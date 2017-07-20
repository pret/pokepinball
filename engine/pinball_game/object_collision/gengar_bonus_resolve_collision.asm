ResolveGengarBonusGameObjectCollisions: ; 0x18377
	call Func_18464
	call Func_1860b
	call Func_187b1
	call Func_18d34
	call Func_183b7
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba StopTimer
	ld a, [wd6a2]
	cp $5
	ret nc
	ld a, $1
	ld [wd6a8], a
	ret

Func_183b7: ; 0x183b7
	ld a, [wd653]
	and a
	ret nz
	ld a, [wBallXPos + 1]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd653], a
	callba LoadStageCollisionAttributes
	call Func_183db
	call Func_18d91
	ret

Func_183db: ; 0x183db
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_183f8
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_183ee
	ld hl, TileDataPointers_1842e
.asm_183ee
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(TileDataPointers_183f8)
	call QueueGraphicsToLoad
	ret

TileDataPointers_183f8:
	dw TileData_183fc
	dw TileData_183ff

TileData_183fc: ; 0x183fc
	db $01
	dw TileData_18402

TileData_183ff: ; 0x183ff
	db $01
	dw TileData_18418

TileData_18402: ; 0x18402
	dw LoadTileLists
	db $06 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $113
	db $D4

	db $02 ; number of tiles
	dw vBGMap + $132
	db $D5, $D6

	db $02 ; number of tiles
	dw vBGMap + $152
	db $D9, $D7

	db $01 ; number of tiles
	dw vBGMap + $172
	db $D8

	db $00 ; terminator

TileData_18418: ; 0x18418
	dw LoadTileLists
	db $06 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $113
	db $12

	db $02 ; number of tiles
	dw vBGMap + $132
	db $0C, $0D

	db $02 ; number of tiles
	dw vBGMap + $152
	db $07, $08

	db $01 ; number of tiles
	dw vBGMap + $172
	db $03

	db $00 ; terminator

TileDataPointers_1842e:
	dw TileData_18432
	dw TileData_18435

TileData_18432: ; 0x18432
	db $01
	dw TileData_18438

TileData_18435: ; 0x18435
	db $01
	dw TileData_1844e

TileData_18438: ; 0x18438
	dw LoadTileLists
	db $06 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $113
	db $D4

	db $02 ; number of tiles
	dw vBGMap + $132
	db $D5, $D6

	db $02 ; number of tiles
	dw vBGMap + $152
	db $D9, $D7

	db $01 ; number of tiles
	dw vBGMap + $172
	db $D8

	db $00 ; terminator

TileData_1844e: ; 0x1844e
	dw LoadTileLists
	db $06 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $113
	db $21

	db $02 ; number of tiles
	dw vBGMap + $132
	db $15, $16

	db $02 ; number of tiles
	dw vBGMap + $152
	db $0A, $0B

	db $01 ; number of tiles
	dw vBGMap + $172
	db $03

	db $00 ; terminator

Func_18464: ; 0x18464
	ld a, [wd659]
	and a
	ret z
	ld a, [wd657]
	and a
	jr z, .asm_184d5
	xor a
	ld [wd657], a
	ld a, [wd7be]
	and a
	jr nz, .asm_184d5
	ld a, [wd658]
	sub $5
	ld c, a
	sla a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd65d
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jr nz, .asm_184d5
	push de
	dec de
	dec de
	dec de
	ld hl, AnimationData_185e6
	call InitAnimation
	pop de
	ld a, $1
	ld [de], a
	ld a, [wd67b]
	inc a
	ld [wd67b], a
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld a, $33
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $2c
	call PlaySoundEffect
.asm_184d5
	ld bc, $0830
	ld de, wd65d
	ld hl, wd675
	call Func_1850c
	ld bc, $5078
	ld de, wd666
	ld hl, wd677
	call Func_1850c
	ld bc, $3050
	ld de, wd66f
	ld hl, wd679
	call Func_1850c
	ld de, wd65d
	call Func_18562
	ld de, wd666
	call Func_18562
	ld de, wd66f
	call Func_18562
	ret

Func_1850c: ; 0x1850c
	ld a, [de]
	and a
	ret nz
	inc de
	push hl
	ld a, [hli]
	push af
	push bc
	ld a, [hl]
	inc a
	and $1f
	ld [hl], a
	ld c, a
	ld b, $0
	ld hl, GastlyData_18542
	add hl, bc
	pop bc
	pop af
	and a
	jr nz, .asm_18534
	ld a, [de]
	add [hl]
	ld [de], a
	inc de
	ld a, [de]
	adc $0
	ld [de], a
	pop hl
	cp c
	ret c
	ld a, $1
	ld [hl], a
	ret

.asm_18534
	ld a, [de]
	sub [hl]
	ld [de], a
	inc de
	ld a, [de]
	sbc $0
	ld [de], a
	pop hl
	cp b
	ret nc
	xor a
	ld [hl], a
	ret

GastlyData_18542: ; 0x18542
; Might be floating y offsets, not sure at the moment.
	db $31, $32, $33, $34, $35, $36, $37, $36
	db $35, $34, $33, $32, $33, $34, $35, $36
	db $37, $38, $39, $3A, $3B, $3A, $39, $38
	db $37, $36, $35, $34, $33, $32, $31, $30

Func_18562: ; 0x18562
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, AnimationDataPointers_185d9
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	dec de
	call UpdateAnimation
	pop de
	ret nc
	ld a, [de]
	dec de
	and a
	jr nz, .asm_1858a
	ld a, [de]
	cp $4
	ret nz
	ld hl, AnimationData_185dd
	dec de
	dec de
	call InitAnimation
	ret

.asm_1858a
	cp $1
	ret nz
	ld a, [de]
	cp $12
	ret nz
	ld a, [wd67b]
	cp $a
	jr nz, .asm_185b1
	ld a, $1
	ld [wd67e], a
	ld [wd687], a
	xor a
	ld [wd659], a
	ld [wd662], a
	ld [wd66b], a
	ld de, $0006
	call PlaySong
	ret

.asm_185b1
	ld c, a
	ld a, [wd65d]
	and a
	jr nz, .asm_185b9
	inc c
.asm_185b9
	ld a, [wd666]
	and a
	jr nz, .asm_185c0
	inc c
.asm_185c0
	ld a, [wd66f]
	and a
	jr nz, .asm_185c7
	inc c
.asm_185c7
	ld a, c
	cp $a
	ret nc
	ld hl, AnimationData_185dd
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	xor a
	ld [de], a
	ret

AnimationDataPointers_185d9:
	dw AnimationData_185dd
	dw AnimationData_185e6

AnimationData_185dd: ; 0x185dd
; Each entry is [duration][frame]
	db $0D, $01
	db $0D, $00
	db $0D, $02
	db $0D, $00
	db $00 ; terminator

AnimationData_185e6: ; 0x185e6
; Each entry is [duration][frame]
	db $05, $03
	db $04, $03
	db $04, $04
	db $04, $03
	db $04, $04
	db $03, $03
	db $03, $04
	db $03, $03
	db $03, $04
	db $02, $03
	db $02, $04
	db $02, $03
	db $02, $04
	db $01, $03
	db $01, $04
	db $01, $03
	db $01, $04
	db $80, $04
	db $00 ; terminator

Func_1860b: ; 0x1860b
	ld a, [wd67e]
	and a
	ret z
	ld a, [wd67c]
	and a
	jr z, .asm_1867c
	xor a
	ld [wd67c], a
	ld a, [wd7be]
	and a
	jr nz, .asm_1867c
	ld a, [wd67d]
	sub $8
	ld c, a
	sla a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd682
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jr nz, .asm_1867c
	push de
	dec de
	dec de
	dec de
	ld hl, AnimationData_1878a
	call InitAnimation
	pop de
	ld a, $1
	ld [de], a
	ld a, [wd695]
	inc a
	ld [wd695], a
	ld bc, FiveHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld a, $33
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $2d
	call PlaySoundEffect
.asm_1867c
	ld bc, $5078
	ld de, wd682
	ld hl, wd691
	call Func_186a1
	ld bc, $1038
	ld de, wd68b
	ld hl, wd693
	call Func_186a1
	ld de, wd682
	call Func_186f7
	ld de, wd68b
	call Func_186f7
	ret

Func_186a1: ; 0x186a1
	ld a, [de]
	and a
	ret nz
	inc de
	push hl
	ld a, [hli]
	push af
	push bc
	ld a, [hl]
	inc a
	and $1f
	ld [hl], a
	ld c, a
	ld b, $0
	ld hl, HaunterData_186d7
	add hl, bc
	pop bc
	pop af
	and a
	jr nz, .asm_186c9
	ld a, [de]
	add [hl]
	ld [de], a
	inc de
	ld a, [de]
	adc $0
	ld [de], a
	pop hl
	cp c
	ret c
	ld a, $1
	ld [hl], a
	ret

.asm_186c9
	ld a, [de]
	sub [hl]
	ld [de], a
	inc de
	ld a, [de]
	sbc $0
	ld [de], a
	pop hl
	cp b
	ret nc
	xor a
	ld [hl], a
	ret

HaunterData_186d7:
; Might be floating y offsets, not sure at the moment.
	db $31, $32, $33, $34, $35, $36, $37, $36
	db $35, $34, $33, $32, $33, $34, $35, $36
	db $37, $38, $39, $3A, $3B, $3A, $39, $38
	db $37, $36, $35, $34, $33, $32, $31, $30

Func_186f7: ; 0x186f7
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, AnimationDataPointers_1877d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	dec de
	call UpdateAnimation
	pop de
	ret nc
	ld a, [de]
	dec de
	and a
	jr nz, .asm_1871f
	ld a, [de]
	cp $4
	ret nz
	ld hl, AnimationData_18781
	dec de
	dec de
	call InitAnimation
	ret

.asm_1871f
	cp $1
	ret nz
	ld a, [de]
	cp $12
	jr nz, .asm_18761
	ld a, [wd695]
	cp $a
	jr nz, .asm_18740
	ld a, $1
	ld [wd656], a
	call Func_18d72
	call Func_18d91
	ld de, $0000
	call PlaySong
	ret

.asm_18740
	ld c, a
	ld a, [wd682]
	and a
	jr nz, .asm_18748
	inc c
.asm_18748
	ld a, [wd68b]
	and a
	jr nz, .asm_1874f
	inc c
.asm_1874f
	ld a, c
	cp $a
	ret nc
	ld hl, AnimationData_18781
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	xor a
	ld [de], a
	ret

.asm_18761
	cp $13
	ret nz
	ld a, [wd695]
	cp $a
	ret nz
	ld a, $1
	ld [wd698], a
	xor a
	ld [wd67e], a
	ld [wd687], a
	ld de, GENGAR
	call PlayCry
	ret

AnimationDataPointers_1877d:
	dw AnimationData_18781
	dw AnimationData_1878a

AnimationData_18781:
; Each entry is [duration][frame]
	db $0D, $00
	db $0D, $01
	db $0D, $02
	db $0D, $03
	db $00 ; terminator

AnimationData_1878a:
; Each entry is [duration][frame]
	db $05, $04
	db $04, $04
	db $04, $05
	db $04, $04
	db $04, $05
	db $03, $04
	db $03, $05
	db $03, $04
	db $03, $05
	db $02, $04
	db $02, $05
	db $02, $04
	db $02, $05
	db $01, $04
	db $01, $05
	db $01, $04
	db $01, $05
	db $80, $05
	db $10, $05
	db $00 ; terminator

Func_187b1: ; 0x187b1
	ld a, [wd698]
	and a
	ret z
	ld a, [wd696]
	and a
	jp z, .asm_1885d
	xor a
	ld [wd696], a
	ld a, [wd7be]
	and a
	jp nz, .asm_1885d
	ld a, [wd697]
	sub $a
	ld c, a
	sla a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd69c
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jp nz, .asm_1885d
	push de
	dec de
	dec de
	dec de
	ld a, [wd6a2]
	inc a
	ld [wd6a2], a
	cp $5
	jr nc, .asm_18804
	ld hl, AnimationData_18b2b
	call InitAnimation
	pop de
	ld a, $2
	ld [de], a
	lb de, $00, $37
	call PlaySoundEffect
	jr .asm_18826

.asm_18804
	ld hl, AnimationData_18b32
	call InitAnimation
	pop de
	ld a, $3
	ld [de], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba StopTimer
	ld de, $0000
	call PlaySong
.asm_18826
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueue
	ld a, $33
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $ff
	ld [wGengarYPos + 1], a
.asm_1885d
	ld a, [wd69c]
	cp $2
	jr nc, .asm_18869
	call Func_18876
	jr .asm_1886c

.asm_18869
	call Func_188e1
.asm_1886c
	ld de, wd69c
	call Func_189af
	call Func_1894c
	ret

Func_18876: ; 0x18876
	ld a, [wd6a3]
	cp $1
	jr z, .asm_1889b
	cp $2
	jr z, .asm_1889b
	ld a, [wGengarAnimationState]
	cp $1
	jr z, .asm_1888c
	cp $2
	jr nz, .asm_1889b
.asm_1888c
	ld a, $1
	ld [wd6a4], a
	ld a, $11
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
.asm_1889b
	ld a, [wGengarAnimationState]
	ld hl, wd6a3
	cp [hl]
	ret z
	ld a, [wd69c]
	and a
	jr nz, .asm_188da
	ld a, [wGengarYPos + 1]
	add $80
	cp $a0
	jr nc, .asm_188da
	ld a, [wGengarAnimationState]
	and a
	jr z, .asm_188ca
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $3
	ld [wGengarYPos + 1], a
	jr .asm_188da

.asm_188ca
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $1
	ld [wGengarYPos + 1], a
.asm_188da
	ld a, [wGengarAnimationState]
	ld [wd6a3], a
	ret

Func_188e1: ; 0x188e1
	ld a, [wd6a3]
	cp $1
	jr z, .asm_18901
	cp $2
	jr z, .asm_18901
	ld a, [wGengarAnimationState]
	cp $1
	jr z, .asm_188f7
	cp $2
	jr nz, .asm_18901
.asm_188f7
	ld a, $1
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
.asm_18901
	ld a, [wGengarAnimationState]
	cp $6
	ret z
	ld a, [wGengarAnimationState]
	ld hl, wd6a3
	cp [hl]
	ret z
	ld a, [wd69c]
	cp $3
	jr nz, .asm_1891d
	ld a, [wd69b]
	cp $9
	jr c, .asm_18945
.asm_1891d
	ld a, [wGengarAnimationState]
	and a
	jr z, .asm_18935
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $fd
	ld [wGengarYPos + 1], a
	jr .asm_18945

.asm_18935
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $ff
	ld [wGengarYPos + 1], a
.asm_18945
	ld a, [wGengarAnimationState]
	ld [wd6a3], a
	ret

Func_1894c: ; 0x1894c
	ld a, [wd6a6]
	and a
	jr nz, .asm_1898f
	ld a, [wd6a4]
	and a
	jr z, .asm_1898f
	ld a, [wd6a5]
	cp $3
	jr z, .asm_18980
	inc a
	ld [wd6a5], a
	ld a, [wPinballIsVisible]
	ld hl, wEnableBallGravityAndTilt
	and [hl]
	jr z, .asm_18973
	ld a, [wBallYPos + 1]
	inc a
	ld [wBallYPos + 1], a
.asm_18973
	ld a, [wUpperTiltPixelsOffset]
	dec a
	ld [wUpperTiltPixelsOffset], a
	ld a, $1
	ld [wUpperTiltPushing], a
	ret

.asm_18980
	lb de, $00, $2b
	call PlaySoundEffect
	ld a, $1
	ld [wd6a6], a
	xor a
	ld [wd6a4], a
.asm_1898f
	xor a
	ld [wUpperTiltPushing], a
	ld a, [wd6a5]
	and a
	jr z, .asm_189a5
	dec a
	ld [wd6a5], a
	ld a, [wUpperTiltPixelsOffset]
	inc a
	ld [wUpperTiltPixelsOffset], a
	ret

.asm_189a5
	ld a, [wd6a4]
	and a
	ret nz
	xor a
	ld [wd6a6], a
	ret

Func_189af: ; 0x189af
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, AnimationDataPointers_18a57
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	dec de
	call UpdateAnimation
	pop de
	ret nc
	ld a, [de]
	dec de
	and a
	jr nz, .asm_189d7
	ld a, [de]
	cp $4
	ret nz
	ld hl, AnimationData_18a61
	dec de
	dec de
	call InitAnimation
	ret

.asm_189d7
	cp $1
	jr nz, .asm_189ed
	ld a, [de]
	cp $60
	ret nz
	ld hl, AnimationData_18a61
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	xor a
	ld [de], a
	ret

.asm_189ed
	cp $2
	jr nz, .asm_18a04
	ld a, [de]
	cp $3
	ret nz
	ld hl, AnimationData_18a6a
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	ld a, $1
	ld [de], a
	ret

.asm_18a04
	cp $3
	jr nz, .asm_18a3c
	ld a, [de]
	cp $1
	jr nz, .asm_18a14
	lb de, $00, $2e
	call PlaySoundEffect
	ret

.asm_18a14
	cp $fe
	ret nz
	ld a, $1
	ld [wd6a8], a
	ld a, BONUS_STAGE_ORDER_MEWTWO
	ld [wNextBonusStage], a
	ld a, $1
	ld [wCompletedBonusStage], a
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText3
	ld de, GengarStageClearedText
	call LoadScrollingText
	lb de, $4b, $2a
	call PlaySoundEffect
	ret

.asm_18a3c
	cp $4
	ret nz
	ld a, [de]
	cp $2
	ret nz
	ld hl, AnimationData_18a61
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	xor a
	ld [de], a
	ld de, $0007
	call PlaySong
	ret

AnimationDataPointers_18a57:
	dw AnimationData_18a61
	dw AnimationData_18a6a
	dw AnimationData_18b2b
	dw AnimationData_18b32
	dw AnimationData_18d2f

AnimationData_18a61:
; Each entry is [duration][frame]
	db $40, $01
	db $10, $00
	db $40, $02
	db $10, $00
	db $00 ; terminator

AnimationData_18a6a:
; Each entry is [duration][frame]
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $01, $00
	db $01, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $01, $03
	db $01, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $01, $03
	db $01, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $01, $04
	db $01, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $00
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $04
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $02, $03
	db $01, $06
	db $00 ; terminator

AnimationData_18b2b:
; Each entry is [duration][frame]
	db $10, $05
	db $20, $01
	db $08, $00
	db $00 ; terminator

AnimationData_18b32:
; Each entry is [duration][frame]
	db $10, $05
	db $10, $00
	db $08, $03
	db $0C, $04
	db $0A, $03
	db $10, $00
	db $08, $03
	db $0C, $04
	db $0A, $03
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $00
	db $04, $06
	db $04, $00
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $00
	db $04, $06
	db $04, $00
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $01
	db $04, $06
	db $04, $00
	db $04, $06
	db $04, $00
	db $04, $06
	db $04, $02
	db $04, $06
	db $04, $02
	db $04, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $00
	db $03, $06
	db $03, $00
	db $03, $06
	db $03, $00
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $03, $01
	db $03, $06
	db $02, $01
	db $01, $00
	db $03, $06
	db $03, $00
	db $03, $06
	db $03, $00
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $03, $02
	db $03, $06
	db $02, $02
	db $02, $06
	db $02, $02
	db $02, $06
	db $02, $02
	db $02, $06
	db $02, $02
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $01
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $00
	db $02, $06
	db $02, $02
	db $02, $06
	db $02, $02
	db $02, $06
	db $02, $02
	db $02, $06
	db $02, $02
	db $02, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $02
	db $01, $06
	db $01, $00
	db $01, $06
	db $01, $00
	db $01, $06
	db $00 ; terminator

AnimationData_18d2f:
; Each entry is [duration][frame]
	db $40, $00
	db $40, $00
	db $00 ; terminator

Func_18d34: ; 0x18d34
	ld a, [wWhichGravestone]
	and a
	jr z, .asm_18d71
	xor a
	ld [wWhichGravestone], a
	ld a, [wd7be]
	and a
	jr nz, .asm_18d71
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueue
	ld a, $ff
	ld [wRumblePattern], a
	ld a, $3
	ld [wRumbleDuration], a
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld de, $002f
	call PlaySFXIfNoneActive
.asm_18d71
	ret

Func_18d72: ; 0x18d72
	ld a, [wd656]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_18ddb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_18d85
	ld hl, TileDataPointers_18ed1
.asm_18d85
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_18ddb)
	call QueueGraphicsToLoad
	ret

Func_18d91: ; 0x18d91
	ld a, [wd656]
	and a
	ld hl, Data_18dc9
	jr z, .asm_18d9d
	ld hl, Data_18dd2
.asm_18d9d
	ld de, wStageCollisionMap + $c7
	call Func_18db2
	ld de, wStageCollisionMap + $ae
	call Func_18db2
	ld de, wStageCollisionMap + $123
	call Func_18db2
	ld de, wStageCollisionMap + $14d
	; fall through

Func_18db2: ; 0x18db2
	push hl
	ld b, $3
.asm_18db5
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add $1e
	ld e, a
	jr nc, .asm_18dc4
	inc d
.asm_18dc4
	dec b
	jr nz, .asm_18db5
	pop hl
	ret

Data_18dc9:
	db $19, $1A, $1B
	db $1C, $27, $1D
	db $1E, $1F, $20

Data_18dd2:
	db $00, $00, $00
	db $00, $00, $00
	db $00, $00, $00

TileDataPointers_18ddb:
	dw TileData_18ddf
	dw TileData_18df4

TileData_18ddf: ; 0x18ddf
	db $0A
	dw TileData_18e09
	dw TileData_18e13
	dw TileData_18e1d
	dw TileData_18e27
	dw TileData_18e31
	dw TileData_18e3b
	dw TileData_18e45
	dw TileData_18e4f
	dw TileData_18e59
	dw TileData_18e63

TileData_18df4: ; 0x18df4
	db $0A
	dw TileData_18e6d
	dw TileData_18e77
	dw TileData_18e81
	dw TileData_18e8b
	dw TileData_18e95
	dw TileData_18e9f
	dw TileData_18ea9
	dw TileData_18eb3
	dw TileData_18ebd
	dw TileData_18ec7

TileData_18e09: ; 0x18e09
	dw Func_11d2
	db $30, $03
	dw $9640
	dw GengarBonusBaseGameBoyGfx + $E40
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e13: ; 0x18e13
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $67
	dw GengarBonusBaseGameBoyGfx + $E70
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e1d: ; 0x18e1d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6A
	dw GengarBonusBaseGameBoyGfx + $EA0
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e27: ; 0x18e27
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6D
	dw GengarBonusBaseGameBoyGfx + $ED0
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e31: ; 0x18e31
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $70
	dw GengarBonusBaseGameBoyGfx + $F00
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e3b: ; 0x18e3b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $73
	dw GengarBonusBaseGameBoyGfx + $F30
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e45: ; 0x18e45
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $76
	dw GengarBonusBaseGameBoyGfx + $F60
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e4f: ; 0x18e4f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $79
	dw GengarBonusBaseGameBoyGfx + $F90
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e59: ; 0x18e59
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $7C
	dw GengarBonusBaseGameBoyGfx + $FC0
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e63: ; 0x18e63
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7F
	dw GengarBonusBaseGameBoyGfx + $FF0
	db Bank(GengarBonusBaseGameBoyGfx)
	db $00

TileData_18e6d: ; 0x18e6d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $64
	dw GengarBonusGroundGfx
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18e77: ; 0x18e77
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $67
	dw GengarBonusGroundGfx + $30
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18e81: ; 0x18e81
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6A
	dw GengarBonusGroundGfx + $60
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18e8b: ; 0x18e8b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6D
	dw GengarBonusGroundGfx + $90
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18e95: ; 0x18e95
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $70
	dw GengarBonusGroundGfx + $C0
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18e9f: ; 0x18e9f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $73
	dw GengarBonusGroundGfx + $F0
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18ea9: ; 0x18ea9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $76
	dw GengarBonusGroundGfx + $120
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18eb3: ; 0x18eb3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $79
	dw GengarBonusGroundGfx + $150
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18ebd: ; 0x18ebd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $7C
	dw GengarBonusGroundGfx + $180
	db Bank(GengarBonusGroundGfx)
	db $00

TileData_18ec7: ; 0x18ec7
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7F
	dw GengarBonusGroundGfx + $1B0
	db Bank(GengarBonusGroundGfx)
	db $00

TileDataPointers_18ed1:
	dw TileData_18ed5
	dw TileData_18ede

TileData_18ed5: ; 0x18ed5
	db $04
	dw TileData_18ee7
	dw TileData_18f03
	dw TileData_18f19
	dw TileData_18f2f

TileData_18ede: ; 0x18ede
	db $04
	dw TileData_18f4b
	dw TileData_18f67
	dw TileData_18f7d
	dw TileData_18f93

TileData_18ee7: ; 0x18ee7
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $67
	db $26, $27, $28

	db $03 ; number of tiles
	dw vBGMap + $87
	db $1C, $1D, $1E

	db $03 ; number of tiles
	dw vBGMap + $A7
	db $3A, $13, $14

	db $03 ; number of tiles
	dw vBGMap + $C7
	db $31, $32, $09

	db $00 ; terminator

TileData_18f03: ; 0x18f03
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $6E
	db $47, $48, $49

	db $03 ; number of tiles
	dw vBGMap + $8E
	db $3A, $13, $14

	db $03 ; number of tiles
	dw vBGMap + $AE
	db $31, $32, $3B

	db $00 ; terminator ; number of tiles

TileData_18f19: ; 0x18f19
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $E3
	db $23, $24, $25

	db $03 ; number of tiles
	dw vBGMap + $103
	db $19, $1A, $1B

	db $03 ; number of tiles
	dw vBGMap + $123
	db $0E, $0F, $10

	db $00 ; terminator ; number of tiles

TileData_18f2f: ; 0x18f2f
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $ED
	db $26, $27, $28

	db $03 ; number of tiles
	dw vBGMap + $10D
	db $1C, $1D, $1E

	db $03 ; number of tiles
	dw vBGMap + $12D
	db $12, $13, $14

	db $03 ; number of tiles
	dw vBGMap + $14D
	db $07, $08, $09

	db $00 ; terminator

TileData_18f4b: ; 0x18f4b
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $67
	db $D9, $D9, $D9

	db $03 ; number of tiles
	dw vBGMap + $87
	db $D9, $D9, $D9

	db $03 ; number of tiles
	dw vBGMap + $A7
	db $74, $75, $76

	db $03 ; number of tiles
	dw vBGMap + $C7
	db $77, $78, $79

	db $00 ; terminator

TileData_18f67: ; 0x18f67
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $6E
	db $D9, $D9, $D9

	db $03 ; number of tiles
	dw vBGMap + $8E
	db $74, $75, $76

	db $03 ; number of tiles
	dw vBGMap + $AE
	db $77, $78, $7F

	db $00 ; terminator ; number of tiles

TileData_18f7d: ; 0x18f7d
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $E3
	db $DB, $38, $39

	db $03 ; number of tiles
	dw vBGMap + $103
	db $7A, $7B, $7C

	db $03 ; number of tiles
	dw vBGMap + $123
	db $7D, $7E, $7F

	db $00 ; terminator ; number of tiles

TileData_18f93: ; 0x18f93
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $ED
	db $D9, $D9, $D9

	db $03 ; number of tiles
	dw vBGMap + $10D
	db $D9, $D9, $D9

	db $03 ; number of tiles
	dw vBGMap + $12D
	db $74, $75, $76

	db $03 ; number of tiles
	dw vBGMap + $14D
	db $77, $78, $79

	db $00 ; terminator
