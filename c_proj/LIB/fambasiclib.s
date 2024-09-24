.export _read_keyboard_state



; Keyboard buffer variable at $0634 in RAM
KEYBOARD_STATE: .res 9, $00
MODIFIER_HELD = $18  ; New variable to track modifier state

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

