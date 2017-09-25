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
   721                                  ;-82 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   722                                  
   723 00000342 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   724                                  
   725                                  ;-83 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   726                                  
   727 00000349 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   728                                  
   729                                  ;-84 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   730                                  
   731 00000350 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   732                                  
   733                                  ;-85 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   734                                  
   735 00000357 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   736                                  
   737                                  ;-86 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   738                                  
   739 0000035E 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   740                                  
   741                                  ;-87 char I_SAL[]=  {'S','A','L',0,          11, 4,    0xF1};
   742                                  
   743 00000365 53414C000B04F1          I_SAL db 83,65,76,0,11,4,241
   744                                  
   745                                  ;-88 char I_SHR[]=  {'S','H','R',0,          11, 5,    0xF1};
   746                                  
   747 0000036C 534852000B05F1          I_SHR db 83,72,82,0,11,5,241
   748                                  
   749                                  ;-89 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   750                                  
   751 00000373 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   752                                  
   753                                  ;-90 //  12: int
   754                                  
   755                                  
   756                                  ;-91 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   757                                  
   758 0000037A 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   759                                  
   760                                  ;-92 //  14: in/out
   761                                  
   762                                  
   763                                  ;-93 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   764                                  
   765 00000382 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   766                                  
   767                                  ;-94 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   768                                  
   769 00000389 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   770                                  
   771                                  ;-95 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   772                                  
   773 00000391 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   774                                  
   775                                  ;-96 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   776                                  
   777 00000399 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   778                                  
   779                                  ;-97 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   780                                  
   781 000003A1 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   782                                  
   783                                  ;-98 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   784                                  
   785 000003A9 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   786                                  
   787                                  ;-99 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   788                                  
   789 000003B1 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   790                                  
   791                                  ;-100 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   792                                  
   793 000003B9 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   794                                  
   795                                  ;-101 //  15: xchg
   796                                  
   797                                  
   798                                  ;-102 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   799                                  
   800 000003C1 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   801                                  
   802                                  ;-103 //  16: loop, jcxz
   803                                  
   804                                  
   805                                  ;-104 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   806                                  
   807 000003CA 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   808 000003D3 F1                 
   809                                  
   810                                  ;-105 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   811                                  
   812 000003D4 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   813 000003DD F1                 
   814                                  
   815                                  ;-106 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   816                                  
   817 000003DE 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   818                                  
   819                                  ;-107 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   820                                  
   821 000003E7 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   822                                  
   823                                  ;-108 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   824                                  
   825 000003F0 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   826                                  
   827                                  ;-109 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   828                                  
   829 000003F8 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   830                                  
   831                                  ;-110 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   832                                  
   833 00000400 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   834                                  
   835                                  ;-111 //  30: enter
   836                                  
   837                                  
   838                                  ;-112 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
   839                                  
   840 00000409 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   841                                  
   842                                  ;-113 // 100: directives
   843                                  
   844                                  
   845                                  ;-114 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   846                                  
   847 00000411 4F52470065F1            I_ORG db 79,82,71,0,101,241
   848                                  
   849                                  ;-115 // section, segment .TEXT .DATA .BSS
   850                                  
   851                                  
   852                                  ;-116 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   853                                  
   854 00000417 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   855 00000420 F1                 
   856                                  
   857                                  ;-117 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   858                                  
   859 00000421 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   860 0000042A F1                 
   861                                  
   862                                  ;-118 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   863                                  
   864 0000042B 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   865 00000434 6EF1               
   866                                  
   867                                  ;-119 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
   868                                  
   869 00000436 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
   870                                  
   871                                  ;-120 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
   872                                  
   873 0000043D 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
   874                                  
   875                                  ;-121 char I_DB[]=   {'D','B',0,            200,        0xF1};
   876                                  
   877 00000444 444200C8F1              I_DB db 68,66,0,200,241
   878                                  
   879                                  ;-122 char I_DW[]=   {'D','W',0,            201,        0xF1};
   880                                  
   881 00000449 445700C9F1              I_DW db 68,87,0,201,241
   882                                  
   883                                  ;-123 char I_DD[]=   {'D','D',0,            202,        0xF1};
   884                                  
   885 0000044E 444400CAF1              I_DD db 68,68,0,202,241
   886                                  
   887                                  ;-124 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   888                                  
   889 00000453 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   890                                  
   891                                  ;-125 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   892                                  
   893 0000045A 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   894                                  
   895                                  ;-126 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   896                                  
   897 00000461 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   898                                  
   899                                  ;-127 char I_END=0;// end of table char
   900                                  
   901 00000468 00                      I_END db 0
   902                                  ;Back to main program: AS.C
   903                                  
   904                                  ;-4 #include "OPS.C"
   905                                  
   906                                  ;Use include file: OPS.C
   907                                  
   908                                  ;-1 int ChangeDirection() {
   909                                  
   910                                  
   911                                  ChangeDirection: PROC
   912                                  
   913                                  ;-2     char c;
   914                                  
   915                                  
   916                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   917                                  
   918                                  ;Function : ChangeDirection, Number of local variables: 1
   919                                  ;   # type sign width addr used name   list of local variables
   920                                  ;  200 var sign byte     2 NULL c = bp-2;
   921 00000469 C8020000                 ENTER  2,0
   922 0000046D A0[2E00]                 mov al, [Op]
   923 00000470 8846FE                   mov [bp-2], al
   924 00000473 A0[2F00]                 mov al, [Op2]
   925 00000476 A2[2E00]                 mov byte [Op], al
   926 00000479 8A46FE                   mov al, [bp-2]
   927 0000047C A2[2F00]                 mov byte [Op2], al
   928                                  
   929                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   930                                  
   931 0000047F A0[3700]                 mov al, [R1Type]
   932 00000482 8846FE                   mov [bp-2], al
   933 00000485 A0[3600]                 mov al, [R2Type]
   934 00000488 A2[3700]                 mov byte [R1Type], al
   935 0000048B 8A46FE                   mov al, [bp-2]
   936 0000048E A2[3600]                 mov byte [R2Type], al
   937                                  
   938                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   939                                  
   940 00000491 A0[3500]                 mov al, [R1No]
   941 00000494 8846FE                   mov [bp-2], al
   942 00000497 A0[3400]                 mov al, [R2No]
   943 0000049A A2[3500]                 mov byte [R1No], al
   944 0000049D 8A46FE                   mov al, [bp-2]
   945 000004A0 A2[3400]                 mov byte [R2No], al
   946                                  
   947                                  ;-6     dflag=2;     
   948                                  
   949 000004A3 B80200                   mov ax, 2
   950 000004A6 A2[3A00]                 mov byte [dflag], al
   951                                  
   952                                  ;-7 }
   953                                  
   954                                  
   955                                  ;-8      
   956                                  
   957                                  
   958                                  ;-9 int checkOpL() {
   959 000004A9 C9                       LEAVE
   960 000004AA C3                       ret
   961                                  ENDP
   962                                  
   963                                  checkOpL: PROC
   964                                  
   965                                  ;-10     if (Op == ADR) implerror();
   966                                  
   967 000004AB A0[2E00]                 mov al, [Op]
   968 000004AE 3C03                     cmp al, 3
   969 000004B0 0F850300                 jne .checkOpL1
   970 000004B4 E8C316                   call implerror
   971                                  
   972                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   973                                  
   974                                  .checkOpL1:
   975 000004B7 A0[3700]                 mov al, [R1Type]
   976 000004BA 3C04                     cmp al, 4
   977 000004BC 0F850600                 jne .checkOpL2
   978 000004C0 E87F17                   call segregerror
   979 000004C3 E93E00                   jmp .retncheckOpL
   980                                  
   981                                  ;-12     setwflag();
   982                                  
   983                                  .checkOpL2:
   984 000004C6 E88C03                   call setwflag
   985                                  
   986                                  ;-13     if (OpSize == 0) error1("no op size declared");
   987                                  
   988 000004C9 A0[3800]                 mov al, [OpSize]
   989 000004CC 3C00                     cmp al, 0
   990 000004CE 0F850900                 jne .checkOpL3
   991 000004D2 68[0505]                 push checkOpL_0
   992 000004D5 E8D215                   call error1
   993 000004D8 83C402                   add  sp, 2
   994                                  
   995                                  ;-14     if (OpSize == R1Type) return;
   996                                  
   997                                  .checkOpL3:
   998 000004DB A0[3800]                 mov al, [OpSize]
   999 000004DE 3A06[3700]               cmp al, [R1Type]
  1000 000004E2 0F850300                 jne .checkOpL4
  1001 000004E6 E91B00                   jmp .retncheckOpL
  1002                                  
  1003                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1004                                  
  1005                                  .checkOpL4:
  1006 000004E9 A0[2E00]                 mov al, [Op]
  1007 000004EC 3C02                     cmp al, 2
  1008 000004EE 0F851200                 jne .checkOpL5
  1009 000004F2 A0[3700]                 mov al, [R1Type]
  1010 000004F5 3C00                     cmp al, 0
  1011 000004F7 0F850900                 jne .checkOpL6
  1012 000004FB 68[1905]                 push checkOpL_1
  1013 000004FE E8A915                   call error1
  1014 00000501 83C402                   add  sp, 2
  1015                                  
  1016                                  ;-16 }
  1017                                  
  1018                                  .checkOpL6:
  1019                                  .checkOpL5:
  1020                                  
  1021                                  ;-17     
  1022                                  
  1023                                  
  1024                                  ;-18 int check2Ops() {
  1025                                  
  1026                                   .retncheckOpL:
  1027 00000504 C3                       ret
  1028 00000505 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1029 0000050E 65206465636C617265-
  1030 00000517 6400               
  1031 00000519 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1032 00000522 657220646566696E65-
  1033 0000052B 6400               
  1034                                  ENDP
  1035                                  
  1036                                  check2Ops: PROC
  1037                                  
  1038                                  ;-19     get2Ops();
  1039                                  
  1040 0000052D E84900                   call get2Ops
  1041                                  
  1042                                  ;-20     if (Op ==   0) addrerror();
  1043                                  
  1044 00000530 A0[2E00]                 mov al, [Op]
  1045 00000533 3C00                     cmp al, 0
  1046 00000535 0F850300                 jne .check2Ops7
  1047 00000539 E8FF15                   call addrerror
  1048                                  
  1049                                  ;-21     if (Op == ADR) invaloperror(); 
  1050                                  
  1051                                  .check2Ops7:
  1052 0000053C A0[2E00]                 mov al, [Op]
  1053 0000053F 3C03                     cmp al, 3
  1054 00000541 0F850300                 jne .check2Ops8
  1055 00000545 E86D16                   call invaloperror
  1056                                  
  1057                                  ;-22     if (Op == IMM) immeerror();   
  1058                                  
  1059                                  .check2Ops8:
  1060 00000548 A0[2E00]                 mov al, [Op]
  1061 0000054B 3C01                     cmp al, 1
  1062 0000054D 0F850300                 jne .check2Ops9
  1063 00000551 E80116                   call immeerror
  1064                                  
  1065                                  ;-23     if (Op2==   0) addrerror();
  1066                                  
  1067                                  .check2Ops9:
  1068 00000554 A0[2F00]                 mov al, [Op2]
  1069 00000557 3C00                     cmp al, 0
  1070 00000559 0F850300                 jne .check2Ops10
  1071 0000055D E8DB15                   call addrerror
  1072                                  
  1073                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           
  1074                                  
  1075                                  .check2Ops10:
  1076 00000560 A0[3000]                 mov al, [CodeType]
  1077 00000563 3C05                     cmp al, 5
  1078 00000565 0F840C00                 je  .check2Ops11
  1079 00000569 A0[2F00]                 mov al, [Op2]
  1080 0000056C 3C03                     cmp al, 3
  1081 0000056E 0F850300                 jne .check2Ops12
  1082 00000572 E84016                   call invaloperror
  1083                                  
  1084                                  ;-25     setwflag();       
  1085                                  
  1086                                  .check2Ops12:
  1087                                  .check2Ops11:
  1088 00000575 E8DD02                   call setwflag
  1089                                  
  1090                                  ;-26 }    
  1091                                  
  1092                                  
  1093                                  ;-27 int get2Ops() {
  1094                                  
  1095 00000578 C3                       ret
  1096                                  ENDP
  1097                                  
  1098                                  get2Ops: PROC
  1099                                  
  1100                                  ;-28     getOpL();
  1101                                  
  1102 00000579 E80C00                   call getOpL
  1103                                  
  1104                                  ;-29     need(',');    
  1105                                  
  1106 0000057C 6A2C                     push 44
  1107 0000057E E89D09                   call need
  1108 00000581 83C402                   add  sp, 2
  1109                                  
  1110                                  ;-30     getOpR();         
  1111                                  
  1112 00000584 E82900                   call getOpR
  1113                                  
  1114                                  ;-31 } 
  1115                                  
  1116                                  
  1117                                  ;-32         
  1118                                  
  1119                                  
  1120                                  ;-33 int getOpL() {
  1121                                  
  1122 00000587 C3                       ret
  1123                                  ENDP
  1124                                  
  1125                                  getOpL: PROC
  1126                                  
  1127                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1128                                  
  1129                                  
  1130                                  ;-35     getOpR();
  1131                                  
  1132 00000588 E82500                   call getOpR
  1133                                  
  1134                                  ;-36     Op=Op2;         Op2=0;
  1135                                  
  1136 0000058B A0[2F00]                 mov al, [Op2]
  1137 0000058E A2[2E00]                 mov byte [Op], al
  1138 00000591 B80000                   mov ax, 0
  1139 00000594 A2[2F00]                 mov byte [Op2], al
  1140                                  
  1141                                  ;-37     R1No=R2No;      R2No=0;
  1142                                  
  1143 00000597 A0[3400]                 mov al, [R2No]
  1144 0000059A A2[3500]                 mov byte [R1No], al
  1145 0000059D B80000                   mov ax, 0
  1146 000005A0 A2[3400]                 mov byte [R2No], al
  1147                                  
  1148                                  ;-38     R1Type=R2Type; R2Type=0; 
  1149                                  
  1150 000005A3 A0[3600]                 mov al, [R2Type]
  1151 000005A6 A2[3700]                 mov byte [R1Type], al
  1152 000005A9 B80000                   mov ax, 0
  1153 000005AC A2[3600]                 mov byte [R2Type], al
  1154                                  
  1155                                  ;-39 }  
  1156                                  
  1157                                  
  1158                                  ;-40 
  1159                                  
  1160                                  
  1161                                  ;-41 int getOpR() {
  1162                                  
  1163 000005AF C3                       ret
  1164                                  ENDP
  1165                                  
  1166                                  getOpR: PROC
  1167                                  
  1168                                  ;-42     Op2=getOp1();
  1169                                  
  1170 000005B0 E88600                   call getOp1
  1171 000005B3 A2[2F00]                 mov byte [Op2], al
  1172                                  
  1173                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1174                                  
  1175 000005B6 6A5B                     push 91
  1176 000005B8 E83B09                   call isToken
  1177 000005BB 83C402                   add  sp, 2
  1178 000005BE 08C0                     or  al, al
  1179 000005C0 0F840C00                 je .getOpR13
  1180 000005C4 B80400                   mov ax, 4
  1181 000005C7 A2[2F00]                 mov byte [Op2], al
  1182 000005CA E8E300                   call getMEM
  1183 000005CD E94F00                   jmp .retngetOpR
  1184                                  
  1185                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1186                                  
  1187                                  .getOpR13:
  1188 000005D0 A0[2F00]                 mov al, [Op2]
  1189 000005D3 3C00                     cmp al, 0
  1190 000005D5 0F850600                 jne .getOpR14
  1191 000005D9 E8D915                   call invaloperror
  1192 000005DC E94000                   jmp .retngetOpR
  1193                                  
  1194                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1195                                  
  1196                                  .getOpR14:
  1197 000005DF A0[2F00]                 mov al, [Op2]
  1198 000005E2 3C01                     cmp al, 1
  1199 000005E4 0F850900                 jne .getOpR15
  1200 000005E8 A1[0F00]                 mov ax, [SymbolInt]
  1201 000005EB A3[4000]                 mov word [imme], ax
  1202 000005EE E92E00                   jmp .retngetOpR
  1203                                  
  1204                                  ;-46     if (Op2 == REG)                            return;
  1205                                  
  1206                                  .getOpR15:
  1207 000005F1 A0[2F00]                 mov al, [Op2]
  1208 000005F4 3C02                     cmp al, 2
  1209 000005F6 0F850300                 jne .getOpR16
  1210 000005FA E92200                   jmp .retngetOpR
  1211                                  
  1212                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1213                                  
  1214                                  .getOpR16:
  1215 000005FD A0[2F00]                 mov al, [Op2]
  1216 00000600 3C03                     cmp al, 3
  1217 00000602 0F851000                 jne .getOpR17
  1218 00000606 8B1E[4B00]               mov bx, [LabelIx]
  1219 0000060A D1E3                     shl bx, 1
  1220 0000060C 8B87FA86                 mov ax, [LabelAddr + bx]
  1221 00000610 A3[3E00]                 mov word [disp], ax
  1222 00000613 E90900                   jmp .retngetOpR
  1223                                  
  1224                                  ;-48     error1("Name of operand expected");
  1225                                  
  1226                                  .getOpR17:
  1227 00000616 68[2006]                 push getOpR_0
  1228 00000619 E88E14                   call error1
  1229 0000061C 83C402                   add  sp, 2
  1230                                  
  1231                                  ;-49 }
  1232                                  
  1233                                  
  1234                                  ;-50 
  1235                                  
  1236                                  
  1237                                  ;-51 int getOp1() {//scan for a single operand
  1238                                  
  1239                                   .retngetOpR:
  1240 0000061F C3                       ret
  1241 00000620 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1242 00000629 706572616E64206578-
  1243 00000632 70656374656400     
  1244                                  ENDP
  1245                                  
  1246                                  getOp1: PROC
  1247                                  
  1248                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1249                                  
  1250                                  
  1251                                  ;-53 //set   :R2Type, R2No by testReg
  1252                                  
  1253                                  
  1254                                  ;-54 //set   :LabelIx by searchLabel
  1255                                  
  1256                                  
  1257                                  ;-55     if (TokeType == 0)      return 0;
  1258                                  
  1259 00000639 A0[2D00]                 mov al, [TokeType]
  1260 0000063C 3C00                     cmp al, 0
  1261 0000063E 0F850600                 jne .getOp118
  1262 00000642 B80000                   mov ax, 0
  1263 00000645 E95400                   jmp .retngetOp1
  1264                                  
  1265                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1266                                  
  1267                                  .getOp118:
  1268 00000648 A0[2D00]                 mov al, [TokeType]
  1269 0000064B 3C01                     cmp al, 1
  1270 0000064D 0F850600                 jne .getOp119
  1271 00000651 B80100                   mov ax, 1
  1272 00000654 E94500                   jmp .retngetOp1
  1273                                  
  1274                                  ;-57     if (TokeType == ALNUME) {
  1275                                  
  1276                                  .getOp119:
  1277 00000657 A0[2D00]                 mov al, [TokeType]
  1278 0000065A 3C03                     cmp al, 3
  1279 0000065C 0F853600                 jne .getOp120
  1280                                  
  1281                                  ;-58         R2No=testReg();
  1282                                  
  1283 00000660 E8240E                   call testReg
  1284 00000663 A2[3400]                 mov byte [R2No], al
  1285                                  
  1286                                  ;-59         if (R2Type)        return REG;
  1287                                  
  1288 00000666 A0[3600]                 mov al, [R2Type]
  1289 00000669 08C0                     or  al, al
  1290 0000066B 0F840600                 je .getOp121
  1291 0000066F B80200                   mov ax, 2
  1292 00000672 E92700                   jmp .retngetOp1
  1293                                  
  1294                                  ;-60         LabelIx=searchLabel();
  1295                                  
  1296                                  .getOp121:
  1297 00000675 E8A305                   call searchLabel
  1298 00000678 A3[4B00]                 mov word [LabelIx], ax
  1299                                  
  1300                                  ;-61         if (LabelIx)        return ADR;
  1301                                  
  1302 0000067B A1[4B00]                 mov ax, [LabelIx]
  1303 0000067E 08C0                     or  al, al
  1304 00000680 0F840900                 je .getOp122
  1305 00000684 B80300                   mov ax, 3
  1306 00000687 E91200                   jmp .retngetOp1
  1307                                  
  1308                                  ;-62         else error1("variable not found"); 
  1309                                  
  1310 0000068A E90900                   jmp .getOp123
  1311                                  .getOp122:
  1312 0000068D 68[9D06]                 push getOp1_0
  1313 00000690 E81714                   call error1
  1314 00000693 83C402                   add  sp, 2
  1315                                  
  1316                                  ;-63     }
  1317                                  
  1318                                  .getOp123:
  1319                                  
  1320                                  ;-64     return 0;
  1321                                  
  1322                                  .getOp120:
  1323 00000696 B80000                   mov ax, 0
  1324 00000699 E90000                   jmp .retngetOp1
  1325                                  
  1326                                  ;-65 }
  1327                                  
  1328                                  
  1329                                  ;-66 
  1330                                  
  1331                                  
  1332                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1333                                  
  1334                                   .retngetOp1:
  1335 0000069C C3                       ret
  1336 0000069D 7661726961626C6520-     getOp1_0 db "variable not found",0
  1337 000006A6 6E6F7420666F756E64-
  1338 000006AF 00                 
  1339                                  ENDP
  1340                                  
  1341                                  getMEM: PROC
  1342                                  
  1343                                  ;-68 //set: disp, rm, R2Type
  1344                                  
  1345                                  
  1346                                  ;-69     char c;
  1347                                  
  1348                                  
  1349                                  ;-70     disp=0; rm=0;
  1350                                  
  1351                                  ;Function : getMEM, Number of local variables: 1
  1352                                  ;   # type sign width addr used name   list of local variables
  1353                                  ;  200 var sign byte    69 NULL c = bp-2;
  1354 000006B0 C8020000                 ENTER  2,0
  1355 000006B4 B80000                   mov ax, 0
  1356 000006B7 A3[3E00]                 mov word [disp], ax
  1357 000006BA B80000                   mov ax, 0
  1358 000006BD A2[3C00]                 mov byte [rm], al
  1359                                  
  1360                                  ;-71     do {
  1361                                  
  1362                                  .getMEM24:
  1363                                  
  1364                                  ;-72         getTokeType();
  1365                                  
  1366 000006C0 E8A003                   call getTokeType
  1367                                  
  1368                                  ;-73         c=getOp1();
  1369                                  
  1370 000006C3 E873FF                   call getOp1
  1371 000006C6 8846FE                   mov [bp-2], al
  1372                                  
  1373                                  ;-74         if (c ==   0) syntaxerror();
  1374                                  
  1375 000006C9 8A46FE                   mov al, [bp-2]
  1376 000006CC 3C00                     cmp al, 0
  1377 000006CE 0F850300                 jne .getMEM25
  1378 000006D2 E89415                   call syntaxerror
  1379                                  
  1380                                  ;-75         if (c == REG) {
  1381                                  
  1382                                  .getMEM25:
  1383 000006D5 8A46FE                   mov al, [bp-2]
  1384 000006D8 3C02                     cmp al, 2
  1385 000006DA 0F851B00                 jne .getMEM26
  1386                                  
  1387                                  ;-76             isDirect=0;
  1388                                  
  1389 000006DE B80000                   mov ax, 0
  1390 000006E1 A2[3D00]                 mov byte [isDirect], al
  1391                                  
  1392                                  ;-77             if (rm) rm=getIndReg2();
  1393                                  
  1394 000006E4 A0[3C00]                 mov al, [rm]
  1395 000006E7 08C0                     or  al, al
  1396 000006E9 0F840900                 je .getMEM27
  1397 000006ED E8E700                   call getIndReg2
  1398 000006F0 A2[3C00]                 mov byte [rm], al
  1399                                  
  1400                                  ;-78             else getIndReg1();
  1401                                  
  1402 000006F3 E90300                   jmp .getMEM28
  1403                                  .getMEM27:
  1404 000006F6 E88900                   call getIndReg1
  1405                                  
  1406                                  ;-79         }
  1407                                  
  1408                                  .getMEM28:
  1409                                  
  1410                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1411                                  
  1412                                  .getMEM26:
  1413 000006F9 8A46FE                   mov al, [bp-2]
  1414 000006FC 3C03                     cmp al, 3
  1415 000006FE 0F851000                 jne .getMEM29
  1416 00000702 A1[3E00]                 mov ax, [disp]
  1417 00000705 8B1E[4B00]               mov bx, [LabelIx]
  1418 00000709 D1E3                     shl bx, 1
  1419 0000070B 0387FA86                 add ax, [LabelAddr + bx]
  1420 0000070F A3[3E00]                 mov word [disp], ax
  1421                                  
  1422                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1423                                  
  1424                                  .getMEM29:
  1425 00000712 8A46FE                   mov al, [bp-2]
  1426 00000715 3C01                     cmp al, 1
  1427 00000717 0F850A00                 jne .getMEM30
  1428 0000071B A1[3E00]                 mov ax, [disp]
  1429 0000071E 0306[0F00]               add ax, [SymbolInt]
  1430 00000722 A3[3E00]                 mov word [disp], ax
  1431                                  
  1432                                  ;-82         if (isToken('-')) {
  1433                                  
  1434                                  .getMEM30:
  1435 00000725 6A2D                     push 45
  1436 00000727 E8CC07                   call isToken
  1437 0000072A 83C402                   add  sp, 2
  1438 0000072D 08C0                     or  al, al
  1439 0000072F 0F841900                 je .getMEM31
  1440                                  
  1441                                  ;-83             getTokeType();
  1442                                  
  1443 00000733 E82D03                   call getTokeType
  1444                                  
  1445                                  ;-84             if (TokeType != DIGIT) numbererror();
  1446                                  
  1447 00000736 A0[2D00]                 mov al, [TokeType]
  1448 00000739 3C01                     cmp al, 1
  1449 0000073B 0F840300                 je  .getMEM32
  1450 0000073F E89414                   call numbererror
  1451                                  
  1452                                  ;-85             disp = disp - SymbolInt;
  1453                                  
  1454                                  .getMEM32:
  1455 00000742 A1[3E00]                 mov ax, [disp]
  1456 00000745 2B06[0F00]               sub ax, [SymbolInt]
  1457 00000749 A3[3E00]                 mov word [disp], ax
  1458                                  
  1459                                  ;-86         }
  1460                                  
  1461                                  
  1462                                  ;-87     } while (isToken('+'));
  1463                                  
  1464                                  .getMEM31:
  1465 0000074C 6A2B                     push 43
  1466 0000074E E8A507                   call isToken
  1467 00000751 83C402                   add  sp, 2
  1468 00000754 08C0                     or  al, al
  1469 00000756 0F840300                 je .getMEM33
  1470 0000075A E963FF                   jmp .getMEM24
  1471                                  .getMEM33:
  1472                                  
  1473                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1474                                  
  1475 0000075D 6A5D                     push 93
  1476 0000075F E89407                   call isToken
  1477 00000762 83C402                   add  sp, 2
  1478 00000765 83F800                   cmp ax, 0
  1479 00000768 0F850900                 jne .getMEM34
  1480 0000076C 68[7707]                 push getMEM_0
  1481 0000076F E89413                   call errorexit
  1482 00000772 83C402                   add  sp, 2
  1483                                  
  1484                                  ;-89 }
  1485                                  
  1486                                  .getMEM34:
  1487                                  
  1488                                  ;-90 int getIndReg1() {
  1489 00000775 C9                       LEAVE
  1490 00000776 C3                       ret
  1491 00000777 5D2065787065637465-     getMEM_0 db "] expected",0
  1492 00000780 6400               
  1493                                  ENDP
  1494                                  
  1495                                  getIndReg1: PROC
  1496                                  
  1497                                  ;-91     if (R2Type !=WORD) indexerror();
  1498                                  
  1499 00000782 A0[3600]                 mov al, [R2Type]
  1500 00000785 3C02                     cmp al, 2
  1501 00000787 0F840300                 je  .getIndReg135
  1502 0000078B E80614                   call indexerror
  1503                                  
  1504                                  ;-92     if (R2No==3) rm=7;//BX
  1505                                  
  1506                                  .getIndReg135:
  1507 0000078E A0[3400]                 mov al, [R2No]
  1508 00000791 3C03                     cmp al, 3
  1509 00000793 0F850600                 jne .getIndReg136
  1510 00000797 B80700                   mov ax, 7
  1511 0000079A A2[3C00]                 mov byte [rm], al
  1512                                  
  1513                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1514                                  
  1515                                  .getIndReg136:
  1516 0000079D A0[3400]                 mov al, [R2No]
  1517 000007A0 3C05                     cmp al, 5
  1518 000007A2 0F850600                 jne .getIndReg137
  1519 000007A6 B80600                   mov ax, 6
  1520 000007A9 A2[3C00]                 mov byte [rm], al
  1521                                  
  1522                                  ;-94     if (R2No==7) rm=5;//DI
  1523                                  
  1524                                  .getIndReg137:
  1525 000007AC A0[3400]                 mov al, [R2No]
  1526 000007AF 3C07                     cmp al, 7
  1527 000007B1 0F850600                 jne .getIndReg138
  1528 000007B5 B80500                   mov ax, 5
  1529 000007B8 A2[3C00]                 mov byte [rm], al
  1530                                  
  1531                                  ;-95     if (R2No==6) rm=4;//SI
  1532                                  
  1533                                  .getIndReg138:
  1534 000007BB A0[3400]                 mov al, [R2No]
  1535 000007BE 3C06                     cmp al, 6
  1536 000007C0 0F850600                 jne .getIndReg139
  1537 000007C4 B80400                   mov ax, 4
  1538 000007C7 A2[3C00]                 mov byte [rm], al
  1539                                  
  1540                                  ;-96     if (rm==0) indexerror();
  1541                                  
  1542                                  .getIndReg139:
  1543 000007CA A0[3C00]                 mov al, [rm]
  1544 000007CD 3C00                     cmp al, 0
  1545 000007CF 0F850300                 jne .getIndReg140
  1546 000007D3 E8BE13                   call indexerror
  1547                                  
  1548                                  ;-97 }
  1549                                  
  1550                                  .getIndReg140:
  1551                                  
  1552                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1553                                  
  1554 000007D6 C3                       ret
  1555                                  ENDP
  1556                                  
  1557                                  getIndReg2: PROC
  1558                                  ;Function : getIndReg2, Number of local variables: 1
  1559                                  ;   # type sign width addr used name   list of local variables
  1560                                  ;  200 var sign byte    98 NULL m = bp-2;
  1561 000007D7 C8020000                 ENTER  2,0
  1562 000007DB B80400                   mov ax, 4
  1563 000007DE 8846FE                   mov [bp-2], al
  1564                                  
  1565                                  ;-99     if (R2Type !=WORD) indexerror();
  1566                                  
  1567 000007E1 A0[3600]                 mov al, [R2Type]
  1568 000007E4 3C02                     cmp al, 2
  1569 000007E6 0F840300                 je  .getIndReg241
  1570 000007EA E8A713                   call indexerror
  1571                                  
  1572                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1573                                  
  1574                                  .getIndReg241:
  1575 000007ED A0[3400]                 mov al, [R2No]
  1576 000007F0 3C07                     cmp al, 7
  1577 000007F2 0F852100                 jne .getIndReg242
  1578 000007F6 A0[3C00]                 mov al, [rm]
  1579 000007F9 3C06                     cmp al, 6
  1580 000007FB 0F850900                 jne .getIndReg243
  1581 000007FF B80300                   mov ax, 3
  1582 00000802 8846FE                   mov [bp-2], al
  1583                                  
  1584                                  ;-101              else if (rm==7) m=1;//BX+DI
  1585                                  
  1586 00000805 E90F00                   jmp .getIndReg244
  1587                                  .getIndReg243:
  1588 00000808 A0[3C00]                 mov al, [rm]
  1589 0000080B 3C07                     cmp al, 7
  1590 0000080D 0F850600                 jne .getIndReg245
  1591 00000811 B80100                   mov ax, 1
  1592 00000814 8846FE                   mov [bp-2], al
  1593                                  
  1594                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1595                                  
  1596                                  .getIndReg245:
  1597                                  .getIndReg244:
  1598                                  .getIndReg242:
  1599 00000817 A0[3400]                 mov al, [R2No]
  1600 0000081A 3C06                     cmp al, 6
  1601 0000081C 0F852100                 jne .getIndReg246
  1602 00000820 A0[3C00]                 mov al, [rm]
  1603 00000823 3C06                     cmp al, 6
  1604 00000825 0F850900                 jne .getIndReg247
  1605 00000829 B80200                   mov ax, 2
  1606 0000082C 8846FE                   mov [bp-2], al
  1607                                  
  1608                                  ;-103              else if (rm==7) m=0;//BX+SI
  1609                                  
  1610 0000082F E90F00                   jmp .getIndReg248
  1611                                  .getIndReg247:
  1612 00000832 A0[3C00]                 mov al, [rm]
  1613 00000835 3C07                     cmp al, 7
  1614 00000837 0F850600                 jne .getIndReg249
  1615 0000083B B80000                   mov ax, 0
  1616 0000083E 8846FE                   mov [bp-2], al
  1617                                  
  1618                                  ;-104     if (m > 3) indexerror();
  1619                                  
  1620                                  .getIndReg249:
  1621                                  .getIndReg248:
  1622                                  .getIndReg246:
  1623 00000841 8A46FE                   mov al, [bp-2]
  1624 00000844 3C03                     cmp al, 3
  1625 00000846 0F8E0300                 jle .getIndReg250
  1626 0000084A E84713                   call indexerror
  1627                                  
  1628                                  ;-105     return m;
  1629                                  
  1630                                  .getIndReg250:
  1631 0000084D 8A46FE                   mov al, [bp-2]
  1632 00000850 E90000                   jmp .retngetIndReg2
  1633                                  
  1634                                  ;-106 }
  1635                                  
  1636                                  
  1637                                  ;-107                   
  1638                                  
  1639                                  
  1640                                  ;-108 int setwflag() {//word size, bit 0
  1641                                  
  1642 00000853 C9                       .retngetIndReg2: LEAVE
  1643 00000854 C3                       ret
  1644                                  ENDP
  1645                                  
  1646                                  setwflag: PROC
  1647                                  
  1648                                  ;-109     wflag=0;
  1649                                  
  1650 00000855 B80000                   mov ax, 0
  1651 00000858 A2[3900]                 mov byte [wflag], al
  1652                                  
  1653                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1654                                  
  1655 0000085B A0[3800]                 mov al, [OpSize]
  1656 0000085E 3C00                     cmp al, 0
  1657 00000860 0F853C00                 jne .setwflag51
  1658                                  
  1659                                  ;-111         if (Op == REG) OpSize=R1Type;
  1660                                  
  1661 00000864 A0[2E00]                 mov al, [Op]
  1662 00000867 3C02                     cmp al, 2
  1663 00000869 0F850600                 jne .setwflag52
  1664 0000086D A0[3700]                 mov al, [R1Type]
  1665 00000870 A2[3800]                 mov byte [OpSize], al
  1666                                  
  1667                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1668                                  
  1669                                  .setwflag52:
  1670 00000873 A0[2F00]                 mov al, [Op2]
  1671 00000876 3C02                     cmp al, 2
  1672 00000878 0F850600                 jne .setwflag53
  1673 0000087C A0[3600]                 mov al, [R2Type]
  1674 0000087F A2[3800]                 mov byte [OpSize], al
  1675                                  
  1676                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1677                                  
  1678                                  .setwflag53:
  1679 00000882 A0[3600]                 mov al, [R2Type]
  1680 00000885 3C04                     cmp al, 4
  1681 00000887 0F850600                 jne .setwflag54
  1682 0000088B B80200                   mov ax, 2
  1683 0000088E A2[3800]                 mov byte [OpSize], al
  1684                                  
  1685                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1686                                  
  1687                                  .setwflag54:
  1688 00000891 A0[3700]                 mov al, [R1Type]
  1689 00000894 3C04                     cmp al, 4
  1690 00000896 0F850600                 jne .setwflag55
  1691 0000089A B80200                   mov ax, 2
  1692 0000089D A2[3800]                 mov byte [OpSize], al
  1693                                  
  1694                                  ;-115     }
  1695                                  
  1696                                  .setwflag55:
  1697                                  
  1698                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1699                                  
  1700                                  .setwflag51:
  1701 000008A0 A0[3800]                 mov al, [OpSize]
  1702 000008A3 3C03                     cmp al, 3
  1703 000008A5 0F850900                 jne .setwflag56
  1704 000008A9 E8C818                   call gen66h
  1705 000008AC B80100                   mov ax, 1
  1706 000008AF A2[3900]                 mov byte [wflag], al
  1707                                  
  1708                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1709                                  
  1710                                  .setwflag56:
  1711 000008B2 A0[3800]                 mov al, [OpSize]
  1712 000008B5 3C02                     cmp al, 2
  1713 000008B7 0F850600                 jne .setwflag57
  1714 000008BB B80100                   mov ax, 1
  1715 000008BE A2[3900]                 mov byte [wflag], al
  1716                                  
  1717                                  ;-118 }
  1718                                  
  1719                                  .setwflag57:
  1720                                  
  1721                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1722                                  
  1723 000008C1 C3                       ret
  1724                                  ENDP
  1725                                  
  1726                                  setsflag: PROC
  1727                                  
  1728                                  ;-120     unsigned int ui;    
  1729                                  
  1730                                  
  1731                                  ;-121     sflag=2;   
  1732                                  
  1733                                  ;Function : setsflag, Number of local variables: 1
  1734                                  ;   # type sign width addr used name   list of local variables
  1735                                  ;  200 var unsg word   120 NULL ui = bp-2;
  1736 000008C2 C8020000                 ENTER  2,0
  1737 000008C6 B80200                   mov ax, 2
  1738 000008C9 A2[3B00]                 mov byte [sflag], al
  1739                                  
  1740                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1741                                  
  1742 000008CC A1[4000]                 mov ax, [imme]
  1743 000008CF 2580FF                   and ax, 65408
  1744 000008D2 8946FE                   mov [bp-2], ax
  1745                                  
  1746                                  ;-123     if(ui != 0) sflag = 0;
  1747                                  
  1748 000008D5 8B46FE                   mov ax, [bp-2]
  1749 000008D8 83F800                   cmp ax, 0
  1750 000008DB 0F840600                 je  .setsflag58
  1751 000008DF B80000                   mov ax, 0
  1752 000008E2 A2[3B00]                 mov byte [sflag], al
  1753                                  
  1754                                  ;-124     if (OpSize == BYTE) {
  1755                                  
  1756                                  .setsflag58:
  1757 000008E5 A0[3800]                 mov al, [OpSize]
  1758 000008E8 3C01                     cmp al, 1
  1759 000008EA 0F851900                 jne .setsflag59
  1760                                  
  1761                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1762                                  
  1763 000008EE A1[4000]                 mov ax, [imme]
  1764 000008F1 3DFF00                   cmp ax, 255
  1765 000008F4 0F8E0900                 jle .setsflag60
  1766 000008F8 68[0909]                 push setsflag_0
  1767 000008FB E8AC11                   call error1
  1768 000008FE 83C402                   add  sp, 2
  1769                                  
  1770                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1771                                  
  1772                                  .setsflag60:
  1773 00000901 B80000                   mov ax, 0
  1774 00000904 A2[3B00]                 mov byte [sflag], al
  1775                                  
  1776                                  ;-127     }
  1777                                  
  1778                                  
  1779                                  ;-128 }
  1780                                  
  1781                                  .setsflag59:
  1782                                  
  1783                                  ;-129 int checkConstSize(unsigned int ui) {    
  1784 00000907 C9                       LEAVE
  1785 00000908 C3                       ret
  1786 00000909 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1787 00000912 6F7220627974652072-
  1788 0000091B 2F6D00             
  1789                                  ENDP
  1790                                  
  1791                                  checkConstSize: PROC
  1792                                  
  1793                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1794                                  
  1795                                  ;Function : checkConstSize, Number of local variables: 1
  1796                                  ;   # type sign width addr used name   list of local variables
  1797                                  ;  200 var unsg word   129 NULL ui = bp+4;
  1798 0000091E C8000000                 ENTER  0,0
  1799 00000922 8B4604                   mov ax, [bp+4]
  1800 00000925 83F87F                   cmp ax, 127
  1801 00000928 0F8E0600                 jle .checkConstSize61
  1802 0000092C B80000                   mov ax, 0
  1803 0000092F E91600                   jmp .retncheckConstSize
  1804                                  
  1805                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1806                                  
  1807                                  .checkConstSize61:
  1808 00000932 8B4604                   mov ax, [bp+4]
  1809 00000935 3D80FF                   cmp ax, 65408
  1810 00000938 0F8D0600                 jge .checkConstSize62
  1811 0000093C B80000                   mov ax, 0
  1812 0000093F E90600                   jmp .retncheckConstSize
  1813                                  
  1814                                  ;-132     return 2;// is short        
  1815                                  
  1816                                  .checkConstSize62:
  1817 00000942 B80200                   mov ax, 2
  1818 00000945 E90000                   jmp .retncheckConstSize
  1819                                  
  1820                                  ;-133 }
  1821                                  
  1822 00000948 C9                       .retncheckConstSize: LEAVE
  1823 00000949 C3                       ret
  1824                                  ENDP
  1825                                  ;Back to main program: AS.C
  1826                                  
  1827                                  ;-5 #include "PARSE.C"
  1828                                  
  1829                                  ;Use include file: PARSE.C
  1830                                  
  1831                                  ;-1 int parse() {
  1832                                  
  1833                                  
  1834                                  parse: PROC
  1835                                  
  1836                                  ;-2     LabelNamePtr  = &LabelNames;
  1837                                  
  1838 0000094A B85A77                   mov ax, LabelNames
  1839 0000094D A3[4700]                 mov word [LabelNamePtr], ax
  1840                                  
  1841                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1842                                  
  1843 00000950 B8AA8B                   mov ax, JmpCallNames
  1844 00000953 A3[4D00]                 mov word [JmpCallNamePtr], ax
  1845                                  
  1846                                  ;-4     LabelMaxIx=0;
  1847                                  
  1848 00000956 B80000                   mov ax, 0
  1849 00000959 A3[4900]                 mov word [LabelMaxIx], ax
  1850                                  
  1851                                  ;-5     JmpCallMaxIx=0;
  1852                                  
  1853 0000095C B80000                   mov ax, 0
  1854 0000095F A3[4F00]                 mov word [JmpCallMaxIx], ax
  1855                                  
  1856                                  ;-6     BinLen=0;
  1857                                  
  1858 00000962 B80000                   mov ax, 0
  1859 00000965 A3[5100]                 mov word [BinLen], ax
  1860                                  
  1861                                  ;-7     isInProc=0;
  1862                                  
  1863 00000968 B80000                   mov ax, 0
  1864 0000096B A2[0E00]                 mov byte [isInProc], al
  1865                                  
  1866                                  ;-8 
  1867                                  
  1868                                  
  1869                                  ;-9     do {//process a new line
  1870                                  
  1871                                  .parse63:
  1872                                  
  1873                                  ;-10         PCStart=PC;
  1874                                  
  1875 0000096E A1[2400]                 mov ax, [PC]
  1876 00000971 A3[2A00]                 mov word [PCStart], ax
  1877                                  
  1878                                  ;-11         OpSize=0;
  1879                                  
  1880 00000974 B80000                   mov ax, 0
  1881 00000977 A2[3800]                 mov byte [OpSize], al
  1882                                  
  1883                                  ;-12         OpPrintIndex=0;
  1884                                  
  1885 0000097A B80000                   mov ax, 0
  1886 0000097D A3[4200]                 mov word [OpPrintIndex], ax
  1887                                  
  1888                                  ;-13         PrintRA=' ';
  1889                                  
  1890 00000980 B82000                   mov ax, 32
  1891 00000983 A2[4600]                 mov byte [PrintRA], al
  1892                                  
  1893                                  ;-14         getLine();
  1894                                  
  1895 00000986 E8BD06                   call getLine
  1896                                  
  1897                                  ;-15         InputPtr = &InputBuf;
  1898                                  
  1899 00000989 B88D75                   mov ax, InputBuf
  1900 0000098C A3[1500]                 mov word [InputPtr], ax
  1901                                  
  1902                                  ;-16         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1903                                  
  1904 0000098F E8D100                   call getTokeType
  1905                                  
  1906                                  ;-17         if (TokeType == ALNUME) {
  1907                                  
  1908 00000992 A0[2D00]                 mov al, [TokeType]
  1909 00000995 3C03                     cmp al, 3
  1910 00000997 0F852C00                 jne .parse64
  1911                                  
  1912                                  ;-18             if (isLabel) {//set in getName
  1913                                  
  1914 0000099B A0[2C00]                 mov al, [isLabel]
  1915 0000099E 08C0                     or  al, al
  1916 000009A0 0F842300                 je .parse65
  1917                                  
  1918                                  ;-19               if (isInProc == 0)  strcpy(ProcName, Symbol);
  1919                                  
  1920 000009A4 A0[0E00]                 mov al, [isInProc]
  1921 000009A7 3C00                     cmp al, 0
  1922 000009A9 0F851000                 jne .parse66
  1923 000009AD 8D063075                 lea  ax, [Symbol]
  1924 000009B1 50                       push ax
  1925 000009B2 8D066E75                 lea  ax, [ProcName]
  1926 000009B6 50                       push ax
  1927 000009B7 E8E408                   call strcpy
  1928 000009BA 83C404                   add  sp, 4
  1929                                  
  1930                                  ;-20                 storeLabel();
  1931                                  
  1932                                  .parse66:
  1933 000009BD E8B401                   call storeLabel
  1934                                  
  1935                                  ;-21                 InputPtr++;//remove :
  1936                                  
  1937 000009C0 FF06[1500]               inc  word[InputPtr]
  1938                                  
  1939                                  ;-22                 getTokeType();
  1940                                  
  1941 000009C4 E89C00                   call getTokeType
  1942                                  
  1943                                  ;-23             }
  1944                                  
  1945                                  
  1946                                  ;-24         }
  1947                                  
  1948                                  .parse65:
  1949                                  
  1950                                  ;-25         if (TokeType == ALNUME) {
  1951                                  
  1952                                  .parse64:
  1953 000009C7 A0[2D00]                 mov al, [TokeType]
  1954 000009CA 3C03                     cmp al, 3
  1955 000009CC 0F851B00                 jne .parse67
  1956                                  
  1957                                  ;-26             lookCode();// and OpCodePtr
  1958                                  
  1959 000009D0 E83504                   call lookCode
  1960                                  
  1961                                  ;-27             if(CodeType) process();
  1962                                  
  1963 000009D3 A0[3000]                 mov al, [CodeType]
  1964 000009D6 08C0                     or  al, al
  1965 000009D8 0F840600                 je .parse68
  1966 000009DC E8B419                   call process
  1967                                  
  1968                                  ;-28             else getVariable();
  1969                                  
  1970 000009DF E90300                   jmp .parse69
  1971                                  .parse68:
  1972 000009E2 E88A02                   call getVariable
  1973                                  
  1974                                  ;-29             skipRest();
  1975                                  
  1976                                  .parse69:
  1977 000009E5 E87505                   call skipRest
  1978                                  
  1979                                  ;-30         }
  1980                                  
  1981                                  
  1982                                  ;-31         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1983                                  
  1984 000009E8 E92700                   jmp .parse70
  1985                                  .parse67:
  1986 000009EB A0[2D00]                 mov al, [TokeType]
  1987 000009EE 3C03                     cmp al, 3
  1988 000009F0 0F8E0C00                 jle .parse71
  1989 000009F4 68[230A]                 push parse_0
  1990 000009F7 E8B010                   call error1
  1991 000009FA 83C402                   add  sp, 2
  1992                                  
  1993                                  ;-32         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1994                                  
  1995 000009FD E91200                   jmp .parse72
  1996                                  .parse71:
  1997 00000A00 A0[2D00]                 mov al, [TokeType]
  1998 00000A03 3C01                     cmp al, 1
  1999 00000A05 0F850900                 jne .parse73
  2000 00000A09 68[410A]                 push parse_1
  2001 00000A0C E89B10                   call error1
  2002 00000A0F 83C402                   add  sp, 2
  2003                                  
  2004                                  ;-33         printLine();
  2005                                  
  2006                                  .parse73:
  2007                                  .parse72:
  2008                                  .parse70:
  2009 00000A12 E8390E                   call printLine
  2010                                  
  2011                                  ;-34     } while (DOS_NoBytes != 0 );
  2012                                  
  2013 00000A15 A1[2100]                 mov ax, [DOS_NoBytes]
  2014 00000A18 83F800                   cmp ax, 0
  2015 00000A1B 0F840300                 je  .parse74
  2016 00000A1F E94CFF                   jmp .parse63
  2017                                  .parse74:
  2018                                  
  2019                                  ;-35 }
  2020                                  
  2021                                  
  2022                                  ;-36 
  2023                                  
  2024                                  
  2025                                  ;-37 int getTokeType() {
  2026                                  
  2027 00000A22 C3                       ret
  2028 00000A23 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2029 00000A2C 696E73747275637469-
  2030 00000A35 6F6E20657870656374-
  2031 00000A3E 656400             
  2032 00000A41 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2033 00000A4A 616C6C6F7765642061-
  2034 00000A53 74207374617274206F-
  2035 00000A5C 66206C696E6500     
  2036                                  ENDP
  2037                                  
  2038                                  getTokeType: PROC
  2039                                  
  2040                                  ;-38     char c;
  2041                                  
  2042                                  
  2043                                  ;-39     skipBlank();
  2044                                  
  2045                                  ;Function : getTokeType, Number of local variables: 1
  2046                                  ;   # type sign width addr used name   list of local variables
  2047                                  ;  200 var sign byte    38 NULL c = bp-2;
  2048 00000A63 C8020000                 ENTER  2,0
  2049 00000A67 E8FD06                   call skipBlank
  2050                                  
  2051                                  ;-40     c = *InputPtr;
  2052                                  
  2053 00000A6A 8B1E[1500]               mov bx, [InputPtr]
  2054 00000A6E 8A07                     mov al, [bx]
  2055 00000A70 B400                     mov ah, 0
  2056 00000A72 8846FE                   mov [bp-2], al
  2057                                  
  2058                                  ;-41     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2059                                  
  2060 00000A75 8A46FE                   mov al, [bp-2]
  2061 00000A78 3C00                     cmp al, 0
  2062 00000A7A 0F850900                 jne .getTokeType75
  2063 00000A7E B80000                   mov ax, 0
  2064 00000A81 A2[2D00]                 mov byte [TokeType], al
  2065 00000A84 E96600                   jmp .retngetTokeType
  2066                                  
  2067                                  ;-42     if (c == ';') {TokeType=0; return; }//comment
  2068                                  
  2069                                  .getTokeType75:
  2070 00000A87 8A46FE                   mov al, [bp-2]
  2071 00000A8A 3C3B                     cmp al, 59
  2072 00000A8C 0F850900                 jne .getTokeType76
  2073 00000A90 B80000                   mov ax, 0
  2074 00000A93 A2[2D00]                 mov byte [TokeType], al
  2075 00000A96 E95400                   jmp .retngetTokeType
  2076                                  
  2077                                  ;-43     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2078                                  
  2079                                  .getTokeType76:
  2080 00000A99 8A46FE                   mov al, byte [bp-2]
  2081 00000A9C B400                     mov ah, 0
  2082 00000A9E 50                       push ax
  2083 00000A9F E8AA07                   call digit
  2084 00000AA2 83C402                   add  sp, 2
  2085 00000AA5 08C0                     or  al, al
  2086 00000AA7 0F841500                 je .getTokeType77
  2087 00000AAB 8A46FE                   mov al, byte [bp-2]
  2088 00000AAE B400                     mov ah, 0
  2089 00000AB0 50                       push ax
  2090 00000AB1 E8D408                   call getDigit
  2091 00000AB4 83C402                   add  sp, 2
  2092 00000AB7 B80100                   mov ax, 1
  2093 00000ABA A2[2D00]                 mov byte [TokeType], al
  2094 00000ABD E92D00                   jmp .retngetTokeType
  2095                                  
  2096                                  ;-44     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2097                                  
  2098                                  .getTokeType77:
  2099 00000AC0 8A46FE                   mov al, byte [bp-2]
  2100 00000AC3 B400                     mov ah, 0
  2101 00000AC5 50                       push ax
  2102 00000AC6 E8C906                   call letterE
  2103 00000AC9 83C402                   add  sp, 2
  2104 00000ACC 08C0                     or  al, al
  2105 00000ACE 0F841500                 je .getTokeType78
  2106 00000AD2 8A46FE                   mov al, byte [bp-2]
  2107 00000AD5 B400                     mov ah, 0
  2108 00000AD7 50                       push ax
  2109 00000AD8 E8FD08                   call getName
  2110 00000ADB 83C402                   add  sp, 2
  2111 00000ADE B80300                   mov ax, 3
  2112 00000AE1 A2[2D00]                 mov byte [TokeType], al
  2113 00000AE4 E90600                   jmp .retngetTokeType
  2114                                  
  2115                                  ;-45     TokeType=NOALNUME;
  2116                                  
  2117                                  .getTokeType78:
  2118 00000AE7 B80400                   mov ax, 4
  2119 00000AEA A2[2D00]                 mov byte [TokeType], al
  2120                                  
  2121                                  ;-46 }
  2122                                  
  2123                                  
  2124                                  ;-47 
  2125                                  
  2126                                  
  2127                                  ;-48 int storeJmpCall() {
  2128                                  
  2129 00000AED C9                       .retngetTokeType: LEAVE
  2130 00000AEE C3                       ret
  2131                                  ENDP
  2132                                  
  2133                                  storeJmpCall: PROC
  2134                                  
  2135                                  ;-49     unsigned int i;
  2136                                  
  2137                                  
  2138                                  ;-50     JmpCallMaxIx++;
  2139                                  
  2140                                  ;Function : storeJmpCall, Number of local variables: 1
  2141                                  ;   # type sign width addr used name   list of local variables
  2142                                  ;  200 var unsg word    49 NULL i = bp-2;
  2143 00000AEF C8020000                 ENTER  2,0
  2144 00000AF3 FF06[4F00]               inc  word[JmpCallMaxIx]
  2145                                  
  2146                                  ;-51     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2147                                  
  2148 00000AF7 A1[4F00]                 mov ax, [JmpCallMaxIx]
  2149 00000AFA 3DF401                   cmp ax, 500 ;unsigned : 1
  2150 00000AFD 0F8C0900                 jl  .storeJmpCall79
  2151 00000B01 68[4B0B]                 push storeJmpCall_0
  2152 00000B04 E8FF0F                   call errorexit
  2153 00000B07 83C402                   add  sp, 2
  2154                                  
  2155                                  ;-52     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2156                                  
  2157                                  .storeJmpCall79:
  2158 00000B0A 8D063075                 lea  ax, [Symbol]
  2159 00000B0E 50                       push ax
  2160 00000B0F FF36[4D00]               push word [JmpCallNamePtr]
  2161 00000B13 E88807                   call strcpy
  2162 00000B16 83C404                   add  sp, 4
  2163 00000B19 A3[4D00]                 mov word [JmpCallNamePtr], ax
  2164                                  
  2165                                  ;-53     JmpCallNamePtr++;
  2166                                  
  2167 00000B1C FF06[4D00]               inc  word[JmpCallNamePtr]
  2168                                  
  2169                                  ;-54     i = JmpCallNamePtr - &JmpCallNames;
  2170                                  
  2171 00000B20 A1[4D00]                 mov ax, [JmpCallNamePtr]
  2172 00000B23 2DAA8B                   sub ax, JmpCallNames
  2173 00000B26 8946FE                   mov [bp-2], ax
  2174                                  
  2175                                  ;-55     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2176                                  
  2177 00000B29 8B46FE                   mov ax, [bp-2]
  2178 00000B2C 3DB107                   cmp ax, 1969 ;unsigned : 0
  2179 00000B2F 0F820900                 jb  .storeJmpCall80
  2180 00000B33 68[5D0B]                 push storeJmpCall_1
  2181 00000B36 E8CD0F                   call errorexit
  2182 00000B39 83C402                   add  sp, 2
  2183                                  
  2184                                  ;-56     JmpCallAddr[JmpCallMaxIx] = PC;
  2185                                  
  2186                                  .storeJmpCall80:
  2187 00000B3C A1[2400]                 mov ax, [PC]
  2188 00000B3F 8B1E[4F00]               mov bx, [JmpCallMaxIx]
  2189 00000B43 D1E3                     shl bx, 1
  2190 00000B45 89877A93                 mov [JmpCallAddr+bx], ax
  2191                                  
  2192                                  ;-57 }
  2193                                  
  2194                                  
  2195                                  ;-58 
  2196                                  
  2197                                  
  2198                                  ;-59 int storeLabel() {
  2199 00000B49 C9                       LEAVE
  2200 00000B4A C3                       ret
  2201 00000B4B 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2202 00000B54 4A6D7043616C6C7300 
  2203 00000B5D 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2204 00000B66 4A6D7043616C6C206E-
  2205 00000B6F 616D657300         
  2206                                  ENDP
  2207                                  
  2208                                  storeLabel: PROC
  2209                                  
  2210                                  ;-60     unsigned int i;
  2211                                  
  2212                                  
  2213                                  ;-61     LabelMaxIx++;
  2214                                  
  2215                                  ;Function : storeLabel, Number of local variables: 1
  2216                                  ;   # type sign width addr used name   list of local variables
  2217                                  ;  200 var unsg word    60 NULL i = bp-2;
  2218 00000B74 C8020000                 ENTER  2,0
  2219 00000B78 FF06[4900]               inc  word[LabelMaxIx]
  2220                                  
  2221                                  ;-62     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2222                                  
  2223 00000B7C A1[4900]                 mov ax, [LabelMaxIx]
  2224 00000B7F 3D5802                   cmp ax, 600 ;unsigned : 1
  2225 00000B82 0F8C0900                 jl  .storeLabel81
  2226 00000B86 68[E60B]                 push storeLabel_0
  2227 00000B89 E87A0F                   call errorexit
  2228 00000B8C 83C402                   add  sp, 2
  2229                                  
  2230                                  ;-63     if(searchLabel()) error1("duplicate label");
  2231                                  
  2232                                  .storeLabel81:
  2233 00000B8F E88900                   call searchLabel
  2234 00000B92 08C0                     or  al, al
  2235 00000B94 0F840900                 je .storeLabel82
  2236 00000B98 68[F60B]                 push storeLabel_1
  2237 00000B9B E80C0F                   call error1
  2238 00000B9E 83C402                   add  sp, 2
  2239                                  
  2240                                  ;-64     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2241                                  
  2242                                  .storeLabel82:
  2243 00000BA1 8D063075                 lea  ax, [Symbol]
  2244 00000BA5 50                       push ax
  2245 00000BA6 FF36[4700]               push word [LabelNamePtr]
  2246 00000BAA E8F106                   call strcpy
  2247 00000BAD 83C404                   add  sp, 4
  2248 00000BB0 A3[4700]                 mov word [LabelNamePtr], ax
  2249                                  
  2250                                  ;-65     LabelNamePtr++;
  2251                                  
  2252 00000BB3 FF06[4700]               inc  word[LabelNamePtr]
  2253                                  
  2254                                  ;-66     i = LabelNamePtr - &LabelNames;
  2255                                  
  2256 00000BB7 A1[4700]                 mov ax, [LabelNamePtr]
  2257 00000BBA 2D5A77                   sub ax, LabelNames
  2258 00000BBD 8946FE                   mov [bp-2], ax
  2259                                  
  2260                                  ;-67     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2261                                  
  2262 00000BC0 8B46FE                   mov ax, [bp-2]
  2263 00000BC3 3D810F                   cmp ax, 3969 ;unsigned : 0
  2264 00000BC6 0F820900                 jb  .storeLabel83
  2265 00000BCA 68[060C]                 push storeLabel_2
  2266 00000BCD E8360F                   call errorexit
  2267 00000BD0 83C402                   add  sp, 2
  2268                                  
  2269                                  ;-68     LabelAddr[LabelMaxIx] = PC + Origin;
  2270                                  
  2271                                  .storeLabel83:
  2272 00000BD3 A1[2400]                 mov ax, [PC]
  2273 00000BD6 0306[2600]               add ax, [Origin]
  2274 00000BDA 8B1E[4900]               mov bx, [LabelMaxIx]
  2275 00000BDE D1E3                     shl bx, 1
  2276 00000BE0 8987FA86                 mov [LabelAddr+bx], ax
  2277                                  
  2278                                  ;-69 }
  2279                                  
  2280                                  
  2281                                  ;-70 
  2282                                  
  2283                                  
  2284                                  ;-71 int searchLabel() {
  2285 00000BE4 C9                       LEAVE
  2286 00000BE5 C3                       ret
  2287 00000BE6 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2288 00000BEF 6C6162656C7300     
  2289 00000BF6 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2290 00000BFF 206C6162656C00     
  2291 00000C06 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2292 00000C0F 6C6162656C206E616D-
  2293 00000C18 657300             
  2294                                  ENDP
  2295                                  
  2296                                  searchLabel: PROC
  2297                                  
  2298                                  ;-72     int LIx; char *p;
  2299                                  
  2300                                  
  2301                                  ;-73     p = &LabelNames;
  2302                                  
  2303                                  ;Function : searchLabel, Number of local variables: 2
  2304                                  ;   # type sign width addr used name   list of local variables
  2305                                  ;  200 var sign word    72 NULL LIx = bp-2
  2306                                  ;  201 ptr sign byte    72 NULL p = bp-4;
  2307 00000C1B C8040000                 ENTER  4,0
  2308 00000C1F B85A77                   mov ax, LabelNames
  2309 00000C22 8946FC                   mov [bp-4], ax
  2310                                  
  2311                                  ;-74     LIx = 1;
  2312                                  
  2313 00000C25 B80100                   mov ax, 1
  2314 00000C28 8946FE                   mov [bp-2], ax
  2315                                  
  2316                                  ;-75     while (LIx <= LabelMaxIx) {
  2317                                  
  2318                                  .searchLabel84:
  2319 00000C2B 8B46FE                   mov ax, [bp-2]
  2320 00000C2E 3B06[4900]               cmp ax, [LabelMaxIx]
  2321 00000C32 0F8F3100                 jg  .searchLabel85
  2322                                  
  2323                                  ;-76         if (eqstr(p, Symbol)) return LIx;//pos of label
  2324                                  
  2325 00000C36 8D063075                 lea  ax, [Symbol]
  2326 00000C3A 50                       push ax
  2327 00000C3B FF76FC                   push word [bp-4]
  2328 00000C3E E89306                   call eqstr
  2329 00000C41 83C404                   add  sp, 4
  2330 00000C44 08C0                     or  al, al
  2331 00000C46 0F840600                 je .searchLabel86
  2332 00000C4A 8B46FE                   mov ax, [bp-2]
  2333 00000C4D E91D00                   jmp .retnsearchLabel
  2334                                  
  2335                                  ;-77         p=strlen(p) + p;
  2336                                  
  2337                                  .searchLabel86:
  2338 00000C50 FF76FC                   push word [bp-4]
  2339 00000C53 E82006                   call strlen
  2340 00000C56 83C402                   add  sp, 2
  2341 00000C59 0346FC                   add ax, [bp-4]
  2342 00000C5C 8946FC                   mov [bp-4], ax
  2343                                  
  2344                                  ;-78         p++;
  2345                                  
  2346 00000C5F FF46FC                   inc  word[bp-4]
  2347                                  
  2348                                  ;-79         LIx++;
  2349                                  
  2350 00000C62 FF46FE                   inc  word[bp-2]
  2351                                  
  2352                                  ;-80     }
  2353                                  
  2354                                  
  2355                                  ;-81     return 0;
  2356                                  
  2357 00000C65 EBC4                     jmp .searchLabel84
  2358                                  .searchLabel85:
  2359 00000C67 B80000                   mov ax, 0
  2360 00000C6A E90000                   jmp .retnsearchLabel
  2361                                  
  2362                                  ;-82 }
  2363                                  
  2364                                  
  2365                                  ;-83 
  2366                                  
  2367                                  
  2368                                  ;-84 int getVariable() {
  2369                                  
  2370 00000C6D C9                       .retnsearchLabel: LEAVE
  2371 00000C6E C3                       ret
  2372                                  ENDP
  2373                                  
  2374                                  getVariable: PROC
  2375                                  
  2376                                  ;-85     char c;
  2377                                  
  2378                                  
  2379                                  ;-86     storeLabel();
  2380                                  
  2381                                  ;Function : getVariable, Number of local variables: 1
  2382                                  ;   # type sign width addr used name   list of local variables
  2383                                  ;  200 var sign byte    85 NULL c = bp-2;
  2384 00000C6F C8020000                 ENTER  2,0
  2385 00000C73 E8FEFE                   call storeLabel
  2386                                  
  2387                                  ;-87     getTokeType();
  2388                                  
  2389 00000C76 E8EAFD                   call getTokeType
  2390                                  
  2391                                  ;-88     if(TokeType==ALNUME) {//getName
  2392                                  
  2393 00000C79 A0[2D00]                 mov al, [TokeType]
  2394 00000C7C 3C03                     cmp al, 3
  2395 00000C7E 0F857001                 jne .getVariable87
  2396                                  
  2397                                  ;-89         lookCode();
  2398                                  
  2399 00000C82 E88301                   call lookCode
  2400                                  
  2401                                  ;-90         if (CodeType < 200) dataexit();
  2402                                  
  2403 00000C85 A0[3000]                 mov al, [CodeType]
  2404 00000C88 3CC8                     cmp al, 200
  2405 00000C8A 0F8D0300                 jge .getVariable88
  2406 00000C8E E80310                   call dataexit
  2407                                  
  2408                                  ;-91         if (CodeType > 205) dataexit();
  2409                                  
  2410                                  .getVariable88:
  2411 00000C91 A0[3000]                 mov al, [CodeType]
  2412 00000C94 3CCD                     cmp al, 205
  2413 00000C96 0F8E0300                 jle .getVariable89
  2414 00000C9A E8F70F                   call dataexit
  2415                                  
  2416                                  ;-92         if (CodeType== 200) {//DB
  2417                                  
  2418                                  .getVariable89:
  2419 00000C9D A0[3000]                 mov al, [CodeType]
  2420 00000CA0 3CC8                     cmp al, 200
  2421 00000CA2 0F856A00                 jne .getVariable90
  2422                                  
  2423                                  ;-93             do {
  2424                                  
  2425                                  .getVariable91:
  2426                                  
  2427                                  ;-94                 getTokeType();
  2428                                  
  2429 00000CA6 E8BAFD                   call getTokeType
  2430                                  
  2431                                  ;-95                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2432                                  
  2433 00000CA9 A0[2D00]                 mov al, [TokeType]
  2434 00000CAC 3C01                     cmp al, 1
  2435 00000CAE 0F850D00                 jne .getVariable92
  2436 00000CB2 FF36[0F00]               push word [SymbolInt]
  2437 00000CB6 E8FB14                   call genCode8
  2438 00000CB9 83C402                   add  sp, 2
  2439                                  
  2440                                  ;-96                 else {
  2441                                  
  2442 00000CBC E94100                   jmp .getVariable93
  2443                                  .getVariable92:
  2444                                  
  2445                                  ;-97                     skipBlank();
  2446                                  
  2447 00000CBF E8A504                   call skipBlank
  2448                                  
  2449                                  ;-98                     if (isToken('"')) {
  2450                                  
  2451 00000CC2 6A22                     push 34
  2452 00000CC4 E82F02                   call isToken
  2453 00000CC7 83C402                   add  sp, 2
  2454 00000CCA 08C0                     or  al, al
  2455 00000CCC 0F843000                 je .getVariable94
  2456                                  
  2457                                  ;-99                         do {
  2458                                  
  2459                                  .getVariable95:
  2460                                  
  2461                                  ;-100                             c= *InputPtr;
  2462                                  
  2463 00000CD0 8B1E[1500]               mov bx, [InputPtr]
  2464 00000CD4 8A07                     mov al, [bx]
  2465 00000CD6 B400                     mov ah, 0
  2466 00000CD8 8846FE                   mov [bp-2], al
  2467                                  
  2468                                  ;-101                             genCode8(c);
  2469                                  
  2470 00000CDB 8A46FE                   mov al, byte [bp-2]
  2471 00000CDE B400                     mov ah, 0
  2472 00000CE0 50                       push ax
  2473 00000CE1 E8D014                   call genCode8
  2474 00000CE4 83C402                   add  sp, 2
  2475                                  
  2476                                  ;-102                             InputPtr++;
  2477                                  
  2478 00000CE7 FF06[1500]               inc  word[InputPtr]
  2479                                  
  2480                                  ;-103                         } while (*InputPtr != '"' );
  2481                                  
  2482 00000CEB 8B1E[1500]               mov bx, [InputPtr]
  2483 00000CEF 8A07                     mov al, [bx]
  2484 00000CF1 B400                     mov ah, 0
  2485 00000CF3 83F822                   cmp ax, 34
  2486 00000CF6 0F840200                 je  .getVariable96
  2487 00000CFA EBD4                     jmp .getVariable95
  2488                                  .getVariable96:
  2489                                  
  2490                                  ;-104                         InputPtr++;
  2491                                  
  2492 00000CFC FF06[1500]               inc  word[InputPtr]
  2493                                  
  2494                                  ;-105                     }
  2495                                  
  2496                                  
  2497                                  ;-106                 }
  2498                                  
  2499                                  .getVariable94:
  2500                                  
  2501                                  ;-107             } while (isToken(','));
  2502                                  
  2503                                  .getVariable93:
  2504 00000D00 6A2C                     push 44
  2505 00000D02 E8F101                   call isToken
  2506 00000D05 83C402                   add  sp, 2
  2507 00000D08 08C0                     or  al, al
  2508 00000D0A 0F840200                 je .getVariable97
  2509 00000D0E EB96                     jmp .getVariable91
  2510                                  .getVariable97:
  2511                                  
  2512                                  ;-108         }
  2513                                  
  2514                                  
  2515                                  ;-109         if (CodeType == 201) {//DW
  2516                                  
  2517                                  .getVariable90:
  2518 00000D10 A0[3000]                 mov al, [CodeType]
  2519 00000D13 3CC9                     cmp al, 201
  2520 00000D15 0F852600                 jne .getVariable98
  2521                                  
  2522                                  ;-110             do {
  2523                                  
  2524                                  .getVariable99:
  2525                                  
  2526                                  ;-111                 getTokeType();
  2527                                  
  2528 00000D19 E847FD                   call getTokeType
  2529                                  
  2530                                  ;-112                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2531                                  
  2532 00000D1C A0[2D00]                 mov al, [TokeType]
  2533 00000D1F 3C01                     cmp al, 1
  2534 00000D21 0F850A00                 jne .getVariable100
  2535 00000D25 FF36[0F00]               push word [SymbolInt]
  2536 00000D29 E8DF14                   call genCode16
  2537 00000D2C 83C402                   add  sp, 2
  2538                                  
  2539                                  ;-113             } while (isToken(','));
  2540                                  
  2541                                  .getVariable100:
  2542 00000D2F 6A2C                     push 44
  2543 00000D31 E8C201                   call isToken
  2544 00000D34 83C402                   add  sp, 2
  2545 00000D37 08C0                     or  al, al
  2546 00000D39 0F840200                 je .getVariable101
  2547 00000D3D EBDA                     jmp .getVariable99
  2548                                  .getVariable101:
  2549                                  
  2550                                  ;-114         }
  2551                                  
  2552                                  
  2553                                  ;-115         if (CodeType == 202) {//DD
  2554                                  
  2555                                  .getVariable98:
  2556 00000D3F A0[3000]                 mov al, [CodeType]
  2557 00000D42 3CCA                     cmp al, 202
  2558 00000D44 0F852E00                 jne .getVariable102
  2559                                  
  2560                                  ;-116             do {
  2561                                  
  2562                                  .getVariable103:
  2563                                  
  2564                                  ;-117                 getTokeType();
  2565                                  
  2566 00000D48 E818FD                   call getTokeType
  2567                                  
  2568                                  ;-118                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2569                                  
  2570 00000D4B A0[2D00]                 mov al, [TokeType]
  2571 00000D4E 3C01                     cmp al, 1
  2572 00000D50 0F851200                 jne .getVariable104
  2573 00000D54 FF36[0F00]               push word [SymbolInt]
  2574 00000D58 E8B014                   call genCode16
  2575 00000D5B 83C402                   add  sp, 2
  2576                                  
  2577                                  ;-119                                     genCode16(0);}//todo genCode32(SymbolLong);
  2578                                  
  2579 00000D5E 6A00                     push 0
  2580 00000D60 E8A814                   call genCode16
  2581 00000D63 83C402                   add  sp, 2
  2582                                  
  2583                                  ;-120             } while (isToken(','));
  2584                                  
  2585                                  .getVariable104:
  2586 00000D66 6A2C                     push 44
  2587 00000D68 E88B01                   call isToken
  2588 00000D6B 83C402                   add  sp, 2
  2589 00000D6E 08C0                     or  al, al
  2590 00000D70 0F840200                 je .getVariable105
  2591 00000D74 EBD2                     jmp .getVariable103
  2592                                  .getVariable105:
  2593                                  
  2594                                  ;-121         }
  2595                                  
  2596                                  
  2597                                  ;-122         if (CodeType >= 203) {//resb, resw, resd
  2598                                  
  2599                                  .getVariable102:
  2600 00000D76 A0[3000]                 mov al, [CodeType]
  2601 00000D79 3CCB                     cmp al, 203 ;unsigned : 1
  2602 00000D7B 0F8C7000                 jl  .getVariable106
  2603                                  
  2604                                  ;-123             getTokeType();
  2605                                  
  2606 00000D7F E8E1FC                   call getTokeType
  2607                                  
  2608                                  ;-124             if (TokeType == DIGIT) {
  2609                                  
  2610 00000D82 A0[2D00]                 mov al, [TokeType]
  2611 00000D85 3C01                     cmp al, 1
  2612 00000D87 0F856100                 jne .getVariable107
  2613                                  
  2614                                  ;-125                 if (SymbolInt <= 0) syntaxerror();
  2615                                  
  2616 00000D8B A1[0F00]                 mov ax, [SymbolInt]
  2617 00000D8E 83F800                   cmp ax, 0
  2618 00000D91 0F870300                 ja  .getVariable108
  2619 00000D95 E8D10E                   call syntaxerror
  2620                                  
  2621                                  ;-126                 if (AbsoluteLab == 0) error1("Absolute is null");
  2622                                  
  2623                                  .getVariable108:
  2624 00000D98 A1[2800]                 mov ax, [AbsoluteLab]
  2625 00000D9B 83F800                   cmp ax, 0
  2626 00000D9E 0F850900                 jne .getVariable109
  2627 00000DA2 68[F70D]                 push getVariable_0
  2628 00000DA5 E8020D                   call error1
  2629 00000DA8 83C402                   add  sp, 2
  2630                                  
  2631                                  ;-127                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2632                                  
  2633                                  .getVariable109:
  2634 00000DAB A1[2800]                 mov ax, [AbsoluteLab]
  2635 00000DAE 8B1E[4900]               mov bx, [LabelMaxIx]
  2636 00000DB2 D1E3                     shl bx, 1
  2637 00000DB4 8987FA86                 mov [LabelAddr+bx], ax
  2638                                  
  2639                                  ;-128                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2640                                  
  2641 00000DB8 A0[3000]                 mov al, [CodeType]
  2642 00000DBB 3CCC                     cmp al, 204
  2643 00000DBD 0F850A00                 jne .getVariable110
  2644 00000DC1 A1[0F00]                 mov ax, [SymbolInt]
  2645 00000DC4 0306[0F00]               add ax, [SymbolInt]
  2646 00000DC8 A3[0F00]                 mov word [SymbolInt], ax
  2647                                  
  2648                                  ;-129                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2649                                  
  2650                                  .getVariable110:
  2651 00000DCB A0[3000]                 mov al, [CodeType]
  2652 00000DCE 3CCD                     cmp al, 205
  2653 00000DD0 0F850B00                 jne .getVariable111
  2654 00000DD4 A1[0F00]                 mov ax, [SymbolInt]
  2655 00000DD7 BB0400                   mov bx, 4
  2656 00000DDA F7E3                     mul bx
  2657 00000DDC A3[0F00]                 mov word [SymbolInt], ax
  2658                                  
  2659                                  ;-130                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2660                                  
  2661                                  .getVariable111:
  2662 00000DDF A1[2800]                 mov ax, [AbsoluteLab]
  2663 00000DE2 0306[0F00]               add ax, [SymbolInt]
  2664 00000DE6 A3[2800]                 mov word [AbsoluteLab], ax
  2665                                  
  2666                                  ;-131             } else numbererror();
  2667                                  
  2668 00000DE9 E90300                   jmp .getVariable112
  2669                                  .getVariable107:
  2670 00000DEC E8E70D                   call numbererror
  2671                                  
  2672                                  ;-132         }
  2673                                  
  2674                                  .getVariable112:
  2675                                  
  2676                                  ;-133     }
  2677                                  
  2678                                  .getVariable106:
  2679                                  
  2680                                  ;-134     else dataexit();
  2681                                  
  2682 00000DEF E90300                   jmp .getVariable113
  2683                                  .getVariable87:
  2684 00000DF2 E89F0E                   call dataexit
  2685                                  
  2686                                  ;-135 }
  2687                                  
  2688                                  .getVariable113:
  2689                                  
  2690                                  ;-136 
  2691                                  
  2692                                  
  2693                                  ;-137 int lookCode() {//ret: CodeType, *OpCodePtr
  2694 00000DF5 C9                       LEAVE
  2695 00000DF6 C3                       ret
  2696 00000DF7 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2697 00000E00 6973206E756C6C00   
  2698                                  ENDP
  2699                                  
  2700                                  lookCode: PROC
  2701                                  
  2702                                  ;-138     CodeType=0;
  2703                                  
  2704 00000E08 B80000                   mov ax, 0
  2705 00000E0B A2[3000]                 mov byte [CodeType], al
  2706                                  
  2707                                  ;-139     OpCodePtr= &I_START;
  2708                                  
  2709 00000E0E B8[5700]                 mov ax, I_START
  2710 00000E11 A3[4400]                 mov word [OpCodePtr], ax
  2711                                  
  2712                                  ;-140     OpCodePtr++;
  2713                                  
  2714 00000E14 FF06[4400]               inc  word[OpCodePtr]
  2715                                  
  2716                                  ;-141     do  {
  2717                                  
  2718                                  .lookCode114:
  2719                                  
  2720                                  ;-142         if (eqstr(SymbolUpper, OpCodePtr))  {
  2721                                  
  2722 00000E18 FF36[4400]               push word [OpCodePtr]
  2723 00000E1C 8D064F75                 lea  ax, [SymbolUpper]
  2724 00000E20 50                       push ax
  2725 00000E21 E8B004                   call eqstr
  2726 00000E24 83C404                   add  sp, 4
  2727 00000E27 08C0                     or  al, al
  2728 00000E29 0F842700                 je .lookCode115
  2729                                  
  2730                                  ;-143             while(*OpCodePtr!=0) OpCodePtr++;
  2731                                  
  2732                                  .lookCode116:
  2733 00000E2D 8B1E[4400]               mov bx, [OpCodePtr]
  2734 00000E31 8A07                     mov al, [bx]
  2735 00000E33 B400                     mov ah, 0
  2736 00000E35 83F800                   cmp ax, 0
  2737 00000E38 0F840600                 je  .lookCode117
  2738 00000E3C FF06[4400]               inc  word[OpCodePtr]
  2739                                  
  2740                                  ;-144             OpCodePtr++;
  2741                                  
  2742 00000E40 EBEB                     jmp .lookCode116
  2743                                  .lookCode117:
  2744 00000E42 FF06[4400]               inc  word[OpCodePtr]
  2745                                  
  2746                                  ;-145             CodeType =*OpCodePtr;
  2747                                  
  2748 00000E46 8B1E[4400]               mov bx, [OpCodePtr]
  2749 00000E4A 8A07                     mov al, [bx]
  2750 00000E4C B400                     mov ah, 0
  2751 00000E4E A2[3000]                 mov byte [CodeType], al
  2752                                  
  2753                                  ;-146             return;
  2754                                  
  2755 00000E51 E92A00                   jmp .retnlookCode
  2756                                  
  2757                                  ;-147         }
  2758                                  
  2759                                  
  2760                                  ;-148     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2761                                  
  2762                                  .lookCode115:
  2763                                  .lookCode118:
  2764 00000E54 8B1E[4400]               mov bx, [OpCodePtr]
  2765 00000E58 8A07                     mov al, [bx]
  2766 00000E5A B400                     mov ah, 0
  2767 00000E5C 3DF100                   cmp ax, 241
  2768 00000E5F 0F840600                 je  .lookCode119
  2769 00000E63 FF06[4400]               inc  word[OpCodePtr]
  2770                                  
  2771                                  ;-149     OpCodePtr++;
  2772                                  
  2773 00000E67 EBEB                     jmp .lookCode118
  2774                                  .lookCode119:
  2775 00000E69 FF06[4400]               inc  word[OpCodePtr]
  2776                                  
  2777                                  ;-150     } while(*OpCodePtr!=0);
  2778                                  
  2779 00000E6D 8B1E[4400]               mov bx, [OpCodePtr]
  2780 00000E71 8A07                     mov al, [bx]
  2781 00000E73 B400                     mov ah, 0
  2782 00000E75 83F800                   cmp ax, 0
  2783 00000E78 0F840200                 je  .lookCode120
  2784 00000E7C EB9A                     jmp .lookCode114
  2785                                  .lookCode120:
  2786                                  
  2787                                  ;-151 }
  2788                                  
  2789                                  
  2790                                  ;-152 
  2791                                  
  2792                                  
  2793                                  ;-153 int getCodeSize() {
  2794                                  
  2795                                   .retnlookCode:
  2796 00000E7E C3                       ret
  2797                                  ENDP
  2798                                  
  2799                                  getCodeSize: PROC
  2800                                  
  2801                                  ;-154     if (TokeType ==ALNUME) {
  2802                                  
  2803 00000E7F A0[2D00]                 mov al, [TokeType]
  2804 00000E82 3C03                     cmp al, 3
  2805 00000E84 0F855700                 jne .getCodeSize121
  2806                                  
  2807                                  ;-155         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2808                                  
  2809 00000E88 68[E60E]                 push getCodeSize_0
  2810 00000E8B 8D064F75                 lea  ax, [SymbolUpper]
  2811 00000E8F 50                       push ax
  2812 00000E90 E84104                   call eqstr
  2813 00000E93 83C404                   add  sp, 4
  2814 00000E96 08C0                     or  al, al
  2815 00000E98 0F840900                 je .getCodeSize122
  2816 00000E9C E8C4FB                   call getTokeType
  2817 00000E9F B80100                   mov ax, 1
  2818 00000EA2 E94000                   jmp .retngetCodeSize
  2819                                  
  2820                                  ;-156         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2821                                  
  2822                                  .getCodeSize122:
  2823 00000EA5 68[EB0E]                 push getCodeSize_1
  2824 00000EA8 8D064F75                 lea  ax, [SymbolUpper]
  2825 00000EAC 50                       push ax
  2826 00000EAD E82404                   call eqstr
  2827 00000EB0 83C404                   add  sp, 4
  2828 00000EB3 08C0                     or  al, al
  2829 00000EB5 0F840900                 je .getCodeSize123
  2830 00000EB9 E8A7FB                   call getTokeType
  2831 00000EBC B80200                   mov ax, 2
  2832 00000EBF E92300                   jmp .retngetCodeSize
  2833                                  
  2834                                  ;-157         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2835                                  
  2836                                  .getCodeSize123:
  2837 00000EC2 68[F00E]                 push getCodeSize_2
  2838 00000EC5 8D064F75                 lea  ax, [SymbolUpper]
  2839 00000EC9 50                       push ax
  2840 00000ECA E80704                   call eqstr
  2841 00000ECD 83C404                   add  sp, 4
  2842 00000ED0 08C0                     or  al, al
  2843 00000ED2 0F840900                 je .getCodeSize124
  2844 00000ED6 E88AFB                   call getTokeType
  2845 00000ED9 B80300                   mov ax, 3
  2846 00000EDC E90600                   jmp .retngetCodeSize
  2847                                  
  2848                                  ;-158     }
  2849                                  
  2850                                  .getCodeSize124:
  2851                                  
  2852                                  ;-159     return 0;
  2853                                  
  2854                                  .getCodeSize121:
  2855 00000EDF B80000                   mov ax, 0
  2856 00000EE2 E90000                   jmp .retngetCodeSize
  2857                                  
  2858                                  ;-160 }
  2859                                  
  2860                                  
  2861                                  ;-161 int isToken(char c) {
  2862                                  
  2863                                   .retngetCodeSize:
  2864 00000EE5 C3                       ret
  2865 00000EE6 4259544500              getCodeSize_0 db "BYTE",0
  2866 00000EEB 574F524400              getCodeSize_1 db "WORD",0
  2867 00000EF0 44574F524400            getCodeSize_2 db "DWORD",0
  2868                                  ENDP
  2869                                  
  2870                                  isToken: PROC
  2871                                  
  2872                                  ;-162     skipBlank();
  2873                                  
  2874                                  ;Function : isToken, Number of local variables: 1
  2875                                  ;   # type sign width addr used name   list of local variables
  2876                                  ;  200 var sign byte   161 NULL c = bp+4;
  2877 00000EF6 C8000000                 ENTER  0,0
  2878 00000EFA E86A02                   call skipBlank
  2879                                  
  2880                                  ;-163     if (*InputPtr == c) {
  2881                                  
  2882 00000EFD 8B1E[1500]               mov bx, [InputPtr]
  2883 00000F01 8A07                     mov al, [bx]
  2884 00000F03 B400                     mov ah, 0
  2885 00000F05 3A4604                   cmp al, [bp+4]
  2886 00000F08 0F850A00                 jne .isToken125
  2887                                  
  2888                                  ;-164         InputPtr++;
  2889                                  
  2890 00000F0C FF06[1500]               inc  word[InputPtr]
  2891                                  
  2892                                  ;-165         return 1;
  2893                                  
  2894 00000F10 B80100                   mov ax, 1
  2895 00000F13 E90600                   jmp .retnisToken
  2896                                  
  2897                                  ;-166         }
  2898                                  
  2899                                  
  2900                                  ;-167     return 0;
  2901                                  
  2902                                  .isToken125:
  2903 00000F16 B80000                   mov ax, 0
  2904 00000F19 E90000                   jmp .retnisToken
  2905                                  
  2906                                  ;-168 }
  2907                                  
  2908                                  
  2909                                  ;-169 int need(char c) {
  2910                                  
  2911 00000F1C C9                       .retnisToken: LEAVE
  2912 00000F1D C3                       ret
  2913                                  ENDP
  2914                                  
  2915                                  need: PROC
  2916                                  
  2917                                  ;-170     if (isToken(c)) {
  2918                                  
  2919                                  ;Function : need, Number of local variables: 1
  2920                                  ;   # type sign width addr used name   list of local variables
  2921                                  ;  200 var sign byte   169 NULL c = bp+4;
  2922 00000F1E C8000000                 ENTER  0,0
  2923 00000F22 8A4604                   mov al, byte [bp+4]
  2924 00000F25 B400                     mov ah, 0
  2925 00000F27 50                       push ax
  2926 00000F28 E8CBFF                   call isToken
  2927 00000F2B 83C402                   add  sp, 2
  2928 00000F2E 08C0                     or  al, al
  2929 00000F30 0F840600                 je .need126
  2930                                  
  2931                                  ;-171         getTokeType();
  2932                                  
  2933 00000F34 E82CFB                   call getTokeType
  2934                                  
  2935                                  ;-172         return;
  2936                                  
  2937 00000F37 E91800                   jmp .retnneed
  2938                                  
  2939                                  ;-173         }
  2940                                  
  2941                                  
  2942                                  ;-174     error1();
  2943                                  
  2944                                  .need126:
  2945 00000F3A E86D0B                   call error1
  2946                                  
  2947                                  ;-175     prs(". need: ");
  2948                                  
  2949 00000F3D 68[540F]                 push need_0
  2950 00000F40 E8150A                   call prs
  2951 00000F43 83C402                   add  sp, 2
  2952                                  
  2953                                  ;-176     prc(c);
  2954                                  
  2955 00000F46 8A4604                   mov al, byte [bp+4]
  2956 00000F49 B400                     mov ah, 0
  2957 00000F4B 50                       push ax
  2958 00000F4C E8A809                   call prc
  2959 00000F4F 83C402                   add  sp, 2
  2960                                  
  2961                                  ;-177 }
  2962                                  
  2963                                  
  2964                                  ;-178 int skipRest() {
  2965                                  
  2966 00000F52 C9                       .retnneed: LEAVE
  2967 00000F53 C3                       ret
  2968 00000F54 2E206E6565643A2000      need_0 db ". need: ",0
  2969                                  ENDP
  2970                                  
  2971                                  skipRest: PROC
  2972                                  
  2973                                  ;-179     getTokeType();
  2974                                  
  2975 00000F5D E803FB                   call getTokeType
  2976                                  
  2977                                  ;-180     if(TokeType)error1("extra char ignored");
  2978                                  
  2979 00000F60 A0[2D00]                 mov al, [TokeType]
  2980 00000F63 08C0                     or  al, al
  2981 00000F65 0F840900                 je .skipRest127
  2982 00000F69 68[730F]                 push skipRest_0
  2983 00000F6C E83B0B                   call error1
  2984 00000F6F 83C402                   add  sp, 2
  2985                                  
  2986                                  ;-181 }
  2987                                  
  2988                                  .skipRest127:
  2989 00000F72 C3                       ret
  2990 00000F73 657874726120636861-     skipRest_0 db "extra char ignored",0
  2991 00000F7C 722069676E6F726564-
  2992 00000F85 00                 
  2993                                  ENDP
  2994                                  ;Back to main program: AS.C
  2995                                  
  2996                                  ;-6 #include "HELPER.C"
  2997                                  
  2998                                  ;Use include file: HELPER.C
  2999                                  
  3000                                  ;-1 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  3001                                  
  3002                                  
  3003                                  writetty: PROC
  3004 00000F86 B40E                     mov  ah, 14
  3005 00000F88 BB0000                   mov  bx, 0
  3006 00000F8B CD10                     db 205,16
  3007                                  
  3008                                  ;-2 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  3009                                  
  3010 00000F8D C3                       ret
  3011                                  ENDP
  3012                                  
  3013                                  putch: PROC
  3014                                  ;Function : putch, Number of local variables: 1
  3015                                  ;   # type sign width addr used name   list of local variables
  3016                                  ;  200 var sign byte     2 NULL c = bp+4;
  3017 00000F8E C8000000                 ENTER  0,0 ; constant expression
  3018 00000F92 807E040A                cmp byte[bp+4], 10
  3019 00000F96 0F850500                 jne .putch128
  3020 00000F9A B00D                     mov  al, 13
  3021 00000F9C E8E7FF                   call writetty
  3022                                  .putch128:
  3023 00000F9F 8A4604                   mov  al, [bp+4]
  3024 00000FA2 E8E1FF                   call writetty
  3025                                  
  3026                                  ;-3 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3027 00000FA5 C9                       LEAVE
  3028 00000FA6 C3                       ret
  3029                                  ENDP
  3030                                  
  3031                                  cputs: PROC
  3032                                  ;Function : cputs, Number of local variables: 2
  3033                                  ;   # type sign width addr used name   list of local variables
  3034                                  ;  200 ptr sign byte     3 NULL s = bp+4
  3035                                  ;  201 var sign byte     3 NULL c = bp-2;
  3036 00000FA7 C8020000                 ENTER  2,0
  3037                                  .cputs129:
  3038 00000FAB 8B5E04                   mov bx, [bp+4]
  3039 00000FAE 8A07                     mov al, [bx]
  3040 00000FB0 B400                     mov ah, 0
  3041 00000FB2 08C0                     or  al, al
  3042 00000FB4 0F841B00                 je .cputs130
  3043 00000FB8 8B5E04                   mov bx, [bp+4]
  3044 00000FBB 8A07                     mov al, [bx]
  3045 00000FBD B400                     mov ah, 0
  3046 00000FBF 8846FE                   mov [bp-2], al
  3047 00000FC2 8A46FE                   mov al, byte [bp-2]
  3048 00000FC5 B400                     mov ah, 0
  3049 00000FC7 50                       push ax
  3050 00000FC8 E8C3FF                   call putch
  3051 00000FCB 83C402                   add  sp, 2
  3052 00000FCE FF4604                   inc  word[bp+4]
  3053 00000FD1 EBD8                     jmp .cputs129
  3054                                  .cputs130:
  3055                                  
  3056                                  ;-4 
  3057                                  
  3058                                  
  3059                                  ;-5 int DosInt() {
  3060 00000FD3 C9                       LEAVE
  3061 00000FD4 C3                       ret
  3062                                  ENDP
  3063                                  
  3064                                  DosInt: PROC
  3065                                  
  3066                                  ;-6     __emit__(0xCD,0x21);//inth 0x21;
  3067                                  
  3068 00000FD5 CD21                     db 205,33
  3069                                  
  3070                                  ;-7     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3071                                  
  3072 00000FD7 7304                     db 115,4
  3073                                  
  3074                                  ;-8     DOS_ERR++;
  3075                                  
  3076 00000FD9 FF06[1D00]               inc  word[DOS_ERR]
  3077                                  
  3078                                  ;-9 }
  3079                                  
  3080                                  
  3081                                  ;-10 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3082                                  
  3083 00000FDD C3                       ret
  3084                                  ENDP
  3085                                  
  3086                                  openR: PROC
  3087                                  ;Function : openR, Number of local variables: 1
  3088                                  ;   # type sign width addr used name   list of local variables
  3089                                  ;  200 ptr sign byte    10 NULL s = bp+4;
  3090 00000FDE C8000000                 ENTER  0,0
  3091 00000FE2 8B5604                   mov  dx, [bp+4]
  3092 00000FE5 B8023D                   mov  ax, 15618
  3093 00000FE8 E8EAFF                   call DosInt
  3094                                  
  3095                                  ;-11 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3096 00000FEB C9                       LEAVE
  3097 00000FEC C3                       ret
  3098                                  ENDP
  3099                                  
  3100                                  creatR: PROC
  3101                                  ;Function : creatR, Number of local variables: 1
  3102                                  ;   # type sign width addr used name   list of local variables
  3103                                  ;  200 ptr sign byte    11 NULL s = bp+4;
  3104 00000FED C8000000                 ENTER  0,0
  3105 00000FF1 8B5604                   mov  dx, [bp+4]
  3106 00000FF4 B90000                   mov  cx, 0
  3107 00000FF7 B8003C                   mov  ax, 15360
  3108 00000FFA E8D8FF                   call DosInt
  3109                                  
  3110                                  ;-12 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3111 00000FFD C9                       LEAVE
  3112 00000FFE C3                       ret
  3113                                  ENDP
  3114                                  
  3115                                  fcloseR: PROC
  3116                                  ;Function : fcloseR, Number of local variables: 1
  3117                                  ;   # type sign width addr used name   list of local variables
  3118                                  ;  200 var sign word    12 NULL fd = bp+4;
  3119 00000FFF C8000000                 ENTER  0,0
  3120 00001003 8B5E04                   mov  bx, [bp+4]
  3121 00001006 B8003E                   mov  ax, 15872
  3122 00001009 E8C9FF                   call DosInt
  3123                                  
  3124                                  ;-13 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3125 0000100C C9                       LEAVE
  3126 0000100D C3                       ret
  3127                                  ENDP
  3128                                  
  3129                                  exitR: PROC
  3130                                  ;Function : exitR, Number of local variables: 1
  3131                                  ;   # type sign width addr used name   list of local variables
  3132                                  ;  200 var sign byte    13 NULL c = bp+4;
  3133 0000100E C8000000                 ENTER  0,0
  3134 00001012 B44C                     mov  ah, 76
  3135 00001014 8A4604                   mov  al, [bp+4]
  3136 00001017 E8BBFF                   call DosInt
  3137                                  
  3138                                  ;-14 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3139 0000101A C9                       LEAVE
  3140 0000101B C3                       ret
  3141                                  ENDP
  3142                                  
  3143                                  readRL: PROC
  3144                                  ;Function : readRL, Number of local variables: 3
  3145                                  ;   # type sign width addr used name   list of local variables
  3146                                  ;  200 ptr sign byte    14 NULL s = bp+4
  3147                                  ;  201 var sign word    14 NULL fd = bp+6
  3148                                  ;  202 var sign word    14 NULL len = bp+8;
  3149 0000101C C8000000                 ENTER  0,0
  3150 00001020 8B5604                   mov  dx, [bp+4]
  3151 00001023 8B4E08                   mov  cx, [bp+8]
  3152 00001026 8B5E06                   mov  bx, [bp+6]
  3153 00001029 B8003F                   mov  ax, 16128
  3154 0000102C E8A6FF                   call DosInt
  3155                                  
  3156                                  ;-15 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3157 0000102F C9                       LEAVE
  3158 00001030 C3                       ret
  3159                                  ENDP
  3160                                  
  3161                                  fputcR: PROC
  3162                                  ;Function : fputcR, Number of local variables: 2
  3163                                  ;   # type sign width addr used name   list of local variables
  3164                                  ;  200 ptr sign byte    15 NULL n = bp+4
  3165                                  ;  201 var sign word    15 NULL fd = bp+6;
  3166 00001031 C8000000                 ENTER  0,0
  3167 00001035 8D5604                  lea dx, [bp+4]
  3168                                  
  3169                                  ;-16   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3170                                  
  3171 00001038 B90100                   mov  cx, 1
  3172 0000103B 8B5E06                   mov  bx, [bp+6]
  3173 0000103E B80040                   mov  ax, 16384
  3174 00001041 E891FF                   call DosInt
  3175                                  
  3176                                  ;-17 
  3177                                  
  3178                                  
  3179                                  ;-18 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3180 00001044 C9                       LEAVE
  3181 00001045 C3                       ret
  3182                                  ENDP
  3183                                  
  3184                                  getLine: PROC
  3185                                  
  3186                                  ;-19   unsigned int i;
  3187                                  
  3188                                  
  3189                                  ;-20   InputPtr= &InputBuf;
  3190                                  
  3191                                  ;Function : getLine, Number of local variables: 1
  3192                                  ;   # type sign width addr used name   list of local variables
  3193                                  ;  200 var unsg word    19 NULL i = bp-2;
  3194 00001046 C8020000                 ENTER  2,0
  3195 0000104A B88D75                   mov ax, InputBuf
  3196 0000104D A3[1500]                 mov word [InputPtr], ax
  3197                                  
  3198                                  ;-21   *InputPtr=0;//if last line is empty
  3199                                  
  3200 00001050 B80000                   mov ax, 0
  3201 00001053 8B1E[1500]               mov  bx, [InputPtr]
  3202 00001057 8807                     mov  [bx], al
  3203                                  
  3204                                  ;-22   do {
  3205                                  
  3206                                  .getLine131:
  3207                                  
  3208                                  ;-23     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3209                                  
  3210 00001059 6A01                     push 1
  3211 0000105B FF36[1700]               push word [asm_fd]
  3212 0000105F 8D06[2300]               lea  ax, [DOS_ByteRead]
  3213 00001063 50                       push ax
  3214 00001064 E8B5FF                   call readRL
  3215 00001067 83C406                   add  sp, 6
  3216 0000106A A3[2100]                 mov word [DOS_NoBytes], ax
  3217                                  
  3218                                  ;-24     if (DOS_ERR) errorexit("Reading Source");
  3219                                  
  3220 0000106D A1[1D00]                 mov ax, [DOS_ERR]
  3221 00001070 08C0                     or  al, al
  3222 00001072 0F840900                 je .getLine132
  3223 00001076 68[D810]                 push getLine_0
  3224 00001079 E88A0A                   call errorexit
  3225 0000107C 83C402                   add  sp, 2
  3226                                  
  3227                                  ;-25     if (DOS_NoBytes == 0) return;
  3228                                  
  3229                                  .getLine132:
  3230 0000107F A1[2100]                 mov ax, [DOS_NoBytes]
  3231 00001082 83F800                   cmp ax, 0
  3232 00001085 0F850300                 jne .getLine133
  3233 00001089 E94A00                   jmp .retngetLine
  3234                                  
  3235                                  ;-26     *InputPtr = DOS_ByteRead;
  3236                                  
  3237                                  .getLine133:
  3238 0000108C A0[2300]                 mov al, [DOS_ByteRead]
  3239 0000108F 8B1E[1500]               mov  bx, [InputPtr]
  3240 00001093 8807                     mov  [bx], al
  3241                                  
  3242                                  ;-27     InputPtr++;
  3243                                  
  3244 00001095 FF06[1500]               inc  word[InputPtr]
  3245                                  
  3246                                  ;-28     i = InputPtr - &InputBuf;
  3247                                  
  3248 00001099 A1[1500]                 mov ax, [InputPtr]
  3249 0000109C 2D8D75                   sub ax, InputBuf
  3250 0000109F 8946FE                   mov [bp-2], ax
  3251                                  
  3252                                  ;-29     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3253                                  
  3254 000010A2 8B46FE                   mov ax, [bp-2]
  3255 000010A5 3DFF00                   cmp ax, 255 ;unsigned : 0
  3256 000010A8 0F820900                 jb  .getLine134
  3257 000010AC 68[E710]                 push getLine_1
  3258 000010AF E8540A                   call errorexit
  3259 000010B2 83C402                   add  sp, 2
  3260                                  
  3261                                  ;-30   } while (ifEOL(DOS_ByteRead) == 0);
  3262                                  
  3263                                  .getLine134:
  3264 000010B5 A0[2300]                 mov al, byte [DOS_ByteRead]
  3265 000010B8 B400                     mov ah, 0
  3266 000010BA 50                       push ax
  3267 000010BB E83D00                   call ifEOL
  3268 000010BE 83C402                   add  sp, 2
  3269 000010C1 3C00                     cmp al, 0
  3270 000010C3 0F850200                 jne .getLine135
  3271 000010C7 EB90                     jmp .getLine131
  3272                                  .getLine135:
  3273                                  
  3274                                  ;-31   InputPtr--;
  3275                                  
  3276 000010C9 FF0E[1500]               dec  word[InputPtr]
  3277                                  
  3278                                  ;-32   *InputPtr=0;
  3279                                  
  3280 000010CD B80000                   mov ax, 0
  3281 000010D0 8B1E[1500]               mov  bx, [InputPtr]
  3282 000010D4 8807                     mov  [bx], al
  3283                                  
  3284                                  ;-33 }
  3285                                  
  3286                                  
  3287                                  ;-34 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3288                                  
  3289 000010D6 C9                       .retngetLine: LEAVE
  3290 000010D7 C3                       ret
  3291 000010D8 52656164696E672053-     getLine_0 db "Reading Source",0
  3292 000010E1 6F7572636500       
  3293 000010E7 696E707574206C696E-     getLine_1 db "input line too long",0
  3294 000010F0 6520746F6F206C6F6E-
  3295 000010F9 6700               
  3296                                  ENDP
  3297                                  
  3298                                  ifEOL: PROC
  3299                                  
  3300                                  ;-35   if (c == 10) return 1;//LF
  3301                                  
  3302                                  ;Function : ifEOL, Number of local variables: 1
  3303                                  ;   # type sign width addr used name   list of local variables
  3304                                  ;  200 var sign byte    34 NULL c = bp+4;
  3305 000010FB C8000000                 ENTER  0,0
  3306 000010FF 8A4604                   mov al, [bp+4]
  3307 00001102 3C0A                     cmp al, 10
  3308 00001104 0F850600                 jne .ifEOL136
  3309 00001108 B80100                   mov ax, 1
  3310 0000110B E93B00                   jmp .retnifEOL
  3311                                  
  3312                                  ;-36   if (c == 13) {//CR
  3313                                  
  3314                                  .ifEOL136:
  3315 0000110E 8A4604                   mov al, [bp+4]
  3316 00001111 3C0D                     cmp al, 13
  3317 00001113 0F852C00                 jne .ifEOL137
  3318                                  
  3319                                  ;-37     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3320                                  
  3321 00001117 6A01                     push 1
  3322 00001119 FF36[1700]               push word [asm_fd]
  3323 0000111D 8D06[2300]               lea  ax, [DOS_ByteRead]
  3324 00001121 50                       push ax
  3325 00001122 E8F7FE                   call readRL
  3326 00001125 83C406                   add  sp, 6
  3327 00001128 A3[2100]                 mov word [DOS_NoBytes], ax
  3328                                  
  3329                                  ;-38     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3330                                  
  3331 0000112B A0[2300]                 mov al, [DOS_ByteRead]
  3332 0000112E 3C0A                     cmp al, 10
  3333 00001130 0F840900                 je  .ifEOL138
  3334 00001134 68[4B11]                 push ifEOL_0
  3335 00001137 E8CC09                   call errorexit
  3336 0000113A 83C402                   add  sp, 2
  3337                                  
  3338                                  ;-39     return 1;
  3339                                  
  3340                                  .ifEOL138:
  3341 0000113D B80100                   mov ax, 1
  3342 00001140 E90600                   jmp .retnifEOL
  3343                                  
  3344                                  ;-40   }
  3345                                  
  3346                                  
  3347                                  ;-41   return 0;
  3348                                  
  3349                                  .ifEOL137:
  3350 00001143 B80000                   mov ax, 0
  3351 00001146 E90000                   jmp .retnifEOL
  3352                                  
  3353                                  ;-42 }
  3354                                  
  3355                                  
  3356                                  ;-43 int skipBlank() {
  3357                                  
  3358 00001149 C9                       .retnifEOL: LEAVE
  3359 0000114A C3                       ret
  3360 0000114B 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3361 00001154 462831302920616674-
  3362 0000115D 657220435228313329-
  3363 00001166 00                 
  3364                                  ENDP
  3365                                  
  3366                                  skipBlank: PROC
  3367                                  
  3368                                  ;-44   skipblank1:
  3369                                  
  3370                                  .skipblank1:
  3371                                  
  3372                                  ;-45     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3373                                  
  3374 00001167 8B1E[1500]               mov bx, [InputPtr]
  3375 0000116B 8A07                     mov al, [bx]
  3376 0000116D B400                     mov ah, 0
  3377 0000116F 83F820                   cmp ax, 32
  3378 00001172 0F850600                 jne .skipBlank139
  3379 00001176 FF06[1500]               inc  word[InputPtr]
  3380 0000117A EBEB                     jmp .skipblank1
  3381                                  
  3382                                  ;-46     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3383                                  
  3384                                  .skipBlank139:
  3385 0000117C 8B1E[1500]               mov bx, [InputPtr]
  3386 00001180 8A07                     mov al, [bx]
  3387 00001182 B400                     mov ah, 0
  3388 00001184 83F809                   cmp ax, 9
  3389 00001187 0F850600                 jne .skipBlank140
  3390 0000118B FF06[1500]               inc  word[InputPtr]
  3391 0000118F EBD6                     jmp .skipblank1
  3392                                  
  3393                                  ;-47 }
  3394                                  
  3395                                  .skipBlank140:
  3396                                  
  3397                                  ;-48 int letterE(char c) {
  3398                                  
  3399 00001191 C3                       ret
  3400                                  ENDP
  3401                                  
  3402                                  letterE: PROC
  3403                                  
  3404                                  ;-49   if (c=='_') return 1;
  3405                                  
  3406                                  ;Function : letterE, Number of local variables: 1
  3407                                  ;   # type sign width addr used name   list of local variables
  3408                                  ;  200 var sign byte    48 NULL c = bp+4;
  3409 00001192 C8000000                 ENTER  0,0
  3410 00001196 8A4604                   mov al, [bp+4]
  3411 00001199 3C5F                     cmp al, 95
  3412 0000119B 0F850600                 jne .letterE141
  3413 0000119F B80100                   mov ax, 1
  3414 000011A2 E96900                   jmp .retnletterE
  3415                                  
  3416                                  ;-50   if (c=='.') return 1;
  3417                                  
  3418                                  .letterE141:
  3419 000011A5 8A4604                   mov al, [bp+4]
  3420 000011A8 3C2E                     cmp al, 46
  3421 000011AA 0F850600                 jne .letterE142
  3422 000011AE B80100                   mov ax, 1
  3423 000011B1 E95A00                   jmp .retnletterE
  3424                                  
  3425                                  ;-51   if (c=='?') return 1;
  3426                                  
  3427                                  .letterE142:
  3428 000011B4 8A4604                   mov al, [bp+4]
  3429 000011B7 3C3F                     cmp al, 63
  3430 000011B9 0F850600                 jne .letterE143
  3431 000011BD B80100                   mov ax, 1
  3432 000011C0 E94B00                   jmp .retnletterE
  3433                                  
  3434                                  ;-52   if (c=='$') return 1;
  3435                                  
  3436                                  .letterE143:
  3437 000011C3 8A4604                   mov al, [bp+4]
  3438 000011C6 3C24                     cmp al, 36
  3439 000011C8 0F850600                 jne .letterE144
  3440 000011CC B80100                   mov ax, 1
  3441 000011CF E93C00                   jmp .retnletterE
  3442                                  
  3443                                  ;-53   if (c> 'z') return 0;
  3444                                  
  3445                                  .letterE144:
  3446 000011D2 8A4604                   mov al, [bp+4]
  3447 000011D5 3C7A                     cmp al, 122
  3448 000011D7 0F8E0600                 jle .letterE145
  3449 000011DB B80000                   mov ax, 0
  3450 000011DE E92D00                   jmp .retnletterE
  3451                                  
  3452                                  ;-54   if (c< '@') return 0; // at included
  3453                                  
  3454                                  .letterE145:
  3455 000011E1 8A4604                   mov al, [bp+4]
  3456 000011E4 3C40                     cmp al, 64
  3457 000011E6 0F8D0600                 jge .letterE146
  3458 000011EA B80000                   mov ax, 0
  3459 000011ED E91E00                   jmp .retnletterE
  3460                                  
  3461                                  ;-55   if (c> 'Z') { if (c< 'a') return 0; }
  3462                                  
  3463                                  .letterE146:
  3464 000011F0 8A4604                   mov al, [bp+4]
  3465 000011F3 3C5A                     cmp al, 90
  3466 000011F5 0F8E0F00                 jle .letterE147
  3467 000011F9 8A4604                   mov al, [bp+4]
  3468 000011FC 3C61                     cmp al, 97
  3469 000011FE 0F8D0600                 jge .letterE148
  3470 00001202 B80000                   mov ax, 0
  3471 00001205 E90600                   jmp .retnletterE
  3472                                  .letterE148:
  3473                                  
  3474                                  ;-56   return 1;
  3475                                  
  3476                                  .letterE147:
  3477 00001208 B80100                   mov ax, 1
  3478 0000120B E90000                   jmp .retnletterE
  3479                                  
  3480                                  ;-57 }
  3481                                  
  3482                                  
  3483                                  ;-58 int alnumE(char c) {
  3484                                  
  3485 0000120E C9                       .retnletterE: LEAVE
  3486 0000120F C3                       ret
  3487                                  ENDP
  3488                                  
  3489                                  alnumE: PROC
  3490                                  
  3491                                  ;-59   if (digit(c)) return 1;
  3492                                  
  3493                                  ;Function : alnumE, Number of local variables: 1
  3494                                  ;   # type sign width addr used name   list of local variables
  3495                                  ;  200 var sign byte    58 NULL c = bp+4;
  3496 00001210 C8000000                 ENTER  0,0
  3497 00001214 8A4604                   mov al, byte [bp+4]
  3498 00001217 B400                     mov ah, 0
  3499 00001219 50                       push ax
  3500 0000121A E82F00                   call digit
  3501 0000121D 83C402                   add  sp, 2
  3502 00001220 08C0                     or  al, al
  3503 00001222 0F840600                 je .alnumE149
  3504 00001226 B80100                   mov ax, 1
  3505 00001229 E91E00                   jmp .retnalnumE
  3506                                  
  3507                                  ;-60   if (letterE(c)) return 1;
  3508                                  
  3509                                  .alnumE149:
  3510 0000122C 8A4604                   mov al, byte [bp+4]
  3511 0000122F B400                     mov ah, 0
  3512 00001231 50                       push ax
  3513 00001232 E85DFF                   call letterE
  3514 00001235 83C402                   add  sp, 2
  3515 00001238 08C0                     or  al, al
  3516 0000123A 0F840600                 je .alnumE150
  3517 0000123E B80100                   mov ax, 1
  3518 00001241 E90600                   jmp .retnalnumE
  3519                                  
  3520                                  ;-61   return 0;
  3521                                  
  3522                                  .alnumE150:
  3523 00001244 B80000                   mov ax, 0
  3524 00001247 E90000                   jmp .retnalnumE
  3525                                  
  3526                                  ;-62 }
  3527                                  
  3528                                  
  3529                                  ;-63 int digit(char c){
  3530                                  
  3531 0000124A C9                       .retnalnumE: LEAVE
  3532 0000124B C3                       ret
  3533                                  ENDP
  3534                                  
  3535                                  digit: PROC
  3536                                  
  3537                                  ;-64     if(c<'0') return 0;
  3538                                  
  3539                                  ;Function : digit, Number of local variables: 1
  3540                                  ;   # type sign width addr used name   list of local variables
  3541                                  ;  200 var sign byte    63 NULL c = bp+4;
  3542 0000124C C8000000                 ENTER  0,0
  3543 00001250 8A4604                   mov al, [bp+4]
  3544 00001253 3C30                     cmp al, 48
  3545 00001255 0F8D0600                 jge .digit151
  3546 00001259 B80000                   mov ax, 0
  3547 0000125C E91500                   jmp .retndigit
  3548                                  
  3549                                  ;-65     if(c>'9') return 0;
  3550                                  
  3551                                  .digit151:
  3552 0000125F 8A4604                   mov al, [bp+4]
  3553 00001262 3C39                     cmp al, 57
  3554 00001264 0F8E0600                 jle .digit152
  3555 00001268 B80000                   mov ax, 0
  3556 0000126B E90600                   jmp .retndigit
  3557                                  
  3558                                  ;-66     return 1;
  3559                                  
  3560                                  .digit152:
  3561 0000126E B80100                   mov ax, 1
  3562 00001271 E90000                   jmp .retndigit
  3563                                  
  3564                                  ;-67 }
  3565                                  
  3566                                  
  3567                                  ;-68 int strlen(char *s) { int c;
  3568                                  
  3569 00001274 C9                       .retndigit: LEAVE
  3570 00001275 C3                       ret
  3571                                  ENDP
  3572                                  
  3573                                  strlen: PROC
  3574                                  
  3575                                  ;-69     c=0;
  3576                                  
  3577                                  ;Function : strlen, Number of local variables: 2
  3578                                  ;   # type sign width addr used name   list of local variables
  3579                                  ;  200 ptr sign byte    68 NULL s = bp+4
  3580                                  ;  201 var sign word    68 NULL c = bp-2;
  3581 00001276 C8020000                 ENTER  2,0
  3582 0000127A B80000                   mov ax, 0
  3583 0000127D 8946FE                   mov [bp-2], ax
  3584                                  
  3585                                  ;-70     while (*s!=0) {s++; c++;}
  3586                                  
  3587                                  .strlen153:
  3588 00001280 8B5E04                   mov bx, [bp+4]
  3589 00001283 8A07                     mov al, [bx]
  3590 00001285 B400                     mov ah, 0
  3591 00001287 83F800                   cmp ax, 0
  3592 0000128A 0F840800                 je  .strlen154
  3593 0000128E FF4604                   inc  word[bp+4]
  3594 00001291 FF46FE                   inc  word[bp-2]
  3595                                  
  3596                                  ;-71     return c;
  3597                                  
  3598 00001294 EBEA                     jmp .strlen153
  3599                                  .strlen154:
  3600 00001296 8B46FE                   mov ax, [bp-2]
  3601 00001299 E90000                   jmp .retnstrlen
  3602                                  
  3603                                  ;-72     }
  3604                                  
  3605                                  
  3606                                  ;-73 int strcpy(char *s, char *t) {
  3607                                  
  3608 0000129C C9                       .retnstrlen: LEAVE
  3609 0000129D C3                       ret
  3610                                  ENDP
  3611                                  
  3612                                  strcpy: PROC
  3613                                  
  3614                                  ;-74     do { *s=*t; s++; t++; }
  3615                                  
  3616                                  ;Function : strcpy, Number of local variables: 2
  3617                                  ;   # type sign width addr used name   list of local variables
  3618                                  ;  200 ptr sign byte    73 NULL s = bp+4
  3619                                  ;  201 ptr sign byte    73 NULL t = bp+6;
  3620 0000129E C8000000                 ENTER  0,0
  3621                                  .strcpy155:
  3622 000012A2 8B5E06                   mov bx, [bp+6]
  3623 000012A5 8A07                     mov al, [bx]
  3624 000012A7 B400                     mov ah, 0
  3625 000012A9 8B5E04                   mov  bx, [bp+4]
  3626 000012AC 8807                     mov  [bx], al
  3627 000012AE FF4604                   inc  word[bp+4]
  3628 000012B1 FF4606                   inc  word[bp+6]
  3629                                  
  3630                                  ;-75     while (*t!=0);
  3631                                  
  3632 000012B4 8B5E06                   mov bx, [bp+6]
  3633 000012B7 8A07                     mov al, [bx]
  3634 000012B9 B400                     mov ah, 0
  3635 000012BB 83F800                   cmp ax, 0
  3636 000012BE 0F840200                 je  .strcpy156
  3637 000012C2 EBDE                     jmp .strcpy155
  3638                                  .strcpy156:
  3639                                  
  3640                                  ;-76     *s=0;
  3641                                  
  3642 000012C4 B80000                   mov ax, 0
  3643 000012C7 8B5E04                   mov  bx, [bp+4]
  3644 000012CA 8807                     mov  [bx], al
  3645                                  
  3646                                  ;-77     return s;
  3647                                  
  3648 000012CC 8B4604                   mov ax, [bp+4]
  3649 000012CF E90000                   jmp .retnstrcpy
  3650                                  
  3651                                  ;-78     }
  3652                                  
  3653                                  
  3654                                  ;-79 int eqstr(char *p, char *q) {
  3655                                  
  3656 000012D2 C9                       .retnstrcpy: LEAVE
  3657 000012D3 C3                       ret
  3658                                  ENDP
  3659                                  
  3660                                  eqstr: PROC
  3661                                  
  3662                                  ;-80     while(*p) {
  3663                                  
  3664                                  ;Function : eqstr, Number of local variables: 2
  3665                                  ;   # type sign width addr used name   list of local variables
  3666                                  ;  200 ptr sign byte    79 NULL p = bp+4
  3667                                  ;  201 ptr sign byte    79 NULL q = bp+6;
  3668 000012D4 C8000000                 ENTER  0,0
  3669                                  .eqstr157:
  3670 000012D8 8B5E04                   mov bx, [bp+4]
  3671 000012DB 8A07                     mov al, [bx]
  3672 000012DD B400                     mov ah, 0
  3673 000012DF 08C0                     or  al, al
  3674 000012E1 0F842000                 je .eqstr158
  3675                                  
  3676                                  ;-81         if (*p != *q) return 0;
  3677                                  
  3678 000012E5 8B5E04                   mov bx, [bp+4]
  3679 000012E8 8A07                     mov al, [bx]
  3680 000012EA B400                     mov ah, 0
  3681 000012EC 8B5E06                   mov bx, [bp+6]
  3682 000012EF 3A07                     cmp al, [bx]
  3683 000012F1 B400                     mov ah, 0
  3684 000012F3 0F840600                 je  .eqstr159
  3685 000012F7 B80000                   mov ax, 0
  3686 000012FA E92100                   jmp .retneqstr
  3687                                  
  3688                                  ;-82             p++;
  3689                                  
  3690                                  .eqstr159:
  3691 000012FD FF4604                   inc  word[bp+4]
  3692                                  
  3693                                  ;-83             q++;
  3694                                  
  3695 00001300 FF4606                   inc  word[bp+6]
  3696                                  
  3697                                  ;-84             }
  3698                                  
  3699                                  
  3700                                  ;-85     if(*q) return 0;
  3701                                  
  3702 00001303 EBD3                     jmp .eqstr157
  3703                                  .eqstr158:
  3704 00001305 8B5E06                   mov bx, [bp+6]
  3705 00001308 8A07                     mov al, [bx]
  3706 0000130A B400                     mov ah, 0
  3707 0000130C 08C0                     or  al, al
  3708 0000130E 0F840600                 je .eqstr160
  3709 00001312 B80000                   mov ax, 0
  3710 00001315 E90600                   jmp .retneqstr
  3711                                  
  3712                                  ;-86     return 1;
  3713                                  
  3714                                  .eqstr160:
  3715 00001318 B80100                   mov ax, 1
  3716 0000131B E90000                   jmp .retneqstr
  3717                                  
  3718                                  ;-87     }
  3719                                  
  3720                                  
  3721                                  ;-88 int strcat1(char *s, char *t) {
  3722                                  
  3723 0000131E C9                       .retneqstr: LEAVE
  3724 0000131F C3                       ret
  3725                                  ENDP
  3726                                  
  3727                                  strcat1: PROC
  3728                                  
  3729                                  ;-89     while (*s != 0) s++;
  3730                                  
  3731                                  ;Function : strcat1, Number of local variables: 2
  3732                                  ;   # type sign width addr used name   list of local variables
  3733                                  ;  200 ptr sign byte    88 NULL s = bp+4
  3734                                  ;  201 ptr sign byte    88 NULL t = bp+6;
  3735 00001320 C8000000                 ENTER  0,0
  3736                                  .strcat1161:
  3737 00001324 8B5E04                   mov bx, [bp+4]
  3738 00001327 8A07                     mov al, [bx]
  3739 00001329 B400                     mov ah, 0
  3740 0000132B 83F800                   cmp ax, 0
  3741 0000132E 0F840500                 je  .strcat1162
  3742 00001332 FF4604                   inc  word[bp+4]
  3743                                  
  3744                                  ;-90     strcpy(s, t);
  3745                                  
  3746 00001335 EBED                     jmp .strcat1161
  3747                                  .strcat1162:
  3748 00001337 FF7606                   push word [bp+6]
  3749 0000133A FF7604                   push word [bp+4]
  3750 0000133D E85EFF                   call strcpy
  3751 00001340 83C404                   add  sp, 4
  3752                                  
  3753                                  ;-91     }
  3754                                  
  3755                                  
  3756                                  ;-92 int toupper(char *s) {
  3757 00001343 C9                       LEAVE
  3758 00001344 C3                       ret
  3759                                  ENDP
  3760                                  
  3761                                  toupper: PROC
  3762                                  
  3763                                  ;-93     while(*s) {
  3764                                  
  3765                                  ;Function : toupper, Number of local variables: 1
  3766                                  ;   # type sign width addr used name   list of local variables
  3767                                  ;  200 ptr sign byte    92 NULL s = bp+4;
  3768 00001345 C8000000                 ENTER  0,0
  3769                                  .toupper163:
  3770 00001349 8B5E04                   mov bx, [bp+4]
  3771 0000134C 8A07                     mov al, [bx]
  3772 0000134E B400                     mov ah, 0
  3773 00001350 08C0                     or  al, al
  3774 00001352 0F843000                 je .toupper164
  3775                                  
  3776                                  ;-94         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3777                                  
  3778 00001356 8B5E04                   mov bx, [bp+4]
  3779 00001359 8A07                     mov al, [bx]
  3780 0000135B B400                     mov ah, 0
  3781 0000135D 83F861                   cmp ax, 97 ;unsigned : 1
  3782 00001360 0F8C1D00                 jl  .toupper165
  3783 00001364 8B5E04                   mov bx, [bp+4]
  3784 00001367 8A07                     mov al, [bx]
  3785 00001369 B400                     mov ah, 0
  3786 0000136B 83F87A                   cmp ax, 122
  3787 0000136E 0F8F0F00                 jg  .toupper166
  3788 00001372 8B5E04                   mov bx, [bp+4]
  3789 00001375 8A07                     mov al, [bx]
  3790 00001377 B400                     mov ah, 0
  3791 00001379 83E820                   sub ax, 32
  3792 0000137C 8B5E04                   mov  bx, [bp+4]
  3793 0000137F 8807                     mov  [bx], al
  3794                                  
  3795                                  ;-95             s++;
  3796                                  
  3797                                  .toupper166:
  3798                                  .toupper165:
  3799 00001381 FF4604                   inc  word[bp+4]
  3800                                  
  3801                                  ;-96               }
  3802                                  
  3803                                  
  3804                                  ;-97     }
  3805                                  
  3806 00001384 EBC3                     jmp .toupper163
  3807                                  .toupper164:
  3808                                  
  3809                                  ;-98 
  3810                                  
  3811                                  
  3812                                  ;-99 int getDigit(unsigned char c) {//ret: SymbolInt
  3813 00001386 C9                       LEAVE
  3814 00001387 C3                       ret
  3815                                  ENDP
  3816                                  
  3817                                  getDigit: PROC
  3818                                  
  3819                                  ;-100   unsigned int CastInt;
  3820                                  
  3821                                  
  3822                                  ;-101   SymbolInt=0;
  3823                                  
  3824                                  ;Function : getDigit, Number of local variables: 2
  3825                                  ;   # type sign width addr used name   list of local variables
  3826                                  ;  200 var unsg byte    99 NULL c = bp+4
  3827                                  ;  201 var unsg word   100 NULL CastInt = bp-2;
  3828 00001388 C8020000                 ENTER  2,0
  3829 0000138C B80000                   mov ax, 0
  3830 0000138F A3[0F00]                 mov word [SymbolInt], ax
  3831                                  
  3832                                  ;-102   do {
  3833                                  
  3834                                  .getDigit167:
  3835                                  
  3836                                  ;-103     c-='0';
  3837                                  
  3838 00001392 806E0430                 sub  byte[bp+4], 48
  3839                                  
  3840                                  ;-104     SymbolInt=SymbolInt*10;
  3841                                  
  3842 00001396 A1[0F00]                 mov ax, [SymbolInt]
  3843 00001399 BB0A00                   mov bx, 10
  3844 0000139C F7E3                     mul bx
  3845 0000139E A3[0F00]                 mov word [SymbolInt], ax
  3846                                  
  3847                                  ;-105     ax=0; CastInt=c; //cast b2w
  3848                                  
  3849 000013A1 B80000                   mov  ax, 0
  3850 000013A4 8A4604                   mov al, [bp+4]
  3851 000013A7 8946FE                   mov [bp-2], ax
  3852                                  
  3853                                  ;-106     SymbolInt=SymbolInt+CastInt;
  3854                                  
  3855 000013AA A1[0F00]                 mov ax, [SymbolInt]
  3856 000013AD 0346FE                   add ax, [bp-2]
  3857 000013B0 A3[0F00]                 mov word [SymbolInt], ax
  3858                                  
  3859                                  ;-107     InputPtr++;
  3860                                  
  3861 000013B3 FF06[1500]               inc  word[InputPtr]
  3862                                  
  3863                                  ;-108     c = *InputPtr;
  3864                                  
  3865 000013B7 8B1E[1500]               mov bx, [InputPtr]
  3866 000013BB 8A07                     mov al, [bx]
  3867 000013BD B400                     mov ah, 0
  3868 000013BF 884604                   mov [bp+4], al
  3869                                  
  3870                                  ;-109   } while(digit(c));
  3871                                  
  3872 000013C2 8A4604                   mov al, byte [bp+4]
  3873 000013C5 B400                     mov ah, 0
  3874 000013C7 50                       push ax
  3875 000013C8 E881FE                   call digit
  3876 000013CB 83C402                   add  sp, 2
  3877 000013CE 08C0                     or  al, al
  3878 000013D0 0F840200                 je .getDigit168
  3879 000013D4 EBBC                     jmp .getDigit167
  3880                                  .getDigit168:
  3881                                  
  3882                                  ;-110 }
  3883                                  
  3884                                  
  3885                                  ;-111 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3886 000013D6 C9                       LEAVE
  3887 000013D7 C3                       ret
  3888                                  ENDP
  3889                                  
  3890                                  getName: PROC
  3891                                  
  3892                                  ;-112   char *p; unsigned int i;
  3893                                  
  3894                                  
  3895                                  ;-113   p = &Symbol;
  3896                                  
  3897                                  ;Function : getName, Number of local variables: 3
  3898                                  ;   # type sign width addr used name   list of local variables
  3899                                  ;  200 var unsg byte   111 NULL c = bp+4
  3900                                  ;  201 ptr sign byte   112 NULL p = bp-2
  3901                                  ;  202 var unsg word   112 NULL i = bp-4;
  3902 000013D8 C8040000                 ENTER  4,0
  3903 000013DC B83075                   mov ax, Symbol
  3904 000013DF 8946FE                   mov [bp-2], ax
  3905                                  
  3906                                  ;-114   *p = c;
  3907                                  
  3908 000013E2 8A4604                   mov al, [bp+4]
  3909 000013E5 8B5EFE                   mov  bx, [bp-2]
  3910 000013E8 8807                     mov  [bx], al
  3911                                  
  3912                                  ;-115   p++;
  3913                                  
  3914 000013EA FF46FE                   inc  word[bp-2]
  3915                                  
  3916                                  ;-116   while (alnumE(c)) {
  3917                                  
  3918                                  .getName169:
  3919 000013ED 8A4604                   mov al, byte [bp+4]
  3920 000013F0 B400                     mov ah, 0
  3921 000013F2 50                       push ax
  3922 000013F3 E81AFE                   call alnumE
  3923 000013F6 83C402                   add  sp, 2
  3924 000013F9 08C0                     or  al, al
  3925 000013FB 0F843800                 je .getName170
  3926                                  
  3927                                  ;-117     InputPtr++;
  3928                                  
  3929 000013FF FF06[1500]               inc  word[InputPtr]
  3930                                  
  3931                                  ;-118     c = *InputPtr;
  3932                                  
  3933 00001403 8B1E[1500]               mov bx, [InputPtr]
  3934 00001407 8A07                     mov al, [bx]
  3935 00001409 B400                     mov ah, 0
  3936 0000140B 884604                   mov [bp+4], al
  3937                                  
  3938                                  ;-119     *p = c;
  3939                                  
  3940 0000140E 8A4604                   mov al, [bp+4]
  3941 00001411 8B5EFE                   mov  bx, [bp-2]
  3942 00001414 8807                     mov  [bx], al
  3943                                  
  3944                                  ;-120     p++;
  3945                                  
  3946 00001416 FF46FE                   inc  word[bp-2]
  3947                                  
  3948                                  ;-121     i = p - &Symbol;
  3949                                  
  3950 00001419 8B46FE                   mov ax, [bp-2]
  3951 0000141C 2D3075                   sub ax, Symbol
  3952 0000141F 8946FC                   mov [bp-4], ax
  3953                                  
  3954                                  ;-122     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3955                                  
  3956 00001422 8B46FC                   mov ax, [bp-4]
  3957 00001425 83F81F                   cmp ax, 31 ;unsigned : 0
  3958 00001428 0F820900                 jb  .getName171
  3959 0000142C 68[7714]                 push getName_0
  3960 0000142F E8D406                   call errorexit
  3961 00001432 83C402                   add  sp, 2
  3962                                  
  3963                                  ;-123   }
  3964                                  
  3965                                  .getName171:
  3966                                  
  3967                                  ;-124   if (c == ':') isLabel=1; else isLabel=0;
  3968                                  
  3969 00001435 EBB6                     jmp .getName169
  3970                                  .getName170:
  3971 00001437 8A4604                   mov al, [bp+4]
  3972 0000143A 3C3A                     cmp al, 58
  3973 0000143C 0F850900                 jne .getName172
  3974 00001440 B80100                   mov ax, 1
  3975 00001443 A2[2C00]                 mov byte [isLabel], al
  3976 00001446 E90600                   jmp .getName173
  3977                                  .getName172:
  3978 00001449 B80000                   mov ax, 0
  3979 0000144C A2[2C00]                 mov byte [isLabel], al
  3980                                  
  3981                                  ;-125   p--;
  3982                                  
  3983                                  .getName173:
  3984 0000144F FF4EFE                   dec  word[bp-2]
  3985                                  
  3986                                  ;-126   *p = 0;
  3987                                  
  3988 00001452 B80000                   mov ax, 0
  3989 00001455 8B5EFE                   mov  bx, [bp-2]
  3990 00001458 8807                     mov  [bx], al
  3991                                  
  3992                                  ;-127   strcpy(SymbolUpper, Symbol);
  3993                                  
  3994 0000145A 8D063075                 lea  ax, [Symbol]
  3995 0000145E 50                       push ax
  3996 0000145F 8D064F75                 lea  ax, [SymbolUpper]
  3997 00001463 50                       push ax
  3998 00001464 E837FE                   call strcpy
  3999 00001467 83C404                   add  sp, 4
  4000                                  
  4001                                  ;-128   toupper(SymbolUpper);
  4002                                  
  4003 0000146A 8D064F75                 lea  ax, [SymbolUpper]
  4004 0000146E 50                       push ax
  4005 0000146F E8D3FE                   call toupper
  4006 00001472 83C402                   add  sp, 2
  4007                                  
  4008                                  ;-129 }
  4009                                  
  4010                                  
  4011                                  ;-130 int testReg() {
  4012 00001475 C9                       LEAVE
  4013 00001476 C3                       ret
  4014 00001477 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4015 00001480 6F206C6F6E6700     
  4016                                  ENDP
  4017                                  
  4018                                  testReg: PROC
  4019                                  
  4020                                  ;-131 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4021                                  
  4022                                  
  4023                                  ;-132   R2Type=0;
  4024                                  
  4025 00001487 B80000                   mov ax, 0
  4026 0000148A A2[3600]                 mov byte [R2Type], al
  4027                                  
  4028                                  ;-133   if (strlen(Symbol) < 2) return 0;
  4029                                  
  4030 0000148D 8D063075                 lea  ax, [Symbol]
  4031 00001491 50                       push ax
  4032 00001492 E8E1FD                   call strlen
  4033 00001495 83C402                   add  sp, 2
  4034 00001498 3C02                     cmp al, 2
  4035 0000149A 0F8D0600                 jge .testReg174
  4036 0000149E B80000                   mov ax, 0
  4037 000014A1 E94703                   jmp .retntestReg
  4038                                  
  4039                                  ;-134   if (strlen(Symbol) > 3) return 0;
  4040                                  
  4041                                  .testReg174:
  4042 000014A4 8D063075                 lea  ax, [Symbol]
  4043 000014A8 50                       push ax
  4044 000014A9 E8CAFD                   call strlen
  4045 000014AC 83C402                   add  sp, 2
  4046 000014AF 3C03                     cmp al, 3
  4047 000014B1 0F8E0600                 jle .testReg175
  4048 000014B5 B80000                   mov ax, 0
  4049 000014B8 E93003                   jmp .retntestReg
  4050                                  
  4051                                  ;-135   R2Type=BYTE;
  4052                                  
  4053                                  .testReg175:
  4054 000014BB B80100                   mov ax, 1
  4055 000014BE A2[3600]                 mov byte [R2Type], al
  4056                                  
  4057                                  ;-136   if (eqstr(SymbolUpper, "AL")) return 0;
  4058                                  
  4059 000014C1 68[EC17]                 push testReg_0
  4060 000014C4 8D064F75                 lea  ax, [SymbolUpper]
  4061 000014C8 50                       push ax
  4062 000014C9 E808FE                   call eqstr
  4063 000014CC 83C404                   add  sp, 4
  4064 000014CF 08C0                     or  al, al
  4065 000014D1 0F840600                 je .testReg176
  4066 000014D5 B80000                   mov ax, 0
  4067 000014D8 E91003                   jmp .retntestReg
  4068                                  
  4069                                  ;-137   if (eqstr(SymbolUpper, "CL")) return 1;
  4070                                  
  4071                                  .testReg176:
  4072 000014DB 68[EF17]                 push testReg_1
  4073 000014DE 8D064F75                 lea  ax, [SymbolUpper]
  4074 000014E2 50                       push ax
  4075 000014E3 E8EEFD                   call eqstr
  4076 000014E6 83C404                   add  sp, 4
  4077 000014E9 08C0                     or  al, al
  4078 000014EB 0F840600                 je .testReg177
  4079 000014EF B80100                   mov ax, 1
  4080 000014F2 E9F602                   jmp .retntestReg
  4081                                  
  4082                                  ;-138   if (eqstr(SymbolUpper, "DL")) return 2;
  4083                                  
  4084                                  .testReg177:
  4085 000014F5 68[F217]                 push testReg_2
  4086 000014F8 8D064F75                 lea  ax, [SymbolUpper]
  4087 000014FC 50                       push ax
  4088 000014FD E8D4FD                   call eqstr
  4089 00001500 83C404                   add  sp, 4
  4090 00001503 08C0                     or  al, al
  4091 00001505 0F840600                 je .testReg178
  4092 00001509 B80200                   mov ax, 2
  4093 0000150C E9DC02                   jmp .retntestReg
  4094                                  
  4095                                  ;-139   if (eqstr(SymbolUpper, "BL")) return 3;
  4096                                  
  4097                                  .testReg178:
  4098 0000150F 68[F517]                 push testReg_3
  4099 00001512 8D064F75                 lea  ax, [SymbolUpper]
  4100 00001516 50                       push ax
  4101 00001517 E8BAFD                   call eqstr
  4102 0000151A 83C404                   add  sp, 4
  4103 0000151D 08C0                     or  al, al
  4104 0000151F 0F840600                 je .testReg179
  4105 00001523 B80300                   mov ax, 3
  4106 00001526 E9C202                   jmp .retntestReg
  4107                                  
  4108                                  ;-140   if (eqstr(SymbolUpper, "AH")) return 4;
  4109                                  
  4110                                  .testReg179:
  4111 00001529 68[F817]                 push testReg_4
  4112 0000152C 8D064F75                 lea  ax, [SymbolUpper]
  4113 00001530 50                       push ax
  4114 00001531 E8A0FD                   call eqstr
  4115 00001534 83C404                   add  sp, 4
  4116 00001537 08C0                     or  al, al
  4117 00001539 0F840600                 je .testReg180
  4118 0000153D B80400                   mov ax, 4
  4119 00001540 E9A802                   jmp .retntestReg
  4120                                  
  4121                                  ;-141   if (eqstr(SymbolUpper, "CH")) return 5;
  4122                                  
  4123                                  .testReg180:
  4124 00001543 68[FB17]                 push testReg_5
  4125 00001546 8D064F75                 lea  ax, [SymbolUpper]
  4126 0000154A 50                       push ax
  4127 0000154B E886FD                   call eqstr
  4128 0000154E 83C404                   add  sp, 4
  4129 00001551 08C0                     or  al, al
  4130 00001553 0F840600                 je .testReg181
  4131 00001557 B80500                   mov ax, 5
  4132 0000155A E98E02                   jmp .retntestReg
  4133                                  
  4134                                  ;-142   if (eqstr(SymbolUpper, "DH")) return 6;
  4135                                  
  4136                                  .testReg181:
  4137 0000155D 68[FE17]                 push testReg_6
  4138 00001560 8D064F75                 lea  ax, [SymbolUpper]
  4139 00001564 50                       push ax
  4140 00001565 E86CFD                   call eqstr
  4141 00001568 83C404                   add  sp, 4
  4142 0000156B 08C0                     or  al, al
  4143 0000156D 0F840600                 je .testReg182
  4144 00001571 B80600                   mov ax, 6
  4145 00001574 E97402                   jmp .retntestReg
  4146                                  
  4147                                  ;-143   if (eqstr(SymbolUpper, "BH")) return 7;
  4148                                  
  4149                                  .testReg182:
  4150 00001577 68[0118]                 push testReg_7
  4151 0000157A 8D064F75                 lea  ax, [SymbolUpper]
  4152 0000157E 50                       push ax
  4153 0000157F E852FD                   call eqstr
  4154 00001582 83C404                   add  sp, 4
  4155 00001585 08C0                     or  al, al
  4156 00001587 0F840600                 je .testReg183
  4157 0000158B B80700                   mov ax, 7
  4158 0000158E E95A02                   jmp .retntestReg
  4159                                  
  4160                                  ;-144   R2Type=WORD;
  4161                                  
  4162                                  .testReg183:
  4163 00001591 B80200                   mov ax, 2
  4164 00001594 A2[3600]                 mov byte [R2Type], al
  4165                                  
  4166                                  ;-145   if (eqstr(SymbolUpper, "AX")) return 0;
  4167                                  
  4168 00001597 68[0418]                 push testReg_8
  4169 0000159A 8D064F75                 lea  ax, [SymbolUpper]
  4170 0000159E 50                       push ax
  4171 0000159F E832FD                   call eqstr
  4172 000015A2 83C404                   add  sp, 4
  4173 000015A5 08C0                     or  al, al
  4174 000015A7 0F840600                 je .testReg184
  4175 000015AB B80000                   mov ax, 0
  4176 000015AE E93A02                   jmp .retntestReg
  4177                                  
  4178                                  ;-146   if (eqstr(SymbolUpper, "CX")) return 1;
  4179                                  
  4180                                  .testReg184:
  4181 000015B1 68[0718]                 push testReg_9
  4182 000015B4 8D064F75                 lea  ax, [SymbolUpper]
  4183 000015B8 50                       push ax
  4184 000015B9 E818FD                   call eqstr
  4185 000015BC 83C404                   add  sp, 4
  4186 000015BF 08C0                     or  al, al
  4187 000015C1 0F840600                 je .testReg185
  4188 000015C5 B80100                   mov ax, 1
  4189 000015C8 E92002                   jmp .retntestReg
  4190                                  
  4191                                  ;-147   if (eqstr(SymbolUpper, "DX")) return 2;
  4192                                  
  4193                                  .testReg185:
  4194 000015CB 68[0A18]                 push testReg_10
  4195 000015CE 8D064F75                 lea  ax, [SymbolUpper]
  4196 000015D2 50                       push ax
  4197 000015D3 E8FEFC                   call eqstr
  4198 000015D6 83C404                   add  sp, 4
  4199 000015D9 08C0                     or  al, al
  4200 000015DB 0F840600                 je .testReg186
  4201 000015DF B80200                   mov ax, 2
  4202 000015E2 E90602                   jmp .retntestReg
  4203                                  
  4204                                  ;-148   if (eqstr(SymbolUpper, "BX")) return 3;
  4205                                  
  4206                                  .testReg186:
  4207 000015E5 68[0D18]                 push testReg_11
  4208 000015E8 8D064F75                 lea  ax, [SymbolUpper]
  4209 000015EC 50                       push ax
  4210 000015ED E8E4FC                   call eqstr
  4211 000015F0 83C404                   add  sp, 4
  4212 000015F3 08C0                     or  al, al
  4213 000015F5 0F840600                 je .testReg187
  4214 000015F9 B80300                   mov ax, 3
  4215 000015FC E9EC01                   jmp .retntestReg
  4216                                  
  4217                                  ;-149   if (eqstr(SymbolUpper, "SP")) return 4;
  4218                                  
  4219                                  .testReg187:
  4220 000015FF 68[1018]                 push testReg_12
  4221 00001602 8D064F75                 lea  ax, [SymbolUpper]
  4222 00001606 50                       push ax
  4223 00001607 E8CAFC                   call eqstr
  4224 0000160A 83C404                   add  sp, 4
  4225 0000160D 08C0                     or  al, al
  4226 0000160F 0F840600                 je .testReg188
  4227 00001613 B80400                   mov ax, 4
  4228 00001616 E9D201                   jmp .retntestReg
  4229                                  
  4230                                  ;-150   if (eqstr(SymbolUpper, "BP")) return 5;
  4231                                  
  4232                                  .testReg188:
  4233 00001619 68[1318]                 push testReg_13
  4234 0000161C 8D064F75                 lea  ax, [SymbolUpper]
  4235 00001620 50                       push ax
  4236 00001621 E8B0FC                   call eqstr
  4237 00001624 83C404                   add  sp, 4
  4238 00001627 08C0                     or  al, al
  4239 00001629 0F840600                 je .testReg189
  4240 0000162D B80500                   mov ax, 5
  4241 00001630 E9B801                   jmp .retntestReg
  4242                                  
  4243                                  ;-151   if (eqstr(SymbolUpper, "SI")) return 6;
  4244                                  
  4245                                  .testReg189:
  4246 00001633 68[1618]                 push testReg_14
  4247 00001636 8D064F75                 lea  ax, [SymbolUpper]
  4248 0000163A 50                       push ax
  4249 0000163B E896FC                   call eqstr
  4250 0000163E 83C404                   add  sp, 4
  4251 00001641 08C0                     or  al, al
  4252 00001643 0F840600                 je .testReg190
  4253 00001647 B80600                   mov ax, 6
  4254 0000164A E99E01                   jmp .retntestReg
  4255                                  
  4256                                  ;-152   if (eqstr(SymbolUpper, "DI")) return 7;
  4257                                  
  4258                                  .testReg190:
  4259 0000164D 68[1918]                 push testReg_15
  4260 00001650 8D064F75                 lea  ax, [SymbolUpper]
  4261 00001654 50                       push ax
  4262 00001655 E87CFC                   call eqstr
  4263 00001658 83C404                   add  sp, 4
  4264 0000165B 08C0                     or  al, al
  4265 0000165D 0F840600                 je .testReg191
  4266 00001661 B80700                   mov ax, 7
  4267 00001664 E98401                   jmp .retntestReg
  4268                                  
  4269                                  ;-153   R2Type=SEGREG;
  4270                                  
  4271                                  .testReg191:
  4272 00001667 B80400                   mov ax, 4
  4273 0000166A A2[3600]                 mov byte [R2Type], al
  4274                                  
  4275                                  ;-154   if (eqstr(SymbolUpper, "ES")) return 0;
  4276                                  
  4277 0000166D 68[1C18]                 push testReg_16
  4278 00001670 8D064F75                 lea  ax, [SymbolUpper]
  4279 00001674 50                       push ax
  4280 00001675 E85CFC                   call eqstr
  4281 00001678 83C404                   add  sp, 4
  4282 0000167B 08C0                     or  al, al
  4283 0000167D 0F840600                 je .testReg192
  4284 00001681 B80000                   mov ax, 0
  4285 00001684 E96401                   jmp .retntestReg
  4286                                  
  4287                                  ;-155   if (eqstr(SymbolUpper, "CS")) return 1;
  4288                                  
  4289                                  .testReg192:
  4290 00001687 68[1F18]                 push testReg_17
  4291 0000168A 8D064F75                 lea  ax, [SymbolUpper]
  4292 0000168E 50                       push ax
  4293 0000168F E842FC                   call eqstr
  4294 00001692 83C404                   add  sp, 4
  4295 00001695 08C0                     or  al, al
  4296 00001697 0F840600                 je .testReg193
  4297 0000169B B80100                   mov ax, 1
  4298 0000169E E94A01                   jmp .retntestReg
  4299                                  
  4300                                  ;-156   if (eqstr(SymbolUpper, "SS")) return 2;
  4301                                  
  4302                                  .testReg193:
  4303 000016A1 68[2218]                 push testReg_18
  4304 000016A4 8D064F75                 lea  ax, [SymbolUpper]
  4305 000016A8 50                       push ax
  4306 000016A9 E828FC                   call eqstr
  4307 000016AC 83C404                   add  sp, 4
  4308 000016AF 08C0                     or  al, al
  4309 000016B1 0F840600                 je .testReg194
  4310 000016B5 B80200                   mov ax, 2
  4311 000016B8 E93001                   jmp .retntestReg
  4312                                  
  4313                                  ;-157   if (eqstr(SymbolUpper, "DS")) return 3;
  4314                                  
  4315                                  .testReg194:
  4316 000016BB 68[2518]                 push testReg_19
  4317 000016BE 8D064F75                 lea  ax, [SymbolUpper]
  4318 000016C2 50                       push ax
  4319 000016C3 E80EFC                   call eqstr
  4320 000016C6 83C404                   add  sp, 4
  4321 000016C9 08C0                     or  al, al
  4322 000016CB 0F840600                 je .testReg195
  4323 000016CF B80300                   mov ax, 3
  4324 000016D2 E91601                   jmp .retntestReg
  4325                                  
  4326                                  ;-158   if (eqstr(SymbolUpper, "FS")) return 4;
  4327                                  
  4328                                  .testReg195:
  4329 000016D5 68[2818]                 push testReg_20
  4330 000016D8 8D064F75                 lea  ax, [SymbolUpper]
  4331 000016DC 50                       push ax
  4332 000016DD E8F4FB                   call eqstr
  4333 000016E0 83C404                   add  sp, 4
  4334 000016E3 08C0                     or  al, al
  4335 000016E5 0F840600                 je .testReg196
  4336 000016E9 B80400                   mov ax, 4
  4337 000016EC E9FC00                   jmp .retntestReg
  4338                                  
  4339                                  ;-159   if (eqstr(SymbolUpper, "GS")) return 5;
  4340                                  
  4341                                  .testReg196:
  4342 000016EF 68[2B18]                 push testReg_21
  4343 000016F2 8D064F75                 lea  ax, [SymbolUpper]
  4344 000016F6 50                       push ax
  4345 000016F7 E8DAFB                   call eqstr
  4346 000016FA 83C404                   add  sp, 4
  4347 000016FD 08C0                     or  al, al
  4348 000016FF 0F840600                 je .testReg197
  4349 00001703 B80500                   mov ax, 5
  4350 00001706 E9E200                   jmp .retntestReg
  4351                                  
  4352                                  ;-160   R2Type=DWORD;
  4353                                  
  4354                                  .testReg197:
  4355 00001709 B80300                   mov ax, 3
  4356 0000170C A2[3600]                 mov byte [R2Type], al
  4357                                  
  4358                                  ;-161   if (eqstr(SymbolUpper, "EAX"))return 0;
  4359                                  
  4360 0000170F 68[2E18]                 push testReg_22
  4361 00001712 8D064F75                 lea  ax, [SymbolUpper]
  4362 00001716 50                       push ax
  4363 00001717 E8BAFB                   call eqstr
  4364 0000171A 83C404                   add  sp, 4
  4365 0000171D 08C0                     or  al, al
  4366 0000171F 0F840600                 je .testReg198
  4367 00001723 B80000                   mov ax, 0
  4368 00001726 E9C200                   jmp .retntestReg
  4369                                  
  4370                                  ;-162   if (eqstr(SymbolUpper, "ECX"))return 1;
  4371                                  
  4372                                  .testReg198:
  4373 00001729 68[3218]                 push testReg_23
  4374 0000172C 8D064F75                 lea  ax, [SymbolUpper]
  4375 00001730 50                       push ax
  4376 00001731 E8A0FB                   call eqstr
  4377 00001734 83C404                   add  sp, 4
  4378 00001737 08C0                     or  al, al
  4379 00001739 0F840600                 je .testReg199
  4380 0000173D B80100                   mov ax, 1
  4381 00001740 E9A800                   jmp .retntestReg
  4382                                  
  4383                                  ;-163   if (eqstr(SymbolUpper, "EDX"))return 2;
  4384                                  
  4385                                  .testReg199:
  4386 00001743 68[3618]                 push testReg_24
  4387 00001746 8D064F75                 lea  ax, [SymbolUpper]
  4388 0000174A 50                       push ax
  4389 0000174B E886FB                   call eqstr
  4390 0000174E 83C404                   add  sp, 4
  4391 00001751 08C0                     or  al, al
  4392 00001753 0F840600                 je .testReg200
  4393 00001757 B80200                   mov ax, 2
  4394 0000175A E98E00                   jmp .retntestReg
  4395                                  
  4396                                  ;-164   if (eqstr(SymbolUpper, "EBX"))return 3;
  4397                                  
  4398                                  .testReg200:
  4399 0000175D 68[3A18]                 push testReg_25
  4400 00001760 8D064F75                 lea  ax, [SymbolUpper]
  4401 00001764 50                       push ax
  4402 00001765 E86CFB                   call eqstr
  4403 00001768 83C404                   add  sp, 4
  4404 0000176B 08C0                     or  al, al
  4405 0000176D 0F840600                 je .testReg201
  4406 00001771 B80300                   mov ax, 3
  4407 00001774 E97400                   jmp .retntestReg
  4408                                  
  4409                                  ;-165   if (eqstr(SymbolUpper, "ESP"))return 4;
  4410                                  
  4411                                  .testReg201:
  4412 00001777 68[3E18]                 push testReg_26
  4413 0000177A 8D064F75                 lea  ax, [SymbolUpper]
  4414 0000177E 50                       push ax
  4415 0000177F E852FB                   call eqstr
  4416 00001782 83C404                   add  sp, 4
  4417 00001785 08C0                     or  al, al
  4418 00001787 0F840600                 je .testReg202
  4419 0000178B B80400                   mov ax, 4
  4420 0000178E E95A00                   jmp .retntestReg
  4421                                  
  4422                                  ;-166   if (eqstr(SymbolUpper, "EBP"))return 5;
  4423                                  
  4424                                  .testReg202:
  4425 00001791 68[4218]                 push testReg_27
  4426 00001794 8D064F75                 lea  ax, [SymbolUpper]
  4427 00001798 50                       push ax
  4428 00001799 E838FB                   call eqstr
  4429 0000179C 83C404                   add  sp, 4
  4430 0000179F 08C0                     or  al, al
  4431 000017A1 0F840600                 je .testReg203
  4432 000017A5 B80500                   mov ax, 5
  4433 000017A8 E94000                   jmp .retntestReg
  4434                                  
  4435                                  ;-167   if (eqstr(SymbolUpper, "ESI"))return 6;
  4436                                  
  4437                                  .testReg203:
  4438 000017AB 68[4618]                 push testReg_28
  4439 000017AE 8D064F75                 lea  ax, [SymbolUpper]
  4440 000017B2 50                       push ax
  4441 000017B3 E81EFB                   call eqstr
  4442 000017B6 83C404                   add  sp, 4
  4443 000017B9 08C0                     or  al, al
  4444 000017BB 0F840600                 je .testReg204
  4445 000017BF B80600                   mov ax, 6
  4446 000017C2 E92600                   jmp .retntestReg
  4447                                  
  4448                                  ;-168   if (eqstr(SymbolUpper, "EDI"))return 7;
  4449                                  
  4450                                  .testReg204:
  4451 000017C5 68[4A18]                 push testReg_29
  4452 000017C8 8D064F75                 lea  ax, [SymbolUpper]
  4453 000017CC 50                       push ax
  4454 000017CD E804FB                   call eqstr
  4455 000017D0 83C404                   add  sp, 4
  4456 000017D3 08C0                     or  al, al
  4457 000017D5 0F840600                 je .testReg205
  4458 000017D9 B80700                   mov ax, 7
  4459 000017DC E90C00                   jmp .retntestReg
  4460                                  
  4461                                  ;-169   R2Type=0; return 0;
  4462                                  
  4463                                  .testReg205:
  4464 000017DF B80000                   mov ax, 0
  4465 000017E2 A2[3600]                 mov byte [R2Type], al
  4466 000017E5 B80000                   mov ax, 0
  4467 000017E8 E90000                   jmp .retntestReg
  4468                                  
  4469                                  ;-170 }
  4470                                  
  4471                                   .retntestReg:
  4472 000017EB C3                       ret
  4473 000017EC 414C00                  testReg_0 db "AL",0
  4474 000017EF 434C00                  testReg_1 db "CL",0
  4475 000017F2 444C00                  testReg_2 db "DL",0
  4476 000017F5 424C00                  testReg_3 db "BL",0
  4477 000017F8 414800                  testReg_4 db "AH",0
  4478 000017FB 434800                  testReg_5 db "CH",0
  4479 000017FE 444800                  testReg_6 db "DH",0
  4480 00001801 424800                  testReg_7 db "BH",0
  4481 00001804 415800                  testReg_8 db "AX",0
  4482 00001807 435800                  testReg_9 db "CX",0
  4483 0000180A 445800                  testReg_10 db "DX",0
  4484 0000180D 425800                  testReg_11 db "BX",0
  4485 00001810 535000                  testReg_12 db "SP",0
  4486 00001813 425000                  testReg_13 db "BP",0
  4487 00001816 534900                  testReg_14 db "SI",0
  4488 00001819 444900                  testReg_15 db "DI",0
  4489 0000181C 455300                  testReg_16 db "ES",0
  4490 0000181F 435300                  testReg_17 db "CS",0
  4491 00001822 535300                  testReg_18 db "SS",0
  4492 00001825 445300                  testReg_19 db "DS",0
  4493 00001828 465300                  testReg_20 db "FS",0
  4494 0000182B 475300                  testReg_21 db "GS",0
  4495 0000182E 45415800                testReg_22 db "EAX",0
  4496 00001832 45435800                testReg_23 db "ECX",0
  4497 00001836 45445800                testReg_24 db "EDX",0
  4498 0000183A 45425800                testReg_25 db "EBX",0
  4499 0000183E 45535000                testReg_26 db "ESP",0
  4500 00001842 45425000                testReg_27 db "EBP",0
  4501 00001846 45534900                testReg_28 db "ESI",0
  4502 0000184A 45444900                testReg_29 db "EDI",0
  4503                                  ENDP
  4504                                  ;Back to main program: AS.C
  4505                                  
  4506                                  ;-7 #include "OUTPUT.C"
  4507                                  
  4508                                  ;Use include file: OUTPUT.C
  4509                                  
  4510                                  ;-1 int printLine() {
  4511                                  
  4512                                  
  4513                                  printLine: PROC
  4514                                  
  4515                                  ;-2     int i; char c;
  4516                                  
  4517                                  
  4518                                  ;-3     prs("\n");
  4519                                  
  4520                                  ;Function : printLine, Number of local variables: 2
  4521                                  ;   # type sign width addr used name   list of local variables
  4522                                  ;  200 var sign word     2 NULL i = bp-2
  4523                                  ;  201 var sign byte     2 NULL c = bp-4;
  4524 0000184E C8040000                 ENTER  4,0
  4525 00001852 68[E018]                 push printLine_0
  4526 00001855 E80001                   call prs
  4527 00001858 83C402                   add  sp, 2
  4528                                  
  4529                                  ;-4     printhex16(PCStart);
  4530                                  
  4531 0000185B FF36[2A00]               push word [PCStart]
  4532 0000185F E8DC01                   call printhex16
  4533 00001862 83C402                   add  sp, 2
  4534                                  
  4535                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  4536                                  
  4537 00001865 A1[4200]                 mov ax, [OpPrintIndex]
  4538 00001868 83F800                   cmp ax, 0
  4539 0000186B 0F850C00                 jne .printLine206
  4540 0000186F 68[E318]                 push printLine_1
  4541 00001872 E8E300                   call prs
  4542 00001875 83C402                   add  sp, 2
  4543                                  
  4544                                  ;-6     else {
  4545                                  
  4546 00001878 E94C00                   jmp .printLine207
  4547                                  .printLine206:
  4548                                  
  4549                                  ;-7 //        prc(' ');
  4550                                  
  4551                                  
  4552                                  ;-8         i=0;
  4553                                  
  4554 0000187B B80000                   mov ax, 0
  4555 0000187E 8946FE                   mov [bp-2], ax
  4556                                  
  4557                                  ;-9         do {
  4558                                  
  4559                                  .printLine208:
  4560                                  
  4561                                  ;-10             c=OpPos[i];
  4562                                  
  4563 00001881 8B5EFE                   mov bx, [bp-2]
  4564 00001884 8A875577                 mov al, [OpPos + bx]
  4565 00001888 8846FC                   mov [bp-4], al
  4566                                  
  4567                                  ;-11             prc(' ');
  4568                                  
  4569 0000188B 6A20                     push 32
  4570 0000188D E86700                   call prc
  4571 00001890 83C402                   add  sp, 2
  4572                                  
  4573                                  ;-12             printhex8a(c);
  4574                                  
  4575 00001893 8A46FC                   mov al, byte [bp-4]
  4576 00001896 B400                     mov ah, 0
  4577 00001898 50                       push ax
  4578 00001899 E85001                   call printhex8a
  4579 0000189C 83C402                   add  sp, 2
  4580                                  
  4581                                  ;-13             i++;
  4582                                  
  4583 0000189F FF46FE                   inc  word[bp-2]
  4584                                  
  4585                                  ;-14         } while (i < OpPrintIndex);
  4586                                  
  4587 000018A2 8B46FE                   mov ax, [bp-2]
  4588 000018A5 3B06[4200]               cmp ax, [OpPrintIndex]
  4589 000018A9 0F8D0200                 jge .printLine209
  4590 000018AD EBD2                     jmp .printLine208
  4591                                  .printLine209:
  4592                                  
  4593                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  4594                                  
  4595                                  .printLine210:
  4596 000018AF 8B46FE                   mov ax, [bp-2]
  4597 000018B2 83F805                   cmp ax, 5
  4598 000018B5 0F8D0E00                 jge .printLine211
  4599                                  
  4600                                  ;-16             prs("   ");
  4601                                  
  4602 000018B9 68[F318]                 push printLine_2
  4603 000018BC E89900                   call prs
  4604 000018BF 83C402                   add  sp, 2
  4605                                  
  4606                                  ;-17             i++;
  4607                                  
  4608 000018C2 FF46FE                   inc  word[bp-2]
  4609                                  
  4610                                  ;-18         }
  4611                                  
  4612                                  
  4613                                  ;-19     }
  4614                                  
  4615 000018C5 EBE8                     jmp .printLine210
  4616                                  .printLine211:
  4617                                  
  4618                                  ;-20     prc(PrintRA);
  4619                                  
  4620                                  .printLine207:
  4621 000018C7 A0[4600]                 mov al, byte [PrintRA]
  4622 000018CA B400                     mov ah, 0
  4623 000018CC 50                       push ax
  4624 000018CD E82700                   call prc
  4625 000018D0 83C402                   add  sp, 2
  4626                                  
  4627                                  ;-21     prscomment(InputBuf);
  4628                                  
  4629 000018D3 8D068D75                 lea  ax, [InputBuf]
  4630 000018D7 50                       push ax
  4631 000018D8 E84F00                   call prscomment
  4632 000018DB 83C402                   add  sp, 2
  4633                                  
  4634                                  ;-22 }
  4635                                  
  4636                                  
  4637                                  ;-23 int prc(unsigned char c) {//print char
  4638 000018DE C9                       LEAVE
  4639 000018DF C3                       ret
  4640 000018E0 5C6E00                  printLine_0 db "\n",0
  4641 000018E3 202020202020202020-     printLine_1 db "               ",0
  4642 000018EC 20202020202000     
  4643 000018F3 20202000                printLine_2 db "   ",0
  4644                                  ENDP
  4645                                  
  4646                                  prc: PROC
  4647                                  
  4648                                  ;-24     if (LIST) {
  4649                                  
  4650                                  ;Function : prc, Number of local variables: 1
  4651                                  ;   # type sign width addr used name   list of local variables
  4652                                  ;  200 var unsg byte    23 NULL c = bp+4;
  4653 000018F7 C8000000                 ENTER  0,0
  4654 000018FB A0[0D00]                 mov al, [LIST]
  4655 000018FE 08C0                     or  al, al
  4656 00001900 0F841400                 je .prc212
  4657                                  
  4658                                  ;-25         if ( _ c==10) {
  4659                                   ; constant expression
  4660 00001904 807E040A                cmp byte[bp+4], 10
  4661 00001908 0F850600                 jne .prc213
  4662                                  
  4663                                  ;-26             ax=13;
  4664                                  
  4665 0000190C B80D00                   mov  ax, 13
  4666                                  
  4667                                  ;-27             writetty();
  4668                                  
  4669 0000190F E874F6                   call writetty
  4670                                  
  4671                                  ;-28             }
  4672                                  
  4673                                  
  4674                                  ;-29         al=c;
  4675                                  
  4676                                  .prc213:
  4677 00001912 8A4604                   mov  al, [bp+4]
  4678                                  
  4679                                  ;-30         writetty();
  4680                                  
  4681 00001915 E86EF6                   call writetty
  4682                                  
  4683                                  ;-31         }
  4684                                  
  4685                                  
  4686                                  ;-32     fputcR(c,lst_fd);
  4687                                  
  4688                                  .prc212:
  4689 00001918 FF36[1900]               push word [lst_fd]
  4690 0000191C 8A4604                   mov al, byte [bp+4]
  4691 0000191F B400                     mov ah, 0
  4692 00001921 50                       push ax
  4693 00001922 E80CF7                   call fputcR
  4694 00001925 83C404                   add  sp, 4
  4695                                  
  4696                                  ;-33 }
  4697                                  
  4698                                  
  4699                                  ;-34 
  4700                                  
  4701                                  
  4702                                  ;-35 int prscomment(unsigned char *s) {
  4703 00001928 C9                       LEAVE
  4704 00001929 C3                       ret
  4705                                  ENDP
  4706                                  
  4707                                  prscomment: PROC
  4708                                  
  4709                                  ;-36     unsigned char c;
  4710                                  
  4711                                  
  4712                                  ;-37     while (*s){
  4713                                  
  4714                                  ;Function : prscomment, Number of local variables: 2
  4715                                  ;   # type sign width addr used name   list of local variables
  4716                                  ;  200 ptr unsg byte    35 NULL s = bp+4
  4717                                  ;  201 var unsg byte    36 NULL c = bp-2;
  4718 0000192A C8020000                 ENTER  2,0
  4719                                  .prscomment214:
  4720 0000192E 8B5E04                   mov bx, [bp+4]
  4721 00001931 8A07                     mov al, [bx]
  4722 00001933 B400                     mov ah, 0
  4723 00001935 08C0                     or  al, al
  4724 00001937 0F841B00                 je .prscomment215
  4725                                  
  4726                                  ;-38         c=*s;
  4727                                  
  4728 0000193B 8B5E04                   mov bx, [bp+4]
  4729 0000193E 8A07                     mov al, [bx]
  4730 00001940 B400                     mov ah, 0
  4731 00001942 8846FE                   mov [bp-2], al
  4732                                  
  4733                                  ;-39         prc(c);
  4734                                  
  4735 00001945 8A46FE                   mov al, byte [bp-2]
  4736 00001948 B400                     mov ah, 0
  4737 0000194A 50                       push ax
  4738 0000194B E8A9FF                   call prc
  4739 0000194E 83C402                   add  sp, 2
  4740                                  
  4741                                  ;-40         s++;
  4742                                  
  4743 00001951 FF4604                   inc  word[bp+4]
  4744                                  
  4745                                  ;-41     }
  4746                                  
  4747                                  
  4748                                  ;-42 }
  4749                                  
  4750 00001954 EBD8                     jmp .prscomment214
  4751                                  .prscomment215:
  4752                                  
  4753                                  ;-43 int prs(unsigned char *s) {
  4754 00001956 C9                       LEAVE
  4755 00001957 C3                       ret
  4756                                  ENDP
  4757                                  
  4758                                  prs: PROC
  4759                                  
  4760                                  ;-44     unsigned char c;
  4761                                  
  4762                                  
  4763                                  ;-45     int com;
  4764                                  
  4765                                  
  4766                                  ;-46     com=0;
  4767                                  
  4768                                  ;Function : prs, Number of local variables: 3
  4769                                  ;   # type sign width addr used name   list of local variables
  4770                                  ;  200 ptr unsg byte    43 NULL s = bp+4
  4771                                  ;  201 var unsg byte    44 NULL c = bp-2
  4772                                  ;  202 var sign word    45 NULL com = bp-4;
  4773 00001958 C8040000                 ENTER  4,0
  4774 0000195C B80000                   mov ax, 0
  4775 0000195F 8946FC                   mov [bp-4], ax
  4776                                  
  4777                                  ;-47     while (*s) {
  4778                                  
  4779                                  .prs216:
  4780 00001962 8B5E04                   mov bx, [bp+4]
  4781 00001965 8A07                     mov al, [bx]
  4782 00001967 B400                     mov ah, 0
  4783 00001969 08C0                     or  al, al
  4784 0000196B 0F847B00                 je .prs217
  4785                                  
  4786                                  ;-48         c=*s;
  4787                                  
  4788 0000196F 8B5E04                   mov bx, [bp+4]
  4789 00001972 8A07                     mov al, [bx]
  4790 00001974 B400                     mov ah, 0
  4791 00001976 8846FE                   mov [bp-2], al
  4792                                  
  4793                                  ;-49         if (c==34) {
  4794                                  
  4795 00001979 8A46FE                   mov al, [bp-2]
  4796 0000197C 3C22                     cmp al, 34
  4797 0000197E 0F851800                 jne .prs218
  4798                                  
  4799                                  ;-50             if (com) com=0;
  4800                                  
  4801 00001982 8B46FC                   mov ax, [bp-4]
  4802 00001985 08C0                     or  al, al
  4803 00001987 0F840900                 je .prs219
  4804 0000198B B80000                   mov ax, 0
  4805 0000198E 8946FC                   mov [bp-4], ax
  4806                                  
  4807                                  ;-51                 else com=1;
  4808                                  
  4809 00001991 E90600                   jmp .prs220
  4810                                  .prs219:
  4811 00001994 B80100                   mov ax, 1
  4812 00001997 8946FC                   mov [bp-4], ax
  4813                                  
  4814                                  ;-52         }
  4815                                  
  4816                                  .prs220:
  4817                                  
  4818                                  ;-53         if (c==92) {
  4819                                  
  4820                                  .prs218:
  4821 0000199A 8A46FE                   mov al, [bp-2]
  4822 0000199D 3C5C                     cmp al, 92
  4823 0000199F 0F853500                 jne .prs221
  4824                                  
  4825                                  ;-54             if (com==0) {
  4826                                  
  4827 000019A3 8B46FC                   mov ax, [bp-4]
  4828 000019A6 83F800                   cmp ax, 0
  4829 000019A9 0F852B00                 jne .prs222
  4830                                  
  4831                                  ;-55                 s++;
  4832                                  
  4833 000019AD FF4604                   inc  word[bp+4]
  4834                                  
  4835                                  ;-56                 c=*s;
  4836                                  
  4837 000019B0 8B5E04                   mov bx, [bp+4]
  4838 000019B3 8A07                     mov al, [bx]
  4839 000019B5 B400                     mov ah, 0
  4840 000019B7 8846FE                   mov [bp-2], al
  4841                                  
  4842                                  ;-57                 if (c=='n') c=10;
  4843                                  
  4844 000019BA 8A46FE                   mov al, [bp-2]
  4845 000019BD 3C6E                     cmp al, 110
  4846 000019BF 0F850600                 jne .prs223
  4847 000019C3 B80A00                   mov ax, 10
  4848 000019C6 8846FE                   mov [bp-2], al
  4849                                  
  4850                                  ;-58                 if (c=='t') c= 9;
  4851                                  
  4852                                  .prs223:
  4853 000019C9 8A46FE                   mov al, [bp-2]
  4854 000019CC 3C74                     cmp al, 116
  4855 000019CE 0F850600                 jne .prs224
  4856 000019D2 B80900                   mov ax, 9
  4857 000019D5 8846FE                   mov [bp-2], al
  4858                                  
  4859                                  ;-59             }
  4860                                  
  4861                                  .prs224:
  4862                                  
  4863                                  ;-60         }
  4864                                  
  4865                                  .prs222:
  4866                                  
  4867                                  ;-61         prc(c);
  4868                                  
  4869                                  .prs221:
  4870 000019D8 8A46FE                   mov al, byte [bp-2]
  4871 000019DB B400                     mov ah, 0
  4872 000019DD 50                       push ax
  4873 000019DE E816FF                   call prc
  4874 000019E1 83C402                   add  sp, 2
  4875                                  
  4876                                  ;-62         s++;
  4877                                  
  4878 000019E4 FF4604                   inc  word[bp+4]
  4879                                  
  4880                                  ;-63     }
  4881                                  
  4882                                  
  4883                                  ;-64 }
  4884                                  
  4885 000019E7 E978FF                   jmp .prs216
  4886                                  .prs217:
  4887                                  
  4888                                  ;-65 int printhex8a(unsigned char c) {
  4889 000019EA C9                       LEAVE
  4890 000019EB C3                       ret
  4891                                  ENDP
  4892                                  
  4893                                  printhex8a: PROC
  4894                                  
  4895                                  ;-66     unsigned char nib;
  4896                                  
  4897                                  
  4898                                  ;-67     nib = c >> 4; printhex4(nib);
  4899                                  
  4900                                  ;Function : printhex8a, Number of local variables: 2
  4901                                  ;   # type sign width addr used name   list of local variables
  4902                                  ;  200 var unsg byte    65 NULL c = bp+4
  4903                                  ;  201 var unsg byte    66 NULL nib = bp-2;
  4904 000019EC C8020000                 ENTER  2,0
  4905 000019F0 8A4604                   mov al, [bp+4]
  4906 000019F3 C0E804                   shr al, 4
  4907 000019F6 8846FE                   mov [bp-2], al
  4908 000019F9 8A46FE                   mov al, byte [bp-2]
  4909 000019FC B400                     mov ah, 0
  4910 000019FE 50                       push ax
  4911 000019FF E81900                   call printhex4
  4912 00001A02 83C402                   add  sp, 2
  4913                                  
  4914                                  ;-68     nib = c & 15; printhex4(nib);
  4915                                  
  4916 00001A05 8A4604                   mov al, [bp+4]
  4917 00001A08 240F                     and al, 15
  4918 00001A0A 8846FE                   mov [bp-2], al
  4919 00001A0D 8A46FE                   mov al, byte [bp-2]
  4920 00001A10 B400                     mov ah, 0
  4921 00001A12 50                       push ax
  4922 00001A13 E80500                   call printhex4
  4923 00001A16 83C402                   add  sp, 2
  4924                                  
  4925                                  ;-69 }
  4926                                  
  4927                                  
  4928                                  ;-70 int printhex4(unsigned char c) {
  4929 00001A19 C9                       LEAVE
  4930 00001A1A C3                       ret
  4931                                  ENDP
  4932                                  
  4933                                  printhex4: PROC
  4934                                  
  4935                                  ;-71     c += 48;
  4936                                  
  4937                                  ;Function : printhex4, Number of local variables: 1
  4938                                  ;   # type sign width addr used name   list of local variables
  4939                                  ;  200 var unsg byte    70 NULL c = bp+4;
  4940 00001A1B C8000000                 ENTER  0,0
  4941 00001A1F 80460430                 add  byte[bp+4], 48
  4942                                  
  4943                                  ;-72     if (c > 57) c += 7;
  4944                                  
  4945 00001A23 8A4604                   mov al, [bp+4]
  4946 00001A26 3C39                     cmp al, 57
  4947 00001A28 0F8E0400                 jle .printhex4225
  4948 00001A2C 80460407                 add  byte[bp+4], 7
  4949                                  
  4950                                  ;-73     prc(c);
  4951                                  
  4952                                  .printhex4225:
  4953 00001A30 8A4604                   mov al, byte [bp+4]
  4954 00001A33 B400                     mov ah, 0
  4955 00001A35 50                       push ax
  4956 00001A36 E8BEFE                   call prc
  4957 00001A39 83C402                   add  sp, 2
  4958                                  
  4959                                  ;-74 }
  4960                                  
  4961                                  
  4962                                  ;-75 int printhex16(unsigned int i) {
  4963 00001A3C C9                       LEAVE
  4964 00001A3D C3                       ret
  4965                                  ENDP
  4966                                  
  4967                                  printhex16: PROC
  4968                                  
  4969                                  ;-76     unsigned int half;
  4970                                  
  4971                                  
  4972                                  ;-77     half = i >>  8; printhex8a(half);
  4973                                  
  4974                                  ;Function : printhex16, Number of local variables: 2
  4975                                  ;   # type sign width addr used name   list of local variables
  4976                                  ;  200 var unsg word    75 NULL i = bp+4
  4977                                  ;  201 var unsg word    76 NULL half = bp-2;
  4978 00001A3E C8020000                 ENTER  2,0
  4979 00001A42 8B4604                   mov ax, [bp+4]
  4980 00001A45 C1E808                   shr ax, 8
  4981 00001A48 8946FE                   mov [bp-2], ax
  4982 00001A4B FF76FE                   push word [bp-2]
  4983 00001A4E E89BFF                   call printhex8a
  4984 00001A51 83C402                   add  sp, 2
  4985                                  
  4986                                  ;-78     half = i & 255; printhex8a(half);
  4987                                  
  4988 00001A54 8B4604                   mov ax, [bp+4]
  4989 00001A57 25FF00                   and ax, 255
  4990 00001A5A 8946FE                   mov [bp-2], ax
  4991 00001A5D FF76FE                   push word [bp-2]
  4992 00001A60 E889FF                   call printhex8a
  4993 00001A63 83C402                   add  sp, 2
  4994                                  
  4995                                  ;-79 }
  4996                                  
  4997                                  
  4998                                  ;-80 int printIntU(unsigned int n) {
  4999 00001A66 C9                       LEAVE
  5000 00001A67 C3                       ret
  5001                                  ENDP
  5002                                  
  5003                                  printIntU: PROC
  5004                                  
  5005                                  ;-81     unsigned int e;
  5006                                  
  5007                                  
  5008                                  ;-82     if ( _ n >= 10) {
  5009                                  
  5010                                  ;Function : printIntU, Number of local variables: 2
  5011                                  ;   # type sign width addr used name   list of local variables
  5012                                  ;  200 var unsg word    80 NULL n = bp+4
  5013                                  ;  201 var unsg word    81 NULL e = bp-2;
  5014 00001A68 C8020000                 ENTER  2,0 ; constant expression
  5015 00001A6C 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5016 00001A70 0F821700                 jb  .printIntU226
  5017                                  
  5018                                  ;-83         e=n/10; //DIV
  5019                                  
  5020 00001A74 8B4604                   mov ax, [bp+4]
  5021 00001A77 BB0A00                   mov bx, 10
  5022 00001A7A BA0000                   mov dx, 0
  5023 00001A7D F7F3                     div bx
  5024 00001A7F 8946FE                   mov [bp-2], ax
  5025                                  
  5026                                  ;-84         printIntU(e);
  5027                                  
  5028 00001A82 FF76FE                   push word [bp-2]
  5029 00001A85 E8E0FF                   call printIntU
  5030 00001A88 83C402                   add  sp, 2
  5031                                  
  5032                                  ;-85     }
  5033                                  
  5034                                  
  5035                                  ;-86     n = n % 10; //unsigned mod
  5036                                  
  5037                                  .printIntU226:
  5038 00001A8B 8B4604                   mov ax, [bp+4]
  5039 00001A8E BB0A00                   mov bx, 10
  5040 00001A91 BA0000                   mov dx, 0
  5041 00001A94 F7F3                     div bx
  5042 00001A96 89D0                     mov ax, dx
  5043 00001A98 894604                   mov [bp+4], ax
  5044                                  
  5045                                  ;-87     n += '0';
  5046                                  
  5047 00001A9B 83460430                 add  word[bp+4], 48
  5048                                  
  5049                                  ;-88     prc(n);
  5050                                  
  5051 00001A9F FF7604                   push word [bp+4]
  5052 00001AA2 E852FE                   call prc
  5053 00001AA5 83C402                   add  sp, 2
  5054                                  
  5055                                  ;-89 }
  5056                                  
  5057                                  
  5058                                  ;-90 
  5059                                  
  5060                                  
  5061                                  ;-91 int error1(char *s) {
  5062 00001AA8 C9                       LEAVE
  5063 00001AA9 C3                       ret
  5064                                  ENDP
  5065                                  
  5066                                  error1: PROC
  5067                                  
  5068                                  ;-92     LIST=1;
  5069                                  
  5070                                  ;Function : error1, Number of local variables: 1
  5071                                  ;   # type sign width addr used name   list of local variables
  5072                                  ;  200 ptr sign byte    91 NULL s = bp+4;
  5073 00001AAA C8000000                 ENTER  0,0
  5074 00001AAE B80100                   mov ax, 1
  5075 00001AB1 A2[0D00]                 mov byte [LIST], al
  5076                                  
  5077                                  ;-93     ErrorCount++;
  5078                                  
  5079 00001AB4 FF06[1F00]               inc  word[ErrorCount]
  5080                                  
  5081                                  ;-94     prs("\n;***** next line ERROR: ");
  5082                                  
  5083 00001AB8 68[E01A]                 push error1_0
  5084 00001ABB E89AFE                   call prs
  5085 00001ABE 83C402                   add  sp, 2
  5086                                  
  5087                                  ;-95     prs(s);
  5088                                  
  5089 00001AC1 FF7604                   push word [bp+4]
  5090 00001AC4 E891FE                   call prs
  5091 00001AC7 83C402                   add  sp, 2
  5092                                  
  5093                                  ;-96     prs(", Symbol: ");
  5094                                  
  5095 00001ACA 68[FB1A]                 push error1_1
  5096 00001ACD E888FE                   call prs
  5097 00001AD0 83C402                   add  sp, 2
  5098                                  
  5099                                  ;-97     prs(Symbol);
  5100                                  
  5101 00001AD3 8D063075                 lea  ax, [Symbol]
  5102 00001AD7 50                       push ax
  5103 00001AD8 E87DFE                   call prs
  5104 00001ADB 83C402                   add  sp, 2
  5105                                  
  5106                                  ;-98 }
  5107                                  
  5108                                  
  5109                                  ;-99 int errorexit(char *s) {
  5110 00001ADE C9                       LEAVE
  5111 00001ADF C3                       ret
  5112 00001AE0 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5113 00001AE9 6E657874206C696E65-
  5114 00001AF2 204552524F523A2000 
  5115 00001AFB 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5116 00001B04 2000               
  5117                                  ENDP
  5118                                  
  5119                                  errorexit: PROC
  5120                                  
  5121                                  ;-100     error1(s);
  5122                                  
  5123                                  ;Function : errorexit, Number of local variables: 1
  5124                                  ;   # type sign width addr used name   list of local variables
  5125                                  ;  200 ptr sign byte    99 NULL s = bp+4;
  5126 00001B06 C8000000                 ENTER  0,0
  5127 00001B0A FF7604                   push word [bp+4]
  5128 00001B0D E89AFF                   call error1
  5129 00001B10 83C402                   add  sp, 2
  5130                                  
  5131                                  ;-101     epilog(); 
  5132                                  
  5133 00001B13 E80B05                   call epilog
  5134                                  
  5135                                  ;-102     end1(1);
  5136                                  
  5137 00001B16 6A01                     push 1
  5138 00001B18 E8FE05                   call end1
  5139 00001B1B 83C402                   add  sp, 2
  5140                                  
  5141                                  ;-103 }
  5142                                  
  5143                                  
  5144                                  ;-104 int allowederror() {error1("not allowed here"); }
  5145 00001B1E C9                       LEAVE
  5146 00001B1F C3                       ret
  5147                                  ENDP
  5148                                  
  5149                                  allowederror: PROC
  5150 00001B20 68[2A1B]                 push allowederror_0
  5151 00001B23 E884FF                   call error1
  5152 00001B26 83C402                   add  sp, 2
  5153                                  
  5154                                  ;-105 int addrerror()    {error1("address missing");}
  5155                                  
  5156 00001B29 C3                       ret
  5157 00001B2A 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5158 00001B33 6564206865726500   
  5159                                  ENDP
  5160                                  
  5161                                  addrerror: PROC
  5162 00001B3B 68[451B]                 push addrerror_0
  5163 00001B3E E869FF                   call error1
  5164 00001B41 83C402                   add  sp, 2
  5165                                  
  5166                                  ;-106 int immeerror()    {error1("immediate not allowed here");}
  5167                                  
  5168 00001B44 C3                       ret
  5169 00001B45 61646472657373206D-     addrerror_0 db "address missing",0
  5170 00001B4E 697373696E6700     
  5171                                  ENDP
  5172                                  
  5173                                  immeerror: PROC
  5174 00001B55 68[5F1B]                 push immeerror_0
  5175 00001B58 E84FFF                   call error1
  5176 00001B5B 83C402                   add  sp, 2
  5177                                  
  5178                                  ;-107 int implerror()    {error1("not implemented");}
  5179                                  
  5180 00001B5E C3                       ret
  5181 00001B5F 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5182 00001B68 206E6F7420616C6C6F-
  5183 00001B71 776564206865726500 
  5184                                  ENDP
  5185                                  
  5186                                  implerror: PROC
  5187 00001B7A 68[841B]                 push implerror_0
  5188 00001B7D E82AFF                   call error1
  5189 00001B80 83C402                   add  sp, 2
  5190                                  
  5191                                  ;-108 int indexerror()   {error1("invalid index register");}
  5192                                  
  5193 00001B83 C3                       ret
  5194 00001B84 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5195 00001B8D 6D656E74656400     
  5196                                  ENDP
  5197                                  
  5198                                  indexerror: PROC
  5199 00001B94 68[9E1B]                 push indexerror_0
  5200 00001B97 E810FF                   call error1
  5201 00001B9A 83C402                   add  sp, 2
  5202                                  
  5203                                  ;-109 int invaloperror() {error1("invalid or no operands");}
  5204                                  
  5205 00001B9D C3                       ret
  5206 00001B9E 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5207 00001BA7 6E6465782072656769-
  5208 00001BB0 7374657200         
  5209                                  ENDP
  5210                                  
  5211                                  invaloperror: PROC
  5212 00001BB5 68[BF1B]                 push invaloperror_0
  5213 00001BB8 E8EFFE                   call error1
  5214 00001BBB 83C402                   add  sp, 2
  5215                                  
  5216                                  ;-110 int numbererror()  {error1("number expected");}
  5217                                  
  5218 00001BBE C3                       ret
  5219 00001BBF 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5220 00001BC8 72206E6F206F706572-
  5221 00001BD1 616E647300         
  5222                                  ENDP
  5223                                  
  5224                                  numbererror: PROC
  5225 00001BD6 68[E01B]                 push numbererror_0
  5226 00001BD9 E8CEFE                   call error1
  5227 00001BDC 83C402                   add  sp, 2
  5228                                  
  5229                                  ;-111 int regmemerror()  {error1("only register or memory allowed");}
  5230                                  
  5231 00001BDF C3                       ret
  5232 00001BE0 6E756D626572206578-     numbererror_0 db "number expected",0
  5233 00001BE9 70656374656400     
  5234                                  ENDP
  5235                                  
  5236                                  regmemerror: PROC
  5237 00001BF0 68[FA1B]                 push regmemerror_0
  5238 00001BF3 E8B4FE                   call error1
  5239 00001BF6 83C402                   add  sp, 2
  5240                                  
  5241                                  ;-112 int reg16error()   {error1("only reg16, no segreg allowed");}
  5242                                  
  5243 00001BF9 C3                       ret
  5244 00001BFA 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5245 00001C03 73746572206F72206D-
  5246 00001C0C 656D6F727920616C6C-
  5247 00001C15 6F77656400         
  5248                                  ENDP
  5249                                  
  5250                                  reg16error: PROC
  5251 00001C1A 68[241C]                 push reg16error_0
  5252 00001C1D E88AFE                   call error1
  5253 00001C20 83C402                   add  sp, 2
  5254                                  
  5255                                  ;-113 int segregerror()  {error1("segment register not allowed");}
  5256                                  
  5257 00001C23 C3                       ret
  5258 00001C24 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5259 00001C2D 362C206E6F20736567-
  5260 00001C36 72656720616C6C6F77-
  5261 00001C3F 656400             
  5262                                  ENDP
  5263                                  
  5264                                  segregerror: PROC
  5265 00001C42 68[4C1C]                 push segregerror_0
  5266 00001C45 E862FE                   call error1
  5267 00001C48 83C402                   add  sp, 2
  5268                                  
  5269                                  ;-114 int syntaxerror()  {error1("syntax");}
  5270                                  
  5271 00001C4B C3                       ret
  5272 00001C4C 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5273 00001C55 65676973746572206E-
  5274 00001C5E 6F7420616C6C6F7765-
  5275 00001C67 6400               
  5276                                  ENDP
  5277                                  
  5278                                  syntaxerror: PROC
  5279 00001C69 68[731C]                 push syntaxerror_0
  5280 00001C6C E83BFE                   call error1
  5281 00001C6F 83C402                   add  sp, 2
  5282                                  
  5283                                  ;-115 
  5284                                  
  5285                                  
  5286                                  ;-116 int addrexit()     {errorexit("illegal address");}
  5287                                  
  5288 00001C72 C3                       ret
  5289 00001C73 73796E74617800          syntaxerror_0 db "syntax",0
  5290                                  ENDP
  5291                                  
  5292                                  addrexit: PROC
  5293 00001C7A 68[841C]                 push addrexit_0
  5294 00001C7D E886FE                   call errorexit
  5295 00001C80 83C402                   add  sp, 2
  5296                                  
  5297                                  ;-117 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5298                                  
  5299 00001C83 C3                       ret
  5300 00001C84 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5301 00001C8D 64647265737300     
  5302                                  ENDP
  5303                                  
  5304                                  dataexit: PROC
  5305 00001C94 68[9E1C]                 push dataexit_0
  5306 00001C97 E86CFE                   call errorexit
  5307 00001C9A 83C402                   add  sp, 2
  5308                                  
  5309                                  ;-118 int internexit()   {errorexit("intern compiler error");}
  5310                                  
  5311 00001C9D C3                       ret
  5312 00001C9E 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5313 00001CA7 6F7220524553422C57-
  5314 00001CB0 2C4420657870656374-
  5315 00001CB9 656400             
  5316                                  ENDP
  5317                                  
  5318                                  internexit: PROC
  5319 00001CBC 68[C61C]                 push internexit_0
  5320 00001CBF E844FE                   call errorexit
  5321 00001CC2 83C402                   add  sp, 2
  5322 00001CC5 C3                       ret
  5323 00001CC6 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5324 00001CCF 6D70696C6572206572-
  5325 00001CD8 726F7200           
  5326                                  ENDP
  5327                                  ;Back to main program: AS.C
  5328                                  
  5329                                  ;-8 #include "MAIN.C"
  5330                                  
  5331                                  ;Use include file: MAIN.C
  5332                                  
  5333                                  ;-1 int main() {
  5334                                  
  5335                                  
  5336                                  main: PROC
  5337                                  
  5338                                  ;-2     getarg();
  5339                                  
  5340 00001CDC E80D00                   call getarg
  5341                                  
  5342                                  ;-3     parse();
  5343                                  
  5344 00001CDF E868EC                   call parse
  5345                                  
  5346                                  ;-4     fixJmpCall();
  5347                                  
  5348 00001CE2 E85002                   call fixJmpCall
  5349                                  
  5350                                  ;-5     epilog();
  5351                                  
  5352 00001CE5 E83903                   call epilog
  5353                                  
  5354                                  ;-6     end1();
  5355                                  
  5356 00001CE8 E82E04                   call end1
  5357                                  
  5358                                  ;-7 }
  5359                                  
  5360                                  
  5361                                  ;-8 
  5362                                  
  5363                                  
  5364                                  ;-9 int getarg() {
  5365                                  
  5366 00001CEB C3                       ret
  5367                                  ENDP
  5368                                  
  5369                                  getarg: PROC
  5370                                  
  5371                                  ;-10     int arglen1; int i; char *c;
  5372                                  
  5373                                  
  5374                                  ;-11     arglen1=*arglen;
  5375                                  
  5376                                  ;Function : getarg, Number of local variables: 3
  5377                                  ;   # type sign width addr used name   list of local variables
  5378                                  ;  200 var sign word    10 NULL arglen1 = bp-2
  5379                                  ;  201 var sign word    10 NULL i = bp-4
  5380                                  ;  202 ptr sign byte    10 NULL c = bp-6;
  5381 00001CEC C8060000                 ENTER  6,0
  5382 00001CF0 8B1E[5300]               mov bx, [arglen]
  5383 00001CF4 8A07                     mov al, [bx]
  5384 00001CF6 B400                     mov ah, 0
  5385 00001CF8 8946FE                   mov [bp-2], ax
  5386                                  
  5387                                  ;-12     if (arglen1==0) {
  5388                                  
  5389 00001CFB 8B46FE                   mov ax, [bp-2]
  5390 00001CFE 83F800                   cmp ax, 0
  5391 00001D01 0F851C00                 jne .getarg227
  5392                                  
  5393                                  ;-13         cputs(Version1);
  5394                                  
  5395 00001D05 8D06[0300]               lea  ax, [Version1]
  5396 00001D09 50                       push ax
  5397 00001D0A E89AF2                   call cputs
  5398 00001D0D 83C402                   add  sp, 2
  5399                                  
  5400                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5401                                  
  5402 00001D10 68[A21E]                 push getarg_0
  5403 00001D13 E891F2                   call cputs
  5404 00001D16 83C402                   add  sp, 2
  5405                                  
  5406                                  ;-15         exitR(3);
  5407                                  
  5408 00001D19 6A03                     push 3
  5409 00001D1B E8F0F2                   call exitR
  5410 00001D1E 83C402                   add  sp, 2
  5411                                  
  5412                                  ;-16     }
  5413                                  
  5414                                  
  5415                                  ;-17     i=arglen1+129;
  5416                                  
  5417                                  .getarg227:
  5418 00001D21 8B46FE                   mov ax, [bp-2]
  5419 00001D24 058100                   add ax, 129
  5420 00001D27 8946FC                   mov [bp-4], ax
  5421                                  
  5422                                  ;-18     *i=0;
  5423                                  
  5424 00001D2A B80000                   mov ax, 0
  5425 00001D2D 8B5EFC                   mov  bx, [bp-4]
  5426 00001D30 8907                     mov  [bx], ax
  5427                                  
  5428                                  ;-19     arglen1--;
  5429                                  
  5430 00001D32 FF4EFE                   dec  word[bp-2]
  5431                                  
  5432                                  ;-20     toupper(argv);
  5433                                  
  5434 00001D35 FF36[5500]               push word [argv]
  5435 00001D39 E809F6                   call toupper
  5436 00001D3C 83C402                   add  sp, 2
  5437                                  
  5438                                  ;-21 
  5439                                  
  5440                                  
  5441                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  5442                                  
  5443 00001D3F FF36[5500]               push word [argv]
  5444 00001D43 8D068C76                 lea  ax, [namein]
  5445 00001D47 50                       push ax
  5446 00001D48 E853F5                   call strcpy
  5447 00001D4B 83C404                   add  sp, 4
  5448 00001D4E 68[C71E]                 push getarg_1
  5449 00001D51 8D068C76                 lea  ax, [namein]
  5450 00001D55 50                       push ax
  5451 00001D56 E8C7F5                   call strcat1
  5452 00001D59 83C404                   add  sp, 4
  5453                                  
  5454                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  5455                                  
  5456 00001D5C FF36[5500]               push word [argv]
  5457 00001D60 8D06CF76                 lea  ax, [namelst]
  5458 00001D64 50                       push ax
  5459 00001D65 E836F5                   call strcpy
  5460 00001D68 83C404                   add  sp, 4
  5461 00001D6B 68[CA1E]                 push getarg_2
  5462 00001D6E 8D06CF76                 lea  ax, [namelst]
  5463 00001D72 50                       push ax
  5464 00001D73 E8AAF5                   call strcat1
  5465 00001D76 83C404                   add  sp, 4
  5466                                  
  5467                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  5468                                  
  5469 00001D79 FF36[5500]               push word [argv]
  5470 00001D7D 8D061277                 lea  ax, [namebin]
  5471 00001D81 50                       push ax
  5472 00001D82 E819F5                   call strcpy
  5473 00001D85 83C404                   add  sp, 4
  5474 00001D88 68[CF1E]                 push getarg_3
  5475 00001D8B 8D061277                 lea  ax, [namebin]
  5476 00001D8F 50                       push ax
  5477 00001D90 E88DF5                   call strcat1
  5478 00001D93 83C404                   add  sp, 4
  5479                                  
  5480                                  ;-25 
  5481                                  
  5482                                  
  5483                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  5484                                  
  5485 00001D96 B80100                   mov ax, 1
  5486 00001D99 A2[0D00]                 mov byte [LIST], al
  5487 00001D9C B80000                   mov ax, 0
  5488 00001D9F A3[1D00]                 mov word [DOS_ERR], ax
  5489 00001DA2 B80000                   mov ax, 0
  5490 00001DA5 A3[2400]                 mov word [PC], ax
  5491 00001DA8 B80000                   mov ax, 0
  5492 00001DAB A3[1F00]                 mov word [ErrorCount], ax
  5493                                  
  5494                                  ;-27 
  5495                                  
  5496                                  
  5497                                  ;-28     asm_fd=openR (namein);
  5498                                  
  5499 00001DAE 8D068C76                 lea  ax, [namein]
  5500 00001DB2 50                       push ax
  5501 00001DB3 E828F2                   call openR
  5502 00001DB6 83C402                   add  sp, 2
  5503 00001DB9 A3[1700]                 mov word [asm_fd], ax
  5504                                  
  5505                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5506                                  
  5507 00001DBC A1[1D00]                 mov ax, [DOS_ERR]
  5508 00001DBF 08C0                     or  al, al
  5509 00001DC1 0F841C00                 je .getarg228
  5510 00001DC5 68[D41E]                 push getarg_4
  5511 00001DC8 E8DCF1                   call cputs
  5512 00001DCB 83C402                   add  sp, 2
  5513 00001DCE 8D068C76                 lea  ax, [namein]
  5514 00001DD2 50                       push ax
  5515 00001DD3 E8D1F1                   call cputs
  5516 00001DD6 83C402                   add  sp, 2
  5517 00001DD9 6A01                     push 1
  5518 00001DDB E830F2                   call exitR
  5519 00001DDE 83C402                   add  sp, 2
  5520                                  
  5521                                  ;-30     lst_fd=creatR(namelst);
  5522                                  
  5523                                  .getarg228:
  5524 00001DE1 8D06CF76                 lea  ax, [namelst]
  5525 00001DE5 50                       push ax
  5526 00001DE6 E804F2                   call creatR
  5527 00001DE9 83C402                   add  sp, 2
  5528 00001DEC A3[1900]                 mov word [lst_fd], ax
  5529                                  
  5530                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5531                                  
  5532 00001DEF A1[1D00]                 mov ax, [DOS_ERR]
  5533 00001DF2 08C0                     or  al, al
  5534 00001DF4 0F841C00                 je .getarg229
  5535 00001DF8 68[EA1E]                 push getarg_5
  5536 00001DFB E8A9F1                   call cputs
  5537 00001DFE 83C402                   add  sp, 2
  5538 00001E01 8D06CF76                 lea  ax, [namelst]
  5539 00001E05 50                       push ax
  5540 00001E06 E89EF1                   call cputs
  5541 00001E09 83C402                   add  sp, 2
  5542 00001E0C 6A02                     push 2
  5543 00001E0E E8FDF1                   call exitR
  5544 00001E11 83C402                   add  sp, 2
  5545                                  
  5546                                  ;-32     bin_fd=creatR(namebin);
  5547                                  
  5548                                  .getarg229:
  5549 00001E14 8D061277                 lea  ax, [namebin]
  5550 00001E18 50                       push ax
  5551 00001E19 E8D1F1                   call creatR
  5552 00001E1C 83C402                   add  sp, 2
  5553 00001E1F A3[1B00]                 mov word [bin_fd], ax
  5554                                  
  5555                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5556                                  
  5557 00001E22 A1[1D00]                 mov ax, [DOS_ERR]
  5558 00001E25 08C0                     or  al, al
  5559 00001E27 0F841C00                 je .getarg230
  5560 00001E2B 68[011F]                 push getarg_6
  5561 00001E2E E876F1                   call cputs
  5562 00001E31 83C402                   add  sp, 2
  5563 00001E34 8D061277                 lea  ax, [namebin]
  5564 00001E38 50                       push ax
  5565 00001E39 E86BF1                   call cputs
  5566 00001E3C 83C402                   add  sp, 2
  5567 00001E3F 6A02                     push 2
  5568 00001E41 E8CAF1                   call exitR
  5569 00001E44 83C402                   add  sp, 2
  5570                                  
  5571                                  ;-34 
  5572                                  
  5573                                  
  5574                                  ;-35     prs(";");
  5575                                  
  5576                                  .getarg230:
  5577 00001E47 68[171F]                 push getarg_7
  5578 00001E4A E80BFB                   call prs
  5579 00001E4D 83C402                   add  sp, 2
  5580                                  
  5581                                  ;-36     prs(Version1);
  5582                                  
  5583 00001E50 8D06[0300]               lea  ax, [Version1]
  5584 00001E54 50                       push ax
  5585 00001E55 E800FB                   call prs
  5586 00001E58 83C402                   add  sp, 2
  5587                                  
  5588                                  ;-37     prs(", Source: "); prs(namein);
  5589                                  
  5590 00001E5B 68[191F]                 push getarg_8
  5591 00001E5E E8F7FA                   call prs
  5592 00001E61 83C402                   add  sp, 2
  5593 00001E64 8D068C76                 lea  ax, [namein]
  5594 00001E68 50                       push ax
  5595 00001E69 E8ECFA                   call prs
  5596 00001E6C 83C402                   add  sp, 2
  5597                                  
  5598                                  ;-38     prs(", Output: "); prs(namelst);
  5599                                  
  5600 00001E6F 68[241F]                 push getarg_9
  5601 00001E72 E8E3FA                   call prs
  5602 00001E75 83C402                   add  sp, 2
  5603 00001E78 8D06CF76                 lea  ax, [namelst]
  5604 00001E7C 50                       push ax
  5605 00001E7D E8D8FA                   call prs
  5606 00001E80 83C402                   add  sp, 2
  5607                                  
  5608                                  ;-39     prs(", "); prs(namebin);
  5609                                  
  5610 00001E83 68[2F1F]                 push getarg_10
  5611 00001E86 E8CFFA                   call prs
  5612 00001E89 83C402                   add  sp, 2
  5613 00001E8C 8D061277                 lea  ax, [namebin]
  5614 00001E90 50                       push ax
  5615 00001E91 E8C4FA                   call prs
  5616 00001E94 83C402                   add  sp, 2
  5617                                  
  5618                                  ;-40     prs("\n");
  5619                                  
  5620 00001E97 68[321F]                 push getarg_11
  5621 00001E9A E8BBFA                   call prs
  5622 00001E9D 83C402                   add  sp, 2
  5623                                  
  5624                                  ;-41 }
  5625                                  
  5626                                  
  5627                                  ;-42 
  5628                                  
  5629                                  
  5630                                  ;-43 int fixJmpCall() {
  5631 00001EA0 C9                       LEAVE
  5632 00001EA1 C3                       ret
  5633 00001EA2 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5634 00001EAB 41532E434F4D206669-
  5635 00001EB4 6C656E616D65205B77-
  5636 00001EBD 2F6F202E535D203A20-
  5637 00001EC6 00                 
  5638 00001EC7 2E5300                  getarg_1 db ".S",0
  5639 00001ECA 2E4C535400              getarg_2 db ".LST",0
  5640 00001ECF 2E434F4D00              getarg_3 db ".COM",0
  5641 00001ED4 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5642 00001EDD 6C65206D697373696E-
  5643 00001EE6 673A2000           
  5644 00001EEA 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5645 00001EF3 206E6F742063726561-
  5646 00001EFC 74653A2000         
  5647 00001F01 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5648 00001F0A 6E6F74206372656174-
  5649 00001F13 653A2000           
  5650 00001F17 3B00                    getarg_7 db ";",0
  5651 00001F19 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5652 00001F22 2000               
  5653 00001F24 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5654 00001F2D 2000               
  5655 00001F2F 2C2000                  getarg_10 db ", ",0
  5656 00001F32 5C6E00                  getarg_11 db "\n",0
  5657                                  ENDP
  5658                                  
  5659                                  fixJmpCall: PROC
  5660                                  
  5661                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5662                                  
  5663                                  
  5664                                  ;-45     i=1;
  5665                                  
  5666                                  ;Function : fixJmpCall, Number of local variables: 5
  5667                                  ;   # type sign width addr used name   list of local variables
  5668                                  ;  200 var sign word    44 NULL i = bp-2
  5669                                  ;  201 var unsg word    44 NULL hex = bp-4
  5670                                  ;  202 ptr sign byte    44 NULL p = bp-6
  5671                                  ;  203 var sign word    44 NULL Ix = bp-8
  5672                                  ;  204 var sign byte    44 NULL c = bp-10;
  5673 00001F35 C80A0000                 ENTER  10,0
  5674 00001F39 B80100                   mov ax, 1
  5675 00001F3C 8946FE                   mov [bp-2], ax
  5676                                  
  5677                                  ;-46     prs("\n;END open jmp/call: ");
  5678                                  
  5679 00001F3F 68[FA1F]                 push fixJmpCall_0
  5680 00001F42 E813FA                   call prs
  5681 00001F45 83C402                   add  sp, 2
  5682                                  
  5683                                  ;-47     printIntU(JmpCallMaxIx);
  5684                                  
  5685 00001F48 FF36[4F00]               push word [JmpCallMaxIx]
  5686 00001F4C E819FB                   call printIntU
  5687 00001F4F 83C402                   add  sp, 2
  5688                                  
  5689                                  ;-48     p = &JmpCallNames;
  5690                                  
  5691 00001F52 B8AA8B                   mov ax, JmpCallNames
  5692 00001F55 8946FA                   mov [bp-6], ax
  5693                                  
  5694                                  ;-49     while (i <= JmpCallMaxIx) {
  5695                                  
  5696                                  .fixJmpCall231:
  5697 00001F58 8B46FE                   mov ax, [bp-2]
  5698 00001F5B 3B06[4F00]               cmp ax, [JmpCallMaxIx]
  5699 00001F5F 0F8F9500                 jg  .fixJmpCall232
  5700                                  
  5701                                  ;-50         strcpy(Symbol, p);
  5702                                  
  5703 00001F63 FF76FA                   push word [bp-6]
  5704 00001F66 8D063075                 lea  ax, [Symbol]
  5705 00001F6A 50                       push ax
  5706 00001F6B E830F3                   call strcpy
  5707 00001F6E 83C404                   add  sp, 4
  5708                                  
  5709                                  ;-51         p = strlen(Symbol) + p;
  5710                                  
  5711 00001F71 8D063075                 lea  ax, [Symbol]
  5712 00001F75 50                       push ax
  5713 00001F76 E8FDF2                   call strlen
  5714 00001F79 83C402                   add  sp, 2
  5715 00001F7C 0346FA                   add ax, [bp-6]
  5716 00001F7F 8946FA                   mov [bp-6], ax
  5717                                  
  5718                                  ;-52         p++;
  5719                                  
  5720 00001F82 FF46FA                   inc  word[bp-6]
  5721                                  
  5722                                  ;-53 //        prs(Symbol);
  5723                                  
  5724                                  
  5725                                  ;-54 //        prc(' ');
  5726                                  
  5727                                  
  5728                                  ;-55         hex = JmpCallAddr[i];
  5729                                  
  5730 00001F85 8B5EFE                   mov bx, [bp-2]
  5731 00001F88 D1E3                     shl bx, 1
  5732 00001F8A 8B877A93                 mov ax, [JmpCallAddr + bx]
  5733 00001F8E 8946FC                   mov [bp-4], ax
  5734                                  
  5735                                  ;-56 //        printhex16(hex);
  5736                                  
  5737                                  
  5738                                  ;-57 
  5739                                  
  5740                                  
  5741                                  ;-58         Ix=searchLabel();
  5742                                  
  5743 00001F91 E887EC                   call searchLabel
  5744 00001F94 8946F8                   mov [bp-8], ax
  5745                                  
  5746                                  ;-59         if (Ix == 0) error1("Label not found");
  5747                                  
  5748 00001F97 8B46F8                   mov ax, [bp-8]
  5749 00001F9A 83F800                   cmp ax, 0
  5750 00001F9D 0F850900                 jne .fixJmpCall233
  5751 00001FA1 68[1120]                 push fixJmpCall_1
  5752 00001FA4 E803FB                   call error1
  5753 00001FA7 83C402                   add  sp, 2
  5754                                  
  5755                                  ;-60         disp = LabelAddr[Ix];
  5756                                  
  5757                                  .fixJmpCall233:
  5758 00001FAA 8B5EF8                   mov bx, [bp-8]
  5759 00001FAD D1E3                     shl bx, 1
  5760 00001FAF 8B87FA86                 mov ax, [LabelAddr + bx]
  5761 00001FB3 A3[3E00]                 mov word [disp], ax
  5762                                  
  5763                                  ;-61         disp = disp - hex;
  5764                                  
  5765 00001FB6 A1[3E00]                 mov ax, [disp]
  5766 00001FB9 2B46FC                   sub ax, [bp-4]
  5767 00001FBC A3[3E00]                 mov word [disp], ax
  5768                                  
  5769                                  ;-62         disp = disp - Origin;
  5770                                  
  5771 00001FBF A1[3E00]                 mov ax, [disp]
  5772 00001FC2 2B06[2600]               sub ax, [Origin]
  5773 00001FC6 A3[3E00]                 mov word [disp], ax
  5774                                  
  5775                                  ;-63 //        prs(", ");
  5776                                  
  5777                                  
  5778                                  ;-64 
  5779                                  
  5780                                  
  5781                                  ;-65             hex = hex - 2;//fix at start of word
  5782                                  
  5783 00001FC9 8B46FC                   mov ax, [bp-4]
  5784 00001FCC 83E802                   sub ax, 2
  5785 00001FCF 8946FC                   mov [bp-4], ax
  5786                                  
  5787                                  ;-66             FileBin[hex] = disp;//fix low byte
  5788                                  
  5789 00001FD2 A1[3E00]                 mov ax, [disp]
  5790 00001FD5 8B5EFC                   mov bx, [bp-4]
  5791 00001FD8 88876297                 mov [FileBin+bx], al
  5792                                  
  5793                                  ;-67             hex++;
  5794                                  
  5795 00001FDC FF46FC                   inc  word[bp-4]
  5796                                  
  5797                                  ;-68             disp = disp >> 8;
  5798                                  
  5799 00001FDF A1[3E00]                 mov ax, [disp]
  5800 00001FE2 C1E808                   shr ax, 8
  5801 00001FE5 A3[3E00]                 mov word [disp], ax
  5802                                  
  5803                                  ;-69             FileBin[hex] = disp;
  5804                                  
  5805 00001FE8 A1[3E00]                 mov ax, [disp]
  5806 00001FEB 8B5EFC                   mov bx, [bp-4]
  5807 00001FEE 88876297                 mov [FileBin+bx], al
  5808                                  
  5809                                  ;-70         i++;
  5810                                  
  5811 00001FF2 FF46FE                   inc  word[bp-2]
  5812                                  
  5813                                  ;-71     }
  5814                                  
  5815                                  
  5816                                  ;-72 }
  5817                                  
  5818 00001FF5 E960FF                   jmp .fixJmpCall231
  5819                                  .fixJmpCall232:
  5820                                  
  5821                                  ;-73 
  5822                                  
  5823                                  
  5824                                  ;-74 int epilog() {
  5825 00001FF8 C9                       LEAVE
  5826 00001FF9 C3                       ret
  5827 00001FFA 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5828 00002003 656E206A6D702F6361-
  5829 0000200C 6C6C3A2000         
  5830 00002011 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5831 0000201A 20666F756E6400     
  5832                                  ENDP
  5833                                  
  5834                                  epilog: PROC
  5835                                  
  5836                                  ;-75     unsigned int i; char c;     int j;
  5837                                  
  5838                                  
  5839                                  ;-76     prs("\n Errors: ");
  5840                                  
  5841                                  ;Function : epilog, Number of local variables: 3
  5842                                  ;   # type sign width addr used name   list of local variables
  5843                                  ;  200 var unsg word    75 NULL i = bp-2
  5844                                  ;  201 var sign byte    75 NULL c = bp-4
  5845                                  ;  202 var sign word    75 NULL j = bp-6;
  5846 00002021 C8060000                 ENTER  6,0
  5847 00002025 68[DC20]                 push epilog_0
  5848 00002028 E82DF9                   call prs
  5849 0000202B 83C402                   add  sp, 2
  5850                                  
  5851                                  ;-77     printIntU(ErrorCount);
  5852                                  
  5853 0000202E FF36[1F00]               push word [ErrorCount]
  5854 00002032 E833FA                   call printIntU
  5855 00002035 83C402                   add  sp, 2
  5856                                  
  5857                                  ;-78     if (ErrorCount) prs(" ***ERROR*** ");
  5858                                  
  5859 00002038 A1[1F00]                 mov ax, [ErrorCount]
  5860 0000203B 08C0                     or  al, al
  5861 0000203D 0F840900                 je .epilog234
  5862 00002041 68[E820]                 push epilog_1
  5863 00002044 E811F9                   call prs
  5864 00002047 83C402                   add  sp, 2
  5865                                  
  5866                                  ;-79     prs(", Out: ");
  5867                                  
  5868                                  .epilog234:
  5869 0000204A 68[F620]                 push epilog_2
  5870 0000204D E808F9                   call prs
  5871 00002050 83C402                   add  sp, 2
  5872                                  
  5873                                  ;-80     prs(namelst);
  5874                                  
  5875 00002053 8D06CF76                 lea  ax, [namelst]
  5876 00002057 50                       push ax
  5877 00002058 E8FDF8                   call prs
  5878 0000205B 83C402                   add  sp, 2
  5879                                  
  5880                                  ;-81     prs(", ");
  5881                                  
  5882 0000205E 68[FE20]                 push epilog_3
  5883 00002061 E8F4F8                   call prs
  5884 00002064 83C402                   add  sp, 2
  5885                                  
  5886                                  ;-82     prs(namebin);
  5887                                  
  5888 00002067 8D061277                 lea  ax, [namebin]
  5889 0000206B 50                       push ax
  5890 0000206C E8E9F8                   call prs
  5891 0000206F 83C402                   add  sp, 2
  5892                                  
  5893                                  ;-83     prs("= ");
  5894                                  
  5895 00002072 68[0121]                 push epilog_4
  5896 00002075 E8E0F8                   call prs
  5897 00002078 83C402                   add  sp, 2
  5898                                  
  5899                                  ;-84     printIntU(BinLen);
  5900                                  
  5901 0000207B FF36[5100]               push word [BinLen]
  5902 0000207F E8E6F9                   call printIntU
  5903 00002082 83C402                   add  sp, 2
  5904                                  
  5905                                  ;-85     prs(" bytes.");
  5906                                  
  5907 00002085 68[0421]                 push epilog_5
  5908 00002088 E8CDF8                   call prs
  5909 0000208B 83C402                   add  sp, 2
  5910                                  
  5911                                  ;-86 
  5912                                  
  5913                                  
  5914                                  ;-87     i=0;
  5915                                  
  5916 0000208E B80000                   mov ax, 0
  5917 00002091 8946FE                   mov [bp-2], ax
  5918                                  
  5919                                  ;-88     do {
  5920                                  
  5921                                  .epilog235:
  5922                                  
  5923                                  ;-89         c = FileBin[i];
  5924                                  
  5925 00002094 8B5EFE                   mov bx, [bp-2]
  5926 00002097 8A876297                 mov al, [FileBin + bx]
  5927 0000209B 8846FC                   mov [bp-4], al
  5928                                  
  5929                                  ;-90         fputcR(c, bin_fd);
  5930                                  
  5931 0000209E FF36[1B00]               push word [bin_fd]
  5932 000020A2 8A46FC                   mov al, byte [bp-4]
  5933 000020A5 B400                     mov ah, 0
  5934 000020A7 50                       push ax
  5935 000020A8 E886EF                   call fputcR
  5936 000020AB 83C404                   add  sp, 4
  5937                                  
  5938                                  ;-91 //printhex8a(c); prc(' ');
  5939                                  
  5940                                  
  5941                                  ;-92         i++;
  5942                                  
  5943 000020AE FF46FE                   inc  word[bp-2]
  5944                                  
  5945                                  ;-93     } while (i < BinLen);
  5946                                  
  5947 000020B1 8B46FE                   mov ax, [bp-2]
  5948 000020B4 3B06[5100]               cmp ax, [BinLen]
  5949 000020B8 0F8D0200                 jge .epilog236
  5950 000020BC EBD6                     jmp .epilog235
  5951                                  .epilog236:
  5952                                  
  5953                                  ;-94 
  5954                                  
  5955                                  
  5956                                  ;-95   prs(" Labels: ");
  5957                                  
  5958 000020BE 68[0C21]                 push epilog_6
  5959 000020C1 E894F8                   call prs
  5960 000020C4 83C402                   add  sp, 2
  5961                                  
  5962                                  ;-96   printIntU(LabelMaxIx);
  5963                                  
  5964 000020C7 FF36[4900]               push word [LabelMaxIx]
  5965 000020CB E89AF9                   call printIntU
  5966 000020CE 83C402                   add  sp, 2
  5967                                  
  5968                                  ;-97   prs(". ");
  5969                                  
  5970 000020D1 68[1621]                 push epilog_7
  5971 000020D4 E881F8                   call prs
  5972 000020D7 83C402                   add  sp, 2
  5973                                  
  5974                                  ;-98 /*
  5975                                  
  5976                                  
  5977                                  ;-99   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);
  5978                                  
  5979                                  
  5980                                  ;-100   i= &LabelNames;
  5981                                  
  5982                                  
  5983                                  ;-101   prs(" &LabelNames:"); printIntU(i);
  5984                                  
  5985                                  
  5986                                  ;-102   i=LabelNamePtr-i;
  5987                                  
  5988                                  
  5989                                  ;-103   prs("size: ");
  5990                                  
  5991                                  
  5992                                  ;-104   printIntU(i);
  5993                                  
  5994                                  
  5995                                  ;-105   prs(". >>");
  5996                                  
  5997                                  
  5998                                  ;-106   i= &LabelNames;
  5999                                  
  6000                                  
  6001                                  ;-107   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6002                                  
  6003                                  
  6004                                  ;-108   } while (i < LabelNamePtr); prs("<< \n");
  6005                                  
  6006                                  
  6007                                  ;-109    i = 1;
  6008                                  
  6009                                  
  6010                                  ;-110     LabelNamePtr= &LabelNames;
  6011                                  
  6012                                  
  6013                                  ;-111     do {
  6014                                  
  6015                                  
  6016                                  ;-112       prs(LabelNamePtr); prc(' ');
  6017                                  
  6018                                  
  6019                                  ;-113       j=LabelAddr[i]; printhex16(j); prs(", ");
  6020                                  
  6021                                  
  6022                                  ;-114       j=strlen(LabelNamePtr);//get end of actual name
  6023                                  
  6024                                  
  6025                                  ;-115       LabelNamePtr=LabelNamePtr+j;
  6026                                  
  6027                                  
  6028                                  ;-116       LabelNamePtr++;
  6029                                  
  6030                                  
  6031                                  ;-117       i++;
  6032                                  
  6033                                  
  6034                                  ;-118     } while (i <= LabelMaxIx);
  6035                                  
  6036                                  
  6037                                  ;-119 */    
  6038                                  
  6039                                  
  6040                                  ;-120 }
  6041                                  
  6042                                  
  6043                                  ;-121 
  6044                                  
  6045                                  
  6046                                  ;-122 int end1(int n) {
  6047 000020DA C9                       LEAVE
  6048 000020DB C3                       ret
  6049 000020DC 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6050 000020E5 3A2000             
  6051 000020E8 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6052 000020F1 2A2A2A2000         
  6053 000020F6 2C204F75743A2000        epilog_2 db ", Out: ",0
  6054 000020FE 2C2000                  epilog_3 db ", ",0
  6055 00002101 3D2000                  epilog_4 db "= ",0
  6056 00002104 2062797465732E00        epilog_5 db " bytes.",0
  6057 0000210C 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6058 00002115 00                 
  6059 00002116 2E2000                  epilog_7 db ". ",0
  6060                                  ENDP
  6061                                  
  6062                                  end1: PROC
  6063                                  
  6064                                  ;-123     fcloseR(asm_fd);
  6065                                  
  6066                                  ;Function : end1, Number of local variables: 1
  6067                                  ;   # type sign width addr used name   list of local variables
  6068                                  ;  200 var sign word   122 NULL n = bp+4;
  6069 00002119 C8000000                 ENTER  0,0
  6070 0000211D FF36[1700]               push word [asm_fd]
  6071 00002121 E8DBEE                   call fcloseR
  6072 00002124 83C402                   add  sp, 2
  6073                                  
  6074                                  ;-124     fcloseR(lst_fd);
  6075                                  
  6076 00002127 FF36[1900]               push word [lst_fd]
  6077 0000212B E8D1EE                   call fcloseR
  6078 0000212E 83C402                   add  sp, 2
  6079                                  
  6080                                  ;-125     fcloseR(bin_fd);
  6081                                  
  6082 00002131 FF36[1B00]               push word [bin_fd]
  6083 00002135 E8C7EE                   call fcloseR
  6084 00002138 83C402                   add  sp, 2
  6085                                  
  6086                                  ;-126     exitR(n);
  6087                                  
  6088 0000213B FF7604                   push word [bp+4]
  6089 0000213E E8CDEE                   call exitR
  6090 00002141 83C402                   add  sp, 2
  6091                                  
  6092                                  ;-127 }
  6093 00002144 C9                       LEAVE
  6094 00002145 C3                       ret
  6095                                  ENDP
  6096                                  ;Back to main program: AS.C
  6097                                  
  6098                                  ;-9 #include "GENCODE.C"
  6099                                  
  6100                                  ;Use include file: GENCODE.C
  6101                                  
  6102                                  ;-1 // generate code
  6103                                  
  6104                                  
  6105                                  ;-2 int getCodes() {
  6106                                  
  6107                                  
  6108                                  getCodes: PROC
  6109                                  
  6110                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  6111                                  
  6112 00002146 FF06[4400]               inc  word[OpCodePtr]
  6113 0000214A 8B1E[4400]               mov bx, [OpCodePtr]
  6114 0000214E 8A07                     mov al, [bx]
  6115 00002150 B400                     mov ah, 0
  6116 00002152 A2[3100]                 mov byte [Code1], al
  6117                                  
  6118                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  6119                                  
  6120 00002155 FF06[4400]               inc  word[OpCodePtr]
  6121 00002159 8B1E[4400]               mov bx, [OpCodePtr]
  6122 0000215D 8A07                     mov al, [bx]
  6123 0000215F B400                     mov ah, 0
  6124 00002161 A2[3200]                 mov byte [Code2], al
  6125                                  
  6126                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  6127                                  
  6128 00002164 FF06[4400]               inc  word[OpCodePtr]
  6129 00002168 8B1E[4400]               mov bx, [OpCodePtr]
  6130 0000216C 8A07                     mov al, [bx]
  6131 0000216E B400                     mov ah, 0
  6132 00002170 A2[3300]                 mov byte [Code3], al
  6133                                  
  6134                                  ;-6 }
  6135                                  
  6136                                  
  6137                                  ;-7 int gen66h() {genCode8(0x66);
  6138                                  
  6139 00002173 C3                       ret
  6140                                  ENDP
  6141                                  
  6142                                  gen66h: PROC
  6143 00002174 6A66                     push 102
  6144 00002176 E83B00                   call genCode8
  6145 00002179 83C402                   add  sp, 2
  6146                                  
  6147                                  ;-8 }
  6148                                  
  6149                                  
  6150                                  ;-9 int genCode2(char c, char d) {
  6151                                  
  6152 0000217C C3                       ret
  6153                                  ENDP
  6154                                  
  6155                                  genCode2: PROC
  6156                                  
  6157                                  ;-10     c = c + d;
  6158                                  
  6159                                  ;Function : genCode2, Number of local variables: 2
  6160                                  ;   # type sign width addr used name   list of local variables
  6161                                  ;  200 var sign byte     9 NULL c = bp+4
  6162                                  ;  201 var sign byte     9 NULL d = bp+6;
  6163 0000217D C8000000                 ENTER  0,0
  6164 00002181 8A4604                   mov al, [bp+4]
  6165 00002184 024606                   add al, [bp+6]
  6166 00002187 884604                   mov [bp+4], al
  6167                                  
  6168                                  ;-11     genCode8(c);
  6169                                  
  6170 0000218A 8A4604                   mov al, byte [bp+4]
  6171 0000218D B400                     mov ah, 0
  6172 0000218F 50                       push ax
  6173 00002190 E82100                   call genCode8
  6174 00002193 83C402                   add  sp, 2
  6175                                  
  6176                                  ;-12 }                             
  6177                                  
  6178                                  
  6179                                  ;-13 int genCodeW(char c) {
  6180 00002196 C9                       LEAVE
  6181 00002197 C3                       ret
  6182                                  ENDP
  6183                                  
  6184                                  genCodeW: PROC
  6185                                  
  6186                                  ;-14     c = c + wflag;  
  6187                                  
  6188                                  ;Function : genCodeW, Number of local variables: 1
  6189                                  ;   # type sign width addr used name   list of local variables
  6190                                  ;  200 var sign byte    13 NULL c = bp+4;
  6191 00002198 C8000000                 ENTER  0,0
  6192 0000219C 8A4604                   mov al, [bp+4]
  6193 0000219F 0206[3900]               add al, [wflag]
  6194 000021A3 884604                   mov [bp+4], al
  6195                                  
  6196                                  ;-15     genCode8(c);
  6197                                  
  6198 000021A6 8A4604                   mov al, byte [bp+4]
  6199 000021A9 B400                     mov ah, 0
  6200 000021AB 50                       push ax
  6201 000021AC E80500                   call genCode8
  6202 000021AF 83C402                   add  sp, 2
  6203                                  
  6204                                  ;-16 }   
  6205                                  
  6206                                  
  6207                                  ;-17 int genCode8(char c) {
  6208 000021B2 C9                       LEAVE
  6209 000021B3 C3                       ret
  6210                                  ENDP
  6211                                  
  6212                                  genCode8: PROC
  6213                                  
  6214                                  ;-18 //set: BinLen++, OpPrintIndex++
  6215                                  
  6216                                  
  6217                                  ;-19     FileBin[BinLen]=c;
  6218                                  
  6219                                  ;Function : genCode8, Number of local variables: 1
  6220                                  ;   # type sign width addr used name   list of local variables
  6221                                  ;  200 var sign byte    17 NULL c = bp+4;
  6222 000021B4 C8000000                 ENTER  0,0
  6223 000021B8 8A4604                   mov al, [bp+4]
  6224 000021BB 8B1E[5100]               mov bx, [BinLen]
  6225 000021BF 88876297                 mov [FileBin+bx], al
  6226                                  
  6227                                  ;-20     BinLen++;
  6228                                  
  6229 000021C3 FF06[5100]               inc  word[BinLen]
  6230                                  
  6231                                  ;-21     PC++;
  6232                                  
  6233 000021C7 FF06[2400]               inc  word[PC]
  6234                                  
  6235                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6236                                  
  6237 000021CB A1[5100]                 mov ax, [BinLen]
  6238 000021CE 3D204E                   cmp ax, 20000 ;unsigned : 0
  6239 000021D1 0F820900                 jb  .genCode8237
  6240 000021D5 68[F921]                 push genCode8_0
  6241 000021D8 E82BF9                   call errorexit
  6242 000021DB 83C402                   add  sp, 2
  6243                                  
  6244                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  6245                                  
  6246                                  .genCode8237:
  6247 000021DE A1[4200]                 mov ax, [OpPrintIndex]
  6248 000021E1 83F805                   cmp ax, 5
  6249 000021E4 0F8D0F00                 jge .genCode8238
  6250                                  
  6251                                  ;-24         OpPos[OpPrintIndex]=c;
  6252                                  
  6253 000021E8 8A4604                   mov al, [bp+4]
  6254 000021EB 8B1E[4200]               mov bx, [OpPrintIndex]
  6255 000021EF 88875577                 mov [OpPos+bx], al
  6256                                  
  6257                                  ;-25         OpPrintIndex++;
  6258                                  
  6259 000021F3 FF06[4200]               inc  word[OpPrintIndex]
  6260                                  
  6261                                  ;-26     }
  6262                                  
  6263                                  
  6264                                  ;-27 }
  6265                                  
  6266                                  .genCode8238:
  6267                                  
  6268                                  ;-28 int genCode16(unsigned int i) {
  6269 000021F7 C9                       LEAVE
  6270 000021F8 C3                       ret
  6271 000021F9 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6272 00002202 746F6F206C6F6E6700 
  6273                                  ENDP
  6274                                  
  6275                                  genCode16: PROC
  6276                                  
  6277                                  ;-29     genCode8(i); i=i >> 8;
  6278                                  
  6279                                  ;Function : genCode16, Number of local variables: 1
  6280                                  ;   # type sign width addr used name   list of local variables
  6281                                  ;  200 var unsg word    28 NULL i = bp+4;
  6282 0000220B C8000000                 ENTER  0,0
  6283 0000220F FF7604                   push word [bp+4]
  6284 00002212 E89FFF                   call genCode8
  6285 00002215 83C402                   add  sp, 2
  6286 00002218 8B4604                   mov ax, [bp+4]
  6287 0000221B C1E808                   shr ax, 8
  6288 0000221E 894604                   mov [bp+4], ax
  6289                                  
  6290                                  ;-30     genCode8(i);
  6291                                  
  6292 00002221 FF7604                   push word [bp+4]
  6293 00002224 E88DFF                   call genCode8
  6294 00002227 83C402                   add  sp, 2
  6295                                  
  6296                                  ;-31 }
  6297                                  
  6298                                  
  6299                                  ;-32 int genCode32(unsigned long L) {
  6300 0000222A C9                       LEAVE
  6301 0000222B C3                       ret
  6302                                  ENDP
  6303                                  
  6304                                  genCode32: PROC
  6305                                  
  6306                                  ;-33     genCode16(L); L=L >>16;
  6307                                  
  6308                                  ;Function : genCode32, Number of local variables: 1
  6309                                  ;   # type sign width addr used name   list of local variables
  6310                                  ;  200 var unsg dwrd    32 NULL L = bp+4;
  6311 0000222C C8000000                 ENTER  0,0
  6312 00002230 8A4604                   mov al, byte [bp+4]
  6313 00002233 B400                     mov ah, 0
  6314 00002235 50                       push ax
  6315 00002236 E8D2FF                   call genCode16
  6316 00002239 83C402                   add  sp, 2
  6317 0000223C 668B4604                 mov eax, [bp+4]
  6318 00002240 66C1E810                 shr eax, 16
  6319 00002244 66894604                 mov [bp+4], eax
  6320                                  
  6321                                  ;-34     genCode16(L);
  6322                                  
  6323 00002248 8A4604                   mov al, byte [bp+4]
  6324 0000224B B400                     mov ah, 0
  6325 0000224D 50                       push ax
  6326 0000224E E8BAFF                   call genCode16
  6327 00002251 83C402                   add  sp, 2
  6328                                  
  6329                                  ;-35 }
  6330                                  
  6331                                  
  6332                                  ;-36 int writeEA(char xxx) {//value for reg/operand
  6333 00002254 C9                       LEAVE
  6334 00002255 C3                       ret
  6335                                  ENDP
  6336                                  
  6337                                  writeEA: PROC
  6338                                  
  6339                                  ;-37 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6340                                  
  6341                                  
  6342                                  ;-38 //mod-bits: mode76, reg/opcode543, r/m210   
  6343                                  
  6344                                  
  6345                                  ;-39 //Op: 0, IMM, REG, ADR, MEM   
  6346                                  
  6347                                  
  6348                                  ;-40     char len;
  6349                                  
  6350                                  
  6351                                  ;-41     len=0;   
  6352                                  
  6353                                  ;Function : writeEA, Number of local variables: 2
  6354                                  ;   # type sign width addr used name   list of local variables
  6355                                  ;  200 var sign byte    36 NULL xxx = bp+4
  6356                                  ;  201 var sign byte    40 NULL len = bp-2;
  6357 00002256 C8020000                 ENTER  2,0
  6358 0000225A B80000                   mov ax, 0
  6359 0000225D 8846FE                   mov [bp-2], al
  6360                                  
  6361                                  ;-42     xxx = xxx << 3;//in reg/opcode field      
  6362                                  
  6363 00002260 8A4604                   mov al, [bp+4]
  6364 00002263 C0E003                   shl al, 3
  6365 00002266 884604                   mov [bp+4], al
  6366                                  
  6367                                  ;-43     if (Op == REG) {
  6368                                  
  6369 00002269 A0[2E00]                 mov al, [Op]
  6370 0000226C 3C02                     cmp al, 2
  6371 0000226E 0F853A00                 jne .writeEA239
  6372                                  
  6373                                  ;-44         xxx |= 0xC0;     
  6374                                  
  6375 00002272 804E04C0                 or  byte[bp+4], 192
  6376                                  
  6377                                  ;-45         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  6378                                  
  6379 00002276 A0[2F00]                 mov al, [Op2]
  6380 00002279 3C01                     cmp al, 1
  6381 0000227B 0F8F0D00                 jg  .writeEA240
  6382 0000227F 8A4604                   mov al, [bp+4]
  6383 00002282 0206[3500]               add al, [R1No]
  6384 00002286 884604                   mov [bp+4], al
  6385                                  
  6386                                  ;-46             else {
  6387                                  
  6388 00002289 E92000                   jmp .writeEA241
  6389                                  .writeEA240:
  6390                                  
  6391                                  ;-47                 if (Op2 == REG) xxx = xxx + R1No;
  6392                                  
  6393 0000228C A0[2F00]                 mov al, [Op2]
  6394 0000228F 3C02                     cmp al, 2
  6395 00002291 0F850D00                 jne .writeEA242
  6396 00002295 8A4604                   mov al, [bp+4]
  6397 00002298 0206[3500]               add al, [R1No]
  6398 0000229C 884604                   mov [bp+4], al
  6399                                  
  6400                                  ;-48                 else            xxx = xxx + R2No;  
  6401                                  
  6402 0000229F E90A00                   jmp .writeEA243
  6403                                  .writeEA242:
  6404 000022A2 8A4604                   mov al, [bp+4]
  6405 000022A5 0206[3400]               add al, [R2No]
  6406 000022A9 884604                   mov [bp+4], al
  6407                                  
  6408                                  ;-49             }
  6409                                  
  6410                                  .writeEA243:
  6411                                  
  6412                                  ;-50         } 
  6413                                  
  6414                                  .writeEA241:
  6415                                  
  6416                                  ;-51     if (Op == MEM) {
  6417                                  
  6418                                  .writeEA239:
  6419 000022AC A0[2E00]                 mov al, [Op]
  6420 000022AF 3C04                     cmp al, 4
  6421 000022B1 0F857300                 jne .writeEA244
  6422                                  
  6423                                  ;-52         if (isDirect) {
  6424                                  
  6425 000022B5 A0[3D00]                 mov al, [isDirect]
  6426 000022B8 08C0                     or  al, al
  6427 000022BA 0F840D00                 je .writeEA245
  6428                                  
  6429                                  ;-53             xxx |= 6;
  6430                                  
  6431 000022BE 804E0406                 or  byte[bp+4], 6
  6432                                  
  6433                                  ;-54             len = 2;
  6434                                  
  6435 000022C2 B80200                   mov ax, 2
  6436 000022C5 8846FE                   mov [bp-2], al
  6437                                  
  6438                                  ;-55         }
  6439                                  
  6440                                  
  6441                                  ;-56         else { 
  6442                                  
  6443 000022C8 E95D00                   jmp .writeEA246
  6444                                  .writeEA245:
  6445                                  
  6446                                  ;-57             xxx = xxx + rm;   
  6447                                  
  6448 000022CB 8A4604                   mov al, [bp+4]
  6449 000022CE 0206[3C00]               add al, [rm]
  6450 000022D2 884604                   mov [bp+4], al
  6451                                  
  6452                                  ;-58             if (rm == 6) {//make [BP+00]
  6453                                  
  6454 000022D5 A0[3C00]                 mov al, [rm]
  6455 000022D8 3C06                     cmp al, 6
  6456 000022DA 0F851400                 jne .writeEA247
  6457                                  
  6458                                  ;-59                 len=1;
  6459                                  
  6460 000022DE B80100                   mov ax, 1
  6461 000022E1 8846FE                   mov [bp-2], al
  6462                                  
  6463                                  ;-60                 if (disp == 0) xxx |= 0x40;
  6464                                  
  6465 000022E4 A1[3E00]                 mov ax, [disp]
  6466 000022E7 83F800                   cmp ax, 0
  6467 000022EA 0F850400                 jne .writeEA248
  6468 000022EE 804E0440                 or  byte[bp+4], 64
  6469                                  
  6470                                  ;-61             }
  6471                                  
  6472                                  .writeEA248:
  6473                                  
  6474                                  ;-62 
  6475                                  
  6476                                  
  6477                                  ;-63             if (disp) {
  6478                                  
  6479                                  .writeEA247:
  6480 000022F2 A1[3E00]                 mov ax, [disp]
  6481 000022F5 08C0                     or  al, al
  6482 000022F7 0F842D00                 je .writeEA249
  6483                                  
  6484                                  ;-64                 ax = disp;
  6485                                  
  6486 000022FB A1[3E00]                 mov  ax, [disp]
  6487                                  
  6488                                  ;-65                 if(ax > 127) len=2;
  6489                                  
  6490 000022FE 83F87F                   cmp  ax, 127
  6491 00002301 0F8E0900                 jle .writeEA250
  6492 00002305 B80200                   mov ax, 2
  6493 00002308 8846FE                   mov [bp-2], al
  6494                                  
  6495                                  ;-66                 else len=1;
  6496                                  
  6497 0000230B E90600                   jmp .writeEA251
  6498                                  .writeEA250:
  6499 0000230E B80100                   mov ax, 1
  6500 00002311 8846FE                   mov [bp-2], al
  6501                                  
  6502                                  ;-67                 if (len == 1) xxx |= 0x40;
  6503                                  
  6504                                  .writeEA251:
  6505 00002314 8A46FE                   mov al, [bp-2]
  6506 00002317 3C01                     cmp al, 1
  6507 00002319 0F850700                 jne .writeEA252
  6508 0000231D 804E0440                 or  byte[bp+4], 64
  6509                                  
  6510                                  ;-68                 else xxx |= 0x80;
  6511                                  
  6512 00002321 E90400                   jmp .writeEA253
  6513                                  .writeEA252:
  6514 00002324 804E0480                 or  byte[bp+4], 128
  6515                                  
  6516                                  ;-69             }
  6517                                  
  6518                                  .writeEA253:
  6519                                  
  6520                                  ;-70         }
  6521                                  
  6522                                  .writeEA249:
  6523                                  
  6524                                  ;-71     }  
  6525                                  
  6526                                  .writeEA246:
  6527                                  
  6528                                  ;-72     
  6529                                  
  6530                                  
  6531                                  ;-73     genCode8(xxx);// gen second byte
  6532                                  
  6533                                  .writeEA244:
  6534 00002328 8A4604                   mov al, byte [bp+4]
  6535 0000232B B400                     mov ah, 0
  6536 0000232D 50                       push ax
  6537 0000232E E883FE                   call genCode8
  6538 00002331 83C402                   add  sp, 2
  6539                                  
  6540                                  ;-74     if (len == 1) genCode8 (disp);
  6541                                  
  6542 00002334 8A46FE                   mov al, [bp-2]
  6543 00002337 3C01                     cmp al, 1
  6544 00002339 0F850A00                 jne .writeEA254
  6545 0000233D FF36[3E00]               push word [disp]
  6546 00002341 E870FE                   call genCode8
  6547 00002344 83C402                   add  sp, 2
  6548                                  
  6549                                  ;-75     if (len == 2) genCode16(disp);
  6550                                  
  6551                                  .writeEA254:
  6552 00002347 8A46FE                   mov al, [bp-2]
  6553 0000234A 3C02                     cmp al, 2
  6554 0000234C 0F850A00                 jne .writeEA255
  6555 00002350 FF36[3E00]               push word [disp]
  6556 00002354 E8B4FE                   call genCode16
  6557 00002357 83C402                   add  sp, 2
  6558                                  
  6559                                  ;-76 }
  6560                                  
  6561                                  .writeEA255:
  6562                                  
  6563                                  ;-77 
  6564                                  
  6565                                  
  6566                                  ;-78 int genImmediate() { 
  6567 0000235A C9                       LEAVE
  6568 0000235B C3                       ret
  6569                                  ENDP
  6570                                  
  6571                                  genImmediate: PROC
  6572                                  
  6573                                  ;-79     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6574                                  
  6575 0000235C A0[3900]                 mov al, [wflag]
  6576 0000235F 08C0                     or  al, al
  6577 00002361 0F842300                 je .genImmediate256
  6578 00002365 A0[3800]                 mov al, [OpSize]
  6579 00002368 3C03                     cmp al, 3
  6580 0000236A 0F850D00                 jne .genImmediate257
  6581 0000236E FF36[4000]               push word [imme]
  6582 00002372 E8B7FE                   call genCode32
  6583 00002375 83C402                   add  sp, 2
  6584                                  
  6585                                  ;-80         else genCode16(imme);
  6586                                  
  6587 00002378 E90A00                   jmp .genImmediate258
  6588                                  .genImmediate257:
  6589 0000237B FF36[4000]               push word [imme]
  6590 0000237F E889FE                   call genCode16
  6591 00002382 83C402                   add  sp, 2
  6592                                  
  6593                                  ;-81     else       genCode8 (imme);  
  6594                                  
  6595                                  .genImmediate258:
  6596 00002385 E90A00                   jmp .genImmediate259
  6597                                  .genImmediate256:
  6598 00002388 FF36[4000]               push word [imme]
  6599 0000238C E825FE                   call genCode8
  6600 0000238F 83C402                   add  sp, 2
  6601                                  
  6602                                  ;-82 }    
  6603                                  
  6604                                  .genImmediate259:
  6605 00002392 C3                       ret
  6606                                  ENDP
  6607                                  ;Back to main program: AS.C
  6608                                  
  6609                                  ;-10 
  6610                                  
  6611                                  
  6612                                  ;-11 int process() {
  6613                                  
  6614                                  
  6615                                  process: PROC
  6616                                  
  6617                                  ;-12     char c;
  6618                                  
  6619                                  
  6620                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6621                                  
  6622                                  ;Function : process, Number of local variables: 1
  6623                                  ;   # type sign width addr used name   list of local variables
  6624                                  ;  200 var sign byte    12 NULL c = bp-2;
  6625 00002393 C8020000                 ENTER  2,0
  6626 00002397 B80000                   mov ax, 0
  6627 0000239A A2[3C00]                 mov byte [rm], al
  6628 0000239D A2[3900]                 mov byte [wflag], al
  6629 000023A0 A2[3A00]                 mov byte [dflag], al
  6630 000023A3 A2[3400]                 mov byte [R2No], al
  6631 000023A6 A2[3500]                 mov byte [R1No], al
  6632 000023A9 A2[3600]                 mov byte [R2Type], al
  6633 000023AC A2[3700]                 mov byte [R1Type], al
  6634 000023AF A2[2F00]                 mov byte [Op2], al
  6635 000023B2 A2[2E00]                 mov byte [Op], al
  6636                                  
  6637                                  ;-14     disp=imme=0;//int
  6638                                  
  6639 000023B5 B80000                   mov ax, 0
  6640 000023B8 A3[4000]                 mov word [imme], ax
  6641 000023BB A3[3E00]                 mov word [disp], ax
  6642                                  
  6643                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6644                                  
  6645 000023BE B80100                   mov ax, 1
  6646 000023C1 A2[3D00]                 mov byte [isDirect], al
  6647                                  
  6648                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6649                                  
  6650 000023C4 E89CE6                   call getTokeType
  6651                                  
  6652                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6653                                  
  6654 000023C7 E8B5EA                   call getCodeSize
  6655 000023CA A2[3800]                 mov byte [OpSize], al
  6656                                  
  6657                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6658                                  
  6659 000023CD E876FD                   call getCodes
  6660                                  
  6661                                  ;-19 
  6662                                  
  6663                                  
  6664                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6665                                  
  6666 000023D0 A0[3000]                 mov al, [CodeType]
  6667 000023D3 3C01                     cmp al, 1
  6668 000023D5 0F850F00                 jne .process260
  6669                                  
  6670                                  ;-21         genCode8(Code1);
  6671                                  
  6672 000023D9 A0[3100]                 mov al, byte [Code1]
  6673 000023DC B400                     mov ah, 0
  6674 000023DE 50                       push ax
  6675 000023DF E8D2FD                   call genCode8
  6676 000023E2 83C402                   add  sp, 2
  6677                                  
  6678                                  ;-22         return;
  6679                                  
  6680 000023E5 E90208                   jmp .retnprocess
  6681                                  
  6682                                  ;-23     }
  6683                                  
  6684                                  
  6685                                  ;-24 
  6686                                  
  6687                                  
  6688                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6689                                  
  6690                                  .process260:
  6691 000023E8 A0[3000]                 mov al, [CodeType]
  6692 000023EB 3C02                     cmp al, 2
  6693 000023ED 0F856900                 jne .process261
  6694                                  
  6695                                  ;-26         getOpL();
  6696                                  
  6697 000023F1 E894E1                   call getOpL
  6698                                  
  6699                                  ;-27         checkOpL();
  6700                                  
  6701 000023F4 E8B4E0                   call checkOpL
  6702                                  
  6703                                  ;-28         if (Code2 <= 1) {//inc,dec
  6704                                  
  6705 000023F7 A0[3200]                 mov al, [Code2]
  6706 000023FA 3C01                     cmp al, 1
  6707 000023FC 0F8F2700                 jg  .process262
  6708                                  
  6709                                  ;-29   	        if (Op == REG) {//short
  6710                                  
  6711 00002400 A0[2E00]                 mov al, [Op]
  6712 00002403 3C02                     cmp al, 2
  6713 00002405 0F851E00                 jne .process263
  6714                                  
  6715                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6716                                  
  6717 00002409 A0[3900]                 mov al, [wflag]
  6718 0000240C 08C0                     or  al, al
  6719 0000240E 0F841500                 je .process264
  6720 00002412 A0[3500]                 mov al, byte [R1No]
  6721 00002415 B400                     mov ah, 0
  6722 00002417 50                       push ax
  6723 00002418 A0[3300]                 mov al, byte [Code3]
  6724 0000241B B400                     mov ah, 0
  6725 0000241D 50                       push ax
  6726 0000241E E85CFD                   call genCode2
  6727 00002421 83C404                   add  sp, 4
  6728 00002424 E9C307                   jmp .retnprocess
  6729                                  
  6730                                  ;-31             }
  6731                                  
  6732                                  .process264:
  6733                                  
  6734                                  ;-32         }
  6735                                  
  6736                                  .process263:
  6737                                  
  6738                                  ;-33         if (Code2 == 5) {//imul extension?
  6739                                  
  6740                                  .process262:
  6741 00002427 A0[3200]                 mov al, [Code2]
  6742 0000242A 3C05                     cmp al, 5
  6743 0000242C 0F850F00                 jne .process265
  6744                                  
  6745                                  ;-34             getTokeType();
  6746                                  
  6747 00002430 E830E6                   call getTokeType
  6748                                  
  6749                                  ;-35             if (TokeType) implerror();
  6750                                  
  6751 00002433 A0[2D00]                 mov al, [TokeType]
  6752 00002436 08C0                     or  al, al
  6753 00002438 0F840300                 je .process266
  6754 0000243C E83BF7                   call implerror
  6755                                  
  6756                                  ;-36         }
  6757                                  
  6758                                  .process266:
  6759                                  
  6760                                  ;-37         genCodeW(Code1);
  6761                                  
  6762                                  .process265:
  6763 0000243F A0[3100]                 mov al, byte [Code1]
  6764 00002442 B400                     mov ah, 0
  6765 00002444 50                       push ax
  6766 00002445 E850FD                   call genCodeW
  6767 00002448 83C402                   add  sp, 2
  6768                                  
  6769                                  ;-38         writeEA(Code2);
  6770                                  
  6771 0000244B A0[3200]                 mov al, byte [Code2]
  6772 0000244E B400                     mov ah, 0
  6773 00002450 50                       push ax
  6774 00002451 E802FE                   call writeEA
  6775 00002454 83C402                   add  sp, 2
  6776                                  
  6777                                  ;-39         return;
  6778                                  
  6779 00002457 E99007                   jmp .retnprocess
  6780                                  
  6781                                  ;-40     }
  6782                                  
  6783                                  
  6784                                  ;-41 
  6785                                  
  6786                                  
  6787                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6788                                  
  6789                                  .process261:
  6790 0000245A A0[3000]                 mov al, [CodeType]
  6791 0000245D 3C03                     cmp al, 3
  6792 0000245F 0F855100                 jne .process267
  6793                                  
  6794                                  ;-43         check2Ops();    //setwflag not applicable
  6795                                  
  6796 00002463 E8C7E0                   call check2Ops
  6797                                  
  6798                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6799                                  
  6800 00002466 A0[3700]                 mov al, [R1Type]
  6801 00002469 3C02                     cmp al, 2
  6802 0000246B 0F840300                 je  .process268
  6803 0000246F E8A8F7                   call reg16error
  6804                                  
  6805                                  ;-45         if (Op2 != MEM) addrerror();//only m16
  6806                                  
  6807                                  .process268:
  6808 00002472 A0[2F00]                 mov al, [Op2]
  6809 00002475 3C04                     cmp al, 4
  6810 00002477 0F840300                 je  .process269
  6811 0000247B E8BDF6                   call addrerror
  6812                                  
  6813                                  ;-46 
  6814                                  
  6815                                  
  6816                                  ;-47         genCode8(Code1);//les,lds,lea
  6817                                  
  6818                                  .process269:
  6819 0000247E A0[3100]                 mov al, byte [Code1]
  6820 00002481 B400                     mov ah, 0
  6821 00002483 50                       push ax
  6822 00002484 E82DFD                   call genCode8
  6823 00002487 83C402                   add  sp, 2
  6824                                  
  6825                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6826                                  
  6827 0000248A A0[3100]                 mov al, [Code1]
  6828 0000248D 3C0F                     cmp al, 15
  6829 0000248F 0F850C00                 jne .process270
  6830 00002493 A0[3200]                 mov al, byte [Code2]
  6831 00002496 B400                     mov ah, 0
  6832 00002498 50                       push ax
  6833 00002499 E818FD                   call genCode8
  6834 0000249C 83C402                   add  sp, 2
  6835                                  
  6836                                  ;-49         Op=Op2;//set MEM for writeEA
  6837                                  
  6838                                  .process270:
  6839 0000249F A0[2F00]                 mov al, [Op2]
  6840 000024A2 A2[2E00]                 mov byte [Op], al
  6841                                  
  6842                                  ;-50         writeEA(R1No);
  6843                                  
  6844 000024A5 A0[3500]                 mov al, byte [R1No]
  6845 000024A8 B400                     mov ah, 0
  6846 000024AA 50                       push ax
  6847 000024AB E8A8FD                   call writeEA
  6848 000024AE 83C402                   add  sp, 2
  6849                                  
  6850                                  ;-51         return;
  6851                                  
  6852 000024B1 E93607                   jmp .retnprocess
  6853                                  
  6854                                  ;-52     }
  6855                                  
  6856                                  
  6857                                  ;-53 
  6858                                  
  6859                                  
  6860                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6861                                  
  6862                                  .process267:
  6863 000024B4 A0[3000]                 mov al, [CodeType]
  6864 000024B7 3C04                     cmp al, 4
  6865 000024B9 0F85EF00                 jne .process271
  6866                                  
  6867                                  ;-55         check2Ops();
  6868                                  
  6869 000024BD E86DE0                   call check2Ops
  6870                                  
  6871                                  ;-56         if (Op2 == IMM) {//second operand is imm
  6872                                  
  6873 000024C0 A0[2F00]                 mov al, [Op2]
  6874 000024C3 3C01                     cmp al, 1
  6875 000024C5 0F857900                 jne .process272
  6876                                  
  6877                                  ;-57             setsflag();
  6878                                  
  6879 000024C9 E8F6E3                   call setsflag
  6880                                  
  6881                                  ;-58             if (Op == REG) {
  6882                                  
  6883 000024CC A0[2E00]                 mov al, [Op]
  6884 000024CF 3C02                     cmp al, 2
  6885 000024D1 0F853100                 jne .process273
  6886                                  
  6887                                  ;-59                 if (R1No == 0) {// acc,imm
  6888                                  
  6889 000024D5 A0[3500]                 mov al, [R1No]
  6890 000024D8 3C00                     cmp al, 0
  6891 000024DA 0F852800                 jne .process274
  6892                                  
  6893                                  ;-60                     if (sflag == 0) {
  6894                                  
  6895 000024DE A0[3B00]                 mov al, [sflag]
  6896 000024E1 3C00                     cmp al, 0
  6897 000024E3 0F851F00                 jne .process275
  6898                                  
  6899                                  ;-61                         c = Code1 << 3;
  6900                                  
  6901 000024E7 A0[3100]                 mov al, [Code1]
  6902 000024EA C0E003                   shl al, 3
  6903 000024ED 8846FE                   mov [bp-2], al
  6904                                  
  6905                                  ;-62                         c += 4;
  6906                                  
  6907 000024F0 8046FE04                 add  byte[bp-2], 4
  6908                                  
  6909                                  ;-63                         genCodeW(c);
  6910                                  
  6911 000024F4 8A46FE                   mov al, byte [bp-2]
  6912 000024F7 B400                     mov ah, 0
  6913 000024F9 50                       push ax
  6914 000024FA E89BFC                   call genCodeW
  6915 000024FD 83C402                   add  sp, 2
  6916                                  
  6917                                  ;-64                         genImmediate();
  6918                                  
  6919 00002500 E859FE                   call genImmediate
  6920                                  
  6921                                  ;-65                         return;
  6922                                  
  6923 00002503 E9E406                   jmp .retnprocess
  6924                                  
  6925                                  ;-66                     }
  6926                                  
  6927                                  
  6928                                  ;-67                 }
  6929                                  
  6930                                  .process275:
  6931                                  
  6932                                  ;-68             }
  6933                                  
  6934                                  .process274:
  6935                                  
  6936                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6937                                  
  6938                                  
  6939                                  ;-70             c = sflag + 0x80;
  6940                                  
  6941                                  .process273:
  6942 00002506 A0[3B00]                 mov al, [sflag]
  6943 00002509 0480                     add al, 128
  6944 0000250B 8846FE                   mov [bp-2], al
  6945                                  
  6946                                  ;-71             genCodeW(c);
  6947                                  
  6948 0000250E 8A46FE                   mov al, byte [bp-2]
  6949 00002511 B400                     mov ah, 0
  6950 00002513 50                       push ax
  6951 00002514 E881FC                   call genCodeW
  6952 00002517 83C402                   add  sp, 2
  6953                                  
  6954                                  ;-72             writeEA(Code1);
  6955                                  
  6956 0000251A A0[3100]                 mov al, byte [Code1]
  6957 0000251D B400                     mov ah, 0
  6958 0000251F 50                       push ax
  6959 00002520 E833FD                   call writeEA
  6960 00002523 83C402                   add  sp, 2
  6961                                  
  6962                                  ;-73             if (sflag) genCode8(imme);
  6963                                  
  6964 00002526 A0[3B00]                 mov al, [sflag]
  6965 00002529 08C0                     or  al, al
  6966 0000252B 0F840D00                 je .process276
  6967 0000252F FF36[4000]               push word [imme]
  6968 00002533 E87EFC                   call genCode8
  6969 00002536 83C402                   add  sp, 2
  6970                                  
  6971                                  ;-74             else genImmediate();
  6972                                  
  6973 00002539 E90300                   jmp .process277
  6974                                  .process276:
  6975 0000253C E81DFE                   call genImmediate
  6976                                  
  6977                                  ;-75             return;
  6978                                  
  6979                                  .process277:
  6980 0000253F E9A806                   jmp .retnprocess
  6981                                  
  6982                                  ;-76         }
  6983                                  
  6984                                  
  6985                                  ;-77         c = Code1 << 3;//r/m, r/r
  6986                                  
  6987                                  .process272:
  6988 00002542 A0[3100]                 mov al, [Code1]
  6989 00002545 C0E003                   shl al, 3
  6990 00002548 8846FE                   mov [bp-2], al
  6991                                  
  6992                                  ;-78         if (Op == REG) {
  6993                                  
  6994 0000254B A0[2E00]                 mov al, [Op]
  6995 0000254E 3C02                     cmp al, 2
  6996 00002550 0F852E00                 jne .process278
  6997                                  
  6998                                  ;-79             if (Op2 == MEM) {//reg, mem
  6999                                  
  7000 00002554 A0[2F00]                 mov al, [Op2]
  7001 00002557 3C04                     cmp al, 4
  7002 00002559 0F852500                 jne .process279
  7003                                  
  7004                                  ;-80                 c += 2;//add direction flag
  7005                                  
  7006 0000255D 8046FE02                 add  byte[bp-2], 2
  7007                                  
  7008                                  ;-81                 genCodeW(c);
  7009                                  
  7010 00002561 8A46FE                   mov al, byte [bp-2]
  7011 00002564 B400                     mov ah, 0
  7012 00002566 50                       push ax
  7013 00002567 E82EFC                   call genCodeW
  7014 0000256A 83C402                   add  sp, 2
  7015                                  
  7016                                  ;-82                 Op=Op2;//set MEM for writeEA
  7017                                  
  7018 0000256D A0[2F00]                 mov al, [Op2]
  7019 00002570 A2[2E00]                 mov byte [Op], al
  7020                                  
  7021                                  ;-83                 writeEA(R1No);
  7022                                  
  7023 00002573 A0[3500]                 mov al, byte [R1No]
  7024 00002576 B400                     mov ah, 0
  7025 00002578 50                       push ax
  7026 00002579 E8DAFC                   call writeEA
  7027 0000257C 83C402                   add  sp, 2
  7028                                  
  7029                                  ;-84                 return;
  7030                                  
  7031 0000257F E96806                   jmp .retnprocess
  7032                                  
  7033                                  ;-85             }
  7034                                  
  7035                                  
  7036                                  ;-86         }
  7037                                  
  7038                                  .process279:
  7039                                  
  7040                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  7041                                  
  7042                                  .process278:
  7043 00002582 A0[2F00]                 mov al, [Op2]
  7044 00002585 3C02                     cmp al, 2
  7045 00002587 0F851B00                 jne .process280
  7046                                  
  7047                                  ;-88             genCodeW(c);
  7048                                  
  7049 0000258B 8A46FE                   mov al, byte [bp-2]
  7050 0000258E B400                     mov ah, 0
  7051 00002590 50                       push ax
  7052 00002591 E804FC                   call genCodeW
  7053 00002594 83C402                   add  sp, 2
  7054                                  
  7055                                  ;-89             writeEA(R2No);//2. Op in reg-field
  7056                                  
  7057 00002597 A0[3400]                 mov al, byte [R2No]
  7058 0000259A B400                     mov ah, 0
  7059 0000259C 50                       push ax
  7060 0000259D E8B6FC                   call writeEA
  7061 000025A0 83C402                   add  sp, 2
  7062                                  
  7063                                  ;-90             return;
  7064                                  
  7065 000025A3 E94406                   jmp .retnprocess
  7066                                  
  7067                                  ;-91         }
  7068                                  
  7069                                  
  7070                                  ;-92         syntaxerror();
  7071                                  
  7072                                  .process280:
  7073 000025A6 E8C0F6                   call syntaxerror
  7074                                  
  7075                                  ;-93         return;
  7076                                  
  7077 000025A9 E93E06                   jmp .retnprocess
  7078                                  
  7079                                  ;-94     }
  7080                                  
  7081                                  
  7082                                  ;-95 
  7083                                  
  7084                                  
  7085                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  7086                                  
  7087                                  .process271:
  7088 000025AC A0[3000]                 mov al, [CodeType]
  7089 000025AF 3C05                     cmp al, 5
  7090 000025B1 0F857C01                 jne .process281
  7091                                  
  7092                                  ;-97         check2Ops();
  7093                                  
  7094 000025B5 E875DF                   call check2Ops
  7095                                  
  7096                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  7097                                  
  7098                                  
  7099                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  7100                                  
  7101                                  
  7102                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  7103                                  
  7104                                  
  7105                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */
  7106                                  
  7107                                  
  7108                                  ;-102         if (Op2 == ADR) {
  7109                                  
  7110 000025B8 A0[2F00]                 mov al, [Op2]
  7111 000025BB 3C03                     cmp al, 3
  7112 000025BD 0F850C00                 jne .process282
  7113                                  
  7114                                  ;-103             imme=disp;
  7115                                  
  7116 000025C1 A1[3E00]                 mov ax, [disp]
  7117 000025C4 A3[4000]                 mov word [imme], ax
  7118                                  
  7119                                  ;-104             Op2=IMM;//continue with IMM
  7120                                  
  7121 000025C7 B80100                   mov ax, 1
  7122 000025CA A2[2F00]                 mov byte [Op2], al
  7123                                  
  7124                                  ;-105         }
  7125                                  
  7126                                  
  7127                                  ;-106         if (Op2 == IMM) {// r,i
  7128                                  
  7129                                  .process282:
  7130 000025CD A0[2F00]                 mov al, [Op2]
  7131 000025D0 3C01                     cmp al, 1
  7132 000025D2 0F855400                 jne .process283
  7133                                  
  7134                                  ;-107             if (Op == REG) {
  7135                                  
  7136 000025D6 A0[2E00]                 mov al, [Op]
  7137 000025D9 3C02                     cmp al, 2
  7138 000025DB 0F852500                 jne .process284
  7139                                  
  7140                                  ;-108                 c = wflag << 3;
  7141                                  
  7142 000025DF A0[3900]                 mov al, [wflag]
  7143 000025E2 C0E003                   shl al, 3
  7144 000025E5 8846FE                   mov [bp-2], al
  7145                                  
  7146                                  ;-109                 c += 0xB0;
  7147                                  
  7148 000025E8 8046FEB0                 add  byte[bp-2], 176
  7149                                  
  7150                                  ;-110                 genCode2(c, R1No);
  7151                                  
  7152 000025EC A0[3500]                 mov al, byte [R1No]
  7153 000025EF B400                     mov ah, 0
  7154 000025F1 50                       push ax
  7155 000025F2 8A46FE                   mov al, byte [bp-2]
  7156 000025F5 B400                     mov ah, 0
  7157 000025F7 50                       push ax
  7158 000025F8 E882FB                   call genCode2
  7159 000025FB 83C404                   add  sp, 4
  7160                                  
  7161                                  ;-111                 genImmediate();
  7162                                  
  7163 000025FE E85BFD                   call genImmediate
  7164                                  
  7165                                  ;-112                 return;
  7166                                  
  7167 00002601 E9E605                   jmp .retnprocess
  7168                                  
  7169                                  ;-113             }
  7170                                  
  7171                                  
  7172                                  ;-114             if (Op == MEM) {// m,i
  7173                                  
  7174                                  .process284:
  7175 00002604 A0[2E00]                 mov al, [Op]
  7176 00002607 3C04                     cmp al, 4
  7177 00002609 0F851700                 jne .process285
  7178                                  
  7179                                  ;-115                 genCodeW(0xC6);
  7180                                  
  7181 0000260D 68C600                   push 198
  7182 00002610 E885FB                   call genCodeW
  7183 00002613 83C402                   add  sp, 2
  7184                                  
  7185                                  ;-116                 writeEA( 0 );
  7186                                  
  7187 00002616 6A00                     push 0
  7188 00002618 E83BFC                   call writeEA
  7189 0000261B 83C402                   add  sp, 2
  7190                                  
  7191                                  ;-117                 genImmediate();
  7192                                  
  7193 0000261E E83BFD                   call genImmediate
  7194                                  
  7195                                  ;-118                 return;
  7196                                  
  7197 00002621 E9C605                   jmp .retnprocess
  7198                                  
  7199                                  ;-119             }
  7200                                  
  7201                                  
  7202                                  ;-120             regmemerror();
  7203                                  
  7204                                  .process285:
  7205 00002624 E8C9F5                   call regmemerror
  7206                                  
  7207                                  ;-121             return;
  7208                                  
  7209 00002627 E9C005                   jmp .retnprocess
  7210                                  
  7211                                  ;-122         }
  7212                                  
  7213                                  
  7214                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7215                                  
  7216                                  .process283:
  7217 0000262A A0[3700]                 mov al, [R1Type]
  7218 0000262D 3C04                     cmp al, 4
  7219 0000262F 0F850300                 jne .process286
  7220 00002633 E833DE                   call ChangeDirection
  7221                                  
  7222                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  7223                                  
  7224                                  .process286:
  7225 00002636 A0[3600]                 mov al, [R2Type]
  7226 00002639 3C04                     cmp al, 4
  7227 0000263B 0F852A00                 jne .process287
  7228                                  
  7229                                  ;-125             if (OpSize != WORD) reg16error();
  7230                                  
  7231 0000263F A0[3800]                 mov al, [OpSize]
  7232 00002642 3C02                     cmp al, 2
  7233 00002644 0F840300                 je  .process288
  7234 00002648 E8CFF5                   call reg16error
  7235                                  
  7236                                  ;-126                 genCode2(0x8C, dflag);
  7237                                  
  7238                                  .process288:
  7239 0000264B A0[3A00]                 mov al, byte [dflag]
  7240 0000264E B400                     mov ah, 0
  7241 00002650 50                       push ax
  7242 00002651 688C00                   push 140
  7243 00002654 E826FB                   call genCode2
  7244 00002657 83C404                   add  sp, 4
  7245                                  
  7246                                  ;-127                 writeEA(R2No);
  7247                                  
  7248 0000265A A0[3400]                 mov al, byte [R2No]
  7249 0000265D B400                     mov ah, 0
  7250 0000265F 50                       push ax
  7251 00002660 E8F3FB                   call writeEA
  7252 00002663 83C402                   add  sp, 2
  7253                                  
  7254                                  ;-128                 return;
  7255                                  
  7256 00002666 E98105                   jmp .retnprocess
  7257                                  
  7258                                  ;-129         }
  7259                                  
  7260                                  
  7261                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  7262                                  
  7263                                  .process287:
  7264 00002669 A0[2F00]                 mov al, [Op2]
  7265 0000266C 3C04                     cmp al, 4
  7266 0000266E 0F853100                 jne .process289
  7267                                  
  7268                                  ;-131             if (Op == REG) {
  7269                                  
  7270 00002672 A0[2E00]                 mov al, [Op]
  7271 00002675 3C02                     cmp al, 2
  7272 00002677 0F852800                 jne .process290
  7273                                  
  7274                                  ;-132                 if (R1No == 0) {
  7275                                  
  7276 0000267B A0[3500]                 mov al, [R1No]
  7277 0000267E 3C00                     cmp al, 0
  7278 00002680 0F851F00                 jne .process291
  7279                                  
  7280                                  ;-133                     if (isDirect) {
  7281                                  
  7282 00002684 A0[3D00]                 mov al, [isDirect]
  7283 00002687 08C0                     or  al, al
  7284 00002689 0F841600                 je .process292
  7285                                  
  7286                                  ;-134                         genCodeW(0xA0);
  7287                                  
  7288 0000268D 68A000                   push 160
  7289 00002690 E805FB                   call genCodeW
  7290 00002693 83C402                   add  sp, 2
  7291                                  
  7292                                  ;-135                         genCode16(disp);
  7293                                  
  7294 00002696 FF36[3E00]               push word [disp]
  7295 0000269A E86EFB                   call genCode16
  7296 0000269D 83C402                   add  sp, 2
  7297                                  
  7298                                  ;-136                         return;
  7299                                  
  7300 000026A0 E94705                   jmp .retnprocess
  7301                                  
  7302                                  ;-137                     }
  7303                                  
  7304                                  
  7305                                  ;-138                 }
  7306                                  
  7307                                  .process292:
  7308                                  
  7309                                  ;-139             }
  7310                                  
  7311                                  .process291:
  7312                                  
  7313                                  ;-140         }
  7314                                  
  7315                                  .process290:
  7316                                  
  7317                                  ;-141         if (Op == MEM) {//moffs16, acc
  7318                                  
  7319                                  .process289:
  7320 000026A3 A0[2E00]                 mov al, [Op]
  7321 000026A6 3C04                     cmp al, 4
  7322 000026A8 0F853100                 jne .process293
  7323                                  
  7324                                  ;-142             if (Op2 == REG) {
  7325                                  
  7326 000026AC A0[2F00]                 mov al, [Op2]
  7327 000026AF 3C02                     cmp al, 2
  7328 000026B1 0F852800                 jne .process294
  7329                                  
  7330                                  ;-143                 if (R2No == 0) {
  7331                                  
  7332 000026B5 A0[3400]                 mov al, [R2No]
  7333 000026B8 3C00                     cmp al, 0
  7334 000026BA 0F851F00                 jne .process295
  7335                                  
  7336                                  ;-144                     if (isDirect) {
  7337                                  
  7338 000026BE A0[3D00]                 mov al, [isDirect]
  7339 000026C1 08C0                     or  al, al
  7340 000026C3 0F841600                 je .process296
  7341                                  
  7342                                  ;-145                         genCodeW(0xA2);
  7343                                  
  7344 000026C7 68A200                   push 162
  7345 000026CA E8CBFA                   call genCodeW
  7346 000026CD 83C402                   add  sp, 2
  7347                                  
  7348                                  ;-146                         genCode16(disp);
  7349                                  
  7350 000026D0 FF36[3E00]               push word [disp]
  7351 000026D4 E834FB                   call genCode16
  7352 000026D7 83C402                   add  sp, 2
  7353                                  
  7354                                  ;-147                         return;
  7355                                  
  7356 000026DA E90D05                   jmp .retnprocess
  7357                                  
  7358                                  ;-148                     }
  7359                                  
  7360                                  
  7361                                  ;-149                 }
  7362                                  
  7363                                  .process296:
  7364                                  
  7365                                  ;-150             }
  7366                                  
  7367                                  .process295:
  7368                                  
  7369                                  ;-151 
  7370                                  
  7371                                  
  7372                                  ;-152         }
  7373                                  
  7374                                  .process294:
  7375                                  
  7376                                  ;-153         if (Op2 == REG) {//rm, r
  7377                                  
  7378                                  .process293:
  7379 000026DD A0[2F00]                 mov al, [Op2]
  7380 000026E0 3C02                     cmp al, 2
  7381 000026E2 0F851800                 jne .process297
  7382                                  
  7383                                  ;-154             genCodeW(0x88);
  7384                                  
  7385 000026E6 688800                   push 136
  7386 000026E9 E8ACFA                   call genCodeW
  7387 000026EC 83C402                   add  sp, 2
  7388                                  
  7389                                  ;-155             writeEA(R2No);
  7390                                  
  7391 000026EF A0[3400]                 mov al, byte [R2No]
  7392 000026F2 B400                     mov ah, 0
  7393 000026F4 50                       push ax
  7394 000026F5 E85EFB                   call writeEA
  7395 000026F8 83C402                   add  sp, 2
  7396                                  
  7397                                  ;-156             return;
  7398                                  
  7399 000026FB E9EC04                   jmp .retnprocess
  7400                                  
  7401                                  ;-157         }
  7402                                  
  7403                                  
  7404                                  ;-158         if (Op2 == MEM) {//r, m
  7405                                  
  7406                                  .process297:
  7407 000026FE A0[2F00]                 mov al, [Op2]
  7408 00002701 3C04                     cmp al, 4
  7409 00002703 0F852400                 jne .process298
  7410                                  
  7411                                  ;-159             if (Op == REG) {
  7412                                  
  7413 00002707 A0[2E00]                 mov al, [Op]
  7414 0000270A 3C02                     cmp al, 2
  7415 0000270C 0F851B00                 jne .process299
  7416                                  
  7417                                  ;-160                 ChangeDirection();
  7418                                  
  7419 00002710 E856DD                   call ChangeDirection
  7420                                  
  7421                                  ;-161                 genCodeW(0x8A);
  7422                                  
  7423 00002713 688A00                   push 138
  7424 00002716 E87FFA                   call genCodeW
  7425 00002719 83C402                   add  sp, 2
  7426                                  
  7427                                  ;-162                 writeEA(R2No);
  7428                                  
  7429 0000271C A0[3400]                 mov al, byte [R2No]
  7430 0000271F B400                     mov ah, 0
  7431 00002721 50                       push ax
  7432 00002722 E831FB                   call writeEA
  7433 00002725 83C402                   add  sp, 2
  7434                                  
  7435                                  ;-163                 return;
  7436                                  
  7437 00002728 E9BF04                   jmp .retnprocess
  7438                                  
  7439                                  ;-164             }
  7440                                  
  7441                                  
  7442                                  ;-165         }
  7443                                  
  7444                                  .process299:
  7445                                  
  7446                                  ;-166         syntaxerror();
  7447                                  
  7448                                  .process298:
  7449 0000272B E83BF5                   call syntaxerror
  7450                                  
  7451                                  ;-167         return;
  7452                                  
  7453 0000272E E9B904                   jmp .retnprocess
  7454                                  
  7455                                  ;-168     }
  7456                                  
  7457                                  
  7458                                  ;-169 
  7459                                  
  7460                                  
  7461                                  ;-170     if (CodeType == 6) {//Jcc
  7462                                  
  7463                                  .process281:
  7464 00002731 A0[3000]                 mov al, [CodeType]
  7465 00002734 3C06                     cmp al, 6
  7466 00002736 0F85BE00                 jne .process300
  7467                                  
  7468                                  ;-171         if (TokeType == ALNUME) {
  7469                                  
  7470 0000273A A0[2D00]                 mov al, [TokeType]
  7471 0000273D 3C03                     cmp al, 3
  7472 0000273F 0F85B500                 jne .process301
  7473                                  
  7474                                  ;-172             LabelIx=searchLabel();
  7475                                  
  7476 00002743 E8D5E4                   call searchLabel
  7477 00002746 A3[4B00]                 mov word [LabelIx], ax
  7478                                  
  7479                                  ;-173             if (LabelIx > 0) {
  7480                                  
  7481 00002749 A1[4B00]                 mov ax, [LabelIx]
  7482 0000274C 83F800                   cmp ax, 0
  7483 0000274F 0F8E7A00                 jle .process302
  7484                                  
  7485                                  ;-174                 disp=LabelAddr[LabelIx];
  7486                                  
  7487 00002753 8B1E[4B00]               mov bx, [LabelIx]
  7488 00002757 D1E3                     shl bx, 1
  7489 00002759 8B87FA86                 mov ax, [LabelAddr + bx]
  7490 0000275D A3[3E00]                 mov word [disp], ax
  7491                                  
  7492                                  ;-175                 disp = disp - PC;
  7493                                  
  7494 00002760 A1[3E00]                 mov ax, [disp]
  7495 00002763 2B06[2400]               sub ax, [PC]
  7496 00002767 A3[3E00]                 mov word [disp], ax
  7497                                  
  7498                                  ;-176                 disp = disp - Origin;
  7499                                  
  7500 0000276A A1[3E00]                 mov ax, [disp]
  7501 0000276D 2B06[2600]               sub ax, [Origin]
  7502 00002771 A3[3E00]                 mov word [disp], ax
  7503                                  
  7504                                  ;-177                 if (checkConstSize(disp) ) {
  7505                                  
  7506 00002774 FF36[3E00]               push word [disp]
  7507 00002778 E8A3E1                   call checkConstSize
  7508 0000277B 83C402                   add  sp, 2
  7509 0000277E 08C0                     or  al, al
  7510 00002780 0F842000                 je .process303
  7511                                  
  7512                                  ;-178                     genCode2(Code1, 0x70);//short
  7513                                  
  7514 00002784 6A70                     push 112
  7515 00002786 A0[3100]                 mov al, byte [Code1]
  7516 00002789 B400                     mov ah, 0
  7517 0000278B 50                       push ax
  7518 0000278C E8EEF9                   call genCode2
  7519 0000278F 83C404                   add  sp, 4
  7520                                  
  7521                                  ;-179                     disp -= 2;
  7522                                  
  7523 00002792 832E[3E00]02             sub  word[disp], 2
  7524                                  
  7525                                  ;-180                     genCode8(disp);
  7526                                  
  7527 00002797 FF36[3E00]               push word [disp]
  7528 0000279B E816FA                   call genCode8
  7529 0000279E 83C402                   add  sp, 2
  7530                                  
  7531                                  ;-181                 } else {
  7532                                  
  7533 000027A1 E92600                   jmp .process304
  7534                                  .process303:
  7535                                  
  7536                                  ;-182                     genCode8(0x0F);
  7537                                  
  7538 000027A4 6A0F                     push 15
  7539 000027A6 E80BFA                   call genCode8
  7540 000027A9 83C402                   add  sp, 2
  7541                                  
  7542                                  ;-183                     genCode2(Code1, 0x80);//near
  7543                                  
  7544 000027AC 688000                   push 128
  7545 000027AF A0[3100]                 mov al, byte [Code1]
  7546 000027B2 B400                     mov ah, 0
  7547 000027B4 50                       push ax
  7548 000027B5 E8C5F9                   call genCode2
  7549 000027B8 83C404                   add  sp, 4
  7550                                  
  7551                                  ;-184                     disp -= 4;
  7552                                  
  7553 000027BB 832E[3E00]04             sub  word[disp], 4
  7554                                  
  7555                                  ;-185                     genCode16(disp);
  7556                                  
  7557 000027C0 FF36[3E00]               push word [disp]
  7558 000027C4 E844FA                   call genCode16
  7559 000027C7 83C402                   add  sp, 2
  7560                                  
  7561                                  ;-186                 }
  7562                                  
  7563                                  
  7564                                  ;-187             }
  7565                                  
  7566                                  .process304:
  7567                                  
  7568                                  ;-188             else {//jump forward, near only
  7569                                  
  7570 000027CA E92800                   jmp .process305
  7571                                  .process302:
  7572                                  
  7573                                  ;-189                 genCode8(0x0F);
  7574                                  
  7575 000027CD 6A0F                     push 15
  7576 000027CF E8E2F9                   call genCode8
  7577 000027D2 83C402                   add  sp, 2
  7578                                  
  7579                                  ;-190                 genCode2(Code1, 0x80);
  7580                                  
  7581 000027D5 688000                   push 128
  7582 000027D8 A0[3100]                 mov al, byte [Code1]
  7583 000027DB B400                     mov ah, 0
  7584 000027DD 50                       push ax
  7585 000027DE E89CF9                   call genCode2
  7586 000027E1 83C404                   add  sp, 4
  7587                                  
  7588                                  ;-191                 genCode16(0);
  7589                                  
  7590 000027E4 6A00                     push 0
  7591 000027E6 E822FA                   call genCode16
  7592 000027E9 83C402                   add  sp, 2
  7593                                  
  7594                                  ;-192                 PrintRA='*';
  7595                                  
  7596 000027EC B82A00                   mov ax, 42
  7597 000027EF A2[4600]                 mov byte [PrintRA], al
  7598                                  
  7599                                  ;-193                 storeJmpCall();
  7600                                  
  7601 000027F2 E8FAE2                   call storeJmpCall
  7602                                  
  7603                                  ;-194             }
  7604                                  
  7605                                  
  7606                                  ;-195         return;
  7607                                  
  7608                                  .process305:
  7609 000027F5 E9F203                   jmp .retnprocess
  7610                                  
  7611                                  ;-196         }
  7612                                  
  7613                                  
  7614                                  ;-197     }
  7615                                  
  7616                                  .process301:
  7617                                  
  7618                                  ;-198 
  7619                                  
  7620                                  
  7621                                  ;-199     if (CodeType == 7) {//jmp, call
  7622                                  
  7623                                  .process300:
  7624 000027F8 A0[3000]                 mov al, [CodeType]
  7625 000027FB 3C07                     cmp al, 7
  7626 000027FD 0F85CA00                 jne .process306
  7627                                  
  7628                                  ;-200         if (TokeType == ALNUME) {
  7629                                  
  7630 00002801 A0[2D00]                 mov al, [TokeType]
  7631 00002804 3C03                     cmp al, 3
  7632 00002806 0F85C100                 jne .process307
  7633                                  
  7634                                  ;-201             LabelIx=searchLabel();
  7635                                  
  7636 0000280A E80EE4                   call searchLabel
  7637 0000280D A3[4B00]                 mov word [LabelIx], ax
  7638                                  
  7639                                  ;-202             if (LabelIx > 0) {
  7640                                  
  7641 00002810 A1[4B00]                 mov ax, [LabelIx]
  7642 00002813 83F800                   cmp ax, 0
  7643 00002816 0F8E9100                 jle .process308
  7644                                  
  7645                                  ;-203                 disp=LabelAddr[LabelIx];
  7646                                  
  7647 0000281A 8B1E[4B00]               mov bx, [LabelIx]
  7648 0000281E D1E3                     shl bx, 1
  7649 00002820 8B87FA86                 mov ax, [LabelAddr + bx]
  7650 00002824 A3[3E00]                 mov word [disp], ax
  7651                                  
  7652                                  ;-204                 disp = disp - PC;
  7653                                  
  7654 00002827 A1[3E00]                 mov ax, [disp]
  7655 0000282A 2B06[2400]               sub ax, [PC]
  7656 0000282E A3[3E00]                 mov word [disp], ax
  7657                                  
  7658                                  ;-205                 disp = disp - Origin;
  7659                                  
  7660 00002831 A1[3E00]                 mov ax, [disp]
  7661 00002834 2B06[2600]               sub ax, [Origin]
  7662 00002838 A3[3E00]                 mov word [disp], ax
  7663                                  
  7664                                  ;-206                 if (checkConstSize(disp) ) {
  7665                                  
  7666 0000283B FF36[3E00]               push word [disp]
  7667 0000283F E8DCE0                   call checkConstSize
  7668 00002842 83C402                   add  sp, 2
  7669 00002845 08C0                     or  al, al
  7670 00002847 0F844200                 je .process309
  7671                                  
  7672                                  ;-207                     if (Code1 == 0xE9) {//jmp only
  7673                                  
  7674 0000284B A0[3100]                 mov al, [Code1]
  7675 0000284E 3CE9                     cmp al, 233
  7676 00002850 0F851B00                 jne .process310
  7677                                  
  7678                                  ;-208                         genCode8(0xEB);//short
  7679                                  
  7680 00002854 68EB00                   push 235
  7681 00002857 E85AF9                   call genCode8
  7682 0000285A 83C402                   add  sp, 2
  7683                                  
  7684                                  ;-209                         disp -= 2;
  7685                                  
  7686 0000285D 832E[3E00]02             sub  word[disp], 2
  7687                                  
  7688                                  ;-210                         genCode8(disp);
  7689                                  
  7690 00002862 FF36[3E00]               push word [disp]
  7691 00002866 E84BF9                   call genCode8
  7692 00002869 83C402                   add  sp, 2
  7693                                  
  7694                                  ;-211                     }
  7695                                  
  7696                                  
  7697                                  ;-212                     else {
  7698                                  
  7699 0000286C E91B00                   jmp .process311
  7700                                  .process310:
  7701                                  
  7702                                  ;-213                         genCode8(Code1);//near
  7703                                  
  7704 0000286F A0[3100]                 mov al, byte [Code1]
  7705 00002872 B400                     mov ah, 0
  7706 00002874 50                       push ax
  7707 00002875 E83CF9                   call genCode8
  7708 00002878 83C402                   add  sp, 2
  7709                                  
  7710                                  ;-214                         disp -= 3;
  7711                                  
  7712 0000287B 832E[3E00]03             sub  word[disp], 3
  7713                                  
  7714                                  ;-215                         genCode16(disp);
  7715                                  
  7716 00002880 FF36[3E00]               push word [disp]
  7717 00002884 E884F9                   call genCode16
  7718 00002887 83C402                   add  sp, 2
  7719                                  
  7720                                  ;-216                     }
  7721                                  
  7722                                  
  7723                                  ;-217                 }
  7724                                  
  7725                                  .process311:
  7726                                  
  7727                                  ;-218                 else {
  7728                                  
  7729 0000288A E91B00                   jmp .process312
  7730                                  .process309:
  7731                                  
  7732                                  ;-219                     genCode8(Code1);//near
  7733                                  
  7734 0000288D A0[3100]                 mov al, byte [Code1]
  7735 00002890 B400                     mov ah, 0
  7736 00002892 50                       push ax
  7737 00002893 E81EF9                   call genCode8
  7738 00002896 83C402                   add  sp, 2
  7739                                  
  7740                                  ;-220                     disp -= 3;
  7741                                  
  7742 00002899 832E[3E00]03             sub  word[disp], 3
  7743                                  
  7744                                  ;-221                     genCode16(disp);
  7745                                  
  7746 0000289E FF36[3E00]               push word [disp]
  7747 000028A2 E866F9                   call genCode16
  7748 000028A5 83C402                   add  sp, 2
  7749                                  
  7750                                  ;-222                 }
  7751                                  
  7752                                  
  7753                                  ;-223             }
  7754                                  
  7755                                  .process312:
  7756                                  
  7757                                  ;-224             else {//jump forward, near only
  7758                                  
  7759 000028A8 E91D00                   jmp .process313
  7760                                  .process308:
  7761                                  
  7762                                  ;-225                 genCode8(Code1);
  7763                                  
  7764 000028AB A0[3100]                 mov al, byte [Code1]
  7765 000028AE B400                     mov ah, 0
  7766 000028B0 50                       push ax
  7767 000028B1 E800F9                   call genCode8
  7768 000028B4 83C402                   add  sp, 2
  7769                                  
  7770                                  ;-226                 genCode16(0);
  7771                                  
  7772 000028B7 6A00                     push 0
  7773 000028B9 E84FF9                   call genCode16
  7774 000028BC 83C402                   add  sp, 2
  7775                                  
  7776                                  ;-227                 PrintRA='*';
  7777                                  
  7778 000028BF B82A00                   mov ax, 42
  7779 000028C2 A2[4600]                 mov byte [PrintRA], al
  7780                                  
  7781                                  ;-228                 storeJmpCall();
  7782                                  
  7783 000028C5 E827E2                   call storeJmpCall
  7784                                  
  7785                                  ;-229             }
  7786                                  
  7787                                  
  7788                                  ;-230         return;
  7789                                  
  7790                                  .process313:
  7791 000028C8 E91F03                   jmp .retnprocess
  7792                                  
  7793                                  ;-231         }
  7794                                  
  7795                                  
  7796                                  ;-232     }
  7797                                  
  7798                                  .process307:
  7799                                  
  7800                                  ;-233 
  7801                                  
  7802                                  
  7803                                  ;-234     if (CodeType ==  8) {//ret,retf
  7804                                  
  7805                                  .process306:
  7806 000028CB A0[3000]                 mov al, [CodeType]
  7807 000028CE 3C08                     cmp al, 8
  7808 000028D0 0F853100                 jne .process314
  7809                                  
  7810                                  ;-235         if (TokeType == DIGIT) {
  7811                                  
  7812 000028D4 A0[2D00]                 mov al, [TokeType]
  7813 000028D7 3C01                     cmp al, 1
  7814 000028D9 0F851900                 jne .process315
  7815                                  
  7816                                  ;-236             genCode8(Code2);
  7817                                  
  7818 000028DD A0[3200]                 mov al, byte [Code2]
  7819 000028E0 B400                     mov ah, 0
  7820 000028E2 50                       push ax
  7821 000028E3 E8CEF8                   call genCode8
  7822 000028E6 83C402                   add  sp, 2
  7823                                  
  7824                                  ;-237             genCode16(SymbolInt);
  7825                                  
  7826 000028E9 FF36[0F00]               push word [SymbolInt]
  7827 000028ED E81BF9                   call genCode16
  7828 000028F0 83C402                   add  sp, 2
  7829                                  
  7830                                  ;-238             return;
  7831                                  
  7832 000028F3 E9F402                   jmp .retnprocess
  7833                                  
  7834                                  ;-239         }
  7835                                  
  7836                                  
  7837                                  ;-240         genCode8(Code1);
  7838                                  
  7839                                  .process315:
  7840 000028F6 A0[3100]                 mov al, byte [Code1]
  7841 000028F9 B400                     mov ah, 0
  7842 000028FB 50                       push ax
  7843 000028FC E8B5F8                   call genCode8
  7844 000028FF 83C402                   add  sp, 2
  7845                                  
  7846                                  ;-241         return;
  7847                                  
  7848 00002902 E9E502                   jmp .retnprocess
  7849                                  
  7850                                  ;-242     }
  7851                                  
  7852                                  
  7853                                  ;-243 
  7854                                  
  7855                                  
  7856                                  ;-244     if (CodeType == 9) {//push, pop
  7857                                  
  7858                                  .process314:
  7859 00002905 A0[3000]                 mov al, [CodeType]
  7860 00002908 3C09                     cmp al, 9
  7861 0000290A 0F850301                 jne .process316
  7862                                  
  7863                                  ;-245         getOpL();
  7864                                  
  7865 0000290E E877DC                   call getOpL
  7866                                  
  7867                                  ;-246         if (Code1 == 0x50) {//push only
  7868                                  
  7869 00002911 A0[3100]                 mov al, [Code1]
  7870 00002914 3C50                     cmp al, 80
  7871 00002916 0F853D00                 jne .process317
  7872                                  
  7873                                  ;-247             if (Op == IMM) {//push imm8,16
  7874                                  
  7875 0000291A A0[2E00]                 mov al, [Op]
  7876 0000291D 3C01                     cmp al, 1
  7877 0000291F 0F853400                 jne .process318
  7878                                  
  7879                                  ;-248                 setsflag();
  7880                                  
  7881 00002923 E89CDF                   call setsflag
  7882                                  
  7883                                  ;-249                 genCode2(0x68, sflag);
  7884                                  
  7885 00002926 A0[3B00]                 mov al, byte [sflag]
  7886 00002929 B400                     mov ah, 0
  7887 0000292B 50                       push ax
  7888 0000292C 6A68                     push 104
  7889 0000292E E84CF8                   call genCode2
  7890 00002931 83C404                   add  sp, 4
  7891                                  
  7892                                  ;-250                 if (sflag) genCode8 (imme);
  7893                                  
  7894 00002934 A0[3B00]                 mov al, [sflag]
  7895 00002937 08C0                     or  al, al
  7896 00002939 0F840D00                 je .process319
  7897 0000293D FF36[4000]               push word [imme]
  7898 00002941 E870F8                   call genCode8
  7899 00002944 83C402                   add  sp, 2
  7900                                  
  7901                                  ;-251                 else       genCode16(imme);
  7902                                  
  7903 00002947 E90A00                   jmp .process320
  7904                                  .process319:
  7905 0000294A FF36[4000]               push word [imme]
  7906 0000294E E8BAF8                   call genCode16
  7907 00002951 83C402                   add  sp, 2
  7908                                  
  7909                                  ;-252                 return;
  7910                                  
  7911                                  .process320:
  7912 00002954 E99302                   jmp .retnprocess
  7913                                  
  7914                                  ;-253             }
  7915                                  
  7916                                  
  7917                                  ;-254         }
  7918                                  
  7919                                  .process318:
  7920                                  
  7921                                  ;-255         if (R1Type == SEGREG) {
  7922                                  
  7923                                  .process317:
  7924 00002957 A0[3700]                 mov al, [R1Type]
  7925 0000295A 3C04                     cmp al, 4
  7926 0000295C 0F855A00                 jne .process321
  7927                                  
  7928                                  ;-256             if (Code1 == 0x58) {
  7929                                  
  7930 00002960 A0[3100]                 mov al, [Code1]
  7931 00002963 3C58                     cmp al, 88
  7932 00002965 0F851200                 jne .process322
  7933                                  
  7934                                  ;-257                 if (R1No == 1) error1("pop cs not allowed");
  7935                                  
  7936 00002969 A0[3500]                 mov al, [R1No]
  7937 0000296C 3C01                     cmp al, 1
  7938 0000296E 0F850900                 jne .process323
  7939 00002972 68[EC2B]                 push process_0
  7940 00002975 E832F1                   call error1
  7941 00002978 83C402                   add  sp, 2
  7942                                  
  7943                                  ;-258             }
  7944                                  
  7945                                  .process323:
  7946                                  
  7947                                  ;-259             c = R1No <<3;
  7948                                  
  7949                                  .process322:
  7950 0000297B A0[3500]                 mov al, [R1No]
  7951 0000297E C0E003                   shl al, 3
  7952 00002981 8846FE                   mov [bp-2], al
  7953                                  
  7954                                  ;-260             if (R1No > 3) {//FS, GS
  7955                                  
  7956 00002984 A0[3500]                 mov al, [R1No]
  7957 00002987 3C03                     cmp al, 3
  7958 00002989 0F8E0C00                 jle .process324
  7959                                  
  7960                                  ;-261                 c += 122;
  7961                                  
  7962 0000298D 8046FE7A                 add  byte[bp-2], 122
  7963                                  
  7964                                  ;-262                 genCode8(0x0F);
  7965                                  
  7966 00002991 6A0F                     push 15
  7967 00002993 E81EF8                   call genCode8
  7968 00002996 83C402                   add  sp, 2
  7969                                  
  7970                                  ;-263             }
  7971                                  
  7972                                  
  7973                                  ;-264             OpCodePtr++;
  7974                                  
  7975                                  .process324:
  7976 00002999 FF06[4400]               inc  word[OpCodePtr]
  7977                                  
  7978                                  ;-265             c = c + *OpCodePtr;//is Code4
  7979                                  
  7980 0000299D 8A46FE                   mov al, [bp-2]
  7981 000029A0 8B1E[4400]               mov bx, [OpCodePtr]
  7982 000029A4 0207                     add al, [bx]
  7983 000029A6 B400                     mov ah, 0
  7984 000029A8 8846FE                   mov [bp-2], al
  7985                                  
  7986                                  ;-266             genCode8(c);
  7987                                  
  7988 000029AB 8A46FE                   mov al, byte [bp-2]
  7989 000029AE B400                     mov ah, 0
  7990 000029B0 50                       push ax
  7991 000029B1 E800F8                   call genCode8
  7992 000029B4 83C402                   add  sp, 2
  7993                                  
  7994                                  ;-267             return;
  7995                                  
  7996 000029B7 E93002                   jmp .retnprocess
  7997                                  
  7998                                  ;-268         }
  7999                                  
  8000                                  
  8001                                  ;-269         checkOpL();
  8002                                  
  8003                                  .process321:
  8004 000029BA E8EEDA                   call checkOpL
  8005                                  
  8006                                  ;-270         if (R1Type == BYTE) reg16error();
  8007                                  
  8008 000029BD A0[3700]                 mov al, [R1Type]
  8009 000029C0 3C01                     cmp al, 1
  8010 000029C2 0F850300                 jne .process325
  8011 000029C6 E851F2                   call reg16error
  8012                                  
  8013                                  ;-271         if (R1Type == WORD) {
  8014                                  
  8015                                  .process325:
  8016 000029C9 A0[3700]                 mov al, [R1Type]
  8017 000029CC 3C02                     cmp al, 2
  8018 000029CE 0F851500                 jne .process326
  8019                                  
  8020                                  ;-272             genCode2(Code1, R1No);
  8021                                  
  8022 000029D2 A0[3500]                 mov al, byte [R1No]
  8023 000029D5 B400                     mov ah, 0
  8024 000029D7 50                       push ax
  8025 000029D8 A0[3100]                 mov al, byte [Code1]
  8026 000029DB B400                     mov ah, 0
  8027 000029DD 50                       push ax
  8028 000029DE E89CF7                   call genCode2
  8029 000029E1 83C404                   add  sp, 4
  8030                                  
  8031                                  ;-273             return;
  8032                                  
  8033 000029E4 E90302                   jmp .retnprocess
  8034                                  
  8035                                  ;-274         }
  8036                                  
  8037                                  
  8038                                  ;-275         if (Op == MEM) {
  8039                                  
  8040                                  .process326:
  8041 000029E7 A0[2E00]                 mov al, [Op]
  8042 000029EA 3C04                     cmp al, 4
  8043 000029EC 0F851B00                 jne .process327
  8044                                  
  8045                                  ;-276             genCode8(Code2);
  8046                                  
  8047 000029F0 A0[3200]                 mov al, byte [Code2]
  8048 000029F3 B400                     mov ah, 0
  8049 000029F5 50                       push ax
  8050 000029F6 E8BBF7                   call genCode8
  8051 000029F9 83C402                   add  sp, 2
  8052                                  
  8053                                  ;-277             writeEA(Code3);
  8054                                  
  8055 000029FC A0[3300]                 mov al, byte [Code3]
  8056 000029FF B400                     mov ah, 0
  8057 00002A01 50                       push ax
  8058 00002A02 E851F8                   call writeEA
  8059 00002A05 83C402                   add  sp, 2
  8060                                  
  8061                                  ;-278             return;
  8062                                  
  8063 00002A08 E9DF01                   jmp .retnprocess
  8064                                  
  8065                                  ;-279         }
  8066                                  
  8067                                  
  8068                                  ;-280         syntaxerror();
  8069                                  
  8070                                  .process327:
  8071 00002A0B E85BF2                   call syntaxerror
  8072                                  
  8073                                  ;-281         return;
  8074                                  
  8075 00002A0E E9D901                   jmp .retnprocess
  8076                                  
  8077                                  ;-282     }
  8078                                  
  8079                                  
  8080                                  ;-283 
  8081                                  
  8082                                  
  8083                                  ;-284     if (CodeType == 11) {//shift, rotate
  8084                                  
  8085                                  .process316:
  8086 00002A11 A0[3000]                 mov al, [CodeType]
  8087 00002A14 3C0B                     cmp al, 11
  8088 00002A16 0F859200                 jne .process328
  8089                                  
  8090                                  ;-285         check2Ops();
  8091                                  
  8092 00002A1A E810DB                   call check2Ops
  8093                                  
  8094                                  ;-286         if (Op2 == IMM) {
  8095                                  
  8096 00002A1D A0[2F00]                 mov al, [Op2]
  8097 00002A20 3C01                     cmp al, 1
  8098 00002A22 0F854400                 jne .process329
  8099                                  
  8100                                  ;-287             if (imme == 1) {
  8101                                  
  8102 00002A26 A1[4000]                 mov ax, [imme]
  8103 00002A29 83F801                   cmp ax, 1
  8104 00002A2C 0F851800                 jne .process330
  8105                                  
  8106                                  ;-288                 genCodeW(0xD0);
  8107                                  
  8108 00002A30 68D000                   push 208
  8109 00002A33 E862F7                   call genCodeW
  8110 00002A36 83C402                   add  sp, 2
  8111                                  
  8112                                  ;-289                 writeEA(Code1);
  8113                                  
  8114 00002A39 A0[3100]                 mov al, byte [Code1]
  8115 00002A3C B400                     mov ah, 0
  8116 00002A3E 50                       push ax
  8117 00002A3F E814F8                   call writeEA
  8118 00002A42 83C402                   add  sp, 2
  8119                                  
  8120                                  ;-290                 return;
  8121                                  
  8122 00002A45 E9A201                   jmp .retnprocess
  8123                                  
  8124                                  ;-291             }
  8125                                  
  8126                                  
  8127                                  ;-292             genCodeW(0xC0);//80186
  8128                                  
  8129                                  .process330:
  8130 00002A48 68C000                   push 192
  8131 00002A4B E84AF7                   call genCodeW
  8132 00002A4E 83C402                   add  sp, 2
  8133                                  
  8134                                  ;-293             writeEA(Code1);
  8135                                  
  8136 00002A51 A0[3100]                 mov al, byte [Code1]
  8137 00002A54 B400                     mov ah, 0
  8138 00002A56 50                       push ax
  8139 00002A57 E8FCF7                   call writeEA
  8140 00002A5A 83C402                   add  sp, 2
  8141                                  
  8142                                  ;-294             genCode8(imme);
  8143                                  
  8144 00002A5D FF36[4000]               push word [imme]
  8145 00002A61 E850F7                   call genCode8
  8146 00002A64 83C402                   add  sp, 2
  8147                                  
  8148                                  ;-295             return;
  8149                                  
  8150 00002A67 E98001                   jmp .retnprocess
  8151                                  
  8152                                  ;-296         }
  8153                                  
  8154                                  
  8155                                  ;-297         if (Op2 == REG) {
  8156                                  
  8157                                  .process329:
  8158 00002A6A A0[2F00]                 mov al, [Op2]
  8159 00002A6D 3C02                     cmp al, 2
  8160 00002A6F 0F853900                 jne .process331
  8161                                  
  8162                                  ;-298             if (R2Type == BYTE) {
  8163                                  
  8164 00002A73 A0[3600]                 mov al, [R2Type]
  8165 00002A76 3C01                     cmp al, 1
  8166 00002A78 0F853000                 jne .process332
  8167                                  
  8168                                  ;-299                 if (R2No == 1) {//CL-REG
  8169                                  
  8170 00002A7C A0[3400]                 mov al, [R2No]
  8171 00002A7F 3C01                     cmp al, 1
  8172 00002A81 0F852700                 jne .process333
  8173                                  
  8174                                  ;-300                     if (R1Type == WORD) wflag=1;//hack
  8175                                  
  8176 00002A85 A0[3700]                 mov al, [R1Type]
  8177 00002A88 3C02                     cmp al, 2
  8178 00002A8A 0F850600                 jne .process334
  8179 00002A8E B80100                   mov ax, 1
  8180 00002A91 A2[3900]                 mov byte [wflag], al
  8181                                  
  8182                                  ;-301                     genCodeW(0xD2);
  8183                                  
  8184                                  .process334:
  8185 00002A94 68D200                   push 210
  8186 00002A97 E8FEF6                   call genCodeW
  8187 00002A9A 83C402                   add  sp, 2
  8188                                  
  8189                                  ;-302                     writeEA(Code1);
  8190                                  
  8191 00002A9D A0[3100]                 mov al, byte [Code1]
  8192 00002AA0 B400                     mov ah, 0
  8193 00002AA2 50                       push ax
  8194 00002AA3 E8B0F7                   call writeEA
  8195 00002AA6 83C402                   add  sp, 2
  8196                                  
  8197                                  ;-303                     return;
  8198                                  
  8199 00002AA9 E93E01                   jmp .retnprocess
  8200                                  
  8201                                  ;-304                 }
  8202                                  
  8203                                  
  8204                                  ;-305             }
  8205                                  
  8206                                  .process333:
  8207                                  
  8208                                  ;-306         }
  8209                                  
  8210                                  .process332:
  8211                                  
  8212                                  ;-307     }
  8213                                  
  8214                                  .process331:
  8215                                  
  8216                                  ;-308 
  8217                                  
  8218                                  
  8219                                  ;-309     if (CodeType == 12) {//int
  8220                                  
  8221                                  .process328:
  8222 00002AAC A0[3000]                 mov al, [CodeType]
  8223 00002AAF 3C0C                     cmp al, 12
  8224 00002AB1 0F852200                 jne .process335
  8225                                  
  8226                                  ;-310         if (TokeType == DIGIT) {
  8227                                  
  8228 00002AB5 A0[2D00]                 mov al, [TokeType]
  8229 00002AB8 3C01                     cmp al, 1
  8230 00002ABA 0F851900                 jne .process336
  8231                                  
  8232                                  ;-311             genCode8(Code1);
  8233                                  
  8234 00002ABE A0[3100]                 mov al, byte [Code1]
  8235 00002AC1 B400                     mov ah, 0
  8236 00002AC3 50                       push ax
  8237 00002AC4 E8EDF6                   call genCode8
  8238 00002AC7 83C402                   add  sp, 2
  8239                                  
  8240                                  ;-312             genCode8(SymbolInt);
  8241                                  
  8242 00002ACA FF36[0F00]               push word [SymbolInt]
  8243 00002ACE E8E3F6                   call genCode8
  8244 00002AD1 83C402                   add  sp, 2
  8245                                  
  8246                                  ;-313             return;
  8247                                  
  8248 00002AD4 E91301                   jmp .retnprocess
  8249                                  
  8250                                  ;-314         }
  8251                                  
  8252                                  
  8253                                  ;-315     }
  8254                                  
  8255                                  .process336:
  8256                                  
  8257                                  ;-316 
  8258                                  
  8259                                  
  8260                                  ;-317     if (CodeType == 30) {//enter i18,i8
  8261                                  
  8262                                  .process335:
  8263 00002AD7 A0[3000]                 mov al, [CodeType]
  8264 00002ADA 3C1E                     cmp al, 30
  8265 00002ADC 0F855200                 jne .process337
  8266                                  
  8267                                  ;-318         genCode8(0xC8);
  8268                                  
  8269 00002AE0 68C800                   push 200
  8270 00002AE3 E8CEF6                   call genCode8
  8271 00002AE6 83C402                   add  sp, 2
  8272                                  
  8273                                  ;-319         Op=getOp1();
  8274                                  
  8275 00002AE9 E84DDB                   call getOp1
  8276 00002AEC A2[2E00]                 mov byte [Op], al
  8277                                  
  8278                                  ;-320         if (Op == IMM) genCode16(SymbolInt);
  8279                                  
  8280 00002AEF A0[2E00]                 mov al, [Op]
  8281 00002AF2 3C01                     cmp al, 1
  8282 00002AF4 0F850D00                 jne .process338
  8283 00002AF8 FF36[0F00]               push word [SymbolInt]
  8284 00002AFC E80CF7                   call genCode16
  8285 00002AFF 83C402                   add  sp, 2
  8286                                  
  8287                                  ;-321         else numbererror();
  8288                                  
  8289 00002B02 E90300                   jmp .process339
  8290                                  .process338:
  8291 00002B05 E8CEF0                   call numbererror
  8292                                  
  8293                                  ;-322         need(',');
  8294                                  
  8295                                  .process339:
  8296 00002B08 6A2C                     push 44
  8297 00002B0A E811E4                   call need
  8298 00002B0D 83C402                   add  sp, 2
  8299                                  
  8300                                  ;-323         Op=getOp1();
  8301                                  
  8302 00002B10 E826DB                   call getOp1
  8303 00002B13 A2[2E00]                 mov byte [Op], al
  8304                                  
  8305                                  ;-324         if (Op == IMM) genCode8 (SymbolInt);
  8306                                  
  8307 00002B16 A0[2E00]                 mov al, [Op]
  8308 00002B19 3C01                     cmp al, 1
  8309 00002B1B 0F850D00                 jne .process340
  8310 00002B1F FF36[0F00]               push word [SymbolInt]
  8311 00002B23 E88EF6                   call genCode8
  8312 00002B26 83C402                   add  sp, 2
  8313                                  
  8314                                  ;-325         else numbererror();
  8315                                  
  8316 00002B29 E90300                   jmp .process341
  8317                                  .process340:
  8318 00002B2C E8A7F0                   call numbererror
  8319                                  
  8320                                  ;-326         return;
  8321                                  
  8322                                  .process341:
  8323 00002B2F E9B800                   jmp .retnprocess
  8324                                  
  8325                                  ;-327     }
  8326                                  
  8327                                  
  8328                                  ;-328 
  8329                                  
  8330                                  
  8331                                  ;-329     if (CodeType==101) {//ORG nn
  8332                                  
  8333                                  .process337:
  8334 00002B32 A0[3000]                 mov al, [CodeType]
  8335 00002B35 3C65                     cmp al, 101
  8336 00002B37 0F851500                 jne .process342
  8337                                  
  8338                                  ;-330         if (TokeType != DIGIT) numbererror();
  8339                                  
  8340 00002B3B A0[2D00]                 mov al, [TokeType]
  8341 00002B3E 3C01                     cmp al, 1
  8342 00002B40 0F840300                 je  .process343
  8343 00002B44 E88FF0                   call numbererror
  8344                                  
  8345                                  ;-331         Origin=SymbolInt;
  8346                                  
  8347                                  .process343:
  8348 00002B47 A1[0F00]                 mov ax, [SymbolInt]
  8349 00002B4A A3[2600]                 mov word [Origin], ax
  8350                                  
  8351                                  ;-332         return;
  8352                                  
  8353 00002B4D E99A00                   jmp .retnprocess
  8354                                  
  8355                                  ;-333     }
  8356                                  
  8357                                  
  8358                                  ;-334 
  8359                                  
  8360                                  
  8361                                  ;-335     if (CodeType == 102) {//section, segment
  8362                                  
  8363                                  .process342:
  8364 00002B50 A0[3000]                 mov al, [CodeType]
  8365 00002B53 3C66                     cmp al, 102
  8366 00002B55 0F850900                 jne .process344
  8367                                  
  8368                                  ;-336         //getTokeType();//ignore .bss .text .data
  8369                                  
  8370                                  
  8371                                  ;-337         AbsoluteLab=0;//nasm resets erevy time
  8372                                  
  8373 00002B59 B80000                   mov ax, 0
  8374 00002B5C A3[2800]                 mov word [AbsoluteLab], ax
  8375                                  
  8376                                  ;-338         return;
  8377                                  
  8378 00002B5F E98800                   jmp .retnprocess
  8379                                  
  8380                                  ;-339     }
  8381                                  
  8382                                  
  8383                                  ;-340 
  8384                                  
  8385                                  
  8386                                  ;-341     if (CodeType == 110) {//absolute
  8387                                  
  8388                                  .process344:
  8389 00002B62 A0[3000]                 mov al, [CodeType]
  8390 00002B65 3C6E                     cmp al, 110
  8391 00002B67 0F851500                 jne .process345
  8392                                  
  8393                                  ;-342         if (TokeType != DIGIT) numbererror();
  8394                                  
  8395 00002B6B A0[2D00]                 mov al, [TokeType]
  8396 00002B6E 3C01                     cmp al, 1
  8397 00002B70 0F840300                 je  .process346
  8398 00002B74 E85FF0                   call numbererror
  8399                                  
  8400                                  ;-343         AbsoluteLab=SymbolInt;
  8401                                  
  8402                                  .process346:
  8403 00002B77 A1[0F00]                 mov ax, [SymbolInt]
  8404 00002B7A A3[2800]                 mov word [AbsoluteLab], ax
  8405                                  
  8406                                  ;-344         return;
  8407                                  
  8408 00002B7D E96A00                   jmp .retnprocess
  8409                                  
  8410                                  ;-345     }
  8411                                  
  8412                                  
  8413                                  ;-346     if (CodeType == 111) {//name: PROC
  8414                                  
  8415                                  .process345:
  8416 00002B80 A0[3000]                 mov al, [CodeType]
  8417 00002B83 3C6F                     cmp al, 111
  8418 00002B85 0F853200                 jne .process347
  8419                                  
  8420                                  ;-347         if (isInProc == 0)  {
  8421                                  
  8422 00002B89 A0[0E00]                 mov al, [isInProc]
  8423 00002B8C 3C00                     cmp al, 0
  8424 00002B8E 0F851D00                 jne .process348
  8425                                  
  8426                                  ;-348           prs("\n;entering: ");
  8427                                  
  8428 00002B92 68[FF2B]                 push process_1
  8429 00002B95 E8C0ED                   call prs
  8430 00002B98 83C402                   add  sp, 2
  8431                                  
  8432                                  ;-349           prs(ProcName);
  8433                                  
  8434 00002B9B 8D066E75                 lea  ax, [ProcName]
  8435 00002B9F 50                       push ax
  8436 00002BA0 E8B5ED                   call prs
  8437 00002BA3 83C402                   add  sp, 2
  8438                                  
  8439                                  ;-350           isInProc=1;
  8440                                  
  8441 00002BA6 B80100                   mov ax, 1
  8442 00002BA9 A2[0E00]                 mov byte [isInProc], al
  8443                                  
  8444                                  ;-351         } else error1("already in proc");
  8445                                  
  8446 00002BAC E90900                   jmp .process349
  8447                                  .process348:
  8448 00002BAF 68[0D2C]                 push process_2
  8449 00002BB2 E8F5EE                   call error1
  8450 00002BB5 83C402                   add  sp, 2
  8451                                  
  8452                                  ;-352         return;
  8453                                  
  8454                                  .process349:
  8455 00002BB8 E92F00                   jmp .retnprocess
  8456                                  
  8457                                  ;-353     }
  8458                                  
  8459                                  
  8460                                  ;-354     if (CodeType == 112) {//ENDP
  8461                                  
  8462                                  .process347:
  8463 00002BBB A0[3000]                 mov al, [CodeType]
  8464 00002BBE 3C70                     cmp al, 112
  8465 00002BC0 0F851D00                 jne .process350
  8466                                  
  8467                                  ;-355       prs("\n;leaving: ");
  8468                                  
  8469 00002BC4 68[1D2C]                 push process_3
  8470 00002BC7 E88EED                   call prs
  8471 00002BCA 83C402                   add  sp, 2
  8472                                  
  8473                                  ;-356       prs(ProcName);
  8474                                  
  8475 00002BCD 8D066E75                 lea  ax, [ProcName]
  8476 00002BD1 50                       push ax
  8477 00002BD2 E883ED                   call prs
  8478 00002BD5 83C402                   add  sp, 2
  8479                                  
  8480                                  ;-357       isInProc=0;
  8481                                  
  8482 00002BD8 B80000                   mov ax, 0
  8483 00002BDB A2[0E00]                 mov byte [isInProc], al
  8484                                  
  8485                                  ;-358       return;
  8486                                  
  8487 00002BDE E90900                   jmp .retnprocess
  8488                                  
  8489                                  ;-359     }
  8490                                  
  8491                                  
  8492                                  ;-360     error1("Command not implemented or syntax error");
  8493                                  
  8494                                  .process350:
  8495 00002BE1 68[2A2C]                 push process_4
  8496 00002BE4 E8C3EE                   call error1
  8497 00002BE7 83C402                   add  sp, 2
  8498                                  
  8499                                  ;-361 }
  8500                                  
  8501 00002BEA C9                       .retnprocess: LEAVE
  8502 00002BEB C3                       ret
  8503 00002BEC 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8504 00002BF5 7420616C6C6F776564-
  8505 00002BFE 00                 
  8506 00002BFF 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8507 00002C08 6E673A2000         
  8508 00002C0D 616C72656164792069-     process_2 db "already in proc",0
  8509 00002C16 6E2070726F6300     
  8510 00002C1D 5C6E3B6C656176696E-     process_3 db "\n;leaving: ",0
  8511 00002C26 673A2000           
  8512 00002C2A 436F6D6D616E64206E-     process_4 db "Command not implemented or syntax error",0
  8513 00002C33 6F7420696D706C656D-
  8514 00002C3C 656E746564206F7220-
  8515 00002C45 73796E746178206572-
  8516 00002C4E 726F7200           
  8517                                  ENDP
  8518                                   
  8519                                  ; missing functions: 
  8520                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8521 00002C52 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8522 00002C55 58                      pop ax
  8523 00002C56 C3                      ret
  8524                                   
  8525                                  ;   # type sign width  adr used name   list of global variables
  8526                                  
  8527                                  ;    1 arr sign byte     1    2 Version1[9]
  8528                                  ;    2 var sign byte     1    3 LIST
  8529                                  ;    3 def unsg byte     2    - SYMBOLMAX=31
  8530                                  ;    4 arr sign byte     3   12 Symbol[31]
  8531                                  ;    5 arr sign byte     4   36 SymbolUpper[31]
  8532                                  ;    6 arr sign byte     5    3 ProcName[31]
  8533                                  ;    7 var sign byte     6    5 isInProc
  8534                                  ;    8 var unsg word     7   24 SymbolInt
  8535                                  ;    9 var unsg dwrd     8 NULL SymbolLong
  8536                                  ;   10 def unsg byte     9    - INPUTBUFMAX=255
  8537                                  ;   11 arr sign byte    10    4 InputBuf[255]
  8538                                  ;   12 ptr unsg byte    11   24 InputPtr
  8539                                  ;   13 arr sign byte    12    5 namein[67]
  8540                                  ;   14 arr sign byte    13    6 namelst[67]
  8541                                  ;   15 arr sign byte    14    6 namebin[67]
  8542                                  ;   16 var sign word    15    4 asm_fd
  8543                                  ;   17 var sign word    16    3 lst_fd
  8544                                  ;   18 var sign word    17    3 bin_fd
  8545                                  ;   19 var sign word    18    6 DOS_ERR
  8546                                  ;   20 var sign word    19    4 ErrorCount
  8547                                  ;   21 var sign word    20    4 DOS_NoBytes
  8548                                  ;   22 var sign byte    21    5 DOS_ByteRead
  8549                                  ;   23 var unsg word    23    7 PC
  8550                                  ;   24 var unsg word    24    5 Origin
  8551                                  ;   25 var unsg word    25    6 AbsoluteLab
  8552                                  ;   26 var unsg word    26    2 PCStart
  8553                                  ;   27 var sign byte    27    3 isLabel
  8554                                  ;   28 def unsg byte    28    - DIGIT=1
  8555                                  ;   29 def unsg byte    29    - LETTERE=2
  8556                                  ;   30 def unsg byte    30    - ALNUME=3
  8557                                  ;   31 def unsg byte    31    - NOALNUME=4
  8558                                  ;   32 var sign byte    32   27 TokeType
  8559                                  ;   33 def unsg byte    33    - BYTE=1
  8560                                  ;   34 def unsg byte    34    - WORD=2
  8561                                  ;   35 def unsg byte    35    - DWORD=3
  8562                                  ;   36 def unsg byte    36    - SEGREG=4
  8563                                  ;   37 def unsg byte    37    - IMM=1
  8564                                  ;   38 def unsg byte    38    - REG=2
  8565                                  ;   39 def unsg byte    39    - ADR=3
  8566                                  ;   40 def unsg byte    40    - MEM=4
  8567                                  ;   41 var sign byte    41   28 Op
  8568                                  ;   42 var sign byte    42   31 Op2
  8569                                  ;   43 var sign byte    43   29 CodeType
  8570                                  ;   44 var sign byte    44   23 Code1
  8571                                  ;   45 var sign byte    45    7 Code2
  8572                                  ;   46 var sign byte    46    3 Code3
  8573                                  ;   47 var sign byte    47   19 R2No
  8574                                  ;   48 var sign byte    48   16 R1No
  8575                                  ;   49 var sign byte    49   18 R2Type
  8576                                  ;   50 var sign byte    50   15 R1Type
  8577                                  ;   51 var sign byte    51   14 OpSize
  8578                                  ;   52 var sign byte    52    9 wflag
  8579                                  ;   53 var sign byte    53    3 dflag
  8580                                  ;   54 var sign byte    54    8 sflag
  8581                                  ;   55 var sign byte    55   15 rm
  8582                                  ;   56 var sign byte    56    5 isDirect
  8583                                  ;   57 var sign word    57   48 disp
  8584                                  ;   58 var unsg word    58   13 imme
  8585                                  ;   59 def unsg byte    60    - OPMAXLEN=5
  8586                                  ;   60 arr sign byte    61    2 OpPos[5]
  8587                                  ;   61 var sign word    62    6 OpPrintIndex
  8588                                  ;   62 ptr sign byte    63   19 OpCodePtr
  8589                                  ;   63 var sign byte    64    4 PrintRA
  8590                                  ;   64 def unsg byte    66    - LABELNAMESMAX=3969
  8591                                  ;   65 arr sign byte    67    3 LabelNames[4000]
  8592                                  ;   66 ptr sign byte    68    5 LabelNamePtr
  8593                                  ;   67 def unsg byte    69    - LABELADRMAX=600
  8594                                  ;   68 arr unsg word    70    7 LabelAddr[600]
  8595                                  ;   69 var sign word    71    7 LabelMaxIx
  8596                                  ;   70 var sign word    72   10 LabelIx
  8597                                  ;   71 def unsg byte    74    - JMPCALLNAMESMAX=1969
  8598                                  ;   72 arr sign byte    75    3 JmpCallNames[2000]
  8599                                  ;   73 ptr sign byte    76    5 JmpCallNamePtr
  8600                                  ;   74 def unsg byte    77    - JMPCALLMAX=500
  8601                                  ;   75 arr unsg word    78    2 JmpCallAddr[500]
  8602                                  ;   76 var sign word    79    6 JmpCallMaxIx
  8603                                  ;   77 def unsg byte    81    - FILEBINMAX=20000
  8604                                  ;   78 arr sign byte    82    4 FileBin[20000]
  8605                                  ;   79 var unsg word    83    6 BinLen
  8606                                  ;   80 ptr sign byte    85    1 arglen
  8607                                  ;   81 ptr sign byte    86    4 argv
  8608                                  ;   82 var sign byte     1    1 I_START
  8609                                  ;   83 arr sign byte     4 NULL I_PUSHA[1208]
  8610                                  ;   84 arr sign byte     5 NULL I_NOP[39424]
  8611                                  ;   85 arr sign byte     6 NULL I_CWDE[674]
  8612                                  ;   86 arr sign byte     7 NULL I_CDQ[8125]
  8613                                  ;   87 arr sign byte     8 NULL I_PUSHF[24260]
  8614                                  ;   88 arr sign byte     9 NULL I_SAHF[9734]
  8615                                  ;   89 arr sign byte    10 NULL I_MOVSB[1931]
  8616                                  ;   90 arr sign byte    11 NULL I_CMPSB[35622]
  8617                                  ;   91 arr sign byte    12 NULL I_STOSB[599]
  8618                                  ;   92 arr sign byte    13 NULL I_LODSB[53495]
  8619                                  ;   93 arr sign byte    14 NULL I_SCASB[54007]
  8620                                  ;   94 arr sign byte    15 NULL I_LEAVE[37]
  8621                                  ;   95 arr sign byte    16 NULL I_INTO[19520]
  8622                                  ;   96 arr sign byte    17 NULL I_XLAT[53]
  8623                                  ;   97 arr sign byte    18 NULL I_REPNE[13900]
  8624                                  ;   98 arr sign byte    19 NULL I_REPE[19456]
  8625                                  ;   99 arr sign byte    20 NULL I_HLT[55]
  8626                                  ;  100 arr sign byte    21 NULL I_STC[14412]
  8627                                  ;  101 arr sign byte    22 NULL I_STI[19456]
  8628                                  ;  102 arr sign byte    23 NULL I_STD[56]
  8629                                  ;  103 arr sign byte    25 NULL I_INC[18315]
  8630                                  ;  104 arr sign byte    26 NULL I_DEC[9734]
  8631                                  ;  105 arr sign byte    27 NULL I_NOT[32643]
  8632                                  ;  106 arr sign byte    28 NULL I_NEG[10]
  8633                                  ;  107 arr sign byte    29 NULL I_MUL[1397]
  8634                                  ;  108 arr sign byte    30 NULL I_IMUL[18119]
  8635                                  ;  109 arr sign byte    31 NULL I_DIV[65534]
  8636                                  ;  110 arr sign byte    32 NULL I_IDIV[33791]
  8637                                  ;  111 arr sign byte    34 NULL I_LES[65150]
  8638                                  ;  112 arr sign byte    35 NULL I_LDS[30207]
  8639                                  ;  113 arr sign byte    36 NULL I_LEA[15642]
  8640                                  ;  114 arr sign byte    37 NULL I_LSS[65535]
  8641                                  ;  115 arr sign byte    38 NULL I_LFS[5493]
  8642                                  ;  116 arr sign byte    39 NULL I_LGS[33574]
  8643                                  ;  117 arr sign byte    41 NULL I_ADD[1151]
  8644                                  ;  118 arr sign byte    42 NULL I_OR[29696]
  8645                                  ;  119 arr sign byte    43 NULL I_ADC[35593]
  8646                                  ;  120 arr sign byte    44 NULL I_SBB[2630]
  8647                                  ;  121 arr sign byte    45 NULL I_AND[14630]
  8648                                  ;  122 arr sign byte    46 NULL I_SUB[1095]
  8649                                  ;  123 arr sign byte    47 NULL I_XOR[26997]
  8650                                  ;  124 arr sign byte    48 NULL I_CMP[49203]
  8651                                  ;  125 arr sign byte    49 NULL I_TEST[52169]
  8652                                  ;  126 arr sign byte    51 NULL I_MOV[33680]
  8653                                  ;  127 arr sign byte    52 NULL I_MOVSX[65150]
  8654                                  ;  128 arr sign byte    53 NULL I_MOVZX[29729]
  8655                                  ;  129 arr sign byte    55 NULL I_JO[33618]
  8656                                  ;  130 arr sign byte    56 NULL I_JNO[65150]
  8657                                  ;  131 arr sign byte    57 NULL I_JB[29731]
  8658                                  ;  132 arr sign byte    58 NULL I_JNB[33612]
  8659                                  ;  133 arr sign byte    59 NULL I_JAE[65150]
  8660                                  ;  134 arr sign byte    60 NULL I_JE[29732]
  8661                                  ;  135 arr sign byte    61 NULL I_JNE[33606]
  8662                                  ;  136 arr sign byte    62 NULL I_JBE[65150]
  8663                                  ;  137 arr sign byte    63 NULL I_JA[29734]
  8664                                  ;  138 arr sign byte    64 NULL I_JS[33600]
  8665                                  ;  139 arr sign byte    65 NULL I_JNS[65150]
  8666                                  ;  140 arr sign byte    66 NULL I_JP[29730]
  8667                                  ;  141 arr sign byte    67 NULL I_JNP[33594]
  8668                                  ;  142 arr sign byte    68 NULL I_JL[65150]
  8669                                  ;  143 arr sign byte    69 NULL I_JNL[29737]
  8670                                  ;  144 arr sign byte    70 NULL I_JLE[33588]
  8671                                  ;  145 arr sign byte    71 NULL I_JG[65150]
  8672                                  ;  146 arr sign byte    73 NULL I_JMP[29736]
  8673                                  ;  147 arr sign byte    74 NULL I_CALL[33582]
  8674                                  ;  148 arr sign byte    76 NULL I_RET[65150]
  8675                                  ;  149 arr sign byte    77 NULL I_RETF[29733]
  8676                                  ;  150 arr sign byte    79 NULL I_PUSH[15656]
  8677                                  ;  151 arr sign byte    80 NULL I_POP[33]
  8678                                  ;  152 arr sign byte    82 NULL I_ROL[9076]
  8679                                  ;  153 arr sign byte    83 NULL I_ROR[9021]
  8680                                  ;  154 arr sign byte    84 NULL I_RCL[29696]
  8681                                  ;  155 arr sign byte    85 NULL I_RCR[15646]
  8682                                  ;  156 arr sign byte    86 NULL I_SHL[36]
  8683                                  ;  157 arr sign byte    87 NULL I_SAL[6516]
  8684                                  ;  158 arr sign byte    88 NULL I_SHR[9789]
  8685                                  ;  159 arr sign byte    89 NULL I_SAR[29696]
  8686                                  ;  160 arr sign byte    91 NULL I_INT[15636]
  8687                                  ;  161 arr sign byte    93 NULL I_IN[34]
  8688                                  ;  162 arr sign byte    94 NULL I_INSB[3956]
  8689                                  ;  163 arr sign byte    95 NULL I_INSW[10557]
  8690                                  ;  164 arr sign byte    96 NULL I_INSD[29696]
  8691                                  ;  165 arr sign byte    97 NULL I_OUT[15626]
  8692                                  ;  166 arr sign byte    98 NULL I_OUTSB[40]
  8693                                  ;  167 arr sign byte    99 NULL I_OUTSW[1396]
  8694                                  ;  168 arr sign byte   100 NULL I_OUTSD[9533]
  8695                                  ;  169 arr sign byte   102 NULL I_XCHG[29952]
  8696                                  ;  170 arr sign byte   104 NULL I_LOOPNZ[33542]
  8697                                  ;  171 arr sign byte   105 NULL I_LOOPNE[2686]
  8698                                  ;  172 arr sign byte   106 NULL I_LOOPZ[60176]
  8699                                  ;  173 arr sign byte   107 NULL I_LOOPE[33540]
  8700                                  ;  174 arr sign byte   108 NULL I_LOOP[2686]
  8701                                  ;  175 arr sign byte   109 NULL I_JCXZ[29984]
  8702                                  ;  176 arr sign byte   110 NULL I_JECXZ[47255]
  8703                                  ;  177 arr sign byte   112 NULL I_ENTER[1]
  8704                                  ;  178 arr sign byte   114 NULL I_ORG[52169]
  8705                                  ;  179 arr sign byte   116 NULL I_SECTION[21904]
  8706                                  ;  180 arr sign byte   117 NULL I_SEGMENT[60555]
  8707                                  ;  181 arr sign byte   118 NULL I_ABSOLUTE[5816]
  8708                                  ;  182 arr sign byte   119 NULL I_PROC[39424]
  8709                                  ;  183 arr sign byte   120 NULL I_ENDP[674]
  8710                                  ;  184 arr sign byte   121 NULL I_DB[8125]
  8711                                  ;  185 arr sign byte   122 NULL I_DW[51030]
  8712                                  ;  186 arr sign byte   123 NULL I_DD[65094]
  8713                                  ;  187 arr sign byte   124 NULL I_RESB[0]
  8714                                  ;  188 arr sign byte   125 NULL I_RESW[1678]
  8715                                  ;  189 arr sign byte   126 NULL I_RESD[52256]
  8716                                  ;  190 var sign byte   127 NULL I_END
  8717                                  
  8718                                  
  8719                                  ;   # Calls Line Width  Name   list of functions
  8720                                  
  8721                                  ;    0    2    1   ChangeDirection
  8722                                  ;    1    2    9   checkOpL
  8723                                  ;    2    4   18   check2Ops
  8724                                  ;    3    1   27   get2Ops
  8725                                  ;    4    3   33   getOpL
  8726                                  ;    5    2   41   getOpR
  8727                                  ;    6    4   51   getOp1
  8728                                  ;    7    1   67   getMEM
  8729                                  ;    8    1   90   getIndReg1
  8730                                  ;    9    1   98   getIndReg2
  8731                                  ;   10    2  108   setwflag
  8732                                  ;   11    2  119   setsflag
  8733                                  ;   12    2  129   checkConstSize
  8734                                  ;   13    1    1   parse
  8735                                  ;   14   16   37   getTokeType
  8736                                  ;   15    2   48   storeJmpCall
  8737                                  ;   16    2   59   storeLabel
  8738                                  ;   17    5   71   searchLabel
  8739                                  ;   18    1   84   getVariable
  8740                                  ;   19    2  137   lookCode
  8741                                  ;   20    1  153   getCodeSize
  8742                                  ;   21    9  161   isToken
  8743                                  ;   22    2  169   need
  8744                                  ;   23    1  178   skipRest
  8745                                  ;   24    4    1   writetty
  8746                                  ;   25    1    2   putch
  8747                                  ;   26    8    3   cputs
  8748                                  ;   27    6    5   DosInt
  8749                                  ;   28    1   10   openR
  8750                                  ;   29    2   11   creatR
  8751                                  ;   30    3   12   fcloseR
  8752                                  ;   31    5   13   exitR
  8753                                  ;   32    2   14   readRL
  8754                                  ;   33    2   15   fputcR
  8755                                  ;   34    1   18   getLine
  8756                                  ;   35    1   34   ifEOL
  8757                                  ;   36    3   43   skipBlank
  8758                                  ;   37    2   48   letterE
  8759                                  ;   38    1   58   alnumE
  8760                                  ;   39    3   63   digit
  8761                                  ;   40    4   68   strlen
  8762                                  ;   41    9   73   strcpy
  8763                                  ;   42   35   79   eqstr
  8764                                  ;   43    3   88   strcat1
  8765                                  ;   44    2   92   toupper
  8766                                  ;   45    1   99   getDigit
  8767                                  ;   46    1  111   getName
  8768                                  ;   47    1  130   testReg
  8769                                  ;   48    1    1   printLine
  8770                                  ;   49    7   23   prc
  8771                                  ;   50    1   35   prscomment
  8772                                  ;   51   32   43   prs
  8773                                  ;   52    3   65   printhex8a
  8774                                  ;   53    2   70   printhex4
  8775                                  ;   54    1   75   printhex16
  8776                                  ;   55    5   80   printIntU
  8777                                  ;   56   27   91   error1
  8778                                  ;   57   13   99   errorexit
  8779                                  ;   58 NULL  104   allowederror
  8780                                  ;   59    3  105   addrerror
  8781                                  ;   60    1  106   immeerror
  8782                                  ;   61    2  107   implerror
  8783                                  ;   62    4  108   indexerror
  8784                                  ;   63    3  109   invaloperror
  8785                                  ;   64    6  110   numbererror
  8786                                  ;   65    1  111   regmemerror
  8787                                  ;   66    3  112   reg16error
  8788                                  ;   67    1  113   segregerror
  8789                                  ;   68    5  114   syntaxerror
  8790                                  ;   69 NULL  116   addrexit
  8791                                  ;   70    3  117   dataexit
  8792                                  ;   71 NULL  118   internexit
  8793                                  ;   72 NULL    1   main
  8794                                  ;   73    1    9   getarg
  8795                                  ;   74    1   43   fixJmpCall
  8796                                  ;   75    2   74   epilog
  8797                                  ;   76    2  122   end1
  8798                                  ;   77    1    2   getCodes
  8799                                  ;   78    1    7   gen66h
  8800                                  ;   79    8    9   genCode2
  8801                                  ;   80   13   13   genCodeW
  8802                                  ;   81   33   17   genCode8
  8803                                  ;   82   17   28   genCode16
  8804                                  ;   83    1   32   genCode32
  8805                                  ;   84   13   36   writeEA
  8806                                  ;   85    4   78   genImmediate
  8807                                  ;   86    1   11   process
  8808                                  ;   87 NULL  361   LastFunctionByt
  8809                                  
  8810                                  ;    #  addr name   list of CALLs
  8811                                  
  8812                                  ;    0     0 implerror
  8813                                  ;    1    10 segregerror
  8814                                  ;    2    22 setwflag
  8815                                  ;    3    31 error1
  8816                                  ;    4    38 error1
  8817                                  ;    5    45 get2Ops
  8818                                  ;    6    53 addrerror
  8819                                  ;    7    63 invaloperror
  8820                                  ;    8    76 immeerror
  8821                                  ;    9    86 addrerror
  8822                                  ;   10    96 invaloperror
  8823                                  ;   11   109 setwflag
  8824                                  ;   12   118 getOpL
  8825                                  ;   13   125 need
  8826                                  ;   14   130 getOpR
  8827                                  ;   15   137 getOpR
  8828                                  ;   16   144 getOp1
  8829                                  ;   17   151 isToken
  8830                                  ;   18   159 getMEM
  8831                                  ;   19   166 invaloperror
  8832                                  ;   20   179 error1
  8833                                  ;   21   186 testReg
  8834                                  ;   22   194 searchLabel
  8835                                  ;   23   206 error1
  8836                                  ;   24   213 getTokeType
  8837                                  ;   25   225 getOp1
  8838                                  ;   26   232 syntaxerror
  8839                                  ;   27   244 getIndReg2
  8840                                  ;   28   255 getIndReg1
  8841                                  ;   29   266 isToken
  8842                                  ;   30   274 getTokeType
  8843                                  ;   31   286 numbererror
  8844                                  ;   32   298 isToken
  8845                                  ;   33   306 isToken
  8846                                  ;   34   314 errorexit
  8847                                  ;   35   324 indexerror
  8848                                  ;   36   335 indexerror
  8849                                  ;   37   346 indexerror
  8850                                  ;   38   357 indexerror
  8851                                  ;   39   368 gen66h
  8852                                  ;   40   375 error1
  8853                                  ;   41   382 getLine
  8854                                  ;   42   390 getTokeType
  8855                                  ;   43   402 strcpy
  8856                                  ;   44   409 storeLabel
  8857                                  ;   45   420 getTokeType
  8858                                  ;   46   432 lookCode
  8859                                  ;   47   441 process
  8860                                  ;   48   449 getVariable
  8861                                  ;   49   461 skipRest
  8862                                  ;   50   470 error1
  8863                                  ;   51   477 error1
  8864                                  ;   52   484 printLine
  8865                                  ;   53   494 skipBlank
  8866                                  ;   54   504 digit
  8867                                  ;   55   510 getDigit
  8868                                  ;   56   519 letterE
  8869                                  ;   57   527 getName
  8870                                  ;   58   535 errorexit
  8871                                  ;   59   545 strcpy
  8872                                  ;   60   552 errorexit
  8873                                  ;   61   562 errorexit
  8874                                  ;   62   572 searchLabel
  8875                                  ;   63   584 error1
  8876                                  ;   64   591 strcpy
  8877                                  ;   65   598 errorexit
  8878                                  ;   66   608 eqstr
  8879                                  ;   67   614 strlen
  8880                                  ;   68   621 storeLabel
  8881                                  ;   69   632 getTokeType
  8882                                  ;   70   644 lookCode
  8883                                  ;   71   653 dataexit
  8884                                  ;   72   662 dataexit
  8885                                  ;   73   671 getTokeType
  8886                                  ;   74   683 genCode8
  8887                                  ;   75   692 skipBlank
  8888                                  ;   76   702 isToken
  8889                                  ;   77   710 genCode8
  8890                                  ;   78   719 isToken
  8891                                  ;   79   727 getTokeType
  8892                                  ;   80   739 genCode16
  8893                                  ;   81   749 isToken
  8894                                  ;   82   757 getTokeType
  8895                                  ;   83   769 genCode16
  8896                                  ;   84   779 genCode16
  8897                                  ;   85   789 isToken
  8898                                  ;   86   797 getTokeType
  8899                                  ;   87   809 syntaxerror
  8900                                  ;   88   821 error1
  8901                                  ;   89   828 numbererror
  8902                                  ;   90   840 dataexit
  8903                                  ;   91   849 eqstr
  8904                                  ;   92   855 eqstr
  8905                                  ;   93   861 getTokeType
  8906                                  ;   94   873 eqstr
  8907                                  ;   95   879 getTokeType
  8908                                  ;   96   891 eqstr
  8909                                  ;   97   897 getTokeType
  8910                                  ;   98   909 skipBlank
  8911                                  ;   99   919 isToken
  8912                                  ;  100   927 getTokeType
  8913                                  ;  101   939 error1
  8914                                  ;  102   946 prs
  8915                                  ;  103   950 prc
  8916                                  ;  104   954 getTokeType
  8917                                  ;  105   966 error1
  8918                                  ;  106   973 writetty
  8919                                  ;  107   982 writetty
  8920                                  ;  108   991 putch
  8921                                  ;  109   997 DosInt
  8922                                  ;  110  1004 DosInt
  8923                                  ;  111  1011 DosInt
  8924                                  ;  112  1018 DosInt
  8925                                  ;  113  1025 DosInt
  8926                                  ;  114  1032 DosInt
  8927                                  ;  115  1039 readRL
  8928                                  ;  116  1046 errorexit
  8929                                  ;  117  1056 errorexit
  8930                                  ;  118  1066 ifEOL
  8931                                  ;  119  1072 readRL
  8932                                  ;  120  1079 errorexit
  8933                                  ;  121  1089 digit
  8934                                  ;  122  1095 letterE
  8935                                  ;  123  1103 strcpy
  8936                                  ;  124  1110 digit
  8937                                  ;  125  1116 alnumE
  8938                                  ;  126  1123 errorexit
  8939                                  ;  127  1133 strcpy
  8940                                  ;  128  1140 toupper
  8941                                  ;  129  1148 strlen
  8942                                  ;  130  1155 strlen
  8943                                  ;  131  1162 eqstr
  8944                                  ;  132  1168 eqstr
  8945                                  ;  133  1174 eqstr
  8946                                  ;  134  1180 eqstr
  8947                                  ;  135  1186 eqstr
  8948                                  ;  136  1192 eqstr
  8949                                  ;  137  1198 eqstr
  8950                                  ;  138  1204 eqstr
  8951                                  ;  139  1210 eqstr
  8952                                  ;  140  1216 eqstr
  8953                                  ;  141  1222 eqstr
  8954                                  ;  142  1228 eqstr
  8955                                  ;  143  1234 eqstr
  8956                                  ;  144  1240 eqstr
  8957                                  ;  145  1246 eqstr
  8958                                  ;  146  1252 eqstr
  8959                                  ;  147  1258 eqstr
  8960                                  ;  148  1264 eqstr
  8961                                  ;  149  1270 eqstr
  8962                                  ;  150  1276 eqstr
  8963                                  ;  151  1282 eqstr
  8964                                  ;  152  1288 eqstr
  8965                                  ;  153  1294 eqstr
  8966                                  ;  154  1300 eqstr
  8967                                  ;  155  1306 eqstr
  8968                                  ;  156  1312 eqstr
  8969                                  ;  157  1318 eqstr
  8970                                  ;  158  1324 eqstr
  8971                                  ;  159  1330 eqstr
  8972                                  ;  160  1336 eqstr
  8973                                  ;  161  1342 prs
  8974                                  ;  162  1346 printhex16
  8975                                  ;  163  1357 prs
  8976                                  ;  164  1361 prc
  8977                                  ;  165  1365 printhex8a
  8978                                  ;  166  1376 prs
  8979                                  ;  167  1380 prc
  8980                                  ;  168  1384 prscomment
  8981                                  ;  169  1395 writetty
  8982                                  ;  170  1404 writetty
  8983                                  ;  171  1413 fputcR
  8984                                  ;  172  1420 prc
  8985                                  ;  173  1424 prc
  8986                                  ;  174  1428 printhex4
  8987                                  ;  175  1438 printhex4
  8988                                  ;  176  1448 prc
  8989                                  ;  177  1452 printhex8a
  8990                                  ;  178  1463 printhex8a
  8991                                  ;  179  1474 printIntU
  8992                                  ;  180  1484 prc
  8993                                  ;  181  1488 prs
  8994                                  ;  182  1492 prs
  8995                                  ;  183  1496 prs
  8996                                  ;  184  1500 prs
  8997                                  ;  185  1504 error1
  8998                                  ;  186  1511 epilog
  8999                                  ;  187  1518 end1
  9000                                  ;  188  1523 error1
  9001                                  ;  189  1530 error1
  9002                                  ;  190  1537 error1
  9003                                  ;  191  1544 error1
  9004                                  ;  192  1551 error1
  9005                                  ;  193  1558 error1
  9006                                  ;  194  1565 error1
  9007                                  ;  195  1572 error1
  9008                                  ;  196  1579 error1
  9009                                  ;  197  1586 error1
  9010                                  ;  198  1593 error1
  9011                                  ;  199  1600 errorexit
  9012                                  ;  200  1610 errorexit
  9013                                  ;  201  1620 errorexit
  9014                                  ;  202  1630 getarg
  9015                                  ;  203  1637 parse
  9016                                  ;  204  1643 fixJmpCall
  9017                                  ;  205  1654 epilog
  9018                                  ;  206  1661 end1
  9019                                  ;  207  1666 cputs
  9020                                  ;  208  1672 cputs
  9021                                  ;  209  1678 exitR
  9022                                  ;  210  1684 toupper
  9023                                  ;  211  1692 strcpy
  9024                                  ;  212  1699 strcat1
  9025                                  ;  213  1707 strcpy
  9026                                  ;  214  1714 strcat1
  9027                                  ;  215  1722 strcpy
  9028                                  ;  216  1729 strcat1
  9029                                  ;  217  1737 openR
  9030                                  ;  218  1743 cputs
  9031                                  ;  219  1749 cputs
  9032                                  ;  220  1755 exitR
  9033                                  ;  221  1761 creatR
  9034                                  ;  222  1768 cputs
  9035                                  ;  223  1774 cputs
  9036                                  ;  224  1780 exitR
  9037                                  ;  225  1786 creatR
  9038                                  ;  226  1793 cputs
  9039                                  ;  227  1799 cputs
  9040                                  ;  228  1805 exitR
  9041                                  ;  229  1811 prs
  9042                                  ;  230  1815 prs
  9043                                  ;  231  1819 prs
  9044                                  ;  232  1823 prs
  9045                                  ;  233  1827 prs
  9046                                  ;  234  1831 prs
  9047                                  ;  235  1835 prs
  9048                                  ;  236  1839 prs
  9049                                  ;  237  1843 prs
  9050                                  ;  238  1847 prs
  9051                                  ;  239  1851 printIntU
  9052                                  ;  240  1861 strcpy
  9053                                  ;  241  1868 strlen
  9054                                  ;  242  1875 searchLabel
  9055                                  ;  243  1887 error1
  9056                                  ;  244  1894 prs
  9057                                  ;  245  1898 printIntU
  9058                                  ;  246  1908 prs
  9059                                  ;  247  1912 prs
  9060                                  ;  248  1916 prs
  9061                                  ;  249  1920 prs
  9062                                  ;  250  1924 prs
  9063                                  ;  251  1928 prs
  9064                                  ;  252  1932 printIntU
  9065                                  ;  253  1942 prs
  9066                                  ;  254  1946 fputcR
  9067                                  ;  255  1953 prs
  9068                                  ;  256  1957 printIntU
  9069                                  ;  257  1967 prs
  9070                                  ;  258  1971 fcloseR
  9071                                  ;  259  1979 fcloseR
  9072                                  ;  260  1987 fcloseR
  9073                                  ;  261  1995 exitR
  9074                                  ;  262  2001 genCode8
  9075                                  ;  263  2010 genCode8
  9076                                  ;  264  2019 genCode8
  9077                                  ;  265  2028 errorexit
  9078                                  ;  266  2038 genCode8
  9079                                  ;  267  2047 genCode8
  9080                                  ;  268  2056 genCode16
  9081                                  ;  269  2066 genCode16
  9082                                  ;  270  2076 genCode8
  9083                                  ;  271  2085 genCode8
  9084                                  ;  272  2094 genCode16
  9085                                  ;  273  2104 genCode32
  9086                                  ;  274  2114 genCode16
  9087                                  ;  275  2124 genCode8
  9088                                  ;  276  2133 getTokeType
  9089                                  ;  277  2145 getCodeSize
  9090                                  ;  278  2157 getCodes
  9091                                  ;  279  2166 genCode8
  9092                                  ;  280  2175 getOpL
  9093                                  ;  281  2182 checkOpL
  9094                                  ;  282  2191 genCode2
  9095                                  ;  283  2200 getTokeType
  9096                                  ;  284  2212 implerror
  9097                                  ;  285  2222 genCodeW
  9098                                  ;  286  2231 writeEA
  9099                                  ;  287  2239 check2Ops
  9100                                  ;  288  2249 reg16error
  9101                                  ;  289  2260 addrerror
  9102                                  ;  290  2270 genCode8
  9103                                  ;  291  2279 genCode8
  9104                                  ;  292  2288 writeEA
  9105                                  ;  293  2296 check2Ops
  9106                                  ;  294  2306 setsflag
  9107                                  ;  295  2315 genCodeW
  9108                                  ;  296  2324 genImmediate
  9109                                  ;  297  2337 genCodeW
  9110                                  ;  298  2346 writeEA
  9111                                  ;  299  2354 genCode8
  9112                                  ;  300  2363 genImmediate
  9113                                  ;  301  2376 genCodeW
  9114                                  ;  302  2385 writeEA
  9115                                  ;  303  2393 genCodeW
  9116                                  ;  304  2402 writeEA
  9117                                  ;  305  2410 syntaxerror
  9118                                  ;  306  2422 check2Ops
  9119                                  ;  307  2432 genCode2
  9120                                  ;  308  2441 genImmediate
  9121                                  ;  309  2454 genCodeW
  9122                                  ;  310  2463 writeEA
  9123                                  ;  311  2471 genImmediate
  9124                                  ;  312  2484 regmemerror
  9125                                  ;  313  2496 ChangeDirection
  9126                                  ;  314  2512 reg16error
  9127                                  ;  315  2523 genCode2
  9128                                  ;  316  2532 writeEA
  9129                                  ;  317  2540 genCodeW
  9130                                  ;  318  2549 genCode16
  9131                                  ;  319  2559 genCodeW
  9132                                  ;  320  2568 genCode16
  9133                                  ;  321  2578 genCodeW
  9134                                  ;  322  2587 writeEA
  9135                                  ;  323  2595 ChangeDirection
  9136                                  ;  324  2611 genCodeW
  9137                                  ;  325  2620 writeEA
  9138                                  ;  326  2628 syntaxerror
  9139                                  ;  327  2640 searchLabel
  9140                                  ;  328  2652 checkConstSize
  9141                                  ;  329  2667 genCode2
  9142                                  ;  330  2676 genCode8
  9143                                  ;  331  2685 genCode8
  9144                                  ;  332  2694 genCode2
  9145                                  ;  333  2703 genCode16
  9146                                  ;  334  2713 genCode8
  9147                                  ;  335  2722 genCode2
  9148                                  ;  336  2731 genCode16
  9149                                  ;  337  2741 storeJmpCall
  9150                                  ;  338  2754 searchLabel
  9151                                  ;  339  2766 checkConstSize
  9152                                  ;  340  2781 genCode8
  9153                                  ;  341  2790 genCode8
  9154                                  ;  342  2799 genCode8
  9155                                  ;  343  2808 genCode16
  9156                                  ;  344  2818 genCode8
  9157                                  ;  345  2827 genCode16
  9158                                  ;  346  2837 genCode8
  9159                                  ;  347  2846 genCode16
  9160                                  ;  348  2856 storeJmpCall
  9161                                  ;  349  2869 genCode8
  9162                                  ;  350  2878 genCode16
  9163                                  ;  351  2888 genCode8
  9164                                  ;  352  2897 getOpL
  9165                                  ;  353  2904 setsflag
  9166                                  ;  354  2913 genCode2
  9167                                  ;  355  2922 genCode8
  9168                                  ;  356  2931 genCode16
  9169                                  ;  357  2941 error1
  9170                                  ;  358  2948 genCode8
  9171                                  ;  359  2957 genCode8
  9172                                  ;  360  2966 checkOpL
  9173                                  ;  361  2975 reg16error
  9174                                  ;  362  2986 genCode2
  9175                                  ;  363  2995 genCode8
  9176                                  ;  364  3004 writeEA
  9177                                  ;  365  3012 syntaxerror
  9178                                  ;  366  3024 check2Ops
  9179                                  ;  367  3034 genCodeW
  9180                                  ;  368  3043 writeEA
  9181                                  ;  369  3051 genCodeW
  9182                                  ;  370  3060 writeEA
  9183                                  ;  371  3068 genCode8
  9184                                  ;  372  3077 genCodeW
  9185                                  ;  373  3086 writeEA
  9186                                  ;  374  3094 genCode8
  9187                                  ;  375  3103 genCode8
  9188                                  ;  376  3112 genCode8
  9189                                  ;  377  3121 getOp1
  9190                                  ;  378  3128 genCode16
  9191                                  ;  379  3138 numbererror
  9192                                  ;  380  3150 need
  9193                                  ;  381  3155 getOp1
  9194                                  ;  382  3162 genCode8
  9195                                  ;  383  3171 numbererror
  9196                                  ;  384  3183 numbererror
  9197                                  ;  385  3195 numbererror
  9198                                  ;  386  3207 prs
  9199                                  ;  387  3211 prs
  9200                                  ;  388  3215 error1
  9201                                  ;  389  3222 prs
  9202                                  ;  390  3226 prs
  9203                                  ;  391  3230 error1
  9204                                  ;Input: AS.C, List: AS.S,  Lines:  362
  9205                                  ;Glob. variables:  190 max.:  200
  9206                                  ;Functions      :   88 max.:  300
  9207                                  ;Calls          :  392 max.: 2000, NameField: 3237 max.:    65535
  9208                                  ;Code until     :21667 max.: 30000, free: 8333
  9209                                  ;Data (HeapEnd) :58754, resting stacksize:  6781
  9210                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
