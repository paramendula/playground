
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
; -> dx=0 if a number, otherwise not a number
atoi:
    push ax

    mov dx, 0
    mov al, [si]
    cmp al, '-'
    jne .no_minus
    mov al, [si+1]
    cmp al, 0
    je .bad
    inc si
    mov dx, 1
.no_minus:
    mov ax, 0
    mov cx, 0
.loop:
    lodsb
    cmp al, 0
    je .end

    cmp al, '0'
    jl .bad
    cmp al, '9'
    jle .digit
    cmp al, 'A'
    jl .bad
    cmp al, 'Z'
    jle .hdigit
    cmp al, 'a'
    jl .bad
    cmp al, 'z'
    jg .bad
    jmp .prehdigit

.digit:
    sub al, '0'
    jmp .left
.prehdigit:
    sub al, 'a'
    add al, 10
    jmp .left
.hdigit:
    sub al, 'A'
    add al, 10
    jmp .left
.bad:
    mov cx, 0
    mov dx, 2
    jmp .end
.left:
    cmp ax, bx
    jge .bad

    push ax
    push dx
    mov ax, cx
    mul bx
    mov cx, ax
    pop dx
    pop ax

    add cx, ax
    jmp .loop
.end:
    cmp dx, 1
    jne .dont_negate
    mov dx, 0
    neg cx
.dont_negate:

    pop ax

    ret

; ax: number
; bx: base
; di: buffer
; -> cx: str length
itoa:
    push dx
    push bp

    mov bp, 0
    cmp bx, 10
    jne .dont_check
    cmp ax, 0
    jge .dont_check
    neg ax
    mov bp, 1
.dont_check:
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
    cmp bp, 0
    je .no_minus
    mov BYTE di[bx], '-'
    inc bx
.no_minus:
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

    pop bp
    pop dx
    ret
