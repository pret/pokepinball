InitBallBlueField: ; 0x1c08d
	ld a, [wd496]
	and a
	jp nz, StartBallAfterBonusStageBlueField
	ld a, $0
	ld [wBallXPos], a
	ld a, $a7
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $98
	ld [wBallYPos + 1], a
	xor a
	ld [wd549], a
	ld [wd580], a
	call Func_1c7c7
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	xor a
	ld [wd50b], a
	ld [wd50c], a
	ld [wd51d], a
	ld [wd51e], a
	ld [wPikachuSaverCharge], a
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wLeftMapMoveCounter], a
	ld [wRightMapMoveCounter], a
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wBallType], a
	ld [wd611], a
	ld [wd612], a
	ld [wd628], a
	ld [wd629], a
	ld [wd62a], a
	ld [wd62b], a
	ld [wd62c], a
	ld [wd63a], a
	ld [wd63b], a
	ld [wd63d], a
	ld [wd63c], a
	ld [wd62d], a
	ld [wd62e], a
	ld [wd613], a
	inc a
	ld [wd482], a
	ld [wd4ef], a
	ld [wd4f1], a
	ld a, $3
	ld [wd610], a
	call Func_1d65f
	ld a, $10
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

StartBallAfterBonusStageBlueField: ; 0x1c129
	ld a, $0
	ld [wBallXPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $16
	ld [wBallYPos + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wd496], a
	ld [wSCX], a
	ld [wd7be], a
	ld a, [wBallTypeBackup]
	ld [wBallType], a
	ld a, $10
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret
