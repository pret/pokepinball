HandleBallLossMeowthBonus: ; 0xdfe2
	xor a
	ld [wd64e], a
	ld a, [wd7be]
	and a
	jr z, .asm_dff2
	ld a, [wCompletedBonusStage]
	and a
	jr z, .asm_e00f
.asm_dff2
	ld a, [wMeowthStageScore]
	cp 20
	jr nc, .asm_e00f
	cp 5
	jr c, .asm_e001
	sub $4
	jr .asm_e002

.asm_e001
	xor a
.asm_e002
	ld [wMeowthStageScore], a
	callba Func_24fa3
.asm_e00f
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd712]
	cp $0
	jr nz, .asm_e025
	lb de, $00, $02
	call PlaySoundEffect
	ret

.asm_e025
	xor a
	ld [wTimeRanOut], a
	ld [wTimerActive], a
	xor a
	ld [wGoingToBonusStage], a
	ld a, $1
	ld [wReturningFromBonusStage], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wDisableHorizontalScrollForBallStart], a
	ld [wd712], a
	ld a, [wCompletedBonusStage]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	ld de, EndMeowthStageText
	call LoadScrollingText
	ret
