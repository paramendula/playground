section .data

input_buffer times 128 db 0
input_len dw 0x0
input_cap dw 127

temp_buffer times 128 db 0
temp_buffer_cap equ ($ - temp_buffer)

msg db "***8086 Playground Kernel***", 0

prompt db "/>", 0
prompt_len dw ($ - prompt - 1)

pheap_bot dw 0x07E00, 0x1000
pheap_top dw 0x00000, 0x7000
pheap_cur dw 0x07E00, 0x0000

pstack_bot dw 0x7E00, 0x0000
pstack_top dw 0x7E00, 0x1000
pstack_cur dw 0x7E00, 0x1000

%include "src/words/words_data.inc"

first_word:
    dw ping_word, 0x0
