HandleBlueCatchEmCollision: ; 0x202bc
	ld a, [wSpecialModeCollisionID]
	cp SPECIAL_COLLISION_SHELLDER
	jp z, HandleShellderCollision_CatchemMode
	cp SPECIAL_COLLISION_SPINNER
	jp z, HandleSpinnerCollision_CatchemMode_BlueField
	cp SPECIAL_COLLISION_SLOWPOKE
	jp z, HandleSlowpokeCollision_CatchemMode
	cp SPECIAL_COLLISION_CLOYSTER
	jp z, HandleCloysterCollision_CatchemMode
	cp SPECIAL_COLLISION_NOTHING
	jr z, .noCollision
	scf
	ret

.noCollision
	call CheckIfCatchemModeTimerExpired_BlueField
	ld a, [wSpecialModeState]
	call CallInFollowingTable
CatchemModeCallTable_BlueField: ; 0x202e2
	padded_dab Func_20302
	padded_dab Func_20320
	padded_dab Func_2032c
	padded_dab ShowAnimatedCatchemPokemon_BlueField
	padded_dab UpdateMonState_CatchemMode_BlueField
	padded_dab CatchPokemon_BlueField
	padded_dab CapturePokemonAnimation_BlueField
	padded_dab ConcludeCatchemMode_BlueField

Func_20302: ; 0x20302
	ld a, [wNumberOfCatchModeTilesFlipped]
	cp $18
	jr nz, .asm_2031e
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_2031e
	ld hl, wSpecialModeState
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
	ld hl, wSpecialModeState
	inc [hl]
.asm_20362
	scf
	ret

ShowAnimatedCatchemPokemon_BlueField: ; 0x20364
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20370
	call Func_1130
	jr nz, .asm_20392
.asm_20370
	callba ShowAnimatedWildMon
	callba PlayCatchemPokemonCry
	callba LoadWildMonCollisionMask
	ld hl, wSpecialModeState
	inc [hl]
.asm_20392
	scf
	ret

UpdateMonState_CatchemMode_BlueField: ; 0x20394
	ld a, [wLoopsUntilNextCatchSpriteAnimationChange]
	dec a
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	jr z, .asm_203a7
	ld a, [wCatchModeMonUpdateTimer]
	inc a
	ld [wCatchModeMonUpdateTimer], a
	and $3
	ret nz
.asm_203a7
	ld a, [wBallHitWildMon]
	and a
	jp z, .asm_20428
	xor a
	ld [wBallHitWildMon], a
	ld a, [wCurrentCatchMonHitFrameDuration]
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	xor a
	ld [wCatchModeMonUpdateTimer], a
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
	call EnableBottomText
	ld hl, wStationaryText2
	ld de, Data_2a2a
	call LoadScoreTextFromStack
	pop de
	pop bc
	ld hl, wStationaryText1
	ld de, HitText
	call LoadStationaryTextAndHeader
	ld a, [wNumMonHits]
	callba Func_10611
	ld c, $2
	jr .asm_2044b

.asm_20417
	xor a
	ld [wTimeRanOut], a
	ld a, $1
	ld [wPauseTimer], a
	ld hl, wSpecialModeState
	inc [hl]
	ld c, $2
	jr .asm_2044b

.asm_20428
	ld a, [wLoopsUntilNextCatchSpriteAnimationChange]
	and a
	ret nz
	ld a, [wCurrentAnimatedMonSpriteType]
	ld c, a
	ld a, [wCurrentAnimatedMonSpriteFrame]
	sub c
	cp $1
	ld c, $0
	jr nc, .asm_2043d
	ld c, $1
.asm_2043d
	ld b, $0
	ld hl, wCurrentCatchMonIdleFrame1Duration
	add hl, bc
	ld a, [hl]
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	xor a
	ld [wCatchModeMonUpdateTimer], a
.asm_2044b
	ld a, [wCurrentAnimatedMonSpriteType]
	add c
	ld [wCurrentAnimatedMonSpriteFrame], a
	scf
	ret

CatchPokemon_BlueField: ; 0x20454
	ld a, [wd580]
	and a
	jr z, .asm_2045f
	xor a
	ld [wd580], a
	ret

.asm_2045f
	callba BallCaptureInit
	ld hl, wSpecialModeState
	inc [hl]
	callba ShowCapturedPokemonText
	callba AddCaughtPokemonToParty
	scf
	ret

CapturePokemonAnimation_BlueField: ; 0x20483
	callba CapturePokemonAnimation
	scf
	ret

ConcludeCatchemMode_BlueField: ; 0x2048f
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba ConcludeCatchEmMode
	ld de, MUSIC_BLUE_FIELD
	call PlaySong
	scf
	ret

CheckIfCatchemModeTimerExpired_BlueField: ; 0x204b3
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $7
	ld [wSpecialModeState], a
	; Automatically set Mew as caught, since you can't possibly catch it
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .notMew
	callba SetPokemonOwnedFlag
.notMew
	callba StopTimer
	callba Func_106a6
	ret

HandleShellderCollision_CatchemMode: ; 0x204f1
	ld a, [wNumberOfCatchModeTilesFlipped]
	cp 24
	jr z, .allTilesFlipped
	sla a
	ld c, a
	ld b, $0
	ld hl, wBillboardTilesIlluminationStates
	add hl, bc
	ld d, $4
.asm_20503
	ld a, $1
	ld [hli], a
	inc hl
	ld a, l
	cp wNumberOfCatchModeTilesFlipped % $100
	jr z, .asm_2050f
	dec d
	jr nz, .asm_20503
.asm_2050f
	ld a, [wNumberOfCatchModeTilesFlipped]
	add $4
	cp $18
	jr c, .asm_2051a
	ld a, $18
.asm_2051a
	ld [wNumberOfCatchModeTilesFlipped], a
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
	call EnableBottomText
	ld hl, wStationaryText2
	ld de, CatchModeTileFlippedScoreStationaryTextHeader
	call LoadScoreTextFromStack
	pop de
	pop bc
	ld hl, wStationaryText1
	ld de, FlippedText
	call LoadStationaryTextAndHeader
.allTilesFlipped
	ld bc, $0001
	ld de, $0000
	call AddBCDEToJackpot
	scf
	ret

HandleSpinnerCollision_CatchemMode_BlueField: ; 0x20569
	ld bc, $0000
	ld de, $1000
	call AddBCDEToJackpot
	ret

HandleSlowpokeCollision_CatchemMode: ; 0x20573
	ld bc, $0005
	ld de, $0000
	ret

HandleCloysterCollision_CatchemMode: ; 0x2057a
	ld bc, $0005
	ld de, $0000
	ret
