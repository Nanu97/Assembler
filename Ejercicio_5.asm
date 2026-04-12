; Ingrese una palabra de hasta 5 caracteres e indique si es palíndromo

.8086
.model small
.stack 100h
.data
	cartel       db "Ingrese una palabra de 5 letras, luego determinaremos si es (o no) palindromo:",0dh,0ah,24h
	texto        db "00000",0dh,0ah,24h
	textoAlverre db "00000",0dh,0ah,24h
	esPalindromo db " ES PALINDROMO!",0dh,0ah,24h
	noPalindromo db " NO es un palindromo",0dh,0ah,24h
	saltarin     db 0dh,0ah,24h

.code
	main proc
	mov ax, @data
	mov ds, ax

	mov bx, 0
	mov cx, 5
	; CAJA DE CARGA
	mov ah, 9
	mov dx, offset cartel
	int 21h

	mov ah, 9
	mov dx, offset saltarin
	int 21h

carga:
	mov ah, 1
	int 21h
	mov texto[bx], al
	mov textoAlverre[bx], al
	inc bx
	loop carga

finCarga:
	mov bx, 0
	mov di, 4
	mov cx, 5

comparacion:
	mov al, texto[bx]
	cmp textoAlverre[di], al
	jne noPal
	inc bx
	dec di
	loop comparacion

esPal:
	mov ah, 9
	mov dx, offset esPalindromo
	int 21h

	jmp fin

noPal:
	mov ah, 9
	mov dx, offset noPalindromo
	int 21h

fin:

	mov ax, 4c00h
	int 21h

	main endp
end
