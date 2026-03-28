.8086
.model small
.stack 100h
.data
	mensaje1 db "Ingrese el texto:", 0dh, 0ah, 24h
	saltador db 					 0dh, 0ah, 24h			; SALTADOR (VARIABLE AUXILIAR)
	texto    db 					 255 dup (24h), 24h
	textoMod db 					 255 dup (24h), 24h
.code
	main proc
	mov ax, @data
	mov ds, ax

	mov ah, 9						; SERVICIO DE IMPRESION
	mov dx, offset mensaje1			; IMPRIMO mensaje1
	int 21h

	;CAJA DE CARGA
	mov bx, 0 						; PONGO EL INDICE EN 0 (SOLO PUEDO USAR BX PARA IR A MEMORIA)

	carga:
		mov ah, 1 					; SERVICIO DE ENTRADA POR TECLADO
		int 21h
		cmp al, 0dh 				; COMPARO CON ENTER PARA TERMINAR LA CARGA DE TEXTO
		je finCarga
		mov texto[bx], al
		mov textoMod[bx], al
		inc bx
	jmp carga

	finCarga:
		mov bx, 0 			 		; REINICIALIZO BX PARA VOLVER A RECORRER

	proceso:
		cmp textoMod[bx], 24h		; CONDICION DE SALIDA
		je  finProceso
		cmp bx, 0					; 1° LETRA. SALTAR A ETIQUETA QUE VERIFIQUE SI ES MAY O MIN
		je  espacio
		cmp textoMod[bx-1], ' '		; SI POSICION ANTERIOR ES UN ESPACIO, VERIFICAR SI ES MINUSCULA
		je  espacio
	aumenta:
		inc bx
	jmp proceso

	espacio:
		cmp textoMod[bx], 61h		; SI ES MINUSCULA, MODIFICAR
		jb  aumenta
		jae inicialMin

	inicialMin:
		mov al, textoMod[bx]
		sub al, 20h					; RESTO 20h (DISTANCIA PARA PASAR DE MINUSCULA A MAYUSCULA)
		mov textoMod[bx], al
		jmp aumenta

	finProceso:

	mov ah, 9
	mov dx, offset textoMod
	int 21h

	mov ah, 9
	mov dx, offset saltador
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ax, 4c00h
	int 21h
	main endp
end
