
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
