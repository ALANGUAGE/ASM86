     1                                  ;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
     2                                  ;1=IMM, 2=REG, 3=ADR, 4=MEM   
     3                                  org 256             ;NASM
     4 00000000 F6D0                    not al              ;F6 D0       
     5 00000002 0800                    VA dw 8             ;08 00  
     6 00000004 F7D1                    not cx              ;F7 D1 
     7 00000006 F7D2                    not DX              ;F7 D2      
     8 00000008 F6970201                not byte [bx+258]   ;F6 97 02 01   
     9 0000000C F611                    not byte [bx+di]    ;F6 11       
    10 0000000E F651FC                  not byte [bx+di-4]  ;F6 51 FC     
    11 00000011 F616[0200]              not byte [VA]       ;F6 16 01 00 
    12 00000015 F716[0200]              not word [VA]       ;F7 16 01 00     
    13 00000019 F7D9                    neg cx              ;F7 D9        
    14 0000001B F69F0201                neg byte [bx+258]   ;F6 9F 02 01   
    15 0000001F F619                    neg byte [bx+di]    ;F6 19       
    16 00000021 F659FC                  neg byte [bx+di-4]  ;F6 59 FC     
    17 00000024 F61E[0200]              neg byte [VA]       ;F6 1E 02 00 
    18 00000028 F71E[0200]              neg word [VA]       ;F7 1E 02 00 
    19 0000002C F6E0                    mul al              ;F6 E0       
    20 0000002E F7E0                    mul ax              ;F7 E0       
    21 00000030 F7E1                    mul cx              ;F7 E1       
    22 00000032 F6A70201                mul byte [bx+258]   ;F6 A7 02 01   
    23 00000036 F621                    mul byte [bx+di]    ;F6 21       
    24 00000038 F661FC                  mul byte [bx+di-4]  ;F6 61 FC     
    25 0000003B F626[0200]              mul byte [VA]       ;F6 26 02 00 
    26 0000003F F726[0200]              mul word [VA]       ;F7 26 02 00 
    27 00000043 F6F0                    div al              ;F6 F0       
    28 00000045 F7F0                    div ax              ;F7 F0       
    29 00000047 F7F1                    div cx              ;F7 F1       
    30 00000049 F6B70201                div byte [bx+258]   ;F6 B7 02 01   
    31 0000004D F631                    div byte [bx+di]    ;F6 31       
    32 0000004F F671FC                  div byte [bx+di-4]  ;F6 71 FC     
    33 00000052 F636[0200]              div byte [VA]       ;F6 36 02 00 
    34 00000056 F736[0200]              div word [VA]       ;F7 36 02 00 
    35 0000005A F6F8                    idiv al             ;F6 F8       
    36 0000005C F7F8                    idiv ax             ;F7 F8       
    37 0000005E F7F9                    idiv cx             ;F7 F9       
    38 00000060 F6BF0201                idiv byte [bx+258]  ;F6 BF 02 01   
    39 00000064 F639                    idiv byte [bx+di]   ;F6 39       
    40 00000066 F679FC                  idiv byte [bx+di-4] ;F6 79 FC     
    41 00000069 F63E[0200]              idiv byte [VA]      ;F6 3E 02 00 
    42 0000006D F73E[0200]              idiv word [VA]      ;F7 3E 02 00 
    43                                  ;acc, rm           
    44 00000071 F6E8                    imul al             ;F6 E8    
    45 00000073 F7E8                    imul ax             ;F7 E8    
    46 00000075 F7E9                    imul cx             ;F7 E9    
    47 00000077 F6AF0201                imul byte [bx+258]  ;F6 AF 02 01
    48 0000007B F629                    imul byte [bx+di]   ;F6 29    
    49 0000007D F669FC                  imul byte [bx+di-4] ;F6 69 FC  
    50 00000080 F62E[0200]              imul byte [VA]      ;F6 2E 01 00 
    51 00000084 F72E[0200]              imul word [VA]      ;F7 2E 01 00 
    52                                  
    53 00000088 C401                    les ax,  [bx+di]    ;C4 01
    54 0000008A 0FB20E[0200]            lss cx, [VA]        ;0F B2 0E [0400]  
    55 0000008F C449FC                  les cx, [bx+di-4]   ;C4 49 FC 
    56 00000092 0FB501                  lgs ax, [bx+di]     ;0F B5 01
    57 00000095 0FB581[0200]            lgs ax, [VA+bx+di]  ;0F B5 81 01 00
    58                                  ;mov al, [bp-4]     ;8A 46 FC
    59                                  ;mov al, [VB+bx]    ;8A 87 06 00           
    60                                  
    61 0000009A 0404                    add al, 4           ;04 04
    62                                  ;add al, 259      ;;;04 03 bounds
    63 0000009C 83C004                  add BYTE ax, 4           ;05 04 00 ;83 C0 04 XXXXXXXX
    64 0000009F 050301                  add ax, 259         ;05 03 01
    65 000000A2 0C04                    or  al, 4           ;0C 04         
    66 000000A4 150301                  adc ax, 259         ;15 03 01     
    67 000000A7 80C104                  add cl, 4           ;80 C1 04
    68 000000AA 83C104                  add cx, 4           ;83 C1 04 
    69 000000AD 81C10301                add cx, 259         ;81 C1 03 01
    70 000000B1 83C402                  add  sp, 2          ;83 C4 02 
    71 000000B4 8006[0200]04            add byte [VA], 4    ;80 06 02 01 04
    72 000000B9 8306[0200]04            add word [VA], 4    ;83 06 02 01 04  
    73 000000BE 8306[0500]04            add word [VA+3],4   ;83 06 05 00 04   
    74                                  ;add word [VA+di]
    75 000000C3 0241FC                  add al, [bx+di-4]   ;02 41 FC    
    76 000000C6 01C3                    add bx, ax          ;01 C3
    77 000000C8 01D8                    add ax, bx          ;01 D8
    78 000000CA 0207                    add al, [bx]        ;02 07
    79 000000CC 0307                    add ax, [bx]        ;03 07
    80 000000CE 030F                    add cx, [bx]        ;03 0F
    81 000000D0 010F                    add [bx], cx        ;01 0F
    82 000000D2 0000                    add [bx+si], al     ;00 00
    83 000000D4 0001                    add [bx+di], al     ;00 01
    84 000000D6 0101                    add [bx+di], ax     ;01 01
    85 000000D8 0201                    add al, [bx+di]     ;02 01
    86 000000DA 0301                    add ax, [bx+di]     ;03 01
