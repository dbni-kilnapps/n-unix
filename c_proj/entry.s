.export __STARTUP__:absolute=1

.import _main

.segment "HEADER"
    .byte $4E,$45,$53,$1A
    .byte $02 ; PRG Banks
    .byte $01 ; CHR Banks
    .byte $03 ; Flags
    .byte $00&$F0 ; Mapper
    .res 8,0


.segment "STARTUP"

.segment "CODE"
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

  jmp _main

  .include "LIB/fambasiclib.s"

nmi:
    rti

.segment "RODATA"
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