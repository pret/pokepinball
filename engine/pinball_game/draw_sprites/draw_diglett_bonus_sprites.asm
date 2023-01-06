DrawSpritesDiglettBonus: ; 0x1ac98
	callba DrawFlippers
	callba DrawPinball
	call DrawDugtrio
	ret

DrawDugtrio: ; 0x1acb0
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $0
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wDugtrioAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, OAMIds_1accf
	add hl, de
	ld a, [hl]
	bit 7, a
	call z, LoadOAMData2
	ret

OAMIds_1accf:
	db $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53
	db $FF
