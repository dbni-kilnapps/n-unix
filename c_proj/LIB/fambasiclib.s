.export _read_keyboard_procedure



.segment "ZP"
; Keyboard buffer variable at $0634 in RAM
KEYBOARD_STATE = $0634
MODIFIER_HELD = $18  ; New variable to track modifier state


.segment "HEADER"
    .byte $4E,$45,$53,$1A
    .byte $02 ; PRG Banks
    .byte $01 ; CHR Banks
    .byte $03 ; Flags
    .byte $00&$F0 ; Mapper
    .res 8,0

.segment "STARTUP"
irq:
reset:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
  stx $4017	; disable APU frame IRQ
  ldx #$ff 	; Set up stack
  txs		;  .
  inx		; now X = 0
  stx $2000	; disable NMI
  stx $2001 	; disable rendering
  stx $4010 	; disable DMC IRQs

;; first wait for vblank to make sure PPU is ready
vblankwait1:
  bit $2002
  bpl vblankwait1

clear_memory:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne clear_memory

;; second wait for vblank, PPU is ready after this
vblankwait2:
  bit $2002
  bpl vblankwait2

main:
load_palettes:
  lda $2002
  lda #$3f
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
@loop:
  lda palettes, x
  sta $2007
  inx
  cpx #$20
  bne @loop

enable_rendering:
  lda #%10000000	; Enable NMI
  sta $2000
  lda #%00010000	; Enable Sprites
  sta $2001


.segment "CODE"

forever:
    jsr _read_keyboard_procedure
    jmp forever

nmi:
    rti
; -------- read_keyboard_procedure --------
_read_keyboard_procedure:
    LDX #$00                 ; Initialize X to 0 (row/column index)

@keyboard_read_loop:
    LDA #$05                 ; Reset to column 0
    STA $4016                ; Write to $4016 (reset to row 0, column 0)
    
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    
    LDA #$04                 ; Increment to next row
    STA $4016                ; Write to $4016 (select column 0)
    LDY #$0A                 ; Initialize Y for delay
    
@get_column_0_state:
    DEY                      ; Delay loop
    BNE @get_column_0_state   ; Continue until Y = 0
    
    NOP
    NOP
    
    LDA $4017                ; Read column 0 data from $4017
    LSR A                    ; Shift right (optional, depending on your data format)
    AND #$0F                 ; Mask to keep only the lower 4 bits
    STA KEYBOARD_STATE,X        ; Store the result in the buffer at $0634
    
    LDA #$06                 ; Select column 1
    STA $4016                ; Write to $4016 (select column 1)
    LDY #$0A                 ; Initialize Y for delay
    
@get_column_1_state:
    DEY                      ; Delay loop
    BNE @get_column_1_state   ; Continue until Y = 0
    
    NOP
    NOP
    
    LDA $4017                ; Read column 1 data from $4017
    ROL A                    ; Rotate left 3 times to align bits
    ROL A
    ROL A
    AND #$F0                 ; Mask to keep only the upper 4 bits
    ORA KEYBOARD_STATE,X        ; Combine with the previously stored lower bits
    EOR #$FF                 ; Invert the bits if needed
    STA KEYBOARD_STATE,X        ; Store the result in the buffer at $0634
    
    ; Modifier handling - checking for Shift/Ctrl keys
    LDA KEYBOARD_STATE+7     ; Load the state of the keyboard (specifically row 7)
    AND #$10                 ; Check if the Shift (or a modifier) is held (bit 4)
    BNE @store_modifier_state

    LDA KEYBOARD_STATE+7     ; Check if Ctrl or another modifier is held (bit 3)
    AND #$08
    BNE @store_modifier_state

    ; Continue normal loop if no modifiers are detected
    LDA #$00
    STA MODIFIER_HELD         ; Clear the MODIFIER_HELD flag if no modifier is held

    INX                      ; Move to the next buffer position
    CPX #$09                 ; Check if all rows are processed
    BNE @keyboard_read_loop   ; Repeat for the next row/column if not done
    
    RTS                      ; Return from subroutine

@store_modifier_state:
    LDA #$FF                 ; Set the modifier flag to FF if a modifier is held
    STA MODIFIER_HELD         ; Store in MODIFIER_HELD
    RTS                      ; Return from subroutine

palettes:
  ; Background Palette
  .byte $0f, $30, $21, $02
  .byte $0f, $30, $27, $18
  .byte $0f, $30, $27, $16
  .byte $0f, $29, $36, $17

  ; Sprite Palette
  .byte $0f, $30, $21, $02
  .byte $0f, $30, $27, $18
  .byte $0f, $30, $27, $16
  .byte $0f, $29, $36, $17

.segment "VECTORS"
    .word nmi	;$fffa vblank nmi
    .word reset	;$fffc reset
   	.word irq	;$fffe irq / brk


.segment "CHARS"

	.incbin "basic.chr"