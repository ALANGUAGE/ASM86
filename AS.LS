     1                                  
     2                                  ; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E90000                  jmp main
     6                                  
     7                                  ;-1 int main() {getarg(); parse(); epilog(); end1();}//BAS.BAT,   AS TE
     8                                  
     9                                  
    10                                  main:  ; *** PROC ***
    11 00000003 E8B519                   call getarg
    12 00000006 E8E408                   call parse
    13 00000009 E8071C                   call epilog
    14 0000000C E8741D                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 5.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 5.1.2016",0
    21 00000019 3720352E312E323031-
    22 00000022 3600               
    23                                  
    24                                  ;-3 #include "DECL.C"
    25                                  
    26                                  ;Use include file: DECL.C
    27                                  
    28                                  ;-1 char LIST;              // listing on/off
    29                                  
    30 00000024 00                      LIST db 0
    31                                  
    32                                  ;-2 char Symbol[80];        //next symbol to decode
    33                                  
    34                                  section .bss
    35                                  absolute 30000
    36 00007530 <res 00000050>          Symbol resb 80
    37                                  section .text
    38                                  
    39                                  ;-3 char SymbolUpper[80];   //set toupper in getName
    40                                  
    41                                  section .bss
    42                                  absolute 30080
    43 00007580 <res 00000050>          SymbolUpper resb 80
    44                                  section .text
    45                                  
    46                                  ;-4 unsigned int SymbolInt; //integer value set in getDigit
    47                                  
    48 00000025 0000                    SymbolInt dw 0
    49                                  
    50                                  ;-5 char InputBuf[128];     //filled in getLine, no overflow test
    51                                  
    52                                  section .bss
    53                                  absolute 30160
    54 000075D0 <res 00000080>          InputBuf resb 128
    55                                  section .text
    56                                  
    57                                  ;-6 unsigned char *InputPtr;//position in InputBuf
    58                                  
    59 00000027 0000                    InputPtr dw 0
    60                                  
    61                                  ;-7 char namein [67];       //input file name  .S
    62                                  
    63                                  section .bss
    64                                  absolute 30288
    65 00007650 <res 00000043>          namein resb 67
    66                                  section .text
    67                                  
    68                                  ;-8 char namelst[67];       //list file name   .LST
    69                                  
    70                                  section .bss
    71                                  absolute 30355
    72 00007693 <res 00000043>          namelst resb 67
    73                                  section .text
    74                                  
    75                                  ;-9 char namebin[67];       //output file name .COM
    76                                  
    77                                  section .bss
    78                                  absolute 30422
    79 000076D6 <res 00000043>          namebin resb 67
    80                                  section .text
    81                                  
    82                                  ;-10 int  asm_fd;            //input file descriptor
    83                                  
    84 00000029 0000                    asm_fd dw 0
    85                                  
    86                                  ;-11 int lst_fd;             //list file descriptor
    87                                  
    88 0000002B 0000                    lst_fd dw 0
    89                                  
    90                                  ;-12 int bin_fd;             //output file descriptor
    91                                  
    92 0000002D 0000                    bin_fd dw 0
    93                                  
    94                                  ;-13 int DOS_ERR;            //global var
    95                                  
    96 0000002F 0000                    DOS_ERR dw 0
    97                                  
    98                                  ;-14 int ErrorCount;         //number of errors
    99                                  
   100 00000031 0000                    ErrorCount dw 0
   101                                  
   102                                  ;-15 int DOS_NoBytes;        //number of bytes read (0 or 1)
   103                                  
   104 00000033 0000                    DOS_NoBytes dw 0
   105                                  
   106                                  ;-16 char DOS_ByteRead;      //the byte just read by DOS
   107                                  
   108 00000035 00                      DOS_ByteRead db 0
   109                                  
   110                                  ;-17 
   111                                  
   112                                  
   113                                  ;-18 unsigned int PC;        //program counter, ORG nn
   114                                  
   115 00000036 0000                    PC dw 0
   116                                  
   117                                  ;-19 unsigned int PCStart;   //PC at start of line by PrintLine()
   118                                  
   119 00000038 0000                    PCStart dw 0
   120                                  
   121                                  ;-20 char isLabel;           //by getName()
   122                                  
   123 0000003A 00                      isLabel db 0
   124                                  
   125                                  ;-21 #define DIGIT    1      //0-9
   126                                  
   127                                  
   128                                  ;-22 #define LETTERE  2      //a-z A-Z @ . _
   129                                  
   130                                  
   131                                  ;-23 #define ALNUME   3      //a-z A-Z @ . _  0-9
   132                                  
   133                                  
   134                                  ;-24 #define NOALNUME 4      //other char
   135                                  
   136                                  
   137                                  ;-25 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   138                                  
   139 0000003B 00                      TokeType db 0
   140                                  
   141                                  ;-26 #define BYTE     1
   142                                  
   143                                  
   144                                  ;-27 #define WORD     2
   145                                  
   146                                  
   147                                  ;-28 #define DWORD    3
   148                                  
   149                                  
   150                                  ;-29 #define SEGREG   4
   151                                  
   152                                  
   153                                  ;-30 //char CodeSize;          //0, BYTE, WORD, DWORD
   154                                  
   155                                  
   156                                  ;-31 #define IMM      1      //const  ,123
   157                                  
   158                                  
   159                                  ;-32 #define REG      2      //       ,BX    mode=11
   160                                  
   161                                  
   162                                  ;-33 #define DIR      3      //VALUE  ,var1  mod=00, r/m=110
   163                                  
   164                                  
   165                                  ;-34 #define IND      4      //indirec,[var1],[BX+SI],[table+BX],[bp-4] disp 0,8,16
   166                                  
   167                                  
   168                                  ;-35 char Op1;               //0, IMM, REG, DIR, IND
   169                                  
   170 0000003C 00                      Op1 db 0
   171                                  
   172                                  ;-36 char CodeType;          //1-207 by searchSymbol(), must be byte size 
   173                                  
   174 0000003D 00                      CodeType db 0
   175                                  
   176                                  ;-37 
   177                                  
   178                                  
   179                                  ;-38 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   180                                  
   181 0000003E 00                      RegType db 0
   182                                  
   183                                  ;-39 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   184                                  
   185 0000003F 00                      RegNo db 0
   186                                  
   187                                  ;-40 char OpSize;            //0, BYTE, WORD, DWORD
   188                                  
   189 00000040 00                      OpSize db 0
   190                                  
   191                                  ;-41 //char AddrSize;          //67h:
   192                                  
   193                                  
   194                                  ;-42 char NumOprns;          //0-2
   195                                  
   196 00000041 00                      NumOprns db 0
   197                                  
   198                                  ;-43 char wflag;             //0=byte, 1=word/dword
   199                                  
   200 00000042 00                      wflag db 0
   201                                  
   202                                  ;-44 char dflag;             //0=source is reg,  1=dest is reg
   203                                  
   204 00000043 00                      dflag db 0
   205                                  
   206                                  ;-45 //char modrm;           //mod, r/m
   207                                  
   208                                  
   209                                  ;-46 char reg;               //combination of index and base reg
   210                                  
   211 00000044 00                      reg db 0
   212                                  
   213                                  ;-47 int disp;               //displacement      0-8 bytes
   214                                  
   215 00000045 0000                    disp dw 0
   216                                  
   217                                  ;-48 int imme;               //immediate         0-8 bytes
   218                                  
   219 00000047 0000                    imme dw 0
   220                                  
   221                                  ;-49 
   222                                  
   223                                  
   224                                  ;-50 #define OPMAXLEN  5
   225                                  
   226                                  
   227                                  ;-51 char OpPos[OPMAXLEN];   //array for one opcode to list
   228                                  
   229                                  section .bss
   230                                  absolute 30489
   231 00007719 <res 00000005>          OpPos resb 5
   232                                  section .text
   233                                  
   234                                  ;-52 int OpPrintIndex;       //0-OPMAXLEN, Position to print opcode, by genCode8()
   235                                  
   236 00000049 0000                    OpPrintIndex dw 0
   237                                  
   238                                  ;-53 char *OpCodePtr;        //position in OpCodeTable by searchSymbol(), div.
   239                                  
   240 0000004B 0000                    OpCodePtr dw 0
   241                                  
   242                                  ;-54 char PrReloc;           //print 'R' if relocative
   243                                  
   244 0000004D 00                      PrReloc db 0
   245                                  
   246                                  ;-55 
   247                                  
   248                                  
   249                                  ;-56 char LabelNames[1000];  //space for names of all labels
   250                                  
   251                                  section .bss
   252                                  absolute 30494
   253 0000771E <res 000003E8>          LabelNames resb 1000
   254                                  section .text
   255                                  
   256                                  ;-57 char *LabelNamePtr;     // first free position
   257                                  
   258 0000004E 0000                    LabelNamePtr dw 0
   259                                  
   260                                  ;-58 unsigned int LabelAddr[100];//addr of each label
   261                                  
   262                                  section .bss
   263                                  absolute 31494
   264 00007B06 <res 000000C8>          LabelAddr resw 100
   265                                  section .text
   266                                  
   267                                  ;-59 int LabelMaxIx=0;       //actual number of stored labels
   268                                  
   269 00000050 0000                    LabelMaxIx dw 0
   270                                  
   271                                  ;-60 int LabelIx;            //actual number of just searched label
   272                                  
   273 00000052 0000                    LabelIx dw 0
   274                                  
   275                                  ;-61 
   276                                  
   277                                  
   278                                  ;-62 char FileBin  [2000];   //output binary file
   279                                  
   280                                  section .bss
   281                                  absolute 31694
   282 00007BCE <res 000007D0>          FileBin resb 2000
   283                                  section .text
   284                                  
   285                                  ;-63 unsigned int BinLen=0;  //length of binary file
   286                                  
   287 00000054 0000                    BinLen dw 0
   288                                  
   289                                  ;-64 
   290                                  
   291                                  
   292                                  ;-65 char *arglen=0x80;      // for main only
   293                                  
   294 00000056 8000                    arglen dw 128
   295                                  
   296                                  ;-66 char *argv=0x82;        // for main only
   297                                  
   298 00000058 8200                    argv dw 130
   299                                  ;Back to main program: AS.C
   300                                  
   301                                  ;-4 
   302                                  
   303                                  
   304                                  ;-5 int process() { int i; char c;
   305                                  
   306                                  
   307                                  process:  ; *** PROC ***
   308                                  
   309                                  ;-6   getTokeType();
   310                                  
   311                                  ;Function : process, Number of local variables: 2
   312                                  ;   # type sign width line used address name   list of local variables
   313                                  ;  200 var sign word     5 NULL bp-2    i
   314                                  ;  201 var sign byte     5 NULL bp-4    c;
   315 0000005A C8040000                 ENTER  4,0
   316 0000005E E82201                   call getTokeType
   317                                  
   318                                  ;-7   OpSize=getCodeSize();
   319                                  
   320 00000061 E8FE05                   call getCodeSize
   321 00000064 A2[4000]                 mov byte [OpSize], al
   322                                  
   323                                  ;-8 
   324                                  
   325                                  
   326                                  ;-9   if (CodeType ==  1) {//1 byte opcode
   327                                  
   328 00000067 A0[3D00]                 mov al, [CodeType]
   329 0000006A 3C01                     cmp al, 1
   330 0000006C 0F850D00                 jne @@process1
   331                                  
   332                                  ;-10     genInstruction(0, 1); return;
   333                                  
   334 00000070 6A01                     push 1
   335 00000072 6A00                     push 0
   336 00000074 E83007                   call genInstruction
   337 00000077 83C404                   add  sp, 4
   338 0000007A E9E000                   jmp @@retn
   339                                  
   340                                  ;-11   }
   341                                  
   342                                  
   343                                  ;-12   if (CodeType ==  2) {//inc, dec
   344                                  
   345                                  @@process1:
   346 0000007D A0[3D00]                 mov al, [CodeType]
   347 00000080 3C02                     cmp al, 2
   348 00000082 0F855400                 jne @@process2
   349                                  
   350                                  ;-13     LeftOpwCheck();
   351                                  
   352 00000086 E89901                   call LeftOpwCheck
   353                                  
   354                                  ;-14     	if (Op1 == REG) {
   355                                  
   356 00000089 A0[3C00]                 mov al, [Op1]
   357 0000008C 3C02                     cmp al, 2
   358 0000008E 0F853400                 jne @@process3
   359                                  
   360                                  ;-15         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form
   361                                  
   362 00000092 A0[3E00]                 mov al, [RegType]
   363 00000095 3C02                     cmp al, 2
   364 00000097 0F851100                 jne @@process4
   365 0000009B 6A03                     push 3
   366 0000009D A0[3F00]                 mov al, byte [RegNo]
   367 000000A0 B400                     mov ah, 0
   368 000000A2 50                       push ax
   369 000000A3 E80107                   call genInstruction
   370 000000A6 83C404                   add  sp, 4
   371 000000A9 E9B100                   jmp @@retn
   372                                  
   373                                  ;-16         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
   374                                  
   375                                  @@process4:
   376 000000AC A0[3E00]                 mov al, [RegType]
   377 000000AF 3C03                     cmp al, 3
   378 000000B1 0F851100                 jne @@process5
   379 000000B5 6A03                     push 3
   380 000000B7 A0[3F00]                 mov al, byte [RegNo]
   381 000000BA B400                     mov ah, 0
   382 000000BC 50                       push ax
   383 000000BD E8E706                   call genInstruction
   384 000000C0 83C404                   add  sp, 4
   385 000000C3 E99700                   jmp @@retn
   386                                  @@process5:
   387                                  
   388                                  ;-17       genInstruction(wflag, 1); genCodeInREG(); return;
   389                                  
   390                                  @@process3:
   391 000000C6 6A01                     push 1
   392 000000C8 A0[4200]                 mov al, byte [wflag]
   393 000000CB B400                     mov ah, 0
   394 000000CD 50                       push ax
   395 000000CE E8D606                   call genInstruction
   396 000000D1 83C404                   add  sp, 4
   397 000000D4 E80207                   call genCodeInREG
   398 000000D7 E98300                   jmp @@retn
   399                                  
   400                                  ;-18   }
   401                                  
   402                                  
   403                                  ;-19 
   404                                  
   405                                  
   406                                  ;-20   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
   407                                  
   408                                  @@process2:
   409 000000DA A0[3D00]                 mov al, [CodeType]
   410 000000DD 3C34                     cmp al, 52
   411 000000DF 0F851700                 jne @@process6
   412                                  
   413                                  ;-21     LeftOpwCheck();
   414                                  
   415 000000E3 E83C01                   call LeftOpwCheck
   416                                  
   417                                  ;-22     genInstruction(wflag, 1); genCodeInREG(); return;
   418                                  
   419 000000E6 6A01                     push 1
   420 000000E8 A0[4200]                 mov al, byte [wflag]
   421 000000EB B400                     mov ah, 0
   422 000000ED 50                       push ax
   423 000000EE E8B606                   call genInstruction
   424 000000F1 83C404                   add  sp, 4
   425 000000F4 E8E206                   call genCodeInREG
   426 000000F7 E96300                   jmp @@retn
   427                                  
   428                                  ;-23   }
   429                                  
   430                                  
   431                                  ;-24 
   432                                  
   433                                  
   434                                  ;-25   if (CodeType==  8) {// ret
   435                                  
   436                                  @@process6:
   437 000000FA A0[3D00]                 mov al, [CodeType]
   438 000000FD 3C08                     cmp al, 8
   439 000000FF 0F852D00                 jne @@process7
   440                                  
   441                                  ;-26     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}
   442                                  
   443 00000103 A0[3B00]                 mov al, [TokeType]
   444 00000106 3C01                     cmp al, 1
   445 00000108 0F851700                 jne @@process8
   446 0000010C 6A02                     push 2
   447 0000010E 6A00                     push 0
   448 00000110 E89406                   call genInstruction
   449 00000113 83C404                   add  sp, 4
   450 00000116 FF36[2500]               push word [SymbolInt]
   451 0000011A E86906                   call genCode16
   452 0000011D 83C402                   add  sp, 2
   453 00000120 E93A00                   jmp @@retn
   454                                  
   455                                  ;-27     genInstruction(0, 1); return;
   456                                  
   457                                  @@process8:
   458 00000123 6A01                     push 1
   459 00000125 6A00                     push 0
   460 00000127 E87D06                   call genInstruction
   461 0000012A 83C404                   add  sp, 4
   462 0000012D E92D00                   jmp @@retn
   463                                  
   464                                  ;-28   }
   465                                  
   466                                  
   467                                  ;-29 
   468                                  
   469                                  
   470                                  ;-30   if (CodeType==101) {// ORG nn
   471                                  
   472                                  @@process7:
   473 00000130 A0[3D00]                 mov al, [CodeType]
   474 00000133 3C65                     cmp al, 101
   475 00000135 0F851B00                 jne @@process9
   476                                  
   477                                  ;-31     if (TokeType != DIGIT) error1("only digit allowed");
   478                                  
   479 00000139 A0[3B00]                 mov al, [TokeType]
   480 0000013C 3C01                     cmp al, 1
   481 0000013E 0F840900                 je  @@process10
   482 00000142 68[5F01]                 push process_0
   483 00000145 E8F216                   call error1
   484 00000148 83C402                   add  sp, 2
   485                                  
   486                                  ;-32     PC=SymbolInt;return;
   487                                  
   488                                  @@process10:
   489 0000014B A1[2500]                 mov ax, [SymbolInt]
   490 0000014E A3[3600]                 mov word [PC], ax
   491 00000151 E90900                   jmp @@retn
   492                                  
   493                                  ;-33   }
   494                                  
   495                                  
   496                                  ;-34   error1("unknown CodeType");
   497                                  
   498                                  @@process9:
   499 00000154 68[7201]                 push process_1
   500 00000157 E8E016                   call error1
   501 0000015A 83C402                   add  sp, 2
   502                                  
   503                                  ;-35 }
   504                                  
   505                                  
   506                                  ;-36 
   507                                  
   508                                  
   509                                  ;-37 // scan code .....................................
   510                                  
   511                                  
   512                                  ;-38 int getTokeType() { char c;
   513                                  
   514 0000015D C9                      @@retn: LEAVE
   515 0000015E C3                       ret
   516                                  ; ENDP
   517 0000015F 6F6E6C792064696769-     process_0 db "only digit allowed",0
   518 00000168 7420616C6C6F776564-
   519 00000171 00                 
   520 00000172 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
   521 0000017B 6F64655479706500   
   522                                  
   523                                  getTokeType:  ; *** PROC ***
   524                                  
   525                                  ;-39   skipBlank();
   526                                  
   527                                  ;Function : getTokeType, Number of local variables: 1
   528                                  ;   # type sign width line used address name   list of local variables
   529                                  ;  200 var sign byte    38 NULL bp-2    c;
   530 00000183 C8020000                 ENTER  2,0
   531 00000187 E8FE0A                   call skipBlank
   532                                  
   533                                  ;-40   c = *InputPtr;
   534                                  
   535 0000018A 8B1E[2700]               mov bx, [InputPtr]
   536 0000018E 8A07                     mov al, [bx]
   537 00000190 B400                     mov ah, 0
   538 00000192 8846FE                   mov byte [bp-2], al
   539                                  
   540                                  ;-41   if (c == 0)   {TokeType=0; return; }//last line or empty line
   541                                  
   542 00000195 8A46FE                   mov al, [bp-2]
   543 00000198 3C00                     cmp al, 0
   544 0000019A 0F850C00                 jne @@getTokeType11
   545 0000019E 66B800000000             mov eax, 0
   546 000001A4 A2[3B00]                 mov byte [TokeType], al
   547 000001A7 E97500                   jmp @@retn
   548                                  
   549                                  ;-42   if (c == ';') {TokeType=0; return; }//comment
   550                                  
   551                                  @@getTokeType11:
   552 000001AA 8A46FE                   mov al, [bp-2]
   553 000001AD 3C3B                     cmp al, 59
   554 000001AF 0F850C00                 jne @@getTokeType12
   555 000001B3 66B800000000             mov eax, 0
   556 000001B9 A2[3B00]                 mov byte [TokeType], al
   557 000001BC E96000                   jmp @@retn
   558                                  
   559                                  ;-43   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
   560                                  
   561                                  @@getTokeType12:
   562 000001BF 8A46FE                   mov al, byte [bp-2]
   563 000001C2 B400                     mov ah, 0
   564 000001C4 50                       push ax
   565 000001C5 E8C51C                   call digit
   566 000001C8 83C402                   add  sp, 2
   567 000001CB 08C0                     or  al, al
   568 000001CD 0F841800                 je @@getTokeType13
   569 000001D1 8A46FE                   mov al, byte [bp-2]
   570 000001D4 B400                     mov ah, 0
   571 000001D6 50                       push ax
   572 000001D7 E8AB0B                   call getDigit
   573 000001DA 83C402                   add  sp, 2
   574 000001DD 66B801000000             mov eax, 1
   575 000001E3 A2[3B00]                 mov byte [TokeType], al
   576 000001E6 E93600                   jmp @@retn
   577                                  
   578                                  ;-44   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
   579                                  
   580                                  @@getTokeType13:
   581 000001E9 8A46FE                   mov al, byte [bp-2]
   582 000001EC B400                     mov ah, 0
   583 000001EE 50                       push ax
   584 000001EF E8C10A                   call letterE
   585 000001F2 83C402                   add  sp, 2
   586 000001F5 08C0                     or  al, al
   587 000001F7 0F841800                 je @@getTokeType14
   588 000001FB 8A46FE                   mov al, byte [bp-2]
   589 000001FE B400                     mov ah, 0
   590 00000200 50                       push ax
   591 00000201 E8D80B                   call getName
   592 00000204 83C402                   add  sp, 2
   593 00000207 66B803000000             mov eax, 3
   594 0000020D A2[3B00]                 mov byte [TokeType], al
   595 00000210 E90C00                   jmp @@retn
   596                                  
   597                                  ;-45   TokeType=NOALNUME; return;
   598                                  
   599                                  @@getTokeType14:
   600 00000213 66B804000000             mov eax, 4
   601 00000219 A2[3B00]                 mov byte [TokeType], al
   602 0000021C E90000                   jmp @@retn
   603                                  
   604                                  ;-46 }
   605                                  
   606                                  
   607                                  ;-47 int Ops() {
   608                                  
   609 0000021F C9                      @@retn: LEAVE
   610 00000220 C3                       ret
   611                                  ; ENDP
   612                                  
   613                                  Ops:  ; *** PROC ***
   614                                  
   615                                  ;-48 //O2=rr,rm,ri,mr,mi
   616                                  
   617                                  
   618                                  ;-49 //NumOprns==2, seg reg not allowed only mov and push
   619                                  
   620                                  
   621                                  ;-50 //size: 1.declaration CodeSize, 2.reg size, 3.error1
   622                                  
   623                                  
   624                                  ;-51 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
   625                                  
   626                                  
   627                                  ;-52 //2. rm , imm 80
   628                                  
   629                                  
   630                                  ;-53 //2a sign ext 83
   631                                  
   632                                  
   633                                  ;-54 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
   634                                  
   635                                  
   636                                  ;-55 //4. rm , reg 00
   637                                  
   638                                  
   639                                  ;-56 //5. error1(mem2mem)
   640                                  
   641                                  
   642                                  ;-57 }
   643                                  
   644                                  
   645                                  ;-58 int LeftOpwCheck() {
   646                                  
   647 00000221 C3                       ret
   648                                  ; ENDP
   649                                  
   650                                  LeftOpwCheck:  ; *** PROC ***
   651                                  
   652                                  ;-59   getLeftOp();
   653                                  
   654 00000222 E8A700                   call getLeftOp
   655                                  
   656                                  ;-60   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
   657                                  
   658 00000225 A0[3E00]                 mov al, [RegType]
   659 00000228 3C04                     cmp al, 4
   660 0000022A 0F850600                 jne @@LeftOpwCheck15
   661 0000022E E80217                   call segregerror
   662 00000231 E95300                   jmp @@retn
   663                                  
   664                                  ;-61   setwflag();
   665                                  
   666                                  @@LeftOpwCheck15:
   667 00000234 E85B01                   call setwflag
   668                                  
   669                                  ;-62   if (OpSize == 0) error1("no op size declared");
   670                                  
   671 00000237 A0[4000]                 mov al, [OpSize]
   672 0000023A 3C00                     cmp al, 0
   673 0000023C 0F850900                 jne @@LeftOpwCheck16
   674 00000240 68[8802]                 push LeftOpwCheck_0
   675 00000243 E8F415                   call error1
   676 00000246 83C402                   add  sp, 2
   677                                  
   678                                  ;-63   if (OpSize == RegType) return;
   679                                  
   680                                  @@LeftOpwCheck16:
   681 00000249 A0[4000]                 mov al, [OpSize]
   682 0000024C 3A06[3E00]               cmp al, [RegType]
   683 00000250 0F850300                 jne @@LeftOpwCheck17
   684 00000254 E93000                   jmp @@retn
   685                                  
   686                                  ;-64   if (OpSize){if (Op1 == IND) return;
   687                                  
   688                                  @@LeftOpwCheck17:
   689 00000257 A0[4000]                 mov al, [OpSize]
   690 0000025A 08C0                     or  al, al
   691 0000025C 0F841500                 je @@LeftOpwCheck18
   692 00000260 A0[3C00]                 mov al, [Op1]
   693 00000263 3C04                     cmp al, 4
   694 00000265 0F850300                 jne @@LeftOpwCheck19
   695 00000269 E91B00                   jmp @@retn
   696                                  
   697                                  ;-65     error1("Conflict OpSize and RegSize"); }
   698                                  
   699                                  @@LeftOpwCheck19:
   700 0000026C 68[9C02]                 push LeftOpwCheck_1
   701 0000026F E8C815                   call error1
   702 00000272 83C402                   add  sp, 2
   703                                  
   704                                  ;-66   if (RegType==0) error1("no register defined");
   705                                  
   706                                  @@LeftOpwCheck18:
   707 00000275 A0[3E00]                 mov al, [RegType]
   708 00000278 3C00                     cmp al, 0
   709 0000027A 0F850900                 jne @@LeftOpwCheck20
   710 0000027E 68[B802]                 push LeftOpwCheck_2
   711 00000281 E8B615                   call error1
   712 00000284 83C402                   add  sp, 2
   713                                  
   714                                  ;-67 }
   715                                  
   716                                  @@LeftOpwCheck20:
   717                                  
   718                                  ;-68 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
   719                                  
   720                                  @@retn:
   721 00000287 C3                       ret
   722                                  ; ENDP
   723 00000288 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
   724 00000291 65206465636C617265-
   725 0000029A 6400               
   726 0000029C 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
   727 000002A5 4F7053697A6520616E-
   728 000002AE 642052656753697A65-
   729 000002B7 00                 
   730 000002B8 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
   731 000002C1 657220646566696E65-
   732 000002CA 6400               
   733                                  
   734                                  getLeftOp:  ; *** PROC ***
   735                                  
   736                                  ;-69 //set: op1, disp->imm, reg, regt->size
   737                                  
   738                                  
   739                                  ;-70   disp=0; imme=0; reg=0;
   740                                  
   741 000002CC 66B800000000             mov eax, 0
   742 000002D2 A3[4500]                 mov word [disp], ax
   743 000002D5 66B800000000             mov eax, 0
   744 000002DB A3[4700]                 mov word [imme], ax
   745 000002DE 66B800000000             mov eax, 0
   746 000002E4 A2[4400]                 mov byte [reg], al
   747                                  
   748                                  ;-71 
   749                                  
   750                                  
   751                                  ;-72   Op1=getOp1();
   752                                  
   753 000002E7 E80301                   call getOp1
   754 000002EA A2[3C00]                 mov byte [Op1], al
   755                                  
   756                                  ;-73   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
   757                                  
   758 000002ED 6A5B                     push 91
   759 000002EF E8F303                   call isToken
   760 000002F2 83C402                   add  sp, 2
   761 000002F5 08C0                     or  al, al
   762 000002F7 0F840F00                 je @@getLeftOp21
   763 000002FB 66B804000000             mov eax, 4
   764 00000301 A2[3C00]                 mov byte [Op1], al
   765 00000304 E86C01                   call getIND
   766 00000307 E95200                   jmp @@retn
   767                                  
   768                                  ;-74   if (Op1 == 0) error1("Name of operand expected");
   769                                  
   770                                  @@getLeftOp21:
   771 0000030A A0[3C00]                 mov al, [Op1]
   772 0000030D 3C00                     cmp al, 0
   773 0000030F 0F850900                 jne @@getLeftOp22
   774 00000313 68[5D03]                 push getLeftOp_0
   775 00000316 E82115                   call error1
   776 00000319 83C402                   add  sp, 2
   777                                  
   778                                  ;-75   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
   779                                  
   780                                  @@getLeftOp22:
   781 0000031C A0[3C00]                 mov al, [Op1]
   782 0000031F 3C01                     cmp al, 1
   783 00000321 0F850900                 jne @@getLeftOp23
   784 00000325 A1[2500]                 mov ax, [SymbolInt]
   785 00000328 A3[4700]                 mov word [imme], ax
   786 0000032B E92E00                   jmp @@retn
   787                                  
   788                                  ;-76   if (Op1 == REG) return;                                    //2
   789                                  
   790                                  @@getLeftOp23:
   791 0000032E A0[3C00]                 mov al, [Op1]
   792 00000331 3C02                     cmp al, 2
   793 00000333 0F850300                 jne @@getLeftOp24
   794 00000337 E92200                   jmp @@retn
   795                                  
   796                                  ;-77   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
   797                                  
   798                                  @@getLeftOp24:
   799 0000033A A0[3C00]                 mov al, [Op1]
   800 0000033D 3C03                     cmp al, 3
   801 0000033F 0F851000                 jne @@getLeftOp25
   802 00000343 8B1E[5200]               mov bx, [LabelIx]
   803 00000347 D1E3                     shl bx, 1
   804 00000349 8B87067B                 mov ax, [LabelAddr + bx]
   805 0000034D A3[4500]                 mov word [disp], ax
   806 00000350 E90900                   jmp @@retn
   807                                  
   808                                  ;-78   error1("Name of operand expected #1");
   809                                  
   810                                  @@getLeftOp25:
   811 00000353 68[7603]                 push getLeftOp_1
   812 00000356 E8E114                   call error1
   813 00000359 83C402                   add  sp, 2
   814                                  
   815                                  ;-79 }
   816                                  
   817                                  
   818                                  ;-80 int setwflag() {//only Op1 (first operand)
   819                                  
   820                                  @@retn:
   821 0000035C C3                       ret
   822                                  ; ENDP
   823 0000035D 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
   824 00000366 706572616E64206578-
   825 0000036F 70656374656400     
   826 00000376 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
   827 0000037F 706572616E64206578-
   828 00000388 706563746564202331-
   829 00000391 00                 
   830                                  
   831                                  setwflag:  ; *** PROC ***
   832                                  
   833                                  ;-81   wflag=0;
   834                                  
   835 00000392 66B800000000             mov eax, 0
   836 00000398 A2[4200]                 mov byte [wflag], al
   837                                  
   838                                  ;-82   if (OpSize == 0) {//do not override OpSize
   839                                  
   840 0000039B A0[4000]                 mov al, [OpSize]
   841 0000039E 3C00                     cmp al, 0
   842 000003A0 0F852100                 jne @@setwflag26
   843                                  
   844                                  ;-83     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
   845                                  
   846 000003A4 A0[3C00]                 mov al, [Op1]
   847 000003A7 3C02                     cmp al, 2
   848 000003A9 0F851800                 jne @@setwflag27
   849 000003AD A0[3E00]                 mov al, [RegType]
   850 000003B0 A2[4000]                 mov byte [OpSize], al
   851 000003B3 A0[3E00]                 mov al, [RegType]
   852 000003B6 3C04                     cmp al, 4
   853 000003B8 0F850900                 jne @@setwflag28
   854 000003BC 66B802000000             mov eax, 2
   855 000003C2 A2[4000]                 mov byte [OpSize], al
   856                                  @@setwflag28:
   857                                  
   858                                  ;-84   }
   859                                  
   860                                  @@setwflag27:
   861                                  
   862                                  ;-85   if (OpSize  == DWORD) {gen66h(); wflag=1;}
   863                                  
   864                                  @@setwflag26:
   865 000003C5 A0[4000]                 mov al, [OpSize]
   866 000003C8 3C03                     cmp al, 3
   867 000003CA 0F850C00                 jne @@setwflag29
   868 000003CE E87A03                   call gen66h
   869 000003D1 66B801000000             mov eax, 1
   870 000003D7 A2[4200]                 mov byte [wflag], al
   871                                  
   872                                  ;-86   if (OpSize  ==  WORD) wflag=1;
   873                                  
   874                                  @@setwflag29:
   875 000003DA A0[4000]                 mov al, [OpSize]
   876 000003DD 3C02                     cmp al, 2
   877 000003DF 0F850900                 jne @@setwflag30
   878 000003E3 66B801000000             mov eax, 1
   879 000003E9 A2[4200]                 mov byte [wflag], al
   880                                  
   881                                  ;-87 }
   882                                  
   883                                  @@setwflag30:
   884                                  
   885                                  ;-88 int getOp1() {//scan for a single operand
   886                                  
   887 000003EC C3                       ret
   888                                  ; ENDP
   889                                  
   890                                  getOp1:  ; *** PROC ***
   891                                  
   892                                  ;-89   //set:Op1, imme, disp, RegType, TegNo, reg
   893                                  
   894                                  
   895                                  ;-90   if (TokeType == 0)      return 0;
   896                                  
   897 000003ED A0[3B00]                 mov al, [TokeType]
   898 000003F0 3C00                     cmp al, 0
   899 000003F2 0F850900                 jne @@getOp131
   900 000003F6 66B800000000             mov eax, 0
   901 000003FC E96000                   jmp @@retn
   902                                  
   903                                  ;-91   if (TokeType == DIGIT)  return IMM;// 1
   904                                  
   905                                  @@getOp131:
   906 000003FF A0[3B00]                 mov al, [TokeType]
   907 00000402 3C01                     cmp al, 1
   908 00000404 0F850900                 jne @@getOp132
   909 00000408 66B801000000             mov eax, 1
   910 0000040E E94E00                   jmp @@retn
   911                                  
   912                                  ;-92   if (TokeType == ALNUME) {
   913                                  
   914                                  @@getOp132:
   915 00000411 A0[3B00]                 mov al, [TokeType]
   916 00000414 3C03                     cmp al, 3
   917 00000416 0F853C00                 jne @@getOp133
   918                                  
   919                                  ;-93     RegNo=testReg();//set global RegType
   920                                  
   921 0000041A E84B0A                   call testReg
   922 0000041D A2[3F00]                 mov byte [RegNo], al
   923                                  
   924                                  ;-94     if (RegType)          return REG;// 2
   925                                  
   926 00000420 A0[3E00]                 mov al, [RegType]
   927 00000423 08C0                     or  al, al
   928 00000425 0F840900                 je @@getOp134
   929 00000429 66B802000000             mov eax, 2
   930 0000042F E92D00                   jmp @@retn
   931                                  
   932                                  ;-95     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];
   933                                  
   934                                  @@getOp134:
   935 00000432 E8EE05                   call searchLabel
   936 00000435 A3[5200]                 mov word [LabelIx], ax
   937                                  
   938                                  ;-96     if (LabelIx)          return DIR;// 3
   939                                  
   940 00000438 A1[5200]                 mov ax, [LabelIx]
   941 0000043B 08C0                     or  al, al
   942 0000043D 0F840C00                 je @@getOp135
   943 00000441 66B803000000             mov eax, 3
   944 00000447 E91500                   jmp @@retn
   945                                  
   946                                  ;-97     else error1("variable not found"); }
   947                                  
   948 0000044A E90900                   jmp @@getOp136
   949                                  @@getOp135:
   950 0000044D 68[6004]                 push getOp1_0
   951 00000450 E8E713                   call error1
   952 00000453 83C402                   add  sp, 2
   953                                  @@getOp136:
   954                                  
   955                                  ;-98   return 0;
   956                                  
   957                                  @@getOp133:
   958 00000456 66B800000000             mov eax, 0
   959 0000045C E90000                   jmp @@retn
   960                                  
   961                                  ;-99 }
   962                                  
   963                                  
   964                                  ;-100 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
   965                                  
   966                                  @@retn:
   967 0000045F C3                       ret
   968                                  ; ENDP
   969 00000460 7661726961626C6520-     getOp1_0 db "variable not found",0
   970 00000469 6E6F7420666F756E64-
   971 00000472 00                 
   972                                  
   973                                  getIND:  ; *** PROC ***
   974                                  
   975                                  ;-101   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
   976                                  
   977                                  ;Function : getIND, Number of local variables: 2
   978                                  ;   # type sign width line used address name   list of local variables
   979                                  ;  200 var sign byte   101 NULL bp-2    op2
   980                                  ;  201 var sign byte   101 NULL bp-4    r1;
   981 00000473 C8040000                 ENTER  4,0
   982 00000477 66B800000000             mov eax, 0
   983 0000047D A3[4500]                 mov word [disp], ax
   984 00000480 66B800000000             mov eax, 0
   985 00000486 8846FC                   mov byte [bp-4], al
   986 00000489 66B800000000             mov eax, 0
   987 0000048F A2[3E00]                 mov byte [RegType], al
   988                                  
   989                                  ;-102   do {
   990                                  
   991                                  @@getIND37:
   992                                  
   993                                  ;-103     getTokeType();
   994                                  
   995 00000492 E8EEFC                   call getTokeType
   996                                  
   997                                  ;-104     op2=getOp1();
   998                                  
   999 00000495 E855FF                   call getOp1
  1000 00000498 8846FE                   mov byte [bp-2], al
  1001                                  
  1002                                  ;-105     if (op2 ==   0) syntaxerror();
  1003                                  
  1004 0000049B 8A46FE                   mov al, [bp-2]
  1005 0000049E 3C00                     cmp al, 0
  1006 000004A0 0F850300                 jne @@getIND38
  1007 000004A4 E8B314                   call syntaxerror
  1008                                  
  1009                                  ;-106     if (op2 == IMM) disp=disp+SymbolInt;
  1010                                  
  1011                                  @@getIND38:
  1012 000004A7 8A46FE                   mov al, [bp-2]
  1013 000004AA 3C01                     cmp al, 1
  1014 000004AC 0F850A00                 jne @@getIND39
  1015 000004B0 A1[4500]                 mov ax, [disp]
  1016 000004B3 0306[2500]               add ax, [SymbolInt]
  1017 000004B7 A3[4500]                 mov word [disp], ax
  1018                                  
  1019                                  ;-107     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
  1020                                  
  1021                                  @@getIND39:
  1022 000004BA 8A46FE                   mov al, [bp-2]
  1023 000004BD 3C02                     cmp al, 2
  1024 000004BF 0F852100                 jne @@getIND40
  1025 000004C3 8A46FC                   mov al, [bp-4]
  1026 000004C6 08C0                     or  al, al
  1027 000004C8 0F841200                 je @@getIND41
  1028 000004CC 8A46FC                   mov al, byte [bp-4]
  1029 000004CF B400                     mov ah, 0
  1030 000004D1 50                       push ax
  1031 000004D2 E80001                   call getIndReg2
  1032 000004D5 83C402                   add  sp, 2
  1033 000004D8 8846FC                   mov byte [bp-4], al
  1034 000004DB E90600                   jmp @@getIND42
  1035                                  @@getIND41:
  1036 000004DE E87F00                   call getIndReg1
  1037 000004E1 8846FC                   mov byte [bp-4], al
  1038                                  
  1039                                  ;-108     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
  1040                                  
  1041                                  @@getIND42:
  1042                                  @@getIND40:
  1043 000004E4 8A46FE                   mov al, [bp-2]
  1044 000004E7 3C03                     cmp al, 3
  1045 000004E9 0F851000                 jne @@getIND43
  1046 000004ED A1[4500]                 mov ax, [disp]
  1047 000004F0 8B1E[5200]               mov bx, [LabelIx]
  1048 000004F4 D1E3                     shl bx, 1
  1049 000004F6 0387067B                 add ax, [LabelAddr + bx]
  1050 000004FA A3[4500]                 mov word [disp], ax
  1051                                  
  1052                                  ;-109     if (isToken('-')) {getTokeType();
  1053                                  
  1054                                  @@getIND43:
  1055 000004FD 6A2D                     push 45
  1056 000004FF E8E301                   call isToken
  1057 00000502 83C402                   add  sp, 2
  1058 00000505 08C0                     or  al, al
  1059 00000507 0F841900                 je @@getIND44
  1060 0000050B E875FC                   call getTokeType
  1061                                  
  1062                                  ;-110       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1063                                  
  1064 0000050E A0[3B00]                 mov al, [TokeType]
  1065 00000511 3C01                     cmp al, 1
  1066 00000513 0F840300                 je  @@getIND45
  1067 00000517 E8D513                   call numbererror
  1068                                  @@getIND45:
  1069 0000051A A1[4500]                 mov ax, [disp]
  1070 0000051D 2B06[2500]               sub ax, [SymbolInt]
  1071 00000521 A3[4500]                 mov word [disp], ax
  1072                                  
  1073                                  ;-111   } while (isToken('+'));
  1074                                  
  1075                                  @@getIND44:
  1076 00000524 6A2B                     push 43
  1077 00000526 E8BC01                   call isToken
  1078 00000529 83C402                   add  sp, 2
  1079 0000052C 08C0                     or  al, al
  1080 0000052E 0F840300                 je @@getIND46
  1081 00000532 E95DFF                   jmp @@getIND37
  1082                                  @@getIND46:
  1083                                  
  1084                                  ;-112   if (isToken(']') == 0) errorexit("] expected");
  1085                                  
  1086 00000535 6A5D                     push 93
  1087 00000537 E8AB01                   call isToken
  1088 0000053A 83C402                   add  sp, 2
  1089 0000053D 83F800                   cmp ax, 0
  1090 00000540 0F850900                 jne @@getIND47
  1091 00000544 68[5505]                 push getIND_0
  1092 00000547 E82114                   call errorexit
  1093 0000054A 83C402                   add  sp, 2
  1094                                  
  1095                                  ;-113   reg=r1;
  1096                                  
  1097                                  @@getIND47:
  1098 0000054D 8A46FC                   mov al, [bp-4]
  1099 00000550 A2[4400]                 mov byte [reg], al
  1100                                  
  1101                                  ;-114 }
  1102                                  
  1103                                  
  1104                                  ;-115 int getIndReg1() {char m; m=0;
  1105 00000553 C9                       LEAVE
  1106 00000554 C3                       ret
  1107                                  ; ENDP
  1108 00000555 5D2065787065637465-     getIND_0 db "] expected",0
  1109 0000055E 6400               
  1110                                  
  1111                                  getIndReg1:  ; *** PROC ***
  1112                                  ;Function : getIndReg1, Number of local variables: 1
  1113                                  ;   # type sign width line used address name   list of local variables
  1114                                  ;  200 var sign byte   115 NULL bp-2    m;
  1115 00000560 C8020000                 ENTER  2,0
  1116 00000564 66B800000000             mov eax, 0
  1117 0000056A 8846FE                   mov byte [bp-2], al
  1118                                  
  1119                                  ;-116   if (RegType !=WORD) indexerror();
  1120                                  
  1121 0000056D A0[3E00]                 mov al, [RegType]
  1122 00000570 3C02                     cmp al, 2
  1123 00000572 0F840300                 je  @@getIndReg148
  1124 00000576 E85513                   call indexerror
  1125                                  
  1126                                  ;-117   if (RegNo==3) m=7;//BX
  1127                                  
  1128                                  @@getIndReg148:
  1129 00000579 A0[3F00]                 mov al, [RegNo]
  1130 0000057C 3C03                     cmp al, 3
  1131 0000057E 0F850900                 jne @@getIndReg149
  1132 00000582 66B807000000             mov eax, 7
  1133 00000588 8846FE                   mov byte [bp-2], al
  1134                                  
  1135                                  ;-118   if (RegNo==5) m=6;//BP change to BP+0
  1136                                  
  1137                                  @@getIndReg149:
  1138 0000058B A0[3F00]                 mov al, [RegNo]
  1139 0000058E 3C05                     cmp al, 5
  1140 00000590 0F850900                 jne @@getIndReg150
  1141 00000594 66B806000000             mov eax, 6
  1142 0000059A 8846FE                   mov byte [bp-2], al
  1143                                  
  1144                                  ;-119   if (RegNo==7) m=5;//DI
  1145                                  
  1146                                  @@getIndReg150:
  1147 0000059D A0[3F00]                 mov al, [RegNo]
  1148 000005A0 3C07                     cmp al, 7
  1149 000005A2 0F850900                 jne @@getIndReg151
  1150 000005A6 66B805000000             mov eax, 5
  1151 000005AC 8846FE                   mov byte [bp-2], al
  1152                                  
  1153                                  ;-120   if (RegNo==6) m=4;//SI
  1154                                  
  1155                                  @@getIndReg151:
  1156 000005AF A0[3F00]                 mov al, [RegNo]
  1157 000005B2 3C06                     cmp al, 6
  1158 000005B4 0F850900                 jne @@getIndReg152
  1159 000005B8 66B804000000             mov eax, 4
  1160 000005BE 8846FE                   mov byte [bp-2], al
  1161                                  
  1162                                  ;-121   if (m    ==0) indexerror();
  1163                                  
  1164                                  @@getIndReg152:
  1165 000005C1 8A46FE                   mov al, [bp-2]
  1166 000005C4 3C00                     cmp al, 0
  1167 000005C6 0F850300                 jne @@getIndReg153
  1168 000005CA E80113                   call indexerror
  1169                                  
  1170                                  ;-122   return m;
  1171                                  
  1172                                  @@getIndReg153:
  1173 000005CD 8A46FE                   mov al, [bp-2]
  1174 000005D0 E90000                   jmp @@retn
  1175                                  
  1176                                  ;-123 }
  1177                                  
  1178                                  
  1179                                  ;-124 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1180                                  
  1181 000005D3 C9                      @@retn: LEAVE
  1182 000005D4 C3                       ret
  1183                                  ; ENDP
  1184                                  
  1185                                  getIndReg2:  ; *** PROC ***
  1186                                  ;Function : getIndReg2, Number of local variables: 2
  1187                                  ;   # type sign width line used address name   list of local variables
  1188                                  ;  200 var sign byte   124 NULL bp+4    r1
  1189                                  ;  201 var sign byte   124 NULL bp-2    m;
  1190 000005D5 C8020000                 ENTER  2,0
  1191 000005D9 66B804000000             mov eax, 4
  1192 000005DF 8846FE                   mov byte [bp-2], al
  1193                                  
  1194                                  ;-125   if (RegType !=WORD) indexerror();
  1195                                  
  1196 000005E2 A0[3E00]                 mov al, [RegType]
  1197 000005E5 3C02                     cmp al, 2
  1198 000005E7 0F840300                 je  @@getIndReg254
  1199 000005EB E8E012                   call indexerror
  1200                                  
  1201                                  ;-126   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1202                                  
  1203                                  @@getIndReg254:
  1204 000005EE A0[3F00]                 mov al, [RegNo]
  1205 000005F1 3C07                     cmp al, 7
  1206 000005F3 0F852700                 jne @@getIndReg255
  1207 000005F7 8A4604                   mov al, [bp+4]
  1208 000005FA 3C06                     cmp al, 6
  1209 000005FC 0F850C00                 jne @@getIndReg256
  1210 00000600 66B803000000             mov eax, 3
  1211 00000606 8846FE                   mov byte [bp-2], al
  1212                                  
  1213                                  ;-127            else if (r1==7) m=1;//BX+DI
  1214                                  
  1215 00000609 E91200                   jmp @@getIndReg257
  1216                                  @@getIndReg256:
  1217 0000060C 8A4604                   mov al, [bp+4]
  1218 0000060F 3C07                     cmp al, 7
  1219 00000611 0F850900                 jne @@getIndReg258
  1220 00000615 66B801000000             mov eax, 1
  1221 0000061B 8846FE                   mov byte [bp-2], al
  1222                                  
  1223                                  ;-128   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1224                                  
  1225                                  @@getIndReg258:
  1226                                  @@getIndReg257:
  1227                                  @@getIndReg255:
  1228 0000061E A0[3F00]                 mov al, [RegNo]
  1229 00000621 3C06                     cmp al, 6
  1230 00000623 0F852700                 jne @@getIndReg259
  1231 00000627 8A4604                   mov al, [bp+4]
  1232 0000062A 3C06                     cmp al, 6
  1233 0000062C 0F850C00                 jne @@getIndReg260
  1234 00000630 66B802000000             mov eax, 2
  1235 00000636 8846FE                   mov byte [bp-2], al
  1236                                  
  1237                                  ;-129            else if (r1==7) m=0;//BX+DI
  1238                                  
  1239 00000639 E91200                   jmp @@getIndReg261
  1240                                  @@getIndReg260:
  1241 0000063C 8A4604                   mov al, [bp+4]
  1242 0000063F 3C07                     cmp al, 7
  1243 00000641 0F850900                 jne @@getIndReg262
  1244 00000645 66B800000000             mov eax, 0
  1245 0000064B 8846FE                   mov byte [bp-2], al
  1246                                  
  1247                                  ;-130   if (m > 3) indexerror();
  1248                                  
  1249                                  @@getIndReg262:
  1250                                  @@getIndReg261:
  1251                                  @@getIndReg259:
  1252 0000064E 8A46FE                   mov al, [bp-2]
  1253 00000651 3C03                     cmp al, 3
  1254 00000653 0F8E0300                 jle @@getIndReg263
  1255 00000657 E87412                   call indexerror
  1256                                  
  1257                                  ;-131   return m;
  1258                                  
  1259                                  @@getIndReg263:
  1260 0000065A 8A46FE                   mov al, [bp-2]
  1261 0000065D E90000                   jmp @@retn
  1262                                  
  1263                                  ;-132 }
  1264                                  
  1265                                  
  1266                                  ;-133 
  1267                                  
  1268                                  
  1269                                  ;-134 int getCodeSize() {
  1270                                  
  1271 00000660 C9                      @@retn: LEAVE
  1272 00000661 C3                       ret
  1273                                  ; ENDP
  1274                                  
  1275                                  getCodeSize:  ; *** PROC ***
  1276                                  
  1277                                  ;-135   if (TokeType ==ALNUME) {
  1278                                  
  1279 00000662 A0[3B00]                 mov al, [TokeType]
  1280 00000665 3C03                     cmp al, 3
  1281 00000667 0F856000                 jne @@getCodeSize64
  1282                                  
  1283                                  ;-136     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1284                                  
  1285 0000066B 68[D506]                 push getCodeSize_0
  1286 0000066E 8D068075                 lea  ax, [SymbolUpper]
  1287 00000672 50                       push ax
  1288 00000673 E84A18                   call eqstr
  1289 00000676 83C404                   add  sp, 4
  1290 00000679 08C0                     or  al, al
  1291 0000067B 0F840C00                 je @@getCodeSize65
  1292 0000067F E801FB                   call getTokeType
  1293 00000682 66B801000000             mov eax, 1
  1294 00000688 E94900                   jmp @@retn
  1295                                  
  1296                                  ;-137     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1297                                  
  1298                                  @@getCodeSize65:
  1299 0000068B 68[DA06]                 push getCodeSize_1
  1300 0000068E 8D068075                 lea  ax, [SymbolUpper]
  1301 00000692 50                       push ax
  1302 00000693 E82A18                   call eqstr
  1303 00000696 83C404                   add  sp, 4
  1304 00000699 08C0                     or  al, al
  1305 0000069B 0F840C00                 je @@getCodeSize66
  1306 0000069F E8E1FA                   call getTokeType
  1307 000006A2 66B802000000             mov eax, 2
  1308 000006A8 E92900                   jmp @@retn
  1309                                  
  1310                                  ;-138     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1311                                  
  1312                                  @@getCodeSize66:
  1313 000006AB 68[DF06]                 push getCodeSize_2
  1314 000006AE 8D068075                 lea  ax, [SymbolUpper]
  1315 000006B2 50                       push ax
  1316 000006B3 E80A18                   call eqstr
  1317 000006B6 83C404                   add  sp, 4
  1318 000006B9 08C0                     or  al, al
  1319 000006BB 0F840C00                 je @@getCodeSize67
  1320 000006BF E8C1FA                   call getTokeType
  1321 000006C2 66B803000000             mov eax, 3
  1322 000006C8 E90900                   jmp @@retn
  1323                                  
  1324                                  ;-139   } return 0;
  1325                                  
  1326                                  @@getCodeSize67:
  1327                                  @@getCodeSize64:
  1328 000006CB 66B800000000             mov eax, 0
  1329 000006D1 E90000                   jmp @@retn
  1330                                  
  1331                                  ;-140 }
  1332                                  
  1333                                  
  1334                                  ;-141 int isToken(char c) {
  1335                                  
  1336                                  @@retn:
  1337 000006D4 C3                       ret
  1338                                  ; ENDP
  1339 000006D5 4259544500              getCodeSize_0 db "BYTE",0
  1340 000006DA 574F524400              getCodeSize_1 db "WORD",0
  1341 000006DF 44574F524400            getCodeSize_2 db "DWORD",0
  1342                                  
  1343                                  isToken:  ; *** PROC ***
  1344                                  
  1345                                  ;-142   skipBlank();
  1346                                  
  1347                                  ;Function : isToken, Number of local variables: 1
  1348                                  ;   # type sign width line used address name   list of local variables
  1349                                  ;  200 var sign byte   141 NULL bp+4    c;
  1350 000006E5 C8000000                 ENTER  0,0
  1351 000006E9 E89C05                   call skipBlank
  1352                                  
  1353                                  ;-143   if (*InputPtr == c) {
  1354                                  
  1355 000006EC 8B1E[2700]               mov bx, [InputPtr]
  1356 000006F0 8A07                     mov al, [bx]
  1357 000006F2 B400                     mov ah, 0
  1358 000006F4 3A4604                   cmp al, [bp+4]
  1359 000006F7 0F850D00                 jne @@isToken68
  1360                                  
  1361                                  ;-144     InputPtr++; return 1;} return 0;
  1362                                  
  1363 000006FB FF06[2700]               inc  word [InputPtr]
  1364 000006FF 66B801000000             mov eax, 1
  1365 00000705 E90900                   jmp @@retn
  1366                                  @@isToken68:
  1367 00000708 66B800000000             mov eax, 0
  1368 0000070E E90000                   jmp @@retn
  1369                                  
  1370                                  ;-145 }
  1371                                  
  1372                                  
  1373                                  ;-146 int skipRest() {
  1374                                  
  1375 00000711 C9                      @@retn: LEAVE
  1376 00000712 C3                       ret
  1377                                  ; ENDP
  1378                                  
  1379                                  skipRest:  ; *** PROC ***
  1380                                  
  1381                                  ;-147   getTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");
  1382                                  
  1383 00000713 E86DFA                   call getTokeType
  1384 00000716 A0[3B00]                 mov al, [TokeType]
  1385 00000719 3C00                     cmp al, 0
  1386 0000071B 0F840900                 je  @@skipRest69
  1387 0000071F 68[2907]                 push skipRest_0
  1388 00000722 E8B80F                   call prs
  1389 00000725 83C402                   add  sp, 2
  1390                                  
  1391                                  ;-148 }
  1392                                  
  1393                                  @@skipRest69:
  1394                                  
  1395                                  ;-149 // generate code ...........................................................
  1396                                  
  1397                                  
  1398                                  ;-150 int gen66h() {genCode8(0x66);}
  1399                                  
  1400 00000728 C3                       ret
  1401                                  ; ENDP
  1402 00000729 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ********** extra char ignored",0
  1403 00000732 2A2A2A2A2A20657874-
  1404 0000073B 726120636861722069-
  1405 00000744 676E6F72656400     
  1406                                  
  1407                                  gen66h:  ; *** PROC ***
  1408 0000074B 6A66                     push 102
  1409 0000074D E80400                   call genCode8
  1410 00000750 83C402                   add  sp, 2
  1411                                  
  1412                                  ;-151 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1413                                  
  1414 00000753 C3                       ret
  1415                                  ; ENDP
  1416                                  
  1417                                  genCode8:  ; *** PROC ***
  1418                                  
  1419                                  ;-152   FileBin[BinLen]=c; BinLen++; PC++;
  1420                                  
  1421                                  ;Function : genCode8, Number of local variables: 1
  1422                                  ;   # type sign width line used address name   list of local variables
  1423                                  ;  200 var sign byte   151 NULL bp+4    c;
  1424 00000754 C8000000                 ENTER  0,0
  1425 00000758 8A4604                   mov al, [bp+4]
  1426 0000075B 8B1E[5400]               mov bx, [BinLen]
  1427 0000075F 8887CE7B                 mov [FileBin+bx], al
  1428 00000763 FF06[5400]               inc  word [BinLen]
  1429 00000767 FF06[3600]               inc  word [PC]
  1430                                  
  1431                                  ;-153   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1432                                  
  1433 0000076B A1[4900]                 mov ax, [OpPrintIndex]
  1434 0000076E 83F805                   cmp ax, 5
  1435 00000771 0F8D0F00                 jge @@genCode870
  1436 00000775 8A4604                   mov al, [bp+4]
  1437 00000778 8B1E[4900]               mov bx, [OpPrintIndex]
  1438 0000077C 88871977                 mov [OpPos+bx], al
  1439 00000780 FF06[4900]               inc  word [OpPrintIndex]
  1440                                  
  1441                                  ;-154 }
  1442                                  
  1443                                  @@genCode870:
  1444                                  
  1445                                  ;-155 int genCode16(int i) {
  1446 00000784 C9                       LEAVE
  1447 00000785 C3                       ret
  1448                                  ; ENDP
  1449                                  
  1450                                  genCode16:  ; *** PROC ***
  1451                                  
  1452                                  ;-156   genCode8(i); i=i >> 8; genCode8(i);
  1453                                  
  1454                                  ;Function : genCode16, Number of local variables: 1
  1455                                  ;   # type sign width line used address name   list of local variables
  1456                                  ;  200 var sign word   155 NULL bp+4    i;
  1457 00000786 C8000000                 ENTER  0,0
  1458 0000078A FF7604                   push word [bp+4]
  1459 0000078D E8C4FF                   call genCode8
  1460 00000790 83C402                   add  sp, 2
  1461 00000793 8B4604                   mov ax, [bp+4]
  1462 00000796 C1E808                   shr ax, 8
  1463 00000799 894604                   mov word [bp+4], ax
  1464 0000079C FF7604                   push word [bp+4]
  1465 0000079F E8B2FF                   call genCode8
  1466 000007A2 83C402                   add  sp, 2
  1467                                  
  1468                                  ;-157 }
  1469                                  
  1470                                  
  1471                                  ;-158 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1472 000007A5 C9                       LEAVE
  1473 000007A6 C3                       ret
  1474                                  ; ENDP
  1475                                  
  1476                                  genInstruction:  ; *** PROC ***
  1477                                  
  1478                                  ;-159   if(loc) OpCodePtr=OpCodePtr+loc;
  1479                                  
  1480                                  ;Function : genInstruction, Number of local variables: 3
  1481                                  ;   # type sign width line used address name   list of local variables
  1482                                  ;  200 var sign byte   158 NULL bp+4    No
  1483                                  ;  201 var sign word   158 NULL bp+6    loc
  1484                                  ;  202 var sign byte   158 NULL bp-2    c;
  1485 000007A7 C8020000                 ENTER  2,0
  1486 000007AB 8B4606                   mov ax, [bp+6]
  1487 000007AE 08C0                     or  al, al
  1488 000007B0 0F840900                 je @@genInstruction71
  1489 000007B4 A1[4B00]                 mov ax, [OpCodePtr]
  1490 000007B7 034606                   add ax, [bp+6]
  1491 000007BA A3[4B00]                 mov word [OpCodePtr], ax
  1492                                  
  1493                                  ;-160   c= *OpCodePtr + No; genCode8(c);
  1494                                  
  1495                                  @@genInstruction71:
  1496 000007BD 8B1E[4B00]               mov bx, [OpCodePtr]
  1497 000007C1 8A07                     mov al, [bx]
  1498 000007C3 B400                     mov ah, 0
  1499 000007C5 024604                   add al, [bp+4]
  1500 000007C8 8846FE                   mov byte [bp-2], al
  1501 000007CB 8A46FE                   mov al, byte [bp-2]
  1502 000007CE B400                     mov ah, 0
  1503 000007D0 50                       push ax
  1504 000007D1 E880FF                   call genCode8
  1505 000007D4 83C402                   add  sp, 2
  1506                                  
  1507                                  ;-161 }
  1508                                  
  1509                                  
  1510                                  ;-162 int genCodeInREG() {char x; //get Code for second byte
  1511 000007D7 C9                       LEAVE
  1512 000007D8 C3                       ret
  1513                                  ; ENDP
  1514                                  
  1515                                  genCodeInREG:  ; *** PROC ***
  1516                                  
  1517                                  ;-163   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1518                                  
  1519                                  ;Function : genCodeInREG, Number of local variables: 1
  1520                                  ;   # type sign width line used address name   list of local variables
  1521                                  ;  200 var sign byte   162 NULL bp-2    x;
  1522 000007D9 C8020000                 ENTER  2,0
  1523 000007DD FF06[4B00]               inc  word [OpCodePtr]
  1524 000007E1 8B1E[4B00]               mov bx, [OpCodePtr]
  1525 000007E5 8A07                     mov al, [bx]
  1526 000007E7 B400                     mov ah, 0
  1527 000007E9 8846FE                   mov byte [bp-2], al
  1528 000007EC 8A46FE                   mov al, byte [bp-2]
  1529 000007EF B400                     mov ah, 0
  1530 000007F1 50                       push ax
  1531 000007F2 E81200                   call writeEA
  1532 000007F5 83C402                   add  sp, 2
  1533                                  
  1534                                  ;-164 }
  1535                                  
  1536                                  
  1537                                  ;-165 int genModRegRM(){ writeEA(reg);//todo
  1538 000007F8 C9                       LEAVE
  1539 000007F9 C3                       ret
  1540                                  ; ENDP
  1541                                  
  1542                                  genModRegRM:  ; *** PROC ***
  1543 000007FA A0[4400]                 mov al, byte [reg]
  1544 000007FD B400                     mov ah, 0
  1545 000007FF 50                       push ax
  1546 00000800 E80400                   call writeEA
  1547 00000803 83C402                   add  sp, 2
  1548                                  
  1549                                  ;-166 }
  1550                                  
  1551                                  
  1552                                  ;-167 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  1553                                  
  1554 00000806 C3                       ret
  1555                                  ; ENDP
  1556                                  
  1557                                  writeEA:  ; *** PROC ***
  1558                                  
  1559                                  ;-168   len=0;
  1560                                  
  1561                                  ;Function : writeEA, Number of local variables: 2
  1562                                  ;   # type sign width line used address name   list of local variables
  1563                                  ;  200 var sign byte   167 NULL bp+4    xxx
  1564                                  ;  201 var sign byte   167 NULL bp-2    len;
  1565 00000807 C8020000                 ENTER  2,0
  1566 0000080B 66B800000000             mov eax, 0
  1567 00000811 8846FE                   mov byte [bp-2], al
  1568                                  
  1569                                  ;-169   xxx = xxx << 3;//in reg field of mod r/m
  1570                                  
  1571 00000814 8A4604                   mov al, [bp+4]
  1572 00000817 C0E003                   shl al, 3
  1573 0000081A 884604                   mov byte [bp+4], al
  1574                                  
  1575                                  ;-170   if (Op1 ==   0) addrexit();
  1576                                  
  1577 0000081D A0[3C00]                 mov al, [Op1]
  1578 00000820 3C00                     cmp al, 0
  1579 00000822 0F850300                 jne @@writeEA72
  1580 00000826 E85911                   call addrexit
  1581                                  
  1582                                  ;-171   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  1583                                  
  1584                                  @@writeEA72:
  1585 00000829 A0[3C00]                 mov al, [Op1]
  1586 0000082C 3C02                     cmp al, 2
  1587 0000082E 0F850E00                 jne @@writeEA73
  1588 00000832 804E04C0                 or  byte [bp+4], 192
  1589 00000836 8A4604                   mov al, [bp+4]
  1590 00000839 0206[3F00]               add al, [RegNo]
  1591 0000083D 884604                   mov byte [bp+4], al
  1592                                  
  1593                                  ;-172   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  1594                                  
  1595                                  @@writeEA73:
  1596 00000840 A0[3C00]                 mov al, [Op1]
  1597 00000843 3C03                     cmp al, 3
  1598 00000845 0F850D00                 jne @@writeEA74
  1599 00000849 804E0406                 or  byte [bp+4], 6
  1600 0000084D 66B802000000             mov eax, 2
  1601 00000853 8846FE                   mov byte [bp-2], al
  1602                                  
  1603                                  ;-173   if (Op1 == IND) { xxx = xxx + reg;                       //4
  1604                                  
  1605                                  @@writeEA74:
  1606 00000856 A0[3C00]                 mov al, [Op1]
  1607 00000859 3C04                     cmp al, 4
  1608 0000085B 0F854600                 jne @@writeEA75
  1609 0000085F 8A4604                   mov al, [bp+4]
  1610 00000862 0206[4400]               add al, [reg]
  1611 00000866 884604                   mov byte [bp+4], al
  1612                                  
  1613                                  ;-174     if (disp) {disp; if(ax > 127) len=2; else len=1;
  1614                                  
  1615 00000869 A1[4500]                 mov ax, [disp]
  1616 0000086C 08C0                     or  al, al
  1617 0000086E 0F843300                 je @@writeEA76
  1618 00000872 A1[4500]                 mov ax, [disp]
  1619 00000875 83F87F                   cmp  ax, 127
  1620 00000878 0F8E0C00                 jle @@writeEA77
  1621 0000087C 66B802000000             mov eax, 2
  1622 00000882 8846FE                   mov byte [bp-2], al
  1623 00000885 E90900                   jmp @@writeEA78
  1624                                  @@writeEA77:
  1625 00000888 66B801000000             mov eax, 1
  1626 0000088E 8846FE                   mov byte [bp-2], al
  1627                                  
  1628                                  ;-175       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  1629                                  
  1630                                  @@writeEA78:
  1631 00000891 8A46FE                   mov al, [bp-2]
  1632 00000894 3C01                     cmp al, 1
  1633 00000896 0F850700                 jne @@writeEA79
  1634 0000089A 804E0440                 or  byte [bp+4], 64
  1635 0000089E E90400                   jmp @@writeEA80
  1636                                  @@writeEA79:
  1637 000008A1 804E0480                 or  byte [bp+4], 128
  1638                                  @@writeEA80:
  1639                                  
  1640                                  ;-176     }
  1641                                  
  1642                                  @@writeEA76:
  1643                                  
  1644                                  ;-177   genCode8(xxx);// gen second byte
  1645                                  
  1646                                  @@writeEA75:
  1647 000008A5 8A4604                   mov al, byte [bp+4]
  1648 000008A8 B400                     mov ah, 0
  1649 000008AA 50                       push ax
  1650 000008AB E8A6FE                   call genCode8
  1651 000008AE 83C402                   add  sp, 2
  1652                                  
  1653                                  ;-178   if (len == 1) genCode8 (disp);
  1654                                  
  1655 000008B1 8A46FE                   mov al, [bp-2]
  1656 000008B4 3C01                     cmp al, 1
  1657 000008B6 0F850A00                 jne @@writeEA81
  1658 000008BA FF36[4500]               push word [disp]
  1659 000008BE E893FE                   call genCode8
  1660 000008C1 83C402                   add  sp, 2
  1661                                  
  1662                                  ;-179   if (len == 2) genCode16(disp);
  1663                                  
  1664                                  @@writeEA81:
  1665 000008C4 8A46FE                   mov al, [bp-2]
  1666 000008C7 3C02                     cmp al, 2
  1667 000008C9 0F850A00                 jne @@writeEA82
  1668 000008CD FF36[4500]               push word [disp]
  1669 000008D1 E8B2FE                   call genCode16
  1670 000008D4 83C402                   add  sp, 2
  1671                                  
  1672                                  ;-180 }
  1673                                  
  1674                                  @@writeEA82:
  1675                                  
  1676                                  ;-181 int test1() { __asm {
  1677 000008D7 C9                       LEAVE
  1678 000008D8 C3                       ret
  1679                                  ; ENDP
  1680                                  
  1681                                  test1:  ; *** PROC ***
  1682                                  
  1683                                  
  1684                                  ;-182 inc byte [Version1]   ;FE 06 [1000]
  1685                                  
  1686 000008D9 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  1687                                  
  1688                                  ;-183 add bx, ax    ;01 C3
  1689                                  
  1690 000008DD 01C3                    add bx, ax    ;01 C3
  1691                                  
  1692                                  ;-184 add ax, bx    ;01 D8
  1693                                  
  1694 000008DF 01D8                    add ax, bx    ;01 D8
  1695                                  
  1696                                  ;-185 add word ax, [bx] ;03 07
  1697                                  
  1698 000008E1 0307                    add word ax, [bx] ;03 07
  1699                                  
  1700                                  ;-186 VA dw 8
  1701                                  
  1702 000008E3 0800                    VA dw 8
  1703                                  
  1704                                  ;-187 mov byte [bp- 4], al ;88 46 FC
  1705                                  
  1706 000008E5 8846FC                  mov byte [bp- 4], al ;88 46 FC
  1707                                  
  1708                                  ;-188 mov      [VA+bx], al ;88 87 [300F]
  1709                                  
  1710 000008E8 8887[E308]              mov      [VA+bx], al ;88 87 [300F]
  1711                                  
  1712                                  ;-189 }  }
  1713                                  
  1714                                  
  1715                                  
  1716                                  ;-190 #include "AS1.C"
  1717                                  
  1718 000008EC C3                       ret
  1719                                  ; ENDP
  1720                                  ;Use include file: AS1.C
  1721                                  
  1722                                  ;-1 //AS1.C  5.12.2014  BAS,  AS TE
  1723                                  
  1724                                  
  1725                                  ;-2 int parse() {
  1726                                  
  1727                                  
  1728                                  parse:  ; *** PROC ***
  1729                                  
  1730                                  ;-3   LabelNamePtr= &LabelNames;
  1731                                  
  1732 000008ED B81E77                   mov ax, LabelNames
  1733 000008F0 A3[4E00]                 mov word [LabelNamePtr], ax
  1734                                  
  1735                                  ;-4   do {
  1736                                  
  1737                                  @@parse83:
  1738                                  
  1739                                  ;-5     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  1740                                  
  1741 000008F3 A1[3600]                 mov ax, [PC]
  1742 000008F6 A3[3800]                 mov word [PCStart], ax
  1743 000008F9 66B800000000             mov eax, 0
  1744 000008FF A2[4000]                 mov byte [OpSize], al
  1745 00000902 66B800000000             mov eax, 0
  1746 00000908 A3[4900]                 mov word [OpPrintIndex], ax
  1747 0000090B 66B820000000             mov eax, 32
  1748 00000911 A2[4D00]                 mov byte [PrReloc], al
  1749                                  
  1750                                  ;-6     getLine();
  1751                                  
  1752 00000914 E8A402                   call getLine
  1753                                  
  1754                                  ;-7     InputPtr = &InputBuf;
  1755                                  
  1756 00000917 B8D075                   mov ax, InputBuf
  1757 0000091A A3[2700]                 mov word [InputPtr], ax
  1758                                  
  1759                                  ;-8     getTokeType();// getCode in SymbolUpper,set TokeType,set isLabel by getName
  1760                                  
  1761 0000091D E863F8                   call getTokeType
  1762                                  
  1763                                  ;-9     if (TokeType == ALNUME) {
  1764                                  
  1765 00000920 A0[3B00]                 mov al, [TokeType]
  1766 00000923 3C03                     cmp al, 3
  1767 00000925 0F851300                 jne @@parse84
  1768                                  
  1769                                  ;-10       if (isLabel) { //set in getName
  1770                                  
  1771 00000929 A0[3A00]                 mov al, [isLabel]
  1772 0000092C 08C0                     or  al, al
  1773 0000092E 0F840A00                 je @@parse85
  1774                                  
  1775                                  ;-11         storeLabel();
  1776                                  
  1777 00000932 E8A300                   call storeLabel
  1778                                  
  1779                                  ;-12         InputPtr++;//remove :
  1780                                  
  1781 00000935 FF06[2700]               inc  word [InputPtr]
  1782                                  
  1783                                  ;-13         getTokeType();
  1784                                  
  1785 00000939 E847F8                   call getTokeType
  1786                                  
  1787                                  ;-14       }
  1788                                  
  1789                                  
  1790                                  ;-15     }
  1791                                  
  1792                                  @@parse85:
  1793                                  
  1794                                  ;-16     if (TokeType == ALNUME) {
  1795                                  
  1796                                  @@parse84:
  1797 0000093C A0[3B00]                 mov al, [TokeType]
  1798 0000093F 3C03                     cmp al, 3
  1799 00000941 0F851B00                 jne @@parse86
  1800                                  
  1801                                  ;-17       lookCode();// and OpCodePtr
  1802                                  
  1803 00000945 E80D0C                   call lookCode
  1804                                  
  1805                                  ;-18       if(CodeType) process();
  1806                                  
  1807 00000948 A0[3D00]                 mov al, [CodeType]
  1808 0000094B 08C0                     or  al, al
  1809 0000094D 0F840600                 je @@parse87
  1810 00000951 E806F7                   call process
  1811                                  
  1812                                  ;-19       else getVariable();
  1813                                  
  1814 00000954 E90300                   jmp @@parse88
  1815                                  @@parse87:
  1816 00000957 E82901                   call getVariable
  1817                                  
  1818                                  ;-20       skipRest();
  1819                                  
  1820                                  @@parse88:
  1821 0000095A E8B6FD                   call skipRest
  1822                                  
  1823                                  ;-21     }
  1824                                  
  1825                                  
  1826                                  ;-22     else if (TokeType >  ALNUME) error1("Label or instruction expected");
  1827                                  
  1828 0000095D E92700                   jmp @@parse89
  1829                                  @@parse86:
  1830 00000960 A0[3B00]                 mov al, [TokeType]
  1831 00000963 3C03                     cmp al, 3
  1832 00000965 0F8E0C00                 jle @@parse90
  1833 00000969 68[9809]                 push parse_0
  1834 0000096C E8CB0E                   call error1
  1835 0000096F 83C402                   add  sp, 2
  1836                                  
  1837                                  ;-23     else if (TokeType == DIGIT) error1("No digit allowed at start of line");
  1838                                  
  1839 00000972 E91200                   jmp @@parse91
  1840                                  @@parse90:
  1841 00000975 A0[3B00]                 mov al, [TokeType]
  1842 00000978 3C01                     cmp al, 1
  1843 0000097A 0F850900                 jne @@parse92
  1844 0000097E 68[B609]                 push parse_1
  1845 00000981 E8B60E                   call error1
  1846 00000984 83C402                   add  sp, 2
  1847                                  
  1848                                  ;-24     printLine();
  1849                                  
  1850                                  @@parse92:
  1851                                  @@parse91:
  1852                                  @@parse89:
  1853 00000987 E8450C                   call printLine
  1854                                  
  1855                                  ;-25   } while (DOS_NoBytes != 0 );
  1856                                  
  1857 0000098A A1[3300]                 mov ax, [DOS_NoBytes]
  1858 0000098D 83F800                   cmp ax, 0
  1859 00000990 0F840300                 je  @@parse93
  1860 00000994 E95CFF                   jmp @@parse83
  1861                                  @@parse93:
  1862                                  
  1863                                  ;-26 }
  1864                                  
  1865                                  
  1866                                  ;-27 int storeLabel() {
  1867                                  
  1868 00000997 C3                       ret
  1869                                  ; ENDP
  1870 00000998 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1871 000009A1 696E73747275637469-
  1872 000009AA 6F6E20657870656374-
  1873 000009B3 656400             
  1874 000009B6 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  1875 000009BF 616C6C6F7765642061-
  1876 000009C8 74207374617274206F-
  1877 000009D1 66206C696E6500     
  1878                                  
  1879                                  storeLabel:  ; *** PROC ***
  1880                                  
  1881                                  ;-28   if(searchLabel()) error1("duplicate symbol");
  1882                                  
  1883 000009D8 E84800                   call searchLabel
  1884 000009DB 08C0                     or  al, al
  1885 000009DD 0F840900                 je @@storeLabel94
  1886 000009E1 68[120A]                 push storeLabel_0
  1887 000009E4 E8530E                   call error1
  1888 000009E7 83C402                   add  sp, 2
  1889                                  
  1890                                  ;-29   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1891                                  
  1892                                  @@storeLabel94:
  1893 000009EA 8D063075                 lea  ax, [Symbol]
  1894 000009EE 50                       push ax
  1895 000009EF FF36[4E00]               push word [LabelNamePtr]
  1896 000009F3 E85E14                   call strcpy
  1897 000009F6 83C404                   add  sp, 4
  1898 000009F9 A3[4E00]                 mov word [LabelNamePtr], ax
  1899                                  
  1900                                  ;-30   LabelNamePtr++;
  1901                                  
  1902 000009FC FF06[4E00]               inc  word [LabelNamePtr]
  1903                                  
  1904                                  ;-31   LabelMaxIx++;
  1905                                  
  1906 00000A00 FF06[5000]               inc  word [LabelMaxIx]
  1907                                  
  1908                                  ;-32   LabelAddr[LabelMaxIx] = PC;
  1909                                  
  1910 00000A04 A1[3600]                 mov ax, [PC]
  1911 00000A07 8B1E[5000]               mov bx, [LabelMaxIx]
  1912 00000A0B D1E3                     shl bx, 1
  1913 00000A0D 8987067B                 mov [LabelAddr+bx], ax
  1914                                  
  1915                                  ;-33 }
  1916                                  
  1917                                  
  1918                                  ;-34 int searchLabel() {
  1919                                  
  1920 00000A11 C3                       ret
  1921                                  ; ENDP
  1922 00000A12 6475706C6963617465-     storeLabel_0 db "duplicate symbol",0
  1923 00000A1B 2073796D626F6C00   
  1924                                  
  1925                                  searchLabel:  ; *** PROC ***
  1926                                  
  1927                                  ;-35   int LIx; char *p; int j;
  1928                                  
  1929                                  
  1930                                  ;-36   p = &LabelNames;
  1931                                  
  1932                                  ;Function : searchLabel, Number of local variables: 3
  1933                                  ;   # type sign width line used address name   list of local variables
  1934                                  ;  200 var sign word    35 NULL bp-2    LIx
  1935                                  ;  201 ptr sign byte    35 NULL bp-4    p
  1936                                  ;  202 var sign word    35 NULL bp-6    j;
  1937 00000A23 C8060000                 ENTER  6,0
  1938 00000A27 B81E77                   mov ax, LabelNames
  1939 00000A2A 8946FC                   mov word [bp-4], ax
  1940                                  
  1941                                  ;-37   LIx=1;
  1942                                  
  1943 00000A2D 66B801000000             mov eax, 1
  1944 00000A33 8946FE                   mov word [bp-2], ax
  1945                                  
  1946                                  ;-38   while (LIx <= LabelMaxIx) {
  1947                                  
  1948                                  @@searchLabel95:
  1949 00000A36 8B46FE                   mov ax, [bp-2]
  1950 00000A39 3B06[5000]               cmp ax, [LabelMaxIx]
  1951 00000A3D 0F8F3700                 jg  @@searchLabel96
  1952                                  
  1953                                  ;-39     if (eqstr(p, Symbol)) return LIx;//and searchType
  1954                                  
  1955 00000A41 8D063075                 lea  ax, [Symbol]
  1956 00000A45 50                       push ax
  1957 00000A46 FF76FC                   push word [bp-4]
  1958 00000A49 E87414                   call eqstr
  1959 00000A4C 83C404                   add  sp, 4
  1960 00000A4F 08C0                     or  al, al
  1961 00000A51 0F840600                 je @@searchLabel97
  1962 00000A55 8B46FE                   mov ax, [bp-2]
  1963 00000A58 E92600                   jmp @@retn
  1964                                  
  1965                                  ;-40     j=strlen(p);
  1966                                  
  1967                                  @@searchLabel97:
  1968 00000A5B FF76FC                   push word [bp-4]
  1969 00000A5E E8C813                   call strlen
  1970 00000A61 83C402                   add  sp, 2
  1971 00000A64 8946FA                   mov word [bp-6], ax
  1972                                  
  1973                                  ;-41     p=p+j; p++; LIx++;
  1974                                  
  1975 00000A67 8B46FC                   mov ax, [bp-4]
  1976 00000A6A 0346FA                   add ax, [bp-6]
  1977 00000A6D 8946FC                   mov word [bp-4], ax
  1978 00000A70 FF46FC                   inc  word [bp-4]
  1979 00000A73 FF46FE                   inc  word [bp-2]
  1980                                  
  1981                                  ;-42   }
  1982                                  
  1983                                  
  1984                                  ;-43   return 0;
  1985                                  
  1986 00000A76 EBBE                     jmp @@searchLabel95
  1987                                  @@searchLabel96:
  1988 00000A78 66B800000000             mov eax, 0
  1989 00000A7E E90000                   jmp @@retn
  1990                                  
  1991                                  ;-44 }
  1992                                  
  1993                                  
  1994                                  ;-45 int getVariable() { char c;
  1995                                  
  1996 00000A81 C9                      @@retn: LEAVE
  1997 00000A82 C3                       ret
  1998                                  ; ENDP
  1999                                  
  2000                                  getVariable:  ; *** PROC ***
  2001                                  
  2002                                  ;-46   storeLabel();
  2003                                  
  2004                                  ;Function : getVariable, Number of local variables: 1
  2005                                  ;   # type sign width line used address name   list of local variables
  2006                                  ;  200 var sign byte    45 NULL bp-2    c;
  2007 00000A83 C8020000                 ENTER  2,0
  2008 00000A87 E84EFF                   call storeLabel
  2009                                  
  2010                                  ;-47   getTokeType(); if(TokeType==ALNUME) {// getName
  2011                                  
  2012 00000A8A E8F6F6                   call getTokeType
  2013 00000A8D A0[3B00]                 mov al, [TokeType]
  2014 00000A90 3C03                     cmp al, 3
  2015 00000A92 0F85CC00                 jne @@getVariable98
  2016                                  
  2017                                  ;-48     lookCode();
  2018                                  
  2019 00000A96 E8BC0A                   call lookCode
  2020                                  
  2021                                  ;-49     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2022                                  
  2023 00000A99 A0[3D00]                 mov al, [CodeType]
  2024 00000A9C 3CC8                     cmp al, 200
  2025 00000A9E 0F8D0900                 jge @@getVariable99
  2026 00000AA2 68[6D0B]                 push getVariable_0
  2027 00000AA5 E8C30E                   call errorexit
  2028 00000AA8 83C402                   add  sp, 2
  2029                                  
  2030                                  ;-50     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2031                                  
  2032                                  @@getVariable99:
  2033 00000AAB A0[3D00]                 mov al, [CodeType]
  2034 00000AAE 3CCF                     cmp al, 207
  2035 00000AB0 0F8E0900                 jle @@getVariable100
  2036 00000AB4 68[850B]                 push getVariable_1
  2037 00000AB7 E8B10E                   call errorexit
  2038 00000ABA 83C402                   add  sp, 2
  2039                                  
  2040                                  ;-51     if (CodeType== 200) {// DB
  2041                                  
  2042                                  @@getVariable100:
  2043 00000ABD A0[3D00]                 mov al, [CodeType]
  2044 00000AC0 3CC8                     cmp al, 200
  2045 00000AC2 0F856A00                 jne @@getVariable101
  2046                                  
  2047                                  ;-52       do { getTokeType();
  2048                                  
  2049                                  @@getVariable102:
  2050 00000AC6 E8BAF6                   call getTokeType
  2051                                  
  2052                                  ;-53         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2053                                  
  2054 00000AC9 A0[3B00]                 mov al, [TokeType]
  2055 00000ACC 3C01                     cmp al, 1
  2056 00000ACE 0F850D00                 jne @@getVariable103
  2057 00000AD2 FF36[2500]               push word [SymbolInt]
  2058 00000AD6 E87BFC                   call genCode8
  2059 00000AD9 83C402                   add  sp, 2
  2060                                  
  2061                                  ;-54         else {
  2062                                  
  2063 00000ADC E94100                   jmp @@getVariable104
  2064                                  @@getVariable103:
  2065                                  
  2066                                  ;-55           skipBlank();
  2067                                  
  2068 00000ADF E8A601                   call skipBlank
  2069                                  
  2070                                  ;-56           if (isToken('"')) {
  2071                                  
  2072 00000AE2 6A22                     push 34
  2073 00000AE4 E8FEFB                   call isToken
  2074 00000AE7 83C402                   add  sp, 2
  2075 00000AEA 08C0                     or  al, al
  2076 00000AEC 0F843000                 je @@getVariable105
  2077                                  
  2078                                  ;-57             do { c= *InputPtr;
  2079                                  
  2080                                  @@getVariable106:
  2081 00000AF0 8B1E[2700]               mov bx, [InputPtr]
  2082 00000AF4 8A07                     mov al, [bx]
  2083 00000AF6 B400                     mov ah, 0
  2084 00000AF8 8846FE                   mov byte [bp-2], al
  2085                                  
  2086                                  ;-58               genCode8(c);
  2087                                  
  2088 00000AFB 8A46FE                   mov al, byte [bp-2]
  2089 00000AFE B400                     mov ah, 0
  2090 00000B00 50                       push ax
  2091 00000B01 E850FC                   call genCode8
  2092 00000B04 83C402                   add  sp, 2
  2093                                  
  2094                                  ;-59               InputPtr++;
  2095                                  
  2096 00000B07 FF06[2700]               inc  word [InputPtr]
  2097                                  
  2098                                  ;-60             } while (*InputPtr != '"' );
  2099                                  
  2100 00000B0B 8B1E[2700]               mov bx, [InputPtr]
  2101 00000B0F 8A07                     mov al, [bx]
  2102 00000B11 B400                     mov ah, 0
  2103 00000B13 83F822                   cmp ax, 34
  2104 00000B16 0F840200                 je  @@getVariable107
  2105 00000B1A EBD4                     jmp @@getVariable106
  2106                                  @@getVariable107:
  2107                                  
  2108                                  ;-61             InputPtr++;
  2109                                  
  2110 00000B1C FF06[2700]               inc  word [InputPtr]
  2111                                  
  2112                                  ;-62           }
  2113                                  
  2114                                  
  2115                                  ;-63         }
  2116                                  
  2117                                  @@getVariable105:
  2118                                  
  2119                                  ;-64       } while (isToken(','));
  2120                                  
  2121                                  @@getVariable104:
  2122 00000B20 6A2C                     push 44
  2123 00000B22 E8C0FB                   call isToken
  2124 00000B25 83C402                   add  sp, 2
  2125 00000B28 08C0                     or  al, al
  2126 00000B2A 0F840200                 je @@getVariable108
  2127 00000B2E EB96                     jmp @@getVariable102
  2128                                  @@getVariable108:
  2129                                  
  2130                                  ;-65     }
  2131                                  
  2132                                  
  2133                                  ;-66     if (CodeType== 201) {// DW
  2134                                  
  2135                                  @@getVariable101:
  2136 00000B30 A0[3D00]                 mov al, [CodeType]
  2137 00000B33 3CC9                     cmp al, 201
  2138 00000B35 0F852600                 jne @@getVariable109
  2139                                  
  2140                                  ;-67       do { getTokeType();
  2141                                  
  2142                                  @@getVariable110:
  2143 00000B39 E847F6                   call getTokeType
  2144                                  
  2145                                  ;-68         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2146                                  
  2147 00000B3C A0[3B00]                 mov al, [TokeType]
  2148 00000B3F 3C01                     cmp al, 1
  2149 00000B41 0F850A00                 jne @@getVariable111
  2150 00000B45 FF36[2500]               push word [SymbolInt]
  2151 00000B49 E83AFC                   call genCode16
  2152 00000B4C 83C402                   add  sp, 2
  2153                                  
  2154                                  ;-69       } while (isToken(','));
  2155                                  
  2156                                  @@getVariable111:
  2157 00000B4F 6A2C                     push 44
  2158 00000B51 E891FB                   call isToken
  2159 00000B54 83C402                   add  sp, 2
  2160 00000B57 08C0                     or  al, al
  2161 00000B59 0F840200                 je @@getVariable112
  2162 00000B5D EBDA                     jmp @@getVariable110
  2163                                  @@getVariable112:
  2164                                  
  2165                                  ;-70     }
  2166                                  
  2167                                  
  2168                                  ;-71   }
  2169                                  
  2170                                  @@getVariable109:
  2171                                  
  2172                                  ;-72   else errorexit("DB,DW,DD or RESB,W,D expected");
  2173                                  
  2174 00000B5F E90900                   jmp @@getVariable113
  2175                                  @@getVariable98:
  2176 00000B62 68[9D0B]                 push getVariable_2
  2177 00000B65 E8030E                   call errorexit
  2178 00000B68 83C402                   add  sp, 2
  2179                                  
  2180                                  ;-73 }
  2181                                  
  2182                                  @@getVariable113:
  2183                                  
  2184                                  ;-74 // helper functions XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  2185                                  
  2186                                  
  2187                                  ;-75 
  2188                                  
  2189                                  
  2190                                  ;-76 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2191 00000B6B C9                       LEAVE
  2192 00000B6C C3                       ret
  2193                                  ; ENDP
  2194 00000B6D 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2195 00000B76 422C572C4420657870-
  2196 00000B7F 656374656400       
  2197 00000B85 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2198 00000B8E 422C572C4420657870-
  2199 00000B97 656374656400       
  2200 00000B9D 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2201 00000BA6 6F7220524553422C57-
  2202 00000BAF 2C4420657870656374-
  2203 00000BB8 656400             
  2204                                  
  2205                                  getLine:  ; *** PROC ***
  2206                                  
  2207                                  ;-77   InputPtr= &InputBuf;
  2208                                  
  2209 00000BBB B8D075                   mov ax, InputBuf
  2210 00000BBE A3[2700]                 mov word [InputPtr], ax
  2211                                  
  2212                                  ;-78   *InputPtr=0;//if last line is empty
  2213                                  
  2214 00000BC1 66B800000000             mov eax, 0
  2215 00000BC7 8B1E[2700]               mov  bx, [InputPtr]
  2216 00000BCB 8807                     mov  [bx], al
  2217                                  
  2218                                  ;-79   do {
  2219                                  
  2220                                  @@getLine114:
  2221                                  
  2222                                  ;-80     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2223                                  
  2224 00000BCD 6A01                     push 1
  2225 00000BCF FF36[2900]               push word [asm_fd]
  2226 00000BD3 8D06[3500]               lea  ax, [DOS_ByteRead]
  2227 00000BD7 50                       push ax
  2228 00000BD8 E88013                   call readRL
  2229 00000BDB 83C406                   add  sp, 6
  2230 00000BDE A3[3300]                 mov word [DOS_NoBytes], ax
  2231                                  
  2232                                  ;-81     if (DOS_ERR) errorexit("Reading Source");
  2233                                  
  2234 00000BE1 A1[2F00]                 mov ax, [DOS_ERR]
  2235 00000BE4 08C0                     or  al, al
  2236 00000BE6 0F840900                 je @@getLine115
  2237 00000BEA 68[320C]                 push getLine_0
  2238 00000BED E87B0D                   call errorexit
  2239 00000BF0 83C402                   add  sp, 2
  2240                                  
  2241                                  ;-82     if (DOS_NoBytes == 0) return;
  2242                                  
  2243                                  @@getLine115:
  2244 00000BF3 A1[3300]                 mov ax, [DOS_NoBytes]
  2245 00000BF6 83F800                   cmp ax, 0
  2246 00000BF9 0F850300                 jne @@getLine116
  2247 00000BFD E93100                   jmp @@retn
  2248                                  
  2249                                  ;-83     *InputPtr = DOS_ByteRead;
  2250                                  
  2251                                  @@getLine116:
  2252 00000C00 A0[3500]                 mov al, [DOS_ByteRead]
  2253 00000C03 8B1E[2700]               mov  bx, [InputPtr]
  2254 00000C07 8807                     mov  [bx], al
  2255                                  
  2256                                  ;-84     InputPtr++;
  2257                                  
  2258 00000C09 FF06[2700]               inc  word [InputPtr]
  2259                                  
  2260                                  ;-85   } while (ifEOL(DOS_ByteRead) == 0);
  2261                                  
  2262 00000C0D A0[3500]                 mov al, byte [DOS_ByteRead]
  2263 00000C10 B400                     mov ah, 0
  2264 00000C12 50                       push ax
  2265 00000C13 E82B00                   call ifEOL
  2266 00000C16 83C402                   add  sp, 2
  2267 00000C19 3C00                     cmp al, 0
  2268 00000C1B 0F850200                 jne @@getLine117
  2269 00000C1F EBAC                     jmp @@getLine114
  2270                                  @@getLine117:
  2271                                  
  2272                                  ;-86   InputPtr--;
  2273                                  
  2274 00000C21 FF0E[2700]               dec  word [InputPtr]
  2275                                  
  2276                                  ;-87   *InputPtr=0;
  2277                                  
  2278 00000C25 66B800000000             mov eax, 0
  2279 00000C2B 8B1E[2700]               mov  bx, [InputPtr]
  2280 00000C2F 8807                     mov  [bx], al
  2281                                  
  2282                                  ;-88 }
  2283                                  
  2284                                  
  2285                                  ;-89 int ifEOL(char c) {
  2286                                  
  2287                                  @@retn:
  2288 00000C31 C3                       ret
  2289                                  ; ENDP
  2290 00000C32 52656164696E672053-     getLine_0 db "Reading Source",0
  2291 00000C3B 6F7572636500       
  2292                                  
  2293                                  ifEOL:  ; *** PROC ***
  2294                                  
  2295                                  ;-90   if (c == 10) return 1;
  2296                                  
  2297                                  ;Function : ifEOL, Number of local variables: 1
  2298                                  ;   # type sign width line used address name   list of local variables
  2299                                  ;  200 var sign byte    89 NULL bp+4    c;
  2300 00000C41 C8000000                 ENTER  0,0
  2301 00000C45 8A4604                   mov al, [bp+4]
  2302 00000C48 3C0A                     cmp al, 10
  2303 00000C4A 0F850900                 jne @@ifEOL118
  2304 00000C4E 66B801000000             mov eax, 1
  2305 00000C54 E92F00                   jmp @@retn
  2306                                  
  2307                                  ;-91   if (c == 13) {
  2308                                  
  2309                                  @@ifEOL118:
  2310 00000C57 8A4604                   mov al, [bp+4]
  2311 00000C5A 3C0D                     cmp al, 13
  2312 00000C5C 0F851D00                 jne @@ifEOL119
  2313                                  
  2314                                  ;-92     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2315                                  
  2316 00000C60 6A01                     push 1
  2317 00000C62 FF36[2900]               push word [asm_fd]
  2318 00000C66 8D06[3500]               lea  ax, [DOS_ByteRead]
  2319 00000C6A 50                       push ax
  2320 00000C6B E8ED12                   call readRL
  2321 00000C6E 83C406                   add  sp, 6
  2322 00000C71 A3[3300]                 mov word [DOS_NoBytes], ax
  2323                                  
  2324                                  ;-93     return 1;}
  2325                                  
  2326 00000C74 66B801000000             mov eax, 1
  2327 00000C7A E90900                   jmp @@retn
  2328                                  
  2329                                  ;-94   return 0;
  2330                                  
  2331                                  @@ifEOL119:
  2332 00000C7D 66B800000000             mov eax, 0
  2333 00000C83 E90000                   jmp @@retn
  2334                                  
  2335                                  ;-95 }
  2336                                  
  2337                                  
  2338                                  ;-96 int skipBlank() {
  2339                                  
  2340 00000C86 C9                      @@retn: LEAVE
  2341 00000C87 C3                       ret
  2342                                  ; ENDP
  2343                                  
  2344                                  skipBlank:  ; *** PROC ***
  2345                                  
  2346                                  ;-97   skipblank1:
  2347                                  
  2348                                  @@skipblank1:
  2349                                  
  2350                                  ;-98     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2351                                  
  2352 00000C88 8B1E[2700]               mov bx, [InputPtr]
  2353 00000C8C 8A07                     mov al, [bx]
  2354 00000C8E B400                     mov ah, 0
  2355 00000C90 83F820                   cmp ax, 32
  2356 00000C93 0F850600                 jne @@skipBlank120
  2357 00000C97 FF06[2700]               inc  word [InputPtr]
  2358 00000C9B EBEB                     jmp @@skipblank1
  2359                                  
  2360                                  ;-99     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2361                                  
  2362                                  @@skipBlank120:
  2363 00000C9D 8B1E[2700]               mov bx, [InputPtr]
  2364 00000CA1 8A07                     mov al, [bx]
  2365 00000CA3 B400                     mov ah, 0
  2366 00000CA5 83F809                   cmp ax, 9
  2367 00000CA8 0F850600                 jne @@skipBlank121
  2368 00000CAC FF06[2700]               inc  word [InputPtr]
  2369 00000CB0 EBD6                     jmp @@skipblank1
  2370                                  
  2371                                  ;-100 }
  2372                                  
  2373                                  @@skipBlank121:
  2374                                  
  2375                                  ;-101 int letterE(char c) {
  2376                                  
  2377 00000CB2 C3                       ret
  2378                                  ; ENDP
  2379                                  
  2380                                  letterE:  ; *** PROC ***
  2381                                  
  2382                                  ;-102   if (digit(c)) return 1;
  2383                                  
  2384                                  ;Function : letterE, Number of local variables: 1
  2385                                  ;   # type sign width line used address name   list of local variables
  2386                                  ;  200 var sign byte   101 NULL bp+4    c;
  2387 00000CB3 C8000000                 ENTER  0,0
  2388 00000CB7 8A4604                   mov al, byte [bp+4]
  2389 00000CBA B400                     mov ah, 0
  2390 00000CBC 50                       push ax
  2391 00000CBD E8CD11                   call digit
  2392 00000CC0 83C402                   add  sp, 2
  2393 00000CC3 08C0                     or  al, al
  2394 00000CC5 0F840900                 je @@letterE122
  2395 00000CC9 66B801000000             mov eax, 1
  2396 00000CCF E96C00                   jmp @@retn
  2397                                  
  2398                                  ;-103   if (c=='_') return 1;
  2399                                  
  2400                                  @@letterE122:
  2401 00000CD2 8A4604                   mov al, [bp+4]
  2402 00000CD5 3C5F                     cmp al, 95
  2403 00000CD7 0F850900                 jne @@letterE123
  2404 00000CDB 66B801000000             mov eax, 1
  2405 00000CE1 E95A00                   jmp @@retn
  2406                                  
  2407                                  ;-104   if (c=='.') return 1;
  2408                                  
  2409                                  @@letterE123:
  2410 00000CE4 8A4604                   mov al, [bp+4]
  2411 00000CE7 3C2E                     cmp al, 46
  2412 00000CE9 0F850900                 jne @@letterE124
  2413 00000CED 66B801000000             mov eax, 1
  2414 00000CF3 E94800                   jmp @@retn
  2415                                  
  2416                                  ;-105   if (c> 'z') return 0;
  2417                                  
  2418                                  @@letterE124:
  2419 00000CF6 8A4604                   mov al, [bp+4]
  2420 00000CF9 3C7A                     cmp al, 122
  2421 00000CFB 0F8E0900                 jle @@letterE125
  2422 00000CFF 66B800000000             mov eax, 0
  2423 00000D05 E93600                   jmp @@retn
  2424                                  
  2425                                  ;-106   if (c< '@') return 0; // at included
  2426                                  
  2427                                  @@letterE125:
  2428 00000D08 8A4604                   mov al, [bp+4]
  2429 00000D0B 3C40                     cmp al, 64
  2430 00000D0D 0F8D0900                 jge @@letterE126
  2431 00000D11 66B800000000             mov eax, 0
  2432 00000D17 E92400                   jmp @@retn
  2433                                  
  2434                                  ;-107   if (c> 'Z') { if (c< 'a') return 0; }
  2435                                  
  2436                                  @@letterE126:
  2437 00000D1A 8A4604                   mov al, [bp+4]
  2438 00000D1D 3C5A                     cmp al, 90
  2439 00000D1F 0F8E1200                 jle @@letterE127
  2440 00000D23 8A4604                   mov al, [bp+4]
  2441 00000D26 3C61                     cmp al, 97
  2442 00000D28 0F8D0900                 jge @@letterE128
  2443 00000D2C 66B800000000             mov eax, 0
  2444 00000D32 E90900                   jmp @@retn
  2445                                  @@letterE128:
  2446                                  
  2447                                  ;-108   return 1;
  2448                                  
  2449                                  @@letterE127:
  2450 00000D35 66B801000000             mov eax, 1
  2451 00000D3B E90000                   jmp @@retn
  2452                                  
  2453                                  ;-109 }
  2454                                  
  2455                                  
  2456                                  ;-110 int alnumE(char c) {
  2457                                  
  2458 00000D3E C9                      @@retn: LEAVE
  2459 00000D3F C3                       ret
  2460                                  ; ENDP
  2461                                  
  2462                                  alnumE:  ; *** PROC ***
  2463                                  
  2464                                  ;-111   if (digit(c)) return 1;
  2465                                  
  2466                                  ;Function : alnumE, Number of local variables: 1
  2467                                  ;   # type sign width line used address name   list of local variables
  2468                                  ;  200 var sign byte   110 NULL bp+4    c;
  2469 00000D40 C8000000                 ENTER  0,0
  2470 00000D44 8A4604                   mov al, byte [bp+4]
  2471 00000D47 B400                     mov ah, 0
  2472 00000D49 50                       push ax
  2473 00000D4A E84011                   call digit
  2474 00000D4D 83C402                   add  sp, 2
  2475 00000D50 08C0                     or  al, al
  2476 00000D52 0F840900                 je @@alnumE129
  2477 00000D56 66B801000000             mov eax, 1
  2478 00000D5C E92400                   jmp @@retn
  2479                                  
  2480                                  ;-112   if (letterE(c)) return 1;
  2481                                  
  2482                                  @@alnumE129:
  2483 00000D5F 8A4604                   mov al, byte [bp+4]
  2484 00000D62 B400                     mov ah, 0
  2485 00000D64 50                       push ax
  2486 00000D65 E84BFF                   call letterE
  2487 00000D68 83C402                   add  sp, 2
  2488 00000D6B 08C0                     or  al, al
  2489 00000D6D 0F840900                 je @@alnumE130
  2490 00000D71 66B801000000             mov eax, 1
  2491 00000D77 E90900                   jmp @@retn
  2492                                  
  2493                                  ;-113   return 0;
  2494                                  
  2495                                  @@alnumE130:
  2496 00000D7A 66B800000000             mov eax, 0
  2497 00000D80 E90000                   jmp @@retn
  2498                                  
  2499                                  ;-114 }
  2500                                  
  2501                                  
  2502                                  ;-115 int getDigit(unsigned char c) {//ret: SymbolInt
  2503                                  
  2504 00000D83 C9                      @@retn: LEAVE
  2505 00000D84 C3                       ret
  2506                                  ; ENDP
  2507                                  
  2508                                  getDigit:  ; *** PROC ***
  2509                                  
  2510                                  ;-116   unsigned int CastInt;
  2511                                  
  2512                                  
  2513                                  ;-117   SymbolInt=0;
  2514                                  
  2515                                  ;Function : getDigit, Number of local variables: 2
  2516                                  ;   # type sign width line used address name   list of local variables
  2517                                  ;  200 var unsg byte   115 NULL bp+4    c
  2518                                  ;  201 var unsg word   116 NULL bp-2    CastInt;
  2519 00000D85 C8020000                 ENTER  2,0
  2520 00000D89 66B800000000             mov eax, 0
  2521 00000D8F A3[2500]                 mov word [SymbolInt], ax
  2522                                  
  2523                                  ;-118   do {
  2524                                  
  2525                                  @@getDigit131:
  2526                                  
  2527                                  ;-119     c-='0';
  2528                                  
  2529 00000D92 806E0430                 sub  byte [bp+4], 48
  2530                                  
  2531                                  ;-120     SymbolInt=SymbolInt*10;
  2532                                  
  2533 00000D96 A1[2500]                 mov ax, [SymbolInt]
  2534 00000D99 66BB0A000000             mov ebx, 10
  2535 00000D9F 66F7E3                   mul ebx
  2536 00000DA2 A3[2500]                 mov word [SymbolInt], ax
  2537                                  
  2538                                  ;-121     ax=0; CastInt=c; //cast b2w
  2539                                  
  2540 00000DA5 B80000                   mov  ax, 0
  2541 00000DA8 8A4604                   mov al, [bp+4]
  2542 00000DAB 8946FE                   mov word [bp-2], ax
  2543                                  
  2544                                  ;-122     SymbolInt=SymbolInt+CastInt;
  2545                                  
  2546 00000DAE A1[2500]                 mov ax, [SymbolInt]
  2547 00000DB1 0346FE                   add ax, [bp-2]
  2548 00000DB4 A3[2500]                 mov word [SymbolInt], ax
  2549                                  
  2550                                  ;-123     InputPtr++;
  2551                                  
  2552 00000DB7 FF06[2700]               inc  word [InputPtr]
  2553                                  
  2554                                  ;-124     c = *InputPtr;
  2555                                  
  2556 00000DBB 8B1E[2700]               mov bx, [InputPtr]
  2557 00000DBF 8A07                     mov al, [bx]
  2558 00000DC1 B400                     mov ah, 0
  2559 00000DC3 884604                   mov byte [bp+4], al
  2560                                  
  2561                                  ;-125   } while(digit(c));
  2562                                  
  2563 00000DC6 8A4604                   mov al, byte [bp+4]
  2564 00000DC9 B400                     mov ah, 0
  2565 00000DCB 50                       push ax
  2566 00000DCC E8BE10                   call digit
  2567 00000DCF 83C402                   add  sp, 2
  2568 00000DD2 08C0                     or  al, al
  2569 00000DD4 0F840200                 je @@getDigit132
  2570 00000DD8 EBB8                     jmp @@getDigit131
  2571                                  @@getDigit132:
  2572                                  
  2573                                  ;-126 }
  2574                                  
  2575                                  
  2576                                  ;-127 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2577 00000DDA C9                       LEAVE
  2578 00000DDB C3                       ret
  2579                                  ; ENDP
  2580                                  
  2581                                  getName:  ; *** PROC ***
  2582                                  
  2583                                  ;-128   char *p;
  2584                                  
  2585                                  
  2586                                  ;-129   p = &Symbol;
  2587                                  
  2588                                  ;Function : getName, Number of local variables: 2
  2589                                  ;   # type sign width line used address name   list of local variables
  2590                                  ;  200 var unsg byte   127 NULL bp+4    c
  2591                                  ;  201 ptr sign byte   128 NULL bp-2    p;
  2592 00000DDC C8020000                 ENTER  2,0
  2593 00000DE0 B83075                   mov ax, Symbol
  2594 00000DE3 8946FE                   mov word [bp-2], ax
  2595                                  
  2596                                  ;-130   *p = c;
  2597                                  
  2598 00000DE6 8A4604                   mov al, [bp+4]
  2599 00000DE9 8B5EFE                   mov  bx, [bp-2]
  2600 00000DEC 8807                     mov  [bx], al
  2601                                  
  2602                                  ;-131   p++;
  2603                                  
  2604 00000DEE FF46FE                   inc  word [bp-2]
  2605                                  
  2606                                  ;-132   while (alnumE(c)) {
  2607                                  
  2608                                  @@getName133:
  2609 00000DF1 8A4604                   mov al, byte [bp+4]
  2610 00000DF4 B400                     mov ah, 0
  2611 00000DF6 50                       push ax
  2612 00000DF7 E846FF                   call alnumE
  2613 00000DFA 83C402                   add  sp, 2
  2614 00000DFD 08C0                     or  al, al
  2615 00000DFF 0F841C00                 je @@getName134
  2616                                  
  2617                                  ;-133     InputPtr++;
  2618                                  
  2619 00000E03 FF06[2700]               inc  word [InputPtr]
  2620                                  
  2621                                  ;-134     c = *InputPtr;
  2622                                  
  2623 00000E07 8B1E[2700]               mov bx, [InputPtr]
  2624 00000E0B 8A07                     mov al, [bx]
  2625 00000E0D B400                     mov ah, 0
  2626 00000E0F 884604                   mov byte [bp+4], al
  2627                                  
  2628                                  ;-135     *p = c;
  2629                                  
  2630 00000E12 8A4604                   mov al, [bp+4]
  2631 00000E15 8B5EFE                   mov  bx, [bp-2]
  2632 00000E18 8807                     mov  [bx], al
  2633                                  
  2634                                  ;-136     p++;
  2635                                  
  2636 00000E1A FF46FE                   inc  word [bp-2]
  2637                                  
  2638                                  ;-137   }
  2639                                  
  2640                                  
  2641                                  ;-138   if (c == ':') isLabel=1; else isLabel=0;
  2642                                  
  2643 00000E1D EBD2                     jmp @@getName133
  2644                                  @@getName134:
  2645 00000E1F 8A4604                   mov al, [bp+4]
  2646 00000E22 3C3A                     cmp al, 58
  2647 00000E24 0F850C00                 jne @@getName135
  2648 00000E28 66B801000000             mov eax, 1
  2649 00000E2E A2[3A00]                 mov byte [isLabel], al
  2650 00000E31 E90900                   jmp @@getName136
  2651                                  @@getName135:
  2652 00000E34 66B800000000             mov eax, 0
  2653 00000E3A A2[3A00]                 mov byte [isLabel], al
  2654                                  
  2655                                  ;-139   p--;
  2656                                  
  2657                                  @@getName136:
  2658 00000E3D FF4EFE                   dec  word [bp-2]
  2659                                  
  2660                                  ;-140   *p = 0;
  2661                                  
  2662 00000E40 66B800000000             mov eax, 0
  2663 00000E46 8B5EFE                   mov  bx, [bp-2]
  2664 00000E49 8807                     mov  [bx], al
  2665                                  
  2666                                  ;-141   strcpy(SymbolUpper, Symbol);
  2667                                  
  2668 00000E4B 8D063075                 lea  ax, [Symbol]
  2669 00000E4F 50                       push ax
  2670 00000E50 8D068075                 lea  ax, [SymbolUpper]
  2671 00000E54 50                       push ax
  2672 00000E55 E8FC0F                   call strcpy
  2673 00000E58 83C404                   add  sp, 4
  2674                                  
  2675                                  ;-142   toupper(SymbolUpper);
  2676                                  
  2677 00000E5B 8D068075                 lea  ax, [SymbolUpper]
  2678 00000E5F 50                       push ax
  2679 00000E60 E8830F                   call toupper
  2680 00000E63 83C402                   add  sp, 2
  2681                                  
  2682                                  ;-143 }
  2683                                  
  2684                                  
  2685                                  ;-144 int testReg() {
  2686 00000E66 C9                       LEAVE
  2687 00000E67 C3                       ret
  2688                                  ; ENDP
  2689                                  
  2690                                  testReg:  ; *** PROC ***
  2691                                  
  2692                                  ;-145 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2693                                  
  2694                                  
  2695                                  ;-146   RegType=0;
  2696                                  
  2697 00000E68 66B800000000             mov eax, 0
  2698 00000E6E A2[3E00]                 mov byte [RegType], al
  2699                                  
  2700                                  ;-147   if (strlen(Symbol) < 2) return 0;
  2701                                  
  2702 00000E71 8D063075                 lea  ax, [Symbol]
  2703 00000E75 50                       push ax
  2704 00000E76 E8B00F                   call strlen
  2705 00000E79 83C402                   add  sp, 2
  2706 00000E7C 3C02                     cmp al, 2
  2707 00000E7E 0F8D0900                 jge @@testReg137
  2708 00000E82 66B800000000             mov eax, 0
  2709 00000E88 E9B603                   jmp @@retn
  2710                                  
  2711                                  ;-148   if (strlen(Symbol) > 3) return 0;
  2712                                  
  2713                                  @@testReg137:
  2714 00000E8B 8D063075                 lea  ax, [Symbol]
  2715 00000E8F 50                       push ax
  2716 00000E90 E8960F                   call strlen
  2717 00000E93 83C402                   add  sp, 2
  2718 00000E96 3C03                     cmp al, 3
  2719 00000E98 0F8E0900                 jle @@testReg138
  2720 00000E9C 66B800000000             mov eax, 0
  2721 00000EA2 E99C03                   jmp @@retn
  2722                                  
  2723                                  ;-149   RegType=BYTE;
  2724                                  
  2725                                  @@testReg138:
  2726 00000EA5 66B801000000             mov eax, 1
  2727 00000EAB A2[3E00]                 mov byte [RegType], al
  2728                                  
  2729                                  ;-150   if (eqstr(SymbolUpper, "AL")) return 0;
  2730                                  
  2731 00000EAE 68[4212]                 push testReg_0
  2732 00000EB1 8D068075                 lea  ax, [SymbolUpper]
  2733 00000EB5 50                       push ax
  2734 00000EB6 E80710                   call eqstr
  2735 00000EB9 83C404                   add  sp, 4
  2736 00000EBC 08C0                     or  al, al
  2737 00000EBE 0F840900                 je @@testReg139
  2738 00000EC2 66B800000000             mov eax, 0
  2739 00000EC8 E97603                   jmp @@retn
  2740                                  
  2741                                  ;-151   if (eqstr(SymbolUpper, "CL")) return 1;
  2742                                  
  2743                                  @@testReg139:
  2744 00000ECB 68[4512]                 push testReg_1
  2745 00000ECE 8D068075                 lea  ax, [SymbolUpper]
  2746 00000ED2 50                       push ax
  2747 00000ED3 E8EA0F                   call eqstr
  2748 00000ED6 83C404                   add  sp, 4
  2749 00000ED9 08C0                     or  al, al
  2750 00000EDB 0F840900                 je @@testReg140
  2751 00000EDF 66B801000000             mov eax, 1
  2752 00000EE5 E95903                   jmp @@retn
  2753                                  
  2754                                  ;-152   if (eqstr(SymbolUpper, "DL")) return 2;
  2755                                  
  2756                                  @@testReg140:
  2757 00000EE8 68[4812]                 push testReg_2
  2758 00000EEB 8D068075                 lea  ax, [SymbolUpper]
  2759 00000EEF 50                       push ax
  2760 00000EF0 E8CD0F                   call eqstr
  2761 00000EF3 83C404                   add  sp, 4
  2762 00000EF6 08C0                     or  al, al
  2763 00000EF8 0F840900                 je @@testReg141
  2764 00000EFC 66B802000000             mov eax, 2
  2765 00000F02 E93C03                   jmp @@retn
  2766                                  
  2767                                  ;-153   if (eqstr(SymbolUpper, "BL")) return 3;
  2768                                  
  2769                                  @@testReg141:
  2770 00000F05 68[4B12]                 push testReg_3
  2771 00000F08 8D068075                 lea  ax, [SymbolUpper]
  2772 00000F0C 50                       push ax
  2773 00000F0D E8B00F                   call eqstr
  2774 00000F10 83C404                   add  sp, 4
  2775 00000F13 08C0                     or  al, al
  2776 00000F15 0F840900                 je @@testReg142
  2777 00000F19 66B803000000             mov eax, 3
  2778 00000F1F E91F03                   jmp @@retn
  2779                                  
  2780                                  ;-154   if (eqstr(SymbolUpper, "AH")) return 4;
  2781                                  
  2782                                  @@testReg142:
  2783 00000F22 68[4E12]                 push testReg_4
  2784 00000F25 8D068075                 lea  ax, [SymbolUpper]
  2785 00000F29 50                       push ax
  2786 00000F2A E8930F                   call eqstr
  2787 00000F2D 83C404                   add  sp, 4
  2788 00000F30 08C0                     or  al, al
  2789 00000F32 0F840900                 je @@testReg143
  2790 00000F36 66B804000000             mov eax, 4
  2791 00000F3C E90203                   jmp @@retn
  2792                                  
  2793                                  ;-155   if (eqstr(SymbolUpper, "CH")) return 5;
  2794                                  
  2795                                  @@testReg143:
  2796 00000F3F 68[5112]                 push testReg_5
  2797 00000F42 8D068075                 lea  ax, [SymbolUpper]
  2798 00000F46 50                       push ax
  2799 00000F47 E8760F                   call eqstr
  2800 00000F4A 83C404                   add  sp, 4
  2801 00000F4D 08C0                     or  al, al
  2802 00000F4F 0F840900                 je @@testReg144
  2803 00000F53 66B805000000             mov eax, 5
  2804 00000F59 E9E502                   jmp @@retn
  2805                                  
  2806                                  ;-156   if (eqstr(SymbolUpper, "DH")) return 6;
  2807                                  
  2808                                  @@testReg144:
  2809 00000F5C 68[5412]                 push testReg_6
  2810 00000F5F 8D068075                 lea  ax, [SymbolUpper]
  2811 00000F63 50                       push ax
  2812 00000F64 E8590F                   call eqstr
  2813 00000F67 83C404                   add  sp, 4
  2814 00000F6A 08C0                     or  al, al
  2815 00000F6C 0F840900                 je @@testReg145
  2816 00000F70 66B806000000             mov eax, 6
  2817 00000F76 E9C802                   jmp @@retn
  2818                                  
  2819                                  ;-157   if (eqstr(SymbolUpper, "BH")) return 7;
  2820                                  
  2821                                  @@testReg145:
  2822 00000F79 68[5712]                 push testReg_7
  2823 00000F7C 8D068075                 lea  ax, [SymbolUpper]
  2824 00000F80 50                       push ax
  2825 00000F81 E83C0F                   call eqstr
  2826 00000F84 83C404                   add  sp, 4
  2827 00000F87 08C0                     or  al, al
  2828 00000F89 0F840900                 je @@testReg146
  2829 00000F8D 66B807000000             mov eax, 7
  2830 00000F93 E9AB02                   jmp @@retn
  2831                                  
  2832                                  ;-158   RegType=WORD;
  2833                                  
  2834                                  @@testReg146:
  2835 00000F96 66B802000000             mov eax, 2
  2836 00000F9C A2[3E00]                 mov byte [RegType], al
  2837                                  
  2838                                  ;-159   if (eqstr(SymbolUpper, "AX")) return 0;
  2839                                  
  2840 00000F9F 68[5A12]                 push testReg_8
  2841 00000FA2 8D068075                 lea  ax, [SymbolUpper]
  2842 00000FA6 50                       push ax
  2843 00000FA7 E8160F                   call eqstr
  2844 00000FAA 83C404                   add  sp, 4
  2845 00000FAD 08C0                     or  al, al
  2846 00000FAF 0F840900                 je @@testReg147
  2847 00000FB3 66B800000000             mov eax, 0
  2848 00000FB9 E98502                   jmp @@retn
  2849                                  
  2850                                  ;-160   if (eqstr(SymbolUpper, "CX")) return 1;
  2851                                  
  2852                                  @@testReg147:
  2853 00000FBC 68[5D12]                 push testReg_9
  2854 00000FBF 8D068075                 lea  ax, [SymbolUpper]
  2855 00000FC3 50                       push ax
  2856 00000FC4 E8F90E                   call eqstr
  2857 00000FC7 83C404                   add  sp, 4
  2858 00000FCA 08C0                     or  al, al
  2859 00000FCC 0F840900                 je @@testReg148
  2860 00000FD0 66B801000000             mov eax, 1
  2861 00000FD6 E96802                   jmp @@retn
  2862                                  
  2863                                  ;-161   if (eqstr(SymbolUpper, "DX")) return 2;
  2864                                  
  2865                                  @@testReg148:
  2866 00000FD9 68[6012]                 push testReg_10
  2867 00000FDC 8D068075                 lea  ax, [SymbolUpper]
  2868 00000FE0 50                       push ax
  2869 00000FE1 E8DC0E                   call eqstr
  2870 00000FE4 83C404                   add  sp, 4
  2871 00000FE7 08C0                     or  al, al
  2872 00000FE9 0F840900                 je @@testReg149
  2873 00000FED 66B802000000             mov eax, 2
  2874 00000FF3 E94B02                   jmp @@retn
  2875                                  
  2876                                  ;-162   if (eqstr(SymbolUpper, "BX")) return 3;
  2877                                  
  2878                                  @@testReg149:
  2879 00000FF6 68[6312]                 push testReg_11
  2880 00000FF9 8D068075                 lea  ax, [SymbolUpper]
  2881 00000FFD 50                       push ax
  2882 00000FFE E8BF0E                   call eqstr
  2883 00001001 83C404                   add  sp, 4
  2884 00001004 08C0                     or  al, al
  2885 00001006 0F840900                 je @@testReg150
  2886 0000100A 66B803000000             mov eax, 3
  2887 00001010 E92E02                   jmp @@retn
  2888                                  
  2889                                  ;-163   if (eqstr(SymbolUpper, "SP")) return 4;
  2890                                  
  2891                                  @@testReg150:
  2892 00001013 68[6612]                 push testReg_12
  2893 00001016 8D068075                 lea  ax, [SymbolUpper]
  2894 0000101A 50                       push ax
  2895 0000101B E8A20E                   call eqstr
  2896 0000101E 83C404                   add  sp, 4
  2897 00001021 08C0                     or  al, al
  2898 00001023 0F840900                 je @@testReg151
  2899 00001027 66B804000000             mov eax, 4
  2900 0000102D E91102                   jmp @@retn
  2901                                  
  2902                                  ;-164   if (eqstr(SymbolUpper, "BP")) return 5;
  2903                                  
  2904                                  @@testReg151:
  2905 00001030 68[6912]                 push testReg_13
  2906 00001033 8D068075                 lea  ax, [SymbolUpper]
  2907 00001037 50                       push ax
  2908 00001038 E8850E                   call eqstr
  2909 0000103B 83C404                   add  sp, 4
  2910 0000103E 08C0                     or  al, al
  2911 00001040 0F840900                 je @@testReg152
  2912 00001044 66B805000000             mov eax, 5
  2913 0000104A E9F401                   jmp @@retn
  2914                                  
  2915                                  ;-165   if (eqstr(SymbolUpper, "SI")) return 6;
  2916                                  
  2917                                  @@testReg152:
  2918 0000104D 68[6C12]                 push testReg_14
  2919 00001050 8D068075                 lea  ax, [SymbolUpper]
  2920 00001054 50                       push ax
  2921 00001055 E8680E                   call eqstr
  2922 00001058 83C404                   add  sp, 4
  2923 0000105B 08C0                     or  al, al
  2924 0000105D 0F840900                 je @@testReg153
  2925 00001061 66B806000000             mov eax, 6
  2926 00001067 E9D701                   jmp @@retn
  2927                                  
  2928                                  ;-166   if (eqstr(SymbolUpper, "DI")) return 7;
  2929                                  
  2930                                  @@testReg153:
  2931 0000106A 68[6F12]                 push testReg_15
  2932 0000106D 8D068075                 lea  ax, [SymbolUpper]
  2933 00001071 50                       push ax
  2934 00001072 E84B0E                   call eqstr
  2935 00001075 83C404                   add  sp, 4
  2936 00001078 08C0                     or  al, al
  2937 0000107A 0F840900                 je @@testReg154
  2938 0000107E 66B807000000             mov eax, 7
  2939 00001084 E9BA01                   jmp @@retn
  2940                                  
  2941                                  ;-167   RegType=SEGREG;
  2942                                  
  2943                                  @@testReg154:
  2944 00001087 66B804000000             mov eax, 4
  2945 0000108D A2[3E00]                 mov byte [RegType], al
  2946                                  
  2947                                  ;-168   if (eqstr(SymbolUpper, "ES")) return 0;
  2948                                  
  2949 00001090 68[7212]                 push testReg_16
  2950 00001093 8D068075                 lea  ax, [SymbolUpper]
  2951 00001097 50                       push ax
  2952 00001098 E8250E                   call eqstr
  2953 0000109B 83C404                   add  sp, 4
  2954 0000109E 08C0                     or  al, al
  2955 000010A0 0F840900                 je @@testReg155
  2956 000010A4 66B800000000             mov eax, 0
  2957 000010AA E99401                   jmp @@retn
  2958                                  
  2959                                  ;-169   if (eqstr(SymbolUpper, "CS")) return 1;
  2960                                  
  2961                                  @@testReg155:
  2962 000010AD 68[7512]                 push testReg_17
  2963 000010B0 8D068075                 lea  ax, [SymbolUpper]
  2964 000010B4 50                       push ax
  2965 000010B5 E8080E                   call eqstr
  2966 000010B8 83C404                   add  sp, 4
  2967 000010BB 08C0                     or  al, al
  2968 000010BD 0F840900                 je @@testReg156
  2969 000010C1 66B801000000             mov eax, 1
  2970 000010C7 E97701                   jmp @@retn
  2971                                  
  2972                                  ;-170   if (eqstr(SymbolUpper, "SS")) return 2;
  2973                                  
  2974                                  @@testReg156:
  2975 000010CA 68[7812]                 push testReg_18
  2976 000010CD 8D068075                 lea  ax, [SymbolUpper]
  2977 000010D1 50                       push ax
  2978 000010D2 E8EB0D                   call eqstr
  2979 000010D5 83C404                   add  sp, 4
  2980 000010D8 08C0                     or  al, al
  2981 000010DA 0F840900                 je @@testReg157
  2982 000010DE 66B802000000             mov eax, 2
  2983 000010E4 E95A01                   jmp @@retn
  2984                                  
  2985                                  ;-171   if (eqstr(SymbolUpper, "DS")) return 3;
  2986                                  
  2987                                  @@testReg157:
  2988 000010E7 68[7B12]                 push testReg_19
  2989 000010EA 8D068075                 lea  ax, [SymbolUpper]
  2990 000010EE 50                       push ax
  2991 000010EF E8CE0D                   call eqstr
  2992 000010F2 83C404                   add  sp, 4
  2993 000010F5 08C0                     or  al, al
  2994 000010F7 0F840900                 je @@testReg158
  2995 000010FB 66B803000000             mov eax, 3
  2996 00001101 E93D01                   jmp @@retn
  2997                                  
  2998                                  ;-172   if (eqstr(SymbolUpper, "FS")) return 4;
  2999                                  
  3000                                  @@testReg158:
  3001 00001104 68[7E12]                 push testReg_20
  3002 00001107 8D068075                 lea  ax, [SymbolUpper]
  3003 0000110B 50                       push ax
  3004 0000110C E8B10D                   call eqstr
  3005 0000110F 83C404                   add  sp, 4
  3006 00001112 08C0                     or  al, al
  3007 00001114 0F840900                 je @@testReg159
  3008 00001118 66B804000000             mov eax, 4
  3009 0000111E E92001                   jmp @@retn
  3010                                  
  3011                                  ;-173   if (eqstr(SymbolUpper, "GS")) return 5;
  3012                                  
  3013                                  @@testReg159:
  3014 00001121 68[8112]                 push testReg_21
  3015 00001124 8D068075                 lea  ax, [SymbolUpper]
  3016 00001128 50                       push ax
  3017 00001129 E8940D                   call eqstr
  3018 0000112C 83C404                   add  sp, 4
  3019 0000112F 08C0                     or  al, al
  3020 00001131 0F840900                 je @@testReg160
  3021 00001135 66B805000000             mov eax, 5
  3022 0000113B E90301                   jmp @@retn
  3023                                  
  3024                                  ;-174   RegType=DWORD;
  3025                                  
  3026                                  @@testReg160:
  3027 0000113E 66B803000000             mov eax, 3
  3028 00001144 A2[3E00]                 mov byte [RegType], al
  3029                                  
  3030                                  ;-175   if (eqstr(SymbolUpper, "EAX"))return 0;
  3031                                  
  3032 00001147 68[8412]                 push testReg_22
  3033 0000114A 8D068075                 lea  ax, [SymbolUpper]
  3034 0000114E 50                       push ax
  3035 0000114F E86E0D                   call eqstr
  3036 00001152 83C404                   add  sp, 4
  3037 00001155 08C0                     or  al, al
  3038 00001157 0F840900                 je @@testReg161
  3039 0000115B 66B800000000             mov eax, 0
  3040 00001161 E9DD00                   jmp @@retn
  3041                                  
  3042                                  ;-176   if (eqstr(SymbolUpper, "ECX"))return 1;
  3043                                  
  3044                                  @@testReg161:
  3045 00001164 68[8812]                 push testReg_23
  3046 00001167 8D068075                 lea  ax, [SymbolUpper]
  3047 0000116B 50                       push ax
  3048 0000116C E8510D                   call eqstr
  3049 0000116F 83C404                   add  sp, 4
  3050 00001172 08C0                     or  al, al
  3051 00001174 0F840900                 je @@testReg162
  3052 00001178 66B801000000             mov eax, 1
  3053 0000117E E9C000                   jmp @@retn
  3054                                  
  3055                                  ;-177   if (eqstr(SymbolUpper, "EDX"))return 2;
  3056                                  
  3057                                  @@testReg162:
  3058 00001181 68[8C12]                 push testReg_24
  3059 00001184 8D068075                 lea  ax, [SymbolUpper]
  3060 00001188 50                       push ax
  3061 00001189 E8340D                   call eqstr
  3062 0000118C 83C404                   add  sp, 4
  3063 0000118F 08C0                     or  al, al
  3064 00001191 0F840900                 je @@testReg163
  3065 00001195 66B802000000             mov eax, 2
  3066 0000119B E9A300                   jmp @@retn
  3067                                  
  3068                                  ;-178   if (eqstr(SymbolUpper, "EBX"))return 3;
  3069                                  
  3070                                  @@testReg163:
  3071 0000119E 68[9012]                 push testReg_25
  3072 000011A1 8D068075                 lea  ax, [SymbolUpper]
  3073 000011A5 50                       push ax
  3074 000011A6 E8170D                   call eqstr
  3075 000011A9 83C404                   add  sp, 4
  3076 000011AC 08C0                     or  al, al
  3077 000011AE 0F840900                 je @@testReg164
  3078 000011B2 66B803000000             mov eax, 3
  3079 000011B8 E98600                   jmp @@retn
  3080                                  
  3081                                  ;-179   if (eqstr(SymbolUpper, "ESP"))return 4;
  3082                                  
  3083                                  @@testReg164:
  3084 000011BB 68[9412]                 push testReg_26
  3085 000011BE 8D068075                 lea  ax, [SymbolUpper]
  3086 000011C2 50                       push ax
  3087 000011C3 E8FA0C                   call eqstr
  3088 000011C6 83C404                   add  sp, 4
  3089 000011C9 08C0                     or  al, al
  3090 000011CB 0F840900                 je @@testReg165
  3091 000011CF 66B804000000             mov eax, 4
  3092 000011D5 E96900                   jmp @@retn
  3093                                  
  3094                                  ;-180   if (eqstr(SymbolUpper, "EBP"))return 5;
  3095                                  
  3096                                  @@testReg165:
  3097 000011D8 68[9812]                 push testReg_27
  3098 000011DB 8D068075                 lea  ax, [SymbolUpper]
  3099 000011DF 50                       push ax
  3100 000011E0 E8DD0C                   call eqstr
  3101 000011E3 83C404                   add  sp, 4
  3102 000011E6 08C0                     or  al, al
  3103 000011E8 0F840900                 je @@testReg166
  3104 000011EC 66B805000000             mov eax, 5
  3105 000011F2 E94C00                   jmp @@retn
  3106                                  
  3107                                  ;-181   if (eqstr(SymbolUpper, "ESI"))return 6;
  3108                                  
  3109                                  @@testReg166:
  3110 000011F5 68[9C12]                 push testReg_28
  3111 000011F8 8D068075                 lea  ax, [SymbolUpper]
  3112 000011FC 50                       push ax
  3113 000011FD E8C00C                   call eqstr
  3114 00001200 83C404                   add  sp, 4
  3115 00001203 08C0                     or  al, al
  3116 00001205 0F840900                 je @@testReg167
  3117 00001209 66B806000000             mov eax, 6
  3118 0000120F E92F00                   jmp @@retn
  3119                                  
  3120                                  ;-182   if (eqstr(SymbolUpper, "EDI"))return 7;
  3121                                  
  3122                                  @@testReg167:
  3123 00001212 68[A012]                 push testReg_29
  3124 00001215 8D068075                 lea  ax, [SymbolUpper]
  3125 00001219 50                       push ax
  3126 0000121A E8A30C                   call eqstr
  3127 0000121D 83C404                   add  sp, 4
  3128 00001220 08C0                     or  al, al
  3129 00001222 0F840900                 je @@testReg168
  3130 00001226 66B807000000             mov eax, 7
  3131 0000122C E91200                   jmp @@retn
  3132                                  
  3133                                  ;-183   RegType=0; return 0;
  3134                                  
  3135                                  @@testReg168:
  3136 0000122F 66B800000000             mov eax, 0
  3137 00001235 A2[3E00]                 mov byte [RegType], al
  3138 00001238 66B800000000             mov eax, 0
  3139 0000123E E90000                   jmp @@retn
  3140                                  
  3141                                  ;-184 }
  3142                                  
  3143                                  
  3144                                  ;-185 // opcodes XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  3145                                  
  3146                                  
  3147                                  ;-186 char I_START=0xF1;//OpName,0,CodeType,OpCode1,OpCodeN,F1h
  3148                                  
  3149                                  @@retn:
  3150 00001241 C3                       ret
  3151                                  ; ENDP
  3152 00001242 414C00                  testReg_0 db "AL",0
  3153 00001245 434C00                  testReg_1 db "CL",0
  3154 00001248 444C00                  testReg_2 db "DL",0
  3155 0000124B 424C00                  testReg_3 db "BL",0
  3156 0000124E 414800                  testReg_4 db "AH",0
  3157 00001251 434800                  testReg_5 db "CH",0
  3158 00001254 444800                  testReg_6 db "DH",0
  3159 00001257 424800                  testReg_7 db "BH",0
  3160 0000125A 415800                  testReg_8 db "AX",0
  3161 0000125D 435800                  testReg_9 db "CX",0
  3162 00001260 445800                  testReg_10 db "DX",0
  3163 00001263 425800                  testReg_11 db "BX",0
  3164 00001266 535000                  testReg_12 db "SP",0
  3165 00001269 425000                  testReg_13 db "BP",0
  3166 0000126C 534900                  testReg_14 db "SI",0
  3167 0000126F 444900                  testReg_15 db "DI",0
  3168 00001272 455300                  testReg_16 db "ES",0
  3169 00001275 435300                  testReg_17 db "CS",0
  3170 00001278 535300                  testReg_18 db "SS",0
  3171 0000127B 445300                  testReg_19 db "DS",0
  3172 0000127E 465300                  testReg_20 db "FS",0
  3173 00001281 475300                  testReg_21 db "GS",0
  3174 00001284 45415800                testReg_22 db "EAX",0
  3175 00001288 45435800                testReg_23 db "ECX",0
  3176 0000128C 45445800                testReg_24 db "EDX",0
  3177 00001290 45425800                testReg_25 db "EBX",0
  3178 00001294 45535000                testReg_26 db "ESP",0
  3179 00001298 45425000                testReg_27 db "EBP",0
  3180 0000129C 45534900                testReg_28 db "ESI",0
  3181 000012A0 45444900                testReg_29 db "EDI",0
  3182 000012A4 F1                      I_START db 241
  3183                                  
  3184                                  ;-187 //  1:   1 byte opcode
  3185                                  
  3186                                  
  3187                                  ;-188 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
  3188                                  
  3189 000012A5 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
  3190                                  
  3191                                  ;-189 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
  3192                                  
  3193 000012AE 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
  3194                                  
  3195                                  ;-190 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
  3196                                  
  3197 000012B6 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
  3198                                  
  3199                                  ;-191 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
  3200                                  
  3201 000012BD 434257000198F1          I_CBW db 67,66,87,0,1,152,241
  3202                                  
  3203                                  ;-192 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
  3204                                  
  3205 000012C4 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
  3206                                  
  3207                                  ;-193 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
  3208                                  
  3209 000012CC 435744000199F1          I_CWD db 67,87,68,0,1,153,241
  3210                                  
  3211                                  ;-194 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
  3212                                  
  3213 000012D3 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
  3214                                  
  3215                                  ;-195 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
  3216                                  
  3217 000012DA 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
  3218                                  
  3219                                  ;-196 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
  3220                                  
  3221 000012E2 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
  3222                                  
  3223                                  ;-197 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
  3224                                  
  3225 000012EB 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
  3226                                  
  3227                                  ;-198 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
  3228                                  
  3229 000012F3 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
  3230                                  
  3231                                  ;-199 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
  3232                                  
  3233 000012FB 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
  3234                                  
  3235                                  ;-200 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
  3236                                  
  3237 00001303 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
  3238                                  
  3239                                  ;-201 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
  3240                                  
  3241 0000130C 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
  3242                                  
  3243                                  ;-202 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
  3244                                  
  3245 00001315 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
  3246                                  
  3247                                  ;-203 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
  3248                                  
  3249 0000131E 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
  3250                                  
  3251                                  ;-204 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
  3252                                  
  3253 00001327 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
  3254                                  
  3255                                  ;-205 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
  3256                                  
  3257 00001330 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
  3258                                  
  3259                                  ;-206 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
  3260                                  
  3261 00001339 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
  3262                                  
  3263                                  ;-207 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
  3264                                  
  3265 00001342 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
  3266                                  
  3267                                  ;-208 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
  3268                                  
  3269 0000134B 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
  3270                                  
  3271                                  ;-209 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
  3272                                  
  3273 00001354 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
  3274                                  
  3275                                  ;-210 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
  3276                                  
  3277 0000135D 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
  3278                                  
  3279                                  ;-211 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
  3280                                  
  3281 00001366 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
  3282                                  
  3283                                  ;-212 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
  3284                                  
  3285 0000136E 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
  3286                                  
  3287                                  ;-213 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
  3288                                  
  3289 00001376 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
  3290                                  
  3291                                  ;-214 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
  3292                                  
  3293 0000137E 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
  3294                                  
  3295                                  ;-215 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
  3296                                  
  3297 00001387 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
  3298                                  
  3299                                  ;-216 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
  3300                                  
  3301 00001390 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
  3302                                  
  3303                                  ;-217 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
  3304                                  
  3305 00001398 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
  3306                                  
  3307                                  ;-218 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
  3308                                  
  3309 000013A0 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
  3310                                  
  3311                                  ;-219 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
  3312                                  
  3313 000013A7 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
  3314                                  
  3315                                  ;-220 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
  3316                                  
  3317 000013AE 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
  3318                                  
  3319                                  ;-221 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
  3320                                  
  3321 000013B5 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
  3322                                  
  3323                                  ;-222 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
  3324                                  
  3325 000013BC 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
  3326                                  
  3327                                  ;-223 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
  3328                                  
  3329 000013C3 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
  3330                                  
  3331                                  ;-224 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
  3332                                  
  3333 000013CA 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
  3334                                  
  3335                                  ;-225 //  2: inc,dec
  3336                                  
  3337                                  
  3338                                  ;-226 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};
  3339                                  
  3340 000013D1 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
  3341                                  
  3342                                  ;-227 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};
  3343                                  
  3344 000013DA 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
  3345                                  
  3346                                  ;-228 // 52: mem reg 16 bit
  3347                                  
  3348                                  
  3349                                  ;-229 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};
  3350                                  
  3351 000013E3 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
  3352                                  
  3353                                  ;-230 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};
  3354                                  
  3355 000013EB 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
  3356                                  
  3357                                  ;-231 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};
  3358                                  
  3359 000013F3 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
  3360                                  
  3361                                  ;-232 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc
  3362                                  
  3363 000013FB 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
  3364                                  
  3365                                  ;-233 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};
  3366                                  
  3367 00001404 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
  3368                                  
  3369                                  ;-234 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};
  3370                                  
  3371 0000140C 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
  3372                                  
  3373                                  ;-235 //  3: les, lda, lea
  3374                                  
  3375                                  
  3376                                  ;-236 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16
  3377                                  
  3378 00001415 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
  3379                                  
  3380                                  ;-237 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16
  3381                                  
  3382 0000141C 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
  3383                                  
  3384                                  ;-238 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16
  3385                                  
  3386 00001423 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
  3387                                  
  3388                                  ;-239 //  4: acc,imm  reg,imm  index,reg
  3389                                  
  3390                                  
  3391                                  ;-240 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};
  3392                                  
  3393 0000142A 414444000400F1          I_ADD db 65,68,68,0,4,0,241
  3394                                  
  3395                                  ;-241 char I_OR []={'O','R',0,                4, 1,     0xF1};
  3396                                  
  3397 00001431 4F52000401F1            I_OR db 79,82,0,4,1,241
  3398                                  
  3399                                  ;-242 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};
  3400                                  
  3401 00001437 414443000402F1          I_ADC db 65,68,67,0,4,2,241
  3402                                  
  3403                                  ;-243 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};
  3404                                  
  3405 0000143E 534242000403F1          I_SBB db 83,66,66,0,4,3,241
  3406                                  
  3407                                  ;-244 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};
  3408                                  
  3409 00001445 414E44000404F1          I_AND db 65,78,68,0,4,4,241
  3410                                  
  3411                                  ;-245 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};
  3412                                  
  3413 0000144C 535542000405F1          I_SUB db 83,85,66,0,4,5,241
  3414                                  
  3415                                  ;-246 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};
  3416                                  
  3417 00001453 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
  3418                                  
  3419                                  ;-247 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};
  3420                                  
  3421 0000145A 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
  3422                                  
  3423                                  ;-248 //  5: mov
  3424                                  
  3425                                  
  3426                                  ;-249 char I_MOV[]={'M','O','V',0,            5,        0xF1};
  3427                                  
  3428 00001461 4D4F560005F1            I_MOV db 77,79,86,0,5,241
  3429                                  
  3430                                  ;-250 //  6: single byte relative jump
  3431                                  
  3432                                  
  3433                                  ;-251 char I_JO []={'J','O',0,                6, 0,     0xF1};
  3434                                  
  3435 00001467 4A4F000600F1            I_JO db 74,79,0,6,0,241
  3436                                  
  3437                                  ;-252 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};
  3438                                  
  3439 0000146D 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
  3440                                  
  3441                                  ;-253 char I_JB []={'J','B',0,                6, 2,     0xF1};
  3442                                  
  3443 00001474 4A42000602F1            I_JB db 74,66,0,6,2,241
  3444                                  
  3445                                  ;-254 char I_JC []={'J','C',0,                6, 2,     0xF1};
  3446                                  
  3447 0000147A 4A43000602F1            I_JC db 74,67,0,6,2,241
  3448                                  
  3449                                  ;-255 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};
  3450                                  
  3451 00001480 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
  3452                                  
  3453                                  ;-256 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};
  3454                                  
  3455 00001487 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
  3456                                  
  3457                                  ;-257 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};
  3458                                  
  3459 0000148E 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
  3460                                  
  3461                                  ;-258 char I_JE []={'J','E',0,                6, 4,     0xF1};//      74 je i8 rel
  3462                                  
  3463 00001495 4A45000604F1            I_JE db 74,69,0,6,4,241
  3464                                  
  3465                                  ;-259 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//   0F 84 je i16 rel
  3466                                  
  3467 0000149B 4A5A000604F1            I_JZ db 74,90,0,6,4,241
  3468                                  
  3469                                  ;-260 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//66 0F 84 je i32 rel
  3470                                  
  3471 000014A1 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
  3472                                  
  3473                                  ;-261 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};
  3474                                  
  3475 000014A8 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
  3476                                  
  3477                                  ;-262 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};
  3478                                  
  3479 000014AF 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
  3480                                  
  3481                                  ;-263 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};
  3482                                  
  3483 000014B6 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
  3484                                  
  3485                                  ;-264 char I_JA []={'J','A',0,                6, 7,     0xF1};
  3486                                  
  3487 000014BD 4A41000607F1            I_JA db 74,65,0,6,7,241
  3488                                  
  3489                                  ;-265 char I_JS []={'J','S',0,                6, 8,     0xF1};
  3490                                  
  3491 000014C3 4A53000608F1            I_JS db 74,83,0,6,8,241
  3492                                  
  3493                                  ;-266 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};
  3494                                  
  3495 000014C9 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
  3496                                  
  3497                                  ;-267 char I_JP[]={'J','P',0,                 6,10,     0xF1};
  3498                                  
  3499 000014D0 4A5000060AF1            I_JP db 74,80,0,6,10,241
  3500                                  
  3501                                  ;-268 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};
  3502                                  
  3503 000014D6 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
  3504                                  
  3505                                  ;-269 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};
  3506                                  
  3507 000014DD 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
  3508                                  
  3509                                  ;-270 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};
  3510                                  
  3511 000014E4 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
  3512                                  
  3513                                  ;-271 char I_JL[]={'J','L',0,                 6,12,     0xF1};
  3514                                  
  3515 000014EB 4A4C00060CF1            I_JL db 74,76,0,6,12,241
  3516                                  
  3517                                  ;-272 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};
  3518                                  
  3519 000014F1 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
  3520                                  
  3521                                  ;-273 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};
  3522                                  
  3523 000014F8 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
  3524                                  
  3525                                  ;-274 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};
  3526                                  
  3527 000014FF 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
  3528                                  
  3529                                  ;-275 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};
  3530                                  
  3531 00001506 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
  3532                                  
  3533                                  ;-276 char I_JG []={'J','G',0,                6,15,     0xF1};
  3534                                  
  3535 0000150D 4A4700060FF1            I_JG db 74,71,0,6,15,241
  3536                                  
  3537                                  ;-277 //  8: ret
  3538                                  
  3539                                  
  3540                                  ;-278 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
  3541                                  
  3542 00001513 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
  3543                                  
  3544                                  ;-279 //  9: seg, r/m
  3545                                  
  3546                                  
  3547                                  ;-280 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16
  3548                                  
  3549 0000151B 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
  3550                                  
  3551                                  ;-281 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16
  3552                                  
  3553 00001523 504F50000958F1          I_POP db 80,79,80,0,9,88,241
  3554                                  
  3555                                  ;-282 //  100 directives
  3556                                  
  3557                                  
  3558                                  ;-283 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
  3559                                  
  3560 0000152A 4F52470065F1            I_ORG db 79,82,71,0,101,241
  3561                                  
  3562                                  ;-284 char I_DB[]=   {'D','B',0,            200,        0xF1};
  3563                                  
  3564 00001530 444200C8F1              I_DB db 68,66,0,200,241
  3565                                  
  3566                                  ;-285 char I_DW[]=   {'D','W',0,            201,        0xF1};
  3567                                  
  3568 00001535 445700C9F1              I_DW db 68,87,0,201,241
  3569                                  
  3570                                  ;-286 char I_DD[]=   {'D','D',0,            202,        0xF1};
  3571                                  
  3572 0000153A 444400CAF1              I_DD db 68,68,0,202,241
  3573                                  
  3574                                  ;-287 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
  3575                                  
  3576 0000153F 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
  3577                                  
  3578                                  ;-288 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
  3579                                  
  3580 00001546 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
  3581                                  
  3582                                  ;-289 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
  3583                                  
  3584 0000154D 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
  3585                                  
  3586                                  ;-290 char I_END=0;// end of table char
  3587                                  
  3588 00001554 00                      I_END db 0
  3589                                  
  3590                                  ;-291 
  3591                                  
  3592                                  
  3593                                  ;-292 int lookCode() { // ret: CodeType, *OpCodePtr
  3594                                  
  3595                                  
  3596                                  lookCode:  ; *** PROC ***
  3597                                  
  3598                                  ;-293   CodeType=0;
  3599                                  
  3600 00001555 66B800000000             mov eax, 0
  3601 0000155B A2[3D00]                 mov byte [CodeType], al
  3602                                  
  3603                                  ;-294   OpCodePtr= &I_START;
  3604                                  
  3605 0000155E B8[A412]                 mov ax, I_START
  3606 00001561 A3[4B00]                 mov word [OpCodePtr], ax
  3607                                  
  3608                                  ;-295   OpCodePtr++;
  3609                                  
  3610 00001564 FF06[4B00]               inc  word [OpCodePtr]
  3611                                  
  3612                                  ;-296   do  {
  3613                                  
  3614                                  @@lookCode169:
  3615                                  
  3616                                  ;-297     if (eqstr(SymbolUpper, OpCodePtr))  {
  3617                                  
  3618 00001568 FF36[4B00]               push word [OpCodePtr]
  3619 0000156C 8D068075                 lea  ax, [SymbolUpper]
  3620 00001570 50                       push ax
  3621 00001571 E84C09                   call eqstr
  3622 00001574 83C404                   add  sp, 4
  3623 00001577 08C0                     or  al, al
  3624 00001579 0F842700                 je @@lookCode170
  3625                                  
  3626                                  ;-298       while(*OpCodePtr!=0) OpCodePtr++;
  3627                                  
  3628                                  @@lookCode171:
  3629 0000157D 8B1E[4B00]               mov bx, [OpCodePtr]
  3630 00001581 8A07                     mov al, [bx]
  3631 00001583 B400                     mov ah, 0
  3632 00001585 83F800                   cmp ax, 0
  3633 00001588 0F840600                 je  @@lookCode172
  3634 0000158C FF06[4B00]               inc  word [OpCodePtr]
  3635                                  
  3636                                  ;-299       OpCodePtr++; CodeType =*OpCodePtr;
  3637                                  
  3638 00001590 EBEB                     jmp @@lookCode171
  3639                                  @@lookCode172:
  3640 00001592 FF06[4B00]               inc  word [OpCodePtr]
  3641 00001596 8B1E[4B00]               mov bx, [OpCodePtr]
  3642 0000159A 8A07                     mov al, [bx]
  3643 0000159C B400                     mov ah, 0
  3644 0000159E A2[3D00]                 mov byte [CodeType], al
  3645                                  
  3646                                  ;-300       return;
  3647                                  
  3648 000015A1 E92A00                   jmp @@retn
  3649                                  
  3650                                  ;-301     }
  3651                                  
  3652                                  
  3653                                  ;-302   while(*OpCodePtr!=0xF1) OpCodePtr++;
  3654                                  
  3655                                  @@lookCode170:
  3656                                  @@lookCode173:
  3657 000015A4 8B1E[4B00]               mov bx, [OpCodePtr]
  3658 000015A8 8A07                     mov al, [bx]
  3659 000015AA B400                     mov ah, 0
  3660 000015AC 3DF100                   cmp ax, 241
  3661 000015AF 0F840600                 je  @@lookCode174
  3662 000015B3 FF06[4B00]               inc  word [OpCodePtr]
  3663                                  
  3664                                  ;-303   OpCodePtr++;
  3665                                  
  3666 000015B7 EBEB                     jmp @@lookCode173
  3667                                  @@lookCode174:
  3668 000015B9 FF06[4B00]               inc  word [OpCodePtr]
  3669                                  
  3670                                  ;-304   } while(*OpCodePtr!=0);
  3671                                  
  3672 000015BD 8B1E[4B00]               mov bx, [OpCodePtr]
  3673 000015C1 8A07                     mov al, [bx]
  3674 000015C3 B400                     mov ah, 0
  3675 000015C5 83F800                   cmp ax, 0
  3676 000015C8 0F840200                 je  @@lookCode175
  3677 000015CC EB9A                     jmp @@lookCode169
  3678                                  @@lookCode175:
  3679                                  
  3680                                  ;-305 }
  3681                                  
  3682                                  
  3683                                  ;-306 // string functions error epilog XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  3684                                  
  3685                                  
  3686                                  ;-307 int printLine() { int i; char c;
  3687                                  
  3688                                  @@retn:
  3689 000015CE C3                       ret
  3690                                  ; ENDP
  3691                                  
  3692                                  printLine:  ; *** PROC ***
  3693                                  
  3694                                  ;-308   prs("\n"); printhex16(PCStart);
  3695                                  
  3696                                  ;Function : printLine, Number of local variables: 2
  3697                                  ;   # type sign width line used address name   list of local variables
  3698                                  ;  200 var sign word   307 NULL bp-2    i
  3699                                  ;  201 var sign byte   307 NULL bp-4    c;
  3700 000015CF C8040000                 ENTER  4,0
  3701 000015D3 68[6416]                 push printLine_0
  3702 000015D6 E80401                   call prs
  3703 000015D9 83C402                   add  sp, 2
  3704 000015DC FF36[3800]               push word [PCStart]
  3705 000015E0 E8EB01                   call printhex16
  3706 000015E3 83C402                   add  sp, 2
  3707                                  
  3708                                  ;-309   if (OpPrintIndex == 0) prs("                ");
  3709                                  
  3710 000015E6 A1[4900]                 mov ax, [OpPrintIndex]
  3711 000015E9 83F800                   cmp ax, 0
  3712 000015EC 0F850C00                 jne @@printLine176
  3713 000015F0 68[6716]                 push printLine_1
  3714 000015F3 E8E700                   call prs
  3715 000015F6 83C402                   add  sp, 2
  3716                                  
  3717                                  ;-310   else {
  3718                                  
  3719 000015F9 E95B00                   jmp @@printLine177
  3720                                  @@printLine176:
  3721                                  
  3722                                  ;-311     prc(PrReloc);
  3723                                  
  3724 000015FC A0[4D00]                 mov al, byte [PrReloc]
  3725 000015FF B400                     mov ah, 0
  3726 00001601 50                       push ax
  3727 00001602 E87700                   call prc
  3728 00001605 83C402                   add  sp, 2
  3729                                  
  3730                                  ;-312     i=0;
  3731                                  
  3732 00001608 66B800000000             mov eax, 0
  3733 0000160E 8946FE                   mov word [bp-2], ax
  3734                                  
  3735                                  ;-313     do {
  3736                                  
  3737                                  @@printLine178:
  3738                                  
  3739                                  ;-314       c=OpPos[i];
  3740                                  
  3741 00001611 8B5EFE                   mov bx, [bp-2]
  3742 00001614 8A871977                 mov al, [OpPos + bx]
  3743 00001618 8846FC                   mov byte [bp-4], al
  3744                                  
  3745                                  ;-315       printhex8a(c); prc(' ');
  3746                                  
  3747 0000161B 8A46FC                   mov al, byte [bp-4]
  3748 0000161E B400                     mov ah, 0
  3749 00001620 50                       push ax
  3750 00001621 E85C01                   call printhex8a
  3751 00001624 83C402                   add  sp, 2
  3752 00001627 6A20                     push 32
  3753 00001629 E85000                   call prc
  3754 0000162C 83C402                   add  sp, 2
  3755                                  
  3756                                  ;-316       i++;
  3757                                  
  3758 0000162F FF46FE                   inc  word [bp-2]
  3759                                  
  3760                                  ;-317     } while(i < OpPrintIndex);
  3761                                  
  3762 00001632 8B46FE                   mov ax, [bp-2]
  3763 00001635 3B06[4900]               cmp ax, [OpPrintIndex]
  3764 00001639 0F8D0200                 jge @@printLine179
  3765 0000163D EBD2                     jmp @@printLine178
  3766                                  @@printLine179:
  3767                                  
  3768                                  ;-318     do {// fill rest with blank
  3769                                  
  3770                                  @@printLine180:
  3771                                  
  3772                                  ;-319       prs("   ");
  3773                                  
  3774 0000163F 68[7816]                 push printLine_2
  3775 00001642 E89800                   call prs
  3776 00001645 83C402                   add  sp, 2
  3777                                  
  3778                                  ;-320       i++;
  3779                                  
  3780 00001648 FF46FE                   inc  word [bp-2]
  3781                                  
  3782                                  ;-321     } while(i < OPMAXLEN);
  3783                                  
  3784 0000164B 8B46FE                   mov ax, [bp-2]
  3785 0000164E 83F805                   cmp ax, 5
  3786 00001651 0F8D0200                 jge @@printLine181
  3787 00001655 EBE8                     jmp @@printLine180
  3788                                  @@printLine181:
  3789                                  
  3790                                  ;-322   }
  3791                                  
  3792                                  
  3793                                  ;-323   prscomment(InputBuf);
  3794                                  
  3795                                  @@printLine177:
  3796 00001657 8D06D075                 lea  ax, [InputBuf]
  3797 0000165B 50                       push ax
  3798 0000165C E85000                   call prscomment
  3799 0000165F 83C402                   add  sp, 2
  3800                                  
  3801                                  ;-324 }
  3802                                  
  3803                                  
  3804                                  ;-325 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  3805 00001662 C9                       LEAVE
  3806 00001663 C3                       ret
  3807                                  ; ENDP
  3808 00001664 5C6E00                  printLine_0 db "\n",0
  3809 00001667 202020202020202020-     printLine_1 db "                ",0
  3810 00001670 2020202020202000   
  3811 00001678 20202000                printLine_2 db "   ",0
  3812                                  
  3813                                  prc:  ; *** PROC ***
  3814                                  ;Function : prc, Number of local variables: 1
  3815                                  ;   # type sign width line used address name   list of local variables
  3816                                  ;  200 var unsg byte   325 NULL bp+4    c;
  3817 0000167C C8000000                 ENTER  0,0
  3818 00001680 A0[2400]                 mov al, [LIST]
  3819 00001683 08C0                     or  al, al
  3820 00001685 0F841400                 je @@prc182
  3821 00001689 807E040A                cmp byte [bp+4], 10
  3822 0000168D 0F850600                 jne @@prc183
  3823 00001691 B80D00                   mov  ax, 13
  3824 00001694 E81907                   call writetty
  3825                                  
  3826                                  ;-326      al=c; writetty(); }
  3827                                  
  3828                                  @@prc183:
  3829 00001697 8A4604                   mov  al, [bp+4]
  3830 0000169A E81307                   call writetty
  3831                                  
  3832                                  ;-327    fputcR(c,lst_fd); }
  3833                                  
  3834                                  @@prc182:
  3835 0000169D FF36[2B00]               push word [lst_fd]
  3836 000016A1 8A4604                   mov al, byte [bp+4]
  3837 000016A4 B400                     mov ah, 0
  3838 000016A6 50                       push ax
  3839 000016A7 E8C608                   call fputcR
  3840 000016AA 83C404                   add  sp, 4
  3841                                  
  3842                                  ;-328 
  3843                                  
  3844                                  
  3845                                  ;-329 int prscomment(unsigned char *s) {unsigned char c;
  3846 000016AD C9                       LEAVE
  3847 000016AE C3                       ret
  3848                                  ; ENDP
  3849                                  
  3850                                  prscomment:  ; *** PROC ***
  3851                                  
  3852                                  ;-330   while(*s){c=*s;prc(c);s++;}
  3853                                  
  3854                                  ;Function : prscomment, Number of local variables: 2
  3855                                  ;   # type sign width line used address name   list of local variables
  3856                                  ;  200 ptr unsg byte   329 NULL bp+4    s
  3857                                  ;  201 var unsg byte   329 NULL bp-2    c;
  3858 000016AF C8020000                 ENTER  2,0
  3859                                  @@prscomment184:
  3860 000016B3 8B5E04                   mov bx, [bp+4]
  3861 000016B6 8A07                     mov al, [bx]
  3862 000016B8 B400                     mov ah, 0
  3863 000016BA 08C0                     or  al, al
  3864 000016BC 0F841B00                 je @@prscomment185
  3865 000016C0 8B5E04                   mov bx, [bp+4]
  3866 000016C3 8A07                     mov al, [bx]
  3867 000016C5 B400                     mov ah, 0
  3868 000016C7 8846FE                   mov byte [bp-2], al
  3869 000016CA 8A46FE                   mov al, byte [bp-2]
  3870 000016CD B400                     mov ah, 0
  3871 000016CF 50                       push ax
  3872 000016D0 E8A9FF                   call prc
  3873 000016D3 83C402                   add  sp, 2
  3874 000016D6 FF4604                   inc  word [bp+4]
  3875                                  
  3876                                  ;-331 }
  3877                                  
  3878 000016D9 EBD8                     jmp @@prscomment184
  3879                                  @@prscomment185:
  3880                                  
  3881                                  ;-332 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3882 000016DB C9                       LEAVE
  3883 000016DC C3                       ret
  3884                                  ; ENDP
  3885                                  
  3886                                  prs:  ; *** PROC ***
  3887                                  ;Function : prs, Number of local variables: 3
  3888                                  ;   # type sign width line used address name   list of local variables
  3889                                  ;  200 ptr unsg byte   332 NULL bp+4    s
  3890                                  ;  201 var unsg byte   332 NULL bp-2    c
  3891                                  ;  202 var sign word   332 NULL bp-4    com;
  3892 000016DD C8040000                 ENTER  4,0
  3893 000016E1 66B800000000             mov eax, 0
  3894 000016E7 8946FC                   mov word [bp-4], ax
  3895                                  
  3896                                  ;-333   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3897                                  
  3898                                  @@prs186:
  3899 000016EA 8B5E04                   mov bx, [bp+4]
  3900 000016ED 8A07                     mov al, [bx]
  3901 000016EF B400                     mov ah, 0
  3902 000016F1 08C0                     or  al, al
  3903 000016F3 0F848700                 je @@prs187
  3904 000016F7 8B5E04                   mov bx, [bp+4]
  3905 000016FA 8A07                     mov al, [bx]
  3906 000016FC B400                     mov ah, 0
  3907 000016FE 8846FE                   mov byte [bp-2], al
  3908 00001701 8A46FE                   mov al, [bp-2]
  3909 00001704 3C22                     cmp al, 34
  3910 00001706 0F851E00                 jne @@prs188
  3911 0000170A 8B46FC                   mov ax, [bp-4]
  3912 0000170D 08C0                     or  al, al
  3913 0000170F 0F840C00                 je @@prs189
  3914 00001713 66B800000000             mov eax, 0
  3915 00001719 8946FC                   mov word [bp-4], ax
  3916 0000171C E90900                   jmp @@prs190
  3917                                  @@prs189:
  3918 0000171F 66B801000000             mov eax, 1
  3919 00001725 8946FC                   mov word [bp-4], ax
  3920                                  
  3921                                  ;-334     if (c==92) { if (com==0) { s++; c=*s;
  3922                                  
  3923                                  @@prs190:
  3924                                  @@prs188:
  3925 00001728 8A46FE                   mov al, [bp-2]
  3926 0000172B 3C5C                     cmp al, 92
  3927 0000172D 0F853B00                 jne @@prs191
  3928 00001731 8B46FC                   mov ax, [bp-4]
  3929 00001734 83F800                   cmp ax, 0
  3930 00001737 0F853100                 jne @@prs192
  3931 0000173B FF4604                   inc  word [bp+4]
  3932 0000173E 8B5E04                   mov bx, [bp+4]
  3933 00001741 8A07                     mov al, [bx]
  3934 00001743 B400                     mov ah, 0
  3935 00001745 8846FE                   mov byte [bp-2], al
  3936                                  
  3937                                  ;-335           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3938                                  
  3939 00001748 8A46FE                   mov al, [bp-2]
  3940 0000174B 3C6E                     cmp al, 110
  3941 0000174D 0F850900                 jne @@prs193
  3942 00001751 66B80A000000             mov eax, 10
  3943 00001757 8846FE                   mov byte [bp-2], al
  3944                                  @@prs193:
  3945 0000175A 8A46FE                   mov al, [bp-2]
  3946 0000175D 3C74                     cmp al, 116
  3947 0000175F 0F850900                 jne @@prs194
  3948 00001763 66B809000000             mov eax, 9
  3949 00001769 8846FE                   mov byte [bp-2], al
  3950                                  @@prs194:
  3951                                  @@prs192:
  3952                                  @@prs191:
  3953 0000176C 8A46FE                   mov al, byte [bp-2]
  3954 0000176F B400                     mov ah, 0
  3955 00001771 50                       push ax
  3956 00001772 E807FF                   call prc
  3957 00001775 83C402                   add  sp, 2
  3958 00001778 FF4604                   inc  word [bp+4]
  3959                                  
  3960                                  ;-336 }
  3961                                  
  3962 0000177B E96CFF                   jmp @@prs186
  3963                                  @@prs187:
  3964                                  
  3965                                  ;-337 int printhex8a(unsigned int c) { unsigned int nib;
  3966 0000177E C9                       LEAVE
  3967 0000177F C3                       ret
  3968                                  ; ENDP
  3969                                  
  3970                                  printhex8a:  ; *** PROC ***
  3971                                  
  3972                                  ;-338   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3973                                  
  3974                                  ;Function : printhex8a, Number of local variables: 2
  3975                                  ;   # type sign width line used address name   list of local variables
  3976                                  ;  200 var unsg word   337 NULL bp+4    c
  3977                                  ;  201 var unsg word   337 NULL bp-2    nib;
  3978 00001780 C8020000                 ENTER  2,0
  3979 00001784 8B4604                   mov ax, [bp+4]
  3980 00001787 C1E804                   shr ax, 4
  3981 0000178A 8946FE                   mov word [bp-2], ax
  3982 0000178D 8346FE30                 add  word [bp-2], 48
  3983 00001791 8B46FE                   mov ax, [bp-2]
  3984 00001794 83F839                   cmp ax, 57
  3985 00001797 0F8E0400                 jle @@printhex8a195
  3986 0000179B 8346FE07                 add  word [bp-2], 7
  3987                                  @@printhex8a195:
  3988 0000179F FF76FE                   push word [bp-2]
  3989 000017A2 E8D7FE                   call prc
  3990 000017A5 83C402                   add  sp, 2
  3991                                  
  3992                                  ;-339   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3993                                  
  3994 000017A8 8B4604                   mov ax, [bp+4]
  3995 000017AB 83E00F                   and ax, 15
  3996 000017AE 8946FE                   mov word [bp-2], ax
  3997 000017B1 8346FE30                 add  word [bp-2], 48
  3998 000017B5 8B46FE                   mov ax, [bp-2]
  3999 000017B8 83F839                   cmp ax, 57
  4000 000017BB 0F8E0400                 jle @@printhex8a196
  4001 000017BF 8346FE07                 add  word [bp-2], 7
  4002                                  @@printhex8a196:
  4003 000017C3 FF76FE                   push word [bp-2]
  4004 000017C6 E8B3FE                   call prc
  4005 000017C9 83C402                   add  sp, 2
  4006                                  
  4007                                  ;-340 }
  4008                                  
  4009                                  
  4010                                  ;-341 int printhex16(unsigned int i) {unsigned int half;
  4011 000017CC C9                       LEAVE
  4012 000017CD C3                       ret
  4013                                  ; ENDP
  4014                                  
  4015                                  printhex16:  ; *** PROC ***
  4016                                  
  4017                                  ;-342   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4018                                  
  4019                                  ;Function : printhex16, Number of local variables: 2
  4020                                  ;   # type sign width line used address name   list of local variables
  4021                                  ;  200 var unsg word   341 NULL bp+4    i
  4022                                  ;  201 var unsg word   341 NULL bp-2    half;
  4023 000017CE C8020000                 ENTER  2,0
  4024 000017D2 8B4604                   mov ax, [bp+4]
  4025 000017D5 C1E808                   shr ax, 8
  4026 000017D8 8946FE                   mov word [bp-2], ax
  4027 000017DB FF76FE                   push word [bp-2]
  4028 000017DE E89FFF                   call printhex8a
  4029 000017E1 83C402                   add  sp, 2
  4030 000017E4 8B4604                   mov ax, [bp+4]
  4031 000017E7 25FF00                   and ax, 255
  4032 000017EA 8946FE                   mov word [bp-2], ax
  4033 000017ED FF76FE                   push word [bp-2]
  4034 000017F0 E88DFF                   call printhex8a
  4035 000017F3 83C402                   add  sp, 2
  4036                                  
  4037                                  ;-343 }
  4038                                  
  4039                                  
  4040                                  ;-344 int printIntU(unsigned int n) { unsigned int e;
  4041 000017F6 C9                       LEAVE
  4042 000017F7 C3                       ret
  4043                                  ; ENDP
  4044                                  
  4045                                  printIntU:  ; *** PROC ***
  4046                                  
  4047                                  ;-345   if ( _ n >= 10) {  e=n/10; //DIV
  4048                                  
  4049                                  ;Function : printIntU, Number of local variables: 2
  4050                                  ;   # type sign width line used address name   list of local variables
  4051                                  ;  200 var unsg word   344 NULL bp+4    n
  4052                                  ;  201 var unsg word   344 NULL bp-2    e;
  4053 000017F8 C8020000                 ENTER  2,0
  4054 000017FC 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4055 00001800 0F821700                 jb  @@printIntU197
  4056 00001804 8B4604                   mov ax, [bp+4]
  4057 00001807 BB0A00                   mov bx, 10
  4058 0000180A BA0000                   mov dx, 0
  4059 0000180D F7F3                     div bx
  4060 0000180F 8946FE                   mov word [bp-2], ax
  4061                                  
  4062                                  ;-346     printIntU(e); }
  4063                                  
  4064 00001812 FF76FE                   push word [bp-2]
  4065 00001815 E8E0FF                   call printIntU
  4066 00001818 83C402                   add  sp, 2
  4067                                  
  4068                                  ;-347     n = n % 10; //unsigned mod
  4069                                  
  4070                                  @@printIntU197:
  4071 0000181B 8B4604                   mov ax, [bp+4]
  4072 0000181E BB0A00                   mov bx, 10
  4073 00001821 BA0000                   mov dx, 0
  4074 00001824 F7F3                     div bx
  4075 00001826 89D0                     mov ax, dx
  4076 00001828 894604                   mov word [bp+4], ax
  4077                                  
  4078                                  ;-348     n += '0'; prc(n);
  4079                                  
  4080 0000182B 83460430                 add  word [bp+4], 48
  4081 0000182F FF7604                   push word [bp+4]
  4082 00001832 E847FE                   call prc
  4083 00001835 83C402                   add  sp, 2
  4084                                  
  4085                                  ;-349 }
  4086                                  
  4087                                  
  4088                                  ;-350 /*int printLineHex(unsigned char *s) { int L; char c;
  4089                                  
  4090                                  
  4091                                  ;-351   L = strlen(s);
  4092                                  
  4093                                  
  4094                                  ;-352   prs(" L:");
  4095                                  
  4096                                  
  4097                                  ;-353   printIntU(L);
  4098                                  
  4099                                  
  4100                                  ;-354   if (L <= 0) return;
  4101                                  
  4102                                  
  4103                                  ;-355   if (L > 80) errorexit("Line > 80 char");
  4104                                  
  4105                                  
  4106                                  ;-356   while ( *s ) {
  4107                                  
  4108                                  
  4109                                  ;-357     c = *s;
  4110                                  
  4111                                  
  4112                                  ;-358     prc(' ');
  4113                                  
  4114                                  
  4115                                  ;-359     printhex8a(c);
  4116                                  
  4117                                  
  4118                                  ;-360     s++;
  4119                                  
  4120                                  
  4121                                  ;-361   }
  4122                                  
  4123                                  
  4124                                  ;-362 } */
  4125                                  
  4126                                  
  4127                                  ;-363 int error1(char *s) { LIST=1; ErrorCount++;
  4128 00001838 C9                       LEAVE
  4129 00001839 C3                       ret
  4130                                  ; ENDP
  4131                                  
  4132                                  error1:  ; *** PROC ***
  4133                                  ;Function : error1, Number of local variables: 1
  4134                                  ;   # type sign width line used address name   list of local variables
  4135                                  ;  200 ptr sign byte   363 NULL bp+4    s;
  4136 0000183A C8000000                 ENTER  0,0
  4137 0000183E 66B801000000             mov eax, 1
  4138 00001844 A2[2400]                 mov byte [LIST], al
  4139 00001847 FF06[3100]               inc  word [ErrorCount]
  4140                                  
  4141                                  ;-364   prs("\n;***** next line ERROR: "); prs(s);
  4142                                  
  4143 0000184B 68[7318]                 push error1_0
  4144 0000184E E88CFE                   call prs
  4145 00001851 83C402                   add  sp, 2
  4146 00001854 FF7604                   push word [bp+4]
  4147 00001857 E883FE                   call prs
  4148 0000185A 83C402                   add  sp, 2
  4149                                  
  4150                                  ;-365   prs(", Symbol: "); prs(Symbol);}
  4151                                  
  4152 0000185D 68[8E18]                 push error1_1
  4153 00001860 E87AFE                   call prs
  4154 00001863 83C402                   add  sp, 2
  4155 00001866 8D063075                 lea  ax, [Symbol]
  4156 0000186A 50                       push ax
  4157 0000186B E86FFE                   call prs
  4158 0000186E 83C402                   add  sp, 2
  4159                                  
  4160                                  ;-366 int allowederror(){error1("not allowed here"); }
  4161 00001871 C9                       LEAVE
  4162 00001872 C3                       ret
  4163                                  ; ENDP
  4164 00001873 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4165 0000187C 6E657874206C696E65-
  4166 00001885 204552524F523A2000 
  4167 0000188E 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4168 00001897 2000               
  4169                                  
  4170                                  allowederror:  ; *** PROC ***
  4171 00001899 68[A318]                 push allowederror_0
  4172 0000189C E89BFF                   call error1
  4173 0000189F 83C402                   add  sp, 2
  4174                                  
  4175                                  ;-367 int implmerror(){error1("not implemented");}
  4176                                  
  4177 000018A2 C3                       ret
  4178                                  ; ENDP
  4179 000018A3 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4180 000018AC 6564206865726500   
  4181                                  
  4182                                  implmerror:  ; *** PROC ***
  4183 000018B4 68[BE18]                 push implmerror_0
  4184 000018B7 E880FF                   call error1
  4185 000018BA 83C402                   add  sp, 2
  4186                                  
  4187                                  ;-368 int indexerror (){error1("invalid index register");}
  4188                                  
  4189 000018BD C3                       ret
  4190                                  ; ENDP
  4191 000018BE 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4192 000018C7 6D656E74656400     
  4193                                  
  4194                                  indexerror:  ; *** PROC ***
  4195 000018CE 68[D818]                 push indexerror_0
  4196 000018D1 E866FF                   call error1
  4197 000018D4 83C402                   add  sp, 2
  4198                                  
  4199                                  ;-369 int numbererror(){error1("number expected");}
  4200                                  
  4201 000018D7 C3                       ret
  4202                                  ; ENDP
  4203 000018D8 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4204 000018E1 6E6465782072656769-
  4205 000018EA 7374657200         
  4206                                  
  4207                                  numbererror:  ; *** PROC ***
  4208 000018EF 68[F918]                 push numbererror_0
  4209 000018F2 E845FF                   call error1
  4210 000018F5 83C402                   add  sp, 2
  4211                                  
  4212                                  ;-370 int regmemerror(){error1("only register or memory allowed");}
  4213                                  
  4214 000018F8 C3                       ret
  4215                                  ; ENDP
  4216 000018F9 6E756D626572206578-     numbererror_0 db "number expected",0
  4217 00001902 70656374656400     
  4218                                  
  4219                                  regmemerror:  ; *** PROC ***
  4220 00001909 68[1319]                 push regmemerror_0
  4221 0000190C E82BFF                   call error1
  4222 0000190F 83C402                   add  sp, 2
  4223                                  
  4224                                  ;-371 int segregerror(){error1("segment register not allowed");}
  4225                                  
  4226 00001912 C3                       ret
  4227                                  ; ENDP
  4228 00001913 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4229 0000191C 73746572206F72206D-
  4230 00001925 656D6F727920616C6C-
  4231 0000192E 6F77656400         
  4232                                  
  4233                                  segregerror:  ; *** PROC ***
  4234 00001933 68[3D19]                 push segregerror_0
  4235 00001936 E801FF                   call error1
  4236 00001939 83C402                   add  sp, 2
  4237                                  
  4238                                  ;-372 int syntaxerror(){error1("syntax");}
  4239                                  
  4240 0000193C C3                       ret
  4241                                  ; ENDP
  4242 0000193D 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4243 00001946 65676973746572206E-
  4244 0000194F 6F7420616C6C6F7765-
  4245 00001958 6400               
  4246                                  
  4247                                  syntaxerror:  ; *** PROC ***
  4248 0000195A 68[6419]                 push syntaxerror_0
  4249 0000195D E8DAFE                   call error1
  4250 00001960 83C402                   add  sp, 2
  4251                                  
  4252                                  ;-373 
  4253                                  
  4254                                  
  4255                                  ;-374 int errorexit(char *s) { error1(s); end1(1);}
  4256                                  
  4257 00001963 C3                       ret
  4258                                  ; ENDP
  4259 00001964 73796E74617800          syntaxerror_0 db "syntax",0
  4260                                  
  4261                                  errorexit:  ; *** PROC ***
  4262                                  ;Function : errorexit, Number of local variables: 1
  4263                                  ;   # type sign width line used address name   list of local variables
  4264                                  ;  200 ptr sign byte   374 NULL bp+4    s;
  4265 0000196B C8000000                 ENTER  0,0
  4266 0000196F FF7604                   push word [bp+4]
  4267 00001972 E8C5FE                   call error1
  4268 00001975 83C402                   add  sp, 2
  4269 00001978 6A01                     push 1
  4270 0000197A E80604                   call end1
  4271 0000197D 83C402                   add  sp, 2
  4272                                  
  4273                                  ;-375 int addrexit(){errorexit("illegal addres");}
  4274 00001980 C9                       LEAVE
  4275 00001981 C3                       ret
  4276                                  ; ENDP
  4277                                  
  4278                                  addrexit:  ; *** PROC ***
  4279 00001982 68[8C19]                 push addrexit_0
  4280 00001985 E8E3FF                   call errorexit
  4281 00001988 83C402                   add  sp, 2
  4282                                  
  4283                                  ;-376 int internexit(){errorexit("intern compiler error");}
  4284                                  
  4285 0000198B C3                       ret
  4286                                  ; ENDP
  4287 0000198C 696C6C6567616C2061-     addrexit_0 db "illegal addres",0
  4288 00001995 646472657300       
  4289                                  
  4290                                  internexit:  ; *** PROC ***
  4291 0000199B 68[A519]                 push internexit_0
  4292 0000199E E8CAFF                   call errorexit
  4293 000019A1 83C402                   add  sp, 2
  4294                                  
  4295                                  ;-377 
  4296                                  
  4297                                  
  4298                                  ;-378 int getarg() { int arglen1; int i; char *c;
  4299                                  
  4300 000019A4 C3                       ret
  4301                                  ; ENDP
  4302 000019A5 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4303 000019AE 6D70696C6572206572-
  4304 000019B7 726F7200           
  4305                                  
  4306                                  getarg:  ; *** PROC ***
  4307                                  
  4308                                  ;-379   arglen1=*arglen;
  4309                                  
  4310                                  ;Function : getarg, Number of local variables: 3
  4311                                  ;   # type sign width line used address name   list of local variables
  4312                                  ;  200 var sign word   378 NULL bp-2    arglen1
  4313                                  ;  201 var sign word   378 NULL bp-4    i
  4314                                  ;  202 ptr sign byte   378 NULL bp-6    c;
  4315 000019BB C8060000                 ENTER  6,0
  4316 000019BF 8B1E[5600]               mov bx, [arglen]
  4317 000019C3 8A07                     mov al, [bx]
  4318 000019C5 B400                     mov ah, 0
  4319 000019C7 8946FE                   mov word [bp-2], ax
  4320                                  
  4321                                  ;-380   if (arglen1==0) {
  4322                                  
  4323 000019CA 8B46FE                   mov ax, [bp-2]
  4324 000019CD 83F800                   cmp ax, 0
  4325 000019D0 0F851C00                 jne @@getarg198
  4326                                  
  4327                                  ;-381     cputs(Version1);
  4328                                  
  4329 000019D4 8D06[1000]               lea  ax, [Version1]
  4330 000019D8 50                       push ax
  4331 000019D9 E8DC03                   call cputs
  4332 000019DC 83C402                   add  sp, 2
  4333                                  
  4334                                  ;-382     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4335                                  
  4336 000019DF 68[801B]                 push getarg_0
  4337 000019E2 E8D303                   call cputs
  4338 000019E5 83C402                   add  sp, 2
  4339                                  
  4340                                  ;-383     exitR(3);
  4341                                  
  4342 000019E8 6A03                     push 3
  4343 000019EA E8A605                   call exitR
  4344 000019ED 83C402                   add  sp, 2
  4345                                  
  4346                                  ;-384   }
  4347                                  
  4348                                  
  4349                                  ;-385   i=arglen1+129; *i=0;  arglen1--;
  4350                                  
  4351                                  @@getarg198:
  4352 000019F0 8B46FE                   mov ax, [bp-2]
  4353 000019F3 058100                   add ax, 129
  4354 000019F6 8946FC                   mov word [bp-4], ax
  4355 000019F9 66B800000000             mov eax, 0
  4356 000019FF 8B5EFC                   mov  bx, [bp-4]
  4357 00001A02 8907                     mov  [bx], ax
  4358 00001A04 FF4EFE                   dec  word [bp-2]
  4359                                  
  4360                                  ;-386   toupper(argv);
  4361                                  
  4362 00001A07 FF36[5800]               push word [argv]
  4363 00001A0B E8D803                   call toupper
  4364 00001A0E 83C402                   add  sp, 2
  4365                                  
  4366                                  ;-387   strcpy(namein, argv); strcat1(namein, ".S");
  4367                                  
  4368 00001A11 FF36[5800]               push word [argv]
  4369 00001A15 8D065076                 lea  ax, [namein]
  4370 00001A19 50                       push ax
  4371 00001A1A E83704                   call strcpy
  4372 00001A1D 83C404                   add  sp, 4
  4373 00001A20 68[A51B]                 push getarg_1
  4374 00001A23 8D065076                 lea  ax, [namein]
  4375 00001A27 50                       push ax
  4376 00001A28 E8EA04                   call strcat1
  4377 00001A2B 83C404                   add  sp, 4
  4378                                  
  4379                                  ;-388   strcpy(namelst,argv); strcat1(namelst,".LST");
  4380                                  
  4381 00001A2E FF36[5800]               push word [argv]
  4382 00001A32 8D069376                 lea  ax, [namelst]
  4383 00001A36 50                       push ax
  4384 00001A37 E81A04                   call strcpy
  4385 00001A3A 83C404                   add  sp, 4
  4386 00001A3D 68[A81B]                 push getarg_2
  4387 00001A40 8D069376                 lea  ax, [namelst]
  4388 00001A44 50                       push ax
  4389 00001A45 E8CD04                   call strcat1
  4390 00001A48 83C404                   add  sp, 4
  4391                                  
  4392                                  ;-389   strcpy(namebin,argv); strcat1(namebin,".COM");
  4393                                  
  4394 00001A4B FF36[5800]               push word [argv]
  4395 00001A4F 8D06D676                 lea  ax, [namebin]
  4396 00001A53 50                       push ax
  4397 00001A54 E8FD03                   call strcpy
  4398 00001A57 83C404                   add  sp, 4
  4399 00001A5A 68[AD1B]                 push getarg_3
  4400 00001A5D 8D06D676                 lea  ax, [namebin]
  4401 00001A61 50                       push ax
  4402 00001A62 E8B004                   call strcat1
  4403 00001A65 83C404                   add  sp, 4
  4404                                  
  4405                                  ;-390 
  4406                                  
  4407                                  
  4408                                  ;-391   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4409                                  
  4410 00001A68 66B801000000             mov eax, 1
  4411 00001A6E A2[2400]                 mov byte [LIST], al
  4412 00001A71 66B800000000             mov eax, 0
  4413 00001A77 A3[2F00]                 mov word [DOS_ERR], ax
  4414 00001A7A 66B800000000             mov eax, 0
  4415 00001A80 A3[3600]                 mov word [PC], ax
  4416 00001A83 66B800000000             mov eax, 0
  4417 00001A89 A3[3100]                 mov word [ErrorCount], ax
  4418                                  
  4419                                  ;-392   asm_fd=openR (namein);
  4420                                  
  4421 00001A8C 8D065076                 lea  ax, [namein]
  4422 00001A90 50                       push ax
  4423 00001A91 E8A604                   call openR
  4424 00001A94 83C402                   add  sp, 2
  4425 00001A97 A3[2900]                 mov word [asm_fd], ax
  4426                                  
  4427                                  ;-393   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4428                                  
  4429 00001A9A A1[2F00]                 mov ax, [DOS_ERR]
  4430 00001A9D 08C0                     or  al, al
  4431 00001A9F 0F841C00                 je @@getarg199
  4432 00001AA3 68[B21B]                 push getarg_4
  4433 00001AA6 E80F03                   call cputs
  4434 00001AA9 83C402                   add  sp, 2
  4435 00001AAC 8D065076                 lea  ax, [namein]
  4436 00001AB0 50                       push ax
  4437 00001AB1 E80403                   call cputs
  4438 00001AB4 83C402                   add  sp, 2
  4439 00001AB7 6A01                     push 1
  4440 00001AB9 E8D704                   call exitR
  4441 00001ABC 83C402                   add  sp, 2
  4442                                  
  4443                                  ;-394   lst_fd=creatR(namelst);
  4444                                  
  4445                                  @@getarg199:
  4446 00001ABF 8D069376                 lea  ax, [namelst]
  4447 00001AC3 50                       push ax
  4448 00001AC4 E88204                   call creatR
  4449 00001AC7 83C402                   add  sp, 2
  4450 00001ACA A3[2B00]                 mov word [lst_fd], ax
  4451                                  
  4452                                  ;-395   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4453                                  
  4454 00001ACD A1[2F00]                 mov ax, [DOS_ERR]
  4455 00001AD0 08C0                     or  al, al
  4456 00001AD2 0F841C00                 je @@getarg200
  4457 00001AD6 68[C81B]                 push getarg_5
  4458 00001AD9 E8DC02                   call cputs
  4459 00001ADC 83C402                   add  sp, 2
  4460 00001ADF 8D069376                 lea  ax, [namelst]
  4461 00001AE3 50                       push ax
  4462 00001AE4 E8D102                   call cputs
  4463 00001AE7 83C402                   add  sp, 2
  4464 00001AEA 6A02                     push 2
  4465 00001AEC E8A404                   call exitR
  4466 00001AEF 83C402                   add  sp, 2
  4467                                  
  4468                                  ;-396   bin_fd=creatR(namebin);
  4469                                  
  4470                                  @@getarg200:
  4471 00001AF2 8D06D676                 lea  ax, [namebin]
  4472 00001AF6 50                       push ax
  4473 00001AF7 E84F04                   call creatR
  4474 00001AFA 83C402                   add  sp, 2
  4475 00001AFD A3[2D00]                 mov word [bin_fd], ax
  4476                                  
  4477                                  ;-397   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4478                                  
  4479 00001B00 A1[2F00]                 mov ax, [DOS_ERR]
  4480 00001B03 08C0                     or  al, al
  4481 00001B05 0F841C00                 je @@getarg201
  4482 00001B09 68[DF1B]                 push getarg_6
  4483 00001B0C E8A902                   call cputs
  4484 00001B0F 83C402                   add  sp, 2
  4485 00001B12 8D06D676                 lea  ax, [namebin]
  4486 00001B16 50                       push ax
  4487 00001B17 E89E02                   call cputs
  4488 00001B1A 83C402                   add  sp, 2
  4489 00001B1D 6A02                     push 2
  4490 00001B1F E87104                   call exitR
  4491 00001B22 83C402                   add  sp, 2
  4492                                  
  4493                                  ;-398   prs(";");prs(Version1);
  4494                                  
  4495                                  @@getarg201:
  4496 00001B25 68[F51B]                 push getarg_7
  4497 00001B28 E8B2FB                   call prs
  4498 00001B2B 83C402                   add  sp, 2
  4499 00001B2E 8D06[1000]               lea  ax, [Version1]
  4500 00001B32 50                       push ax
  4501 00001B33 E8A7FB                   call prs
  4502 00001B36 83C402                   add  sp, 2
  4503                                  
  4504                                  ;-399   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4505                                  
  4506 00001B39 68[F71B]                 push getarg_8
  4507 00001B3C E89EFB                   call prs
  4508 00001B3F 83C402                   add  sp, 2
  4509 00001B42 8D065076                 lea  ax, [namein]
  4510 00001B46 50                       push ax
  4511 00001B47 E893FB                   call prs
  4512 00001B4A 83C402                   add  sp, 2
  4513 00001B4D 68[021C]                 push getarg_9
  4514 00001B50 E88AFB                   call prs
  4515 00001B53 83C402                   add  sp, 2
  4516 00001B56 8D069376                 lea  ax, [namelst]
  4517 00001B5A 50                       push ax
  4518 00001B5B E87FFB                   call prs
  4519 00001B5E 83C402                   add  sp, 2
  4520                                  
  4521                                  ;-400   prs(", "); prs(namebin);
  4522                                  
  4523 00001B61 68[0D1C]                 push getarg_10
  4524 00001B64 E876FB                   call prs
  4525 00001B67 83C402                   add  sp, 2
  4526 00001B6A 8D06D676                 lea  ax, [namebin]
  4527 00001B6E 50                       push ax
  4528 00001B6F E86BFB                   call prs
  4529 00001B72 83C402                   add  sp, 2
  4530                                  
  4531                                  ;-401   prs("\n");
  4532                                  
  4533 00001B75 68[101C]                 push getarg_11
  4534 00001B78 E862FB                   call prs
  4535 00001B7B 83C402                   add  sp, 2
  4536                                  
  4537                                  ;-402 }
  4538                                  
  4539                                  
  4540                                  ;-403 int epilog() { int i; int j; char c;
  4541 00001B7E C9                       LEAVE
  4542 00001B7F C3                       ret
  4543                                  ; ENDP
  4544 00001B80 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4545 00001B89 41532E434F4D206669-
  4546 00001B92 6C656E616D65205B77-
  4547 00001B9B 2F6F202E535D203A20-
  4548 00001BA4 00                 
  4549 00001BA5 2E5300                  getarg_1 db ".S",0
  4550 00001BA8 2E4C535400              getarg_2 db ".LST",0
  4551 00001BAD 2E434F4D00              getarg_3 db ".COM",0
  4552 00001BB2 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4553 00001BBB 6C65206D697373696E-
  4554 00001BC4 673A2000           
  4555 00001BC8 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4556 00001BD1 206E6F742063726561-
  4557 00001BDA 74653A2000         
  4558 00001BDF 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4559 00001BE8 6E6F74206372656174-
  4560 00001BF1 653A2000           
  4561 00001BF5 3B00                    getarg_7 db ";",0
  4562 00001BF7 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4563 00001C00 2000               
  4564 00001C02 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4565 00001C0B 2000               
  4566 00001C0D 2C2000                  getarg_10 db ", ",0
  4567 00001C10 5C6E00                  getarg_11 db "\n",0
  4568                                  
  4569                                  epilog:  ; *** PROC ***
  4570                                  
  4571                                  ;-404   prs("\n;END Errors: "); printIntU(ErrorCount);
  4572                                  
  4573                                  ;Function : epilog, Number of local variables: 3
  4574                                  ;   # type sign width line used address name   list of local variables
  4575                                  ;  200 var sign word   403 NULL bp-2    i
  4576                                  ;  201 var sign word   403 NULL bp-4    j
  4577                                  ;  202 var sign byte   403 NULL bp-6    c;
  4578 00001C13 C8060000                 ENTER  6,0
  4579 00001C17 68[3C1D]                 push epilog_0
  4580 00001C1A E8C0FA                   call prs
  4581 00001C1D 83C402                   add  sp, 2
  4582 00001C20 FF36[3100]               push word [ErrorCount]
  4583 00001C24 E8D1FB                   call printIntU
  4584 00001C27 83C402                   add  sp, 2
  4585                                  
  4586                                  ;-405   if (ErrorCount) prs(" ***ERROR*** ");
  4587                                  
  4588 00001C2A A1[3100]                 mov ax, [ErrorCount]
  4589 00001C2D 08C0                     or  al, al
  4590 00001C2F 0F840900                 je @@epilog202
  4591 00001C33 68[4C1D]                 push epilog_1
  4592 00001C36 E8A4FA                   call prs
  4593 00001C39 83C402                   add  sp, 2
  4594                                  
  4595                                  ;-406   prs(", Label & Var: ");
  4596                                  
  4597                                  @@epilog202:
  4598 00001C3C 68[5A1D]                 push epilog_2
  4599 00001C3F E89BFA                   call prs
  4600 00001C42 83C402                   add  sp, 2
  4601                                  
  4602                                  ;-407 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4603                                  
  4604                                  
  4605                                  ;-408   i= &LabelNames;
  4606                                  
  4607                                  
  4608                                  ;-409   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4609                                  
  4610                                  
  4611                                  ;-410   } while (i < LabelNamePtr); prs("<< \n"); */
  4612                                  
  4613                                  
  4614                                  ;-411   if (LabelMaxIx) {
  4615                                  
  4616 00001C45 A1[5000]                 mov ax, [LabelMaxIx]
  4617 00001C48 08C0                     or  al, al
  4618 00001C4A 0F846900                 je @@epilog203
  4619                                  
  4620                                  ;-412     i = 1;
  4621                                  
  4622 00001C4E 66B801000000             mov eax, 1
  4623 00001C54 8946FE                   mov word [bp-2], ax
  4624                                  
  4625                                  ;-413     LabelNamePtr= &LabelNames;
  4626                                  
  4627 00001C57 B81E77                   mov ax, LabelNames
  4628 00001C5A A3[4E00]                 mov word [LabelNamePtr], ax
  4629                                  
  4630                                  ;-414     do {
  4631                                  
  4632                                  @@epilog204:
  4633                                  
  4634                                  ;-415       prs(LabelNamePtr); prc(' ');
  4635                                  
  4636 00001C5D FF36[4E00]               push word [LabelNamePtr]
  4637 00001C61 E879FA                   call prs
  4638 00001C64 83C402                   add  sp, 2
  4639 00001C67 6A20                     push 32
  4640 00001C69 E810FA                   call prc
  4641 00001C6C 83C402                   add  sp, 2
  4642                                  
  4643                                  ;-416       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4644                                  
  4645 00001C6F 8B5EFE                   mov bx, [bp-2]
  4646 00001C72 D1E3                     shl bx, 1
  4647 00001C74 8B87067B                 mov ax, [LabelAddr + bx]
  4648 00001C78 8946FC                   mov word [bp-4], ax
  4649 00001C7B FF76FC                   push word [bp-4]
  4650 00001C7E E84DFB                   call printhex16
  4651 00001C81 83C402                   add  sp, 2
  4652 00001C84 68[6A1D]                 push epilog_3
  4653 00001C87 E853FA                   call prs
  4654 00001C8A 83C402                   add  sp, 2
  4655                                  
  4656                                  ;-417       j=strlen(LabelNamePtr);//get end of actual name
  4657                                  
  4658 00001C8D FF36[4E00]               push word [LabelNamePtr]
  4659 00001C91 E89501                   call strlen
  4660 00001C94 83C402                   add  sp, 2
  4661 00001C97 8946FC                   mov word [bp-4], ax
  4662                                  
  4663                                  ;-418       LabelNamePtr=LabelNamePtr+j;
  4664                                  
  4665 00001C9A A1[4E00]                 mov ax, [LabelNamePtr]
  4666 00001C9D 0346FC                   add ax, [bp-4]
  4667 00001CA0 A3[4E00]                 mov word [LabelNamePtr], ax
  4668                                  
  4669                                  ;-419       LabelNamePtr++;
  4670                                  
  4671 00001CA3 FF06[4E00]               inc  word [LabelNamePtr]
  4672                                  
  4673                                  ;-420       i++;
  4674                                  
  4675 00001CA7 FF46FE                   inc  word [bp-2]
  4676                                  
  4677                                  ;-421     } while (i <= LabelMaxIx);
  4678                                  
  4679 00001CAA 8B46FE                   mov ax, [bp-2]
  4680 00001CAD 3B06[5000]               cmp ax, [LabelMaxIx]
  4681 00001CB1 0F8F0200                 jg  @@epilog205
  4682 00001CB5 EBA6                     jmp @@epilog204
  4683                                  @@epilog205:
  4684                                  
  4685                                  ;-422   }
  4686                                  
  4687                                  
  4688                                  ;-423   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4689                                  
  4690                                  @@epilog203:
  4691 00001CB7 68[6E1D]                 push epilog_4
  4692 00001CBA E820FA                   call prs
  4693 00001CBD 83C402                   add  sp, 2
  4694 00001CC0 FF36[5400]               push word [BinLen]
  4695 00001CC4 E831FB                   call printIntU
  4696 00001CC7 83C402                   add  sp, 2
  4697 00001CCA 68[7B1D]                 push epilog_5
  4698 00001CCD E80DFA                   call prs
  4699 00001CD0 83C402                   add  sp, 2
  4700                                  
  4701                                  ;-424   i=0;
  4702                                  
  4703 00001CD3 66B800000000             mov eax, 0
  4704 00001CD9 8946FE                   mov word [bp-2], ax
  4705                                  
  4706                                  ;-425   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4707                                  
  4708                                  @@epilog206:
  4709 00001CDC 6A20                     push 32
  4710 00001CDE E89BF9                   call prc
  4711 00001CE1 83C402                   add  sp, 2
  4712 00001CE4 8B5EFE                   mov bx, [bp-2]
  4713 00001CE7 8A87CE7B                 mov al, [FileBin + bx]
  4714 00001CEB 8946FC                   mov word [bp-4], ax
  4715 00001CEE FF76FC                   push word [bp-4]
  4716 00001CF1 E88CFA                   call printhex8a
  4717 00001CF4 83C402                   add  sp, 2
  4718 00001CF7 FF46FE                   inc  word [bp-2]
  4719                                  
  4720                                  ;-426   } while (i < BinLen);
  4721                                  
  4722 00001CFA 8B46FE                   mov ax, [bp-2]
  4723 00001CFD 3B06[5400]               cmp ax, [BinLen]
  4724 00001D01 0F8D0200                 jge @@epilog207
  4725 00001D05 EBD5                     jmp @@epilog206
  4726                                  @@epilog207:
  4727                                  
  4728                                  ;-427   i=0;
  4729                                  
  4730 00001D07 66B800000000             mov eax, 0
  4731 00001D0D 8946FE                   mov word [bp-2], ax
  4732                                  
  4733                                  ;-428   do {
  4734                                  
  4735                                  @@epilog208:
  4736                                  
  4737                                  ;-429     c = FileBin[i];
  4738                                  
  4739 00001D10 8B5EFE                   mov bx, [bp-2]
  4740 00001D13 8A87CE7B                 mov al, [FileBin + bx]
  4741 00001D17 8846FA                   mov byte [bp-6], al
  4742                                  
  4743                                  ;-430     fputcR(c, bin_fd);
  4744                                  
  4745 00001D1A FF36[2D00]               push word [bin_fd]
  4746 00001D1E 8A46FA                   mov al, byte [bp-6]
  4747 00001D21 B400                     mov ah, 0
  4748 00001D23 50                       push ax
  4749 00001D24 E84902                   call fputcR
  4750 00001D27 83C404                   add  sp, 4
  4751                                  
  4752                                  ;-431     i++;
  4753                                  
  4754 00001D2A FF46FE                   inc  word [bp-2]
  4755                                  
  4756                                  ;-432   } while (i < BinLen);
  4757                                  
  4758 00001D2D 8B46FE                   mov ax, [bp-2]
  4759 00001D30 3B06[5400]               cmp ax, [BinLen]
  4760 00001D34 0F8D0200                 jge @@epilog209
  4761 00001D38 EBD6                     jmp @@epilog208
  4762                                  @@epilog209:
  4763                                  
  4764                                  ;-433 }
  4765                                  
  4766                                  
  4767                                  ;-434 int end1(int n) {
  4768 00001D3A C9                       LEAVE
  4769 00001D3B C3                       ret
  4770                                  ; ENDP
  4771 00001D3C 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4772 00001D45 726F72733A2000     
  4773 00001D4C 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4774 00001D55 2A2A2A2000         
  4775 00001D5A 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4776 00001D63 205661723A2000     
  4777 00001D6A 2C202000                epilog_3 db ",  ",0
  4778 00001D6E 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4779 00001D77 6C652000           
  4780 00001D7B 2062797465733A00        epilog_5 db " bytes:",0
  4781                                  
  4782                                  end1:  ; *** PROC ***
  4783                                  
  4784                                  ;-435   fcloseR(asm_fd);
  4785                                  
  4786                                  ;Function : end1, Number of local variables: 1
  4787                                  ;   # type sign width line used address name   list of local variables
  4788                                  ;  200 var sign word   434 NULL bp+4    n;
  4789 00001D83 C8000000                 ENTER  0,0
  4790 00001D87 FF36[2900]               push word [asm_fd]
  4791 00001D8B E8F701                   call fcloseR
  4792 00001D8E 83C402                   add  sp, 2
  4793                                  
  4794                                  ;-436   fcloseR(lst_fd);
  4795                                  
  4796 00001D91 FF36[2B00]               push word [lst_fd]
  4797 00001D95 E8ED01                   call fcloseR
  4798 00001D98 83C402                   add  sp, 2
  4799                                  
  4800                                  ;-437   fcloseR(bin_fd);
  4801                                  
  4802 00001D9B FF36[2D00]               push word [bin_fd]
  4803 00001D9F E8E301                   call fcloseR
  4804 00001DA2 83C402                   add  sp, 2
  4805                                  
  4806                                  ;-438   exitR(n);
  4807                                  
  4808 00001DA5 FF7604                   push word [bp+4]
  4809 00001DA8 E8E801                   call exitR
  4810 00001DAB 83C402                   add  sp, 2
  4811                                  
  4812                                  ;-439 }
  4813 00001DAE C9                       LEAVE
  4814 00001DAF C3                       ret
  4815                                  ; ENDP
  4816                                  ;Back to main program: AS.C
  4817                                   
  4818                                  ; missing functions: 
  4819                                  ; digit
  4820                                  ; eqstr
  4821                                  ; eqstr
  4822                                  ; eqstr
  4823                                  ; strcpy
  4824                                  ; eqstr
  4825                                  ; strlen
  4826                                  ; readRL
  4827                                  ; readRL
  4828                                  ; digit
  4829                                  ; digit
  4830                                  ; digit
  4831                                  ; strcpy
  4832                                  ; toupper
  4833                                  ; strlen
  4834                                  ; strlen
  4835                                  ; eqstr
  4836                                  ; eqstr
  4837                                  ; eqstr
  4838                                  ; eqstr
  4839                                  ; eqstr
  4840                                  ; eqstr
  4841                                  ; eqstr
  4842                                  ; eqstr
  4843                                  ; eqstr
  4844                                  ; eqstr
  4845                                  ; eqstr
  4846                                  ; eqstr
  4847                                  ; eqstr
  4848                                  ; eqstr
  4849                                  ; eqstr
  4850                                  ; eqstr
  4851                                  ; eqstr
  4852                                  ; eqstr
  4853                                  ; eqstr
  4854                                  ; eqstr
  4855                                  ; eqstr
  4856                                  ; eqstr
  4857                                  ; eqstr
  4858                                  ; eqstr
  4859                                  ; eqstr
  4860                                  ; eqstr
  4861                                  ; eqstr
  4862                                  ; eqstr
  4863                                  ; eqstr
  4864                                  ; eqstr
  4865                                  ; eqstr
  4866                                  ; writetty
  4867                                  ; writetty
  4868                                  ; fputcR
  4869                                  ; cputs
  4870                                  ; cputs
  4871                                  ; exitR
  4872                                  ; toupper
  4873                                  ; strcpy
  4874                                  ; strcat1
  4875                                  ; strcpy
  4876                                  ; strcat1
  4877                                  ; strcpy
  4878                                  ; strcat1
  4879                                  ; openR
  4880                                  ; cputs
  4881                                  ; cputs
  4882                                  ; exitR
  4883                                  ; creatR
  4884                                  ; cputs
  4885                                  ; cputs
  4886                                  ; exitR
  4887                                  ; creatR
  4888                                  ; cputs
  4889                                  ; cputs
  4890                                  ; exitR
  4891                                  ; strlen
  4892                                  ; fputcR
  4893                                  ; fcloseR
  4894                                  ; fcloseR
  4895                                  ; fcloseR
  4896                                  ; exitR
  4897                                  ; Number of unresolved CALLs :   78
  4898                                  ;use archive file: AR.C
  4899                                  
  4900                                  ;-191 // AR.C Archive
  4901                                  
  4902                                  ;Number of CALLs:    2 : writetty
  4903                                  
  4904                                  writetty:  ; *** PROC ***
  4905 00001DB0 B40E                     mov  ah, 14
  4906 00001DB2 BB0000                   mov  bx, 0
  4907 00001DB5 CD10                     int  16
  4908                                  
  4909                                  ;-192 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  4910                                  
  4911 00001DB7 C3                       ret
  4912                                  ; ENDP
  4913                                  ;Number of CALLs:    8 : cputs
  4914                                  
  4915                                  cputs:  ; *** PROC ***
  4916                                  ;Function : cputs, Number of local variables: 2
  4917                                  ;   # type sign width line used address name   list of local variables
  4918                                  ;  200 ptr sign byte   192 NULL bp+4    s
  4919                                  ;  201 var sign byte   192 NULL bp-2    c;
  4920 00001DB8 C8020000                 ENTER  2,0
  4921                                  @@cputs210:
  4922 00001DBC 8B5E04                   mov bx, [bp+4]
  4923 00001DBF 8A07                     mov al, [bx]
  4924 00001DC1 B400                     mov ah, 0
  4925 00001DC3 08C0                     or  al, al
  4926 00001DC5 0F841B00                 je @@cputs211
  4927 00001DC9 8B5E04                   mov bx, [bp+4]
  4928 00001DCC 8A07                     mov al, [bx]
  4929 00001DCE B400                     mov ah, 0
  4930 00001DD0 8846FE                   mov byte [bp-2], al
  4931 00001DD3 8A46FE                   mov al, byte [bp-2]
  4932 00001DD6 B400                     mov ah, 0
  4933 00001DD8 50                       push ax
  4934 00001DD9 E8C401                   call putch
  4935 00001DDC 83C402                   add  sp, 2
  4936 00001DDF FF4604                   inc  word [bp+4]
  4937 00001DE2 EBD8                     jmp @@cputs210
  4938                                  @@cputs211:
  4939                                  
  4940                                  ;-193 int mkneg(int n) { n; __asm {neg ax} }
  4941 00001DE4 C9                       LEAVE
  4942 00001DE5 C3                       ret
  4943                                  ; ENDP
  4944                                  ;Number of CALLs:    2 : toupper
  4945                                  
  4946                                  toupper:  ; *** PROC ***
  4947                                  ;Function : toupper, Number of local variables: 1
  4948                                  ;   # type sign width line used address name   list of local variables
  4949                                  ;  200 ptr sign byte   193 NULL bp+4    s;
  4950 00001DE6 C8000000                 ENTER  0,0
  4951                                  @@toupper212:
  4952 00001DEA 8B5E04                   mov bx, [bp+4]
  4953 00001DED 8A07                     mov al, [bx]
  4954 00001DEF B400                     mov ah, 0
  4955 00001DF1 08C0                     or  al, al
  4956 00001DF3 0F843000                 je @@toupper213
  4957 00001DF7 8B5E04                   mov bx, [bp+4]
  4958 00001DFA 8A07                     mov al, [bx]
  4959 00001DFC B400                     mov ah, 0
  4960 00001DFE 83F861                   cmp ax, 97 ;unsigned : 1
  4961 00001E01 0F8C1D00                 jl  @@toupper214
  4962 00001E05 8B5E04                   mov bx, [bp+4]
  4963 00001E08 8A07                     mov al, [bx]
  4964 00001E0A B400                     mov ah, 0
  4965 00001E0C 83F87A                   cmp ax, 122
  4966 00001E0F 0F8F0F00                 jg  @@toupper215
  4967 00001E13 8B5E04                   mov bx, [bp+4]
  4968 00001E16 8A07                     mov al, [bx]
  4969 00001E18 B400                     mov ah, 0
  4970 00001E1A 83E820                   sub ax, 32
  4971 00001E1D 8B5E04                   mov  bx, [bp+4]
  4972 00001E20 8807                     mov  [bx], al
  4973                                  @@toupper215:
  4974                                  @@toupper214:
  4975 00001E22 FF4604                   inc  word [bp+4]
  4976 00001E25 EBC3                     jmp @@toupper212
  4977                                  @@toupper213:
  4978                                  
  4979                                  ;-194 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  4980                                  
  4981                                  
  4982                                  ;-195 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  4983 00001E27 C9                       LEAVE
  4984 00001E28 C3                       ret
  4985                                  ; ENDP
  4986                                  ;Number of CALLs:    4 : strlen
  4987                                  
  4988                                  strlen:  ; *** PROC ***
  4989                                  ;Function : strlen, Number of local variables: 2
  4990                                  ;   # type sign width line used address name   list of local variables
  4991                                  ;  200 ptr sign byte   195 NULL bp+4    s
  4992                                  ;  201 var sign word   195 NULL bp-2    c;
  4993 00001E29 C8020000                 ENTER  2,0
  4994 00001E2D 66B800000000             mov eax, 0
  4995 00001E33 8946FE                   mov word [bp-2], ax
  4996                                  @@strlen216:
  4997 00001E36 8B5E04                   mov bx, [bp+4]
  4998 00001E39 8A07                     mov al, [bx]
  4999 00001E3B B400                     mov ah, 0
  5000 00001E3D 83F800                   cmp ax, 0
  5001 00001E40 0F840800                 je  @@strlen217
  5002 00001E44 FF4604                   inc  word [bp+4]
  5003 00001E47 FF46FE                   inc  word [bp-2]
  5004 00001E4A EBEA                     jmp @@strlen216
  5005                                  @@strlen217:
  5006 00001E4C 8B46FE                   mov ax, [bp-2]
  5007 00001E4F E90000                   jmp @@retn
  5008                                  
  5009                                  ;-196 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5010                                  
  5011 00001E52 C9                      @@retn: LEAVE
  5012 00001E53 C3                       ret
  5013                                  ; ENDP
  5014                                  ;Number of CALLs:    5 : strcpy
  5015                                  
  5016                                  strcpy:  ; *** PROC ***
  5017                                  ;Function : strcpy, Number of local variables: 2
  5018                                  ;   # type sign width line used address name   list of local variables
  5019                                  ;  200 ptr sign byte   196 NULL bp+4    s
  5020                                  ;  201 ptr sign byte   196 NULL bp+6    t;
  5021 00001E54 C8000000                 ENTER  0,0
  5022                                  @@strcpy218:
  5023 00001E58 8B5E06                   mov bx, [bp+6]
  5024 00001E5B 8A07                     mov al, [bx]
  5025 00001E5D B400                     mov ah, 0
  5026 00001E5F 8B5E04                   mov  bx, [bp+4]
  5027 00001E62 8807                     mov  [bx], al
  5028 00001E64 FF4604                   inc  word [bp+4]
  5029 00001E67 FF4606                   inc  word [bp+6]
  5030                                  
  5031                                  ;-197   while (*t!=0); *s=0; return s; }
  5032                                  
  5033 00001E6A 8B5E06                   mov bx, [bp+6]
  5034 00001E6D 8A07                     mov al, [bx]
  5035 00001E6F B400                     mov ah, 0
  5036 00001E71 83F800                   cmp ax, 0
  5037 00001E74 0F840200                 je  @@strcpy219
  5038 00001E78 EBDE                     jmp @@strcpy218
  5039                                  @@strcpy219:
  5040 00001E7A 66B800000000             mov eax, 0
  5041 00001E80 8B5E04                   mov  bx, [bp+4]
  5042 00001E83 8807                     mov  [bx], al
  5043 00001E85 8B4604                   mov ax, [bp+4]
  5044 00001E88 E90000                   jmp @@retn
  5045                                  
  5046                                  ;-198 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5047                                  
  5048 00001E8B C9                      @@retn: LEAVE
  5049 00001E8C C3                       ret
  5050                                  ; ENDP
  5051                                  ;Number of CALLs:    4 : digit
  5052                                  
  5053                                  digit:  ; *** PROC ***
  5054                                  ;Function : digit, Number of local variables: 1
  5055                                  ;   # type sign width line used address name   list of local variables
  5056                                  ;  200 var sign byte   198 NULL bp+4    c;
  5057 00001E8D C8000000                 ENTER  0,0
  5058 00001E91 8A4604                   mov al, [bp+4]
  5059 00001E94 3C30                     cmp al, 48
  5060 00001E96 0F8D0900                 jge @@digit220
  5061 00001E9A 66B800000000             mov eax, 0
  5062 00001EA0 E91B00                   jmp @@retn
  5063                                  @@digit220:
  5064 00001EA3 8A4604                   mov al, [bp+4]
  5065 00001EA6 3C39                     cmp al, 57
  5066 00001EA8 0F8E0900                 jle @@digit221
  5067 00001EAC 66B800000000             mov eax, 0
  5068 00001EB2 E90900                   jmp @@retn
  5069                                  @@digit221:
  5070 00001EB5 66B801000000             mov eax, 1
  5071 00001EBB E90000                   jmp @@retn
  5072                                  
  5073                                  ;-199 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5074                                  
  5075 00001EBE C9                      @@retn: LEAVE
  5076 00001EBF C3                       ret
  5077                                  ; ENDP
  5078                                  ;Number of CALLs:   35 : eqstr
  5079                                  
  5080                                  eqstr:  ; *** PROC ***
  5081                                  ;Function : eqstr, Number of local variables: 2
  5082                                  ;   # type sign width line used address name   list of local variables
  5083                                  ;  200 ptr sign byte   199 NULL bp+4    p
  5084                                  ;  201 ptr sign byte   199 NULL bp+6    q;
  5085 00001EC0 C8000000                 ENTER  0,0
  5086                                  @@eqstr222:
  5087 00001EC4 8B5E04                   mov bx, [bp+4]
  5088 00001EC7 8A07                     mov al, [bx]
  5089 00001EC9 B400                     mov ah, 0
  5090 00001ECB 08C0                     or  al, al
  5091 00001ECD 0F842300                 je @@eqstr223
  5092                                  
  5093                                  ;-200     if (*p != *q) return 0; p++; q++; }
  5094                                  
  5095 00001ED1 8B5E04                   mov bx, [bp+4]
  5096 00001ED4 8A07                     mov al, [bx]
  5097 00001ED6 B400                     mov ah, 0
  5098 00001ED8 8B5E06                   mov bx, [bp+6]
  5099 00001EDB 3A07                     cmp al, [bx]
  5100 00001EDD B400                     mov ah, 0
  5101 00001EDF 0F840900                 je  @@eqstr224
  5102 00001EE3 66B800000000             mov eax, 0
  5103 00001EE9 E92700                   jmp @@retn
  5104                                  @@eqstr224:
  5105 00001EEC FF4604                   inc  word [bp+4]
  5106 00001EEF FF4606                   inc  word [bp+6]
  5107                                  
  5108                                  ;-201     if(*q) return 0; return 1; }
  5109                                  
  5110 00001EF2 EBD0                     jmp @@eqstr222
  5111                                  @@eqstr223:
  5112 00001EF4 8B5E06                   mov bx, [bp+6]
  5113 00001EF7 8A07                     mov al, [bx]
  5114 00001EF9 B400                     mov ah, 0
  5115 00001EFB 08C0                     or  al, al
  5116 00001EFD 0F840900                 je @@eqstr225
  5117 00001F01 66B800000000             mov eax, 0
  5118 00001F07 E90900                   jmp @@retn
  5119                                  @@eqstr225:
  5120 00001F0A 66B801000000             mov eax, 1
  5121 00001F10 E90000                   jmp @@retn
  5122                                  
  5123                                  ;-202 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5124                                  
  5125 00001F13 C9                      @@retn: LEAVE
  5126 00001F14 C3                       ret
  5127                                  ; ENDP
  5128                                  ;Number of CALLs:    3 : strcat1
  5129                                  
  5130                                  strcat1:  ; *** PROC ***
  5131                                  ;Function : strcat1, Number of local variables: 2
  5132                                  ;   # type sign width line used address name   list of local variables
  5133                                  ;  200 ptr sign byte   202 NULL bp+4    s
  5134                                  ;  201 ptr sign byte   202 NULL bp+6    t;
  5135 00001F15 C8000000                 ENTER  0,0
  5136                                  @@strcat1226:
  5137 00001F19 8B5E04                   mov bx, [bp+4]
  5138 00001F1C 8A07                     mov al, [bx]
  5139 00001F1E B400                     mov ah, 0
  5140 00001F20 83F800                   cmp ax, 0
  5141 00001F23 0F840500                 je  @@strcat1227
  5142 00001F27 FF4604                   inc  word [bp+4]
  5143 00001F2A EBED                     jmp @@strcat1226
  5144                                  @@strcat1227:
  5145 00001F2C FF7606                   push word [bp+6]
  5146 00001F2F FF7604                   push word [bp+4]
  5147 00001F32 E81FFF                   call strcpy
  5148 00001F35 83C404                   add  sp, 4
  5149                                  
  5150                                  ;-203 int basename(char *s) { char *p; p=0;
  5151 00001F38 C9                       LEAVE
  5152 00001F39 C3                       ret
  5153                                  ; ENDP
  5154                                  ;Number of CALLs:    1 : openR
  5155                                  
  5156                                  openR:  ; *** PROC ***
  5157                                  ;Function : openR, Number of local variables: 1
  5158                                  ;   # type sign width line used address name   list of local variables
  5159                                  ;  200 ptr sign byte   203 NULL bp+4    s;
  5160 00001F3A C8000000                 ENTER  0,0
  5161 00001F3E 8B5604                   mov  dx, [bp+4]
  5162 00001F41 B8023D                   mov  ax, 15618
  5163 00001F44 E87200                   call DosInt
  5164                                  
  5165                                  ;-204 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5166 00001F47 C9                       LEAVE
  5167 00001F48 C3                       ret
  5168                                  ; ENDP
  5169                                  ;Number of CALLs:    2 : creatR
  5170                                  
  5171                                  creatR:  ; *** PROC ***
  5172                                  ;Function : creatR, Number of local variables: 1
  5173                                  ;   # type sign width line used address name   list of local variables
  5174                                  ;  200 ptr sign byte   204 NULL bp+4    s;
  5175 00001F49 C8000000                 ENTER  0,0
  5176 00001F4D 8B5604                   mov  dx, [bp+4]
  5177 00001F50 B90000                   mov  cx, 0
  5178 00001F53 B8003C                   mov  ax, 15360
  5179 00001F56 E86000                   call DosInt
  5180                                  
  5181                                  ;-205 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5182 00001F59 C9                       LEAVE
  5183 00001F5A C3                       ret
  5184                                  ; ENDP
  5185                                  ;Number of CALLs:    2 : readRL
  5186                                  
  5187                                  readRL:  ; *** PROC ***
  5188                                  ;Function : readRL, Number of local variables: 3
  5189                                  ;   # type sign width line used address name   list of local variables
  5190                                  ;  200 ptr sign byte   205 NULL bp+4    s
  5191                                  ;  201 var sign word   205 NULL bp+6    fd
  5192                                  ;  202 var sign word   205 NULL bp+8    len;
  5193 00001F5B C8000000                 ENTER  0,0
  5194 00001F5F 8B5604                   mov  dx, [bp+4]
  5195 00001F62 8B4E08                   mov  cx, [bp+8]
  5196 00001F65 8B5E06                   mov  bx, [bp+6]
  5197 00001F68 B8003F                   mov  ax, 16128
  5198 00001F6B E84B00                   call DosInt
  5199                                  
  5200                                  ;-206 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5201 00001F6E C9                       LEAVE
  5202 00001F6F C3                       ret
  5203                                  ; ENDP
  5204                                  ;Number of CALLs:    2 : fputcR
  5205                                  
  5206                                  fputcR:  ; *** PROC ***
  5207                                  ;Function : fputcR, Number of local variables: 2
  5208                                  ;   # type sign width line used address name   list of local variables
  5209                                  ;  200 ptr sign byte   206 NULL bp+4    n
  5210                                  ;  201 var sign word   206 NULL bp+6    fd;
  5211 00001F70 C8000000                 ENTER  0,0
  5212 00001F74 8D5604                  lea dx, [bp+4]
  5213                                  
  5214                                  ;-207   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5215                                  
  5216 00001F77 B90100                   mov  cx, 1
  5217 00001F7A 8B5E06                   mov  bx, [bp+6]
  5218 00001F7D B80040                   mov  ax, 16384
  5219 00001F80 E83600                   call DosInt
  5220                                  
  5221                                  ;-208 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5222 00001F83 C9                       LEAVE
  5223 00001F84 C3                       ret
  5224                                  ; ENDP
  5225                                  ;Number of CALLs:    3 : fcloseR
  5226                                  
  5227                                  fcloseR:  ; *** PROC ***
  5228                                  ;Function : fcloseR, Number of local variables: 1
  5229                                  ;   # type sign width line used address name   list of local variables
  5230                                  ;  200 var sign word   208 NULL bp+4    fd;
  5231 00001F85 C8000000                 ENTER  0,0
  5232 00001F89 8B5E04                   mov  bx, [bp+4]
  5233 00001F8C B8003E                   mov  ax, 15872
  5234 00001F8F CD21                     int  33
  5235                                  
  5236                                  ;-209 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5237 00001F91 C9                       LEAVE
  5238 00001F92 C3                       ret
  5239                                  ; ENDP
  5240                                  ;Number of CALLs:    5 : exitR
  5241                                  
  5242                                  exitR:  ; *** PROC ***
  5243                                  ;Function : exitR, Number of local variables: 1
  5244                                  ;   # type sign width line used address name   list of local variables
  5245                                  ;  200 var sign byte   209 NULL bp+4    c;
  5246 00001F93 C8000000                 ENTER  0,0
  5247 00001F97 B44C                     mov  ah, 76
  5248 00001F99 8A4604                   mov  al, [bp+4]
  5249 00001F9C CD21                     int  33
  5250                                  
  5251                                  ;-210 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5252 00001F9E C9                       LEAVE
  5253 00001F9F C3                       ret
  5254                                  ; ENDP
  5255                                  ;End of archive file. 
  5256                                   
  5257                                  ; missing functions: 
  5258                                  ; putch
  5259                                  ; DosInt
  5260                                  ; DosInt
  5261                                  ; DosInt
  5262                                  ; DosInt
  5263                                  ; Number of unresolved CALLs :    5
  5264                                  ;use archive file: AR.C
  5265                                  
  5266                                  ;-211 // AR.C Archive
  5267                                  
  5268                                  ;Number of CALLs:    1 : putch
  5269                                  
  5270                                  putch:  ; *** PROC ***
  5271                                  ;Function : putch, Number of local variables: 1
  5272                                  ;   # type sign width line used address name   list of local variables
  5273                                  ;  200 var sign byte   211 NULL bp+4    c;
  5274 00001FA0 C8000000                 ENTER  0,0
  5275 00001FA4 807E040A                cmp byte [bp+4], 10
  5276 00001FA8 0F850500                 jne @@putch228
  5277 00001FAC B00D                     mov  al, 13
  5278 00001FAE E8FFFD                   call writetty
  5279                                  @@putch228:
  5280 00001FB1 8A4604                   mov  al, [bp+4]
  5281 00001FB4 E8F9FD                   call writetty
  5282                                  
  5283                                  ;-212 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5284 00001FB7 C9                       LEAVE
  5285 00001FB8 C3                       ret
  5286                                  ; ENDP
  5287                                  ;Number of CALLs:    4 : DosInt
  5288                                  
  5289                                  DosInt:  ; *** PROC ***
  5290 00001FB9 CD21                     int  33
  5291 00001FBB 7304                     jae short @@DosInt229
  5292 00001FBD FF06[2F00]               inc  word [DOS_ERR]
  5293                                  @@DosInt229:
  5294                                  
  5295                                  ;-213 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5296                                  
  5297 00001FC1 C3                       ret
  5298                                  ; ENDP
  5299                                  ;End of archive file. 
  5300                                   
  5301                                  ; missing functions:  All FUNCTIONs in place
  5302 00001FC2 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5303 00001FC5 58                      pop ax
  5304 00001FC6 C3                      ret
  5305                                   
  5306                                  ;   # type sign width line used  address name   list of global variables
  5307                                  
  5308                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5309                                  ;    2 var sign byte     1    3        0 LIST
  5310                                  ;    3 arr sign byte     2    7    30000 Symbol[80]
  5311                                  ;    4 arr sign byte     3   36    30080 SymbolUpper[80]
  5312                                  ;    5 var unsg word     4   12        0 SymbolInt
  5313                                  ;    6 arr sign byte     5    3    30160 InputBuf[128]
  5314                                  ;    7 ptr unsg byte     6   23        0 InputPtr
  5315                                  ;    8 arr sign byte     7    5    30288 namein[67]
  5316                                  ;    9 arr sign byte     8    5    30355 namelst[67]
  5317                                  ;   10 arr sign byte     9    5    30422 namebin[67]
  5318                                  ;   11 var sign word    10    4        0 asm_fd
  5319                                  ;   12 var sign word    11    3        0 lst_fd
  5320                                  ;   13 var sign word    12    3        0 bin_fd
  5321                                  ;   14 var sign word    13    6        0 DOS_ERR
  5322                                  ;   15 var sign word    14    4        0 ErrorCount
  5323                                  ;   16 var sign word    15    4        0 DOS_NoBytes
  5324                                  ;   17 var sign byte    16    4        0 DOS_ByteRead
  5325                                  ;   18 var unsg word    18    5        0 PC
  5326                                  ;   19 var unsg word    19    2        0 PCStart
  5327                                  ;   20 var sign byte    20    3        0 isLabel
  5328                                  ;   21 def unsg byte    21    -        0 DIGIT=1
  5329                                  ;   22 def unsg byte    22    -        0 LETTERE=2
  5330                                  ;   23 def unsg byte    23    -        0 ALNUME=3
  5331                                  ;   24 def unsg byte    24    -        0 NOALNUME=4
  5332                                  ;   25 var sign byte    25   20        0 TokeType
  5333                                  ;   26 def unsg byte    26    -        0 BYTE=1
  5334                                  ;   27 def unsg byte    27    -        0 WORD=2
  5335                                  ;   28 def unsg byte    28    -        0 DWORD=3
  5336                                  ;   29 def unsg byte    29    -        0 SEGREG=4
  5337                                  ;   30 def unsg byte    31    -        0 IMM=1
  5338                                  ;   31 def unsg byte    32    -        0 REG=2
  5339                                  ;   32 def unsg byte    33    -        0 DIR=3
  5340                                  ;   33 def unsg byte    34    -        0 IND=4
  5341                                  ;   34 var sign byte    35   13        0 Op1
  5342                                  ;   35 var sign byte    36   12        0 CodeType
  5343                                  ;   36 var sign byte    38   17        0 RegType
  5344                                  ;   37 var sign byte    39   10        0 RegNo
  5345                                  ;   38 var sign byte    40   10        0 OpSize
  5346                                  ;   39 var sign byte    42 NULL        0 NumOprns
  5347                                  ;   40 var sign byte    43    5        0 wflag
  5348                                  ;   41 var sign byte    44 NULL        0 dflag
  5349                                  ;   42 var sign byte    46    4        0 reg
  5350                                  ;   43 var sign word    47   13        0 disp
  5351                                  ;   44 var sign word    48    2        0 imme
  5352                                  ;   45 def unsg byte    50    -        0 OPMAXLEN=5
  5353                                  ;   46 arr sign byte    51    2    30489 OpPos[5]
  5354                                  ;   47 var sign word    52    6        0 OpPrintIndex
  5355                                  ;   48 ptr sign byte    53   16        0 OpCodePtr
  5356                                  ;   49 var sign byte    54    2        0 PrReloc
  5357                                  ;   50 arr sign byte    56    3    30494 LabelNames[1000]
  5358                                  ;   51 ptr sign byte    57   10        0 LabelNamePtr
  5359                                  ;   52 arr unsg word    58    4    31494 LabelAddr[100]
  5360                                  ;   53 var sign word    59    5        0 LabelMaxIx
  5361                                  ;   54 var sign word    60    4        0 LabelIx
  5362                                  ;   55 arr sign byte    62    3    31694 FileBin[2000]
  5363                                  ;   56 var unsg word    63    5        0 BinLen
  5364                                  ;   57 ptr sign byte    65    1        0 arglen
  5365                                  ;   58 ptr sign byte    66    4        0 argv
  5366                                  ;   59 var sign byte   186    1        0 I_START
  5367                                  ;   60 arr sign byte   188 NULL        0 I_PUSHA[9]
  5368                                  ;   61 arr sign byte   189 NULL        0 I_POPA[8]
  5369                                  ;   62 arr sign byte   190 NULL        0 I_NOP[7]
  5370                                  ;   63 arr sign byte   191 NULL        0 I_CBW[7]
  5371                                  ;   64 arr sign byte   192 NULL        0 I_CWDE[8]
  5372                                  ;   65 arr sign byte   193 NULL        0 I_CWD[7]
  5373                                  ;   66 arr sign byte   194 NULL        0 I_CDQ[7]
  5374                                  ;   67 arr sign byte   195 NULL        0 I_WAIT[8]
  5375                                  ;   68 arr sign byte   196 NULL        0 I_PUSHF[9]
  5376                                  ;   69 arr sign byte   197 NULL        0 I_POPF[8]
  5377                                  ;   70 arr sign byte   198 NULL        0 I_SAHF[8]
  5378                                  ;   71 arr sign byte   199 NULL        0 I_LAHF[8]
  5379                                  ;   72 arr sign byte   200 NULL        0 I_MOVSB[9]
  5380                                  ;   73 arr sign byte   201 NULL        0 I_MOVSW[9]
  5381                                  ;   74 arr sign byte   202 NULL        0 I_CMPSB[9]
  5382                                  ;   75 arr sign byte   203 NULL        0 I_CMPSW[9]
  5383                                  ;   76 arr sign byte   204 NULL        0 I_STOSB[9]
  5384                                  ;   77 arr sign byte   205 NULL        0 I_STOSW[9]
  5385                                  ;   78 arr sign byte   206 NULL        0 I_LODSB[9]
  5386                                  ;   79 arr sign byte   207 NULL        0 I_LODSW[9]
  5387                                  ;   80 arr sign byte   208 NULL        0 I_SCASB[9]
  5388                                  ;   81 arr sign byte   209 NULL        0 I_SCASW[9]
  5389                                  ;   82 arr sign byte   210 NULL        0 I_LEAVE[9]
  5390                                  ;   83 arr sign byte   211 NULL        0 I_IRET[8]
  5391                                  ;   84 arr sign byte   212 NULL        0 I_XLAT[8]
  5392                                  ;   85 arr sign byte   213 NULL        0 I_LOCK[8]
  5393                                  ;   86 arr sign byte   214 NULL        0 I_REPNE[9]
  5394                                  ;   87 arr sign byte   215 NULL        0 I_REPNZ[9]
  5395                                  ;   88 arr sign byte   216 NULL        0 I_REPE[8]
  5396                                  ;   89 arr sign byte   217 NULL        0 I_REPZ[8]
  5397                                  ;   90 arr sign byte   218 NULL        0 I_HLT[7]
  5398                                  ;   91 arr sign byte   219 NULL        0 I_CLC[7]
  5399                                  ;   92 arr sign byte   220 NULL        0 I_STC[7]
  5400                                  ;   93 arr sign byte   221 NULL        0 I_CLI[7]
  5401                                  ;   94 arr sign byte   222 NULL        0 I_STI[7]
  5402                                  ;   95 arr sign byte   223 NULL        0 I_CLD[7]
  5403                                  ;   96 arr sign byte   224 NULL        0 I_STD[7]
  5404                                  ;   97 arr sign byte   226 NULL        0 I_INC[9]
  5405                                  ;   98 arr sign byte   227 NULL        0 I_DEC[9]
  5406                                  ;   99 arr sign byte   229 NULL        0 I_NOT[8]
  5407                                  ;  100 arr sign byte   230 NULL        0 I_NEG[8]
  5408                                  ;  101 arr sign byte   231 NULL        0 I_MUL[8]
  5409                                  ;  102 arr sign byte   232 NULL        0 I_IMUL[9]
  5410                                  ;  103 arr sign byte   233 NULL        0 I_DIV[8]
  5411                                  ;  104 arr sign byte   234 NULL        0 I_IDIV[9]
  5412                                  ;  105 arr sign byte   236 NULL        0 I_LES[7]
  5413                                  ;  106 arr sign byte   237 NULL        0 I_LDS[7]
  5414                                  ;  107 arr sign byte   238 NULL        0 I_LEA[7]
  5415                                  ;  108 arr sign byte   240 NULL        0 I_ADD[7]
  5416                                  ;  109 arr sign byte   241 NULL        0 I_OR[6]
  5417                                  ;  110 arr sign byte   242 NULL        0 I_ADC[7]
  5418                                  ;  111 arr sign byte   243 NULL        0 I_SBB[7]
  5419                                  ;  112 arr sign byte   244 NULL        0 I_AND[7]
  5420                                  ;  113 arr sign byte   245 NULL        0 I_SUB[7]
  5421                                  ;  114 arr sign byte   246 NULL        0 I_XOR[7]
  5422                                  ;  115 arr sign byte   247 NULL        0 I_CMP[7]
  5423                                  ;  116 arr sign byte   249 NULL        0 I_MOV[6]
  5424                                  ;  117 arr sign byte   251 NULL        0 I_JO[6]
  5425                                  ;  118 arr sign byte   252 NULL        0 I_JNO[7]
  5426                                  ;  119 arr sign byte   253 NULL        0 I_JB[6]
  5427                                  ;  120 arr sign byte   254 NULL        0 I_JC[6]
  5428                                  ;  121 arr sign byte   255 NULL        0 I_JNB[7]
  5429                                  ;  122 arr sign byte   256 NULL        0 I_JAE[7]
  5430                                  ;  123 arr sign byte   257 NULL        0 I_JNC[7]
  5431                                  ;  124 arr sign byte   258 NULL        0 I_JE[6]
  5432                                  ;  125 arr sign byte   259 NULL        0 I_JZ[6]
  5433                                  ;  126 arr sign byte   260 NULL        0 I_JNE[7]
  5434                                  ;  127 arr sign byte   261 NULL        0 I_JNZ[7]
  5435                                  ;  128 arr sign byte   262 NULL        0 I_JBE[7]
  5436                                  ;  129 arr sign byte   263 NULL        0 I_JNA[7]
  5437                                  ;  130 arr sign byte   264 NULL        0 I_JA[6]
  5438                                  ;  131 arr sign byte   265 NULL        0 I_JS[6]
  5439                                  ;  132 arr sign byte   266 NULL        0 I_JNS[7]
  5440                                  ;  133 arr sign byte   267 NULL        0 I_JP[6]
  5441                                  ;  134 arr sign byte   268 NULL        0 I_JPE[7]
  5442                                  ;  135 arr sign byte   269 NULL        0 I_JNP[7]
  5443                                  ;  136 arr sign byte   270 NULL        0 I_JPO[7]
  5444                                  ;  137 arr sign byte   271 NULL        0 I_JL[6]
  5445                                  ;  138 arr sign byte   272 NULL        0 I_JNL[7]
  5446                                  ;  139 arr sign byte   273 NULL        0 I_JGE[7]
  5447                                  ;  140 arr sign byte   274 NULL        0 I_JLE[7]
  5448                                  ;  141 arr sign byte   275 NULL        0 I_JNG[7]
  5449                                  ;  142 arr sign byte   276 NULL        0 I_JG[6]
  5450                                  ;  143 arr sign byte   278 NULL        0 I_RET[8]
  5451                                  ;  144 arr sign byte   280 NULL        0 I_PUSH[8]
  5452                                  ;  145 arr sign byte   281 NULL        0 I_POP[7]
  5453                                  ;  146 arr sign byte   283 NULL        0 I_ORG[6]
  5454                                  ;  147 arr sign byte   284 NULL        0 I_DB[5]
  5455                                  ;  148 arr sign byte   285 NULL        0 I_DW[5]
  5456                                  ;  149 arr sign byte   286 NULL        0 I_DD[5]
  5457                                  ;  150 arr sign byte   287 NULL        0 I_RESB[7]
  5458                                  ;  151 arr sign byte   288 NULL        0 I_RESW[7]
  5459                                  ;  152 arr sign byte   289 NULL        0 I_RESD[7]
  5460                                  ;  153 var sign byte   290 NULL        0 I_END
  5461                                  
  5462                                  
  5463                                  ;   # Calls Line Width  Name   list of functions
  5464                                  
  5465                                  ;    0 NULL    1 word   main
  5466                                  ;    1    1    5 word   process
  5467                                  ;    2   12   38 word   getTokeType
  5468                                  ;    3 NULL   47 word   Ops
  5469                                  ;    4    2   58 word   LeftOpwCheck
  5470                                  ;    5    1   68 word   getLeftOp
  5471                                  ;    6    1   80 word   setwflag
  5472                                  ;    7    2   88 word   getOp1
  5473                                  ;    8    1  100 word   getIND
  5474                                  ;    9    1  115 word   getIndReg1
  5475                                  ;   10    1  124 word   getIndReg2
  5476                                  ;   11    1  134 word   getCodeSize
  5477                                  ;   12    7  141 word   isToken
  5478                                  ;   13    1  146 word   skipRest
  5479                                  ;   14    1  150 word   gen66h
  5480                                  ;   15    8  151 word   genCode8
  5481                                  ;   16    3  155 word   genCode16
  5482                                  ;   17    7  158 word   genInstruction
  5483                                  ;   18    2  162 word   genCodeInREG
  5484                                  ;   19 NULL  165 word   genModRegRM
  5485                                  ;   20    2  167 word   writeEA
  5486                                  ;   21 NULL  181 word   test1
  5487                                  ;   22    1    2 word   parse
  5488                                  ;   23    2   27 word   storeLabel
  5489                                  ;   24    2   34 word   searchLabel
  5490                                  ;   25    1   45 word   getVariable
  5491                                  ;   26    1   76 word   getLine
  5492                                  ;   27    1   89 word   ifEOL
  5493                                  ;   28    3   96 word   skipBlank
  5494                                  ;   29    2  101 word   letterE
  5495                                  ;   30    1  110 word   alnumE
  5496                                  ;   31    1  115 word   getDigit
  5497                                  ;   32    1  127 word   getName
  5498                                  ;   33    1  144 word   testReg
  5499                                  ;   34    2  292 word   lookCode
  5500                                  ;   35    1  307 word   printLine
  5501                                  ;   36    9  325 word   prc
  5502                                  ;   37    1  329 word   prscomment
  5503                                  ;   38   24  332 word   prs
  5504                                  ;   39    4  337 word   printhex8a
  5505                                  ;   40    2  341 word   printhex16
  5506                                  ;   41    3  344 word   printIntU
  5507                                  ;   42   19  363 word   error1
  5508                                  ;   43 NULL  366 word   allowederror
  5509                                  ;   44 NULL  367 word   implmerror
  5510                                  ;   45    4  368 word   indexerror
  5511                                  ;   46    1  369 word   numbererror
  5512                                  ;   47 NULL  370 word   regmemerror
  5513                                  ;   48    1  371 word   segregerror
  5514                                  ;   49    1  372 word   syntaxerror
  5515                                  ;   50    7  374 word   errorexit
  5516                                  ;   51    1  375 word   addrexit
  5517                                  ;   52 NULL  376 word   internexit
  5518                                  ;   53    1  378 word   getarg
  5519                                  ;   54    1  403 word   epilog
  5520                                  ;   55    2  434 word   end1
  5521                                  ;   56    4  191 word   writetty
  5522                                  ;   57    8  192 word   cputs
  5523                                  ;   58    2  193 word   toupper
  5524                                  ;   59    4  195 word   strlen
  5525                                  ;   60    6  196 word   strcpy
  5526                                  ;   61    4  198 word   digit
  5527                                  ;   62   35  199 word   eqstr
  5528                                  ;   63    3  202 word   strcat1
  5529                                  ;   64    1  203 word   openR
  5530                                  ;   65    2  204 word   creatR
  5531                                  ;   66    2  205 word   readRL
  5532                                  ;   67    2  206 word   fputcR
  5533                                  ;   68    3  208 word   fcloseR
  5534                                  ;   69    5  209 word   exitR
  5535                                  ;   70    1  211 word   putch
  5536                                  ;   71    4  212 word   DosInt
  5537                                  ;   72 NULL  213 word   LastFunctionByt
  5538                                  
  5539                                  ;    #  addr name   list of CALLs
  5540                                  
  5541                                  ;    0     5 getarg
  5542                                  ;    1    12 parse
  5543                                  ;    2    18 epilog
  5544                                  ;    3    25 end1
  5545                                  ;    4   483 getTokeType
  5546                                  ;    5   495 getCodeSize
  5547                                  ;    6   507 genInstruction
  5548                                  ;    7   522 LeftOpwCheck
  5549                                  ;    8   535 genInstruction
  5550                                  ;    9   550 genInstruction
  5551                                  ;   10   565 genInstruction
  5552                                  ;   11   580 genCodeInREG
  5553                                  ;   12   593 LeftOpwCheck
  5554                                  ;   13   606 genInstruction
  5555                                  ;   14   621 genCodeInREG
  5556                                  ;   15   634 genInstruction
  5557                                  ;   16   649 genCode16
  5558                                  ;   17   659 genInstruction
  5559                                  ;   18   674 error1
  5560                                  ;   19   681 error1
  5561                                  ;   20   702 skipBlank
  5562                                  ;   21   712 digit
  5563                                  ;   22   718 getDigit
  5564                                  ;   23   727 letterE
  5565                                  ;   24   735 getName
  5566                                  ;   25   760 getLeftOp
  5567                                  ;   26   770 segregerror
  5568                                  ;   27   782 setwflag
  5569                                  ;   28   791 error1
  5570                                  ;   29   798 error1
  5571                                  ;   30   805 error1
  5572                                  ;   31   822 getOp1
  5573                                  ;   32   829 isToken
  5574                                  ;   33   837 getIND
  5575                                  ;   34   844 error1
  5576                                  ;   35   851 error1
  5577                                  ;   36   867 gen66h
  5578                                  ;   37   881 testReg
  5579                                  ;   38   889 searchLabel
  5580                                  ;   39   901 error1
  5581                                  ;   40   922 getTokeType
  5582                                  ;   41   934 getOp1
  5583                                  ;   42   941 syntaxerror
  5584                                  ;   43   953 getIndReg2
  5585                                  ;   44   964 getIndReg1
  5586                                  ;   45   975 isToken
  5587                                  ;   46   983 getTokeType
  5588                                  ;   47   995 numbererror
  5589                                  ;   48  1007 isToken
  5590                                  ;   49  1015 isToken
  5591                                  ;   50  1023 errorexit
  5592                                  ;   51  1046 indexerror
  5593                                  ;   52  1057 indexerror
  5594                                  ;   53  1084 indexerror
  5595                                  ;   54  1095 indexerror
  5596                                  ;   55  1118 eqstr
  5597                                  ;   56  1124 getTokeType
  5598                                  ;   57  1136 eqstr
  5599                                  ;   58  1142 getTokeType
  5600                                  ;   59  1154 eqstr
  5601                                  ;   60  1160 getTokeType
  5602                                  ;   61  1182 skipBlank
  5603                                  ;   62  1201 getTokeType
  5604                                  ;   63  1213 prs
  5605                                  ;   64  1224 genCode8
  5606                                  ;   65  1256 genCode8
  5607                                  ;   66  1265 genCode8
  5608                                  ;   67  1298 genCode8
  5609                                  ;   68  1322 writeEA
  5610                                  ;   69  1342 writeEA
  5611                                  ;   70  1366 addrexit
  5612                                  ;   71  1375 genCode8
  5613                                  ;   72  1384 genCode8
  5614                                  ;   73  1393 genCode16
  5615                                  ;   74  1415 getLine
  5616                                  ;   75  1423 getTokeType
  5617                                  ;   76  1435 storeLabel
  5618                                  ;   77  1446 getTokeType
  5619                                  ;   78  1458 lookCode
  5620                                  ;   79  1467 process
  5621                                  ;   80  1475 getVariable
  5622                                  ;   81  1487 skipRest
  5623                                  ;   82  1496 error1
  5624                                  ;   83  1503 error1
  5625                                  ;   84  1510 printLine
  5626                                  ;   85  1531 searchLabel
  5627                                  ;   86  1543 error1
  5628                                  ;   87  1550 strcpy
  5629                                  ;   88  1577 eqstr
  5630                                  ;   89  1583 strlen
  5631                                  ;   90  1604 storeLabel
  5632                                  ;   91  1615 getTokeType
  5633                                  ;   92  1627 lookCode
  5634                                  ;   93  1636 errorexit
  5635                                  ;   94  1646 errorexit
  5636                                  ;   95  1656 getTokeType
  5637                                  ;   96  1668 genCode8
  5638                                  ;   97  1677 skipBlank
  5639                                  ;   98  1687 isToken
  5640                                  ;   99  1695 genCode8
  5641                                  ;  100  1704 isToken
  5642                                  ;  101  1712 getTokeType
  5643                                  ;  102  1724 genCode16
  5644                                  ;  103  1734 isToken
  5645                                  ;  104  1742 errorexit
  5646                                  ;  105  1760 readRL
  5647                                  ;  106  1767 errorexit
  5648                                  ;  107  1777 ifEOL
  5649                                  ;  108  1791 readRL
  5650                                  ;  109  1818 digit
  5651                                  ;  110  1833 digit
  5652                                  ;  111  1839 letterE
  5653                                  ;  112  1866 digit
  5654                                  ;  113  1884 alnumE
  5655                                  ;  114  1891 strcpy
  5656                                  ;  115  1898 toupper
  5657                                  ;  116  1914 strlen
  5658                                  ;  117  1921 strlen
  5659                                  ;  118  1928 eqstr
  5660                                  ;  119  1934 eqstr
  5661                                  ;  120  1940 eqstr
  5662                                  ;  121  1946 eqstr
  5663                                  ;  122  1952 eqstr
  5664                                  ;  123  1958 eqstr
  5665                                  ;  124  1964 eqstr
  5666                                  ;  125  1970 eqstr
  5667                                  ;  126  1976 eqstr
  5668                                  ;  127  1982 eqstr
  5669                                  ;  128  1988 eqstr
  5670                                  ;  129  1994 eqstr
  5671                                  ;  130  2000 eqstr
  5672                                  ;  131  2006 eqstr
  5673                                  ;  132  2012 eqstr
  5674                                  ;  133  2018 eqstr
  5675                                  ;  134  2024 eqstr
  5676                                  ;  135  2030 eqstr
  5677                                  ;  136  2036 eqstr
  5678                                  ;  137  2042 eqstr
  5679                                  ;  138  2048 eqstr
  5680                                  ;  139  2054 eqstr
  5681                                  ;  140  2060 eqstr
  5682                                  ;  141  2066 eqstr
  5683                                  ;  142  2072 eqstr
  5684                                  ;  143  2078 eqstr
  5685                                  ;  144  2084 eqstr
  5686                                  ;  145  2090 eqstr
  5687                                  ;  146  2096 eqstr
  5688                                  ;  147  2102 eqstr
  5689                                  ;  148  2722 eqstr
  5690                                  ;  149  2742 prs
  5691                                  ;  150  2746 printhex16
  5692                                  ;  151  2757 prs
  5693                                  ;  152  2761 prc
  5694                                  ;  153  2765 printhex8a
  5695                                  ;  154  2776 prc
  5696                                  ;  155  2780 prs
  5697                                  ;  156  2784 prscomment
  5698                                  ;  157  2801 writetty
  5699                                  ;  158  2810 writetty
  5700                                  ;  159  2819 fputcR
  5701                                  ;  160  2841 prc
  5702                                  ;  161  2857 prc
  5703                                  ;  162  2878 prc
  5704                                  ;  163  2882 prc
  5705                                  ;  164  2904 printhex8a
  5706                                  ;  165  2915 printhex8a
  5707                                  ;  166  2940 printIntU
  5708                                  ;  167  2950 prc
  5709                                  ;  168  2963 prs
  5710                                  ;  169  2967 prs
  5711                                  ;  170  2971 prs
  5712                                  ;  171  2975 prs
  5713                                  ;  172  2992 error1
  5714                                  ;  173  3010 error1
  5715                                  ;  174  3028 error1
  5716                                  ;  175  3047 error1
  5717                                  ;  176  3066 error1
  5718                                  ;  177  3085 error1
  5719                                  ;  178  3104 error1
  5720                                  ;  179  3123 error1
  5721                                  ;  180  3130 end1
  5722                                  ;  181  3144 errorexit
  5723                                  ;  182  3165 errorexit
  5724                                  ;  183  3194 cputs
  5725                                  ;  184  3200 cputs
  5726                                  ;  185  3206 exitR
  5727                                  ;  186  3212 toupper
  5728                                  ;  187  3220 strcpy
  5729                                  ;  188  3227 strcat1
  5730                                  ;  189  3235 strcpy
  5731                                  ;  190  3242 strcat1
  5732                                  ;  191  3250 strcpy
  5733                                  ;  192  3257 strcat1
  5734                                  ;  193  3265 openR
  5735                                  ;  194  3271 cputs
  5736                                  ;  195  3277 cputs
  5737                                  ;  196  3283 exitR
  5738                                  ;  197  3289 creatR
  5739                                  ;  198  3296 cputs
  5740                                  ;  199  3302 cputs
  5741                                  ;  200  3308 exitR
  5742                                  ;  201  3314 creatR
  5743                                  ;  202  3321 cputs
  5744                                  ;  203  3327 cputs
  5745                                  ;  204  3333 exitR
  5746                                  ;  205  3339 prs
  5747                                  ;  206  3343 prs
  5748                                  ;  207  3347 prs
  5749                                  ;  208  3351 prs
  5750                                  ;  209  3355 prs
  5751                                  ;  210  3359 prs
  5752                                  ;  211  3363 prs
  5753                                  ;  212  3367 prs
  5754                                  ;  213  3371 prs
  5755                                  ;  214  3388 prs
  5756                                  ;  215  3392 printIntU
  5757                                  ;  216  3402 prs
  5758                                  ;  217  3406 prs
  5759                                  ;  218  3410 prs
  5760                                  ;  219  3414 prc
  5761                                  ;  220  3418 printhex16
  5762                                  ;  221  3429 prs
  5763                                  ;  222  3433 strlen
  5764                                  ;  223  3440 prs
  5765                                  ;  224  3444 printIntU
  5766                                  ;  225  3454 prs
  5767                                  ;  226  3458 prc
  5768                                  ;  227  3462 printhex8a
  5769                                  ;  228  3473 fputcR
  5770                                  ;  229  3487 fcloseR
  5771                                  ;  230  3495 fcloseR
  5772                                  ;  231  3503 fcloseR
  5773                                  ;  232  3511 exitR
  5774                                  ;  233  3536 putch
  5775                                  ;  234  3604 strcpy
  5776                                  ;  235  3619 DosInt
  5777                                  ;  236  3635 DosInt
  5778                                  ;  237  3658 DosInt
  5779                                  ;  238  3677 DosInt
  5780                                  ;  239  3711 writetty
  5781                                  ;  240  3720 writetty
  5782                                  ;Input: AS.C, List: AS.S,  Lines:  214
  5783                                  ;Glob. variables:  153 max.:  200
  5784                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  5785                                  ;Functions      :   73 max.:  300
  5786                                  ;Calls          :  241 max.: 2000, NameField: 3752 max.:    65535
  5787                                  ;Code until     :26009 max.: 30000, free: 3991
  5788                                  ;Data (HeapEnd) :33694, resting stacksize: 31841
  5789                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
