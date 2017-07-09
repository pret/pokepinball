GenRandom: ; 0x959
	push bc
	push de
	push hl
	ld a, [wd811]
	ld c, a
	ld b, $0
	inc a
	cp 54 + 1
	jr nz, .asm_96e
	call Func_9fa
	xor a
	ld bc, $0000
.asm_96e
	ld [wd811], a
	ld hl, wd812
	add hl, bc
	ld a, [hl]
	pop hl
	pop de
	pop bc
	ret

Func_97a: ; 0x97a
	ld a, [wd810]
	ld d, a
	ld a, $0
	ld a, [sRNGMod]
.asm_983
	cp d
	jr c, .asm_989
	sub d
	jr .asm_983

.asm_989
	ld [wd80f], a
	ld [wd848], a
	ld e, $1
	ld hl, Data_9c4
	ld a, $36
.asm_996
	push af
	ld c, [hl]
	inc hl
	ld b, $0
	push hl
	ld hl, wd812
	add hl, bc
	ld [hl], e
	ld a, [wd80f]
	sub e
	jr nc, .asm_9a8
	add d
.asm_9a8
	ld e, a
	ld a, [hl]
	ld [wd80f], a
	pop hl
	pop af
	dec a
	jr nz, .asm_996
	call Func_9fa
	call Func_9fa
	call Func_9fa
	ld a, $0
	call GenRandom
	ld [sRNGMod], a
	ret

Data_9c4:
	db $14, $29, $07, $1c, $31, $0f, $24, $02, $17
	db $2c, $0a, $1f, $34, $12, $27, $05, $1a, $2f
	db $0d, $22, $00, $15, $2a, $08, $1d, $32, $10
	db $25, $03, $18, $2d, $0b, $20, $35, $13, $28
	db $06, $1b, $30, $0e, $23, $01, $16, $2b, $09
	db $1e, $33, $11, $26, $04, $19, $2e, $0c, $21

Func_9fa: ; 0x9fa
	ld a, [wd810]
	ld d, a
	ld bc, wd812
	ld hl, wd812 + $1f
	ld e, $18
.asm_a06
	ld a, [bc]
	sub [hl]
	jr nc, .asm_a0b
	add d
.asm_a0b
	ld [bc], a
	dec e
	jr nz, .asm_a06
	ld bc, wd812 + $18
	ld hl, wd812
	ld e, $1f
.asm_a17
	ld a, [bc]
	sub [hl]
	jr nc, .asm_a1c
	add d
.asm_a1c
	ld [bc], a
	dec e
	jr nz, .asm_a17
	ret

Func_a21: ; 0xa21
	push bc
	push hl
	ld c, a
	ld b, $0
	ld hl, Data_a38
	add hl, bc
	ld l, [hl]
	call GenRandom
	call Func_dd4
	inc h
	srl h
	ld a, h
	pop hl
	pop bc
	ret

Data_a38:
x = 0
REPT 128
	db x | ((x >> 7) & 1)
x = x + 2
ENDR
