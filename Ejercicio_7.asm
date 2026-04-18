; INGRESE UN TEXTO E IMPRIMA LA CANTIDAD DE PALABRAS

.8086
.model small
.stack 100h
.data
	texto         db 255 dup (24h),24h
	cartel1       db "Ingrese un texto y contaremos la cantidad de palabras",0dh,0ah,24h
	cartel2       db "Cantidad de palabras:",0dh,0ah,24h
	saltarin      db 0dh,0ah,24h
	contadorP     db 0
	palabrasAscii db "000",0dh,0ah,24h
	dataMul       db 100, 10, 1

.code
	main proc
	mov ax, @data
	mov ds, ax

	mov bx, 0

	mov ah, 9
	mov dx, offset cartel1
	int 21h

	; CAJA DE CARGA

carga:
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCarga
	mov texto[bx], al
	inc bx
	jmp carga

finCarga:

	mov bx, 0            ; REINICIALIZO INDICE BX

	; PROCESO
primerP:
	cmp texto[bx], 'a'
	jae primerP_min
primerP_min:
	cmp texto[bx], 'z'
	jbe esPalabra

primerP_may:
	cmp texto[bx], 'A'
	jae casiPrimerP_may
casiPrimerP_may:
	cmp texto[bx], 'Z'
	jbe esPalabra

proceso:
	cmp texto[bx], 24h
	je finProceso
	mov al, texto[bx]
	cmp al, 20h
	je puedeSerPalabraMIN

incrementa:
	inc bx
	jmp proceso

puedeSerPalabraMIN:
	inc bx
	cmp texto[bx], 24h
	je finProceso
	cmp texto[bx], 'a'
	jae casiPalabraMIN

casiPalabraMIN:
	cmp texto[bx], 'z'
	jbe esPalabra

puedeSerPalabraMAY:
	cmp texto[bx], 'A'
	jae casiPalabraMAY

casiPalabraMAY:
	cmp texto[bx], 'Z'
	jbe esPalabra

esPalabra:
	inc contadorP
	jmp incrementa

finProceso:

	; R2A MAQUINA DE MATAR

	mov cx, 3

	mov al, contadorP
	xor ah, ah
	xor bx, bx

r2a:
	mov dl, dataMul[bx]
	div dl
	add palabrasAscii[bx], al
	mov al, ah
	xor ah, ah
	inc bx
loop r2a

	; IMPRIMO RESULTADOS

	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset cartel2
	int 21h

	mov ah, 9
	mov dx, offset palabrasAscii
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
