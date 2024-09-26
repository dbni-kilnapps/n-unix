.export _read_keyboard_state, _put_char


GREY: .byte $00, $10, $20, $30
AZURE: .byte $01, $11, $21, $31
BLUE: .byte $02, $12, $22, $32
VIOLET: .byte $03, $13, $23, $33
MAGENTA: .byte $04, $14, $24, $34
ROSE: .byte $05, $15, $25, $35
RED: .byte $06, $16, $26, $36
ORANGE: .byte $07, $17, $27, $37
YELLOW: .byte $08, $18, $28, $38
CHARTREUSE: .byte $09, $19, $29, $39
GREEN: .byte $0a, $1a, $2a, $3a
SPRING: .byte $0b, $1b, $2b, $3b
CYAN: .byte $0c, $1c, $2c, $3c

.segment "ZEROPAGE"
; Keyboard buffer variable at $0634 in RAM
KEYBOARD_STATE: .res 9
MODIFIER_HELD: .res 1 ; New variable to track modifier state

CURSOR_POS: .res 2
PPUADDR_OFFSET: .res 2
HIGHLIGHTED_CHAR: .res 1

.segment "CODE"

_put_char:
    sta $2006
    sty $2006
    sta $2007
    rts

; Family BASIC Routines
_read_keyboard_state:
    ldx #0 ; Loop counter
    lda #5 ; Reset matrix to 0,0
    sta $4016
@poll_loop:
    lda #4 ; Select column 0, row n
    sta $4016
    lda $4017
    lsr A
    and #$0F
    asl A
    asl A
    asl A
    asl A
    sta KEYBOARD_STATE, X

    lda #6 ; Select column 1, row n
    sta $4016
    lda $4017
    rol A
    rol A
    rol A
    and #$F0
    lsr A
    lsr A
    lsr A
    lsr A
    ora KEYBOARD_STATE, X ; Merge with previous column
    eor #$FF
    sta KEYBOARD_STATE, X

    inx
    cpx #8
    bne @poll_loop
    rts

