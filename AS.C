char Version1[]="AS.C V0.07";//BAS.BAT, AS TE, NAS.BAT
#include "DECL.C"
#include "OPTABL.C"   
#include "OPS.C"
#include "PARSE.C"
#include "HELPER.C"
#include "OUTPUT.C"
#include "MAIN.C"
#include "GENCODE.C"

int process() { 
    char c;           
    Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
    disp=imme=0;//int
    isDirect=1; //set in getMeM=0, need in WriteEA
    getTokeType();//0, DIGIT, ALNUME, NOALNUME
    OpSize=getCodeSize();//0, BYTE, WORD, DWORD
    getCodes();//set: Code1, Code2, Code3

    if (CodeType ==  1) {//1 byte opcode
        genCode8(Code1);
        return;
    }
  
    if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
        getOpL();    
        checkOpL();        
        if (Code2 <= 1) {//inc,dec
  	        if (Op == REG) {//short
                if (wflag) {genCode2(Code3, R1No); return; }
            }
        }
        if (Code2 == 5) {//imul extension?
            getTokeType();
            if (TokeType) implerror();
        }
        genCodeW(Code1);           
        writeEA(Code2);
        return;
    }
  
    if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
        check2Ops();    //setwflag not applicable
        if (R1Type != WORD) reg16error();//only r16
        if (Op2 != MEM) addrerror();//only m16 
        
        genCode8(Code1);//les,lds,lea
        if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
        Op=Op2;//set MEM for writeEA
        writeEA(R1No);           
        return;
    }

    if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
        check2Ops();    
        if (Op2 == IMM) {//second operand is imm     
            setsflag();   
            if (Op == REG) {                
                if (R1No == 0) {// acc,imm   
                    if (sflag == 0) {                        
                        c = Code1 << 3;
                        c += 4;    
                        genCodeW(c);
                        genImmediate();
                        return;
                    }
                }
            }
            //r/m, imm: 80 sign-extended,TTT,imm
            c = sflag + 0x80;   
            genCodeW(c); 
            writeEA(Code1);  
            if (sflag) genCode8(imme);
            else genImmediate();    
            return;     
        }  
        c = Code1 << 3;//r/m, r/r  
        if (Op == REG) {
            if (Op2 == MEM) {//reg, mem      
                c += 2;//add direction flag
                genCodeW(c);
                Op=Op2;//set MEM for writeEA                
                writeEA(R1No);
                return;    
            }
        }
        if (Op2 == REG) {//mem,reg    reg,reg
            genCodeW(c);
            writeEA(R2No);//2. Op in reg-field
            return;            
        }          
        syntaxerror();        
        return;
    }
 
    if (CodeType == 5) {//mov (movsx, movzx=51)
        check2Ops();    
/*    prs("\n Op:"); printhex8a(Op);
    prs(", Op2:"); printhex8a(Op2);
    prs(", R1No:"); printhex8a(R1No);
    prs(", R2No:"); printhex8a(R2No);   */  
        if (Op2 == ADR) {
            imme=disp;
            Op2=IMM;//continue with IMM    
        }  
        if (Op2 == IMM) {// r,i     
            if (Op == REG) {               
                c = wflag << 3;   
                c += 0xB0;                                     
                genCode2(c, R1No);   
                genImmediate();
                return; 
            }
            if (Op == MEM) {// m,i  
                genCodeW(0xC6);
                writeEA( 0 );
                genImmediate();
                return;  
            }
            regmemerror();
            return;
        }      
        if (R1Type == SEGREG) ChangeDirection();//sreg,rm
        if (R2Type == SEGREG) {//rm,sreg
            if (OpSize != WORD) reg16error();
                genCode2(0x8C, dflag);
                writeEA(R2No);
                return;   
        }          
        if (Op2 == MEM) {//acc, moffs16
            if (Op == REG) {
                if (R1No == 0) {
                    if (isDirect) {
                        genCodeW(0xA0);
                        genCode16(disp);
                        return;   
                    }   
                }   
            }   
        } 
        if (Op == MEM) {//moffs16, acc
            if (Op2 == REG) {
                if (R2No == 0) {
                    if (isDirect) {
                        genCodeW(0xA2);
                        genCode16(disp);
                        return;   
                    }   
                }   
            }
        
        }
        if (Op2 == REG) {//rm, r
            genCodeW(0x88);     
            writeEA(R2No);
            return;
        }
        if (Op2 == MEM) {//r, m
            if (Op == REG) {
                ChangeDirection();
                genCodeW(0x8A);
                writeEA(R2No);
                return;   
            }   
        }         
        syntaxerror();
        return;
    }    
    
    if (CodeType == 6) {//Jcc       
        if (TokeType == ALNUME) {
            LabelIx=searchLabel();
            if (LabelIx > 0) {
                disp=LabelAddr[LabelIx];
                disp = disp - PC;   
                disp = disp - Origin;
                if (checkConstSize(disp) ) {
                    genCode2(Code1, 0x70);//short       
                    disp -= 2; 
                    genCode8(disp);   
                } else {     
                    genCode8(0x0F);
                    genCode2(Code1, 0x80);//near       
                    disp -= 4; 
                    genCode16(disp);                       
                }    
            }
            else {//jump forward, near only
                genCode8(0x0F);
                genCode2(Code1, 0x80);
                genCode16(0);
                PrintRA='*';
                storeJmpCall();
            }   
        return; 
        }  
    }

    if (CodeType == 7) {//jmp, call
        if (TokeType == ALNUME) {
            LabelIx=searchLabel();
            if (LabelIx > 0) {
                disp=LabelAddr[LabelIx];
                disp = disp - PC;   
                disp = disp - Origin;
                if (checkConstSize(disp) ) {
                    if (Code1 == 0xE9) {//jmp only
                        genCode8(0xEB);//short       
                        disp -= 2; 
                        genCode8(disp);
                    } 
                    else {     
                        genCode8(Code1);//near    
                        disp -= 3; 
                        genCode16(disp);                       
                    }    
                } 
                else {     
                    genCode8(Code1);//near    
                    disp -= 3; 
                    genCode16(disp);                       
                }    
            }
            else {//jump forward, near only
                genCode8(Code1);
                genCode16(0);
                PrintRA='*';
                storeJmpCall();
            }   
        return; 
        }
    }
    
    if (CodeType ==  8) {//ret,retf
        if (TokeType == DIGIT) {
            genCode8(Code2);
            genCode16(SymbolInt);
            return;
        }
        genCode8(Code1); 
        return;
    }
       
    if (CodeType == 9) {//push, pop  
        getOpL();
        if (Code1 == 0x50) {//push only
            if (Op == IMM) {//push imm8,16
                setsflag();
                genCode2(0x68, sflag);     
                if (sflag) genCode8 (imme);
                else       genCode16(imme);    
                return;   
            }   
        }
        if (R1Type == SEGREG) {
            if (Code1 == 0x58) {
                if (R1No == 1) error1("pop cs not allowed");   
            }
            c = R1No <<3;
            if (R1No > 3) {//FS, GS
                c += 122;
                genCode8(0x0F);
            }
            OpCodePtr++;
            c = c + *OpCodePtr;//is Code4   
            genCode8(c);  
            return; 
        }  
        checkOpL();    
        if (R1Type == BYTE) reg16error();
        if (R1Type == WORD) {
            genCode2(Code1, R1No);
            return;   
        }                
        if (Op == MEM) {
            genCode8(Code2);
            writeEA(Code3);
            return;   
        }
        syntaxerror();
        return;        
    }
    
    if (CodeType == 12) {//int
        if (TokeType == DIGIT) {            
            genCode8(Code1);
            genCode8(SymbolInt);
            return;   
        }
    }
    
    if (CodeType == 30) {//enter i18,i8
        genCode8(0xC8);
        Op=getOp1();
        if (Op == IMM) genCode16(SymbolInt);
        else numbererror();
        need(',');
        Op=getOp1();
        if (Op == IMM) genCode8 (SymbolInt);
        else numbererror();           
        return;
    }
       
    if (CodeType==101) {// ORG nn
        if (TokeType != DIGIT) numbererror();
        Origin=SymbolInt;
        return;
    }
    error1("Command not implemented or syntax error");
}    
           