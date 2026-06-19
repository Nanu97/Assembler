;----------------------------------------------------------------------------
;                       CODIGO FUENTE DEL TA-TE-TI
;----------------------------------------------------------------------------

.8086
.model small
.stack 100h
.data

    ;FILA Y COLUMNA DONDE ESTA PARADO EL CURSOR
    filTablero   db 0
    colTablero   db 0
    scanCode     db 0

    ;VARIABLES PARA MANEJAR QUIÉN ESTÁ JUGANDO
    turno        db 0
    fichaActual  db 'X'

    ;VARIABLES PARA DIBUJAR EL TABLERO
    fila1        db '[ ] [ ] [ ]', 24h
    fila2        db '[ ] [ ] [ ]', 24h
    fila3        db '[ ] [ ] [ ]', 24h

    ;VARIABLES PARA VECTORES DE VICTORIA
    fil1         db "000$"
    fil2         db "000$"
    fil3         db "000$"
    col1         db "000$"  
    col2         db "000$"
    col3         db "000$"
    diag_asc     db "000$"  ;diagonal ascendente
    diag_des     db "000$"  ;diagonal descendiente
    casillero    db 0      
    marca        db 1          
    ganador      db "0"
    reinicio     db "JUGAR DE NUEVO?",0dh,0ah
                 db "1) SI",0dh,0ah
                 db "0) NO",0dh,0ah
                 db "Seleccione una opcion:",0dh,0ah,24h
    cartelSalida db "Gracias por jugar!",0dh,0ah,24h
    jugadas      db 0      
    cartelEmpate db 0dh, 0ah
                 db "  ===========  ", 0dh, 0ah
                 db "  ! EMPATE !      ", 0dh, 0ah
                 db "  ===========  ", 0dh, 0ah, 24h
    cierreCartel db " |", 0dh, 0ah
                 db "  ==============", 0dh, 0ah, 24h

.code
extrn win_chk:proc
extrn limpiar_pantalla:proc

    main proc

    mov ax, @data
    mov ds, ax

gameLoop:
    call limpiar_pantalla
    call dibujarTablero

    mov dh, filTablero
    add dh, 11

    ;JUEGO CON LAS COORDENADAS DE LA BIOS PARA APUNTAR EL CURSOR
    mov al, colTablero
    mov bl, 4
    mul bl
    add al, 36   
    mov dl, al
    mov ah, 02h
    mov bh, 00h
    int 10h

    ;IMPRIMO FICHA DEL TURNO ACTUAL:
    mov ah, 2
    mov dl, fichaActual 
    int 21h

    ;LEO LA TECLA
    mov ah, 00h
    int 16h
    mov scanCode, ah

    ;CALCULO DE VUELTA LA POSICION EN PANTALLA PARA BORRAR TEMPORALMENTE LA FICHA
    mov dh, filTablero
    add dh, 11
    mov al, colTablero
    mov bl, 4
    mul bl
    add al, 36
    mov dl, al

    mov ah, 02h
    mov bh, 00h
    int 10h

    mov al, colTablero
    mov bl, 4
    mul bl
    add al, 1
    xor ah, ah
    mov si, ax

    cmp filTablero, 0
    je leerF1
    cmp filTablero, 1
    je leerF2
    jmp leerF3
leerF1:
    mov dl, [fila1 + si]
    jmp restaurarCaracter
leerF2:
    mov dl, [fila2 + si]
    jmp restaurarCaracter
leerF3:
    mov dl, [fila3 + si]

restaurarCaracter:
    mov ah, 2
    int 21h

    ;CONTROL DE TECLAS:
    cmp scanCode, 48h   ;FLECHA ARRIBA
    je arriba

    cmp scanCode, 50h   ;FLECHA ABAJO
    je abajo

    cmp scanCode, 4Bh   ;FLECHA IZQUIERDA
    je izquierda

    cmp scanCode, 4Dh   ;FLECHA DERECHA
    je derecha

    cmp scanCode, 1Ch   ;ENTER
    je colocarFicha

    jmp gameLoop

volver:
    jmp gameLoop

arriba:
    cmp filTablero, 0
    je volver
    dec filTablero
    jmp volver

abajo:
    cmp filTablero, 2
    je volver
    inc filTablero
    jmp volver

izquierda:
    cmp colTablero, 0
    je volver
    dec colTablero
    jmp volver

derecha:
    cmp colTablero, 2
    je volver
    inc colTablero
    jmp volver

colocarFicha:
    mov al, colTablero
    mov bl, 4
    mul bl
    add al, 1          
    xor ah, ah
    mov si, ax 

    cmp filTablero, 0
    je f1
    cmp filTablero, 1
    je f2
    jmp f3

f1:
    cmp [fila1 + si], ' ' 
    je casilla_libre_f1
    jmp volver
casilla_libre_f1:            
    mov cl, fichaActual
    mov [fila1 + si], cl  
    call mtxindx
    jmp llamada_win_chk

f2:
    cmp [fila2 + si], ' ' 
    je casilla_libre_f2
    jmp volver
casilla_libre_f2:
    mov cl, fichaActual
    mov [fila2 + si], cl
    call mtxindx
    jmp llamada_win_chk

f3:
    cmp [fila3 + si], ' '
    je casilla_libre_f3   
    jmp volver            
    
casilla_libre_f3:
    mov cl, fichaActual
    mov [fila3 + si], cl
    call mtxindx
    jmp llamada_win_chk

llamada_win_chk:
    mov ganador, '0'

    ;EN CADA LLAMADA A LA FUNCION, AUMENTAMOS EL CONTADOR DE JUGADAS
    inc jugadas

    push offset ganador
    push offset fil1
    call win_chk

    push offset ganador
    push offset fil2
    call win_chk

    push offset ganador
    push offset fil3
    call win_chk

    push offset ganador
    push offset col1
    call win_chk

    push offset ganador
    push offset col2
    call win_chk

    push offset ganador
    push offset col3
    call win_chk

    push offset ganador
    push offset diag_des
    call win_chk

    push offset ganador
    push offset diag_asc
    call win_chk

    ;VERIFICAMOS SI HUBO GANADOR
    cmp ganador, '0'
    jne mostrarGanador 

    ;VERIFICAMOS SI HUBO EMPATE
    cmp jugadas, 9
    je mostrarEmpate

    jmp cambiarTurno

cambiarTurno:
    cmp turno, 0
    jne jugadorX
    mov turno, 1
    mov fichaActual, 'O'
    jmp volver

jugadorX:
    mov turno, 0
    mov fichaActual, 'X'
    jmp volver

mostrarGanador:
    call limpiar_pantalla
    call dibujarTablero

    mov ah, 2
    mov bh, 00h
    mov dh, 15
    mov dl, 0
    int 10h

;---------------------------------------------------------------
;               LLAMADO A NUESTRA INTERRUPCION
;---------------------------------------------------------------
    int 80h        

    mov dl, ganador         
    mov ah, 2             
    int 21h

    mov ah, 9
    mov dx, offset cierreCartel
    int 21h

preguntarReinicio:
    mov ah, 9
    mov dx, offset reinicio
    int 21h

    mov ah,1
    int 21h

    cmp al, '1'
    jne salida
    call reiniciarDatos
    jmp gameLoop

mostrarEmpate:
    call limpiar_pantalla
    call dibujarTablero

    mov ah, 2
    mov bh, 00h
    mov dh, 15
    mov dl, 0
    int 10h

    mov ah, 9
    mov dx, offset cartelEmpate
    int 21h
    jmp preguntarReinicio

salida:
    mov ah,2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h

    mov ah, 9
    mov dx, offset cartelSalida
    int 21h

    mov ax, 4c00h
    int 21h

    main endp

;-----------------------------------------------------------------
;                   CENTRAR Y DIBUJAR TABLERO
;-----------------------------------------------------------------

    dibujarTablero proc
    push ax
    push bx
    push cx
    push dx

    ;FILA 1 COORDENADAS: X=35 || Y=11
    mov ah, 02h
    mov bh, 00h
    mov dh, 11
    mov dl, 35
    int 10h
    lea dx, fila1
    mov ah, 9
    int 21h

    ;FILA 2 COORDENADAS: X=35 || Y=12
    mov ah, 02h
    mov bh, 00h
    mov dh, 12
    mov dl, 35
    int 10h
    lea dx, fila2
    mov ah, 9
    int 21h

    ;FILA 3 COORDENADAS: X=35 || Y=13
    mov ah, 02h
    mov bh, 00h
    mov dh, 13
    mov dl, 35
    int 10h
    lea dx, fila3
    mov ah, 9
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
    dibujarTablero endp

;-----------------------------------------------------------------
;               MAPEO Y ACTUALIZACION DE JUGADAS
;-----------------------------------------------------------------

    mtxindx proc
    push ax
    push bx
    push si
    push di
    push cx
    push dx

    xor dx, dx
    mov dl, fichaActual     
    mov al, filTablero
    mov ah, colTablero     

    cmp al, 0
    je fila1_
    cmp al, 1
    je fila2_
    cmp al, 2
    je fila3_
    jmp fin_

fila1_:
    cmp ah, 0
    je f1c1_
    cmp ah, 1
    je f1c2_
    cmp ah, 2
    je f1c3_
    jmp fin_

fila2_:
    cmp ah, 0
    je f2c1_
    cmp ah, 1
    je f2c2_
    cmp ah, 2
    je f2c3_
    jmp fin_

fila3_:
    cmp ah, 0
    je f3c1_
    cmp ah, 1
    je f3c2_
    cmp ah, 2
    je f3c3_
    jmp fin_

f1c1_:
    mov fil1[0], dl
    mov col1[0], dl
    mov diag_des[0], dl
    jmp fin_

f1c2_:
    mov fil1[1], dl
    mov col2[0], dl
    jmp fin_

f1c3_:
    mov fil1[2], dl
    mov col3[0], dl
    mov diag_asc[2], dl
    jmp fin_

f2c1_:
    mov fil2[0], dl
    mov col1[1], dl
    jmp fin_

f2c2_:
    mov fil2[1], dl
    mov col2[1], dl
    mov diag_des[1], dl
    mov diag_asc[1], dl
    jmp fin_

f2c3_:
    mov fil2[2], dl
    mov col3[1], dl
    jmp fin_

f3c1_:
    mov fil3[0], dl
    mov col1[2], dl
    mov diag_asc[0], dl
    jmp fin_

f3c2_:
    mov fil3[1], dl
    mov col2[2], dl
    jmp fin_

f3c3_:
    mov fil3[2], dl
    mov col3[2], dl
    mov diag_des[2], dl
    jmp fin_

fin_:
    pop dx
    pop cx
    pop di
    pop si
    pop bx
    pop ax
    ret
    mtxindx endp

;-------------------------------------------------------------------
;                        REINICIO DE DATOS
;-------------------------------------------------------------------

    reiniciarDatos proc
    ;ESTA FUNCION PONE TODAS LAS VARIABLES EN CERO EN CASO DE QUE
    ;EL USUARIO QUIERA REINICIAR LA PARTIDA
    push ax
    push si
    push cx

    mov filTablero, 0
    mov colTablero, 0
    mov scanCode, 0
    mov turno, 0
    mov fichaActual, 'X'
    mov ganador, '0'
    mov jugadas, 0

    mov [fila1 + 1], ' '
    mov [fila1 + 5], ' '
    mov [fila1 + 9], ' '
    
    mov [fila2 + 1], ' '
    mov [fila2 + 5], ' '
    mov [fila2 + 9], ' '

    mov [fila3 + 1], ' '
    mov [fila3 + 5], ' '
    mov [fila3 + 9], ' '

    mov cx, 3
    mov si, 0
limpieza:
    mov [fil1 + si],     '0'
    mov [fil2 + si],     '0'
    mov [fil3 + si],     '0'
    mov [col1 + si],     '0'
    mov [col2 + si],     '0'
    mov [col3 + si],     '0'
    mov [diag_asc + si], '0'
    mov [diag_des + si], '0'
    inc si
loop limpieza

    pop cx
    pop si
    pop ax
    ret
    reiniciarDatos endp

end
