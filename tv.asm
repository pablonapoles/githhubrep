Dosseg
.model small
.data
    cartel db 'Oprima una tecla para pasar a modo gráfico$'

.code
Nombre proc near
    mov AX,@data
    mov DS,AX
    
    mov ax,0b800h
    mov es,ax

    mov di,0
    xor bx,bx
    mov cx,80*25
ciclo:
    mov es:[di],bx
    add di,2
    loop ciclo

    lea si,[cartel]
    mov di,80*10+2*10
    mov bh,11b
repetir:
    mov bl,[si]
    cmp bl, '$'
    je siguiente
    mov es:[di],bx
    add di,2
    inc si
    jmp repetir

siguiente:
    xor ax,ax
    mov ah,0
    int 16h

    XOR AH,AH
    MOV AL,13h
    INT 10H

    MOV AX,0a000H
    MOV ES,AX
    mov ax, 0011h

pintar:
    mov cx,320*200
    mov di,0
LAZO:
    MOV ES:[DI],ax
    add DI,2
    LOOP LAZO

    xor ah, ah
    int 16h

    cmp al, 27 ;ESC
    je fin
    jmp pintar

fin:
    xor ax,ax
    MOV AL,3
    INT 10H

    Mov AX,4C00h
    Int 21h    
Nombre endp
End  
