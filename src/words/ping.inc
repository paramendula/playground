ping_code:
    push si
    push cx
    mov si, ping_str_other
    mov cx, ping_str_other_len
    call print_string_cursor
    call newline
    pop cx
    pop si
    retf

ping_word:
    dw ping_str, 0x0
    dd 0x0
    dw ping_code, 0x0
