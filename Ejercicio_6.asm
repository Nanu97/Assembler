; INGRESE UN TEXTO E IMPRIMA LA CANTIDAD DE VOCALES Y CONSONANTES UTILIZADAS

.8086
.model small
.stack 100h
.data
	texto       db 255 dup (24h),24h
	cartel1     db "***Ingrese un texto, luego contaremos cuantas vocales y consonantes tiene***",0dh,0ah,24h
	cartel2     db "Cantidad de vocales:",0dh,0ah,24h
	cartel3     db "Cantidad de consonantes",0dh,0ah,24h
	saltarin    db 0dh,0ah,24h
	vocales     db "aeiouAEIOU",24h
	consonantes db "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ",24h
	contadorV   db 0
	contadorC   db 0
	nroVocales  db "000",0dh,0ah,24h
	nroConso    db "000",0dh,0ah,24h
	dataMul     db 100,10,1

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
	mov bx, 0

proceso:
	mov si, 0
	mov di, 0
	cmp texto[bx], 24h
	je finProceso
procesoVoc:
	cmp vocales[si],24h
	je procesoCons
	mov al, texto[bx]
	cmp al, vocales[si]
	je esVocal
	inc si
	jmp procesoVoc

procesoCons:
	cmp consonantes[di],24h
	je noEsLetra
	mov al, texto[bx]
	cmp al, consonantes[di]
	je esConsonante
	inc di
	jmp procesoCons

esVocal:
	inc contadorV
	inc bx
	jmp proceso

esConsonante:
	inc contadorC
	inc bx
	jmp proceso

noEsLetra:
	inc bx
	jmp proceso

finProceso:

	; REG2ASCII MAQUINA DE MATAR

	mov cx, 3

	mov al, contadorV
	xor ah, ah
	xor bx, bx
r2aVocal:
	mov dl, dataMul[bx]
	div dl
	add nroVocales[bx], al
	mov al, ah
	xor ah, ah
	inc bx
loop r2aVocal

	; LO MISMO PARA EL CONTADOR DE CONSONANTES
	
	mov cx, 3

	mov al, contadorC
	xor ah, ah
	xor bx, bx
r2aConso:
	mov dl, dataMul[bx]
	div dl
	add nroConso[bx], al
	mov al, ah
	xor ah, ah
	inc bx
loop r2aConso

	; IMPRIMO

	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset cartel2
	int 21h

	mov ah, 9
	mov dx, offset nroVocales
	int 21h

	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset cartel3
	int 21h

	mov ah, 9
	mov dx, offset nroConso
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
