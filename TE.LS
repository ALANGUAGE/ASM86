     1                                  ;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT
     2                                  ;1=IMM, 2=REG, 3=ADR, 4=MEM
     3                                  org 256            ;NASM
     4 00000000 E97602                  jmp main
     5 00000003 0800                    VA dw 8            ;08 00
     6 00000005 414206                  VB db "AB",6       ;41 42 06
     7 00000008 48                      dec ax             ;48
     8 00000009 49                      dec word cx        ;49
     9 0000000A 40                      inc ax             ;40
    10 0000000B 47                      inc di             ;47
    11 0000000C FE07                    inc byte [bx]      ;FE 07
    12 0000000E FE0F                    dec byte [bx]      ;FE 0F
    13 00000010 FE4F03                  dec byte [bx+3]    ;FE 4F 03
    14 00000013 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    15 00000016 F6D1                    not cl             ;F6 D1
    16 00000018 FEC9                    dec cl             ;FE C9
    17 0000001A 6649                    dec ecx            ;66 49
    18 0000001C FE0F                    dec byte [bx]      ;FE 0F
    19 0000001E FE4F03                  dec byte [bx+3]    ;FE 4F 03
    20 00000021 FE8F0201                dec byte [bx+258]  ;FE 8F 02 01
    21 00000025 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    22                                  ;dec word [cx];inv effective adr
    23                                  ;inc word  VA ;inv comb opcode+operands
    24 00000028 FE06[0300]              inc byte [VA]      ;FE 06 04 00
    25 0000002C FF06[0500]              inc word [VB]      ;FF 06 06 00
    26 00000030 FF06[0900]              inc word [VB+4]    ;FF 06 0A 00
    27 00000034 FE4600                  inc byte [bp]      ;FE 46 00  special case
    28 00000037 FE4604                  inc byte [bp+4]    ;FE 46 04
    29 0000003A FE860201                inc byte [bp+258]  ;FE 86 02 01
    30 0000003E FE810201                inc byte [bx+di+258];FE81 02 01
    31 00000042 FE46FC                  inc byte [bp-4]    ;FE 46 FC
    32 00000045 FE01                    inc byte [bx+di]   ;FE 01
    33 00000047 FE41FC                  inc byte [bx+di-4] ;FE 41 FC
    34 0000004A F7D1                    not cx              ;F7 D1
    35 0000004C F7D2                    not DX              ;F7 D2
    36 0000004E F6970201                not byte [bx+258]   ;F6 97 02 01
    37 00000052 F611                    not byte [bx+di]    ;F6 11
    38 00000054 F651FC                  not byte [bx+di-4]  ;F6 51 FC
    39 00000057 F616[0300]              not byte [VA]       ;F6 16 01 00
    40 0000005B F716[0300]              not word [VA]       ;F7 16 01 00
    41 0000005F F7D9                    neg cx              ;F7 D9
    42 00000061 F69F0201                neg byte [bx+258]   ;F6 9F 02 01
    43 00000065 F619                    neg byte [bx+di]    ;F6 19
    44 00000067 F659FC                  neg byte [bx+di-4]  ;F6 59 FC
    45 0000006A F61E[0300]              neg byte [VA]       ;F6 1E 02 00
    46 0000006E F71E[0300]              neg word [VA]       ;F7 1E 02 00
    47 00000072 F6E0                    mul al              ;F6 E0
    48 00000074 F7E0                    mul ax              ;F7 E0
    49 00000076 F7E1                    mul cx              ;F7 E1
    50 00000078 F6A70201                mul byte [bx+258]   ;F6 A7 02 01
    51 0000007C F621                    mul byte [bx+di]    ;F6 21
    52 0000007E F661FC                  mul byte [bx+di-4]  ;F6 61 FC
    53 00000081 F626[0300]              mul byte [VA]       ;F6 26 02 00
    54 00000085 F726[0300]              mul word [VA]       ;F7 26 02 00
    55 00000089 F6F0                    div al              ;F6 F0
    56 0000008B F7F0                    div ax              ;F7 F0
    57 0000008D F7F1                    div cx              ;F7 F1
    58 0000008F F6B70201                div byte [bx+258]   ;F6 B7 02 01
    59 00000093 F631                    div byte [bx+di]    ;F6 31
    60 00000095 F671FC                  div byte [bx+di-4]  ;F6 71 FC
    61 00000098 F636[0300]              div byte [VA]       ;F6 36 02 00
    62 0000009C F736[0300]              div word [VA]       ;F7 36 02 00
    63 000000A0 F6F8                    idiv al             ;F6 F8
    64 000000A2 F7F8                    idiv ax             ;F7 F8
    65 000000A4 F7F9                    idiv cx             ;F7 F9
    66 000000A6 F6BF0201                idiv byte [bx+258]  ;F6 BF 02 01
    67 000000AA F639                    idiv byte [bx+di]   ;F6 39
    68 000000AC F679FC                  idiv byte [bx+di-4] ;F6 79 FC
    69 000000AF F63E[0300]              idiv byte [VA]      ;F6 3E 02 00
    70 000000B3 F73E[0300]              idiv word [VA]      ;F7 3E 02 00
    71                                  ;acc, rm
    72 000000B7 F6E8                    imul al             ;F6 E8
    73 000000B9 F7E8                    imul ax             ;F7 E8
    74 000000BB F7E9                    imul cx             ;F7 E9
    75 000000BD F6AF0201                imul byte [bx+258]  ;F6 AF 02 01
    76 000000C1 F629                    imul byte [bx+di]   ;F6 29
    77 000000C3 F669FC                  imul byte [bx+di-4] ;F6 69 FC
    78 000000C6 F62E[0300]              imul byte [VA]      ;F6 2E 01 00
    79 000000CA F72E[0300]              imul word [VA]      ;F7 2E 01 00
    80                                  
    81 000000CE C401                    les ax,  [bx+di]    ;C4 01
    82 000000D0 0FB20E[0300]            lss cx, [VA]        ;0F B2 0E [0400]
    83 000000D5 C449FC                  les cx, [bx+di-4]   ;C4 49 FC
    84 000000D8 0FB501                  lgs ax, [bx+di]     ;0F B5 01
    85 000000DB 0FB581[0300]            lgs ax, [VA+bx+di]  ;0F B5 81 01 00
    86                                  ;mov al, [bp-4]     ;8A 46 FC
    87                                  ;mov al, [VB+bx]    ;8A 87 06 00
    88                                  
    89 000000E0 0404                    add al, 4           ;04 04
    90                                  ;add al, 259      ;;;04 03 bounds
    91 000000E2 83C004                  add ax, 4           ;83 C0 04
    92 000000E5 050301                  add ax, 259         ;05 03 01
    93 000000E8 0C04                    or  al, 4           ;0C 04
    94 000000EA 150301                  adc ax, 259         ;15 03 01
    95 000000ED 80C104                  add cl, 4           ;80 C1 04
    96 000000F0 83C104                  add cx, 4           ;83 C1 04
    97 000000F3 81C10301                add cx, 259         ;81 C1 03 01
    98 000000F7 80C904                  or  cl, 4           ;80 C9 04
    99 000000FA 80C9FF                  or  cl, 255         ;80 C9 FF
   100 000000FD 83C904                  or  cx, 4           ;83 C9 04
   101 00000100 83C97F                  or  cx, 127         ;83 C9 7F
   102 00000103 81C98000                or  cx, 128         ;81 C9 80 00
   103 00000107 81C9FF00                or  cx, 255         ;81 C9 FF 00
   104 0000010B 81C90301                or  cx, 259         ;81 C9 03 01
   105 0000010F 83C402                  add  sp, 2          ;83 C4 02
   106 00000112 8006[0300]04            add byte [VA], 4    ;80 06 02 01 04
   107 00000117 8306[0300]04            add word [VA], 4    ;83 06 02 01 04
   108 0000011C 8306[0600]04            add word [VA+3],4   ;83 06 05 01 04
   109                                  ;add word [VA+di]
   110 00000121 0241FC                  add al, [bx+di-4]   ;02 41 FC
   111 00000124 01C3                    add bx, ax          ;01 C3
   112 00000126 01D8                    add ax, bx          ;01 D8
   113 00000128 0207                    add al, [bx]        ;02 07
   114 0000012A 0307                    add ax, [bx]        ;03 07
   115 0000012C 030F                    add cx, [bx]        ;03 0F
   116 0000012E 010F                    add [bx], cx        ;01 0F
   117 00000130 0000                    add [bx+si], al     ;00 00
   118 00000132 0001                    add [bx+di], al     ;00 01
   119 00000134 0101                    add [bx+di], ax     ;01 01
   120 00000136 0201                    add al, [bx+di]     ;02 01
   121 00000138 0301                    add ax, [bx+di]     ;03 01
   122                                  
   123 0000013A B000                    mov al, 0           ;B0 00
   124 0000013C B003                    mov al, 3           ;B0 03
   125 0000013E B07F                    mov al, 127         ;B0 7F
   126 00000140 B0FF                    mov al, 255         ;B0 FF
   127 00000142 B80000                  mov ax, 0           ;B8 00 00
   128 00000145 B80301                  mov ax, 259         ;B8 03 01
   129 00000148 B8FFFF                  mov ax, 65535       ;B8 FF FF
   130 0000014B B303                    mov bl, 3           ;B3 03
   131 0000014D BB0300                  mov bx, 3           ;BB 03 00
   132 00000150 BB0301                  mov bx, 259         ;BB 03 01
   133 00000153 C606[0300]03            mov byte [VA], 3    ;C6 06 02 00 03
   134 00000158 C706[0300]0300          mov word [VA], 3    ;C7 06 02 00 03 00
   135 0000015E C706[0300]0301          mov word [VA], 259  ;C7 06 02 00 03 01
   136                                  
   137 00000164 8CC0                    mov ax, es          ;8C C0
   138 00000166 8CC8                    mov ax, cs          ;8C C8
   139 00000168 8CD0                    mov ax, ss          ;8C D0
   140 0000016A 8CD8                    mov ax, ds          ;8C D8
   141 0000016C 8CE0                    mov ax, fs          ;8C E0
   142 0000016E 8CE8                    mov ax, gs          ;8C E8
   143 00000170 8CC1                    mov cx, es          ;8C C1
   144 00000172 8CC2                    mov dx, es          ;8C C2
   145 00000174 8CD3                    mov bx, ss          ;8C D3
   146 00000176 8CD4                    mov sp, ss          ;8C D4
   147 00000178 8CE5                    mov bp, fs          ;8C E5
   148 0000017A 8CE6                    mov si, fs          ;8C E6
   149 0000017C 8CE7                    mov di, fs          ;8C E7
   150 0000017E 8C41FC                  mov [bx+di-4], es   ;8C 41 FC
   151 00000181 8C06[0300]              mov [VA], es        ;8C 06 02 00
   152 00000185 8C56FC                  mov [bp-4], ss      ;8C 56 FC
   153 00000188 8C08                    mov word [bx+si],cs ;8C 08
   154 0000018A 8EC0                    mov es, ax          ;8E C0
   155 0000018C 8ED0                    mov ss, ax          ;8E D0
   156 0000018E 8E41FC                  mov es, [bx+di-4]   ;8E 41 FC
   157 00000191 8E06[0300]              mov es, [VA]        ;8E 06 02 00
   158 00000195 A0[0300]                mov al, [VA]        ;A0 02 00
   159 00000198 A0[0600]                mov al, [VA+3]      ;A0 05 00
   160 0000019B A1[0300]                mov ax, [VA]        ;A1 02 00
   161 0000019E A2[0300]                mov [VA], al        ;A2 02 00
   162 000001A1 A3[0300]                mov [VA], ax        ;A3 02 00
   163 000001A4 B0[0300]                mov al, VA          ;B0 02 00
   164 000001A6 B8[0300]                mov ax, VA          ;B8 02 00
   165 000001A9 C706[0300][0300]        mov word[VA], VA    ;C7 06 02 00 02 00
   166 000001AF 8800                    mov [bx+si], al     ;88 00
   167 000001B1 8808                    mov [bx+si], cl     ;88 08
   168 000001B3 88C8                    mov al, cl          ;88 C8
   169 000001B5 88C1                    mov cl, al          ;88 C1
   170 000001B7 8A00                    mov al, [bx+si]     ;8A 00
   171 000001B9 8A41FC                  mov al, [bx+di-4]   ;8A 41 FC
   172 000001BC 8A08                    mov cl, [bx+si]     ;8A 08
   173 000001BE 8A80[0300]              mov al, [VA+bx+si]  ;8A 80 02 00
   174 000001C2 8A80[FFFF]              mov al, [VA+bx+si-4];8A 80 FE FF
   175                                  
   176 000001C6 50                      push ax             ;50
   177 000001C7 57                      push di             ;57
   178 000001C8 FF36[0300]              push word [VA]      ;FF 36 02 00
   179 000001CC FF36[0500]              push word [VB]      ;FF 36 04 00
   180 000001D0 68[0300]                push VA             ;68 03(01 ORG incl.)
   181 000001D3 68[0500]                push VB             ;68 05 01
   182                                  
   183 000001D6 58                      pop ax              ;58
   184 000001D7 5F                      pop di              ;5F
   185 000001D8 8F06[0300]              pop word [VA]       ;8F 06 02 00
   186 000001DC 06                      push es             ;06
   187 000001DD 0E                      push cs             ;0E
   188 000001DE 16                      push ss             ;16
   189 000001DF 1E                      push ds             ;1E
   190 000001E0 0FA0                    push fs             ;0F A0
   191 000001E2 0FA8                    push gs             ;0F A8
   192 000001E4 07                      pop es              ;07
   193 000001E5 17                      pop ss              ;17
   194 000001E6 1F                      pop ds              ;1F
   195 000001E7 0FA1                    pop fs              ;0F A1
   196 000001E9 0FA9                    pop gs              ;0F A9
   197 000001EB 6A00                    push 0              ;6A 00
   198 000001ED 6A7F                    push 127            ;6A 7F
   199 000001EF 688000                  push 128            ;68 80 00
   200 000001F2 68FF00                  push 255            ;68 FF 00
   201 000001F5 680001                  push 256            ;68 00 01
   202 000001F8 68FF7F                  push 32767          ;68 FF 7F
   203 000001FB 680080                  push 32768          ;68 00 80
   204 000001FE 68FFFF                  push 65535          ;68 FF FF
   205 00000201 CD21                    L2: int 33          ;CD 21
   206 00000203 CD03                    int 3               ;CD 03
   207 00000205 CC                      int3                ;CC
   208 00000206 CE                      into                ;CE
   209 00000207 C8000000                enter 0,0           ;C8 0000 00
   210 0000020B C8000100                enter 256,0         ;C8 0001 00
   211 0000020F C80080FF                enter 32768,255     ;C8 0080 FF
   212 00000213 C8D20410                ENTER 1234,16       ;C8 D204 10
   213                                  L1:
   214 00000217 70FE                    jo L1               ;70 FE
   215 00000219 7FFC                    JG L1               ;7F FC
   216 0000021B 72E4                    jc L2               ;72 E4
   217 0000021D 0F82E4FD                jc VB               ;0F 82 EA FD
   218 00000221 0F81DEFD                jno VA              ;0F 81 E4 FD
   219 00000225 0F820400                jc L5               ;0F 82 04 00
   220 00000229 0F800100                jo L6               ;0F 80 01 00
   221 0000022D 90                      L5:  nop            ;90
   222 0000022E 0F820200                L6:  jc L7          ;0F 82 02 00
   223 00000232 31C0                    xor ax, ax          ;31 C0
   224                                  L7:
   225 00000234 EBE1                    jmp L1              ;EB E1
   226 00000236 E9CAFD                  jmp VA              ;E9 D0 FD
   227 00000239 E8DBFF                  call L1             ;E8 DB FF
   228 0000023C E8C4FD                  call VA             ;E8 CA FD
   229 0000023F E90400                  jmp L8              ;E9 04 00
   230 00000242 E80100                  call L8             ;E8 01 00
   231 00000245 90                      nop                 ;90
   232                                  L8:
   233 00000246 90                      nop                 ;90
   234 00000247 D0CB                    ror bl, 1           ;D0 CB
   235 00000249 D1CB                    ror bx, 1           ;D1 CB
   236 0000024B D1E3                    shl bx, 1           ;D1 E3
   237 0000024D D1C0                    rol ax, 1           ;D1 C0
   238 0000024F D2E0                    shl al, cl          ;D2 E0
   239 00000251 D3E0                    shl ax, cl          ;D3 E0
   240 00000253 C0E003                  sal al, 3           ;C0 E0 03
   241 00000256 C1E303                  sal bx, 3           ;C1 E3 03
   242 00000259 C02E[0300]03            shr byte [VA], 3    ;C0 2E 02 00 03
   243 0000025E C12E[0300]03            shr word [VA], 3    ;C1 2E 02 00 03
   244                                  section .bss
   245                                  absolute 4096
   246 00001000 <res 00000001>          eins resb 1
   247 00001001 <res 00000008>          acht resd 2
   248 00001009 <res 00000006>          sechs resw 3
   249 0000100F <res 00000002>          zwei resb 2
   250                                  absolute 1044
   251 00000414 <res 00000004>          Einsd resd 1
   252 00000418 <res 00000006>          dreiw resw 3
   253                                  section .text
   254 00000263 A00010                  mov al, [eins]      ;A0 00 10
   255 00000266 A00110                  mov al, [acht]      ;A0 01 10
   256 00000269 A00910                  mov al, [sechs]     ;A0 09 10
   257 0000026C A10F10                  mov ax, [zwei]      ;A1 0F 10
   258 0000026F A01404                  mov al, [Einsd]     ;A0 14 04
   259 00000272 A01804                  mov al, [dreiw]     ;A0 18 04
   260                                  ;push fehler         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   261                                  
   262                                  name: PROC
   263 00000275 90                      nop
   264                                  endp
   265                                  
   266 00000276 90                      nop
   267 00000277 5300                    getarg_1 db "S",0
   268                                  
   269                                  main: PROC
   270 00000279 54                      text1 db "T"
   271 0000027A C8060000                ENTER  6,0
   272 0000027E E90400                  jmp L9              ;E9 04 00
   273 00000281 E80100                  call L9             ;E8 01 00
   274 00000284 90                      nop                 ;90
   275                                  L9:
   276 00000285 68[7902]                push text1
   277 00000288 68[8D02]                push text2
   278 0000028B C9                      leave
   279 0000028C C3                      ret
   280 0000028D 45                      text2 db "E"
   281                                  ENDP
   282                                  
   283 0000028E 90                      L10:nop
