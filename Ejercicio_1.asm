; INGRESE UN TEXTO DE HASTA 255 CARACTERES TERMINADOS POR EL SIGNO $.
; IMPRIMA EL TEXTO MODIFICANDO LA LETRA A POR LA LETRA X.
; IMPRIMA EL TEXTO MODIFICADO Y LUEGO EL TEXTO ORIGINAL.

.8086
.model small
.stack 100h
.data
	texto    db 255 dup (24h),24h
	textoMod db 255 dup (24h),24h
	mensaje1 db "***TEXTO ORIGINAL***",0dh,0ah,24h
	mensaje2 db "***TEXTO MODIFICADO***",0dh,0ah,24h
	saltarin db 0dh,0ah,24h

.code
	main proc
	mov ax, @data
	mov ds, ax

	; CAJA DE CARGA
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
	mov bx, 0            ; REINICIALIZO EL INDICE BX

proceso:
	cmp textoMod[bx], 24h
	je finProceso
	cmp textoMod[bx], 'a'
	je esA
	cmp textoMod[bx], 'A'
	je esA

aumenta:
	inc bx
	jmp proceso

esA:
	add textoMod[bx], 23
	jmp aumenta

finProceso:

	; IMPRESION DE RESULTADOS

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
	mov dx, offset textoMod
	int 21h

	mov ax, 4c00h
	int 21h

	main endp
end
