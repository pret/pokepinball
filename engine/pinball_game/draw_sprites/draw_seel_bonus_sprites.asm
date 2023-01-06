DrawSpritesSeelBonus: ; 0x26b7e
	ld bc, $7f65
	callba DrawTimer
	call Func_26bf7
	callba DrawFlippers
	callba DrawPinball
	call Func_26ba9
	call Func_26c3c
	ret

Func_26ba9: ; 0x26ba9
	ld de, wd76e
	call Func_26bbc
	ld de, wd778
	call Func_26bbc
	ld de, wd782
	call Func_26bbc
	ret

Func_26bbc: ; 0x26bbc
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_26bdf
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_26bdf:
	db $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $63
	db $64, $65, $66, $67, $68, $69, $6A
	db $FF

Func_26bf7: ; 0x26bf7: ; 0x26bf7
	ld a, [wd795]
	cp $0
	ret z
	ld de, wd79c
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_26c23
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_26c23:
	db $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A
	db $7B, $7C, $7D, $7E, $7F, $80, $81, $82
	db $FF

Func_26c3c: ; 0x26c3c
	ld a, [wd64e]
	and a
	ret z
	ld a, [wd652]
	ld hl, hSCX
	sub [hl]
	ld b, a
	xor a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd64f]
	cp $a
	jr c, .asm_26c5b
	ld de, $0000
	jr .asm_26c5e

.asm_26c5b
	ld de, $0001
.asm_26c5e
	ld hl, OAMIds_26c7d
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld hl, wd64f
	inc [hl]
	ld a, [hl]
	cp $14
	ret c
	ld [hl], $0
	ld hl, wd650
	inc [hl]
	ld a, [hl]
	cp $a
	ret nz
	xor a
	ld [wd64e], a
	ret

OAMIds_26c7d:
	db $83, $84
