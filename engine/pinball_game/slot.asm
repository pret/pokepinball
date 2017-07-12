Func_ed8e: ; 0xed8e
	xor a
	ld [wRumblePattern], a
	ld [wRumbleDuration], a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ld a, [wNumPartyMons]
	ld [wSlotAnyPokemonCaught], a
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeMultipliers
	add hl, bc
	ld a, [hl]
	ld [wd621], a
.asm_edac
	xor a
	ld [hJoypadState], a
	ld [hNewlyPressedButtons], a
	ld [hPressedButtons], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	ld [hFarCallTempA], a
	ld a, $3
	ld hl, HandleFlippers
	call nz, BankSwitch
	callba DrawSpritesForStage
	call UpdateBottomText
	call CleanOAMBuffer
	rst AdvanceFrame
	ld a, [wd7af]
	and a
	jr nz, .asm_edac
	ld a, [wd7b3]
	and a
	jr nz, .asm_edac
	ld a, [hGameBoyColorFlag]
	and a
	call nz, LoadGreyBillboardPaletteData
	call GenRandom
	and $f0
	ld [wd61a], a
	xor a
	ld [wd61b], a
	ld [wd61e], a
.asm_6df7
	ld a, [wd61a]
	ld c, a
	ld b, $0
	ld hl, Data_f339
	add hl, bc
	ld a, [wd619]
	add [hl]
	ld c, a
	ld hl, Data_f439
	add hl, bc
	ld a, [hli]
	bit 7, a
	jr nz, .asm_ee56
	call Func_eef9
	ld [wd61d], a
	push af
	lb de, $00, $09
	call PlaySoundEffect
	pop af
	call LoadBillboardOffPicture
	ld a, [wd61b]
	cp $a
	jr nc, .asm_ee29
	ld a, $a
.asm_ee29
	ld b, a
.asm_ee2a
	push bc
	call Delay1Frame
	ld a, [wd61e]
	and a
	jr nz, .asm_ee47
	call Func_ef1e
	jr z, .asm_ee47
	ld [wd61e], a
	ld a, $32
	ld [wd61b], a
	lb de, $07, $28
	call PlaySoundEffect
.asm_ee47
	pop bc
	dec b
	jr nz, .asm_ee2a
	ld a, [wd61b]
	inc a
	ld [wd61b], a
	cp $3c
	jr z, .asm_ee69
.asm_ee56
	ld a, [wd61a]
	and $f0
	ld b, a
	ld a, [wd61a]
	inc a
	and $f
	or b
	ld [wd61a], a
	jp .asm_6df7

.asm_ee69
	ld a, [wd61d]
	cp $5
	jr nz, .asm_ee78
	lb de, $0c, $42
	call PlaySoundEffect
	jr .asm_ee7e

.asm_ee78
	lb de, $0c, $43
	call PlaySoundEffect
.asm_ee7e
	ld b, $28
.asm_ee80
	push bc
	rst AdvanceFrame
	pop bc
	call Func_ef1e
	jr nz, .asm_ee8b
	dec b
	jr nz, .asm_ee80
.asm_ee8b
	ld a, [hGameBoyColorFlag]
	and a
	ld a, [wd61d]
	call nz, Func_f2a0
	ld b, $80
.asm_ee96
	push bc
	ld a, b
	and $f
	jr nz, .asm_eeae
	bit 4, b
	jr z, .asm_eea8
	ld a, [wd61d]
	call LoadBillboardPicture
	jr .asm_eeae

.asm_eea8
	ld a, [wd61d]
	call LoadBillboardOffPicture
.asm_eeae
	rst AdvanceFrame
	pop bc
	call Func_ef1e
	jr nz, .asm_eeb8
	dec b
	jr nz, .asm_ee96
.asm_eeb8
	ld a, [wd619]
	add $a
	cp $fa
	jr nz, .asm_eec3
	ld a, $64
.asm_eec3
	ld [wd619], a
	ld a, [wd61d]
	rst JumpTable  ; calls JumpToFuncInTable
SlotRewards_CallTable: ; 0xeeca
	dw Start30SecondSaverTimer
	dw Start60SecondSaverTimer
	dw Start90SecondSaverTimer
	dw SlotRewardPikachuSaver
	dw SlotRewardBonusMultiplier
	dw SlotRewardSmallPoints
	dw SlotRewardBigPoints
	dw SlotRewardCatchEmMode
	dw SlotRewardEvolutionMode
	dw SlotRewardUpgradeBall
	dw SlotRewardUpgradeBall
	dw SlotRewardUpgradeBall
	dw SlotBonusMultiplier
	dw SlotRewardGoToBonusStage
	dw SlotRewardGoToBonusStage
	dw SlotRewardGoToBonusStage
	dw SlotRewardGoToBonusStage
	dw SlotRewardGoToBonusStage

Delay1Frame: ; 0xeeee
; Simply does nothing for approximately 1 frame of real time
	push bc
	ld bc, $0200
.loop
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop bc
	ret

Func_eef9: ; 0xeef9
	cp $8
	jr nz, .asm_ef09
	ld a, [wSlotAnyPokemonCaught]
	and a
	jr nz, .asm_ef06
	ld a, $7
	ret

.asm_ef06
	ld a, $8
	ret

.asm_ef09
	cp $9
	jr nz, .asm_ef14
	push hl
	ld hl, wd621
	add [hl]
	pop hl
	ret

.asm_ef14
	cp $d
	ret nz
	push hl
	ld hl, wd498
	add [hl]
	pop hl
	ret

Func_ef1e: ; 0xef1e
	push bc
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	jr nz, .asm_ef2d
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
.asm_ef2d
	pop bc
	ret

BallTypeMultipliers: ; 0xef2f
; Score multiplier for each ball type.
	db $00  ; POKE_BALL
	db $00
	db $01  ; GREAT_BALL
	db $02  ; ULTRA_BALL
	db $02
	db $02  ; MASTER_BALL

INCLUDE "engine/pinball_game/ball_saver/ball_saver_30.asm"
INCLUDE "engine/pinball_game/ball_saver/ball_saver_60.asm"
INCLUDE "engine/pinball_game/ball_saver/ball_saver_90.asm"

SlotRewardPikachuSaver: ; 0xef83
	ld a, $1
	ld [wPikachuSaverSlotRewardActive], a
	ld a, MAX_PIKACHU_SAVER_CHARGE
	ld [wPikachuSaverCharge], a
	xor a
	ld [wAudioEngineEnabled], a
	call Func_310a
	rst AdvanceFrame
	ld a, $0
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wAudioEngineEnabled], a
	ret

SlotRewardBonusMultiplier: ; 0xefa7
	callba IncrementBonusMultiplierFromFieldEvent
	ret

SlotRewardSmallPoints: ; 0xefb2
	ld a, $8
	call RandomRange
	ld [wCurSlotBonus], a
	ld b, $80
.asm_efbc
	push bc
	ld a, b
	and $f
	jr nz, .asm_efd8
	bit 4, b
	jr z, .asm_efd0
	ld a, [wCurSlotBonus]
	add (SmallReward100PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardPicture
	jr .asm_efd8

.asm_efd0
	ld a, [wCurSlotBonus]
	add (SmallReward100PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardOffPicture
.asm_efd8
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	and FLIPPERS
	jr nz, .asm_efe3
	dec b
	jr nz, .asm_efbc
.asm_efe3
	ld a, [wCurSlotBonus]
	inc a
	swap a
	ld e, a
	ld d, $0
	ld bc, $0000
	call AddBCDEToCurBufferValue
	ret

SlotRewardBigPoints: ; 0xeff3
	ld a, $8
	call RandomRange
	ld [wCurSlotBonus], a
	ld b, $80
.asm_effd
	push bc
	ld a, b
	and $f
	jr nz, .asm_f019
	bit 4, b
	jr z, .asm_f011
	ld a, [wCurSlotBonus]
	add (BigReward1000000PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardPicture
	jr .asm_f019

.asm_f011
	ld a, [wCurSlotBonus]
	add (BigReward1000000PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardOffPicture
.asm_f019
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	and FLIPPERS
	jr nz, .asm_f024
	dec b
	jr nz, .asm_effd
.asm_f024
	ld a, [wCurSlotBonus]
	inc a
	swap a
	ld c, a
	ld b, $0
	ld de, $0000
	call AddBCDEToCurBufferValue
	ret

SlotRewardCatchEmMode: ; 0xf034
	ld a, CATCHEM_MODE_SLOT_REWARD
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

SlotRewardEvolutionMode: ; 0xf03a
	ld a, EVOLUTION_MODE_SLOT_REWARD
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

SlotRewardUpgradeBall: ; 0xf040
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
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
	; upgrade ball type
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgressionBlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .asm_f0b0

.masterBall
	lb de, $0f, $4d
	call PlaySoundEffect
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $100
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
.asm_f0b0
	callba TransitionPinballUpgradePalette
	ret

BallTypeProgressionBlueField: ; 0xf0bb
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

SlotBonusMultiplier: ; 0xf0c1
	ld a, $4
	call RandomRange
	ld [wCurSlotBonus], a
	ld b, $80
.asm_f0cb
	push bc
	ld a, b
	and $f
	jr nz, .asm_f0e7
	bit 4, b
	jr z, .asm_f0df
	ld a, [wCurSlotBonus]
	add (BonusMultiplierX1OnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardPicture
	jr .asm_f0e7

.asm_f0df
	ld a, [wCurSlotBonus]
	add (BonusMultiplierX1OnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardOffPicture
.asm_f0e7
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	and FLIPPERS
	jr nz, .asm_f0f2
	dec b
	jr nz, .asm_f0cb
.asm_f0f2
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld [wd612], a
	ld a, [wCurBonusMultiplier]
	call .DivideBy25
	ld b, c
	ld a, [wCurSlotBonus]
	inc a
	ld hl, wCurBonusMultiplier
	add [hl]
	cp 100
	jr c, .asm_f113
	ld a, 99
.asm_f113
	ld [hl], a
	call .DivideBy25
	ld a, c
	cp b
	callba nz, IncrementBonusMultiplierFromFieldEvent
	callba GetBCDForNextBonusMultiplier_RedField
	ld a, [wBonusMultiplierTensDigit]
	callba Func_f154 ; no need for BankSwitch here...
	ld a, [wBonusMultiplierOnesDigit]
	add $14
	callba Func_f154 ; no need for BankSwitch here...
	ret

.DivideBy25: ; 0xf14a
	ld c, $0
.div_25
	cp 25
	ret c
	sub 25
	inc c
	jr .div_25

Func_f154: ; 0xf154
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_f15a: ; 0xf15a
	padded_dab LoadBonusMultiplierRailingGraphics_RedField
	padded_dab LoadBonusMultiplierRailingGraphics_RedField
	padded_dab LoadBonusMultiplierRailingGraphics_RedField
	padded_dab LoadBonusMultiplierRailingGraphics_RedField
	padded_dab LoadBonusMultiplierRailingGraphics_BlueField
	padded_dab LoadBonusMultiplierRailingGraphics_BlueField

SlotRewardGoToBonusStage: ; 0xf172
	ld a, $1
	ld [wBonusStageSlotRewardActive], a
	ret

INCLUDE "engine/pinball_game/billboard.asm"

Func_f2a0: ; 0xf2a0
	push hl
	ld c, a
	ld b, $0
	sla c
	add c
	ld c, a
	ld hl, PaletteDataPointerTable_f2be
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, b
	ld l, c
	ld de, $0030
	ld bc, $0010
	call Func_7dc
	pop hl
	ret

PaletteDataPointerTable_f2be: ; 0xf2be
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc10, Bank(PaletteData_dcc10)
	dwb PaletteData_dcc18, Bank(PaletteData_dcc18)
	dwb PaletteData_dcc20, Bank(PaletteData_dcc20)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc28, Bank(PaletteData_dcc28)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc30, Bank(PaletteData_dcc30)
	dwb PaletteData_dcc38, Bank(PaletteData_dcc38)
	dwb PaletteData_dcc40, Bank(PaletteData_dcc40)
	dwb PaletteData_dcc48, Bank(PaletteData_dcc48)
	dwb PaletteData_dcc50, Bank(PaletteData_dcc50)
	dwb PaletteData_dcc58, Bank(PaletteData_dcc58)
	dwb PaletteData_dcc60, Bank(PaletteData_dcc60)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)

Data_f339: ; 0xf339
	db $02, $06, $00, $08, $04, $02, $06, $08, $04, $00, $06, $02, $04, $08, $00, $02
	db $06, $02, $04, $08, $00, $06, $04, $08, $02, $00, $06, $08, $02, $00, $06, $08
	db $02, $04, $00, $08, $06, $04, $00, $02, $06, $04, $00, $08, $06, $04, $02, $08
	db $00, $08, $02, $04, $00, $08, $06, $02, $04, $00, $06, $08, $04, $00, $06, $02
	db $00, $08, $02, $04, $00, $08, $06, $04, $02, $08, $00, $06, $02, $08, $00, $06
	db $02, $00, $06, $04, $02, $00, $06, $08, $02, $04, $00, $06, $08, $04, $02, $06
	db $00, $02, $08, $04, $00, $02, $06, $04, $08, $02, $06, $00, $04, $08, $06, $02
	db $04, $08, $06, $02, $00, $08, $04, $06, $00, $02, $04, $06, $00, $02, $04, $08
	db $02, $00, $04, $06, $02, $00, $08, $04, $02, $00, $06, $04, $08, $00, $06, $04
	db $04, $00, $02, $08, $04, $06, $00, $08, $02, $04, $06, $08, $00, $04, $06, $02
	db $06, $08, $04, $02, $06, $00, $08, $02, $04, $00, $06, $02, $08, $04, $06, $02
	db $04, $06, $02, $00, $08, $04, $06, $00, $08, $02, $06, $00, $08, $02, $04, $00
	db $02, $00, $06, $04, $02, $08, $06, $00, $04, $08, $02, $00, $04, $06, $08, $00
	db $08, $06, $04, $00, $08, $06, $02, $00, $08, $06, $04, $00, $08, $06, $04, $02
	db $02, $00, $06, $04, $08, $02, $00, $04, $08, $02, $00, $04, $06, $02, $08, $00
	db $04, $06, $08, $02, $00, $06, $04, $08, $02, $06, $00, $08, $04, $06, $02, $08

Data_f439: ; 0xf439
	db $05, $19, $0C, $4C, $00, $4C, $03, $4C, $FF, $00, $05, $19, $0C, $4C, $00, $4C
	db $07, $4C, $FF, $00, $05, $19, $0C, $44, $00, $44, $03, $44, $06, $16, $05, $19
	db $0C, $4C, $00, $4C, $08, $4C, $FF, $00, $01, $4C, $06, $66, $0D, $4C, $FF, $00
	db $FF, $00, $05, $19, $0C, $4C, $00, $4C, $03, $4C, $FF, $00, $05, $19, $0C, $4C
	db $00, $4C, $07, $4C, $FF, $00, $05, $19, $0C, $44, $00, $44, $03, $44, $06, $16
	db $05, $19, $0C, $4C, $00, $4C, $08, $4C, $FF, $00, $01, $3F, $06, $3F, $0D, $3F
	db $09, $3F, $FF, $00, $05, $11, $0C, $4F, $00, $4F, $03, $4F, $FF, $00, $05, $11
	db $0C, $4F, $01, $4F, $07, $4F, $FF, $00, $05, $11, $0C, $44, $00, $44, $03, $44
	db $06, $1E, $05, $11, $0C, $4F, $01, $4F, $08, $4F, $FF, $00, $02, $66, $06, $4C
	db $0D, $4C, $FF, $00, $FF, $00, $05, $0A, $0C, $51, $00, $51, $03, $51, $FF, $00
	db $05, $0A, $0C, $51, $01, $51, $07, $51, $FF, $00, $05, $0A, $0C, $44, $00, $44
	db $03, $44, $06, $26, $05, $0A, $0C, $51, $01, $51, $08, $51, $FF, $00, $01, $3F
	db $06, $3F, $0D, $3F, $09, $3F, $FF, $00, $05, $0A, $0C, $51, $00, $51, $03, $51
	db $FF, $00, $05, $0A, $0C, $51, $01, $51, $07, $51, $FF, $00, $05, $0A, $0C, $44
	db $00, $44, $03, $44, $06, $26, $05, $0A, $0C, $51, $01, $51, $08, $51, $FF, $00
	db $01, $26, $06, $26, $0D, $26, $04, $8C, $FF, $00
