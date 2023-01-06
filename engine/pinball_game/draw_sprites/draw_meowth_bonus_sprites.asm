DrawSpritesMeowthBonus: ; 0x2583b
	ld bc, $7f65
	callba DrawTimer
	callba DrawFlippers
	call Func_259fe
	call Func_25895
	call Func_2595e
	call Func_2586c
	callba DrawPinball
	call Func_25a39
	ret

Func_2586c: ; 0x2586c
	ld a, [wMeowthXPosition]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthYPosition]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, OAMIds_2588b
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

OAMIds_2588b:
	db $21, $22, $23, $24, $25, $26, $27, $28, $33, $34

Func_25895: ; 0x25895
	ld a, [wd714]
	cp $b
	jr nz, .asm_258a0
	xor a
	ld [wd714], a
.asm_258a0
	ld a, [wd715]
	cp $b
	jr nz, .asm_258ab
	xor a
	ld [wd715], a
.asm_258ab
	ld a, [wd716]
	cp $b
	jr nz, .asm_258b6
	xor a
	ld [wd716], a
.asm_258b6
	ld a, [wd71a]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd727]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd717]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd714]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd71b]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd728]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd718]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd715]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd71c]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd729]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd719]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd716]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

OAMPointers_25935:
	dw OAMIds_2593d
	dw OAMIds_2593d
	dw OAMIds_25948
	dw OAMIds_25953

OAMIds_2593d:
	db $29, $29, $29, $29, $2A, $2A, $2A, $2A, $2A, $2A, $2A

OAMIds_25948:
	db $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2C, $2C, $2C, $2C

OAMIds_25953:
	db $2D, $32, $31, $30, $2F, $2E, $2F, $30, $31, $32, $32

Func_2595e: ; 0x2595e
	ld a, [wd71e]
	cp $b
	jr nz, .asm_25969
	xor a
	ld [wd71e], a
.asm_25969
	ld a, [wd71f]
	cp $b
	jr nz, .asm_25974
	xor a
	ld [wd71f], a
.asm_25974
	ld a, [wd720]
	cp $b
	jr nz, .asm_2597f
	xor a
	ld [wd720], a
.asm_2597f
	ld a, [wd724]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd731]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd721]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd71e]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd725]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd732]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd722]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd71f]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd726]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd733]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd723]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd720]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

Func_259fe: ; 0x259fe
	ld a, [wd795]
	and a
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
	ld hl, OAMIds_25a29
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_25a29:
	db $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42, $43
	db $FF

Func_25a39: ; 0x25a39
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
	jr c, .asm_25a58
	ld de, $0000
	jr .asm_25a5b

.asm_25a58
	ld de, $0001
.asm_25a5b
	ld hl, OAMIds_25a7a
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

OAMIds_25a7a: ; 0x25a7a
	db $44, $45
