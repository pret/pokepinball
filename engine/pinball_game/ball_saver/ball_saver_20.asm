Start20SecondSaverTimer: ; 0xdbba
	ld a, $1
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wBallSaverFlashRate], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 20
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret
