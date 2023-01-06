DrawNumPartyMonsIcon: ; 0xdc7c
; Draws the number of party Pokemon on the left side of the score bar on the bottom of the screen.
	ld hl, wBottomMessageBuffer + $40
	ld a, $83
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $81
	ld [hl], a
	ld a, [wNumPartyMons]
	call ConvertHexByteToDecWord
	ld hl, wBottomMessageBuffer + $41
	ld c, $1
	ld a, d
	call .drawDigit
	ld a, e
	swap a
	call .drawDigit
	ld a, e
	ld c, $0
.drawDigit
	and $f
	jr nz, .asm_dca7
	ld a, c
	and a
	ret nz
.asm_dca7
	ld c, $0
	add $86
	ld [hli], a
	ret

UnusedData_dcad:
; BCD powers of 2
; unused
	db $01, $02, $04, $08, $16, $32, $64
