
    two     dq 2.0
    dt      dq 0.1    ; Intervalo de tiempo
    d       dq 0.2    ; Distancia al centro
    
    ; Arrays para almacenar datos
    v_right  dq 1.0, 1.2, 1.1  ; Velocidades rueda derecha
    v_left   dq 0.8, 1.0, 0.9  ; Velocidades rueda izquierda
    
    ; Arrays para resultados
    pos_x    times 100 dq 0.0  ; Posiciones x
    pos_y    times 100 dq 0.0  ; Posiciones y
    angles   times 100 dq 0.0  ; Ángulos
    
    ; Variables temporales
    temp    dq 0.0
    v_c     dq 0.0    ; Velocidad del centro
    omega   dq 0.0    ; Velocidad angular
    
section .text
global main

calculate_position:
    ; Preservar registros
    push rbp
    mov rbp, rsp
    
    ; Inicializar índice
    mov rcx, 0
    
    ; Inicializar FPU
    finit
    
calculate_loop:
    ; Calcular Vc = (Vr + Vl)/2
    fld qword [v_right + rcx*8]  ; Cargar Vr
    fadd qword [v_left + rcx*8]  ; Añadir Vl
    fdiv qword [two]             ; Dividir por 2
    fstp qword [v_c]             ; Guardar Vc
    
    ; Calcular omega = (Vr - Vl)/(2*d)
    fld qword [v_right + rcx*8]  ; Cargar Vr
    fsub qword [v_left + rcx*8]  ; Restar Vl
    fld qword [d]                ; Cargar d
    fmul qword [two]             ; Multiplicar por 2
    fdivp                        ; Dividir
    fstp qword [omega]           ; Guardar omega
    
    ; Calcular nueva posición x
    fld qword [pos_x + rcx*8]    ; Cargar x actual
    fld qword [v_c]              ; Cargar Vc
    fld qword [angles + rcx*8]   ; Cargar ángulo actual
    fcos                         ; Calcular coseno
    fmulp                        ; Multiplicar
    fld qword [dt]               ; Cargar dt
    fmulp                        ; Multiplicar
    faddp                        ; Sumar a x actual
    fstp qword [pos_x + rcx*8 + 8] ; Guardar nueva x
    
    ; Calcular nueva posición y
    fld qword [pos_y + rcx*8]    ; Cargar y actual
    fld qword [v_c]              ; Cargar Vc
    fld qword [angles + rcx*8]   ; Cargar ángulo actual
    fsin                         ; Calcular seno
    fmulp                        ; Multiplicar
    fld qword [dt]               ; Cargar dt
    fmulp                        ; Multiplicar
    faddp                        ; Sumar a y actual
    fstp qword [pos_y + rcx*8 + 8] ; Guardar nueva y
    
    ; Calcular nuevo ángulo
    fld qword [angles + rcx*8]   ; Cargar ángulo actual
    fld qword [omega]            ; Cargar omega
    fld qword [dt]               ; Cargar dt
    fmulp                        ; Multiplicar
    faddp                        ; Sumar al ángulo actual
    fstp qword [angles + rcx*8 + 8] ; Guardar nuevo ángulo
    
    ; Incrementar índice y comprobar si hemos terminado
    inc rcx
    cmp rcx, 2                   ; Comparar con número de pasos - 1
    jl calculate_loop
    
    ; Restaurar registros y retornar
    mov rsp, rbp
    pop rbp
    ret

main:
    ; Llamar a la función principal
    call calculate_position
    
    ; Salir del programa
    mov rax, 60                  ; syscall exit
    xor rdi, rdi                ; código de retorno 0
    syscall
