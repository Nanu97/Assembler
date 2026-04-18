; Ingrese un texto y encríptelo sumando a cada letras 5. (recuerde que
; trabajamos con los valores de la tabla ascii en hexa)

.8086
.model small
.stack 100h
.data
	texto    db 255 dup (24h),24h
	textoCod db 255 dup (24h),24h
	saltarin db 0dh, 0ah, 24h
.code
	main proc
	mov ax, @data
	mov ds, ax

	mov bx, 0

	; CAJA DE CARGA

carga:
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCarga
	mov texto[bx], al
	mov textoCod[bx], al
	inc bx
	jmp carga

finCarga:
	
	mov bx, 0

	; PROCESO

proceso:
	cmp textoCod[bx], 24h
	je finProceso
	cmp textoCod[bx], 'a'
	jb verificoMAY
	cmp textoCod[bx], 'z'
	ja incrementa
	jbe esLetra

incrementa:
	inc bx
	jmp proceso

verificoMAY:
	cmp textoCod[bx], 'Z'
	ja incrementa
	cmp textoCod[bx], 'A'
	jb incrementa
	jae esLetra

esLetra:
	mov al, textoCod[bx]
	add al, 05h
	mov textoCod[bx], al
	jmp incrementa

finProceso:

	; IMPRIMO RESULTADOS

	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset textoCod
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
