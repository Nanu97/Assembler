.8086
.model small
.stack 100h
.data

.code

;---------------------------------------------------------------------------------------------------------------------------------------
public win_chk
public limpiar_pantalla

win_chk proc
;SS+4: RECIBE EL OFFSET DE UN DB DE 3 BYTES (ej: "000")
;SS+6: DEVUELVE 0 SI NO SON TODOS IGUALES A "X" O "O", DEVUELVE "X" SI SON TODOS IGUALES A "X", DEVUELVE "O" SI SON TODOS IGUALES A "O"
;USA AX COMO CONTADOR PARA "X", DX COMO CONTADOR PARA "O"
push bp
mov bp, sp
push bx
push si
push ax
push cx
push dx

xor ax, ax
xor dx, dx

mov bx, SS:[BP+4]
mov si, SS:[BP+6]

mov cx, 3
ciclo:
	cmp byte ptr [bx], "X"
	je suma1

	cmp byte ptr [bx], "O"
	je suma2

	jmp skip
	suma1:
	inc ax
	jmp skip

	suma2:
	inc dx
	jmp skip

skip:
inc bx
loop ciclo

cmp al, 3
je es_X
jmp siguiente

es_X:
mov byte ptr[si], "X"

siguiente:
cmp dl, 3
je es_O
jmp fin_func

es_O:
mov byte ptr [si], "O"

fin_func:

pop dx
pop cx
pop ax
pop si
pop bx
pop bp

ret 4
win_chk endp
;---------------------------------------------------------------------------------------------------------------------------------------

	limpiar_pantalla proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 06h        ; Función de la BIOS: Scroll hacia arriba
    mov al, 00h        ; AL = 0 significa limpiar toda la pantalla
    mov bh, 07h        ; Atributo de video: Texto blanco (7) sobre fondo negro (0)
    mov ch, 0          ; Fila superior izquierda
    mov cl, 0          ; Columna superior izquierda
    mov dh, 24         ; Fila inferior derecha
    mov dl, 79         ; Columna inferior derecha
    int 10h            ; Interrupcion de la BIOS

    pop dx
    pop cx
    pop bx
    pop ax
    ret
	limpiar_pantalla endp

end
