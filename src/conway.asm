section .data
    
    hop db 10, 0
    one db '1', 0
    zero db '0', 0
    blanc db ' ', 0
    none db '9', 0
    grid db 1, 1 ,0, 0, 0
            db 0, 0, 0, 1, 0
            db 0, 1, 0, 0, 0
            db 1, 1, 1, 1, 1
            db 0, 1, 1, 0, 1

section .bss
    neighbour_count resb 1
    next_grid resb 25 
    
section .text
    global _start

_start:
    call printer
    call deadspace
    call check_neighbours
    call copy_grid
    call printer
    call ejected

printer:
    xor esi, esi

    print_row:
        cmp esi, 5
        jge printed
        xor edi, edi

    print_col:
        cmp edi, 5
        jge next_r

        ; indice del arr[][]
        mov ebx, esi
        imul ebx, 5
        add ebx, edi

        ; analizo si es 0 y salto o 1 e imprimo
        mov al, [grid + ebx]
        cmp al, 0
        je print_zero

        ; era 1
        mov eax, 4      
        mov ebx, 1      
        mov ecx, one
        mov edx, 1
        int 0x80

        ; Imprimir espacio
        mov eax, 4
        mov ebx, 1
        mov ecx, blanc
        mov edx, 1
        int 0x80

        jmp advance_col

    print_zero:
        mov eax, 4      
        mov ebx, 1     
        mov ecx, zero
        mov edx, 1
        int 0x80

        ; Imprimir espacio
        mov eax, 4
        mov ebx, 1
        mov ecx, blanc
        mov edx, 1
        int 0x80

    advance_col:
        inc edi
        jmp print_col

    next_r:
        mov eax, 4      
        mov ebx, 1       
        mov ecx, hop
        mov edx, 1
        int 0x80

        inc esi
        jmp print_row

    printed:
        ret

check_neighbours:
    ; fila (y)
    xor esi, esi 
    ; columna (x)
    xor edi, edi 

next_cell:
    cmp esi, 5
    jge finish_check
    cmp edi, 5
    jge next_row

    ; resetear contador de vecinos
    mov byte [neighbour_count], 0

    push esi
    push edi
    call count_neighbours
    pop edi
    pop esi

    call apply_rules

    inc edi
    jmp next_cell

next_row:
    inc esi
    xor edi, edi
    jmp next_cell

finish_check:
    ret

count_neighbours:
    push esi
    push edi

    mov ecx, -1
outer_loop:
    cmp ecx, 2
    jge end_count

    mov edx, -1
inner_loop:
    cmp edx, 2
    jge next_outer

    cmp ecx, 0
    jne check_cell
    cmp edx, 0
    jne check_cell
    jmp skip_center

check_cell:
    ; calcular fila y columna del vecino
    mov eax, esi
    add eax, ecx
    cmp eax, 0
    jl skip_neighbor
    cmp eax, 4
    jg skip_neighbor

    mov ebx, edi
    add ebx, edx
    cmp ebx, 0
    jl skip_neighbor
    cmp ebx, 4
    jg skip_neighbor

    push edi
    mov edi, eax
    imul eax, 5
    add eax, ebx
    mov bl, [grid + eax]
    cmp bl, 1
    jne restore_edi

    ; vecino vivo, incrementar contador
    mov al, [neighbour_count]
    inc al
    mov [neighbour_count], al

restore_edi:
    pop edi            

skip_neighbor:
    inc edx
    jmp inner_loop

skip_center:
    inc edx
    jmp inner_loop

next_outer:
    inc ecx
    jmp outer_loop

end_count:
    pop edi
    pop esi
    ret

apply_rules:
    mov eax, esi
    imul eax, 5
    add eax, edi

    ; estado actual (0 o 1)
    mov bl, [grid + eax] 
    mov cl, [neighbour_count]

    cmp bl, 1 
    je cell_was_alive

cell_was_dead:
    cmp cl, 3
    jne rule_done
    mov byte [next_grid + eax], 1
    jmp rule_done

cell_was_alive:
    cmp cl, 2
    je survives
    cmp cl, 3
    je survives
    
    mov byte [next_grid + eax], 0
    jmp rule_done

survives:
    mov byte [next_grid + eax], 1

rule_done:
    ret

copy_grid:
    xor ecx, ecx    

copy_loop:
    cmp ecx, 25
    jge copy_done

    mov al, [next_grid + ecx]
    mov [grid + ecx], al

    inc ecx
    jmp copy_loop

copy_done:
    ret


delimiter:
    ; si row < 0 esta afuera
    cmp esi, 0
    jl outlander

    ; si col < 0 esta afuera
    cmp edi, 0
    jl outlander

    ; si row > 4 esta afuera
    cmp esi, 4
    jg outlander

    ; si col > 4 esta afuera
    cmp edi, 4
    jg outlander

    ret

outlander:
    mov eax, 4      
    mov ebx, 1       
    mov ecx, blanc
    mov edx, 1
    int 0x80
    ret


    call ejected
    
deadspace:
    mov eax, 4      
    mov ebx, 1       
    mov ecx, hop
    mov edx, 1
    int 0x80

    pop ebp


ejected:
    call printer
    mov eax, 1
    xor ebx, ebx
    int 0x80