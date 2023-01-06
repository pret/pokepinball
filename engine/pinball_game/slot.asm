DoSlotRewardRoulette: ; 0xed8e
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
	ld [wSlotBallIncrease], a
.waitForFlippers
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
	ld a, [wLeftFlipperState + 1]
	and a
	jr nz, .waitForFlippers
	ld a, [wRightFlipperState + 1]
	and a
	jr nz, .waitForFlippers
	ld a, [hGameBoyColorFlag]
	and a
	call nz, LoadGreyBillboardPaletteData
	call GenRandom
	and $f0
	ld [wCurSlotRewardRouletteIndex], a
	xor a
	ld [wSlotRouletteCounter], a
	ld [wSlotRouletteSlowed], a
.rouletteLoop
	ld a, [wCurSlotRewardRouletteIndex]
	ld c, a
	ld b, 0
	ld hl, SlotRewardRoulettePermutations
	add hl, bc
	ld a, [wSlotRewardProgress]
	add [hl]
	ld c, a
	ld hl, SlotRewardSets
	add hl, bc
	ld a, [hli]
	bit 7, a ; ignore empty entires
	jr nz, .continue
	call ConvertSlotRewardBillboardPicture
	ld [wSlotRouletteBillboardPicture], a
	push af
	lb de, $00, $09
	call PlaySoundEffect
	pop af
	call LoadBillboardOffPicture
	ld a, [wSlotRouletteCounter]
	cp 10
	jr nc, .startDelayLoop
	ld a, 10
.startDelayLoop
	ld b, a
.delayLoop
	push bc
	call Delay1Frame
	ld a, [wSlotRouletteSlowed]
	and a
	jr nz, .continueDelay
	call IsRightOrLeftFlipperKeyPressed
	jr z, .continueDelay
	ld [wSlotRouletteSlowed], a
	ld a, 50
	ld [wSlotRouletteCounter], a
	lb de, $07, $28
	call PlaySoundEffect
.continueDelay
	pop bc
	dec b
	jr nz, .delayLoop
	ld a, [wSlotRouletteCounter]
	inc a
	ld [wSlotRouletteCounter], a
	cp 60
	jr z, .rouletteStopped
.continue
	ld a, [wCurSlotRewardRouletteIndex]
	and $f0
	ld b, a
	ld a, [wCurSlotRewardRouletteIndex]
	inc a
	and $f
	or b
	ld [wCurSlotRewardRouletteIndex], a
	jp .rouletteLoop

.rouletteStopped
	ld a, [wSlotRouletteBillboardPicture]
	cp BILLBOARD_SMALL_REWARD
	jr nz, .playGoodRewardSoundEffect
	lb de, $0c, $42
	call PlaySoundEffect
	jr .displayReward

.playGoodRewardSoundEffect
	lb de, $0c, $43
	call PlaySoundEffect
.displayReward
	ld b, 40
.displayRewardLoop
	push bc
	rst AdvanceFrame
	pop bc
	call IsRightOrLeftFlipperKeyPressed
	jr nz, .loadColoredRewardPicture
	dec b
	jr nz, .displayRewardLoop
.loadColoredRewardPicture
	ld a, [hGameBoyColorFlag]
	and a
	ld a, [wSlotRouletteBillboardPicture]
	call nz, Func_f2a0
	ld b, $80
.displayAnimatedRewardLoop
	push bc
	ld a, b
	and $f
	jr nz, .asm_eeae
	bit 4, b
	jr z, .asm_eea8
	ld a, [wSlotRouletteBillboardPicture]
	call LoadBillboardPicture
	jr .asm_eeae

.asm_eea8
	ld a, [wSlotRouletteBillboardPicture]
	call LoadBillboardOffPicture
.asm_eeae
	rst AdvanceFrame
	pop bc
	call IsRightOrLeftFlipperKeyPressed
	jr nz, .asm_eeb8
	dec b
	jr nz, .displayAnimatedRewardLoop
.asm_eeb8
	ld a, [wSlotRewardProgress]
	add 10
	cp 250
	jr nz, .saveSlotRewardProgress
	ld a, 100
.saveSlotRewardProgress
	ld [wSlotRewardProgress], a
	ld a, [wSlotRouletteBillboardPicture]
	rst JumpTable  ; calls JumpToFuncInTable
SlotRewards_CallTable: ; 0xeeca
	dw Start30SecondSaverTimer
	dw Start60SecondSaverTimer
	dw Start90SecondSaverTimer
	dw SlotRewardPikachuSaver
	dw SlotRewardExtraBall
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

ConvertSlotRewardBillboardPicture: ; 0xeef9
	cp BILLBOARD_EVOLUTION_MODE
	jr nz, .checkBallUpgrade
	ld a, [wSlotAnyPokemonCaught]
	and a
	jr nz, .evoMode
	ld a, BILLBOARD_CATCHEM_MODE
	ret

.evoMode
	ld a, BILLBOARD_EVOLUTION_MODE
	ret

.checkBallUpgrade
	cp BILLBOARD_GREAT_BALL
	jr nz, .checkGoToBonus
	push hl
	ld hl, wSlotBallIncrease
	add [hl]
	pop hl
	ret

.checkGoToBonus
	cp BILLBOARD_GENGAR_BONUS
	ret nz
	push hl
	ld hl, wNextBonusStage
	add [hl]
	pop hl
	ret

IsRightOrLeftFlipperKeyPressed: ; 0xef1e
	push bc
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	jr nz, .exit
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
.exit
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

SlotRewardExtraBall: ; 0xefa7
	callba AddExtraBall
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
	add BILLBOARD_SMALL_REWARD_100
	call LoadBillboardPicture
	jr .asm_efd8

.asm_efd0
	ld a, [wCurSlotBonus]
	add BILLBOARD_SMALL_REWARD_100
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
	add BILLBOARD_BIG_REWARD_1000000
	call LoadBillboardPicture
	jr .asm_f019

.asm_f011
	ld a, [wCurSlotBonus]
	add BILLBOARD_BIG_REWARD_1000000
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
	call EnableBottomText
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
	call EnableBottomText
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
	add BILLBOARD_BONUS_MULTIPLIER_X1
	call LoadBillboardPicture
	jr .asm_f0e7

.asm_f0df
	ld a, [wCurSlotBonus]
	add BILLBOARD_BONUS_MULTIPLIER_X1
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
	callba nz, AddExtraBall
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
	padded_dab _LoadBonusMultiplierRailingGraphics_RedField
	padded_dab _LoadBonusMultiplierRailingGraphics_RedField
	padded_dab _LoadBonusMultiplierRailingGraphics_RedField
	padded_dab _LoadBonusMultiplierRailingGraphics_RedField
	padded_dab _LoadBonusMultiplierRailingGraphics_BlueField
	padded_dab _LoadBonusMultiplierRailingGraphics_BlueField

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
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc08
	dab PaletteData_dcc08
	dab PaletteData_dcc10
	dab PaletteData_dcc18
	dab PaletteData_dcc20
	dab PaletteData_dcc08
	dab PaletteData_dcc28
	dab PaletteData_dcc08
	dab PaletteData_dcc30
	dab PaletteData_dcc38
	dab GoToGengarBonusOnBillboardBGPalette
	dab GoToMewtwoBonusOnBillboardBGPalette
	dab GoToMeowthBonusOnBillboardBGPalette
	dab GoToDiglettBonusOnBillboardBGPalette
	dab GoToSeelBonusOnBillboardBGPalette
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00
	dab PaletteData_dcc00

; Each row of 16 values is a single permutation, which is repeatedly cycled
; through until stopping on the selected slot reward.
SlotRewardRoulettePermutations: ; 0xf339
	db 2, 6, 0, 8, 4, 2, 6, 8, 4, 0, 6, 2, 4, 8, 0, 2
	db 6, 2, 4, 8, 0, 6, 4, 8, 2, 0, 6, 8, 2, 0, 6, 8
	db 2, 4, 0, 8, 6, 4, 0, 2, 6, 4, 0, 8, 6, 4, 2, 8
	db 0, 8, 2, 4, 0, 8, 6, 2, 4, 0, 6, 8, 4, 0, 6, 2
	db 0, 8, 2, 4, 0, 8, 6, 4, 2, 8, 0, 6, 2, 8, 0, 6
	db 2, 0, 6, 4, 2, 0, 6, 8, 2, 4, 0, 6, 8, 4, 2, 6
	db 0, 2, 8, 4, 0, 2, 6, 4, 8, 2, 6, 0, 4, 8, 6, 2
	db 4, 8, 6, 2, 0, 8, 4, 6, 0, 2, 4, 6, 0, 2, 4, 8
	db 2, 0, 4, 6, 2, 0, 8, 4, 2, 0, 6, 4, 8, 0, 6, 4
	db 4, 0, 2, 8, 4, 6, 0, 8, 2, 4, 6, 8, 0, 4, 6, 2
	db 6, 8, 4, 2, 6, 0, 8, 2, 4, 0, 6, 2, 8, 4, 6, 2
	db 4, 6, 2, 0, 8, 4, 6, 0, 8, 2, 6, 0, 8, 2, 4, 0
	db 2, 0, 6, 4, 2, 8, 6, 0, 4, 8, 2, 0, 4, 6, 8, 0
	db 8, 6, 4, 0, 8, 6, 2, 0, 8, 6, 4, 0, 8, 6, 4, 2
	db 2, 0, 6, 4, 8, 2, 0, 4, 8, 2, 0, 4, 6, 2, 8, 0
	db 4, 6, 8, 2, 0, 6, 4, 8, 2, 6, 0, 8, 4, 6, 2, 8

; Each group of 10 pairs corresponds to the offset in wSlotRewardProgress.
; The second value in each row is unused. It appears to have been used in some
; kind of weighting scheme, perhaps to control the probability of each item being
; chosen if the player interrupted the roulette by pressing a flipper key?
SlotRewardSets: ; 0xf439
	; wSlotRewardProgress = 0
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $4C
	db BILLBOARD_BALL_SAVER_30, $4C
	db BILLBOARD_PIKACHU_SAVER, $4C
	db $FF, $00

	; wSlotRewardProgress = 10
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $4C
	db BILLBOARD_BALL_SAVER_30, $4C
	db BILLBOARD_CATCHEM_MODE, $4C
	db $FF, $00

	; wSlotRewardProgress = 20
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $44
	db BILLBOARD_BALL_SAVER_30, $44
	db BILLBOARD_PIKACHU_SAVER, $44
	db BILLBOARD_BIG_REWARD, $16

	; wSlotRewardProgress = 30
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $4C
	db BILLBOARD_BALL_SAVER_30, $4C
	db BILLBOARD_EVOLUTION_MODE, $4C
	db $FF, $00

	; wSlotRewardProgress = 40
	db BILLBOARD_BALL_SAVER_60, $4C
	db BILLBOARD_BIG_REWARD, $66
	db BILLBOARD_GENGAR_BONUS, $4C
	db $FF, $00
	db $FF, $00

	; wSlotRewardProgress = 50
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $4C
	db BILLBOARD_BALL_SAVER_30, $4C
	db BILLBOARD_PIKACHU_SAVER, $4C
	db $FF, $00

	; wSlotRewardProgress = 60
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $4C
	db BILLBOARD_BALL_SAVER_30, $4C
	db BILLBOARD_CATCHEM_MODE, $4C
	db $FF, $00

	; wSlotRewardProgress = 70
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $44
	db BILLBOARD_BALL_SAVER_30, $44
	db BILLBOARD_PIKACHU_SAVER, $44
	db BILLBOARD_BIG_REWARD, $16

	; wSlotRewardProgress = 80
	db BILLBOARD_SMALL_REWARD, $19
	db BILLBOARD_BONUS_MULTIPLIER, $4C
	db BILLBOARD_BALL_SAVER_30, $4C
	db BILLBOARD_EVOLUTION_MODE, $4C
	db $FF, $00

	; wSlotRewardProgress = 90
	db BILLBOARD_BALL_SAVER_60, $3F
	db BILLBOARD_BIG_REWARD, $3F
	db BILLBOARD_GENGAR_BONUS, $3F
	db BILLBOARD_GREAT_BALL, $3F
	db $FF, $00

	; wSlotRewardProgress = 100
	db BILLBOARD_SMALL_REWARD, $11
	db BILLBOARD_BONUS_MULTIPLIER, $4F
	db BILLBOARD_BALL_SAVER_30, $4F
	db BILLBOARD_PIKACHU_SAVER, $4F
	db $FF, $00

	; wSlotRewardProgress = 110
	db BILLBOARD_SMALL_REWARD, $11
	db BILLBOARD_BONUS_MULTIPLIER, $4F
	db BILLBOARD_BALL_SAVER_60, $4F
	db BILLBOARD_CATCHEM_MODE, $4F
	db $FF, $00

	; wSlotRewardProgress = 120
	db BILLBOARD_SMALL_REWARD, $11
	db BILLBOARD_BONUS_MULTIPLIER, $44
	db BILLBOARD_BALL_SAVER_30, $44
	db BILLBOARD_PIKACHU_SAVER, $44
	db BILLBOARD_BIG_REWARD, $1E

	; wSlotRewardProgress = 130
	db BILLBOARD_SMALL_REWARD, $11
	db BILLBOARD_BONUS_MULTIPLIER, $4F
	db BILLBOARD_BALL_SAVER_60, $4F
	db BILLBOARD_EVOLUTION_MODE, $4F
	db $FF, $00

	; wSlotRewardProgress = 140
	db BILLBOARD_BALL_SAVER_90, $66
	db BILLBOARD_BIG_REWARD, $4C
	db BILLBOARD_GENGAR_BONUS, $4C
	db $FF, $00
	db $FF, $00

	; wSlotRewardProgress = 150
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $51
	db BILLBOARD_BALL_SAVER_30, $51
	db BILLBOARD_PIKACHU_SAVER, $51
	db $FF, $00

	; wSlotRewardProgress = 160
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $51
	db BILLBOARD_BALL_SAVER_60, $51
	db BILLBOARD_CATCHEM_MODE, $51
	db $FF, $00

	; wSlotRewardProgress = 170
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $44
	db BILLBOARD_BALL_SAVER_30, $44
	db BILLBOARD_PIKACHU_SAVER, $44
	db BILLBOARD_BIG_REWARD, $26

	; wSlotRewardProgress = 180
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $51
	db BILLBOARD_BALL_SAVER_60, $51
	db BILLBOARD_EVOLUTION_MODE, $51
	db $FF, $00

	; wSlotRewardProgress = 190
	db BILLBOARD_BALL_SAVER_60, $3F
	db BILLBOARD_BIG_REWARD, $3F
	db BILLBOARD_GENGAR_BONUS, $3F
	db BILLBOARD_GREAT_BALL, $3F
	db $FF, $00

	; wSlotRewardProgress = 200
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $51
	db BILLBOARD_BALL_SAVER_30, $51
	db BILLBOARD_PIKACHU_SAVER, $51
	db $FF, $00

	; wSlotRewardProgress = 210
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $51
	db BILLBOARD_BALL_SAVER_60, $51
	db BILLBOARD_CATCHEM_MODE, $51
	db $FF, $00

	; wSlotRewardProgress = 220
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $44
	db BILLBOARD_BALL_SAVER_30, $44
	db BILLBOARD_PIKACHU_SAVER, $44
	db BILLBOARD_BIG_REWARD, $26

	; wSlotRewardProgress = 230
	db BILLBOARD_SMALL_REWARD, $0A
	db BILLBOARD_BONUS_MULTIPLIER, $51
	db BILLBOARD_BALL_SAVER_60, $51
	db BILLBOARD_EVOLUTION_MODE, $51
	db $FF, $00

	; wSlotRewardProgress = 240
	db BILLBOARD_BALL_SAVER_60, $26
	db BILLBOARD_BIG_REWARD, $26
	db BILLBOARD_GENGAR_BONUS, $26
	db BILLBOARD_EXTRA_BALL, $8C
	db $FF, $00
