; INGRESE UN TEXTO DE HASTA 5 CARACTERES E IMPRIMA EN FORMA DE ESPEJO

.8086
.model small
.stack 100h
.data
	texto        db "00000",0dh,0ah,24h		; CARGA FORZADA
	textoAlverre db "00000",0dh,0ah,24h
	saltarin     db 0dh,0ah,24h
	mensaje1     db "***TEXTO ORIGINAL***",0dh,0ah,24h
	mensaje2     db "***TEXTO AL REVES***",0dh,0ah,24h

.code
	main proc
	mov ax, @data
	mov ds, ax

	; CAJA DE CARGA
	mov bx, 0
	mov cx, 5
	mov si, 4

carga:
	mov ah, 1
	int 21h
	mov texto[bx], al
	mov textoAlverre[si], al
	inc bx
	dec si
	loop carga

imprimo:
	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset mensaje1
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset mensaje2
	int 21h

	mov ah, 9
	mov dx, offset textoAlverre
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
