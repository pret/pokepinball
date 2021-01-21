Func_14c4: ; 14c4 (0:14c4)
	ld a, [wd8dc]
	and a
	jp nz, Func_165f
	ld a, [wd8ad]
	cp $7
	jp z, Func_1612
	ld a, [wd8af]
	and a
	jr nz, .asm_14df
	call Func_1502
	jp Func_1663

.asm_14df
	ld a, [wd8b0]
	and a
	jr z, .asm_14fc
	ld a, [wd8b1]
	and a
	jr z, .asm_14fc
	ld a, [wd8b2]
	cp $2
	jr z, .asm_14f7
	call Func_15e1
	jr .asm_14ff

.asm_14f7
	call Func_15f8
	jr .asm_14ff

.asm_14fc
	call Func_1527
.asm_14ff
	jp Func_1663

Func_1502: ; 1502 (0:1502)
	ld hl, wd8b9
	ld c, [hl]
	inc [hl]
	ld b, $0
	ld hl, SerialTranfserData_18ff
	add hl, bc
	ld a, [hl]
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ld a, [wd8b9]
	cp $2
	ret nz
	xor a
	ld [wd8b9], a
	inc a
	ld [wd8af], a
	ret

Func_1527: ; 1527 (0:1527)
	ld a, [wd8b9]
	ld c, a
	ld a, [wd8ba]
	ld b, a
	ld a, [wd8bb]
	ld l, a
	ld a, [wd8bc]
	ld h, a
	add hl, bc
	ld a, [rSB]
	ld [wd8c8 + 1], a
	ld a, [hl]
	ld [rSB], a
	ld l, a
	ld a, [wd8c3]
	add l
	ld [wd8c3], a
	ld a, [wd8c4]
	adc $0
	ld [wd8c4], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ld hl, wd8b9
	inc [hl]
	jr nz, .asm_1560
	inc hl
	inc [hl]
.asm_1560
	ld hl, wd8b9
	ld a, [wd8b3]
	cp [hl]
	jr nz, .asm_1570
	inc hl
	ld a, [wd8b4]
	cp [hl]
	jr z, .asm_1572
.asm_1570
	jr .asm_15b0

.asm_1572
	ld hl, wd8b0
	ld a, [hl]
	and a
	jr z, .asm_157c
	ld hl, wd8b1
.asm_157c
	inc [hl]
	ld a, [wd8cc]
	and a
	jr z, .asm_15b5
	ld a, [wd8ad]
	cp $6
	jr z, .asm_15b5
	ld hl, wd8b1
	ld a, [hl]
	and a
	jr nz, .asm_15b1
	xor a
	ld [wd8b9], a
	ld [wd8ba], a
	ld a, [wd8bf]
	ld [wd8bb], a
	ld a, [wd8c0]
	ld [wd8bc], a
	ld a, [wd8b7]
	ld [wd8b3], a
	ld a, [wd8b8]
	ld [wd8b4], a
.asm_15b0
	ret

.asm_15b1
	call Func_15c8
	ret

.asm_15b5
	ld a, [wd8c8 + 1]
	ld [wd8c8], a
Func_15bb:
	ld a, $7
	ld [wd8ad], a
	ld a, $1
	ld [wd8c5], a
	call Func_16bf
Func_15c8: ; 15c8 (0:15c8)
	ld a, [wd8b5]
	ld [wd8b3], a
	ld a, [wd8b6]
	ld [wd8b4], a
	ld a, [wd8bd]
	ld [wd8bb], a
	ld a, [wd8be]
	ld [wd8bc], a
	ret

Func_15e1: ; 15e1 (0:15e1)
	ld c, a
	ld b, $0
	ld hl, wd8c3
	add hl, bc
	ld a, [hl]
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ld hl, wd8b2
	inc [hl]
	ret

Func_15f8: ; 15f8 (0:15f8)
	ld a, [rSB]
	ld [wd8c8], a
	xor a
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ld hl, wd8c6
	inc [hl]
	ld a, [hl]
	cp $2
	jr z, Func_15bb
	ret

Func_1612: ; 1612 (0:1612)
	ld a, [wd8cb]
	ld [wd8ae], a
	ld a, [wd8c7]
	ld [wd86e + 2], a
	cp $ff
	jr z, .asm_1625
	ld [wd86e + 1], a
.asm_1625
	ld a, [rSB]
	ld [wd8c7], a
	cp $ff
	jr nz, .asm_163a
	ld a, $0
	ld [wd8db], a
	ld [wd8ad], a
	ld a, $2
	jr .asm_1652

.asm_163a
	bit 1, a
	jr z, .asm_1643
	ld a, $1
	ld [wd8e2], a
.asm_1643
	bit 4, a
	ld a, $0
	ld [wd8ad], a
	ld a, $1
	jr nz, .asm_1651
	ld [wd8ad], a
.asm_1651
	inc a
.asm_1652
	ld [wd8c5], a
	ld a, [wd8cc]
	and a
	jr nz, Func_165f
	xor a
	ld [wd8db], a
Func_165f: ; 165f (0:165f)
	ret

Func_1660:
	xor a
	ld [rSC], a
Func_1663: ; 1663 (0:1663)
	ret

Func_1664:
	push af
	ld a, [rSC]
	bit 7, a
	jr nz, .asm_1679
	push bc
	push de
	push hl
	ld a, $1
	ld [wd8ca], a
	call Func_14c4
	pop hl
	pop de
	pop bc
.asm_1679
	pop af
	reti
Func_167b: ; 0x167b
	ld a, [wd8ad]
	cp $1
	ret nz
	ld a, [wd8c7]
	cp $ff
	ret z
	ld a, [wd8db]
	and a
	ret nz
	ld hl, wd8e0
	inc [hl]
	ld a, [hl]
	cp $6
	ret c
	xor a
	ld [hl], a
	ld [wd8e2], a
	call Func_18ac
	ret

Func_169d:
	xor a
	ld [rSC], a
	ld [rSB], a
	; fallthrough

Func_16a2: ; 0x16a2
	xor a
	ld [rSB], a
	ld [rSC], a
	ld [wd8ad], a
	dec a
	ld [wd8c7], a
	ld [wd8c8], a
	call Func_16b5
	ret

Func_16b5: ; 0x16b5
	xor a
	ld [wd8c5], a
	ld [wd8ca], a
	ld [wd8db], a
	; fall through
Func_16bf: ; 0x16bf
	xor a
	ld [wd8af], a
	ld [wd8b0], a
	ld [wd8b1], a
	ld [wd8b2], a
	ld [wd8c6], a
	ld [wd8c3], a
	ld [wd8c4], a
	ld [wd8b9], a
	ld [wd8ba], a
	ld [wd8dc], a
	ld [wd8e2], a
	ret

Func_16e2: ; 0x16e2
	ld a, [wd8db]
	and a
	jr z, .asm_16ec
	call Func_16fd
	ret nc
.asm_16ec
	ld a, [wd8ae]
	cp $1
	jr nz, .asm_16f7
	call Func_16fd
	ret nc
.asm_16f7
	call Func_1925
	jp Func_19e5

Func_16fd: ; 0x16fd
	ld a, [wd8c5]
	cp $2
	jr nz, .asm_173c
	xor a
	ld [wd8e0], a
	ld [wd8ae], a
	inc a
	ld [wd8ad], a
	ld a, [wd8c7]
	cp $ff
	jr z, .asm_1735
	bit 0, a
	jr nz, .asm_172e
	bit 1, a
	jr nz, .asm_172e
	bit 4, a
	jr z, .asm_173a
	xor a
	ld [wd8ad], a
	ld [wd8ae], a
	ld a, [wd8c7]
	jr .asm_173a

.asm_172e
	scf
	ret

.asm_1730
	xor a
	ld [wd8ae], a
	dec a
.asm_1735
	inc a
	ld [wd8ad], a
	dec a
.asm_173a
	and a
	ret

.asm_173c
	xor a
	ld a, $f0
	ret

Func_1740: ; 0x1740
	ld a, [wd8ad]
	cp $1
	jr z, .asm_1752
	cp $2
	jr z, .asm_1752
	and a
	ld a, $ff
	ret z
.asm_174f
	ld a, $f0
	ret

.asm_1752
	ld a, [wd8e2]
	and a
	jr nz, .asm_174f
	ld a, [wd8db]
	and a
	jr z, .asm_1762
	call Func_16fd
	ret nc
.asm_1762
	ld a, [wd8ae]
	cp $2
	jr nz, .asm_176d
	call Func_16fd
	ret nc
.asm_176d
	ld a, [wd8c7]
	cp $ff
	ret z
	call Func_1932
	jp Func_19e5

Func_1779: ; 0x1779
	ld c, a
	ld a, [wd8ad]
	and a
	ld a, [wd8c7]
	ret z
	ld a, [wd8ad]
	cp $1
	jr z, .asm_1790
	cp $3
	jr z, .asm_1790
	ld a, $f0
	ret

.asm_1790
	ld a, [wd8db]
	and a
	jr nz, .asm_17df
	ld a, c
	inc a
	ld [wd8de], a
	ld a, l
	ld [wd8c1], a
	ld a, h
	ld [wd8c2], a
	ld a, [wd8c7]
	cp $ff
	ret z
	ld a, [wd8ab]
	ld [wd8ac], a
	and a
	jr z, .asm_17d6
	ld a, [wd8de]
	dec a
	dec a
	push af
	ld c, a
	ld b, $0
	push hl
	ld hl, wd89d
	add hl, bc
	ld a, [hl]
	pop hl
	ld [wd8ac], a
	pop af
	add a
	ld c, a
	ld b, $0
	push hl
	ld hl, wd88b
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	pop hl
	ld c, a
	jp .asm_17d9

.asm_17d6
	ld bc, $0280
.asm_17d9
	call Func_1989
	jp Func_19e5

.asm_17df
	ld a, [wd8c5]
	cp $2
	ld a, $f0
	jp nz, .asm_1869
	ld hl, wd8de
	ld a, [wd8c7]
	bit 4, a
	jp nz, .asm_1859
	bit 1, a
	jp nz, .asm_1804
	bit 0, a
	jp nz, .asm_1804
	dec [hl]
	ld a, [wd8c7]
	jr z, .asm_1860
.asm_1804
	ld a, [hl]
	cp $1
	jr z, .asm_186a
	ld bc, $0280
	ld a, [wd8ab]
	ld [wd8ac], a
	and a
	jr z, .asm_1836
	ld a, [wd8de]
	dec a
	dec a
	push af
	ld c, a
	ld b, $0
	push hl
	ld hl, wd89d
	add hl, bc
	ld a, [hl]
	pop hl
	ld [wd8ac], a
	pop af
	add a
	ld c, a
	ld b, $0
	push hl
	ld hl, wd88b
	add hl, bc
	ld a, [hli]
	ld b, [hl]
	pop hl
	ld c, a
.asm_1836
	ld a, [wd8c7]
	bit 1, a
	jp nz, .asm_184e
	ld a, [wd8bf]
	add $80
	ld [wd8bf], a
	ld a, [wd8c0]
	adc $2
	ld [wd8c0], a
.asm_184e
	ld a, [wd8bf]
	ld l, a
	ld a, [wd8c0]
	ld h, a
	jp .asm_17d9

.asm_1859
	push af
	ld a, $1
	ld [wd8dc], a
	pop af
.asm_1860
	push af
	xor a
	ld [wd8cc], a
	ld [wd8db], a
	pop af
.asm_1869
	ret

.asm_186a
	ld a, [wd8dd]
	and a
	ld a, [wd8c7]
	jr z, .asm_1860
	call Func_19d7
	jp Func_19e5

Func_1879:
	ld a, [wd8ad]
	cp $1
	jr z, .asm_188b
	cp $3
	jr z, .asm_188b
	and a
	ld a, $ff
	ret z
	ld a, $f0
	ret

.asm_188b
	ld a, [wd8db]
	and a
	jr z, .asm_1895
	call Func_16fd
	ret nc
.asm_1895
	ld a, [wd8ae]
	cp $4
	jr nz, .asm_18a0
	call Func_16fd
	ret nc
.asm_18a0
	ld a, [wd8c7]
	cp $ff
	ret z
	call Func_19bd
	jp Func_19e5

Func_18ac: ; 0x18ac
	ld a, [wd8ad]
	cp $1
	jr z, .asm_18be
	cp $3
	jr z, .asm_18be
	and a
	ld a, $ff
	ret z
	ld a, $f0
	ret

.asm_18be
	ld a, [wd8db]
	and a
	jr z, .asm_18c8
	call Func_16fd
	ret nc
.asm_18c8
	ld a, [wd8c7]
	cp $ff
	ret z
	call Func_19ca
	jp Func_19e5

Func_18d4: ; 0x18d4
	ld [wd8cb], a
	ld a, d
	ld [wd8cc], a
	ld a, l
	ld [wd8bb], a
	ld [wd8bd], a
	ld a, h
	ld [wd8bc], a
	ld [wd8be], a
	ld a, c
	ld [wd8b3], a
	ld [wd8b5], a
	ld a, b
	ld [wd8b4], a
	ld [wd8b6], a
	xor a
	ld [wd8c5], a
	call Func_16bf
	ret

SerialTranfserData_18ff: ; 0x18ff
	db $88
	db $33

SerialTransferData_1901: ; 0x1901
	db $01
	db $00
	db $00
	db $00
	db $01
	db $00
	db $00
	db $00

SerialTransferData_1909: ; 0x1909
	db $02
	db $00
	db $04
	db $00

SerialTransferData_190d: ; 0x190d
	db $04
	db $00
	db $00
	db $00
	db $04
	db $00
	db $00
	db $00

SerialTransferData_1915: ; 0x1915
	db $08
	db $00
	db $00
	db $00
	db $08
	db $00
	db $00
	db $00

SerialTransferData_191d: ; 0x191d
	db $0F
	db $00
	db $00
	db $00
	db $0F
	db $00
	db $00
	db $00

Func_1925: ; 0x1925
	ld a, $1
	ld d, $0
	ld hl, SerialTransferData_1901
	ld bc, $0008
	jp Func_18d4

Func_1932: ; 0x19332
	ld a, $2
	ld d, $0
	ld hl, wd8cd
	ld bc, $000c
	call Func_18d4
	ld hl, SerialTransferData_1909
	ld de, wd8cd
	ld bc, $0004
	call LocalCopyData
	ld de, $0006
	ld a, [wd8a8]
	ld [wd8d1], a
	call Func_1982
	ld a, [wd8a9]
	ld [wd8d2], a
	call Func_1982
	ld a, [wd8aa]
	ld [wd8d3], a
	call Func_1982
	ld a, [wd8a7]
	ld [wd8d4], a
	call Func_1982
	ld a, e
	ld [wd8d5], a
	ld a, d
	ld [wd8d6], a
	xor a
	ld [wd8d7], a
	ld [wd8d8], a
	ret

Func_1982: ; 0x1982
	add e
	ld e, a
	ld a, d
	adc $0
	ld d, a
	ret

Func_1989: ; 0x1989
	ld a, l
	ld [wd8bf], a
	ld a, h
	ld [wd8c0], a
	ld a, c
	ld [wd8b7], a
	ld a, b
	ld [wd8b8], a
	push bc
	ld a, $3
	ld d, $1
	ld hl, wd8cd
	ld bc, $0004
	call Func_18d4
	ld a, [SerialTransferData_190d]
	ld [wd8cd], a
	ld a, [wd8ac]
	ld [wd8ce], a
	pop bc
	ld a, c
	ld [wd8cf], a
	ld a, b
	ld [wd8d0], a
	ret

Func_19bd: ; 19bd (0:19bd)
	ld a, $4
	ld d, $0
	ld hl, SerialTransferData_1915
	ld bc, $8
	jp Func_18d4

Func_19ca: ; 0x19ca
	ld a, $5
	ld d, $0
	ld hl, SerialTransferData_191d
	ld bc, $0008
	jp Func_18d4

Func_19d7: ; 0x19d7
	ld a, $6
	ld d, $1
	ld hl, SerialTransferData_190d
	ld bc, $0008
	jp Func_18d4

; unused
	ret

Func_19e5: ; 0x19e5
	ld a, [wd8ad]
	cp $1
	jr z, .asm_19f8
	and a
	jr nz, .asm_19f6
	ld a, [wd8cb]
	cp $1
	jr z, .asm_1a02
.asm_19f6
	scf
	ret

.asm_19f8
	ld a, [wd8cb]
	cp $1
	jr z, .asm_19f6
	ld [wd8ad], a
.asm_1a02
	xor a
	ld [wd8c5], a
	ld [wd8ae], a
	ld a, $1
	ld [wd8b9], a
	ld [wd8db], a
	ld a, [SerialTranfserData_18ff]
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ld a, $f0
	ret
