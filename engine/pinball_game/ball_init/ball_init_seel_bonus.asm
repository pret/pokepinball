InitBallSeelBonusStage: ; 0x25af1
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
	ld [wd766], a
	ld a, $0
	ld [wd772], a
	ld a, $1
	ld [wd77c], a
	ld a, $0
	ld [wd786], a
	ld a, $4
	ld [wd775], a
	ld [wd77f], a
	ld [wd76b], a
	ld a, $1
	ld [wd76c], a
	ld a, $4
	ld [wd776], a
	ld a, $1
	ld [wd780], a
	ld a, $5
	ld [wd771], a
	ld [wd77b], a
	ld [wd785], a
	ld a, $ff
	ld [wd79a], a
	xor a
	ld [wd792], a
	ld [wd791], a
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
	ld de, wd76b
	ld a, [wd76c]
	call Func_26137
	ld de, wd775
	ld a, [wd776]
	call Func_26137
	ld de, wd77f
	ld a, [wd780]
	call Func_26137
	ld a, [wLostBall]
	and a
	ret z
	xor a
	ld [wLostBall], a
	ret
