Start30SecondSaverTimer: ; 0xef35
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wBallSaverFlashRate], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 30
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret
