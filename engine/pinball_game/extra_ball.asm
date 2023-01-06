AddExtraBall: ; 0x30164
	ld a, [wExtraBalls]
	inc a
	cp MAX_EXTRA_BALLS + 1
	jr z, .maxed
	ld [wExtraBalls], a
	ld a, $1
	ld [wShowExtraBallText], a
	ret

.maxed
	ld bc, TenMillionPoints
	callba AddBigBCD6FromQueue
	ld a, $2
	ld [wShowExtraBallText], a
	ret

ShowExtraBallMessage: ; 0x30188
; Displays the extra ball scrolling message, if an extra ball has been granted.
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	ld a, [wShowExtraBallText]
	and a
	ret z
	cp $1
	jr nz, .asm_301a7
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText1
	ld de, ExtraBallText
	call LoadScrollingText
	jr .asm_301c9

.asm_301a7
	ld bc, $1000
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText2
	ld de, DigitsText1to9
	call Func_32cc
	pop de
	pop bc
	ld hl, wScrollingText1
	ld de, ExtraBallSpecialBonusText
	call LoadScrollingText
.asm_301c9
	xor a
	ld [wShowExtraBallText], a
	ret
