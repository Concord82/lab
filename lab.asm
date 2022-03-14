.model large
DATA SEGMENT
    message1 db 'input A= $'
    message2 db 'input B= $'
    otvet    db 'c= $'
    endline  db 13,10,'$'
    bufer    db '    $'

DATA ENDS
STK SEGMENT STACK
    db 256 dup('?')
STK ENDS
CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STK
ProgramStart      PROC  NEAR
    mov ax, DATA            ; 
    mov ds,ax               ;

    mov di, OFFSET bufer

    mov bx, 0DFh
    call OutString
    
    mov bx,OFFSET message1
    call PrintString        ; ������� ���祭�� � �� ���짮��⥫�
    push bx                 ; ��࠭塞 ���祭�� ��६���� � � �⥪�

    mov bx,OFFSET message2
    call PrintString        ; ������� ���祭�� B �� ���짮��⥫�

    mov ax, bx 
    mov cx, 2               ; �⫮��� 2 � cx ��� 㬭������

    sbb ax, 5h              ; b - 5H
    jnc M4                  ;��� ��७��?
    ; --------------------------------------------------------
    ; �믮����� �᫨ B < 4 � १���� ���⠭�� ����⥫��
    ; --------------------------------------------------------
    neg ax                  ;� al ����� १���� ⠪ ��� १���� ����⥫��

    
    mul cx                  ; 㬭����� �� ��� ॣ���� AX





    jmp M6
M4: ; --------------------------------------------------------
    ; �믮����� �᫨ B >= 5 � १���� ���⠭�� ������⥫��
    ; --------------------------------------------------------
    mul cx                  ; 㬭����� �� ��� ॣ���� AX


M6:
    mov bx, ax
    call OutString

  

    mov ax,4c00h    ; �㭪�� DOS �����襭�� �ணࠬ��
    int 21h         ; �������� �ணࠬ��

ProgramStart   ENDP

; ����ணࠬ�� �뢮�� ��ப�
; bx - ᬥ饭�� ��ப� ��� �뢮�� �� �࠭
PrintString      PROC   NEAR
    mov dx, bx      ; ����ᨬ � dx ᬥ饭��
    mov ah, 09      ; 09 - �뢮� �� �࠭ ��ப�
    int 21h         ; ������� ���뢠��� � ����஬ 21h

    mov ah, 1h      ; 1h - ����� ᨬ��� � ���ன�⢠ �����    
    int 21h         ; 

    mov dl, al      ;ᮤ�ন��� ॣ���� al � ॣ���� dl
    sub dl, 30h     ;���⠭��: (dl)=(dl)-30h
    cmp dl, 9h      ;�ࠢ���� (dl) � 9h
    jle M1          ;��३� �� ���� M1 �᫨ dl<9h ��� dl=9h
    sub dl, 7h      ;���⠭��: (dl)=(dl)-7h
M1: mov cl, 4h      ;����뫪� 4h � ॣ���� cl
    shl dl, cl      ;ᤢ�� ᮤ�ন���� dl �� 4 ࠧ�鸞 �����
    int 21h         ;�맮� ���뢠��� � ����஬ 21h
    sub al,30h      ;���⠭��: (dl)=(dl)-30h
    cmp al,9h       ;�ࠢ���� (al) � 9h 
    jle M2          ;��३� �� ���� M2 �᫨ al<9h ��� al=9h
    sub al,7h       ;���⠭��: (al)=(al)-7h
M2: add dl,al       ;᫮�����: (dl)=(dl)+(al)

    mov bl, dl

    call print_endline
    ret
PrintString ENDP


; ����ணࠬ�� �뢮�� �᫠ � ����筮� ����
; bx - �᫮ ��� �뢮��
OutString   PROC NEAR
    mov cx, 16      ; ���-�� �ᥫ ��� �뢮��
M3: mov dl, 30h     ; ���� ��� १����, 
                    ; �� �뢮�� �� �࠭ ����� �㤥� ��� ���� 
                    ; � ASCII-����� 30h ��� ������ � ASCII-����� 31h
    shl bx, 1       ;ᤢ����� �᫮ � �� ���� ࠧ�� ����� ���� �������, 
                    ;����� ⠬ ��室���� �� ������� �� 䫠� ��७�� (Carry Flag ��� CF)
    adc dl,0        ; ᫮����� ��� � ��७�ᮬ, �᫨ CF=1 ����� �� ������� ࠧ�� � DL=31h 
                    ;�᫨ CF=0 ����� � ��।��� ࠧ�拉 �� ���� � DL=30h

    mov ah,2h       ; ����� �㭪樨 �뢮�� ᨬ����
    int 21h
loop M3         ; �᫨ cx<>0 � cx=cx-1 � ���室 �� ���� m1
   
    call print_endline
    ret
OutString ENDP


;��楤�� �뢮�� ���� ��ப� (CR+LF)
print_endline   PROC NEAR
    push di
    mov di, OFFSET endline          ;DI = ���� ��ப� � ᨬ������ CR,LF
    push ax
    mov ah, 9                ;�㭪�� DOS 09h - �뢮� ��ப�
    xchg dx, di              ;����� ���祭�ﬨ DX � DI
    int 21h                 ;���饭�� � �㭪樨 DOS
    xchg dx, di              ;����� ���祭�ﬨ DX � DI
    pop ax
    pop di
    ret
print_endline ENDP

CODE ENDS
END ProgramStart