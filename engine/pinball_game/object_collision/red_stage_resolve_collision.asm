; TODO: this file has a bunch of stuff that doesn't belong here.

ResolveRedFieldTopGameObjectCollisions: ; 0x1460e
	call ResolveVoltorbCollision
	call ResolveRedStageSpinnerCollision
	call ResolveBallUpgradeTriggersCollision_RedField
	call UpdateBallTypeUpgradeCounter_RedField
	call UpdateCAVELightsBlinking_RedField
	call ResolveRedStageBoardTriggerCollision
	call ResolveRedStagePikachuCollision
	call ResolveStaryuCollision
	call ResolveBellsproutCollision
	call ResolveDittoSlotCollision
	call Func_161e0
	call Func_164e3
	call UpdateBallSaverState
	call Func_174ea
	call UpdateMapMoveCounters_RedFieldTop
	callba HandleExtraBall
	ld a, $0
	callba Func_10000
	ret

ResolveRedFieldBottomGameObjectCollisions: ; 0x14652
	call ResolveWildMonCollision_RedField
	call ResolveRedStageBumperCollision
	call ResolveDiglettCollision
	call UpdateMapMoveCounters_RedFieldBottom
	call UpdateRedStageSpinner
	call UpdatePinballUpgradeBlinkingAnimation_RedField
	call UpdateBallTypeUpgradeCounter_RedField
	call ResolveCAVELightCollision_RedField
	call ResolveRedStagePinballLaunchCollision
	call ResolveRedStagePikachuCollision
	call Func_167ff
	call Func_169a6
	call ResolveRedStageBonusMultiplierCollision
	call Func_16279
	call Func_161af
	call Func_164e3
	call Func_14733
	call UpdateBallSaver
	call Func_174d0
	callba HandleExtraBall
	ld a, $0
	callba Func_10000
	ret

UpdateBallSaver: ; 0x146a2
	call UpdateBallSaverState
	call nz, DrawBallSaverIcon ;redraw icon if its state changed
	ret

UpdateBallSaverState: ; 0x146a9
	ld a, [wBallSaverTimerFrames]
	ld hl, wBallSaverTimerSeconds
	or [hl] ;skip if timer ran out
	ret z
	ld a, [wBallXPos + 1]
	cp 154 ;if high? Byte of ball X pos is >= 154, don't update timers
	jr nc, .SkipSecondsOrFramesUpdate
	ld a, [wBallSaverTimerFrames]
	dec a
	ld [wBallSaverTimerFrames], a
	bit 7, a
	jr z, .SkipSecondsOrFramesUpdate
	ld a, 59 ;if frames underflowed, set to 59 and decrement second
	ld [wBallSaverTimerFrames], a
	ld a, [hl]
	dec a
	bit 7, a
	jr nz, .DontClampSeconds ;if seconds would underflow, keep it at 0
	ld [hl], a
.DontClampSeconds
	inc a
	ld c, $0
	cp $2
	jr c, .asm_146e4
	ld c, $4
	cp $6
	jr c, .asm_146e4
	ld c, $10
	cp $b
	jr c, .asm_146e4
	ld c, $ff
.asm_146e4
	ld a, c
	ld [wBallSaverFlashRate], a
.SkipSecondsOrFramesUpdate
	ld a, [wBallSaverFlashRate]
	ld c, $0
	and a
	jr z, .asm_146fe
	ld c, $1
	cp $ff
	jr z, .asm_146fe
	ld hl, hNumFramesDropped
	and [hl]
	jr z, .asm_146fe ; hNumFramesDropped used as timer for flashing
	ld c, $0
.asm_146fe
	ld a, [wBallSaverIconOn]
	cp c ;did the icon state change ?
	ld a, c
	ld [wBallSaverIconOn], a
	ret

DrawBallSaverIcon: ; 0x14707
	ld a, [wBallSaverIconOn]
	and a
	jr nz, .DrawIconOn
	ld a, BANK(BgTileData_1172b)
	ld hl, BgTileData_1172b
	deCoord 8, 13, vBGMap
	ld bc, $0004
	call LoadOrCopyVRAMData
	ret

.DrawIconOn
	ld a, BANK(BgTileData_1472f)
	ld hl, BgTileData_1472f
	deCoord 8, 13, vBGMap
	ld bc, $0004
	call LoadOrCopyVRAMData
	ret

BgTileData_1172b: ;BallSaverIconOffSprite
	db $AA, $AB, $AC, $AD

BgTileData_1472f: ;BallSaverIconOnSprite
	db $B4, $B5, $B6, $B7

Func_14733: ; 0x14733
	ld c, $0
	ld a, [wCurBonusMultiplierFromFieldEvents]
	and a
	jr z, .asm_1473d
	ld c, $1
.asm_1473d
	ld a, [wd4a9]
	cp c
	ld a, c
	ld [wd4a9], a
	ret z
	; fall through

Func_14746: ; 0x14746
	ld c, $0
	ld a, [wCurBonusMultiplierFromFieldEvents]
	and a
	jr z, .asm_14750
	ld c, $2
.asm_14750
	ld b, $0
	ld hl, AgainTextTileDataRedField
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(AgainTextTileDataRedField)
	call Func_10aa
	ret

AgainTextTileDataRedField:
	dw AgainTextOffTileDataRedField
	dw AgainTextOnTileDataRedField

AgainTextOffTileDataRedField:
	db 2
	dw AgainTextOffTileDataRedField1
	dw AgainTextOffTileDataRedField2

AgainTextOnTileDataRedField:
	db 2
	dw AgainTextOnTileDataRedField1
	dw AgainTextOnTileDataRedField2

AgainTextOffTileDataRedField1:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $38
	dw AgainTextOffGfx
	db Bank(AgainTextOffGfx)
	db $00

AgainTextOffTileDataRedField2:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $3a
	dw AgainTextOffGfx + $20
	db Bank(AgainTextOffGfx)
	db $00

AgainTextOnTileDataRedField1:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $38
	dw StageRedFieldBottomBaseGameBoyGfx + $380
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

AgainTextOnTileDataRedField2:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $3a
	dw StageRedFieldBottomBaseGameBoyGfx + $3a0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

ResolveWildMonCollision_RedField: ; 0x14795
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

ResolveDiglettCollision: ; 0x147aa
	ld a, [wWhichDiglett]
	and a
	jp z, .asm_14834
	xor a
	ld [wWhichDiglett], a
	ld a, [wWhichDiglettId]
	sub $1
	sla a
	ld c, a
	ld b, $0
	ld hl, wLeftMapMoveCounter
	add hl, bc
	ld a, [hl]
	cp $3
	jr z, .asm_14834
	inc a
	ld [hld], a
	ld [hl], $50
	ld hl, wLeftMapMoveCounterFramesUntilDecrease
	add hl, bc
	ld a, MAP_MOVE_FRAMES_COUNTER & $ff
	ld [hli], a
	ld a, MAP_MOVE_FRAMES_COUNTER >> 8
	ld [hl], a
	ld a, c
	and a
	jr z, .asm_14807
	ld a, $6a
	ld [wStageCollisionMap + $f0], a
	ld a, $6b
	ld [wStageCollisionMap + $110], a
	ld a, $5
	call LoadDiglettGraphics
	ld a, [wRightMapMoveCounter]
	add $4
	call LoadDiglettNumberGraphics
	ld a, $8
	callba Func_10000
	ld a, [wRightMapMoveCounter]
	cp $3
	call z, HitRightDiglett3Times
	jr .asm_14830

.asm_14807
	ld a, $66
	ld [wStageCollisionMap + $e3], a
	ld a, $67
	ld [wStageCollisionMap + $103], a
	ld a, $2
	call LoadDiglettGraphics
	ld a, [wLeftMapMoveCounter]
	call LoadDiglettNumberGraphics
	ld a, $7
	callba Func_10000
	ld a, [wLeftMapMoveCounter]
	cp $3
	call z, HitLeftDiglett3Times
.asm_14830
	call AddScoreForHittingDiglett
	ret

.asm_14834
	ld a, [wd4ef]
	and a
	jr z, .asm_14857
	dec a
	ld [wd4ef], a
	jr nz, .asm_14857
	ld a, [wLeftMapMoveCounter]
	sub $3
	jr nz, .asm_1484d
	ld [wLeftMapMoveCounter], a
	call LoadDiglettNumberGraphics
.asm_1484d
	ld a, $64
	ld [wStageCollisionMap + $e3], a
	ld a, $65
	ld [wStageCollisionMap + $103], a
.asm_14857
	ld a, [wd4f1]
	and a
	jr z, .asm_1487c
	dec a
	ld [wd4f1], a
	jr nz, .asm_1487c
	ld a, [wRightMapMoveCounter]
	sub $3
	jr nz, .asm_14872
	ld [wRightMapMoveCounter], a
	add $4
	call LoadDiglettNumberGraphics
.asm_14872
	ld a, $68
	ld [wStageCollisionMap + $f0], a
	ld a, $69
	ld [wStageCollisionMap + $110], a
.asm_1487c
	call Func_14990
	ret

UpdateMapMoveCounters_RedFieldBottom: ; 0x14880
; Decrements the two counters that cause the map move counters to decrease by one every 8 seconds.
; Also updates the counter graphics if anything changes.
; The map move counters appear next to Digletts.
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
	call LoadDiglettNumberGraphics
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
	call LoadDiglettNumberGraphics
.done
	ret

UpdateMapMoveCounters_RedFieldTop: ; 0x148cf
; This is identical logic to UpdateMapMoveCounters_RedFieldBottom, but it doesn't load
; any graphics, since the Diglett aren't in the Top half of the Red Field.
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

HitRightDiglett3Times: ; 0x14920
	ld hl, wNumDugtrioTriples
	call Increment_Max100
	jr nc, .asm_14937
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_14937
	ld a, $1
	ld [wd55a], a
	callba StartMapMoveMode
	ret

HitLeftDiglett3Times: ; 0x14947
	ld hl, wNumDugtrioTriples
	call Increment_Max100
	jr nc, .asm_1495e
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_1495e
	xor a
	ld [wd55a], a
	callba StartMapMoveMode
	ret

AddScoreForHittingDiglett: ; 0x1496d
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

Func_14990: ; 0x14990
	ld a, [wd4ef]
	and a
	jr nz, .asm_149b6
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_149a2
	dec a
	ld [wLeftMapMoveDiglettAnimationCounter], a
	jr .asm_149b6

.asm_149a2
	call Func_1130
	ret nz
	ld a, $14
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, [wLeftMapMoveDiglettFrame]
	xor $1
	ld [wLeftMapMoveDiglettFrame], a
	call LoadDiglettGraphics
.asm_149b6
	ld a, [wd4f1]
	and a
	ret nz
	ld a, [wRightMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_149c6
	dec a
	ld [wRightMapMoveDiglettAnimationCounter], a
	ret

.asm_149c6
	call Func_1130
	ret nz
	ld a, $14
	ld [wRightMapMoveDiglettAnimationCounter], a
	ld a, [wRightMapMoveDiglettFrame]
	xor $1
	ld [wRightMapMoveDiglettFrame], a
	add $3
	; fall through
LoadDiglettGraphics: ; 0x149d9
	sla a
	ld c, a
	ld b, $0
	ld hl, TileListDataPointers_14a11
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_149e9
	ld hl, TileListDataPointers_14a83
.asm_149e9
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, BANK(TileListDataPointers_14a11)
	call Func_10aa
	ret

LoadDiglettNumberGraphics: ; 0x149f5
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_14af5
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_14a05
	ld hl, TileListDataPointers_14c8d
.asm_14a05
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, BANK(Data_14af5)
	call Func_10aa
	ret

INCLUDE "data/queued_tiledata/red_field/diglett.asm"

ResolveVoltorbCollision: ; 0x14d85
	ld a, [wWhichVoltorb]
	and a
	jr z, .noVoltorbCollision
	xor a
	ld [wWhichVoltorb], a
	call Func_14dc9
	ld a, $10
	ld [wVoltorbHitAnimationDuration], a
	ld a, [wWhichVoltorbId]
	sub $3
	ld [wWhichAnimatedVoltorb], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.noVoltorbCollision
	ld a, [wVoltorbHitAnimationDuration]
	and a
	ret z
	dec a
	ld [wVoltorbHitAnimationDuration], a
	ret nz
	ld a, $ff
	ld [wWhichAnimatedVoltorb], a
	ret

Func_14dc9: ; 0x14dc9
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

ResolveRedStageSpinnerCollision: ; 0x14dea
	ld a, [wSpinnerCollision]
	and a
	jr z, UpdateRedStageSpinner
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

UpdateRedStageSpinner: ; 0x14e10
	ld hl, wd50b
	ld a, [hli]
	or [hl]
	ret z
	ld a, [wd50b]
	ld c, a
	ld a, [wd50c]
	ld b, a
	bit 7, b
	jr nz, .asm_14e2e
	ld a, c
	sub $7
	ld c, a
	ld a, b
	sbc $0
	ld b, a
	jr nc, .asm_14e3b
	jr .asm_14e38

.asm_14e2e
	ld a, c
	add $7
	ld c, a
	ld a, b
	adc $0
	ld b, a
	jr nc, .asm_14e3b
.asm_14e38
	ld bc, $0000
.asm_14e3b
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
	jr z, .asm_14e5e
	add $18
	ld c, $1
	jr .asm_14e66

.asm_14e5e
	cp $18
	jr c, .asm_14e66
	sub $18
	ld c, $1
.asm_14e66
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
	jr nz, .asm_14e8a
	call PlaySpinnerChargingSoundEffect_RedField
	ret

.asm_14e8a
	inc a
	ld [wPikachuSaverCharge], a
	call PlaySpinnerChargingSoundEffect_RedField
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_14e9d
	ld a, $64
	ld [wd51e], a
.asm_14e9d
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	call UpdateSpinnerChargeGraphics_RedField
	ret

PlaySpinnerChargingSoundEffect_RedField: ; 0x14ea7
	ld a, [wd51e]
	and a
	ret nz
	ld a, [wPikachuSaverCharge]
	ld c, a
	ld b, $0
	ld hl, SpinnerChargingSoundEffectIds_RedField
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

SpinnerChargingSoundEffectIds_RedField:
	db $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $11

UpdateSpinnerChargeGraphics_RedField: ; 0x14ece
; Loads the correct graphics that show the lightning bolt icon for the spinner's current charge.
	ld a, [wPikachuSaverCharge]
	ld c, a
	sla c
	ld b, $0
	ld hl, TileDataPointers_14eeb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_14ee1
	ld hl, TileDataPointers_1509b
.asm_14ee1
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(TileDataPointers_14eeb)
	call Func_10aa
	ret

INCLUDE "data/queued_tiledata/red_field/spinner.asm"

ResolveCAVELightCollision_RedField: ; 0x151cb
	ld a, [wWhichCAVELight]
	and a
	jr z, .asm_15229
	xor a
	ld [wWhichCAVELight], a
	ld a, [wCAVELightsBlinking]
	and a
	jr nz, .asm_15229
	ld a, [wWhichCAVELightId]
	sub $a
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
	jr z, LoadCAVELightsGraphics_RedField
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
	jr LoadCAVELightsGraphics_RedField

.asm_15229
	call UpdateCAVELightsBlinking_RedField
	ret z
	; fall through

LoadCAVELightsGraphics_RedField: ; 0x1522d
; Loads the graphics for each of the 4 CAVE lights, depending on what their current toggled state is.
	ld hl, wCAVELightStates + 3
	ld b, $4
.loop
	ld a, [hld]
	push hl
	call LoadCAVELightGraphics_RedField
	pop hl
	dec b
	jr nz, .loop
	ret

LoadCAVELightGraphics_RedField: ; 0x1523c
; Loads a graphics for single CAVE light.
; Input: a = toggle state for CAVE light
	and a
	jr z, .toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOnGameboy
	ld hl, TileDataPointers_152dd
	jr .load

.toggledOnGameboy
	ld hl, TileDataPointers_1531d
	jr .load

.toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOffGameboy
	ld hl, TileDataPointers_152e5
	jr .load

.toggledOffGameboy
	ld hl, TileDataPointers_15325
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
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

UpdateCAVELightsBlinking_RedField: ; 0x15270
	ld a, [wCAVELightsBlinking]
	and a
	jr z, .notBlinking
	ld a, [wCAVELightsBlinkingFramesRemaining]
	dec a
	ld [wCAVELightsBlinkingFramesRemaining], a
	jr nz, .asm_1528d
	ld [wCAVELightsBlinking], a
	ld a, $1
	ld [wd608], a
	ld a, $3
	ld [wd607], a
	xor a
.asm_1528d
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

INCLUDE "data/queued_tiledata/red_field/cave_lights.asm"

ResolveBallUpgradeTriggersCollision_RedField: ; 0x1535d
	ld a, [wWhichPinballUpgradeTrigger]
	and a
	jp z, .updatePinballUpgradeTriggersAnimation
	xor a
	ld [wWhichPinballUpgradeTrigger], a
	ld a, [wStageCollisionState]
	bit 0, a
	jp z, .updatePinballUpgradeTriggersAnimation
	ld a, [wBallUpgradeTriggersBlinking]
	and a
	jp nz, .updatePinballUpgradeTriggersAnimation
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	call Func_159c9
	ld a, $b
	callba Func_10000
	ld a, [wWhichPinballUpgradeTriggerId]
	sub $e
	ld c, a
	ld b, $0
	ld hl, wBallUpgradeTriggerStates
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
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
	jp LoadPinballUpgradeTriggersGraphics_RedField

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
	ld de, FieldMultiplierText
	ld hl, wScrollingText1
	call LoadScrollingText
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgressionRedField
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
	call TransitionPinballUpgrade
	jr LoadPinballUpgradeTriggersGraphics_RedField

.updatePinballUpgradeTriggersAnimation
	call UpdatePinballUpgradeBlinkingAnimation_RedField
	ret z

LoadPinballUpgradeTriggersGraphics_RedField
; Loads the on or off graphics for each of the 3 pinball upgrade trigger dots, depending on their current toggle state.
	ld a, [wStageCollisionState]
	bit 0, a
	ret z
	ld hl, wBallUpgradeTriggerStates + 2
	ld b, $3
.loop
	ld a, [hld]
	push hl
	call LoadPinballUpgradeTriggerGraphics_RedField
	pop hl
	dec b
	jr nz, .loop
	ret

LoadPinballUpgradeTriggerGraphics_RedField: ; 0x15465
; Loads the on or off graphics for one of the 3 pinball upgrade trigger dots, depending on its current toggle state.
; Input: a = toggle state
	and a
	jr z, .toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOnGameboy
	ld hl, TileDataPointers_15511
	jr .load

.toggledOnGameboy
	ld hl, TileDataPointers_15543
	jr .load

.toggledOff
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .toggledOffGameboy
	ld hl, TileDataPointers_15517
	jr .load

.toggledOffGameboy
	ld hl, TileDataPointers_15549
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
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

LoadDisabledPinballUpgradeTriggerGraphics_RedField: ; 0x15499
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld b, $3
.loop
	push hl
	xor a
	call LoadPinballUpgradeTriggerGraphics_RedField
	pop hl
	dec b
	jr nz, .loop
	ret

UpdatePinballUpgradeBlinkingAnimation_RedField: ; 0x154a9
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

BallTypeProgressionRedField: ; 0x15505
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

BallTypeDegradationRedField: ; 0x1550b
; Determines the previous upgrade for the Ball.
	db POKE_BALL   ; POKE_BALL -> POKE_BALL
	db POKE_BALL   ; unused
	db POKE_BALL   ; GREAT_BALL -> POKE_BALL
	db GREAT_BALL  ; ULTRA_BALL -> GREAT_BALL
	db ULTRA_BALL  ; unused
	db ULTRA_BALL  ; MASTER_BALL -> GREAT_BALL

INCLUDE "data/queued_tiledata/red_field/ball_upgrade_triggers.asm"

UpdateBallTypeUpgradeCounter_RedField: ; 0x15575
	ld a, [wCapturingMon]
	and a
	ret nz
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
	ld hl, BallTypeDegradationRedField
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
	call TransitionPinballUpgrade
	ret

TransitionPinballUpgrade: ; 0x155a7
	ld a, [wBallType]
	ld c, a
	sla c
	ld b, $0
	ld hl, PinballUpgradeTransition_TileDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(PinballUpgradeTransition_TileDataPointers)
	call Func_10aa
	; fall through

TransitionPinballUpgradePalette: ; 0x155bb
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	; gameboy color
	ld a, [wBallType]
	sla a
	ld c, a
	ld b, $0
	ld hl, PinballUpgradeTransitionPalettes
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, BANK(PinballUpgradeTransitionPalettes)
	ld de, LoadPalettes
	call Func_10c5
	ret

INCLUDE "data/queued_tiledata/ball_upgrade.asm"

ResolveRedStageBoardTriggerCollision: ; 0x1581f
	ld a, [wWhichBoardTrigger]
	and a
	ret z
	xor a
	ld [wWhichBoardTrigger], a
	ld bc, FivePoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wWhichBoardTriggerId]
	sub $11
	ld c, a
	ld b, $0
	ld hl, wCollidedAlleyTriggers
	add hl, bc
	ld [hl], $1
	ld a, [wCollidedAlleyTriggers + 0]
	and a
	call nz, HandleSecondaryLeftAlleyTrigger_RedField
	ld a, [wCollidedAlleyTriggers + 1]
	and a
	call nz, HandleThirdLeftAlleyTrigger_RedField
	ld a, [wCollidedAlleyTriggers + 2]
	and a
	call nz, HandleSecondaryStaryuAlleyTrigger_RedField
	ld a, [wCollidedAlleyTriggers + 3]
	and a
	call nz, HandleLeftAlleyTrigger_RedField
	ld a, [wCollidedAlleyTriggers + 4]
	and a
	call nz, HandleStaryuAlleyTrigger_RedField
	; Ball passed over the second Staryu alley trigger point in the Red Field.
	ld a, [wCollidedAlleyTriggers + 5]
	and a
	call nz, HandleSecondaryRightAlleyTrigger_RedField
	ld a, [wCollidedAlleyTriggers + 6]
	and a
	call nz, HandleRightAlleyTrigger_RedField
	ld a, [wCollidedAlleyTriggers + 7]
	and a
	call nz, Func_15990
	ret

HandleSecondaryLeftAlleyTrigger_RedField: ; 0x1587c
; Ball passed over the secondary left alley trigger point in the Red Field.
; This is the trigger that is covered up by Ditto when evolution mode isn't available.
	xor a
	ld [wCollidedAlleyTriggers + 0], a
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
	set 7, a
	ld [wIndicatorStates], a
	cp $83
	ret nz
	ld a, [wStageCollisionState]
	and $1
	or $6
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

HandleThirdLeftAlleyTrigger_RedField: ; 0x158c0
; Ball passed over the third left alley trigger point in the Red Field.
; This is the trigger that is NOT covered up by Ditto when evolution mode isn't available. It's located just to to the left of the top of the Voltorg area.
	xor a
	ld [wCollidedAlleyTriggers + 1], a
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
	set 7, a
	ld [wIndicatorStates], a
	cp $83
	ret nz
	ld a, [wStageCollisionState]
	and $1
	or $6
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

HandleSecondaryStaryuAlleyTrigger_RedField: ; 0x15904
; Ball passed over the second Staryu alley trigger point in the Red Field.
	xor a
	ld [wCollidedAlleyTriggers + 2], a
	ld a, [wSecondaryLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $3
	callba Func_10000
	ret

HandleLeftAlleyTrigger_RedField: ; 0x1591e
; Ball passed over the left alley trigger point in the Red Field.
	xor a
	ld [wCollidedAlleyTriggers + 3], a
	ld [wRightAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wLeftAlleyTrigger], a
	call Func_159c9
	ret

HandleStaryuAlleyTrigger_RedField: ; 0x15931
; Ball passed over the first Staryu alley trigger point in the Red Field.
	xor a
	ld [wCollidedAlleyTriggers + 4], a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	ld [wSecondaryLeftAlleyTrigger], a
	call Func_159c9
	ret

HandleSecondaryRightAlleyTrigger_RedField: ; 0x15944
; Ball passed over the secondary right alley trigger point in the Red Field.
	xor a
	ld [wCollidedAlleyTriggers + 5], a
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
	jr z, .asm_1596e
	set 7, a
.asm_1596e
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

HandleRightAlleyTrigger_RedField: ; 0x1597d
; Ball passed over the right alley trigger point in the Red Field.
	xor a
	ld [wCollidedAlleyTriggers + 6], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wRightAlleyTrigger], a
	call Func_159c9
	ret

Func_15990: ; 0x15990
	xor a
	ld [wCollidedAlleyTriggers + 7], a
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
	jr z, .asm_159ba
	set 7, a
.asm_159ba
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

Func_159c9: ; 0x159c9
	ld a, [wd7ad]
	bit 7, a
	ret nz
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	ld a, $ff
	ld [wd7ad], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ld a, $1
	ld [wd580], a
	call Func_1404a
	ret

Func_159f4: ; 0x159f4
	ld a, [hLCDC]
	bit 7, a
	jr z, .asm_15a13
	ld a, [wd7f2]
	and $fe
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	cp c
	jr z, .asm_15a13
	add c
	cp $2
	jr z, .asm_15a13
	lb de, $00, $00
	call PlaySoundEffect
.asm_15a13
	ld a, [wd7f2]
	swap a
	ld c, a
	ld a, [wStageCollisionState]
	sla a
	or c
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_15a3f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_15a2d
	ld hl, TileDataPointers_15d05
.asm_15a2d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_15a3f)
	call Func_10aa
	ld a, [wStageCollisionState]
	ld [wd7f2], a
	ret

TileDataPointers_15a3f:
	dw $0000
	dw TileData_15b71
	dw TileData_15b16
	dw TileData_15abf
	dw TileData_15b23
	dw TileData_15adc
	dw TileData_15b2a
	dw TileData_15af3
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b16
	dw $0000
	dw TileData_15b23
	dw $0000
	dw TileData_15b2a
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b71
	dw TileData_15b3d
	dw $0000
	dw TileData_15b50
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b82
	dw $0000
	dw $0000
	dw TileData_15b3d
	dw $0000
	dw TileData_15b50
	dw $0000
	dw $0000
	dw TileData_15b57
	dw $0000
	dw $0000
	dw TileData_15b71
	dw TileData_15b2a
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b57
	dw TileData_15b82
	dw $0000
	dw $0000
	dw TileData_15b2a
	dw $0000
	dw $0000
	dw TileData_15b6a
	dw $0000
	dw TileData_15b3d
	dw $0000
	dw $0000
	dw TileData_15b71
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b6a
	dw $0000
	dw TileData_15b3d
	dw TileData_15b82
	dw $0000

TileData_15abf: ; 0x15abf
	db $e
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51

TileData_15adc: ; 0x15adc
	db $0b
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51
	dw TileData_15ce7
	dw TileData_15cf1
	dw TileData_15cfb

TileData_15af3: ; 0x15af3
	db $11
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51
	dw TileData_15cab
	dw TileData_15cb5
	dw TileData_15cbf

TileData_15b16: ; 0x15b16
	db $06
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5

TileData_15b23: ; 0x15b23
	db $03
	dw TileData_15ce7
	dw TileData_15cf1
	dw TileData_15cfb

TileData_15b2a: ; 0x15b2a
	db $09
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15cab
	dw TileData_15cb5
	dw TileData_15cbf

TileData_15b3d: ; 0x15b3d
	db $09
	dw TileData_15bcf
	dw TileData_15bd9
	dw TileData_15be3
	dw TileData_15bed
	dw TileData_15bf7
	dw TileData_15c01
	dw TileData_15ce7
	dw TileData_15cf1
	dw TileData_15cfb

TileData_15b50: ; 0x15b50
	db $03
	dw TileData_15cab
	dw TileData_15cb5
	dw TileData_15cbf

TileData_15b57: ; 0x15b57
	db $09
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15cc9
	dw TileData_15cd3
	dw TileData_15cdd

TileData_15b6a: ; 0x15b6a
	db $03
	dw TileData_15cc9
	dw TileData_15cd3
	dw TileData_15cdd

TileData_15b71: ; 0x15b71
	db $08
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51

TileData_15b82: ; 0x15b82
	db $08
	dw TileData_15c5b
	dw TileData_15c65
	dw TileData_15c6f
	dw TileData_15c79
	dw TileData_15c83
	dw TileData_15c8d
	dw TileData_15c97
	dw TileData_15ca1

TileData_15b93: ; 0x15b93
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15b9d: ; 0x15b9d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15ba7: ; 0x15ba7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bb1: ; 0x15bb1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $90
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bbb: ; 0x15bbb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $50
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bc5: ; 0x15bc5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $53
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bcf: ; 0x15bcf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldTopBaseGameBoyGfx + $9a0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15bd9: ; 0x15bd9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldTopBaseGameBoyGfx + $9d0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15be3: ; 0x15be3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4A
	dw StageRedFieldTopBaseGameBoyGfx + $a00
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15bed: ; 0x15bed
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4D
	dw StageRedFieldTopBaseGameBoyGfx + $a30
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15bf7: ; 0x15bf7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $50
	dw StageRedFieldTopBaseGameBoyGfx + $a60
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c01: ; 0x15c01
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $53
	dw StageRedFieldTopBaseGameBoyGfx + $a90
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c0b: ; 0x15c0b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $56
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $120
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c15: ; 0x15c15
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $59
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $150
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c1f: ; 0x15c1f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $180
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c29: ; 0x15c29
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c33: ; 0x15c33
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $62
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c3d: ; 0x15c3d
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $65
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $210
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c47: ; 0x15c47
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $66
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $620
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c51: ; 0x15c51
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $69
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $650
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c5b: ; 0x15c5b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $56
	dw StageRedFieldTopBaseGameBoyGfx + $ac0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c65: ; 0x15c65
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $59
	dw StageRedFieldTopBaseGameBoyGfx + $af0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c6f: ; 0x15c6f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5C
	dw StageRedFieldTopBaseGameBoyGfx + $b20
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c79: ; 0x15c79
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5F
	dw StageRedFieldTopBaseGameBoyGfx + $b50
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c83: ; 0x15c83
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $62
	dw StageRedFieldTopBaseGameBoyGfx + $b80
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c8d: ; 0x15c8d
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $65
	dw StageRedFieldTopBaseGameBoyGfx + $bb0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c97: ; 0x15c97
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $66
	dw StageRedFieldTopBaseGameBoyGfx + $bc0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15ca1: ; 0x15ca1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $69
	dw StageRedFieldTopBaseGameBoyGfx + $bf0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15cab: ; 0x15cab
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cb5: ; 0x15cb5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cbf: ; 0x15cbf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $72
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $310
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cc9: ; 0x15cc9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6C
	dw StageRedFieldTopBaseGameBoyGfx + $c20
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15cd3: ; 0x15cd3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6F
	dw StageRedFieldTopBaseGameBoyGfx + $c50
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15cdd: ; 0x15cdd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $72
	dw StageRedFieldTopBaseGameBoyGfx + $c80
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15ce7: ; 0x15ce7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $220
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cf1: ; 0x15cf1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $250
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cfb: ; 0x15cfb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $72
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $280
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_15d05:
	dw $0000
	dw TileData_15db1
	dw TileData_15d96
	dw TileData_15d85
	dw TileData_15d99
	dw TileData_15d8a
	dw TileData_15d9c
	dw TileData_15d8f
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15d96
	dw $0000
	dw TileData_15d99
	dw $0000
	dw TileData_15d9c
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15db1
	dw TileData_15da1
	dw $0000
	dw TileData_15da6
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15db4
	dw $0000
	dw $0000
	dw TileData_15da1
	dw $0000
	dw TileData_15da6
	dw $0000
	dw $0000
	dw TileData_15da9
	dw $0000
	dw $0000
	dw TileData_15db1
	dw TileData_15d9c
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15da9
	dw TileData_15db4
	dw $0000
	dw $0000
	dw TileData_15d9c
	dw $0000
	dw $0000
	dw TileData_15dae
	dw $0000
	dw TileData_15da1
	dw $0000
	dw $0000
	dw TileData_15db1
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15dae
	dw $0000
	dw TileData_15da1
	dw TileData_15db4
	dw $0000

TileData_15d85: ; 0x15d85
	db $02
	dw TileData_15db7
	dw TileData_15df2

TileData_15d8a: ; 0x15d8a
	db $02
	dw TileData_15df2
	dw TileData_15e82

TileData_15d8f: ; 0x15d8f
	db $03
	dw TileData_15db7
	dw TileData_15df2
	dw TileData_15e50

TileData_15d96: ; 0x15d96
	db $01
	dw TileData_15db7

TileData_15d99: ; 0x15d99
	db $01
	dw TileData_15e82

TileData_15d9c: ; 0x15d9c
	db $02
	dw TileData_15db7
	dw TileData_15e50

TileData_15da1: ; 0x15da1
	db $02
	dw TileData_15dd5
	dw TileData_15e82

TileData_15da6: ; 0x15da6
	db $01
	dw TileData_15e50

TileData_15da9: ; 0x15da9
	db $02
	dw TileData_15db7
	dw TileData_15e69

TileData_15dae: ; 0x15dae
	db $01
	dw TileData_15e69

TileData_15db1: ; 0x15dab1
	db $01
	dw TileData_15df2

TileData_15db4: ; 0x15db4
	db $01
	dw TileData_15e21

TileData_15db7: ; 0x15db7
	dw Func_1198

	db ($a << 1)
	db $03
	dw vBGMap + $4c

	db ($40 << 1)
	db $09
	dw vBGMap + $6c

	db (($32 << 1) | 1)
	db $08
	dw vBGMap + $8d

	db (4 << 1)
	dw vBGMap + $ae

	db (2 << 1)
	dw vBGMap + $d0

	db (2 << 1)
	dw vBGMap + $f1

	db (2 << 1)
	dw vBGMap + $111

	db (1 << 1)
	dw vBGMap + $132

	db $00 ; terminator

TileData_15dd5: ; 0x15dd5
	dw Func_1198

	db ($a << 1)
	db $03
	dw vBGMap + $4c

	db (($28 << 1) | 1)
	db $08
	dw vBGMap + $6c

	db ($4 << 1)
	dw vBGMap + $8d

	db ($04 << 1)
	dw vBGMap + $ae

	db ($02 << 1)
	dw vBGMap + $d0

	db ($02 << 1)
	dw vBGMap + $f1

	db ($02 << 1)
	dw vBGMap + $111

	db (1 << 1)
	dw vBGMap + $132

	db $00 ; terminator

TileData_15df2: ; 0x15df2
	dw LoadTileLists
	db $19 ; total number of tiles

	db $05 ; number of tiles
	dw vBGMap + $a9
	db $1e, $1f, $20, $21, $22

	db $07
	dw vBGMap + $c7
	db $23, $24, $39, $3a, $25, $3b, $26

	db $08 ; number of tiles
	dw vBGMap + $e6
	db $27, $37, $28, $29, $2a, $2b, $3c, $2c

	db $03 ; number of tiles
	dw vBGMap + $106
	db $2d, $38, $2e

	db $01 ; number of tiles
	dw vBGMap + $10d
	db $2f

	db $01 ; number of tiles
	dw vBGMap + $126
	db $30

	db 00 ; terminator

TileData_15e21: ; 0x15e21
	dw LoadTileLists
	db $19 ; total number of tiles

	db $05 ; number of tiles
	dw vBGMap + $a9
	db $0b, $0c, $0d, $0e, $0f

	db $07
	dw vBGMap + $c7
	db $10, $11, $33, $34, $12, $35, $13

	db $08 ; number of tiles
	dw vBGMap + $e6
	db $14, $31, $15, $16, $17, $18, $36, $19

	db $03 ; number of tiles
	dw vBGMap + $106
	db $1a, $32, $1b

	db $01 ; number of tiles
	dw vBGMap + $10d
	db $1c

	db $01 ; number of tiles
	dw vBGMap + $126
	db $1d

	db 00 ; terminator

TileData_15e50: ; 0x15e50
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $100
	db $45, $46, $22

	db $02 ; number of tiles
	dw vBGMap + $120
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $140
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $160
	db $45, $46

	db $00 ; terminator

TileData_15e69: ; 0x15e69
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $100
	db $43, $44, $22

	db $02 ; number of tiles
	dw vBGMap + $120
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $140
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $160
	db $45, $46

	db $00 ; terminator

TileData_15e82: ; 0x15e82
	dw Func_1198

	db ((4 << 1) | 1)
	db $07
	dw vBGMap + $100

	db (($23 << 1) | 1)
	db $04
	dw vBGMap + $120

	db (2 << 1)
	dw vBGMap + $140

	db (2 << 1)
	dw vBGMap + $160

	db $00 ; terminator

ResolveBellsproutCollision: ; 0x15e93
	ld a, [wBellsproutCollision]
	and a
	jr z, .asm_15eda
	xor a
	ld [wBellsproutCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, BellsproutAnimationData
	ld de, wBellsproutAnimation
	call InitAnimation
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $7c
	ld [wBallXPos + 1], a
	ld a, $78
	ld [wBallYPos + 1], a
	xor a
	ld [wEnableBallGravityAndTilt], a
.asm_15eda
	ld hl, BellsproutAnimationData
	ld de, wBellsproutAnimation
	call UpdateAnimation
	push af
	ld a, [wBellsproutAnimationFrameCounter]
	and a
	jr nz, .asm_15ef8
	ld a, $19
	ld [wBellsproutAnimationFrameCounter], a
	xor a
	ld [wBellsproutAnimationFrame], a
	ld a, $6
	ld [wBellsproutAnimationIndex], a
.asm_15ef8
	pop af
	ret nc
	ld a, [wBellsproutAnimationIndex]
	cp $1
	jr nz, .asm_15f35
	xor a
	ld [wPinballIsVisible], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .noCatchEmMode
	ld a, $8
	jr nz, .startCatchEmMode
	xor a
.startCatchEmMode
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
.noCatchEmMode
	ld hl, wNumBellsproutEntries
	call Increment_Max100
	ret nc
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
	ret

.asm_15f35
	ld a, [wBellsproutAnimationIndex]
	cp $4
	jr nz, .asm_15f42
	ld a, $1
	ld [wPinballIsVisible], a
	ret

.asm_15f42
	ld a, [wBellsproutAnimationIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wEnableBallGravityAndTilt], a
	xor a
	ld [wBallXVelocity + 1], a
	ld a, $2
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, $5
	callba Func_10000
	ret

BellsproutAnimationData: ; 0x15f69
; Each entry is [duration][OAM id]
	db $08, $01
	db $06, $02
	db $20, $03
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
	db $00  ; terminator

ResolveRedStageBumperCollision: ; 0x15f86
	ld a, [wWhichBumper]
	and a
	jr z, .asm_15f99
	call LoadBumperCollisionGraphics_RedField
	call Func_15fa6
	xor a
	ld [wWhichBumper], a
	call ApplyBumperCollision_RedField
.asm_15f99
	ld a, [wd4da]
	and a
	ret z
	dec a
	ld [wd4da], a
	call z, LoadBumperCollisionGraphics_RedField
	ret

Func_15fa6: ; 0x15fa6
	ld a, $10
	ld [wd4da], a
	ld a, [wWhichBumperId]
	sub $6
	ld [wd4db], a
	sla a
	inc a
	jr asm_15fc0

LoadBumperCollisionGraphics_RedField: ; 0x5fb8
	ld a, [wd4db]
	cp $ff
	ret z
	sla a
asm_15fc0
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_16010
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_15fd0
	ld hl, TileData_16080
.asm_15fd0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_16010)
	call Func_10aa
	ret

ApplyBumperCollision_RedField: ; 0x15fda
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
	sub $6
	ld c, a
	ld b, $0
	ld hl, BumperCollisionAngleDeltas_RedField
	add hl, bc
	ld a, [wCollisionForceAngle]
	add [hl]
	ld [wCollisionForceAngle], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

BumperCollisionAngleDeltas_RedField:
	db -8, 8

INCLUDE "data/queued_tiledata/red_field/bumpers.asm"

ResolveDittoSlotCollision: ; 0x160f0
	ld a, [wDittoSlotCollision]
	and a
	jr z, .asm_16137
	xor a
	ld [wDittoSlotCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $21
	call PlaySoundEffect
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wEnableBallGravityAndTilt], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $11
	ld [wBallXPos + 1], a
	ld a, $23
	ld [wBallYPos + 1], a
	ld a, $10
	ld [wd600], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
.asm_16137
	ld a, [wd600]
	and a
	ret z
	dec a
	ld [wd600], a
	cp $f
	jr nz, .asm_1614f
	callba LoadMiniBallGfx
	ret

.asm_1614f
	cp $c
	jr nz, .asm_1615e
	callba Func_dd62
	ret

.asm_1615e
	cp $9
	jr nz, .asm_1616d
	xor a
	ld [wPinballIsVisible], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_1616d
	cp $6
	jr nz, .asm_1618e
	callba StartEvolutionMode
	ld a, $1
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

.asm_1618e
	cp $3
	jr nz, .asm_1619d
	callba LoadMiniBallGfx
	ret

.asm_1619d
	and a
	ret nz
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ret

Func_161af: ; 0x161af
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
	jr asm_1620f

Func_161e0: ; 0x161e0
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
asm_1620f: ; 0x1620f
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
	jr z, .asm_1624e
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1624e
	pop hl
	bit 7, h
	jr z, .asm_1625a
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1625a
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

Func_16279: ; 0x16279
	ld a, [wSlotCollision]
	and a
	jr z, .asm_162ae
	xor a
	ld [wSlotCollision], a
	ld a, [wd604]
	and a
	ret z
	ld a, [wd603]
	and a
	jr nz, .asm_162ae
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
	ld [wd603], a
.asm_162ae
	ld a, [wd603]
	and a
	ret z
	dec a
	ld [wd603], a
	ld a, $18
	ld [wd606], a
	ld a, [wd603]
	cp $12
	jr nz, .asm_162d4
	lb de, $00, $21
	call PlaySoundEffect
	callba LoadMiniBallGfx
	ret

.asm_162d4
	cp $f
	jr nz, .asm_162e3
	callba Func_dd62
	ret

.asm_162e3
	cp $c
	jr nz, .asm_162f2
	xor a
	ld [wPinballIsVisible], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_162f2
	cp $9
	jr nz, .asm_162fa
	call Func_16352
	ret

.asm_162fa
	cp $6
	jr nz, .asm_16317
	xor a
	ld [wd604], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	callba LoadMiniBallGfx
	ret

.asm_16317
	cp $3
	jr nz, .asm_16330
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	ret

.asm_16330
	and a
	ret nz
	call Func_16425
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

Func_16352: ; 0x16352
	xor a
	ld [wIndicatorStates + 4], a
	ld a, $d
	callba Func_10000
	jr nc, .asm_1636d
	ld a, $1
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ret

.asm_1636d
	ld a, [wPreviousNumPokeballs]
	cp $3
	jr nz, .asm_163b3
	ld a, [wd607]
	and a
	jr nz, .asm_163b3
.asm_1637a
	ld a, [wBonusStageSlotRewardActive]
	and a
	jr nz, .asm_16389
	xor a
	ld [wNumPokeballs], a
	ld a, $40
	ld [wPokeballBlinkingCounter], a
.asm_16389
	xor a
	ld [wBonusStageSlotRewardActive], a
	ld a, $1
	ld [wd495], a
	ld [wd4ae], a
	ld a, [wd498]
	ld c, a
	ld b, $0
	ld hl, GoToBonusStageTextIds_RedField
	add hl, bc
	ld a, [hl]
	ld [wd497], a
	call Func_163f2
	xor a
	ld [wd609], a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ld a, $1e
	ld [wd607], a
	ret

.asm_163b3
	callba Func_ed8e
	xor a
	ld [wd608], a
	ld a, [wd61d]
	cp $d
	jr nc, .asm_1637a
	ld a, $1
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ld a, [wCatchEmOrEvolutionSlotRewardActive]
	cp EVOLUTION_MODE_SLOT_REWARD
	ret nz
	callba StartEvolutionMode
	ld a, [wd7ad]
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	xor a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

Func_163f2: ; 0x163f2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	ld a, [wd497]
	ld de, GoToDiglettStageText
	cp STAGE_DIGLETT_BONUS
	jr z, .asm_1640f
	ld de, GoToGengarStageText
	cp STAGE_GENGAR_BONUS
	jr z, .asm_1640f
	ld de, GoToMewtwoStageText
.asm_1640f
	call LoadScrollingText
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $3c, $23
	call PlaySoundEffect
	ret

GoToBonusStageTextIds_RedField:
	db STAGE_GENGAR_BONUS
	db STAGE_MEWTWO_BONUS
	db STAGE_MEOWTH_BONUS
	db STAGE_DIGLETT_BONUS
	db STAGE_SEEL_BONUS

Func_16425: ; 0x16425
	ld a, [wCurrentStage]
	and $1
	sla a
	ld c, a
	ld a, [wd604]
	add c
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1644d
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_16441
	ld hl, TileDataPointers_164a1
.asm_16441
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1644d)
	call Func_10aa
	ret

TileDataPointers_1644d:
	dw TileData_16455
	dw TileData_16458
	dw TileData_1645b
	dw TileData_16460

TileData_16455: ; 0x16455
	db $01
	dw TileData_16465

TileData_16458: ; 0x16458
	db $01
	dw TileData_1646f

TileData_1645b: ; 0x1645b
	db $02
	dw TileData_16479
	dw TileData_16483

TileData_16460: ; 0x16460
	db $02
	dw TileData_1648D
	dw TileData_16497

TileData_16465: ; 0x16465
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldTopBaseGameBoyGfx + $1c0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_1646f: ; 0x1646f
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $340
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16479: ; 0x16479
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $48
	dw StageRedFieldBottomBaseGameBoyGfx + $c80
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16483: ; 0x16483
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $4A
	dw StageRedFieldBottomBaseGameBoyGfx + $CA0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_1648D: ; 0x1648D
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $340
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16497: ; 0x16497
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $4A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $360
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_164a1:
	dw TileData_164a9
	dw TileData_164ac
	dw TileData_164af
	dw TileData_164b2

TileData_164a9: ; 0x164a9
	db $01
	dw TileData_164b5

TileData_164ac: ; 0x164ac
	db $01
	dw TileData_164be

TileData_164af: ; 0x164af
	db $01
	dw TileData_164c7

TileData_164b2: ; 0x164b2
	db $01
	dw TileData_164d5

TileData_164b5: ; 0x164b5
	dw LoadTileLists
	db $02

	db $02
	dw vBGMap + $229
	db $d4, $d5

	db $00

TileData_164be: ; 0x164be
	dw LoadTileLists
	db $02

	db $02

	dw vBGMap + $229
	db $d6, $d7

	db $00

TileData_164c7: ; 0x164c7
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $9
	db $38, $39

	db $02
	dw vBGMap + $29
	db $3a, $3b

	db $00

TileData_164d5: ; 0x164d5
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $9
	db $3c, $3d

	db $02
	dw vBGMap + $29
	db $3e, $3f

	db $00

Func_164e3: ; 0x164e3
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
	jr z, .asm_164ff
	ld a, [wd498]
	add $15
	jr .asm_16506

.asm_164ff
	ld a, [wd608]
	and a
	ret z
	ld a, $1a
.asm_16506
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
	call nz, Func_16425
	ret

ResolveRedStagePinballLaunchCollision: ; 0x1652d
	ld a, [wPinballLaunchCollision]
	and a
	ret z
	xor a
	ld [wPinballLaunchCollision], a ; set to 0, so we only check for a launch once per frame
	ld a, [wPinballLaunched]
	and a
	jr z, .notLaunchedYet
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hl], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld a, $80
	ld [wBallYVelocity], a
	ld a, $fa
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wEnableBallGravityAndTilt], a
	lb de, $00, $0a
	call PlaySoundEffect
.notLaunchedYet
	ld a, $ff
	ld [wPreviousTriggeredGameObject], a
	ld a, [wPinballLaunched]
	and a
	ret nz
	ld a, [wChoseInitialMap]
	and a
	jr nz, .checkPressedKeysToLaunchBall
	call ChooseInitialMap_RedField
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

ChooseInitialMap_RedField: ; 0x1658f
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
	ld hl, RedStageInitialMaps
	add hl, bc
	ld a, [hl]
	ld [wCurrentMap], a
	push af
	lb de, $00, $48
	call PlaySoundEffect
	pop af
	add (PalletTownPic_Pointer - BillboardPicturePointers) / 3 ; map billboard pictures start at the $29th entry in BillboardPicturePointers
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

RedStageInitialMaps: ; 0x16605
	db PALLET_TOWN
	db VIRIDIAN_FOREST
	db PEWTER_CITY
	db CERULEAN_CITY
	db VERMILION_SEASIDE
	db ROCK_MOUNTAIN
	db LAVENDER_TOWN

ResolveRedStagePikachuCollision: ; 0x1660c
	ld a, [wWhichPikachu]
	and a
	jr z, .asm_1667b
	xor a
	ld [wWhichPikachu], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1667b
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	jr nz, .asm_16634
	ld a, [wWhichPikachuId]
	sub $1c
	ld hl, wd518
	cp [hl]
	jr nz, .asm_1667b
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_16667
.asm_16634
	ld hl, PikachuSaverAnimationDataBlueStage
	ld de, wPikachuSaverAnimation
	call InitAnimation
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	jr nz, .asm_16647
	xor a
	ld [wPikachuSaverCharge], a
.asm_16647
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
	jr .asm_1667b

.asm_16667
	ld hl, PikachuSaverAnimation2DataBlueStage
	ld de, wPikachuSaverAnimation
	call InitAnimation
	ld a, $2
	ld [wd51c], a
	lb de, $00, $3b
	call PlaySoundEffect
.asm_1667b
	ld a, [wd51c]
	and a
	call z, Func_16766
	call Func_1669e
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

Func_1669e: ; 0x1669e
	ld a, [wd51c]
	cp $1
	jr nz, .asm_16719
	ld hl, PikachuSaverAnimationDataBlueStage
	ld de, wPikachuSaverAnimation
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationIndex]
	cp $1
	jr nz, .asm_166f7
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
	jr nc, .asm_166f0
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_166f0
	lb de, $16, $10
	call PlaySoundEffect
	ret

.asm_166f7
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

.asm_16719
	cp $2
	jr nz, .asm_16732
	ld hl, PikachuSaverAnimation2DataBlueStage
	ld de, wPikachuSaverAnimation
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationIndex]
	cp $1
	ret nz
	xor a
	ld [wd51c], a
	ret

.asm_16732
	ld a, [hNumFramesDropped]
	swap a
	and $1
	ld [wPikachuSaverAnimationFrame], a
	ret

PikachuSaverAnimationDataBlueStage: ; 0x1673c
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

PikachuSaverAnimation2DataBlueStage: ; 0x16761
; Each entry is [duration][OAM id]
	db $0C, $02
	db $01, $00
	db $00

Func_16766: ; 0x16766
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	jr z, .asm_16774
	ld hl, wd518
	ld [hl], $0
	ret

.asm_16774
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ret z
	ld hl, wd518
	ld [hl], $1
	ret

ResolveStaryuCollision: ; 0x16781
	ld a, [wStaryuCollision]
	and a
	jr z, .asm_167bd
	xor a
	ld [wStaryuCollision], a
	ld a, [wd503]
	and a
	jr nz, .asm_167c2
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd502]
	xor $1
	set 1, a
	ld [wd502], a
	ld a, $14
	ld [wd503], a
	call Func_16859
	ld a, $6
	callba Func_10000
	ret

.asm_167bd
	ld a, [wd503]
	and a
	ret z
.asm_167c2
	dec a
	ld [wd503], a
	ret nz
	ld a, [wd502]
	res 1, a
	ld [wd502], a
	call Func_16859
	ld a, [wd502]
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	lb de, $00, $07
	call PlaySoundEffect
	ld a, [wStageCollisionState]
	bit 0, a
	jp nz, LoadPinballUpgradeTriggersGraphics_RedField
	jp LoadDisabledPinballUpgradeTriggerGraphics_RedField

Func_167ff: ; 0x167ff
	ld a, [wStaryuCollision]
	and a
	jr z, .asm_16839
	xor a
	ld [wStaryuCollision], a
	ld a, [wd503]
	and a
	jr nz, .asm_1683e
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd502]
	xor $1
	ld [wd502], a
	ld a, $14
	ld [wd503], a
	call Func_16878
	ld a, $6
	callba Func_10000
	ret

.asm_16839
	ld a, [wd503]
	and a
	ret z
.asm_1683e
	dec a
	ld [wd503], a
	ret nz
	ld a, [wd502]
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	lb de, $00, $07
	call PlaySoundEffect
	ret

Func_16859: ; 0x16859
	ld a, [wd502]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_16899
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1686c
	ld hl, TileDataPointers_16910
.asm_1686c
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_16899)
	call Func_10aa
	ret

Func_16878: ; 0x16878
	ld a, [wd502]
	and $1
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1695a
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1688d
	ld hl, TileDataPointers_16980
.asm_1688d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1695a)
	call Func_10aa
	ret

TileDataPointers_16899:
	dw TileData_168a1
	dw TileData_168a8
	dw TileData_168af
	dw TileData_168af

TileData_168a1: ; 0x168a1
	db $03
	dw TileData_168b6
	dw TileData_168c0
	dw TileData_168ca

TileData_168a8: ; 0x168a8
	db $03
	dw TileData_168d4
	dw TileData_168de
	dw TileData_168e8

TileData_168af: ; 0x168af
	db $03
	dw TileData_168f2
	dw TileData_168fc
	dw TileData_16906

TileData_168b6: ; 0x168b6
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $50
	dw StageRedFieldTopBaseGameBoyGfx + $260
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168c0: ; 0x168c0
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $53
	dw StageRedFieldTopBaseGameBoyGfx + $290
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168ca: ; 0x168ca
	dw Func_11d2
	db $10, $01
	dw vTilesSH tile $56
	dw StageRedFieldTopBaseGameBoyGfx + $2c0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168d4: ; 0x168d4
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $52
	dw StageRedFieldTopBaseGameBoyGfx + $280
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168de: ; 0x168de
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $55
	dw StageRedFieldTopBaseGameBoyGfx + $2b0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168e8: ; 0x168e8
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $50
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $EA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_168f2: ; 0x168f2
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $10E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_168fc: ; 0x168fc
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $54
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1110
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16906: ; 0x16906
	dw Func_11d2
	db $10, $01
	dw vTilesSH tile $50
	dw StageRedFieldTopBaseGameBoyGfx + $260
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileDataPointers_16910:
	dw TileData_16918
	dw TileData_1691b
	dw TileData_1691e
	dw TileData_1691e

TileData_16918: ;0x16918
	db $01
	dw TileData_16921

TileData_1691b: ;0x1691b
	db $01
	dw TileData_16934

TileData_1691e: ;0x1691e
	db $01
	dw TileData_16947

TileData_16921: ; 0x16921
	dw LoadTileLists
	db $06

	db $03
	dw vBGMap + $1C6
	db $C3, $C4, $C5

	db $02
	dw vBGMap + $1E7
	db $C6, $C7

	db $01
	dw vBGMap + $207
	db $C8

	db $00

TileData_16934: ; 0x16934
	dw LoadTileLists
	db $06

	db $03
	dw vBGMap + $1C6
	db $CD, $CE, $C5

	db $02
	dw vBGMap + $1E7
	db $C6, $C7

	db $01
	dw vBGMap + $207
	db $C8

	db $00

TileData_16947: ; 0x16947
	dw LoadTileLists
	db $06

	db $03
	dw vBGMap + $1C6
	db $C3, $C4, $C9

	db $02
	dw vBGMap + $1E7
	db $CA, $CB

	db $01
	dw vBGMap + $207
	db $CC

	db $00

TileDataPointers_1695a:
	dw TileData_1695e
	dw TileData_16961

TileData_1695e: ; 0x1695e
	db $01
	dw TileData_16964

TileData_16961: ; 0x16961
	db $01
	dw TileData_16972

TileData_16964: ; 0x16964
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $BE, $BF

	db $02
	dw vBGMap + $60
	db $C0, $C1

	db $00

TileData_16972: ; 0x16972
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $C2, $C3

	db $02
	dw vBGMap + $60
	db $C4, $C5

	db $00

TileDataPointers_16980:
	dw TileData_16984
	dw TileData_16987

TileData_16984: ; 0x16984
	db $01
	dw TileData_1698a

TileData_16987: ; 0x16987
	db $01
	dw TileData_16998

TileData_1698a: ; 0x1698a
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $BC, $BD

	db $02
	dw vBGMap + $60
	db $BE, $BF

	db $00

TileData_16998: ; 0x16998
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $C0, $C1

	db $02
	dw vBGMap + $60
	db $C2, $C3

	db $00

Func_169a6: ; 0x169a6
	ld a, [hNumFramesDropped]
	and $1f
	ret nz
	ld bc, $0000
.asm_169ae
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	bit 7, [hl]
	jr z, .asm_169c5
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 5, [hl]
	jr z, .asm_169c2
	inc a
.asm_169c2
	call Func_169cd
.asm_169c5
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_169ae
	ret

Func_169cd: ; 0x169cd
	push af
	sla c
	ld hl, TileDataPointers_169ed
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_169db
	ld hl, TileDataPointers_16bef
.asm_169db
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
	ld a, Bank(TileDataPointers_169ed)
	call Func_10aa
	ret

TileDataPointers_169ed:
	dw TileDataPointers_169f7
	dw TileDataPointers_16a01
	dw TileDataPointers_16a0b
	dw TileDataPointers_16a0f
	dw TileDataPointers_16a13

TileDataPointers_169f7: ; 0x169f7
	dw TileData_16a17
	dw TileData_16a1e
	dw TileData_16a25
	dw TileData_16a2c
	dw TileData_16a33

TileDataPointers_16a01: ; 0x16a01
	dw TileData_16a3a
	dw TileData_16a41
	dw TileData_16a48
	dw TileData_16a4f
	dw TileData_16a56

TileDataPointers_16a0b: ; 0x16a0b
	dw TileData_16a5d
	dw TileData_16a60

TileDataPointers_16a0f: ; 0x16a0f
	dw TileData_16a63
	dw TileData_16a66

TileDataPointers_16a13: ; 0x16a13
	dw TileData_16a69
	dw TileData_16a6e

TileData_16a17: ; 0x16a17
	db $03
	dw TileData_16a73
	dw TileData_16a7d
	dw TileData_16a87

TileData_16a1e: ; 0x16a1e
	db $03
	dw TileData_16a91
	dw TileData_16a9b
	dw TileData_16aa5

TileData_16a25: ; 0x16a25
	db $03
	dw TileData_16aaf
	dw TileData_16ab9
	dw TileData_16ac3

TileData_16a2c: ; 0x16a2c
	db $03
	dw TileData_16acd
	dw TileData_16ad7
	dw TileData_16ae1

TileData_16a33: ; 0x16a33
	db $03
	dw TileData_16aeb
	dw TileData_16af5
	dw TileData_16aff

TileData_16a3a: ; 0x16a3a
	db $03
	dw TileData_16b09
	dw TileData_16b13
	dw TileData_16b1d

TileData_16a41: ; 0x16a41
	db $03
	dw TileData_16b27
	dw TileData_16b31
	dw TileData_16b3b

TileData_16a48: ; 0x16a48
	db $03
	dw TileData_16b45
	dw TileData_16b4f
	dw TileData_16b59

TileData_16a4f: ; 0x16a4f
	db $03
	dw TileData_16b63
	dw TileData_16b6d
	dw TileData_16b77

TileData_16a56: ; 0x16a56
	db $03
	dw TileData_16b81
	dw TileData_16b8b
	dw TileData_16b95

TileData_16a5d: ; 0x16a5d
	db $01
	dw TileData_16b9f

TileData_16a60: ; 0x16a60
	db $01
	dw TileData_16ba9

TileData_16a63: ; 0x16a63
	db $01
	dw TileData_16bb3

TileData_16a66: ; 0x16a66
	db $01
	dw TileData_16bbd

TileData_16a69: ; 0x16a69
	db $02
	dw TileData_16bc7
	dw TileData_16bd1

TileData_16a6e: ; 0x16a6e
	db $02
	dw TileData_16bdb
	dw TileData_16be5

TileData_16a73: ; 0x16a73
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomBaseGameBoyGfx + $ba0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16a7d: ; 0x16a7d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomBaseGameBoyGfx + $bd0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16a87: ; 0x16a87
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomBaseGameBoyGfx + $c00
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16a91: ; 0x16a91
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $380
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16a9b: ; 0x16a9b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $3B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aa5: ; 0x16aa5
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $3E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aaf: ; 0x16aaf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $3F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ab9: ; 0x16ab9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $420
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ac3: ; 0x16ac3
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $450
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16acd: ; 0x16acd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $460
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ad7: ; 0x16ad7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $490
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ae1: ; 0x16ae1
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $4C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aeb: ; 0x16aeb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16af5: ; 0x16af5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aff: ; 0x16aff
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F90
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b09: ; 0x16b09
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomBaseGameBoyGfx + $c10
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16b13: ; 0x16b13
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomBaseGameBoyGfx + $c40
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16b1d: ; 0x16b1d
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomBaseGameBoyGfx + $c70
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16b27: ; 0x16b27
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $4D0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b31: ; 0x16b31
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $500
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b3b: ; 0x16b3b
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $530
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b45: ; 0x16b45
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $540
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b4f: ; 0x16b4f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $570
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b59: ; 0x16b59
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $5A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b63: ; 0x16b63
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $5B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b6d: ; 0x16b6d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $5E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b77: ; 0x16b77
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $610
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b81: ; 0x16b81
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1010
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b8b: ; 0x16b8b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1040
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b95: ; 0x16b95
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1070
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b9f: ; 0x16b9f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $20
	dw StageRedFieldBottomBaseGameBoyGfx + $a00
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16ba9: ; 0x16ba9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $20
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16bb3: ; 0x16bb3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $23
	dw StageRedFieldBottomBaseGameBoyGfx + $a30
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16bbd: ; 0x16bbd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $10B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16bc7: ; 0x16bc7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1C
	dw StageRedFieldBottomBaseGameBoyGfx + $9c0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16bd1: ; 0x16bd1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1E
	dw StageRedFieldBottomBaseGameBoyGfx + $9e0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16bdb: ; 0x16bdb
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $6E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16be5: ; 0x16be5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $700
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_16bef:
	dw TileDataPointers_16bf9
	dw TileDataPointers_16c03
	dw TileDataPointers_16c0d
	dw TileDataPointers_16c11
	dw TileDataPointers_16c15

TileDataPointers_16bf9: ; 0x16bf9
	dw TileData_16c19
	dw TileData_16c1c
	dw TileData_16c1f
	dw TileData_16c22
	dw TileData_16c25

TileDataPointers_16c03: ; 0x16c03
	dw TileData_16c28
	dw TileData_16c2b
	dw TileData_16c2e
	dw TileData_16c31
	dw TileData_16c34

TileDataPointers_16c0d: ; 0x16c0d
	dw TileData_16c37
	dw TileData_16c3a

TileDataPointers_16c11: ; 0x16c11
	dw TileData_16c3d
	dw TileData_16c40

TileDataPointers_16c15: ; 0x16c15
	dw TileData_16c43
	dw TileData_16c46

TileData_16c19: ; 0x16c19
	db $01
	dw TileData_16c49

TileData_16c1c: ; 0x16c1c
	db $01
	dw TileData_16c63

TileData_16c1f: ; 0x16c1f
	db $01
	dw TileData_16c7d

TileData_16c22: ; 0x16c22
	db $01
	dw TileData_16c97

TileData_16c25: ; 0x16c25
	db $01
	dw TileData_16cb1

TileData_16c28: ; 0x16c28
	db $01
	dw TileData_16ccb

TileData_16c2b: ; 0x16c2b
	db $01
	dw TileData_16ce5

TileData_16c2e: ; 0x16c2e
	db $01
	dw TileData_16cff

TileData_16c31: ; 0x16c31
	db $01
	dw TileData_16d19

TileData_16c34: ; 0x16c34
	db $01
	dw TileData_16d33

TileData_16c37: ; 0x16c37
	db $01
	dw TileData_16d4d

TileData_16c3a: ; 0x16c3a
	db $01
	dw TileData_16d5a

TileData_16c3d: ; 0x16c3d
	db $01
	dw TileData_16d67

TileData_16c40: ; 0x16c40
	db $01
	dw TileData_16d74

TileData_16c43: ; 0x16c43
	db $01
	dw TileData_16d81

TileData_16c46: ; 0x16c46
	db $01
	dw TileData_16d8f

TileData_16c49: ; 0x16c49
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $23
	db $5E

	db $02
	dw vBGMap + $43
	db $5F, $60

	db $02
	dw vBGMap + $64
	db $61, $62

	db $01
	dw vBGMap + $85
	db $63

	db $01
	dw vBGMap + $A5
	db $64

	db $00

TileData_16c63: ; 0x16c63
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $23
	db $65

	db $02
	dw vBGMap + $43
	db $66, $67

	db $02
	dw vBGMap + $64
	db $61, $62

	db $01
	dw vBGMap + $85
	db $63

	db $01
	dw vBGMap + $A5
	db $64

	db $00

TileData_16c7d: ; 0x16c7d
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $23
	db $65

	db $02
	dw vBGMap + $43
	db $66, $67

	db $02
	dw vBGMap + $64
	db $68, $69

	db $01
	dw vBGMap + $85
	db $63

	db $01
	dw vBGMap + $A5
	db $64

	db $00

TileData_16c97: ; 0x16c97
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $23
	db $65

	db $02
	dw vBGMap + $43
	db $66, $67

	db $02
	dw vBGMap + $64
	db $68, $69

	db $01
	dw vBGMap + $85
	db $6A

	db $01
	dw vBGMap + $A5
	db $6B

	db $00

TileData_16cb1: ; 0x16cb1
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $23
	db $5E

	db $02
	dw vBGMap + $43
	db $5F, $60

	db $02
	dw vBGMap + $64
	db $68, $69

	db $01
	dw vBGMap + $85
	db $6A

	db $01
	dw vBGMap + $A5
	db $6B

	db $00

TileData_16ccb: ; 0x16ccb
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $30
	db $6C

	db $02
	dw vBGMap + $4F
	db $6D, $6E

	db $02
	dw vBGMap + $6E
	db $6F, $70

	db $01
	dw vBGMap + $8E
	db $71

	db $01
	dw vBGMap + $AE
	db $72

	db $00

TileData_16ce5: ; 0x16ce5
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $30
	db $73

	db $02
	dw vBGMap + $4F
	db $74, $75

	db $02
	dw vBGMap + $6E
	db $6F, $70

	db $01
	dw vBGMap + $8E
	db $71

	db $01
	dw vBGMap + $AE
	db $72

	db $00

TileData_16cff: ; 0x16cff
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $30
	db $73

	db $02
	dw vBGMap + $4F
	db $74, $75

	db $02
	dw vBGMap + $6E
	db $76, $77

	db $01
	dw vBGMap + $8E
	db $71

	db $01
	dw vBGMap + $AE
	db $72

	db $00

TileData_16d19: ; 0x16d19
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $30
	db $73

	db $02
	dw vBGMap + $4F
	db $74, $75

	db $02
	dw vBGMap + $6E
	db $76, $77

	db $01
	dw vBGMap + $8E
	db $78

	db $01
	dw vBGMap + $AE
	db $79

	db $00

TileData_16d33: ; 0x16d33
	dw LoadTileLists
	db $07

	db $01
	dw vBGMap + $30
	db $6C

	db $02
	dw vBGMap + $4F
	db $6D, $6E

	db $02
	dw vBGMap + $6E
	db $76, $77

	db $01
	dw vBGMap + $8E
	db $78

	db $01
	dw vBGMap + $AE
	db $79

	db $00

TileData_16d4d: ; 0x16d4d
	dw LoadTileLists
	db $03

	db $01
	dw vBGMap + $6
	db $48

	db $02
	dw vBGMap + $26
	db $49, $4A

	db $00

TileData_16d5a: ; 0x16d5a
	dw LoadTileLists
	db $03

	db $01
	dw vBGMap + $6
	db $4B

	db $02
	dw vBGMap + $26
	db $4C, $4D

	db $00

TileData_16d67: ; 0x16d67
	dw LoadTileLists
	db $03

	db $01
	dw vBGMap + $D
	db $4E

	db $02
	dw vBGMap + $2C
	db $4F, $50

	db $00

TileData_16d74: ; 0x16d74
	dw LoadTileLists
	db $03

	db $01
	dw vBGMap + $D
	db $51

	db $02
	dw vBGMap + $2C
	db $52, $53

	db $00

TileData_16d81: ; 0x16d81
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $49
	db $40, $41

	db $02
	dw vBGMap + $69
	db $42, $43

	db $00

TileData_16d8f: ; 0x16d8f
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $49
	db $44, $45

	db $02
	dw vBGMap + $69
	db $46, $47

	db $00

ResolveRedStageBonusMultiplierCollision: ; 016d9d
	ld a, [wWhichBonusMultiplierRailing]
	and a
	jp z, UpdateBonusMultiplierRailing_RedField
	xor a
	ld [wWhichBonusMultiplierRailing], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wWhichBonusMultiplierRailingId]
	sub $21
	jr nz, .hitRightRailing
	ld a, $9
	callba Func_10000
	ld a, [wd610]
	cp $3
	jr nz, .asm_16e35
	ld a, $1
	ld [wd610], a
	ld a, $3
	ld [wd611], a
	ld a, [wBonusMultiplierTensDigit]
	set 7, a
	ld [wBonusMultiplierTensDigit], a
	jr .asm_16e35

.hitRightRailing
	ld a, $a
	callba Func_10000
	ld a, [wd611]
	cp $3
	jr nz, .asm_16e35
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
	jr c, .asm_16e10
	ld a, MAX_BONUS_MULTIPLIER
.asm_16e10
	ld [wCurBonusMultiplier], a
	jr nc, .asm_16e24
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent
.asm_16e24
	ld a, [wBonusMultiplierTensDigit]
	ld [wd614], a
	ld a, [wBonusMultiplierOnesDigit]
	ld [wd615], a
	ld a, $1
	ld [wd613], a
.asm_16e35
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wBonusMultiplierTensDigit]
	call LoadBonusMultiplierRailingGraphics_RedField
	ld a, [wBonusMultiplierOnesDigit]
	add $14
	call LoadBonusMultiplierRailingGraphics_RedField
	ret

UpdateBonusMultiplierRailing_RedField: ; 0x16e51
	call ShowBonusMultiplierMessage_RedField ; only shows the scrolling message when appropriate
	ld a, [wd612]
	and a
	jr z, .asm_16e8f
	dec a
	ld [wd612], a
	cp $70
	jr nz, .asm_16e6e
	ld a, $2
	ld [wd610], a
	ld a, $2
	ld [wd611], a
	jr .asm_16e8f

.asm_16e6e
	and a
	jr nz, .asm_16e8f
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld a, [wCurBonusMultiplier]
	call GetBCDForNextBonusMultiplier_RedField
	ld a, [wBonusMultiplierTensDigit]
	call LoadBonusMultiplierRailingGraphics_RedField
	ld a, [wBonusMultiplierOnesDigit]
	add $14
	call LoadBonusMultiplierRailingGraphics_RedField
	ret

.asm_16e8f
	ld a, [wd610]
	cp $2
	jr c, .asm_16ec1
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_16ea0
	srl a
	srl a
.asm_16ea0
	ld b, a
	and $3
	jr nz, .asm_16ec1
	bit 3, b
	jr nz, .asm_16eb6
	ld a, [wBonusMultiplierTensDigit]
	res 7, a
	ld [wBonusMultiplierTensDigit], a
	call LoadBonusMultiplierRailingGraphics_RedField
	jr .asm_16ec1

.asm_16eb6
	ld a, [wBonusMultiplierTensDigit]
	set 7, a
	ld [wBonusMultiplierTensDigit], a
	call LoadBonusMultiplierRailingGraphics_RedField
.asm_16ec1
	ld a, [wd611]
	cp $2
	ret c
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_16ed1
	srl a
	srl a
.asm_16ed1
	ld b, a
	and $3
	ret nz
	bit 3, b
	jr nz, .asm_16ee7
	ld a, [wBonusMultiplierOnesDigit]
	res 7, a
	ld [wBonusMultiplierOnesDigit], a
	add $14
	call LoadBonusMultiplierRailingGraphics_RedField
	ret

.asm_16ee7
	ld a, [wBonusMultiplierOnesDigit]
	set 7, a
	ld [wBonusMultiplierOnesDigit], a
	add $14
	call LoadBonusMultiplierRailingGraphics_RedField
	ret

ShowBonusMultiplierMessage_RedField: ; 0x16ef5
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
	ld hl, wScrollingText1
	ld de, BonusMultiplierText
	call LoadScrollingText
	ld hl, wBottomMessageText + $12
	ld a, [wd614]
	and $7f
	jr z, .asm_16f1f
	add $30
	ld [hli], a
.asm_16f1f
	ld a, [wd615]
	res 7, a
	add $30
	ld [hl], a
	ret

LoadBonusMultiplierRailingGraphics_RedField: ; 0x16f28
	push af
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	pop af
	call LoadBonusMultiplierRailingGraphics_RedField_Gameboy
	ret

.gameboyColor
	pop af
	call LoadBonusMultiplierRailingGraphics_RedField_GameboyColor
	ret

LoadBonusMultiplierRailingGraphics_RedField_Gameboy: ; 0x16f38
	push af
	res 7, a
	ld hl, wd60e
	cp $14
	jr c, .asm_16f47
	ld hl, wd60f
	sub $a
.asm_16f47
	cp [hl]
	jr z, .asm_16f5c
	ld [hl], a
	ld c, a
	ld b, $0
	sla c
	ld hl, BonusMultiplierRailingTileDataPointers_16fc8
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BonusMultiplierRailingTileDataPointers_16fc8)
	call Func_10aa
.asm_16f5c
	pop af
	ld bc, $0000
	bit 7, a
	jr z, .asm_16f68
	res 7, a
	set 1, c
.asm_16f68
	cp $14
	jr c, .asm_16f6e
	set 2, c
.asm_16f6e
	ld hl, BonusMultiplierRailingTileData_171e4
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BonusMultiplierRailingTileData_171e4)
	call Func_10aa
	ret

LoadBonusMultiplierRailingGraphics_RedField_GameboyColor: ; 0x16f7b
	bit 7, a
	jr z, .asm_16f83
	res 7, a
	add $a
.asm_16f83
	ld c, a
	ld b, $0
	sla c
	ld hl, BonusMultiplierRailingTileDataPointers_17228
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BonusMultiplierRailingTileDataPointers_17228)
	call Func_10aa
	ret

GetBCDForNextBonusMultiplier_RedField: ; 0x16f95
; Gets the BCD representation of the next bonus multplier value.
; Output:  [wBonusMultiplierTensDigit] = the tens digit
;          [wBonusMultiplierOnesDigit] = the ones digit
	ld a, [wCurBonusMultiplier]
	inc a
	cp MAX_BONUS_MULTIPLIER + 1
	jr c, .asm_16f9f
	ld a, MAX_BONUS_MULTIPLIER
.asm_16f9f
	ld b, a
	xor a
	ld hl, Data_16fc1
	ld c, $7
.asm_16fa6
	bit 0, b
	jr z, .asm_16fac
	add [hl]
	daa
.asm_16fac
	srl b
	inc hl
	dec c
	jr nz, .asm_16fa6
	push af
	swap a
	and $f
	ld [wBonusMultiplierTensDigit], a
	pop af
	and $f
	ld [wBonusMultiplierOnesDigit], a
	ret

Data_16fc1:
; BCD powers of 2
	db $01
	db $02
	db $04
	db $08
	db $16
	db $32
	db $64

INCLUDE "data/queued_tiledata/red_field/bonus_multiplier_railings.asm"

Func_174d0: ; 0x174d0
	call Func_174ea
	ret nc
	; fall through

Func_174d4: ; 0x174d4
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_17528
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	ret

Func_174ea: ; 0x174ea
	ld a, [wPreviousNumPokeballs]
	ld hl, wNumPokeballs
	cp [hl]
	ret z
	ld a, [wPokeballBlinkingCounter]
	dec a
	ld [wPokeballBlinkingCounter], a
	jr nz, .asm_17514
	ld a, [wNumPokeballs]
	ld [wPreviousNumPokeballs], a
	cp $3
	jr c, .asm_1750f
	ld a, $1
	ld [wd609], a
	ld a, $3
	ld [wd607], a
.asm_1750f
	ld a, [wPreviousNumPokeballs]
	scf
	ret

.asm_17514
	and $7
	ret nz
	ld a, [wPokeballBlinkingCounter]
	bit 3, a
	jr nz, .asm_17523
	ld a, [wPreviousNumPokeballs]
	scf
	ret

.asm_17523
	ld a, [wNumPokeballs]
	scf
	ret

TileDataPointers_17528:
	dw TileData_17530
	dw TileData_1753B
	dw TileData_17546
	dw TileData_17551

TileData_17530: ; 0x17530
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $B0, $B1, $B0, $B1, $B0, $B1
	db $00

TileData_1753B: ; 0x1753B
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $AE, $AF, $B0, $B1, $B0, $B1
	db $00

TileData_17546: ; 0x17546
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $AE, $AF, $AE, $AF, $B0, $B1
	db $00

TileData_17551: ; 0x17551
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $AE, $AF, $AE, $AF, $AE, $AF
	db $00
