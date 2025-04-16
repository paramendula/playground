start:
    ; segments
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; stack
    cli
    mov ax, 0x7000
    mov ss, ax
    mov sp, 0xFFFF
    sti

    ; clear screen
    mov al, 0x03
    call video_set

    ; segments
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; hello world
    mov si, msg
    call strlen

    mov si, msg
    mov dh, 0
    mov dl, 0
    call print_string

    mov dh, 1
    mov dl, 0
    call cursor_set

    call print_prompt

    call load_words

.loop:
    call get_key
    cmp al, 0x0D ; CR
    jne .std

    call teletype

    mov al, 0x0A ; LF
    call teletype

    call command

    mov WORD [input_len], 0
    mov BYTE [input_buffer], 0

    call print_prompt

    jmp .loop
.std:
    cmp al, 0x08 ; BACKSPACE
    je .del

    mov cx, WORD [input_len]
    cmp cx, [input_cap]
    je .loop

    mov di, cx
    mov BYTE input_buffer[di], al
    mov BYTE input_buffer[di+1], 0
    inc cx
    mov WORD [input_len], cx

    call teletype
    jmp .loop
.del:
    mov cx, WORD [input_len]
    cmp cx, 0

    je .loop

    call teletype

    push cx
    mov al, 0x20 ; SPACE
    mov cx, 1
    call print_char

    pop cx

    dec cx
    mov di, cx
    mov BYTE input_buffer[di], 0
    mov WORD [input_len], cx

    jmp .loop
