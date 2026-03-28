.8086
.model small
.stack 100h

.data
	mensaje1 db "Ingrese el texto:", 0dh, 0ah, 24h
	mensaje2 db "Texto original:", 0dh, 0ah, 24h
	mensaje3 db "Texto modificado:", 0dh, 0ah, 24h

	texto db 255 dup (24h), 24h
	textoMod db 255 dup (24h), 24h
	salto db 0dh, 0ah, 24h
.code
	main proc

	mov ax, @data
	mov ds, ax
	mov bx, 0
	
	mov ah, 9
	mov dx, offset mensaje1
	int 21h

	mov bx, 0
carga:
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCarga
	mov texto[bx], al
	mov textoMod[bx], al
	inc bx
	jmp carga

finCarga:
	mov bx, 0

proceso:
	cmp textoMod[bx], 24h
	je finProceso
	cmp textoMod[bx], 'a'
	je esVocal
	cmp textoMod[bx], 'e'
	je esVocal
	cmp textoMod[bx], 'i'
	je esVocal
	cmp textoMod[bx], 'o'
	je esVocal
	cmp textoMod[bx], 'u'
	je esVocal

aumenta:
	inc bx
	jmp proceso

esVocal:
	mov al, textoMod[bx]
	sub al, 32
	mov textoMod[bx], al
	jmp aumenta

finProceso:
	
	mov ah, 9
	mov dx, offset mensaje2
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ah, 9
	mov dx, offset salto
	int 21h

	mov ah, 9
	mov dx, offset mensaje3
	int 21h

	mov ah, 9
	mov dx, offset textoMod
	int 21h

	mov ax, 4c00h
	int 21h
	main endp
end
