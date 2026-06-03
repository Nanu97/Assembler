;ARRAY DE SIMBOLOS POR LAS DUDAS: "!#$%&'()*+,-./:;<=>?@[\]^_`{|}~"

.8086
.model small
.stack 100h
.data

.code

	public reemplazaCaracteres ;POR UNO ESPECIFICO QUE ELIGE USUARIO
	public cargaTexto ;CAJA DE CARGA BASICA
	public imprimo
	public cargaSoloLetras ;O TAMBIEN NUMEROS/SIMBOLOS
	public darVuelta
	public contarCosas ;VOCALES, NUMEROS, SIMBOLOS, LETRAS, ETC...
	public r2a ;REGTOASCII (PICO Y PALA)
	public mayusculizar
	public funcionSumar
	public quitarEspacios

;---------------------------------------------------------------------------
;						1) REEMPLAZAR CARACTERES
;---------------------------------------------------------------------------

	reemplazaCaracteres proc
	;ESTA FUNCION RECIBE POR STACK UN TEXTO terminado en 24h SS:[BP+6]
	;EL OFFSET DE UNA VARIABLE CON UN CARACTER EN SS:[BP+4]

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

;----------------------------------------------------------------
;					2) CAJA DE CARGA BÁSICA
;----------------------------------------------------------------

	cargaTexto proc

	push bp
	mov bp, sp
	push ax
	push bx

	mov bx, SS:[BP+4] ;RESCATO OFFSET DEL TEXTO A CARGAR

	;CAJA DE CARGA
carga:
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCarga
	mov [bx], al
	inc bx
jmp carga

finCarga:
	mov byte ptr [bx], '$' 

	pop bx
	pop ax
	pop bp
	ret 2

	cargaTexto endp

;-------------------------------------------------------------------
;						3) PROCESO DE IMPRESION
;-------------------------------------------------------------------

	imprimo proc

	push bp
	mov bp, sp
	push ax
	push dx

	mov dx, SS:[BP+4] ;RESCATO OFFSET DEL TEXTO A IMPRIMIR

	mov ah, 9
	int 21h

	pop dx
	pop ax
	pop bp
	ret 2

	imprimo endp

;--------------------------------------------------------------------------
;			4) CAJA DE CARGA ESPECIAL (SOLO LEERÁ [USUARIO ELIGE])
;--------------------------------------------------------------------------

	cargaSoloLetras proc
	;CAMBIANDO EL CONTENIDO DEL ARRAY EN MAIN, PODEMOS CONVERTIRLO
	;EN UN LECTOR DE SOLO NUMEROS/SIMBOLOS

	push bp
	mov bp, sp
	push ax
	push bx
	push si
	push dx

	mov bx, SS:[BP+6] ;RESCATO OFFSET DEL TEXTO A CARGAR
	mov si, SS:[BP+4] ;RESCATO OFFSET DEL ARRAY DE LETRAS

	mov dx, si

	;CAJA DE CARGA letras
cargaLet:
	mov si, dx
	mov ah, 1
	int 21h
	cmp al, 0dh
	je finCargaLet
comparoArray:
	cmp byte ptr [si], 24h
	je cargaLet
	cmp al, [si]
	je esLetra
	inc si
jmp comparoArray

esLetra:
	mov [bx], al
	inc bx
jmp cargaLet

finCargaLet:
	mov byte ptr [bx], '$'

	pop dx
	pop si
	pop bx
	pop ax
	pop bp
	ret 4

	cargaSoloLetras endp

;------------------------------------------------------------------------------------
;					5) PROCESO DE INVERSION DE TEXTO (ESPEJO)
;------------------------------------------------------------------------------------

	darVuelta proc
	;ESTA FUNCION RECIBE EL OFFSET DE UN TEXTO EN SS:[BP+6] terminado en 24h
	;Y EL OFFSET DEL TEXTO QUE SE IMPRIME AL REVES EN SS:[BP+4] terminado en 24h

	push bp
	mov bp, sp
	push bx
	push si
	push di
	push ax

	mov bx, SS:[BP+6] ;RESCATO TEXTO ORIGINAL
	mov si, SS:[BP+4] ;RESCATO TEXTO AL REVES

	mov di, bx ;LE PASO A 'DI' LA DIRECCION DONDE COMIENZA EL OFFSET DE TEXTO

conteo: 
;PROCESO DE CONTEO PARA SABER LA LONGITUD DEL TEXTO INGRESADO POR EL USUARIO

	cmp byte ptr [bx], 24h
	je finConteo
	inc bx
jmp conteo

finConteo:
	dec bx ;PORQUE BX QUEDA PASADO UNA POSICION (APUNTA A 24h)

procesoAlverre:
	cmp bx, di
	jb finProcesoAlverre ;CUANDO BX SEA MENOR QUE EL OFFSET, XQ INTERESA LA 1ra POS
	mov al, [bx]
	mov [si], al
	dec bx
	inc si
jmp procesoAlverre

finProcesoAlverre:	
	mov byte ptr [si], '$'

	pop ax
	pop di
	pop si
	pop bx
	pop bp
	ret 4
	darVuelta endp

;------------------------------------------------------------------------------------
;						6) CONTADOR DE [USUARIO ELIGE]
;------------------------------------------------------------------------------------

	contarCosas proc
	;ESTA FUNCION RECIBE EL OFFSET DE UN TEXTO EN SS:[BP+8] terminado en 24h
	;EL OFFSET DE UN ARRAY DE SIMBOLOS EN SS:[BP+6] terminado en 003 (EOT)
	;Y EL CONTADOR DE SIMBOLOS EN SS:[BP+4]

	push bp
	mov bp, sp
	push bx
	push si
	push di
	push dx
	push ax

	mov bx, SS:[BP+8] ;RESCATO TEXTO
	mov si, SS:[BP+6] ;RESCATO ARRAY DE SIMBOLOS (CONTENIDO MODIFICABLE EN MAIN)
	mov di, SS:[BP+4] ;RESCATO CANTIDAD

	mov dx, si ;DX GUARDA UNA COPIA DEL INICIO DEL ARRAY DE SIMBOLOS

procesoCuenta:
	mov si, dx
	cmp byte ptr [bx], 24h
	je finCuenta
procesito:
	cmp byte ptr [si], 3
	je continua
	mov al, [si]
	cmp [bx], al
	je sumar
	inc si
jmp procesito

continua:
	inc bx
jmp procesoCuenta

sumar:
	inc byte ptr [di]
	inc bx
jmp procesoCuenta

finCuenta:

	pop ax
	pop dx
	pop di
	pop si
	pop bx
	pop bp
	ret 6
	contarCosas endp

;------------------------------------------------------------------------
;							7) REG 2 ASCII
;------------------------------------------------------------------------

	r2a proc  ;recibe en bx el offset de una variable de 3 bytes, 
	          ;y el numero a convertir por dl no mayor a 255
    push ax
    push dx

	add bx,2
	xor ax,ax
	mov al, dl
	mov dl, 10
	div dl
	add [bx],ah

	xor ah,ah
	dec bx
    div dl
	add [bx],ah

	xor ah,ah
	dec bx
    div dl
	add [bx],ah

    pop dx
    pop ax
    ret

	r2a endp

;-------------------------------------------------------------------------
;			8) PROCESO PARA CONVERTIR TODO EL TEXTO A MAYUSCULAS
;-------------------------------------------------------------------------

	mayusculizar proc
	;ESTA FUNCION RECIBE EL OFFSET DE UN TEXTO EN SS:[BP+6]
	;Y EL ARRAY DE MINUSCULAS EN SS:[BP+4]

	push bp
	mov bp, sp
	push bx
	push si
	push dx
	push ax

	mov bx, SS:[BP+6] ;RESCATO TEXTO
	mov si, SS:[BP+4] ;RESCATO MINUSCULAS

	mov dx, si ;GUARDO COPIA DE DONDE INICIA EL ARRAY DE MINUSCULAS
procesoMayus:
	mov si, dx
	cmp byte ptr[bx], 24h
	je finMayusculizo
procesitoMayus:
	cmp byte ptr[si], 24h
	je ignoro
	mov al, [si]
	cmp [bx], al
	je esMinuscula
	inc si
jmp procesitoMayus

ignoro:
	inc bx
jmp procesoMayus

esMinuscula:
	sub byte ptr[bx], 32
	inc bx
jmp procesoMayus

finMayusculizo:

	pop ax
	pop dx
	pop si
	pop bx
	pop bp
	ret 4
	mayusculizar endp

;--------------------------------------------------------------------------------------
;				9) SUMAR DOS NUMEROS (EL RESULTADO NO PUEDE SUPERAR 255)
;--------------------------------------------------------------------------------------

	funcionSumar proc
	;ESTA FUNCION RECIBE EL OFFSET DE UNA VARIABLE CON EL NUMERO 'A' EN SS:[BP+6]
	;Y EL OFFSET DEL NUMERO 'B' EN SS:[BP+4]
	;LAS VARIABLES CON LOS NUMEROS EN MAIN DEBEN SER DEL TIPO "DW"

	xor ax, ax
	push bp
	mov bp, sp
	push bx
	push si

	mov bx, SS:[BP+6] ;RESCATO OFFSET PRIMER NUMERO
	mov si, SS:[BP+4] ;RESCATO OFFSET SEGUNDO NUMERO

	mov ax, [bx] ;RESCATO EL CONTENIDO DEL PRIMER NUMERO
	mov bx, [si] ;RESCATO EL CONTENIDO DEL SEGUNDO NUMERO

	add ax, bx
	;EL RESULTADO VUELVE EN AX, ASI QUE NO POPEAMOS EL REGISTRO

	pop si
	pop bx
	pop bp
	ret 4
	funcionSumar endp

;-------------------------------------------------------------------------------------------
;							10) BORRAR ESPACIOS DE UN TEXTO
;-------------------------------------------------------------------------------------------

	quitarEspacios proc
	;ESTA FUNCION RECIBE EL OFFSET DE UN TEXTO EN SS:[BP+6]
	;Y EN SS:[BP+4] RECIBE EL TEXTO QUE IRA CARGANDO UNA COPIA DEL PRIMERO PERO SIN ESPACIOS

	push bp
	mov bp, sp
	push bx
	push si
	push ax

	mov bx, SS:[BP+6] ;RESCATO OFFSET DEL TEXTO
	mov si, SS:[BP+4] ;RESCATO TEXTO QUE NO CARGARA ESPACIOS

procesoQuitaespacios:
	cmp byte ptr [bx], 24h
	je finProcesoQuitaespacios
	cmp byte ptr [bx], ' '
	je esEspacio
	mov al, byte ptr [bx]
	mov byte ptr [si], al
	inc bx
	inc si
jmp procesoQuitaespacios

esEspacio:
	inc bx
jmp procesoQuitaespacios

finProcesoQuitaespacios:
	mov byte ptr [bx], '$'

	pop ax
	pop si
	pop bx
	pop bp
	ret 4
	quitarEspacios endp

end
