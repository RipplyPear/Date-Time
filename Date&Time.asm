.MODEL SMALL
.STACK 100H

.DATA
   xlat_table DB "LMMJVSD"
   
.CODE
START:
   MOV AX, @DATA   
   MOV DS, AX      

   
   MOV AH, 2Ah
   INT 21H

   ;MOV AL, 0     ;Testing pentru ziua de Duminica

   CMP AL, 0      
   JNE RESUME      
   MOV AL, 7      

RESUME:
   DEC AL
   LEA BX, xlat_table      
   XLAT                    
   SUB AL, '0'
   
   MOV BL, DH

   PUSH CX
   PUSH BX
   PUSH DX
   PUSH AX

   MOV CX, 4

DO:
   POP BX      

   ADD BX, '0'
   MOV DL, BH              
   MOV AH, 02H
   INT 21H
   MOV DL, BL              
   MOV AH, 02H
   INT 21H             
LOOP DO

   MOV AX, 4C00H           
   INT 21H
END START