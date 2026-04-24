; INGRESE UN TEXTO DE HASTA 255 CARACTERES Y MAYUSCULICE CADA INICIAL DE UNA PALABRA

.8086
.model small
.stack 100h
.data
	texto  db 255 dup (24h), 24h
	minusc db "abcdefghijklmnopqrstuvwxyz", 24h
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
	;PROCESO

primerP:
	mov si, 0
	cmp bx, 0
	je puedeSerPrimerP

puedeSerPrimerP:
	cmp texto[bx], 24h
	je finProceso
	cmp minusc[si], 24h
	je noMayusculizo
	mov al, texto[bx]
	cmp al, minusc[si]
	je procesoMay
	inc si
	jmp puedeSerPrimerP

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

puedeSerPal:
	cmp texto[bx], 20h
	je incrementa
	cmp minusc[si], 24h
	je noMayusculizo
	mov al, texto[bx]
	cmp al, minusc[si]
	je procesoMay
	inc si
	jmp puedeSerPal

procesoMay:
	sub al, 20h
	mov texto[bx], al
	inc bx
	jmp proceso

noMayusculizo:
	inc bx
	jmp proceso

finProceso:

	;IMPRIMO RESULTADOS

	mov ah, 2
	mov dl, 0dh
	int 21h
	mov ah, 2
	mov dl, 0ah
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
