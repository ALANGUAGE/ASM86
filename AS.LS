     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9CD1C                  jmp main
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
   276                                  ;-67 #define LABELNAMESMAX 3969//next number - SYMBOLMAX
   277                                  
   278                                  
   279                                  ;-68 char LabelNames[4000];  //space for names of all labels
   280                                  
   281                                  section .bss
   282                                  absolute 30554
   283 0000775A <res 00000FA0>          LabelNames resb 4000
   284                                  section .text
   285                                  
   286                                  ;-69 char *LabelNamePtr;     //first free position
   287                                  
   288 00000046 0000                    LabelNamePtr dw 0
   289                                  
   290                                  ;-70 unsigned int locLabelNamePtr;//set after PROC to LabelNamePtr
   291                                  
   292 00000048 0000                    locLabelNamePtr dw 0
   293                                  
   294                                  ;-71 #define LABELADRMAX 600
   295                                  
   296                                  
   297                                  ;-72 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   298                                  
   299                                  section .bss
   300                                  absolute 34554
   301 000086FA <res 000004B0>          LabelAddr resw 600
   302                                  section .text
   303                                  
   304                                  ;-73 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   305                                  
   306 0000004A 0000                    LabelMaxIx dw 0
   307                                  
   308                                  ;-74 int localLabelMaxIx;    //set after PROC to LabelMaxIx
   309                                  
   310 0000004C 0000                    localLabelMaxIx dw 0
   311                                  
   312                                  ;-75 int LabelIx;            //actual # of just searched label
   313                                  
   314 0000004E 0000                    LabelIx dw 0
   315                                  
   316                                  ;-76 
   317                                  
   318                                  
   319                                  ;-77 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   320                                  
   321                                  
   322                                  ;-78 char JmpCallNames[2000];//space for names of jmp, call
   323                                  
   324                                  section .bss
   325                                  absolute 35754
   326 00008BAA <res 000007D0>          JmpCallNames resb 2000
   327                                  section .text
   328                                  
   329                                  ;-79 char *JmpCallNamePtr;   //first free position
   330                                  
   331 00000050 0000                    JmpCallNamePtr dw 0
   332                                  
   333                                  ;-80 #define JMPCALLMAX 500  //max. jmp and call
   334                                  
   335                                  
   336                                  ;-81 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   337                                  
   338                                  section .bss
   339                                  absolute 37754
   340 0000937A <res 000003E8>          JmpCallAddr resw 500
   341                                  section .text
   342                                  
   343                                  ;-82 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   344                                  
   345 00000052 0000                    JmpCallMaxIx dw 0
   346                                  
   347                                  ;-83 
   348                                  
   349                                  
   350                                  ;-84 #define FILEBINMAX 20000
   351                                  
   352                                  
   353                                  ;-85 char FileBin  [FILEBINMAX];//output binary file
   354                                  
   355                                  section .bss
   356                                  absolute 38754
   357 00009762 <res 00004E20>          FileBin resb 20000
   358                                  section .text
   359                                  
   360                                  ;-86 unsigned int BinLen=0;  //length of binary file
   361                                  
   362 00000054 0000                    BinLen dw 0
   363                                  
   364                                  ;-87 
   365                                  
   366                                  
   367                                  ;-88 char *arglen=0x80;      // for main only
   368                                  
   369 00000056 8000                    arglen dw 128
   370                                  
   371                                  ;-89 char *argv=0x82;        // for main only
   372                                  
   373 00000058 8200                    argv dw 130
   374                                  
   375                                  ;-90 
   376                                  
   377                                  
   378                                  ;-91 
   379                                  
   380                                  
   381                                  ;-92 //#include "OPTABL.C"
   382                                  
   383                                  
   384                                  ;-93 char I_START=0xF1;
   385                                  
   386 0000005A F1                      I_START db 241
   387                                  
   388                                  ;-94 //OpName, 0, CodeType, OpCode1-n, F1h
   389                                  
   390                                  
   391                                  ;-95 //  1:   1 byte opcode
   392                                  
   393                                  
   394                                  ;-96 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};
   395                                  
   396 0000005B 5055534841000160F1-     I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241
   397 00000064 504F5041000161F1   
   398                                  
   399                                  ;-97 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};
   400                                  
   401 0000006C 4E4F50000190F14342-     I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241
   402 00000075 57000198F1         
   403                                  
   404                                  ;-98 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};
   405                                  
   406 0000007A 43574445000198F143-     I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241
   407 00000083 5744000199F1       
   408                                  
   409                                  ;-99 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};
   410                                  
   411 00000089 434451000199F15741-     I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241
   412 00000092 495400019BF1       
   413                                  
   414                                  ;-100 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};
   415                                  
   416 00000098 505553484600019CF1-     I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241
   417 000000A1 504F504600019DF1   
   418                                  
   419                                  ;-101 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};
   420                                  
   421 000000A9 5341484600019EF14C-     I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241
   422 000000B2 41484600019FF1     
   423                                  
   424                                  ;-102 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};
   425                                  
   426 000000B9 4D4F5653420001A4F1-     I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241
   427 000000C2 4D4F5653570001A5F1 
   428                                  
   429                                  ;-103 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};
   430                                  
   431 000000CB 434D5053420001A6F1-     I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241
   432 000000D4 434D5053570001A7F1 
   433                                  
   434                                  ;-104 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};
   435                                  
   436 000000DD 53544F53420001AAF1-     I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241
   437 000000E6 53544F53570001ABF1 
   438                                  
   439                                  ;-105 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};
   440                                  
   441 000000EF 4C4F4453420001ACF1-     I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241
   442 000000F8 4C4F4453570001ADF1 
   443                                  
   444                                  ;-106 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};
   445                                  
   446 00000101 53434153420001AEF1-     I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241
   447 0000010A 53434153570001AFF1 
   448                                  
   449                                  ;-107 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};
   450                                  
   451 00000113 4C454156450001C9F1-     I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241
   452 0000011C 494E54330001CCF1   
   453                                  
   454                                  ;-108 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};
   455                                  
   456 00000124 494E544F0001CEF149-     I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241
   457 0000012D 5245540001CFF1     
   458                                  
   459                                  ;-109 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};
   460                                  
   461 00000134 584C41540001D7F14C-     I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241
   462 0000013D 4F434B0001F0F1     
   463                                  
   464                                  ;-110 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};
   465                                  
   466 00000144 5245504E450001F2F1-     I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241
   467 0000014D 5245504E5A0001F2F1 
   468                                  
   469                                  ;-111 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};
   470                                  
   471 00000156 524550450001F3F152-     I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241
   472 0000015F 45505A0001F3F1     
   473                                  
   474                                  ;-112 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};
   475                                  
   476 00000166 484C540001F4F1434C-     I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241
   477 0000016F 430001F8F1         
   478                                  
   479                                  ;-113 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};
   480                                  
   481 00000174 5354430001F9F1434C-     I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241
   482 0000017D 490001FAF1         
   483                                  
   484                                  ;-114 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};
   485                                  
   486 00000182 5354490001FBF1434C-     I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241
   487 0000018B 440001FCF1         
   488                                  
   489                                  ;-115 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};
   490                                  
   491 00000190 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   492                                  
   493                                  ;-116 // 2: mem reg 16 bit
   494                                  
   495                                  
   496                                  ;-117 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   497                                  
   498 00000197 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   499                                  
   500                                  ;-118 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   501                                  
   502 000001A0 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   503                                  
   504                                  ;-119 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   505                                  
   506 000001A9 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   507                                  
   508                                  ;-120 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   509                                  
   510 000001B1 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   511                                  
   512                                  ;-121 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   513                                  
   514 000001B9 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   515                                  
   516                                  ;-122 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   517                                  
   518 000001C1 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   519                                  
   520                                  ;-123 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   521                                  
   522 000001CA 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   523                                  
   524                                  ;-124 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   525                                  
   526 000001D2 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   527                                  
   528                                  ;-125 //  3: les, lda, lea, lss, lfs, lgs
   529                                  
   530                                  
   531                                  ;-126 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   532                                  
   533 000001DB 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   534                                  
   535                                  ;-127 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   536                                  
   537 000001E2 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   538                                  
   539                                  ;-128 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   540                                  
   541 000001E9 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   542                                  
   543                                  ;-129 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   544                                  
   545 000001F0 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   546                                  
   547                                  ;-130 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   548                                  
   549 000001F8 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   550                                  
   551                                  ;-131 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   552                                  
   553 00000200 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   554                                  
   555                                  ;-132 //  4: acc,imm  reg,imm  index,reg
   556                                  
   557                                  
   558                                  ;-133 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   559                                  
   560 00000208 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   561                                  
   562                                  ;-134 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   563                                  
   564 0000020F 4F52000401F1            I_OR db 79,82,0,4,1,241
   565                                  
   566                                  ;-135 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   567                                  
   568 00000215 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   569                                  
   570                                  ;-136 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   571                                  
   572 0000021C 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   573                                  
   574                                  ;-137 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   575                                  
   576 00000223 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   577                                  
   578                                  ;-138 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   579                                  
   580 0000022A 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   581                                  
   582                                  ;-139 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   583                                  
   584 00000231 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   585                                  
   586                                  ;-140 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   587                                  
   588 00000238 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   589                                  
   590                                  ;-141 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   591                                  
   592 0000023F 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   593 00000248 00F1               
   594                                  
   595                                  ;-142 //  5: mov
   596                                  
   597                                  
   598                                  ;-143 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   599                                  
   600 0000024A 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   601                                  
   602                                  ;-144 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   603                                  
   604 00000250 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   605                                  
   606                                  ;-145 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   607                                  
   608 00000259 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   609                                  
   610                                  ;-146 //  6: single byte relative jump
   611                                  
   612                                  
   613                                  ;-147 char I_JO []=  {'J','O',0,     6, 0,0xF1};
   614                                  
   615 00000262 4A4F000600F1            I_JO db 74,79,0,6,0,241
   616                                  
   617                                  ;-148 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
   618                                  
   619 00000268 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   620                                  
   621                                  ;-149 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
   622                                  
   623 0000026F 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
   624 00000278 0602F1             
   625                                  
   626                                  ;-150 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
   627                                  
   628 0000027B 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   629                                  
   630                                  ;-151 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
   631                                  
   632 00000282 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
   633 0000028B 43000603F1         
   634                                  
   635                                  ;-152 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
   636                                  
   637 00000290 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
   638 00000299 0604F1             
   639                                  
   640                                  ;-153 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
   641                                  
   642 0000029C 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
   643 000002A5 5A000605F1         
   644                                  
   645                                  ;-154 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
   646                                  
   647 000002AA 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
   648 000002B3 41000606F1         
   649                                  
   650                                  ;-155 char I_JA []=  {'J','A',0,     6, 7,0xF1};
   651                                  
   652 000002B8 4A41000607F1            I_JA db 74,65,0,6,7,241
   653                                  
   654                                  ;-156 char I_JS []=  {'J','S',0,     6, 8,0xF1};
   655                                  
   656 000002BE 4A53000608F1            I_JS db 74,83,0,6,8,241
   657                                  
   658                                  ;-157 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
   659                                  
   660 000002C4 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   661                                  
   662                                  ;-158 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
   663                                  
   664 000002CB 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
   665 000002D4 00060AF1           
   666                                  
   667                                  ;-159 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
   668                                  
   669 000002D8 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
   670 000002E1 4F00060BF1         
   671                                  
   672                                  ;-160 char I_JL []=  {'J','L',0,     6,12,0xF1};
   673                                  
   674 000002E6 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   675                                  
   676                                  ;-161 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
   677                                  
   678 000002EC 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
   679 000002F5 4500060DF1         
   680                                  
   681                                  ;-162 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
   682                                  
   683 000002FA 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
   684 00000303 4700060EF1         
   685                                  
   686                                  ;-163 char I_JG []=  {'J','G',0,     6,15,0xF1};
   687                                  
   688 00000308 4A4700060FF1            I_JG db 74,71,0,6,15,241
   689                                  
   690                                  ;-164 //  7: jmp, call
   691                                  
   692                                  
   693                                  ;-165 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   694                                  
   695 0000030E 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   696                                  
   697                                  ;-166 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   698                                  
   699 00000316 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   700                                  
   701                                  ;-167 //  8: ret
   702                                  
   703                                  
   704                                  ;-168 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   705                                  
   706 0000031F 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   707                                  
   708                                  ;-169 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   709                                  
   710 00000327 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   711                                  
   712                                  ;-170 //  9: seg, r/m
   713                                  
   714                                  
   715                                  ;-171 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   716                                  
   717 00000330 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   718 00000339 06F1               
   719                                  
   720                                  ;-172 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   721                                  
   722 0000033B 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   723 00000344 F1                 
   724                                  
   725                                  ;-173 //  11: shift, rotates
   726                                  
   727                                  
   728                                  ;-174 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
   729                                  
   730 00000345 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
   731 0000034E 52000B01F1         
   732                                  
   733                                  ;-175 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
   734                                  
   735 00000353 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
   736 0000035C 52000B03F1         
   737                                  
   738                                  ;-176 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
   739                                  
   740 00000361 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
   741 0000036A 4C000B04F1         
   742                                  
   743                                  ;-177 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
   744                                  
   745 0000036F 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
   746 00000378 52000B07F1         
   747                                  
   748                                  ;-178 //  12: int
   749                                  
   750                                  
   751                                  ;-179 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   752                                  
   753 0000037D 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   754                                  
   755                                  ;-180 //  14: in/out
   756                                  
   757                                  
   758                                  ;-181 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   759                                  
   760 00000385 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   761                                  
   762                                  ;-182 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   763                                  
   764 0000038C 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   765                                  
   766                                  ;-183 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   767                                  
   768 00000394 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   769                                  
   770                                  ;-184 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   771                                  
   772 0000039C 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   773                                  
   774                                  ;-185 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   775                                  
   776 000003A4 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   777                                  
   778                                  ;-186 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   779                                  
   780 000003AC 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   781                                  
   782                                  ;-187 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   783                                  
   784 000003B4 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   785                                  
   786                                  ;-188 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   787                                  
   788 000003BC 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   789                                  
   790                                  ;-189 //  15: xchg
   791                                  
   792                                  
   793                                  ;-190 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   794                                  
   795 000003C4 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   796                                  
   797                                  ;-191 //  16: loop, jcxz
   798                                  
   799                                  
   800                                  ;-192 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   801                                  
   802 000003CD 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   803 000003D6 F1                 
   804                                  
   805                                  ;-193 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   806                                  
   807 000003D7 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   808 000003E0 F1                 
   809                                  
   810                                  ;-194 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   811                                  
   812 000003E1 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   813                                  
   814                                  ;-195 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   815                                  
   816 000003EA 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   817                                  
   818                                  ;-196 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   819                                  
   820 000003F3 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   821                                  
   822                                  ;-197 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   823                                  
   824 000003FB 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   825                                  
   826                                  ;-198 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   827                                  
   828 00000403 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   829                                  
   830                                  ;-199 //  30: enter
   831                                  
   832                                  
   833                                  ;-200 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
   834                                  
   835 0000040C 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   836                                  
   837                                  ;-201 // 100: directives
   838                                  
   839                                  
   840                                  ;-202 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   841                                  
   842 00000414 4F52470065F1            I_ORG db 79,82,71,0,101,241
   843                                  
   844                                  ;-203 // section, segment .TEXT .DATA .BSS
   845                                  
   846                                  
   847                                  ;-204 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   848                                  
   849 0000041A 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   850 00000423 F1                 
   851                                  
   852                                  ;-205 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   853                                  
   854 00000424 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   855 0000042D F1                 
   856                                  
   857                                  ;-206 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   858                                  
   859 0000042E 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   860 00000437 6EF1               
   861                                  
   862                                  ;-207 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
   863                                  
   864 00000439 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
   865                                  
   866                                  ;-208 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
   867                                  
   868 00000440 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
   869                                  
   870                                  ;-209 char I_DB[]=   {'D','B',0,            200,        0xF1};
   871                                  
   872 00000447 444200C8F1              I_DB db 68,66,0,200,241
   873                                  
   874                                  ;-210 char I_DW[]=   {'D','W',0,            201,        0xF1};
   875                                  
   876 0000044C 445700C9F1              I_DW db 68,87,0,201,241
   877                                  
   878                                  ;-211 char I_DD[]=   {'D','D',0,            202,        0xF1};
   879                                  
   880 00000451 444400CAF1              I_DD db 68,68,0,202,241
   881                                  
   882                                  ;-212 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   883                                  
   884 00000456 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   885                                  
   886                                  ;-213 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   887                                  
   888 0000045D 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   889                                  
   890                                  ;-214 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   891                                  
   892 00000464 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   893                                  
   894                                  ;-215 char I_END=0;// end of table char
   895                                  
   896 0000046B 00                      I_END db 0
   897                                  
   898                                  ;-216 
   899                                  
   900                                  
   901                                  ;-217 
   902                                  
   903                                  
   904                                  ;-218 //#include "OPS.C"
   905                                  
   906                                  
   907                                  ;-219 int ChangeDirection() {
   908                                  
   909                                  
   910                                  ChangeDirection: PROC
   911                                  
   912                                  ;-220     char c;
   913                                  
   914                                  
   915                                  ;-221     c=Op;     Op    =Op2;    Op2   =c;
   916                                  
   917                                  ;Function : ChangeDirection, Number of local variables: 1
   918                                  ;   # type sign width addr used name   list of local variables
   919                                  ;  200 var sign byte   220 NULL c = bp-2;
   920 0000046C C8020000                 ENTER  2,0
   921 00000470 A0[2D00]                 mov al, [Op]
   922 00000473 8846FE                   mov [bp-2], al
   923 00000476 A0[2E00]                 mov al, [Op2]
   924 00000479 A2[2D00]                 mov byte [Op], al
   925 0000047C 8A46FE                   mov al, [bp-2]
   926 0000047F A2[2E00]                 mov byte [Op2], al
   927                                  
   928                                  ;-222     c=R1Type; R1Type=R2Type; R2Type=c;
   929                                  
   930 00000482 A0[3600]                 mov al, [R1Type]
   931 00000485 8846FE                   mov [bp-2], al
   932 00000488 A0[3500]                 mov al, [R2Type]
   933 0000048B A2[3600]                 mov byte [R1Type], al
   934 0000048E 8A46FE                   mov al, [bp-2]
   935 00000491 A2[3500]                 mov byte [R2Type], al
   936                                  
   937                                  ;-223     c=R1No;   R1No  =R2No;   R2No  =c;
   938                                  
   939 00000494 A0[3400]                 mov al, [R1No]
   940 00000497 8846FE                   mov [bp-2], al
   941 0000049A A0[3300]                 mov al, [R2No]
   942 0000049D A2[3400]                 mov byte [R1No], al
   943 000004A0 8A46FE                   mov al, [bp-2]
   944 000004A3 A2[3300]                 mov byte [R2No], al
   945                                  
   946                                  ;-224     dflag=2;
   947                                  
   948 000004A6 B80200                   mov ax, 2
   949 000004A9 A2[3900]                 mov byte [dflag], al
   950                                  
   951                                  ;-225 }
   952                                  
   953                                  
   954                                  ;-226 
   955                                  
   956                                  
   957                                  ;-227 int checkOpL() {
   958 000004AC C9                       LEAVE
   959 000004AD C3                       ret
   960                                  ENDP
   961                                  
   962                                  checkOpL: PROC
   963                                  
   964                                  ;-228     if (Op == ADR) implerror();
   965                                  
   966 000004AE A0[2D00]                 mov al, [Op]
   967 000004B1 3C03                     cmp al, 3
   968 000004B3 0F850300                 jne .checkOpL1
   969 000004B7 E8B416                   call implerror
   970                                  
   971                                  ;-229     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   972                                  
   973                                  .checkOpL1:
   974 000004BA A0[3600]                 mov al, [R1Type]
   975 000004BD 3C04                     cmp al, 4
   976 000004BF 0F850600                 jne .checkOpL2
   977 000004C3 E87017                   call segregerror
   978 000004C6 E93E00                   jmp .retncheckOpL
   979                                  
   980                                  ;-230     setwflag();
   981                                  
   982                                  .checkOpL2:
   983 000004C9 E88C03                   call setwflag
   984                                  
   985                                  ;-231     if (OpSize == 0) error1("no op size declared");
   986                                  
   987 000004CC A0[3700]                 mov al, [OpSize]
   988 000004CF 3C00                     cmp al, 0
   989 000004D1 0F850900                 jne .checkOpL3
   990 000004D5 68[0805]                 push checkOpL_0
   991 000004D8 E8C915                   call error1
   992 000004DB 83C402                   add  sp, 2
   993                                  
   994                                  ;-232     if (OpSize == R1Type) return;
   995                                  
   996                                  .checkOpL3:
   997 000004DE A0[3700]                 mov al, [OpSize]
   998 000004E1 3A06[3600]               cmp al, [R1Type]
   999 000004E5 0F850300                 jne .checkOpL4
  1000 000004E9 E91B00                   jmp .retncheckOpL
  1001                                  
  1002                                  ;-233     if (Op == REG) if (R1Type==0) error1("no register defined");
  1003                                  
  1004                                  .checkOpL4:
  1005 000004EC A0[2D00]                 mov al, [Op]
  1006 000004EF 3C02                     cmp al, 2
  1007 000004F1 0F851200                 jne .checkOpL5
  1008 000004F5 A0[3600]                 mov al, [R1Type]
  1009 000004F8 3C00                     cmp al, 0
  1010 000004FA 0F850900                 jne .checkOpL6
  1011 000004FE 68[1C05]                 push checkOpL_1
  1012 00000501 E8A015                   call error1
  1013 00000504 83C402                   add  sp, 2
  1014                                  
  1015                                  ;-234 }
  1016                                  
  1017                                  .checkOpL6:
  1018                                  .checkOpL5:
  1019                                  
  1020                                  ;-235 
  1021                                  
  1022                                  
  1023                                  ;-236 int check2Ops() {
  1024                                  
  1025                                   .retncheckOpL:
  1026 00000507 C3                       ret
  1027 00000508 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1028 00000511 65206465636C617265-
  1029 0000051A 6400               
  1030 0000051C 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1031 00000525 657220646566696E65-
  1032 0000052E 6400               
  1033                                  ENDP
  1034                                  
  1035                                  check2Ops: PROC
  1036                                  
  1037                                  ;-237     get2Ops();
  1038                                  
  1039 00000530 E84900                   call get2Ops
  1040                                  
  1041                                  ;-238     if (Op ==   0) addrerror();
  1042                                  
  1043 00000533 A0[2D00]                 mov al, [Op]
  1044 00000536 3C00                     cmp al, 0
  1045 00000538 0F850300                 jne .check2Ops7
  1046 0000053C E8F015                   call addrerror
  1047                                  
  1048                                  ;-239     if (Op == ADR) invaloperror();
  1049                                  
  1050                                  .check2Ops7:
  1051 0000053F A0[2D00]                 mov al, [Op]
  1052 00000542 3C03                     cmp al, 3
  1053 00000544 0F850300                 jne .check2Ops8
  1054 00000548 E85E16                   call invaloperror
  1055                                  
  1056                                  ;-240     if (Op == IMM) immeerror();
  1057                                  
  1058                                  .check2Ops8:
  1059 0000054B A0[2D00]                 mov al, [Op]
  1060 0000054E 3C01                     cmp al, 1
  1061 00000550 0F850300                 jne .check2Ops9
  1062 00000554 E8F215                   call immeerror
  1063                                  
  1064                                  ;-241     if (Op2==   0) addrerror();
  1065                                  
  1066                                  .check2Ops9:
  1067 00000557 A0[2E00]                 mov al, [Op2]
  1068 0000055A 3C00                     cmp al, 0
  1069 0000055C 0F850300                 jne .check2Ops10
  1070 00000560 E8CC15                   call addrerror
  1071                                  
  1072                                  ;-242     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov
  1073                                  
  1074                                  .check2Ops10:
  1075 00000563 A0[2F00]                 mov al, [CodeType]
  1076 00000566 3C05                     cmp al, 5
  1077 00000568 0F840C00                 je  .check2Ops11
  1078 0000056C A0[2E00]                 mov al, [Op2]
  1079 0000056F 3C03                     cmp al, 3
  1080 00000571 0F850300                 jne .check2Ops12
  1081 00000575 E83116                   call invaloperror
  1082                                  
  1083                                  ;-243     setwflag();
  1084                                  
  1085                                  .check2Ops12:
  1086                                  .check2Ops11:
  1087 00000578 E8DD02                   call setwflag
  1088                                  
  1089                                  ;-244 }
  1090                                  
  1091                                  
  1092                                  ;-245 int get2Ops() {
  1093                                  
  1094 0000057B C3                       ret
  1095                                  ENDP
  1096                                  
  1097                                  get2Ops: PROC
  1098                                  
  1099                                  ;-246     getOpL();
  1100                                  
  1101 0000057C E80C00                   call getOpL
  1102                                  
  1103                                  ;-247     need(',');
  1104                                  
  1105 0000057F 6A2C                     push 44
  1106 00000581 E89D09                   call need
  1107 00000584 83C402                   add  sp, 2
  1108                                  
  1109                                  ;-248     getOpR();
  1110                                  
  1111 00000587 E82900                   call getOpR
  1112                                  
  1113                                  ;-249 }
  1114                                  
  1115                                  
  1116                                  ;-250 
  1117                                  
  1118                                  
  1119                                  ;-251 int getOpL() {
  1120                                  
  1121 0000058A C3                       ret
  1122                                  ENDP
  1123                                  
  1124                                  getOpL: PROC
  1125                                  
  1126                                  ;-252 //set: op=0,IMM,REG,ADR,MEM
  1127                                  
  1128                                  
  1129                                  ;-253     getOpR();
  1130                                  
  1131 0000058B E82500                   call getOpR
  1132                                  
  1133                                  ;-254     Op=Op2;         Op2=0;
  1134                                  
  1135 0000058E A0[2E00]                 mov al, [Op2]
  1136 00000591 A2[2D00]                 mov byte [Op], al
  1137 00000594 B80000                   mov ax, 0
  1138 00000597 A2[2E00]                 mov byte [Op2], al
  1139                                  
  1140                                  ;-255     R1No=R2No;      R2No=0;
  1141                                  
  1142 0000059A A0[3300]                 mov al, [R2No]
  1143 0000059D A2[3400]                 mov byte [R1No], al
  1144 000005A0 B80000                   mov ax, 0
  1145 000005A3 A2[3300]                 mov byte [R2No], al
  1146                                  
  1147                                  ;-256     R1Type=R2Type; R2Type=0;
  1148                                  
  1149 000005A6 A0[3500]                 mov al, [R2Type]
  1150 000005A9 A2[3600]                 mov byte [R1Type], al
  1151 000005AC B80000                   mov ax, 0
  1152 000005AF A2[3500]                 mov byte [R2Type], al
  1153                                  
  1154                                  ;-257 }
  1155                                  
  1156                                  
  1157                                  ;-258 
  1158                                  
  1159                                  
  1160                                  ;-259 int getOpR() {
  1161                                  
  1162 000005B2 C3                       ret
  1163                                  ENDP
  1164                                  
  1165                                  getOpR: PROC
  1166                                  
  1167                                  ;-260     Op2=getOp1();
  1168                                  
  1169 000005B3 E88600                   call getOp1
  1170 000005B6 A2[2E00]                 mov byte [Op2], al
  1171                                  
  1172                                  ;-261     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1173                                  
  1174 000005B9 6A5B                     push 91
  1175 000005BB E83B09                   call isToken
  1176 000005BE 83C402                   add  sp, 2
  1177 000005C1 08C0                     or  al, al
  1178 000005C3 0F840C00                 je .getOpR13
  1179 000005C7 B80400                   mov ax, 4
  1180 000005CA A2[2E00]                 mov byte [Op2], al
  1181 000005CD E8E300                   call getMEM
  1182 000005D0 E94F00                   jmp .retngetOpR
  1183                                  
  1184                                  ;-262     if (Op2 == 0)     {invaloperror();         return;}
  1185                                  
  1186                                  .getOpR13:
  1187 000005D3 A0[2E00]                 mov al, [Op2]
  1188 000005D6 3C00                     cmp al, 0
  1189 000005D8 0F850600                 jne .getOpR14
  1190 000005DC E8CA15                   call invaloperror
  1191 000005DF E94000                   jmp .retngetOpR
  1192                                  
  1193                                  ;-263     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1194                                  
  1195                                  .getOpR14:
  1196 000005E2 A0[2E00]                 mov al, [Op2]
  1197 000005E5 3C01                     cmp al, 1
  1198 000005E7 0F850900                 jne .getOpR15
  1199 000005EB A1[0E00]                 mov ax, [SymbolInt]
  1200 000005EE A3[3F00]                 mov word [imme], ax
  1201 000005F1 E92E00                   jmp .retngetOpR
  1202                                  
  1203                                  ;-264     if (Op2 == REG)                            return;
  1204                                  
  1205                                  .getOpR15:
  1206 000005F4 A0[2E00]                 mov al, [Op2]
  1207 000005F7 3C02                     cmp al, 2
  1208 000005F9 0F850300                 jne .getOpR16
  1209 000005FD E92200                   jmp .retngetOpR
  1210                                  
  1211                                  ;-265     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1212                                  
  1213                                  .getOpR16:
  1214 00000600 A0[2E00]                 mov al, [Op2]
  1215 00000603 3C03                     cmp al, 3
  1216 00000605 0F851000                 jne .getOpR17
  1217 00000609 8B1E[4E00]               mov bx, [LabelIx]
  1218 0000060D D1E3                     shl bx, 1
  1219 0000060F 8B87FA86                 mov ax, [LabelAddr + bx]
  1220 00000613 A3[3D00]                 mov word [disp], ax
  1221 00000616 E90900                   jmp .retngetOpR
  1222                                  
  1223                                  ;-266     error1("Name of operand expected");
  1224                                  
  1225                                  .getOpR17:
  1226 00000619 68[2306]                 push getOpR_0
  1227 0000061C E88514                   call error1
  1228 0000061F 83C402                   add  sp, 2
  1229                                  
  1230                                  ;-267 }
  1231                                  
  1232                                  
  1233                                  ;-268 
  1234                                  
  1235                                  
  1236                                  ;-269 int getOp1() {//scan for a single operand
  1237                                  
  1238                                   .retngetOpR:
  1239 00000622 C3                       ret
  1240 00000623 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1241 0000062C 706572616E64206578-
  1242 00000635 70656374656400     
  1243                                  ENDP
  1244                                  
  1245                                  getOp1: PROC
  1246                                  
  1247                                  ;-270 //return:0, IMM, REG, ADR (not MEM)
  1248                                  
  1249                                  
  1250                                  ;-271 //set   :R2Type, R2No by testReg
  1251                                  
  1252                                  
  1253                                  ;-272 //set   :LabelIx by searchLabel
  1254                                  
  1255                                  
  1256                                  ;-273     if (TokeType == 0)      return 0;
  1257                                  
  1258 0000063C A0[2C00]                 mov al, [TokeType]
  1259 0000063F 3C00                     cmp al, 0
  1260 00000641 0F850600                 jne .getOp118
  1261 00000645 B80000                   mov ax, 0
  1262 00000648 E95400                   jmp .retngetOp1
  1263                                  
  1264                                  ;-274     if (TokeType == DIGIT)  return IMM;
  1265                                  
  1266                                  .getOp118:
  1267 0000064B A0[2C00]                 mov al, [TokeType]
  1268 0000064E 3C01                     cmp al, 1
  1269 00000650 0F850600                 jne .getOp119
  1270 00000654 B80100                   mov ax, 1
  1271 00000657 E94500                   jmp .retngetOp1
  1272                                  
  1273                                  ;-275     if (TokeType == ALNUME) {
  1274                                  
  1275                                  .getOp119:
  1276 0000065A A0[2C00]                 mov al, [TokeType]
  1277 0000065D 3C03                     cmp al, 3
  1278 0000065F 0F853600                 jne .getOp120
  1279                                  
  1280                                  ;-276         R2No=testReg();
  1281                                  
  1282 00000663 E8240E                   call testReg
  1283 00000666 A2[3300]                 mov byte [R2No], al
  1284                                  
  1285                                  ;-277         if (R2Type)        return REG;
  1286                                  
  1287 00000669 A0[3500]                 mov al, [R2Type]
  1288 0000066C 08C0                     or  al, al
  1289 0000066E 0F840600                 je .getOp121
  1290 00000672 B80200                   mov ax, 2
  1291 00000675 E92700                   jmp .retngetOp1
  1292                                  
  1293                                  ;-278         LabelIx=searchLabel();
  1294                                  
  1295                                  .getOp121:
  1296 00000678 E8A305                   call searchLabel
  1297 0000067B A3[4E00]                 mov word [LabelIx], ax
  1298                                  
  1299                                  ;-279         if (LabelIx)        return ADR;
  1300                                  
  1301 0000067E A1[4E00]                 mov ax, [LabelIx]
  1302 00000681 08C0                     or  al, al
  1303 00000683 0F840900                 je .getOp122
  1304 00000687 B80300                   mov ax, 3
  1305 0000068A E91200                   jmp .retngetOp1
  1306                                  
  1307                                  ;-280         else error1("variable not found");
  1308                                  
  1309 0000068D E90900                   jmp .getOp123
  1310                                  .getOp122:
  1311 00000690 68[A006]                 push getOp1_0
  1312 00000693 E80E14                   call error1
  1313 00000696 83C402                   add  sp, 2
  1314                                  
  1315                                  ;-281     }
  1316                                  
  1317                                  .getOp123:
  1318                                  
  1319                                  ;-282     return 0;
  1320                                  
  1321                                  .getOp120:
  1322 00000699 B80000                   mov ax, 0
  1323 0000069C E90000                   jmp .retngetOp1
  1324                                  
  1325                                  ;-283 }
  1326                                  
  1327                                  
  1328                                  ;-284 
  1329                                  
  1330                                  
  1331                                  ;-285 int getMEM() {// e.g. [array+bp+si-4]
  1332                                  
  1333                                   .retngetOp1:
  1334 0000069F C3                       ret
  1335 000006A0 7661726961626C6520-     getOp1_0 db "variable not found",0
  1336 000006A9 6E6F7420666F756E64-
  1337 000006B2 00                 
  1338                                  ENDP
  1339                                  
  1340                                  getMEM: PROC
  1341                                  
  1342                                  ;-286 //set: disp, rm, R2Type
  1343                                  
  1344                                  
  1345                                  ;-287     char c;
  1346                                  
  1347                                  
  1348                                  ;-288     disp=0; rm=0;
  1349                                  
  1350                                  ;Function : getMEM, Number of local variables: 1
  1351                                  ;   # type sign width addr used name   list of local variables
  1352                                  ;  200 var sign byte   287 NULL c = bp-2;
  1353 000006B3 C8020000                 ENTER  2,0
  1354 000006B7 B80000                   mov ax, 0
  1355 000006BA A3[3D00]                 mov word [disp], ax
  1356 000006BD B80000                   mov ax, 0
  1357 000006C0 A2[3B00]                 mov byte [rm], al
  1358                                  
  1359                                  ;-289     do {
  1360                                  
  1361                                  .getMEM24:
  1362                                  
  1363                                  ;-290         getTokeType();
  1364                                  
  1365 000006C3 E8A003                   call getTokeType
  1366                                  
  1367                                  ;-291         c=getOp1();
  1368                                  
  1369 000006C6 E873FF                   call getOp1
  1370 000006C9 8846FE                   mov [bp-2], al
  1371                                  
  1372                                  ;-292         if (c ==   0) syntaxerror();
  1373                                  
  1374 000006CC 8A46FE                   mov al, [bp-2]
  1375 000006CF 3C00                     cmp al, 0
  1376 000006D1 0F850300                 jne .getMEM25
  1377 000006D5 E88515                   call syntaxerror
  1378                                  
  1379                                  ;-293         if (c == REG) {
  1380                                  
  1381                                  .getMEM25:
  1382 000006D8 8A46FE                   mov al, [bp-2]
  1383 000006DB 3C02                     cmp al, 2
  1384 000006DD 0F851B00                 jne .getMEM26
  1385                                  
  1386                                  ;-294             isDirect=0;
  1387                                  
  1388 000006E1 B80000                   mov ax, 0
  1389 000006E4 A2[3C00]                 mov byte [isDirect], al
  1390                                  
  1391                                  ;-295             if (rm) rm=getIndReg2();
  1392                                  
  1393 000006E7 A0[3B00]                 mov al, [rm]
  1394 000006EA 08C0                     or  al, al
  1395 000006EC 0F840900                 je .getMEM27
  1396 000006F0 E8E700                   call getIndReg2
  1397 000006F3 A2[3B00]                 mov byte [rm], al
  1398                                  
  1399                                  ;-296             else getIndReg1();
  1400                                  
  1401 000006F6 E90300                   jmp .getMEM28
  1402                                  .getMEM27:
  1403 000006F9 E88900                   call getIndReg1
  1404                                  
  1405                                  ;-297         }
  1406                                  
  1407                                  .getMEM28:
  1408                                  
  1409                                  ;-298         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1410                                  
  1411                                  .getMEM26:
  1412 000006FC 8A46FE                   mov al, [bp-2]
  1413 000006FF 3C03                     cmp al, 3
  1414 00000701 0F851000                 jne .getMEM29
  1415 00000705 A1[3D00]                 mov ax, [disp]
  1416 00000708 8B1E[4E00]               mov bx, [LabelIx]
  1417 0000070C D1E3                     shl bx, 1
  1418 0000070E 0387FA86                 add ax, [LabelAddr + bx]
  1419 00000712 A3[3D00]                 mov word [disp], ax
  1420                                  
  1421                                  ;-299         if (c == IMM) disp=disp+SymbolInt;
  1422                                  
  1423                                  .getMEM29:
  1424 00000715 8A46FE                   mov al, [bp-2]
  1425 00000718 3C01                     cmp al, 1
  1426 0000071A 0F850A00                 jne .getMEM30
  1427 0000071E A1[3D00]                 mov ax, [disp]
  1428 00000721 0306[0E00]               add ax, [SymbolInt]
  1429 00000725 A3[3D00]                 mov word [disp], ax
  1430                                  
  1431                                  ;-300         if (isToken('-')) {
  1432                                  
  1433                                  .getMEM30:
  1434 00000728 6A2D                     push 45
  1435 0000072A E8CC07                   call isToken
  1436 0000072D 83C402                   add  sp, 2
  1437 00000730 08C0                     or  al, al
  1438 00000732 0F841900                 je .getMEM31
  1439                                  
  1440                                  ;-301             getTokeType();
  1441                                  
  1442 00000736 E82D03                   call getTokeType
  1443                                  
  1444                                  ;-302             if (TokeType != DIGIT) numbererror();
  1445                                  
  1446 00000739 A0[2C00]                 mov al, [TokeType]
  1447 0000073C 3C01                     cmp al, 1
  1448 0000073E 0F840300                 je  .getMEM32
  1449 00000742 E88514                   call numbererror
  1450                                  
  1451                                  ;-303             disp = disp - SymbolInt;
  1452                                  
  1453                                  .getMEM32:
  1454 00000745 A1[3D00]                 mov ax, [disp]
  1455 00000748 2B06[0E00]               sub ax, [SymbolInt]
  1456 0000074C A3[3D00]                 mov word [disp], ax
  1457                                  
  1458                                  ;-304         }
  1459                                  
  1460                                  
  1461                                  ;-305     } while (isToken('+'));
  1462                                  
  1463                                  .getMEM31:
  1464 0000074F 6A2B                     push 43
  1465 00000751 E8A507                   call isToken
  1466 00000754 83C402                   add  sp, 2
  1467 00000757 08C0                     or  al, al
  1468 00000759 0F840300                 je .getMEM33
  1469 0000075D E963FF                   jmp .getMEM24
  1470                                  .getMEM33:
  1471                                  
  1472                                  ;-306     if (isToken(']') == 0) errorexit("] expected");
  1473                                  
  1474 00000760 6A5D                     push 93
  1475 00000762 E89407                   call isToken
  1476 00000765 83C402                   add  sp, 2
  1477 00000768 83F800                   cmp ax, 0
  1478 0000076B 0F850900                 jne .getMEM34
  1479 0000076F 68[7A07]                 push getMEM_0
  1480 00000772 E88513                   call errorexit
  1481 00000775 83C402                   add  sp, 2
  1482                                  
  1483                                  ;-307 }
  1484                                  
  1485                                  .getMEM34:
  1486                                  
  1487                                  ;-308 int getIndReg1() {
  1488 00000778 C9                       LEAVE
  1489 00000779 C3                       ret
  1490 0000077A 5D2065787065637465-     getMEM_0 db "] expected",0
  1491 00000783 6400               
  1492                                  ENDP
  1493                                  
  1494                                  getIndReg1: PROC
  1495                                  
  1496                                  ;-309     if (R2Type !=WORD) indexerror();
  1497                                  
  1498 00000785 A0[3500]                 mov al, [R2Type]
  1499 00000788 3C02                     cmp al, 2
  1500 0000078A 0F840300                 je  .getIndReg135
  1501 0000078E E8F713                   call indexerror
  1502                                  
  1503                                  ;-310     if (R2No==3) rm=7;//BX
  1504                                  
  1505                                  .getIndReg135:
  1506 00000791 A0[3300]                 mov al, [R2No]
  1507 00000794 3C03                     cmp al, 3
  1508 00000796 0F850600                 jne .getIndReg136
  1509 0000079A B80700                   mov ax, 7
  1510 0000079D A2[3B00]                 mov byte [rm], al
  1511                                  
  1512                                  ;-311     if (R2No==5) rm=6;//BP, change to BP+0
  1513                                  
  1514                                  .getIndReg136:
  1515 000007A0 A0[3300]                 mov al, [R2No]
  1516 000007A3 3C05                     cmp al, 5
  1517 000007A5 0F850600                 jne .getIndReg137
  1518 000007A9 B80600                   mov ax, 6
  1519 000007AC A2[3B00]                 mov byte [rm], al
  1520                                  
  1521                                  ;-312     if (R2No==7) rm=5;//DI
  1522                                  
  1523                                  .getIndReg137:
  1524 000007AF A0[3300]                 mov al, [R2No]
  1525 000007B2 3C07                     cmp al, 7
  1526 000007B4 0F850600                 jne .getIndReg138
  1527 000007B8 B80500                   mov ax, 5
  1528 000007BB A2[3B00]                 mov byte [rm], al
  1529                                  
  1530                                  ;-313     if (R2No==6) rm=4;//SI
  1531                                  
  1532                                  .getIndReg138:
  1533 000007BE A0[3300]                 mov al, [R2No]
  1534 000007C1 3C06                     cmp al, 6
  1535 000007C3 0F850600                 jne .getIndReg139
  1536 000007C7 B80400                   mov ax, 4
  1537 000007CA A2[3B00]                 mov byte [rm], al
  1538                                  
  1539                                  ;-314     if (rm==0) indexerror();
  1540                                  
  1541                                  .getIndReg139:
  1542 000007CD A0[3B00]                 mov al, [rm]
  1543 000007D0 3C00                     cmp al, 0
  1544 000007D2 0F850300                 jne .getIndReg140
  1545 000007D6 E8AF13                   call indexerror
  1546                                  
  1547                                  ;-315 }
  1548                                  
  1549                                  .getIndReg140:
  1550                                  
  1551                                  ;-316 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1552                                  
  1553 000007D9 C3                       ret
  1554                                  ENDP
  1555                                  
  1556                                  getIndReg2: PROC
  1557                                  ;Function : getIndReg2, Number of local variables: 1
  1558                                  ;   # type sign width addr used name   list of local variables
  1559                                  ;  200 var sign byte   316 NULL m = bp-2;
  1560 000007DA C8020000                 ENTER  2,0
  1561 000007DE B80400                   mov ax, 4
  1562 000007E1 8846FE                   mov [bp-2], al
  1563                                  
  1564                                  ;-317     if (R2Type !=WORD) indexerror();
  1565                                  
  1566 000007E4 A0[3500]                 mov al, [R2Type]
  1567 000007E7 3C02                     cmp al, 2
  1568 000007E9 0F840300                 je  .getIndReg241
  1569 000007ED E89813                   call indexerror
  1570                                  
  1571                                  ;-318     if (R2No==7) if (rm==6) m=3;//BP+DI
  1572                                  
  1573                                  .getIndReg241:
  1574 000007F0 A0[3300]                 mov al, [R2No]
  1575 000007F3 3C07                     cmp al, 7
  1576 000007F5 0F852100                 jne .getIndReg242
  1577 000007F9 A0[3B00]                 mov al, [rm]
  1578 000007FC 3C06                     cmp al, 6
  1579 000007FE 0F850900                 jne .getIndReg243
  1580 00000802 B80300                   mov ax, 3
  1581 00000805 8846FE                   mov [bp-2], al
  1582                                  
  1583                                  ;-319              else if (rm==7) m=1;//BX+DI
  1584                                  
  1585 00000808 E90F00                   jmp .getIndReg244
  1586                                  .getIndReg243:
  1587 0000080B A0[3B00]                 mov al, [rm]
  1588 0000080E 3C07                     cmp al, 7
  1589 00000810 0F850600                 jne .getIndReg245
  1590 00000814 B80100                   mov ax, 1
  1591 00000817 8846FE                   mov [bp-2], al
  1592                                  
  1593                                  ;-320     if (R2No==6) if (rm==6) m=2;//BP+SI
  1594                                  
  1595                                  .getIndReg245:
  1596                                  .getIndReg244:
  1597                                  .getIndReg242:
  1598 0000081A A0[3300]                 mov al, [R2No]
  1599 0000081D 3C06                     cmp al, 6
  1600 0000081F 0F852100                 jne .getIndReg246
  1601 00000823 A0[3B00]                 mov al, [rm]
  1602 00000826 3C06                     cmp al, 6
  1603 00000828 0F850900                 jne .getIndReg247
  1604 0000082C B80200                   mov ax, 2
  1605 0000082F 8846FE                   mov [bp-2], al
  1606                                  
  1607                                  ;-321              else if (rm==7) m=0;//BX+SI
  1608                                  
  1609 00000832 E90F00                   jmp .getIndReg248
  1610                                  .getIndReg247:
  1611 00000835 A0[3B00]                 mov al, [rm]
  1612 00000838 3C07                     cmp al, 7
  1613 0000083A 0F850600                 jne .getIndReg249
  1614 0000083E B80000                   mov ax, 0
  1615 00000841 8846FE                   mov [bp-2], al
  1616                                  
  1617                                  ;-322     if (m > 3) indexerror();
  1618                                  
  1619                                  .getIndReg249:
  1620                                  .getIndReg248:
  1621                                  .getIndReg246:
  1622 00000844 8A46FE                   mov al, [bp-2]
  1623 00000847 3C03                     cmp al, 3
  1624 00000849 0F8E0300                 jle .getIndReg250
  1625 0000084D E83813                   call indexerror
  1626                                  
  1627                                  ;-323     return m;
  1628                                  
  1629                                  .getIndReg250:
  1630 00000850 8A46FE                   mov al, [bp-2]
  1631 00000853 E90000                   jmp .retngetIndReg2
  1632                                  
  1633                                  ;-324 }
  1634                                  
  1635                                  
  1636                                  ;-325 
  1637                                  
  1638                                  
  1639                                  ;-326 int setwflag() {//word size, bit 0
  1640                                  
  1641 00000856 C9                       .retngetIndReg2: LEAVE
  1642 00000857 C3                       ret
  1643                                  ENDP
  1644                                  
  1645                                  setwflag: PROC
  1646                                  
  1647                                  ;-327     wflag=0;
  1648                                  
  1649 00000858 B80000                   mov ax, 0
  1650 0000085B A2[3800]                 mov byte [wflag], al
  1651                                  
  1652                                  ;-328     if (OpSize == 0) {//do not override OpSize
  1653                                  
  1654 0000085E A0[3700]                 mov al, [OpSize]
  1655 00000861 3C00                     cmp al, 0
  1656 00000863 0F853C00                 jne .setwflag51
  1657                                  
  1658                                  ;-329         if (Op == REG) OpSize=R1Type;
  1659                                  
  1660 00000867 A0[2D00]                 mov al, [Op]
  1661 0000086A 3C02                     cmp al, 2
  1662 0000086C 0F850600                 jne .setwflag52
  1663 00000870 A0[3600]                 mov al, [R1Type]
  1664 00000873 A2[3700]                 mov byte [OpSize], al
  1665                                  
  1666                                  ;-330         if (Op2== REG) OpSize=R2Type;
  1667                                  
  1668                                  .setwflag52:
  1669 00000876 A0[2E00]                 mov al, [Op2]
  1670 00000879 3C02                     cmp al, 2
  1671 0000087B 0F850600                 jne .setwflag53
  1672 0000087F A0[3500]                 mov al, [R2Type]
  1673 00000882 A2[3700]                 mov byte [OpSize], al
  1674                                  
  1675                                  ;-331         if (R2Type== SEGREG) OpSize=WORD;
  1676                                  
  1677                                  .setwflag53:
  1678 00000885 A0[3500]                 mov al, [R2Type]
  1679 00000888 3C04                     cmp al, 4
  1680 0000088A 0F850600                 jne .setwflag54
  1681 0000088E B80200                   mov ax, 2
  1682 00000891 A2[3700]                 mov byte [OpSize], al
  1683                                  
  1684                                  ;-332         if (R1Type == SEGREG) OpSize=WORD;
  1685                                  
  1686                                  .setwflag54:
  1687 00000894 A0[3600]                 mov al, [R1Type]
  1688 00000897 3C04                     cmp al, 4
  1689 00000899 0F850600                 jne .setwflag55
  1690 0000089D B80200                   mov ax, 2
  1691 000008A0 A2[3700]                 mov byte [OpSize], al
  1692                                  
  1693                                  ;-333     }
  1694                                  
  1695                                  .setwflag55:
  1696                                  
  1697                                  ;-334     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1698                                  
  1699                                  .setwflag51:
  1700 000008A3 A0[3700]                 mov al, [OpSize]
  1701 000008A6 3C03                     cmp al, 3
  1702 000008A8 0F850900                 jne .setwflag56
  1703 000008AC E8B318                   call gen66h
  1704 000008AF B80100                   mov ax, 1
  1705 000008B2 A2[3800]                 mov byte [wflag], al
  1706                                  
  1707                                  ;-335     if (OpSize  ==  WORD) wflag=1;
  1708                                  
  1709                                  .setwflag56:
  1710 000008B5 A0[3700]                 mov al, [OpSize]
  1711 000008B8 3C02                     cmp al, 2
  1712 000008BA 0F850600                 jne .setwflag57
  1713 000008BE B80100                   mov ax, 1
  1714 000008C1 A2[3800]                 mov byte [wflag], al
  1715                                  
  1716                                  ;-336 }
  1717                                  
  1718                                  .setwflag57:
  1719                                  
  1720                                  ;-337 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  1721                                  
  1722 000008C4 C3                       ret
  1723                                  ENDP
  1724                                  
  1725                                  setsflag: PROC
  1726                                  
  1727                                  ;-338     unsigned int ui;
  1728                                  
  1729                                  
  1730                                  ;-339     sflag=2;
  1731                                  
  1732                                  ;Function : setsflag, Number of local variables: 1
  1733                                  ;   # type sign width addr used name   list of local variables
  1734                                  ;  200 var unsg word   338 NULL ui = bp-2;
  1735 000008C5 C8020000                 ENTER  2,0
  1736 000008C9 B80200                   mov ax, 2
  1737 000008CC A2[3A00]                 mov byte [sflag], al
  1738                                  
  1739                                  ;-340     ui = imme & 0xFF80;//is greater than signed 127?
  1740                                  
  1741 000008CF A1[3F00]                 mov ax, [imme]
  1742 000008D2 2580FF                   and ax, 65408
  1743 000008D5 8946FE                   mov [bp-2], ax
  1744                                  
  1745                                  ;-341     if(ui != 0) sflag = 0;
  1746                                  
  1747 000008D8 8B46FE                   mov ax, [bp-2]
  1748 000008DB 83F800                   cmp ax, 0
  1749 000008DE 0F840600                 je  .setsflag58
  1750 000008E2 B80000                   mov ax, 0
  1751 000008E5 A2[3A00]                 mov byte [sflag], al
  1752                                  
  1753                                  ;-342     if (OpSize == BYTE) {
  1754                                  
  1755                                  .setsflag58:
  1756 000008E8 A0[3700]                 mov al, [OpSize]
  1757 000008EB 3C01                     cmp al, 1
  1758 000008ED 0F851900                 jne .setsflag59
  1759                                  
  1760                                  ;-343         if (imme > 255) error1("too big for byte r/m");
  1761                                  
  1762 000008F1 A1[3F00]                 mov ax, [imme]
  1763 000008F4 3DFF00                   cmp ax, 255
  1764 000008F7 0F8E0900                 jle .setsflag60
  1765 000008FB 68[0C09]                 push setsflag_0
  1766 000008FE E8A311                   call error1
  1767 00000901 83C402                   add  sp, 2
  1768                                  
  1769                                  ;-344         sflag=0;//byte reg does not need sign extended
  1770                                  
  1771                                  .setsflag60:
  1772 00000904 B80000                   mov ax, 0
  1773 00000907 A2[3A00]                 mov byte [sflag], al
  1774                                  
  1775                                  ;-345     }
  1776                                  
  1777                                  
  1778                                  ;-346 }
  1779                                  
  1780                                  .setsflag59:
  1781                                  
  1782                                  ;-347 int checkConstSize(unsigned int ui) {
  1783 0000090A C9                       LEAVE
  1784 0000090B C3                       ret
  1785 0000090C 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1786 00000915 6F7220627974652072-
  1787 0000091E 2F6D00             
  1788                                  ENDP
  1789                                  
  1790                                  checkConstSize: PROC
  1791                                  
  1792                                  ;-348     if (ui > 127   ) return 0;//is near; return sflag
  1793                                  
  1794                                  ;Function : checkConstSize, Number of local variables: 1
  1795                                  ;   # type sign width addr used name   list of local variables
  1796                                  ;  200 var unsg word   347 NULL ui = bp+4;
  1797 00000921 C8000000                 ENTER  0,0
  1798 00000925 8B4604                   mov ax, [bp+4]
  1799 00000928 83F87F                   cmp ax, 127
  1800 0000092B 0F8E0600                 jle .checkConstSize61
  1801 0000092F B80000                   mov ax, 0
  1802 00000932 E91600                   jmp .retncheckConstSize
  1803                                  
  1804                                  ;-349     if (ui < 0xFF80) return 0;//-128dez
  1805                                  
  1806                                  .checkConstSize61:
  1807 00000935 8B4604                   mov ax, [bp+4]
  1808 00000938 3D80FF                   cmp ax, 65408
  1809 0000093B 0F8D0600                 jge .checkConstSize62
  1810 0000093F B80000                   mov ax, 0
  1811 00000942 E90600                   jmp .retncheckConstSize
  1812                                  
  1813                                  ;-350     return 2;// is short
  1814                                  
  1815                                  .checkConstSize62:
  1816 00000945 B80200                   mov ax, 2
  1817 00000948 E90000                   jmp .retncheckConstSize
  1818                                  
  1819                                  ;-351 }
  1820                                  
  1821                                  
  1822                                  ;-352 
  1823                                  
  1824                                  
  1825                                  ;-353 
  1826                                  
  1827                                  
  1828                                  ;-354 //#include "PARSE.C"
  1829                                  
  1830                                  
  1831                                  ;-355 int parse() {
  1832                                  
  1833 0000094B C9                       .retncheckConstSize: LEAVE
  1834 0000094C C3                       ret
  1835                                  ENDP
  1836                                  
  1837                                  parse: PROC
  1838                                  
  1839                                  ;-356     LabelNamePtr  = &LabelNames;
  1840                                  
  1841 0000094D B85A77                   mov ax, LabelNames
  1842 00000950 A3[4600]                 mov word [LabelNamePtr], ax
  1843                                  
  1844                                  ;-357     JmpCallNamePtr= &JmpCallNames;
  1845                                  
  1846 00000953 B8AA8B                   mov ax, JmpCallNames
  1847 00000956 A3[5000]                 mov word [JmpCallNamePtr], ax
  1848                                  
  1849                                  ;-358     LabelMaxIx=0;
  1850                                  
  1851 00000959 B80000                   mov ax, 0
  1852 0000095C A3[4A00]                 mov word [LabelMaxIx], ax
  1853                                  
  1854                                  ;-359     JmpCallMaxIx=0;
  1855                                  
  1856 0000095F B80000                   mov ax, 0
  1857 00000962 A3[5200]                 mov word [JmpCallMaxIx], ax
  1858                                  
  1859                                  ;-360     BinLen=0;
  1860                                  
  1861 00000965 B80000                   mov ax, 0
  1862 00000968 A3[5400]                 mov word [BinLen], ax
  1863                                  
  1864                                  ;-361     isInProc=0;
  1865                                  
  1866 0000096B B80000                   mov ax, 0
  1867 0000096E A2[0D00]                 mov byte [isInProc], al
  1868                                  
  1869                                  ;-362 
  1870                                  
  1871                                  
  1872                                  ;-363     do {//process a new line
  1873                                  
  1874                                  .parse63:
  1875                                  
  1876                                  ;-364         PCStart=PC;
  1877                                  
  1878 00000971 A1[2300]                 mov ax, [PC]
  1879 00000974 A3[2900]                 mov word [PCStart], ax
  1880                                  
  1881                                  ;-365         OpSize=0;
  1882                                  
  1883 00000977 B80000                   mov ax, 0
  1884 0000097A A2[3700]                 mov byte [OpSize], al
  1885                                  
  1886                                  ;-366         OpPrintIndex=0;
  1887                                  
  1888 0000097D B80000                   mov ax, 0
  1889 00000980 A3[4100]                 mov word [OpPrintIndex], ax
  1890                                  
  1891                                  ;-367         PrintRA=' ';
  1892                                  
  1893 00000983 B82000                   mov ax, 32
  1894 00000986 A2[4500]                 mov byte [PrintRA], al
  1895                                  
  1896                                  ;-368         getLine();
  1897                                  
  1898 00000989 E8BD06                   call getLine
  1899                                  
  1900                                  ;-369         InputPtr = &InputBuf;
  1901                                  
  1902 0000098C B88D75                   mov ax, InputBuf
  1903 0000098F A3[1400]                 mov word [InputPtr], ax
  1904                                  
  1905                                  ;-370         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1906                                  
  1907 00000992 E8D100                   call getTokeType
  1908                                  
  1909                                  ;-371         if (TokeType == ALNUME) {
  1910                                  
  1911 00000995 A0[2C00]                 mov al, [TokeType]
  1912 00000998 3C03                     cmp al, 3
  1913 0000099A 0F852C00                 jne .parse64
  1914                                  
  1915                                  ;-372             if (isLabel) {//set in getName
  1916                                  
  1917 0000099E A0[2B00]                 mov al, [isLabel]
  1918 000009A1 08C0                     or  al, al
  1919 000009A3 0F842300                 je .parse65
  1920                                  
  1921                                  ;-373               if (isInProc == 0)  strcpy(ProcName, Symbol);
  1922                                  
  1923 000009A7 A0[0D00]                 mov al, [isInProc]
  1924 000009AA 3C00                     cmp al, 0
  1925 000009AC 0F851000                 jne .parse66
  1926 000009B0 8D063075                 lea  ax, [Symbol]
  1927 000009B4 50                       push ax
  1928 000009B5 8D066E75                 lea  ax, [ProcName]
  1929 000009B9 50                       push ax
  1930 000009BA E8E408                   call strcpy
  1931 000009BD 83C404                   add  sp, 4
  1932                                  
  1933                                  ;-374                 storeLabel();
  1934                                  
  1935                                  .parse66:
  1936 000009C0 E8B401                   call storeLabel
  1937                                  
  1938                                  ;-375                 InputPtr++;//remove :
  1939                                  
  1940 000009C3 FF06[1400]               inc  word[InputPtr]
  1941                                  
  1942                                  ;-376                 getTokeType();
  1943                                  
  1944 000009C7 E89C00                   call getTokeType
  1945                                  
  1946                                  ;-377             }
  1947                                  
  1948                                  
  1949                                  ;-378         }
  1950                                  
  1951                                  .parse65:
  1952                                  
  1953                                  ;-379         if (TokeType == ALNUME) {
  1954                                  
  1955                                  .parse64:
  1956 000009CA A0[2C00]                 mov al, [TokeType]
  1957 000009CD 3C03                     cmp al, 3
  1958 000009CF 0F851B00                 jne .parse67
  1959                                  
  1960                                  ;-380             lookCode();// and OpCodePtr
  1961                                  
  1962 000009D3 E83504                   call lookCode
  1963                                  
  1964                                  ;-381             if(CodeType) process();
  1965                                  
  1966 000009D6 A0[2F00]                 mov al, [CodeType]
  1967 000009D9 08C0                     or  al, al
  1968 000009DB 0F840600                 je .parse68
  1969 000009DF E89F19                   call process
  1970                                  
  1971                                  ;-382             else getVariable();
  1972                                  
  1973 000009E2 E90300                   jmp .parse69
  1974                                  .parse68:
  1975 000009E5 E88A02                   call getVariable
  1976                                  
  1977                                  ;-383             skipRest();
  1978                                  
  1979                                  .parse69:
  1980 000009E8 E87505                   call skipRest
  1981                                  
  1982                                  ;-384         }
  1983                                  
  1984                                  
  1985                                  ;-385         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1986                                  
  1987 000009EB E92700                   jmp .parse70
  1988                                  .parse67:
  1989 000009EE A0[2C00]                 mov al, [TokeType]
  1990 000009F1 3C03                     cmp al, 3
  1991 000009F3 0F8E0C00                 jle .parse71
  1992 000009F7 68[260A]                 push parse_0
  1993 000009FA E8A710                   call error1
  1994 000009FD 83C402                   add  sp, 2
  1995                                  
  1996                                  ;-386         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1997                                  
  1998 00000A00 E91200                   jmp .parse72
  1999                                  .parse71:
  2000 00000A03 A0[2C00]                 mov al, [TokeType]
  2001 00000A06 3C01                     cmp al, 1
  2002 00000A08 0F850900                 jne .parse73
  2003 00000A0C 68[440A]                 push parse_1
  2004 00000A0F E89210                   call error1
  2005 00000A12 83C402                   add  sp, 2
  2006                                  
  2007                                  ;-387         printLine();
  2008                                  
  2009                                  .parse73:
  2010                                  .parse72:
  2011                                  .parse70:
  2012 00000A15 E8390E                   call printLine
  2013                                  
  2014                                  ;-388     } while (DOS_NoBytes != 0 );
  2015                                  
  2016 00000A18 A1[2000]                 mov ax, [DOS_NoBytes]
  2017 00000A1B 83F800                   cmp ax, 0
  2018 00000A1E 0F840300                 je  .parse74
  2019 00000A22 E94CFF                   jmp .parse63
  2020                                  .parse74:
  2021                                  
  2022                                  ;-389 }
  2023                                  
  2024                                  
  2025                                  ;-390 
  2026                                  
  2027                                  
  2028                                  ;-391 int getTokeType() {
  2029                                  
  2030 00000A25 C3                       ret
  2031 00000A26 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2032 00000A2F 696E73747275637469-
  2033 00000A38 6F6E20657870656374-
  2034 00000A41 656400             
  2035 00000A44 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2036 00000A4D 616C6C6F7765642061-
  2037 00000A56 74207374617274206F-
  2038 00000A5F 66206C696E6500     
  2039                                  ENDP
  2040                                  
  2041                                  getTokeType: PROC
  2042                                  
  2043                                  ;-392     char c;
  2044                                  
  2045                                  
  2046                                  ;-393     skipBlank();
  2047                                  
  2048                                  ;Function : getTokeType, Number of local variables: 1
  2049                                  ;   # type sign width addr used name   list of local variables
  2050                                  ;  200 var sign byte   392 NULL c = bp-2;
  2051 00000A66 C8020000                 ENTER  2,0
  2052 00000A6A E8FD06                   call skipBlank
  2053                                  
  2054                                  ;-394     c = *InputPtr;
  2055                                  
  2056 00000A6D 8B1E[1400]               mov bx, [InputPtr]
  2057 00000A71 8A07                     mov al, [bx]
  2058 00000A73 B400                     mov ah, 0
  2059 00000A75 8846FE                   mov [bp-2], al
  2060                                  
  2061                                  ;-395     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2062                                  
  2063 00000A78 8A46FE                   mov al, [bp-2]
  2064 00000A7B 3C00                     cmp al, 0
  2065 00000A7D 0F850900                 jne .getTokeType75
  2066 00000A81 B80000                   mov ax, 0
  2067 00000A84 A2[2C00]                 mov byte [TokeType], al
  2068 00000A87 E96600                   jmp .retngetTokeType
  2069                                  
  2070                                  ;-396     if (c == ';') {TokeType=0; return; }//comment
  2071                                  
  2072                                  .getTokeType75:
  2073 00000A8A 8A46FE                   mov al, [bp-2]
  2074 00000A8D 3C3B                     cmp al, 59
  2075 00000A8F 0F850900                 jne .getTokeType76
  2076 00000A93 B80000                   mov ax, 0
  2077 00000A96 A2[2C00]                 mov byte [TokeType], al
  2078 00000A99 E95400                   jmp .retngetTokeType
  2079                                  
  2080                                  ;-397     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2081                                  
  2082                                  .getTokeType76:
  2083 00000A9C 8A46FE                   mov al, byte [bp-2]
  2084 00000A9F B400                     mov ah, 0
  2085 00000AA1 50                       push ax
  2086 00000AA2 E8AA07                   call digit
  2087 00000AA5 83C402                   add  sp, 2
  2088 00000AA8 08C0                     or  al, al
  2089 00000AAA 0F841500                 je .getTokeType77
  2090 00000AAE 8A46FE                   mov al, byte [bp-2]
  2091 00000AB1 B400                     mov ah, 0
  2092 00000AB3 50                       push ax
  2093 00000AB4 E8D408                   call getDigit
  2094 00000AB7 83C402                   add  sp, 2
  2095 00000ABA B80100                   mov ax, 1
  2096 00000ABD A2[2C00]                 mov byte [TokeType], al
  2097 00000AC0 E92D00                   jmp .retngetTokeType
  2098                                  
  2099                                  ;-398     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2100                                  
  2101                                  .getTokeType77:
  2102 00000AC3 8A46FE                   mov al, byte [bp-2]
  2103 00000AC6 B400                     mov ah, 0
  2104 00000AC8 50                       push ax
  2105 00000AC9 E8C906                   call letterE
  2106 00000ACC 83C402                   add  sp, 2
  2107 00000ACF 08C0                     or  al, al
  2108 00000AD1 0F841500                 je .getTokeType78
  2109 00000AD5 8A46FE                   mov al, byte [bp-2]
  2110 00000AD8 B400                     mov ah, 0
  2111 00000ADA 50                       push ax
  2112 00000ADB E8FD08                   call getName
  2113 00000ADE 83C402                   add  sp, 2
  2114 00000AE1 B80300                   mov ax, 3
  2115 00000AE4 A2[2C00]                 mov byte [TokeType], al
  2116 00000AE7 E90600                   jmp .retngetTokeType
  2117                                  
  2118                                  ;-399     TokeType=NOALNUME;
  2119                                  
  2120                                  .getTokeType78:
  2121 00000AEA B80400                   mov ax, 4
  2122 00000AED A2[2C00]                 mov byte [TokeType], al
  2123                                  
  2124                                  ;-400 }
  2125                                  
  2126                                  
  2127                                  ;-401 
  2128                                  
  2129                                  
  2130                                  ;-402 int storeJmpCall() {
  2131                                  
  2132 00000AF0 C9                       .retngetTokeType: LEAVE
  2133 00000AF1 C3                       ret
  2134                                  ENDP
  2135                                  
  2136                                  storeJmpCall: PROC
  2137                                  
  2138                                  ;-403     unsigned int i;
  2139                                  
  2140                                  
  2141                                  ;-404     JmpCallMaxIx++;
  2142                                  
  2143                                  ;Function : storeJmpCall, Number of local variables: 1
  2144                                  ;   # type sign width addr used name   list of local variables
  2145                                  ;  200 var unsg word   403 NULL i = bp-2;
  2146 00000AF2 C8020000                 ENTER  2,0
  2147 00000AF6 FF06[5200]               inc  word[JmpCallMaxIx]
  2148                                  
  2149                                  ;-405     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2150                                  
  2151 00000AFA A1[5200]                 mov ax, [JmpCallMaxIx]
  2152 00000AFD 3DF401                   cmp ax, 500 ;unsigned : 1
  2153 00000B00 0F8C0900                 jl  .storeJmpCall79
  2154 00000B04 68[4E0B]                 push storeJmpCall_0
  2155 00000B07 E8F00F                   call errorexit
  2156 00000B0A 83C402                   add  sp, 2
  2157                                  
  2158                                  ;-406     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2159                                  
  2160                                  .storeJmpCall79:
  2161 00000B0D 8D063075                 lea  ax, [Symbol]
  2162 00000B11 50                       push ax
  2163 00000B12 FF36[5000]               push word [JmpCallNamePtr]
  2164 00000B16 E88807                   call strcpy
  2165 00000B19 83C404                   add  sp, 4
  2166 00000B1C A3[5000]                 mov word [JmpCallNamePtr], ax
  2167                                  
  2168                                  ;-407     JmpCallNamePtr++;
  2169                                  
  2170 00000B1F FF06[5000]               inc  word[JmpCallNamePtr]
  2171                                  
  2172                                  ;-408     i = JmpCallNamePtr - &JmpCallNames;
  2173                                  
  2174 00000B23 A1[5000]                 mov ax, [JmpCallNamePtr]
  2175 00000B26 2DAA8B                   sub ax, JmpCallNames
  2176 00000B29 8946FE                   mov [bp-2], ax
  2177                                  
  2178                                  ;-409     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2179                                  
  2180 00000B2C 8B46FE                   mov ax, [bp-2]
  2181 00000B2F 3DB107                   cmp ax, 1969 ;unsigned : 0
  2182 00000B32 0F820900                 jb  .storeJmpCall80
  2183 00000B36 68[600B]                 push storeJmpCall_1
  2184 00000B39 E8BE0F                   call errorexit
  2185 00000B3C 83C402                   add  sp, 2
  2186                                  
  2187                                  ;-410     JmpCallAddr[JmpCallMaxIx] = PC;
  2188                                  
  2189                                  .storeJmpCall80:
  2190 00000B3F A1[2300]                 mov ax, [PC]
  2191 00000B42 8B1E[5200]               mov bx, [JmpCallMaxIx]
  2192 00000B46 D1E3                     shl bx, 1
  2193 00000B48 89877A93                 mov [JmpCallAddr+bx], ax
  2194                                  
  2195                                  ;-411 }
  2196                                  
  2197                                  
  2198                                  ;-412 
  2199                                  
  2200                                  
  2201                                  ;-413 int storeLabel() {
  2202 00000B4C C9                       LEAVE
  2203 00000B4D C3                       ret
  2204 00000B4E 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2205 00000B57 4A6D7043616C6C7300 
  2206 00000B60 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2207 00000B69 4A6D7043616C6C206E-
  2208 00000B72 616D657300         
  2209                                  ENDP
  2210                                  
  2211                                  storeLabel: PROC
  2212                                  
  2213                                  ;-414     unsigned int i;
  2214                                  
  2215                                  
  2216                                  ;-415     if(searchLabel()) error1("duplicate label");
  2217                                  
  2218                                  ;Function : storeLabel, Number of local variables: 1
  2219                                  ;   # type sign width addr used name   list of local variables
  2220                                  ;  200 var unsg word   414 NULL i = bp-2;
  2221 00000B77 C8020000                 ENTER  2,0
  2222 00000B7B E8A000                   call searchLabel
  2223 00000B7E 08C0                     or  al, al
  2224 00000B80 0F840900                 je .storeLabel81
  2225 00000B84 68[E90B]                 push storeLabel_0
  2226 00000B87 E81A0F                   call error1
  2227 00000B8A 83C402                   add  sp, 2
  2228                                  
  2229                                  ;-416     LabelMaxIx++;
  2230                                  
  2231                                  .storeLabel81:
  2232 00000B8D FF06[4A00]               inc  word[LabelMaxIx]
  2233                                  
  2234                                  ;-417     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2235                                  
  2236 00000B91 A1[4A00]                 mov ax, [LabelMaxIx]
  2237 00000B94 3D5802                   cmp ax, 600 ;unsigned : 1
  2238 00000B97 0F8C0900                 jl  .storeLabel82
  2239 00000B9B 68[F90B]                 push storeLabel_1
  2240 00000B9E E8590F                   call errorexit
  2241 00000BA1 83C402                   add  sp, 2
  2242                                  
  2243                                  ;-418     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2244                                  
  2245                                  .storeLabel82:
  2246 00000BA4 8D063075                 lea  ax, [Symbol]
  2247 00000BA8 50                       push ax
  2248 00000BA9 FF36[4600]               push word [LabelNamePtr]
  2249 00000BAD E8F106                   call strcpy
  2250 00000BB0 83C404                   add  sp, 4
  2251 00000BB3 A3[4600]                 mov word [LabelNamePtr], ax
  2252                                  
  2253                                  ;-419     LabelNamePtr++;
  2254                                  
  2255 00000BB6 FF06[4600]               inc  word[LabelNamePtr]
  2256                                  
  2257                                  ;-420     i = LabelNamePtr - &LabelNames;
  2258                                  
  2259 00000BBA A1[4600]                 mov ax, [LabelNamePtr]
  2260 00000BBD 2D5A77                   sub ax, LabelNames
  2261 00000BC0 8946FE                   mov [bp-2], ax
  2262                                  
  2263                                  ;-421     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2264                                  
  2265 00000BC3 8B46FE                   mov ax, [bp-2]
  2266 00000BC6 3D810F                   cmp ax, 3969 ;unsigned : 0
  2267 00000BC9 0F820900                 jb  .storeLabel83
  2268 00000BCD 68[090C]                 push storeLabel_2
  2269 00000BD0 E8270F                   call errorexit
  2270 00000BD3 83C402                   add  sp, 2
  2271                                  
  2272                                  ;-422     LabelAddr[LabelMaxIx] = PC + Origin;
  2273                                  
  2274                                  .storeLabel83:
  2275 00000BD6 A1[2300]                 mov ax, [PC]
  2276 00000BD9 0306[2500]               add ax, [Origin]
  2277 00000BDD 8B1E[4A00]               mov bx, [LabelMaxIx]
  2278 00000BE1 D1E3                     shl bx, 1
  2279 00000BE3 8987FA86                 mov [LabelAddr+bx], ax
  2280                                  
  2281                                  ;-423 }
  2282                                  
  2283                                  
  2284                                  ;-424 
  2285                                  
  2286                                  
  2287                                  ;-425 int searchLabel() {
  2288 00000BE7 C9                       LEAVE
  2289 00000BE8 C3                       ret
  2290 00000BE9 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2291 00000BF2 206C6162656C00     
  2292 00000BF9 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  2293 00000C02 6C6162656C7300     
  2294 00000C09 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2295 00000C12 6C6162656C206E616D-
  2296 00000C1B 657300             
  2297                                  ENDP
  2298                                  
  2299                                  searchLabel: PROC
  2300                                  
  2301                                  ;-426     int LIx; char *p;
  2302                                  
  2303                                  
  2304                                  ;-427     p = &LabelNames;
  2305                                  
  2306                                  ;Function : searchLabel, Number of local variables: 2
  2307                                  ;   # type sign width addr used name   list of local variables
  2308                                  ;  200 var sign word   426 NULL LIx = bp-2
  2309                                  ;  201 ptr sign byte   426 NULL p = bp-4;
  2310 00000C1E C8040000                 ENTER  4,0
  2311 00000C22 B85A77                   mov ax, LabelNames
  2312 00000C25 8946FC                   mov [bp-4], ax
  2313                                  
  2314                                  ;-428     LIx = 1;
  2315                                  
  2316 00000C28 B80100                   mov ax, 1
  2317 00000C2B 8946FE                   mov [bp-2], ax
  2318                                  
  2319                                  ;-429     while (LIx <= LabelMaxIx) {
  2320                                  
  2321                                  .searchLabel84:
  2322 00000C2E 8B46FE                   mov ax, [bp-2]
  2323 00000C31 3B06[4A00]               cmp ax, [LabelMaxIx]
  2324 00000C35 0F8F3100                 jg  .searchLabel85
  2325                                  
  2326                                  ;-430         if (eqstr(p, Symbol)) return LIx;//pos of label
  2327                                  
  2328 00000C39 8D063075                 lea  ax, [Symbol]
  2329 00000C3D 50                       push ax
  2330 00000C3E FF76FC                   push word [bp-4]
  2331 00000C41 E89306                   call eqstr
  2332 00000C44 83C404                   add  sp, 4
  2333 00000C47 08C0                     or  al, al
  2334 00000C49 0F840600                 je .searchLabel86
  2335 00000C4D 8B46FE                   mov ax, [bp-2]
  2336 00000C50 E91D00                   jmp .retnsearchLabel
  2337                                  
  2338                                  ;-431         p=strlen(p) + p;
  2339                                  
  2340                                  .searchLabel86:
  2341 00000C53 FF76FC                   push word [bp-4]
  2342 00000C56 E82006                   call strlen
  2343 00000C59 83C402                   add  sp, 2
  2344 00000C5C 0346FC                   add ax, [bp-4]
  2345 00000C5F 8946FC                   mov [bp-4], ax
  2346                                  
  2347                                  ;-432         p++;
  2348                                  
  2349 00000C62 FF46FC                   inc  word[bp-4]
  2350                                  
  2351                                  ;-433         LIx++;
  2352                                  
  2353 00000C65 FF46FE                   inc  word[bp-2]
  2354                                  
  2355                                  ;-434     }
  2356                                  
  2357                                  
  2358                                  ;-435     return 0;
  2359                                  
  2360 00000C68 EBC4                     jmp .searchLabel84
  2361                                  .searchLabel85:
  2362 00000C6A B80000                   mov ax, 0
  2363 00000C6D E90000                   jmp .retnsearchLabel
  2364                                  
  2365                                  ;-436 }
  2366                                  
  2367                                  
  2368                                  ;-437 
  2369                                  
  2370                                  
  2371                                  ;-438 int getVariable() {
  2372                                  
  2373 00000C70 C9                       .retnsearchLabel: LEAVE
  2374 00000C71 C3                       ret
  2375                                  ENDP
  2376                                  
  2377                                  getVariable: PROC
  2378                                  
  2379                                  ;-439     char c;
  2380                                  
  2381                                  
  2382                                  ;-440     storeLabel();
  2383                                  
  2384                                  ;Function : getVariable, Number of local variables: 1
  2385                                  ;   # type sign width addr used name   list of local variables
  2386                                  ;  200 var sign byte   439 NULL c = bp-2;
  2387 00000C72 C8020000                 ENTER  2,0
  2388 00000C76 E8FEFE                   call storeLabel
  2389                                  
  2390                                  ;-441     getTokeType();
  2391                                  
  2392 00000C79 E8EAFD                   call getTokeType
  2393                                  
  2394                                  ;-442     if(TokeType==ALNUME) {//getName
  2395                                  
  2396 00000C7C A0[2C00]                 mov al, [TokeType]
  2397 00000C7F 3C03                     cmp al, 3
  2398 00000C81 0F857001                 jne .getVariable87
  2399                                  
  2400                                  ;-443         lookCode();
  2401                                  
  2402 00000C85 E88301                   call lookCode
  2403                                  
  2404                                  ;-444         if (CodeType < 200) dataexit();
  2405                                  
  2406 00000C88 A0[2F00]                 mov al, [CodeType]
  2407 00000C8B 3CC8                     cmp al, 200
  2408 00000C8D 0F8D0300                 jge .getVariable88
  2409 00000C91 E8F40F                   call dataexit
  2410                                  
  2411                                  ;-445         if (CodeType > 205) dataexit();
  2412                                  
  2413                                  .getVariable88:
  2414 00000C94 A0[2F00]                 mov al, [CodeType]
  2415 00000C97 3CCD                     cmp al, 205
  2416 00000C99 0F8E0300                 jle .getVariable89
  2417 00000C9D E8E80F                   call dataexit
  2418                                  
  2419                                  ;-446         if (CodeType== 200) {//DB
  2420                                  
  2421                                  .getVariable89:
  2422 00000CA0 A0[2F00]                 mov al, [CodeType]
  2423 00000CA3 3CC8                     cmp al, 200
  2424 00000CA5 0F856A00                 jne .getVariable90
  2425                                  
  2426                                  ;-447             do {
  2427                                  
  2428                                  .getVariable91:
  2429                                  
  2430                                  ;-448                 getTokeType();
  2431                                  
  2432 00000CA9 E8BAFD                   call getTokeType
  2433                                  
  2434                                  ;-449                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2435                                  
  2436 00000CAC A0[2C00]                 mov al, [TokeType]
  2437 00000CAF 3C01                     cmp al, 1
  2438 00000CB1 0F850D00                 jne .getVariable92
  2439 00000CB5 FF36[0E00]               push word [SymbolInt]
  2440 00000CB9 E8E614                   call genCode8
  2441 00000CBC 83C402                   add  sp, 2
  2442                                  
  2443                                  ;-450                 else {
  2444                                  
  2445 00000CBF E94100                   jmp .getVariable93
  2446                                  .getVariable92:
  2447                                  
  2448                                  ;-451                     skipBlank();
  2449                                  
  2450 00000CC2 E8A504                   call skipBlank
  2451                                  
  2452                                  ;-452                     if (isToken('"')) {
  2453                                  
  2454 00000CC5 6A22                     push 34
  2455 00000CC7 E82F02                   call isToken
  2456 00000CCA 83C402                   add  sp, 2
  2457 00000CCD 08C0                     or  al, al
  2458 00000CCF 0F843000                 je .getVariable94
  2459                                  
  2460                                  ;-453                         do {
  2461                                  
  2462                                  .getVariable95:
  2463                                  
  2464                                  ;-454                             c= *InputPtr;
  2465                                  
  2466 00000CD3 8B1E[1400]               mov bx, [InputPtr]
  2467 00000CD7 8A07                     mov al, [bx]
  2468 00000CD9 B400                     mov ah, 0
  2469 00000CDB 8846FE                   mov [bp-2], al
  2470                                  
  2471                                  ;-455                             genCode8(c);
  2472                                  
  2473 00000CDE 8A46FE                   mov al, byte [bp-2]
  2474 00000CE1 B400                     mov ah, 0
  2475 00000CE3 50                       push ax
  2476 00000CE4 E8BB14                   call genCode8
  2477 00000CE7 83C402                   add  sp, 2
  2478                                  
  2479                                  ;-456                             InputPtr++;
  2480                                  
  2481 00000CEA FF06[1400]               inc  word[InputPtr]
  2482                                  
  2483                                  ;-457                         } while (*InputPtr != '"' );
  2484                                  
  2485 00000CEE 8B1E[1400]               mov bx, [InputPtr]
  2486 00000CF2 8A07                     mov al, [bx]
  2487 00000CF4 B400                     mov ah, 0
  2488 00000CF6 83F822                   cmp ax, 34
  2489 00000CF9 0F840200                 je  .getVariable96
  2490 00000CFD EBD4                     jmp .getVariable95
  2491                                  .getVariable96:
  2492                                  
  2493                                  ;-458                         InputPtr++;
  2494                                  
  2495 00000CFF FF06[1400]               inc  word[InputPtr]
  2496                                  
  2497                                  ;-459                     }
  2498                                  
  2499                                  
  2500                                  ;-460                 }
  2501                                  
  2502                                  .getVariable94:
  2503                                  
  2504                                  ;-461             } while (isToken(','));
  2505                                  
  2506                                  .getVariable93:
  2507 00000D03 6A2C                     push 44
  2508 00000D05 E8F101                   call isToken
  2509 00000D08 83C402                   add  sp, 2
  2510 00000D0B 08C0                     or  al, al
  2511 00000D0D 0F840200                 je .getVariable97
  2512 00000D11 EB96                     jmp .getVariable91
  2513                                  .getVariable97:
  2514                                  
  2515                                  ;-462         }
  2516                                  
  2517                                  
  2518                                  ;-463         if (CodeType == 201) {//DW
  2519                                  
  2520                                  .getVariable90:
  2521 00000D13 A0[2F00]                 mov al, [CodeType]
  2522 00000D16 3CC9                     cmp al, 201
  2523 00000D18 0F852600                 jne .getVariable98
  2524                                  
  2525                                  ;-464             do {
  2526                                  
  2527                                  .getVariable99:
  2528                                  
  2529                                  ;-465                 getTokeType();
  2530                                  
  2531 00000D1C E847FD                   call getTokeType
  2532                                  
  2533                                  ;-466                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2534                                  
  2535 00000D1F A0[2C00]                 mov al, [TokeType]
  2536 00000D22 3C01                     cmp al, 1
  2537 00000D24 0F850A00                 jne .getVariable100
  2538 00000D28 FF36[0E00]               push word [SymbolInt]
  2539 00000D2C E8CA14                   call genCode16
  2540 00000D2F 83C402                   add  sp, 2
  2541                                  
  2542                                  ;-467             } while (isToken(','));
  2543                                  
  2544                                  .getVariable100:
  2545 00000D32 6A2C                     push 44
  2546 00000D34 E8C201                   call isToken
  2547 00000D37 83C402                   add  sp, 2
  2548 00000D3A 08C0                     or  al, al
  2549 00000D3C 0F840200                 je .getVariable101
  2550 00000D40 EBDA                     jmp .getVariable99
  2551                                  .getVariable101:
  2552                                  
  2553                                  ;-468         }
  2554                                  
  2555                                  
  2556                                  ;-469         if (CodeType == 202) {//DD
  2557                                  
  2558                                  .getVariable98:
  2559 00000D42 A0[2F00]                 mov al, [CodeType]
  2560 00000D45 3CCA                     cmp al, 202
  2561 00000D47 0F852E00                 jne .getVariable102
  2562                                  
  2563                                  ;-470             do {
  2564                                  
  2565                                  .getVariable103:
  2566                                  
  2567                                  ;-471                 getTokeType();
  2568                                  
  2569 00000D4B E818FD                   call getTokeType
  2570                                  
  2571                                  ;-472                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2572                                  
  2573 00000D4E A0[2C00]                 mov al, [TokeType]
  2574 00000D51 3C01                     cmp al, 1
  2575 00000D53 0F851200                 jne .getVariable104
  2576 00000D57 FF36[0E00]               push word [SymbolInt]
  2577 00000D5B E89B14                   call genCode16
  2578 00000D5E 83C402                   add  sp, 2
  2579                                  
  2580                                  ;-473                                     genCode16(0);}//todo genCode32(SymbolLong);
  2581                                  
  2582 00000D61 6A00                     push 0
  2583 00000D63 E89314                   call genCode16
  2584 00000D66 83C402                   add  sp, 2
  2585                                  
  2586                                  ;-474             } while (isToken(','));
  2587                                  
  2588                                  .getVariable104:
  2589 00000D69 6A2C                     push 44
  2590 00000D6B E88B01                   call isToken
  2591 00000D6E 83C402                   add  sp, 2
  2592 00000D71 08C0                     or  al, al
  2593 00000D73 0F840200                 je .getVariable105
  2594 00000D77 EBD2                     jmp .getVariable103
  2595                                  .getVariable105:
  2596                                  
  2597                                  ;-475         }
  2598                                  
  2599                                  
  2600                                  ;-476         if (CodeType >= 203) {//resb, resw, resd
  2601                                  
  2602                                  .getVariable102:
  2603 00000D79 A0[2F00]                 mov al, [CodeType]
  2604 00000D7C 3CCB                     cmp al, 203 ;unsigned : 1
  2605 00000D7E 0F8C7000                 jl  .getVariable106
  2606                                  
  2607                                  ;-477             getTokeType();
  2608                                  
  2609 00000D82 E8E1FC                   call getTokeType
  2610                                  
  2611                                  ;-478             if (TokeType == DIGIT) {
  2612                                  
  2613 00000D85 A0[2C00]                 mov al, [TokeType]
  2614 00000D88 3C01                     cmp al, 1
  2615 00000D8A 0F856100                 jne .getVariable107
  2616                                  
  2617                                  ;-479                 if (SymbolInt <= 0) syntaxerror();
  2618                                  
  2619 00000D8E A1[0E00]                 mov ax, [SymbolInt]
  2620 00000D91 83F800                   cmp ax, 0
  2621 00000D94 0F870300                 ja  .getVariable108
  2622 00000D98 E8C20E                   call syntaxerror
  2623                                  
  2624                                  ;-480                 if (AbsoluteLab == 0) error1("Absolute is null");
  2625                                  
  2626                                  .getVariable108:
  2627 00000D9B A1[2700]                 mov ax, [AbsoluteLab]
  2628 00000D9E 83F800                   cmp ax, 0
  2629 00000DA1 0F850900                 jne .getVariable109
  2630 00000DA5 68[FA0D]                 push getVariable_0
  2631 00000DA8 E8F90C                   call error1
  2632 00000DAB 83C402                   add  sp, 2
  2633                                  
  2634                                  ;-481                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2635                                  
  2636                                  .getVariable109:
  2637 00000DAE A1[2700]                 mov ax, [AbsoluteLab]
  2638 00000DB1 8B1E[4A00]               mov bx, [LabelMaxIx]
  2639 00000DB5 D1E3                     shl bx, 1
  2640 00000DB7 8987FA86                 mov [LabelAddr+bx], ax
  2641                                  
  2642                                  ;-482                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2643                                  
  2644 00000DBB A0[2F00]                 mov al, [CodeType]
  2645 00000DBE 3CCC                     cmp al, 204
  2646 00000DC0 0F850A00                 jne .getVariable110
  2647 00000DC4 A1[0E00]                 mov ax, [SymbolInt]
  2648 00000DC7 0306[0E00]               add ax, [SymbolInt]
  2649 00000DCB A3[0E00]                 mov word [SymbolInt], ax
  2650                                  
  2651                                  ;-483                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2652                                  
  2653                                  .getVariable110:
  2654 00000DCE A0[2F00]                 mov al, [CodeType]
  2655 00000DD1 3CCD                     cmp al, 205
  2656 00000DD3 0F850B00                 jne .getVariable111
  2657 00000DD7 A1[0E00]                 mov ax, [SymbolInt]
  2658 00000DDA BB0400                   mov bx, 4
  2659 00000DDD F7E3                     mul bx
  2660 00000DDF A3[0E00]                 mov word [SymbolInt], ax
  2661                                  
  2662                                  ;-484                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2663                                  
  2664                                  .getVariable111:
  2665 00000DE2 A1[2700]                 mov ax, [AbsoluteLab]
  2666 00000DE5 0306[0E00]               add ax, [SymbolInt]
  2667 00000DE9 A3[2700]                 mov word [AbsoluteLab], ax
  2668                                  
  2669                                  ;-485             } else numbererror();
  2670                                  
  2671 00000DEC E90300                   jmp .getVariable112
  2672                                  .getVariable107:
  2673 00000DEF E8D80D                   call numbererror
  2674                                  
  2675                                  ;-486         }
  2676                                  
  2677                                  .getVariable112:
  2678                                  
  2679                                  ;-487     }
  2680                                  
  2681                                  .getVariable106:
  2682                                  
  2683                                  ;-488     else dataexit();
  2684                                  
  2685 00000DF2 E90300                   jmp .getVariable113
  2686                                  .getVariable87:
  2687 00000DF5 E8900E                   call dataexit
  2688                                  
  2689                                  ;-489 }
  2690                                  
  2691                                  .getVariable113:
  2692                                  
  2693                                  ;-490 
  2694                                  
  2695                                  
  2696                                  ;-491 int lookCode() {//ret: CodeType, *OpCodePtr
  2697 00000DF8 C9                       LEAVE
  2698 00000DF9 C3                       ret
  2699 00000DFA 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2700 00000E03 6973206E756C6C00   
  2701                                  ENDP
  2702                                  
  2703                                  lookCode: PROC
  2704                                  
  2705                                  ;-492     CodeType=0;
  2706                                  
  2707 00000E0B B80000                   mov ax, 0
  2708 00000E0E A2[2F00]                 mov byte [CodeType], al
  2709                                  
  2710                                  ;-493     OpCodePtr= &I_START;
  2711                                  
  2712 00000E11 B8[5A00]                 mov ax, I_START
  2713 00000E14 A3[4300]                 mov word [OpCodePtr], ax
  2714                                  
  2715                                  ;-494     OpCodePtr++;
  2716                                  
  2717 00000E17 FF06[4300]               inc  word[OpCodePtr]
  2718                                  
  2719                                  ;-495     do  {
  2720                                  
  2721                                  .lookCode114:
  2722                                  
  2723                                  ;-496         if (eqstr(SymbolUpper, OpCodePtr))  {
  2724                                  
  2725 00000E1B FF36[4300]               push word [OpCodePtr]
  2726 00000E1F 8D064F75                 lea  ax, [SymbolUpper]
  2727 00000E23 50                       push ax
  2728 00000E24 E8B004                   call eqstr
  2729 00000E27 83C404                   add  sp, 4
  2730 00000E2A 08C0                     or  al, al
  2731 00000E2C 0F842700                 je .lookCode115
  2732                                  
  2733                                  ;-497             while(*OpCodePtr!=0) OpCodePtr++;
  2734                                  
  2735                                  .lookCode116:
  2736 00000E30 8B1E[4300]               mov bx, [OpCodePtr]
  2737 00000E34 8A07                     mov al, [bx]
  2738 00000E36 B400                     mov ah, 0
  2739 00000E38 83F800                   cmp ax, 0
  2740 00000E3B 0F840600                 je  .lookCode117
  2741 00000E3F FF06[4300]               inc  word[OpCodePtr]
  2742                                  
  2743                                  ;-498             OpCodePtr++;
  2744                                  
  2745 00000E43 EBEB                     jmp .lookCode116
  2746                                  .lookCode117:
  2747 00000E45 FF06[4300]               inc  word[OpCodePtr]
  2748                                  
  2749                                  ;-499             CodeType =*OpCodePtr;
  2750                                  
  2751 00000E49 8B1E[4300]               mov bx, [OpCodePtr]
  2752 00000E4D 8A07                     mov al, [bx]
  2753 00000E4F B400                     mov ah, 0
  2754 00000E51 A2[2F00]                 mov byte [CodeType], al
  2755                                  
  2756                                  ;-500             return;
  2757                                  
  2758 00000E54 E92A00                   jmp .retnlookCode
  2759                                  
  2760                                  ;-501         }
  2761                                  
  2762                                  
  2763                                  ;-502     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2764                                  
  2765                                  .lookCode115:
  2766                                  .lookCode118:
  2767 00000E57 8B1E[4300]               mov bx, [OpCodePtr]
  2768 00000E5B 8A07                     mov al, [bx]
  2769 00000E5D B400                     mov ah, 0
  2770 00000E5F 3DF100                   cmp ax, 241
  2771 00000E62 0F840600                 je  .lookCode119
  2772 00000E66 FF06[4300]               inc  word[OpCodePtr]
  2773                                  
  2774                                  ;-503     OpCodePtr++;
  2775                                  
  2776 00000E6A EBEB                     jmp .lookCode118
  2777                                  .lookCode119:
  2778 00000E6C FF06[4300]               inc  word[OpCodePtr]
  2779                                  
  2780                                  ;-504     } while(*OpCodePtr!=0);
  2781                                  
  2782 00000E70 8B1E[4300]               mov bx, [OpCodePtr]
  2783 00000E74 8A07                     mov al, [bx]
  2784 00000E76 B400                     mov ah, 0
  2785 00000E78 83F800                   cmp ax, 0
  2786 00000E7B 0F840200                 je  .lookCode120
  2787 00000E7F EB9A                     jmp .lookCode114
  2788                                  .lookCode120:
  2789                                  
  2790                                  ;-505 }
  2791                                  
  2792                                  
  2793                                  ;-506 
  2794                                  
  2795                                  
  2796                                  ;-507 int getCodeSize() {
  2797                                  
  2798                                   .retnlookCode:
  2799 00000E81 C3                       ret
  2800                                  ENDP
  2801                                  
  2802                                  getCodeSize: PROC
  2803                                  
  2804                                  ;-508     if (TokeType ==ALNUME) {
  2805                                  
  2806 00000E82 A0[2C00]                 mov al, [TokeType]
  2807 00000E85 3C03                     cmp al, 3
  2808 00000E87 0F855700                 jne .getCodeSize121
  2809                                  
  2810                                  ;-509         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2811                                  
  2812 00000E8B 68[E90E]                 push getCodeSize_0
  2813 00000E8E 8D064F75                 lea  ax, [SymbolUpper]
  2814 00000E92 50                       push ax
  2815 00000E93 E84104                   call eqstr
  2816 00000E96 83C404                   add  sp, 4
  2817 00000E99 08C0                     or  al, al
  2818 00000E9B 0F840900                 je .getCodeSize122
  2819 00000E9F E8C4FB                   call getTokeType
  2820 00000EA2 B80100                   mov ax, 1
  2821 00000EA5 E94000                   jmp .retngetCodeSize
  2822                                  
  2823                                  ;-510         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2824                                  
  2825                                  .getCodeSize122:
  2826 00000EA8 68[EE0E]                 push getCodeSize_1
  2827 00000EAB 8D064F75                 lea  ax, [SymbolUpper]
  2828 00000EAF 50                       push ax
  2829 00000EB0 E82404                   call eqstr
  2830 00000EB3 83C404                   add  sp, 4
  2831 00000EB6 08C0                     or  al, al
  2832 00000EB8 0F840900                 je .getCodeSize123
  2833 00000EBC E8A7FB                   call getTokeType
  2834 00000EBF B80200                   mov ax, 2
  2835 00000EC2 E92300                   jmp .retngetCodeSize
  2836                                  
  2837                                  ;-511         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2838                                  
  2839                                  .getCodeSize123:
  2840 00000EC5 68[F30E]                 push getCodeSize_2
  2841 00000EC8 8D064F75                 lea  ax, [SymbolUpper]
  2842 00000ECC 50                       push ax
  2843 00000ECD E80704                   call eqstr
  2844 00000ED0 83C404                   add  sp, 4
  2845 00000ED3 08C0                     or  al, al
  2846 00000ED5 0F840900                 je .getCodeSize124
  2847 00000ED9 E88AFB                   call getTokeType
  2848 00000EDC B80300                   mov ax, 3
  2849 00000EDF E90600                   jmp .retngetCodeSize
  2850                                  
  2851                                  ;-512     }
  2852                                  
  2853                                  .getCodeSize124:
  2854                                  
  2855                                  ;-513     return 0;
  2856                                  
  2857                                  .getCodeSize121:
  2858 00000EE2 B80000                   mov ax, 0
  2859 00000EE5 E90000                   jmp .retngetCodeSize
  2860                                  
  2861                                  ;-514 }
  2862                                  
  2863                                  
  2864                                  ;-515 int isToken(char c) {
  2865                                  
  2866                                   .retngetCodeSize:
  2867 00000EE8 C3                       ret
  2868 00000EE9 4259544500              getCodeSize_0 db "BYTE",0
  2869 00000EEE 574F524400              getCodeSize_1 db "WORD",0
  2870 00000EF3 44574F524400            getCodeSize_2 db "DWORD",0
  2871                                  ENDP
  2872                                  
  2873                                  isToken: PROC
  2874                                  
  2875                                  ;-516     skipBlank();
  2876                                  
  2877                                  ;Function : isToken, Number of local variables: 1
  2878                                  ;   # type sign width addr used name   list of local variables
  2879                                  ;  200 var sign byte   515 NULL c = bp+4;
  2880 00000EF9 C8000000                 ENTER  0,0
  2881 00000EFD E86A02                   call skipBlank
  2882                                  
  2883                                  ;-517     if (*InputPtr == c) {
  2884                                  
  2885 00000F00 8B1E[1400]               mov bx, [InputPtr]
  2886 00000F04 8A07                     mov al, [bx]
  2887 00000F06 B400                     mov ah, 0
  2888 00000F08 3A4604                   cmp al, [bp+4]
  2889 00000F0B 0F850A00                 jne .isToken125
  2890                                  
  2891                                  ;-518         InputPtr++;
  2892                                  
  2893 00000F0F FF06[1400]               inc  word[InputPtr]
  2894                                  
  2895                                  ;-519         return 1;
  2896                                  
  2897 00000F13 B80100                   mov ax, 1
  2898 00000F16 E90600                   jmp .retnisToken
  2899                                  
  2900                                  ;-520         }
  2901                                  
  2902                                  
  2903                                  ;-521     return 0;
  2904                                  
  2905                                  .isToken125:
  2906 00000F19 B80000                   mov ax, 0
  2907 00000F1C E90000                   jmp .retnisToken
  2908                                  
  2909                                  ;-522 }
  2910                                  
  2911                                  
  2912                                  ;-523 int need(char c) {
  2913                                  
  2914 00000F1F C9                       .retnisToken: LEAVE
  2915 00000F20 C3                       ret
  2916                                  ENDP
  2917                                  
  2918                                  need: PROC
  2919                                  
  2920                                  ;-524     if (isToken(c)) {
  2921                                  
  2922                                  ;Function : need, Number of local variables: 1
  2923                                  ;   # type sign width addr used name   list of local variables
  2924                                  ;  200 var sign byte   523 NULL c = bp+4;
  2925 00000F21 C8000000                 ENTER  0,0
  2926 00000F25 8A4604                   mov al, byte [bp+4]
  2927 00000F28 B400                     mov ah, 0
  2928 00000F2A 50                       push ax
  2929 00000F2B E8CBFF                   call isToken
  2930 00000F2E 83C402                   add  sp, 2
  2931 00000F31 08C0                     or  al, al
  2932 00000F33 0F840600                 je .need126
  2933                                  
  2934                                  ;-525         getTokeType();
  2935                                  
  2936 00000F37 E82CFB                   call getTokeType
  2937                                  
  2938                                  ;-526         return;
  2939                                  
  2940 00000F3A E91800                   jmp .retnneed
  2941                                  
  2942                                  ;-527         }
  2943                                  
  2944                                  
  2945                                  ;-528     error1();
  2946                                  
  2947                                  .need126:
  2948 00000F3D E8640B                   call error1
  2949                                  
  2950                                  ;-529     prs(". need: ");
  2951                                  
  2952 00000F40 68[570F]                 push need_0
  2953 00000F43 E80C0A                   call prs
  2954 00000F46 83C402                   add  sp, 2
  2955                                  
  2956                                  ;-530     prc(c);
  2957                                  
  2958 00000F49 8A4604                   mov al, byte [bp+4]
  2959 00000F4C B400                     mov ah, 0
  2960 00000F4E 50                       push ax
  2961 00000F4F E8A809                   call prc
  2962 00000F52 83C402                   add  sp, 2
  2963                                  
  2964                                  ;-531 }
  2965                                  
  2966                                  
  2967                                  ;-532 int skipRest() {
  2968                                  
  2969 00000F55 C9                       .retnneed: LEAVE
  2970 00000F56 C3                       ret
  2971 00000F57 2E206E6565643A2000      need_0 db ". need: ",0
  2972                                  ENDP
  2973                                  
  2974                                  skipRest: PROC
  2975                                  
  2976                                  ;-533     getTokeType();
  2977                                  
  2978 00000F60 E803FB                   call getTokeType
  2979                                  
  2980                                  ;-534     if(TokeType)error1("extra char ignored");
  2981                                  
  2982 00000F63 A0[2C00]                 mov al, [TokeType]
  2983 00000F66 08C0                     or  al, al
  2984 00000F68 0F840900                 je .skipRest127
  2985 00000F6C 68[760F]                 push skipRest_0
  2986 00000F6F E8320B                   call error1
  2987 00000F72 83C402                   add  sp, 2
  2988                                  
  2989                                  ;-535 }
  2990                                  
  2991                                  .skipRest127:
  2992                                  
  2993                                  ;-536 
  2994                                  
  2995                                  
  2996                                  ;-537 
  2997                                  
  2998                                  
  2999                                  ;-538 //#include "HELPER.C"
  3000                                  
  3001                                  
  3002                                  ;-539 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  3003                                  
  3004 00000F75 C3                       ret
  3005 00000F76 657874726120636861-     skipRest_0 db "extra char ignored",0
  3006 00000F7F 722069676E6F726564-
  3007 00000F88 00                 
  3008                                  ENDP
  3009                                  
  3010                                  writetty: PROC
  3011 00000F89 B40E                     mov  ah, 14
  3012 00000F8B BB0000                   mov  bx, 0
  3013 00000F8E CD10                     db 205,16
  3014                                  
  3015                                  ;-540 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  3016                                  
  3017 00000F90 C3                       ret
  3018                                  ENDP
  3019                                  
  3020                                  putch: PROC
  3021                                  ;Function : putch, Number of local variables: 1
  3022                                  ;   # type sign width addr used name   list of local variables
  3023                                  ;  200 var sign byte   540 NULL c = bp+4;
  3024 00000F91 C8000000                 ENTER  0,0 ; constant expression
  3025 00000F95 807E040A                cmp byte[bp+4], 10
  3026 00000F99 0F850500                 jne .putch128
  3027 00000F9D B00D                     mov  al, 13
  3028 00000F9F E8E7FF                   call writetty
  3029                                  .putch128:
  3030 00000FA2 8A4604                   mov  al, [bp+4]
  3031 00000FA5 E8E1FF                   call writetty
  3032                                  
  3033                                  ;-541 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3034 00000FA8 C9                       LEAVE
  3035 00000FA9 C3                       ret
  3036                                  ENDP
  3037                                  
  3038                                  cputs: PROC
  3039                                  ;Function : cputs, Number of local variables: 2
  3040                                  ;   # type sign width addr used name   list of local variables
  3041                                  ;  200 ptr sign byte   541 NULL s = bp+4
  3042                                  ;  201 var sign byte   541 NULL c = bp-2;
  3043 00000FAA C8020000                 ENTER  2,0
  3044                                  .cputs129:
  3045 00000FAE 8B5E04                   mov bx, [bp+4]
  3046 00000FB1 8A07                     mov al, [bx]
  3047 00000FB3 B400                     mov ah, 0
  3048 00000FB5 08C0                     or  al, al
  3049 00000FB7 0F841B00                 je .cputs130
  3050 00000FBB 8B5E04                   mov bx, [bp+4]
  3051 00000FBE 8A07                     mov al, [bx]
  3052 00000FC0 B400                     mov ah, 0
  3053 00000FC2 8846FE                   mov [bp-2], al
  3054 00000FC5 8A46FE                   mov al, byte [bp-2]
  3055 00000FC8 B400                     mov ah, 0
  3056 00000FCA 50                       push ax
  3057 00000FCB E8C3FF                   call putch
  3058 00000FCE 83C402                   add  sp, 2
  3059 00000FD1 FF4604                   inc  word[bp+4]
  3060 00000FD4 EBD8                     jmp .cputs129
  3061                                  .cputs130:
  3062                                  
  3063                                  ;-542 
  3064                                  
  3065                                  
  3066                                  ;-543 int DosInt() {
  3067 00000FD6 C9                       LEAVE
  3068 00000FD7 C3                       ret
  3069                                  ENDP
  3070                                  
  3071                                  DosInt: PROC
  3072                                  
  3073                                  ;-544     __emit__(0xCD,0x21);//inth 0x21;
  3074                                  
  3075 00000FD8 CD21                     db 205,33
  3076                                  
  3077                                  ;-545     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3078                                  
  3079 00000FDA 7304                     db 115,4
  3080                                  
  3081                                  ;-546     DOS_ERR++;
  3082                                  
  3083 00000FDC FF06[1C00]               inc  word[DOS_ERR]
  3084                                  
  3085                                  ;-547 }
  3086                                  
  3087                                  
  3088                                  ;-548 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3089                                  
  3090 00000FE0 C3                       ret
  3091                                  ENDP
  3092                                  
  3093                                  openR: PROC
  3094                                  ;Function : openR, Number of local variables: 1
  3095                                  ;   # type sign width addr used name   list of local variables
  3096                                  ;  200 ptr sign byte   548 NULL s = bp+4;
  3097 00000FE1 C8000000                 ENTER  0,0
  3098 00000FE5 8B5604                   mov  dx, [bp+4]
  3099 00000FE8 B8023D                   mov  ax, 15618
  3100 00000FEB E8EAFF                   call DosInt
  3101                                  
  3102                                  ;-549 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3103 00000FEE C9                       LEAVE
  3104 00000FEF C3                       ret
  3105                                  ENDP
  3106                                  
  3107                                  creatR: PROC
  3108                                  ;Function : creatR, Number of local variables: 1
  3109                                  ;   # type sign width addr used name   list of local variables
  3110                                  ;  200 ptr sign byte   549 NULL s = bp+4;
  3111 00000FF0 C8000000                 ENTER  0,0
  3112 00000FF4 8B5604                   mov  dx, [bp+4]
  3113 00000FF7 B90000                   mov  cx, 0
  3114 00000FFA B8003C                   mov  ax, 15360
  3115 00000FFD E8D8FF                   call DosInt
  3116                                  
  3117                                  ;-550 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3118 00001000 C9                       LEAVE
  3119 00001001 C3                       ret
  3120                                  ENDP
  3121                                  
  3122                                  fcloseR: PROC
  3123                                  ;Function : fcloseR, Number of local variables: 1
  3124                                  ;   # type sign width addr used name   list of local variables
  3125                                  ;  200 var sign word   550 NULL fd = bp+4;
  3126 00001002 C8000000                 ENTER  0,0
  3127 00001006 8B5E04                   mov  bx, [bp+4]
  3128 00001009 B8003E                   mov  ax, 15872
  3129 0000100C E8C9FF                   call DosInt
  3130                                  
  3131                                  ;-551 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3132 0000100F C9                       LEAVE
  3133 00001010 C3                       ret
  3134                                  ENDP
  3135                                  
  3136                                  exitR: PROC
  3137                                  ;Function : exitR, Number of local variables: 1
  3138                                  ;   # type sign width addr used name   list of local variables
  3139                                  ;  200 var sign byte   551 NULL c = bp+4;
  3140 00001011 C8000000                 ENTER  0,0
  3141 00001015 B44C                     mov  ah, 76
  3142 00001017 8A4604                   mov  al, [bp+4]
  3143 0000101A E8BBFF                   call DosInt
  3144                                  
  3145                                  ;-552 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3146 0000101D C9                       LEAVE
  3147 0000101E C3                       ret
  3148                                  ENDP
  3149                                  
  3150                                  readRL: PROC
  3151                                  ;Function : readRL, Number of local variables: 3
  3152                                  ;   # type sign width addr used name   list of local variables
  3153                                  ;  200 ptr sign byte   552 NULL s = bp+4
  3154                                  ;  201 var sign word   552 NULL fd = bp+6
  3155                                  ;  202 var sign word   552 NULL len = bp+8;
  3156 0000101F C8000000                 ENTER  0,0
  3157 00001023 8B5604                   mov  dx, [bp+4]
  3158 00001026 8B4E08                   mov  cx, [bp+8]
  3159 00001029 8B5E06                   mov  bx, [bp+6]
  3160 0000102C B8003F                   mov  ax, 16128
  3161 0000102F E8A6FF                   call DosInt
  3162                                  
  3163                                  ;-553 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3164 00001032 C9                       LEAVE
  3165 00001033 C3                       ret
  3166                                  ENDP
  3167                                  
  3168                                  fputcR: PROC
  3169                                  ;Function : fputcR, Number of local variables: 2
  3170                                  ;   # type sign width addr used name   list of local variables
  3171                                  ;  200 ptr sign byte   553 NULL n = bp+4
  3172                                  ;  201 var sign word   553 NULL fd = bp+6;
  3173 00001034 C8000000                 ENTER  0,0
  3174 00001038 8D5604                  lea dx, [bp+4]
  3175                                  
  3176                                  ;-554   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3177                                  
  3178 0000103B B90100                   mov  cx, 1
  3179 0000103E 8B5E06                   mov  bx, [bp+6]
  3180 00001041 B80040                   mov  ax, 16384
  3181 00001044 E891FF                   call DosInt
  3182                                  
  3183                                  ;-555 
  3184                                  
  3185                                  
  3186                                  ;-556 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3187 00001047 C9                       LEAVE
  3188 00001048 C3                       ret
  3189                                  ENDP
  3190                                  
  3191                                  getLine: PROC
  3192                                  
  3193                                  ;-557   unsigned int i;
  3194                                  
  3195                                  
  3196                                  ;-558   InputPtr= &InputBuf;
  3197                                  
  3198                                  ;Function : getLine, Number of local variables: 1
  3199                                  ;   # type sign width addr used name   list of local variables
  3200                                  ;  200 var unsg word   557 NULL i = bp-2;
  3201 00001049 C8020000                 ENTER  2,0
  3202 0000104D B88D75                   mov ax, InputBuf
  3203 00001050 A3[1400]                 mov word [InputPtr], ax
  3204                                  
  3205                                  ;-559   *InputPtr=0;//if last line is empty
  3206                                  
  3207 00001053 B80000                   mov ax, 0
  3208 00001056 8B1E[1400]               mov  bx, [InputPtr]
  3209 0000105A 8807                     mov  [bx], al
  3210                                  
  3211                                  ;-560   do {
  3212                                  
  3213                                  .getLine131:
  3214                                  
  3215                                  ;-561     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3216                                  
  3217 0000105C 6A01                     push 1
  3218 0000105E FF36[1600]               push word [asm_fd]
  3219 00001062 8D06[2200]               lea  ax, [DOS_ByteRead]
  3220 00001066 50                       push ax
  3221 00001067 E8B5FF                   call readRL
  3222 0000106A 83C406                   add  sp, 6
  3223 0000106D A3[2000]                 mov word [DOS_NoBytes], ax
  3224                                  
  3225                                  ;-562     if (DOS_ERR) errorexit("Reading Source");
  3226                                  
  3227 00001070 A1[1C00]                 mov ax, [DOS_ERR]
  3228 00001073 08C0                     or  al, al
  3229 00001075 0F840900                 je .getLine132
  3230 00001079 68[DB10]                 push getLine_0
  3231 0000107C E87B0A                   call errorexit
  3232 0000107F 83C402                   add  sp, 2
  3233                                  
  3234                                  ;-563     if (DOS_NoBytes == 0) return;
  3235                                  
  3236                                  .getLine132:
  3237 00001082 A1[2000]                 mov ax, [DOS_NoBytes]
  3238 00001085 83F800                   cmp ax, 0
  3239 00001088 0F850300                 jne .getLine133
  3240 0000108C E94A00                   jmp .retngetLine
  3241                                  
  3242                                  ;-564     *InputPtr = DOS_ByteRead;
  3243                                  
  3244                                  .getLine133:
  3245 0000108F A0[2200]                 mov al, [DOS_ByteRead]
  3246 00001092 8B1E[1400]               mov  bx, [InputPtr]
  3247 00001096 8807                     mov  [bx], al
  3248                                  
  3249                                  ;-565     InputPtr++;
  3250                                  
  3251 00001098 FF06[1400]               inc  word[InputPtr]
  3252                                  
  3253                                  ;-566     i = InputPtr - &InputBuf;
  3254                                  
  3255 0000109C A1[1400]                 mov ax, [InputPtr]
  3256 0000109F 2D8D75                   sub ax, InputBuf
  3257 000010A2 8946FE                   mov [bp-2], ax
  3258                                  
  3259                                  ;-567     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3260                                  
  3261 000010A5 8B46FE                   mov ax, [bp-2]
  3262 000010A8 3DFF00                   cmp ax, 255 ;unsigned : 0
  3263 000010AB 0F820900                 jb  .getLine134
  3264 000010AF 68[EA10]                 push getLine_1
  3265 000010B2 E8450A                   call errorexit
  3266 000010B5 83C402                   add  sp, 2
  3267                                  
  3268                                  ;-568   } while (ifEOL(DOS_ByteRead) == 0);
  3269                                  
  3270                                  .getLine134:
  3271 000010B8 A0[2200]                 mov al, byte [DOS_ByteRead]
  3272 000010BB B400                     mov ah, 0
  3273 000010BD 50                       push ax
  3274 000010BE E83D00                   call ifEOL
  3275 000010C1 83C402                   add  sp, 2
  3276 000010C4 3C00                     cmp al, 0
  3277 000010C6 0F850200                 jne .getLine135
  3278 000010CA EB90                     jmp .getLine131
  3279                                  .getLine135:
  3280                                  
  3281                                  ;-569   InputPtr--;
  3282                                  
  3283 000010CC FF0E[1400]               dec  word[InputPtr]
  3284                                  
  3285                                  ;-570   *InputPtr=0;
  3286                                  
  3287 000010D0 B80000                   mov ax, 0
  3288 000010D3 8B1E[1400]               mov  bx, [InputPtr]
  3289 000010D7 8807                     mov  [bx], al
  3290                                  
  3291                                  ;-571 }
  3292                                  
  3293                                  
  3294                                  ;-572 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3295                                  
  3296 000010D9 C9                       .retngetLine: LEAVE
  3297 000010DA C3                       ret
  3298 000010DB 52656164696E672053-     getLine_0 db "Reading Source",0
  3299 000010E4 6F7572636500       
  3300 000010EA 696E707574206C696E-     getLine_1 db "input line too long",0
  3301 000010F3 6520746F6F206C6F6E-
  3302 000010FC 6700               
  3303                                  ENDP
  3304                                  
  3305                                  ifEOL: PROC
  3306                                  
  3307                                  ;-573   if (c == 10) return 1;//LF
  3308                                  
  3309                                  ;Function : ifEOL, Number of local variables: 1
  3310                                  ;   # type sign width addr used name   list of local variables
  3311                                  ;  200 var sign byte   572 NULL c = bp+4;
  3312 000010FE C8000000                 ENTER  0,0
  3313 00001102 8A4604                   mov al, [bp+4]
  3314 00001105 3C0A                     cmp al, 10
  3315 00001107 0F850600                 jne .ifEOL136
  3316 0000110B B80100                   mov ax, 1
  3317 0000110E E93B00                   jmp .retnifEOL
  3318                                  
  3319                                  ;-574   if (c == 13) {//CR
  3320                                  
  3321                                  .ifEOL136:
  3322 00001111 8A4604                   mov al, [bp+4]
  3323 00001114 3C0D                     cmp al, 13
  3324 00001116 0F852C00                 jne .ifEOL137
  3325                                  
  3326                                  ;-575     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3327                                  
  3328 0000111A 6A01                     push 1
  3329 0000111C FF36[1600]               push word [asm_fd]
  3330 00001120 8D06[2200]               lea  ax, [DOS_ByteRead]
  3331 00001124 50                       push ax
  3332 00001125 E8F7FE                   call readRL
  3333 00001128 83C406                   add  sp, 6
  3334 0000112B A3[2000]                 mov word [DOS_NoBytes], ax
  3335                                  
  3336                                  ;-576     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3337                                  
  3338 0000112E A0[2200]                 mov al, [DOS_ByteRead]
  3339 00001131 3C0A                     cmp al, 10
  3340 00001133 0F840900                 je  .ifEOL138
  3341 00001137 68[4E11]                 push ifEOL_0
  3342 0000113A E8BD09                   call errorexit
  3343 0000113D 83C402                   add  sp, 2
  3344                                  
  3345                                  ;-577     return 1;
  3346                                  
  3347                                  .ifEOL138:
  3348 00001140 B80100                   mov ax, 1
  3349 00001143 E90600                   jmp .retnifEOL
  3350                                  
  3351                                  ;-578   }
  3352                                  
  3353                                  
  3354                                  ;-579   return 0;
  3355                                  
  3356                                  .ifEOL137:
  3357 00001146 B80000                   mov ax, 0
  3358 00001149 E90000                   jmp .retnifEOL
  3359                                  
  3360                                  ;-580 }
  3361                                  
  3362                                  
  3363                                  ;-581 int skipBlank() {
  3364                                  
  3365 0000114C C9                       .retnifEOL: LEAVE
  3366 0000114D C3                       ret
  3367 0000114E 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3368 00001157 462831302920616674-
  3369 00001160 657220435228313329-
  3370 00001169 00                 
  3371                                  ENDP
  3372                                  
  3373                                  skipBlank: PROC
  3374                                  
  3375                                  ;-582   skipblank1:
  3376                                  
  3377                                  .skipblank1:
  3378                                  
  3379                                  ;-583     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3380                                  
  3381 0000116A 8B1E[1400]               mov bx, [InputPtr]
  3382 0000116E 8A07                     mov al, [bx]
  3383 00001170 B400                     mov ah, 0
  3384 00001172 83F820                   cmp ax, 32
  3385 00001175 0F850600                 jne .skipBlank139
  3386 00001179 FF06[1400]               inc  word[InputPtr]
  3387 0000117D EBEB                     jmp .skipblank1
  3388                                  
  3389                                  ;-584     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3390                                  
  3391                                  .skipBlank139:
  3392 0000117F 8B1E[1400]               mov bx, [InputPtr]
  3393 00001183 8A07                     mov al, [bx]
  3394 00001185 B400                     mov ah, 0
  3395 00001187 83F809                   cmp ax, 9
  3396 0000118A 0F850600                 jne .skipBlank140
  3397 0000118E FF06[1400]               inc  word[InputPtr]
  3398 00001192 EBD6                     jmp .skipblank1
  3399                                  
  3400                                  ;-585 }
  3401                                  
  3402                                  .skipBlank140:
  3403                                  
  3404                                  ;-586 int letterE(char c) {
  3405                                  
  3406 00001194 C3                       ret
  3407                                  ENDP
  3408                                  
  3409                                  letterE: PROC
  3410                                  
  3411                                  ;-587   if (c=='_') return 1;
  3412                                  
  3413                                  ;Function : letterE, Number of local variables: 1
  3414                                  ;   # type sign width addr used name   list of local variables
  3415                                  ;  200 var sign byte   586 NULL c = bp+4;
  3416 00001195 C8000000                 ENTER  0,0
  3417 00001199 8A4604                   mov al, [bp+4]
  3418 0000119C 3C5F                     cmp al, 95
  3419 0000119E 0F850600                 jne .letterE141
  3420 000011A2 B80100                   mov ax, 1
  3421 000011A5 E96900                   jmp .retnletterE
  3422                                  
  3423                                  ;-588   if (c=='.') return 1;
  3424                                  
  3425                                  .letterE141:
  3426 000011A8 8A4604                   mov al, [bp+4]
  3427 000011AB 3C2E                     cmp al, 46
  3428 000011AD 0F850600                 jne .letterE142
  3429 000011B1 B80100                   mov ax, 1
  3430 000011B4 E95A00                   jmp .retnletterE
  3431                                  
  3432                                  ;-589   if (c=='?') return 1;
  3433                                  
  3434                                  .letterE142:
  3435 000011B7 8A4604                   mov al, [bp+4]
  3436 000011BA 3C3F                     cmp al, 63
  3437 000011BC 0F850600                 jne .letterE143
  3438 000011C0 B80100                   mov ax, 1
  3439 000011C3 E94B00                   jmp .retnletterE
  3440                                  
  3441                                  ;-590   if (c=='$') return 1;
  3442                                  
  3443                                  .letterE143:
  3444 000011C6 8A4604                   mov al, [bp+4]
  3445 000011C9 3C24                     cmp al, 36
  3446 000011CB 0F850600                 jne .letterE144
  3447 000011CF B80100                   mov ax, 1
  3448 000011D2 E93C00                   jmp .retnletterE
  3449                                  
  3450                                  ;-591   if (c> 'z') return 0;
  3451                                  
  3452                                  .letterE144:
  3453 000011D5 8A4604                   mov al, [bp+4]
  3454 000011D8 3C7A                     cmp al, 122
  3455 000011DA 0F8E0600                 jle .letterE145
  3456 000011DE B80000                   mov ax, 0
  3457 000011E1 E92D00                   jmp .retnletterE
  3458                                  
  3459                                  ;-592   if (c< '@') return 0; // at included
  3460                                  
  3461                                  .letterE145:
  3462 000011E4 8A4604                   mov al, [bp+4]
  3463 000011E7 3C40                     cmp al, 64
  3464 000011E9 0F8D0600                 jge .letterE146
  3465 000011ED B80000                   mov ax, 0
  3466 000011F0 E91E00                   jmp .retnletterE
  3467                                  
  3468                                  ;-593   if (c> 'Z') { if (c< 'a') return 0; }
  3469                                  
  3470                                  .letterE146:
  3471 000011F3 8A4604                   mov al, [bp+4]
  3472 000011F6 3C5A                     cmp al, 90
  3473 000011F8 0F8E0F00                 jle .letterE147
  3474 000011FC 8A4604                   mov al, [bp+4]
  3475 000011FF 3C61                     cmp al, 97
  3476 00001201 0F8D0600                 jge .letterE148
  3477 00001205 B80000                   mov ax, 0
  3478 00001208 E90600                   jmp .retnletterE
  3479                                  .letterE148:
  3480                                  
  3481                                  ;-594   return 1;
  3482                                  
  3483                                  .letterE147:
  3484 0000120B B80100                   mov ax, 1
  3485 0000120E E90000                   jmp .retnletterE
  3486                                  
  3487                                  ;-595 }
  3488                                  
  3489                                  
  3490                                  ;-596 int alnumE(char c) {
  3491                                  
  3492 00001211 C9                       .retnletterE: LEAVE
  3493 00001212 C3                       ret
  3494                                  ENDP
  3495                                  
  3496                                  alnumE: PROC
  3497                                  
  3498                                  ;-597   if (digit(c)) return 1;
  3499                                  
  3500                                  ;Function : alnumE, Number of local variables: 1
  3501                                  ;   # type sign width addr used name   list of local variables
  3502                                  ;  200 var sign byte   596 NULL c = bp+4;
  3503 00001213 C8000000                 ENTER  0,0
  3504 00001217 8A4604                   mov al, byte [bp+4]
  3505 0000121A B400                     mov ah, 0
  3506 0000121C 50                       push ax
  3507 0000121D E82F00                   call digit
  3508 00001220 83C402                   add  sp, 2
  3509 00001223 08C0                     or  al, al
  3510 00001225 0F840600                 je .alnumE149
  3511 00001229 B80100                   mov ax, 1
  3512 0000122C E91E00                   jmp .retnalnumE
  3513                                  
  3514                                  ;-598   if (letterE(c)) return 1;
  3515                                  
  3516                                  .alnumE149:
  3517 0000122F 8A4604                   mov al, byte [bp+4]
  3518 00001232 B400                     mov ah, 0
  3519 00001234 50                       push ax
  3520 00001235 E85DFF                   call letterE
  3521 00001238 83C402                   add  sp, 2
  3522 0000123B 08C0                     or  al, al
  3523 0000123D 0F840600                 je .alnumE150
  3524 00001241 B80100                   mov ax, 1
  3525 00001244 E90600                   jmp .retnalnumE
  3526                                  
  3527                                  ;-599   return 0;
  3528                                  
  3529                                  .alnumE150:
  3530 00001247 B80000                   mov ax, 0
  3531 0000124A E90000                   jmp .retnalnumE
  3532                                  
  3533                                  ;-600 }
  3534                                  
  3535                                  
  3536                                  ;-601 int digit(char c){
  3537                                  
  3538 0000124D C9                       .retnalnumE: LEAVE
  3539 0000124E C3                       ret
  3540                                  ENDP
  3541                                  
  3542                                  digit: PROC
  3543                                  
  3544                                  ;-602     if(c<'0') return 0;
  3545                                  
  3546                                  ;Function : digit, Number of local variables: 1
  3547                                  ;   # type sign width addr used name   list of local variables
  3548                                  ;  200 var sign byte   601 NULL c = bp+4;
  3549 0000124F C8000000                 ENTER  0,0
  3550 00001253 8A4604                   mov al, [bp+4]
  3551 00001256 3C30                     cmp al, 48
  3552 00001258 0F8D0600                 jge .digit151
  3553 0000125C B80000                   mov ax, 0
  3554 0000125F E91500                   jmp .retndigit
  3555                                  
  3556                                  ;-603     if(c>'9') return 0;
  3557                                  
  3558                                  .digit151:
  3559 00001262 8A4604                   mov al, [bp+4]
  3560 00001265 3C39                     cmp al, 57
  3561 00001267 0F8E0600                 jle .digit152
  3562 0000126B B80000                   mov ax, 0
  3563 0000126E E90600                   jmp .retndigit
  3564                                  
  3565                                  ;-604     return 1;
  3566                                  
  3567                                  .digit152:
  3568 00001271 B80100                   mov ax, 1
  3569 00001274 E90000                   jmp .retndigit
  3570                                  
  3571                                  ;-605 }
  3572                                  
  3573                                  
  3574                                  ;-606 int strlen(char *s) { int c;
  3575                                  
  3576 00001277 C9                       .retndigit: LEAVE
  3577 00001278 C3                       ret
  3578                                  ENDP
  3579                                  
  3580                                  strlen: PROC
  3581                                  
  3582                                  ;-607     c=0;
  3583                                  
  3584                                  ;Function : strlen, Number of local variables: 2
  3585                                  ;   # type sign width addr used name   list of local variables
  3586                                  ;  200 ptr sign byte   606 NULL s = bp+4
  3587                                  ;  201 var sign word   606 NULL c = bp-2;
  3588 00001279 C8020000                 ENTER  2,0
  3589 0000127D B80000                   mov ax, 0
  3590 00001280 8946FE                   mov [bp-2], ax
  3591                                  
  3592                                  ;-608     while (*s!=0) {s++; c++;}
  3593                                  
  3594                                  .strlen153:
  3595 00001283 8B5E04                   mov bx, [bp+4]
  3596 00001286 8A07                     mov al, [bx]
  3597 00001288 B400                     mov ah, 0
  3598 0000128A 83F800                   cmp ax, 0
  3599 0000128D 0F840800                 je  .strlen154
  3600 00001291 FF4604                   inc  word[bp+4]
  3601 00001294 FF46FE                   inc  word[bp-2]
  3602                                  
  3603                                  ;-609     return c;
  3604                                  
  3605 00001297 EBEA                     jmp .strlen153
  3606                                  .strlen154:
  3607 00001299 8B46FE                   mov ax, [bp-2]
  3608 0000129C E90000                   jmp .retnstrlen
  3609                                  
  3610                                  ;-610     }
  3611                                  
  3612                                  
  3613                                  ;-611 int strcpy(char *s, char *t) {
  3614                                  
  3615 0000129F C9                       .retnstrlen: LEAVE
  3616 000012A0 C3                       ret
  3617                                  ENDP
  3618                                  
  3619                                  strcpy: PROC
  3620                                  
  3621                                  ;-612     do { *s=*t; s++; t++; }
  3622                                  
  3623                                  ;Function : strcpy, Number of local variables: 2
  3624                                  ;   # type sign width addr used name   list of local variables
  3625                                  ;  200 ptr sign byte   611 NULL s = bp+4
  3626                                  ;  201 ptr sign byte   611 NULL t = bp+6;
  3627 000012A1 C8000000                 ENTER  0,0
  3628                                  .strcpy155:
  3629 000012A5 8B5E06                   mov bx, [bp+6]
  3630 000012A8 8A07                     mov al, [bx]
  3631 000012AA B400                     mov ah, 0
  3632 000012AC 8B5E04                   mov  bx, [bp+4]
  3633 000012AF 8807                     mov  [bx], al
  3634 000012B1 FF4604                   inc  word[bp+4]
  3635 000012B4 FF4606                   inc  word[bp+6]
  3636                                  
  3637                                  ;-613     while (*t!=0);
  3638                                  
  3639 000012B7 8B5E06                   mov bx, [bp+6]
  3640 000012BA 8A07                     mov al, [bx]
  3641 000012BC B400                     mov ah, 0
  3642 000012BE 83F800                   cmp ax, 0
  3643 000012C1 0F840200                 je  .strcpy156
  3644 000012C5 EBDE                     jmp .strcpy155
  3645                                  .strcpy156:
  3646                                  
  3647                                  ;-614     *s=0;
  3648                                  
  3649 000012C7 B80000                   mov ax, 0
  3650 000012CA 8B5E04                   mov  bx, [bp+4]
  3651 000012CD 8807                     mov  [bx], al
  3652                                  
  3653                                  ;-615     return s;
  3654                                  
  3655 000012CF 8B4604                   mov ax, [bp+4]
  3656 000012D2 E90000                   jmp .retnstrcpy
  3657                                  
  3658                                  ;-616     }
  3659                                  
  3660                                  
  3661                                  ;-617 int eqstr(char *p, char *q) {
  3662                                  
  3663 000012D5 C9                       .retnstrcpy: LEAVE
  3664 000012D6 C3                       ret
  3665                                  ENDP
  3666                                  
  3667                                  eqstr: PROC
  3668                                  
  3669                                  ;-618     while(*p) {
  3670                                  
  3671                                  ;Function : eqstr, Number of local variables: 2
  3672                                  ;   # type sign width addr used name   list of local variables
  3673                                  ;  200 ptr sign byte   617 NULL p = bp+4
  3674                                  ;  201 ptr sign byte   617 NULL q = bp+6;
  3675 000012D7 C8000000                 ENTER  0,0
  3676                                  .eqstr157:
  3677 000012DB 8B5E04                   mov bx, [bp+4]
  3678 000012DE 8A07                     mov al, [bx]
  3679 000012E0 B400                     mov ah, 0
  3680 000012E2 08C0                     or  al, al
  3681 000012E4 0F842000                 je .eqstr158
  3682                                  
  3683                                  ;-619         if (*p != *q) return 0;
  3684                                  
  3685 000012E8 8B5E04                   mov bx, [bp+4]
  3686 000012EB 8A07                     mov al, [bx]
  3687 000012ED B400                     mov ah, 0
  3688 000012EF 8B5E06                   mov bx, [bp+6]
  3689 000012F2 3A07                     cmp al, [bx]
  3690 000012F4 B400                     mov ah, 0
  3691 000012F6 0F840600                 je  .eqstr159
  3692 000012FA B80000                   mov ax, 0
  3693 000012FD E92100                   jmp .retneqstr
  3694                                  
  3695                                  ;-620             p++;
  3696                                  
  3697                                  .eqstr159:
  3698 00001300 FF4604                   inc  word[bp+4]
  3699                                  
  3700                                  ;-621             q++;
  3701                                  
  3702 00001303 FF4606                   inc  word[bp+6]
  3703                                  
  3704                                  ;-622             }
  3705                                  
  3706                                  
  3707                                  ;-623     if(*q) return 0;
  3708                                  
  3709 00001306 EBD3                     jmp .eqstr157
  3710                                  .eqstr158:
  3711 00001308 8B5E06                   mov bx, [bp+6]
  3712 0000130B 8A07                     mov al, [bx]
  3713 0000130D B400                     mov ah, 0
  3714 0000130F 08C0                     or  al, al
  3715 00001311 0F840600                 je .eqstr160
  3716 00001315 B80000                   mov ax, 0
  3717 00001318 E90600                   jmp .retneqstr
  3718                                  
  3719                                  ;-624     return 1;
  3720                                  
  3721                                  .eqstr160:
  3722 0000131B B80100                   mov ax, 1
  3723 0000131E E90000                   jmp .retneqstr
  3724                                  
  3725                                  ;-625     }
  3726                                  
  3727                                  
  3728                                  ;-626 int strcat1(char *s, char *t) {
  3729                                  
  3730 00001321 C9                       .retneqstr: LEAVE
  3731 00001322 C3                       ret
  3732                                  ENDP
  3733                                  
  3734                                  strcat1: PROC
  3735                                  
  3736                                  ;-627     while (*s != 0) s++;
  3737                                  
  3738                                  ;Function : strcat1, Number of local variables: 2
  3739                                  ;   # type sign width addr used name   list of local variables
  3740                                  ;  200 ptr sign byte   626 NULL s = bp+4
  3741                                  ;  201 ptr sign byte   626 NULL t = bp+6;
  3742 00001323 C8000000                 ENTER  0,0
  3743                                  .strcat1161:
  3744 00001327 8B5E04                   mov bx, [bp+4]
  3745 0000132A 8A07                     mov al, [bx]
  3746 0000132C B400                     mov ah, 0
  3747 0000132E 83F800                   cmp ax, 0
  3748 00001331 0F840500                 je  .strcat1162
  3749 00001335 FF4604                   inc  word[bp+4]
  3750                                  
  3751                                  ;-628     strcpy(s, t);
  3752                                  
  3753 00001338 EBED                     jmp .strcat1161
  3754                                  .strcat1162:
  3755 0000133A FF7606                   push word [bp+6]
  3756 0000133D FF7604                   push word [bp+4]
  3757 00001340 E85EFF                   call strcpy
  3758 00001343 83C404                   add  sp, 4
  3759                                  
  3760                                  ;-629     }
  3761                                  
  3762                                  
  3763                                  ;-630 int toupper(char *s) {
  3764 00001346 C9                       LEAVE
  3765 00001347 C3                       ret
  3766                                  ENDP
  3767                                  
  3768                                  toupper: PROC
  3769                                  
  3770                                  ;-631     while(*s) {
  3771                                  
  3772                                  ;Function : toupper, Number of local variables: 1
  3773                                  ;   # type sign width addr used name   list of local variables
  3774                                  ;  200 ptr sign byte   630 NULL s = bp+4;
  3775 00001348 C8000000                 ENTER  0,0
  3776                                  .toupper163:
  3777 0000134C 8B5E04                   mov bx, [bp+4]
  3778 0000134F 8A07                     mov al, [bx]
  3779 00001351 B400                     mov ah, 0
  3780 00001353 08C0                     or  al, al
  3781 00001355 0F843000                 je .toupper164
  3782                                  
  3783                                  ;-632         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3784                                  
  3785 00001359 8B5E04                   mov bx, [bp+4]
  3786 0000135C 8A07                     mov al, [bx]
  3787 0000135E B400                     mov ah, 0
  3788 00001360 83F861                   cmp ax, 97 ;unsigned : 1
  3789 00001363 0F8C1D00                 jl  .toupper165
  3790 00001367 8B5E04                   mov bx, [bp+4]
  3791 0000136A 8A07                     mov al, [bx]
  3792 0000136C B400                     mov ah, 0
  3793 0000136E 83F87A                   cmp ax, 122
  3794 00001371 0F8F0F00                 jg  .toupper166
  3795 00001375 8B5E04                   mov bx, [bp+4]
  3796 00001378 8A07                     mov al, [bx]
  3797 0000137A B400                     mov ah, 0
  3798 0000137C 83E820                   sub ax, 32
  3799 0000137F 8B5E04                   mov  bx, [bp+4]
  3800 00001382 8807                     mov  [bx], al
  3801                                  
  3802                                  ;-633             s++;
  3803                                  
  3804                                  .toupper166:
  3805                                  .toupper165:
  3806 00001384 FF4604                   inc  word[bp+4]
  3807                                  
  3808                                  ;-634               }
  3809                                  
  3810                                  
  3811                                  ;-635     }
  3812                                  
  3813 00001387 EBC3                     jmp .toupper163
  3814                                  .toupper164:
  3815                                  
  3816                                  ;-636 
  3817                                  
  3818                                  
  3819                                  ;-637 int getDigit(unsigned char c) {//ret: SymbolInt
  3820 00001389 C9                       LEAVE
  3821 0000138A C3                       ret
  3822                                  ENDP
  3823                                  
  3824                                  getDigit: PROC
  3825                                  
  3826                                  ;-638   unsigned int CastInt;
  3827                                  
  3828                                  
  3829                                  ;-639   SymbolInt=0;
  3830                                  
  3831                                  ;Function : getDigit, Number of local variables: 2
  3832                                  ;   # type sign width addr used name   list of local variables
  3833                                  ;  200 var unsg byte   637 NULL c = bp+4
  3834                                  ;  201 var unsg word   638 NULL CastInt = bp-2;
  3835 0000138B C8020000                 ENTER  2,0
  3836 0000138F B80000                   mov ax, 0
  3837 00001392 A3[0E00]                 mov word [SymbolInt], ax
  3838                                  
  3839                                  ;-640   do {
  3840                                  
  3841                                  .getDigit167:
  3842                                  
  3843                                  ;-641     c-='0';
  3844                                  
  3845 00001395 806E0430                 sub  byte[bp+4], 48
  3846                                  
  3847                                  ;-642     SymbolInt=SymbolInt*10;
  3848                                  
  3849 00001399 A1[0E00]                 mov ax, [SymbolInt]
  3850 0000139C BB0A00                   mov bx, 10
  3851 0000139F F7E3                     mul bx
  3852 000013A1 A3[0E00]                 mov word [SymbolInt], ax
  3853                                  
  3854                                  ;-643     ax=0; CastInt=c; //cast b2w
  3855                                  
  3856 000013A4 B80000                   mov  ax, 0
  3857 000013A7 8A4604                   mov al, [bp+4]
  3858 000013AA 8946FE                   mov [bp-2], ax
  3859                                  
  3860                                  ;-644     SymbolInt=SymbolInt+CastInt;
  3861                                  
  3862 000013AD A1[0E00]                 mov ax, [SymbolInt]
  3863 000013B0 0346FE                   add ax, [bp-2]
  3864 000013B3 A3[0E00]                 mov word [SymbolInt], ax
  3865                                  
  3866                                  ;-645     InputPtr++;
  3867                                  
  3868 000013B6 FF06[1400]               inc  word[InputPtr]
  3869                                  
  3870                                  ;-646     c = *InputPtr;
  3871                                  
  3872 000013BA 8B1E[1400]               mov bx, [InputPtr]
  3873 000013BE 8A07                     mov al, [bx]
  3874 000013C0 B400                     mov ah, 0
  3875 000013C2 884604                   mov [bp+4], al
  3876                                  
  3877                                  ;-647   } while(digit(c));
  3878                                  
  3879 000013C5 8A4604                   mov al, byte [bp+4]
  3880 000013C8 B400                     mov ah, 0
  3881 000013CA 50                       push ax
  3882 000013CB E881FE                   call digit
  3883 000013CE 83C402                   add  sp, 2
  3884 000013D1 08C0                     or  al, al
  3885 000013D3 0F840200                 je .getDigit168
  3886 000013D7 EBBC                     jmp .getDigit167
  3887                                  .getDigit168:
  3888                                  
  3889                                  ;-648 }
  3890                                  
  3891                                  
  3892                                  ;-649 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3893 000013D9 C9                       LEAVE
  3894 000013DA C3                       ret
  3895                                  ENDP
  3896                                  
  3897                                  getName: PROC
  3898                                  
  3899                                  ;-650   char *p; unsigned int i;
  3900                                  
  3901                                  
  3902                                  ;-651   p = &Symbol;
  3903                                  
  3904                                  ;Function : getName, Number of local variables: 3
  3905                                  ;   # type sign width addr used name   list of local variables
  3906                                  ;  200 var unsg byte   649 NULL c = bp+4
  3907                                  ;  201 ptr sign byte   650 NULL p = bp-2
  3908                                  ;  202 var unsg word   650 NULL i = bp-4;
  3909 000013DB C8040000                 ENTER  4,0
  3910 000013DF B83075                   mov ax, Symbol
  3911 000013E2 8946FE                   mov [bp-2], ax
  3912                                  
  3913                                  ;-652   *p = c;
  3914                                  
  3915 000013E5 8A4604                   mov al, [bp+4]
  3916 000013E8 8B5EFE                   mov  bx, [bp-2]
  3917 000013EB 8807                     mov  [bx], al
  3918                                  
  3919                                  ;-653   p++;
  3920                                  
  3921 000013ED FF46FE                   inc  word[bp-2]
  3922                                  
  3923                                  ;-654   while (alnumE(c)) {
  3924                                  
  3925                                  .getName169:
  3926 000013F0 8A4604                   mov al, byte [bp+4]
  3927 000013F3 B400                     mov ah, 0
  3928 000013F5 50                       push ax
  3929 000013F6 E81AFE                   call alnumE
  3930 000013F9 83C402                   add  sp, 2
  3931 000013FC 08C0                     or  al, al
  3932 000013FE 0F843800                 je .getName170
  3933                                  
  3934                                  ;-655     InputPtr++;
  3935                                  
  3936 00001402 FF06[1400]               inc  word[InputPtr]
  3937                                  
  3938                                  ;-656     c = *InputPtr;
  3939                                  
  3940 00001406 8B1E[1400]               mov bx, [InputPtr]
  3941 0000140A 8A07                     mov al, [bx]
  3942 0000140C B400                     mov ah, 0
  3943 0000140E 884604                   mov [bp+4], al
  3944                                  
  3945                                  ;-657     *p = c;
  3946                                  
  3947 00001411 8A4604                   mov al, [bp+4]
  3948 00001414 8B5EFE                   mov  bx, [bp-2]
  3949 00001417 8807                     mov  [bx], al
  3950                                  
  3951                                  ;-658     p++;
  3952                                  
  3953 00001419 FF46FE                   inc  word[bp-2]
  3954                                  
  3955                                  ;-659     i = p - &Symbol;
  3956                                  
  3957 0000141C 8B46FE                   mov ax, [bp-2]
  3958 0000141F 2D3075                   sub ax, Symbol
  3959 00001422 8946FC                   mov [bp-4], ax
  3960                                  
  3961                                  ;-660     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3962                                  
  3963 00001425 8B46FC                   mov ax, [bp-4]
  3964 00001428 83F81F                   cmp ax, 31 ;unsigned : 0
  3965 0000142B 0F820900                 jb  .getName171
  3966 0000142F 68[7A14]                 push getName_0
  3967 00001432 E8C506                   call errorexit
  3968 00001435 83C402                   add  sp, 2
  3969                                  
  3970                                  ;-661   }
  3971                                  
  3972                                  .getName171:
  3973                                  
  3974                                  ;-662   if (c == ':') isLabel=1; else isLabel=0;
  3975                                  
  3976 00001438 EBB6                     jmp .getName169
  3977                                  .getName170:
  3978 0000143A 8A4604                   mov al, [bp+4]
  3979 0000143D 3C3A                     cmp al, 58
  3980 0000143F 0F850900                 jne .getName172
  3981 00001443 B80100                   mov ax, 1
  3982 00001446 A2[2B00]                 mov byte [isLabel], al
  3983 00001449 E90600                   jmp .getName173
  3984                                  .getName172:
  3985 0000144C B80000                   mov ax, 0
  3986 0000144F A2[2B00]                 mov byte [isLabel], al
  3987                                  
  3988                                  ;-663   p--;
  3989                                  
  3990                                  .getName173:
  3991 00001452 FF4EFE                   dec  word[bp-2]
  3992                                  
  3993                                  ;-664   *p = 0;
  3994                                  
  3995 00001455 B80000                   mov ax, 0
  3996 00001458 8B5EFE                   mov  bx, [bp-2]
  3997 0000145B 8807                     mov  [bx], al
  3998                                  
  3999                                  ;-665   strcpy(SymbolUpper, Symbol);
  4000                                  
  4001 0000145D 8D063075                 lea  ax, [Symbol]
  4002 00001461 50                       push ax
  4003 00001462 8D064F75                 lea  ax, [SymbolUpper]
  4004 00001466 50                       push ax
  4005 00001467 E837FE                   call strcpy
  4006 0000146A 83C404                   add  sp, 4
  4007                                  
  4008                                  ;-666   toupper(SymbolUpper);
  4009                                  
  4010 0000146D 8D064F75                 lea  ax, [SymbolUpper]
  4011 00001471 50                       push ax
  4012 00001472 E8D3FE                   call toupper
  4013 00001475 83C402                   add  sp, 2
  4014                                  
  4015                                  ;-667 }
  4016                                  
  4017                                  
  4018                                  ;-668 int testReg() {
  4019 00001478 C9                       LEAVE
  4020 00001479 C3                       ret
  4021 0000147A 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4022 00001483 6F206C6F6E6700     
  4023                                  ENDP
  4024                                  
  4025                                  testReg: PROC
  4026                                  
  4027                                  ;-669 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4028                                  
  4029                                  
  4030                                  ;-670   R2Type=0;
  4031                                  
  4032 0000148A B80000                   mov ax, 0
  4033 0000148D A2[3500]                 mov byte [R2Type], al
  4034                                  
  4035                                  ;-671   if (strlen(Symbol) < 2) return 0;
  4036                                  
  4037 00001490 8D063075                 lea  ax, [Symbol]
  4038 00001494 50                       push ax
  4039 00001495 E8E1FD                   call strlen
  4040 00001498 83C402                   add  sp, 2
  4041 0000149B 3C02                     cmp al, 2
  4042 0000149D 0F8D0600                 jge .testReg174
  4043 000014A1 B80000                   mov ax, 0
  4044 000014A4 E94703                   jmp .retntestReg
  4045                                  
  4046                                  ;-672   if (strlen(Symbol) > 3) return 0;
  4047                                  
  4048                                  .testReg174:
  4049 000014A7 8D063075                 lea  ax, [Symbol]
  4050 000014AB 50                       push ax
  4051 000014AC E8CAFD                   call strlen
  4052 000014AF 83C402                   add  sp, 2
  4053 000014B2 3C03                     cmp al, 3
  4054 000014B4 0F8E0600                 jle .testReg175
  4055 000014B8 B80000                   mov ax, 0
  4056 000014BB E93003                   jmp .retntestReg
  4057                                  
  4058                                  ;-673   R2Type=BYTE;
  4059                                  
  4060                                  .testReg175:
  4061 000014BE B80100                   mov ax, 1
  4062 000014C1 A2[3500]                 mov byte [R2Type], al
  4063                                  
  4064                                  ;-674   if (eqstr(SymbolUpper, "AL")) return 0;
  4065                                  
  4066 000014C4 68[EF17]                 push testReg_0
  4067 000014C7 8D064F75                 lea  ax, [SymbolUpper]
  4068 000014CB 50                       push ax
  4069 000014CC E808FE                   call eqstr
  4070 000014CF 83C404                   add  sp, 4
  4071 000014D2 08C0                     or  al, al
  4072 000014D4 0F840600                 je .testReg176
  4073 000014D8 B80000                   mov ax, 0
  4074 000014DB E91003                   jmp .retntestReg
  4075                                  
  4076                                  ;-675   if (eqstr(SymbolUpper, "CL")) return 1;
  4077                                  
  4078                                  .testReg176:
  4079 000014DE 68[F217]                 push testReg_1
  4080 000014E1 8D064F75                 lea  ax, [SymbolUpper]
  4081 000014E5 50                       push ax
  4082 000014E6 E8EEFD                   call eqstr
  4083 000014E9 83C404                   add  sp, 4
  4084 000014EC 08C0                     or  al, al
  4085 000014EE 0F840600                 je .testReg177
  4086 000014F2 B80100                   mov ax, 1
  4087 000014F5 E9F602                   jmp .retntestReg
  4088                                  
  4089                                  ;-676   if (eqstr(SymbolUpper, "DL")) return 2;
  4090                                  
  4091                                  .testReg177:
  4092 000014F8 68[F517]                 push testReg_2
  4093 000014FB 8D064F75                 lea  ax, [SymbolUpper]
  4094 000014FF 50                       push ax
  4095 00001500 E8D4FD                   call eqstr
  4096 00001503 83C404                   add  sp, 4
  4097 00001506 08C0                     or  al, al
  4098 00001508 0F840600                 je .testReg178
  4099 0000150C B80200                   mov ax, 2
  4100 0000150F E9DC02                   jmp .retntestReg
  4101                                  
  4102                                  ;-677   if (eqstr(SymbolUpper, "BL")) return 3;
  4103                                  
  4104                                  .testReg178:
  4105 00001512 68[F817]                 push testReg_3
  4106 00001515 8D064F75                 lea  ax, [SymbolUpper]
  4107 00001519 50                       push ax
  4108 0000151A E8BAFD                   call eqstr
  4109 0000151D 83C404                   add  sp, 4
  4110 00001520 08C0                     or  al, al
  4111 00001522 0F840600                 je .testReg179
  4112 00001526 B80300                   mov ax, 3
  4113 00001529 E9C202                   jmp .retntestReg
  4114                                  
  4115                                  ;-678   if (eqstr(SymbolUpper, "AH")) return 4;
  4116                                  
  4117                                  .testReg179:
  4118 0000152C 68[FB17]                 push testReg_4
  4119 0000152F 8D064F75                 lea  ax, [SymbolUpper]
  4120 00001533 50                       push ax
  4121 00001534 E8A0FD                   call eqstr
  4122 00001537 83C404                   add  sp, 4
  4123 0000153A 08C0                     or  al, al
  4124 0000153C 0F840600                 je .testReg180
  4125 00001540 B80400                   mov ax, 4
  4126 00001543 E9A802                   jmp .retntestReg
  4127                                  
  4128                                  ;-679   if (eqstr(SymbolUpper, "CH")) return 5;
  4129                                  
  4130                                  .testReg180:
  4131 00001546 68[FE17]                 push testReg_5
  4132 00001549 8D064F75                 lea  ax, [SymbolUpper]
  4133 0000154D 50                       push ax
  4134 0000154E E886FD                   call eqstr
  4135 00001551 83C404                   add  sp, 4
  4136 00001554 08C0                     or  al, al
  4137 00001556 0F840600                 je .testReg181
  4138 0000155A B80500                   mov ax, 5
  4139 0000155D E98E02                   jmp .retntestReg
  4140                                  
  4141                                  ;-680   if (eqstr(SymbolUpper, "DH")) return 6;
  4142                                  
  4143                                  .testReg181:
  4144 00001560 68[0118]                 push testReg_6
  4145 00001563 8D064F75                 lea  ax, [SymbolUpper]
  4146 00001567 50                       push ax
  4147 00001568 E86CFD                   call eqstr
  4148 0000156B 83C404                   add  sp, 4
  4149 0000156E 08C0                     or  al, al
  4150 00001570 0F840600                 je .testReg182
  4151 00001574 B80600                   mov ax, 6
  4152 00001577 E97402                   jmp .retntestReg
  4153                                  
  4154                                  ;-681   if (eqstr(SymbolUpper, "BH")) return 7;
  4155                                  
  4156                                  .testReg182:
  4157 0000157A 68[0418]                 push testReg_7
  4158 0000157D 8D064F75                 lea  ax, [SymbolUpper]
  4159 00001581 50                       push ax
  4160 00001582 E852FD                   call eqstr
  4161 00001585 83C404                   add  sp, 4
  4162 00001588 08C0                     or  al, al
  4163 0000158A 0F840600                 je .testReg183
  4164 0000158E B80700                   mov ax, 7
  4165 00001591 E95A02                   jmp .retntestReg
  4166                                  
  4167                                  ;-682   R2Type=WORD;
  4168                                  
  4169                                  .testReg183:
  4170 00001594 B80200                   mov ax, 2
  4171 00001597 A2[3500]                 mov byte [R2Type], al
  4172                                  
  4173                                  ;-683   if (eqstr(SymbolUpper, "AX")) return 0;
  4174                                  
  4175 0000159A 68[0718]                 push testReg_8
  4176 0000159D 8D064F75                 lea  ax, [SymbolUpper]
  4177 000015A1 50                       push ax
  4178 000015A2 E832FD                   call eqstr
  4179 000015A5 83C404                   add  sp, 4
  4180 000015A8 08C0                     or  al, al
  4181 000015AA 0F840600                 je .testReg184
  4182 000015AE B80000                   mov ax, 0
  4183 000015B1 E93A02                   jmp .retntestReg
  4184                                  
  4185                                  ;-684   if (eqstr(SymbolUpper, "CX")) return 1;
  4186                                  
  4187                                  .testReg184:
  4188 000015B4 68[0A18]                 push testReg_9
  4189 000015B7 8D064F75                 lea  ax, [SymbolUpper]
  4190 000015BB 50                       push ax
  4191 000015BC E818FD                   call eqstr
  4192 000015BF 83C404                   add  sp, 4
  4193 000015C2 08C0                     or  al, al
  4194 000015C4 0F840600                 je .testReg185
  4195 000015C8 B80100                   mov ax, 1
  4196 000015CB E92002                   jmp .retntestReg
  4197                                  
  4198                                  ;-685   if (eqstr(SymbolUpper, "DX")) return 2;
  4199                                  
  4200                                  .testReg185:
  4201 000015CE 68[0D18]                 push testReg_10
  4202 000015D1 8D064F75                 lea  ax, [SymbolUpper]
  4203 000015D5 50                       push ax
  4204 000015D6 E8FEFC                   call eqstr
  4205 000015D9 83C404                   add  sp, 4
  4206 000015DC 08C0                     or  al, al
  4207 000015DE 0F840600                 je .testReg186
  4208 000015E2 B80200                   mov ax, 2
  4209 000015E5 E90602                   jmp .retntestReg
  4210                                  
  4211                                  ;-686   if (eqstr(SymbolUpper, "BX")) return 3;
  4212                                  
  4213                                  .testReg186:
  4214 000015E8 68[1018]                 push testReg_11
  4215 000015EB 8D064F75                 lea  ax, [SymbolUpper]
  4216 000015EF 50                       push ax
  4217 000015F0 E8E4FC                   call eqstr
  4218 000015F3 83C404                   add  sp, 4
  4219 000015F6 08C0                     or  al, al
  4220 000015F8 0F840600                 je .testReg187
  4221 000015FC B80300                   mov ax, 3
  4222 000015FF E9EC01                   jmp .retntestReg
  4223                                  
  4224                                  ;-687   if (eqstr(SymbolUpper, "SP")) return 4;
  4225                                  
  4226                                  .testReg187:
  4227 00001602 68[1318]                 push testReg_12
  4228 00001605 8D064F75                 lea  ax, [SymbolUpper]
  4229 00001609 50                       push ax
  4230 0000160A E8CAFC                   call eqstr
  4231 0000160D 83C404                   add  sp, 4
  4232 00001610 08C0                     or  al, al
  4233 00001612 0F840600                 je .testReg188
  4234 00001616 B80400                   mov ax, 4
  4235 00001619 E9D201                   jmp .retntestReg
  4236                                  
  4237                                  ;-688   if (eqstr(SymbolUpper, "BP")) return 5;
  4238                                  
  4239                                  .testReg188:
  4240 0000161C 68[1618]                 push testReg_13
  4241 0000161F 8D064F75                 lea  ax, [SymbolUpper]
  4242 00001623 50                       push ax
  4243 00001624 E8B0FC                   call eqstr
  4244 00001627 83C404                   add  sp, 4
  4245 0000162A 08C0                     or  al, al
  4246 0000162C 0F840600                 je .testReg189
  4247 00001630 B80500                   mov ax, 5
  4248 00001633 E9B801                   jmp .retntestReg
  4249                                  
  4250                                  ;-689   if (eqstr(SymbolUpper, "SI")) return 6;
  4251                                  
  4252                                  .testReg189:
  4253 00001636 68[1918]                 push testReg_14
  4254 00001639 8D064F75                 lea  ax, [SymbolUpper]
  4255 0000163D 50                       push ax
  4256 0000163E E896FC                   call eqstr
  4257 00001641 83C404                   add  sp, 4
  4258 00001644 08C0                     or  al, al
  4259 00001646 0F840600                 je .testReg190
  4260 0000164A B80600                   mov ax, 6
  4261 0000164D E99E01                   jmp .retntestReg
  4262                                  
  4263                                  ;-690   if (eqstr(SymbolUpper, "DI")) return 7;
  4264                                  
  4265                                  .testReg190:
  4266 00001650 68[1C18]                 push testReg_15
  4267 00001653 8D064F75                 lea  ax, [SymbolUpper]
  4268 00001657 50                       push ax
  4269 00001658 E87CFC                   call eqstr
  4270 0000165B 83C404                   add  sp, 4
  4271 0000165E 08C0                     or  al, al
  4272 00001660 0F840600                 je .testReg191
  4273 00001664 B80700                   mov ax, 7
  4274 00001667 E98401                   jmp .retntestReg
  4275                                  
  4276                                  ;-691   R2Type=SEGREG;
  4277                                  
  4278                                  .testReg191:
  4279 0000166A B80400                   mov ax, 4
  4280 0000166D A2[3500]                 mov byte [R2Type], al
  4281                                  
  4282                                  ;-692   if (eqstr(SymbolUpper, "ES")) return 0;
  4283                                  
  4284 00001670 68[1F18]                 push testReg_16
  4285 00001673 8D064F75                 lea  ax, [SymbolUpper]
  4286 00001677 50                       push ax
  4287 00001678 E85CFC                   call eqstr
  4288 0000167B 83C404                   add  sp, 4
  4289 0000167E 08C0                     or  al, al
  4290 00001680 0F840600                 je .testReg192
  4291 00001684 B80000                   mov ax, 0
  4292 00001687 E96401                   jmp .retntestReg
  4293                                  
  4294                                  ;-693   if (eqstr(SymbolUpper, "CS")) return 1;
  4295                                  
  4296                                  .testReg192:
  4297 0000168A 68[2218]                 push testReg_17
  4298 0000168D 8D064F75                 lea  ax, [SymbolUpper]
  4299 00001691 50                       push ax
  4300 00001692 E842FC                   call eqstr
  4301 00001695 83C404                   add  sp, 4
  4302 00001698 08C0                     or  al, al
  4303 0000169A 0F840600                 je .testReg193
  4304 0000169E B80100                   mov ax, 1
  4305 000016A1 E94A01                   jmp .retntestReg
  4306                                  
  4307                                  ;-694   if (eqstr(SymbolUpper, "SS")) return 2;
  4308                                  
  4309                                  .testReg193:
  4310 000016A4 68[2518]                 push testReg_18
  4311 000016A7 8D064F75                 lea  ax, [SymbolUpper]
  4312 000016AB 50                       push ax
  4313 000016AC E828FC                   call eqstr
  4314 000016AF 83C404                   add  sp, 4
  4315 000016B2 08C0                     or  al, al
  4316 000016B4 0F840600                 je .testReg194
  4317 000016B8 B80200                   mov ax, 2
  4318 000016BB E93001                   jmp .retntestReg
  4319                                  
  4320                                  ;-695   if (eqstr(SymbolUpper, "DS")) return 3;
  4321                                  
  4322                                  .testReg194:
  4323 000016BE 68[2818]                 push testReg_19
  4324 000016C1 8D064F75                 lea  ax, [SymbolUpper]
  4325 000016C5 50                       push ax
  4326 000016C6 E80EFC                   call eqstr
  4327 000016C9 83C404                   add  sp, 4
  4328 000016CC 08C0                     or  al, al
  4329 000016CE 0F840600                 je .testReg195
  4330 000016D2 B80300                   mov ax, 3
  4331 000016D5 E91601                   jmp .retntestReg
  4332                                  
  4333                                  ;-696   if (eqstr(SymbolUpper, "FS")) return 4;
  4334                                  
  4335                                  .testReg195:
  4336 000016D8 68[2B18]                 push testReg_20
  4337 000016DB 8D064F75                 lea  ax, [SymbolUpper]
  4338 000016DF 50                       push ax
  4339 000016E0 E8F4FB                   call eqstr
  4340 000016E3 83C404                   add  sp, 4
  4341 000016E6 08C0                     or  al, al
  4342 000016E8 0F840600                 je .testReg196
  4343 000016EC B80400                   mov ax, 4
  4344 000016EF E9FC00                   jmp .retntestReg
  4345                                  
  4346                                  ;-697   if (eqstr(SymbolUpper, "GS")) return 5;
  4347                                  
  4348                                  .testReg196:
  4349 000016F2 68[2E18]                 push testReg_21
  4350 000016F5 8D064F75                 lea  ax, [SymbolUpper]
  4351 000016F9 50                       push ax
  4352 000016FA E8DAFB                   call eqstr
  4353 000016FD 83C404                   add  sp, 4
  4354 00001700 08C0                     or  al, al
  4355 00001702 0F840600                 je .testReg197
  4356 00001706 B80500                   mov ax, 5
  4357 00001709 E9E200                   jmp .retntestReg
  4358                                  
  4359                                  ;-698   R2Type=DWORD;
  4360                                  
  4361                                  .testReg197:
  4362 0000170C B80300                   mov ax, 3
  4363 0000170F A2[3500]                 mov byte [R2Type], al
  4364                                  
  4365                                  ;-699   if (eqstr(SymbolUpper, "EAX"))return 0;
  4366                                  
  4367 00001712 68[3118]                 push testReg_22
  4368 00001715 8D064F75                 lea  ax, [SymbolUpper]
  4369 00001719 50                       push ax
  4370 0000171A E8BAFB                   call eqstr
  4371 0000171D 83C404                   add  sp, 4
  4372 00001720 08C0                     or  al, al
  4373 00001722 0F840600                 je .testReg198
  4374 00001726 B80000                   mov ax, 0
  4375 00001729 E9C200                   jmp .retntestReg
  4376                                  
  4377                                  ;-700   if (eqstr(SymbolUpper, "ECX"))return 1;
  4378                                  
  4379                                  .testReg198:
  4380 0000172C 68[3518]                 push testReg_23
  4381 0000172F 8D064F75                 lea  ax, [SymbolUpper]
  4382 00001733 50                       push ax
  4383 00001734 E8A0FB                   call eqstr
  4384 00001737 83C404                   add  sp, 4
  4385 0000173A 08C0                     or  al, al
  4386 0000173C 0F840600                 je .testReg199
  4387 00001740 B80100                   mov ax, 1
  4388 00001743 E9A800                   jmp .retntestReg
  4389                                  
  4390                                  ;-701   if (eqstr(SymbolUpper, "EDX"))return 2;
  4391                                  
  4392                                  .testReg199:
  4393 00001746 68[3918]                 push testReg_24
  4394 00001749 8D064F75                 lea  ax, [SymbolUpper]
  4395 0000174D 50                       push ax
  4396 0000174E E886FB                   call eqstr
  4397 00001751 83C404                   add  sp, 4
  4398 00001754 08C0                     or  al, al
  4399 00001756 0F840600                 je .testReg200
  4400 0000175A B80200                   mov ax, 2
  4401 0000175D E98E00                   jmp .retntestReg
  4402                                  
  4403                                  ;-702   if (eqstr(SymbolUpper, "EBX"))return 3;
  4404                                  
  4405                                  .testReg200:
  4406 00001760 68[3D18]                 push testReg_25
  4407 00001763 8D064F75                 lea  ax, [SymbolUpper]
  4408 00001767 50                       push ax
  4409 00001768 E86CFB                   call eqstr
  4410 0000176B 83C404                   add  sp, 4
  4411 0000176E 08C0                     or  al, al
  4412 00001770 0F840600                 je .testReg201
  4413 00001774 B80300                   mov ax, 3
  4414 00001777 E97400                   jmp .retntestReg
  4415                                  
  4416                                  ;-703   if (eqstr(SymbolUpper, "ESP"))return 4;
  4417                                  
  4418                                  .testReg201:
  4419 0000177A 68[4118]                 push testReg_26
  4420 0000177D 8D064F75                 lea  ax, [SymbolUpper]
  4421 00001781 50                       push ax
  4422 00001782 E852FB                   call eqstr
  4423 00001785 83C404                   add  sp, 4
  4424 00001788 08C0                     or  al, al
  4425 0000178A 0F840600                 je .testReg202
  4426 0000178E B80400                   mov ax, 4
  4427 00001791 E95A00                   jmp .retntestReg
  4428                                  
  4429                                  ;-704   if (eqstr(SymbolUpper, "EBP"))return 5;
  4430                                  
  4431                                  .testReg202:
  4432 00001794 68[4518]                 push testReg_27
  4433 00001797 8D064F75                 lea  ax, [SymbolUpper]
  4434 0000179B 50                       push ax
  4435 0000179C E838FB                   call eqstr
  4436 0000179F 83C404                   add  sp, 4
  4437 000017A2 08C0                     or  al, al
  4438 000017A4 0F840600                 je .testReg203
  4439 000017A8 B80500                   mov ax, 5
  4440 000017AB E94000                   jmp .retntestReg
  4441                                  
  4442                                  ;-705   if (eqstr(SymbolUpper, "ESI"))return 6;
  4443                                  
  4444                                  .testReg203:
  4445 000017AE 68[4918]                 push testReg_28
  4446 000017B1 8D064F75                 lea  ax, [SymbolUpper]
  4447 000017B5 50                       push ax
  4448 000017B6 E81EFB                   call eqstr
  4449 000017B9 83C404                   add  sp, 4
  4450 000017BC 08C0                     or  al, al
  4451 000017BE 0F840600                 je .testReg204
  4452 000017C2 B80600                   mov ax, 6
  4453 000017C5 E92600                   jmp .retntestReg
  4454                                  
  4455                                  ;-706   if (eqstr(SymbolUpper, "EDI"))return 7;
  4456                                  
  4457                                  .testReg204:
  4458 000017C8 68[4D18]                 push testReg_29
  4459 000017CB 8D064F75                 lea  ax, [SymbolUpper]
  4460 000017CF 50                       push ax
  4461 000017D0 E804FB                   call eqstr
  4462 000017D3 83C404                   add  sp, 4
  4463 000017D6 08C0                     or  al, al
  4464 000017D8 0F840600                 je .testReg205
  4465 000017DC B80700                   mov ax, 7
  4466 000017DF E90C00                   jmp .retntestReg
  4467                                  
  4468                                  ;-707   R2Type=0; return 0;
  4469                                  
  4470                                  .testReg205:
  4471 000017E2 B80000                   mov ax, 0
  4472 000017E5 A2[3500]                 mov byte [R2Type], al
  4473 000017E8 B80000                   mov ax, 0
  4474 000017EB E90000                   jmp .retntestReg
  4475                                  
  4476                                  ;-708 }
  4477                                  
  4478                                  
  4479                                  ;-709 
  4480                                  
  4481                                  
  4482                                  ;-710 
  4483                                  
  4484                                  
  4485                                  ;-711 //#include "OUTPUT.C"
  4486                                  
  4487                                  
  4488                                  ;-712 int printLine() {
  4489                                  
  4490                                   .retntestReg:
  4491 000017EE C3                       ret
  4492 000017EF 414C00                  testReg_0 db "AL",0
  4493 000017F2 434C00                  testReg_1 db "CL",0
  4494 000017F5 444C00                  testReg_2 db "DL",0
  4495 000017F8 424C00                  testReg_3 db "BL",0
  4496 000017FB 414800                  testReg_4 db "AH",0
  4497 000017FE 434800                  testReg_5 db "CH",0
  4498 00001801 444800                  testReg_6 db "DH",0
  4499 00001804 424800                  testReg_7 db "BH",0
  4500 00001807 415800                  testReg_8 db "AX",0
  4501 0000180A 435800                  testReg_9 db "CX",0
  4502 0000180D 445800                  testReg_10 db "DX",0
  4503 00001810 425800                  testReg_11 db "BX",0
  4504 00001813 535000                  testReg_12 db "SP",0
  4505 00001816 425000                  testReg_13 db "BP",0
  4506 00001819 534900                  testReg_14 db "SI",0
  4507 0000181C 444900                  testReg_15 db "DI",0
  4508 0000181F 455300                  testReg_16 db "ES",0
  4509 00001822 435300                  testReg_17 db "CS",0
  4510 00001825 535300                  testReg_18 db "SS",0
  4511 00001828 445300                  testReg_19 db "DS",0
  4512 0000182B 465300                  testReg_20 db "FS",0
  4513 0000182E 475300                  testReg_21 db "GS",0
  4514 00001831 45415800                testReg_22 db "EAX",0
  4515 00001835 45435800                testReg_23 db "ECX",0
  4516 00001839 45445800                testReg_24 db "EDX",0
  4517 0000183D 45425800                testReg_25 db "EBX",0
  4518 00001841 45535000                testReg_26 db "ESP",0
  4519 00001845 45425000                testReg_27 db "EBP",0
  4520 00001849 45534900                testReg_28 db "ESI",0
  4521 0000184D 45444900                testReg_29 db "EDI",0
  4522                                  ENDP
  4523                                  
  4524                                  printLine: PROC
  4525                                  
  4526                                  ;-713     int i; char c;
  4527                                  
  4528                                  
  4529                                  ;-714     prs("\n");
  4530                                  
  4531                                  ;Function : printLine, Number of local variables: 2
  4532                                  ;   # type sign width addr used name   list of local variables
  4533                                  ;  200 var sign word   713 NULL i = bp-2
  4534                                  ;  201 var sign byte   713 NULL c = bp-4;
  4535 00001851 C8040000                 ENTER  4,0
  4536 00001855 68[E318]                 push printLine_0
  4537 00001858 E8F700                   call prs
  4538 0000185B 83C402                   add  sp, 2
  4539                                  
  4540                                  ;-715     printhex16(PCStart);
  4541                                  
  4542 0000185E FF36[2900]               push word [PCStart]
  4543 00001862 E8D301                   call printhex16
  4544 00001865 83C402                   add  sp, 2
  4545                                  
  4546                                  ;-716     if (OpPrintIndex == 0) prs("               ");
  4547                                  
  4548 00001868 A1[4100]                 mov ax, [OpPrintIndex]
  4549 0000186B 83F800                   cmp ax, 0
  4550 0000186E 0F850C00                 jne .printLine206
  4551 00001872 68[E618]                 push printLine_1
  4552 00001875 E8DA00                   call prs
  4553 00001878 83C402                   add  sp, 2
  4554                                  
  4555                                  ;-717     else {
  4556                                  
  4557 0000187B E94C00                   jmp .printLine207
  4558                                  .printLine206:
  4559                                  
  4560                                  ;-718 //        prc(' ');
  4561                                  
  4562                                  
  4563                                  ;-719         i=0;
  4564                                  
  4565 0000187E B80000                   mov ax, 0
  4566 00001881 8946FE                   mov [bp-2], ax
  4567                                  
  4568                                  ;-720         do {
  4569                                  
  4570                                  .printLine208:
  4571                                  
  4572                                  ;-721             c=OpPos[i];
  4573                                  
  4574 00001884 8B5EFE                   mov bx, [bp-2]
  4575 00001887 8A875577                 mov al, [OpPos + bx]
  4576 0000188B 8846FC                   mov [bp-4], al
  4577                                  
  4578                                  ;-722             prc(' ');
  4579                                  
  4580 0000188E 6A20                     push 32
  4581 00001890 E86700                   call prc
  4582 00001893 83C402                   add  sp, 2
  4583                                  
  4584                                  ;-723             printhex8a(c);
  4585                                  
  4586 00001896 8A46FC                   mov al, byte [bp-4]
  4587 00001899 B400                     mov ah, 0
  4588 0000189B 50                       push ax
  4589 0000189C E84701                   call printhex8a
  4590 0000189F 83C402                   add  sp, 2
  4591                                  
  4592                                  ;-724             i++;
  4593                                  
  4594 000018A2 FF46FE                   inc  word[bp-2]
  4595                                  
  4596                                  ;-725         } while (i < OpPrintIndex);
  4597                                  
  4598 000018A5 8B46FE                   mov ax, [bp-2]
  4599 000018A8 3B06[4100]               cmp ax, [OpPrintIndex]
  4600 000018AC 0F8D0200                 jge .printLine209
  4601 000018B0 EBD2                     jmp .printLine208
  4602                                  .printLine209:
  4603                                  
  4604                                  ;-726         while (i < OPMAXLEN) {// fill rest with blank
  4605                                  
  4606                                  .printLine210:
  4607 000018B2 8B46FE                   mov ax, [bp-2]
  4608 000018B5 83F805                   cmp ax, 5
  4609 000018B8 0F8D0E00                 jge .printLine211
  4610                                  
  4611                                  ;-727             prs("   ");
  4612                                  
  4613 000018BC 68[F618]                 push printLine_2
  4614 000018BF E89000                   call prs
  4615 000018C2 83C402                   add  sp, 2
  4616                                  
  4617                                  ;-728             i++;
  4618                                  
  4619 000018C5 FF46FE                   inc  word[bp-2]
  4620                                  
  4621                                  ;-729         }
  4622                                  
  4623                                  
  4624                                  ;-730     }
  4625                                  
  4626 000018C8 EBE8                     jmp .printLine210
  4627                                  .printLine211:
  4628                                  
  4629                                  ;-731     prc(PrintRA);
  4630                                  
  4631                                  .printLine207:
  4632 000018CA A0[4500]                 mov al, byte [PrintRA]
  4633 000018CD B400                     mov ah, 0
  4634 000018CF 50                       push ax
  4635 000018D0 E82700                   call prc
  4636 000018D3 83C402                   add  sp, 2
  4637                                  
  4638                                  ;-732     prscomment(InputBuf);
  4639                                  
  4640 000018D6 8D068D75                 lea  ax, [InputBuf]
  4641 000018DA 50                       push ax
  4642 000018DB E84600                   call prscomment
  4643 000018DE 83C402                   add  sp, 2
  4644                                  
  4645                                  ;-733 }
  4646                                  
  4647                                  
  4648                                  ;-734 int prc(unsigned char c) {//print char
  4649 000018E1 C9                       LEAVE
  4650 000018E2 C3                       ret
  4651 000018E3 5C6E00                  printLine_0 db "\n",0
  4652 000018E6 202020202020202020-     printLine_1 db "               ",0
  4653 000018EF 20202020202000     
  4654 000018F6 20202000                printLine_2 db "   ",0
  4655                                  ENDP
  4656                                  
  4657                                  prc: PROC
  4658                                  
  4659                                  ;-735         if ( _ c==10) {
  4660                                  
  4661                                  ;Function : prc, Number of local variables: 1
  4662                                  ;   # type sign width addr used name   list of local variables
  4663                                  ;  200 var unsg byte   734 NULL c = bp+4;
  4664 000018FA C8000000                 ENTER  0,0 ; constant expression
  4665 000018FE 807E040A                cmp byte[bp+4], 10
  4666 00001902 0F850600                 jne .prc212
  4667                                  
  4668                                  ;-736             ax=13;
  4669                                  
  4670 00001906 B80D00                   mov  ax, 13
  4671                                  
  4672                                  ;-737             writetty();
  4673                                  
  4674 00001909 E87DF6                   call writetty
  4675                                  
  4676                                  ;-738             }
  4677                                  
  4678                                  
  4679                                  ;-739         al=c;
  4680                                  
  4681                                  .prc212:
  4682 0000190C 8A4604                   mov  al, [bp+4]
  4683                                  
  4684                                  ;-740         writetty();
  4685                                  
  4686 0000190F E877F6                   call writetty
  4687                                  
  4688                                  ;-741     fputcR(c,lst_fd);
  4689                                  
  4690 00001912 FF36[1800]               push word [lst_fd]
  4691 00001916 8A4604                   mov al, byte [bp+4]
  4692 00001919 B400                     mov ah, 0
  4693 0000191B 50                       push ax
  4694 0000191C E815F7                   call fputcR
  4695 0000191F 83C404                   add  sp, 4
  4696                                  
  4697                                  ;-742 }
  4698                                  
  4699                                  
  4700                                  ;-743 
  4701                                  
  4702                                  
  4703                                  ;-744 int prscomment(unsigned char *s) {
  4704 00001922 C9                       LEAVE
  4705 00001923 C3                       ret
  4706                                  ENDP
  4707                                  
  4708                                  prscomment: PROC
  4709                                  
  4710                                  ;-745     unsigned char c;
  4711                                  
  4712                                  
  4713                                  ;-746     while (*s){
  4714                                  
  4715                                  ;Function : prscomment, Number of local variables: 2
  4716                                  ;   # type sign width addr used name   list of local variables
  4717                                  ;  200 ptr unsg byte   744 NULL s = bp+4
  4718                                  ;  201 var unsg byte   745 NULL c = bp-2;
  4719 00001924 C8020000                 ENTER  2,0
  4720                                  .prscomment213:
  4721 00001928 8B5E04                   mov bx, [bp+4]
  4722 0000192B 8A07                     mov al, [bx]
  4723 0000192D B400                     mov ah, 0
  4724 0000192F 08C0                     or  al, al
  4725 00001931 0F841B00                 je .prscomment214
  4726                                  
  4727                                  ;-747         c=*s;
  4728                                  
  4729 00001935 8B5E04                   mov bx, [bp+4]
  4730 00001938 8A07                     mov al, [bx]
  4731 0000193A B400                     mov ah, 0
  4732 0000193C 8846FE                   mov [bp-2], al
  4733                                  
  4734                                  ;-748         prc(c);
  4735                                  
  4736 0000193F 8A46FE                   mov al, byte [bp-2]
  4737 00001942 B400                     mov ah, 0
  4738 00001944 50                       push ax
  4739 00001945 E8B2FF                   call prc
  4740 00001948 83C402                   add  sp, 2
  4741                                  
  4742                                  ;-749         s++;
  4743                                  
  4744 0000194B FF4604                   inc  word[bp+4]
  4745                                  
  4746                                  ;-750     }
  4747                                  
  4748                                  
  4749                                  ;-751 }
  4750                                  
  4751 0000194E EBD8                     jmp .prscomment213
  4752                                  .prscomment214:
  4753                                  
  4754                                  ;-752 int prs(unsigned char *s) {
  4755 00001950 C9                       LEAVE
  4756 00001951 C3                       ret
  4757                                  ENDP
  4758                                  
  4759                                  prs: PROC
  4760                                  
  4761                                  ;-753     unsigned char c;
  4762                                  
  4763                                  
  4764                                  ;-754     int com;
  4765                                  
  4766                                  
  4767                                  ;-755     com=0;
  4768                                  
  4769                                  ;Function : prs, Number of local variables: 3
  4770                                  ;   # type sign width addr used name   list of local variables
  4771                                  ;  200 ptr unsg byte   752 NULL s = bp+4
  4772                                  ;  201 var unsg byte   753 NULL c = bp-2
  4773                                  ;  202 var sign word   754 NULL com = bp-4;
  4774 00001952 C8040000                 ENTER  4,0
  4775 00001956 B80000                   mov ax, 0
  4776 00001959 8946FC                   mov [bp-4], ax
  4777                                  
  4778                                  ;-756     while (*s) {
  4779                                  
  4780                                  .prs215:
  4781 0000195C 8B5E04                   mov bx, [bp+4]
  4782 0000195F 8A07                     mov al, [bx]
  4783 00001961 B400                     mov ah, 0
  4784 00001963 08C0                     or  al, al
  4785 00001965 0F847B00                 je .prs216
  4786                                  
  4787                                  ;-757         c=*s;
  4788                                  
  4789 00001969 8B5E04                   mov bx, [bp+4]
  4790 0000196C 8A07                     mov al, [bx]
  4791 0000196E B400                     mov ah, 0
  4792 00001970 8846FE                   mov [bp-2], al
  4793                                  
  4794                                  ;-758         if (c==34) {
  4795                                  
  4796 00001973 8A46FE                   mov al, [bp-2]
  4797 00001976 3C22                     cmp al, 34
  4798 00001978 0F851800                 jne .prs217
  4799                                  
  4800                                  ;-759             if (com) com=0;
  4801                                  
  4802 0000197C 8B46FC                   mov ax, [bp-4]
  4803 0000197F 08C0                     or  al, al
  4804 00001981 0F840900                 je .prs218
  4805 00001985 B80000                   mov ax, 0
  4806 00001988 8946FC                   mov [bp-4], ax
  4807                                  
  4808                                  ;-760                 else com=1;
  4809                                  
  4810 0000198B E90600                   jmp .prs219
  4811                                  .prs218:
  4812 0000198E B80100                   mov ax, 1
  4813 00001991 8946FC                   mov [bp-4], ax
  4814                                  
  4815                                  ;-761         }
  4816                                  
  4817                                  .prs219:
  4818                                  
  4819                                  ;-762         if (c==92) {
  4820                                  
  4821                                  .prs217:
  4822 00001994 8A46FE                   mov al, [bp-2]
  4823 00001997 3C5C                     cmp al, 92
  4824 00001999 0F853500                 jne .prs220
  4825                                  
  4826                                  ;-763             if (com==0) {
  4827                                  
  4828 0000199D 8B46FC                   mov ax, [bp-4]
  4829 000019A0 83F800                   cmp ax, 0
  4830 000019A3 0F852B00                 jne .prs221
  4831                                  
  4832                                  ;-764                 s++;
  4833                                  
  4834 000019A7 FF4604                   inc  word[bp+4]
  4835                                  
  4836                                  ;-765                 c=*s;
  4837                                  
  4838 000019AA 8B5E04                   mov bx, [bp+4]
  4839 000019AD 8A07                     mov al, [bx]
  4840 000019AF B400                     mov ah, 0
  4841 000019B1 8846FE                   mov [bp-2], al
  4842                                  
  4843                                  ;-766                 if (c=='n') c=10;
  4844                                  
  4845 000019B4 8A46FE                   mov al, [bp-2]
  4846 000019B7 3C6E                     cmp al, 110
  4847 000019B9 0F850600                 jne .prs222
  4848 000019BD B80A00                   mov ax, 10
  4849 000019C0 8846FE                   mov [bp-2], al
  4850                                  
  4851                                  ;-767                 if (c=='t') c= 9;
  4852                                  
  4853                                  .prs222:
  4854 000019C3 8A46FE                   mov al, [bp-2]
  4855 000019C6 3C74                     cmp al, 116
  4856 000019C8 0F850600                 jne .prs223
  4857 000019CC B80900                   mov ax, 9
  4858 000019CF 8846FE                   mov [bp-2], al
  4859                                  
  4860                                  ;-768             }
  4861                                  
  4862                                  .prs223:
  4863                                  
  4864                                  ;-769         }
  4865                                  
  4866                                  .prs221:
  4867                                  
  4868                                  ;-770         prc(c);
  4869                                  
  4870                                  .prs220:
  4871 000019D2 8A46FE                   mov al, byte [bp-2]
  4872 000019D5 B400                     mov ah, 0
  4873 000019D7 50                       push ax
  4874 000019D8 E81FFF                   call prc
  4875 000019DB 83C402                   add  sp, 2
  4876                                  
  4877                                  ;-771         s++;
  4878                                  
  4879 000019DE FF4604                   inc  word[bp+4]
  4880                                  
  4881                                  ;-772     }
  4882                                  
  4883                                  
  4884                                  ;-773 }
  4885                                  
  4886 000019E1 E978FF                   jmp .prs215
  4887                                  .prs216:
  4888                                  
  4889                                  ;-774 int printhex8a(unsigned char c) {
  4890 000019E4 C9                       LEAVE
  4891 000019E5 C3                       ret
  4892                                  ENDP
  4893                                  
  4894                                  printhex8a: PROC
  4895                                  
  4896                                  ;-775     unsigned char nib;
  4897                                  
  4898                                  
  4899                                  ;-776     nib = c >> 4; printhex4(nib);
  4900                                  
  4901                                  ;Function : printhex8a, Number of local variables: 2
  4902                                  ;   # type sign width addr used name   list of local variables
  4903                                  ;  200 var unsg byte   774 NULL c = bp+4
  4904                                  ;  201 var unsg byte   775 NULL nib = bp-2;
  4905 000019E6 C8020000                 ENTER  2,0
  4906 000019EA 8A4604                   mov al, [bp+4]
  4907 000019ED C0E804                   shr al, 4
  4908 000019F0 8846FE                   mov [bp-2], al
  4909 000019F3 8A46FE                   mov al, byte [bp-2]
  4910 000019F6 B400                     mov ah, 0
  4911 000019F8 50                       push ax
  4912 000019F9 E81900                   call printhex4
  4913 000019FC 83C402                   add  sp, 2
  4914                                  
  4915                                  ;-777     nib = c & 15; printhex4(nib);
  4916                                  
  4917 000019FF 8A4604                   mov al, [bp+4]
  4918 00001A02 240F                     and al, 15
  4919 00001A04 8846FE                   mov [bp-2], al
  4920 00001A07 8A46FE                   mov al, byte [bp-2]
  4921 00001A0A B400                     mov ah, 0
  4922 00001A0C 50                       push ax
  4923 00001A0D E80500                   call printhex4
  4924 00001A10 83C402                   add  sp, 2
  4925                                  
  4926                                  ;-778 }
  4927                                  
  4928                                  
  4929                                  ;-779 int printhex4(unsigned char c) {
  4930 00001A13 C9                       LEAVE
  4931 00001A14 C3                       ret
  4932                                  ENDP
  4933                                  
  4934                                  printhex4: PROC
  4935                                  
  4936                                  ;-780     c += 48;
  4937                                  
  4938                                  ;Function : printhex4, Number of local variables: 1
  4939                                  ;   # type sign width addr used name   list of local variables
  4940                                  ;  200 var unsg byte   779 NULL c = bp+4;
  4941 00001A15 C8000000                 ENTER  0,0
  4942 00001A19 80460430                 add  byte[bp+4], 48
  4943                                  
  4944                                  ;-781     if (c > 57) c += 7;
  4945                                  
  4946 00001A1D 8A4604                   mov al, [bp+4]
  4947 00001A20 3C39                     cmp al, 57
  4948 00001A22 0F8E0400                 jle .printhex4224
  4949 00001A26 80460407                 add  byte[bp+4], 7
  4950                                  
  4951                                  ;-782     prc(c);
  4952                                  
  4953                                  .printhex4224:
  4954 00001A2A 8A4604                   mov al, byte [bp+4]
  4955 00001A2D B400                     mov ah, 0
  4956 00001A2F 50                       push ax
  4957 00001A30 E8C7FE                   call prc
  4958 00001A33 83C402                   add  sp, 2
  4959                                  
  4960                                  ;-783 }
  4961                                  
  4962                                  
  4963                                  ;-784 int printhex16(unsigned int i) {
  4964 00001A36 C9                       LEAVE
  4965 00001A37 C3                       ret
  4966                                  ENDP
  4967                                  
  4968                                  printhex16: PROC
  4969                                  
  4970                                  ;-785     unsigned int half;
  4971                                  
  4972                                  
  4973                                  ;-786     half = i >>  8; printhex8a(half);
  4974                                  
  4975                                  ;Function : printhex16, Number of local variables: 2
  4976                                  ;   # type sign width addr used name   list of local variables
  4977                                  ;  200 var unsg word   784 NULL i = bp+4
  4978                                  ;  201 var unsg word   785 NULL half = bp-2;
  4979 00001A38 C8020000                 ENTER  2,0
  4980 00001A3C 8B4604                   mov ax, [bp+4]
  4981 00001A3F C1E808                   shr ax, 8
  4982 00001A42 8946FE                   mov [bp-2], ax
  4983 00001A45 FF76FE                   push word [bp-2]
  4984 00001A48 E89BFF                   call printhex8a
  4985 00001A4B 83C402                   add  sp, 2
  4986                                  
  4987                                  ;-787     half = i & 255; printhex8a(half);
  4988                                  
  4989 00001A4E 8B4604                   mov ax, [bp+4]
  4990 00001A51 25FF00                   and ax, 255
  4991 00001A54 8946FE                   mov [bp-2], ax
  4992 00001A57 FF76FE                   push word [bp-2]
  4993 00001A5A E889FF                   call printhex8a
  4994 00001A5D 83C402                   add  sp, 2
  4995                                  
  4996                                  ;-788 }
  4997                                  
  4998                                  
  4999                                  ;-789 int printIntU(unsigned int n) {
  5000 00001A60 C9                       LEAVE
  5001 00001A61 C3                       ret
  5002                                  ENDP
  5003                                  
  5004                                  printIntU: PROC
  5005                                  
  5006                                  ;-790     unsigned int e;
  5007                                  
  5008                                  
  5009                                  ;-791     if ( _ n >= 10) {
  5010                                  
  5011                                  ;Function : printIntU, Number of local variables: 2
  5012                                  ;   # type sign width addr used name   list of local variables
  5013                                  ;  200 var unsg word   789 NULL n = bp+4
  5014                                  ;  201 var unsg word   790 NULL e = bp-2;
  5015 00001A62 C8020000                 ENTER  2,0 ; constant expression
  5016 00001A66 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5017 00001A6A 0F821700                 jb  .printIntU225
  5018                                  
  5019                                  ;-792         e=n/10; //DIV
  5020                                  
  5021 00001A6E 8B4604                   mov ax, [bp+4]
  5022 00001A71 BB0A00                   mov bx, 10
  5023 00001A74 BA0000                   mov dx, 0
  5024 00001A77 F7F3                     div bx
  5025 00001A79 8946FE                   mov [bp-2], ax
  5026                                  
  5027                                  ;-793         printIntU(e);
  5028                                  
  5029 00001A7C FF76FE                   push word [bp-2]
  5030 00001A7F E8E0FF                   call printIntU
  5031 00001A82 83C402                   add  sp, 2
  5032                                  
  5033                                  ;-794     }
  5034                                  
  5035                                  
  5036                                  ;-795     n = n % 10; //unsigned mod
  5037                                  
  5038                                  .printIntU225:
  5039 00001A85 8B4604                   mov ax, [bp+4]
  5040 00001A88 BB0A00                   mov bx, 10
  5041 00001A8B BA0000                   mov dx, 0
  5042 00001A8E F7F3                     div bx
  5043 00001A90 89D0                     mov ax, dx
  5044 00001A92 894604                   mov [bp+4], ax
  5045                                  
  5046                                  ;-796     n += '0';
  5047                                  
  5048 00001A95 83460430                 add  word[bp+4], 48
  5049                                  
  5050                                  ;-797     prc(n);
  5051                                  
  5052 00001A99 FF7604                   push word [bp+4]
  5053 00001A9C E85BFE                   call prc
  5054 00001A9F 83C402                   add  sp, 2
  5055                                  
  5056                                  ;-798 }
  5057                                  
  5058                                  
  5059                                  ;-799 
  5060                                  
  5061                                  
  5062                                  ;-800 int error1(char *s) {
  5063 00001AA2 C9                       LEAVE
  5064 00001AA3 C3                       ret
  5065                                  ENDP
  5066                                  
  5067                                  error1: PROC
  5068                                  
  5069                                  ;-801     ErrorCount++;
  5070                                  
  5071                                  ;Function : error1, Number of local variables: 1
  5072                                  ;   # type sign width addr used name   list of local variables
  5073                                  ;  200 ptr sign byte   800 NULL s = bp+4;
  5074 00001AA4 C8000000                 ENTER  0,0
  5075 00001AA8 FF06[1E00]               inc  word[ErrorCount]
  5076                                  
  5077                                  ;-802     prs("\n;***** next line ERROR: ");
  5078                                  
  5079 00001AAC 68[D41A]                 push error1_0
  5080 00001AAF E8A0FE                   call prs
  5081 00001AB2 83C402                   add  sp, 2
  5082                                  
  5083                                  ;-803     prs(s);
  5084                                  
  5085 00001AB5 FF7604                   push word [bp+4]
  5086 00001AB8 E897FE                   call prs
  5087 00001ABB 83C402                   add  sp, 2
  5088                                  
  5089                                  ;-804     prs(", Symbol: ");
  5090                                  
  5091 00001ABE 68[EF1A]                 push error1_1
  5092 00001AC1 E88EFE                   call prs
  5093 00001AC4 83C402                   add  sp, 2
  5094                                  
  5095                                  ;-805     prs(Symbol);
  5096                                  
  5097 00001AC7 8D063075                 lea  ax, [Symbol]
  5098 00001ACB 50                       push ax
  5099 00001ACC E883FE                   call prs
  5100 00001ACF 83C402                   add  sp, 2
  5101                                  
  5102                                  ;-806 }
  5103                                  
  5104                                  
  5105                                  ;-807 int errorexit(char *s) {
  5106 00001AD2 C9                       LEAVE
  5107 00001AD3 C3                       ret
  5108 00001AD4 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5109 00001ADD 6E657874206C696E65-
  5110 00001AE6 204552524F523A2000 
  5111 00001AEF 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5112 00001AF8 2000               
  5113                                  ENDP
  5114                                  
  5115                                  errorexit: PROC
  5116                                  
  5117                                  ;-808     error1(s);
  5118                                  
  5119                                  ;Function : errorexit, Number of local variables: 1
  5120                                  ;   # type sign width addr used name   list of local variables
  5121                                  ;  200 ptr sign byte   807 NULL s = bp+4;
  5122 00001AFA C8000000                 ENTER  0,0
  5123 00001AFE FF7604                   push word [bp+4]
  5124 00001B01 E8A0FF                   call error1
  5125 00001B04 83C402                   add  sp, 2
  5126                                  
  5127                                  ;-809     epilog();
  5128                                  
  5129 00001B07 E80505                   call epilog
  5130                                  
  5131                                  ;-810     end1(1);
  5132                                  
  5133 00001B0A 6A01                     push 1
  5134 00001B0C E8F805                   call end1
  5135 00001B0F 83C402                   add  sp, 2
  5136                                  
  5137                                  ;-811 }
  5138                                  
  5139                                  
  5140                                  ;-812 int allowederror() {error1("not allowed here"); }
  5141 00001B12 C9                       LEAVE
  5142 00001B13 C3                       ret
  5143                                  ENDP
  5144                                  
  5145                                  allowederror: PROC
  5146 00001B14 68[1E1B]                 push allowederror_0
  5147 00001B17 E88AFF                   call error1
  5148 00001B1A 83C402                   add  sp, 2
  5149                                  
  5150                                  ;-813 int addrerror()    {error1("address missing");}
  5151                                  
  5152 00001B1D C3                       ret
  5153 00001B1E 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5154 00001B27 6564206865726500   
  5155                                  ENDP
  5156                                  
  5157                                  addrerror: PROC
  5158 00001B2F 68[391B]                 push addrerror_0
  5159 00001B32 E86FFF                   call error1
  5160 00001B35 83C402                   add  sp, 2
  5161                                  
  5162                                  ;-814 int immeerror()    {error1("immediate not allowed here");}
  5163                                  
  5164 00001B38 C3                       ret
  5165 00001B39 61646472657373206D-     addrerror_0 db "address missing",0
  5166 00001B42 697373696E6700     
  5167                                  ENDP
  5168                                  
  5169                                  immeerror: PROC
  5170 00001B49 68[531B]                 push immeerror_0
  5171 00001B4C E855FF                   call error1
  5172 00001B4F 83C402                   add  sp, 2
  5173                                  
  5174                                  ;-815 int implerror()    {error1("not implemented");}
  5175                                  
  5176 00001B52 C3                       ret
  5177 00001B53 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5178 00001B5C 206E6F7420616C6C6F-
  5179 00001B65 776564206865726500 
  5180                                  ENDP
  5181                                  
  5182                                  implerror: PROC
  5183 00001B6E 68[781B]                 push implerror_0
  5184 00001B71 E830FF                   call error1
  5185 00001B74 83C402                   add  sp, 2
  5186                                  
  5187                                  ;-816 int indexerror()   {error1("invalid index register");}
  5188                                  
  5189 00001B77 C3                       ret
  5190 00001B78 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5191 00001B81 6D656E74656400     
  5192                                  ENDP
  5193                                  
  5194                                  indexerror: PROC
  5195 00001B88 68[921B]                 push indexerror_0
  5196 00001B8B E816FF                   call error1
  5197 00001B8E 83C402                   add  sp, 2
  5198                                  
  5199                                  ;-817 int invaloperror() {error1("invalid or no operands");}
  5200                                  
  5201 00001B91 C3                       ret
  5202 00001B92 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5203 00001B9B 6E6465782072656769-
  5204 00001BA4 7374657200         
  5205                                  ENDP
  5206                                  
  5207                                  invaloperror: PROC
  5208 00001BA9 68[B31B]                 push invaloperror_0
  5209 00001BAC E8F5FE                   call error1
  5210 00001BAF 83C402                   add  sp, 2
  5211                                  
  5212                                  ;-818 int numbererror()  {error1("number expected");}
  5213                                  
  5214 00001BB2 C3                       ret
  5215 00001BB3 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5216 00001BBC 72206E6F206F706572-
  5217 00001BC5 616E647300         
  5218                                  ENDP
  5219                                  
  5220                                  numbererror: PROC
  5221 00001BCA 68[D41B]                 push numbererror_0
  5222 00001BCD E8D4FE                   call error1
  5223 00001BD0 83C402                   add  sp, 2
  5224                                  
  5225                                  ;-819 int regmemerror()  {error1("only register or memory allowed");}
  5226                                  
  5227 00001BD3 C3                       ret
  5228 00001BD4 6E756D626572206578-     numbererror_0 db "number expected",0
  5229 00001BDD 70656374656400     
  5230                                  ENDP
  5231                                  
  5232                                  regmemerror: PROC
  5233 00001BE4 68[EE1B]                 push regmemerror_0
  5234 00001BE7 E8BAFE                   call error1
  5235 00001BEA 83C402                   add  sp, 2
  5236                                  
  5237                                  ;-820 int reg16error()   {error1("only reg16, no segreg allowed");}
  5238                                  
  5239 00001BED C3                       ret
  5240 00001BEE 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5241 00001BF7 73746572206F72206D-
  5242 00001C00 656D6F727920616C6C-
  5243 00001C09 6F77656400         
  5244                                  ENDP
  5245                                  
  5246                                  reg16error: PROC
  5247 00001C0E 68[181C]                 push reg16error_0
  5248 00001C11 E890FE                   call error1
  5249 00001C14 83C402                   add  sp, 2
  5250                                  
  5251                                  ;-821 int segregerror()  {error1("segment register not allowed");}
  5252                                  
  5253 00001C17 C3                       ret
  5254 00001C18 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5255 00001C21 362C206E6F20736567-
  5256 00001C2A 72656720616C6C6F77-
  5257 00001C33 656400             
  5258                                  ENDP
  5259                                  
  5260                                  segregerror: PROC
  5261 00001C36 68[401C]                 push segregerror_0
  5262 00001C39 E868FE                   call error1
  5263 00001C3C 83C402                   add  sp, 2
  5264                                  
  5265                                  ;-822 int syntaxerror()  {error1("syntax");}
  5266                                  
  5267 00001C3F C3                       ret
  5268 00001C40 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5269 00001C49 65676973746572206E-
  5270 00001C52 6F7420616C6C6F7765-
  5271 00001C5B 6400               
  5272                                  ENDP
  5273                                  
  5274                                  syntaxerror: PROC
  5275 00001C5D 68[671C]                 push syntaxerror_0
  5276 00001C60 E841FE                   call error1
  5277 00001C63 83C402                   add  sp, 2
  5278                                  
  5279                                  ;-823 
  5280                                  
  5281                                  
  5282                                  ;-824 int addrexit()     {errorexit("illegal address");}
  5283                                  
  5284 00001C66 C3                       ret
  5285 00001C67 73796E74617800          syntaxerror_0 db "syntax",0
  5286                                  ENDP
  5287                                  
  5288                                  addrexit: PROC
  5289 00001C6E 68[781C]                 push addrexit_0
  5290 00001C71 E886FE                   call errorexit
  5291 00001C74 83C402                   add  sp, 2
  5292                                  
  5293                                  ;-825 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5294                                  
  5295 00001C77 C3                       ret
  5296 00001C78 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5297 00001C81 64647265737300     
  5298                                  ENDP
  5299                                  
  5300                                  dataexit: PROC
  5301 00001C88 68[921C]                 push dataexit_0
  5302 00001C8B E86CFE                   call errorexit
  5303 00001C8E 83C402                   add  sp, 2
  5304                                  
  5305                                  ;-826 int internexit()   {errorexit("intern compiler error");}
  5306                                  
  5307 00001C91 C3                       ret
  5308 00001C92 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5309 00001C9B 6F7220524553422C57-
  5310 00001CA4 2C4420657870656374-
  5311 00001CAD 656400             
  5312                                  ENDP
  5313                                  
  5314                                  internexit: PROC
  5315 00001CB0 68[BA1C]                 push internexit_0
  5316 00001CB3 E844FE                   call errorexit
  5317 00001CB6 83C402                   add  sp, 2
  5318                                  
  5319                                  ;-827 
  5320                                  
  5321                                  
  5322                                  ;-828 
  5323                                  
  5324                                  
  5325                                  ;-829 //#include "MAIN.C"
  5326                                  
  5327                                  
  5328                                  ;-830 int main() {
  5329                                  
  5330 00001CB9 C3                       ret
  5331 00001CBA 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5332 00001CC3 6D70696C6572206572-
  5333 00001CCC 726F7200           
  5334                                  ENDP
  5335                                  
  5336                                  main: PROC
  5337                                  
  5338                                  ;-831     getarg();
  5339                                  
  5340 00001CD0 E80D00                   call getarg
  5341                                  
  5342                                  ;-832     parse();
  5343                                  
  5344 00001CD3 E877EC                   call parse
  5345                                  
  5346                                  ;-833     fixJmpCall();
  5347                                  
  5348 00001CD6 E84A02                   call fixJmpCall
  5349                                  
  5350                                  ;-834     epilog();
  5351                                  
  5352 00001CD9 E83303                   call epilog
  5353                                  
  5354                                  ;-835     end1();
  5355                                  
  5356 00001CDC E82804                   call end1
  5357                                  
  5358                                  ;-836 }
  5359                                  
  5360                                  
  5361                                  ;-837 
  5362                                  
  5363                                  
  5364                                  ;-838 int getarg() {
  5365                                  
  5366 00001CDF C3                       ret
  5367                                  ENDP
  5368                                  
  5369                                  getarg: PROC
  5370                                  
  5371                                  ;-839     int arglen1; int i; char *c;
  5372                                  
  5373                                  
  5374                                  ;-840     arglen1=*arglen;
  5375                                  
  5376                                  ;Function : getarg, Number of local variables: 3
  5377                                  ;   # type sign width addr used name   list of local variables
  5378                                  ;  200 var sign word   839 NULL arglen1 = bp-2
  5379                                  ;  201 var sign word   839 NULL i = bp-4
  5380                                  ;  202 ptr sign byte   839 NULL c = bp-6;
  5381 00001CE0 C8060000                 ENTER  6,0
  5382 00001CE4 8B1E[5600]               mov bx, [arglen]
  5383 00001CE8 8A07                     mov al, [bx]
  5384 00001CEA B400                     mov ah, 0
  5385 00001CEC 8946FE                   mov [bp-2], ax
  5386                                  
  5387                                  ;-841     if (arglen1==0) {
  5388                                  
  5389 00001CEF 8B46FE                   mov ax, [bp-2]
  5390 00001CF2 83F800                   cmp ax, 0
  5391 00001CF5 0F851C00                 jne .getarg226
  5392                                  
  5393                                  ;-842         cputs(Version1);
  5394                                  
  5395 00001CF9 8D06[0300]               lea  ax, [Version1]
  5396 00001CFD 50                       push ax
  5397 00001CFE E8A9F2                   call cputs
  5398 00001D01 83C402                   add  sp, 2
  5399                                  
  5400                                  ;-843         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5401                                  
  5402 00001D04 68[901E]                 push getarg_0
  5403 00001D07 E8A0F2                   call cputs
  5404 00001D0A 83C402                   add  sp, 2
  5405                                  
  5406                                  ;-844         exitR(3);
  5407                                  
  5408 00001D0D 6A03                     push 3
  5409 00001D0F E8FFF2                   call exitR
  5410 00001D12 83C402                   add  sp, 2
  5411                                  
  5412                                  ;-845     }
  5413                                  
  5414                                  
  5415                                  ;-846     i=arglen1+129;
  5416                                  
  5417                                  .getarg226:
  5418 00001D15 8B46FE                   mov ax, [bp-2]
  5419 00001D18 058100                   add ax, 129
  5420 00001D1B 8946FC                   mov [bp-4], ax
  5421                                  
  5422                                  ;-847     *i=0;
  5423                                  
  5424 00001D1E B80000                   mov ax, 0
  5425 00001D21 8B5EFC                   mov  bx, [bp-4]
  5426 00001D24 8907                     mov  [bx], ax
  5427                                  
  5428                                  ;-848     arglen1--;
  5429                                  
  5430 00001D26 FF4EFE                   dec  word[bp-2]
  5431                                  
  5432                                  ;-849     toupper(argv);
  5433                                  
  5434 00001D29 FF36[5800]               push word [argv]
  5435 00001D2D E818F6                   call toupper
  5436 00001D30 83C402                   add  sp, 2
  5437                                  
  5438                                  ;-850 
  5439                                  
  5440                                  
  5441                                  ;-851     strcpy(namein, argv); strcat1(namein, ".S");
  5442                                  
  5443 00001D33 FF36[5800]               push word [argv]
  5444 00001D37 8D068C76                 lea  ax, [namein]
  5445 00001D3B 50                       push ax
  5446 00001D3C E862F5                   call strcpy
  5447 00001D3F 83C404                   add  sp, 4
  5448 00001D42 68[B51E]                 push getarg_1
  5449 00001D45 8D068C76                 lea  ax, [namein]
  5450 00001D49 50                       push ax
  5451 00001D4A E8D6F5                   call strcat1
  5452 00001D4D 83C404                   add  sp, 4
  5453                                  
  5454                                  ;-852     strcpy(namelst,argv); strcat1(namelst,".LST");
  5455                                  
  5456 00001D50 FF36[5800]               push word [argv]
  5457 00001D54 8D06CF76                 lea  ax, [namelst]
  5458 00001D58 50                       push ax
  5459 00001D59 E845F5                   call strcpy
  5460 00001D5C 83C404                   add  sp, 4
  5461 00001D5F 68[B81E]                 push getarg_2
  5462 00001D62 8D06CF76                 lea  ax, [namelst]
  5463 00001D66 50                       push ax
  5464 00001D67 E8B9F5                   call strcat1
  5465 00001D6A 83C404                   add  sp, 4
  5466                                  
  5467                                  ;-853     strcpy(namebin,argv); strcat1(namebin,".COM");
  5468                                  
  5469 00001D6D FF36[5800]               push word [argv]
  5470 00001D71 8D061277                 lea  ax, [namebin]
  5471 00001D75 50                       push ax
  5472 00001D76 E828F5                   call strcpy
  5473 00001D79 83C404                   add  sp, 4
  5474 00001D7C 68[BD1E]                 push getarg_3
  5475 00001D7F 8D061277                 lea  ax, [namebin]
  5476 00001D83 50                       push ax
  5477 00001D84 E89CF5                   call strcat1
  5478 00001D87 83C404                   add  sp, 4
  5479                                  
  5480                                  ;-854 
  5481                                  
  5482                                  
  5483                                  ;-855   DOS_ERR=0; PC=0; ErrorCount=0;
  5484                                  
  5485 00001D8A B80000                   mov ax, 0
  5486 00001D8D A3[1C00]                 mov word [DOS_ERR], ax
  5487 00001D90 B80000                   mov ax, 0
  5488 00001D93 A3[2300]                 mov word [PC], ax
  5489 00001D96 B80000                   mov ax, 0
  5490 00001D99 A3[1E00]                 mov word [ErrorCount], ax
  5491                                  
  5492                                  ;-856 
  5493                                  
  5494                                  
  5495                                  ;-857     asm_fd=openR (namein);
  5496                                  
  5497 00001D9C 8D068C76                 lea  ax, [namein]
  5498 00001DA0 50                       push ax
  5499 00001DA1 E83DF2                   call openR
  5500 00001DA4 83C402                   add  sp, 2
  5501 00001DA7 A3[1600]                 mov word [asm_fd], ax
  5502                                  
  5503                                  ;-858     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5504                                  
  5505 00001DAA A1[1C00]                 mov ax, [DOS_ERR]
  5506 00001DAD 08C0                     or  al, al
  5507 00001DAF 0F841C00                 je .getarg227
  5508 00001DB3 68[C21E]                 push getarg_4
  5509 00001DB6 E8F1F1                   call cputs
  5510 00001DB9 83C402                   add  sp, 2
  5511 00001DBC 8D068C76                 lea  ax, [namein]
  5512 00001DC0 50                       push ax
  5513 00001DC1 E8E6F1                   call cputs
  5514 00001DC4 83C402                   add  sp, 2
  5515 00001DC7 6A01                     push 1
  5516 00001DC9 E845F2                   call exitR
  5517 00001DCC 83C402                   add  sp, 2
  5518                                  
  5519                                  ;-859     lst_fd=creatR(namelst);
  5520                                  
  5521                                  .getarg227:
  5522 00001DCF 8D06CF76                 lea  ax, [namelst]
  5523 00001DD3 50                       push ax
  5524 00001DD4 E819F2                   call creatR
  5525 00001DD7 83C402                   add  sp, 2
  5526 00001DDA A3[1800]                 mov word [lst_fd], ax
  5527                                  
  5528                                  ;-860     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5529                                  
  5530 00001DDD A1[1C00]                 mov ax, [DOS_ERR]
  5531 00001DE0 08C0                     or  al, al
  5532 00001DE2 0F841C00                 je .getarg228
  5533 00001DE6 68[D81E]                 push getarg_5
  5534 00001DE9 E8BEF1                   call cputs
  5535 00001DEC 83C402                   add  sp, 2
  5536 00001DEF 8D06CF76                 lea  ax, [namelst]
  5537 00001DF3 50                       push ax
  5538 00001DF4 E8B3F1                   call cputs
  5539 00001DF7 83C402                   add  sp, 2
  5540 00001DFA 6A02                     push 2
  5541 00001DFC E812F2                   call exitR
  5542 00001DFF 83C402                   add  sp, 2
  5543                                  
  5544                                  ;-861     bin_fd=creatR(namebin);
  5545                                  
  5546                                  .getarg228:
  5547 00001E02 8D061277                 lea  ax, [namebin]
  5548 00001E06 50                       push ax
  5549 00001E07 E8E6F1                   call creatR
  5550 00001E0A 83C402                   add  sp, 2
  5551 00001E0D A3[1A00]                 mov word [bin_fd], ax
  5552                                  
  5553                                  ;-862     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5554                                  
  5555 00001E10 A1[1C00]                 mov ax, [DOS_ERR]
  5556 00001E13 08C0                     or  al, al
  5557 00001E15 0F841C00                 je .getarg229
  5558 00001E19 68[EF1E]                 push getarg_6
  5559 00001E1C E88BF1                   call cputs
  5560 00001E1F 83C402                   add  sp, 2
  5561 00001E22 8D061277                 lea  ax, [namebin]
  5562 00001E26 50                       push ax
  5563 00001E27 E880F1                   call cputs
  5564 00001E2A 83C402                   add  sp, 2
  5565 00001E2D 6A02                     push 2
  5566 00001E2F E8DFF1                   call exitR
  5567 00001E32 83C402                   add  sp, 2
  5568                                  
  5569                                  ;-863 
  5570                                  
  5571                                  
  5572                                  ;-864     prs(";");
  5573                                  
  5574                                  .getarg229:
  5575 00001E35 68[051F]                 push getarg_7
  5576 00001E38 E817FB                   call prs
  5577 00001E3B 83C402                   add  sp, 2
  5578                                  
  5579                                  ;-865     prs(Version1);
  5580                                  
  5581 00001E3E 8D06[0300]               lea  ax, [Version1]
  5582 00001E42 50                       push ax
  5583 00001E43 E80CFB                   call prs
  5584 00001E46 83C402                   add  sp, 2
  5585                                  
  5586                                  ;-866     prs(", Source: "); prs(namein);
  5587                                  
  5588 00001E49 68[071F]                 push getarg_8
  5589 00001E4C E803FB                   call prs
  5590 00001E4F 83C402                   add  sp, 2
  5591 00001E52 8D068C76                 lea  ax, [namein]
  5592 00001E56 50                       push ax
  5593 00001E57 E8F8FA                   call prs
  5594 00001E5A 83C402                   add  sp, 2
  5595                                  
  5596                                  ;-867     prs(", Output: "); prs(namelst);
  5597                                  
  5598 00001E5D 68[121F]                 push getarg_9
  5599 00001E60 E8EFFA                   call prs
  5600 00001E63 83C402                   add  sp, 2
  5601 00001E66 8D06CF76                 lea  ax, [namelst]
  5602 00001E6A 50                       push ax
  5603 00001E6B E8E4FA                   call prs
  5604 00001E6E 83C402                   add  sp, 2
  5605                                  
  5606                                  ;-868     prs(", "); prs(namebin);
  5607                                  
  5608 00001E71 68[1D1F]                 push getarg_10
  5609 00001E74 E8DBFA                   call prs
  5610 00001E77 83C402                   add  sp, 2
  5611 00001E7A 8D061277                 lea  ax, [namebin]
  5612 00001E7E 50                       push ax
  5613 00001E7F E8D0FA                   call prs
  5614 00001E82 83C402                   add  sp, 2
  5615                                  
  5616                                  ;-869     prs("\n");
  5617                                  
  5618 00001E85 68[201F]                 push getarg_11
  5619 00001E88 E8C7FA                   call prs
  5620 00001E8B 83C402                   add  sp, 2
  5621                                  
  5622                                  ;-870 }
  5623                                  
  5624                                  
  5625                                  ;-871 
  5626                                  
  5627                                  
  5628                                  ;-872 int fixJmpCall() {
  5629 00001E8E C9                       LEAVE
  5630 00001E8F C3                       ret
  5631 00001E90 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5632 00001E99 41532E434F4D206669-
  5633 00001EA2 6C656E616D65205B77-
  5634 00001EAB 2F6F202E535D203A20-
  5635 00001EB4 00                 
  5636 00001EB5 2E5300                  getarg_1 db ".S",0
  5637 00001EB8 2E4C535400              getarg_2 db ".LST",0
  5638 00001EBD 2E434F4D00              getarg_3 db ".COM",0
  5639 00001EC2 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5640 00001ECB 6C65206D697373696E-
  5641 00001ED4 673A2000           
  5642 00001ED8 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5643 00001EE1 206E6F742063726561-
  5644 00001EEA 74653A2000         
  5645 00001EEF 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5646 00001EF8 6E6F74206372656174-
  5647 00001F01 653A2000           
  5648 00001F05 3B00                    getarg_7 db ";",0
  5649 00001F07 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5650 00001F10 2000               
  5651 00001F12 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5652 00001F1B 2000               
  5653 00001F1D 2C2000                  getarg_10 db ", ",0
  5654 00001F20 5C6E00                  getarg_11 db "\n",0
  5655                                  ENDP
  5656                                  
  5657                                  fixJmpCall: PROC
  5658                                  
  5659                                  ;-873     int i;  unsigned int hex;  char *p; int Ix; char c;
  5660                                  
  5661                                  
  5662                                  ;-874     i=1;
  5663                                  
  5664                                  ;Function : fixJmpCall, Number of local variables: 5
  5665                                  ;   # type sign width addr used name   list of local variables
  5666                                  ;  200 var sign word   873 NULL i = bp-2
  5667                                  ;  201 var unsg word   873 NULL hex = bp-4
  5668                                  ;  202 ptr sign byte   873 NULL p = bp-6
  5669                                  ;  203 var sign word   873 NULL Ix = bp-8
  5670                                  ;  204 var sign byte   873 NULL c = bp-10;
  5671 00001F23 C80A0000                 ENTER  10,0
  5672 00001F27 B80100                   mov ax, 1
  5673 00001F2A 8946FE                   mov [bp-2], ax
  5674                                  
  5675                                  ;-875     prs("\n;END open jmp/call: ");
  5676                                  
  5677 00001F2D 68[E81F]                 push fixJmpCall_0
  5678 00001F30 E81FFA                   call prs
  5679 00001F33 83C402                   add  sp, 2
  5680                                  
  5681                                  ;-876     printIntU(JmpCallMaxIx);
  5682                                  
  5683 00001F36 FF36[5200]               push word [JmpCallMaxIx]
  5684 00001F3A E825FB                   call printIntU
  5685 00001F3D 83C402                   add  sp, 2
  5686                                  
  5687                                  ;-877     p = &JmpCallNames;
  5688                                  
  5689 00001F40 B8AA8B                   mov ax, JmpCallNames
  5690 00001F43 8946FA                   mov [bp-6], ax
  5691                                  
  5692                                  ;-878     while (i <= JmpCallMaxIx) {
  5693                                  
  5694                                  .fixJmpCall230:
  5695 00001F46 8B46FE                   mov ax, [bp-2]
  5696 00001F49 3B06[5200]               cmp ax, [JmpCallMaxIx]
  5697 00001F4D 0F8F9500                 jg  .fixJmpCall231
  5698                                  
  5699                                  ;-879         strcpy(Symbol, p);
  5700                                  
  5701 00001F51 FF76FA                   push word [bp-6]
  5702 00001F54 8D063075                 lea  ax, [Symbol]
  5703 00001F58 50                       push ax
  5704 00001F59 E845F3                   call strcpy
  5705 00001F5C 83C404                   add  sp, 4
  5706                                  
  5707                                  ;-880         p = strlen(Symbol) + p;
  5708                                  
  5709 00001F5F 8D063075                 lea  ax, [Symbol]
  5710 00001F63 50                       push ax
  5711 00001F64 E812F3                   call strlen
  5712 00001F67 83C402                   add  sp, 2
  5713 00001F6A 0346FA                   add ax, [bp-6]
  5714 00001F6D 8946FA                   mov [bp-6], ax
  5715                                  
  5716                                  ;-881         p++;
  5717                                  
  5718 00001F70 FF46FA                   inc  word[bp-6]
  5719                                  
  5720                                  ;-882 //        prs(Symbol);
  5721                                  
  5722                                  
  5723                                  ;-883 //        prc(' ');
  5724                                  
  5725                                  
  5726                                  ;-884         hex = JmpCallAddr[i];
  5727                                  
  5728 00001F73 8B5EFE                   mov bx, [bp-2]
  5729 00001F76 D1E3                     shl bx, 1
  5730 00001F78 8B877A93                 mov ax, [JmpCallAddr + bx]
  5731 00001F7C 8946FC                   mov [bp-4], ax
  5732                                  
  5733                                  ;-885 //        printhex16(hex);
  5734                                  
  5735                                  
  5736                                  ;-886 
  5737                                  
  5738                                  
  5739                                  ;-887         Ix=searchLabel();
  5740                                  
  5741 00001F7F E89CEC                   call searchLabel
  5742 00001F82 8946F8                   mov [bp-8], ax
  5743                                  
  5744                                  ;-888         if (Ix == 0) error1("Label not found");
  5745                                  
  5746 00001F85 8B46F8                   mov ax, [bp-8]
  5747 00001F88 83F800                   cmp ax, 0
  5748 00001F8B 0F850900                 jne .fixJmpCall232
  5749 00001F8F 68[FF1F]                 push fixJmpCall_1
  5750 00001F92 E80FFB                   call error1
  5751 00001F95 83C402                   add  sp, 2
  5752                                  
  5753                                  ;-889         disp = LabelAddr[Ix];
  5754                                  
  5755                                  .fixJmpCall232:
  5756 00001F98 8B5EF8                   mov bx, [bp-8]
  5757 00001F9B D1E3                     shl bx, 1
  5758 00001F9D 8B87FA86                 mov ax, [LabelAddr + bx]
  5759 00001FA1 A3[3D00]                 mov word [disp], ax
  5760                                  
  5761                                  ;-890         disp = disp - hex;
  5762                                  
  5763 00001FA4 A1[3D00]                 mov ax, [disp]
  5764 00001FA7 2B46FC                   sub ax, [bp-4]
  5765 00001FAA A3[3D00]                 mov word [disp], ax
  5766                                  
  5767                                  ;-891         disp = disp - Origin;
  5768                                  
  5769 00001FAD A1[3D00]                 mov ax, [disp]
  5770 00001FB0 2B06[2500]               sub ax, [Origin]
  5771 00001FB4 A3[3D00]                 mov word [disp], ax
  5772                                  
  5773                                  ;-892 //        prs(", ");
  5774                                  
  5775                                  
  5776                                  ;-893 
  5777                                  
  5778                                  
  5779                                  ;-894             hex = hex - 2;//fix at start of word
  5780                                  
  5781 00001FB7 8B46FC                   mov ax, [bp-4]
  5782 00001FBA 83E802                   sub ax, 2
  5783 00001FBD 8946FC                   mov [bp-4], ax
  5784                                  
  5785                                  ;-895             FileBin[hex] = disp;//fix low byte
  5786                                  
  5787 00001FC0 A1[3D00]                 mov ax, [disp]
  5788 00001FC3 8B5EFC                   mov bx, [bp-4]
  5789 00001FC6 88876297                 mov [FileBin+bx], al
  5790                                  
  5791                                  ;-896             hex++;
  5792                                  
  5793 00001FCA FF46FC                   inc  word[bp-4]
  5794                                  
  5795                                  ;-897             disp = disp >> 8;
  5796                                  
  5797 00001FCD A1[3D00]                 mov ax, [disp]
  5798 00001FD0 C1E808                   shr ax, 8
  5799 00001FD3 A3[3D00]                 mov word [disp], ax
  5800                                  
  5801                                  ;-898             FileBin[hex] = disp;
  5802                                  
  5803 00001FD6 A1[3D00]                 mov ax, [disp]
  5804 00001FD9 8B5EFC                   mov bx, [bp-4]
  5805 00001FDC 88876297                 mov [FileBin+bx], al
  5806                                  
  5807                                  ;-899         i++;
  5808                                  
  5809 00001FE0 FF46FE                   inc  word[bp-2]
  5810                                  
  5811                                  ;-900     }
  5812                                  
  5813                                  
  5814                                  ;-901 }
  5815                                  
  5816 00001FE3 E960FF                   jmp .fixJmpCall230
  5817                                  .fixJmpCall231:
  5818                                  
  5819                                  ;-902 
  5820                                  
  5821                                  
  5822                                  ;-903 int epilog() {
  5823 00001FE6 C9                       LEAVE
  5824 00001FE7 C3                       ret
  5825 00001FE8 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5826 00001FF1 656E206A6D702F6361-
  5827 00001FFA 6C6C3A2000         
  5828 00001FFF 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5829 00002008 20666F756E6400     
  5830                                  ENDP
  5831                                  
  5832                                  epilog: PROC
  5833                                  
  5834                                  ;-904     unsigned int i; char c;     int j;
  5835                                  
  5836                                  
  5837                                  ;-905     prs("\n Errors: ");
  5838                                  
  5839                                  ;Function : epilog, Number of local variables: 3
  5840                                  ;   # type sign width addr used name   list of local variables
  5841                                  ;  200 var unsg word   904 NULL i = bp-2
  5842                                  ;  201 var sign byte   904 NULL c = bp-4
  5843                                  ;  202 var sign word   904 NULL j = bp-6;
  5844 0000200F C8060000                 ENTER  6,0
  5845 00002013 68[CA20]                 push epilog_0
  5846 00002016 E839F9                   call prs
  5847 00002019 83C402                   add  sp, 2
  5848                                  
  5849                                  ;-906     printIntU(ErrorCount);
  5850                                  
  5851 0000201C FF36[1E00]               push word [ErrorCount]
  5852 00002020 E83FFA                   call printIntU
  5853 00002023 83C402                   add  sp, 2
  5854                                  
  5855                                  ;-907     if (ErrorCount) prs(" ***ERROR*** ");
  5856                                  
  5857 00002026 A1[1E00]                 mov ax, [ErrorCount]
  5858 00002029 08C0                     or  al, al
  5859 0000202B 0F840900                 je .epilog233
  5860 0000202F 68[D620]                 push epilog_1
  5861 00002032 E81DF9                   call prs
  5862 00002035 83C402                   add  sp, 2
  5863                                  
  5864                                  ;-908     prs(", Out: ");
  5865                                  
  5866                                  .epilog233:
  5867 00002038 68[E420]                 push epilog_2
  5868 0000203B E814F9                   call prs
  5869 0000203E 83C402                   add  sp, 2
  5870                                  
  5871                                  ;-909     prs(namelst);
  5872                                  
  5873 00002041 8D06CF76                 lea  ax, [namelst]
  5874 00002045 50                       push ax
  5875 00002046 E809F9                   call prs
  5876 00002049 83C402                   add  sp, 2
  5877                                  
  5878                                  ;-910     prs(", ");
  5879                                  
  5880 0000204C 68[EC20]                 push epilog_3
  5881 0000204F E800F9                   call prs
  5882 00002052 83C402                   add  sp, 2
  5883                                  
  5884                                  ;-911     prs(namebin);
  5885                                  
  5886 00002055 8D061277                 lea  ax, [namebin]
  5887 00002059 50                       push ax
  5888 0000205A E8F5F8                   call prs
  5889 0000205D 83C402                   add  sp, 2
  5890                                  
  5891                                  ;-912     prs("= ");
  5892                                  
  5893 00002060 68[EF20]                 push epilog_4
  5894 00002063 E8ECF8                   call prs
  5895 00002066 83C402                   add  sp, 2
  5896                                  
  5897                                  ;-913     printIntU(BinLen);
  5898                                  
  5899 00002069 FF36[5400]               push word [BinLen]
  5900 0000206D E8F2F9                   call printIntU
  5901 00002070 83C402                   add  sp, 2
  5902                                  
  5903                                  ;-914     prs(" bytes.");
  5904                                  
  5905 00002073 68[F220]                 push epilog_5
  5906 00002076 E8D9F8                   call prs
  5907 00002079 83C402                   add  sp, 2
  5908                                  
  5909                                  ;-915 
  5910                                  
  5911                                  
  5912                                  ;-916     i=0;
  5913                                  
  5914 0000207C B80000                   mov ax, 0
  5915 0000207F 8946FE                   mov [bp-2], ax
  5916                                  
  5917                                  ;-917     do {
  5918                                  
  5919                                  .epilog234:
  5920                                  
  5921                                  ;-918         c = FileBin[i];
  5922                                  
  5923 00002082 8B5EFE                   mov bx, [bp-2]
  5924 00002085 8A876297                 mov al, [FileBin + bx]
  5925 00002089 8846FC                   mov [bp-4], al
  5926                                  
  5927                                  ;-919         fputcR(c, bin_fd);
  5928                                  
  5929 0000208C FF36[1A00]               push word [bin_fd]
  5930 00002090 8A46FC                   mov al, byte [bp-4]
  5931 00002093 B400                     mov ah, 0
  5932 00002095 50                       push ax
  5933 00002096 E89BEF                   call fputcR
  5934 00002099 83C404                   add  sp, 4
  5935                                  
  5936                                  ;-920 //printhex8a(c); prc(' ');
  5937                                  
  5938                                  
  5939                                  ;-921         i++;
  5940                                  
  5941 0000209C FF46FE                   inc  word[bp-2]
  5942                                  
  5943                                  ;-922     } while (i < BinLen);
  5944                                  
  5945 0000209F 8B46FE                   mov ax, [bp-2]
  5946 000020A2 3B06[5400]               cmp ax, [BinLen]
  5947 000020A6 0F8D0200                 jge .epilog235
  5948 000020AA EBD6                     jmp .epilog234
  5949                                  .epilog235:
  5950                                  
  5951                                  ;-923 
  5952                                  
  5953                                  
  5954                                  ;-924   prs(" Labels: ");
  5955                                  
  5956 000020AC 68[FA20]                 push epilog_6
  5957 000020AF E8A0F8                   call prs
  5958 000020B2 83C402                   add  sp, 2
  5959                                  
  5960                                  ;-925   printIntU(LabelMaxIx);
  5961                                  
  5962 000020B5 FF36[4A00]               push word [LabelMaxIx]
  5963 000020B9 E8A6F9                   call printIntU
  5964 000020BC 83C402                   add  sp, 2
  5965                                  
  5966                                  ;-926   prs(". ");
  5967                                  
  5968 000020BF 68[0421]                 push epilog_7
  5969 000020C2 E88DF8                   call prs
  5970 000020C5 83C402                   add  sp, 2
  5971                                  
  5972                                  ;-927 /*
  5973                                  
  5974                                  
  5975                                  ;-928   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);
  5976                                  
  5977                                  
  5978                                  ;-929   i= &LabelNames;
  5979                                  
  5980                                  
  5981                                  ;-930   prs(" &LabelNames:"); printIntU(i);
  5982                                  
  5983                                  
  5984                                  ;-931   i=LabelNamePtr-i;
  5985                                  
  5986                                  
  5987                                  ;-932   prs("size: ");
  5988                                  
  5989                                  
  5990                                  ;-933   printIntU(i);
  5991                                  
  5992                                  
  5993                                  ;-934   prs(". >>");
  5994                                  
  5995                                  
  5996                                  ;-935   i= &LabelNames;
  5997                                  
  5998                                  
  5999                                  ;-936   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6000                                  
  6001                                  
  6002                                  ;-937   } while (i < LabelNamePtr); prs("<< \n");
  6003                                  
  6004                                  
  6005                                  ;-938    i = 1;
  6006                                  
  6007                                  
  6008                                  ;-939     LabelNamePtr= &LabelNames;
  6009                                  
  6010                                  
  6011                                  ;-940     do {
  6012                                  
  6013                                  
  6014                                  ;-941       prs(LabelNamePtr); prc(' ');
  6015                                  
  6016                                  
  6017                                  ;-942       j=LabelAddr[i]; printhex16(j); prs(", ");
  6018                                  
  6019                                  
  6020                                  ;-943       j=strlen(LabelNamePtr);//get end of actual name
  6021                                  
  6022                                  
  6023                                  ;-944       LabelNamePtr=LabelNamePtr+j;
  6024                                  
  6025                                  
  6026                                  ;-945       LabelNamePtr++;
  6027                                  
  6028                                  
  6029                                  ;-946       i++;
  6030                                  
  6031                                  
  6032                                  ;-947     } while (i <= LabelMaxIx);
  6033                                  
  6034                                  
  6035                                  ;-948 */
  6036                                  
  6037                                  
  6038                                  ;-949 }
  6039                                  
  6040                                  
  6041                                  ;-950 
  6042                                  
  6043                                  
  6044                                  ;-951 int end1(int n) {
  6045 000020C8 C9                       LEAVE
  6046 000020C9 C3                       ret
  6047 000020CA 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6048 000020D3 3A2000             
  6049 000020D6 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6050 000020DF 2A2A2A2000         
  6051 000020E4 2C204F75743A2000        epilog_2 db ", Out: ",0
  6052 000020EC 2C2000                  epilog_3 db ", ",0
  6053 000020EF 3D2000                  epilog_4 db "= ",0
  6054 000020F2 2062797465732E00        epilog_5 db " bytes.",0
  6055 000020FA 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6056 00002103 00                 
  6057 00002104 2E2000                  epilog_7 db ". ",0
  6058                                  ENDP
  6059                                  
  6060                                  end1: PROC
  6061                                  
  6062                                  ;-952     fcloseR(asm_fd);
  6063                                  
  6064                                  ;Function : end1, Number of local variables: 1
  6065                                  ;   # type sign width addr used name   list of local variables
  6066                                  ;  200 var sign word   951 NULL n = bp+4;
  6067 00002107 C8000000                 ENTER  0,0
  6068 0000210B FF36[1600]               push word [asm_fd]
  6069 0000210F E8F0EE                   call fcloseR
  6070 00002112 83C402                   add  sp, 2
  6071                                  
  6072                                  ;-953     fcloseR(lst_fd);
  6073                                  
  6074 00002115 FF36[1800]               push word [lst_fd]
  6075 00002119 E8E6EE                   call fcloseR
  6076 0000211C 83C402                   add  sp, 2
  6077                                  
  6078                                  ;-954     fcloseR(bin_fd);
  6079                                  
  6080 0000211F FF36[1A00]               push word [bin_fd]
  6081 00002123 E8DCEE                   call fcloseR
  6082 00002126 83C402                   add  sp, 2
  6083                                  
  6084                                  ;-955     exitR(n);
  6085                                  
  6086 00002129 FF7604                   push word [bp+4]
  6087 0000212C E8E2EE                   call exitR
  6088 0000212F 83C402                   add  sp, 2
  6089                                  
  6090                                  ;-956 }
  6091                                  
  6092                                  
  6093                                  ;-957 
  6094                                  
  6095                                  
  6096                                  ;-958 
  6097                                  
  6098                                  
  6099                                  ;-959 //#include "GENCODE.C"
  6100                                  
  6101                                  
  6102                                  ;-960 // generate code
  6103                                  
  6104                                  
  6105                                  ;-961 int getCodes() {
  6106 00002132 C9                       LEAVE
  6107 00002133 C3                       ret
  6108                                  ENDP
  6109                                  
  6110                                  getCodes: PROC
  6111                                  
  6112                                  ;-962     OpCodePtr ++; Code1 = *OpCodePtr;
  6113                                  
  6114 00002134 FF06[4300]               inc  word[OpCodePtr]
  6115 00002138 8B1E[4300]               mov bx, [OpCodePtr]
  6116 0000213C 8A07                     mov al, [bx]
  6117 0000213E B400                     mov ah, 0
  6118 00002140 A2[3000]                 mov byte [Code1], al
  6119                                  
  6120                                  ;-963     OpCodePtr ++; Code2 = *OpCodePtr;
  6121                                  
  6122 00002143 FF06[4300]               inc  word[OpCodePtr]
  6123 00002147 8B1E[4300]               mov bx, [OpCodePtr]
  6124 0000214B 8A07                     mov al, [bx]
  6125 0000214D B400                     mov ah, 0
  6126 0000214F A2[3100]                 mov byte [Code2], al
  6127                                  
  6128                                  ;-964     OpCodePtr ++; Code3 = *OpCodePtr;
  6129                                  
  6130 00002152 FF06[4300]               inc  word[OpCodePtr]
  6131 00002156 8B1E[4300]               mov bx, [OpCodePtr]
  6132 0000215A 8A07                     mov al, [bx]
  6133 0000215C B400                     mov ah, 0
  6134 0000215E A2[3200]                 mov byte [Code3], al
  6135                                  
  6136                                  ;-965 }
  6137                                  
  6138                                  
  6139                                  ;-966 int gen66h() {genCode8(0x66);
  6140                                  
  6141 00002161 C3                       ret
  6142                                  ENDP
  6143                                  
  6144                                  gen66h: PROC
  6145 00002162 6A66                     push 102
  6146 00002164 E83B00                   call genCode8
  6147 00002167 83C402                   add  sp, 2
  6148                                  
  6149                                  ;-967 }
  6150                                  
  6151                                  
  6152                                  ;-968 int genCode2(char c, char d) {
  6153                                  
  6154 0000216A C3                       ret
  6155                                  ENDP
  6156                                  
  6157                                  genCode2: PROC
  6158                                  
  6159                                  ;-969     c = c + d;
  6160                                  
  6161                                  ;Function : genCode2, Number of local variables: 2
  6162                                  ;   # type sign width addr used name   list of local variables
  6163                                  ;  200 var sign byte   968 NULL c = bp+4
  6164                                  ;  201 var sign byte   968 NULL d = bp+6;
  6165 0000216B C8000000                 ENTER  0,0
  6166 0000216F 8A4604                   mov al, [bp+4]
  6167 00002172 024606                   add al, [bp+6]
  6168 00002175 884604                   mov [bp+4], al
  6169                                  
  6170                                  ;-970     genCode8(c);
  6171                                  
  6172 00002178 8A4604                   mov al, byte [bp+4]
  6173 0000217B B400                     mov ah, 0
  6174 0000217D 50                       push ax
  6175 0000217E E82100                   call genCode8
  6176 00002181 83C402                   add  sp, 2
  6177                                  
  6178                                  ;-971 }
  6179                                  
  6180                                  
  6181                                  ;-972 int genCodeW(char c) {
  6182 00002184 C9                       LEAVE
  6183 00002185 C3                       ret
  6184                                  ENDP
  6185                                  
  6186                                  genCodeW: PROC
  6187                                  
  6188                                  ;-973     c = c + wflag;
  6189                                  
  6190                                  ;Function : genCodeW, Number of local variables: 1
  6191                                  ;   # type sign width addr used name   list of local variables
  6192                                  ;  200 var sign byte   972 NULL c = bp+4;
  6193 00002186 C8000000                 ENTER  0,0
  6194 0000218A 8A4604                   mov al, [bp+4]
  6195 0000218D 0206[3800]               add al, [wflag]
  6196 00002191 884604                   mov [bp+4], al
  6197                                  
  6198                                  ;-974     genCode8(c);
  6199                                  
  6200 00002194 8A4604                   mov al, byte [bp+4]
  6201 00002197 B400                     mov ah, 0
  6202 00002199 50                       push ax
  6203 0000219A E80500                   call genCode8
  6204 0000219D 83C402                   add  sp, 2
  6205                                  
  6206                                  ;-975 }
  6207                                  
  6208                                  
  6209                                  ;-976 int genCode8(char c) {
  6210 000021A0 C9                       LEAVE
  6211 000021A1 C3                       ret
  6212                                  ENDP
  6213                                  
  6214                                  genCode8: PROC
  6215                                  
  6216                                  ;-977 //set: BinLen++, OpPrintIndex++
  6217                                  
  6218                                  
  6219                                  ;-978     FileBin[BinLen]=c;
  6220                                  
  6221                                  ;Function : genCode8, Number of local variables: 1
  6222                                  ;   # type sign width addr used name   list of local variables
  6223                                  ;  200 var sign byte   976 NULL c = bp+4;
  6224 000021A2 C8000000                 ENTER  0,0
  6225 000021A6 8A4604                   mov al, [bp+4]
  6226 000021A9 8B1E[5400]               mov bx, [BinLen]
  6227 000021AD 88876297                 mov [FileBin+bx], al
  6228                                  
  6229                                  ;-979     BinLen++;
  6230                                  
  6231 000021B1 FF06[5400]               inc  word[BinLen]
  6232                                  
  6233                                  ;-980     PC++;
  6234                                  
  6235 000021B5 FF06[2300]               inc  word[PC]
  6236                                  
  6237                                  ;-981     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6238                                  
  6239 000021B9 A1[5400]                 mov ax, [BinLen]
  6240 000021BC 3D204E                   cmp ax, 20000 ;unsigned : 0
  6241 000021BF 0F820900                 jb  .genCode8236
  6242 000021C3 68[E721]                 push genCode8_0
  6243 000021C6 E831F9                   call errorexit
  6244 000021C9 83C402                   add  sp, 2
  6245                                  
  6246                                  ;-982     if (OpPrintIndex < OPMAXLEN) {
  6247                                  
  6248                                  .genCode8236:
  6249 000021CC A1[4100]                 mov ax, [OpPrintIndex]
  6250 000021CF 83F805                   cmp ax, 5
  6251 000021D2 0F8D0F00                 jge .genCode8237
  6252                                  
  6253                                  ;-983         OpPos[OpPrintIndex]=c;
  6254                                  
  6255 000021D6 8A4604                   mov al, [bp+4]
  6256 000021D9 8B1E[4100]               mov bx, [OpPrintIndex]
  6257 000021DD 88875577                 mov [OpPos+bx], al
  6258                                  
  6259                                  ;-984         OpPrintIndex++;
  6260                                  
  6261 000021E1 FF06[4100]               inc  word[OpPrintIndex]
  6262                                  
  6263                                  ;-985     }
  6264                                  
  6265                                  
  6266                                  ;-986 }
  6267                                  
  6268                                  .genCode8237:
  6269                                  
  6270                                  ;-987 int genCode16(unsigned int i) {
  6271 000021E5 C9                       LEAVE
  6272 000021E6 C3                       ret
  6273 000021E7 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6274 000021F0 746F6F206C6F6E6700 
  6275                                  ENDP
  6276                                  
  6277                                  genCode16: PROC
  6278                                  
  6279                                  ;-988     genCode8(i); i=i >> 8;
  6280                                  
  6281                                  ;Function : genCode16, Number of local variables: 1
  6282                                  ;   # type sign width addr used name   list of local variables
  6283                                  ;  200 var unsg word   987 NULL i = bp+4;
  6284 000021F9 C8000000                 ENTER  0,0
  6285 000021FD FF7604                   push word [bp+4]
  6286 00002200 E89FFF                   call genCode8
  6287 00002203 83C402                   add  sp, 2
  6288 00002206 8B4604                   mov ax, [bp+4]
  6289 00002209 C1E808                   shr ax, 8
  6290 0000220C 894604                   mov [bp+4], ax
  6291                                  
  6292                                  ;-989     genCode8(i);
  6293                                  
  6294 0000220F FF7604                   push word [bp+4]
  6295 00002212 E88DFF                   call genCode8
  6296 00002215 83C402                   add  sp, 2
  6297                                  
  6298                                  ;-990 }
  6299                                  
  6300                                  
  6301                                  ;-991 int genCode32(unsigned long L) {
  6302 00002218 C9                       LEAVE
  6303 00002219 C3                       ret
  6304                                  ENDP
  6305                                  
  6306                                  genCode32: PROC
  6307                                  
  6308                                  ;-992     genCode16(L); L=L >>16;
  6309                                  
  6310                                  ;Function : genCode32, Number of local variables: 1
  6311                                  ;   # type sign width addr used name   list of local variables
  6312                                  ;  200 var unsg dwrd   991 NULL L = bp+4;
  6313 0000221A C8000000                 ENTER  0,0
  6314 0000221E 8A4604                   mov al, byte [bp+4]
  6315 00002221 B400                     mov ah, 0
  6316 00002223 50                       push ax
  6317 00002224 E8D2FF                   call genCode16
  6318 00002227 83C402                   add  sp, 2
  6319 0000222A 668B4604                 mov eax, [bp+4]
  6320 0000222E 66C1E810                 shr eax, 16
  6321 00002232 66894604                 mov [bp+4], eax
  6322                                  
  6323                                  ;-993     genCode16(L);
  6324                                  
  6325 00002236 8A4604                   mov al, byte [bp+4]
  6326 00002239 B400                     mov ah, 0
  6327 0000223B 50                       push ax
  6328 0000223C E8BAFF                   call genCode16
  6329 0000223F 83C402                   add  sp, 2
  6330                                  
  6331                                  ;-994 }
  6332                                  
  6333                                  
  6334                                  ;-995 int writeEA(char xxx) {//value for reg/operand
  6335 00002242 C9                       LEAVE
  6336 00002243 C3                       ret
  6337                                  ENDP
  6338                                  
  6339                                  writeEA: PROC
  6340                                  
  6341                                  ;-996 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6342                                  
  6343                                  
  6344                                  ;-997 //mod-bits: mode76, reg/opcode543, r/m210
  6345                                  
  6346                                  
  6347                                  ;-998 //Op: 0, IMM, REG, ADR, MEM
  6348                                  
  6349                                  
  6350                                  ;-999     char len;
  6351                                  
  6352                                  
  6353                                  ;-1000     len=0;
  6354                                  
  6355                                  ;Function : writeEA, Number of local variables: 2
  6356                                  ;   # type sign width addr used name   list of local variables
  6357                                  ;  200 var sign byte   995 NULL xxx = bp+4
  6358                                  ;  201 var sign byte   999 NULL len = bp-2;
  6359 00002244 C8020000                 ENTER  2,0
  6360 00002248 B80000                   mov ax, 0
  6361 0000224B 8846FE                   mov [bp-2], al
  6362                                  
  6363                                  ;-1001     xxx = xxx << 3;//in reg/opcode field
  6364                                  
  6365 0000224E 8A4604                   mov al, [bp+4]
  6366 00002251 C0E003                   shl al, 3
  6367 00002254 884604                   mov [bp+4], al
  6368                                  
  6369                                  ;-1002     if (Op == REG) {
  6370                                  
  6371 00002257 A0[2D00]                 mov al, [Op]
  6372 0000225A 3C02                     cmp al, 2
  6373 0000225C 0F853A00                 jne .writeEA238
  6374                                  
  6375                                  ;-1003         xxx |= 0xC0;
  6376                                  
  6377 00002260 804E04C0                 or  byte[bp+4], 192
  6378                                  
  6379                                  ;-1004         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  6380                                  
  6381 00002264 A0[2E00]                 mov al, [Op2]
  6382 00002267 3C01                     cmp al, 1
  6383 00002269 0F8F0D00                 jg  .writeEA239
  6384 0000226D 8A4604                   mov al, [bp+4]
  6385 00002270 0206[3400]               add al, [R1No]
  6386 00002274 884604                   mov [bp+4], al
  6387                                  
  6388                                  ;-1005             else {
  6389                                  
  6390 00002277 E92000                   jmp .writeEA240
  6391                                  .writeEA239:
  6392                                  
  6393                                  ;-1006                 if (Op2 == REG) xxx = xxx + R1No;
  6394                                  
  6395 0000227A A0[2E00]                 mov al, [Op2]
  6396 0000227D 3C02                     cmp al, 2
  6397 0000227F 0F850D00                 jne .writeEA241
  6398 00002283 8A4604                   mov al, [bp+4]
  6399 00002286 0206[3400]               add al, [R1No]
  6400 0000228A 884604                   mov [bp+4], al
  6401                                  
  6402                                  ;-1007                 else            xxx = xxx + R2No;
  6403                                  
  6404 0000228D E90A00                   jmp .writeEA242
  6405                                  .writeEA241:
  6406 00002290 8A4604                   mov al, [bp+4]
  6407 00002293 0206[3300]               add al, [R2No]
  6408 00002297 884604                   mov [bp+4], al
  6409                                  
  6410                                  ;-1008             }
  6411                                  
  6412                                  .writeEA242:
  6413                                  
  6414                                  ;-1009         }
  6415                                  
  6416                                  .writeEA240:
  6417                                  
  6418                                  ;-1010     if (Op == MEM) {
  6419                                  
  6420                                  .writeEA238:
  6421 0000229A A0[2D00]                 mov al, [Op]
  6422 0000229D 3C04                     cmp al, 4
  6423 0000229F 0F857300                 jne .writeEA243
  6424                                  
  6425                                  ;-1011         if (isDirect) {
  6426                                  
  6427 000022A3 A0[3C00]                 mov al, [isDirect]
  6428 000022A6 08C0                     or  al, al
  6429 000022A8 0F840D00                 je .writeEA244
  6430                                  
  6431                                  ;-1012             xxx |= 6;
  6432                                  
  6433 000022AC 804E0406                 or  byte[bp+4], 6
  6434                                  
  6435                                  ;-1013             len = 2;
  6436                                  
  6437 000022B0 B80200                   mov ax, 2
  6438 000022B3 8846FE                   mov [bp-2], al
  6439                                  
  6440                                  ;-1014         }
  6441                                  
  6442                                  
  6443                                  ;-1015         else {
  6444                                  
  6445 000022B6 E95D00                   jmp .writeEA245
  6446                                  .writeEA244:
  6447                                  
  6448                                  ;-1016             xxx = xxx + rm;
  6449                                  
  6450 000022B9 8A4604                   mov al, [bp+4]
  6451 000022BC 0206[3B00]               add al, [rm]
  6452 000022C0 884604                   mov [bp+4], al
  6453                                  
  6454                                  ;-1017             if (rm == 6) {//make [BP+00]
  6455                                  
  6456 000022C3 A0[3B00]                 mov al, [rm]
  6457 000022C6 3C06                     cmp al, 6
  6458 000022C8 0F851400                 jne .writeEA246
  6459                                  
  6460                                  ;-1018                 len=1;
  6461                                  
  6462 000022CC B80100                   mov ax, 1
  6463 000022CF 8846FE                   mov [bp-2], al
  6464                                  
  6465                                  ;-1019                 if (disp == 0) xxx |= 0x40;
  6466                                  
  6467 000022D2 A1[3D00]                 mov ax, [disp]
  6468 000022D5 83F800                   cmp ax, 0
  6469 000022D8 0F850400                 jne .writeEA247
  6470 000022DC 804E0440                 or  byte[bp+4], 64
  6471                                  
  6472                                  ;-1020             }
  6473                                  
  6474                                  .writeEA247:
  6475                                  
  6476                                  ;-1021 
  6477                                  
  6478                                  
  6479                                  ;-1022             if (disp) {
  6480                                  
  6481                                  .writeEA246:
  6482 000022E0 A1[3D00]                 mov ax, [disp]
  6483 000022E3 08C0                     or  al, al
  6484 000022E5 0F842D00                 je .writeEA248
  6485                                  
  6486                                  ;-1023                 ax = disp;
  6487                                  
  6488 000022E9 A1[3D00]                 mov  ax, [disp]
  6489                                  
  6490                                  ;-1024                 if(ax > 127) len=2;
  6491                                  
  6492 000022EC 83F87F                   cmp  ax, 127
  6493 000022EF 0F8E0900                 jle .writeEA249
  6494 000022F3 B80200                   mov ax, 2
  6495 000022F6 8846FE                   mov [bp-2], al
  6496                                  
  6497                                  ;-1025                 else len=1;
  6498                                  
  6499 000022F9 E90600                   jmp .writeEA250
  6500                                  .writeEA249:
  6501 000022FC B80100                   mov ax, 1
  6502 000022FF 8846FE                   mov [bp-2], al
  6503                                  
  6504                                  ;-1026                 if (len == 1) xxx |= 0x40;
  6505                                  
  6506                                  .writeEA250:
  6507 00002302 8A46FE                   mov al, [bp-2]
  6508 00002305 3C01                     cmp al, 1
  6509 00002307 0F850700                 jne .writeEA251
  6510 0000230B 804E0440                 or  byte[bp+4], 64
  6511                                  
  6512                                  ;-1027                 else xxx |= 0x80;
  6513                                  
  6514 0000230F E90400                   jmp .writeEA252
  6515                                  .writeEA251:
  6516 00002312 804E0480                 or  byte[bp+4], 128
  6517                                  
  6518                                  ;-1028             }
  6519                                  
  6520                                  .writeEA252:
  6521                                  
  6522                                  ;-1029         }
  6523                                  
  6524                                  .writeEA248:
  6525                                  
  6526                                  ;-1030     }
  6527                                  
  6528                                  .writeEA245:
  6529                                  
  6530                                  ;-1031 
  6531                                  
  6532                                  
  6533                                  ;-1032     genCode8(xxx);// gen second byte
  6534                                  
  6535                                  .writeEA243:
  6536 00002316 8A4604                   mov al, byte [bp+4]
  6537 00002319 B400                     mov ah, 0
  6538 0000231B 50                       push ax
  6539 0000231C E883FE                   call genCode8
  6540 0000231F 83C402                   add  sp, 2
  6541                                  
  6542                                  ;-1033     if (len == 1) genCode8 (disp);
  6543                                  
  6544 00002322 8A46FE                   mov al, [bp-2]
  6545 00002325 3C01                     cmp al, 1
  6546 00002327 0F850A00                 jne .writeEA253
  6547 0000232B FF36[3D00]               push word [disp]
  6548 0000232F E870FE                   call genCode8
  6549 00002332 83C402                   add  sp, 2
  6550                                  
  6551                                  ;-1034     if (len == 2) genCode16(disp);
  6552                                  
  6553                                  .writeEA253:
  6554 00002335 8A46FE                   mov al, [bp-2]
  6555 00002338 3C02                     cmp al, 2
  6556 0000233A 0F850A00                 jne .writeEA254
  6557 0000233E FF36[3D00]               push word [disp]
  6558 00002342 E8B4FE                   call genCode16
  6559 00002345 83C402                   add  sp, 2
  6560                                  
  6561                                  ;-1035 }
  6562                                  
  6563                                  .writeEA254:
  6564                                  
  6565                                  ;-1036 
  6566                                  
  6567                                  
  6568                                  ;-1037 int genImmediate() {
  6569 00002348 C9                       LEAVE
  6570 00002349 C3                       ret
  6571                                  ENDP
  6572                                  
  6573                                  genImmediate: PROC
  6574                                  
  6575                                  ;-1038     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6576                                  
  6577 0000234A A0[3800]                 mov al, [wflag]
  6578 0000234D 08C0                     or  al, al
  6579 0000234F 0F842300                 je .genImmediate255
  6580 00002353 A0[3700]                 mov al, [OpSize]
  6581 00002356 3C03                     cmp al, 3
  6582 00002358 0F850D00                 jne .genImmediate256
  6583 0000235C FF36[3F00]               push word [imme]
  6584 00002360 E8B7FE                   call genCode32
  6585 00002363 83C402                   add  sp, 2
  6586                                  
  6587                                  ;-1039         else genCode16(imme);
  6588                                  
  6589 00002366 E90A00                   jmp .genImmediate257
  6590                                  .genImmediate256:
  6591 00002369 FF36[3F00]               push word [imme]
  6592 0000236D E889FE                   call genCode16
  6593 00002370 83C402                   add  sp, 2
  6594                                  
  6595                                  ;-1040     else       genCode8 (imme);
  6596                                  
  6597                                  .genImmediate257:
  6598 00002373 E90A00                   jmp .genImmediate258
  6599                                  .genImmediate255:
  6600 00002376 FF36[3F00]               push word [imme]
  6601 0000237A E825FE                   call genCode8
  6602 0000237D 83C402                   add  sp, 2
  6603                                  
  6604                                  ;-1041 }
  6605                                  
  6606                                  .genImmediate258:
  6607                                  
  6608                                  ;-1042 
  6609                                  
  6610                                  
  6611                                  ;-1043 //AS.C
  6612                                  
  6613                                  
  6614                                  ;-1044 int process() {
  6615                                  
  6616 00002380 C3                       ret
  6617                                  ENDP
  6618                                  
  6619                                  process: PROC
  6620                                  
  6621                                  ;-1045     char c;
  6622                                  
  6623                                  
  6624                                  ;-1046     int i;
  6625                                  
  6626                                  
  6627                                  ;-1047     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6628                                  
  6629                                  ;Function : process, Number of local variables: 2
  6630                                  ;   # type sign width addr used name   list of local variables
  6631                                  ;  200 var sign byte  1045 NULL c = bp-2
  6632                                  ;  201 var sign word  1046 NULL i = bp-4;
  6633 00002381 C8040000                 ENTER  4,0
  6634 00002385 B80000                   mov ax, 0
  6635 00002388 A2[3B00]                 mov byte [rm], al
  6636 0000238B A2[3800]                 mov byte [wflag], al
  6637 0000238E A2[3900]                 mov byte [dflag], al
  6638 00002391 A2[3300]                 mov byte [R2No], al
  6639 00002394 A2[3400]                 mov byte [R1No], al
  6640 00002397 A2[3500]                 mov byte [R2Type], al
  6641 0000239A A2[3600]                 mov byte [R1Type], al
  6642 0000239D A2[2E00]                 mov byte [Op2], al
  6643 000023A0 A2[2D00]                 mov byte [Op], al
  6644                                  
  6645                                  ;-1048     disp=imme=0;//int
  6646                                  
  6647 000023A3 B80000                   mov ax, 0
  6648 000023A6 A3[3F00]                 mov word [imme], ax
  6649 000023A9 A3[3D00]                 mov word [disp], ax
  6650                                  
  6651                                  ;-1049     isDirect=1; //set in getMeM=0, need in WriteEA
  6652                                  
  6653 000023AC B80100                   mov ax, 1
  6654 000023AF A2[3C00]                 mov byte [isDirect], al
  6655                                  
  6656                                  ;-1050     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6657                                  
  6658 000023B2 E8B1E6                   call getTokeType
  6659                                  
  6660                                  ;-1051     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6661                                  
  6662 000023B5 E8CAEA                   call getCodeSize
  6663 000023B8 A2[3700]                 mov byte [OpSize], al
  6664                                  
  6665                                  ;-1052     getCodes();//set: Code1, Code2, Code3
  6666                                  
  6667 000023BB E876FD                   call getCodes
  6668                                  
  6669                                  ;-1053 
  6670                                  
  6671                                  
  6672                                  ;-1054     if (CodeType ==  1) {//1 byte opcode
  6673                                  
  6674 000023BE A0[2F00]                 mov al, [CodeType]
  6675 000023C1 3C01                     cmp al, 1
  6676 000023C3 0F850F00                 jne .process259
  6677                                  
  6678                                  ;-1055         genCode8(Code1);
  6679                                  
  6680 000023C7 A0[3000]                 mov al, byte [Code1]
  6681 000023CA B400                     mov ah, 0
  6682 000023CC 50                       push ax
  6683 000023CD E8D2FD                   call genCode8
  6684 000023D0 83C402                   add  sp, 2
  6685                                  
  6686                                  ;-1056         return;
  6687                                  
  6688 000023D3 E94808                   jmp .retnprocess
  6689                                  
  6690                                  ;-1057     }
  6691                                  
  6692                                  
  6693                                  ;-1058 
  6694                                  
  6695                                  
  6696                                  ;-1059     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6697                                  
  6698                                  .process259:
  6699 000023D6 A0[2F00]                 mov al, [CodeType]
  6700 000023D9 3C02                     cmp al, 2
  6701 000023DB 0F856900                 jne .process260
  6702                                  
  6703                                  ;-1060         getOpL();
  6704                                  
  6705 000023DF E8A9E1                   call getOpL
  6706                                  
  6707                                  ;-1061         checkOpL();
  6708                                  
  6709 000023E2 E8C9E0                   call checkOpL
  6710                                  
  6711                                  ;-1062         if (Code2 <= 1) {//inc,dec
  6712                                  
  6713 000023E5 A0[3100]                 mov al, [Code2]
  6714 000023E8 3C01                     cmp al, 1
  6715 000023EA 0F8F2700                 jg  .process261
  6716                                  
  6717                                  ;-1063   	        if (Op == REG) {//short
  6718                                  
  6719 000023EE A0[2D00]                 mov al, [Op]
  6720 000023F1 3C02                     cmp al, 2
  6721 000023F3 0F851E00                 jne .process262
  6722                                  
  6723                                  ;-1064                 if (wflag) {genCode2(Code3, R1No); return; }
  6724                                  
  6725 000023F7 A0[3800]                 mov al, [wflag]
  6726 000023FA 08C0                     or  al, al
  6727 000023FC 0F841500                 je .process263
  6728 00002400 A0[3400]                 mov al, byte [R1No]
  6729 00002403 B400                     mov ah, 0
  6730 00002405 50                       push ax
  6731 00002406 A0[3200]                 mov al, byte [Code3]
  6732 00002409 B400                     mov ah, 0
  6733 0000240B 50                       push ax
  6734 0000240C E85CFD                   call genCode2
  6735 0000240F 83C404                   add  sp, 4
  6736 00002412 E90908                   jmp .retnprocess
  6737                                  
  6738                                  ;-1065             }
  6739                                  
  6740                                  .process263:
  6741                                  
  6742                                  ;-1066         }
  6743                                  
  6744                                  .process262:
  6745                                  
  6746                                  ;-1067         if (Code2 == 5) {//imul extension?
  6747                                  
  6748                                  .process261:
  6749 00002415 A0[3100]                 mov al, [Code2]
  6750 00002418 3C05                     cmp al, 5
  6751 0000241A 0F850F00                 jne .process264
  6752                                  
  6753                                  ;-1068             getTokeType();
  6754                                  
  6755 0000241E E845E6                   call getTokeType
  6756                                  
  6757                                  ;-1069             if (TokeType) implerror();
  6758                                  
  6759 00002421 A0[2C00]                 mov al, [TokeType]
  6760 00002424 08C0                     or  al, al
  6761 00002426 0F840300                 je .process265
  6762 0000242A E841F7                   call implerror
  6763                                  
  6764                                  ;-1070         }
  6765                                  
  6766                                  .process265:
  6767                                  
  6768                                  ;-1071         genCodeW(Code1);
  6769                                  
  6770                                  .process264:
  6771 0000242D A0[3000]                 mov al, byte [Code1]
  6772 00002430 B400                     mov ah, 0
  6773 00002432 50                       push ax
  6774 00002433 E850FD                   call genCodeW
  6775 00002436 83C402                   add  sp, 2
  6776                                  
  6777                                  ;-1072         writeEA(Code2);
  6778                                  
  6779 00002439 A0[3100]                 mov al, byte [Code2]
  6780 0000243C B400                     mov ah, 0
  6781 0000243E 50                       push ax
  6782 0000243F E802FE                   call writeEA
  6783 00002442 83C402                   add  sp, 2
  6784                                  
  6785                                  ;-1073         return;
  6786                                  
  6787 00002445 E9D607                   jmp .retnprocess
  6788                                  
  6789                                  ;-1074     }
  6790                                  
  6791                                  
  6792                                  ;-1075 
  6793                                  
  6794                                  
  6795                                  ;-1076     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6796                                  
  6797                                  .process260:
  6798 00002448 A0[2F00]                 mov al, [CodeType]
  6799 0000244B 3C03                     cmp al, 3
  6800 0000244D 0F855100                 jne .process266
  6801                                  
  6802                                  ;-1077         check2Ops();    //setwflag not applicable
  6803                                  
  6804 00002451 E8DCE0                   call check2Ops
  6805                                  
  6806                                  ;-1078         if (R1Type != WORD) reg16error();//only r16
  6807                                  
  6808 00002454 A0[3600]                 mov al, [R1Type]
  6809 00002457 3C02                     cmp al, 2
  6810 00002459 0F840300                 je  .process267
  6811 0000245D E8AEF7                   call reg16error
  6812                                  
  6813                                  ;-1079         if (Op2 != MEM) addrerror();//only m16
  6814                                  
  6815                                  .process267:
  6816 00002460 A0[2E00]                 mov al, [Op2]
  6817 00002463 3C04                     cmp al, 4
  6818 00002465 0F840300                 je  .process268
  6819 00002469 E8C3F6                   call addrerror
  6820                                  
  6821                                  ;-1080 
  6822                                  
  6823                                  
  6824                                  ;-1081         genCode8(Code1);//les,lds,lea
  6825                                  
  6826                                  .process268:
  6827 0000246C A0[3000]                 mov al, byte [Code1]
  6828 0000246F B400                     mov ah, 0
  6829 00002471 50                       push ax
  6830 00002472 E82DFD                   call genCode8
  6831 00002475 83C402                   add  sp, 2
  6832                                  
  6833                                  ;-1082         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6834                                  
  6835 00002478 A0[3000]                 mov al, [Code1]
  6836 0000247B 3C0F                     cmp al, 15
  6837 0000247D 0F850C00                 jne .process269
  6838 00002481 A0[3100]                 mov al, byte [Code2]
  6839 00002484 B400                     mov ah, 0
  6840 00002486 50                       push ax
  6841 00002487 E818FD                   call genCode8
  6842 0000248A 83C402                   add  sp, 2
  6843                                  
  6844                                  ;-1083         Op=Op2;//set MEM for writeEA
  6845                                  
  6846                                  .process269:
  6847 0000248D A0[2E00]                 mov al, [Op2]
  6848 00002490 A2[2D00]                 mov byte [Op], al
  6849                                  
  6850                                  ;-1084         writeEA(R1No);
  6851                                  
  6852 00002493 A0[3400]                 mov al, byte [R1No]
  6853 00002496 B400                     mov ah, 0
  6854 00002498 50                       push ax
  6855 00002499 E8A8FD                   call writeEA
  6856 0000249C 83C402                   add  sp, 2
  6857                                  
  6858                                  ;-1085         return;
  6859                                  
  6860 0000249F E97C07                   jmp .retnprocess
  6861                                  
  6862                                  ;-1086     }
  6863                                  
  6864                                  
  6865                                  ;-1087 
  6866                                  
  6867                                  
  6868                                  ;-1088     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6869                                  
  6870                                  .process266:
  6871 000024A2 A0[2F00]                 mov al, [CodeType]
  6872 000024A5 3C04                     cmp al, 4
  6873 000024A7 0F85EF00                 jne .process270
  6874                                  
  6875                                  ;-1089         check2Ops();
  6876                                  
  6877 000024AB E882E0                   call check2Ops
  6878                                  
  6879                                  ;-1090         if (Op2 == IMM) {//second operand is imm
  6880                                  
  6881 000024AE A0[2E00]                 mov al, [Op2]
  6882 000024B1 3C01                     cmp al, 1
  6883 000024B3 0F857900                 jne .process271
  6884                                  
  6885                                  ;-1091             setsflag();
  6886                                  
  6887 000024B7 E80BE4                   call setsflag
  6888                                  
  6889                                  ;-1092             if (Op == REG) {
  6890                                  
  6891 000024BA A0[2D00]                 mov al, [Op]
  6892 000024BD 3C02                     cmp al, 2
  6893 000024BF 0F853100                 jne .process272
  6894                                  
  6895                                  ;-1093                 if (R1No == 0) {// acc,imm
  6896                                  
  6897 000024C3 A0[3400]                 mov al, [R1No]
  6898 000024C6 3C00                     cmp al, 0
  6899 000024C8 0F852800                 jne .process273
  6900                                  
  6901                                  ;-1094                     if (sflag == 0) {
  6902                                  
  6903 000024CC A0[3A00]                 mov al, [sflag]
  6904 000024CF 3C00                     cmp al, 0
  6905 000024D1 0F851F00                 jne .process274
  6906                                  
  6907                                  ;-1095                         c = Code1 << 3;
  6908                                  
  6909 000024D5 A0[3000]                 mov al, [Code1]
  6910 000024D8 C0E003                   shl al, 3
  6911 000024DB 8846FE                   mov [bp-2], al
  6912                                  
  6913                                  ;-1096                         c += 4;
  6914                                  
  6915 000024DE 8046FE04                 add  byte[bp-2], 4
  6916                                  
  6917                                  ;-1097                         genCodeW(c);
  6918                                  
  6919 000024E2 8A46FE                   mov al, byte [bp-2]
  6920 000024E5 B400                     mov ah, 0
  6921 000024E7 50                       push ax
  6922 000024E8 E89BFC                   call genCodeW
  6923 000024EB 83C402                   add  sp, 2
  6924                                  
  6925                                  ;-1098                         genImmediate();
  6926                                  
  6927 000024EE E859FE                   call genImmediate
  6928                                  
  6929                                  ;-1099                         return;
  6930                                  
  6931 000024F1 E92A07                   jmp .retnprocess
  6932                                  
  6933                                  ;-1100                     }
  6934                                  
  6935                                  
  6936                                  ;-1101                 }
  6937                                  
  6938                                  .process274:
  6939                                  
  6940                                  ;-1102             }
  6941                                  
  6942                                  .process273:
  6943                                  
  6944                                  ;-1103             //r/m, imm: 80 sign-extended,TTT,imm
  6945                                  
  6946                                  
  6947                                  ;-1104             c = sflag + 0x80;
  6948                                  
  6949                                  .process272:
  6950 000024F4 A0[3A00]                 mov al, [sflag]
  6951 000024F7 0480                     add al, 128
  6952 000024F9 8846FE                   mov [bp-2], al
  6953                                  
  6954                                  ;-1105             genCodeW(c);
  6955                                  
  6956 000024FC 8A46FE                   mov al, byte [bp-2]
  6957 000024FF B400                     mov ah, 0
  6958 00002501 50                       push ax
  6959 00002502 E881FC                   call genCodeW
  6960 00002505 83C402                   add  sp, 2
  6961                                  
  6962                                  ;-1106             writeEA(Code1);
  6963                                  
  6964 00002508 A0[3000]                 mov al, byte [Code1]
  6965 0000250B B400                     mov ah, 0
  6966 0000250D 50                       push ax
  6967 0000250E E833FD                   call writeEA
  6968 00002511 83C402                   add  sp, 2
  6969                                  
  6970                                  ;-1107             if (sflag) genCode8(imme);
  6971                                  
  6972 00002514 A0[3A00]                 mov al, [sflag]
  6973 00002517 08C0                     or  al, al
  6974 00002519 0F840D00                 je .process275
  6975 0000251D FF36[3F00]               push word [imme]
  6976 00002521 E87EFC                   call genCode8
  6977 00002524 83C402                   add  sp, 2
  6978                                  
  6979                                  ;-1108             else genImmediate();
  6980                                  
  6981 00002527 E90300                   jmp .process276
  6982                                  .process275:
  6983 0000252A E81DFE                   call genImmediate
  6984                                  
  6985                                  ;-1109             return;
  6986                                  
  6987                                  .process276:
  6988 0000252D E9EE06                   jmp .retnprocess
  6989                                  
  6990                                  ;-1110         }
  6991                                  
  6992                                  
  6993                                  ;-1111         c = Code1 << 3;//r/m, r/r
  6994                                  
  6995                                  .process271:
  6996 00002530 A0[3000]                 mov al, [Code1]
  6997 00002533 C0E003                   shl al, 3
  6998 00002536 8846FE                   mov [bp-2], al
  6999                                  
  7000                                  ;-1112         if (Op == REG) {
  7001                                  
  7002 00002539 A0[2D00]                 mov al, [Op]
  7003 0000253C 3C02                     cmp al, 2
  7004 0000253E 0F852E00                 jne .process277
  7005                                  
  7006                                  ;-1113             if (Op2 == MEM) {//reg, mem
  7007                                  
  7008 00002542 A0[2E00]                 mov al, [Op2]
  7009 00002545 3C04                     cmp al, 4
  7010 00002547 0F852500                 jne .process278
  7011                                  
  7012                                  ;-1114                 c += 2;//add direction flag
  7013                                  
  7014 0000254B 8046FE02                 add  byte[bp-2], 2
  7015                                  
  7016                                  ;-1115                 genCodeW(c);
  7017                                  
  7018 0000254F 8A46FE                   mov al, byte [bp-2]
  7019 00002552 B400                     mov ah, 0
  7020 00002554 50                       push ax
  7021 00002555 E82EFC                   call genCodeW
  7022 00002558 83C402                   add  sp, 2
  7023                                  
  7024                                  ;-1116                 Op=Op2;//set MEM for writeEA
  7025                                  
  7026 0000255B A0[2E00]                 mov al, [Op2]
  7027 0000255E A2[2D00]                 mov byte [Op], al
  7028                                  
  7029                                  ;-1117                 writeEA(R1No);
  7030                                  
  7031 00002561 A0[3400]                 mov al, byte [R1No]
  7032 00002564 B400                     mov ah, 0
  7033 00002566 50                       push ax
  7034 00002567 E8DAFC                   call writeEA
  7035 0000256A 83C402                   add  sp, 2
  7036                                  
  7037                                  ;-1118                 return;
  7038                                  
  7039 0000256D E9AE06                   jmp .retnprocess
  7040                                  
  7041                                  ;-1119             }
  7042                                  
  7043                                  
  7044                                  ;-1120         }
  7045                                  
  7046                                  .process278:
  7047                                  
  7048                                  ;-1121         if (Op2 == REG) {//mem,reg    reg,reg
  7049                                  
  7050                                  .process277:
  7051 00002570 A0[2E00]                 mov al, [Op2]
  7052 00002573 3C02                     cmp al, 2
  7053 00002575 0F851B00                 jne .process279
  7054                                  
  7055                                  ;-1122             genCodeW(c);
  7056                                  
  7057 00002579 8A46FE                   mov al, byte [bp-2]
  7058 0000257C B400                     mov ah, 0
  7059 0000257E 50                       push ax
  7060 0000257F E804FC                   call genCodeW
  7061 00002582 83C402                   add  sp, 2
  7062                                  
  7063                                  ;-1123             writeEA(R2No);//2. Op in reg-field
  7064                                  
  7065 00002585 A0[3300]                 mov al, byte [R2No]
  7066 00002588 B400                     mov ah, 0
  7067 0000258A 50                       push ax
  7068 0000258B E8B6FC                   call writeEA
  7069 0000258E 83C402                   add  sp, 2
  7070                                  
  7071                                  ;-1124             return;
  7072                                  
  7073 00002591 E98A06                   jmp .retnprocess
  7074                                  
  7075                                  ;-1125         }
  7076                                  
  7077                                  
  7078                                  ;-1126         syntaxerror();
  7079                                  
  7080                                  .process279:
  7081 00002594 E8C6F6                   call syntaxerror
  7082                                  
  7083                                  ;-1127         return;
  7084                                  
  7085 00002597 E98406                   jmp .retnprocess
  7086                                  
  7087                                  ;-1128     }
  7088                                  
  7089                                  
  7090                                  ;-1129 
  7091                                  
  7092                                  
  7093                                  ;-1130     if (CodeType == 5) {//mov (movsx, movzx=51)
  7094                                  
  7095                                  .process270:
  7096 0000259A A0[2F00]                 mov al, [CodeType]
  7097 0000259D 3C05                     cmp al, 5
  7098 0000259F 0F857C01                 jne .process280
  7099                                  
  7100                                  ;-1131         check2Ops();
  7101                                  
  7102 000025A3 E88ADF                   call check2Ops
  7103                                  
  7104                                  ;-1132 /*    prs("\n Op:"); printhex8a(Op);
  7105                                  
  7106                                  
  7107                                  ;-1133     prs(", Op2:"); printhex8a(Op2);
  7108                                  
  7109                                  
  7110                                  ;-1134     prs(", R1No:"); printhex8a(R1No);
  7111                                  
  7112                                  
  7113                                  ;-1135     prs(", R2No:"); printhex8a(R2No);   */
  7114                                  
  7115                                  
  7116                                  ;-1136         if (Op2 == ADR) {
  7117                                  
  7118 000025A6 A0[2E00]                 mov al, [Op2]
  7119 000025A9 3C03                     cmp al, 3
  7120 000025AB 0F850C00                 jne .process281
  7121                                  
  7122                                  ;-1137             imme=disp;
  7123                                  
  7124 000025AF A1[3D00]                 mov ax, [disp]
  7125 000025B2 A3[3F00]                 mov word [imme], ax
  7126                                  
  7127                                  ;-1138             Op2=IMM;//continue with IMM
  7128                                  
  7129 000025B5 B80100                   mov ax, 1
  7130 000025B8 A2[2E00]                 mov byte [Op2], al
  7131                                  
  7132                                  ;-1139         }
  7133                                  
  7134                                  
  7135                                  ;-1140         if (Op2 == IMM) {// r,i
  7136                                  
  7137                                  .process281:
  7138 000025BB A0[2E00]                 mov al, [Op2]
  7139 000025BE 3C01                     cmp al, 1
  7140 000025C0 0F855400                 jne .process282
  7141                                  
  7142                                  ;-1141             if (Op == REG) {
  7143                                  
  7144 000025C4 A0[2D00]                 mov al, [Op]
  7145 000025C7 3C02                     cmp al, 2
  7146 000025C9 0F852500                 jne .process283
  7147                                  
  7148                                  ;-1142                 c = wflag << 3;
  7149                                  
  7150 000025CD A0[3800]                 mov al, [wflag]
  7151 000025D0 C0E003                   shl al, 3
  7152 000025D3 8846FE                   mov [bp-2], al
  7153                                  
  7154                                  ;-1143                 c += 0xB0;
  7155                                  
  7156 000025D6 8046FEB0                 add  byte[bp-2], 176
  7157                                  
  7158                                  ;-1144                 genCode2(c, R1No);
  7159                                  
  7160 000025DA A0[3400]                 mov al, byte [R1No]
  7161 000025DD B400                     mov ah, 0
  7162 000025DF 50                       push ax
  7163 000025E0 8A46FE                   mov al, byte [bp-2]
  7164 000025E3 B400                     mov ah, 0
  7165 000025E5 50                       push ax
  7166 000025E6 E882FB                   call genCode2
  7167 000025E9 83C404                   add  sp, 4
  7168                                  
  7169                                  ;-1145                 genImmediate();
  7170                                  
  7171 000025EC E85BFD                   call genImmediate
  7172                                  
  7173                                  ;-1146                 return;
  7174                                  
  7175 000025EF E92C06                   jmp .retnprocess
  7176                                  
  7177                                  ;-1147             }
  7178                                  
  7179                                  
  7180                                  ;-1148             if (Op == MEM) {// m,i
  7181                                  
  7182                                  .process283:
  7183 000025F2 A0[2D00]                 mov al, [Op]
  7184 000025F5 3C04                     cmp al, 4
  7185 000025F7 0F851700                 jne .process284
  7186                                  
  7187                                  ;-1149                 genCodeW(0xC6);
  7188                                  
  7189 000025FB 68C600                   push 198
  7190 000025FE E885FB                   call genCodeW
  7191 00002601 83C402                   add  sp, 2
  7192                                  
  7193                                  ;-1150                 writeEA( 0 );
  7194                                  
  7195 00002604 6A00                     push 0
  7196 00002606 E83BFC                   call writeEA
  7197 00002609 83C402                   add  sp, 2
  7198                                  
  7199                                  ;-1151                 genImmediate();
  7200                                  
  7201 0000260C E83BFD                   call genImmediate
  7202                                  
  7203                                  ;-1152                 return;
  7204                                  
  7205 0000260F E90C06                   jmp .retnprocess
  7206                                  
  7207                                  ;-1153             }
  7208                                  
  7209                                  
  7210                                  ;-1154             regmemerror();
  7211                                  
  7212                                  .process284:
  7213 00002612 E8CFF5                   call regmemerror
  7214                                  
  7215                                  ;-1155             return;
  7216                                  
  7217 00002615 E90606                   jmp .retnprocess
  7218                                  
  7219                                  ;-1156         }
  7220                                  
  7221                                  
  7222                                  ;-1157         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7223                                  
  7224                                  .process282:
  7225 00002618 A0[3600]                 mov al, [R1Type]
  7226 0000261B 3C04                     cmp al, 4
  7227 0000261D 0F850300                 jne .process285
  7228 00002621 E848DE                   call ChangeDirection
  7229                                  
  7230                                  ;-1158         if (R2Type == SEGREG) {//rm,sreg
  7231                                  
  7232                                  .process285:
  7233 00002624 A0[3500]                 mov al, [R2Type]
  7234 00002627 3C04                     cmp al, 4
  7235 00002629 0F852A00                 jne .process286
  7236                                  
  7237                                  ;-1159             if (OpSize != WORD) reg16error();
  7238                                  
  7239 0000262D A0[3700]                 mov al, [OpSize]
  7240 00002630 3C02                     cmp al, 2
  7241 00002632 0F840300                 je  .process287
  7242 00002636 E8D5F5                   call reg16error
  7243                                  
  7244                                  ;-1160                 genCode2(0x8C, dflag);
  7245                                  
  7246                                  .process287:
  7247 00002639 A0[3900]                 mov al, byte [dflag]
  7248 0000263C B400                     mov ah, 0
  7249 0000263E 50                       push ax
  7250 0000263F 688C00                   push 140
  7251 00002642 E826FB                   call genCode2
  7252 00002645 83C404                   add  sp, 4
  7253                                  
  7254                                  ;-1161                 writeEA(R2No);
  7255                                  
  7256 00002648 A0[3300]                 mov al, byte [R2No]
  7257 0000264B B400                     mov ah, 0
  7258 0000264D 50                       push ax
  7259 0000264E E8F3FB                   call writeEA
  7260 00002651 83C402                   add  sp, 2
  7261                                  
  7262                                  ;-1162                 return;
  7263                                  
  7264 00002654 E9C705                   jmp .retnprocess
  7265                                  
  7266                                  ;-1163         }
  7267                                  
  7268                                  
  7269                                  ;-1164         if (Op2 == MEM) {//acc, moffs16
  7270                                  
  7271                                  .process286:
  7272 00002657 A0[2E00]                 mov al, [Op2]
  7273 0000265A 3C04                     cmp al, 4
  7274 0000265C 0F853100                 jne .process288
  7275                                  
  7276                                  ;-1165             if (Op == REG) {
  7277                                  
  7278 00002660 A0[2D00]                 mov al, [Op]
  7279 00002663 3C02                     cmp al, 2
  7280 00002665 0F852800                 jne .process289
  7281                                  
  7282                                  ;-1166                 if (R1No == 0) {
  7283                                  
  7284 00002669 A0[3400]                 mov al, [R1No]
  7285 0000266C 3C00                     cmp al, 0
  7286 0000266E 0F851F00                 jne .process290
  7287                                  
  7288                                  ;-1167                     if (isDirect) {
  7289                                  
  7290 00002672 A0[3C00]                 mov al, [isDirect]
  7291 00002675 08C0                     or  al, al
  7292 00002677 0F841600                 je .process291
  7293                                  
  7294                                  ;-1168                         genCodeW(0xA0);
  7295                                  
  7296 0000267B 68A000                   push 160
  7297 0000267E E805FB                   call genCodeW
  7298 00002681 83C402                   add  sp, 2
  7299                                  
  7300                                  ;-1169                         genCode16(disp);
  7301                                  
  7302 00002684 FF36[3D00]               push word [disp]
  7303 00002688 E86EFB                   call genCode16
  7304 0000268B 83C402                   add  sp, 2
  7305                                  
  7306                                  ;-1170                         return;
  7307                                  
  7308 0000268E E98D05                   jmp .retnprocess
  7309                                  
  7310                                  ;-1171                     }
  7311                                  
  7312                                  
  7313                                  ;-1172                 }
  7314                                  
  7315                                  .process291:
  7316                                  
  7317                                  ;-1173             }
  7318                                  
  7319                                  .process290:
  7320                                  
  7321                                  ;-1174         }
  7322                                  
  7323                                  .process289:
  7324                                  
  7325                                  ;-1175         if (Op == MEM) {//moffs16, acc
  7326                                  
  7327                                  .process288:
  7328 00002691 A0[2D00]                 mov al, [Op]
  7329 00002694 3C04                     cmp al, 4
  7330 00002696 0F853100                 jne .process292
  7331                                  
  7332                                  ;-1176             if (Op2 == REG) {
  7333                                  
  7334 0000269A A0[2E00]                 mov al, [Op2]
  7335 0000269D 3C02                     cmp al, 2
  7336 0000269F 0F852800                 jne .process293
  7337                                  
  7338                                  ;-1177                 if (R2No == 0) {
  7339                                  
  7340 000026A3 A0[3300]                 mov al, [R2No]
  7341 000026A6 3C00                     cmp al, 0
  7342 000026A8 0F851F00                 jne .process294
  7343                                  
  7344                                  ;-1178                     if (isDirect) {
  7345                                  
  7346 000026AC A0[3C00]                 mov al, [isDirect]
  7347 000026AF 08C0                     or  al, al
  7348 000026B1 0F841600                 je .process295
  7349                                  
  7350                                  ;-1179                         genCodeW(0xA2);
  7351                                  
  7352 000026B5 68A200                   push 162
  7353 000026B8 E8CBFA                   call genCodeW
  7354 000026BB 83C402                   add  sp, 2
  7355                                  
  7356                                  ;-1180                         genCode16(disp);
  7357                                  
  7358 000026BE FF36[3D00]               push word [disp]
  7359 000026C2 E834FB                   call genCode16
  7360 000026C5 83C402                   add  sp, 2
  7361                                  
  7362                                  ;-1181                         return;
  7363                                  
  7364 000026C8 E95305                   jmp .retnprocess
  7365                                  
  7366                                  ;-1182                     }
  7367                                  
  7368                                  
  7369                                  ;-1183                 }
  7370                                  
  7371                                  .process295:
  7372                                  
  7373                                  ;-1184             }
  7374                                  
  7375                                  .process294:
  7376                                  
  7377                                  ;-1185 
  7378                                  
  7379                                  
  7380                                  ;-1186         }
  7381                                  
  7382                                  .process293:
  7383                                  
  7384                                  ;-1187         if (Op2 == REG) {//rm, r
  7385                                  
  7386                                  .process292:
  7387 000026CB A0[2E00]                 mov al, [Op2]
  7388 000026CE 3C02                     cmp al, 2
  7389 000026D0 0F851800                 jne .process296
  7390                                  
  7391                                  ;-1188             genCodeW(0x88);
  7392                                  
  7393 000026D4 688800                   push 136
  7394 000026D7 E8ACFA                   call genCodeW
  7395 000026DA 83C402                   add  sp, 2
  7396                                  
  7397                                  ;-1189             writeEA(R2No);
  7398                                  
  7399 000026DD A0[3300]                 mov al, byte [R2No]
  7400 000026E0 B400                     mov ah, 0
  7401 000026E2 50                       push ax
  7402 000026E3 E85EFB                   call writeEA
  7403 000026E6 83C402                   add  sp, 2
  7404                                  
  7405                                  ;-1190             return;
  7406                                  
  7407 000026E9 E93205                   jmp .retnprocess
  7408                                  
  7409                                  ;-1191         }
  7410                                  
  7411                                  
  7412                                  ;-1192         if (Op2 == MEM) {//r, m
  7413                                  
  7414                                  .process296:
  7415 000026EC A0[2E00]                 mov al, [Op2]
  7416 000026EF 3C04                     cmp al, 4
  7417 000026F1 0F852400                 jne .process297
  7418                                  
  7419                                  ;-1193             if (Op == REG) {
  7420                                  
  7421 000026F5 A0[2D00]                 mov al, [Op]
  7422 000026F8 3C02                     cmp al, 2
  7423 000026FA 0F851B00                 jne .process298
  7424                                  
  7425                                  ;-1194                 ChangeDirection();
  7426                                  
  7427 000026FE E86BDD                   call ChangeDirection
  7428                                  
  7429                                  ;-1195                 genCodeW(0x8A);
  7430                                  
  7431 00002701 688A00                   push 138
  7432 00002704 E87FFA                   call genCodeW
  7433 00002707 83C402                   add  sp, 2
  7434                                  
  7435                                  ;-1196                 writeEA(R2No);
  7436                                  
  7437 0000270A A0[3300]                 mov al, byte [R2No]
  7438 0000270D B400                     mov ah, 0
  7439 0000270F 50                       push ax
  7440 00002710 E831FB                   call writeEA
  7441 00002713 83C402                   add  sp, 2
  7442                                  
  7443                                  ;-1197                 return;
  7444                                  
  7445 00002716 E90505                   jmp .retnprocess
  7446                                  
  7447                                  ;-1198             }
  7448                                  
  7449                                  
  7450                                  ;-1199         }
  7451                                  
  7452                                  .process298:
  7453                                  
  7454                                  ;-1200         syntaxerror();
  7455                                  
  7456                                  .process297:
  7457 00002719 E841F5                   call syntaxerror
  7458                                  
  7459                                  ;-1201         return;
  7460                                  
  7461 0000271C E9FF04                   jmp .retnprocess
  7462                                  
  7463                                  ;-1202     }
  7464                                  
  7465                                  
  7466                                  ;-1203 
  7467                                  
  7468                                  
  7469                                  ;-1204     if (CodeType == 6) {//Jcc
  7470                                  
  7471                                  .process280:
  7472 0000271F A0[2F00]                 mov al, [CodeType]
  7473 00002722 3C06                     cmp al, 6
  7474 00002724 0F85BE00                 jne .process299
  7475                                  
  7476                                  ;-1205         if (TokeType == ALNUME) {
  7477                                  
  7478 00002728 A0[2C00]                 mov al, [TokeType]
  7479 0000272B 3C03                     cmp al, 3
  7480 0000272D 0F85B500                 jne .process300
  7481                                  
  7482                                  ;-1206             LabelIx=searchLabel();
  7483                                  
  7484 00002731 E8EAE4                   call searchLabel
  7485 00002734 A3[4E00]                 mov word [LabelIx], ax
  7486                                  
  7487                                  ;-1207             if (LabelIx > 0) {
  7488                                  
  7489 00002737 A1[4E00]                 mov ax, [LabelIx]
  7490 0000273A 83F800                   cmp ax, 0
  7491 0000273D 0F8E7A00                 jle .process301
  7492                                  
  7493                                  ;-1208                 disp=LabelAddr[LabelIx];
  7494                                  
  7495 00002741 8B1E[4E00]               mov bx, [LabelIx]
  7496 00002745 D1E3                     shl bx, 1
  7497 00002747 8B87FA86                 mov ax, [LabelAddr + bx]
  7498 0000274B A3[3D00]                 mov word [disp], ax
  7499                                  
  7500                                  ;-1209                 disp = disp - PC;
  7501                                  
  7502 0000274E A1[3D00]                 mov ax, [disp]
  7503 00002751 2B06[2300]               sub ax, [PC]
  7504 00002755 A3[3D00]                 mov word [disp], ax
  7505                                  
  7506                                  ;-1210                 disp = disp - Origin;
  7507                                  
  7508 00002758 A1[3D00]                 mov ax, [disp]
  7509 0000275B 2B06[2500]               sub ax, [Origin]
  7510 0000275F A3[3D00]                 mov word [disp], ax
  7511                                  
  7512                                  ;-1211                 if (checkConstSize(disp) ) {
  7513                                  
  7514 00002762 FF36[3D00]               push word [disp]
  7515 00002766 E8B8E1                   call checkConstSize
  7516 00002769 83C402                   add  sp, 2
  7517 0000276C 08C0                     or  al, al
  7518 0000276E 0F842000                 je .process302
  7519                                  
  7520                                  ;-1212                     genCode2(Code1, 0x70);//short
  7521                                  
  7522 00002772 6A70                     push 112
  7523 00002774 A0[3000]                 mov al, byte [Code1]
  7524 00002777 B400                     mov ah, 0
  7525 00002779 50                       push ax
  7526 0000277A E8EEF9                   call genCode2
  7527 0000277D 83C404                   add  sp, 4
  7528                                  
  7529                                  ;-1213                     disp -= 2;
  7530                                  
  7531 00002780 832E[3D00]02             sub  word[disp], 2
  7532                                  
  7533                                  ;-1214                     genCode8(disp);
  7534                                  
  7535 00002785 FF36[3D00]               push word [disp]
  7536 00002789 E816FA                   call genCode8
  7537 0000278C 83C402                   add  sp, 2
  7538                                  
  7539                                  ;-1215                 } else {
  7540                                  
  7541 0000278F E92600                   jmp .process303
  7542                                  .process302:
  7543                                  
  7544                                  ;-1216                     genCode8(0x0F);
  7545                                  
  7546 00002792 6A0F                     push 15
  7547 00002794 E80BFA                   call genCode8
  7548 00002797 83C402                   add  sp, 2
  7549                                  
  7550                                  ;-1217                     genCode2(Code1, 0x80);//near
  7551                                  
  7552 0000279A 688000                   push 128
  7553 0000279D A0[3000]                 mov al, byte [Code1]
  7554 000027A0 B400                     mov ah, 0
  7555 000027A2 50                       push ax
  7556 000027A3 E8C5F9                   call genCode2
  7557 000027A6 83C404                   add  sp, 4
  7558                                  
  7559                                  ;-1218                     disp -= 4;
  7560                                  
  7561 000027A9 832E[3D00]04             sub  word[disp], 4
  7562                                  
  7563                                  ;-1219                     genCode16(disp);
  7564                                  
  7565 000027AE FF36[3D00]               push word [disp]
  7566 000027B2 E844FA                   call genCode16
  7567 000027B5 83C402                   add  sp, 2
  7568                                  
  7569                                  ;-1220                 }
  7570                                  
  7571                                  
  7572                                  ;-1221             }
  7573                                  
  7574                                  .process303:
  7575                                  
  7576                                  ;-1222             else {//jump forward, near only
  7577                                  
  7578 000027B8 E92800                   jmp .process304
  7579                                  .process301:
  7580                                  
  7581                                  ;-1223                 genCode8(0x0F);
  7582                                  
  7583 000027BB 6A0F                     push 15
  7584 000027BD E8E2F9                   call genCode8
  7585 000027C0 83C402                   add  sp, 2
  7586                                  
  7587                                  ;-1224                 genCode2(Code1, 0x80);
  7588                                  
  7589 000027C3 688000                   push 128
  7590 000027C6 A0[3000]                 mov al, byte [Code1]
  7591 000027C9 B400                     mov ah, 0
  7592 000027CB 50                       push ax
  7593 000027CC E89CF9                   call genCode2
  7594 000027CF 83C404                   add  sp, 4
  7595                                  
  7596                                  ;-1225                 genCode16(0);
  7597                                  
  7598 000027D2 6A00                     push 0
  7599 000027D4 E822FA                   call genCode16
  7600 000027D7 83C402                   add  sp, 2
  7601                                  
  7602                                  ;-1226                 PrintRA='r';
  7603                                  
  7604 000027DA B87200                   mov ax, 114
  7605 000027DD A2[4500]                 mov byte [PrintRA], al
  7606                                  
  7607                                  ;-1227                 storeJmpCall();
  7608                                  
  7609 000027E0 E80FE3                   call storeJmpCall
  7610                                  
  7611                                  ;-1228             }
  7612                                  
  7613                                  
  7614                                  ;-1229         return;
  7615                                  
  7616                                  .process304:
  7617 000027E3 E93804                   jmp .retnprocess
  7618                                  
  7619                                  ;-1230         }
  7620                                  
  7621                                  
  7622                                  ;-1231     }
  7623                                  
  7624                                  .process300:
  7625                                  
  7626                                  ;-1232 
  7627                                  
  7628                                  
  7629                                  ;-1233     if (CodeType == 7) {//jmp, call
  7630                                  
  7631                                  .process299:
  7632 000027E6 A0[2F00]                 mov al, [CodeType]
  7633 000027E9 3C07                     cmp al, 7
  7634 000027EB 0F85CA00                 jne .process305
  7635                                  
  7636                                  ;-1234         if (TokeType == ALNUME) {
  7637                                  
  7638 000027EF A0[2C00]                 mov al, [TokeType]
  7639 000027F2 3C03                     cmp al, 3
  7640 000027F4 0F85C100                 jne .process306
  7641                                  
  7642                                  ;-1235             LabelIx=searchLabel();
  7643                                  
  7644 000027F8 E823E4                   call searchLabel
  7645 000027FB A3[4E00]                 mov word [LabelIx], ax
  7646                                  
  7647                                  ;-1236             if (LabelIx > 0) {
  7648                                  
  7649 000027FE A1[4E00]                 mov ax, [LabelIx]
  7650 00002801 83F800                   cmp ax, 0
  7651 00002804 0F8E9100                 jle .process307
  7652                                  
  7653                                  ;-1237                 disp=LabelAddr[LabelIx];
  7654                                  
  7655 00002808 8B1E[4E00]               mov bx, [LabelIx]
  7656 0000280C D1E3                     shl bx, 1
  7657 0000280E 8B87FA86                 mov ax, [LabelAddr + bx]
  7658 00002812 A3[3D00]                 mov word [disp], ax
  7659                                  
  7660                                  ;-1238                 disp = disp - PC;
  7661                                  
  7662 00002815 A1[3D00]                 mov ax, [disp]
  7663 00002818 2B06[2300]               sub ax, [PC]
  7664 0000281C A3[3D00]                 mov word [disp], ax
  7665                                  
  7666                                  ;-1239                 disp = disp - Origin;
  7667                                  
  7668 0000281F A1[3D00]                 mov ax, [disp]
  7669 00002822 2B06[2500]               sub ax, [Origin]
  7670 00002826 A3[3D00]                 mov word [disp], ax
  7671                                  
  7672                                  ;-1240                 if (checkConstSize(disp) ) {
  7673                                  
  7674 00002829 FF36[3D00]               push word [disp]
  7675 0000282D E8F1E0                   call checkConstSize
  7676 00002830 83C402                   add  sp, 2
  7677 00002833 08C0                     or  al, al
  7678 00002835 0F844200                 je .process308
  7679                                  
  7680                                  ;-1241                     if (Code1 == 0xE9) {//jmp only
  7681                                  
  7682 00002839 A0[3000]                 mov al, [Code1]
  7683 0000283C 3CE9                     cmp al, 233
  7684 0000283E 0F851B00                 jne .process309
  7685                                  
  7686                                  ;-1242                         genCode8(0xEB);//short
  7687                                  
  7688 00002842 68EB00                   push 235
  7689 00002845 E85AF9                   call genCode8
  7690 00002848 83C402                   add  sp, 2
  7691                                  
  7692                                  ;-1243                         disp -= 2;
  7693                                  
  7694 0000284B 832E[3D00]02             sub  word[disp], 2
  7695                                  
  7696                                  ;-1244                         genCode8(disp);
  7697                                  
  7698 00002850 FF36[3D00]               push word [disp]
  7699 00002854 E84BF9                   call genCode8
  7700 00002857 83C402                   add  sp, 2
  7701                                  
  7702                                  ;-1245                     }
  7703                                  
  7704                                  
  7705                                  ;-1246                     else {
  7706                                  
  7707 0000285A E91B00                   jmp .process310
  7708                                  .process309:
  7709                                  
  7710                                  ;-1247                         genCode8(Code1);//near
  7711                                  
  7712 0000285D A0[3000]                 mov al, byte [Code1]
  7713 00002860 B400                     mov ah, 0
  7714 00002862 50                       push ax
  7715 00002863 E83CF9                   call genCode8
  7716 00002866 83C402                   add  sp, 2
  7717                                  
  7718                                  ;-1248                         disp -= 3;
  7719                                  
  7720 00002869 832E[3D00]03             sub  word[disp], 3
  7721                                  
  7722                                  ;-1249                         genCode16(disp);
  7723                                  
  7724 0000286E FF36[3D00]               push word [disp]
  7725 00002872 E884F9                   call genCode16
  7726 00002875 83C402                   add  sp, 2
  7727                                  
  7728                                  ;-1250                     }
  7729                                  
  7730                                  
  7731                                  ;-1251                 }
  7732                                  
  7733                                  .process310:
  7734                                  
  7735                                  ;-1252                 else {
  7736                                  
  7737 00002878 E91B00                   jmp .process311
  7738                                  .process308:
  7739                                  
  7740                                  ;-1253                     genCode8(Code1);//near
  7741                                  
  7742 0000287B A0[3000]                 mov al, byte [Code1]
  7743 0000287E B400                     mov ah, 0
  7744 00002880 50                       push ax
  7745 00002881 E81EF9                   call genCode8
  7746 00002884 83C402                   add  sp, 2
  7747                                  
  7748                                  ;-1254                     disp -= 3;
  7749                                  
  7750 00002887 832E[3D00]03             sub  word[disp], 3
  7751                                  
  7752                                  ;-1255                     genCode16(disp);
  7753                                  
  7754 0000288C FF36[3D00]               push word [disp]
  7755 00002890 E866F9                   call genCode16
  7756 00002893 83C402                   add  sp, 2
  7757                                  
  7758                                  ;-1256                 }
  7759                                  
  7760                                  
  7761                                  ;-1257             }
  7762                                  
  7763                                  .process311:
  7764                                  
  7765                                  ;-1258             else {//jump forward, near only
  7766                                  
  7767 00002896 E91D00                   jmp .process312
  7768                                  .process307:
  7769                                  
  7770                                  ;-1259                 genCode8(Code1);
  7771                                  
  7772 00002899 A0[3000]                 mov al, byte [Code1]
  7773 0000289C B400                     mov ah, 0
  7774 0000289E 50                       push ax
  7775 0000289F E800F9                   call genCode8
  7776 000028A2 83C402                   add  sp, 2
  7777                                  
  7778                                  ;-1260                 genCode16(0);
  7779                                  
  7780 000028A5 6A00                     push 0
  7781 000028A7 E84FF9                   call genCode16
  7782 000028AA 83C402                   add  sp, 2
  7783                                  
  7784                                  ;-1261                 PrintRA='R';
  7785                                  
  7786 000028AD B85200                   mov ax, 82
  7787 000028B0 A2[4500]                 mov byte [PrintRA], al
  7788                                  
  7789                                  ;-1262                 storeJmpCall();
  7790                                  
  7791 000028B3 E83CE2                   call storeJmpCall
  7792                                  
  7793                                  ;-1263             }
  7794                                  
  7795                                  
  7796                                  ;-1264         return;
  7797                                  
  7798                                  .process312:
  7799 000028B6 E96503                   jmp .retnprocess
  7800                                  
  7801                                  ;-1265         }
  7802                                  
  7803                                  
  7804                                  ;-1266     }
  7805                                  
  7806                                  .process306:
  7807                                  
  7808                                  ;-1267 
  7809                                  
  7810                                  
  7811                                  ;-1268     if (CodeType ==  8) {//ret,retf
  7812                                  
  7813                                  .process305:
  7814 000028B9 A0[2F00]                 mov al, [CodeType]
  7815 000028BC 3C08                     cmp al, 8
  7816 000028BE 0F853100                 jne .process313
  7817                                  
  7818                                  ;-1269         if (TokeType == DIGIT) {
  7819                                  
  7820 000028C2 A0[2C00]                 mov al, [TokeType]
  7821 000028C5 3C01                     cmp al, 1
  7822 000028C7 0F851900                 jne .process314
  7823                                  
  7824                                  ;-1270             genCode8(Code2);
  7825                                  
  7826 000028CB A0[3100]                 mov al, byte [Code2]
  7827 000028CE B400                     mov ah, 0
  7828 000028D0 50                       push ax
  7829 000028D1 E8CEF8                   call genCode8
  7830 000028D4 83C402                   add  sp, 2
  7831                                  
  7832                                  ;-1271             genCode16(SymbolInt);
  7833                                  
  7834 000028D7 FF36[0E00]               push word [SymbolInt]
  7835 000028DB E81BF9                   call genCode16
  7836 000028DE 83C402                   add  sp, 2
  7837                                  
  7838                                  ;-1272             return;
  7839                                  
  7840 000028E1 E93A03                   jmp .retnprocess
  7841                                  
  7842                                  ;-1273         }
  7843                                  
  7844                                  
  7845                                  ;-1274         genCode8(Code1);
  7846                                  
  7847                                  .process314:
  7848 000028E4 A0[3000]                 mov al, byte [Code1]
  7849 000028E7 B400                     mov ah, 0
  7850 000028E9 50                       push ax
  7851 000028EA E8B5F8                   call genCode8
  7852 000028ED 83C402                   add  sp, 2
  7853                                  
  7854                                  ;-1275         return;
  7855                                  
  7856 000028F0 E92B03                   jmp .retnprocess
  7857                                  
  7858                                  ;-1276     }
  7859                                  
  7860                                  
  7861                                  ;-1277 
  7862                                  
  7863                                  
  7864                                  ;-1278     if (CodeType == 9) {//push, pop
  7865                                  
  7866                                  .process313:
  7867 000028F3 A0[2F00]                 mov al, [CodeType]
  7868 000028F6 3C09                     cmp al, 9
  7869 000028F8 0F852101                 jne .process315
  7870                                  
  7871                                  ;-1279         getOpL();
  7872                                  
  7873 000028FC E88CDC                   call getOpL
  7874                                  
  7875                                  ;-1280         if (Code1 == 0x50) {//push only
  7876                                  
  7877 000028FF A0[3000]                 mov al, [Code1]
  7878 00002902 3C50                     cmp al, 80
  7879 00002904 0F855B00                 jne .process316
  7880                                  
  7881                                  ;-1281             if (Op == IMM) {//push imm8,16
  7882                                  
  7883 00002908 A0[2D00]                 mov al, [Op]
  7884 0000290B 3C01                     cmp al, 1
  7885 0000290D 0F853400                 jne .process317
  7886                                  
  7887                                  ;-1282                 setsflag();
  7888                                  
  7889 00002911 E8B1DF                   call setsflag
  7890                                  
  7891                                  ;-1283                 genCode2(0x68, sflag);
  7892                                  
  7893 00002914 A0[3A00]                 mov al, byte [sflag]
  7894 00002917 B400                     mov ah, 0
  7895 00002919 50                       push ax
  7896 0000291A 6A68                     push 104
  7897 0000291C E84CF8                   call genCode2
  7898 0000291F 83C404                   add  sp, 4
  7899                                  
  7900                                  ;-1284                 if (sflag) genCode8 (imme);
  7901                                  
  7902 00002922 A0[3A00]                 mov al, [sflag]
  7903 00002925 08C0                     or  al, al
  7904 00002927 0F840D00                 je .process318
  7905 0000292B FF36[3F00]               push word [imme]
  7906 0000292F E870F8                   call genCode8
  7907 00002932 83C402                   add  sp, 2
  7908                                  
  7909                                  ;-1285                 else       genCode16(imme);
  7910                                  
  7911 00002935 E90A00                   jmp .process319
  7912                                  .process318:
  7913 00002938 FF36[3F00]               push word [imme]
  7914 0000293C E8BAF8                   call genCode16
  7915 0000293F 83C402                   add  sp, 2
  7916                                  
  7917                                  ;-1286                 return;
  7918                                  
  7919                                  .process319:
  7920 00002942 E9D902                   jmp .retnprocess
  7921                                  
  7922                                  ;-1287             }
  7923                                  
  7924                                  
  7925                                  ;-1288             if (Op == ADR) {//push string ABSOLUTE i16
  7926                                  
  7927                                  .process317:
  7928 00002945 A0[2D00]                 mov al, [Op]
  7929 00002948 3C03                     cmp al, 3
  7930 0000294A 0F851500                 jne .process320
  7931                                  
  7932                                  ;-1289                 genCode8(0x68);
  7933                                  
  7934 0000294E 6A68                     push 104
  7935 00002950 E84FF8                   call genCode8
  7936 00002953 83C402                   add  sp, 2
  7937                                  
  7938                                  ;-1290                 genCode16(disp);
  7939                                  
  7940 00002956 FF36[3D00]               push word [disp]
  7941 0000295A E89CF8                   call genCode16
  7942 0000295D 83C402                   add  sp, 2
  7943                                  
  7944                                  ;-1291                 return;
  7945                                  
  7946 00002960 E9BB02                   jmp .retnprocess
  7947                                  
  7948                                  ;-1292             }
  7949                                  
  7950                                  
  7951                                  ;-1293         }
  7952                                  
  7953                                  .process320:
  7954                                  
  7955                                  ;-1294         if (R1Type == SEGREG) {
  7956                                  
  7957                                  .process316:
  7958 00002963 A0[3600]                 mov al, [R1Type]
  7959 00002966 3C04                     cmp al, 4
  7960 00002968 0F855A00                 jne .process321
  7961                                  
  7962                                  ;-1295             if (Code1 == 0x58) {//pop only
  7963                                  
  7964 0000296C A0[3000]                 mov al, [Code1]
  7965 0000296F 3C58                     cmp al, 88
  7966 00002971 0F851200                 jne .process322
  7967                                  
  7968                                  ;-1296                 if (R1No == 1) error1("pop cs not allowed");
  7969                                  
  7970 00002975 A0[3400]                 mov al, [R1No]
  7971 00002978 3C01                     cmp al, 1
  7972 0000297A 0F850900                 jne .process323
  7973 0000297E 68[202C]                 push process_0
  7974 00002981 E820F1                   call error1
  7975 00002984 83C402                   add  sp, 2
  7976                                  
  7977                                  ;-1297             }
  7978                                  
  7979                                  .process323:
  7980                                  
  7981                                  ;-1298             c = R1No <<3;
  7982                                  
  7983                                  .process322:
  7984 00002987 A0[3400]                 mov al, [R1No]
  7985 0000298A C0E003                   shl al, 3
  7986 0000298D 8846FE                   mov [bp-2], al
  7987                                  
  7988                                  ;-1299             if (R1No > 3) {//FS, GS
  7989                                  
  7990 00002990 A0[3400]                 mov al, [R1No]
  7991 00002993 3C03                     cmp al, 3
  7992 00002995 0F8E0C00                 jle .process324
  7993                                  
  7994                                  ;-1300                 c += 122;
  7995                                  
  7996 00002999 8046FE7A                 add  byte[bp-2], 122
  7997                                  
  7998                                  ;-1301                 genCode8(0x0F);
  7999                                  
  8000 0000299D 6A0F                     push 15
  8001 0000299F E800F8                   call genCode8
  8002 000029A2 83C402                   add  sp, 2
  8003                                  
  8004                                  ;-1302             }
  8005                                  
  8006                                  
  8007                                  ;-1303             OpCodePtr++;
  8008                                  
  8009                                  .process324:
  8010 000029A5 FF06[4300]               inc  word[OpCodePtr]
  8011                                  
  8012                                  ;-1304             c = c + *OpCodePtr;//is Code4
  8013                                  
  8014 000029A9 8A46FE                   mov al, [bp-2]
  8015 000029AC 8B1E[4300]               mov bx, [OpCodePtr]
  8016 000029B0 0207                     add al, [bx]
  8017 000029B2 B400                     mov ah, 0
  8018 000029B4 8846FE                   mov [bp-2], al
  8019                                  
  8020                                  ;-1305             genCode8(c);
  8021                                  
  8022 000029B7 8A46FE                   mov al, byte [bp-2]
  8023 000029BA B400                     mov ah, 0
  8024 000029BC 50                       push ax
  8025 000029BD E8E2F7                   call genCode8
  8026 000029C0 83C402                   add  sp, 2
  8027                                  
  8028                                  ;-1306             return;
  8029                                  
  8030 000029C3 E95802                   jmp .retnprocess
  8031                                  
  8032                                  ;-1307         }
  8033                                  
  8034                                  
  8035                                  ;-1308         checkOpL();
  8036                                  
  8037                                  .process321:
  8038 000029C6 E8E5DA                   call checkOpL
  8039                                  
  8040                                  ;-1309         if (R1Type == BYTE) reg16error();
  8041                                  
  8042 000029C9 A0[3600]                 mov al, [R1Type]
  8043 000029CC 3C01                     cmp al, 1
  8044 000029CE 0F850300                 jne .process325
  8045 000029D2 E839F2                   call reg16error
  8046                                  
  8047                                  ;-1310         if (R1Type == WORD) {
  8048                                  
  8049                                  .process325:
  8050 000029D5 A0[3600]                 mov al, [R1Type]
  8051 000029D8 3C02                     cmp al, 2
  8052 000029DA 0F851500                 jne .process326
  8053                                  
  8054                                  ;-1311             genCode2(Code1, R1No);
  8055                                  
  8056 000029DE A0[3400]                 mov al, byte [R1No]
  8057 000029E1 B400                     mov ah, 0
  8058 000029E3 50                       push ax
  8059 000029E4 A0[3000]                 mov al, byte [Code1]
  8060 000029E7 B400                     mov ah, 0
  8061 000029E9 50                       push ax
  8062 000029EA E87EF7                   call genCode2
  8063 000029ED 83C404                   add  sp, 4
  8064                                  
  8065                                  ;-1312             return;
  8066                                  
  8067 000029F0 E92B02                   jmp .retnprocess
  8068                                  
  8069                                  ;-1313         }
  8070                                  
  8071                                  
  8072                                  ;-1314         if (Op == MEM) {
  8073                                  
  8074                                  .process326:
  8075 000029F3 A0[2D00]                 mov al, [Op]
  8076 000029F6 3C04                     cmp al, 4
  8077 000029F8 0F851B00                 jne .process327
  8078                                  
  8079                                  ;-1315             genCode8(Code2);
  8080                                  
  8081 000029FC A0[3100]                 mov al, byte [Code2]
  8082 000029FF B400                     mov ah, 0
  8083 00002A01 50                       push ax
  8084 00002A02 E89DF7                   call genCode8
  8085 00002A05 83C402                   add  sp, 2
  8086                                  
  8087                                  ;-1316             writeEA(Code3);
  8088                                  
  8089 00002A08 A0[3200]                 mov al, byte [Code3]
  8090 00002A0B B400                     mov ah, 0
  8091 00002A0D 50                       push ax
  8092 00002A0E E833F8                   call writeEA
  8093 00002A11 83C402                   add  sp, 2
  8094                                  
  8095                                  ;-1317             return;
  8096                                  
  8097 00002A14 E90702                   jmp .retnprocess
  8098                                  
  8099                                  ;-1318         }
  8100                                  
  8101                                  
  8102                                  ;-1319         syntaxerror();
  8103                                  
  8104                                  .process327:
  8105 00002A17 E843F2                   call syntaxerror
  8106                                  
  8107                                  ;-1320         return;
  8108                                  
  8109 00002A1A E90102                   jmp .retnprocess
  8110                                  
  8111                                  ;-1321     }
  8112                                  
  8113                                  
  8114                                  ;-1322 
  8115                                  
  8116                                  
  8117                                  ;-1323     if (CodeType == 11) {//shift, rotate
  8118                                  
  8119                                  .process315:
  8120 00002A1D A0[2F00]                 mov al, [CodeType]
  8121 00002A20 3C0B                     cmp al, 11
  8122 00002A22 0F859200                 jne .process328
  8123                                  
  8124                                  ;-1324         check2Ops();
  8125                                  
  8126 00002A26 E807DB                   call check2Ops
  8127                                  
  8128                                  ;-1325         if (Op2 == IMM) {
  8129                                  
  8130 00002A29 A0[2E00]                 mov al, [Op2]
  8131 00002A2C 3C01                     cmp al, 1
  8132 00002A2E 0F854400                 jne .process329
  8133                                  
  8134                                  ;-1326             if (imme == 1) {
  8135                                  
  8136 00002A32 A1[3F00]                 mov ax, [imme]
  8137 00002A35 83F801                   cmp ax, 1
  8138 00002A38 0F851800                 jne .process330
  8139                                  
  8140                                  ;-1327                 genCodeW(0xD0);
  8141                                  
  8142 00002A3C 68D000                   push 208
  8143 00002A3F E844F7                   call genCodeW
  8144 00002A42 83C402                   add  sp, 2
  8145                                  
  8146                                  ;-1328                 writeEA(Code1);
  8147                                  
  8148 00002A45 A0[3000]                 mov al, byte [Code1]
  8149 00002A48 B400                     mov ah, 0
  8150 00002A4A 50                       push ax
  8151 00002A4B E8F6F7                   call writeEA
  8152 00002A4E 83C402                   add  sp, 2
  8153                                  
  8154                                  ;-1329                 return;
  8155                                  
  8156 00002A51 E9CA01                   jmp .retnprocess
  8157                                  
  8158                                  ;-1330             }
  8159                                  
  8160                                  
  8161                                  ;-1331             genCodeW(0xC0);//80186
  8162                                  
  8163                                  .process330:
  8164 00002A54 68C000                   push 192
  8165 00002A57 E82CF7                   call genCodeW
  8166 00002A5A 83C402                   add  sp, 2
  8167                                  
  8168                                  ;-1332             writeEA(Code1);
  8169                                  
  8170 00002A5D A0[3000]                 mov al, byte [Code1]
  8171 00002A60 B400                     mov ah, 0
  8172 00002A62 50                       push ax
  8173 00002A63 E8DEF7                   call writeEA
  8174 00002A66 83C402                   add  sp, 2
  8175                                  
  8176                                  ;-1333             genCode8(imme);
  8177                                  
  8178 00002A69 FF36[3F00]               push word [imme]
  8179 00002A6D E832F7                   call genCode8
  8180 00002A70 83C402                   add  sp, 2
  8181                                  
  8182                                  ;-1334             return;
  8183                                  
  8184 00002A73 E9A801                   jmp .retnprocess
  8185                                  
  8186                                  ;-1335         }
  8187                                  
  8188                                  
  8189                                  ;-1336         if (Op2 == REG) {
  8190                                  
  8191                                  .process329:
  8192 00002A76 A0[2E00]                 mov al, [Op2]
  8193 00002A79 3C02                     cmp al, 2
  8194 00002A7B 0F853900                 jne .process331
  8195                                  
  8196                                  ;-1337             if (R2Type == BYTE) {
  8197                                  
  8198 00002A7F A0[3500]                 mov al, [R2Type]
  8199 00002A82 3C01                     cmp al, 1
  8200 00002A84 0F853000                 jne .process332
  8201                                  
  8202                                  ;-1338                 if (R2No == 1) {//CL-REG
  8203                                  
  8204 00002A88 A0[3300]                 mov al, [R2No]
  8205 00002A8B 3C01                     cmp al, 1
  8206 00002A8D 0F852700                 jne .process333
  8207                                  
  8208                                  ;-1339                     if (R1Type == WORD) wflag=1;//hack
  8209                                  
  8210 00002A91 A0[3600]                 mov al, [R1Type]
  8211 00002A94 3C02                     cmp al, 2
  8212 00002A96 0F850600                 jne .process334
  8213 00002A9A B80100                   mov ax, 1
  8214 00002A9D A2[3800]                 mov byte [wflag], al
  8215                                  
  8216                                  ;-1340                     genCodeW(0xD2);
  8217                                  
  8218                                  .process334:
  8219 00002AA0 68D200                   push 210
  8220 00002AA3 E8E0F6                   call genCodeW
  8221 00002AA6 83C402                   add  sp, 2
  8222                                  
  8223                                  ;-1341                     writeEA(Code1);
  8224                                  
  8225 00002AA9 A0[3000]                 mov al, byte [Code1]
  8226 00002AAC B400                     mov ah, 0
  8227 00002AAE 50                       push ax
  8228 00002AAF E892F7                   call writeEA
  8229 00002AB2 83C402                   add  sp, 2
  8230                                  
  8231                                  ;-1342                     return;
  8232                                  
  8233 00002AB5 E96601                   jmp .retnprocess
  8234                                  
  8235                                  ;-1343                 }
  8236                                  
  8237                                  
  8238                                  ;-1344             }
  8239                                  
  8240                                  .process333:
  8241                                  
  8242                                  ;-1345         }
  8243                                  
  8244                                  .process332:
  8245                                  
  8246                                  ;-1346     }
  8247                                  
  8248                                  .process331:
  8249                                  
  8250                                  ;-1347 
  8251                                  
  8252                                  
  8253                                  ;-1348     if (CodeType == 12) {//int
  8254                                  
  8255                                  .process328:
  8256 00002AB8 A0[2F00]                 mov al, [CodeType]
  8257 00002ABB 3C0C                     cmp al, 12
  8258 00002ABD 0F852200                 jne .process335
  8259                                  
  8260                                  ;-1349         if (TokeType == DIGIT) {
  8261                                  
  8262 00002AC1 A0[2C00]                 mov al, [TokeType]
  8263 00002AC4 3C01                     cmp al, 1
  8264 00002AC6 0F851900                 jne .process336
  8265                                  
  8266                                  ;-1350             genCode8(Code1);
  8267                                  
  8268 00002ACA A0[3000]                 mov al, byte [Code1]
  8269 00002ACD B400                     mov ah, 0
  8270 00002ACF 50                       push ax
  8271 00002AD0 E8CFF6                   call genCode8
  8272 00002AD3 83C402                   add  sp, 2
  8273                                  
  8274                                  ;-1351             genCode8(SymbolInt);
  8275                                  
  8276 00002AD6 FF36[0E00]               push word [SymbolInt]
  8277 00002ADA E8C5F6                   call genCode8
  8278 00002ADD 83C402                   add  sp, 2
  8279                                  
  8280                                  ;-1352             return;
  8281                                  
  8282 00002AE0 E93B01                   jmp .retnprocess
  8283                                  
  8284                                  ;-1353         }
  8285                                  
  8286                                  
  8287                                  ;-1354     }
  8288                                  
  8289                                  .process336:
  8290                                  
  8291                                  ;-1355 
  8292                                  
  8293                                  
  8294                                  ;-1356     if (CodeType == 30) {//enter i18,i8
  8295                                  
  8296                                  .process335:
  8297 00002AE3 A0[2F00]                 mov al, [CodeType]
  8298 00002AE6 3C1E                     cmp al, 30
  8299 00002AE8 0F855200                 jne .process337
  8300                                  
  8301                                  ;-1357         genCode8(0xC8);
  8302                                  
  8303 00002AEC 68C800                   push 200
  8304 00002AEF E8B0F6                   call genCode8
  8305 00002AF2 83C402                   add  sp, 2
  8306                                  
  8307                                  ;-1358         Op=getOp1();
  8308                                  
  8309 00002AF5 E844DB                   call getOp1
  8310 00002AF8 A2[2D00]                 mov byte [Op], al
  8311                                  
  8312                                  ;-1359         if (Op == IMM) genCode16(SymbolInt);
  8313                                  
  8314 00002AFB A0[2D00]                 mov al, [Op]
  8315 00002AFE 3C01                     cmp al, 1
  8316 00002B00 0F850D00                 jne .process338
  8317 00002B04 FF36[0E00]               push word [SymbolInt]
  8318 00002B08 E8EEF6                   call genCode16
  8319 00002B0B 83C402                   add  sp, 2
  8320                                  
  8321                                  ;-1360         else numbererror();
  8322                                  
  8323 00002B0E E90300                   jmp .process339
  8324                                  .process338:
  8325 00002B11 E8B6F0                   call numbererror
  8326                                  
  8327                                  ;-1361         need(',');
  8328                                  
  8329                                  .process339:
  8330 00002B14 6A2C                     push 44
  8331 00002B16 E808E4                   call need
  8332 00002B19 83C402                   add  sp, 2
  8333                                  
  8334                                  ;-1362         Op=getOp1();
  8335                                  
  8336 00002B1C E81DDB                   call getOp1
  8337 00002B1F A2[2D00]                 mov byte [Op], al
  8338                                  
  8339                                  ;-1363         if (Op == IMM) genCode8 (SymbolInt);
  8340                                  
  8341 00002B22 A0[2D00]                 mov al, [Op]
  8342 00002B25 3C01                     cmp al, 1
  8343 00002B27 0F850D00                 jne .process340
  8344 00002B2B FF36[0E00]               push word [SymbolInt]
  8345 00002B2F E870F6                   call genCode8
  8346 00002B32 83C402                   add  sp, 2
  8347                                  
  8348                                  ;-1364         else numbererror();
  8349                                  
  8350 00002B35 E90300                   jmp .process341
  8351                                  .process340:
  8352 00002B38 E88FF0                   call numbererror
  8353                                  
  8354                                  ;-1365         return;
  8355                                  
  8356                                  .process341:
  8357 00002B3B E9E000                   jmp .retnprocess
  8358                                  
  8359                                  ;-1366     }
  8360                                  
  8361                                  
  8362                                  ;-1367 
  8363                                  
  8364                                  
  8365                                  ;-1368     if (CodeType==101) {//ORG nn
  8366                                  
  8367                                  .process337:
  8368 00002B3E A0[2F00]                 mov al, [CodeType]
  8369 00002B41 3C65                     cmp al, 101
  8370 00002B43 0F851500                 jne .process342
  8371                                  
  8372                                  ;-1369         if (TokeType != DIGIT) numbererror();
  8373                                  
  8374 00002B47 A0[2C00]                 mov al, [TokeType]
  8375 00002B4A 3C01                     cmp al, 1
  8376 00002B4C 0F840300                 je  .process343
  8377 00002B50 E877F0                   call numbererror
  8378                                  
  8379                                  ;-1370         Origin=SymbolInt;
  8380                                  
  8381                                  .process343:
  8382 00002B53 A1[0E00]                 mov ax, [SymbolInt]
  8383 00002B56 A3[2500]                 mov word [Origin], ax
  8384                                  
  8385                                  ;-1371         return;
  8386                                  
  8387 00002B59 E9C200                   jmp .retnprocess
  8388                                  
  8389                                  ;-1372     }
  8390                                  
  8391                                  
  8392                                  ;-1373 
  8393                                  
  8394                                  
  8395                                  ;-1374     if (CodeType == 102) {//section, segment
  8396                                  
  8397                                  .process342:
  8398 00002B5C A0[2F00]                 mov al, [CodeType]
  8399 00002B5F 3C66                     cmp al, 102
  8400 00002B61 0F850900                 jne .process344
  8401                                  
  8402                                  ;-1375         //getTokeType();//ignore .bss .text .data
  8403                                  
  8404                                  
  8405                                  ;-1376         AbsoluteLab=0;//nasm resets erevy time
  8406                                  
  8407 00002B65 B80000                   mov ax, 0
  8408 00002B68 A3[2700]                 mov word [AbsoluteLab], ax
  8409                                  
  8410                                  ;-1377         return;
  8411                                  
  8412 00002B6B E9B000                   jmp .retnprocess
  8413                                  
  8414                                  ;-1378     }
  8415                                  
  8416                                  
  8417                                  ;-1379 
  8418                                  
  8419                                  
  8420                                  ;-1380     if (CodeType == 110) {//absolute
  8421                                  
  8422                                  .process344:
  8423 00002B6E A0[2F00]                 mov al, [CodeType]
  8424 00002B71 3C6E                     cmp al, 110
  8425 00002B73 0F851500                 jne .process345
  8426                                  
  8427                                  ;-1381         if (TokeType != DIGIT) numbererror();
  8428                                  
  8429 00002B77 A0[2C00]                 mov al, [TokeType]
  8430 00002B7A 3C01                     cmp al, 1
  8431 00002B7C 0F840300                 je  .process346
  8432 00002B80 E847F0                   call numbererror
  8433                                  
  8434                                  ;-1382         AbsoluteLab=SymbolInt;
  8435                                  
  8436                                  .process346:
  8437 00002B83 A1[0E00]                 mov ax, [SymbolInt]
  8438 00002B86 A3[2700]                 mov word [AbsoluteLab], ax
  8439                                  
  8440                                  ;-1383         return;
  8441                                  
  8442 00002B89 E99200                   jmp .retnprocess
  8443                                  
  8444                                  ;-1384     }
  8445                                  
  8446                                  
  8447                                  ;-1385     if (CodeType == 111) {//name: PROC
  8448                                  
  8449                                  .process345:
  8450 00002B8C A0[2F00]                 mov al, [CodeType]
  8451 00002B8F 3C6F                     cmp al, 111
  8452 00002B91 0F853E00                 jne .process347
  8453                                  
  8454                                  ;-1386         if (isInProc == 0)  {
  8455                                  
  8456 00002B95 A0[0D00]                 mov al, [isInProc]
  8457 00002B98 3C00                     cmp al, 0
  8458 00002B9A 0F852900                 jne .process348
  8459                                  
  8460                                  ;-1387           prs("\n;entering: ");
  8461                                  
  8462 00002B9E 68[332C]                 push process_1
  8463 00002BA1 E8AEED                   call prs
  8464 00002BA4 83C402                   add  sp, 2
  8465                                  
  8466                                  ;-1388           prs(ProcName);
  8467                                  
  8468 00002BA7 8D066E75                 lea  ax, [ProcName]
  8469 00002BAB 50                       push ax
  8470 00002BAC E8A3ED                   call prs
  8471 00002BAF 83C402                   add  sp, 2
  8472                                  
  8473                                  ;-1389           isInProc=1;
  8474                                  
  8475 00002BB2 B80100                   mov ax, 1
  8476 00002BB5 A2[0D00]                 mov byte [isInProc], al
  8477                                  
  8478                                  ;-1390           locLabelNamePtr = LabelNamePtr;
  8479                                  
  8480 00002BB8 A1[4600]                 mov ax, [LabelNamePtr]
  8481 00002BBB A3[4800]                 mov word [locLabelNamePtr], ax
  8482                                  
  8483                                  ;-1391           localLabelMaxIx = LabelMaxIx;
  8484                                  
  8485 00002BBE A1[4A00]                 mov ax, [LabelMaxIx]
  8486 00002BC1 A3[4C00]                 mov word [localLabelMaxIx], ax
  8487                                  
  8488                                  ;-1392         } else error1("already in proc");
  8489                                  
  8490 00002BC4 E90900                   jmp .process349
  8491                                  .process348:
  8492 00002BC7 68[412C]                 push process_2
  8493 00002BCA E8D7EE                   call error1
  8494 00002BCD 83C402                   add  sp, 2
  8495                                  
  8496                                  ;-1393         return;
  8497                                  
  8498                                  .process349:
  8499 00002BD0 E94B00                   jmp .retnprocess
  8500                                  
  8501                                  ;-1394     }
  8502                                  
  8503                                  
  8504                                  ;-1395     if (CodeType == 112) {//ENDP
  8505                                  
  8506                                  .process347:
  8507 00002BD3 A0[2F00]                 mov al, [CodeType]
  8508 00002BD6 3C70                     cmp al, 112
  8509 00002BD8 0F853900                 jne .process350
  8510                                  
  8511                                  ;-1396       prs("\n;leaving: ");
  8512                                  
  8513 00002BDC 68[512C]                 push process_3
  8514 00002BDF E870ED                   call prs
  8515 00002BE2 83C402                   add  sp, 2
  8516                                  
  8517                                  ;-1397       prs(ProcName);
  8518                                  
  8519 00002BE5 8D066E75                 lea  ax, [ProcName]
  8520 00002BE9 50                       push ax
  8521 00002BEA E865ED                   call prs
  8522 00002BED 83C402                   add  sp, 2
  8523                                  
  8524                                  ;-1398       isInProc=0;
  8525                                  
  8526 00002BF0 B80000                   mov ax, 0
  8527 00002BF3 A2[0D00]                 mov byte [isInProc], al
  8528                                  
  8529                                  ;-1399       i = LabelMaxIx - localLabelMaxIx;
  8530                                  
  8531 00002BF6 A1[4A00]                 mov ax, [LabelMaxIx]
  8532 00002BF9 2B06[4C00]               sub ax, [localLabelMaxIx]
  8533 00002BFD 8946FC                   mov [bp-4], ax
  8534                                  
  8535                                  ;-1400       prs(". # local labels :");
  8536                                  
  8537 00002C00 68[5E2C]                 push process_4
  8538 00002C03 E84CED                   call prs
  8539 00002C06 83C402                   add  sp, 2
  8540                                  
  8541                                  ;-1401       printIntU(i);
  8542                                  
  8543 00002C09 FF76FC                   push word [bp-4]
  8544 00002C0C E853EE                   call printIntU
  8545 00002C0F 83C402                   add  sp, 2
  8546                                  
  8547                                  ;-1402 // 1. close push string
  8548                                  
  8549                                  
  8550                                  ;-1403 // 2. close open call/jmp
  8551                                  
  8552                                  
  8553                                  ;-1404 // 3. delete all local labels
  8554                                  
  8555                                  
  8556                                  ;-1405       return;
  8557                                  
  8558 00002C12 E90900                   jmp .retnprocess
  8559                                  
  8560                                  ;-1406     }
  8561                                  
  8562                                  
  8563                                  ;-1407     error1("Command not implemented or syntax error");
  8564                                  
  8565                                  .process350:
  8566 00002C15 68[712C]                 push process_5
  8567 00002C18 E889EE                   call error1
  8568 00002C1B 83C402                   add  sp, 2
  8569                                  
  8570                                  ;-1408 }
  8571                                  
  8572 00002C1E C9                       .retnprocess: LEAVE
  8573 00002C1F C3                       ret
  8574 00002C20 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8575 00002C29 7420616C6C6F776564-
  8576 00002C32 00                 
  8577 00002C33 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8578 00002C3C 6E673A2000         
  8579 00002C41 616C72656164792069-     process_2 db "already in proc",0
  8580 00002C4A 6E2070726F6300     
  8581 00002C51 5C6E3B6C656176696E-     process_3 db "\n;leaving: ",0
  8582 00002C5A 673A2000           
  8583 00002C5E 2E2023206C6F63616C-     process_4 db ". # local labels :",0
  8584 00002C67 206C6162656C73203A-
  8585 00002C70 00                 
  8586 00002C71 436F6D6D616E64206E-     process_5 db "Command not implemented or syntax error",0
  8587 00002C7A 6F7420696D706C656D-
  8588 00002C83 656E746564206F7220-
  8589 00002C8C 73796E746178206572-
  8590 00002C95 726F7200           
  8591                                  ENDP
  8592                                   
  8593                                  ; missing functions: 
  8594                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8595 00002C99 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8596 00002C9C 58                      pop ax
  8597 00002C9D C3                      ret
  8598                                   
  8599                                  ;   # type sign width  adr used name   list of global variables
  8600                                  
  8601                                  ;    1 arr sign byte     1    2 Version1[9]
  8602                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  8603                                  ;    3 arr sign byte     4   12 Symbol[31]
  8604                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  8605                                  ;    5 arr sign byte     6    3 ProcName[31]
  8606                                  ;    6 var sign byte     7    5 isInProc
  8607                                  ;    7 var unsg word     8   24 SymbolInt
  8608                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  8609                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  8610                                  ;   10 arr sign byte    11    4 InputBuf[255]
  8611                                  ;   11 ptr unsg byte    12   24 InputPtr
  8612                                  ;   12 arr sign byte    13    5 namein[67]
  8613                                  ;   13 arr sign byte    14    6 namelst[67]
  8614                                  ;   14 arr sign byte    15    6 namebin[67]
  8615                                  ;   15 var sign word    16    4 asm_fd
  8616                                  ;   16 var sign word    17    3 lst_fd
  8617                                  ;   17 var sign word    18    3 bin_fd
  8618                                  ;   18 var sign word    19    6 DOS_ERR
  8619                                  ;   19 var sign word    20    4 ErrorCount
  8620                                  ;   20 var sign word    21    4 DOS_NoBytes
  8621                                  ;   21 var sign byte    22    5 DOS_ByteRead
  8622                                  ;   22 var unsg word    24    7 PC
  8623                                  ;   23 var unsg word    25    5 Origin
  8624                                  ;   24 var unsg word    26    6 AbsoluteLab
  8625                                  ;   25 var unsg word    27    2 PCStart
  8626                                  ;   26 var sign byte    28    3 isLabel
  8627                                  ;   27 def unsg byte    29    - DIGIT=1
  8628                                  ;   28 def unsg byte    30    - LETTERE=2
  8629                                  ;   29 def unsg byte    31    - ALNUME=3
  8630                                  ;   30 def unsg byte    32    - NOALNUME=4
  8631                                  ;   31 var sign byte    33   27 TokeType
  8632                                  ;   32 def unsg byte    34    - BYTE=1
  8633                                  ;   33 def unsg byte    35    - WORD=2
  8634                                  ;   34 def unsg byte    36    - DWORD=3
  8635                                  ;   35 def unsg byte    37    - SEGREG=4
  8636                                  ;   36 def unsg byte    38    - IMM=1
  8637                                  ;   37 def unsg byte    39    - REG=2
  8638                                  ;   38 def unsg byte    40    - ADR=3
  8639                                  ;   39 def unsg byte    41    - MEM=4
  8640                                  ;   40 var sign byte    42   29 Op
  8641                                  ;   41 var sign byte    43   31 Op2
  8642                                  ;   42 var sign byte    44   29 CodeType
  8643                                  ;   43 var sign byte    45   23 Code1
  8644                                  ;   44 var sign byte    46    7 Code2
  8645                                  ;   45 var sign byte    47    3 Code3
  8646                                  ;   46 var sign byte    48   19 R2No
  8647                                  ;   47 var sign byte    49   16 R1No
  8648                                  ;   48 var sign byte    50   18 R2Type
  8649                                  ;   49 var sign byte    51   15 R1Type
  8650                                  ;   50 var sign byte    52   14 OpSize
  8651                                  ;   51 var sign byte    53    9 wflag
  8652                                  ;   52 var sign byte    54    3 dflag
  8653                                  ;   53 var sign byte    55    8 sflag
  8654                                  ;   54 var sign byte    56   15 rm
  8655                                  ;   55 var sign byte    57    5 isDirect
  8656                                  ;   56 var sign word    58   49 disp
  8657                                  ;   57 var unsg word    59   13 imme
  8658                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  8659                                  ;   59 arr sign byte    62    2 OpPos[5]
  8660                                  ;   60 var sign word    63    6 OpPrintIndex
  8661                                  ;   61 ptr sign byte    64   19 OpCodePtr
  8662                                  ;   62 var sign byte    65    4 PrintRA
  8663                                  ;   63 def unsg byte    67    - LABELNAMESMAX=3969
  8664                                  ;   64 arr sign byte    68    3 LabelNames[4000]
  8665                                  ;   65 ptr sign byte    69    6 LabelNamePtr
  8666                                  ;   66 var unsg word    70    1 locLabelNamePtr
  8667                                  ;   67 def unsg byte    71    - LABELADRMAX=600
  8668                                  ;   68 arr unsg word    72    7 LabelAddr[600]
  8669                                  ;   69 var sign word    73    9 LabelMaxIx
  8670                                  ;   70 var sign word    74    2 localLabelMaxIx
  8671                                  ;   71 var sign word    75   10 LabelIx
  8672                                  ;   72 def unsg byte    77    - JMPCALLNAMESMAX=1969
  8673                                  ;   73 arr sign byte    78    3 JmpCallNames[2000]
  8674                                  ;   74 ptr sign byte    79    5 JmpCallNamePtr
  8675                                  ;   75 def unsg byte    80    - JMPCALLMAX=500
  8676                                  ;   76 arr unsg word    81    2 JmpCallAddr[500]
  8677                                  ;   77 var sign word    82    6 JmpCallMaxIx
  8678                                  ;   78 def unsg byte    84    - FILEBINMAX=20000
  8679                                  ;   79 arr sign byte    85    4 FileBin[20000]
  8680                                  ;   80 var unsg word    86    6 BinLen
  8681                                  ;   81 ptr sign byte    88    1 arglen
  8682                                  ;   82 ptr sign byte    89    4 argv
  8683                                  ;   83 var sign byte    93    1 I_START
  8684                                  ;   84 arr sign byte    96 NULL I_PUSHA[39424]
  8685                                  ;   85 arr sign byte    97 NULL I_NOP[674]
  8686                                  ;   86 arr sign byte    98 NULL I_CWDE[8125]
  8687                                  ;   87 arr sign byte    99 NULL I_CDQ[24260]
  8688                                  ;   88 arr sign byte   100 NULL I_PUSHF[9734]
  8689                                  ;   89 arr sign byte   101 NULL I_SAHF[1931]
  8690                                  ;   90 arr sign byte   102 NULL I_MOVSB[35622]
  8691                                  ;   91 arr sign byte   103 NULL I_CMPSB[599]
  8692                                  ;   92 arr sign byte   104 NULL I_STOSB[53495]
  8693                                  ;   93 arr sign byte   105 NULL I_LODSB[54007]
  8694                                  ;   94 arr sign byte   106 NULL I_SCASB[37]
  8695                                  ;   95 arr sign byte   107 NULL I_LEAVE[27968]
  8696                                  ;   96 arr sign byte   108 NULL I_INTO[26977]
  8697                                  ;   97 arr sign byte   109 NULL I_XLAT[110]
  8698                                  ;   98 arr sign byte   110 NULL I_REPNE[13644]
  8699                                  ;   99 arr sign byte   111 NULL I_REPE[19456]
  8700                                  ;  100 arr sign byte   112 NULL I_HLT[54]
  8701                                  ;  101 arr sign byte   113 NULL I_STC[14156]
  8702                                  ;  102 arr sign byte   114 NULL I_STI[19456]
  8703                                  ;  103 arr sign byte   115 NULL I_STD[56]
  8704                                  ;  104 arr sign byte   117 NULL I_INC[14412]
  8705                                  ;  105 arr sign byte   118 NULL I_DEC[19456]
  8706                                  ;  106 arr sign byte   119 NULL I_NOT[57]
  8707                                  ;  107 arr sign byte   120 NULL I_NEG[14668]
  8708                                  ;  108 arr sign byte   121 NULL I_MUL[17920]
  8709                                  ;  109 arr sign byte   122 NULL I_IMUL[65534]
  8710                                  ;  110 arr sign byte   123 NULL I_DIV[33791]
  8711                                  ;  111 arr sign byte   124 NULL I_IDIV[65150]
  8712                                  ;  112 arr sign byte   126 NULL I_LES[30207]
  8713                                  ;  113 arr sign byte   127 NULL I_LDS[15642]
  8714                                  ;  114 arr sign byte   128 NULL I_LEA[65535]
  8715                                  ;  115 arr sign byte   129 NULL I_LSS[5493]
  8716                                  ;  116 arr sign byte   130 NULL I_LFS[33574]
  8717                                  ;  117 arr sign byte   131 NULL I_LGS[1151]
  8718                                  ;  118 arr sign byte   133 NULL I_ADD[29696]
  8719                                  ;  119 arr sign byte   134 NULL I_OR[35593]
  8720                                  ;  120 arr sign byte   135 NULL I_ADC[2630]
  8721                                  ;  121 arr sign byte   136 NULL I_SBB[14630]
  8722                                  ;  122 arr sign byte   137 NULL I_AND[1095]
  8723                                  ;  123 arr sign byte   138 NULL I_SUB[26997]
  8724                                  ;  124 arr sign byte   139 NULL I_XOR[49203]
  8725                                  ;  125 arr sign byte   140 NULL I_CMP[52169]
  8726                                  ;  126 arr sign byte   141 NULL I_TEST[33680]
  8727                                  ;  127 arr sign byte   143 NULL I_MOV[65150]
  8728                                  ;  128 arr sign byte   144 NULL I_MOVSX[29729]
  8729                                  ;  129 arr sign byte   145 NULL I_MOVZX[33618]
  8730                                  ;  130 arr sign byte   147 NULL I_JO[65150]
  8731                                  ;  131 arr sign byte   148 NULL I_JNO[29731]
  8732                                  ;  132 arr sign byte   149 NULL I_JB[33612]
  8733                                  ;  133 arr sign byte   150 NULL I_JNB[65150]
  8734                                  ;  134 arr sign byte   151 NULL I_JAE[29732]
  8735                                  ;  135 arr sign byte   152 NULL I_JE[33606]
  8736                                  ;  136 arr sign byte   153 NULL I_JNE[65150]
  8737                                  ;  137 arr sign byte   154 NULL I_JBE[29734]
  8738                                  ;  138 arr sign byte   155 NULL I_JA[33600]
  8739                                  ;  139 arr sign byte   156 NULL I_JS[65150]
  8740                                  ;  140 arr sign byte   157 NULL I_JNS[29730]
  8741                                  ;  141 arr sign byte   158 NULL I_JP[33594]
  8742                                  ;  142 arr sign byte   159 NULL I_JNP[65150]
  8743                                  ;  143 arr sign byte   160 NULL I_JL[29737]
  8744                                  ;  144 arr sign byte   161 NULL I_JNL[33588]
  8745                                  ;  145 arr sign byte   162 NULL I_JLE[65150]
  8746                                  ;  146 arr sign byte   163 NULL I_JG[29736]
  8747                                  ;  147 arr sign byte   165 NULL I_JMP[33582]
  8748                                  ;  148 arr sign byte   166 NULL I_CALL[65150]
  8749                                  ;  149 arr sign byte   168 NULL I_RET[29733]
  8750                                  ;  150 arr sign byte   169 NULL I_RETF[15656]
  8751                                  ;  151 arr sign byte   171 NULL I_PUSH[33]
  8752                                  ;  152 arr sign byte   172 NULL I_POP[9076]
  8753                                  ;  153 arr sign byte   174 NULL I_ROL[9021]
  8754                                  ;  154 arr sign byte   175 NULL I_RCL[29696]
  8755                                  ;  155 arr sign byte   176 NULL I_SHL[15646]
  8756                                  ;  156 arr sign byte   177 NULL I_SHR[36]
  8757                                  ;  157 arr sign byte   179 NULL I_INT[6516]
  8758                                  ;  158 arr sign byte   181 NULL I_IN[9789]
  8759                                  ;  159 arr sign byte   182 NULL I_INSB[29696]
  8760                                  ;  160 arr sign byte   183 NULL I_INSW[15636]
  8761                                  ;  161 arr sign byte   184 NULL I_INSD[34]
  8762                                  ;  162 arr sign byte   185 NULL I_OUT[3956]
  8763                                  ;  163 arr sign byte   186 NULL I_OUTSB[10557]
  8764                                  ;  164 arr sign byte   187 NULL I_OUTSW[29696]
  8765                                  ;  165 arr sign byte   188 NULL I_OUTSD[15626]
  8766                                  ;  166 arr sign byte   190 NULL I_XCHG[40]
  8767                                  ;  167 arr sign byte   192 NULL I_LOOPNZ[1396]
  8768                                  ;  168 arr sign byte   193 NULL I_LOOPNE[9533]
  8769                                  ;  169 arr sign byte   194 NULL I_LOOPZ[29952]
  8770                                  ;  170 arr sign byte   195 NULL I_LOOPE[33542]
  8771                                  ;  171 arr sign byte   196 NULL I_LOOP[2686]
  8772                                  ;  172 arr sign byte   197 NULL I_JCXZ[60176]
  8773                                  ;  173 arr sign byte   198 NULL I_JECXZ[33540]
  8774                                  ;  174 arr sign byte   200 NULL I_ENTER[2686]
  8775                                  ;  175 arr sign byte   202 NULL I_ORG[29984]
  8776                                  ;  176 arr sign byte   204 NULL I_SECTION[47255]
  8777                                  ;  177 arr sign byte   205 NULL I_SEGMENT[1]
  8778                                  ;  178 arr sign byte   206 NULL I_ABSOLUTE[52169]
  8779                                  ;  179 arr sign byte   207 NULL I_PROC[21904]
  8780                                  ;  180 arr sign byte   208 NULL I_ENDP[60555]
  8781                                  ;  181 arr sign byte   209 NULL I_DB[5816]
  8782                                  ;  182 arr sign byte   210 NULL I_DW[39424]
  8783                                  ;  183 arr sign byte   211 NULL I_DD[674]
  8784                                  ;  184 arr sign byte   212 NULL I_RESB[8125]
  8785                                  ;  185 arr sign byte   213 NULL I_RESW[51030]
  8786                                  ;  186 arr sign byte   214 NULL I_RESD[65094]
  8787                                  ;  187 var sign byte   215 NULL I_END
  8788                                  
  8789                                  
  8790                                  ;   # Calls Line Width  Name   list of functions
  8791                                  
  8792                                  ;    0    2  219   ChangeDirection
  8793                                  ;    1    2  227   checkOpL
  8794                                  ;    2    4  236   check2Ops
  8795                                  ;    3    1  245   get2Ops
  8796                                  ;    4    3  251   getOpL
  8797                                  ;    5    2  259   getOpR
  8798                                  ;    6    4  269   getOp1
  8799                                  ;    7    1  285   getMEM
  8800                                  ;    8    1  308   getIndReg1
  8801                                  ;    9    1  316   getIndReg2
  8802                                  ;   10    2  326   setwflag
  8803                                  ;   11    2  337   setsflag
  8804                                  ;   12    2  347   checkConstSize
  8805                                  ;   13    1  355   parse
  8806                                  ;   14   16  391   getTokeType
  8807                                  ;   15    2  402   storeJmpCall
  8808                                  ;   16    2  413   storeLabel
  8809                                  ;   17    5  425   searchLabel
  8810                                  ;   18    1  438   getVariable
  8811                                  ;   19    2  491   lookCode
  8812                                  ;   20    1  507   getCodeSize
  8813                                  ;   21    9  515   isToken
  8814                                  ;   22    2  523   need
  8815                                  ;   23    1  532   skipRest
  8816                                  ;   24    4  539   writetty
  8817                                  ;   25    1  540   putch
  8818                                  ;   26    8  541   cputs
  8819                                  ;   27    6  543   DosInt
  8820                                  ;   28    1  548   openR
  8821                                  ;   29    2  549   creatR
  8822                                  ;   30    3  550   fcloseR
  8823                                  ;   31    5  551   exitR
  8824                                  ;   32    2  552   readRL
  8825                                  ;   33    2  553   fputcR
  8826                                  ;   34    1  556   getLine
  8827                                  ;   35    1  572   ifEOL
  8828                                  ;   36    3  581   skipBlank
  8829                                  ;   37    2  586   letterE
  8830                                  ;   38    1  596   alnumE
  8831                                  ;   39    3  601   digit
  8832                                  ;   40    4  606   strlen
  8833                                  ;   41    9  611   strcpy
  8834                                  ;   42   35  617   eqstr
  8835                                  ;   43    3  626   strcat1
  8836                                  ;   44    2  630   toupper
  8837                                  ;   45    1  637   getDigit
  8838                                  ;   46    1  649   getName
  8839                                  ;   47    1  668   testReg
  8840                                  ;   48    1  712   printLine
  8841                                  ;   49    7  734   prc
  8842                                  ;   50    1  744   prscomment
  8843                                  ;   51   33  752   prs
  8844                                  ;   52    3  774   printhex8a
  8845                                  ;   53    2  779   printhex4
  8846                                  ;   54    1  784   printhex16
  8847                                  ;   55    6  789   printIntU
  8848                                  ;   56   27  800   error1
  8849                                  ;   57   13  807   errorexit
  8850                                  ;   58 NULL  812   allowederror
  8851                                  ;   59    3  813   addrerror
  8852                                  ;   60    1  814   immeerror
  8853                                  ;   61    2  815   implerror
  8854                                  ;   62    4  816   indexerror
  8855                                  ;   63    3  817   invaloperror
  8856                                  ;   64    6  818   numbererror
  8857                                  ;   65    1  819   regmemerror
  8858                                  ;   66    3  820   reg16error
  8859                                  ;   67    1  821   segregerror
  8860                                  ;   68    5  822   syntaxerror
  8861                                  ;   69 NULL  824   addrexit
  8862                                  ;   70    3  825   dataexit
  8863                                  ;   71 NULL  826   internexit
  8864                                  ;   72 NULL  830   main
  8865                                  ;   73    1  838   getarg
  8866                                  ;   74    1  872   fixJmpCall
  8867                                  ;   75    2  903   epilog
  8868                                  ;   76    2  951   end1
  8869                                  ;   77    1  961   getCodes
  8870                                  ;   78    1  966   gen66h
  8871                                  ;   79    8  968   genCode2
  8872                                  ;   80   13  972   genCodeW
  8873                                  ;   81   34  976   genCode8
  8874                                  ;   82   18  987   genCode16
  8875                                  ;   83    1  991   genCode32
  8876                                  ;   84   13  995   writeEA
  8877                                  ;   85    4 1037   genImmediate
  8878                                  ;   86    1 1044   process
  8879                                  ;   87 NULL 1408   LastFunctionByt
  8880                                  
  8881                                  ;    #  addr name   list of CALLs
  8882                                  
  8883                                  ;    0     0 implerror
  8884                                  ;    1    10 segregerror
  8885                                  ;    2    22 setwflag
  8886                                  ;    3    31 error1
  8887                                  ;    4    38 error1
  8888                                  ;    5    45 get2Ops
  8889                                  ;    6    53 addrerror
  8890                                  ;    7    63 invaloperror
  8891                                  ;    8    76 immeerror
  8892                                  ;    9    86 addrerror
  8893                                  ;   10    96 invaloperror
  8894                                  ;   11   109 setwflag
  8895                                  ;   12   118 getOpL
  8896                                  ;   13   125 need
  8897                                  ;   14   130 getOpR
  8898                                  ;   15   137 getOpR
  8899                                  ;   16   144 getOp1
  8900                                  ;   17   151 isToken
  8901                                  ;   18   159 getMEM
  8902                                  ;   19   166 invaloperror
  8903                                  ;   20   179 error1
  8904                                  ;   21   186 testReg
  8905                                  ;   22   194 searchLabel
  8906                                  ;   23   206 error1
  8907                                  ;   24   213 getTokeType
  8908                                  ;   25   225 getOp1
  8909                                  ;   26   232 syntaxerror
  8910                                  ;   27   244 getIndReg2
  8911                                  ;   28   255 getIndReg1
  8912                                  ;   29   266 isToken
  8913                                  ;   30   274 getTokeType
  8914                                  ;   31   286 numbererror
  8915                                  ;   32   298 isToken
  8916                                  ;   33   306 isToken
  8917                                  ;   34   314 errorexit
  8918                                  ;   35   324 indexerror
  8919                                  ;   36   335 indexerror
  8920                                  ;   37   346 indexerror
  8921                                  ;   38   357 indexerror
  8922                                  ;   39   368 gen66h
  8923                                  ;   40   375 error1
  8924                                  ;   41   382 getLine
  8925                                  ;   42   390 getTokeType
  8926                                  ;   43   402 strcpy
  8927                                  ;   44   409 storeLabel
  8928                                  ;   45   420 getTokeType
  8929                                  ;   46   432 lookCode
  8930                                  ;   47   441 process
  8931                                  ;   48   449 getVariable
  8932                                  ;   49   461 skipRest
  8933                                  ;   50   470 error1
  8934                                  ;   51   477 error1
  8935                                  ;   52   484 printLine
  8936                                  ;   53   494 skipBlank
  8937                                  ;   54   504 digit
  8938                                  ;   55   510 getDigit
  8939                                  ;   56   519 letterE
  8940                                  ;   57   527 getName
  8941                                  ;   58   535 errorexit
  8942                                  ;   59   545 strcpy
  8943                                  ;   60   552 errorexit
  8944                                  ;   61   562 searchLabel
  8945                                  ;   62   574 error1
  8946                                  ;   63   581 errorexit
  8947                                  ;   64   591 strcpy
  8948                                  ;   65   598 errorexit
  8949                                  ;   66   608 eqstr
  8950                                  ;   67   614 strlen
  8951                                  ;   68   621 storeLabel
  8952                                  ;   69   632 getTokeType
  8953                                  ;   70   644 lookCode
  8954                                  ;   71   653 dataexit
  8955                                  ;   72   662 dataexit
  8956                                  ;   73   671 getTokeType
  8957                                  ;   74   683 genCode8
  8958                                  ;   75   692 skipBlank
  8959                                  ;   76   702 isToken
  8960                                  ;   77   710 genCode8
  8961                                  ;   78   719 isToken
  8962                                  ;   79   727 getTokeType
  8963                                  ;   80   739 genCode16
  8964                                  ;   81   749 isToken
  8965                                  ;   82   757 getTokeType
  8966                                  ;   83   769 genCode16
  8967                                  ;   84   779 genCode16
  8968                                  ;   85   789 isToken
  8969                                  ;   86   797 getTokeType
  8970                                  ;   87   809 syntaxerror
  8971                                  ;   88   821 error1
  8972                                  ;   89   828 numbererror
  8973                                  ;   90   840 dataexit
  8974                                  ;   91   849 eqstr
  8975                                  ;   92   855 eqstr
  8976                                  ;   93   861 getTokeType
  8977                                  ;   94   873 eqstr
  8978                                  ;   95   879 getTokeType
  8979                                  ;   96   891 eqstr
  8980                                  ;   97   897 getTokeType
  8981                                  ;   98   909 skipBlank
  8982                                  ;   99   919 isToken
  8983                                  ;  100   927 getTokeType
  8984                                  ;  101   939 error1
  8985                                  ;  102   946 prs
  8986                                  ;  103   950 prc
  8987                                  ;  104   954 getTokeType
  8988                                  ;  105   966 error1
  8989                                  ;  106   973 writetty
  8990                                  ;  107   982 writetty
  8991                                  ;  108   991 putch
  8992                                  ;  109   997 DosInt
  8993                                  ;  110  1004 DosInt
  8994                                  ;  111  1011 DosInt
  8995                                  ;  112  1018 DosInt
  8996                                  ;  113  1025 DosInt
  8997                                  ;  114  1032 DosInt
  8998                                  ;  115  1039 readRL
  8999                                  ;  116  1046 errorexit
  9000                                  ;  117  1056 errorexit
  9001                                  ;  118  1066 ifEOL
  9002                                  ;  119  1072 readRL
  9003                                  ;  120  1079 errorexit
  9004                                  ;  121  1089 digit
  9005                                  ;  122  1095 letterE
  9006                                  ;  123  1103 strcpy
  9007                                  ;  124  1110 digit
  9008                                  ;  125  1116 alnumE
  9009                                  ;  126  1123 errorexit
  9010                                  ;  127  1133 strcpy
  9011                                  ;  128  1140 toupper
  9012                                  ;  129  1148 strlen
  9013                                  ;  130  1155 strlen
  9014                                  ;  131  1162 eqstr
  9015                                  ;  132  1168 eqstr
  9016                                  ;  133  1174 eqstr
  9017                                  ;  134  1180 eqstr
  9018                                  ;  135  1186 eqstr
  9019                                  ;  136  1192 eqstr
  9020                                  ;  137  1198 eqstr
  9021                                  ;  138  1204 eqstr
  9022                                  ;  139  1210 eqstr
  9023                                  ;  140  1216 eqstr
  9024                                  ;  141  1222 eqstr
  9025                                  ;  142  1228 eqstr
  9026                                  ;  143  1234 eqstr
  9027                                  ;  144  1240 eqstr
  9028                                  ;  145  1246 eqstr
  9029                                  ;  146  1252 eqstr
  9030                                  ;  147  1258 eqstr
  9031                                  ;  148  1264 eqstr
  9032                                  ;  149  1270 eqstr
  9033                                  ;  150  1276 eqstr
  9034                                  ;  151  1282 eqstr
  9035                                  ;  152  1288 eqstr
  9036                                  ;  153  1294 eqstr
  9037                                  ;  154  1300 eqstr
  9038                                  ;  155  1306 eqstr
  9039                                  ;  156  1312 eqstr
  9040                                  ;  157  1318 eqstr
  9041                                  ;  158  1324 eqstr
  9042                                  ;  159  1330 eqstr
  9043                                  ;  160  1336 eqstr
  9044                                  ;  161  1342 prs
  9045                                  ;  162  1346 printhex16
  9046                                  ;  163  1357 prs
  9047                                  ;  164  1361 prc
  9048                                  ;  165  1365 printhex8a
  9049                                  ;  166  1376 prs
  9050                                  ;  167  1380 prc
  9051                                  ;  168  1384 prscomment
  9052                                  ;  169  1395 writetty
  9053                                  ;  170  1404 writetty
  9054                                  ;  171  1413 fputcR
  9055                                  ;  172  1420 prc
  9056                                  ;  173  1424 prc
  9057                                  ;  174  1428 printhex4
  9058                                  ;  175  1438 printhex4
  9059                                  ;  176  1448 prc
  9060                                  ;  177  1452 printhex8a
  9061                                  ;  178  1463 printhex8a
  9062                                  ;  179  1474 printIntU
  9063                                  ;  180  1484 prc
  9064                                  ;  181  1488 prs
  9065                                  ;  182  1492 prs
  9066                                  ;  183  1496 prs
  9067                                  ;  184  1500 prs
  9068                                  ;  185  1504 error1
  9069                                  ;  186  1511 epilog
  9070                                  ;  187  1518 end1
  9071                                  ;  188  1523 error1
  9072                                  ;  189  1530 error1
  9073                                  ;  190  1537 error1
  9074                                  ;  191  1544 error1
  9075                                  ;  192  1551 error1
  9076                                  ;  193  1558 error1
  9077                                  ;  194  1565 error1
  9078                                  ;  195  1572 error1
  9079                                  ;  196  1579 error1
  9080                                  ;  197  1586 error1
  9081                                  ;  198  1593 error1
  9082                                  ;  199  1600 errorexit
  9083                                  ;  200  1610 errorexit
  9084                                  ;  201  1620 errorexit
  9085                                  ;  202  1630 getarg
  9086                                  ;  203  1637 parse
  9087                                  ;  204  1643 fixJmpCall
  9088                                  ;  205  1654 epilog
  9089                                  ;  206  1661 end1
  9090                                  ;  207  1666 cputs
  9091                                  ;  208  1672 cputs
  9092                                  ;  209  1678 exitR
  9093                                  ;  210  1684 toupper
  9094                                  ;  211  1692 strcpy
  9095                                  ;  212  1699 strcat1
  9096                                  ;  213  1707 strcpy
  9097                                  ;  214  1714 strcat1
  9098                                  ;  215  1722 strcpy
  9099                                  ;  216  1729 strcat1
  9100                                  ;  217  1737 openR
  9101                                  ;  218  1743 cputs
  9102                                  ;  219  1749 cputs
  9103                                  ;  220  1755 exitR
  9104                                  ;  221  1761 creatR
  9105                                  ;  222  1768 cputs
  9106                                  ;  223  1774 cputs
  9107                                  ;  224  1780 exitR
  9108                                  ;  225  1786 creatR
  9109                                  ;  226  1793 cputs
  9110                                  ;  227  1799 cputs
  9111                                  ;  228  1805 exitR
  9112                                  ;  229  1811 prs
  9113                                  ;  230  1815 prs
  9114                                  ;  231  1819 prs
  9115                                  ;  232  1823 prs
  9116                                  ;  233  1827 prs
  9117                                  ;  234  1831 prs
  9118                                  ;  235  1835 prs
  9119                                  ;  236  1839 prs
  9120                                  ;  237  1843 prs
  9121                                  ;  238  1847 prs
  9122                                  ;  239  1851 printIntU
  9123                                  ;  240  1861 strcpy
  9124                                  ;  241  1868 strlen
  9125                                  ;  242  1875 searchLabel
  9126                                  ;  243  1887 error1
  9127                                  ;  244  1894 prs
  9128                                  ;  245  1898 printIntU
  9129                                  ;  246  1908 prs
  9130                                  ;  247  1912 prs
  9131                                  ;  248  1916 prs
  9132                                  ;  249  1920 prs
  9133                                  ;  250  1924 prs
  9134                                  ;  251  1928 prs
  9135                                  ;  252  1932 printIntU
  9136                                  ;  253  1942 prs
  9137                                  ;  254  1946 fputcR
  9138                                  ;  255  1953 prs
  9139                                  ;  256  1957 printIntU
  9140                                  ;  257  1967 prs
  9141                                  ;  258  1971 fcloseR
  9142                                  ;  259  1979 fcloseR
  9143                                  ;  260  1987 fcloseR
  9144                                  ;  261  1995 exitR
  9145                                  ;  262  2001 genCode8
  9146                                  ;  263  2010 genCode8
  9147                                  ;  264  2019 genCode8
  9148                                  ;  265  2028 errorexit
  9149                                  ;  266  2038 genCode8
  9150                                  ;  267  2047 genCode8
  9151                                  ;  268  2056 genCode16
  9152                                  ;  269  2066 genCode16
  9153                                  ;  270  2076 genCode8
  9154                                  ;  271  2085 genCode8
  9155                                  ;  272  2094 genCode16
  9156                                  ;  273  2104 genCode32
  9157                                  ;  274  2114 genCode16
  9158                                  ;  275  2124 genCode8
  9159                                  ;  276  2133 getTokeType
  9160                                  ;  277  2145 getCodeSize
  9161                                  ;  278  2157 getCodes
  9162                                  ;  279  2166 genCode8
  9163                                  ;  280  2175 getOpL
  9164                                  ;  281  2182 checkOpL
  9165                                  ;  282  2191 genCode2
  9166                                  ;  283  2200 getTokeType
  9167                                  ;  284  2212 implerror
  9168                                  ;  285  2222 genCodeW
  9169                                  ;  286  2231 writeEA
  9170                                  ;  287  2239 check2Ops
  9171                                  ;  288  2249 reg16error
  9172                                  ;  289  2260 addrerror
  9173                                  ;  290  2270 genCode8
  9174                                  ;  291  2279 genCode8
  9175                                  ;  292  2288 writeEA
  9176                                  ;  293  2296 check2Ops
  9177                                  ;  294  2306 setsflag
  9178                                  ;  295  2315 genCodeW
  9179                                  ;  296  2324 genImmediate
  9180                                  ;  297  2337 genCodeW
  9181                                  ;  298  2346 writeEA
  9182                                  ;  299  2354 genCode8
  9183                                  ;  300  2363 genImmediate
  9184                                  ;  301  2376 genCodeW
  9185                                  ;  302  2385 writeEA
  9186                                  ;  303  2393 genCodeW
  9187                                  ;  304  2402 writeEA
  9188                                  ;  305  2410 syntaxerror
  9189                                  ;  306  2422 check2Ops
  9190                                  ;  307  2432 genCode2
  9191                                  ;  308  2441 genImmediate
  9192                                  ;  309  2454 genCodeW
  9193                                  ;  310  2463 writeEA
  9194                                  ;  311  2471 genImmediate
  9195                                  ;  312  2484 regmemerror
  9196                                  ;  313  2496 ChangeDirection
  9197                                  ;  314  2512 reg16error
  9198                                  ;  315  2523 genCode2
  9199                                  ;  316  2532 writeEA
  9200                                  ;  317  2540 genCodeW
  9201                                  ;  318  2549 genCode16
  9202                                  ;  319  2559 genCodeW
  9203                                  ;  320  2568 genCode16
  9204                                  ;  321  2578 genCodeW
  9205                                  ;  322  2587 writeEA
  9206                                  ;  323  2595 ChangeDirection
  9207                                  ;  324  2611 genCodeW
  9208                                  ;  325  2620 writeEA
  9209                                  ;  326  2628 syntaxerror
  9210                                  ;  327  2640 searchLabel
  9211                                  ;  328  2652 checkConstSize
  9212                                  ;  329  2667 genCode2
  9213                                  ;  330  2676 genCode8
  9214                                  ;  331  2685 genCode8
  9215                                  ;  332  2694 genCode2
  9216                                  ;  333  2703 genCode16
  9217                                  ;  334  2713 genCode8
  9218                                  ;  335  2722 genCode2
  9219                                  ;  336  2731 genCode16
  9220                                  ;  337  2741 storeJmpCall
  9221                                  ;  338  2754 searchLabel
  9222                                  ;  339  2766 checkConstSize
  9223                                  ;  340  2781 genCode8
  9224                                  ;  341  2790 genCode8
  9225                                  ;  342  2799 genCode8
  9226                                  ;  343  2808 genCode16
  9227                                  ;  344  2818 genCode8
  9228                                  ;  345  2827 genCode16
  9229                                  ;  346  2837 genCode8
  9230                                  ;  347  2846 genCode16
  9231                                  ;  348  2856 storeJmpCall
  9232                                  ;  349  2869 genCode8
  9233                                  ;  350  2878 genCode16
  9234                                  ;  351  2888 genCode8
  9235                                  ;  352  2897 getOpL
  9236                                  ;  353  2904 setsflag
  9237                                  ;  354  2913 genCode2
  9238                                  ;  355  2922 genCode8
  9239                                  ;  356  2931 genCode16
  9240                                  ;  357  2941 genCode8
  9241                                  ;  358  2950 genCode16
  9242                                  ;  359  2960 error1
  9243                                  ;  360  2967 genCode8
  9244                                  ;  361  2976 genCode8
  9245                                  ;  362  2985 checkOpL
  9246                                  ;  363  2994 reg16error
  9247                                  ;  364  3005 genCode2
  9248                                  ;  365  3014 genCode8
  9249                                  ;  366  3023 writeEA
  9250                                  ;  367  3031 syntaxerror
  9251                                  ;  368  3043 check2Ops
  9252                                  ;  369  3053 genCodeW
  9253                                  ;  370  3062 writeEA
  9254                                  ;  371  3070 genCodeW
  9255                                  ;  372  3079 writeEA
  9256                                  ;  373  3087 genCode8
  9257                                  ;  374  3096 genCodeW
  9258                                  ;  375  3105 writeEA
  9259                                  ;  376  3113 genCode8
  9260                                  ;  377  3122 genCode8
  9261                                  ;  378  3131 genCode8
  9262                                  ;  379  3140 getOp1
  9263                                  ;  380  3147 genCode16
  9264                                  ;  381  3157 numbererror
  9265                                  ;  382  3169 need
  9266                                  ;  383  3174 getOp1
  9267                                  ;  384  3181 genCode8
  9268                                  ;  385  3190 numbererror
  9269                                  ;  386  3202 numbererror
  9270                                  ;  387  3214 numbererror
  9271                                  ;  388  3226 prs
  9272                                  ;  389  3230 prs
  9273                                  ;  390  3234 error1
  9274                                  ;  391  3241 prs
  9275                                  ;  392  3245 prs
  9276                                  ;  393  3249 prs
  9277                                  ;  394  3253 printIntU
  9278                                  ;  395  3263 error1
  9279                                  ;Input: AS.C, List: AS.S,  Lines: 1409
  9280                                  ;Glob. variables:  187 max.:  200
  9281                                  ;Functions      :   88 max.:  300
  9282                                  ;Calls          :  396 max.: 2000, NameField: 3270 max.:    65535
  9283                                  ;Code until     :21667 max.: 30000, free: 8333
  9284                                  ;Data (HeapEnd) :58754, resting stacksize:  6781
  9285                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
