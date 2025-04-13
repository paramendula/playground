[org 0x0900]
[bits 16]

; Memory Layout
; 0x00500 - 0x07E00: kernel code
; 0x07E00 - 0x70000: heap
; 0x70000 - 0x7FFFF: kernel stack

start:
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

    jmp .loop
.std:
    cmp al, 0x08 ; BACKSPACE
    je .del

    mov cx, WORD [input_len]
    cmp cx, [input_cap]
    je .loop

    mov di, cx
    mov BYTE input_buffer[di], al
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
heap_top dw 0x0000, 0x7E00
heap_bot dw 0x7000, 0x0000

command:
    call cursor_get

    mov cx, WORD [input_len]
    mov si, input_buffer
    call print_string

    add dl, cl
    call cursor_set

    mov al, '>'
    call teletype

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
