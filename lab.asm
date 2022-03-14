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
    call PrintString        ; получить значение А от пользователя
    push bx                 ; сохраняем значение перемнной А в стеке

    mov bx,OFFSET message2
    call PrintString        ; получить значение B от пользователя

    mov ax, bx 
    mov cx, 2               ; отложим 2 в cx под умножение

    sbb ax, 5h              ; b - 5H
    jnc M4                  ;нет переноса?
    ; --------------------------------------------------------
    ; выполнить если B < 4 и результат вычитания отрицательный
    ; --------------------------------------------------------
    neg ax                  ;в al модуль результата так как результат отрицательный

    
    mul cx                  ; умножаем на два регистр AX





    jmp M6
M4: ; --------------------------------------------------------
    ; выполнить если B >= 5 и результат вычитания положительный
    ; --------------------------------------------------------
    mul cx                  ; умножаем на два регистр AX


M6:
    mov bx, ax
    call OutString

  

    mov ax,4c00h    ; функция DOS завершения программы
    int 21h         ; завершить программу

ProgramStart   ENDP

; Подпрограмма вывода строки
; bx - смещение строки для вывода на экран
PrintString      PROC   NEAR
    mov dx, bx      ; заносим в dx смещение
    mov ah, 09      ; 09 - вывод на экран строки
    int 21h         ; генерация прерывания с номером 21h

    mov ah, 1h      ; 1h - считать символ с устройства ввода    
    int 21h         ; 

    mov dl, al      ;содержимое регистра al в регистр dl
    sub dl, 30h     ;вычитание: (dl)=(dl)-30h
    cmp dl, 9h      ;сравнить (dl) с 9h
    jle M1          ;перейти на метку M1 если dl<9h или dl=9h
    sub dl, 7h      ;вычитание: (dl)=(dl)-7h
M1: mov cl, 4h      ;пересылка 4h в регистр cl
    shl dl, cl      ;сдвиг содержимого dl на 4 разряда влево
    int 21h         ;вызов прерывания с номером 21h
    sub al,30h      ;вычитание: (dl)=(dl)-30h
    cmp al,9h       ;сравнить (al) с 9h 
    jle M2          ;перейти на метку M2 если al<9h или al=9h
    sub al,7h       ;вычитание: (al)=(al)-7h
M2: add dl,al       ;сложение: (dl)=(dl)+(al)

    mov bl, dl

    call print_endline
    ret
PrintString ENDP


; подпрограмма вывода числа в двоичном виде
; bx - число для вывода
OutString   PROC NEAR
    mov cx, 16      ; кол-во чисел для вывода
M3: mov dl, 30h     ; место под результат, 
                    ; при выводе на экран здесь будет или ноль 
                    ; с ASCII-кодом 30h или единица с ASCII-кодом 31h
    shl bx, 1       ;сдвигаем число Х на один разряд влево пока единицы, 
                    ;которые там находятся не попадут во флаг переноса (Carry Flag или CF)
    adc dl,0        ; сложение нуля с переносом, если CF=1 значит был единичный разряд и DL=31h 
                    ;если CF=0 значит в очередном разряде был ноль и DL=30h

    mov ah,2h       ; номер функции вывода символа
    int 21h
loop M3         ; если cx<>0 то cx=cx-1 и переход на метку m1
   
    call print_endline
    ret
OutString ENDP


;Процедура вывода конца строки (CR+LF)
print_endline   PROC NEAR
    push di
    mov di, OFFSET endline          ;DI = адрес строки с символами CR,LF
    push ax
    mov ah, 9                ;Функция DOS 09h - вывод строки
    xchg dx, di              ;Обмен значениями DX и DI
    int 21h                 ;Обращение к функции DOS
    xchg dx, di              ;Обмен значениями DX и DI
    pop ax
    pop di
    ret
print_endline ENDP

CODE ENDS
END ProgramStart