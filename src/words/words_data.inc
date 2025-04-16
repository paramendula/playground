%include "src/words/ping_data.inc"
%include "src/words/base_data.inc"

words_list:
    dw ping_word
    dw stack_print_word
    dw stack_peek_word
    dw plus_word
    dw minus_word
    dw mul_word
    dw div_word
words_count equ ($ - words_list) / 2
