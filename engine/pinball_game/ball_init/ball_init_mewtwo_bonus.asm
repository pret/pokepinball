InitBallMewtwoBonusStage: ; 0x192e3
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd6a9], a
	ld a, [wLostBall]
	and a
	ret z
	xor a
	ld [wLostBall], a
	ret
