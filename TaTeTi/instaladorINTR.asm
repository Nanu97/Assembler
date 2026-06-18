.8086
.model tiny
.code
   org 100h
start:
   jmp main

;------------------------------------------------------------------------
;- Parte que queda residente en memoria (ISR)
;------------------------------------------------------------------------
ganador PROC FAR
    push ax
    push dx
    push ds

    mov ax, cs      
    mov ds, ax

    ; Imprime únicamente el cartel estático
    mov ah, 09h
    mov dx, offset CartelGanador
    int 21h

    pop ds
    pop dx
    pop ax
    iret
ganador endp

;------------------------------------------------------------------------
; Datos USADOS por la ISR (Tienen que quedar residentes)
;------------------------------------------------------------------------
DespIntXX dw 0
SegIntXX  dw 0

CartelGanador DB 0dh, 0ah
              DB "  ==============",0dh,0ah
              DB "  | GANADOR: ", 24h

FinResidente LABEL BYTE

;------------------------------------------------------------------------
; Datos de instalación
;------------------------------------------------------------------------
Cartel        DB "Programa Instalado exitosamente!!!", 0dh, 0ah, '$'

main:                    
    mov ax, CS
    mov DS, ax
    mov ES, ax

InstalarInt:
    mov AX, 3580h        
    int 21h    
         
    mov DespIntXX, BX    
    mov SegIntXX, ES

    mov AX, 2580h        
    mov DX, Offset ganador
    int 21h

MostrarCartel:
    mov dx, offset Cartel
    mov ah, 9
    int 21h

DejarResidente:     
    mov     AX, (15 + offset FinResidente) 
    shr     AX, 1        
    shr     AX, 1        
    shr     AX, 1        
    shr     AX, 1
    mov     DX, AX           
    mov     AX, 3100h    
    int     21h         
end start
