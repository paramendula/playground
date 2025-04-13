[org 0x0900]
[bits 16]

; Memory Layout
; 0x00500 - 0x07E00: kernel code
; 0x07E00 - 0x70000: heap
; 0x70000 - 0x7FFFF: kernel stack

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

    call cursor_get
    dec dl
    call cursor_set

    pop cx

    dec cx
    mov di, cx
    mov BYTE input_buffer[di], 0
    mov WORD [input_len], cx

    jmp .loop

input_buffer times 128 db 0
input_len dw 0x0
input_cap dw 127
msg db "***8086 Playground Kernel***", 0
prompt db "/>", 0
prompt_len dw ($ - prompt - 1)
heap_top dw 0x0000, 0x7E00
heap_bot dw 0x7000, 0x0000
; word: STR, dd NEXT, dd CODE
ping_str db "ping", 0
ping_str_other db "pong!", 0
ping_str_other_len equ ($ - ping_str_other)
ping_word:
    dd ping_str
    dd 0x0
    dd ping_code
first_word: dd ping_word

ping_code:
    push si
    push cx
    mov si, ping_str
    mov cx, ping_str_other_len
    call print_string_cursor
    call newline
    pop cx
    pop si
    ret

newline:
    push ax
    push cx

    mov al, 0x0D ; SPACE
    mov cx, 1
    call print_char

    mov al, 0x0A ; SPACE
    call print_char

    pop cx
    pop ax
    ret

print_prompt:
    push cx
    push si

    mov si, prompt
    mov cx, [prompt_len]
    call print_string_cursor

    pop si
    pop cx
    ret

; si: word str, 0 end
pword:
    push ax
    push cx

    mov al, '!'
    call teletype

    push si
    call strlen
    pop si

    call print_string_cursor

    mov al, '!'
    call teletype

    call newline

    pop cx
    pop ax
    ret

command:
    push ax
    push bx
    push si
    push di

    mov si, input_buffer
    mov di, si
    mov bx, 0x20

    cld
.loop:
    lodsb
    cmp al, 0
    je .word

    cmp al, 0x20 ; ' '
    jne .next
    cmp al, bl
    je .same
    mov BYTE [si - 1], 0
    jmp .word

    jmp .loop
.next:
    mov bl, al
    jmp .loop
.word:
    cmp bl, 0x20
    je .end

    push si
    mov si, di
    call pword
    pop si

    cmp al, 0
    je .end

    mov bx, 0x20
    mov di, si

    jmp .loop
.same:
    inc si
    mov di, si
    jmp .loop
.end:
    pop di
    pop si
    pop bx
    pop ax
    ret

; al: desired video mode
video_set:
    mov ah, 0
    int 0x10
    ret

; dh: row
; dl: column
cursor_set:
    push ax
    push bx
    mov ah, 0x02
    mov bh, 0x0
    int 0x10
    pop bx
    pop ax
    ret

; ch: start scan line
; cl: end scan line
; dh: row
; dl: column
cursor_get:
    push ax
    push bx
    mov ah, 0x03
    mov bx, 0
    int 0x10
    pop bx
    pop ax
    ret

; si: str
; -> cx: str len
strlen:
    push ax
    mov cx, 0
    cld
.loop:
    lodsb
    cmp al, 0
    je .done
    inc cx
    jmp .loop
.done:
    pop ax
    ret

; si: str
; dh: row
; dl: column
; cx: str len
print_string:
    push ax
    push bx
    push bp
    mov bp, si
    mov ah, 0x13
    mov al, 0
    mov bh, 0
    mov bl, 7
    int 0x10
    pop bp
    pop bx
    pop ax
    ret

; si: str
; cx: str len
print_string_cursor:
    push ax
    push bx
    push bp
    push dx

    push cx
    call cursor_get
    pop cx

    mov bp, si
    mov ah, 0x13
    mov al, 0
    mov bh, 0
    mov bl, 7
    int 0x10

    add dl, cl
    call cursor_set

    pop dx
    pop bp
    pop bx
    pop ax
    ret

; al: char
teletype:
    push bx
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0
    int 0x10
    pop bx
    ret

; al: char
; cx: number of times
print_char:
    push bx
    mov bh, 0
    mov bl, 0
    int 0x10
    pop bx
    ret

; -> ah: bios scan node
;    al: ascii character
get_key:
    mov ah, 0
    int 0x16
    ret

; zf set if no keystroke available
; zf clear if keystroke available
; -> ah?: bios scan code
;    al?: ascii character
check_key:
    mov ah, 01h
    int 0x16
    ret
