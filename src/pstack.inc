%ifdef NOP
; TODO
pstack_push:
    push es
    push bp
    push ax

    mov es, word [pheap_cur]
    mov bp, word [pheap_cur+2]

    xchg ss, es
    xchg sp, bp

    mov ax, word es:[bp + 6]

    cmp sp, 0x0000
    jne .good
    mov ss, 0x0000
    mov sp, 0xFFFF
    mov [pheap_cur], ss
    mov [pheap_cur+2], 0xFFFD
.good:
    push ax

    xchg ss, es
    xchg sp, bp

    pop ax
    pop bp
    pop es

    add sp, 2

    ret

; -> ax
pstack_pop:
    push es
    push bp

    mov es, word [pheap_cur]
    mov bp, word [pheap_cur+2]

    xchg ss, es
    xchg sp, bp

    pop ax

    xchg ss, es
    xchg sp, bp

    pop bp
    pop es

    ret
%endif
