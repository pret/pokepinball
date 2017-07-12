HandleBlueEvoModeCollision: ; 0x20bae
	ld a, [wSpecialModeCollisionID]
	cp $4
	jp z, Func_20e34
	cp $1
	jp z, Func_21089
	cp $e
	jp z, Func_20e5e
	cp $f
	jp z, Func_20e82
	cp $7
	jp z, Func_20ea6
	cp $8
	jp z, Func_20ec7
	cp $9
	jp z, Func_20ee8
	cp $a
	jp z, Func_20f09
	cp $b
	jp z, Func_20f2a
	cp $c
	jp z, Func_20f4b
	cp $d
	jp z, Func_2112a
	cp $2
	jp z, Func_2105c
	cp $0
	jr z, .asm_20bf3
	scf
	ret

.asm_20bf3
	call Func_20da0
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_20bfc: ; 0x20bfc
	padded_dab Func_20c08
	padded_dab Func_20d30
	padded_dab Func_20d7c

Func_20c08: ; 0x20c08
	ld a, [wCurrentStage]
	ld b, a
	ld a, [wd578]
	and a
	ret z
	dec a
	bit 0, b
	jr z, .asm_20c18
	add $c
.asm_20c18
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ld a, [hl]
	and a
	ret z
	xor a
	ld [hl], a
	ld [wd551], a
	call Func_20c76
	ld a, [wd558]
	ld [wIndicatorStates], a
	ld a, [wd559]
	ld [wIndicatorStates + 3], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld de, YeahYouGotItText
	ld hl, wScrollingText1
	call LoadScrollingText
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20c74
	ld a, BANK(StageBlueFieldBottomOBJPalette6)
	ld hl, StageBlueFieldBottomOBJPalette6
	ld de, $0070
	ld bc, $0008
	call Func_7dc
.asm_20c74
	scf
	ret

Func_20c76: ; 0x20c76
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20ca6
	ld a, [wCurrentEvolutionType]
	dec a
	ld c, a
	ld b, $0
	swap c
	sla c
	ld hl, EvolutionProgressIconsGfx
	add hl, bc
	ld a, [wd554]
	ld c, a
	ld b, $0
	swap c
	sla c
	push hl
	ld hl, vTilesSH tile $2e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, $0020
	ld a, BANK(EvolutionProgressIconsGfx)
	call LoadVRAMData
.asm_20ca6
	ld a, [wd554]
	inc a
	ld [wd554], a
	cp $1
	jr nz, .asm_20cb8
	lb de, $07, $28
	call PlaySoundEffect
	ret

.asm_20cb8
	cp $2
	jr nz, .asm_20cc3
	lb de, $07, $44
	call PlaySoundEffect
	ret

.asm_20cc3
	cp $3
	ret nz
	lb de, $07, $45
	call PlaySoundEffect
	ld a, $1
	ld [wSlotIsOpen], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	xor a
	ld [wIndicatorStates + 9], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 13], a
	ld [wIndicatorStates + 14], a
	ld [wIndicatorStates + 11], a
	ld [wIndicatorStates + 12], a
	ld [wIndicatorStates + 10], a
	ld [wIndicatorStates + 6], a
	ld [wIndicatorStates + 7], a
	ld [wd558], a
	ld [wd559], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, BANK(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20d25
	ld a, BANK(StageBlueFieldBottomOBJPalette7)
	ld hl, StageBlueFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_20d25
	callba LoadSlotCaveCoverGraphics_BlueField
	ret

Func_20d30: ; 0x20d30
	callba RestoreBallSaverAfterCatchEmMode
	callba PlaceEvolutionInParty
	callba ConcludeEvolutionMode
	ld de, $0001
	call PlaySong
	ld hl, wNumPokemonEvolvedInBallBonus
	call Increment_Max100
	callba SetPokemonOwnedFlag
	ld a, [wPreviousNumPokeballs]
	cp $3
	ret z
	add $2
	cp $3
	jr c, .DontClampBalls
	ld a, $3
.DontClampBalls
	ld [wNumPokeballs], a
	ld a, $80
	ld [wPokeballBlinkingCounter], a
	scf
	ret

Func_20d7c: ; 0x20d7c
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba ConcludeEvolutionMode
	ld de, $0001
	call PlaySong
	scf
	ret

Func_20da0: ; 0x20da0
	ld hl, wd556
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	jr z, .asm_20db3
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	jr nz, .asm_20db3
	call Func_21079
.asm_20db3
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $2
	ld [wd54d], a
	xor a
	ld [wSlotIsOpen], a
	ld hl, wIndicatorStates
	ld [wIndicatorStates + 4], a
	ld [wIndicatorStates + 9], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 13], a
	ld [wIndicatorStates + 14], a
	ld [wIndicatorStates + 11], a
	ld [wIndicatorStates + 12], a
	ld [wIndicatorStates + 10], a
	ld [wIndicatorStates + 6], a
	ld [wIndicatorStates + 7], a
	ld [wd558], a
	ld [wd559], a
	ld [wd551], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20e1a
	callba Func_1c2cb
	callba LoadSlotCaveCoverGraphics_BlueField
.asm_20e1a
	callba StopTimer
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld de, EvolutionFailedText
	call LoadScrollingText
	ret

Func_20e34: ; 0x20e34
	ld bc, $0001
	ld de, $5000
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20e5c
	ld a, [wIndicatorStates + 9]
	and a
	jr z, .asm_20e5c
	xor a
	ld [wIndicatorStates + 9], a
	ld a, [wd55c]
	and a
	ld a, $0
	ld [wd55c], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20e5c
	scf
	ret

Func_20e5e: ; 0x20e5e
	ld a, [wd551]
	and a
	jr nz, .asm_20e80
	ld a, [wIndicatorStates + 3]
	and a
	jr z, .asm_20e80
	xor a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wd562]
	and a
	ld a, $0
	ld [wd562], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20e80
	scf
	ret

Func_20e82: ; 0x20e82
	ld a, [wd551]
	and a
	jr nz, .asm_20ea4
	ld a, [wIndicatorStates + 8]
	and a
	jr z, .asm_20ea4
	xor a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 2], a
	ld a, [wd561]
	and a
	ld a, $0
	ld [wd561], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20ea4
	scf
	ret

Func_20ea6: ; 0x20ea6
	ld a, [wd551]
	and a
	jr nz, .asm_20ec5
	ld a, [wIndicatorStates + 13]
	and a
	jr z, .asm_20ec5
	xor a
	ld [wIndicatorStates + 13], a
	ld a, [wd55d]
	and a
	ld a, $0
	ld [wd55d], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20ec5
	scf
	ret

Func_20ec7: ; 0x20ec7
	ld a, [wd551]
	and a
	jr nz, .asm_20ee6
	ld a, [wIndicatorStates + 14]
	and a
	jr z, .asm_20ee6
	xor a
	ld [wIndicatorStates + 14], a
	ld a, [wd55e]
	and a
	ld a, $0
	ld [wd55e], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20ee6
	scf
	ret

Func_20ee8: ; 0x20ee8
	ld a, [wd551]
	and a
	jr nz, .asm_20f07
	ld a, [wIndicatorStates + 11]
	and a
	jr z, .asm_20f07
	xor a
	ld [wIndicatorStates + 11], a
	ld a, [wd55f]
	and a
	ld a, $0
	ld [wd55f], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f07
	scf
	ret

Func_20f09: ; 0x20f09
	ld a, [wd551]
	and a
	jr nz, .asm_20f28
	ld a, [wIndicatorStates + 12]
	and a
	jr z, .asm_20f28
	xor a
	ld [wIndicatorStates + 12], a
	ld a, [wd560]
	and a
	ld a, $0
	ld [wd560], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f28
	scf
	ret

Func_20f2a: ; 0x20f2a
	ld a, [wd551]
	and a
	jr nz, .asm_20f49
	ld a, [wIndicatorStates + 6]
	and a
	jr z, .asm_20f49
	xor a
	ld [wIndicatorStates + 6], a
	ld a, [wd565]
	and a
	ld a, $0
	ld [wd565], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f49
	scf
	ret

Func_20f4b: ; 0x20f4b
	ld bc, $0000
	ld de, $1500
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20f73
	ld a, [wIndicatorStates + 7]
	and a
	jr z, .asm_20f73
	xor a
	ld [wIndicatorStates + 7], a
	ld a, [wd564]
	and a
	ld a, $0
	ld [wd564], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f73
	scf
	ret

Func_20f75: ; 0x20f75
	lb de, $07, $46
	call PlaySoundEffect
	call Func_2111d
	ld a, [wCurrentEvolutionType]
	ld [hl], a
	ld [wd551], a
	ld a, [wIndicatorStates]
	ld [wd558], a
	ld a, [wIndicatorStates + 3]
	ld [wd559], a
	ld a, [wIndicatorStates + 2]
	ld [wIndicatorState2Backup], a
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20fc3
	ld a, BANK(PaletteData_dd188)
	ld hl, PaletteData_dd188
	ld de, $0070
	ld bc, $0010
	call Func_7dc
.asm_20fc3
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentEvolutionType]
	dec a
	ld c, a
	ld b, $0
	sla c
	ld hl, EvolutionTypeGetTextPointers
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, wScrollingText1
	call LoadScrollingText
	scf
	ret

Func_20fef: ; 0x20fef
	lb de, $07, $47
	call PlaySoundEffect
	ld a, $1
	ld [wd551], a
	ld a, [wIndicatorStates]
	ld [wd558], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld a, [wIndicatorStates + 3]
	ld [wd559], a
	ld a, [wIndicatorStates + 2]
	ld [wIndicatorState2Backup], a
	xor a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld a, $58
	ld [wd556], a
	ld a, $2
	ld [wd557], a
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, PokemonIsTiredText
	jr z, .asm_21057
	ld de, ItemNotFoundText
.asm_21057
	call LoadScrollingText
	scf
	ret

Func_2105c: ; 0x2105c
	ld a, [wd551]
	and a
	jr z, .asm_21077
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_21077
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr asm_210c7

.asm_21077
	scf
	ret

Func_21079: ; 0x21079
	ld a, [wd551]
	and a
	jr z, .asm_21087
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_21087
	jr asm_210c7

.asm_21087
	scf
	ret

Func_21089: ; 0x21089
	ld a, [wd551]
	and a
	jr nz, .asm_210aa
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_210a8
	xor a
	ld [wIndicatorStates], a
	ld a, [wd563]
	and a
	ld a, $0
	ld [wd563], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_210a8
	scf
	ret

.asm_210aa
	ld a, [wd551]
	and a
	jr z, .asm_210c5
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_210c5
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr asm_210c7

.asm_210c5
	scf
	ret

asm_210c7:
	xor a
	ld [wIndicatorStates + 1], a
	ld [wd551], a
	ld a, [wd558]
	ld [wIndicatorStates], a
	ld a, [wd559]
	ld [wIndicatorStates + 3], a
	ld a, [wIndicatorState2Backup]
	ld [wIndicatorStates + 2], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_21102
	ld a, BANK(StageBlueFieldBottomOBJPalette6)
	ld hl, StageBlueFieldBottomOBJPalette6
	ld de, $0070
	ld bc, $0008
	call Func_7dc
.asm_21102
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, PokemonRecoveredText
	jr z, .asm_21115
	ld de, TryNextPlaceText
.asm_21115
	ld hl, wScrollingText1
	call LoadScrollingText
	scf
	ret

Func_2111d: ; 0x2111d
	ld a, $11
	call RandomRange
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ret

Func_2112a: ; 0x2112a
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jr nz, .asm_21134
	ld a, [wCurrentCatchEmMon]
.asm_21134
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_21140
	inc b
.asm_21140
	push bc
	ld hl, MonBillboardPicPointers
	add hl, bc
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	inc hl
	ld c, a
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	inc hl
	ld b, a
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	ld h, b
	ld l, c
	ld de, vTilesSH tile $10
	ld bc, $0180
	call LoadOrCopyVRAMData
	pop bc
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_211a8
	push bc
	ld hl, MonBillboardPaletteMapPointers
	add hl, bc
	ld a, Bank(MonBillboardPaletteMapPointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, Bank(MonBillboardPaletteMapPointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, Bank(MonBillboardPaletteMapPointers)
	call ReadByteFromBank
	hlCoord 7, 4, vBGMap
	call LoadBillboardPaletteMap
	pop bc
	ld hl, MonBillboardPalettePointers
	add hl, bc
	ld a, Bank(MonBillboardPalettePointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, Bank(MonBillboardPalettePointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, Bank(MonBillboardPalettePointers)
	call ReadByteFromBank
	ld bc, $10b0
	ld hl, rBGPI
	call Func_8e1
.asm_211a8
	callba Func_10e0a
	call Func_3475
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $2d, $26
	call PlaySoundEffect
	callba Func_10825
	call Func_3475
	ld a, $1
	ld [wd54d], a
	scf
	ret
