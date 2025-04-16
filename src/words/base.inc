stack_print_code:
    push ax
    push bx
    push cx
    push di
    push si
    push es

    call pstack_pop_ax

    mov bx, 10
    mov cx, 0
    mov es, cx
    mov di, temp_buffer
    call itoa

    mov si, temp_buffer
    call print_string_cursor

    mov al, ' '
    call teletype

    pop es
    pop si
    pop di
    pop cx
    pop bx
    pop ax
    retf

plus_code:
    push bx
    push ax

    call pstack_pop_ax
    mov bx, ax
    call pstack_pop_ax
    add ax, bx
    call pstack_push_ax

    pop ax
    pop bx
    retf

minus_code:
    push bx
    push ax

    call pstack_pop_ax
    mov bx, ax
    call pstack_pop_ax
    sub ax, bx
    call pstack_push_ax

    pop ax
    pop bx
    retf

stack_print_word:
    dw stack_print_str, 0x0
    dw plus_word, 0x0
    dw stack_print_code, 0x0

plus_word:
    dw plus_str, 0x0
    dw minus_word, 0x0
    dw plus_code, 0x0

minus_word:
    dw minus_str, 0x0
    dd 0x0
    dw minus_code, 0x0
