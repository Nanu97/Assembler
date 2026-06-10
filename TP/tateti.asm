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
; TABLERO (Quitamos los saltos de línea para controlarlos por código)
;=========================
fila1 db '[ ] [ ] [ ]', 24h
fila2 db '[ ] [ ] [ ]', 24h
fila3 db '[ ] [ ] [ ]', 24h

.code
main proc
    mov ax, @data
    mov ds, ax

gameLoop:
    ;================================================
    ; DIBUJAR TABLERO CENTRADO
    ;================================================
    ; Fila 1 (Fila 11, Columna 35)
    mov ah, 02h
    mov bh, 00h
    mov dh, 11
    mov dl, 35
    int 10h
    lea dx, fila1
    mov ah, 9
    int 21h

    ; Fila 2 (Fila 12, Columna 35)
    mov ah, 02h
    mov bh, 00h
    mov dh, 12
    mov dl, 35
    int 10h
    lea dx, fila2
    mov ah, 9
    int 21h

    ; Fila 3 (Fila 13, Columna 35)
    mov ah, 02h
    mov bh, 00h
    mov dh, 13
    mov dl, 35
    int 10h
    lea dx, fila3
    mov ah, 9
    int 21h

    ;=========================
    ; CALCULAR POSICION VISUAL DEL CURSOR ('X')
    ;=========================
    ; Fila: 11 + filaTablero
    mov dh, filaTablero
    add dh, 11

    ; Columna: 35 + (columnaTablero * 4) + 1  <-- El +1 es para caer dentro del [ ]
    mov al, columnaTablero
    mov bl, 4
    mul bl
    add al, 36   ; 35 del centro + 1 del espacio interno del corchete
    mov dl, al

    ;=========================
    ; POSICIONAR CURSOR Y DIBUJAR X
    ;=========================
    mov ah, 02h
    mov bh, 00h
    int 10h

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
    ; BORRAR X EN LA POSICION ACTUAL ANTES DE MOVER
    ;=========================
    ; Recalculamos la misma posición donde se dibujó
    mov dh, filaTablero
    add dh, 11
    mov al, columnaTablero
    mov bl, 4
    mul bl
    add al, 36
    mov dl, al

    mov ah, 02h
    mov bh, 00h
    int 10h

    mov ah, 2
    mov dl, ' '  ; Reemplazamos la X por un espacio
    int 21h

    ;=========================
    ; DETECTAR FLECHAS
    ;=========================

    cmp scanCode, 48h ; FLECHA ARRIBA
    jne noArriba
    jmp arriba
noArriba:

    cmp scanCode, 50h ; FLECHA ABAJO
    jne noAbajo
    jmp abajo
noAbajo:

    cmp scanCode, 4Bh ; FLECHA IZQUIERDA
    jne noIzquierda
    jmp izquierda
noIzquierda:

    cmp scanCode, 4Dh ; FLECHA DERECHA
    jne noDerecha
    jmp derecha
noDerecha:

    jmp gameLoop

;---------------------------------
;           MOVIMIENTOS
;---------------------------------

volver:
    jmp gameLoop

arriba:
    cmp filaTablero, 0
    je volver
    dec filaTablero
    jmp volver

abajo:
    cmp filaTablero, 2
    je volver
    inc filaTablero
    jmp volver

izquierda:
    cmp columnaTablero, 0
    je volver
    dec columnaTablero
    jmp volver

derecha:
    cmp columnaTablero, 2
    je volver
    inc columnaTablero
    jmp volver

main endp
end
