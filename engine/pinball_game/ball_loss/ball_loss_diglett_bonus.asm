HandleBallLossDiglettBonus: ; 0xe056
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	lb de, $00, $0b
	call PlaySoundEffect
	xor a
	ld [wGoingToBonusStage], a
	ld a, $1
	ld [wReturningFromBonusStage], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wDisableHorizontalScrollForBallStart], a
	ld a, [wCompletedBonusStage]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	ld de, EndDiglettStageText
	call LoadScrollingText
	ret
