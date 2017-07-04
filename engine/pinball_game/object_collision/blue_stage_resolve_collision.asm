ResolveBlueFieldTopGameObjectCollisions: ; 0x1c715
	call ResolveShellderCollision
	call ResolveBlueStageSpinnerCollision
	call ResolveBlueStagePinballUpgradeTriggersCollision
	call HandleBlueStageBallTypeUpgradeCounter
	call Func_1e66a
	call ResolveBlueStageBoardTriggerCollision
	call ResolveBlueStagePikachuCollision
	call ResolveSlowpokeCollision
	call ResolveCloysterCollision
	call Func_1ea3b
	call ResolvePsyduckPoliwagCollision
	call ResolveBlueStageForceFieldCollision
	call Func_1e9c0
	call Func_1c8b6
	call Func_1f18a
	callba Func_146a9
	call Func_1f27b
	call Func_1df15
	callba HandleExtraBall
	ld a, $0
	callba Func_10000
	ret

ResolveBlueFieldBottomGameObjectCollisions: ; 0x1c769
	call Func_1ca4a
	call Func_1ce40
	call ResolvePsyduckPoliwagCollision
	call Func_1ca85
	call Func_1e4b8
	call HandleBlueStageBallTypeUpgradeCounter
	call Func_1e5c5
	call Func_1c7d7
	call ResolveBlueStagePikachuCollision
	call Func_1ead4
	call ResolveBlueStageBonusMultiplierCollision
	call Func_1e757
	call Func_1e9c0
	call Func_1ea0a
	call Func_1c8b6
	callba Func_14733
	callba Func_146a2
	call Func_1f261
	call Func_1de93
	callba HandleExtraBall
	ld a, $0
	callba Func_10000
	ret

Func_1c7c7: ; 0x1c7c7
	ld a, $0
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ret

Func_1c7d7: ; 0x1c7d7
	ld a, [wPinballLaunchAlley]
	and a
	ret z
	xor a
	ld [wPinballLaunchAlley], a
	ld a, [wd4de]
	and a
	jr z, .asm_1c810
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hl], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld a, $71
	ld [wBallYVelocity], a
	ld a, $fa
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	lb de, $00, $0a
	call PlaySoundEffect
.asm_1c810
	ld a, $ff
	ld [wPreviousTriggeredGameObject], a
	ld a, [wd4de]
	and a
	ret nz
	ld a, [wd4e0]
	and a
	jr nz, .asm_1c82c
	call Func_1c839
	ld a, $1
	ld [wd4e0], a
	ld [wd4de], a
	ret

.asm_1c82c
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	ret z
	ld a, $1
	ld [wd4de], a
	ret

Func_1c839: ; 0x1c839
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, LoadGreyBillboardPaletteData
.showNextMap
	ld a, [wInitialMapSelectionIndex]
	inc a
	cp $7  ; number of maps to choose from at the start of play
	jr c, .gotMapId
	xor a  ; wrap around to 0
.gotMapId
	ld [wInitialMapSelectionIndex], a
	ld c, a
	ld b, $0
	ld hl, BlueStageInitialMaps
	add hl, bc
	ld a, [hl]
	ld [wCurrentMap], a
	push af
	lb de, $00, $48
	call PlaySoundEffect
	pop af
	add (PalletTownPic_Pointer - BillboardPicturePointers) / 3  ; map billboard pictures start at the $29th entry in BillboardPicturePointers
	callba LoadBillboardPicture
	ld b, $20  ; number of frames to delay before the next map is shown
.waitOnCurrentMap
	push bc
	callba Func_eeee
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	jr nz, .ballStartKeyPressed
	pop bc
	dec b
	jr nz, .waitOnCurrentMap
	jr .showNextMap

.ballStartKeyPressed
	pop bc
	callba LoadMapBillboardTileData
	ld bc, StartFromMapText
	callba Func_3118f
	ld a, [wCurrentMap]
	ld [wd4e3], a
	xor a
	ld [wd4e2], a
	ret

BlueStageInitialMaps: ; 0x1c8af
	db VIRIDIAN_CITY
	db VIRIDIAN_FOREST
	db MT_MOON
	db CERULEAN_CITY
	db VERMILION_STREETS
	db ROCK_MOUNTAIN
	db CELADON_CITY

Func_1c8b6: ; 0x1c8b6
	ld a, [wd64c]
	inc a
	cp $3c
	jr z, .asm_1c8c2
	ld [wd64c], a
	ret

.asm_1c8c2
	xor a
	ld [wd64c], a
	ld hl, wd64d
	inc [hl]
	ld a, [hl]
	cp $5
	ret nz
	ld a, [wd644]
	and a
	jr nz, .asm_1c8e1
	ld a, [wd643]
	and a
	jr nz, .asm_1c8e5
	ld a, [wRightAlleyCount]
	cp $2
	jr nc, .asm_1c8e5
.asm_1c8e1
	xor a
	ld [wd64b], a
.asm_1c8e5
	ld a, [wd644]
	and a
	jr nz, .asm_1c8f8
	ld a, [wd643]
	and a
	jr nz, .asm_1c8fc
	ld a, [wLeftAlleyCount]
	cp $3
	jr z, .asm_1c8fc
.asm_1c8f8
	xor a
	ld [wd64b], a
.asm_1c8fc
	xor a
	ld [wd64d], a
	xor a
	ld [wd64a], a
	ld [wd649], a
	ld [wd648], a
	ld a, [wBlueStageForceFieldDirection]
	cp $1  ; right direction
	jr z, .asm_1c97f
	cp $3  ; left direction
	jr z, .asm_1c97f
.asm_1c915
	ld a, [wd644]
	cp $0
	jr z, .asm_1c925
	ld a, [wd55a]
	cp $0
	jr nz, .asm_1c933
	jr .asm_1c947

.asm_1c925
	ld a, [wd643]
	cp $0
	jr nz, .asm_1c933
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .asm_1c947
.asm_1c933
	ld a, [wd64b]
	cp $1
	jr z, .asm_1c947
	ld a, $1  ; right direction
	ld [wBlueStageForceFieldDirection], a
	ld [wd64b], a
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	jr .asm_1c99e

.asm_1c947
	ld a, [wd644]
	cp $0
	jr z, .asm_1c955
	ld a, [wd55a]
	cp $0
	jr z, .asm_1c969
.asm_1c955
	ld a, [wd643]
	cp $0
	jr nz, .asm_1c969
	ld a, [wLeftAlleyCount]
	cp $3
	jr nz, .asm_1c97f
	ld a, [wInSpecialMode]
	and a
	jr nz, .asm_1c97f
.asm_1c969
	ld a, [wd64b]
	cp $3
	jr z, .asm_1c915
	ld a, $3  ; left direction
	ld [wBlueStageForceFieldDirection], a
	ld [wd64b], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	jr .asm_1c99e

.asm_1c97f
	ld a, [wBlueStageForceFieldFlippedDown]
	and a
	jr nz, .asm_1c993
	xor a
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	ld [wd64a], a
	jr .asm_1c99e

.asm_1c993
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	ret

.asm_1c99e
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jr nz, .asm_1c9ac
	ld a, $1
	ld [wd64a], a
	jr .asm_1c9c0

.asm_1c9ac
	cp $1
	jr nz, .asm_1c9b7
	ld a, $1
	ld [wd649], a
	jr .asm_1c9c0

.asm_1c9b7
	cp $3
	jr nz, .asm_1c9c0
	ld a, $1
	ld [wd648], a
.asm_1c9c0
	ret

ResolveShellderCollision: ; 0x1c9c1
	ld a, [wWhichShellder]
	and a
	jr z, .noCollision
	xor a
	ld [wWhichShellder], a
	call Func_1ca29
	ld a, [wBlueStageForceFieldFlippedDown]
	and a
	jr nz, .asm_1c9f2
	ld a, $1
	ld [wBlueStageForceFieldFlippedDown], a
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jr nz, .asm_1c9f2
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	ld a, $3
	ld [wd64c], a
	ld [wd64d], a
.asm_1c9f2
	ld a, $10
	ld [wd4d6], a
	ld a, [wWhichShellderId]
	sub $3
	ld [wd4d7], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.noCollision
	ld a, [wd4d6]
	and a
	ret z
	dec a
	ld [wd4d6], a
	ret nz
	ld a, $ff
	ld [wd4d7], a
	ret

Func_1ca29: ; 0x1ca29
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $0e
	call PlaySoundEffect
	ret

Func_1ca4a: ; 1ca4a
	ld a, [wWildMonCollision]
	and a
	ret z
	xor a
	ld [wWildMonCollision], a
	ld a, $1
	ld [wBallHitWildMon], a
	lb de, $00, $06
	call PlaySoundEffect
	ret

ResolveBlueStageSpinnerCollision: ; 0x1ca5f
	ld a, [wSpinnerCollision]
	and a
	jr z, Func_1ca85
	xor a
	ld [wSpinnerCollision], a
	ld a, [wBallYVelocity]
	ld c, a
	ld a, [wBallYVelocity + 1]
	ld b, a
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld a, $c
	callba Func_10000
	; fall through

Func_1ca85: ; 0x1ca85
	ld hl, wd50b
	ld a, [hli]
	or [hl]
	ret z
	ld a, [wd50b]
	ld c, a
	ld a, [wd50c]
	ld b, a
	bit 7, b
	jr nz, .asm_1caa3
	ld a, c
	sub $7
	ld c, a
	ld a, b
	sbc $0
	ld b, a
	jr nc, .asm_1cab0
	jr .asm_1caad

.asm_1caa3
	ld a, c
	add $7
	ld c, a
	ld a, b
	adc $0
	ld b, a
	jr nc, .asm_1cab0
.asm_1caad
	ld bc, $0000
.asm_1cab0
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld hl, wd50b
	ld a, [wd509]
	add [hl]
	ld [wd509], a
	inc hl
	ld a, [wd50a]
	adc [hl]
	bit 7, a
	ld c, $0
	jr z, .asm_1cad3
	add $18
	ld c, $1
	jr .asm_1cadb

.asm_1cad3
	cp $18
	jr c, .asm_1cadb
	sub $18
	ld c, $1
.asm_1cadb
	ld [wd50a], a
	ld a, c
	and a
	ret z
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wNumSpinnerTurns
	call Increment_Max100
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_1caff
	call Func_1cb1c
	ret

.asm_1caff
	inc a
	ld [wPikachuSaverCharge], a
	call Func_1cb1c
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_1cb12
	ld a, $64
	ld [wd51e], a
.asm_1cb12
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	call Func_1cb43
	ret

Func_1cb1c: ; 0x1cb1c
	ld a, [wd51e]
	and a
	ret nz
	ld a, [wPikachuSaverCharge]
	ld c, a
	ld b, $0
	ld hl, SoundEffectIds_1cb33
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

SoundEffectIds_1cb33:
	db $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $11

Func_1cb43: ; 0x1cb43
	ld a, [wPikachuSaverCharge]
	ld c, a
	sla c
	ld b, $0
	ld hl, TileDataPointers_1cb60
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1cb56
	ld hl, TileDataPointers_1cd10
.asm_1cb56
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_1cb60)
	call Func_10aa
	ret

TileDataPointers_1cb60:
	dw TileData_1cb80
	dw TileData_1cb85
	dw TileData_1cb8a
	dw TileData_1cb8f
	dw TileData_1cb94
	dw TileData_1cb99
	dw TileData_1cb9e
	dw TileData_1cba3
	dw TileData_1cba8
	dw TileData_1cbad
	dw TileData_1cbb2
	dw TileData_1cbb7
	dw TileData_1cbbc
	dw TileData_1cbc1
	dw TileData_1cbc6
	dw TileData_1cbcb

TileData_1cb80: ; 0x1cb80
	db $02
	dw TileData_1cbd0
	dw TileData_1cbda

TileData_1cb85: ; 0x1cb85
	db $02
	dw TileData_1cbe4
	dw TileData_1cbee

TileData_1cb8a: ; 0x1cb8a
	db $02
	dw TileData_1cbf8
	dw TileData_1cc02

TileData_1cb8f: ; 0x1cb8f
	db $02
	dw TileData_1cc0c
	dw TileData_1cc16

TileData_1cb94: ; 0x1cb94
	db $02
	dw TileData_1cc20
	dw TileData_1cc2a

TileData_1cb99: ; 0x1cb99
	db $02
	dw TileData_1cc34
	dw TileData_1cc3e

TileData_1cb9e: ; 0x1cb9e
	db $02
	dw TileData_1cc48
	dw TileData_1cc52

TileData_1cba3: ; 0x1cba3
	db $02
	dw TileData_1cc5c
	dw TileData_1cc66

TileData_1cba8: ; 0x1cba8
	db $02
	dw TileData_1cc70
	dw TileData_1cc7a

TileData_1cbad: ; 0x1cbad
	db $02
	dw TileData_1cc84
	dw TileData_1cc8e

TileData_1cbb2: ; 0x1cbb2
	db $02
	dw TileData_1cc98
	dw TileData_1cca2

TileData_1cbb7: ; 0x1cbb7
	db $02
	dw TileData_1ccac
	dw TileData_1ccb6

TileData_1cbbc: ; 0x1cbbc
	db $02
	dw TileData_1ccc0
	dw TileData_1ccca

TileData_1cbc1: ; 0x1cbc1
	db $02
	dw TileData_1ccd4
	dw TileData_1ccde

TileData_1cbc6: ; 0x1cbc6
	db $02
	dw TileData_1cce8
	dw TileData_1ccf2

TileData_1cbcb: ; 0x1cbcb
	db $02
	dw TileData_1ccfc
	dw TileData_1cd06

TileData_1cbd0: ; 0xcbd0
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageBlueFieldTopBaseGameBoyGfx + $c20
	db Bank(StageBlueFieldTopBaseGameBoyGfx)
	db $00 ; terminator

TileData_1cbda: ; 0xcbda
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageBlueFieldTopBaseGameBoyGfx + $c40
	db Bank(StageBlueFieldTopBaseGameBoyGfx)
	db $00 ; terminator

TileData_1cbe4: ; 0xcbe4
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1800
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cbee: ; 0xcbee
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1820
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cbf8: ; 0xcbf8
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1840
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc02: ; 0xcc02
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1860
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc0c: ; 0xcc0c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1880
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc16: ; 0xcc16
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $18A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc20: ; 0xcc20
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $18C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc2a: ; 0xcc2a
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $18E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc34: ; 0xcc34
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1900
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc3e: ; 0xcc3e
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1920
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc48: ; 0xcc48
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1940
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc52: ; 0xcc52
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1960
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc5c: ; 0xcc5c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1980
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc66: ; 0xcc66
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $19A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc70: ; 0xcc70
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $19C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc7a: ; 0xcc7a
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $19E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc84: ; 0xcc84
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc8e: ; 0xcc8e
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc98: ; 0xcc98
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cca2: ; 0xcca2
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccac: ; 0xccac
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccb6: ; 0xccb6
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1AA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccc0: ; 0xccc0
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1AC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccca: ; 0xccca
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1AE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccd4: ; 0xccd4
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccde: ; 0xccde
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cce8: ; 0xcce8
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccf2: ; 0xccf2
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccfc: ; 0xccfc
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cd06: ; 0xcd06
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1BA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileDataPointers_1cd10:
	dw TileData_1cd30
	dw TileData_1cd33
	dw TileData_1cd36
	dw TileData_1cd39
	dw TileData_1cd3c
	dw TileData_1cd3f
	dw TileData_1cd42
	dw TileData_1cd45
	dw TileData_1cd48
	dw TileData_1cd4b
	dw TileData_1cd4e
	dw TileData_1cd51
	dw TileData_1cd54
	dw TileData_1cd57
	dw TileData_1cd5a
	dw TileData_1cd5d

TileData_1cd30: ; 0x1cd30
	db $01
	dw TileData_1cd60

TileData_1cd33: ; 0x1cd33
	db $01
	dw TileData_1cd6e

TileData_1cd36: ; 0x1cd36
	db $01
	dw TileData_1cd7c

TileData_1cd39: ; 0x1cd39
	db $01
	dw TileData_1cd8a

TileData_1cd3c: ; 0x1cd3c
	db $01
	dw TileData_1cd98

TileData_1cd3f: ; 0x1cd3f
	db $01
	dw TileData_1cda6

TileData_1cd42: ; 0x1cd42
	db $01
	dw TileData_1cdb4

TileData_1cd45: ; 0x1cd45
	db $01
	dw TileData_1cdc2

TileData_1cd48: ; 0x1cd48
	db $01
	dw TileData_1cdd0

TileData_1cd4b: ; 0x1cd4b
	db $01
	dw TileData_1cdde

TileData_1cd4e: ; 0x1cd4e
	db $01
	dw TileData_1cdec

TileData_1cd51: ; 0x1cd51
	db $01
	dw TileData_1cdfa

TileData_1cd54: ; 0x1cd54
	db $01
	dw TileData_1ce08

TileData_1cd57: ; 0x1cd57
	db $01
	dw TileData_1ce16

TileData_1cd5a: ; 0x1cd5a
	db $01
	dw TileData_1ce24

TileData_1cd5d: ; 0x1cd5d
	db $01
	dw TileData_1ce32

TileData_1cd60: ; 0x1cd60
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $4A, $4B

	db $00 ; terminator

TileData_1cd6e: ; 0x1cd6e
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $4C, $4D

	db $00 ; terminator

TileData_1cd7c: ; 0x1cd7c
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $4E, $4F

	db $00 ; terminator

TileData_1cd8a: ; 0x1cd8a
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $50, $51

	db $00 ; terminator

TileData_1cd98: ; 0x1cd98
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $52, $53

	db $00 ; terminator

TileData_1cda6: ; 0x1cda6
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $54, $55

	db $00 ; terminator

TileData_1cdb4: ; 0x1cdb4
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $56, $57

	db $00 ; terminator

TileData_1cdc2: ; 0x1cdc2
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdd0: ; 0x1cdd0
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdde: ; 0x1cdde
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $5C, $5D

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdec: ; 0x1cdec
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $5E, $5F

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdfa: ; 0x1cdfa
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $60, $61

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce08: ; 0x1ce08
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $62, $63

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce16: ; 0x1ce16
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $64, $65

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce24: ; 0x1ce24
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $66, $67

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce32: ; 0x1ce32
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $68, $69

	db $02 ; number of tiles
	dw vBGMap + $163
	db $6A, $6B

	db $00 ; terminator

Func_1ce40: ; 1ce40
	ld a, [wWhichBumper]
	and a
	jr z, .asm_1ce53
	call Func_1ce72
	call Func_1ce60
	xor a
	ld [wWhichBumper], a
	call Func_1ce94
.asm_1ce53
	ld a, [wd4da]
	and a
	ret z
	dec a
	ld [wd4da], a
	call z, Func_1ce72
	ret

Func_1ce60: ; 0x1ce60
	ld a, $10
	ld [wd4da], a
	ld a, [wWhichBumperId]
	sub $1
	ld [wd4db], a
	sla a
	inc a
	jr asm_1ce7a

Func_1ce72: ; 1ce72
	ld a, [wd4db]
	cp $ff
	ret z
	sla a
asm_1ce7a: ; 0x1ce7a
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1ceca
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1ce8a
	ld hl, TileDataPointers_1cf3a
.asm_1ce8a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_1ceca)
	call Func_10aa
	ret

Func_1ce94: ; 0x1ce94
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wWhichBumperId]
	sub $1
	ld c, a
	ld b, $0
	ld hl, Data_1cec8
	add hl, bc
	ld a, [wCollisionForceAngle]
	add [hl]
	ld [wCollisionForceAngle], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

Data_1cec8:
	db -8, 8

TileDataPointers_1ceca:
	dw TileData_1ced2
	dw TileData_1ced5
	dw TileData_1ced8
	dw TileData_1cedb

TileData_1ced2: ; 0x1ced2
	db $01
	dw TileData_1cede

TileData_1ced5: ; 0x1ced5
	db $01
	dw TileData_1cef5

TileData_1ced8: ; 0x1ced8
	db $01
	dw TileData_1cf0c

TileData_1cedb: ; 0x1cedb
	db $01
	dw TileData_1cf23

TileData_1cede: ; 0x1cede
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $61

	db $02 ; number of tiles
	dw vBGMap + $144
	db $62, $63

	db $02 ; number of tiles
	dw vBGMap + $164
	db $64, $65

	db $02 ; number of tiles
	dw vBGMap + $185
	db $66, $67

	db $00 ; number of tiles

TileData_1cef5: ; 0x1cef5
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $68

	db $02 ; number of tiles
	dw vBGMap + $144
	db $69, $6A

	db $02 ; number of tiles
	dw vBGMap + $164
	db $6B, $6C

	db $02 ; number of tiles
	dw vBGMap + $185
	db $6D, $6E

	db $00 ; number of tiles

TileData_1cf0c: ; 0x1cf0c
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $6F

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $70, $71

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $72, $73

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $74, $75

	db $00 ; number of tiles

TileData_1cf23: ; 0x1cf23
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $76

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $77, $78

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $79, $7A

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $7B, $7C

	db $00 ; number of tiles

TileDataPointers_1cf3a:
	dw TileData_1cf42
	dw TileData_1cf45
	dw TileData_1cf48
	dw TileData_1cf4b

TileData_1cf42: ; 0x1cf42
	db $01
	dw TileData_1cf4e

TileData_1cf45: ; 0x1cf45
	db $01
	dw TileData_1cf65

TileData_1cf48: ; 0x1cf48
	db $01
	dw TileData_1cf7c

TileData_1cf4b: ; 0x1cf4b
	db $01
	dw TileData_1cf93

TileData_1cf4e: ; 0x1cf4e
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $39

	db $02 ; number of tiles
	dw vBGMap + $144
	db $3A, $3B

	db $02 ; number of tiles
	dw vBGMap + $164
	db $3C, $3D

	db $02 ; number of tiles
	dw vBGMap + $185
	db $3E, $3F

	db $00 ; terminator

TileData_1cf65: ; 0x1cf65
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $40

	db $02 ; number of tiles
	dw vBGMap + $144
	db $41, $42

	db $02 ; number of tiles
	dw vBGMap + $164
	db $43, $44

	db $02 ; number of tiles
	dw vBGMap + $185
	db $45, $46

	db $00 ; terminator

TileData_1cf7c: ; 0x1cf7c
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $39

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $3B, $3A

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $3D, $3C

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $3F, $3E

	db $00 ; terminator

TileData_1cf93: ; 0x1cf93
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $40

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $42, $41

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $44, $43

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $46, $45

	db $00 ; terminator

ResolveBlueStageBoardTriggerCollision: ; 0x1cfaa
	ld a, [wWhichBoardTrigger]
	and a
	ret z
	xor a
	ld [wWhichBoardTrigger], a
	ld bc, FivePoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wStageCollisionState]
	cp $0
	jr nz, .asm_1cfe5
	ld a, $1
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ld a, $1
	ld [wd580], a
	callba Func_1404a
.asm_1cfe5
	ld a, [wWhichBoardTriggerId]
	sub $7
	ld c, a
	ld b, $0
	ld hl, wd521
	add hl, bc
	ld [hl], $1
	ld a, [wd521]
	and a
	call nz, Func_1d010
	ld a, [wd522]
	and a
	call nz, Func_1d047
	ld a, [wd523]
	and a
	call nz, HandleLeftAlleyTriggerBlueField
	ld a, [wd524]
	and a
	call nz, HandleRightAlleyTriggerBlueField
	ret

Func_1d010: ; 0x1d010
	xor a
	ld [wd521], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba Func_10000
	ret c
	ld a, [wLeftAlleyCount]
	cp $3
	ret z
	inc a
	ld [wLeftAlleyCount], a
	cp $3
	jr z, .asm_1d03e
	set 7, a
	ld [wIndicatorStates], a
	ret

.asm_1d03e
	ld [wIndicatorStates], a
	ld a, $80
	ld [wIndicatorStates + 2], a
	ret

Func_1d047: ; 0x1d047
	xor a
	ld [wd522], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba Func_10000
	ret c
	ld a, [wRightAlleyCount]
	cp $3
	ret z
	inc a
	ld [wRightAlleyCount], a
	cp $3
	jr z, .asm_1d071
	set 7, a
.asm_1d071
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

HandleLeftAlleyTriggerBlueField: ; 0x1d080
; Ball passed over the left alley trigger point in the Blue Field.
	xor a
	ld [wd523], a
	ld [wRightAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wLeftAlleyTrigger], a
	ret c
	ret

HandleRightAlleyTriggerBlueField: ; 0x1d091
; Ball passed over the right alley trigger point in the Blue Field.
	xor a
	ld [wd524], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wRightAlleyTrigger], a
	ret

ResolveBlueStagePikachuCollision: ; 0x1d0a1
	ld a, [wWhichPikachu]
	and a
	jr z, .asm_1d110
	xor a
	ld [wWhichPikachu], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1d110
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	jr nz, .asm_1d0c9
	ld a, [wWhichPikachuId]
	sub $d
	ld hl, wd518
	cp [hl]
	jr nz, .asm_1d110
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_1d0fc
.asm_1d0c9
	ld hl, PikachuSaverAnimationDataRedStage
	ld de, wPikachuSaverAnimation
	call InitAnimation
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	jr nz, .asm_1d0dc
	xor a
	ld [wPikachuSaverCharge], a
.asm_1d0dc
	ld a, $1
	ld [wd51c], a
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld [wd549], a
	call FillBottomMessageBufferWithBlackTile
	jr .asm_1d110

.asm_1d0fc
	ld hl, PikachuSaverAnimation2DataRedStage
	ld de, wPikachuSaverAnimation
	call InitAnimation
	ld a, $2
	ld [wd51c], a
	lb de, $00, $3b
	call PlaySoundEffect
.asm_1d110
	ld a, [wd51c]
	and a
	call z, Func_1d1fb
	call Func_1d133
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	ret nz
	ld a, [wd51e]
	and a
	ret z
	dec a
	ld [wd51e], a
	cp $5a
	ret nz
	lb de, $0f, $22
	call PlaySoundEffect
	ret

Func_1d133: ; 0x1d133
	ld a, [wd51c]
	cp $1
	jr nz, .asm_1d1ae
	ld hl, PikachuSaverAnimationDataRedStage
	ld de, wPikachuSaverAnimation
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationIndex]
	cp $1
	jr nz, .asm_1d18c
	xor a
	ld [wd85d], a
	call Func_310a
	rst AdvanceFrame
	ld a, $1
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wd85d], a
	ld a, $ff
	ld [wd803], a
	ld a, $60
	ld [wd804], a
	ld hl, wNumPikachuSaves
	call Increment_Max100
	jr nc, .asm_1d185
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_1d185
	lb de, $16, $10
	call PlaySoundEffect
	ret

.asm_1d18c
	ld a, [wPikachuSaverAnimationIndex]
	cp $11
	ret nz
	ld a, $fc
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wd51c], a
	ret

.asm_1d1ae
	cp $2
	jr nz, .asm_1d1c7
	ld hl, PikachuSaverAnimation2DataRedStage
	ld de, wPikachuSaverAnimation
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationIndex]
	cp $1
	ret nz
	xor a
	ld [wd51c], a
	ret

.asm_1d1c7
	ld a, [hNumFramesDropped]
	swap a
	and $1
	ld [wPikachuSaverAnimationFrame], a
	ret

PikachuSaverAnimationDataRedStage: ; 0x1d1d1
; Each entry is [duration][OAM id]
	db $0C, $02
	db $05, $03
	db $05, $02
	db $05, $04
	db $05, $05
	db $05, $02
	db $06, $06
	db $06, $07
	db $06, $08
	db $06, $02
	db $06, $05
	db $06, $08
	db $06, $07
	db $06, $02
	db $06, $08
	db $06, $07
	db $06, $02
	db $01, $00
	db $00

PikachuSaverAnimation2DataRedStage: ; 0x1d1f6
; Each entry is [duration][OAM id]
	db $0C, $02
	db $01, $00
	db $00

Func_1d1fb: ; 0x1d1fb
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	jr z, .asm_1d209
	ld hl, wd518
	ld [hl], $0
	ret

.asm_1d209
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ret z
	ld hl, wd518
	ld [hl], $1
	ret

ResolveSlowpokeCollision: ; 0x1d216
	ld a, [wSlowpokeCollision]
	and a
	jr z, .asm_1d253
	xor a
	ld [wSlowpokeCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, SlowpokeCollisionAnimationData ; 0x1d312
	ld de, wSlowpokeAnimation
	call InitAnimation
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	xor a
	ld [wd549], a
.asm_1d253
	ld hl, SlowpokeCollisionAnimationData ; 0x1d312
	ld de, wSlowpokeAnimation
	call UpdateAnimation
	push af
	ld a, [wSlowpokeAnimation]
	and a
	jr nz, .asm_1d271
	ld a, $19
	ld [wSlowpokeAnimationFrameCounter], a
	xor a
	ld [wSlowpokeAnimationFrame], a
	ld a, $6
	ld [wSlowpokeAnimationIndex], a
.asm_1d271
	pop af
	ret nc
	ld a, [wSlowpokeAnimationIndex]
	cp $1
	jr nz, .asm_1d2b6
	xor a
	ld [wd548], a
	ld a, [wLeftAlleyCount]
	cp $3
	jr nz, .asm_1d299
	callba Func_10ab3
	ld a, [wd643]
	and a
	ret z
	ld a, $1
	ld [wd642], a
.asm_1d299
	ld hl, wNumSlowpokeEntries
	call Increment_Max100
	ld hl, wNumBellsproutEntries ; This is an oversight. No need to tally bellsprout.
	call Increment_Max100
	ret nc
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplier
	ret

.asm_1d2b6
	ld a, [wSlowpokeAnimationIndex]
	cp $4
	jr nz, .asm_1d2c3
	ld a, $1
	ld [wd548], a
	ret

.asm_1d2c3
	ld a, [wSlowpokeAnimationIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wd549], a
	ld a, $b0
	ld [wBallXVelocity], a
	ld a, $0
	ld [wBallXVelocity + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, [wd642]
	cp $0
	jr nz, .asm_1d2f8
	ld a, $f
	callba Func_10000
.asm_1d2f8
	xor a
	ld [wd642], a
	ld [wd64c], a
	ld [wd64d], a
	ld a, $1
	ld [wBlueStageForceFieldFlippedDown], a
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	ret

SlowpokeCollisionAnimationData: ; 0x1d312
; Each entry is [OAM id][duration]
	db $08, $01
	db $06, $02
	db $06, $02
	db $08, $01
	db $01, $00
	db $29, $00
	db $28, $01
	db $2A, $00
	db $27, $01
	db $29, $00
	db $28, $01
	db $2B, $00
	db $28, $01
	db $00

ResolveCloysterCollision: ; 0x1d32d
	ld a, [wCloysterCollision]
	and a
	jr z, .asm_1d36a
	xor a
	ld [wCloysterCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, CloysterCollisionAnimationData
	ld de, wCloysterAnimation
	call InitAnimation
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	xor a
	ld [wd549], a
.asm_1d36a
	ld hl, CloysterCollisionAnimationData
	ld de, wCloysterAnimation
	call UpdateAnimation
	push af
	ld a, [wCloysterAnimationFrameCounter]
	and a
	jr nz, .asm_1d388
	ld a, $19
	ld [wCloysterAnimationFrameCounter], a
	xor a
	ld [wCloysterAnimationFrame], a
	ld a, $6
	ld [wCloysterAnimationIndex], a
.asm_1d388
	pop af
	ret nc
	ld a, [wCloysterAnimationIndex]
	cp $1
	jr nz, .asm_1d3cb
	xor a
	ld [wd548], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .noCatchEmMode
	ld a, $8
	jr nz, .asm_1d3a1
	xor a
.asm_1d3a1
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
.noCatchEmMode
	ld hl, wNumCloysterEntries
	call Increment_Max100
	ld hl, wNumBellsproutEntries
	call Increment_Max100
	ret nc
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplier
	ret

.asm_1d3cb
	ld a, [wCloysterAnimationIndex]
	cp $4
	jr nz, .asm_1d3d8
	ld a, $1
	ld [wd548], a
	ret

.asm_1d3d8
	ld a, [wCloysterAnimationIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wd549], a
	ld a, $4f
	ld [wBallXVelocity], a
	ld a, $ff
	ld [wBallXVelocity + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, $e
	callba Func_10000
	xor a
	ld [wd64c], a
	ld [wd64d], a
	ld a, $1
	ld [wBlueStageForceFieldFlippedDown], a
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	ret

CloysterCollisionAnimationData: ; 0x1d41d
; Each entry is [OAM id][duration]
	db $08, $01
	db $06, $02
	db $06, $02
	db $08, $01
	db $01, $00
	db $29, $00
	db $28, $01
	db $2A, $00
	db $27, $01
	db $29, $00
	db $28, $01
	db $2B, $00
	db $28, $01
	db 00 ; terminator

ResolveBlueStageBonusMultiplierCollision: ; 0x1d438
	call Func_1d692
	ld a, [wWhichBonusMultiplierRailing]
	and a
	jp z, Func_1d51b
	xor a
	ld [wWhichBonusMultiplierRailing], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wWhichBonusMultiplierRailingId]
	sub $f
	jr nz, .asm_1d48e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d45c
	ld a, $1f
	jr .asm_1d45e

.asm_1d45c
	ld a, $29
.asm_1d45e
	call Func_1d5f2
	ld a, $3c
	ld [wd647], a
	ld a, $9
	callba Func_10000
	ld a, [wd610]
	cp $3
	jp nz, asm_1d4fa
	ld a, $1
	ld [wd610], a
	ld a, $3
	ld [wd611], a
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	jr asm_1d4fa

.asm_1d48e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d497
	ld a, $21
	jr .asm_1d499

.asm_1d497
	ld a, $2b
.asm_1d499
	call Func_1d5f2
	ld a, $1e
	ld [wd647], a
	ld a, $a
	callba Func_10000
	ld a, [wd611]
	cp $3
	jr nz, asm_1d4fa
	ld a, $1
	ld [wd610], a
	ld a, $1
	ld [wd611], a
	ld a, $80
	ld [wd612], a
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	ld a, [wd482]
	inc a
	cp 100
	jr c, .asm_1d4d5
	ld a, 99
.asm_1d4d5
	ld [wd482], a
	jr nc, .asm_1d4e9
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_1d4e9
	ld a, [wd60c]
	ld [wd614], a
	ld a, [wd60d]
	ld [wd615], a
	ld a, $1
	ld [wd613], a
asm_1d4fa: ; 0x1d4fa
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd60c]
	call Func_1d5f2
	ld a, [wd60d]
	add $14
	call Func_1d5f2
	ld a, $3c
	ld [wd647], a
	ret

Func_1d51b: ; 0x1d51b
	call Func_1d5bf
	ld a, [wd612]
	and a
	jr z, .asm_1d559
	dec a
	ld [wd612], a
	cp $70
	jr nz, .asm_1d538
	ld a, $2
	ld [wd610], a
	ld a, $2
	ld [wd611], a
	jr .asm_1d559

.asm_1d538
	and a
	jr nz, .asm_1d559
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld a, [wd482]
	call Func_1d65f
	ld a, [wd60c]
	call Func_1d5f2
	ld a, [wd60d]
	add $14
	call Func_1d5f2
	ret

.asm_1d559
	ld a, [wd610]
	cp $2
	jr c, .asm_1d58b
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_1d56a
	srl a
	srl a
.asm_1d56a
	ld b, a
	and $3
	jr nz, .asm_1d58b
	bit 3, b
	jr nz, .asm_1d580
	ld a, [wd60c]
	res 7, a
	ld [wd60c], a
	call Func_1d5f2
	jr .asm_1d58b

.asm_1d580
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	call Func_1d5f2
.asm_1d58b
	ld a, [wd611]
	cp $2
	ret c
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_1d59b
	srl a
	srl a
.asm_1d59b
	ld b, a
	and $3
	ret nz
	bit 3, b
	jr nz, .asm_1d5b1
	ld a, [wd60d]
	res 7, a
	ld [wd60d], a
	add $14
	call Func_1d5f2
	ret

.asm_1d5b1
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	add $14
	call Func_1d5f2
	ret

Func_1d5bf: ; 0x1d5bf
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd613]
	and a
	ret z
	xor a
	ld [wd613], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, BonusMultiplierText
	call LoadTextHeader
	ld hl, wBottomMessageText + $12
	ld a, [wd614]
	and $7f
	jr z, .asm_1d5e9
	add $30
	ld [hli], a
.asm_1d5e9
	ld a, [wd615]
	res 7, a
	add $30
	ld [hl], a
	ret

Func_1d5f2: ; 0x1d5f2
	push af
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d5fd
	pop af
	call Func_1d602
	ret

.asm_1d5fd
	pop af
	call Func_1d645
	ret

Func_1d602: ; 0x1d602
	push af
	res 7, a
	ld hl, wd60e
	cp $14
	jr c, .asm_1d611
	ld hl, wd60f
	sub $a
.asm_1d611
	cp [hl]
	jr z, .asm_1d626
	ld [hl], a
	ld c, a
	ld b, $0
	sla c
	ld hl, TileDataPointers_1d6be
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_1d6be)
	call Func_10aa
.asm_1d626
	pop af
	ld bc, $0000
	bit 7, a
	jr z, .asm_1d632
	res 7, a
	set 1, c
.asm_1d632
	cp $14
	jr c, .asm_1d638
	set 2, c
.asm_1d638
	ld hl, TileDataPointers_1d946
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_1d946)
	call Func_10aa
	ret

Func_1d645: ; 0x1d645
	bit 7, a
	jr z, .asm_1d64d
	res 7, a
	add $a
.asm_1d64d
	ld c, a
	ld b, $0
	sla c
	ld hl, TileDataPointers_1d97a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_1d97a)
	call Func_10aa
	ret

Func_1d65f: ; 0x1d65f
	ld a, [wd482]
	inc a
	cp $64
	jr c, .asm_1d669
	ld a, $63
.asm_1d669
	ld b, a
	xor a
	ld hl, Data_1d68b
	ld c, $7
.asm_1d670
	bit 0, b
	jr z, .asm_1d676
	add [hl]
	daa
.asm_1d676
	srl b
	inc hl
	dec c
	jr nz, .asm_1d670
	push af
	swap a
	and $f
	ld [wd60c], a
	pop af
	and $f
	ld [wd60d], a
	ret

Data_1d68b:
; BCD powers of 2
	db $01, $02, $04, $08, $16, $32, $64

Func_1d692: ; 0x1d692
	ld a, [wd647]
	cp $1
	jr z, .asm_1d69e
	dec a
	ld [wd647], a
	ret

.asm_1d69e
	ld a, $0
	ld [wd647], a
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d6b3
	ld a, $1e
	call Func_1d5f2
	ld a, $20
	call Func_1d5f2
	ret

.asm_1d6b3
	ld a, $2a
	call Func_1d5f2
	ld a, $28
	call Func_1d5f2
	ret

TileDataPointers_1d6be:
	dw TileData_1d6ee
	dw TileData_1d6f3
	dw TileData_1d6f8
	dw TileData_1d6fd
	dw TileData_1d702
	dw TileData_1d707
	dw TileData_1d70c
	dw TileData_1d711
	dw TileData_1d716
	dw TileData_1d71b
	dw TileData_1d720
	dw TileData_1d725
	dw TileData_1d72a
	dw TileData_1d72f
	dw TileData_1d734
	dw TileData_1d739
	dw TileData_1d73e
	dw TileData_1d743
	dw TileData_1d748
	dw TileData_1d74d
	dw TileData_1d752
	dw TileData_1d757
	dw TileData_1d75c
	dw TileData_1d761

TileData_1d6ee: ; 0x1d6ee
	db $02
	dw TileData_1d766
	dw TileData_1d770

TileData_1d6f3: ; 0x1d6f3
	db $02
	dw TileData_1d77a
	dw TileData_1d784

TileData_1d6f8: ; 0x1d6f8
	db $02
	dw TileData_1d78e
	dw TileData_1d798

TileData_1d6fd: ; 0x1d6fd
	db $02
	dw TileData_1d7a2
	dw TileData_1d7AC

TileData_1d702: ; 0x1d702
	db $02
	dw TileData_1d7b6
	dw TileData_1d7C0

TileData_1d707: ; 0x1d707
	db $02
	dw TileData_1d7ca
	dw TileData_1d7D4

TileData_1d70c: ; 0x1d70c
	db $02
	dw TileData_1d7de
	dw TileData_1d7E8

TileData_1d711: ; 0x1d711
	db $02
	dw TileData_1d7f2
	dw TileData_1d7FC

TileData_1d716: ; 0x1d716
	db $02
	dw TileData_1d806
	dw TileData_1d810

TileData_1d71b: ; 0x1d71b
	db $02
	dw TileData_1d81a
	dw TileData_1d824

TileData_1d720: ; 0x1d720
	db $02
	dw TileData_1d82e
	dw TileData_1d838

TileData_1d725: ; 0x1d725
	db $02
	dw TileData_1d842
	dw TileData_1d84C

TileData_1d72a: ; 0x1d72a
	db $02
	dw TileData_1d856
	dw TileData_1d860

TileData_1d72f: ; 0x1d72f
	db $02
	dw TileData_1d86a
	dw TileData_1d874

TileData_1d734: ; 0x1d734
	db $02
	dw TileData_1d87e
	dw TileData_1d888

TileData_1d739: ; 0x1d739
	db $02
	dw TileData_1d892
	dw TileData_1d89C

TileData_1d73e: ; 0x1d73e
	db $02
	dw TileData_1d8a6
	dw TileData_1d8B0

TileData_1d743: ; 0x1d743
	db $02
	dw TileData_1d8ba
	dw TileData_1d8C4

TileData_1d748: ; 0x1d748
	db $02
	dw TileData_1d8ce
	dw TileData_1d8D8

TileData_1d74d: ; 0x1d74d
	db $02
	dw TileData_1d8e2
	dw TileData_1d8EC

TileData_1d752: ; 0x1d752
	db $02
	dw TileData_1d8f6
	dw TileData_1d900

TileData_1d757: ; 0x1d757
	db $02
	dw TileData_1d90a
	dw TileData_1d914

TileData_1d75c: ; 0x1d75c
	db $02
	dw TileData_1d91e
	dw TileData_1d928

TileData_1d761: ; 0x1d761
	db $02
	dw TileData_1d932
	dw TileData_1d93C

TileData_1d766: ; 0x1d766
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d770: ; 0x1d770
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1cc0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d77a: ; 0x1d77a
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d70
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d784: ; 0x1d784
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1cd0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d78e: ; 0x1d78e
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d798: ; 0x1d798
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1ce0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7a2: ; 0x1d7a2
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d90
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7AC: ; 0x1d7AC
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1cf0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7b6: ; 0x1d7b6
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1da0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7C0: ; 0x1d7C0
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7ca: ; 0x1d7ca
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1db0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7D4: ; 0x1d7D4
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d10
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7de: ; 0x1d7de
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1dc0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7E8: ; 0x1d7E8
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7f2: ; 0x1d7f2
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1dd0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d7FC: ; 0x1d7FC
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d806: ; 0x1d806
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1de0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d810: ; 0x1d810
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d81a: ; 0x1d81a
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $27
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1df0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d824: ; 0x1d824
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1d50
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d82e: ; 0x1d82e
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1ea0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d838: ; 0x1d838
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d842: ; 0x1d842
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1eb0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d84C: ; 0x1d84C
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e10
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d856: ; 0x1d856
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1ec0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d860: ; 0x1d860
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d86a: ; 0x1d86a
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1ed0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d874: ; 0x1d874
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d87e: ; 0x1d87e
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1ee0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d888: ; 0x1d888
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d892: ; 0x1d892
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1ef0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d89C: ; 0x1d89C
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e50
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8a6: ; 0x1d8a6
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1f00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8B0: ; 0x1d8B0
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8ba: ; 0x1d8ba
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1f10
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8C4: ; 0x1d8C4
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e70
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8ce: ; 0x1d8ce
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1f20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8D8: ; 0x1d8D8
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8e2: ; 0x1d8e2
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $28
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1f30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8EC: ; 0x1d8EC
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $7E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1e90
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1d8f6: ; 0x1d8f6
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $29
	dw StageBlueFieldBottomBaseGameBoyGfx + $A90
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d900: ; 0x1d900
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $2C
	dw StageBlueFieldBottomBaseGameBoyGfx + $AC0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d90a: ; 0x1d90a
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $29
	dw StageBlueFieldBottomBaseGameBoyGfx + $AE0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d914: ; 0x1d914
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $2C
	dw StageBlueFieldBottomBaseGameBoyGfx + $B10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d91e: ; 0x1d91e
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $33
	dw StageBlueFieldBottomBaseGameBoyGfx + $B30
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d928: ; 0x1d928
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $36
	dw StageBlueFieldBottomBaseGameBoyGfx + $B60
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d932: ; 0x1d932
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $33
	dw StageBlueFieldBottomBaseGameBoyGfx + $B80
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1d93C: ; 0x1d93C
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $36
	dw StageBlueFieldBottomBaseGameBoyGfx + $BB0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileDataPointers_1d946:
	dw TileData_1d94e
	dw TileData_1d951
	dw TileData_1d954
	dw TileData_1d957

TileData_1d94e: ; 0x1d94e
	db $01
	dw TileData_1d95a

TileData_1d951: ; 0x1d951
	db $01
	dw TileData_1d962

TileData_1d954: ; 0x1d954
	db $01
	dw TileData_1d96a

TileData_1d957: ; 0x1d957
	db $01
	dw TileData_1d972

TileData_1d95a: ; 0x1d95a
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $27

	db $00 ; terminator

TileData_1d962: ; 0x1d962
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $7D

	db $00 ; terminator

TileData_1d96a: ; 0x1d96a
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $28

	db $00 ; terminator

TileData_1d972: ; 0x1d972
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7E

	db $00 ; terminator

TileDataPointers_1d97a:
	dw TileData_1d9d2
	dw TileData_1d9d5
	dw TileData_1d9d8
	dw TileData_1d9db
	dw TileData_1d9de
	dw TileData_1d9e1
	dw TileData_1d9e4
	dw TileData_1d9e7
	dw TileData_1d9ea
	dw TileData_1d9ed
	dw TileData_1d9f0
	dw TileData_1d9f3
	dw TileData_1d9f6
	dw TileData_1d9f9
	dw TileData_1d9fc
	dw TileData_1d9ff
	dw TileData_1da02
	dw TileData_1da05
	dw TileData_1da08
	dw TileData_1da0b
	dw TileData_1da0e
	dw TileData_1da11
	dw TileData_1da14
	dw TileData_1da17
	dw TileData_1da1a
	dw TileData_1da1d
	dw TileData_1da20
	dw TileData_1da23
	dw TileData_1da26
	dw TileData_1da29
	dw TileData_1da2c
	dw TileData_1da2f
	dw TileData_1da32
	dw TileData_1da35
	dw TileData_1da38
	dw TileData_1da3b
	dw TileData_1da3e
	dw TileData_1da41
	dw TileData_1da44
	dw TileData_1da47
	dw TileData_1da4a
	dw TileData_1da4d
	dw TileData_1da50
	dw TileData_1da53

TileData_1d9d2: ; 0x1d9d2
	db $01
	dw TileData_1da56

TileData_1d9d5: ; 0x1d9d5
	db $01
	dw TileData_1da5e

TileData_1d9d8: ; 0x1d9d8
	db $01
	dw TileData_1da66

TileData_1d9db: ; 0x1d9db
	db $01
	dw TileData_1da6e

TileData_1d9de: ; 0x1d9de
	db $01
	dw TileData_1da76

TileData_1d9e1: ; 0x1d9e1
	db $01
	dw TileData_1da7e

TileData_1d9e4: ; 0x1d9e4
	db $01
	dw TileData_1da86

TileData_1d9e7: ; 0x1d9e7
	db $01
	dw TileData_1da8e

TileData_1d9ea: ; 0x1d9ea
	db $01
	dw TileData_1da96

TileData_1d9ed: ; 0x1d9ed
	db $01
	dw TileData_1da9e

TileData_1d9f0: ; 0x1d9f0
	db $01
	dw TileData_1daa6

TileData_1d9f3: ; 0x1d9f3
	db $01
	dw TileData_1daae

TileData_1d9f6: ; 0x1d9f6
	db $01
	dw TileData_1dab6

TileData_1d9f9: ; 0x1d9f9
	db $01
	dw TileData_1dabe

TileData_1d9fc: ; 0x1d9fc
	db $01
	dw TileData_1dac6

TileData_1d9ff: ; 0x1d9ff
	db $01
	dw TileData_1dace

TileData_1da02: ; 0x1da02
	db $01
	dw TileData_1dad6

TileData_1da05: ; 0x1da05
	db $01
	dw TileData_1dade

TileData_1da08: ; 0x1da08
	db $01
	dw TileData_1dae6

TileData_1da0b: ; 0x1da0b
	db $01
	dw TileData_1daee

TileData_1da0e: ; 0x1da0e
	db $01
	dw TileData_1daf6

TileData_1da11: ; 0x1da11
	db $01
	dw TileData_1dafe

TileData_1da14: ; 0x1da14
	db $01
	dw TileData_1db06

TileData_1da17: ; 0x1da17
	db $01
	dw TileData_1db0e

TileData_1da1a: ; 0x1da1a
	db $01
	dw TileData_1db16

TileData_1da1d: ; 0x1da1d
	db $01
	dw TileData_1db1e

TileData_1da20: ; 0x1da20
	db $01
	dw TileData_1db26

TileData_1da23: ; 0x1da23
	db $01
	dw TileData_1db2e

TileData_1da26: ; 0x1da26
	db $01
	dw TileData_1db36

TileData_1da29: ; 0x1da29
	db $01
	dw TileData_1db3e

TileData_1da2c: ; 0x1da2c
	db $01
	dw TileData_1db46

TileData_1da2f: ; 0x1da2f
	db $01
	dw TileData_1db4e

TileData_1da32: ; 0x1da32
	db $01
	dw TileData_1db56

TileData_1da35: ; 0x1da35
	db $01
	dw TileData_1db5e

TileData_1da38: ; 0x1da38
	db $01
	dw TileData_1db66

TileData_1da3b: ; 0x1da3b
	db $01
	dw TileData_1db6e

TileData_1da3e: ; 0x1da3e
	db $01
	dw TileData_1db76

TileData_1da41: ; 0x1da41
	db $01
	dw TileData_1db7e

TileData_1da44: ; 0x1da44
	db $01
	dw TileData_1db86

TileData_1da47: ; 0x1da47
	db $01
	dw TileData_1db8e

TileData_1da4a: ; 0x1da4a
	db $01
	dw TileData_1db96

TileData_1da4d: ; 0x1da4d
	db $01
	dw TileData_1dba5

TileData_1da50: ; 0x1da50
	db $01
	dw TileData_1dbb4

TileData_1da53: ; 0x1da53
	db $01
	dw TileData_1dbc3

TileData_1da56: ; 0x1da56
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $62

	db $00 ; terminator

TileData_1da5e: ; 0x1da5e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $63

	db $00 ; terminator

TileData_1da66: ; 0x1da66
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $64

	db $00 ; terminator

TileData_1da6e: ; 0x1da6e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $65

	db $00 ; terminator

TileData_1da76: ; 0x1da76
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $66

	db $00 ; terminator

TileData_1da7e: ; 0x1da7e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $67

	db $00 ; terminator

TileData_1da86: ; 0x1da86
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $68

	db $00 ; terminator

TileData_1da8e: ; 0x1da8e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $69

	db $00 ; terminator

TileData_1da96: ; 0x1da96
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $6A

	db $00 ; terminator

TileData_1da9e: ; 0x1da9e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $6B

	db $00 ; terminator

TileData_1daa6: ; 0x1daa6
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $58

	db $00 ; terminator

TileData_1daae: ; 0x1daae
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $59

	db $00 ; terminator

TileData_1dab6: ; 0x1dab6
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $5A

	db $00 ; terminator

TileData_1dabe: ; 0x1dabe
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $5B

	db $00 ; terminator

TileData_1dac6: ; 0x1dac6
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $5C

	db $00 ; terminator

TileData_1dace: ; 0x1dace
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $5D

	db $00 ; terminator

TileData_1dad6: ; 0x1dad6
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $5E

	db $00 ; terminator

TileData_1dade: ; 0x1dade
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $5F

	db $00 ; terminator

TileData_1dae6: ; 0x1dae6
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $60

	db $00 ; terminator

TileData_1daee: ; 0x1daee
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $4
	db $61

	db $00 ; terminator

TileData_1daf6: ; 0x1daf6
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $76

	db $00 ; terminator

TileData_1dafe: ; 0x1dafe
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $77

	db $00 ; terminator

TileData_1db06: ; 0x1db06
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $78

	db $00 ; terminator

TileData_1db0e: ; 0x1db0e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $79

	db $00 ; terminator

TileData_1db16: ; 0x1db16
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7A

	db $00 ; terminator

TileData_1db1e: ; 0x1db1e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7B

	db $00 ; terminator

TileData_1db26: ; 0x1db26
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7C

	db $00 ; terminator

TileData_1db2e: ; 0x1db2e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7D

	db $00 ; terminator

TileData_1db36: ; 0x1db36
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7E

	db $00 ; terminator

TileData_1db3e: ; 0x1db3e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $7F

	db $00 ; terminator

TileData_1db46: ; 0x1db46
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $6C

	db $00 ; terminator

TileData_1db4e: ; 0x1db4e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $6D

	db $00 ; terminator

TileData_1db56: ; 0x1db56
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $6E

	db $00 ; terminator

TileData_1db5e: ; 0x1db5e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $6F

	db $00 ; terminator

TileData_1db66: ; 0x1db66
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $70

	db $00 ; terminator

TileData_1db6e: ; 0x1db6e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $71

	db $00 ; terminator

TileData_1db76: ; 0x1db76
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $72

	db $00 ; terminator

TileData_1db7e: ; 0x1db7e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $73

	db $00 ; terminator

TileData_1db86: ; 0x1db86
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $74

	db $00 ; terminator

TileData_1db8e: ; 0x1db8e
	dw LoadTileLists
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $F
	db $75

	db $00 ; terminator

TileData_1db96: ; 0x1db96
	dw LoadTileLists
	db $05 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $24
	db $25, $26, $27

	db $02 ; number of tiles
	dw vBGMap + $44
	db $28, $29

	db $00 ; terminator

TileData_1dba5: ; 0x1dba5
	dw LoadTileLists
	db $05 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $24
	db $2A, $2B, $2C

	db $02 ; number of tiles
	dw vBGMap + $44
	db $2D, $2E

	db $00 ; terminator

TileData_1dbb4: ; 0x1dbb4
	dw LoadTileLists
	db $05 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $2D
	db $27, $26, $2F

	db $02 ; number of tiles
	dw vBGMap + $4E
	db $29, $28

	db $00 ; terminator

TileData_1dbc3: ; 0x1dbc3
	dw LoadTileLists
	db $05 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $2D
	db $2C, $2B, $30

	db $02 ; number of tiles
	dw vBGMap + $4E
	db $2E, $2D

	db $00 ; terminator

ResolvePsyduckPoliwagCollision: ; 0x1dbd2
	ld a, [wWhichPsyduckPoliwag]
	and a
	jp z, Func_1dc8e
	cp $2
	jr z, .asm_1dc33
	xor a
	ld [wWhichPsyduckPoliwag], a
	ld hl, wLeftMapMoveCounter
	ld a, [hl]
	cp $3
	jp z, Func_1dc8e
	inc a
	ld [hl], a
	ld hl, wd4f7
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dc06
	ld a, $54
	ld [wStageCollisionMap + $e3], a
	ld a, $55
	ld [wStageCollisionMap + $103], a
.asm_1dc06
	ld a, $1
	call Func_1de4b
	ld a, [wLeftMapMoveCounter]
	call Func_1de6f
	ld a, [wLeftMapMoveCounter]
	cp $3
	ld a, $7
	callba Func_10000
	ld a, $2
	ld [wd646], a
	ld a, $78
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, $14
	ld [wLeftMapMoveDiglettFrame], a
	jr .asm_1dc8a

.asm_1dc33
	xor a
	ld [wWhichPsyduckPoliwag], a
	ld hl, wRightMapMoveCounter
	ld a, [hl]
	cp $3
	jp z, Func_1dc8e
	inc a
	ld [hl], a
	ld hl, wd4f9
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dc5c
	ld a, $52
	ld [wStageCollisionMap + $f0], a
	ld a, $53
	ld [wStageCollisionMap + $110], a
.asm_1dc5c
	ld a, $3
	call Func_1de4b
	ld a, [wRightMapMoveCounter]
	cp $3
	ld a, $8
	callba Func_10000
	ld a, [wRightMapMoveCounter]
	cp $3
	ccf
	call z, Func_1ddf4
	ld a, $2
	ld [wd645], a
	ld a, $28
	ld [wRightMapMoveDiglettAnimationCounter], a
	ld a, $78
	ld [wRightMapMoveDiglettFrame], a
.asm_1dc8a
	call Func_1de22
	ret

Func_1dc8e: ; 0x1dc8e
	call Func_1dc95
	call Func_1dd2e
	ret

Func_1dc95: ; 0x1dc95
	ld a, [wd646]
	cp $0
	ret z
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_1dceb
	dec a
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, [wd644]
	and a
	ret nz
	ld a, [wLeftMapMoveDiglettFrame]
	cp $1
	jr z, .asm_1dcb9
	cp $0
	ret z
	dec a
	ld [wLeftMapMoveDiglettFrame], a
	ret

.asm_1dcb9
	ld a, [wd646]
	cp $2
	ret nz
	call Func_1130
	ret nz
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1dcd7
	ld a, [wLeftMapMoveCounter]
	cp $0
	jr z, .asm_1dcd4
	ld b, $7
	add b
	jr .asm_1dcd9

.asm_1dcd4
	xor a
	jr .asm_1dcd9

.asm_1dcd7
	ld a, $8
.asm_1dcd9
	call Func_1de6f
	ld a, [wLeftMapMoveCounter]
	cp $3
	ccf
	call z, Func_1ddc7
	ld a, $1
	ld [wd646], a
	ret

.asm_1dceb
	ld a, [wd646]
	cp $1
	ret nz
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	ret nz
	ld a, $0
	call Func_1de4b
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dd0c
	ld a, $5e
	ld [wStageCollisionMap + $e3], a
	ld a, $5f
	ld [wStageCollisionMap + $103], a
.asm_1dd0c
	ld a, $0
	ld [wd646], a
	ld a, [wLeftMapMoveCounter]
	sub $3
	ret nz
	ld a, [wLeftMapMoveCounter]
	sub $3
	ld [wLeftMapMoveCounter], a
	call Func_1de6f
	ld a, $0
	call Func_1de4b
	ld a, $0
	ld [wd646], a
	ret

; XXX
	ret

Func_1dd2e: ; 0x1dd2e
	ld a, [wd645]
	cp $0
	ret z
	cp $1
	jr z, .asm_1dd53
	cp $3
	jr z, .asm_1dd69
	ld a, [wRightMapMoveDiglettAnimationCounter]
	cp $0
	jr z, .asm_1dd48
	dec a
	ld [wRightMapMoveDiglettAnimationCounter], a
	ret

.asm_1dd48
	ld a, $2
	call Func_1de4b
	ld a, $1
	ld [wd645], a
	ret

.asm_1dd53
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_1de6f
	ld a, [wRightMapMoveCounter]
	add $3
	call Func_1de4b
	ld a, $3
	ld [wd645], a
	ret

.asm_1dd69
	ld a, [wRightMapMoveDiglettFrame]
	and a
	jr z, .asm_1dd74
	dec a
	ld [wRightMapMoveDiglettFrame], a
	ret

.asm_1dd74
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1dd89
	ld a, [wRightMapMoveCounter]
	cp $0
	jr z, .asm_1dd85
	ld b, $a
	add b
	jr .asm_1dd8b

.asm_1dd85
	ld a, $4
	jr .asm_1dd8b

.asm_1dd89
	ld a, $9
.asm_1dd8b
	call Func_1de6f
	ld a, $2
	call Func_1de4b
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dda9
	ld a, $24
	ld [wStageCollisionMap + $f0], a
	ld a, $25
	ld [wStageCollisionMap + $110], a
	ld a, $0
	ld [wd645], a
.asm_1dda9
	ld a, [wRightMapMoveCounter]
	sub $3
	ret nz
	ld a, [wRightMapMoveCounter]
	sub $3
	ld [wRightMapMoveCounter], a
	ld a, $4
	call Func_1de6f
	ld a, $2
	call Func_1de4b
	ld a, $0
	ld [wd645], a
	ret

Func_1ddc7: ; 0x1ddc7
	ld hl, wNumPoliwagTriples
	call Increment_Max100
	ld hl, wNumDugtrioTriples
	call Increment_Max100
	jr nc, .asm_1dde4
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_1dde4
	xor a
	ld [wd55a], a
	callba StartMapMoveMode
	scf
	ret

Func_1ddf4: ; 0x1ddf4
	ld hl, wNumPsyduckTriples
	call Increment_Max100
	ld hl, wNumDugtrioTriples
	call Increment_Max100
	jr nc, .asm_1de11
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_1de11
	ld a, $1
	ld [wd55a], a
	callba StartMapMoveMode
	scf
	ret

Func_1de22: ; 0x1de22
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, $55
	ld [wd803], a
	ld a, $4
	ld [wd804], a
	ld a, $2
	ld [wd7eb], a
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $0f
	call PlaySoundEffect
	ret

Func_1de4b: ; 0x1de4b
	ld b, a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, b
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1df66
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1de63
	ld hl, TileDataPointers_1e00f
.asm_1de63
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1df66)
	call Func_10aa
	ret

Func_1de6f: ; 0x1de6f
	ld b, a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, b
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1e0a4
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1de87
	ld hl, TileDataPointers_1e1d6
.asm_1de87
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1e0a4)
	call Func_10aa
	ret

Func_1de93: ; 0x1de93
	ld hl, wd4f7
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1ded2
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1ded2
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_1ded2
	cp $3
	jr z, .asm_1ded2
	dec a
	ld [wLeftMapMoveCounter], a
	call Func_1de6f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1decd
	ld a, [wLeftMapMoveCounter]
	cp $0
	jr z, .asm_1deca
	ld b, $7
	add b
	jr .asm_1decf

.asm_1deca
	xor a
	jr .asm_1decf

.asm_1decd
	ld a, $8
.asm_1decf
	call Func_1de6f
.asm_1ded2
	ld hl, wd4f9
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1df14
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1df14
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_1df14
	cp $3
	jr z, .asm_1df14
	dec a
	ld [wRightMapMoveCounter], a
	add $4
	call Func_1de6f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1df0f
	ld a, [wRightMapMoveCounter]
	cp $0
	jr z, .asm_1df0b
	ld b, $a
	add b
	jr .asm_1df11

.asm_1df0b
	ld a, $4
	jr .asm_1df11

.asm_1df0f
	ld a, $9
.asm_1df11
	call Func_1de6f
.asm_1df14
	ret

Func_1df15: ; 0x1df15
	ld b, $0
	ld hl, wd4f8
	ld a, [hld]
	or [hl]
	jr z, .asm_1df3e
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1df3e
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1df3e
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_1df3e
	cp $3
	jr z, .asm_1df3e
	dec a
	ld [wLeftMapMoveCounter], a
.asm_1df3e
	ld hl, wd4fa
	ld a, [hld]
	or [hl]
	jr z, .asm_1df65
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1df65
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1df65
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_1df65
	cp $3
	jr z, .asm_1df65
	dec a
	ld [wRightMapMoveCounter], a
.asm_1df65
	ret

TileDataPointers_1df66:
	dw TileData_1df74
	dw TileData_1df77
	dw TileData_1df7a
	dw TileData_1df7f
	dw TileData_1df84
	dw TileData_1df89
	dw TileData_1df8e

TileData_1df74: ; 0x1df74
	db $01
	dw TileData_1df93

TileData_1df77: ; 0x1df77
	db $01
	dw TileData_1df9f

TileData_1df7a: ; 0x1df7a
	db $02
	dw TileData_1dfab
	dw TileData_1dfb5

TileData_1df7f: ; 0x1df7f
	db $02
	dw TileData_1dfbf
	dw TileData_1dfc9

TileData_1df84: ; 0x1df84
	db $02
	dw TileData_1dfd3
	dw TileData_1dfdd

TileData_1df89: ; 0x1df89
	db $02
	dw TileData_1dfe7
	dw TileData_1dff1

TileData_1df8e: ; 0x1df8e
	db $02
	dw TileData_1dffb
	dw TileData_1e005

TileData_1df93: ; 0x1df93
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $4A

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $4B

	db $00 ; terminator

TileData_1df9f: ; 0x1df9f
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $4C

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $4D

	db $00 ; terminator

TileData_1dfab: ; 0x1dfab
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageBlueFieldBottomBaseGameBoyGfx + $CE0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfb5: ; 0x1dfb5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageBlueFieldBottomBaseGameBoyGfx + $D10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfbf: ; 0x1dfbf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageBlueFieldBottomBaseGameBoyGfx + $D30
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfc9: ; 0x1dfc9
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageBlueFieldBottomBaseGameBoyGfx + $D60
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfd3: ; 0x1dfd3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $20B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dfdd: ; 0x1dfdd
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $20E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dfe7: ; 0x1dfe7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2100
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dff1: ; 0x1dff1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2130
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dffb: ; 0x1dffb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2150
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e005: ; 0x1e005
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2180
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_1e00f:
	dw TileData_1e01d
	dw TileData_1e020
	dw TileData_1e023
	dw TileData_1e026
	dw TileData_1e029
	dw TileData_1e02c
	dw TileData_1e02f

TileData_1e01d: ; 0x1e01d
	db $01
	dw TileData_1e032

TileData_1e020: ; 0x1e020
	db $01
	dw TileData_1e03e

TileData_1e023: ; 0x1e023
	db $01
	dw TileData_1e04a

TileData_1e026: ; 0x1e026
	db $01
	dw TileData_1e05c

TileData_1e029: ; 0x1e029
	db $01
	dw TileData_1e06e

TileData_1e02c: ; 0x1e02c
	db $01
	dw TileData_1e080

TileData_1e02f: ; 0x1e02f
	db $01
	dw TileData_1e092

TileData_1e032: ; 0x1e032
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $35

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $36

	db $00 ; terminator

TileData_1e03e: ; 0x1e03e
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $37

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $38

	db $00 ; terminator

TileData_1e04a: ; 0x1e04a
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $4F

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $50, $51

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $52, $53

	db $00 ; terminator

TileData_1e05c: ; 0x1e05c
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $54

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $55, $56

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $57, $58

	db $00 ; terminator

TileData_1e06e: ; 0x1e06e
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $59

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $5A, $5B

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $5C, $5D

	db $00 ; terminator

TileData_1e080: ; 0x1e080
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $59

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $5A, $5E

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $5C, $5F

	db $00 ; terminator

TileData_1e092: ; 0x1e092
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $60

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $61, $62

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $63, $64

	db $00 ; terminator

TileDataPointers_1e0a4:
	dw TileData_1e0b8
	dw TileData_1e0bf
	dw TileData_1e0c6
	dw TileData_1e0cd
	dw TileData_1e0d4
	dw TileData_1e0d9
	dw TileData_1e0de
	dw TileData_1e0e3
	dw TileData_1e0e8
	dw TileData_1e0ed

TileData_1e0b8: ; 0x1e0b8
	db $03
	dw TileData_1e0f0
	dw TileData_1e0fa
	dw TileData_1e104

TileData_1e0bf: ; 0x1e0bf
	db $03
	dw TileData_1e10e
	dw TileData_1e118
	dw TileData_1e122

TileData_1e0c6: ; 0x1e0c6
	db $03
	dw TileData_1e12c
	dw TileData_1e136
	dw TileData_1e140

TileData_1e0cd: ; 0x1e0cd
	db $03
	dw TileData_1e14a
	dw TileData_1e154
	dw TileData_1e15e

TileData_1e0d4: ; 0x1e0d4
	db $02
	dw TileData_1e168
	dw TileData_1e172

TileData_1e0d9: ; 0x1e0d9
	db $02
	dw TileData_1e17c
	dw TileData_1e186

TileData_1e0de: ; 0x1e0de
	db $02
	dw TileData_1e190
	dw TileData_1e19a

TileData_1e0e3: ; 0x1e0e3
	db $02
	dw TileData_1e1a4
	dw TileData_1e1ae

TileData_1e0e8: ; 0x1e0e8
	db $02
	dw TileData_1e1b8
	dw TileData_1e1c2

TileData_1e0ed: ; 0x1e0ed
	db $01
	dw TileData_1e1cc

TileData_1e0f0: ; 0x1e0f0
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageBlueFieldBottomBaseGameBoyGfx + $C10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e0fa: ; 0x1e0fa
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageBlueFieldBottomBaseGameBoyGfx + $C40
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e104: ; 0x1e104
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageBlueFieldBottomBaseGameBoyGfx + $C70
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e10e: ; 0x1e10e
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1FC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e118: ; 0x1e118
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2050
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e122: ; 0x1e122
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e12c: ; 0x1e12c
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1FF0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e136: ; 0x1e136
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2050
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e140: ; 0x1e140
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e14a: ; 0x1e14a
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2020
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e154: ; 0x1e154
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2050
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e15e: ; 0x1e15e
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e168: ; 0x1e168
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageBlueFieldBottomBaseGameBoyGfx + $D80
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e172: ; 0x1e172
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageBlueFieldBottomBaseGameBoyGfx + $DA0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e17c: ; 0x1e17c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e186: ; 0x1e186
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e190: ; 0x1e190
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e19a: ; 0x1e19a
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2210
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e1a4: ; 0x1e1a4
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e1ae: ; 0x1e1ae
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2240
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e1b8: ; 0x1e1b8
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageBlueFieldBottomBaseGameBoyGfx + $C40
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e1c2: ; 0x1e1c2
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageBlueFieldBottomBaseGameBoyGfx + $C70
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e1cc: ; 0x1e1cc
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageBlueFieldBottomBaseGameBoyGfx + $D80
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileDataPointers_1e1d6:
	dw TileData_1e1f2
	dw TileData_1e1f5
	dw TileData_1e1f8
	dw TileData_1e1fb
	dw TileData_1e1fe
	dw TileData_1e201
	dw TileData_1e204
	dw TileData_1e207
	dw TileData_1e20a
	dw TileData_1e20d
	dw TileData_1e210
	dw TileData_1e213
	dw TileData_1e216
	dw TileData_1e219
	
TileData_1e1f2: ; 0x1e1f2
	db $01
	dw TileData_1e21c

TileData_1e1f5: ; 0x1e1f5
	db $01
	dw TileData_1e238

TileData_1e1f8: ; 0x1e1f8
	db $01
	dw TileData_1e254

TileData_1e1fb: ; 0x1e1fb
	db $01
	dw TileData_1e270

TileData_1e1fe: ; 0x1e1fe
	db $01
	dw TileData_1e28c

TileData_1e201: ; 0x1e201
	db $01
	dw TileData_1e2a2

TileData_1e204: ; 0x1e204
	db $01
	dw TileData_1e2b8

TileData_1e207: ; 0x1e207
	db $01
	dw TileData_1e2ce

TileData_1e20a: ; 0x1e20a
	db $01
	dw TileData_1e2e4

TileData_1e20d: ; 0x1e20d
	db $01
	dw TileData_1e2fa

TileData_1e210: ; 0x1e210
	db $01
	dw TileData_1e310

TileData_1e213: ; 0x1e213
	db $01
	dw TileData_1e326

TileData_1e216: ; 0x1e216
	db $01
	dw TileData_1e336

TileData_1e219: ; 0x1e219
	db $01
	dw TileData_1e346

TileData_1e21c: ; 0x1e21c
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $36, $37, $38

	db $03 ; number of tiles
	dw vBGMap + $80
	db $39, $3A, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e238: ; 0x1e238
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $3C, $37, $38

	db $03 ; number of tiles
	dw vBGMap + $80
	db $3D, $3E, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $52, $53, $54

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $55, $56, $57

	db $00 ; terminator

TileData_1e254: ; 0x1e254
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $40, $41, $38

	db $03 ; number of tiles
	dw vBGMap + $80
	db $42, $43, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $52, $53, $54

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $55, $56, $57

	db $00 ; terminator

TileData_1e270: ; 0x1e270
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $36, $46, $47

	db $03 ; number of tiles
	dw vBGMap + $80
	db $48, $49, $4A

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $52, $53, $54

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $55, $56, $57

	db $00 ; terminator

TileData_1e28c: ; 0x1e28c
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $67, $68

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $69, $6A, $6B

	db $00 ; terminator

TileData_1e2a2: ; 0x1e2a2
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $6C, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $6D, $6E, $68

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $6F, $70, $6B

	db $00 ; terminator

TileData_1e2b8: ; 0x1e2b8
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $6C, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $72, $68

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $69, $73, $6B

	db $00 ; terminator

TileData_1e2ce: ; 0x1e2ce
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $75, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $76, $77

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $69, $78, $79

	db $00 ; terminator

TileData_1e2e4: ; 0x1e2e4
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $80
	db $3F, $3A, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e2fa: ; 0x1e2fa
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $80
	db $44, $45, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e310: ; 0x1e310
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $80
	db $39, $4B, $4A

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e326: ; 0x1e326
	dw LoadTileLists
	db $06 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $6D, $71, $68

	db $00 ; terminator

TileData_1e336: ; 0x1e336
	dw LoadTileLists
	db $06 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $74, $68

	db $00 ; terminator

TileData_1e346: ; 0x1e346
	dw LoadTileLists
	db $06 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $67, $77

	db $00 ; terminator

ResolveBlueStagePinballUpgradeTriggersCollision: ; 0x1e356
	ld a, [wWhichPinballUpgradeTrigger]
	and a
	jp z, Func_1e471
	xor a
	ld [wWhichPinballUpgradeTrigger], a
	ld a, [wStageCollisionState]
	cp $0
	jr nz, .asm_1e386
	ld a, $1
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ld a, $1
	ld [wd580], a
	callba Func_1404a
.asm_1e386
	ld a, [wStageCollisionState]
	bit 0, a
	jp z, Func_1e471
	ld a, [wd5fc]
	and a
	jp nz, Func_1e471
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $b
	callba Func_10000
	ld a, [wWhichPinballUpgradeTriggerId]
	sub $13
	ld c, a
	ld b, $0
	ld hl, wd5f9
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	jr z, .asm_1e3bf
	ld [hl], $0
.asm_1e3bf
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd5f9
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	jr nz, .asm_1e3de
	lb de, $00, $09
	call PlaySoundEffect
	jp asm_1e475

.asm_1e3de
	ld a, $1
	ld [wd5fc], a
	ld a, $80
	ld [wd5fd], a
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wBallType]
	cp MASTER_BALL
	jr z, .masterBall
	lb de, $06, $3a
	call PlaySoundEffect
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, FieldMultiplierText
	call LoadTextHeader
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgression2BlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .asm_1e465

.masterBall
	lb de, $0f, $4d
	call PlaySoundEffect
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $0100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, DigitsText1to8
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, FieldMultiplierSpecialBonusText
	call LoadTextHeader
.asm_1e465
	callba TransitionPinballUpgrade
	jr asm_1e475

Func_1e471: ; 0x1e471
	call Func_1e4b8
	ret z
asm_1e475: ; 0x1e475
	ld hl, wd5fb
	ld b, $3
.asm_1e47a
	ld a, [hld]
	push hl
	call Func_1e484
	pop hl
	dec b
	jr nz, .asm_1e47a
	ret

Func_1e484: ; 0x1e484
	and a
	jr z, .asm_1e496
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e491
	ld hl, TileDataPointers_1e520
	jr .asm_1e4a3

.asm_1e491
	ld hl, TileDataPointers_1e556
	jr .asm_1e4a3

.asm_1e496
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e4a0
	ld hl, TileDataPointers_1e526
	jr .asm_1e4a3

.asm_1e4a0
	ld hl, TileDataPointers_1e55c
.asm_1e4a3
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $7
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_1e4b8: ; 0x1e4b8
	ld a, [wd5fc]
	and a
	jr z, .asm_1e4e5
	ld a, [wd5fd]
	dec a
	ld [wd5fd], a
	jr nz, .asm_1e4ca
	ld [wd5fc], a
.asm_1e4ca
	and $7
	jr nz, .asm_1e4e3
	ld a, [wd5fd]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_1e4e3
	xor a
	ret

.asm_1e4e5
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .leftFlipperKeyIsPressed
	; left flipper key is pressed
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.leftFlipperKeyIsPressed
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	; right flipper key is pressed
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hl], a
	ret

BallTypeProgression2BlueField: ; 0x1e514
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

BallTypeDegradation2BlueField: ; 0x1e51a
; Determines the previous upgrade for the Ball.
	db POKE_BALL   ; POKE_BALL -> POKE_BALL
	db POKE_BALL   ; unused
	db POKE_BALL   ; GREAT_BALL -> POKE_BALL
	db GREAT_BALL  ; ULTRA_BALL -> GREAT_BALL
	db ULTRA_BALL  ; unused
	db ULTRA_BALL  ; MASTER_BALL -> GREAT_BALL

TileDataPointers_1e520:
	dw TileData_1e52c
	dw TileData_1e533
	dw TileData_1e53a

TileDataPointers_1e526:
	dw TileData_1e541
	dw TileData_1e548
	dw TileData_1e54f

TileData_1e52c: ; 0x1e52c
	db $02, $02
	dw vBGMap + $86
	db $66, $67
	db $00

TileData_1e533: ; 0x1e533
	db $02, $02
	dw vBGMap + $69
	db $66, $67
	db $00

TileData_1e53a: ; 0x1e53a
	db $02, $02
	dw vBGMap + $8C
	db $66, $67
	db $00

TileData_1e541: ; 0x1e541
	db $02, $02
	dw vBGMap + $86
	db $64, $65
	db $00

TileData_1e548: ; 0x1e548
	db $02, $02
	dw vBGMap + $69
	db $64, $65
	db $00

TileData_1e54f: ; 0x1e54f
	db $02, $02
	dw vBGMap + $8C
	db $64, $65
	db $00

TileDataPointers_1e556:
	dw TileData_1e562
	dw TileData_1e569
	dw TileData_1e570

TileDataPointers_1e55c:
	dw TileData_1e577
	dw TileData_1e57e
	dw TileData_1e585

TileData_1e562: ; 0x1e562
	db $02, $02
	dw vBGMap + $86
	db $43, $43
	db $00

TileData_1e569: ; 0x1e569
	db $02, $02
	dw vBGMap + $69
	db $43, $43
	db $00

TileData_1e570: ; 0x1e570
	db $02, $02
	dw vBGMap + $8C
	db $43, $43
	db $00

TileData_1e577: ; 0x1e577
	db $02, $02
	dw vBGMap + $86
	db $42, $42
	db $00

TileData_1e57e: ; 0x1e57e
	db $02, $02
	dw vBGMap + $69
	db $42, $42
	db $00

TileData_1e585: ; 0x1e585
	db $02, $02
	dw vBGMap + $8C
	db $42, $42
	db $00

HandleBlueStageBallTypeUpgradeCounter: ; 0x1e58c
	ld a, [wCapturingMon]
	and a
	ret nz
	; check if counter is at 0
	ld hl, wBallTypeCounter
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	ret z
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	ret nz
	; counter is now 0! Degrade the ball upgrade.
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeDegradation2BlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	and a
	jr z, .pokeball
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
.pokeball
	callba TransitionPinballUpgrade
	ret

Func_1e5c5: ; 0x1e5c5
	ld a, [wWhichCAVELight]
	and a
	jr z, .asm_1e623
	xor a
	ld [wWhichCAVELight], a
	ld a, [wd513]
	and a
	jr nz, .asm_1e623
	ld a, [wWhichCAVELightId]
	sub $16
	ld c, a
	ld b, $0
	ld hl, wd50f
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd50f
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	inc hl
	and [hl]
	jr z, Func_1e627
	ld a, $1
	ld [wd513], a
	ld a, $80
	ld [wd514], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $09
	call PlaySoundEffect
	ld hl, wNumCAVECompletions
	call Increment_Max100
	jr Func_1e627

.asm_1e623
	call Func_1e66a
	ret z
	; fall through

Func_1e627: ; 0x1e627
	ld hl, wd512
	ld b, $4
.asm_1e62c
	ld a, [hld]
	push hl
	call Func_1e636
	pop hl
	dec b
	jr nz, .asm_1e62c
	ret

Func_1e636: ; 0x1e636
	and a
	jr z, .asm_1e648
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e643
	ld hl, TileDataPointers_1e6d7
	jr .asm_1e655

.asm_1e643
	ld hl, TileDataPointers_1e717
	jr .asm_1e655

.asm_1e648
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e652
	ld hl, TileDataPointers_1e6df
	jr .asm_1e655

.asm_1e652
	ld hl, TileDataPointers_1e71f
.asm_1e655
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $7
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_1e66a: ; 0x1e66a
	ld a, [wd513]
	and a
	jr z, .asm_1e6a0
	ld a, [wd514]
	dec a
	ld [wd514], a
	jr nz, .asm_1e687
	ld [wd513], a
	ld a, $1
	ld [wd608], a
	ld a, $3
	ld [wd607], a
	xor a
.asm_1e687
	and $7
	ret nz
	ld a, [wd514]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_1e6a0
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_1e6bc
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.asm_1e6bc
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hl], a
	ret

TileDataPointers_1e6d7:
	dw TileData_1e6e7
	dw TileData_1e6ed
	dw TileData_1e6f3
	dw TileData_1e6f9

TileDataPointers_1e6df:
	dw TileData_1e6ff
	dw TileData_1e705
	dw TileData_1e70b
	dw TileData_1e711

TileData_1e6e7: ; 0x1e6e7
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $121
	db $5E

	db $00 ; terminator

TileData_1e6ed: ; 0x1e6ed
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $123
	db $5E

	db $00 ; terminator

TileData_1e6f3: ; 0x1e6f3
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $130
	db $60

	db $00 ; terminator

TileData_1e6f9: ; 0x1e6f9
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $132
	db $60

	db $00 ; terminator

TileData_1e6ff: ; 0x1e6ff
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $121
	db $5D

	db $00 ; terminator

TileData_1e705: ; 0x1e705
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $123
	db $5D

	db $00 ; terminator

TileData_1e70b: ; 0x1e70b
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $130
	db $5F

	db $00 ; terminator

TileData_1e711: ; 0x1e711
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $132
	db $5F

	db $00 ; terminator

TileDataPointers_1e717:
	dw TileData_1e727
	dw TileData_1e72d
	dw TileData_1e733
	dw TileData_1e739

TileDataPointers_1e71f:
	dw TileData_1e73f
	dw TileData_1e745
	dw TileData_1e74b
	dw TileData_1e751

TileData_1e727: ; 0x1e727
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $121
	db $49

	db $00 ; terminator

TileData_1e72d: ; 0x1e72d
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $123
	db $4A

	db $00 ; terminator

TileData_1e733: ; 0x1e733
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $130
	db $4B

	db $00 ; terminator

TileData_1e739: ; 0x1e739
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $132
	db $4C

	db $00 ; terminator

TileData_1e73f: ; 0x1e73f
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $121
	db $47

	db $00 ; terminator

TileData_1e745: ; 0x1e745
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $123
	db $48

	db $00 ; terminator

TileData_1e74b: ; 0x1e74b
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $130
	db $7A

	db $00 ; terminator

TileData_1e751: ; 0x1e751
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $132
	db $7B

	db $00 ; terminator

Func_1e757: ; 0x1e757
	ld a, [wSlotCollision]
	and a
	jr z, .asm_1e78c
	xor a
	ld [wSlotCollision], a
	ld a, [wd604]
	and a
	ret z
	ld a, [wd603]
	and a
	jr nz, .asm_1e78c
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd549], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $16
	ld [wBallYPos + 1], a
	ld a, $13
	ld [wd603], a
.asm_1e78c
	ld a, [wd603]
	and a
	ret z
	dec a
	ld [wd603], a
	ld a, $18
	ld [wd606], a
	ld a, [wd603]
	cp $12
	jr nz, .asm_1e7b2
	lb de, $00, $21
	call PlaySoundEffect
	callba LoadMiniBallGfx
	ret

.asm_1e7b2
	cp $f
	jr nz, .asm_1e7c1
	callba Func_dd62
	ret

.asm_1e7c1
	cp $c
	jr nz, .asm_1e7d0
	xor a
	ld [wd548], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_1e7d0
	cp $9
	jr nz, .asm_1e7d8
	call Func_1e830
	ret

.asm_1e7d8
	cp $6
	jr nz, .asm_1e7f5
	xor a
	ld [wd604], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	callba LoadMiniBallGfx
	ret

.asm_1e7f5
	cp $3
	jr nz, .asm_1e80e
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	ret

.asm_1e80e
	and a
	ret nz
	call Func_1e8f6
	ld a, [wCatchEmOrEvolutionSlotRewardActive]
	cp CATCHEM_MODE_SLOT_REWARD
	ret nz
	call GenRandom
	and $8
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
	xor a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

Func_1e830: ; 0x1e830
	xor a
	ld [wIndicatorStates + 4], a
	ld a, $d
	callba Func_10000
	jr nc, .asm_1e84b
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ret

.asm_1e84b
	ld a, [wPreviousNumPokeballs]
	cp $3
	jr nz, .asm_1e891
	ld a, [wd607]
	and a
	jr nz, .asm_1e891
.asm_1e858
	ld a, [wBonusStageSlotRewardActive]
	and a
	jr nz, .asm_1e867
	xor a
	ld [wNumPokeballs], a
	ld a, $40
	ld [wPokeballBlinkingCounter], a
.asm_1e867
	xor a
	ld [wBonusStageSlotRewardActive], a
	ld a, $1
	ld [wd495], a
	ld [wd4ae], a
	ld a, [wd498]
	ld c, a
	ld b, $0
	ld hl, GoToBonusStageTextIds_BlueField
	add hl, bc
	ld a, [hl]
	ld [wd497], a
	call Func_1e8c3
	xor a
	ld [wd609], a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ld a, $1e
	ld [wd607], a
	ret

.asm_1e891
	callba Func_ed8e
	xor a
	ld [wd608], a
	ld a, [wd61d]
	cp $d
	jr nc, .asm_1e858
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ld a, [wCatchEmOrEvolutionSlotRewardActive]
	cp EVOLUTION_MODE_SLOT_REWARD
	ret nz
	callba Func_10ab3
	xor a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

Func_1e8c3: ; 0x1e8c3
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld a, [wd497]
	ld de, GoToMeowthStageText
	cp STAGE_MEOWTH_BONUS
	jr z, .loadText
	ld de, GoToSeelStageText
	cp STAGE_SEEL_BONUS
	jr z, .loadText
	ld de, GoToMewtwoStageText
.loadText
	call LoadTextHeader
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $3c, $23
	call PlaySoundEffect
	ret

GoToBonusStageTextIds_BlueField:
	db STAGE_GENGAR_BONUS
	db STAGE_MEWTWO_BONUS
	db STAGE_MEOWTH_BONUS
	db STAGE_DIGLETT_BONUS
	db STAGE_SEEL_BONUS

Func_1e8f6: ; 0x1e8f6
	ld a, [wCurrentStage]
	and $1
	sla a
	ld c, a
	ld a, [wd604]
	add c
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1e91e
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1e912
	ld hl, TileDataPointers_1e970
.asm_1e912
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1e91e)
	call Func_10aa
	ret

TileDataPointers_1e91e:
	dw TileData_1e926
	dw TileData_1e929
	dw TileData_1e92c
	dw TileData_1e931

TileData_1e926: ; 0x1e926
	db $01
	dw TileData_1e936

TileData_1e929: ; 0x1e929
	db $01
	dw TileData_1e93f

TileData_1e92c: ; 0x1e92c
	db $02
	dw TileData_1e948
	dw TileData_1e952

TileData_1e931: ; 0x1e931
	db $02
	dw TileData_1e95c
	dw TileData_1e966

TileData_1e936: ; 0x1e936
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $EE, $EF

	db $00 ; terminator

TileData_1e93f: ; 0x1e93f
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $F0, $F1

	db $00 ; terminator

TileData_1e948: ; 0x1e948
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1F
	dw StageBlueFieldBottomBaseGameBoyGfx + $9F0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e952: ; 0x1e952
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $21
	dw StageBlueFieldBottomBaseGameBoyGfx + $A10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e95c: ; 0x1e95c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1BC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e966: ; 0x1e966
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $21
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1BE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_1e970:
	dw TileData_1e978
	dw TileData_1e97d
	dw TileData_1e980
	dw TileData_1e983

TileData_1e978: ; 0x1e978
	db $02
	dw TileData_1e986
	dw TileData_1e98F

TileData_1e97d: ; 0x1e97d
	db $01
	dw TileData_1e99b

TileData_1e980: ; 0x1e980
	db $01
	dw TileData_1e9a4

TileData_1e983: ; 0x1e983
	db $01
	dw TileData_1e9b2

TileData_1e986: ; 0x1e986
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $F0, $F1

	db $00 ; terminator

TileData_1e98F: ; 0x1e98F
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $224
	db $D8

	db $01 ; number of tiles
	dw vBGMap + $22f
	db $EC

	db $00 ; terminator

TileData_1e99b: ; 0x1e99b
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $F2, $F3

	db $00 ; terminator

TileData_1e9a4: ; 0x1e9a4
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $9809
	db $15, $16

	db $02 ; terminator
	dw vBGMap + $29
	db $17, $18

	db $00 ; terminator

TileData_1e9b2: ; 0x1e9b2
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $9
	db $19, $1A

	db $02 ; terminator
	dw vBGMap + $29
	db $1B, $1C

	db $00 ; terminator

Func_1e9c0: ; 0x1e9c0
	ld a, [wd607]
	and a
	ret z
	dec a
	ld [wd607], a
	ret nz
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wd609]
	and a
	jr z, .asm_1e9dc
	ld a, [wd498]
	add $15
	jr .asm_1e9e3

.asm_1e9dc
	ld a, [wd608]
	and a
	ret z
	ld a, $1a
.asm_1e9e3
	ld hl, wCurrentStage
	bit 0, [hl]
	callba nz, LoadBillboardTileData
	ld a, [wd604]
	and a
	ret nz
	ld a, $1
	ld [wd604], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	call nz, Func_1e8f6
	ret

Func_1ea0a: ; 0x1ea0a
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $fe
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jr asm_1ea6a

Func_1ea3b: ; 0x1ea3b
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $86
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	; fall through

asm_1ea6a: ; 0x1ea6a
	ld bc, BallPhysicsData_f0000
	add hl, bc
	ld de, wBallXVelocity
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1eaa9
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1eaa9
	pop hl
	bit 7, h
	jr z, .asm_1eab5
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1eab5
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	lb de, $00, $04
	call PlaySoundEffect
	ret

Func_1ead4: ; 0x1ead4
	ld a, [hNumFramesDropped]
	and $f
	ret nz
	ld bc, $0000
.asm_1eadc
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	cp $1
	jr z, .asm_1eaf8
	bit 7, [hl]
	jr z, .asm_1eaf8
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 4, [hl]
	jr z, .asm_1eaf5
	inc a
.asm_1eaf5
	call Func_1eb41
.asm_1eaf8
	pop bc
	inc c
	ld a, c
	cp $2
	jr nz, .asm_1eadc
	ld a, [hNumFramesDropped]
	and $f
	ret nz
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld bc, $0002
.asm_1eb0d
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	cp $1
	jr z, .asm_1eb29
	bit 7, [hl]
	jr z, .asm_1eb29
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 4, [hl]
	jr z, .asm_1eb2b
	inc a
	inc a
	jr .asm_1eb2b

.asm_1eb29
	ld a, $0
.asm_1eb2b
	push af
	ld hl, wd648
	add hl, bc
	dec hl
	dec hl
	ld a, [hl]
	ld d, a
	pop af
	add d
	call Func_1eb41
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_1eb0d
	ret

Func_1eb41: ; 0x1eb41
	push af
	sla c
	ld hl, TileDataPointers_1eb61
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1eb4f
	ld hl, TileDataPointers_1ed51
.asm_1eb4f
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_1eb61)
	call Func_10aa
	ret

TileDataPointers_1eb61:
	dw TileDataPointers_1eb6b
	dw TileDataPointers_1eb75
	dw TileDataPointers_1eb7f
	dw TileDataPointers_1eb87
	dw TileDataPointers_1eb8f

TileDataPointers_1eb6b: ; 0x1eb6b
	dw TileData_1eb97
	dw TileData_1eb9a
	dw TileData_1eb9d
	dw TileData_1eba0
	dw TileData_1eba3

TileDataPointers_1eb75: ; 0x1eb75
	dw TileData_1eba6
	dw TileData_1eba9
	dw TileData_1ebac
	dw TileData_1ebaf
	dw TileData_1ebb2

TileDataPointers_1eb7f: ; 0x1eb7f
	dw TileData_1ebb5
	dw TileData_1ebb8
	dw TileData_1ebbb
	dw TileData_1ebbe

TileDataPointers_1eb87: ; 0x1eb87
	dw TileData_1ebc1
	dw TileData_1ebc6
	dw TileData_1ebcb
	dw TileData_1ebd0

TileDataPointers_1eb8f: ; 0x1eb8f
	dw TileData_1ebd5
	dw TileData_1ebda
	dw TileData_1ebdf
	dw TileData_1ebe4

TileData_1eb97: ; 0x1eb97
	db $01
	dw TileData_1ebe9

TileData_1eb9a: ; 0x1eb9a
	db $01
	dw TileData_1ebf9

TileData_1eb9d: ; 0x1eb9d
	db $01
	dw TileData_1ec09

TileData_1eba0: ; 0x1eba0
	db $01
	dw TileData_1ec19

TileData_1eba3: ; 0x1eba3
	db $01
	dw TileData_1ec29

TileData_1eba6: ; 0x1eba6
	db $01
	dw TileData_1ec39

TileData_1eba9: ; 0x1eba9
	db $01
	dw TileData_1ec49

TileData_1ebac: ; 0x1ebac
	db $01
	dw TileData_1ec59

TileData_1ebaf: ; 0x1ebaf
	db $01
	dw TileData_1ec69

TileData_1ebb2: ; 0x1ebb2
	db $01
	dw TileData_1ec79

TileData_1ebb5: ; 0x1ebb5
	db $01
	dw TileData_1ec89

TileData_1ebb8: ; 0x1ebb8
	db $01
	dw TileData_1ec93

TileData_1ebbb: ; 0x1ebbb
	db $01
	dw TileData_1ec9d

TileData_1ebbe: ; 0x1ebbe
	db $01
	dw TileData_1eca7

TileData_1ebc1: ; 0x1ebc1
	db $02
	dw TileData_1ecb1
	dw TileData_1ecbb

TileData_1ebc6: ; 0x1ebc6
	db $02
	dw TileData_1ecc5
	dw TileData_1eccf

TileData_1ebcb: ; 0x1ebcb
	db $02
	dw TileData_1ecd9
	dw TileData_1ece3

TileData_1ebd0: ; 0x1ebd0
	db $02
	dw TileData_1eced
	dw TileData_1ecf7

TileData_1ebd5: ; 0x1ebd5
	db $02
	dw TileData_1ed01
	dw TileData_1ed0b

TileData_1ebda: ; 0x1ebda
	db $02
	dw TileData_1ed15
	dw TileData_1ed1f

TileData_1ebdf: ; 0x1ebdf
	db $02
	dw TileData_1ed01
	dw TileData_1ed0b

TileData_1ebe4: ; 0x1ebe4
	db $02
	dw TileData_1ed15
	dw TileData_1ed1f

TileData_1ebe9: ; 0x1ebe9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3D

	db $01 ; number of tiles
	dw vBGMap + $84
	db $17

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ebf9: ; 0x1ebf9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3E

	db $01 ; number of tiles
	dw vBGMap + $84
	db $17

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ec09: ; 0x1ec09
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3E

	db $01 ; number of tiles
	dw vBGMap + $84
	db $18

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ec19: ; 0x1ec19
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3E

	db $01 ; number of tiles
	dw vBGMap + $84
	db $18

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3E

	db $00 ; terminator

TileData_1ec29: ; 0x1ec29
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3D

	db $01 ; number of tiles
	dw vBGMap + $84
	db $18

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ec39: ; 0x1ec39
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $3F

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1D

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $3F

	db $00 ; terminator

TileData_1ec49: ; 0x1ec49
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1D

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $3F

	db $00 ; terminator

TileData_1ec59: ; 0x1ec59
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1E

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $3F

	db $00 ; terminator

TileData_1ec69: ; 0x1ec69
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1E

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $40

	db $00 ; terminator

TileData_1ec79: ; 0x1ec79
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1D

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $40

	db $00 ; terminator

TileData_1ec89: ; 0x1ec89
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageBlueFieldBottomBaseGameBoyGfx + $950
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ec93: ; 0x1ec93
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1F40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ec9d: ; 0x1ec9d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1F60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1eca7: ; 0x1eca7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1F80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ecb1: ; 0x1ecb1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageBlueFieldBottomBaseGameBoyGfx + $990
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ecbb: ; 0x1ecbb
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageBlueFieldBottomBaseGameBoyGfx + $9B0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ecc5: ; 0x1ecc5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2270
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1eccf: ; 0x1eccf
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2290
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ecd9: ; 0x1ecd9
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $22B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ece3: ; 0x1ece3
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $22D0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1eced: ; 0x1eced
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $22F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ecf7: ; 0x1ecf7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2310
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed01: ; 0x1ed01
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageBlueFieldBottomBaseGameBoyGfx + $A30
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ed0b: ; 0x1ed0b
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageBlueFieldBottomBaseGameBoyGfx + $A50
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ed15: ; 0x1ed15
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed1f: ; 0x1ed1f
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed29: ; 0x1ed29
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed33: ; 0x1ed33
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e3d: ; 0x1e3d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed47: ; 0x1ed47
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1CA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_1ed51: ; 0x1ed51
	dw TileDataPointers_1ed5b
	dw TileDataPointers_1ed65
	dw TileDataPointers_1ed6f
	dw TileDataPointers_1ed77
	dw TileDataPointers_1ed7f

TileDataPointers_1ed5b: ; 0x1ed5b
	dw TileData_1ed87
	dw TileData_1ed8a
	dw TileData_1ed8d
	dw TileData_1ed90
	dw TileData_1ed93

TileDataPointers_1ed65: ; 0x1ed65
	dw TileData_1ed96
	dw TileData_1ed99
	dw TileData_1ed9c
	dw TileData_1ed9f
	dw TileData_1eda2

TileDataPointers_1ed6f: ; 0x1ed6f
	dw TileData_1eda5
	dw TileData_1eda8
	dw TileData_1edab
	dw TileData_1edae

TileDataPointers_1ed77: ; 0x1ed77
	dw TileData_1edb1
	dw TileData_1edb4
	dw TileData_1edb7
	dw TileData_1edba

TileDataPointers_1ed7f: ; 0x1ed7f
	dw TileData_1edbd
	dw TileData_1edc0
	dw TileData_1edc3
	dw TileData_1edc6

TileData_1ed87: ; 0x1ed87
	db $01
	dw TileData_1edc9

TileData_1ed8a: ; 0x1ed8a
	db $01
	dw TileData_1edd9

TileData_1ed8d: ; 0x1ed8d
	db $01
	dw TileData_1ede9

TileData_1ed90: ; 0x1ed90
	db $01
	dw TileData_1edf9

TileData_1ed93: ; 0x1ed93
	db $01
	dw TileData_1ee09

TileData_1ed96: ; 0x1ed96
	db $01
	dw TileData_1ee19

TileData_1ed99: ; 0x1ed99
	db $01
	dw TileData_1ee29

TileData_1ed9c: ; 0x1ed9c
	db $01
	dw TileData_1ee39

TileData_1ed9f: ; 0x1ed9f
	db $01
	dw TileData_1ee49

TileData_1eda2: ; 0x1eda2
	db $01
	dw TileData_1ee59

TileData_1eda5: ; 0x1eda5
	db $01
	dw TileData_1ee69

TileData_1eda8: ; 0x1eda8
	db $01
	dw TileData_1ee75

TileData_1edab: ; 0x1edab
	db $01
	dw TileData_1ee81

TileData_1edae: ; 0x1edae
	db $01
	dw TileData_1ee8d

TileData_1edb1: ; 0x1edb1
	db $01
	dw TileData_1ee99

TileData_1edb4: ; 0x1edb4
	db $01
	dw TileData_1eea7

TileData_1edb7: ; 0x1edb7
	db $01
	dw TileData_1eeb5

TileData_1edba: ; 0x1edba
	db $01
	dw TileData_1eec3

TileData_1edbd: ; 0x1edbd
	db $01
	dw TileData_1eed1

TileData_1edc0: ; 0x1edc0
	db $01
	dw TileData_1eedf

TileData_1edc3: ; 0x1edc3
	db $01
	dw TileData_1eeed

TileData_1edc6: ; 0x1edc6
	db $01
	dw TileData_1eefb

TileData_1edc9: ; 0x1edc9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $31

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0D

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1edd9: ; 0x1edd9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $32

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0D

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1ede9: ; 0x1ede9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $32

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0E

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1edf9: ; 0x1edf9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $32

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0E

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7D

	db $00 ; terminator

TileData_1ee09: ; 0x1ee09
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $31

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0E

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1ee19: ; 0x1ee19
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $33

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $0F

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee29: ; 0x1ee29
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $34

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $0F

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee39: ; 0x1ee39
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $34

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $10

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee49: ; 0x1ee49
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $34

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $10

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7F

	db $00 ; terminator

TileData_1ee59: ; 0x1ee59
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $33

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $10

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee69: ; 0x1ee69
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $05

	db $01 ; number of tiles
	dw vBGMap + $68
	db $06

	db $00 ; terminator

TileData_1ee75: ; 0x1ee75
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $07

	db $01 ; number of tiles
	dw vBGMap + $68
	db $08

	db $00 ; terminator

TileData_1ee81: ; 0x1ee81
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $09

	db $01 ; number of tiles
	dw vBGMap + $68
	db $0A

	db $00 ; terminator

TileData_1ee8d: ; 0x1ee8d
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $0B

	db $01 ; number of tiles
	dw vBGMap + $68
	db $0C

	db $00 ; terminator

TileData_1ee99: ; 0x1ee99
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $26, $27

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $28, $29

	db $00 ; terminator

TileData_1eea7: ; 0x1eea7
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $2A, $2B

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $2C, $2D

	db $00 ; terminator

TileData_1eeb5: ; 0x1eeb5
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $2E, $2F

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $30, $31

	db $00 ; terminator

TileData_1eec3: ; 0x1eec3
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $32, $33

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $34, $35

	db $00 ; terminator

TileData_1eed1: ; 0x1eed1
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $16, $17

	db $02 ; number of tiles
	dw vBGMap + $69
	db $18, $19

	db $00 ; terminator

TileData_1eedf: ; 0x1eedf
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $1A, $1B

	db $02 ; number of tiles
	dw vBGMap + $69
	db $1C, $1D

	db $00 ; terminator

TileData_1eeed: ; 0x1eeed
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $1E, $1F

	db $02 ; number of tiles
	dw vBGMap + $69
	db $20, $21

	db $00 ; terminator

TileData_1eefb: ; 0x1eefb
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $22, $23

	db $02 ; number of tiles
	dw vBGMap + $69
	db $24, $25

	db $00 ; terminator

ResolveBlueStageForceFieldCollision: ; 0x1ef09
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jp z, Func_1ef20
	cp $1  ; right direction
	jp z, Func_1ef4d
	cp $2  ; down direction
	jp z, Func_1ef7e
	cp $3  ; left direction
	jp z, Func_1efae
	; fall through
	; default to upward forcefield

Func_1ef20: ; 0x1ef20
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jp Func_1efdc

Func_1ef4d: ; 0x1ef4d
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld a, $30
	sub c
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jp Func_1efdc

Func_1ef7e: ; 0x1ef7e
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, a
	ld a, $30
	sub c
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jr Func_1efdc

Func_1efae: ; 0x1efae
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, a
	ld a, $30
	sub c
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	; fall through
Func_1efdc: ; 0x1efdc
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jp z, Func_1eff3
	cp $1  ; right direction
	jp z, Func_1f0be
	cp $2  ; down direction
	jp z, Func_1f057
	cp $3  ; left direction
	jp z, Func_1f124
	; fall through
	; default to upward forcefield

Func_1eff3:  ; 0x1eff3
	ld bc, BallPhysicsData_ec000
	add hl, bc
	ld de, wBallXVelocity
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f032
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f032
	pop hl
	bit 7, h
	jr z, .asm_1f03e
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f03e
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f057: ; 0x1f057
	ld bc, BallPhysicsData_ec000
	add hl, bc
	ld de, wBallXVelocity
	bit 2, l
	ret nz
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	sub c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	sbc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f099
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f099
	pop hl
	bit 7, h
	jr z, .asm_1f0a5
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f0a5
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f0be: ; 0x1f0be
	ld bc, BallPhysicsData_ec000
	add hl, bc
	ld de, wBallYVelocity
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc hl
	push bc
	dec de
	dec de
	dec de
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	sub c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	sbc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f0ff
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f0ff
	pop hl
	bit 7, h
	jr z, .asm_1f10b
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f10b
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f124: ; 0x1f124
	ld bc, BallPhysicsData_ec000
	add hl, bc
	ld de, wBallYVelocity
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	sub c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	sbc b
	ld [de], a
	inc hl
	push bc
	dec de
	dec de
	dec de
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f165
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f165
	pop hl
	bit 7, h
	jr z, .asm_1f171
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f171
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f18a: ; 0x1f18a
	ld a, [wBlueStageForceFieldGfxNeedsLoading]
	cp $0
	jr z, .asm_1f1b4
	ld a, [wBlueStageForceFieldDirection]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1f1b5
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1f1a4
	ld hl, TileDataPointers_1f201
.asm_1f1a4
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1f1b5)
	call Func_10aa
	ld a, $0
	ld [wBlueStageForceFieldGfxNeedsLoading], a
.asm_1f1b4
	ret

TileDataPointers_1f1b5:
	dw TileData_1f1bd
	dw TileData_1f1c0
	dw TileData_1f1c3
	dw TileData_1f1c6

TileData_1f1bd: ; 0x1f1bd
	db $01
	dw TileData_1f1c9

TileData_1f1c0: ; 0x1f1c0
	db $01
	dw TileData_1f1d7

TileData_1f1c3: ; 0x1f1c3
	db $01
	dw TileData_1f1e5

TileData_1f1c6: ; 0x1f1c6
	db $01
	dw TileData_1f1f3

TileData_1f1c9: ; 0x1f1c9
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $189
	db $70, $71

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $72, $73

	db $00 ; terminator

TileData_1f1d7: ; 0x1f1d7
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $189
	db $74, $75

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $76, $77

	db $00 ; terminator

TileData_1f1e5: ; 0x1f1e5
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $189
	db $78, $79

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $7A, $7B

	db $00 ; terminator

TileData_1f1f3: ; 0x1f1f3
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $189
	db $7C, $7D

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $7E, $7F

	db $00 ; terminator

TileDataPointers_1f201:
	dw TileData_1f209
	dw TileData_1f20c
	dw TileData_1f20f
	dw TileData_1f212

TileData_1f209: ; 0x1f209
	db $01
	dw TileData_1f215

TileData_1f20c: ; 0x1f20c
	db $01
	dw TileData_1f228

TileData_1f20f: ; 0x1f20f
	db $01
	dw TileData_1f23b

TileData_1f212: ; 0x1f212
	db $01
	dw TileData_1f24e

TileData_1f215: ; 0x1f215
	dw LoadTileLists
	db $06 ; total number of tiles

	db $02 ; number of otiles
	dw vBGMap + $189
	db $6C, $6D

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $6E, $6F

	db $02
	dw vBGMap + $1c9
	db $70, $71

	db $00 ; terminator

TileData_1f228: ; 0x1f228
	dw LoadTileLists
	db $06 ; total number of tiles

	db $02 ; number of otiles
	dw vBGMap + $189
	db $72, $80

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $73, $74

	db $02
	dw vBGMap + $1c9
	db $75, $80

	db $00 ; terminator

TileData_1f23b: ; 0x1f23b
	dw LoadTileLists
	db $06 ; total number of tiles

	db $02 ; number of otiles
	dw vBGMap + $189
	db $76, $77

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $78, $79

	db $02
	dw vBGMap + $1c9
	db $7A, $7B

	db $00 ; terminator

TileData_1f24e: ; 0x1f24e
	dw LoadTileLists
	db $06 ; total number of tiles

	db $02 ; number of otiles
	dw vBGMap + $189
	db $80, $7C

	db $02 ; number of tiles
	dw vBGMap + $1a9
	db $7D, $7E

	db $02
	dw vBGMap + $1c9
	db $80, $7F

	db $00 ; terminator

Func_1f261: ; 0x1f261
	call Func_1f27b
	ret nc
	; fall through

Func_1f265: ; 0x1f265
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1f2b9
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $7
	ld de, LoadTileLists
	call Func_10c5
	ret

Func_1f27b: ; 0x1f27b
	ld a, [wPreviousNumPokeballs]
	ld hl, wNumPokeballs
	cp [hl]
	ret z
	ld a, [wPokeballBlinkingCounter]
	dec a
	ld [wPokeballBlinkingCounter], a
	jr nz, .asm_1f2a5
	ld a, [wNumPokeballs]
	ld [wPreviousNumPokeballs], a
	cp $3
	jr c, .asm_1f2a0
	ld a, $1
	ld [wd609], a
	ld a, $3
	ld [wd607], a
.asm_1f2a0
	ld a, [wPreviousNumPokeballs]
	scf
	ret

.asm_1f2a5
	and $7
	ret nz
	ld a, [wPokeballBlinkingCounter]
	bit 3, a
	jr nz, .asm_1f2b4
	ld a, [wPreviousNumPokeballs]
	scf
	ret

.asm_1f2b4
	ld a, [wNumPokeballs]
	scf
	ret

TileDataPointers_1f2b9:
	dw TileData_1f2c1
	dw TileData_1f2cc
	dw TileData_1f2d7
	dw TileData_1f2e2

TileData_1f2c1: ; 0x1f2c1
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw vBGMap + $107
	db $B0, $B1, $B0, $B1, $B0, $B1

	db $00 ; terminator

TileData_1f2cc: ; 0x1f2cc
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw vBGMap + $107
	db $AE, $AF, $B0, $B1, $B0, $B1

	db $00 ; terminator

TileData_1f2d7: ; 0x1f2d7
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw vBGMap + $107
	db $AE, $AF, $AE, $AF, $B0, $B1

	db $00 ; terminator

TileData_1f2e2: ; 0x1f2e2
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw vBGMap + $107
	db $AE, $AF, $AE, $AF, $AE, $AF

	db $00 ; terminator

Func_1f2ed: ; 0x1f2ed
	xor a
	ld [wd604], a
	ld [wIndicatorStates + 4], a
	ld [hFarCallTempA], a
	ld a, Bank(Func_1e8f6)  ; this is in the same bank...
	ld hl, Func_1e8f6
	call BankSwitch
	ret

Func_1f2ff: ; 0x1f2ff
	ld a, [wLeftAlleyCount]
	cp $3
	jr c, .asm_1f30b
	ld a, $80
	ld [wIndicatorStates + 2], a
.asm_1f30b
	ld a, [wLeftAlleyCount]
	cp $3
	jr z, .asm_1f314
	set 7, a
.asm_1f314
	ld [wIndicatorStates], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .asm_1f323
	ld a, $80
	ld [wIndicatorStates + 3], a
.asm_1f323
	ld a, [wRightAlleyCount]
	cp $3
	jr z, .asm_1f32c
	set 7, a
.asm_1f32c
	ld [wIndicatorStates + 1], a
	ret
