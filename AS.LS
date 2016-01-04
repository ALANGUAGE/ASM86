     1                                  
     2                                  ; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E90000                  jmp main
     6                                  
     7                                  ;-1 int main() {getarg(); parse(); epilog(); end1();}//BAS   AS TE
     8                                  
     9                                  
    10                                  main:  ; *** PROC ***
    11 00000003 E8E719                   call getarg
    12 00000006 E8EB08                   call parse
    13 00000009 E83F1C                   call epilog
    14 0000000C E8AC1D                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.06 4.1.2015";//alt-re 5[  7|  8{  N~  7Caps 
    17 0000000F C3                       ret
    18                                  ; ENDP
    19 00000010 41532E432056302E30-     Version1 db "AS.C V0.06 4.1.2015",0
    20 00000019 3620342E312E323031-
    21 00000022 3500               
    22                                  
    23                                  ;-3 char LIST;
    24                                  
    25 00000024 00                      LIST db 0
    26                                  
    27                                  ;-4 char Symbol[80]; char SymbolUpper[80]; unsigned int SymbolInt;
    28                                  
    29                                  section .bss
    30                                  absolute 30000
    31 00007530 <res 00000050>          Symbol resb 80
    32                                  section .text
    33                                  section .bss
    34                                  absolute 30080
    35 00007580 <res 00000050>          SymbolUpper resb 80
    36                                  section .text
    37 00000025 0000                    SymbolInt dw 0
    38                                  
    39                                  ;-5 char InputBuf[128];  unsigned char *InputPtr;
    40                                  
    41                                  section .bss
    42                                  absolute 30160
    43 000075D0 <res 00000080>          InputBuf resb 128
    44                                  section .text
    45 00000027 0000                    InputPtr dw 0
    46                                  
    47                                  ;-6 char namein [67]; char namelst[67]; char namebin[67];
    48                                  
    49                                  section .bss
    50                                  absolute 30288
    51 00007650 <res 00000043>          namein resb 67
    52                                  section .text
    53                                  section .bss
    54                                  absolute 30355
    55 00007693 <res 00000043>          namelst resb 67
    56                                  section .text
    57                                  section .bss
    58                                  absolute 30422
    59 000076D6 <res 00000043>          namebin resb 67
    60                                  section .text
    61                                  
    62                                  ;-7 int  asm_fd;       int lst_fd;       int bin_fd;
    63                                  
    64 00000029 0000                    asm_fd dw 0
    65 0000002B 0000                    lst_fd dw 0
    66 0000002D 0000                    bin_fd dw 0
    67                                  
    68                                  ;-8 int DOS_ERR;     int ErrorCount;
    69                                  
    70 0000002F 0000                    DOS_ERR dw 0
    71 00000031 0000                    ErrorCount dw 0
    72                                  
    73                                  ;-9 int DOS_NoBytes; char DOS_ByteRead;
    74                                  
    75 00000033 0000                    DOS_NoBytes dw 0
    76 00000035 00                      DOS_ByteRead db 0
    77                                  
    78                                  ;-10 
    79                                  
    80                                  
    81                                  ;-11 unsigned int PC;   //program counter, ORG nn
    82                                  
    83 00000036 0000                    PC dw 0
    84                                  
    85                                  ;-12 unsigned int PCStart;//PC at start of line by PrintLine()
    86                                  
    87 00000038 0000                    PCStart dw 0
    88                                  
    89                                  ;-13 char isLabel;      //by getName()
    90                                  
    91 0000003A 00                      isLabel db 0
    92                                  
    93                                  ;-14 #define LABEL    1
    94                                  
    95                                  
    96                                  ;-15 #define VARIABLE 2
    97                                  
    98                                  
    99                                  ;-16 #define DIGIT    1 //0-9
   100                                  
   101                                  
   102                                  ;-17 #define ALNUM    2 //0-9 _ a-z A-Z
   103                                  
   104                                  
   105                                  ;-18 char TokeType;     //0, DIGIT, ALNUM, noalnum
   106                                  
   107 0000003B 00                      TokeType db 0
   108                                  
   109                                  ;-19 #define BYTE     1
   110                                  
   111                                  
   112                                  ;-20 #define WORD     2
   113                                  
   114                                  
   115                                  ;-21 #define DWORD    3
   116                                  
   117                                  
   118                                  ;-22 #define SEGREG   4
   119                                  
   120                                  
   121                                  ;-23 //char CodeSize;     //0, BYTE, WORD, DWORD
   122                                  
   123                                  
   124                                  ;-24 #define IMM      1 //const  ,123
   125                                  
   126                                  
   127                                  ;-25 #define REG      2 //       ,BX    mode=11
   128                                  
   129                                  
   130                                  ;-26 #define DIR      3 //VALUE  ,var1  mod=00, r/m=110
   131                                  
   132                                  
   133                                  ;-27 #define IND      4 //indirec,[var1], [BX+SI], [table+BX], [bp-4]  disp 0,8,16
   134                                  
   135                                  
   136                                  ;-28 char Op1;          //0, IMM, REG, DIR, IND
   137                                  
   138 0000003C 00                      Op1 db 0
   139                                  
   140                                  ;-29 int  CodeType;     //1-207 by searchSymbol()
   141                                  
   142 0000003D 0000                    CodeType dw 0
   143                                  
   144                                  ;-30 
   145                                  
   146                                  
   147                                  ;-31 char RegType;      //0=no reg, BYTE, WORD, DWORD, SEGREG
   148                                  
   149 0000003F 00                      RegType db 0
   150                                  
   151                                  ;-32 char RegNo;        //0 - 7 AL, CL, ...  by testReg()
   152                                  
   153 00000040 00                      RegNo db 0
   154                                  
   155                                  ;-33 char OpSize;       //0, BYTE, WORD, DWORD
   156                                  
   157 00000041 00                      OpSize db 0
   158                                  
   159                                  ;-34 //char AddrSize;   //67h:
   160                                  
   161                                  
   162                                  ;-35 char NumOprns;     //0-2
   163                                  
   164 00000042 00                      NumOprns db 0
   165                                  
   166                                  ;-36 char wflag;        //0=byte, 1=word/dword
   167                                  
   168 00000043 00                      wflag db 0
   169                                  
   170                                  ;-37 char dflag;        //0=source is reg,  1=dest is reg
   171                                  
   172 00000044 00                      dflag db 0
   173                                  
   174                                  ;-38 //char modrm;        //mod, r/m
   175                                  
   176                                  
   177                                  ;-39 char reg;          //combination of index and base reg
   178                                  
   179 00000045 00                      reg db 0
   180                                  
   181                                  ;-40 int disp;          //displacement      0-8 bytes
   182                                  
   183 00000046 0000                    disp dw 0
   184                                  
   185                                  ;-41 int imme;          //immediate         0-8 bytes
   186                                  
   187 00000048 0000                    imme dw 0
   188                                  
   189                                  ;-42 
   190                                  
   191                                  
   192                                  ;-43 #define OPMAXLEN  5
   193                                  
   194                                  
   195                                  ;-44 char OpPos[OPMAXLEN];
   196                                  
   197                                  section .bss
   198                                  absolute 30489
   199 00007719 <res 00000005>          OpPos resb 5
   200                                  section .text
   201                                  
   202                                  ;-45 int OpPrintIndex;  //0-OPMAXLEN, Position to print opcode, by genCode8()
   203                                  
   204 0000004A 0000                    OpPrintIndex dw 0
   205                                  
   206                                  ;-46 char *OpCodePtr;   //position in OpCodeTable by searchSymbol(), div.
   207                                  
   208 0000004C 0000                    OpCodePtr dw 0
   209                                  
   210                                  ;-47 char PrReloc;      //print 'R' if relocative
   211                                  
   212 0000004E 00                      PrReloc db 0
   213                                  
   214                                  ;-48 char LabelNames[1000]; char *LabelNamePtr;
   215                                  
   216                                  section .bss
   217                                  absolute 30494
   218 0000771E <res 000003E8>          LabelNames resb 1000
   219                                  section .text
   220 0000004F 0000                    LabelNamePtr dw 0
   221                                  
   222                                  ;-49 char LabelType  [100]; unsigned int LabelAddr[100];
   223                                  
   224                                  section .bss
   225                                  absolute 31494
   226 00007B06 <res 00000064>          LabelType resb 100
   227                                  section .text
   228                                  section .bss
   229                                  absolute 31594
   230 00007B6A <res 000000C8>          LabelAddr resw 100
   231                                  section .text
   232                                  
   233                                  ;-50 int LabelMaxIx=0;  int LabelIx;
   234                                  
   235 00000051 0000                    LabelMaxIx dw 0
   236 00000053 0000                    LabelIx dw 0
   237                                  
   238                                  ;-51 char FileBin  [2000]; unsigned int BinLen=0;
   239                                  
   240                                  section .bss
   241                                  absolute 31794
   242 00007C32 <res 000007D0>          FileBin resb 2000
   243                                  section .text
   244 00000055 0000                    BinLen dw 0
   245                                  
   246                                  ;-52 
   247                                  
   248                                  
   249                                  ;-53 int process() { int i; char c;
   250                                  
   251                                  
   252                                  process:  ; *** PROC ***
   253                                  
   254                                  ;-54   setTokeType();
   255                                  
   256                                  ;Function : process, Number of local variables: 2
   257                                  ;   # type sign width line used address name   list of local variables
   258                                  ;  200 var sign word    53 NULL bp-2    i
   259                                  ;  201 var sign byte    53 NULL bp-4    c;
   260 00000057 C8040000                 ENTER  4,0
   261 0000005B E82701                   call setTokeType
   262                                  
   263                                  ;-55   OpSize=getCodeSize();
   264                                  
   265 0000005E E80806                   call getCodeSize
   266 00000061 A2[4100]                 mov byte [OpSize], al
   267                                  
   268                                  ;-56 
   269                                  
   270                                  
   271                                  ;-57   if (CodeType ==  1) {//1 byte opcode
   272                                  
   273 00000064 A1[3D00]                 mov ax, [CodeType]
   274 00000067 83F801                   cmp ax, 1
   275 0000006A 0F850D00                 jne @@process1
   276                                  
   277                                  ;-58     genInstruction(0, 1); return;
   278                                  
   279 0000006E 6A01                     push 1
   280 00000070 6A00                     push 0
   281 00000072 E83907                   call genInstruction
   282 00000075 83C404                   add  sp, 4
   283 00000078 E9E400                   jmp @@retn
   284                                  
   285                                  ;-59   }
   286                                  
   287                                  
   288                                  ;-60   if (CodeType ==  2) {//inc, dec
   289                                  
   290                                  @@process1:
   291 0000007B A1[3D00]                 mov ax, [CodeType]
   292 0000007E 83F802                   cmp ax, 2
   293 00000081 0F855400                 jne @@process2
   294                                  
   295                                  ;-61     LeftOpwCheck();
   296                                  
   297 00000085 E89C01                   call LeftOpwCheck
   298                                  
   299                                  ;-62     	if (Op1 == REG) {
   300                                  
   301 00000088 A0[3C00]                 mov al, [Op1]
   302 0000008B 3C02                     cmp al, 2
   303 0000008D 0F853400                 jne @@process3
   304                                  
   305                                  ;-63         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form
   306                                  
   307 00000091 A0[3F00]                 mov al, [RegType]
   308 00000094 3C02                     cmp al, 2
   309 00000096 0F851100                 jne @@process4
   310 0000009A 6A03                     push 3
   311 0000009C A0[4000]                 mov al, byte [RegNo]
   312 0000009F B400                     mov ah, 0
   313 000000A1 50                       push ax
   314 000000A2 E80907                   call genInstruction
   315 000000A5 83C404                   add  sp, 4
   316 000000A8 E9B400                   jmp @@retn
   317                                  
   318                                  ;-64         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
   319                                  
   320                                  @@process4:
   321 000000AB A0[3F00]                 mov al, [RegType]
   322 000000AE 3C03                     cmp al, 3
   323 000000B0 0F851100                 jne @@process5
   324 000000B4 6A03                     push 3
   325 000000B6 A0[4000]                 mov al, byte [RegNo]
   326 000000B9 B400                     mov ah, 0
   327 000000BB 50                       push ax
   328 000000BC E8EF06                   call genInstruction
   329 000000BF 83C404                   add  sp, 4
   330 000000C2 E99A00                   jmp @@retn
   331                                  @@process5:
   332                                  
   333                                  ;-65       genInstruction(wflag, 1); genCodeInREG(); return; 
   334                                  
   335                                  @@process3:
   336 000000C5 6A01                     push 1
   337 000000C7 A0[4300]                 mov al, byte [wflag]
   338 000000CA B400                     mov ah, 0
   339 000000CC 50                       push ax
   340 000000CD E8DE06                   call genInstruction
   341 000000D0 83C404                   add  sp, 4
   342 000000D3 E80A07                   call genCodeInREG
   343 000000D6 E98600                   jmp @@retn
   344                                  
   345                                  ;-66   }
   346                                  
   347                                  
   348                                  ;-67 
   349                                  
   350                                  
   351                                  ;-68   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
   352                                  
   353                                  @@process2:
   354 000000D9 A1[3D00]                 mov ax, [CodeType]
   355 000000DC 83F834                   cmp ax, 52
   356 000000DF 0F851700                 jne @@process6
   357                                  
   358                                  ;-69     LeftOpwCheck();
   359                                  
   360 000000E3 E83E01                   call LeftOpwCheck
   361                                  
   362                                  ;-70     genInstruction(wflag, 1); genCodeInREG(); return; 
   363                                  
   364 000000E6 6A01                     push 1
   365 000000E8 A0[4300]                 mov al, byte [wflag]
   366 000000EB B400                     mov ah, 0
   367 000000ED 50                       push ax
   368 000000EE E8BD06                   call genInstruction
   369 000000F1 83C404                   add  sp, 4
   370 000000F4 E8E906                   call genCodeInREG
   371 000000F7 E96500                   jmp @@retn
   372                                  
   373                                  ;-71   }
   374                                  
   375                                  
   376                                  ;-72 
   377                                  
   378                                  
   379                                  ;-73   if (CodeType==  8) {// ret
   380                                  
   381                                  @@process6:
   382 000000FA A1[3D00]                 mov ax, [CodeType]
   383 000000FD 83F808                   cmp ax, 8
   384 00000100 0F852D00                 jne @@process7
   385                                  
   386                                  ;-74     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}
   387                                  
   388 00000104 A0[3B00]                 mov al, [TokeType]
   389 00000107 3C01                     cmp al, 1
   390 00000109 0F851700                 jne @@process8
   391 0000010D 6A02                     push 2
   392 0000010F 6A00                     push 0
   393 00000111 E89A06                   call genInstruction
   394 00000114 83C404                   add  sp, 4
   395 00000117 FF36[2500]               push word [SymbolInt]
   396 0000011B E86F06                   call genCode16
   397 0000011E 83C402                   add  sp, 2
   398 00000121 E93B00                   jmp @@retn
   399                                  
   400                                  ;-75     genInstruction(0, 1); return; 
   401                                  
   402                                  @@process8:
   403 00000124 6A01                     push 1
   404 00000126 6A00                     push 0
   405 00000128 E88306                   call genInstruction
   406 0000012B 83C404                   add  sp, 4
   407 0000012E E92E00                   jmp @@retn
   408                                  
   409                                  ;-76   }
   410                                  
   411                                  
   412                                  ;-77 
   413                                  
   414                                  
   415                                  ;-78   if (CodeType==101) {// ORG nn
   416                                  
   417                                  @@process7:
   418 00000131 A1[3D00]                 mov ax, [CodeType]
   419 00000134 83F865                   cmp ax, 101
   420 00000137 0F851B00                 jne @@process9
   421                                  
   422                                  ;-79     if (TokeType != DIGIT) error1("only digit allowed");
   423                                  
   424 0000013B A0[3B00]                 mov al, [TokeType]
   425 0000013E 3C01                     cmp al, 1
   426 00000140 0F840900                 je  @@process10
   427 00000144 68[6101]                 push process_0
   428 00000147 E81E17                   call error1
   429 0000014A 83C402                   add  sp, 2
   430                                  
   431                                  ;-80     PC=SymbolInt;return;
   432                                  
   433                                  @@process10:
   434 0000014D A1[2500]                 mov ax, [SymbolInt]
   435 00000150 A3[3600]                 mov word [PC], ax
   436 00000153 E90900                   jmp @@retn
   437                                  
   438                                  ;-81   }
   439                                  
   440                                  
   441                                  ;-82   error1("unknown CodeType");
   442                                  
   443                                  @@process9:
   444 00000156 68[7401]                 push process_1
   445 00000159 E80C17                   call error1
   446 0000015C 83C402                   add  sp, 2
   447                                  
   448                                  ;-83 }
   449                                  
   450                                  
   451                                  ;-84 
   452                                  
   453                                  
   454                                  ;-85 // scan code .....................................
   455                                  
   456                                  
   457                                  ;-86 int setTokeType() { char c; //set: TokeType
   458                                  
   459 0000015F C9                      @@retn: LEAVE
   460 00000160 C3                       ret
   461                                  ; ENDP
   462 00000161 6F6E6C792064696769-     process_0 db "only digit allowed",0
   463 0000016A 7420616C6C6F776564-
   464 00000173 00                 
   465 00000174 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
   466 0000017D 6F64655479706500   
   467                                  
   468                                  setTokeType:  ; *** PROC ***
   469                                  
   470                                  ;-87   skipBlank();
   471                                  
   472                                  ;Function : setTokeType, Number of local variables: 1
   473                                  ;   # type sign width line used address name   list of local variables
   474                                  ;  200 var sign byte    86 NULL bp-2    c;
   475 00000185 C8020000                 ENTER  2,0
   476 00000189 E8FC0B                   call skipBlank
   477                                  
   478                                  ;-88   c = *InputPtr;
   479                                  
   480 0000018C 8B1E[2700]               mov bx, [InputPtr]
   481 00000190 8A07                     mov al, [bx]
   482 00000192 B400                     mov ah, 0
   483 00000194 8846FE                   mov byte [bp-2], al
   484                                  
   485                                  ;-89   if (c == 0)   {TokeType=0; return; }//last line or empty line
   486                                  
   487 00000197 8A46FE                   mov al, [bp-2]
   488 0000019A 3C00                     cmp al, 0
   489 0000019C 0F850C00                 jne @@setTokeType11
   490 000001A0 66B800000000             mov eax, 0
   491 000001A6 A2[3B00]                 mov byte [TokeType], al
   492 000001A9 E97500                   jmp @@retn
   493                                  
   494                                  ;-90   if (c == ';') {TokeType=0; return; }//comment
   495                                  
   496                                  @@setTokeType11:
   497 000001AC 8A46FE                   mov al, [bp-2]
   498 000001AF 3C3B                     cmp al, 59
   499 000001B1 0F850C00                 jne @@setTokeType12
   500 000001B5 66B800000000             mov eax, 0
   501 000001BB A2[3B00]                 mov byte [TokeType], al
   502 000001BE E96000                   jmp @@retn
   503                                  
   504                                  ;-91   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
   505                                  
   506                                  @@setTokeType12:
   507 000001C1 8A46FE                   mov al, byte [bp-2]
   508 000001C4 B400                     mov ah, 0
   509 000001C6 50                       push ax
   510 000001C7 E8FB1C                   call digit
   511 000001CA 83C402                   add  sp, 2
   512 000001CD 08C0                     or  al, al
   513 000001CF 0F841800                 je @@setTokeType13
   514 000001D3 8A46FE                   mov al, byte [bp-2]
   515 000001D6 B400                     mov ah, 0
   516 000001D8 50                       push ax
   517 000001D9 E8D70B                   call getDigit
   518 000001DC 83C402                   add  sp, 2
   519 000001DF 66B801000000             mov eax, 1
   520 000001E5 A2[3B00]                 mov byte [TokeType], al
   521 000001E8 E93600                   jmp @@retn
   522                                  
   523                                  ;-92   if (alnum (c)) {getName(c); TokeType=ALNUM; return;}//ret:2=Symbol
   524                                  
   525                                  @@setTokeType13:
   526 000001EB 8A46FE                   mov al, byte [bp-2]
   527 000001EE B400                     mov ah, 0
   528 000001F0 50                       push ax
   529 000001F1 E8041D                   call alnum
   530 000001F4 83C402                   add  sp, 2
   531 000001F7 08C0                     or  al, al
   532 000001F9 0F841800                 je @@setTokeType14
   533 000001FD 8A46FE                   mov al, byte [bp-2]
   534 00000200 B400                     mov ah, 0
   535 00000202 50                       push ax
   536 00000203 E8040C                   call getName
   537 00000206 83C402                   add  sp, 2
   538 00000209 66B802000000             mov eax, 2
   539 0000020F A2[3B00]                 mov byte [TokeType], al
   540 00000212 E90C00                   jmp @@retn
   541                                  
   542                                  ;-93   TokeType=3; return;               //no alnum
   543                                  
   544                                  @@setTokeType14:
   545 00000215 66B803000000             mov eax, 3
   546 0000021B A2[3B00]                 mov byte [TokeType], al
   547 0000021E E90000                   jmp @@retn
   548                                  
   549                                  ;-94 }
   550                                  
   551                                  
   552                                  ;-95 int Ops() {
   553                                  
   554 00000221 C9                      @@retn: LEAVE
   555 00000222 C3                       ret
   556                                  ; ENDP
   557                                  
   558                                  Ops:  ; *** PROC ***
   559                                  
   560                                  ;-96 //O2=rr,rm,ri,mr,mi
   561                                  
   562                                  
   563                                  ;-97 //NumOprns==2, seg reg not allowed only mov and push
   564                                  
   565                                  
   566                                  ;-98 //size: 1.declaration CodeSize, 2.reg size, 3.error1
   567                                  
   568                                  
   569                                  ;-99 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
   570                                  
   571                                  
   572                                  ;-100 //2. rm , imm 80  
   573                                  
   574                                  
   575                                  ;-101 //2a sign ext 83
   576                                  
   577                                  
   578                                  ;-102 //3. reg, rm  02  if (dest==reg) set direction bit; else default;
   579                                  
   580                                  
   581                                  ;-103 //4. rm , reg 00
   582                                  
   583                                  
   584                                  ;-104 //5. error1(mem2mem)
   585                                  
   586                                  
   587                                  ;-105 }
   588                                  
   589                                  
   590                                  ;-106 int LeftOpwCheck() {
   591                                  
   592 00000223 C3                       ret
   593                                  ; ENDP
   594                                  
   595                                  LeftOpwCheck:  ; *** PROC ***
   596                                  
   597                                  ;-107   getLeftOp();
   598                                  
   599 00000224 E8A700                   call getLeftOp
   600                                  
   601                                  ;-108   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
   602                                  
   603 00000227 A0[3F00]                 mov al, [RegType]
   604 0000022A 3C04                     cmp al, 4
   605 0000022C 0F850600                 jne @@LeftOpwCheck15
   606 00000230 E82E17                   call segregerror
   607 00000233 E95300                   jmp @@retn
   608                                  
   609                                  ;-109   setwflag();
   610                                  
   611                                  @@LeftOpwCheck15:
   612 00000236 E85B01                   call setwflag
   613                                  
   614                                  ;-110   if (OpSize == 0) error1("no op size declared");
   615                                  
   616 00000239 A0[4100]                 mov al, [OpSize]
   617 0000023C 3C00                     cmp al, 0
   618 0000023E 0F850900                 jne @@LeftOpwCheck16
   619 00000242 68[8A02]                 push LeftOpwCheck_0
   620 00000245 E82016                   call error1
   621 00000248 83C402                   add  sp, 2
   622                                  
   623                                  ;-111   if (OpSize == RegType) return;
   624                                  
   625                                  @@LeftOpwCheck16:
   626 0000024B A0[4100]                 mov al, [OpSize]
   627 0000024E 3A06[3F00]               cmp al, [RegType]
   628 00000252 0F850300                 jne @@LeftOpwCheck17
   629 00000256 E93000                   jmp @@retn
   630                                  
   631                                  ;-112   if (OpSize){if (Op1 == IND) return; 
   632                                  
   633                                  @@LeftOpwCheck17:
   634 00000259 A0[4100]                 mov al, [OpSize]
   635 0000025C 08C0                     or  al, al
   636 0000025E 0F841500                 je @@LeftOpwCheck18
   637 00000262 A0[3C00]                 mov al, [Op1]
   638 00000265 3C04                     cmp al, 4
   639 00000267 0F850300                 jne @@LeftOpwCheck19
   640 0000026B E91B00                   jmp @@retn
   641                                  
   642                                  ;-113     error1("Conflict OpSize and RegSize"); }
   643                                  
   644                                  @@LeftOpwCheck19:
   645 0000026E 68[9E02]                 push LeftOpwCheck_1
   646 00000271 E8F415                   call error1
   647 00000274 83C402                   add  sp, 2
   648                                  
   649                                  ;-114   if (RegType==0) error1("no register defined");
   650                                  
   651                                  @@LeftOpwCheck18:
   652 00000277 A0[3F00]                 mov al, [RegType]
   653 0000027A 3C00                     cmp al, 0
   654 0000027C 0F850900                 jne @@LeftOpwCheck20
   655 00000280 68[BA02]                 push LeftOpwCheck_2
   656 00000283 E8E215                   call error1
   657 00000286 83C402                   add  sp, 2
   658                                  
   659                                  ;-115 }
   660                                  
   661                                  @@LeftOpwCheck20:
   662                                  
   663                                  ;-116 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
   664                                  
   665                                  @@retn:
   666 00000289 C3                       ret
   667                                  ; ENDP
   668 0000028A 6E6F206F702073697A-     LeftOpwCheck_0 db "no op size declared",0
   669 00000293 65206465636C617265-
   670 0000029C 6400               
   671 0000029E 436F6E666C69637420-     LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
   672 000002A7 4F7053697A6520616E-
   673 000002B0 642052656753697A65-
   674 000002B9 00                 
   675 000002BA 6E6F20726567697374-     LeftOpwCheck_2 db "no register defined",0
   676 000002C3 657220646566696E65-
   677 000002CC 6400               
   678                                  
   679                                  getLeftOp:  ; *** PROC ***
   680                                  
   681                                  ;-117 //set: op1, disp->imm, reg, regt->size  
   682                                  
   683                                  
   684                                  ;-118   disp=0; imme=0; reg=0; 
   685                                  
   686 000002CE 66B800000000             mov eax, 0
   687 000002D4 A3[4600]                 mov word [disp], ax
   688 000002D7 66B800000000             mov eax, 0
   689 000002DD A3[4800]                 mov word [imme], ax
   690 000002E0 66B800000000             mov eax, 0
   691 000002E6 A2[4500]                 mov byte [reg], al
   692                                  
   693                                  ;-119 
   694                                  
   695                                  
   696                                  ;-120   Op1=getOp1();
   697                                  
   698 000002E9 E80301                   call getOp1
   699 000002EC A2[3C00]                 mov byte [Op1], al
   700                                  
   701                                  ;-121   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
   702                                  
   703 000002EF 6A5B                     push 91
   704 000002F1 E8F803                   call isToken
   705 000002F4 83C402                   add  sp, 2
   706 000002F7 08C0                     or  al, al
   707 000002F9 0F840F00                 je @@getLeftOp21
   708 000002FD 66B804000000             mov eax, 4
   709 00000303 A2[3C00]                 mov byte [Op1], al
   710 00000306 E87101                   call getIND
   711 00000309 E95200                   jmp @@retn
   712                                  
   713                                  ;-122   if (Op1 == 0) error1("Name of operand expected");
   714                                  
   715                                  @@getLeftOp21:
   716 0000030C A0[3C00]                 mov al, [Op1]
   717 0000030F 3C00                     cmp al, 0
   718 00000311 0F850900                 jne @@getLeftOp22
   719 00000315 68[5F03]                 push getLeftOp_0
   720 00000318 E84D15                   call error1
   721 0000031B 83C402                   add  sp, 2
   722                                  
   723                                  ;-123   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
   724                                  
   725                                  @@getLeftOp22:
   726 0000031E A0[3C00]                 mov al, [Op1]
   727 00000321 3C01                     cmp al, 1
   728 00000323 0F850900                 jne @@getLeftOp23
   729 00000327 A1[2500]                 mov ax, [SymbolInt]
   730 0000032A A3[4800]                 mov word [imme], ax
   731 0000032D E92E00                   jmp @@retn
   732                                  
   733                                  ;-124   if (Op1 == REG) return;                                    //2
   734                                  
   735                                  @@getLeftOp23:
   736 00000330 A0[3C00]                 mov al, [Op1]
   737 00000333 3C02                     cmp al, 2
   738 00000335 0F850300                 jne @@getLeftOp24
   739 00000339 E92200                   jmp @@retn
   740                                  
   741                                  ;-125   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
   742                                  
   743                                  @@getLeftOp24:
   744 0000033C A0[3C00]                 mov al, [Op1]
   745 0000033F 3C03                     cmp al, 3
   746 00000341 0F851000                 jne @@getLeftOp25
   747 00000345 8B1E[5300]               mov bx, [LabelIx]
   748 00000349 D1E3                     shl bx, 1
   749 0000034B 8B876A7B                 mov ax, [LabelAddr + bx]
   750 0000034F A3[4600]                 mov word [disp], ax
   751 00000352 E90900                   jmp @@retn
   752                                  
   753                                  ;-126   error1("Name of operand expected #1");
   754                                  
   755                                  @@getLeftOp25:
   756 00000355 68[7803]                 push getLeftOp_1
   757 00000358 E80D15                   call error1
   758 0000035B 83C402                   add  sp, 2
   759                                  
   760                                  ;-127 }
   761                                  
   762                                  
   763                                  ;-128 int setwflag() {//only Op1 (first operand)
   764                                  
   765                                  @@retn:
   766 0000035E C3                       ret
   767                                  ; ENDP
   768 0000035F 4E616D65206F66206F-     getLeftOp_0 db "Name of operand expected",0
   769 00000368 706572616E64206578-
   770 00000371 70656374656400     
   771 00000378 4E616D65206F66206F-     getLeftOp_1 db "Name of operand expected #1",0
   772 00000381 706572616E64206578-
   773 0000038A 706563746564202331-
   774 00000393 00                 
   775                                  
   776                                  setwflag:  ; *** PROC ***
   777                                  
   778                                  ;-129   wflag=0;
   779                                  
   780 00000394 66B800000000             mov eax, 0
   781 0000039A A2[4300]                 mov byte [wflag], al
   782                                  
   783                                  ;-130   if (OpSize == 0) {//do not override OpSize
   784                                  
   785 0000039D A0[4100]                 mov al, [OpSize]
   786 000003A0 3C00                     cmp al, 0
   787 000003A2 0F852100                 jne @@setwflag26
   788                                  
   789                                  ;-131     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
   790                                  
   791 000003A6 A0[3C00]                 mov al, [Op1]
   792 000003A9 3C02                     cmp al, 2
   793 000003AB 0F851800                 jne @@setwflag27
   794 000003AF A0[3F00]                 mov al, [RegType]
   795 000003B2 A2[4100]                 mov byte [OpSize], al
   796 000003B5 A0[3F00]                 mov al, [RegType]
   797 000003B8 3C04                     cmp al, 4
   798 000003BA 0F850900                 jne @@setwflag28
   799 000003BE 66B802000000             mov eax, 2
   800 000003C4 A2[4100]                 mov byte [OpSize], al
   801                                  @@setwflag28:
   802                                  
   803                                  ;-132   }
   804                                  
   805                                  @@setwflag27:
   806                                  
   807                                  ;-133   if (OpSize  == DWORD) {gen66h(); wflag=1;}
   808                                  
   809                                  @@setwflag26:
   810 000003C7 A0[4100]                 mov al, [OpSize]
   811 000003CA 3C03                     cmp al, 3
   812 000003CC 0F850C00                 jne @@setwflag29
   813 000003D0 E87F03                   call gen66h
   814 000003D3 66B801000000             mov eax, 1
   815 000003D9 A2[4300]                 mov byte [wflag], al
   816                                  
   817                                  ;-134   if (OpSize  ==  WORD) wflag=1;
   818                                  
   819                                  @@setwflag29:
   820 000003DC A0[4100]                 mov al, [OpSize]
   821 000003DF 3C02                     cmp al, 2
   822 000003E1 0F850900                 jne @@setwflag30
   823 000003E5 66B801000000             mov eax, 1
   824 000003EB A2[4300]                 mov byte [wflag], al
   825                                  
   826                                  ;-135 }
   827                                  
   828                                  @@setwflag30:
   829                                  
   830                                  ;-136 int getOp1() {//scan for a single operand 
   831                                  
   832 000003EE C3                       ret
   833                                  ; ENDP
   834                                  
   835                                  getOp1:  ; *** PROC ***
   836                                  
   837                                  ;-137   //set:Op1, imme, disp, RegType, TegNo, reg
   838                                  
   839                                  
   840                                  ;-138   if (TokeType == 0)      return 0;
   841                                  
   842 000003EF A0[3B00]                 mov al, [TokeType]
   843 000003F2 3C00                     cmp al, 0
   844 000003F4 0F850900                 jne @@getOp131
   845 000003F8 66B800000000             mov eax, 0
   846 000003FE E96500                   jmp @@retn
   847                                  
   848                                  ;-139   if (TokeType == DIGIT)  return IMM;// 1
   849                                  
   850                                  @@getOp131:
   851 00000401 A0[3B00]                 mov al, [TokeType]
   852 00000404 3C01                     cmp al, 1
   853 00000406 0F850900                 jne @@getOp132
   854 0000040A 66B801000000             mov eax, 1
   855 00000410 E95300                   jmp @@retn
   856                                  
   857                                  ;-140   if (TokeType == ALNUM) {
   858                                  
   859                                  @@getOp132:
   860 00000413 A0[3B00]                 mov al, [TokeType]
   861 00000416 3C02                     cmp al, 2
   862 00000418 0F854100                 jne @@getOp133
   863                                  
   864                                  ;-141     RegNo=testReg();//set global RegType
   865                                  
   866 0000041C E8770A                   call testReg
   867 0000041F A2[4000]                 mov byte [RegNo], al
   868                                  
   869                                  ;-142     if (RegType)          return REG;// 2
   870                                  
   871 00000422 A0[3F00]                 mov al, [RegType]
   872 00000425 08C0                     or  al, al
   873 00000427 0F840900                 je @@getOp134
   874 0000042B 66B802000000             mov eax, 2
   875 00000431 E93200                   jmp @@retn
   876                                  
   877                                  ;-143     LabelIx=searchLabel(VARIABLE);//disp=LabelAddr[LabelIx];
   878                                  
   879                                  @@getOp134:
   880 00000434 6A02                     push 2
   881 00000436 E80F06                   call searchLabel
   882 00000439 83C402                   add  sp, 2
   883 0000043C A3[5300]                 mov word [LabelIx], ax
   884                                  
   885                                  ;-144     if (LabelIx)          return DIR;// 3
   886                                  
   887 0000043F A1[5300]                 mov ax, [LabelIx]
   888 00000442 08C0                     or  al, al
   889 00000444 0F840C00                 je @@getOp135
   890 00000448 66B803000000             mov eax, 3
   891 0000044E E91500                   jmp @@retn
   892                                  
   893                                  ;-145     else error1("variable not found"); }
   894                                  
   895 00000451 E90900                   jmp @@getOp136
   896                                  @@getOp135:
   897 00000454 68[6704]                 push getOp1_0
   898 00000457 E80E14                   call error1
   899 0000045A 83C402                   add  sp, 2
   900                                  @@getOp136:
   901                                  
   902                                  ;-146   return 0;
   903                                  
   904                                  @@getOp133:
   905 0000045D 66B800000000             mov eax, 0
   906 00000463 E90000                   jmp @@retn
   907                                  
   908                                  ;-147 }
   909                                  
   910                                  
   911                                  ;-148 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
   912                                  
   913                                  @@retn:
   914 00000466 C3                       ret
   915                                  ; ENDP
   916 00000467 7661726961626C6520-     getOp1_0 db "variable not found",0
   917 00000470 6E6F7420666F756E64-
   918 00000479 00                 
   919                                  
   920                                  getIND:  ; *** PROC ***
   921                                  
   922                                  ;-149   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
   923                                  
   924                                  ;Function : getIND, Number of local variables: 2
   925                                  ;   # type sign width line used address name   list of local variables
   926                                  ;  200 var sign byte   149 NULL bp-2    op2
   927                                  ;  201 var sign byte   149 NULL bp-4    r1;
   928 0000047A C8040000                 ENTER  4,0
   929 0000047E 66B800000000             mov eax, 0
   930 00000484 A3[4600]                 mov word [disp], ax
   931 00000487 66B800000000             mov eax, 0
   932 0000048D 8846FC                   mov byte [bp-4], al
   933 00000490 66B800000000             mov eax, 0
   934 00000496 A2[3F00]                 mov byte [RegType], al
   935                                  
   936                                  ;-150   do {
   937                                  
   938                                  @@getIND37:
   939                                  
   940                                  ;-151     setTokeType();// 0, DIGIT, ALNUM, no alnum
   941                                  
   942 00000499 E8E9FC                   call setTokeType
   943                                  
   944                                  ;-152     op2=getOp1();
   945                                  
   946 0000049C E850FF                   call getOp1
   947 0000049F 8846FE                   mov byte [bp-2], al
   948                                  
   949                                  ;-153     if (op2 ==   0) syntaxerror();
   950                                  
   951 000004A2 8A46FE                   mov al, [bp-2]
   952 000004A5 3C00                     cmp al, 0
   953 000004A7 0F850300                 jne @@getIND38
   954 000004AB E8DA14                   call syntaxerror
   955                                  
   956                                  ;-154     if (op2 == IMM) disp=disp+SymbolInt;
   957                                  
   958                                  @@getIND38:
   959 000004AE 8A46FE                   mov al, [bp-2]
   960 000004B1 3C01                     cmp al, 1
   961 000004B3 0F850A00                 jne @@getIND39
   962 000004B7 A1[4600]                 mov ax, [disp]
   963 000004BA 0306[2500]               add ax, [SymbolInt]
   964 000004BE A3[4600]                 mov word [disp], ax
   965                                  
   966                                  ;-155     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
   967                                  
   968                                  @@getIND39:
   969 000004C1 8A46FE                   mov al, [bp-2]
   970 000004C4 3C02                     cmp al, 2
   971 000004C6 0F852100                 jne @@getIND40
   972 000004CA 8A46FC                   mov al, [bp-4]
   973 000004CD 08C0                     or  al, al
   974 000004CF 0F841200                 je @@getIND41
   975 000004D3 8A46FC                   mov al, byte [bp-4]
   976 000004D6 B400                     mov ah, 0
   977 000004D8 50                       push ax
   978 000004D9 E80001                   call getIndReg2
   979 000004DC 83C402                   add  sp, 2
   980 000004DF 8846FC                   mov byte [bp-4], al
   981 000004E2 E90600                   jmp @@getIND42
   982                                  @@getIND41:
   983 000004E5 E87F00                   call getIndReg1
   984 000004E8 8846FC                   mov byte [bp-4], al
   985                                  
   986                                  ;-156     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
   987                                  
   988                                  @@getIND42:
   989                                  @@getIND40:
   990 000004EB 8A46FE                   mov al, [bp-2]
   991 000004EE 3C03                     cmp al, 3
   992 000004F0 0F851000                 jne @@getIND43
   993 000004F4 A1[4600]                 mov ax, [disp]
   994 000004F7 8B1E[5300]               mov bx, [LabelIx]
   995 000004FB D1E3                     shl bx, 1
   996 000004FD 03876A7B                 add ax, [LabelAddr + bx]
   997 00000501 A3[4600]                 mov word [disp], ax
   998                                  
   999                                  ;-157     if (isToken('-')) {setTokeType(); 
  1000                                  
  1001                                  @@getIND43:
  1002 00000504 6A2D                     push 45
  1003 00000506 E8E301                   call isToken
  1004 00000509 83C402                   add  sp, 2
  1005 0000050C 08C0                     or  al, al
  1006 0000050E 0F841900                 je @@getIND44
  1007 00000512 E870FC                   call setTokeType
  1008                                  
  1009                                  ;-158       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  1010                                  
  1011 00000515 A0[3B00]                 mov al, [TokeType]
  1012 00000518 3C01                     cmp al, 1
  1013 0000051A 0F840300                 je  @@getIND45
  1014 0000051E E8FC13                   call numbererror
  1015                                  @@getIND45:
  1016 00000521 A1[4600]                 mov ax, [disp]
  1017 00000524 2B06[2500]               sub ax, [SymbolInt]
  1018 00000528 A3[4600]                 mov word [disp], ax
  1019                                  
  1020                                  ;-159   } while (isToken('+'));
  1021                                  
  1022                                  @@getIND44:
  1023 0000052B 6A2B                     push 43
  1024 0000052D E8BC01                   call isToken
  1025 00000530 83C402                   add  sp, 2
  1026 00000533 08C0                     or  al, al
  1027 00000535 0F840300                 je @@getIND46
  1028 00000539 E95DFF                   jmp @@getIND37
  1029                                  @@getIND46:
  1030                                  
  1031                                  ;-160   if (isToken(']') == 0) errorexit("] expected"); 
  1032                                  
  1033 0000053C 6A5D                     push 93
  1034 0000053E E8AB01                   call isToken
  1035 00000541 83C402                   add  sp, 2
  1036 00000544 83F800                   cmp ax, 0
  1037 00000547 0F850900                 jne @@getIND47
  1038 0000054B 68[5C05]                 push getIND_0
  1039 0000054E E84814                   call errorexit
  1040 00000551 83C402                   add  sp, 2
  1041                                  
  1042                                  ;-161   reg=r1;
  1043                                  
  1044                                  @@getIND47:
  1045 00000554 8A46FC                   mov al, [bp-4]
  1046 00000557 A2[4500]                 mov byte [reg], al
  1047                                  
  1048                                  ;-162 }
  1049                                  
  1050                                  
  1051                                  ;-163 int getIndReg1() {char m; m=0;
  1052 0000055A C9                       LEAVE
  1053 0000055B C3                       ret
  1054                                  ; ENDP
  1055 0000055C 5D2065787065637465-     getIND_0 db "] expected",0
  1056 00000565 6400               
  1057                                  
  1058                                  getIndReg1:  ; *** PROC ***
  1059                                  ;Function : getIndReg1, Number of local variables: 1
  1060                                  ;   # type sign width line used address name   list of local variables
  1061                                  ;  200 var sign byte   163 NULL bp-2    m;
  1062 00000567 C8020000                 ENTER  2,0
  1063 0000056B 66B800000000             mov eax, 0
  1064 00000571 8846FE                   mov byte [bp-2], al
  1065                                  
  1066                                  ;-164   if (RegType !=WORD) indexerror();
  1067                                  
  1068 00000574 A0[3F00]                 mov al, [RegType]
  1069 00000577 3C02                     cmp al, 2
  1070 00000579 0F840300                 je  @@getIndReg148
  1071 0000057D E87C13                   call indexerror
  1072                                  
  1073                                  ;-165   if (RegNo==3) m=7;//BX
  1074                                  
  1075                                  @@getIndReg148:
  1076 00000580 A0[4000]                 mov al, [RegNo]
  1077 00000583 3C03                     cmp al, 3
  1078 00000585 0F850900                 jne @@getIndReg149
  1079 00000589 66B807000000             mov eax, 7
  1080 0000058F 8846FE                   mov byte [bp-2], al
  1081                                  
  1082                                  ;-166   if (RegNo==5) m=6;//BP change to BP+0
  1083                                  
  1084                                  @@getIndReg149:
  1085 00000592 A0[4000]                 mov al, [RegNo]
  1086 00000595 3C05                     cmp al, 5
  1087 00000597 0F850900                 jne @@getIndReg150
  1088 0000059B 66B806000000             mov eax, 6
  1089 000005A1 8846FE                   mov byte [bp-2], al
  1090                                  
  1091                                  ;-167   if (RegNo==7) m=5;//DI
  1092                                  
  1093                                  @@getIndReg150:
  1094 000005A4 A0[4000]                 mov al, [RegNo]
  1095 000005A7 3C07                     cmp al, 7
  1096 000005A9 0F850900                 jne @@getIndReg151
  1097 000005AD 66B805000000             mov eax, 5
  1098 000005B3 8846FE                   mov byte [bp-2], al
  1099                                  
  1100                                  ;-168   if (RegNo==6) m=4;//SI
  1101                                  
  1102                                  @@getIndReg151:
  1103 000005B6 A0[4000]                 mov al, [RegNo]
  1104 000005B9 3C06                     cmp al, 6
  1105 000005BB 0F850900                 jne @@getIndReg152
  1106 000005BF 66B804000000             mov eax, 4
  1107 000005C5 8846FE                   mov byte [bp-2], al
  1108                                  
  1109                                  ;-169   if (m    ==0) indexerror();
  1110                                  
  1111                                  @@getIndReg152:
  1112 000005C8 8A46FE                   mov al, [bp-2]
  1113 000005CB 3C00                     cmp al, 0
  1114 000005CD 0F850300                 jne @@getIndReg153
  1115 000005D1 E82813                   call indexerror
  1116                                  
  1117                                  ;-170   return m;
  1118                                  
  1119                                  @@getIndReg153:
  1120 000005D4 8A46FE                   mov al, [bp-2]
  1121 000005D7 E90000                   jmp @@retn
  1122                                  
  1123                                  ;-171 }
  1124                                  
  1125                                  
  1126                                  ;-172 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  1127                                  
  1128 000005DA C9                      @@retn: LEAVE
  1129 000005DB C3                       ret
  1130                                  ; ENDP
  1131                                  
  1132                                  getIndReg2:  ; *** PROC ***
  1133                                  ;Function : getIndReg2, Number of local variables: 2
  1134                                  ;   # type sign width line used address name   list of local variables
  1135                                  ;  200 var sign byte   172 NULL bp+4    r1
  1136                                  ;  201 var sign byte   172 NULL bp-2    m;
  1137 000005DC C8020000                 ENTER  2,0
  1138 000005E0 66B804000000             mov eax, 4
  1139 000005E6 8846FE                   mov byte [bp-2], al
  1140                                  
  1141                                  ;-173   if (RegType !=WORD) indexerror();
  1142                                  
  1143 000005E9 A0[3F00]                 mov al, [RegType]
  1144 000005EC 3C02                     cmp al, 2
  1145 000005EE 0F840300                 je  @@getIndReg254
  1146 000005F2 E80713                   call indexerror
  1147                                  
  1148                                  ;-174   if (RegNo==7) if (r1==6) m=3;//BP+DI
  1149                                  
  1150                                  @@getIndReg254:
  1151 000005F5 A0[4000]                 mov al, [RegNo]
  1152 000005F8 3C07                     cmp al, 7
  1153 000005FA 0F852700                 jne @@getIndReg255
  1154 000005FE 8A4604                   mov al, [bp+4]
  1155 00000601 3C06                     cmp al, 6
  1156 00000603 0F850C00                 jne @@getIndReg256
  1157 00000607 66B803000000             mov eax, 3
  1158 0000060D 8846FE                   mov byte [bp-2], al
  1159                                  
  1160                                  ;-175            else if (r1==7) m=1;//BX+DI
  1161                                  
  1162 00000610 E91200                   jmp @@getIndReg257
  1163                                  @@getIndReg256:
  1164 00000613 8A4604                   mov al, [bp+4]
  1165 00000616 3C07                     cmp al, 7
  1166 00000618 0F850900                 jne @@getIndReg258
  1167 0000061C 66B801000000             mov eax, 1
  1168 00000622 8846FE                   mov byte [bp-2], al
  1169                                  
  1170                                  ;-176   if (RegNo==6) if (r1==6) m=2;//BP+SI
  1171                                  
  1172                                  @@getIndReg258:
  1173                                  @@getIndReg257:
  1174                                  @@getIndReg255:
  1175 00000625 A0[4000]                 mov al, [RegNo]
  1176 00000628 3C06                     cmp al, 6
  1177 0000062A 0F852700                 jne @@getIndReg259
  1178 0000062E 8A4604                   mov al, [bp+4]
  1179 00000631 3C06                     cmp al, 6
  1180 00000633 0F850C00                 jne @@getIndReg260
  1181 00000637 66B802000000             mov eax, 2
  1182 0000063D 8846FE                   mov byte [bp-2], al
  1183                                  
  1184                                  ;-177            else if (r1==7) m=0;//BX+DI
  1185                                  
  1186 00000640 E91200                   jmp @@getIndReg261
  1187                                  @@getIndReg260:
  1188 00000643 8A4604                   mov al, [bp+4]
  1189 00000646 3C07                     cmp al, 7
  1190 00000648 0F850900                 jne @@getIndReg262
  1191 0000064C 66B800000000             mov eax, 0
  1192 00000652 8846FE                   mov byte [bp-2], al
  1193                                  
  1194                                  ;-178   if (m > 3) indexerror();
  1195                                  
  1196                                  @@getIndReg262:
  1197                                  @@getIndReg261:
  1198                                  @@getIndReg259:
  1199 00000655 8A46FE                   mov al, [bp-2]
  1200 00000658 3C03                     cmp al, 3
  1201 0000065A 0F8E0300                 jle @@getIndReg263
  1202 0000065E E89B12                   call indexerror
  1203                                  
  1204                                  ;-179   return m;
  1205                                  
  1206                                  @@getIndReg263:
  1207 00000661 8A46FE                   mov al, [bp-2]
  1208 00000664 E90000                   jmp @@retn
  1209                                  
  1210                                  ;-180 }
  1211                                  
  1212                                  
  1213                                  ;-181 
  1214                                  
  1215                                  
  1216                                  ;-182 int getCodeSize() {
  1217                                  
  1218 00000667 C9                      @@retn: LEAVE
  1219 00000668 C3                       ret
  1220                                  ; ENDP
  1221                                  
  1222                                  getCodeSize:  ; *** PROC ***
  1223                                  
  1224                                  ;-183   if (TokeType ==ALNUM) {
  1225                                  
  1226 00000669 A0[3B00]                 mov al, [TokeType]
  1227 0000066C 3C02                     cmp al, 2
  1228 0000066E 0F856000                 jne @@getCodeSize64
  1229                                  
  1230                                  ;-184     if (eqstr(SymbolUpper,"BYTE")) {setTokeType(); return BYTE;}
  1231                                  
  1232 00000672 68[DC06]                 push getCodeSize_0
  1233 00000675 8D068075                 lea  ax, [SymbolUpper]
  1234 00000679 50                       push ax
  1235 0000067A E8F618                   call eqstr
  1236 0000067D 83C404                   add  sp, 4
  1237 00000680 08C0                     or  al, al
  1238 00000682 0F840C00                 je @@getCodeSize65
  1239 00000686 E8FCFA                   call setTokeType
  1240 00000689 66B801000000             mov eax, 1
  1241 0000068F E94900                   jmp @@retn
  1242                                  
  1243                                  ;-185     if (eqstr(SymbolUpper,"WORD")) {setTokeType(); return WORD;}
  1244                                  
  1245                                  @@getCodeSize65:
  1246 00000692 68[E106]                 push getCodeSize_1
  1247 00000695 8D068075                 lea  ax, [SymbolUpper]
  1248 00000699 50                       push ax
  1249 0000069A E8D618                   call eqstr
  1250 0000069D 83C404                   add  sp, 4
  1251 000006A0 08C0                     or  al, al
  1252 000006A2 0F840C00                 je @@getCodeSize66
  1253 000006A6 E8DCFA                   call setTokeType
  1254 000006A9 66B802000000             mov eax, 2
  1255 000006AF E92900                   jmp @@retn
  1256                                  
  1257                                  ;-186     if (eqstr(SymbolUpper,"DWORD")){setTokeType(); return DWORD;}
  1258                                  
  1259                                  @@getCodeSize66:
  1260 000006B2 68[E606]                 push getCodeSize_2
  1261 000006B5 8D068075                 lea  ax, [SymbolUpper]
  1262 000006B9 50                       push ax
  1263 000006BA E8B618                   call eqstr
  1264 000006BD 83C404                   add  sp, 4
  1265 000006C0 08C0                     or  al, al
  1266 000006C2 0F840C00                 je @@getCodeSize67
  1267 000006C6 E8BCFA                   call setTokeType
  1268 000006C9 66B803000000             mov eax, 3
  1269 000006CF E90900                   jmp @@retn
  1270                                  
  1271                                  ;-187   } return 0;
  1272                                  
  1273                                  @@getCodeSize67:
  1274                                  @@getCodeSize64:
  1275 000006D2 66B800000000             mov eax, 0
  1276 000006D8 E90000                   jmp @@retn
  1277                                  
  1278                                  ;-188 }
  1279                                  
  1280                                  
  1281                                  ;-189 int isToken(char c) {
  1282                                  
  1283                                  @@retn:
  1284 000006DB C3                       ret
  1285                                  ; ENDP
  1286 000006DC 4259544500              getCodeSize_0 db "BYTE",0
  1287 000006E1 574F524400              getCodeSize_1 db "WORD",0
  1288 000006E6 44574F524400            getCodeSize_2 db "DWORD",0
  1289                                  
  1290                                  isToken:  ; *** PROC ***
  1291                                  
  1292                                  ;-190   skipBlank();
  1293                                  
  1294                                  ;Function : isToken, Number of local variables: 1
  1295                                  ;   # type sign width line used address name   list of local variables
  1296                                  ;  200 var sign byte   189 NULL bp+4    c;
  1297 000006EC C8000000                 ENTER  0,0
  1298 000006F0 E89506                   call skipBlank
  1299                                  
  1300                                  ;-191   if (*InputPtr == c) {
  1301                                  
  1302 000006F3 8B1E[2700]               mov bx, [InputPtr]
  1303 000006F7 8A07                     mov al, [bx]
  1304 000006F9 B400                     mov ah, 0
  1305 000006FB 3A4604                   cmp al, [bp+4]
  1306 000006FE 0F850D00                 jne @@isToken68
  1307                                  
  1308                                  ;-192     InputPtr++; return 1;} return 0;
  1309                                  
  1310 00000702 FF06[2700]               inc  word [InputPtr]
  1311 00000706 66B801000000             mov eax, 1
  1312 0000070C E90900                   jmp @@retn
  1313                                  @@isToken68:
  1314 0000070F 66B800000000             mov eax, 0
  1315 00000715 E90000                   jmp @@retn
  1316                                  
  1317                                  ;-193 }
  1318                                  
  1319                                  
  1320                                  ;-194 /*int need(char c) {
  1321                                  
  1322                                  
  1323                                  ;-195   if (isToken(c) == 0) {
  1324                                  
  1325                                  
  1326                                  ;-196     prs("\n; ************** expected >> "); prc(c);
  1327                                  
  1328                                  
  1329                                  ;-197     prs(" <<\\n"); errorexit("token expected"); }  }*/
  1330                                  
  1331                                  
  1332                                  ;-198 int skipRest() {
  1333                                  
  1334 00000718 C9                      @@retn: LEAVE
  1335 00000719 C3                       ret
  1336                                  ; ENDP
  1337                                  
  1338                                  skipRest:  ; *** PROC ***
  1339                                  
  1340                                  ;-199   setTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");
  1341                                  
  1342 0000071A E868FA                   call setTokeType
  1343 0000071D A0[3B00]                 mov al, [TokeType]
  1344 00000720 3C00                     cmp al, 0
  1345 00000722 0F840900                 je  @@skipRest69
  1346 00000726 68[3007]                 push skipRest_0
  1347 00000729 E8DF0F                   call prs
  1348 0000072C 83C402                   add  sp, 2
  1349                                  
  1350                                  ;-200 }
  1351                                  
  1352                                  @@skipRest69:
  1353                                  
  1354                                  ;-201 // generate code ...........................................................
  1355                                  
  1356                                  
  1357                                  ;-202 int gen66h() {genCode8(0x66);}
  1358                                  
  1359 0000072F C3                       ret
  1360                                  ; ENDP
  1361 00000730 5C6E3B202A2A2A2A2A-     skipRest_0 db "\n; ********** extra char ignored",0
  1362 00000739 2A2A2A2A2A20657874-
  1363 00000742 726120636861722069-
  1364 0000074B 676E6F72656400     
  1365                                  
  1366                                  gen66h:  ; *** PROC ***
  1367 00000752 6A66                     push 102
  1368 00000754 E80400                   call genCode8
  1369 00000757 83C402                   add  sp, 2
  1370                                  
  1371                                  ;-203 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  1372                                  
  1373 0000075A C3                       ret
  1374                                  ; ENDP
  1375                                  
  1376                                  genCode8:  ; *** PROC ***
  1377                                  
  1378                                  ;-204   FileBin[BinLen]=c; BinLen++; PC++;
  1379                                  
  1380                                  ;Function : genCode8, Number of local variables: 1
  1381                                  ;   # type sign width line used address name   list of local variables
  1382                                  ;  200 var sign byte   203 NULL bp+4    c;
  1383 0000075B C8000000                 ENTER  0,0
  1384 0000075F 8A4604                   mov al, [bp+4]
  1385 00000762 8B1E[5500]               mov bx, [BinLen]
  1386 00000766 8887327C                 mov [FileBin+bx], al
  1387 0000076A FF06[5500]               inc  word [BinLen]
  1388 0000076E FF06[3600]               inc  word [PC]
  1389                                  
  1390                                  ;-205   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
  1391                                  
  1392 00000772 A1[4A00]                 mov ax, [OpPrintIndex]
  1393 00000775 83F805                   cmp ax, 5
  1394 00000778 0F8D0F00                 jge @@genCode870
  1395 0000077C 8A4604                   mov al, [bp+4]
  1396 0000077F 8B1E[4A00]               mov bx, [OpPrintIndex]
  1397 00000783 88871977                 mov [OpPos+bx], al
  1398 00000787 FF06[4A00]               inc  word [OpPrintIndex]
  1399                                  
  1400                                  ;-206 }
  1401                                  
  1402                                  @@genCode870:
  1403                                  
  1404                                  ;-207 int genCode16(int i) {
  1405 0000078B C9                       LEAVE
  1406 0000078C C3                       ret
  1407                                  ; ENDP
  1408                                  
  1409                                  genCode16:  ; *** PROC ***
  1410                                  
  1411                                  ;-208   genCode8(i); i=i >> 8; genCode8(i);
  1412                                  
  1413                                  ;Function : genCode16, Number of local variables: 1
  1414                                  ;   # type sign width line used address name   list of local variables
  1415                                  ;  200 var sign word   207 NULL bp+4    i;
  1416 0000078D C8000000                 ENTER  0,0
  1417 00000791 FF7604                   push word [bp+4]
  1418 00000794 E8C4FF                   call genCode8
  1419 00000797 83C402                   add  sp, 2
  1420 0000079A 8B4604                   mov ax, [bp+4]
  1421 0000079D C1E808                   shr ax, 8
  1422 000007A0 894604                   mov word [bp+4], ax
  1423 000007A3 FF7604                   push word [bp+4]
  1424 000007A6 E8B2FF                   call genCode8
  1425 000007A9 83C402                   add  sp, 2
  1426                                  
  1427                                  ;-209 }
  1428                                  
  1429                                  
  1430                                  ;-210 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  1431 000007AC C9                       LEAVE
  1432 000007AD C3                       ret
  1433                                  ; ENDP
  1434                                  
  1435                                  genInstruction:  ; *** PROC ***
  1436                                  
  1437                                  ;-211   if(loc) OpCodePtr=OpCodePtr+loc;
  1438                                  
  1439                                  ;Function : genInstruction, Number of local variables: 3
  1440                                  ;   # type sign width line used address name   list of local variables
  1441                                  ;  200 var sign byte   210 NULL bp+4    No
  1442                                  ;  201 var sign word   210 NULL bp+6    loc
  1443                                  ;  202 var sign byte   210 NULL bp-2    c;
  1444 000007AE C8020000                 ENTER  2,0
  1445 000007B2 8B4606                   mov ax, [bp+6]
  1446 000007B5 08C0                     or  al, al
  1447 000007B7 0F840900                 je @@genInstruction71
  1448 000007BB A1[4C00]                 mov ax, [OpCodePtr]
  1449 000007BE 034606                   add ax, [bp+6]
  1450 000007C1 A3[4C00]                 mov word [OpCodePtr], ax
  1451                                  
  1452                                  ;-212   c= *OpCodePtr + No; genCode8(c);
  1453                                  
  1454                                  @@genInstruction71:
  1455 000007C4 8B1E[4C00]               mov bx, [OpCodePtr]
  1456 000007C8 8A07                     mov al, [bx]
  1457 000007CA B400                     mov ah, 0
  1458 000007CC 024604                   add al, [bp+4]
  1459 000007CF 8846FE                   mov byte [bp-2], al
  1460 000007D2 8A46FE                   mov al, byte [bp-2]
  1461 000007D5 B400                     mov ah, 0
  1462 000007D7 50                       push ax
  1463 000007D8 E880FF                   call genCode8
  1464 000007DB 83C402                   add  sp, 2
  1465                                  
  1466                                  ;-213 }
  1467                                  
  1468                                  
  1469                                  ;-214 int genCodeInREG() {char x; //get Code for second byte
  1470 000007DE C9                       LEAVE
  1471 000007DF C3                       ret
  1472                                  ; ENDP
  1473                                  
  1474                                  genCodeInREG:  ; *** PROC ***
  1475                                  
  1476                                  ;-215   OpCodePtr++; x= *OpCodePtr; writeEA(x);
  1477                                  
  1478                                  ;Function : genCodeInREG, Number of local variables: 1
  1479                                  ;   # type sign width line used address name   list of local variables
  1480                                  ;  200 var sign byte   214 NULL bp-2    x;
  1481 000007E0 C8020000                 ENTER  2,0
  1482 000007E4 FF06[4C00]               inc  word [OpCodePtr]
  1483 000007E8 8B1E[4C00]               mov bx, [OpCodePtr]
  1484 000007EC 8A07                     mov al, [bx]
  1485 000007EE B400                     mov ah, 0
  1486 000007F0 8846FE                   mov byte [bp-2], al
  1487 000007F3 8A46FE                   mov al, byte [bp-2]
  1488 000007F6 B400                     mov ah, 0
  1489 000007F8 50                       push ax
  1490 000007F9 E81200                   call writeEA
  1491 000007FC 83C402                   add  sp, 2
  1492                                  
  1493                                  ;-216 }
  1494                                  
  1495                                  
  1496                                  ;-217 int genModRegRM(){ writeEA(reg);//todo
  1497 000007FF C9                       LEAVE
  1498 00000800 C3                       ret
  1499                                  ; ENDP
  1500                                  
  1501                                  genModRegRM:  ; *** PROC ***
  1502 00000801 A0[4500]                 mov al, byte [reg]
  1503 00000804 B400                     mov ah, 0
  1504 00000806 50                       push ax
  1505 00000807 E80400                   call writeEA
  1506 0000080A 83C402                   add  sp, 2
  1507                                  
  1508                                  ;-218 }
  1509                                  
  1510                                  
  1511                                  ;-219 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  1512                                  
  1513 0000080D C3                       ret
  1514                                  ; ENDP
  1515                                  
  1516                                  writeEA:  ; *** PROC ***
  1517                                  
  1518                                  ;-220   len=0;
  1519                                  
  1520                                  ;Function : writeEA, Number of local variables: 2
  1521                                  ;   # type sign width line used address name   list of local variables
  1522                                  ;  200 var sign byte   219 NULL bp+4    xxx
  1523                                  ;  201 var sign byte   219 NULL bp-2    len;
  1524 0000080E C8020000                 ENTER  2,0
  1525 00000812 66B800000000             mov eax, 0
  1526 00000818 8846FE                   mov byte [bp-2], al
  1527                                  
  1528                                  ;-221   xxx = xxx << 3;//in reg field of mod r/m
  1529                                  
  1530 0000081B 8A4604                   mov al, [bp+4]
  1531 0000081E C0E003                   shl al, 3
  1532 00000821 884604                   mov byte [bp+4], al
  1533                                  
  1534                                  ;-222   if (Op1 ==   0) addrexit();  
  1535                                  
  1536 00000824 A0[3C00]                 mov al, [Op1]
  1537 00000827 3C00                     cmp al, 0
  1538 00000829 0F850300                 jne @@writeEA72
  1539 0000082D E88011                   call addrexit
  1540                                  
  1541                                  ;-223   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  1542                                  
  1543                                  @@writeEA72:
  1544 00000830 A0[3C00]                 mov al, [Op1]
  1545 00000833 3C02                     cmp al, 2
  1546 00000835 0F850E00                 jne @@writeEA73
  1547 00000839 804E04C0                 or  byte [bp+4], 192
  1548 0000083D 8A4604                   mov al, [bp+4]
  1549 00000840 0206[4000]               add al, [RegNo]
  1550 00000844 884604                   mov byte [bp+4], al
  1551                                  
  1552                                  ;-224   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  1553                                  
  1554                                  @@writeEA73:
  1555 00000847 A0[3C00]                 mov al, [Op1]
  1556 0000084A 3C03                     cmp al, 3
  1557 0000084C 0F850D00                 jne @@writeEA74
  1558 00000850 804E0406                 or  byte [bp+4], 6
  1559 00000854 66B802000000             mov eax, 2
  1560 0000085A 8846FE                   mov byte [bp-2], al
  1561                                  
  1562                                  ;-225   if (Op1 == IND) { xxx = xxx + reg;                       //4
  1563                                  
  1564                                  @@writeEA74:
  1565 0000085D A0[3C00]                 mov al, [Op1]
  1566 00000860 3C04                     cmp al, 4
  1567 00000862 0F854600                 jne @@writeEA75
  1568 00000866 8A4604                   mov al, [bp+4]
  1569 00000869 0206[4500]               add al, [reg]
  1570 0000086D 884604                   mov byte [bp+4], al
  1571                                  
  1572                                  ;-226     if (disp) {disp; if(ax > 127) len=2; else len=1;
  1573                                  
  1574 00000870 A1[4600]                 mov ax, [disp]
  1575 00000873 08C0                     or  al, al
  1576 00000875 0F843300                 je @@writeEA76
  1577 00000879 A1[4600]                 mov ax, [disp]
  1578 0000087C 83F87F                   cmp  ax, 127
  1579 0000087F 0F8E0C00                 jle @@writeEA77
  1580 00000883 66B802000000             mov eax, 2
  1581 00000889 8846FE                   mov byte [bp-2], al
  1582 0000088C E90900                   jmp @@writeEA78
  1583                                  @@writeEA77:
  1584 0000088F 66B801000000             mov eax, 1
  1585 00000895 8846FE                   mov byte [bp-2], al
  1586                                  
  1587                                  ;-227       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
  1588                                  
  1589                                  @@writeEA78:
  1590 00000898 8A46FE                   mov al, [bp-2]
  1591 0000089B 3C01                     cmp al, 1
  1592 0000089D 0F850700                 jne @@writeEA79
  1593 000008A1 804E0440                 or  byte [bp+4], 64
  1594 000008A5 E90400                   jmp @@writeEA80
  1595                                  @@writeEA79:
  1596 000008A8 804E0480                 or  byte [bp+4], 128
  1597                                  @@writeEA80:
  1598                                  
  1599                                  ;-228     }
  1600                                  
  1601                                  @@writeEA76:
  1602                                  
  1603                                  ;-229   genCode8(xxx);// gen second byte
  1604                                  
  1605                                  @@writeEA75:
  1606 000008AC 8A4604                   mov al, byte [bp+4]
  1607 000008AF B400                     mov ah, 0
  1608 000008B1 50                       push ax
  1609 000008B2 E8A6FE                   call genCode8
  1610 000008B5 83C402                   add  sp, 2
  1611                                  
  1612                                  ;-230   if (len == 1) genCode8 (disp);
  1613                                  
  1614 000008B8 8A46FE                   mov al, [bp-2]
  1615 000008BB 3C01                     cmp al, 1
  1616 000008BD 0F850A00                 jne @@writeEA81
  1617 000008C1 FF36[4600]               push word [disp]
  1618 000008C5 E893FE                   call genCode8
  1619 000008C8 83C402                   add  sp, 2
  1620                                  
  1621                                  ;-231   if (len == 2) genCode16(disp);
  1622                                  
  1623                                  @@writeEA81:
  1624 000008CB 8A46FE                   mov al, [bp-2]
  1625 000008CE 3C02                     cmp al, 2
  1626 000008D0 0F850A00                 jne @@writeEA82
  1627 000008D4 FF36[4600]               push word [disp]
  1628 000008D8 E8B2FE                   call genCode16
  1629 000008DB 83C402                   add  sp, 2
  1630                                  
  1631                                  ;-232 }
  1632                                  
  1633                                  @@writeEA82:
  1634                                  
  1635                                  ;-233 int test1() { __asm {
  1636 000008DE C9                       LEAVE
  1637 000008DF C3                       ret
  1638                                  ; ENDP
  1639                                  
  1640                                  test1:  ; *** PROC ***
  1641                                  
  1642                                  
  1643                                  ;-234 inc byte [Version1]   ;FE 06 [1000]
  1644                                  
  1645 000008E0 FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  1646                                  
  1647                                  ;-235 add bx, ax    ;01 C3
  1648                                  
  1649 000008E4 01C3                    add bx, ax    ;01 C3
  1650                                  
  1651                                  ;-236 add ax, bx    ;01 D8
  1652                                  
  1653 000008E6 01D8                    add ax, bx    ;01 D8
  1654                                  
  1655                                  ;-237 add word ax, [bx] ;03 07
  1656                                  
  1657 000008E8 0307                    add word ax, [bx] ;03 07
  1658                                  
  1659                                  ;-238 VA dw 8
  1660                                  
  1661 000008EA 0800                    VA dw 8
  1662                                  
  1663                                  ;-239 mov byte [bp- 4], al ;88 46 FC
  1664                                  
  1665 000008EC 8846FC                  mov byte [bp- 4], al ;88 46 FC
  1666                                  
  1667                                  ;-240 mov      [VA+bx], al ;88 87 [300F]
  1668                                  
  1669 000008EF 8887[EA08]              mov      [VA+bx], al ;88 87 [300F]
  1670                                  
  1671                                  ;-241 }  }
  1672                                  
  1673                                  
  1674                                  
  1675                                  ;-242 #include "AS1.C"
  1676                                  
  1677 000008F3 C3                       ret
  1678                                  ; ENDP
  1679                                  ;Use include file: AS1.C
  1680                                  
  1681                                  ;-1 //AS1.C  5.12.2014  BAS,  AS TE
  1682                                  
  1683                                  
  1684                                  ;-2 int parse() {
  1685                                  
  1686                                  
  1687                                  parse:  ; *** PROC ***
  1688                                  
  1689                                  ;-3   LabelNamePtr= &LabelNames;
  1690                                  
  1691 000008F4 B81E77                   mov ax, LabelNames
  1692 000008F7 A3[4F00]                 mov word [LabelNamePtr], ax
  1693                                  
  1694                                  ;-4   do {
  1695                                  
  1696                                  @@parse83:
  1697                                  
  1698                                  ;-5     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
  1699                                  
  1700 000008FA A1[3600]                 mov ax, [PC]
  1701 000008FD A3[3800]                 mov word [PCStart], ax
  1702 00000900 66B800000000             mov eax, 0
  1703 00000906 A2[4100]                 mov byte [OpSize], al
  1704 00000909 66B800000000             mov eax, 0
  1705 0000090F A3[4A00]                 mov word [OpPrintIndex], ax
  1706 00000912 66B820000000             mov eax, 32
  1707 00000918 A2[4E00]                 mov byte [PrReloc], al
  1708                                  
  1709                                  ;-6     getLine();
  1710                                  
  1711 0000091B E89D03                   call getLine
  1712                                  
  1713                                  ;-7     InputPtr = &InputBuf;
  1714                                  
  1715 0000091E B8D075                   mov ax, InputBuf
  1716 00000921 A3[2700]                 mov word [InputPtr], ax
  1717                                  
  1718                                  ;-8     setTokeType();// getCode in SymbolUpper, set TokeType, set isLabel by getName
  1719                                  
  1720 00000924 E85EF8                   call setTokeType
  1721                                  
  1722                                  ;-9     if (TokeType == ALNUM) {
  1723                                  
  1724 00000927 A0[3B00]                 mov al, [TokeType]
  1725 0000092A 3C02                     cmp al, 2
  1726 0000092C 0F851800                 jne @@parse84
  1727                                  
  1728                                  ;-10       if (isLabel) {
  1729                                  
  1730 00000930 A0[3A00]                 mov al, [isLabel]
  1731 00000933 08C0                     or  al, al
  1732 00000935 0F840F00                 je @@parse85
  1733                                  
  1734                                  ;-11         storeLabel(LABEL);
  1735                                  
  1736 00000939 6A01                     push 1
  1737 0000093B E8A600                   call storeLabel
  1738 0000093E 83C402                   add  sp, 2
  1739                                  
  1740                                  ;-12         InputPtr++;//remove :
  1741                                  
  1742 00000941 FF06[2700]               inc  word [InputPtr]
  1743                                  
  1744                                  ;-13         setTokeType();
  1745                                  
  1746 00000945 E83DF8                   call setTokeType
  1747                                  
  1748                                  ;-14       }
  1749                                  
  1750                                  
  1751                                  ;-15     }
  1752                                  
  1753                                  @@parse85:
  1754                                  
  1755                                  ;-16     if (TokeType == ALNUM) {
  1756                                  
  1757                                  @@parse84:
  1758 00000948 A0[3B00]                 mov al, [TokeType]
  1759 0000094B 3C02                     cmp al, 2
  1760 0000094D 0F851B00                 jne @@parse86
  1761                                  
  1762                                  ;-17       lookCode();// and OpCodePtr
  1763                                  
  1764 00000951 E82F0C                   call lookCode
  1765                                  
  1766                                  ;-18       if(CodeType) process();
  1767                                  
  1768 00000954 A1[3D00]                 mov ax, [CodeType]
  1769 00000957 08C0                     or  al, al
  1770 00000959 0F840600                 je @@parse87
  1771 0000095D E8F7F6                   call process
  1772                                  
  1773                                  ;-19       else getVariable();
  1774                                  
  1775 00000960 E90300                   jmp @@parse88
  1776                                  @@parse87:
  1777 00000963 E84201                   call getVariable
  1778                                  
  1779                                  ;-20       skipRest();
  1780                                  
  1781                                  @@parse88:
  1782 00000966 E8B1FD                   call skipRest
  1783                                  
  1784                                  ;-21     }
  1785                                  
  1786                                  
  1787                                  ;-22     else if (TokeType >  ALNUM) error1("Label or instruction expected");
  1788                                  
  1789 00000969 E92700                   jmp @@parse89
  1790                                  @@parse86:
  1791 0000096C A0[3B00]                 mov al, [TokeType]
  1792 0000096F 3C02                     cmp al, 2
  1793 00000971 0F8E0C00                 jle @@parse90
  1794 00000975 68[A409]                 push parse_0
  1795 00000978 E8ED0E                   call error1
  1796 0000097B 83C402                   add  sp, 2
  1797                                  
  1798                                  ;-23     else if (TokeType == DIGIT) error1("No digit allowed at start of line");
  1799                                  
  1800 0000097E E91200                   jmp @@parse91
  1801                                  @@parse90:
  1802 00000981 A0[3B00]                 mov al, [TokeType]
  1803 00000984 3C01                     cmp al, 1
  1804 00000986 0F850900                 jne @@parse92
  1805 0000098A 68[C209]                 push parse_1
  1806 0000098D E8D80E                   call error1
  1807 00000990 83C402                   add  sp, 2
  1808                                  
  1809                                  ;-24     printLine();
  1810                                  
  1811                                  @@parse92:
  1812                                  @@parse91:
  1813                                  @@parse89:
  1814 00000993 E8670C                   call printLine
  1815                                  
  1816                                  ;-25   } while (DOS_NoBytes != 0 );
  1817                                  
  1818 00000996 A1[3300]                 mov ax, [DOS_NoBytes]
  1819 00000999 83F800                   cmp ax, 0
  1820 0000099C 0F840300                 je  @@parse93
  1821 000009A0 E957FF                   jmp @@parse83
  1822                                  @@parse93:
  1823                                  
  1824                                  ;-26 }
  1825                                  
  1826                                  
  1827                                  ;-27 int storeLabel(char LabType) {
  1828                                  
  1829 000009A3 C3                       ret
  1830                                  ; ENDP
  1831 000009A4 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1832 000009AD 696E73747275637469-
  1833 000009B6 6F6E20657870656374-
  1834 000009BF 656400             
  1835 000009C2 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  1836 000009CB 616C6C6F7765642061-
  1837 000009D4 74207374617274206F-
  1838 000009DD 66206C696E6500     
  1839                                  
  1840                                  storeLabel:  ; *** PROC ***
  1841                                  
  1842                                  ;-28   if(searchLabel(LabType)) error1("duplicate symbol");
  1843                                  
  1844                                  ;Function : storeLabel, Number of local variables: 1
  1845                                  ;   # type sign width line used address name   list of local variables
  1846                                  ;  200 var sign byte    27 NULL bp+4    LabType;
  1847 000009E4 C8000000                 ENTER  0,0
  1848 000009E8 8A4604                   mov al, byte [bp+4]
  1849 000009EB B400                     mov ah, 0
  1850 000009ED 50                       push ax
  1851 000009EE E85700                   call searchLabel
  1852 000009F1 83C402                   add  sp, 2
  1853 000009F4 08C0                     or  al, al
  1854 000009F6 0F840900                 je @@storeLabel94
  1855 000009FA 68[370A]                 push storeLabel_0
  1856 000009FD E8680E                   call error1
  1857 00000A00 83C402                   add  sp, 2
  1858                                  
  1859                                  ;-29   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1860                                  
  1861                                  @@storeLabel94:
  1862 00000A03 8D063075                 lea  ax, [Symbol]
  1863 00000A07 50                       push ax
  1864 00000A08 FF36[4F00]               push word [LabelNamePtr]
  1865 00000A0C E87D14                   call strcpy
  1866 00000A0F 83C404                   add  sp, 4
  1867 00000A12 A3[4F00]                 mov word [LabelNamePtr], ax
  1868                                  
  1869                                  ;-30   LabelNamePtr++;
  1870                                  
  1871 00000A15 FF06[4F00]               inc  word [LabelNamePtr]
  1872                                  
  1873                                  ;-31   LabelMaxIx++;
  1874                                  
  1875 00000A19 FF06[5100]               inc  word [LabelMaxIx]
  1876                                  
  1877                                  ;-32   LabelType[LabelMaxIx] = LabType;// 1=LABEL, 2=VARIABLE
  1878                                  
  1879 00000A1D 8A4604                   mov al, [bp+4]
  1880 00000A20 8B1E[5100]               mov bx, [LabelMaxIx]
  1881 00000A24 8887067B                 mov [LabelType+bx], al
  1882                                  
  1883                                  ;-33   LabelAddr[LabelMaxIx] = PC;
  1884                                  
  1885 00000A28 A1[3600]                 mov ax, [PC]
  1886 00000A2B 8B1E[5100]               mov bx, [LabelMaxIx]
  1887 00000A2F D1E3                     shl bx, 1
  1888 00000A31 89876A7B                 mov [LabelAddr+bx], ax
  1889                                  
  1890                                  ;-34 }
  1891                                  
  1892                                  
  1893                                  ;-35 int searchLabel(char searchType) {
  1894 00000A35 C9                       LEAVE
  1895 00000A36 C3                       ret
  1896                                  ; ENDP
  1897 00000A37 6475706C6963617465-     storeLabel_0 db "duplicate symbol",0
  1898 00000A40 2073796D626F6C00   
  1899                                  
  1900                                  searchLabel:  ; *** PROC ***
  1901                                  
  1902                                  ;-36   int LIx; char *p; int j;
  1903                                  
  1904                                  
  1905                                  ;-37   p = &LabelNames;
  1906                                  
  1907                                  ;Function : searchLabel, Number of local variables: 4
  1908                                  ;   # type sign width line used address name   list of local variables
  1909                                  ;  200 var sign byte    35 NULL bp+4    searchType
  1910                                  ;  201 var sign word    36 NULL bp-2    LIx
  1911                                  ;  202 ptr sign byte    36 NULL bp-4    p
  1912                                  ;  203 var sign word    36 NULL bp-6    j;
  1913 00000A48 C8060000                 ENTER  6,0
  1914 00000A4C B81E77                   mov ax, LabelNames
  1915 00000A4F 8946FC                   mov word [bp-4], ax
  1916                                  
  1917                                  ;-38   LIx=1;
  1918                                  
  1919 00000A52 66B801000000             mov eax, 1
  1920 00000A58 8946FE                   mov word [bp-2], ax
  1921                                  
  1922                                  ;-39   while (LIx <= LabelMaxIx) {
  1923                                  
  1924                                  @@searchLabel95:
  1925 00000A5B 8B46FE                   mov ax, [bp-2]
  1926 00000A5E 3B06[5100]               cmp ax, [LabelMaxIx]
  1927 00000A62 0F8F3700                 jg  @@searchLabel96
  1928                                  
  1929                                  ;-40     if (eqstr(p, Symbol)) return LIx;//and searchType
  1930                                  
  1931 00000A66 8D063075                 lea  ax, [Symbol]
  1932 00000A6A 50                       push ax
  1933 00000A6B FF76FC                   push word [bp-4]
  1934 00000A6E E80215                   call eqstr
  1935 00000A71 83C404                   add  sp, 4
  1936 00000A74 08C0                     or  al, al
  1937 00000A76 0F840600                 je @@searchLabel97
  1938 00000A7A 8B46FE                   mov ax, [bp-2]
  1939 00000A7D E92600                   jmp @@retn
  1940                                  
  1941                                  ;-41     j=strlen(p);
  1942                                  
  1943                                  @@searchLabel97:
  1944 00000A80 FF76FC                   push word [bp-4]
  1945 00000A83 E8DB13                   call strlen
  1946 00000A86 83C402                   add  sp, 2
  1947 00000A89 8946FA                   mov word [bp-6], ax
  1948                                  
  1949                                  ;-42     p=p+j; p++; LIx++;
  1950                                  
  1951 00000A8C 8B46FC                   mov ax, [bp-4]
  1952 00000A8F 0346FA                   add ax, [bp-6]
  1953 00000A92 8946FC                   mov word [bp-4], ax
  1954 00000A95 FF46FC                   inc  word [bp-4]
  1955 00000A98 FF46FE                   inc  word [bp-2]
  1956                                  
  1957                                  ;-43   }
  1958                                  
  1959                                  
  1960                                  ;-44   return 0;
  1961                                  
  1962 00000A9B EBBE                     jmp @@searchLabel95
  1963                                  @@searchLabel96:
  1964 00000A9D 66B800000000             mov eax, 0
  1965 00000AA3 E90000                   jmp @@retn
  1966                                  
  1967                                  ;-45 }
  1968                                  
  1969                                  
  1970                                  ;-46 int getVariable() { char c;
  1971                                  
  1972 00000AA6 C9                      @@retn: LEAVE
  1973 00000AA7 C3                       ret
  1974                                  ; ENDP
  1975                                  
  1976                                  getVariable:  ; *** PROC ***
  1977                                  
  1978                                  ;-47   storeLabel(VARIABLE);
  1979                                  
  1980                                  ;Function : getVariable, Number of local variables: 1
  1981                                  ;   # type sign width line used address name   list of local variables
  1982                                  ;  200 var sign byte    46 NULL bp-2    c;
  1983 00000AA8 C8020000                 ENTER  2,0
  1984 00000AAC 6A02                     push 2
  1985 00000AAE E833FF                   call storeLabel
  1986 00000AB1 83C402                   add  sp, 2
  1987                                  
  1988                                  ;-48   setTokeType(); if(TokeType==ALNUM) {// getName
  1989                                  
  1990 00000AB4 E8CEF6                   call setTokeType
  1991 00000AB7 A0[3B00]                 mov al, [TokeType]
  1992 00000ABA 3C02                     cmp al, 2
  1993 00000ABC 0F85D000                 jne @@getVariable98
  1994                                  
  1995                                  ;-49     lookCode();
  1996                                  
  1997 00000AC0 E8C00A                   call lookCode
  1998                                  
  1999                                  ;-50     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2000                                  
  2001 00000AC3 A1[3D00]                 mov ax, [CodeType]
  2002 00000AC6 3DC800                   cmp ax, 200
  2003 00000AC9 0F8D0900                 jge @@getVariable99
  2004 00000ACD 68[9B0B]                 push getVariable_0
  2005 00000AD0 E8C60E                   call errorexit
  2006 00000AD3 83C402                   add  sp, 2
  2007                                  
  2008                                  ;-51     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2009                                  
  2010                                  @@getVariable99:
  2011 00000AD6 A1[3D00]                 mov ax, [CodeType]
  2012 00000AD9 3DCF00                   cmp ax, 207
  2013 00000ADC 0F8E0900                 jle @@getVariable100
  2014 00000AE0 68[B30B]                 push getVariable_1
  2015 00000AE3 E8B30E                   call errorexit
  2016 00000AE6 83C402                   add  sp, 2
  2017                                  
  2018                                  ;-52     if (CodeType== 200) {// DB
  2019                                  
  2020                                  @@getVariable100:
  2021 00000AE9 A1[3D00]                 mov ax, [CodeType]
  2022 00000AEC 3DC800                   cmp ax, 200
  2023 00000AEF 0F856A00                 jne @@getVariable101
  2024                                  
  2025                                  ;-53       do { setTokeType();
  2026                                  
  2027                                  @@getVariable102:
  2028 00000AF3 E88FF6                   call setTokeType
  2029                                  
  2030                                  ;-54         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2031                                  
  2032 00000AF6 A0[3B00]                 mov al, [TokeType]
  2033 00000AF9 3C01                     cmp al, 1
  2034 00000AFB 0F850D00                 jne @@getVariable103
  2035 00000AFF FF36[2500]               push word [SymbolInt]
  2036 00000B03 E855FC                   call genCode8
  2037 00000B06 83C402                   add  sp, 2
  2038                                  
  2039                                  ;-55         else {
  2040                                  
  2041 00000B09 E94100                   jmp @@getVariable104
  2042                                  @@getVariable103:
  2043                                  
  2044                                  ;-56           skipBlank();
  2045                                  
  2046 00000B0C E87902                   call skipBlank
  2047                                  
  2048                                  ;-57           if (isToken('"')) {
  2049                                  
  2050 00000B0F 6A22                     push 34
  2051 00000B11 E8D8FB                   call isToken
  2052 00000B14 83C402                   add  sp, 2
  2053 00000B17 08C0                     or  al, al
  2054 00000B19 0F843000                 je @@getVariable105
  2055                                  
  2056                                  ;-58             do { c= *InputPtr;
  2057                                  
  2058                                  @@getVariable106:
  2059 00000B1D 8B1E[2700]               mov bx, [InputPtr]
  2060 00000B21 8A07                     mov al, [bx]
  2061 00000B23 B400                     mov ah, 0
  2062 00000B25 8846FE                   mov byte [bp-2], al
  2063                                  
  2064                                  ;-59               genCode8(c);
  2065                                  
  2066 00000B28 8A46FE                   mov al, byte [bp-2]
  2067 00000B2B B400                     mov ah, 0
  2068 00000B2D 50                       push ax
  2069 00000B2E E82AFC                   call genCode8
  2070 00000B31 83C402                   add  sp, 2
  2071                                  
  2072                                  ;-60               InputPtr++;
  2073                                  
  2074 00000B34 FF06[2700]               inc  word [InputPtr]
  2075                                  
  2076                                  ;-61             } while (*InputPtr != '"' );
  2077                                  
  2078 00000B38 8B1E[2700]               mov bx, [InputPtr]
  2079 00000B3C 8A07                     mov al, [bx]
  2080 00000B3E B400                     mov ah, 0
  2081 00000B40 83F822                   cmp ax, 34
  2082 00000B43 0F840200                 je  @@getVariable107
  2083 00000B47 EBD4                     jmp @@getVariable106
  2084                                  @@getVariable107:
  2085                                  
  2086                                  ;-62             InputPtr++;
  2087                                  
  2088 00000B49 FF06[2700]               inc  word [InputPtr]
  2089                                  
  2090                                  ;-63           }
  2091                                  
  2092                                  
  2093                                  ;-64         }
  2094                                  
  2095                                  @@getVariable105:
  2096                                  
  2097                                  ;-65       } while (isToken(','));
  2098                                  
  2099                                  @@getVariable104:
  2100 00000B4D 6A2C                     push 44
  2101 00000B4F E89AFB                   call isToken
  2102 00000B52 83C402                   add  sp, 2
  2103 00000B55 08C0                     or  al, al
  2104 00000B57 0F840200                 je @@getVariable108
  2105 00000B5B EB96                     jmp @@getVariable102
  2106                                  @@getVariable108:
  2107                                  
  2108                                  ;-66     }
  2109                                  
  2110                                  
  2111                                  ;-67     if (CodeType== 201) {// DW
  2112                                  
  2113                                  @@getVariable101:
  2114 00000B5D A1[3D00]                 mov ax, [CodeType]
  2115 00000B60 3DC900                   cmp ax, 201
  2116 00000B63 0F852600                 jne @@getVariable109
  2117                                  
  2118                                  ;-68       do { setTokeType();
  2119                                  
  2120                                  @@getVariable110:
  2121 00000B67 E81BF6                   call setTokeType
  2122                                  
  2123                                  ;-69         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2124                                  
  2125 00000B6A A0[3B00]                 mov al, [TokeType]
  2126 00000B6D 3C01                     cmp al, 1
  2127 00000B6F 0F850A00                 jne @@getVariable111
  2128 00000B73 FF36[2500]               push word [SymbolInt]
  2129 00000B77 E813FC                   call genCode16
  2130 00000B7A 83C402                   add  sp, 2
  2131                                  
  2132                                  ;-70       } while (isToken(','));
  2133                                  
  2134                                  @@getVariable111:
  2135 00000B7D 6A2C                     push 44
  2136 00000B7F E86AFB                   call isToken
  2137 00000B82 83C402                   add  sp, 2
  2138 00000B85 08C0                     or  al, al
  2139 00000B87 0F840200                 je @@getVariable112
  2140 00000B8B EBDA                     jmp @@getVariable110
  2141                                  @@getVariable112:
  2142                                  
  2143                                  ;-71     }
  2144                                  
  2145                                  
  2146                                  ;-72   }
  2147                                  
  2148                                  @@getVariable109:
  2149                                  
  2150                                  ;-73   else errorexit("DB,DW,DD or RESB,W,D expected");
  2151                                  
  2152 00000B8D E90900                   jmp @@getVariable113
  2153                                  @@getVariable98:
  2154 00000B90 68[CB0B]                 push getVariable_2
  2155 00000B93 E8030E                   call errorexit
  2156 00000B96 83C402                   add  sp, 2
  2157                                  
  2158                                  ;-74 }
  2159                                  
  2160                                  @@getVariable113:
  2161                                  
  2162                                  ;-75 // helper functions XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  2163                                  
  2164                                  
  2165                                  ;-76 int letterX(char c) {
  2166 00000B99 C9                       LEAVE
  2167 00000B9A C3                       ret
  2168                                  ; ENDP
  2169 00000B9B 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2170 00000BA4 422C572C4420657870-
  2171 00000BAD 656374656400       
  2172 00000BB3 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2173 00000BBC 422C572C4420657870-
  2174 00000BC5 656374656400       
  2175 00000BCB 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2176 00000BD4 6F7220524553422C57-
  2177 00000BDD 2C4420657870656374-
  2178 00000BE6 656400             
  2179                                  
  2180                                  letterX:  ; *** PROC ***
  2181                                  
  2182                                  ;-77   if (digit(c)) return 1;
  2183                                  
  2184                                  ;Function : letterX, Number of local variables: 1
  2185                                  ;   # type sign width line used address name   list of local variables
  2186                                  ;  200 var sign byte    76 NULL bp+4    c;
  2187 00000BE9 C8000000                 ENTER  0,0
  2188 00000BED 8A4604                   mov al, byte [bp+4]
  2189 00000BF0 B400                     mov ah, 0
  2190 00000BF2 50                       push ax
  2191 00000BF3 E8CF12                   call digit
  2192 00000BF6 83C402                   add  sp, 2
  2193 00000BF9 08C0                     or  al, al
  2194 00000BFB 0F840900                 je @@letterX114
  2195 00000BFF 66B801000000             mov eax, 1
  2196 00000C05 E96C00                   jmp @@retn
  2197                                  
  2198                                  ;-78   if (c=='_') return 1;
  2199                                  
  2200                                  @@letterX114:
  2201 00000C08 8A4604                   mov al, [bp+4]
  2202 00000C0B 3C5F                     cmp al, 95
  2203 00000C0D 0F850900                 jne @@letterX115
  2204 00000C11 66B801000000             mov eax, 1
  2205 00000C17 E95A00                   jmp @@retn
  2206                                  
  2207                                  ;-79   if (c=='.') return 1;
  2208                                  
  2209                                  @@letterX115:
  2210 00000C1A 8A4604                   mov al, [bp+4]
  2211 00000C1D 3C2E                     cmp al, 46
  2212 00000C1F 0F850900                 jne @@letterX116
  2213 00000C23 66B801000000             mov eax, 1
  2214 00000C29 E94800                   jmp @@retn
  2215                                  
  2216                                  ;-80   if (c> 'z') return 0;
  2217                                  
  2218                                  @@letterX116:
  2219 00000C2C 8A4604                   mov al, [bp+4]
  2220 00000C2F 3C7A                     cmp al, 122
  2221 00000C31 0F8E0900                 jle @@letterX117
  2222 00000C35 66B800000000             mov eax, 0
  2223 00000C3B E93600                   jmp @@retn
  2224                                  
  2225                                  ;-81   if (c< '@') return 0; // at included
  2226                                  
  2227                                  @@letterX117:
  2228 00000C3E 8A4604                   mov al, [bp+4]
  2229 00000C41 3C40                     cmp al, 64
  2230 00000C43 0F8D0900                 jge @@letterX118
  2231 00000C47 66B800000000             mov eax, 0
  2232 00000C4D E92400                   jmp @@retn
  2233                                  
  2234                                  ;-82   if (c> 'Z') { if (c< 'a') return 0; }
  2235                                  
  2236                                  @@letterX118:
  2237 00000C50 8A4604                   mov al, [bp+4]
  2238 00000C53 3C5A                     cmp al, 90
  2239 00000C55 0F8E1200                 jle @@letterX119
  2240 00000C59 8A4604                   mov al, [bp+4]
  2241 00000C5C 3C61                     cmp al, 97
  2242 00000C5E 0F8D0900                 jge @@letterX120
  2243 00000C62 66B800000000             mov eax, 0
  2244 00000C68 E90900                   jmp @@retn
  2245                                  @@letterX120:
  2246                                  
  2247                                  ;-83   return 1;
  2248                                  
  2249                                  @@letterX119:
  2250 00000C6B 66B801000000             mov eax, 1
  2251 00000C71 E90000                   jmp @@retn
  2252                                  
  2253                                  ;-84 }
  2254                                  
  2255                                  
  2256                                  ;-85 int alnumX(char c) {
  2257                                  
  2258 00000C74 C9                      @@retn: LEAVE
  2259 00000C75 C3                       ret
  2260                                  ; ENDP
  2261                                  
  2262                                  alnumX:  ; *** PROC ***
  2263                                  
  2264                                  ;-86   if (digit(c)) return 1;
  2265                                  
  2266                                  ;Function : alnumX, Number of local variables: 1
  2267                                  ;   # type sign width line used address name   list of local variables
  2268                                  ;  200 var sign byte    85 NULL bp+4    c;
  2269 00000C76 C8000000                 ENTER  0,0
  2270 00000C7A 8A4604                   mov al, byte [bp+4]
  2271 00000C7D B400                     mov ah, 0
  2272 00000C7F 50                       push ax
  2273 00000C80 E84212                   call digit
  2274 00000C83 83C402                   add  sp, 2
  2275 00000C86 08C0                     or  al, al
  2276 00000C88 0F840900                 je @@alnumX121
  2277 00000C8C 66B801000000             mov eax, 1
  2278 00000C92 E92400                   jmp @@retn
  2279                                  
  2280                                  ;-87   if (letterX(c)) return 1;
  2281                                  
  2282                                  @@alnumX121:
  2283 00000C95 8A4604                   mov al, byte [bp+4]
  2284 00000C98 B400                     mov ah, 0
  2285 00000C9A 50                       push ax
  2286 00000C9B E84BFF                   call letterX
  2287 00000C9E 83C402                   add  sp, 2
  2288 00000CA1 08C0                     or  al, al
  2289 00000CA3 0F840900                 je @@alnumX122
  2290 00000CA7 66B801000000             mov eax, 1
  2291 00000CAD E90900                   jmp @@retn
  2292                                  
  2293                                  ;-88   return 0; 
  2294                                  
  2295                                  @@alnumX122:
  2296 00000CB0 66B800000000             mov eax, 0
  2297 00000CB6 E90000                   jmp @@retn
  2298                                  
  2299                                  ;-89 }
  2300                                  
  2301                                  
  2302                                  ;-90 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2303                                  
  2304 00000CB9 C9                      @@retn: LEAVE
  2305 00000CBA C3                       ret
  2306                                  ; ENDP
  2307                                  
  2308                                  getLine:  ; *** PROC ***
  2309                                  
  2310                                  ;-91   InputPtr= &InputBuf;
  2311                                  
  2312 00000CBB B8D075                   mov ax, InputBuf
  2313 00000CBE A3[2700]                 mov word [InputPtr], ax
  2314                                  
  2315                                  ;-92   *InputPtr=0;//if last line is empty
  2316                                  
  2317 00000CC1 66B800000000             mov eax, 0
  2318 00000CC7 8B1E[2700]               mov  bx, [InputPtr]
  2319 00000CCB 8807                     mov  [bx], al
  2320                                  
  2321                                  ;-93   do {
  2322                                  
  2323                                  @@getLine123:
  2324                                  
  2325                                  ;-94     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2326                                  
  2327 00000CCD 6A01                     push 1
  2328 00000CCF FF36[2900]               push word [asm_fd]
  2329 00000CD3 8D06[3500]               lea  ax, [DOS_ByteRead]
  2330 00000CD7 50                       push ax
  2331 00000CD8 E83313                   call readRL
  2332 00000CDB 83C406                   add  sp, 6
  2333 00000CDE A3[3300]                 mov word [DOS_NoBytes], ax
  2334                                  
  2335                                  ;-95     if (DOS_ERR) errorexit("Reading Source");
  2336                                  
  2337 00000CE1 A1[2F00]                 mov ax, [DOS_ERR]
  2338 00000CE4 08C0                     or  al, al
  2339 00000CE6 0F840900                 je @@getLine124
  2340 00000CEA 68[320D]                 push getLine_0
  2341 00000CED E8A90C                   call errorexit
  2342 00000CF0 83C402                   add  sp, 2
  2343                                  
  2344                                  ;-96     if (DOS_NoBytes == 0) return;
  2345                                  
  2346                                  @@getLine124:
  2347 00000CF3 A1[3300]                 mov ax, [DOS_NoBytes]
  2348 00000CF6 83F800                   cmp ax, 0
  2349 00000CF9 0F850300                 jne @@getLine125
  2350 00000CFD E93100                   jmp @@retn
  2351                                  
  2352                                  ;-97     *InputPtr = DOS_ByteRead;
  2353                                  
  2354                                  @@getLine125:
  2355 00000D00 A0[3500]                 mov al, [DOS_ByteRead]
  2356 00000D03 8B1E[2700]               mov  bx, [InputPtr]
  2357 00000D07 8807                     mov  [bx], al
  2358                                  
  2359                                  ;-98     InputPtr++;
  2360                                  
  2361 00000D09 FF06[2700]               inc  word [InputPtr]
  2362                                  
  2363                                  ;-99   } while (ifEOL(DOS_ByteRead) == 0);
  2364                                  
  2365 00000D0D A0[3500]                 mov al, byte [DOS_ByteRead]
  2366 00000D10 B400                     mov ah, 0
  2367 00000D12 50                       push ax
  2368 00000D13 E82B00                   call ifEOL
  2369 00000D16 83C402                   add  sp, 2
  2370 00000D19 3C00                     cmp al, 0
  2371 00000D1B 0F850200                 jne @@getLine126
  2372 00000D1F EBAC                     jmp @@getLine123
  2373                                  @@getLine126:
  2374                                  
  2375                                  ;-100   InputPtr--;
  2376                                  
  2377 00000D21 FF0E[2700]               dec  word [InputPtr]
  2378                                  
  2379                                  ;-101   *InputPtr=0;
  2380                                  
  2381 00000D25 66B800000000             mov eax, 0
  2382 00000D2B 8B1E[2700]               mov  bx, [InputPtr]
  2383 00000D2F 8807                     mov  [bx], al
  2384                                  
  2385                                  ;-102 }
  2386                                  
  2387                                  
  2388                                  ;-103 int ifEOL(char c) {
  2389                                  
  2390                                  @@retn:
  2391 00000D31 C3                       ret
  2392                                  ; ENDP
  2393 00000D32 52656164696E672053-     getLine_0 db "Reading Source",0
  2394 00000D3B 6F7572636500       
  2395                                  
  2396                                  ifEOL:  ; *** PROC ***
  2397                                  
  2398                                  ;-104   if (c == 10) return 1;
  2399                                  
  2400                                  ;Function : ifEOL, Number of local variables: 1
  2401                                  ;   # type sign width line used address name   list of local variables
  2402                                  ;  200 var sign byte   103 NULL bp+4    c;
  2403 00000D41 C8000000                 ENTER  0,0
  2404 00000D45 8A4604                   mov al, [bp+4]
  2405 00000D48 3C0A                     cmp al, 10
  2406 00000D4A 0F850900                 jne @@ifEOL127
  2407 00000D4E 66B801000000             mov eax, 1
  2408 00000D54 E92F00                   jmp @@retn
  2409                                  
  2410                                  ;-105   if (c == 13) {
  2411                                  
  2412                                  @@ifEOL127:
  2413 00000D57 8A4604                   mov al, [bp+4]
  2414 00000D5A 3C0D                     cmp al, 13
  2415 00000D5C 0F851D00                 jne @@ifEOL128
  2416                                  
  2417                                  ;-106     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2418                                  
  2419 00000D60 6A01                     push 1
  2420 00000D62 FF36[2900]               push word [asm_fd]
  2421 00000D66 8D06[3500]               lea  ax, [DOS_ByteRead]
  2422 00000D6A 50                       push ax
  2423 00000D6B E8A012                   call readRL
  2424 00000D6E 83C406                   add  sp, 6
  2425 00000D71 A3[3300]                 mov word [DOS_NoBytes], ax
  2426                                  
  2427                                  ;-107     return 1;}
  2428                                  
  2429 00000D74 66B801000000             mov eax, 1
  2430 00000D7A E90900                   jmp @@retn
  2431                                  
  2432                                  ;-108   return 0;
  2433                                  
  2434                                  @@ifEOL128:
  2435 00000D7D 66B800000000             mov eax, 0
  2436 00000D83 E90000                   jmp @@retn
  2437                                  
  2438                                  ;-109 }
  2439                                  
  2440                                  
  2441                                  ;-110 int skipBlank() {
  2442                                  
  2443 00000D86 C9                      @@retn: LEAVE
  2444 00000D87 C3                       ret
  2445                                  ; ENDP
  2446                                  
  2447                                  skipBlank:  ; *** PROC ***
  2448                                  
  2449                                  ;-111   skipblank1:
  2450                                  
  2451                                  @@skipblank1:
  2452                                  
  2453                                  ;-112     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2454                                  
  2455 00000D88 8B1E[2700]               mov bx, [InputPtr]
  2456 00000D8C 8A07                     mov al, [bx]
  2457 00000D8E B400                     mov ah, 0
  2458 00000D90 83F820                   cmp ax, 32
  2459 00000D93 0F850600                 jne @@skipBlank129
  2460 00000D97 FF06[2700]               inc  word [InputPtr]
  2461 00000D9B EBEB                     jmp @@skipblank1
  2462                                  
  2463                                  ;-113     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2464                                  
  2465                                  @@skipBlank129:
  2466 00000D9D 8B1E[2700]               mov bx, [InputPtr]
  2467 00000DA1 8A07                     mov al, [bx]
  2468 00000DA3 B400                     mov ah, 0
  2469 00000DA5 83F809                   cmp ax, 9
  2470 00000DA8 0F850600                 jne @@skipBlank130
  2471 00000DAC FF06[2700]               inc  word [InputPtr]
  2472 00000DB0 EBD6                     jmp @@skipblank1
  2473                                  
  2474                                  ;-114 }
  2475                                  
  2476                                  @@skipBlank130:
  2477                                  
  2478                                  ;-115 int getDigit(unsigned char c) {//ret: SymbolInt
  2479                                  
  2480 00000DB2 C3                       ret
  2481                                  ; ENDP
  2482                                  
  2483                                  getDigit:  ; *** PROC ***
  2484                                  
  2485                                  ;-116   unsigned int CastInt;
  2486                                  
  2487                                  
  2488                                  ;-117   SymbolInt=0;
  2489                                  
  2490                                  ;Function : getDigit, Number of local variables: 2
  2491                                  ;   # type sign width line used address name   list of local variables
  2492                                  ;  200 var unsg byte   115 NULL bp+4    c
  2493                                  ;  201 var unsg word   116 NULL bp-2    CastInt;
  2494 00000DB3 C8020000                 ENTER  2,0
  2495 00000DB7 66B800000000             mov eax, 0
  2496 00000DBD A3[2500]                 mov word [SymbolInt], ax
  2497                                  
  2498                                  ;-118   do {
  2499                                  
  2500                                  @@getDigit131:
  2501                                  
  2502                                  ;-119     c-='0';
  2503                                  
  2504 00000DC0 806E0430                 sub  byte [bp+4], 48
  2505                                  
  2506                                  ;-120     SymbolInt=SymbolInt*10;
  2507                                  
  2508 00000DC4 A1[2500]                 mov ax, [SymbolInt]
  2509 00000DC7 66BB0A000000             mov ebx, 10
  2510 00000DCD 66F7E3                   mul ebx
  2511 00000DD0 A3[2500]                 mov word [SymbolInt], ax
  2512                                  
  2513                                  ;-121     ax=0; CastInt=c; //cast b2w
  2514                                  
  2515 00000DD3 B80000                   mov  ax, 0
  2516 00000DD6 8A4604                   mov al, [bp+4]
  2517 00000DD9 8946FE                   mov word [bp-2], ax
  2518                                  
  2519                                  ;-122     SymbolInt=SymbolInt+CastInt;
  2520                                  
  2521 00000DDC A1[2500]                 mov ax, [SymbolInt]
  2522 00000DDF 0346FE                   add ax, [bp-2]
  2523 00000DE2 A3[2500]                 mov word [SymbolInt], ax
  2524                                  
  2525                                  ;-123     InputPtr++;
  2526                                  
  2527 00000DE5 FF06[2700]               inc  word [InputPtr]
  2528                                  
  2529                                  ;-124     c = *InputPtr;
  2530                                  
  2531 00000DE9 8B1E[2700]               mov bx, [InputPtr]
  2532 00000DED 8A07                     mov al, [bx]
  2533 00000DEF B400                     mov ah, 0
  2534 00000DF1 884604                   mov byte [bp+4], al
  2535                                  
  2536                                  ;-125   } while(digit(c));
  2537                                  
  2538 00000DF4 8A4604                   mov al, byte [bp+4]
  2539 00000DF7 B400                     mov ah, 0
  2540 00000DF9 50                       push ax
  2541 00000DFA E8C810                   call digit
  2542 00000DFD 83C402                   add  sp, 2
  2543 00000E00 08C0                     or  al, al
  2544 00000E02 0F840200                 je @@getDigit132
  2545 00000E06 EBB8                     jmp @@getDigit131
  2546                                  @@getDigit132:
  2547                                  
  2548                                  ;-126 }
  2549                                  
  2550                                  
  2551                                  ;-127 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2552 00000E08 C9                       LEAVE
  2553 00000E09 C3                       ret
  2554                                  ; ENDP
  2555                                  
  2556                                  getName:  ; *** PROC ***
  2557                                  
  2558                                  ;-128   char *p;
  2559                                  
  2560                                  
  2561                                  ;-129   p = &Symbol;
  2562                                  
  2563                                  ;Function : getName, Number of local variables: 2
  2564                                  ;   # type sign width line used address name   list of local variables
  2565                                  ;  200 var unsg byte   127 NULL bp+4    c
  2566                                  ;  201 ptr sign byte   128 NULL bp-2    p;
  2567 00000E0A C8020000                 ENTER  2,0
  2568 00000E0E B83075                   mov ax, Symbol
  2569 00000E11 8946FE                   mov word [bp-2], ax
  2570                                  
  2571                                  ;-130   *p = c;
  2572                                  
  2573 00000E14 8A4604                   mov al, [bp+4]
  2574 00000E17 8B5EFE                   mov  bx, [bp-2]
  2575 00000E1A 8807                     mov  [bx], al
  2576                                  
  2577                                  ;-131   p++;
  2578                                  
  2579 00000E1C FF46FE                   inc  word [bp-2]
  2580                                  
  2581                                  ;-132   while (alnum(c)) {
  2582                                  
  2583                                  @@getName133:
  2584 00000E1F 8A4604                   mov al, byte [bp+4]
  2585 00000E22 B400                     mov ah, 0
  2586 00000E24 50                       push ax
  2587 00000E25 E8D010                   call alnum
  2588 00000E28 83C402                   add  sp, 2
  2589 00000E2B 08C0                     or  al, al
  2590 00000E2D 0F841C00                 je @@getName134
  2591                                  
  2592                                  ;-133     InputPtr++;
  2593                                  
  2594 00000E31 FF06[2700]               inc  word [InputPtr]
  2595                                  
  2596                                  ;-134     c = *InputPtr;
  2597                                  
  2598 00000E35 8B1E[2700]               mov bx, [InputPtr]
  2599 00000E39 8A07                     mov al, [bx]
  2600 00000E3B B400                     mov ah, 0
  2601 00000E3D 884604                   mov byte [bp+4], al
  2602                                  
  2603                                  ;-135     *p = c;
  2604                                  
  2605 00000E40 8A4604                   mov al, [bp+4]
  2606 00000E43 8B5EFE                   mov  bx, [bp-2]
  2607 00000E46 8807                     mov  [bx], al
  2608                                  
  2609                                  ;-136     p++;
  2610                                  
  2611 00000E48 FF46FE                   inc  word [bp-2]
  2612                                  
  2613                                  ;-137   }
  2614                                  
  2615                                  
  2616                                  ;-138   if (c == ':') isLabel=1; else isLabel=0;
  2617                                  
  2618 00000E4B EBD2                     jmp @@getName133
  2619                                  @@getName134:
  2620 00000E4D 8A4604                   mov al, [bp+4]
  2621 00000E50 3C3A                     cmp al, 58
  2622 00000E52 0F850C00                 jne @@getName135
  2623 00000E56 66B801000000             mov eax, 1
  2624 00000E5C A2[3A00]                 mov byte [isLabel], al
  2625 00000E5F E90900                   jmp @@getName136
  2626                                  @@getName135:
  2627 00000E62 66B800000000             mov eax, 0
  2628 00000E68 A2[3A00]                 mov byte [isLabel], al
  2629                                  
  2630                                  ;-139   p--;
  2631                                  
  2632                                  @@getName136:
  2633 00000E6B FF4EFE                   dec  word [bp-2]
  2634                                  
  2635                                  ;-140   *p = 0;
  2636                                  
  2637 00000E6E 66B800000000             mov eax, 0
  2638 00000E74 8B5EFE                   mov  bx, [bp-2]
  2639 00000E77 8807                     mov  [bx], al
  2640                                  
  2641                                  ;-141   strcpy(SymbolUpper, Symbol);
  2642                                  
  2643 00000E79 8D063075                 lea  ax, [Symbol]
  2644 00000E7D 50                       push ax
  2645 00000E7E 8D068075                 lea  ax, [SymbolUpper]
  2646 00000E82 50                       push ax
  2647 00000E83 E80610                   call strcpy
  2648 00000E86 83C404                   add  sp, 4
  2649                                  
  2650                                  ;-142   toupper(SymbolUpper);
  2651                                  
  2652 00000E89 8D068075                 lea  ax, [SymbolUpper]
  2653 00000E8D 50                       push ax
  2654 00000E8E E88D0F                   call toupper
  2655 00000E91 83C402                   add  sp, 2
  2656                                  
  2657                                  ;-143 }
  2658                                  
  2659                                  
  2660                                  ;-144 int testReg() {
  2661 00000E94 C9                       LEAVE
  2662 00000E95 C3                       ret
  2663                                  ; ENDP
  2664                                  
  2665                                  testReg:  ; *** PROC ***
  2666                                  
  2667                                  ;-145 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2668                                  
  2669                                  
  2670                                  ;-146   RegType=0;
  2671                                  
  2672 00000E96 66B800000000             mov eax, 0
  2673 00000E9C A2[3F00]                 mov byte [RegType], al
  2674                                  
  2675                                  ;-147   if (strlen(Symbol) < 2) return 0;
  2676                                  
  2677 00000E9F 8D063075                 lea  ax, [Symbol]
  2678 00000EA3 50                       push ax
  2679 00000EA4 E8BA0F                   call strlen
  2680 00000EA7 83C402                   add  sp, 2
  2681 00000EAA 3C02                     cmp al, 2
  2682 00000EAC 0F8D0900                 jge @@testReg137
  2683 00000EB0 66B800000000             mov eax, 0
  2684 00000EB6 E9B603                   jmp @@retn
  2685                                  
  2686                                  ;-148   if (strlen(Symbol) > 3) return 0;
  2687                                  
  2688                                  @@testReg137:
  2689 00000EB9 8D063075                 lea  ax, [Symbol]
  2690 00000EBD 50                       push ax
  2691 00000EBE E8A00F                   call strlen
  2692 00000EC1 83C402                   add  sp, 2
  2693 00000EC4 3C03                     cmp al, 3
  2694 00000EC6 0F8E0900                 jle @@testReg138
  2695 00000ECA 66B800000000             mov eax, 0
  2696 00000ED0 E99C03                   jmp @@retn
  2697                                  
  2698                                  ;-149   RegType=BYTE;
  2699                                  
  2700                                  @@testReg138:
  2701 00000ED3 66B801000000             mov eax, 1
  2702 00000ED9 A2[3F00]                 mov byte [RegType], al
  2703                                  
  2704                                  ;-150   if (eqstr(SymbolUpper, "AL")) return 0;
  2705                                  
  2706 00000EDC 68[7012]                 push testReg_0
  2707 00000EDF 8D068075                 lea  ax, [SymbolUpper]
  2708 00000EE3 50                       push ax
  2709 00000EE4 E88C10                   call eqstr
  2710 00000EE7 83C404                   add  sp, 4
  2711 00000EEA 08C0                     or  al, al
  2712 00000EEC 0F840900                 je @@testReg139
  2713 00000EF0 66B800000000             mov eax, 0
  2714 00000EF6 E97603                   jmp @@retn
  2715                                  
  2716                                  ;-151   if (eqstr(SymbolUpper, "CL")) return 1;
  2717                                  
  2718                                  @@testReg139:
  2719 00000EF9 68[7312]                 push testReg_1
  2720 00000EFC 8D068075                 lea  ax, [SymbolUpper]
  2721 00000F00 50                       push ax
  2722 00000F01 E86F10                   call eqstr
  2723 00000F04 83C404                   add  sp, 4
  2724 00000F07 08C0                     or  al, al
  2725 00000F09 0F840900                 je @@testReg140
  2726 00000F0D 66B801000000             mov eax, 1
  2727 00000F13 E95903                   jmp @@retn
  2728                                  
  2729                                  ;-152   if (eqstr(SymbolUpper, "DL")) return 2;
  2730                                  
  2731                                  @@testReg140:
  2732 00000F16 68[7612]                 push testReg_2
  2733 00000F19 8D068075                 lea  ax, [SymbolUpper]
  2734 00000F1D 50                       push ax
  2735 00000F1E E85210                   call eqstr
  2736 00000F21 83C404                   add  sp, 4
  2737 00000F24 08C0                     or  al, al
  2738 00000F26 0F840900                 je @@testReg141
  2739 00000F2A 66B802000000             mov eax, 2
  2740 00000F30 E93C03                   jmp @@retn
  2741                                  
  2742                                  ;-153   if (eqstr(SymbolUpper, "BL")) return 3;
  2743                                  
  2744                                  @@testReg141:
  2745 00000F33 68[7912]                 push testReg_3
  2746 00000F36 8D068075                 lea  ax, [SymbolUpper]
  2747 00000F3A 50                       push ax
  2748 00000F3B E83510                   call eqstr
  2749 00000F3E 83C404                   add  sp, 4
  2750 00000F41 08C0                     or  al, al
  2751 00000F43 0F840900                 je @@testReg142
  2752 00000F47 66B803000000             mov eax, 3
  2753 00000F4D E91F03                   jmp @@retn
  2754                                  
  2755                                  ;-154   if (eqstr(SymbolUpper, "AH")) return 4;
  2756                                  
  2757                                  @@testReg142:
  2758 00000F50 68[7C12]                 push testReg_4
  2759 00000F53 8D068075                 lea  ax, [SymbolUpper]
  2760 00000F57 50                       push ax
  2761 00000F58 E81810                   call eqstr
  2762 00000F5B 83C404                   add  sp, 4
  2763 00000F5E 08C0                     or  al, al
  2764 00000F60 0F840900                 je @@testReg143
  2765 00000F64 66B804000000             mov eax, 4
  2766 00000F6A E90203                   jmp @@retn
  2767                                  
  2768                                  ;-155   if (eqstr(SymbolUpper, "CH")) return 5;
  2769                                  
  2770                                  @@testReg143:
  2771 00000F6D 68[7F12]                 push testReg_5
  2772 00000F70 8D068075                 lea  ax, [SymbolUpper]
  2773 00000F74 50                       push ax
  2774 00000F75 E8FB0F                   call eqstr
  2775 00000F78 83C404                   add  sp, 4
  2776 00000F7B 08C0                     or  al, al
  2777 00000F7D 0F840900                 je @@testReg144
  2778 00000F81 66B805000000             mov eax, 5
  2779 00000F87 E9E502                   jmp @@retn
  2780                                  
  2781                                  ;-156   if (eqstr(SymbolUpper, "DH")) return 6;
  2782                                  
  2783                                  @@testReg144:
  2784 00000F8A 68[8212]                 push testReg_6
  2785 00000F8D 8D068075                 lea  ax, [SymbolUpper]
  2786 00000F91 50                       push ax
  2787 00000F92 E8DE0F                   call eqstr
  2788 00000F95 83C404                   add  sp, 4
  2789 00000F98 08C0                     or  al, al
  2790 00000F9A 0F840900                 je @@testReg145
  2791 00000F9E 66B806000000             mov eax, 6
  2792 00000FA4 E9C802                   jmp @@retn
  2793                                  
  2794                                  ;-157   if (eqstr(SymbolUpper, "BH")) return 7;
  2795                                  
  2796                                  @@testReg145:
  2797 00000FA7 68[8512]                 push testReg_7
  2798 00000FAA 8D068075                 lea  ax, [SymbolUpper]
  2799 00000FAE 50                       push ax
  2800 00000FAF E8C10F                   call eqstr
  2801 00000FB2 83C404                   add  sp, 4
  2802 00000FB5 08C0                     or  al, al
  2803 00000FB7 0F840900                 je @@testReg146
  2804 00000FBB 66B807000000             mov eax, 7
  2805 00000FC1 E9AB02                   jmp @@retn
  2806                                  
  2807                                  ;-158   RegType=WORD;
  2808                                  
  2809                                  @@testReg146:
  2810 00000FC4 66B802000000             mov eax, 2
  2811 00000FCA A2[3F00]                 mov byte [RegType], al
  2812                                  
  2813                                  ;-159   if (eqstr(SymbolUpper, "AX")) return 0;
  2814                                  
  2815 00000FCD 68[8812]                 push testReg_8
  2816 00000FD0 8D068075                 lea  ax, [SymbolUpper]
  2817 00000FD4 50                       push ax
  2818 00000FD5 E89B0F                   call eqstr
  2819 00000FD8 83C404                   add  sp, 4
  2820 00000FDB 08C0                     or  al, al
  2821 00000FDD 0F840900                 je @@testReg147
  2822 00000FE1 66B800000000             mov eax, 0
  2823 00000FE7 E98502                   jmp @@retn
  2824                                  
  2825                                  ;-160   if (eqstr(SymbolUpper, "CX")) return 1;
  2826                                  
  2827                                  @@testReg147:
  2828 00000FEA 68[8B12]                 push testReg_9
  2829 00000FED 8D068075                 lea  ax, [SymbolUpper]
  2830 00000FF1 50                       push ax
  2831 00000FF2 E87E0F                   call eqstr
  2832 00000FF5 83C404                   add  sp, 4
  2833 00000FF8 08C0                     or  al, al
  2834 00000FFA 0F840900                 je @@testReg148
  2835 00000FFE 66B801000000             mov eax, 1
  2836 00001004 E96802                   jmp @@retn
  2837                                  
  2838                                  ;-161   if (eqstr(SymbolUpper, "DX")) return 2;
  2839                                  
  2840                                  @@testReg148:
  2841 00001007 68[8E12]                 push testReg_10
  2842 0000100A 8D068075                 lea  ax, [SymbolUpper]
  2843 0000100E 50                       push ax
  2844 0000100F E8610F                   call eqstr
  2845 00001012 83C404                   add  sp, 4
  2846 00001015 08C0                     or  al, al
  2847 00001017 0F840900                 je @@testReg149
  2848 0000101B 66B802000000             mov eax, 2
  2849 00001021 E94B02                   jmp @@retn
  2850                                  
  2851                                  ;-162   if (eqstr(SymbolUpper, "BX")) return 3;
  2852                                  
  2853                                  @@testReg149:
  2854 00001024 68[9112]                 push testReg_11
  2855 00001027 8D068075                 lea  ax, [SymbolUpper]
  2856 0000102B 50                       push ax
  2857 0000102C E8440F                   call eqstr
  2858 0000102F 83C404                   add  sp, 4
  2859 00001032 08C0                     or  al, al
  2860 00001034 0F840900                 je @@testReg150
  2861 00001038 66B803000000             mov eax, 3
  2862 0000103E E92E02                   jmp @@retn
  2863                                  
  2864                                  ;-163   if (eqstr(SymbolUpper, "SP")) return 4;
  2865                                  
  2866                                  @@testReg150:
  2867 00001041 68[9412]                 push testReg_12
  2868 00001044 8D068075                 lea  ax, [SymbolUpper]
  2869 00001048 50                       push ax
  2870 00001049 E8270F                   call eqstr
  2871 0000104C 83C404                   add  sp, 4
  2872 0000104F 08C0                     or  al, al
  2873 00001051 0F840900                 je @@testReg151
  2874 00001055 66B804000000             mov eax, 4
  2875 0000105B E91102                   jmp @@retn
  2876                                  
  2877                                  ;-164   if (eqstr(SymbolUpper, "BP")) return 5;
  2878                                  
  2879                                  @@testReg151:
  2880 0000105E 68[9712]                 push testReg_13
  2881 00001061 8D068075                 lea  ax, [SymbolUpper]
  2882 00001065 50                       push ax
  2883 00001066 E80A0F                   call eqstr
  2884 00001069 83C404                   add  sp, 4
  2885 0000106C 08C0                     or  al, al
  2886 0000106E 0F840900                 je @@testReg152
  2887 00001072 66B805000000             mov eax, 5
  2888 00001078 E9F401                   jmp @@retn
  2889                                  
  2890                                  ;-165   if (eqstr(SymbolUpper, "SI")) return 6;
  2891                                  
  2892                                  @@testReg152:
  2893 0000107B 68[9A12]                 push testReg_14
  2894 0000107E 8D068075                 lea  ax, [SymbolUpper]
  2895 00001082 50                       push ax
  2896 00001083 E8ED0E                   call eqstr
  2897 00001086 83C404                   add  sp, 4
  2898 00001089 08C0                     or  al, al
  2899 0000108B 0F840900                 je @@testReg153
  2900 0000108F 66B806000000             mov eax, 6
  2901 00001095 E9D701                   jmp @@retn
  2902                                  
  2903                                  ;-166   if (eqstr(SymbolUpper, "DI")) return 7;
  2904                                  
  2905                                  @@testReg153:
  2906 00001098 68[9D12]                 push testReg_15
  2907 0000109B 8D068075                 lea  ax, [SymbolUpper]
  2908 0000109F 50                       push ax
  2909 000010A0 E8D00E                   call eqstr
  2910 000010A3 83C404                   add  sp, 4
  2911 000010A6 08C0                     or  al, al
  2912 000010A8 0F840900                 je @@testReg154
  2913 000010AC 66B807000000             mov eax, 7
  2914 000010B2 E9BA01                   jmp @@retn
  2915                                  
  2916                                  ;-167   RegType=SEGREG;
  2917                                  
  2918                                  @@testReg154:
  2919 000010B5 66B804000000             mov eax, 4
  2920 000010BB A2[3F00]                 mov byte [RegType], al
  2921                                  
  2922                                  ;-168   if (eqstr(SymbolUpper, "ES")) return 0;
  2923                                  
  2924 000010BE 68[A012]                 push testReg_16
  2925 000010C1 8D068075                 lea  ax, [SymbolUpper]
  2926 000010C5 50                       push ax
  2927 000010C6 E8AA0E                   call eqstr
  2928 000010C9 83C404                   add  sp, 4
  2929 000010CC 08C0                     or  al, al
  2930 000010CE 0F840900                 je @@testReg155
  2931 000010D2 66B800000000             mov eax, 0
  2932 000010D8 E99401                   jmp @@retn
  2933                                  
  2934                                  ;-169   if (eqstr(SymbolUpper, "CS")) return 1;
  2935                                  
  2936                                  @@testReg155:
  2937 000010DB 68[A312]                 push testReg_17
  2938 000010DE 8D068075                 lea  ax, [SymbolUpper]
  2939 000010E2 50                       push ax
  2940 000010E3 E88D0E                   call eqstr
  2941 000010E6 83C404                   add  sp, 4
  2942 000010E9 08C0                     or  al, al
  2943 000010EB 0F840900                 je @@testReg156
  2944 000010EF 66B801000000             mov eax, 1
  2945 000010F5 E97701                   jmp @@retn
  2946                                  
  2947                                  ;-170   if (eqstr(SymbolUpper, "SS")) return 2;
  2948                                  
  2949                                  @@testReg156:
  2950 000010F8 68[A612]                 push testReg_18
  2951 000010FB 8D068075                 lea  ax, [SymbolUpper]
  2952 000010FF 50                       push ax
  2953 00001100 E8700E                   call eqstr
  2954 00001103 83C404                   add  sp, 4
  2955 00001106 08C0                     or  al, al
  2956 00001108 0F840900                 je @@testReg157
  2957 0000110C 66B802000000             mov eax, 2
  2958 00001112 E95A01                   jmp @@retn
  2959                                  
  2960                                  ;-171   if (eqstr(SymbolUpper, "DS")) return 3;
  2961                                  
  2962                                  @@testReg157:
  2963 00001115 68[A912]                 push testReg_19
  2964 00001118 8D068075                 lea  ax, [SymbolUpper]
  2965 0000111C 50                       push ax
  2966 0000111D E8530E                   call eqstr
  2967 00001120 83C404                   add  sp, 4
  2968 00001123 08C0                     or  al, al
  2969 00001125 0F840900                 je @@testReg158
  2970 00001129 66B803000000             mov eax, 3
  2971 0000112F E93D01                   jmp @@retn
  2972                                  
  2973                                  ;-172   if (eqstr(SymbolUpper, "FS")) return 4;
  2974                                  
  2975                                  @@testReg158:
  2976 00001132 68[AC12]                 push testReg_20
  2977 00001135 8D068075                 lea  ax, [SymbolUpper]
  2978 00001139 50                       push ax
  2979 0000113A E8360E                   call eqstr
  2980 0000113D 83C404                   add  sp, 4
  2981 00001140 08C0                     or  al, al
  2982 00001142 0F840900                 je @@testReg159
  2983 00001146 66B804000000             mov eax, 4
  2984 0000114C E92001                   jmp @@retn
  2985                                  
  2986                                  ;-173   if (eqstr(SymbolUpper, "GS")) return 5;
  2987                                  
  2988                                  @@testReg159:
  2989 0000114F 68[AF12]                 push testReg_21
  2990 00001152 8D068075                 lea  ax, [SymbolUpper]
  2991 00001156 50                       push ax
  2992 00001157 E8190E                   call eqstr
  2993 0000115A 83C404                   add  sp, 4
  2994 0000115D 08C0                     or  al, al
  2995 0000115F 0F840900                 je @@testReg160
  2996 00001163 66B805000000             mov eax, 5
  2997 00001169 E90301                   jmp @@retn
  2998                                  
  2999                                  ;-174   RegType=DWORD;
  3000                                  
  3001                                  @@testReg160:
  3002 0000116C 66B803000000             mov eax, 3
  3003 00001172 A2[3F00]                 mov byte [RegType], al
  3004                                  
  3005                                  ;-175   if (eqstr(SymbolUpper, "EAX"))return 0;
  3006                                  
  3007 00001175 68[B212]                 push testReg_22
  3008 00001178 8D068075                 lea  ax, [SymbolUpper]
  3009 0000117C 50                       push ax
  3010 0000117D E8F30D                   call eqstr
  3011 00001180 83C404                   add  sp, 4
  3012 00001183 08C0                     or  al, al
  3013 00001185 0F840900                 je @@testReg161
  3014 00001189 66B800000000             mov eax, 0
  3015 0000118F E9DD00                   jmp @@retn
  3016                                  
  3017                                  ;-176   if (eqstr(SymbolUpper, "ECX"))return 1;
  3018                                  
  3019                                  @@testReg161:
  3020 00001192 68[B612]                 push testReg_23
  3021 00001195 8D068075                 lea  ax, [SymbolUpper]
  3022 00001199 50                       push ax
  3023 0000119A E8D60D                   call eqstr
  3024 0000119D 83C404                   add  sp, 4
  3025 000011A0 08C0                     or  al, al
  3026 000011A2 0F840900                 je @@testReg162
  3027 000011A6 66B801000000             mov eax, 1
  3028 000011AC E9C000                   jmp @@retn
  3029                                  
  3030                                  ;-177   if (eqstr(SymbolUpper, "EDX"))return 2;
  3031                                  
  3032                                  @@testReg162:
  3033 000011AF 68[BA12]                 push testReg_24
  3034 000011B2 8D068075                 lea  ax, [SymbolUpper]
  3035 000011B6 50                       push ax
  3036 000011B7 E8B90D                   call eqstr
  3037 000011BA 83C404                   add  sp, 4
  3038 000011BD 08C0                     or  al, al
  3039 000011BF 0F840900                 je @@testReg163
  3040 000011C3 66B802000000             mov eax, 2
  3041 000011C9 E9A300                   jmp @@retn
  3042                                  
  3043                                  ;-178   if (eqstr(SymbolUpper, "EBX"))return 3;
  3044                                  
  3045                                  @@testReg163:
  3046 000011CC 68[BE12]                 push testReg_25
  3047 000011CF 8D068075                 lea  ax, [SymbolUpper]
  3048 000011D3 50                       push ax
  3049 000011D4 E89C0D                   call eqstr
  3050 000011D7 83C404                   add  sp, 4
  3051 000011DA 08C0                     or  al, al
  3052 000011DC 0F840900                 je @@testReg164
  3053 000011E0 66B803000000             mov eax, 3
  3054 000011E6 E98600                   jmp @@retn
  3055                                  
  3056                                  ;-179   if (eqstr(SymbolUpper, "ESP"))return 4;
  3057                                  
  3058                                  @@testReg164:
  3059 000011E9 68[C212]                 push testReg_26
  3060 000011EC 8D068075                 lea  ax, [SymbolUpper]
  3061 000011F0 50                       push ax
  3062 000011F1 E87F0D                   call eqstr
  3063 000011F4 83C404                   add  sp, 4
  3064 000011F7 08C0                     or  al, al
  3065 000011F9 0F840900                 je @@testReg165
  3066 000011FD 66B804000000             mov eax, 4
  3067 00001203 E96900                   jmp @@retn
  3068                                  
  3069                                  ;-180   if (eqstr(SymbolUpper, "EBP"))return 5;
  3070                                  
  3071                                  @@testReg165:
  3072 00001206 68[C612]                 push testReg_27
  3073 00001209 8D068075                 lea  ax, [SymbolUpper]
  3074 0000120D 50                       push ax
  3075 0000120E E8620D                   call eqstr
  3076 00001211 83C404                   add  sp, 4
  3077 00001214 08C0                     or  al, al
  3078 00001216 0F840900                 je @@testReg166
  3079 0000121A 66B805000000             mov eax, 5
  3080 00001220 E94C00                   jmp @@retn
  3081                                  
  3082                                  ;-181   if (eqstr(SymbolUpper, "ESI"))return 6;
  3083                                  
  3084                                  @@testReg166:
  3085 00001223 68[CA12]                 push testReg_28
  3086 00001226 8D068075                 lea  ax, [SymbolUpper]
  3087 0000122A 50                       push ax
  3088 0000122B E8450D                   call eqstr
  3089 0000122E 83C404                   add  sp, 4
  3090 00001231 08C0                     or  al, al
  3091 00001233 0F840900                 je @@testReg167
  3092 00001237 66B806000000             mov eax, 6
  3093 0000123D E92F00                   jmp @@retn
  3094                                  
  3095                                  ;-182   if (eqstr(SymbolUpper, "EDI"))return 7;
  3096                                  
  3097                                  @@testReg167:
  3098 00001240 68[CE12]                 push testReg_29
  3099 00001243 8D068075                 lea  ax, [SymbolUpper]
  3100 00001247 50                       push ax
  3101 00001248 E8280D                   call eqstr
  3102 0000124B 83C404                   add  sp, 4
  3103 0000124E 08C0                     or  al, al
  3104 00001250 0F840900                 je @@testReg168
  3105 00001254 66B807000000             mov eax, 7
  3106 0000125A E91200                   jmp @@retn
  3107                                  
  3108                                  ;-183   RegType=0; return 0;
  3109                                  
  3110                                  @@testReg168:
  3111 0000125D 66B800000000             mov eax, 0
  3112 00001263 A2[3F00]                 mov byte [RegType], al
  3113 00001266 66B800000000             mov eax, 0
  3114 0000126C E90000                   jmp @@retn
  3115                                  
  3116                                  ;-184 }
  3117                                  
  3118                                  
  3119                                  ;-185 // opcodes XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  3120                                  
  3121                                  
  3122                                  ;-186 char I_START=0xF1;//OpName,0,CodeType,OpCode1,OpCodeN,F1h
  3123                                  
  3124                                  @@retn:
  3125 0000126F C3                       ret
  3126                                  ; ENDP
  3127 00001270 414C00                  testReg_0 db "AL",0
  3128 00001273 434C00                  testReg_1 db "CL",0
  3129 00001276 444C00                  testReg_2 db "DL",0
  3130 00001279 424C00                  testReg_3 db "BL",0
  3131 0000127C 414800                  testReg_4 db "AH",0
  3132 0000127F 434800                  testReg_5 db "CH",0
  3133 00001282 444800                  testReg_6 db "DH",0
  3134 00001285 424800                  testReg_7 db "BH",0
  3135 00001288 415800                  testReg_8 db "AX",0
  3136 0000128B 435800                  testReg_9 db "CX",0
  3137 0000128E 445800                  testReg_10 db "DX",0
  3138 00001291 425800                  testReg_11 db "BX",0
  3139 00001294 535000                  testReg_12 db "SP",0
  3140 00001297 425000                  testReg_13 db "BP",0
  3141 0000129A 534900                  testReg_14 db "SI",0
  3142 0000129D 444900                  testReg_15 db "DI",0
  3143 000012A0 455300                  testReg_16 db "ES",0
  3144 000012A3 435300                  testReg_17 db "CS",0
  3145 000012A6 535300                  testReg_18 db "SS",0
  3146 000012A9 445300                  testReg_19 db "DS",0
  3147 000012AC 465300                  testReg_20 db "FS",0
  3148 000012AF 475300                  testReg_21 db "GS",0
  3149 000012B2 45415800                testReg_22 db "EAX",0
  3150 000012B6 45435800                testReg_23 db "ECX",0
  3151 000012BA 45445800                testReg_24 db "EDX",0
  3152 000012BE 45425800                testReg_25 db "EBX",0
  3153 000012C2 45535000                testReg_26 db "ESP",0
  3154 000012C6 45425000                testReg_27 db "EBP",0
  3155 000012CA 45534900                testReg_28 db "ESI",0
  3156 000012CE 45444900                testReg_29 db "EDI",0
  3157 000012D2 F1                      I_START db 241
  3158                                  
  3159                                  ;-187 //  1:   1 byte opcode
  3160                                  
  3161                                  
  3162                                  ;-188 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
  3163                                  
  3164 000012D3 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
  3165                                  
  3166                                  ;-189 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
  3167                                  
  3168 000012DC 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
  3169                                  
  3170                                  ;-190 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
  3171                                  
  3172 000012E4 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
  3173                                  
  3174                                  ;-191 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
  3175                                  
  3176 000012EB 434257000198F1          I_CBW db 67,66,87,0,1,152,241
  3177                                  
  3178                                  ;-192 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
  3179                                  
  3180 000012F2 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
  3181                                  
  3182                                  ;-193 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
  3183                                  
  3184 000012FA 435744000199F1          I_CWD db 67,87,68,0,1,153,241
  3185                                  
  3186                                  ;-194 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
  3187                                  
  3188 00001301 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
  3189                                  
  3190                                  ;-195 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
  3191                                  
  3192 00001308 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
  3193                                  
  3194                                  ;-196 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
  3195                                  
  3196 00001310 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
  3197                                  
  3198                                  ;-197 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
  3199                                  
  3200 00001319 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
  3201                                  
  3202                                  ;-198 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
  3203                                  
  3204 00001321 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
  3205                                  
  3206                                  ;-199 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
  3207                                  
  3208 00001329 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
  3209                                  
  3210                                  ;-200 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
  3211                                  
  3212 00001331 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
  3213                                  
  3214                                  ;-201 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
  3215                                  
  3216 0000133A 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
  3217                                  
  3218                                  ;-202 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
  3219                                  
  3220 00001343 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
  3221                                  
  3222                                  ;-203 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
  3223                                  
  3224 0000134C 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
  3225                                  
  3226                                  ;-204 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
  3227                                  
  3228 00001355 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
  3229                                  
  3230                                  ;-205 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
  3231                                  
  3232 0000135E 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
  3233                                  
  3234                                  ;-206 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
  3235                                  
  3236 00001367 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
  3237                                  
  3238                                  ;-207 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
  3239                                  
  3240 00001370 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
  3241                                  
  3242                                  ;-208 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
  3243                                  
  3244 00001379 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
  3245                                  
  3246                                  ;-209 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
  3247                                  
  3248 00001382 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
  3249                                  
  3250                                  ;-210 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
  3251                                  
  3252 0000138B 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
  3253                                  
  3254                                  ;-211 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
  3255                                  
  3256 00001394 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
  3257                                  
  3258                                  ;-212 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
  3259                                  
  3260 0000139C 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
  3261                                  
  3262                                  ;-213 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
  3263                                  
  3264 000013A4 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
  3265                                  
  3266                                  ;-214 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
  3267                                  
  3268 000013AC 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
  3269                                  
  3270                                  ;-215 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
  3271                                  
  3272 000013B5 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
  3273                                  
  3274                                  ;-216 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
  3275                                  
  3276 000013BE 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
  3277                                  
  3278                                  ;-217 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
  3279                                  
  3280 000013C6 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
  3281                                  
  3282                                  ;-218 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
  3283                                  
  3284 000013CE 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
  3285                                  
  3286                                  ;-219 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
  3287                                  
  3288 000013D5 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
  3289                                  
  3290                                  ;-220 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
  3291                                  
  3292 000013DC 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
  3293                                  
  3294                                  ;-221 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
  3295                                  
  3296 000013E3 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
  3297                                  
  3298                                  ;-222 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
  3299                                  
  3300 000013EA 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
  3301                                  
  3302                                  ;-223 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
  3303                                  
  3304 000013F1 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
  3305                                  
  3306                                  ;-224 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
  3307                                  
  3308 000013F8 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
  3309                                  
  3310                                  ;-225 //  2: inc,dec
  3311                                  
  3312                                  
  3313                                  ;-226 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};
  3314                                  
  3315 000013FF 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
  3316                                  
  3317                                  ;-227 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};
  3318                                  
  3319 00001408 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
  3320                                  
  3321                                  ;-228 // 52: mem reg 16 bit
  3322                                  
  3323                                  
  3324                                  ;-229 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};
  3325                                  
  3326 00001411 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
  3327                                  
  3328                                  ;-230 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};
  3329                                  
  3330 00001419 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
  3331                                  
  3332                                  ;-231 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};
  3333                                  
  3334 00001421 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
  3335                                  
  3336                                  ;-232 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc
  3337                                  
  3338 00001429 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
  3339                                  
  3340                                  ;-233 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};
  3341                                  
  3342 00001432 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
  3343                                  
  3344                                  ;-234 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};
  3345                                  
  3346 0000143A 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
  3347                                  
  3348                                  ;-235 //  3: les, lda, lea
  3349                                  
  3350                                  
  3351                                  ;-236 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16
  3352                                  
  3353 00001443 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
  3354                                  
  3355                                  ;-237 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16
  3356                                  
  3357 0000144A 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
  3358                                  
  3359                                  ;-238 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16
  3360                                  
  3361 00001451 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
  3362                                  
  3363                                  ;-239 //  4: acc,imm  reg,imm  index,reg
  3364                                  
  3365                                  
  3366                                  ;-240 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};
  3367                                  
  3368 00001458 414444000400F1          I_ADD db 65,68,68,0,4,0,241
  3369                                  
  3370                                  ;-241 char I_OR []={'O','R',0,                4, 1,     0xF1};
  3371                                  
  3372 0000145F 4F52000401F1            I_OR db 79,82,0,4,1,241
  3373                                  
  3374                                  ;-242 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};
  3375                                  
  3376 00001465 414443000402F1          I_ADC db 65,68,67,0,4,2,241
  3377                                  
  3378                                  ;-243 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};
  3379                                  
  3380 0000146C 534242000403F1          I_SBB db 83,66,66,0,4,3,241
  3381                                  
  3382                                  ;-244 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};
  3383                                  
  3384 00001473 414E44000404F1          I_AND db 65,78,68,0,4,4,241
  3385                                  
  3386                                  ;-245 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};
  3387                                  
  3388 0000147A 535542000405F1          I_SUB db 83,85,66,0,4,5,241
  3389                                  
  3390                                  ;-246 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};
  3391                                  
  3392 00001481 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
  3393                                  
  3394                                  ;-247 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};
  3395                                  
  3396 00001488 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
  3397                                  
  3398                                  ;-248 //  5: mov
  3399                                  
  3400                                  
  3401                                  ;-249 char I_MOV[]={'M','O','V',0,            5,        0xF1};
  3402                                  
  3403 0000148F 4D4F560005F1            I_MOV db 77,79,86,0,5,241
  3404                                  
  3405                                  ;-250 //  6: single byte relative jump
  3406                                  
  3407                                  
  3408                                  ;-251 char I_JO []={'J','O',0,                6, 0,     0xF1};
  3409                                  
  3410 00001495 4A4F000600F1            I_JO db 74,79,0,6,0,241
  3411                                  
  3412                                  ;-252 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};
  3413                                  
  3414 0000149B 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
  3415                                  
  3416                                  ;-253 char I_JB []={'J','B',0,                6, 2,     0xF1};
  3417                                  
  3418 000014A2 4A42000602F1            I_JB db 74,66,0,6,2,241
  3419                                  
  3420                                  ;-254 char I_JC []={'J','C',0,                6, 2,     0xF1};
  3421                                  
  3422 000014A8 4A43000602F1            I_JC db 74,67,0,6,2,241
  3423                                  
  3424                                  ;-255 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};
  3425                                  
  3426 000014AE 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
  3427                                  
  3428                                  ;-256 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};
  3429                                  
  3430 000014B5 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
  3431                                  
  3432                                  ;-257 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};
  3433                                  
  3434 000014BC 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
  3435                                  
  3436                                  ;-258 char I_JE []={'J','E',0,                6, 4,     0xF1};//      74 je i8 rel
  3437                                  
  3438 000014C3 4A45000604F1            I_JE db 74,69,0,6,4,241
  3439                                  
  3440                                  ;-259 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//   0F 84 je i16 rel
  3441                                  
  3442 000014C9 4A5A000604F1            I_JZ db 74,90,0,6,4,241
  3443                                  
  3444                                  ;-260 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//66 0F 84 je i32 rel
  3445                                  
  3446 000014CF 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
  3447                                  
  3448                                  ;-261 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};
  3449                                  
  3450 000014D6 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
  3451                                  
  3452                                  ;-262 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};
  3453                                  
  3454 000014DD 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
  3455                                  
  3456                                  ;-263 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};
  3457                                  
  3458 000014E4 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
  3459                                  
  3460                                  ;-264 char I_JA []={'J','A',0,                6, 7,     0xF1};
  3461                                  
  3462 000014EB 4A41000607F1            I_JA db 74,65,0,6,7,241
  3463                                  
  3464                                  ;-265 char I_JS []={'J','S',0,                6, 8,     0xF1};
  3465                                  
  3466 000014F1 4A53000608F1            I_JS db 74,83,0,6,8,241
  3467                                  
  3468                                  ;-266 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};
  3469                                  
  3470 000014F7 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
  3471                                  
  3472                                  ;-267 char I_JP[]={'J','P',0,                 6,10,     0xF1};
  3473                                  
  3474 000014FE 4A5000060AF1            I_JP db 74,80,0,6,10,241
  3475                                  
  3476                                  ;-268 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};
  3477                                  
  3478 00001504 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
  3479                                  
  3480                                  ;-269 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};
  3481                                  
  3482 0000150B 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
  3483                                  
  3484                                  ;-270 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};
  3485                                  
  3486 00001512 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
  3487                                  
  3488                                  ;-271 char I_JL[]={'J','L',0,                 6,12,     0xF1};
  3489                                  
  3490 00001519 4A4C00060CF1            I_JL db 74,76,0,6,12,241
  3491                                  
  3492                                  ;-272 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};
  3493                                  
  3494 0000151F 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
  3495                                  
  3496                                  ;-273 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};
  3497                                  
  3498 00001526 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
  3499                                  
  3500                                  ;-274 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};
  3501                                  
  3502 0000152D 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
  3503                                  
  3504                                  ;-275 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};
  3505                                  
  3506 00001534 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
  3507                                  
  3508                                  ;-276 char I_JG []={'J','G',0,                6,15,     0xF1};
  3509                                  
  3510 0000153B 4A4700060FF1            I_JG db 74,71,0,6,15,241
  3511                                  
  3512                                  ;-277 //  8: ret
  3513                                  
  3514                                  
  3515                                  ;-278 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
  3516                                  
  3517 00001541 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
  3518                                  
  3519                                  ;-279 //  9: seg, r/m
  3520                                  
  3521                                  
  3522                                  ;-280 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16
  3523                                  
  3524 00001549 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
  3525                                  
  3526                                  ;-281 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16
  3527                                  
  3528 00001551 504F50000958F1          I_POP db 80,79,80,0,9,88,241
  3529                                  
  3530                                  ;-282 //  100 directives
  3531                                  
  3532                                  
  3533                                  ;-283 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
  3534                                  
  3535 00001558 4F52470065F1            I_ORG db 79,82,71,0,101,241
  3536                                  
  3537                                  ;-284 char I_DB[]=   {'D','B',0,            200,        0xF1};
  3538                                  
  3539 0000155E 444200C8F1              I_DB db 68,66,0,200,241
  3540                                  
  3541                                  ;-285 char I_DW[]=   {'D','W',0,            201,        0xF1};
  3542                                  
  3543 00001563 445700C9F1              I_DW db 68,87,0,201,241
  3544                                  
  3545                                  ;-286 char I_DD[]=   {'D','D',0,            202,        0xF1};
  3546                                  
  3547 00001568 444400CAF1              I_DD db 68,68,0,202,241
  3548                                  
  3549                                  ;-287 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
  3550                                  
  3551 0000156D 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
  3552                                  
  3553                                  ;-288 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
  3554                                  
  3555 00001574 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
  3556                                  
  3557                                  ;-289 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
  3558                                  
  3559 0000157B 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
  3560                                  
  3561                                  ;-290 char I_END=0;// end of table char
  3562                                  
  3563 00001582 00                      I_END db 0
  3564                                  
  3565                                  ;-291 
  3566                                  
  3567                                  
  3568                                  ;-292 int lookCode() { // ret: CodeType, OpCodePtr
  3569                                  
  3570                                  
  3571                                  lookCode:  ; *** PROC ***
  3572                                  
  3573                                  ;-293   CodeType=0;
  3574                                  
  3575 00001583 66B800000000             mov eax, 0
  3576 00001589 A3[3D00]                 mov word [CodeType], ax
  3577                                  
  3578                                  ;-294   OpCodePtr= &I_START;
  3579                                  
  3580 0000158C B8[D212]                 mov ax, I_START
  3581 0000158F A3[4C00]                 mov word [OpCodePtr], ax
  3582                                  
  3583                                  ;-295   OpCodePtr++;
  3584                                  
  3585 00001592 FF06[4C00]               inc  word [OpCodePtr]
  3586                                  
  3587                                  ;-296   do  {
  3588                                  
  3589                                  @@lookCode169:
  3590                                  
  3591                                  ;-297     if (eqstr(SymbolUpper, OpCodePtr))  {
  3592                                  
  3593 00001596 FF36[4C00]               push word [OpCodePtr]
  3594 0000159A 8D068075                 lea  ax, [SymbolUpper]
  3595 0000159E 50                       push ax
  3596 0000159F E8D109                   call eqstr
  3597 000015A2 83C404                   add  sp, 4
  3598 000015A5 08C0                     or  al, al
  3599 000015A7 0F842700                 je @@lookCode170
  3600                                  
  3601                                  ;-298       while(*OpCodePtr!=0) OpCodePtr++;
  3602                                  
  3603                                  @@lookCode171:
  3604 000015AB 8B1E[4C00]               mov bx, [OpCodePtr]
  3605 000015AF 8A07                     mov al, [bx]
  3606 000015B1 B400                     mov ah, 0
  3607 000015B3 83F800                   cmp ax, 0
  3608 000015B6 0F840600                 je  @@lookCode172
  3609 000015BA FF06[4C00]               inc  word [OpCodePtr]
  3610                                  
  3611                                  ;-299       OpCodePtr++; CodeType =*OpCodePtr;
  3612                                  
  3613 000015BE EBEB                     jmp @@lookCode171
  3614                                  @@lookCode172:
  3615 000015C0 FF06[4C00]               inc  word [OpCodePtr]
  3616 000015C4 8B1E[4C00]               mov bx, [OpCodePtr]
  3617 000015C8 8A07                     mov al, [bx]
  3618 000015CA B400                     mov ah, 0
  3619 000015CC A3[3D00]                 mov word [CodeType], ax
  3620                                  
  3621                                  ;-300       return;
  3622                                  
  3623 000015CF E92A00                   jmp @@retn
  3624                                  
  3625                                  ;-301     }
  3626                                  
  3627                                  
  3628                                  ;-302   while(*OpCodePtr!=0xF1) OpCodePtr++;
  3629                                  
  3630                                  @@lookCode170:
  3631                                  @@lookCode173:
  3632 000015D2 8B1E[4C00]               mov bx, [OpCodePtr]
  3633 000015D6 8A07                     mov al, [bx]
  3634 000015D8 B400                     mov ah, 0
  3635 000015DA 3DF100                   cmp ax, 241
  3636 000015DD 0F840600                 je  @@lookCode174
  3637 000015E1 FF06[4C00]               inc  word [OpCodePtr]
  3638                                  
  3639                                  ;-303   OpCodePtr++;
  3640                                  
  3641 000015E5 EBEB                     jmp @@lookCode173
  3642                                  @@lookCode174:
  3643 000015E7 FF06[4C00]               inc  word [OpCodePtr]
  3644                                  
  3645                                  ;-304   } while(*OpCodePtr!=0);
  3646                                  
  3647 000015EB 8B1E[4C00]               mov bx, [OpCodePtr]
  3648 000015EF 8A07                     mov al, [bx]
  3649 000015F1 B400                     mov ah, 0
  3650 000015F3 83F800                   cmp ax, 0
  3651 000015F6 0F840200                 je  @@lookCode175
  3652 000015FA EB9A                     jmp @@lookCode169
  3653                                  @@lookCode175:
  3654                                  
  3655                                  ;-305 }
  3656                                  
  3657                                  
  3658                                  ;-306 // string functions error epilog XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  3659                                  
  3660                                  
  3661                                  ;-307 int printLine() { int i; char c;
  3662                                  
  3663                                  @@retn:
  3664 000015FC C3                       ret
  3665                                  ; ENDP
  3666                                  
  3667                                  printLine:  ; *** PROC ***
  3668                                  
  3669                                  ;-308   prs("\n"); printhex16(PCStart);
  3670                                  
  3671                                  ;Function : printLine, Number of local variables: 2
  3672                                  ;   # type sign width line used address name   list of local variables
  3673                                  ;  200 var sign word   307 NULL bp-2    i
  3674                                  ;  201 var sign byte   307 NULL bp-4    c;
  3675 000015FD C8040000                 ENTER  4,0
  3676 00001601 68[9216]                 push printLine_0
  3677 00001604 E80401                   call prs
  3678 00001607 83C402                   add  sp, 2
  3679 0000160A FF36[3800]               push word [PCStart]
  3680 0000160E E8EB01                   call printhex16
  3681 00001611 83C402                   add  sp, 2
  3682                                  
  3683                                  ;-309   if (OpPrintIndex == 0) prs("                ");
  3684                                  
  3685 00001614 A1[4A00]                 mov ax, [OpPrintIndex]
  3686 00001617 83F800                   cmp ax, 0
  3687 0000161A 0F850C00                 jne @@printLine176
  3688 0000161E 68[9516]                 push printLine_1
  3689 00001621 E8E700                   call prs
  3690 00001624 83C402                   add  sp, 2
  3691                                  
  3692                                  ;-310   else {
  3693                                  
  3694 00001627 E95B00                   jmp @@printLine177
  3695                                  @@printLine176:
  3696                                  
  3697                                  ;-311     prc(PrReloc);
  3698                                  
  3699 0000162A A0[4E00]                 mov al, byte [PrReloc]
  3700 0000162D B400                     mov ah, 0
  3701 0000162F 50                       push ax
  3702 00001630 E87700                   call prc
  3703 00001633 83C402                   add  sp, 2
  3704                                  
  3705                                  ;-312     i=0;
  3706                                  
  3707 00001636 66B800000000             mov eax, 0
  3708 0000163C 8946FE                   mov word [bp-2], ax
  3709                                  
  3710                                  ;-313     do {
  3711                                  
  3712                                  @@printLine178:
  3713                                  
  3714                                  ;-314       c=OpPos[i];
  3715                                  
  3716 0000163F 8B5EFE                   mov bx, [bp-2]
  3717 00001642 8A871977                 mov al, [OpPos + bx]
  3718 00001646 8846FC                   mov byte [bp-4], al
  3719                                  
  3720                                  ;-315       printhex8a(c); prc(' ');
  3721                                  
  3722 00001649 8A46FC                   mov al, byte [bp-4]
  3723 0000164C B400                     mov ah, 0
  3724 0000164E 50                       push ax
  3725 0000164F E85C01                   call printhex8a
  3726 00001652 83C402                   add  sp, 2
  3727 00001655 6A20                     push 32
  3728 00001657 E85000                   call prc
  3729 0000165A 83C402                   add  sp, 2
  3730                                  
  3731                                  ;-316       i++;
  3732                                  
  3733 0000165D FF46FE                   inc  word [bp-2]
  3734                                  
  3735                                  ;-317     } while(i < OpPrintIndex);
  3736                                  
  3737 00001660 8B46FE                   mov ax, [bp-2]
  3738 00001663 3B06[4A00]               cmp ax, [OpPrintIndex]
  3739 00001667 0F8D0200                 jge @@printLine179
  3740 0000166B EBD2                     jmp @@printLine178
  3741                                  @@printLine179:
  3742                                  
  3743                                  ;-318     do {// fill rest with blank
  3744                                  
  3745                                  @@printLine180:
  3746                                  
  3747                                  ;-319       prs("   ");
  3748                                  
  3749 0000166D 68[A616]                 push printLine_2
  3750 00001670 E89800                   call prs
  3751 00001673 83C402                   add  sp, 2
  3752                                  
  3753                                  ;-320       i++;
  3754                                  
  3755 00001676 FF46FE                   inc  word [bp-2]
  3756                                  
  3757                                  ;-321     } while(i < OPMAXLEN);
  3758                                  
  3759 00001679 8B46FE                   mov ax, [bp-2]
  3760 0000167C 83F805                   cmp ax, 5
  3761 0000167F 0F8D0200                 jge @@printLine181
  3762 00001683 EBE8                     jmp @@printLine180
  3763                                  @@printLine181:
  3764                                  
  3765                                  ;-322   }
  3766                                  
  3767                                  
  3768                                  ;-323   prscomment(InputBuf);
  3769                                  
  3770                                  @@printLine177:
  3771 00001685 8D06D075                 lea  ax, [InputBuf]
  3772 00001689 50                       push ax
  3773 0000168A E85000                   call prscomment
  3774 0000168D 83C402                   add  sp, 2
  3775                                  
  3776                                  ;-324 }
  3777                                  
  3778                                  
  3779                                  ;-325 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  3780 00001690 C9                       LEAVE
  3781 00001691 C3                       ret
  3782                                  ; ENDP
  3783 00001692 5C6E00                  printLine_0 db "\n",0
  3784 00001695 202020202020202020-     printLine_1 db "                ",0
  3785 0000169E 2020202020202000   
  3786 000016A6 20202000                printLine_2 db "   ",0
  3787                                  
  3788                                  prc:  ; *** PROC ***
  3789                                  ;Function : prc, Number of local variables: 1
  3790                                  ;   # type sign width line used address name   list of local variables
  3791                                  ;  200 var unsg byte   325 NULL bp+4    c;
  3792 000016AA C8000000                 ENTER  0,0
  3793 000016AE A0[2400]                 mov al, [LIST]
  3794 000016B1 08C0                     or  al, al
  3795 000016B3 0F841400                 je @@prc182
  3796 000016B7 807E040A                cmp byte [bp+4], 10
  3797 000016BB 0F850600                 jne @@prc183
  3798 000016BF B80D00                   mov  ax, 13
  3799 000016C2 E82307                   call writetty
  3800                                  
  3801                                  ;-326      al=c; writetty(); }
  3802                                  
  3803                                  @@prc183:
  3804 000016C5 8A4604                   mov  al, [bp+4]
  3805 000016C8 E81D07                   call writetty
  3806                                  
  3807                                  ;-327    fputcR(c,lst_fd); }
  3808                                  
  3809                                  @@prc182:
  3810 000016CB FF36[2B00]               push word [lst_fd]
  3811 000016CF 8A4604                   mov al, byte [bp+4]
  3812 000016D2 B400                     mov ah, 0
  3813 000016D4 50                       push ax
  3814 000016D5 E84B09                   call fputcR
  3815 000016D8 83C404                   add  sp, 4
  3816                                  
  3817                                  ;-328 
  3818                                  
  3819                                  
  3820                                  ;-329 int prscomment(unsigned char *s) {unsigned char c;
  3821 000016DB C9                       LEAVE
  3822 000016DC C3                       ret
  3823                                  ; ENDP
  3824                                  
  3825                                  prscomment:  ; *** PROC ***
  3826                                  
  3827                                  ;-330   while(*s){c=*s;prc(c);s++;}
  3828                                  
  3829                                  ;Function : prscomment, Number of local variables: 2
  3830                                  ;   # type sign width line used address name   list of local variables
  3831                                  ;  200 ptr unsg byte   329 NULL bp+4    s
  3832                                  ;  201 var unsg byte   329 NULL bp-2    c;
  3833 000016DD C8020000                 ENTER  2,0
  3834                                  @@prscomment184:
  3835 000016E1 8B5E04                   mov bx, [bp+4]
  3836 000016E4 8A07                     mov al, [bx]
  3837 000016E6 B400                     mov ah, 0
  3838 000016E8 08C0                     or  al, al
  3839 000016EA 0F841B00                 je @@prscomment185
  3840 000016EE 8B5E04                   mov bx, [bp+4]
  3841 000016F1 8A07                     mov al, [bx]
  3842 000016F3 B400                     mov ah, 0
  3843 000016F5 8846FE                   mov byte [bp-2], al
  3844 000016F8 8A46FE                   mov al, byte [bp-2]
  3845 000016FB B400                     mov ah, 0
  3846 000016FD 50                       push ax
  3847 000016FE E8A9FF                   call prc
  3848 00001701 83C402                   add  sp, 2
  3849 00001704 FF4604                   inc  word [bp+4]
  3850                                  
  3851                                  ;-331 }
  3852                                  
  3853 00001707 EBD8                     jmp @@prscomment184
  3854                                  @@prscomment185:
  3855                                  
  3856                                  ;-332 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3857 00001709 C9                       LEAVE
  3858 0000170A C3                       ret
  3859                                  ; ENDP
  3860                                  
  3861                                  prs:  ; *** PROC ***
  3862                                  ;Function : prs, Number of local variables: 3
  3863                                  ;   # type sign width line used address name   list of local variables
  3864                                  ;  200 ptr unsg byte   332 NULL bp+4    s
  3865                                  ;  201 var unsg byte   332 NULL bp-2    c
  3866                                  ;  202 var sign word   332 NULL bp-4    com;
  3867 0000170B C8040000                 ENTER  4,0
  3868 0000170F 66B800000000             mov eax, 0
  3869 00001715 8946FC                   mov word [bp-4], ax
  3870                                  
  3871                                  ;-333   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3872                                  
  3873                                  @@prs186:
  3874 00001718 8B5E04                   mov bx, [bp+4]
  3875 0000171B 8A07                     mov al, [bx]
  3876 0000171D B400                     mov ah, 0
  3877 0000171F 08C0                     or  al, al
  3878 00001721 0F848700                 je @@prs187
  3879 00001725 8B5E04                   mov bx, [bp+4]
  3880 00001728 8A07                     mov al, [bx]
  3881 0000172A B400                     mov ah, 0
  3882 0000172C 8846FE                   mov byte [bp-2], al
  3883 0000172F 8A46FE                   mov al, [bp-2]
  3884 00001732 3C22                     cmp al, 34
  3885 00001734 0F851E00                 jne @@prs188
  3886 00001738 8B46FC                   mov ax, [bp-4]
  3887 0000173B 08C0                     or  al, al
  3888 0000173D 0F840C00                 je @@prs189
  3889 00001741 66B800000000             mov eax, 0
  3890 00001747 8946FC                   mov word [bp-4], ax
  3891 0000174A E90900                   jmp @@prs190
  3892                                  @@prs189:
  3893 0000174D 66B801000000             mov eax, 1
  3894 00001753 8946FC                   mov word [bp-4], ax
  3895                                  
  3896                                  ;-334     if (c==92) { if (com==0) { s++; c=*s;
  3897                                  
  3898                                  @@prs190:
  3899                                  @@prs188:
  3900 00001756 8A46FE                   mov al, [bp-2]
  3901 00001759 3C5C                     cmp al, 92
  3902 0000175B 0F853B00                 jne @@prs191
  3903 0000175F 8B46FC                   mov ax, [bp-4]
  3904 00001762 83F800                   cmp ax, 0
  3905 00001765 0F853100                 jne @@prs192
  3906 00001769 FF4604                   inc  word [bp+4]
  3907 0000176C 8B5E04                   mov bx, [bp+4]
  3908 0000176F 8A07                     mov al, [bx]
  3909 00001771 B400                     mov ah, 0
  3910 00001773 8846FE                   mov byte [bp-2], al
  3911                                  
  3912                                  ;-335           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3913                                  
  3914 00001776 8A46FE                   mov al, [bp-2]
  3915 00001779 3C6E                     cmp al, 110
  3916 0000177B 0F850900                 jne @@prs193
  3917 0000177F 66B80A000000             mov eax, 10
  3918 00001785 8846FE                   mov byte [bp-2], al
  3919                                  @@prs193:
  3920 00001788 8A46FE                   mov al, [bp-2]
  3921 0000178B 3C74                     cmp al, 116
  3922 0000178D 0F850900                 jne @@prs194
  3923 00001791 66B809000000             mov eax, 9
  3924 00001797 8846FE                   mov byte [bp-2], al
  3925                                  @@prs194:
  3926                                  @@prs192:
  3927                                  @@prs191:
  3928 0000179A 8A46FE                   mov al, byte [bp-2]
  3929 0000179D B400                     mov ah, 0
  3930 0000179F 50                       push ax
  3931 000017A0 E807FF                   call prc
  3932 000017A3 83C402                   add  sp, 2
  3933 000017A6 FF4604                   inc  word [bp+4]
  3934                                  
  3935                                  ;-336 }
  3936                                  
  3937 000017A9 E96CFF                   jmp @@prs186
  3938                                  @@prs187:
  3939                                  
  3940                                  ;-337 int printhex8a(unsigned int c) { unsigned int nib;
  3941 000017AC C9                       LEAVE
  3942 000017AD C3                       ret
  3943                                  ; ENDP
  3944                                  
  3945                                  printhex8a:  ; *** PROC ***
  3946                                  
  3947                                  ;-338   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3948                                  
  3949                                  ;Function : printhex8a, Number of local variables: 2
  3950                                  ;   # type sign width line used address name   list of local variables
  3951                                  ;  200 var unsg word   337 NULL bp+4    c
  3952                                  ;  201 var unsg word   337 NULL bp-2    nib;
  3953 000017AE C8020000                 ENTER  2,0
  3954 000017B2 8B4604                   mov ax, [bp+4]
  3955 000017B5 C1E804                   shr ax, 4
  3956 000017B8 8946FE                   mov word [bp-2], ax
  3957 000017BB 8346FE30                 add  word [bp-2], 48
  3958 000017BF 8B46FE                   mov ax, [bp-2]
  3959 000017C2 83F839                   cmp ax, 57
  3960 000017C5 0F8E0400                 jle @@printhex8a195
  3961 000017C9 8346FE07                 add  word [bp-2], 7
  3962                                  @@printhex8a195:
  3963 000017CD FF76FE                   push word [bp-2]
  3964 000017D0 E8D7FE                   call prc
  3965 000017D3 83C402                   add  sp, 2
  3966                                  
  3967                                  ;-339   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3968                                  
  3969 000017D6 8B4604                   mov ax, [bp+4]
  3970 000017D9 83E00F                   and ax, 15
  3971 000017DC 8946FE                   mov word [bp-2], ax
  3972 000017DF 8346FE30                 add  word [bp-2], 48
  3973 000017E3 8B46FE                   mov ax, [bp-2]
  3974 000017E6 83F839                   cmp ax, 57
  3975 000017E9 0F8E0400                 jle @@printhex8a196
  3976 000017ED 8346FE07                 add  word [bp-2], 7
  3977                                  @@printhex8a196:
  3978 000017F1 FF76FE                   push word [bp-2]
  3979 000017F4 E8B3FE                   call prc
  3980 000017F7 83C402                   add  sp, 2
  3981                                  
  3982                                  ;-340 }
  3983                                  
  3984                                  
  3985                                  ;-341 int printhex16(unsigned int i) {unsigned int half;
  3986 000017FA C9                       LEAVE
  3987 000017FB C3                       ret
  3988                                  ; ENDP
  3989                                  
  3990                                  printhex16:  ; *** PROC ***
  3991                                  
  3992                                  ;-342   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3993                                  
  3994                                  ;Function : printhex16, Number of local variables: 2
  3995                                  ;   # type sign width line used address name   list of local variables
  3996                                  ;  200 var unsg word   341 NULL bp+4    i
  3997                                  ;  201 var unsg word   341 NULL bp-2    half;
  3998 000017FC C8020000                 ENTER  2,0
  3999 00001800 8B4604                   mov ax, [bp+4]
  4000 00001803 C1E808                   shr ax, 8
  4001 00001806 8946FE                   mov word [bp-2], ax
  4002 00001809 FF76FE                   push word [bp-2]
  4003 0000180C E89FFF                   call printhex8a
  4004 0000180F 83C402                   add  sp, 2
  4005 00001812 8B4604                   mov ax, [bp+4]
  4006 00001815 25FF00                   and ax, 255
  4007 00001818 8946FE                   mov word [bp-2], ax
  4008 0000181B FF76FE                   push word [bp-2]
  4009 0000181E E88DFF                   call printhex8a
  4010 00001821 83C402                   add  sp, 2
  4011                                  
  4012                                  ;-343 }
  4013                                  
  4014                                  
  4015                                  ;-344 int printIntU(unsigned int n) { unsigned int e;
  4016 00001824 C9                       LEAVE
  4017 00001825 C3                       ret
  4018                                  ; ENDP
  4019                                  
  4020                                  printIntU:  ; *** PROC ***
  4021                                  
  4022                                  ;-345   if ( _ n >= 10) {  e=n/10; //DIV
  4023                                  
  4024                                  ;Function : printIntU, Number of local variables: 2
  4025                                  ;   # type sign width line used address name   list of local variables
  4026                                  ;  200 var unsg word   344 NULL bp+4    n
  4027                                  ;  201 var unsg word   344 NULL bp-2    e;
  4028 00001826 C8020000                 ENTER  2,0
  4029 0000182A 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4030 0000182E 0F821700                 jb  @@printIntU197
  4031 00001832 8B4604                   mov ax, [bp+4]
  4032 00001835 BB0A00                   mov bx, 10
  4033 00001838 BA0000                   mov dx, 0
  4034 0000183B F7F3                     div bx
  4035 0000183D 8946FE                   mov word [bp-2], ax
  4036                                  
  4037                                  ;-346     printIntU(e); }
  4038                                  
  4039 00001840 FF76FE                   push word [bp-2]
  4040 00001843 E8E0FF                   call printIntU
  4041 00001846 83C402                   add  sp, 2
  4042                                  
  4043                                  ;-347     n = n % 10; //unsigned mod
  4044                                  
  4045                                  @@printIntU197:
  4046 00001849 8B4604                   mov ax, [bp+4]
  4047 0000184C BB0A00                   mov bx, 10
  4048 0000184F BA0000                   mov dx, 0
  4049 00001852 F7F3                     div bx
  4050 00001854 89D0                     mov ax, dx
  4051 00001856 894604                   mov word [bp+4], ax
  4052                                  
  4053                                  ;-348     n += '0'; prc(n);
  4054                                  
  4055 00001859 83460430                 add  word [bp+4], 48
  4056 0000185D FF7604                   push word [bp+4]
  4057 00001860 E847FE                   call prc
  4058 00001863 83C402                   add  sp, 2
  4059                                  
  4060                                  ;-349 }
  4061                                  
  4062                                  
  4063                                  ;-350 /*int printLineHex(unsigned char *s) { int L; char c;
  4064                                  
  4065                                  
  4066                                  ;-351   L = strlen(s);
  4067                                  
  4068                                  
  4069                                  ;-352   prs(" L:");
  4070                                  
  4071                                  
  4072                                  ;-353   printIntU(L);
  4073                                  
  4074                                  
  4075                                  ;-354   if (L <= 0) return;
  4076                                  
  4077                                  
  4078                                  ;-355   if (L > 80) errorexit("Line > 80 char");
  4079                                  
  4080                                  
  4081                                  ;-356   while ( *s ) {
  4082                                  
  4083                                  
  4084                                  ;-357     c = *s;
  4085                                  
  4086                                  
  4087                                  ;-358     prc(' ');
  4088                                  
  4089                                  
  4090                                  ;-359     printhex8a(c);
  4091                                  
  4092                                  
  4093                                  ;-360     s++;
  4094                                  
  4095                                  
  4096                                  ;-361   }
  4097                                  
  4098                                  
  4099                                  ;-362 } */
  4100                                  
  4101                                  
  4102                                  ;-363 int error1(char *s) { LIST=1; ErrorCount++;
  4103 00001866 C9                       LEAVE
  4104 00001867 C3                       ret
  4105                                  ; ENDP
  4106                                  
  4107                                  error1:  ; *** PROC ***
  4108                                  ;Function : error1, Number of local variables: 1
  4109                                  ;   # type sign width line used address name   list of local variables
  4110                                  ;  200 ptr sign byte   363 NULL bp+4    s;
  4111 00001868 C8000000                 ENTER  0,0
  4112 0000186C 66B801000000             mov eax, 1
  4113 00001872 A2[2400]                 mov byte [LIST], al
  4114 00001875 FF06[3100]               inc  word [ErrorCount]
  4115                                  
  4116                                  ;-364   prs("\n;***** next line ERROR: "); prs(s);
  4117                                  
  4118 00001879 68[A118]                 push error1_0
  4119 0000187C E88CFE                   call prs
  4120 0000187F 83C402                   add  sp, 2
  4121 00001882 FF7604                   push word [bp+4]
  4122 00001885 E883FE                   call prs
  4123 00001888 83C402                   add  sp, 2
  4124                                  
  4125                                  ;-365   prs(", Symbol: "); prs(Symbol);}
  4126                                  
  4127 0000188B 68[BC18]                 push error1_1
  4128 0000188E E87AFE                   call prs
  4129 00001891 83C402                   add  sp, 2
  4130 00001894 8D063075                 lea  ax, [Symbol]
  4131 00001898 50                       push ax
  4132 00001899 E86FFE                   call prs
  4133 0000189C 83C402                   add  sp, 2
  4134                                  
  4135                                  ;-366 int allowederror(){error1("not allowed here"); }
  4136 0000189F C9                       LEAVE
  4137 000018A0 C3                       ret
  4138                                  ; ENDP
  4139 000018A1 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4140 000018AA 6E657874206C696E65-
  4141 000018B3 204552524F523A2000 
  4142 000018BC 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4143 000018C5 2000               
  4144                                  
  4145                                  allowederror:  ; *** PROC ***
  4146 000018C7 68[D118]                 push allowederror_0
  4147 000018CA E89BFF                   call error1
  4148 000018CD 83C402                   add  sp, 2
  4149                                  
  4150                                  ;-367 int implmerror(){error1("not implemented");}
  4151                                  
  4152 000018D0 C3                       ret
  4153                                  ; ENDP
  4154 000018D1 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4155 000018DA 6564206865726500   
  4156                                  
  4157                                  implmerror:  ; *** PROC ***
  4158 000018E2 68[EC18]                 push implmerror_0
  4159 000018E5 E880FF                   call error1
  4160 000018E8 83C402                   add  sp, 2
  4161                                  
  4162                                  ;-368 int indexerror (){error1("invalid index register");}
  4163                                  
  4164 000018EB C3                       ret
  4165                                  ; ENDP
  4166 000018EC 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4167 000018F5 6D656E74656400     
  4168                                  
  4169                                  indexerror:  ; *** PROC ***
  4170 000018FC 68[0619]                 push indexerror_0
  4171 000018FF E866FF                   call error1
  4172 00001902 83C402                   add  sp, 2
  4173                                  
  4174                                  ;-369 int numbererror(){error1("number expected");}
  4175                                  
  4176 00001905 C3                       ret
  4177                                  ; ENDP
  4178 00001906 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4179 0000190F 6E6465782072656769-
  4180 00001918 7374657200         
  4181                                  
  4182                                  numbererror:  ; *** PROC ***
  4183 0000191D 68[2719]                 push numbererror_0
  4184 00001920 E845FF                   call error1
  4185 00001923 83C402                   add  sp, 2
  4186                                  
  4187                                  ;-370 int regmemerror(){error1("only register or memory allowed");}
  4188                                  
  4189 00001926 C3                       ret
  4190                                  ; ENDP
  4191 00001927 6E756D626572206578-     numbererror_0 db "number expected",0
  4192 00001930 70656374656400     
  4193                                  
  4194                                  regmemerror:  ; *** PROC ***
  4195 00001937 68[4119]                 push regmemerror_0
  4196 0000193A E82BFF                   call error1
  4197 0000193D 83C402                   add  sp, 2
  4198                                  
  4199                                  ;-371 int segregerror(){error1("segment register not allowed");}
  4200                                  
  4201 00001940 C3                       ret
  4202                                  ; ENDP
  4203 00001941 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4204 0000194A 73746572206F72206D-
  4205 00001953 656D6F727920616C6C-
  4206 0000195C 6F77656400         
  4207                                  
  4208                                  segregerror:  ; *** PROC ***
  4209 00001961 68[6B19]                 push segregerror_0
  4210 00001964 E801FF                   call error1
  4211 00001967 83C402                   add  sp, 2
  4212                                  
  4213                                  ;-372 int syntaxerror(){error1("syntax");}
  4214                                  
  4215 0000196A C3                       ret
  4216                                  ; ENDP
  4217 0000196B 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4218 00001974 65676973746572206E-
  4219 0000197D 6F7420616C6C6F7765-
  4220 00001986 6400               
  4221                                  
  4222                                  syntaxerror:  ; *** PROC ***
  4223 00001988 68[9219]                 push syntaxerror_0
  4224 0000198B E8DAFE                   call error1
  4225 0000198E 83C402                   add  sp, 2
  4226                                  
  4227                                  ;-373 
  4228                                  
  4229                                  
  4230                                  ;-374 int errorexit(char *s) { error1(s); end1(1);}
  4231                                  
  4232 00001991 C3                       ret
  4233                                  ; ENDP
  4234 00001992 73796E74617800          syntaxerror_0 db "syntax",0
  4235                                  
  4236                                  errorexit:  ; *** PROC ***
  4237                                  ;Function : errorexit, Number of local variables: 1
  4238                                  ;   # type sign width line used address name   list of local variables
  4239                                  ;  200 ptr sign byte   374 NULL bp+4    s;
  4240 00001999 C8000000                 ENTER  0,0
  4241 0000199D FF7604                   push word [bp+4]
  4242 000019A0 E8C5FE                   call error1
  4243 000019A3 83C402                   add  sp, 2
  4244 000019A6 6A01                     push 1
  4245 000019A8 E81004                   call end1
  4246 000019AB 83C402                   add  sp, 2
  4247                                  
  4248                                  ;-375 int addrexit(){errorexit("illegal addres");}
  4249 000019AE C9                       LEAVE
  4250 000019AF C3                       ret
  4251                                  ; ENDP
  4252                                  
  4253                                  addrexit:  ; *** PROC ***
  4254 000019B0 68[BA19]                 push addrexit_0
  4255 000019B3 E8E3FF                   call errorexit
  4256 000019B6 83C402                   add  sp, 2
  4257                                  
  4258                                  ;-376 int internexit(){errorexit("intern compiler error");}
  4259                                  
  4260 000019B9 C3                       ret
  4261                                  ; ENDP
  4262 000019BA 696C6C6567616C2061-     addrexit_0 db "illegal addres",0
  4263 000019C3 646472657300       
  4264                                  
  4265                                  internexit:  ; *** PROC ***
  4266 000019C9 68[D319]                 push internexit_0
  4267 000019CC E8CAFF                   call errorexit
  4268 000019CF 83C402                   add  sp, 2
  4269                                  
  4270                                  ;-377 
  4271                                  
  4272                                  
  4273                                  ;-378 //int main() {getarg(); parse(); epilog(); end1();}//NB AS, AS TE
  4274                                  
  4275                                  
  4276                                  ;-379 char *arglen=0x80; char *argv=0x82;
  4277                                  
  4278 000019D2 C3                       ret
  4279                                  ; ENDP
  4280 000019D3 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4281 000019DC 6D70696C6572206572-
  4282 000019E5 726F7200           
  4283 000019E9 8000                    arglen dw 128
  4284 000019EB 8200                    argv dw 130
  4285                                  
  4286                                  ;-380 int getarg() { int arglen1; int i; char *c;
  4287                                  
  4288                                  
  4289                                  getarg:  ; *** PROC ***
  4290                                  
  4291                                  ;-381   arglen1=*arglen;
  4292                                  
  4293                                  ;Function : getarg, Number of local variables: 3
  4294                                  ;   # type sign width line used address name   list of local variables
  4295                                  ;  200 var sign word   380 NULL bp-2    arglen1
  4296                                  ;  201 var sign word   380 NULL bp-4    i
  4297                                  ;  202 ptr sign byte   380 NULL bp-6    c;
  4298 000019ED C8060000                 ENTER  6,0
  4299 000019F1 8B1E[E919]               mov bx, [arglen]
  4300 000019F5 8A07                     mov al, [bx]
  4301 000019F7 B400                     mov ah, 0
  4302 000019F9 8946FE                   mov word [bp-2], ax
  4303                                  
  4304                                  ;-382   if (arglen1==0) {
  4305                                  
  4306 000019FC 8B46FE                   mov ax, [bp-2]
  4307 000019FF 83F800                   cmp ax, 0
  4308 00001A02 0F851C00                 jne @@getarg198
  4309                                  
  4310                                  ;-383     cputs(Version1);
  4311                                  
  4312 00001A06 8D06[1000]               lea  ax, [Version1]
  4313 00001A0A 50                       push ax
  4314 00001A0B E8E203                   call cputs
  4315 00001A0E 83C402                   add  sp, 2
  4316                                  
  4317                                  ;-384     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4318                                  
  4319 00001A11 68[B21B]                 push getarg_0
  4320 00001A14 E8D903                   call cputs
  4321 00001A17 83C402                   add  sp, 2
  4322                                  
  4323                                  ;-385     exitR(3);
  4324                                  
  4325 00001A1A 6A03                     push 3
  4326 00001A1C E82706                   call exitR
  4327 00001A1F 83C402                   add  sp, 2
  4328                                  
  4329                                  ;-386   }
  4330                                  
  4331                                  
  4332                                  ;-387   i=arglen1+129; *i=0;  arglen1--;
  4333                                  
  4334                                  @@getarg198:
  4335 00001A22 8B46FE                   mov ax, [bp-2]
  4336 00001A25 058100                   add ax, 129
  4337 00001A28 8946FC                   mov word [bp-4], ax
  4338 00001A2B 66B800000000             mov eax, 0
  4339 00001A31 8B5EFC                   mov  bx, [bp-4]
  4340 00001A34 8907                     mov  [bx], ax
  4341 00001A36 FF4EFE                   dec  word [bp-2]
  4342                                  
  4343                                  ;-388   toupper(argv);
  4344                                  
  4345 00001A39 FF36[EB19]               push word [argv]
  4346 00001A3D E8DE03                   call toupper
  4347 00001A40 83C402                   add  sp, 2
  4348                                  
  4349                                  ;-389   strcpy(namein, argv); strcat1(namein, ".S");
  4350                                  
  4351 00001A43 FF36[EB19]               push word [argv]
  4352 00001A47 8D065076                 lea  ax, [namein]
  4353 00001A4B 50                       push ax
  4354 00001A4C E83D04                   call strcpy
  4355 00001A4F 83C404                   add  sp, 4
  4356 00001A52 68[D71B]                 push getarg_1
  4357 00001A55 8D065076                 lea  ax, [namein]
  4358 00001A59 50                       push ax
  4359 00001A5A E86B05                   call strcat1
  4360 00001A5D 83C404                   add  sp, 4
  4361                                  
  4362                                  ;-390   strcpy(namelst,argv); strcat1(namelst,".LST");
  4363                                  
  4364 00001A60 FF36[EB19]               push word [argv]
  4365 00001A64 8D069376                 lea  ax, [namelst]
  4366 00001A68 50                       push ax
  4367 00001A69 E82004                   call strcpy
  4368 00001A6C 83C404                   add  sp, 4
  4369 00001A6F 68[DA1B]                 push getarg_2
  4370 00001A72 8D069376                 lea  ax, [namelst]
  4371 00001A76 50                       push ax
  4372 00001A77 E84E05                   call strcat1
  4373 00001A7A 83C404                   add  sp, 4
  4374                                  
  4375                                  ;-391   strcpy(namebin,argv); strcat1(namebin,".COM");
  4376                                  
  4377 00001A7D FF36[EB19]               push word [argv]
  4378 00001A81 8D06D676                 lea  ax, [namebin]
  4379 00001A85 50                       push ax
  4380 00001A86 E80304                   call strcpy
  4381 00001A89 83C404                   add  sp, 4
  4382 00001A8C 68[DF1B]                 push getarg_3
  4383 00001A8F 8D06D676                 lea  ax, [namebin]
  4384 00001A93 50                       push ax
  4385 00001A94 E83105                   call strcat1
  4386 00001A97 83C404                   add  sp, 4
  4387                                  
  4388                                  ;-392 
  4389                                  
  4390                                  
  4391                                  ;-393   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4392                                  
  4393 00001A9A 66B801000000             mov eax, 1
  4394 00001AA0 A2[2400]                 mov byte [LIST], al
  4395 00001AA3 66B800000000             mov eax, 0
  4396 00001AA9 A3[2F00]                 mov word [DOS_ERR], ax
  4397 00001AAC 66B800000000             mov eax, 0
  4398 00001AB2 A3[3600]                 mov word [PC], ax
  4399 00001AB5 66B800000000             mov eax, 0
  4400 00001ABB A3[3100]                 mov word [ErrorCount], ax
  4401                                  
  4402                                  ;-394   asm_fd=openR (namein);
  4403                                  
  4404 00001ABE 8D065076                 lea  ax, [namein]
  4405 00001AC2 50                       push ax
  4406 00001AC3 E82705                   call openR
  4407 00001AC6 83C402                   add  sp, 2
  4408 00001AC9 A3[2900]                 mov word [asm_fd], ax
  4409                                  
  4410                                  ;-395   if(DOS_ERR){cputs("Source file missing: "); cputs(namein); exitR(1); }
  4411                                  
  4412 00001ACC A1[2F00]                 mov ax, [DOS_ERR]
  4413 00001ACF 08C0                     or  al, al
  4414 00001AD1 0F841C00                 je @@getarg199
  4415 00001AD5 68[E41B]                 push getarg_4
  4416 00001AD8 E81503                   call cputs
  4417 00001ADB 83C402                   add  sp, 2
  4418 00001ADE 8D065076                 lea  ax, [namein]
  4419 00001AE2 50                       push ax
  4420 00001AE3 E80A03                   call cputs
  4421 00001AE6 83C402                   add  sp, 2
  4422 00001AE9 6A01                     push 1
  4423 00001AEB E85805                   call exitR
  4424 00001AEE 83C402                   add  sp, 2
  4425                                  
  4426                                  ;-396   lst_fd=creatR(namelst);
  4427                                  
  4428                                  @@getarg199:
  4429 00001AF1 8D069376                 lea  ax, [namelst]
  4430 00001AF5 50                       push ax
  4431 00001AF6 E80305                   call creatR
  4432 00001AF9 83C402                   add  sp, 2
  4433 00001AFC A3[2B00]                 mov word [lst_fd], ax
  4434                                  
  4435                                  ;-397   if(DOS_ERR){cputs("List file not creatable: ");cputs(namelst);exitR(2);}
  4436                                  
  4437 00001AFF A1[2F00]                 mov ax, [DOS_ERR]
  4438 00001B02 08C0                     or  al, al
  4439 00001B04 0F841C00                 je @@getarg200
  4440 00001B08 68[FA1B]                 push getarg_5
  4441 00001B0B E8E202                   call cputs
  4442 00001B0E 83C402                   add  sp, 2
  4443 00001B11 8D069376                 lea  ax, [namelst]
  4444 00001B15 50                       push ax
  4445 00001B16 E8D702                   call cputs
  4446 00001B19 83C402                   add  sp, 2
  4447 00001B1C 6A02                     push 2
  4448 00001B1E E82505                   call exitR
  4449 00001B21 83C402                   add  sp, 2
  4450                                  
  4451                                  ;-398   bin_fd=creatR(namebin);
  4452                                  
  4453                                  @@getarg200:
  4454 00001B24 8D06D676                 lea  ax, [namebin]
  4455 00001B28 50                       push ax
  4456 00001B29 E8D004                   call creatR
  4457 00001B2C 83C402                   add  sp, 2
  4458 00001B2F A3[2D00]                 mov word [bin_fd], ax
  4459                                  
  4460                                  ;-399   if(DOS_ERR){cputs("COM file not creatable: ");cputs(namebin);exitR(2);}
  4461                                  
  4462 00001B32 A1[2F00]                 mov ax, [DOS_ERR]
  4463 00001B35 08C0                     or  al, al
  4464 00001B37 0F841C00                 je @@getarg201
  4465 00001B3B 68[141C]                 push getarg_6
  4466 00001B3E E8AF02                   call cputs
  4467 00001B41 83C402                   add  sp, 2
  4468 00001B44 8D06D676                 lea  ax, [namebin]
  4469 00001B48 50                       push ax
  4470 00001B49 E8A402                   call cputs
  4471 00001B4C 83C402                   add  sp, 2
  4472 00001B4F 6A02                     push 2
  4473 00001B51 E8F204                   call exitR
  4474 00001B54 83C402                   add  sp, 2
  4475                                  
  4476                                  ;-400   prs(";");prs(Version1);
  4477                                  
  4478                                  @@getarg201:
  4479 00001B57 68[2D1C]                 push getarg_7
  4480 00001B5A E8AEFB                   call prs
  4481 00001B5D 83C402                   add  sp, 2
  4482 00001B60 8D06[1000]               lea  ax, [Version1]
  4483 00001B64 50                       push ax
  4484 00001B65 E8A3FB                   call prs
  4485 00001B68 83C402                   add  sp, 2
  4486                                  
  4487                                  ;-401   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4488                                  
  4489 00001B6B 68[2F1C]                 push getarg_8
  4490 00001B6E E89AFB                   call prs
  4491 00001B71 83C402                   add  sp, 2
  4492 00001B74 8D065076                 lea  ax, [namein]
  4493 00001B78 50                       push ax
  4494 00001B79 E88FFB                   call prs
  4495 00001B7C 83C402                   add  sp, 2
  4496 00001B7F 68[3A1C]                 push getarg_9
  4497 00001B82 E886FB                   call prs
  4498 00001B85 83C402                   add  sp, 2
  4499 00001B88 8D069376                 lea  ax, [namelst]
  4500 00001B8C 50                       push ax
  4501 00001B8D E87BFB                   call prs
  4502 00001B90 83C402                   add  sp, 2
  4503                                  
  4504                                  ;-402   prs(", "); prs(namebin);
  4505                                  
  4506 00001B93 68[451C]                 push getarg_10
  4507 00001B96 E872FB                   call prs
  4508 00001B99 83C402                   add  sp, 2
  4509 00001B9C 8D06D676                 lea  ax, [namebin]
  4510 00001BA0 50                       push ax
  4511 00001BA1 E867FB                   call prs
  4512 00001BA4 83C402                   add  sp, 2
  4513                                  
  4514                                  ;-403   prs("\n");
  4515                                  
  4516 00001BA7 68[481C]                 push getarg_11
  4517 00001BAA E85EFB                   call prs
  4518 00001BAD 83C402                   add  sp, 2
  4519                                  
  4520                                  ;-404 }
  4521                                  
  4522                                  
  4523                                  ;-405 int epilog() { int i; int j; char c;
  4524 00001BB0 C9                       LEAVE
  4525 00001BB1 C3                       ret
  4526                                  ; ENDP
  4527 00001BB2 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4528 00001BBB 41532E434F4D206669-
  4529 00001BC4 6C656E616D65205B77-
  4530 00001BCD 2F6F202E535D203A20-
  4531 00001BD6 00                 
  4532 00001BD7 2E5300                  getarg_1 db ".S",0
  4533 00001BDA 2E4C535400              getarg_2 db ".LST",0
  4534 00001BDF 2E434F4D00              getarg_3 db ".COM",0
  4535 00001BE4 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4536 00001BED 6C65206D697373696E-
  4537 00001BF6 673A2000           
  4538 00001BFA 4C6973742066696C65-     getarg_5 db "List file not creatable: ",0
  4539 00001C03 206E6F742063726561-
  4540 00001C0C 7461626C653A2000   
  4541 00001C14 434F4D2066696C6520-     getarg_6 db "COM file not creatable: ",0
  4542 00001C1D 6E6F74206372656174-
  4543 00001C26 61626C653A2000     
  4544 00001C2D 3B00                    getarg_7 db ";",0
  4545 00001C2F 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4546 00001C38 2000               
  4547 00001C3A 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4548 00001C43 2000               
  4549 00001C45 2C2000                  getarg_10 db ", ",0
  4550 00001C48 5C6E00                  getarg_11 db "\n",0
  4551                                  
  4552                                  epilog:  ; *** PROC ***
  4553                                  
  4554                                  ;-406   prs("\n;END Errors: "); printIntU(ErrorCount);
  4555                                  
  4556                                  ;Function : epilog, Number of local variables: 3
  4557                                  ;   # type sign width line used address name   list of local variables
  4558                                  ;  200 var sign word   405 NULL bp-2    i
  4559                                  ;  201 var sign word   405 NULL bp-4    j
  4560                                  ;  202 var sign byte   405 NULL bp-6    c;
  4561 00001C4B C8060000                 ENTER  6,0
  4562 00001C4F 68[741D]                 push epilog_0
  4563 00001C52 E8B6FA                   call prs
  4564 00001C55 83C402                   add  sp, 2
  4565 00001C58 FF36[3100]               push word [ErrorCount]
  4566 00001C5C E8C7FB                   call printIntU
  4567 00001C5F 83C402                   add  sp, 2
  4568                                  
  4569                                  ;-407   if (ErrorCount) prs(" ***ERROR*** ");
  4570                                  
  4571 00001C62 A1[3100]                 mov ax, [ErrorCount]
  4572 00001C65 08C0                     or  al, al
  4573 00001C67 0F840900                 je @@epilog202
  4574 00001C6B 68[841D]                 push epilog_1
  4575 00001C6E E89AFA                   call prs
  4576 00001C71 83C402                   add  sp, 2
  4577                                  
  4578                                  ;-408   prs(", Label & Var: ");
  4579                                  
  4580                                  @@epilog202:
  4581 00001C74 68[921D]                 push epilog_2
  4582 00001C77 E891FA                   call prs
  4583 00001C7A 83C402                   add  sp, 2
  4584                                  
  4585                                  ;-409 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4586                                  
  4587                                  
  4588                                  ;-410   i= &LabelNames;
  4589                                  
  4590                                  
  4591                                  ;-411   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4592                                  
  4593                                  
  4594                                  ;-412   } while (i < LabelNamePtr); prs("<< \n"); */
  4595                                  
  4596                                  
  4597                                  ;-413   if (LabelMaxIx) {
  4598                                  
  4599 00001C7D A1[5100]                 mov ax, [LabelMaxIx]
  4600 00001C80 08C0                     or  al, al
  4601 00001C82 0F846900                 je @@epilog203
  4602                                  
  4603                                  ;-414     i = 1;
  4604                                  
  4605 00001C86 66B801000000             mov eax, 1
  4606 00001C8C 8946FE                   mov word [bp-2], ax
  4607                                  
  4608                                  ;-415     LabelNamePtr= &LabelNames;
  4609                                  
  4610 00001C8F B81E77                   mov ax, LabelNames
  4611 00001C92 A3[4F00]                 mov word [LabelNamePtr], ax
  4612                                  
  4613                                  ;-416     do {
  4614                                  
  4615                                  @@epilog204:
  4616                                  
  4617                                  ;-417       prs(LabelNamePtr); prc(' ');
  4618                                  
  4619 00001C95 FF36[4F00]               push word [LabelNamePtr]
  4620 00001C99 E86FFA                   call prs
  4621 00001C9C 83C402                   add  sp, 2
  4622 00001C9F 6A20                     push 32
  4623 00001CA1 E806FA                   call prc
  4624 00001CA4 83C402                   add  sp, 2
  4625                                  
  4626                                  ;-418  /*     j=LabelType[i]; //printIntU(j);
  4627                                  
  4628                                  
  4629                                  ;-419       if (j == 1) prc('L');
  4630                                  
  4631                                  
  4632                                  ;-420       if (j == 2) prc('V');
  4633                                  
  4634                                  
  4635                                  ;-421       prc('.'); */
  4636                                  
  4637                                  
  4638                                  ;-422       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4639                                  
  4640 00001CA7 8B5EFE                   mov bx, [bp-2]
  4641 00001CAA D1E3                     shl bx, 1
  4642 00001CAC 8B876A7B                 mov ax, [LabelAddr + bx]
  4643 00001CB0 8946FC                   mov word [bp-4], ax
  4644 00001CB3 FF76FC                   push word [bp-4]
  4645 00001CB6 E843FB                   call printhex16
  4646 00001CB9 83C402                   add  sp, 2
  4647 00001CBC 68[A21D]                 push epilog_3
  4648 00001CBF E849FA                   call prs
  4649 00001CC2 83C402                   add  sp, 2
  4650                                  
  4651                                  ;-423       j=strlen(LabelNamePtr);//get end of act. name
  4652                                  
  4653 00001CC5 FF36[4F00]               push word [LabelNamePtr]
  4654 00001CC9 E89501                   call strlen
  4655 00001CCC 83C402                   add  sp, 2
  4656 00001CCF 8946FC                   mov word [bp-4], ax
  4657                                  
  4658                                  ;-424       LabelNamePtr=LabelNamePtr+j;
  4659                                  
  4660 00001CD2 A1[4F00]                 mov ax, [LabelNamePtr]
  4661 00001CD5 0346FC                   add ax, [bp-4]
  4662 00001CD8 A3[4F00]                 mov word [LabelNamePtr], ax
  4663                                  
  4664                                  ;-425       LabelNamePtr++;
  4665                                  
  4666 00001CDB FF06[4F00]               inc  word [LabelNamePtr]
  4667                                  
  4668                                  ;-426       i++;
  4669                                  
  4670 00001CDF FF46FE                   inc  word [bp-2]
  4671                                  
  4672                                  ;-427     } while (i <= LabelMaxIx);
  4673                                  
  4674 00001CE2 8B46FE                   mov ax, [bp-2]
  4675 00001CE5 3B06[5100]               cmp ax, [LabelMaxIx]
  4676 00001CE9 0F8F0200                 jg  @@epilog205
  4677 00001CED EBA6                     jmp @@epilog204
  4678                                  @@epilog205:
  4679                                  
  4680                                  ;-428   }
  4681                                  
  4682                                  
  4683                                  ;-429   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4684                                  
  4685                                  @@epilog203:
  4686 00001CEF 68[A61D]                 push epilog_4
  4687 00001CF2 E816FA                   call prs
  4688 00001CF5 83C402                   add  sp, 2
  4689 00001CF8 FF36[5500]               push word [BinLen]
  4690 00001CFC E827FB                   call printIntU
  4691 00001CFF 83C402                   add  sp, 2
  4692 00001D02 68[B31D]                 push epilog_5
  4693 00001D05 E803FA                   call prs
  4694 00001D08 83C402                   add  sp, 2
  4695                                  
  4696                                  ;-430   i=0;
  4697                                  
  4698 00001D0B 66B800000000             mov eax, 0
  4699 00001D11 8946FE                   mov word [bp-2], ax
  4700                                  
  4701                                  ;-431   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4702                                  
  4703                                  @@epilog206:
  4704 00001D14 6A20                     push 32
  4705 00001D16 E891F9                   call prc
  4706 00001D19 83C402                   add  sp, 2
  4707 00001D1C 8B5EFE                   mov bx, [bp-2]
  4708 00001D1F 8A87327C                 mov al, [FileBin + bx]
  4709 00001D23 8946FC                   mov word [bp-4], ax
  4710 00001D26 FF76FC                   push word [bp-4]
  4711 00001D29 E882FA                   call printhex8a
  4712 00001D2C 83C402                   add  sp, 2
  4713 00001D2F FF46FE                   inc  word [bp-2]
  4714                                  
  4715                                  ;-432   } while (i < BinLen);
  4716                                  
  4717 00001D32 8B46FE                   mov ax, [bp-2]
  4718 00001D35 3B06[5500]               cmp ax, [BinLen]
  4719 00001D39 0F8D0200                 jge @@epilog207
  4720 00001D3D EBD5                     jmp @@epilog206
  4721                                  @@epilog207:
  4722                                  
  4723                                  ;-433   i=0;
  4724                                  
  4725 00001D3F 66B800000000             mov eax, 0
  4726 00001D45 8946FE                   mov word [bp-2], ax
  4727                                  
  4728                                  ;-434   do {
  4729                                  
  4730                                  @@epilog208:
  4731                                  
  4732                                  ;-435     c = FileBin[i];
  4733                                  
  4734 00001D48 8B5EFE                   mov bx, [bp-2]
  4735 00001D4B 8A87327C                 mov al, [FileBin + bx]
  4736 00001D4F 8846FA                   mov byte [bp-6], al
  4737                                  
  4738                                  ;-436     fputcR(c, bin_fd);
  4739                                  
  4740 00001D52 FF36[2D00]               push word [bin_fd]
  4741 00001D56 8A46FA                   mov al, byte [bp-6]
  4742 00001D59 B400                     mov ah, 0
  4743 00001D5B 50                       push ax
  4744 00001D5C E8C402                   call fputcR
  4745 00001D5F 83C404                   add  sp, 4
  4746                                  
  4747                                  ;-437     i++;
  4748                                  
  4749 00001D62 FF46FE                   inc  word [bp-2]
  4750                                  
  4751                                  ;-438   } while (i < BinLen);
  4752                                  
  4753 00001D65 8B46FE                   mov ax, [bp-2]
  4754 00001D68 3B06[5500]               cmp ax, [BinLen]
  4755 00001D6C 0F8D0200                 jge @@epilog209
  4756 00001D70 EBD6                     jmp @@epilog208
  4757                                  @@epilog209:
  4758                                  
  4759                                  ;-439 }
  4760                                  
  4761                                  
  4762                                  ;-440 int end1(int n) {fcloseR(asm_fd); fcloseR(lst_fd); fcloseR(bin_fd);exitR(n);
  4763 00001D72 C9                       LEAVE
  4764 00001D73 C3                       ret
  4765                                  ; ENDP
  4766 00001D74 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4767 00001D7D 726F72733A2000     
  4768 00001D84 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4769 00001D8D 2A2A2A2000         
  4770 00001D92 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4771 00001D9B 205661723A2000     
  4772 00001DA2 2C202000                epilog_3 db ",  ",0
  4773 00001DA6 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4774 00001DAF 6C652000           
  4775 00001DB3 2062797465733A00        epilog_5 db " bytes:",0
  4776                                  
  4777                                  end1:  ; *** PROC ***
  4778                                  ;Function : end1, Number of local variables: 1
  4779                                  ;   # type sign width line used address name   list of local variables
  4780                                  ;  200 var sign word   440 NULL bp+4    n;
  4781 00001DBB C8000000                 ENTER  0,0
  4782 00001DBF FF36[2900]               push word [asm_fd]
  4783 00001DC3 E87202                   call fcloseR
  4784 00001DC6 83C402                   add  sp, 2
  4785 00001DC9 FF36[2B00]               push word [lst_fd]
  4786 00001DCD E86802                   call fcloseR
  4787 00001DD0 83C402                   add  sp, 2
  4788 00001DD3 FF36[2D00]               push word [bin_fd]
  4789 00001DD7 E85E02                   call fcloseR
  4790 00001DDA 83C402                   add  sp, 2
  4791 00001DDD FF7604                   push word [bp+4]
  4792 00001DE0 E86302                   call exitR
  4793 00001DE3 83C402                   add  sp, 2
  4794                                  
  4795                                  ;-441 }
  4796                                  
  4797                                  
  4798                                  ;-442 /*
  4799                                  
  4800                                  
  4801                                  ;-443 Hierarchical software diagram, except string & DOS functions,  .=end
  4802                                  
  4803                                  
  4804                                  ;-444 main:  getarg. parse epilog. end1.
  4805                                  
  4806                                  
  4807                                  ;-445 parse: getLine. getToken storeLabel. searchLabel. lookCode. process
  4808                                  
  4809                                  
  4810                                  ;-446        getVariable printLine.
  4811                                  
  4812                                  
  4813                                  ;-447 getToken: skipBlank. getDigit. getName.
  4814                                  
  4815                                  
  4816                                  ;-448 process: genInstruction getToken testReg. genAddr16.
  4817                                  
  4818                                  
  4819                                  ;-449 genInstruction: genCode8.
  4820                                  
  4821                                  
  4822                                  ;-450 getVariable: storeLabel. getToken lookCode. skipBlank. isToken. genAddr16.
  4823                                  
  4824                                  
  4825                                  ;-451 */
  4826 00001DE6 C9                       LEAVE
  4827 00001DE7 C3                       ret
  4828                                  ; ENDP
  4829                                  ;Back to main program: AS.C
  4830                                   
  4831                                  ; missing functions: 
  4832                                  ; digit
  4833                                  ; alnum
  4834                                  ; eqstr
  4835                                  ; eqstr
  4836                                  ; eqstr
  4837                                  ; strcpy
  4838                                  ; eqstr
  4839                                  ; strlen
  4840                                  ; digit
  4841                                  ; digit
  4842                                  ; readRL
  4843                                  ; readRL
  4844                                  ; digit
  4845                                  ; alnum
  4846                                  ; strcpy
  4847                                  ; toupper
  4848                                  ; strlen
  4849                                  ; strlen
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
  4866                                  ; eqstr
  4867                                  ; eqstr
  4868                                  ; eqstr
  4869                                  ; eqstr
  4870                                  ; eqstr
  4871                                  ; eqstr
  4872                                  ; eqstr
  4873                                  ; eqstr
  4874                                  ; eqstr
  4875                                  ; eqstr
  4876                                  ; eqstr
  4877                                  ; eqstr
  4878                                  ; eqstr
  4879                                  ; eqstr
  4880                                  ; eqstr
  4881                                  ; writetty
  4882                                  ; writetty
  4883                                  ; fputcR
  4884                                  ; cputs
  4885                                  ; cputs
  4886                                  ; exitR
  4887                                  ; toupper
  4888                                  ; strcpy
  4889                                  ; strcat1
  4890                                  ; strcpy
  4891                                  ; strcat1
  4892                                  ; strcpy
  4893                                  ; strcat1
  4894                                  ; openR
  4895                                  ; cputs
  4896                                  ; cputs
  4897                                  ; exitR
  4898                                  ; creatR
  4899                                  ; cputs
  4900                                  ; cputs
  4901                                  ; exitR
  4902                                  ; creatR
  4903                                  ; cputs
  4904                                  ; cputs
  4905                                  ; exitR
  4906                                  ; strlen
  4907                                  ; fputcR
  4908                                  ; fcloseR
  4909                                  ; fcloseR
  4910                                  ; fcloseR
  4911                                  ; exitR
  4912                                  ; Number of unresolved CALLs :   80
  4913                                  ;use archive file: AR.C
  4914                                  
  4915                                  ;-243 // AR.C Archive
  4916                                  
  4917                                  ;Number of CALLs:    2 : writetty
  4918                                  
  4919                                  writetty:  ; *** PROC ***
  4920 00001DE8 B40E                     mov  ah, 14
  4921 00001DEA BB0000                   mov  bx, 0
  4922 00001DED CD10                     int  16
  4923                                  
  4924                                  ;-244 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  4925                                  
  4926 00001DEF C3                       ret
  4927                                  ; ENDP
  4928                                  ;Number of CALLs:    8 : cputs
  4929                                  
  4930                                  cputs:  ; *** PROC ***
  4931                                  ;Function : cputs, Number of local variables: 2
  4932                                  ;   # type sign width line used address name   list of local variables
  4933                                  ;  200 ptr sign byte   244 NULL bp+4    s
  4934                                  ;  201 var sign byte   244 NULL bp-2    c;
  4935 00001DF0 C8020000                 ENTER  2,0
  4936                                  @@cputs210:
  4937 00001DF4 8B5E04                   mov bx, [bp+4]
  4938 00001DF7 8A07                     mov al, [bx]
  4939 00001DF9 B400                     mov ah, 0
  4940 00001DFB 08C0                     or  al, al
  4941 00001DFD 0F841B00                 je @@cputs211
  4942 00001E01 8B5E04                   mov bx, [bp+4]
  4943 00001E04 8A07                     mov al, [bx]
  4944 00001E06 B400                     mov ah, 0
  4945 00001E08 8846FE                   mov byte [bp-2], al
  4946 00001E0B 8A46FE                   mov al, byte [bp-2]
  4947 00001E0E B400                     mov ah, 0
  4948 00001E10 50                       push ax
  4949 00001E11 E83F02                   call putch
  4950 00001E14 83C402                   add  sp, 2
  4951 00001E17 FF4604                   inc  word [bp+4]
  4952 00001E1A EBD8                     jmp @@cputs210
  4953                                  @@cputs211:
  4954                                  
  4955                                  ;-245 int mkneg(int n) { n; __asm {neg ax} }
  4956 00001E1C C9                       LEAVE
  4957 00001E1D C3                       ret
  4958                                  ; ENDP
  4959                                  ;Number of CALLs:    2 : toupper
  4960                                  
  4961                                  toupper:  ; *** PROC ***
  4962                                  ;Function : toupper, Number of local variables: 1
  4963                                  ;   # type sign width line used address name   list of local variables
  4964                                  ;  200 ptr sign byte   245 NULL bp+4    s;
  4965 00001E1E C8000000                 ENTER  0,0
  4966                                  @@toupper212:
  4967 00001E22 8B5E04                   mov bx, [bp+4]
  4968 00001E25 8A07                     mov al, [bx]
  4969 00001E27 B400                     mov ah, 0
  4970 00001E29 08C0                     or  al, al
  4971 00001E2B 0F843000                 je @@toupper213
  4972 00001E2F 8B5E04                   mov bx, [bp+4]
  4973 00001E32 8A07                     mov al, [bx]
  4974 00001E34 B400                     mov ah, 0
  4975 00001E36 83F861                   cmp ax, 97 ;unsigned : 1
  4976 00001E39 0F8C1D00                 jl  @@toupper214
  4977 00001E3D 8B5E04                   mov bx, [bp+4]
  4978 00001E40 8A07                     mov al, [bx]
  4979 00001E42 B400                     mov ah, 0
  4980 00001E44 83F87A                   cmp ax, 122
  4981 00001E47 0F8F0F00                 jg  @@toupper215
  4982 00001E4B 8B5E04                   mov bx, [bp+4]
  4983 00001E4E 8A07                     mov al, [bx]
  4984 00001E50 B400                     mov ah, 0
  4985 00001E52 83E820                   sub ax, 32
  4986 00001E55 8B5E04                   mov  bx, [bp+4]
  4987 00001E58 8807                     mov  [bx], al
  4988                                  @@toupper215:
  4989                                  @@toupper214:
  4990 00001E5A FF4604                   inc  word [bp+4]
  4991 00001E5D EBC3                     jmp @@toupper212
  4992                                  @@toupper213:
  4993                                  
  4994                                  ;-246 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  4995                                  
  4996                                  
  4997                                  ;-247 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  4998 00001E5F C9                       LEAVE
  4999 00001E60 C3                       ret
  5000                                  ; ENDP
  5001                                  ;Number of CALLs:    4 : strlen
  5002                                  
  5003                                  strlen:  ; *** PROC ***
  5004                                  ;Function : strlen, Number of local variables: 2
  5005                                  ;   # type sign width line used address name   list of local variables
  5006                                  ;  200 ptr sign byte   247 NULL bp+4    s
  5007                                  ;  201 var sign word   247 NULL bp-2    c;
  5008 00001E61 C8020000                 ENTER  2,0
  5009 00001E65 66B800000000             mov eax, 0
  5010 00001E6B 8946FE                   mov word [bp-2], ax
  5011                                  @@strlen216:
  5012 00001E6E 8B5E04                   mov bx, [bp+4]
  5013 00001E71 8A07                     mov al, [bx]
  5014 00001E73 B400                     mov ah, 0
  5015 00001E75 83F800                   cmp ax, 0
  5016 00001E78 0F840800                 je  @@strlen217
  5017 00001E7C FF4604                   inc  word [bp+4]
  5018 00001E7F FF46FE                   inc  word [bp-2]
  5019 00001E82 EBEA                     jmp @@strlen216
  5020                                  @@strlen217:
  5021 00001E84 8B46FE                   mov ax, [bp-2]
  5022 00001E87 E90000                   jmp @@retn
  5023                                  
  5024                                  ;-248 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5025                                  
  5026 00001E8A C9                      @@retn: LEAVE
  5027 00001E8B C3                       ret
  5028                                  ; ENDP
  5029                                  ;Number of CALLs:    5 : strcpy
  5030                                  
  5031                                  strcpy:  ; *** PROC ***
  5032                                  ;Function : strcpy, Number of local variables: 2
  5033                                  ;   # type sign width line used address name   list of local variables
  5034                                  ;  200 ptr sign byte   248 NULL bp+4    s
  5035                                  ;  201 ptr sign byte   248 NULL bp+6    t;
  5036 00001E8C C8000000                 ENTER  0,0
  5037                                  @@strcpy218:
  5038 00001E90 8B5E06                   mov bx, [bp+6]
  5039 00001E93 8A07                     mov al, [bx]
  5040 00001E95 B400                     mov ah, 0
  5041 00001E97 8B5E04                   mov  bx, [bp+4]
  5042 00001E9A 8807                     mov  [bx], al
  5043 00001E9C FF4604                   inc  word [bp+4]
  5044 00001E9F FF4606                   inc  word [bp+6]
  5045                                  
  5046                                  ;-249   while (*t!=0); *s=0; return s; }
  5047                                  
  5048 00001EA2 8B5E06                   mov bx, [bp+6]
  5049 00001EA5 8A07                     mov al, [bx]
  5050 00001EA7 B400                     mov ah, 0
  5051 00001EA9 83F800                   cmp ax, 0
  5052 00001EAC 0F840200                 je  @@strcpy219
  5053 00001EB0 EBDE                     jmp @@strcpy218
  5054                                  @@strcpy219:
  5055 00001EB2 66B800000000             mov eax, 0
  5056 00001EB8 8B5E04                   mov  bx, [bp+4]
  5057 00001EBB 8807                     mov  [bx], al
  5058 00001EBD 8B4604                   mov ax, [bp+4]
  5059 00001EC0 E90000                   jmp @@retn
  5060                                  
  5061                                  ;-250 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5062                                  
  5063 00001EC3 C9                      @@retn: LEAVE
  5064 00001EC4 C3                       ret
  5065                                  ; ENDP
  5066                                  ;Number of CALLs:    4 : digit
  5067                                  
  5068                                  digit:  ; *** PROC ***
  5069                                  ;Function : digit, Number of local variables: 1
  5070                                  ;   # type sign width line used address name   list of local variables
  5071                                  ;  200 var sign byte   250 NULL bp+4    c;
  5072 00001EC5 C8000000                 ENTER  0,0
  5073 00001EC9 8A4604                   mov al, [bp+4]
  5074 00001ECC 3C30                     cmp al, 48
  5075 00001ECE 0F8D0900                 jge @@digit220
  5076 00001ED2 66B800000000             mov eax, 0
  5077 00001ED8 E91B00                   jmp @@retn
  5078                                  @@digit220:
  5079 00001EDB 8A4604                   mov al, [bp+4]
  5080 00001EDE 3C39                     cmp al, 57
  5081 00001EE0 0F8E0900                 jle @@digit221
  5082 00001EE4 66B800000000             mov eax, 0
  5083 00001EEA E90900                   jmp @@retn
  5084                                  @@digit221:
  5085 00001EED 66B801000000             mov eax, 1
  5086 00001EF3 E90000                   jmp @@retn
  5087                                  
  5088                                  ;-251 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5089                                  
  5090 00001EF6 C9                      @@retn: LEAVE
  5091 00001EF7 C3                       ret
  5092                                  ; ENDP
  5093                                  ;Number of CALLs:    2 : alnum
  5094                                  
  5095                                  alnum:  ; *** PROC ***
  5096                                  ;Function : alnum, Number of local variables: 1
  5097                                  ;   # type sign width line used address name   list of local variables
  5098                                  ;  200 var sign byte   251 NULL bp+4    c;
  5099 00001EF8 C8000000                 ENTER  0,0
  5100 00001EFC 8A4604                   mov al, byte [bp+4]
  5101 00001EFF B400                     mov ah, 0
  5102 00001F01 50                       push ax
  5103 00001F02 E8C0FF                   call digit
  5104 00001F05 83C402                   add  sp, 2
  5105 00001F08 08C0                     or  al, al
  5106 00001F0A 0F840900                 je @@alnum222
  5107 00001F0E 66B801000000             mov eax, 1
  5108 00001F14 E95A00                   jmp @@retn
  5109                                  @@alnum222:
  5110 00001F17 8A4604                   mov al, [bp+4]
  5111 00001F1A 3C5F                     cmp al, 95
  5112 00001F1C 0F850900                 jne @@alnum223
  5113 00001F20 66B801000000             mov eax, 1
  5114 00001F26 E94800                   jmp @@retn
  5115                                  
  5116                                  ;-252   if (c> 'z') return 0; if (c< '@') return 0;
  5117                                  
  5118                                  @@alnum223:
  5119 00001F29 8A4604                   mov al, [bp+4]
  5120 00001F2C 3C7A                     cmp al, 122
  5121 00001F2E 0F8E0900                 jle @@alnum224
  5122 00001F32 66B800000000             mov eax, 0
  5123 00001F38 E93600                   jmp @@retn
  5124                                  @@alnum224:
  5125 00001F3B 8A4604                   mov al, [bp+4]
  5126 00001F3E 3C40                     cmp al, 64
  5127 00001F40 0F8D0900                 jge @@alnum225
  5128 00001F44 66B800000000             mov eax, 0
  5129 00001F4A E92400                   jmp @@retn
  5130                                  
  5131                                  ;-253   if (c> 'Z') { if (c< 'a') return 0; }  return 1; }//same as letter  XXXXXXXXX
  5132                                  
  5133                                  @@alnum225:
  5134 00001F4D 8A4604                   mov al, [bp+4]
  5135 00001F50 3C5A                     cmp al, 90
  5136 00001F52 0F8E1200                 jle @@alnum226
  5137 00001F56 8A4604                   mov al, [bp+4]
  5138 00001F59 3C61                     cmp al, 97
  5139 00001F5B 0F8D0900                 jge @@alnum227
  5140 00001F5F 66B800000000             mov eax, 0
  5141 00001F65 E90900                   jmp @@retn
  5142                                  @@alnum227:
  5143                                  @@alnum226:
  5144 00001F68 66B801000000             mov eax, 1
  5145 00001F6E E90000                   jmp @@retn
  5146                                  
  5147                                  ;-254 int eqstr(char *p, char *q) { while(*p) {
  5148                                  
  5149 00001F71 C9                      @@retn: LEAVE
  5150 00001F72 C3                       ret
  5151                                  ; ENDP
  5152                                  ;Number of CALLs:   35 : eqstr
  5153                                  
  5154                                  eqstr:  ; *** PROC ***
  5155                                  ;Function : eqstr, Number of local variables: 2
  5156                                  ;   # type sign width line used address name   list of local variables
  5157                                  ;  200 ptr sign byte   254 NULL bp+4    p
  5158                                  ;  201 ptr sign byte   254 NULL bp+6    q;
  5159 00001F73 C8000000                 ENTER  0,0
  5160                                  @@eqstr228:
  5161 00001F77 8B5E04                   mov bx, [bp+4]
  5162 00001F7A 8A07                     mov al, [bx]
  5163 00001F7C B400                     mov ah, 0
  5164 00001F7E 08C0                     or  al, al
  5165 00001F80 0F842300                 je @@eqstr229
  5166                                  
  5167                                  ;-255     if (*p != *q) return 0; p++; q++; }
  5168                                  
  5169 00001F84 8B5E04                   mov bx, [bp+4]
  5170 00001F87 8A07                     mov al, [bx]
  5171 00001F89 B400                     mov ah, 0
  5172 00001F8B 8B5E06                   mov bx, [bp+6]
  5173 00001F8E 3A07                     cmp al, [bx]
  5174 00001F90 B400                     mov ah, 0
  5175 00001F92 0F840900                 je  @@eqstr230
  5176 00001F96 66B800000000             mov eax, 0
  5177 00001F9C E92700                   jmp @@retn
  5178                                  @@eqstr230:
  5179 00001F9F FF4604                   inc  word [bp+4]
  5180 00001FA2 FF4606                   inc  word [bp+6]
  5181                                  
  5182                                  ;-256     if(*q) return 0; return 1; }
  5183                                  
  5184 00001FA5 EBD0                     jmp @@eqstr228
  5185                                  @@eqstr229:
  5186 00001FA7 8B5E06                   mov bx, [bp+6]
  5187 00001FAA 8A07                     mov al, [bx]
  5188 00001FAC B400                     mov ah, 0
  5189 00001FAE 08C0                     or  al, al
  5190 00001FB0 0F840900                 je @@eqstr231
  5191 00001FB4 66B800000000             mov eax, 0
  5192 00001FBA E90900                   jmp @@retn
  5193                                  @@eqstr231:
  5194 00001FBD 66B801000000             mov eax, 1
  5195 00001FC3 E90000                   jmp @@retn
  5196                                  
  5197                                  ;-257 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5198                                  
  5199 00001FC6 C9                      @@retn: LEAVE
  5200 00001FC7 C3                       ret
  5201                                  ; ENDP
  5202                                  ;Number of CALLs:    3 : strcat1
  5203                                  
  5204                                  strcat1:  ; *** PROC ***
  5205                                  ;Function : strcat1, Number of local variables: 2
  5206                                  ;   # type sign width line used address name   list of local variables
  5207                                  ;  200 ptr sign byte   257 NULL bp+4    s
  5208                                  ;  201 ptr sign byte   257 NULL bp+6    t;
  5209 00001FC8 C8000000                 ENTER  0,0
  5210                                  @@strcat1232:
  5211 00001FCC 8B5E04                   mov bx, [bp+4]
  5212 00001FCF 8A07                     mov al, [bx]
  5213 00001FD1 B400                     mov ah, 0
  5214 00001FD3 83F800                   cmp ax, 0
  5215 00001FD6 0F840500                 je  @@strcat1233
  5216 00001FDA FF4604                   inc  word [bp+4]
  5217 00001FDD EBED                     jmp @@strcat1232
  5218                                  @@strcat1233:
  5219 00001FDF FF7606                   push word [bp+6]
  5220 00001FE2 FF7604                   push word [bp+4]
  5221 00001FE5 E8A4FE                   call strcpy
  5222 00001FE8 83C404                   add  sp, 4
  5223                                  
  5224                                  ;-258 int basename(char *s) { char *p; p=0;
  5225 00001FEB C9                       LEAVE
  5226 00001FEC C3                       ret
  5227                                  ; ENDP
  5228                                  ;Number of CALLs:    1 : openR
  5229                                  
  5230                                  openR:  ; *** PROC ***
  5231                                  ;Function : openR, Number of local variables: 1
  5232                                  ;   # type sign width line used address name   list of local variables
  5233                                  ;  200 ptr sign byte   258 NULL bp+4    s;
  5234 00001FED C8000000                 ENTER  0,0
  5235 00001FF1 8B5604                   mov  dx, [bp+4]
  5236 00001FF4 B8023D                   mov  ax, 15618
  5237 00001FF7 E87200                   call DosInt
  5238                                  
  5239                                  ;-259 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5240 00001FFA C9                       LEAVE
  5241 00001FFB C3                       ret
  5242                                  ; ENDP
  5243                                  ;Number of CALLs:    2 : creatR
  5244                                  
  5245                                  creatR:  ; *** PROC ***
  5246                                  ;Function : creatR, Number of local variables: 1
  5247                                  ;   # type sign width line used address name   list of local variables
  5248                                  ;  200 ptr sign byte   259 NULL bp+4    s;
  5249 00001FFC C8000000                 ENTER  0,0
  5250 00002000 8B5604                   mov  dx, [bp+4]
  5251 00002003 B90000                   mov  cx, 0
  5252 00002006 B8003C                   mov  ax, 15360
  5253 00002009 E86000                   call DosInt
  5254                                  
  5255                                  ;-260 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5256 0000200C C9                       LEAVE
  5257 0000200D C3                       ret
  5258                                  ; ENDP
  5259                                  ;Number of CALLs:    2 : readRL
  5260                                  
  5261                                  readRL:  ; *** PROC ***
  5262                                  ;Function : readRL, Number of local variables: 3
  5263                                  ;   # type sign width line used address name   list of local variables
  5264                                  ;  200 ptr sign byte   260 NULL bp+4    s
  5265                                  ;  201 var sign word   260 NULL bp+6    fd
  5266                                  ;  202 var sign word   260 NULL bp+8    len;
  5267 0000200E C8000000                 ENTER  0,0
  5268 00002012 8B5604                   mov  dx, [bp+4]
  5269 00002015 8B4E08                   mov  cx, [bp+8]
  5270 00002018 8B5E06                   mov  bx, [bp+6]
  5271 0000201B B8003F                   mov  ax, 16128
  5272 0000201E E84B00                   call DosInt
  5273                                  
  5274                                  ;-261 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5275 00002021 C9                       LEAVE
  5276 00002022 C3                       ret
  5277                                  ; ENDP
  5278                                  ;Number of CALLs:    2 : fputcR
  5279                                  
  5280                                  fputcR:  ; *** PROC ***
  5281                                  ;Function : fputcR, Number of local variables: 2
  5282                                  ;   # type sign width line used address name   list of local variables
  5283                                  ;  200 ptr sign byte   261 NULL bp+4    n
  5284                                  ;  201 var sign word   261 NULL bp+6    fd;
  5285 00002023 C8000000                 ENTER  0,0
  5286 00002027 8D5604                  lea dx, [bp+4]
  5287                                  
  5288                                  ;-262   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5289                                  
  5290 0000202A B90100                   mov  cx, 1
  5291 0000202D 8B5E06                   mov  bx, [bp+6]
  5292 00002030 B80040                   mov  ax, 16384
  5293 00002033 E83600                   call DosInt
  5294                                  
  5295                                  ;-263 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5296 00002036 C9                       LEAVE
  5297 00002037 C3                       ret
  5298                                  ; ENDP
  5299                                  ;Number of CALLs:    3 : fcloseR
  5300                                  
  5301                                  fcloseR:  ; *** PROC ***
  5302                                  ;Function : fcloseR, Number of local variables: 1
  5303                                  ;   # type sign width line used address name   list of local variables
  5304                                  ;  200 var sign word   263 NULL bp+4    fd;
  5305 00002038 C8000000                 ENTER  0,0
  5306 0000203C 8B5E04                   mov  bx, [bp+4]
  5307 0000203F B8003E                   mov  ax, 15872
  5308 00002042 CD21                     int  33
  5309                                  
  5310                                  ;-264 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5311 00002044 C9                       LEAVE
  5312 00002045 C3                       ret
  5313                                  ; ENDP
  5314                                  ;Number of CALLs:    5 : exitR
  5315                                  
  5316                                  exitR:  ; *** PROC ***
  5317                                  ;Function : exitR, Number of local variables: 1
  5318                                  ;   # type sign width line used address name   list of local variables
  5319                                  ;  200 var sign byte   264 NULL bp+4    c;
  5320 00002046 C8000000                 ENTER  0,0
  5321 0000204A B44C                     mov  ah, 76
  5322 0000204C 8A4604                   mov  al, [bp+4]
  5323 0000204F CD21                     int  33
  5324                                  
  5325                                  ;-265 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5326 00002051 C9                       LEAVE
  5327 00002052 C3                       ret
  5328                                  ; ENDP
  5329                                  ;End of archive file. 
  5330                                   
  5331                                  ; missing functions: 
  5332                                  ; putch
  5333                                  ; DosInt
  5334                                  ; DosInt
  5335                                  ; DosInt
  5336                                  ; DosInt
  5337                                  ; Number of unresolved CALLs :    5
  5338                                  ;use archive file: AR.C
  5339                                  
  5340                                  ;-266 // AR.C Archive
  5341                                  
  5342                                  ;Number of CALLs:    1 : putch
  5343                                  
  5344                                  putch:  ; *** PROC ***
  5345                                  ;Function : putch, Number of local variables: 1
  5346                                  ;   # type sign width line used address name   list of local variables
  5347                                  ;  200 var sign byte   266 NULL bp+4    c;
  5348 00002053 C8000000                 ENTER  0,0
  5349 00002057 807E040A                cmp byte [bp+4], 10
  5350 0000205B 0F850500                 jne @@putch234
  5351 0000205F B00D                     mov  al, 13
  5352 00002061 E884FD                   call writetty
  5353                                  @@putch234:
  5354 00002064 8A4604                   mov  al, [bp+4]
  5355 00002067 E87EFD                   call writetty
  5356                                  
  5357                                  ;-267 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5358 0000206A C9                       LEAVE
  5359 0000206B C3                       ret
  5360                                  ; ENDP
  5361                                  ;Number of CALLs:    4 : DosInt
  5362                                  
  5363                                  DosInt:  ; *** PROC ***
  5364 0000206C CD21                     int  33
  5365 0000206E 7304                     jae short @@DosInt235
  5366 00002070 FF06[2F00]               inc  word [DOS_ERR]
  5367                                  @@DosInt235:
  5368                                  
  5369                                  ;-268 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5370                                  
  5371 00002074 C3                       ret
  5372                                  ; ENDP
  5373                                  ;End of archive file. 
  5374                                   
  5375                                  ; missing functions:  All FUNCTIONs in place
  5376 00002075 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5377 00002078 58                      pop ax
  5378 00002079 C3                      ret
  5379                                   
  5380                                  ;   # type sign width line used  address name   list of global variables
  5381                                  
  5382                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5383                                  ;    2 var sign byte     3    3        0 LIST
  5384                                  ;    3 arr sign byte     4    7    30000 Symbol[80]
  5385                                  ;    4 arr sign byte     4   36    30080 SymbolUpper[80]
  5386                                  ;    5 var unsg word     4   12        0 SymbolInt
  5387                                  ;    6 arr sign byte     5    3    30160 InputBuf[128]
  5388                                  ;    7 ptr unsg byte     5   23        0 InputPtr
  5389                                  ;    8 arr sign byte     6    5    30288 namein[67]
  5390                                  ;    9 arr sign byte     6    5    30355 namelst[67]
  5391                                  ;   10 arr sign byte     6    5    30422 namebin[67]
  5392                                  ;   11 var sign word     7    4        0 asm_fd
  5393                                  ;   12 var sign word     7    3        0 lst_fd
  5394                                  ;   13 var sign word     7    3        0 bin_fd
  5395                                  ;   14 var sign word     8    6        0 DOS_ERR
  5396                                  ;   15 var sign word     8    4        0 ErrorCount
  5397                                  ;   16 var sign word     9    4        0 DOS_NoBytes
  5398                                  ;   17 var sign byte     9    4        0 DOS_ByteRead
  5399                                  ;   18 var unsg word    11    5        0 PC
  5400                                  ;   19 var unsg word    12    2        0 PCStart
  5401                                  ;   20 var sign byte    13    3        0 isLabel
  5402                                  ;   21 def unsg byte    14    -        0 LABEL=1
  5403                                  ;   22 def unsg byte    15    -        0 VARIABLE=2
  5404                                  ;   23 def unsg byte    16    -        0 DIGIT=1
  5405                                  ;   24 def unsg byte    17    -        0 ALNUM=2
  5406                                  ;   25 var sign byte    18   20        0 TokeType
  5407                                  ;   26 def unsg byte    19    -        0 BYTE=1
  5408                                  ;   27 def unsg byte    20    -        0 WORD=2
  5409                                  ;   28 def unsg byte    21    -        0 DWORD=3
  5410                                  ;   29 def unsg byte    22    -        0 SEGREG=4
  5411                                  ;   30 def unsg byte    24    -        0 IMM=1
  5412                                  ;   31 def unsg byte    25    -        0 REG=2
  5413                                  ;   32 def unsg byte    26    -        0 DIR=3
  5414                                  ;   33 def unsg byte    27    -        0 IND=4
  5415                                  ;   34 var sign byte    28   13        0 Op1
  5416                                  ;   35 var sign word    29   12        0 CodeType
  5417                                  ;   36 var sign byte    31   17        0 RegType
  5418                                  ;   37 var sign byte    32   10        0 RegNo
  5419                                  ;   38 var sign byte    33   10        0 OpSize
  5420                                  ;   39 var sign byte    35 NULL        0 NumOprns
  5421                                  ;   40 var sign byte    36    5        0 wflag
  5422                                  ;   41 var sign byte    37 NULL        0 dflag
  5423                                  ;   42 var sign byte    39    4        0 reg
  5424                                  ;   43 var sign word    40   13        0 disp
  5425                                  ;   44 var sign word    41    2        0 imme
  5426                                  ;   45 def unsg byte    43    -        0 OPMAXLEN=5
  5427                                  ;   46 arr sign byte    44    2    30489 OpPos[5]
  5428                                  ;   47 var sign word    45    6        0 OpPrintIndex
  5429                                  ;   48 ptr sign byte    46   16        0 OpCodePtr
  5430                                  ;   49 var sign byte    47    2        0 PrReloc
  5431                                  ;   50 arr sign byte    48    3    30494 LabelNames[1000]
  5432                                  ;   51 ptr sign byte    48   10        0 LabelNamePtr
  5433                                  ;   52 arr sign byte    49    1    31494 LabelType[100]
  5434                                  ;   53 arr unsg word    49    4    31594 LabelAddr[100]
  5435                                  ;   54 var sign word    50    6        0 LabelMaxIx
  5436                                  ;   55 var sign word    50    4        0 LabelIx
  5437                                  ;   56 arr sign byte    51    3    31794 FileBin[2000]
  5438                                  ;   57 var unsg word    51    5        0 BinLen
  5439                                  ;   58 var sign byte   186    1        0 I_START
  5440                                  ;   59 arr sign byte   188 NULL        0 I_PUSHA[9]
  5441                                  ;   60 arr sign byte   189 NULL        0 I_POPA[8]
  5442                                  ;   61 arr sign byte   190 NULL        0 I_NOP[7]
  5443                                  ;   62 arr sign byte   191 NULL        0 I_CBW[7]
  5444                                  ;   63 arr sign byte   192 NULL        0 I_CWDE[8]
  5445                                  ;   64 arr sign byte   193 NULL        0 I_CWD[7]
  5446                                  ;   65 arr sign byte   194 NULL        0 I_CDQ[7]
  5447                                  ;   66 arr sign byte   195 NULL        0 I_WAIT[8]
  5448                                  ;   67 arr sign byte   196 NULL        0 I_PUSHF[9]
  5449                                  ;   68 arr sign byte   197 NULL        0 I_POPF[8]
  5450                                  ;   69 arr sign byte   198 NULL        0 I_SAHF[8]
  5451                                  ;   70 arr sign byte   199 NULL        0 I_LAHF[8]
  5452                                  ;   71 arr sign byte   200 NULL        0 I_MOVSB[9]
  5453                                  ;   72 arr sign byte   201 NULL        0 I_MOVSW[9]
  5454                                  ;   73 arr sign byte   202 NULL        0 I_CMPSB[9]
  5455                                  ;   74 arr sign byte   203 NULL        0 I_CMPSW[9]
  5456                                  ;   75 arr sign byte   204 NULL        0 I_STOSB[9]
  5457                                  ;   76 arr sign byte   205 NULL        0 I_STOSW[9]
  5458                                  ;   77 arr sign byte   206 NULL        0 I_LODSB[9]
  5459                                  ;   78 arr sign byte   207 NULL        0 I_LODSW[9]
  5460                                  ;   79 arr sign byte   208 NULL        0 I_SCASB[9]
  5461                                  ;   80 arr sign byte   209 NULL        0 I_SCASW[9]
  5462                                  ;   81 arr sign byte   210 NULL        0 I_LEAVE[9]
  5463                                  ;   82 arr sign byte   211 NULL        0 I_IRET[8]
  5464                                  ;   83 arr sign byte   212 NULL        0 I_XLAT[8]
  5465                                  ;   84 arr sign byte   213 NULL        0 I_LOCK[8]
  5466                                  ;   85 arr sign byte   214 NULL        0 I_REPNE[9]
  5467                                  ;   86 arr sign byte   215 NULL        0 I_REPNZ[9]
  5468                                  ;   87 arr sign byte   216 NULL        0 I_REPE[8]
  5469                                  ;   88 arr sign byte   217 NULL        0 I_REPZ[8]
  5470                                  ;   89 arr sign byte   218 NULL        0 I_HLT[7]
  5471                                  ;   90 arr sign byte   219 NULL        0 I_CLC[7]
  5472                                  ;   91 arr sign byte   220 NULL        0 I_STC[7]
  5473                                  ;   92 arr sign byte   221 NULL        0 I_CLI[7]
  5474                                  ;   93 arr sign byte   222 NULL        0 I_STI[7]
  5475                                  ;   94 arr sign byte   223 NULL        0 I_CLD[7]
  5476                                  ;   95 arr sign byte   224 NULL        0 I_STD[7]
  5477                                  ;   96 arr sign byte   226 NULL        0 I_INC[9]
  5478                                  ;   97 arr sign byte   227 NULL        0 I_DEC[9]
  5479                                  ;   98 arr sign byte   229 NULL        0 I_NOT[8]
  5480                                  ;   99 arr sign byte   230 NULL        0 I_NEG[8]
  5481                                  ;  100 arr sign byte   231 NULL        0 I_MUL[8]
  5482                                  ;  101 arr sign byte   232 NULL        0 I_IMUL[9]
  5483                                  ;  102 arr sign byte   233 NULL        0 I_DIV[8]
  5484                                  ;  103 arr sign byte   234 NULL        0 I_IDIV[9]
  5485                                  ;  104 arr sign byte   236 NULL        0 I_LES[7]
  5486                                  ;  105 arr sign byte   237 NULL        0 I_LDS[7]
  5487                                  ;  106 arr sign byte   238 NULL        0 I_LEA[7]
  5488                                  ;  107 arr sign byte   240 NULL        0 I_ADD[7]
  5489                                  ;  108 arr sign byte   241 NULL        0 I_OR[6]
  5490                                  ;  109 arr sign byte   242 NULL        0 I_ADC[7]
  5491                                  ;  110 arr sign byte   243 NULL        0 I_SBB[7]
  5492                                  ;  111 arr sign byte   244 NULL        0 I_AND[7]
  5493                                  ;  112 arr sign byte   245 NULL        0 I_SUB[7]
  5494                                  ;  113 arr sign byte   246 NULL        0 I_XOR[7]
  5495                                  ;  114 arr sign byte   247 NULL        0 I_CMP[7]
  5496                                  ;  115 arr sign byte   249 NULL        0 I_MOV[6]
  5497                                  ;  116 arr sign byte   251 NULL        0 I_JO[6]
  5498                                  ;  117 arr sign byte   252 NULL        0 I_JNO[7]
  5499                                  ;  118 arr sign byte   253 NULL        0 I_JB[6]
  5500                                  ;  119 arr sign byte   254 NULL        0 I_JC[6]
  5501                                  ;  120 arr sign byte   255 NULL        0 I_JNB[7]
  5502                                  ;  121 arr sign byte   256 NULL        0 I_JAE[7]
  5503                                  ;  122 arr sign byte   257 NULL        0 I_JNC[7]
  5504                                  ;  123 arr sign byte   258 NULL        0 I_JE[6]
  5505                                  ;  124 arr sign byte   259 NULL        0 I_JZ[6]
  5506                                  ;  125 arr sign byte   260 NULL        0 I_JNE[7]
  5507                                  ;  126 arr sign byte   261 NULL        0 I_JNZ[7]
  5508                                  ;  127 arr sign byte   262 NULL        0 I_JBE[7]
  5509                                  ;  128 arr sign byte   263 NULL        0 I_JNA[7]
  5510                                  ;  129 arr sign byte   264 NULL        0 I_JA[6]
  5511                                  ;  130 arr sign byte   265 NULL        0 I_JS[6]
  5512                                  ;  131 arr sign byte   266 NULL        0 I_JNS[7]
  5513                                  ;  132 arr sign byte   267 NULL        0 I_JP[6]
  5514                                  ;  133 arr sign byte   268 NULL        0 I_JPE[7]
  5515                                  ;  134 arr sign byte   269 NULL        0 I_JNP[7]
  5516                                  ;  135 arr sign byte   270 NULL        0 I_JPO[7]
  5517                                  ;  136 arr sign byte   271 NULL        0 I_JL[6]
  5518                                  ;  137 arr sign byte   272 NULL        0 I_JNL[7]
  5519                                  ;  138 arr sign byte   273 NULL        0 I_JGE[7]
  5520                                  ;  139 arr sign byte   274 NULL        0 I_JLE[7]
  5521                                  ;  140 arr sign byte   275 NULL        0 I_JNG[7]
  5522                                  ;  141 arr sign byte   276 NULL        0 I_JG[6]
  5523                                  ;  142 arr sign byte   278 NULL        0 I_RET[8]
  5524                                  ;  143 arr sign byte   280 NULL        0 I_PUSH[8]
  5525                                  ;  144 arr sign byte   281 NULL        0 I_POP[7]
  5526                                  ;  145 arr sign byte   283 NULL        0 I_ORG[6]
  5527                                  ;  146 arr sign byte   284 NULL        0 I_DB[5]
  5528                                  ;  147 arr sign byte   285 NULL        0 I_DW[5]
  5529                                  ;  148 arr sign byte   286 NULL        0 I_DD[5]
  5530                                  ;  149 arr sign byte   287 NULL        0 I_RESB[7]
  5531                                  ;  150 arr sign byte   288 NULL        0 I_RESW[7]
  5532                                  ;  151 arr sign byte   289 NULL        0 I_RESD[7]
  5533                                  ;  152 var sign byte   290 NULL        0 I_END
  5534                                  ;  153 ptr sign byte   379    1        0 arglen
  5535                                  ;  154 ptr sign byte   379    4        0 argv
  5536                                  
  5537                                  
  5538                                  ;   # Calls Line Width  Name   list of functions
  5539                                  
  5540                                  ;    0 NULL    1 word   main
  5541                                  ;    1    1   53 word   process
  5542                                  ;    2   12   86 word   setTokeType
  5543                                  ;    3 NULL   95 word   Ops
  5544                                  ;    4    2  106 word   LeftOpwCheck
  5545                                  ;    5    1  116 word   getLeftOp
  5546                                  ;    6    1  128 word   setwflag
  5547                                  ;    7    2  136 word   getOp1
  5548                                  ;    8    1  148 word   getIND
  5549                                  ;    9    1  163 word   getIndReg1
  5550                                  ;   10    1  172 word   getIndReg2
  5551                                  ;   11    1  182 word   getCodeSize
  5552                                  ;   12    7  189 word   isToken
  5553                                  ;   13    1  198 word   skipRest
  5554                                  ;   14    1  202 word   gen66h
  5555                                  ;   15    8  203 word   genCode8
  5556                                  ;   16    3  207 word   genCode16
  5557                                  ;   17    7  210 word   genInstruction
  5558                                  ;   18    2  214 word   genCodeInREG
  5559                                  ;   19 NULL  217 word   genModRegRM
  5560                                  ;   20    2  219 word   writeEA
  5561                                  ;   21 NULL  233 word   test1
  5562                                  ;   22    1    2 word   parse
  5563                                  ;   23    2   27 word   storeLabel
  5564                                  ;   24    2   35 word   searchLabel
  5565                                  ;   25    1   46 word   getVariable
  5566                                  ;   26    1   76 word   letterX
  5567                                  ;   27 NULL   85 word   alnumX
  5568                                  ;   28    1   90 word   getLine
  5569                                  ;   29    1  103 word   ifEOL
  5570                                  ;   30    3  110 word   skipBlank
  5571                                  ;   31    1  115 word   getDigit
  5572                                  ;   32    1  127 word   getName
  5573                                  ;   33    1  144 word   testReg
  5574                                  ;   34    2  292 word   lookCode
  5575                                  ;   35    1  307 word   printLine
  5576                                  ;   36    9  325 word   prc
  5577                                  ;   37    1  329 word   prscomment
  5578                                  ;   38   24  332 word   prs
  5579                                  ;   39    4  337 word   printhex8a
  5580                                  ;   40    2  341 word   printhex16
  5581                                  ;   41    3  344 word   printIntU
  5582                                  ;   42   19  363 word   error1
  5583                                  ;   43 NULL  366 word   allowederror
  5584                                  ;   44 NULL  367 word   implmerror
  5585                                  ;   45    4  368 word   indexerror
  5586                                  ;   46    1  369 word   numbererror
  5587                                  ;   47 NULL  370 word   regmemerror
  5588                                  ;   48    1  371 word   segregerror
  5589                                  ;   49    1  372 word   syntaxerror
  5590                                  ;   50    7  374 word   errorexit
  5591                                  ;   51    1  375 word   addrexit
  5592                                  ;   52 NULL  376 word   internexit
  5593                                  ;   53    1  380 word   getarg
  5594                                  ;   54    1  405 word   epilog
  5595                                  ;   55    2  440 word   end1
  5596                                  ;   56    4  243 word   writetty
  5597                                  ;   57    8  244 word   cputs
  5598                                  ;   58    2  245 word   toupper
  5599                                  ;   59    4  247 word   strlen
  5600                                  ;   60    6  248 word   strcpy
  5601                                  ;   61    5  250 word   digit
  5602                                  ;   62    2  251 word   alnum
  5603                                  ;   63   35  254 word   eqstr
  5604                                  ;   64    3  257 word   strcat1
  5605                                  ;   65    1  258 word   openR
  5606                                  ;   66    2  259 word   creatR
  5607                                  ;   67    2  260 word   readRL
  5608                                  ;   68    2  261 word   fputcR
  5609                                  ;   69    3  263 word   fcloseR
  5610                                  ;   70    5  264 word   exitR
  5611                                  ;   71    1  266 word   putch
  5612                                  ;   72    4  267 word   DosInt
  5613                                  ;   73 NULL  268 word   LastFunctionByt
  5614                                  
  5615                                  ;    #  addr name   list of CALLs
  5616                                  
  5617                                  ;    0     5 getarg
  5618                                  ;    1    12 parse
  5619                                  ;    2    18 epilog
  5620                                  ;    3    25 end1
  5621                                  ;    4   478 setTokeType
  5622                                  ;    5   490 getCodeSize
  5623                                  ;    6   502 genInstruction
  5624                                  ;    7   517 LeftOpwCheck
  5625                                  ;    8   530 genInstruction
  5626                                  ;    9   545 genInstruction
  5627                                  ;   10   560 genInstruction
  5628                                  ;   11   575 genCodeInREG
  5629                                  ;   12   588 LeftOpwCheck
  5630                                  ;   13   601 genInstruction
  5631                                  ;   14   616 genCodeInREG
  5632                                  ;   15   629 genInstruction
  5633                                  ;   16   644 genCode16
  5634                                  ;   17   654 genInstruction
  5635                                  ;   18   669 error1
  5636                                  ;   19   676 error1
  5637                                  ;   20   697 skipBlank
  5638                                  ;   21   707 digit
  5639                                  ;   22   713 getDigit
  5640                                  ;   23   722 alnum
  5641                                  ;   24   728 getName
  5642                                  ;   25   753 getLeftOp
  5643                                  ;   26   763 segregerror
  5644                                  ;   27   775 setwflag
  5645                                  ;   28   784 error1
  5646                                  ;   29   791 error1
  5647                                  ;   30   798 error1
  5648                                  ;   31   815 getOp1
  5649                                  ;   32   822 isToken
  5650                                  ;   33   830 getIND
  5651                                  ;   34   837 error1
  5652                                  ;   35   844 error1
  5653                                  ;   36   860 gen66h
  5654                                  ;   37   874 testReg
  5655                                  ;   38   882 searchLabel
  5656                                  ;   39   894 error1
  5657                                  ;   40   915 setTokeType
  5658                                  ;   41   927 getOp1
  5659                                  ;   42   934 syntaxerror
  5660                                  ;   43   946 getIndReg2
  5661                                  ;   44   957 getIndReg1
  5662                                  ;   45   968 isToken
  5663                                  ;   46   976 setTokeType
  5664                                  ;   47   988 numbererror
  5665                                  ;   48  1000 isToken
  5666                                  ;   49  1008 isToken
  5667                                  ;   50  1016 errorexit
  5668                                  ;   51  1039 indexerror
  5669                                  ;   52  1050 indexerror
  5670                                  ;   53  1077 indexerror
  5671                                  ;   54  1088 indexerror
  5672                                  ;   55  1111 eqstr
  5673                                  ;   56  1117 setTokeType
  5674                                  ;   57  1129 eqstr
  5675                                  ;   58  1135 setTokeType
  5676                                  ;   59  1147 eqstr
  5677                                  ;   60  1153 setTokeType
  5678                                  ;   61  1175 skipBlank
  5679                                  ;   62  1194 setTokeType
  5680                                  ;   63  1206 prs
  5681                                  ;   64  1217 genCode8
  5682                                  ;   65  1249 genCode8
  5683                                  ;   66  1258 genCode8
  5684                                  ;   67  1291 genCode8
  5685                                  ;   68  1315 writeEA
  5686                                  ;   69  1335 writeEA
  5687                                  ;   70  1359 addrexit
  5688                                  ;   71  1368 genCode8
  5689                                  ;   72  1377 genCode8
  5690                                  ;   73  1386 genCode16
  5691                                  ;   74  1408 getLine
  5692                                  ;   75  1416 setTokeType
  5693                                  ;   76  1428 storeLabel
  5694                                  ;   77  1439 setTokeType
  5695                                  ;   78  1451 lookCode
  5696                                  ;   79  1460 process
  5697                                  ;   80  1468 getVariable
  5698                                  ;   81  1480 skipRest
  5699                                  ;   82  1489 error1
  5700                                  ;   83  1496 error1
  5701                                  ;   84  1503 printLine
  5702                                  ;   85  1532 searchLabel
  5703                                  ;   86  1544 error1
  5704                                  ;   87  1551 strcpy
  5705                                  ;   88  1589 eqstr
  5706                                  ;   89  1595 strlen
  5707                                  ;   90  1616 storeLabel
  5708                                  ;   91  1627 setTokeType
  5709                                  ;   92  1639 lookCode
  5710                                  ;   93  1648 errorexit
  5711                                  ;   94  1658 errorexit
  5712                                  ;   95  1668 setTokeType
  5713                                  ;   96  1680 genCode8
  5714                                  ;   97  1689 skipBlank
  5715                                  ;   98  1699 isToken
  5716                                  ;   99  1707 genCode8
  5717                                  ;  100  1716 isToken
  5718                                  ;  101  1724 setTokeType
  5719                                  ;  102  1736 genCode16
  5720                                  ;  103  1746 isToken
  5721                                  ;  104  1754 errorexit
  5722                                  ;  105  1774 digit
  5723                                  ;  106  1789 digit
  5724                                  ;  107  1795 letterX
  5725                                  ;  108  1811 readRL
  5726                                  ;  109  1818 errorexit
  5727                                  ;  110  1828 ifEOL
  5728                                  ;  111  1842 readRL
  5729                                  ;  112  1878 digit
  5730                                  ;  113  1896 alnum
  5731                                  ;  114  1902 strcpy
  5732                                  ;  115  1909 toupper
  5733                                  ;  116  1925 strlen
  5734                                  ;  117  1932 strlen
  5735                                  ;  118  1939 eqstr
  5736                                  ;  119  1945 eqstr
  5737                                  ;  120  1951 eqstr
  5738                                  ;  121  1957 eqstr
  5739                                  ;  122  1963 eqstr
  5740                                  ;  123  1969 eqstr
  5741                                  ;  124  1975 eqstr
  5742                                  ;  125  1981 eqstr
  5743                                  ;  126  1987 eqstr
  5744                                  ;  127  1993 eqstr
  5745                                  ;  128  1999 eqstr
  5746                                  ;  129  2005 eqstr
  5747                                  ;  130  2011 eqstr
  5748                                  ;  131  2017 eqstr
  5749                                  ;  132  2023 eqstr
  5750                                  ;  133  2029 eqstr
  5751                                  ;  134  2035 eqstr
  5752                                  ;  135  2041 eqstr
  5753                                  ;  136  2047 eqstr
  5754                                  ;  137  2053 eqstr
  5755                                  ;  138  2059 eqstr
  5756                                  ;  139  2065 eqstr
  5757                                  ;  140  2071 eqstr
  5758                                  ;  141  2077 eqstr
  5759                                  ;  142  2083 eqstr
  5760                                  ;  143  2089 eqstr
  5761                                  ;  144  2095 eqstr
  5762                                  ;  145  2101 eqstr
  5763                                  ;  146  2107 eqstr
  5764                                  ;  147  2113 eqstr
  5765                                  ;  148  2733 eqstr
  5766                                  ;  149  2753 prs
  5767                                  ;  150  2757 printhex16
  5768                                  ;  151  2768 prs
  5769                                  ;  152  2772 prc
  5770                                  ;  153  2776 printhex8a
  5771                                  ;  154  2787 prc
  5772                                  ;  155  2791 prs
  5773                                  ;  156  2795 prscomment
  5774                                  ;  157  2812 writetty
  5775                                  ;  158  2821 writetty
  5776                                  ;  159  2830 fputcR
  5777                                  ;  160  2852 prc
  5778                                  ;  161  2868 prc
  5779                                  ;  162  2889 prc
  5780                                  ;  163  2893 prc
  5781                                  ;  164  2915 printhex8a
  5782                                  ;  165  2926 printhex8a
  5783                                  ;  166  2951 printIntU
  5784                                  ;  167  2961 prc
  5785                                  ;  168  2974 prs
  5786                                  ;  169  2978 prs
  5787                                  ;  170  2982 prs
  5788                                  ;  171  2986 prs
  5789                                  ;  172  3003 error1
  5790                                  ;  173  3021 error1
  5791                                  ;  174  3039 error1
  5792                                  ;  175  3058 error1
  5793                                  ;  176  3077 error1
  5794                                  ;  177  3096 error1
  5795                                  ;  178  3115 error1
  5796                                  ;  179  3134 error1
  5797                                  ;  180  3141 end1
  5798                                  ;  181  3155 errorexit
  5799                                  ;  182  3176 errorexit
  5800                                  ;  183  3217 cputs
  5801                                  ;  184  3223 cputs
  5802                                  ;  185  3229 exitR
  5803                                  ;  186  3235 toupper
  5804                                  ;  187  3243 strcpy
  5805                                  ;  188  3250 strcat1
  5806                                  ;  189  3258 strcpy
  5807                                  ;  190  3265 strcat1
  5808                                  ;  191  3273 strcpy
  5809                                  ;  192  3280 strcat1
  5810                                  ;  193  3288 openR
  5811                                  ;  194  3294 cputs
  5812                                  ;  195  3300 cputs
  5813                                  ;  196  3306 exitR
  5814                                  ;  197  3312 creatR
  5815                                  ;  198  3319 cputs
  5816                                  ;  199  3325 cputs
  5817                                  ;  200  3331 exitR
  5818                                  ;  201  3337 creatR
  5819                                  ;  202  3344 cputs
  5820                                  ;  203  3350 cputs
  5821                                  ;  204  3356 exitR
  5822                                  ;  205  3362 prs
  5823                                  ;  206  3366 prs
  5824                                  ;  207  3370 prs
  5825                                  ;  208  3374 prs
  5826                                  ;  209  3378 prs
  5827                                  ;  210  3382 prs
  5828                                  ;  211  3386 prs
  5829                                  ;  212  3390 prs
  5830                                  ;  213  3394 prs
  5831                                  ;  214  3411 prs
  5832                                  ;  215  3415 printIntU
  5833                                  ;  216  3425 prs
  5834                                  ;  217  3429 prs
  5835                                  ;  218  3433 prs
  5836                                  ;  219  3437 prc
  5837                                  ;  220  3441 printhex16
  5838                                  ;  221  3452 prs
  5839                                  ;  222  3456 strlen
  5840                                  ;  223  3463 prs
  5841                                  ;  224  3467 printIntU
  5842                                  ;  225  3477 prs
  5843                                  ;  226  3481 prc
  5844                                  ;  227  3485 printhex8a
  5845                                  ;  228  3496 fputcR
  5846                                  ;  229  3510 fcloseR
  5847                                  ;  230  3518 fcloseR
  5848                                  ;  231  3526 fcloseR
  5849                                  ;  232  3534 exitR
  5850                                  ;  233  3559 putch
  5851                                  ;  234  3613 digit
  5852                                  ;  235  3641 strcpy
  5853                                  ;  236  3656 DosInt
  5854                                  ;  237  3672 DosInt
  5855                                  ;  238  3695 DosInt
  5856                                  ;  239  3714 DosInt
  5857                                  ;  240  3748 writetty
  5858                                  ;  241  3757 writetty
  5859                                  ;Input: AS.C, List: AS.S,  Lines:  269
  5860                                  ;Glob. variables:  154 max.:  200
  5861                                  ;Local variables:    4 max.:  100, in 'searchLabel'
  5862                                  ;Functions      :   74 max.:  300
  5863                                  ;Calls          :  242 max.: 2000, NameField: 3789 max.:    65535
  5864                                  ;Code until     :26009 max.: 30000, free: 3991
  5865                                  ;Data (HeapEnd) :33794, resting stacksize: 31741
  5866                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
