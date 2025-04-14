input_buffer times 128 db 0
input_len dw 0x0
input_cap dw 127

temp_buffer:
    times 127 db 'M'
    db 0
temp_cap equ ($ - temp_buffer)

msg db "***8086 Playground Kernel***", 0

msg_equal db "equal", 0
msg_equal_len equ ($ - msg_equal - 1)
msg_inequal db "inequal", 0
msg_inequal_len equ ($ - msg_inequal - 1)

prompt db "/>", 0
prompt_len dw ($ - prompt - 1)

heap_top dw 0x0000, 0x7E00
heap_bot dw 0x7000, 0x0000

; word: dd STR, dd NEXT, dd CODE
ping_str db "ping", 0
ping_str_other db "pong!", 0
ping_str_other_len equ ($ - ping_str_other)
ping_word:
    dd ping_str
    dd 0x0
    dd ping_code

first_word:
    dd ping_word
