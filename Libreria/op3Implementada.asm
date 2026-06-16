.8086
.model small
.stack 100h
.data
	menu         db "MENU PRINCIPAL",0dh,0ah
		         db "--------------",0dh,0ah
		         db "1)Leer texto principal",0dh,0ah
		         db "2)Leer lista de caracteres",0dh,0ah
		         db "3)Mostrar apariciones",0dh,0ah
		         db "4)Mostrar longitud en decimal",0dh,0ah
		         db "5)Mostrar longitud en binario",0dh,0ah
		         db "6)Salir",0dh,0ah
		         db "--------------",0dh,0ah
		         db "Seleccione opcion:",0dh,0ah,24h
	texto        db 255 dup (24h),0dh,0ah,24h
	cartel1A     db "Ingrese un texto (hasta 255 caracteres):",0dh,0ah,24h
	cartel1B     db "Texto cargado correctamente!",0dh,0ah,24h
	cartel2A     db "Ingrese caracteres a buscar:",0dh,0ah,24h
	cartel2B     db "Los caracteres seleccionados aparecen en el texto original una cantidad de:",0dh,0ah,24h
	cantCar      db 0
	asciiCar     db "000",0dh,0ah,24h
	arrayUsuario db 20 dup (24h),3
	long         db 0
	asciilong    db "000",0dh,0ah,24h
	cartel4A     db "Cantidad de caracteres en decimal:",0dh,0ah,24h
	cartelSalida db "Gracias por tanto, perdon por tan poco!",0dh,0ah,24h

.code
extrn cargaTexto:proc
extrn imprimo:proc
extrn saltarin:proc
extrn contarCosas:proc
extrn r2a:proc
extrn cuentaIndividual:proc

	main proc

	mov ax, @data
	mov ds, ax

menuPrincipal:

	call saltarin
	
	lea bx, menu
	push bx
	call imprimo

	mov ah, 1
	int 21h

	cmp al, '1'
	je opcion1

	cmp al, '2'
	je opcion2

	cmp al, '3'
	jne noEs3
	jmp opcion3
noEs3:

	cmp al, '4'
	jne noEs4
	jmp opcion4
noEs4:

	cmp al, '5'
	jne noEs5
	jmp opcion5
noEs5:

	cmp al, '6'
	jne noSalir
	jmp salida
noSalir:

opcion1:
	call saltarin

	lea bx, cartel1A
	push bx
	call imprimo

	lea bx, texto
	push bx
	call cargaTexto

	call saltarin

	lea bx, cartel1B
	push bx
	call imprimo

jmp menuPrincipal	

opcion2:
	call saltarin

	lea bx, cartel2A
	push bx
	call imprimo

	call saltarin

	lea bx, arrayUsuario
	push bx
	call cargaTexto

	mov cantCar, 0
	mov byte ptr asciiCar, '0'
	mov byte ptr asciiCar+1, '0'
	mov byte ptr asciiCar+2, '0'

	lea bx, texto
	push bx
	lea bx, arrayUsuario
	push bx
	lea bx, cantCar
	push bx
	call contarCosas

	mov dl, cantCar
	lea bx, asciiCar
	call r2a

	call saltarin

	lea bx, cartel2B
	push bx
	call imprimo

	call saltarin

	lea bx, asciiCar
	push bx
	call imprimo

jmp menuPrincipal

opcion3:
    call saltarin

    ; Usamos SI para recorrer la lista de caracteres del usuario
    lea si, arrayUsuario 

ciclo_lista_op3:
    ; --- 1. VALIDAR FIN DE LA LISTA (Múltiples resguardos) ---
    cmp byte ptr [si], 3      ; ¿Llegamos al fin físico del array (EOT / 3)?
    je fin_opcion3
    cmp byte ptr [si], 0Dh    ; ¿Es el Enter que dejó la función cargaTexto?
    je fin_opcion3
    cmp byte ptr [si], 24h    ; ¿Llegamos a las posiciones vacías con '$'?
    je fin_opcion3

    ; --- 2. LIMPIAR EL CONTADOR PARA ESTA LETRA ---
    mov cantCar, 0

    ; --- 3. PASAR PARÁMETROS POR STACK Y LLAMAR A TU FUNCIÓN ---
    lea bx, texto
    push bx                   ; SS:[BP+8] -> Texto principal
    push si                   ; SS:[BP+6] -> Offset del caracter actual de la lista
    lea bx, cantCar
    push bx                   ; SS:[BP+4] -> Offset del contador
    
    call cuentaIndividual     ; Al volver, 'cantCar' tiene el número puro

    ; --- 4. CONVERTIR EL RESULTADO A ASCII ---
    mov byte ptr [asciiCar], '0'
    mov byte ptr [asciiCar+1], '0'
    mov byte ptr [asciiCar+2], '0'

    mov dl, cantCar           ; DL = El número binario a convertir
    lea bx, asciiCar          ; BX = El string de destino
    call r2a                  

    ; --- 5. IMPRIMIR EL CARÁCTER Y SU CANTIDAD ---
    mov dl, [si]
    mov ah, 02h               ; Función DOS: Imprimir un carácter individual
    int 21h

    mov dl, ':'               ; Imprimimos los dos puntos
    int 21h
    mov dl, ' '               ; Imprimimos el espacio
    int 21h

    lea dx, asciiCar          ; Imprimimos "000" + salto de línea
    mov ah, 09h               
    int 21h

    ; --- 6. AVANZAR AL SIGUIENTE CARÁCTER DE LA LISTA ---
    inc si                    
    jmp ciclo_lista_op3

fin_opcion3:
    jmp menuPrincipal

opcion4:
	call saltarin

	mov long, 0
	mov byte ptr asciiLong, '0'
	mov byte ptr asciiLong+1, '0'
	mov byte ptr asciiLong+2, '0'

	lea bx, texto
	push bx
	lea bx, texto
	push bx
	lea bx, long
	push bx
	call contarCosas

	mov dl, long
	lea bx, asciiLong
	call r2a

	call saltarin

	lea bx, cartel4A
	push bx
	call imprimo

	call saltarin

	lea bx, asciiLong
	push bx
	call imprimo

jmp menuPrincipal

opcion5:

jmp menuPrincipal

salida:
	call saltarin

	lea bx, cartelSalida
	push bx
	call imprimo

	mov ax, 4c00h
	int 21h

	main endp
end
