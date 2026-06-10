;-----------------------------------------------------------------------
; Programa TSR que se instala en el vector de interrupciones 80h
; Muestra el ganador de un Tateti (recibe el caracter en AL)
; Se debe generar el ejecutable .COM con los siguientes comandos:
;   tasm tsr2.asm
;   tlink /t tsr2.obj
;-----------------------------------------------------------------------
.8086
.model tiny     ; Definicion para generar un archivo .COM
.code
   org 100h     ; Definicion para generar un archivo .COM
start:
   jmp main     ; Comienza con un salto para dejar la parte residente primero

;------------------------------------------------------------------------
;- Parte que queda residente en memoria y contiene las ISR
;------------------------------------------------------------------------
ganador PROC FAR

    push ax
    push dx
    push ds

    mov ax, cs      ; Forzamos a que DS apunte al CS del TSR
    mov ds, ax

    mov fichaGanador, al ; Guarda el caracter que vino en AL

    mov ah, 09h
    mov dx, offset CartelGanador
    int 21h

    mov dl, fichaGanador
    mov ah, 02h
    int 21h

    mov ah, 09h
    mov dx, offset CartelFin
    int 21h

    pop ds
    pop dx
    pop ax

    iret

ganador ENDP

;------------------------------------------------------------------------
; Datos USADOS por la ISR (Tienen que quedar residentes)
;------------------------------------------------------------------------
DespIntXX dw 0
SegIntXX  dw 0

fichaGanador  DB '?'
CartelGanador DB "===========",0dh,0ah
              DB "| GANADOR ",'$'
CartelFin     DB " |",0dh,0ah
              DB "===========",0dh,0ah,'$'

FinResidente LABEL BYTE

;------------------------------------------------------------------------
; Datos a ser usados SOLO por el Instalador (Se pueden liberar)
;------------------------------------------------------------------------
Cartel        DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$'

main:                   
    mov ax,CS
    mov DS,ax
    mov ES,ax

InstalarInt:
    mov AX,3580h        ; Obtiene la ISR original de la INT 80h
    int 21h    
         
    mov DespIntXX,BX    
    mov SegIntXX,ES

    mov AX,2580h        ; Coloca la nueva ISR (ganador) en la INT 80h
    mov DX,Offset ganador
    int 21h

MostrarCartel:
    mov dx, offset Cartel
    mov ah,9
    int 21h

DejarResidente:     
    Mov     AX,(15 + offset FinResidente) ; Sumo 15 para redondear el parágrafo
    Shr     AX,1        
    Shr     AX,1        ; Se obtiene la cantidad de parágrafos
    Shr     AX,1        ; ocupados dividiendo por 16
    Shr     AX,1
    Mov     DX,AX           
    Mov     AX,3100h    ; Termina y deja el código residente
    Int     21h         
end start
