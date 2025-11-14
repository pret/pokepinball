HandleEvoModeCollision: ; 0x19a95
	ld a, [wCurrentStage]
	call CallInFollowingTable
HandleEvoModeCollisionPointerTable: ; 0x10a9b
	padded_dab HandleRedEvoModeCollision ; STAGE_RED_FIELD_TOP
	padded_dab HandleRedEvoModeCollision ; STAGE_RED_FIELD_BOTTOM
	padded_dab HandleRedEvoModeCollision
	padded_dab HandleRedEvoModeCollision
	padded_dab HandleBlueEvoModeCollision ; STAGE_BLUE_FIELD_TOP
	padded_dab HandleBlueEvoModeCollision ; STAGE_BLUE_FIELD_BOTTOM

StartEvolutionMode: ; 0x10ab3
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
StartEvolutionMode_CallTable: ; 0x10abc
	dw StartEvolutionMode_RedField ; STAGE_RED_FIELD_TOP
	dw StartEvolutionMode_RedField ; STAGE_RED_FIELD_BOTTOM
	dw StartEvolutionMode_UnusedField
	dw StartEvolutionMode_UnusedField
	dw StartEvolutionMode_BlueField ; STAGE_BLUE_FIELD_TOP
	dw StartEvolutionMode_BlueField ; STAGE_BLUE_FIELD_BOTTOM

ConcludeEvolutionMode: ; 0x10ac8
	xor a
	ld [wBottomTextEnabled], a
	call FillBottomMessageBufferWithBlackTile
	xor a
	ld [wInSpecialMode], a
	ld [wWildMonIsHittable], a
	ld [wNumberOfCatchModeTilesFlipped], a
	ld [wNumMonHits], a
	ld [wEvolutionObjectsDisabled], a
	ld [wNumEvolutionTrinkets], a
	call ClearWildMonCollisionMask
	callba StopTimer
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
ConcludeEvolutionMode_CallTable: ; 0x10af3
	dw ConcludeEvolutionMode_RedField ; STAGE_RED_FIELD_TOP
	dw ConcludeEvolutionMode_RedField ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_11060
	dw DoNothing_11060
	dw ConcludeEvolutionMode_BlueField ; STAGE_BLUE_FIELD_TOP
	dw ConcludeEvolutionMode_BlueField ; STAGE_BLUE_FIELD_TOP

LoadRedFieldTopGraphics: ; 0x10aff
	ld a, [wCurrentStage]
	res 0, a
	ld c, a
	ld b, $0
	srl c
	sla a
	sla a
	sla a
	sub c
	ld c, a
	ld hl, VideoData_10b2a
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push af
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	pop af
	call LoadVRAMData
	ret

VideoData_10b2a: ; 0x10b2a
	dab StageRedFieldTopGfx3
	dw $8900
	dw $E0
	dab StageRedFieldTopGfx3
	dw $8900
	dw $E0
	dab StageRedFieldTopGfx3
	dw $8900
	dw $E0

ShowStartEvolutionModeText: ; 0x10b3f
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText1
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, StartTrainingText
	jr z, .showText
	ld de, FindItemsText
.showText
	call LoadScrollingText
	ret

InitEvolutionSelectionMenu: ; 0x10b59
; Initializes the list menu, which the player uses to select which pokemon to evolve.
	xor a
	ld [wDrawBottomMessageBox], a
	ld hl, wBottomMessageText
	ld a, $81
	ld b, $30
.clearLoop
	ld [hli], a ; load spaces into bottom text. repeat 192 times
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .clearLoop
	ld hl, wPartyMons
	call LoadMonNamesIntoEvolutionSelectionList
	ld a, BANK(InGameMenuSymbolsGfx)
	ld hl, InGameMenuSymbolsGfx + $50
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
	ld a, $0
	ld hl, wBottomMessageText
	deCoord 0, 0, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

LoadMonNamesIntoEvolutionSelectionList: ; 0x10b8e
; Loads 6 pokemon names into the list that allows the player to select which pokemon to evolve.
; Input: hl = pointer to a list of pokemon ids. (an offset of wPartyMons)
	ld a, [wNumPartyMons]
	ld c, $0
	ld b, a
.loop
	ld a, [hli]
	call LoadMonNameIntoEvolutionSelectionList
	inc c
	ld a, c
	cp $6
	jr z, .done
	dec b
	jr nz, .loop
.done
	ret

LoadMonNameIntoEvolutionSelectionList: ; 0x10ba2
; Loads a single pokemon name into the list of pokemon to evolve.
; Input: c = index of the list
;        a = pokemon id
	push bc
	push hl
	swap c ;c* 32, does wird things if c starts >15
	sla c
	ld b, $0
	ld hl, wBottomMessageText
	add hl, bc ;goes down text as many times as new c
	ld d, h
	ld e, l
	ld c, a ;c now equals paerty mon, HL stored in de
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ;multiplies party mon by 16, then jumps to correct name in the table
	ld hl, PokemonNames ;names are 16 chars long
	add hl, bc
	ld a, $81
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	ld a, $81
	ld [de], a ; loaded 4 spaces into de
	inc de
	call LoadMonNameIntoBottomMessageBufferList
.loadBlankCharacterLoop
	ld a, e
	and $1f
	cp $14
	jr nc, .done
	ld a, $81
	ld [de], a
	inc de
	jr .loadBlankCharacterLoop

.done
	pop hl
	pop bc
	ret

SelectPokemonToEvolveMenu: ; 0x10bea
; Drivers the menu that allows the player to select a pokemon to evolve.
	xor a
	ld [wCurSelectedPartyMon], a
	ld [wCurSelectedPartyMonScrollOffset], a
	ld [wPartySelectionCursorCounter], a
.loop
	call MoveEvolutionSelectionCursor
	call ClearPersistentJoypadStates
	call UpdateEvolutionSelectionList
	rst AdvanceFrame
	ld a, [wNewlyPressedButtonsPersistent]
	bit BIT_A_BUTTON, a
	jr z, .loop
	lb de, $00, $01
	call PlaySoundEffect
	ret

MoveEvolutionSelectionCursor: ; 0x10c0c
	ld a, [wPressedButtonsPersistent]
	ld b, a
	ld a, [wNumPartyMons]
	ld c, a
	ld a, [wCurSelectedPartyMon]
	bit BIT_D_UP, b
	jr z, .didntPressUp
	and a
	ret z
	; move the cursor up
	dec a
	ld [wCurSelectedPartyMon], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

.didntPressUp
	bit BIT_D_DOWN, b
	ret z
	inc a
	cp c
	ret z
	; move the cursor down
	ld [wCurSelectedPartyMon], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

UpdateEvolutionSelectionList: ; 0x10c38
	ld a, [wCurSelectedPartyMon]
	ld hl, wCurSelectedPartyMonScrollOffset
	sub [hl]
	jr nc, .asm_10c45
	dec [hl]
	xor a
	jr .asm_10c4c

.asm_10c45
	cp $6
	jr c, .asm_10c4c
	inc [hl]
	ld a, $5
.asm_10c4c
	ld c, a
	push bc
	ld a, [hl]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	call LoadMonNamesIntoEvolutionSelectionList
	ldh a, [hJoypadState]
	and a
	ld a, [wPartySelectionCursorCounter]
	jr z, .asm_10c62
	xor a
.asm_10c62
	inc a
	ld [wPartySelectionCursorCounter], a
	bit 3, a
	pop bc
	jr nz, .asm_10c78
	swap c
	sla c
	ld b, $0
	ld hl, wBottomMessageText + $03
	add hl, bc
	ld a, $88
	ld [hl], a
.asm_10c78
	ld a, [wCurSelectedPartyMonScrollOffset]
	and a
	jr z, .asm_10c83
	ld a, $8a
	ld [wBottomMessageText + $11], a
.asm_10c83
	ld a, [wCurSelectedPartyMonScrollOffset]
	add $7
	jr z, .asm_10c96
	ld c, a
	ld a, [wNumPartyMons]
	cp c
	jr c, .asm_10c96
	ld a, $89
	ld [wBottomMessageText + $b1], a
.asm_10c96
	ld a, $0
	ld hl, wBottomMessageText
	deCoord 0, 0, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

PlaceEvolutionInParty: ; 0x10ca5
	ld a, [wCurSelectedPartyMon]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [wCurrentEvolutionMon]
	cp $ff
	ret z
	ld [hl], a
	ret

SelectPokemonToEvolve: ; 0x10cb7
	call FillBottomMessageBufferWithBlackTile
	call InitEvolutionSelectionMenu
	ld a, $60
	ldh [hWY], a
	dec a
	ldh [hLYC], a
	ld a, $fd
	ldh [hLCDCMask], a
	call SelectPokemonToEvolveMenu
	ld a, $86
	ldh [hWY], a
	ld a, $83
	ldh [hLYC], a
	ldh [hLastLYC], a
	ld a, $ff
	ldh [hLCDCMask], a
	ldh a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	ld a, BANK(StageRedFieldTopStatusBarSymbolsGfx_GameBoy)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoy + $80
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
	jr .asm_10cfc

.gameboyColor
	ld a, BANK(StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor + $80
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
.asm_10cfc
	call FillBottomMessageBufferWithBlackTile
	ld a, SPECIAL_MODE_EVOLUTION
	ld [wDrawBottomMessageBox], a
	ld [wInSpecialMode], a
	ld [wSpecialMode], a
	xor a
	ld [wSpecialModeState], a
	ld a, [wCurSelectedPartyMon]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [hl]
	ld [wCurrentCatchEmMon], a
	ret

InitEvolutionModeForMon: ; 0x10d1d
	ld hl, wBillboardTilesIlluminationStates
	ld b, $18
.asm_10d22
	ld a, $1
	ld [hli], a
	xor a
	ld [hli], a
	dec b
	jr nz, .asm_10d22
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, MonEvolutionObjectCounts
	add hl, bc
	ld a, [hl]
	add 2
	ld [wNumPossibleEvolutionObjects], a
	xor a
	ld hl, wActiveEvolutionTrinkets
	ld b, 18 + 1 ; This goes out of bounds by 1--it's supposed to be 18. Doesn't result in any bad behavior, though.
.clearEvoTrinketsLoop
	ld [hli], a
	dec b
	jr nz, .clearEvoTrinketsLoop
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, CatchEmTimerData
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	callba StartTimer
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c  ; multiply mon id by 6
	rl b
	add c
	ld c, a
	jr nc, .noCarry
	inc b
.noCarry
	sla c
	rl b
	ld hl, MonEvolutions
	add hl, bc
	push hl
	ld bc, $03ff
.countMonEvolutionsLoop
	ld a, [hli]
	and a
	jr z, .nextEvolution
	inc c
.nextEvolution
	inc hl
	dec b
	jr nz, .countMonEvolutionsLoop
	ld a, c
	cp $ff
	jr nz, .chooseEvolution
	xor a
.chooseEvolution
	call RandomRange
	sla a
	ld c, a
	pop hl
	add hl, bc  ; hl points to one of three entries in mon's evolution data
	ld a, [hli]  ; a = mon id of evolution
	dec a
	ld [wCurrentEvolutionMon], a
	ld a, [hl]  ; a = evolution type id
	ld [wCurrentEvolutionType], a
	xor a
	ld [wNumEvolutionTrinkets], a
	ld [wEvolutionTrinketCooldownFrames], a
	ld [wEvolutionTrinketCooldownFrames + 1], a
	; Randomly set three entries in wEvolutionObjectStates to $1.
	; Each mon has a specified range of which entries can be set to $1.
	; The idea is that rarer mons can have harder-to-hit objects.
	ld hl, wEvolutionObjectStates
	ld a, 1
	ld b, 3
.initLoop1
	ld [hli], a
	dec b
	jr nz, .initLoop1
	xor a
	ld b, 7
.initLoop2
	ld [hli], a
	dec b
	jr nz, .initLoop2
	ld de, wEvolutionObjectStates
	ld a, [wNumPossibleEvolutionObjects]
	ld c, a
	inc a
	ld b, a
.shuffleLoop
	push bc
	ld a, c
	call RandomRange
	ld c, a
	ld b, $0
	ld hl, wEvolutionObjectStates
	add hl, bc
	ld c, [hl]
	ld a, [de]
	ld [hl], a
	ld a, c
	ld [de], a
	pop bc
	inc de
	dec b
	jr nz, .shuffleLoop
	callba InitBallSaverForCatchEmMode
	call ShowStartEvolutionModeText
	call Func_3579
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_10e09
	ld a, BANK(StageRedFieldBottomBaseGameBoyColorGfx)
	ld hl, StageRedFieldBottomBaseGameBoyColorGfx + $300
	ld de, vTilesSH tile $2e
	ld bc, $0020
	call LoadOrCopyVRAMData
	ld a, $0
	ld hl, CatchBarTiles
	deCoord 6, 8, vBGMap
	ld bc, (CatchBarTilesEnd - CatchBarTiles)
	call LoadOrCopyVRAMData
.asm_10e09
	ret

ShowMonEvolvedText: ; 0x10e0a
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jp z, EvolutionSpecialBonus
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, PokemonNames + 1
	add hl, bc
	ld de, ItEvolvedIntoAnText  ; "It evolved into an"
	ld bc, Data_2b34
	ld a, [hl]
	; check if mon's name starts with a vowel, so it can print "an", instead of "a"
	cp 'A'
	jr z, .nameStartsWithVowel
	cp 'I'
	jr z, .nameStartsWithVowel
	cp 'U'
	jr z, .nameStartsWithVowel
	cp 'E'
	jr z, .nameStartsWithVowel
	cp 'O'
	jr z, .nameStartsWithVowel
	ld de, ItEvolvedIntoAText  ; "It evolved into a"
	ld bc, Data_2b1c
.nameStartsWithVowel
	push hl
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText1
	pop de
	call LoadScrollingText
	ld hl, wScrollingText2
	pop de
	call LoadScrollingText
	pop hl
	ld de, wBottomMessageText + $20
	ld b, $0
.loadMonNameLoop
	ld a, [hli]
	and a
	jr z, .continue
	ld [de], a
	inc de
	inc b
	jr .loadMonNameLoop
.continue
	ld a, $20
	ld [de], a
	inc de
	xor a
	ld [de], a
	ld a, [wScrollingText2ScrollStepsRemaining]
	add b
	ld [wScrollingText2ScrollStepsRemaining], a
	ld a, $14
	sub b
	srl a
	ld b, a
	ld a, [wScrollingText2StopOffset]
	add b
	ld [wScrollingText2StopOffset], a
	ret

EvolutionSpecialBonus: ; 0x10e8b
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $0100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText2
	ld de, Data_2b6b
	call Func_32cc
	pop de
	pop bc
	ld hl, wScrollingText1
	ld de, EvolutionSpecialBonusText
	call LoadScrollingText
	ret

StartEvolutionMode_RedField: ; 0x10ebb
	ld a, [wNumPartyMons]
	and a
	ret z
	call SelectPokemonToEvolve
	call InitEvolutionModeForMon
	ld a, [wNumPossibleEvolutionObjects]
	sub 2
	ld c, a
	sla c
	ld hl, InitialIndicatorStates_RedField
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wIndicatorStates
	ld b, $13
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	xor a
	ld [wLeftAlleyCount], a
	call CloseSlotCave_
	ld a, $2
	ld [wRedStageStructureBackup], a
	ld de, MUSIC_CATCH_EM_BLUE ; Either MUSIC_CATCH_EM_BLUE or MUSIC_CATCH_EM_RED. They have the same id in their respective audio Banks.
	call PlaySong
	call SetPokemonSeenFlag
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .bottom
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
	ld de, vTilesSH tile $10
	ld bc, $00e0
	call LoadOrCopyVRAMData
	ret

.bottom
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadOrCopyVRAMData
	callba ClearAllRedIndicators
	callba Func_10184
	ldh a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

InitialIndicatorStates_RedField: ; 0x10f3b
	dw InitialIndicatorStates0_RedField
	dw InitialIndicatorStates1_RedField
	dw InitialIndicatorStates2_RedField
	dw InitialIndicatorStates3_RedField
	dw InitialIndicatorStates4_RedField
	dw InitialIndicatorStates5_RedField
	dw InitialIndicatorStates6_RedField
	dw InitialIndicatorStates7_RedField

InitialIndicatorStates0_RedField:  ; 0x10f4b
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00

InitialIndicatorStates1_RedField:  ; 0x10f5e
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00

InitialIndicatorStates2_RedField:  ; 0x10f71
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates3_RedField:  ; 0x10f84
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates4_RedField:  ; 0x10f97
	db $00, $00, $00, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates5_RedField:  ; 0x10faa
	db $00, $00, $80, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates6_RedField:  ; 0x10fbd
	db $00, $00, $80, $80, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates7_RedField:  ; 0x10fd0
	db $00, $00, $80, $80, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

ConcludeEvolutionMode_RedField: ; 0x10fe3
	call ResetIndicatorStates
	call OpenSlotCave
	call SetLeftAndRightAlleyArrowIndicatorStates_RedField
	call Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	jp z, LoadRedFieldTopGraphics
	callba ClearAllRedIndicators
	callba LoadSlotCaveCoverGraphics_RedField
	callba LoadMapBillboardTileData
	ld a, BANK(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ldh a, [hGameBoyColorFlag]
	and a
	jr z, .asm_11036
	ld a, BANK(StageRedFieldBottomOBJPalette7)
	ld hl, StageRedFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_11036
	ld hl, BlankSaverSpaceTileDataRedField
	ld a, BANK(BlankSaverSpaceTileDataRedField)
	call QueueGraphicsToLoad
	ld a, [wPreviousNumPokeballs]
	callba LoadPokeballsGraphics_RedField
	ld hl, CaughtPokeballTileDataPointers
	ld a, BANK(CaughtPokeballTileDataPointers)
	call QueueGraphicsToLoad
	ret

StartEvolutionMode_UnusedField: ; 0x11054
	ld a, [wNumPartyMons]
	and a
	ret z
	call SelectPokemonToEvolve
	call InitEvolutionModeForMon
	ret

DoNothing_11060: ; 0x11060
	ret

StartEvolutionMode_BlueField: ; 0x11061
	ld a, [wNumPartyMons]
	and a
	ret z
	call SelectPokemonToEvolve
	call InitEvolutionModeForMon
	ld a, $1
	ld [wd643], a
	ld a, [wNumPossibleEvolutionObjects]
	sub 2
	ld c, a
	sla c
	ld hl, InitialIndicatorStates_BlueField
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wIndicatorStates
	ld b, $13
.asm_11085
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_11085
	xor a
	ld [wLeftAlleyCount], a
	callba CloseSlotCave
	ld a, $2
	ld [wRedStageStructureBackup], a
	ld de, MUSIC_CATCH_EM_BLUE ; Either MUSIC_CATCH_EM_BLUE or MUSIC_CATCH_EM_RED. They have the same id in their respective audio Banks.
	call PlaySong
	call SetPokemonSeenFlag
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .bottom
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
	ld de, vTilesOB tile $60
	ld bc, $00e0
	call LoadOrCopyVRAMData
	ret

.bottom
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadOrCopyVRAMData
	callba Func_1c2cb
	callba Func_10184
	ldh a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

InitialIndicatorStates_BlueField: ; 0x110ed
	dw InitialIndicatorStates0_BlueField
	dw InitialIndicatorStates1_BlueField
	dw InitialIndicatorStates2_BlueField
	dw InitialIndicatorStates3_BlueField
	dw InitialIndicatorStates4_BlueField
	dw InitialIndicatorStates5_BlueField
	dw InitialIndicatorStates6_BlueField
	dw InitialIndicatorStates7_BlueField

InitialIndicatorStates0_BlueField: ; 0x110fd
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00

InitialIndicatorStates1_BlueField: ; 0x11110
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00

InitialIndicatorStates2_BlueField: ; 0x11123
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates3_BlueField: ; 0x11136
	db $00, $00, $80, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates4_BlueField: ; 0x11149
	db $00, $00, $80, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates5_BlueField: ; 0x1115c
	db $00, $00, $80, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates6_BlueField: ; 0x1116f
	db $80, $00, $80, $80, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

InitialIndicatorStates7_BlueField: ; 0x11182
	db $80, $00, $80, $80, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

ConcludeEvolutionMode_BlueField: ; 0x11195
	xor a
	ld [wd643], a
	call ResetIndicatorStates
	call OpenSlotCave
	callba SetLeftAndRightAlleyArrowIndicatorStates_BlueField
	ld a, [wCurrentStage]
	bit 0, a
	jp z, LoadBlueFieldTopGraphics
	callba Func_1c2cb
	callba LoadSlotCaveCoverGraphics_BlueField
	callba LoadMapBillboardTileData
	ld a, Bank(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ldh a, [hGameBoyColorFlag]
	and a
	jr z, .asm_111f0
	ld a, BANK(StageBlueFieldBottomOBJPalette7)
	ld hl, StageBlueFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_111f0
	ld hl, BlankSaverSpaceTileDataBlueField
	ld a, BANK(BlankSaverSpaceTileDataBlueField)
	call QueueGraphicsToLoad
	ld a, [wPreviousNumPokeballs]
	callba LoadPokeballsGraphics_RedField
	ld hl, Data_10a88
	ld a, BANK(Data_10a88)
	call QueueGraphicsToLoad
	ret

LoadBlueFieldTopGraphics: ; 0x1120e
	ld a, [wCurrentStage]
	sub $4
	res 0, a
	ld c, a
	ld b, $0
	srl c
	sla a
	sla a
	sla a
	sub c
	ld c, a
	ld hl, VRAMData_1123b
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push af
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	pop af
	call LoadVRAMData
	ret

VRAMData_1123b: ; 0x1123b
; This doesn't seem very useful...
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
