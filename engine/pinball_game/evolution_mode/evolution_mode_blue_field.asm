HandleBlueEvoModeCollision: ; 0x20bae
	ld a, [wSpecialModeCollisionID]
	cp SPECIAL_COLLISION_SHELLDER
	jp z, HandleShellderCollision_EvolutionMode
	cp SPECIAL_COLLISION_LEFT_TRIGGER
	jp z, HandleLeftTriggerCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_CLOYSTER
	jp z, HandleCloysterCollision_EvolutionMode
	cp SPECIAL_COLLISION_SLOWPOKE
	jp z, HandleSlowpokeCollision_EvolutionMode
	cp SPECIAL_COLLISION_POLIWAG
	jp z, HandlePoliwagCollision_EvolutionMode
	cp SPECIAL_COLLISION_PSYDUCK
	jp z, HandlePsyduckCollision_EvolutionMode
	cp SPECIAL_COLLISION_LEFT_BONUS_MULTIPLIER
	jp z, HandleLeftBonusMultiplierCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_RIGHT_BONUS_MULTIPLIER
	jp z, HandleRightBonusMultiplierCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_BALL_UPGRADE
	jp z, HandleBallUpgradeCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_SPINNER
	jp z, HandleSpinnerCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_SLOT_HOLE
	jp z, HandleSlotCaveCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_RIGHT_TRIGGER
	jp z, HandleRightTriggerCollision_EvolutionMode_BlueField
	cp SPECIAL_COLLISION_NOTHING
	jr z, .noCollision
	scf
	ret
.noCollision
	call CheckIfEvolutionModeTimerExpired_BlueField
	ld a, [wSpecialModeState]
	call CallInFollowingTable
EvolutionModeCallTable_BlueField: ; 0x20bfc
	padded_dab HandleEvolutionMode_BlueField
	padded_dab CompleteEvolutionMode_BlueField
	padded_dab FailEvolutionMode_BlueField

HandleEvolutionMode_BlueField: ; 0x20c08
; Handles the logic for what happens when an evolution trinket is collected.
	ld a, [wCurrentStage]
	ld b, a
	ld a, [wCollidedPointIndex]
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
	ld [wEvolutionObjectsDisabled], a
	call ProgressEvolution
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
	call EnableBottomText
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

ProgressEvolution: ; 0x20c76
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .top
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
.top
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

CompleteEvolutionMode_BlueField: ; 0x20d30
	callba RestoreBallSaverAfterCatchEmMode
	callba PlaceEvolutionInParty
	callba ConcludeEvolutionMode
	ld de, MUSIC_BLUE_FIELD
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

FailEvolutionMode_BlueField: ; 0x20d7c
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba ConcludeEvolutionMode
	ld de, MUSIC_BLUE_FIELD
	call PlaySong
	scf
	ret

CheckIfEvolutionModeTimerExpired_BlueField: ; 0x20da0
	ld hl, wEvolutionTrinketCooldownFrames
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	jr z, .cooldownNotEnding
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	jr nz, .cooldownNotEnding
	call EndEvolutionTrinketCooldown_BlueField
.cooldownNotEnding
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $2
	ld [wSpecialModeState], a
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
	ld [wEvolutionObjectsDisabled], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20e1a
	callba Func_1c2cb
	callba LoadSlotCaveCoverGraphics_BlueField
.asm_20e1a
	callba StopTimer
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText1
	ld de, EvolutionFailedText
	call LoadScrollingText
	ret

HandleShellderCollision_EvolutionMode: ; 0x20e34
	ld bc, $0001
	ld de, $5000
	call AddBCDEToJackpot
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 9]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 9], a
	ld a, [wd55c]
	and a
	ld a, $0
	ld [wd55c], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandleCloysterCollision_EvolutionMode: ; 0x20e5e
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 3]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wd562]
	and a
	ld a, $0
	ld [wd562], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandleSlowpokeCollision_EvolutionMode: ; 0x20e82
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 8]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 2], a
	ld a, [wd561]
	and a
	ld a, $0
	ld [wd561], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandlePoliwagCollision_EvolutionMode: ; 0x20ea6
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 13]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 13], a
	ld a, [wd55d]
	and a
	ld a, $0
	ld [wd55d], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandlePsyduckCollision_EvolutionMode: ; 0x20ec7
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 14]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 14], a
	ld a, [wd55e]
	and a
	ld a, $0
	ld [wd55e], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandleLeftBonusMultiplierCollision_EvolutionMode_BlueField: ; 0x20ee8
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 11]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 11], a
	ld a, [wd55f]
	and a
	ld a, $0
	ld [wd55f], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandleRightBonusMultiplierCollision_EvolutionMode_BlueField: ; 0x20f09
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 12]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 12], a
	ld a, [wd560]
	and a
	ld a, $0
	ld [wd560], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandleBallUpgradeCollision_EvolutionMode_BlueField: ; 0x20f2a
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 6]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 6], a
	ld a, [wd565]
	and a
	ld a, $0
	ld [wd565], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

HandleSpinnerCollision_EvolutionMode_BlueField: ; 0x20f4b
	ld bc, $0000
	ld de, $1500
	call AddBCDEToJackpot
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates + 7]
	and a
	jr z, .disabled
	xor a
	ld [wIndicatorStates + 7], a
	ld a, [wd564]
	and a
	ld a, $0
	ld [wd564], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.disabled
	scf
	ret

CreateEvolutionTrinket_BlueField: ; 0x20f75
; Makes an evolution trinket appear somewhere randomly on the pinball table.
	lb de, $07, $46
	call PlaySoundEffect
	call ChooseNextEvolutionTrinketLocation_BlueField
	ld a, [wCurrentEvolutionType]
	ld [hl], a
	ld [wEvolutionObjectsDisabled], a
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
	ld a, BANK(EvolutionTrinketPalettes)
	ld hl, EvolutionTrinketPalettes
	ld de, $0070
	ld bc, $0010
	call Func_7dc
.asm_20fc3
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
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

EvolutionTrinketNotFound_BlueField: ; 0x20fef
; Shows that an evolution trinket isn't available from hitting whichever object that generated this event.
; Disables the ability to find more evolution trinkets for several seconds.
	lb de, $07, $47
	call PlaySoundEffect
	ld a, $1
	ld [wEvolutionObjectsDisabled], a
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
	ld [wEvolutionTrinketCooldownFrames], a
	ld a, $2
	ld [wEvolutionTrinketCooldownFrames + 1], a
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
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

HandleRightTriggerCollision_EvolutionMode_BlueField: ; 0x2105c
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr z, .evolutionObjectsEnabled
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .evolutionObjectsEnabled
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr RecoverPokemon_BlueField

.evolutionObjectsEnabled
	scf
	ret

EndEvolutionTrinketCooldown_BlueField: ; 0x21079
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr z, .evolutionObjectsEnabled
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .evolutionObjectsEnabled
	jr RecoverPokemon_BlueField

.evolutionObjectsEnabled
	scf
	ret

HandleLeftTriggerCollision_EvolutionMode_BlueField: ; 0x21089
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr nz, .disabled
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_210a8
	xor a
	ld [wIndicatorStates], a
	ld a, [wd563]
	and a
	ld a, $0
	ld [wd563], a
	jp nz, CreateEvolutionTrinket_BlueField
	jp EvolutionTrinketNotFound_BlueField

.asm_210a8
	scf
	ret

.disabled
	ld a, [wEvolutionObjectsDisabled]
	and a
	jr z, .evolutionObjectsEnabled
	ld a, [wIndicatorStates]
	and a
	jr z, .evolutionObjectsEnabled
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr RecoverPokemon_BlueField

.evolutionObjectsEnabled
	scf
	ret

RecoverPokemon_BlueField:
	xor a
	ld [wIndicatorStates + 1], a
	ld [wEvolutionObjectsDisabled], a
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
	call EnableBottomText
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

ChooseNextEvolutionTrinketLocation_BlueField: ; 0x2111d
	ld a, $11
	call RandomRange
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ret

HandleSlotCaveCollision_EvolutionMode_BlueField: ; 0x2112a
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
	callba ShowMonEvolvedText
	call MainLoopUntilTextIsClear
	ld de, MUSIC_NOTHING
	call PlaySong
	rst AdvanceFrame
	lb de, $2d, $26
	call PlaySoundEffect
	callba ShowJackpotText
	call MainLoopUntilTextIsClear
	ld a, $1
	ld [wSpecialModeState], a
	scf
	ret
