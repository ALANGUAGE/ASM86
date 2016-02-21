     1                                  ;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
     2                                  ;1=IMM, 2=REG, 3=ADR, 4=MEM   
     3                                  org 256
     4 00000000 F6D0                    not al              ;F6 D0       
     5 00000002 0800                    VA dw 8             ;08 00  
     6 00000004 F7D1                    not cx              ;F7 D1       
     7 00000006 F6970201                not byte [bx+258]   ;F6 97 02 01   
     8 0000000A F611                    not byte [bx+di]    ;F6 11       
     9 0000000C F651FC                  not byte [bx+di-4]  ;F6 51 FC     
    10 0000000F F616[0200]              not byte [VA]       ;F6 16 01 00 
    11 00000013 F716[0200]              not word [VA]       ;F7 16 01 00     
    12 00000017 F7D9                    neg cx             
    13 00000019 F69F0201                neg byte [bx+258]  
    14 0000001D F619                    neg byte [bx+di]   
    15 0000001F F659FC                  neg byte [bx+di-4] 
    16 00000022 F61E[0200]              neg byte [VA]      
    17 00000026 F71E[0200]              neg word [VA]      
    18 0000002A F6E0                    mul al             
    19 0000002C F7E0                    mul ax             
    20 0000002E F7E1                    mul cx             
    21 00000030 F6A70201                mul byte [bx+258]  
    22 00000034 F621                    mul byte [bx+di]   
    23 00000036 F661FC                  mul byte [bx+di-4] 
    24 00000039 F626[0200]              mul byte [VA]      
    25 0000003D F726[0200]              mul word [VA]      
    26 00000041 F6F0                    div al             
    27 00000043 F7F0                    div ax             
    28 00000045 F7F1                    div cx             
    29 00000047 F6B70201                div byte [bx+258]  
    30 0000004B F631                    div byte [bx+di]   
    31 0000004D F671FC                  div byte [bx+di-4] 
    32 00000050 F636[0200]              div byte [VA]      
    33 00000054 F736[0200]              div word [VA]      
    34 00000058 F6F8                    idiv al            
    35 0000005A F7F8                    idiv ax            
    36 0000005C F7F9                    idiv cx            
    37 0000005E F6BF0201                idiv byte [bx+258] 
    38 00000062 F639                    idiv byte [bx+di]  
    39 00000064 F679FC                  idiv byte [bx+di-4]
    40 00000067 F63E[0200]              idiv byte [VA]     
    41 0000006B F73E[0200]              idiv word [VA]     
    42                                  ;acc, rm           
    43 0000006F F6E8                    imul al             ;F6 E8    
    44 00000071 F7E8                    imul ax             ;F7 E8    
    45 00000073 F7E9                    imul cx             ;F7 E9    
    46 00000075 F6AF0201                imul byte [bx+258]  ;F6 AF 02 01
    47 00000079 F629                    imul byte [bx+di]   ;F6 29    
    48 0000007B F669FC                  imul byte [bx+di-4] ;F6 69 FC  
    49 0000007E F62E[0200]              imul byte [VA]      ;F6 2E 01 00 
    50 00000082 F72E[0200]              imul word [VA]      ;F7 2E 01 00 
    51 00000086 C401                    les ax,  [bx+di]    ;C4 01
    52 00000088 0FB20E[0200]            lss cx, [VA]        ;0F B2 0E [0400]  
    53 0000008D C449FC                  les cx, [bx+di-4]   ;C4 49 FC 
    54 00000090 0FB501                  lgs ax, [bx+di]     ;0F B5 01
    55 00000093 0FB581[0200]            lgs ax, [VA+bx+di]  ;0F B5 81 01 00
    56                                  ;mov al, [bp-4]     ;8A 46 FC
    57                                  ;mov al, [VB+bx]    ;8A 87 06 00           
    58 00000098 0404                    add al, 4           ;04 04
    59                                  ;add al, 259      ;;;04 03 bounds
    60 0000009A 83C004                  add ax, 4           ;05 04 00 ;83 C0 04 XXXXXXXX
    61 0000009D 050301                  add ax, 259         ;05 03 01
    62 000000A0 0C04                    or  al, 4           ;0C 04         
    63 000000A2 150301                  adc ax, 259         ;15 03 01     
    64 000000A5 80C104                  add cl, 4           ;80 C1 04
    65 000000A8 83C104                  add cx, 4           ;83 C1 04 
    66 000000AB 81C10301                add cx, 259         ;81 C1 03 01
    67 000000AF 83C402                  add  sp, 2          ;83 C4 02 
    68 000000B2 8006[0200]04            add byte [VA], 4    ;80 06 02 01 04
    69 000000B7 8306[0200]04            add word [VA], 4    ;83 06 02 01 04  
    70 000000BC 8306[0500]04            add word [VA+3],4   ;83 06 05 00 04   
    71                                  ;add word [VA+di]
    72 000000C1 0241FC                  add al, [bx+di-4]   ;02 41 FC    
    73 000000C4 01C3                    add bx, ax          ;01 C3
    74 000000C6 01D8                    add ax, bx          ;01 D8
    75 000000C8 0207                    add al, [bx]        ;02 07
    76 000000CA 0307                    add ax, [bx]        ;03 07
    77 000000CC 030F                    add cx, [bx]        ;03 0F
    78 000000CE 010F                    add [bx], cx        ;01 0F
    79 000000D0 0000                    add [bx+si], al     ;00 00
    80 000000D2 0001                    add [bx+di], al     ;00 01
    81 000000D4 0101                    add [bx+di], ax     ;01 01
    82 000000D6 0201                    add al, [bx+di]     ;02 01
    83 000000D8 0301                    add ax, [bx+di]     ;03 01
