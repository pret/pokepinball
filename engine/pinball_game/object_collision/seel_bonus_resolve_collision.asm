ResolveSeelBonusGameObjectCollisions: ; 0x25c5a
	call Func_25da3
	call TryCloseGate_SeelBonus
	ld a, [wSeelStageScore]
	cp 20
	jr c, .asm_25c98
	ld a, [wd794]
	cp $2
	jr nc, .asm_25c98
	ld a, BONUS_STAGE_ORDER_MEWTWO
	ld [wNextBonusStage], a
	ld de, MUSIC_NOTHING
	call PlaySong
	ld a, $1
	ld [wCompletedBonusStage], a
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText3
	ld de, SeelStageClearedText
	call LoadScrollingText
	ld a, $2
	ld [wd794], a
	lb de, $4b, $2a
	call PlaySoundEffect
.asm_25c98
	ld a, [wd794]
	cp $2
	jr nz, .asm_25cb0
	ld a, [wSFXTimer]
	and a
	jr nz, .asm_25cb0
	ld de, MUSIC_SEEL_STAGE
	call PlaySong
	ld a, $5
	ld [wd794], a
.asm_25cb0
	ld a, [wd794]
	cp $2
	jr z, .asm_25cc1
	callba PlayLowTimeSfx
.asm_25cc1
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $1
	ld [wFlippersDisabled], a
	call LoadFlippersPalette
	callba StopTimer
	ld a, $3
	ld [wd791], a
	ld a, [wd794]
	cp $5
	ret z
	ld a, $1
	ld [wd794], a
	ret

TryCloseGate_SeelBonus: ; 0x25ced
	ld a, [wSeelBonusClosedGate]
	and a
	ret nz
	ld a, [wBallXPos + 1]
	cp 138
	ret nc
	ld a, 1
	ld [wStageCollisionState], a
	ld [wSeelBonusClosedGate], a
	callba LoadStageCollisionAttributes
	call Func_25d0e
	ret

Func_25d0e: ; 0x25d0e
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_25d2b
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_25d21
	ld hl, TileDataPointers_25d67
.asm_25d21
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_25d2b)
	call QueueGraphicsToLoad
	ret

TileDataPointers_25d2b:
	dw TileData_25d2f
	dw TileData_25d32

TileData_25d2f: ; 0x25d2f
	db $01
	dw TileData_25d35

TileData_25d32: ; 0x25d32
	db $01
	dw TileData_25d4e

TileData_25d35: ; 0x25d35
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $1F, $20

	db $02 ; number of tiles
	dw vBGMap + $133
	db $1D, $1E

	db $03 ; number of tiles
	dw vBGMap + $152
	db $80, $1B, $1C

	db $02 ; number of tiles
	dw vBGMap + $172
	db $17, $18

	db $00 ; terminator

TileData_25d4e: ; 0x25d4e
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $24, $F9

	db $02 ; number of tiles
	dw vBGMap + $133
	db $22, $04

	db $03 ; number of tiles
	dw vBGMap + $152
	db $36, $37, $FE

	db $02 ; number of tiles
	dw vBGMap + $172
	db $35, $F9

	db $00 ; terminator

TileDataPointers_25d67:
	dw TileData_25d6b
	dw TileData_25d6e

TileData_25d6b: ; 0x25d6b
	db $01
	dw TileData_25d71

TileData_25d6e: ; 0x25d6e
	db $01
	dw TileData_25d8a

TileData_25d71: ; 0x25d71
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $11, $10

	db $02 ; number of tiles
	dw vBGMap + $133
	db $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $152
	db $80, $0B, $0A

	db $02
	dw vBGMap + $172
	db $07, $06

	db $00 ; terminator

TileData_25d8a: ; 0x25d8a
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $0F, $F4

	db $02 ; number of tiles
	dw vBGMap + $133
	db $0C, $FB

	db $03 ; number of tiles
	dw vBGMap + $152
	db $09, $08, $F8

	db $02
	dw vBGMap + $172
	db $04, $F4

	db $00 ; terminator

Func_25da3: ; 0x25da3
	ld a, [wd767]
	and a
	jp z, .asm_25e38
	xor a
	ld [wd767], a
	ld a, [wd768]
	sla a
	ld c, a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd76c
	add hl, bc
	ld d, h
	ld e, l
	ld a, $9
	ld [de], a
	dec de
	dec de
	dec de
	push bc
	ld hl, SeelAnimationData10
	call InitAnimation
	pop bc
	ld hl, wd76e
	add hl, bc
	ld a, [hl]
	ld [wd79c], a
	ld hl, wd770
	add hl, bc
	ld a, [hl]
	add $8
	ld [wd79e], a
	ld a, [wSeelStageStreak]
	cp 9
	jr nz, .asm_25df1
	ld a, 0
	ld [wSeelStageStreak], a
	ld [wd79a], a
.asm_25df1
	ld a, [wSeelStageStreak]
	dec a
	cp $ff
	jr z, .asm_25e04
	ld [wd79a], a
	ld de, wd79a
	call Func_261f9
	jr .asm_25e07

.asm_25e04
	ld [wd79a], a
.asm_25e07
	ld a, $33
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	lb de, $00, $30
	call PlaySoundEffect
	call Func_25e85
	ld hl, wSeelStageStreak
	inc [hl]
	ld a, [wSeelStageScore]
	cp 20
	ret nc
	ld hl, wSeelStageScore
	inc [hl]
	ld a, [wSeelStageStreak]
	dec a
	ld b, a
	ld a, [hl]
	add b
	ld [hl], a
	ld a, $1
	ld [wd64e], a
	call Func_262f4
.asm_25e38
	ld de, wd76c
	call UpdateSeelAnimation
	ld de, wd776
	call UpdateSeelAnimation
	ld de, wd780
	call UpdateSeelAnimation
	ld a, [wSeelStageStreak]
	dec a
	cp $ff
	jr z, .asm_25e5d
	ld [wd79a], a
	ld de, wd79a
	call Func_26212
	jr .asm_25e60

.asm_25e5d
	ld [wd79a], a
.asm_25e60
	ld bc, $087a  ; again, probably one call for each Seel swimming around
	ld de, wd76d
	ld hl, wd772
	call UpdateSeelPosition
	ld bc, $087a
	ld de, wd777
	ld hl, wd77c
	call UpdateSeelPosition
	ld bc, $087a
	ld de, wd781
	ld hl, wd786
	call UpdateSeelPosition
	ret

Func_25e85: ; 0x25e85
	ld a, [wSeelStageStreak]
	inc a
	ld d, $1
	ld e, a
	ld a, $1
.asm_25e8e
	cp e
	jr z, .asm_25e96
	sla d
	inc a
	jr .asm_25e8e

.asm_25e96
	push de
	ld a, d
	cp $32
	jr nc, .asm_25ead
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	pop de
	dec d
	jr .asm_25ebf

.asm_25ead
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	pop de
	ld a, d
	sub $32
	ld d, a
.asm_25ebf
	ld a, d
	cp $0
	jr nz, .asm_25e96
	ret

UpdateSeelPosition: ; 0x25ec5
	dec de
	ld a, [de]
	cp $1
	jr z, .asm_25ece
	cp $4
	ret nz
.asm_25ece
	inc de
	push hl
	ld a, [hld]
	push af
	push bc
	ld a, [hl]
	and $f
	ld c, a
	ld b, $0
	ld hl, SeelSwimmingXDeltas
	add hl, bc
	pop bc
	pop af
	and a
	jr nz, .swimmingLeft
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
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld a, $7
	ld [hl], a
	dec hl
	dec hl
	dec hl
	ld d, h
	ld e, l
	ld hl, SeelAnimationData8
	call InitAnimation
	ret

.swimmingLeft
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
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld a, $8
	ld [hl], a
	dec hl
	dec hl
	dec hl
	ld d, h
	ld e, l
	ld hl, SeelAnimationData9
	call InitAnimation
	ret

SeelSwimmingXDeltas:
	db $31, $32, $33, $34, $35, $36, $37, $36, $35, $34, $33, $32, $33, $34, $35, $36
	db $37, $38, $39, $3A, $3B, $3A, $39, $38, $37, $36, $35, $34, $33, $32, $31, $30

UpdateSeelAnimation: ; 0x25f47
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, SeelAnimationsTable
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
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_25f5f: ; 0x25f5f
	dw Func_25f77
	dw Func_25fbe
	dw Func_25ff3
	dw Func_2602a
	dw Func_2604c
	dw Func_2607f
	dw Func_260b6
	dw Func_260d8
	dw Func_260e2
	dw Func_260ec
	dw Func_26109
	dw Func_26120

Func_25f77: ; 0x25f77
	dec de
	ld a, [de]
	cp $2
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ld a, $3
	jr z, .asm_25f8f
	pop de
	xor a
	jp Func_26137

.asm_25f8f
	ld hl, wSeelStageStreak
	ld [hl], $0
	call GenRandom
	bit 7, a
	jr z, .asm_25fa2
	inc de
	ld a, $1
	ld [de], a
	dec de
	jr .asm_25fa7

.asm_25fa2
	inc de
	ld a, $0
	ld [de], a
	dec de
.asm_25fa7
	inc de
	ld a, [de]
	and a
	jr z, .asm_25fb0
	ld a, $6
	jr .asm_25fb2

.asm_25fb0
	ld a, $3
.asm_25fb2
	push af
	lb de, $00, $31
	call PlaySoundEffect
	pop af
	pop de
	jp Func_26137

Func_25fbe: ; 0x25fbe
	dec de
	ld a, [de]
	cp $4
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	dec a
	ld [de], a
	jr z, .asm_25fd5
	pop de
	ld a, $1
	jp Func_26137

.asm_25fd5
	ld a, [wd791]
	cp $0
	jr z, .asm_25fe9
	ld a, $2
	ld [de], a
	pop de
	ld a, $4
	ld [de], a
	ld a, $1
	jp Func_26137
	ret ; unused instruction

.asm_25fe9
	ld hl, wd791
	inc [hl]
	pop de
	ld a, $2
	jp Func_26137

Func_25ff3: ; 0x25ff3
	dec de
	ld a, [de]
	cp $7
	ret nz
	xor a
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [wSeelStageStreak]
	cp $6
	jr nc, .asm_26020
	cp $2
	jr nc, .asm_26016
	ld a, $3
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_26016
	ld a, $2
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_26020
	ld a, $1
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

Func_2602a: ; 0x2602a
	dec de
	ld a, [de]
	cp $9
	ret nz
	ld a, $1
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	call GenRandom
	bit 7, a
	jr z, .asm_26044
	ld a, $3
	jr .asm_26046

.asm_26044
	ld a, $5
.asm_26046
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_2604c: ; 0x2604c
	dec de
	ld a, [de]
	cp $4
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	dec a
	ld [de], a
	jr z, .asm_26063
	pop de
	ld a, $4
	jp Func_26137

.asm_26063
	ld a, [wd791]
	cp $0
	jr z, .asm_26075
	ld a, $2
	ld [de], a
	pop de
	ld a, $4
	ld [de], a
	jp Func_26137
	ret ; unused instruction

.asm_26075
	ld hl, wd791
	inc [hl]
	pop de
	ld a, $5
	jp Func_26137

Func_2607f: ; 0x2607f
	dec de
	ld a, [de]
	cp $7
	ret nz
	xor a
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [wSeelStageStreak]
	cp $6
	jr nc, .asm_260ac
	cp $2
	jr nc, .asm_260a2
	ld a, $3
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_260a2
	ld a, $2
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_260ac
	ld a, $1
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

Func_260b6: ; 0x260b6
	dec de
	ld a, [de]
	cp $9
	ret nz
	ld a, $4
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	call GenRandom
	bit 7, a
	jr z, .asm_260d0
	ld a, $3
	jr .asm_260d2

.asm_260d0
	ld a, $5
.asm_260d2
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_260d8: ; 0x260d8
	dec de
	ld a, [de]
	cp $5
	ret nz
	ld a, $4
	jp Func_26137

Func_260e2: ; 0x260e2
	dec de
	ld a, [de]
	cp $5
	ret nz
	ld a, $1
	jp Func_26137

Func_260ec: ; 0x260ec
	dec de
	ld a, [de]
	cp $1
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	and a
	jr z, .asm_26103
	pop de
	ld a, $b
	jp Func_26137

.asm_26103
	pop de
	ld a, $a
	jp Func_26137

Func_26109: ; 0x26109
	dec de
	ld a, [de]
	cp $7
	ret nz
	ld a, $1
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, $5
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_26120: ; 0x26120
	dec de
	ld a, [de]
	cp $7
	ret nz
	ld a, $4
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, $5
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_26137: ; 0x26137
	push af
	sla a
	ld c, a
	ld b, $0
	ld hl, SeelAnimationsTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	pop af
	ld [de], a
	ret

SeelAnimationsTable: ; 0x2614f
	dw SeelAnimationData1
	dw SeelAnimationData2
	dw SeelAnimationData3
	dw SeelAnimationData4
	dw SeelAnimationData5
	dw SeelAnimationData6
	dw SeelAnimationData7
	dw SeelAnimationData8
	dw SeelAnimationData9
	dw SeelAnimationData10
	dw SeelAnimationData11
	dw SeelAnimationData12

SeelAnimationData1:
	db $1C, $00
	db $1C, $01
	db $00 ; terminator

SeelAnimationData2:
	db $0C, $03
	db $08, $04
	db $0C, $05
	db $08, $04
	db $00 ; terminator

SeelAnimationData3:
	db $04, $06
	db $04, $07
	db $05, $08
	db $05, $09
	db $06, $0A
	db $04, $0B
	db $08, $0C
	db $00 ; terminator

SeelAnimationData4:
	db $08, $0C
	db $04, $0B
	db $06, $0D
	db $10, $17
	db $06, $0A
	db $05, $09
	db $05, $08
	db $04, $0E
	db $04, $0F
	db $00 ; terminator

SeelAnimationData5:
	db $0C, $10
	db $08, $11
	db $0C, $12
	db $08, $11
	db $00 ; terminator

SeelAnimationData6:
	db $04, $13
	db $04, $14
	db $05, $08
	db $05, $09
	db $06, $0A
	db $04, $0B
	db $08, $0C
	db $00 ; terminator

SeelAnimationData7:
	db $08, $0C
	db $04, $0B
	db $06, $0D
	db $10, $17
	db $06, $0A
	db $05, $09
	db $05, $08
	db $04, $15
	db $04, $16
	db $00 ; terminator

SeelAnimationData8:
	db $04, $06
	db $04, $07
	db $06, $0A
	db $04, $15
	db $04, $16
	db $00 ; terminator

SeelAnimationData9:
	db $04, $13
	db $04, $14
	db $06, $0A
	db $04, $0E
	db $04, $0F
	db $00 ; terminator

SeelAnimationData10:
	db $10, $02
	db $00 ; terminator

SeelAnimationData11:
	db $06, $0D
	db $10, $17
	db $06, $0A
	db $05, $09
	db $05, $08
	db $04, $0E
	db $04, $0F
	db $00 ; terminator

SeelAnimationData12:
	db $06, $0D
	db $10, $17
	db $06, $0A
	db $05, $09
	db $05, $08
	db $04, $15
	db $04, $16
	db $00 ; terminator

Func_261f9: ; 0x261f9
	ld a, $ff
	ld [wd795], a
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, SeelStageAnimations
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec de
	dec de
	dec de
	call InitAnimation
	ret

Func_26212: ; 0x26212
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, SeelStageAnimations
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
	dec de
	ld a, [de]
	cp $a
	ret nz
	xor a
	ld [de], a
	ld [wd79c], a
	ld [wd79e], a
	ld a, a
	ld [wd795], a
	ret

SeelStageAnimations:
	dw SeelStageAnimationData1
	dw SeelStageAnimationData1
	dw SeelStageAnimationData2
	dw SeelStageAnimationData3
	dw SeelStageAnimationData4
	dw SeelStageAnimationData5
	dw SeelStageAnimationData6
	dw SeelStageAnimationData7
	dw SeelStageAnimationData8

SeelStageAnimationData1:
	db $02, $00
	db $02, $01
	db $02, $02
	db $10, $00
	db $04, $18
	db $04, $00
	db $04, $18
	db $04, $00
	db $04, $18
	db $04, $00
	db $00 ; terminator

SeelStageAnimationData2:
	db $02, $03
	db $02, $04
	db $02, $05
	db $10, $03
	db $04, $18
	db $04, $03
	db $04, $18
	db $04, $03
	db $04, $18
	db $04, $03
	db $00 ; terminator

SeelStageAnimationData3:
	db $02, $06
	db $02, $07
	db $02, $08
	db $10, $06
	db $04, $18
	db $04, $06
	db $04, $18
	db $04, $06
	db $04, $18
	db $04, $06
	db $00 ; terminator

SeelStageAnimationData4:
	db $02, $09
	db $02, $0A
	db $02, $0B
	db $10, $09
	db $04, $18
	db $04, $09
	db $04, $18
	db $04, $09
	db $04, $18
	db $04, $09
	db $00 ; terminator

SeelStageAnimationData5:
	db $02, $0C
	db $02, $0D
	db $02, $0E
	db $10, $0C
	db $04, $18
	db $04, $0C
	db $04, $18
	db $04, $0C
	db $04, $18
	db $04, $0C
	db $00 ; terminator

SeelStageAnimationData6:
	db $02, $0F
	db $02, $10
	db $02, $11
	db $10, $0F
	db $04, $18
	db $04, $0F
	db $04, $18
	db $04, $0F
	db $04, $18
	db $04, $0F
	db $00 ; terminator

SeelStageAnimationData7:
	db $02, $12
	db $02, $13
	db $02, $14
	db $10, $12
	db $04, $18
	db $04, $12
	db $04, $18
	db $04, $12
	db $04, $18
	db $04, $12
	db $00 ; terminator

SeelStageAnimationData8:
	db $02, $15
	db $02, $16
	db $02, $17
	db $10, $15
	db $04, $18
	db $04, $15
	db $04, $18
	db $04, $15
	db $04, $18
	db $04, $15
	db $00 ; terminator

Func_262f4: ; 0x262f4
	ld a, [wSeelStageScore]
	ld c, a
	ld b, $0
.asm_262fa
	ld a, c
	and a
	jr z, .asm_26306
	ld a, b
	add $8
	ld b, a
	dec c
	ld a, c
	jr .asm_262fa

.asm_26306
	ld a, b
	and a
	jr z, .asm_2630c
	sub $8
.asm_2630c
	ld [wd652], a
	ld a, [wSeelStageStreak]
	and a
	jr z, .asm_2631b
	ld b, a
	ld a, [wSeelStageScore]
	inc a
	sub b
.asm_2631b
	ld [wd651], a
	ld a, [wSeelStageScore]
	cp 21
	jr c, .asm_2632a
	ld a, 20
	ld [wSeelStageScore], a
.asm_2632a
	push af
	xor a
	ld [wd650], a
	pop af
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_2634a
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_26340
	ld hl, TileDataPointers_26764
.asm_26340
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_2634a)
	call QueueGraphicsToLoad
	ret

TileDataPointers_2634a:
	dw TileData_26374
	dw TileData_26377
	dw TileData_2637a
	dw TileData_2637d
	dw TileData_26380
	dw TileData_26383
	dw TileData_26386
	dw TileData_26389
	dw TileData_2638c
	dw TileData_2638f
	dw TileData_26392
	dw TileData_26395
	dw TileData_26398
	dw TileData_2639b
	dw TileData_2639e
	dw TileData_263a1
	dw TileData_263a4
	dw TileData_263a7
	dw TileData_263aa
	dw TileData_263ad
	dw TileData_263b0

TileData_26374: ; 0x26374
	db $01
	dw TileData_263b3

TileData_26377: ; 0x26377
	db $01
	dw TileData_263e0

TileData_2637a: ; 0x2637a
	db $01
	dw TileData_2640d

TileData_2637d: ; 0x2637d
	db $01
	dw TileData_2643a

TileData_26380: ; 0x26380
	db $01
	dw TileData_26467

TileData_26383: ; 0x26383
	db $01
	dw TileData_26494

TileData_26386: ; 0x26386
	db $01
	dw TileData_264c1

TileData_26389: ; 0x26389
	db $01
	dw TileData_264ee

TileData_2638c: ; 0x2638c
	db $01
	dw TileData_2651b

TileData_2638f: ; 0x2638f
	db $01
	dw TileData_26548

TileData_26392: ; 0x26392
	db $01
	dw TileData_26575

TileData_26395: ; 0x26395
	db $01
	dw TileData_265a2

TileData_26398: ; 0x26398
	db $01
	dw TileData_265cf

TileData_2639b: ; 0x2639b
	db $01
	dw TileData_265fc

TileData_2639e: ; 0x2639e
	db $01
	dw TileData_26629

TileData_263a1: ; 0x263a1
	db $01
	dw TileData_26656

TileData_263a4: ; 0x263a4
	db $01
	dw TileData_26683

TileData_263a7: ; 0x263a7
	db $01
	dw TileData_266b0

TileData_263aa: ; 0x263aa
	db $01
	dw TileData_266dd

TileData_263ad: ; 0x263ad
	db $01
	dw TileData_2670a

TileData_263b0: ; 0x263b0
	db $01
	dw TileData_26737

TileData_263b3: ; 0x263b3
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $01, $30, $31

	db $03 ; number of tiles
	dw vBGMap + $3
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_263e0: ; 0x263e0
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $30, $31

	db $03 ; number of tiles
	dw vBGMap + $3
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_2640d: ; 0x2640d
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $31

	db $03 ; number of tiles
	dw vBGMap + $3
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_2643a: ; 0x2643a
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26467: ; 0x26467
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26494: ; 0x26494
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $32

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_264c1: ; 0x264c1
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_264ee: ; 0x264ee
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_2651b: ; 0x2651b
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $32

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26548: ; 0x26548
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26575: ; 0x26575
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_265a2: ; 0x265a2
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $32

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_265cf: ; 0x265cf
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $32, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_265fc: ; 0x265fc
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $32, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26629: ; 0x26629
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $32

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26656: ; 0x26656
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $32, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_26683: ; 0x26683
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $3A, $32, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_266b0: ; 0x266b0
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $3A, $3A, $33

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_266dd: ; 0x266dd
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $3A, $3A, $3A

	db $02 ; number of tiles
	dw vBGMap + $12
	db $34, $04

	db $00 ; terminator

TileData_2670a: ; 0x2670a
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $3A, $3A, $3A

	db $02 ; number of tiles
	dw vBGMap + $12
	db $3B, $04

	db $00 ; terminator

TileData_26737: ; 0x26737
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $38, $39, $3A

	db $03 ; number of tiles
	dw vBGMap + $3
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $3A, $3A, $3A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $3A, $3A, $3A

	db $02 ; number of tiles
	dw vBGMap + $12
	db $3B, $38

	db $00 ; terminator

TileDataPointers_26764:
	dw TileData_2678e
	dw TileData_26791
	dw TileData_26794
	dw TileData_26797
	dw TileData_2679a
	dw TileData_2679d
	dw TileData_267a0
	dw TileData_267a3
	dw TileData_267a6
	dw TileData_267a9
	dw TileData_267ac
	dw TileData_267af
	dw TileData_267b2
	dw TileData_267b5
	dw TileData_267b8
	dw TileData_267bb
	dw TileData_267be
	dw TileData_267c1
	dw TileData_267c4
	dw TileData_267c7
	dw TileData_267ca

TileData_2678e: ; 0x2678e
	db $01
	dw TileData_267cd

TileData_26791: ; 0x26791
	db $01
	dw TileData_267fa

TileData_26794: ; 0x26794
	db $01
	dw TileData_26827

TileData_26797: ; 0x26797
	db $01
	dw TileData_26854

TileData_2679a: ; 0x2679a
	db $01
	dw TileData_26881

TileData_2679d: ; 0x2679d
	db $01
	dw TileData_268ae

TileData_267a0: ; 0x267a0
	db $01
	dw TileData_268db

TileData_267a3: ; 0x267a3
	db $01
	dw TileData_26908

TileData_267a6: ; 0x267a6
	db $01
	dw TileData_26935

TileData_267a9: ; 0x267a9
	db $01
	dw TileData_26962

TileData_267ac: ; 0x267ac
	db $01
	dw TileData_2698f

TileData_267af: ; 0x267af
	db $01
	dw TileData_269bc

TileData_267b2: ; 0x267b2
	db $01
	dw TileData_269e9

TileData_267b5: ; 0x267b5
	db $01
	dw TileData_26a16

TileData_267b8: ; 0x267b8
	db $01
	dw TileData_26a43

TileData_267bb: ; 0x267bb
	db $01
	dw TileData_26a70

TileData_267be: ; 0x267be
	db $01
	dw TileData_26a9d

TileData_267c1: ; 0x267c1
	db $01
	dw TileData_26aca

TileData_267c4: ; 0x267c4
	db $01
	dw TileData_26af7

TileData_267c7: ; 0x267c7
	db $01
	dw TileData_26b24

TileData_267ca: ; 0x267ca
	db $01
	dw TileData_26b51

TileData_267cd: ; 0x267cd
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FB, $18, $19

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_267fa: ; 0x267fa
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $18, $19

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26827: ; 0x26827
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $19

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26854: ; 0x26854
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26881: ; 0x26881
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_268ae: ; 0x268ae
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1A

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_268db: ; 0x268db
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26908: ; 0x26908
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26935: ; 0x26935
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1A

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26962: ; 0x26962
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_2698f: ; 0x2698f
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_269bc: ; 0x269bc
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1A

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_269e9: ; 0x269e9
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1A, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26a16: ; 0x26a16
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1A, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26a43: ; 0x26a43
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1A

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26a70: ; 0x26a70
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1A, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26a9d: ; 0x26a9d
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1D, $1A, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26aca: ; 0x26aca
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1D, $1D, $19

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26af7: ; 0x26af7
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1D, $1D, $1D

	db $02 ; number of tiles
	dw vBGMap + $12
	db $18, $FB

	db $00 ; terminator

TileData_26b24: ; 0x26b24
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1D, $1D, $1D

	db $02 ; number of tiles
	dw vBGMap + $12
	db $1E, $FB

	db $00 ; terminator

TileData_26b51: ; 0x26b51
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $1B, $1C, $1D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $6
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $C
	db $1D, $1D, $1D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $1D, $1D, $1D

	db $02 ; number of tiles
	dw vBGMap + $12
	db $1E, $1B

	db $00 ; terminator
