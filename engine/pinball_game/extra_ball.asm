HandleExtraBall: ; 0x30188
; Grants the player an extra Ball, if they qualify for it.
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd4ca]
	and a
	ret z
	cp $1
	jr nz, .asm_301a7
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
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
	call Func_30db
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
	ld [wd4ca], a
	ret
