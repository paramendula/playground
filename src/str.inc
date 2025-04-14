
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

; ds: for s1
; si: s1
; es: for s2
; di: s2
; -> zf if equal, not zf if not equal
strcmp:
    push ax
    push bx

    mov ax, 0
    mov bx, 0
.loop:
    mov al, BYTE ds:[si]
    mov bl, BYTE es:[di]
    sub ax, bx
    jnz .done
    cmp bx, 0
    je .done
    inc si
    inc di
    jmp .loop
.done:
    pop bx
    pop ax
    ret

; si: str
; bx: base
; -> cx: attempt (0 if wrong)
atoi:

ret

; ax: number
; bx: base
; di: buffer
; -> cx: str length
itoa:
    push dx

    mov cx, bx
    mov bx, 0
.loop:
    mov dx, 0
    cmp ax, 0x0
    je .zero

    div cx
.zero:
    cmp dx, 9
    jg .big
    add dx, '0'
    jmp .other
.big:
    sub dx, 10
    add dx, 'A'
.other:
    mov BYTE di[bx], dl
    inc bx
    cmp ax, 0
    je .end
    jmp .loop
.end:
    mov dx, 0
    mov ax, bx
    mov cx, 2
    div cx
    mov dx, bx
    mov bx, 0
    mov si, di
    add si, dx
    dec si
.rev_loop:
    cmp bx, ax
    je .total_end
    mov cl, byte [si]
    push cx
    mov cl, byte di[bx]
    mov byte [si], cl
    pop cx
    mov byte di[bx], cl
    inc bx
    dec si
    jmp .rev_loop
.total_end:
    mov bx, dx
    mov byte di[bx], 0
    mov cx, bx

    pop dx
    ret
