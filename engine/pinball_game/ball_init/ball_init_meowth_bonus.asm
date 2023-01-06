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
	ld [wd71a], a
	ld [wd727], a
	ld [wd71b], a
	ld [wd728], a
	ld [wd71c], a
	ld [wd729], a
	ld [wd724], a
	ld [wd731], a
	ld [wd725], a
	ld [wd732], a
	ld [wd726], a
	ld [wd733], a
	xor a
	ld [wd717], a
	ld [wd718], a
	ld [wd719], a
	ld [wd721], a
	ld [wd722], a
	ld [wd723], a
	ld [wd714], a
	ld [wd715], a
	ld [wd716], a
	ld [wd71e], a
	ld [wd71f], a
	ld [wd720], a
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
