%macro capturar 2
    mov eax, 3
    mov ebx, 0
    mov ecx,%1
    mov edx,%2
    int 80h
    %endmacro
    
%macro imprime 2
    mov eax,4
    mov ebx,1
    mov ecx,%1
    mov edx,%2
    int 80h
    %endmacro
    
    
section .data

    actual db '0'
    
    Salir db 13, 10, 10, "Desea Salir? [Y/n]", 13, 10
    lenSalir equ $-Salir
    
    Bienvendida db "Bienvenido a mi calculadora",10,13
    lenBienvenida equ $-Bienvenida
    
    Msg1 db "Introduzca el numero 1: "
    lenMsg1 equ $-Msg1
    
    Msq2 db "Introduzca el numero 2: "
    lenMsg2 equ $-Msg2
    
    Operacion db "Que operacion deseas hacer (1:Suma, 2:Resta, 3:Multiplicacion, 4:Division): "
    lenOperacion equ $-Operacion
    
    resta db "-"
    lnResta equ $-resta
    
    Introducido db "Operacion: "
    lenIntroducido equ $-Introducido
    
    Error db "Opcion Invalida",10,13
    lenError equ $-Error     
    
    msg9     db    10,'Resultado: ',0
    lmsg9    equ   $ - msg9
    
    nlinea   db    10,10,0
    lnlinea  equ   $ - nlinea
    
    
section .bss


    opcion: resb 2
    num1:   resb 2
    num2:   resb 2
    resultado:resb 2
    simbolo: resb 2
    outputbuffer resb 4
    
section .text

    global_start
    
 _start:
 
    imprime Bienvenida, lenBienvenida
    
    capturaOpcion:
        imprime Operacion, lenOperacion
        capturar opcion, 2
        
    mov al, [opcion]
    cmp al, '1'
    jb capturaOpcion
    cmp al, '4'
    ja capturaOpcion
    
    
    imprime Msg1, lenMsg1
    
    capturar num1, 2
    
    imprime Msg2, lenMsg2
    
    capturar num2, 2     
    
    imprime msg9, lmsg9
    
    
    mov ah, [opcion]
    sub ah, '0'
    
    cmp ah, 1
    je sumar
    
    cmp ah, 2
    je restar
    
    cmp ah, 3
    je multiplicar
    
    cmp ah, 4
    je dividir
    
    jmp salir
    
sumar:

    mov al, [num1]
    mov bl, [num2]
    
    sub al, '0'
    sub bl, '0'
    
    add al, bl
    
    add al, '0'
    
    mov [resultado], al
    
    jmp salir
    
mayor:

    sub al, '0'
    sub bl, '0'
    
    sub bl, al
    
    add bl, '0'
    
    mov [resultado], bl
    
    imprime resta, lnResta
    jmp salir
    
restar:
    
    mov al, [num1]
    mov bl, [num2]
    cmp bl, al
    ja mayor
    
    sub al, '0'
    sub bl, '0'
    
    sub al, bl
    
    add al, '0'
    
    mov [resultado], al
    
    jmp salir
    
multiplicar:

    mov al, [num1]
    mov bl, [num2]
    
    sub al, '0'
    sub bl, '0'
    
    mul bl
    
    add ax, '0'
    
    mov [resultado], ax
    
    jmp salir
    
dividir:

    mov al, [num1]
    mov bl, [num2]
    
    mov dx, 0
    mov ah, 0
    
    sub al, '0'
    sub bl, '0'
    
    div bl
    
    add ax, '0'
    
    mov [resultado], ax
    
    jmp salir
    
salir:

    mov al, [resultado]
    sub al, '0'
    aam
    add ax, 3030h
    mov [outputbuffer], ah
    mov[outputbuffer + 1], al
    mov acx, outputbuffer
    mov edx, 2
    mov ebx, 1
    mov eax, 4
    int 80h
    
    mov eax, 1
    mov bl, [resultado]
    int 80h
    
    imprime Salir, lenSalir
    capturar actual, 2
    
    mov al, [actual]
    cmp al, 'n'
    je _start
    
    mov eax, 1
    mov ebx, 0
    int 80h