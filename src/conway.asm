global get_matrix
global next_gen

section .data 
    matrix:
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,1,0,0,0,0,0
        db 1,1,1,0,1,0,0,0,0,0
        db 0,0,0,0,1,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0
        db 0,0,0,0,0,0,0,0,0,0

    next_matrix times 100 db 0

section .text

get_matrix:
    mov rax, matrix
    ret

next_gen:
    call siguienteGen
    call matrizCopy
    ret

siguienteGen:
    ;se guardan registros usados
    push rbx
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    xor rbx, rbx
.outer_loop:
    cmp rbx, 100
    jge .done
    mov rax, rbx
    mov rcx, 10
    xor rdx, rdx
    div rcx
    mov r8, rax ; fila
    mov r9, rdx ; columna
    xor r10, r10 ; contador de vecinos
    mov r11, -1 

.vecinosY:
    cmp r11, 1
    jg .condiciones
    mov r12, -1  
.vecinosX:
    cmp r12, 1
    jg .inc_y
    cmp r11, 0
    jne .not_self
    cmp r12, 0
    jne .not_self
    jmp .sigVecino

.not_self:
    mov r13, r8
    add r13, r11
    mov r14, r9
    add r14, r12
    cmp r13, 0
    jl .sigVecino
    cmp r13, 9
    jg .sigVecino
    cmp r14, 0
    jl .sigVecino
    cmp r14, 9
    jg .sigVecino
    mov rax, r13
    mov rcx, 10
    mul rcx
    add rax, r14
    mov al, [matrix + rax]
    cmp al, 1
    jne .sigVecino
    inc r10

.sigVecino:
    inc r12
    jmp .vecinosX

.inc_y:
    inc r11
    jmp .vecinosY

.condiciones:
    mov al, [matrix + rbx]
    cmp al, 1
    jne .condicionDead
    cmp r10, 2
    je .vive
    cmp r10, 3
    je .vive
    jmp .muere

.condicionDead:
    cmp r10, 3
    je .vive
    jmp .muere

.vive:
    mov byte [next_matrix + rbx], 1
    jmp .sigCel

.muere:
    mov byte [next_matrix + rbx], 0

.sigCel:
    inc rbx
    jmp .outer_loop

.done:
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop rbx
    ret

matrizCopy:
    push rcx
    push rax

    xor rcx, rcx
.copy_loop:
    cmp rcx, 100
    jge .done_copy
    mov al, [next_matrix + rcx]
    mov [matrix + rcx], al
    inc rcx
    jmp .copy_loop

.done_copy:
    pop rax
    pop rcx
    ret

