.MODEL SMALL
.STACK 100H

.DATA
    ;Tabelul pentru functia XLAT alcatuit din initialele zilelor saptamanii
    xlat_table DB "LMMJVSD"
    
.CODE
START:
    MOV AX, @DATA   ;se copiaza adresa segementului de date
    MOV DS, AX      ;si se pune in DS pentru a sti de unde citim variabilele
                    ;DS indica spre segmentul de date


    ;Apelarea functiei 2Ah din INT 21h pentru a obtine ziua date despre data de azi
    ;De interes este ziua din saptamana, al carei indice va fi memorat in registrul AL
    MOV AH, 2Ah
    INT 21H

    ;MOV AL, 0     ;Testing pentru ziua de Duminica

    ;Salt conditionat pentru a modifica indicele zilei doar daca acesta este 0 (Duminica)
    CMP AL, 00      ;Comparam ziua saptamanii cu 0 (Duminica)
    JNE RESUME      ;Daca nu sunt egale, trecem mai departe

    MOV AL, 07      ;Altfel, punem valoarea 7 in AL

RESUME:
    MOV BL, AL      ;Memoram valoarea lui AL in BL, folosit ca registru auxiliar
                    ;Pentru a evita pierderea valorii din AL atunci cand se apeleaza functia 02h

    ADD AL, '0'     ;Transformam valoarea din AL in caracterul printabil echivalent
    MOV DL, AL      ;Punem valoarea lui AL in DL, pentru afisare
    MOV AH, 02H     ;Apelam functia 02H pentru a afisa caracterul din DL 
    INT 21H

    MOV DL, '='     ;Afisam un '=' intre indicele zilei si litera corespunzatoare
    MOV AH, 02H     ;Apelam functia 02H pentru a afisa caracterul din DL 
    INT 21H

    MOV AL, BL      ;AL ia valoarea de dinaintea apelarii functiei 02h
    DEC AL          ;Decrementam AL, deoarece indicii folositi sunt de la 1 la 7
                    ;Daca am lasa AL asa, atunci XLAT ne-ar pune in AL valoarea de la 
                    ;inceputul tabelului + 1, adica 'M'
                    ;Asadar, pentru corectitudine, decrementam AL

    LEA BX, xlat_table      ;Punem in BX offset-ul, adica de unde incepe tabelul
    XLAT                    ;Apelam functia XLAT
    MOV DL, AL              ;Punem valoarea lui AL in DL, pentru afisare
    MOV AH, 02H             ;Apelam functia 02H pentru a afisa caracterul din DL 
    INT 21H

    MOV AX, 4C00H           ;Apelam intrerupere DOS pentru iesirea din program
    INT 21H
END START