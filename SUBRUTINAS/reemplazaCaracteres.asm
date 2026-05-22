.8086
.model small
.stack 100h
.data

.code

	public reemplazaCaracteres

	reemplazaCaracteres proc
	;ESTA FUNCION RECIBE POR STACK UN TEXTO terminado en 24h SS:[BP+6]
	;UNA VARIABLE CON UN CARACTER EN SS:[BP+4]

	push bp
	mov bp, sp
	push bx
	push si
	push ax

	mov bx, SS:[BP+6] ;RESCATO TEXTO
	mov si, SS:[BP+4] ;RESCATO CARACTER A REEMPLAZAR

procesoReemplaza:
	cmp byte ptr [bx], 24h
	je finReemplaza
	mov al, [si]
	cmp [bx], al
	je cambiar
	inc bx
jmp procesoReemplaza

cambiar:
	mov byte ptr [bx], '0' ; PUEDE VARIAR DEPENDIENDO DEL CARACTER QUE EL USUARIO DECIDA
	inc bx
	jmp procesoReemplaza

finReemplaza:
	
	pop ax
	pop si
	pop bx
	pop bp
	ret 4

	reemplazaCaracteres endp

end
