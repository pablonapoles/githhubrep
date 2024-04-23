;Ejercicio 11
;Realice un programa en ASM que permita entrar solo letras (en color rojo y fondo amarillo),
;si se entra un carácter que no se letra, se mostrará en color azul y fondo verde.

DOSSEG
.MODEL SMALL
.DATA
    CARACTER db ?
    ATRIBUTO_LETRA db 11100100B  ; Fondo amarillo y color de letra rojo
    ATRIBUTO_OTRO db 00100001B  ; Fondo verde y color de letra azul

.CODE
PRINC PROC NEAR
    MOV AX,@DATA
    MOV DS,AX

    MOV AH,0
    MOV AL,3             ; Estableciendo el modo 3 de video texto
    INT 10H

    MOV AX,0B800H        ; Me ubico en la memoria de video.
    MOV ES,AX
    MOV DI,0             ; Offset=0 para direccionar la memoria de video B800:0000H

    LOOP_INICIO:
        MOV AH,7         ; Leer un carácter desde la entrada estándar con eco
        INT 21H
        MOV CARACTER, AL ; Guardar el carácter ingresado en la variable CARACTER

        ; Verificar si el carácter ingresado es una letra
        MOV AH, CARACTER
        CMP AH, 'a'      ; Comprobar si es al menos 'a'
        JB NO_ES_LETRA   ; Si el carácter es menor que 'a', no es una letra
        CMP AH, 'z'      ; Comprobar si es menor o igual que 'z'
        JA NO_ES_LETRA   ; Si el carácter es mayor que 'z', no es una letra

        ; Si el carácter es una letra, mostrarla en rojo con fondo amarillo
        MOV AH, ATRIBUTO_LETRA ; Atributo: fondo amarillo y letra rojo
        JMP MOSTRAR_CARACTER

    NO_ES_LETRA:
        ; Si el carácter no es una letra, mostrarlo en azul con fondo verde
        MOV AH, ATRIBUTO_OTRO   ; Atributo: fondo verde y letra azul

    MOSTRAR_CARACTER:
        MOV AL, CARACTER  ; Carácter a mostrar
        MOV ES:[DI], AX   ; Mostrar el carácter en la pantalla

        ; Avanzar al siguiente espacio en la pantalla
        ADD DI, 2

        ; Salir del bucle si se presiona la tecla Enter (código ASCII 13)
        CMP AL, 13
        JE FIN_PROGRAMA

        JMP LOOP_INICIO

    FIN_PROGRAMA:
        MOV AH, 7         ; Se espera por una tecla para continuar el programa.
        INT 21H
        MOV AX, 4C00H     ; Se termina el programa
        INT 21H

PRINC ENDP
END
