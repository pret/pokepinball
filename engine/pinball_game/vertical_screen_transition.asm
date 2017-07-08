FieldVerticalTransition: ; 0xe674
	push af
	ld a, [wPinballIsVisible]
	push af
	xor a
	ld [wPinballIsVisible], a
	ld [wd803], a
	callba DrawSpritesForStage
	call CleanOAMBuffer
	pop af
	ld [wPinballIsVisible], a
	pop af
	ld [wCurrentStage], a
	xor a
	ld [hBGP], a
	ld [hOBP0], a
	ld [hOBP1], a
	rst AdvanceFrame
	call Func_e5d
	call Func_576
	call ClearOAMBuffer
	call Func_1129
	call LoadStageCollisionAttributes
	call LoadStageData
	call Func_e5d
	call Func_588
	ld a, $e4
	ld [hBGP], a
	ld a, $e1
	ld [hOBP0], a
	ld a, $e4
	ld [hOBP1], a
	ret

LoadStageData: ; 0xe6c2
; Loads all stage data, such as graphics, collision attributes, etc.
	ld a, [wCurrentStage]
	bit 0, a
	ld a, $86
	jr z, .asm_e6d5
	ld a, [wd5ca]
	and a
	ld a, $86
	jr nz, .asm_e6d5
	ld a, $90
.asm_e6d5
	ld [hWY], a
	ld hl, StageGfxPointers_GameBoy
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .loadData
	ld hl, StageGfxPointers_GameBoyColor
.loadData
	ld a, [wCurrentStage]
	call LoadVideoData
	xor a
	ld [wd7f2], a
	callba _LoadStageData
	ret

INCLUDE "data/stage_base_gfx.asm"

CheckStageTransition: ; 0xece9
	call Func_ed5e
	ld a, [wBallYPos + 1]
	add $10
	cp $18
	jr c, .moving_up
	cp $b8
	ret c
	ld a, [wCurrentStage]
	ld c, a
	ld b, $0
	ld hl, BallMovingDownStageTransitions
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .youLose
	call FieldVerticalTransition
	ld a, [wBallYPos + 1]
	sub $88
	ld [wBallYPos + 1], a
	ret

.moving_up
	ld a, [wCurrentStage]
	ld c, a
	ld b, $0
	ld hl, BallMovingUpStageTransitions
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .youLose
	call FieldVerticalTransition
	ld a, [wBallYPos + 1]
	add $88
	ld [wBallYPos + 1], a
	ret

.youLose
	ld a, $1
	ld [wd4ae], a
	callba HandleBallLoss
	ret

BallMovingUpStageTransitions: ; 0xed3e
; Maps the relationship between stages when
; the ball moves out of the screen upward.
	db $FF                   ; STAGE_RED_FIELD_TOP
	db STAGE_RED_FIELD_TOP   ; STAGE_RED_FIELD_BOTTOM
	db $FF
	db $02
	db $FF                   ; STAGE_BLUE_FIELD_TOP
	db STAGE_BLUE_FIELD_TOP  ; STAGE_BLUE_FIELD_BOTTOM
	db $FF                   ; STAGE_GENGAR_BONUS
	db $FF                   ; STAGE_GENGAR_BONUS
	db $FF                   ; STAGE_MEWTWO_BONUS
	db $FF                   ; STAGE_MEWTWO_BONUS
	db $FF                   ; STAGE_MEOWTH_BONUS
	db $FF                   ; STAGE_MEOWTH_BONUS
	db $FF                   ; STAGE_DIGLETT_BONUS
	db $FF                   ; STAGE_DIGLETT_BONUS
	db $FF                   ; STAGE_SEEL_BONUS
	db $FF                   ; STAGE_SEEL_BONUS

BallMovingDownStageTransitions: ; 0xed4e
; Maps the relationship between stages when
; the ball moves out of the screen downward.
	db STAGE_RED_FIELD_BOTTOM   ; STAGE_RED_FIELD_TOP
	db $FF                      ; STAGE_RED_FIELD_BOTTOM
	db $03
	db $FF
	db STAGE_BLUE_FIELD_BOTTOM  ; STAGE_BLUE_FIELD_TOP
	db $FF                      ; STAGE_BLUE_FIELD_BOTTOM
	db $FF                      ; STAGE_GENGAR_BONUS
	db $FF                      ; STAGE_GENGAR_BONUS
	db $FF                      ; STAGE_MEWTWO_BONUS
	db $FF                      ; STAGE_MEWTWO_BONUS
	db $FF                      ; STAGE_MEOWTH_BONUS
	db $FF                      ; STAGE_MEOWTH_BONUS
	db $FF                      ; STAGE_DIGLETT_BONUS
	db $FF                      ; STAGE_DIGLETT_BONUS
	db $FF                      ; STAGE_SEEL_BONUS
	db $FF                      ; STAGE_SEEL_BONUS

Func_ed5e: ; 0xed5e
	ld hl, wSCX
	ld a, [wd7ac]
	and a
	jr nz, .modify_scx_and_scy
	ld a, [wBallXPos + 1]
	cp $9a
	ld a,  2
	jr nc, .okay1
	ld a, -2
.okay1
	ld [wd7aa], a
	add [hl]
	cp $22
	jr z, .modify_scx_and_scy
	bit 7, a
	jr nz, .modify_scx_and_scy
	ld [hl], a
.modify_scx_and_scy
	ld a, [hl]
	ld hl, wd79f
	sub [hl]
	ld [hSCX], a
	xor a
	ld hl, wd7a0
	sub [hl]
	ld [hSCY], a
	ret
