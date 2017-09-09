InitBallGengarBonusStage: ; 0x18157
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd653], a
	xor a
	ld [wd674], a
	ld a, $8
	ld [wd690], a
	ld [wd6a1], a
	ld a, [wLostBall]
	and a
	ret z
	xor a
	ld [wLostBall], a
	ret
