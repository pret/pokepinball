HandleBallLossSeelBonus: ; 0xe08b
	xor a
	ld [wd64e], a
	ld a, [wd7be]
	and a
	jr z, .asm_e09b
	ld a, [wCompletedBonusStage]
	and a
	jr z, .asm_e0b8
.asm_e09b
	ld a, [wd793]
	cp $14
	jr nc, .asm_e0b8
	cp $5
	jr c, .asm_e0aa
	sub $4
	jr .asm_e0ab

.asm_e0aa
	xor a
.asm_e0ab
	ld [wd793], a
	callba Func_262f4
.asm_e0b8
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd794]
	cp $0
	jr nz, .asm_e0c8
	ret

.asm_e0c8
	lb de, $00, $02
	call PlaySoundEffect
	xor a
	ld [wTimerActive], a
	ld [wTimerActive], a ; duplicate instruction
	ld [wGoingToBonusStage], a
	ld a, $1
	ld [wReturningFromBonusStage], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wDisableHorizontalScrollForBallStart], a
	ld [wd794], a
	ld a, [wCompletedBonusStage]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	ld de, EndSeelStageText
	call LoadScrollingText
	ret
