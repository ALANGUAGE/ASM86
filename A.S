;PLA compiler A.COM V1.0.1, Input: A.C, Output: A.S
org  256 
jmp main
;-1 char Version1[]="PLA compiler A.COM V1.0.1";//16759 bytes. 32905 stack

Version1 db "PLA compiler A.COM V1.0.1",0
;-2 //todo:op=reg not recognized

;-3 #define IDLENMAX       31//max length of names

;-4 #define COLUMNMAX     128//output, input is 100

;-5 #define T_NAME        256//the following defines for better clearity

;-6 #define T_CONST       257

;-7 #define T_STRING      258

;-8 #define T_DEFINE      511

;-9 #define T_RETURN      512

;-10 #define T_IF          513

;-11 #define T_ELSE        514

;-12 #define T_WHILE       515

;-13 #define T_DO          516

;-14 #define T_INT         517

;-15 #define T_ASM         518

;-16 #define T_ASMBLOCK    519

;-17 #define T_ASMDIRECT   525

;-18 #define T_EMIT        520

;-19 #define T_GOTO        521

;-20 #define T_VOID        529

;-21 #define T_CHAR        530

;-22 #define T_SIGNED      531

;-23 #define T_UNSIGNED    532

;-24 #define T_LONG        533

;-25 #define T_INTH        600

;-26 #define T_EQ          806

;-27 #define T_NE          807

;-28 #define T_GE          811

;-29 #define T_LE          824

;-30 #define T_PLUSPLUS   1219

;-31 #define T_MINUSMINUS 1225

;-32 #define T_PLUSASS    1230

;-33 #define T_MINUSASS   1231

;-34 #define T_MULASS     1232

;-35 #define T_DIVASS     1233

;-36 #define T_ANDASS     1234

;-37 #define T_ORASS      1235

;-38 #define T_LESSLESS   1240

;-39 #define T_GREATGREAT 1241

;-40 

;-41 char isPrint=1;//set screen listing

isPrint db 1
;-42 #define ORGDATA     20000//set it to end of text

;-43 unsigned int orgDataOriginal=20000;//must be ORGDATA

orgDataOriginal dw 20000
;-44 unsigned int orgDatai;//actual max of array, must be less than stack

orgDatai dw 0
;-45 #define COMAX        3000

;-46 char co[COMAX];//constant storage

section .bss
absolute 20000
co resb 3000
section .text
;-47 int maxco=0;

maxco dw 0
;-48 int maxco1=0;

maxco1 dw 0
;-49 #define CMDLENMAX      67

;-50 char Symbol[COLUMNMAX];

section .bss
absolute 23000
Symbol resb 128
section .text
;-51 char fname[CMDLENMAX];

section .bss
absolute 23128
fname resb 67
section .text
;-52 char namein[CMDLENMAX];

section .bss
absolute 23195
namein resb 67
section .text
;-53 char namelst[CMDLENMAX];

section .bss
absolute 23262
namelst resb 67
section .text
;-54 char *cloc=0;

cloc dw 0
;-55 int fdin=0;

fdin dw 0
;-56 int fdout=0;

fdout dw 0
;-57 int token=0;

token dw 0
;-58 int column=0;

column dw 0
;-59 char thechar=0;   //reads one char forward

thechar db 0
;-60 int iscmp=0;

iscmp dw 0
;-61 int nconst=0;

nconst dw 0
;-62 int nreturn=0;

nreturn dw 0
;-63 int nlabel=0;‚

nlabel dw 0
;-64 unsigned int lexval=0;

lexval dw 0
;-65 int typei;       char istype;

typei dw 0
istype db 0
;-66 int signi;       char issign;

signi dw 0
issign db 0
;-67 int widthi;      char iswidth;

widthi dw 0
iswidth db 0
;-68 int wi=0;

wi dw 0
;-69 #define VARMAX        400//max global and local var

;-70 char GType [VARMAX]; // 0=V, 1=*, 2=&,#

section .bss
absolute 23329
GType resb 400
section .text
;-71 char GSign [VARMAX]; // 0=U, 1=S

section .bss
absolute 23729
GSign resb 400
section .text
;-72 char GWidth[VARMAX]; // 0, 1, 2, 4

section .bss
absolute 24129
GWidth resb 400
section .text
;-73 int  GData [VARMAX];

section .bss
absolute 24529
GData resw 400
section .text
;-74 #define VARNAMESMAX 4000

;-75 char VarNames[VARNAMESMAX];//Space for global and local var names

section .bss
absolute 25329
VarNames resb 4000
section .text
;-76 char *VarNamePtr;   //first free position

VarNamePtr dw 0
;-77 int GTop=1;         //0 = empty

GTop dw 1
;-78 // int LStart=1  ;     //max global var

;-79 int LTop=1;

LTop dw 1
;-80 

;-81 #define FUNCMAX       300//max functions

;-82 #define FUNCTIONNAMESMAX 3000//Space for preceeding functon names

;-83 char FunctionNames[FUNCTIONNAMESMAX];

section .bss
absolute 29329
FunctionNames resb 3000
section .text
;-84 char *FunctionNamePtr;  //first free position in FunctionNames

FunctionNamePtr dw 0
;-85 int  FunctionMaxIx=0;   //number of functions

FunctionMaxIx dw 0
;-86 

;-87 char fgetsdest[COLUMNMAX];

section .bss
absolute 32329
fgetsdest resb 128
section .text
;-88 unsigned char *fgetsp=0;

fgetsp dw 0
;-89 unsigned int lineno=1;

lineno dw 1
;-90 unsigned char *pt=0;

pt dw 0
;-91 unsigned char *p1=0;

p1 dw 0
;-92 int DOS_ERR=0;

DOS_ERR dw 0
;-93 int DOS_NoBytes=0;

DOS_NoBytes dw 0
;-94 char DOS_ByteRead=0;

DOS_ByteRead db 0
;-95 int ireg1;

ireg1 dw 0
;-96 int mod2;

mod2 dw 0
;-97 int ireg2;

ireg2 dw 0
;-98 

;-99 int writetty()     {//char in AL


writetty: PROC
;-100     ah=0x0E;

 mov  ah, 14
;-101     asm push bx

 push bx
;-102     bx=0;     //page in BH

 mov  bx, 0
;-103     inth 0x10;

 int  16
;-104     asm pop bx

 pop bx
;-105 }

;-106 int putch(char c)  {

 ret
ENDP

putch: PROC
;-107     if (c==10)  {// LF

;Function : putch, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-108         al=13;   // CR, write CR first and then LF

 mov  al, 13
;-109         writetty();

 call writetty
;-110     }

;-111     al=c;

.putch1:
 mov  al, [bp+4]
;-112     writetty();

 call writetty
;-113 }

;-114 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-115     char c;

;-116     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-117         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-118         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-119         s++;

 inc  word[bp+4]
;-120     }

;-121 }

 jmp .cputs2
.cputs3:
;-122 int mkneg(int n)   {

 LEAVE
 ret
ENDP

mkneg: PROC
;-123     n; // ax=n;

;Function : mkneg, Number local Var: 1
; # type sign width local variables
;95 var sign word n = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
;-124     asm neg ax

 neg ax
;-125 }

;-126 

;-127 int DosInt() {

 LEAVE
 ret
ENDP

DosInt: PROC
;-128     inth 0x21;

 int  33
;-129     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-130     DOS_ERR++;

 inc  word[DOS_ERR]
;-131 }

;-132 int openR (char *s) {

 ret
ENDP

openR: PROC
;-133 	dx=s;

;Function : openR, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
;-134     ax=0x3D02;

 mov  ax, 15618
;-135     DosInt();

 call DosInt
;-136 }

;-137 int creatR(char *s) {

 LEAVE
 ret
ENDP

creatR: PROC
;-138     dx=s;

;Function : creatR, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
;-139     cx=0;

 mov  cx, 0
;-140     ax=0x3C00;

 mov  ax, 15360
;-141     DosInt();

 call DosInt
;-142 }

;-143 int fcloseR(int fd) {

 LEAVE
 ret
ENDP

fcloseR: PROC
;-144     bx=fd;

;Function : fcloseR, Number local Var: 1
; # type sign width local variables
;95 var sign word fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
;-145     ax=0x3E00;

 mov  ax, 15872
;-146     DosInt();

 call DosInt
;-147 }

;-148 int exitR  (char c) {

 LEAVE
 ret
ENDP

exitR: PROC
;-149     ah=0x4C;

;Function : exitR, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov  ah, 76
;-150     al=c;

 mov  al, [bp+4]
;-151     DosInt();

 call DosInt
;-152 }

;-153 int readRL(char *s, int fd, int len){

 LEAVE
 ret
ENDP

readRL: PROC
;-154     dx=s;

;Function : readRL, Number local Var: 3
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign word fd = bp+6
;97 var sign word len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
;-155     cx=len;

 mov  cx, [bp+8]
;-156     bx=fd;

 mov  bx, [bp+6]
;-157     ax=0x3F00;

 mov  ax, 16128
;-158     DosInt();

 call DosInt
;-159 }

;-160 int fputcR(char *n, int fd) {

 LEAVE
 ret
ENDP

fputcR: PROC
;-161     asm lea dx, [bp+4]; *n  todo: why not mov

;Function : fputcR, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte n = bp+4
;96 var sign word fd = bp+6;
 ENTER  0,0
 lea dx, [bp+4]; *n  todo: why not mov
;-162     asm mov cx, 1;      cx=1;

 mov cx, 1;      cx=1;
;-163     asm mov bx, [bp+6]; bx=fd;

 mov bx, [bp+6]; bx=fd;
;-164     asm mov ax, 16384;  ax=0x4000;

 mov ax, 16384;  ax=0x4000;
;-165     DosInt();

 call DosInt
;-166 }

;-167 

;-168 int letter(char c) {

 LEAVE
 ret
ENDP

letter: PROC
;-169       if (c=='_') return 1;

;Function : letter, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letter4
 mov ax, 1
 jmp .retnletter
;-170       if (c=='.') return 1;

.letter4:
 mov al, [bp+4]
 cmp al, 46
 jne .letter5
 mov ax, 1
 jmp .retnletter
;-171       if (c=='?') return 1;

.letter5:
 mov al, [bp+4]
 cmp al, 63
 jne .letter6
 mov ax, 1
 jmp .retnletter
;-172       if (c=='$') return 1;

.letter6:
 mov al, [bp+4]
 cmp al, 36
 jne .letter7
 mov ax, 1
 jmp .retnletter
;-173       if (c> 'z') return 0;

.letter7:
 mov al, [bp+4]
 cmp al, 122
 jle .letter8
 mov ax, 0
 jmp .retnletter
;-174       if (c< '@') return 0;// at included

.letter8:
 mov al, [bp+4]
 cmp al, 64
 jge .letter9
 mov ax, 0
 jmp .retnletter
;-175       if (c> 'Z') { if (c< 'a') return 0; }

.letter9:
 mov al, [bp+4]
 cmp al, 90
 jle .letter10
 mov al, [bp+4]
 cmp al, 97
 jge .letter11
 mov ax, 0
 jmp .retnletter
.letter11:
;-176       return 1;

.letter10:
 mov ax, 1
 jmp .retnletter
;-177 }

;-178 int digit(char c){

 .retnletter:
 LEAVE
 ret
ENDP

digit: PROC
;-179       if(c<'0') return 0;

;Function : digit, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit12
 mov ax, 0
 jmp .retndigit
;-180       if(c>'9') return 0;

.digit12:
 mov al, [bp+4]
 cmp al, 57
 jle .digit13
 mov ax, 0
 jmp .retndigit
;-181       return 1;

.digit13:
 mov ax, 1
 jmp .retndigit
;-182 }

;-183 int alnum(char c) {

 .retndigit:
 LEAVE
 ret
ENDP

alnum: PROC
;-184     if (digit (c)) return 1;

;Function : alnum, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .alnum14
 mov ax, 1
 jmp .retnalnum
;-185     if (letter(c)) return 1;

.alnum14:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letter
 add  sp, 2
 or  al, al
 je .alnum15
 mov ax, 1
 jmp .retnalnum
;-186     return 0;

.alnum15:
 mov ax, 0
 jmp .retnalnum
;-187 }

;-188 

;-189 int strlen(char *s) { int c;

 .retnalnum:
 LEAVE
 ret
ENDP

strlen: PROC
;-190     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-191     while (*s!=0) {s++; c++;}

.strlen16:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen17
 inc  word[bp+4]
 inc  word[bp-2]
;-192     return c;

 jmp .strlen16
.strlen17:
 mov ax, [bp-2]
 jmp .retnstrlen
;-193 }

;-194 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-195     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-196     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy19
 jmp .strcpy18
.strcpy19:
;-197     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-198     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-199 }

;-200 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-201     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte p = bp+4
;96 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr21
;-202         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr22
 mov ax, 0
 jmp .retneqstr
;-203         p++;

.eqstr22:
 inc  word[bp+4]
;-204         q++;

 inc  word[bp+6]
;-205     }

;-206     if(*q) return 0;

 jmp .eqstr20
.eqstr21:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr23
 mov ax, 0
 jmp .retneqstr
;-207     return 1;

.eqstr23:
 mov ax, 1
 jmp .retneqstr
;-208 }

;-209 int strcat(char *s, char *t) {

 .retneqstr:
 LEAVE
 ret
ENDP

strcat: PROC
;-210     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat25
 inc  word[bp+4]
;-211     strcpy(s, t);

 jmp .strcat24
.strcat25:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-212 }

;-213 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-214     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper27
;-215         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper28
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper29
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-216         s++;

.toupper29:
.toupper28:
 inc  word[bp+4]
;-217     }

;-218 }

 jmp .toupper26
.toupper27:
;-219 int instr1(char *s, char c) {

 LEAVE
 ret
ENDP

instr1: PROC
;-220     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign byte c = bp+6;
 ENTER  0,0
.instr130:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr131
;-221         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr132
 mov ax, 1
 jmp .retninstr1
;-222         s++;

.instr132:
 inc  word[bp+4]
;-223     }

;-224     return 0;

 jmp .instr130
.instr131:
 mov ax, 0
 jmp .retninstr1
;-225 }

;-226 

;-227 int eprc(char c)  {

 .retninstr1:
 LEAVE
 ret
ENDP

eprc: PROC
;-228     *cloc=c;

;Function : eprc, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov  bx, [cloc]
 mov  [bx], al
;-229     cloc++;

 inc  word[cloc]
;-230 }

;-231 int eprs(char *s) {

 LEAVE
 ret
ENDP

eprs: PROC
;-232     char c;

;-233     while(*s) {

;Function : eprs, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign byte c = bp-2;
 ENTER  2,0
.eprs33:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eprs34
;-234         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-235         eprc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call eprc
 add  sp, 2
;-236         s++;

 inc  word[bp+4]
;-237     }

;-238 }

 jmp .eprs33
.eprs34:
;-239 

;-240 int prc(unsigned char c) {

 LEAVE
 ret
ENDP

prc: PROC
;-241     if (isPrint) {

;Function : prc, Number local Var: 1
; # type sign width local variables
;95 var unsg byte c = bp+4;
 ENTER  0,0
 mov al, [isPrint]
 or  al, al
 je .prc35
;-242         if (c==10) {

 mov al, [bp+4]
 cmp al, 10
 jne .prc36
;-243             asm mov ax, 13

 mov ax, 13
;-244             writetty();

 call writetty
;-245         }

;-246         asm mov al, [bp+4]; al=c;

.prc36:
 mov al, [bp+4]; al=c;
;-247         writetty();

 call writetty
;-248     }

;-249     fputcR(c, fdout);

.prc35:
 push word [fdout]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-250 }

;-251 

;-252 int prscomment(unsigned char *s) {

 LEAVE
 ret
ENDP

prscomment: PROC
;-253     unsigned char c;

;-254     while(*s){

;Function : prscomment, Number local Var: 2
; # type sign width local variables
;95 ptr unsg byte s = bp+4
;96 var unsg byte c = bp-2;
 ENTER  2,0
.prscomment37:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment38
;-255         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-256         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-257         s++;

 inc  word[bp+4]
;-258     }

;-259 }

 jmp .prscomment37
.prscomment38:
;-260 

;-261 int printstring(unsigned char *s) {

 LEAVE
 ret
ENDP

printstring: PROC
;-262     unsigned char c; int com;

;-263     com=0;

;Function : printstring, Number local Var: 3
; # type sign width local variables
;95 ptr unsg byte s = bp+4
;96 var unsg byte c = bp-2
;97 var sign word com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax
;-264     while(*s) {

.printstring39:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .printstring40
;-265         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-266         if (c==34) if (com) com=0;

 mov al, [bp-2]
 cmp al, 34
 jne .printstring41
 mov ax, [bp-4]
 or  al, al
 je .printstring42
 mov ax, 0
 mov [bp-4], ax
;-267                    else com=1;

 jmp .printstring43
.printstring42:
 mov ax, 1
 mov [bp-4], ax
;-268         if (c==92) {

.printstring43:
.printstring41:
 mov al, [bp-2]
 cmp al, 92
 jne .printstring44
;-269             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .printstring45
;-270                 s++;

 inc  word[bp+4]
;-271                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-272                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .printstring46
 mov ax, 10
 mov [bp-2], al
;-273                 if (c=='t') c= 9;

.printstring46:
 mov al, [bp-2]
 cmp al, 116
 jne .printstring47
 mov ax, 9
 mov [bp-2], al
;-274             }

.printstring47:
;-275         }

.printstring45:
;-276         prc(c);

.printstring44:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-277         s++;

 inc  word[bp+4]
;-278     }

;-279 }

 jmp .printstring39
.printstring40:
;-280 

;-281 int eprnum(int n){//for docall procedure

 LEAVE
 ret
ENDP

eprnum: PROC
;-282     int e;

;-283     if(n<0) {

;Function : eprnum, Number local Var: 2
; # type sign width local variables
;95 var sign word n = bp+4
;96 var sign word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 0
 jge .eprnum48
;-284         eprc('-');

 push 45
 call eprc
 add  sp, 2
;-285         n=mkneg(n);

 push word [bp+4]
 call mkneg
 add  sp, 2
 mov [bp+4], ax
;-286     }

;-287     if (n >= 10) {

.eprnum48:
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 1
 jl  .eprnum49
;-288         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 cwd
 idiv bx
 mov [bp-2], ax
;-289         eprnum(e);

 push word [bp-2]
 call eprnum
 add  sp, 2
;-290     }

;-291     n=n%10;

.eprnum49:
 mov ax, [bp+4]
 mov bx, 10
 cwd
 idiv bx
 mov ax, dx
 mov [bp+4], ax
;-292     n=n+'0';

 mov ax, [bp+4]
 add ax, 48
 mov [bp+4], ax
;-293     eprc(n);

 push word [bp+4]
 call eprc
 add  sp, 2
;-294 }

;-295 

;-296 int printinteger (int n){

 LEAVE
 ret
ENDP

printinteger: PROC
;-297     int e;

;-298     if(n<0) {  prc('-');  n=mkneg(n); }

;Function : printinteger, Number local Var: 2
; # type sign width local variables
;95 var sign word n = bp+4
;96 var sign word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 0
 jge .printinteger50
 push 45
 call prc
 add  sp, 2
 push word [bp+4]
 call mkneg
 add  sp, 2
 mov [bp+4], ax
;-299     if (n >= 10) {

.printinteger50:
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 1
 jl  .printinteger51
;-300         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 cwd
 idiv bx
 mov [bp-2], ax
;-301         printinteger(e);

 push word [bp-2]
 call printinteger
 add  sp, 2
;-302     }

;-303     n=n%10;

.printinteger51:
 mov ax, [bp+4]
 mov bx, 10
 cwd
 idiv bx
 mov ax, dx
 mov [bp+4], ax
;-304     n += '0';

 add  word[bp+4], 48
;-305     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2
;-306 }

;-307 

;-308 int printunsigned(unsigned int n) {

 LEAVE
 ret
ENDP

printunsigned: PROC
;-309     unsigned int e;

;-310     if (n >= 10) {

;Function : printunsigned, Number local Var: 2
; # type sign width local variables
;95 var unsg word n = bp+4
;96 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsigned52
;-311         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-312         printunsigned(e);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-313     }

;-314     n = n % 10; /*unsigned mod*/

.printunsigned52:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-315     n += '0';

 add  word[bp+4], 48
;-316     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2
;-317 }

;-318 

;-319 int end1(int n) {

 LEAVE
 ret
ENDP

end1: PROC
;-320     fcloseR(fdin);

;Function : end1, Number local Var: 1
; # type sign width local variables
;95 var sign word n = bp+4;
 ENTER  0,0
 push word [fdin]
 call fcloseR
 add  sp, 2
;-321     fcloseR(fdout);

 push word [fdout]
 call fcloseR
 add  sp, 2
;-322     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2
;-323 }

;-324 

;-325 int error1(char *s) {

 LEAVE
 ret
ENDP

error1: PROC
;-326     isPrint=1;

;Function : error1, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte s = bp+4;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al
;-327     lineno--;

 dec  word[lineno]
;-328     printstring("\n ");

 push error1_0
 call printstring
 add  sp, 2
;-329     prscomment(&fgetsdest);

 lea  ax, [fgetsdest]
 push ax
 call prscomment
 add  sp, 2
;-330     printstring(";Line: ");

 push error1_1
 call printstring
 add  sp, 2
;-331     printunsigned(lineno);

 push word [lineno]
 call printunsigned
 add  sp, 2
;-332     printstring(" ************** ERROR: ");

 push error1_2
 call printstring
 add  sp, 2
;-333     printstring(s);

 push word [bp+4]
 call printstring
 add  sp, 2
;-334     printstring("  in column: ");

 push error1_3
 call printstring
 add  sp, 2
;-335     printunsigned(column);

 push word [column]
 call printunsigned
 add  sp, 2
;-336     printstring("\nToken: ");

 push error1_4
 call printstring
 add  sp, 2
;-337     printunsigned(token);

 push word [token]
 call printunsigned
 add  sp, 2
;-338     printstring(", Symbol: ");

 push error1_5
 call printstring
 add  sp, 2
;-339     printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-340     end1(1);

 push 1
 call end1
 add  sp, 2
;-341 }

;-342 

;-343 int printinputline() {

 LEAVE
 ret
error1_0 db "\n ",0
error1_1 db ";Line: ",0
error1_2 db " ************** ERROR: ",0
error1_3 db "  in column: ",0
error1_4 db "\nToken: ",0
error1_5 db ", Symbol: ",0
ENDP

printinputline: PROC
;-344     int col;

;-345     col=0;

;Function : printinputline, Number local Var: 1
; # type sign width local variables
;95 var sign word col = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-346     fgetsp=&fgetsdest;

 mov ax, fgetsdest
 mov word [fgetsp], ax
;-347     do {

.printinputline53:
;-348         DOS_NoBytes=readRL(&DOS_ByteRead, fdin, 1);

 push 1
 push word [fdin]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-349         if (DOS_NoBytes == 0) return;

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .printinputline54
 jmp .retnprintinputline
;-350         *fgetsp=DOS_ByteRead;

.printinputline54:
 mov al, [DOS_ByteRead]
 mov  bx, [fgetsp]
 mov  [bx], al
;-351         fgetsp++;

 inc  word[fgetsp]
;-352         col++;

 inc  word[bp-2]
;-353         if (col >100) error1("input line longer than 100 char");

 mov ax, [bp-2]
 cmp ax, 100
 jle .printinputline55
 push printinputline_0
 call error1
 add  sp, 2
;-354         }

.printinputline55:
;-355         while (DOS_ByteRead != 10);

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .printinputline56
 jmp .printinputline53
.printinputline56:
;-356     *fgetsp=0;

 mov ax, 0
 mov  bx, [fgetsp]
 mov  [bx], al
;-357         printstring("\n;-");

 push printinputline_1
 call printstring
 add  sp, 2
;-358         printunsigned(lineno);

 push word [lineno]
 call printunsigned
 add  sp, 2
;-359         prc(' ');

 push 32
 call prc
 add  sp, 2
;-360         lineno++;

 inc  word[lineno]
;-361         prscomment(&fgetsdest);

 lea  ax, [fgetsdest]
 push ax
 call prscomment
 add  sp, 2
;-362 }

;-363 

;-364 int fgets1() {

 .retnprintinputline:
 LEAVE
 ret
printinputline_0 db "input line longer than 100 char",0
printinputline_1 db "\n;-",0
ENDP

fgets1: PROC
;-365     char c;

;-366     c=*fgetsp;

;Function : fgets1, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp-2;
 ENTER  2,0
 mov bx, [fgetsp]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-367     if (c==0) {

 mov al, [bp-2]
 cmp al, 0
 jne .fgets157
;-368         printinputline();

 call printinputline
;-369         if (DOS_NoBytes == 0) return 0;

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .fgets158
 mov ax, 0
 jmp .retnfgets1
;-370         fgetsp=&fgetsdest;

.fgets158:
 mov ax, fgetsdest
 mov word [fgetsp], ax
;-371         c=*fgetsp;

 mov bx, [fgetsp]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-372         column=0;

 mov ax, 0
 mov word [column], ax
;-373     }

;-374     fgetsp++;

.fgets157:
 inc  word[fgetsp]
;-375     column++;

 inc  word[column]
;-376     return c;

 mov al, [bp-2]
 jmp .retnfgets1
;-377 }

;-378 

;-379 int next() {

 .retnfgets1:
 LEAVE
 ret
ENDP

next: PROC
;-380     char r;

;-381     r = thechar;

;Function : next, Number local Var: 1
; # type sign width local variables
;95 var sign byte r = bp-2;
 ENTER  2,0
 mov al, [thechar]
 mov [bp-2], al
;-382     thechar = fgets1();

 call fgets1
 mov byte [thechar], al
;-383     return r;

 mov al, [bp-2]
 jmp .retnnext
;-384 }

;-385 

;-386 int storeVarName() {

 .retnnext:
 LEAVE
 ret
ENDP

storeVarName: PROC
;-387     unsigned int i;

;-388     VarNamePtr=strcpy(VarNamePtr, Symbol);

;Function : storeVarName, Number local Var: 1
; # type sign width local variables
;95 var unsg word i = bp-2;
 ENTER  2,0
 lea  ax, [Symbol]
 push ax
 push word [VarNamePtr]
 call strcpy
 add  sp, 4
 mov word [VarNamePtr], ax
;-389     VarNamePtr++;

 inc  word[VarNamePtr]
;-390     i = VarNamePtr - &VarNames;

 mov ax, [VarNamePtr]
 sub ax, VarNames
 mov [bp-2], ax
;-391     i += IDLENMAX;

 add  word[bp-2], 31
;-392     if (i > VARNAMESMAX) error1("too many variable names");

 mov ax, [bp-2]
 cmp ax, 4000
 jle .storeVarName59
 push storeVarName_0
 call error1
 add  sp, 2
;-393 }

.storeVarName59:
;-394 /*

;-395 int searchVarName() {

;-396 	char *p; int i;

;-397 	p = &VarNames;

;-398 	i=1;//start with 1

;-399 	while (i < VARMAX) {

;-400 		if (eqstr(p, Symbol)) return i;

;-401 		p=strlen(p) + p;

;-402 		p++;

;-403 		i++;

;-404 	}

;-405 	return 0;		

;-406 }

;-407 */	

;-408 int getVarName(unsigned int i) {

 LEAVE
 ret
storeVarName_0 db "too many variable names",0
ENDP

getVarName: PROC
;-409 	int j; char *p;

;-410 	j = 1;

;Function : getVarName, Number local Var: 3
; # type sign width local variables
;95 var unsg word i = bp+4
;96 var sign word j = bp-2
;97 ptr sign byte p = bp-4;
 ENTER  4,0
 mov ax, 1
 mov [bp-2], ax
;-411 	p = &VarNames;

 mov ax, VarNames
 mov [bp-4], ax
;-412 	while (j < i) {

.getVarName60:
 mov ax, [bp-2]
 cmp ax, [bp+4]
 jge .getVarName61
;-413 		while (*p) p++;

.getVarName62:
 mov bx, [bp-4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .getVarName63
 inc  word[bp-4]
;-414 		p++;

 jmp .getVarName62
.getVarName63:
 inc  word[bp-4]
;-415 		j++;	 		

 inc  word[bp-2]
;-416 	}

;-417 	return p;	

 jmp .getVarName60
.getVarName61:
 mov ax, [bp-4]
 jmp .retngetVarName
;-418 		

;-419 }

;-420 		

;-421 int printName(unsigned int i) {

 .retngetVarName:
 LEAVE
 ret
ENDP

printName: PROC
;-422     if (i < GTop) {

;Function : printName, Number local Var: 1
; # type sign width local variables
;95 var unsg word i = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, [GTop]
 jge .printName64
;-423 	    i=getVarName(i);	    

 push word [bp+4]
 call getVarName
 add  sp, 2
 mov [bp+4], ax
;-424         printstring(i);

 push word [bp+4]
 call printstring
 add  sp, 2
;-425     }

;-426     else {

 jmp .printName65
.printName64:
;-427         printstring("[bp");

 push printName_0
 call printstring
 add  sp, 2
;-428         i = GData[i];

 mov bx, [bp+4]
 shl bx, 1
 mov ax, [GData + bx]
 mov [bp+4], ax
;-429         if (i>0) prc('+');

 mov ax, [bp+4]
 cmp ax, 0
 jle .printName66
 push 43
 call prc
 add  sp, 2
;-430         printinteger(i);

.printName66:
 push word [bp+4]
 call printinteger
 add  sp, 2
;-431         prc(']');

 push 93
 call prc
 add  sp, 2
;-432     }

;-433 }

.printName65:
;-434 

;-435 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 LEAVE
 ret
printName_0 db "[bp",0
ENDP

ifEOL: PROC
;-436     if (c == 10) return 1;//LF

;Function : ifEOL, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL67
 mov ax, 1
 jmp .retnifEOL
;-437     if (c == 13) {//CR

.ifEOL67:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL68
;-438         if (thechar == 10) c=next();

 mov al, [thechar]
 cmp al, 10
 jne .ifEOL69
 call next
 mov [bp+4], al
;-439         return 1;

.ifEOL69:
 mov ax, 1
 jmp .retnifEOL
;-440     }

;-441     return 0;

.ifEOL68:
 mov ax, 0
 jmp .retnifEOL
;-442 }

;-443 

;-444 char symboltemp[80];

 .retnifEOL:
 LEAVE
 ret
ENDP
section .bss
absolute 32457
symboltemp resb 80
section .text
;-445 

;-446 int getlex() {


getlex: PROC
;-447     char c; char *p;

;-448     int i; int j;

;-449 g1: c=next();

;Function : getlex, Number local Var: 4
; # type sign width local variables
;96 var sign byte c = bp-2
;97 ptr sign byte p = bp-4
;98 var sign word i = bp-6
;99 var sign word j = bp-8;
 ENTER  8,0
.g1:
 call next
 mov [bp-2], al
;-450     if (c == 0) return 0;

 mov al, [bp-2]
 cmp al, 0
 jne .getlex70
 mov ax, 0
 jmp .retngetlex
;-451     if (c <= ' ') goto g1;

.getlex70:
 mov al, [bp-2]
 cmp al, 32
 jg  .getlex71
 jmp .g1
;-452   if (c=='=') {if(thechar=='=') {next(); return T_EQ; }}

.getlex71:
 mov al, [bp-2]
 cmp al, 61
 jne .getlex72
 mov al, [thechar]
 cmp al, 61
 jne .getlex73
 call next
 mov ax, 806
 jmp .retngetlex
.getlex73:
;-453   if (c=='!') {if(thechar=='=') {next(); return T_NE; }}

.getlex72:
 mov al, [bp-2]
 cmp al, 33
 jne .getlex74
 mov al, [thechar]
 cmp al, 61
 jne .getlex75
 call next
 mov ax, 807
 jmp .retngetlex
.getlex75:
;-454   if (c=='<') {if(thechar=='=') {next(); return T_LE; }}

.getlex74:
 mov al, [bp-2]
 cmp al, 60
 jne .getlex76
 mov al, [thechar]
 cmp al, 61
 jne .getlex77
 call next
 mov ax, 824
 jmp .retngetlex
.getlex77:
;-455   if (c=='>') {if(thechar=='=') {next(); return T_GE; }}

.getlex76:
 mov al, [bp-2]
 cmp al, 62
 jne .getlex78
 mov al, [thechar]
 cmp al, 61
 jne .getlex79
 call next
 mov ax, 811
 jmp .retngetlex
.getlex79:
;-456   if (c=='<') {if(thechar=='<') {next(); return T_LESSLESS;  }}

.getlex78:
 mov al, [bp-2]
 cmp al, 60
 jne .getlex80
 mov al, [thechar]
 cmp al, 60
 jne .getlex81
 call next
 mov ax, 1240
 jmp .retngetlex
.getlex81:
;-457   if (c=='>') {if(thechar=='>') {next(); return T_GREATGREAT;}}

.getlex80:
 mov al, [bp-2]
 cmp al, 62
 jne .getlex82
 mov al, [thechar]
 cmp al, 62
 jne .getlex83
 call next
 mov ax, 1241
 jmp .retngetlex
.getlex83:
;-458   if (c=='+') {if(thechar=='+') {next(); return T_PLUSPLUS;  }}

.getlex82:
 mov al, [bp-2]
 cmp al, 43
 jne .getlex84
 mov al, [thechar]
 cmp al, 43
 jne .getlex85
 call next
 mov ax, 1219
 jmp .retngetlex
.getlex85:
;-459   if (c=='-') {if(thechar=='-') {next(); return T_MINUSMINUS;}}

.getlex84:
 mov al, [bp-2]
 cmp al, 45
 jne .getlex86
 mov al, [thechar]
 cmp al, 45
 jne .getlex87
 call next
 mov ax, 1225
 jmp .retngetlex
.getlex87:
;-460   if (c=='+') {if(thechar=='=') {next(); return T_PLUSASS;   }}

.getlex86:
 mov al, [bp-2]
 cmp al, 43
 jne .getlex88
 mov al, [thechar]
 cmp al, 61
 jne .getlex89
 call next
 mov ax, 1230
 jmp .retngetlex
.getlex89:
;-461   if (c=='-') {if(thechar=='=') {next(); return T_MINUSASS;  }}

.getlex88:
 mov al, [bp-2]
 cmp al, 45
 jne .getlex90
 mov al, [thechar]
 cmp al, 61
 jne .getlex91
 call next
 mov ax, 1231
 jmp .retngetlex
.getlex91:
;-462   if (c=='&') {if(thechar=='=') {next(); return T_ANDASS;    }}

.getlex90:
 mov al, [bp-2]
 cmp al, 38
 jne .getlex92
 mov al, [thechar]
 cmp al, 61
 jne .getlex93
 call next
 mov ax, 1234
 jmp .retngetlex
.getlex93:
;-463   if (c=='|') {if(thechar=='=') {next(); return T_ORASS;     }}

.getlex92:
 mov al, [bp-2]
 cmp al, 124
 jne .getlex94
 mov al, [thechar]
 cmp al, 61
 jne .getlex95
 call next
 mov ax, 1235
 jmp .retngetlex
.getlex95:
;-464   if (c=='*') {if(thechar=='=') {next(); return T_MULASS;    }}

.getlex94:
 mov al, [bp-2]
 cmp al, 42
 jne .getlex96
 mov al, [thechar]
 cmp al, 61
 jne .getlex97
 call next
 mov ax, 1232
 jmp .retngetlex
.getlex97:
;-465   if (c=='/') {if(thechar=='=') {next(); return T_DIVASS;    }}

.getlex96:
 mov al, [bp-2]
 cmp al, 47
 jne .getlex98
 mov al, [thechar]
 cmp al, 61
 jne .getlex99
 call next
 mov ax, 1233
 jmp .retngetlex
.getlex99:
;-466   if (instr1("()[]{},;*:%-><=+!&|#?", c)) return c ;

.getlex98:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 push getlex_0
 call instr1
 add  sp, 4
 or  al, al
 je .getlex100
 mov al, [bp-2]
 jmp .retngetlex
;-467   if (c == '/') {

.getlex100:
 mov al, [bp-2]
 cmp al, 47
 jne .getlex101
;-468       if (thechar == '/') {

 mov al, [thechar]
 cmp al, 47
 jne .getlex102
;-469           do c=next();

.getlex103:
 call next
 mov [bp-2], al
;-470           while(ifEOL(c)==0) return getlex();

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getlex104
 jmp .getlex103
.getlex104:
 call getlex
 jmp .retngetlex
;-471       }

;-472   }

.getlex102:
;-473   if (c == '/') {

.getlex101:
 mov al, [bp-2]
 cmp al, 47
 jne .getlex105
;-474       if (thechar == '*') {

 mov al, [thechar]
 cmp al, 42
 jne .getlex106
;-475           g2: c=next();

.g2:
 call next
 mov [bp-2], al
;-476           if (c != '*') goto g2;

 mov al, [bp-2]
 cmp al, 42
 je  .getlex107
 jmp .g2
;-477           if (thechar != '/') goto g2;

.getlex107:
 mov al, [thechar]
 cmp al, 47
 je  .getlex108
 jmp .g2
;-478           c=next();

.getlex108:
 call next
 mov [bp-2], al
;-479           return getlex();

 call getlex
 jmp .retngetlex
;-480       } else  return '/';

 jmp .getlex109
.getlex106:
 mov ax, 47
 jmp .retngetlex
;-481   }

.getlex109:
;-482   if (c == '"') {

.getlex105:
 mov al, [bp-2]
 cmp al, 34
 jne .getlex110
;-483       p=&Symbol;

 mov ax, Symbol
 mov [bp-4], ax
;-484       c=next();

 call next
 mov [bp-2], al
;-485       while (c != '"') {

.getlex111:
 mov al, [bp-2]
 cmp al, 34
 je  .getlex112
;-486           *p=c;

 mov al, [bp-2]
 mov  bx, [bp-4]
 mov  [bx], al
;-487           p++;

 inc  word[bp-4]
;-488           c=next();

 call next
 mov [bp-2], al
;-489           }

;-490           *p=0;

 jmp .getlex111
.getlex112:
 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], al
;-491       return T_STRING;

 mov ax, 258
 jmp .retngetlex
;-492   }

;-493   if (digit(c)) {

.getlex110:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getlex113
;-494       lexval=0;

 mov ax, 0
 mov word [lexval], ax
;-495       lexval=c-'0'; // lexval=int hi=0, c=char

 mov al, [bp-2]
 sub al, 48
 mov word [lexval], ax
;-496       if (thechar=='x') thechar='X';

 mov al, [thechar]
 cmp al, 120
 jne .getlex114
 mov ax, 88
 mov byte [thechar], al
;-497       if (thechar=='X') {

.getlex114:
 mov al, [thechar]
 cmp al, 88
 jne .getlex115
;-498           next();

 call next
;-499           while(alnum(thechar)) {

.getlex116:
 mov al, byte [thechar]
 mov ah, 0
 push ax
 call alnum
 add  sp, 2
 or  al, al
 je .getlex117
;-500               c=next();

 call next
 mov [bp-2], al
;-501               if(c>96) c=c-39;

 mov al, [bp-2]
 cmp al, 96
 jle .getlex118
 mov al, [bp-2]
 sub al, 39
 mov [bp-2], al
;-502       	       if (c>64) c=c-7;

.getlex118:
 mov al, [bp-2]
 cmp al, 64
 jle .getlex119
 mov al, [bp-2]
 sub al, 7
 mov [bp-2], al
;-503                c=c-48;

.getlex119:
 mov al, [bp-2]
 sub al, 48
 mov [bp-2], al
;-504                lexval=lexval << 4; // * 16

 mov ax, [lexval]
 shl ax, 4
 mov word [lexval], ax
;-505                i=0;

 mov ax, 0
 mov [bp-6], ax
;-506                i=c;

 mov al, [bp-2]
 mov [bp-6], ax
;-507                lexval=lexval+i;

 mov ax, [lexval]
 add ax, [bp-6]
 mov word [lexval], ax
;-508            }

;-509        }else {

 jmp .getlex116
.getlex117:
 jmp .getlex120
.getlex115:
;-510            while(digit(thechar)) {

.getlex121:
 mov al, byte [thechar]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getlex122
;-511                c=next();

 call next
 mov [bp-2], al
;-512                c=c-48;

 mov al, [bp-2]
 sub al, 48
 mov [bp-2], al
;-513                lexval=lexval*10;

 mov ax, [lexval]
 mov bx, 10
 mul bx
 mov word [lexval], ax
;-514                i=0;

 mov ax, 0
 mov [bp-6], ax
;-515                i=c;

 mov al, [bp-2]
 mov [bp-6], ax
;-516                lexval=lexval+i;

 mov ax, [lexval]
 add ax, [bp-6]
 mov word [lexval], ax
;-517            }

;-518        }

 jmp .getlex121
.getlex122:
;-519       return T_CONST;

.getlex120:
 mov ax, 257
 jmp .retngetlex
;-520   }

;-521   if (c==39) {

.getlex113:
 mov al, [bp-2]
 cmp al, 39
 jne .getlex123
;-522       lexval=next();

 call next
 mov word [lexval], ax
;-523       if (lexval==92) {

 mov ax, [lexval]
 cmp ax, 92
 jne .getlex124
;-524           lexval=next();

 call next
 mov word [lexval], ax
;-525           if (lexval=='n') lexval=10;

 mov ax, [lexval]
 cmp ax, 110
 jne .getlex125
 mov ax, 10
 mov word [lexval], ax
;-526           if (lexval=='t') lexval= 9;

.getlex125:
 mov ax, [lexval]
 cmp ax, 116
 jne .getlex126
 mov ax, 9
 mov word [lexval], ax
;-527           if (lexval=='0') lexval= 0;

.getlex126:
 mov ax, [lexval]
 cmp ax, 48
 jne .getlex127
 mov ax, 0
 mov word [lexval], ax
;-528       }

.getlex127:
;-529       next();

.getlex124:
 call next
;-530       return T_CONST;

 mov ax, 257
 jmp .retngetlex
;-531   }

;-532   if (alnum(c)) {

.getlex123:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call alnum
 add  sp, 2
 or  al, al
 je .getlex128
;-533     strcpy(symboltemp, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [symboltemp]
 push ax
 call strcpy
 add  sp, 4
;-534     p=&Symbol;

 mov ax, Symbol
 mov [bp-4], ax
;-535     *p=c;

 mov al, [bp-2]
 mov  bx, [bp-4]
 mov  [bx], al
;-536     p++;

 inc  word[bp-4]
;-537     while(alnum(thechar)) {

.getlex129:
 mov al, byte [thechar]
 mov ah, 0
 push ax
 call alnum
 add  sp, 2
 or  al, al
 je .getlex130
;-538         c=next();

 call next
 mov [bp-2], al
;-539         *p=c;

 mov al, [bp-2]
 mov  bx, [bp-4]
 mov  [bx], al
;-540         p++;

 inc  word[bp-4]
;-541     }

;-542     *p=0;

 jmp .getlex129
.getlex130:
 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], al
;-543     if (eqstr(Symbol,"signed"  )) return T_SIGNED;

 push getlex_1
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex131
 mov ax, 531
 jmp .retngetlex
;-544     if (eqstr(Symbol,"unsigned")) return T_UNSIGNED;

.getlex131:
 push getlex_2
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex132
 mov ax, 532
 jmp .retngetlex
;-545     if (eqstr(Symbol,"void"    )) return T_VOID;

.getlex132:
 push getlex_3
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex133
 mov ax, 529
 jmp .retngetlex
;-546     if (eqstr(Symbol,"int"     )) return T_INT;

.getlex133:
 push getlex_4
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex134
 mov ax, 517
 jmp .retngetlex
;-547     if (eqstr(Symbol,"long"    )) return T_LONG;

.getlex134:
 push getlex_5
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex135
 mov ax, 533
 jmp .retngetlex
;-548     if (eqstr(Symbol,"inth"    )) return T_INTH;

.getlex135:
 push getlex_6
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex136
 mov ax, 600
 jmp .retngetlex
;-549     if (eqstr(Symbol,"char"    )) return T_CHAR;

.getlex136:
 push getlex_7
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex137
 mov ax, 530
 jmp .retngetlex
;-550     if (eqstr(Symbol,"asm"     )) return T_ASM;

.getlex137:
 push getlex_8
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex138
 mov ax, 518
 jmp .retngetlex
;-551     if (eqstr(Symbol,"__asm"   )) return T_ASMBLOCK;

.getlex138:
 push getlex_9
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex139
 mov ax, 519
 jmp .retngetlex
;-552     if (eqstr(Symbol,"push"    )) return T_ASMDIRECT;

.getlex139:
 push getlex_10
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex140
 mov ax, 525
 jmp .retngetlex
;-553     if (eqstr(Symbol,"pop"     )) return T_ASMDIRECT;

.getlex140:
 push getlex_11
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex141
 mov ax, 525
 jmp .retngetlex
;-554     if (eqstr(Symbol,"iret"    )) return T_ASMDIRECT;

.getlex141:
 push getlex_12
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex142
 mov ax, 525
 jmp .retngetlex
;-555     if (eqstr(Symbol,"ret"     )) return T_ASMDIRECT;

.getlex142:
 push getlex_13
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex143
 mov ax, 525
 jmp .retngetlex
;-556     if (eqstr(Symbol,"cli"     )) return T_ASMDIRECT;

.getlex143:
 push getlex_14
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex144
 mov ax, 525
 jmp .retngetlex
;-557     if (eqstr(Symbol,"sti"     )) return T_ASMDIRECT;

.getlex144:
 push getlex_15
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex145
 mov ax, 525
 jmp .retngetlex
;-558     if (eqstr(Symbol,"__emit__")) return T_EMIT;

.getlex145:
 push getlex_16
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex146
 mov ax, 520
 jmp .retngetlex
;-559     if (eqstr(Symbol,"return"  )) return T_RETURN;

.getlex146:
 push getlex_17
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex147
 mov ax, 512
 jmp .retngetlex
;-560     if (eqstr(Symbol,"if"      )) return T_IF;

.getlex147:
 push getlex_18
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex148
 mov ax, 513
 jmp .retngetlex
;-561     if (eqstr(Symbol,"else"    )) return T_ELSE;

.getlex148:
 push getlex_19
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex149
 mov ax, 514
 jmp .retngetlex
;-562     if (eqstr(Symbol,"while"   )) return T_WHILE;

.getlex149:
 push getlex_20
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex150
 mov ax, 515
 jmp .retngetlex
;-563     if (eqstr(Symbol,"do"      )) return T_DO;

.getlex150:
 push getlex_21
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex151
 mov ax, 516
 jmp .retngetlex
;-564     if (eqstr(Symbol,"goto"    )) return T_GOTO;

.getlex151:
 push getlex_22
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex152
 mov ax, 521
 jmp .retngetlex
;-565     if (eqstr(Symbol,"define"  )) return T_DEFINE;

.getlex152:
 push getlex_23
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex153
 mov ax, 511
 jmp .retngetlex
;-566 

;-567     i=0;//convert define to value

.getlex153:
 mov ax, 0
 mov [bp-6], ax
;-568     while (i < GTop) {

.getlex154:
 mov ax, [bp-6]
 cmp ax, [GTop]
 jge .getlex155
;-569         j=getVarName(i);

 push word [bp-6]
 call getVarName
 add  sp, 2
 mov [bp-8], ax
;-570         if (eqstr(Symbol,j)) {

 push word [bp-8]
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getlex156
;-571             if (GType[i]=='#') {

 mov bx, [bp-6]
 mov al, [GType + bx]
 cmp al, 35
 jne .getlex157
;-572                 lexval=GData[i];

 mov bx, [bp-6]
 shl bx, 1
 mov ax, [GData + bx]
 mov word [lexval], ax
;-573                 strcpy(Symbol, symboltemp);

 lea  ax, [symboltemp]
 push ax
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-574                 return T_CONST;

 mov ax, 257
 jmp .retngetlex
;-575             }

;-576         }

.getlex157:
;-577         i++;

.getlex156:
 inc  word[bp-6]
;-578     }

;-579     return T_NAME; } 

 jmp .getlex154
.getlex155:
 mov ax, 256
 jmp .retngetlex
;-580     error1("Input item not recognized");

.getlex128:
 push getlex_24
 call error1
 add  sp, 2
;-581 }

;-582 

;-583 int istoken(int t) {

 .retngetlex:
 LEAVE
 ret
getlex_0 db "()[]{},;*:%-><=+!&|#?",0
getlex_1 db "signed",0
getlex_2 db "unsigned",0
getlex_3 db "void",0
getlex_4 db "int",0
getlex_5 db "long",0
getlex_6 db "inth",0
getlex_7 db "char",0
getlex_8 db "asm",0
getlex_9 db "__asm",0
getlex_10 db "push",0
getlex_11 db "pop",0
getlex_12 db "iret",0
getlex_13 db "ret",0
getlex_14 db "cli",0
getlex_15 db "sti",0
getlex_16 db "__emit__",0
getlex_17 db "return",0
getlex_18 db "if",0
getlex_19 db "else",0
getlex_20 db "while",0
getlex_21 db "do",0
getlex_22 db "goto",0
getlex_23 db "define",0
getlex_24 db "Input item not recognized",0
ENDP

istoken: PROC
;-584     if (token == t) {

;Function : istoken, Number local Var: 1
; # type sign width local variables
;96 var sign word t = bp+4;
 ENTER  0,0
 mov ax, [token]
 cmp ax, [bp+4]
 jne .istoken158
;-585         token=getlex();

 call getlex
 mov word [token], ax
;-586         return 1;

 mov ax, 1
 jmp .retnistoken
;-587     }

;-588     return 0;

.istoken158:
 mov ax, 0
 jmp .retnistoken
;-589 }

;-590 

;-591 int expect(int t) {

 .retnistoken:
 LEAVE
 ret
ENDP

expect: PROC
;-592     if (istoken(t)==0) {

;Function : expect, Number local Var: 1
; # type sign width local variables
;96 var sign word t = bp+4;
 ENTER  0,0
 push word [bp+4]
 call istoken
 add  sp, 2
 cmp ax, 0
 jne .expect159
;-593         *cloc=0;

 mov ax, 0
 mov  bx, [cloc]
 mov  [bx], al
;-594         printstring(co);

 lea  ax, [co]
 push ax
 call printstring
 add  sp, 2
;-595         printstring("\nExpected ASCII(dez): ");

 push expect_0
 call printstring
 add  sp, 2
;-596         printinteger(t);

 push word [bp+4]
 call printinteger
 add  sp, 2
;-597         error1(" not found");

 push expect_1
 call error1
 add  sp, 2
;-598     }

;-599 }

.expect159:
;-600 

;-601 int v(unsigned int i) {//value

 LEAVE
 ret
expect_0 db "\nExpected ASCII(dez): ",0
expect_1 db " not found",0
ENDP

v: PROC
;-602     if (i < GTop) prc('[');

;Function : v, Number local Var: 1
; # type sign width local variables
;96 var unsg word i = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, [GTop]
 jge .v160
 push 91
 call prc
 add  sp, 2
;-603     printName(i);

.v160:
 push word [bp+4]
 call printName
 add  sp, 2
;-604     if (i < GTop) prc(']');

 mov ax, [bp+4]
 cmp ax, [GTop]
 jge .v161
 push 93
 call prc
 add  sp, 2
;-605 }

.v161:
;-606 int checknamelen() {

 LEAVE
 ret
ENDP

checknamelen: PROC
;-607     int i;

;-608     i=strlen(Symbol);

;Function : checknamelen, Number local Var: 1
; # type sign width local variables
;96 var sign word i = bp-2;
 ENTER  2,0
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-609     if (i > IDLENMAX) error1("Item name is too long)");

 mov ax, [bp-2]
 cmp ax, 31
 jle .checknamelen162
 push checknamelen_0
 call error1
 add  sp, 2
;-610 }

.checknamelen162:
;-611 

;-612 int checkName() {

 LEAVE
 ret
checknamelen_0 db "Item name is too long)",0
ENDP

checkName: PROC
;-613     unsigned int i; unsigned int j;

;-614     i=GTop;

;Function : checkName, Number local Var: 2
; # type sign width local variables
;96 var unsg word i = bp-2
;97 var unsg word j = bp-4;
 ENTER  4,0
 mov ax, [GTop]
 mov [bp-2], ax
;-615     while(i<LTop) {//todo look for local var first

.checkName163:
 mov ax, [bp-2]
 cmp ax, [LTop]
 jge .checkName164
;-616         j=getVarName(i);

 push word [bp-2]
 call getVarName
 add  sp, 2
 mov [bp-4], ax
;-617         if(eqstr(Symbol,j))return i;

 push word [bp-4]
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkName165
 mov ax, [bp-2]
 jmp .retncheckName
;-618         i++;

.checkName165:
 inc  word[bp-2]
;-619     }

;-620     i=1;

 jmp .checkName163
.checkName164:
 mov ax, 1
 mov [bp-2], ax
;-621     while(i<GTop) {

.checkName166:
 mov ax, [bp-2]
 cmp ax, [GTop]
 jge .checkName167
;-622         j=getVarName(i);

 push word [bp-2]
 call getVarName
 add  sp, 2
 mov [bp-4], ax
;-623         if(eqstr(Symbol,j))return i;

 push word [bp-4]
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkName168
 mov ax, [bp-2]
 jmp .retncheckName
;-624         i++;

.checkName168:
 inc  word[bp-2]
;-625     }

;-626     return 0;

 jmp .checkName166
.checkName167:
 mov ax, 0
 jmp .retncheckName
;-627 }

;-628 

;-629 int searchname() {

 .retncheckName:
 LEAVE
 ret
ENDP

searchname: PROC
;-630     unsigned int i;

;-631     i=checkName();

;Function : searchname, Number local Var: 1
; # type sign width local variables
;96 var unsg word i = bp-2;
 ENTER  2,0
 call checkName
 mov [bp-2], ax
;-632     if (i == 0) error1("Variable unknown");

 mov ax, [bp-2]
 cmp ax, 0
 jne .searchname169
 push searchname_0
 call error1
 add  sp, 2
;-633     return i;

.searchname169:
 mov ax, [bp-2]
 jmp .retnsearchname
;-634 }

;-635 

;-636 int name1() {

 .retnsearchname:
 LEAVE
 ret
searchname_0 db "Variable unknown",0
ENDP

name1: PROC
;-637     if (token!=T_NAME) error1("Name expected");

 mov ax, [token]
 cmp ax, 256
 je  .name1170
 push name1_0
 call error1
 add  sp, 2
;-638     token=getlex();

.name1170:
 call getlex
 mov word [token], ax
;-639 }

;-640 

;-641 int typeName() {

 ret
name1_0 db "Name expected",0
ENDP

typeName: PROC
;-642     int m; //0=V,1=*,2=&

;-643     issign='S';

;Function : typeName, Number local Var: 1
; # type sign width local variables
;96 var sign word m = bp-2;
 ENTER  2,0
 mov ax, 83
 mov byte [issign], al
;-644     if(istoken(T_SIGNED))   issign='S';

 push 531
 call istoken
 add  sp, 2
 or  al, al
 je .typeName171
 mov ax, 83
 mov byte [issign], al
;-645     if(istoken(T_UNSIGNED)) issign='U';

.typeName171:
 push 532
 call istoken
 add  sp, 2
 or  al, al
 je .typeName172
 mov ax, 85
 mov byte [issign], al
;-646     iswidth=2;

.typeName172:
 mov ax, 2
 mov byte [iswidth], al
;-647     if(istoken(T_VOID))     iswidth=0;

 push 529
 call istoken
 add  sp, 2
 or  al, al
 je .typeName173
 mov ax, 0
 mov byte [iswidth], al
;-648     if(istoken(T_CHAR))     iswidth=1;

.typeName173:
 push 530
 call istoken
 add  sp, 2
 or  al, al
 je .typeName174
 mov ax, 1
 mov byte [iswidth], al
;-649     if(istoken(T_INT))      iswidth=2;

.typeName174:
 push 517
 call istoken
 add  sp, 2
 or  al, al
 je .typeName175
 mov ax, 2
 mov byte [iswidth], al
;-650     if(istoken(T_LONG))     iswidth=4;

.typeName175:
 push 533
 call istoken
 add  sp, 2
 or  al, al
 je .typeName176
 mov ax, 4
 mov byte [iswidth], al
;-651     istype='V';

.typeName176:
 mov ax, 86
 mov byte [istype], al
;-652     m=0;

 mov ax, 0
 mov [bp-2], ax
;-653     if(istoken('*'))  {istype='*'; m=1;}

 push 42
 call istoken
 add  sp, 2
 or  al, al
 je .typeName177
 mov ax, 42
 mov byte [istype], al
 mov ax, 1
 mov [bp-2], ax
;-654     if(istoken('&'))  {istype='&'; m=2;}

.typeName177:
 push 38
 call istoken
 add  sp, 2
 or  al, al
 je .typeName178
 mov ax, 38
 mov byte [istype], al
 mov ax, 2
 mov [bp-2], ax
;-655     name1();

.typeName178:
 call name1
;-656     return m;

 mov ax, [bp-2]
 jmp .retntypeName
;-657 }

;-658 

;-659 int gettypes(int i) {

 .retntypeName:
 LEAVE
 ret
ENDP

gettypes: PROC
;-660     char c;

;-661     c=GSign [i];

;Function : gettypes, Number local Var: 2
; # type sign width local variables
;96 var sign word i = bp+4
;97 var sign byte c = bp-2;
 ENTER  2,0
 mov bx, [bp+4]
 mov al, [GSign + bx]
 mov [bp-2], al
;-662     if (c=='S') signi =1;  else signi =0;

 mov al, [bp-2]
 cmp al, 83
 jne .gettypes179
 mov ax, 1
 mov word [signi], ax
 jmp .gettypes180
.gettypes179:
 mov ax, 0
 mov word [signi], ax
;-663     c=GWidth[i];

.gettypes180:
 mov bx, [bp+4]
 mov al, [GWidth + bx]
 mov [bp-2], al
;-664     widthi=0;

 mov ax, 0
 mov word [widthi], ax
;-665     wi=0;

 mov ax, 0
 mov word [wi], ax
;-666     if (c==1) {widthi=1;wi=1;}

 mov al, [bp-2]
 cmp al, 1
 jne .gettypes181
 mov ax, 1
 mov word [widthi], ax
 mov ax, 1
 mov word [wi], ax
;-667     if (c==2) {widthi=2;wi=2;}

.gettypes181:
 mov al, [bp-2]
 cmp al, 2
 jne .gettypes182
 mov ax, 2
 mov word [widthi], ax
 mov ax, 2
 mov word [wi], ax
;-668     if (c==4) {widthi=4;wi=4;}

.gettypes182:
 mov al, [bp-2]
 cmp al, 4
 jne .gettypes183
 mov ax, 4
 mov word [widthi], ax
 mov ax, 4
 mov word [wi], ax
;-669     c=GType [i];

.gettypes183:
 mov bx, [bp+4]
 mov al, [GType + bx]
 mov [bp-2], al
;-670     typei=0;

 mov ax, 0
 mov word [typei], ax
;-671     if (c=='*') {typei=1;wi=2;}

 mov al, [bp-2]
 cmp al, 42
 jne .gettypes184
 mov ax, 1
 mov word [typei], ax
 mov ax, 2
 mov word [wi], ax
;-672     if (c=='&')  typei=2;

.gettypes184:
 mov al, [bp-2]
 cmp al, 38
 jne .gettypes185
 mov ax, 2
 mov word [typei], ax
;-673     return i;

.gettypes185:
 mov ax, [bp+4]
 jmp .retngettypes
;-674 }

;-675 

;-676 int addlocal() {

 .retngettypes:
 LEAVE
 ret
ENDP

addlocal: PROC
;-677     if(LTop >= VARMAX) error1("Local variable table full");

 mov ax, [LTop]
 cmp ax, 400 ;unsigned : 1
 jl  .addlocal186
 push addlocal_0
 call error1
 add  sp, 2
;-678     if (checkName() != 0) error1("Variable already defined");

.addlocal186:
 call checkName
 cmp ax, 0
 je  .addlocal187
 push addlocal_1
 call error1
 add  sp, 2
;-679     GSign[LTop]=issign;

.addlocal187:
 mov al, [issign]
 mov bx, [LTop]
 mov [GSign+bx], al
;-680     GWidth[LTop]=iswidth;

 mov al, [iswidth]
 mov bx, [LTop]
 mov [GWidth+bx], al
;-681     GType[LTop]=istype;

 mov al, [istype]
 mov bx, [LTop]
 mov [GType+bx], al
;-682     pt=getVarName(LTop);

 push word [LTop]
 call getVarName
 add  sp, 2
 mov word [pt], ax
;-683     strcpy(pt, Symbol);

 lea  ax, [Symbol]
 push ax
 push word [pt]
 call strcpy
 add  sp, 4
;-684     storeVarName();

 call storeVarName
;-685 }

;-686 

;-687 

;-688 int cmpneg(int ids) {

 ret
addlocal_0 db "Local variable table full",0
addlocal_1 db "Variable already defined",0
ENDP

cmpneg: PROC
;-689        if(iscmp==T_EQ) printstring("\n jne .");         //ZF=0

;Function : cmpneg, Number local Var: 1
; # type sign width local variables
;96 var sign word ids = bp+4;
 ENTER  0,0
 mov ax, [iscmp]
 cmp ax, 806
 jne .cmpneg188
 push cmpneg_0
 call printstring
 add  sp, 2
;-690   else if(iscmp==T_NE) printstring("\n je  .");         //ZF=1

 jmp .cmpneg189
.cmpneg188:
 mov ax, [iscmp]
 cmp ax, 807
 jne .cmpneg190
 push cmpneg_1
 call printstring
 add  sp, 2
;-691   else if(iscmp==T_LE) if (ids) printstring("\n jg  .");//ZF=0 SF=O

 jmp .cmpneg191
.cmpneg190:
 mov ax, [iscmp]
 cmp ax, 824
 jne .cmpneg192
 mov ax, [bp+4]
 or  al, al
 je .cmpneg193
 push cmpneg_2
 call printstring
 add  sp, 2
;-692                        else     printstring("\n ja  .");//ZF=0 CF=0

 jmp .cmpneg194
.cmpneg193:
 push cmpneg_3
 call printstring
 add  sp, 2
;-693   else if(iscmp==T_GE) if (ids){printstring(" ;unsigned : ");

.cmpneg194:
 jmp .cmpneg195
.cmpneg192:
 mov ax, [iscmp]
 cmp ax, 811
 jne .cmpneg196
 mov ax, [bp+4]
 or  al, al
 je .cmpneg197
 push cmpneg_4
 call printstring
 add  sp, 2
;-694                                 printunsigned(ids);

 push word [bp+4]
 call printunsigned
 add  sp, 2
;-695                                 printstring("\n jl  .");}//SF!=O

 push cmpneg_5
 call printstring
 add  sp, 2
;-696                        else    {printstring(" ;unsigned : ");

 jmp .cmpneg198
.cmpneg197:
 push cmpneg_6
 call printstring
 add  sp, 2
;-697                                 printunsigned(ids);

 push word [bp+4]
 call printunsigned
 add  sp, 2
;-698                                 printstring("\n jb  .");}//jb=jc=CF=1

 push cmpneg_7
 call printstring
 add  sp, 2
;-699   else if(iscmp=='<' ) printstring("\n jge .");          //SF=O

.cmpneg198:
 jmp .cmpneg199
.cmpneg196:
 mov ax, [iscmp]
 cmp ax, 60
 jne .cmpneg200
 push cmpneg_8
 call printstring
 add  sp, 2
;-700   else if(iscmp=='>' ) printstring("\n jle .");          //ZF=1 | SF!=O

 jmp .cmpneg201
.cmpneg200:
 mov ax, [iscmp]
 cmp ax, 62
 jne .cmpneg202
 push cmpneg_9
 call printstring
 add  sp, 2
;-701   else error1("internal error compare unknown in CMPNEG()");

 jmp .cmpneg203
.cmpneg202:
 push cmpneg_10
 call error1
 add  sp, 2
;-702 }

.cmpneg203:
.cmpneg201:
.cmpneg199:
.cmpneg195:
.cmpneg191:
.cmpneg189:
;-703 

;-704 int isrelational() {

 LEAVE
 ret
cmpneg_0 db "\n jne .",0
cmpneg_1 db "\n je  .",0
cmpneg_2 db "\n jg  .",0
cmpneg_3 db "\n ja  .",0
cmpneg_4 db " ;unsigned : ",0
cmpneg_5 db "\n jl  .",0
cmpneg_6 db " ;unsigned : ",0
cmpneg_7 db "\n jb  .",0
cmpneg_8 db "\n jge .",0
cmpneg_9 db "\n jle .",0
cmpneg_10 db "internal error compare unknown in CMPNEG()",0
ENDP

isrelational: PROC
;-705     if (token==T_EQ) goto w;

 mov ax, [token]
 cmp ax, 806
 jne .isrelational204
 jmp .w
;-706     if (token==T_NE) goto w;

.isrelational204:
 mov ax, [token]
 cmp ax, 807
 jne .isrelational205
 jmp .w
;-707     if (token==T_LE) goto w;

.isrelational205:
 mov ax, [token]
 cmp ax, 824
 jne .isrelational206
 jmp .w
;-708     if (token==T_GE) goto w;

.isrelational206:
 mov ax, [token]
 cmp ax, 811
 jne .isrelational207
 jmp .w
;-709     if (token=='<' ) goto w;

.isrelational207:
 mov ax, [token]
 cmp ax, 60
 jne .isrelational208
 jmp .w
;-710     if (token=='>' ) goto w;

.isrelational208:
 mov ax, [token]
 cmp ax, 62
 jne .isrelational209
 jmp .w
;-711     return 0;

.isrelational209:
 mov ax, 0
 jmp .retnisrelational
;-712 w:  iscmp=token;

.w:
 mov ax, [token]
 mov word [iscmp], ax
;-713     token=getlex();

 call getlex
 mov word [token], ax
;-714     return 1;

 mov ax, 1
 jmp .retnisrelational
;-715 }

;-716 

;-717 int checkreg() { // >=17 = 16bit, >=47 = 32bit

 .retnisrelational:
 ret
ENDP

checkreg: PROC
;-718   if (strlen(Symbol) <  2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 2
 jge .checkreg210
 mov ax, 0
 jmp .retncheckreg
;-719   if (eqstr(Symbol,"al")) return 1;   if (eqstr(Symbol,"cl")) return 3;

.checkreg210:
 push checkreg_0
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg211
 mov ax, 1
 jmp .retncheckreg
.checkreg211:
 push checkreg_1
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg212
 mov ax, 3
 jmp .retncheckreg
;-720   if (eqstr(Symbol,"dl")) return 5;   if (eqstr(Symbol,"bl")) return 7;

.checkreg212:
 push checkreg_2
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg213
 mov ax, 5
 jmp .retncheckreg
.checkreg213:
 push checkreg_3
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg214
 mov ax, 7
 jmp .retncheckreg
;-721   if (eqstr(Symbol,"ah")) return 9;   if (eqstr(Symbol,"ch")) return 11;

.checkreg214:
 push checkreg_4
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg215
 mov ax, 9
 jmp .retncheckreg
.checkreg215:
 push checkreg_5
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg216
 mov ax, 11
 jmp .retncheckreg
;-722   if (eqstr(Symbol,"dh")) return 13;  if (eqstr(Symbol,"bh")) return 15;

.checkreg216:
 push checkreg_6
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg217
 mov ax, 13
 jmp .retncheckreg
.checkreg217:
 push checkreg_7
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg218
 mov ax, 15
 jmp .retncheckreg
;-723   if (eqstr(Symbol,"ax")) return 17;  if (eqstr(Symbol,"cx")) return 19;

.checkreg218:
 push checkreg_8
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg219
 mov ax, 17
 jmp .retncheckreg
.checkreg219:
 push checkreg_9
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg220
 mov ax, 19
 jmp .retncheckreg
;-724   if (eqstr(Symbol,"dx")) return 21;  if (eqstr(Symbol,"bx")) return 23;

.checkreg220:
 push checkreg_10
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg221
 mov ax, 21
 jmp .retncheckreg
.checkreg221:
 push checkreg_11
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg222
 mov ax, 23
 jmp .retncheckreg
;-725   if (eqstr(Symbol,"sp")) return 25;  if (eqstr(Symbol,"bp")) return 27;

.checkreg222:
 push checkreg_12
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg223
 mov ax, 25
 jmp .retncheckreg
.checkreg223:
 push checkreg_13
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg224
 mov ax, 27
 jmp .retncheckreg
;-726   if (eqstr(Symbol,"si")) return 29;  if (eqstr(Symbol,"di")) return 31;

.checkreg224:
 push checkreg_14
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg225
 mov ax, 29
 jmp .retncheckreg
.checkreg225:
 push checkreg_15
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg226
 mov ax, 31
 jmp .retncheckreg
;-727   if (eqstr(Symbol,"es")) return 33;  if (eqstr(Symbol,"cs")) return 35;

.checkreg226:
 push checkreg_16
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg227
 mov ax, 33
 jmp .retncheckreg
.checkreg227:
 push checkreg_17
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg228
 mov ax, 35
 jmp .retncheckreg
;-728   if (eqstr(Symbol,"ss")) return 37;  if (eqstr(Symbol,"ds")) return 39;

.checkreg228:
 push checkreg_18
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg229
 mov ax, 37
 jmp .retncheckreg
.checkreg229:
 push checkreg_19
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg230
 mov ax, 39
 jmp .retncheckreg
;-729   if (eqstr(Symbol,"fs")) return 41;  if (eqstr(Symbol,"gs")) return 43;

.checkreg230:
 push checkreg_20
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg231
 mov ax, 41
 jmp .retncheckreg
.checkreg231:
 push checkreg_21
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg232
 mov ax, 43
 jmp .retncheckreg
;-730   // (eqstr(Symbol,"ip")) return 45;

;-731   if (strlen(Symbol) >   3) return 0;

.checkreg232:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 3
 jle .checkreg233
 mov ax, 0
 jmp .retncheckreg
;-732   if (eqstr(Symbol,"eax")) return 47; if (eqstr(Symbol,"ecx")) return 50;

.checkreg233:
 push checkreg_22
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg234
 mov ax, 47
 jmp .retncheckreg
.checkreg234:
 push checkreg_23
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg235
 mov ax, 50
 jmp .retncheckreg
;-733   if (eqstr(Symbol,"edx")) return 53; if (eqstr(Symbol,"ebx")) return 56;

.checkreg235:
 push checkreg_24
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg236
 mov ax, 53
 jmp .retncheckreg
.checkreg236:
 push checkreg_25
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg237
 mov ax, 56
 jmp .retncheckreg
;-734   if (eqstr(Symbol,"esp")) return 59; if (eqstr(Symbol,"ebp")) return 62;

.checkreg237:
 push checkreg_26
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg238
 mov ax, 59
 jmp .retncheckreg
.checkreg238:
 push checkreg_27
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg239
 mov ax, 62
 jmp .retncheckreg
;-735   if (eqstr(Symbol,"esi")) return 65; if (eqstr(Symbol,"edi")) return 68;

.checkreg239:
 push checkreg_28
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg240
 mov ax, 65
 jmp .retncheckreg
.checkreg240:
 push checkreg_29
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .checkreg241
 mov ax, 68
 jmp .retncheckreg
;-736 //  if (eqstr(Symbol,"cr0")) return 71;

;-737   return 0;

.checkreg241:
 mov ax, 0
 jmp .retncheckreg
;-738 }

;-739 

;-740 char printregstr[]

 .retncheckreg:
 ret
checkreg_0 db "al",0
checkreg_1 db "cl",0
checkreg_2 db "dl",0
checkreg_3 db "bl",0
checkreg_4 db "ah",0
checkreg_5 db "ch",0
checkreg_6 db "dh",0
checkreg_7 db "bh",0
checkreg_8 db "ax",0
checkreg_9 db "cx",0
checkreg_10 db "dx",0
checkreg_11 db "bx",0
checkreg_12 db "sp",0
checkreg_13 db "bp",0
checkreg_14 db "si",0
checkreg_15 db "di",0
checkreg_16 db "es",0
checkreg_17 db "cs",0
checkreg_18 db "ss",0
checkreg_19 db "ds",0
checkreg_20 db "fs",0
checkreg_21 db "gs",0
checkreg_22 db "eax",0
checkreg_23 db "ecx",0
checkreg_24 db "edx",0
checkreg_25 db "ebx",0
checkreg_26 db "esp",0
checkreg_27 db "ebp",0
checkreg_28 db "esi",0
checkreg_29 db "edi",0
ENDP
;-741 ="*alcldlblahchdhbhaxcxdxbxspbpsidiescsssdsfsgsipeaxecxedxebxespebpesiedi";

printregstr db "*alcldlblahchdhbhaxcxdxbxspbpsidiescsssdsfsgsipeaxecxedxebxespebpesiedi",0
;-742 

;-743 int printreg(int i) {


printreg: PROC
;-744     unsigned int k; unsigned char c;

;-745     k = &printregstr + i;

;Function : printreg, Number local Var: 3
; # type sign width local variables
;97 var sign word i = bp+4
;98 var unsg word k = bp-2
;99 var unsg byte c = bp-4;
 ENTER  4,0
 mov ax, printregstr
 add ax, [bp+4]
 mov [bp-2], ax
;-746     c=*k;

 mov bx, [bp-2]
 mov ax, [bx]
 mov [bp-4], al
;-747     prc(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-748     i++;

 inc  word[bp+4]
;-749     k = &printregstr + i;

 mov ax, printregstr
 add ax, [bp+4]
 mov [bp-2], ax
;-750     c=*k;

 mov bx, [bp-2]
 mov ax, [bx]
 mov [bp-4], al
;-751     prc(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-752     if (i > 47) {

 mov ax, [bp+4]
 cmp ax, 47
 jle .printreg242
;-753         i++;

 inc  word[bp+4]
;-754         k = &printregstr + i;

 mov ax, printregstr
 add ax, [bp+4]
 mov [bp-2], ax
;-755         c=*k;

 mov bx, [bp-2]
 mov ax, [bx]
 mov [bp-4], al
;-756         prc(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-757         }

;-758 }

.printreg242:
;-759 

;-760 char ops[5];

 LEAVE
 ret
ENDP
section .bss
absolute 32537
ops resb 5
section .text
;-761 int doreg1(int iscmp1) {


doreg1: PROC
;-762     int i;

;-763     if (istoken('='))          strcpy(ops, "mov");

;Function : doreg1, Number local Var: 2
; # type sign width local variables
;98 var sign word iscmp1 = bp+4
;99 var sign word i = bp-2;
 ENTER  2,0
 push 61
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1243
 push doreg1_0
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-764     if (istoken(T_PLUSASS))    strcpy(ops, "add");

.doreg1243:
 push 1230
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1244
 push doreg1_1
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-765     if (istoken(T_MINUSASS))   strcpy(ops, "sub");

.doreg1244:
 push 1231
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1245
 push doreg1_2
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-766     if (istoken(T_ANDASS))     strcpy(ops, "and");

.doreg1245:
 push 1234
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1246
 push doreg1_3
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-767     if (istoken(T_ORASS))      strcpy(ops, "or" );

.doreg1246:
 push 1235
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1247
 push doreg1_4
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-768     if (istoken(T_LESSLESS))   strcpy(ops, "shl");

.doreg1247:
 push 1240
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1248
 push doreg1_5
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-769     if (istoken(T_GREATGREAT)) strcpy(ops, "shr");

.doreg1248:
 push 1241
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1249
 push doreg1_6
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-770     if (iscmp1 == 1) {

.doreg1249:
 mov ax, [bp+4]
 cmp ax, 1
 jne .doreg1250
;-771             token=getlex();

 call getlex
 mov word [token], ax
;-772             if (isrelational() ==0) error1("Relational expected");

 call isrelational
 cmp ax, 0
 jne .doreg1251
 push doreg1_7
 call error1
 add  sp, 2
;-773             strcpy(ops, "cmp");

.doreg1251:
 push doreg1_8
 lea  ax, [ops]
 push ax
 call strcpy
 add  sp, 4
;-774         }

;-775     printstring("\n ");

.doreg1250:
 push doreg1_9
 call printstring
 add  sp, 2
;-776     printstring(ops);

 lea  ax, [ops]
 push ax
 call printstring
 add  sp, 2
;-777     printstring("  ");

 push doreg1_10
 call printstring
 add  sp, 2
;-778     printreg(ireg1);   //todo

 push word [ireg1]
 call printreg
 add  sp, 2
;-779     printstring(", ");

 push doreg1_11
 call printstring
 add  sp, 2
;-780 

;-781     if (istoken(T_CONST)) {

 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .doreg1252
;-782         printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-783         goto reg1;

 jmp .reg1
;-784         }

;-785     mod2=typeName();

.doreg1252:
 call typeName
 mov word [mod2], ax
;-786     ireg2=checkreg();

 call checkreg
 mov word [ireg2], ax
;-787     if (ireg2) {

 mov ax, [ireg2]
 or  al, al
 je .doreg1253
;-788         printreg(ireg2);

 push word [ireg2]
 call printreg
 add  sp, 2
;-789         goto reg1;

 jmp .reg1
;-790         }

;-791     i=searchname();

.doreg1253:
 call searchname
 mov [bp-2], ax
;-792     if (mod2 == 2) printName(i);

 mov ax, [mod2]
 cmp ax, 2
 jne .doreg1254
 push word [bp-2]
 call printName
 add  sp, 2
;-793         else v(i);

 jmp .doreg1255
.doreg1254:
 push word [bp-2]
 call v
 add  sp, 2
;-794 reg1: if (iscmp1 == 1) {

.doreg1255:
.reg1:
 mov ax, [bp+4]
 cmp ax, 1
 jne .doreg1256
;-795     cmpneg(0);

 push 0
 call cmpneg
 add  sp, 2
;-796     printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-797     expect(')');

 push 41
 call expect
 add  sp, 2
;-798     }

;-799 }

.doreg1256:
;-800 

;-801 int compoundass(char *op, int mode, int id1) {

 LEAVE
 ret
doreg1_0 db "mov",0
doreg1_1 db "add",0
doreg1_2 db "sub",0
doreg1_3 db "and",0
doreg1_4 db "or",0
doreg1_5 db "shl",0
doreg1_6 db "shr",0
doreg1_7 db "Relational expected",0
doreg1_8 db "cmp",0
doreg1_9 db "\n ",0
doreg1_10 db "  ",0
doreg1_11 db ", ",0
ENDP

compoundass: PROC
;-802     if(mode) error1("only scalar variable allowed");

;Function : compoundass, Number local Var: 3
; # type sign width local variables
;98 ptr sign byte op = bp+4
;99 var sign word mode = bp+6
;100 var sign word id1 = bp+8;
 ENTER  0,0
 mov ax, [bp+6]
 or  al, al
 je .compoundass257
 push compoundass_0
 call error1
 add  sp, 2
;-803     printstring("\n ");

.compoundass257:
 push compoundass_1
 call printstring
 add  sp, 2
;-804     printstring(op);

 push word [bp+4]
 call printstring
 add  sp, 2
;-805     printstring("  ");

 push compoundass_2
 call printstring
 add  sp, 2
;-806     gettypes(id1);

 push word [bp+8]
 call gettypes
 add  sp, 2
;-807     if (wi==2) printstring("word");

 mov ax, [wi]
 cmp ax, 2
 jne .compoundass258
 push compoundass_3
 call printstring
 add  sp, 2
;-808         else printstring("byte");

 jmp .compoundass259
.compoundass258:
 push compoundass_4
 call printstring
 add  sp, 2
;-809     v(id1);

.compoundass259:
 push word [bp+8]
 call v
 add  sp, 2
;-810     printstring(", ");

 push compoundass_5
 call printstring
 add  sp, 2
;-811     expect(T_CONST);

 push 257
 call expect
 add  sp, 2
;-812     printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-813 }

;-814 

;-815 int dovar1(int mode, int op, int ixarr, int id1) {

 LEAVE
 ret
compoundass_0 db "only scalar variable allowed",0
compoundass_1 db "\n ",0
compoundass_2 db "  ",0
compoundass_3 db "word",0
compoundass_4 db "byte",0
compoundass_5 db ", ",0
ENDP

dovar1: PROC
;-816     gettypes(id1);

;Function : dovar1, Number local Var: 4
; # type sign width local variables
;98 var sign word mode = bp+4
;99 var sign word op = bp+6
;100 var sign word ixarr = bp+8
;101 var sign word id1 = bp+10;
 ENTER  0,0
 push word [bp+10]
 call gettypes
 add  sp, 2
;-817     if (mode==1) {// * = ptr

 mov ax, [bp+4]
 cmp ax, 1
 jne .dovar1260
;-818         printstring("\n mov bx, ");

 push dovar1_0
 call printstring
 add  sp, 2
;-819         v(id1); printstring("\n ");

 push word [bp+10]
 call v
 add  sp, 2
 push dovar1_1
 call printstring
 add  sp, 2
;-820         printstring(op);

 push word [bp+6]
 call printstring
 add  sp, 2
;-821         if(widthi == 1) printstring(" al, [bx]\n mov ah, 0");

 mov ax, [widthi]
 cmp ax, 1
 jne .dovar1261
 push dovar1_2
 call printstring
 add  sp, 2
;-822         if(widthi == 2) printstring(" ax, [bx]");

.dovar1261:
 mov ax, [widthi]
 cmp ax, 2
 jne .dovar1262
 push dovar1_3
 call printstring
 add  sp, 2
;-823         return;

.dovar1262:
 jmp .retndovar1
;-824         }

;-825     if (mode==2){// & = adr

.dovar1260:
 mov ax, [bp+4]
 cmp ax, 2
 jne .dovar1263
;-826         printstring("\n ");

 push dovar1_4
 call printstring
 add  sp, 2
;-827         printstring(op);

 push word [bp+6]
 call printstring
 add  sp, 2
;-828         printstring(" ax, ");

 push dovar1_5
 call printstring
 add  sp, 2
;-829         printName(id1);

 push word [bp+10]
 call printName
 add  sp, 2
;-830         return;

 jmp .retndovar1
;-831         }

;-832     if (ixarr) {//array

.dovar1263:
 mov ax, [bp+8]
 or  al, al
 je .dovar1264
;-833         printstring("\n mov bx, ");

 push dovar1_6
 call printstring
 add  sp, 2
;-834         v(ixarr);

 push word [bp+8]
 call v
 add  sp, 2
;-835         if (wi==2) printstring("\n shl bx, 1");

 mov ax, [wi]
 cmp ax, 2
 jne .dovar1265
 push dovar1_7
 call printstring
 add  sp, 2
;-836         printstring("\n ");

.dovar1265:
 push dovar1_8
 call printstring
 add  sp, 2
;-837         printstring(op);

 push word [bp+6]
 call printstring
 add  sp, 2
;-838         if (wi==2) printstring(" ax, ");

 mov ax, [wi]
 cmp ax, 2
 jne .dovar1266
 push dovar1_9
 call printstring
 add  sp, 2
;-839             else printstring(" al, ");

 jmp .dovar1267
.dovar1266:
 push dovar1_10
 call printstring
 add  sp, 2
;-840         prc('[');

.dovar1267:
 push 91
 call prc
 add  sp, 2
;-841         printName(id1);

 push word [bp+10]
 call printName
 add  sp, 2
;-842         printstring(" + bx]");

 push dovar1_11
 call printstring
 add  sp, 2
;-843         return;

 jmp .retndovar1
;-844         }

;-845     printstring("\n ");

.dovar1264:
 push dovar1_12
 call printstring
 add  sp, 2
;-846     printstring(op);

 push word [bp+6]
 call printstring
 add  sp, 2
;-847     if(wi==1) printstring(" al, ");

 mov ax, [wi]
 cmp ax, 1
 jne .dovar1268
 push dovar1_13
 call printstring
 add  sp, 2
;-848     if(wi==2) printstring(" ax, ");

.dovar1268:
 mov ax, [wi]
 cmp ax, 2
 jne .dovar1269
 push dovar1_14
 call printstring
 add  sp, 2
;-849     if(wi==4) printstring(" eax, ");

.dovar1269:
 mov ax, [wi]
 cmp ax, 4
 jne .dovar1270
 push dovar1_15
 call printstring
 add  sp, 2
;-850     v(id1);

.dovar1270:
 push word [bp+10]
 call v
 add  sp, 2
;-851 }

;-852 

;-853 int rterm(char *op) {

 .retndovar1:
 LEAVE
 ret
dovar1_0 db "\n mov bx, ",0
dovar1_1 db "\n ",0
dovar1_2 db " al, [bx]\n mov ah, 0",0
dovar1_3 db " ax, [bx]",0
dovar1_4 db "\n ",0
dovar1_5 db " ax, ",0
dovar1_6 db "\n mov bx, ",0
dovar1_7 db "\n shl bx, 1",0
dovar1_8 db "\n ",0
dovar1_9 db " ax, ",0
dovar1_10 db " al, ",0
dovar1_11 db " + bx]",0
dovar1_12 db "\n ",0
dovar1_13 db " al, ",0
dovar1_14 db " ax, ",0
dovar1_15 db " eax, ",0
ENDP

rterm: PROC
;-854     int mode; int opint; int ixarr; int id1;

;-855     if (istoken(T_CONST)) {

;Function : rterm, Number local Var: 5
; # type sign width local variables
;98 ptr sign byte op = bp+4
;99 var sign word mode = bp-2
;100 var sign word opint = bp-4
;101 var sign word ixarr = bp-6
;102 var sign word id1 = bp-8;
 ENTER  8,0
 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .rterm271
;-856         printstring("\n ");

 push rterm_0
 call printstring
 add  sp, 2
;-857         printstring(op);

 push word [bp+4]
 call printstring
 add  sp, 2
;-858         if (wi==1) printstring(" al, ");

 mov ax, [wi]
 cmp ax, 1
 jne .rterm272
 push rterm_1
 call printstring
 add  sp, 2
;-859         if (wi==2) printstring(" ax, ");

.rterm272:
 mov ax, [wi]
 cmp ax, 2
 jne .rterm273
 push rterm_2
 call printstring
 add  sp, 2
;-860         if (wi==4) printstring(" eax, ");

.rterm273:
 mov ax, [wi]
 cmp ax, 4
 jne .rterm274
 push rterm_3
 call printstring
 add  sp, 2
;-861         printunsigned(lexval);

.rterm274:
 push word [lexval]
 call printunsigned
 add  sp, 2
;-862         return;

 jmp .retnrterm
;-863         }

;-864     mode=typeName();

.rterm271:
 call typeName
 mov [bp-2], ax
;-865     id1=searchname();

 call searchname
 mov [bp-8], ax
;-866     ixarr=0;

 mov ax, 0
 mov [bp-6], ax
;-867     if (istoken('[')) {

 push 91
 call istoken
 add  sp, 2
 or  al, al
 je .rterm275
;-868         ixarr=searchname();

 call searchname
 mov [bp-6], ax
;-869         expect(T_NAME);

 push 256
 call expect
 add  sp, 2
;-870         expect(']');

 push 93
 call expect
 add  sp, 2
;-871         gettypes(ixarr);

 push word [bp-6]
 call gettypes
 add  sp, 2
;-872         if (widthi != 2) error1("Array index must be int");

 mov ax, [widthi]
 cmp ax, 2
 je  .rterm276
 push rterm_4
 call error1
 add  sp, 2
;-873         }

.rterm276:
;-874     if (eqstr(Symbol,"ax")) return;

.rterm275:
 push rterm_5
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .rterm277
 jmp .retnrterm
;-875     opint=op;

.rterm277:
 mov ax, [bp+4]
 mov [bp-4], ax
;-876     dovar1(mode, opint, ixarr, id1);

 push word [bp-8]
 push word [bp-6]
 push word [bp-4]
 push word [bp-2]
 call dovar1
 add  sp, 8
;-877 }

;-878 

;-879 int doassign(int mode, int i, int ixarr, int ixconst) {

 .retnrterm:
 LEAVE
 ret
rterm_0 db "\n ",0
rterm_1 db " al, ",0
rterm_2 db " ax, ",0
rterm_3 db " eax, ",0
rterm_4 db "Array index must be int",0
rterm_5 db "ax",0
ENDP

doassign: PROC
;-880     gettypes(i);

;Function : doassign, Number local Var: 4
; # type sign width local variables
;98 var sign word mode = bp+4
;99 var sign word i = bp+6
;100 var sign word ixarr = bp+8
;101 var sign word ixconst = bp+10;
 ENTER  0,0
 push word [bp+6]
 call gettypes
 add  sp, 2
;-881     if (mode==1) {// * = ptr

 mov ax, [bp+4]
 cmp ax, 1
 jne .doassign278
;-882         printstring("\n mov  bx, ");

 push doassign_0
 call printstring
 add  sp, 2
;-883         v(i);

 push word [bp+6]
 call v
 add  sp, 2
;-884         if (widthi == 2) printstring("\n mov  [bx], ax");

 mov ax, [widthi]
 cmp ax, 2
 jne .doassign279
 push doassign_1
 call printstring
 add  sp, 2
;-885             else  printstring("\n mov  [bx], al");

 jmp .doassign280
.doassign279:
 push doassign_2
 call printstring
 add  sp, 2
;-886         return;

.doassign280:
 jmp .retndoassign
;-887         }

;-888     if (mode==2) {// & = adr

.doassign278:
 mov ax, [bp+4]
 cmp ax, 2
 jne .doassign281
;-889         printstring("\n mov  ");

 push doassign_3
 call printstring
 add  sp, 2
;-890         printName(i);

 push word [bp+6]
 call printName
 add  sp, 2
;-891         printstring(", ax");

 push doassign_4
 call printstring
 add  sp, 2
;-892         return;

 jmp .retndoassign
;-893         }

;-894     if (ixarr) {

.doassign281:
 mov ax, [bp+8]
 or  al, al
 je .doassign282
;-895         printstring("\n mov bx, ");

 push doassign_5
 call printstring
 add  sp, 2
;-896         if(ixconst) printunsigned(ixarr);

 mov ax, [bp+10]
 or  al, al
 je .doassign283
 push word [bp+8]
 call printunsigned
 add  sp, 2
;-897             else v(ixarr);

 jmp .doassign284
.doassign283:
 push word [bp+8]
 call v
 add  sp, 2
;-898         if (wi==2) printstring("\n shl bx, 1");

.doassign284:
 mov ax, [wi]
 cmp ax, 2
 jne .doassign285
 push doassign_6
 call printstring
 add  sp, 2
;-899         printstring("\n mov [");

.doassign285:
 push doassign_7
 call printstring
 add  sp, 2
;-900         printName(i);

 push word [bp+6]
 call printName
 add  sp, 2
;-901         if (wi==2) printstring("+bx], ax");

 mov ax, [wi]
 cmp ax, 2
 jne .doassign286
 push doassign_8
 call printstring
 add  sp, 2
;-902             else printstring("+bx], al");

 jmp .doassign287
.doassign286:
 push doassign_9
 call printstring
 add  sp, 2
;-903         return;

.doassign287:
 jmp .retndoassign
;-904         }

;-905     if (wi==1){

.doassign282:
 mov ax, [wi]
 cmp ax, 1
 jne .doassign288
;-906         printstring("\n mov ");

 push doassign_10
 call printstring
 add  sp, 2
;-907         if(i<GTop) printstring("byte ");

 mov ax, [bp+6]
 cmp ax, [GTop]
 jge .doassign289
 push doassign_11
 call printstring
 add  sp, 2
;-908         v(i);

.doassign289:
 push word [bp+6]
 call v
 add  sp, 2
;-909         printstring(", al");

 push doassign_12
 call printstring
 add  sp, 2
;-910         return;

 jmp .retndoassign
;-911         }

;-912     if (wi==2){

.doassign288:
 mov ax, [wi]
 cmp ax, 2
 jne .doassign290
;-913         printstring("\n mov ");

 push doassign_13
 call printstring
 add  sp, 2
;-914         if(i<GTop) printstring("word ");

 mov ax, [bp+6]
 cmp ax, [GTop]
 jge .doassign291
 push doassign_14
 call printstring
 add  sp, 2
;-915         v(i);

.doassign291:
 push word [bp+6]
 call v
 add  sp, 2
;-916         printstring(", ax");

 push doassign_15
 call printstring
 add  sp, 2
;-917         return;

 jmp .retndoassign
;-918         }

;-919     if (wi==4){

.doassign290:
 mov ax, [wi]
 cmp ax, 4
 jne .doassign292
;-920         printstring("\n mov ");

 push doassign_16
 call printstring
 add  sp, 2
;-921         if(i<GTop) printstring("dword ");

 mov ax, [bp+6]
 cmp ax, [GTop]
 jge .doassign293
 push doassign_17
 call printstring
 add  sp, 2
;-922         v(i);

.doassign293:
 push word [bp+6]
 call v
 add  sp, 2
;-923         printstring(", eax");

 push doassign_18
 call printstring
 add  sp, 2
;-924         return;

 jmp .retndoassign
;-925         }

;-926 }

.doassign292:
;-927 

;-928 int domul(int ids) {

 .retndoassign:
 LEAVE
 ret
doassign_0 db "\n mov  bx, ",0
doassign_1 db "\n mov  [bx], ax",0
doassign_2 db "\n mov  [bx], al",0
doassign_3 db "\n mov  ",0
doassign_4 db ", ax",0
doassign_5 db "\n mov bx, ",0
doassign_6 db "\n shl bx, 1",0
doassign_7 db "\n mov [",0
doassign_8 db "+bx], ax",0
doassign_9 db "+bx], al",0
doassign_10 db "\n mov ",0
doassign_11 db "byte ",0
doassign_12 db ", al",0
doassign_13 db "\n mov ",0
doassign_14 db "word ",0
doassign_15 db ", ax",0
doassign_16 db "\n mov ",0
doassign_17 db "dword ",0
doassign_18 db ", eax",0
ENDP

domul: PROC
;-929     if (ids) rterm("imul");

;Function : domul, Number local Var: 1
; # type sign width local variables
;98 var sign word ids = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 or  al, al
 je .domul294
 push domul_0
 call rterm
 add  sp, 2
;-930         else {

 jmp .domul295
.domul294:
;-931         if (istoken(T_CONST)) {

 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .domul296
;-932             printstring("\n mov bx, ");

 push domul_1
 call printstring
 add  sp, 2
;-933             printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-934             printstring("\n mul bx");

 push domul_2
 call printstring
 add  sp, 2
;-935             }

;-936         else error1("with MUL only const number as multipl. allowed");

 jmp .domul297
.domul296:
 push domul_3
 call error1
 add  sp, 2
;-937         }

.domul297:
;-938 }

.domul295:
;-939 

;-940 int doidiv(int ids) {

 LEAVE
 ret
domul_0 db "imul",0
domul_1 db "\n mov bx, ",0
domul_2 db "\n mul bx",0
domul_3 db "with MUL only const number as multipl. allowed",0
ENDP

doidiv: PROC
;-941     int mode; int id1;

;-942     if (istoken(T_CONST)) {

;Function : doidiv, Number local Var: 3
; # type sign width local variables
;98 var sign word ids = bp+4
;99 var sign word mode = bp-2
;100 var sign word id1 = bp-4;
 ENTER  4,0
 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .doidiv298
;-943         printstring("\n mov bx, ");

 push doidiv_0
 call printstring
 add  sp, 2
;-944         printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-945         if (ids) printstring("\n cwd\n idiv bx");

 mov ax, [bp+4]
 or  al, al
 je .doidiv299
 push doidiv_1
 call printstring
 add  sp, 2
;-946             else printstring("\n mov dx, 0\n div bx");

 jmp .doidiv300
.doidiv299:
 push doidiv_2
 call printstring
 add  sp, 2
;-947         }

.doidiv300:
;-948     else {

 jmp .doidiv301
.doidiv298:
;-949         mode=typeName();

 call typeName
 mov [bp-2], ax
;-950         id1=searchname();

 call searchname
 mov [bp-4], ax
;-951         if (mode) error1("only const number or int as divisor allowed");

 mov ax, [bp-2]
 or  al, al
 je .doidiv302
 push doidiv_3
 call error1
 add  sp, 2
;-952         gettypes(id1);

.doidiv302:
 push word [bp-4]
 call gettypes
 add  sp, 2
;-953         if (typei) error1("only int as simple var divisor allowed");

 mov ax, [typei]
 or  al, al
 je .doidiv303
 push doidiv_4
 call error1
 add  sp, 2
;-954         if (wi!=2) error1("only int, no byte as divisor allowed");

.doidiv303:
 mov ax, [wi]
 cmp ax, 2
 je  .doidiv304
 push doidiv_5
 call error1
 add  sp, 2
;-955         printstring("\n mov bx, ");

.doidiv304:
 push doidiv_6
 call printstring
 add  sp, 2
;-956         v(id1);

 push word [bp-4]
 call v
 add  sp, 2
;-957         if (ids) printstring("\n cwd\n idiv bx");

 mov ax, [bp+4]
 or  al, al
 je .doidiv305
 push doidiv_7
 call printstring
 add  sp, 2
;-958             else printstring("\n mov dx, 0\n div bx");

 jmp .doidiv306
.doidiv305:
 push doidiv_8
 call printstring
 add  sp, 2
;-959     }

.doidiv306:
;-960 }

.doidiv301:
;-961 

;-962 int domod(int ids) {

 LEAVE
 ret
doidiv_0 db "\n mov bx, ",0
doidiv_1 db "\n cwd\n idiv bx",0
doidiv_2 db "\n mov dx, 0\n div bx",0
doidiv_3 db "only const number or int as divisor allowed",0
doidiv_4 db "only int as simple var divisor allowed",0
doidiv_5 db "only int, no byte as divisor allowed",0
doidiv_6 db "\n mov bx, ",0
doidiv_7 db "\n cwd\n idiv bx",0
doidiv_8 db "\n mov dx, 0\n div bx",0
ENDP

domod: PROC
;-963     doidiv(ids);

;Function : domod, Number local Var: 1
; # type sign width local variables
;98 var sign word ids = bp+4;
 ENTER  0,0
 push word [bp+4]
 call doidiv
 add  sp, 2
;-964     printstring("\n mov ax, dx");

 push domod_0
 call printstring
 add  sp, 2
;-965 }

;-966 

;-967 

;-968 int docalltype[10]; int docallvalue[10];

 LEAVE
 ret
domod_0 db "\n mov ax, dx",0
ENDP
section .bss
absolute 32542
docalltype resw 10
section .text
section .bss
absolute 32562
docallvalue resw 10
section .text
;-969 char procname[17]; // 1=CONST, 2=String, 3=&, 4=Name

section .bss
absolute 32582
procname resb 17
section .text
;-970 

;-971 int docall() {


docall: PROC
;-972     int i; int narg; int t0; int n0;  int sz32;

;-973     narg=0;

;Function : docall, Number local Var: 5
; # type sign width local variables
;101 var sign word i = bp-2
;102 var sign word narg = bp-4
;103 var sign word t0 = bp-6
;104 var sign word n0 = bp-8
;105 var sign word sz32 = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-4], ax
;-974     sz32=0;

 mov ax, 0
 mov [bp-10], ax
;-975     checknamelen();

 call checknamelen
;-976     strcpy(&procname, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [procname]
 push ax
 call strcpy
 add  sp, 4
;-977     expect('(');

 push 40
 call expect
 add  sp, 2
;-978 	if (istoken(')') ==0 ) {

 push 41
 call istoken
 add  sp, 2
 cmp ax, 0
 jne .docall307
;-979 	    do {

.docall308:
;-980 	        narg++;

 inc  word[bp-4]
;-981 	        if (narg >9 ) error1("Max. 9 parameters");

 mov ax, [bp-4]
 cmp ax, 9
 jle .docall309
 push docall_0
 call error1
 add  sp, 2
;-982 	        t0=0;

.docall309:
 mov ax, 0
 mov [bp-6], ax
;-983             if(istoken(T_CONST)) {

 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .docall310
;-984                 t0=1;

 mov ax, 1
 mov [bp-6], ax
;-985                 n0=lexval;

 mov ax, [lexval]
 mov [bp-8], ax
;-986                 }

;-987             if(istoken(T_STRING)){

.docall310:
 push 258
 call istoken
 add  sp, 2
 or  al, al
 je .docall311
;-988                 t0=2;

 mov ax, 2
 mov [bp-6], ax
;-989                 n0=nconst;

 mov ax, [nconst]
 mov [bp-8], ax
;-990                 eprs("\n");

 push docall_1
 call eprs
 add  sp, 2
;-991                 eprs(fname);

 lea  ax, [fname]
 push ax
 call eprs
 add  sp, 2
;-992                 eprc(95);

 push 95
 call eprc
 add  sp, 2
;-993                 eprnum(nconst);

 push word [nconst]
 call eprnum
 add  sp, 2
;-994                 eprs(" db ");

 push docall_2
 call eprs
 add  sp, 2
;-995                 eprc(34);

 push 34
 call eprc
 add  sp, 2
;-996                 eprs(Symbol);

 lea  ax, [Symbol]
 push ax
 call eprs
 add  sp, 2
;-997                 eprc(34);

 push 34
 call eprc
 add  sp, 2
;-998                 eprs(",0");

 push docall_3
 call eprs
 add  sp, 2
;-999                 nconst++;

 inc  word[nconst]
;-1000                 }

;-1001             if(istoken('&'))     {

.docall311:
 push 38
 call istoken
 add  sp, 2
 or  al, al
 je .docall312
;-1002                 t0=3;

 mov ax, 3
 mov [bp-6], ax
;-1003                 name1();

 call name1
;-1004                 n0=searchname();

 call searchname
 mov [bp-8], ax
;-1005                 }

;-1006             if(istoken(T_NAME))  {

.docall312:
 push 256
 call istoken
 add  sp, 2
 or  al, al
 je .docall313
;-1007 

;-1008 

;-1009 

;-1010                     t0=4;

 mov ax, 4
 mov [bp-6], ax
;-1011                     n0=searchname();

 call searchname
 mov [bp-8], ax
;-1012                     p1=&GType;

 mov ax, GType
 mov word [p1], ax
;-1013                     p1=p1+n0;

 mov ax, [p1]
 add ax, [bp-8]
 mov word [p1], ax
;-1014                     if (*p1=='&') t0=3;

 mov bx, [p1]
 mov al, [bx]
 mov ah, 0
 cmp ax, 38
 jne .docall314
 mov ax, 3
 mov [bp-6], ax
;-1015 

;-1016                 }

.docall314:
;-1017             if (t0==0) error1("parameter not recognized (no * allowed)");

.docall313:
 mov ax, [bp-6]
 cmp ax, 0
 jne .docall315
 push docall_4
 call error1
 add  sp, 2
;-1018             docalltype [narg] = t0;

.docall315:
 mov ax, [bp-6]
 mov bx, [bp-4]
 shl bx, 1
 mov [docalltype+bx], ax
;-1019             docallvalue[narg] = n0;

 mov ax, [bp-8]
 mov bx, [bp-4]
 shl bx, 1
 mov [docallvalue+bx], ax
;-1020         } while (istoken(','));

 push 44
 call istoken
 add  sp, 2
 or  al, al
 je .docall316
 jmp .docall308
.docall316:
;-1021 

;-1022   	expect(')');

 push 41
 call expect
 add  sp, 2
;-1023   	i=narg;

 mov ax, [bp-4]
 mov [bp-2], ax
;-1024     do {

.docall317:
;-1025         t0 = docalltype [i];

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [docalltype + bx]
 mov [bp-6], ax
;-1026         n0 = docallvalue[i];

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [docallvalue + bx]
 mov [bp-8], ax
;-1027         if(t0==1){

 mov ax, [bp-6]
 cmp ax, 1
 jne .docall318
;-1028             printstring("\n push ");

 push docall_5
 call printstring
 add  sp, 2
;-1029             printunsigned(n0);

 push word [bp-8]
 call printunsigned
 add  sp, 2
;-1030             }

;-1031         if(t0==2){

.docall318:
 mov ax, [bp-6]
 cmp ax, 2
 jne .docall319
;-1032             printstring("\n push ");

 push docall_6
 call printstring
 add  sp, 2
;-1033             printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1034             prc(95);

 push 95
 call prc
 add  sp, 2
;-1035             printunsigned(n0);

 push word [bp-8]
 call printunsigned
 add  sp, 2
;-1036             }

;-1037         if(t0==3){

.docall319:
 mov ax, [bp-6]
 cmp ax, 3
 jne .docall320
;-1038             printstring("\n lea  ax, ");

 push docall_7
 call printstring
 add  sp, 2
;-1039             v(n0);

 push word [bp-8]
 call v
 add  sp, 2
;-1040             printstring("\n push ax");

 push docall_8
 call printstring
 add  sp, 2
;-1041             }

;-1042         if(t0==4){

.docall320:
 mov ax, [bp-6]
 cmp ax, 4
 jne .docall321
;-1043             gettypes(n0);

 push word [bp-8]
 call gettypes
 add  sp, 2
;-1044             if(wi==2) {

 mov ax, [wi]
 cmp ax, 2
 jne .docall322
;-1045                 printstring("\n push word ");

 push docall_9
 call printstring
 add  sp, 2
;-1046                 v(n0);

 push word [bp-8]
 call v
 add  sp, 2
;-1047                 }

;-1048             else {

 jmp .docall323
.docall322:
;-1049                 printstring("\n mov al, byte ");

 push docall_10
 call printstring
 add  sp, 2
;-1050                 v(n0);

 push word [bp-8]
 call v
 add  sp, 2
;-1051                 printstring("\n mov ah, 0\n push ax");

 push docall_11
 call printstring
 add  sp, 2
;-1052                 }

;-1053             }

.docall323:
;-1054         if(t0==5){

.docall321:
 mov ax, [bp-6]
 cmp ax, 5
 jne .docall324
;-1055             printstring("\n push ");

 push docall_12
 call printstring
 add  sp, 2
;-1056             printreg(n0);

 push word [bp-8]
 call printreg
 add  sp, 2
;-1057             if (n0 >= 47) sz32+2;

 mov ax, [bp-8]
 cmp ax, 47 ;unsigned : 1
 jl  .docall325
 mov ax, [bp-10]
 add ax, 2
;-1058             }

.docall325:
;-1059         i--;

.docall324:
 dec  word[bp-2]
;-1060         } while (i > 0);

 mov ax, [bp-2]
 cmp ax, 0
 jle .docall326
 jmp .docall317
.docall326:
;-1061     }

;-1062 	printstring("\n call ");

.docall307:
 push docall_13
 call printstring
 add  sp, 2
;-1063 	printstring(&procname);

 lea  ax, [procname]
 push ax
 call printstring
 add  sp, 2
;-1064 	if (narg>0) {

 mov ax, [bp-4]
 cmp ax, 0
 jle .docall327
;-1065 	    printstring("\n add  sp, ");

 push docall_14
 call printstring
 add  sp, 2
;-1066         narg=narg+narg;

 mov ax, [bp-4]
 add ax, [bp-4]
 mov [bp-4], ax
;-1067         narg=narg+sz32;

 mov ax, [bp-4]
 add ax, [bp-10]
 mov [bp-4], ax
;-1068         printunsigned(narg);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1069         }

;-1070 }

.docall327:
;-1071 

;-1072 

;-1073 int expr() {

 LEAVE
 ret
docall_0 db "Max. 9 parameters",0
docall_1 db "\n",0
docall_2 db " db ",0
docall_3 db ",0",0
docall_4 db "parameter not recognized (no * allowed)",0
docall_5 db "\n push ",0
docall_6 db "\n push ",0
docall_7 db "\n lea  ax, ",0
docall_8 db "\n push ax",0
docall_9 db "\n push word ",0
docall_10 db "\n mov al, byte ",0
docall_11 db "\n mov ah, 0\n push ax",0
docall_12 db "\n push ",0
docall_13 db "\n call ",0
docall_14 db "\n add  sp, ",0
ENDP

expr: PROC
;-1074     int mode;   int id1;

;-1075     int ixarr;  int ixconst;

;-1076     int ids;    int isCONST;

;-1077     int i;      unsigned char *p;

;-1078 

;-1079     if (istoken(T_CONST)) {// constant ;

;Function : expr, Number local Var: 8
; # type sign width local variables
;101 var sign word mode = bp-2
;102 var sign word id1 = bp-4
;103 var sign word ixarr = bp-6
;104 var sign word ixconst = bp-8
;105 var sign word ids = bp-10
;106 var sign word isCONST = bp-12
;107 var sign word i = bp-14
;108 ptr unsg byte p = bp-16;
 ENTER  16,0
 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .expr328
;-1080         printstring("\n mov ax, ");

 push expr_0
 call printstring
 add  sp, 2
;-1081         printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-1082         return 4;

 mov ax, 4
 jmp .retnexpr
;-1083         }

;-1084     mode=typeName(); /*0=variable, 1=* ptr, 2=& adr*/

.expr328:
 call typeName
 mov [bp-2], ax
;-1085     ireg1=checkreg();//todo

 call checkreg
 mov word [ireg1], ax
;-1086     if (ireg1) {

 mov ax, [ireg1]
 or  al, al
 je .expr329
;-1087         doreg1(0);

 push 0
 call doreg1
 add  sp, 2
;-1088         return;

 jmp .retnexpr
;-1089         }

;-1090 

;-1091     if (token=='(')  {

.expr329:
 mov ax, [token]
 cmp ax, 40
 jne .expr330
;-1092         docall();

 call docall
;-1093         goto e1;

 jmp .e1
;-1094         }

;-1095 

;-1096     id1=searchname();

.expr330:
 call searchname
 mov [bp-4], ax
;-1097     gettypes(id1);

 push word [bp-4]
 call gettypes
 add  sp, 2
;-1098     ids=signi;

 mov ax, [signi]
 mov [bp-10], ax
;-1099     ixarr=0;

 mov ax, 0
 mov [bp-6], ax
;-1100     ixconst=0;

 mov ax, 0
 mov [bp-8], ax
;-1101     if (istoken('[')) {

 push 91
 call istoken
 add  sp, 2
 or  al, al
 je .expr331
;-1102         if (istoken(T_CONST)) {

 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .expr332
;-1103             ixconst=1;

 mov ax, 1
 mov [bp-8], ax
;-1104             ixarr=lexval;

 mov ax, [lexval]
 mov [bp-6], ax
;-1105             expect(']');

 push 93
 call expect
 add  sp, 2
;-1106             }

;-1107         else {

 jmp .expr333
.expr332:
;-1108             ixarr=searchname();

 call searchname
 mov [bp-6], ax
;-1109             expect(T_NAME);

 push 256
 call expect
 add  sp, 2
;-1110             expect(']');

 push 93
 call expect
 add  sp, 2
;-1111             gettypes(ixarr);

 push word [bp-6]
 call gettypes
 add  sp, 2
;-1112             if (widthi != 2) error1("Array index must be number or int");

 mov ax, [widthi]
 cmp ax, 2
 je  .expr334
 push expr_1
 call error1
 add  sp, 2
;-1113             }

.expr334:
;-1114         }

.expr333:
;-1115     if (istoken(T_PLUSPLUS  )) {

.expr331:
 push 1219
 call istoken
 add  sp, 2
 or  al, al
 je .expr335
;-1116         if(mode)error1("Only var allowed");

 mov ax, [bp-2]
 or  al, al
 je .expr336
 push expr_2
 call error1
 add  sp, 2
;-1117         printstring("\n inc  ");

.expr336:
 push expr_3
 call printstring
 add  sp, 2
;-1118         if (wi==2) printstring("word"); else printstring("byte");

 mov ax, [wi]
 cmp ax, 2
 jne .expr337
 push expr_4
 call printstring
 add  sp, 2
 jmp .expr338
.expr337:
 push expr_5
 call printstring
 add  sp, 2
;-1119         v(id1);

.expr338:
 push word [bp-4]
 call v
 add  sp, 2
;-1120         goto e1;

 jmp .e1
;-1121         }

;-1122     if (istoken(T_MINUSMINUS)) {

.expr335:
 push 1225
 call istoken
 add  sp, 2
 or  al, al
 je .expr339
;-1123         if(mode)error1("Only var allowed");

 mov ax, [bp-2]
 or  al, al
 je .expr340
 push expr_6
 call error1
 add  sp, 2
;-1124         printstring("\n dec  ");

.expr340:
 push expr_7
 call printstring
 add  sp, 2
;-1125         if (wi==2) printstring("word"); else printstring("byte");

 mov ax, [wi]
 cmp ax, 2
 jne .expr341
 push expr_8
 call printstring
 add  sp, 2
 jmp .expr342
.expr341:
 push expr_9
 call printstring
 add  sp, 2
;-1126         v(id1);

.expr342:
 push word [bp-4]
 call v
 add  sp, 2
;-1127         goto e1;

 jmp .e1
;-1128         }

;-1129 

;-1130     if (istoken(T_PLUSASS )) {compoundass("add", mode, id1); goto e1; }

.expr339:
 push 1230
 call istoken
 add  sp, 2
 or  al, al
 je .expr343
 push word [bp-4]
 push word [bp-2]
 push expr_10
 call compoundass
 add  sp, 6
 jmp .e1
;-1131     if (istoken(T_MINUSASS)) {compoundass("sub", mode, id1); goto e1; }

.expr343:
 push 1231
 call istoken
 add  sp, 2
 or  al, al
 je .expr344
 push word [bp-4]
 push word [bp-2]
 push expr_11
 call compoundass
 add  sp, 6
 jmp .e1
;-1132     if (istoken(T_ANDASS  )) {compoundass("and", mode, id1); goto e1; }

.expr344:
 push 1234
 call istoken
 add  sp, 2
 or  al, al
 je .expr345
 push word [bp-4]
 push word [bp-2]
 push expr_12
 call compoundass
 add  sp, 6
 jmp .e1
;-1133     if (istoken(T_ORASS   )) {compoundass("or" , mode, id1); goto e1; }

.expr345:
 push 1235
 call istoken
 add  sp, 2
 or  al, al
 je .expr346
 push word [bp-4]
 push word [bp-2]
 push expr_13
 call compoundass
 add  sp, 6
 jmp .e1
;-1134     if (istoken(T_MULASS  )) error1("not implemented");

.expr346:
 push 1232
 call istoken
 add  sp, 2
 or  al, al
 je .expr347
 push expr_14
 call error1
 add  sp, 2
;-1135     if (istoken(T_DIVASS  )) error1("not implemented");

.expr347:
 push 1233
 call istoken
 add  sp, 2
 or  al, al
 je .expr348
 push expr_15
 call error1
 add  sp, 2
;-1136 

;-1137     if (istoken('=')) {

.expr348:
 push 61
 call istoken
 add  sp, 2
 or  al, al
 je .expr349
;-1138         expr();

 call expr
;-1139         doassign(mode, id1, ixarr, ixconst);

 push word [bp-8]
 push word [bp-6]
 push word [bp-4]
 push word [bp-2]
 call doassign
 add  sp, 8
;-1140         goto e1;

 jmp .e1
;-1141         }

;-1142     dovar1(mode, "mov", ixarr, id1);

.expr349:
 push word [bp-4]
 push word [bp-6]
 push expr_16
 push word [bp-2]
 call dovar1
 add  sp, 8
;-1143 

;-1144 e1:      if (istoken('+')) rterm("add");

.e1:
 push 43
 call istoken
 add  sp, 2
 or  al, al
 je .expr350
 push expr_17
 call rterm
 add  sp, 2
;-1145     else if (istoken('-')) rterm("sub");

 jmp .expr351
.expr350:
 push 45
 call istoken
 add  sp, 2
 or  al, al
 je .expr352
 push expr_18
 call rterm
 add  sp, 2
;-1146     else if (istoken('&')) rterm("and");

 jmp .expr353
.expr352:
 push 38
 call istoken
 add  sp, 2
 or  al, al
 je .expr354
 push expr_19
 call rterm
 add  sp, 2
;-1147     else if (istoken('|')) rterm("or" );

 jmp .expr355
.expr354:
 push 124
 call istoken
 add  sp, 2
 or  al, al
 je .expr356
 push expr_20
 call rterm
 add  sp, 2
;-1148     else if (istoken(T_LESSLESS)) rterm("shl");

 jmp .expr357
.expr356:
 push 1240
 call istoken
 add  sp, 2
 or  al, al
 je .expr358
 push expr_21
 call rterm
 add  sp, 2
;-1149     else if (istoken(T_GREATGREAT)) rterm("shr");

 jmp .expr359
.expr358:
 push 1241
 call istoken
 add  sp, 2
 or  al, al
 je .expr360
 push expr_22
 call rterm
 add  sp, 2
;-1150     else if (istoken('*')) domul (ids);

 jmp .expr361
.expr360:
 push 42
 call istoken
 add  sp, 2
 or  al, al
 je .expr362
 push word [bp-10]
 call domul
 add  sp, 2
;-1151     else if (istoken('/')) doidiv(ids);

 jmp .expr363
.expr362:
 push 47
 call istoken
 add  sp, 2
 or  al, al
 je .expr364
 push word [bp-10]
 call doidiv
 add  sp, 2
;-1152     else if (istoken('%')) domod (ids);

 jmp .expr365
.expr364:
 push 37
 call istoken
 add  sp, 2
 or  al, al
 je .expr366
 push word [bp-10]
 call domod
 add  sp, 2
;-1153     if (isrelational()) {

.expr366:
.expr365:
.expr363:
.expr361:
.expr359:
.expr357:
.expr355:
.expr353:
.expr351:
 call isrelational
 or  al, al
 je .expr367
;-1154         rterm("cmp");

 push expr_23
 call rterm
 add  sp, 2
;-1155         cmpneg(ids);

 push word [bp-10]
 call cmpneg
 add  sp, 2
;-1156         }

;-1157     return 0;

.expr367:
 mov ax, 0
 jmp .retnexpr
;-1158 }

;-1159 

;-1160 int pexpr() {//called from if, do, while

 .retnexpr:
 LEAVE
 ret
expr_0 db "\n mov ax, ",0
expr_1 db "Array index must be number or int",0
expr_2 db "Only var allowed",0
expr_3 db "\n inc  ",0
expr_4 db "word",0
expr_5 db "byte",0
expr_6 db "Only var allowed",0
expr_7 db "\n dec  ",0
expr_8 db "word",0
expr_9 db "byte",0
expr_10 db "add",0
expr_11 db "sub",0
expr_12 db "and",0
expr_13 db "or",0
expr_14 db "not implemented",0
expr_15 db "not implemented",0
expr_16 db "mov",0
expr_17 db "add",0
expr_18 db "sub",0
expr_19 db "and",0
expr_20 db "or",0
expr_21 db "shl",0
expr_22 db "shr",0
expr_23 db "cmp",0
ENDP

pexpr: PROC
;-1161     expect('(');

 push 40
 call expect
 add  sp, 2
;-1162     iscmp=0;

 mov ax, 0
 mov word [iscmp], ax
;-1163     if (token==T_NAME) {

 mov ax, [token]
 cmp ax, 256
 jne .pexpr368
;-1164         ireg1=checkreg();

 call checkreg
 mov word [ireg1], ax
;-1165         if (ireg1) {

 mov ax, [ireg1]
 or  al, al
 je .pexpr369
;-1166             doreg1(1);

 push 1
 call doreg1
 add  sp, 2
;-1167             return;

 jmp .retnpexpr
;-1168             }

;-1169         }

.pexpr369:
;-1170 

;-1171     expr();

.pexpr368:
 call expr
;-1172     if (iscmp==0) printstring("\n or  al, al\n je .");

 mov ax, [iscmp]
 cmp ax, 0
 jne .pexpr370
 push pexpr_0
 call printstring
 add  sp, 2
;-1173     printstring(fname);

.pexpr370:
 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1174     expect(')');

 push 41
 call expect
 add  sp, 2
;-1175 }

;-1176 

;-1177 

;-1178 int prlabel(int n) {

 .retnpexpr:
 ret
pexpr_0 db "\n or  al, al\n je .",0
ENDP

prlabel: PROC
;-1179     printstring("\n.");

;Function : prlabel, Number local Var: 1
; # type sign width local variables
;101 var sign word n = bp+4;
 ENTER  0,0
 push prlabel_0
 call printstring
 add  sp, 2
;-1180     printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1181     printunsigned(n);

 push word [bp+4]
 call printunsigned
 add  sp, 2
;-1182     prc(':');

 push 58
 call prc
 add  sp, 2
;-1183 }

;-1184 int prjump (int n) {

 LEAVE
 ret
prlabel_0 db "\n.",0
ENDP

prjump: PROC
;-1185     printstring("\n jmp .");

;Function : prjump, Number local Var: 1
; # type sign width local variables
;101 var sign word n = bp+4;
 ENTER  0,0
 push prjump_0
 call printstring
 add  sp, 2
;-1186     printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1187     printunsigned(n);

 push word [bp+4]
 call printunsigned
 add  sp, 2
;-1188 }

;-1189 

;-1190 int stmt() {

 LEAVE
 ret
prjump_0 db "\n jmp .",0
ENDP

stmt: PROC
;-1191     int c; char cha;

;-1192     int jdest; int tst; int jtemp;

;-1193     if(istoken('{')) {

;Function : stmt, Number local Var: 5
; # type sign width local variables
;101 var sign word c = bp-2
;102 var sign byte cha = bp-4
;103 var sign word jdest = bp-6
;104 var sign word tst = bp-8
;105 var sign word jtemp = bp-10;
 ENTER  10,0
 push 123
 call istoken
 add  sp, 2
 or  al, al
 je .stmt371
;-1194         while(istoken('}')==0) stmt();

.stmt372:
 push 125
 call istoken
 add  sp, 2
 cmp ax, 0
 jne .stmt373
 call stmt
;-1195         }

 jmp .stmt372
.stmt373:
;-1196     else if(istoken(T_IF)) {

 jmp .stmt374
.stmt371:
 push 513
 call istoken
 add  sp, 2
 or  al, al
 je .stmt375
;-1197         pexpr();

 call pexpr
;-1198         nlabel++;

 inc  word[nlabel]
;-1199         jdest=nlabel;

 mov ax, [nlabel]
 mov [bp-6], ax
;-1200         printinteger(jdest);

 push word [bp-6]
 call printinteger
 add  sp, 2
;-1201         stmt();

 call stmt
;-1202         if (istoken(T_ELSE)) {

 push 514
 call istoken
 add  sp, 2
 or  al, al
 je .stmt376
;-1203             nlabel++;

 inc  word[nlabel]
;-1204             tst=nlabel;

 mov ax, [nlabel]
 mov [bp-8], ax
;-1205             prjump(tst);

 push word [bp-8]
 call prjump
 add  sp, 2
;-1206             prlabel(jdest);

 push word [bp-6]
 call prlabel
 add  sp, 2
;-1207             stmt();

 call stmt
;-1208             prlabel(tst);

 push word [bp-8]
 call prlabel
 add  sp, 2
;-1209         }

;-1210         else prlabel(jdest);

 jmp .stmt377
.stmt376:
 push word [bp-6]
 call prlabel
 add  sp, 2
;-1211     }

.stmt377:
;-1212     else if(istoken(T_DO)) {

 jmp .stmt378
.stmt375:
 push 516
 call istoken
 add  sp, 2
 or  al, al
 je .stmt379
;-1213         nlabel++;

 inc  word[nlabel]
;-1214         jdest=nlabel;

 mov ax, [nlabel]
 mov [bp-6], ax
;-1215         prlabel(jdest);

 push word [bp-6]
 call prlabel
 add  sp, 2
;-1216         stmt();

 call stmt
;-1217         expect(T_WHILE);

 push 515
 call expect
 add  sp, 2
;-1218         pexpr();

 call pexpr
;-1219         nlabel++;

 inc  word[nlabel]
;-1220         jtemp=nlabel;

 mov ax, [nlabel]
 mov [bp-10], ax
;-1221         printinteger(jtemp);

 push word [bp-10]
 call printinteger
 add  sp, 2
;-1222         prjump(jdest);

 push word [bp-6]
 call prjump
 add  sp, 2
;-1223          prlabel(jtemp);

 push word [bp-10]
 call prlabel
 add  sp, 2
;-1224     }

;-1225     else if(istoken(T_WHILE)) {

 jmp .stmt380
.stmt379:
 push 515
 call istoken
 add  sp, 2
 or  al, al
 je .stmt381
;-1226         nlabel++;

 inc  word[nlabel]
;-1227         jdest=nlabel;

 mov ax, [nlabel]
 mov [bp-6], ax
;-1228         prlabel(jdest);

 push word [bp-6]
 call prlabel
 add  sp, 2
;-1229         pexpr();

 call pexpr
;-1230         nlabel++;

 inc  word[nlabel]
;-1231         tst=nlabel;

 mov ax, [nlabel]
 mov [bp-8], ax
;-1232         printinteger(tst);

 push word [bp-8]
 call printinteger
 add  sp, 2
;-1233         stmt();

 call stmt
;-1234         prjump(jdest);

 push word [bp-6]
 call prjump
 add  sp, 2
;-1235         prlabel(tst);

 push word [bp-8]
 call prlabel
 add  sp, 2
;-1236     }

;-1237     else if(istoken(T_GOTO))  {

 jmp .stmt382
.stmt381:
 push 521
 call istoken
 add  sp, 2
 or  al, al
 je .stmt383
;-1238         printstring("\n jmp .");

 push stmt_0
 call printstring
 add  sp, 2
;-1239         name1();

 call name1
;-1240         printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-1241         expect(';');

 push 59
 call expect
 add  sp, 2
;-1242     }

;-1243     else if(token==T_ASM)     {

 jmp .stmt384
.stmt383:
 mov ax, [token]
 cmp ax, 518
 jne .stmt385
;-1244       printstring("\n");

 push stmt_1
 call printstring
 add  sp, 2
;-1245       c=next();

 call next
 mov [bp-2], ax
;-1246       while(c != '\n') {

.stmt386:
 mov ax, [bp-2]
 cmp ax, 10
 je  .stmt387
;-1247         prc(c);

 push word [bp-2]
 call prc
 add  sp, 2
;-1248         c=next();

 call next
 mov [bp-2], ax
;-1249         };

 jmp .stmt386
.stmt387:
;-1250         token=getlex();

 call getlex
 mov word [token], ax
;-1251     }

;-1252     else if(token==T_ASMDIRECT)     {

 jmp .stmt388
.stmt385:
 mov ax, [token]
 cmp ax, 525
 jne .stmt389
;-1253       printstring("\n");

 push stmt_2
 call printstring
 add  sp, 2
;-1254       printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-1255       c=next();

 call next
 mov [bp-2], ax
;-1256       while(c != '\n') {

.stmt390:
 mov ax, [bp-2]
 cmp ax, 10
 je  .stmt391
;-1257         prc(c);

 push word [bp-2]
 call prc
 add  sp, 2
;-1258         c=next();

 call next
 mov [bp-2], ax
;-1259         };

 jmp .stmt390
.stmt391:
;-1260         token=getlex();

 call getlex
 mov word [token], ax
;-1261     }

;-1262     else if(istoken(T_ASMBLOCK)) {

 jmp .stmt392
.stmt389:
 push 519
 call istoken
 add  sp, 2
 or  al, al
 je .stmt393
;-1263         if (token== '{' )  {

 mov ax, [token]
 cmp ax, 123
 jne .stmt394
;-1264             printstring("\n"); cha=next();

 push stmt_3
 call printstring
 add  sp, 2
 call next
 mov [bp-4], al
;-1265             while(cha!= '}') {

.stmt395:
 mov al, [bp-4]
 cmp al, 125
 je  .stmt396
;-1266                 prc(cha);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-1267                 cha=next();

 call next
 mov [bp-4], al
;-1268             }

;-1269             token=getlex();

 jmp .stmt395
.stmt396:
 call getlex
 mov word [token], ax
;-1270         } else error1("Curly open expected");

 jmp .stmt397
.stmt394:
 push stmt_4
 call error1
 add  sp, 2
;-1271     }

.stmt397:
;-1272     else if(istoken(T_INTH))  {

 jmp .stmt398
.stmt393:
 push 600
 call istoken
 add  sp, 2
 or  al, al
 je .stmt399
;-1273         printstring("\n int  ");

 push stmt_5
 call printstring
 add  sp, 2
;-1274         expect(T_CONST);

 push 257
 call expect
 add  sp, 2
;-1275         printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-1276         expect(';');

 push 59
 call expect
 add  sp, 2
;-1277     }

;-1278     else if(istoken(T_EMIT)) {

 jmp .stmt400
.stmt399:
 push 520
 call istoken
 add  sp, 2
 or  al, al
 je .stmt401
;-1279       printstring("\n db ");

 push stmt_6
 call printstring
 add  sp, 2
;-1280     L1: token=getlex();

.L1:
 call getlex
 mov word [token], ax
;-1281       printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-1282       token=getlex();

 call getlex
 mov word [token], ax
;-1283       if (token== ',') {

 mov ax, [token]
 cmp ax, 44
 jne .stmt402
;-1284           prc(',');

 push 44
 call prc
 add  sp, 2
;-1285           goto L1;

 jmp .L1
;-1286       }

;-1287       expect(')');

.stmt402:
 push 41
 call expect
 add  sp, 2
;-1288     }

;-1289     else if(istoken(';'))      { }

 jmp .stmt403
.stmt401:
 push 59
 call istoken
 add  sp, 2
 or  al, al
 je .stmt404
;-1290     else if(istoken(T_RETURN)) {

 jmp .stmt405
.stmt404:
 push 512
 call istoken
 add  sp, 2
 or  al, al
 je .stmt406
;-1291         if (token!=';') expr();

 mov ax, [token]
 cmp ax, 59
 je  .stmt407
 call expr
;-1292         printstring("\n jmp .retn");

.stmt407:
 push stmt_7
 call printstring
 add  sp, 2
;-1293         printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1294         nreturn++;

 inc  word[nreturn]
;-1295         expect(';');

 push 59
 call expect
 add  sp, 2
;-1296     }

;-1297     else if(thechar==':')      {

 jmp .stmt408
.stmt406:
 mov al, [thechar]
 cmp al, 58
 jne .stmt409
;-1298         printstring("\n."); // Label

 push stmt_8
 call printstring
 add  sp, 2
;-1299         printstring(Symbol); prc(':');

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
 push 58
 call prc
 add  sp, 2
;-1300         expect(T_NAME);

 push 256
 call expect
 add  sp, 2
;-1301         expect(':');

 push 58
 call expect
 add  sp, 2
;-1302     }

;-1303     else  {expr();; expect(';'); }

 jmp .stmt410
.stmt409:
 call expr
 push 59
 call expect
 add  sp, 2
;-1304 }

.stmt410:
.stmt408:
.stmt405:
.stmt403:
.stmt400:
.stmt398:
.stmt392:
.stmt388:
.stmt384:
.stmt382:
.stmt380:
.stmt378:
.stmt374:
;-1305 

;-1306 int isvariable() {

 LEAVE
 ret
stmt_0 db "\n jmp .",0
stmt_1 db "\n",0
stmt_2 db "\n",0
stmt_3 db "\n",0
stmt_4 db "Curly open expected",0
stmt_5 db "\n int  ",0
stmt_6 db "\n db ",0
stmt_7 db "\n jmp .retn",0
stmt_8 db "\n.",0
ENDP

isvariable: PROC
;-1307     if(token==T_SIGNED)   goto v1;

 mov ax, [token]
 cmp ax, 531
 jne .isvariable411
 jmp .v1
;-1308     if(token==T_UNSIGNED) goto v1;

.isvariable411:
 mov ax, [token]
 cmp ax, 532
 jne .isvariable412
 jmp .v1
;-1309     if(token==T_CHAR)     goto v1;

.isvariable412:
 mov ax, [token]
 cmp ax, 530
 jne .isvariable413
 jmp .v1
;-1310     if(token==T_INT)      goto v1;

.isvariable413:
 mov ax, [token]
 cmp ax, 517
 jne .isvariable414
 jmp .v1
;-1311     if(token==T_LONG)     goto v1;

.isvariable414:
 mov ax, [token]
 cmp ax, 533
 jne .isvariable415
 jmp .v1
;-1312     return 0;

.isvariable415:
 mov ax, 0
 jmp .retnisvariable
;-1313 v1: return 1;

.v1:
 mov ax, 1
 jmp .retnisvariable
;-1314 }

;-1315 

;-1316 //***************************************************************

;-1317 int listvar(unsigned int i) {

 .retnisvariable:
 ret
ENDP

listvar: PROC
;-1318     unsigned int j;

;-1319     char c;

;-1320     printstring("\n;");

;Function : listvar, Number local Var: 3
; # type sign width local variables
;101 var unsg word i = bp+4
;102 var unsg word j = bp-2
;103 var sign byte c = bp-4;
 ENTER  4,0
 push listvar_0
 call printstring
 add  sp, 2
;-1321     printunsigned(i);

 push word [bp+4]
 call printunsigned
 add  sp, 2
;-1322     prc(32);

 push 32
 call prc
 add  sp, 2
;-1323     c=GType [i];

 mov bx, [bp+4]
 mov al, [GType + bx]
 mov [bp-4], al
;-1324     if(c=='V')printstring("var ");

 mov al, [bp-4]
 cmp al, 86
 jne .listvar416
 push listvar_1
 call printstring
 add  sp, 2
;-1325     if(c=='*')printstring("ptr ");

.listvar416:
 mov al, [bp-4]
 cmp al, 42
 jne .listvar417
 push listvar_2
 call printstring
 add  sp, 2
;-1326     if(c=='&')printstring("arr ");

.listvar417:
 mov al, [bp-4]
 cmp al, 38
 jne .listvar418
 push listvar_3
 call printstring
 add  sp, 2
;-1327     if(c=='#')printstring("def ");

.listvar418:
 mov al, [bp-4]
 cmp al, 35
 jne .listvar419
 push listvar_4
 call printstring
 add  sp, 2
;-1328     c=GSign [i];

.listvar419:
 mov bx, [bp+4]
 mov al, [GSign + bx]
 mov [bp-4], al
;-1329     if(c=='S')printstring("sign ");

 mov al, [bp-4]
 cmp al, 83
 jne .listvar420
 push listvar_5
 call printstring
 add  sp, 2
;-1330     if(c=='U')printstring("unsg ");

.listvar420:
 mov al, [bp-4]
 cmp al, 85
 jne .listvar421
 push listvar_6
 call printstring
 add  sp, 2
;-1331     c=GWidth[i];

.listvar421:
 mov bx, [bp+4]
 mov al, [GWidth + bx]
 mov [bp-4], al
;-1332     if(c== 0)printstring("NULL " );

 mov al, [bp-4]
 cmp al, 0
 jne .listvar422
 push listvar_7
 call printstring
 add  sp, 2
;-1333     if(c== 1)printstring("byte " );

.listvar422:
 mov al, [bp-4]
 cmp al, 1
 jne .listvar423
 push listvar_8
 call printstring
 add  sp, 2
;-1334     if(c== 2)printstring("word " );

.listvar423:
 mov al, [bp-4]
 cmp al, 2
 jne .listvar424
 push listvar_9
 call printstring
 add  sp, 2
;-1335     if(c== 4)printstring("long " );

.listvar424:
 mov al, [bp-4]
 cmp al, 4
 jne .listvar425
 push listvar_10
 call printstring
 add  sp, 2
;-1336     pt=getVarName(i);

.listvar425:
 push word [bp+4]
 call getVarName
 add  sp, 2
 mov word [pt], ax
;-1337 //    j=i*32;

;-1338 //    pt=&GNameField + j;

;-1339     printstring(pt);

 push word [pt]
 call printstring
 add  sp, 2
;-1340     if(GType[i]=='#') {

 mov bx, [bp+4]
 mov al, [GType + bx]
 cmp al, 35
 jne .listvar426
;-1341         prc('=');

 push 61
 call prc
 add  sp, 2
;-1342         j=GData[i];

 mov bx, [bp+4]
 shl bx, 1
 mov ax, [GData + bx]
 mov [bp-2], ax
;-1343         printunsigned(j);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1344     }

;-1345     if(GType[i]=='&') {

.listvar426:
 mov bx, [bp+4]
 mov al, [GType + bx]
 cmp al, 38
 jne .listvar427
;-1346         prc('[');

 push 91
 call prc
 add  sp, 2
;-1347         j=GData[i];

 mov bx, [bp+4]
 shl bx, 1
 mov ax, [GData + bx]
 mov [bp-2], ax
;-1348         printunsigned(j);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1349         prc(']');

 push 93
 call prc
 add  sp, 2
;-1350     }

;-1351     if (i >= GTop) {

.listvar427:
 mov ax, [bp+4]
 cmp ax, [GTop] ;unsigned : 0
 jb  .listvar428
;-1352         printstring(" = bp");

 push listvar_11
 call printstring
 add  sp, 2
;-1353         j=GData[i];

 mov bx, [bp+4]
 shl bx, 1
 mov ax, [GData + bx]
 mov [bp-2], ax
;-1354         if (j > 0) prc('+');

 mov ax, [bp-2]
 cmp ax, 0
 jle .listvar429
 push 43
 call prc
 add  sp, 2
;-1355         printinteger(j);

.listvar429:
 push word [bp-2]
 call printinteger
 add  sp, 2
;-1356     }

;-1357 }

.listvar428:
;-1358 

;-1359 int listproc() {

 LEAVE
 ret
listvar_0 db "\n;",0
listvar_1 db "var ",0
listvar_2 db "ptr ",0
listvar_3 db "arr ",0
listvar_4 db "def ",0
listvar_5 db "sign ",0
listvar_6 db "unsg ",0
listvar_7 db "NULL ",0
listvar_8 db "byte ",0
listvar_9 db "word ",0
listvar_10 db "long ",0
listvar_11 db " = bp",0
ENDP

listproc: PROC
;-1360     int i;

;-1361     if (LTop > GTop) {

;Function : listproc, Number local Var: 1
; # type sign width local variables
;101 var sign word i = bp-2;
 ENTER  2,0
 mov ax, [LTop]
 cmp ax, [GTop]
 jle .listproc430
;-1362         printstring("\n;Function : ");

 push listproc_0
 call printstring
 add  sp, 2
;-1363         printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1364         printstring(", Number local Var: ");

 push listproc_1
 call printstring
 add  sp, 2
;-1365         i=LTop - GTop;

 mov ax, [LTop]
 sub ax, [GTop]
 mov [bp-2], ax
;-1366         printunsigned(i);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1367         printstring("\n; # type sign width local variables");

 push listproc_2
 call printstring
 add  sp, 2
;-1368         i=GTop;

 mov ax, [GTop]
 mov [bp-2], ax
;-1369         while (i < LTop) {

.listproc431:
 mov ax, [bp-2]
 cmp ax, [LTop]
 jge .listproc432
;-1370             listvar(i);

 push word [bp-2]
 call listvar
 add  sp, 2
;-1371             i++;

 inc  word[bp-2]
;-1372         }

;-1373     }

 jmp .listproc431
.listproc432:
;-1374 }

.listproc430:
;-1375 

;-1376 int searchFunction() {

 LEAVE
 ret
listproc_0 db "\n;Function : ",0
listproc_1 db ", Number local Var: ",0
listproc_2 db "\n; # type sign width local variables",0
ENDP

searchFunction: PROC
;-1377     int FunctionIndex; char *p;

;-1378     p= &FunctionNames;

;Function : searchFunction, Number local Var: 2
; # type sign width local variables
;101 var sign word FunctionIndex = bp-2
;102 ptr sign byte p = bp-4;
 ENTER  4,0
 mov ax, FunctionNames
 mov [bp-4], ax
;-1379     FunctionIndex=1;          //0=function name not found

 mov ax, 1
 mov [bp-2], ax
;-1380     while (FunctionIndex <= FunctionMaxIx ) {

.searchFunction433:
 mov ax, [bp-2]
 cmp ax, [FunctionMaxIx]
 jg  .searchFunction434
;-1381         if (eqstr(p, Symbol)) return FunctionIndex;

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchFunction435
 mov ax, [bp-2]
 jmp .retnsearchFunction
;-1382         p = strlen(p) + p;

.searchFunction435:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax
;-1383         p++;

 inc  word[bp-4]
;-1384         FunctionIndex++;

 inc  word[bp-2]
;-1385     }

;-1386     return 0;               //no function found

 jmp .searchFunction433
.searchFunction434:
 mov ax, 0
 jmp .retnsearchFunction
;-1387 }

;-1388 

;-1389 int storeFunction() {

 .retnsearchFunction:
 LEAVE
 ret
ENDP

storeFunction: PROC
;-1390     unsigned int i;

;-1391     FunctionMaxIx++;        //leave 0 empty for function not notfound

;Function : storeFunction, Number local Var: 1
; # type sign width local variables
;101 var unsg word i = bp-2;
 ENTER  2,0
 inc  word[FunctionMaxIx]
;-1392     if (FunctionMaxIx >= FUNCMAX) error1("Function table full");

 mov ax, [FunctionMaxIx]
 cmp ax, 300 ;unsigned : 1
 jl  .storeFunction436
 push storeFunction_0
 call error1
 add  sp, 2
;-1393     FunctionNamePtr=strcpy(FunctionNamePtr, Symbol);

.storeFunction436:
 lea  ax, [Symbol]
 push ax
 push word [FunctionNamePtr]
 call strcpy
 add  sp, 4
 mov word [FunctionNamePtr], ax
;-1394     FunctionNamePtr++;      //function name is saved

 inc  word[FunctionNamePtr]
;-1395     i = FunctionNamePtr - &FunctionNames;

 mov ax, [FunctionNamePtr]
 sub ax, FunctionNames
 mov [bp-2], ax
;-1396     i += IDLENMAX;

 add  word[bp-2], 31
;-1397     if (i >= FUNCTIONNAMESMAX) error1("too many function names");

 mov ax, [bp-2]
 cmp ax, 3000 ;unsigned : 0
 jb  .storeFunction437
 push storeFunction_1
 call error1
 add  sp, 2
;-1398 

;-1399 }

.storeFunction437:
;-1400 

;-1401 int dofunc() {

 LEAVE
 ret
storeFunction_0 db "Function table full",0
storeFunction_1 db "too many function names",0
ENDP

dofunc: PROC
;-1402     int nloc; unsigned int j;int narg;

;-1403     int VarNamePtrLocalStart;

;-1404     cloc=&co;

;Function : dofunc, Number local Var: 4
; # type sign width local variables
;101 var sign word nloc = bp-2
;102 var unsg word j = bp-4
;103 var sign word narg = bp-6
;104 var sign word VarNamePtrLocalStart = bp-8;
 ENTER  8,0
 mov ax, co
 mov word [cloc], ax
;-1405     checknamelen();

 call checknamelen
;-1406     strcpy(fname, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [fname]
 push ax
 call strcpy
 add  sp, 4
;-1407     if(searchFunction()) error1("Function already defined");

 call searchFunction
 or  al, al
 je .dofunc438
 push dofunc_0
 call error1
 add  sp, 2
;-1408     storeFunction();

.dofunc438:
 call storeFunction
;-1409 

;-1410     printstring("\n\n");

 push dofunc_1
 call printstring
 add  sp, 2
;-1411     printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-1412     printstring(": PROC");

 push dofunc_2
 call printstring
 add  sp, 2
;-1413     expect('(');

 push 40
 call expect
 add  sp, 2
;-1414 //    LStart=GTop;

;-1415     LTop=GTop;

 mov ax, [GTop]
 mov word [LTop], ax
;-1416     VarNamePtrLocalStart=VarNamePtr;

 mov ax, [VarNamePtr]
 mov [bp-8], ax
;-1417 

;-1418     if (istoken(')')==0) {

 push 41
 call istoken
 add  sp, 2
 cmp ax, 0
 jne .dofunc439
;-1419         narg=2;

 mov ax, 2
 mov [bp-6], ax
;-1420         do {

.dofunc440:
;-1421             typeName();

 call typeName
;-1422             addlocal();

 call addlocal
;-1423             narg+=2;

 add  word[bp-6], 2
;-1424             GData[LTop]=narg;

 mov ax, [bp-6]
 mov bx, [LTop]
 shl bx, 1
 mov [GData+bx], ax
;-1425             if (iswidth == 4) narg+=2;

 mov al, [iswidth]
 cmp al, 4
 jne .dofunc441
 add  word[bp-6], 2
;-1426             LTop++;

.dofunc441:
 inc  word[LTop]
;-1427             }

;-1428         while (istoken(','));

 push 44
 call istoken
 add  sp, 2
 or  al, al
 je .dofunc442
 jmp .dofunc440
.dofunc442:
;-1429         expect(')');

 push 41
 call expect
 add  sp, 2
;-1430         }

;-1431 

;-1432     expect('{'); /*body*/

.dofunc439:
 push 123
 call expect
 add  sp, 2
;-1433     nloc=0;

 mov ax, 0
 mov [bp-2], ax
;-1434     nreturn=0;

 mov ax, 0
 mov word [nreturn], ax
;-1435     nconst=0;

 mov ax, 0
 mov word [nconst], ax
;-1436     while(isvariable()) {

.dofunc443:
 call isvariable
 or  al, al
 je .dofunc444
;-1437         do {

.dofunc445:
;-1438             typeName();

 call typeName
;-1439             checknamelen();

 call checknamelen
;-1440             addlocal();

 call addlocal
;-1441             nloc-=2;

 sub  word[bp-2], 2
;-1442             if (iswidth == 4) nloc-=2;

 mov al, [iswidth]
 cmp al, 4
 jne .dofunc446
 sub  word[bp-2], 2
;-1443             GData[LTop]=nloc;

.dofunc446:
 mov ax, [bp-2]
 mov bx, [LTop]
 shl bx, 1
 mov [GData+bx], ax
;-1444             if (istoken('[')){

 push 91
 call istoken
 add  sp, 2
 or  al, al
 je .dofunc447
;-1445                 istype='&';

 mov ax, 38
 mov byte [istype], al
;-1446                 GType[LTop]='&';

 mov ax, 38
 mov bx, [LTop]
 mov [GType+bx], al
;-1447                 expect(T_CONST);

 push 257
 call expect
 add  sp, 2
;-1448                 expect(']');

 push 93
 call expect
 add  sp, 2
;-1449                 nloc=nloc-lexval;

 mov ax, [bp-2]
 sub ax, [lexval]
 mov [bp-2], ax
;-1450                 nloc+=2;

 add  word[bp-2], 2
;-1451                 GData[LTop]=nloc;

 mov ax, [bp-2]
 mov bx, [LTop]
 shl bx, 1
 mov [GData+bx], ax
;-1452             }

;-1453             LTop++;

.dofunc447:
 inc  word[LTop]
;-1454         } while (istoken(','));

 push 44
 call istoken
 add  sp, 2
 or  al, al
 je .dofunc448
 jmp .dofunc445
.dofunc448:
;-1455         expect(';');

 push 59
 call expect
 add  sp, 2
;-1456     }

;-1457     listproc();

 jmp .dofunc443
.dofunc444:
 call listproc
;-1458     if (LTop>GTop){

 mov ax, [LTop]
 cmp ax, [GTop]
 jle .dofunc449
;-1459         printstring(";\n ENTER  ");

 push dofunc_3
 call printstring
 add  sp, 2
;-1460         nloc=mkneg(nloc);

 push word [bp-2]
 call mkneg
 add  sp, 2
 mov [bp-2], ax
;-1461         printunsigned (nloc);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1462         printstring(",0");

 push dofunc_4
 call printstring
 add  sp, 2
;-1463         }

;-1464 

;-1465     while(istoken('}')==0)  stmt();

.dofunc449:
.dofunc450:
 push 125
 call istoken
 add  sp, 2
 cmp ax, 0
 jne .dofunc451
 call stmt
;-1466 

;-1467     if (nreturn) {

 jmp .dofunc450
.dofunc451:
 mov ax, [nreturn]
 or  al, al
 je .dofunc452
;-1468             printstring("\n .retn");

 push dofunc_5
 call printstring
 add  sp, 2
;-1469             printstring(fname);

 lea  ax, [fname]
 push ax
 call printstring
 add  sp, 2
;-1470             prc(':');

 push 58
 call prc
 add  sp, 2
;-1471         }

;-1472     if (LTop > GTop) printstring("\n LEAVE");

.dofunc452:
 mov ax, [LTop]
 cmp ax, [GTop]
 jle .dofunc453
 push dofunc_6
 call printstring
 add  sp, 2
;-1473     printstring("\n ret");

.dofunc453:
 push dofunc_7
 call printstring
 add  sp, 2
;-1474     *cloc=0;

 mov ax, 0
 mov  bx, [cloc]
 mov  [bx], al
;-1475     printstring(co);

 lea  ax, [co]
 push ax
 call printstring
 add  sp, 2
;-1476     maxco1=strlen(co);

 lea  ax, [co]
 push ax
 call strlen
 add  sp, 2
 mov word [maxco1], ax
;-1477     if (maxco1 > maxco) maxco=maxco1;

 mov ax, [maxco1]
 cmp ax, [maxco]
 jle .dofunc454
 mov ax, [maxco1]
 mov word [maxco], ax
;-1478     printstring("\nENDP");

.dofunc454:
 push dofunc_8
 call printstring
 add  sp, 2
;-1479     VarNamePtr=VarNamePtrLocalStart;//delete local names

 mov ax, [bp-8]
 mov word [VarNamePtr], ax
;-1480 }

;-1481 

;-1482 char doglobName[IDLENMAX];

 LEAVE
 ret
dofunc_0 db "Function already defined",0
dofunc_1 db "\n\n",0
dofunc_2 db ": PROC",0
dofunc_3 db ";\n ENTER  ",0
dofunc_4 db ",0",0
dofunc_5 db "\n .retn",0
dofunc_6 db "\n LEAVE",0
dofunc_7 db "\n ret",0
dofunc_8 db "\nENDP",0
ENDP
section .bss
absolute 32599
doglobName resb 31
section .text
;-1483 int doglob() {


doglob: PROC
;-1484     int i; int j; int isstrarr;

;-1485     isstrarr=0;

;Function : doglob, Number local Var: 3
; # type sign width local variables
;102 var sign word i = bp-2
;103 var sign word j = bp-4
;104 var sign word isstrarr = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-1486     if (GTop >= VARMAX) error1("Global table full");

 mov ax, [GTop]
 cmp ax, 400 ;unsigned : 1
 jl  .doglob455
 push doglob_0
 call error1
 add  sp, 2
;-1487     if (iswidth == 0) error1("no VOID as var type");

.doglob455:
 mov al, [iswidth]
 cmp al, 0
 jne .doglob456
 push doglob_1
 call error1
 add  sp, 2
;-1488     checknamelen();

.doglob456:
 call checknamelen
;-1489     if (checkName() != 0) error1("Variable already defined");

 call checkName
 cmp al, 0
 je  .doglob457
 push doglob_2
 call error1
 add  sp, 2
;-1490     if (istoken('[')) {

.doglob457:
 push 91
 call istoken
 add  sp, 2
 or  al, al
 je .doglob458
;-1491         istype='&';

 mov ax, 38
 mov byte [istype], al
;-1492         if (istoken(T_CONST)) {

 push 257
 call istoken
 add  sp, 2
 or  al, al
 je .doglob459
;-1493             printstring("\nsection .bss\nabsolute ");

 push doglob_3
 call printstring
 add  sp, 2
;-1494             printunsigned(orgDatai);

 push word [orgDatai]
 call printunsigned
 add  sp, 2
;-1495             printstring("\n"); printstring(Symbol);

 push doglob_4
 call printstring
 add  sp, 2
 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-1496             if (iswidth==1) printstring(" resb ");

 mov al, [iswidth]
 cmp al, 1
 jne .doglob460
 push doglob_5
 call printstring
 add  sp, 2
;-1497             if (iswidth==2) printstring(" resw ");

.doglob460:
 mov al, [iswidth]
 cmp al, 2
 jne .doglob461
 push doglob_6
 call printstring
 add  sp, 2
;-1498             if (iswidth==4) printstring(" resd ");

.doglob461:
 mov al, [iswidth]
 cmp al, 4
 jne .doglob462
 push doglob_7
 call printstring
 add  sp, 2
;-1499             printunsigned(lexval);

.doglob462:
 push word [lexval]
 call printunsigned
 add  sp, 2
;-1500             printstring("\nsection .text");

 push doglob_8
 call printstring
 add  sp, 2
;-1501             orgDatai=orgDatai+lexval;

 mov ax, [orgDatai]
 add ax, [lexval]
 mov word [orgDatai], ax
;-1502             if (iswidth==2) orgDatai=orgDatai+lexval;

 mov al, [iswidth]
 cmp al, 2
 jne .doglob463
 mov ax, [orgDatai]
 add ax, [lexval]
 mov word [orgDatai], ax
;-1503             if (iswidth==4) {i= lexval * 3; orgDatai=orgDatai + i;}

.doglob463:
 mov al, [iswidth]
 cmp al, 4
 jne .doglob464
 mov ax, [lexval]
 mov bx, 3
 mul bx
 mov [bp-2], ax
 mov ax, [orgDatai]
 add ax, [bp-2]
 mov word [orgDatai], ax
;-1504             GData[GTop]=lexval;

.doglob464:
 mov ax, [lexval]
 mov bx, [GTop]
 shl bx, 1
 mov [GData+bx], ax
;-1505             expect(']');

 push 93
 call expect
 add  sp, 2
;-1506         }else {

 jmp .doglob465
.doglob459:
;-1507             expect(']');

 push 93
 call expect
 add  sp, 2
;-1508             if (iswidth != 1) error1("Only ByteArray allowed");

 mov al, [iswidth]
 cmp al, 1
 je  .doglob466
 push doglob_9
 call error1
 add  sp, 2
;-1509             printstring("\n");

.doglob466:
 push doglob_10
 call printstring
 add  sp, 2
;-1510             printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-1511             printstring(" db ");

 push doglob_11
 call printstring
 add  sp, 2
;-1512             isstrarr=1;

 mov ax, 1
 mov [bp-6], ax
;-1513             strcpy(doglobName, Symbol);//save Symbol name

 lea  ax, [Symbol]
 push ax
 lea  ax, [doglobName]
 push ax
 call strcpy
 add  sp, 4
;-1514             expect('=');

 push 61
 call expect
 add  sp, 2
;-1515             if (istoken(T_STRING)) {

 push 258
 call istoken
 add  sp, 2
 or  al, al
 je .doglob467
;-1516                 prc(34);

 push 34
 call prc
 add  sp, 2
;-1517                 prscomment(Symbol);

 lea  ax, [Symbol]
 push ax
 call prscomment
 add  sp, 2
;-1518                 prc(34);

 push 34
 call prc
 add  sp, 2
;-1519                 printstring(",0");

 push doglob_12
 call printstring
 add  sp, 2
;-1520                 i=strlen(Symbol);

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-1521                 GData[GTop]=i;

 mov ax, [bp-2]
 mov bx, [GTop]
 shl bx, 1
 mov [GData+bx], ax
;-1522                 }

;-1523             else if (istoken('{' )) {

 jmp .doglob468
.doglob467:
 push 123
 call istoken
 add  sp, 2
 or  al, al
 je .doglob469
;-1524                 i=0;

 mov ax, 0
 mov [bp-2], ax
;-1525                 do {

.doglob470:
;-1526                     if(i) prc(',');

 mov ax, [bp-2]
 or  al, al
 je .doglob471
 push 44
 call prc
 add  sp, 2
;-1527                     expect(T_CONST);

.doglob471:
 push 257
 call expect
 add  sp, 2
;-1528                     printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-1529                     i=1;

 mov ax, 1
 mov [bp-2], ax
;-1530                     }

;-1531                     while (istoken(','));

 push 44
 call istoken
 add  sp, 2
 or  al, al
 je .doglob472
 jmp .doglob470
.doglob472:
;-1532                 expect('}');

 push 125
 call expect
 add  sp, 2
;-1533             }

;-1534         else error1("String or number array expected");

 jmp .doglob473
.doglob469:
 push doglob_13
 call error1
 add  sp, 2
;-1535         };

.doglob473:
.doglob468:
.doglob465:
;-1536     }else { //expect('=');

 jmp .doglob474
.doglob458:
;-1537         printstring("\n");

 push doglob_14
 call printstring
 add  sp, 2
;-1538         printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-1539         if (istype=='*') printstring(" dw ");

 mov al, [istype]
 cmp al, 42
 jne .doglob475
 push doglob_15
 call printstring
 add  sp, 2
;-1540         else {

 jmp .doglob476
.doglob475:
;-1541             if      (iswidth==1) printstring(" db ");

 mov al, [iswidth]
 cmp al, 1
 jne .doglob477
 push doglob_16
 call printstring
 add  sp, 2
;-1542             else if (iswidth==2) printstring(" dw ");

 jmp .doglob478
.doglob477:
 mov al, [iswidth]
 cmp al, 2
 jne .doglob479
 push doglob_17
 call printstring
 add  sp, 2
;-1543             else                 printstring(" dd ");

 jmp .doglob480
.doglob479:
 push doglob_18
 call printstring
 add  sp, 2
;-1544         }

.doglob480:
.doglob478:
;-1545     if(istoken('-')) prc('-');

.doglob476:
 push 45
 call istoken
 add  sp, 2
 or  al, al
 je .doglob481
 push 45
 call prc
 add  sp, 2
;-1546     if (istoken('=')) {

.doglob481:
 push 61
 call istoken
 add  sp, 2
 or  al, al
 je .doglob482
;-1547         expect(T_CONST);

 push 257
 call expect
 add  sp, 2
;-1548         printunsigned(lexval);

 push word [lexval]
 call printunsigned
 add  sp, 2
;-1549         }else printunsigned(0);

 jmp .doglob483
.doglob482:
 push 0
 call printunsigned
 add  sp, 2
;-1550     }

.doglob483:
;-1551     GSign[GTop]=issign;

.doglob474:
 mov al, [issign]
 mov bx, [GTop]
 mov [GSign+bx], al
;-1552     GWidth[GTop]=iswidth;

 mov al, [iswidth]
 mov bx, [GTop]
 mov [GWidth+bx], al
;-1553     GType[GTop]=istype;

 mov al, [istype]
 mov bx, [GTop]
 mov [GType+bx], al
;-1554     pt=getVarName(GTop);

 push word [GTop]
 call getVarName
 add  sp, 2
 mov word [pt], ax
;-1555     if (isstrarr) strcpy(pt, doglobName);

 mov ax, [bp-6]
 or  al, al
 je .doglob484
 lea  ax, [doglobName]
 push ax
 push word [pt]
 call strcpy
 add  sp, 4
;-1556         else strcpy(pt, Symbol);

 jmp .doglob485
.doglob484:
 lea  ax, [Symbol]
 push ax
 push word [pt]
 call strcpy
 add  sp, 4
;-1557 	if (isstrarr) strcpy(Symbol, doglobName);

.doglob485:
 mov ax, [bp-6]
 or  al, al
 je .doglob486
 lea  ax, [doglobName]
 push ax
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-1558 	storeVarName();

.doglob486:
 call storeVarName
;-1559     GTop++;

 inc  word[GTop]
;-1560     expect(';');

 push 59
 call expect
 add  sp, 2
;-1561 }

;-1562 

;-1563 int dodefine() {

 LEAVE
 ret
doglob_0 db "Global table full",0
doglob_1 db "no VOID as var type",0
doglob_2 db "Variable already defined",0
doglob_3 db "\nsection .bss\nabsolute ",0
doglob_4 db "\n",0
doglob_5 db " resb ",0
doglob_6 db " resw ",0
doglob_7 db " resd ",0
doglob_8 db "\nsection .text",0
doglob_9 db "Only ByteArray allowed",0
doglob_10 db "\n",0
doglob_11 db " db ",0
doglob_12 db ",0",0
doglob_13 db "String or number array expected",0
doglob_14 db "\n",0
doglob_15 db " dw ",0
doglob_16 db " db ",0
doglob_17 db " dw ",0
doglob_18 db " dd ",0
ENDP

dodefine: PROC
;-1564     expect(T_NAME);

 push 256
 call expect
 add  sp, 2
;-1565     if (token==T_CONST) {

 mov ax, [token]
 cmp ax, 257
 jne .dodefine487
;-1566         if (GTop >= VARMAX) error1("global table (define) full");

 mov ax, [GTop]
 cmp ax, 400 ;unsigned : 1
 jl  .dodefine488
 push dodefine_0
 call error1
 add  sp, 2
;-1567         checknamelen();

.dodefine488:
 call checknamelen
;-1568         if (checkName() != 0) error1("#Define var already defined");

 call checkName
 cmp ax, 0
 je  .dodefine489
 push dodefine_1
 call error1
 add  sp, 2
;-1569         if (eqstr(Symbol, "ORGDATA")) {

.dodefine489:
 push dodefine_2
 lea  ax, [Symbol]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .dodefine490
;-1570             orgDataOriginal=lexval;

 mov ax, [lexval]
 mov word [orgDataOriginal], ax
;-1571             orgDatai=lexval;

 mov ax, [lexval]
 mov word [orgDatai], ax
;-1572             expect(T_CONST);

 push 257
 call expect
 add  sp, 2
;-1573             return;

 jmp .retndodefine
;-1574         }

;-1575         GSign [GTop]='U';

.dodefine490:
 mov ax, 85
 mov bx, [GTop]
 mov [GSign+bx], al
;-1576         GWidth[GTop]=1;

 mov ax, 1
 mov bx, [GTop]
 mov [GWidth+bx], al
;-1577         GType [GTop]='#';

 mov ax, 35
 mov bx, [GTop]
 mov [GType+bx], al
;-1578         pt=getVarName(GTop);

 push word [GTop]
 call getVarName
 add  sp, 2
 mov word [pt], ax
;-1579         strcpy(pt, Symbol);

 lea  ax, [Symbol]
 push ax
 push word [pt]
 call strcpy
 add  sp, 4
;-1580         storeVarName();

 call storeVarName
;-1581         GData[GTop]=lexval;

 mov ax, [lexval]
 mov bx, [GTop]
 shl bx, 1
 mov [GData+bx], ax
;-1582         expect(T_CONST);

 push 257
 call expect
 add  sp, 2
;-1583         GTop++;

 inc  word[GTop]
;-1584     }

;-1585 }

.dodefine487:
;-1586 

;-1587 int parse() {

 .retndodefine:
 ret
dodefine_0 db "global table (define) full",0
dodefine_1 db "#Define var already defined",0
dodefine_2 db "ORGDATA",0
ENDP

parse: PROC
;-1588     token=getlex();

 call getlex
 mov word [token], ax
;-1589     do {

.parse491:
;-1590         if (token <= 0) return 1;

 mov ax, [token]
 cmp ax, 0
 jg  .parse492
 mov ax, 1
 jmp .retnparse
;-1591         if (istoken('#')) {

.parse492:
 push 35
 call istoken
 add  sp, 2
 or  al, al
 je .parse493
;-1592              if (istoken(T_DEFINE))  dodefine();

 push 511
 call istoken
 add  sp, 2
 or  al, al
 je .parse494
 call dodefine
;-1593              else error1("define expected");

 jmp .parse495
.parse494:
 push parse_0
 call error1
 add  sp, 2
;-1594         }

.parse495:
;-1595     else{

 jmp .parse496
.parse493:
;-1596         typeName();

 call typeName
;-1597         if (token=='(') dofunc();

 mov ax, [token]
 cmp ax, 40
 jne .parse497
 call dofunc
;-1598         else doglob(); }

 jmp .parse498
.parse497:
 call doglob
.parse498:
;-1599     } while(1);

.parse496:
 mov ax, 1
 or  al, al
 je .parse499
 jmp .parse491
.parse499:
;-1600 }

;-1601 

;-1602 char *arglen=0x80; char *argv=0x82;

 .retnparse:
 ret
parse_0 db "define expected",0
ENDP
arglen dw 128
argv dw 130
;-1603 int getarguments() {


getarguments: PROC
;-1604     int arglen1; unsigned int i; char *c;

;-1605     isPrint=1;

;Function : getarguments, Number local Var: 3
; # type sign width local variables
;104 var sign word arglen1 = bp-2
;105 var unsg word i = bp-4
;106 ptr sign byte c = bp-6;
 ENTER  6,0
 mov ax, 1
 mov byte [isPrint], al
;-1606     arglen1=*arglen;

 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax
;-1607     if (arglen1 == 0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarguments500
;-1608         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-1609         cputs(" Usage: A.COM in_file[.C]: ");

 push getarguments_0
 call cputs
 add  sp, 2
;-1610         exitR(3);

 push 3
 call exitR
 add  sp, 2
;-1611         }

;-1612     i=arglen1+129;

.getarguments500:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax
;-1613     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
;-1614     arglen1--;

 dec  word[bp-2]
;-1615     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2
;-1616     strcpy(namein, argv);

 push word [argv]
 lea  ax, [namein]
 push ax
 call strcpy
 add  sp, 4
;-1617     if (instr1(namein, '.') == 0) strcat(namein, ".C");

 push 46
 lea  ax, [namein]
 push ax
 call instr1
 add  sp, 4
 cmp ax, 0
 jne .getarguments501
 push getarguments_1
 lea  ax, [namein]
 push ax
 call strcat
 add  sp, 4
;-1618     strcpy(namelst, namein);

.getarguments501:
 lea  ax, [namein]
 push ax
 lea  ax, [namelst]
 push ax
 call strcpy
 add  sp, 4
;-1619     i=strlen(namelst);

 lea  ax, [namelst]
 push ax
 call strlen
 add  sp, 2
 mov [bp-4], ax
;-1620     i--;

 dec  word[bp-4]
;-1621     c=&namelst+i;

 mov ax, namelst
 add ax, [bp-4]
 mov [bp-6], ax
;-1622     *c='S';

 mov ax, 83
 mov  bx, [bp-6]
 mov  [bx], al
;-1623 }

;-1624 int openfiles() {

 LEAVE
 ret
getarguments_0 db " Usage: A.COM in_file[.C]: ",0
getarguments_1 db ".C",0
ENDP

openfiles: PROC
;-1625     fdin=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [fdin], ax
;-1626     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .openfiles502
;-1627         cputs("Source file missing (.C): ");

 push openfiles_0
 call cputs
 add  sp, 2
;-1628         cputs(namein);

 lea  ax, [namein]
 push ax
 call cputs
 add  sp, 2
;-1629         exitR(1);

 push 1
 call exitR
 add  sp, 2
;-1630         }

;-1631     fdout=creatR(namelst);

.openfiles502:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [fdout], ax
;-1632     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .openfiles503
;-1633         cputs("list file not creatable: ");

 push openfiles_1
 call cputs
 add  sp, 2
;-1634         cputs(namelst);

 lea  ax, [namelst]
 push ax
 call cputs
 add  sp, 2
;-1635         exitR(2);

 push 2
 call exitR
 add  sp, 2
;-1636         }

;-1637     printstring(";");

.openfiles503:
 push openfiles_2
 call printstring
 add  sp, 2
;-1638     printstring(Version1);

 lea  ax, [Version1]
 push ax
 call printstring
 add  sp, 2
;-1639     printstring(", Input: "); printstring(namein);

 push openfiles_3
 call printstring
 add  sp, 2
 lea  ax, [namein]
 push ax
 call printstring
 add  sp, 2
;-1640     printstring(", Output: "); printstring(namelst);

 push openfiles_4
 call printstring
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call printstring
 add  sp, 2
;-1641 }

;-1642 

;-1643 int epilog() {

 ret
openfiles_0 db "Source file missing (.C): ",0
openfiles_1 db "list file not creatable: ",0
openfiles_2 db ";",0
openfiles_3 db ", Input: ",0
openfiles_4 db ", Output: ",0
ENDP

epilog: PROC
;-1644     unsigned int i;

;-1645     isPrint=1;

;Function : epilog, Number local Var: 1
; # type sign width local variables
;104 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, 1
 mov byte [isPrint], al
;-1646     GTop--;

 dec  word[GTop]
;-1647     printstring("\n;Glob. variables:"); printunsigned(GTop);

 push epilog_0
 call printstring
 add  sp, 2
 push word [GTop]
 call printunsigned
 add  sp, 2
;-1648     printstring(" (");                  printunsigned(VARMAX);

 push epilog_1
 call printstring
 add  sp, 2
 push 400
 call printunsigned
 add  sp, 2
;-1649     i = VarNamePtr - &VarNames;

 mov ax, [VarNamePtr]
 sub ax, VarNames
 mov [bp-2], ax
;-1650     printstring("):");                  printunsigned(i);

 push epilog_2
 call printstring
 add  sp, 2
 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1651     printstring(" (");					printunsigned(VARNAMESMAX);

 push epilog_3
 call printstring
 add  sp, 2
 push 4000
 call printunsigned
 add  sp, 2
;-1652     printstring("), Functions:");       printunsigned(FunctionMaxIx);

 push epilog_4
 call printstring
 add  sp, 2
 push word [FunctionMaxIx]
 call printunsigned
 add  sp, 2
;-1653     printstring(" (");                  printunsigned(FUNCMAX);

 push epilog_5
 call printstring
 add  sp, 2
 push 300
 call printunsigned
 add  sp, 2
;-1654     i = FunctionNamePtr - &FunctionNames;

 mov ax, [FunctionNamePtr]
 sub ax, FunctionNames
 mov [bp-2], ax
;-1655     printstring("):");                  printunsigned(i);

 push epilog_6
 call printstring
 add  sp, 2
 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1656     printstring(" (");					printunsigned(FUNCTIONNAMESMAX);

 push epilog_7
 call printstring
 add  sp, 2
 push 3000
 call printunsigned
 add  sp, 2
;-1657     printstring(")\n;Lines:");          printunsigned(lineno);

 push epilog_8
 call printstring
 add  sp, 2
 push word [lineno]
 call printunsigned
 add  sp, 2
;-1658     printstring(", Constant: ");        printunsigned(maxco);

 push epilog_9
 call printstring
 add  sp, 2
 push word [maxco]
 call printunsigned
 add  sp, 2
;-1659     printstring(" (");                  printunsigned(COMAX);

 push epilog_10
 call printstring
 add  sp, 2
 push 3000
 call printunsigned
 add  sp, 2
;-1660     i = COMAX;

 mov ax, 3000
 mov [bp-2], ax
;-1661     i = i - maxco;

 mov ax, [bp-2]
 sub ax, [maxco]
 mov [bp-2], ax
;-1662     if (i<=1000)printstring("\n ** Warning ** constant area too small");

 mov ax, [bp-2]
 cmp ax, 1000
 ja  .epilog504
 push epilog_11
 call printstring
 add  sp, 2
;-1663     printstring("), stacksize: ");

.epilog504:
 push epilog_12
 call printstring
 add  sp, 2
;-1664     i=65535;

 mov ax, 65535
 mov [bp-2], ax
;-1665     i=i-orgDatai;

 mov ax, [bp-2]
 sub ax, [orgDatai]
 mov [bp-2], ax
;-1666     printunsigned(i);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-1667     if (i <= 1000) printstring("\n *** Warning *** Stack too small");

 mov ax, [bp-2]
 cmp ax, 1000
 ja  .epilog505
 push epilog_13
 call printstring
 add  sp, 2
;-1668 

;-1669 }

.epilog505:
;-1670 

;-1671 int main() {

 LEAVE
 ret
epilog_0 db "\n;Glob. variables:",0
epilog_1 db " (",0
epilog_2 db "):",0
epilog_3 db " (",0
epilog_4 db "), Functions:",0
epilog_5 db " (",0
epilog_6 db "):",0
epilog_7 db " (",0
epilog_8 db ")\n;Lines:",0
epilog_9 db ", Constant: ",0
epilog_10 db " (",0
epilog_11 db "\n ** Warning ** constant area too small",0
epilog_12 db "), stacksize: ",0
epilog_13 db "\n *** Warning *** Stack too small",0
ENDP

main: PROC
;-1672     getarguments();

 call getarguments
;-1673     openfiles();

 call openfiles
;-1674     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al
;-1675     printstring("\norg  256 \njmp main");

 push main_0
 call printstring
 add  sp, 2
;-1676 

;-1677 	GTop = 1;

 mov ax, 1
 mov word [GTop], ax
;-1678     VarNamePtr= &VarNames;

 mov ax, VarNames
 mov word [VarNamePtr], ax
;-1679     FunctionNamePtr= &FunctionNames;

 mov ax, FunctionNames
 mov word [FunctionNamePtr], ax
;-1680     FunctionMaxIx=0;

 mov ax, 0
 mov word [FunctionMaxIx], ax
;-1681     orgDatai=orgDataOriginal;

 mov ax, [orgDataOriginal]
 mov word [orgDatai], ax
;-1682     fgetsp=&fgetsdest;

 mov ax, fgetsdest
 mov word [fgetsp], ax
;-1683     *fgetsp=0;

 mov ax, 0
 mov  bx, [fgetsp]
 mov  [bx], al
;-1684     thechar=fgets1();

 call fgets1
 mov byte [thechar], al
;-1685 

;-1686     parse();

 call parse
;-1687 

;-1688     epilog();

 call epilog
;-1689     end1(0);

 push 0
 call end1
 add  sp, 2
;-1690 }

 ret
main_0 db "\norg  256 \njmp main",0
ENDP
;Glob. variables:103 (400):830 (4000), Functions:79 (300):634 (3000)
;Lines:1691, Constant: 688 (3000), stacksize: 32905