Start60SecondSaverTimer: ; 0xef4f
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wd4a2], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 60
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret