     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9D01C                  jmp main
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
   316                                  ;-76 int locStrAdrIx=0;      //push string not known
   317                                  
   318 00000050 0000                    locStrAdrIx dw 0
   319                                  
   320                                  ;-77 unsigned int locStrAdr[100];//list of push of strings not known
   321                                  
   322                                  section .bss
   323                                  absolute 35754
   324 00008BAA <res 000000C8>          locStrAdr resw 100
   325                                  section .text
   326                                  
   327                                  ;-78 
   328                                  
   329                                  
   330                                  ;-79 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   331                                  
   332                                  
   333                                  ;-80 char JmpCallNames[2000];//space for names of jmp, call
   334                                  
   335                                  section .bss
   336                                  absolute 35954
   337 00008C72 <res 000007D0>          JmpCallNames resb 2000
   338                                  section .text
   339                                  
   340                                  ;-81 char *JmpCallNamePtr;   //first free position
   341                                  
   342 00000052 0000                    JmpCallNamePtr dw 0
   343                                  
   344                                  ;-82 #define JMPCALLMAX 500  //max. jmp and call
   345                                  
   346                                  
   347                                  ;-83 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   348                                  
   349                                  section .bss
   350                                  absolute 37954
   351 00009442 <res 000003E8>          JmpCallAddr resw 500
   352                                  section .text
   353                                  
   354                                  ;-84 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   355                                  
   356 00000054 0000                    JmpCallMaxIx dw 0
   357                                  
   358                                  ;-85 
   359                                  
   360                                  
   361                                  ;-86 #define FILEBINMAX 20000
   362                                  
   363                                  
   364                                  ;-87 char FileBin  [FILEBINMAX];//output binary file
   365                                  
   366                                  section .bss
   367                                  absolute 38954
   368 0000982A <res 00004E20>          FileBin resb 20000
   369                                  section .text
   370                                  
   371                                  ;-88 unsigned int BinLen=0;  //length of binary file
   372                                  
   373 00000056 0000                    BinLen dw 0
   374                                  
   375                                  ;-89 
   376                                  
   377                                  
   378                                  ;-90 char *arglen=0x80;      // for main only
   379                                  
   380 00000058 8000                    arglen dw 128
   381                                  
   382                                  ;-91 char *argv=0x82;        // for main only
   383                                  
   384 0000005A 8200                    argv dw 130
   385                                  
   386                                  ;-92 
   387                                  
   388                                  
   389                                  ;-93 
   390                                  
   391                                  
   392                                  ;-94 //#include "OPTABL.C"
   393                                  
   394                                  
   395                                  ;-95 char I_START=0xF1;
   396                                  
   397 0000005C F1                      I_START db 241
   398                                  
   399                                  ;-96 //OpName, 0, CodeType, OpCode1-n, F1h
   400                                  
   401                                  
   402                                  ;-97 //  1:   1 byte opcode
   403                                  
   404                                  
   405                                  ;-98 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};
   406                                  
   407 0000005D 5055534841000160F1-     I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241
   408 00000066 504F5041000161F1   
   409                                  
   410                                  ;-99 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};
   411                                  
   412 0000006E 4E4F50000190F14342-     I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241
   413 00000077 57000198F1         
   414                                  
   415                                  ;-100 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};
   416                                  
   417 0000007C 43574445000198F143-     I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241
   418 00000085 5744000199F1       
   419                                  
   420                                  ;-101 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};
   421                                  
   422 0000008B 434451000199F15741-     I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241
   423 00000094 495400019BF1       
   424                                  
   425                                  ;-102 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};
   426                                  
   427 0000009A 505553484600019CF1-     I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241
   428 000000A3 504F504600019DF1   
   429                                  
   430                                  ;-103 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};
   431                                  
   432 000000AB 5341484600019EF14C-     I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241
   433 000000B4 41484600019FF1     
   434                                  
   435                                  ;-104 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};
   436                                  
   437 000000BB 4D4F5653420001A4F1-     I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241
   438 000000C4 4D4F5653570001A5F1 
   439                                  
   440                                  ;-105 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};
   441                                  
   442 000000CD 434D5053420001A6F1-     I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241
   443 000000D6 434D5053570001A7F1 
   444                                  
   445                                  ;-106 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};
   446                                  
   447 000000DF 53544F53420001AAF1-     I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241
   448 000000E8 53544F53570001ABF1 
   449                                  
   450                                  ;-107 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};
   451                                  
   452 000000F1 4C4F4453420001ACF1-     I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241
   453 000000FA 4C4F4453570001ADF1 
   454                                  
   455                                  ;-108 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};
   456                                  
   457 00000103 53434153420001AEF1-     I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241
   458 0000010C 53434153570001AFF1 
   459                                  
   460                                  ;-109 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};
   461                                  
   462 00000115 4C454156450001C9F1-     I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241
   463 0000011E 494E54330001CCF1   
   464                                  
   465                                  ;-110 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};
   466                                  
   467 00000126 494E544F0001CEF149-     I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241
   468 0000012F 5245540001CFF1     
   469                                  
   470                                  ;-111 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};
   471                                  
   472 00000136 584C41540001D7F14C-     I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241
   473 0000013F 4F434B0001F0F1     
   474                                  
   475                                  ;-112 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};
   476                                  
   477 00000146 5245504E450001F2F1-     I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241
   478 0000014F 5245504E5A0001F2F1 
   479                                  
   480                                  ;-113 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};
   481                                  
   482 00000158 524550450001F3F152-     I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241
   483 00000161 45505A0001F3F1     
   484                                  
   485                                  ;-114 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};
   486                                  
   487 00000168 484C540001F4F1434C-     I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241
   488 00000171 430001F8F1         
   489                                  
   490                                  ;-115 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};
   491                                  
   492 00000176 5354430001F9F1434C-     I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241
   493 0000017F 490001FAF1         
   494                                  
   495                                  ;-116 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};
   496                                  
   497 00000184 5354490001FBF1434C-     I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241
   498 0000018D 440001FCF1         
   499                                  
   500                                  ;-117 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};
   501                                  
   502 00000192 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   503                                  
   504                                  ;-118 // 2: mem reg 16 bit
   505                                  
   506                                  
   507                                  ;-119 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   508                                  
   509 00000199 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   510                                  
   511                                  ;-120 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   512                                  
   513 000001A2 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   514                                  
   515                                  ;-121 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   516                                  
   517 000001AB 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   518                                  
   519                                  ;-122 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   520                                  
   521 000001B3 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   522                                  
   523                                  ;-123 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   524                                  
   525 000001BB 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   526                                  
   527                                  ;-124 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   528                                  
   529 000001C3 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   530                                  
   531                                  ;-125 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   532                                  
   533 000001CC 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   534                                  
   535                                  ;-126 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   536                                  
   537 000001D4 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   538                                  
   539                                  ;-127 //  3: les, lda, lea, lss, lfs, lgs
   540                                  
   541                                  
   542                                  ;-128 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   543                                  
   544 000001DD 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   545                                  
   546                                  ;-129 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   547                                  
   548 000001E4 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   549                                  
   550                                  ;-130 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   551                                  
   552 000001EB 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   553                                  
   554                                  ;-131 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   555                                  
   556 000001F2 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   557                                  
   558                                  ;-132 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   559                                  
   560 000001FA 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   561                                  
   562                                  ;-133 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   563                                  
   564 00000202 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   565                                  
   566                                  ;-134 //  4: acc,imm  reg,imm  index,reg
   567                                  
   568                                  
   569                                  ;-135 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   570                                  
   571 0000020A 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   572                                  
   573                                  ;-136 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   574                                  
   575 00000211 4F52000401F1            I_OR db 79,82,0,4,1,241
   576                                  
   577                                  ;-137 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   578                                  
   579 00000217 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   580                                  
   581                                  ;-138 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   582                                  
   583 0000021E 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   584                                  
   585                                  ;-139 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   586                                  
   587 00000225 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   588                                  
   589                                  ;-140 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   590                                  
   591 0000022C 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   592                                  
   593                                  ;-141 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   594                                  
   595 00000233 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   596                                  
   597                                  ;-142 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   598                                  
   599 0000023A 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   600                                  
   601                                  ;-143 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   602                                  
   603 00000241 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   604 0000024A 00F1               
   605                                  
   606                                  ;-144 //  5: mov
   607                                  
   608                                  
   609                                  ;-145 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   610                                  
   611 0000024C 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   612                                  
   613                                  ;-146 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   614                                  
   615 00000252 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   616                                  
   617                                  ;-147 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   618                                  
   619 0000025B 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   620                                  
   621                                  ;-148 //  6: single byte relative jump
   622                                  
   623                                  
   624                                  ;-149 char I_JO []=  {'J','O',0,     6, 0,0xF1};
   625                                  
   626 00000264 4A4F000600F1            I_JO db 74,79,0,6,0,241
   627                                  
   628                                  ;-150 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
   629                                  
   630 0000026A 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   631                                  
   632                                  ;-151 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
   633                                  
   634 00000271 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
   635 0000027A 0602F1             
   636                                  
   637                                  ;-152 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
   638                                  
   639 0000027D 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   640                                  
   641                                  ;-153 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
   642                                  
   643 00000284 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
   644 0000028D 43000603F1         
   645                                  
   646                                  ;-154 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
   647                                  
   648 00000292 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
   649 0000029B 0604F1             
   650                                  
   651                                  ;-155 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
   652                                  
   653 0000029E 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
   654 000002A7 5A000605F1         
   655                                  
   656                                  ;-156 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
   657                                  
   658 000002AC 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
   659 000002B5 41000606F1         
   660                                  
   661                                  ;-157 char I_JA []=  {'J','A',0,     6, 7,0xF1};
   662                                  
   663 000002BA 4A41000607F1            I_JA db 74,65,0,6,7,241
   664                                  
   665                                  ;-158 char I_JS []=  {'J','S',0,     6, 8,0xF1};
   666                                  
   667 000002C0 4A53000608F1            I_JS db 74,83,0,6,8,241
   668                                  
   669                                  ;-159 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
   670                                  
   671 000002C6 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   672                                  
   673                                  ;-160 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
   674                                  
   675 000002CD 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
   676 000002D6 00060AF1           
   677                                  
   678                                  ;-161 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
   679                                  
   680 000002DA 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
   681 000002E3 4F00060BF1         
   682                                  
   683                                  ;-162 char I_JL []=  {'J','L',0,     6,12,0xF1};
   684                                  
   685 000002E8 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   686                                  
   687                                  ;-163 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
   688                                  
   689 000002EE 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
   690 000002F7 4500060DF1         
   691                                  
   692                                  ;-164 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
   693                                  
   694 000002FC 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
   695 00000305 4700060EF1         
   696                                  
   697                                  ;-165 char I_JG []=  {'J','G',0,     6,15,0xF1};
   698                                  
   699 0000030A 4A4700060FF1            I_JG db 74,71,0,6,15,241
   700                                  
   701                                  ;-166 //  7: jmp, call
   702                                  
   703                                  
   704                                  ;-167 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   705                                  
   706 00000310 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   707                                  
   708                                  ;-168 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   709                                  
   710 00000318 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   711                                  
   712                                  ;-169 //  8: ret
   713                                  
   714                                  
   715                                  ;-170 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   716                                  
   717 00000321 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   718                                  
   719                                  ;-171 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   720                                  
   721 00000329 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   722                                  
   723                                  ;-172 //  9: seg, r/m
   724                                  
   725                                  
   726                                  ;-173 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   727                                  
   728 00000332 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   729 0000033B 06F1               
   730                                  
   731                                  ;-174 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   732                                  
   733 0000033D 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   734 00000346 F1                 
   735                                  
   736                                  ;-175 //  11: shift, rotates
   737                                  
   738                                  
   739                                  ;-176 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
   740                                  
   741 00000347 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
   742 00000350 52000B01F1         
   743                                  
   744                                  ;-177 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
   745                                  
   746 00000355 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
   747 0000035E 52000B03F1         
   748                                  
   749                                  ;-178 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
   750                                  
   751 00000363 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
   752 0000036C 4C000B04F1         
   753                                  
   754                                  ;-179 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
   755                                  
   756 00000371 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
   757 0000037A 52000B07F1         
   758                                  
   759                                  ;-180 //  12: int
   760                                  
   761                                  
   762                                  ;-181 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   763                                  
   764 0000037F 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   765                                  
   766                                  ;-182 //  14: in/out
   767                                  
   768                                  
   769                                  ;-183 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   770                                  
   771 00000387 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   772                                  
   773                                  ;-184 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   774                                  
   775 0000038E 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   776                                  
   777                                  ;-185 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   778                                  
   779 00000396 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   780                                  
   781                                  ;-186 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   782                                  
   783 0000039E 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   784                                  
   785                                  ;-187 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   786                                  
   787 000003A6 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   788                                  
   789                                  ;-188 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   790                                  
   791 000003AE 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   792                                  
   793                                  ;-189 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   794                                  
   795 000003B6 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   796                                  
   797                                  ;-190 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   798                                  
   799 000003BE 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   800                                  
   801                                  ;-191 //  15: xchg
   802                                  
   803                                  
   804                                  ;-192 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   805                                  
   806 000003C6 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   807                                  
   808                                  ;-193 //  16: loop, jcxz
   809                                  
   810                                  
   811                                  ;-194 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   812                                  
   813 000003CF 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   814 000003D8 F1                 
   815                                  
   816                                  ;-195 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   817                                  
   818 000003D9 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   819 000003E2 F1                 
   820                                  
   821                                  ;-196 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   822                                  
   823 000003E3 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   824                                  
   825                                  ;-197 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   826                                  
   827 000003EC 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   828                                  
   829                                  ;-198 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   830                                  
   831 000003F5 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   832                                  
   833                                  ;-199 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   834                                  
   835 000003FD 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   836                                  
   837                                  ;-200 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   838                                  
   839 00000405 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   840                                  
   841                                  ;-201 //  30: enter
   842                                  
   843                                  
   844                                  ;-202 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
   845                                  
   846 0000040E 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   847                                  
   848                                  ;-203 // 100: directives
   849                                  
   850                                  
   851                                  ;-204 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   852                                  
   853 00000416 4F52470065F1            I_ORG db 79,82,71,0,101,241
   854                                  
   855                                  ;-205 // section, segment .TEXT .DATA .BSS
   856                                  
   857                                  
   858                                  ;-206 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   859                                  
   860 0000041C 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   861 00000425 F1                 
   862                                  
   863                                  ;-207 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   864                                  
   865 00000426 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   866 0000042F F1                 
   867                                  
   868                                  ;-208 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   869                                  
   870 00000430 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   871 00000439 6EF1               
   872                                  
   873                                  ;-209 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
   874                                  
   875 0000043B 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
   876                                  
   877                                  ;-210 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
   878                                  
   879 00000442 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
   880                                  
   881                                  ;-211 char I_DB[]=   {'D','B',0,            200,        0xF1};
   882                                  
   883 00000449 444200C8F1              I_DB db 68,66,0,200,241
   884                                  
   885                                  ;-212 char I_DW[]=   {'D','W',0,            201,        0xF1};
   886                                  
   887 0000044E 445700C9F1              I_DW db 68,87,0,201,241
   888                                  
   889                                  ;-213 char I_DD[]=   {'D','D',0,            202,        0xF1};
   890                                  
   891 00000453 444400CAF1              I_DD db 68,68,0,202,241
   892                                  
   893                                  ;-214 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   894                                  
   895 00000458 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   896                                  
   897                                  ;-215 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   898                                  
   899 0000045F 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   900                                  
   901                                  ;-216 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   902                                  
   903 00000466 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   904                                  
   905                                  ;-217 char I_END=0;// end of table char
   906                                  
   907 0000046D 00                      I_END db 0
   908                                  
   909                                  ;-218 
   910                                  
   911                                  
   912                                  ;-219 int lookCode() {//ret: CodeType, *OpCodePtr
   913                                  
   914                                  
   915                                  lookCode: PROC
   916                                  
   917                                  ;-220     CodeType=0;
   918                                  
   919 0000046E B80000                   mov ax, 0
   920 00000471 A2[2F00]                 mov byte [CodeType], al
   921                                  
   922                                  ;-221     OpCodePtr= &I_START;
   923                                  
   924 00000474 B8[5C00]                 mov ax, I_START
   925 00000477 A3[4300]                 mov word [OpCodePtr], ax
   926                                  
   927                                  ;-222     OpCodePtr++;
   928                                  
   929 0000047A FF06[4300]               inc  word[OpCodePtr]
   930                                  
   931                                  ;-223     do  {
   932                                  
   933                                  .lookCode1:
   934                                  
   935                                  ;-224         if (eqstr(SymbolUpper, OpCodePtr))  {
   936                                  
   937 0000047E FF36[4300]               push word [OpCodePtr]
   938 00000482 8D064F75                 lea  ax, [SymbolUpper]
   939 00000486 50                       push ax
   940 00000487 E8360E                   call eqstr
   941 0000048A 83C404                   add  sp, 4
   942 0000048D 08C0                     or  al, al
   943 0000048F 0F842700                 je .lookCode2
   944                                  
   945                                  ;-225             while(*OpCodePtr!=0) OpCodePtr++;
   946                                  
   947                                  .lookCode3:
   948 00000493 8B1E[4300]               mov bx, [OpCodePtr]
   949 00000497 8A07                     mov al, [bx]
   950 00000499 B400                     mov ah, 0
   951 0000049B 83F800                   cmp ax, 0
   952 0000049E 0F840600                 je  .lookCode4
   953 000004A2 FF06[4300]               inc  word[OpCodePtr]
   954                                  
   955                                  ;-226             OpCodePtr++;
   956                                  
   957 000004A6 EBEB                     jmp .lookCode3
   958                                  .lookCode4:
   959 000004A8 FF06[4300]               inc  word[OpCodePtr]
   960                                  
   961                                  ;-227             CodeType =*OpCodePtr;
   962                                  
   963 000004AC 8B1E[4300]               mov bx, [OpCodePtr]
   964 000004B0 8A07                     mov al, [bx]
   965 000004B2 B400                     mov ah, 0
   966 000004B4 A2[2F00]                 mov byte [CodeType], al
   967                                  
   968                                  ;-228             return;
   969                                  
   970 000004B7 E92A00                   jmp .retnlookCode
   971                                  
   972                                  ;-229         }
   973                                  
   974                                  
   975                                  ;-230     while(*OpCodePtr!=0xF1) OpCodePtr++;
   976                                  
   977                                  .lookCode2:
   978                                  .lookCode5:
   979 000004BA 8B1E[4300]               mov bx, [OpCodePtr]
   980 000004BE 8A07                     mov al, [bx]
   981 000004C0 B400                     mov ah, 0
   982 000004C2 3DF100                   cmp ax, 241
   983 000004C5 0F840600                 je  .lookCode6
   984 000004C9 FF06[4300]               inc  word[OpCodePtr]
   985                                  
   986                                  ;-231     OpCodePtr++;
   987                                  
   988 000004CD EBEB                     jmp .lookCode5
   989                                  .lookCode6:
   990 000004CF FF06[4300]               inc  word[OpCodePtr]
   991                                  
   992                                  ;-232     } while(*OpCodePtr!=0);
   993                                  
   994 000004D3 8B1E[4300]               mov bx, [OpCodePtr]
   995 000004D7 8A07                     mov al, [bx]
   996 000004D9 B400                     mov ah, 0
   997 000004DB 83F800                   cmp ax, 0
   998 000004DE 0F840200                 je  .lookCode7
   999 000004E2 EB9A                     jmp .lookCode1
  1000                                  .lookCode7:
  1001                                  
  1002                                  ;-233 }
  1003                                  
  1004                                  
  1005                                  ;-234 
  1006                                  
  1007                                  
  1008                                  ;-235 //#include "OPS.C"
  1009                                  
  1010                                  
  1011                                  ;-236 int ChangeDirection() {
  1012                                  
  1013                                   .retnlookCode:
  1014 000004E4 C3                       ret
  1015                                  ENDP
  1016                                  
  1017                                  ChangeDirection: PROC
  1018                                  
  1019                                  ;-237     char c;
  1020                                  
  1021                                  
  1022                                  ;-238     c=Op;     Op    =Op2;    Op2   =c;
  1023                                  
  1024                                  ;Function : ChangeDirection, Number of local variables: 1
  1025                                  ;   # type sign width addr used name   list of local variables
  1026                                  ;  200 var sign byte   237 NULL c = bp-2;
  1027 000004E5 C8020000                 ENTER  2,0
  1028 000004E9 A0[2D00]                 mov al, [Op]
  1029 000004EC 8846FE                   mov [bp-2], al
  1030 000004EF A0[2E00]                 mov al, [Op2]
  1031 000004F2 A2[2D00]                 mov byte [Op], al
  1032 000004F5 8A46FE                   mov al, [bp-2]
  1033 000004F8 A2[2E00]                 mov byte [Op2], al
  1034                                  
  1035                                  ;-239     c=R1Type; R1Type=R2Type; R2Type=c;
  1036                                  
  1037 000004FB A0[3600]                 mov al, [R1Type]
  1038 000004FE 8846FE                   mov [bp-2], al
  1039 00000501 A0[3500]                 mov al, [R2Type]
  1040 00000504 A2[3600]                 mov byte [R1Type], al
  1041 00000507 8A46FE                   mov al, [bp-2]
  1042 0000050A A2[3500]                 mov byte [R2Type], al
  1043                                  
  1044                                  ;-240     c=R1No;   R1No  =R2No;   R2No  =c;
  1045                                  
  1046 0000050D A0[3400]                 mov al, [R1No]
  1047 00000510 8846FE                   mov [bp-2], al
  1048 00000513 A0[3300]                 mov al, [R2No]
  1049 00000516 A2[3400]                 mov byte [R1No], al
  1050 00000519 8A46FE                   mov al, [bp-2]
  1051 0000051C A2[3300]                 mov byte [R2No], al
  1052                                  
  1053                                  ;-241     dflag=2;
  1054                                  
  1055 0000051F B80200                   mov ax, 2
  1056 00000522 A2[3900]                 mov byte [dflag], al
  1057                                  
  1058                                  ;-242 }
  1059                                  
  1060                                  
  1061                                  ;-243 
  1062                                  
  1063                                  
  1064                                  ;-244 int checkOpL() {
  1065 00000525 C9                       LEAVE
  1066 00000526 C3                       ret
  1067                                  ENDP
  1068                                  
  1069                                  checkOpL: PROC
  1070                                  
  1071                                  ;-245     if (Op == ADR) implerror();
  1072                                  
  1073 00000527 A0[2D00]                 mov al, [Op]
  1074 0000052A 3C03                     cmp al, 3
  1075 0000052C 0F850300                 jne .checkOpL8
  1076 00000530 E83E16                   call implerror
  1077                                  
  1078                                  ;-246     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  1079                                  
  1080                                  .checkOpL8:
  1081 00000533 A0[3600]                 mov al, [R1Type]
  1082 00000536 3C04                     cmp al, 4
  1083 00000538 0F850600                 jne .checkOpL9
  1084 0000053C E8FA16                   call segregerror
  1085 0000053F E93E00                   jmp .retncheckOpL
  1086                                  
  1087                                  ;-247     setwflag();
  1088                                  
  1089                                  .checkOpL9:
  1090 00000542 E87303                   call setwflag
  1091                                  
  1092                                  ;-248     if (OpSize == 0) error1("no op size declared");
  1093                                  
  1094 00000545 A0[3700]                 mov al, [OpSize]
  1095 00000548 3C00                     cmp al, 0
  1096 0000054A 0F850900                 jne .checkOpL10
  1097 0000054E 68[8105]                 push checkOpL_0
  1098 00000551 E83915                   call error1
  1099 00000554 83C402                   add  sp, 2
  1100                                  
  1101                                  ;-249     if (OpSize == R1Type) return;
  1102                                  
  1103                                  .checkOpL10:
  1104 00000557 A0[3700]                 mov al, [OpSize]
  1105 0000055A 3A06[3600]               cmp al, [R1Type]
  1106 0000055E 0F850300                 jne .checkOpL11
  1107 00000562 E91B00                   jmp .retncheckOpL
  1108                                  
  1109                                  ;-250     if (Op == REG) if (R1Type==0) error1("no register defined");
  1110                                  
  1111                                  .checkOpL11:
  1112 00000565 A0[2D00]                 mov al, [Op]
  1113 00000568 3C02                     cmp al, 2
  1114 0000056A 0F851200                 jne .checkOpL12
  1115 0000056E A0[3600]                 mov al, [R1Type]
  1116 00000571 3C00                     cmp al, 0
  1117 00000573 0F850900                 jne .checkOpL13
  1118 00000577 68[9505]                 push checkOpL_1
  1119 0000057A E81015                   call error1
  1120 0000057D 83C402                   add  sp, 2
  1121                                  
  1122                                  ;-251 }
  1123                                  
  1124                                  .checkOpL13:
  1125                                  .checkOpL12:
  1126                                  
  1127                                  ;-252 
  1128                                  
  1129                                  
  1130                                  ;-253 int check2Ops() {
  1131                                  
  1132                                   .retncheckOpL:
  1133 00000580 C3                       ret
  1134 00000581 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1135 0000058A 65206465636C617265-
  1136 00000593 6400               
  1137 00000595 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1138 0000059E 657220646566696E65-
  1139 000005A7 6400               
  1140                                  ENDP
  1141                                  
  1142                                  check2Ops: PROC
  1143                                  
  1144                                  ;-254     get2Ops();
  1145                                  
  1146 000005A9 E84900                   call get2Ops
  1147                                  
  1148                                  ;-255     if (Op ==   0) addrerror();
  1149                                  
  1150 000005AC A0[2D00]                 mov al, [Op]
  1151 000005AF 3C00                     cmp al, 0
  1152 000005B1 0F850300                 jne .check2Ops14
  1153 000005B5 E87A15                   call addrerror
  1154                                  
  1155                                  ;-256     if (Op == ADR) invaloperror();
  1156                                  
  1157                                  .check2Ops14:
  1158 000005B8 A0[2D00]                 mov al, [Op]
  1159 000005BB 3C03                     cmp al, 3
  1160 000005BD 0F850300                 jne .check2Ops15
  1161 000005C1 E8E815                   call invaloperror
  1162                                  
  1163                                  ;-257     if (Op == IMM) immeerror();
  1164                                  
  1165                                  .check2Ops15:
  1166 000005C4 A0[2D00]                 mov al, [Op]
  1167 000005C7 3C01                     cmp al, 1
  1168 000005C9 0F850300                 jne .check2Ops16
  1169 000005CD E87C15                   call immeerror
  1170                                  
  1171                                  ;-258     if (Op2==   0) addrerror();
  1172                                  
  1173                                  .check2Ops16:
  1174 000005D0 A0[2E00]                 mov al, [Op2]
  1175 000005D3 3C00                     cmp al, 0
  1176 000005D5 0F850300                 jne .check2Ops17
  1177 000005D9 E85615                   call addrerror
  1178                                  
  1179                                  ;-259     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov
  1180                                  
  1181                                  .check2Ops17:
  1182 000005DC A0[2F00]                 mov al, [CodeType]
  1183 000005DF 3C05                     cmp al, 5
  1184 000005E1 0F840C00                 je  .check2Ops18
  1185 000005E5 A0[2E00]                 mov al, [Op2]
  1186 000005E8 3C03                     cmp al, 3
  1187 000005EA 0F850300                 jne .check2Ops19
  1188 000005EE E8BB15                   call invaloperror
  1189                                  
  1190                                  ;-260     setwflag();
  1191                                  
  1192                                  .check2Ops19:
  1193                                  .check2Ops18:
  1194 000005F1 E8C402                   call setwflag
  1195                                  
  1196                                  ;-261 }
  1197                                  
  1198                                  
  1199                                  ;-262 int get2Ops() {
  1200                                  
  1201 000005F4 C3                       ret
  1202                                  ENDP
  1203                                  
  1204                                  get2Ops: PROC
  1205                                  
  1206                                  ;-263     getOpL();
  1207                                  
  1208 000005F5 E80C00                   call getOpL
  1209                                  
  1210                                  ;-264     need(',');
  1211                                  
  1212 000005F8 6A2C                     push 44
  1213 000005FA E80D09                   call need
  1214 000005FD 83C402                   add  sp, 2
  1215                                  
  1216                                  ;-265     getOpR();
  1217                                  
  1218 00000600 E82900                   call getOpR
  1219                                  
  1220                                  ;-266 }
  1221                                  
  1222                                  
  1223                                  ;-267 
  1224                                  
  1225                                  
  1226                                  ;-268 int getOpL() {
  1227                                  
  1228 00000603 C3                       ret
  1229                                  ENDP
  1230                                  
  1231                                  getOpL: PROC
  1232                                  
  1233                                  ;-269 //set: op=0,IMM,REG,ADR,MEM
  1234                                  
  1235                                  
  1236                                  ;-270     getOpR();
  1237                                  
  1238 00000604 E82500                   call getOpR
  1239                                  
  1240                                  ;-271     Op=Op2;         Op2=0;
  1241                                  
  1242 00000607 A0[2E00]                 mov al, [Op2]
  1243 0000060A A2[2D00]                 mov byte [Op], al
  1244 0000060D B80000                   mov ax, 0
  1245 00000610 A2[2E00]                 mov byte [Op2], al
  1246                                  
  1247                                  ;-272     R1No=R2No;      R2No=0;
  1248                                  
  1249 00000613 A0[3300]                 mov al, [R2No]
  1250 00000616 A2[3400]                 mov byte [R1No], al
  1251 00000619 B80000                   mov ax, 0
  1252 0000061C A2[3300]                 mov byte [R2No], al
  1253                                  
  1254                                  ;-273     R1Type=R2Type; R2Type=0;
  1255                                  
  1256 0000061F A0[3500]                 mov al, [R2Type]
  1257 00000622 A2[3600]                 mov byte [R1Type], al
  1258 00000625 B80000                   mov ax, 0
  1259 00000628 A2[3500]                 mov byte [R2Type], al
  1260                                  
  1261                                  ;-274 }
  1262                                  
  1263                                  
  1264                                  ;-275 
  1265                                  
  1266                                  
  1267                                  ;-276 int getOpR() {
  1268                                  
  1269 0000062B C3                       ret
  1270                                  ENDP
  1271                                  
  1272                                  getOpR: PROC
  1273                                  
  1274                                  ;-277     Op2=getOp1();
  1275                                  
  1276 0000062C E88600                   call getOp1
  1277 0000062F A2[2E00]                 mov byte [Op2], al
  1278                                  
  1279                                  ;-278     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1280                                  
  1281 00000632 6A5B                     push 91
  1282 00000634 E8AB08                   call isToken
  1283 00000637 83C402                   add  sp, 2
  1284 0000063A 08C0                     or  al, al
  1285 0000063C 0F840C00                 je .getOpR20
  1286 00000640 B80400                   mov ax, 4
  1287 00000643 A2[2E00]                 mov byte [Op2], al
  1288 00000646 E8BB00                   call getMEM
  1289 00000649 E94F00                   jmp .retngetOpR
  1290                                  
  1291                                  ;-279     if (Op2 == 0)     {invaloperror();         return;}
  1292                                  
  1293                                  .getOpR20:
  1294 0000064C A0[2E00]                 mov al, [Op2]
  1295 0000064F 3C00                     cmp al, 0
  1296 00000651 0F850600                 jne .getOpR21
  1297 00000655 E85415                   call invaloperror
  1298 00000658 E94000                   jmp .retngetOpR
  1299                                  
  1300                                  ;-280     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1301                                  
  1302                                  .getOpR21:
  1303 0000065B A0[2E00]                 mov al, [Op2]
  1304 0000065E 3C01                     cmp al, 1
  1305 00000660 0F850900                 jne .getOpR22
  1306 00000664 A1[0E00]                 mov ax, [SymbolInt]
  1307 00000667 A3[3F00]                 mov word [imme], ax
  1308 0000066A E92E00                   jmp .retngetOpR
  1309                                  
  1310                                  ;-281     if (Op2 == REG)                            return;
  1311                                  
  1312                                  .getOpR22:
  1313 0000066D A0[2E00]                 mov al, [Op2]
  1314 00000670 3C02                     cmp al, 2
  1315 00000672 0F850300                 jne .getOpR23
  1316 00000676 E92200                   jmp .retngetOpR
  1317                                  
  1318                                  ;-282     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1319                                  
  1320                                  .getOpR23:
  1321 00000679 A0[2E00]                 mov al, [Op2]
  1322 0000067C 3C03                     cmp al, 3
  1323 0000067E 0F851000                 jne .getOpR24
  1324 00000682 8B1E[4E00]               mov bx, [LabelIx]
  1325 00000686 D1E3                     shl bx, 1
  1326 00000688 8B87FA86                 mov ax, [LabelAddr + bx]
  1327 0000068C A3[3D00]                 mov word [disp], ax
  1328 0000068F E90900                   jmp .retngetOpR
  1329                                  
  1330                                  ;-283     error1("Name of operand expected");
  1331                                  
  1332                                  .getOpR24:
  1333 00000692 68[9C06]                 push getOpR_0
  1334 00000695 E8F513                   call error1
  1335 00000698 83C402                   add  sp, 2
  1336                                  
  1337                                  ;-284 }
  1338                                  
  1339                                  
  1340                                  ;-285 
  1341                                  
  1342                                  
  1343                                  ;-286 int getOp1() {//scan for a single operand
  1344                                  
  1345                                   .retngetOpR:
  1346 0000069B C3                       ret
  1347 0000069C 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1348 000006A5 706572616E64206578-
  1349 000006AE 70656374656400     
  1350                                  ENDP
  1351                                  
  1352                                  getOp1: PROC
  1353                                  
  1354                                  ;-287 //return:0, IMM, REG, ADR (not MEM)
  1355                                  
  1356                                  
  1357                                  ;-288 //set   :R2Type, R2No by testReg
  1358                                  
  1359                                  
  1360                                  ;-289 //set   :LabelIx by searchLabel
  1361                                  
  1362                                  
  1363                                  ;-290     if (TokeType == 0)      return 0;
  1364                                  
  1365 000006B5 A0[2C00]                 mov al, [TokeType]
  1366 000006B8 3C00                     cmp al, 0
  1367 000006BA 0F850600                 jne .getOp125
  1368 000006BE B80000                   mov ax, 0
  1369 000006C1 E93F00                   jmp .retngetOp1
  1370                                  
  1371                                  ;-291     if (TokeType == DIGIT)  return IMM;
  1372                                  
  1373                                  .getOp125:
  1374 000006C4 A0[2C00]                 mov al, [TokeType]
  1375 000006C7 3C01                     cmp al, 1
  1376 000006C9 0F850600                 jne .getOp126
  1377 000006CD B80100                   mov ax, 1
  1378 000006D0 E93000                   jmp .retngetOp1
  1379                                  
  1380                                  ;-292     if (TokeType == ALNUME) {
  1381                                  
  1382                                  .getOp126:
  1383 000006D3 A0[2C00]                 mov al, [TokeType]
  1384 000006D6 3C03                     cmp al, 3
  1385 000006D8 0F852100                 jne .getOp127
  1386                                  
  1387                                  ;-293         R2No=testReg();
  1388                                  
  1389 000006DC E8940D                   call testReg
  1390 000006DF A2[3300]                 mov byte [R2No], al
  1391                                  
  1392                                  ;-294         if (R2Type)        return REG;
  1393                                  
  1394 000006E2 A0[3500]                 mov al, [R2Type]
  1395 000006E5 08C0                     or  al, al
  1396 000006E7 0F840600                 je .getOp128
  1397 000006EB B80200                   mov ax, 2
  1398 000006EE E91200                   jmp .retngetOp1
  1399                                  
  1400                                  ;-295         LabelIx=searchLabel();
  1401                                  
  1402                                  .getOp128:
  1403 000006F1 E88A05                   call searchLabel
  1404 000006F4 A3[4E00]                 mov word [LabelIx], ax
  1405                                  
  1406                                  ;-296         return ADR;
  1407                                  
  1408 000006F7 B80300                   mov ax, 3
  1409 000006FA E90600                   jmp .retngetOp1
  1410                                  
  1411                                  ;-297 //        if (LabelIx)        return ADR;
  1412                                  
  1413                                  
  1414                                  ;-298 //        else error1("variable not found");
  1415                                  
  1416                                  
  1417                                  ;-299     }
  1418                                  
  1419                                  
  1420                                  ;-300     return 0;
  1421                                  
  1422                                  .getOp127:
  1423 000006FD B80000                   mov ax, 0
  1424 00000700 E90000                   jmp .retngetOp1
  1425                                  
  1426                                  ;-301 }
  1427                                  
  1428                                  
  1429                                  ;-302 
  1430                                  
  1431                                  
  1432                                  ;-303 int getMEM() {// e.g. [array+bp+si-4]
  1433                                  
  1434                                   .retngetOp1:
  1435 00000703 C3                       ret
  1436                                  ENDP
  1437                                  
  1438                                  getMEM: PROC
  1439                                  
  1440                                  ;-304 //set: disp, rm, R2Type
  1441                                  
  1442                                  
  1443                                  ;-305     char c;
  1444                                  
  1445                                  
  1446                                  ;-306     disp=0; rm=0;
  1447                                  
  1448                                  ;Function : getMEM, Number of local variables: 1
  1449                                  ;   # type sign width addr used name   list of local variables
  1450                                  ;  200 var sign byte   305 NULL c = bp-2;
  1451 00000704 C8020000                 ENTER  2,0
  1452 00000708 B80000                   mov ax, 0
  1453 0000070B A3[3D00]                 mov word [disp], ax
  1454 0000070E B80000                   mov ax, 0
  1455 00000711 A2[3B00]                 mov byte [rm], al
  1456                                  
  1457                                  ;-307     do {
  1458                                  
  1459                                  .getMEM29:
  1460                                  
  1461                                  ;-308         getTokeType();
  1462                                  
  1463 00000714 E8AF03                   call getTokeType
  1464                                  
  1465                                  ;-309         c=getOp1();
  1466                                  
  1467 00000717 E89BFF                   call getOp1
  1468 0000071A 8846FE                   mov [bp-2], al
  1469                                  
  1470                                  ;-310         if (c ==   0) syntaxerror();
  1471                                  
  1472 0000071D 8A46FE                   mov al, [bp-2]
  1473 00000720 3C00                     cmp al, 0
  1474 00000722 0F850300                 jne .getMEM30
  1475 00000726 E83715                   call syntaxerror
  1476                                  
  1477                                  ;-311         if (c == REG) {
  1478                                  
  1479                                  .getMEM30:
  1480 00000729 8A46FE                   mov al, [bp-2]
  1481 0000072C 3C02                     cmp al, 2
  1482 0000072E 0F851B00                 jne .getMEM31
  1483                                  
  1484                                  ;-312             isDirect=0;
  1485                                  
  1486 00000732 B80000                   mov ax, 0
  1487 00000735 A2[3C00]                 mov byte [isDirect], al
  1488                                  
  1489                                  ;-313             if (rm) rm=getIndReg2();
  1490                                  
  1491 00000738 A0[3B00]                 mov al, [rm]
  1492 0000073B 08C0                     or  al, al
  1493 0000073D 0F840900                 je .getMEM32
  1494 00000741 E8F600                   call getIndReg2
  1495 00000744 A2[3B00]                 mov byte [rm], al
  1496                                  
  1497                                  ;-314             else getIndReg1();
  1498                                  
  1499 00000747 E90300                   jmp .getMEM33
  1500                                  .getMEM32:
  1501 0000074A E89800                   call getIndReg1
  1502                                  
  1503                                  ;-315         }
  1504                                  
  1505                                  .getMEM33:
  1506                                  
  1507                                  ;-316         if (c == ADR) {
  1508                                  
  1509                                  .getMEM31:
  1510 0000074D 8A46FE                   mov al, [bp-2]
  1511 00000750 3C03                     cmp al, 3
  1512 00000752 0F851F00                 jne .getMEM34
  1513                                  
  1514                                  ;-317             if (LabelIx)    disp=disp+LabelAddr[LabelIx];
  1515                                  
  1516 00000756 A1[4E00]                 mov ax, [LabelIx]
  1517 00000759 08C0                     or  al, al
  1518 0000075B 0F841300                 je .getMEM35
  1519 0000075F A1[3D00]                 mov ax, [disp]
  1520 00000762 8B1E[4E00]               mov bx, [LabelIx]
  1521 00000766 D1E3                     shl bx, 1
  1522 00000768 0387FA86                 add ax, [LabelAddr + bx]
  1523 0000076C A3[3D00]                 mov word [disp], ax
  1524                                  
  1525                                  ;-318             else notfounderror();
  1526                                  
  1527 0000076F E90300                   jmp .getMEM36
  1528                                  .getMEM35:
  1529 00000772 E88813                   call notfounderror
  1530                                  
  1531                                  ;-319         }
  1532                                  
  1533                                  .getMEM36:
  1534                                  
  1535                                  ;-320         if (c == IMM) disp=disp+SymbolInt;
  1536                                  
  1537                                  .getMEM34:
  1538 00000775 8A46FE                   mov al, [bp-2]
  1539 00000778 3C01                     cmp al, 1
  1540 0000077A 0F850A00                 jne .getMEM37
  1541 0000077E A1[3D00]                 mov ax, [disp]
  1542 00000781 0306[0E00]               add ax, [SymbolInt]
  1543 00000785 A3[3D00]                 mov word [disp], ax
  1544                                  
  1545                                  ;-321         if (isToken('-')) {
  1546                                  
  1547                                  .getMEM37:
  1548 00000788 6A2D                     push 45
  1549 0000078A E85507                   call isToken
  1550 0000078D 83C402                   add  sp, 2
  1551 00000790 08C0                     or  al, al
  1552 00000792 0F841900                 je .getMEM38
  1553                                  
  1554                                  ;-322             getTokeType();
  1555                                  
  1556 00000796 E82D03                   call getTokeType
  1557                                  
  1558                                  ;-323             if (TokeType != DIGIT) numbererror();
  1559                                  
  1560 00000799 A0[2C00]                 mov al, [TokeType]
  1561 0000079C 3C01                     cmp al, 1
  1562 0000079E 0F840300                 je  .getMEM39
  1563 000007A2 E82814                   call numbererror
  1564                                  
  1565                                  ;-324             disp = disp - SymbolInt;
  1566                                  
  1567                                  .getMEM39:
  1568 000007A5 A1[3D00]                 mov ax, [disp]
  1569 000007A8 2B06[0E00]               sub ax, [SymbolInt]
  1570 000007AC A3[3D00]                 mov word [disp], ax
  1571                                  
  1572                                  ;-325         }
  1573                                  
  1574                                  
  1575                                  ;-326     } while (isToken('+'));
  1576                                  
  1577                                  .getMEM38:
  1578 000007AF 6A2B                     push 43
  1579 000007B1 E82E07                   call isToken
  1580 000007B4 83C402                   add  sp, 2
  1581 000007B7 08C0                     or  al, al
  1582 000007B9 0F840300                 je .getMEM40
  1583 000007BD E954FF                   jmp .getMEM29
  1584                                  .getMEM40:
  1585                                  
  1586                                  ;-327     if (isToken(']') == 0) errorexit("] expected");
  1587                                  
  1588 000007C0 6A5D                     push 93
  1589 000007C2 E81D07                   call isToken
  1590 000007C5 83C402                   add  sp, 2
  1591 000007C8 83F800                   cmp ax, 0
  1592 000007CB 0F850900                 jne .getMEM41
  1593 000007CF 68[DA07]                 push getMEM_0
  1594 000007D2 E80E13                   call errorexit
  1595 000007D5 83C402                   add  sp, 2
  1596                                  
  1597                                  ;-328 }
  1598                                  
  1599                                  .getMEM41:
  1600                                  
  1601                                  ;-329 int getIndReg1() {
  1602 000007D8 C9                       LEAVE
  1603 000007D9 C3                       ret
  1604 000007DA 5D2065787065637465-     getMEM_0 db "] expected",0
  1605 000007E3 6400               
  1606                                  ENDP
  1607                                  
  1608                                  getIndReg1: PROC
  1609                                  
  1610                                  ;-330     if (R2Type !=WORD) indexerror();
  1611                                  
  1612 000007E5 A0[3500]                 mov al, [R2Type]
  1613 000007E8 3C02                     cmp al, 2
  1614 000007EA 0F840300                 je  .getIndReg142
  1615 000007EE E89A13                   call indexerror
  1616                                  
  1617                                  ;-331     if (R2No==3) rm=7;//BX
  1618                                  
  1619                                  .getIndReg142:
  1620 000007F1 A0[3300]                 mov al, [R2No]
  1621 000007F4 3C03                     cmp al, 3
  1622 000007F6 0F850600                 jne .getIndReg143
  1623 000007FA B80700                   mov ax, 7
  1624 000007FD A2[3B00]                 mov byte [rm], al
  1625                                  
  1626                                  ;-332     if (R2No==5) rm=6;//BP, change to BP+0
  1627                                  
  1628                                  .getIndReg143:
  1629 00000800 A0[3300]                 mov al, [R2No]
  1630 00000803 3C05                     cmp al, 5
  1631 00000805 0F850600                 jne .getIndReg144
  1632 00000809 B80600                   mov ax, 6
  1633 0000080C A2[3B00]                 mov byte [rm], al
  1634                                  
  1635                                  ;-333     if (R2No==7) rm=5;//DI
  1636                                  
  1637                                  .getIndReg144:
  1638 0000080F A0[3300]                 mov al, [R2No]
  1639 00000812 3C07                     cmp al, 7
  1640 00000814 0F850600                 jne .getIndReg145
  1641 00000818 B80500                   mov ax, 5
  1642 0000081B A2[3B00]                 mov byte [rm], al
  1643                                  
  1644                                  ;-334     if (R2No==6) rm=4;//SI
  1645                                  
  1646                                  .getIndReg145:
  1647 0000081E A0[3300]                 mov al, [R2No]
  1648 00000821 3C06                     cmp al, 6
  1649 00000823 0F850600                 jne .getIndReg146
  1650 00000827 B80400                   mov ax, 4
  1651 0000082A A2[3B00]                 mov byte [rm], al
  1652                                  
  1653                                  ;-335     if (rm==0) indexerror();
  1654                                  
  1655                                  .getIndReg146:
  1656 0000082D A0[3B00]                 mov al, [rm]
  1657 00000830 3C00                     cmp al, 0
  1658 00000832 0F850300                 jne .getIndReg147
  1659 00000836 E85213                   call indexerror
  1660                                  
  1661                                  ;-336 }
  1662                                  
  1663                                  .getIndReg147:
  1664                                  
  1665                                  ;-337 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1666                                  
  1667 00000839 C3                       ret
  1668                                  ENDP
  1669                                  
  1670                                  getIndReg2: PROC
  1671                                  ;Function : getIndReg2, Number of local variables: 1
  1672                                  ;   # type sign width addr used name   list of local variables
  1673                                  ;  200 var sign byte   337 NULL m = bp-2;
  1674 0000083A C8020000                 ENTER  2,0
  1675 0000083E B80400                   mov ax, 4
  1676 00000841 8846FE                   mov [bp-2], al
  1677                                  
  1678                                  ;-338     if (R2Type !=WORD) indexerror();
  1679                                  
  1680 00000844 A0[3500]                 mov al, [R2Type]
  1681 00000847 3C02                     cmp al, 2
  1682 00000849 0F840300                 je  .getIndReg248
  1683 0000084D E83B13                   call indexerror
  1684                                  
  1685                                  ;-339     if (R2No==7) if (rm==6) m=3;//BP+DI
  1686                                  
  1687                                  .getIndReg248:
  1688 00000850 A0[3300]                 mov al, [R2No]
  1689 00000853 3C07                     cmp al, 7
  1690 00000855 0F852100                 jne .getIndReg249
  1691 00000859 A0[3B00]                 mov al, [rm]
  1692 0000085C 3C06                     cmp al, 6
  1693 0000085E 0F850900                 jne .getIndReg250
  1694 00000862 B80300                   mov ax, 3
  1695 00000865 8846FE                   mov [bp-2], al
  1696                                  
  1697                                  ;-340              else if (rm==7) m=1;//BX+DI
  1698                                  
  1699 00000868 E90F00                   jmp .getIndReg251
  1700                                  .getIndReg250:
  1701 0000086B A0[3B00]                 mov al, [rm]
  1702 0000086E 3C07                     cmp al, 7
  1703 00000870 0F850600                 jne .getIndReg252
  1704 00000874 B80100                   mov ax, 1
  1705 00000877 8846FE                   mov [bp-2], al
  1706                                  
  1707                                  ;-341     if (R2No==6) if (rm==6) m=2;//BP+SI
  1708                                  
  1709                                  .getIndReg252:
  1710                                  .getIndReg251:
  1711                                  .getIndReg249:
  1712 0000087A A0[3300]                 mov al, [R2No]
  1713 0000087D 3C06                     cmp al, 6
  1714 0000087F 0F852100                 jne .getIndReg253
  1715 00000883 A0[3B00]                 mov al, [rm]
  1716 00000886 3C06                     cmp al, 6
  1717 00000888 0F850900                 jne .getIndReg254
  1718 0000088C B80200                   mov ax, 2
  1719 0000088F 8846FE                   mov [bp-2], al
  1720                                  
  1721                                  ;-342              else if (rm==7) m=0;//BX+SI
  1722                                  
  1723 00000892 E90F00                   jmp .getIndReg255
  1724                                  .getIndReg254:
  1725 00000895 A0[3B00]                 mov al, [rm]
  1726 00000898 3C07                     cmp al, 7
  1727 0000089A 0F850600                 jne .getIndReg256
  1728 0000089E B80000                   mov ax, 0
  1729 000008A1 8846FE                   mov [bp-2], al
  1730                                  
  1731                                  ;-343     if (m > 3) indexerror();
  1732                                  
  1733                                  .getIndReg256:
  1734                                  .getIndReg255:
  1735                                  .getIndReg253:
  1736 000008A4 8A46FE                   mov al, [bp-2]
  1737 000008A7 3C03                     cmp al, 3
  1738 000008A9 0F8E0300                 jle .getIndReg257
  1739 000008AD E8DB12                   call indexerror
  1740                                  
  1741                                  ;-344     return m;
  1742                                  
  1743                                  .getIndReg257:
  1744 000008B0 8A46FE                   mov al, [bp-2]
  1745 000008B3 E90000                   jmp .retngetIndReg2
  1746                                  
  1747                                  ;-345 }
  1748                                  
  1749                                  
  1750                                  ;-346 
  1751                                  
  1752                                  
  1753                                  ;-347 int setwflag() {//word size, bit 0
  1754                                  
  1755 000008B6 C9                       .retngetIndReg2: LEAVE
  1756 000008B7 C3                       ret
  1757                                  ENDP
  1758                                  
  1759                                  setwflag: PROC
  1760                                  
  1761                                  ;-348     wflag=0;
  1762                                  
  1763 000008B8 B80000                   mov ax, 0
  1764 000008BB A2[3800]                 mov byte [wflag], al
  1765                                  
  1766                                  ;-349     if (OpSize == 0) {//do not override OpSize
  1767                                  
  1768 000008BE A0[3700]                 mov al, [OpSize]
  1769 000008C1 3C00                     cmp al, 0
  1770 000008C3 0F853C00                 jne .setwflag58
  1771                                  
  1772                                  ;-350         if (Op == REG) OpSize=R1Type;
  1773                                  
  1774 000008C7 A0[2D00]                 mov al, [Op]
  1775 000008CA 3C02                     cmp al, 2
  1776 000008CC 0F850600                 jne .setwflag59
  1777 000008D0 A0[3600]                 mov al, [R1Type]
  1778 000008D3 A2[3700]                 mov byte [OpSize], al
  1779                                  
  1780                                  ;-351         if (Op2== REG) OpSize=R2Type;
  1781                                  
  1782                                  .setwflag59:
  1783 000008D6 A0[2E00]                 mov al, [Op2]
  1784 000008D9 3C02                     cmp al, 2
  1785 000008DB 0F850600                 jne .setwflag60
  1786 000008DF A0[3500]                 mov al, [R2Type]
  1787 000008E2 A2[3700]                 mov byte [OpSize], al
  1788                                  
  1789                                  ;-352         if (R2Type== SEGREG) OpSize=WORD;
  1790                                  
  1791                                  .setwflag60:
  1792 000008E5 A0[3500]                 mov al, [R2Type]
  1793 000008E8 3C04                     cmp al, 4
  1794 000008EA 0F850600                 jne .setwflag61
  1795 000008EE B80200                   mov ax, 2
  1796 000008F1 A2[3700]                 mov byte [OpSize], al
  1797                                  
  1798                                  ;-353         if (R1Type == SEGREG) OpSize=WORD;
  1799                                  
  1800                                  .setwflag61:
  1801 000008F4 A0[3600]                 mov al, [R1Type]
  1802 000008F7 3C04                     cmp al, 4
  1803 000008F9 0F850600                 jne .setwflag62
  1804 000008FD B80200                   mov ax, 2
  1805 00000900 A2[3700]                 mov byte [OpSize], al
  1806                                  
  1807                                  ;-354     }
  1808                                  
  1809                                  .setwflag62:
  1810                                  
  1811                                  ;-355     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1812                                  
  1813                                  .setwflag58:
  1814 00000903 A0[3700]                 mov al, [OpSize]
  1815 00000906 3C03                     cmp al, 3
  1816 00000908 0F850900                 jne .setwflag63
  1817 0000090C E85618                   call gen66h
  1818 0000090F B80100                   mov ax, 1
  1819 00000912 A2[3800]                 mov byte [wflag], al
  1820                                  
  1821                                  ;-356     if (OpSize  ==  WORD) wflag=1;
  1822                                  
  1823                                  .setwflag63:
  1824 00000915 A0[3700]                 mov al, [OpSize]
  1825 00000918 3C02                     cmp al, 2
  1826 0000091A 0F850600                 jne .setwflag64
  1827 0000091E B80100                   mov ax, 1
  1828 00000921 A2[3800]                 mov byte [wflag], al
  1829                                  
  1830                                  ;-357 }
  1831                                  
  1832                                  .setwflag64:
  1833                                  
  1834                                  ;-358 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  1835                                  
  1836 00000924 C3                       ret
  1837                                  ENDP
  1838                                  
  1839                                  setsflag: PROC
  1840                                  
  1841                                  ;-359     unsigned int ui;
  1842                                  
  1843                                  
  1844                                  ;-360     sflag=2;
  1845                                  
  1846                                  ;Function : setsflag, Number of local variables: 1
  1847                                  ;   # type sign width addr used name   list of local variables
  1848                                  ;  200 var unsg word   359 NULL ui = bp-2;
  1849 00000925 C8020000                 ENTER  2,0
  1850 00000929 B80200                   mov ax, 2
  1851 0000092C A2[3A00]                 mov byte [sflag], al
  1852                                  
  1853                                  ;-361     ui = imme & 0xFF80;//is greater than signed 127?
  1854                                  
  1855 0000092F A1[3F00]                 mov ax, [imme]
  1856 00000932 2580FF                   and ax, 65408
  1857 00000935 8946FE                   mov [bp-2], ax
  1858                                  
  1859                                  ;-362     if(ui != 0) sflag = 0;
  1860                                  
  1861 00000938 8B46FE                   mov ax, [bp-2]
  1862 0000093B 83F800                   cmp ax, 0
  1863 0000093E 0F840600                 je  .setsflag65
  1864 00000942 B80000                   mov ax, 0
  1865 00000945 A2[3A00]                 mov byte [sflag], al
  1866                                  
  1867                                  ;-363     if (OpSize == BYTE) {
  1868                                  
  1869                                  .setsflag65:
  1870 00000948 A0[3700]                 mov al, [OpSize]
  1871 0000094B 3C01                     cmp al, 1
  1872 0000094D 0F851900                 jne .setsflag66
  1873                                  
  1874                                  ;-364         if (imme > 255) error1("too big for byte r/m");
  1875                                  
  1876 00000951 A1[3F00]                 mov ax, [imme]
  1877 00000954 3DFF00                   cmp ax, 255
  1878 00000957 0F8E0900                 jle .setsflag67
  1879 0000095B 68[6C09]                 push setsflag_0
  1880 0000095E E82C11                   call error1
  1881 00000961 83C402                   add  sp, 2
  1882                                  
  1883                                  ;-365         sflag=0;//byte reg does not need sign extended
  1884                                  
  1885                                  .setsflag67:
  1886 00000964 B80000                   mov ax, 0
  1887 00000967 A2[3A00]                 mov byte [sflag], al
  1888                                  
  1889                                  ;-366     }
  1890                                  
  1891                                  
  1892                                  ;-367 }
  1893                                  
  1894                                  .setsflag66:
  1895                                  
  1896                                  ;-368 int checkConstSize(unsigned int ui) {
  1897 0000096A C9                       LEAVE
  1898 0000096B C3                       ret
  1899 0000096C 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1900 00000975 6F7220627974652072-
  1901 0000097E 2F6D00             
  1902                                  ENDP
  1903                                  
  1904                                  checkConstSize: PROC
  1905                                  
  1906                                  ;-369     if (ui > 127   ) return 0;//is near; return sflag
  1907                                  
  1908                                  ;Function : checkConstSize, Number of local variables: 1
  1909                                  ;   # type sign width addr used name   list of local variables
  1910                                  ;  200 var unsg word   368 NULL ui = bp+4;
  1911 00000981 C8000000                 ENTER  0,0
  1912 00000985 8B4604                   mov ax, [bp+4]
  1913 00000988 83F87F                   cmp ax, 127
  1914 0000098B 0F8E0600                 jle .checkConstSize68
  1915 0000098F B80000                   mov ax, 0
  1916 00000992 E91600                   jmp .retncheckConstSize
  1917                                  
  1918                                  ;-370     if (ui < 0xFF80) return 0;//-128dez
  1919                                  
  1920                                  .checkConstSize68:
  1921 00000995 8B4604                   mov ax, [bp+4]
  1922 00000998 3D80FF                   cmp ax, 65408
  1923 0000099B 0F8D0600                 jge .checkConstSize69
  1924 0000099F B80000                   mov ax, 0
  1925 000009A2 E90600                   jmp .retncheckConstSize
  1926                                  
  1927                                  ;-371     return 2;// is short
  1928                                  
  1929                                  .checkConstSize69:
  1930 000009A5 B80200                   mov ax, 2
  1931 000009A8 E90000                   jmp .retncheckConstSize
  1932                                  
  1933                                  ;-372 }
  1934                                  
  1935                                  
  1936                                  ;-373 
  1937                                  
  1938                                  
  1939                                  ;-374 
  1940                                  
  1941                                  
  1942                                  ;-375 //#include "PARSE.C"
  1943                                  
  1944                                  
  1945                                  ;-376 int parse() {
  1946                                  
  1947 000009AB C9                       .retncheckConstSize: LEAVE
  1948 000009AC C3                       ret
  1949                                  ENDP
  1950                                  
  1951                                  parse: PROC
  1952                                  
  1953                                  ;-377     LabelNamePtr  = &LabelNames;
  1954                                  
  1955 000009AD B85A77                   mov ax, LabelNames
  1956 000009B0 A3[4600]                 mov word [LabelNamePtr], ax
  1957                                  
  1958                                  ;-378     JmpCallNamePtr= &JmpCallNames;
  1959                                  
  1960 000009B3 B8728C                   mov ax, JmpCallNames
  1961 000009B6 A3[5200]                 mov word [JmpCallNamePtr], ax
  1962                                  
  1963                                  ;-379     LabelMaxIx=0;
  1964                                  
  1965 000009B9 B80000                   mov ax, 0
  1966 000009BC A3[4A00]                 mov word [LabelMaxIx], ax
  1967                                  
  1968                                  ;-380     JmpCallMaxIx=0;
  1969                                  
  1970 000009BF B80000                   mov ax, 0
  1971 000009C2 A3[5400]                 mov word [JmpCallMaxIx], ax
  1972                                  
  1973                                  ;-381     BinLen=0;
  1974                                  
  1975 000009C5 B80000                   mov ax, 0
  1976 000009C8 A3[5600]                 mov word [BinLen], ax
  1977                                  
  1978                                  ;-382     isInProc=0;
  1979                                  
  1980 000009CB B80000                   mov ax, 0
  1981 000009CE A2[0D00]                 mov byte [isInProc], al
  1982                                  
  1983                                  ;-383 
  1984                                  
  1985                                  
  1986                                  ;-384     do {//process a new line
  1987                                  
  1988                                  .parse70:
  1989                                  
  1990                                  ;-385         PCStart=PC;
  1991                                  
  1992 000009D1 A1[2300]                 mov ax, [PC]
  1993 000009D4 A3[2900]                 mov word [PCStart], ax
  1994                                  
  1995                                  ;-386         OpSize=0;
  1996                                  
  1997 000009D7 B80000                   mov ax, 0
  1998 000009DA A2[3700]                 mov byte [OpSize], al
  1999                                  
  2000                                  ;-387         OpPrintIndex=0;
  2001                                  
  2002 000009DD B80000                   mov ax, 0
  2003 000009E0 A3[4100]                 mov word [OpPrintIndex], ax
  2004                                  
  2005                                  ;-388         PrintRA=' ';
  2006                                  
  2007 000009E3 B82000                   mov ax, 32
  2008 000009E6 A2[4500]                 mov byte [PrintRA], al
  2009                                  
  2010                                  ;-389         getLine();
  2011                                  
  2012 000009E9 E84606                   call getLine
  2013                                  
  2014                                  ;-390         InputPtr = &InputBuf;
  2015                                  
  2016 000009EC B88D75                   mov ax, InputBuf
  2017 000009EF A3[1400]                 mov word [InputPtr], ax
  2018                                  
  2019                                  ;-391         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2020                                  
  2021 000009F2 E8D100                   call getTokeType
  2022                                  
  2023                                  ;-392         if (TokeType == ALNUME) {
  2024                                  
  2025 000009F5 A0[2C00]                 mov al, [TokeType]
  2026 000009F8 3C03                     cmp al, 3
  2027 000009FA 0F852C00                 jne .parse71
  2028                                  
  2029                                  ;-393             if (isLabel) {//set in getName
  2030                                  
  2031 000009FE A0[2B00]                 mov al, [isLabel]
  2032 00000A01 08C0                     or  al, al
  2033 00000A03 0F842300                 je .parse72
  2034                                  
  2035                                  ;-394               if (isInProc == 0)  strcpy(ProcName, Symbol);
  2036                                  
  2037 00000A07 A0[0D00]                 mov al, [isInProc]
  2038 00000A0A 3C00                     cmp al, 0
  2039 00000A0C 0F851000                 jne .parse73
  2040 00000A10 8D063075                 lea  ax, [Symbol]
  2041 00000A14 50                       push ax
  2042 00000A15 8D066E75                 lea  ax, [ProcName]
  2043 00000A19 50                       push ax
  2044 00000A1A E86D08                   call strcpy
  2045 00000A1D 83C404                   add  sp, 4
  2046                                  
  2047                                  ;-395                 storeLabel();
  2048                                  
  2049                                  .parse73:
  2050 00000A20 E8B401                   call storeLabel
  2051                                  
  2052                                  ;-396                 InputPtr++;//remove :
  2053                                  
  2054 00000A23 FF06[1400]               inc  word[InputPtr]
  2055                                  
  2056                                  ;-397                 getTokeType();
  2057                                  
  2058 00000A27 E89C00                   call getTokeType
  2059                                  
  2060                                  ;-398             }
  2061                                  
  2062                                  
  2063                                  ;-399         }
  2064                                  
  2065                                  .parse72:
  2066                                  
  2067                                  ;-400         if (TokeType == ALNUME) {
  2068                                  
  2069                                  .parse71:
  2070 00000A2A A0[2C00]                 mov al, [TokeType]
  2071 00000A2D 3C03                     cmp al, 3
  2072 00000A2F 0F851B00                 jne .parse74
  2073                                  
  2074                                  ;-401             lookCode();// and OpCodePtr
  2075                                  
  2076 00000A33 E838FA                   call lookCode
  2077                                  
  2078                                  ;-402             if(CodeType) process();
  2079                                  
  2080 00000A36 A0[2F00]                 mov al, [CodeType]
  2081 00000A39 08C0                     or  al, al
  2082 00000A3B 0F840600                 je .parse75
  2083 00000A3F E84219                   call process
  2084                                  
  2085                                  ;-403             else getVariable();
  2086                                  
  2087 00000A42 E90300                   jmp .parse76
  2088                                  .parse75:
  2089 00000A45 E88A02                   call getVariable
  2090                                  
  2091                                  ;-404             skipRest();
  2092                                  
  2093                                  .parse76:
  2094 00000A48 E8FE04                   call skipRest
  2095                                  
  2096                                  ;-405         }
  2097                                  
  2098                                  
  2099                                  ;-406         else if (TokeType >ALNUME) error1("Label or instruction expected");
  2100                                  
  2101 00000A4B E92700                   jmp .parse77
  2102                                  .parse74:
  2103 00000A4E A0[2C00]                 mov al, [TokeType]
  2104 00000A51 3C03                     cmp al, 3
  2105 00000A53 0F8E0C00                 jle .parse78
  2106 00000A57 68[860A]                 push parse_0
  2107 00000A5A E83010                   call error1
  2108 00000A5D 83C402                   add  sp, 2
  2109                                  
  2110                                  ;-407         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  2111                                  
  2112 00000A60 E91200                   jmp .parse79
  2113                                  .parse78:
  2114 00000A63 A0[2C00]                 mov al, [TokeType]
  2115 00000A66 3C01                     cmp al, 1
  2116 00000A68 0F850900                 jne .parse80
  2117 00000A6C 68[A40A]                 push parse_1
  2118 00000A6F E81B10                   call error1
  2119 00000A72 83C402                   add  sp, 2
  2120                                  
  2121                                  ;-408         printLine();
  2122                                  
  2123                                  .parse80:
  2124                                  .parse79:
  2125                                  .parse77:
  2126 00000A75 E8C20D                   call printLine
  2127                                  
  2128                                  ;-409     } while (DOS_NoBytes != 0 );
  2129                                  
  2130 00000A78 A1[2000]                 mov ax, [DOS_NoBytes]
  2131 00000A7B 83F800                   cmp ax, 0
  2132 00000A7E 0F840300                 je  .parse81
  2133 00000A82 E94CFF                   jmp .parse70
  2134                                  .parse81:
  2135                                  
  2136                                  ;-410 }
  2137                                  
  2138                                  
  2139                                  ;-411 
  2140                                  
  2141                                  
  2142                                  ;-412 int getTokeType() {
  2143                                  
  2144 00000A85 C3                       ret
  2145 00000A86 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2146 00000A8F 696E73747275637469-
  2147 00000A98 6F6E20657870656374-
  2148 00000AA1 656400             
  2149 00000AA4 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2150 00000AAD 616C6C6F7765642061-
  2151 00000AB6 74207374617274206F-
  2152 00000ABF 66206C696E6500     
  2153                                  ENDP
  2154                                  
  2155                                  getTokeType: PROC
  2156                                  
  2157                                  ;-413     char c;
  2158                                  
  2159                                  
  2160                                  ;-414     skipBlank();
  2161                                  
  2162                                  ;Function : getTokeType, Number of local variables: 1
  2163                                  ;   # type sign width addr used name   list of local variables
  2164                                  ;  200 var sign byte   413 NULL c = bp-2;
  2165 00000AC6 C8020000                 ENTER  2,0
  2166 00000ACA E88606                   call skipBlank
  2167                                  
  2168                                  ;-415     c = *InputPtr;
  2169                                  
  2170 00000ACD 8B1E[1400]               mov bx, [InputPtr]
  2171 00000AD1 8A07                     mov al, [bx]
  2172 00000AD3 B400                     mov ah, 0
  2173 00000AD5 8846FE                   mov [bp-2], al
  2174                                  
  2175                                  ;-416     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2176                                  
  2177 00000AD8 8A46FE                   mov al, [bp-2]
  2178 00000ADB 3C00                     cmp al, 0
  2179 00000ADD 0F850900                 jne .getTokeType82
  2180 00000AE1 B80000                   mov ax, 0
  2181 00000AE4 A2[2C00]                 mov byte [TokeType], al
  2182 00000AE7 E96600                   jmp .retngetTokeType
  2183                                  
  2184                                  ;-417     if (c == ';') {TokeType=0; return; }//comment
  2185                                  
  2186                                  .getTokeType82:
  2187 00000AEA 8A46FE                   mov al, [bp-2]
  2188 00000AED 3C3B                     cmp al, 59
  2189 00000AEF 0F850900                 jne .getTokeType83
  2190 00000AF3 B80000                   mov ax, 0
  2191 00000AF6 A2[2C00]                 mov byte [TokeType], al
  2192 00000AF9 E95400                   jmp .retngetTokeType
  2193                                  
  2194                                  ;-418     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2195                                  
  2196                                  .getTokeType83:
  2197 00000AFC 8A46FE                   mov al, byte [bp-2]
  2198 00000AFF B400                     mov ah, 0
  2199 00000B01 50                       push ax
  2200 00000B02 E83307                   call digit
  2201 00000B05 83C402                   add  sp, 2
  2202 00000B08 08C0                     or  al, al
  2203 00000B0A 0F841500                 je .getTokeType84
  2204 00000B0E 8A46FE                   mov al, byte [bp-2]
  2205 00000B11 B400                     mov ah, 0
  2206 00000B13 50                       push ax
  2207 00000B14 E85D08                   call getDigit
  2208 00000B17 83C402                   add  sp, 2
  2209 00000B1A B80100                   mov ax, 1
  2210 00000B1D A2[2C00]                 mov byte [TokeType], al
  2211 00000B20 E92D00                   jmp .retngetTokeType
  2212                                  
  2213                                  ;-419     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2214                                  
  2215                                  .getTokeType84:
  2216 00000B23 8A46FE                   mov al, byte [bp-2]
  2217 00000B26 B400                     mov ah, 0
  2218 00000B28 50                       push ax
  2219 00000B29 E85206                   call letterE
  2220 00000B2C 83C402                   add  sp, 2
  2221 00000B2F 08C0                     or  al, al
  2222 00000B31 0F841500                 je .getTokeType85
  2223 00000B35 8A46FE                   mov al, byte [bp-2]
  2224 00000B38 B400                     mov ah, 0
  2225 00000B3A 50                       push ax
  2226 00000B3B E88608                   call getName
  2227 00000B3E 83C402                   add  sp, 2
  2228 00000B41 B80300                   mov ax, 3
  2229 00000B44 A2[2C00]                 mov byte [TokeType], al
  2230 00000B47 E90600                   jmp .retngetTokeType
  2231                                  
  2232                                  ;-420     TokeType=NOALNUME;
  2233                                  
  2234                                  .getTokeType85:
  2235 00000B4A B80400                   mov ax, 4
  2236 00000B4D A2[2C00]                 mov byte [TokeType], al
  2237                                  
  2238                                  ;-421 }
  2239                                  
  2240                                  
  2241                                  ;-422 
  2242                                  
  2243                                  
  2244                                  ;-423 int storeJmpCall() {
  2245                                  
  2246 00000B50 C9                       .retngetTokeType: LEAVE
  2247 00000B51 C3                       ret
  2248                                  ENDP
  2249                                  
  2250                                  storeJmpCall: PROC
  2251                                  
  2252                                  ;-424     unsigned int i;
  2253                                  
  2254                                  
  2255                                  ;-425     JmpCallMaxIx++;
  2256                                  
  2257                                  ;Function : storeJmpCall, Number of local variables: 1
  2258                                  ;   # type sign width addr used name   list of local variables
  2259                                  ;  200 var unsg word   424 NULL i = bp-2;
  2260 00000B52 C8020000                 ENTER  2,0
  2261 00000B56 FF06[5400]               inc  word[JmpCallMaxIx]
  2262                                  
  2263                                  ;-426     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2264                                  
  2265 00000B5A A1[5400]                 mov ax, [JmpCallMaxIx]
  2266 00000B5D 3DF401                   cmp ax, 500 ;unsigned : 1
  2267 00000B60 0F8C0900                 jl  .storeJmpCall86
  2268 00000B64 68[AE0B]                 push storeJmpCall_0
  2269 00000B67 E8790F                   call errorexit
  2270 00000B6A 83C402                   add  sp, 2
  2271                                  
  2272                                  ;-427     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2273                                  
  2274                                  .storeJmpCall86:
  2275 00000B6D 8D063075                 lea  ax, [Symbol]
  2276 00000B71 50                       push ax
  2277 00000B72 FF36[5200]               push word [JmpCallNamePtr]
  2278 00000B76 E81107                   call strcpy
  2279 00000B79 83C404                   add  sp, 4
  2280 00000B7C A3[5200]                 mov word [JmpCallNamePtr], ax
  2281                                  
  2282                                  ;-428     JmpCallNamePtr++;
  2283                                  
  2284 00000B7F FF06[5200]               inc  word[JmpCallNamePtr]
  2285                                  
  2286                                  ;-429     i = JmpCallNamePtr - &JmpCallNames;
  2287                                  
  2288 00000B83 A1[5200]                 mov ax, [JmpCallNamePtr]
  2289 00000B86 2D728C                   sub ax, JmpCallNames
  2290 00000B89 8946FE                   mov [bp-2], ax
  2291                                  
  2292                                  ;-430     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2293                                  
  2294 00000B8C 8B46FE                   mov ax, [bp-2]
  2295 00000B8F 3DB107                   cmp ax, 1969 ;unsigned : 0
  2296 00000B92 0F820900                 jb  .storeJmpCall87
  2297 00000B96 68[C00B]                 push storeJmpCall_1
  2298 00000B99 E8470F                   call errorexit
  2299 00000B9C 83C402                   add  sp, 2
  2300                                  
  2301                                  ;-431     JmpCallAddr[JmpCallMaxIx] = PC;
  2302                                  
  2303                                  .storeJmpCall87:
  2304 00000B9F A1[2300]                 mov ax, [PC]
  2305 00000BA2 8B1E[5400]               mov bx, [JmpCallMaxIx]
  2306 00000BA6 D1E3                     shl bx, 1
  2307 00000BA8 89874294                 mov [JmpCallAddr+bx], ax
  2308                                  
  2309                                  ;-432 }
  2310                                  
  2311                                  
  2312                                  ;-433 
  2313                                  
  2314                                  
  2315                                  ;-434 int storeLabel() {
  2316 00000BAC C9                       LEAVE
  2317 00000BAD C3                       ret
  2318 00000BAE 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2319 00000BB7 4A6D7043616C6C7300 
  2320 00000BC0 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2321 00000BC9 4A6D7043616C6C206E-
  2322 00000BD2 616D657300         
  2323                                  ENDP
  2324                                  
  2325                                  storeLabel: PROC
  2326                                  
  2327                                  ;-435     unsigned int i;
  2328                                  
  2329                                  
  2330                                  ;-436     if(searchLabel()) error1("duplicate label");
  2331                                  
  2332                                  ;Function : storeLabel, Number of local variables: 1
  2333                                  ;   # type sign width addr used name   list of local variables
  2334                                  ;  200 var unsg word   435 NULL i = bp-2;
  2335 00000BD7 C8020000                 ENTER  2,0
  2336 00000BDB E8A000                   call searchLabel
  2337 00000BDE 08C0                     or  al, al
  2338 00000BE0 0F840900                 je .storeLabel88
  2339 00000BE4 68[490C]                 push storeLabel_0
  2340 00000BE7 E8A30E                   call error1
  2341 00000BEA 83C402                   add  sp, 2
  2342                                  
  2343                                  ;-437     LabelMaxIx++;
  2344                                  
  2345                                  .storeLabel88:
  2346 00000BED FF06[4A00]               inc  word[LabelMaxIx]
  2347                                  
  2348                                  ;-438     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2349                                  
  2350 00000BF1 A1[4A00]                 mov ax, [LabelMaxIx]
  2351 00000BF4 3D5802                   cmp ax, 600 ;unsigned : 1
  2352 00000BF7 0F8C0900                 jl  .storeLabel89
  2353 00000BFB 68[590C]                 push storeLabel_1
  2354 00000BFE E8E20E                   call errorexit
  2355 00000C01 83C402                   add  sp, 2
  2356                                  
  2357                                  ;-439     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2358                                  
  2359                                  .storeLabel89:
  2360 00000C04 8D063075                 lea  ax, [Symbol]
  2361 00000C08 50                       push ax
  2362 00000C09 FF36[4600]               push word [LabelNamePtr]
  2363 00000C0D E87A06                   call strcpy
  2364 00000C10 83C404                   add  sp, 4
  2365 00000C13 A3[4600]                 mov word [LabelNamePtr], ax
  2366                                  
  2367                                  ;-440     LabelNamePtr++;
  2368                                  
  2369 00000C16 FF06[4600]               inc  word[LabelNamePtr]
  2370                                  
  2371                                  ;-441     i = LabelNamePtr - &LabelNames;
  2372                                  
  2373 00000C1A A1[4600]                 mov ax, [LabelNamePtr]
  2374 00000C1D 2D5A77                   sub ax, LabelNames
  2375 00000C20 8946FE                   mov [bp-2], ax
  2376                                  
  2377                                  ;-442     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2378                                  
  2379 00000C23 8B46FE                   mov ax, [bp-2]
  2380 00000C26 3D810F                   cmp ax, 3969 ;unsigned : 0
  2381 00000C29 0F820900                 jb  .storeLabel90
  2382 00000C2D 68[690C]                 push storeLabel_2
  2383 00000C30 E8B00E                   call errorexit
  2384 00000C33 83C402                   add  sp, 2
  2385                                  
  2386                                  ;-443     LabelAddr[LabelMaxIx] = PC + Origin;
  2387                                  
  2388                                  .storeLabel90:
  2389 00000C36 A1[2300]                 mov ax, [PC]
  2390 00000C39 0306[2500]               add ax, [Origin]
  2391 00000C3D 8B1E[4A00]               mov bx, [LabelMaxIx]
  2392 00000C41 D1E3                     shl bx, 1
  2393 00000C43 8987FA86                 mov [LabelAddr+bx], ax
  2394                                  
  2395                                  ;-444 }
  2396                                  
  2397                                  
  2398                                  ;-445 
  2399                                  
  2400                                  
  2401                                  ;-446 int searchLabel() {
  2402 00000C47 C9                       LEAVE
  2403 00000C48 C3                       ret
  2404 00000C49 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2405 00000C52 206C6162656C00     
  2406 00000C59 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  2407 00000C62 6C6162656C7300     
  2408 00000C69 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2409 00000C72 6C6162656C206E616D-
  2410 00000C7B 657300             
  2411                                  ENDP
  2412                                  
  2413                                  searchLabel: PROC
  2414                                  
  2415                                  ;-447     int LIx; char *p;
  2416                                  
  2417                                  
  2418                                  ;-448     p = &LabelNames;
  2419                                  
  2420                                  ;Function : searchLabel, Number of local variables: 2
  2421                                  ;   # type sign width addr used name   list of local variables
  2422                                  ;  200 var sign word   447 NULL LIx = bp-2
  2423                                  ;  201 ptr sign byte   447 NULL p = bp-4;
  2424 00000C7E C8040000                 ENTER  4,0
  2425 00000C82 B85A77                   mov ax, LabelNames
  2426 00000C85 8946FC                   mov [bp-4], ax
  2427                                  
  2428                                  ;-449     LIx = 1;
  2429                                  
  2430 00000C88 B80100                   mov ax, 1
  2431 00000C8B 8946FE                   mov [bp-2], ax
  2432                                  
  2433                                  ;-450     while (LIx <= LabelMaxIx) {
  2434                                  
  2435                                  .searchLabel91:
  2436 00000C8E 8B46FE                   mov ax, [bp-2]
  2437 00000C91 3B06[4A00]               cmp ax, [LabelMaxIx]
  2438 00000C95 0F8F3100                 jg  .searchLabel92
  2439                                  
  2440                                  ;-451         if (eqstr(p, Symbol)) return LIx;//pos of label
  2441                                  
  2442 00000C99 8D063075                 lea  ax, [Symbol]
  2443 00000C9D 50                       push ax
  2444 00000C9E FF76FC                   push word [bp-4]
  2445 00000CA1 E81C06                   call eqstr
  2446 00000CA4 83C404                   add  sp, 4
  2447 00000CA7 08C0                     or  al, al
  2448 00000CA9 0F840600                 je .searchLabel93
  2449 00000CAD 8B46FE                   mov ax, [bp-2]
  2450 00000CB0 E91D00                   jmp .retnsearchLabel
  2451                                  
  2452                                  ;-452         p=strlen(p) + p;
  2453                                  
  2454                                  .searchLabel93:
  2455 00000CB3 FF76FC                   push word [bp-4]
  2456 00000CB6 E8A905                   call strlen
  2457 00000CB9 83C402                   add  sp, 2
  2458 00000CBC 0346FC                   add ax, [bp-4]
  2459 00000CBF 8946FC                   mov [bp-4], ax
  2460                                  
  2461                                  ;-453         p++;
  2462                                  
  2463 00000CC2 FF46FC                   inc  word[bp-4]
  2464                                  
  2465                                  ;-454         LIx++;
  2466                                  
  2467 00000CC5 FF46FE                   inc  word[bp-2]
  2468                                  
  2469                                  ;-455     }
  2470                                  
  2471                                  
  2472                                  ;-456     return 0;
  2473                                  
  2474 00000CC8 EBC4                     jmp .searchLabel91
  2475                                  .searchLabel92:
  2476 00000CCA B80000                   mov ax, 0
  2477 00000CCD E90000                   jmp .retnsearchLabel
  2478                                  
  2479                                  ;-457 }
  2480                                  
  2481                                  
  2482                                  ;-458 
  2483                                  
  2484                                  
  2485                                  ;-459 int getVariable() {
  2486                                  
  2487 00000CD0 C9                       .retnsearchLabel: LEAVE
  2488 00000CD1 C3                       ret
  2489                                  ENDP
  2490                                  
  2491                                  getVariable: PROC
  2492                                  
  2493                                  ;-460     char c;
  2494                                  
  2495                                  
  2496                                  ;-461     storeLabel();
  2497                                  
  2498                                  ;Function : getVariable, Number of local variables: 1
  2499                                  ;   # type sign width addr used name   list of local variables
  2500                                  ;  200 var sign byte   460 NULL c = bp-2;
  2501 00000CD2 C8020000                 ENTER  2,0
  2502 00000CD6 E8FEFE                   call storeLabel
  2503                                  
  2504                                  ;-462     getTokeType();
  2505                                  
  2506 00000CD9 E8EAFD                   call getTokeType
  2507                                  
  2508                                  ;-463     if(TokeType==ALNUME) {//getName
  2509                                  
  2510 00000CDC A0[2C00]                 mov al, [TokeType]
  2511 00000CDF 3C03                     cmp al, 3
  2512 00000CE1 0F857001                 jne .getVariable94
  2513                                  
  2514                                  ;-464         lookCode();
  2515                                  
  2516 00000CE5 E886F7                   call lookCode
  2517                                  
  2518                                  ;-465         if (CodeType < 200) dataexit();
  2519                                  
  2520 00000CE8 A0[2F00]                 mov al, [CodeType]
  2521 00000CEB 3CC8                     cmp al, 200
  2522 00000CED 0F8D0300                 jge .getVariable95
  2523 00000CF1 E8970F                   call dataexit
  2524                                  
  2525                                  ;-466         if (CodeType > 205) dataexit();
  2526                                  
  2527                                  .getVariable95:
  2528 00000CF4 A0[2F00]                 mov al, [CodeType]
  2529 00000CF7 3CCD                     cmp al, 205
  2530 00000CF9 0F8E0300                 jle .getVariable96
  2531 00000CFD E88B0F                   call dataexit
  2532                                  
  2533                                  ;-467         if (CodeType== 200) {//DB
  2534                                  
  2535                                  .getVariable96:
  2536 00000D00 A0[2F00]                 mov al, [CodeType]
  2537 00000D03 3CC8                     cmp al, 200
  2538 00000D05 0F856A00                 jne .getVariable97
  2539                                  
  2540                                  ;-468             do {
  2541                                  
  2542                                  .getVariable98:
  2543                                  
  2544                                  ;-469                 getTokeType();
  2545                                  
  2546 00000D09 E8BAFD                   call getTokeType
  2547                                  
  2548                                  ;-470                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2549                                  
  2550 00000D0C A0[2C00]                 mov al, [TokeType]
  2551 00000D0F 3C01                     cmp al, 1
  2552 00000D11 0F850D00                 jne .getVariable99
  2553 00000D15 FF36[0E00]               push word [SymbolInt]
  2554 00000D19 E88914                   call genCode8
  2555 00000D1C 83C402                   add  sp, 2
  2556                                  
  2557                                  ;-471                 else {
  2558                                  
  2559 00000D1F E94100                   jmp .getVariable100
  2560                                  .getVariable99:
  2561                                  
  2562                                  ;-472                     skipBlank();
  2563                                  
  2564 00000D22 E82E04                   call skipBlank
  2565                                  
  2566                                  ;-473                     if (isToken('"')) {
  2567                                  
  2568 00000D25 6A22                     push 34
  2569 00000D27 E8B801                   call isToken
  2570 00000D2A 83C402                   add  sp, 2
  2571 00000D2D 08C0                     or  al, al
  2572 00000D2F 0F843000                 je .getVariable101
  2573                                  
  2574                                  ;-474                         do {
  2575                                  
  2576                                  .getVariable102:
  2577                                  
  2578                                  ;-475                             c= *InputPtr;
  2579                                  
  2580 00000D33 8B1E[1400]               mov bx, [InputPtr]
  2581 00000D37 8A07                     mov al, [bx]
  2582 00000D39 B400                     mov ah, 0
  2583 00000D3B 8846FE                   mov [bp-2], al
  2584                                  
  2585                                  ;-476                             genCode8(c);
  2586                                  
  2587 00000D3E 8A46FE                   mov al, byte [bp-2]
  2588 00000D41 B400                     mov ah, 0
  2589 00000D43 50                       push ax
  2590 00000D44 E85E14                   call genCode8
  2591 00000D47 83C402                   add  sp, 2
  2592                                  
  2593                                  ;-477                             InputPtr++;
  2594                                  
  2595 00000D4A FF06[1400]               inc  word[InputPtr]
  2596                                  
  2597                                  ;-478                         } while (*InputPtr != '"' );
  2598                                  
  2599 00000D4E 8B1E[1400]               mov bx, [InputPtr]
  2600 00000D52 8A07                     mov al, [bx]
  2601 00000D54 B400                     mov ah, 0
  2602 00000D56 83F822                   cmp ax, 34
  2603 00000D59 0F840200                 je  .getVariable103
  2604 00000D5D EBD4                     jmp .getVariable102
  2605                                  .getVariable103:
  2606                                  
  2607                                  ;-479                         InputPtr++;
  2608                                  
  2609 00000D5F FF06[1400]               inc  word[InputPtr]
  2610                                  
  2611                                  ;-480                     }
  2612                                  
  2613                                  
  2614                                  ;-481                 }
  2615                                  
  2616                                  .getVariable101:
  2617                                  
  2618                                  ;-482             } while (isToken(','));
  2619                                  
  2620                                  .getVariable100:
  2621 00000D63 6A2C                     push 44
  2622 00000D65 E87A01                   call isToken
  2623 00000D68 83C402                   add  sp, 2
  2624 00000D6B 08C0                     or  al, al
  2625 00000D6D 0F840200                 je .getVariable104
  2626 00000D71 EB96                     jmp .getVariable98
  2627                                  .getVariable104:
  2628                                  
  2629                                  ;-483         }
  2630                                  
  2631                                  
  2632                                  ;-484         if (CodeType == 201) {//DW
  2633                                  
  2634                                  .getVariable97:
  2635 00000D73 A0[2F00]                 mov al, [CodeType]
  2636 00000D76 3CC9                     cmp al, 201
  2637 00000D78 0F852600                 jne .getVariable105
  2638                                  
  2639                                  ;-485             do {
  2640                                  
  2641                                  .getVariable106:
  2642                                  
  2643                                  ;-486                 getTokeType();
  2644                                  
  2645 00000D7C E847FD                   call getTokeType
  2646                                  
  2647                                  ;-487                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2648                                  
  2649 00000D7F A0[2C00]                 mov al, [TokeType]
  2650 00000D82 3C01                     cmp al, 1
  2651 00000D84 0F850A00                 jne .getVariable107
  2652 00000D88 FF36[0E00]               push word [SymbolInt]
  2653 00000D8C E86D14                   call genCode16
  2654 00000D8F 83C402                   add  sp, 2
  2655                                  
  2656                                  ;-488             } while (isToken(','));
  2657                                  
  2658                                  .getVariable107:
  2659 00000D92 6A2C                     push 44
  2660 00000D94 E84B01                   call isToken
  2661 00000D97 83C402                   add  sp, 2
  2662 00000D9A 08C0                     or  al, al
  2663 00000D9C 0F840200                 je .getVariable108
  2664 00000DA0 EBDA                     jmp .getVariable106
  2665                                  .getVariable108:
  2666                                  
  2667                                  ;-489         }
  2668                                  
  2669                                  
  2670                                  ;-490         if (CodeType == 202) {//DD
  2671                                  
  2672                                  .getVariable105:
  2673 00000DA2 A0[2F00]                 mov al, [CodeType]
  2674 00000DA5 3CCA                     cmp al, 202
  2675 00000DA7 0F852E00                 jne .getVariable109
  2676                                  
  2677                                  ;-491             do {
  2678                                  
  2679                                  .getVariable110:
  2680                                  
  2681                                  ;-492                 getTokeType();
  2682                                  
  2683 00000DAB E818FD                   call getTokeType
  2684                                  
  2685                                  ;-493                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2686                                  
  2687 00000DAE A0[2C00]                 mov al, [TokeType]
  2688 00000DB1 3C01                     cmp al, 1
  2689 00000DB3 0F851200                 jne .getVariable111
  2690 00000DB7 FF36[0E00]               push word [SymbolInt]
  2691 00000DBB E83E14                   call genCode16
  2692 00000DBE 83C402                   add  sp, 2
  2693                                  
  2694                                  ;-494                                     genCode16(0);}//todo genCode32(SymbolLong);
  2695                                  
  2696 00000DC1 6A00                     push 0
  2697 00000DC3 E83614                   call genCode16
  2698 00000DC6 83C402                   add  sp, 2
  2699                                  
  2700                                  ;-495             } while (isToken(','));
  2701                                  
  2702                                  .getVariable111:
  2703 00000DC9 6A2C                     push 44
  2704 00000DCB E81401                   call isToken
  2705 00000DCE 83C402                   add  sp, 2
  2706 00000DD1 08C0                     or  al, al
  2707 00000DD3 0F840200                 je .getVariable112
  2708 00000DD7 EBD2                     jmp .getVariable110
  2709                                  .getVariable112:
  2710                                  
  2711                                  ;-496         }
  2712                                  
  2713                                  
  2714                                  ;-497         if (CodeType >= 203) {//resb, resw, resd
  2715                                  
  2716                                  .getVariable109:
  2717 00000DD9 A0[2F00]                 mov al, [CodeType]
  2718 00000DDC 3CCB                     cmp al, 203 ;unsigned : 1
  2719 00000DDE 0F8C7000                 jl  .getVariable113
  2720                                  
  2721                                  ;-498             getTokeType();
  2722                                  
  2723 00000DE2 E8E1FC                   call getTokeType
  2724                                  
  2725                                  ;-499             if (TokeType == DIGIT) {
  2726                                  
  2727 00000DE5 A0[2C00]                 mov al, [TokeType]
  2728 00000DE8 3C01                     cmp al, 1
  2729 00000DEA 0F856100                 jne .getVariable114
  2730                                  
  2731                                  ;-500                 if (SymbolInt <= 0) syntaxerror();
  2732                                  
  2733 00000DEE A1[0E00]                 mov ax, [SymbolInt]
  2734 00000DF1 83F800                   cmp ax, 0
  2735 00000DF4 0F870300                 ja  .getVariable115
  2736 00000DF8 E8650E                   call syntaxerror
  2737                                  
  2738                                  ;-501                 if (AbsoluteLab == 0) error1("Absolute is null");
  2739                                  
  2740                                  .getVariable115:
  2741 00000DFB A1[2700]                 mov ax, [AbsoluteLab]
  2742 00000DFE 83F800                   cmp ax, 0
  2743 00000E01 0F850900                 jne .getVariable116
  2744 00000E05 68[5A0E]                 push getVariable_0
  2745 00000E08 E8820C                   call error1
  2746 00000E0B 83C402                   add  sp, 2
  2747                                  
  2748                                  ;-502                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2749                                  
  2750                                  .getVariable116:
  2751 00000E0E A1[2700]                 mov ax, [AbsoluteLab]
  2752 00000E11 8B1E[4A00]               mov bx, [LabelMaxIx]
  2753 00000E15 D1E3                     shl bx, 1
  2754 00000E17 8987FA86                 mov [LabelAddr+bx], ax
  2755                                  
  2756                                  ;-503                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2757                                  
  2758 00000E1B A0[2F00]                 mov al, [CodeType]
  2759 00000E1E 3CCC                     cmp al, 204
  2760 00000E20 0F850A00                 jne .getVariable117
  2761 00000E24 A1[0E00]                 mov ax, [SymbolInt]
  2762 00000E27 0306[0E00]               add ax, [SymbolInt]
  2763 00000E2B A3[0E00]                 mov word [SymbolInt], ax
  2764                                  
  2765                                  ;-504                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2766                                  
  2767                                  .getVariable117:
  2768 00000E2E A0[2F00]                 mov al, [CodeType]
  2769 00000E31 3CCD                     cmp al, 205
  2770 00000E33 0F850B00                 jne .getVariable118
  2771 00000E37 A1[0E00]                 mov ax, [SymbolInt]
  2772 00000E3A BB0400                   mov bx, 4
  2773 00000E3D F7E3                     mul bx
  2774 00000E3F A3[0E00]                 mov word [SymbolInt], ax
  2775                                  
  2776                                  ;-505                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2777                                  
  2778                                  .getVariable118:
  2779 00000E42 A1[2700]                 mov ax, [AbsoluteLab]
  2780 00000E45 0306[0E00]               add ax, [SymbolInt]
  2781 00000E49 A3[2700]                 mov word [AbsoluteLab], ax
  2782                                  
  2783                                  ;-506             } else numbererror();
  2784                                  
  2785 00000E4C E90300                   jmp .getVariable119
  2786                                  .getVariable114:
  2787 00000E4F E87B0D                   call numbererror
  2788                                  
  2789                                  ;-507         }
  2790                                  
  2791                                  .getVariable119:
  2792                                  
  2793                                  ;-508     }
  2794                                  
  2795                                  .getVariable113:
  2796                                  
  2797                                  ;-509     else dataexit();
  2798                                  
  2799 00000E52 E90300                   jmp .getVariable120
  2800                                  .getVariable94:
  2801 00000E55 E8330E                   call dataexit
  2802                                  
  2803                                  ;-510 }
  2804                                  
  2805                                  .getVariable120:
  2806                                  
  2807                                  ;-511 
  2808                                  
  2809                                  
  2810                                  ;-512 int getCodeSize() {
  2811 00000E58 C9                       LEAVE
  2812 00000E59 C3                       ret
  2813 00000E5A 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2814 00000E63 6973206E756C6C00   
  2815                                  ENDP
  2816                                  
  2817                                  getCodeSize: PROC
  2818                                  
  2819                                  ;-513     if (TokeType ==ALNUME) {
  2820                                  
  2821 00000E6B A0[2C00]                 mov al, [TokeType]
  2822 00000E6E 3C03                     cmp al, 3
  2823 00000E70 0F855700                 jne .getCodeSize121
  2824                                  
  2825                                  ;-514         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2826                                  
  2827 00000E74 68[D20E]                 push getCodeSize_0
  2828 00000E77 8D064F75                 lea  ax, [SymbolUpper]
  2829 00000E7B 50                       push ax
  2830 00000E7C E84104                   call eqstr
  2831 00000E7F 83C404                   add  sp, 4
  2832 00000E82 08C0                     or  al, al
  2833 00000E84 0F840900                 je .getCodeSize122
  2834 00000E88 E83BFC                   call getTokeType
  2835 00000E8B B80100                   mov ax, 1
  2836 00000E8E E94000                   jmp .retngetCodeSize
  2837                                  
  2838                                  ;-515         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2839                                  
  2840                                  .getCodeSize122:
  2841 00000E91 68[D70E]                 push getCodeSize_1
  2842 00000E94 8D064F75                 lea  ax, [SymbolUpper]
  2843 00000E98 50                       push ax
  2844 00000E99 E82404                   call eqstr
  2845 00000E9C 83C404                   add  sp, 4
  2846 00000E9F 08C0                     or  al, al
  2847 00000EA1 0F840900                 je .getCodeSize123
  2848 00000EA5 E81EFC                   call getTokeType
  2849 00000EA8 B80200                   mov ax, 2
  2850 00000EAB E92300                   jmp .retngetCodeSize
  2851                                  
  2852                                  ;-516         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2853                                  
  2854                                  .getCodeSize123:
  2855 00000EAE 68[DC0E]                 push getCodeSize_2
  2856 00000EB1 8D064F75                 lea  ax, [SymbolUpper]
  2857 00000EB5 50                       push ax
  2858 00000EB6 E80704                   call eqstr
  2859 00000EB9 83C404                   add  sp, 4
  2860 00000EBC 08C0                     or  al, al
  2861 00000EBE 0F840900                 je .getCodeSize124
  2862 00000EC2 E801FC                   call getTokeType
  2863 00000EC5 B80300                   mov ax, 3
  2864 00000EC8 E90600                   jmp .retngetCodeSize
  2865                                  
  2866                                  ;-517     }
  2867                                  
  2868                                  .getCodeSize124:
  2869                                  
  2870                                  ;-518     return 0;
  2871                                  
  2872                                  .getCodeSize121:
  2873 00000ECB B80000                   mov ax, 0
  2874 00000ECE E90000                   jmp .retngetCodeSize
  2875                                  
  2876                                  ;-519 }
  2877                                  
  2878                                  
  2879                                  ;-520 int isToken(char c) {
  2880                                  
  2881                                   .retngetCodeSize:
  2882 00000ED1 C3                       ret
  2883 00000ED2 4259544500              getCodeSize_0 db "BYTE",0
  2884 00000ED7 574F524400              getCodeSize_1 db "WORD",0
  2885 00000EDC 44574F524400            getCodeSize_2 db "DWORD",0
  2886                                  ENDP
  2887                                  
  2888                                  isToken: PROC
  2889                                  
  2890                                  ;-521     skipBlank();
  2891                                  
  2892                                  ;Function : isToken, Number of local variables: 1
  2893                                  ;   # type sign width addr used name   list of local variables
  2894                                  ;  200 var sign byte   520 NULL c = bp+4;
  2895 00000EE2 C8000000                 ENTER  0,0
  2896 00000EE6 E86A02                   call skipBlank
  2897                                  
  2898                                  ;-522     if (*InputPtr == c) {
  2899                                  
  2900 00000EE9 8B1E[1400]               mov bx, [InputPtr]
  2901 00000EED 8A07                     mov al, [bx]
  2902 00000EEF B400                     mov ah, 0
  2903 00000EF1 3A4604                   cmp al, [bp+4]
  2904 00000EF4 0F850A00                 jne .isToken125
  2905                                  
  2906                                  ;-523         InputPtr++;
  2907                                  
  2908 00000EF8 FF06[1400]               inc  word[InputPtr]
  2909                                  
  2910                                  ;-524         return 1;
  2911                                  
  2912 00000EFC B80100                   mov ax, 1
  2913 00000EFF E90600                   jmp .retnisToken
  2914                                  
  2915                                  ;-525         }
  2916                                  
  2917                                  
  2918                                  ;-526     return 0;
  2919                                  
  2920                                  .isToken125:
  2921 00000F02 B80000                   mov ax, 0
  2922 00000F05 E90000                   jmp .retnisToken
  2923                                  
  2924                                  ;-527 }
  2925                                  
  2926                                  
  2927                                  ;-528 int need(char c) {
  2928                                  
  2929 00000F08 C9                       .retnisToken: LEAVE
  2930 00000F09 C3                       ret
  2931                                  ENDP
  2932                                  
  2933                                  need: PROC
  2934                                  
  2935                                  ;-529     if (isToken(c)) {
  2936                                  
  2937                                  ;Function : need, Number of local variables: 1
  2938                                  ;   # type sign width addr used name   list of local variables
  2939                                  ;  200 var sign byte   528 NULL c = bp+4;
  2940 00000F0A C8000000                 ENTER  0,0
  2941 00000F0E 8A4604                   mov al, byte [bp+4]
  2942 00000F11 B400                     mov ah, 0
  2943 00000F13 50                       push ax
  2944 00000F14 E8CBFF                   call isToken
  2945 00000F17 83C402                   add  sp, 2
  2946 00000F1A 08C0                     or  al, al
  2947 00000F1C 0F840600                 je .need126
  2948                                  
  2949                                  ;-530         getTokeType();
  2950                                  
  2951 00000F20 E8A3FB                   call getTokeType
  2952                                  
  2953                                  ;-531         return;
  2954                                  
  2955 00000F23 E91800                   jmp .retnneed
  2956                                  
  2957                                  ;-532         }
  2958                                  
  2959                                  
  2960                                  ;-533     error1();
  2961                                  
  2962                                  .need126:
  2963 00000F26 E8640B                   call error1
  2964                                  
  2965                                  ;-534     prs(". need: ");
  2966                                  
  2967 00000F29 68[400F]                 push need_0
  2968 00000F2C E80C0A                   call prs
  2969 00000F2F 83C402                   add  sp, 2
  2970                                  
  2971                                  ;-535     prc(c);
  2972                                  
  2973 00000F32 8A4604                   mov al, byte [bp+4]
  2974 00000F35 B400                     mov ah, 0
  2975 00000F37 50                       push ax
  2976 00000F38 E8A809                   call prc
  2977 00000F3B 83C402                   add  sp, 2
  2978                                  
  2979                                  ;-536 }
  2980                                  
  2981                                  
  2982                                  ;-537 int skipRest() {
  2983                                  
  2984 00000F3E C9                       .retnneed: LEAVE
  2985 00000F3F C3                       ret
  2986 00000F40 2E206E6565643A2000      need_0 db ". need: ",0
  2987                                  ENDP
  2988                                  
  2989                                  skipRest: PROC
  2990                                  
  2991                                  ;-538     getTokeType();
  2992                                  
  2993 00000F49 E87AFB                   call getTokeType
  2994                                  
  2995                                  ;-539     if(TokeType)error1("extra char ignored");
  2996                                  
  2997 00000F4C A0[2C00]                 mov al, [TokeType]
  2998 00000F4F 08C0                     or  al, al
  2999 00000F51 0F840900                 je .skipRest127
  3000 00000F55 68[5F0F]                 push skipRest_0
  3001 00000F58 E8320B                   call error1
  3002 00000F5B 83C402                   add  sp, 2
  3003                                  
  3004                                  ;-540 }
  3005                                  
  3006                                  .skipRest127:
  3007                                  
  3008                                  ;-541 
  3009                                  
  3010                                  
  3011                                  ;-542 
  3012                                  
  3013                                  
  3014                                  ;-543 //#include "HELPER.C"
  3015                                  
  3016                                  
  3017                                  ;-544 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  3018                                  
  3019 00000F5E C3                       ret
  3020 00000F5F 657874726120636861-     skipRest_0 db "extra char ignored",0
  3021 00000F68 722069676E6F726564-
  3022 00000F71 00                 
  3023                                  ENDP
  3024                                  
  3025                                  writetty: PROC
  3026 00000F72 B40E                     mov  ah, 14
  3027 00000F74 BB0000                   mov  bx, 0
  3028 00000F77 CD10                     db 205,16
  3029                                  
  3030                                  ;-545 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  3031                                  
  3032 00000F79 C3                       ret
  3033                                  ENDP
  3034                                  
  3035                                  putch: PROC
  3036                                  ;Function : putch, Number of local variables: 1
  3037                                  ;   # type sign width addr used name   list of local variables
  3038                                  ;  200 var sign byte   545 NULL c = bp+4;
  3039 00000F7A C8000000                 ENTER  0,0 ; constant expression
  3040 00000F7E 807E040A                cmp byte[bp+4], 10
  3041 00000F82 0F850500                 jne .putch128
  3042 00000F86 B00D                     mov  al, 13
  3043 00000F88 E8E7FF                   call writetty
  3044                                  .putch128:
  3045 00000F8B 8A4604                   mov  al, [bp+4]
  3046 00000F8E E8E1FF                   call writetty
  3047                                  
  3048                                  ;-546 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3049 00000F91 C9                       LEAVE
  3050 00000F92 C3                       ret
  3051                                  ENDP
  3052                                  
  3053                                  cputs: PROC
  3054                                  ;Function : cputs, Number of local variables: 2
  3055                                  ;   # type sign width addr used name   list of local variables
  3056                                  ;  200 ptr sign byte   546 NULL s = bp+4
  3057                                  ;  201 var sign byte   546 NULL c = bp-2;
  3058 00000F93 C8020000                 ENTER  2,0
  3059                                  .cputs129:
  3060 00000F97 8B5E04                   mov bx, [bp+4]
  3061 00000F9A 8A07                     mov al, [bx]
  3062 00000F9C B400                     mov ah, 0
  3063 00000F9E 08C0                     or  al, al
  3064 00000FA0 0F841B00                 je .cputs130
  3065 00000FA4 8B5E04                   mov bx, [bp+4]
  3066 00000FA7 8A07                     mov al, [bx]
  3067 00000FA9 B400                     mov ah, 0
  3068 00000FAB 8846FE                   mov [bp-2], al
  3069 00000FAE 8A46FE                   mov al, byte [bp-2]
  3070 00000FB1 B400                     mov ah, 0
  3071 00000FB3 50                       push ax
  3072 00000FB4 E8C3FF                   call putch
  3073 00000FB7 83C402                   add  sp, 2
  3074 00000FBA FF4604                   inc  word[bp+4]
  3075 00000FBD EBD8                     jmp .cputs129
  3076                                  .cputs130:
  3077                                  
  3078                                  ;-547 
  3079                                  
  3080                                  
  3081                                  ;-548 int DosInt() {
  3082 00000FBF C9                       LEAVE
  3083 00000FC0 C3                       ret
  3084                                  ENDP
  3085                                  
  3086                                  DosInt: PROC
  3087                                  
  3088                                  ;-549     __emit__(0xCD,0x21);//inth 0x21;
  3089                                  
  3090 00000FC1 CD21                     db 205,33
  3091                                  
  3092                                  ;-550     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3093                                  
  3094 00000FC3 7304                     db 115,4
  3095                                  
  3096                                  ;-551     DOS_ERR++;
  3097                                  
  3098 00000FC5 FF06[1C00]               inc  word[DOS_ERR]
  3099                                  
  3100                                  ;-552 }
  3101                                  
  3102                                  
  3103                                  ;-553 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3104                                  
  3105 00000FC9 C3                       ret
  3106                                  ENDP
  3107                                  
  3108                                  openR: PROC
  3109                                  ;Function : openR, Number of local variables: 1
  3110                                  ;   # type sign width addr used name   list of local variables
  3111                                  ;  200 ptr sign byte   553 NULL s = bp+4;
  3112 00000FCA C8000000                 ENTER  0,0
  3113 00000FCE 8B5604                   mov  dx, [bp+4]
  3114 00000FD1 B8023D                   mov  ax, 15618
  3115 00000FD4 E8EAFF                   call DosInt
  3116                                  
  3117                                  ;-554 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3118 00000FD7 C9                       LEAVE
  3119 00000FD8 C3                       ret
  3120                                  ENDP
  3121                                  
  3122                                  creatR: PROC
  3123                                  ;Function : creatR, Number of local variables: 1
  3124                                  ;   # type sign width addr used name   list of local variables
  3125                                  ;  200 ptr sign byte   554 NULL s = bp+4;
  3126 00000FD9 C8000000                 ENTER  0,0
  3127 00000FDD 8B5604                   mov  dx, [bp+4]
  3128 00000FE0 B90000                   mov  cx, 0
  3129 00000FE3 B8003C                   mov  ax, 15360
  3130 00000FE6 E8D8FF                   call DosInt
  3131                                  
  3132                                  ;-555 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3133 00000FE9 C9                       LEAVE
  3134 00000FEA C3                       ret
  3135                                  ENDP
  3136                                  
  3137                                  fcloseR: PROC
  3138                                  ;Function : fcloseR, Number of local variables: 1
  3139                                  ;   # type sign width addr used name   list of local variables
  3140                                  ;  200 var sign word   555 NULL fd = bp+4;
  3141 00000FEB C8000000                 ENTER  0,0
  3142 00000FEF 8B5E04                   mov  bx, [bp+4]
  3143 00000FF2 B8003E                   mov  ax, 15872
  3144 00000FF5 E8C9FF                   call DosInt
  3145                                  
  3146                                  ;-556 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3147 00000FF8 C9                       LEAVE
  3148 00000FF9 C3                       ret
  3149                                  ENDP
  3150                                  
  3151                                  exitR: PROC
  3152                                  ;Function : exitR, Number of local variables: 1
  3153                                  ;   # type sign width addr used name   list of local variables
  3154                                  ;  200 var sign byte   556 NULL c = bp+4;
  3155 00000FFA C8000000                 ENTER  0,0
  3156 00000FFE B44C                     mov  ah, 76
  3157 00001000 8A4604                   mov  al, [bp+4]
  3158 00001003 E8BBFF                   call DosInt
  3159                                  
  3160                                  ;-557 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3161 00001006 C9                       LEAVE
  3162 00001007 C3                       ret
  3163                                  ENDP
  3164                                  
  3165                                  readRL: PROC
  3166                                  ;Function : readRL, Number of local variables: 3
  3167                                  ;   # type sign width addr used name   list of local variables
  3168                                  ;  200 ptr sign byte   557 NULL s = bp+4
  3169                                  ;  201 var sign word   557 NULL fd = bp+6
  3170                                  ;  202 var sign word   557 NULL len = bp+8;
  3171 00001008 C8000000                 ENTER  0,0
  3172 0000100C 8B5604                   mov  dx, [bp+4]
  3173 0000100F 8B4E08                   mov  cx, [bp+8]
  3174 00001012 8B5E06                   mov  bx, [bp+6]
  3175 00001015 B8003F                   mov  ax, 16128
  3176 00001018 E8A6FF                   call DosInt
  3177                                  
  3178                                  ;-558 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3179 0000101B C9                       LEAVE
  3180 0000101C C3                       ret
  3181                                  ENDP
  3182                                  
  3183                                  fputcR: PROC
  3184                                  ;Function : fputcR, Number of local variables: 2
  3185                                  ;   # type sign width addr used name   list of local variables
  3186                                  ;  200 ptr sign byte   558 NULL n = bp+4
  3187                                  ;  201 var sign word   558 NULL fd = bp+6;
  3188 0000101D C8000000                 ENTER  0,0
  3189 00001021 8D5604                  lea dx, [bp+4]
  3190                                  
  3191                                  ;-559   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3192                                  
  3193 00001024 B90100                   mov  cx, 1
  3194 00001027 8B5E06                   mov  bx, [bp+6]
  3195 0000102A B80040                   mov  ax, 16384
  3196 0000102D E891FF                   call DosInt
  3197                                  
  3198                                  ;-560 
  3199                                  
  3200                                  
  3201                                  ;-561 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3202 00001030 C9                       LEAVE
  3203 00001031 C3                       ret
  3204                                  ENDP
  3205                                  
  3206                                  getLine: PROC
  3207                                  
  3208                                  ;-562   unsigned int i;
  3209                                  
  3210                                  
  3211                                  ;-563   InputPtr= &InputBuf;
  3212                                  
  3213                                  ;Function : getLine, Number of local variables: 1
  3214                                  ;   # type sign width addr used name   list of local variables
  3215                                  ;  200 var unsg word   562 NULL i = bp-2;
  3216 00001032 C8020000                 ENTER  2,0
  3217 00001036 B88D75                   mov ax, InputBuf
  3218 00001039 A3[1400]                 mov word [InputPtr], ax
  3219                                  
  3220                                  ;-564   *InputPtr=0;//if last line is empty
  3221                                  
  3222 0000103C B80000                   mov ax, 0
  3223 0000103F 8B1E[1400]               mov  bx, [InputPtr]
  3224 00001043 8807                     mov  [bx], al
  3225                                  
  3226                                  ;-565   do {
  3227                                  
  3228                                  .getLine131:
  3229                                  
  3230                                  ;-566     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3231                                  
  3232 00001045 6A01                     push 1
  3233 00001047 FF36[1600]               push word [asm_fd]
  3234 0000104B 8D06[2200]               lea  ax, [DOS_ByteRead]
  3235 0000104F 50                       push ax
  3236 00001050 E8B5FF                   call readRL
  3237 00001053 83C406                   add  sp, 6
  3238 00001056 A3[2000]                 mov word [DOS_NoBytes], ax
  3239                                  
  3240                                  ;-567     if (DOS_ERR) errorexit("Reading Source");
  3241                                  
  3242 00001059 A1[1C00]                 mov ax, [DOS_ERR]
  3243 0000105C 08C0                     or  al, al
  3244 0000105E 0F840900                 je .getLine132
  3245 00001062 68[C410]                 push getLine_0
  3246 00001065 E87B0A                   call errorexit
  3247 00001068 83C402                   add  sp, 2
  3248                                  
  3249                                  ;-568     if (DOS_NoBytes == 0) return;
  3250                                  
  3251                                  .getLine132:
  3252 0000106B A1[2000]                 mov ax, [DOS_NoBytes]
  3253 0000106E 83F800                   cmp ax, 0
  3254 00001071 0F850300                 jne .getLine133
  3255 00001075 E94A00                   jmp .retngetLine
  3256                                  
  3257                                  ;-569     *InputPtr = DOS_ByteRead;
  3258                                  
  3259                                  .getLine133:
  3260 00001078 A0[2200]                 mov al, [DOS_ByteRead]
  3261 0000107B 8B1E[1400]               mov  bx, [InputPtr]
  3262 0000107F 8807                     mov  [bx], al
  3263                                  
  3264                                  ;-570     InputPtr++;
  3265                                  
  3266 00001081 FF06[1400]               inc  word[InputPtr]
  3267                                  
  3268                                  ;-571     i = InputPtr - &InputBuf;
  3269                                  
  3270 00001085 A1[1400]                 mov ax, [InputPtr]
  3271 00001088 2D8D75                   sub ax, InputBuf
  3272 0000108B 8946FE                   mov [bp-2], ax
  3273                                  
  3274                                  ;-572     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3275                                  
  3276 0000108E 8B46FE                   mov ax, [bp-2]
  3277 00001091 3DFF00                   cmp ax, 255 ;unsigned : 0
  3278 00001094 0F820900                 jb  .getLine134
  3279 00001098 68[D310]                 push getLine_1
  3280 0000109B E8450A                   call errorexit
  3281 0000109E 83C402                   add  sp, 2
  3282                                  
  3283                                  ;-573   } while (ifEOL(DOS_ByteRead) == 0);
  3284                                  
  3285                                  .getLine134:
  3286 000010A1 A0[2200]                 mov al, byte [DOS_ByteRead]
  3287 000010A4 B400                     mov ah, 0
  3288 000010A6 50                       push ax
  3289 000010A7 E83D00                   call ifEOL
  3290 000010AA 83C402                   add  sp, 2
  3291 000010AD 3C00                     cmp al, 0
  3292 000010AF 0F850200                 jne .getLine135
  3293 000010B3 EB90                     jmp .getLine131
  3294                                  .getLine135:
  3295                                  
  3296                                  ;-574   InputPtr--;
  3297                                  
  3298 000010B5 FF0E[1400]               dec  word[InputPtr]
  3299                                  
  3300                                  ;-575   *InputPtr=0;
  3301                                  
  3302 000010B9 B80000                   mov ax, 0
  3303 000010BC 8B1E[1400]               mov  bx, [InputPtr]
  3304 000010C0 8807                     mov  [bx], al
  3305                                  
  3306                                  ;-576 }
  3307                                  
  3308                                  
  3309                                  ;-577 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3310                                  
  3311 000010C2 C9                       .retngetLine: LEAVE
  3312 000010C3 C3                       ret
  3313 000010C4 52656164696E672053-     getLine_0 db "Reading Source",0
  3314 000010CD 6F7572636500       
  3315 000010D3 696E707574206C696E-     getLine_1 db "input line too long",0
  3316 000010DC 6520746F6F206C6F6E-
  3317 000010E5 6700               
  3318                                  ENDP
  3319                                  
  3320                                  ifEOL: PROC
  3321                                  
  3322                                  ;-578   if (c == 10) return 1;//LF
  3323                                  
  3324                                  ;Function : ifEOL, Number of local variables: 1
  3325                                  ;   # type sign width addr used name   list of local variables
  3326                                  ;  200 var sign byte   577 NULL c = bp+4;
  3327 000010E7 C8000000                 ENTER  0,0
  3328 000010EB 8A4604                   mov al, [bp+4]
  3329 000010EE 3C0A                     cmp al, 10
  3330 000010F0 0F850600                 jne .ifEOL136
  3331 000010F4 B80100                   mov ax, 1
  3332 000010F7 E93B00                   jmp .retnifEOL
  3333                                  
  3334                                  ;-579   if (c == 13) {//CR
  3335                                  
  3336                                  .ifEOL136:
  3337 000010FA 8A4604                   mov al, [bp+4]
  3338 000010FD 3C0D                     cmp al, 13
  3339 000010FF 0F852C00                 jne .ifEOL137
  3340                                  
  3341                                  ;-580     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3342                                  
  3343 00001103 6A01                     push 1
  3344 00001105 FF36[1600]               push word [asm_fd]
  3345 00001109 8D06[2200]               lea  ax, [DOS_ByteRead]
  3346 0000110D 50                       push ax
  3347 0000110E E8F7FE                   call readRL
  3348 00001111 83C406                   add  sp, 6
  3349 00001114 A3[2000]                 mov word [DOS_NoBytes], ax
  3350                                  
  3351                                  ;-581     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3352                                  
  3353 00001117 A0[2200]                 mov al, [DOS_ByteRead]
  3354 0000111A 3C0A                     cmp al, 10
  3355 0000111C 0F840900                 je  .ifEOL138
  3356 00001120 68[3711]                 push ifEOL_0
  3357 00001123 E8BD09                   call errorexit
  3358 00001126 83C402                   add  sp, 2
  3359                                  
  3360                                  ;-582     return 1;
  3361                                  
  3362                                  .ifEOL138:
  3363 00001129 B80100                   mov ax, 1
  3364 0000112C E90600                   jmp .retnifEOL
  3365                                  
  3366                                  ;-583   }
  3367                                  
  3368                                  
  3369                                  ;-584   return 0;
  3370                                  
  3371                                  .ifEOL137:
  3372 0000112F B80000                   mov ax, 0
  3373 00001132 E90000                   jmp .retnifEOL
  3374                                  
  3375                                  ;-585 }
  3376                                  
  3377                                  
  3378                                  ;-586 int skipBlank() {
  3379                                  
  3380 00001135 C9                       .retnifEOL: LEAVE
  3381 00001136 C3                       ret
  3382 00001137 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3383 00001140 462831302920616674-
  3384 00001149 657220435228313329-
  3385 00001152 00                 
  3386                                  ENDP
  3387                                  
  3388                                  skipBlank: PROC
  3389                                  
  3390                                  ;-587   skipblank1:
  3391                                  
  3392                                  .skipblank1:
  3393                                  
  3394                                  ;-588     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3395                                  
  3396 00001153 8B1E[1400]               mov bx, [InputPtr]
  3397 00001157 8A07                     mov al, [bx]
  3398 00001159 B400                     mov ah, 0
  3399 0000115B 83F820                   cmp ax, 32
  3400 0000115E 0F850600                 jne .skipBlank139
  3401 00001162 FF06[1400]               inc  word[InputPtr]
  3402 00001166 EBEB                     jmp .skipblank1
  3403                                  
  3404                                  ;-589     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3405                                  
  3406                                  .skipBlank139:
  3407 00001168 8B1E[1400]               mov bx, [InputPtr]
  3408 0000116C 8A07                     mov al, [bx]
  3409 0000116E B400                     mov ah, 0
  3410 00001170 83F809                   cmp ax, 9
  3411 00001173 0F850600                 jne .skipBlank140
  3412 00001177 FF06[1400]               inc  word[InputPtr]
  3413 0000117B EBD6                     jmp .skipblank1
  3414                                  
  3415                                  ;-590 }
  3416                                  
  3417                                  .skipBlank140:
  3418                                  
  3419                                  ;-591 int letterE(char c) {
  3420                                  
  3421 0000117D C3                       ret
  3422                                  ENDP
  3423                                  
  3424                                  letterE: PROC
  3425                                  
  3426                                  ;-592   if (c=='_') return 1;
  3427                                  
  3428                                  ;Function : letterE, Number of local variables: 1
  3429                                  ;   # type sign width addr used name   list of local variables
  3430                                  ;  200 var sign byte   591 NULL c = bp+4;
  3431 0000117E C8000000                 ENTER  0,0
  3432 00001182 8A4604                   mov al, [bp+4]
  3433 00001185 3C5F                     cmp al, 95
  3434 00001187 0F850600                 jne .letterE141
  3435 0000118B B80100                   mov ax, 1
  3436 0000118E E96900                   jmp .retnletterE
  3437                                  
  3438                                  ;-593   if (c=='.') return 1;
  3439                                  
  3440                                  .letterE141:
  3441 00001191 8A4604                   mov al, [bp+4]
  3442 00001194 3C2E                     cmp al, 46
  3443 00001196 0F850600                 jne .letterE142
  3444 0000119A B80100                   mov ax, 1
  3445 0000119D E95A00                   jmp .retnletterE
  3446                                  
  3447                                  ;-594   if (c=='?') return 1;
  3448                                  
  3449                                  .letterE142:
  3450 000011A0 8A4604                   mov al, [bp+4]
  3451 000011A3 3C3F                     cmp al, 63
  3452 000011A5 0F850600                 jne .letterE143
  3453 000011A9 B80100                   mov ax, 1
  3454 000011AC E94B00                   jmp .retnletterE
  3455                                  
  3456                                  ;-595   if (c=='$') return 1;
  3457                                  
  3458                                  .letterE143:
  3459 000011AF 8A4604                   mov al, [bp+4]
  3460 000011B2 3C24                     cmp al, 36
  3461 000011B4 0F850600                 jne .letterE144
  3462 000011B8 B80100                   mov ax, 1
  3463 000011BB E93C00                   jmp .retnletterE
  3464                                  
  3465                                  ;-596   if (c> 'z') return 0;
  3466                                  
  3467                                  .letterE144:
  3468 000011BE 8A4604                   mov al, [bp+4]
  3469 000011C1 3C7A                     cmp al, 122
  3470 000011C3 0F8E0600                 jle .letterE145
  3471 000011C7 B80000                   mov ax, 0
  3472 000011CA E92D00                   jmp .retnletterE
  3473                                  
  3474                                  ;-597   if (c< '@') return 0; // at included
  3475                                  
  3476                                  .letterE145:
  3477 000011CD 8A4604                   mov al, [bp+4]
  3478 000011D0 3C40                     cmp al, 64
  3479 000011D2 0F8D0600                 jge .letterE146
  3480 000011D6 B80000                   mov ax, 0
  3481 000011D9 E91E00                   jmp .retnletterE
  3482                                  
  3483                                  ;-598   if (c> 'Z') { if (c< 'a') return 0; }
  3484                                  
  3485                                  .letterE146:
  3486 000011DC 8A4604                   mov al, [bp+4]
  3487 000011DF 3C5A                     cmp al, 90
  3488 000011E1 0F8E0F00                 jle .letterE147
  3489 000011E5 8A4604                   mov al, [bp+4]
  3490 000011E8 3C61                     cmp al, 97
  3491 000011EA 0F8D0600                 jge .letterE148
  3492 000011EE B80000                   mov ax, 0
  3493 000011F1 E90600                   jmp .retnletterE
  3494                                  .letterE148:
  3495                                  
  3496                                  ;-599   return 1;
  3497                                  
  3498                                  .letterE147:
  3499 000011F4 B80100                   mov ax, 1
  3500 000011F7 E90000                   jmp .retnletterE
  3501                                  
  3502                                  ;-600 }
  3503                                  
  3504                                  
  3505                                  ;-601 int alnumE(char c) {
  3506                                  
  3507 000011FA C9                       .retnletterE: LEAVE
  3508 000011FB C3                       ret
  3509                                  ENDP
  3510                                  
  3511                                  alnumE: PROC
  3512                                  
  3513                                  ;-602   if (digit(c)) return 1;
  3514                                  
  3515                                  ;Function : alnumE, Number of local variables: 1
  3516                                  ;   # type sign width addr used name   list of local variables
  3517                                  ;  200 var sign byte   601 NULL c = bp+4;
  3518 000011FC C8000000                 ENTER  0,0
  3519 00001200 8A4604                   mov al, byte [bp+4]
  3520 00001203 B400                     mov ah, 0
  3521 00001205 50                       push ax
  3522 00001206 E82F00                   call digit
  3523 00001209 83C402                   add  sp, 2
  3524 0000120C 08C0                     or  al, al
  3525 0000120E 0F840600                 je .alnumE149
  3526 00001212 B80100                   mov ax, 1
  3527 00001215 E91E00                   jmp .retnalnumE
  3528                                  
  3529                                  ;-603   if (letterE(c)) return 1;
  3530                                  
  3531                                  .alnumE149:
  3532 00001218 8A4604                   mov al, byte [bp+4]
  3533 0000121B B400                     mov ah, 0
  3534 0000121D 50                       push ax
  3535 0000121E E85DFF                   call letterE
  3536 00001221 83C402                   add  sp, 2
  3537 00001224 08C0                     or  al, al
  3538 00001226 0F840600                 je .alnumE150
  3539 0000122A B80100                   mov ax, 1
  3540 0000122D E90600                   jmp .retnalnumE
  3541                                  
  3542                                  ;-604   return 0;
  3543                                  
  3544                                  .alnumE150:
  3545 00001230 B80000                   mov ax, 0
  3546 00001233 E90000                   jmp .retnalnumE
  3547                                  
  3548                                  ;-605 }
  3549                                  
  3550                                  
  3551                                  ;-606 int digit(char c){
  3552                                  
  3553 00001236 C9                       .retnalnumE: LEAVE
  3554 00001237 C3                       ret
  3555                                  ENDP
  3556                                  
  3557                                  digit: PROC
  3558                                  
  3559                                  ;-607     if(c<'0') return 0;
  3560                                  
  3561                                  ;Function : digit, Number of local variables: 1
  3562                                  ;   # type sign width addr used name   list of local variables
  3563                                  ;  200 var sign byte   606 NULL c = bp+4;
  3564 00001238 C8000000                 ENTER  0,0
  3565 0000123C 8A4604                   mov al, [bp+4]
  3566 0000123F 3C30                     cmp al, 48
  3567 00001241 0F8D0600                 jge .digit151
  3568 00001245 B80000                   mov ax, 0
  3569 00001248 E91500                   jmp .retndigit
  3570                                  
  3571                                  ;-608     if(c>'9') return 0;
  3572                                  
  3573                                  .digit151:
  3574 0000124B 8A4604                   mov al, [bp+4]
  3575 0000124E 3C39                     cmp al, 57
  3576 00001250 0F8E0600                 jle .digit152
  3577 00001254 B80000                   mov ax, 0
  3578 00001257 E90600                   jmp .retndigit
  3579                                  
  3580                                  ;-609     return 1;
  3581                                  
  3582                                  .digit152:
  3583 0000125A B80100                   mov ax, 1
  3584 0000125D E90000                   jmp .retndigit
  3585                                  
  3586                                  ;-610 }
  3587                                  
  3588                                  
  3589                                  ;-611 int strlen(char *s) { int c;
  3590                                  
  3591 00001260 C9                       .retndigit: LEAVE
  3592 00001261 C3                       ret
  3593                                  ENDP
  3594                                  
  3595                                  strlen: PROC
  3596                                  
  3597                                  ;-612     c=0;
  3598                                  
  3599                                  ;Function : strlen, Number of local variables: 2
  3600                                  ;   # type sign width addr used name   list of local variables
  3601                                  ;  200 ptr sign byte   611 NULL s = bp+4
  3602                                  ;  201 var sign word   611 NULL c = bp-2;
  3603 00001262 C8020000                 ENTER  2,0
  3604 00001266 B80000                   mov ax, 0
  3605 00001269 8946FE                   mov [bp-2], ax
  3606                                  
  3607                                  ;-613     while (*s!=0) {s++; c++;}
  3608                                  
  3609                                  .strlen153:
  3610 0000126C 8B5E04                   mov bx, [bp+4]
  3611 0000126F 8A07                     mov al, [bx]
  3612 00001271 B400                     mov ah, 0
  3613 00001273 83F800                   cmp ax, 0
  3614 00001276 0F840800                 je  .strlen154
  3615 0000127A FF4604                   inc  word[bp+4]
  3616 0000127D FF46FE                   inc  word[bp-2]
  3617                                  
  3618                                  ;-614     return c;
  3619                                  
  3620 00001280 EBEA                     jmp .strlen153
  3621                                  .strlen154:
  3622 00001282 8B46FE                   mov ax, [bp-2]
  3623 00001285 E90000                   jmp .retnstrlen
  3624                                  
  3625                                  ;-615     }
  3626                                  
  3627                                  
  3628                                  ;-616 int strcpy(char *s, char *t) {
  3629                                  
  3630 00001288 C9                       .retnstrlen: LEAVE
  3631 00001289 C3                       ret
  3632                                  ENDP
  3633                                  
  3634                                  strcpy: PROC
  3635                                  
  3636                                  ;-617     do { *s=*t; s++; t++; }
  3637                                  
  3638                                  ;Function : strcpy, Number of local variables: 2
  3639                                  ;   # type sign width addr used name   list of local variables
  3640                                  ;  200 ptr sign byte   616 NULL s = bp+4
  3641                                  ;  201 ptr sign byte   616 NULL t = bp+6;
  3642 0000128A C8000000                 ENTER  0,0
  3643                                  .strcpy155:
  3644 0000128E 8B5E06                   mov bx, [bp+6]
  3645 00001291 8A07                     mov al, [bx]
  3646 00001293 B400                     mov ah, 0
  3647 00001295 8B5E04                   mov  bx, [bp+4]
  3648 00001298 8807                     mov  [bx], al
  3649 0000129A FF4604                   inc  word[bp+4]
  3650 0000129D FF4606                   inc  word[bp+6]
  3651                                  
  3652                                  ;-618     while (*t!=0);
  3653                                  
  3654 000012A0 8B5E06                   mov bx, [bp+6]
  3655 000012A3 8A07                     mov al, [bx]
  3656 000012A5 B400                     mov ah, 0
  3657 000012A7 83F800                   cmp ax, 0
  3658 000012AA 0F840200                 je  .strcpy156
  3659 000012AE EBDE                     jmp .strcpy155
  3660                                  .strcpy156:
  3661                                  
  3662                                  ;-619     *s=0;
  3663                                  
  3664 000012B0 B80000                   mov ax, 0
  3665 000012B3 8B5E04                   mov  bx, [bp+4]
  3666 000012B6 8807                     mov  [bx], al
  3667                                  
  3668                                  ;-620     return s;
  3669                                  
  3670 000012B8 8B4604                   mov ax, [bp+4]
  3671 000012BB E90000                   jmp .retnstrcpy
  3672                                  
  3673                                  ;-621     }
  3674                                  
  3675                                  
  3676                                  ;-622 int eqstr(char *p, char *q) {
  3677                                  
  3678 000012BE C9                       .retnstrcpy: LEAVE
  3679 000012BF C3                       ret
  3680                                  ENDP
  3681                                  
  3682                                  eqstr: PROC
  3683                                  
  3684                                  ;-623     while(*p) {
  3685                                  
  3686                                  ;Function : eqstr, Number of local variables: 2
  3687                                  ;   # type sign width addr used name   list of local variables
  3688                                  ;  200 ptr sign byte   622 NULL p = bp+4
  3689                                  ;  201 ptr sign byte   622 NULL q = bp+6;
  3690 000012C0 C8000000                 ENTER  0,0
  3691                                  .eqstr157:
  3692 000012C4 8B5E04                   mov bx, [bp+4]
  3693 000012C7 8A07                     mov al, [bx]
  3694 000012C9 B400                     mov ah, 0
  3695 000012CB 08C0                     or  al, al
  3696 000012CD 0F842000                 je .eqstr158
  3697                                  
  3698                                  ;-624         if (*p != *q) return 0;
  3699                                  
  3700 000012D1 8B5E04                   mov bx, [bp+4]
  3701 000012D4 8A07                     mov al, [bx]
  3702 000012D6 B400                     mov ah, 0
  3703 000012D8 8B5E06                   mov bx, [bp+6]
  3704 000012DB 3A07                     cmp al, [bx]
  3705 000012DD B400                     mov ah, 0
  3706 000012DF 0F840600                 je  .eqstr159
  3707 000012E3 B80000                   mov ax, 0
  3708 000012E6 E92100                   jmp .retneqstr
  3709                                  
  3710                                  ;-625             p++;
  3711                                  
  3712                                  .eqstr159:
  3713 000012E9 FF4604                   inc  word[bp+4]
  3714                                  
  3715                                  ;-626             q++;
  3716                                  
  3717 000012EC FF4606                   inc  word[bp+6]
  3718                                  
  3719                                  ;-627             }
  3720                                  
  3721                                  
  3722                                  ;-628     if(*q) return 0;
  3723                                  
  3724 000012EF EBD3                     jmp .eqstr157
  3725                                  .eqstr158:
  3726 000012F1 8B5E06                   mov bx, [bp+6]
  3727 000012F4 8A07                     mov al, [bx]
  3728 000012F6 B400                     mov ah, 0
  3729 000012F8 08C0                     or  al, al
  3730 000012FA 0F840600                 je .eqstr160
  3731 000012FE B80000                   mov ax, 0
  3732 00001301 E90600                   jmp .retneqstr
  3733                                  
  3734                                  ;-629     return 1;
  3735                                  
  3736                                  .eqstr160:
  3737 00001304 B80100                   mov ax, 1
  3738 00001307 E90000                   jmp .retneqstr
  3739                                  
  3740                                  ;-630     }
  3741                                  
  3742                                  
  3743                                  ;-631 int strcat1(char *s, char *t) {
  3744                                  
  3745 0000130A C9                       .retneqstr: LEAVE
  3746 0000130B C3                       ret
  3747                                  ENDP
  3748                                  
  3749                                  strcat1: PROC
  3750                                  
  3751                                  ;-632     while (*s != 0) s++;
  3752                                  
  3753                                  ;Function : strcat1, Number of local variables: 2
  3754                                  ;   # type sign width addr used name   list of local variables
  3755                                  ;  200 ptr sign byte   631 NULL s = bp+4
  3756                                  ;  201 ptr sign byte   631 NULL t = bp+6;
  3757 0000130C C8000000                 ENTER  0,0
  3758                                  .strcat1161:
  3759 00001310 8B5E04                   mov bx, [bp+4]
  3760 00001313 8A07                     mov al, [bx]
  3761 00001315 B400                     mov ah, 0
  3762 00001317 83F800                   cmp ax, 0
  3763 0000131A 0F840500                 je  .strcat1162
  3764 0000131E FF4604                   inc  word[bp+4]
  3765                                  
  3766                                  ;-633     strcpy(s, t);
  3767                                  
  3768 00001321 EBED                     jmp .strcat1161
  3769                                  .strcat1162:
  3770 00001323 FF7606                   push word [bp+6]
  3771 00001326 FF7604                   push word [bp+4]
  3772 00001329 E85EFF                   call strcpy
  3773 0000132C 83C404                   add  sp, 4
  3774                                  
  3775                                  ;-634     }
  3776                                  
  3777                                  
  3778                                  ;-635 int toupper(char *s) {
  3779 0000132F C9                       LEAVE
  3780 00001330 C3                       ret
  3781                                  ENDP
  3782                                  
  3783                                  toupper: PROC
  3784                                  
  3785                                  ;-636     while(*s) {
  3786                                  
  3787                                  ;Function : toupper, Number of local variables: 1
  3788                                  ;   # type sign width addr used name   list of local variables
  3789                                  ;  200 ptr sign byte   635 NULL s = bp+4;
  3790 00001331 C8000000                 ENTER  0,0
  3791                                  .toupper163:
  3792 00001335 8B5E04                   mov bx, [bp+4]
  3793 00001338 8A07                     mov al, [bx]
  3794 0000133A B400                     mov ah, 0
  3795 0000133C 08C0                     or  al, al
  3796 0000133E 0F843000                 je .toupper164
  3797                                  
  3798                                  ;-637         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3799                                  
  3800 00001342 8B5E04                   mov bx, [bp+4]
  3801 00001345 8A07                     mov al, [bx]
  3802 00001347 B400                     mov ah, 0
  3803 00001349 83F861                   cmp ax, 97 ;unsigned : 1
  3804 0000134C 0F8C1D00                 jl  .toupper165
  3805 00001350 8B5E04                   mov bx, [bp+4]
  3806 00001353 8A07                     mov al, [bx]
  3807 00001355 B400                     mov ah, 0
  3808 00001357 83F87A                   cmp ax, 122
  3809 0000135A 0F8F0F00                 jg  .toupper166
  3810 0000135E 8B5E04                   mov bx, [bp+4]
  3811 00001361 8A07                     mov al, [bx]
  3812 00001363 B400                     mov ah, 0
  3813 00001365 83E820                   sub ax, 32
  3814 00001368 8B5E04                   mov  bx, [bp+4]
  3815 0000136B 8807                     mov  [bx], al
  3816                                  
  3817                                  ;-638             s++;
  3818                                  
  3819                                  .toupper166:
  3820                                  .toupper165:
  3821 0000136D FF4604                   inc  word[bp+4]
  3822                                  
  3823                                  ;-639               }
  3824                                  
  3825                                  
  3826                                  ;-640     }
  3827                                  
  3828 00001370 EBC3                     jmp .toupper163
  3829                                  .toupper164:
  3830                                  
  3831                                  ;-641 
  3832                                  
  3833                                  
  3834                                  ;-642 int getDigit(unsigned char c) {//ret: SymbolInt
  3835 00001372 C9                       LEAVE
  3836 00001373 C3                       ret
  3837                                  ENDP
  3838                                  
  3839                                  getDigit: PROC
  3840                                  
  3841                                  ;-643   unsigned int CastInt;
  3842                                  
  3843                                  
  3844                                  ;-644   SymbolInt=0;
  3845                                  
  3846                                  ;Function : getDigit, Number of local variables: 2
  3847                                  ;   # type sign width addr used name   list of local variables
  3848                                  ;  200 var unsg byte   642 NULL c = bp+4
  3849                                  ;  201 var unsg word   643 NULL CastInt = bp-2;
  3850 00001374 C8020000                 ENTER  2,0
  3851 00001378 B80000                   mov ax, 0
  3852 0000137B A3[0E00]                 mov word [SymbolInt], ax
  3853                                  
  3854                                  ;-645   do {
  3855                                  
  3856                                  .getDigit167:
  3857                                  
  3858                                  ;-646     c-='0';
  3859                                  
  3860 0000137E 806E0430                 sub  byte[bp+4], 48
  3861                                  
  3862                                  ;-647     SymbolInt=SymbolInt*10;
  3863                                  
  3864 00001382 A1[0E00]                 mov ax, [SymbolInt]
  3865 00001385 BB0A00                   mov bx, 10
  3866 00001388 F7E3                     mul bx
  3867 0000138A A3[0E00]                 mov word [SymbolInt], ax
  3868                                  
  3869                                  ;-648     ax=0; CastInt=c; //cast b2w
  3870                                  
  3871 0000138D B80000                   mov  ax, 0
  3872 00001390 8A4604                   mov al, [bp+4]
  3873 00001393 8946FE                   mov [bp-2], ax
  3874                                  
  3875                                  ;-649     SymbolInt=SymbolInt+CastInt;
  3876                                  
  3877 00001396 A1[0E00]                 mov ax, [SymbolInt]
  3878 00001399 0346FE                   add ax, [bp-2]
  3879 0000139C A3[0E00]                 mov word [SymbolInt], ax
  3880                                  
  3881                                  ;-650     InputPtr++;
  3882                                  
  3883 0000139F FF06[1400]               inc  word[InputPtr]
  3884                                  
  3885                                  ;-651     c = *InputPtr;
  3886                                  
  3887 000013A3 8B1E[1400]               mov bx, [InputPtr]
  3888 000013A7 8A07                     mov al, [bx]
  3889 000013A9 B400                     mov ah, 0
  3890 000013AB 884604                   mov [bp+4], al
  3891                                  
  3892                                  ;-652   } while(digit(c));
  3893                                  
  3894 000013AE 8A4604                   mov al, byte [bp+4]
  3895 000013B1 B400                     mov ah, 0
  3896 000013B3 50                       push ax
  3897 000013B4 E881FE                   call digit
  3898 000013B7 83C402                   add  sp, 2
  3899 000013BA 08C0                     or  al, al
  3900 000013BC 0F840200                 je .getDigit168
  3901 000013C0 EBBC                     jmp .getDigit167
  3902                                  .getDigit168:
  3903                                  
  3904                                  ;-653 }
  3905                                  
  3906                                  
  3907                                  ;-654 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3908 000013C2 C9                       LEAVE
  3909 000013C3 C3                       ret
  3910                                  ENDP
  3911                                  
  3912                                  getName: PROC
  3913                                  
  3914                                  ;-655   char *p; unsigned int i;
  3915                                  
  3916                                  
  3917                                  ;-656   p = &Symbol;
  3918                                  
  3919                                  ;Function : getName, Number of local variables: 3
  3920                                  ;   # type sign width addr used name   list of local variables
  3921                                  ;  200 var unsg byte   654 NULL c = bp+4
  3922                                  ;  201 ptr sign byte   655 NULL p = bp-2
  3923                                  ;  202 var unsg word   655 NULL i = bp-4;
  3924 000013C4 C8040000                 ENTER  4,0
  3925 000013C8 B83075                   mov ax, Symbol
  3926 000013CB 8946FE                   mov [bp-2], ax
  3927                                  
  3928                                  ;-657   *p = c;
  3929                                  
  3930 000013CE 8A4604                   mov al, [bp+4]
  3931 000013D1 8B5EFE                   mov  bx, [bp-2]
  3932 000013D4 8807                     mov  [bx], al
  3933                                  
  3934                                  ;-658   p++;
  3935                                  
  3936 000013D6 FF46FE                   inc  word[bp-2]
  3937                                  
  3938                                  ;-659   while (alnumE(c)) {
  3939                                  
  3940                                  .getName169:
  3941 000013D9 8A4604                   mov al, byte [bp+4]
  3942 000013DC B400                     mov ah, 0
  3943 000013DE 50                       push ax
  3944 000013DF E81AFE                   call alnumE
  3945 000013E2 83C402                   add  sp, 2
  3946 000013E5 08C0                     or  al, al
  3947 000013E7 0F843800                 je .getName170
  3948                                  
  3949                                  ;-660     InputPtr++;
  3950                                  
  3951 000013EB FF06[1400]               inc  word[InputPtr]
  3952                                  
  3953                                  ;-661     c = *InputPtr;
  3954                                  
  3955 000013EF 8B1E[1400]               mov bx, [InputPtr]
  3956 000013F3 8A07                     mov al, [bx]
  3957 000013F5 B400                     mov ah, 0
  3958 000013F7 884604                   mov [bp+4], al
  3959                                  
  3960                                  ;-662     *p = c;
  3961                                  
  3962 000013FA 8A4604                   mov al, [bp+4]
  3963 000013FD 8B5EFE                   mov  bx, [bp-2]
  3964 00001400 8807                     mov  [bx], al
  3965                                  
  3966                                  ;-663     p++;
  3967                                  
  3968 00001402 FF46FE                   inc  word[bp-2]
  3969                                  
  3970                                  ;-664     i = p - &Symbol;
  3971                                  
  3972 00001405 8B46FE                   mov ax, [bp-2]
  3973 00001408 2D3075                   sub ax, Symbol
  3974 0000140B 8946FC                   mov [bp-4], ax
  3975                                  
  3976                                  ;-665     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3977                                  
  3978 0000140E 8B46FC                   mov ax, [bp-4]
  3979 00001411 83F81F                   cmp ax, 31 ;unsigned : 0
  3980 00001414 0F820900                 jb  .getName171
  3981 00001418 68[6314]                 push getName_0
  3982 0000141B E8C506                   call errorexit
  3983 0000141E 83C402                   add  sp, 2
  3984                                  
  3985                                  ;-666   }
  3986                                  
  3987                                  .getName171:
  3988                                  
  3989                                  ;-667   if (c == ':') isLabel=1; else isLabel=0;
  3990                                  
  3991 00001421 EBB6                     jmp .getName169
  3992                                  .getName170:
  3993 00001423 8A4604                   mov al, [bp+4]
  3994 00001426 3C3A                     cmp al, 58
  3995 00001428 0F850900                 jne .getName172
  3996 0000142C B80100                   mov ax, 1
  3997 0000142F A2[2B00]                 mov byte [isLabel], al
  3998 00001432 E90600                   jmp .getName173
  3999                                  .getName172:
  4000 00001435 B80000                   mov ax, 0
  4001 00001438 A2[2B00]                 mov byte [isLabel], al
  4002                                  
  4003                                  ;-668   p--;
  4004                                  
  4005                                  .getName173:
  4006 0000143B FF4EFE                   dec  word[bp-2]
  4007                                  
  4008                                  ;-669   *p = 0;
  4009                                  
  4010 0000143E B80000                   mov ax, 0
  4011 00001441 8B5EFE                   mov  bx, [bp-2]
  4012 00001444 8807                     mov  [bx], al
  4013                                  
  4014                                  ;-670   strcpy(SymbolUpper, Symbol);
  4015                                  
  4016 00001446 8D063075                 lea  ax, [Symbol]
  4017 0000144A 50                       push ax
  4018 0000144B 8D064F75                 lea  ax, [SymbolUpper]
  4019 0000144F 50                       push ax
  4020 00001450 E837FE                   call strcpy
  4021 00001453 83C404                   add  sp, 4
  4022                                  
  4023                                  ;-671   toupper(SymbolUpper);
  4024                                  
  4025 00001456 8D064F75                 lea  ax, [SymbolUpper]
  4026 0000145A 50                       push ax
  4027 0000145B E8D3FE                   call toupper
  4028 0000145E 83C402                   add  sp, 2
  4029                                  
  4030                                  ;-672 }
  4031                                  
  4032                                  
  4033                                  ;-673 int testReg() {
  4034 00001461 C9                       LEAVE
  4035 00001462 C3                       ret
  4036 00001463 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4037 0000146C 6F206C6F6E6700     
  4038                                  ENDP
  4039                                  
  4040                                  testReg: PROC
  4041                                  
  4042                                  ;-674 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4043                                  
  4044                                  
  4045                                  ;-675   R2Type=0;
  4046                                  
  4047 00001473 B80000                   mov ax, 0
  4048 00001476 A2[3500]                 mov byte [R2Type], al
  4049                                  
  4050                                  ;-676   if (strlen(Symbol) < 2) return 0;
  4051                                  
  4052 00001479 8D063075                 lea  ax, [Symbol]
  4053 0000147D 50                       push ax
  4054 0000147E E8E1FD                   call strlen
  4055 00001481 83C402                   add  sp, 2
  4056 00001484 3C02                     cmp al, 2
  4057 00001486 0F8D0600                 jge .testReg174
  4058 0000148A B80000                   mov ax, 0
  4059 0000148D E94703                   jmp .retntestReg
  4060                                  
  4061                                  ;-677   if (strlen(Symbol) > 3) return 0;
  4062                                  
  4063                                  .testReg174:
  4064 00001490 8D063075                 lea  ax, [Symbol]
  4065 00001494 50                       push ax
  4066 00001495 E8CAFD                   call strlen
  4067 00001498 83C402                   add  sp, 2
  4068 0000149B 3C03                     cmp al, 3
  4069 0000149D 0F8E0600                 jle .testReg175
  4070 000014A1 B80000                   mov ax, 0
  4071 000014A4 E93003                   jmp .retntestReg
  4072                                  
  4073                                  ;-678   R2Type=BYTE;
  4074                                  
  4075                                  .testReg175:
  4076 000014A7 B80100                   mov ax, 1
  4077 000014AA A2[3500]                 mov byte [R2Type], al
  4078                                  
  4079                                  ;-679   if (eqstr(SymbolUpper, "AL")) return 0;
  4080                                  
  4081 000014AD 68[D817]                 push testReg_0
  4082 000014B0 8D064F75                 lea  ax, [SymbolUpper]
  4083 000014B4 50                       push ax
  4084 000014B5 E808FE                   call eqstr
  4085 000014B8 83C404                   add  sp, 4
  4086 000014BB 08C0                     or  al, al
  4087 000014BD 0F840600                 je .testReg176
  4088 000014C1 B80000                   mov ax, 0
  4089 000014C4 E91003                   jmp .retntestReg
  4090                                  
  4091                                  ;-680   if (eqstr(SymbolUpper, "CL")) return 1;
  4092                                  
  4093                                  .testReg176:
  4094 000014C7 68[DB17]                 push testReg_1
  4095 000014CA 8D064F75                 lea  ax, [SymbolUpper]
  4096 000014CE 50                       push ax
  4097 000014CF E8EEFD                   call eqstr
  4098 000014D2 83C404                   add  sp, 4
  4099 000014D5 08C0                     or  al, al
  4100 000014D7 0F840600                 je .testReg177
  4101 000014DB B80100                   mov ax, 1
  4102 000014DE E9F602                   jmp .retntestReg
  4103                                  
  4104                                  ;-681   if (eqstr(SymbolUpper, "DL")) return 2;
  4105                                  
  4106                                  .testReg177:
  4107 000014E1 68[DE17]                 push testReg_2
  4108 000014E4 8D064F75                 lea  ax, [SymbolUpper]
  4109 000014E8 50                       push ax
  4110 000014E9 E8D4FD                   call eqstr
  4111 000014EC 83C404                   add  sp, 4
  4112 000014EF 08C0                     or  al, al
  4113 000014F1 0F840600                 je .testReg178
  4114 000014F5 B80200                   mov ax, 2
  4115 000014F8 E9DC02                   jmp .retntestReg
  4116                                  
  4117                                  ;-682   if (eqstr(SymbolUpper, "BL")) return 3;
  4118                                  
  4119                                  .testReg178:
  4120 000014FB 68[E117]                 push testReg_3
  4121 000014FE 8D064F75                 lea  ax, [SymbolUpper]
  4122 00001502 50                       push ax
  4123 00001503 E8BAFD                   call eqstr
  4124 00001506 83C404                   add  sp, 4
  4125 00001509 08C0                     or  al, al
  4126 0000150B 0F840600                 je .testReg179
  4127 0000150F B80300                   mov ax, 3
  4128 00001512 E9C202                   jmp .retntestReg
  4129                                  
  4130                                  ;-683   if (eqstr(SymbolUpper, "AH")) return 4;
  4131                                  
  4132                                  .testReg179:
  4133 00001515 68[E417]                 push testReg_4
  4134 00001518 8D064F75                 lea  ax, [SymbolUpper]
  4135 0000151C 50                       push ax
  4136 0000151D E8A0FD                   call eqstr
  4137 00001520 83C404                   add  sp, 4
  4138 00001523 08C0                     or  al, al
  4139 00001525 0F840600                 je .testReg180
  4140 00001529 B80400                   mov ax, 4
  4141 0000152C E9A802                   jmp .retntestReg
  4142                                  
  4143                                  ;-684   if (eqstr(SymbolUpper, "CH")) return 5;
  4144                                  
  4145                                  .testReg180:
  4146 0000152F 68[E717]                 push testReg_5
  4147 00001532 8D064F75                 lea  ax, [SymbolUpper]
  4148 00001536 50                       push ax
  4149 00001537 E886FD                   call eqstr
  4150 0000153A 83C404                   add  sp, 4
  4151 0000153D 08C0                     or  al, al
  4152 0000153F 0F840600                 je .testReg181
  4153 00001543 B80500                   mov ax, 5
  4154 00001546 E98E02                   jmp .retntestReg
  4155                                  
  4156                                  ;-685   if (eqstr(SymbolUpper, "DH")) return 6;
  4157                                  
  4158                                  .testReg181:
  4159 00001549 68[EA17]                 push testReg_6
  4160 0000154C 8D064F75                 lea  ax, [SymbolUpper]
  4161 00001550 50                       push ax
  4162 00001551 E86CFD                   call eqstr
  4163 00001554 83C404                   add  sp, 4
  4164 00001557 08C0                     or  al, al
  4165 00001559 0F840600                 je .testReg182
  4166 0000155D B80600                   mov ax, 6
  4167 00001560 E97402                   jmp .retntestReg
  4168                                  
  4169                                  ;-686   if (eqstr(SymbolUpper, "BH")) return 7;
  4170                                  
  4171                                  .testReg182:
  4172 00001563 68[ED17]                 push testReg_7
  4173 00001566 8D064F75                 lea  ax, [SymbolUpper]
  4174 0000156A 50                       push ax
  4175 0000156B E852FD                   call eqstr
  4176 0000156E 83C404                   add  sp, 4
  4177 00001571 08C0                     or  al, al
  4178 00001573 0F840600                 je .testReg183
  4179 00001577 B80700                   mov ax, 7
  4180 0000157A E95A02                   jmp .retntestReg
  4181                                  
  4182                                  ;-687   R2Type=WORD;
  4183                                  
  4184                                  .testReg183:
  4185 0000157D B80200                   mov ax, 2
  4186 00001580 A2[3500]                 mov byte [R2Type], al
  4187                                  
  4188                                  ;-688   if (eqstr(SymbolUpper, "AX")) return 0;
  4189                                  
  4190 00001583 68[F017]                 push testReg_8
  4191 00001586 8D064F75                 lea  ax, [SymbolUpper]
  4192 0000158A 50                       push ax
  4193 0000158B E832FD                   call eqstr
  4194 0000158E 83C404                   add  sp, 4
  4195 00001591 08C0                     or  al, al
  4196 00001593 0F840600                 je .testReg184
  4197 00001597 B80000                   mov ax, 0
  4198 0000159A E93A02                   jmp .retntestReg
  4199                                  
  4200                                  ;-689   if (eqstr(SymbolUpper, "CX")) return 1;
  4201                                  
  4202                                  .testReg184:
  4203 0000159D 68[F317]                 push testReg_9
  4204 000015A0 8D064F75                 lea  ax, [SymbolUpper]
  4205 000015A4 50                       push ax
  4206 000015A5 E818FD                   call eqstr
  4207 000015A8 83C404                   add  sp, 4
  4208 000015AB 08C0                     or  al, al
  4209 000015AD 0F840600                 je .testReg185
  4210 000015B1 B80100                   mov ax, 1
  4211 000015B4 E92002                   jmp .retntestReg
  4212                                  
  4213                                  ;-690   if (eqstr(SymbolUpper, "DX")) return 2;
  4214                                  
  4215                                  .testReg185:
  4216 000015B7 68[F617]                 push testReg_10
  4217 000015BA 8D064F75                 lea  ax, [SymbolUpper]
  4218 000015BE 50                       push ax
  4219 000015BF E8FEFC                   call eqstr
  4220 000015C2 83C404                   add  sp, 4
  4221 000015C5 08C0                     or  al, al
  4222 000015C7 0F840600                 je .testReg186
  4223 000015CB B80200                   mov ax, 2
  4224 000015CE E90602                   jmp .retntestReg
  4225                                  
  4226                                  ;-691   if (eqstr(SymbolUpper, "BX")) return 3;
  4227                                  
  4228                                  .testReg186:
  4229 000015D1 68[F917]                 push testReg_11
  4230 000015D4 8D064F75                 lea  ax, [SymbolUpper]
  4231 000015D8 50                       push ax
  4232 000015D9 E8E4FC                   call eqstr
  4233 000015DC 83C404                   add  sp, 4
  4234 000015DF 08C0                     or  al, al
  4235 000015E1 0F840600                 je .testReg187
  4236 000015E5 B80300                   mov ax, 3
  4237 000015E8 E9EC01                   jmp .retntestReg
  4238                                  
  4239                                  ;-692   if (eqstr(SymbolUpper, "SP")) return 4;
  4240                                  
  4241                                  .testReg187:
  4242 000015EB 68[FC17]                 push testReg_12
  4243 000015EE 8D064F75                 lea  ax, [SymbolUpper]
  4244 000015F2 50                       push ax
  4245 000015F3 E8CAFC                   call eqstr
  4246 000015F6 83C404                   add  sp, 4
  4247 000015F9 08C0                     or  al, al
  4248 000015FB 0F840600                 je .testReg188
  4249 000015FF B80400                   mov ax, 4
  4250 00001602 E9D201                   jmp .retntestReg
  4251                                  
  4252                                  ;-693   if (eqstr(SymbolUpper, "BP")) return 5;
  4253                                  
  4254                                  .testReg188:
  4255 00001605 68[FF17]                 push testReg_13
  4256 00001608 8D064F75                 lea  ax, [SymbolUpper]
  4257 0000160C 50                       push ax
  4258 0000160D E8B0FC                   call eqstr
  4259 00001610 83C404                   add  sp, 4
  4260 00001613 08C0                     or  al, al
  4261 00001615 0F840600                 je .testReg189
  4262 00001619 B80500                   mov ax, 5
  4263 0000161C E9B801                   jmp .retntestReg
  4264                                  
  4265                                  ;-694   if (eqstr(SymbolUpper, "SI")) return 6;
  4266                                  
  4267                                  .testReg189:
  4268 0000161F 68[0218]                 push testReg_14
  4269 00001622 8D064F75                 lea  ax, [SymbolUpper]
  4270 00001626 50                       push ax
  4271 00001627 E896FC                   call eqstr
  4272 0000162A 83C404                   add  sp, 4
  4273 0000162D 08C0                     or  al, al
  4274 0000162F 0F840600                 je .testReg190
  4275 00001633 B80600                   mov ax, 6
  4276 00001636 E99E01                   jmp .retntestReg
  4277                                  
  4278                                  ;-695   if (eqstr(SymbolUpper, "DI")) return 7;
  4279                                  
  4280                                  .testReg190:
  4281 00001639 68[0518]                 push testReg_15
  4282 0000163C 8D064F75                 lea  ax, [SymbolUpper]
  4283 00001640 50                       push ax
  4284 00001641 E87CFC                   call eqstr
  4285 00001644 83C404                   add  sp, 4
  4286 00001647 08C0                     or  al, al
  4287 00001649 0F840600                 je .testReg191
  4288 0000164D B80700                   mov ax, 7
  4289 00001650 E98401                   jmp .retntestReg
  4290                                  
  4291                                  ;-696   R2Type=SEGREG;
  4292                                  
  4293                                  .testReg191:
  4294 00001653 B80400                   mov ax, 4
  4295 00001656 A2[3500]                 mov byte [R2Type], al
  4296                                  
  4297                                  ;-697   if (eqstr(SymbolUpper, "ES")) return 0;
  4298                                  
  4299 00001659 68[0818]                 push testReg_16
  4300 0000165C 8D064F75                 lea  ax, [SymbolUpper]
  4301 00001660 50                       push ax
  4302 00001661 E85CFC                   call eqstr
  4303 00001664 83C404                   add  sp, 4
  4304 00001667 08C0                     or  al, al
  4305 00001669 0F840600                 je .testReg192
  4306 0000166D B80000                   mov ax, 0
  4307 00001670 E96401                   jmp .retntestReg
  4308                                  
  4309                                  ;-698   if (eqstr(SymbolUpper, "CS")) return 1;
  4310                                  
  4311                                  .testReg192:
  4312 00001673 68[0B18]                 push testReg_17
  4313 00001676 8D064F75                 lea  ax, [SymbolUpper]
  4314 0000167A 50                       push ax
  4315 0000167B E842FC                   call eqstr
  4316 0000167E 83C404                   add  sp, 4
  4317 00001681 08C0                     or  al, al
  4318 00001683 0F840600                 je .testReg193
  4319 00001687 B80100                   mov ax, 1
  4320 0000168A E94A01                   jmp .retntestReg
  4321                                  
  4322                                  ;-699   if (eqstr(SymbolUpper, "SS")) return 2;
  4323                                  
  4324                                  .testReg193:
  4325 0000168D 68[0E18]                 push testReg_18
  4326 00001690 8D064F75                 lea  ax, [SymbolUpper]
  4327 00001694 50                       push ax
  4328 00001695 E828FC                   call eqstr
  4329 00001698 83C404                   add  sp, 4
  4330 0000169B 08C0                     or  al, al
  4331 0000169D 0F840600                 je .testReg194
  4332 000016A1 B80200                   mov ax, 2
  4333 000016A4 E93001                   jmp .retntestReg
  4334                                  
  4335                                  ;-700   if (eqstr(SymbolUpper, "DS")) return 3;
  4336                                  
  4337                                  .testReg194:
  4338 000016A7 68[1118]                 push testReg_19
  4339 000016AA 8D064F75                 lea  ax, [SymbolUpper]
  4340 000016AE 50                       push ax
  4341 000016AF E80EFC                   call eqstr
  4342 000016B2 83C404                   add  sp, 4
  4343 000016B5 08C0                     or  al, al
  4344 000016B7 0F840600                 je .testReg195
  4345 000016BB B80300                   mov ax, 3
  4346 000016BE E91601                   jmp .retntestReg
  4347                                  
  4348                                  ;-701   if (eqstr(SymbolUpper, "FS")) return 4;
  4349                                  
  4350                                  .testReg195:
  4351 000016C1 68[1418]                 push testReg_20
  4352 000016C4 8D064F75                 lea  ax, [SymbolUpper]
  4353 000016C8 50                       push ax
  4354 000016C9 E8F4FB                   call eqstr
  4355 000016CC 83C404                   add  sp, 4
  4356 000016CF 08C0                     or  al, al
  4357 000016D1 0F840600                 je .testReg196
  4358 000016D5 B80400                   mov ax, 4
  4359 000016D8 E9FC00                   jmp .retntestReg
  4360                                  
  4361                                  ;-702   if (eqstr(SymbolUpper, "GS")) return 5;
  4362                                  
  4363                                  .testReg196:
  4364 000016DB 68[1718]                 push testReg_21
  4365 000016DE 8D064F75                 lea  ax, [SymbolUpper]
  4366 000016E2 50                       push ax
  4367 000016E3 E8DAFB                   call eqstr
  4368 000016E6 83C404                   add  sp, 4
  4369 000016E9 08C0                     or  al, al
  4370 000016EB 0F840600                 je .testReg197
  4371 000016EF B80500                   mov ax, 5
  4372 000016F2 E9E200                   jmp .retntestReg
  4373                                  
  4374                                  ;-703   R2Type=DWORD;
  4375                                  
  4376                                  .testReg197:
  4377 000016F5 B80300                   mov ax, 3
  4378 000016F8 A2[3500]                 mov byte [R2Type], al
  4379                                  
  4380                                  ;-704   if (eqstr(SymbolUpper, "EAX"))return 0;
  4381                                  
  4382 000016FB 68[1A18]                 push testReg_22
  4383 000016FE 8D064F75                 lea  ax, [SymbolUpper]
  4384 00001702 50                       push ax
  4385 00001703 E8BAFB                   call eqstr
  4386 00001706 83C404                   add  sp, 4
  4387 00001709 08C0                     or  al, al
  4388 0000170B 0F840600                 je .testReg198
  4389 0000170F B80000                   mov ax, 0
  4390 00001712 E9C200                   jmp .retntestReg
  4391                                  
  4392                                  ;-705   if (eqstr(SymbolUpper, "ECX"))return 1;
  4393                                  
  4394                                  .testReg198:
  4395 00001715 68[1E18]                 push testReg_23
  4396 00001718 8D064F75                 lea  ax, [SymbolUpper]
  4397 0000171C 50                       push ax
  4398 0000171D E8A0FB                   call eqstr
  4399 00001720 83C404                   add  sp, 4
  4400 00001723 08C0                     or  al, al
  4401 00001725 0F840600                 je .testReg199
  4402 00001729 B80100                   mov ax, 1
  4403 0000172C E9A800                   jmp .retntestReg
  4404                                  
  4405                                  ;-706   if (eqstr(SymbolUpper, "EDX"))return 2;
  4406                                  
  4407                                  .testReg199:
  4408 0000172F 68[2218]                 push testReg_24
  4409 00001732 8D064F75                 lea  ax, [SymbolUpper]
  4410 00001736 50                       push ax
  4411 00001737 E886FB                   call eqstr
  4412 0000173A 83C404                   add  sp, 4
  4413 0000173D 08C0                     or  al, al
  4414 0000173F 0F840600                 je .testReg200
  4415 00001743 B80200                   mov ax, 2
  4416 00001746 E98E00                   jmp .retntestReg
  4417                                  
  4418                                  ;-707   if (eqstr(SymbolUpper, "EBX"))return 3;
  4419                                  
  4420                                  .testReg200:
  4421 00001749 68[2618]                 push testReg_25
  4422 0000174C 8D064F75                 lea  ax, [SymbolUpper]
  4423 00001750 50                       push ax
  4424 00001751 E86CFB                   call eqstr
  4425 00001754 83C404                   add  sp, 4
  4426 00001757 08C0                     or  al, al
  4427 00001759 0F840600                 je .testReg201
  4428 0000175D B80300                   mov ax, 3
  4429 00001760 E97400                   jmp .retntestReg
  4430                                  
  4431                                  ;-708   if (eqstr(SymbolUpper, "ESP"))return 4;
  4432                                  
  4433                                  .testReg201:
  4434 00001763 68[2A18]                 push testReg_26
  4435 00001766 8D064F75                 lea  ax, [SymbolUpper]
  4436 0000176A 50                       push ax
  4437 0000176B E852FB                   call eqstr
  4438 0000176E 83C404                   add  sp, 4
  4439 00001771 08C0                     or  al, al
  4440 00001773 0F840600                 je .testReg202
  4441 00001777 B80400                   mov ax, 4
  4442 0000177A E95A00                   jmp .retntestReg
  4443                                  
  4444                                  ;-709   if (eqstr(SymbolUpper, "EBP"))return 5;
  4445                                  
  4446                                  .testReg202:
  4447 0000177D 68[2E18]                 push testReg_27
  4448 00001780 8D064F75                 lea  ax, [SymbolUpper]
  4449 00001784 50                       push ax
  4450 00001785 E838FB                   call eqstr
  4451 00001788 83C404                   add  sp, 4
  4452 0000178B 08C0                     or  al, al
  4453 0000178D 0F840600                 je .testReg203
  4454 00001791 B80500                   mov ax, 5
  4455 00001794 E94000                   jmp .retntestReg
  4456                                  
  4457                                  ;-710   if (eqstr(SymbolUpper, "ESI"))return 6;
  4458                                  
  4459                                  .testReg203:
  4460 00001797 68[3218]                 push testReg_28
  4461 0000179A 8D064F75                 lea  ax, [SymbolUpper]
  4462 0000179E 50                       push ax
  4463 0000179F E81EFB                   call eqstr
  4464 000017A2 83C404                   add  sp, 4
  4465 000017A5 08C0                     or  al, al
  4466 000017A7 0F840600                 je .testReg204
  4467 000017AB B80600                   mov ax, 6
  4468 000017AE E92600                   jmp .retntestReg
  4469                                  
  4470                                  ;-711   if (eqstr(SymbolUpper, "EDI"))return 7;
  4471                                  
  4472                                  .testReg204:
  4473 000017B1 68[3618]                 push testReg_29
  4474 000017B4 8D064F75                 lea  ax, [SymbolUpper]
  4475 000017B8 50                       push ax
  4476 000017B9 E804FB                   call eqstr
  4477 000017BC 83C404                   add  sp, 4
  4478 000017BF 08C0                     or  al, al
  4479 000017C1 0F840600                 je .testReg205
  4480 000017C5 B80700                   mov ax, 7
  4481 000017C8 E90C00                   jmp .retntestReg
  4482                                  
  4483                                  ;-712   R2Type=0; return 0;
  4484                                  
  4485                                  .testReg205:
  4486 000017CB B80000                   mov ax, 0
  4487 000017CE A2[3500]                 mov byte [R2Type], al
  4488 000017D1 B80000                   mov ax, 0
  4489 000017D4 E90000                   jmp .retntestReg
  4490                                  
  4491                                  ;-713 }
  4492                                  
  4493                                  
  4494                                  ;-714 
  4495                                  
  4496                                  
  4497                                  ;-715 
  4498                                  
  4499                                  
  4500                                  ;-716 //#include "OUTPUT.C"
  4501                                  
  4502                                  
  4503                                  ;-717 int printLine() {
  4504                                  
  4505                                   .retntestReg:
  4506 000017D7 C3                       ret
  4507 000017D8 414C00                  testReg_0 db "AL",0
  4508 000017DB 434C00                  testReg_1 db "CL",0
  4509 000017DE 444C00                  testReg_2 db "DL",0
  4510 000017E1 424C00                  testReg_3 db "BL",0
  4511 000017E4 414800                  testReg_4 db "AH",0
  4512 000017E7 434800                  testReg_5 db "CH",0
  4513 000017EA 444800                  testReg_6 db "DH",0
  4514 000017ED 424800                  testReg_7 db "BH",0
  4515 000017F0 415800                  testReg_8 db "AX",0
  4516 000017F3 435800                  testReg_9 db "CX",0
  4517 000017F6 445800                  testReg_10 db "DX",0
  4518 000017F9 425800                  testReg_11 db "BX",0
  4519 000017FC 535000                  testReg_12 db "SP",0
  4520 000017FF 425000                  testReg_13 db "BP",0
  4521 00001802 534900                  testReg_14 db "SI",0
  4522 00001805 444900                  testReg_15 db "DI",0
  4523 00001808 455300                  testReg_16 db "ES",0
  4524 0000180B 435300                  testReg_17 db "CS",0
  4525 0000180E 535300                  testReg_18 db "SS",0
  4526 00001811 445300                  testReg_19 db "DS",0
  4527 00001814 465300                  testReg_20 db "FS",0
  4528 00001817 475300                  testReg_21 db "GS",0
  4529 0000181A 45415800                testReg_22 db "EAX",0
  4530 0000181E 45435800                testReg_23 db "ECX",0
  4531 00001822 45445800                testReg_24 db "EDX",0
  4532 00001826 45425800                testReg_25 db "EBX",0
  4533 0000182A 45535000                testReg_26 db "ESP",0
  4534 0000182E 45425000                testReg_27 db "EBP",0
  4535 00001832 45534900                testReg_28 db "ESI",0
  4536 00001836 45444900                testReg_29 db "EDI",0
  4537                                  ENDP
  4538                                  
  4539                                  printLine: PROC
  4540                                  
  4541                                  ;-718     int i; char c;
  4542                                  
  4543                                  
  4544                                  ;-719     prs("\n");
  4545                                  
  4546                                  ;Function : printLine, Number of local variables: 2
  4547                                  ;   # type sign width addr used name   list of local variables
  4548                                  ;  200 var sign word   718 NULL i = bp-2
  4549                                  ;  201 var sign byte   718 NULL c = bp-4;
  4550 0000183A C8040000                 ENTER  4,0
  4551 0000183E 68[CC18]                 push printLine_0
  4552 00001841 E8F700                   call prs
  4553 00001844 83C402                   add  sp, 2
  4554                                  
  4555                                  ;-720     printhex16(PCStart);
  4556                                  
  4557 00001847 FF36[2900]               push word [PCStart]
  4558 0000184B E8D301                   call printhex16
  4559 0000184E 83C402                   add  sp, 2
  4560                                  
  4561                                  ;-721     if (OpPrintIndex == 0) prs("               ");
  4562                                  
  4563 00001851 A1[4100]                 mov ax, [OpPrintIndex]
  4564 00001854 83F800                   cmp ax, 0
  4565 00001857 0F850C00                 jne .printLine206
  4566 0000185B 68[CF18]                 push printLine_1
  4567 0000185E E8DA00                   call prs
  4568 00001861 83C402                   add  sp, 2
  4569                                  
  4570                                  ;-722     else {
  4571                                  
  4572 00001864 E94C00                   jmp .printLine207
  4573                                  .printLine206:
  4574                                  
  4575                                  ;-723 //        prc(' ');
  4576                                  
  4577                                  
  4578                                  ;-724         i=0;
  4579                                  
  4580 00001867 B80000                   mov ax, 0
  4581 0000186A 8946FE                   mov [bp-2], ax
  4582                                  
  4583                                  ;-725         do {
  4584                                  
  4585                                  .printLine208:
  4586                                  
  4587                                  ;-726             c=OpPos[i];
  4588                                  
  4589 0000186D 8B5EFE                   mov bx, [bp-2]
  4590 00001870 8A875577                 mov al, [OpPos + bx]
  4591 00001874 8846FC                   mov [bp-4], al
  4592                                  
  4593                                  ;-727             prc(' ');
  4594                                  
  4595 00001877 6A20                     push 32
  4596 00001879 E86700                   call prc
  4597 0000187C 83C402                   add  sp, 2
  4598                                  
  4599                                  ;-728             printhex8a(c);
  4600                                  
  4601 0000187F 8A46FC                   mov al, byte [bp-4]
  4602 00001882 B400                     mov ah, 0
  4603 00001884 50                       push ax
  4604 00001885 E84701                   call printhex8a
  4605 00001888 83C402                   add  sp, 2
  4606                                  
  4607                                  ;-729             i++;
  4608                                  
  4609 0000188B FF46FE                   inc  word[bp-2]
  4610                                  
  4611                                  ;-730         } while (i < OpPrintIndex);
  4612                                  
  4613 0000188E 8B46FE                   mov ax, [bp-2]
  4614 00001891 3B06[4100]               cmp ax, [OpPrintIndex]
  4615 00001895 0F8D0200                 jge .printLine209
  4616 00001899 EBD2                     jmp .printLine208
  4617                                  .printLine209:
  4618                                  
  4619                                  ;-731         while (i < OPMAXLEN) {// fill rest with blank
  4620                                  
  4621                                  .printLine210:
  4622 0000189B 8B46FE                   mov ax, [bp-2]
  4623 0000189E 83F805                   cmp ax, 5
  4624 000018A1 0F8D0E00                 jge .printLine211
  4625                                  
  4626                                  ;-732             prs("   ");
  4627                                  
  4628 000018A5 68[DF18]                 push printLine_2
  4629 000018A8 E89000                   call prs
  4630 000018AB 83C402                   add  sp, 2
  4631                                  
  4632                                  ;-733             i++;
  4633                                  
  4634 000018AE FF46FE                   inc  word[bp-2]
  4635                                  
  4636                                  ;-734         }
  4637                                  
  4638                                  
  4639                                  ;-735     }
  4640                                  
  4641 000018B1 EBE8                     jmp .printLine210
  4642                                  .printLine211:
  4643                                  
  4644                                  ;-736     prc(PrintRA);
  4645                                  
  4646                                  .printLine207:
  4647 000018B3 A0[4500]                 mov al, byte [PrintRA]
  4648 000018B6 B400                     mov ah, 0
  4649 000018B8 50                       push ax
  4650 000018B9 E82700                   call prc
  4651 000018BC 83C402                   add  sp, 2
  4652                                  
  4653                                  ;-737     prscomment(InputBuf);
  4654                                  
  4655 000018BF 8D068D75                 lea  ax, [InputBuf]
  4656 000018C3 50                       push ax
  4657 000018C4 E84600                   call prscomment
  4658 000018C7 83C402                   add  sp, 2
  4659                                  
  4660                                  ;-738 }
  4661                                  
  4662                                  
  4663                                  ;-739 int prc(unsigned char c) {//print char
  4664 000018CA C9                       LEAVE
  4665 000018CB C3                       ret
  4666 000018CC 5C6E00                  printLine_0 db "\n",0
  4667 000018CF 202020202020202020-     printLine_1 db "               ",0
  4668 000018D8 20202020202000     
  4669 000018DF 20202000                printLine_2 db "   ",0
  4670                                  ENDP
  4671                                  
  4672                                  prc: PROC
  4673                                  
  4674                                  ;-740         if ( _ c==10) {
  4675                                  
  4676                                  ;Function : prc, Number of local variables: 1
  4677                                  ;   # type sign width addr used name   list of local variables
  4678                                  ;  200 var unsg byte   739 NULL c = bp+4;
  4679 000018E3 C8000000                 ENTER  0,0 ; constant expression
  4680 000018E7 807E040A                cmp byte[bp+4], 10
  4681 000018EB 0F850600                 jne .prc212
  4682                                  
  4683                                  ;-741             ax=13;
  4684                                  
  4685 000018EF B80D00                   mov  ax, 13
  4686                                  
  4687                                  ;-742             writetty();
  4688                                  
  4689 000018F2 E87DF6                   call writetty
  4690                                  
  4691                                  ;-743             }
  4692                                  
  4693                                  
  4694                                  ;-744         al=c;
  4695                                  
  4696                                  .prc212:
  4697 000018F5 8A4604                   mov  al, [bp+4]
  4698                                  
  4699                                  ;-745         writetty();
  4700                                  
  4701 000018F8 E877F6                   call writetty
  4702                                  
  4703                                  ;-746     fputcR(c,lst_fd);
  4704                                  
  4705 000018FB FF36[1800]               push word [lst_fd]
  4706 000018FF 8A4604                   mov al, byte [bp+4]
  4707 00001902 B400                     mov ah, 0
  4708 00001904 50                       push ax
  4709 00001905 E815F7                   call fputcR
  4710 00001908 83C404                   add  sp, 4
  4711                                  
  4712                                  ;-747 }
  4713                                  
  4714                                  
  4715                                  ;-748 
  4716                                  
  4717                                  
  4718                                  ;-749 int prscomment(unsigned char *s) {
  4719 0000190B C9                       LEAVE
  4720 0000190C C3                       ret
  4721                                  ENDP
  4722                                  
  4723                                  prscomment: PROC
  4724                                  
  4725                                  ;-750     unsigned char c;
  4726                                  
  4727                                  
  4728                                  ;-751     while (*s){
  4729                                  
  4730                                  ;Function : prscomment, Number of local variables: 2
  4731                                  ;   # type sign width addr used name   list of local variables
  4732                                  ;  200 ptr unsg byte   749 NULL s = bp+4
  4733                                  ;  201 var unsg byte   750 NULL c = bp-2;
  4734 0000190D C8020000                 ENTER  2,0
  4735                                  .prscomment213:
  4736 00001911 8B5E04                   mov bx, [bp+4]
  4737 00001914 8A07                     mov al, [bx]
  4738 00001916 B400                     mov ah, 0
  4739 00001918 08C0                     or  al, al
  4740 0000191A 0F841B00                 je .prscomment214
  4741                                  
  4742                                  ;-752         c=*s;
  4743                                  
  4744 0000191E 8B5E04                   mov bx, [bp+4]
  4745 00001921 8A07                     mov al, [bx]
  4746 00001923 B400                     mov ah, 0
  4747 00001925 8846FE                   mov [bp-2], al
  4748                                  
  4749                                  ;-753         prc(c);
  4750                                  
  4751 00001928 8A46FE                   mov al, byte [bp-2]
  4752 0000192B B400                     mov ah, 0
  4753 0000192D 50                       push ax
  4754 0000192E E8B2FF                   call prc
  4755 00001931 83C402                   add  sp, 2
  4756                                  
  4757                                  ;-754         s++;
  4758                                  
  4759 00001934 FF4604                   inc  word[bp+4]
  4760                                  
  4761                                  ;-755     }
  4762                                  
  4763                                  
  4764                                  ;-756 }
  4765                                  
  4766 00001937 EBD8                     jmp .prscomment213
  4767                                  .prscomment214:
  4768                                  
  4769                                  ;-757 int prs(unsigned char *s) {
  4770 00001939 C9                       LEAVE
  4771 0000193A C3                       ret
  4772                                  ENDP
  4773                                  
  4774                                  prs: PROC
  4775                                  
  4776                                  ;-758     unsigned char c;
  4777                                  
  4778                                  
  4779                                  ;-759     int com;
  4780                                  
  4781                                  
  4782                                  ;-760     com=0;
  4783                                  
  4784                                  ;Function : prs, Number of local variables: 3
  4785                                  ;   # type sign width addr used name   list of local variables
  4786                                  ;  200 ptr unsg byte   757 NULL s = bp+4
  4787                                  ;  201 var unsg byte   758 NULL c = bp-2
  4788                                  ;  202 var sign word   759 NULL com = bp-4;
  4789 0000193B C8040000                 ENTER  4,0
  4790 0000193F B80000                   mov ax, 0
  4791 00001942 8946FC                   mov [bp-4], ax
  4792                                  
  4793                                  ;-761     while (*s) {
  4794                                  
  4795                                  .prs215:
  4796 00001945 8B5E04                   mov bx, [bp+4]
  4797 00001948 8A07                     mov al, [bx]
  4798 0000194A B400                     mov ah, 0
  4799 0000194C 08C0                     or  al, al
  4800 0000194E 0F847B00                 je .prs216
  4801                                  
  4802                                  ;-762         c=*s;
  4803                                  
  4804 00001952 8B5E04                   mov bx, [bp+4]
  4805 00001955 8A07                     mov al, [bx]
  4806 00001957 B400                     mov ah, 0
  4807 00001959 8846FE                   mov [bp-2], al
  4808                                  
  4809                                  ;-763         if (c==34) {
  4810                                  
  4811 0000195C 8A46FE                   mov al, [bp-2]
  4812 0000195F 3C22                     cmp al, 34
  4813 00001961 0F851800                 jne .prs217
  4814                                  
  4815                                  ;-764             if (com) com=0;
  4816                                  
  4817 00001965 8B46FC                   mov ax, [bp-4]
  4818 00001968 08C0                     or  al, al
  4819 0000196A 0F840900                 je .prs218
  4820 0000196E B80000                   mov ax, 0
  4821 00001971 8946FC                   mov [bp-4], ax
  4822                                  
  4823                                  ;-765                 else com=1;
  4824                                  
  4825 00001974 E90600                   jmp .prs219
  4826                                  .prs218:
  4827 00001977 B80100                   mov ax, 1
  4828 0000197A 8946FC                   mov [bp-4], ax
  4829                                  
  4830                                  ;-766         }
  4831                                  
  4832                                  .prs219:
  4833                                  
  4834                                  ;-767         if (c==92) {
  4835                                  
  4836                                  .prs217:
  4837 0000197D 8A46FE                   mov al, [bp-2]
  4838 00001980 3C5C                     cmp al, 92
  4839 00001982 0F853500                 jne .prs220
  4840                                  
  4841                                  ;-768             if (com==0) {
  4842                                  
  4843 00001986 8B46FC                   mov ax, [bp-4]
  4844 00001989 83F800                   cmp ax, 0
  4845 0000198C 0F852B00                 jne .prs221
  4846                                  
  4847                                  ;-769                 s++;
  4848                                  
  4849 00001990 FF4604                   inc  word[bp+4]
  4850                                  
  4851                                  ;-770                 c=*s;
  4852                                  
  4853 00001993 8B5E04                   mov bx, [bp+4]
  4854 00001996 8A07                     mov al, [bx]
  4855 00001998 B400                     mov ah, 0
  4856 0000199A 8846FE                   mov [bp-2], al
  4857                                  
  4858                                  ;-771                 if (c=='n') c=10;
  4859                                  
  4860 0000199D 8A46FE                   mov al, [bp-2]
  4861 000019A0 3C6E                     cmp al, 110
  4862 000019A2 0F850600                 jne .prs222
  4863 000019A6 B80A00                   mov ax, 10
  4864 000019A9 8846FE                   mov [bp-2], al
  4865                                  
  4866                                  ;-772                 if (c=='t') c= 9;
  4867                                  
  4868                                  .prs222:
  4869 000019AC 8A46FE                   mov al, [bp-2]
  4870 000019AF 3C74                     cmp al, 116
  4871 000019B1 0F850600                 jne .prs223
  4872 000019B5 B80900                   mov ax, 9
  4873 000019B8 8846FE                   mov [bp-2], al
  4874                                  
  4875                                  ;-773             }
  4876                                  
  4877                                  .prs223:
  4878                                  
  4879                                  ;-774         }
  4880                                  
  4881                                  .prs221:
  4882                                  
  4883                                  ;-775         prc(c);
  4884                                  
  4885                                  .prs220:
  4886 000019BB 8A46FE                   mov al, byte [bp-2]
  4887 000019BE B400                     mov ah, 0
  4888 000019C0 50                       push ax
  4889 000019C1 E81FFF                   call prc
  4890 000019C4 83C402                   add  sp, 2
  4891                                  
  4892                                  ;-776         s++;
  4893                                  
  4894 000019C7 FF4604                   inc  word[bp+4]
  4895                                  
  4896                                  ;-777     }
  4897                                  
  4898                                  
  4899                                  ;-778 }
  4900                                  
  4901 000019CA E978FF                   jmp .prs215
  4902                                  .prs216:
  4903                                  
  4904                                  ;-779 int printhex8a(unsigned char c) {
  4905 000019CD C9                       LEAVE
  4906 000019CE C3                       ret
  4907                                  ENDP
  4908                                  
  4909                                  printhex8a: PROC
  4910                                  
  4911                                  ;-780     unsigned char nib;
  4912                                  
  4913                                  
  4914                                  ;-781     nib = c >> 4; printhex4(nib);
  4915                                  
  4916                                  ;Function : printhex8a, Number of local variables: 2
  4917                                  ;   # type sign width addr used name   list of local variables
  4918                                  ;  200 var unsg byte   779 NULL c = bp+4
  4919                                  ;  201 var unsg byte   780 NULL nib = bp-2;
  4920 000019CF C8020000                 ENTER  2,0
  4921 000019D3 8A4604                   mov al, [bp+4]
  4922 000019D6 C0E804                   shr al, 4
  4923 000019D9 8846FE                   mov [bp-2], al
  4924 000019DC 8A46FE                   mov al, byte [bp-2]
  4925 000019DF B400                     mov ah, 0
  4926 000019E1 50                       push ax
  4927 000019E2 E81900                   call printhex4
  4928 000019E5 83C402                   add  sp, 2
  4929                                  
  4930                                  ;-782     nib = c & 15; printhex4(nib);
  4931                                  
  4932 000019E8 8A4604                   mov al, [bp+4]
  4933 000019EB 240F                     and al, 15
  4934 000019ED 8846FE                   mov [bp-2], al
  4935 000019F0 8A46FE                   mov al, byte [bp-2]
  4936 000019F3 B400                     mov ah, 0
  4937 000019F5 50                       push ax
  4938 000019F6 E80500                   call printhex4
  4939 000019F9 83C402                   add  sp, 2
  4940                                  
  4941                                  ;-783 }
  4942                                  
  4943                                  
  4944                                  ;-784 int printhex4(unsigned char c) {
  4945 000019FC C9                       LEAVE
  4946 000019FD C3                       ret
  4947                                  ENDP
  4948                                  
  4949                                  printhex4: PROC
  4950                                  
  4951                                  ;-785     c += 48;
  4952                                  
  4953                                  ;Function : printhex4, Number of local variables: 1
  4954                                  ;   # type sign width addr used name   list of local variables
  4955                                  ;  200 var unsg byte   784 NULL c = bp+4;
  4956 000019FE C8000000                 ENTER  0,0
  4957 00001A02 80460430                 add  byte[bp+4], 48
  4958                                  
  4959                                  ;-786     if (c > 57) c += 7;
  4960                                  
  4961 00001A06 8A4604                   mov al, [bp+4]
  4962 00001A09 3C39                     cmp al, 57
  4963 00001A0B 0F8E0400                 jle .printhex4224
  4964 00001A0F 80460407                 add  byte[bp+4], 7
  4965                                  
  4966                                  ;-787     prc(c);
  4967                                  
  4968                                  .printhex4224:
  4969 00001A13 8A4604                   mov al, byte [bp+4]
  4970 00001A16 B400                     mov ah, 0
  4971 00001A18 50                       push ax
  4972 00001A19 E8C7FE                   call prc
  4973 00001A1C 83C402                   add  sp, 2
  4974                                  
  4975                                  ;-788 }
  4976                                  
  4977                                  
  4978                                  ;-789 int printhex16(unsigned int i) {
  4979 00001A1F C9                       LEAVE
  4980 00001A20 C3                       ret
  4981                                  ENDP
  4982                                  
  4983                                  printhex16: PROC
  4984                                  
  4985                                  ;-790     unsigned int half;
  4986                                  
  4987                                  
  4988                                  ;-791     half = i >>  8; printhex8a(half);
  4989                                  
  4990                                  ;Function : printhex16, Number of local variables: 2
  4991                                  ;   # type sign width addr used name   list of local variables
  4992                                  ;  200 var unsg word   789 NULL i = bp+4
  4993                                  ;  201 var unsg word   790 NULL half = bp-2;
  4994 00001A21 C8020000                 ENTER  2,0
  4995 00001A25 8B4604                   mov ax, [bp+4]
  4996 00001A28 C1E808                   shr ax, 8
  4997 00001A2B 8946FE                   mov [bp-2], ax
  4998 00001A2E FF76FE                   push word [bp-2]
  4999 00001A31 E89BFF                   call printhex8a
  5000 00001A34 83C402                   add  sp, 2
  5001                                  
  5002                                  ;-792     half = i & 255; printhex8a(half);
  5003                                  
  5004 00001A37 8B4604                   mov ax, [bp+4]
  5005 00001A3A 25FF00                   and ax, 255
  5006 00001A3D 8946FE                   mov [bp-2], ax
  5007 00001A40 FF76FE                   push word [bp-2]
  5008 00001A43 E889FF                   call printhex8a
  5009 00001A46 83C402                   add  sp, 2
  5010                                  
  5011                                  ;-793 }
  5012                                  
  5013                                  
  5014                                  ;-794 int printIntU(unsigned int n) {
  5015 00001A49 C9                       LEAVE
  5016 00001A4A C3                       ret
  5017                                  ENDP
  5018                                  
  5019                                  printIntU: PROC
  5020                                  
  5021                                  ;-795     unsigned int e;
  5022                                  
  5023                                  
  5024                                  ;-796     if ( _ n >= 10) {
  5025                                  
  5026                                  ;Function : printIntU, Number of local variables: 2
  5027                                  ;   # type sign width addr used name   list of local variables
  5028                                  ;  200 var unsg word   794 NULL n = bp+4
  5029                                  ;  201 var unsg word   795 NULL e = bp-2;
  5030 00001A4B C8020000                 ENTER  2,0 ; constant expression
  5031 00001A4F 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5032 00001A53 0F821700                 jb  .printIntU225
  5033                                  
  5034                                  ;-797         e=n/10; //DIV
  5035                                  
  5036 00001A57 8B4604                   mov ax, [bp+4]
  5037 00001A5A BB0A00                   mov bx, 10
  5038 00001A5D BA0000                   mov dx, 0
  5039 00001A60 F7F3                     div bx
  5040 00001A62 8946FE                   mov [bp-2], ax
  5041                                  
  5042                                  ;-798         printIntU(e);
  5043                                  
  5044 00001A65 FF76FE                   push word [bp-2]
  5045 00001A68 E8E0FF                   call printIntU
  5046 00001A6B 83C402                   add  sp, 2
  5047                                  
  5048                                  ;-799     }
  5049                                  
  5050                                  
  5051                                  ;-800     n = n % 10; //unsigned mod
  5052                                  
  5053                                  .printIntU225:
  5054 00001A6E 8B4604                   mov ax, [bp+4]
  5055 00001A71 BB0A00                   mov bx, 10
  5056 00001A74 BA0000                   mov dx, 0
  5057 00001A77 F7F3                     div bx
  5058 00001A79 89D0                     mov ax, dx
  5059 00001A7B 894604                   mov [bp+4], ax
  5060                                  
  5061                                  ;-801     n += '0';
  5062                                  
  5063 00001A7E 83460430                 add  word[bp+4], 48
  5064                                  
  5065                                  ;-802     prc(n);
  5066                                  
  5067 00001A82 FF7604                   push word [bp+4]
  5068 00001A85 E85BFE                   call prc
  5069 00001A88 83C402                   add  sp, 2
  5070                                  
  5071                                  ;-803 }
  5072                                  
  5073                                  
  5074                                  ;-804 
  5075                                  
  5076                                  
  5077                                  ;-805 int error1(char *s) {
  5078 00001A8B C9                       LEAVE
  5079 00001A8C C3                       ret
  5080                                  ENDP
  5081                                  
  5082                                  error1: PROC
  5083                                  
  5084                                  ;-806     ErrorCount++;
  5085                                  
  5086                                  ;Function : error1, Number of local variables: 1
  5087                                  ;   # type sign width addr used name   list of local variables
  5088                                  ;  200 ptr sign byte   805 NULL s = bp+4;
  5089 00001A8D C8000000                 ENTER  0,0
  5090 00001A91 FF06[1E00]               inc  word[ErrorCount]
  5091                                  
  5092                                  ;-807     prs("\n;***** next line ERROR: ");
  5093                                  
  5094 00001A95 68[BD1A]                 push error1_0
  5095 00001A98 E8A0FE                   call prs
  5096 00001A9B 83C402                   add  sp, 2
  5097                                  
  5098                                  ;-808     prs(s);
  5099                                  
  5100 00001A9E FF7604                   push word [bp+4]
  5101 00001AA1 E897FE                   call prs
  5102 00001AA4 83C402                   add  sp, 2
  5103                                  
  5104                                  ;-809     prs(", Symbol: ");
  5105                                  
  5106 00001AA7 68[D81A]                 push error1_1
  5107 00001AAA E88EFE                   call prs
  5108 00001AAD 83C402                   add  sp, 2
  5109                                  
  5110                                  ;-810     prs(Symbol);
  5111                                  
  5112 00001AB0 8D063075                 lea  ax, [Symbol]
  5113 00001AB4 50                       push ax
  5114 00001AB5 E883FE                   call prs
  5115 00001AB8 83C402                   add  sp, 2
  5116                                  
  5117                                  ;-811 }
  5118                                  
  5119                                  
  5120                                  ;-812 int errorexit(char *s) {
  5121 00001ABB C9                       LEAVE
  5122 00001ABC C3                       ret
  5123 00001ABD 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5124 00001AC6 6E657874206C696E65-
  5125 00001ACF 204552524F523A2000 
  5126 00001AD8 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5127 00001AE1 2000               
  5128                                  ENDP
  5129                                  
  5130                                  errorexit: PROC
  5131                                  
  5132                                  ;-813     error1(s);
  5133                                  
  5134                                  ;Function : errorexit, Number of local variables: 1
  5135                                  ;   # type sign width addr used name   list of local variables
  5136                                  ;  200 ptr sign byte   812 NULL s = bp+4;
  5137 00001AE3 C8000000                 ENTER  0,0
  5138 00001AE7 FF7604                   push word [bp+4]
  5139 00001AEA E8A0FF                   call error1
  5140 00001AED 83C402                   add  sp, 2
  5141                                  
  5142                                  ;-814     epilog();
  5143                                  
  5144 00001AF0 E81F05                   call epilog
  5145                                  
  5146                                  ;-815     end1(1);
  5147                                  
  5148 00001AF3 6A01                     push 1
  5149 00001AF5 E81206                   call end1
  5150 00001AF8 83C402                   add  sp, 2
  5151                                  
  5152                                  ;-816 }
  5153                                  
  5154                                  
  5155                                  ;-817 int notfounderror(){error1("label not found"); }
  5156 00001AFB C9                       LEAVE
  5157 00001AFC C3                       ret
  5158                                  ENDP
  5159                                  
  5160                                  notfounderror: PROC
  5161 00001AFD 68[071B]                 push notfounderror_0
  5162 00001B00 E88AFF                   call error1
  5163 00001B03 83C402                   add  sp, 2
  5164                                  
  5165                                  ;-818 int allowederror() {error1("not allowed here"); }
  5166                                  
  5167 00001B06 C3                       ret
  5168 00001B07 6C6162656C206E6F74-     notfounderror_0 db "label not found",0
  5169 00001B10 20666F756E6400     
  5170                                  ENDP
  5171                                  
  5172                                  allowederror: PROC
  5173 00001B17 68[211B]                 push allowederror_0
  5174 00001B1A E870FF                   call error1
  5175 00001B1D 83C402                   add  sp, 2
  5176                                  
  5177                                  ;-819 int addrerror()    {error1("address missing");}
  5178                                  
  5179 00001B20 C3                       ret
  5180 00001B21 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5181 00001B2A 6564206865726500   
  5182                                  ENDP
  5183                                  
  5184                                  addrerror: PROC
  5185 00001B32 68[3C1B]                 push addrerror_0
  5186 00001B35 E855FF                   call error1
  5187 00001B38 83C402                   add  sp, 2
  5188                                  
  5189                                  ;-820 int immeerror()    {error1("immediate not allowed here");}
  5190                                  
  5191 00001B3B C3                       ret
  5192 00001B3C 61646472657373206D-     addrerror_0 db "address missing",0
  5193 00001B45 697373696E6700     
  5194                                  ENDP
  5195                                  
  5196                                  immeerror: PROC
  5197 00001B4C 68[561B]                 push immeerror_0
  5198 00001B4F E83BFF                   call error1
  5199 00001B52 83C402                   add  sp, 2
  5200                                  
  5201                                  ;-821 int implerror()    {error1("not implemented");}
  5202                                  
  5203 00001B55 C3                       ret
  5204 00001B56 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5205 00001B5F 206E6F7420616C6C6F-
  5206 00001B68 776564206865726500 
  5207                                  ENDP
  5208                                  
  5209                                  implerror: PROC
  5210 00001B71 68[7B1B]                 push implerror_0
  5211 00001B74 E816FF                   call error1
  5212 00001B77 83C402                   add  sp, 2
  5213                                  
  5214                                  ;-822 int indexerror()   {error1("invalid index register");}
  5215                                  
  5216 00001B7A C3                       ret
  5217 00001B7B 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5218 00001B84 6D656E74656400     
  5219                                  ENDP
  5220                                  
  5221                                  indexerror: PROC
  5222 00001B8B 68[951B]                 push indexerror_0
  5223 00001B8E E8FCFE                   call error1
  5224 00001B91 83C402                   add  sp, 2
  5225                                  
  5226                                  ;-823 int invaloperror() {error1("invalid or no operands");}
  5227                                  
  5228 00001B94 C3                       ret
  5229 00001B95 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5230 00001B9E 6E6465782072656769-
  5231 00001BA7 7374657200         
  5232                                  ENDP
  5233                                  
  5234                                  invaloperror: PROC
  5235 00001BAC 68[B61B]                 push invaloperror_0
  5236 00001BAF E8DBFE                   call error1
  5237 00001BB2 83C402                   add  sp, 2
  5238                                  
  5239                                  ;-824 int numbererror()  {error1("number expected");}
  5240                                  
  5241 00001BB5 C3                       ret
  5242 00001BB6 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5243 00001BBF 72206E6F206F706572-
  5244 00001BC8 616E647300         
  5245                                  ENDP
  5246                                  
  5247                                  numbererror: PROC
  5248 00001BCD 68[D71B]                 push numbererror_0
  5249 00001BD0 E8BAFE                   call error1
  5250 00001BD3 83C402                   add  sp, 2
  5251                                  
  5252                                  ;-825 int regmemerror()  {error1("only register or memory allowed");}
  5253                                  
  5254 00001BD6 C3                       ret
  5255 00001BD7 6E756D626572206578-     numbererror_0 db "number expected",0
  5256 00001BE0 70656374656400     
  5257                                  ENDP
  5258                                  
  5259                                  regmemerror: PROC
  5260 00001BE7 68[F11B]                 push regmemerror_0
  5261 00001BEA E8A0FE                   call error1
  5262 00001BED 83C402                   add  sp, 2
  5263                                  
  5264                                  ;-826 int reg16error()   {error1("only reg16, no segreg allowed");}
  5265                                  
  5266 00001BF0 C3                       ret
  5267 00001BF1 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5268 00001BFA 73746572206F72206D-
  5269 00001C03 656D6F727920616C6C-
  5270 00001C0C 6F77656400         
  5271                                  ENDP
  5272                                  
  5273                                  reg16error: PROC
  5274 00001C11 68[1B1C]                 push reg16error_0
  5275 00001C14 E876FE                   call error1
  5276 00001C17 83C402                   add  sp, 2
  5277                                  
  5278                                  ;-827 int segregerror()  {error1("segment register not allowed");}
  5279                                  
  5280 00001C1A C3                       ret
  5281 00001C1B 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5282 00001C24 362C206E6F20736567-
  5283 00001C2D 72656720616C6C6F77-
  5284 00001C36 656400             
  5285                                  ENDP
  5286                                  
  5287                                  segregerror: PROC
  5288 00001C39 68[431C]                 push segregerror_0
  5289 00001C3C E84EFE                   call error1
  5290 00001C3F 83C402                   add  sp, 2
  5291                                  
  5292                                  ;-828 int syntaxerror()  {error1("syntax");}
  5293                                  
  5294 00001C42 C3                       ret
  5295 00001C43 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5296 00001C4C 65676973746572206E-
  5297 00001C55 6F7420616C6C6F7765-
  5298 00001C5E 6400               
  5299                                  ENDP
  5300                                  
  5301                                  syntaxerror: PROC
  5302 00001C60 68[6A1C]                 push syntaxerror_0
  5303 00001C63 E827FE                   call error1
  5304 00001C66 83C402                   add  sp, 2
  5305                                  
  5306                                  ;-829 
  5307                                  
  5308                                  
  5309                                  ;-830 int addrexit()     {errorexit("illegal address");}
  5310                                  
  5311 00001C69 C3                       ret
  5312 00001C6A 73796E74617800          syntaxerror_0 db "syntax",0
  5313                                  ENDP
  5314                                  
  5315                                  addrexit: PROC
  5316 00001C71 68[7B1C]                 push addrexit_0
  5317 00001C74 E86CFE                   call errorexit
  5318 00001C77 83C402                   add  sp, 2
  5319                                  
  5320                                  ;-831 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5321                                  
  5322 00001C7A C3                       ret
  5323 00001C7B 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5324 00001C84 64647265737300     
  5325                                  ENDP
  5326                                  
  5327                                  dataexit: PROC
  5328 00001C8B 68[951C]                 push dataexit_0
  5329 00001C8E E852FE                   call errorexit
  5330 00001C91 83C402                   add  sp, 2
  5331                                  
  5332                                  ;-832 int internexit()   {errorexit("intern compiler error");}
  5333                                  
  5334 00001C94 C3                       ret
  5335 00001C95 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5336 00001C9E 6F7220524553422C57-
  5337 00001CA7 2C4420657870656374-
  5338 00001CB0 656400             
  5339                                  ENDP
  5340                                  
  5341                                  internexit: PROC
  5342 00001CB3 68[BD1C]                 push internexit_0
  5343 00001CB6 E82AFE                   call errorexit
  5344 00001CB9 83C402                   add  sp, 2
  5345                                  
  5346                                  ;-833 
  5347                                  
  5348                                  
  5349                                  ;-834 
  5350                                  
  5351                                  
  5352                                  ;-835 //#include "MAIN.C"
  5353                                  
  5354                                  
  5355                                  ;-836 int main() {
  5356                                  
  5357 00001CBC C3                       ret
  5358 00001CBD 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5359 00001CC6 6D70696C6572206572-
  5360 00001CCF 726F7200           
  5361                                  ENDP
  5362                                  
  5363                                  main: PROC
  5364                                  
  5365                                  ;-837     getarg();
  5366                                  
  5367 00001CD3 E80D00                   call getarg
  5368                                  
  5369                                  ;-838     parse();
  5370                                  
  5371 00001CD6 E8D4EC                   call parse
  5372                                  
  5373                                  ;-839     fixJmpCall();
  5374                                  
  5375 00001CD9 E84A02                   call fixJmpCall
  5376                                  
  5377                                  ;-840     epilog();
  5378                                  
  5379 00001CDC E83303                   call epilog
  5380                                  
  5381                                  ;-841     end1();
  5382                                  
  5383 00001CDF E82804                   call end1
  5384                                  
  5385                                  ;-842 }
  5386                                  
  5387                                  
  5388                                  ;-843 
  5389                                  
  5390                                  
  5391                                  ;-844 int getarg() {
  5392                                  
  5393 00001CE2 C3                       ret
  5394                                  ENDP
  5395                                  
  5396                                  getarg: PROC
  5397                                  
  5398                                  ;-845     int arglen1; int i; char *c;
  5399                                  
  5400                                  
  5401                                  ;-846     arglen1=*arglen;
  5402                                  
  5403                                  ;Function : getarg, Number of local variables: 3
  5404                                  ;   # type sign width addr used name   list of local variables
  5405                                  ;  200 var sign word   845 NULL arglen1 = bp-2
  5406                                  ;  201 var sign word   845 NULL i = bp-4
  5407                                  ;  202 ptr sign byte   845 NULL c = bp-6;
  5408 00001CE3 C8060000                 ENTER  6,0
  5409 00001CE7 8B1E[5800]               mov bx, [arglen]
  5410 00001CEB 8A07                     mov al, [bx]
  5411 00001CED B400                     mov ah, 0
  5412 00001CEF 8946FE                   mov [bp-2], ax
  5413                                  
  5414                                  ;-847     if (arglen1==0) {
  5415                                  
  5416 00001CF2 8B46FE                   mov ax, [bp-2]
  5417 00001CF5 83F800                   cmp ax, 0
  5418 00001CF8 0F851C00                 jne .getarg226
  5419                                  
  5420                                  ;-848         cputs(Version1);
  5421                                  
  5422 00001CFC 8D06[0300]               lea  ax, [Version1]
  5423 00001D00 50                       push ax
  5424 00001D01 E88FF2                   call cputs
  5425 00001D04 83C402                   add  sp, 2
  5426                                  
  5427                                  ;-849         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5428                                  
  5429 00001D07 68[931E]                 push getarg_0
  5430 00001D0A E886F2                   call cputs
  5431 00001D0D 83C402                   add  sp, 2
  5432                                  
  5433                                  ;-850         exitR(3);
  5434                                  
  5435 00001D10 6A03                     push 3
  5436 00001D12 E8E5F2                   call exitR
  5437 00001D15 83C402                   add  sp, 2
  5438                                  
  5439                                  ;-851     }
  5440                                  
  5441                                  
  5442                                  ;-852     i=arglen1+129;
  5443                                  
  5444                                  .getarg226:
  5445 00001D18 8B46FE                   mov ax, [bp-2]
  5446 00001D1B 058100                   add ax, 129
  5447 00001D1E 8946FC                   mov [bp-4], ax
  5448                                  
  5449                                  ;-853     *i=0;
  5450                                  
  5451 00001D21 B80000                   mov ax, 0
  5452 00001D24 8B5EFC                   mov  bx, [bp-4]
  5453 00001D27 8907                     mov  [bx], ax
  5454                                  
  5455                                  ;-854     arglen1--;
  5456                                  
  5457 00001D29 FF4EFE                   dec  word[bp-2]
  5458                                  
  5459                                  ;-855     toupper(argv);
  5460                                  
  5461 00001D2C FF36[5A00]               push word [argv]
  5462 00001D30 E8FEF5                   call toupper
  5463 00001D33 83C402                   add  sp, 2
  5464                                  
  5465                                  ;-856 
  5466                                  
  5467                                  
  5468                                  ;-857     strcpy(namein, argv); strcat1(namein, ".S");
  5469                                  
  5470 00001D36 FF36[5A00]               push word [argv]
  5471 00001D3A 8D068C76                 lea  ax, [namein]
  5472 00001D3E 50                       push ax
  5473 00001D3F E848F5                   call strcpy
  5474 00001D42 83C404                   add  sp, 4
  5475 00001D45 68[B81E]                 push getarg_1
  5476 00001D48 8D068C76                 lea  ax, [namein]
  5477 00001D4C 50                       push ax
  5478 00001D4D E8BCF5                   call strcat1
  5479 00001D50 83C404                   add  sp, 4
  5480                                  
  5481                                  ;-858     strcpy(namelst,argv); strcat1(namelst,".LST");
  5482                                  
  5483 00001D53 FF36[5A00]               push word [argv]
  5484 00001D57 8D06CF76                 lea  ax, [namelst]
  5485 00001D5B 50                       push ax
  5486 00001D5C E82BF5                   call strcpy
  5487 00001D5F 83C404                   add  sp, 4
  5488 00001D62 68[BB1E]                 push getarg_2
  5489 00001D65 8D06CF76                 lea  ax, [namelst]
  5490 00001D69 50                       push ax
  5491 00001D6A E89FF5                   call strcat1
  5492 00001D6D 83C404                   add  sp, 4
  5493                                  
  5494                                  ;-859     strcpy(namebin,argv); strcat1(namebin,".COM");
  5495                                  
  5496 00001D70 FF36[5A00]               push word [argv]
  5497 00001D74 8D061277                 lea  ax, [namebin]
  5498 00001D78 50                       push ax
  5499 00001D79 E80EF5                   call strcpy
  5500 00001D7C 83C404                   add  sp, 4
  5501 00001D7F 68[C01E]                 push getarg_3
  5502 00001D82 8D061277                 lea  ax, [namebin]
  5503 00001D86 50                       push ax
  5504 00001D87 E882F5                   call strcat1
  5505 00001D8A 83C404                   add  sp, 4
  5506                                  
  5507                                  ;-860 
  5508                                  
  5509                                  
  5510                                  ;-861   DOS_ERR=0; PC=0; ErrorCount=0;
  5511                                  
  5512 00001D8D B80000                   mov ax, 0
  5513 00001D90 A3[1C00]                 mov word [DOS_ERR], ax
  5514 00001D93 B80000                   mov ax, 0
  5515 00001D96 A3[2300]                 mov word [PC], ax
  5516 00001D99 B80000                   mov ax, 0
  5517 00001D9C A3[1E00]                 mov word [ErrorCount], ax
  5518                                  
  5519                                  ;-862 
  5520                                  
  5521                                  
  5522                                  ;-863     asm_fd=openR (namein);
  5523                                  
  5524 00001D9F 8D068C76                 lea  ax, [namein]
  5525 00001DA3 50                       push ax
  5526 00001DA4 E823F2                   call openR
  5527 00001DA7 83C402                   add  sp, 2
  5528 00001DAA A3[1600]                 mov word [asm_fd], ax
  5529                                  
  5530                                  ;-864     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5531                                  
  5532 00001DAD A1[1C00]                 mov ax, [DOS_ERR]
  5533 00001DB0 08C0                     or  al, al
  5534 00001DB2 0F841C00                 je .getarg227
  5535 00001DB6 68[C51E]                 push getarg_4
  5536 00001DB9 E8D7F1                   call cputs
  5537 00001DBC 83C402                   add  sp, 2
  5538 00001DBF 8D068C76                 lea  ax, [namein]
  5539 00001DC3 50                       push ax
  5540 00001DC4 E8CCF1                   call cputs
  5541 00001DC7 83C402                   add  sp, 2
  5542 00001DCA 6A01                     push 1
  5543 00001DCC E82BF2                   call exitR
  5544 00001DCF 83C402                   add  sp, 2
  5545                                  
  5546                                  ;-865     lst_fd=creatR(namelst);
  5547                                  
  5548                                  .getarg227:
  5549 00001DD2 8D06CF76                 lea  ax, [namelst]
  5550 00001DD6 50                       push ax
  5551 00001DD7 E8FFF1                   call creatR
  5552 00001DDA 83C402                   add  sp, 2
  5553 00001DDD A3[1800]                 mov word [lst_fd], ax
  5554                                  
  5555                                  ;-866     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5556                                  
  5557 00001DE0 A1[1C00]                 mov ax, [DOS_ERR]
  5558 00001DE3 08C0                     or  al, al
  5559 00001DE5 0F841C00                 je .getarg228
  5560 00001DE9 68[DB1E]                 push getarg_5
  5561 00001DEC E8A4F1                   call cputs
  5562 00001DEF 83C402                   add  sp, 2
  5563 00001DF2 8D06CF76                 lea  ax, [namelst]
  5564 00001DF6 50                       push ax
  5565 00001DF7 E899F1                   call cputs
  5566 00001DFA 83C402                   add  sp, 2
  5567 00001DFD 6A02                     push 2
  5568 00001DFF E8F8F1                   call exitR
  5569 00001E02 83C402                   add  sp, 2
  5570                                  
  5571                                  ;-867     bin_fd=creatR(namebin);
  5572                                  
  5573                                  .getarg228:
  5574 00001E05 8D061277                 lea  ax, [namebin]
  5575 00001E09 50                       push ax
  5576 00001E0A E8CCF1                   call creatR
  5577 00001E0D 83C402                   add  sp, 2
  5578 00001E10 A3[1A00]                 mov word [bin_fd], ax
  5579                                  
  5580                                  ;-868     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5581                                  
  5582 00001E13 A1[1C00]                 mov ax, [DOS_ERR]
  5583 00001E16 08C0                     or  al, al
  5584 00001E18 0F841C00                 je .getarg229
  5585 00001E1C 68[F21E]                 push getarg_6
  5586 00001E1F E871F1                   call cputs
  5587 00001E22 83C402                   add  sp, 2
  5588 00001E25 8D061277                 lea  ax, [namebin]
  5589 00001E29 50                       push ax
  5590 00001E2A E866F1                   call cputs
  5591 00001E2D 83C402                   add  sp, 2
  5592 00001E30 6A02                     push 2
  5593 00001E32 E8C5F1                   call exitR
  5594 00001E35 83C402                   add  sp, 2
  5595                                  
  5596                                  ;-869 
  5597                                  
  5598                                  
  5599                                  ;-870     prs(";");
  5600                                  
  5601                                  .getarg229:
  5602 00001E38 68[081F]                 push getarg_7
  5603 00001E3B E8FDFA                   call prs
  5604 00001E3E 83C402                   add  sp, 2
  5605                                  
  5606                                  ;-871     prs(Version1);
  5607                                  
  5608 00001E41 8D06[0300]               lea  ax, [Version1]
  5609 00001E45 50                       push ax
  5610 00001E46 E8F2FA                   call prs
  5611 00001E49 83C402                   add  sp, 2
  5612                                  
  5613                                  ;-872     prs(", Source: "); prs(namein);
  5614                                  
  5615 00001E4C 68[0A1F]                 push getarg_8
  5616 00001E4F E8E9FA                   call prs
  5617 00001E52 83C402                   add  sp, 2
  5618 00001E55 8D068C76                 lea  ax, [namein]
  5619 00001E59 50                       push ax
  5620 00001E5A E8DEFA                   call prs
  5621 00001E5D 83C402                   add  sp, 2
  5622                                  
  5623                                  ;-873     prs(", Output: "); prs(namelst);
  5624                                  
  5625 00001E60 68[151F]                 push getarg_9
  5626 00001E63 E8D5FA                   call prs
  5627 00001E66 83C402                   add  sp, 2
  5628 00001E69 8D06CF76                 lea  ax, [namelst]
  5629 00001E6D 50                       push ax
  5630 00001E6E E8CAFA                   call prs
  5631 00001E71 83C402                   add  sp, 2
  5632                                  
  5633                                  ;-874     prs(", "); prs(namebin);
  5634                                  
  5635 00001E74 68[201F]                 push getarg_10
  5636 00001E77 E8C1FA                   call prs
  5637 00001E7A 83C402                   add  sp, 2
  5638 00001E7D 8D061277                 lea  ax, [namebin]
  5639 00001E81 50                       push ax
  5640 00001E82 E8B6FA                   call prs
  5641 00001E85 83C402                   add  sp, 2
  5642                                  
  5643                                  ;-875     prs("\n");
  5644                                  
  5645 00001E88 68[231F]                 push getarg_11
  5646 00001E8B E8ADFA                   call prs
  5647 00001E8E 83C402                   add  sp, 2
  5648                                  
  5649                                  ;-876 }
  5650                                  
  5651                                  
  5652                                  ;-877 
  5653                                  
  5654                                  
  5655                                  ;-878 int fixJmpCall() {
  5656 00001E91 C9                       LEAVE
  5657 00001E92 C3                       ret
  5658 00001E93 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5659 00001E9C 41532E434F4D206669-
  5660 00001EA5 6C656E616D65205B77-
  5661 00001EAE 2F6F202E535D203A20-
  5662 00001EB7 00                 
  5663 00001EB8 2E5300                  getarg_1 db ".S",0
  5664 00001EBB 2E4C535400              getarg_2 db ".LST",0
  5665 00001EC0 2E434F4D00              getarg_3 db ".COM",0
  5666 00001EC5 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5667 00001ECE 6C65206D697373696E-
  5668 00001ED7 673A2000           
  5669 00001EDB 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5670 00001EE4 206E6F742063726561-
  5671 00001EED 74653A2000         
  5672 00001EF2 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5673 00001EFB 6E6F74206372656174-
  5674 00001F04 653A2000           
  5675 00001F08 3B00                    getarg_7 db ";",0
  5676 00001F0A 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5677 00001F13 2000               
  5678 00001F15 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5679 00001F1E 2000               
  5680 00001F20 2C2000                  getarg_10 db ", ",0
  5681 00001F23 5C6E00                  getarg_11 db "\n",0
  5682                                  ENDP
  5683                                  
  5684                                  fixJmpCall: PROC
  5685                                  
  5686                                  ;-879     int i;  unsigned int hex;  char *p; int Ix; char c;
  5687                                  
  5688                                  
  5689                                  ;-880     i=1;
  5690                                  
  5691                                  ;Function : fixJmpCall, Number of local variables: 5
  5692                                  ;   # type sign width addr used name   list of local variables
  5693                                  ;  200 var sign word   879 NULL i = bp-2
  5694                                  ;  201 var unsg word   879 NULL hex = bp-4
  5695                                  ;  202 ptr sign byte   879 NULL p = bp-6
  5696                                  ;  203 var sign word   879 NULL Ix = bp-8
  5697                                  ;  204 var sign byte   879 NULL c = bp-10;
  5698 00001F26 C80A0000                 ENTER  10,0
  5699 00001F2A B80100                   mov ax, 1
  5700 00001F2D 8946FE                   mov [bp-2], ax
  5701                                  
  5702                                  ;-881     prs("\n;END open jmp/call: ");
  5703                                  
  5704 00001F30 68[EB1F]                 push fixJmpCall_0
  5705 00001F33 E805FA                   call prs
  5706 00001F36 83C402                   add  sp, 2
  5707                                  
  5708                                  ;-882     printIntU(JmpCallMaxIx);
  5709                                  
  5710 00001F39 FF36[5400]               push word [JmpCallMaxIx]
  5711 00001F3D E80BFB                   call printIntU
  5712 00001F40 83C402                   add  sp, 2
  5713                                  
  5714                                  ;-883     p = &JmpCallNames;
  5715                                  
  5716 00001F43 B8728C                   mov ax, JmpCallNames
  5717 00001F46 8946FA                   mov [bp-6], ax
  5718                                  
  5719                                  ;-884     while (i <= JmpCallMaxIx) {
  5720                                  
  5721                                  .fixJmpCall230:
  5722 00001F49 8B46FE                   mov ax, [bp-2]
  5723 00001F4C 3B06[5400]               cmp ax, [JmpCallMaxIx]
  5724 00001F50 0F8F9500                 jg  .fixJmpCall231
  5725                                  
  5726                                  ;-885         strcpy(Symbol, p);
  5727                                  
  5728 00001F54 FF76FA                   push word [bp-6]
  5729 00001F57 8D063075                 lea  ax, [Symbol]
  5730 00001F5B 50                       push ax
  5731 00001F5C E82BF3                   call strcpy
  5732 00001F5F 83C404                   add  sp, 4
  5733                                  
  5734                                  ;-886         p = strlen(Symbol) + p;
  5735                                  
  5736 00001F62 8D063075                 lea  ax, [Symbol]
  5737 00001F66 50                       push ax
  5738 00001F67 E8F8F2                   call strlen
  5739 00001F6A 83C402                   add  sp, 2
  5740 00001F6D 0346FA                   add ax, [bp-6]
  5741 00001F70 8946FA                   mov [bp-6], ax
  5742                                  
  5743                                  ;-887         p++;
  5744                                  
  5745 00001F73 FF46FA                   inc  word[bp-6]
  5746                                  
  5747                                  ;-888 //        prs(Symbol);
  5748                                  
  5749                                  
  5750                                  ;-889 //        prc(' ');
  5751                                  
  5752                                  
  5753                                  ;-890         hex = JmpCallAddr[i];
  5754                                  
  5755 00001F76 8B5EFE                   mov bx, [bp-2]
  5756 00001F79 D1E3                     shl bx, 1
  5757 00001F7B 8B874294                 mov ax, [JmpCallAddr + bx]
  5758 00001F7F 8946FC                   mov [bp-4], ax
  5759                                  
  5760                                  ;-891 //        printhex16(hex);
  5761                                  
  5762                                  
  5763                                  ;-892 
  5764                                  
  5765                                  
  5766                                  ;-893         Ix=searchLabel();
  5767                                  
  5768 00001F82 E8F9EC                   call searchLabel
  5769 00001F85 8946F8                   mov [bp-8], ax
  5770                                  
  5771                                  ;-894         if (Ix == 0) error1("Label not found");
  5772                                  
  5773 00001F88 8B46F8                   mov ax, [bp-8]
  5774 00001F8B 83F800                   cmp ax, 0
  5775 00001F8E 0F850900                 jne .fixJmpCall232
  5776 00001F92 68[0220]                 push fixJmpCall_1
  5777 00001F95 E8F5FA                   call error1
  5778 00001F98 83C402                   add  sp, 2
  5779                                  
  5780                                  ;-895         disp = LabelAddr[Ix];
  5781                                  
  5782                                  .fixJmpCall232:
  5783 00001F9B 8B5EF8                   mov bx, [bp-8]
  5784 00001F9E D1E3                     shl bx, 1
  5785 00001FA0 8B87FA86                 mov ax, [LabelAddr + bx]
  5786 00001FA4 A3[3D00]                 mov word [disp], ax
  5787                                  
  5788                                  ;-896         disp = disp - hex;
  5789                                  
  5790 00001FA7 A1[3D00]                 mov ax, [disp]
  5791 00001FAA 2B46FC                   sub ax, [bp-4]
  5792 00001FAD A3[3D00]                 mov word [disp], ax
  5793                                  
  5794                                  ;-897         disp = disp - Origin;
  5795                                  
  5796 00001FB0 A1[3D00]                 mov ax, [disp]
  5797 00001FB3 2B06[2500]               sub ax, [Origin]
  5798 00001FB7 A3[3D00]                 mov word [disp], ax
  5799                                  
  5800                                  ;-898 //        prs(", ");
  5801                                  
  5802                                  
  5803                                  ;-899 
  5804                                  
  5805                                  
  5806                                  ;-900             hex = hex - 2;//fix at start of word
  5807                                  
  5808 00001FBA 8B46FC                   mov ax, [bp-4]
  5809 00001FBD 83E802                   sub ax, 2
  5810 00001FC0 8946FC                   mov [bp-4], ax
  5811                                  
  5812                                  ;-901             FileBin[hex] = disp;//fix low byte
  5813                                  
  5814 00001FC3 A1[3D00]                 mov ax, [disp]
  5815 00001FC6 8B5EFC                   mov bx, [bp-4]
  5816 00001FC9 88872A98                 mov [FileBin+bx], al
  5817                                  
  5818                                  ;-902             hex++;
  5819                                  
  5820 00001FCD FF46FC                   inc  word[bp-4]
  5821                                  
  5822                                  ;-903             disp = disp >> 8;
  5823                                  
  5824 00001FD0 A1[3D00]                 mov ax, [disp]
  5825 00001FD3 C1E808                   shr ax, 8
  5826 00001FD6 A3[3D00]                 mov word [disp], ax
  5827                                  
  5828                                  ;-904             FileBin[hex] = disp;
  5829                                  
  5830 00001FD9 A1[3D00]                 mov ax, [disp]
  5831 00001FDC 8B5EFC                   mov bx, [bp-4]
  5832 00001FDF 88872A98                 mov [FileBin+bx], al
  5833                                  
  5834                                  ;-905         i++;
  5835                                  
  5836 00001FE3 FF46FE                   inc  word[bp-2]
  5837                                  
  5838                                  ;-906     }
  5839                                  
  5840                                  
  5841                                  ;-907 }
  5842                                  
  5843 00001FE6 E960FF                   jmp .fixJmpCall230
  5844                                  .fixJmpCall231:
  5845                                  
  5846                                  ;-908 
  5847                                  
  5848                                  
  5849                                  ;-909 int epilog() {
  5850 00001FE9 C9                       LEAVE
  5851 00001FEA C3                       ret
  5852 00001FEB 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5853 00001FF4 656E206A6D702F6361-
  5854 00001FFD 6C6C3A2000         
  5855 00002002 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5856 0000200B 20666F756E6400     
  5857                                  ENDP
  5858                                  
  5859                                  epilog: PROC
  5860                                  
  5861                                  ;-910     unsigned int i; char c;     int j;
  5862                                  
  5863                                  
  5864                                  ;-911     prs("\n Errors: ");
  5865                                  
  5866                                  ;Function : epilog, Number of local variables: 3
  5867                                  ;   # type sign width addr used name   list of local variables
  5868                                  ;  200 var unsg word   910 NULL i = bp-2
  5869                                  ;  201 var sign byte   910 NULL c = bp-4
  5870                                  ;  202 var sign word   910 NULL j = bp-6;
  5871 00002012 C8060000                 ENTER  6,0
  5872 00002016 68[CD20]                 push epilog_0
  5873 00002019 E81FF9                   call prs
  5874 0000201C 83C402                   add  sp, 2
  5875                                  
  5876                                  ;-912     printIntU(ErrorCount);
  5877                                  
  5878 0000201F FF36[1E00]               push word [ErrorCount]
  5879 00002023 E825FA                   call printIntU
  5880 00002026 83C402                   add  sp, 2
  5881                                  
  5882                                  ;-913     if (ErrorCount) prs(" ***ERROR*** ");
  5883                                  
  5884 00002029 A1[1E00]                 mov ax, [ErrorCount]
  5885 0000202C 08C0                     or  al, al
  5886 0000202E 0F840900                 je .epilog233
  5887 00002032 68[D920]                 push epilog_1
  5888 00002035 E803F9                   call prs
  5889 00002038 83C402                   add  sp, 2
  5890                                  
  5891                                  ;-914     prs(", Out: ");
  5892                                  
  5893                                  .epilog233:
  5894 0000203B 68[E720]                 push epilog_2
  5895 0000203E E8FAF8                   call prs
  5896 00002041 83C402                   add  sp, 2
  5897                                  
  5898                                  ;-915     prs(namelst);
  5899                                  
  5900 00002044 8D06CF76                 lea  ax, [namelst]
  5901 00002048 50                       push ax
  5902 00002049 E8EFF8                   call prs
  5903 0000204C 83C402                   add  sp, 2
  5904                                  
  5905                                  ;-916     prs(", ");
  5906                                  
  5907 0000204F 68[EF20]                 push epilog_3
  5908 00002052 E8E6F8                   call prs
  5909 00002055 83C402                   add  sp, 2
  5910                                  
  5911                                  ;-917     prs(namebin);
  5912                                  
  5913 00002058 8D061277                 lea  ax, [namebin]
  5914 0000205C 50                       push ax
  5915 0000205D E8DBF8                   call prs
  5916 00002060 83C402                   add  sp, 2
  5917                                  
  5918                                  ;-918     prs("= ");
  5919                                  
  5920 00002063 68[F220]                 push epilog_4
  5921 00002066 E8D2F8                   call prs
  5922 00002069 83C402                   add  sp, 2
  5923                                  
  5924                                  ;-919     printIntU(BinLen);
  5925                                  
  5926 0000206C FF36[5600]               push word [BinLen]
  5927 00002070 E8D8F9                   call printIntU
  5928 00002073 83C402                   add  sp, 2
  5929                                  
  5930                                  ;-920     prs(" bytes.");
  5931                                  
  5932 00002076 68[F520]                 push epilog_5
  5933 00002079 E8BFF8                   call prs
  5934 0000207C 83C402                   add  sp, 2
  5935                                  
  5936                                  ;-921 
  5937                                  
  5938                                  
  5939                                  ;-922     i=0;
  5940                                  
  5941 0000207F B80000                   mov ax, 0
  5942 00002082 8946FE                   mov [bp-2], ax
  5943                                  
  5944                                  ;-923     do {
  5945                                  
  5946                                  .epilog234:
  5947                                  
  5948                                  ;-924         c = FileBin[i];
  5949                                  
  5950 00002085 8B5EFE                   mov bx, [bp-2]
  5951 00002088 8A872A98                 mov al, [FileBin + bx]
  5952 0000208C 8846FC                   mov [bp-4], al
  5953                                  
  5954                                  ;-925         fputcR(c, bin_fd);
  5955                                  
  5956 0000208F FF36[1A00]               push word [bin_fd]
  5957 00002093 8A46FC                   mov al, byte [bp-4]
  5958 00002096 B400                     mov ah, 0
  5959 00002098 50                       push ax
  5960 00002099 E881EF                   call fputcR
  5961 0000209C 83C404                   add  sp, 4
  5962                                  
  5963                                  ;-926 //printhex8a(c); prc(' ');
  5964                                  
  5965                                  
  5966                                  ;-927         i++;
  5967                                  
  5968 0000209F FF46FE                   inc  word[bp-2]
  5969                                  
  5970                                  ;-928     } while (i < BinLen);
  5971                                  
  5972 000020A2 8B46FE                   mov ax, [bp-2]
  5973 000020A5 3B06[5600]               cmp ax, [BinLen]
  5974 000020A9 0F8D0200                 jge .epilog235
  5975 000020AD EBD6                     jmp .epilog234
  5976                                  .epilog235:
  5977                                  
  5978                                  ;-929 
  5979                                  
  5980                                  
  5981                                  ;-930   prs(" Labels: ");
  5982                                  
  5983 000020AF 68[FD20]                 push epilog_6
  5984 000020B2 E886F8                   call prs
  5985 000020B5 83C402                   add  sp, 2
  5986                                  
  5987                                  ;-931   printIntU(LabelMaxIx);
  5988                                  
  5989 000020B8 FF36[4A00]               push word [LabelMaxIx]
  5990 000020BC E88CF9                   call printIntU
  5991 000020BF 83C402                   add  sp, 2
  5992                                  
  5993                                  ;-932   prs(". ");
  5994                                  
  5995 000020C2 68[0721]                 push epilog_7
  5996 000020C5 E873F8                   call prs
  5997 000020C8 83C402                   add  sp, 2
  5998                                  
  5999                                  ;-933 /*
  6000                                  
  6001                                  
  6002                                  ;-934   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);
  6003                                  
  6004                                  
  6005                                  ;-935   i= &LabelNames;
  6006                                  
  6007                                  
  6008                                  ;-936   prs(" &LabelNames:"); printIntU(i);
  6009                                  
  6010                                  
  6011                                  ;-937   i=LabelNamePtr-i;
  6012                                  
  6013                                  
  6014                                  ;-938   prs("size: ");
  6015                                  
  6016                                  
  6017                                  ;-939   printIntU(i);
  6018                                  
  6019                                  
  6020                                  ;-940   prs(". >>");
  6021                                  
  6022                                  
  6023                                  ;-941   i= &LabelNames;
  6024                                  
  6025                                  
  6026                                  ;-942   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6027                                  
  6028                                  
  6029                                  ;-943   } while (i < LabelNamePtr); prs("<< \n");
  6030                                  
  6031                                  
  6032                                  ;-944    i = 1;
  6033                                  
  6034                                  
  6035                                  ;-945     LabelNamePtr= &LabelNames;
  6036                                  
  6037                                  
  6038                                  ;-946     do {
  6039                                  
  6040                                  
  6041                                  ;-947       prs(LabelNamePtr); prc(' ');
  6042                                  
  6043                                  
  6044                                  ;-948       j=LabelAddr[i]; printhex16(j); prs(", ");
  6045                                  
  6046                                  
  6047                                  ;-949       j=strlen(LabelNamePtr);//get end of actual name
  6048                                  
  6049                                  
  6050                                  ;-950       LabelNamePtr=LabelNamePtr+j;
  6051                                  
  6052                                  
  6053                                  ;-951       LabelNamePtr++;
  6054                                  
  6055                                  
  6056                                  ;-952       i++;
  6057                                  
  6058                                  
  6059                                  ;-953     } while (i <= LabelMaxIx);
  6060                                  
  6061                                  
  6062                                  ;-954 */
  6063                                  
  6064                                  
  6065                                  ;-955 }
  6066                                  
  6067                                  
  6068                                  ;-956 
  6069                                  
  6070                                  
  6071                                  ;-957 int end1(int n) {
  6072 000020CB C9                       LEAVE
  6073 000020CC C3                       ret
  6074 000020CD 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6075 000020D6 3A2000             
  6076 000020D9 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6077 000020E2 2A2A2A2000         
  6078 000020E7 2C204F75743A2000        epilog_2 db ", Out: ",0
  6079 000020EF 2C2000                  epilog_3 db ", ",0
  6080 000020F2 3D2000                  epilog_4 db "= ",0
  6081 000020F5 2062797465732E00        epilog_5 db " bytes.",0
  6082 000020FD 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6083 00002106 00                 
  6084 00002107 2E2000                  epilog_7 db ". ",0
  6085                                  ENDP
  6086                                  
  6087                                  end1: PROC
  6088                                  
  6089                                  ;-958     fcloseR(asm_fd);
  6090                                  
  6091                                  ;Function : end1, Number of local variables: 1
  6092                                  ;   # type sign width addr used name   list of local variables
  6093                                  ;  200 var sign word   957 NULL n = bp+4;
  6094 0000210A C8000000                 ENTER  0,0
  6095 0000210E FF36[1600]               push word [asm_fd]
  6096 00002112 E8D6EE                   call fcloseR
  6097 00002115 83C402                   add  sp, 2
  6098                                  
  6099                                  ;-959     fcloseR(lst_fd);
  6100                                  
  6101 00002118 FF36[1800]               push word [lst_fd]
  6102 0000211C E8CCEE                   call fcloseR
  6103 0000211F 83C402                   add  sp, 2
  6104                                  
  6105                                  ;-960     fcloseR(bin_fd);
  6106                                  
  6107 00002122 FF36[1A00]               push word [bin_fd]
  6108 00002126 E8C2EE                   call fcloseR
  6109 00002129 83C402                   add  sp, 2
  6110                                  
  6111                                  ;-961     exitR(n);
  6112                                  
  6113 0000212C FF7604                   push word [bp+4]
  6114 0000212F E8C8EE                   call exitR
  6115 00002132 83C402                   add  sp, 2
  6116                                  
  6117                                  ;-962 }
  6118                                  
  6119                                  
  6120                                  ;-963 
  6121                                  
  6122                                  
  6123                                  ;-964 
  6124                                  
  6125                                  
  6126                                  ;-965 //#include "GENCODE.C"
  6127                                  
  6128                                  
  6129                                  ;-966 // generate code
  6130                                  
  6131                                  
  6132                                  ;-967 int getCodes() {
  6133 00002135 C9                       LEAVE
  6134 00002136 C3                       ret
  6135                                  ENDP
  6136                                  
  6137                                  getCodes: PROC
  6138                                  
  6139                                  ;-968     OpCodePtr ++; Code1 = *OpCodePtr;
  6140                                  
  6141 00002137 FF06[4300]               inc  word[OpCodePtr]
  6142 0000213B 8B1E[4300]               mov bx, [OpCodePtr]
  6143 0000213F 8A07                     mov al, [bx]
  6144 00002141 B400                     mov ah, 0
  6145 00002143 A2[3000]                 mov byte [Code1], al
  6146                                  
  6147                                  ;-969     OpCodePtr ++; Code2 = *OpCodePtr;
  6148                                  
  6149 00002146 FF06[4300]               inc  word[OpCodePtr]
  6150 0000214A 8B1E[4300]               mov bx, [OpCodePtr]
  6151 0000214E 8A07                     mov al, [bx]
  6152 00002150 B400                     mov ah, 0
  6153 00002152 A2[3100]                 mov byte [Code2], al
  6154                                  
  6155                                  ;-970     OpCodePtr ++; Code3 = *OpCodePtr;
  6156                                  
  6157 00002155 FF06[4300]               inc  word[OpCodePtr]
  6158 00002159 8B1E[4300]               mov bx, [OpCodePtr]
  6159 0000215D 8A07                     mov al, [bx]
  6160 0000215F B400                     mov ah, 0
  6161 00002161 A2[3200]                 mov byte [Code3], al
  6162                                  
  6163                                  ;-971 }
  6164                                  
  6165                                  
  6166                                  ;-972 int gen66h() {genCode8(0x66);
  6167                                  
  6168 00002164 C3                       ret
  6169                                  ENDP
  6170                                  
  6171                                  gen66h: PROC
  6172 00002165 6A66                     push 102
  6173 00002167 E83B00                   call genCode8
  6174 0000216A 83C402                   add  sp, 2
  6175                                  
  6176                                  ;-973 }
  6177                                  
  6178                                  
  6179                                  ;-974 int genCode2(char c, char d) {
  6180                                  
  6181 0000216D C3                       ret
  6182                                  ENDP
  6183                                  
  6184                                  genCode2: PROC
  6185                                  
  6186                                  ;-975     c = c + d;
  6187                                  
  6188                                  ;Function : genCode2, Number of local variables: 2
  6189                                  ;   # type sign width addr used name   list of local variables
  6190                                  ;  200 var sign byte   974 NULL c = bp+4
  6191                                  ;  201 var sign byte   974 NULL d = bp+6;
  6192 0000216E C8000000                 ENTER  0,0
  6193 00002172 8A4604                   mov al, [bp+4]
  6194 00002175 024606                   add al, [bp+6]
  6195 00002178 884604                   mov [bp+4], al
  6196                                  
  6197                                  ;-976     genCode8(c);
  6198                                  
  6199 0000217B 8A4604                   mov al, byte [bp+4]
  6200 0000217E B400                     mov ah, 0
  6201 00002180 50                       push ax
  6202 00002181 E82100                   call genCode8
  6203 00002184 83C402                   add  sp, 2
  6204                                  
  6205                                  ;-977 }
  6206                                  
  6207                                  
  6208                                  ;-978 int genCodeW(char c) {
  6209 00002187 C9                       LEAVE
  6210 00002188 C3                       ret
  6211                                  ENDP
  6212                                  
  6213                                  genCodeW: PROC
  6214                                  
  6215                                  ;-979     c = c + wflag;
  6216                                  
  6217                                  ;Function : genCodeW, Number of local variables: 1
  6218                                  ;   # type sign width addr used name   list of local variables
  6219                                  ;  200 var sign byte   978 NULL c = bp+4;
  6220 00002189 C8000000                 ENTER  0,0
  6221 0000218D 8A4604                   mov al, [bp+4]
  6222 00002190 0206[3800]               add al, [wflag]
  6223 00002194 884604                   mov [bp+4], al
  6224                                  
  6225                                  ;-980     genCode8(c);
  6226                                  
  6227 00002197 8A4604                   mov al, byte [bp+4]
  6228 0000219A B400                     mov ah, 0
  6229 0000219C 50                       push ax
  6230 0000219D E80500                   call genCode8
  6231 000021A0 83C402                   add  sp, 2
  6232                                  
  6233                                  ;-981 }
  6234                                  
  6235                                  
  6236                                  ;-982 int genCode8(char c) {
  6237 000021A3 C9                       LEAVE
  6238 000021A4 C3                       ret
  6239                                  ENDP
  6240                                  
  6241                                  genCode8: PROC
  6242                                  
  6243                                  ;-983 //set: BinLen++, OpPrintIndex++
  6244                                  
  6245                                  
  6246                                  ;-984     FileBin[BinLen]=c;
  6247                                  
  6248                                  ;Function : genCode8, Number of local variables: 1
  6249                                  ;   # type sign width addr used name   list of local variables
  6250                                  ;  200 var sign byte   982 NULL c = bp+4;
  6251 000021A5 C8000000                 ENTER  0,0
  6252 000021A9 8A4604                   mov al, [bp+4]
  6253 000021AC 8B1E[5600]               mov bx, [BinLen]
  6254 000021B0 88872A98                 mov [FileBin+bx], al
  6255                                  
  6256                                  ;-985     BinLen++;
  6257                                  
  6258 000021B4 FF06[5600]               inc  word[BinLen]
  6259                                  
  6260                                  ;-986     PC++;
  6261                                  
  6262 000021B8 FF06[2300]               inc  word[PC]
  6263                                  
  6264                                  ;-987     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6265                                  
  6266 000021BC A1[5600]                 mov ax, [BinLen]
  6267 000021BF 3D204E                   cmp ax, 20000 ;unsigned : 0
  6268 000021C2 0F820900                 jb  .genCode8236
  6269 000021C6 68[EA21]                 push genCode8_0
  6270 000021C9 E817F9                   call errorexit
  6271 000021CC 83C402                   add  sp, 2
  6272                                  
  6273                                  ;-988     if (OpPrintIndex < OPMAXLEN) {
  6274                                  
  6275                                  .genCode8236:
  6276 000021CF A1[4100]                 mov ax, [OpPrintIndex]
  6277 000021D2 83F805                   cmp ax, 5
  6278 000021D5 0F8D0F00                 jge .genCode8237
  6279                                  
  6280                                  ;-989         OpPos[OpPrintIndex]=c;
  6281                                  
  6282 000021D9 8A4604                   mov al, [bp+4]
  6283 000021DC 8B1E[4100]               mov bx, [OpPrintIndex]
  6284 000021E0 88875577                 mov [OpPos+bx], al
  6285                                  
  6286                                  ;-990         OpPrintIndex++;
  6287                                  
  6288 000021E4 FF06[4100]               inc  word[OpPrintIndex]
  6289                                  
  6290                                  ;-991     }
  6291                                  
  6292                                  
  6293                                  ;-992 }
  6294                                  
  6295                                  .genCode8237:
  6296                                  
  6297                                  ;-993 int genCode16(unsigned int i) {
  6298 000021E8 C9                       LEAVE
  6299 000021E9 C3                       ret
  6300 000021EA 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6301 000021F3 746F6F206C6F6E6700 
  6302                                  ENDP
  6303                                  
  6304                                  genCode16: PROC
  6305                                  
  6306                                  ;-994     genCode8(i); i=i >> 8;
  6307                                  
  6308                                  ;Function : genCode16, Number of local variables: 1
  6309                                  ;   # type sign width addr used name   list of local variables
  6310                                  ;  200 var unsg word   993 NULL i = bp+4;
  6311 000021FC C8000000                 ENTER  0,0
  6312 00002200 FF7604                   push word [bp+4]
  6313 00002203 E89FFF                   call genCode8
  6314 00002206 83C402                   add  sp, 2
  6315 00002209 8B4604                   mov ax, [bp+4]
  6316 0000220C C1E808                   shr ax, 8
  6317 0000220F 894604                   mov [bp+4], ax
  6318                                  
  6319                                  ;-995     genCode8(i);
  6320                                  
  6321 00002212 FF7604                   push word [bp+4]
  6322 00002215 E88DFF                   call genCode8
  6323 00002218 83C402                   add  sp, 2
  6324                                  
  6325                                  ;-996 }
  6326                                  
  6327                                  
  6328                                  ;-997 int genCode32(unsigned long L) {
  6329 0000221B C9                       LEAVE
  6330 0000221C C3                       ret
  6331                                  ENDP
  6332                                  
  6333                                  genCode32: PROC
  6334                                  
  6335                                  ;-998     genCode16(L); L=L >>16;
  6336                                  
  6337                                  ;Function : genCode32, Number of local variables: 1
  6338                                  ;   # type sign width addr used name   list of local variables
  6339                                  ;  200 var unsg dwrd   997 NULL L = bp+4;
  6340 0000221D C8000000                 ENTER  0,0
  6341 00002221 8A4604                   mov al, byte [bp+4]
  6342 00002224 B400                     mov ah, 0
  6343 00002226 50                       push ax
  6344 00002227 E8D2FF                   call genCode16
  6345 0000222A 83C402                   add  sp, 2
  6346 0000222D 668B4604                 mov eax, [bp+4]
  6347 00002231 66C1E810                 shr eax, 16
  6348 00002235 66894604                 mov [bp+4], eax
  6349                                  
  6350                                  ;-999     genCode16(L);
  6351                                  
  6352 00002239 8A4604                   mov al, byte [bp+4]
  6353 0000223C B400                     mov ah, 0
  6354 0000223E 50                       push ax
  6355 0000223F E8BAFF                   call genCode16
  6356 00002242 83C402                   add  sp, 2
  6357                                  
  6358                                  ;-1000 }
  6359                                  
  6360                                  
  6361                                  ;-1001 int writeEA(char xxx) {//value for reg/operand
  6362 00002245 C9                       LEAVE
  6363 00002246 C3                       ret
  6364                                  ENDP
  6365                                  
  6366                                  writeEA: PROC
  6367                                  
  6368                                  ;-1002 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6369                                  
  6370                                  
  6371                                  ;-1003 //mod-bits: mode76, reg/opcode543, r/m210
  6372                                  
  6373                                  
  6374                                  ;-1004 //Op: 0, IMM, REG, ADR, MEM
  6375                                  
  6376                                  
  6377                                  ;-1005     char len;
  6378                                  
  6379                                  
  6380                                  ;-1006     len=0;
  6381                                  
  6382                                  ;Function : writeEA, Number of local variables: 2
  6383                                  ;   # type sign width addr used name   list of local variables
  6384                                  ;  200 var sign byte  1001 NULL xxx = bp+4
  6385                                  ;  201 var sign byte  1005 NULL len = bp-2;
  6386 00002247 C8020000                 ENTER  2,0
  6387 0000224B B80000                   mov ax, 0
  6388 0000224E 8846FE                   mov [bp-2], al
  6389                                  
  6390                                  ;-1007     xxx = xxx << 3;//in reg/opcode field
  6391                                  
  6392 00002251 8A4604                   mov al, [bp+4]
  6393 00002254 C0E003                   shl al, 3
  6394 00002257 884604                   mov [bp+4], al
  6395                                  
  6396                                  ;-1008     if (Op == REG) {
  6397                                  
  6398 0000225A A0[2D00]                 mov al, [Op]
  6399 0000225D 3C02                     cmp al, 2
  6400 0000225F 0F853A00                 jne .writeEA238
  6401                                  
  6402                                  ;-1009         xxx |= 0xC0;
  6403                                  
  6404 00002263 804E04C0                 or  byte[bp+4], 192
  6405                                  
  6406                                  ;-1010         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  6407                                  
  6408 00002267 A0[2E00]                 mov al, [Op2]
  6409 0000226A 3C01                     cmp al, 1
  6410 0000226C 0F8F0D00                 jg  .writeEA239
  6411 00002270 8A4604                   mov al, [bp+4]
  6412 00002273 0206[3400]               add al, [R1No]
  6413 00002277 884604                   mov [bp+4], al
  6414                                  
  6415                                  ;-1011             else {
  6416                                  
  6417 0000227A E92000                   jmp .writeEA240
  6418                                  .writeEA239:
  6419                                  
  6420                                  ;-1012                 if (Op2 == REG) xxx = xxx + R1No;
  6421                                  
  6422 0000227D A0[2E00]                 mov al, [Op2]
  6423 00002280 3C02                     cmp al, 2
  6424 00002282 0F850D00                 jne .writeEA241
  6425 00002286 8A4604                   mov al, [bp+4]
  6426 00002289 0206[3400]               add al, [R1No]
  6427 0000228D 884604                   mov [bp+4], al
  6428                                  
  6429                                  ;-1013                 else            xxx = xxx + R2No;
  6430                                  
  6431 00002290 E90A00                   jmp .writeEA242
  6432                                  .writeEA241:
  6433 00002293 8A4604                   mov al, [bp+4]
  6434 00002296 0206[3300]               add al, [R2No]
  6435 0000229A 884604                   mov [bp+4], al
  6436                                  
  6437                                  ;-1014             }
  6438                                  
  6439                                  .writeEA242:
  6440                                  
  6441                                  ;-1015         }
  6442                                  
  6443                                  .writeEA240:
  6444                                  
  6445                                  ;-1016     if (Op == MEM) {
  6446                                  
  6447                                  .writeEA238:
  6448 0000229D A0[2D00]                 mov al, [Op]
  6449 000022A0 3C04                     cmp al, 4
  6450 000022A2 0F857300                 jne .writeEA243
  6451                                  
  6452                                  ;-1017         if (isDirect) {
  6453                                  
  6454 000022A6 A0[3C00]                 mov al, [isDirect]
  6455 000022A9 08C0                     or  al, al
  6456 000022AB 0F840D00                 je .writeEA244
  6457                                  
  6458                                  ;-1018             xxx |= 6;
  6459                                  
  6460 000022AF 804E0406                 or  byte[bp+4], 6
  6461                                  
  6462                                  ;-1019             len = 2;
  6463                                  
  6464 000022B3 B80200                   mov ax, 2
  6465 000022B6 8846FE                   mov [bp-2], al
  6466                                  
  6467                                  ;-1020         }
  6468                                  
  6469                                  
  6470                                  ;-1021         else {
  6471                                  
  6472 000022B9 E95D00                   jmp .writeEA245
  6473                                  .writeEA244:
  6474                                  
  6475                                  ;-1022             xxx = xxx + rm;
  6476                                  
  6477 000022BC 8A4604                   mov al, [bp+4]
  6478 000022BF 0206[3B00]               add al, [rm]
  6479 000022C3 884604                   mov [bp+4], al
  6480                                  
  6481                                  ;-1023             if (rm == 6) {//make [BP+00]
  6482                                  
  6483 000022C6 A0[3B00]                 mov al, [rm]
  6484 000022C9 3C06                     cmp al, 6
  6485 000022CB 0F851400                 jne .writeEA246
  6486                                  
  6487                                  ;-1024                 len=1;
  6488                                  
  6489 000022CF B80100                   mov ax, 1
  6490 000022D2 8846FE                   mov [bp-2], al
  6491                                  
  6492                                  ;-1025                 if (disp == 0) xxx |= 0x40;
  6493                                  
  6494 000022D5 A1[3D00]                 mov ax, [disp]
  6495 000022D8 83F800                   cmp ax, 0
  6496 000022DB 0F850400                 jne .writeEA247
  6497 000022DF 804E0440                 or  byte[bp+4], 64
  6498                                  
  6499                                  ;-1026             }
  6500                                  
  6501                                  .writeEA247:
  6502                                  
  6503                                  ;-1027 
  6504                                  
  6505                                  
  6506                                  ;-1028             if (disp) {
  6507                                  
  6508                                  .writeEA246:
  6509 000022E3 A1[3D00]                 mov ax, [disp]
  6510 000022E6 08C0                     or  al, al
  6511 000022E8 0F842D00                 je .writeEA248
  6512                                  
  6513                                  ;-1029                 ax = disp;
  6514                                  
  6515 000022EC A1[3D00]                 mov  ax, [disp]
  6516                                  
  6517                                  ;-1030                 if(ax > 127) len=2;
  6518                                  
  6519 000022EF 83F87F                   cmp  ax, 127
  6520 000022F2 0F8E0900                 jle .writeEA249
  6521 000022F6 B80200                   mov ax, 2
  6522 000022F9 8846FE                   mov [bp-2], al
  6523                                  
  6524                                  ;-1031                 else len=1;
  6525                                  
  6526 000022FC E90600                   jmp .writeEA250
  6527                                  .writeEA249:
  6528 000022FF B80100                   mov ax, 1
  6529 00002302 8846FE                   mov [bp-2], al
  6530                                  
  6531                                  ;-1032                 if (len == 1) xxx |= 0x40;
  6532                                  
  6533                                  .writeEA250:
  6534 00002305 8A46FE                   mov al, [bp-2]
  6535 00002308 3C01                     cmp al, 1
  6536 0000230A 0F850700                 jne .writeEA251
  6537 0000230E 804E0440                 or  byte[bp+4], 64
  6538                                  
  6539                                  ;-1033                 else xxx |= 0x80;
  6540                                  
  6541 00002312 E90400                   jmp .writeEA252
  6542                                  .writeEA251:
  6543 00002315 804E0480                 or  byte[bp+4], 128
  6544                                  
  6545                                  ;-1034             }
  6546                                  
  6547                                  .writeEA252:
  6548                                  
  6549                                  ;-1035         }
  6550                                  
  6551                                  .writeEA248:
  6552                                  
  6553                                  ;-1036     }
  6554                                  
  6555                                  .writeEA245:
  6556                                  
  6557                                  ;-1037 
  6558                                  
  6559                                  
  6560                                  ;-1038     genCode8(xxx);// gen second byte
  6561                                  
  6562                                  .writeEA243:
  6563 00002319 8A4604                   mov al, byte [bp+4]
  6564 0000231C B400                     mov ah, 0
  6565 0000231E 50                       push ax
  6566 0000231F E883FE                   call genCode8
  6567 00002322 83C402                   add  sp, 2
  6568                                  
  6569                                  ;-1039     if (len == 1) genCode8 (disp);
  6570                                  
  6571 00002325 8A46FE                   mov al, [bp-2]
  6572 00002328 3C01                     cmp al, 1
  6573 0000232A 0F850A00                 jne .writeEA253
  6574 0000232E FF36[3D00]               push word [disp]
  6575 00002332 E870FE                   call genCode8
  6576 00002335 83C402                   add  sp, 2
  6577                                  
  6578                                  ;-1040     if (len == 2) genCode16(disp);
  6579                                  
  6580                                  .writeEA253:
  6581 00002338 8A46FE                   mov al, [bp-2]
  6582 0000233B 3C02                     cmp al, 2
  6583 0000233D 0F850A00                 jne .writeEA254
  6584 00002341 FF36[3D00]               push word [disp]
  6585 00002345 E8B4FE                   call genCode16
  6586 00002348 83C402                   add  sp, 2
  6587                                  
  6588                                  ;-1041 }
  6589                                  
  6590                                  .writeEA254:
  6591                                  
  6592                                  ;-1042 
  6593                                  
  6594                                  
  6595                                  ;-1043 int genImmediate() {
  6596 0000234B C9                       LEAVE
  6597 0000234C C3                       ret
  6598                                  ENDP
  6599                                  
  6600                                  genImmediate: PROC
  6601                                  
  6602                                  ;-1044     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6603                                  
  6604 0000234D A0[3800]                 mov al, [wflag]
  6605 00002350 08C0                     or  al, al
  6606 00002352 0F842300                 je .genImmediate255
  6607 00002356 A0[3700]                 mov al, [OpSize]
  6608 00002359 3C03                     cmp al, 3
  6609 0000235B 0F850D00                 jne .genImmediate256
  6610 0000235F FF36[3F00]               push word [imme]
  6611 00002363 E8B7FE                   call genCode32
  6612 00002366 83C402                   add  sp, 2
  6613                                  
  6614                                  ;-1045         else genCode16(imme);
  6615                                  
  6616 00002369 E90A00                   jmp .genImmediate257
  6617                                  .genImmediate256:
  6618 0000236C FF36[3F00]               push word [imme]
  6619 00002370 E889FE                   call genCode16
  6620 00002373 83C402                   add  sp, 2
  6621                                  
  6622                                  ;-1046     else       genCode8 (imme);
  6623                                  
  6624                                  .genImmediate257:
  6625 00002376 E90A00                   jmp .genImmediate258
  6626                                  .genImmediate255:
  6627 00002379 FF36[3F00]               push word [imme]
  6628 0000237D E825FE                   call genCode8
  6629 00002380 83C402                   add  sp, 2
  6630                                  
  6631                                  ;-1047 }
  6632                                  
  6633                                  .genImmediate258:
  6634                                  
  6635                                  ;-1048 
  6636                                  
  6637                                  
  6638                                  ;-1049 //AS.C
  6639                                  
  6640                                  
  6641                                  ;-1050 int process() {
  6642                                  
  6643 00002383 C3                       ret
  6644                                  ENDP
  6645                                  
  6646                                  process: PROC
  6647                                  
  6648                                  ;-1051     char c;
  6649                                  
  6650                                  
  6651                                  ;-1052     int i;
  6652                                  
  6653                                  
  6654                                  ;-1053     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6655                                  
  6656                                  ;Function : process, Number of local variables: 2
  6657                                  ;   # type sign width addr used name   list of local variables
  6658                                  ;  200 var sign byte  1051 NULL c = bp-2
  6659                                  ;  201 var sign word  1052 NULL i = bp-4;
  6660 00002384 C8040000                 ENTER  4,0
  6661 00002388 B80000                   mov ax, 0
  6662 0000238B A2[3B00]                 mov byte [rm], al
  6663 0000238E A2[3800]                 mov byte [wflag], al
  6664 00002391 A2[3900]                 mov byte [dflag], al
  6665 00002394 A2[3300]                 mov byte [R2No], al
  6666 00002397 A2[3400]                 mov byte [R1No], al
  6667 0000239A A2[3500]                 mov byte [R2Type], al
  6668 0000239D A2[3600]                 mov byte [R1Type], al
  6669 000023A0 A2[2E00]                 mov byte [Op2], al
  6670 000023A3 A2[2D00]                 mov byte [Op], al
  6671                                  
  6672                                  ;-1054     disp=imme=0;//int
  6673                                  
  6674 000023A6 B80000                   mov ax, 0
  6675 000023A9 A3[3F00]                 mov word [imme], ax
  6676 000023AC A3[3D00]                 mov word [disp], ax
  6677                                  
  6678                                  ;-1055     isDirect=1; //set in getMeM=0, need in WriteEA
  6679                                  
  6680 000023AF B80100                   mov ax, 1
  6681 000023B2 A2[3C00]                 mov byte [isDirect], al
  6682                                  
  6683                                  ;-1056     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6684                                  
  6685 000023B5 E80EE7                   call getTokeType
  6686                                  
  6687                                  ;-1057     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6688                                  
  6689 000023B8 E8B0EA                   call getCodeSize
  6690 000023BB A2[3700]                 mov byte [OpSize], al
  6691                                  
  6692                                  ;-1058     getCodes();//set: Code1, Code2, Code3
  6693                                  
  6694 000023BE E876FD                   call getCodes
  6695                                  
  6696                                  ;-1059 
  6697                                  
  6698                                  
  6699                                  ;-1060     if (CodeType ==  1) {//1 byte opcode
  6700                                  
  6701 000023C1 A0[2F00]                 mov al, [CodeType]
  6702 000023C4 3C01                     cmp al, 1
  6703 000023C6 0F850F00                 jne .process259
  6704                                  
  6705                                  ;-1061         genCode8(Code1);
  6706                                  
  6707 000023CA A0[3000]                 mov al, byte [Code1]
  6708 000023CD B400                     mov ah, 0
  6709 000023CF 50                       push ax
  6710 000023D0 E8D2FD                   call genCode8
  6711 000023D3 83C402                   add  sp, 2
  6712                                  
  6713                                  ;-1062         return;
  6714                                  
  6715 000023D6 E99208                   jmp .retnprocess
  6716                                  
  6717                                  ;-1063     }
  6718                                  
  6719                                  
  6720                                  ;-1064 
  6721                                  
  6722                                  
  6723                                  ;-1065     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6724                                  
  6725                                  .process259:
  6726 000023D9 A0[2F00]                 mov al, [CodeType]
  6727 000023DC 3C02                     cmp al, 2
  6728 000023DE 0F856900                 jne .process260
  6729                                  
  6730                                  ;-1066         getOpL();
  6731                                  
  6732 000023E2 E81FE2                   call getOpL
  6733                                  
  6734                                  ;-1067         checkOpL();
  6735                                  
  6736 000023E5 E83FE1                   call checkOpL
  6737                                  
  6738                                  ;-1068         if (Code2 <= 1) {//inc,dec
  6739                                  
  6740 000023E8 A0[3100]                 mov al, [Code2]
  6741 000023EB 3C01                     cmp al, 1
  6742 000023ED 0F8F2700                 jg  .process261
  6743                                  
  6744                                  ;-1069   	        if (Op == REG) {//short
  6745                                  
  6746 000023F1 A0[2D00]                 mov al, [Op]
  6747 000023F4 3C02                     cmp al, 2
  6748 000023F6 0F851E00                 jne .process262
  6749                                  
  6750                                  ;-1070                 if (wflag) {genCode2(Code3, R1No); return; }
  6751                                  
  6752 000023FA A0[3800]                 mov al, [wflag]
  6753 000023FD 08C0                     or  al, al
  6754 000023FF 0F841500                 je .process263
  6755 00002403 A0[3400]                 mov al, byte [R1No]
  6756 00002406 B400                     mov ah, 0
  6757 00002408 50                       push ax
  6758 00002409 A0[3200]                 mov al, byte [Code3]
  6759 0000240C B400                     mov ah, 0
  6760 0000240E 50                       push ax
  6761 0000240F E85CFD                   call genCode2
  6762 00002412 83C404                   add  sp, 4
  6763 00002415 E95308                   jmp .retnprocess
  6764                                  
  6765                                  ;-1071             }
  6766                                  
  6767                                  .process263:
  6768                                  
  6769                                  ;-1072         }
  6770                                  
  6771                                  .process262:
  6772                                  
  6773                                  ;-1073         if (Code2 == 5) {//imul extension?
  6774                                  
  6775                                  .process261:
  6776 00002418 A0[3100]                 mov al, [Code2]
  6777 0000241B 3C05                     cmp al, 5
  6778 0000241D 0F850F00                 jne .process264
  6779                                  
  6780                                  ;-1074             getTokeType();
  6781                                  
  6782 00002421 E8A2E6                   call getTokeType
  6783                                  
  6784                                  ;-1075             if (TokeType) implerror();
  6785                                  
  6786 00002424 A0[2C00]                 mov al, [TokeType]
  6787 00002427 08C0                     or  al, al
  6788 00002429 0F840300                 je .process265
  6789 0000242D E841F7                   call implerror
  6790                                  
  6791                                  ;-1076         }
  6792                                  
  6793                                  .process265:
  6794                                  
  6795                                  ;-1077         genCodeW(Code1);
  6796                                  
  6797                                  .process264:
  6798 00002430 A0[3000]                 mov al, byte [Code1]
  6799 00002433 B400                     mov ah, 0
  6800 00002435 50                       push ax
  6801 00002436 E850FD                   call genCodeW
  6802 00002439 83C402                   add  sp, 2
  6803                                  
  6804                                  ;-1078         writeEA(Code2);
  6805                                  
  6806 0000243C A0[3100]                 mov al, byte [Code2]
  6807 0000243F B400                     mov ah, 0
  6808 00002441 50                       push ax
  6809 00002442 E802FE                   call writeEA
  6810 00002445 83C402                   add  sp, 2
  6811                                  
  6812                                  ;-1079         return;
  6813                                  
  6814 00002448 E92008                   jmp .retnprocess
  6815                                  
  6816                                  ;-1080     }
  6817                                  
  6818                                  
  6819                                  ;-1081 
  6820                                  
  6821                                  
  6822                                  ;-1082     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6823                                  
  6824                                  .process260:
  6825 0000244B A0[2F00]                 mov al, [CodeType]
  6826 0000244E 3C03                     cmp al, 3
  6827 00002450 0F855100                 jne .process266
  6828                                  
  6829                                  ;-1083         check2Ops();    //setwflag not applicable
  6830                                  
  6831 00002454 E852E1                   call check2Ops
  6832                                  
  6833                                  ;-1084         if (R1Type != WORD) reg16error();//only r16
  6834                                  
  6835 00002457 A0[3600]                 mov al, [R1Type]
  6836 0000245A 3C02                     cmp al, 2
  6837 0000245C 0F840300                 je  .process267
  6838 00002460 E8AEF7                   call reg16error
  6839                                  
  6840                                  ;-1085         if (Op2 != MEM) addrerror();//only m16
  6841                                  
  6842                                  .process267:
  6843 00002463 A0[2E00]                 mov al, [Op2]
  6844 00002466 3C04                     cmp al, 4
  6845 00002468 0F840300                 je  .process268
  6846 0000246C E8C3F6                   call addrerror
  6847                                  
  6848                                  ;-1086 
  6849                                  
  6850                                  
  6851                                  ;-1087         genCode8(Code1);//les,lds,lea
  6852                                  
  6853                                  .process268:
  6854 0000246F A0[3000]                 mov al, byte [Code1]
  6855 00002472 B400                     mov ah, 0
  6856 00002474 50                       push ax
  6857 00002475 E82DFD                   call genCode8
  6858 00002478 83C402                   add  sp, 2
  6859                                  
  6860                                  ;-1088         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6861                                  
  6862 0000247B A0[3000]                 mov al, [Code1]
  6863 0000247E 3C0F                     cmp al, 15
  6864 00002480 0F850C00                 jne .process269
  6865 00002484 A0[3100]                 mov al, byte [Code2]
  6866 00002487 B400                     mov ah, 0
  6867 00002489 50                       push ax
  6868 0000248A E818FD                   call genCode8
  6869 0000248D 83C402                   add  sp, 2
  6870                                  
  6871                                  ;-1089         Op=Op2;//set MEM for writeEA
  6872                                  
  6873                                  .process269:
  6874 00002490 A0[2E00]                 mov al, [Op2]
  6875 00002493 A2[2D00]                 mov byte [Op], al
  6876                                  
  6877                                  ;-1090         writeEA(R1No);
  6878                                  
  6879 00002496 A0[3400]                 mov al, byte [R1No]
  6880 00002499 B400                     mov ah, 0
  6881 0000249B 50                       push ax
  6882 0000249C E8A8FD                   call writeEA
  6883 0000249F 83C402                   add  sp, 2
  6884                                  
  6885                                  ;-1091         return;
  6886                                  
  6887 000024A2 E9C607                   jmp .retnprocess
  6888                                  
  6889                                  ;-1092     }
  6890                                  
  6891                                  
  6892                                  ;-1093 
  6893                                  
  6894                                  
  6895                                  ;-1094     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6896                                  
  6897                                  .process266:
  6898 000024A5 A0[2F00]                 mov al, [CodeType]
  6899 000024A8 3C04                     cmp al, 4
  6900 000024AA 0F85EF00                 jne .process270
  6901                                  
  6902                                  ;-1095         check2Ops();
  6903                                  
  6904 000024AE E8F8E0                   call check2Ops
  6905                                  
  6906                                  ;-1096         if (Op2 == IMM) {//second operand is imm
  6907                                  
  6908 000024B1 A0[2E00]                 mov al, [Op2]
  6909 000024B4 3C01                     cmp al, 1
  6910 000024B6 0F857900                 jne .process271
  6911                                  
  6912                                  ;-1097             setsflag();
  6913                                  
  6914 000024BA E868E4                   call setsflag
  6915                                  
  6916                                  ;-1098             if (Op == REG) {
  6917                                  
  6918 000024BD A0[2D00]                 mov al, [Op]
  6919 000024C0 3C02                     cmp al, 2
  6920 000024C2 0F853100                 jne .process272
  6921                                  
  6922                                  ;-1099                 if (R1No == 0) {// acc,imm
  6923                                  
  6924 000024C6 A0[3400]                 mov al, [R1No]
  6925 000024C9 3C00                     cmp al, 0
  6926 000024CB 0F852800                 jne .process273
  6927                                  
  6928                                  ;-1100                     if (sflag == 0) {
  6929                                  
  6930 000024CF A0[3A00]                 mov al, [sflag]
  6931 000024D2 3C00                     cmp al, 0
  6932 000024D4 0F851F00                 jne .process274
  6933                                  
  6934                                  ;-1101                         c = Code1 << 3;
  6935                                  
  6936 000024D8 A0[3000]                 mov al, [Code1]
  6937 000024DB C0E003                   shl al, 3
  6938 000024DE 8846FE                   mov [bp-2], al
  6939                                  
  6940                                  ;-1102                         c += 4;
  6941                                  
  6942 000024E1 8046FE04                 add  byte[bp-2], 4
  6943                                  
  6944                                  ;-1103                         genCodeW(c);
  6945                                  
  6946 000024E5 8A46FE                   mov al, byte [bp-2]
  6947 000024E8 B400                     mov ah, 0
  6948 000024EA 50                       push ax
  6949 000024EB E89BFC                   call genCodeW
  6950 000024EE 83C402                   add  sp, 2
  6951                                  
  6952                                  ;-1104                         genImmediate();
  6953                                  
  6954 000024F1 E859FE                   call genImmediate
  6955                                  
  6956                                  ;-1105                         return;
  6957                                  
  6958 000024F4 E97407                   jmp .retnprocess
  6959                                  
  6960                                  ;-1106                     }
  6961                                  
  6962                                  
  6963                                  ;-1107                 }
  6964                                  
  6965                                  .process274:
  6966                                  
  6967                                  ;-1108             }
  6968                                  
  6969                                  .process273:
  6970                                  
  6971                                  ;-1109             //r/m, imm: 80 sign-extended,TTT,imm
  6972                                  
  6973                                  
  6974                                  ;-1110             c = sflag + 0x80;
  6975                                  
  6976                                  .process272:
  6977 000024F7 A0[3A00]                 mov al, [sflag]
  6978 000024FA 0480                     add al, 128
  6979 000024FC 8846FE                   mov [bp-2], al
  6980                                  
  6981                                  ;-1111             genCodeW(c);
  6982                                  
  6983 000024FF 8A46FE                   mov al, byte [bp-2]
  6984 00002502 B400                     mov ah, 0
  6985 00002504 50                       push ax
  6986 00002505 E881FC                   call genCodeW
  6987 00002508 83C402                   add  sp, 2
  6988                                  
  6989                                  ;-1112             writeEA(Code1);
  6990                                  
  6991 0000250B A0[3000]                 mov al, byte [Code1]
  6992 0000250E B400                     mov ah, 0
  6993 00002510 50                       push ax
  6994 00002511 E833FD                   call writeEA
  6995 00002514 83C402                   add  sp, 2
  6996                                  
  6997                                  ;-1113             if (sflag) genCode8(imme);
  6998                                  
  6999 00002517 A0[3A00]                 mov al, [sflag]
  7000 0000251A 08C0                     or  al, al
  7001 0000251C 0F840D00                 je .process275
  7002 00002520 FF36[3F00]               push word [imme]
  7003 00002524 E87EFC                   call genCode8
  7004 00002527 83C402                   add  sp, 2
  7005                                  
  7006                                  ;-1114             else genImmediate();
  7007                                  
  7008 0000252A E90300                   jmp .process276
  7009                                  .process275:
  7010 0000252D E81DFE                   call genImmediate
  7011                                  
  7012                                  ;-1115             return;
  7013                                  
  7014                                  .process276:
  7015 00002530 E93807                   jmp .retnprocess
  7016                                  
  7017                                  ;-1116         }
  7018                                  
  7019                                  
  7020                                  ;-1117         c = Code1 << 3;//r/m, r/r
  7021                                  
  7022                                  .process271:
  7023 00002533 A0[3000]                 mov al, [Code1]
  7024 00002536 C0E003                   shl al, 3
  7025 00002539 8846FE                   mov [bp-2], al
  7026                                  
  7027                                  ;-1118         if (Op == REG) {
  7028                                  
  7029 0000253C A0[2D00]                 mov al, [Op]
  7030 0000253F 3C02                     cmp al, 2
  7031 00002541 0F852E00                 jne .process277
  7032                                  
  7033                                  ;-1119             if (Op2 == MEM) {//reg, mem
  7034                                  
  7035 00002545 A0[2E00]                 mov al, [Op2]
  7036 00002548 3C04                     cmp al, 4
  7037 0000254A 0F852500                 jne .process278
  7038                                  
  7039                                  ;-1120                 c += 2;//add direction flag
  7040                                  
  7041 0000254E 8046FE02                 add  byte[bp-2], 2
  7042                                  
  7043                                  ;-1121                 genCodeW(c);
  7044                                  
  7045 00002552 8A46FE                   mov al, byte [bp-2]
  7046 00002555 B400                     mov ah, 0
  7047 00002557 50                       push ax
  7048 00002558 E82EFC                   call genCodeW
  7049 0000255B 83C402                   add  sp, 2
  7050                                  
  7051                                  ;-1122                 Op=Op2;//set MEM for writeEA
  7052                                  
  7053 0000255E A0[2E00]                 mov al, [Op2]
  7054 00002561 A2[2D00]                 mov byte [Op], al
  7055                                  
  7056                                  ;-1123                 writeEA(R1No);
  7057                                  
  7058 00002564 A0[3400]                 mov al, byte [R1No]
  7059 00002567 B400                     mov ah, 0
  7060 00002569 50                       push ax
  7061 0000256A E8DAFC                   call writeEA
  7062 0000256D 83C402                   add  sp, 2
  7063                                  
  7064                                  ;-1124                 return;
  7065                                  
  7066 00002570 E9F806                   jmp .retnprocess
  7067                                  
  7068                                  ;-1125             }
  7069                                  
  7070                                  
  7071                                  ;-1126         }
  7072                                  
  7073                                  .process278:
  7074                                  
  7075                                  ;-1127         if (Op2 == REG) {//mem,reg    reg,reg
  7076                                  
  7077                                  .process277:
  7078 00002573 A0[2E00]                 mov al, [Op2]
  7079 00002576 3C02                     cmp al, 2
  7080 00002578 0F851B00                 jne .process279
  7081                                  
  7082                                  ;-1128             genCodeW(c);
  7083                                  
  7084 0000257C 8A46FE                   mov al, byte [bp-2]
  7085 0000257F B400                     mov ah, 0
  7086 00002581 50                       push ax
  7087 00002582 E804FC                   call genCodeW
  7088 00002585 83C402                   add  sp, 2
  7089                                  
  7090                                  ;-1129             writeEA(R2No);//2. Op in reg-field
  7091                                  
  7092 00002588 A0[3300]                 mov al, byte [R2No]
  7093 0000258B B400                     mov ah, 0
  7094 0000258D 50                       push ax
  7095 0000258E E8B6FC                   call writeEA
  7096 00002591 83C402                   add  sp, 2
  7097                                  
  7098                                  ;-1130             return;
  7099                                  
  7100 00002594 E9D406                   jmp .retnprocess
  7101                                  
  7102                                  ;-1131         }
  7103                                  
  7104                                  
  7105                                  ;-1132         syntaxerror();
  7106                                  
  7107                                  .process279:
  7108 00002597 E8C6F6                   call syntaxerror
  7109                                  
  7110                                  ;-1133         return;
  7111                                  
  7112 0000259A E9CE06                   jmp .retnprocess
  7113                                  
  7114                                  ;-1134     }
  7115                                  
  7116                                  
  7117                                  ;-1135 
  7118                                  
  7119                                  
  7120                                  ;-1136     if (CodeType == 5) {//mov (movsx, movzx=51)
  7121                                  
  7122                                  .process270:
  7123 0000259D A0[2F00]                 mov al, [CodeType]
  7124 000025A0 3C05                     cmp al, 5
  7125 000025A2 0F858B01                 jne .process280
  7126                                  
  7127                                  ;-1137         check2Ops();
  7128                                  
  7129 000025A6 E800E0                   call check2Ops
  7130                                  
  7131                                  ;-1138 /*    prs("\n Op:"); printhex8a(Op);
  7132                                  
  7133                                  
  7134                                  ;-1139     prs(", Op2:"); printhex8a(Op2);
  7135                                  
  7136                                  
  7137                                  ;-1140     prs(", R1No:"); printhex8a(R1No);
  7138                                  
  7139                                  
  7140                                  ;-1141     prs(", R2No:"); printhex8a(R2No);   */
  7141                                  
  7142                                  
  7143                                  ;-1142         if (Op2 == ADR) {
  7144                                  
  7145 000025A9 A0[2E00]                 mov al, [Op2]
  7146 000025AC 3C03                     cmp al, 3
  7147 000025AE 0F851B00                 jne .process281
  7148                                  
  7149                                  ;-1143             if (disp) imme=disp;
  7150                                  
  7151 000025B2 A1[3D00]                 mov ax, [disp]
  7152 000025B5 08C0                     or  al, al
  7153 000025B7 0F840900                 je .process282
  7154 000025BB A1[3D00]                 mov ax, [disp]
  7155 000025BE A3[3F00]                 mov word [imme], ax
  7156                                  
  7157                                  ;-1144             else notfounderror();
  7158                                  
  7159 000025C1 E90300                   jmp .process283
  7160                                  .process282:
  7161 000025C4 E836F5                   call notfounderror
  7162                                  
  7163                                  ;-1145             Op2=IMM;//continue with IMM
  7164                                  
  7165                                  .process283:
  7166 000025C7 B80100                   mov ax, 1
  7167 000025CA A2[2E00]                 mov byte [Op2], al
  7168                                  
  7169                                  ;-1146         }
  7170                                  
  7171                                  
  7172                                  ;-1147         if (Op2 == IMM) {// r,i
  7173                                  
  7174                                  .process281:
  7175 000025CD A0[2E00]                 mov al, [Op2]
  7176 000025D0 3C01                     cmp al, 1
  7177 000025D2 0F855400                 jne .process284
  7178                                  
  7179                                  ;-1148             if (Op == REG) {
  7180                                  
  7181 000025D6 A0[2D00]                 mov al, [Op]
  7182 000025D9 3C02                     cmp al, 2
  7183 000025DB 0F852500                 jne .process285
  7184                                  
  7185                                  ;-1149                 c = wflag << 3;
  7186                                  
  7187 000025DF A0[3800]                 mov al, [wflag]
  7188 000025E2 C0E003                   shl al, 3
  7189 000025E5 8846FE                   mov [bp-2], al
  7190                                  
  7191                                  ;-1150                 c += 0xB0;
  7192                                  
  7193 000025E8 8046FEB0                 add  byte[bp-2], 176
  7194                                  
  7195                                  ;-1151                 genCode2(c, R1No);
  7196                                  
  7197 000025EC A0[3400]                 mov al, byte [R1No]
  7198 000025EF B400                     mov ah, 0
  7199 000025F1 50                       push ax
  7200 000025F2 8A46FE                   mov al, byte [bp-2]
  7201 000025F5 B400                     mov ah, 0
  7202 000025F7 50                       push ax
  7203 000025F8 E873FB                   call genCode2
  7204 000025FB 83C404                   add  sp, 4
  7205                                  
  7206                                  ;-1152                 genImmediate();
  7207                                  
  7208 000025FE E84CFD                   call genImmediate
  7209                                  
  7210                                  ;-1153                 return;
  7211                                  
  7212 00002601 E96706                   jmp .retnprocess
  7213                                  
  7214                                  ;-1154             }
  7215                                  
  7216                                  
  7217                                  ;-1155             if (Op == MEM) {// m,i
  7218                                  
  7219                                  .process285:
  7220 00002604 A0[2D00]                 mov al, [Op]
  7221 00002607 3C04                     cmp al, 4
  7222 00002609 0F851700                 jne .process286
  7223                                  
  7224                                  ;-1156                 genCodeW(0xC6);
  7225                                  
  7226 0000260D 68C600                   push 198
  7227 00002610 E876FB                   call genCodeW
  7228 00002613 83C402                   add  sp, 2
  7229                                  
  7230                                  ;-1157                 writeEA( 0 );
  7231                                  
  7232 00002616 6A00                     push 0
  7233 00002618 E82CFC                   call writeEA
  7234 0000261B 83C402                   add  sp, 2
  7235                                  
  7236                                  ;-1158                 genImmediate();
  7237                                  
  7238 0000261E E82CFD                   call genImmediate
  7239                                  
  7240                                  ;-1159                 return;
  7241                                  
  7242 00002621 E94706                   jmp .retnprocess
  7243                                  
  7244                                  ;-1160             }
  7245                                  
  7246                                  
  7247                                  ;-1161             regmemerror();
  7248                                  
  7249                                  .process286:
  7250 00002624 E8C0F5                   call regmemerror
  7251                                  
  7252                                  ;-1162             return;
  7253                                  
  7254 00002627 E94106                   jmp .retnprocess
  7255                                  
  7256                                  ;-1163         }
  7257                                  
  7258                                  
  7259                                  ;-1164         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7260                                  
  7261                                  .process284:
  7262 0000262A A0[3600]                 mov al, [R1Type]
  7263 0000262D 3C04                     cmp al, 4
  7264 0000262F 0F850300                 jne .process287
  7265 00002633 E8AFDE                   call ChangeDirection
  7266                                  
  7267                                  ;-1165         if (R2Type == SEGREG) {//rm,sreg
  7268                                  
  7269                                  .process287:
  7270 00002636 A0[3500]                 mov al, [R2Type]
  7271 00002639 3C04                     cmp al, 4
  7272 0000263B 0F852A00                 jne .process288
  7273                                  
  7274                                  ;-1166             if (OpSize != WORD) reg16error();
  7275                                  
  7276 0000263F A0[3700]                 mov al, [OpSize]
  7277 00002642 3C02                     cmp al, 2
  7278 00002644 0F840300                 je  .process289
  7279 00002648 E8C6F5                   call reg16error
  7280                                  
  7281                                  ;-1167                 genCode2(0x8C, dflag);
  7282                                  
  7283                                  .process289:
  7284 0000264B A0[3900]                 mov al, byte [dflag]
  7285 0000264E B400                     mov ah, 0
  7286 00002650 50                       push ax
  7287 00002651 688C00                   push 140
  7288 00002654 E817FB                   call genCode2
  7289 00002657 83C404                   add  sp, 4
  7290                                  
  7291                                  ;-1168                 writeEA(R2No);
  7292                                  
  7293 0000265A A0[3300]                 mov al, byte [R2No]
  7294 0000265D B400                     mov ah, 0
  7295 0000265F 50                       push ax
  7296 00002660 E8E4FB                   call writeEA
  7297 00002663 83C402                   add  sp, 2
  7298                                  
  7299                                  ;-1169                 return;
  7300                                  
  7301 00002666 E90206                   jmp .retnprocess
  7302                                  
  7303                                  ;-1170         }
  7304                                  
  7305                                  
  7306                                  ;-1171         if (Op2 == MEM) {//acc, moffs16
  7307                                  
  7308                                  .process288:
  7309 00002669 A0[2E00]                 mov al, [Op2]
  7310 0000266C 3C04                     cmp al, 4
  7311 0000266E 0F853100                 jne .process290
  7312                                  
  7313                                  ;-1172             if (Op == REG) {
  7314                                  
  7315 00002672 A0[2D00]                 mov al, [Op]
  7316 00002675 3C02                     cmp al, 2
  7317 00002677 0F852800                 jne .process291
  7318                                  
  7319                                  ;-1173                 if (R1No == 0) {
  7320                                  
  7321 0000267B A0[3400]                 mov al, [R1No]
  7322 0000267E 3C00                     cmp al, 0
  7323 00002680 0F851F00                 jne .process292
  7324                                  
  7325                                  ;-1174                     if (isDirect) {
  7326                                  
  7327 00002684 A0[3C00]                 mov al, [isDirect]
  7328 00002687 08C0                     or  al, al
  7329 00002689 0F841600                 je .process293
  7330                                  
  7331                                  ;-1175                         genCodeW(0xA0);
  7332                                  
  7333 0000268D 68A000                   push 160
  7334 00002690 E8F6FA                   call genCodeW
  7335 00002693 83C402                   add  sp, 2
  7336                                  
  7337                                  ;-1176                         genCode16(disp);
  7338                                  
  7339 00002696 FF36[3D00]               push word [disp]
  7340 0000269A E85FFB                   call genCode16
  7341 0000269D 83C402                   add  sp, 2
  7342                                  
  7343                                  ;-1177                         return;
  7344                                  
  7345 000026A0 E9C805                   jmp .retnprocess
  7346                                  
  7347                                  ;-1178                     }
  7348                                  
  7349                                  
  7350                                  ;-1179                 }
  7351                                  
  7352                                  .process293:
  7353                                  
  7354                                  ;-1180             }
  7355                                  
  7356                                  .process292:
  7357                                  
  7358                                  ;-1181         }
  7359                                  
  7360                                  .process291:
  7361                                  
  7362                                  ;-1182         if (Op == MEM) {//moffs16, acc
  7363                                  
  7364                                  .process290:
  7365 000026A3 A0[2D00]                 mov al, [Op]
  7366 000026A6 3C04                     cmp al, 4
  7367 000026A8 0F853100                 jne .process294
  7368                                  
  7369                                  ;-1183             if (Op2 == REG) {
  7370                                  
  7371 000026AC A0[2E00]                 mov al, [Op2]
  7372 000026AF 3C02                     cmp al, 2
  7373 000026B1 0F852800                 jne .process295
  7374                                  
  7375                                  ;-1184                 if (R2No == 0) {
  7376                                  
  7377 000026B5 A0[3300]                 mov al, [R2No]
  7378 000026B8 3C00                     cmp al, 0
  7379 000026BA 0F851F00                 jne .process296
  7380                                  
  7381                                  ;-1185                     if (isDirect) {
  7382                                  
  7383 000026BE A0[3C00]                 mov al, [isDirect]
  7384 000026C1 08C0                     or  al, al
  7385 000026C3 0F841600                 je .process297
  7386                                  
  7387                                  ;-1186                         genCodeW(0xA2);
  7388                                  
  7389 000026C7 68A200                   push 162
  7390 000026CA E8BCFA                   call genCodeW
  7391 000026CD 83C402                   add  sp, 2
  7392                                  
  7393                                  ;-1187                         genCode16(disp);
  7394                                  
  7395 000026D0 FF36[3D00]               push word [disp]
  7396 000026D4 E825FB                   call genCode16
  7397 000026D7 83C402                   add  sp, 2
  7398                                  
  7399                                  ;-1188                         return;
  7400                                  
  7401 000026DA E98E05                   jmp .retnprocess
  7402                                  
  7403                                  ;-1189                     }
  7404                                  
  7405                                  
  7406                                  ;-1190                 }
  7407                                  
  7408                                  .process297:
  7409                                  
  7410                                  ;-1191             }
  7411                                  
  7412                                  .process296:
  7413                                  
  7414                                  ;-1192 
  7415                                  
  7416                                  
  7417                                  ;-1193         }
  7418                                  
  7419                                  .process295:
  7420                                  
  7421                                  ;-1194         if (Op2 == REG) {//rm, r
  7422                                  
  7423                                  .process294:
  7424 000026DD A0[2E00]                 mov al, [Op2]
  7425 000026E0 3C02                     cmp al, 2
  7426 000026E2 0F851800                 jne .process298
  7427                                  
  7428                                  ;-1195             genCodeW(0x88);
  7429                                  
  7430 000026E6 688800                   push 136
  7431 000026E9 E89DFA                   call genCodeW
  7432 000026EC 83C402                   add  sp, 2
  7433                                  
  7434                                  ;-1196             writeEA(R2No);
  7435                                  
  7436 000026EF A0[3300]                 mov al, byte [R2No]
  7437 000026F2 B400                     mov ah, 0
  7438 000026F4 50                       push ax
  7439 000026F5 E84FFB                   call writeEA
  7440 000026F8 83C402                   add  sp, 2
  7441                                  
  7442                                  ;-1197             return;
  7443                                  
  7444 000026FB E96D05                   jmp .retnprocess
  7445                                  
  7446                                  ;-1198         }
  7447                                  
  7448                                  
  7449                                  ;-1199         if (Op2 == MEM) {//r, m
  7450                                  
  7451                                  .process298:
  7452 000026FE A0[2E00]                 mov al, [Op2]
  7453 00002701 3C04                     cmp al, 4
  7454 00002703 0F852400                 jne .process299
  7455                                  
  7456                                  ;-1200             if (Op == REG) {
  7457                                  
  7458 00002707 A0[2D00]                 mov al, [Op]
  7459 0000270A 3C02                     cmp al, 2
  7460 0000270C 0F851B00                 jne .process300
  7461                                  
  7462                                  ;-1201                 ChangeDirection();
  7463                                  
  7464 00002710 E8D2DD                   call ChangeDirection
  7465                                  
  7466                                  ;-1202                 genCodeW(0x8A);
  7467                                  
  7468 00002713 688A00                   push 138
  7469 00002716 E870FA                   call genCodeW
  7470 00002719 83C402                   add  sp, 2
  7471                                  
  7472                                  ;-1203                 writeEA(R2No);
  7473                                  
  7474 0000271C A0[3300]                 mov al, byte [R2No]
  7475 0000271F B400                     mov ah, 0
  7476 00002721 50                       push ax
  7477 00002722 E822FB                   call writeEA
  7478 00002725 83C402                   add  sp, 2
  7479                                  
  7480                                  ;-1204                 return;
  7481                                  
  7482 00002728 E94005                   jmp .retnprocess
  7483                                  
  7484                                  ;-1205             }
  7485                                  
  7486                                  
  7487                                  ;-1206         }
  7488                                  
  7489                                  .process300:
  7490                                  
  7491                                  ;-1207         syntaxerror();
  7492                                  
  7493                                  .process299:
  7494 0000272B E832F5                   call syntaxerror
  7495                                  
  7496                                  ;-1208         return;
  7497                                  
  7498 0000272E E93A05                   jmp .retnprocess
  7499                                  
  7500                                  ;-1209     }
  7501                                  
  7502                                  
  7503                                  ;-1210 
  7504                                  
  7505                                  
  7506                                  ;-1211     if (CodeType == 6) {//Jcc
  7507                                  
  7508                                  .process280:
  7509 00002731 A0[2F00]                 mov al, [CodeType]
  7510 00002734 3C06                     cmp al, 6
  7511 00002736 0F85BE00                 jne .process301
  7512                                  
  7513                                  ;-1212         if (TokeType == ALNUME) {
  7514                                  
  7515 0000273A A0[2C00]                 mov al, [TokeType]
  7516 0000273D 3C03                     cmp al, 3
  7517 0000273F 0F85B500                 jne .process302
  7518                                  
  7519                                  ;-1213             LabelIx=searchLabel();
  7520                                  
  7521 00002743 E838E5                   call searchLabel
  7522 00002746 A3[4E00]                 mov word [LabelIx], ax
  7523                                  
  7524                                  ;-1214             if (LabelIx > 0) {
  7525                                  
  7526 00002749 A1[4E00]                 mov ax, [LabelIx]
  7527 0000274C 83F800                   cmp ax, 0
  7528 0000274F 0F8E7A00                 jle .process303
  7529                                  
  7530                                  ;-1215                 disp=LabelAddr[LabelIx];
  7531                                  
  7532 00002753 8B1E[4E00]               mov bx, [LabelIx]
  7533 00002757 D1E3                     shl bx, 1
  7534 00002759 8B87FA86                 mov ax, [LabelAddr + bx]
  7535 0000275D A3[3D00]                 mov word [disp], ax
  7536                                  
  7537                                  ;-1216                 disp = disp - PC;
  7538                                  
  7539 00002760 A1[3D00]                 mov ax, [disp]
  7540 00002763 2B06[2300]               sub ax, [PC]
  7541 00002767 A3[3D00]                 mov word [disp], ax
  7542                                  
  7543                                  ;-1217                 disp = disp - Origin;
  7544                                  
  7545 0000276A A1[3D00]                 mov ax, [disp]
  7546 0000276D 2B06[2500]               sub ax, [Origin]
  7547 00002771 A3[3D00]                 mov word [disp], ax
  7548                                  
  7549                                  ;-1218                 if (checkConstSize(disp) ) {
  7550                                  
  7551 00002774 FF36[3D00]               push word [disp]
  7552 00002778 E806E2                   call checkConstSize
  7553 0000277B 83C402                   add  sp, 2
  7554 0000277E 08C0                     or  al, al
  7555 00002780 0F842000                 je .process304
  7556                                  
  7557                                  ;-1219                     genCode2(Code1, 0x70);//short
  7558                                  
  7559 00002784 6A70                     push 112
  7560 00002786 A0[3000]                 mov al, byte [Code1]
  7561 00002789 B400                     mov ah, 0
  7562 0000278B 50                       push ax
  7563 0000278C E8DFF9                   call genCode2
  7564 0000278F 83C404                   add  sp, 4
  7565                                  
  7566                                  ;-1220                     disp -= 2;
  7567                                  
  7568 00002792 832E[3D00]02             sub  word[disp], 2
  7569                                  
  7570                                  ;-1221                     genCode8(disp);
  7571                                  
  7572 00002797 FF36[3D00]               push word [disp]
  7573 0000279B E807FA                   call genCode8
  7574 0000279E 83C402                   add  sp, 2
  7575                                  
  7576                                  ;-1222                 } else {
  7577                                  
  7578 000027A1 E92600                   jmp .process305
  7579                                  .process304:
  7580                                  
  7581                                  ;-1223                     genCode8(0x0F);
  7582                                  
  7583 000027A4 6A0F                     push 15
  7584 000027A6 E8FCF9                   call genCode8
  7585 000027A9 83C402                   add  sp, 2
  7586                                  
  7587                                  ;-1224                     genCode2(Code1, 0x80);//near
  7588                                  
  7589 000027AC 688000                   push 128
  7590 000027AF A0[3000]                 mov al, byte [Code1]
  7591 000027B2 B400                     mov ah, 0
  7592 000027B4 50                       push ax
  7593 000027B5 E8B6F9                   call genCode2
  7594 000027B8 83C404                   add  sp, 4
  7595                                  
  7596                                  ;-1225                     disp -= 4;
  7597                                  
  7598 000027BB 832E[3D00]04             sub  word[disp], 4
  7599                                  
  7600                                  ;-1226                     genCode16(disp);
  7601                                  
  7602 000027C0 FF36[3D00]               push word [disp]
  7603 000027C4 E835FA                   call genCode16
  7604 000027C7 83C402                   add  sp, 2
  7605                                  
  7606                                  ;-1227                 }
  7607                                  
  7608                                  
  7609                                  ;-1228             }
  7610                                  
  7611                                  .process305:
  7612                                  
  7613                                  ;-1229             else {//jump forward, near only
  7614                                  
  7615 000027CA E92800                   jmp .process306
  7616                                  .process303:
  7617                                  
  7618                                  ;-1230                 genCode8(0x0F);
  7619                                  
  7620 000027CD 6A0F                     push 15
  7621 000027CF E8D3F9                   call genCode8
  7622 000027D2 83C402                   add  sp, 2
  7623                                  
  7624                                  ;-1231                 genCode2(Code1, 0x80);
  7625                                  
  7626 000027D5 688000                   push 128
  7627 000027D8 A0[3000]                 mov al, byte [Code1]
  7628 000027DB B400                     mov ah, 0
  7629 000027DD 50                       push ax
  7630 000027DE E88DF9                   call genCode2
  7631 000027E1 83C404                   add  sp, 4
  7632                                  
  7633                                  ;-1232                 genCode16(0);
  7634                                  
  7635 000027E4 6A00                     push 0
  7636 000027E6 E813FA                   call genCode16
  7637 000027E9 83C402                   add  sp, 2
  7638                                  
  7639                                  ;-1233                 PrintRA='r';
  7640                                  
  7641 000027EC B87200                   mov ax, 114
  7642 000027EF A2[4500]                 mov byte [PrintRA], al
  7643                                  
  7644                                  ;-1234                 storeJmpCall();
  7645                                  
  7646 000027F2 E85DE3                   call storeJmpCall
  7647                                  
  7648                                  ;-1235             }
  7649                                  
  7650                                  
  7651                                  ;-1236         return;
  7652                                  
  7653                                  .process306:
  7654 000027F5 E97304                   jmp .retnprocess
  7655                                  
  7656                                  ;-1237         }
  7657                                  
  7658                                  
  7659                                  ;-1238     }
  7660                                  
  7661                                  .process302:
  7662                                  
  7663                                  ;-1239 
  7664                                  
  7665                                  
  7666                                  ;-1240     if (CodeType == 7) {//jmp, call
  7667                                  
  7668                                  .process301:
  7669 000027F8 A0[2F00]                 mov al, [CodeType]
  7670 000027FB 3C07                     cmp al, 7
  7671 000027FD 0F85CA00                 jne .process307
  7672                                  
  7673                                  ;-1241         if (TokeType == ALNUME) {
  7674                                  
  7675 00002801 A0[2C00]                 mov al, [TokeType]
  7676 00002804 3C03                     cmp al, 3
  7677 00002806 0F85C100                 jne .process308
  7678                                  
  7679                                  ;-1242             LabelIx=searchLabel();
  7680                                  
  7681 0000280A E871E4                   call searchLabel
  7682 0000280D A3[4E00]                 mov word [LabelIx], ax
  7683                                  
  7684                                  ;-1243             if (LabelIx > 0) {
  7685                                  
  7686 00002810 A1[4E00]                 mov ax, [LabelIx]
  7687 00002813 83F800                   cmp ax, 0
  7688 00002816 0F8E9100                 jle .process309
  7689                                  
  7690                                  ;-1244                 disp=LabelAddr[LabelIx];
  7691                                  
  7692 0000281A 8B1E[4E00]               mov bx, [LabelIx]
  7693 0000281E D1E3                     shl bx, 1
  7694 00002820 8B87FA86                 mov ax, [LabelAddr + bx]
  7695 00002824 A3[3D00]                 mov word [disp], ax
  7696                                  
  7697                                  ;-1245                 disp = disp - PC;
  7698                                  
  7699 00002827 A1[3D00]                 mov ax, [disp]
  7700 0000282A 2B06[2300]               sub ax, [PC]
  7701 0000282E A3[3D00]                 mov word [disp], ax
  7702                                  
  7703                                  ;-1246                 disp = disp - Origin;
  7704                                  
  7705 00002831 A1[3D00]                 mov ax, [disp]
  7706 00002834 2B06[2500]               sub ax, [Origin]
  7707 00002838 A3[3D00]                 mov word [disp], ax
  7708                                  
  7709                                  ;-1247                 if (checkConstSize(disp) ) {
  7710                                  
  7711 0000283B FF36[3D00]               push word [disp]
  7712 0000283F E83FE1                   call checkConstSize
  7713 00002842 83C402                   add  sp, 2
  7714 00002845 08C0                     or  al, al
  7715 00002847 0F844200                 je .process310
  7716                                  
  7717                                  ;-1248                     if (Code1 == 0xE9) {//jmp only
  7718                                  
  7719 0000284B A0[3000]                 mov al, [Code1]
  7720 0000284E 3CE9                     cmp al, 233
  7721 00002850 0F851B00                 jne .process311
  7722                                  
  7723                                  ;-1249                         genCode8(0xEB);//short
  7724                                  
  7725 00002854 68EB00                   push 235
  7726 00002857 E84BF9                   call genCode8
  7727 0000285A 83C402                   add  sp, 2
  7728                                  
  7729                                  ;-1250                         disp -= 2;
  7730                                  
  7731 0000285D 832E[3D00]02             sub  word[disp], 2
  7732                                  
  7733                                  ;-1251                         genCode8(disp);
  7734                                  
  7735 00002862 FF36[3D00]               push word [disp]
  7736 00002866 E83CF9                   call genCode8
  7737 00002869 83C402                   add  sp, 2
  7738                                  
  7739                                  ;-1252                     }
  7740                                  
  7741                                  
  7742                                  ;-1253                     else {
  7743                                  
  7744 0000286C E91B00                   jmp .process312
  7745                                  .process311:
  7746                                  
  7747                                  ;-1254                         genCode8(Code1);//near
  7748                                  
  7749 0000286F A0[3000]                 mov al, byte [Code1]
  7750 00002872 B400                     mov ah, 0
  7751 00002874 50                       push ax
  7752 00002875 E82DF9                   call genCode8
  7753 00002878 83C402                   add  sp, 2
  7754                                  
  7755                                  ;-1255                         disp -= 3;
  7756                                  
  7757 0000287B 832E[3D00]03             sub  word[disp], 3
  7758                                  
  7759                                  ;-1256                         genCode16(disp);
  7760                                  
  7761 00002880 FF36[3D00]               push word [disp]
  7762 00002884 E875F9                   call genCode16
  7763 00002887 83C402                   add  sp, 2
  7764                                  
  7765                                  ;-1257                     }
  7766                                  
  7767                                  
  7768                                  ;-1258                 }
  7769                                  
  7770                                  .process312:
  7771                                  
  7772                                  ;-1259                 else {
  7773                                  
  7774 0000288A E91B00                   jmp .process313
  7775                                  .process310:
  7776                                  
  7777                                  ;-1260                     genCode8(Code1);//near
  7778                                  
  7779 0000288D A0[3000]                 mov al, byte [Code1]
  7780 00002890 B400                     mov ah, 0
  7781 00002892 50                       push ax
  7782 00002893 E80FF9                   call genCode8
  7783 00002896 83C402                   add  sp, 2
  7784                                  
  7785                                  ;-1261                     disp -= 3;
  7786                                  
  7787 00002899 832E[3D00]03             sub  word[disp], 3
  7788                                  
  7789                                  ;-1262                     genCode16(disp);
  7790                                  
  7791 0000289E FF36[3D00]               push word [disp]
  7792 000028A2 E857F9                   call genCode16
  7793 000028A5 83C402                   add  sp, 2
  7794                                  
  7795                                  ;-1263                 }
  7796                                  
  7797                                  
  7798                                  ;-1264             }
  7799                                  
  7800                                  .process313:
  7801                                  
  7802                                  ;-1265             else {//jump forward, near only
  7803                                  
  7804 000028A8 E91D00                   jmp .process314
  7805                                  .process309:
  7806                                  
  7807                                  ;-1266                 genCode8(Code1);
  7808                                  
  7809 000028AB A0[3000]                 mov al, byte [Code1]
  7810 000028AE B400                     mov ah, 0
  7811 000028B0 50                       push ax
  7812 000028B1 E8F1F8                   call genCode8
  7813 000028B4 83C402                   add  sp, 2
  7814                                  
  7815                                  ;-1267                 genCode16(0);
  7816                                  
  7817 000028B7 6A00                     push 0
  7818 000028B9 E840F9                   call genCode16
  7819 000028BC 83C402                   add  sp, 2
  7820                                  
  7821                                  ;-1268                 PrintRA='R';
  7822                                  
  7823 000028BF B85200                   mov ax, 82
  7824 000028C2 A2[4500]                 mov byte [PrintRA], al
  7825                                  
  7826                                  ;-1269                 storeJmpCall();
  7827                                  
  7828 000028C5 E88AE2                   call storeJmpCall
  7829                                  
  7830                                  ;-1270             }
  7831                                  
  7832                                  
  7833                                  ;-1271         return;
  7834                                  
  7835                                  .process314:
  7836 000028C8 E9A003                   jmp .retnprocess
  7837                                  
  7838                                  ;-1272         }
  7839                                  
  7840                                  
  7841                                  ;-1273     }
  7842                                  
  7843                                  .process308:
  7844                                  
  7845                                  ;-1274 
  7846                                  
  7847                                  
  7848                                  ;-1275     if (CodeType ==  8) {//ret,retf
  7849                                  
  7850                                  .process307:
  7851 000028CB A0[2F00]                 mov al, [CodeType]
  7852 000028CE 3C08                     cmp al, 8
  7853 000028D0 0F853100                 jne .process315
  7854                                  
  7855                                  ;-1276         if (TokeType == DIGIT) {
  7856                                  
  7857 000028D4 A0[2C00]                 mov al, [TokeType]
  7858 000028D7 3C01                     cmp al, 1
  7859 000028D9 0F851900                 jne .process316
  7860                                  
  7861                                  ;-1277             genCode8(Code2);
  7862                                  
  7863 000028DD A0[3100]                 mov al, byte [Code2]
  7864 000028E0 B400                     mov ah, 0
  7865 000028E2 50                       push ax
  7866 000028E3 E8BFF8                   call genCode8
  7867 000028E6 83C402                   add  sp, 2
  7868                                  
  7869                                  ;-1278             genCode16(SymbolInt);
  7870                                  
  7871 000028E9 FF36[0E00]               push word [SymbolInt]
  7872 000028ED E80CF9                   call genCode16
  7873 000028F0 83C402                   add  sp, 2
  7874                                  
  7875                                  ;-1279             return;
  7876                                  
  7877 000028F3 E97503                   jmp .retnprocess
  7878                                  
  7879                                  ;-1280         }
  7880                                  
  7881                                  
  7882                                  ;-1281         genCode8(Code1);
  7883                                  
  7884                                  .process316:
  7885 000028F6 A0[3000]                 mov al, byte [Code1]
  7886 000028F9 B400                     mov ah, 0
  7887 000028FB 50                       push ax
  7888 000028FC E8A6F8                   call genCode8
  7889 000028FF 83C402                   add  sp, 2
  7890                                  
  7891                                  ;-1282         return;
  7892                                  
  7893 00002902 E96603                   jmp .retnprocess
  7894                                  
  7895                                  ;-1283     }
  7896                                  
  7897                                  
  7898                                  ;-1284 
  7899                                  
  7900                                  
  7901                                  ;-1285     if (CodeType == 9) {//push, pop
  7902                                  
  7903                                  .process315:
  7904 00002905 A0[2F00]                 mov al, [CodeType]
  7905 00002908 3C09                     cmp al, 9
  7906 0000290A 0F854301                 jne .process317
  7907                                  
  7908                                  ;-1286         getOpL();
  7909                                  
  7910 0000290E E8F3DC                   call getOpL
  7911                                  
  7912                                  ;-1287         if (Code1 == 0x50) {//push only
  7913                                  
  7914 00002911 A0[3000]                 mov al, [Code1]
  7915 00002914 3C50                     cmp al, 80
  7916 00002916 0F857D00                 jne .process318
  7917                                  
  7918                                  ;-1288             if (Op == IMM) {//push imm8,16
  7919                                  
  7920 0000291A A0[2D00]                 mov al, [Op]
  7921 0000291D 3C01                     cmp al, 1
  7922 0000291F 0F853400                 jne .process319
  7923                                  
  7924                                  ;-1289                 setsflag();
  7925                                  
  7926 00002923 E8FFDF                   call setsflag
  7927                                  
  7928                                  ;-1290                 genCode2(0x68, sflag);
  7929                                  
  7930 00002926 A0[3A00]                 mov al, byte [sflag]
  7931 00002929 B400                     mov ah, 0
  7932 0000292B 50                       push ax
  7933 0000292C 6A68                     push 104
  7934 0000292E E83DF8                   call genCode2
  7935 00002931 83C404                   add  sp, 4
  7936                                  
  7937                                  ;-1291                 if (sflag) genCode8 (imme);
  7938                                  
  7939 00002934 A0[3A00]                 mov al, [sflag]
  7940 00002937 08C0                     or  al, al
  7941 00002939 0F840D00                 je .process320
  7942 0000293D FF36[3F00]               push word [imme]
  7943 00002941 E861F8                   call genCode8
  7944 00002944 83C402                   add  sp, 2
  7945                                  
  7946                                  ;-1292                 else       genCode16(imme);
  7947                                  
  7948 00002947 E90A00                   jmp .process321
  7949                                  .process320:
  7950 0000294A FF36[3F00]               push word [imme]
  7951 0000294E E8ABF8                   call genCode16
  7952 00002951 83C402                   add  sp, 2
  7953                                  
  7954                                  ;-1293                 return;
  7955                                  
  7956                                  .process321:
  7957 00002954 E91403                   jmp .retnprocess
  7958                                  
  7959                                  ;-1294             }
  7960                                  
  7961                                  
  7962                                  ;-1295             if (Op == ADR) {//push string ABSOLUTE i16
  7963                                  
  7964                                  .process319:
  7965 00002957 A0[2D00]                 mov al, [Op]
  7966 0000295A 3C03                     cmp al, 3
  7967 0000295C 0F853700                 jne .process322
  7968                                  
  7969                                  ;-1296                 if (disp) {
  7970                                  
  7971 00002960 A1[3D00]                 mov ax, [disp]
  7972 00002963 08C0                     or  al, al
  7973 00002965 0F841800                 je .process323
  7974                                  
  7975                                  ;-1297                     genCode8(0x68);
  7976                                  
  7977 00002969 6A68                     push 104
  7978 0000296B E837F8                   call genCode8
  7979 0000296E 83C402                   add  sp, 2
  7980                                  
  7981                                  ;-1298                     genCode16(disp);
  7982                                  
  7983 00002971 FF36[3D00]               push word [disp]
  7984 00002975 E884F8                   call genCode16
  7985 00002978 83C402                   add  sp, 2
  7986                                  
  7987                                  ;-1299                     return;
  7988                                  
  7989 0000297B E9ED02                   jmp .retnprocess
  7990                                  
  7991                                  ;-1300                 }
  7992                                  
  7993                                  
  7994                                  ;-1301                 else {
  7995                                  
  7996 0000297E E91600                   jmp .process324
  7997                                  .process323:
  7998                                  
  7999                                  ;-1302                     genCode8(0x68);
  8000                                  
  8001 00002981 6A68                     push 104
  8002 00002983 E81FF8                   call genCode8
  8003 00002986 83C402                   add  sp, 2
  8004                                  
  8005                                  ;-1303                     genCode16(0);
  8006                                  
  8007 00002989 6A00                     push 0
  8008 0000298B E86EF8                   call genCode16
  8009 0000298E 83C402                   add  sp, 2
  8010                                  
  8011                                  ;-1304                     PrintRA='A';
  8012                                  
  8013 00002991 B84100                   mov ax, 65
  8014 00002994 A2[4500]                 mov byte [PrintRA], al
  8015                                  
  8016                                  ;-1305 //todo store Adr of push code, as storeJmpCall
  8017                                  
  8018                                  
  8019                                  ;-1306 
  8020                                  
  8021                                  
  8022                                  ;-1307                 }
  8023                                  
  8024                                  
  8025                                  ;-1308             }
  8026                                  
  8027                                  .process324:
  8028                                  
  8029                                  ;-1309         }
  8030                                  
  8031                                  .process322:
  8032                                  
  8033                                  ;-1310         if (R1Type == SEGREG) {
  8034                                  
  8035                                  .process318:
  8036 00002997 A0[3600]                 mov al, [R1Type]
  8037 0000299A 3C04                     cmp al, 4
  8038 0000299C 0F855A00                 jne .process325
  8039                                  
  8040                                  ;-1311             if (Code1 == 0x58) {//pop only
  8041                                  
  8042 000029A0 A0[3000]                 mov al, [Code1]
  8043 000029A3 3C58                     cmp al, 88
  8044 000029A5 0F851200                 jne .process326
  8045                                  
  8046                                  ;-1312                 if (R1No == 1) error1("pop cs not allowed");
  8047                                  
  8048 000029A9 A0[3400]                 mov al, [R1No]
  8049 000029AC 3C01                     cmp al, 1
  8050 000029AE 0F850900                 jne .process327
  8051 000029B2 68[6D2C]                 push process_0
  8052 000029B5 E8D5F0                   call error1
  8053 000029B8 83C402                   add  sp, 2
  8054                                  
  8055                                  ;-1313             }
  8056                                  
  8057                                  .process327:
  8058                                  
  8059                                  ;-1314             c = R1No <<3;
  8060                                  
  8061                                  .process326:
  8062 000029BB A0[3400]                 mov al, [R1No]
  8063 000029BE C0E003                   shl al, 3
  8064 000029C1 8846FE                   mov [bp-2], al
  8065                                  
  8066                                  ;-1315             if (R1No > 3) {//FS, GS
  8067                                  
  8068 000029C4 A0[3400]                 mov al, [R1No]
  8069 000029C7 3C03                     cmp al, 3
  8070 000029C9 0F8E0C00                 jle .process328
  8071                                  
  8072                                  ;-1316                 c += 122;
  8073                                  
  8074 000029CD 8046FE7A                 add  byte[bp-2], 122
  8075                                  
  8076                                  ;-1317                 genCode8(0x0F);
  8077                                  
  8078 000029D1 6A0F                     push 15
  8079 000029D3 E8CFF7                   call genCode8
  8080 000029D6 83C402                   add  sp, 2
  8081                                  
  8082                                  ;-1318             }
  8083                                  
  8084                                  
  8085                                  ;-1319             OpCodePtr++;
  8086                                  
  8087                                  .process328:
  8088 000029D9 FF06[4300]               inc  word[OpCodePtr]
  8089                                  
  8090                                  ;-1320             c = c + *OpCodePtr;//is Code4
  8091                                  
  8092 000029DD 8A46FE                   mov al, [bp-2]
  8093 000029E0 8B1E[4300]               mov bx, [OpCodePtr]
  8094 000029E4 0207                     add al, [bx]
  8095 000029E6 B400                     mov ah, 0
  8096 000029E8 8846FE                   mov [bp-2], al
  8097                                  
  8098                                  ;-1321             genCode8(c);
  8099                                  
  8100 000029EB 8A46FE                   mov al, byte [bp-2]
  8101 000029EE B400                     mov ah, 0
  8102 000029F0 50                       push ax
  8103 000029F1 E8B1F7                   call genCode8
  8104 000029F4 83C402                   add  sp, 2
  8105                                  
  8106                                  ;-1322             return;
  8107                                  
  8108 000029F7 E97102                   jmp .retnprocess
  8109                                  
  8110                                  ;-1323         }
  8111                                  
  8112                                  
  8113                                  ;-1324         checkOpL();//no ADR, SEGREG
  8114                                  
  8115                                  .process325:
  8116 000029FA E82ADB                   call checkOpL
  8117                                  
  8118                                  ;-1325         if (R1Type == BYTE) reg16error();
  8119                                  
  8120 000029FD A0[3600]                 mov al, [R1Type]
  8121 00002A00 3C01                     cmp al, 1
  8122 00002A02 0F850300                 jne .process329
  8123 00002A06 E808F2                   call reg16error
  8124                                  
  8125                                  ;-1326         if (R1Type == WORD) {
  8126                                  
  8127                                  .process329:
  8128 00002A09 A0[3600]                 mov al, [R1Type]
  8129 00002A0C 3C02                     cmp al, 2
  8130 00002A0E 0F851500                 jne .process330
  8131                                  
  8132                                  ;-1327             genCode2(Code1, R1No);
  8133                                  
  8134 00002A12 A0[3400]                 mov al, byte [R1No]
  8135 00002A15 B400                     mov ah, 0
  8136 00002A17 50                       push ax
  8137 00002A18 A0[3000]                 mov al, byte [Code1]
  8138 00002A1B B400                     mov ah, 0
  8139 00002A1D 50                       push ax
  8140 00002A1E E84DF7                   call genCode2
  8141 00002A21 83C404                   add  sp, 4
  8142                                  
  8143                                  ;-1328             return;
  8144                                  
  8145 00002A24 E94402                   jmp .retnprocess
  8146                                  
  8147                                  ;-1329         }
  8148                                  
  8149                                  
  8150                                  ;-1330         if (Op == MEM) {
  8151                                  
  8152                                  .process330:
  8153 00002A27 A0[2D00]                 mov al, [Op]
  8154 00002A2A 3C04                     cmp al, 4
  8155 00002A2C 0F851B00                 jne .process331
  8156                                  
  8157                                  ;-1331             genCode8(Code2);
  8158                                  
  8159 00002A30 A0[3100]                 mov al, byte [Code2]
  8160 00002A33 B400                     mov ah, 0
  8161 00002A35 50                       push ax
  8162 00002A36 E86CF7                   call genCode8
  8163 00002A39 83C402                   add  sp, 2
  8164                                  
  8165                                  ;-1332             writeEA(Code3);
  8166                                  
  8167 00002A3C A0[3200]                 mov al, byte [Code3]
  8168 00002A3F B400                     mov ah, 0
  8169 00002A41 50                       push ax
  8170 00002A42 E802F8                   call writeEA
  8171 00002A45 83C402                   add  sp, 2
  8172                                  
  8173                                  ;-1333             return;
  8174                                  
  8175 00002A48 E92002                   jmp .retnprocess
  8176                                  
  8177                                  ;-1334         }
  8178                                  
  8179                                  
  8180                                  ;-1335         syntaxerror();
  8181                                  
  8182                                  .process331:
  8183 00002A4B E812F2                   call syntaxerror
  8184                                  
  8185                                  ;-1336         return;
  8186                                  
  8187 00002A4E E91A02                   jmp .retnprocess
  8188                                  
  8189                                  ;-1337     }
  8190                                  
  8191                                  
  8192                                  ;-1338 
  8193                                  
  8194                                  
  8195                                  ;-1339     if (CodeType == 11) {//shift, rotate
  8196                                  
  8197                                  .process317:
  8198 00002A51 A0[2F00]                 mov al, [CodeType]
  8199 00002A54 3C0B                     cmp al, 11
  8200 00002A56 0F859200                 jne .process332
  8201                                  
  8202                                  ;-1340         check2Ops();
  8203                                  
  8204 00002A5A E84CDB                   call check2Ops
  8205                                  
  8206                                  ;-1341         if (Op2 == IMM) {
  8207                                  
  8208 00002A5D A0[2E00]                 mov al, [Op2]
  8209 00002A60 3C01                     cmp al, 1
  8210 00002A62 0F854400                 jne .process333
  8211                                  
  8212                                  ;-1342             if (imme == 1) {
  8213                                  
  8214 00002A66 A1[3F00]                 mov ax, [imme]
  8215 00002A69 83F801                   cmp ax, 1
  8216 00002A6C 0F851800                 jne .process334
  8217                                  
  8218                                  ;-1343                 genCodeW(0xD0);
  8219                                  
  8220 00002A70 68D000                   push 208
  8221 00002A73 E813F7                   call genCodeW
  8222 00002A76 83C402                   add  sp, 2
  8223                                  
  8224                                  ;-1344                 writeEA(Code1);
  8225                                  
  8226 00002A79 A0[3000]                 mov al, byte [Code1]
  8227 00002A7C B400                     mov ah, 0
  8228 00002A7E 50                       push ax
  8229 00002A7F E8C5F7                   call writeEA
  8230 00002A82 83C402                   add  sp, 2
  8231                                  
  8232                                  ;-1345                 return;
  8233                                  
  8234 00002A85 E9E301                   jmp .retnprocess
  8235                                  
  8236                                  ;-1346             }
  8237                                  
  8238                                  
  8239                                  ;-1347             genCodeW(0xC0);//80186
  8240                                  
  8241                                  .process334:
  8242 00002A88 68C000                   push 192
  8243 00002A8B E8FBF6                   call genCodeW
  8244 00002A8E 83C402                   add  sp, 2
  8245                                  
  8246                                  ;-1348             writeEA(Code1);
  8247                                  
  8248 00002A91 A0[3000]                 mov al, byte [Code1]
  8249 00002A94 B400                     mov ah, 0
  8250 00002A96 50                       push ax
  8251 00002A97 E8ADF7                   call writeEA
  8252 00002A9A 83C402                   add  sp, 2
  8253                                  
  8254                                  ;-1349             genCode8(imme);
  8255                                  
  8256 00002A9D FF36[3F00]               push word [imme]
  8257 00002AA1 E801F7                   call genCode8
  8258 00002AA4 83C402                   add  sp, 2
  8259                                  
  8260                                  ;-1350             return;
  8261                                  
  8262 00002AA7 E9C101                   jmp .retnprocess
  8263                                  
  8264                                  ;-1351         }
  8265                                  
  8266                                  
  8267                                  ;-1352         if (Op2 == REG) {
  8268                                  
  8269                                  .process333:
  8270 00002AAA A0[2E00]                 mov al, [Op2]
  8271 00002AAD 3C02                     cmp al, 2
  8272 00002AAF 0F853900                 jne .process335
  8273                                  
  8274                                  ;-1353             if (R2Type == BYTE) {
  8275                                  
  8276 00002AB3 A0[3500]                 mov al, [R2Type]
  8277 00002AB6 3C01                     cmp al, 1
  8278 00002AB8 0F853000                 jne .process336
  8279                                  
  8280                                  ;-1354                 if (R2No == 1) {//CL-REG
  8281                                  
  8282 00002ABC A0[3300]                 mov al, [R2No]
  8283 00002ABF 3C01                     cmp al, 1
  8284 00002AC1 0F852700                 jne .process337
  8285                                  
  8286                                  ;-1355                     if (R1Type == WORD) wflag=1;//hack
  8287                                  
  8288 00002AC5 A0[3600]                 mov al, [R1Type]
  8289 00002AC8 3C02                     cmp al, 2
  8290 00002ACA 0F850600                 jne .process338
  8291 00002ACE B80100                   mov ax, 1
  8292 00002AD1 A2[3800]                 mov byte [wflag], al
  8293                                  
  8294                                  ;-1356                     genCodeW(0xD2);
  8295                                  
  8296                                  .process338:
  8297 00002AD4 68D200                   push 210
  8298 00002AD7 E8AFF6                   call genCodeW
  8299 00002ADA 83C402                   add  sp, 2
  8300                                  
  8301                                  ;-1357                     writeEA(Code1);
  8302                                  
  8303 00002ADD A0[3000]                 mov al, byte [Code1]
  8304 00002AE0 B400                     mov ah, 0
  8305 00002AE2 50                       push ax
  8306 00002AE3 E861F7                   call writeEA
  8307 00002AE6 83C402                   add  sp, 2
  8308                                  
  8309                                  ;-1358                     return;
  8310                                  
  8311 00002AE9 E97F01                   jmp .retnprocess
  8312                                  
  8313                                  ;-1359                 }
  8314                                  
  8315                                  
  8316                                  ;-1360             }
  8317                                  
  8318                                  .process337:
  8319                                  
  8320                                  ;-1361         }
  8321                                  
  8322                                  .process336:
  8323                                  
  8324                                  ;-1362     }
  8325                                  
  8326                                  .process335:
  8327                                  
  8328                                  ;-1363 
  8329                                  
  8330                                  
  8331                                  ;-1364     if (CodeType == 12) {//int
  8332                                  
  8333                                  .process332:
  8334 00002AEC A0[2F00]                 mov al, [CodeType]
  8335 00002AEF 3C0C                     cmp al, 12
  8336 00002AF1 0F852200                 jne .process339
  8337                                  
  8338                                  ;-1365         if (TokeType == DIGIT) {
  8339                                  
  8340 00002AF5 A0[2C00]                 mov al, [TokeType]
  8341 00002AF8 3C01                     cmp al, 1
  8342 00002AFA 0F851900                 jne .process340
  8343                                  
  8344                                  ;-1366             genCode8(Code1);
  8345                                  
  8346 00002AFE A0[3000]                 mov al, byte [Code1]
  8347 00002B01 B400                     mov ah, 0
  8348 00002B03 50                       push ax
  8349 00002B04 E89EF6                   call genCode8
  8350 00002B07 83C402                   add  sp, 2
  8351                                  
  8352                                  ;-1367             genCode8(SymbolInt);
  8353                                  
  8354 00002B0A FF36[0E00]               push word [SymbolInt]
  8355 00002B0E E894F6                   call genCode8
  8356 00002B11 83C402                   add  sp, 2
  8357                                  
  8358                                  ;-1368             return;
  8359                                  
  8360 00002B14 E95401                   jmp .retnprocess
  8361                                  
  8362                                  ;-1369         }
  8363                                  
  8364                                  
  8365                                  ;-1370     }
  8366                                  
  8367                                  .process340:
  8368                                  
  8369                                  ;-1371 
  8370                                  
  8371                                  
  8372                                  ;-1372     if (CodeType == 30) {//enter i18,i8
  8373                                  
  8374                                  .process339:
  8375 00002B17 A0[2F00]                 mov al, [CodeType]
  8376 00002B1A 3C1E                     cmp al, 30
  8377 00002B1C 0F855200                 jne .process341
  8378                                  
  8379                                  ;-1373         genCode8(0xC8);
  8380                                  
  8381 00002B20 68C800                   push 200
  8382 00002B23 E87FF6                   call genCode8
  8383 00002B26 83C402                   add  sp, 2
  8384                                  
  8385                                  ;-1374         Op=getOp1();
  8386                                  
  8387 00002B29 E889DB                   call getOp1
  8388 00002B2C A2[2D00]                 mov byte [Op], al
  8389                                  
  8390                                  ;-1375         if (Op == IMM) genCode16(SymbolInt);
  8391                                  
  8392 00002B2F A0[2D00]                 mov al, [Op]
  8393 00002B32 3C01                     cmp al, 1
  8394 00002B34 0F850D00                 jne .process342
  8395 00002B38 FF36[0E00]               push word [SymbolInt]
  8396 00002B3C E8BDF6                   call genCode16
  8397 00002B3F 83C402                   add  sp, 2
  8398                                  
  8399                                  ;-1376         else numbererror();
  8400                                  
  8401 00002B42 E90300                   jmp .process343
  8402                                  .process342:
  8403 00002B45 E885F0                   call numbererror
  8404                                  
  8405                                  ;-1377         need(',');
  8406                                  
  8407                                  .process343:
  8408 00002B48 6A2C                     push 44
  8409 00002B4A E8BDE3                   call need
  8410 00002B4D 83C402                   add  sp, 2
  8411                                  
  8412                                  ;-1378         Op=getOp1();
  8413                                  
  8414 00002B50 E862DB                   call getOp1
  8415 00002B53 A2[2D00]                 mov byte [Op], al
  8416                                  
  8417                                  ;-1379         if (Op == IMM) genCode8 (SymbolInt);
  8418                                  
  8419 00002B56 A0[2D00]                 mov al, [Op]
  8420 00002B59 3C01                     cmp al, 1
  8421 00002B5B 0F850D00                 jne .process344
  8422 00002B5F FF36[0E00]               push word [SymbolInt]
  8423 00002B63 E83FF6                   call genCode8
  8424 00002B66 83C402                   add  sp, 2
  8425                                  
  8426                                  ;-1380         else numbererror();
  8427                                  
  8428 00002B69 E90300                   jmp .process345
  8429                                  .process344:
  8430 00002B6C E85EF0                   call numbererror
  8431                                  
  8432                                  ;-1381         return;
  8433                                  
  8434                                  .process345:
  8435 00002B6F E9F900                   jmp .retnprocess
  8436                                  
  8437                                  ;-1382     }
  8438                                  
  8439                                  
  8440                                  ;-1383 
  8441                                  
  8442                                  
  8443                                  ;-1384     if (CodeType==101) {//ORG nn
  8444                                  
  8445                                  .process341:
  8446 00002B72 A0[2F00]                 mov al, [CodeType]
  8447 00002B75 3C65                     cmp al, 101
  8448 00002B77 0F851500                 jne .process346
  8449                                  
  8450                                  ;-1385         if (TokeType != DIGIT) numbererror();
  8451                                  
  8452 00002B7B A0[2C00]                 mov al, [TokeType]
  8453 00002B7E 3C01                     cmp al, 1
  8454 00002B80 0F840300                 je  .process347
  8455 00002B84 E846F0                   call numbererror
  8456                                  
  8457                                  ;-1386         Origin=SymbolInt;
  8458                                  
  8459                                  .process347:
  8460 00002B87 A1[0E00]                 mov ax, [SymbolInt]
  8461 00002B8A A3[2500]                 mov word [Origin], ax
  8462                                  
  8463                                  ;-1387         return;
  8464                                  
  8465 00002B8D E9DB00                   jmp .retnprocess
  8466                                  
  8467                                  ;-1388     }
  8468                                  
  8469                                  
  8470                                  ;-1389 
  8471                                  
  8472                                  
  8473                                  ;-1390     if (CodeType == 102) {//section, segment
  8474                                  
  8475                                  .process346:
  8476 00002B90 A0[2F00]                 mov al, [CodeType]
  8477 00002B93 3C66                     cmp al, 102
  8478 00002B95 0F850900                 jne .process348
  8479                                  
  8480                                  ;-1391         //getTokeType();//ignore .bss .text .data
  8481                                  
  8482                                  
  8483                                  ;-1392         AbsoluteLab=0;//nasm resets erevy time
  8484                                  
  8485 00002B99 B80000                   mov ax, 0
  8486 00002B9C A3[2700]                 mov word [AbsoluteLab], ax
  8487                                  
  8488                                  ;-1393         return;
  8489                                  
  8490 00002B9F E9C900                   jmp .retnprocess
  8491                                  
  8492                                  ;-1394     }
  8493                                  
  8494                                  
  8495                                  ;-1395 
  8496                                  
  8497                                  
  8498                                  ;-1396     if (CodeType == 110) {//absolute
  8499                                  
  8500                                  .process348:
  8501 00002BA2 A0[2F00]                 mov al, [CodeType]
  8502 00002BA5 3C6E                     cmp al, 110
  8503 00002BA7 0F851500                 jne .process349
  8504                                  
  8505                                  ;-1397         if (TokeType != DIGIT) numbererror();
  8506                                  
  8507 00002BAB A0[2C00]                 mov al, [TokeType]
  8508 00002BAE 3C01                     cmp al, 1
  8509 00002BB0 0F840300                 je  .process350
  8510 00002BB4 E816F0                   call numbererror
  8511                                  
  8512                                  ;-1398         AbsoluteLab=SymbolInt;
  8513                                  
  8514                                  .process350:
  8515 00002BB7 A1[0E00]                 mov ax, [SymbolInt]
  8516 00002BBA A3[2700]                 mov word [AbsoluteLab], ax
  8517                                  
  8518                                  ;-1399         return;
  8519                                  
  8520 00002BBD E9AB00                   jmp .retnprocess
  8521                                  
  8522                                  ;-1400     }
  8523                                  
  8524                                  
  8525                                  ;-1401     if (CodeType == 111) {//name: PROC
  8526                                  
  8527                                  .process349:
  8528 00002BC0 A0[2F00]                 mov al, [CodeType]
  8529 00002BC3 3C6F                     cmp al, 111
  8530 00002BC5 0F854400                 jne .process351
  8531                                  
  8532                                  ;-1402         if (isInProc == 0)  {
  8533                                  
  8534 00002BC9 A0[0D00]                 mov al, [isInProc]
  8535 00002BCC 3C00                     cmp al, 0
  8536 00002BCE 0F852F00                 jne .process352
  8537                                  
  8538                                  ;-1403           prs("\n;entering: ");
  8539                                  
  8540 00002BD2 68[802C]                 push process_1
  8541 00002BD5 E863ED                   call prs
  8542 00002BD8 83C402                   add  sp, 2
  8543                                  
  8544                                  ;-1404           prs(ProcName);
  8545                                  
  8546 00002BDB 8D066E75                 lea  ax, [ProcName]
  8547 00002BDF 50                       push ax
  8548 00002BE0 E858ED                   call prs
  8549 00002BE3 83C402                   add  sp, 2
  8550                                  
  8551                                  ;-1405           isInProc=1;
  8552                                  
  8553 00002BE6 B80100                   mov ax, 1
  8554 00002BE9 A2[0D00]                 mov byte [isInProc], al
  8555                                  
  8556                                  ;-1406           locLabelNamePtr = LabelNamePtr;
  8557                                  
  8558 00002BEC A1[4600]                 mov ax, [LabelNamePtr]
  8559 00002BEF A3[4800]                 mov word [locLabelNamePtr], ax
  8560                                  
  8561                                  ;-1407           localLabelMaxIx = LabelMaxIx;
  8562                                  
  8563 00002BF2 A1[4A00]                 mov ax, [LabelMaxIx]
  8564 00002BF5 A3[4C00]                 mov word [localLabelMaxIx], ax
  8565                                  
  8566                                  ;-1408           locStrAdrIx = 0;  //push string is local to proc
  8567                                  
  8568 00002BF8 B80000                   mov ax, 0
  8569 00002BFB A3[5000]                 mov word [locStrAdrIx], ax
  8570                                  
  8571                                  ;-1409 
  8572                                  
  8573                                  
  8574                                  ;-1410         } else error1("already in proc");
  8575                                  
  8576 00002BFE E90900                   jmp .process353
  8577                                  .process352:
  8578 00002C01 68[8E2C]                 push process_2
  8579 00002C04 E886EE                   call error1
  8580 00002C07 83C402                   add  sp, 2
  8581                                  
  8582                                  ;-1411         return;
  8583                                  
  8584                                  .process353:
  8585 00002C0A E95E00                   jmp .retnprocess
  8586                                  
  8587                                  ;-1412     }
  8588                                  
  8589                                  
  8590                                  ;-1413     if (CodeType == 112) {//ENDP
  8591                                  
  8592                                  .process351:
  8593 00002C0D A0[2F00]                 mov al, [CodeType]
  8594 00002C10 3C70                     cmp al, 112
  8595 00002C12 0F854C00                 jne .process354
  8596                                  
  8597                                  ;-1414       prs("\n;leaving: ");
  8598                                  
  8599 00002C16 68[9E2C]                 push process_3
  8600 00002C19 E81FED                   call prs
  8601 00002C1C 83C402                   add  sp, 2
  8602                                  
  8603                                  ;-1415       prs(ProcName);
  8604                                  
  8605 00002C1F 8D066E75                 lea  ax, [ProcName]
  8606 00002C23 50                       push ax
  8607 00002C24 E814ED                   call prs
  8608 00002C27 83C402                   add  sp, 2
  8609                                  
  8610                                  ;-1416       isInProc=0;
  8611                                  
  8612 00002C2A B80000                   mov ax, 0
  8613 00002C2D A2[0D00]                 mov byte [isInProc], al
  8614                                  
  8615                                  ;-1417       i = LabelMaxIx - localLabelMaxIx;
  8616                                  
  8617 00002C30 A1[4A00]                 mov ax, [LabelMaxIx]
  8618 00002C33 2B06[4C00]               sub ax, [localLabelMaxIx]
  8619 00002C37 8946FC                   mov [bp-4], ax
  8620                                  
  8621                                  ;-1418       prs(". # local labels :");
  8622                                  
  8623 00002C3A 68[AB2C]                 push process_4
  8624 00002C3D E8FBEC                   call prs
  8625 00002C40 83C402                   add  sp, 2
  8626                                  
  8627                                  ;-1419       printIntU(i);
  8628                                  
  8629 00002C43 FF76FC                   push word [bp-4]
  8630 00002C46 E802EE                   call printIntU
  8631 00002C49 83C402                   add  sp, 2
  8632                                  
  8633                                  ;-1420       prs(". local strings to push :");
  8634                                  
  8635 00002C4C 68[BE2C]                 push process_5
  8636 00002C4F E8E9EC                   call prs
  8637 00002C52 83C402                   add  sp, 2
  8638                                  
  8639                                  ;-1421       printIntU(locStrAdrIx);
  8640                                  
  8641 00002C55 FF36[5000]               push word [locStrAdrIx]
  8642 00002C59 E8EFED                   call printIntU
  8643 00002C5C 83C402                   add  sp, 2
  8644                                  
  8645                                  ;-1422 // 1. close push string
  8646                                  
  8647                                  
  8648                                  ;-1423 
  8649                                  
  8650                                  
  8651                                  ;-1424 // 2. close open call/jmp
  8652                                  
  8653                                  
  8654                                  ;-1425 // 3. delete all local labels
  8655                                  
  8656                                  
  8657                                  ;-1426       return;
  8658                                  
  8659 00002C5F E90900                   jmp .retnprocess
  8660                                  
  8661                                  ;-1427     }
  8662                                  
  8663                                  
  8664                                  ;-1428     error1("Command not implemented or syntax error");
  8665                                  
  8666                                  .process354:
  8667 00002C62 68[D82C]                 push process_6
  8668 00002C65 E825EE                   call error1
  8669 00002C68 83C402                   add  sp, 2
  8670                                  
  8671                                  ;-1429 }
  8672                                  
  8673 00002C6B C9                       .retnprocess: LEAVE
  8674 00002C6C C3                       ret
  8675 00002C6D 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8676 00002C76 7420616C6C6F776564-
  8677 00002C7F 00                 
  8678 00002C80 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8679 00002C89 6E673A2000         
  8680 00002C8E 616C72656164792069-     process_2 db "already in proc",0
  8681 00002C97 6E2070726F6300     
  8682 00002C9E 5C6E3B6C656176696E-     process_3 db "\n;leaving: ",0
  8683 00002CA7 673A2000           
  8684 00002CAB 2E2023206C6F63616C-     process_4 db ". # local labels :",0
  8685 00002CB4 206C6162656C73203A-
  8686 00002CBD 00                 
  8687 00002CBE 2E206C6F63616C2073-     process_5 db ". local strings to push :",0
  8688 00002CC7 7472696E677320746F-
  8689 00002CD0 2070757368203A00   
  8690 00002CD8 436F6D6D616E64206E-     process_6 db "Command not implemented or syntax error",0
  8691 00002CE1 6F7420696D706C656D-
  8692 00002CEA 656E746564206F7220-
  8693 00002CF3 73796E746178206572-
  8694 00002CFC 726F7200           
  8695                                  ENDP
  8696                                   
  8697                                  ; missing functions: 
  8698                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8699 00002D00 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8700 00002D03 58                      pop ax
  8701 00002D04 C3                      ret
  8702                                   
  8703                                  ;   # type sign width  adr used name   list of global variables
  8704                                  
  8705                                  ;    1 arr sign byte     1    2 Version1[9]
  8706                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  8707                                  ;    3 arr sign byte     4   12 Symbol[31]
  8708                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  8709                                  ;    5 arr sign byte     6    3 ProcName[31]
  8710                                  ;    6 var sign byte     7    5 isInProc
  8711                                  ;    7 var unsg word     8   24 SymbolInt
  8712                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  8713                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  8714                                  ;   10 arr sign byte    11    4 InputBuf[255]
  8715                                  ;   11 ptr unsg byte    12   24 InputPtr
  8716                                  ;   12 arr sign byte    13    5 namein[67]
  8717                                  ;   13 arr sign byte    14    6 namelst[67]
  8718                                  ;   14 arr sign byte    15    6 namebin[67]
  8719                                  ;   15 var sign word    16    4 asm_fd
  8720                                  ;   16 var sign word    17    3 lst_fd
  8721                                  ;   17 var sign word    18    3 bin_fd
  8722                                  ;   18 var sign word    19    6 DOS_ERR
  8723                                  ;   19 var sign word    20    4 ErrorCount
  8724                                  ;   20 var sign word    21    4 DOS_NoBytes
  8725                                  ;   21 var sign byte    22    5 DOS_ByteRead
  8726                                  ;   22 var unsg word    24    7 PC
  8727                                  ;   23 var unsg word    25    5 Origin
  8728                                  ;   24 var unsg word    26    6 AbsoluteLab
  8729                                  ;   25 var unsg word    27    2 PCStart
  8730                                  ;   26 var sign byte    28    3 isLabel
  8731                                  ;   27 def unsg byte    29    - DIGIT=1
  8732                                  ;   28 def unsg byte    30    - LETTERE=2
  8733                                  ;   29 def unsg byte    31    - ALNUME=3
  8734                                  ;   30 def unsg byte    32    - NOALNUME=4
  8735                                  ;   31 var sign byte    33   27 TokeType
  8736                                  ;   32 def unsg byte    34    - BYTE=1
  8737                                  ;   33 def unsg byte    35    - WORD=2
  8738                                  ;   34 def unsg byte    36    - DWORD=3
  8739                                  ;   35 def unsg byte    37    - SEGREG=4
  8740                                  ;   36 def unsg byte    38    - IMM=1
  8741                                  ;   37 def unsg byte    39    - REG=2
  8742                                  ;   38 def unsg byte    40    - ADR=3
  8743                                  ;   39 def unsg byte    41    - MEM=4
  8744                                  ;   40 var sign byte    42   29 Op
  8745                                  ;   41 var sign byte    43   31 Op2
  8746                                  ;   42 var sign byte    44   29 CodeType
  8747                                  ;   43 var sign byte    45   23 Code1
  8748                                  ;   44 var sign byte    46    7 Code2
  8749                                  ;   45 var sign byte    47    3 Code3
  8750                                  ;   46 var sign byte    48   19 R2No
  8751                                  ;   47 var sign byte    49   16 R1No
  8752                                  ;   48 var sign byte    50   18 R2Type
  8753                                  ;   49 var sign byte    51   15 R1Type
  8754                                  ;   50 var sign byte    52   14 OpSize
  8755                                  ;   51 var sign byte    53    9 wflag
  8756                                  ;   52 var sign byte    54    3 dflag
  8757                                  ;   53 var sign byte    55    8 sflag
  8758                                  ;   54 var sign byte    56   15 rm
  8759                                  ;   55 var sign byte    57    5 isDirect
  8760                                  ;   56 var sign word    58   51 disp
  8761                                  ;   57 var unsg word    59   13 imme
  8762                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  8763                                  ;   59 arr sign byte    62    2 OpPos[5]
  8764                                  ;   60 var sign word    63    6 OpPrintIndex
  8765                                  ;   61 ptr sign byte    64   19 OpCodePtr
  8766                                  ;   62 var sign byte    65    5 PrintRA
  8767                                  ;   63 def unsg byte    67    - LABELNAMESMAX=3969
  8768                                  ;   64 arr sign byte    68    3 LabelNames[4000]
  8769                                  ;   65 ptr sign byte    69    6 LabelNamePtr
  8770                                  ;   66 var unsg word    70    1 locLabelNamePtr
  8771                                  ;   67 def unsg byte    71    - LABELADRMAX=600
  8772                                  ;   68 arr unsg word    72    7 LabelAddr[600]
  8773                                  ;   69 var sign word    73    9 LabelMaxIx
  8774                                  ;   70 var sign word    74    2 localLabelMaxIx
  8775                                  ;   71 var sign word    75   10 LabelIx
  8776                                  ;   72 var sign word    76    2 locStrAdrIx
  8777                                  ;   73 arr unsg word    77 NULL locStrAdr[100]
  8778                                  ;   74 def unsg byte    79    - JMPCALLNAMESMAX=1969
  8779                                  ;   75 arr sign byte    80    3 JmpCallNames[2000]
  8780                                  ;   76 ptr sign byte    81    5 JmpCallNamePtr
  8781                                  ;   77 def unsg byte    82    - JMPCALLMAX=500
  8782                                  ;   78 arr unsg word    83    2 JmpCallAddr[500]
  8783                                  ;   79 var sign word    84    6 JmpCallMaxIx
  8784                                  ;   80 def unsg byte    86    - FILEBINMAX=20000
  8785                                  ;   81 arr sign byte    87    4 FileBin[20000]
  8786                                  ;   82 var unsg word    88    6 BinLen
  8787                                  ;   83 ptr sign byte    90    1 arglen
  8788                                  ;   84 ptr sign byte    91    4 argv
  8789                                  ;   85 var sign byte    95    1 I_START
  8790                                  ;   86 arr sign byte    98 NULL I_PUSHA[3584]
  8791                                  ;   87 arr sign byte    99 NULL I_NOP[27]
  8792                                  ;   88 arr sign byte   100 NULL I_CWDE[1550]
  8793                                  ;   89 arr sign byte   101 NULL I_CDQ[1542]
  8794                                  ;   90 arr sign byte   102 NULL I_PUSHF[26118]
  8795                                  ;   91 arr sign byte   103 NULL I_SAHF[15462]
  8796                                  ;   92 arr sign byte   104 NULL I_MOVSB[0]
  8797                                  ;   93 arr sign byte   105 NULL I_CMPSB[6156]
  8798                                  ;   94 arr sign byte   106 NULL I_STOSB[48]
  8799                                  ;   95 arr sign byte   107 NULL I_LODSB[28024]
  8800                                  ;   96 arr sign byte   108 NULL I_SCASB[26977]
  8801                                  ;   97 arr sign byte   109 NULL I_LEAVE[110]
  8802                                  ;   98 arr sign byte   110 NULL I_INTO[13644]
  8803                                  ;   99 arr sign byte   111 NULL I_XLAT[19456]
  8804                                  ;  100 arr sign byte   112 NULL I_REPNE[54]
  8805                                  ;  101 arr sign byte   113 NULL I_REPE[14156]
  8806                                  ;  102 arr sign byte   114 NULL I_HLT[19456]
  8807                                  ;  103 arr sign byte   115 NULL I_STC[56]
  8808                                  ;  104 arr sign byte   116 NULL I_STI[14412]
  8809                                  ;  105 arr sign byte   117 NULL I_STD[19456]
  8810                                  ;  106 arr sign byte   119 NULL I_INC[57]
  8811                                  ;  107 arr sign byte   120 NULL I_DEC[14668]
  8812                                  ;  108 arr sign byte   121 NULL I_NOT[0]
  8813                                  ;  109 arr sign byte   122 NULL I_NEG[50812]
  8814                                  ;  110 arr sign byte   123 NULL I_MUL[50886]
  8815                                  ;  111 arr sign byte   124 NULL I_IMUL[31942]
  8816                                  ;  112 arr sign byte   125 NULL I_DIV[0]
  8817                                  ;  113 arr sign byte   126 NULL I_IDIV[0]
  8818                                  ;  114 arr sign byte   128 NULL I_LES[6156]
  8819                                  ;  115 arr sign byte   129 NULL I_LDS[48]
  8820                                  ;  116 arr sign byte   130 NULL I_LEA[52428]
  8821                                  ;  117 arr sign byte   131 NULL I_LSS[52428]
  8822                                  ;  118 arr sign byte   132 NULL I_LFS[30412]
  8823                                  ;  119 arr sign byte   133 NULL I_LGS[0]
  8824                                  ;  120 arr sign byte   135 NULL I_ADD[0]
  8825                                  ;  121 arr sign byte   136 NULL I_OR[30208]
  8826                                  ;  122 arr sign byte   137 NULL I_ADC[220]
  8827                                  ;  123 arr sign byte   138 NULL I_SBB[26332]
  8828                                  ;  124 arr sign byte   139 NULL I_AND[26214]
  8829                                  ;  125 arr sign byte   140 NULL I_SUB[26214]
  8830                                  ;  126 arr sign byte   141 NULL I_XOR[0]
  8831                                  ;  127 arr sign byte   142 NULL I_CMP[56438]
  8832                                  ;  128 arr sign byte   143 NULL I_TEST[50688]
  8833                                  ;  129 arr sign byte   145 NULL I_MOV[63206]
  8834                                  ;  130 arr sign byte   146 NULL I_MOVSX[57086]
  8835                                  ;  131 arr sign byte   147 NULL I_MOVZX[50894]
  8836                                  ;  132 arr sign byte   149 NULL I_JO[50886]
  8837                                  ;  133 arr sign byte   150 NULL I_JNO[0]
  8838                                  ;  134 arr sign byte   151 NULL I_JB[31942]
  8839                                  ;  135 arr sign byte   152 NULL I_JNB[15360]
  8840                                  ;  136 arr sign byte   153 NULL I_JAE[49766]
  8841                                  ;  137 arr sign byte   154 NULL I_JE[49344]
  8842                                  ;  138 arr sign byte   155 NULL I_JNE[50910]
  8843                                  ;  139 arr sign byte   156 NULL I_JBE[14950]
  8844                                  ;  140 arr sign byte   157 NULL I_JA[0]
  8845                                  ;  141 arr sign byte   158 NULL I_JS[0]
  8846                                  ;  142 arr sign byte   159 NULL I_JNS[50688]
  8847                                  ;  143 arr sign byte   160 NULL I_JP[124]
  8848                                  ;  144 arr sign byte   161 NULL I_JNP[52342]
  8849                                  ;  145 arr sign byte   162 NULL I_JL[52428]
  8850                                  ;  146 arr sign byte   163 NULL I_JNL[31948]
  8851                                  ;  147 arr sign byte   164 NULL I_JLE[30732]
  8852                                  ;  148 arr sign byte   165 NULL I_JG[27704]
  8853                                  ;  149 arr sign byte   167 NULL I_JMP[50688]
  8854                                  ;  150 arr sign byte   168 NULL I_CALL[50886]
  8855                                  ;  151 arr sign byte   170 NULL I_RET[50942]
  8856                                  ;  152 arr sign byte   171 NULL I_RETF[50886]
  8857                                  ;  153 arr sign byte   173 NULL I_PUSH[50886]
  8858                                  ;  154 arr sign byte   174 NULL I_POP[0]
  8859                                  ;  155 arr sign byte   176 NULL I_ROL[27704]
  8860                                  ;  156 arr sign byte   177 NULL I_RCL[57344]
  8861                                  ;  157 arr sign byte   178 NULL I_SHL[24672]
  8862                                  ;  158 arr sign byte   179 NULL I_SHR[30316]
  8863                                  ;  159 arr sign byte   181 NULL I_INT[26214]
  8864                                  ;  160 arr sign byte   183 NULL I_IN[58982]
  8865                                  ;  161 arr sign byte   184 NULL I_INSB[0]
  8866                                  ;  162 arr sign byte   185 NULL I_INSW[0]
  8867                                  ;  163 arr sign byte   186 NULL I_INSD[0]
  8868                                  ;  164 arr sign byte   187 NULL I_OUT[0]
  8869                                  ;  165 arr sign byte   188 NULL I_OUTSB[0]
  8870                                  ;  166 arr sign byte   189 NULL I_OUTSW[0]
  8871                                  ;  167 arr sign byte   190 NULL I_OUTSD[0]
  8872                                  ;  168 arr sign byte   192 NULL I_XCHG[0]
  8873                                  ;  169 arr sign byte   194 NULL I_LOOPNZ[24576]
  8874                                  ;  170 arr sign byte   195 NULL I_LOOPNE[25568]
  8875                                  ;  171 arr sign byte   196 NULL I_LOOPZ[27750]
  8876                                  ;  172 arr sign byte   197 NULL I_LOOPE[12312]
  8877                                  ;  173 arr sign byte   198 NULL I_LOOP[50030]
  8878                                  ;  174 arr sign byte   199 NULL I_JCXZ[3078]
  8879                                  ;  175 arr sign byte   200 NULL I_JECXZ[31]
  8880                                  ;  176 arr sign byte   202 NULL I_ENTER[13852]
  8881                                  ;  177 arr sign byte   204 NULL I_ORG[7680]
  8882                                  ;  178 arr sign byte   206 NULL I_SECTION[3084]
  8883                                  ;  179 arr sign byte   207 NULL I_SEGMENT[3084]
  8884                                  ;  180 arr sign byte   208 NULL I_ABSOLUTE[52236]
  8885                                  ;  181 arr sign byte   209 NULL I_PROC[30924]
  8886                                  ;  182 arr sign byte   210 NULL I_ENDP[0]
  8887                                  ;  183 arr sign byte   211 NULL I_DB[0]
  8888                                  ;  184 arr sign byte   212 NULL I_DW[0]
  8889                                  ;  185 arr sign byte   213 NULL I_DD[0]
  8890                                  ;  186 arr sign byte   214 NULL I_RESB[50812]
  8891                                  ;  187 arr sign byte   215 NULL I_RESW[7280]
  8892                                  ;  188 arr sign byte   216 NULL I_RESD[31942]
  8893                                  ;  189 var sign byte   217 NULL I_END
  8894                                  
  8895                                  
  8896                                  ;   # Calls Line Width  Name   list of functions
  8897                                  
  8898                                  ;    0    2  219   lookCode
  8899                                  ;    1    2  236   ChangeDirection
  8900                                  ;    2    2  244   checkOpL
  8901                                  ;    3    4  253   check2Ops
  8902                                  ;    4    1  262   get2Ops
  8903                                  ;    5    3  268   getOpL
  8904                                  ;    6    2  276   getOpR
  8905                                  ;    7    4  286   getOp1
  8906                                  ;    8    1  303   getMEM
  8907                                  ;    9    1  329   getIndReg1
  8908                                  ;   10    1  337   getIndReg2
  8909                                  ;   11    2  347   setwflag
  8910                                  ;   12    2  358   setsflag
  8911                                  ;   13    2  368   checkConstSize
  8912                                  ;   14    1  376   parse
  8913                                  ;   15   16  412   getTokeType
  8914                                  ;   16    2  423   storeJmpCall
  8915                                  ;   17    2  434   storeLabel
  8916                                  ;   18    5  446   searchLabel
  8917                                  ;   19    1  459   getVariable
  8918                                  ;   20    1  512   getCodeSize
  8919                                  ;   21    9  520   isToken
  8920                                  ;   22    2  528   need
  8921                                  ;   23    1  537   skipRest
  8922                                  ;   24    4  544   writetty
  8923                                  ;   25    1  545   putch
  8924                                  ;   26    8  546   cputs
  8925                                  ;   27    6  548   DosInt
  8926                                  ;   28    1  553   openR
  8927                                  ;   29    2  554   creatR
  8928                                  ;   30    3  555   fcloseR
  8929                                  ;   31    5  556   exitR
  8930                                  ;   32    2  557   readRL
  8931                                  ;   33    2  558   fputcR
  8932                                  ;   34    1  561   getLine
  8933                                  ;   35    1  577   ifEOL
  8934                                  ;   36    3  586   skipBlank
  8935                                  ;   37    2  591   letterE
  8936                                  ;   38    1  601   alnumE
  8937                                  ;   39    3  606   digit
  8938                                  ;   40    4  611   strlen
  8939                                  ;   41    9  616   strcpy
  8940                                  ;   42   35  622   eqstr
  8941                                  ;   43    3  631   strcat1
  8942                                  ;   44    2  635   toupper
  8943                                  ;   45    1  642   getDigit
  8944                                  ;   46    1  654   getName
  8945                                  ;   47    1  673   testReg
  8946                                  ;   48    1  717   printLine
  8947                                  ;   49    7  739   prc
  8948                                  ;   50    1  749   prscomment
  8949                                  ;   51   34  757   prs
  8950                                  ;   52    3  779   printhex8a
  8951                                  ;   53    2  784   printhex4
  8952                                  ;   54    1  789   printhex16
  8953                                  ;   55    7  794   printIntU
  8954                                  ;   56   27  805   error1
  8955                                  ;   57   13  812   errorexit
  8956                                  ;   58    2  817   notfounderror
  8957                                  ;   59 NULL  818   allowederror
  8958                                  ;   60    3  819   addrerror
  8959                                  ;   61    1  820   immeerror
  8960                                  ;   62    2  821   implerror
  8961                                  ;   63    4  822   indexerror
  8962                                  ;   64    3  823   invaloperror
  8963                                  ;   65    6  824   numbererror
  8964                                  ;   66    1  825   regmemerror
  8965                                  ;   67    3  826   reg16error
  8966                                  ;   68    1  827   segregerror
  8967                                  ;   69    5  828   syntaxerror
  8968                                  ;   70 NULL  830   addrexit
  8969                                  ;   71    3  831   dataexit
  8970                                  ;   72 NULL  832   internexit
  8971                                  ;   73 NULL  836   main
  8972                                  ;   74    1  844   getarg
  8973                                  ;   75    1  878   fixJmpCall
  8974                                  ;   76    2  909   epilog
  8975                                  ;   77    2  957   end1
  8976                                  ;   78    1  967   getCodes
  8977                                  ;   79    1  972   gen66h
  8978                                  ;   80    8  974   genCode2
  8979                                  ;   81   13  978   genCodeW
  8980                                  ;   82   35  982   genCode8
  8981                                  ;   83   19  993   genCode16
  8982                                  ;   84    1  997   genCode32
  8983                                  ;   85   13 1001   writeEA
  8984                                  ;   86    4 1043   genImmediate
  8985                                  ;   87    1 1050   process
  8986                                  ;   88 NULL 1429   LastFunctionByt
  8987                                  
  8988                                  ;    #  addr name   list of CALLs
  8989                                  
  8990                                  ;    0     0 eqstr
  8991                                  ;    1     6 implerror
  8992                                  ;    2    16 segregerror
  8993                                  ;    3    28 setwflag
  8994                                  ;    4    37 error1
  8995                                  ;    5    44 error1
  8996                                  ;    6    51 get2Ops
  8997                                  ;    7    59 addrerror
  8998                                  ;    8    69 invaloperror
  8999                                  ;    9    82 immeerror
  9000                                  ;   10    92 addrerror
  9001                                  ;   11   102 invaloperror
  9002                                  ;   12   115 setwflag
  9003                                  ;   13   124 getOpL
  9004                                  ;   14   131 need
  9005                                  ;   15   136 getOpR
  9006                                  ;   16   143 getOpR
  9007                                  ;   17   150 getOp1
  9008                                  ;   18   157 isToken
  9009                                  ;   19   165 getMEM
  9010                                  ;   20   172 invaloperror
  9011                                  ;   21   185 error1
  9012                                  ;   22   192 testReg
  9013                                  ;   23   200 searchLabel
  9014                                  ;   24   212 getTokeType
  9015                                  ;   25   224 getOp1
  9016                                  ;   26   231 syntaxerror
  9017                                  ;   27   243 getIndReg2
  9018                                  ;   28   254 getIndReg1
  9019                                  ;   29   265 notfounderror
  9020                                  ;   30   279 isToken
  9021                                  ;   31   287 getTokeType
  9022                                  ;   32   299 numbererror
  9023                                  ;   33   311 isToken
  9024                                  ;   34   319 isToken
  9025                                  ;   35   327 errorexit
  9026                                  ;   36   337 indexerror
  9027                                  ;   37   348 indexerror
  9028                                  ;   38   359 indexerror
  9029                                  ;   39   370 indexerror
  9030                                  ;   40   381 gen66h
  9031                                  ;   41   388 error1
  9032                                  ;   42   395 getLine
  9033                                  ;   43   403 getTokeType
  9034                                  ;   44   415 strcpy
  9035                                  ;   45   422 storeLabel
  9036                                  ;   46   433 getTokeType
  9037                                  ;   47   445 lookCode
  9038                                  ;   48   454 process
  9039                                  ;   49   462 getVariable
  9040                                  ;   50   474 skipRest
  9041                                  ;   51   483 error1
  9042                                  ;   52   490 error1
  9043                                  ;   53   497 printLine
  9044                                  ;   54   507 skipBlank
  9045                                  ;   55   517 digit
  9046                                  ;   56   523 getDigit
  9047                                  ;   57   532 letterE
  9048                                  ;   58   540 getName
  9049                                  ;   59   548 errorexit
  9050                                  ;   60   558 strcpy
  9051                                  ;   61   565 errorexit
  9052                                  ;   62   575 searchLabel
  9053                                  ;   63   587 error1
  9054                                  ;   64   594 errorexit
  9055                                  ;   65   604 strcpy
  9056                                  ;   66   611 errorexit
  9057                                  ;   67   621 eqstr
  9058                                  ;   68   627 strlen
  9059                                  ;   69   634 storeLabel
  9060                                  ;   70   645 getTokeType
  9061                                  ;   71   657 lookCode
  9062                                  ;   72   666 dataexit
  9063                                  ;   73   675 dataexit
  9064                                  ;   74   684 getTokeType
  9065                                  ;   75   696 genCode8
  9066                                  ;   76   705 skipBlank
  9067                                  ;   77   715 isToken
  9068                                  ;   78   723 genCode8
  9069                                  ;   79   732 isToken
  9070                                  ;   80   740 getTokeType
  9071                                  ;   81   752 genCode16
  9072                                  ;   82   762 isToken
  9073                                  ;   83   770 getTokeType
  9074                                  ;   84   782 genCode16
  9075                                  ;   85   792 genCode16
  9076                                  ;   86   802 isToken
  9077                                  ;   87   810 getTokeType
  9078                                  ;   88   822 syntaxerror
  9079                                  ;   89   834 error1
  9080                                  ;   90   841 numbererror
  9081                                  ;   91   853 dataexit
  9082                                  ;   92   862 eqstr
  9083                                  ;   93   868 getTokeType
  9084                                  ;   94   880 eqstr
  9085                                  ;   95   886 getTokeType
  9086                                  ;   96   898 eqstr
  9087                                  ;   97   904 getTokeType
  9088                                  ;   98   916 skipBlank
  9089                                  ;   99   926 isToken
  9090                                  ;  100   934 getTokeType
  9091                                  ;  101   946 error1
  9092                                  ;  102   953 prs
  9093                                  ;  103   957 prc
  9094                                  ;  104   961 getTokeType
  9095                                  ;  105   973 error1
  9096                                  ;  106   980 writetty
  9097                                  ;  107   989 writetty
  9098                                  ;  108   998 putch
  9099                                  ;  109  1004 DosInt
  9100                                  ;  110  1011 DosInt
  9101                                  ;  111  1018 DosInt
  9102                                  ;  112  1025 DosInt
  9103                                  ;  113  1032 DosInt
  9104                                  ;  114  1039 DosInt
  9105                                  ;  115  1046 readRL
  9106                                  ;  116  1053 errorexit
  9107                                  ;  117  1063 errorexit
  9108                                  ;  118  1073 ifEOL
  9109                                  ;  119  1079 readRL
  9110                                  ;  120  1086 errorexit
  9111                                  ;  121  1096 digit
  9112                                  ;  122  1102 letterE
  9113                                  ;  123  1110 strcpy
  9114                                  ;  124  1117 digit
  9115                                  ;  125  1123 alnumE
  9116                                  ;  126  1130 errorexit
  9117                                  ;  127  1140 strcpy
  9118                                  ;  128  1147 toupper
  9119                                  ;  129  1155 strlen
  9120                                  ;  130  1162 strlen
  9121                                  ;  131  1169 eqstr
  9122                                  ;  132  1175 eqstr
  9123                                  ;  133  1181 eqstr
  9124                                  ;  134  1187 eqstr
  9125                                  ;  135  1193 eqstr
  9126                                  ;  136  1199 eqstr
  9127                                  ;  137  1205 eqstr
  9128                                  ;  138  1211 eqstr
  9129                                  ;  139  1217 eqstr
  9130                                  ;  140  1223 eqstr
  9131                                  ;  141  1229 eqstr
  9132                                  ;  142  1235 eqstr
  9133                                  ;  143  1241 eqstr
  9134                                  ;  144  1247 eqstr
  9135                                  ;  145  1253 eqstr
  9136                                  ;  146  1259 eqstr
  9137                                  ;  147  1265 eqstr
  9138                                  ;  148  1271 eqstr
  9139                                  ;  149  1277 eqstr
  9140                                  ;  150  1283 eqstr
  9141                                  ;  151  1289 eqstr
  9142                                  ;  152  1295 eqstr
  9143                                  ;  153  1301 eqstr
  9144                                  ;  154  1307 eqstr
  9145                                  ;  155  1313 eqstr
  9146                                  ;  156  1319 eqstr
  9147                                  ;  157  1325 eqstr
  9148                                  ;  158  1331 eqstr
  9149                                  ;  159  1337 eqstr
  9150                                  ;  160  1343 eqstr
  9151                                  ;  161  1349 prs
  9152                                  ;  162  1353 printhex16
  9153                                  ;  163  1364 prs
  9154                                  ;  164  1368 prc
  9155                                  ;  165  1372 printhex8a
  9156                                  ;  166  1383 prs
  9157                                  ;  167  1387 prc
  9158                                  ;  168  1391 prscomment
  9159                                  ;  169  1402 writetty
  9160                                  ;  170  1411 writetty
  9161                                  ;  171  1420 fputcR
  9162                                  ;  172  1427 prc
  9163                                  ;  173  1431 prc
  9164                                  ;  174  1435 printhex4
  9165                                  ;  175  1445 printhex4
  9166                                  ;  176  1455 prc
  9167                                  ;  177  1459 printhex8a
  9168                                  ;  178  1470 printhex8a
  9169                                  ;  179  1481 printIntU
  9170                                  ;  180  1491 prc
  9171                                  ;  181  1495 prs
  9172                                  ;  182  1499 prs
  9173                                  ;  183  1503 prs
  9174                                  ;  184  1507 prs
  9175                                  ;  185  1511 error1
  9176                                  ;  186  1518 epilog
  9177                                  ;  187  1525 end1
  9178                                  ;  188  1530 error1
  9179                                  ;  189  1537 error1
  9180                                  ;  190  1544 error1
  9181                                  ;  191  1551 error1
  9182                                  ;  192  1558 error1
  9183                                  ;  193  1565 error1
  9184                                  ;  194  1572 error1
  9185                                  ;  195  1579 error1
  9186                                  ;  196  1586 error1
  9187                                  ;  197  1593 error1
  9188                                  ;  198  1600 error1
  9189                                  ;  199  1607 error1
  9190                                  ;  200  1614 errorexit
  9191                                  ;  201  1624 errorexit
  9192                                  ;  202  1634 errorexit
  9193                                  ;  203  1644 getarg
  9194                                  ;  204  1651 parse
  9195                                  ;  205  1657 fixJmpCall
  9196                                  ;  206  1668 epilog
  9197                                  ;  207  1675 end1
  9198                                  ;  208  1680 cputs
  9199                                  ;  209  1686 cputs
  9200                                  ;  210  1692 exitR
  9201                                  ;  211  1698 toupper
  9202                                  ;  212  1706 strcpy
  9203                                  ;  213  1713 strcat1
  9204                                  ;  214  1721 strcpy
  9205                                  ;  215  1728 strcat1
  9206                                  ;  216  1736 strcpy
  9207                                  ;  217  1743 strcat1
  9208                                  ;  218  1751 openR
  9209                                  ;  219  1757 cputs
  9210                                  ;  220  1763 cputs
  9211                                  ;  221  1769 exitR
  9212                                  ;  222  1775 creatR
  9213                                  ;  223  1782 cputs
  9214                                  ;  224  1788 cputs
  9215                                  ;  225  1794 exitR
  9216                                  ;  226  1800 creatR
  9217                                  ;  227  1807 cputs
  9218                                  ;  228  1813 cputs
  9219                                  ;  229  1819 exitR
  9220                                  ;  230  1825 prs
  9221                                  ;  231  1829 prs
  9222                                  ;  232  1833 prs
  9223                                  ;  233  1837 prs
  9224                                  ;  234  1841 prs
  9225                                  ;  235  1845 prs
  9226                                  ;  236  1849 prs
  9227                                  ;  237  1853 prs
  9228                                  ;  238  1857 prs
  9229                                  ;  239  1861 prs
  9230                                  ;  240  1865 printIntU
  9231                                  ;  241  1875 strcpy
  9232                                  ;  242  1882 strlen
  9233                                  ;  243  1889 searchLabel
  9234                                  ;  244  1901 error1
  9235                                  ;  245  1908 prs
  9236                                  ;  246  1912 printIntU
  9237                                  ;  247  1922 prs
  9238                                  ;  248  1926 prs
  9239                                  ;  249  1930 prs
  9240                                  ;  250  1934 prs
  9241                                  ;  251  1938 prs
  9242                                  ;  252  1942 prs
  9243                                  ;  253  1946 printIntU
  9244                                  ;  254  1956 prs
  9245                                  ;  255  1960 fputcR
  9246                                  ;  256  1967 prs
  9247                                  ;  257  1971 printIntU
  9248                                  ;  258  1981 prs
  9249                                  ;  259  1985 fcloseR
  9250                                  ;  260  1993 fcloseR
  9251                                  ;  261  2001 fcloseR
  9252                                  ;  262  2009 exitR
  9253                                  ;  263  2015 genCode8
  9254                                  ;  264  2024 genCode8
  9255                                  ;  265  2033 genCode8
  9256                                  ;  266  2042 errorexit
  9257                                  ;  267  2052 genCode8
  9258                                  ;  268  2061 genCode8
  9259                                  ;  269  2070 genCode16
  9260                                  ;  270  2080 genCode16
  9261                                  ;  271  2090 genCode8
  9262                                  ;  272  2099 genCode8
  9263                                  ;  273  2108 genCode16
  9264                                  ;  274  2118 genCode32
  9265                                  ;  275  2128 genCode16
  9266                                  ;  276  2138 genCode8
  9267                                  ;  277  2147 getTokeType
  9268                                  ;  278  2159 getCodeSize
  9269                                  ;  279  2171 getCodes
  9270                                  ;  280  2180 genCode8
  9271                                  ;  281  2189 getOpL
  9272                                  ;  282  2196 checkOpL
  9273                                  ;  283  2205 genCode2
  9274                                  ;  284  2214 getTokeType
  9275                                  ;  285  2226 implerror
  9276                                  ;  286  2236 genCodeW
  9277                                  ;  287  2245 writeEA
  9278                                  ;  288  2253 check2Ops
  9279                                  ;  289  2263 reg16error
  9280                                  ;  290  2274 addrerror
  9281                                  ;  291  2284 genCode8
  9282                                  ;  292  2293 genCode8
  9283                                  ;  293  2302 writeEA
  9284                                  ;  294  2310 check2Ops
  9285                                  ;  295  2320 setsflag
  9286                                  ;  296  2329 genCodeW
  9287                                  ;  297  2338 genImmediate
  9288                                  ;  298  2351 genCodeW
  9289                                  ;  299  2360 writeEA
  9290                                  ;  300  2368 genCode8
  9291                                  ;  301  2377 genImmediate
  9292                                  ;  302  2390 genCodeW
  9293                                  ;  303  2399 writeEA
  9294                                  ;  304  2407 genCodeW
  9295                                  ;  305  2416 writeEA
  9296                                  ;  306  2424 syntaxerror
  9297                                  ;  307  2436 check2Ops
  9298                                  ;  308  2446 notfounderror
  9299                                  ;  309  2460 genCode2
  9300                                  ;  310  2469 genImmediate
  9301                                  ;  311  2482 genCodeW
  9302                                  ;  312  2491 writeEA
  9303                                  ;  313  2499 genImmediate
  9304                                  ;  314  2512 regmemerror
  9305                                  ;  315  2524 ChangeDirection
  9306                                  ;  316  2540 reg16error
  9307                                  ;  317  2551 genCode2
  9308                                  ;  318  2560 writeEA
  9309                                  ;  319  2568 genCodeW
  9310                                  ;  320  2577 genCode16
  9311                                  ;  321  2587 genCodeW
  9312                                  ;  322  2596 genCode16
  9313                                  ;  323  2606 genCodeW
  9314                                  ;  324  2615 writeEA
  9315                                  ;  325  2623 ChangeDirection
  9316                                  ;  326  2639 genCodeW
  9317                                  ;  327  2648 writeEA
  9318                                  ;  328  2656 syntaxerror
  9319                                  ;  329  2668 searchLabel
  9320                                  ;  330  2680 checkConstSize
  9321                                  ;  331  2695 genCode2
  9322                                  ;  332  2704 genCode8
  9323                                  ;  333  2713 genCode8
  9324                                  ;  334  2722 genCode2
  9325                                  ;  335  2731 genCode16
  9326                                  ;  336  2741 genCode8
  9327                                  ;  337  2750 genCode2
  9328                                  ;  338  2759 genCode16
  9329                                  ;  339  2769 storeJmpCall
  9330                                  ;  340  2782 searchLabel
  9331                                  ;  341  2794 checkConstSize
  9332                                  ;  342  2809 genCode8
  9333                                  ;  343  2818 genCode8
  9334                                  ;  344  2827 genCode8
  9335                                  ;  345  2836 genCode16
  9336                                  ;  346  2846 genCode8
  9337                                  ;  347  2855 genCode16
  9338                                  ;  348  2865 genCode8
  9339                                  ;  349  2874 genCode16
  9340                                  ;  350  2884 storeJmpCall
  9341                                  ;  351  2897 genCode8
  9342                                  ;  352  2906 genCode16
  9343                                  ;  353  2916 genCode8
  9344                                  ;  354  2925 getOpL
  9345                                  ;  355  2932 setsflag
  9346                                  ;  356  2941 genCode2
  9347                                  ;  357  2950 genCode8
  9348                                  ;  358  2959 genCode16
  9349                                  ;  359  2969 genCode8
  9350                                  ;  360  2978 genCode16
  9351                                  ;  361  2988 genCode8
  9352                                  ;  362  2997 genCode16
  9353                                  ;  363  3007 error1
  9354                                  ;  364  3014 genCode8
  9355                                  ;  365  3023 genCode8
  9356                                  ;  366  3032 checkOpL
  9357                                  ;  367  3041 reg16error
  9358                                  ;  368  3052 genCode2
  9359                                  ;  369  3061 genCode8
  9360                                  ;  370  3070 writeEA
  9361                                  ;  371  3078 syntaxerror
  9362                                  ;  372  3090 check2Ops
  9363                                  ;  373  3100 genCodeW
  9364                                  ;  374  3109 writeEA
  9365                                  ;  375  3117 genCodeW
  9366                                  ;  376  3126 writeEA
  9367                                  ;  377  3134 genCode8
  9368                                  ;  378  3143 genCodeW
  9369                                  ;  379  3152 writeEA
  9370                                  ;  380  3160 genCode8
  9371                                  ;  381  3169 genCode8
  9372                                  ;  382  3178 genCode8
  9373                                  ;  383  3187 getOp1
  9374                                  ;  384  3194 genCode16
  9375                                  ;  385  3204 numbererror
  9376                                  ;  386  3216 need
  9377                                  ;  387  3221 getOp1
  9378                                  ;  388  3228 genCode8
  9379                                  ;  389  3237 numbererror
  9380                                  ;  390  3249 numbererror
  9381                                  ;  391  3261 numbererror
  9382                                  ;  392  3273 prs
  9383                                  ;  393  3277 prs
  9384                                  ;  394  3281 error1
  9385                                  ;  395  3288 prs
  9386                                  ;  396  3292 prs
  9387                                  ;  397  3296 prs
  9388                                  ;  398  3300 printIntU
  9389                                  ;  399  3310 prs
  9390                                  ;  400  3314 printIntU
  9391                                  ;  401  3324 error1
  9392                                  ;Input: AS.C, List: AS.S,  Lines: 1430
  9393                                  ;Glob. variables:  189 max.:  200
  9394                                  ;Functions      :   89 max.:  300
  9395                                  ;Calls          :  402 max.: 2000, NameField: 3331 max.:    65535
  9396                                  ;Code until     :21667 max.: 30000, free: 8333
  9397                                  ;Data (HeapEnd) :58954, resting stacksize:  6581
  9398                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
