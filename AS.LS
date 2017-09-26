     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9D91C                  jmp main
     5                                  
     6                                  ;-1 char Version1[]="AS.C V0.1";//BAS.BAT, AS TE, NAS.BAT
     7                                  
     8 00000003 41532E432056302E31-     Version1 db "AS.C V0.1",0
     9 0000000C 00                 
    10                                  
    11                                  ;-2 #include "DECL.C"
    12                                  
    13                                  ;Use include file: DECL.C
    14                                  
    15                                  ;-1 char LIST;              ///< listing on/off
    16                                  
    17 0000000D 00                      LIST db 0
    18                                  
    19                                  ;-2 #define SYMBOLMAX    31
    20                                  
    21                                  
    22                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    23                                  
    24                                  section .bss
    25                                  absolute 30000
    26 00007530 <res 0000001F>          Symbol resb 31
    27                                  section .text
    28                                  
    29                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    30                                  
    31                                  section .bss
    32                                  absolute 30031
    33 0000754F <res 0000001F>          SymbolUpper resb 31
    34                                  section .text
    35                                  
    36                                  ;-5 char ProcName[SYMBOLMAX];//name of actual proc
    37                                  
    38                                  section .bss
    39                                  absolute 30062
    40 0000756E <res 0000001F>          ProcName resb 31
    41                                  section .text
    42                                  
    43                                  ;-6 char isInProc=0;        //is inside a procedure
    44                                  
    45 0000000E 00                      isInProc db 0
    46                                  
    47                                  ;-7 unsigned int SymbolInt; //integer value set in getDigit
    48                                  
    49 0000000F 0000                    SymbolInt dw 0
    50                                  
    51                                  ;-8 unsigned long SymbolLong;//integer value set in getDigit
    52                                  
    53 00000011 00000000                SymbolLong dd 0
    54                                  
    55                                  ;-9 #define INPUTBUFMAX 255
    56                                  
    57                                  
    58                                  ;-10 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    59                                  
    60                                  section .bss
    61                                  absolute 30093
    62 0000758D <res 000000FF>          InputBuf resb 255
    63                                  section .text
    64                                  
    65                                  ;-11 unsigned char *InputPtr;//position in InputBuf
    66                                  
    67 00000015 0000                    InputPtr dw 0
    68                                  
    69                                  ;-12 char namein [67];       //input file name  .S
    70                                  
    71                                  section .bss
    72                                  absolute 30348
    73 0000768C <res 00000043>          namein resb 67
    74                                  section .text
    75                                  
    76                                  ;-13 char namelst[67];       //list file name   .LST
    77                                  
    78                                  section .bss
    79                                  absolute 30415
    80 000076CF <res 00000043>          namelst resb 67
    81                                  section .text
    82                                  
    83                                  ;-14 char namebin[67];       //output file name .COM
    84                                  
    85                                  section .bss
    86                                  absolute 30482
    87 00007712 <res 00000043>          namebin resb 67
    88                                  section .text
    89                                  
    90                                  ;-15 int  asm_fd;            //input file descriptor
    91                                  
    92 00000017 0000                    asm_fd dw 0
    93                                  
    94                                  ;-16 int lst_fd;             //list file descriptor
    95                                  
    96 00000019 0000                    lst_fd dw 0
    97                                  
    98                                  ;-17 int bin_fd;             //output file descriptor
    99                                  
   100 0000001B 0000                    bin_fd dw 0
   101                                  
   102                                  ;-18 int DOS_ERR=0;          //global var
   103                                  
   104 0000001D 0000                    DOS_ERR dw 0
   105                                  
   106                                  ;-19 int ErrorCount=0;       //number of errors
   107                                  
   108 0000001F 0000                    ErrorCount dw 0
   109                                  
   110                                  ;-20 int DOS_NoBytes;        //number of bytes read (0 or 1)
   111                                  
   112 00000021 0000                    DOS_NoBytes dw 0
   113                                  
   114                                  ;-21 char DOS_ByteRead;      //the byte just read by DOS
   115                                  
   116 00000023 00                      DOS_ByteRead db 0
   117                                  
   118                                  ;-22 
   119                                  
   120                                  
   121                                  ;-23 unsigned int PC=0;      //program counter
   122                                  
   123 00000024 0000                    PC dw 0
   124                                  
   125                                  ;-24 unsigned int Origin=0;  //ORG nn
   126                                  
   127 00000026 0000                    Origin dw 0
   128                                  
   129                                  ;-25 unsigned int AbsoluteLab=0;//uninitialised data
   130                                  
   131 00000028 0000                    AbsoluteLab dw 0
   132                                  
   133                                  ;-26 unsigned int PCStart;   //PC at start of line by PrintLine()
   134                                  
   135 0000002A 0000                    PCStart dw 0
   136                                  
   137                                  ;-27 char isLabel;           //by getName()
   138                                  
   139 0000002C 00                      isLabel db 0
   140                                  
   141                                  ;-28 #define DIGIT    1      //0-9
   142                                  
   143                                  
   144                                  ;-29 #define LETTERE  2      //a-z A-Z @ . _
   145                                  
   146                                  
   147                                  ;-30 #define ALNUME   3      //a-z A-Z @ . _  0-9
   148                                  
   149                                  
   150                                  ;-31 #define NOALNUME 4      //other char
   151                                  
   152                                  
   153                                  ;-32 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   154                                  
   155 0000002D 00                      TokeType db 0
   156                                  
   157                                  ;-33 #define BYTE     1
   158                                  
   159                                  
   160                                  ;-34 #define WORD     2
   161                                  
   162                                  
   163                                  ;-35 #define DWORD    3
   164                                  
   165                                  
   166                                  ;-36 #define SEGREG   4
   167                                  
   168                                  
   169                                  ;-37 #define IMM      1      //const  ,123
   170                                  
   171                                  
   172                                  ;-38 #define REG      2      //       ,BX    mode=11
   173                                  
   174                                  
   175                                  ;-39 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   176                                  
   177                                  
   178                                  ;-40 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   179                                  
   180                                  
   181                                  ;-41 char Op;                //1. operand: 0, IMM, REG, ADR, MEM
   182                                  
   183 0000002E 00                      Op db 0
   184                                  
   185                                  ;-42 char Op2;               //2. operand
   186                                  
   187 0000002F 00                      Op2 db 0
   188                                  
   189                                  ;-43 char CodeType;          //1-207 by searchSymbol(), must be byte size
   190                                  
   191 00000030 00                      CodeType db 0
   192                                  
   193                                  ;-44 char Code1;             //1. Opcode
   194                                  
   195 00000031 00                      Code1 db 0
   196                                  
   197                                  ;-45 char Code2;             //2. Opcode
   198                                  
   199 00000032 00                      Code2 db 0
   200                                  
   201                                  ;-46 char Code3;             //3. Opcode
   202                                  
   203 00000033 00                      Code3 db 0
   204                                  
   205                                  ;-47 char R2No;              //0 - 7 AL, CL, ...  set in testReg()
   206                                  
   207 00000034 00                      R2No db 0
   208                                  
   209                                  ;-48 char R1No;              //temp for 1. register
   210                                  
   211 00000035 00                      R1No db 0
   212                                  
   213                                  ;-49 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   214                                  
   215 00000036 00                      R2Type db 0
   216                                  
   217                                  ;-50 char R1Type;            //temp for 1. register
   218                                  
   219 00000037 00                      R1Type db 0
   220                                  
   221                                  ;-51 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   222                                  
   223 00000038 00                      OpSize db 0
   224                                  
   225                                  ;-52 char wflag;             //wordflag: 0=byte, 1=word/dword
   226                                  
   227 00000039 00                      wflag db 0
   228                                  
   229                                  ;-53 char dflag;             //directionflag: 1=to reg MOV,ALU
   230                                  
   231 0000003A 00                      dflag db 0
   232                                  
   233                                  ;-54 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3
   234                                  
   235 0000003B 00                      sflag db 0
   236                                  
   237                                  ;-55 char rm;                //combination of index and base reg
   238                                  
   239 0000003C 00                      rm db 0
   240                                  
   241                                  ;-56 char isDirect;          //set in process and getMeM, need in WriteEA
   242                                  
   243 0000003D 00                      isDirect db 0
   244                                  
   245                                  ;-57 int disp;               //displacement      0-8 bytes
   246                                  
   247 0000003E 0000                    disp dw 0
   248                                  
   249                                  ;-58 unsigned int imme;      //immediate         0-8 bytes
   250                                  
   251 00000040 0000                    imme dw 0
   252                                  
   253                                  ;-59 
   254                                  
   255                                  
   256                                  ;-60 #define OPMAXLEN 5
   257                                  
   258                                  
   259                                  ;-61 char OpPos[OPMAXLEN];   //array for one opcode to list
   260                                  
   261                                  section .bss
   262                                  absolute 30549
   263 00007755 <res 00000005>          OpPos resb 5
   264                                  section .text
   265                                  
   266                                  ;-62 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   267                                  
   268 00000042 0000                    OpPrintIndex dw 0
   269                                  
   270                                  ;-63 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   271                                  
   272 00000044 0000                    OpCodePtr dw 0
   273                                  
   274                                  ;-64 char PrintRA;           //print * for forward relocative jmp
   275                                  
   276 00000046 00                      PrintRA db 0
   277                                  
   278                                  ;-65 
   279                                  
   280                                  
   281                                  ;-66 #define LABELNAMESMAX 3969//next number - SYMBOLMAX
   282                                  
   283                                  
   284                                  ;-67 char LabelNames[4000];  //space for names of all labels
   285                                  
   286                                  section .bss
   287                                  absolute 30554
   288 0000775A <res 00000FA0>          LabelNames resb 4000
   289                                  section .text
   290                                  
   291                                  ;-68 char *LabelNamePtr;     //first free position
   292                                  
   293 00000047 0000                    LabelNamePtr dw 0
   294                                  
   295                                  ;-69 #define LABELADRMAX 600
   296                                  
   297                                  
   298                                  ;-70 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   299                                  
   300                                  section .bss
   301                                  absolute 34554
   302 000086FA <res 000004B0>          LabelAddr resw 600
   303                                  section .text
   304                                  
   305                                  ;-71 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   306                                  
   307 00000049 0000                    LabelMaxIx dw 0
   308                                  
   309                                  ;-72 int LabelIx;            //actual # of just searched label
   310                                  
   311 0000004B 0000                    LabelIx dw 0
   312                                  
   313                                  ;-73 
   314                                  
   315                                  
   316                                  ;-74 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   317                                  
   318                                  
   319                                  ;-75 char JmpCallNames[2000];//space for names of jmp, call
   320                                  
   321                                  section .bss
   322                                  absolute 35754
   323 00008BAA <res 000007D0>          JmpCallNames resb 2000
   324                                  section .text
   325                                  
   326                                  ;-76 char *JmpCallNamePtr;   //first free position
   327                                  
   328 0000004D 0000                    JmpCallNamePtr dw 0
   329                                  
   330                                  ;-77 #define JMPCALLMAX 500  //max. jmp and call
   331                                  
   332                                  
   333                                  ;-78 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   334                                  
   335                                  section .bss
   336                                  absolute 37754
   337 0000937A <res 000003E8>          JmpCallAddr resw 500
   338                                  section .text
   339                                  
   340                                  ;-79 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   341                                  
   342 0000004F 0000                    JmpCallMaxIx dw 0
   343                                  
   344                                  ;-80 
   345                                  
   346                                  
   347                                  ;-81 #define FILEBINMAX 20000
   348                                  
   349                                  
   350                                  ;-82 char FileBin  [FILEBINMAX];//output binary file
   351                                  
   352                                  section .bss
   353                                  absolute 38754
   354 00009762 <res 00004E20>          FileBin resb 20000
   355                                  section .text
   356                                  
   357                                  ;-83 unsigned int BinLen=0;  //length of binary file
   358                                  
   359 00000051 0000                    BinLen dw 0
   360                                  
   361                                  ;-84 
   362                                  
   363                                  
   364                                  ;-85 char *arglen=0x80;      // for main only
   365                                  
   366 00000053 8000                    arglen dw 128
   367                                  
   368                                  ;-86 char *argv=0x82;        // for main only
   369                                  
   370 00000055 8200                    argv dw 130
   371                                  ;Back to main program: AS.C
   372                                  
   373                                  ;-3 #include "OPTABL.C"
   374                                  
   375                                  ;Use include file: OPTABL.C
   376                                  
   377                                  ;-1 char I_START=0xF1;
   378                                  
   379 00000057 F1                      I_START db 241
   380                                  
   381                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   382                                  
   383                                  
   384                                  ;-3 //  1:   1 byte opcode
   385                                  
   386                                  
   387                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};
   388                                  
   389 00000058 5055534841000160F1-     I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241
   390 00000061 504F5041000161F1   
   391                                  
   392                                  ;-5 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};
   393                                  
   394 00000069 4E4F50000190F14342-     I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241
   395 00000072 57000198F1         
   396                                  
   397                                  ;-6 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};
   398                                  
   399 00000077 43574445000198F143-     I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241
   400 00000080 5744000199F1       
   401                                  
   402                                  ;-7 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};
   403                                  
   404 00000086 434451000199F15741-     I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241
   405 0000008F 495400019BF1       
   406                                  
   407                                  ;-8 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};
   408                                  
   409 00000095 505553484600019CF1-     I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241
   410 0000009E 504F504600019DF1   
   411                                  
   412                                  ;-9 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};
   413                                  
   414 000000A6 5341484600019EF14C-     I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241
   415 000000AF 41484600019FF1     
   416                                  
   417                                  ;-10 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};
   418                                  
   419 000000B6 4D4F5653420001A4F1-     I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241
   420 000000BF 4D4F5653570001A5F1 
   421                                  
   422                                  ;-11 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};
   423                                  
   424 000000C8 434D5053420001A6F1-     I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241
   425 000000D1 434D5053570001A7F1 
   426                                  
   427                                  ;-12 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};
   428                                  
   429 000000DA 53544F53420001AAF1-     I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241
   430 000000E3 53544F53570001ABF1 
   431                                  
   432                                  ;-13 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};
   433                                  
   434 000000EC 4C4F4453420001ACF1-     I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241
   435 000000F5 4C4F4453570001ADF1 
   436                                  
   437                                  ;-14 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};
   438                                  
   439 000000FE 53434153420001AEF1-     I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241
   440 00000107 53434153570001AFF1 
   441                                  
   442                                  ;-15 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};
   443                                  
   444 00000110 4C454156450001C9F1-     I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241
   445 00000119 494E54330001CCF1   
   446                                  
   447                                  ;-16 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};
   448                                  
   449 00000121 494E544F0001CEF149-     I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241
   450 0000012A 5245540001CFF1     
   451                                  
   452                                  ;-17 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};
   453                                  
   454 00000131 584C41540001D7F14C-     I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241
   455 0000013A 4F434B0001F0F1     
   456                                  
   457                                  ;-18 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};
   458                                  
   459 00000141 5245504E450001F2F1-     I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241
   460 0000014A 5245504E5A0001F2F1 
   461                                  
   462                                  ;-19 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};
   463                                  
   464 00000153 524550450001F3F152-     I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241
   465 0000015C 45505A0001F3F1     
   466                                  
   467                                  ;-20 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};
   468                                  
   469 00000163 484C540001F4F1434C-     I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241
   470 0000016C 430001F8F1         
   471                                  
   472                                  ;-21 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};
   473                                  
   474 00000171 5354430001F9F1434C-     I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241
   475 0000017A 490001FAF1         
   476                                  
   477                                  ;-22 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};
   478                                  
   479 0000017F 5354490001FBF1434C-     I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241
   480 00000188 440001FCF1         
   481                                  
   482                                  ;-23 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};
   483                                  
   484 0000018D 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   485                                  
   486                                  ;-24 // 2: mem reg 16 bit
   487                                  
   488                                  
   489                                  ;-25 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   490                                  
   491 00000194 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   492                                  
   493                                  ;-26 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   494                                  
   495 0000019D 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   496                                  
   497                                  ;-27 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   498                                  
   499 000001A6 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   500                                  
   501                                  ;-28 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   502                                  
   503 000001AE 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   504                                  
   505                                  ;-29 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   506                                  
   507 000001B6 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   508                                  
   509                                  ;-30 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   510                                  
   511 000001BE 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   512                                  
   513                                  ;-31 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   514                                  
   515 000001C7 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   516                                  
   517                                  ;-32 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   518                                  
   519 000001CF 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   520                                  
   521                                  ;-33 //  3: les, lda, lea, lss, lfs, lgs
   522                                  
   523                                  
   524                                  ;-34 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   525                                  
   526 000001D8 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   527                                  
   528                                  ;-35 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   529                                  
   530 000001DF 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   531                                  
   532                                  ;-36 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   533                                  
   534 000001E6 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   535                                  
   536                                  ;-37 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   537                                  
   538 000001ED 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   539                                  
   540                                  ;-38 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   541                                  
   542 000001F5 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   543                                  
   544                                  ;-39 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   545                                  
   546 000001FD 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   547                                  
   548                                  ;-40 //  4: acc,imm  reg,imm  index,reg
   549                                  
   550                                  
   551                                  ;-41 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   552                                  
   553 00000205 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   554                                  
   555                                  ;-42 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   556                                  
   557 0000020C 4F52000401F1            I_OR db 79,82,0,4,1,241
   558                                  
   559                                  ;-43 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   560                                  
   561 00000212 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   562                                  
   563                                  ;-44 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   564                                  
   565 00000219 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   566                                  
   567                                  ;-45 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   568                                  
   569 00000220 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   570                                  
   571                                  ;-46 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   572                                  
   573 00000227 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   574                                  
   575                                  ;-47 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   576                                  
   577 0000022E 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   578                                  
   579                                  ;-48 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   580                                  
   581 00000235 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   582                                  
   583                                  ;-49 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   584                                  
   585 0000023C 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   586 00000245 00F1               
   587                                  
   588                                  ;-50 //  5: mov
   589                                  
   590                                  
   591                                  ;-51 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   592                                  
   593 00000247 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   594                                  
   595                                  ;-52 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   596                                  
   597 0000024D 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   598                                  
   599                                  ;-53 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   600                                  
   601 00000256 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   602                                  
   603                                  ;-54 //  6: single byte relative jump
   604                                  
   605                                  
   606                                  ;-55 char I_JO []=  {'J','O',0,     6, 0,0xF1};
   607                                  
   608 0000025F 4A4F000600F1            I_JO db 74,79,0,6,0,241
   609                                  
   610                                  ;-56 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
   611                                  
   612 00000265 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   613                                  
   614                                  ;-57 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
   615                                  
   616 0000026C 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
   617 00000275 0602F1             
   618                                  
   619                                  ;-58 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
   620                                  
   621 00000278 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   622                                  
   623                                  ;-59 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
   624                                  
   625 0000027F 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
   626 00000288 43000603F1         
   627                                  
   628                                  ;-60 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
   629                                  
   630 0000028D 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
   631 00000296 0604F1             
   632                                  
   633                                  ;-61 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
   634                                  
   635 00000299 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
   636 000002A2 5A000605F1         
   637                                  
   638                                  ;-62 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
   639                                  
   640 000002A7 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
   641 000002B0 41000606F1         
   642                                  
   643                                  ;-63 char I_JA []=  {'J','A',0,     6, 7,0xF1};
   644                                  
   645 000002B5 4A41000607F1            I_JA db 74,65,0,6,7,241
   646                                  
   647                                  ;-64 char I_JS []=  {'J','S',0,     6, 8,0xF1};
   648                                  
   649 000002BB 4A53000608F1            I_JS db 74,83,0,6,8,241
   650                                  
   651                                  ;-65 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
   652                                  
   653 000002C1 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   654                                  
   655                                  ;-66 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
   656                                  
   657 000002C8 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
   658 000002D1 00060AF1           
   659                                  
   660                                  ;-67 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
   661                                  
   662 000002D5 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
   663 000002DE 4F00060BF1         
   664                                  
   665                                  ;-68 char I_JL []=  {'J','L',0,     6,12,0xF1};
   666                                  
   667 000002E3 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   668                                  
   669                                  ;-69 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
   670                                  
   671 000002E9 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
   672 000002F2 4500060DF1         
   673                                  
   674                                  ;-70 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
   675                                  
   676 000002F7 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
   677 00000300 4700060EF1         
   678                                  
   679                                  ;-71 char I_JG []=  {'J','G',0,     6,15,0xF1};
   680                                  
   681 00000305 4A4700060FF1            I_JG db 74,71,0,6,15,241
   682                                  
   683                                  ;-72 //  7: jmp, call
   684                                  
   685                                  
   686                                  ;-73 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   687                                  
   688 0000030B 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   689                                  
   690                                  ;-74 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   691                                  
   692 00000313 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   693                                  
   694                                  ;-75 //  8: ret
   695                                  
   696                                  
   697                                  ;-76 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   698                                  
   699 0000031C 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   700                                  
   701                                  ;-77 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   702                                  
   703 00000324 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   704                                  
   705                                  ;-78 //  9: seg, r/m
   706                                  
   707                                  
   708                                  ;-79 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   709                                  
   710 0000032D 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   711 00000336 06F1               
   712                                  
   713                                  ;-80 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   714                                  
   715 00000338 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   716 00000341 F1                 
   717                                  
   718                                  ;-81 //  11: shift, rotates
   719                                  
   720                                  
   721                                  ;-82 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
   722                                  
   723 00000342 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
   724 0000034B 52000B01F1         
   725                                  
   726                                  ;-83 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
   727                                  
   728 00000350 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
   729 00000359 52000B03F1         
   730                                  
   731                                  ;-84 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
   732                                  
   733 0000035E 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
   734 00000367 4C000B04F1         
   735                                  
   736                                  ;-85 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
   737                                  
   738 0000036C 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
   739 00000375 52000B07F1         
   740                                  
   741                                  ;-86 //  12: int
   742                                  
   743                                  
   744                                  ;-87 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   745                                  
   746 0000037A 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   747                                  
   748                                  ;-88 //  14: in/out
   749                                  
   750                                  
   751                                  ;-89 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   752                                  
   753 00000382 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   754                                  
   755                                  ;-90 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   756                                  
   757 00000389 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   758                                  
   759                                  ;-91 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   760                                  
   761 00000391 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   762                                  
   763                                  ;-92 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   764                                  
   765 00000399 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   766                                  
   767                                  ;-93 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   768                                  
   769 000003A1 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   770                                  
   771                                  ;-94 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   772                                  
   773 000003A9 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   774                                  
   775                                  ;-95 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   776                                  
   777 000003B1 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   778                                  
   779                                  ;-96 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   780                                  
   781 000003B9 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   782                                  
   783                                  ;-97 //  15: xchg
   784                                  
   785                                  
   786                                  ;-98 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   787                                  
   788 000003C1 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   789                                  
   790                                  ;-99 //  16: loop, jcxz
   791                                  
   792                                  
   793                                  ;-100 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   794                                  
   795 000003CA 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   796 000003D3 F1                 
   797                                  
   798                                  ;-101 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   799                                  
   800 000003D4 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   801 000003DD F1                 
   802                                  
   803                                  ;-102 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   804                                  
   805 000003DE 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   806                                  
   807                                  ;-103 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   808                                  
   809 000003E7 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   810                                  
   811                                  ;-104 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   812                                  
   813 000003F0 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   814                                  
   815                                  ;-105 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   816                                  
   817 000003F8 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   818                                  
   819                                  ;-106 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   820                                  
   821 00000400 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   822                                  
   823                                  ;-107 //  30: enter
   824                                  
   825                                  
   826                                  ;-108 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
   827                                  
   828 00000409 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   829                                  
   830                                  ;-109 // 100: directives
   831                                  
   832                                  
   833                                  ;-110 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   834                                  
   835 00000411 4F52470065F1            I_ORG db 79,82,71,0,101,241
   836                                  
   837                                  ;-111 // section, segment .TEXT .DATA .BSS
   838                                  
   839                                  
   840                                  ;-112 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   841                                  
   842 00000417 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   843 00000420 F1                 
   844                                  
   845                                  ;-113 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   846                                  
   847 00000421 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   848 0000042A F1                 
   849                                  
   850                                  ;-114 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   851                                  
   852 0000042B 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   853 00000434 6EF1               
   854                                  
   855                                  ;-115 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
   856                                  
   857 00000436 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
   858                                  
   859                                  ;-116 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
   860                                  
   861 0000043D 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
   862                                  
   863                                  ;-117 char I_DB[]=   {'D','B',0,            200,        0xF1};
   864                                  
   865 00000444 444200C8F1              I_DB db 68,66,0,200,241
   866                                  
   867                                  ;-118 char I_DW[]=   {'D','W',0,            201,        0xF1};
   868                                  
   869 00000449 445700C9F1              I_DW db 68,87,0,201,241
   870                                  
   871                                  ;-119 char I_DD[]=   {'D','D',0,            202,        0xF1};
   872                                  
   873 0000044E 444400CAF1              I_DD db 68,68,0,202,241
   874                                  
   875                                  ;-120 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   876                                  
   877 00000453 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   878                                  
   879                                  ;-121 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   880                                  
   881 0000045A 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   882                                  
   883                                  ;-122 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   884                                  
   885 00000461 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   886                                  
   887                                  ;-123 char I_END=0;// end of table char
   888                                  
   889 00000468 00                      I_END db 0
   890                                  ;Back to main program: AS.C
   891                                  
   892                                  ;-4 #include "OPS.C"
   893                                  
   894                                  ;Use include file: OPS.C
   895                                  
   896                                  ;-1 int ChangeDirection() {
   897                                  
   898                                  
   899                                  ChangeDirection: PROC
   900                                  
   901                                  ;-2     char c;
   902                                  
   903                                  
   904                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   905                                  
   906                                  ;Function : ChangeDirection, Number of local variables: 1
   907                                  ;   # type sign width addr used name   list of local variables
   908                                  ;  200 var sign byte     2 NULL c = bp-2;
   909 00000469 C8020000                 ENTER  2,0
   910 0000046D A0[2E00]                 mov al, [Op]
   911 00000470 8846FE                   mov [bp-2], al
   912 00000473 A0[2F00]                 mov al, [Op2]
   913 00000476 A2[2E00]                 mov byte [Op], al
   914 00000479 8A46FE                   mov al, [bp-2]
   915 0000047C A2[2F00]                 mov byte [Op2], al
   916                                  
   917                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   918                                  
   919 0000047F A0[3700]                 mov al, [R1Type]
   920 00000482 8846FE                   mov [bp-2], al
   921 00000485 A0[3600]                 mov al, [R2Type]
   922 00000488 A2[3700]                 mov byte [R1Type], al
   923 0000048B 8A46FE                   mov al, [bp-2]
   924 0000048E A2[3600]                 mov byte [R2Type], al
   925                                  
   926                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   927                                  
   928 00000491 A0[3500]                 mov al, [R1No]
   929 00000494 8846FE                   mov [bp-2], al
   930 00000497 A0[3400]                 mov al, [R2No]
   931 0000049A A2[3500]                 mov byte [R1No], al
   932 0000049D 8A46FE                   mov al, [bp-2]
   933 000004A0 A2[3400]                 mov byte [R2No], al
   934                                  
   935                                  ;-6     dflag=2;     
   936                                  
   937 000004A3 B80200                   mov ax, 2
   938 000004A6 A2[3A00]                 mov byte [dflag], al
   939                                  
   940                                  ;-7 }
   941                                  
   942                                  
   943                                  ;-8      
   944                                  
   945                                  
   946                                  ;-9 int checkOpL() {
   947 000004A9 C9                       LEAVE
   948 000004AA C3                       ret
   949                                  ENDP
   950                                  
   951                                  checkOpL: PROC
   952                                  
   953                                  ;-10     if (Op == ADR) implerror();
   954                                  
   955 000004AB A0[2E00]                 mov al, [Op]
   956 000004AE 3C03                     cmp al, 3
   957 000004B0 0F850300                 jne .checkOpL1
   958 000004B4 E8C316                   call implerror
   959                                  
   960                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   961                                  
   962                                  .checkOpL1:
   963 000004B7 A0[3700]                 mov al, [R1Type]
   964 000004BA 3C04                     cmp al, 4
   965 000004BC 0F850600                 jne .checkOpL2
   966 000004C0 E87F17                   call segregerror
   967 000004C3 E93E00                   jmp .retncheckOpL
   968                                  
   969                                  ;-12     setwflag();
   970                                  
   971                                  .checkOpL2:
   972 000004C6 E88C03                   call setwflag
   973                                  
   974                                  ;-13     if (OpSize == 0) error1("no op size declared");
   975                                  
   976 000004C9 A0[3800]                 mov al, [OpSize]
   977 000004CC 3C00                     cmp al, 0
   978 000004CE 0F850900                 jne .checkOpL3
   979 000004D2 68[0505]                 push checkOpL_0
   980 000004D5 E8D215                   call error1
   981 000004D8 83C402                   add  sp, 2
   982                                  
   983                                  ;-14     if (OpSize == R1Type) return;
   984                                  
   985                                  .checkOpL3:
   986 000004DB A0[3800]                 mov al, [OpSize]
   987 000004DE 3A06[3700]               cmp al, [R1Type]
   988 000004E2 0F850300                 jne .checkOpL4
   989 000004E6 E91B00                   jmp .retncheckOpL
   990                                  
   991                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
   992                                  
   993                                  .checkOpL4:
   994 000004E9 A0[2E00]                 mov al, [Op]
   995 000004EC 3C02                     cmp al, 2
   996 000004EE 0F851200                 jne .checkOpL5
   997 000004F2 A0[3700]                 mov al, [R1Type]
   998 000004F5 3C00                     cmp al, 0
   999 000004F7 0F850900                 jne .checkOpL6
  1000 000004FB 68[1905]                 push checkOpL_1
  1001 000004FE E8A915                   call error1
  1002 00000501 83C402                   add  sp, 2
  1003                                  
  1004                                  ;-16 }
  1005                                  
  1006                                  .checkOpL6:
  1007                                  .checkOpL5:
  1008                                  
  1009                                  ;-17     
  1010                                  
  1011                                  
  1012                                  ;-18 int check2Ops() {
  1013                                  
  1014                                   .retncheckOpL:
  1015 00000504 C3                       ret
  1016 00000505 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1017 0000050E 65206465636C617265-
  1018 00000517 6400               
  1019 00000519 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1020 00000522 657220646566696E65-
  1021 0000052B 6400               
  1022                                  ENDP
  1023                                  
  1024                                  check2Ops: PROC
  1025                                  
  1026                                  ;-19     get2Ops();
  1027                                  
  1028 0000052D E84900                   call get2Ops
  1029                                  
  1030                                  ;-20     if (Op ==   0) addrerror();
  1031                                  
  1032 00000530 A0[2E00]                 mov al, [Op]
  1033 00000533 3C00                     cmp al, 0
  1034 00000535 0F850300                 jne .check2Ops7
  1035 00000539 E8FF15                   call addrerror
  1036                                  
  1037                                  ;-21     if (Op == ADR) invaloperror(); 
  1038                                  
  1039                                  .check2Ops7:
  1040 0000053C A0[2E00]                 mov al, [Op]
  1041 0000053F 3C03                     cmp al, 3
  1042 00000541 0F850300                 jne .check2Ops8
  1043 00000545 E86D16                   call invaloperror
  1044                                  
  1045                                  ;-22     if (Op == IMM) immeerror();   
  1046                                  
  1047                                  .check2Ops8:
  1048 00000548 A0[2E00]                 mov al, [Op]
  1049 0000054B 3C01                     cmp al, 1
  1050 0000054D 0F850300                 jne .check2Ops9
  1051 00000551 E80116                   call immeerror
  1052                                  
  1053                                  ;-23     if (Op2==   0) addrerror();
  1054                                  
  1055                                  .check2Ops9:
  1056 00000554 A0[2F00]                 mov al, [Op2]
  1057 00000557 3C00                     cmp al, 0
  1058 00000559 0F850300                 jne .check2Ops10
  1059 0000055D E8DB15                   call addrerror
  1060                                  
  1061                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           
  1062                                  
  1063                                  .check2Ops10:
  1064 00000560 A0[3000]                 mov al, [CodeType]
  1065 00000563 3C05                     cmp al, 5
  1066 00000565 0F840C00                 je  .check2Ops11
  1067 00000569 A0[2F00]                 mov al, [Op2]
  1068 0000056C 3C03                     cmp al, 3
  1069 0000056E 0F850300                 jne .check2Ops12
  1070 00000572 E84016                   call invaloperror
  1071                                  
  1072                                  ;-25     setwflag();       
  1073                                  
  1074                                  .check2Ops12:
  1075                                  .check2Ops11:
  1076 00000575 E8DD02                   call setwflag
  1077                                  
  1078                                  ;-26 }    
  1079                                  
  1080                                  
  1081                                  ;-27 int get2Ops() {
  1082                                  
  1083 00000578 C3                       ret
  1084                                  ENDP
  1085                                  
  1086                                  get2Ops: PROC
  1087                                  
  1088                                  ;-28     getOpL();
  1089                                  
  1090 00000579 E80C00                   call getOpL
  1091                                  
  1092                                  ;-29     need(',');    
  1093                                  
  1094 0000057C 6A2C                     push 44
  1095 0000057E E89D09                   call need
  1096 00000581 83C402                   add  sp, 2
  1097                                  
  1098                                  ;-30     getOpR();         
  1099                                  
  1100 00000584 E82900                   call getOpR
  1101                                  
  1102                                  ;-31 } 
  1103                                  
  1104                                  
  1105                                  ;-32         
  1106                                  
  1107                                  
  1108                                  ;-33 int getOpL() {
  1109                                  
  1110 00000587 C3                       ret
  1111                                  ENDP
  1112                                  
  1113                                  getOpL: PROC
  1114                                  
  1115                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1116                                  
  1117                                  
  1118                                  ;-35     getOpR();
  1119                                  
  1120 00000588 E82500                   call getOpR
  1121                                  
  1122                                  ;-36     Op=Op2;         Op2=0;
  1123                                  
  1124 0000058B A0[2F00]                 mov al, [Op2]
  1125 0000058E A2[2E00]                 mov byte [Op], al
  1126 00000591 B80000                   mov ax, 0
  1127 00000594 A2[2F00]                 mov byte [Op2], al
  1128                                  
  1129                                  ;-37     R1No=R2No;      R2No=0;
  1130                                  
  1131 00000597 A0[3400]                 mov al, [R2No]
  1132 0000059A A2[3500]                 mov byte [R1No], al
  1133 0000059D B80000                   mov ax, 0
  1134 000005A0 A2[3400]                 mov byte [R2No], al
  1135                                  
  1136                                  ;-38     R1Type=R2Type; R2Type=0; 
  1137                                  
  1138 000005A3 A0[3600]                 mov al, [R2Type]
  1139 000005A6 A2[3700]                 mov byte [R1Type], al
  1140 000005A9 B80000                   mov ax, 0
  1141 000005AC A2[3600]                 mov byte [R2Type], al
  1142                                  
  1143                                  ;-39 }  
  1144                                  
  1145                                  
  1146                                  ;-40 
  1147                                  
  1148                                  
  1149                                  ;-41 int getOpR() {
  1150                                  
  1151 000005AF C3                       ret
  1152                                  ENDP
  1153                                  
  1154                                  getOpR: PROC
  1155                                  
  1156                                  ;-42     Op2=getOp1();
  1157                                  
  1158 000005B0 E88600                   call getOp1
  1159 000005B3 A2[2F00]                 mov byte [Op2], al
  1160                                  
  1161                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1162                                  
  1163 000005B6 6A5B                     push 91
  1164 000005B8 E83B09                   call isToken
  1165 000005BB 83C402                   add  sp, 2
  1166 000005BE 08C0                     or  al, al
  1167 000005C0 0F840C00                 je .getOpR13
  1168 000005C4 B80400                   mov ax, 4
  1169 000005C7 A2[2F00]                 mov byte [Op2], al
  1170 000005CA E8E300                   call getMEM
  1171 000005CD E94F00                   jmp .retngetOpR
  1172                                  
  1173                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1174                                  
  1175                                  .getOpR13:
  1176 000005D0 A0[2F00]                 mov al, [Op2]
  1177 000005D3 3C00                     cmp al, 0
  1178 000005D5 0F850600                 jne .getOpR14
  1179 000005D9 E8D915                   call invaloperror
  1180 000005DC E94000                   jmp .retngetOpR
  1181                                  
  1182                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1183                                  
  1184                                  .getOpR14:
  1185 000005DF A0[2F00]                 mov al, [Op2]
  1186 000005E2 3C01                     cmp al, 1
  1187 000005E4 0F850900                 jne .getOpR15
  1188 000005E8 A1[0F00]                 mov ax, [SymbolInt]
  1189 000005EB A3[4000]                 mov word [imme], ax
  1190 000005EE E92E00                   jmp .retngetOpR
  1191                                  
  1192                                  ;-46     if (Op2 == REG)                            return;
  1193                                  
  1194                                  .getOpR15:
  1195 000005F1 A0[2F00]                 mov al, [Op2]
  1196 000005F4 3C02                     cmp al, 2
  1197 000005F6 0F850300                 jne .getOpR16
  1198 000005FA E92200                   jmp .retngetOpR
  1199                                  
  1200                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1201                                  
  1202                                  .getOpR16:
  1203 000005FD A0[2F00]                 mov al, [Op2]
  1204 00000600 3C03                     cmp al, 3
  1205 00000602 0F851000                 jne .getOpR17
  1206 00000606 8B1E[4B00]               mov bx, [LabelIx]
  1207 0000060A D1E3                     shl bx, 1
  1208 0000060C 8B87FA86                 mov ax, [LabelAddr + bx]
  1209 00000610 A3[3E00]                 mov word [disp], ax
  1210 00000613 E90900                   jmp .retngetOpR
  1211                                  
  1212                                  ;-48     error1("Name of operand expected");
  1213                                  
  1214                                  .getOpR17:
  1215 00000616 68[2006]                 push getOpR_0
  1216 00000619 E88E14                   call error1
  1217 0000061C 83C402                   add  sp, 2
  1218                                  
  1219                                  ;-49 }
  1220                                  
  1221                                  
  1222                                  ;-50 
  1223                                  
  1224                                  
  1225                                  ;-51 int getOp1() {//scan for a single operand
  1226                                  
  1227                                   .retngetOpR:
  1228 0000061F C3                       ret
  1229 00000620 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1230 00000629 706572616E64206578-
  1231 00000632 70656374656400     
  1232                                  ENDP
  1233                                  
  1234                                  getOp1: PROC
  1235                                  
  1236                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1237                                  
  1238                                  
  1239                                  ;-53 //set   :R2Type, R2No by testReg
  1240                                  
  1241                                  
  1242                                  ;-54 //set   :LabelIx by searchLabel
  1243                                  
  1244                                  
  1245                                  ;-55     if (TokeType == 0)      return 0;
  1246                                  
  1247 00000639 A0[2D00]                 mov al, [TokeType]
  1248 0000063C 3C00                     cmp al, 0
  1249 0000063E 0F850600                 jne .getOp118
  1250 00000642 B80000                   mov ax, 0
  1251 00000645 E95400                   jmp .retngetOp1
  1252                                  
  1253                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1254                                  
  1255                                  .getOp118:
  1256 00000648 A0[2D00]                 mov al, [TokeType]
  1257 0000064B 3C01                     cmp al, 1
  1258 0000064D 0F850600                 jne .getOp119
  1259 00000651 B80100                   mov ax, 1
  1260 00000654 E94500                   jmp .retngetOp1
  1261                                  
  1262                                  ;-57     if (TokeType == ALNUME) {
  1263                                  
  1264                                  .getOp119:
  1265 00000657 A0[2D00]                 mov al, [TokeType]
  1266 0000065A 3C03                     cmp al, 3
  1267 0000065C 0F853600                 jne .getOp120
  1268                                  
  1269                                  ;-58         R2No=testReg();
  1270                                  
  1271 00000660 E8240E                   call testReg
  1272 00000663 A2[3400]                 mov byte [R2No], al
  1273                                  
  1274                                  ;-59         if (R2Type)        return REG;
  1275                                  
  1276 00000666 A0[3600]                 mov al, [R2Type]
  1277 00000669 08C0                     or  al, al
  1278 0000066B 0F840600                 je .getOp121
  1279 0000066F B80200                   mov ax, 2
  1280 00000672 E92700                   jmp .retngetOp1
  1281                                  
  1282                                  ;-60         LabelIx=searchLabel();
  1283                                  
  1284                                  .getOp121:
  1285 00000675 E8A305                   call searchLabel
  1286 00000678 A3[4B00]                 mov word [LabelIx], ax
  1287                                  
  1288                                  ;-61         if (LabelIx)        return ADR;
  1289                                  
  1290 0000067B A1[4B00]                 mov ax, [LabelIx]
  1291 0000067E 08C0                     or  al, al
  1292 00000680 0F840900                 je .getOp122
  1293 00000684 B80300                   mov ax, 3
  1294 00000687 E91200                   jmp .retngetOp1
  1295                                  
  1296                                  ;-62         else error1("variable not found"); 
  1297                                  
  1298 0000068A E90900                   jmp .getOp123
  1299                                  .getOp122:
  1300 0000068D 68[9D06]                 push getOp1_0
  1301 00000690 E81714                   call error1
  1302 00000693 83C402                   add  sp, 2
  1303                                  
  1304                                  ;-63     }
  1305                                  
  1306                                  .getOp123:
  1307                                  
  1308                                  ;-64     return 0;
  1309                                  
  1310                                  .getOp120:
  1311 00000696 B80000                   mov ax, 0
  1312 00000699 E90000                   jmp .retngetOp1
  1313                                  
  1314                                  ;-65 }
  1315                                  
  1316                                  
  1317                                  ;-66 
  1318                                  
  1319                                  
  1320                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1321                                  
  1322                                   .retngetOp1:
  1323 0000069C C3                       ret
  1324 0000069D 7661726961626C6520-     getOp1_0 db "variable not found",0
  1325 000006A6 6E6F7420666F756E64-
  1326 000006AF 00                 
  1327                                  ENDP
  1328                                  
  1329                                  getMEM: PROC
  1330                                  
  1331                                  ;-68 //set: disp, rm, R2Type
  1332                                  
  1333                                  
  1334                                  ;-69     char c;
  1335                                  
  1336                                  
  1337                                  ;-70     disp=0; rm=0;
  1338                                  
  1339                                  ;Function : getMEM, Number of local variables: 1
  1340                                  ;   # type sign width addr used name   list of local variables
  1341                                  ;  200 var sign byte    69 NULL c = bp-2;
  1342 000006B0 C8020000                 ENTER  2,0
  1343 000006B4 B80000                   mov ax, 0
  1344 000006B7 A3[3E00]                 mov word [disp], ax
  1345 000006BA B80000                   mov ax, 0
  1346 000006BD A2[3C00]                 mov byte [rm], al
  1347                                  
  1348                                  ;-71     do {
  1349                                  
  1350                                  .getMEM24:
  1351                                  
  1352                                  ;-72         getTokeType();
  1353                                  
  1354 000006C0 E8A003                   call getTokeType
  1355                                  
  1356                                  ;-73         c=getOp1();
  1357                                  
  1358 000006C3 E873FF                   call getOp1
  1359 000006C6 8846FE                   mov [bp-2], al
  1360                                  
  1361                                  ;-74         if (c ==   0) syntaxerror();
  1362                                  
  1363 000006C9 8A46FE                   mov al, [bp-2]
  1364 000006CC 3C00                     cmp al, 0
  1365 000006CE 0F850300                 jne .getMEM25
  1366 000006D2 E89415                   call syntaxerror
  1367                                  
  1368                                  ;-75         if (c == REG) {
  1369                                  
  1370                                  .getMEM25:
  1371 000006D5 8A46FE                   mov al, [bp-2]
  1372 000006D8 3C02                     cmp al, 2
  1373 000006DA 0F851B00                 jne .getMEM26
  1374                                  
  1375                                  ;-76             isDirect=0;
  1376                                  
  1377 000006DE B80000                   mov ax, 0
  1378 000006E1 A2[3D00]                 mov byte [isDirect], al
  1379                                  
  1380                                  ;-77             if (rm) rm=getIndReg2();
  1381                                  
  1382 000006E4 A0[3C00]                 mov al, [rm]
  1383 000006E7 08C0                     or  al, al
  1384 000006E9 0F840900                 je .getMEM27
  1385 000006ED E8E700                   call getIndReg2
  1386 000006F0 A2[3C00]                 mov byte [rm], al
  1387                                  
  1388                                  ;-78             else getIndReg1();
  1389                                  
  1390 000006F3 E90300                   jmp .getMEM28
  1391                                  .getMEM27:
  1392 000006F6 E88900                   call getIndReg1
  1393                                  
  1394                                  ;-79         }
  1395                                  
  1396                                  .getMEM28:
  1397                                  
  1398                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1399                                  
  1400                                  .getMEM26:
  1401 000006F9 8A46FE                   mov al, [bp-2]
  1402 000006FC 3C03                     cmp al, 3
  1403 000006FE 0F851000                 jne .getMEM29
  1404 00000702 A1[3E00]                 mov ax, [disp]
  1405 00000705 8B1E[4B00]               mov bx, [LabelIx]
  1406 00000709 D1E3                     shl bx, 1
  1407 0000070B 0387FA86                 add ax, [LabelAddr + bx]
  1408 0000070F A3[3E00]                 mov word [disp], ax
  1409                                  
  1410                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1411                                  
  1412                                  .getMEM29:
  1413 00000712 8A46FE                   mov al, [bp-2]
  1414 00000715 3C01                     cmp al, 1
  1415 00000717 0F850A00                 jne .getMEM30
  1416 0000071B A1[3E00]                 mov ax, [disp]
  1417 0000071E 0306[0F00]               add ax, [SymbolInt]
  1418 00000722 A3[3E00]                 mov word [disp], ax
  1419                                  
  1420                                  ;-82         if (isToken('-')) {
  1421                                  
  1422                                  .getMEM30:
  1423 00000725 6A2D                     push 45
  1424 00000727 E8CC07                   call isToken
  1425 0000072A 83C402                   add  sp, 2
  1426 0000072D 08C0                     or  al, al
  1427 0000072F 0F841900                 je .getMEM31
  1428                                  
  1429                                  ;-83             getTokeType();
  1430                                  
  1431 00000733 E82D03                   call getTokeType
  1432                                  
  1433                                  ;-84             if (TokeType != DIGIT) numbererror();
  1434                                  
  1435 00000736 A0[2D00]                 mov al, [TokeType]
  1436 00000739 3C01                     cmp al, 1
  1437 0000073B 0F840300                 je  .getMEM32
  1438 0000073F E89414                   call numbererror
  1439                                  
  1440                                  ;-85             disp = disp - SymbolInt;
  1441                                  
  1442                                  .getMEM32:
  1443 00000742 A1[3E00]                 mov ax, [disp]
  1444 00000745 2B06[0F00]               sub ax, [SymbolInt]
  1445 00000749 A3[3E00]                 mov word [disp], ax
  1446                                  
  1447                                  ;-86         }
  1448                                  
  1449                                  
  1450                                  ;-87     } while (isToken('+'));
  1451                                  
  1452                                  .getMEM31:
  1453 0000074C 6A2B                     push 43
  1454 0000074E E8A507                   call isToken
  1455 00000751 83C402                   add  sp, 2
  1456 00000754 08C0                     or  al, al
  1457 00000756 0F840300                 je .getMEM33
  1458 0000075A E963FF                   jmp .getMEM24
  1459                                  .getMEM33:
  1460                                  
  1461                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1462                                  
  1463 0000075D 6A5D                     push 93
  1464 0000075F E89407                   call isToken
  1465 00000762 83C402                   add  sp, 2
  1466 00000765 83F800                   cmp ax, 0
  1467 00000768 0F850900                 jne .getMEM34
  1468 0000076C 68[7707]                 push getMEM_0
  1469 0000076F E89413                   call errorexit
  1470 00000772 83C402                   add  sp, 2
  1471                                  
  1472                                  ;-89 }
  1473                                  
  1474                                  .getMEM34:
  1475                                  
  1476                                  ;-90 int getIndReg1() {
  1477 00000775 C9                       LEAVE
  1478 00000776 C3                       ret
  1479 00000777 5D2065787065637465-     getMEM_0 db "] expected",0
  1480 00000780 6400               
  1481                                  ENDP
  1482                                  
  1483                                  getIndReg1: PROC
  1484                                  
  1485                                  ;-91     if (R2Type !=WORD) indexerror();
  1486                                  
  1487 00000782 A0[3600]                 mov al, [R2Type]
  1488 00000785 3C02                     cmp al, 2
  1489 00000787 0F840300                 je  .getIndReg135
  1490 0000078B E80614                   call indexerror
  1491                                  
  1492                                  ;-92     if (R2No==3) rm=7;//BX
  1493                                  
  1494                                  .getIndReg135:
  1495 0000078E A0[3400]                 mov al, [R2No]
  1496 00000791 3C03                     cmp al, 3
  1497 00000793 0F850600                 jne .getIndReg136
  1498 00000797 B80700                   mov ax, 7
  1499 0000079A A2[3C00]                 mov byte [rm], al
  1500                                  
  1501                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1502                                  
  1503                                  .getIndReg136:
  1504 0000079D A0[3400]                 mov al, [R2No]
  1505 000007A0 3C05                     cmp al, 5
  1506 000007A2 0F850600                 jne .getIndReg137
  1507 000007A6 B80600                   mov ax, 6
  1508 000007A9 A2[3C00]                 mov byte [rm], al
  1509                                  
  1510                                  ;-94     if (R2No==7) rm=5;//DI
  1511                                  
  1512                                  .getIndReg137:
  1513 000007AC A0[3400]                 mov al, [R2No]
  1514 000007AF 3C07                     cmp al, 7
  1515 000007B1 0F850600                 jne .getIndReg138
  1516 000007B5 B80500                   mov ax, 5
  1517 000007B8 A2[3C00]                 mov byte [rm], al
  1518                                  
  1519                                  ;-95     if (R2No==6) rm=4;//SI
  1520                                  
  1521                                  .getIndReg138:
  1522 000007BB A0[3400]                 mov al, [R2No]
  1523 000007BE 3C06                     cmp al, 6
  1524 000007C0 0F850600                 jne .getIndReg139
  1525 000007C4 B80400                   mov ax, 4
  1526 000007C7 A2[3C00]                 mov byte [rm], al
  1527                                  
  1528                                  ;-96     if (rm==0) indexerror();
  1529                                  
  1530                                  .getIndReg139:
  1531 000007CA A0[3C00]                 mov al, [rm]
  1532 000007CD 3C00                     cmp al, 0
  1533 000007CF 0F850300                 jne .getIndReg140
  1534 000007D3 E8BE13                   call indexerror
  1535                                  
  1536                                  ;-97 }
  1537                                  
  1538                                  .getIndReg140:
  1539                                  
  1540                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1541                                  
  1542 000007D6 C3                       ret
  1543                                  ENDP
  1544                                  
  1545                                  getIndReg2: PROC
  1546                                  ;Function : getIndReg2, Number of local variables: 1
  1547                                  ;   # type sign width addr used name   list of local variables
  1548                                  ;  200 var sign byte    98 NULL m = bp-2;
  1549 000007D7 C8020000                 ENTER  2,0
  1550 000007DB B80400                   mov ax, 4
  1551 000007DE 8846FE                   mov [bp-2], al
  1552                                  
  1553                                  ;-99     if (R2Type !=WORD) indexerror();
  1554                                  
  1555 000007E1 A0[3600]                 mov al, [R2Type]
  1556 000007E4 3C02                     cmp al, 2
  1557 000007E6 0F840300                 je  .getIndReg241
  1558 000007EA E8A713                   call indexerror
  1559                                  
  1560                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1561                                  
  1562                                  .getIndReg241:
  1563 000007ED A0[3400]                 mov al, [R2No]
  1564 000007F0 3C07                     cmp al, 7
  1565 000007F2 0F852100                 jne .getIndReg242
  1566 000007F6 A0[3C00]                 mov al, [rm]
  1567 000007F9 3C06                     cmp al, 6
  1568 000007FB 0F850900                 jne .getIndReg243
  1569 000007FF B80300                   mov ax, 3
  1570 00000802 8846FE                   mov [bp-2], al
  1571                                  
  1572                                  ;-101              else if (rm==7) m=1;//BX+DI
  1573                                  
  1574 00000805 E90F00                   jmp .getIndReg244
  1575                                  .getIndReg243:
  1576 00000808 A0[3C00]                 mov al, [rm]
  1577 0000080B 3C07                     cmp al, 7
  1578 0000080D 0F850600                 jne .getIndReg245
  1579 00000811 B80100                   mov ax, 1
  1580 00000814 8846FE                   mov [bp-2], al
  1581                                  
  1582                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1583                                  
  1584                                  .getIndReg245:
  1585                                  .getIndReg244:
  1586                                  .getIndReg242:
  1587 00000817 A0[3400]                 mov al, [R2No]
  1588 0000081A 3C06                     cmp al, 6
  1589 0000081C 0F852100                 jne .getIndReg246
  1590 00000820 A0[3C00]                 mov al, [rm]
  1591 00000823 3C06                     cmp al, 6
  1592 00000825 0F850900                 jne .getIndReg247
  1593 00000829 B80200                   mov ax, 2
  1594 0000082C 8846FE                   mov [bp-2], al
  1595                                  
  1596                                  ;-103              else if (rm==7) m=0;//BX+SI
  1597                                  
  1598 0000082F E90F00                   jmp .getIndReg248
  1599                                  .getIndReg247:
  1600 00000832 A0[3C00]                 mov al, [rm]
  1601 00000835 3C07                     cmp al, 7
  1602 00000837 0F850600                 jne .getIndReg249
  1603 0000083B B80000                   mov ax, 0
  1604 0000083E 8846FE                   mov [bp-2], al
  1605                                  
  1606                                  ;-104     if (m > 3) indexerror();
  1607                                  
  1608                                  .getIndReg249:
  1609                                  .getIndReg248:
  1610                                  .getIndReg246:
  1611 00000841 8A46FE                   mov al, [bp-2]
  1612 00000844 3C03                     cmp al, 3
  1613 00000846 0F8E0300                 jle .getIndReg250
  1614 0000084A E84713                   call indexerror
  1615                                  
  1616                                  ;-105     return m;
  1617                                  
  1618                                  .getIndReg250:
  1619 0000084D 8A46FE                   mov al, [bp-2]
  1620 00000850 E90000                   jmp .retngetIndReg2
  1621                                  
  1622                                  ;-106 }
  1623                                  
  1624                                  
  1625                                  ;-107                   
  1626                                  
  1627                                  
  1628                                  ;-108 int setwflag() {//word size, bit 0
  1629                                  
  1630 00000853 C9                       .retngetIndReg2: LEAVE
  1631 00000854 C3                       ret
  1632                                  ENDP
  1633                                  
  1634                                  setwflag: PROC
  1635                                  
  1636                                  ;-109     wflag=0;
  1637                                  
  1638 00000855 B80000                   mov ax, 0
  1639 00000858 A2[3900]                 mov byte [wflag], al
  1640                                  
  1641                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1642                                  
  1643 0000085B A0[3800]                 mov al, [OpSize]
  1644 0000085E 3C00                     cmp al, 0
  1645 00000860 0F853C00                 jne .setwflag51
  1646                                  
  1647                                  ;-111         if (Op == REG) OpSize=R1Type;
  1648                                  
  1649 00000864 A0[2E00]                 mov al, [Op]
  1650 00000867 3C02                     cmp al, 2
  1651 00000869 0F850600                 jne .setwflag52
  1652 0000086D A0[3700]                 mov al, [R1Type]
  1653 00000870 A2[3800]                 mov byte [OpSize], al
  1654                                  
  1655                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1656                                  
  1657                                  .setwflag52:
  1658 00000873 A0[2F00]                 mov al, [Op2]
  1659 00000876 3C02                     cmp al, 2
  1660 00000878 0F850600                 jne .setwflag53
  1661 0000087C A0[3600]                 mov al, [R2Type]
  1662 0000087F A2[3800]                 mov byte [OpSize], al
  1663                                  
  1664                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1665                                  
  1666                                  .setwflag53:
  1667 00000882 A0[3600]                 mov al, [R2Type]
  1668 00000885 3C04                     cmp al, 4
  1669 00000887 0F850600                 jne .setwflag54
  1670 0000088B B80200                   mov ax, 2
  1671 0000088E A2[3800]                 mov byte [OpSize], al
  1672                                  
  1673                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1674                                  
  1675                                  .setwflag54:
  1676 00000891 A0[3700]                 mov al, [R1Type]
  1677 00000894 3C04                     cmp al, 4
  1678 00000896 0F850600                 jne .setwflag55
  1679 0000089A B80200                   mov ax, 2
  1680 0000089D A2[3800]                 mov byte [OpSize], al
  1681                                  
  1682                                  ;-115     }
  1683                                  
  1684                                  .setwflag55:
  1685                                  
  1686                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1687                                  
  1688                                  .setwflag51:
  1689 000008A0 A0[3800]                 mov al, [OpSize]
  1690 000008A3 3C03                     cmp al, 3
  1691 000008A5 0F850900                 jne .setwflag56
  1692 000008A9 E8C818                   call gen66h
  1693 000008AC B80100                   mov ax, 1
  1694 000008AF A2[3900]                 mov byte [wflag], al
  1695                                  
  1696                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1697                                  
  1698                                  .setwflag56:
  1699 000008B2 A0[3800]                 mov al, [OpSize]
  1700 000008B5 3C02                     cmp al, 2
  1701 000008B7 0F850600                 jne .setwflag57
  1702 000008BB B80100                   mov ax, 1
  1703 000008BE A2[3900]                 mov byte [wflag], al
  1704                                  
  1705                                  ;-118 }
  1706                                  
  1707                                  .setwflag57:
  1708                                  
  1709                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1710                                  
  1711 000008C1 C3                       ret
  1712                                  ENDP
  1713                                  
  1714                                  setsflag: PROC
  1715                                  
  1716                                  ;-120     unsigned int ui;    
  1717                                  
  1718                                  
  1719                                  ;-121     sflag=2;   
  1720                                  
  1721                                  ;Function : setsflag, Number of local variables: 1
  1722                                  ;   # type sign width addr used name   list of local variables
  1723                                  ;  200 var unsg word   120 NULL ui = bp-2;
  1724 000008C2 C8020000                 ENTER  2,0
  1725 000008C6 B80200                   mov ax, 2
  1726 000008C9 A2[3B00]                 mov byte [sflag], al
  1727                                  
  1728                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1729                                  
  1730 000008CC A1[4000]                 mov ax, [imme]
  1731 000008CF 2580FF                   and ax, 65408
  1732 000008D2 8946FE                   mov [bp-2], ax
  1733                                  
  1734                                  ;-123     if(ui != 0) sflag = 0;
  1735                                  
  1736 000008D5 8B46FE                   mov ax, [bp-2]
  1737 000008D8 83F800                   cmp ax, 0
  1738 000008DB 0F840600                 je  .setsflag58
  1739 000008DF B80000                   mov ax, 0
  1740 000008E2 A2[3B00]                 mov byte [sflag], al
  1741                                  
  1742                                  ;-124     if (OpSize == BYTE) {
  1743                                  
  1744                                  .setsflag58:
  1745 000008E5 A0[3800]                 mov al, [OpSize]
  1746 000008E8 3C01                     cmp al, 1
  1747 000008EA 0F851900                 jne .setsflag59
  1748                                  
  1749                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1750                                  
  1751 000008EE A1[4000]                 mov ax, [imme]
  1752 000008F1 3DFF00                   cmp ax, 255
  1753 000008F4 0F8E0900                 jle .setsflag60
  1754 000008F8 68[0909]                 push setsflag_0
  1755 000008FB E8AC11                   call error1
  1756 000008FE 83C402                   add  sp, 2
  1757                                  
  1758                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1759                                  
  1760                                  .setsflag60:
  1761 00000901 B80000                   mov ax, 0
  1762 00000904 A2[3B00]                 mov byte [sflag], al
  1763                                  
  1764                                  ;-127     }
  1765                                  
  1766                                  
  1767                                  ;-128 }
  1768                                  
  1769                                  .setsflag59:
  1770                                  
  1771                                  ;-129 int checkConstSize(unsigned int ui) {    
  1772 00000907 C9                       LEAVE
  1773 00000908 C3                       ret
  1774 00000909 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1775 00000912 6F7220627974652072-
  1776 0000091B 2F6D00             
  1777                                  ENDP
  1778                                  
  1779                                  checkConstSize: PROC
  1780                                  
  1781                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1782                                  
  1783                                  ;Function : checkConstSize, Number of local variables: 1
  1784                                  ;   # type sign width addr used name   list of local variables
  1785                                  ;  200 var unsg word   129 NULL ui = bp+4;
  1786 0000091E C8000000                 ENTER  0,0
  1787 00000922 8B4604                   mov ax, [bp+4]
  1788 00000925 83F87F                   cmp ax, 127
  1789 00000928 0F8E0600                 jle .checkConstSize61
  1790 0000092C B80000                   mov ax, 0
  1791 0000092F E91600                   jmp .retncheckConstSize
  1792                                  
  1793                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1794                                  
  1795                                  .checkConstSize61:
  1796 00000932 8B4604                   mov ax, [bp+4]
  1797 00000935 3D80FF                   cmp ax, 65408
  1798 00000938 0F8D0600                 jge .checkConstSize62
  1799 0000093C B80000                   mov ax, 0
  1800 0000093F E90600                   jmp .retncheckConstSize
  1801                                  
  1802                                  ;-132     return 2;// is short        
  1803                                  
  1804                                  .checkConstSize62:
  1805 00000942 B80200                   mov ax, 2
  1806 00000945 E90000                   jmp .retncheckConstSize
  1807                                  
  1808                                  ;-133 }
  1809                                  
  1810 00000948 C9                       .retncheckConstSize: LEAVE
  1811 00000949 C3                       ret
  1812                                  ENDP
  1813                                  ;Back to main program: AS.C
  1814                                  
  1815                                  ;-5 #include "PARSE.C"
  1816                                  
  1817                                  ;Use include file: PARSE.C
  1818                                  
  1819                                  ;-1 int parse() {
  1820                                  
  1821                                  
  1822                                  parse: PROC
  1823                                  
  1824                                  ;-2     LabelNamePtr  = &LabelNames;
  1825                                  
  1826 0000094A B85A77                   mov ax, LabelNames
  1827 0000094D A3[4700]                 mov word [LabelNamePtr], ax
  1828                                  
  1829                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1830                                  
  1831 00000950 B8AA8B                   mov ax, JmpCallNames
  1832 00000953 A3[4D00]                 mov word [JmpCallNamePtr], ax
  1833                                  
  1834                                  ;-4     LabelMaxIx=0;
  1835                                  
  1836 00000956 B80000                   mov ax, 0
  1837 00000959 A3[4900]                 mov word [LabelMaxIx], ax
  1838                                  
  1839                                  ;-5     JmpCallMaxIx=0;
  1840                                  
  1841 0000095C B80000                   mov ax, 0
  1842 0000095F A3[4F00]                 mov word [JmpCallMaxIx], ax
  1843                                  
  1844                                  ;-6     BinLen=0;
  1845                                  
  1846 00000962 B80000                   mov ax, 0
  1847 00000965 A3[5100]                 mov word [BinLen], ax
  1848                                  
  1849                                  ;-7     isInProc=0;
  1850                                  
  1851 00000968 B80000                   mov ax, 0
  1852 0000096B A2[0E00]                 mov byte [isInProc], al
  1853                                  
  1854                                  ;-8 
  1855                                  
  1856                                  
  1857                                  ;-9     do {//process a new line
  1858                                  
  1859                                  .parse63:
  1860                                  
  1861                                  ;-10         PCStart=PC;
  1862                                  
  1863 0000096E A1[2400]                 mov ax, [PC]
  1864 00000971 A3[2A00]                 mov word [PCStart], ax
  1865                                  
  1866                                  ;-11         OpSize=0;
  1867                                  
  1868 00000974 B80000                   mov ax, 0
  1869 00000977 A2[3800]                 mov byte [OpSize], al
  1870                                  
  1871                                  ;-12         OpPrintIndex=0;
  1872                                  
  1873 0000097A B80000                   mov ax, 0
  1874 0000097D A3[4200]                 mov word [OpPrintIndex], ax
  1875                                  
  1876                                  ;-13         PrintRA=' ';
  1877                                  
  1878 00000980 B82000                   mov ax, 32
  1879 00000983 A2[4600]                 mov byte [PrintRA], al
  1880                                  
  1881                                  ;-14         getLine();
  1882                                  
  1883 00000986 E8BD06                   call getLine
  1884                                  
  1885                                  ;-15         InputPtr = &InputBuf;
  1886                                  
  1887 00000989 B88D75                   mov ax, InputBuf
  1888 0000098C A3[1500]                 mov word [InputPtr], ax
  1889                                  
  1890                                  ;-16         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1891                                  
  1892 0000098F E8D100                   call getTokeType
  1893                                  
  1894                                  ;-17         if (TokeType == ALNUME) {
  1895                                  
  1896 00000992 A0[2D00]                 mov al, [TokeType]
  1897 00000995 3C03                     cmp al, 3
  1898 00000997 0F852C00                 jne .parse64
  1899                                  
  1900                                  ;-18             if (isLabel) {//set in getName
  1901                                  
  1902 0000099B A0[2C00]                 mov al, [isLabel]
  1903 0000099E 08C0                     or  al, al
  1904 000009A0 0F842300                 je .parse65
  1905                                  
  1906                                  ;-19               if (isInProc == 0)  strcpy(ProcName, Symbol);
  1907                                  
  1908 000009A4 A0[0E00]                 mov al, [isInProc]
  1909 000009A7 3C00                     cmp al, 0
  1910 000009A9 0F851000                 jne .parse66
  1911 000009AD 8D063075                 lea  ax, [Symbol]
  1912 000009B1 50                       push ax
  1913 000009B2 8D066E75                 lea  ax, [ProcName]
  1914 000009B6 50                       push ax
  1915 000009B7 E8E408                   call strcpy
  1916 000009BA 83C404                   add  sp, 4
  1917                                  
  1918                                  ;-20                 storeLabel();
  1919                                  
  1920                                  .parse66:
  1921 000009BD E8B401                   call storeLabel
  1922                                  
  1923                                  ;-21                 InputPtr++;//remove :
  1924                                  
  1925 000009C0 FF06[1500]               inc  word[InputPtr]
  1926                                  
  1927                                  ;-22                 getTokeType();
  1928                                  
  1929 000009C4 E89C00                   call getTokeType
  1930                                  
  1931                                  ;-23             }
  1932                                  
  1933                                  
  1934                                  ;-24         }
  1935                                  
  1936                                  .parse65:
  1937                                  
  1938                                  ;-25         if (TokeType == ALNUME) {
  1939                                  
  1940                                  .parse64:
  1941 000009C7 A0[2D00]                 mov al, [TokeType]
  1942 000009CA 3C03                     cmp al, 3
  1943 000009CC 0F851B00                 jne .parse67
  1944                                  
  1945                                  ;-26             lookCode();// and OpCodePtr
  1946                                  
  1947 000009D0 E83504                   call lookCode
  1948                                  
  1949                                  ;-27             if(CodeType) process();
  1950                                  
  1951 000009D3 A0[3000]                 mov al, [CodeType]
  1952 000009D6 08C0                     or  al, al
  1953 000009D8 0F840600                 je .parse68
  1954 000009DC E8B419                   call process
  1955                                  
  1956                                  ;-28             else getVariable();
  1957                                  
  1958 000009DF E90300                   jmp .parse69
  1959                                  .parse68:
  1960 000009E2 E88A02                   call getVariable
  1961                                  
  1962                                  ;-29             skipRest();
  1963                                  
  1964                                  .parse69:
  1965 000009E5 E87505                   call skipRest
  1966                                  
  1967                                  ;-30         }
  1968                                  
  1969                                  
  1970                                  ;-31         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1971                                  
  1972 000009E8 E92700                   jmp .parse70
  1973                                  .parse67:
  1974 000009EB A0[2D00]                 mov al, [TokeType]
  1975 000009EE 3C03                     cmp al, 3
  1976 000009F0 0F8E0C00                 jle .parse71
  1977 000009F4 68[230A]                 push parse_0
  1978 000009F7 E8B010                   call error1
  1979 000009FA 83C402                   add  sp, 2
  1980                                  
  1981                                  ;-32         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1982                                  
  1983 000009FD E91200                   jmp .parse72
  1984                                  .parse71:
  1985 00000A00 A0[2D00]                 mov al, [TokeType]
  1986 00000A03 3C01                     cmp al, 1
  1987 00000A05 0F850900                 jne .parse73
  1988 00000A09 68[410A]                 push parse_1
  1989 00000A0C E89B10                   call error1
  1990 00000A0F 83C402                   add  sp, 2
  1991                                  
  1992                                  ;-33         printLine();
  1993                                  
  1994                                  .parse73:
  1995                                  .parse72:
  1996                                  .parse70:
  1997 00000A12 E8390E                   call printLine
  1998                                  
  1999                                  ;-34     } while (DOS_NoBytes != 0 );
  2000                                  
  2001 00000A15 A1[2100]                 mov ax, [DOS_NoBytes]
  2002 00000A18 83F800                   cmp ax, 0
  2003 00000A1B 0F840300                 je  .parse74
  2004 00000A1F E94CFF                   jmp .parse63
  2005                                  .parse74:
  2006                                  
  2007                                  ;-35 }
  2008                                  
  2009                                  
  2010                                  ;-36 
  2011                                  
  2012                                  
  2013                                  ;-37 int getTokeType() {
  2014                                  
  2015 00000A22 C3                       ret
  2016 00000A23 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2017 00000A2C 696E73747275637469-
  2018 00000A35 6F6E20657870656374-
  2019 00000A3E 656400             
  2020 00000A41 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2021 00000A4A 616C6C6F7765642061-
  2022 00000A53 74207374617274206F-
  2023 00000A5C 66206C696E6500     
  2024                                  ENDP
  2025                                  
  2026                                  getTokeType: PROC
  2027                                  
  2028                                  ;-38     char c;
  2029                                  
  2030                                  
  2031                                  ;-39     skipBlank();
  2032                                  
  2033                                  ;Function : getTokeType, Number of local variables: 1
  2034                                  ;   # type sign width addr used name   list of local variables
  2035                                  ;  200 var sign byte    38 NULL c = bp-2;
  2036 00000A63 C8020000                 ENTER  2,0
  2037 00000A67 E8FD06                   call skipBlank
  2038                                  
  2039                                  ;-40     c = *InputPtr;
  2040                                  
  2041 00000A6A 8B1E[1500]               mov bx, [InputPtr]
  2042 00000A6E 8A07                     mov al, [bx]
  2043 00000A70 B400                     mov ah, 0
  2044 00000A72 8846FE                   mov [bp-2], al
  2045                                  
  2046                                  ;-41     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2047                                  
  2048 00000A75 8A46FE                   mov al, [bp-2]
  2049 00000A78 3C00                     cmp al, 0
  2050 00000A7A 0F850900                 jne .getTokeType75
  2051 00000A7E B80000                   mov ax, 0
  2052 00000A81 A2[2D00]                 mov byte [TokeType], al
  2053 00000A84 E96600                   jmp .retngetTokeType
  2054                                  
  2055                                  ;-42     if (c == ';') {TokeType=0; return; }//comment
  2056                                  
  2057                                  .getTokeType75:
  2058 00000A87 8A46FE                   mov al, [bp-2]
  2059 00000A8A 3C3B                     cmp al, 59
  2060 00000A8C 0F850900                 jne .getTokeType76
  2061 00000A90 B80000                   mov ax, 0
  2062 00000A93 A2[2D00]                 mov byte [TokeType], al
  2063 00000A96 E95400                   jmp .retngetTokeType
  2064                                  
  2065                                  ;-43     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2066                                  
  2067                                  .getTokeType76:
  2068 00000A99 8A46FE                   mov al, byte [bp-2]
  2069 00000A9C B400                     mov ah, 0
  2070 00000A9E 50                       push ax
  2071 00000A9F E8AA07                   call digit
  2072 00000AA2 83C402                   add  sp, 2
  2073 00000AA5 08C0                     or  al, al
  2074 00000AA7 0F841500                 je .getTokeType77
  2075 00000AAB 8A46FE                   mov al, byte [bp-2]
  2076 00000AAE B400                     mov ah, 0
  2077 00000AB0 50                       push ax
  2078 00000AB1 E8D408                   call getDigit
  2079 00000AB4 83C402                   add  sp, 2
  2080 00000AB7 B80100                   mov ax, 1
  2081 00000ABA A2[2D00]                 mov byte [TokeType], al
  2082 00000ABD E92D00                   jmp .retngetTokeType
  2083                                  
  2084                                  ;-44     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2085                                  
  2086                                  .getTokeType77:
  2087 00000AC0 8A46FE                   mov al, byte [bp-2]
  2088 00000AC3 B400                     mov ah, 0
  2089 00000AC5 50                       push ax
  2090 00000AC6 E8C906                   call letterE
  2091 00000AC9 83C402                   add  sp, 2
  2092 00000ACC 08C0                     or  al, al
  2093 00000ACE 0F841500                 je .getTokeType78
  2094 00000AD2 8A46FE                   mov al, byte [bp-2]
  2095 00000AD5 B400                     mov ah, 0
  2096 00000AD7 50                       push ax
  2097 00000AD8 E8FD08                   call getName
  2098 00000ADB 83C402                   add  sp, 2
  2099 00000ADE B80300                   mov ax, 3
  2100 00000AE1 A2[2D00]                 mov byte [TokeType], al
  2101 00000AE4 E90600                   jmp .retngetTokeType
  2102                                  
  2103                                  ;-45     TokeType=NOALNUME;
  2104                                  
  2105                                  .getTokeType78:
  2106 00000AE7 B80400                   mov ax, 4
  2107 00000AEA A2[2D00]                 mov byte [TokeType], al
  2108                                  
  2109                                  ;-46 }
  2110                                  
  2111                                  
  2112                                  ;-47 
  2113                                  
  2114                                  
  2115                                  ;-48 int storeJmpCall() {
  2116                                  
  2117 00000AED C9                       .retngetTokeType: LEAVE
  2118 00000AEE C3                       ret
  2119                                  ENDP
  2120                                  
  2121                                  storeJmpCall: PROC
  2122                                  
  2123                                  ;-49     unsigned int i;
  2124                                  
  2125                                  
  2126                                  ;-50     JmpCallMaxIx++;
  2127                                  
  2128                                  ;Function : storeJmpCall, Number of local variables: 1
  2129                                  ;   # type sign width addr used name   list of local variables
  2130                                  ;  200 var unsg word    49 NULL i = bp-2;
  2131 00000AEF C8020000                 ENTER  2,0
  2132 00000AF3 FF06[4F00]               inc  word[JmpCallMaxIx]
  2133                                  
  2134                                  ;-51     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2135                                  
  2136 00000AF7 A1[4F00]                 mov ax, [JmpCallMaxIx]
  2137 00000AFA 3DF401                   cmp ax, 500 ;unsigned : 1
  2138 00000AFD 0F8C0900                 jl  .storeJmpCall79
  2139 00000B01 68[4B0B]                 push storeJmpCall_0
  2140 00000B04 E8FF0F                   call errorexit
  2141 00000B07 83C402                   add  sp, 2
  2142                                  
  2143                                  ;-52     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2144                                  
  2145                                  .storeJmpCall79:
  2146 00000B0A 8D063075                 lea  ax, [Symbol]
  2147 00000B0E 50                       push ax
  2148 00000B0F FF36[4D00]               push word [JmpCallNamePtr]
  2149 00000B13 E88807                   call strcpy
  2150 00000B16 83C404                   add  sp, 4
  2151 00000B19 A3[4D00]                 mov word [JmpCallNamePtr], ax
  2152                                  
  2153                                  ;-53     JmpCallNamePtr++;
  2154                                  
  2155 00000B1C FF06[4D00]               inc  word[JmpCallNamePtr]
  2156                                  
  2157                                  ;-54     i = JmpCallNamePtr - &JmpCallNames;
  2158                                  
  2159 00000B20 A1[4D00]                 mov ax, [JmpCallNamePtr]
  2160 00000B23 2DAA8B                   sub ax, JmpCallNames
  2161 00000B26 8946FE                   mov [bp-2], ax
  2162                                  
  2163                                  ;-55     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2164                                  
  2165 00000B29 8B46FE                   mov ax, [bp-2]
  2166 00000B2C 3DB107                   cmp ax, 1969 ;unsigned : 0
  2167 00000B2F 0F820900                 jb  .storeJmpCall80
  2168 00000B33 68[5D0B]                 push storeJmpCall_1
  2169 00000B36 E8CD0F                   call errorexit
  2170 00000B39 83C402                   add  sp, 2
  2171                                  
  2172                                  ;-56     JmpCallAddr[JmpCallMaxIx] = PC;
  2173                                  
  2174                                  .storeJmpCall80:
  2175 00000B3C A1[2400]                 mov ax, [PC]
  2176 00000B3F 8B1E[4F00]               mov bx, [JmpCallMaxIx]
  2177 00000B43 D1E3                     shl bx, 1
  2178 00000B45 89877A93                 mov [JmpCallAddr+bx], ax
  2179                                  
  2180                                  ;-57 }
  2181                                  
  2182                                  
  2183                                  ;-58 
  2184                                  
  2185                                  
  2186                                  ;-59 int storeLabel() {
  2187 00000B49 C9                       LEAVE
  2188 00000B4A C3                       ret
  2189 00000B4B 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2190 00000B54 4A6D7043616C6C7300 
  2191 00000B5D 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2192 00000B66 4A6D7043616C6C206E-
  2193 00000B6F 616D657300         
  2194                                  ENDP
  2195                                  
  2196                                  storeLabel: PROC
  2197                                  
  2198                                  ;-60     unsigned int i;
  2199                                  
  2200                                  
  2201                                  ;-61     LabelMaxIx++;
  2202                                  
  2203                                  ;Function : storeLabel, Number of local variables: 1
  2204                                  ;   # type sign width addr used name   list of local variables
  2205                                  ;  200 var unsg word    60 NULL i = bp-2;
  2206 00000B74 C8020000                 ENTER  2,0
  2207 00000B78 FF06[4900]               inc  word[LabelMaxIx]
  2208                                  
  2209                                  ;-62     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2210                                  
  2211 00000B7C A1[4900]                 mov ax, [LabelMaxIx]
  2212 00000B7F 3D5802                   cmp ax, 600 ;unsigned : 1
  2213 00000B82 0F8C0900                 jl  .storeLabel81
  2214 00000B86 68[E60B]                 push storeLabel_0
  2215 00000B89 E87A0F                   call errorexit
  2216 00000B8C 83C402                   add  sp, 2
  2217                                  
  2218                                  ;-63     if(searchLabel()) error1("duplicate label");
  2219                                  
  2220                                  .storeLabel81:
  2221 00000B8F E88900                   call searchLabel
  2222 00000B92 08C0                     or  al, al
  2223 00000B94 0F840900                 je .storeLabel82
  2224 00000B98 68[F60B]                 push storeLabel_1
  2225 00000B9B E80C0F                   call error1
  2226 00000B9E 83C402                   add  sp, 2
  2227                                  
  2228                                  ;-64     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2229                                  
  2230                                  .storeLabel82:
  2231 00000BA1 8D063075                 lea  ax, [Symbol]
  2232 00000BA5 50                       push ax
  2233 00000BA6 FF36[4700]               push word [LabelNamePtr]
  2234 00000BAA E8F106                   call strcpy
  2235 00000BAD 83C404                   add  sp, 4
  2236 00000BB0 A3[4700]                 mov word [LabelNamePtr], ax
  2237                                  
  2238                                  ;-65     LabelNamePtr++;
  2239                                  
  2240 00000BB3 FF06[4700]               inc  word[LabelNamePtr]
  2241                                  
  2242                                  ;-66     i = LabelNamePtr - &LabelNames;
  2243                                  
  2244 00000BB7 A1[4700]                 mov ax, [LabelNamePtr]
  2245 00000BBA 2D5A77                   sub ax, LabelNames
  2246 00000BBD 8946FE                   mov [bp-2], ax
  2247                                  
  2248                                  ;-67     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2249                                  
  2250 00000BC0 8B46FE                   mov ax, [bp-2]
  2251 00000BC3 3D810F                   cmp ax, 3969 ;unsigned : 0
  2252 00000BC6 0F820900                 jb  .storeLabel83
  2253 00000BCA 68[060C]                 push storeLabel_2
  2254 00000BCD E8360F                   call errorexit
  2255 00000BD0 83C402                   add  sp, 2
  2256                                  
  2257                                  ;-68     LabelAddr[LabelMaxIx] = PC + Origin;
  2258                                  
  2259                                  .storeLabel83:
  2260 00000BD3 A1[2400]                 mov ax, [PC]
  2261 00000BD6 0306[2600]               add ax, [Origin]
  2262 00000BDA 8B1E[4900]               mov bx, [LabelMaxIx]
  2263 00000BDE D1E3                     shl bx, 1
  2264 00000BE0 8987FA86                 mov [LabelAddr+bx], ax
  2265                                  
  2266                                  ;-69 }
  2267                                  
  2268                                  
  2269                                  ;-70 
  2270                                  
  2271                                  
  2272                                  ;-71 int searchLabel() {
  2273 00000BE4 C9                       LEAVE
  2274 00000BE5 C3                       ret
  2275 00000BE6 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2276 00000BEF 6C6162656C7300     
  2277 00000BF6 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2278 00000BFF 206C6162656C00     
  2279 00000C06 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2280 00000C0F 6C6162656C206E616D-
  2281 00000C18 657300             
  2282                                  ENDP
  2283                                  
  2284                                  searchLabel: PROC
  2285                                  
  2286                                  ;-72     int LIx; char *p;
  2287                                  
  2288                                  
  2289                                  ;-73     p = &LabelNames;
  2290                                  
  2291                                  ;Function : searchLabel, Number of local variables: 2
  2292                                  ;   # type sign width addr used name   list of local variables
  2293                                  ;  200 var sign word    72 NULL LIx = bp-2
  2294                                  ;  201 ptr sign byte    72 NULL p = bp-4;
  2295 00000C1B C8040000                 ENTER  4,0
  2296 00000C1F B85A77                   mov ax, LabelNames
  2297 00000C22 8946FC                   mov [bp-4], ax
  2298                                  
  2299                                  ;-74     LIx = 1;
  2300                                  
  2301 00000C25 B80100                   mov ax, 1
  2302 00000C28 8946FE                   mov [bp-2], ax
  2303                                  
  2304                                  ;-75     while (LIx <= LabelMaxIx) {
  2305                                  
  2306                                  .searchLabel84:
  2307 00000C2B 8B46FE                   mov ax, [bp-2]
  2308 00000C2E 3B06[4900]               cmp ax, [LabelMaxIx]
  2309 00000C32 0F8F3100                 jg  .searchLabel85
  2310                                  
  2311                                  ;-76         if (eqstr(p, Symbol)) return LIx;//pos of label
  2312                                  
  2313 00000C36 8D063075                 lea  ax, [Symbol]
  2314 00000C3A 50                       push ax
  2315 00000C3B FF76FC                   push word [bp-4]
  2316 00000C3E E89306                   call eqstr
  2317 00000C41 83C404                   add  sp, 4
  2318 00000C44 08C0                     or  al, al
  2319 00000C46 0F840600                 je .searchLabel86
  2320 00000C4A 8B46FE                   mov ax, [bp-2]
  2321 00000C4D E91D00                   jmp .retnsearchLabel
  2322                                  
  2323                                  ;-77         p=strlen(p) + p;
  2324                                  
  2325                                  .searchLabel86:
  2326 00000C50 FF76FC                   push word [bp-4]
  2327 00000C53 E82006                   call strlen
  2328 00000C56 83C402                   add  sp, 2
  2329 00000C59 0346FC                   add ax, [bp-4]
  2330 00000C5C 8946FC                   mov [bp-4], ax
  2331                                  
  2332                                  ;-78         p++;
  2333                                  
  2334 00000C5F FF46FC                   inc  word[bp-4]
  2335                                  
  2336                                  ;-79         LIx++;
  2337                                  
  2338 00000C62 FF46FE                   inc  word[bp-2]
  2339                                  
  2340                                  ;-80     }
  2341                                  
  2342                                  
  2343                                  ;-81     return 0;
  2344                                  
  2345 00000C65 EBC4                     jmp .searchLabel84
  2346                                  .searchLabel85:
  2347 00000C67 B80000                   mov ax, 0
  2348 00000C6A E90000                   jmp .retnsearchLabel
  2349                                  
  2350                                  ;-82 }
  2351                                  
  2352                                  
  2353                                  ;-83 
  2354                                  
  2355                                  
  2356                                  ;-84 int getVariable() {
  2357                                  
  2358 00000C6D C9                       .retnsearchLabel: LEAVE
  2359 00000C6E C3                       ret
  2360                                  ENDP
  2361                                  
  2362                                  getVariable: PROC
  2363                                  
  2364                                  ;-85     char c;
  2365                                  
  2366                                  
  2367                                  ;-86     storeLabel();
  2368                                  
  2369                                  ;Function : getVariable, Number of local variables: 1
  2370                                  ;   # type sign width addr used name   list of local variables
  2371                                  ;  200 var sign byte    85 NULL c = bp-2;
  2372 00000C6F C8020000                 ENTER  2,0
  2373 00000C73 E8FEFE                   call storeLabel
  2374                                  
  2375                                  ;-87     getTokeType();
  2376                                  
  2377 00000C76 E8EAFD                   call getTokeType
  2378                                  
  2379                                  ;-88     if(TokeType==ALNUME) {//getName
  2380                                  
  2381 00000C79 A0[2D00]                 mov al, [TokeType]
  2382 00000C7C 3C03                     cmp al, 3
  2383 00000C7E 0F857001                 jne .getVariable87
  2384                                  
  2385                                  ;-89         lookCode();
  2386                                  
  2387 00000C82 E88301                   call lookCode
  2388                                  
  2389                                  ;-90         if (CodeType < 200) dataexit();
  2390                                  
  2391 00000C85 A0[3000]                 mov al, [CodeType]
  2392 00000C88 3CC8                     cmp al, 200
  2393 00000C8A 0F8D0300                 jge .getVariable88
  2394 00000C8E E80310                   call dataexit
  2395                                  
  2396                                  ;-91         if (CodeType > 205) dataexit();
  2397                                  
  2398                                  .getVariable88:
  2399 00000C91 A0[3000]                 mov al, [CodeType]
  2400 00000C94 3CCD                     cmp al, 205
  2401 00000C96 0F8E0300                 jle .getVariable89
  2402 00000C9A E8F70F                   call dataexit
  2403                                  
  2404                                  ;-92         if (CodeType== 200) {//DB
  2405                                  
  2406                                  .getVariable89:
  2407 00000C9D A0[3000]                 mov al, [CodeType]
  2408 00000CA0 3CC8                     cmp al, 200
  2409 00000CA2 0F856A00                 jne .getVariable90
  2410                                  
  2411                                  ;-93             do {
  2412                                  
  2413                                  .getVariable91:
  2414                                  
  2415                                  ;-94                 getTokeType();
  2416                                  
  2417 00000CA6 E8BAFD                   call getTokeType
  2418                                  
  2419                                  ;-95                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2420                                  
  2421 00000CA9 A0[2D00]                 mov al, [TokeType]
  2422 00000CAC 3C01                     cmp al, 1
  2423 00000CAE 0F850D00                 jne .getVariable92
  2424 00000CB2 FF36[0F00]               push word [SymbolInt]
  2425 00000CB6 E8FB14                   call genCode8
  2426 00000CB9 83C402                   add  sp, 2
  2427                                  
  2428                                  ;-96                 else {
  2429                                  
  2430 00000CBC E94100                   jmp .getVariable93
  2431                                  .getVariable92:
  2432                                  
  2433                                  ;-97                     skipBlank();
  2434                                  
  2435 00000CBF E8A504                   call skipBlank
  2436                                  
  2437                                  ;-98                     if (isToken('"')) {
  2438                                  
  2439 00000CC2 6A22                     push 34
  2440 00000CC4 E82F02                   call isToken
  2441 00000CC7 83C402                   add  sp, 2
  2442 00000CCA 08C0                     or  al, al
  2443 00000CCC 0F843000                 je .getVariable94
  2444                                  
  2445                                  ;-99                         do {
  2446                                  
  2447                                  .getVariable95:
  2448                                  
  2449                                  ;-100                             c= *InputPtr;
  2450                                  
  2451 00000CD0 8B1E[1500]               mov bx, [InputPtr]
  2452 00000CD4 8A07                     mov al, [bx]
  2453 00000CD6 B400                     mov ah, 0
  2454 00000CD8 8846FE                   mov [bp-2], al
  2455                                  
  2456                                  ;-101                             genCode8(c);
  2457                                  
  2458 00000CDB 8A46FE                   mov al, byte [bp-2]
  2459 00000CDE B400                     mov ah, 0
  2460 00000CE0 50                       push ax
  2461 00000CE1 E8D014                   call genCode8
  2462 00000CE4 83C402                   add  sp, 2
  2463                                  
  2464                                  ;-102                             InputPtr++;
  2465                                  
  2466 00000CE7 FF06[1500]               inc  word[InputPtr]
  2467                                  
  2468                                  ;-103                         } while (*InputPtr != '"' );
  2469                                  
  2470 00000CEB 8B1E[1500]               mov bx, [InputPtr]
  2471 00000CEF 8A07                     mov al, [bx]
  2472 00000CF1 B400                     mov ah, 0
  2473 00000CF3 83F822                   cmp ax, 34
  2474 00000CF6 0F840200                 je  .getVariable96
  2475 00000CFA EBD4                     jmp .getVariable95
  2476                                  .getVariable96:
  2477                                  
  2478                                  ;-104                         InputPtr++;
  2479                                  
  2480 00000CFC FF06[1500]               inc  word[InputPtr]
  2481                                  
  2482                                  ;-105                     }
  2483                                  
  2484                                  
  2485                                  ;-106                 }
  2486                                  
  2487                                  .getVariable94:
  2488                                  
  2489                                  ;-107             } while (isToken(','));
  2490                                  
  2491                                  .getVariable93:
  2492 00000D00 6A2C                     push 44
  2493 00000D02 E8F101                   call isToken
  2494 00000D05 83C402                   add  sp, 2
  2495 00000D08 08C0                     or  al, al
  2496 00000D0A 0F840200                 je .getVariable97
  2497 00000D0E EB96                     jmp .getVariable91
  2498                                  .getVariable97:
  2499                                  
  2500                                  ;-108         }
  2501                                  
  2502                                  
  2503                                  ;-109         if (CodeType == 201) {//DW
  2504                                  
  2505                                  .getVariable90:
  2506 00000D10 A0[3000]                 mov al, [CodeType]
  2507 00000D13 3CC9                     cmp al, 201
  2508 00000D15 0F852600                 jne .getVariable98
  2509                                  
  2510                                  ;-110             do {
  2511                                  
  2512                                  .getVariable99:
  2513                                  
  2514                                  ;-111                 getTokeType();
  2515                                  
  2516 00000D19 E847FD                   call getTokeType
  2517                                  
  2518                                  ;-112                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2519                                  
  2520 00000D1C A0[2D00]                 mov al, [TokeType]
  2521 00000D1F 3C01                     cmp al, 1
  2522 00000D21 0F850A00                 jne .getVariable100
  2523 00000D25 FF36[0F00]               push word [SymbolInt]
  2524 00000D29 E8DF14                   call genCode16
  2525 00000D2C 83C402                   add  sp, 2
  2526                                  
  2527                                  ;-113             } while (isToken(','));
  2528                                  
  2529                                  .getVariable100:
  2530 00000D2F 6A2C                     push 44
  2531 00000D31 E8C201                   call isToken
  2532 00000D34 83C402                   add  sp, 2
  2533 00000D37 08C0                     or  al, al
  2534 00000D39 0F840200                 je .getVariable101
  2535 00000D3D EBDA                     jmp .getVariable99
  2536                                  .getVariable101:
  2537                                  
  2538                                  ;-114         }
  2539                                  
  2540                                  
  2541                                  ;-115         if (CodeType == 202) {//DD
  2542                                  
  2543                                  .getVariable98:
  2544 00000D3F A0[3000]                 mov al, [CodeType]
  2545 00000D42 3CCA                     cmp al, 202
  2546 00000D44 0F852E00                 jne .getVariable102
  2547                                  
  2548                                  ;-116             do {
  2549                                  
  2550                                  .getVariable103:
  2551                                  
  2552                                  ;-117                 getTokeType();
  2553                                  
  2554 00000D48 E818FD                   call getTokeType
  2555                                  
  2556                                  ;-118                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2557                                  
  2558 00000D4B A0[2D00]                 mov al, [TokeType]
  2559 00000D4E 3C01                     cmp al, 1
  2560 00000D50 0F851200                 jne .getVariable104
  2561 00000D54 FF36[0F00]               push word [SymbolInt]
  2562 00000D58 E8B014                   call genCode16
  2563 00000D5B 83C402                   add  sp, 2
  2564                                  
  2565                                  ;-119                                     genCode16(0);}//todo genCode32(SymbolLong);
  2566                                  
  2567 00000D5E 6A00                     push 0
  2568 00000D60 E8A814                   call genCode16
  2569 00000D63 83C402                   add  sp, 2
  2570                                  
  2571                                  ;-120             } while (isToken(','));
  2572                                  
  2573                                  .getVariable104:
  2574 00000D66 6A2C                     push 44
  2575 00000D68 E88B01                   call isToken
  2576 00000D6B 83C402                   add  sp, 2
  2577 00000D6E 08C0                     or  al, al
  2578 00000D70 0F840200                 je .getVariable105
  2579 00000D74 EBD2                     jmp .getVariable103
  2580                                  .getVariable105:
  2581                                  
  2582                                  ;-121         }
  2583                                  
  2584                                  
  2585                                  ;-122         if (CodeType >= 203) {//resb, resw, resd
  2586                                  
  2587                                  .getVariable102:
  2588 00000D76 A0[3000]                 mov al, [CodeType]
  2589 00000D79 3CCB                     cmp al, 203 ;unsigned : 1
  2590 00000D7B 0F8C7000                 jl  .getVariable106
  2591                                  
  2592                                  ;-123             getTokeType();
  2593                                  
  2594 00000D7F E8E1FC                   call getTokeType
  2595                                  
  2596                                  ;-124             if (TokeType == DIGIT) {
  2597                                  
  2598 00000D82 A0[2D00]                 mov al, [TokeType]
  2599 00000D85 3C01                     cmp al, 1
  2600 00000D87 0F856100                 jne .getVariable107
  2601                                  
  2602                                  ;-125                 if (SymbolInt <= 0) syntaxerror();
  2603                                  
  2604 00000D8B A1[0F00]                 mov ax, [SymbolInt]
  2605 00000D8E 83F800                   cmp ax, 0
  2606 00000D91 0F870300                 ja  .getVariable108
  2607 00000D95 E8D10E                   call syntaxerror
  2608                                  
  2609                                  ;-126                 if (AbsoluteLab == 0) error1("Absolute is null");
  2610                                  
  2611                                  .getVariable108:
  2612 00000D98 A1[2800]                 mov ax, [AbsoluteLab]
  2613 00000D9B 83F800                   cmp ax, 0
  2614 00000D9E 0F850900                 jne .getVariable109
  2615 00000DA2 68[F70D]                 push getVariable_0
  2616 00000DA5 E8020D                   call error1
  2617 00000DA8 83C402                   add  sp, 2
  2618                                  
  2619                                  ;-127                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2620                                  
  2621                                  .getVariable109:
  2622 00000DAB A1[2800]                 mov ax, [AbsoluteLab]
  2623 00000DAE 8B1E[4900]               mov bx, [LabelMaxIx]
  2624 00000DB2 D1E3                     shl bx, 1
  2625 00000DB4 8987FA86                 mov [LabelAddr+bx], ax
  2626                                  
  2627                                  ;-128                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2628                                  
  2629 00000DB8 A0[3000]                 mov al, [CodeType]
  2630 00000DBB 3CCC                     cmp al, 204
  2631 00000DBD 0F850A00                 jne .getVariable110
  2632 00000DC1 A1[0F00]                 mov ax, [SymbolInt]
  2633 00000DC4 0306[0F00]               add ax, [SymbolInt]
  2634 00000DC8 A3[0F00]                 mov word [SymbolInt], ax
  2635                                  
  2636                                  ;-129                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2637                                  
  2638                                  .getVariable110:
  2639 00000DCB A0[3000]                 mov al, [CodeType]
  2640 00000DCE 3CCD                     cmp al, 205
  2641 00000DD0 0F850B00                 jne .getVariable111
  2642 00000DD4 A1[0F00]                 mov ax, [SymbolInt]
  2643 00000DD7 BB0400                   mov bx, 4
  2644 00000DDA F7E3                     mul bx
  2645 00000DDC A3[0F00]                 mov word [SymbolInt], ax
  2646                                  
  2647                                  ;-130                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2648                                  
  2649                                  .getVariable111:
  2650 00000DDF A1[2800]                 mov ax, [AbsoluteLab]
  2651 00000DE2 0306[0F00]               add ax, [SymbolInt]
  2652 00000DE6 A3[2800]                 mov word [AbsoluteLab], ax
  2653                                  
  2654                                  ;-131             } else numbererror();
  2655                                  
  2656 00000DE9 E90300                   jmp .getVariable112
  2657                                  .getVariable107:
  2658 00000DEC E8E70D                   call numbererror
  2659                                  
  2660                                  ;-132         }
  2661                                  
  2662                                  .getVariable112:
  2663                                  
  2664                                  ;-133     }
  2665                                  
  2666                                  .getVariable106:
  2667                                  
  2668                                  ;-134     else dataexit();
  2669                                  
  2670 00000DEF E90300                   jmp .getVariable113
  2671                                  .getVariable87:
  2672 00000DF2 E89F0E                   call dataexit
  2673                                  
  2674                                  ;-135 }
  2675                                  
  2676                                  .getVariable113:
  2677                                  
  2678                                  ;-136 
  2679                                  
  2680                                  
  2681                                  ;-137 int lookCode() {//ret: CodeType, *OpCodePtr
  2682 00000DF5 C9                       LEAVE
  2683 00000DF6 C3                       ret
  2684 00000DF7 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2685 00000E00 6973206E756C6C00   
  2686                                  ENDP
  2687                                  
  2688                                  lookCode: PROC
  2689                                  
  2690                                  ;-138     CodeType=0;
  2691                                  
  2692 00000E08 B80000                   mov ax, 0
  2693 00000E0B A2[3000]                 mov byte [CodeType], al
  2694                                  
  2695                                  ;-139     OpCodePtr= &I_START;
  2696                                  
  2697 00000E0E B8[5700]                 mov ax, I_START
  2698 00000E11 A3[4400]                 mov word [OpCodePtr], ax
  2699                                  
  2700                                  ;-140     OpCodePtr++;
  2701                                  
  2702 00000E14 FF06[4400]               inc  word[OpCodePtr]
  2703                                  
  2704                                  ;-141     do  {
  2705                                  
  2706                                  .lookCode114:
  2707                                  
  2708                                  ;-142         if (eqstr(SymbolUpper, OpCodePtr))  {
  2709                                  
  2710 00000E18 FF36[4400]               push word [OpCodePtr]
  2711 00000E1C 8D064F75                 lea  ax, [SymbolUpper]
  2712 00000E20 50                       push ax
  2713 00000E21 E8B004                   call eqstr
  2714 00000E24 83C404                   add  sp, 4
  2715 00000E27 08C0                     or  al, al
  2716 00000E29 0F842700                 je .lookCode115
  2717                                  
  2718                                  ;-143             while(*OpCodePtr!=0) OpCodePtr++;
  2719                                  
  2720                                  .lookCode116:
  2721 00000E2D 8B1E[4400]               mov bx, [OpCodePtr]
  2722 00000E31 8A07                     mov al, [bx]
  2723 00000E33 B400                     mov ah, 0
  2724 00000E35 83F800                   cmp ax, 0
  2725 00000E38 0F840600                 je  .lookCode117
  2726 00000E3C FF06[4400]               inc  word[OpCodePtr]
  2727                                  
  2728                                  ;-144             OpCodePtr++;
  2729                                  
  2730 00000E40 EBEB                     jmp .lookCode116
  2731                                  .lookCode117:
  2732 00000E42 FF06[4400]               inc  word[OpCodePtr]
  2733                                  
  2734                                  ;-145             CodeType =*OpCodePtr;
  2735                                  
  2736 00000E46 8B1E[4400]               mov bx, [OpCodePtr]
  2737 00000E4A 8A07                     mov al, [bx]
  2738 00000E4C B400                     mov ah, 0
  2739 00000E4E A2[3000]                 mov byte [CodeType], al
  2740                                  
  2741                                  ;-146             return;
  2742                                  
  2743 00000E51 E92A00                   jmp .retnlookCode
  2744                                  
  2745                                  ;-147         }
  2746                                  
  2747                                  
  2748                                  ;-148     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2749                                  
  2750                                  .lookCode115:
  2751                                  .lookCode118:
  2752 00000E54 8B1E[4400]               mov bx, [OpCodePtr]
  2753 00000E58 8A07                     mov al, [bx]
  2754 00000E5A B400                     mov ah, 0
  2755 00000E5C 3DF100                   cmp ax, 241
  2756 00000E5F 0F840600                 je  .lookCode119
  2757 00000E63 FF06[4400]               inc  word[OpCodePtr]
  2758                                  
  2759                                  ;-149     OpCodePtr++;
  2760                                  
  2761 00000E67 EBEB                     jmp .lookCode118
  2762                                  .lookCode119:
  2763 00000E69 FF06[4400]               inc  word[OpCodePtr]
  2764                                  
  2765                                  ;-150     } while(*OpCodePtr!=0);
  2766                                  
  2767 00000E6D 8B1E[4400]               mov bx, [OpCodePtr]
  2768 00000E71 8A07                     mov al, [bx]
  2769 00000E73 B400                     mov ah, 0
  2770 00000E75 83F800                   cmp ax, 0
  2771 00000E78 0F840200                 je  .lookCode120
  2772 00000E7C EB9A                     jmp .lookCode114
  2773                                  .lookCode120:
  2774                                  
  2775                                  ;-151 }
  2776                                  
  2777                                  
  2778                                  ;-152 
  2779                                  
  2780                                  
  2781                                  ;-153 int getCodeSize() {
  2782                                  
  2783                                   .retnlookCode:
  2784 00000E7E C3                       ret
  2785                                  ENDP
  2786                                  
  2787                                  getCodeSize: PROC
  2788                                  
  2789                                  ;-154     if (TokeType ==ALNUME) {
  2790                                  
  2791 00000E7F A0[2D00]                 mov al, [TokeType]
  2792 00000E82 3C03                     cmp al, 3
  2793 00000E84 0F855700                 jne .getCodeSize121
  2794                                  
  2795                                  ;-155         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2796                                  
  2797 00000E88 68[E60E]                 push getCodeSize_0
  2798 00000E8B 8D064F75                 lea  ax, [SymbolUpper]
  2799 00000E8F 50                       push ax
  2800 00000E90 E84104                   call eqstr
  2801 00000E93 83C404                   add  sp, 4
  2802 00000E96 08C0                     or  al, al
  2803 00000E98 0F840900                 je .getCodeSize122
  2804 00000E9C E8C4FB                   call getTokeType
  2805 00000E9F B80100                   mov ax, 1
  2806 00000EA2 E94000                   jmp .retngetCodeSize
  2807                                  
  2808                                  ;-156         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2809                                  
  2810                                  .getCodeSize122:
  2811 00000EA5 68[EB0E]                 push getCodeSize_1
  2812 00000EA8 8D064F75                 lea  ax, [SymbolUpper]
  2813 00000EAC 50                       push ax
  2814 00000EAD E82404                   call eqstr
  2815 00000EB0 83C404                   add  sp, 4
  2816 00000EB3 08C0                     or  al, al
  2817 00000EB5 0F840900                 je .getCodeSize123
  2818 00000EB9 E8A7FB                   call getTokeType
  2819 00000EBC B80200                   mov ax, 2
  2820 00000EBF E92300                   jmp .retngetCodeSize
  2821                                  
  2822                                  ;-157         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2823                                  
  2824                                  .getCodeSize123:
  2825 00000EC2 68[F00E]                 push getCodeSize_2
  2826 00000EC5 8D064F75                 lea  ax, [SymbolUpper]
  2827 00000EC9 50                       push ax
  2828 00000ECA E80704                   call eqstr
  2829 00000ECD 83C404                   add  sp, 4
  2830 00000ED0 08C0                     or  al, al
  2831 00000ED2 0F840900                 je .getCodeSize124
  2832 00000ED6 E88AFB                   call getTokeType
  2833 00000ED9 B80300                   mov ax, 3
  2834 00000EDC E90600                   jmp .retngetCodeSize
  2835                                  
  2836                                  ;-158     }
  2837                                  
  2838                                  .getCodeSize124:
  2839                                  
  2840                                  ;-159     return 0;
  2841                                  
  2842                                  .getCodeSize121:
  2843 00000EDF B80000                   mov ax, 0
  2844 00000EE2 E90000                   jmp .retngetCodeSize
  2845                                  
  2846                                  ;-160 }
  2847                                  
  2848                                  
  2849                                  ;-161 int isToken(char c) {
  2850                                  
  2851                                   .retngetCodeSize:
  2852 00000EE5 C3                       ret
  2853 00000EE6 4259544500              getCodeSize_0 db "BYTE",0
  2854 00000EEB 574F524400              getCodeSize_1 db "WORD",0
  2855 00000EF0 44574F524400            getCodeSize_2 db "DWORD",0
  2856                                  ENDP
  2857                                  
  2858                                  isToken: PROC
  2859                                  
  2860                                  ;-162     skipBlank();
  2861                                  
  2862                                  ;Function : isToken, Number of local variables: 1
  2863                                  ;   # type sign width addr used name   list of local variables
  2864                                  ;  200 var sign byte   161 NULL c = bp+4;
  2865 00000EF6 C8000000                 ENTER  0,0
  2866 00000EFA E86A02                   call skipBlank
  2867                                  
  2868                                  ;-163     if (*InputPtr == c) {
  2869                                  
  2870 00000EFD 8B1E[1500]               mov bx, [InputPtr]
  2871 00000F01 8A07                     mov al, [bx]
  2872 00000F03 B400                     mov ah, 0
  2873 00000F05 3A4604                   cmp al, [bp+4]
  2874 00000F08 0F850A00                 jne .isToken125
  2875                                  
  2876                                  ;-164         InputPtr++;
  2877                                  
  2878 00000F0C FF06[1500]               inc  word[InputPtr]
  2879                                  
  2880                                  ;-165         return 1;
  2881                                  
  2882 00000F10 B80100                   mov ax, 1
  2883 00000F13 E90600                   jmp .retnisToken
  2884                                  
  2885                                  ;-166         }
  2886                                  
  2887                                  
  2888                                  ;-167     return 0;
  2889                                  
  2890                                  .isToken125:
  2891 00000F16 B80000                   mov ax, 0
  2892 00000F19 E90000                   jmp .retnisToken
  2893                                  
  2894                                  ;-168 }
  2895                                  
  2896                                  
  2897                                  ;-169 int need(char c) {
  2898                                  
  2899 00000F1C C9                       .retnisToken: LEAVE
  2900 00000F1D C3                       ret
  2901                                  ENDP
  2902                                  
  2903                                  need: PROC
  2904                                  
  2905                                  ;-170     if (isToken(c)) {
  2906                                  
  2907                                  ;Function : need, Number of local variables: 1
  2908                                  ;   # type sign width addr used name   list of local variables
  2909                                  ;  200 var sign byte   169 NULL c = bp+4;
  2910 00000F1E C8000000                 ENTER  0,0
  2911 00000F22 8A4604                   mov al, byte [bp+4]
  2912 00000F25 B400                     mov ah, 0
  2913 00000F27 50                       push ax
  2914 00000F28 E8CBFF                   call isToken
  2915 00000F2B 83C402                   add  sp, 2
  2916 00000F2E 08C0                     or  al, al
  2917 00000F30 0F840600                 je .need126
  2918                                  
  2919                                  ;-171         getTokeType();
  2920                                  
  2921 00000F34 E82CFB                   call getTokeType
  2922                                  
  2923                                  ;-172         return;
  2924                                  
  2925 00000F37 E91800                   jmp .retnneed
  2926                                  
  2927                                  ;-173         }
  2928                                  
  2929                                  
  2930                                  ;-174     error1();
  2931                                  
  2932                                  .need126:
  2933 00000F3A E86D0B                   call error1
  2934                                  
  2935                                  ;-175     prs(". need: ");
  2936                                  
  2937 00000F3D 68[540F]                 push need_0
  2938 00000F40 E8150A                   call prs
  2939 00000F43 83C402                   add  sp, 2
  2940                                  
  2941                                  ;-176     prc(c);
  2942                                  
  2943 00000F46 8A4604                   mov al, byte [bp+4]
  2944 00000F49 B400                     mov ah, 0
  2945 00000F4B 50                       push ax
  2946 00000F4C E8A809                   call prc
  2947 00000F4F 83C402                   add  sp, 2
  2948                                  
  2949                                  ;-177 }
  2950                                  
  2951                                  
  2952                                  ;-178 int skipRest() {
  2953                                  
  2954 00000F52 C9                       .retnneed: LEAVE
  2955 00000F53 C3                       ret
  2956 00000F54 2E206E6565643A2000      need_0 db ". need: ",0
  2957                                  ENDP
  2958                                  
  2959                                  skipRest: PROC
  2960                                  
  2961                                  ;-179     getTokeType();
  2962                                  
  2963 00000F5D E803FB                   call getTokeType
  2964                                  
  2965                                  ;-180     if(TokeType)error1("extra char ignored");
  2966                                  
  2967 00000F60 A0[2D00]                 mov al, [TokeType]
  2968 00000F63 08C0                     or  al, al
  2969 00000F65 0F840900                 je .skipRest127
  2970 00000F69 68[730F]                 push skipRest_0
  2971 00000F6C E83B0B                   call error1
  2972 00000F6F 83C402                   add  sp, 2
  2973                                  
  2974                                  ;-181 }
  2975                                  
  2976                                  .skipRest127:
  2977 00000F72 C3                       ret
  2978 00000F73 657874726120636861-     skipRest_0 db "extra char ignored",0
  2979 00000F7C 722069676E6F726564-
  2980 00000F85 00                 
  2981                                  ENDP
  2982                                  ;Back to main program: AS.C
  2983                                  
  2984                                  ;-6 #include "HELPER.C"
  2985                                  
  2986                                  ;Use include file: HELPER.C
  2987                                  
  2988                                  ;-1 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  2989                                  
  2990                                  
  2991                                  writetty: PROC
  2992 00000F86 B40E                     mov  ah, 14
  2993 00000F88 BB0000                   mov  bx, 0
  2994 00000F8B CD10                     db 205,16
  2995                                  
  2996                                  ;-2 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  2997                                  
  2998 00000F8D C3                       ret
  2999                                  ENDP
  3000                                  
  3001                                  putch: PROC
  3002                                  ;Function : putch, Number of local variables: 1
  3003                                  ;   # type sign width addr used name   list of local variables
  3004                                  ;  200 var sign byte     2 NULL c = bp+4;
  3005 00000F8E C8000000                 ENTER  0,0 ; constant expression
  3006 00000F92 807E040A                cmp byte[bp+4], 10
  3007 00000F96 0F850500                 jne .putch128
  3008 00000F9A B00D                     mov  al, 13
  3009 00000F9C E8E7FF                   call writetty
  3010                                  .putch128:
  3011 00000F9F 8A4604                   mov  al, [bp+4]
  3012 00000FA2 E8E1FF                   call writetty
  3013                                  
  3014                                  ;-3 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3015 00000FA5 C9                       LEAVE
  3016 00000FA6 C3                       ret
  3017                                  ENDP
  3018                                  
  3019                                  cputs: PROC
  3020                                  ;Function : cputs, Number of local variables: 2
  3021                                  ;   # type sign width addr used name   list of local variables
  3022                                  ;  200 ptr sign byte     3 NULL s = bp+4
  3023                                  ;  201 var sign byte     3 NULL c = bp-2;
  3024 00000FA7 C8020000                 ENTER  2,0
  3025                                  .cputs129:
  3026 00000FAB 8B5E04                   mov bx, [bp+4]
  3027 00000FAE 8A07                     mov al, [bx]
  3028 00000FB0 B400                     mov ah, 0
  3029 00000FB2 08C0                     or  al, al
  3030 00000FB4 0F841B00                 je .cputs130
  3031 00000FB8 8B5E04                   mov bx, [bp+4]
  3032 00000FBB 8A07                     mov al, [bx]
  3033 00000FBD B400                     mov ah, 0
  3034 00000FBF 8846FE                   mov [bp-2], al
  3035 00000FC2 8A46FE                   mov al, byte [bp-2]
  3036 00000FC5 B400                     mov ah, 0
  3037 00000FC7 50                       push ax
  3038 00000FC8 E8C3FF                   call putch
  3039 00000FCB 83C402                   add  sp, 2
  3040 00000FCE FF4604                   inc  word[bp+4]
  3041 00000FD1 EBD8                     jmp .cputs129
  3042                                  .cputs130:
  3043                                  
  3044                                  ;-4 
  3045                                  
  3046                                  
  3047                                  ;-5 int DosInt() {
  3048 00000FD3 C9                       LEAVE
  3049 00000FD4 C3                       ret
  3050                                  ENDP
  3051                                  
  3052                                  DosInt: PROC
  3053                                  
  3054                                  ;-6     __emit__(0xCD,0x21);//inth 0x21;
  3055                                  
  3056 00000FD5 CD21                     db 205,33
  3057                                  
  3058                                  ;-7     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3059                                  
  3060 00000FD7 7304                     db 115,4
  3061                                  
  3062                                  ;-8     DOS_ERR++;
  3063                                  
  3064 00000FD9 FF06[1D00]               inc  word[DOS_ERR]
  3065                                  
  3066                                  ;-9 }
  3067                                  
  3068                                  
  3069                                  ;-10 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3070                                  
  3071 00000FDD C3                       ret
  3072                                  ENDP
  3073                                  
  3074                                  openR: PROC
  3075                                  ;Function : openR, Number of local variables: 1
  3076                                  ;   # type sign width addr used name   list of local variables
  3077                                  ;  200 ptr sign byte    10 NULL s = bp+4;
  3078 00000FDE C8000000                 ENTER  0,0
  3079 00000FE2 8B5604                   mov  dx, [bp+4]
  3080 00000FE5 B8023D                   mov  ax, 15618
  3081 00000FE8 E8EAFF                   call DosInt
  3082                                  
  3083                                  ;-11 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3084 00000FEB C9                       LEAVE
  3085 00000FEC C3                       ret
  3086                                  ENDP
  3087                                  
  3088                                  creatR: PROC
  3089                                  ;Function : creatR, Number of local variables: 1
  3090                                  ;   # type sign width addr used name   list of local variables
  3091                                  ;  200 ptr sign byte    11 NULL s = bp+4;
  3092 00000FED C8000000                 ENTER  0,0
  3093 00000FF1 8B5604                   mov  dx, [bp+4]
  3094 00000FF4 B90000                   mov  cx, 0
  3095 00000FF7 B8003C                   mov  ax, 15360
  3096 00000FFA E8D8FF                   call DosInt
  3097                                  
  3098                                  ;-12 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3099 00000FFD C9                       LEAVE
  3100 00000FFE C3                       ret
  3101                                  ENDP
  3102                                  
  3103                                  fcloseR: PROC
  3104                                  ;Function : fcloseR, Number of local variables: 1
  3105                                  ;   # type sign width addr used name   list of local variables
  3106                                  ;  200 var sign word    12 NULL fd = bp+4;
  3107 00000FFF C8000000                 ENTER  0,0
  3108 00001003 8B5E04                   mov  bx, [bp+4]
  3109 00001006 B8003E                   mov  ax, 15872
  3110 00001009 E8C9FF                   call DosInt
  3111                                  
  3112                                  ;-13 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3113 0000100C C9                       LEAVE
  3114 0000100D C3                       ret
  3115                                  ENDP
  3116                                  
  3117                                  exitR: PROC
  3118                                  ;Function : exitR, Number of local variables: 1
  3119                                  ;   # type sign width addr used name   list of local variables
  3120                                  ;  200 var sign byte    13 NULL c = bp+4;
  3121 0000100E C8000000                 ENTER  0,0
  3122 00001012 B44C                     mov  ah, 76
  3123 00001014 8A4604                   mov  al, [bp+4]
  3124 00001017 E8BBFF                   call DosInt
  3125                                  
  3126                                  ;-14 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3127 0000101A C9                       LEAVE
  3128 0000101B C3                       ret
  3129                                  ENDP
  3130                                  
  3131                                  readRL: PROC
  3132                                  ;Function : readRL, Number of local variables: 3
  3133                                  ;   # type sign width addr used name   list of local variables
  3134                                  ;  200 ptr sign byte    14 NULL s = bp+4
  3135                                  ;  201 var sign word    14 NULL fd = bp+6
  3136                                  ;  202 var sign word    14 NULL len = bp+8;
  3137 0000101C C8000000                 ENTER  0,0
  3138 00001020 8B5604                   mov  dx, [bp+4]
  3139 00001023 8B4E08                   mov  cx, [bp+8]
  3140 00001026 8B5E06                   mov  bx, [bp+6]
  3141 00001029 B8003F                   mov  ax, 16128
  3142 0000102C E8A6FF                   call DosInt
  3143                                  
  3144                                  ;-15 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3145 0000102F C9                       LEAVE
  3146 00001030 C3                       ret
  3147                                  ENDP
  3148                                  
  3149                                  fputcR: PROC
  3150                                  ;Function : fputcR, Number of local variables: 2
  3151                                  ;   # type sign width addr used name   list of local variables
  3152                                  ;  200 ptr sign byte    15 NULL n = bp+4
  3153                                  ;  201 var sign word    15 NULL fd = bp+6;
  3154 00001031 C8000000                 ENTER  0,0
  3155 00001035 8D5604                  lea dx, [bp+4]
  3156                                  
  3157                                  ;-16   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3158                                  
  3159 00001038 B90100                   mov  cx, 1
  3160 0000103B 8B5E06                   mov  bx, [bp+6]
  3161 0000103E B80040                   mov  ax, 16384
  3162 00001041 E891FF                   call DosInt
  3163                                  
  3164                                  ;-17 
  3165                                  
  3166                                  
  3167                                  ;-18 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3168 00001044 C9                       LEAVE
  3169 00001045 C3                       ret
  3170                                  ENDP
  3171                                  
  3172                                  getLine: PROC
  3173                                  
  3174                                  ;-19   unsigned int i;
  3175                                  
  3176                                  
  3177                                  ;-20   InputPtr= &InputBuf;
  3178                                  
  3179                                  ;Function : getLine, Number of local variables: 1
  3180                                  ;   # type sign width addr used name   list of local variables
  3181                                  ;  200 var unsg word    19 NULL i = bp-2;
  3182 00001046 C8020000                 ENTER  2,0
  3183 0000104A B88D75                   mov ax, InputBuf
  3184 0000104D A3[1500]                 mov word [InputPtr], ax
  3185                                  
  3186                                  ;-21   *InputPtr=0;//if last line is empty
  3187                                  
  3188 00001050 B80000                   mov ax, 0
  3189 00001053 8B1E[1500]               mov  bx, [InputPtr]
  3190 00001057 8807                     mov  [bx], al
  3191                                  
  3192                                  ;-22   do {
  3193                                  
  3194                                  .getLine131:
  3195                                  
  3196                                  ;-23     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3197                                  
  3198 00001059 6A01                     push 1
  3199 0000105B FF36[1700]               push word [asm_fd]
  3200 0000105F 8D06[2300]               lea  ax, [DOS_ByteRead]
  3201 00001063 50                       push ax
  3202 00001064 E8B5FF                   call readRL
  3203 00001067 83C406                   add  sp, 6
  3204 0000106A A3[2100]                 mov word [DOS_NoBytes], ax
  3205                                  
  3206                                  ;-24     if (DOS_ERR) errorexit("Reading Source");
  3207                                  
  3208 0000106D A1[1D00]                 mov ax, [DOS_ERR]
  3209 00001070 08C0                     or  al, al
  3210 00001072 0F840900                 je .getLine132
  3211 00001076 68[D810]                 push getLine_0
  3212 00001079 E88A0A                   call errorexit
  3213 0000107C 83C402                   add  sp, 2
  3214                                  
  3215                                  ;-25     if (DOS_NoBytes == 0) return;
  3216                                  
  3217                                  .getLine132:
  3218 0000107F A1[2100]                 mov ax, [DOS_NoBytes]
  3219 00001082 83F800                   cmp ax, 0
  3220 00001085 0F850300                 jne .getLine133
  3221 00001089 E94A00                   jmp .retngetLine
  3222                                  
  3223                                  ;-26     *InputPtr = DOS_ByteRead;
  3224                                  
  3225                                  .getLine133:
  3226 0000108C A0[2300]                 mov al, [DOS_ByteRead]
  3227 0000108F 8B1E[1500]               mov  bx, [InputPtr]
  3228 00001093 8807                     mov  [bx], al
  3229                                  
  3230                                  ;-27     InputPtr++;
  3231                                  
  3232 00001095 FF06[1500]               inc  word[InputPtr]
  3233                                  
  3234                                  ;-28     i = InputPtr - &InputBuf;
  3235                                  
  3236 00001099 A1[1500]                 mov ax, [InputPtr]
  3237 0000109C 2D8D75                   sub ax, InputBuf
  3238 0000109F 8946FE                   mov [bp-2], ax
  3239                                  
  3240                                  ;-29     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3241                                  
  3242 000010A2 8B46FE                   mov ax, [bp-2]
  3243 000010A5 3DFF00                   cmp ax, 255 ;unsigned : 0
  3244 000010A8 0F820900                 jb  .getLine134
  3245 000010AC 68[E710]                 push getLine_1
  3246 000010AF E8540A                   call errorexit
  3247 000010B2 83C402                   add  sp, 2
  3248                                  
  3249                                  ;-30   } while (ifEOL(DOS_ByteRead) == 0);
  3250                                  
  3251                                  .getLine134:
  3252 000010B5 A0[2300]                 mov al, byte [DOS_ByteRead]
  3253 000010B8 B400                     mov ah, 0
  3254 000010BA 50                       push ax
  3255 000010BB E83D00                   call ifEOL
  3256 000010BE 83C402                   add  sp, 2
  3257 000010C1 3C00                     cmp al, 0
  3258 000010C3 0F850200                 jne .getLine135
  3259 000010C7 EB90                     jmp .getLine131
  3260                                  .getLine135:
  3261                                  
  3262                                  ;-31   InputPtr--;
  3263                                  
  3264 000010C9 FF0E[1500]               dec  word[InputPtr]
  3265                                  
  3266                                  ;-32   *InputPtr=0;
  3267                                  
  3268 000010CD B80000                   mov ax, 0
  3269 000010D0 8B1E[1500]               mov  bx, [InputPtr]
  3270 000010D4 8807                     mov  [bx], al
  3271                                  
  3272                                  ;-33 }
  3273                                  
  3274                                  
  3275                                  ;-34 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3276                                  
  3277 000010D6 C9                       .retngetLine: LEAVE
  3278 000010D7 C3                       ret
  3279 000010D8 52656164696E672053-     getLine_0 db "Reading Source",0
  3280 000010E1 6F7572636500       
  3281 000010E7 696E707574206C696E-     getLine_1 db "input line too long",0
  3282 000010F0 6520746F6F206C6F6E-
  3283 000010F9 6700               
  3284                                  ENDP
  3285                                  
  3286                                  ifEOL: PROC
  3287                                  
  3288                                  ;-35   if (c == 10) return 1;//LF
  3289                                  
  3290                                  ;Function : ifEOL, Number of local variables: 1
  3291                                  ;   # type sign width addr used name   list of local variables
  3292                                  ;  200 var sign byte    34 NULL c = bp+4;
  3293 000010FB C8000000                 ENTER  0,0
  3294 000010FF 8A4604                   mov al, [bp+4]
  3295 00001102 3C0A                     cmp al, 10
  3296 00001104 0F850600                 jne .ifEOL136
  3297 00001108 B80100                   mov ax, 1
  3298 0000110B E93B00                   jmp .retnifEOL
  3299                                  
  3300                                  ;-36   if (c == 13) {//CR
  3301                                  
  3302                                  .ifEOL136:
  3303 0000110E 8A4604                   mov al, [bp+4]
  3304 00001111 3C0D                     cmp al, 13
  3305 00001113 0F852C00                 jne .ifEOL137
  3306                                  
  3307                                  ;-37     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3308                                  
  3309 00001117 6A01                     push 1
  3310 00001119 FF36[1700]               push word [asm_fd]
  3311 0000111D 8D06[2300]               lea  ax, [DOS_ByteRead]
  3312 00001121 50                       push ax
  3313 00001122 E8F7FE                   call readRL
  3314 00001125 83C406                   add  sp, 6
  3315 00001128 A3[2100]                 mov word [DOS_NoBytes], ax
  3316                                  
  3317                                  ;-38     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3318                                  
  3319 0000112B A0[2300]                 mov al, [DOS_ByteRead]
  3320 0000112E 3C0A                     cmp al, 10
  3321 00001130 0F840900                 je  .ifEOL138
  3322 00001134 68[4B11]                 push ifEOL_0
  3323 00001137 E8CC09                   call errorexit
  3324 0000113A 83C402                   add  sp, 2
  3325                                  
  3326                                  ;-39     return 1;
  3327                                  
  3328                                  .ifEOL138:
  3329 0000113D B80100                   mov ax, 1
  3330 00001140 E90600                   jmp .retnifEOL
  3331                                  
  3332                                  ;-40   }
  3333                                  
  3334                                  
  3335                                  ;-41   return 0;
  3336                                  
  3337                                  .ifEOL137:
  3338 00001143 B80000                   mov ax, 0
  3339 00001146 E90000                   jmp .retnifEOL
  3340                                  
  3341                                  ;-42 }
  3342                                  
  3343                                  
  3344                                  ;-43 int skipBlank() {
  3345                                  
  3346 00001149 C9                       .retnifEOL: LEAVE
  3347 0000114A C3                       ret
  3348 0000114B 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3349 00001154 462831302920616674-
  3350 0000115D 657220435228313329-
  3351 00001166 00                 
  3352                                  ENDP
  3353                                  
  3354                                  skipBlank: PROC
  3355                                  
  3356                                  ;-44   skipblank1:
  3357                                  
  3358                                  .skipblank1:
  3359                                  
  3360                                  ;-45     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3361                                  
  3362 00001167 8B1E[1500]               mov bx, [InputPtr]
  3363 0000116B 8A07                     mov al, [bx]
  3364 0000116D B400                     mov ah, 0
  3365 0000116F 83F820                   cmp ax, 32
  3366 00001172 0F850600                 jne .skipBlank139
  3367 00001176 FF06[1500]               inc  word[InputPtr]
  3368 0000117A EBEB                     jmp .skipblank1
  3369                                  
  3370                                  ;-46     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3371                                  
  3372                                  .skipBlank139:
  3373 0000117C 8B1E[1500]               mov bx, [InputPtr]
  3374 00001180 8A07                     mov al, [bx]
  3375 00001182 B400                     mov ah, 0
  3376 00001184 83F809                   cmp ax, 9
  3377 00001187 0F850600                 jne .skipBlank140
  3378 0000118B FF06[1500]               inc  word[InputPtr]
  3379 0000118F EBD6                     jmp .skipblank1
  3380                                  
  3381                                  ;-47 }
  3382                                  
  3383                                  .skipBlank140:
  3384                                  
  3385                                  ;-48 int letterE(char c) {
  3386                                  
  3387 00001191 C3                       ret
  3388                                  ENDP
  3389                                  
  3390                                  letterE: PROC
  3391                                  
  3392                                  ;-49   if (c=='_') return 1;
  3393                                  
  3394                                  ;Function : letterE, Number of local variables: 1
  3395                                  ;   # type sign width addr used name   list of local variables
  3396                                  ;  200 var sign byte    48 NULL c = bp+4;
  3397 00001192 C8000000                 ENTER  0,0
  3398 00001196 8A4604                   mov al, [bp+4]
  3399 00001199 3C5F                     cmp al, 95
  3400 0000119B 0F850600                 jne .letterE141
  3401 0000119F B80100                   mov ax, 1
  3402 000011A2 E96900                   jmp .retnletterE
  3403                                  
  3404                                  ;-50   if (c=='.') return 1;
  3405                                  
  3406                                  .letterE141:
  3407 000011A5 8A4604                   mov al, [bp+4]
  3408 000011A8 3C2E                     cmp al, 46
  3409 000011AA 0F850600                 jne .letterE142
  3410 000011AE B80100                   mov ax, 1
  3411 000011B1 E95A00                   jmp .retnletterE
  3412                                  
  3413                                  ;-51   if (c=='?') return 1;
  3414                                  
  3415                                  .letterE142:
  3416 000011B4 8A4604                   mov al, [bp+4]
  3417 000011B7 3C3F                     cmp al, 63
  3418 000011B9 0F850600                 jne .letterE143
  3419 000011BD B80100                   mov ax, 1
  3420 000011C0 E94B00                   jmp .retnletterE
  3421                                  
  3422                                  ;-52   if (c=='$') return 1;
  3423                                  
  3424                                  .letterE143:
  3425 000011C3 8A4604                   mov al, [bp+4]
  3426 000011C6 3C24                     cmp al, 36
  3427 000011C8 0F850600                 jne .letterE144
  3428 000011CC B80100                   mov ax, 1
  3429 000011CF E93C00                   jmp .retnletterE
  3430                                  
  3431                                  ;-53   if (c> 'z') return 0;
  3432                                  
  3433                                  .letterE144:
  3434 000011D2 8A4604                   mov al, [bp+4]
  3435 000011D5 3C7A                     cmp al, 122
  3436 000011D7 0F8E0600                 jle .letterE145
  3437 000011DB B80000                   mov ax, 0
  3438 000011DE E92D00                   jmp .retnletterE
  3439                                  
  3440                                  ;-54   if (c< '@') return 0; // at included
  3441                                  
  3442                                  .letterE145:
  3443 000011E1 8A4604                   mov al, [bp+4]
  3444 000011E4 3C40                     cmp al, 64
  3445 000011E6 0F8D0600                 jge .letterE146
  3446 000011EA B80000                   mov ax, 0
  3447 000011ED E91E00                   jmp .retnletterE
  3448                                  
  3449                                  ;-55   if (c> 'Z') { if (c< 'a') return 0; }
  3450                                  
  3451                                  .letterE146:
  3452 000011F0 8A4604                   mov al, [bp+4]
  3453 000011F3 3C5A                     cmp al, 90
  3454 000011F5 0F8E0F00                 jle .letterE147
  3455 000011F9 8A4604                   mov al, [bp+4]
  3456 000011FC 3C61                     cmp al, 97
  3457 000011FE 0F8D0600                 jge .letterE148
  3458 00001202 B80000                   mov ax, 0
  3459 00001205 E90600                   jmp .retnletterE
  3460                                  .letterE148:
  3461                                  
  3462                                  ;-56   return 1;
  3463                                  
  3464                                  .letterE147:
  3465 00001208 B80100                   mov ax, 1
  3466 0000120B E90000                   jmp .retnletterE
  3467                                  
  3468                                  ;-57 }
  3469                                  
  3470                                  
  3471                                  ;-58 int alnumE(char c) {
  3472                                  
  3473 0000120E C9                       .retnletterE: LEAVE
  3474 0000120F C3                       ret
  3475                                  ENDP
  3476                                  
  3477                                  alnumE: PROC
  3478                                  
  3479                                  ;-59   if (digit(c)) return 1;
  3480                                  
  3481                                  ;Function : alnumE, Number of local variables: 1
  3482                                  ;   # type sign width addr used name   list of local variables
  3483                                  ;  200 var sign byte    58 NULL c = bp+4;
  3484 00001210 C8000000                 ENTER  0,0
  3485 00001214 8A4604                   mov al, byte [bp+4]
  3486 00001217 B400                     mov ah, 0
  3487 00001219 50                       push ax
  3488 0000121A E82F00                   call digit
  3489 0000121D 83C402                   add  sp, 2
  3490 00001220 08C0                     or  al, al
  3491 00001222 0F840600                 je .alnumE149
  3492 00001226 B80100                   mov ax, 1
  3493 00001229 E91E00                   jmp .retnalnumE
  3494                                  
  3495                                  ;-60   if (letterE(c)) return 1;
  3496                                  
  3497                                  .alnumE149:
  3498 0000122C 8A4604                   mov al, byte [bp+4]
  3499 0000122F B400                     mov ah, 0
  3500 00001231 50                       push ax
  3501 00001232 E85DFF                   call letterE
  3502 00001235 83C402                   add  sp, 2
  3503 00001238 08C0                     or  al, al
  3504 0000123A 0F840600                 je .alnumE150
  3505 0000123E B80100                   mov ax, 1
  3506 00001241 E90600                   jmp .retnalnumE
  3507                                  
  3508                                  ;-61   return 0;
  3509                                  
  3510                                  .alnumE150:
  3511 00001244 B80000                   mov ax, 0
  3512 00001247 E90000                   jmp .retnalnumE
  3513                                  
  3514                                  ;-62 }
  3515                                  
  3516                                  
  3517                                  ;-63 int digit(char c){
  3518                                  
  3519 0000124A C9                       .retnalnumE: LEAVE
  3520 0000124B C3                       ret
  3521                                  ENDP
  3522                                  
  3523                                  digit: PROC
  3524                                  
  3525                                  ;-64     if(c<'0') return 0;
  3526                                  
  3527                                  ;Function : digit, Number of local variables: 1
  3528                                  ;   # type sign width addr used name   list of local variables
  3529                                  ;  200 var sign byte    63 NULL c = bp+4;
  3530 0000124C C8000000                 ENTER  0,0
  3531 00001250 8A4604                   mov al, [bp+4]
  3532 00001253 3C30                     cmp al, 48
  3533 00001255 0F8D0600                 jge .digit151
  3534 00001259 B80000                   mov ax, 0
  3535 0000125C E91500                   jmp .retndigit
  3536                                  
  3537                                  ;-65     if(c>'9') return 0;
  3538                                  
  3539                                  .digit151:
  3540 0000125F 8A4604                   mov al, [bp+4]
  3541 00001262 3C39                     cmp al, 57
  3542 00001264 0F8E0600                 jle .digit152
  3543 00001268 B80000                   mov ax, 0
  3544 0000126B E90600                   jmp .retndigit
  3545                                  
  3546                                  ;-66     return 1;
  3547                                  
  3548                                  .digit152:
  3549 0000126E B80100                   mov ax, 1
  3550 00001271 E90000                   jmp .retndigit
  3551                                  
  3552                                  ;-67 }
  3553                                  
  3554                                  
  3555                                  ;-68 int strlen(char *s) { int c;
  3556                                  
  3557 00001274 C9                       .retndigit: LEAVE
  3558 00001275 C3                       ret
  3559                                  ENDP
  3560                                  
  3561                                  strlen: PROC
  3562                                  
  3563                                  ;-69     c=0;
  3564                                  
  3565                                  ;Function : strlen, Number of local variables: 2
  3566                                  ;   # type sign width addr used name   list of local variables
  3567                                  ;  200 ptr sign byte    68 NULL s = bp+4
  3568                                  ;  201 var sign word    68 NULL c = bp-2;
  3569 00001276 C8020000                 ENTER  2,0
  3570 0000127A B80000                   mov ax, 0
  3571 0000127D 8946FE                   mov [bp-2], ax
  3572                                  
  3573                                  ;-70     while (*s!=0) {s++; c++;}
  3574                                  
  3575                                  .strlen153:
  3576 00001280 8B5E04                   mov bx, [bp+4]
  3577 00001283 8A07                     mov al, [bx]
  3578 00001285 B400                     mov ah, 0
  3579 00001287 83F800                   cmp ax, 0
  3580 0000128A 0F840800                 je  .strlen154
  3581 0000128E FF4604                   inc  word[bp+4]
  3582 00001291 FF46FE                   inc  word[bp-2]
  3583                                  
  3584                                  ;-71     return c;
  3585                                  
  3586 00001294 EBEA                     jmp .strlen153
  3587                                  .strlen154:
  3588 00001296 8B46FE                   mov ax, [bp-2]
  3589 00001299 E90000                   jmp .retnstrlen
  3590                                  
  3591                                  ;-72     }
  3592                                  
  3593                                  
  3594                                  ;-73 int strcpy(char *s, char *t) {
  3595                                  
  3596 0000129C C9                       .retnstrlen: LEAVE
  3597 0000129D C3                       ret
  3598                                  ENDP
  3599                                  
  3600                                  strcpy: PROC
  3601                                  
  3602                                  ;-74     do { *s=*t; s++; t++; }
  3603                                  
  3604                                  ;Function : strcpy, Number of local variables: 2
  3605                                  ;   # type sign width addr used name   list of local variables
  3606                                  ;  200 ptr sign byte    73 NULL s = bp+4
  3607                                  ;  201 ptr sign byte    73 NULL t = bp+6;
  3608 0000129E C8000000                 ENTER  0,0
  3609                                  .strcpy155:
  3610 000012A2 8B5E06                   mov bx, [bp+6]
  3611 000012A5 8A07                     mov al, [bx]
  3612 000012A7 B400                     mov ah, 0
  3613 000012A9 8B5E04                   mov  bx, [bp+4]
  3614 000012AC 8807                     mov  [bx], al
  3615 000012AE FF4604                   inc  word[bp+4]
  3616 000012B1 FF4606                   inc  word[bp+6]
  3617                                  
  3618                                  ;-75     while (*t!=0);
  3619                                  
  3620 000012B4 8B5E06                   mov bx, [bp+6]
  3621 000012B7 8A07                     mov al, [bx]
  3622 000012B9 B400                     mov ah, 0
  3623 000012BB 83F800                   cmp ax, 0
  3624 000012BE 0F840200                 je  .strcpy156
  3625 000012C2 EBDE                     jmp .strcpy155
  3626                                  .strcpy156:
  3627                                  
  3628                                  ;-76     *s=0;
  3629                                  
  3630 000012C4 B80000                   mov ax, 0
  3631 000012C7 8B5E04                   mov  bx, [bp+4]
  3632 000012CA 8807                     mov  [bx], al
  3633                                  
  3634                                  ;-77     return s;
  3635                                  
  3636 000012CC 8B4604                   mov ax, [bp+4]
  3637 000012CF E90000                   jmp .retnstrcpy
  3638                                  
  3639                                  ;-78     }
  3640                                  
  3641                                  
  3642                                  ;-79 int eqstr(char *p, char *q) {
  3643                                  
  3644 000012D2 C9                       .retnstrcpy: LEAVE
  3645 000012D3 C3                       ret
  3646                                  ENDP
  3647                                  
  3648                                  eqstr: PROC
  3649                                  
  3650                                  ;-80     while(*p) {
  3651                                  
  3652                                  ;Function : eqstr, Number of local variables: 2
  3653                                  ;   # type sign width addr used name   list of local variables
  3654                                  ;  200 ptr sign byte    79 NULL p = bp+4
  3655                                  ;  201 ptr sign byte    79 NULL q = bp+6;
  3656 000012D4 C8000000                 ENTER  0,0
  3657                                  .eqstr157:
  3658 000012D8 8B5E04                   mov bx, [bp+4]
  3659 000012DB 8A07                     mov al, [bx]
  3660 000012DD B400                     mov ah, 0
  3661 000012DF 08C0                     or  al, al
  3662 000012E1 0F842000                 je .eqstr158
  3663                                  
  3664                                  ;-81         if (*p != *q) return 0;
  3665                                  
  3666 000012E5 8B5E04                   mov bx, [bp+4]
  3667 000012E8 8A07                     mov al, [bx]
  3668 000012EA B400                     mov ah, 0
  3669 000012EC 8B5E06                   mov bx, [bp+6]
  3670 000012EF 3A07                     cmp al, [bx]
  3671 000012F1 B400                     mov ah, 0
  3672 000012F3 0F840600                 je  .eqstr159
  3673 000012F7 B80000                   mov ax, 0
  3674 000012FA E92100                   jmp .retneqstr
  3675                                  
  3676                                  ;-82             p++;
  3677                                  
  3678                                  .eqstr159:
  3679 000012FD FF4604                   inc  word[bp+4]
  3680                                  
  3681                                  ;-83             q++;
  3682                                  
  3683 00001300 FF4606                   inc  word[bp+6]
  3684                                  
  3685                                  ;-84             }
  3686                                  
  3687                                  
  3688                                  ;-85     if(*q) return 0;
  3689                                  
  3690 00001303 EBD3                     jmp .eqstr157
  3691                                  .eqstr158:
  3692 00001305 8B5E06                   mov bx, [bp+6]
  3693 00001308 8A07                     mov al, [bx]
  3694 0000130A B400                     mov ah, 0
  3695 0000130C 08C0                     or  al, al
  3696 0000130E 0F840600                 je .eqstr160
  3697 00001312 B80000                   mov ax, 0
  3698 00001315 E90600                   jmp .retneqstr
  3699                                  
  3700                                  ;-86     return 1;
  3701                                  
  3702                                  .eqstr160:
  3703 00001318 B80100                   mov ax, 1
  3704 0000131B E90000                   jmp .retneqstr
  3705                                  
  3706                                  ;-87     }
  3707                                  
  3708                                  
  3709                                  ;-88 int strcat1(char *s, char *t) {
  3710                                  
  3711 0000131E C9                       .retneqstr: LEAVE
  3712 0000131F C3                       ret
  3713                                  ENDP
  3714                                  
  3715                                  strcat1: PROC
  3716                                  
  3717                                  ;-89     while (*s != 0) s++;
  3718                                  
  3719                                  ;Function : strcat1, Number of local variables: 2
  3720                                  ;   # type sign width addr used name   list of local variables
  3721                                  ;  200 ptr sign byte    88 NULL s = bp+4
  3722                                  ;  201 ptr sign byte    88 NULL t = bp+6;
  3723 00001320 C8000000                 ENTER  0,0
  3724                                  .strcat1161:
  3725 00001324 8B5E04                   mov bx, [bp+4]
  3726 00001327 8A07                     mov al, [bx]
  3727 00001329 B400                     mov ah, 0
  3728 0000132B 83F800                   cmp ax, 0
  3729 0000132E 0F840500                 je  .strcat1162
  3730 00001332 FF4604                   inc  word[bp+4]
  3731                                  
  3732                                  ;-90     strcpy(s, t);
  3733                                  
  3734 00001335 EBED                     jmp .strcat1161
  3735                                  .strcat1162:
  3736 00001337 FF7606                   push word [bp+6]
  3737 0000133A FF7604                   push word [bp+4]
  3738 0000133D E85EFF                   call strcpy
  3739 00001340 83C404                   add  sp, 4
  3740                                  
  3741                                  ;-91     }
  3742                                  
  3743                                  
  3744                                  ;-92 int toupper(char *s) {
  3745 00001343 C9                       LEAVE
  3746 00001344 C3                       ret
  3747                                  ENDP
  3748                                  
  3749                                  toupper: PROC
  3750                                  
  3751                                  ;-93     while(*s) {
  3752                                  
  3753                                  ;Function : toupper, Number of local variables: 1
  3754                                  ;   # type sign width addr used name   list of local variables
  3755                                  ;  200 ptr sign byte    92 NULL s = bp+4;
  3756 00001345 C8000000                 ENTER  0,0
  3757                                  .toupper163:
  3758 00001349 8B5E04                   mov bx, [bp+4]
  3759 0000134C 8A07                     mov al, [bx]
  3760 0000134E B400                     mov ah, 0
  3761 00001350 08C0                     or  al, al
  3762 00001352 0F843000                 je .toupper164
  3763                                  
  3764                                  ;-94         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3765                                  
  3766 00001356 8B5E04                   mov bx, [bp+4]
  3767 00001359 8A07                     mov al, [bx]
  3768 0000135B B400                     mov ah, 0
  3769 0000135D 83F861                   cmp ax, 97 ;unsigned : 1
  3770 00001360 0F8C1D00                 jl  .toupper165
  3771 00001364 8B5E04                   mov bx, [bp+4]
  3772 00001367 8A07                     mov al, [bx]
  3773 00001369 B400                     mov ah, 0
  3774 0000136B 83F87A                   cmp ax, 122
  3775 0000136E 0F8F0F00                 jg  .toupper166
  3776 00001372 8B5E04                   mov bx, [bp+4]
  3777 00001375 8A07                     mov al, [bx]
  3778 00001377 B400                     mov ah, 0
  3779 00001379 83E820                   sub ax, 32
  3780 0000137C 8B5E04                   mov  bx, [bp+4]
  3781 0000137F 8807                     mov  [bx], al
  3782                                  
  3783                                  ;-95             s++;
  3784                                  
  3785                                  .toupper166:
  3786                                  .toupper165:
  3787 00001381 FF4604                   inc  word[bp+4]
  3788                                  
  3789                                  ;-96               }
  3790                                  
  3791                                  
  3792                                  ;-97     }
  3793                                  
  3794 00001384 EBC3                     jmp .toupper163
  3795                                  .toupper164:
  3796                                  
  3797                                  ;-98 
  3798                                  
  3799                                  
  3800                                  ;-99 int getDigit(unsigned char c) {//ret: SymbolInt
  3801 00001386 C9                       LEAVE
  3802 00001387 C3                       ret
  3803                                  ENDP
  3804                                  
  3805                                  getDigit: PROC
  3806                                  
  3807                                  ;-100   unsigned int CastInt;
  3808                                  
  3809                                  
  3810                                  ;-101   SymbolInt=0;
  3811                                  
  3812                                  ;Function : getDigit, Number of local variables: 2
  3813                                  ;   # type sign width addr used name   list of local variables
  3814                                  ;  200 var unsg byte    99 NULL c = bp+4
  3815                                  ;  201 var unsg word   100 NULL CastInt = bp-2;
  3816 00001388 C8020000                 ENTER  2,0
  3817 0000138C B80000                   mov ax, 0
  3818 0000138F A3[0F00]                 mov word [SymbolInt], ax
  3819                                  
  3820                                  ;-102   do {
  3821                                  
  3822                                  .getDigit167:
  3823                                  
  3824                                  ;-103     c-='0';
  3825                                  
  3826 00001392 806E0430                 sub  byte[bp+4], 48
  3827                                  
  3828                                  ;-104     SymbolInt=SymbolInt*10;
  3829                                  
  3830 00001396 A1[0F00]                 mov ax, [SymbolInt]
  3831 00001399 BB0A00                   mov bx, 10
  3832 0000139C F7E3                     mul bx
  3833 0000139E A3[0F00]                 mov word [SymbolInt], ax
  3834                                  
  3835                                  ;-105     ax=0; CastInt=c; //cast b2w
  3836                                  
  3837 000013A1 B80000                   mov  ax, 0
  3838 000013A4 8A4604                   mov al, [bp+4]
  3839 000013A7 8946FE                   mov [bp-2], ax
  3840                                  
  3841                                  ;-106     SymbolInt=SymbolInt+CastInt;
  3842                                  
  3843 000013AA A1[0F00]                 mov ax, [SymbolInt]
  3844 000013AD 0346FE                   add ax, [bp-2]
  3845 000013B0 A3[0F00]                 mov word [SymbolInt], ax
  3846                                  
  3847                                  ;-107     InputPtr++;
  3848                                  
  3849 000013B3 FF06[1500]               inc  word[InputPtr]
  3850                                  
  3851                                  ;-108     c = *InputPtr;
  3852                                  
  3853 000013B7 8B1E[1500]               mov bx, [InputPtr]
  3854 000013BB 8A07                     mov al, [bx]
  3855 000013BD B400                     mov ah, 0
  3856 000013BF 884604                   mov [bp+4], al
  3857                                  
  3858                                  ;-109   } while(digit(c));
  3859                                  
  3860 000013C2 8A4604                   mov al, byte [bp+4]
  3861 000013C5 B400                     mov ah, 0
  3862 000013C7 50                       push ax
  3863 000013C8 E881FE                   call digit
  3864 000013CB 83C402                   add  sp, 2
  3865 000013CE 08C0                     or  al, al
  3866 000013D0 0F840200                 je .getDigit168
  3867 000013D4 EBBC                     jmp .getDigit167
  3868                                  .getDigit168:
  3869                                  
  3870                                  ;-110 }
  3871                                  
  3872                                  
  3873                                  ;-111 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3874 000013D6 C9                       LEAVE
  3875 000013D7 C3                       ret
  3876                                  ENDP
  3877                                  
  3878                                  getName: PROC
  3879                                  
  3880                                  ;-112   char *p; unsigned int i;
  3881                                  
  3882                                  
  3883                                  ;-113   p = &Symbol;
  3884                                  
  3885                                  ;Function : getName, Number of local variables: 3
  3886                                  ;   # type sign width addr used name   list of local variables
  3887                                  ;  200 var unsg byte   111 NULL c = bp+4
  3888                                  ;  201 ptr sign byte   112 NULL p = bp-2
  3889                                  ;  202 var unsg word   112 NULL i = bp-4;
  3890 000013D8 C8040000                 ENTER  4,0
  3891 000013DC B83075                   mov ax, Symbol
  3892 000013DF 8946FE                   mov [bp-2], ax
  3893                                  
  3894                                  ;-114   *p = c;
  3895                                  
  3896 000013E2 8A4604                   mov al, [bp+4]
  3897 000013E5 8B5EFE                   mov  bx, [bp-2]
  3898 000013E8 8807                     mov  [bx], al
  3899                                  
  3900                                  ;-115   p++;
  3901                                  
  3902 000013EA FF46FE                   inc  word[bp-2]
  3903                                  
  3904                                  ;-116   while (alnumE(c)) {
  3905                                  
  3906                                  .getName169:
  3907 000013ED 8A4604                   mov al, byte [bp+4]
  3908 000013F0 B400                     mov ah, 0
  3909 000013F2 50                       push ax
  3910 000013F3 E81AFE                   call alnumE
  3911 000013F6 83C402                   add  sp, 2
  3912 000013F9 08C0                     or  al, al
  3913 000013FB 0F843800                 je .getName170
  3914                                  
  3915                                  ;-117     InputPtr++;
  3916                                  
  3917 000013FF FF06[1500]               inc  word[InputPtr]
  3918                                  
  3919                                  ;-118     c = *InputPtr;
  3920                                  
  3921 00001403 8B1E[1500]               mov bx, [InputPtr]
  3922 00001407 8A07                     mov al, [bx]
  3923 00001409 B400                     mov ah, 0
  3924 0000140B 884604                   mov [bp+4], al
  3925                                  
  3926                                  ;-119     *p = c;
  3927                                  
  3928 0000140E 8A4604                   mov al, [bp+4]
  3929 00001411 8B5EFE                   mov  bx, [bp-2]
  3930 00001414 8807                     mov  [bx], al
  3931                                  
  3932                                  ;-120     p++;
  3933                                  
  3934 00001416 FF46FE                   inc  word[bp-2]
  3935                                  
  3936                                  ;-121     i = p - &Symbol;
  3937                                  
  3938 00001419 8B46FE                   mov ax, [bp-2]
  3939 0000141C 2D3075                   sub ax, Symbol
  3940 0000141F 8946FC                   mov [bp-4], ax
  3941                                  
  3942                                  ;-122     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3943                                  
  3944 00001422 8B46FC                   mov ax, [bp-4]
  3945 00001425 83F81F                   cmp ax, 31 ;unsigned : 0
  3946 00001428 0F820900                 jb  .getName171
  3947 0000142C 68[7714]                 push getName_0
  3948 0000142F E8D406                   call errorexit
  3949 00001432 83C402                   add  sp, 2
  3950                                  
  3951                                  ;-123   }
  3952                                  
  3953                                  .getName171:
  3954                                  
  3955                                  ;-124   if (c == ':') isLabel=1; else isLabel=0;
  3956                                  
  3957 00001435 EBB6                     jmp .getName169
  3958                                  .getName170:
  3959 00001437 8A4604                   mov al, [bp+4]
  3960 0000143A 3C3A                     cmp al, 58
  3961 0000143C 0F850900                 jne .getName172
  3962 00001440 B80100                   mov ax, 1
  3963 00001443 A2[2C00]                 mov byte [isLabel], al
  3964 00001446 E90600                   jmp .getName173
  3965                                  .getName172:
  3966 00001449 B80000                   mov ax, 0
  3967 0000144C A2[2C00]                 mov byte [isLabel], al
  3968                                  
  3969                                  ;-125   p--;
  3970                                  
  3971                                  .getName173:
  3972 0000144F FF4EFE                   dec  word[bp-2]
  3973                                  
  3974                                  ;-126   *p = 0;
  3975                                  
  3976 00001452 B80000                   mov ax, 0
  3977 00001455 8B5EFE                   mov  bx, [bp-2]
  3978 00001458 8807                     mov  [bx], al
  3979                                  
  3980                                  ;-127   strcpy(SymbolUpper, Symbol);
  3981                                  
  3982 0000145A 8D063075                 lea  ax, [Symbol]
  3983 0000145E 50                       push ax
  3984 0000145F 8D064F75                 lea  ax, [SymbolUpper]
  3985 00001463 50                       push ax
  3986 00001464 E837FE                   call strcpy
  3987 00001467 83C404                   add  sp, 4
  3988                                  
  3989                                  ;-128   toupper(SymbolUpper);
  3990                                  
  3991 0000146A 8D064F75                 lea  ax, [SymbolUpper]
  3992 0000146E 50                       push ax
  3993 0000146F E8D3FE                   call toupper
  3994 00001472 83C402                   add  sp, 2
  3995                                  
  3996                                  ;-129 }
  3997                                  
  3998                                  
  3999                                  ;-130 int testReg() {
  4000 00001475 C9                       LEAVE
  4001 00001476 C3                       ret
  4002 00001477 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4003 00001480 6F206C6F6E6700     
  4004                                  ENDP
  4005                                  
  4006                                  testReg: PROC
  4007                                  
  4008                                  ;-131 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4009                                  
  4010                                  
  4011                                  ;-132   R2Type=0;
  4012                                  
  4013 00001487 B80000                   mov ax, 0
  4014 0000148A A2[3600]                 mov byte [R2Type], al
  4015                                  
  4016                                  ;-133   if (strlen(Symbol) < 2) return 0;
  4017                                  
  4018 0000148D 8D063075                 lea  ax, [Symbol]
  4019 00001491 50                       push ax
  4020 00001492 E8E1FD                   call strlen
  4021 00001495 83C402                   add  sp, 2
  4022 00001498 3C02                     cmp al, 2
  4023 0000149A 0F8D0600                 jge .testReg174
  4024 0000149E B80000                   mov ax, 0
  4025 000014A1 E94703                   jmp .retntestReg
  4026                                  
  4027                                  ;-134   if (strlen(Symbol) > 3) return 0;
  4028                                  
  4029                                  .testReg174:
  4030 000014A4 8D063075                 lea  ax, [Symbol]
  4031 000014A8 50                       push ax
  4032 000014A9 E8CAFD                   call strlen
  4033 000014AC 83C402                   add  sp, 2
  4034 000014AF 3C03                     cmp al, 3
  4035 000014B1 0F8E0600                 jle .testReg175
  4036 000014B5 B80000                   mov ax, 0
  4037 000014B8 E93003                   jmp .retntestReg
  4038                                  
  4039                                  ;-135   R2Type=BYTE;
  4040                                  
  4041                                  .testReg175:
  4042 000014BB B80100                   mov ax, 1
  4043 000014BE A2[3600]                 mov byte [R2Type], al
  4044                                  
  4045                                  ;-136   if (eqstr(SymbolUpper, "AL")) return 0;
  4046                                  
  4047 000014C1 68[EC17]                 push testReg_0
  4048 000014C4 8D064F75                 lea  ax, [SymbolUpper]
  4049 000014C8 50                       push ax
  4050 000014C9 E808FE                   call eqstr
  4051 000014CC 83C404                   add  sp, 4
  4052 000014CF 08C0                     or  al, al
  4053 000014D1 0F840600                 je .testReg176
  4054 000014D5 B80000                   mov ax, 0
  4055 000014D8 E91003                   jmp .retntestReg
  4056                                  
  4057                                  ;-137   if (eqstr(SymbolUpper, "CL")) return 1;
  4058                                  
  4059                                  .testReg176:
  4060 000014DB 68[EF17]                 push testReg_1
  4061 000014DE 8D064F75                 lea  ax, [SymbolUpper]
  4062 000014E2 50                       push ax
  4063 000014E3 E8EEFD                   call eqstr
  4064 000014E6 83C404                   add  sp, 4
  4065 000014E9 08C0                     or  al, al
  4066 000014EB 0F840600                 je .testReg177
  4067 000014EF B80100                   mov ax, 1
  4068 000014F2 E9F602                   jmp .retntestReg
  4069                                  
  4070                                  ;-138   if (eqstr(SymbolUpper, "DL")) return 2;
  4071                                  
  4072                                  .testReg177:
  4073 000014F5 68[F217]                 push testReg_2
  4074 000014F8 8D064F75                 lea  ax, [SymbolUpper]
  4075 000014FC 50                       push ax
  4076 000014FD E8D4FD                   call eqstr
  4077 00001500 83C404                   add  sp, 4
  4078 00001503 08C0                     or  al, al
  4079 00001505 0F840600                 je .testReg178
  4080 00001509 B80200                   mov ax, 2
  4081 0000150C E9DC02                   jmp .retntestReg
  4082                                  
  4083                                  ;-139   if (eqstr(SymbolUpper, "BL")) return 3;
  4084                                  
  4085                                  .testReg178:
  4086 0000150F 68[F517]                 push testReg_3
  4087 00001512 8D064F75                 lea  ax, [SymbolUpper]
  4088 00001516 50                       push ax
  4089 00001517 E8BAFD                   call eqstr
  4090 0000151A 83C404                   add  sp, 4
  4091 0000151D 08C0                     or  al, al
  4092 0000151F 0F840600                 je .testReg179
  4093 00001523 B80300                   mov ax, 3
  4094 00001526 E9C202                   jmp .retntestReg
  4095                                  
  4096                                  ;-140   if (eqstr(SymbolUpper, "AH")) return 4;
  4097                                  
  4098                                  .testReg179:
  4099 00001529 68[F817]                 push testReg_4
  4100 0000152C 8D064F75                 lea  ax, [SymbolUpper]
  4101 00001530 50                       push ax
  4102 00001531 E8A0FD                   call eqstr
  4103 00001534 83C404                   add  sp, 4
  4104 00001537 08C0                     or  al, al
  4105 00001539 0F840600                 je .testReg180
  4106 0000153D B80400                   mov ax, 4
  4107 00001540 E9A802                   jmp .retntestReg
  4108                                  
  4109                                  ;-141   if (eqstr(SymbolUpper, "CH")) return 5;
  4110                                  
  4111                                  .testReg180:
  4112 00001543 68[FB17]                 push testReg_5
  4113 00001546 8D064F75                 lea  ax, [SymbolUpper]
  4114 0000154A 50                       push ax
  4115 0000154B E886FD                   call eqstr
  4116 0000154E 83C404                   add  sp, 4
  4117 00001551 08C0                     or  al, al
  4118 00001553 0F840600                 je .testReg181
  4119 00001557 B80500                   mov ax, 5
  4120 0000155A E98E02                   jmp .retntestReg
  4121                                  
  4122                                  ;-142   if (eqstr(SymbolUpper, "DH")) return 6;
  4123                                  
  4124                                  .testReg181:
  4125 0000155D 68[FE17]                 push testReg_6
  4126 00001560 8D064F75                 lea  ax, [SymbolUpper]
  4127 00001564 50                       push ax
  4128 00001565 E86CFD                   call eqstr
  4129 00001568 83C404                   add  sp, 4
  4130 0000156B 08C0                     or  al, al
  4131 0000156D 0F840600                 je .testReg182
  4132 00001571 B80600                   mov ax, 6
  4133 00001574 E97402                   jmp .retntestReg
  4134                                  
  4135                                  ;-143   if (eqstr(SymbolUpper, "BH")) return 7;
  4136                                  
  4137                                  .testReg182:
  4138 00001577 68[0118]                 push testReg_7
  4139 0000157A 8D064F75                 lea  ax, [SymbolUpper]
  4140 0000157E 50                       push ax
  4141 0000157F E852FD                   call eqstr
  4142 00001582 83C404                   add  sp, 4
  4143 00001585 08C0                     or  al, al
  4144 00001587 0F840600                 je .testReg183
  4145 0000158B B80700                   mov ax, 7
  4146 0000158E E95A02                   jmp .retntestReg
  4147                                  
  4148                                  ;-144   R2Type=WORD;
  4149                                  
  4150                                  .testReg183:
  4151 00001591 B80200                   mov ax, 2
  4152 00001594 A2[3600]                 mov byte [R2Type], al
  4153                                  
  4154                                  ;-145   if (eqstr(SymbolUpper, "AX")) return 0;
  4155                                  
  4156 00001597 68[0418]                 push testReg_8
  4157 0000159A 8D064F75                 lea  ax, [SymbolUpper]
  4158 0000159E 50                       push ax
  4159 0000159F E832FD                   call eqstr
  4160 000015A2 83C404                   add  sp, 4
  4161 000015A5 08C0                     or  al, al
  4162 000015A7 0F840600                 je .testReg184
  4163 000015AB B80000                   mov ax, 0
  4164 000015AE E93A02                   jmp .retntestReg
  4165                                  
  4166                                  ;-146   if (eqstr(SymbolUpper, "CX")) return 1;
  4167                                  
  4168                                  .testReg184:
  4169 000015B1 68[0718]                 push testReg_9
  4170 000015B4 8D064F75                 lea  ax, [SymbolUpper]
  4171 000015B8 50                       push ax
  4172 000015B9 E818FD                   call eqstr
  4173 000015BC 83C404                   add  sp, 4
  4174 000015BF 08C0                     or  al, al
  4175 000015C1 0F840600                 je .testReg185
  4176 000015C5 B80100                   mov ax, 1
  4177 000015C8 E92002                   jmp .retntestReg
  4178                                  
  4179                                  ;-147   if (eqstr(SymbolUpper, "DX")) return 2;
  4180                                  
  4181                                  .testReg185:
  4182 000015CB 68[0A18]                 push testReg_10
  4183 000015CE 8D064F75                 lea  ax, [SymbolUpper]
  4184 000015D2 50                       push ax
  4185 000015D3 E8FEFC                   call eqstr
  4186 000015D6 83C404                   add  sp, 4
  4187 000015D9 08C0                     or  al, al
  4188 000015DB 0F840600                 je .testReg186
  4189 000015DF B80200                   mov ax, 2
  4190 000015E2 E90602                   jmp .retntestReg
  4191                                  
  4192                                  ;-148   if (eqstr(SymbolUpper, "BX")) return 3;
  4193                                  
  4194                                  .testReg186:
  4195 000015E5 68[0D18]                 push testReg_11
  4196 000015E8 8D064F75                 lea  ax, [SymbolUpper]
  4197 000015EC 50                       push ax
  4198 000015ED E8E4FC                   call eqstr
  4199 000015F0 83C404                   add  sp, 4
  4200 000015F3 08C0                     or  al, al
  4201 000015F5 0F840600                 je .testReg187
  4202 000015F9 B80300                   mov ax, 3
  4203 000015FC E9EC01                   jmp .retntestReg
  4204                                  
  4205                                  ;-149   if (eqstr(SymbolUpper, "SP")) return 4;
  4206                                  
  4207                                  .testReg187:
  4208 000015FF 68[1018]                 push testReg_12
  4209 00001602 8D064F75                 lea  ax, [SymbolUpper]
  4210 00001606 50                       push ax
  4211 00001607 E8CAFC                   call eqstr
  4212 0000160A 83C404                   add  sp, 4
  4213 0000160D 08C0                     or  al, al
  4214 0000160F 0F840600                 je .testReg188
  4215 00001613 B80400                   mov ax, 4
  4216 00001616 E9D201                   jmp .retntestReg
  4217                                  
  4218                                  ;-150   if (eqstr(SymbolUpper, "BP")) return 5;
  4219                                  
  4220                                  .testReg188:
  4221 00001619 68[1318]                 push testReg_13
  4222 0000161C 8D064F75                 lea  ax, [SymbolUpper]
  4223 00001620 50                       push ax
  4224 00001621 E8B0FC                   call eqstr
  4225 00001624 83C404                   add  sp, 4
  4226 00001627 08C0                     or  al, al
  4227 00001629 0F840600                 je .testReg189
  4228 0000162D B80500                   mov ax, 5
  4229 00001630 E9B801                   jmp .retntestReg
  4230                                  
  4231                                  ;-151   if (eqstr(SymbolUpper, "SI")) return 6;
  4232                                  
  4233                                  .testReg189:
  4234 00001633 68[1618]                 push testReg_14
  4235 00001636 8D064F75                 lea  ax, [SymbolUpper]
  4236 0000163A 50                       push ax
  4237 0000163B E896FC                   call eqstr
  4238 0000163E 83C404                   add  sp, 4
  4239 00001641 08C0                     or  al, al
  4240 00001643 0F840600                 je .testReg190
  4241 00001647 B80600                   mov ax, 6
  4242 0000164A E99E01                   jmp .retntestReg
  4243                                  
  4244                                  ;-152   if (eqstr(SymbolUpper, "DI")) return 7;
  4245                                  
  4246                                  .testReg190:
  4247 0000164D 68[1918]                 push testReg_15
  4248 00001650 8D064F75                 lea  ax, [SymbolUpper]
  4249 00001654 50                       push ax
  4250 00001655 E87CFC                   call eqstr
  4251 00001658 83C404                   add  sp, 4
  4252 0000165B 08C0                     or  al, al
  4253 0000165D 0F840600                 je .testReg191
  4254 00001661 B80700                   mov ax, 7
  4255 00001664 E98401                   jmp .retntestReg
  4256                                  
  4257                                  ;-153   R2Type=SEGREG;
  4258                                  
  4259                                  .testReg191:
  4260 00001667 B80400                   mov ax, 4
  4261 0000166A A2[3600]                 mov byte [R2Type], al
  4262                                  
  4263                                  ;-154   if (eqstr(SymbolUpper, "ES")) return 0;
  4264                                  
  4265 0000166D 68[1C18]                 push testReg_16
  4266 00001670 8D064F75                 lea  ax, [SymbolUpper]
  4267 00001674 50                       push ax
  4268 00001675 E85CFC                   call eqstr
  4269 00001678 83C404                   add  sp, 4
  4270 0000167B 08C0                     or  al, al
  4271 0000167D 0F840600                 je .testReg192
  4272 00001681 B80000                   mov ax, 0
  4273 00001684 E96401                   jmp .retntestReg
  4274                                  
  4275                                  ;-155   if (eqstr(SymbolUpper, "CS")) return 1;
  4276                                  
  4277                                  .testReg192:
  4278 00001687 68[1F18]                 push testReg_17
  4279 0000168A 8D064F75                 lea  ax, [SymbolUpper]
  4280 0000168E 50                       push ax
  4281 0000168F E842FC                   call eqstr
  4282 00001692 83C404                   add  sp, 4
  4283 00001695 08C0                     or  al, al
  4284 00001697 0F840600                 je .testReg193
  4285 0000169B B80100                   mov ax, 1
  4286 0000169E E94A01                   jmp .retntestReg
  4287                                  
  4288                                  ;-156   if (eqstr(SymbolUpper, "SS")) return 2;
  4289                                  
  4290                                  .testReg193:
  4291 000016A1 68[2218]                 push testReg_18
  4292 000016A4 8D064F75                 lea  ax, [SymbolUpper]
  4293 000016A8 50                       push ax
  4294 000016A9 E828FC                   call eqstr
  4295 000016AC 83C404                   add  sp, 4
  4296 000016AF 08C0                     or  al, al
  4297 000016B1 0F840600                 je .testReg194
  4298 000016B5 B80200                   mov ax, 2
  4299 000016B8 E93001                   jmp .retntestReg
  4300                                  
  4301                                  ;-157   if (eqstr(SymbolUpper, "DS")) return 3;
  4302                                  
  4303                                  .testReg194:
  4304 000016BB 68[2518]                 push testReg_19
  4305 000016BE 8D064F75                 lea  ax, [SymbolUpper]
  4306 000016C2 50                       push ax
  4307 000016C3 E80EFC                   call eqstr
  4308 000016C6 83C404                   add  sp, 4
  4309 000016C9 08C0                     or  al, al
  4310 000016CB 0F840600                 je .testReg195
  4311 000016CF B80300                   mov ax, 3
  4312 000016D2 E91601                   jmp .retntestReg
  4313                                  
  4314                                  ;-158   if (eqstr(SymbolUpper, "FS")) return 4;
  4315                                  
  4316                                  .testReg195:
  4317 000016D5 68[2818]                 push testReg_20
  4318 000016D8 8D064F75                 lea  ax, [SymbolUpper]
  4319 000016DC 50                       push ax
  4320 000016DD E8F4FB                   call eqstr
  4321 000016E0 83C404                   add  sp, 4
  4322 000016E3 08C0                     or  al, al
  4323 000016E5 0F840600                 je .testReg196
  4324 000016E9 B80400                   mov ax, 4
  4325 000016EC E9FC00                   jmp .retntestReg
  4326                                  
  4327                                  ;-159   if (eqstr(SymbolUpper, "GS")) return 5;
  4328                                  
  4329                                  .testReg196:
  4330 000016EF 68[2B18]                 push testReg_21
  4331 000016F2 8D064F75                 lea  ax, [SymbolUpper]
  4332 000016F6 50                       push ax
  4333 000016F7 E8DAFB                   call eqstr
  4334 000016FA 83C404                   add  sp, 4
  4335 000016FD 08C0                     or  al, al
  4336 000016FF 0F840600                 je .testReg197
  4337 00001703 B80500                   mov ax, 5
  4338 00001706 E9E200                   jmp .retntestReg
  4339                                  
  4340                                  ;-160   R2Type=DWORD;
  4341                                  
  4342                                  .testReg197:
  4343 00001709 B80300                   mov ax, 3
  4344 0000170C A2[3600]                 mov byte [R2Type], al
  4345                                  
  4346                                  ;-161   if (eqstr(SymbolUpper, "EAX"))return 0;
  4347                                  
  4348 0000170F 68[2E18]                 push testReg_22
  4349 00001712 8D064F75                 lea  ax, [SymbolUpper]
  4350 00001716 50                       push ax
  4351 00001717 E8BAFB                   call eqstr
  4352 0000171A 83C404                   add  sp, 4
  4353 0000171D 08C0                     or  al, al
  4354 0000171F 0F840600                 je .testReg198
  4355 00001723 B80000                   mov ax, 0
  4356 00001726 E9C200                   jmp .retntestReg
  4357                                  
  4358                                  ;-162   if (eqstr(SymbolUpper, "ECX"))return 1;
  4359                                  
  4360                                  .testReg198:
  4361 00001729 68[3218]                 push testReg_23
  4362 0000172C 8D064F75                 lea  ax, [SymbolUpper]
  4363 00001730 50                       push ax
  4364 00001731 E8A0FB                   call eqstr
  4365 00001734 83C404                   add  sp, 4
  4366 00001737 08C0                     or  al, al
  4367 00001739 0F840600                 je .testReg199
  4368 0000173D B80100                   mov ax, 1
  4369 00001740 E9A800                   jmp .retntestReg
  4370                                  
  4371                                  ;-163   if (eqstr(SymbolUpper, "EDX"))return 2;
  4372                                  
  4373                                  .testReg199:
  4374 00001743 68[3618]                 push testReg_24
  4375 00001746 8D064F75                 lea  ax, [SymbolUpper]
  4376 0000174A 50                       push ax
  4377 0000174B E886FB                   call eqstr
  4378 0000174E 83C404                   add  sp, 4
  4379 00001751 08C0                     or  al, al
  4380 00001753 0F840600                 je .testReg200
  4381 00001757 B80200                   mov ax, 2
  4382 0000175A E98E00                   jmp .retntestReg
  4383                                  
  4384                                  ;-164   if (eqstr(SymbolUpper, "EBX"))return 3;
  4385                                  
  4386                                  .testReg200:
  4387 0000175D 68[3A18]                 push testReg_25
  4388 00001760 8D064F75                 lea  ax, [SymbolUpper]
  4389 00001764 50                       push ax
  4390 00001765 E86CFB                   call eqstr
  4391 00001768 83C404                   add  sp, 4
  4392 0000176B 08C0                     or  al, al
  4393 0000176D 0F840600                 je .testReg201
  4394 00001771 B80300                   mov ax, 3
  4395 00001774 E97400                   jmp .retntestReg
  4396                                  
  4397                                  ;-165   if (eqstr(SymbolUpper, "ESP"))return 4;
  4398                                  
  4399                                  .testReg201:
  4400 00001777 68[3E18]                 push testReg_26
  4401 0000177A 8D064F75                 lea  ax, [SymbolUpper]
  4402 0000177E 50                       push ax
  4403 0000177F E852FB                   call eqstr
  4404 00001782 83C404                   add  sp, 4
  4405 00001785 08C0                     or  al, al
  4406 00001787 0F840600                 je .testReg202
  4407 0000178B B80400                   mov ax, 4
  4408 0000178E E95A00                   jmp .retntestReg
  4409                                  
  4410                                  ;-166   if (eqstr(SymbolUpper, "EBP"))return 5;
  4411                                  
  4412                                  .testReg202:
  4413 00001791 68[4218]                 push testReg_27
  4414 00001794 8D064F75                 lea  ax, [SymbolUpper]
  4415 00001798 50                       push ax
  4416 00001799 E838FB                   call eqstr
  4417 0000179C 83C404                   add  sp, 4
  4418 0000179F 08C0                     or  al, al
  4419 000017A1 0F840600                 je .testReg203
  4420 000017A5 B80500                   mov ax, 5
  4421 000017A8 E94000                   jmp .retntestReg
  4422                                  
  4423                                  ;-167   if (eqstr(SymbolUpper, "ESI"))return 6;
  4424                                  
  4425                                  .testReg203:
  4426 000017AB 68[4618]                 push testReg_28
  4427 000017AE 8D064F75                 lea  ax, [SymbolUpper]
  4428 000017B2 50                       push ax
  4429 000017B3 E81EFB                   call eqstr
  4430 000017B6 83C404                   add  sp, 4
  4431 000017B9 08C0                     or  al, al
  4432 000017BB 0F840600                 je .testReg204
  4433 000017BF B80600                   mov ax, 6
  4434 000017C2 E92600                   jmp .retntestReg
  4435                                  
  4436                                  ;-168   if (eqstr(SymbolUpper, "EDI"))return 7;
  4437                                  
  4438                                  .testReg204:
  4439 000017C5 68[4A18]                 push testReg_29
  4440 000017C8 8D064F75                 lea  ax, [SymbolUpper]
  4441 000017CC 50                       push ax
  4442 000017CD E804FB                   call eqstr
  4443 000017D0 83C404                   add  sp, 4
  4444 000017D3 08C0                     or  al, al
  4445 000017D5 0F840600                 je .testReg205
  4446 000017D9 B80700                   mov ax, 7
  4447 000017DC E90C00                   jmp .retntestReg
  4448                                  
  4449                                  ;-169   R2Type=0; return 0;
  4450                                  
  4451                                  .testReg205:
  4452 000017DF B80000                   mov ax, 0
  4453 000017E2 A2[3600]                 mov byte [R2Type], al
  4454 000017E5 B80000                   mov ax, 0
  4455 000017E8 E90000                   jmp .retntestReg
  4456                                  
  4457                                  ;-170 }
  4458                                  
  4459                                   .retntestReg:
  4460 000017EB C3                       ret
  4461 000017EC 414C00                  testReg_0 db "AL",0
  4462 000017EF 434C00                  testReg_1 db "CL",0
  4463 000017F2 444C00                  testReg_2 db "DL",0
  4464 000017F5 424C00                  testReg_3 db "BL",0
  4465 000017F8 414800                  testReg_4 db "AH",0
  4466 000017FB 434800                  testReg_5 db "CH",0
  4467 000017FE 444800                  testReg_6 db "DH",0
  4468 00001801 424800                  testReg_7 db "BH",0
  4469 00001804 415800                  testReg_8 db "AX",0
  4470 00001807 435800                  testReg_9 db "CX",0
  4471 0000180A 445800                  testReg_10 db "DX",0
  4472 0000180D 425800                  testReg_11 db "BX",0
  4473 00001810 535000                  testReg_12 db "SP",0
  4474 00001813 425000                  testReg_13 db "BP",0
  4475 00001816 534900                  testReg_14 db "SI",0
  4476 00001819 444900                  testReg_15 db "DI",0
  4477 0000181C 455300                  testReg_16 db "ES",0
  4478 0000181F 435300                  testReg_17 db "CS",0
  4479 00001822 535300                  testReg_18 db "SS",0
  4480 00001825 445300                  testReg_19 db "DS",0
  4481 00001828 465300                  testReg_20 db "FS",0
  4482 0000182B 475300                  testReg_21 db "GS",0
  4483 0000182E 45415800                testReg_22 db "EAX",0
  4484 00001832 45435800                testReg_23 db "ECX",0
  4485 00001836 45445800                testReg_24 db "EDX",0
  4486 0000183A 45425800                testReg_25 db "EBX",0
  4487 0000183E 45535000                testReg_26 db "ESP",0
  4488 00001842 45425000                testReg_27 db "EBP",0
  4489 00001846 45534900                testReg_28 db "ESI",0
  4490 0000184A 45444900                testReg_29 db "EDI",0
  4491                                  ENDP
  4492                                  ;Back to main program: AS.C
  4493                                  
  4494                                  ;-7 #include "OUTPUT.C"
  4495                                  
  4496                                  ;Use include file: OUTPUT.C
  4497                                  
  4498                                  ;-1 int printLine() {
  4499                                  
  4500                                  
  4501                                  printLine: PROC
  4502                                  
  4503                                  ;-2     int i; char c;
  4504                                  
  4505                                  
  4506                                  ;-3     prs("\n");
  4507                                  
  4508                                  ;Function : printLine, Number of local variables: 2
  4509                                  ;   # type sign width addr used name   list of local variables
  4510                                  ;  200 var sign word     2 NULL i = bp-2
  4511                                  ;  201 var sign byte     2 NULL c = bp-4;
  4512 0000184E C8040000                 ENTER  4,0
  4513 00001852 68[E018]                 push printLine_0
  4514 00001855 E80001                   call prs
  4515 00001858 83C402                   add  sp, 2
  4516                                  
  4517                                  ;-4     printhex16(PCStart);
  4518                                  
  4519 0000185B FF36[2A00]               push word [PCStart]
  4520 0000185F E8DC01                   call printhex16
  4521 00001862 83C402                   add  sp, 2
  4522                                  
  4523                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  4524                                  
  4525 00001865 A1[4200]                 mov ax, [OpPrintIndex]
  4526 00001868 83F800                   cmp ax, 0
  4527 0000186B 0F850C00                 jne .printLine206
  4528 0000186F 68[E318]                 push printLine_1
  4529 00001872 E8E300                   call prs
  4530 00001875 83C402                   add  sp, 2
  4531                                  
  4532                                  ;-6     else {
  4533                                  
  4534 00001878 E94C00                   jmp .printLine207
  4535                                  .printLine206:
  4536                                  
  4537                                  ;-7 //        prc(' ');
  4538                                  
  4539                                  
  4540                                  ;-8         i=0;
  4541                                  
  4542 0000187B B80000                   mov ax, 0
  4543 0000187E 8946FE                   mov [bp-2], ax
  4544                                  
  4545                                  ;-9         do {
  4546                                  
  4547                                  .printLine208:
  4548                                  
  4549                                  ;-10             c=OpPos[i];
  4550                                  
  4551 00001881 8B5EFE                   mov bx, [bp-2]
  4552 00001884 8A875577                 mov al, [OpPos + bx]
  4553 00001888 8846FC                   mov [bp-4], al
  4554                                  
  4555                                  ;-11             prc(' ');
  4556                                  
  4557 0000188B 6A20                     push 32
  4558 0000188D E86700                   call prc
  4559 00001890 83C402                   add  sp, 2
  4560                                  
  4561                                  ;-12             printhex8a(c);
  4562                                  
  4563 00001893 8A46FC                   mov al, byte [bp-4]
  4564 00001896 B400                     mov ah, 0
  4565 00001898 50                       push ax
  4566 00001899 E85001                   call printhex8a
  4567 0000189C 83C402                   add  sp, 2
  4568                                  
  4569                                  ;-13             i++;
  4570                                  
  4571 0000189F FF46FE                   inc  word[bp-2]
  4572                                  
  4573                                  ;-14         } while (i < OpPrintIndex);
  4574                                  
  4575 000018A2 8B46FE                   mov ax, [bp-2]
  4576 000018A5 3B06[4200]               cmp ax, [OpPrintIndex]
  4577 000018A9 0F8D0200                 jge .printLine209
  4578 000018AD EBD2                     jmp .printLine208
  4579                                  .printLine209:
  4580                                  
  4581                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  4582                                  
  4583                                  .printLine210:
  4584 000018AF 8B46FE                   mov ax, [bp-2]
  4585 000018B2 83F805                   cmp ax, 5
  4586 000018B5 0F8D0E00                 jge .printLine211
  4587                                  
  4588                                  ;-16             prs("   ");
  4589                                  
  4590 000018B9 68[F318]                 push printLine_2
  4591 000018BC E89900                   call prs
  4592 000018BF 83C402                   add  sp, 2
  4593                                  
  4594                                  ;-17             i++;
  4595                                  
  4596 000018C2 FF46FE                   inc  word[bp-2]
  4597                                  
  4598                                  ;-18         }
  4599                                  
  4600                                  
  4601                                  ;-19     }
  4602                                  
  4603 000018C5 EBE8                     jmp .printLine210
  4604                                  .printLine211:
  4605                                  
  4606                                  ;-20     prc(PrintRA);
  4607                                  
  4608                                  .printLine207:
  4609 000018C7 A0[4600]                 mov al, byte [PrintRA]
  4610 000018CA B400                     mov ah, 0
  4611 000018CC 50                       push ax
  4612 000018CD E82700                   call prc
  4613 000018D0 83C402                   add  sp, 2
  4614                                  
  4615                                  ;-21     prscomment(InputBuf);
  4616                                  
  4617 000018D3 8D068D75                 lea  ax, [InputBuf]
  4618 000018D7 50                       push ax
  4619 000018D8 E84F00                   call prscomment
  4620 000018DB 83C402                   add  sp, 2
  4621                                  
  4622                                  ;-22 }
  4623                                  
  4624                                  
  4625                                  ;-23 int prc(unsigned char c) {//print char
  4626 000018DE C9                       LEAVE
  4627 000018DF C3                       ret
  4628 000018E0 5C6E00                  printLine_0 db "\n",0
  4629 000018E3 202020202020202020-     printLine_1 db "               ",0
  4630 000018EC 20202020202000     
  4631 000018F3 20202000                printLine_2 db "   ",0
  4632                                  ENDP
  4633                                  
  4634                                  prc: PROC
  4635                                  
  4636                                  ;-24     if (LIST) {
  4637                                  
  4638                                  ;Function : prc, Number of local variables: 1
  4639                                  ;   # type sign width addr used name   list of local variables
  4640                                  ;  200 var unsg byte    23 NULL c = bp+4;
  4641 000018F7 C8000000                 ENTER  0,0
  4642 000018FB A0[0D00]                 mov al, [LIST]
  4643 000018FE 08C0                     or  al, al
  4644 00001900 0F841400                 je .prc212
  4645                                  
  4646                                  ;-25         if ( _ c==10) {
  4647                                   ; constant expression
  4648 00001904 807E040A                cmp byte[bp+4], 10
  4649 00001908 0F850600                 jne .prc213
  4650                                  
  4651                                  ;-26             ax=13;
  4652                                  
  4653 0000190C B80D00                   mov  ax, 13
  4654                                  
  4655                                  ;-27             writetty();
  4656                                  
  4657 0000190F E874F6                   call writetty
  4658                                  
  4659                                  ;-28             }
  4660                                  
  4661                                  
  4662                                  ;-29         al=c;
  4663                                  
  4664                                  .prc213:
  4665 00001912 8A4604                   mov  al, [bp+4]
  4666                                  
  4667                                  ;-30         writetty();
  4668                                  
  4669 00001915 E86EF6                   call writetty
  4670                                  
  4671                                  ;-31         }
  4672                                  
  4673                                  
  4674                                  ;-32     fputcR(c,lst_fd);
  4675                                  
  4676                                  .prc212:
  4677 00001918 FF36[1900]               push word [lst_fd]
  4678 0000191C 8A4604                   mov al, byte [bp+4]
  4679 0000191F B400                     mov ah, 0
  4680 00001921 50                       push ax
  4681 00001922 E80CF7                   call fputcR
  4682 00001925 83C404                   add  sp, 4
  4683                                  
  4684                                  ;-33 }
  4685                                  
  4686                                  
  4687                                  ;-34 
  4688                                  
  4689                                  
  4690                                  ;-35 int prscomment(unsigned char *s) {
  4691 00001928 C9                       LEAVE
  4692 00001929 C3                       ret
  4693                                  ENDP
  4694                                  
  4695                                  prscomment: PROC
  4696                                  
  4697                                  ;-36     unsigned char c;
  4698                                  
  4699                                  
  4700                                  ;-37     while (*s){
  4701                                  
  4702                                  ;Function : prscomment, Number of local variables: 2
  4703                                  ;   # type sign width addr used name   list of local variables
  4704                                  ;  200 ptr unsg byte    35 NULL s = bp+4
  4705                                  ;  201 var unsg byte    36 NULL c = bp-2;
  4706 0000192A C8020000                 ENTER  2,0
  4707                                  .prscomment214:
  4708 0000192E 8B5E04                   mov bx, [bp+4]
  4709 00001931 8A07                     mov al, [bx]
  4710 00001933 B400                     mov ah, 0
  4711 00001935 08C0                     or  al, al
  4712 00001937 0F841B00                 je .prscomment215
  4713                                  
  4714                                  ;-38         c=*s;
  4715                                  
  4716 0000193B 8B5E04                   mov bx, [bp+4]
  4717 0000193E 8A07                     mov al, [bx]
  4718 00001940 B400                     mov ah, 0
  4719 00001942 8846FE                   mov [bp-2], al
  4720                                  
  4721                                  ;-39         prc(c);
  4722                                  
  4723 00001945 8A46FE                   mov al, byte [bp-2]
  4724 00001948 B400                     mov ah, 0
  4725 0000194A 50                       push ax
  4726 0000194B E8A9FF                   call prc
  4727 0000194E 83C402                   add  sp, 2
  4728                                  
  4729                                  ;-40         s++;
  4730                                  
  4731 00001951 FF4604                   inc  word[bp+4]
  4732                                  
  4733                                  ;-41     }
  4734                                  
  4735                                  
  4736                                  ;-42 }
  4737                                  
  4738 00001954 EBD8                     jmp .prscomment214
  4739                                  .prscomment215:
  4740                                  
  4741                                  ;-43 int prs(unsigned char *s) {
  4742 00001956 C9                       LEAVE
  4743 00001957 C3                       ret
  4744                                  ENDP
  4745                                  
  4746                                  prs: PROC
  4747                                  
  4748                                  ;-44     unsigned char c;
  4749                                  
  4750                                  
  4751                                  ;-45     int com;
  4752                                  
  4753                                  
  4754                                  ;-46     com=0;
  4755                                  
  4756                                  ;Function : prs, Number of local variables: 3
  4757                                  ;   # type sign width addr used name   list of local variables
  4758                                  ;  200 ptr unsg byte    43 NULL s = bp+4
  4759                                  ;  201 var unsg byte    44 NULL c = bp-2
  4760                                  ;  202 var sign word    45 NULL com = bp-4;
  4761 00001958 C8040000                 ENTER  4,0
  4762 0000195C B80000                   mov ax, 0
  4763 0000195F 8946FC                   mov [bp-4], ax
  4764                                  
  4765                                  ;-47     while (*s) {
  4766                                  
  4767                                  .prs216:
  4768 00001962 8B5E04                   mov bx, [bp+4]
  4769 00001965 8A07                     mov al, [bx]
  4770 00001967 B400                     mov ah, 0
  4771 00001969 08C0                     or  al, al
  4772 0000196B 0F847B00                 je .prs217
  4773                                  
  4774                                  ;-48         c=*s;
  4775                                  
  4776 0000196F 8B5E04                   mov bx, [bp+4]
  4777 00001972 8A07                     mov al, [bx]
  4778 00001974 B400                     mov ah, 0
  4779 00001976 8846FE                   mov [bp-2], al
  4780                                  
  4781                                  ;-49         if (c==34) {
  4782                                  
  4783 00001979 8A46FE                   mov al, [bp-2]
  4784 0000197C 3C22                     cmp al, 34
  4785 0000197E 0F851800                 jne .prs218
  4786                                  
  4787                                  ;-50             if (com) com=0;
  4788                                  
  4789 00001982 8B46FC                   mov ax, [bp-4]
  4790 00001985 08C0                     or  al, al
  4791 00001987 0F840900                 je .prs219
  4792 0000198B B80000                   mov ax, 0
  4793 0000198E 8946FC                   mov [bp-4], ax
  4794                                  
  4795                                  ;-51                 else com=1;
  4796                                  
  4797 00001991 E90600                   jmp .prs220
  4798                                  .prs219:
  4799 00001994 B80100                   mov ax, 1
  4800 00001997 8946FC                   mov [bp-4], ax
  4801                                  
  4802                                  ;-52         }
  4803                                  
  4804                                  .prs220:
  4805                                  
  4806                                  ;-53         if (c==92) {
  4807                                  
  4808                                  .prs218:
  4809 0000199A 8A46FE                   mov al, [bp-2]
  4810 0000199D 3C5C                     cmp al, 92
  4811 0000199F 0F853500                 jne .prs221
  4812                                  
  4813                                  ;-54             if (com==0) {
  4814                                  
  4815 000019A3 8B46FC                   mov ax, [bp-4]
  4816 000019A6 83F800                   cmp ax, 0
  4817 000019A9 0F852B00                 jne .prs222
  4818                                  
  4819                                  ;-55                 s++;
  4820                                  
  4821 000019AD FF4604                   inc  word[bp+4]
  4822                                  
  4823                                  ;-56                 c=*s;
  4824                                  
  4825 000019B0 8B5E04                   mov bx, [bp+4]
  4826 000019B3 8A07                     mov al, [bx]
  4827 000019B5 B400                     mov ah, 0
  4828 000019B7 8846FE                   mov [bp-2], al
  4829                                  
  4830                                  ;-57                 if (c=='n') c=10;
  4831                                  
  4832 000019BA 8A46FE                   mov al, [bp-2]
  4833 000019BD 3C6E                     cmp al, 110
  4834 000019BF 0F850600                 jne .prs223
  4835 000019C3 B80A00                   mov ax, 10
  4836 000019C6 8846FE                   mov [bp-2], al
  4837                                  
  4838                                  ;-58                 if (c=='t') c= 9;
  4839                                  
  4840                                  .prs223:
  4841 000019C9 8A46FE                   mov al, [bp-2]
  4842 000019CC 3C74                     cmp al, 116
  4843 000019CE 0F850600                 jne .prs224
  4844 000019D2 B80900                   mov ax, 9
  4845 000019D5 8846FE                   mov [bp-2], al
  4846                                  
  4847                                  ;-59             }
  4848                                  
  4849                                  .prs224:
  4850                                  
  4851                                  ;-60         }
  4852                                  
  4853                                  .prs222:
  4854                                  
  4855                                  ;-61         prc(c);
  4856                                  
  4857                                  .prs221:
  4858 000019D8 8A46FE                   mov al, byte [bp-2]
  4859 000019DB B400                     mov ah, 0
  4860 000019DD 50                       push ax
  4861 000019DE E816FF                   call prc
  4862 000019E1 83C402                   add  sp, 2
  4863                                  
  4864                                  ;-62         s++;
  4865                                  
  4866 000019E4 FF4604                   inc  word[bp+4]
  4867                                  
  4868                                  ;-63     }
  4869                                  
  4870                                  
  4871                                  ;-64 }
  4872                                  
  4873 000019E7 E978FF                   jmp .prs216
  4874                                  .prs217:
  4875                                  
  4876                                  ;-65 int printhex8a(unsigned char c) {
  4877 000019EA C9                       LEAVE
  4878 000019EB C3                       ret
  4879                                  ENDP
  4880                                  
  4881                                  printhex8a: PROC
  4882                                  
  4883                                  ;-66     unsigned char nib;
  4884                                  
  4885                                  
  4886                                  ;-67     nib = c >> 4; printhex4(nib);
  4887                                  
  4888                                  ;Function : printhex8a, Number of local variables: 2
  4889                                  ;   # type sign width addr used name   list of local variables
  4890                                  ;  200 var unsg byte    65 NULL c = bp+4
  4891                                  ;  201 var unsg byte    66 NULL nib = bp-2;
  4892 000019EC C8020000                 ENTER  2,0
  4893 000019F0 8A4604                   mov al, [bp+4]
  4894 000019F3 C0E804                   shr al, 4
  4895 000019F6 8846FE                   mov [bp-2], al
  4896 000019F9 8A46FE                   mov al, byte [bp-2]
  4897 000019FC B400                     mov ah, 0
  4898 000019FE 50                       push ax
  4899 000019FF E81900                   call printhex4
  4900 00001A02 83C402                   add  sp, 2
  4901                                  
  4902                                  ;-68     nib = c & 15; printhex4(nib);
  4903                                  
  4904 00001A05 8A4604                   mov al, [bp+4]
  4905 00001A08 240F                     and al, 15
  4906 00001A0A 8846FE                   mov [bp-2], al
  4907 00001A0D 8A46FE                   mov al, byte [bp-2]
  4908 00001A10 B400                     mov ah, 0
  4909 00001A12 50                       push ax
  4910 00001A13 E80500                   call printhex4
  4911 00001A16 83C402                   add  sp, 2
  4912                                  
  4913                                  ;-69 }
  4914                                  
  4915                                  
  4916                                  ;-70 int printhex4(unsigned char c) {
  4917 00001A19 C9                       LEAVE
  4918 00001A1A C3                       ret
  4919                                  ENDP
  4920                                  
  4921                                  printhex4: PROC
  4922                                  
  4923                                  ;-71     c += 48;
  4924                                  
  4925                                  ;Function : printhex4, Number of local variables: 1
  4926                                  ;   # type sign width addr used name   list of local variables
  4927                                  ;  200 var unsg byte    70 NULL c = bp+4;
  4928 00001A1B C8000000                 ENTER  0,0
  4929 00001A1F 80460430                 add  byte[bp+4], 48
  4930                                  
  4931                                  ;-72     if (c > 57) c += 7;
  4932                                  
  4933 00001A23 8A4604                   mov al, [bp+4]
  4934 00001A26 3C39                     cmp al, 57
  4935 00001A28 0F8E0400                 jle .printhex4225
  4936 00001A2C 80460407                 add  byte[bp+4], 7
  4937                                  
  4938                                  ;-73     prc(c);
  4939                                  
  4940                                  .printhex4225:
  4941 00001A30 8A4604                   mov al, byte [bp+4]
  4942 00001A33 B400                     mov ah, 0
  4943 00001A35 50                       push ax
  4944 00001A36 E8BEFE                   call prc
  4945 00001A39 83C402                   add  sp, 2
  4946                                  
  4947                                  ;-74 }
  4948                                  
  4949                                  
  4950                                  ;-75 int printhex16(unsigned int i) {
  4951 00001A3C C9                       LEAVE
  4952 00001A3D C3                       ret
  4953                                  ENDP
  4954                                  
  4955                                  printhex16: PROC
  4956                                  
  4957                                  ;-76     unsigned int half;
  4958                                  
  4959                                  
  4960                                  ;-77     half = i >>  8; printhex8a(half);
  4961                                  
  4962                                  ;Function : printhex16, Number of local variables: 2
  4963                                  ;   # type sign width addr used name   list of local variables
  4964                                  ;  200 var unsg word    75 NULL i = bp+4
  4965                                  ;  201 var unsg word    76 NULL half = bp-2;
  4966 00001A3E C8020000                 ENTER  2,0
  4967 00001A42 8B4604                   mov ax, [bp+4]
  4968 00001A45 C1E808                   shr ax, 8
  4969 00001A48 8946FE                   mov [bp-2], ax
  4970 00001A4B FF76FE                   push word [bp-2]
  4971 00001A4E E89BFF                   call printhex8a
  4972 00001A51 83C402                   add  sp, 2
  4973                                  
  4974                                  ;-78     half = i & 255; printhex8a(half);
  4975                                  
  4976 00001A54 8B4604                   mov ax, [bp+4]
  4977 00001A57 25FF00                   and ax, 255
  4978 00001A5A 8946FE                   mov [bp-2], ax
  4979 00001A5D FF76FE                   push word [bp-2]
  4980 00001A60 E889FF                   call printhex8a
  4981 00001A63 83C402                   add  sp, 2
  4982                                  
  4983                                  ;-79 }
  4984                                  
  4985                                  
  4986                                  ;-80 int printIntU(unsigned int n) {
  4987 00001A66 C9                       LEAVE
  4988 00001A67 C3                       ret
  4989                                  ENDP
  4990                                  
  4991                                  printIntU: PROC
  4992                                  
  4993                                  ;-81     unsigned int e;
  4994                                  
  4995                                  
  4996                                  ;-82     if ( _ n >= 10) {
  4997                                  
  4998                                  ;Function : printIntU, Number of local variables: 2
  4999                                  ;   # type sign width addr used name   list of local variables
  5000                                  ;  200 var unsg word    80 NULL n = bp+4
  5001                                  ;  201 var unsg word    81 NULL e = bp-2;
  5002 00001A68 C8020000                 ENTER  2,0 ; constant expression
  5003 00001A6C 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5004 00001A70 0F821700                 jb  .printIntU226
  5005                                  
  5006                                  ;-83         e=n/10; //DIV
  5007                                  
  5008 00001A74 8B4604                   mov ax, [bp+4]
  5009 00001A77 BB0A00                   mov bx, 10
  5010 00001A7A BA0000                   mov dx, 0
  5011 00001A7D F7F3                     div bx
  5012 00001A7F 8946FE                   mov [bp-2], ax
  5013                                  
  5014                                  ;-84         printIntU(e);
  5015                                  
  5016 00001A82 FF76FE                   push word [bp-2]
  5017 00001A85 E8E0FF                   call printIntU
  5018 00001A88 83C402                   add  sp, 2
  5019                                  
  5020                                  ;-85     }
  5021                                  
  5022                                  
  5023                                  ;-86     n = n % 10; //unsigned mod
  5024                                  
  5025                                  .printIntU226:
  5026 00001A8B 8B4604                   mov ax, [bp+4]
  5027 00001A8E BB0A00                   mov bx, 10
  5028 00001A91 BA0000                   mov dx, 0
  5029 00001A94 F7F3                     div bx
  5030 00001A96 89D0                     mov ax, dx
  5031 00001A98 894604                   mov [bp+4], ax
  5032                                  
  5033                                  ;-87     n += '0';
  5034                                  
  5035 00001A9B 83460430                 add  word[bp+4], 48
  5036                                  
  5037                                  ;-88     prc(n);
  5038                                  
  5039 00001A9F FF7604                   push word [bp+4]
  5040 00001AA2 E852FE                   call prc
  5041 00001AA5 83C402                   add  sp, 2
  5042                                  
  5043                                  ;-89 }
  5044                                  
  5045                                  
  5046                                  ;-90 
  5047                                  
  5048                                  
  5049                                  ;-91 int error1(char *s) {
  5050 00001AA8 C9                       LEAVE
  5051 00001AA9 C3                       ret
  5052                                  ENDP
  5053                                  
  5054                                  error1: PROC
  5055                                  
  5056                                  ;-92     LIST=1;
  5057                                  
  5058                                  ;Function : error1, Number of local variables: 1
  5059                                  ;   # type sign width addr used name   list of local variables
  5060                                  ;  200 ptr sign byte    91 NULL s = bp+4;
  5061 00001AAA C8000000                 ENTER  0,0
  5062 00001AAE B80100                   mov ax, 1
  5063 00001AB1 A2[0D00]                 mov byte [LIST], al
  5064                                  
  5065                                  ;-93     ErrorCount++;
  5066                                  
  5067 00001AB4 FF06[1F00]               inc  word[ErrorCount]
  5068                                  
  5069                                  ;-94     prs("\n;***** next line ERROR: ");
  5070                                  
  5071 00001AB8 68[E01A]                 push error1_0
  5072 00001ABB E89AFE                   call prs
  5073 00001ABE 83C402                   add  sp, 2
  5074                                  
  5075                                  ;-95     prs(s);
  5076                                  
  5077 00001AC1 FF7604                   push word [bp+4]
  5078 00001AC4 E891FE                   call prs
  5079 00001AC7 83C402                   add  sp, 2
  5080                                  
  5081                                  ;-96     prs(", Symbol: ");
  5082                                  
  5083 00001ACA 68[FB1A]                 push error1_1
  5084 00001ACD E888FE                   call prs
  5085 00001AD0 83C402                   add  sp, 2
  5086                                  
  5087                                  ;-97     prs(Symbol);
  5088                                  
  5089 00001AD3 8D063075                 lea  ax, [Symbol]
  5090 00001AD7 50                       push ax
  5091 00001AD8 E87DFE                   call prs
  5092 00001ADB 83C402                   add  sp, 2
  5093                                  
  5094                                  ;-98 }
  5095                                  
  5096                                  
  5097                                  ;-99 int errorexit(char *s) {
  5098 00001ADE C9                       LEAVE
  5099 00001ADF C3                       ret
  5100 00001AE0 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5101 00001AE9 6E657874206C696E65-
  5102 00001AF2 204552524F523A2000 
  5103 00001AFB 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5104 00001B04 2000               
  5105                                  ENDP
  5106                                  
  5107                                  errorexit: PROC
  5108                                  
  5109                                  ;-100     error1(s);
  5110                                  
  5111                                  ;Function : errorexit, Number of local variables: 1
  5112                                  ;   # type sign width addr used name   list of local variables
  5113                                  ;  200 ptr sign byte    99 NULL s = bp+4;
  5114 00001B06 C8000000                 ENTER  0,0
  5115 00001B0A FF7604                   push word [bp+4]
  5116 00001B0D E89AFF                   call error1
  5117 00001B10 83C402                   add  sp, 2
  5118                                  
  5119                                  ;-101     epilog(); 
  5120                                  
  5121 00001B13 E80B05                   call epilog
  5122                                  
  5123                                  ;-102     end1(1);
  5124                                  
  5125 00001B16 6A01                     push 1
  5126 00001B18 E8FE05                   call end1
  5127 00001B1B 83C402                   add  sp, 2
  5128                                  
  5129                                  ;-103 }
  5130                                  
  5131                                  
  5132                                  ;-104 int allowederror() {error1("not allowed here"); }
  5133 00001B1E C9                       LEAVE
  5134 00001B1F C3                       ret
  5135                                  ENDP
  5136                                  
  5137                                  allowederror: PROC
  5138 00001B20 68[2A1B]                 push allowederror_0
  5139 00001B23 E884FF                   call error1
  5140 00001B26 83C402                   add  sp, 2
  5141                                  
  5142                                  ;-105 int addrerror()    {error1("address missing");}
  5143                                  
  5144 00001B29 C3                       ret
  5145 00001B2A 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5146 00001B33 6564206865726500   
  5147                                  ENDP
  5148                                  
  5149                                  addrerror: PROC
  5150 00001B3B 68[451B]                 push addrerror_0
  5151 00001B3E E869FF                   call error1
  5152 00001B41 83C402                   add  sp, 2
  5153                                  
  5154                                  ;-106 int immeerror()    {error1("immediate not allowed here");}
  5155                                  
  5156 00001B44 C3                       ret
  5157 00001B45 61646472657373206D-     addrerror_0 db "address missing",0
  5158 00001B4E 697373696E6700     
  5159                                  ENDP
  5160                                  
  5161                                  immeerror: PROC
  5162 00001B55 68[5F1B]                 push immeerror_0
  5163 00001B58 E84FFF                   call error1
  5164 00001B5B 83C402                   add  sp, 2
  5165                                  
  5166                                  ;-107 int implerror()    {error1("not implemented");}
  5167                                  
  5168 00001B5E C3                       ret
  5169 00001B5F 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5170 00001B68 206E6F7420616C6C6F-
  5171 00001B71 776564206865726500 
  5172                                  ENDP
  5173                                  
  5174                                  implerror: PROC
  5175 00001B7A 68[841B]                 push implerror_0
  5176 00001B7D E82AFF                   call error1
  5177 00001B80 83C402                   add  sp, 2
  5178                                  
  5179                                  ;-108 int indexerror()   {error1("invalid index register");}
  5180                                  
  5181 00001B83 C3                       ret
  5182 00001B84 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5183 00001B8D 6D656E74656400     
  5184                                  ENDP
  5185                                  
  5186                                  indexerror: PROC
  5187 00001B94 68[9E1B]                 push indexerror_0
  5188 00001B97 E810FF                   call error1
  5189 00001B9A 83C402                   add  sp, 2
  5190                                  
  5191                                  ;-109 int invaloperror() {error1("invalid or no operands");}
  5192                                  
  5193 00001B9D C3                       ret
  5194 00001B9E 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5195 00001BA7 6E6465782072656769-
  5196 00001BB0 7374657200         
  5197                                  ENDP
  5198                                  
  5199                                  invaloperror: PROC
  5200 00001BB5 68[BF1B]                 push invaloperror_0
  5201 00001BB8 E8EFFE                   call error1
  5202 00001BBB 83C402                   add  sp, 2
  5203                                  
  5204                                  ;-110 int numbererror()  {error1("number expected");}
  5205                                  
  5206 00001BBE C3                       ret
  5207 00001BBF 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5208 00001BC8 72206E6F206F706572-
  5209 00001BD1 616E647300         
  5210                                  ENDP
  5211                                  
  5212                                  numbererror: PROC
  5213 00001BD6 68[E01B]                 push numbererror_0
  5214 00001BD9 E8CEFE                   call error1
  5215 00001BDC 83C402                   add  sp, 2
  5216                                  
  5217                                  ;-111 int regmemerror()  {error1("only register or memory allowed");}
  5218                                  
  5219 00001BDF C3                       ret
  5220 00001BE0 6E756D626572206578-     numbererror_0 db "number expected",0
  5221 00001BE9 70656374656400     
  5222                                  ENDP
  5223                                  
  5224                                  regmemerror: PROC
  5225 00001BF0 68[FA1B]                 push regmemerror_0
  5226 00001BF3 E8B4FE                   call error1
  5227 00001BF6 83C402                   add  sp, 2
  5228                                  
  5229                                  ;-112 int reg16error()   {error1("only reg16, no segreg allowed");}
  5230                                  
  5231 00001BF9 C3                       ret
  5232 00001BFA 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5233 00001C03 73746572206F72206D-
  5234 00001C0C 656D6F727920616C6C-
  5235 00001C15 6F77656400         
  5236                                  ENDP
  5237                                  
  5238                                  reg16error: PROC
  5239 00001C1A 68[241C]                 push reg16error_0
  5240 00001C1D E88AFE                   call error1
  5241 00001C20 83C402                   add  sp, 2
  5242                                  
  5243                                  ;-113 int segregerror()  {error1("segment register not allowed");}
  5244                                  
  5245 00001C23 C3                       ret
  5246 00001C24 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5247 00001C2D 362C206E6F20736567-
  5248 00001C36 72656720616C6C6F77-
  5249 00001C3F 656400             
  5250                                  ENDP
  5251                                  
  5252                                  segregerror: PROC
  5253 00001C42 68[4C1C]                 push segregerror_0
  5254 00001C45 E862FE                   call error1
  5255 00001C48 83C402                   add  sp, 2
  5256                                  
  5257                                  ;-114 int syntaxerror()  {error1("syntax");}
  5258                                  
  5259 00001C4B C3                       ret
  5260 00001C4C 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5261 00001C55 65676973746572206E-
  5262 00001C5E 6F7420616C6C6F7765-
  5263 00001C67 6400               
  5264                                  ENDP
  5265                                  
  5266                                  syntaxerror: PROC
  5267 00001C69 68[731C]                 push syntaxerror_0
  5268 00001C6C E83BFE                   call error1
  5269 00001C6F 83C402                   add  sp, 2
  5270                                  
  5271                                  ;-115 
  5272                                  
  5273                                  
  5274                                  ;-116 int addrexit()     {errorexit("illegal address");}
  5275                                  
  5276 00001C72 C3                       ret
  5277 00001C73 73796E74617800          syntaxerror_0 db "syntax",0
  5278                                  ENDP
  5279                                  
  5280                                  addrexit: PROC
  5281 00001C7A 68[841C]                 push addrexit_0
  5282 00001C7D E886FE                   call errorexit
  5283 00001C80 83C402                   add  sp, 2
  5284                                  
  5285                                  ;-117 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5286                                  
  5287 00001C83 C3                       ret
  5288 00001C84 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5289 00001C8D 64647265737300     
  5290                                  ENDP
  5291                                  
  5292                                  dataexit: PROC
  5293 00001C94 68[9E1C]                 push dataexit_0
  5294 00001C97 E86CFE                   call errorexit
  5295 00001C9A 83C402                   add  sp, 2
  5296                                  
  5297                                  ;-118 int internexit()   {errorexit("intern compiler error");}
  5298                                  
  5299 00001C9D C3                       ret
  5300 00001C9E 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5301 00001CA7 6F7220524553422C57-
  5302 00001CB0 2C4420657870656374-
  5303 00001CB9 656400             
  5304                                  ENDP
  5305                                  
  5306                                  internexit: PROC
  5307 00001CBC 68[C61C]                 push internexit_0
  5308 00001CBF E844FE                   call errorexit
  5309 00001CC2 83C402                   add  sp, 2
  5310 00001CC5 C3                       ret
  5311 00001CC6 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5312 00001CCF 6D70696C6572206572-
  5313 00001CD8 726F7200           
  5314                                  ENDP
  5315                                  ;Back to main program: AS.C
  5316                                  
  5317                                  ;-8 #include "MAIN.C"
  5318                                  
  5319                                  ;Use include file: MAIN.C
  5320                                  
  5321                                  ;-1 int main() {
  5322                                  
  5323                                  
  5324                                  main: PROC
  5325                                  
  5326                                  ;-2     getarg();
  5327                                  
  5328 00001CDC E80D00                   call getarg
  5329                                  
  5330                                  ;-3     parse();
  5331                                  
  5332 00001CDF E868EC                   call parse
  5333                                  
  5334                                  ;-4     fixJmpCall();
  5335                                  
  5336 00001CE2 E85002                   call fixJmpCall
  5337                                  
  5338                                  ;-5     epilog();
  5339                                  
  5340 00001CE5 E83903                   call epilog
  5341                                  
  5342                                  ;-6     end1();
  5343                                  
  5344 00001CE8 E82E04                   call end1
  5345                                  
  5346                                  ;-7 }
  5347                                  
  5348                                  
  5349                                  ;-8 
  5350                                  
  5351                                  
  5352                                  ;-9 int getarg() {
  5353                                  
  5354 00001CEB C3                       ret
  5355                                  ENDP
  5356                                  
  5357                                  getarg: PROC
  5358                                  
  5359                                  ;-10     int arglen1; int i; char *c;
  5360                                  
  5361                                  
  5362                                  ;-11     arglen1=*arglen;
  5363                                  
  5364                                  ;Function : getarg, Number of local variables: 3
  5365                                  ;   # type sign width addr used name   list of local variables
  5366                                  ;  200 var sign word    10 NULL arglen1 = bp-2
  5367                                  ;  201 var sign word    10 NULL i = bp-4
  5368                                  ;  202 ptr sign byte    10 NULL c = bp-6;
  5369 00001CEC C8060000                 ENTER  6,0
  5370 00001CF0 8B1E[5300]               mov bx, [arglen]
  5371 00001CF4 8A07                     mov al, [bx]
  5372 00001CF6 B400                     mov ah, 0
  5373 00001CF8 8946FE                   mov [bp-2], ax
  5374                                  
  5375                                  ;-12     if (arglen1==0) {
  5376                                  
  5377 00001CFB 8B46FE                   mov ax, [bp-2]
  5378 00001CFE 83F800                   cmp ax, 0
  5379 00001D01 0F851C00                 jne .getarg227
  5380                                  
  5381                                  ;-13         cputs(Version1);
  5382                                  
  5383 00001D05 8D06[0300]               lea  ax, [Version1]
  5384 00001D09 50                       push ax
  5385 00001D0A E89AF2                   call cputs
  5386 00001D0D 83C402                   add  sp, 2
  5387                                  
  5388                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5389                                  
  5390 00001D10 68[A21E]                 push getarg_0
  5391 00001D13 E891F2                   call cputs
  5392 00001D16 83C402                   add  sp, 2
  5393                                  
  5394                                  ;-15         exitR(3);
  5395                                  
  5396 00001D19 6A03                     push 3
  5397 00001D1B E8F0F2                   call exitR
  5398 00001D1E 83C402                   add  sp, 2
  5399                                  
  5400                                  ;-16     }
  5401                                  
  5402                                  
  5403                                  ;-17     i=arglen1+129;
  5404                                  
  5405                                  .getarg227:
  5406 00001D21 8B46FE                   mov ax, [bp-2]
  5407 00001D24 058100                   add ax, 129
  5408 00001D27 8946FC                   mov [bp-4], ax
  5409                                  
  5410                                  ;-18     *i=0;
  5411                                  
  5412 00001D2A B80000                   mov ax, 0
  5413 00001D2D 8B5EFC                   mov  bx, [bp-4]
  5414 00001D30 8907                     mov  [bx], ax
  5415                                  
  5416                                  ;-19     arglen1--;
  5417                                  
  5418 00001D32 FF4EFE                   dec  word[bp-2]
  5419                                  
  5420                                  ;-20     toupper(argv);
  5421                                  
  5422 00001D35 FF36[5500]               push word [argv]
  5423 00001D39 E809F6                   call toupper
  5424 00001D3C 83C402                   add  sp, 2
  5425                                  
  5426                                  ;-21 
  5427                                  
  5428                                  
  5429                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  5430                                  
  5431 00001D3F FF36[5500]               push word [argv]
  5432 00001D43 8D068C76                 lea  ax, [namein]
  5433 00001D47 50                       push ax
  5434 00001D48 E853F5                   call strcpy
  5435 00001D4B 83C404                   add  sp, 4
  5436 00001D4E 68[C71E]                 push getarg_1
  5437 00001D51 8D068C76                 lea  ax, [namein]
  5438 00001D55 50                       push ax
  5439 00001D56 E8C7F5                   call strcat1
  5440 00001D59 83C404                   add  sp, 4
  5441                                  
  5442                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  5443                                  
  5444 00001D5C FF36[5500]               push word [argv]
  5445 00001D60 8D06CF76                 lea  ax, [namelst]
  5446 00001D64 50                       push ax
  5447 00001D65 E836F5                   call strcpy
  5448 00001D68 83C404                   add  sp, 4
  5449 00001D6B 68[CA1E]                 push getarg_2
  5450 00001D6E 8D06CF76                 lea  ax, [namelst]
  5451 00001D72 50                       push ax
  5452 00001D73 E8AAF5                   call strcat1
  5453 00001D76 83C404                   add  sp, 4
  5454                                  
  5455                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  5456                                  
  5457 00001D79 FF36[5500]               push word [argv]
  5458 00001D7D 8D061277                 lea  ax, [namebin]
  5459 00001D81 50                       push ax
  5460 00001D82 E819F5                   call strcpy
  5461 00001D85 83C404                   add  sp, 4
  5462 00001D88 68[CF1E]                 push getarg_3
  5463 00001D8B 8D061277                 lea  ax, [namebin]
  5464 00001D8F 50                       push ax
  5465 00001D90 E88DF5                   call strcat1
  5466 00001D93 83C404                   add  sp, 4
  5467                                  
  5468                                  ;-25 
  5469                                  
  5470                                  
  5471                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  5472                                  
  5473 00001D96 B80100                   mov ax, 1
  5474 00001D99 A2[0D00]                 mov byte [LIST], al
  5475 00001D9C B80000                   mov ax, 0
  5476 00001D9F A3[1D00]                 mov word [DOS_ERR], ax
  5477 00001DA2 B80000                   mov ax, 0
  5478 00001DA5 A3[2400]                 mov word [PC], ax
  5479 00001DA8 B80000                   mov ax, 0
  5480 00001DAB A3[1F00]                 mov word [ErrorCount], ax
  5481                                  
  5482                                  ;-27 
  5483                                  
  5484                                  
  5485                                  ;-28     asm_fd=openR (namein);
  5486                                  
  5487 00001DAE 8D068C76                 lea  ax, [namein]
  5488 00001DB2 50                       push ax
  5489 00001DB3 E828F2                   call openR
  5490 00001DB6 83C402                   add  sp, 2
  5491 00001DB9 A3[1700]                 mov word [asm_fd], ax
  5492                                  
  5493                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5494                                  
  5495 00001DBC A1[1D00]                 mov ax, [DOS_ERR]
  5496 00001DBF 08C0                     or  al, al
  5497 00001DC1 0F841C00                 je .getarg228
  5498 00001DC5 68[D41E]                 push getarg_4
  5499 00001DC8 E8DCF1                   call cputs
  5500 00001DCB 83C402                   add  sp, 2
  5501 00001DCE 8D068C76                 lea  ax, [namein]
  5502 00001DD2 50                       push ax
  5503 00001DD3 E8D1F1                   call cputs
  5504 00001DD6 83C402                   add  sp, 2
  5505 00001DD9 6A01                     push 1
  5506 00001DDB E830F2                   call exitR
  5507 00001DDE 83C402                   add  sp, 2
  5508                                  
  5509                                  ;-30     lst_fd=creatR(namelst);
  5510                                  
  5511                                  .getarg228:
  5512 00001DE1 8D06CF76                 lea  ax, [namelst]
  5513 00001DE5 50                       push ax
  5514 00001DE6 E804F2                   call creatR
  5515 00001DE9 83C402                   add  sp, 2
  5516 00001DEC A3[1900]                 mov word [lst_fd], ax
  5517                                  
  5518                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5519                                  
  5520 00001DEF A1[1D00]                 mov ax, [DOS_ERR]
  5521 00001DF2 08C0                     or  al, al
  5522 00001DF4 0F841C00                 je .getarg229
  5523 00001DF8 68[EA1E]                 push getarg_5
  5524 00001DFB E8A9F1                   call cputs
  5525 00001DFE 83C402                   add  sp, 2
  5526 00001E01 8D06CF76                 lea  ax, [namelst]
  5527 00001E05 50                       push ax
  5528 00001E06 E89EF1                   call cputs
  5529 00001E09 83C402                   add  sp, 2
  5530 00001E0C 6A02                     push 2
  5531 00001E0E E8FDF1                   call exitR
  5532 00001E11 83C402                   add  sp, 2
  5533                                  
  5534                                  ;-32     bin_fd=creatR(namebin);
  5535                                  
  5536                                  .getarg229:
  5537 00001E14 8D061277                 lea  ax, [namebin]
  5538 00001E18 50                       push ax
  5539 00001E19 E8D1F1                   call creatR
  5540 00001E1C 83C402                   add  sp, 2
  5541 00001E1F A3[1B00]                 mov word [bin_fd], ax
  5542                                  
  5543                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5544                                  
  5545 00001E22 A1[1D00]                 mov ax, [DOS_ERR]
  5546 00001E25 08C0                     or  al, al
  5547 00001E27 0F841C00                 je .getarg230
  5548 00001E2B 68[011F]                 push getarg_6
  5549 00001E2E E876F1                   call cputs
  5550 00001E31 83C402                   add  sp, 2
  5551 00001E34 8D061277                 lea  ax, [namebin]
  5552 00001E38 50                       push ax
  5553 00001E39 E86BF1                   call cputs
  5554 00001E3C 83C402                   add  sp, 2
  5555 00001E3F 6A02                     push 2
  5556 00001E41 E8CAF1                   call exitR
  5557 00001E44 83C402                   add  sp, 2
  5558                                  
  5559                                  ;-34 
  5560                                  
  5561                                  
  5562                                  ;-35     prs(";");
  5563                                  
  5564                                  .getarg230:
  5565 00001E47 68[171F]                 push getarg_7
  5566 00001E4A E80BFB                   call prs
  5567 00001E4D 83C402                   add  sp, 2
  5568                                  
  5569                                  ;-36     prs(Version1);
  5570                                  
  5571 00001E50 8D06[0300]               lea  ax, [Version1]
  5572 00001E54 50                       push ax
  5573 00001E55 E800FB                   call prs
  5574 00001E58 83C402                   add  sp, 2
  5575                                  
  5576                                  ;-37     prs(", Source: "); prs(namein);
  5577                                  
  5578 00001E5B 68[191F]                 push getarg_8
  5579 00001E5E E8F7FA                   call prs
  5580 00001E61 83C402                   add  sp, 2
  5581 00001E64 8D068C76                 lea  ax, [namein]
  5582 00001E68 50                       push ax
  5583 00001E69 E8ECFA                   call prs
  5584 00001E6C 83C402                   add  sp, 2
  5585                                  
  5586                                  ;-38     prs(", Output: "); prs(namelst);
  5587                                  
  5588 00001E6F 68[241F]                 push getarg_9
  5589 00001E72 E8E3FA                   call prs
  5590 00001E75 83C402                   add  sp, 2
  5591 00001E78 8D06CF76                 lea  ax, [namelst]
  5592 00001E7C 50                       push ax
  5593 00001E7D E8D8FA                   call prs
  5594 00001E80 83C402                   add  sp, 2
  5595                                  
  5596                                  ;-39     prs(", "); prs(namebin);
  5597                                  
  5598 00001E83 68[2F1F]                 push getarg_10
  5599 00001E86 E8CFFA                   call prs
  5600 00001E89 83C402                   add  sp, 2
  5601 00001E8C 8D061277                 lea  ax, [namebin]
  5602 00001E90 50                       push ax
  5603 00001E91 E8C4FA                   call prs
  5604 00001E94 83C402                   add  sp, 2
  5605                                  
  5606                                  ;-40     prs("\n");
  5607                                  
  5608 00001E97 68[321F]                 push getarg_11
  5609 00001E9A E8BBFA                   call prs
  5610 00001E9D 83C402                   add  sp, 2
  5611                                  
  5612                                  ;-41 }
  5613                                  
  5614                                  
  5615                                  ;-42 
  5616                                  
  5617                                  
  5618                                  ;-43 int fixJmpCall() {
  5619 00001EA0 C9                       LEAVE
  5620 00001EA1 C3                       ret
  5621 00001EA2 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5622 00001EAB 41532E434F4D206669-
  5623 00001EB4 6C656E616D65205B77-
  5624 00001EBD 2F6F202E535D203A20-
  5625 00001EC6 00                 
  5626 00001EC7 2E5300                  getarg_1 db ".S",0
  5627 00001ECA 2E4C535400              getarg_2 db ".LST",0
  5628 00001ECF 2E434F4D00              getarg_3 db ".COM",0
  5629 00001ED4 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5630 00001EDD 6C65206D697373696E-
  5631 00001EE6 673A2000           
  5632 00001EEA 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5633 00001EF3 206E6F742063726561-
  5634 00001EFC 74653A2000         
  5635 00001F01 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5636 00001F0A 6E6F74206372656174-
  5637 00001F13 653A2000           
  5638 00001F17 3B00                    getarg_7 db ";",0
  5639 00001F19 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5640 00001F22 2000               
  5641 00001F24 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5642 00001F2D 2000               
  5643 00001F2F 2C2000                  getarg_10 db ", ",0
  5644 00001F32 5C6E00                  getarg_11 db "\n",0
  5645                                  ENDP
  5646                                  
  5647                                  fixJmpCall: PROC
  5648                                  
  5649                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5650                                  
  5651                                  
  5652                                  ;-45     i=1;
  5653                                  
  5654                                  ;Function : fixJmpCall, Number of local variables: 5
  5655                                  ;   # type sign width addr used name   list of local variables
  5656                                  ;  200 var sign word    44 NULL i = bp-2
  5657                                  ;  201 var unsg word    44 NULL hex = bp-4
  5658                                  ;  202 ptr sign byte    44 NULL p = bp-6
  5659                                  ;  203 var sign word    44 NULL Ix = bp-8
  5660                                  ;  204 var sign byte    44 NULL c = bp-10;
  5661 00001F35 C80A0000                 ENTER  10,0
  5662 00001F39 B80100                   mov ax, 1
  5663 00001F3C 8946FE                   mov [bp-2], ax
  5664                                  
  5665                                  ;-46     prs("\n;END open jmp/call: ");
  5666                                  
  5667 00001F3F 68[FA1F]                 push fixJmpCall_0
  5668 00001F42 E813FA                   call prs
  5669 00001F45 83C402                   add  sp, 2
  5670                                  
  5671                                  ;-47     printIntU(JmpCallMaxIx);
  5672                                  
  5673 00001F48 FF36[4F00]               push word [JmpCallMaxIx]
  5674 00001F4C E819FB                   call printIntU
  5675 00001F4F 83C402                   add  sp, 2
  5676                                  
  5677                                  ;-48     p = &JmpCallNames;
  5678                                  
  5679 00001F52 B8AA8B                   mov ax, JmpCallNames
  5680 00001F55 8946FA                   mov [bp-6], ax
  5681                                  
  5682                                  ;-49     while (i <= JmpCallMaxIx) {
  5683                                  
  5684                                  .fixJmpCall231:
  5685 00001F58 8B46FE                   mov ax, [bp-2]
  5686 00001F5B 3B06[4F00]               cmp ax, [JmpCallMaxIx]
  5687 00001F5F 0F8F9500                 jg  .fixJmpCall232
  5688                                  
  5689                                  ;-50         strcpy(Symbol, p);
  5690                                  
  5691 00001F63 FF76FA                   push word [bp-6]
  5692 00001F66 8D063075                 lea  ax, [Symbol]
  5693 00001F6A 50                       push ax
  5694 00001F6B E830F3                   call strcpy
  5695 00001F6E 83C404                   add  sp, 4
  5696                                  
  5697                                  ;-51         p = strlen(Symbol) + p;
  5698                                  
  5699 00001F71 8D063075                 lea  ax, [Symbol]
  5700 00001F75 50                       push ax
  5701 00001F76 E8FDF2                   call strlen
  5702 00001F79 83C402                   add  sp, 2
  5703 00001F7C 0346FA                   add ax, [bp-6]
  5704 00001F7F 8946FA                   mov [bp-6], ax
  5705                                  
  5706                                  ;-52         p++;
  5707                                  
  5708 00001F82 FF46FA                   inc  word[bp-6]
  5709                                  
  5710                                  ;-53 //        prs(Symbol);
  5711                                  
  5712                                  
  5713                                  ;-54 //        prc(' ');
  5714                                  
  5715                                  
  5716                                  ;-55         hex = JmpCallAddr[i];
  5717                                  
  5718 00001F85 8B5EFE                   mov bx, [bp-2]
  5719 00001F88 D1E3                     shl bx, 1
  5720 00001F8A 8B877A93                 mov ax, [JmpCallAddr + bx]
  5721 00001F8E 8946FC                   mov [bp-4], ax
  5722                                  
  5723                                  ;-56 //        printhex16(hex);
  5724                                  
  5725                                  
  5726                                  ;-57 
  5727                                  
  5728                                  
  5729                                  ;-58         Ix=searchLabel();
  5730                                  
  5731 00001F91 E887EC                   call searchLabel
  5732 00001F94 8946F8                   mov [bp-8], ax
  5733                                  
  5734                                  ;-59         if (Ix == 0) error1("Label not found");
  5735                                  
  5736 00001F97 8B46F8                   mov ax, [bp-8]
  5737 00001F9A 83F800                   cmp ax, 0
  5738 00001F9D 0F850900                 jne .fixJmpCall233
  5739 00001FA1 68[1120]                 push fixJmpCall_1
  5740 00001FA4 E803FB                   call error1
  5741 00001FA7 83C402                   add  sp, 2
  5742                                  
  5743                                  ;-60         disp = LabelAddr[Ix];
  5744                                  
  5745                                  .fixJmpCall233:
  5746 00001FAA 8B5EF8                   mov bx, [bp-8]
  5747 00001FAD D1E3                     shl bx, 1
  5748 00001FAF 8B87FA86                 mov ax, [LabelAddr + bx]
  5749 00001FB3 A3[3E00]                 mov word [disp], ax
  5750                                  
  5751                                  ;-61         disp = disp - hex;
  5752                                  
  5753 00001FB6 A1[3E00]                 mov ax, [disp]
  5754 00001FB9 2B46FC                   sub ax, [bp-4]
  5755 00001FBC A3[3E00]                 mov word [disp], ax
  5756                                  
  5757                                  ;-62         disp = disp - Origin;
  5758                                  
  5759 00001FBF A1[3E00]                 mov ax, [disp]
  5760 00001FC2 2B06[2600]               sub ax, [Origin]
  5761 00001FC6 A3[3E00]                 mov word [disp], ax
  5762                                  
  5763                                  ;-63 //        prs(", ");
  5764                                  
  5765                                  
  5766                                  ;-64 
  5767                                  
  5768                                  
  5769                                  ;-65             hex = hex - 2;//fix at start of word
  5770                                  
  5771 00001FC9 8B46FC                   mov ax, [bp-4]
  5772 00001FCC 83E802                   sub ax, 2
  5773 00001FCF 8946FC                   mov [bp-4], ax
  5774                                  
  5775                                  ;-66             FileBin[hex] = disp;//fix low byte
  5776                                  
  5777 00001FD2 A1[3E00]                 mov ax, [disp]
  5778 00001FD5 8B5EFC                   mov bx, [bp-4]
  5779 00001FD8 88876297                 mov [FileBin+bx], al
  5780                                  
  5781                                  ;-67             hex++;
  5782                                  
  5783 00001FDC FF46FC                   inc  word[bp-4]
  5784                                  
  5785                                  ;-68             disp = disp >> 8;
  5786                                  
  5787 00001FDF A1[3E00]                 mov ax, [disp]
  5788 00001FE2 C1E808                   shr ax, 8
  5789 00001FE5 A3[3E00]                 mov word [disp], ax
  5790                                  
  5791                                  ;-69             FileBin[hex] = disp;
  5792                                  
  5793 00001FE8 A1[3E00]                 mov ax, [disp]
  5794 00001FEB 8B5EFC                   mov bx, [bp-4]
  5795 00001FEE 88876297                 mov [FileBin+bx], al
  5796                                  
  5797                                  ;-70         i++;
  5798                                  
  5799 00001FF2 FF46FE                   inc  word[bp-2]
  5800                                  
  5801                                  ;-71     }
  5802                                  
  5803                                  
  5804                                  ;-72 }
  5805                                  
  5806 00001FF5 E960FF                   jmp .fixJmpCall231
  5807                                  .fixJmpCall232:
  5808                                  
  5809                                  ;-73 
  5810                                  
  5811                                  
  5812                                  ;-74 int epilog() {
  5813 00001FF8 C9                       LEAVE
  5814 00001FF9 C3                       ret
  5815 00001FFA 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5816 00002003 656E206A6D702F6361-
  5817 0000200C 6C6C3A2000         
  5818 00002011 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5819 0000201A 20666F756E6400     
  5820                                  ENDP
  5821                                  
  5822                                  epilog: PROC
  5823                                  
  5824                                  ;-75     unsigned int i; char c;     int j;
  5825                                  
  5826                                  
  5827                                  ;-76     prs("\n Errors: ");
  5828                                  
  5829                                  ;Function : epilog, Number of local variables: 3
  5830                                  ;   # type sign width addr used name   list of local variables
  5831                                  ;  200 var unsg word    75 NULL i = bp-2
  5832                                  ;  201 var sign byte    75 NULL c = bp-4
  5833                                  ;  202 var sign word    75 NULL j = bp-6;
  5834 00002021 C8060000                 ENTER  6,0
  5835 00002025 68[DC20]                 push epilog_0
  5836 00002028 E82DF9                   call prs
  5837 0000202B 83C402                   add  sp, 2
  5838                                  
  5839                                  ;-77     printIntU(ErrorCount);
  5840                                  
  5841 0000202E FF36[1F00]               push word [ErrorCount]
  5842 00002032 E833FA                   call printIntU
  5843 00002035 83C402                   add  sp, 2
  5844                                  
  5845                                  ;-78     if (ErrorCount) prs(" ***ERROR*** ");
  5846                                  
  5847 00002038 A1[1F00]                 mov ax, [ErrorCount]
  5848 0000203B 08C0                     or  al, al
  5849 0000203D 0F840900                 je .epilog234
  5850 00002041 68[E820]                 push epilog_1
  5851 00002044 E811F9                   call prs
  5852 00002047 83C402                   add  sp, 2
  5853                                  
  5854                                  ;-79     prs(", Out: ");
  5855                                  
  5856                                  .epilog234:
  5857 0000204A 68[F620]                 push epilog_2
  5858 0000204D E808F9                   call prs
  5859 00002050 83C402                   add  sp, 2
  5860                                  
  5861                                  ;-80     prs(namelst);
  5862                                  
  5863 00002053 8D06CF76                 lea  ax, [namelst]
  5864 00002057 50                       push ax
  5865 00002058 E8FDF8                   call prs
  5866 0000205B 83C402                   add  sp, 2
  5867                                  
  5868                                  ;-81     prs(", ");
  5869                                  
  5870 0000205E 68[FE20]                 push epilog_3
  5871 00002061 E8F4F8                   call prs
  5872 00002064 83C402                   add  sp, 2
  5873                                  
  5874                                  ;-82     prs(namebin);
  5875                                  
  5876 00002067 8D061277                 lea  ax, [namebin]
  5877 0000206B 50                       push ax
  5878 0000206C E8E9F8                   call prs
  5879 0000206F 83C402                   add  sp, 2
  5880                                  
  5881                                  ;-83     prs("= ");
  5882                                  
  5883 00002072 68[0121]                 push epilog_4
  5884 00002075 E8E0F8                   call prs
  5885 00002078 83C402                   add  sp, 2
  5886                                  
  5887                                  ;-84     printIntU(BinLen);
  5888                                  
  5889 0000207B FF36[5100]               push word [BinLen]
  5890 0000207F E8E6F9                   call printIntU
  5891 00002082 83C402                   add  sp, 2
  5892                                  
  5893                                  ;-85     prs(" bytes.");
  5894                                  
  5895 00002085 68[0421]                 push epilog_5
  5896 00002088 E8CDF8                   call prs
  5897 0000208B 83C402                   add  sp, 2
  5898                                  
  5899                                  ;-86 
  5900                                  
  5901                                  
  5902                                  ;-87     i=0;
  5903                                  
  5904 0000208E B80000                   mov ax, 0
  5905 00002091 8946FE                   mov [bp-2], ax
  5906                                  
  5907                                  ;-88     do {
  5908                                  
  5909                                  .epilog235:
  5910                                  
  5911                                  ;-89         c = FileBin[i];
  5912                                  
  5913 00002094 8B5EFE                   mov bx, [bp-2]
  5914 00002097 8A876297                 mov al, [FileBin + bx]
  5915 0000209B 8846FC                   mov [bp-4], al
  5916                                  
  5917                                  ;-90         fputcR(c, bin_fd);
  5918                                  
  5919 0000209E FF36[1B00]               push word [bin_fd]
  5920 000020A2 8A46FC                   mov al, byte [bp-4]
  5921 000020A5 B400                     mov ah, 0
  5922 000020A7 50                       push ax
  5923 000020A8 E886EF                   call fputcR
  5924 000020AB 83C404                   add  sp, 4
  5925                                  
  5926                                  ;-91 //printhex8a(c); prc(' ');
  5927                                  
  5928                                  
  5929                                  ;-92         i++;
  5930                                  
  5931 000020AE FF46FE                   inc  word[bp-2]
  5932                                  
  5933                                  ;-93     } while (i < BinLen);
  5934                                  
  5935 000020B1 8B46FE                   mov ax, [bp-2]
  5936 000020B4 3B06[5100]               cmp ax, [BinLen]
  5937 000020B8 0F8D0200                 jge .epilog236
  5938 000020BC EBD6                     jmp .epilog235
  5939                                  .epilog236:
  5940                                  
  5941                                  ;-94 
  5942                                  
  5943                                  
  5944                                  ;-95   prs(" Labels: ");
  5945                                  
  5946 000020BE 68[0C21]                 push epilog_6
  5947 000020C1 E894F8                   call prs
  5948 000020C4 83C402                   add  sp, 2
  5949                                  
  5950                                  ;-96   printIntU(LabelMaxIx);
  5951                                  
  5952 000020C7 FF36[4900]               push word [LabelMaxIx]
  5953 000020CB E89AF9                   call printIntU
  5954 000020CE 83C402                   add  sp, 2
  5955                                  
  5956                                  ;-97   prs(". ");
  5957                                  
  5958 000020D1 68[1621]                 push epilog_7
  5959 000020D4 E881F8                   call prs
  5960 000020D7 83C402                   add  sp, 2
  5961                                  
  5962                                  ;-98 /*
  5963                                  
  5964                                  
  5965                                  ;-99   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);
  5966                                  
  5967                                  
  5968                                  ;-100   i= &LabelNames;
  5969                                  
  5970                                  
  5971                                  ;-101   prs(" &LabelNames:"); printIntU(i);
  5972                                  
  5973                                  
  5974                                  ;-102   i=LabelNamePtr-i;
  5975                                  
  5976                                  
  5977                                  ;-103   prs("size: ");
  5978                                  
  5979                                  
  5980                                  ;-104   printIntU(i);
  5981                                  
  5982                                  
  5983                                  ;-105   prs(". >>");
  5984                                  
  5985                                  
  5986                                  ;-106   i= &LabelNames;
  5987                                  
  5988                                  
  5989                                  ;-107   do { c=*i; if (c==0) c=' '; prc(c); i++;
  5990                                  
  5991                                  
  5992                                  ;-108   } while (i < LabelNamePtr); prs("<< \n");
  5993                                  
  5994                                  
  5995                                  ;-109    i = 1;
  5996                                  
  5997                                  
  5998                                  ;-110     LabelNamePtr= &LabelNames;
  5999                                  
  6000                                  
  6001                                  ;-111     do {
  6002                                  
  6003                                  
  6004                                  ;-112       prs(LabelNamePtr); prc(' ');
  6005                                  
  6006                                  
  6007                                  ;-113       j=LabelAddr[i]; printhex16(j); prs(", ");
  6008                                  
  6009                                  
  6010                                  ;-114       j=strlen(LabelNamePtr);//get end of actual name
  6011                                  
  6012                                  
  6013                                  ;-115       LabelNamePtr=LabelNamePtr+j;
  6014                                  
  6015                                  
  6016                                  ;-116       LabelNamePtr++;
  6017                                  
  6018                                  
  6019                                  ;-117       i++;
  6020                                  
  6021                                  
  6022                                  ;-118     } while (i <= LabelMaxIx);
  6023                                  
  6024                                  
  6025                                  ;-119 */    
  6026                                  
  6027                                  
  6028                                  ;-120 }
  6029                                  
  6030                                  
  6031                                  ;-121 
  6032                                  
  6033                                  
  6034                                  ;-122 int end1(int n) {
  6035 000020DA C9                       LEAVE
  6036 000020DB C3                       ret
  6037 000020DC 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6038 000020E5 3A2000             
  6039 000020E8 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6040 000020F1 2A2A2A2000         
  6041 000020F6 2C204F75743A2000        epilog_2 db ", Out: ",0
  6042 000020FE 2C2000                  epilog_3 db ", ",0
  6043 00002101 3D2000                  epilog_4 db "= ",0
  6044 00002104 2062797465732E00        epilog_5 db " bytes.",0
  6045 0000210C 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6046 00002115 00                 
  6047 00002116 2E2000                  epilog_7 db ". ",0
  6048                                  ENDP
  6049                                  
  6050                                  end1: PROC
  6051                                  
  6052                                  ;-123     fcloseR(asm_fd);
  6053                                  
  6054                                  ;Function : end1, Number of local variables: 1
  6055                                  ;   # type sign width addr used name   list of local variables
  6056                                  ;  200 var sign word   122 NULL n = bp+4;
  6057 00002119 C8000000                 ENTER  0,0
  6058 0000211D FF36[1700]               push word [asm_fd]
  6059 00002121 E8DBEE                   call fcloseR
  6060 00002124 83C402                   add  sp, 2
  6061                                  
  6062                                  ;-124     fcloseR(lst_fd);
  6063                                  
  6064 00002127 FF36[1900]               push word [lst_fd]
  6065 0000212B E8D1EE                   call fcloseR
  6066 0000212E 83C402                   add  sp, 2
  6067                                  
  6068                                  ;-125     fcloseR(bin_fd);
  6069                                  
  6070 00002131 FF36[1B00]               push word [bin_fd]
  6071 00002135 E8C7EE                   call fcloseR
  6072 00002138 83C402                   add  sp, 2
  6073                                  
  6074                                  ;-126     exitR(n);
  6075                                  
  6076 0000213B FF7604                   push word [bp+4]
  6077 0000213E E8CDEE                   call exitR
  6078 00002141 83C402                   add  sp, 2
  6079                                  
  6080                                  ;-127 }
  6081 00002144 C9                       LEAVE
  6082 00002145 C3                       ret
  6083                                  ENDP
  6084                                  ;Back to main program: AS.C
  6085                                  
  6086                                  ;-9 #include "GENCODE.C"
  6087                                  
  6088                                  ;Use include file: GENCODE.C
  6089                                  
  6090                                  ;-1 // generate code
  6091                                  
  6092                                  
  6093                                  ;-2 int getCodes() {
  6094                                  
  6095                                  
  6096                                  getCodes: PROC
  6097                                  
  6098                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  6099                                  
  6100 00002146 FF06[4400]               inc  word[OpCodePtr]
  6101 0000214A 8B1E[4400]               mov bx, [OpCodePtr]
  6102 0000214E 8A07                     mov al, [bx]
  6103 00002150 B400                     mov ah, 0
  6104 00002152 A2[3100]                 mov byte [Code1], al
  6105                                  
  6106                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  6107                                  
  6108 00002155 FF06[4400]               inc  word[OpCodePtr]
  6109 00002159 8B1E[4400]               mov bx, [OpCodePtr]
  6110 0000215D 8A07                     mov al, [bx]
  6111 0000215F B400                     mov ah, 0
  6112 00002161 A2[3200]                 mov byte [Code2], al
  6113                                  
  6114                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  6115                                  
  6116 00002164 FF06[4400]               inc  word[OpCodePtr]
  6117 00002168 8B1E[4400]               mov bx, [OpCodePtr]
  6118 0000216C 8A07                     mov al, [bx]
  6119 0000216E B400                     mov ah, 0
  6120 00002170 A2[3300]                 mov byte [Code3], al
  6121                                  
  6122                                  ;-6 }
  6123                                  
  6124                                  
  6125                                  ;-7 int gen66h() {genCode8(0x66);
  6126                                  
  6127 00002173 C3                       ret
  6128                                  ENDP
  6129                                  
  6130                                  gen66h: PROC
  6131 00002174 6A66                     push 102
  6132 00002176 E83B00                   call genCode8
  6133 00002179 83C402                   add  sp, 2
  6134                                  
  6135                                  ;-8 }
  6136                                  
  6137                                  
  6138                                  ;-9 int genCode2(char c, char d) {
  6139                                  
  6140 0000217C C3                       ret
  6141                                  ENDP
  6142                                  
  6143                                  genCode2: PROC
  6144                                  
  6145                                  ;-10     c = c + d;
  6146                                  
  6147                                  ;Function : genCode2, Number of local variables: 2
  6148                                  ;   # type sign width addr used name   list of local variables
  6149                                  ;  200 var sign byte     9 NULL c = bp+4
  6150                                  ;  201 var sign byte     9 NULL d = bp+6;
  6151 0000217D C8000000                 ENTER  0,0
  6152 00002181 8A4604                   mov al, [bp+4]
  6153 00002184 024606                   add al, [bp+6]
  6154 00002187 884604                   mov [bp+4], al
  6155                                  
  6156                                  ;-11     genCode8(c);
  6157                                  
  6158 0000218A 8A4604                   mov al, byte [bp+4]
  6159 0000218D B400                     mov ah, 0
  6160 0000218F 50                       push ax
  6161 00002190 E82100                   call genCode8
  6162 00002193 83C402                   add  sp, 2
  6163                                  
  6164                                  ;-12 }                             
  6165                                  
  6166                                  
  6167                                  ;-13 int genCodeW(char c) {
  6168 00002196 C9                       LEAVE
  6169 00002197 C3                       ret
  6170                                  ENDP
  6171                                  
  6172                                  genCodeW: PROC
  6173                                  
  6174                                  ;-14     c = c + wflag;  
  6175                                  
  6176                                  ;Function : genCodeW, Number of local variables: 1
  6177                                  ;   # type sign width addr used name   list of local variables
  6178                                  ;  200 var sign byte    13 NULL c = bp+4;
  6179 00002198 C8000000                 ENTER  0,0
  6180 0000219C 8A4604                   mov al, [bp+4]
  6181 0000219F 0206[3900]               add al, [wflag]
  6182 000021A3 884604                   mov [bp+4], al
  6183                                  
  6184                                  ;-15     genCode8(c);
  6185                                  
  6186 000021A6 8A4604                   mov al, byte [bp+4]
  6187 000021A9 B400                     mov ah, 0
  6188 000021AB 50                       push ax
  6189 000021AC E80500                   call genCode8
  6190 000021AF 83C402                   add  sp, 2
  6191                                  
  6192                                  ;-16 }   
  6193                                  
  6194                                  
  6195                                  ;-17 int genCode8(char c) {
  6196 000021B2 C9                       LEAVE
  6197 000021B3 C3                       ret
  6198                                  ENDP
  6199                                  
  6200                                  genCode8: PROC
  6201                                  
  6202                                  ;-18 //set: BinLen++, OpPrintIndex++
  6203                                  
  6204                                  
  6205                                  ;-19     FileBin[BinLen]=c;
  6206                                  
  6207                                  ;Function : genCode8, Number of local variables: 1
  6208                                  ;   # type sign width addr used name   list of local variables
  6209                                  ;  200 var sign byte    17 NULL c = bp+4;
  6210 000021B4 C8000000                 ENTER  0,0
  6211 000021B8 8A4604                   mov al, [bp+4]
  6212 000021BB 8B1E[5100]               mov bx, [BinLen]
  6213 000021BF 88876297                 mov [FileBin+bx], al
  6214                                  
  6215                                  ;-20     BinLen++;
  6216                                  
  6217 000021C3 FF06[5100]               inc  word[BinLen]
  6218                                  
  6219                                  ;-21     PC++;
  6220                                  
  6221 000021C7 FF06[2400]               inc  word[PC]
  6222                                  
  6223                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6224                                  
  6225 000021CB A1[5100]                 mov ax, [BinLen]
  6226 000021CE 3D204E                   cmp ax, 20000 ;unsigned : 0
  6227 000021D1 0F820900                 jb  .genCode8237
  6228 000021D5 68[F921]                 push genCode8_0
  6229 000021D8 E82BF9                   call errorexit
  6230 000021DB 83C402                   add  sp, 2
  6231                                  
  6232                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  6233                                  
  6234                                  .genCode8237:
  6235 000021DE A1[4200]                 mov ax, [OpPrintIndex]
  6236 000021E1 83F805                   cmp ax, 5
  6237 000021E4 0F8D0F00                 jge .genCode8238
  6238                                  
  6239                                  ;-24         OpPos[OpPrintIndex]=c;
  6240                                  
  6241 000021E8 8A4604                   mov al, [bp+4]
  6242 000021EB 8B1E[4200]               mov bx, [OpPrintIndex]
  6243 000021EF 88875577                 mov [OpPos+bx], al
  6244                                  
  6245                                  ;-25         OpPrintIndex++;
  6246                                  
  6247 000021F3 FF06[4200]               inc  word[OpPrintIndex]
  6248                                  
  6249                                  ;-26     }
  6250                                  
  6251                                  
  6252                                  ;-27 }
  6253                                  
  6254                                  .genCode8238:
  6255                                  
  6256                                  ;-28 int genCode16(unsigned int i) {
  6257 000021F7 C9                       LEAVE
  6258 000021F8 C3                       ret
  6259 000021F9 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6260 00002202 746F6F206C6F6E6700 
  6261                                  ENDP
  6262                                  
  6263                                  genCode16: PROC
  6264                                  
  6265                                  ;-29     genCode8(i); i=i >> 8;
  6266                                  
  6267                                  ;Function : genCode16, Number of local variables: 1
  6268                                  ;   # type sign width addr used name   list of local variables
  6269                                  ;  200 var unsg word    28 NULL i = bp+4;
  6270 0000220B C8000000                 ENTER  0,0
  6271 0000220F FF7604                   push word [bp+4]
  6272 00002212 E89FFF                   call genCode8
  6273 00002215 83C402                   add  sp, 2
  6274 00002218 8B4604                   mov ax, [bp+4]
  6275 0000221B C1E808                   shr ax, 8
  6276 0000221E 894604                   mov [bp+4], ax
  6277                                  
  6278                                  ;-30     genCode8(i);
  6279                                  
  6280 00002221 FF7604                   push word [bp+4]
  6281 00002224 E88DFF                   call genCode8
  6282 00002227 83C402                   add  sp, 2
  6283                                  
  6284                                  ;-31 }
  6285                                  
  6286                                  
  6287                                  ;-32 int genCode32(unsigned long L) {
  6288 0000222A C9                       LEAVE
  6289 0000222B C3                       ret
  6290                                  ENDP
  6291                                  
  6292                                  genCode32: PROC
  6293                                  
  6294                                  ;-33     genCode16(L); L=L >>16;
  6295                                  
  6296                                  ;Function : genCode32, Number of local variables: 1
  6297                                  ;   # type sign width addr used name   list of local variables
  6298                                  ;  200 var unsg dwrd    32 NULL L = bp+4;
  6299 0000222C C8000000                 ENTER  0,0
  6300 00002230 8A4604                   mov al, byte [bp+4]
  6301 00002233 B400                     mov ah, 0
  6302 00002235 50                       push ax
  6303 00002236 E8D2FF                   call genCode16
  6304 00002239 83C402                   add  sp, 2
  6305 0000223C 668B4604                 mov eax, [bp+4]
  6306 00002240 66C1E810                 shr eax, 16
  6307 00002244 66894604                 mov [bp+4], eax
  6308                                  
  6309                                  ;-34     genCode16(L);
  6310                                  
  6311 00002248 8A4604                   mov al, byte [bp+4]
  6312 0000224B B400                     mov ah, 0
  6313 0000224D 50                       push ax
  6314 0000224E E8BAFF                   call genCode16
  6315 00002251 83C402                   add  sp, 2
  6316                                  
  6317                                  ;-35 }
  6318                                  
  6319                                  
  6320                                  ;-36 int writeEA(char xxx) {//value for reg/operand
  6321 00002254 C9                       LEAVE
  6322 00002255 C3                       ret
  6323                                  ENDP
  6324                                  
  6325                                  writeEA: PROC
  6326                                  
  6327                                  ;-37 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6328                                  
  6329                                  
  6330                                  ;-38 //mod-bits: mode76, reg/opcode543, r/m210   
  6331                                  
  6332                                  
  6333                                  ;-39 //Op: 0, IMM, REG, ADR, MEM   
  6334                                  
  6335                                  
  6336                                  ;-40     char len;
  6337                                  
  6338                                  
  6339                                  ;-41     len=0;   
  6340                                  
  6341                                  ;Function : writeEA, Number of local variables: 2
  6342                                  ;   # type sign width addr used name   list of local variables
  6343                                  ;  200 var sign byte    36 NULL xxx = bp+4
  6344                                  ;  201 var sign byte    40 NULL len = bp-2;
  6345 00002256 C8020000                 ENTER  2,0
  6346 0000225A B80000                   mov ax, 0
  6347 0000225D 8846FE                   mov [bp-2], al
  6348                                  
  6349                                  ;-42     xxx = xxx << 3;//in reg/opcode field      
  6350                                  
  6351 00002260 8A4604                   mov al, [bp+4]
  6352 00002263 C0E003                   shl al, 3
  6353 00002266 884604                   mov [bp+4], al
  6354                                  
  6355                                  ;-43     if (Op == REG) {
  6356                                  
  6357 00002269 A0[2E00]                 mov al, [Op]
  6358 0000226C 3C02                     cmp al, 2
  6359 0000226E 0F853A00                 jne .writeEA239
  6360                                  
  6361                                  ;-44         xxx |= 0xC0;     
  6362                                  
  6363 00002272 804E04C0                 or  byte[bp+4], 192
  6364                                  
  6365                                  ;-45         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  6366                                  
  6367 00002276 A0[2F00]                 mov al, [Op2]
  6368 00002279 3C01                     cmp al, 1
  6369 0000227B 0F8F0D00                 jg  .writeEA240
  6370 0000227F 8A4604                   mov al, [bp+4]
  6371 00002282 0206[3500]               add al, [R1No]
  6372 00002286 884604                   mov [bp+4], al
  6373                                  
  6374                                  ;-46             else {
  6375                                  
  6376 00002289 E92000                   jmp .writeEA241
  6377                                  .writeEA240:
  6378                                  
  6379                                  ;-47                 if (Op2 == REG) xxx = xxx + R1No;
  6380                                  
  6381 0000228C A0[2F00]                 mov al, [Op2]
  6382 0000228F 3C02                     cmp al, 2
  6383 00002291 0F850D00                 jne .writeEA242
  6384 00002295 8A4604                   mov al, [bp+4]
  6385 00002298 0206[3500]               add al, [R1No]
  6386 0000229C 884604                   mov [bp+4], al
  6387                                  
  6388                                  ;-48                 else            xxx = xxx + R2No;  
  6389                                  
  6390 0000229F E90A00                   jmp .writeEA243
  6391                                  .writeEA242:
  6392 000022A2 8A4604                   mov al, [bp+4]
  6393 000022A5 0206[3400]               add al, [R2No]
  6394 000022A9 884604                   mov [bp+4], al
  6395                                  
  6396                                  ;-49             }
  6397                                  
  6398                                  .writeEA243:
  6399                                  
  6400                                  ;-50         } 
  6401                                  
  6402                                  .writeEA241:
  6403                                  
  6404                                  ;-51     if (Op == MEM) {
  6405                                  
  6406                                  .writeEA239:
  6407 000022AC A0[2E00]                 mov al, [Op]
  6408 000022AF 3C04                     cmp al, 4
  6409 000022B1 0F857300                 jne .writeEA244
  6410                                  
  6411                                  ;-52         if (isDirect) {
  6412                                  
  6413 000022B5 A0[3D00]                 mov al, [isDirect]
  6414 000022B8 08C0                     or  al, al
  6415 000022BA 0F840D00                 je .writeEA245
  6416                                  
  6417                                  ;-53             xxx |= 6;
  6418                                  
  6419 000022BE 804E0406                 or  byte[bp+4], 6
  6420                                  
  6421                                  ;-54             len = 2;
  6422                                  
  6423 000022C2 B80200                   mov ax, 2
  6424 000022C5 8846FE                   mov [bp-2], al
  6425                                  
  6426                                  ;-55         }
  6427                                  
  6428                                  
  6429                                  ;-56         else { 
  6430                                  
  6431 000022C8 E95D00                   jmp .writeEA246
  6432                                  .writeEA245:
  6433                                  
  6434                                  ;-57             xxx = xxx + rm;   
  6435                                  
  6436 000022CB 8A4604                   mov al, [bp+4]
  6437 000022CE 0206[3C00]               add al, [rm]
  6438 000022D2 884604                   mov [bp+4], al
  6439                                  
  6440                                  ;-58             if (rm == 6) {//make [BP+00]
  6441                                  
  6442 000022D5 A0[3C00]                 mov al, [rm]
  6443 000022D8 3C06                     cmp al, 6
  6444 000022DA 0F851400                 jne .writeEA247
  6445                                  
  6446                                  ;-59                 len=1;
  6447                                  
  6448 000022DE B80100                   mov ax, 1
  6449 000022E1 8846FE                   mov [bp-2], al
  6450                                  
  6451                                  ;-60                 if (disp == 0) xxx |= 0x40;
  6452                                  
  6453 000022E4 A1[3E00]                 mov ax, [disp]
  6454 000022E7 83F800                   cmp ax, 0
  6455 000022EA 0F850400                 jne .writeEA248
  6456 000022EE 804E0440                 or  byte[bp+4], 64
  6457                                  
  6458                                  ;-61             }
  6459                                  
  6460                                  .writeEA248:
  6461                                  
  6462                                  ;-62 
  6463                                  
  6464                                  
  6465                                  ;-63             if (disp) {
  6466                                  
  6467                                  .writeEA247:
  6468 000022F2 A1[3E00]                 mov ax, [disp]
  6469 000022F5 08C0                     or  al, al
  6470 000022F7 0F842D00                 je .writeEA249
  6471                                  
  6472                                  ;-64                 ax = disp;
  6473                                  
  6474 000022FB A1[3E00]                 mov  ax, [disp]
  6475                                  
  6476                                  ;-65                 if(ax > 127) len=2;
  6477                                  
  6478 000022FE 83F87F                   cmp  ax, 127
  6479 00002301 0F8E0900                 jle .writeEA250
  6480 00002305 B80200                   mov ax, 2
  6481 00002308 8846FE                   mov [bp-2], al
  6482                                  
  6483                                  ;-66                 else len=1;
  6484                                  
  6485 0000230B E90600                   jmp .writeEA251
  6486                                  .writeEA250:
  6487 0000230E B80100                   mov ax, 1
  6488 00002311 8846FE                   mov [bp-2], al
  6489                                  
  6490                                  ;-67                 if (len == 1) xxx |= 0x40;
  6491                                  
  6492                                  .writeEA251:
  6493 00002314 8A46FE                   mov al, [bp-2]
  6494 00002317 3C01                     cmp al, 1
  6495 00002319 0F850700                 jne .writeEA252
  6496 0000231D 804E0440                 or  byte[bp+4], 64
  6497                                  
  6498                                  ;-68                 else xxx |= 0x80;
  6499                                  
  6500 00002321 E90400                   jmp .writeEA253
  6501                                  .writeEA252:
  6502 00002324 804E0480                 or  byte[bp+4], 128
  6503                                  
  6504                                  ;-69             }
  6505                                  
  6506                                  .writeEA253:
  6507                                  
  6508                                  ;-70         }
  6509                                  
  6510                                  .writeEA249:
  6511                                  
  6512                                  ;-71     }  
  6513                                  
  6514                                  .writeEA246:
  6515                                  
  6516                                  ;-72     
  6517                                  
  6518                                  
  6519                                  ;-73     genCode8(xxx);// gen second byte
  6520                                  
  6521                                  .writeEA244:
  6522 00002328 8A4604                   mov al, byte [bp+4]
  6523 0000232B B400                     mov ah, 0
  6524 0000232D 50                       push ax
  6525 0000232E E883FE                   call genCode8
  6526 00002331 83C402                   add  sp, 2
  6527                                  
  6528                                  ;-74     if (len == 1) genCode8 (disp);
  6529                                  
  6530 00002334 8A46FE                   mov al, [bp-2]
  6531 00002337 3C01                     cmp al, 1
  6532 00002339 0F850A00                 jne .writeEA254
  6533 0000233D FF36[3E00]               push word [disp]
  6534 00002341 E870FE                   call genCode8
  6535 00002344 83C402                   add  sp, 2
  6536                                  
  6537                                  ;-75     if (len == 2) genCode16(disp);
  6538                                  
  6539                                  .writeEA254:
  6540 00002347 8A46FE                   mov al, [bp-2]
  6541 0000234A 3C02                     cmp al, 2
  6542 0000234C 0F850A00                 jne .writeEA255
  6543 00002350 FF36[3E00]               push word [disp]
  6544 00002354 E8B4FE                   call genCode16
  6545 00002357 83C402                   add  sp, 2
  6546                                  
  6547                                  ;-76 }
  6548                                  
  6549                                  .writeEA255:
  6550                                  
  6551                                  ;-77 
  6552                                  
  6553                                  
  6554                                  ;-78 int genImmediate() { 
  6555 0000235A C9                       LEAVE
  6556 0000235B C3                       ret
  6557                                  ENDP
  6558                                  
  6559                                  genImmediate: PROC
  6560                                  
  6561                                  ;-79     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6562                                  
  6563 0000235C A0[3900]                 mov al, [wflag]
  6564 0000235F 08C0                     or  al, al
  6565 00002361 0F842300                 je .genImmediate256
  6566 00002365 A0[3800]                 mov al, [OpSize]
  6567 00002368 3C03                     cmp al, 3
  6568 0000236A 0F850D00                 jne .genImmediate257
  6569 0000236E FF36[4000]               push word [imme]
  6570 00002372 E8B7FE                   call genCode32
  6571 00002375 83C402                   add  sp, 2
  6572                                  
  6573                                  ;-80         else genCode16(imme);
  6574                                  
  6575 00002378 E90A00                   jmp .genImmediate258
  6576                                  .genImmediate257:
  6577 0000237B FF36[4000]               push word [imme]
  6578 0000237F E889FE                   call genCode16
  6579 00002382 83C402                   add  sp, 2
  6580                                  
  6581                                  ;-81     else       genCode8 (imme);  
  6582                                  
  6583                                  .genImmediate258:
  6584 00002385 E90A00                   jmp .genImmediate259
  6585                                  .genImmediate256:
  6586 00002388 FF36[4000]               push word [imme]
  6587 0000238C E825FE                   call genCode8
  6588 0000238F 83C402                   add  sp, 2
  6589                                  
  6590                                  ;-82 }    
  6591                                  
  6592                                  .genImmediate259:
  6593 00002392 C3                       ret
  6594                                  ENDP
  6595                                  ;Back to main program: AS.C
  6596                                  
  6597                                  ;-10 
  6598                                  
  6599                                  
  6600                                  ;-11 int process() {
  6601                                  
  6602                                  
  6603                                  process: PROC
  6604                                  
  6605                                  ;-12     char c;
  6606                                  
  6607                                  
  6608                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6609                                  
  6610                                  ;Function : process, Number of local variables: 1
  6611                                  ;   # type sign width addr used name   list of local variables
  6612                                  ;  200 var sign byte    12 NULL c = bp-2;
  6613 00002393 C8020000                 ENTER  2,0
  6614 00002397 B80000                   mov ax, 0
  6615 0000239A A2[3C00]                 mov byte [rm], al
  6616 0000239D A2[3900]                 mov byte [wflag], al
  6617 000023A0 A2[3A00]                 mov byte [dflag], al
  6618 000023A3 A2[3400]                 mov byte [R2No], al
  6619 000023A6 A2[3500]                 mov byte [R1No], al
  6620 000023A9 A2[3600]                 mov byte [R2Type], al
  6621 000023AC A2[3700]                 mov byte [R1Type], al
  6622 000023AF A2[2F00]                 mov byte [Op2], al
  6623 000023B2 A2[2E00]                 mov byte [Op], al
  6624                                  
  6625                                  ;-14     disp=imme=0;//int
  6626                                  
  6627 000023B5 B80000                   mov ax, 0
  6628 000023B8 A3[4000]                 mov word [imme], ax
  6629 000023BB A3[3E00]                 mov word [disp], ax
  6630                                  
  6631                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6632                                  
  6633 000023BE B80100                   mov ax, 1
  6634 000023C1 A2[3D00]                 mov byte [isDirect], al
  6635                                  
  6636                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6637                                  
  6638 000023C4 E89CE6                   call getTokeType
  6639                                  
  6640                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6641                                  
  6642 000023C7 E8B5EA                   call getCodeSize
  6643 000023CA A2[3800]                 mov byte [OpSize], al
  6644                                  
  6645                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6646                                  
  6647 000023CD E876FD                   call getCodes
  6648                                  
  6649                                  ;-19 
  6650                                  
  6651                                  
  6652                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6653                                  
  6654 000023D0 A0[3000]                 mov al, [CodeType]
  6655 000023D3 3C01                     cmp al, 1
  6656 000023D5 0F850F00                 jne .process260
  6657                                  
  6658                                  ;-21         genCode8(Code1);
  6659                                  
  6660 000023D9 A0[3100]                 mov al, byte [Code1]
  6661 000023DC B400                     mov ah, 0
  6662 000023DE 50                       push ax
  6663 000023DF E8D2FD                   call genCode8
  6664 000023E2 83C402                   add  sp, 2
  6665                                  
  6666                                  ;-22         return;
  6667                                  
  6668 000023E5 E90208                   jmp .retnprocess
  6669                                  
  6670                                  ;-23     }
  6671                                  
  6672                                  
  6673                                  ;-24 
  6674                                  
  6675                                  
  6676                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6677                                  
  6678                                  .process260:
  6679 000023E8 A0[3000]                 mov al, [CodeType]
  6680 000023EB 3C02                     cmp al, 2
  6681 000023ED 0F856900                 jne .process261
  6682                                  
  6683                                  ;-26         getOpL();
  6684                                  
  6685 000023F1 E894E1                   call getOpL
  6686                                  
  6687                                  ;-27         checkOpL();
  6688                                  
  6689 000023F4 E8B4E0                   call checkOpL
  6690                                  
  6691                                  ;-28         if (Code2 <= 1) {//inc,dec
  6692                                  
  6693 000023F7 A0[3200]                 mov al, [Code2]
  6694 000023FA 3C01                     cmp al, 1
  6695 000023FC 0F8F2700                 jg  .process262
  6696                                  
  6697                                  ;-29   	        if (Op == REG) {//short
  6698                                  
  6699 00002400 A0[2E00]                 mov al, [Op]
  6700 00002403 3C02                     cmp al, 2
  6701 00002405 0F851E00                 jne .process263
  6702                                  
  6703                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6704                                  
  6705 00002409 A0[3900]                 mov al, [wflag]
  6706 0000240C 08C0                     or  al, al
  6707 0000240E 0F841500                 je .process264
  6708 00002412 A0[3500]                 mov al, byte [R1No]
  6709 00002415 B400                     mov ah, 0
  6710 00002417 50                       push ax
  6711 00002418 A0[3300]                 mov al, byte [Code3]
  6712 0000241B B400                     mov ah, 0
  6713 0000241D 50                       push ax
  6714 0000241E E85CFD                   call genCode2
  6715 00002421 83C404                   add  sp, 4
  6716 00002424 E9C307                   jmp .retnprocess
  6717                                  
  6718                                  ;-31             }
  6719                                  
  6720                                  .process264:
  6721                                  
  6722                                  ;-32         }
  6723                                  
  6724                                  .process263:
  6725                                  
  6726                                  ;-33         if (Code2 == 5) {//imul extension?
  6727                                  
  6728                                  .process262:
  6729 00002427 A0[3200]                 mov al, [Code2]
  6730 0000242A 3C05                     cmp al, 5
  6731 0000242C 0F850F00                 jne .process265
  6732                                  
  6733                                  ;-34             getTokeType();
  6734                                  
  6735 00002430 E830E6                   call getTokeType
  6736                                  
  6737                                  ;-35             if (TokeType) implerror();
  6738                                  
  6739 00002433 A0[2D00]                 mov al, [TokeType]
  6740 00002436 08C0                     or  al, al
  6741 00002438 0F840300                 je .process266
  6742 0000243C E83BF7                   call implerror
  6743                                  
  6744                                  ;-36         }
  6745                                  
  6746                                  .process266:
  6747                                  
  6748                                  ;-37         genCodeW(Code1);
  6749                                  
  6750                                  .process265:
  6751 0000243F A0[3100]                 mov al, byte [Code1]
  6752 00002442 B400                     mov ah, 0
  6753 00002444 50                       push ax
  6754 00002445 E850FD                   call genCodeW
  6755 00002448 83C402                   add  sp, 2
  6756                                  
  6757                                  ;-38         writeEA(Code2);
  6758                                  
  6759 0000244B A0[3200]                 mov al, byte [Code2]
  6760 0000244E B400                     mov ah, 0
  6761 00002450 50                       push ax
  6762 00002451 E802FE                   call writeEA
  6763 00002454 83C402                   add  sp, 2
  6764                                  
  6765                                  ;-39         return;
  6766                                  
  6767 00002457 E99007                   jmp .retnprocess
  6768                                  
  6769                                  ;-40     }
  6770                                  
  6771                                  
  6772                                  ;-41 
  6773                                  
  6774                                  
  6775                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6776                                  
  6777                                  .process261:
  6778 0000245A A0[3000]                 mov al, [CodeType]
  6779 0000245D 3C03                     cmp al, 3
  6780 0000245F 0F855100                 jne .process267
  6781                                  
  6782                                  ;-43         check2Ops();    //setwflag not applicable
  6783                                  
  6784 00002463 E8C7E0                   call check2Ops
  6785                                  
  6786                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6787                                  
  6788 00002466 A0[3700]                 mov al, [R1Type]
  6789 00002469 3C02                     cmp al, 2
  6790 0000246B 0F840300                 je  .process268
  6791 0000246F E8A8F7                   call reg16error
  6792                                  
  6793                                  ;-45         if (Op2 != MEM) addrerror();//only m16
  6794                                  
  6795                                  .process268:
  6796 00002472 A0[2F00]                 mov al, [Op2]
  6797 00002475 3C04                     cmp al, 4
  6798 00002477 0F840300                 je  .process269
  6799 0000247B E8BDF6                   call addrerror
  6800                                  
  6801                                  ;-46 
  6802                                  
  6803                                  
  6804                                  ;-47         genCode8(Code1);//les,lds,lea
  6805                                  
  6806                                  .process269:
  6807 0000247E A0[3100]                 mov al, byte [Code1]
  6808 00002481 B400                     mov ah, 0
  6809 00002483 50                       push ax
  6810 00002484 E82DFD                   call genCode8
  6811 00002487 83C402                   add  sp, 2
  6812                                  
  6813                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6814                                  
  6815 0000248A A0[3100]                 mov al, [Code1]
  6816 0000248D 3C0F                     cmp al, 15
  6817 0000248F 0F850C00                 jne .process270
  6818 00002493 A0[3200]                 mov al, byte [Code2]
  6819 00002496 B400                     mov ah, 0
  6820 00002498 50                       push ax
  6821 00002499 E818FD                   call genCode8
  6822 0000249C 83C402                   add  sp, 2
  6823                                  
  6824                                  ;-49         Op=Op2;//set MEM for writeEA
  6825                                  
  6826                                  .process270:
  6827 0000249F A0[2F00]                 mov al, [Op2]
  6828 000024A2 A2[2E00]                 mov byte [Op], al
  6829                                  
  6830                                  ;-50         writeEA(R1No);
  6831                                  
  6832 000024A5 A0[3500]                 mov al, byte [R1No]
  6833 000024A8 B400                     mov ah, 0
  6834 000024AA 50                       push ax
  6835 000024AB E8A8FD                   call writeEA
  6836 000024AE 83C402                   add  sp, 2
  6837                                  
  6838                                  ;-51         return;
  6839                                  
  6840 000024B1 E93607                   jmp .retnprocess
  6841                                  
  6842                                  ;-52     }
  6843                                  
  6844                                  
  6845                                  ;-53 
  6846                                  
  6847                                  
  6848                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6849                                  
  6850                                  .process267:
  6851 000024B4 A0[3000]                 mov al, [CodeType]
  6852 000024B7 3C04                     cmp al, 4
  6853 000024B9 0F85EF00                 jne .process271
  6854                                  
  6855                                  ;-55         check2Ops();
  6856                                  
  6857 000024BD E86DE0                   call check2Ops
  6858                                  
  6859                                  ;-56         if (Op2 == IMM) {//second operand is imm
  6860                                  
  6861 000024C0 A0[2F00]                 mov al, [Op2]
  6862 000024C3 3C01                     cmp al, 1
  6863 000024C5 0F857900                 jne .process272
  6864                                  
  6865                                  ;-57             setsflag();
  6866                                  
  6867 000024C9 E8F6E3                   call setsflag
  6868                                  
  6869                                  ;-58             if (Op == REG) {
  6870                                  
  6871 000024CC A0[2E00]                 mov al, [Op]
  6872 000024CF 3C02                     cmp al, 2
  6873 000024D1 0F853100                 jne .process273
  6874                                  
  6875                                  ;-59                 if (R1No == 0) {// acc,imm
  6876                                  
  6877 000024D5 A0[3500]                 mov al, [R1No]
  6878 000024D8 3C00                     cmp al, 0
  6879 000024DA 0F852800                 jne .process274
  6880                                  
  6881                                  ;-60                     if (sflag == 0) {
  6882                                  
  6883 000024DE A0[3B00]                 mov al, [sflag]
  6884 000024E1 3C00                     cmp al, 0
  6885 000024E3 0F851F00                 jne .process275
  6886                                  
  6887                                  ;-61                         c = Code1 << 3;
  6888                                  
  6889 000024E7 A0[3100]                 mov al, [Code1]
  6890 000024EA C0E003                   shl al, 3
  6891 000024ED 8846FE                   mov [bp-2], al
  6892                                  
  6893                                  ;-62                         c += 4;
  6894                                  
  6895 000024F0 8046FE04                 add  byte[bp-2], 4
  6896                                  
  6897                                  ;-63                         genCodeW(c);
  6898                                  
  6899 000024F4 8A46FE                   mov al, byte [bp-2]
  6900 000024F7 B400                     mov ah, 0
  6901 000024F9 50                       push ax
  6902 000024FA E89BFC                   call genCodeW
  6903 000024FD 83C402                   add  sp, 2
  6904                                  
  6905                                  ;-64                         genImmediate();
  6906                                  
  6907 00002500 E859FE                   call genImmediate
  6908                                  
  6909                                  ;-65                         return;
  6910                                  
  6911 00002503 E9E406                   jmp .retnprocess
  6912                                  
  6913                                  ;-66                     }
  6914                                  
  6915                                  
  6916                                  ;-67                 }
  6917                                  
  6918                                  .process275:
  6919                                  
  6920                                  ;-68             }
  6921                                  
  6922                                  .process274:
  6923                                  
  6924                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6925                                  
  6926                                  
  6927                                  ;-70             c = sflag + 0x80;
  6928                                  
  6929                                  .process273:
  6930 00002506 A0[3B00]                 mov al, [sflag]
  6931 00002509 0480                     add al, 128
  6932 0000250B 8846FE                   mov [bp-2], al
  6933                                  
  6934                                  ;-71             genCodeW(c);
  6935                                  
  6936 0000250E 8A46FE                   mov al, byte [bp-2]
  6937 00002511 B400                     mov ah, 0
  6938 00002513 50                       push ax
  6939 00002514 E881FC                   call genCodeW
  6940 00002517 83C402                   add  sp, 2
  6941                                  
  6942                                  ;-72             writeEA(Code1);
  6943                                  
  6944 0000251A A0[3100]                 mov al, byte [Code1]
  6945 0000251D B400                     mov ah, 0
  6946 0000251F 50                       push ax
  6947 00002520 E833FD                   call writeEA
  6948 00002523 83C402                   add  sp, 2
  6949                                  
  6950                                  ;-73             if (sflag) genCode8(imme);
  6951                                  
  6952 00002526 A0[3B00]                 mov al, [sflag]
  6953 00002529 08C0                     or  al, al
  6954 0000252B 0F840D00                 je .process276
  6955 0000252F FF36[4000]               push word [imme]
  6956 00002533 E87EFC                   call genCode8
  6957 00002536 83C402                   add  sp, 2
  6958                                  
  6959                                  ;-74             else genImmediate();
  6960                                  
  6961 00002539 E90300                   jmp .process277
  6962                                  .process276:
  6963 0000253C E81DFE                   call genImmediate
  6964                                  
  6965                                  ;-75             return;
  6966                                  
  6967                                  .process277:
  6968 0000253F E9A806                   jmp .retnprocess
  6969                                  
  6970                                  ;-76         }
  6971                                  
  6972                                  
  6973                                  ;-77         c = Code1 << 3;//r/m, r/r
  6974                                  
  6975                                  .process272:
  6976 00002542 A0[3100]                 mov al, [Code1]
  6977 00002545 C0E003                   shl al, 3
  6978 00002548 8846FE                   mov [bp-2], al
  6979                                  
  6980                                  ;-78         if (Op == REG) {
  6981                                  
  6982 0000254B A0[2E00]                 mov al, [Op]
  6983 0000254E 3C02                     cmp al, 2
  6984 00002550 0F852E00                 jne .process278
  6985                                  
  6986                                  ;-79             if (Op2 == MEM) {//reg, mem
  6987                                  
  6988 00002554 A0[2F00]                 mov al, [Op2]
  6989 00002557 3C04                     cmp al, 4
  6990 00002559 0F852500                 jne .process279
  6991                                  
  6992                                  ;-80                 c += 2;//add direction flag
  6993                                  
  6994 0000255D 8046FE02                 add  byte[bp-2], 2
  6995                                  
  6996                                  ;-81                 genCodeW(c);
  6997                                  
  6998 00002561 8A46FE                   mov al, byte [bp-2]
  6999 00002564 B400                     mov ah, 0
  7000 00002566 50                       push ax
  7001 00002567 E82EFC                   call genCodeW
  7002 0000256A 83C402                   add  sp, 2
  7003                                  
  7004                                  ;-82                 Op=Op2;//set MEM for writeEA
  7005                                  
  7006 0000256D A0[2F00]                 mov al, [Op2]
  7007 00002570 A2[2E00]                 mov byte [Op], al
  7008                                  
  7009                                  ;-83                 writeEA(R1No);
  7010                                  
  7011 00002573 A0[3500]                 mov al, byte [R1No]
  7012 00002576 B400                     mov ah, 0
  7013 00002578 50                       push ax
  7014 00002579 E8DAFC                   call writeEA
  7015 0000257C 83C402                   add  sp, 2
  7016                                  
  7017                                  ;-84                 return;
  7018                                  
  7019 0000257F E96806                   jmp .retnprocess
  7020                                  
  7021                                  ;-85             }
  7022                                  
  7023                                  
  7024                                  ;-86         }
  7025                                  
  7026                                  .process279:
  7027                                  
  7028                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  7029                                  
  7030                                  .process278:
  7031 00002582 A0[2F00]                 mov al, [Op2]
  7032 00002585 3C02                     cmp al, 2
  7033 00002587 0F851B00                 jne .process280
  7034                                  
  7035                                  ;-88             genCodeW(c);
  7036                                  
  7037 0000258B 8A46FE                   mov al, byte [bp-2]
  7038 0000258E B400                     mov ah, 0
  7039 00002590 50                       push ax
  7040 00002591 E804FC                   call genCodeW
  7041 00002594 83C402                   add  sp, 2
  7042                                  
  7043                                  ;-89             writeEA(R2No);//2. Op in reg-field
  7044                                  
  7045 00002597 A0[3400]                 mov al, byte [R2No]
  7046 0000259A B400                     mov ah, 0
  7047 0000259C 50                       push ax
  7048 0000259D E8B6FC                   call writeEA
  7049 000025A0 83C402                   add  sp, 2
  7050                                  
  7051                                  ;-90             return;
  7052                                  
  7053 000025A3 E94406                   jmp .retnprocess
  7054                                  
  7055                                  ;-91         }
  7056                                  
  7057                                  
  7058                                  ;-92         syntaxerror();
  7059                                  
  7060                                  .process280:
  7061 000025A6 E8C0F6                   call syntaxerror
  7062                                  
  7063                                  ;-93         return;
  7064                                  
  7065 000025A9 E93E06                   jmp .retnprocess
  7066                                  
  7067                                  ;-94     }
  7068                                  
  7069                                  
  7070                                  ;-95 
  7071                                  
  7072                                  
  7073                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  7074                                  
  7075                                  .process271:
  7076 000025AC A0[3000]                 mov al, [CodeType]
  7077 000025AF 3C05                     cmp al, 5
  7078 000025B1 0F857C01                 jne .process281
  7079                                  
  7080                                  ;-97         check2Ops();
  7081                                  
  7082 000025B5 E875DF                   call check2Ops
  7083                                  
  7084                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  7085                                  
  7086                                  
  7087                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  7088                                  
  7089                                  
  7090                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  7091                                  
  7092                                  
  7093                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */
  7094                                  
  7095                                  
  7096                                  ;-102         if (Op2 == ADR) {
  7097                                  
  7098 000025B8 A0[2F00]                 mov al, [Op2]
  7099 000025BB 3C03                     cmp al, 3
  7100 000025BD 0F850C00                 jne .process282
  7101                                  
  7102                                  ;-103             imme=disp;
  7103                                  
  7104 000025C1 A1[3E00]                 mov ax, [disp]
  7105 000025C4 A3[4000]                 mov word [imme], ax
  7106                                  
  7107                                  ;-104             Op2=IMM;//continue with IMM
  7108                                  
  7109 000025C7 B80100                   mov ax, 1
  7110 000025CA A2[2F00]                 mov byte [Op2], al
  7111                                  
  7112                                  ;-105         }
  7113                                  
  7114                                  
  7115                                  ;-106         if (Op2 == IMM) {// r,i
  7116                                  
  7117                                  .process282:
  7118 000025CD A0[2F00]                 mov al, [Op2]
  7119 000025D0 3C01                     cmp al, 1
  7120 000025D2 0F855400                 jne .process283
  7121                                  
  7122                                  ;-107             if (Op == REG) {
  7123                                  
  7124 000025D6 A0[2E00]                 mov al, [Op]
  7125 000025D9 3C02                     cmp al, 2
  7126 000025DB 0F852500                 jne .process284
  7127                                  
  7128                                  ;-108                 c = wflag << 3;
  7129                                  
  7130 000025DF A0[3900]                 mov al, [wflag]
  7131 000025E2 C0E003                   shl al, 3
  7132 000025E5 8846FE                   mov [bp-2], al
  7133                                  
  7134                                  ;-109                 c += 0xB0;
  7135                                  
  7136 000025E8 8046FEB0                 add  byte[bp-2], 176
  7137                                  
  7138                                  ;-110                 genCode2(c, R1No);
  7139                                  
  7140 000025EC A0[3500]                 mov al, byte [R1No]
  7141 000025EF B400                     mov ah, 0
  7142 000025F1 50                       push ax
  7143 000025F2 8A46FE                   mov al, byte [bp-2]
  7144 000025F5 B400                     mov ah, 0
  7145 000025F7 50                       push ax
  7146 000025F8 E882FB                   call genCode2
  7147 000025FB 83C404                   add  sp, 4
  7148                                  
  7149                                  ;-111                 genImmediate();
  7150                                  
  7151 000025FE E85BFD                   call genImmediate
  7152                                  
  7153                                  ;-112                 return;
  7154                                  
  7155 00002601 E9E605                   jmp .retnprocess
  7156                                  
  7157                                  ;-113             }
  7158                                  
  7159                                  
  7160                                  ;-114             if (Op == MEM) {// m,i
  7161                                  
  7162                                  .process284:
  7163 00002604 A0[2E00]                 mov al, [Op]
  7164 00002607 3C04                     cmp al, 4
  7165 00002609 0F851700                 jne .process285
  7166                                  
  7167                                  ;-115                 genCodeW(0xC6);
  7168                                  
  7169 0000260D 68C600                   push 198
  7170 00002610 E885FB                   call genCodeW
  7171 00002613 83C402                   add  sp, 2
  7172                                  
  7173                                  ;-116                 writeEA( 0 );
  7174                                  
  7175 00002616 6A00                     push 0
  7176 00002618 E83BFC                   call writeEA
  7177 0000261B 83C402                   add  sp, 2
  7178                                  
  7179                                  ;-117                 genImmediate();
  7180                                  
  7181 0000261E E83BFD                   call genImmediate
  7182                                  
  7183                                  ;-118                 return;
  7184                                  
  7185 00002621 E9C605                   jmp .retnprocess
  7186                                  
  7187                                  ;-119             }
  7188                                  
  7189                                  
  7190                                  ;-120             regmemerror();
  7191                                  
  7192                                  .process285:
  7193 00002624 E8C9F5                   call regmemerror
  7194                                  
  7195                                  ;-121             return;
  7196                                  
  7197 00002627 E9C005                   jmp .retnprocess
  7198                                  
  7199                                  ;-122         }
  7200                                  
  7201                                  
  7202                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7203                                  
  7204                                  .process283:
  7205 0000262A A0[3700]                 mov al, [R1Type]
  7206 0000262D 3C04                     cmp al, 4
  7207 0000262F 0F850300                 jne .process286
  7208 00002633 E833DE                   call ChangeDirection
  7209                                  
  7210                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  7211                                  
  7212                                  .process286:
  7213 00002636 A0[3600]                 mov al, [R2Type]
  7214 00002639 3C04                     cmp al, 4
  7215 0000263B 0F852A00                 jne .process287
  7216                                  
  7217                                  ;-125             if (OpSize != WORD) reg16error();
  7218                                  
  7219 0000263F A0[3800]                 mov al, [OpSize]
  7220 00002642 3C02                     cmp al, 2
  7221 00002644 0F840300                 je  .process288
  7222 00002648 E8CFF5                   call reg16error
  7223                                  
  7224                                  ;-126                 genCode2(0x8C, dflag);
  7225                                  
  7226                                  .process288:
  7227 0000264B A0[3A00]                 mov al, byte [dflag]
  7228 0000264E B400                     mov ah, 0
  7229 00002650 50                       push ax
  7230 00002651 688C00                   push 140
  7231 00002654 E826FB                   call genCode2
  7232 00002657 83C404                   add  sp, 4
  7233                                  
  7234                                  ;-127                 writeEA(R2No);
  7235                                  
  7236 0000265A A0[3400]                 mov al, byte [R2No]
  7237 0000265D B400                     mov ah, 0
  7238 0000265F 50                       push ax
  7239 00002660 E8F3FB                   call writeEA
  7240 00002663 83C402                   add  sp, 2
  7241                                  
  7242                                  ;-128                 return;
  7243                                  
  7244 00002666 E98105                   jmp .retnprocess
  7245                                  
  7246                                  ;-129         }
  7247                                  
  7248                                  
  7249                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  7250                                  
  7251                                  .process287:
  7252 00002669 A0[2F00]                 mov al, [Op2]
  7253 0000266C 3C04                     cmp al, 4
  7254 0000266E 0F853100                 jne .process289
  7255                                  
  7256                                  ;-131             if (Op == REG) {
  7257                                  
  7258 00002672 A0[2E00]                 mov al, [Op]
  7259 00002675 3C02                     cmp al, 2
  7260 00002677 0F852800                 jne .process290
  7261                                  
  7262                                  ;-132                 if (R1No == 0) {
  7263                                  
  7264 0000267B A0[3500]                 mov al, [R1No]
  7265 0000267E 3C00                     cmp al, 0
  7266 00002680 0F851F00                 jne .process291
  7267                                  
  7268                                  ;-133                     if (isDirect) {
  7269                                  
  7270 00002684 A0[3D00]                 mov al, [isDirect]
  7271 00002687 08C0                     or  al, al
  7272 00002689 0F841600                 je .process292
  7273                                  
  7274                                  ;-134                         genCodeW(0xA0);
  7275                                  
  7276 0000268D 68A000                   push 160
  7277 00002690 E805FB                   call genCodeW
  7278 00002693 83C402                   add  sp, 2
  7279                                  
  7280                                  ;-135                         genCode16(disp);
  7281                                  
  7282 00002696 FF36[3E00]               push word [disp]
  7283 0000269A E86EFB                   call genCode16
  7284 0000269D 83C402                   add  sp, 2
  7285                                  
  7286                                  ;-136                         return;
  7287                                  
  7288 000026A0 E94705                   jmp .retnprocess
  7289                                  
  7290                                  ;-137                     }
  7291                                  
  7292                                  
  7293                                  ;-138                 }
  7294                                  
  7295                                  .process292:
  7296                                  
  7297                                  ;-139             }
  7298                                  
  7299                                  .process291:
  7300                                  
  7301                                  ;-140         }
  7302                                  
  7303                                  .process290:
  7304                                  
  7305                                  ;-141         if (Op == MEM) {//moffs16, acc
  7306                                  
  7307                                  .process289:
  7308 000026A3 A0[2E00]                 mov al, [Op]
  7309 000026A6 3C04                     cmp al, 4
  7310 000026A8 0F853100                 jne .process293
  7311                                  
  7312                                  ;-142             if (Op2 == REG) {
  7313                                  
  7314 000026AC A0[2F00]                 mov al, [Op2]
  7315 000026AF 3C02                     cmp al, 2
  7316 000026B1 0F852800                 jne .process294
  7317                                  
  7318                                  ;-143                 if (R2No == 0) {
  7319                                  
  7320 000026B5 A0[3400]                 mov al, [R2No]
  7321 000026B8 3C00                     cmp al, 0
  7322 000026BA 0F851F00                 jne .process295
  7323                                  
  7324                                  ;-144                     if (isDirect) {
  7325                                  
  7326 000026BE A0[3D00]                 mov al, [isDirect]
  7327 000026C1 08C0                     or  al, al
  7328 000026C3 0F841600                 je .process296
  7329                                  
  7330                                  ;-145                         genCodeW(0xA2);
  7331                                  
  7332 000026C7 68A200                   push 162
  7333 000026CA E8CBFA                   call genCodeW
  7334 000026CD 83C402                   add  sp, 2
  7335                                  
  7336                                  ;-146                         genCode16(disp);
  7337                                  
  7338 000026D0 FF36[3E00]               push word [disp]
  7339 000026D4 E834FB                   call genCode16
  7340 000026D7 83C402                   add  sp, 2
  7341                                  
  7342                                  ;-147                         return;
  7343                                  
  7344 000026DA E90D05                   jmp .retnprocess
  7345                                  
  7346                                  ;-148                     }
  7347                                  
  7348                                  
  7349                                  ;-149                 }
  7350                                  
  7351                                  .process296:
  7352                                  
  7353                                  ;-150             }
  7354                                  
  7355                                  .process295:
  7356                                  
  7357                                  ;-151 
  7358                                  
  7359                                  
  7360                                  ;-152         }
  7361                                  
  7362                                  .process294:
  7363                                  
  7364                                  ;-153         if (Op2 == REG) {//rm, r
  7365                                  
  7366                                  .process293:
  7367 000026DD A0[2F00]                 mov al, [Op2]
  7368 000026E0 3C02                     cmp al, 2
  7369 000026E2 0F851800                 jne .process297
  7370                                  
  7371                                  ;-154             genCodeW(0x88);
  7372                                  
  7373 000026E6 688800                   push 136
  7374 000026E9 E8ACFA                   call genCodeW
  7375 000026EC 83C402                   add  sp, 2
  7376                                  
  7377                                  ;-155             writeEA(R2No);
  7378                                  
  7379 000026EF A0[3400]                 mov al, byte [R2No]
  7380 000026F2 B400                     mov ah, 0
  7381 000026F4 50                       push ax
  7382 000026F5 E85EFB                   call writeEA
  7383 000026F8 83C402                   add  sp, 2
  7384                                  
  7385                                  ;-156             return;
  7386                                  
  7387 000026FB E9EC04                   jmp .retnprocess
  7388                                  
  7389                                  ;-157         }
  7390                                  
  7391                                  
  7392                                  ;-158         if (Op2 == MEM) {//r, m
  7393                                  
  7394                                  .process297:
  7395 000026FE A0[2F00]                 mov al, [Op2]
  7396 00002701 3C04                     cmp al, 4
  7397 00002703 0F852400                 jne .process298
  7398                                  
  7399                                  ;-159             if (Op == REG) {
  7400                                  
  7401 00002707 A0[2E00]                 mov al, [Op]
  7402 0000270A 3C02                     cmp al, 2
  7403 0000270C 0F851B00                 jne .process299
  7404                                  
  7405                                  ;-160                 ChangeDirection();
  7406                                  
  7407 00002710 E856DD                   call ChangeDirection
  7408                                  
  7409                                  ;-161                 genCodeW(0x8A);
  7410                                  
  7411 00002713 688A00                   push 138
  7412 00002716 E87FFA                   call genCodeW
  7413 00002719 83C402                   add  sp, 2
  7414                                  
  7415                                  ;-162                 writeEA(R2No);
  7416                                  
  7417 0000271C A0[3400]                 mov al, byte [R2No]
  7418 0000271F B400                     mov ah, 0
  7419 00002721 50                       push ax
  7420 00002722 E831FB                   call writeEA
  7421 00002725 83C402                   add  sp, 2
  7422                                  
  7423                                  ;-163                 return;
  7424                                  
  7425 00002728 E9BF04                   jmp .retnprocess
  7426                                  
  7427                                  ;-164             }
  7428                                  
  7429                                  
  7430                                  ;-165         }
  7431                                  
  7432                                  .process299:
  7433                                  
  7434                                  ;-166         syntaxerror();
  7435                                  
  7436                                  .process298:
  7437 0000272B E83BF5                   call syntaxerror
  7438                                  
  7439                                  ;-167         return;
  7440                                  
  7441 0000272E E9B904                   jmp .retnprocess
  7442                                  
  7443                                  ;-168     }
  7444                                  
  7445                                  
  7446                                  ;-169 
  7447                                  
  7448                                  
  7449                                  ;-170     if (CodeType == 6) {//Jcc
  7450                                  
  7451                                  .process281:
  7452 00002731 A0[3000]                 mov al, [CodeType]
  7453 00002734 3C06                     cmp al, 6
  7454 00002736 0F85BE00                 jne .process300
  7455                                  
  7456                                  ;-171         if (TokeType == ALNUME) {
  7457                                  
  7458 0000273A A0[2D00]                 mov al, [TokeType]
  7459 0000273D 3C03                     cmp al, 3
  7460 0000273F 0F85B500                 jne .process301
  7461                                  
  7462                                  ;-172             LabelIx=searchLabel();
  7463                                  
  7464 00002743 E8D5E4                   call searchLabel
  7465 00002746 A3[4B00]                 mov word [LabelIx], ax
  7466                                  
  7467                                  ;-173             if (LabelIx > 0) {
  7468                                  
  7469 00002749 A1[4B00]                 mov ax, [LabelIx]
  7470 0000274C 83F800                   cmp ax, 0
  7471 0000274F 0F8E7A00                 jle .process302
  7472                                  
  7473                                  ;-174                 disp=LabelAddr[LabelIx];
  7474                                  
  7475 00002753 8B1E[4B00]               mov bx, [LabelIx]
  7476 00002757 D1E3                     shl bx, 1
  7477 00002759 8B87FA86                 mov ax, [LabelAddr + bx]
  7478 0000275D A3[3E00]                 mov word [disp], ax
  7479                                  
  7480                                  ;-175                 disp = disp - PC;
  7481                                  
  7482 00002760 A1[3E00]                 mov ax, [disp]
  7483 00002763 2B06[2400]               sub ax, [PC]
  7484 00002767 A3[3E00]                 mov word [disp], ax
  7485                                  
  7486                                  ;-176                 disp = disp - Origin;
  7487                                  
  7488 0000276A A1[3E00]                 mov ax, [disp]
  7489 0000276D 2B06[2600]               sub ax, [Origin]
  7490 00002771 A3[3E00]                 mov word [disp], ax
  7491                                  
  7492                                  ;-177                 if (checkConstSize(disp) ) {
  7493                                  
  7494 00002774 FF36[3E00]               push word [disp]
  7495 00002778 E8A3E1                   call checkConstSize
  7496 0000277B 83C402                   add  sp, 2
  7497 0000277E 08C0                     or  al, al
  7498 00002780 0F842000                 je .process303
  7499                                  
  7500                                  ;-178                     genCode2(Code1, 0x70);//short
  7501                                  
  7502 00002784 6A70                     push 112
  7503 00002786 A0[3100]                 mov al, byte [Code1]
  7504 00002789 B400                     mov ah, 0
  7505 0000278B 50                       push ax
  7506 0000278C E8EEF9                   call genCode2
  7507 0000278F 83C404                   add  sp, 4
  7508                                  
  7509                                  ;-179                     disp -= 2;
  7510                                  
  7511 00002792 832E[3E00]02             sub  word[disp], 2
  7512                                  
  7513                                  ;-180                     genCode8(disp);
  7514                                  
  7515 00002797 FF36[3E00]               push word [disp]
  7516 0000279B E816FA                   call genCode8
  7517 0000279E 83C402                   add  sp, 2
  7518                                  
  7519                                  ;-181                 } else {
  7520                                  
  7521 000027A1 E92600                   jmp .process304
  7522                                  .process303:
  7523                                  
  7524                                  ;-182                     genCode8(0x0F);
  7525                                  
  7526 000027A4 6A0F                     push 15
  7527 000027A6 E80BFA                   call genCode8
  7528 000027A9 83C402                   add  sp, 2
  7529                                  
  7530                                  ;-183                     genCode2(Code1, 0x80);//near
  7531                                  
  7532 000027AC 688000                   push 128
  7533 000027AF A0[3100]                 mov al, byte [Code1]
  7534 000027B2 B400                     mov ah, 0
  7535 000027B4 50                       push ax
  7536 000027B5 E8C5F9                   call genCode2
  7537 000027B8 83C404                   add  sp, 4
  7538                                  
  7539                                  ;-184                     disp -= 4;
  7540                                  
  7541 000027BB 832E[3E00]04             sub  word[disp], 4
  7542                                  
  7543                                  ;-185                     genCode16(disp);
  7544                                  
  7545 000027C0 FF36[3E00]               push word [disp]
  7546 000027C4 E844FA                   call genCode16
  7547 000027C7 83C402                   add  sp, 2
  7548                                  
  7549                                  ;-186                 }
  7550                                  
  7551                                  
  7552                                  ;-187             }
  7553                                  
  7554                                  .process304:
  7555                                  
  7556                                  ;-188             else {//jump forward, near only
  7557                                  
  7558 000027CA E92800                   jmp .process305
  7559                                  .process302:
  7560                                  
  7561                                  ;-189                 genCode8(0x0F);
  7562                                  
  7563 000027CD 6A0F                     push 15
  7564 000027CF E8E2F9                   call genCode8
  7565 000027D2 83C402                   add  sp, 2
  7566                                  
  7567                                  ;-190                 genCode2(Code1, 0x80);
  7568                                  
  7569 000027D5 688000                   push 128
  7570 000027D8 A0[3100]                 mov al, byte [Code1]
  7571 000027DB B400                     mov ah, 0
  7572 000027DD 50                       push ax
  7573 000027DE E89CF9                   call genCode2
  7574 000027E1 83C404                   add  sp, 4
  7575                                  
  7576                                  ;-191                 genCode16(0);
  7577                                  
  7578 000027E4 6A00                     push 0
  7579 000027E6 E822FA                   call genCode16
  7580 000027E9 83C402                   add  sp, 2
  7581                                  
  7582                                  ;-192                 PrintRA='*';
  7583                                  
  7584 000027EC B82A00                   mov ax, 42
  7585 000027EF A2[4600]                 mov byte [PrintRA], al
  7586                                  
  7587                                  ;-193                 storeJmpCall();
  7588                                  
  7589 000027F2 E8FAE2                   call storeJmpCall
  7590                                  
  7591                                  ;-194             }
  7592                                  
  7593                                  
  7594                                  ;-195         return;
  7595                                  
  7596                                  .process305:
  7597 000027F5 E9F203                   jmp .retnprocess
  7598                                  
  7599                                  ;-196         }
  7600                                  
  7601                                  
  7602                                  ;-197     }
  7603                                  
  7604                                  .process301:
  7605                                  
  7606                                  ;-198 
  7607                                  
  7608                                  
  7609                                  ;-199     if (CodeType == 7) {//jmp, call
  7610                                  
  7611                                  .process300:
  7612 000027F8 A0[3000]                 mov al, [CodeType]
  7613 000027FB 3C07                     cmp al, 7
  7614 000027FD 0F85CA00                 jne .process306
  7615                                  
  7616                                  ;-200         if (TokeType == ALNUME) {
  7617                                  
  7618 00002801 A0[2D00]                 mov al, [TokeType]
  7619 00002804 3C03                     cmp al, 3
  7620 00002806 0F85C100                 jne .process307
  7621                                  
  7622                                  ;-201             LabelIx=searchLabel();
  7623                                  
  7624 0000280A E80EE4                   call searchLabel
  7625 0000280D A3[4B00]                 mov word [LabelIx], ax
  7626                                  
  7627                                  ;-202             if (LabelIx > 0) {
  7628                                  
  7629 00002810 A1[4B00]                 mov ax, [LabelIx]
  7630 00002813 83F800                   cmp ax, 0
  7631 00002816 0F8E9100                 jle .process308
  7632                                  
  7633                                  ;-203                 disp=LabelAddr[LabelIx];
  7634                                  
  7635 0000281A 8B1E[4B00]               mov bx, [LabelIx]
  7636 0000281E D1E3                     shl bx, 1
  7637 00002820 8B87FA86                 mov ax, [LabelAddr + bx]
  7638 00002824 A3[3E00]                 mov word [disp], ax
  7639                                  
  7640                                  ;-204                 disp = disp - PC;
  7641                                  
  7642 00002827 A1[3E00]                 mov ax, [disp]
  7643 0000282A 2B06[2400]               sub ax, [PC]
  7644 0000282E A3[3E00]                 mov word [disp], ax
  7645                                  
  7646                                  ;-205                 disp = disp - Origin;
  7647                                  
  7648 00002831 A1[3E00]                 mov ax, [disp]
  7649 00002834 2B06[2600]               sub ax, [Origin]
  7650 00002838 A3[3E00]                 mov word [disp], ax
  7651                                  
  7652                                  ;-206                 if (checkConstSize(disp) ) {
  7653                                  
  7654 0000283B FF36[3E00]               push word [disp]
  7655 0000283F E8DCE0                   call checkConstSize
  7656 00002842 83C402                   add  sp, 2
  7657 00002845 08C0                     or  al, al
  7658 00002847 0F844200                 je .process309
  7659                                  
  7660                                  ;-207                     if (Code1 == 0xE9) {//jmp only
  7661                                  
  7662 0000284B A0[3100]                 mov al, [Code1]
  7663 0000284E 3CE9                     cmp al, 233
  7664 00002850 0F851B00                 jne .process310
  7665                                  
  7666                                  ;-208                         genCode8(0xEB);//short
  7667                                  
  7668 00002854 68EB00                   push 235
  7669 00002857 E85AF9                   call genCode8
  7670 0000285A 83C402                   add  sp, 2
  7671                                  
  7672                                  ;-209                         disp -= 2;
  7673                                  
  7674 0000285D 832E[3E00]02             sub  word[disp], 2
  7675                                  
  7676                                  ;-210                         genCode8(disp);
  7677                                  
  7678 00002862 FF36[3E00]               push word [disp]
  7679 00002866 E84BF9                   call genCode8
  7680 00002869 83C402                   add  sp, 2
  7681                                  
  7682                                  ;-211                     }
  7683                                  
  7684                                  
  7685                                  ;-212                     else {
  7686                                  
  7687 0000286C E91B00                   jmp .process311
  7688                                  .process310:
  7689                                  
  7690                                  ;-213                         genCode8(Code1);//near
  7691                                  
  7692 0000286F A0[3100]                 mov al, byte [Code1]
  7693 00002872 B400                     mov ah, 0
  7694 00002874 50                       push ax
  7695 00002875 E83CF9                   call genCode8
  7696 00002878 83C402                   add  sp, 2
  7697                                  
  7698                                  ;-214                         disp -= 3;
  7699                                  
  7700 0000287B 832E[3E00]03             sub  word[disp], 3
  7701                                  
  7702                                  ;-215                         genCode16(disp);
  7703                                  
  7704 00002880 FF36[3E00]               push word [disp]
  7705 00002884 E884F9                   call genCode16
  7706 00002887 83C402                   add  sp, 2
  7707                                  
  7708                                  ;-216                     }
  7709                                  
  7710                                  
  7711                                  ;-217                 }
  7712                                  
  7713                                  .process311:
  7714                                  
  7715                                  ;-218                 else {
  7716                                  
  7717 0000288A E91B00                   jmp .process312
  7718                                  .process309:
  7719                                  
  7720                                  ;-219                     genCode8(Code1);//near
  7721                                  
  7722 0000288D A0[3100]                 mov al, byte [Code1]
  7723 00002890 B400                     mov ah, 0
  7724 00002892 50                       push ax
  7725 00002893 E81EF9                   call genCode8
  7726 00002896 83C402                   add  sp, 2
  7727                                  
  7728                                  ;-220                     disp -= 3;
  7729                                  
  7730 00002899 832E[3E00]03             sub  word[disp], 3
  7731                                  
  7732                                  ;-221                     genCode16(disp);
  7733                                  
  7734 0000289E FF36[3E00]               push word [disp]
  7735 000028A2 E866F9                   call genCode16
  7736 000028A5 83C402                   add  sp, 2
  7737                                  
  7738                                  ;-222                 }
  7739                                  
  7740                                  
  7741                                  ;-223             }
  7742                                  
  7743                                  .process312:
  7744                                  
  7745                                  ;-224             else {//jump forward, near only
  7746                                  
  7747 000028A8 E91D00                   jmp .process313
  7748                                  .process308:
  7749                                  
  7750                                  ;-225                 genCode8(Code1);
  7751                                  
  7752 000028AB A0[3100]                 mov al, byte [Code1]
  7753 000028AE B400                     mov ah, 0
  7754 000028B0 50                       push ax
  7755 000028B1 E800F9                   call genCode8
  7756 000028B4 83C402                   add  sp, 2
  7757                                  
  7758                                  ;-226                 genCode16(0);
  7759                                  
  7760 000028B7 6A00                     push 0
  7761 000028B9 E84FF9                   call genCode16
  7762 000028BC 83C402                   add  sp, 2
  7763                                  
  7764                                  ;-227                 PrintRA='*';
  7765                                  
  7766 000028BF B82A00                   mov ax, 42
  7767 000028C2 A2[4600]                 mov byte [PrintRA], al
  7768                                  
  7769                                  ;-228                 storeJmpCall();
  7770                                  
  7771 000028C5 E827E2                   call storeJmpCall
  7772                                  
  7773                                  ;-229             }
  7774                                  
  7775                                  
  7776                                  ;-230         return;
  7777                                  
  7778                                  .process313:
  7779 000028C8 E91F03                   jmp .retnprocess
  7780                                  
  7781                                  ;-231         }
  7782                                  
  7783                                  
  7784                                  ;-232     }
  7785                                  
  7786                                  .process307:
  7787                                  
  7788                                  ;-233 
  7789                                  
  7790                                  
  7791                                  ;-234     if (CodeType ==  8) {//ret,retf
  7792                                  
  7793                                  .process306:
  7794 000028CB A0[3000]                 mov al, [CodeType]
  7795 000028CE 3C08                     cmp al, 8
  7796 000028D0 0F853100                 jne .process314
  7797                                  
  7798                                  ;-235         if (TokeType == DIGIT) {
  7799                                  
  7800 000028D4 A0[2D00]                 mov al, [TokeType]
  7801 000028D7 3C01                     cmp al, 1
  7802 000028D9 0F851900                 jne .process315
  7803                                  
  7804                                  ;-236             genCode8(Code2);
  7805                                  
  7806 000028DD A0[3200]                 mov al, byte [Code2]
  7807 000028E0 B400                     mov ah, 0
  7808 000028E2 50                       push ax
  7809 000028E3 E8CEF8                   call genCode8
  7810 000028E6 83C402                   add  sp, 2
  7811                                  
  7812                                  ;-237             genCode16(SymbolInt);
  7813                                  
  7814 000028E9 FF36[0F00]               push word [SymbolInt]
  7815 000028ED E81BF9                   call genCode16
  7816 000028F0 83C402                   add  sp, 2
  7817                                  
  7818                                  ;-238             return;
  7819                                  
  7820 000028F3 E9F402                   jmp .retnprocess
  7821                                  
  7822                                  ;-239         }
  7823                                  
  7824                                  
  7825                                  ;-240         genCode8(Code1);
  7826                                  
  7827                                  .process315:
  7828 000028F6 A0[3100]                 mov al, byte [Code1]
  7829 000028F9 B400                     mov ah, 0
  7830 000028FB 50                       push ax
  7831 000028FC E8B5F8                   call genCode8
  7832 000028FF 83C402                   add  sp, 2
  7833                                  
  7834                                  ;-241         return;
  7835                                  
  7836 00002902 E9E502                   jmp .retnprocess
  7837                                  
  7838                                  ;-242     }
  7839                                  
  7840                                  
  7841                                  ;-243 
  7842                                  
  7843                                  
  7844                                  ;-244     if (CodeType == 9) {//push, pop
  7845                                  
  7846                                  .process314:
  7847 00002905 A0[3000]                 mov al, [CodeType]
  7848 00002908 3C09                     cmp al, 9
  7849 0000290A 0F850301                 jne .process316
  7850                                  
  7851                                  ;-245         getOpL();
  7852                                  
  7853 0000290E E877DC                   call getOpL
  7854                                  
  7855                                  ;-246         if (Code1 == 0x50) {//push only
  7856                                  
  7857 00002911 A0[3100]                 mov al, [Code1]
  7858 00002914 3C50                     cmp al, 80
  7859 00002916 0F853D00                 jne .process317
  7860                                  
  7861                                  ;-247             if (Op == IMM) {//push imm8,16
  7862                                  
  7863 0000291A A0[2E00]                 mov al, [Op]
  7864 0000291D 3C01                     cmp al, 1
  7865 0000291F 0F853400                 jne .process318
  7866                                  
  7867                                  ;-248                 setsflag();
  7868                                  
  7869 00002923 E89CDF                   call setsflag
  7870                                  
  7871                                  ;-249                 genCode2(0x68, sflag);
  7872                                  
  7873 00002926 A0[3B00]                 mov al, byte [sflag]
  7874 00002929 B400                     mov ah, 0
  7875 0000292B 50                       push ax
  7876 0000292C 6A68                     push 104
  7877 0000292E E84CF8                   call genCode2
  7878 00002931 83C404                   add  sp, 4
  7879                                  
  7880                                  ;-250                 if (sflag) genCode8 (imme);
  7881                                  
  7882 00002934 A0[3B00]                 mov al, [sflag]
  7883 00002937 08C0                     or  al, al
  7884 00002939 0F840D00                 je .process319
  7885 0000293D FF36[4000]               push word [imme]
  7886 00002941 E870F8                   call genCode8
  7887 00002944 83C402                   add  sp, 2
  7888                                  
  7889                                  ;-251                 else       genCode16(imme);
  7890                                  
  7891 00002947 E90A00                   jmp .process320
  7892                                  .process319:
  7893 0000294A FF36[4000]               push word [imme]
  7894 0000294E E8BAF8                   call genCode16
  7895 00002951 83C402                   add  sp, 2
  7896                                  
  7897                                  ;-252                 return;
  7898                                  
  7899                                  .process320:
  7900 00002954 E99302                   jmp .retnprocess
  7901                                  
  7902                                  ;-253             }
  7903                                  
  7904                                  
  7905                                  ;-254         }
  7906                                  
  7907                                  .process318:
  7908                                  
  7909                                  ;-255         if (R1Type == SEGREG) {
  7910                                  
  7911                                  .process317:
  7912 00002957 A0[3700]                 mov al, [R1Type]
  7913 0000295A 3C04                     cmp al, 4
  7914 0000295C 0F855A00                 jne .process321
  7915                                  
  7916                                  ;-256             if (Code1 == 0x58) {
  7917                                  
  7918 00002960 A0[3100]                 mov al, [Code1]
  7919 00002963 3C58                     cmp al, 88
  7920 00002965 0F851200                 jne .process322
  7921                                  
  7922                                  ;-257                 if (R1No == 1) error1("pop cs not allowed");
  7923                                  
  7924 00002969 A0[3500]                 mov al, [R1No]
  7925 0000296C 3C01                     cmp al, 1
  7926 0000296E 0F850900                 jne .process323
  7927 00002972 68[EC2B]                 push process_0
  7928 00002975 E832F1                   call error1
  7929 00002978 83C402                   add  sp, 2
  7930                                  
  7931                                  ;-258             }
  7932                                  
  7933                                  .process323:
  7934                                  
  7935                                  ;-259             c = R1No <<3;
  7936                                  
  7937                                  .process322:
  7938 0000297B A0[3500]                 mov al, [R1No]
  7939 0000297E C0E003                   shl al, 3
  7940 00002981 8846FE                   mov [bp-2], al
  7941                                  
  7942                                  ;-260             if (R1No > 3) {//FS, GS
  7943                                  
  7944 00002984 A0[3500]                 mov al, [R1No]
  7945 00002987 3C03                     cmp al, 3
  7946 00002989 0F8E0C00                 jle .process324
  7947                                  
  7948                                  ;-261                 c += 122;
  7949                                  
  7950 0000298D 8046FE7A                 add  byte[bp-2], 122
  7951                                  
  7952                                  ;-262                 genCode8(0x0F);
  7953                                  
  7954 00002991 6A0F                     push 15
  7955 00002993 E81EF8                   call genCode8
  7956 00002996 83C402                   add  sp, 2
  7957                                  
  7958                                  ;-263             }
  7959                                  
  7960                                  
  7961                                  ;-264             OpCodePtr++;
  7962                                  
  7963                                  .process324:
  7964 00002999 FF06[4400]               inc  word[OpCodePtr]
  7965                                  
  7966                                  ;-265             c = c + *OpCodePtr;//is Code4
  7967                                  
  7968 0000299D 8A46FE                   mov al, [bp-2]
  7969 000029A0 8B1E[4400]               mov bx, [OpCodePtr]
  7970 000029A4 0207                     add al, [bx]
  7971 000029A6 B400                     mov ah, 0
  7972 000029A8 8846FE                   mov [bp-2], al
  7973                                  
  7974                                  ;-266             genCode8(c);
  7975                                  
  7976 000029AB 8A46FE                   mov al, byte [bp-2]
  7977 000029AE B400                     mov ah, 0
  7978 000029B0 50                       push ax
  7979 000029B1 E800F8                   call genCode8
  7980 000029B4 83C402                   add  sp, 2
  7981                                  
  7982                                  ;-267             return;
  7983                                  
  7984 000029B7 E93002                   jmp .retnprocess
  7985                                  
  7986                                  ;-268         }
  7987                                  
  7988                                  
  7989                                  ;-269         checkOpL();
  7990                                  
  7991                                  .process321:
  7992 000029BA E8EEDA                   call checkOpL
  7993                                  
  7994                                  ;-270         if (R1Type == BYTE) reg16error();
  7995                                  
  7996 000029BD A0[3700]                 mov al, [R1Type]
  7997 000029C0 3C01                     cmp al, 1
  7998 000029C2 0F850300                 jne .process325
  7999 000029C6 E851F2                   call reg16error
  8000                                  
  8001                                  ;-271         if (R1Type == WORD) {
  8002                                  
  8003                                  .process325:
  8004 000029C9 A0[3700]                 mov al, [R1Type]
  8005 000029CC 3C02                     cmp al, 2
  8006 000029CE 0F851500                 jne .process326
  8007                                  
  8008                                  ;-272             genCode2(Code1, R1No);
  8009                                  
  8010 000029D2 A0[3500]                 mov al, byte [R1No]
  8011 000029D5 B400                     mov ah, 0
  8012 000029D7 50                       push ax
  8013 000029D8 A0[3100]                 mov al, byte [Code1]
  8014 000029DB B400                     mov ah, 0
  8015 000029DD 50                       push ax
  8016 000029DE E89CF7                   call genCode2
  8017 000029E1 83C404                   add  sp, 4
  8018                                  
  8019                                  ;-273             return;
  8020                                  
  8021 000029E4 E90302                   jmp .retnprocess
  8022                                  
  8023                                  ;-274         }
  8024                                  
  8025                                  
  8026                                  ;-275         if (Op == MEM) {
  8027                                  
  8028                                  .process326:
  8029 000029E7 A0[2E00]                 mov al, [Op]
  8030 000029EA 3C04                     cmp al, 4
  8031 000029EC 0F851B00                 jne .process327
  8032                                  
  8033                                  ;-276             genCode8(Code2);
  8034                                  
  8035 000029F0 A0[3200]                 mov al, byte [Code2]
  8036 000029F3 B400                     mov ah, 0
  8037 000029F5 50                       push ax
  8038 000029F6 E8BBF7                   call genCode8
  8039 000029F9 83C402                   add  sp, 2
  8040                                  
  8041                                  ;-277             writeEA(Code3);
  8042                                  
  8043 000029FC A0[3300]                 mov al, byte [Code3]
  8044 000029FF B400                     mov ah, 0
  8045 00002A01 50                       push ax
  8046 00002A02 E851F8                   call writeEA
  8047 00002A05 83C402                   add  sp, 2
  8048                                  
  8049                                  ;-278             return;
  8050                                  
  8051 00002A08 E9DF01                   jmp .retnprocess
  8052                                  
  8053                                  ;-279         }
  8054                                  
  8055                                  
  8056                                  ;-280         syntaxerror();
  8057                                  
  8058                                  .process327:
  8059 00002A0B E85BF2                   call syntaxerror
  8060                                  
  8061                                  ;-281         return;
  8062                                  
  8063 00002A0E E9D901                   jmp .retnprocess
  8064                                  
  8065                                  ;-282     }
  8066                                  
  8067                                  
  8068                                  ;-283 
  8069                                  
  8070                                  
  8071                                  ;-284     if (CodeType == 11) {//shift, rotate
  8072                                  
  8073                                  .process316:
  8074 00002A11 A0[3000]                 mov al, [CodeType]
  8075 00002A14 3C0B                     cmp al, 11
  8076 00002A16 0F859200                 jne .process328
  8077                                  
  8078                                  ;-285         check2Ops();
  8079                                  
  8080 00002A1A E810DB                   call check2Ops
  8081                                  
  8082                                  ;-286         if (Op2 == IMM) {
  8083                                  
  8084 00002A1D A0[2F00]                 mov al, [Op2]
  8085 00002A20 3C01                     cmp al, 1
  8086 00002A22 0F854400                 jne .process329
  8087                                  
  8088                                  ;-287             if (imme == 1) {
  8089                                  
  8090 00002A26 A1[4000]                 mov ax, [imme]
  8091 00002A29 83F801                   cmp ax, 1
  8092 00002A2C 0F851800                 jne .process330
  8093                                  
  8094                                  ;-288                 genCodeW(0xD0);
  8095                                  
  8096 00002A30 68D000                   push 208
  8097 00002A33 E862F7                   call genCodeW
  8098 00002A36 83C402                   add  sp, 2
  8099                                  
  8100                                  ;-289                 writeEA(Code1);
  8101                                  
  8102 00002A39 A0[3100]                 mov al, byte [Code1]
  8103 00002A3C B400                     mov ah, 0
  8104 00002A3E 50                       push ax
  8105 00002A3F E814F8                   call writeEA
  8106 00002A42 83C402                   add  sp, 2
  8107                                  
  8108                                  ;-290                 return;
  8109                                  
  8110 00002A45 E9A201                   jmp .retnprocess
  8111                                  
  8112                                  ;-291             }
  8113                                  
  8114                                  
  8115                                  ;-292             genCodeW(0xC0);//80186
  8116                                  
  8117                                  .process330:
  8118 00002A48 68C000                   push 192
  8119 00002A4B E84AF7                   call genCodeW
  8120 00002A4E 83C402                   add  sp, 2
  8121                                  
  8122                                  ;-293             writeEA(Code1);
  8123                                  
  8124 00002A51 A0[3100]                 mov al, byte [Code1]
  8125 00002A54 B400                     mov ah, 0
  8126 00002A56 50                       push ax
  8127 00002A57 E8FCF7                   call writeEA
  8128 00002A5A 83C402                   add  sp, 2
  8129                                  
  8130                                  ;-294             genCode8(imme);
  8131                                  
  8132 00002A5D FF36[4000]               push word [imme]
  8133 00002A61 E850F7                   call genCode8
  8134 00002A64 83C402                   add  sp, 2
  8135                                  
  8136                                  ;-295             return;
  8137                                  
  8138 00002A67 E98001                   jmp .retnprocess
  8139                                  
  8140                                  ;-296         }
  8141                                  
  8142                                  
  8143                                  ;-297         if (Op2 == REG) {
  8144                                  
  8145                                  .process329:
  8146 00002A6A A0[2F00]                 mov al, [Op2]
  8147 00002A6D 3C02                     cmp al, 2
  8148 00002A6F 0F853900                 jne .process331
  8149                                  
  8150                                  ;-298             if (R2Type == BYTE) {
  8151                                  
  8152 00002A73 A0[3600]                 mov al, [R2Type]
  8153 00002A76 3C01                     cmp al, 1
  8154 00002A78 0F853000                 jne .process332
  8155                                  
  8156                                  ;-299                 if (R2No == 1) {//CL-REG
  8157                                  
  8158 00002A7C A0[3400]                 mov al, [R2No]
  8159 00002A7F 3C01                     cmp al, 1
  8160 00002A81 0F852700                 jne .process333
  8161                                  
  8162                                  ;-300                     if (R1Type == WORD) wflag=1;//hack
  8163                                  
  8164 00002A85 A0[3700]                 mov al, [R1Type]
  8165 00002A88 3C02                     cmp al, 2
  8166 00002A8A 0F850600                 jne .process334
  8167 00002A8E B80100                   mov ax, 1
  8168 00002A91 A2[3900]                 mov byte [wflag], al
  8169                                  
  8170                                  ;-301                     genCodeW(0xD2);
  8171                                  
  8172                                  .process334:
  8173 00002A94 68D200                   push 210
  8174 00002A97 E8FEF6                   call genCodeW
  8175 00002A9A 83C402                   add  sp, 2
  8176                                  
  8177                                  ;-302                     writeEA(Code1);
  8178                                  
  8179 00002A9D A0[3100]                 mov al, byte [Code1]
  8180 00002AA0 B400                     mov ah, 0
  8181 00002AA2 50                       push ax
  8182 00002AA3 E8B0F7                   call writeEA
  8183 00002AA6 83C402                   add  sp, 2
  8184                                  
  8185                                  ;-303                     return;
  8186                                  
  8187 00002AA9 E93E01                   jmp .retnprocess
  8188                                  
  8189                                  ;-304                 }
  8190                                  
  8191                                  
  8192                                  ;-305             }
  8193                                  
  8194                                  .process333:
  8195                                  
  8196                                  ;-306         }
  8197                                  
  8198                                  .process332:
  8199                                  
  8200                                  ;-307     }
  8201                                  
  8202                                  .process331:
  8203                                  
  8204                                  ;-308 
  8205                                  
  8206                                  
  8207                                  ;-309     if (CodeType == 12) {//int
  8208                                  
  8209                                  .process328:
  8210 00002AAC A0[3000]                 mov al, [CodeType]
  8211 00002AAF 3C0C                     cmp al, 12
  8212 00002AB1 0F852200                 jne .process335
  8213                                  
  8214                                  ;-310         if (TokeType == DIGIT) {
  8215                                  
  8216 00002AB5 A0[2D00]                 mov al, [TokeType]
  8217 00002AB8 3C01                     cmp al, 1
  8218 00002ABA 0F851900                 jne .process336
  8219                                  
  8220                                  ;-311             genCode8(Code1);
  8221                                  
  8222 00002ABE A0[3100]                 mov al, byte [Code1]
  8223 00002AC1 B400                     mov ah, 0
  8224 00002AC3 50                       push ax
  8225 00002AC4 E8EDF6                   call genCode8
  8226 00002AC7 83C402                   add  sp, 2
  8227                                  
  8228                                  ;-312             genCode8(SymbolInt);
  8229                                  
  8230 00002ACA FF36[0F00]               push word [SymbolInt]
  8231 00002ACE E8E3F6                   call genCode8
  8232 00002AD1 83C402                   add  sp, 2
  8233                                  
  8234                                  ;-313             return;
  8235                                  
  8236 00002AD4 E91301                   jmp .retnprocess
  8237                                  
  8238                                  ;-314         }
  8239                                  
  8240                                  
  8241                                  ;-315     }
  8242                                  
  8243                                  .process336:
  8244                                  
  8245                                  ;-316 
  8246                                  
  8247                                  
  8248                                  ;-317     if (CodeType == 30) {//enter i18,i8
  8249                                  
  8250                                  .process335:
  8251 00002AD7 A0[3000]                 mov al, [CodeType]
  8252 00002ADA 3C1E                     cmp al, 30
  8253 00002ADC 0F855200                 jne .process337
  8254                                  
  8255                                  ;-318         genCode8(0xC8);
  8256                                  
  8257 00002AE0 68C800                   push 200
  8258 00002AE3 E8CEF6                   call genCode8
  8259 00002AE6 83C402                   add  sp, 2
  8260                                  
  8261                                  ;-319         Op=getOp1();
  8262                                  
  8263 00002AE9 E84DDB                   call getOp1
  8264 00002AEC A2[2E00]                 mov byte [Op], al
  8265                                  
  8266                                  ;-320         if (Op == IMM) genCode16(SymbolInt);
  8267                                  
  8268 00002AEF A0[2E00]                 mov al, [Op]
  8269 00002AF2 3C01                     cmp al, 1
  8270 00002AF4 0F850D00                 jne .process338
  8271 00002AF8 FF36[0F00]               push word [SymbolInt]
  8272 00002AFC E80CF7                   call genCode16
  8273 00002AFF 83C402                   add  sp, 2
  8274                                  
  8275                                  ;-321         else numbererror();
  8276                                  
  8277 00002B02 E90300                   jmp .process339
  8278                                  .process338:
  8279 00002B05 E8CEF0                   call numbererror
  8280                                  
  8281                                  ;-322         need(',');
  8282                                  
  8283                                  .process339:
  8284 00002B08 6A2C                     push 44
  8285 00002B0A E811E4                   call need
  8286 00002B0D 83C402                   add  sp, 2
  8287                                  
  8288                                  ;-323         Op=getOp1();
  8289                                  
  8290 00002B10 E826DB                   call getOp1
  8291 00002B13 A2[2E00]                 mov byte [Op], al
  8292                                  
  8293                                  ;-324         if (Op == IMM) genCode8 (SymbolInt);
  8294                                  
  8295 00002B16 A0[2E00]                 mov al, [Op]
  8296 00002B19 3C01                     cmp al, 1
  8297 00002B1B 0F850D00                 jne .process340
  8298 00002B1F FF36[0F00]               push word [SymbolInt]
  8299 00002B23 E88EF6                   call genCode8
  8300 00002B26 83C402                   add  sp, 2
  8301                                  
  8302                                  ;-325         else numbererror();
  8303                                  
  8304 00002B29 E90300                   jmp .process341
  8305                                  .process340:
  8306 00002B2C E8A7F0                   call numbererror
  8307                                  
  8308                                  ;-326         return;
  8309                                  
  8310                                  .process341:
  8311 00002B2F E9B800                   jmp .retnprocess
  8312                                  
  8313                                  ;-327     }
  8314                                  
  8315                                  
  8316                                  ;-328 
  8317                                  
  8318                                  
  8319                                  ;-329     if (CodeType==101) {//ORG nn
  8320                                  
  8321                                  .process337:
  8322 00002B32 A0[3000]                 mov al, [CodeType]
  8323 00002B35 3C65                     cmp al, 101
  8324 00002B37 0F851500                 jne .process342
  8325                                  
  8326                                  ;-330         if (TokeType != DIGIT) numbererror();
  8327                                  
  8328 00002B3B A0[2D00]                 mov al, [TokeType]
  8329 00002B3E 3C01                     cmp al, 1
  8330 00002B40 0F840300                 je  .process343
  8331 00002B44 E88FF0                   call numbererror
  8332                                  
  8333                                  ;-331         Origin=SymbolInt;
  8334                                  
  8335                                  .process343:
  8336 00002B47 A1[0F00]                 mov ax, [SymbolInt]
  8337 00002B4A A3[2600]                 mov word [Origin], ax
  8338                                  
  8339                                  ;-332         return;
  8340                                  
  8341 00002B4D E99A00                   jmp .retnprocess
  8342                                  
  8343                                  ;-333     }
  8344                                  
  8345                                  
  8346                                  ;-334 
  8347                                  
  8348                                  
  8349                                  ;-335     if (CodeType == 102) {//section, segment
  8350                                  
  8351                                  .process342:
  8352 00002B50 A0[3000]                 mov al, [CodeType]
  8353 00002B53 3C66                     cmp al, 102
  8354 00002B55 0F850900                 jne .process344
  8355                                  
  8356                                  ;-336         //getTokeType();//ignore .bss .text .data
  8357                                  
  8358                                  
  8359                                  ;-337         AbsoluteLab=0;//nasm resets erevy time
  8360                                  
  8361 00002B59 B80000                   mov ax, 0
  8362 00002B5C A3[2800]                 mov word [AbsoluteLab], ax
  8363                                  
  8364                                  ;-338         return;
  8365                                  
  8366 00002B5F E98800                   jmp .retnprocess
  8367                                  
  8368                                  ;-339     }
  8369                                  
  8370                                  
  8371                                  ;-340 
  8372                                  
  8373                                  
  8374                                  ;-341     if (CodeType == 110) {//absolute
  8375                                  
  8376                                  .process344:
  8377 00002B62 A0[3000]                 mov al, [CodeType]
  8378 00002B65 3C6E                     cmp al, 110
  8379 00002B67 0F851500                 jne .process345
  8380                                  
  8381                                  ;-342         if (TokeType != DIGIT) numbererror();
  8382                                  
  8383 00002B6B A0[2D00]                 mov al, [TokeType]
  8384 00002B6E 3C01                     cmp al, 1
  8385 00002B70 0F840300                 je  .process346
  8386 00002B74 E85FF0                   call numbererror
  8387                                  
  8388                                  ;-343         AbsoluteLab=SymbolInt;
  8389                                  
  8390                                  .process346:
  8391 00002B77 A1[0F00]                 mov ax, [SymbolInt]
  8392 00002B7A A3[2800]                 mov word [AbsoluteLab], ax
  8393                                  
  8394                                  ;-344         return;
  8395                                  
  8396 00002B7D E96A00                   jmp .retnprocess
  8397                                  
  8398                                  ;-345     }
  8399                                  
  8400                                  
  8401                                  ;-346     if (CodeType == 111) {//name: PROC
  8402                                  
  8403                                  .process345:
  8404 00002B80 A0[3000]                 mov al, [CodeType]
  8405 00002B83 3C6F                     cmp al, 111
  8406 00002B85 0F853200                 jne .process347
  8407                                  
  8408                                  ;-347         if (isInProc == 0)  {
  8409                                  
  8410 00002B89 A0[0E00]                 mov al, [isInProc]
  8411 00002B8C 3C00                     cmp al, 0
  8412 00002B8E 0F851D00                 jne .process348
  8413                                  
  8414                                  ;-348           prs("\n;entering: ");
  8415                                  
  8416 00002B92 68[FF2B]                 push process_1
  8417 00002B95 E8C0ED                   call prs
  8418 00002B98 83C402                   add  sp, 2
  8419                                  
  8420                                  ;-349           prs(ProcName);
  8421                                  
  8422 00002B9B 8D066E75                 lea  ax, [ProcName]
  8423 00002B9F 50                       push ax
  8424 00002BA0 E8B5ED                   call prs
  8425 00002BA3 83C402                   add  sp, 2
  8426                                  
  8427                                  ;-350           isInProc=1;
  8428                                  
  8429 00002BA6 B80100                   mov ax, 1
  8430 00002BA9 A2[0E00]                 mov byte [isInProc], al
  8431                                  
  8432                                  ;-351         } else error1("already in proc");
  8433                                  
  8434 00002BAC E90900                   jmp .process349
  8435                                  .process348:
  8436 00002BAF 68[0D2C]                 push process_2
  8437 00002BB2 E8F5EE                   call error1
  8438 00002BB5 83C402                   add  sp, 2
  8439                                  
  8440                                  ;-352         return;
  8441                                  
  8442                                  .process349:
  8443 00002BB8 E92F00                   jmp .retnprocess
  8444                                  
  8445                                  ;-353     }
  8446                                  
  8447                                  
  8448                                  ;-354     if (CodeType == 112) {//ENDP
  8449                                  
  8450                                  .process347:
  8451 00002BBB A0[3000]                 mov al, [CodeType]
  8452 00002BBE 3C70                     cmp al, 112
  8453 00002BC0 0F851D00                 jne .process350
  8454                                  
  8455                                  ;-355       prs("\n;leaving: ");
  8456                                  
  8457 00002BC4 68[1D2C]                 push process_3
  8458 00002BC7 E88EED                   call prs
  8459 00002BCA 83C402                   add  sp, 2
  8460                                  
  8461                                  ;-356       prs(ProcName);
  8462                                  
  8463 00002BCD 8D066E75                 lea  ax, [ProcName]
  8464 00002BD1 50                       push ax
  8465 00002BD2 E883ED                   call prs
  8466 00002BD5 83C402                   add  sp, 2
  8467                                  
  8468                                  ;-357       isInProc=0;
  8469                                  
  8470 00002BD8 B80000                   mov ax, 0
  8471 00002BDB A2[0E00]                 mov byte [isInProc], al
  8472                                  
  8473                                  ;-358       return;
  8474                                  
  8475 00002BDE E90900                   jmp .retnprocess
  8476                                  
  8477                                  ;-359     }
  8478                                  
  8479                                  
  8480                                  ;-360     error1("Command not implemented or syntax error");
  8481                                  
  8482                                  .process350:
  8483 00002BE1 68[2A2C]                 push process_4
  8484 00002BE4 E8C3EE                   call error1
  8485 00002BE7 83C402                   add  sp, 2
  8486                                  
  8487                                  ;-361 }
  8488                                  
  8489 00002BEA C9                       .retnprocess: LEAVE
  8490 00002BEB C3                       ret
  8491 00002BEC 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8492 00002BF5 7420616C6C6F776564-
  8493 00002BFE 00                 
  8494 00002BFF 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8495 00002C08 6E673A2000         
  8496 00002C0D 616C72656164792069-     process_2 db "already in proc",0
  8497 00002C16 6E2070726F6300     
  8498 00002C1D 5C6E3B6C656176696E-     process_3 db "\n;leaving: ",0
  8499 00002C26 673A2000           
  8500 00002C2A 436F6D6D616E64206E-     process_4 db "Command not implemented or syntax error",0
  8501 00002C33 6F7420696D706C656D-
  8502 00002C3C 656E746564206F7220-
  8503 00002C45 73796E746178206572-
  8504 00002C4E 726F7200           
  8505                                  ENDP
  8506                                   
  8507                                  ; missing functions: 
  8508                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8509 00002C52 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8510 00002C55 58                      pop ax
  8511 00002C56 C3                      ret
  8512                                   
  8513                                  ;   # type sign width  adr used name   list of global variables
  8514                                  
  8515                                  ;    1 arr sign byte     1    2 Version1[9]
  8516                                  ;    2 var sign byte     1    3 LIST
  8517                                  ;    3 def unsg byte     2    - SYMBOLMAX=31
  8518                                  ;    4 arr sign byte     3   12 Symbol[31]
  8519                                  ;    5 arr sign byte     4   36 SymbolUpper[31]
  8520                                  ;    6 arr sign byte     5    3 ProcName[31]
  8521                                  ;    7 var sign byte     6    5 isInProc
  8522                                  ;    8 var unsg word     7   24 SymbolInt
  8523                                  ;    9 var unsg dwrd     8 NULL SymbolLong
  8524                                  ;   10 def unsg byte     9    - INPUTBUFMAX=255
  8525                                  ;   11 arr sign byte    10    4 InputBuf[255]
  8526                                  ;   12 ptr unsg byte    11   24 InputPtr
  8527                                  ;   13 arr sign byte    12    5 namein[67]
  8528                                  ;   14 arr sign byte    13    6 namelst[67]
  8529                                  ;   15 arr sign byte    14    6 namebin[67]
  8530                                  ;   16 var sign word    15    4 asm_fd
  8531                                  ;   17 var sign word    16    3 lst_fd
  8532                                  ;   18 var sign word    17    3 bin_fd
  8533                                  ;   19 var sign word    18    6 DOS_ERR
  8534                                  ;   20 var sign word    19    4 ErrorCount
  8535                                  ;   21 var sign word    20    4 DOS_NoBytes
  8536                                  ;   22 var sign byte    21    5 DOS_ByteRead
  8537                                  ;   23 var unsg word    23    7 PC
  8538                                  ;   24 var unsg word    24    5 Origin
  8539                                  ;   25 var unsg word    25    6 AbsoluteLab
  8540                                  ;   26 var unsg word    26    2 PCStart
  8541                                  ;   27 var sign byte    27    3 isLabel
  8542                                  ;   28 def unsg byte    28    - DIGIT=1
  8543                                  ;   29 def unsg byte    29    - LETTERE=2
  8544                                  ;   30 def unsg byte    30    - ALNUME=3
  8545                                  ;   31 def unsg byte    31    - NOALNUME=4
  8546                                  ;   32 var sign byte    32   27 TokeType
  8547                                  ;   33 def unsg byte    33    - BYTE=1
  8548                                  ;   34 def unsg byte    34    - WORD=2
  8549                                  ;   35 def unsg byte    35    - DWORD=3
  8550                                  ;   36 def unsg byte    36    - SEGREG=4
  8551                                  ;   37 def unsg byte    37    - IMM=1
  8552                                  ;   38 def unsg byte    38    - REG=2
  8553                                  ;   39 def unsg byte    39    - ADR=3
  8554                                  ;   40 def unsg byte    40    - MEM=4
  8555                                  ;   41 var sign byte    41   28 Op
  8556                                  ;   42 var sign byte    42   31 Op2
  8557                                  ;   43 var sign byte    43   29 CodeType
  8558                                  ;   44 var sign byte    44   23 Code1
  8559                                  ;   45 var sign byte    45    7 Code2
  8560                                  ;   46 var sign byte    46    3 Code3
  8561                                  ;   47 var sign byte    47   19 R2No
  8562                                  ;   48 var sign byte    48   16 R1No
  8563                                  ;   49 var sign byte    49   18 R2Type
  8564                                  ;   50 var sign byte    50   15 R1Type
  8565                                  ;   51 var sign byte    51   14 OpSize
  8566                                  ;   52 var sign byte    52    9 wflag
  8567                                  ;   53 var sign byte    53    3 dflag
  8568                                  ;   54 var sign byte    54    8 sflag
  8569                                  ;   55 var sign byte    55   15 rm
  8570                                  ;   56 var sign byte    56    5 isDirect
  8571                                  ;   57 var sign word    57   48 disp
  8572                                  ;   58 var unsg word    58   13 imme
  8573                                  ;   59 def unsg byte    60    - OPMAXLEN=5
  8574                                  ;   60 arr sign byte    61    2 OpPos[5]
  8575                                  ;   61 var sign word    62    6 OpPrintIndex
  8576                                  ;   62 ptr sign byte    63   19 OpCodePtr
  8577                                  ;   63 var sign byte    64    4 PrintRA
  8578                                  ;   64 def unsg byte    66    - LABELNAMESMAX=3969
  8579                                  ;   65 arr sign byte    67    3 LabelNames[4000]
  8580                                  ;   66 ptr sign byte    68    5 LabelNamePtr
  8581                                  ;   67 def unsg byte    69    - LABELADRMAX=600
  8582                                  ;   68 arr unsg word    70    7 LabelAddr[600]
  8583                                  ;   69 var sign word    71    7 LabelMaxIx
  8584                                  ;   70 var sign word    72   10 LabelIx
  8585                                  ;   71 def unsg byte    74    - JMPCALLNAMESMAX=1969
  8586                                  ;   72 arr sign byte    75    3 JmpCallNames[2000]
  8587                                  ;   73 ptr sign byte    76    5 JmpCallNamePtr
  8588                                  ;   74 def unsg byte    77    - JMPCALLMAX=500
  8589                                  ;   75 arr unsg word    78    2 JmpCallAddr[500]
  8590                                  ;   76 var sign word    79    6 JmpCallMaxIx
  8591                                  ;   77 def unsg byte    81    - FILEBINMAX=20000
  8592                                  ;   78 arr sign byte    82    4 FileBin[20000]
  8593                                  ;   79 var unsg word    83    6 BinLen
  8594                                  ;   80 ptr sign byte    85    1 arglen
  8595                                  ;   81 ptr sign byte    86    4 argv
  8596                                  ;   82 var sign byte     1    1 I_START
  8597                                  ;   83 arr sign byte     4 NULL I_PUSHA[1208]
  8598                                  ;   84 arr sign byte     5 NULL I_NOP[39424]
  8599                                  ;   85 arr sign byte     6 NULL I_CWDE[674]
  8600                                  ;   86 arr sign byte     7 NULL I_CDQ[8125]
  8601                                  ;   87 arr sign byte     8 NULL I_PUSHF[24260]
  8602                                  ;   88 arr sign byte     9 NULL I_SAHF[9734]
  8603                                  ;   89 arr sign byte    10 NULL I_MOVSB[1931]
  8604                                  ;   90 arr sign byte    11 NULL I_CMPSB[35622]
  8605                                  ;   91 arr sign byte    12 NULL I_STOSB[599]
  8606                                  ;   92 arr sign byte    13 NULL I_LODSB[53495]
  8607                                  ;   93 arr sign byte    14 NULL I_SCASB[54007]
  8608                                  ;   94 arr sign byte    15 NULL I_LEAVE[37]
  8609                                  ;   95 arr sign byte    16 NULL I_INTO[19520]
  8610                                  ;   96 arr sign byte    17 NULL I_XLAT[53]
  8611                                  ;   97 arr sign byte    18 NULL I_REPNE[13900]
  8612                                  ;   98 arr sign byte    19 NULL I_REPE[19456]
  8613                                  ;   99 arr sign byte    20 NULL I_HLT[55]
  8614                                  ;  100 arr sign byte    21 NULL I_STC[14412]
  8615                                  ;  101 arr sign byte    22 NULL I_STI[19456]
  8616                                  ;  102 arr sign byte    23 NULL I_STD[56]
  8617                                  ;  103 arr sign byte    25 NULL I_INC[18315]
  8618                                  ;  104 arr sign byte    26 NULL I_DEC[9734]
  8619                                  ;  105 arr sign byte    27 NULL I_NOT[32643]
  8620                                  ;  106 arr sign byte    28 NULL I_NEG[10]
  8621                                  ;  107 arr sign byte    29 NULL I_MUL[1397]
  8622                                  ;  108 arr sign byte    30 NULL I_IMUL[18119]
  8623                                  ;  109 arr sign byte    31 NULL I_DIV[65534]
  8624                                  ;  110 arr sign byte    32 NULL I_IDIV[33791]
  8625                                  ;  111 arr sign byte    34 NULL I_LES[65150]
  8626                                  ;  112 arr sign byte    35 NULL I_LDS[30207]
  8627                                  ;  113 arr sign byte    36 NULL I_LEA[15642]
  8628                                  ;  114 arr sign byte    37 NULL I_LSS[65535]
  8629                                  ;  115 arr sign byte    38 NULL I_LFS[5493]
  8630                                  ;  116 arr sign byte    39 NULL I_LGS[33574]
  8631                                  ;  117 arr sign byte    41 NULL I_ADD[1151]
  8632                                  ;  118 arr sign byte    42 NULL I_OR[29696]
  8633                                  ;  119 arr sign byte    43 NULL I_ADC[35593]
  8634                                  ;  120 arr sign byte    44 NULL I_SBB[2630]
  8635                                  ;  121 arr sign byte    45 NULL I_AND[14630]
  8636                                  ;  122 arr sign byte    46 NULL I_SUB[1095]
  8637                                  ;  123 arr sign byte    47 NULL I_XOR[26997]
  8638                                  ;  124 arr sign byte    48 NULL I_CMP[49203]
  8639                                  ;  125 arr sign byte    49 NULL I_TEST[52169]
  8640                                  ;  126 arr sign byte    51 NULL I_MOV[33680]
  8641                                  ;  127 arr sign byte    52 NULL I_MOVSX[65150]
  8642                                  ;  128 arr sign byte    53 NULL I_MOVZX[29729]
  8643                                  ;  129 arr sign byte    55 NULL I_JO[33618]
  8644                                  ;  130 arr sign byte    56 NULL I_JNO[65150]
  8645                                  ;  131 arr sign byte    57 NULL I_JB[29731]
  8646                                  ;  132 arr sign byte    58 NULL I_JNB[33612]
  8647                                  ;  133 arr sign byte    59 NULL I_JAE[65150]
  8648                                  ;  134 arr sign byte    60 NULL I_JE[29732]
  8649                                  ;  135 arr sign byte    61 NULL I_JNE[33606]
  8650                                  ;  136 arr sign byte    62 NULL I_JBE[65150]
  8651                                  ;  137 arr sign byte    63 NULL I_JA[29734]
  8652                                  ;  138 arr sign byte    64 NULL I_JS[33600]
  8653                                  ;  139 arr sign byte    65 NULL I_JNS[65150]
  8654                                  ;  140 arr sign byte    66 NULL I_JP[29730]
  8655                                  ;  141 arr sign byte    67 NULL I_JNP[33594]
  8656                                  ;  142 arr sign byte    68 NULL I_JL[65150]
  8657                                  ;  143 arr sign byte    69 NULL I_JNL[29737]
  8658                                  ;  144 arr sign byte    70 NULL I_JLE[33588]
  8659                                  ;  145 arr sign byte    71 NULL I_JG[65150]
  8660                                  ;  146 arr sign byte    73 NULL I_JMP[29736]
  8661                                  ;  147 arr sign byte    74 NULL I_CALL[33582]
  8662                                  ;  148 arr sign byte    76 NULL I_RET[65150]
  8663                                  ;  149 arr sign byte    77 NULL I_RETF[29733]
  8664                                  ;  150 arr sign byte    79 NULL I_PUSH[15656]
  8665                                  ;  151 arr sign byte    80 NULL I_POP[33]
  8666                                  ;  152 arr sign byte    82 NULL I_ROL[9076]
  8667                                  ;  153 arr sign byte    83 NULL I_RCL[9021]
  8668                                  ;  154 arr sign byte    84 NULL I_SHL[29696]
  8669                                  ;  155 arr sign byte    85 NULL I_SHR[15646]
  8670                                  ;  156 arr sign byte    87 NULL I_INT[36]
  8671                                  ;  157 arr sign byte    89 NULL I_IN[6516]
  8672                                  ;  158 arr sign byte    90 NULL I_INSB[9789]
  8673                                  ;  159 arr sign byte    91 NULL I_INSW[29696]
  8674                                  ;  160 arr sign byte    92 NULL I_INSD[15636]
  8675                                  ;  161 arr sign byte    93 NULL I_OUT[34]
  8676                                  ;  162 arr sign byte    94 NULL I_OUTSB[3956]
  8677                                  ;  163 arr sign byte    95 NULL I_OUTSW[10557]
  8678                                  ;  164 arr sign byte    96 NULL I_OUTSD[29696]
  8679                                  ;  165 arr sign byte    98 NULL I_XCHG[15626]
  8680                                  ;  166 arr sign byte   100 NULL I_LOOPNZ[40]
  8681                                  ;  167 arr sign byte   101 NULL I_LOOPNE[1396]
  8682                                  ;  168 arr sign byte   102 NULL I_LOOPZ[9533]
  8683                                  ;  169 arr sign byte   103 NULL I_LOOPE[29952]
  8684                                  ;  170 arr sign byte   104 NULL I_LOOP[33542]
  8685                                  ;  171 arr sign byte   105 NULL I_JCXZ[2686]
  8686                                  ;  172 arr sign byte   106 NULL I_JECXZ[60176]
  8687                                  ;  173 arr sign byte   108 NULL I_ENTER[33540]
  8688                                  ;  174 arr sign byte   110 NULL I_ORG[2686]
  8689                                  ;  175 arr sign byte   112 NULL I_SECTION[29984]
  8690                                  ;  176 arr sign byte   113 NULL I_SEGMENT[47255]
  8691                                  ;  177 arr sign byte   114 NULL I_ABSOLUTE[1]
  8692                                  ;  178 arr sign byte   115 NULL I_PROC[52169]
  8693                                  ;  179 arr sign byte   116 NULL I_ENDP[21904]
  8694                                  ;  180 arr sign byte   117 NULL I_DB[60555]
  8695                                  ;  181 arr sign byte   118 NULL I_DW[5816]
  8696                                  ;  182 arr sign byte   119 NULL I_DD[39424]
  8697                                  ;  183 arr sign byte   120 NULL I_RESB[674]
  8698                                  ;  184 arr sign byte   121 NULL I_RESW[8125]
  8699                                  ;  185 arr sign byte   122 NULL I_RESD[51030]
  8700                                  ;  186 var sign byte   123 NULL I_END
  8701                                  
  8702                                  
  8703                                  ;   # Calls Line Width  Name   list of functions
  8704                                  
  8705                                  ;    0    2    1   ChangeDirection
  8706                                  ;    1    2    9   checkOpL
  8707                                  ;    2    4   18   check2Ops
  8708                                  ;    3    1   27   get2Ops
  8709                                  ;    4    3   33   getOpL
  8710                                  ;    5    2   41   getOpR
  8711                                  ;    6    4   51   getOp1
  8712                                  ;    7    1   67   getMEM
  8713                                  ;    8    1   90   getIndReg1
  8714                                  ;    9    1   98   getIndReg2
  8715                                  ;   10    2  108   setwflag
  8716                                  ;   11    2  119   setsflag
  8717                                  ;   12    2  129   checkConstSize
  8718                                  ;   13    1    1   parse
  8719                                  ;   14   16   37   getTokeType
  8720                                  ;   15    2   48   storeJmpCall
  8721                                  ;   16    2   59   storeLabel
  8722                                  ;   17    5   71   searchLabel
  8723                                  ;   18    1   84   getVariable
  8724                                  ;   19    2  137   lookCode
  8725                                  ;   20    1  153   getCodeSize
  8726                                  ;   21    9  161   isToken
  8727                                  ;   22    2  169   need
  8728                                  ;   23    1  178   skipRest
  8729                                  ;   24    4    1   writetty
  8730                                  ;   25    1    2   putch
  8731                                  ;   26    8    3   cputs
  8732                                  ;   27    6    5   DosInt
  8733                                  ;   28    1   10   openR
  8734                                  ;   29    2   11   creatR
  8735                                  ;   30    3   12   fcloseR
  8736                                  ;   31    5   13   exitR
  8737                                  ;   32    2   14   readRL
  8738                                  ;   33    2   15   fputcR
  8739                                  ;   34    1   18   getLine
  8740                                  ;   35    1   34   ifEOL
  8741                                  ;   36    3   43   skipBlank
  8742                                  ;   37    2   48   letterE
  8743                                  ;   38    1   58   alnumE
  8744                                  ;   39    3   63   digit
  8745                                  ;   40    4   68   strlen
  8746                                  ;   41    9   73   strcpy
  8747                                  ;   42   35   79   eqstr
  8748                                  ;   43    3   88   strcat1
  8749                                  ;   44    2   92   toupper
  8750                                  ;   45    1   99   getDigit
  8751                                  ;   46    1  111   getName
  8752                                  ;   47    1  130   testReg
  8753                                  ;   48    1    1   printLine
  8754                                  ;   49    7   23   prc
  8755                                  ;   50    1   35   prscomment
  8756                                  ;   51   32   43   prs
  8757                                  ;   52    3   65   printhex8a
  8758                                  ;   53    2   70   printhex4
  8759                                  ;   54    1   75   printhex16
  8760                                  ;   55    5   80   printIntU
  8761                                  ;   56   27   91   error1
  8762                                  ;   57   13   99   errorexit
  8763                                  ;   58 NULL  104   allowederror
  8764                                  ;   59    3  105   addrerror
  8765                                  ;   60    1  106   immeerror
  8766                                  ;   61    2  107   implerror
  8767                                  ;   62    4  108   indexerror
  8768                                  ;   63    3  109   invaloperror
  8769                                  ;   64    6  110   numbererror
  8770                                  ;   65    1  111   regmemerror
  8771                                  ;   66    3  112   reg16error
  8772                                  ;   67    1  113   segregerror
  8773                                  ;   68    5  114   syntaxerror
  8774                                  ;   69 NULL  116   addrexit
  8775                                  ;   70    3  117   dataexit
  8776                                  ;   71 NULL  118   internexit
  8777                                  ;   72 NULL    1   main
  8778                                  ;   73    1    9   getarg
  8779                                  ;   74    1   43   fixJmpCall
  8780                                  ;   75    2   74   epilog
  8781                                  ;   76    2  122   end1
  8782                                  ;   77    1    2   getCodes
  8783                                  ;   78    1    7   gen66h
  8784                                  ;   79    8    9   genCode2
  8785                                  ;   80   13   13   genCodeW
  8786                                  ;   81   33   17   genCode8
  8787                                  ;   82   17   28   genCode16
  8788                                  ;   83    1   32   genCode32
  8789                                  ;   84   13   36   writeEA
  8790                                  ;   85    4   78   genImmediate
  8791                                  ;   86    1   11   process
  8792                                  ;   87 NULL  361   LastFunctionByt
  8793                                  
  8794                                  ;    #  addr name   list of CALLs
  8795                                  
  8796                                  ;    0     0 implerror
  8797                                  ;    1    10 segregerror
  8798                                  ;    2    22 setwflag
  8799                                  ;    3    31 error1
  8800                                  ;    4    38 error1
  8801                                  ;    5    45 get2Ops
  8802                                  ;    6    53 addrerror
  8803                                  ;    7    63 invaloperror
  8804                                  ;    8    76 immeerror
  8805                                  ;    9    86 addrerror
  8806                                  ;   10    96 invaloperror
  8807                                  ;   11   109 setwflag
  8808                                  ;   12   118 getOpL
  8809                                  ;   13   125 need
  8810                                  ;   14   130 getOpR
  8811                                  ;   15   137 getOpR
  8812                                  ;   16   144 getOp1
  8813                                  ;   17   151 isToken
  8814                                  ;   18   159 getMEM
  8815                                  ;   19   166 invaloperror
  8816                                  ;   20   179 error1
  8817                                  ;   21   186 testReg
  8818                                  ;   22   194 searchLabel
  8819                                  ;   23   206 error1
  8820                                  ;   24   213 getTokeType
  8821                                  ;   25   225 getOp1
  8822                                  ;   26   232 syntaxerror
  8823                                  ;   27   244 getIndReg2
  8824                                  ;   28   255 getIndReg1
  8825                                  ;   29   266 isToken
  8826                                  ;   30   274 getTokeType
  8827                                  ;   31   286 numbererror
  8828                                  ;   32   298 isToken
  8829                                  ;   33   306 isToken
  8830                                  ;   34   314 errorexit
  8831                                  ;   35   324 indexerror
  8832                                  ;   36   335 indexerror
  8833                                  ;   37   346 indexerror
  8834                                  ;   38   357 indexerror
  8835                                  ;   39   368 gen66h
  8836                                  ;   40   375 error1
  8837                                  ;   41   382 getLine
  8838                                  ;   42   390 getTokeType
  8839                                  ;   43   402 strcpy
  8840                                  ;   44   409 storeLabel
  8841                                  ;   45   420 getTokeType
  8842                                  ;   46   432 lookCode
  8843                                  ;   47   441 process
  8844                                  ;   48   449 getVariable
  8845                                  ;   49   461 skipRest
  8846                                  ;   50   470 error1
  8847                                  ;   51   477 error1
  8848                                  ;   52   484 printLine
  8849                                  ;   53   494 skipBlank
  8850                                  ;   54   504 digit
  8851                                  ;   55   510 getDigit
  8852                                  ;   56   519 letterE
  8853                                  ;   57   527 getName
  8854                                  ;   58   535 errorexit
  8855                                  ;   59   545 strcpy
  8856                                  ;   60   552 errorexit
  8857                                  ;   61   562 errorexit
  8858                                  ;   62   572 searchLabel
  8859                                  ;   63   584 error1
  8860                                  ;   64   591 strcpy
  8861                                  ;   65   598 errorexit
  8862                                  ;   66   608 eqstr
  8863                                  ;   67   614 strlen
  8864                                  ;   68   621 storeLabel
  8865                                  ;   69   632 getTokeType
  8866                                  ;   70   644 lookCode
  8867                                  ;   71   653 dataexit
  8868                                  ;   72   662 dataexit
  8869                                  ;   73   671 getTokeType
  8870                                  ;   74   683 genCode8
  8871                                  ;   75   692 skipBlank
  8872                                  ;   76   702 isToken
  8873                                  ;   77   710 genCode8
  8874                                  ;   78   719 isToken
  8875                                  ;   79   727 getTokeType
  8876                                  ;   80   739 genCode16
  8877                                  ;   81   749 isToken
  8878                                  ;   82   757 getTokeType
  8879                                  ;   83   769 genCode16
  8880                                  ;   84   779 genCode16
  8881                                  ;   85   789 isToken
  8882                                  ;   86   797 getTokeType
  8883                                  ;   87   809 syntaxerror
  8884                                  ;   88   821 error1
  8885                                  ;   89   828 numbererror
  8886                                  ;   90   840 dataexit
  8887                                  ;   91   849 eqstr
  8888                                  ;   92   855 eqstr
  8889                                  ;   93   861 getTokeType
  8890                                  ;   94   873 eqstr
  8891                                  ;   95   879 getTokeType
  8892                                  ;   96   891 eqstr
  8893                                  ;   97   897 getTokeType
  8894                                  ;   98   909 skipBlank
  8895                                  ;   99   919 isToken
  8896                                  ;  100   927 getTokeType
  8897                                  ;  101   939 error1
  8898                                  ;  102   946 prs
  8899                                  ;  103   950 prc
  8900                                  ;  104   954 getTokeType
  8901                                  ;  105   966 error1
  8902                                  ;  106   973 writetty
  8903                                  ;  107   982 writetty
  8904                                  ;  108   991 putch
  8905                                  ;  109   997 DosInt
  8906                                  ;  110  1004 DosInt
  8907                                  ;  111  1011 DosInt
  8908                                  ;  112  1018 DosInt
  8909                                  ;  113  1025 DosInt
  8910                                  ;  114  1032 DosInt
  8911                                  ;  115  1039 readRL
  8912                                  ;  116  1046 errorexit
  8913                                  ;  117  1056 errorexit
  8914                                  ;  118  1066 ifEOL
  8915                                  ;  119  1072 readRL
  8916                                  ;  120  1079 errorexit
  8917                                  ;  121  1089 digit
  8918                                  ;  122  1095 letterE
  8919                                  ;  123  1103 strcpy
  8920                                  ;  124  1110 digit
  8921                                  ;  125  1116 alnumE
  8922                                  ;  126  1123 errorexit
  8923                                  ;  127  1133 strcpy
  8924                                  ;  128  1140 toupper
  8925                                  ;  129  1148 strlen
  8926                                  ;  130  1155 strlen
  8927                                  ;  131  1162 eqstr
  8928                                  ;  132  1168 eqstr
  8929                                  ;  133  1174 eqstr
  8930                                  ;  134  1180 eqstr
  8931                                  ;  135  1186 eqstr
  8932                                  ;  136  1192 eqstr
  8933                                  ;  137  1198 eqstr
  8934                                  ;  138  1204 eqstr
  8935                                  ;  139  1210 eqstr
  8936                                  ;  140  1216 eqstr
  8937                                  ;  141  1222 eqstr
  8938                                  ;  142  1228 eqstr
  8939                                  ;  143  1234 eqstr
  8940                                  ;  144  1240 eqstr
  8941                                  ;  145  1246 eqstr
  8942                                  ;  146  1252 eqstr
  8943                                  ;  147  1258 eqstr
  8944                                  ;  148  1264 eqstr
  8945                                  ;  149  1270 eqstr
  8946                                  ;  150  1276 eqstr
  8947                                  ;  151  1282 eqstr
  8948                                  ;  152  1288 eqstr
  8949                                  ;  153  1294 eqstr
  8950                                  ;  154  1300 eqstr
  8951                                  ;  155  1306 eqstr
  8952                                  ;  156  1312 eqstr
  8953                                  ;  157  1318 eqstr
  8954                                  ;  158  1324 eqstr
  8955                                  ;  159  1330 eqstr
  8956                                  ;  160  1336 eqstr
  8957                                  ;  161  1342 prs
  8958                                  ;  162  1346 printhex16
  8959                                  ;  163  1357 prs
  8960                                  ;  164  1361 prc
  8961                                  ;  165  1365 printhex8a
  8962                                  ;  166  1376 prs
  8963                                  ;  167  1380 prc
  8964                                  ;  168  1384 prscomment
  8965                                  ;  169  1395 writetty
  8966                                  ;  170  1404 writetty
  8967                                  ;  171  1413 fputcR
  8968                                  ;  172  1420 prc
  8969                                  ;  173  1424 prc
  8970                                  ;  174  1428 printhex4
  8971                                  ;  175  1438 printhex4
  8972                                  ;  176  1448 prc
  8973                                  ;  177  1452 printhex8a
  8974                                  ;  178  1463 printhex8a
  8975                                  ;  179  1474 printIntU
  8976                                  ;  180  1484 prc
  8977                                  ;  181  1488 prs
  8978                                  ;  182  1492 prs
  8979                                  ;  183  1496 prs
  8980                                  ;  184  1500 prs
  8981                                  ;  185  1504 error1
  8982                                  ;  186  1511 epilog
  8983                                  ;  187  1518 end1
  8984                                  ;  188  1523 error1
  8985                                  ;  189  1530 error1
  8986                                  ;  190  1537 error1
  8987                                  ;  191  1544 error1
  8988                                  ;  192  1551 error1
  8989                                  ;  193  1558 error1
  8990                                  ;  194  1565 error1
  8991                                  ;  195  1572 error1
  8992                                  ;  196  1579 error1
  8993                                  ;  197  1586 error1
  8994                                  ;  198  1593 error1
  8995                                  ;  199  1600 errorexit
  8996                                  ;  200  1610 errorexit
  8997                                  ;  201  1620 errorexit
  8998                                  ;  202  1630 getarg
  8999                                  ;  203  1637 parse
  9000                                  ;  204  1643 fixJmpCall
  9001                                  ;  205  1654 epilog
  9002                                  ;  206  1661 end1
  9003                                  ;  207  1666 cputs
  9004                                  ;  208  1672 cputs
  9005                                  ;  209  1678 exitR
  9006                                  ;  210  1684 toupper
  9007                                  ;  211  1692 strcpy
  9008                                  ;  212  1699 strcat1
  9009                                  ;  213  1707 strcpy
  9010                                  ;  214  1714 strcat1
  9011                                  ;  215  1722 strcpy
  9012                                  ;  216  1729 strcat1
  9013                                  ;  217  1737 openR
  9014                                  ;  218  1743 cputs
  9015                                  ;  219  1749 cputs
  9016                                  ;  220  1755 exitR
  9017                                  ;  221  1761 creatR
  9018                                  ;  222  1768 cputs
  9019                                  ;  223  1774 cputs
  9020                                  ;  224  1780 exitR
  9021                                  ;  225  1786 creatR
  9022                                  ;  226  1793 cputs
  9023                                  ;  227  1799 cputs
  9024                                  ;  228  1805 exitR
  9025                                  ;  229  1811 prs
  9026                                  ;  230  1815 prs
  9027                                  ;  231  1819 prs
  9028                                  ;  232  1823 prs
  9029                                  ;  233  1827 prs
  9030                                  ;  234  1831 prs
  9031                                  ;  235  1835 prs
  9032                                  ;  236  1839 prs
  9033                                  ;  237  1843 prs
  9034                                  ;  238  1847 prs
  9035                                  ;  239  1851 printIntU
  9036                                  ;  240  1861 strcpy
  9037                                  ;  241  1868 strlen
  9038                                  ;  242  1875 searchLabel
  9039                                  ;  243  1887 error1
  9040                                  ;  244  1894 prs
  9041                                  ;  245  1898 printIntU
  9042                                  ;  246  1908 prs
  9043                                  ;  247  1912 prs
  9044                                  ;  248  1916 prs
  9045                                  ;  249  1920 prs
  9046                                  ;  250  1924 prs
  9047                                  ;  251  1928 prs
  9048                                  ;  252  1932 printIntU
  9049                                  ;  253  1942 prs
  9050                                  ;  254  1946 fputcR
  9051                                  ;  255  1953 prs
  9052                                  ;  256  1957 printIntU
  9053                                  ;  257  1967 prs
  9054                                  ;  258  1971 fcloseR
  9055                                  ;  259  1979 fcloseR
  9056                                  ;  260  1987 fcloseR
  9057                                  ;  261  1995 exitR
  9058                                  ;  262  2001 genCode8
  9059                                  ;  263  2010 genCode8
  9060                                  ;  264  2019 genCode8
  9061                                  ;  265  2028 errorexit
  9062                                  ;  266  2038 genCode8
  9063                                  ;  267  2047 genCode8
  9064                                  ;  268  2056 genCode16
  9065                                  ;  269  2066 genCode16
  9066                                  ;  270  2076 genCode8
  9067                                  ;  271  2085 genCode8
  9068                                  ;  272  2094 genCode16
  9069                                  ;  273  2104 genCode32
  9070                                  ;  274  2114 genCode16
  9071                                  ;  275  2124 genCode8
  9072                                  ;  276  2133 getTokeType
  9073                                  ;  277  2145 getCodeSize
  9074                                  ;  278  2157 getCodes
  9075                                  ;  279  2166 genCode8
  9076                                  ;  280  2175 getOpL
  9077                                  ;  281  2182 checkOpL
  9078                                  ;  282  2191 genCode2
  9079                                  ;  283  2200 getTokeType
  9080                                  ;  284  2212 implerror
  9081                                  ;  285  2222 genCodeW
  9082                                  ;  286  2231 writeEA
  9083                                  ;  287  2239 check2Ops
  9084                                  ;  288  2249 reg16error
  9085                                  ;  289  2260 addrerror
  9086                                  ;  290  2270 genCode8
  9087                                  ;  291  2279 genCode8
  9088                                  ;  292  2288 writeEA
  9089                                  ;  293  2296 check2Ops
  9090                                  ;  294  2306 setsflag
  9091                                  ;  295  2315 genCodeW
  9092                                  ;  296  2324 genImmediate
  9093                                  ;  297  2337 genCodeW
  9094                                  ;  298  2346 writeEA
  9095                                  ;  299  2354 genCode8
  9096                                  ;  300  2363 genImmediate
  9097                                  ;  301  2376 genCodeW
  9098                                  ;  302  2385 writeEA
  9099                                  ;  303  2393 genCodeW
  9100                                  ;  304  2402 writeEA
  9101                                  ;  305  2410 syntaxerror
  9102                                  ;  306  2422 check2Ops
  9103                                  ;  307  2432 genCode2
  9104                                  ;  308  2441 genImmediate
  9105                                  ;  309  2454 genCodeW
  9106                                  ;  310  2463 writeEA
  9107                                  ;  311  2471 genImmediate
  9108                                  ;  312  2484 regmemerror
  9109                                  ;  313  2496 ChangeDirection
  9110                                  ;  314  2512 reg16error
  9111                                  ;  315  2523 genCode2
  9112                                  ;  316  2532 writeEA
  9113                                  ;  317  2540 genCodeW
  9114                                  ;  318  2549 genCode16
  9115                                  ;  319  2559 genCodeW
  9116                                  ;  320  2568 genCode16
  9117                                  ;  321  2578 genCodeW
  9118                                  ;  322  2587 writeEA
  9119                                  ;  323  2595 ChangeDirection
  9120                                  ;  324  2611 genCodeW
  9121                                  ;  325  2620 writeEA
  9122                                  ;  326  2628 syntaxerror
  9123                                  ;  327  2640 searchLabel
  9124                                  ;  328  2652 checkConstSize
  9125                                  ;  329  2667 genCode2
  9126                                  ;  330  2676 genCode8
  9127                                  ;  331  2685 genCode8
  9128                                  ;  332  2694 genCode2
  9129                                  ;  333  2703 genCode16
  9130                                  ;  334  2713 genCode8
  9131                                  ;  335  2722 genCode2
  9132                                  ;  336  2731 genCode16
  9133                                  ;  337  2741 storeJmpCall
  9134                                  ;  338  2754 searchLabel
  9135                                  ;  339  2766 checkConstSize
  9136                                  ;  340  2781 genCode8
  9137                                  ;  341  2790 genCode8
  9138                                  ;  342  2799 genCode8
  9139                                  ;  343  2808 genCode16
  9140                                  ;  344  2818 genCode8
  9141                                  ;  345  2827 genCode16
  9142                                  ;  346  2837 genCode8
  9143                                  ;  347  2846 genCode16
  9144                                  ;  348  2856 storeJmpCall
  9145                                  ;  349  2869 genCode8
  9146                                  ;  350  2878 genCode16
  9147                                  ;  351  2888 genCode8
  9148                                  ;  352  2897 getOpL
  9149                                  ;  353  2904 setsflag
  9150                                  ;  354  2913 genCode2
  9151                                  ;  355  2922 genCode8
  9152                                  ;  356  2931 genCode16
  9153                                  ;  357  2941 error1
  9154                                  ;  358  2948 genCode8
  9155                                  ;  359  2957 genCode8
  9156                                  ;  360  2966 checkOpL
  9157                                  ;  361  2975 reg16error
  9158                                  ;  362  2986 genCode2
  9159                                  ;  363  2995 genCode8
  9160                                  ;  364  3004 writeEA
  9161                                  ;  365  3012 syntaxerror
  9162                                  ;  366  3024 check2Ops
  9163                                  ;  367  3034 genCodeW
  9164                                  ;  368  3043 writeEA
  9165                                  ;  369  3051 genCodeW
  9166                                  ;  370  3060 writeEA
  9167                                  ;  371  3068 genCode8
  9168                                  ;  372  3077 genCodeW
  9169                                  ;  373  3086 writeEA
  9170                                  ;  374  3094 genCode8
  9171                                  ;  375  3103 genCode8
  9172                                  ;  376  3112 genCode8
  9173                                  ;  377  3121 getOp1
  9174                                  ;  378  3128 genCode16
  9175                                  ;  379  3138 numbererror
  9176                                  ;  380  3150 need
  9177                                  ;  381  3155 getOp1
  9178                                  ;  382  3162 genCode8
  9179                                  ;  383  3171 numbererror
  9180                                  ;  384  3183 numbererror
  9181                                  ;  385  3195 numbererror
  9182                                  ;  386  3207 prs
  9183                                  ;  387  3211 prs
  9184                                  ;  388  3215 error1
  9185                                  ;  389  3222 prs
  9186                                  ;  390  3226 prs
  9187                                  ;  391  3230 error1
  9188                                  ;Input: AS.C, List: AS.S,  Lines:  362
  9189                                  ;Glob. variables:  186 max.:  200
  9190                                  ;Functions      :   88 max.:  300
  9191                                  ;Calls          :  392 max.: 2000, NameField: 3237 max.:    65535
  9192                                  ;Code until     :21667 max.: 30000, free: 8333
  9193                                  ;Data (HeapEnd) :58754, resting stacksize:  6781
  9194                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
