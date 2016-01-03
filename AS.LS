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
    11 00000003 E81519                   call getarg
    12 00000006 E8EB08                   call parse
    13 00000009 E86D1B                   call epilog
    14 0000000C E8DA1C                   call end1
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
   428 00000147 E84C16                   call error1
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
   445 00000159 E83A16                   call error1
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
   476 00000189 E82A0B                   call skipBlank
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
   510 000001C7 E8291C                   call digit
   511 000001CA 83C402                   add  sp, 2
   512 000001CD 08C0                     or  al, al
   513 000001CF 0F841800                 je @@setTokeType13
   514 000001D3 8A46FE                   mov al, byte [bp-2]
   515 000001D6 B400                     mov ah, 0
   516 000001D8 50                       push ax
   517 000001D9 E8050B                   call getDigit
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
   529 000001F1 E8321C                   call alnum
   530 000001F4 83C402                   add  sp, 2
   531 000001F7 08C0                     or  al, al
   532 000001F9 0F841800                 je @@setTokeType14
   533 000001FD 8A46FE                   mov al, byte [bp-2]
   534 00000200 B400                     mov ah, 0
   535 00000202 50                       push ax
   536 00000203 E8320B                   call getName
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
   606 00000230 E85C16                   call segregerror
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
   620 00000245 E84E15                   call error1
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
   646 00000271 E82215                   call error1
   647 00000274 83C402                   add  sp, 2
   648                                  
   649                                  ;-114   if (RegType==0) error1("no register defined");
   650                                  
   651                                  @@LeftOpwCheck18:
   652 00000277 A0[3F00]                 mov al, [RegType]
   653 0000027A 3C00                     cmp al, 0
   654 0000027C 0F850900                 jne @@LeftOpwCheck20
   655 00000280 68[BA02]                 push LeftOpwCheck_2
   656 00000283 E81015                   call error1
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
   720 00000318 E87B14                   call error1
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
   757 00000358 E83B14                   call error1
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
   866 0000041C E8A509                   call testReg
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
   898 00000457 E83C13                   call error1
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
   954 000004AB E80814                   call syntaxerror
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
  1014 0000051E E82A13                   call numbererror
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
  1039 0000054E E87613                   call errorexit
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
  1071 0000057D E8AA12                   call indexerror
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
  1115 000005D1 E85612                   call indexerror
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
  1146 000005F2 E83512                   call indexerror
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
  1202 0000065E E8C911                   call indexerror
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
  1235 0000067A E82418                   call eqstr
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
  1249 0000069A E80418                   call eqstr
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
  1263 000006BA E8E417                   call eqstr
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
  1298 000006F0 E8C305                   call skipBlank
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
  1347 00000729 E80D0F                   call prs
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
  1539 0000082D E8AE10                   call addrexit
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
  1711 0000091B E8CB02                   call getLine
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
  1764 00000951 E85D0B                   call lookCode
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
  1795 00000978 E81B0E                   call error1
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
  1806 0000098D E8060E                   call error1
  1807 00000990 83C402                   add  sp, 2
  1808                                  
  1809                                  ;-24     printLine();
  1810                                  
  1811                                  @@parse92:
  1812                                  @@parse91:
  1813                                  @@parse89:
  1814 00000993 E8950B                   call printLine
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
  1856 000009FD E8960D                   call error1
  1857 00000A00 83C402                   add  sp, 2
  1858                                  
  1859                                  ;-29   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1860                                  
  1861                                  @@storeLabel94:
  1862 00000A03 8D063075                 lea  ax, [Symbol]
  1863 00000A07 50                       push ax
  1864 00000A08 FF36[4F00]               push word [LabelNamePtr]
  1865 00000A0C E8AB13                   call strcpy
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
  1934 00000A6E E83014                   call eqstr
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
  1945 00000A83 E80913                   call strlen
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
  1997 00000AC0 E8EE09                   call lookCode
  1998                                  
  1999                                  ;-50     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2000                                  
  2001 00000AC3 A1[3D00]                 mov ax, [CodeType]
  2002 00000AC6 3DC800                   cmp ax, 200
  2003 00000AC9 0F8D0900                 jge @@getVariable99
  2004 00000ACD 68[9B0B]                 push getVariable_0
  2005 00000AD0 E8F40D                   call errorexit
  2006 00000AD3 83C402                   add  sp, 2
  2007                                  
  2008                                  ;-51     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2009                                  
  2010                                  @@getVariable99:
  2011 00000AD6 A1[3D00]                 mov ax, [CodeType]
  2012 00000AD9 3DCF00                   cmp ax, 207
  2013 00000ADC 0F8E0900                 jle @@getVariable100
  2014 00000AE0 68[B30B]                 push getVariable_1
  2015 00000AE3 E8E10D                   call errorexit
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
  2046 00000B0C E8A701                   call skipBlank
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
  2155 00000B93 E8310D                   call errorexit
  2156 00000B96 83C402                   add  sp, 2
  2157                                  
  2158                                  ;-74 }
  2159                                  
  2160                                  @@getVariable113:
  2161                                  
  2162                                  ;-75 // helper functions XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  2163                                  
  2164                                  
  2165                                  ;-76 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
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
  2180                                  getLine:  ; *** PROC ***
  2181                                  
  2182                                  ;-77   InputPtr= &InputBuf;
  2183                                  
  2184 00000BE9 B8D075                   mov ax, InputBuf
  2185 00000BEC A3[2700]                 mov word [InputPtr], ax
  2186                                  
  2187                                  ;-78   *InputPtr=0;//if last line is empty
  2188                                  
  2189 00000BEF 66B800000000             mov eax, 0
  2190 00000BF5 8B1E[2700]               mov  bx, [InputPtr]
  2191 00000BF9 8807                     mov  [bx], al
  2192                                  
  2193                                  ;-79   do {
  2194                                  
  2195                                  @@getLine114:
  2196                                  
  2197                                  ;-80     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2198                                  
  2199 00000BFB 6A01                     push 1
  2200 00000BFD FF36[2900]               push word [asm_fd]
  2201 00000C01 8D06[3500]               lea  ax, [DOS_ByteRead]
  2202 00000C05 50                       push ax
  2203 00000C06 E83313                   call readRL
  2204 00000C09 83C406                   add  sp, 6
  2205 00000C0C A3[3300]                 mov word [DOS_NoBytes], ax
  2206                                  
  2207                                  ;-81     if (DOS_ERR) errorexit("Reading Source");
  2208                                  
  2209 00000C0F A1[2F00]                 mov ax, [DOS_ERR]
  2210 00000C12 08C0                     or  al, al
  2211 00000C14 0F840900                 je @@getLine115
  2212 00000C18 68[600C]                 push getLine_0
  2213 00000C1B E8A90C                   call errorexit
  2214 00000C1E 83C402                   add  sp, 2
  2215                                  
  2216                                  ;-82     if (DOS_NoBytes == 0) return;
  2217                                  
  2218                                  @@getLine115:
  2219 00000C21 A1[3300]                 mov ax, [DOS_NoBytes]
  2220 00000C24 83F800                   cmp ax, 0
  2221 00000C27 0F850300                 jne @@getLine116
  2222 00000C2B E93100                   jmp @@retn
  2223                                  
  2224                                  ;-83     *InputPtr = DOS_ByteRead; 
  2225                                  
  2226                                  @@getLine116:
  2227 00000C2E A0[3500]                 mov al, [DOS_ByteRead]
  2228 00000C31 8B1E[2700]               mov  bx, [InputPtr]
  2229 00000C35 8807                     mov  [bx], al
  2230                                  
  2231                                  ;-84     InputPtr++;
  2232                                  
  2233 00000C37 FF06[2700]               inc  word [InputPtr]
  2234                                  
  2235                                  ;-85   } while (ifEOL(DOS_ByteRead) == 0);
  2236                                  
  2237 00000C3B A0[3500]                 mov al, byte [DOS_ByteRead]
  2238 00000C3E B400                     mov ah, 0
  2239 00000C40 50                       push ax
  2240 00000C41 E82B00                   call ifEOL
  2241 00000C44 83C402                   add  sp, 2
  2242 00000C47 3C00                     cmp al, 0
  2243 00000C49 0F850200                 jne @@getLine117
  2244 00000C4D EBAC                     jmp @@getLine114
  2245                                  @@getLine117:
  2246                                  
  2247                                  ;-86   InputPtr--;
  2248                                  
  2249 00000C4F FF0E[2700]               dec  word [InputPtr]
  2250                                  
  2251                                  ;-87   *InputPtr=0;
  2252                                  
  2253 00000C53 66B800000000             mov eax, 0
  2254 00000C59 8B1E[2700]               mov  bx, [InputPtr]
  2255 00000C5D 8807                     mov  [bx], al
  2256                                  
  2257                                  ;-88 }
  2258                                  
  2259                                  
  2260                                  ;-89 int ifEOL(char c) {
  2261                                  
  2262                                  @@retn:
  2263 00000C5F C3                       ret
  2264                                  ; ENDP
  2265 00000C60 52656164696E672053-     getLine_0 db "Reading Source",0
  2266 00000C69 6F7572636500       
  2267                                  
  2268                                  ifEOL:  ; *** PROC ***
  2269                                  
  2270                                  ;-90   if (c == 10) return 1;
  2271                                  
  2272                                  ;Function : ifEOL, Number of local variables: 1
  2273                                  ;   # type sign width line used address name   list of local variables
  2274                                  ;  200 var sign byte    89 NULL bp+4    c;
  2275 00000C6F C8000000                 ENTER  0,0
  2276 00000C73 8A4604                   mov al, [bp+4]
  2277 00000C76 3C0A                     cmp al, 10
  2278 00000C78 0F850900                 jne @@ifEOL118
  2279 00000C7C 66B801000000             mov eax, 1
  2280 00000C82 E92F00                   jmp @@retn
  2281                                  
  2282                                  ;-91   if (c == 13) { 
  2283                                  
  2284                                  @@ifEOL118:
  2285 00000C85 8A4604                   mov al, [bp+4]
  2286 00000C88 3C0D                     cmp al, 13
  2287 00000C8A 0F851D00                 jne @@ifEOL119
  2288                                  
  2289                                  ;-92     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1); 
  2290                                  
  2291 00000C8E 6A01                     push 1
  2292 00000C90 FF36[2900]               push word [asm_fd]
  2293 00000C94 8D06[3500]               lea  ax, [DOS_ByteRead]
  2294 00000C98 50                       push ax
  2295 00000C99 E8A012                   call readRL
  2296 00000C9C 83C406                   add  sp, 6
  2297 00000C9F A3[3300]                 mov word [DOS_NoBytes], ax
  2298                                  
  2299                                  ;-93     return 1;}
  2300                                  
  2301 00000CA2 66B801000000             mov eax, 1
  2302 00000CA8 E90900                   jmp @@retn
  2303                                  
  2304                                  ;-94   return 0;
  2305                                  
  2306                                  @@ifEOL119:
  2307 00000CAB 66B800000000             mov eax, 0
  2308 00000CB1 E90000                   jmp @@retn
  2309                                  
  2310                                  ;-95 }
  2311                                  
  2312                                  
  2313                                  ;-96 int skipBlank() {
  2314                                  
  2315 00000CB4 C9                      @@retn: LEAVE
  2316 00000CB5 C3                       ret
  2317                                  ; ENDP
  2318                                  
  2319                                  skipBlank:  ; *** PROC ***
  2320                                  
  2321                                  ;-97   skipblank1:
  2322                                  
  2323                                  @@skipblank1:
  2324                                  
  2325                                  ;-98     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2326                                  
  2327 00000CB6 8B1E[2700]               mov bx, [InputPtr]
  2328 00000CBA 8A07                     mov al, [bx]
  2329 00000CBC B400                     mov ah, 0
  2330 00000CBE 83F820                   cmp ax, 32
  2331 00000CC1 0F850600                 jne @@skipBlank120
  2332 00000CC5 FF06[2700]               inc  word [InputPtr]
  2333 00000CC9 EBEB                     jmp @@skipblank1
  2334                                  
  2335                                  ;-99     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2336                                  
  2337                                  @@skipBlank120:
  2338 00000CCB 8B1E[2700]               mov bx, [InputPtr]
  2339 00000CCF 8A07                     mov al, [bx]
  2340 00000CD1 B400                     mov ah, 0
  2341 00000CD3 83F809                   cmp ax, 9
  2342 00000CD6 0F850600                 jne @@skipBlank121
  2343 00000CDA FF06[2700]               inc  word [InputPtr]
  2344 00000CDE EBD6                     jmp @@skipblank1
  2345                                  
  2346                                  ;-100 }
  2347                                  
  2348                                  @@skipBlank121:
  2349                                  
  2350                                  ;-101 int getDigit(unsigned char c) {//ret: SymbolInt
  2351                                  
  2352 00000CE0 C3                       ret
  2353                                  ; ENDP
  2354                                  
  2355                                  getDigit:  ; *** PROC ***
  2356                                  
  2357                                  ;-102   unsigned int CastInt;
  2358                                  
  2359                                  
  2360                                  ;-103   SymbolInt=0;
  2361                                  
  2362                                  ;Function : getDigit, Number of local variables: 2
  2363                                  ;   # type sign width line used address name   list of local variables
  2364                                  ;  200 var unsg byte   101 NULL bp+4    c
  2365                                  ;  201 var unsg word   102 NULL bp-2    CastInt;
  2366 00000CE1 C8020000                 ENTER  2,0
  2367 00000CE5 66B800000000             mov eax, 0
  2368 00000CEB A3[2500]                 mov word [SymbolInt], ax
  2369                                  
  2370                                  ;-104   do {
  2371                                  
  2372                                  @@getDigit122:
  2373                                  
  2374                                  ;-105     c-='0';
  2375                                  
  2376 00000CEE 806E0430                 sub  byte [bp+4], 48
  2377                                  
  2378                                  ;-106     SymbolInt=SymbolInt*10;
  2379                                  
  2380 00000CF2 A1[2500]                 mov ax, [SymbolInt]
  2381 00000CF5 66BB0A000000             mov ebx, 10
  2382 00000CFB 66F7E3                   mul ebx
  2383 00000CFE A3[2500]                 mov word [SymbolInt], ax
  2384                                  
  2385                                  ;-107     ax=0; CastInt=c; //cast b2w
  2386                                  
  2387 00000D01 B80000                   mov  ax, 0
  2388 00000D04 8A4604                   mov al, [bp+4]
  2389 00000D07 8946FE                   mov word [bp-2], ax
  2390                                  
  2391                                  ;-108     SymbolInt=SymbolInt+CastInt;
  2392                                  
  2393 00000D0A A1[2500]                 mov ax, [SymbolInt]
  2394 00000D0D 0346FE                   add ax, [bp-2]
  2395 00000D10 A3[2500]                 mov word [SymbolInt], ax
  2396                                  
  2397                                  ;-109     InputPtr++;
  2398                                  
  2399 00000D13 FF06[2700]               inc  word [InputPtr]
  2400                                  
  2401                                  ;-110     c = *InputPtr;
  2402                                  
  2403 00000D17 8B1E[2700]               mov bx, [InputPtr]
  2404 00000D1B 8A07                     mov al, [bx]
  2405 00000D1D B400                     mov ah, 0
  2406 00000D1F 884604                   mov byte [bp+4], al
  2407                                  
  2408                                  ;-111   } while(digit(c));
  2409                                  
  2410 00000D22 8A4604                   mov al, byte [bp+4]
  2411 00000D25 B400                     mov ah, 0
  2412 00000D27 50                       push ax
  2413 00000D28 E8C810                   call digit
  2414 00000D2B 83C402                   add  sp, 2
  2415 00000D2E 08C0                     or  al, al
  2416 00000D30 0F840200                 je @@getDigit123
  2417 00000D34 EBB8                     jmp @@getDigit122
  2418                                  @@getDigit123:
  2419                                  
  2420                                  ;-112 }
  2421                                  
  2422                                  
  2423                                  ;-113 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2424 00000D36 C9                       LEAVE
  2425 00000D37 C3                       ret
  2426                                  ; ENDP
  2427                                  
  2428                                  getName:  ; *** PROC ***
  2429                                  
  2430                                  ;-114   char *p;
  2431                                  
  2432                                  
  2433                                  ;-115   p = &Symbol;
  2434                                  
  2435                                  ;Function : getName, Number of local variables: 2
  2436                                  ;   # type sign width line used address name   list of local variables
  2437                                  ;  200 var unsg byte   113 NULL bp+4    c
  2438                                  ;  201 ptr sign byte   114 NULL bp-2    p;
  2439 00000D38 C8020000                 ENTER  2,0
  2440 00000D3C B83075                   mov ax, Symbol
  2441 00000D3F 8946FE                   mov word [bp-2], ax
  2442                                  
  2443                                  ;-116   *p = c;
  2444                                  
  2445 00000D42 8A4604                   mov al, [bp+4]
  2446 00000D45 8B5EFE                   mov  bx, [bp-2]
  2447 00000D48 8807                     mov  [bx], al
  2448                                  
  2449                                  ;-117   p++;
  2450                                  
  2451 00000D4A FF46FE                   inc  word [bp-2]
  2452                                  
  2453                                  ;-118   while (alnum(c)) {
  2454                                  
  2455                                  @@getName124:
  2456 00000D4D 8A4604                   mov al, byte [bp+4]
  2457 00000D50 B400                     mov ah, 0
  2458 00000D52 50                       push ax
  2459 00000D53 E8D010                   call alnum
  2460 00000D56 83C402                   add  sp, 2
  2461 00000D59 08C0                     or  al, al
  2462 00000D5B 0F841C00                 je @@getName125
  2463                                  
  2464                                  ;-119     InputPtr++;
  2465                                  
  2466 00000D5F FF06[2700]               inc  word [InputPtr]
  2467                                  
  2468                                  ;-120     c = *InputPtr;
  2469                                  
  2470 00000D63 8B1E[2700]               mov bx, [InputPtr]
  2471 00000D67 8A07                     mov al, [bx]
  2472 00000D69 B400                     mov ah, 0
  2473 00000D6B 884604                   mov byte [bp+4], al
  2474                                  
  2475                                  ;-121     *p = c;
  2476                                  
  2477 00000D6E 8A4604                   mov al, [bp+4]
  2478 00000D71 8B5EFE                   mov  bx, [bp-2]
  2479 00000D74 8807                     mov  [bx], al
  2480                                  
  2481                                  ;-122     p++;
  2482                                  
  2483 00000D76 FF46FE                   inc  word [bp-2]
  2484                                  
  2485                                  ;-123   }
  2486                                  
  2487                                  
  2488                                  ;-124   if (c == ':') isLabel=1; else isLabel=0;
  2489                                  
  2490 00000D79 EBD2                     jmp @@getName124
  2491                                  @@getName125:
  2492 00000D7B 8A4604                   mov al, [bp+4]
  2493 00000D7E 3C3A                     cmp al, 58
  2494 00000D80 0F850C00                 jne @@getName126
  2495 00000D84 66B801000000             mov eax, 1
  2496 00000D8A A2[3A00]                 mov byte [isLabel], al
  2497 00000D8D E90900                   jmp @@getName127
  2498                                  @@getName126:
  2499 00000D90 66B800000000             mov eax, 0
  2500 00000D96 A2[3A00]                 mov byte [isLabel], al
  2501                                  
  2502                                  ;-125   p--;
  2503                                  
  2504                                  @@getName127:
  2505 00000D99 FF4EFE                   dec  word [bp-2]
  2506                                  
  2507                                  ;-126   *p = 0;
  2508                                  
  2509 00000D9C 66B800000000             mov eax, 0
  2510 00000DA2 8B5EFE                   mov  bx, [bp-2]
  2511 00000DA5 8807                     mov  [bx], al
  2512                                  
  2513                                  ;-127   strcpy(SymbolUpper, Symbol);
  2514                                  
  2515 00000DA7 8D063075                 lea  ax, [Symbol]
  2516 00000DAB 50                       push ax
  2517 00000DAC 8D068075                 lea  ax, [SymbolUpper]
  2518 00000DB0 50                       push ax
  2519 00000DB1 E80610                   call strcpy
  2520 00000DB4 83C404                   add  sp, 4
  2521                                  
  2522                                  ;-128   toupper(SymbolUpper);
  2523                                  
  2524 00000DB7 8D068075                 lea  ax, [SymbolUpper]
  2525 00000DBB 50                       push ax
  2526 00000DBC E88D0F                   call toupper
  2527 00000DBF 83C402                   add  sp, 2
  2528                                  
  2529                                  ;-129 }
  2530                                  
  2531                                  
  2532                                  ;-130 int testReg() {
  2533 00000DC2 C9                       LEAVE
  2534 00000DC3 C3                       ret
  2535                                  ; ENDP
  2536                                  
  2537                                  testReg:  ; *** PROC ***
  2538                                  
  2539                                  ;-131 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2540                                  
  2541                                  
  2542                                  ;-132   RegType=0;
  2543                                  
  2544 00000DC4 66B800000000             mov eax, 0
  2545 00000DCA A2[3F00]                 mov byte [RegType], al
  2546                                  
  2547                                  ;-133   if (strlen(Symbol) < 2) return 0;
  2548                                  
  2549 00000DCD 8D063075                 lea  ax, [Symbol]
  2550 00000DD1 50                       push ax
  2551 00000DD2 E8BA0F                   call strlen
  2552 00000DD5 83C402                   add  sp, 2
  2553 00000DD8 3C02                     cmp al, 2
  2554 00000DDA 0F8D0900                 jge @@testReg128
  2555 00000DDE 66B800000000             mov eax, 0
  2556 00000DE4 E9B603                   jmp @@retn
  2557                                  
  2558                                  ;-134   if (strlen(Symbol) > 3) return 0;
  2559                                  
  2560                                  @@testReg128:
  2561 00000DE7 8D063075                 lea  ax, [Symbol]
  2562 00000DEB 50                       push ax
  2563 00000DEC E8A00F                   call strlen
  2564 00000DEF 83C402                   add  sp, 2
  2565 00000DF2 3C03                     cmp al, 3
  2566 00000DF4 0F8E0900                 jle @@testReg129
  2567 00000DF8 66B800000000             mov eax, 0
  2568 00000DFE E99C03                   jmp @@retn
  2569                                  
  2570                                  ;-135   RegType=BYTE;
  2571                                  
  2572                                  @@testReg129:
  2573 00000E01 66B801000000             mov eax, 1
  2574 00000E07 A2[3F00]                 mov byte [RegType], al
  2575                                  
  2576                                  ;-136   if (eqstr(SymbolUpper, "AL")) return 0;
  2577                                  
  2578 00000E0A 68[9E11]                 push testReg_0
  2579 00000E0D 8D068075                 lea  ax, [SymbolUpper]
  2580 00000E11 50                       push ax
  2581 00000E12 E88C10                   call eqstr
  2582 00000E15 83C404                   add  sp, 4
  2583 00000E18 08C0                     or  al, al
  2584 00000E1A 0F840900                 je @@testReg130
  2585 00000E1E 66B800000000             mov eax, 0
  2586 00000E24 E97603                   jmp @@retn
  2587                                  
  2588                                  ;-137   if (eqstr(SymbolUpper, "CL")) return 1;
  2589                                  
  2590                                  @@testReg130:
  2591 00000E27 68[A111]                 push testReg_1
  2592 00000E2A 8D068075                 lea  ax, [SymbolUpper]
  2593 00000E2E 50                       push ax
  2594 00000E2F E86F10                   call eqstr
  2595 00000E32 83C404                   add  sp, 4
  2596 00000E35 08C0                     or  al, al
  2597 00000E37 0F840900                 je @@testReg131
  2598 00000E3B 66B801000000             mov eax, 1
  2599 00000E41 E95903                   jmp @@retn
  2600                                  
  2601                                  ;-138   if (eqstr(SymbolUpper, "DL")) return 2;
  2602                                  
  2603                                  @@testReg131:
  2604 00000E44 68[A411]                 push testReg_2
  2605 00000E47 8D068075                 lea  ax, [SymbolUpper]
  2606 00000E4B 50                       push ax
  2607 00000E4C E85210                   call eqstr
  2608 00000E4F 83C404                   add  sp, 4
  2609 00000E52 08C0                     or  al, al
  2610 00000E54 0F840900                 je @@testReg132
  2611 00000E58 66B802000000             mov eax, 2
  2612 00000E5E E93C03                   jmp @@retn
  2613                                  
  2614                                  ;-139   if (eqstr(SymbolUpper, "BL")) return 3;
  2615                                  
  2616                                  @@testReg132:
  2617 00000E61 68[A711]                 push testReg_3
  2618 00000E64 8D068075                 lea  ax, [SymbolUpper]
  2619 00000E68 50                       push ax
  2620 00000E69 E83510                   call eqstr
  2621 00000E6C 83C404                   add  sp, 4
  2622 00000E6F 08C0                     or  al, al
  2623 00000E71 0F840900                 je @@testReg133
  2624 00000E75 66B803000000             mov eax, 3
  2625 00000E7B E91F03                   jmp @@retn
  2626                                  
  2627                                  ;-140   if (eqstr(SymbolUpper, "AH")) return 4;
  2628                                  
  2629                                  @@testReg133:
  2630 00000E7E 68[AA11]                 push testReg_4
  2631 00000E81 8D068075                 lea  ax, [SymbolUpper]
  2632 00000E85 50                       push ax
  2633 00000E86 E81810                   call eqstr
  2634 00000E89 83C404                   add  sp, 4
  2635 00000E8C 08C0                     or  al, al
  2636 00000E8E 0F840900                 je @@testReg134
  2637 00000E92 66B804000000             mov eax, 4
  2638 00000E98 E90203                   jmp @@retn
  2639                                  
  2640                                  ;-141   if (eqstr(SymbolUpper, "CH")) return 5;
  2641                                  
  2642                                  @@testReg134:
  2643 00000E9B 68[AD11]                 push testReg_5
  2644 00000E9E 8D068075                 lea  ax, [SymbolUpper]
  2645 00000EA2 50                       push ax
  2646 00000EA3 E8FB0F                   call eqstr
  2647 00000EA6 83C404                   add  sp, 4
  2648 00000EA9 08C0                     or  al, al
  2649 00000EAB 0F840900                 je @@testReg135
  2650 00000EAF 66B805000000             mov eax, 5
  2651 00000EB5 E9E502                   jmp @@retn
  2652                                  
  2653                                  ;-142   if (eqstr(SymbolUpper, "DH")) return 6;
  2654                                  
  2655                                  @@testReg135:
  2656 00000EB8 68[B011]                 push testReg_6
  2657 00000EBB 8D068075                 lea  ax, [SymbolUpper]
  2658 00000EBF 50                       push ax
  2659 00000EC0 E8DE0F                   call eqstr
  2660 00000EC3 83C404                   add  sp, 4
  2661 00000EC6 08C0                     or  al, al
  2662 00000EC8 0F840900                 je @@testReg136
  2663 00000ECC 66B806000000             mov eax, 6
  2664 00000ED2 E9C802                   jmp @@retn
  2665                                  
  2666                                  ;-143   if (eqstr(SymbolUpper, "BH")) return 7;
  2667                                  
  2668                                  @@testReg136:
  2669 00000ED5 68[B311]                 push testReg_7
  2670 00000ED8 8D068075                 lea  ax, [SymbolUpper]
  2671 00000EDC 50                       push ax
  2672 00000EDD E8C10F                   call eqstr
  2673 00000EE0 83C404                   add  sp, 4
  2674 00000EE3 08C0                     or  al, al
  2675 00000EE5 0F840900                 je @@testReg137
  2676 00000EE9 66B807000000             mov eax, 7
  2677 00000EEF E9AB02                   jmp @@retn
  2678                                  
  2679                                  ;-144   RegType=WORD;
  2680                                  
  2681                                  @@testReg137:
  2682 00000EF2 66B802000000             mov eax, 2
  2683 00000EF8 A2[3F00]                 mov byte [RegType], al
  2684                                  
  2685                                  ;-145   if (eqstr(SymbolUpper, "AX")) return 0;
  2686                                  
  2687 00000EFB 68[B611]                 push testReg_8
  2688 00000EFE 8D068075                 lea  ax, [SymbolUpper]
  2689 00000F02 50                       push ax
  2690 00000F03 E89B0F                   call eqstr
  2691 00000F06 83C404                   add  sp, 4
  2692 00000F09 08C0                     or  al, al
  2693 00000F0B 0F840900                 je @@testReg138
  2694 00000F0F 66B800000000             mov eax, 0
  2695 00000F15 E98502                   jmp @@retn
  2696                                  
  2697                                  ;-146   if (eqstr(SymbolUpper, "CX")) return 1;
  2698                                  
  2699                                  @@testReg138:
  2700 00000F18 68[B911]                 push testReg_9
  2701 00000F1B 8D068075                 lea  ax, [SymbolUpper]
  2702 00000F1F 50                       push ax
  2703 00000F20 E87E0F                   call eqstr
  2704 00000F23 83C404                   add  sp, 4
  2705 00000F26 08C0                     or  al, al
  2706 00000F28 0F840900                 je @@testReg139
  2707 00000F2C 66B801000000             mov eax, 1
  2708 00000F32 E96802                   jmp @@retn
  2709                                  
  2710                                  ;-147   if (eqstr(SymbolUpper, "DX")) return 2;
  2711                                  
  2712                                  @@testReg139:
  2713 00000F35 68[BC11]                 push testReg_10
  2714 00000F38 8D068075                 lea  ax, [SymbolUpper]
  2715 00000F3C 50                       push ax
  2716 00000F3D E8610F                   call eqstr
  2717 00000F40 83C404                   add  sp, 4
  2718 00000F43 08C0                     or  al, al
  2719 00000F45 0F840900                 je @@testReg140
  2720 00000F49 66B802000000             mov eax, 2
  2721 00000F4F E94B02                   jmp @@retn
  2722                                  
  2723                                  ;-148   if (eqstr(SymbolUpper, "BX")) return 3;
  2724                                  
  2725                                  @@testReg140:
  2726 00000F52 68[BF11]                 push testReg_11
  2727 00000F55 8D068075                 lea  ax, [SymbolUpper]
  2728 00000F59 50                       push ax
  2729 00000F5A E8440F                   call eqstr
  2730 00000F5D 83C404                   add  sp, 4
  2731 00000F60 08C0                     or  al, al
  2732 00000F62 0F840900                 je @@testReg141
  2733 00000F66 66B803000000             mov eax, 3
  2734 00000F6C E92E02                   jmp @@retn
  2735                                  
  2736                                  ;-149   if (eqstr(SymbolUpper, "SP")) return 4;
  2737                                  
  2738                                  @@testReg141:
  2739 00000F6F 68[C211]                 push testReg_12
  2740 00000F72 8D068075                 lea  ax, [SymbolUpper]
  2741 00000F76 50                       push ax
  2742 00000F77 E8270F                   call eqstr
  2743 00000F7A 83C404                   add  sp, 4
  2744 00000F7D 08C0                     or  al, al
  2745 00000F7F 0F840900                 je @@testReg142
  2746 00000F83 66B804000000             mov eax, 4
  2747 00000F89 E91102                   jmp @@retn
  2748                                  
  2749                                  ;-150   if (eqstr(SymbolUpper, "BP")) return 5;
  2750                                  
  2751                                  @@testReg142:
  2752 00000F8C 68[C511]                 push testReg_13
  2753 00000F8F 8D068075                 lea  ax, [SymbolUpper]
  2754 00000F93 50                       push ax
  2755 00000F94 E80A0F                   call eqstr
  2756 00000F97 83C404                   add  sp, 4
  2757 00000F9A 08C0                     or  al, al
  2758 00000F9C 0F840900                 je @@testReg143
  2759 00000FA0 66B805000000             mov eax, 5
  2760 00000FA6 E9F401                   jmp @@retn
  2761                                  
  2762                                  ;-151   if (eqstr(SymbolUpper, "SI")) return 6;
  2763                                  
  2764                                  @@testReg143:
  2765 00000FA9 68[C811]                 push testReg_14
  2766 00000FAC 8D068075                 lea  ax, [SymbolUpper]
  2767 00000FB0 50                       push ax
  2768 00000FB1 E8ED0E                   call eqstr
  2769 00000FB4 83C404                   add  sp, 4
  2770 00000FB7 08C0                     or  al, al
  2771 00000FB9 0F840900                 je @@testReg144
  2772 00000FBD 66B806000000             mov eax, 6
  2773 00000FC3 E9D701                   jmp @@retn
  2774                                  
  2775                                  ;-152   if (eqstr(SymbolUpper, "DI")) return 7;
  2776                                  
  2777                                  @@testReg144:
  2778 00000FC6 68[CB11]                 push testReg_15
  2779 00000FC9 8D068075                 lea  ax, [SymbolUpper]
  2780 00000FCD 50                       push ax
  2781 00000FCE E8D00E                   call eqstr
  2782 00000FD1 83C404                   add  sp, 4
  2783 00000FD4 08C0                     or  al, al
  2784 00000FD6 0F840900                 je @@testReg145
  2785 00000FDA 66B807000000             mov eax, 7
  2786 00000FE0 E9BA01                   jmp @@retn
  2787                                  
  2788                                  ;-153   RegType=SEGREG;
  2789                                  
  2790                                  @@testReg145:
  2791 00000FE3 66B804000000             mov eax, 4
  2792 00000FE9 A2[3F00]                 mov byte [RegType], al
  2793                                  
  2794                                  ;-154   if (eqstr(SymbolUpper, "ES")) return 0;
  2795                                  
  2796 00000FEC 68[CE11]                 push testReg_16
  2797 00000FEF 8D068075                 lea  ax, [SymbolUpper]
  2798 00000FF3 50                       push ax
  2799 00000FF4 E8AA0E                   call eqstr
  2800 00000FF7 83C404                   add  sp, 4
  2801 00000FFA 08C0                     or  al, al
  2802 00000FFC 0F840900                 je @@testReg146
  2803 00001000 66B800000000             mov eax, 0
  2804 00001006 E99401                   jmp @@retn
  2805                                  
  2806                                  ;-155   if (eqstr(SymbolUpper, "CS")) return 1;
  2807                                  
  2808                                  @@testReg146:
  2809 00001009 68[D111]                 push testReg_17
  2810 0000100C 8D068075                 lea  ax, [SymbolUpper]
  2811 00001010 50                       push ax
  2812 00001011 E88D0E                   call eqstr
  2813 00001014 83C404                   add  sp, 4
  2814 00001017 08C0                     or  al, al
  2815 00001019 0F840900                 je @@testReg147
  2816 0000101D 66B801000000             mov eax, 1
  2817 00001023 E97701                   jmp @@retn
  2818                                  
  2819                                  ;-156   if (eqstr(SymbolUpper, "SS")) return 2;
  2820                                  
  2821                                  @@testReg147:
  2822 00001026 68[D411]                 push testReg_18
  2823 00001029 8D068075                 lea  ax, [SymbolUpper]
  2824 0000102D 50                       push ax
  2825 0000102E E8700E                   call eqstr
  2826 00001031 83C404                   add  sp, 4
  2827 00001034 08C0                     or  al, al
  2828 00001036 0F840900                 je @@testReg148
  2829 0000103A 66B802000000             mov eax, 2
  2830 00001040 E95A01                   jmp @@retn
  2831                                  
  2832                                  ;-157   if (eqstr(SymbolUpper, "DS")) return 3;
  2833                                  
  2834                                  @@testReg148:
  2835 00001043 68[D711]                 push testReg_19
  2836 00001046 8D068075                 lea  ax, [SymbolUpper]
  2837 0000104A 50                       push ax
  2838 0000104B E8530E                   call eqstr
  2839 0000104E 83C404                   add  sp, 4
  2840 00001051 08C0                     or  al, al
  2841 00001053 0F840900                 je @@testReg149
  2842 00001057 66B803000000             mov eax, 3
  2843 0000105D E93D01                   jmp @@retn
  2844                                  
  2845                                  ;-158   if (eqstr(SymbolUpper, "FS")) return 4;
  2846                                  
  2847                                  @@testReg149:
  2848 00001060 68[DA11]                 push testReg_20
  2849 00001063 8D068075                 lea  ax, [SymbolUpper]
  2850 00001067 50                       push ax
  2851 00001068 E8360E                   call eqstr
  2852 0000106B 83C404                   add  sp, 4
  2853 0000106E 08C0                     or  al, al
  2854 00001070 0F840900                 je @@testReg150
  2855 00001074 66B804000000             mov eax, 4
  2856 0000107A E92001                   jmp @@retn
  2857                                  
  2858                                  ;-159   if (eqstr(SymbolUpper, "GS")) return 5;
  2859                                  
  2860                                  @@testReg150:
  2861 0000107D 68[DD11]                 push testReg_21
  2862 00001080 8D068075                 lea  ax, [SymbolUpper]
  2863 00001084 50                       push ax
  2864 00001085 E8190E                   call eqstr
  2865 00001088 83C404                   add  sp, 4
  2866 0000108B 08C0                     or  al, al
  2867 0000108D 0F840900                 je @@testReg151
  2868 00001091 66B805000000             mov eax, 5
  2869 00001097 E90301                   jmp @@retn
  2870                                  
  2871                                  ;-160   RegType=DWORD;
  2872                                  
  2873                                  @@testReg151:
  2874 0000109A 66B803000000             mov eax, 3
  2875 000010A0 A2[3F00]                 mov byte [RegType], al
  2876                                  
  2877                                  ;-161   if (eqstr(SymbolUpper, "EAX"))return 0;
  2878                                  
  2879 000010A3 68[E011]                 push testReg_22
  2880 000010A6 8D068075                 lea  ax, [SymbolUpper]
  2881 000010AA 50                       push ax
  2882 000010AB E8F30D                   call eqstr
  2883 000010AE 83C404                   add  sp, 4
  2884 000010B1 08C0                     or  al, al
  2885 000010B3 0F840900                 je @@testReg152
  2886 000010B7 66B800000000             mov eax, 0
  2887 000010BD E9DD00                   jmp @@retn
  2888                                  
  2889                                  ;-162   if (eqstr(SymbolUpper, "ECX"))return 1;
  2890                                  
  2891                                  @@testReg152:
  2892 000010C0 68[E411]                 push testReg_23
  2893 000010C3 8D068075                 lea  ax, [SymbolUpper]
  2894 000010C7 50                       push ax
  2895 000010C8 E8D60D                   call eqstr
  2896 000010CB 83C404                   add  sp, 4
  2897 000010CE 08C0                     or  al, al
  2898 000010D0 0F840900                 je @@testReg153
  2899 000010D4 66B801000000             mov eax, 1
  2900 000010DA E9C000                   jmp @@retn
  2901                                  
  2902                                  ;-163   if (eqstr(SymbolUpper, "EDX"))return 2;
  2903                                  
  2904                                  @@testReg153:
  2905 000010DD 68[E811]                 push testReg_24
  2906 000010E0 8D068075                 lea  ax, [SymbolUpper]
  2907 000010E4 50                       push ax
  2908 000010E5 E8B90D                   call eqstr
  2909 000010E8 83C404                   add  sp, 4
  2910 000010EB 08C0                     or  al, al
  2911 000010ED 0F840900                 je @@testReg154
  2912 000010F1 66B802000000             mov eax, 2
  2913 000010F7 E9A300                   jmp @@retn
  2914                                  
  2915                                  ;-164   if (eqstr(SymbolUpper, "EBX"))return 3;
  2916                                  
  2917                                  @@testReg154:
  2918 000010FA 68[EC11]                 push testReg_25
  2919 000010FD 8D068075                 lea  ax, [SymbolUpper]
  2920 00001101 50                       push ax
  2921 00001102 E89C0D                   call eqstr
  2922 00001105 83C404                   add  sp, 4
  2923 00001108 08C0                     or  al, al
  2924 0000110A 0F840900                 je @@testReg155
  2925 0000110E 66B803000000             mov eax, 3
  2926 00001114 E98600                   jmp @@retn
  2927                                  
  2928                                  ;-165   if (eqstr(SymbolUpper, "ESP"))return 4;
  2929                                  
  2930                                  @@testReg155:
  2931 00001117 68[F011]                 push testReg_26
  2932 0000111A 8D068075                 lea  ax, [SymbolUpper]
  2933 0000111E 50                       push ax
  2934 0000111F E87F0D                   call eqstr
  2935 00001122 83C404                   add  sp, 4
  2936 00001125 08C0                     or  al, al
  2937 00001127 0F840900                 je @@testReg156
  2938 0000112B 66B804000000             mov eax, 4
  2939 00001131 E96900                   jmp @@retn
  2940                                  
  2941                                  ;-166   if (eqstr(SymbolUpper, "EBP"))return 5;
  2942                                  
  2943                                  @@testReg156:
  2944 00001134 68[F411]                 push testReg_27
  2945 00001137 8D068075                 lea  ax, [SymbolUpper]
  2946 0000113B 50                       push ax
  2947 0000113C E8620D                   call eqstr
  2948 0000113F 83C404                   add  sp, 4
  2949 00001142 08C0                     or  al, al
  2950 00001144 0F840900                 je @@testReg157
  2951 00001148 66B805000000             mov eax, 5
  2952 0000114E E94C00                   jmp @@retn
  2953                                  
  2954                                  ;-167   if (eqstr(SymbolUpper, "ESI"))return 6;
  2955                                  
  2956                                  @@testReg157:
  2957 00001151 68[F811]                 push testReg_28
  2958 00001154 8D068075                 lea  ax, [SymbolUpper]
  2959 00001158 50                       push ax
  2960 00001159 E8450D                   call eqstr
  2961 0000115C 83C404                   add  sp, 4
  2962 0000115F 08C0                     or  al, al
  2963 00001161 0F840900                 je @@testReg158
  2964 00001165 66B806000000             mov eax, 6
  2965 0000116B E92F00                   jmp @@retn
  2966                                  
  2967                                  ;-168   if (eqstr(SymbolUpper, "EDI"))return 7;
  2968                                  
  2969                                  @@testReg158:
  2970 0000116E 68[FC11]                 push testReg_29
  2971 00001171 8D068075                 lea  ax, [SymbolUpper]
  2972 00001175 50                       push ax
  2973 00001176 E8280D                   call eqstr
  2974 00001179 83C404                   add  sp, 4
  2975 0000117C 08C0                     or  al, al
  2976 0000117E 0F840900                 je @@testReg159
  2977 00001182 66B807000000             mov eax, 7
  2978 00001188 E91200                   jmp @@retn
  2979                                  
  2980                                  ;-169   RegType=0; return 0;
  2981                                  
  2982                                  @@testReg159:
  2983 0000118B 66B800000000             mov eax, 0
  2984 00001191 A2[3F00]                 mov byte [RegType], al
  2985 00001194 66B800000000             mov eax, 0
  2986 0000119A E90000                   jmp @@retn
  2987                                  
  2988                                  ;-170 }
  2989                                  
  2990                                  
  2991                                  ;-171 // opcodes XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  2992                                  
  2993                                  
  2994                                  ;-172 char I_START=0xF1;//OpName,0,CodeType,OpCode1,OpCodeN,F1h
  2995                                  
  2996                                  @@retn:
  2997 0000119D C3                       ret
  2998                                  ; ENDP
  2999 0000119E 414C00                  testReg_0 db "AL",0
  3000 000011A1 434C00                  testReg_1 db "CL",0
  3001 000011A4 444C00                  testReg_2 db "DL",0
  3002 000011A7 424C00                  testReg_3 db "BL",0
  3003 000011AA 414800                  testReg_4 db "AH",0
  3004 000011AD 434800                  testReg_5 db "CH",0
  3005 000011B0 444800                  testReg_6 db "DH",0
  3006 000011B3 424800                  testReg_7 db "BH",0
  3007 000011B6 415800                  testReg_8 db "AX",0
  3008 000011B9 435800                  testReg_9 db "CX",0
  3009 000011BC 445800                  testReg_10 db "DX",0
  3010 000011BF 425800                  testReg_11 db "BX",0
  3011 000011C2 535000                  testReg_12 db "SP",0
  3012 000011C5 425000                  testReg_13 db "BP",0
  3013 000011C8 534900                  testReg_14 db "SI",0
  3014 000011CB 444900                  testReg_15 db "DI",0
  3015 000011CE 455300                  testReg_16 db "ES",0
  3016 000011D1 435300                  testReg_17 db "CS",0
  3017 000011D4 535300                  testReg_18 db "SS",0
  3018 000011D7 445300                  testReg_19 db "DS",0
  3019 000011DA 465300                  testReg_20 db "FS",0
  3020 000011DD 475300                  testReg_21 db "GS",0
  3021 000011E0 45415800                testReg_22 db "EAX",0
  3022 000011E4 45435800                testReg_23 db "ECX",0
  3023 000011E8 45445800                testReg_24 db "EDX",0
  3024 000011EC 45425800                testReg_25 db "EBX",0
  3025 000011F0 45535000                testReg_26 db "ESP",0
  3026 000011F4 45425000                testReg_27 db "EBP",0
  3027 000011F8 45534900                testReg_28 db "ESI",0
  3028 000011FC 45444900                testReg_29 db "EDI",0
  3029 00001200 F1                      I_START db 241
  3030                                  
  3031                                  ;-173 //  1:   1 byte opcode
  3032                                  
  3033                                  
  3034                                  ;-174 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
  3035                                  
  3036 00001201 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
  3037                                  
  3038                                  ;-175 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
  3039                                  
  3040 0000120A 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
  3041                                  
  3042                                  ;-176 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
  3043                                  
  3044 00001212 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
  3045                                  
  3046                                  ;-177 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
  3047                                  
  3048 00001219 434257000198F1          I_CBW db 67,66,87,0,1,152,241
  3049                                  
  3050                                  ;-178 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
  3051                                  
  3052 00001220 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
  3053                                  
  3054                                  ;-179 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
  3055                                  
  3056 00001228 435744000199F1          I_CWD db 67,87,68,0,1,153,241
  3057                                  
  3058                                  ;-180 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
  3059                                  
  3060 0000122F 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
  3061                                  
  3062                                  ;-181 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
  3063                                  
  3064 00001236 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
  3065                                  
  3066                                  ;-182 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
  3067                                  
  3068 0000123E 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
  3069                                  
  3070                                  ;-183 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
  3071                                  
  3072 00001247 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
  3073                                  
  3074                                  ;-184 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
  3075                                  
  3076 0000124F 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
  3077                                  
  3078                                  ;-185 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
  3079                                  
  3080 00001257 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
  3081                                  
  3082                                  ;-186 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
  3083                                  
  3084 0000125F 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
  3085                                  
  3086                                  ;-187 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
  3087                                  
  3088 00001268 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
  3089                                  
  3090                                  ;-188 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
  3091                                  
  3092 00001271 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
  3093                                  
  3094                                  ;-189 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
  3095                                  
  3096 0000127A 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
  3097                                  
  3098                                  ;-190 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
  3099                                  
  3100 00001283 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
  3101                                  
  3102                                  ;-191 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
  3103                                  
  3104 0000128C 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
  3105                                  
  3106                                  ;-192 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
  3107                                  
  3108 00001295 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
  3109                                  
  3110                                  ;-193 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
  3111                                  
  3112 0000129E 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
  3113                                  
  3114                                  ;-194 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
  3115                                  
  3116 000012A7 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
  3117                                  
  3118                                  ;-195 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
  3119                                  
  3120 000012B0 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
  3121                                  
  3122                                  ;-196 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
  3123                                  
  3124 000012B9 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
  3125                                  
  3126                                  ;-197 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
  3127                                  
  3128 000012C2 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
  3129                                  
  3130                                  ;-198 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
  3131                                  
  3132 000012CA 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
  3133                                  
  3134                                  ;-199 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
  3135                                  
  3136 000012D2 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
  3137                                  
  3138                                  ;-200 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
  3139                                  
  3140 000012DA 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
  3141                                  
  3142                                  ;-201 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
  3143                                  
  3144 000012E3 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
  3145                                  
  3146                                  ;-202 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
  3147                                  
  3148 000012EC 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
  3149                                  
  3150                                  ;-203 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
  3151                                  
  3152 000012F4 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
  3153                                  
  3154                                  ;-204 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
  3155                                  
  3156 000012FC 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
  3157                                  
  3158                                  ;-205 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
  3159                                  
  3160 00001303 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
  3161                                  
  3162                                  ;-206 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
  3163                                  
  3164 0000130A 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
  3165                                  
  3166                                  ;-207 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
  3167                                  
  3168 00001311 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
  3169                                  
  3170                                  ;-208 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
  3171                                  
  3172 00001318 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
  3173                                  
  3174                                  ;-209 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
  3175                                  
  3176 0000131F 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
  3177                                  
  3178                                  ;-210 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
  3179                                  
  3180 00001326 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
  3181                                  
  3182                                  ;-211 //  2: inc,dec
  3183                                  
  3184                                  
  3185                                  ;-212 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};
  3186                                  
  3187 0000132D 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
  3188                                  
  3189                                  ;-213 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};
  3190                                  
  3191 00001336 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
  3192                                  
  3193                                  ;-214 // 52: mem reg 16 bit
  3194                                  
  3195                                  
  3196                                  ;-215 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};
  3197                                  
  3198 0000133F 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
  3199                                  
  3200                                  ;-216 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};
  3201                                  
  3202 00001347 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
  3203                                  
  3204                                  ;-217 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};
  3205                                  
  3206 0000134F 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
  3207                                  
  3208                                  ;-218 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc
  3209                                  
  3210 00001357 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
  3211                                  
  3212                                  ;-219 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};
  3213                                  
  3214 00001360 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
  3215                                  
  3216                                  ;-220 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};
  3217                                  
  3218 00001368 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
  3219                                  
  3220                                  ;-221 //  3: les, lda, lea
  3221                                  
  3222                                  
  3223                                  ;-222 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16
  3224                                  
  3225 00001371 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
  3226                                  
  3227                                  ;-223 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16
  3228                                  
  3229 00001378 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
  3230                                  
  3231                                  ;-224 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16
  3232                                  
  3233 0000137F 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
  3234                                  
  3235                                  ;-225 //  4: acc,imm  reg,imm  index,reg
  3236                                  
  3237                                  
  3238                                  ;-226 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};
  3239                                  
  3240 00001386 414444000400F1          I_ADD db 65,68,68,0,4,0,241
  3241                                  
  3242                                  ;-227 char I_OR []={'O','R',0,                4, 1,     0xF1};
  3243                                  
  3244 0000138D 4F52000401F1            I_OR db 79,82,0,4,1,241
  3245                                  
  3246                                  ;-228 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};
  3247                                  
  3248 00001393 414443000402F1          I_ADC db 65,68,67,0,4,2,241
  3249                                  
  3250                                  ;-229 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};
  3251                                  
  3252 0000139A 534242000403F1          I_SBB db 83,66,66,0,4,3,241
  3253                                  
  3254                                  ;-230 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};
  3255                                  
  3256 000013A1 414E44000404F1          I_AND db 65,78,68,0,4,4,241
  3257                                  
  3258                                  ;-231 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};
  3259                                  
  3260 000013A8 535542000405F1          I_SUB db 83,85,66,0,4,5,241
  3261                                  
  3262                                  ;-232 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};
  3263                                  
  3264 000013AF 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
  3265                                  
  3266                                  ;-233 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};
  3267                                  
  3268 000013B6 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
  3269                                  
  3270                                  ;-234 //  5: mov
  3271                                  
  3272                                  
  3273                                  ;-235 char I_MOV[]={'M','O','V',0,            5,        0xF1};
  3274                                  
  3275 000013BD 4D4F560005F1            I_MOV db 77,79,86,0,5,241
  3276                                  
  3277                                  ;-236 //  6: single byte relative jump
  3278                                  
  3279                                  
  3280                                  ;-237 char I_JO []={'J','O',0,                6, 0,     0xF1};
  3281                                  
  3282 000013C3 4A4F000600F1            I_JO db 74,79,0,6,0,241
  3283                                  
  3284                                  ;-238 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};
  3285                                  
  3286 000013C9 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
  3287                                  
  3288                                  ;-239 char I_JB []={'J','B',0,                6, 2,     0xF1};
  3289                                  
  3290 000013D0 4A42000602F1            I_JB db 74,66,0,6,2,241
  3291                                  
  3292                                  ;-240 char I_JC []={'J','C',0,                6, 2,     0xF1};
  3293                                  
  3294 000013D6 4A43000602F1            I_JC db 74,67,0,6,2,241
  3295                                  
  3296                                  ;-241 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};
  3297                                  
  3298 000013DC 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
  3299                                  
  3300                                  ;-242 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};
  3301                                  
  3302 000013E3 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
  3303                                  
  3304                                  ;-243 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};
  3305                                  
  3306 000013EA 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
  3307                                  
  3308                                  ;-244 char I_JE []={'J','E',0,                6, 4,     0xF1};//      74 je i8 rel
  3309                                  
  3310 000013F1 4A45000604F1            I_JE db 74,69,0,6,4,241
  3311                                  
  3312                                  ;-245 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//   0F 84 je i16 rel
  3313                                  
  3314 000013F7 4A5A000604F1            I_JZ db 74,90,0,6,4,241
  3315                                  
  3316                                  ;-246 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//66 0F 84 je i32 rel
  3317                                  
  3318 000013FD 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
  3319                                  
  3320                                  ;-247 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};
  3321                                  
  3322 00001404 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
  3323                                  
  3324                                  ;-248 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};
  3325                                  
  3326 0000140B 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
  3327                                  
  3328                                  ;-249 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};
  3329                                  
  3330 00001412 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
  3331                                  
  3332                                  ;-250 char I_JA []={'J','A',0,                6, 7,     0xF1};
  3333                                  
  3334 00001419 4A41000607F1            I_JA db 74,65,0,6,7,241
  3335                                  
  3336                                  ;-251 char I_JS []={'J','S',0,                6, 8,     0xF1};
  3337                                  
  3338 0000141F 4A53000608F1            I_JS db 74,83,0,6,8,241
  3339                                  
  3340                                  ;-252 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};
  3341                                  
  3342 00001425 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
  3343                                  
  3344                                  ;-253 char I_JP[]={'J','P',0,                 6,10,     0xF1};
  3345                                  
  3346 0000142C 4A5000060AF1            I_JP db 74,80,0,6,10,241
  3347                                  
  3348                                  ;-254 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};
  3349                                  
  3350 00001432 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
  3351                                  
  3352                                  ;-255 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};
  3353                                  
  3354 00001439 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
  3355                                  
  3356                                  ;-256 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};
  3357                                  
  3358 00001440 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
  3359                                  
  3360                                  ;-257 char I_JL[]={'J','L',0,                 6,12,     0xF1};
  3361                                  
  3362 00001447 4A4C00060CF1            I_JL db 74,76,0,6,12,241
  3363                                  
  3364                                  ;-258 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};
  3365                                  
  3366 0000144D 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
  3367                                  
  3368                                  ;-259 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};
  3369                                  
  3370 00001454 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
  3371                                  
  3372                                  ;-260 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};
  3373                                  
  3374 0000145B 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
  3375                                  
  3376                                  ;-261 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};
  3377                                  
  3378 00001462 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
  3379                                  
  3380                                  ;-262 char I_JG []={'J','G',0,                6,15,     0xF1};
  3381                                  
  3382 00001469 4A4700060FF1            I_JG db 74,71,0,6,15,241
  3383                                  
  3384                                  ;-263 //  8: ret
  3385                                  
  3386                                  
  3387                                  ;-264 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
  3388                                  
  3389 0000146F 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
  3390                                  
  3391                                  ;-265 //  9: seg, r/m
  3392                                  
  3393                                  
  3394                                  ;-266 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16
  3395                                  
  3396 00001477 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
  3397                                  
  3398                                  ;-267 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16
  3399                                  
  3400 0000147F 504F50000958F1          I_POP db 80,79,80,0,9,88,241
  3401                                  
  3402                                  ;-268 //  100 directives
  3403                                  
  3404                                  
  3405                                  ;-269 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
  3406                                  
  3407 00001486 4F52470065F1            I_ORG db 79,82,71,0,101,241
  3408                                  
  3409                                  ;-270 char I_DB[]=   {'D','B',0,            200,        0xF1};
  3410                                  
  3411 0000148C 444200C8F1              I_DB db 68,66,0,200,241
  3412                                  
  3413                                  ;-271 char I_DW[]=   {'D','W',0,            201,        0xF1};
  3414                                  
  3415 00001491 445700C9F1              I_DW db 68,87,0,201,241
  3416                                  
  3417                                  ;-272 char I_DD[]=   {'D','D',0,            202,        0xF1};
  3418                                  
  3419 00001496 444400CAF1              I_DD db 68,68,0,202,241
  3420                                  
  3421                                  ;-273 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
  3422                                  
  3423 0000149B 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
  3424                                  
  3425                                  ;-274 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
  3426                                  
  3427 000014A2 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
  3428                                  
  3429                                  ;-275 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
  3430                                  
  3431 000014A9 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
  3432                                  
  3433                                  ;-276 char I_END=0;// end of table char
  3434                                  
  3435 000014B0 00                      I_END db 0
  3436                                  
  3437                                  ;-277 
  3438                                  
  3439                                  
  3440                                  ;-278 int lookCode() { // ret: CodeType, OpCodePtr
  3441                                  
  3442                                  
  3443                                  lookCode:  ; *** PROC ***
  3444                                  
  3445                                  ;-279   CodeType=0;
  3446                                  
  3447 000014B1 66B800000000             mov eax, 0
  3448 000014B7 A3[3D00]                 mov word [CodeType], ax
  3449                                  
  3450                                  ;-280   OpCodePtr= &I_START;
  3451                                  
  3452 000014BA B8[0012]                 mov ax, I_START
  3453 000014BD A3[4C00]                 mov word [OpCodePtr], ax
  3454                                  
  3455                                  ;-281   OpCodePtr++;
  3456                                  
  3457 000014C0 FF06[4C00]               inc  word [OpCodePtr]
  3458                                  
  3459                                  ;-282   do  {
  3460                                  
  3461                                  @@lookCode160:
  3462                                  
  3463                                  ;-283     if (eqstr(SymbolUpper, OpCodePtr))  {
  3464                                  
  3465 000014C4 FF36[4C00]               push word [OpCodePtr]
  3466 000014C8 8D068075                 lea  ax, [SymbolUpper]
  3467 000014CC 50                       push ax
  3468 000014CD E8D109                   call eqstr
  3469 000014D0 83C404                   add  sp, 4
  3470 000014D3 08C0                     or  al, al
  3471 000014D5 0F842700                 je @@lookCode161
  3472                                  
  3473                                  ;-284       while(*OpCodePtr!=0) OpCodePtr++;
  3474                                  
  3475                                  @@lookCode162:
  3476 000014D9 8B1E[4C00]               mov bx, [OpCodePtr]
  3477 000014DD 8A07                     mov al, [bx]
  3478 000014DF B400                     mov ah, 0
  3479 000014E1 83F800                   cmp ax, 0
  3480 000014E4 0F840600                 je  @@lookCode163
  3481 000014E8 FF06[4C00]               inc  word [OpCodePtr]
  3482                                  
  3483                                  ;-285       OpCodePtr++; CodeType =*OpCodePtr;
  3484                                  
  3485 000014EC EBEB                     jmp @@lookCode162
  3486                                  @@lookCode163:
  3487 000014EE FF06[4C00]               inc  word [OpCodePtr]
  3488 000014F2 8B1E[4C00]               mov bx, [OpCodePtr]
  3489 000014F6 8A07                     mov al, [bx]
  3490 000014F8 B400                     mov ah, 0
  3491 000014FA A3[3D00]                 mov word [CodeType], ax
  3492                                  
  3493                                  ;-286       return;
  3494                                  
  3495 000014FD E92A00                   jmp @@retn
  3496                                  
  3497                                  ;-287     }
  3498                                  
  3499                                  
  3500                                  ;-288   while(*OpCodePtr!=0xF1) OpCodePtr++;
  3501                                  
  3502                                  @@lookCode161:
  3503                                  @@lookCode164:
  3504 00001500 8B1E[4C00]               mov bx, [OpCodePtr]
  3505 00001504 8A07                     mov al, [bx]
  3506 00001506 B400                     mov ah, 0
  3507 00001508 3DF100                   cmp ax, 241
  3508 0000150B 0F840600                 je  @@lookCode165
  3509 0000150F FF06[4C00]               inc  word [OpCodePtr]
  3510                                  
  3511                                  ;-289   OpCodePtr++;
  3512                                  
  3513 00001513 EBEB                     jmp @@lookCode164
  3514                                  @@lookCode165:
  3515 00001515 FF06[4C00]               inc  word [OpCodePtr]
  3516                                  
  3517                                  ;-290   } while(*OpCodePtr!=0);
  3518                                  
  3519 00001519 8B1E[4C00]               mov bx, [OpCodePtr]
  3520 0000151D 8A07                     mov al, [bx]
  3521 0000151F B400                     mov ah, 0
  3522 00001521 83F800                   cmp ax, 0
  3523 00001524 0F840200                 je  @@lookCode166
  3524 00001528 EB9A                     jmp @@lookCode160
  3525                                  @@lookCode166:
  3526                                  
  3527                                  ;-291 }
  3528                                  
  3529                                  
  3530                                  ;-292 // string functions error epilog XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  3531                                  
  3532                                  
  3533                                  ;-293 int printLine() { int i; char c;
  3534                                  
  3535                                  @@retn:
  3536 0000152A C3                       ret
  3537                                  ; ENDP
  3538                                  
  3539                                  printLine:  ; *** PROC ***
  3540                                  
  3541                                  ;-294   prs("\n"); printhex16(PCStart);
  3542                                  
  3543                                  ;Function : printLine, Number of local variables: 2
  3544                                  ;   # type sign width line used address name   list of local variables
  3545                                  ;  200 var sign word   293 NULL bp-2    i
  3546                                  ;  201 var sign byte   293 NULL bp-4    c;
  3547 0000152B C8040000                 ENTER  4,0
  3548 0000152F 68[C015]                 push printLine_0
  3549 00001532 E80401                   call prs
  3550 00001535 83C402                   add  sp, 2
  3551 00001538 FF36[3800]               push word [PCStart]
  3552 0000153C E8EB01                   call printhex16
  3553 0000153F 83C402                   add  sp, 2
  3554                                  
  3555                                  ;-295   if (OpPrintIndex == 0) prs("                ");
  3556                                  
  3557 00001542 A1[4A00]                 mov ax, [OpPrintIndex]
  3558 00001545 83F800                   cmp ax, 0
  3559 00001548 0F850C00                 jne @@printLine167
  3560 0000154C 68[C315]                 push printLine_1
  3561 0000154F E8E700                   call prs
  3562 00001552 83C402                   add  sp, 2
  3563                                  
  3564                                  ;-296   else {
  3565                                  
  3566 00001555 E95B00                   jmp @@printLine168
  3567                                  @@printLine167:
  3568                                  
  3569                                  ;-297     prc(PrReloc);
  3570                                  
  3571 00001558 A0[4E00]                 mov al, byte [PrReloc]
  3572 0000155B B400                     mov ah, 0
  3573 0000155D 50                       push ax
  3574 0000155E E87700                   call prc
  3575 00001561 83C402                   add  sp, 2
  3576                                  
  3577                                  ;-298     i=0;
  3578                                  
  3579 00001564 66B800000000             mov eax, 0
  3580 0000156A 8946FE                   mov word [bp-2], ax
  3581                                  
  3582                                  ;-299     do {
  3583                                  
  3584                                  @@printLine169:
  3585                                  
  3586                                  ;-300       c=OpPos[i];
  3587                                  
  3588 0000156D 8B5EFE                   mov bx, [bp-2]
  3589 00001570 8A871977                 mov al, [OpPos + bx]
  3590 00001574 8846FC                   mov byte [bp-4], al
  3591                                  
  3592                                  ;-301       printhex8a(c); prc(' ');
  3593                                  
  3594 00001577 8A46FC                   mov al, byte [bp-4]
  3595 0000157A B400                     mov ah, 0
  3596 0000157C 50                       push ax
  3597 0000157D E85C01                   call printhex8a
  3598 00001580 83C402                   add  sp, 2
  3599 00001583 6A20                     push 32
  3600 00001585 E85000                   call prc
  3601 00001588 83C402                   add  sp, 2
  3602                                  
  3603                                  ;-302       i++;
  3604                                  
  3605 0000158B FF46FE                   inc  word [bp-2]
  3606                                  
  3607                                  ;-303     } while(i < OpPrintIndex);
  3608                                  
  3609 0000158E 8B46FE                   mov ax, [bp-2]
  3610 00001591 3B06[4A00]               cmp ax, [OpPrintIndex]
  3611 00001595 0F8D0200                 jge @@printLine170
  3612 00001599 EBD2                     jmp @@printLine169
  3613                                  @@printLine170:
  3614                                  
  3615                                  ;-304     do {// fill rest with blank
  3616                                  
  3617                                  @@printLine171:
  3618                                  
  3619                                  ;-305       prs("   ");
  3620                                  
  3621 0000159B 68[D415]                 push printLine_2
  3622 0000159E E89800                   call prs
  3623 000015A1 83C402                   add  sp, 2
  3624                                  
  3625                                  ;-306       i++;
  3626                                  
  3627 000015A4 FF46FE                   inc  word [bp-2]
  3628                                  
  3629                                  ;-307     } while(i < OPMAXLEN);
  3630                                  
  3631 000015A7 8B46FE                   mov ax, [bp-2]
  3632 000015AA 83F805                   cmp ax, 5
  3633 000015AD 0F8D0200                 jge @@printLine172
  3634 000015B1 EBE8                     jmp @@printLine171
  3635                                  @@printLine172:
  3636                                  
  3637                                  ;-308   }
  3638                                  
  3639                                  
  3640                                  ;-309   prscomment(InputBuf);
  3641                                  
  3642                                  @@printLine168:
  3643 000015B3 8D06D075                 lea  ax, [InputBuf]
  3644 000015B7 50                       push ax
  3645 000015B8 E85000                   call prscomment
  3646 000015BB 83C402                   add  sp, 2
  3647                                  
  3648                                  ;-310 }
  3649                                  
  3650                                  
  3651                                  ;-311 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  3652 000015BE C9                       LEAVE
  3653 000015BF C3                       ret
  3654                                  ; ENDP
  3655 000015C0 5C6E00                  printLine_0 db "\n",0
  3656 000015C3 202020202020202020-     printLine_1 db "                ",0
  3657 000015CC 2020202020202000   
  3658 000015D4 20202000                printLine_2 db "   ",0
  3659                                  
  3660                                  prc:  ; *** PROC ***
  3661                                  ;Function : prc, Number of local variables: 1
  3662                                  ;   # type sign width line used address name   list of local variables
  3663                                  ;  200 var unsg byte   311 NULL bp+4    c;
  3664 000015D8 C8000000                 ENTER  0,0
  3665 000015DC A0[2400]                 mov al, [LIST]
  3666 000015DF 08C0                     or  al, al
  3667 000015E1 0F841400                 je @@prc173
  3668 000015E5 807E040A                cmp byte [bp+4], 10
  3669 000015E9 0F850600                 jne @@prc174
  3670 000015ED B80D00                   mov  ax, 13
  3671 000015F0 E82307                   call writetty
  3672                                  
  3673                                  ;-312      al=c; writetty(); }
  3674                                  
  3675                                  @@prc174:
  3676 000015F3 8A4604                   mov  al, [bp+4]
  3677 000015F6 E81D07                   call writetty
  3678                                  
  3679                                  ;-313    fputcR(c,lst_fd); }
  3680                                  
  3681                                  @@prc173:
  3682 000015F9 FF36[2B00]               push word [lst_fd]
  3683 000015FD 8A4604                   mov al, byte [bp+4]
  3684 00001600 B400                     mov ah, 0
  3685 00001602 50                       push ax
  3686 00001603 E84B09                   call fputcR
  3687 00001606 83C404                   add  sp, 4
  3688                                  
  3689                                  ;-314 
  3690                                  
  3691                                  
  3692                                  ;-315 int prscomment(unsigned char *s) {unsigned char c;
  3693 00001609 C9                       LEAVE
  3694 0000160A C3                       ret
  3695                                  ; ENDP
  3696                                  
  3697                                  prscomment:  ; *** PROC ***
  3698                                  
  3699                                  ;-316   while(*s){c=*s;prc(c);s++;}
  3700                                  
  3701                                  ;Function : prscomment, Number of local variables: 2
  3702                                  ;   # type sign width line used address name   list of local variables
  3703                                  ;  200 ptr unsg byte   315 NULL bp+4    s
  3704                                  ;  201 var unsg byte   315 NULL bp-2    c;
  3705 0000160B C8020000                 ENTER  2,0
  3706                                  @@prscomment175:
  3707 0000160F 8B5E04                   mov bx, [bp+4]
  3708 00001612 8A07                     mov al, [bx]
  3709 00001614 B400                     mov ah, 0
  3710 00001616 08C0                     or  al, al
  3711 00001618 0F841B00                 je @@prscomment176
  3712 0000161C 8B5E04                   mov bx, [bp+4]
  3713 0000161F 8A07                     mov al, [bx]
  3714 00001621 B400                     mov ah, 0
  3715 00001623 8846FE                   mov byte [bp-2], al
  3716 00001626 8A46FE                   mov al, byte [bp-2]
  3717 00001629 B400                     mov ah, 0
  3718 0000162B 50                       push ax
  3719 0000162C E8A9FF                   call prc
  3720 0000162F 83C402                   add  sp, 2
  3721 00001632 FF4604                   inc  word [bp+4]
  3722                                  
  3723                                  ;-317 }
  3724                                  
  3725 00001635 EBD8                     jmp @@prscomment175
  3726                                  @@prscomment176:
  3727                                  
  3728                                  ;-318 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3729 00001637 C9                       LEAVE
  3730 00001638 C3                       ret
  3731                                  ; ENDP
  3732                                  
  3733                                  prs:  ; *** PROC ***
  3734                                  ;Function : prs, Number of local variables: 3
  3735                                  ;   # type sign width line used address name   list of local variables
  3736                                  ;  200 ptr unsg byte   318 NULL bp+4    s
  3737                                  ;  201 var unsg byte   318 NULL bp-2    c
  3738                                  ;  202 var sign word   318 NULL bp-4    com;
  3739 00001639 C8040000                 ENTER  4,0
  3740 0000163D 66B800000000             mov eax, 0
  3741 00001643 8946FC                   mov word [bp-4], ax
  3742                                  
  3743                                  ;-319   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3744                                  
  3745                                  @@prs177:
  3746 00001646 8B5E04                   mov bx, [bp+4]
  3747 00001649 8A07                     mov al, [bx]
  3748 0000164B B400                     mov ah, 0
  3749 0000164D 08C0                     or  al, al
  3750 0000164F 0F848700                 je @@prs178
  3751 00001653 8B5E04                   mov bx, [bp+4]
  3752 00001656 8A07                     mov al, [bx]
  3753 00001658 B400                     mov ah, 0
  3754 0000165A 8846FE                   mov byte [bp-2], al
  3755 0000165D 8A46FE                   mov al, [bp-2]
  3756 00001660 3C22                     cmp al, 34
  3757 00001662 0F851E00                 jne @@prs179
  3758 00001666 8B46FC                   mov ax, [bp-4]
  3759 00001669 08C0                     or  al, al
  3760 0000166B 0F840C00                 je @@prs180
  3761 0000166F 66B800000000             mov eax, 0
  3762 00001675 8946FC                   mov word [bp-4], ax
  3763 00001678 E90900                   jmp @@prs181
  3764                                  @@prs180:
  3765 0000167B 66B801000000             mov eax, 1
  3766 00001681 8946FC                   mov word [bp-4], ax
  3767                                  
  3768                                  ;-320     if (c==92) { if (com==0) { s++; c=*s;
  3769                                  
  3770                                  @@prs181:
  3771                                  @@prs179:
  3772 00001684 8A46FE                   mov al, [bp-2]
  3773 00001687 3C5C                     cmp al, 92
  3774 00001689 0F853B00                 jne @@prs182
  3775 0000168D 8B46FC                   mov ax, [bp-4]
  3776 00001690 83F800                   cmp ax, 0
  3777 00001693 0F853100                 jne @@prs183
  3778 00001697 FF4604                   inc  word [bp+4]
  3779 0000169A 8B5E04                   mov bx, [bp+4]
  3780 0000169D 8A07                     mov al, [bx]
  3781 0000169F B400                     mov ah, 0
  3782 000016A1 8846FE                   mov byte [bp-2], al
  3783                                  
  3784                                  ;-321           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3785                                  
  3786 000016A4 8A46FE                   mov al, [bp-2]
  3787 000016A7 3C6E                     cmp al, 110
  3788 000016A9 0F850900                 jne @@prs184
  3789 000016AD 66B80A000000             mov eax, 10
  3790 000016B3 8846FE                   mov byte [bp-2], al
  3791                                  @@prs184:
  3792 000016B6 8A46FE                   mov al, [bp-2]
  3793 000016B9 3C74                     cmp al, 116
  3794 000016BB 0F850900                 jne @@prs185
  3795 000016BF 66B809000000             mov eax, 9
  3796 000016C5 8846FE                   mov byte [bp-2], al
  3797                                  @@prs185:
  3798                                  @@prs183:
  3799                                  @@prs182:
  3800 000016C8 8A46FE                   mov al, byte [bp-2]
  3801 000016CB B400                     mov ah, 0
  3802 000016CD 50                       push ax
  3803 000016CE E807FF                   call prc
  3804 000016D1 83C402                   add  sp, 2
  3805 000016D4 FF4604                   inc  word [bp+4]
  3806                                  
  3807                                  ;-322 }
  3808                                  
  3809 000016D7 E96CFF                   jmp @@prs177
  3810                                  @@prs178:
  3811                                  
  3812                                  ;-323 int printhex8a(unsigned int c) { unsigned int nib;
  3813 000016DA C9                       LEAVE
  3814 000016DB C3                       ret
  3815                                  ; ENDP
  3816                                  
  3817                                  printhex8a:  ; *** PROC ***
  3818                                  
  3819                                  ;-324   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3820                                  
  3821                                  ;Function : printhex8a, Number of local variables: 2
  3822                                  ;   # type sign width line used address name   list of local variables
  3823                                  ;  200 var unsg word   323 NULL bp+4    c
  3824                                  ;  201 var unsg word   323 NULL bp-2    nib;
  3825 000016DC C8020000                 ENTER  2,0
  3826 000016E0 8B4604                   mov ax, [bp+4]
  3827 000016E3 C1E804                   shr ax, 4
  3828 000016E6 8946FE                   mov word [bp-2], ax
  3829 000016E9 8346FE30                 add  word [bp-2], 48
  3830 000016ED 8B46FE                   mov ax, [bp-2]
  3831 000016F0 83F839                   cmp ax, 57
  3832 000016F3 0F8E0400                 jle @@printhex8a186
  3833 000016F7 8346FE07                 add  word [bp-2], 7
  3834                                  @@printhex8a186:
  3835 000016FB FF76FE                   push word [bp-2]
  3836 000016FE E8D7FE                   call prc
  3837 00001701 83C402                   add  sp, 2
  3838                                  
  3839                                  ;-325   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3840                                  
  3841 00001704 8B4604                   mov ax, [bp+4]
  3842 00001707 83E00F                   and ax, 15
  3843 0000170A 8946FE                   mov word [bp-2], ax
  3844 0000170D 8346FE30                 add  word [bp-2], 48
  3845 00001711 8B46FE                   mov ax, [bp-2]
  3846 00001714 83F839                   cmp ax, 57
  3847 00001717 0F8E0400                 jle @@printhex8a187
  3848 0000171B 8346FE07                 add  word [bp-2], 7
  3849                                  @@printhex8a187:
  3850 0000171F FF76FE                   push word [bp-2]
  3851 00001722 E8B3FE                   call prc
  3852 00001725 83C402                   add  sp, 2
  3853                                  
  3854                                  ;-326 }
  3855                                  
  3856                                  
  3857                                  ;-327 int printhex16(unsigned int i) {unsigned int half;
  3858 00001728 C9                       LEAVE
  3859 00001729 C3                       ret
  3860                                  ; ENDP
  3861                                  
  3862                                  printhex16:  ; *** PROC ***
  3863                                  
  3864                                  ;-328   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3865                                  
  3866                                  ;Function : printhex16, Number of local variables: 2
  3867                                  ;   # type sign width line used address name   list of local variables
  3868                                  ;  200 var unsg word   327 NULL bp+4    i
  3869                                  ;  201 var unsg word   327 NULL bp-2    half;
  3870 0000172A C8020000                 ENTER  2,0
  3871 0000172E 8B4604                   mov ax, [bp+4]
  3872 00001731 C1E808                   shr ax, 8
  3873 00001734 8946FE                   mov word [bp-2], ax
  3874 00001737 FF76FE                   push word [bp-2]
  3875 0000173A E89FFF                   call printhex8a
  3876 0000173D 83C402                   add  sp, 2
  3877 00001740 8B4604                   mov ax, [bp+4]
  3878 00001743 25FF00                   and ax, 255
  3879 00001746 8946FE                   mov word [bp-2], ax
  3880 00001749 FF76FE                   push word [bp-2]
  3881 0000174C E88DFF                   call printhex8a
  3882 0000174F 83C402                   add  sp, 2
  3883                                  
  3884                                  ;-329 }
  3885                                  
  3886                                  
  3887                                  ;-330 int printIntU(unsigned int n) { unsigned int e;
  3888 00001752 C9                       LEAVE
  3889 00001753 C3                       ret
  3890                                  ; ENDP
  3891                                  
  3892                                  printIntU:  ; *** PROC ***
  3893                                  
  3894                                  ;-331   if ( _ n >= 10) {  e=n/10; //DIV
  3895                                  
  3896                                  ;Function : printIntU, Number of local variables: 2
  3897                                  ;   # type sign width line used address name   list of local variables
  3898                                  ;  200 var unsg word   330 NULL bp+4    n
  3899                                  ;  201 var unsg word   330 NULL bp-2    e;
  3900 00001754 C8020000                 ENTER  2,0
  3901 00001758 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3902 0000175C 0F821700                 jb  @@printIntU188
  3903 00001760 8B4604                   mov ax, [bp+4]
  3904 00001763 BB0A00                   mov bx, 10
  3905 00001766 BA0000                   mov dx, 0
  3906 00001769 F7F3                     div bx
  3907 0000176B 8946FE                   mov word [bp-2], ax
  3908                                  
  3909                                  ;-332     printIntU(e); }
  3910                                  
  3911 0000176E FF76FE                   push word [bp-2]
  3912 00001771 E8E0FF                   call printIntU
  3913 00001774 83C402                   add  sp, 2
  3914                                  
  3915                                  ;-333     n = n % 10; //unsigned mod
  3916                                  
  3917                                  @@printIntU188:
  3918 00001777 8B4604                   mov ax, [bp+4]
  3919 0000177A BB0A00                   mov bx, 10
  3920 0000177D BA0000                   mov dx, 0
  3921 00001780 F7F3                     div bx
  3922 00001782 89D0                     mov ax, dx
  3923 00001784 894604                   mov word [bp+4], ax
  3924                                  
  3925                                  ;-334     n += '0'; prc(n);
  3926                                  
  3927 00001787 83460430                 add  word [bp+4], 48
  3928 0000178B FF7604                   push word [bp+4]
  3929 0000178E E847FE                   call prc
  3930 00001791 83C402                   add  sp, 2
  3931                                  
  3932                                  ;-335 }
  3933                                  
  3934                                  
  3935                                  ;-336 /*int printLineHex(unsigned char *s) { int L; char c;
  3936                                  
  3937                                  
  3938                                  ;-337   L = strlen(s);
  3939                                  
  3940                                  
  3941                                  ;-338   prs(" L:");
  3942                                  
  3943                                  
  3944                                  ;-339   printIntU(L);  
  3945                                  
  3946                                  
  3947                                  ;-340   if (L <= 0) return;
  3948                                  
  3949                                  
  3950                                  ;-341   if (L > 80) errorexit("Line > 80 char");
  3951                                  
  3952                                  
  3953                                  ;-342   while ( *s ) {
  3954                                  
  3955                                  
  3956                                  ;-343     c = *s;
  3957                                  
  3958                                  
  3959                                  ;-344     prc(' ');
  3960                                  
  3961                                  
  3962                                  ;-345     printhex8a(c);
  3963                                  
  3964                                  
  3965                                  ;-346     s++;
  3966                                  
  3967                                  
  3968                                  ;-347   }
  3969                                  
  3970                                  
  3971                                  ;-348 } */
  3972                                  
  3973                                  
  3974                                  ;-349 int error1(char *s) { LIST=1; ErrorCount++;
  3975 00001794 C9                       LEAVE
  3976 00001795 C3                       ret
  3977                                  ; ENDP
  3978                                  
  3979                                  error1:  ; *** PROC ***
  3980                                  ;Function : error1, Number of local variables: 1
  3981                                  ;   # type sign width line used address name   list of local variables
  3982                                  ;  200 ptr sign byte   349 NULL bp+4    s;
  3983 00001796 C8000000                 ENTER  0,0
  3984 0000179A 66B801000000             mov eax, 1
  3985 000017A0 A2[2400]                 mov byte [LIST], al
  3986 000017A3 FF06[3100]               inc  word [ErrorCount]
  3987                                  
  3988                                  ;-350   prs("\n;***** next line ERROR: "); prs(s);
  3989                                  
  3990 000017A7 68[CF17]                 push error1_0
  3991 000017AA E88CFE                   call prs
  3992 000017AD 83C402                   add  sp, 2
  3993 000017B0 FF7604                   push word [bp+4]
  3994 000017B3 E883FE                   call prs
  3995 000017B6 83C402                   add  sp, 2
  3996                                  
  3997                                  ;-351   prs(", Symbol: "); prs(Symbol);}
  3998                                  
  3999 000017B9 68[EA17]                 push error1_1
  4000 000017BC E87AFE                   call prs
  4001 000017BF 83C402                   add  sp, 2
  4002 000017C2 8D063075                 lea  ax, [Symbol]
  4003 000017C6 50                       push ax
  4004 000017C7 E86FFE                   call prs
  4005 000017CA 83C402                   add  sp, 2
  4006                                  
  4007                                  ;-352 int allowederror(){error1("not allowed here"); }
  4008 000017CD C9                       LEAVE
  4009 000017CE C3                       ret
  4010                                  ; ENDP
  4011 000017CF 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4012 000017D8 6E657874206C696E65-
  4013 000017E1 204552524F523A2000 
  4014 000017EA 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4015 000017F3 2000               
  4016                                  
  4017                                  allowederror:  ; *** PROC ***
  4018 000017F5 68[FF17]                 push allowederror_0
  4019 000017F8 E89BFF                   call error1
  4020 000017FB 83C402                   add  sp, 2
  4021                                  
  4022                                  ;-353 int implmerror(){error1("not implemented");}
  4023                                  
  4024 000017FE C3                       ret
  4025                                  ; ENDP
  4026 000017FF 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4027 00001808 6564206865726500   
  4028                                  
  4029                                  implmerror:  ; *** PROC ***
  4030 00001810 68[1A18]                 push implmerror_0
  4031 00001813 E880FF                   call error1
  4032 00001816 83C402                   add  sp, 2
  4033                                  
  4034                                  ;-354 int indexerror (){error1("invalid index register");}
  4035                                  
  4036 00001819 C3                       ret
  4037                                  ; ENDP
  4038 0000181A 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4039 00001823 6D656E74656400     
  4040                                  
  4041                                  indexerror:  ; *** PROC ***
  4042 0000182A 68[3418]                 push indexerror_0
  4043 0000182D E866FF                   call error1
  4044 00001830 83C402                   add  sp, 2
  4045                                  
  4046                                  ;-355 int numbererror(){error1("number expected");}  
  4047                                  
  4048 00001833 C3                       ret
  4049                                  ; ENDP
  4050 00001834 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4051 0000183D 6E6465782072656769-
  4052 00001846 7374657200         
  4053                                  
  4054                                  numbererror:  ; *** PROC ***
  4055 0000184B 68[5518]                 push numbererror_0
  4056 0000184E E845FF                   call error1
  4057 00001851 83C402                   add  sp, 2
  4058                                  
  4059                                  ;-356 int regmemerror(){error1("only register or memory allowed");}
  4060                                  
  4061 00001854 C3                       ret
  4062                                  ; ENDP
  4063 00001855 6E756D626572206578-     numbererror_0 db "number expected",0
  4064 0000185E 70656374656400     
  4065                                  
  4066                                  regmemerror:  ; *** PROC ***
  4067 00001865 68[6F18]                 push regmemerror_0
  4068 00001868 E82BFF                   call error1
  4069 0000186B 83C402                   add  sp, 2
  4070                                  
  4071                                  ;-357 int segregerror(){error1("segment register not allowed");}
  4072                                  
  4073 0000186E C3                       ret
  4074                                  ; ENDP
  4075 0000186F 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4076 00001878 73746572206F72206D-
  4077 00001881 656D6F727920616C6C-
  4078 0000188A 6F77656400         
  4079                                  
  4080                                  segregerror:  ; *** PROC ***
  4081 0000188F 68[9918]                 push segregerror_0
  4082 00001892 E801FF                   call error1
  4083 00001895 83C402                   add  sp, 2
  4084                                  
  4085                                  ;-358 int syntaxerror(){error1("syntax");}
  4086                                  
  4087 00001898 C3                       ret
  4088                                  ; ENDP
  4089 00001899 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4090 000018A2 65676973746572206E-
  4091 000018AB 6F7420616C6C6F7765-
  4092 000018B4 6400               
  4093                                  
  4094                                  syntaxerror:  ; *** PROC ***
  4095 000018B6 68[C018]                 push syntaxerror_0
  4096 000018B9 E8DAFE                   call error1
  4097 000018BC 83C402                   add  sp, 2
  4098                                  
  4099                                  ;-359 
  4100                                  
  4101                                  
  4102                                  ;-360 int errorexit(char *s) { error1(s); end1(1);}
  4103                                  
  4104 000018BF C3                       ret
  4105                                  ; ENDP
  4106 000018C0 73796E74617800          syntaxerror_0 db "syntax",0
  4107                                  
  4108                                  errorexit:  ; *** PROC ***
  4109                                  ;Function : errorexit, Number of local variables: 1
  4110                                  ;   # type sign width line used address name   list of local variables
  4111                                  ;  200 ptr sign byte   360 NULL bp+4    s;
  4112 000018C7 C8000000                 ENTER  0,0
  4113 000018CB FF7604                   push word [bp+4]
  4114 000018CE E8C5FE                   call error1
  4115 000018D1 83C402                   add  sp, 2
  4116 000018D4 6A01                     push 1
  4117 000018D6 E81004                   call end1
  4118 000018D9 83C402                   add  sp, 2
  4119                                  
  4120                                  ;-361 int addrexit(){errorexit("illegal addres");}
  4121 000018DC C9                       LEAVE
  4122 000018DD C3                       ret
  4123                                  ; ENDP
  4124                                  
  4125                                  addrexit:  ; *** PROC ***
  4126 000018DE 68[E818]                 push addrexit_0
  4127 000018E1 E8E3FF                   call errorexit
  4128 000018E4 83C402                   add  sp, 2
  4129                                  
  4130                                  ;-362 int internexit(){errorexit("intern compiler error");}
  4131                                  
  4132 000018E7 C3                       ret
  4133                                  ; ENDP
  4134 000018E8 696C6C6567616C2061-     addrexit_0 db "illegal addres",0
  4135 000018F1 646472657300       
  4136                                  
  4137                                  internexit:  ; *** PROC ***
  4138 000018F7 68[0119]                 push internexit_0
  4139 000018FA E8CAFF                   call errorexit
  4140 000018FD 83C402                   add  sp, 2
  4141                                  
  4142                                  ;-363 
  4143                                  
  4144                                  
  4145                                  ;-364 //int main() {getarg(); parse(); epilog(); end1();}//NB AS, AS TE
  4146                                  
  4147                                  
  4148                                  ;-365 char *arglen=0x80; char *argv=0x82;
  4149                                  
  4150 00001900 C3                       ret
  4151                                  ; ENDP
  4152 00001901 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4153 0000190A 6D70696C6572206572-
  4154 00001913 726F7200           
  4155 00001917 8000                    arglen dw 128
  4156 00001919 8200                    argv dw 130
  4157                                  
  4158                                  ;-366 int getarg() { int arglen1; int i; char *c;
  4159                                  
  4160                                  
  4161                                  getarg:  ; *** PROC ***
  4162                                  
  4163                                  ;-367   arglen1=*arglen;
  4164                                  
  4165                                  ;Function : getarg, Number of local variables: 3
  4166                                  ;   # type sign width line used address name   list of local variables
  4167                                  ;  200 var sign word   366 NULL bp-2    arglen1
  4168                                  ;  201 var sign word   366 NULL bp-4    i
  4169                                  ;  202 ptr sign byte   366 NULL bp-6    c;
  4170 0000191B C8060000                 ENTER  6,0
  4171 0000191F 8B1E[1719]               mov bx, [arglen]
  4172 00001923 8A07                     mov al, [bx]
  4173 00001925 B400                     mov ah, 0
  4174 00001927 8946FE                   mov word [bp-2], ax
  4175                                  
  4176                                  ;-368   if (arglen1==0) {
  4177                                  
  4178 0000192A 8B46FE                   mov ax, [bp-2]
  4179 0000192D 83F800                   cmp ax, 0
  4180 00001930 0F851C00                 jne @@getarg189
  4181                                  
  4182                                  ;-369     cputs(Version1);
  4183                                  
  4184 00001934 8D06[1000]               lea  ax, [Version1]
  4185 00001938 50                       push ax
  4186 00001939 E8E203                   call cputs
  4187 0000193C 83C402                   add  sp, 2
  4188                                  
  4189                                  ;-370     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4190                                  
  4191 0000193F 68[E01A]                 push getarg_0
  4192 00001942 E8D903                   call cputs
  4193 00001945 83C402                   add  sp, 2
  4194                                  
  4195                                  ;-371     exitR(3);
  4196                                  
  4197 00001948 6A03                     push 3
  4198 0000194A E82706                   call exitR
  4199 0000194D 83C402                   add  sp, 2
  4200                                  
  4201                                  ;-372   }
  4202                                  
  4203                                  
  4204                                  ;-373   i=arglen1+129; *i=0;  arglen1--;
  4205                                  
  4206                                  @@getarg189:
  4207 00001950 8B46FE                   mov ax, [bp-2]
  4208 00001953 058100                   add ax, 129
  4209 00001956 8946FC                   mov word [bp-4], ax
  4210 00001959 66B800000000             mov eax, 0
  4211 0000195F 8B5EFC                   mov  bx, [bp-4]
  4212 00001962 8907                     mov  [bx], ax
  4213 00001964 FF4EFE                   dec  word [bp-2]
  4214                                  
  4215                                  ;-374   toupper(argv);
  4216                                  
  4217 00001967 FF36[1919]               push word [argv]
  4218 0000196B E8DE03                   call toupper
  4219 0000196E 83C402                   add  sp, 2
  4220                                  
  4221                                  ;-375   strcpy(namein, argv); strcat1(namein, ".S");
  4222                                  
  4223 00001971 FF36[1919]               push word [argv]
  4224 00001975 8D065076                 lea  ax, [namein]
  4225 00001979 50                       push ax
  4226 0000197A E83D04                   call strcpy
  4227 0000197D 83C404                   add  sp, 4
  4228 00001980 68[051B]                 push getarg_1
  4229 00001983 8D065076                 lea  ax, [namein]
  4230 00001987 50                       push ax
  4231 00001988 E86B05                   call strcat1
  4232 0000198B 83C404                   add  sp, 4
  4233                                  
  4234                                  ;-376   strcpy(namelst,argv); strcat1(namelst,".LST");
  4235                                  
  4236 0000198E FF36[1919]               push word [argv]
  4237 00001992 8D069376                 lea  ax, [namelst]
  4238 00001996 50                       push ax
  4239 00001997 E82004                   call strcpy
  4240 0000199A 83C404                   add  sp, 4
  4241 0000199D 68[081B]                 push getarg_2
  4242 000019A0 8D069376                 lea  ax, [namelst]
  4243 000019A4 50                       push ax
  4244 000019A5 E84E05                   call strcat1
  4245 000019A8 83C404                   add  sp, 4
  4246                                  
  4247                                  ;-377   strcpy(namebin,argv); strcat1(namebin,".COM");
  4248                                  
  4249 000019AB FF36[1919]               push word [argv]
  4250 000019AF 8D06D676                 lea  ax, [namebin]
  4251 000019B3 50                       push ax
  4252 000019B4 E80304                   call strcpy
  4253 000019B7 83C404                   add  sp, 4
  4254 000019BA 68[0D1B]                 push getarg_3
  4255 000019BD 8D06D676                 lea  ax, [namebin]
  4256 000019C1 50                       push ax
  4257 000019C2 E83105                   call strcat1
  4258 000019C5 83C404                   add  sp, 4
  4259                                  
  4260                                  ;-378 
  4261                                  
  4262                                  
  4263                                  ;-379   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4264                                  
  4265 000019C8 66B801000000             mov eax, 1
  4266 000019CE A2[2400]                 mov byte [LIST], al
  4267 000019D1 66B800000000             mov eax, 0
  4268 000019D7 A3[2F00]                 mov word [DOS_ERR], ax
  4269 000019DA 66B800000000             mov eax, 0
  4270 000019E0 A3[3600]                 mov word [PC], ax
  4271 000019E3 66B800000000             mov eax, 0
  4272 000019E9 A3[3100]                 mov word [ErrorCount], ax
  4273                                  
  4274                                  ;-380   asm_fd=openR (namein);
  4275                                  
  4276 000019EC 8D065076                 lea  ax, [namein]
  4277 000019F0 50                       push ax
  4278 000019F1 E82705                   call openR
  4279 000019F4 83C402                   add  sp, 2
  4280 000019F7 A3[2900]                 mov word [asm_fd], ax
  4281                                  
  4282                                  ;-381   if(DOS_ERR){cputs("Source file missing: "); cputs(namein); exitR(1); }
  4283                                  
  4284 000019FA A1[2F00]                 mov ax, [DOS_ERR]
  4285 000019FD 08C0                     or  al, al
  4286 000019FF 0F841C00                 je @@getarg190
  4287 00001A03 68[121B]                 push getarg_4
  4288 00001A06 E81503                   call cputs
  4289 00001A09 83C402                   add  sp, 2
  4290 00001A0C 8D065076                 lea  ax, [namein]
  4291 00001A10 50                       push ax
  4292 00001A11 E80A03                   call cputs
  4293 00001A14 83C402                   add  sp, 2
  4294 00001A17 6A01                     push 1
  4295 00001A19 E85805                   call exitR
  4296 00001A1C 83C402                   add  sp, 2
  4297                                  
  4298                                  ;-382   lst_fd=creatR(namelst);
  4299                                  
  4300                                  @@getarg190:
  4301 00001A1F 8D069376                 lea  ax, [namelst]
  4302 00001A23 50                       push ax
  4303 00001A24 E80305                   call creatR
  4304 00001A27 83C402                   add  sp, 2
  4305 00001A2A A3[2B00]                 mov word [lst_fd], ax
  4306                                  
  4307                                  ;-383   if(DOS_ERR){cputs("List file not creatable: ");cputs(namelst);exitR(2);}
  4308                                  
  4309 00001A2D A1[2F00]                 mov ax, [DOS_ERR]
  4310 00001A30 08C0                     or  al, al
  4311 00001A32 0F841C00                 je @@getarg191
  4312 00001A36 68[281B]                 push getarg_5
  4313 00001A39 E8E202                   call cputs
  4314 00001A3C 83C402                   add  sp, 2
  4315 00001A3F 8D069376                 lea  ax, [namelst]
  4316 00001A43 50                       push ax
  4317 00001A44 E8D702                   call cputs
  4318 00001A47 83C402                   add  sp, 2
  4319 00001A4A 6A02                     push 2
  4320 00001A4C E82505                   call exitR
  4321 00001A4F 83C402                   add  sp, 2
  4322                                  
  4323                                  ;-384   bin_fd=creatR(namebin);
  4324                                  
  4325                                  @@getarg191:
  4326 00001A52 8D06D676                 lea  ax, [namebin]
  4327 00001A56 50                       push ax
  4328 00001A57 E8D004                   call creatR
  4329 00001A5A 83C402                   add  sp, 2
  4330 00001A5D A3[2D00]                 mov word [bin_fd], ax
  4331                                  
  4332                                  ;-385   if(DOS_ERR){cputs("COM file not creatable: ");cputs(namebin);exitR(2);}
  4333                                  
  4334 00001A60 A1[2F00]                 mov ax, [DOS_ERR]
  4335 00001A63 08C0                     or  al, al
  4336 00001A65 0F841C00                 je @@getarg192
  4337 00001A69 68[421B]                 push getarg_6
  4338 00001A6C E8AF02                   call cputs
  4339 00001A6F 83C402                   add  sp, 2
  4340 00001A72 8D06D676                 lea  ax, [namebin]
  4341 00001A76 50                       push ax
  4342 00001A77 E8A402                   call cputs
  4343 00001A7A 83C402                   add  sp, 2
  4344 00001A7D 6A02                     push 2
  4345 00001A7F E8F204                   call exitR
  4346 00001A82 83C402                   add  sp, 2
  4347                                  
  4348                                  ;-386   prs(";");prs(Version1);
  4349                                  
  4350                                  @@getarg192:
  4351 00001A85 68[5B1B]                 push getarg_7
  4352 00001A88 E8AEFB                   call prs
  4353 00001A8B 83C402                   add  sp, 2
  4354 00001A8E 8D06[1000]               lea  ax, [Version1]
  4355 00001A92 50                       push ax
  4356 00001A93 E8A3FB                   call prs
  4357 00001A96 83C402                   add  sp, 2
  4358                                  
  4359                                  ;-387   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4360                                  
  4361 00001A99 68[5D1B]                 push getarg_8
  4362 00001A9C E89AFB                   call prs
  4363 00001A9F 83C402                   add  sp, 2
  4364 00001AA2 8D065076                 lea  ax, [namein]
  4365 00001AA6 50                       push ax
  4366 00001AA7 E88FFB                   call prs
  4367 00001AAA 83C402                   add  sp, 2
  4368 00001AAD 68[681B]                 push getarg_9
  4369 00001AB0 E886FB                   call prs
  4370 00001AB3 83C402                   add  sp, 2
  4371 00001AB6 8D069376                 lea  ax, [namelst]
  4372 00001ABA 50                       push ax
  4373 00001ABB E87BFB                   call prs
  4374 00001ABE 83C402                   add  sp, 2
  4375                                  
  4376                                  ;-388   prs(", "); prs(namebin);
  4377                                  
  4378 00001AC1 68[731B]                 push getarg_10
  4379 00001AC4 E872FB                   call prs
  4380 00001AC7 83C402                   add  sp, 2
  4381 00001ACA 8D06D676                 lea  ax, [namebin]
  4382 00001ACE 50                       push ax
  4383 00001ACF E867FB                   call prs
  4384 00001AD2 83C402                   add  sp, 2
  4385                                  
  4386                                  ;-389   prs("\n");
  4387                                  
  4388 00001AD5 68[761B]                 push getarg_11
  4389 00001AD8 E85EFB                   call prs
  4390 00001ADB 83C402                   add  sp, 2
  4391                                  
  4392                                  ;-390 }
  4393                                  
  4394                                  
  4395                                  ;-391 int epilog() { int i; int j; char c;
  4396 00001ADE C9                       LEAVE
  4397 00001ADF C3                       ret
  4398                                  ; ENDP
  4399 00001AE0 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4400 00001AE9 41532E434F4D206669-
  4401 00001AF2 6C656E616D65205B77-
  4402 00001AFB 2F6F202E535D203A20-
  4403 00001B04 00                 
  4404 00001B05 2E5300                  getarg_1 db ".S",0
  4405 00001B08 2E4C535400              getarg_2 db ".LST",0
  4406 00001B0D 2E434F4D00              getarg_3 db ".COM",0
  4407 00001B12 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4408 00001B1B 6C65206D697373696E-
  4409 00001B24 673A2000           
  4410 00001B28 4C6973742066696C65-     getarg_5 db "List file not creatable: ",0
  4411 00001B31 206E6F742063726561-
  4412 00001B3A 7461626C653A2000   
  4413 00001B42 434F4D2066696C6520-     getarg_6 db "COM file not creatable: ",0
  4414 00001B4B 6E6F74206372656174-
  4415 00001B54 61626C653A2000     
  4416 00001B5B 3B00                    getarg_7 db ";",0
  4417 00001B5D 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4418 00001B66 2000               
  4419 00001B68 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4420 00001B71 2000               
  4421 00001B73 2C2000                  getarg_10 db ", ",0
  4422 00001B76 5C6E00                  getarg_11 db "\n",0
  4423                                  
  4424                                  epilog:  ; *** PROC ***
  4425                                  
  4426                                  ;-392   prs("\n;END Errors: "); printIntU(ErrorCount);
  4427                                  
  4428                                  ;Function : epilog, Number of local variables: 3
  4429                                  ;   # type sign width line used address name   list of local variables
  4430                                  ;  200 var sign word   391 NULL bp-2    i
  4431                                  ;  201 var sign word   391 NULL bp-4    j
  4432                                  ;  202 var sign byte   391 NULL bp-6    c;
  4433 00001B79 C8060000                 ENTER  6,0
  4434 00001B7D 68[A21C]                 push epilog_0
  4435 00001B80 E8B6FA                   call prs
  4436 00001B83 83C402                   add  sp, 2
  4437 00001B86 FF36[3100]               push word [ErrorCount]
  4438 00001B8A E8C7FB                   call printIntU
  4439 00001B8D 83C402                   add  sp, 2
  4440                                  
  4441                                  ;-393   if (ErrorCount) prs(" ***ERROR*** ");
  4442                                  
  4443 00001B90 A1[3100]                 mov ax, [ErrorCount]
  4444 00001B93 08C0                     or  al, al
  4445 00001B95 0F840900                 je @@epilog193
  4446 00001B99 68[B21C]                 push epilog_1
  4447 00001B9C E89AFA                   call prs
  4448 00001B9F 83C402                   add  sp, 2
  4449                                  
  4450                                  ;-394   prs(", Label & Var: ");
  4451                                  
  4452                                  @@epilog193:
  4453 00001BA2 68[C01C]                 push epilog_2
  4454 00001BA5 E891FA                   call prs
  4455 00001BA8 83C402                   add  sp, 2
  4456                                  
  4457                                  ;-395 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  4458                                  
  4459                                  
  4460                                  ;-396   i= &LabelNames;
  4461                                  
  4462                                  
  4463                                  ;-397   do { c=*i; if (c==0) c=' '; prc(c); i++;
  4464                                  
  4465                                  
  4466                                  ;-398   } while (i < LabelNamePtr); prs("<< \n"); */
  4467                                  
  4468                                  
  4469                                  ;-399   if (LabelMaxIx) {
  4470                                  
  4471 00001BAB A1[5100]                 mov ax, [LabelMaxIx]
  4472 00001BAE 08C0                     or  al, al
  4473 00001BB0 0F846900                 je @@epilog194
  4474                                  
  4475                                  ;-400     i = 1;
  4476                                  
  4477 00001BB4 66B801000000             mov eax, 1
  4478 00001BBA 8946FE                   mov word [bp-2], ax
  4479                                  
  4480                                  ;-401     LabelNamePtr= &LabelNames;
  4481                                  
  4482 00001BBD B81E77                   mov ax, LabelNames
  4483 00001BC0 A3[4F00]                 mov word [LabelNamePtr], ax
  4484                                  
  4485                                  ;-402     do {
  4486                                  
  4487                                  @@epilog195:
  4488                                  
  4489                                  ;-403       prs(LabelNamePtr); prc(' ');
  4490                                  
  4491 00001BC3 FF36[4F00]               push word [LabelNamePtr]
  4492 00001BC7 E86FFA                   call prs
  4493 00001BCA 83C402                   add  sp, 2
  4494 00001BCD 6A20                     push 32
  4495 00001BCF E806FA                   call prc
  4496 00001BD2 83C402                   add  sp, 2
  4497                                  
  4498                                  ;-404  /*     j=LabelType[i]; //printIntU(j);
  4499                                  
  4500                                  
  4501                                  ;-405       if (j == 1) prc('L');
  4502                                  
  4503                                  
  4504                                  ;-406       if (j == 2) prc('V');
  4505                                  
  4506                                  
  4507                                  ;-407       prc('.'); */
  4508                                  
  4509                                  
  4510                                  ;-408       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4511                                  
  4512 00001BD5 8B5EFE                   mov bx, [bp-2]
  4513 00001BD8 D1E3                     shl bx, 1
  4514 00001BDA 8B876A7B                 mov ax, [LabelAddr + bx]
  4515 00001BDE 8946FC                   mov word [bp-4], ax
  4516 00001BE1 FF76FC                   push word [bp-4]
  4517 00001BE4 E843FB                   call printhex16
  4518 00001BE7 83C402                   add  sp, 2
  4519 00001BEA 68[D01C]                 push epilog_3
  4520 00001BED E849FA                   call prs
  4521 00001BF0 83C402                   add  sp, 2
  4522                                  
  4523                                  ;-409       j=strlen(LabelNamePtr);//get end of act. name
  4524                                  
  4525 00001BF3 FF36[4F00]               push word [LabelNamePtr]
  4526 00001BF7 E89501                   call strlen
  4527 00001BFA 83C402                   add  sp, 2
  4528 00001BFD 8946FC                   mov word [bp-4], ax
  4529                                  
  4530                                  ;-410       LabelNamePtr=LabelNamePtr+j;
  4531                                  
  4532 00001C00 A1[4F00]                 mov ax, [LabelNamePtr]
  4533 00001C03 0346FC                   add ax, [bp-4]
  4534 00001C06 A3[4F00]                 mov word [LabelNamePtr], ax
  4535                                  
  4536                                  ;-411       LabelNamePtr++;
  4537                                  
  4538 00001C09 FF06[4F00]               inc  word [LabelNamePtr]
  4539                                  
  4540                                  ;-412       i++;
  4541                                  
  4542 00001C0D FF46FE                   inc  word [bp-2]
  4543                                  
  4544                                  ;-413     } while (i <= LabelMaxIx);
  4545                                  
  4546 00001C10 8B46FE                   mov ax, [bp-2]
  4547 00001C13 3B06[5100]               cmp ax, [LabelMaxIx]
  4548 00001C17 0F8F0200                 jg  @@epilog196
  4549 00001C1B EBA6                     jmp @@epilog195
  4550                                  @@epilog196:
  4551                                  
  4552                                  ;-414   }
  4553                                  
  4554                                  
  4555                                  ;-415   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4556                                  
  4557                                  @@epilog194:
  4558 00001C1D 68[D41C]                 push epilog_4
  4559 00001C20 E816FA                   call prs
  4560 00001C23 83C402                   add  sp, 2
  4561 00001C26 FF36[5500]               push word [BinLen]
  4562 00001C2A E827FB                   call printIntU
  4563 00001C2D 83C402                   add  sp, 2
  4564 00001C30 68[E11C]                 push epilog_5
  4565 00001C33 E803FA                   call prs
  4566 00001C36 83C402                   add  sp, 2
  4567                                  
  4568                                  ;-416   i=0;
  4569                                  
  4570 00001C39 66B800000000             mov eax, 0
  4571 00001C3F 8946FE                   mov word [bp-2], ax
  4572                                  
  4573                                  ;-417   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4574                                  
  4575                                  @@epilog197:
  4576 00001C42 6A20                     push 32
  4577 00001C44 E891F9                   call prc
  4578 00001C47 83C402                   add  sp, 2
  4579 00001C4A 8B5EFE                   mov bx, [bp-2]
  4580 00001C4D 8A87327C                 mov al, [FileBin + bx]
  4581 00001C51 8946FC                   mov word [bp-4], ax
  4582 00001C54 FF76FC                   push word [bp-4]
  4583 00001C57 E882FA                   call printhex8a
  4584 00001C5A 83C402                   add  sp, 2
  4585 00001C5D FF46FE                   inc  word [bp-2]
  4586                                  
  4587                                  ;-418   } while (i < BinLen);
  4588                                  
  4589 00001C60 8B46FE                   mov ax, [bp-2]
  4590 00001C63 3B06[5500]               cmp ax, [BinLen]
  4591 00001C67 0F8D0200                 jge @@epilog198
  4592 00001C6B EBD5                     jmp @@epilog197
  4593                                  @@epilog198:
  4594                                  
  4595                                  ;-419   i=0;
  4596                                  
  4597 00001C6D 66B800000000             mov eax, 0
  4598 00001C73 8946FE                   mov word [bp-2], ax
  4599                                  
  4600                                  ;-420   do {
  4601                                  
  4602                                  @@epilog199:
  4603                                  
  4604                                  ;-421     c = FileBin[i];
  4605                                  
  4606 00001C76 8B5EFE                   mov bx, [bp-2]
  4607 00001C79 8A87327C                 mov al, [FileBin + bx]
  4608 00001C7D 8846FA                   mov byte [bp-6], al
  4609                                  
  4610                                  ;-422     fputcR(c, bin_fd);
  4611                                  
  4612 00001C80 FF36[2D00]               push word [bin_fd]
  4613 00001C84 8A46FA                   mov al, byte [bp-6]
  4614 00001C87 B400                     mov ah, 0
  4615 00001C89 50                       push ax
  4616 00001C8A E8C402                   call fputcR
  4617 00001C8D 83C404                   add  sp, 4
  4618                                  
  4619                                  ;-423     i++;
  4620                                  
  4621 00001C90 FF46FE                   inc  word [bp-2]
  4622                                  
  4623                                  ;-424   } while (i < BinLen);
  4624                                  
  4625 00001C93 8B46FE                   mov ax, [bp-2]
  4626 00001C96 3B06[5500]               cmp ax, [BinLen]
  4627 00001C9A 0F8D0200                 jge @@epilog200
  4628 00001C9E EBD6                     jmp @@epilog199
  4629                                  @@epilog200:
  4630                                  
  4631                                  ;-425 }
  4632                                  
  4633                                  
  4634                                  ;-426 int end1(int n) {fcloseR(asm_fd); fcloseR(lst_fd); fcloseR(bin_fd);exitR(n);
  4635 00001CA0 C9                       LEAVE
  4636 00001CA1 C3                       ret
  4637                                  ; ENDP
  4638 00001CA2 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4639 00001CAB 726F72733A2000     
  4640 00001CB2 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4641 00001CBB 2A2A2A2000         
  4642 00001CC0 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  4643 00001CC9 205661723A2000     
  4644 00001CD0 2C202000                epilog_3 db ",  ",0
  4645 00001CD4 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  4646 00001CDD 6C652000           
  4647 00001CE1 2062797465733A00        epilog_5 db " bytes:",0
  4648                                  
  4649                                  end1:  ; *** PROC ***
  4650                                  ;Function : end1, Number of local variables: 1
  4651                                  ;   # type sign width line used address name   list of local variables
  4652                                  ;  200 var sign word   426 NULL bp+4    n;
  4653 00001CE9 C8000000                 ENTER  0,0
  4654 00001CED FF36[2900]               push word [asm_fd]
  4655 00001CF1 E87202                   call fcloseR
  4656 00001CF4 83C402                   add  sp, 2
  4657 00001CF7 FF36[2B00]               push word [lst_fd]
  4658 00001CFB E86802                   call fcloseR
  4659 00001CFE 83C402                   add  sp, 2
  4660 00001D01 FF36[2D00]               push word [bin_fd]
  4661 00001D05 E85E02                   call fcloseR
  4662 00001D08 83C402                   add  sp, 2
  4663 00001D0B FF7604                   push word [bp+4]
  4664 00001D0E E86302                   call exitR
  4665 00001D11 83C402                   add  sp, 2
  4666                                  
  4667                                  ;-427 }
  4668                                  
  4669                                  
  4670                                  ;-428 /*
  4671                                  
  4672                                  
  4673                                  ;-429 Hierarchical software diagram, except string & DOS functions,  .=end
  4674                                  
  4675                                  
  4676                                  ;-430 main:  getarg. parse epilog. end1.
  4677                                  
  4678                                  
  4679                                  ;-431 parse: getLine. getToken storeLabel. searchLabel. lookCode. process
  4680                                  
  4681                                  
  4682                                  ;-432        getVariable printLine.
  4683                                  
  4684                                  
  4685                                  ;-433 getToken: skipBlank. getDigit. getName.
  4686                                  
  4687                                  
  4688                                  ;-434 process: genInstruction getToken testReg. genAddr16.
  4689                                  
  4690                                  
  4691                                  ;-435 genInstruction: genCode8.
  4692                                  
  4693                                  
  4694                                  ;-436 getVariable: storeLabel. getToken lookCode. skipBlank. isToken. genAddr16.
  4695                                  
  4696                                  
  4697                                  ;-437 */
  4698 00001D14 C9                       LEAVE
  4699 00001D15 C3                       ret
  4700                                  ; ENDP
  4701                                  ;Back to main program: AS.C
  4702                                   
  4703                                  ; missing functions: 
  4704                                  ; digit
  4705                                  ; alnum
  4706                                  ; eqstr
  4707                                  ; eqstr
  4708                                  ; eqstr
  4709                                  ; strcpy
  4710                                  ; eqstr
  4711                                  ; strlen
  4712                                  ; readRL
  4713                                  ; readRL
  4714                                  ; digit
  4715                                  ; alnum
  4716                                  ; strcpy
  4717                                  ; toupper
  4718                                  ; strlen
  4719                                  ; strlen
  4720                                  ; eqstr
  4721                                  ; eqstr
  4722                                  ; eqstr
  4723                                  ; eqstr
  4724                                  ; eqstr
  4725                                  ; eqstr
  4726                                  ; eqstr
  4727                                  ; eqstr
  4728                                  ; eqstr
  4729                                  ; eqstr
  4730                                  ; eqstr
  4731                                  ; eqstr
  4732                                  ; eqstr
  4733                                  ; eqstr
  4734                                  ; eqstr
  4735                                  ; eqstr
  4736                                  ; eqstr
  4737                                  ; eqstr
  4738                                  ; eqstr
  4739                                  ; eqstr
  4740                                  ; eqstr
  4741                                  ; eqstr
  4742                                  ; eqstr
  4743                                  ; eqstr
  4744                                  ; eqstr
  4745                                  ; eqstr
  4746                                  ; eqstr
  4747                                  ; eqstr
  4748                                  ; eqstr
  4749                                  ; eqstr
  4750                                  ; eqstr
  4751                                  ; writetty
  4752                                  ; writetty
  4753                                  ; fputcR
  4754                                  ; cputs
  4755                                  ; cputs
  4756                                  ; exitR
  4757                                  ; toupper
  4758                                  ; strcpy
  4759                                  ; strcat1
  4760                                  ; strcpy
  4761                                  ; strcat1
  4762                                  ; strcpy
  4763                                  ; strcat1
  4764                                  ; openR
  4765                                  ; cputs
  4766                                  ; cputs
  4767                                  ; exitR
  4768                                  ; creatR
  4769                                  ; cputs
  4770                                  ; cputs
  4771                                  ; exitR
  4772                                  ; creatR
  4773                                  ; cputs
  4774                                  ; cputs
  4775                                  ; exitR
  4776                                  ; strlen
  4777                                  ; fputcR
  4778                                  ; fcloseR
  4779                                  ; fcloseR
  4780                                  ; fcloseR
  4781                                  ; exitR
  4782                                  ; Number of unresolved CALLs :   78
  4783                                  ;use archive file: AR.C
  4784                                  
  4785                                  ;-243 // AR.C Archive
  4786                                  
  4787                                  ;Number of CALLs:    2 : writetty
  4788                                  
  4789                                  writetty:  ; *** PROC ***
  4790 00001D16 B40E                     mov  ah, 14
  4791 00001D18 BB0000                   mov  bx, 0
  4792 00001D1B CD10                     int  16
  4793                                  
  4794                                  ;-244 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  4795                                  
  4796 00001D1D C3                       ret
  4797                                  ; ENDP
  4798                                  ;Number of CALLs:    8 : cputs
  4799                                  
  4800                                  cputs:  ; *** PROC ***
  4801                                  ;Function : cputs, Number of local variables: 2
  4802                                  ;   # type sign width line used address name   list of local variables
  4803                                  ;  200 ptr sign byte   244 NULL bp+4    s
  4804                                  ;  201 var sign byte   244 NULL bp-2    c;
  4805 00001D1E C8020000                 ENTER  2,0
  4806                                  @@cputs201:
  4807 00001D22 8B5E04                   mov bx, [bp+4]
  4808 00001D25 8A07                     mov al, [bx]
  4809 00001D27 B400                     mov ah, 0
  4810 00001D29 08C0                     or  al, al
  4811 00001D2B 0F841B00                 je @@cputs202
  4812 00001D2F 8B5E04                   mov bx, [bp+4]
  4813 00001D32 8A07                     mov al, [bx]
  4814 00001D34 B400                     mov ah, 0
  4815 00001D36 8846FE                   mov byte [bp-2], al
  4816 00001D39 8A46FE                   mov al, byte [bp-2]
  4817 00001D3C B400                     mov ah, 0
  4818 00001D3E 50                       push ax
  4819 00001D3F E83F02                   call putch
  4820 00001D42 83C402                   add  sp, 2
  4821 00001D45 FF4604                   inc  word [bp+4]
  4822 00001D48 EBD8                     jmp @@cputs201
  4823                                  @@cputs202:
  4824                                  
  4825                                  ;-245 int mkneg(int n) { n; __asm {neg ax} }
  4826 00001D4A C9                       LEAVE
  4827 00001D4B C3                       ret
  4828                                  ; ENDP
  4829                                  ;Number of CALLs:    2 : toupper
  4830                                  
  4831                                  toupper:  ; *** PROC ***
  4832                                  ;Function : toupper, Number of local variables: 1
  4833                                  ;   # type sign width line used address name   list of local variables
  4834                                  ;  200 ptr sign byte   245 NULL bp+4    s;
  4835 00001D4C C8000000                 ENTER  0,0
  4836                                  @@toupper203:
  4837 00001D50 8B5E04                   mov bx, [bp+4]
  4838 00001D53 8A07                     mov al, [bx]
  4839 00001D55 B400                     mov ah, 0
  4840 00001D57 08C0                     or  al, al
  4841 00001D59 0F843000                 je @@toupper204
  4842 00001D5D 8B5E04                   mov bx, [bp+4]
  4843 00001D60 8A07                     mov al, [bx]
  4844 00001D62 B400                     mov ah, 0
  4845 00001D64 83F861                   cmp ax, 97 ;unsigned : 1
  4846 00001D67 0F8C1D00                 jl  @@toupper205
  4847 00001D6B 8B5E04                   mov bx, [bp+4]
  4848 00001D6E 8A07                     mov al, [bx]
  4849 00001D70 B400                     mov ah, 0
  4850 00001D72 83F87A                   cmp ax, 122
  4851 00001D75 0F8F0F00                 jg  @@toupper206
  4852 00001D79 8B5E04                   mov bx, [bp+4]
  4853 00001D7C 8A07                     mov al, [bx]
  4854 00001D7E B400                     mov ah, 0
  4855 00001D80 83E820                   sub ax, 32
  4856 00001D83 8B5E04                   mov  bx, [bp+4]
  4857 00001D86 8807                     mov  [bx], al
  4858                                  @@toupper206:
  4859                                  @@toupper205:
  4860 00001D88 FF4604                   inc  word [bp+4]
  4861 00001D8B EBC3                     jmp @@toupper203
  4862                                  @@toupper204:
  4863                                  
  4864                                  ;-246 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  4865                                  
  4866                                  
  4867                                  ;-247 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  4868 00001D8D C9                       LEAVE
  4869 00001D8E C3                       ret
  4870                                  ; ENDP
  4871                                  ;Number of CALLs:    4 : strlen
  4872                                  
  4873                                  strlen:  ; *** PROC ***
  4874                                  ;Function : strlen, Number of local variables: 2
  4875                                  ;   # type sign width line used address name   list of local variables
  4876                                  ;  200 ptr sign byte   247 NULL bp+4    s
  4877                                  ;  201 var sign word   247 NULL bp-2    c;
  4878 00001D8F C8020000                 ENTER  2,0
  4879 00001D93 66B800000000             mov eax, 0
  4880 00001D99 8946FE                   mov word [bp-2], ax
  4881                                  @@strlen207:
  4882 00001D9C 8B5E04                   mov bx, [bp+4]
  4883 00001D9F 8A07                     mov al, [bx]
  4884 00001DA1 B400                     mov ah, 0
  4885 00001DA3 83F800                   cmp ax, 0
  4886 00001DA6 0F840800                 je  @@strlen208
  4887 00001DAA FF4604                   inc  word [bp+4]
  4888 00001DAD FF46FE                   inc  word [bp-2]
  4889 00001DB0 EBEA                     jmp @@strlen207
  4890                                  @@strlen208:
  4891 00001DB2 8B46FE                   mov ax, [bp-2]
  4892 00001DB5 E90000                   jmp @@retn
  4893                                  
  4894                                  ;-248 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  4895                                  
  4896 00001DB8 C9                      @@retn: LEAVE
  4897 00001DB9 C3                       ret
  4898                                  ; ENDP
  4899                                  ;Number of CALLs:    5 : strcpy
  4900                                  
  4901                                  strcpy:  ; *** PROC ***
  4902                                  ;Function : strcpy, Number of local variables: 2
  4903                                  ;   # type sign width line used address name   list of local variables
  4904                                  ;  200 ptr sign byte   248 NULL bp+4    s
  4905                                  ;  201 ptr sign byte   248 NULL bp+6    t;
  4906 00001DBA C8000000                 ENTER  0,0
  4907                                  @@strcpy209:
  4908 00001DBE 8B5E06                   mov bx, [bp+6]
  4909 00001DC1 8A07                     mov al, [bx]
  4910 00001DC3 B400                     mov ah, 0
  4911 00001DC5 8B5E04                   mov  bx, [bp+4]
  4912 00001DC8 8807                     mov  [bx], al
  4913 00001DCA FF4604                   inc  word [bp+4]
  4914 00001DCD FF4606                   inc  word [bp+6]
  4915                                  
  4916                                  ;-249   while (*t!=0); *s=0; return s; }
  4917                                  
  4918 00001DD0 8B5E06                   mov bx, [bp+6]
  4919 00001DD3 8A07                     mov al, [bx]
  4920 00001DD5 B400                     mov ah, 0
  4921 00001DD7 83F800                   cmp ax, 0
  4922 00001DDA 0F840200                 je  @@strcpy210
  4923 00001DDE EBDE                     jmp @@strcpy209
  4924                                  @@strcpy210:
  4925 00001DE0 66B800000000             mov eax, 0
  4926 00001DE6 8B5E04                   mov  bx, [bp+4]
  4927 00001DE9 8807                     mov  [bx], al
  4928 00001DEB 8B4604                   mov ax, [bp+4]
  4929 00001DEE E90000                   jmp @@retn
  4930                                  
  4931                                  ;-250 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  4932                                  
  4933 00001DF1 C9                      @@retn: LEAVE
  4934 00001DF2 C3                       ret
  4935                                  ; ENDP
  4936                                  ;Number of CALLs:    2 : digit
  4937                                  
  4938                                  digit:  ; *** PROC ***
  4939                                  ;Function : digit, Number of local variables: 1
  4940                                  ;   # type sign width line used address name   list of local variables
  4941                                  ;  200 var sign byte   250 NULL bp+4    c;
  4942 00001DF3 C8000000                 ENTER  0,0
  4943 00001DF7 8A4604                   mov al, [bp+4]
  4944 00001DFA 3C30                     cmp al, 48
  4945 00001DFC 0F8D0900                 jge @@digit211
  4946 00001E00 66B800000000             mov eax, 0
  4947 00001E06 E91B00                   jmp @@retn
  4948                                  @@digit211:
  4949 00001E09 8A4604                   mov al, [bp+4]
  4950 00001E0C 3C39                     cmp al, 57
  4951 00001E0E 0F8E0900                 jle @@digit212
  4952 00001E12 66B800000000             mov eax, 0
  4953 00001E18 E90900                   jmp @@retn
  4954                                  @@digit212:
  4955 00001E1B 66B801000000             mov eax, 1
  4956 00001E21 E90000                   jmp @@retn
  4957                                  
  4958                                  ;-251 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1;
  4959                                  
  4960 00001E24 C9                      @@retn: LEAVE
  4961 00001E25 C3                       ret
  4962                                  ; ENDP
  4963                                  ;Number of CALLs:    2 : alnum
  4964                                  
  4965                                  alnum:  ; *** PROC ***
  4966                                  ;Function : alnum, Number of local variables: 1
  4967                                  ;   # type sign width line used address name   list of local variables
  4968                                  ;  200 var sign byte   251 NULL bp+4    c;
  4969 00001E26 C8000000                 ENTER  0,0
  4970 00001E2A 8A4604                   mov al, byte [bp+4]
  4971 00001E2D B400                     mov ah, 0
  4972 00001E2F 50                       push ax
  4973 00001E30 E8C0FF                   call digit
  4974 00001E33 83C402                   add  sp, 2
  4975 00001E36 08C0                     or  al, al
  4976 00001E38 0F840900                 je @@alnum213
  4977 00001E3C 66B801000000             mov eax, 1
  4978 00001E42 E95A00                   jmp @@retn
  4979                                  @@alnum213:
  4980 00001E45 8A4604                   mov al, [bp+4]
  4981 00001E48 3C5F                     cmp al, 95
  4982 00001E4A 0F850900                 jne @@alnum214
  4983 00001E4E 66B801000000             mov eax, 1
  4984 00001E54 E94800                   jmp @@retn
  4985                                  
  4986                                  ;-252   if (c> 'z') return 0; if (c< '@') return 0;
  4987                                  
  4988                                  @@alnum214:
  4989 00001E57 8A4604                   mov al, [bp+4]
  4990 00001E5A 3C7A                     cmp al, 122
  4991 00001E5C 0F8E0900                 jle @@alnum215
  4992 00001E60 66B800000000             mov eax, 0
  4993 00001E66 E93600                   jmp @@retn
  4994                                  @@alnum215:
  4995 00001E69 8A4604                   mov al, [bp+4]
  4996 00001E6C 3C40                     cmp al, 64
  4997 00001E6E 0F8D0900                 jge @@alnum216
  4998 00001E72 66B800000000             mov eax, 0
  4999 00001E78 E92400                   jmp @@retn
  5000                                  
  5001                                  ;-253   if (c> 'Z') { if (c< 'a') return 0; }  return 1; }//same as letter
  5002                                  
  5003                                  @@alnum216:
  5004 00001E7B 8A4604                   mov al, [bp+4]
  5005 00001E7E 3C5A                     cmp al, 90
  5006 00001E80 0F8E1200                 jle @@alnum217
  5007 00001E84 8A4604                   mov al, [bp+4]
  5008 00001E87 3C61                     cmp al, 97
  5009 00001E89 0F8D0900                 jge @@alnum218
  5010 00001E8D 66B800000000             mov eax, 0
  5011 00001E93 E90900                   jmp @@retn
  5012                                  @@alnum218:
  5013                                  @@alnum217:
  5014 00001E96 66B801000000             mov eax, 1
  5015 00001E9C E90000                   jmp @@retn
  5016                                  
  5017                                  ;-254 int eqstr(char *p, char *q) { while(*p) {
  5018                                  
  5019 00001E9F C9                      @@retn: LEAVE
  5020 00001EA0 C3                       ret
  5021                                  ; ENDP
  5022                                  ;Number of CALLs:   35 : eqstr
  5023                                  
  5024                                  eqstr:  ; *** PROC ***
  5025                                  ;Function : eqstr, Number of local variables: 2
  5026                                  ;   # type sign width line used address name   list of local variables
  5027                                  ;  200 ptr sign byte   254 NULL bp+4    p
  5028                                  ;  201 ptr sign byte   254 NULL bp+6    q;
  5029 00001EA1 C8000000                 ENTER  0,0
  5030                                  @@eqstr219:
  5031 00001EA5 8B5E04                   mov bx, [bp+4]
  5032 00001EA8 8A07                     mov al, [bx]
  5033 00001EAA B400                     mov ah, 0
  5034 00001EAC 08C0                     or  al, al
  5035 00001EAE 0F842300                 je @@eqstr220
  5036                                  
  5037                                  ;-255     if (*p != *q) return 0; p++; q++; }
  5038                                  
  5039 00001EB2 8B5E04                   mov bx, [bp+4]
  5040 00001EB5 8A07                     mov al, [bx]
  5041 00001EB7 B400                     mov ah, 0
  5042 00001EB9 8B5E06                   mov bx, [bp+6]
  5043 00001EBC 3A07                     cmp al, [bx]
  5044 00001EBE B400                     mov ah, 0
  5045 00001EC0 0F840900                 je  @@eqstr221
  5046 00001EC4 66B800000000             mov eax, 0
  5047 00001ECA E92700                   jmp @@retn
  5048                                  @@eqstr221:
  5049 00001ECD FF4604                   inc  word [bp+4]
  5050 00001ED0 FF4606                   inc  word [bp+6]
  5051                                  
  5052                                  ;-256     if(*q) return 0; return 1; }
  5053                                  
  5054 00001ED3 EBD0                     jmp @@eqstr219
  5055                                  @@eqstr220:
  5056 00001ED5 8B5E06                   mov bx, [bp+6]
  5057 00001ED8 8A07                     mov al, [bx]
  5058 00001EDA B400                     mov ah, 0
  5059 00001EDC 08C0                     or  al, al
  5060 00001EDE 0F840900                 je @@eqstr222
  5061 00001EE2 66B800000000             mov eax, 0
  5062 00001EE8 E90900                   jmp @@retn
  5063                                  @@eqstr222:
  5064 00001EEB 66B801000000             mov eax, 1
  5065 00001EF1 E90000                   jmp @@retn
  5066                                  
  5067                                  ;-257 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5068                                  
  5069 00001EF4 C9                      @@retn: LEAVE
  5070 00001EF5 C3                       ret
  5071                                  ; ENDP
  5072                                  ;Number of CALLs:    3 : strcat1
  5073                                  
  5074                                  strcat1:  ; *** PROC ***
  5075                                  ;Function : strcat1, Number of local variables: 2
  5076                                  ;   # type sign width line used address name   list of local variables
  5077                                  ;  200 ptr sign byte   257 NULL bp+4    s
  5078                                  ;  201 ptr sign byte   257 NULL bp+6    t;
  5079 00001EF6 C8000000                 ENTER  0,0
  5080                                  @@strcat1223:
  5081 00001EFA 8B5E04                   mov bx, [bp+4]
  5082 00001EFD 8A07                     mov al, [bx]
  5083 00001EFF B400                     mov ah, 0
  5084 00001F01 83F800                   cmp ax, 0
  5085 00001F04 0F840500                 je  @@strcat1224
  5086 00001F08 FF4604                   inc  word [bp+4]
  5087 00001F0B EBED                     jmp @@strcat1223
  5088                                  @@strcat1224:
  5089 00001F0D FF7606                   push word [bp+6]
  5090 00001F10 FF7604                   push word [bp+4]
  5091 00001F13 E8A4FE                   call strcpy
  5092 00001F16 83C404                   add  sp, 4
  5093                                  
  5094                                  ;-258 int basename(char *s) { char *p; p=0;
  5095 00001F19 C9                       LEAVE
  5096 00001F1A C3                       ret
  5097                                  ; ENDP
  5098                                  ;Number of CALLs:    1 : openR
  5099                                  
  5100                                  openR:  ; *** PROC ***
  5101                                  ;Function : openR, Number of local variables: 1
  5102                                  ;   # type sign width line used address name   list of local variables
  5103                                  ;  200 ptr sign byte   258 NULL bp+4    s;
  5104 00001F1B C8000000                 ENTER  0,0
  5105 00001F1F 8B5604                   mov  dx, [bp+4]
  5106 00001F22 B8023D                   mov  ax, 15618
  5107 00001F25 E87200                   call DosInt
  5108                                  
  5109                                  ;-259 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5110 00001F28 C9                       LEAVE
  5111 00001F29 C3                       ret
  5112                                  ; ENDP
  5113                                  ;Number of CALLs:    2 : creatR
  5114                                  
  5115                                  creatR:  ; *** PROC ***
  5116                                  ;Function : creatR, Number of local variables: 1
  5117                                  ;   # type sign width line used address name   list of local variables
  5118                                  ;  200 ptr sign byte   259 NULL bp+4    s;
  5119 00001F2A C8000000                 ENTER  0,0
  5120 00001F2E 8B5604                   mov  dx, [bp+4]
  5121 00001F31 B90000                   mov  cx, 0
  5122 00001F34 B8003C                   mov  ax, 15360
  5123 00001F37 E86000                   call DosInt
  5124                                  
  5125                                  ;-260 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5126 00001F3A C9                       LEAVE
  5127 00001F3B C3                       ret
  5128                                  ; ENDP
  5129                                  ;Number of CALLs:    2 : readRL
  5130                                  
  5131                                  readRL:  ; *** PROC ***
  5132                                  ;Function : readRL, Number of local variables: 3
  5133                                  ;   # type sign width line used address name   list of local variables
  5134                                  ;  200 ptr sign byte   260 NULL bp+4    s
  5135                                  ;  201 var sign word   260 NULL bp+6    fd
  5136                                  ;  202 var sign word   260 NULL bp+8    len;
  5137 00001F3C C8000000                 ENTER  0,0
  5138 00001F40 8B5604                   mov  dx, [bp+4]
  5139 00001F43 8B4E08                   mov  cx, [bp+8]
  5140 00001F46 8B5E06                   mov  bx, [bp+6]
  5141 00001F49 B8003F                   mov  ax, 16128
  5142 00001F4C E84B00                   call DosInt
  5143                                  
  5144                                  ;-261 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5145 00001F4F C9                       LEAVE
  5146 00001F50 C3                       ret
  5147                                  ; ENDP
  5148                                  ;Number of CALLs:    2 : fputcR
  5149                                  
  5150                                  fputcR:  ; *** PROC ***
  5151                                  ;Function : fputcR, Number of local variables: 2
  5152                                  ;   # type sign width line used address name   list of local variables
  5153                                  ;  200 ptr sign byte   261 NULL bp+4    n
  5154                                  ;  201 var sign word   261 NULL bp+6    fd;
  5155 00001F51 C8000000                 ENTER  0,0
  5156 00001F55 8D5604                  lea dx, [bp+4]
  5157                                  
  5158                                  ;-262   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5159                                  
  5160 00001F58 B90100                   mov  cx, 1
  5161 00001F5B 8B5E06                   mov  bx, [bp+6]
  5162 00001F5E B80040                   mov  ax, 16384
  5163 00001F61 E83600                   call DosInt
  5164                                  
  5165                                  ;-263 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5166 00001F64 C9                       LEAVE
  5167 00001F65 C3                       ret
  5168                                  ; ENDP
  5169                                  ;Number of CALLs:    3 : fcloseR
  5170                                  
  5171                                  fcloseR:  ; *** PROC ***
  5172                                  ;Function : fcloseR, Number of local variables: 1
  5173                                  ;   # type sign width line used address name   list of local variables
  5174                                  ;  200 var sign word   263 NULL bp+4    fd;
  5175 00001F66 C8000000                 ENTER  0,0
  5176 00001F6A 8B5E04                   mov  bx, [bp+4]
  5177 00001F6D B8003E                   mov  ax, 15872
  5178 00001F70 CD21                     int  33
  5179                                  
  5180                                  ;-264 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5181 00001F72 C9                       LEAVE
  5182 00001F73 C3                       ret
  5183                                  ; ENDP
  5184                                  ;Number of CALLs:    5 : exitR
  5185                                  
  5186                                  exitR:  ; *** PROC ***
  5187                                  ;Function : exitR, Number of local variables: 1
  5188                                  ;   # type sign width line used address name   list of local variables
  5189                                  ;  200 var sign byte   264 NULL bp+4    c;
  5190 00001F74 C8000000                 ENTER  0,0
  5191 00001F78 B44C                     mov  ah, 76
  5192 00001F7A 8A4604                   mov  al, [bp+4]
  5193 00001F7D CD21                     int  33
  5194                                  
  5195                                  ;-265 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5196 00001F7F C9                       LEAVE
  5197 00001F80 C3                       ret
  5198                                  ; ENDP
  5199                                  ;End of archive file. 
  5200                                   
  5201                                  ; missing functions: 
  5202                                  ; putch
  5203                                  ; DosInt
  5204                                  ; DosInt
  5205                                  ; DosInt
  5206                                  ; DosInt
  5207                                  ; Number of unresolved CALLs :    5
  5208                                  ;use archive file: AR.C
  5209                                  
  5210                                  ;-266 // AR.C Archive
  5211                                  
  5212                                  ;Number of CALLs:    1 : putch
  5213                                  
  5214                                  putch:  ; *** PROC ***
  5215                                  ;Function : putch, Number of local variables: 1
  5216                                  ;   # type sign width line used address name   list of local variables
  5217                                  ;  200 var sign byte   266 NULL bp+4    c;
  5218 00001F81 C8000000                 ENTER  0,0
  5219 00001F85 807E040A                cmp byte [bp+4], 10
  5220 00001F89 0F850500                 jne @@putch225
  5221 00001F8D B00D                     mov  al, 13
  5222 00001F8F E884FD                   call writetty
  5223                                  @@putch225:
  5224 00001F92 8A4604                   mov  al, [bp+4]
  5225 00001F95 E87EFD                   call writetty
  5226                                  
  5227                                  ;-267 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5228 00001F98 C9                       LEAVE
  5229 00001F99 C3                       ret
  5230                                  ; ENDP
  5231                                  ;Number of CALLs:    4 : DosInt
  5232                                  
  5233                                  DosInt:  ; *** PROC ***
  5234 00001F9A CD21                     int  33
  5235 00001F9C 7304                     jae short @@DosInt226
  5236 00001F9E FF06[2F00]               inc  word [DOS_ERR]
  5237                                  @@DosInt226:
  5238                                  
  5239                                  ;-268 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5240                                  
  5241 00001FA2 C3                       ret
  5242                                  ; ENDP
  5243                                  ;End of archive file. 
  5244                                   
  5245                                  ; missing functions:  All FUNCTIONs in place
  5246 00001FA3 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5247 00001FA6 58                      pop ax
  5248 00001FA7 C3                      ret
  5249                                   
  5250                                  ;   # type sign width line used  address name   list of global variables
  5251                                  
  5252                                  ;    1 arr sign byte     2    2        0 Version1[19]
  5253                                  ;    2 var sign byte     3    3        0 LIST
  5254                                  ;    3 arr sign byte     4    7    30000 Symbol[80]
  5255                                  ;    4 arr sign byte     4   36    30080 SymbolUpper[80]
  5256                                  ;    5 var unsg word     4   12        0 SymbolInt
  5257                                  ;    6 arr sign byte     5    3    30160 InputBuf[128]
  5258                                  ;    7 ptr unsg byte     5   23        0 InputPtr
  5259                                  ;    8 arr sign byte     6    5    30288 namein[67]
  5260                                  ;    9 arr sign byte     6    5    30355 namelst[67]
  5261                                  ;   10 arr sign byte     6    5    30422 namebin[67]
  5262                                  ;   11 var sign word     7    4        0 asm_fd
  5263                                  ;   12 var sign word     7    3        0 lst_fd
  5264                                  ;   13 var sign word     7    3        0 bin_fd
  5265                                  ;   14 var sign word     8    6        0 DOS_ERR
  5266                                  ;   15 var sign word     8    4        0 ErrorCount
  5267                                  ;   16 var sign word     9    4        0 DOS_NoBytes
  5268                                  ;   17 var sign byte     9    4        0 DOS_ByteRead
  5269                                  ;   18 var unsg word    11    5        0 PC
  5270                                  ;   19 var unsg word    12    2        0 PCStart
  5271                                  ;   20 var sign byte    13    3        0 isLabel
  5272                                  ;   21 def unsg byte    14    -        0 LABEL=1
  5273                                  ;   22 def unsg byte    15    -        0 VARIABLE=2
  5274                                  ;   23 def unsg byte    16    -        0 DIGIT=1
  5275                                  ;   24 def unsg byte    17    -        0 ALNUM=2
  5276                                  ;   25 var sign byte    18   20        0 TokeType
  5277                                  ;   26 def unsg byte    19    -        0 BYTE=1
  5278                                  ;   27 def unsg byte    20    -        0 WORD=2
  5279                                  ;   28 def unsg byte    21    -        0 DWORD=3
  5280                                  ;   29 def unsg byte    22    -        0 SEGREG=4
  5281                                  ;   30 def unsg byte    24    -        0 IMM=1
  5282                                  ;   31 def unsg byte    25    -        0 REG=2
  5283                                  ;   32 def unsg byte    26    -        0 DIR=3
  5284                                  ;   33 def unsg byte    27    -        0 IND=4
  5285                                  ;   34 var sign byte    28   13        0 Op1
  5286                                  ;   35 var sign word    29   12        0 CodeType
  5287                                  ;   36 var sign byte    31   17        0 RegType
  5288                                  ;   37 var sign byte    32   10        0 RegNo
  5289                                  ;   38 var sign byte    33   10        0 OpSize
  5290                                  ;   39 var sign byte    35 NULL        0 NumOprns
  5291                                  ;   40 var sign byte    36    5        0 wflag
  5292                                  ;   41 var sign byte    37 NULL        0 dflag
  5293                                  ;   42 var sign byte    39    4        0 reg
  5294                                  ;   43 var sign word    40   13        0 disp
  5295                                  ;   44 var sign word    41    2        0 imme
  5296                                  ;   45 def unsg byte    43    -        0 OPMAXLEN=5
  5297                                  ;   46 arr sign byte    44    2    30489 OpPos[5]
  5298                                  ;   47 var sign word    45    6        0 OpPrintIndex
  5299                                  ;   48 ptr sign byte    46   16        0 OpCodePtr
  5300                                  ;   49 var sign byte    47    2        0 PrReloc
  5301                                  ;   50 arr sign byte    48    3    30494 LabelNames[1000]
  5302                                  ;   51 ptr sign byte    48   10        0 LabelNamePtr
  5303                                  ;   52 arr sign byte    49    1    31494 LabelType[100]
  5304                                  ;   53 arr unsg word    49    4    31594 LabelAddr[100]
  5305                                  ;   54 var sign word    50    6        0 LabelMaxIx
  5306                                  ;   55 var sign word    50    4        0 LabelIx
  5307                                  ;   56 arr sign byte    51    3    31794 FileBin[2000]
  5308                                  ;   57 var unsg word    51    5        0 BinLen
  5309                                  ;   58 var sign byte   172    1        0 I_START
  5310                                  ;   59 arr sign byte   174 NULL        0 I_PUSHA[9]
  5311                                  ;   60 arr sign byte   175 NULL        0 I_POPA[8]
  5312                                  ;   61 arr sign byte   176 NULL        0 I_NOP[7]
  5313                                  ;   62 arr sign byte   177 NULL        0 I_CBW[7]
  5314                                  ;   63 arr sign byte   178 NULL        0 I_CWDE[8]
  5315                                  ;   64 arr sign byte   179 NULL        0 I_CWD[7]
  5316                                  ;   65 arr sign byte   180 NULL        0 I_CDQ[7]
  5317                                  ;   66 arr sign byte   181 NULL        0 I_WAIT[8]
  5318                                  ;   67 arr sign byte   182 NULL        0 I_PUSHF[9]
  5319                                  ;   68 arr sign byte   183 NULL        0 I_POPF[8]
  5320                                  ;   69 arr sign byte   184 NULL        0 I_SAHF[8]
  5321                                  ;   70 arr sign byte   185 NULL        0 I_LAHF[8]
  5322                                  ;   71 arr sign byte   186 NULL        0 I_MOVSB[9]
  5323                                  ;   72 arr sign byte   187 NULL        0 I_MOVSW[9]
  5324                                  ;   73 arr sign byte   188 NULL        0 I_CMPSB[9]
  5325                                  ;   74 arr sign byte   189 NULL        0 I_CMPSW[9]
  5326                                  ;   75 arr sign byte   190 NULL        0 I_STOSB[9]
  5327                                  ;   76 arr sign byte   191 NULL        0 I_STOSW[9]
  5328                                  ;   77 arr sign byte   192 NULL        0 I_LODSB[9]
  5329                                  ;   78 arr sign byte   193 NULL        0 I_LODSW[9]
  5330                                  ;   79 arr sign byte   194 NULL        0 I_SCASB[9]
  5331                                  ;   80 arr sign byte   195 NULL        0 I_SCASW[9]
  5332                                  ;   81 arr sign byte   196 NULL        0 I_LEAVE[9]
  5333                                  ;   82 arr sign byte   197 NULL        0 I_IRET[8]
  5334                                  ;   83 arr sign byte   198 NULL        0 I_XLAT[8]
  5335                                  ;   84 arr sign byte   199 NULL        0 I_LOCK[8]
  5336                                  ;   85 arr sign byte   200 NULL        0 I_REPNE[9]
  5337                                  ;   86 arr sign byte   201 NULL        0 I_REPNZ[9]
  5338                                  ;   87 arr sign byte   202 NULL        0 I_REPE[8]
  5339                                  ;   88 arr sign byte   203 NULL        0 I_REPZ[8]
  5340                                  ;   89 arr sign byte   204 NULL        0 I_HLT[7]
  5341                                  ;   90 arr sign byte   205 NULL        0 I_CLC[7]
  5342                                  ;   91 arr sign byte   206 NULL        0 I_STC[7]
  5343                                  ;   92 arr sign byte   207 NULL        0 I_CLI[7]
  5344                                  ;   93 arr sign byte   208 NULL        0 I_STI[7]
  5345                                  ;   94 arr sign byte   209 NULL        0 I_CLD[7]
  5346                                  ;   95 arr sign byte   210 NULL        0 I_STD[7]
  5347                                  ;   96 arr sign byte   212 NULL        0 I_INC[9]
  5348                                  ;   97 arr sign byte   213 NULL        0 I_DEC[9]
  5349                                  ;   98 arr sign byte   215 NULL        0 I_NOT[8]
  5350                                  ;   99 arr sign byte   216 NULL        0 I_NEG[8]
  5351                                  ;  100 arr sign byte   217 NULL        0 I_MUL[8]
  5352                                  ;  101 arr sign byte   218 NULL        0 I_IMUL[9]
  5353                                  ;  102 arr sign byte   219 NULL        0 I_DIV[8]
  5354                                  ;  103 arr sign byte   220 NULL        0 I_IDIV[9]
  5355                                  ;  104 arr sign byte   222 NULL        0 I_LES[7]
  5356                                  ;  105 arr sign byte   223 NULL        0 I_LDS[7]
  5357                                  ;  106 arr sign byte   224 NULL        0 I_LEA[7]
  5358                                  ;  107 arr sign byte   226 NULL        0 I_ADD[7]
  5359                                  ;  108 arr sign byte   227 NULL        0 I_OR[6]
  5360                                  ;  109 arr sign byte   228 NULL        0 I_ADC[7]
  5361                                  ;  110 arr sign byte   229 NULL        0 I_SBB[7]
  5362                                  ;  111 arr sign byte   230 NULL        0 I_AND[7]
  5363                                  ;  112 arr sign byte   231 NULL        0 I_SUB[7]
  5364                                  ;  113 arr sign byte   232 NULL        0 I_XOR[7]
  5365                                  ;  114 arr sign byte   233 NULL        0 I_CMP[7]
  5366                                  ;  115 arr sign byte   235 NULL        0 I_MOV[6]
  5367                                  ;  116 arr sign byte   237 NULL        0 I_JO[6]
  5368                                  ;  117 arr sign byte   238 NULL        0 I_JNO[7]
  5369                                  ;  118 arr sign byte   239 NULL        0 I_JB[6]
  5370                                  ;  119 arr sign byte   240 NULL        0 I_JC[6]
  5371                                  ;  120 arr sign byte   241 NULL        0 I_JNB[7]
  5372                                  ;  121 arr sign byte   242 NULL        0 I_JAE[7]
  5373                                  ;  122 arr sign byte   243 NULL        0 I_JNC[7]
  5374                                  ;  123 arr sign byte   244 NULL        0 I_JE[6]
  5375                                  ;  124 arr sign byte   245 NULL        0 I_JZ[6]
  5376                                  ;  125 arr sign byte   246 NULL        0 I_JNE[7]
  5377                                  ;  126 arr sign byte   247 NULL        0 I_JNZ[7]
  5378                                  ;  127 arr sign byte   248 NULL        0 I_JBE[7]
  5379                                  ;  128 arr sign byte   249 NULL        0 I_JNA[7]
  5380                                  ;  129 arr sign byte   250 NULL        0 I_JA[6]
  5381                                  ;  130 arr sign byte   251 NULL        0 I_JS[6]
  5382                                  ;  131 arr sign byte   252 NULL        0 I_JNS[7]
  5383                                  ;  132 arr sign byte   253 NULL        0 I_JP[6]
  5384                                  ;  133 arr sign byte   254 NULL        0 I_JPE[7]
  5385                                  ;  134 arr sign byte   255 NULL        0 I_JNP[7]
  5386                                  ;  135 arr sign byte   256 NULL        0 I_JPO[7]
  5387                                  ;  136 arr sign byte   257 NULL        0 I_JL[6]
  5388                                  ;  137 arr sign byte   258 NULL        0 I_JNL[7]
  5389                                  ;  138 arr sign byte   259 NULL        0 I_JGE[7]
  5390                                  ;  139 arr sign byte   260 NULL        0 I_JLE[7]
  5391                                  ;  140 arr sign byte   261 NULL        0 I_JNG[7]
  5392                                  ;  141 arr sign byte   262 NULL        0 I_JG[6]
  5393                                  ;  142 arr sign byte   264 NULL        0 I_RET[8]
  5394                                  ;  143 arr sign byte   266 NULL        0 I_PUSH[8]
  5395                                  ;  144 arr sign byte   267 NULL        0 I_POP[7]
  5396                                  ;  145 arr sign byte   269 NULL        0 I_ORG[6]
  5397                                  ;  146 arr sign byte   270 NULL        0 I_DB[5]
  5398                                  ;  147 arr sign byte   271 NULL        0 I_DW[5]
  5399                                  ;  148 arr sign byte   272 NULL        0 I_DD[5]
  5400                                  ;  149 arr sign byte   273 NULL        0 I_RESB[7]
  5401                                  ;  150 arr sign byte   274 NULL        0 I_RESW[7]
  5402                                  ;  151 arr sign byte   275 NULL        0 I_RESD[7]
  5403                                  ;  152 var sign byte   276 NULL        0 I_END
  5404                                  ;  153 ptr sign byte   365    1        0 arglen
  5405                                  ;  154 ptr sign byte   365    4        0 argv
  5406                                  
  5407                                  
  5408                                  ;   # Calls Line Width  Name   list of functions
  5409                                  
  5410                                  ;    0 NULL    1 word   main
  5411                                  ;    1    1   53 word   process
  5412                                  ;    2   12   86 word   setTokeType
  5413                                  ;    3 NULL   95 word   Ops
  5414                                  ;    4    2  106 word   LeftOpwCheck
  5415                                  ;    5    1  116 word   getLeftOp
  5416                                  ;    6    1  128 word   setwflag
  5417                                  ;    7    2  136 word   getOp1
  5418                                  ;    8    1  148 word   getIND
  5419                                  ;    9    1  163 word   getIndReg1
  5420                                  ;   10    1  172 word   getIndReg2
  5421                                  ;   11    1  182 word   getCodeSize
  5422                                  ;   12    7  189 word   isToken
  5423                                  ;   13    1  198 word   skipRest
  5424                                  ;   14    1  202 word   gen66h
  5425                                  ;   15    8  203 word   genCode8
  5426                                  ;   16    3  207 word   genCode16
  5427                                  ;   17    7  210 word   genInstruction
  5428                                  ;   18    2  214 word   genCodeInREG
  5429                                  ;   19 NULL  217 word   genModRegRM
  5430                                  ;   20    2  219 word   writeEA
  5431                                  ;   21 NULL  233 word   test1
  5432                                  ;   22    1    2 word   parse
  5433                                  ;   23    2   27 word   storeLabel
  5434                                  ;   24    2   35 word   searchLabel
  5435                                  ;   25    1   46 word   getVariable
  5436                                  ;   26    1   76 word   getLine
  5437                                  ;   27    1   89 word   ifEOL
  5438                                  ;   28    3   96 word   skipBlank
  5439                                  ;   29    1  101 word   getDigit
  5440                                  ;   30    1  113 word   getName
  5441                                  ;   31    1  130 word   testReg
  5442                                  ;   32    2  278 word   lookCode
  5443                                  ;   33    1  293 word   printLine
  5444                                  ;   34    9  311 word   prc
  5445                                  ;   35    1  315 word   prscomment
  5446                                  ;   36   24  318 word   prs
  5447                                  ;   37    4  323 word   printhex8a
  5448                                  ;   38    2  327 word   printhex16
  5449                                  ;   39    3  330 word   printIntU
  5450                                  ;   40   19  349 word   error1
  5451                                  ;   41 NULL  352 word   allowederror
  5452                                  ;   42 NULL  353 word   implmerror
  5453                                  ;   43    4  354 word   indexerror
  5454                                  ;   44    1  355 word   numbererror
  5455                                  ;   45 NULL  356 word   regmemerror
  5456                                  ;   46    1  357 word   segregerror
  5457                                  ;   47    1  358 word   syntaxerror
  5458                                  ;   48    7  360 word   errorexit
  5459                                  ;   49    1  361 word   addrexit
  5460                                  ;   50 NULL  362 word   internexit
  5461                                  ;   51    1  366 word   getarg
  5462                                  ;   52    1  391 word   epilog
  5463                                  ;   53    2  426 word   end1
  5464                                  ;   54    4  243 word   writetty
  5465                                  ;   55    8  244 word   cputs
  5466                                  ;   56    2  245 word   toupper
  5467                                  ;   57    4  247 word   strlen
  5468                                  ;   58    6  248 word   strcpy
  5469                                  ;   59    3  250 word   digit
  5470                                  ;   60    2  251 word   alnum
  5471                                  ;   61   35  254 word   eqstr
  5472                                  ;   62    3  257 word   strcat1
  5473                                  ;   63    1  258 word   openR
  5474                                  ;   64    2  259 word   creatR
  5475                                  ;   65    2  260 word   readRL
  5476                                  ;   66    2  261 word   fputcR
  5477                                  ;   67    3  263 word   fcloseR
  5478                                  ;   68    5  264 word   exitR
  5479                                  ;   69    1  266 word   putch
  5480                                  ;   70    4  267 word   DosInt
  5481                                  ;   71 NULL  268 word   LastFunctionByt
  5482                                  
  5483                                  ;    #  addr name   list of CALLs
  5484                                  
  5485                                  ;    0     5 getarg
  5486                                  ;    1    12 parse
  5487                                  ;    2    18 epilog
  5488                                  ;    3    25 end1
  5489                                  ;    4   478 setTokeType
  5490                                  ;    5   490 getCodeSize
  5491                                  ;    6   502 genInstruction
  5492                                  ;    7   517 LeftOpwCheck
  5493                                  ;    8   530 genInstruction
  5494                                  ;    9   545 genInstruction
  5495                                  ;   10   560 genInstruction
  5496                                  ;   11   575 genCodeInREG
  5497                                  ;   12   588 LeftOpwCheck
  5498                                  ;   13   601 genInstruction
  5499                                  ;   14   616 genCodeInREG
  5500                                  ;   15   629 genInstruction
  5501                                  ;   16   644 genCode16
  5502                                  ;   17   654 genInstruction
  5503                                  ;   18   669 error1
  5504                                  ;   19   676 error1
  5505                                  ;   20   697 skipBlank
  5506                                  ;   21   707 digit
  5507                                  ;   22   713 getDigit
  5508                                  ;   23   722 alnum
  5509                                  ;   24   728 getName
  5510                                  ;   25   753 getLeftOp
  5511                                  ;   26   763 segregerror
  5512                                  ;   27   775 setwflag
  5513                                  ;   28   784 error1
  5514                                  ;   29   791 error1
  5515                                  ;   30   798 error1
  5516                                  ;   31   815 getOp1
  5517                                  ;   32   822 isToken
  5518                                  ;   33   830 getIND
  5519                                  ;   34   837 error1
  5520                                  ;   35   844 error1
  5521                                  ;   36   860 gen66h
  5522                                  ;   37   874 testReg
  5523                                  ;   38   882 searchLabel
  5524                                  ;   39   894 error1
  5525                                  ;   40   915 setTokeType
  5526                                  ;   41   927 getOp1
  5527                                  ;   42   934 syntaxerror
  5528                                  ;   43   946 getIndReg2
  5529                                  ;   44   957 getIndReg1
  5530                                  ;   45   968 isToken
  5531                                  ;   46   976 setTokeType
  5532                                  ;   47   988 numbererror
  5533                                  ;   48  1000 isToken
  5534                                  ;   49  1008 isToken
  5535                                  ;   50  1016 errorexit
  5536                                  ;   51  1039 indexerror
  5537                                  ;   52  1050 indexerror
  5538                                  ;   53  1077 indexerror
  5539                                  ;   54  1088 indexerror
  5540                                  ;   55  1111 eqstr
  5541                                  ;   56  1117 setTokeType
  5542                                  ;   57  1129 eqstr
  5543                                  ;   58  1135 setTokeType
  5544                                  ;   59  1147 eqstr
  5545                                  ;   60  1153 setTokeType
  5546                                  ;   61  1175 skipBlank
  5547                                  ;   62  1194 setTokeType
  5548                                  ;   63  1206 prs
  5549                                  ;   64  1217 genCode8
  5550                                  ;   65  1249 genCode8
  5551                                  ;   66  1258 genCode8
  5552                                  ;   67  1291 genCode8
  5553                                  ;   68  1315 writeEA
  5554                                  ;   69  1335 writeEA
  5555                                  ;   70  1359 addrexit
  5556                                  ;   71  1368 genCode8
  5557                                  ;   72  1377 genCode8
  5558                                  ;   73  1386 genCode16
  5559                                  ;   74  1408 getLine
  5560                                  ;   75  1416 setTokeType
  5561                                  ;   76  1428 storeLabel
  5562                                  ;   77  1439 setTokeType
  5563                                  ;   78  1451 lookCode
  5564                                  ;   79  1460 process
  5565                                  ;   80  1468 getVariable
  5566                                  ;   81  1480 skipRest
  5567                                  ;   82  1489 error1
  5568                                  ;   83  1496 error1
  5569                                  ;   84  1503 printLine
  5570                                  ;   85  1532 searchLabel
  5571                                  ;   86  1544 error1
  5572                                  ;   87  1551 strcpy
  5573                                  ;   88  1589 eqstr
  5574                                  ;   89  1595 strlen
  5575                                  ;   90  1616 storeLabel
  5576                                  ;   91  1627 setTokeType
  5577                                  ;   92  1639 lookCode
  5578                                  ;   93  1648 errorexit
  5579                                  ;   94  1658 errorexit
  5580                                  ;   95  1668 setTokeType
  5581                                  ;   96  1680 genCode8
  5582                                  ;   97  1689 skipBlank
  5583                                  ;   98  1699 isToken
  5584                                  ;   99  1707 genCode8
  5585                                  ;  100  1716 isToken
  5586                                  ;  101  1724 setTokeType
  5587                                  ;  102  1736 genCode16
  5588                                  ;  103  1746 isToken
  5589                                  ;  104  1754 errorexit
  5590                                  ;  105  1772 readRL
  5591                                  ;  106  1779 errorexit
  5592                                  ;  107  1789 ifEOL
  5593                                  ;  108  1803 readRL
  5594                                  ;  109  1839 digit
  5595                                  ;  110  1857 alnum
  5596                                  ;  111  1863 strcpy
  5597                                  ;  112  1870 toupper
  5598                                  ;  113  1886 strlen
  5599                                  ;  114  1893 strlen
  5600                                  ;  115  1900 eqstr
  5601                                  ;  116  1906 eqstr
  5602                                  ;  117  1912 eqstr
  5603                                  ;  118  1918 eqstr
  5604                                  ;  119  1924 eqstr
  5605                                  ;  120  1930 eqstr
  5606                                  ;  121  1936 eqstr
  5607                                  ;  122  1942 eqstr
  5608                                  ;  123  1948 eqstr
  5609                                  ;  124  1954 eqstr
  5610                                  ;  125  1960 eqstr
  5611                                  ;  126  1966 eqstr
  5612                                  ;  127  1972 eqstr
  5613                                  ;  128  1978 eqstr
  5614                                  ;  129  1984 eqstr
  5615                                  ;  130  1990 eqstr
  5616                                  ;  131  1996 eqstr
  5617                                  ;  132  2002 eqstr
  5618                                  ;  133  2008 eqstr
  5619                                  ;  134  2014 eqstr
  5620                                  ;  135  2020 eqstr
  5621                                  ;  136  2026 eqstr
  5622                                  ;  137  2032 eqstr
  5623                                  ;  138  2038 eqstr
  5624                                  ;  139  2044 eqstr
  5625                                  ;  140  2050 eqstr
  5626                                  ;  141  2056 eqstr
  5627                                  ;  142  2062 eqstr
  5628                                  ;  143  2068 eqstr
  5629                                  ;  144  2074 eqstr
  5630                                  ;  145  2694 eqstr
  5631                                  ;  146  2714 prs
  5632                                  ;  147  2718 printhex16
  5633                                  ;  148  2729 prs
  5634                                  ;  149  2733 prc
  5635                                  ;  150  2737 printhex8a
  5636                                  ;  151  2748 prc
  5637                                  ;  152  2752 prs
  5638                                  ;  153  2756 prscomment
  5639                                  ;  154  2773 writetty
  5640                                  ;  155  2782 writetty
  5641                                  ;  156  2791 fputcR
  5642                                  ;  157  2813 prc
  5643                                  ;  158  2829 prc
  5644                                  ;  159  2850 prc
  5645                                  ;  160  2854 prc
  5646                                  ;  161  2876 printhex8a
  5647                                  ;  162  2887 printhex8a
  5648                                  ;  163  2912 printIntU
  5649                                  ;  164  2922 prc
  5650                                  ;  165  2935 prs
  5651                                  ;  166  2939 prs
  5652                                  ;  167  2943 prs
  5653                                  ;  168  2947 prs
  5654                                  ;  169  2964 error1
  5655                                  ;  170  2982 error1
  5656                                  ;  171  3000 error1
  5657                                  ;  172  3019 error1
  5658                                  ;  173  3038 error1
  5659                                  ;  174  3057 error1
  5660                                  ;  175  3076 error1
  5661                                  ;  176  3095 error1
  5662                                  ;  177  3102 end1
  5663                                  ;  178  3116 errorexit
  5664                                  ;  179  3137 errorexit
  5665                                  ;  180  3178 cputs
  5666                                  ;  181  3184 cputs
  5667                                  ;  182  3190 exitR
  5668                                  ;  183  3196 toupper
  5669                                  ;  184  3204 strcpy
  5670                                  ;  185  3211 strcat1
  5671                                  ;  186  3219 strcpy
  5672                                  ;  187  3226 strcat1
  5673                                  ;  188  3234 strcpy
  5674                                  ;  189  3241 strcat1
  5675                                  ;  190  3249 openR
  5676                                  ;  191  3255 cputs
  5677                                  ;  192  3261 cputs
  5678                                  ;  193  3267 exitR
  5679                                  ;  194  3273 creatR
  5680                                  ;  195  3280 cputs
  5681                                  ;  196  3286 cputs
  5682                                  ;  197  3292 exitR
  5683                                  ;  198  3298 creatR
  5684                                  ;  199  3305 cputs
  5685                                  ;  200  3311 cputs
  5686                                  ;  201  3317 exitR
  5687                                  ;  202  3323 prs
  5688                                  ;  203  3327 prs
  5689                                  ;  204  3331 prs
  5690                                  ;  205  3335 prs
  5691                                  ;  206  3339 prs
  5692                                  ;  207  3343 prs
  5693                                  ;  208  3347 prs
  5694                                  ;  209  3351 prs
  5695                                  ;  210  3355 prs
  5696                                  ;  211  3372 prs
  5697                                  ;  212  3376 printIntU
  5698                                  ;  213  3386 prs
  5699                                  ;  214  3390 prs
  5700                                  ;  215  3394 prs
  5701                                  ;  216  3398 prc
  5702                                  ;  217  3402 printhex16
  5703                                  ;  218  3413 prs
  5704                                  ;  219  3417 strlen
  5705                                  ;  220  3424 prs
  5706                                  ;  221  3428 printIntU
  5707                                  ;  222  3438 prs
  5708                                  ;  223  3442 prc
  5709                                  ;  224  3446 printhex8a
  5710                                  ;  225  3457 fputcR
  5711                                  ;  226  3471 fcloseR
  5712                                  ;  227  3479 fcloseR
  5713                                  ;  228  3487 fcloseR
  5714                                  ;  229  3495 exitR
  5715                                  ;  230  3520 putch
  5716                                  ;  231  3574 digit
  5717                                  ;  232  3602 strcpy
  5718                                  ;  233  3617 DosInt
  5719                                  ;  234  3633 DosInt
  5720                                  ;  235  3656 DosInt
  5721                                  ;  236  3675 DosInt
  5722                                  ;  237  3709 writetty
  5723                                  ;  238  3718 writetty
  5724                                  ;Input: AS.C, List: AS.S,  Lines:  269
  5725                                  ;Glob. variables:  154 max.:  200
  5726                                  ;Local variables:    4 max.:  100, in 'searchLabel'
  5727                                  ;Functions      :   72 max.:  300
  5728                                  ;Calls          :  239 max.: 2000, NameField: 3750 max.:    65535
  5729                                  ;Code until     :26009 max.: 30000, free: 3991
  5730                                  ;Data (HeapEnd) :33794, resting stacksize: 31741
  5731                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
