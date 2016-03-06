     1                                  ;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
     2                                  ;1=IMM, 2=REG, 3=ADR, 4=MEM   
     3                                  org 256            ;NASM
     4 00000000 F6D0                    not al             ;F6 D0       
     5 00000002 0800                    VA dw 8            ;08 00   
     6 00000004 414206                  VB db "AB",6       ;41 42 06                 
     7 00000007 48                      dec ax             ;48
     8 00000008 49                      dec word cx        ;49    
     9 00000009 40                      inc ax             ;40
    10 0000000A 47                      inc di             ;47
    11 0000000B FE07                    inc byte [bx]      ;FE 07
    12 0000000D FE0F                    dec byte [bx]      ;FE 0F
    13 0000000F FE4F03                  dec byte [bx+3]    ;FE 4F 03
    14 00000012 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    15 00000015 F6D1                    not cl             ;F6 D1
    16 00000017 FEC9                    dec cl             ;FE C9
    17 00000019 6649                    dec ecx            ;66 49
    18 0000001B FE0F                    dec byte [bx]      ;FE 0F
    19 0000001D FE4F03                  dec byte [bx+3]    ;FE 4F 03
    20 00000020 FE8F0201                dec byte [bx+258]  ;FE 8F 02 01
    21 00000024 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    22                                  ;dec word [cx];inv effective adr
    23                                  ;inc word  VA ;inv comb opcode+operands
    24 00000027 FE06[0200]              inc byte [VA]      ;FE 06 04 00
    25 0000002B FF06[0400]              inc word [VB]      ;FF 06 06 00
    26 0000002F FF06[0800]              inc word [VB+4]    ;FF 06 0A 00
    27 00000033 FE4600                  inc byte [bp]      ;FE 46 00  special case
    28 00000036 FE4604                  inc byte [bp+4]    ;FE 46 04
    29 00000039 FE860201                inc byte [bp+258]  ;FE 86 02 01
    30 0000003D FE810201                inc byte [bx+di+258];FE81 02 01
    31 00000041 FE46FC                  inc byte [bp-4]    ;FE 46 FC
    32 00000044 FE01                    inc byte [bx+di]   ;FE 01
    33 00000046 FE41FC                  inc byte [bx+di-4] ;FE 41 FC
    34 00000049 F7D1                    not cx              ;F7 D1 
    35 0000004B F7D2                    not DX              ;F7 D2      
    36 0000004D F6970201                not byte [bx+258]   ;F6 97 02 01   
    37 00000051 F611                    not byte [bx+di]    ;F6 11       
    38 00000053 F651FC                  not byte [bx+di-4]  ;F6 51 FC     
    39 00000056 F616[0200]              not byte [VA]       ;F6 16 01 00 
    40 0000005A F716[0200]              not word [VA]       ;F7 16 01 00     
    41 0000005E F7D9                    neg cx              ;F7 D9        
    42 00000060 F69F0201                neg byte [bx+258]   ;F6 9F 02 01   
    43 00000064 F619                    neg byte [bx+di]    ;F6 19       
    44 00000066 F659FC                  neg byte [bx+di-4]  ;F6 59 FC     
    45 00000069 F61E[0200]              neg byte [VA]       ;F6 1E 02 00 
    46 0000006D F71E[0200]              neg word [VA]       ;F7 1E 02 00 
    47 00000071 F6E0                    mul al              ;F6 E0       
    48 00000073 F7E0                    mul ax              ;F7 E0       
    49 00000075 F7E1                    mul cx              ;F7 E1       
    50 00000077 F6A70201                mul byte [bx+258]   ;F6 A7 02 01   
    51 0000007B F621                    mul byte [bx+di]    ;F6 21       
    52 0000007D F661FC                  mul byte [bx+di-4]  ;F6 61 FC     
    53 00000080 F626[0200]              mul byte [VA]       ;F6 26 02 00 
    54 00000084 F726[0200]              mul word [VA]       ;F7 26 02 00 
    55 00000088 F6F0                    div al              ;F6 F0       
    56 0000008A F7F0                    div ax              ;F7 F0       
    57 0000008C F7F1                    div cx              ;F7 F1       
    58 0000008E F6B70201                div byte [bx+258]   ;F6 B7 02 01   
    59 00000092 F631                    div byte [bx+di]    ;F6 31       
    60 00000094 F671FC                  div byte [bx+di-4]  ;F6 71 FC     
    61 00000097 F636[0200]              div byte [VA]       ;F6 36 02 00 
    62 0000009B F736[0200]              div word [VA]       ;F7 36 02 00 
    63 0000009F F6F8                    idiv al             ;F6 F8       
    64 000000A1 F7F8                    idiv ax             ;F7 F8       
    65 000000A3 F7F9                    idiv cx             ;F7 F9       
    66 000000A5 F6BF0201                idiv byte [bx+258]  ;F6 BF 02 01   
    67 000000A9 F639                    idiv byte [bx+di]   ;F6 39       
    68 000000AB F679FC                  idiv byte [bx+di-4] ;F6 79 FC     
    69 000000AE F63E[0200]              idiv byte [VA]      ;F6 3E 02 00 
    70 000000B2 F73E[0200]              idiv word [VA]      ;F7 3E 02 00 
    71                                  ;acc, rm           
    72 000000B6 F6E8                    imul al             ;F6 E8    
    73 000000B8 F7E8                    imul ax             ;F7 E8    
    74 000000BA F7E9                    imul cx             ;F7 E9    
    75 000000BC F6AF0201                imul byte [bx+258]  ;F6 AF 02 01
    76 000000C0 F629                    imul byte [bx+di]   ;F6 29    
    77 000000C2 F669FC                  imul byte [bx+di-4] ;F6 69 FC  
    78 000000C5 F62E[0200]              imul byte [VA]      ;F6 2E 01 00 
    79 000000C9 F72E[0200]              imul word [VA]      ;F7 2E 01 00 
    80                                  
    81 000000CD C401                    les ax,  [bx+di]    ;C4 01
    82 000000CF 0FB20E[0200]            lss cx, [VA]        ;0F B2 0E [0400]  
    83 000000D4 C449FC                  les cx, [bx+di-4]   ;C4 49 FC 
    84 000000D7 0FB501                  lgs ax, [bx+di]     ;0F B5 01
    85 000000DA 0FB581[0200]            lgs ax, [VA+bx+di]  ;0F B5 81 01 00
    86                                  ;mov al, [bp-4]     ;8A 46 FC
    87                                  ;mov al, [VB+bx]    ;8A 87 06 00           
    88                                  
    89 000000DF 0404                    add al, 4           ;04 04
    90                                  ;add al, 259      ;;;04 03 bounds
    91 000000E1 83C004                  add ax, 4           ;83 C0 04
    92 000000E4 050301                  add ax, 259         ;05 03 01
    93 000000E7 0C04                    or  al, 4           ;0C 04         
    94 000000E9 150301                  adc ax, 259         ;15 03 01     
    95 000000EC 80C104                  add cl, 4           ;80 C1 04
    96 000000EF 83C104                  add cx, 4           ;83 C1 04 
    97 000000F2 81C10301                add cx, 259         ;81 C1 03 01  
    98 000000F6 80C904                  or  cl, 4           ;80 C9 04  
    99 000000F9 80C9FF                  or  cl, 255         ;80 C9 FF  
   100 000000FC 83C904                  or  cx, 4           ;83 C9 04 
   101 000000FF 83C97F                  or  cx, 127         ;83 C9 7F  
   102 00000102 81C98000                or  cx, 128         ;81 C9 80 00
   103 00000106 81C9FF00                or  cx, 255         ;81 C9 FF 00
   104 0000010A 81C90301                or  cx, 259         ;81 C9 03 01
   105 0000010E 83C402                  add  sp, 2          ;83 C4 02 
   106 00000111 8006[0200]04            add byte [VA], 4    ;80 06 02 01 04
   107 00000116 8306[0200]04            add word [VA], 4    ;83 06 02 01 04  
   108 0000011B 8306[0500]04            add word [VA+3],4   ;83 06 05 01 04   
   109                                  ;add word [VA+di]
   110 00000120 0241FC                  add al, [bx+di-4]   ;02 41 FC    
   111 00000123 01C3                    add bx, ax          ;01 C3
   112 00000125 01D8                    add ax, bx          ;01 D8
   113 00000127 0207                    add al, [bx]        ;02 07
   114 00000129 0307                    add ax, [bx]        ;03 07
   115 0000012B 030F                    add cx, [bx]        ;03 0F
   116 0000012D 010F                    add [bx], cx        ;01 0F
   117 0000012F 0000                    add [bx+si], al     ;00 00
   118 00000131 0001                    add [bx+di], al     ;00 01
   119 00000133 0101                    add [bx+di], ax     ;01 01
   120 00000135 0201                    add al, [bx+di]     ;02 01
   121 00000137 0301                    add ax, [bx+di]     ;03 01    
   122                                  
   123 00000139 B000                    mov al, 0           ;B0 00   
   124 0000013B B003                    mov al, 3           ;B0 03   
   125 0000013D B07F                    mov al, 127         ;B0 7F   
   126 0000013F B0FF                    mov al, 255         ;B0 FF   
   127 00000141 B80000                  mov ax, 0           ;B8 00 00 
   128 00000144 B80301                  mov ax, 259         ;B8 03 01 
   129 00000147 B8FFFF                  mov ax, 65535       ;B8 FF FF 
   130 0000014A B303                    mov bl, 3           ;B3 03   
   131 0000014C BB0300                  mov bx, 3           ;BB 03 00 
   132 0000014F BB0301                  mov bx, 259         ;BB 03 01 
   133 00000152 C606[0200]03            mov byte [VA], 3    ;C6 06 02 00 03  
   134 00000157 C706[0200]0300          mov word [VA], 3    ;C7 06 02 00 03 00
   135 0000015D C706[0200]0301          mov word [VA], 259  ;C7 06 02 00 03 01
   136                                  
   137 00000163 8CC0                    mov ax, es          ;8C C0
   138 00000165 8CC8                    mov ax, cs          ;8C C8
   139 00000167 8CD0                    mov ax, ss          ;8C D0
   140 00000169 8CD8                    mov ax, ds          ;8C D8
   141 0000016B 8CE0                    mov ax, fs          ;8C E0
   142 0000016D 8CE8                    mov ax, gs          ;8C E8   
   143 0000016F 8CC1                    mov cx, es          ;8C C1
   144 00000171 8CC2                    mov dx, es          ;8C C2
   145 00000173 8CD3                    mov bx, ss          ;8C D3
   146 00000175 8CD4                    mov sp, ss          ;8C D4
   147 00000177 8CE5                    mov bp, fs          ;8C E5
   148 00000179 8CE6                    mov si, fs          ;8C E6
   149 0000017B 8CE7                    mov di, fs          ;8C E7     
   150 0000017D 8C41FC                  mov [bx+di-4], es   ;8C 41 FC    
   151 00000180 8C06[0200]              mov [VA], es        ;8C 06 02 00
   152 00000184 8C56FC                  mov [bp-4], ss      ;8C 56 FC
   153 00000187 8C08                    mov word [bx+si],cs ;8C 08  
   154 00000189 8EC0                    mov es, ax          ;8E C0      
   155 0000018B 8ED0                    mov ss, ax          ;8E D0      
   156 0000018D 8E41FC                  mov es, [bx+di-4]   ;8E 41 FC    
   157 00000190 8E06[0200]              mov es, [VA]        ;8E 06 02 00         
   158                                  
   159 00000194 8800                    mov [bx+si], al     ;88 00   
   160 00000196 8808                    mov [bx+si], cl     ;88 08   
   161 00000198 88C8                    mov al, cl          ;88 C8   
   162 0000019A 88C1                    mov cl, al          ;88 C1   
   163 0000019C 8A00                    mov al, [bx+si]     ;8A 00   
   164 0000019E 8A41FC                  mov al, [bx+di-4]   ;8A 41 FC 
   165 000001A1 8A08                    mov cl, [bx+si]     ;8A 08  
   166 000001A3 8A81[0200]              mov al, [VA+bx+di] 
   167 000001A7 8A81[FEFF]              mov al, [VA+bx+di-4]  
   168 000001AB A0[0200]                mov al, [VA]        ;A0 02 00
   169 000001AE A0[0500]                mov al, [VA+3]      ;A0 05 00
   170 000001B1 A1[0200]                mov ax, [VA]        ;A1 02 00
   171 000001B4 A2[0200]                mov [VA], al        ;A2 02 00 
   172 000001B7 B0[0200]                mov al, VA          ;B0 02 00 error  
   173 000001B9 B8[0200]                mov ax, VA          ;B8 02 00
   174 000001BC C706[0200][0200]        mov word [VA], VA   ;C7 06 02 00 02 00
