HandleMapModeCollision: ; 0x301ce
	ld a, [wCurrentStage]
	call CallInFollowingTable
HandleMapModeCollisionPointerTable: ; 0x301d4
	padded_dab HandleRedMapModeCollision ; STAGE_RED_FIELD_TOP
	padded_dab HandleRedMapModeCollision ; STAGE_RED_FIELD_BOTTOM
	padded_dab HandleRedMapModeCollision
	padded_dab HandleRedMapModeCollision
	padded_dab HandleBlueMapModeCollision ; STAGE_BLUE_FIELD_TOP
	padded_dab HandleBlueMapModeCollision ; STAGE_BLUE_FIELD_BOTTOM

StartMapMoveMode: ; 0x301ec
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, $1
	ld [wInSpecialMode], a
	ld a, SPECIAL_MODE_MAP_MOVE
	ld [wSpecialMode], a
	xor a
	ld [wd54d], a
	ld bc, $0030  ; 30 seconds
	callba StartTimer
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_3021b
	ld a, [wMapMoveDirection]
	add $12
	call LoadBillboardTileData
.asm_3021b
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_3021f: ; 0x3021f
	dw Func_311b4 ; STAGE_RED_FIELD_TOP
	dw Func_311b4 ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_31324
	dw DoNothing_31324
	dw Func_31326 ; STAGE_BLUE_FIELD_TOP
	dw Func_31326 ; STAGE_BLUE_FIELD_BOTTOM

Func_3022b: ; 0x3022b
	xor a
	ld [wBottomTextEnabled], a ;turn text off
	call FillBottomMessageBufferWithBlackTile ;clear text
	xor a
	ld [wInSpecialMode], a
	ld [wSpecialMode], a ;no longer in special modes
	callba StopTimer
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_30247: ; 0x30247
	dw Func_31234 ; STAGE_RED_FIELD_TOP
	dw Func_31234 ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_31325
	dw DoNothing_31325
	dw Func_313c3 ; STAGE_BLUE_FIELD_TOP
	dw Func_313c3 ; STAGE_BLUE_FIELD_TOP

INCLUDE "engine/pinball_game/billboard_tiledata.asm"

LoadScrollingMapNameText: ; 0x3118f
; Loads the scrolling message that displays the current map's name.
; Input: bc = pointer to prefix scrolling text
	push bc
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentMap]
	sla a
	ld c, a
	ld b, $0
	ld hl, MapNames
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, wScrollingText2
	call LoadScrollingText
	pop de
	ld hl, wScrollingText1
	call LoadScrollingText
	ret

Func_311b4: ; 0x311b4
	ld a, [wMapMoveDirection]
	and a
	jr nz, .asm_311ce
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	jr .asm_311e2

.asm_311ce
	ld a, $80
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 4], a
	jr .asm_311e2

.asm_311e2
	ld a, $2
	callba LoadDiglettGraphics
	ld a, $5
	callba LoadDiglettGraphics
	ld a, $6a
	ld [wStageCollisionMap + $f0], a
	ld a, $6b
	ld [wStageCollisionMap + $110], a
	ld a, $66
	ld [wStageCollisionMap + $e3], a
	ld a, $67
	ld [wStageCollisionMap + $103], a
	callba Func_107b0
	ld a, $4
	ld [wd7ad], a
	ld de, $0003
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba ClearAllRedIndicators
	ret

Func_31234: ; 0x31234
	callba ResetIndicatorStates
	callba Func_107c2
	callba SetLeftAndRightAlleyArrowIndicatorStates_RedField
	callba Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba ClearAllRedIndicators
	callba LoadSlotCaveCoverGraphics_RedField
	callba LoadMapBillboardTileData
	ret

ChooseNextMap_RedField: ; 0x31282
; Picks the next map to perform a map move.
; Also records which maps have been visited.
	ld a, [wNumMapMoves]
	inc a
	cp $6
	jr c, .dontReset
	ld a, $ff
	ld [wVisitedMaps], a
	ld [wVisitedMaps + 1], a
	ld [wVisitedMaps + 2], a
	ld [wVisitedMaps + 3], a
	ld [wVisitedMaps + 4], a
	ld [wVisitedMaps + 5], a
	xor a
.dontReset
	ld [wNumMapMoves], a
	cp $3
	jr c, .chooseMapFromArea1
	cp $5
	jr c, .chooseMapFromArea2
	ld a, INDIGO_PLATEAU
	ld [wCurrentMap], a
	ld [wVisitedMaps + 5], a
	ret

.chooseMapFromArea1
	call GenRandom
	and $7
	cp $7
	jr nc, .chooseMapFromArea1
	ld c, a
	ld b, $0
	ld hl, FirstMapMoveSet_RedField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps
	ld a, [wNumMapMoves]
	and a
	jr z, .asm_312d4
	ld b, a
.asm_312cd
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea1
	dec b
	jr nz, .asm_312cd
.asm_312d4
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

.chooseMapFromArea2
	call GenRandom
	and $3
	ld c, a
	ld b, $0
	ld hl, SecondMapMoveSet_RedField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps + 3
	ld a, [wNumMapMoves]
	sub $3
	jr z, .asm_31306
	ld b, a
.asm_312ff
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea2
	dec b
	jr nz, .asm_312ff
.asm_31306
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

FirstMapMoveSet_RedField:
	db PALLET_TOWN
	db VIRIDIAN_FOREST
	db PEWTER_CITY
	db CERULEAN_CITY
	db VERMILION_SEASIDE
	db ROCK_MOUNTAIN
	db LAVENDER_TOWN

SecondMapMoveSet_RedField:
	db CYCLING_ROAD
	db SAFARI_ZONE
	db SEAFOAM_ISLANDS
	db CINNABAR_ISLAND

DoNothing_31324: ; 0x31324
	ret

DoNothing_31325: ; 0x31325
	ret

Func_31326: ; 0x31326
	ld a, [wMapMoveDirection]
	and a
	jr nz, .asm_3134c
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	ld a, $3
	callba LoadPsyduckOrPoliwagGraphics
	jr .asm_31382

.asm_3134c
	ld a, $80
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 4], a
	ld a, $1
	callba LoadPsyduckOrPoliwagGraphics
	ld a, $6
	callba LoadPsyduckOrPoliwagGraphics
	ld a, $7
	callba LoadPsyduckOrPoliwagNumberGraphics
.asm_31382
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_3139d
	ld a, $54
	ld [wStageCollisionMap + $e3], a
	ld a, $55
	ld [wStageCollisionMap + $103], a
	ld a, $52
	ld [wStageCollisionMap + $f0], a
	ld a, $53
	ld [wStageCollisionMap + $110], a
.asm_3139d
	ld a, $1
	ld [wd644], a
	callba CloseSlotCave
	ld de, $0003
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	ret

Func_313c3: ; 0x313c3
	callba ResetIndicatorStates
	callba Func_107c2
	callba SetLeftAndRightAlleyArrowIndicatorStates_BlueField
	ld a, $0
	ld [wd644], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	callba LoadSlotCaveCoverGraphics_BlueField
	callba LoadMapBillboardTileData
	ret

ChooseNextMap_BlueField: ; 0x3140b
; Picks the next map to perform a map move.
; Also records which maps have been visited.
	ld a, [wNumMapMoves]
	inc a
	cp $6
	jr c, .dontReset
	ld a, $ff
	ld [wVisitedMaps], a
	ld [wVisitedMaps + 1], a
	ld [wVisitedMaps + 2], a
	ld [wVisitedMaps + 3], a
	ld [wVisitedMaps + 4], a
	ld [wVisitedMaps + 5], a
	xor a
.dontReset
	ld [wNumMapMoves], a
	cp $3
	jr c, .chooseMapFromArea1
	cp $5
	jr c, .chooseMapFromArea2
	ld a, INDIGO_PLATEAU
	ld [wCurrentMap], a
	ld [wVisitedMaps + 5], a
	ret

.chooseMapFromArea1
	call GenRandom
	and $7
	cp $7
	jr nc, .chooseMapFromArea1
	ld c, a
	ld b, $0
	ld hl, FirstMapMoveSet_BlueField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps
	ld a, [wNumMapMoves]
	and a
	jr z, .asm_3145e
	ld b, a
.asm_31457
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea1
	dec b
	jr nz, .asm_31457
.asm_3145e
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

.chooseMapFromArea2
	call GenRandom
	and $3
	ld c, a
	ld b, $0
	ld hl, SecondMapMoveSet_BlueField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps + 3
	ld a, [wNumMapMoves]
	sub $3
	jr z, .asm_31490
	ld b, a
.asm_31489
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea2
	dec b
	jr nz, .asm_31489
.asm_31490
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

FirstMapMoveSet_BlueField:
	db VIRIDIAN_CITY
	db VIRIDIAN_FOREST
	db MT_MOON
	db CERULEAN_CITY
	db VERMILION_STREETS
	db ROCK_MOUNTAIN
	db CELADON_CITY

SecondMapMoveSet_BlueField:
	db FUCHSIA_CITY
	db SAFARI_ZONE
	db SAFFRON_CITY
	db CINNABAR_ISLAND

HandleRedMapModeCollision: ; 0x314ae
	ld a, [wTimerActive]
	and a
	ld a, [wSpecialModeCollisionID]
	jr z, .asm_314d0
	cp $1
	jp z, OpenRedMapMoveSlotFromLeft
	cp $3
	jp z, OpenRedMapMoveSlotFromLeft
	cp $2
	jp z, OpenRedMapMoveSlotFromRight
	cp $5
	jp z, OpenRedMapMoveSlotFromRight
	cp $d
	jp z, ResolveSucsessfulRedMapMove
.asm_314d0
	cp $0
	jr z, .asm_314d6
	scf
	ret

.asm_314d6
	call UpdateMapMove_RedField
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_314df: ; 0xd13df
	padded_dab Func_314ef
	padded_dab Func_314f1
	padded_dab Func_314f3
	padded_dab Func_31505

Func_314ef: ; 0x314ef
	scf
	ret

Func_314f1: ; 0x314f1
	scf
	ret

Func_314f3: ; 0x314f3
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

Func_31505: ; 0x31505
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

UpdateMapMove_RedField: ; 0x3151f handle map move timer and fail when it expires
	ld a, $50
	ld [wLeftDiglettAnimationController], a
	ld [wRightDiglettAnimationController], a
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut] ;if ??? is 0, quit, else make it zero (this only truns once per something?) and handle a failed map move
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $3
	ld [wd54d], a
	xor a
	ld [wSlotIsOpen], a ;close slot and indicators
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_31577 ;if on stage without flippers(the tops), jump
	callba ClearAllRedIndicators ;clear indicators
	callba LoadSlotCaveCoverGraphics_RedField
	callba LoadMapBillboardTileData
.asm_31577
	callba StopTimer ;stop the timer
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld de, MapMoveFailedText
	call LoadScrollingText
	ret

OpenRedMapMoveSlotFromLeft: ; 0x31591
	ld a, [wMapMoveDirection]
	and a
	jr nz, .NotApplicibleOrCompleted
	ld a, [wIndicatorStates]
	and a
	jr z, .NotApplicibleOrCompleted
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wSlotIsOpen], a
	ld [wd54d], a
.NotApplicibleOrCompleted
	scf
	ret

OpenRedMapMoveSlotFromRight: ; 0x315b3
	ld a, [wMapMoveDirection]
	and a
	jr z, .NotApplicibleOrCompleted
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .NotApplicibleOrCompleted
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wSlotIsOpen], a
	ld [wd54d], a
.NotApplicibleOrCompleted
	scf
	ret

ResolveSucsessfulRedMapMove: ; 0x315d5
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	callba ChooseNextMap_RedField
	callba LoadMapBillboardTileData
	lb de, $25, $25
	call PlaySoundEffect
	ld bc, ArrivedAtMapText
	callba LoadScrollingMapNameText
.asm_31603
	callba UpdateBottomText
	rst AdvanceFrame
	ld a, [wBottomTextEnabled]
	and a
	jr nz, .asm_31603
	ld a, $2
	ld [wd54d], a
	scf
	ret

HandleBlueMapModeCollision: ; 0x3161b
	ld a, [wTimerActive]
	and a
	ld a, [wSpecialModeCollisionID]
	jr z, .asm_3163d
	cp $1
	jp z, Func_31708
	cp $f
	jp z, Func_31708
	cp $2
	jp z, Func_3172a
	cp $e
	jp z, Func_3172a
	cp $d
	jp z, Func_3174c
.asm_3163d
	cp $0
	jr z, .asm_31643
	scf
	ret

.asm_31643
	call UpdateMapMove_BlueField
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_3164c: ; 0x3164c
	padded_dab Func_3165c
	padded_dab Func_3165e
	padded_dab Func_31660
	padded_dab Func_31672

Func_3165c: ; 0x3165c
	scf
	ret

Func_3165e: ; 0x3165e
	scf
	ret

Func_31660: ; 0x31660
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

Func_31672: ; 0x31672
	ld a, [wBottomTextEnabled] ;if text is off
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

UpdateMapMove_BlueField: ; 0x3168c
	ld a, $50
	ld [wLeftMapMovePoliwagAnimationCounter], a
	ld [wRightMapMovePsyduckFrame], a
	ld a, $3
	ld [wPsyduckState], a
	ld a, $1
	ld [wPoliwagState], a
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $3
	ld [wd54d], a
	xor a
	ld [wSlotIsOpen], a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_316ee
	callba Func_1c2cb
	callba LoadSlotCaveCoverGraphics_BlueField
	callba LoadMapBillboardTileData
.asm_316ee
	callba StopTimer
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld de, MapMoveFailedText
	call LoadScrollingText
	ret

Func_31708: ; 0x31708
	ld a, [wMapMoveDirection]
	and a
	jr nz, .asm_31728
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_31728
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wSlotIsOpen], a
	ld [wd54d], a
.asm_31728
	scf
	ret

Func_3172a: ; 0x3172a
	ld a, [wMapMoveDirection]
	and a
	jr z, .asm_3174a
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_3174a
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wSlotIsOpen], a
	ld [wd54d], a
.asm_3174a
	scf
	ret

Func_3174c: ; 0x3174c
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	callba ChooseNextMap_BlueField
	callba LoadMapBillboardTileData
	lb de, $25, $25
	call PlaySoundEffect
	ld bc, ArrivedAtMapText
	callba LoadScrollingMapNameText
.asm_3177a
	callba UpdateBottomText
	rst AdvanceFrame
	ld a, [wBottomTextEnabled]
	and a
	jr nz, .asm_3177a
	ld a, $2
	ld [wd54d], a
	scf
	ret
