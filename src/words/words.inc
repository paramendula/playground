%include "src/words/ping.inc"
%include "src/words/base.inc"

load_words:
    push ax
    push bx
    push cx
    push si

    mov si, words_list
    mov ax, WORD [si]
    mov WORD [first_word], ax

    mov cx, words_count
    dec cx
.loop:
    lodsw
    mov bx, WORD [si]
    xchg ax, bx
    mov [bx+4], ax

    loop .loop

    pop si
    pop cx
    pop bx
    pop ax

    ret
