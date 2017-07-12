ResolveBlueFieldTopGameObjectCollisions: ; 0x1c715
	call ResolveShellderCollision
	call ResolveBlueStageSpinnerCollision
	call ResolveBallUpgradeTriggersCollision_BlueField
	call UpdateBallTypeUpgradeCounter_BlueField
	call UpdateCAVELightsBlinking_BlueField
	call ResolveBlueStageBoardTriggerCollision
	call ResolveBlueStagePikachuCollision
	call ResolveSlowpokeCollision
	call ResolveCloysterCollision
	call ApplySlotForceField_BlueFieldTop
	call ResolvePsyduckPoliwagCollision
	call ResolveForceFieldCollision
	call OpenSlotCave_BlueField
	call UpdateForceFieldDirection
	call UpdateForceFieldGraphics
	callba UpdateBallSaverState
	call UpdateBlinkingPokeballs_BlueField
	call UpdateMapMoveCounters_BlueFieldTop
	callba ShowExtraBallMessage
	ld a, $0
	callba CheckSpecialModeColision
	ret

ResolveBlueFieldBottomGameObjectCollisions: ; 0x1c769
	call ResolveWildMonCollision_BlueField
	call ResolveBumpersCollision_BlueField
	call ResolvePsyduckPoliwagCollision
	call UpdateBlueStageSpinner
	call UpdatePinballUpgradeBlinkingAnimation_BlueField
	call UpdateBallTypeUpgradeCounter_BlueField
	call ResolveCAVELightCollision_BlueField
	call ResolveBlueStagePinballLaunchCollision
	call ResolveBlueStagePikachuCollision
	call UpdateArrowIndicators_BlueField
	call ResolveBonusMultiplierCollision_BlueField
	call ResolveSlotCollision_BlueField
	call OpenSlotCave_BlueField
	call ApplySlotForceField_BlueFieldBottom
	call UpdateForceFieldDirection
	callba UpdateAgainText
	callba UpdateBallSaver
	call UpdatePokeballs_BlueField
	call UpdateMapMoveCounters_BlueFieldBottom
	callba ShowExtraBallMessage
	ld a, $0
	callba CheckSpecialModeColision
	ret

InitBlueFieldCollisionAttributes: ; 0x1c7c7
	ld a, $0
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ret

ResolveBlueStagePinballLaunchCollision: ; 0x1c7d7
	ld a, [wPinballLaunchCollision]
	and a
	ret z
	xor a
	ld [wPinballLaunchCollision], a ; set to 0, so we only check for a launch once per frame
	ld a, [wPinballLaunched]
	and a
	jr z, .dontLaunch
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
	ld [wEnableBallGravityAndTilt], a
	lb de, $00, $0a
	call PlaySoundEffect
.dontLaunch
	ld a, $ff
	ld [wPreviousTriggeredGameObject], a
	ld a, [wPinballLaunched]
	and a
	ret nz
	ld a, [wChoseInitialMap]
	and a
	jr nz, .checkPressedKeysToLaunchBall
	call ChooseInitialMap_BlueField
	ld a, $1
	ld [wChoseInitialMap], a
	ld [wPinballLaunched], a
	ret

.checkPressedKeysToLaunchBall
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	ret z
	ld a, $1
	ld [wPinballLaunched], a
	ret

ChooseInitialMap_BlueField: ; 0x1c839
; While waiting to launch the pinball, this quickly rotates the billboard with the initial
; maps the player can start on.
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
	callba Delay1Frame
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
	callba LoadScrollingMapNameText
	ld a, [wCurrentMap]
	ld [wVisitedMaps], a
	xor a
	ld [wNumMapMoves], a
	ret

BlueStageInitialMaps: ; 0x1c8af
	db VIRIDIAN_CITY
	db VIRIDIAN_FOREST
	db MT_MOON
	db CERULEAN_CITY
	db VERMILION_STREETS
	db ROCK_MOUNTAIN
	db CELADON_CITY

UpdateForceFieldDirection: ; 0x1c8b6
; Every 5 seconds, decide which way the force field (in between slowpoke and cloyster) should point.
	ld a, [wBlueFieldForceFieldFrameCounter]
	inc a
	cp 60
	jr z, .oneSecond
	ld [wBlueFieldForceFieldFrameCounter], a
	ret

.oneSecond
	xor a
	ld [wBlueFieldForceFieldFrameCounter], a
	ld hl, wBlueFieldForceFieldSecondsCounter
	inc [hl]
	ld a, [hl]
	cp 5
	ret nz
	; This code is reached exactly once every 5 seconds
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
	ld [wBlueFieldForceFieldSecondsCounter], a
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
	ld a, [wMapMoveDirection]
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
	ld a, [wMapMoveDirection]
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
	call ApplyShellderCollision
	ld a, [wBlueStageForceFieldFlippedDown]
	and a
	jr nz, .forceFieldPointingCorrectDirection
	ld a, $1
	ld [wBlueStageForceFieldFlippedDown], a
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jr nz, .forceFieldPointingCorrectDirection
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wBlueStageForceFieldGfxNeedsLoading], a
	ld a, $3
	ld [wBlueFieldForceFieldFrameCounter], a
	ld [wBlueFieldForceFieldSecondsCounter], a
.forceFieldPointingCorrectDirection
	ld a, $10
	ld [wShellderHitAnimationDuration], a
	ld a, [wWhichShellderId]
	sub $3
	ld [wWhichAnimatedShellder], a
	ld a, $4
	callba CheckSpecialModeColision
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.noCollision
	ld a, [wShellderHitAnimationDuration]
	and a
	ret z
	dec a
	ld [wShellderHitAnimationDuration], a
	ret nz
	ld a, $ff
	ld [wWhichAnimatedShellder], a
	ret

ApplyShellderCollision: ; 0x1ca29
	ld a, $ff
	ld [wRumblePattern], a
	ld a, $3
	ld [wRumbleDuration], a
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

ResolveWildMonCollision_BlueField: ; 0x1ca4a
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
	jr z, UpdateBlueStageSpinner
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
	callba CheckSpecialModeColision
	; fall through

UpdateBlueStageSpinner: ; 0x1ca85
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
	call PlaySpinnerChargingSoundEffect_BlueField
	ret

.asm_1caff
	inc a
	ld [wPikachuSaverCharge], a
	call PlaySpinnerChargingSoundEffect_BlueField
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_1cb12
	ld a, $64
	ld [wd51e], a
.asm_1cb12
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	call UpdateSpinnerChargeGraphics_BlueField
	ret

PlaySpinnerChargingSoundEffect_BlueField: ; 0x1cb1c
	ld a, [wd51e]
	and a
	ret nz
	ld a, [wPikachuSaverCharge]
	ld c, a
	ld b, $0
	ld hl, SpinnerChargingSoundEffectIds_BlueField
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

SpinnerChargingSoundEffectIds_BlueField:
	db $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $11

UpdateSpinnerChargeGraphics_BlueField: ; 0x1cb43
; Loads the correct graphics that show the lightning bolt icon for the spinner's current charge.
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
	call QueueGraphicsToLoad
	ret

INCLUDE "data/queued_tiledata/blue_field/spinner.asm"

ResolveBumpersCollision_BlueField: ; 1ce40
	ld a, [wWhichBumper]
	and a
	jr z, .noNewCollision
	call LoadBumpersGraphics_BlueField
	call LightUpBumper_BlueField
	xor a
	ld [wWhichBumper], a
	call ApplyBumperCollision_BlueField
.noNewCollision
	ld a, [wBumperLightUpDuration]
	and a
	ret z
	dec a
	ld [wBumperLightUpDuration], a
	call z, LoadBumpersGraphics_BlueField
	ret

LightUpBumper_BlueField: ; 0x1ce60
; Makes the hit bumper light briefly
	ld a, 16
	ld [wBumperLightUpDuration], a
	ld a, [wWhichBumperId]
	sub $1
	ld [wd4db], a
	sla a
	inc a
	jr LoadBumperGraphics_BlueField

LoadBumpersGraphics_BlueField: ; 1ce72
	ld a, [wd4db]
	cp $ff
	ret z
	sla a
	; fall through

LoadBumperGraphics_BlueField: ; 0x1ce7a
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
	call QueueGraphicsToLoad
	ret

ApplyBumperCollision_BlueField: ; 0x1ce94
	ld a, $ff
	ld [wRumblePattern], a
	ld a, $3
	ld [wRumbleDuration], a
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
	ld hl, BumperCollisionAngleDeltas_BlueField
	add hl, bc
	ld a, [wCollisionForceAngle]
	add [hl]
	ld [wCollisionForceAngle], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

BumperCollisionAngleDeltas_BlueField:
	db -8, 8

INCLUDE "data/queued_tiledata/blue_field/bumpers.asm"

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
	callba LoadTimerGraphics
.asm_1cfe5
	ld a, [wWhichBoardTriggerId]
	sub $7
	ld c, a
	ld b, $0
	ld hl, wCollidedAlleyTriggers
	add hl, bc
	ld [hl], $1
	ld a, [wCollidedAlleyTriggers + 0]
	and a
	call nz, HandleSecondaryLeftAlleyTrigger_BlueField
	ld a, [wCollidedAlleyTriggers + 1]
	and a
	call nz, HandleSecondaryRightAlleyTrigger_BlueField
	ld a, [wCollidedAlleyTriggers + 2]
	and a
	call nz, HandleLeftAlleyTrigger_BlueField
	ld a, [wCollidedAlleyTriggers + 3]
	and a
	call nz, HandleRightAlleyTrigger_BlueField
	ret

HandleSecondaryLeftAlleyTrigger_BlueField: ; 0x1d010
; Ball passed over the secondary left alley trigger point in the Blue Field.
	xor a
	ld [wCollidedAlleyTriggers + 0], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba CheckSpecialModeColision
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

HandleSecondaryRightAlleyTrigger_BlueField: ; 0x1d047
; Ball passed over the secondary right alley trigger point in the Blue Field.
	xor a
	ld [wCollidedAlleyTriggers + 1], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba CheckSpecialModeColision
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

HandleLeftAlleyTrigger_BlueField: ; 0x1d080
; Ball passed over the left alley trigger point in the Blue Field.
	xor a
	ld [wCollidedAlleyTriggers + 2], a
	ld [wRightAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wLeftAlleyTrigger], a
	ret c
	ret

HandleRightAlleyTrigger_BlueField: ; 0x1d091
; Ball passed over the right alley trigger point in the Blue Field.
	xor a
	ld [wCollidedAlleyTriggers + 3], a
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
	ld hl, wWhichPikachuSaverSide
	cp [hl]
	jr nz, .asm_1d110
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_1d0fc
.asm_1d0c9
	ld hl, PikachuSaverAnimationData_BlueField
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
	ld [wEnableBallGravityAndTilt], a
	call FillBottomMessageBufferWithBlackTile
	jr .asm_1d110

.asm_1d0fc
	ld hl, PikachuSaverAnimation2Data_BlueField
	ld de, wPikachuSaverAnimation
	call InitAnimation
	ld a, $2
	ld [wd51c], a
	lb de, $00, $3b
	call PlaySoundEffect
.asm_1d110
	ld a, [wd51c]
	and a
	call z, SetPikachuSaverSide_BlueField
	call UpdatePikachuSaverAnimation_BlueField
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

UpdatePikachuSaverAnimation_BlueField: ; 0x1d133
	ld a, [wd51c]
	cp $1
	jr nz, .asm_1d1ae
	ld hl, PikachuSaverAnimationData_BlueField
	ld de, wPikachuSaverAnimation
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationIndex]
	cp $1
	jr nz, .asm_1d18c
	xor a
	ld [wAudioEngineEnabled], a
	call Func_310a
	rst AdvanceFrame
	ld a, $1
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wAudioEngineEnabled], a
	ld a, $ff
	ld [wRumblePattern], a
	ld a, $60
	ld [wRumbleDuration], a
	ld hl, wNumPikachuSaves
	call Increment_Max100
	jr nc, .asm_1d185
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
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
	ld [wEnableBallGravityAndTilt], a
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wd51c], a
	ret

.asm_1d1ae
	cp $2
	jr nz, .asm_1d1c7
	ld hl, PikachuSaverAnimation2Data_BlueField
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

PikachuSaverAnimationData_BlueField: ; 0x1d1d1
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

PikachuSaverAnimation2Data_BlueField: ; 0x1d1f6
; Each entry is [duration][OAM id]
	db $0C, $02
	db $01, $00
	db $00

SetPikachuSaverSide_BlueField: ; 0x1d1fb
; Sets which side Pikachu is on, depending on which flipper was pressed last.
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	jr z, .asm_1d209
	ld hl, wWhichPikachuSaverSide
	ld [hl], $0
	ret

.asm_1d209
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ret z
	ld hl, wWhichPikachuSaverSide
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
	ld [wEnableBallGravityAndTilt], a
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
	ld [wPinballIsVisible], a
	ld a, [wLeftAlleyCount]
	cp $3
	jr nz, .asm_1d299
	callba StartEvolutionMode
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
	callba z, IncrementBonusMultiplierFromFieldEvent
	ret

.asm_1d2b6
	ld a, [wSlowpokeAnimationIndex]
	cp $4
	jr nz, .asm_1d2c3
	ld a, $1
	ld [wPinballIsVisible], a
	ret

.asm_1d2c3
	ld a, [wSlowpokeAnimationIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wEnableBallGravityAndTilt], a
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
	callba CheckSpecialModeColision
.asm_1d2f8
	xor a
	ld [wd642], a
	ld [wBlueFieldForceFieldFrameCounter], a
	ld [wBlueFieldForceFieldSecondsCounter], a
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
	ld [wEnableBallGravityAndTilt], a
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
	ld [wPinballIsVisible], a
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
	callba z, IncrementBonusMultiplierFromFieldEvent
	ret

.asm_1d3cb
	ld a, [wCloysterAnimationIndex]
	cp $4
	jr nz, .asm_1d3d8
	ld a, $1
	ld [wPinballIsVisible], a
	ret

.asm_1d3d8
	ld a, [wCloysterAnimationIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wEnableBallGravityAndTilt], a
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
	callba CheckSpecialModeColision
	xor a
	ld [wBlueFieldForceFieldFrameCounter], a
	ld [wBlueFieldForceFieldSecondsCounter], a
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

ResolveBonusMultiplierCollision_BlueField: ; 0x1d438
	call UpdateBonusMultiplierRailingLight
	ld a, [wWhichBonusMultiplierRailing]
	and a
	jp z, UpdateBonusMultiplierRailing_BlueField
	xor a
	ld [wWhichBonusMultiplierRailing], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wWhichBonusMultiplierRailingId]
	sub $f
	jr nz, .hitRightRailing
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d45c
	ld a, $1f
	jr .asm_1d45e

.asm_1d45c
	ld a, $29
.asm_1d45e
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, $3c
	ld [wBonusMultiplierRailingEndLightDuration], a
	ld a, $9
	callba CheckSpecialModeColision
	ld a, [wd610]
	cp $3
	jp nz, asm_1d4fa
	ld a, $1
	ld [wd610], a
	ld a, $3
	ld [wd611], a
	ld a, [wBonusMultiplierTensDigit]
	set 7, a
	ld [wBonusMultiplierTensDigit], a
	jr asm_1d4fa

.hitRightRailing
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d497
	ld a, $21
	jr .asm_1d499

.asm_1d497
	ld a, $2b
.asm_1d499
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, $1e
	ld [wBonusMultiplierRailingEndLightDuration], a
	ld a, $a
	callba CheckSpecialModeColision
	ld a, [wd611]
	cp $3
	jr nz, asm_1d4fa
	ld a, $1
	ld [wd610], a
	ld a, $1
	ld [wd611], a
	ld a, $80
	ld [wd612], a
	ld a, [wBonusMultiplierOnesDigit]
	set 7, a
	ld [wBonusMultiplierOnesDigit], a
	ld a, [wCurBonusMultiplier]
	inc a
	cp MAX_BONUS_MULTIPLIER + 1
	jr c, .setNewBonusMultplier
	ld a, MAX_BONUS_MULTIPLIER
.setNewBonusMultplier
	ld [wCurBonusMultiplier], a
	jr nc, .asm_1d4e9
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_1d4e9
	ld a, [wBonusMultiplierTensDigit]
	ld [wd614], a
	ld a, [wBonusMultiplierOnesDigit]
	ld [wd615], a
	ld a, $1
	ld [wd613], a
asm_1d4fa: ; 0x1d4fa
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wBonusMultiplierTensDigit]
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, [wBonusMultiplierOnesDigit]
	add $14
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, 60
	ld [wBonusMultiplierRailingEndLightDuration], a
	ret

UpdateBonusMultiplierRailing_BlueField: ; 0x1d51b
	call ShowBonusMultiplierMessage_BlueField ; only shows the scrolling message when appropriate
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
	ld a, [wCurBonusMultiplier]
	call GetBCDForNextBonusMultiplier_BlueField
	ld a, [wBonusMultiplierTensDigit]
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, [wBonusMultiplierOnesDigit]
	add $14
	call LoadBonusMultiplierRailingGraphics_BlueField
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
	ld a, [wBonusMultiplierTensDigit]
	res 7, a
	ld [wBonusMultiplierTensDigit], a
	call LoadBonusMultiplierRailingGraphics_BlueField
	jr .asm_1d58b

.asm_1d580
	ld a, [wBonusMultiplierTensDigit]
	set 7, a
	ld [wBonusMultiplierTensDigit], a
	call LoadBonusMultiplierRailingGraphics_BlueField
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
	ld a, [wBonusMultiplierOnesDigit]
	res 7, a
	ld [wBonusMultiplierOnesDigit], a
	add $14
	call LoadBonusMultiplierRailingGraphics_BlueField
	ret

.asm_1d5b1
	ld a, [wBonusMultiplierOnesDigit]
	set 7, a
	ld [wBonusMultiplierOnesDigit], a
	add $14
	call LoadBonusMultiplierRailingGraphics_BlueField
	ret

ShowBonusMultiplierMessage_BlueField: ; 0x1d5bf
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	ld a, [wd613]
	and a
	ret z
	xor a
	ld [wd613], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld de, BonusMultiplierText
	call LoadScrollingText
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

LoadBonusMultiplierRailingGraphics_BlueField: ; 0x1d5f2
	push af
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	pop af
	call LoadBonusMultiplierRailingGraphics_BlueField_Gameboy
	ret

.gameboyColor
	pop af
	call LoadBonusMultiplierRailingGraphics_BlueField_GameboyColor
	ret

LoadBonusMultiplierRailingGraphics_BlueField_Gameboy: ; 0x1d602
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
	ld hl, BonusMultiplierRailingTileDataPointers_1d6be
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BonusMultiplierRailingTileDataPointers_1d6be)
	call QueueGraphicsToLoad
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
	ld hl, BonusMultiplierRailingTileDataPointers_1d946
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BonusMultiplierRailingTileDataPointers_1d946)
	call QueueGraphicsToLoad
	ret

LoadBonusMultiplierRailingGraphics_BlueField_GameboyColor: ; 0x1d645
	bit 7, a
	jr z, .asm_1d64d
	res 7, a
	add $a
.asm_1d64d
	ld c, a
	ld b, $0
	sla c
	ld hl, BonusMultiplierRailingTileDataPointers_1d97a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BonusMultiplierRailingTileDataPointers_1d97a)
	call QueueGraphicsToLoad
	ret

GetBCDForNextBonusMultiplier_BlueField: ; 0x1d65f
; Gets the BCD representation of the next bonus multplier value.
; Output:  [wBonusMultiplierTensDigit] = the tens digit
;          [wBonusMultiplierOnesDigit] = the ones digit
	ld a, [wCurBonusMultiplier]
	inc a
	cp MAX_BONUS_MULTIPLIER + 1
	jr c, .max99
	ld a, MAX_BONUS_MULTIPLIER
.max99
	ld b, a
	xor a
	ld hl, PowersOfTwo_1d68b
	ld c, $7
.loop
	bit 0, b
	jr z, .evenNumber
	add [hl]
	daa
.evenNumber
	srl b
	inc hl
	dec c
	jr nz, .loop
	push af
	swap a
	and $f
	ld [wBonusMultiplierTensDigit], a
	pop af
	and $f
	ld [wBonusMultiplierOnesDigit], a
	ret

PowersOfTwo_1d68b:
; BCD powers of 2
	db $01, $02, $04, $08, $16, $32, $64

UpdateBonusMultiplierRailingLight: ; 0x1d692
; When one of the two bonus multiplier buttons are hit, they stay lit up for a second.
; This function turns of the light effect after the duration runs out.
	ld a, [wBonusMultiplierRailingEndLightDuration]
	cp $1
	jr z, .turnOffLight
	dec a
	ld [wBonusMultiplierRailingEndLightDuration], a
	ret

.turnOffLight
	ld a, $0
	ld [wBonusMultiplierRailingEndLightDuration], a
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboy
	ld a, $1e
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, $20
	call LoadBonusMultiplierRailingGraphics_BlueField
	ret

.gameboy
	ld a, $2a
	call LoadBonusMultiplierRailingGraphics_BlueField
	ld a, $28
	call LoadBonusMultiplierRailingGraphics_BlueField
	ret

INCLUDE "data/queued_tiledata/blue_field/bonus_multiplier_railings.asm"

ResolvePsyduckPoliwagCollision: ; 0x1dbd2
	ld a, [wWhichPsyduckPoliwag]
	and a
	jp z, UpdatePsyduckAndPoliwag
	cp $2
	jr z, .hitPsyduck
	; hit poliwag
	xor a
	ld [wWhichPsyduckPoliwag], a
	ld hl, wLeftMapMoveCounter
	ld a, [hl]
	cp $3
	jp z, UpdatePsyduckAndPoliwag
	inc a
	ld [hl], a
	; Set 8 seconds until the counter will decrease by 1
	ld hl, wLeftMapMoveCounterFramesUntilDecrease
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
	ld [hl], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .skipCollisionMapChange
	ld a, $54
	ld [wStageCollisionMap + $e3], a
	ld a, $55
	ld [wStageCollisionMap + $103], a
.skipCollisionMapChange
	ld a, $1
	call LoadPsyduckOrPoliwagGraphics
	ld a, [wLeftMapMoveCounter]
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, [wLeftMapMoveCounter]
	cp $3
	ld a, $7
	callba CheckSpecialModeColision
	ld a, $2
	ld [wPoliwagState], a
	ld a, $78
	ld [wLeftMapMovePoliwagAnimationCounter], a
	ld a, $14
	ld [wLeftMapMovePoliwagFrame], a
	jr .asm_1dc8a

.hitPsyduck
	xor a
	ld [wWhichPsyduckPoliwag], a
	ld hl, wRightMapMoveCounter
	ld a, [hl]
	cp $3
	jp z, UpdatePsyduckAndPoliwag
	inc a
	ld [hl], a
	; Set 8 seconds until the counter will decrease by 1
	ld hl, wRightMapMoveCounterFramesUntilDecrease
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
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
	call LoadPsyduckOrPoliwagGraphics
	ld a, [wRightMapMoveCounter]
	cp $3
	ld a, $8
	callba CheckSpecialModeColision
	ld a, [wRightMapMoveCounter]
	cp $3
	ccf
	call z, HitPsyduck3Times
	ld a, $2
	ld [wPsyduckState], a
	ld a, $28
	ld [wRightMapMovePsyduckAnimationCounter], a
	ld a, $78
	ld [wRightMapMovePsyduckFrame], a
.asm_1dc8a
	call AddScorePsyduckOrPoliwag
	ret

UpdatePsyduckAndPoliwag: ; 0x1dc8e
	call UpdatePoliwag
	call UpdatePsyduck
	ret

UpdatePoliwag: ; 0x1dc95
	ld a, [wPoliwagState]
	cp $0
	ret z
	ld a, [wLeftMapMovePoliwagAnimationCounter]
	and a
	jr z, .asm_1dceb
	dec a
	ld [wLeftMapMovePoliwagAnimationCounter], a
	ld a, [wd644]
	and a
	ret nz
	ld a, [wLeftMapMovePoliwagFrame]
	cp $1
	jr z, .asm_1dcb9
	cp $0
	ret z
	dec a
	ld [wLeftMapMovePoliwagFrame], a
	ret

.asm_1dcb9
	ld a, [wPoliwagState]
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
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, [wLeftMapMoveCounter]
	cp $3
	ccf
	call z, HitPoliwag3Times
	ld a, $1
	ld [wPoliwagState], a
	ret

.asm_1dceb
	ld a, [wPoliwagState]
	cp $1
	ret nz
	ld a, [wLeftMapMovePoliwagAnimationCounter]
	and a
	ret nz
	ld a, $0
	call LoadPsyduckOrPoliwagGraphics
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dd0c
	ld a, $5e
	ld [wStageCollisionMap + $e3], a
	ld a, $5f
	ld [wStageCollisionMap + $103], a
.asm_1dd0c
	ld a, $0
	ld [wPoliwagState], a
	ld a, [wLeftMapMoveCounter]
	sub $3
	ret nz
	ld a, [wLeftMapMoveCounter]
	sub $3
	ld [wLeftMapMoveCounter], a
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, $0
	call LoadPsyduckOrPoliwagGraphics
	ld a, $0
	ld [wPoliwagState], a
	ret

; XXX
	ret

UpdatePsyduck: ; 0x1dd2e
	ld a, [wPsyduckState]
	cp $0
	ret z
	cp $1
	jr z, .asm_1dd53
	cp $3
	jr z, .asm_1dd69
	ld a, [wRightMapMovePsyduckAnimationCounter]
	cp $0
	jr z, .asm_1dd48
	dec a
	ld [wRightMapMovePsyduckAnimationCounter], a
	ret

.asm_1dd48
	ld a, $2
	call LoadPsyduckOrPoliwagGraphics
	ld a, $1
	ld [wPsyduckState], a
	ret

.asm_1dd53
	ld a, [wRightMapMoveCounter]
	add $4
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, [wRightMapMoveCounter]
	add $3
	call LoadPsyduckOrPoliwagGraphics
	ld a, $3
	ld [wPsyduckState], a
	ret

.asm_1dd69
	ld a, [wRightMapMovePsyduckFrame]
	and a
	jr z, .asm_1dd74
	dec a
	ld [wRightMapMovePsyduckFrame], a
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
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, $2
	call LoadPsyduckOrPoliwagGraphics
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dda9
	ld a, $24
	ld [wStageCollisionMap + $f0], a
	ld a, $25
	ld [wStageCollisionMap + $110], a
	ld a, $0
	ld [wPsyduckState], a
.asm_1dda9
	ld a, [wRightMapMoveCounter]
	sub $3
	ret nz
	ld a, [wRightMapMoveCounter]
	sub $3
	ld [wRightMapMoveCounter], a
	ld a, $4
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, $2
	call LoadPsyduckOrPoliwagGraphics
	ld a, $0
	ld [wPsyduckState], a
	ret

HitPoliwag3Times: ; 0x1ddc7
	ld hl, wNumPoliwagTriples
	call Increment_Max100
	ld hl, wNumDugtrioTriples ; developer oversight
	call Increment_Max100
	jr nc, .asm_1dde4
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_1dde4
	xor a
	ld [wMapMoveDirection], a
	callba StartMapMoveMode
	scf
	ret

HitPsyduck3Times: ; 0x1ddf4
	ld hl, wNumPsyduckTriples
	call Increment_Max100
	ld hl, wNumDugtrioTriples ; developer oversight
	call Increment_Max100
	jr nc, .asm_1de11
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_1de11
	ld a, $1
	ld [wMapMoveDirection], a
	callba StartMapMoveMode
	scf
	ret

AddScorePsyduckOrPoliwag: ; 0x1de22
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, $55
	ld [wRumblePattern], a
	ld a, $4
	ld [wRumbleDuration], a
	ld a, $2
	ld [wd7eb], a
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $0f
	call PlaySoundEffect
	ret

LoadPsyduckOrPoliwagGraphics: ; 0x1de4b
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
	jr z, .gameboyColor
	ld hl, TileDataPointers_1e00f
.gameboyColor
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1df66)
	call QueueGraphicsToLoad
	ret

LoadPsyduckOrPoliwagNumberGraphics: ; 0x1de6f
; This is for the map move numbers that appears next to poliwag and psyduck.
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
	call QueueGraphicsToLoad
	ret

UpdateMapMoveCounters_BlueFieldBottom: ; 0x1de93
; Decrements the two counters that cause the map move counters to decrease by one every 8 seconds.
; Also updates the counter graphics if anything changes.
; The map move counters appear next to Poliwag and Psyduck.
	ld hl, wLeftMapMoveCounterFramesUntilDecrease
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .checkRightMapMoveCounter
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .checkRightMapMoveCounter
	; Reset the counter back to 8 seconds worth of frames (480 frames)
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .checkRightMapMoveCounter
	cp $3
	jr z, .checkRightMapMoveCounter
	dec a
	ld [wLeftMapMoveCounter], a
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .gameboy
	ld a, [wLeftMapMoveCounter]
	cp $0
	jr z, .asm_1deca
	ld b, $7
	add b
	jr .asm_1decf

.asm_1deca
	xor a
	jr .asm_1decf

.gameboy
	ld a, $8
.asm_1decf
	call LoadPsyduckOrPoliwagNumberGraphics
.checkRightMapMoveCounter
	ld hl, wRightMapMoveCounterFramesUntilDecrease
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .done
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .done
	; Reset the counter back to 8 seconds worth of frames (480 frames)
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .done
	cp $3
	jr z, .done
	dec a
	ld [wRightMapMoveCounter], a
	add $4
	call LoadPsyduckOrPoliwagNumberGraphics
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .gameboy_2
	ld a, [wRightMapMoveCounter]
	cp $0
	jr z, .asm_1df0b
	ld b, $a
	add b
	jr .asm_1df11

.asm_1df0b
	ld a, $4
	jr .asm_1df11

.gameboy_2
	ld a, $9
.asm_1df11
	call LoadPsyduckOrPoliwagNumberGraphics
.done
	ret

UpdateMapMoveCounters_BlueFieldTop: ; 0x1df15
; This is identical logic to UpdateMapMoveCounters_BlueFieldTop, but it doesn't load
; any graphics, since Poliwag and Psyduck aren't in the Top half of the Blue Field.
	ld b, $0
	ld hl, wLeftMapMoveCounterFramesUntilDecrease + 1
	ld a, [hld]
	or [hl]
	jr z, .checkRightMapMoveCounter
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .checkRightMapMoveCounter
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .checkRightMapMoveCounter
	; Reset the counter back to 8 seconds worth of frames (480 frames)
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .checkRightMapMoveCounter
	cp $3
	jr z, .checkRightMapMoveCounter
	dec a
	ld [wLeftMapMoveCounter], a
.checkRightMapMoveCounter
	ld hl, wRightMapMoveCounterFramesUntilDecrease + 1
	ld a, [hld]
	or [hl]
	jr z, .done
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .done
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .done
	; Reset the counter back to 8 seconds worth of frames (480 frames)
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .done
	cp $3
	jr z, .done
	dec a
	ld [wRightMapMoveCounter], a
.done
	ret

INCLUDE "data/queued_tiledata/blue_field/poliwag_psyduck.asm"

ResolveBallUpgradeTriggersCollision_BlueField: ; 0x1e356
	ld a, [wWhichPinballUpgradeTrigger]
	and a
	jp z, UpdatePinballUpgradeTriggers
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
	callba LoadTimerGraphics
.asm_1e386
	ld a, [wStageCollisionState]
	bit 0, a
	jp z, UpdatePinballUpgradeTriggers
	ld a, [wBallUpgradeTriggersBlinking]
	and a
	jp nz, UpdatePinballUpgradeTriggers
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $b
	callba CheckSpecialModeColision
	ld a, [wWhichPinballUpgradeTriggerId]
	sub $13
	ld c, a
	ld b, $0
	ld hl, wBallUpgradeTriggerStates
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	jr z, .toggled
	ld [hl], $0
.toggled
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wBallUpgradeTriggerStates
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	jr nz, .allTriggersOn
	lb de, $00, $09
	call PlaySoundEffect
	jp LoadPinballUpgradeTriggersGraphics_BlueField

.allTriggersOn
	ld a, $1
	ld [wBallUpgradeTriggersBlinking], a
	ld a, $80
	ld [wBallUpgradeTriggersBlinkingFramesRemaining], a
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, PINBALL_UPGRADE_FRAMES_COUNTER & $ff
	ld [wBallTypeCounter], a
	ld a, PINBALL_UPGRADE_FRAMES_COUNTER >> 8
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
	ld hl, wScrollingText1
	ld de, FieldMultiplierText
	call LoadScrollingText
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgression2BlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .done

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
	ld hl, wScrollingText2
	ld de, DigitsText1to8
	call Func_32cc
	pop de
	pop bc
	ld hl, wScrollingText1
	ld de, FieldMultiplierSpecialBonusText
	call LoadScrollingText
.done
	callba TransitionPinballUpgrade
	jr LoadPinballUpgradeTriggersGraphics_BlueField

UpdatePinballUpgradeTriggers: ; 0x1e471
	call UpdatePinballUpgradeBlinkingAnimation_BlueField
	ret z
	; fall through
LoadPinballUpgradeTriggersGraphics_BlueField: ; 0x1e475
; Loads the on or off graphics for each of the 3 pinball upgrade trigger dots, depending on their current toggle state.
	ld hl, wBallUpgradeTriggerStates + 2
	ld b, $3
.loop
	ld a, [hld]
	push hl
	call LoadPinballUpgradeTriggerGraphics_BlueField
	pop hl
	dec b
	jr nz, .loop
	ret

LoadPinballUpgradeTriggerGraphics_BlueField: ; 0x1e484
; Loads the on or off graphics for one of the 3 pinball upgrade trigger dots, depending on its current toggle state.
; Input: a = toggle state
	and a
	jr z, .toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOnGameboy
	ld hl, TileDataPointers_1e520
	jr .load

.toggledOnGameboy
	ld hl, TileDataPointers_1e556
	jr .load

.toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOffGameboy
	ld hl, TileDataPointers_1e526
	jr .load

.toggledOffGameboy
	ld hl, TileDataPointers_1e55c
.load
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, Bank(TileDataPointers_1e520)
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	pop bc
	ret

UpdatePinballUpgradeBlinkingAnimation_BlueField: ; 0x1e4b8
; Controls the brief blinking animation of the 3 upgrade triggers after successfully
; upgrading the pinball.
	ld a, [wBallUpgradeTriggersBlinking]
	and a
	jr z, .notBlinking
	ld a, [wBallUpgradeTriggersBlinkingFramesRemaining]
	dec a
	ld [wBallUpgradeTriggersBlinkingFramesRemaining], a
	jr nz, .stillBlinking
	ld [wBallUpgradeTriggersBlinking], a
.stillBlinking
	and $7
	jr nz, .dontFlipState
	; Blink the triggers on or off
	ld a, [wBallUpgradeTriggersBlinkingFramesRemaining]
	srl a
	srl a
	srl a
	and $1
	ld hl, wBallUpgradeTriggerStates
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.dontFlipState
	xor a
	ret

.notBlinking
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .checkRightFlipperKeyPress
	; left flipper key is pressed
	ld hl, wBallUpgradeTriggerStates
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

.checkRightFlipperKeyPress
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	; right flipper key is pressed
	ld hl, wBallUpgradeTriggerStates
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

INCLUDE "data/queued_tiledata/blue_field/ball_upgrade_triggers.asm"

UpdateBallTypeUpgradeCounter_BlueField: ; 0x1e58c
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
	; counter is now 0! Degrade the ball upgrade type.
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
	ld a, PINBALL_UPGRADE_FRAMES_COUNTER & $ff
	ld [wBallTypeCounter], a
	ld a, PINBALL_UPGRADE_FRAMES_COUNTER >> 8
	ld [wBallTypeCounter + 1], a
.pokeball
	callba TransitionPinballUpgrade
	ret

ResolveCAVELightCollision_BlueField: ; 0x1e5c5
	ld a, [wWhichCAVELight]
	and a
	jr z, .noCollision
	xor a
	ld [wWhichCAVELight], a
	ld a, [wCAVELightsBlinking]
	and a
	jr nz, .noCollision
	ld a, [wWhichCAVELightId]
	sub $16
	ld c, a
	ld b, $0
	ld hl, wCAVELightStates
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wCAVELightStates
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	inc hl
	and [hl]
	jr z, LoadCAVELightsGraphics_BlueField
	ld a, $1
	ld [wCAVELightsBlinking], a
	ld a, $80
	ld [wCAVELightsBlinkingFramesRemaining], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $09
	call PlaySoundEffect
	ld hl, wNumCAVECompletions
	call Increment_Max100
	jr LoadCAVELightsGraphics_BlueField

.noCollision
	call UpdateCAVELightsBlinking_BlueField
	ret z
	; fall through

LoadCAVELightsGraphics_BlueField: ; 0x1e627
; Loads the graphics for each of the 4 CAVE lights, depending on what their current toggled state is.
	ld hl, wCAVELightStates + 3
	ld b, $4
.loop
	ld a, [hld]
	push hl
	call LoadCAVELightGraphics_BlueField
	pop hl
	dec b
	jr nz, .loop
	ret

LoadCAVELightGraphics_BlueField: ; 0x1e636
; Loads a graphics for single CAVE light.
; Input: a = toggle state for CAVE light
	and a
	jr z, .toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOnGameboy
	ld hl, TileDataPointers_1e6d7
	jr .load

.toggledOnGameboy
	ld hl, TileDataPointers_1e717
	jr .load

.toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOffGameboy
	ld hl, TileDataPointers_1e6df
	jr .load

.toggledOffGameboy
	ld hl, TileDataPointers_1e71f
.load
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, Bank(TileDataPointers_1e6d7)
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	pop bc
	ret

UpdateCAVELightsBlinking_BlueField: ; 0x1e66a
	ld a, [wCAVELightsBlinking]
	and a
	jr z, .notBlinking
	ld a, [wCAVELightsBlinkingFramesRemaining]
	dec a
	ld [wCAVELightsBlinkingFramesRemaining], a
	jr nz, .asm_1e687
	ld [wCAVELightsBlinking], a
	ld a, $1
	ld [wOpenedSlotByGetting4CAVELights], a
	ld a, $3
	ld [wFramesUntilSlotCaveOpens], a
	xor a
.asm_1e687
	and $7
	ret nz
	ld a, [wCAVELightsBlinkingFramesRemaining]
	srl a
	srl a
	srl a
	and $1
	ld hl, wCAVELightStates
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.notBlinking
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .checkRightFlipperKeyPress
	ld hl, wCAVELightStates
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

.checkRightFlipperKeyPress
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wCAVELightStates
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

INCLUDE "data/queued_tiledata/blue_field/cave_lights.asm"

ResolveSlotCollision_BlueField: ; 0x1e757
	ld a, [wSlotCollision]
	and a
	jr z, .noCollision
	xor a
	ld [wSlotCollision], a
	ld a, [wSlotIsOpen]
	and a
	ret z
	ld a, [wSlotEnterOrExitCounter]
	and a
	jr nz, .noCollision
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wEnableBallGravityAndTilt], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $16
	ld [wBallYPos + 1], a
	ld a, $13
	ld [wSlotEnterOrExitCounter], a
.noCollision
	ld a, [wSlotEnterOrExitCounter]
	and a
	ret z
	dec a
	ld [wSlotEnterOrExitCounter], a
	ld a, $18
	ld [wSlotGlowingAnimationCounter], a
	ld a, [wSlotEnterOrExitCounter]
	cp $12
	jr nz, .asm_1e7b2
	lb de, $00, $21
	call PlaySoundEffect
	callba LoadMiniBallGfx
	ret

.asm_1e7b2
	cp $f
	jr nz, .asm_1e7c1
	callba LoadSuperMiniPinballGfx
	ret

.asm_1e7c1
	cp $c
	jr nz, .asm_1e7d0
	xor a
	ld [wPinballIsVisible], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_1e7d0
	cp $9
	jr nz, .asm_1e7d8
	call DoSlotLogic_BlueField
	ret

.asm_1e7d8
	cp $6
	jr nz, .asm_1e7f5
	xor a
	ld [wSlotIsOpen], a
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
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
	call LoadSlotCaveCoverGraphics_BlueField
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

DoSlotLogic_BlueField: ; 0x1e830
; Performs the slot logic when pinball entered the slot cave.
; This could be the slot roulette, or evolving a pokemon, for example.
	xor a
	ld [wIndicatorStates + 4], a
	ld a, $d
	callba CheckSpecialModeColision
	jr nc, .asm_1e84b
	ld a, $1
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ret

.asm_1e84b
	ld a, [wPreviousNumPokeballs]
	cp $3
	jr nz, .asm_1e891
	ld a, [wFramesUntilSlotCaveOpens]
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
	ld [wMoveToNextScreenState], a
	ld a, [wd498]
	ld c, a
	ld b, $0
	ld hl, BonusStages_BlueField
	add hl, bc
	ld a, [hl]
	ld [wNextStage], a
	call ShowScrollingGoToBonusText_BlueField
	xor a
	ld [wOpenedSlotByGetting3Pokeballs], a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	ret

.asm_1e891
	callba Func_ed8e
	xor a
	ld [wOpenedSlotByGetting4CAVELights], a
	ld a, [wd61d]
	cp $d
	jr nc, .asm_1e858
	ld a, $1
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ld a, [wCatchEmOrEvolutionSlotRewardActive]
	cp EVOLUTION_MODE_SLOT_REWARD
	ret nz
	callba StartEvolutionMode
	xor a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

ShowScrollingGoToBonusText_BlueField: ; 0x1e8c3
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	ld a, [wNextStage]
	ld de, GoToMeowthStageText
	cp STAGE_MEOWTH_BONUS
	jr z, .loadText
	ld de, GoToSeelStageText
	cp STAGE_SEEL_BONUS
	jr z, .loadText
	ld de, GoToMewtwoStageText
.loadText
	call LoadScrollingText
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $3c, $23
	call PlaySoundEffect
	ret

BonusStages_BlueField:
	db STAGE_GENGAR_BONUS
	db STAGE_MEWTWO_BONUS
	db STAGE_MEOWTH_BONUS
	db STAGE_DIGLETT_BONUS
	db STAGE_SEEL_BONUS

LoadSlotCaveCoverGraphics_BlueField: ; 0x1e8f6
; Loads the graphics for the circular slot cave area.
; It looks like a cover that opens and closes.
	ld a, [wCurrentStage]
	and $1
	sla a
	ld c, a
	ld a, [wSlotIsOpen]
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
	call QueueGraphicsToLoad
	ret

INCLUDE "data/queued_tiledata/blue_field/slot_cave.asm"

OpenSlotCave_BlueField: ; 0x1e9c0
	ld a, [wFramesUntilSlotCaveOpens]
	and a
	ret z
	dec a
	ld [wFramesUntilSlotCaveOpens], a
	ret nz
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wOpenedSlotByGetting3Pokeballs]
	and a
	jr z, .asm_1e9dc
	ld a, [wd498]
	add $15
	jr .asm_1e9e3

.asm_1e9dc
	ld a, [wOpenedSlotByGetting4CAVELights]
	and a
	ret z
	ld a, $1a ; "Slot On" billboard picture id
.asm_1e9e3
	ld hl, wCurrentStage
	bit 0, [hl]
	callba nz, LoadBillboardTileData
	ld a, [wSlotIsOpen]
	and a
	ret nz
	ld a, $1
	ld [wSlotIsOpen], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	call nz, LoadSlotCaveCoverGraphics_BlueField
	ret

ApplySlotForceField_BlueFieldBottom: ; 0x1ea0a
; Applies the force field to the pinball when near the slot cave opening.
	ld a, [wSlotIsOpen]
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
	jr _ApplySlotForceField_BlueField

ApplySlotForceField_BlueFieldTop: ; 0x1ea3b
; Applies the force field to the pinball when near the slot cave opening.
; Even though the Slot cave is on the bottom half of the board, the force field
; still affects the pinball when it's really close to the bottom of the top-half of the board.
	ld a, [wSlotIsOpen]
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

_ApplySlotForceField_BlueField: ; 0x1ea6a
; Applies the force field to the pinball when near the slot cave opening.
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
	ld a, [wRumbleDuration]
	and a
	ret nz
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	lb de, $00, $04
	call PlaySoundEffect
	ret

UpdateArrowIndicators_BlueField: ; 0x1ead4
; Updates the 5 blinking arrow indicators in the blue field bottom.
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
	call LoadArrowIndicatorGraphics_BlueStage
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
.loop
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
	call LoadArrowIndicatorGraphics_BlueStage
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .loop
	ret

LoadArrowIndicatorGraphics_BlueStage: ; 0x1eb41
	push af
	sla c
	ld hl, TileDataPointers_1eb61
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .gameboy
	ld hl, TileDataPointers_1ed51
.gameboy
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
	call QueueGraphicsToLoad
	ret

INCLUDE "data/queued_tiledata/blue_field/arrow_indicators.asm"

ResolveForceFieldCollision: ; 0x1ef09
; Handles the collision with the directional force field in between Slowpoke and Cloyster.
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jp z, ResolveForceFieldCollision_Up
	cp $1  ; right direction
	jp z, ResolveForceFieldCollision_Right
	cp $2  ; down direction
	jp z, ResolveForceFieldCollision_Down
	cp $3  ; left direction
	jp z, ResolveForceFieldCollision_Left
	; fall through
	; default to upward forcefield

ResolveForceFieldCollision_Up: ; 0x1ef20
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
	jp ApplyForceFieldForce

ResolveForceFieldCollision_Right: ; 0x1ef4d
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
	jp ApplyForceFieldForce

ResolveForceFieldCollision_Down: ; 0x1ef7e
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
	jr ApplyForceFieldForce

ResolveForceFieldCollision_Left: ; 0x1efae
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

ApplyForceFieldForce: ; 0x1efdc
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jp z, ApplyForceFieldForce_Up
	cp $1  ; right direction
	jp z, ApplyForceFieldForce_Right
	cp $2  ; down direction
	jp z, ApplyForceFieldForce_Down
	cp $3  ; left direction
	jp z, ApplyForceFieldForce_Left
	; fall through
	; default to upward forcefield

ApplyForceFieldForce_Up:  ; 0x1eff3
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
	ld a, [wRumbleDuration]
	and a
	ret nz
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ret

ApplyForceFieldForce_Down: ; 0x1f057
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
	ld a, [wRumbleDuration]
	and a
	ret nz
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ret

ApplyForceFieldForce_Right: ; 0x1f0be
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
	ld a, [wRumbleDuration]
	and a
	ret nz
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ret

ApplyForceFieldForce_Left: ; 0x1f124
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
	ld a, [wRumbleDuration]
	and a
	ret nz
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ret

UpdateForceFieldGraphics: ; 0x1f18a
	ld a, [wBlueStageForceFieldGfxNeedsLoading]
	cp $0
	jr z, .done
	ld a, [wBlueStageForceFieldDirection]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1f1b5
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .gameboy
	ld hl, TileDataPointers_1f201
.gameboy
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1f1b5)
	call QueueGraphicsToLoad
	ld a, $0
	ld [wBlueStageForceFieldGfxNeedsLoading], a
.done
	ret

INCLUDE "data/queued_tiledata/blue_field/force_field.asm"

UpdatePokeballs_BlueField: ; 0x1f261
; Update the pokeballs underneath the billboard, which blink for awhile after catch'em mode and evolution mode.
	call UpdateBlinkingPokeballs_BlueField
	ret nc
	; fall through

LoadPokeballsGraphics_BlueField: ; 0x1f265
; Loads the graphics for the list of pokeballs underneath the billboard picture.
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1f2b9
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, Bank(TileDataPointers_1f2b9)
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	ret

UpdateBlinkingPokeballs_BlueField: ; 0x1f27b
	ld a, [wPreviousNumPokeballs]
	ld hl, wNumPokeballs
	cp [hl]
	ret z
	ld a, [wPokeballBlinkingCounter]
	dec a
	ld [wPokeballBlinkingCounter], a
	jr nz, .stillBlinking
	ld a, [wNumPokeballs]
	ld [wPreviousNumPokeballs], a
	cp $3
	jr c, .dontOpenSlot
	ld a, $1
	ld [wOpenedSlotByGetting3Pokeballs], a
	ld a, $3
	ld [wFramesUntilSlotCaveOpens], a
.dontOpenSlot
	ld a, [wPreviousNumPokeballs]
	scf
	ret

.stillBlinking
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

INCLUDE "data/queued_tiledata/blue_field/pokeballs.asm"

CloseSlotCave: ; 0x1f2ed
; Closes the Slot cave, so it can't be entered.
	xor a
	ld [wSlotIsOpen], a
	ld [wIndicatorStates + 4], a
	ld [hFarCallTempA], a
	ld a, Bank(LoadSlotCaveCoverGraphics_BlueField)  ; this is in the same bank...
	ld hl, LoadSlotCaveCoverGraphics_BlueField
	call BankSwitch
	ret

SetLeftAndRightAlleyArrowIndicatorStates_BlueField: ; 0x1f2ff
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
