     1                                  ;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
     2                                  ;1=IMM, 2=REG, 3=ADR, 4=MEM   
     3                                  org 256
     4 00000000 FC                      cld                 ;FC
     5 00000001 0800                    VA dw 8             ;08 00  
     6 00000003 F6D0                    not al             
     7 00000005 F7D1                    not cx             
     8 00000007 F6970201                not byte [bx+258]  
     9 0000000B F611                    not byte [bx+di]   
    10 0000000D F651FC                  not byte [bx+di-4] 
    11 00000010 F616[0100]              not byte [VA]      
    12 00000014 F716[0100]              not word [VA]           
    13 00000018 F7D9                    neg cx             
    14 0000001A F69F0201                neg byte [bx+258]  
    15 0000001E F619                    neg byte [bx+di]   
    16 00000020 F659FC                  neg byte [bx+di-4] 
    17 00000023 F61E[0100]              neg byte [VA]      
    18 00000027 F71E[0100]              neg word [VA]      
    19 0000002B F6E0                    mul al             
    20 0000002D F7E0                    mul ax             
    21 0000002F F7E1                    mul cx             
    22 00000031 F6A70201                mul byte [bx+258]  
    23 00000035 F621                    mul byte [bx+di]   
    24 00000037 F661FC                  mul byte [bx+di-4] 
    25 0000003A F626[0100]              mul byte [VA]      
    26 0000003E F726[0100]              mul word [VA]      
    27 00000042 F6F0                    div al             
    28 00000044 F7F0                    div ax             
    29 00000046 F7F1                    div cx             
    30 00000048 F6B70201                div byte [bx+258]  
    31 0000004C F631                    div byte [bx+di]   
    32 0000004E F671FC                  div byte [bx+di-4] 
    33 00000051 F636[0100]              div byte [VA]      
    34 00000055 F736[0100]              div word [VA]      
    35 00000059 F6F8                    idiv al            
    36 0000005B F7F8                    idiv ax            
    37 0000005D F7F9                    idiv cx            
    38 0000005F F6BF0201                idiv byte [bx+258] 
    39 00000063 F639                    idiv byte [bx+di]  
    40 00000065 F679FC                  idiv byte [bx+di-4]
    41 00000068 F63E[0100]              idiv byte [VA]     
    42 0000006C F73E[0100]              idiv word [VA]     
    43                                  ;acc, rm           
    44 00000070 F6E8                    imul al            
    45 00000072 F7E8                    imul ax            
    46 00000074 F7E9                    imul cx            
    47 00000076 F6AF0201                imul byte [bx+258] 
    48 0000007A F629                    imul byte [bx+di]  
    49 0000007C F669FC                  imul byte [bx+di-4]
    50 0000007F F62E[0100]              imul byte [VA]     
    51 00000083 F72E[0100]              imul word [VA]     
    52 00000087 C401                    les ax,  [bx+di]    ;C4 01
    53 00000089 0FB20E[0100]            lss cx, [VA]        ;0F B2 0E [0400]  
    54 0000008E C449FC                  les cx, [bx+di-4]   ;C4 49 FC 
    55 00000091 0FB501                  lgs ax, [bx+di]     ;0F B5 01
    56 00000094 0FB581[0100]            lgs ax, [VA+bx+di]  ;0F  
    57                                  ;mov al, [bp-4]     ;8A 46 FC
    58                                  ;mov al, [VB+bx]    ;8A 87 06 00           
    59 00000099 0404                    add al, 4           ;04 04
    60                                  ;add al, 259      ;;;04 03 bounds
    61 0000009B 83C004                  add ax, 4           ;83 C0 04 ;05 04 00
    62 0000009E 050301                  add ax, 259         ;05 03 01
    63 000000A1 0C04                    or  al, 4           ;0C 04         
    64 000000A3 150301                  adc ax, 259         ;15 03 01     
    65 000000A6 80C104                  add cl, 4           ;80 C1 04
    66 000000A9 81C10301                add cx, 259         ;81 C1 03 01
    67 000000AD 8006[0100]04            add byte [VA], 4    ;80 06 01 01 04
    68 000000B2 8306[0100]04            add word [VA], 4  ;;;83 06 01 01 04  
    69 000000B7 8306[0400]04            add word [VA+3],4   
    70                                  ;add word [VA+di]
    71 000000BC 0241FC                  add al, [bx+di-4]   ;02 41 FC    
    72 000000BF 01C3                    add bx, ax          ;01 C3
    73 000000C1 01D8                    add ax, bx          ;01 D8
    74 000000C3 0207                    add al, [bx]        ;02 07
    75 000000C5 0307                    add ax, [bx]        ;03 07
    76 000000C7 0001                    add [bx+di], al     ;00 01
    77 000000C9 0101                    add [bx+di], ax     ;01 01
    78 000000CB 0201                    add al, [bx+di]     ;02 01
    79 000000CD 0301                    add ax, [bx+di]     ;03 01
