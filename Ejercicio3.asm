; INGRESE UN TEXTO E IMPRIMALO CON LA PRIMER LETRA DE CADA PALABRA EN MAYUSCULA

.8086
.model small
.stack 100h
.data
	mensaje1 db "Ingrese el texto:", 0dh, 0ah, 24h
	mensaje2 db "*****TEXTO ORIGINAL*****", 0dh, 0ah, 24h
	mensaje3 db "*****TEXTO MODIFICADO*****", 0dh, 0ah, 24h
	saltarin db 0dh, 0ah, 24h			            ; SALTARIN (VARIABLE AUXILIAR)
	texto    db 255 dup (24h), 24h					; TEXTO ORIGINAL
	textoMod db 255 dup (24h), 24h					; TEXTO MODIFICADO
.code
	main proc
	mov ax, @data
	mov ds, ax

	mov ah, 9						        ; SERVICIO DE IMPRESION
	mov dx, offset mensaje1			        ; IMPRIMO mensaje1
	int 21h									; EJECUTO

	;CAJA DE CARGA
	mov bx, 0 								; PONGO EL INDICE EN 0

	carga:
		mov ah, 1 							; SERVICIO DE ENTRADA POR TECLADO
		int 21h								; EJECUTO INT 21h
		cmp al, 0dh 						; COMPARO CON ENTER PARA FINALIZAR CARGA
		je finCarga
		mov texto[bx], al
		mov textoMod[bx], al
		inc bx
	jmp carga

	finCarga:
		mov bx, 0 			 				; REINICIALIZO BX PARA VOLVER A RECORRER

	proceso:
		cmp textoMod[bx], 24h				; CONDICION DE SALIDA
		je  finProceso
		cmp bx, 0							; PRIMER LETRA
		je  espacio
		cmp textoMod[bx-1], ' '				; COMPARO POSICION ANTERIOR CON ESPACIO
		je  espacio
	aumenta:
		inc bx								; INCREMENTO EL INDICE
	jmp proceso

	espacio:
		cmp textoMod[bx], 61h				; COMPARO A PARTIR DE 61h ('a')
		jb  aumenta							; SI EL ASCII ES MENOR: YA ES MAYUSCULA
		jae inicialMin						; SI EL ASCII ES MAYOR O IGUAL: ES MINUSCULA

	inicialMin:
		mov al, textoMod[bx]
		sub al, 20h					; RESTO 20h (DISTANCIA PARA PASAR DE MINUSCULA A MAYUSCULA)
		mov textoMod[bx], al
		jmp aumenta

	finProceso:

	mov ah, 9
	mov dx, offset mensaje3
	int 21h

	mov ah, 9
	mov dx, offset textoMod
	int 21h

	mov ah, 9
	mov dx, offset saltarin
	int 21h

	mov ah, 9
	mov dx, offset mensaje2
	int 21h

	mov ah, 9
	mov dx, offset texto
	int 21h

	mov ax, 4c00h
	int 21h
	main endp
end
