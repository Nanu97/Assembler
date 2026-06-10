.8086
.model small
.stack 100h
.data

    ;FILA Y COLUMNA DONDE ESTÁ PARADO EL CURSOR
    filTablero  db 0
    colTablero  db 0
    scanCode    db 0

    ;VARIABLES PARA MANEJAR QUIÉN ESTÁ JUGANDO
    turno       db 0
    fichaActual db 'X'

    ;VARIABLES PARA DIBUJAR EL TABLERO
    fila1       db '[ ] [ ] [ ]', 24h
    fila2       db '[ ] [ ] [ ]', 24h
    fila3       db '[ ] [ ] [ ]', 24h

.code

    main proc

    mov ax, @data
    mov ds, ax

gameLoop:
    ;DIBUJAMOS  EL TABLERO EN EL CENTRO DE LA PANTALLA

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

    mov dh, filTablero
    add dh, 11

    ;JUEGO CON LAS COORDENADAS DE LA BIOS PARA APUNTAR EL CURSOR EN LA POSICION CORRECTA:

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

    ;CALCULO DE VUELTA LA POSICION EN PANTALLA PARA BORRAR TEMPORALMENTE LA 'X' o LA 'O':

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

    ;CONTROL DE MOVIMIENTOS (LIMITADO PARA NO SALIRSE DEL TABLERO)
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

    ;PASAMOS A LA PARTE DE LA JUGADA DEL USUARIO (INGRESO DE FICHA)

colocarFicha:
    mov al, colTablero
    mov bl, 4
    mul bl
    add al, 1          
    xor ah, ah
    mov si, ax ;USAMOS 'SI' PARA MANEJAR LOS INDICES Y SABER QUÉ CASILLERO ALTERAR

    ;VERIFICAR DONDE ESTOY PARADO
    cmp filTablero, 0
    je f1
    cmp filTablero, 1
    je f2
    jmp f3

f1:
    cmp [fila1 + si], ' ' ;COMPROBAMOS SI ESTÁ LIBRE
    jne volver            ;EN CASO DE HABER UNA FICHA, NO PERMITE SUPERPONER
    mov cl, fichaActual
    mov [fila1 + si], cl  ;GUARDO FICHA
    jmp cambiarTurno

f2:
    cmp [fila2 + si], ' ' 
    jne volver
    mov cl, fichaActual
    mov [fila2 + si], cl
    jmp cambiarTurno

f3:
    cmp [fila3 + si], ' '
    jne volver
    mov cl, fichaActual
    mov [fila3 + si], cl
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

    main endp
end
