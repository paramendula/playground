; ax: arg
pstack_push_ax:
    push bx
    push es
    push cx

    mov bx, word [pstack_cur]

    cmp bx, 0x0000
    je .under
    mov cx, bx
    mov bx, word [pstack_cur+2]
    mov es, bx
    mov bx, cx
    sub bx, 2
    jmp .left
.under:
    mov bx, 0x0000
    mov word [pstack_cur+2], bx
    mov es, bx
    mov bx, 0xFFFE
.left:
    mov word [pstack_cur], bx
    mov word [es:bx], ax

    pop cx
    pop es
    pop bx

    ret

; -> ax
pstack_pop_ax:
    push bx
    push es

    mov bx, word [pstack_cur+2]
    mov es, bx
    mov bx, word [pstack_cur]

    mov ax, word [es:bx]

    cmp bx, 0xFFFE
    je .over
    add bx, 2
    jmp .left
.over:
    mov bx, 0x1000
    mov word [pstack_cur+2], bx
    mov bx, 0x0000
.left:
    mov word [pstack_cur], bx

    pop es
    pop bx

    ret

; -> ax
pstack_peek_ax:
    push bx
    push es

    mov bx, word [pstack_cur+2]
    mov es, bx
    mov bx, word [pstack_cur]

    mov ax, word [es:bx]

    pop es
    pop bx

    ret
