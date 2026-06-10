.8086
.model small
.stack 100h
.data

;=========================
; POSICION LOGICA
;=========================

filaTablero db 0
columnaTablero db 0

scanCode db ?

;=========================
; TABLERO
;=========================

fila1 db '[ ] [ ] [ ]', 0dh,0ah,24h
fila2 db '[ ] [ ] [ ]', 0dh,0ah,24h
fila3 db '[ ] [ ] [ ]', 24h

.code

    main proc

    mov ax, @data
    mov ds, ax

    ;=========================
    ; DIBUJAR TABLERO
    ;=========================

    lea dx, fila1
    mov ah, 9
    int 21h

    lea dx, fila2
    mov ah, 9
    int 21h

    lea dx, fila3
    mov ah, 9
    int 21h

;================================================
; GAME LOOP
;================================================

gameLoop:

    ;=========================
    ; CALCULAR FILA VISUAL
    ;=========================

    mov dh, filaTablero
    add dh, 22	;ME MUEVO VERTICALMENTE HACIA ABAJO HASTA ENCAJAR CON LA POSICION [0][0] DEL TABLERO

    ;=========================
    ; CALCULAR COLUMNA VISUAL
    ;=========================

    mov al, columnaTablero
    mov bl, 4
    mul bl

    add al, 1

    mov dl, al

    ;=========================
    ; POSICIONAR CURSOR
    ;=========================

    mov ah, 02h
    mov bh, 00h
    int 10h

    ;=========================
    ; DIBUJAR X
    ;=========================

    mov ah, 2
    mov dl, 'X'
    int 21h

    ;=========================
    ; LEER TECLA
    ;=========================

    mov ah, 00h
    int 16h

    mov scanCode, ah

    ;=========================
    ; RECALCULAR POSICION
    ;=========================

    mov dh, filaTablero
    add dh, 22

    mov al, columnaTablero
    mov bl, 4
    mul bl

    add al, 1

    mov dl, al

    ;=========================
    ; VOLVER A POSICION
    ;=========================

    mov ah, 02h
    mov bh, 00h
    int 10h

    ;=========================
    ; BORRAR X
    ;=========================

    mov ah, 2
    mov dl, ' '
    int 21h

    ;=========================
    ; DETECTAR FLECHAS
    ;=========================

    cmp scanCode, 48h ;FLECHA ARRIBA
    jne noArriba
    jmp arriba

noArriba:

    cmp scanCode, 50h ;FLECHA ABAJO
    jne noAbajo
    jmp abajo

noAbajo:

    cmp scanCode, 4Bh ;FLECHA IZQUIERDA
    jne noIzquierda
    jmp izquierda

noIzquierda:

    cmp scanCode, 4Dh ;FLECHA DERECHA
    jne noDerecha
    jmp derecha

noDerecha:

    jmp gameLoop

;================================================
; MOVIMIENTOS
;================================================

arriba:

    cmp filaTablero, 0
    jne moverArriba
    jmp gameLoop

moverArriba:

    dec filaTablero
    jmp gameLoop

;------------------------------------------------

abajo:

    cmp filaTablero, 2
    jne moverAbajo
    jmp gameLoop

moverAbajo:

    inc filaTablero
    jmp gameLoop

;------------------------------------------------

izquierda:

    cmp columnaTablero, 0
    jne moverIzquierda
    jmp gameLoop

moverIzquierda:

    dec columnaTablero
    jmp gameLoop

;------------------------------------------------

derecha:

    cmp columnaTablero, 2
    jne moverDerecha
    jmp gameLoop

moverDerecha:

    inc columnaTablero
    jmp gameLoop

    main endp
end
