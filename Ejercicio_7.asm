; INGRESE UN TEXTO Y CUENTE LA CANTIDAD DE PALABRAS

.8086
.model small
.stack 100h
.data
	texto       db 255 dup (24h), 24h
	palabras    db 0
	imprimirPal db "000",0dh, 0ah, 24h
	letras      db "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 24h
	dataMul     db 100,10,1
.code
	main proc

	mov ax, @data
	mov ds, ax

	mov bx, 0

	;CAJA DE CARGA

carga:
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCarga
	mov texto[bx], al
	inc bx
	jmp carga

finCarga:

	mov bx, 0

primerP:
	mov si, 0
	cmp bx, 0
	je puedeSerPal

proceso:
	mov si, 0
	cmp texto[bx], 24h
	je finProceso
	cmp texto[bx], 20h
	je incrementa
	inc bx
	jmp proceso

incrementa:
	inc bx
	jmp puedeSerPal

puedeSerPal:
	cmp letras[si], 24h
	je noEsLetra
	mov al, texto[bx]
	cmp al, letras[si]
	je esLetra
	inc si
	jmp puedeSerPal

esLetra:
	inc palabras
	inc bx
	jmp proceso

noEsLetra:
	inc bx
	jmp proceso

finProceso:

	;REG2ASCII MAQUINA DE MATAR

	mov cx, 3

	mov al, palabras

	xor ah, ah
	xor bx, bx

r2a:
	mov dl, dataMul[bx]
	div dl
	add imprimirPal[bx], al
	mov al, ah
	xor ah, ah
	inc bx
	loop r2a

	;IMPRIMO RESULTADOS

	mov cx, 60
	
separador:
	mov ah, 2
	mov dl, '-'
	int 21h
	loop separador

	mov ah, 2
	mov dl, 0dh
	int 21h
	mov ah, 2
	mov dl, 0ah
	int 21h

	mov ah, 9
	mov dx, offset imprimirPal
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
