DrawSpritesMewtwoBonus: ; 0x1994e
	ld bc, $7f65
	callba DrawTimer
	call Func_1999d
	callba DrawFlippers
	callba DrawPinball
	call Func_19976
	ret

Func_19976: ; 0x19976
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $0
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd6ad]
	ld e, a
	ld d, $0
	ld hl, OAMIds_19995
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_19995:
	db $0F, $10, $11, $12, $17, $18, $19
	db $FF

Func_1999d: ; 0x1999d
	ld de, wd6b6
	call Func_199be
	ld de, wd6be
	call Func_199be
	ld de, wd6c6
	call Func_199be
	ld de, wd6ce
	call Func_199be
	ld de, wd6d6
	call Func_199be
	ld de, wd6de
	; fall through

Func_199be: ; 0x199be
	ld a, [de]
	and a
	ret z
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_199e6
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_199e6:
	db $13, $14, $15, $16, $1A, $1B, $1C, $1D, $1E, $1F, $20
	db $FF
