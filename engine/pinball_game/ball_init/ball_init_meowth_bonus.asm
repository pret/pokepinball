InitBallMeowthBonusStage: ; 0x24059
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	ld a, $40
	ld [wBallXVelocity], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wMeowthBonusClosedGate], a
	ld hl, wd6f3
	ld b, $16
.asm_24081
	ld a, [hl]
	and a
	jr z, .asm_24088
	ld a, $1
	ld [hl], a
.asm_24088
	inc hl
	dec b
	jr nz, .asm_24081
	ld a, $1
	ld [wDisableHorizontalScrollForBallStart], a
	ld a, $40
	ld [wMeowthXPosition], a
	ld a, $20
	ld [wMeowthYPosition], a
	ld a, $10
	ld [wMeowthAnimationFrameCounter], a
	ld a, $ff  ; walk left
	ld [wMeowthXMovement], a
	xor a
	ld [wMeowthAnimationFrame], a
	ld [wMeowthState], a
	ld [wMeowthAnimationIndex], a
	ld [wNumActiveJewelsBottom], a
	ld [wNumActiveJewelsTop], a
	ld a, $c8
	ld [wMeowthJewel0XCoord], a
	ld [wMeowthJewel0YCoord], a
	ld [wMeowthJewel1XCoord], a
	ld [wMeowthJewel1YCoord], a
	ld [wMeowthJewel2XCoord], a
	ld [wMeowthJewel2YCoord], a
	ld [wMeowthJewel3XCoord], a
	ld [wMeowthJewel3YCoord], a
	ld [wMeowthJewel4XCoord], a
	ld [wMeowthJewel4YCoord], a
	ld [wMeowthJewel5XCoord], a
	ld [wMeowthJewel5YCoord], a
	xor a
	ld [wMeowthJewel0State], a
	ld [wMeowthJewel1State], a
	ld [wMeowthJewel2State], a
	ld [wMeowthJewel3State], a
	ld [wMeowthJewel4State], a
	ld [wMeowthJewel5State], a
	ld [wMeowthJewel0AnimationIndex], a
	ld [wMeowthJewel1AnimationIndex], a
	ld [wMeowthJewel2AnimationIndex], a
	ld [wMeowthJewel3AnimationIndex], a
	ld [wMeowthJewel4AnimationIndex], a
	ld [wMeowthJewel5AnimationIndex], a
	ld [wd64e], a
	ld [wd64f], a
	ld [wd650], a
	ld [wd651], a
	ld [wd795], a
	ld [wd796], a
	ld [wd797], a
	ld [wd798], a
	ld [wd799], a
	ld [wd79a], a
	ld a, [wLostBall]
	and a
	ret z
	xor a
	ld [wLostBall], a
	ret
