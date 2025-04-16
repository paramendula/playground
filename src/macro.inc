; For debugging purposes

%macro M_print_reg 2
    push ax
    push bx
    push cx
    push di
    push si
    push es

    mov ax, %1
    mov bx, %2
    mov cx, 0
    mov es, cx
    mov di, temp_buffer
    call itoa

    mov si, temp_buffer
    call print_string_cursor

    mov al, ';'
    call teletype

    pop es
    pop si
    pop di
    pop cx
    pop bx
    pop ax
%endmacro

%macro M_print_str 1
    push si
    push ax
    push cx

    mov si, %1
    push si
    call strlen
    pop si

    call print_string_cursor

    mov al, ';'
    call teletype

    pop cx
    pop ax
    pop si
%endmacro

%macro M_print_var 2
    push bx

    mov bx, [%1]
    M_print_reg bx, %2

    pop bx
%endmacro
