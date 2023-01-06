HandleBallLossMewtwoBonus: ; 0xdf7e
	ld a, [wCurrentStageBackup]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd6b3]
	and a
	jr nz, .asm_dfbb
	ld a, [wd6b1]
	cp $8
	jr c, .asm_dfb4
	xor a
	ld [wMoveToNextScreenState], a
	ld a, [wd6b2]
	and a
	ret nz
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $1
	ld [wd6b2], a
.asm_dfb4
	lb de, $00, $0b
	call PlaySoundEffect
	ret

.asm_dfbb
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
	call EnableBottomText
	ld hl, wScrollingText3
	ld de, EndMewtwoStageText
	call LoadScrollingText
	ret
