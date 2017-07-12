HandleBlueCatchEmCollision: ; 0x202bc
	ld a, [wSpecialModeCollisionID]
	cp $4
	jp z, Func_204f1
	cp $c
	jp z, Func_20569
	cp $f
	jp z, Func_20573
	cp $e
	jp z, Func_2057a
	cp $0
	jr z, .asm_202d9
	scf
	ret

.asm_202d9
	call Func_204b3
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_202e2: ; 0x202e2
	padded_dab Func_20302
	padded_dab Func_20320
	padded_dab Func_2032c
	padded_dab Func_20364
	padded_dab Func_20394
	padded_dab Func_20454
	padded_dab CapturePokemonBlueStage
	padded_dab Func_2048f

Func_20302: ; 0x20302
	ld a, [wd5b6]
	cp $18
	jr nz, .asm_2031e
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_2031e
	ld hl, wd54d
	inc [hl]
	ld a, $14
	ld [wd54e], a
	ld a, $5
	ld [wd54f], a
.asm_2031e
	scf
	ret

Func_20320: ; 0x20320
	callba Func_10648
	scf
	ret

Func_2032c: ; 0x2032c
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20333
	call Func_1130
	jr nz, .asm_20362
	callba Func_10414
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_10301
.asm_20333
	ld a, $1
	ld [wd5c6], a
	ld hl, wd54d
	inc [hl]
.asm_20362
	scf
	ret

Func_20364: ; 0x20364
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20370
	call Func_1130
	jr nz, .asm_20392
.asm_20370
	callba ShowAnimatedWildMon
	callba Func_10732
	callba LoadWildMonCollisionMask
	ld hl, wd54d
	inc [hl]
.asm_20392
	scf
	ret

Func_20394: ; 0x20394
	ld a, [wd5be]
	dec a
	ld [wd5be], a
	jr z, .asm_203a7
	ld a, [wd5c4]
	inc a
	ld [wd5c4], a
	and $3
	ret nz
.asm_203a7
	ld a, [wBallHitWildMon]
	and a
	jp z, .asm_20428
	xor a
	ld [wBallHitWildMon], a
	ld a, [wd5c3]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .notMew
	ld a, [wNumMewHitsLow]
	inc a
	ld [wNumMewHitsLow], a
	jr nz, .asm_203d7
.notMew
	ld a, [wNumMonHits]
	cp $3
	jr z, .asm_20417
	inc a
	ld [wNumMonHits], a
.asm_203d7
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld bc, $0030
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wStationaryText2
	ld de, Data_2a2a
	call Func_3372
	pop de
	pop bc
	ld hl, wStationaryText1
	ld de, HitText
	call Func_3357
	ld a, [wNumMonHits]
	callba Func_10611
	ld c, $2
	jr .asm_2044b

.asm_20417
	xor a
	ld [wTimeRanOut], a
	ld a, $1
	ld [wPauseTimer], a
	ld hl, wd54d
	inc [hl]
	ld c, $2
	jr .asm_2044b

.asm_20428
	ld a, [wd5be]
	and a
	ret nz
	ld a, [wd5bc]
	ld c, a
	ld a, [wd5bd]
	sub c
	cp $1
	ld c, $0
	jr nc, .asm_2043d
	ld c, $1
.asm_2043d
	ld b, $0
	ld hl, wd5c1
	add hl, bc
	ld a, [hl]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
.asm_2044b
	ld a, [wd5bc]
	add c
	ld [wd5bd], a
	scf
	ret

Func_20454: ; 0x20454
	ld a, [wd580]
	and a
	jr z, .asm_2045f
	xor a
	ld [wd580], a
	ret

.asm_2045f
	callba BallCaptureInit
	ld hl, wd54d
	inc [hl]
	callba Func_106b6
	callba AddCaughtPokemonToParty
	scf
	ret

CapturePokemonBlueStage: ; 0x20483
	callba CapturePokemon
	scf
	ret

Func_2048f: ; 0x2048f
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba ConcludeCatchEmMode
	ld de, $0001
	call PlaySong
	scf
	ret

Func_204b3: ; 0x204b3
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $7
	ld [wd54d], a
	; Automatically set Mew as caught, since you can't possibly catch it
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .notMew
	callba SetPokemonOwnedFlag
.notMew
	callba StopTimer
	callba Func_106a6
	ret

Func_204f1: ; 0x204f1
	ld a, [wd5b6]
	cp $18
	jr z, .asm_2055e
	sla a
	ld c, a
	ld b, $0
	ld hl, wd586
	add hl, bc
	ld d, $4
.asm_20503
	ld a, $1
	ld [hli], a
	inc hl
	ld a, l
	cp wd5b6 % $100
	jr z, .asm_2050f
	dec d
	jr nz, .asm_20503
.asm_2050f
	ld a, [wd5b6]
	add $4
	cp $18
	jr c, .asm_2051a
	ld a, $18
.asm_2051a
	ld [wd5b6], a
	cp $18
	jr nz, .asm_20525
	xor a
	ld [wIndicatorStates + 9], a
.asm_20525
	callba Func_10184
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld bc, $0010
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wStationaryText2
	ld de, Data_2a3d
	call Func_3372
	pop de
	pop bc
	ld hl, wStationaryText1
	ld de, FlippedText
	call Func_3357
.asm_2055e
	ld bc, $0001
	ld de, $0000
	call Func_3538
	scf
	ret

Func_20569: ; 0x20569
	ld bc, $0000
	ld de, $1000
	call Func_3538
	ret

Func_20573: ; 0x20573
	ld bc, $0005
	ld de, $0000
	ret

Func_2057a: ; 0x2057a
	ld bc, $0005
	ld de, $0000
	ret
