InitBallSaverForCatchEmMode: ; 0xdbd4
	ld a, [wBallSaverTimerFrames]
	ld [wBallSaverTimerFramesBackup], a
	ld a, [wBallSaverTimerSeconds]
	ld [wBallSaverTimerSecondsBackup], a
	ld a, [wNumTimesBallSavedTextWillDisplay]
	ld [wNumTimesBallSavedTextWillDisplayBackup], a
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wBallSaverFlashRate], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 60
	ld [wBallSaverTimerSeconds], a
	ld a, $ff
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret

RestoreBallSaverAfterCatchEmMode: ; 0xdc00
	ld a, [wBallSaverTimerFramesBackup]
	ld [wBallSaverTimerFrames], a
	ld a, [wBallSaverTimerSecondsBackup]
	ld [wBallSaverTimerSeconds], a
	ld a, [wNumTimesBallSavedTextWillDisplayBackup]
	ld [wNumTimesBallSavedTextWillDisplay], a
	ld a, [wBallSaverTimerSeconds]
	and a
	jr z, .SetSaverIconOff
	ld a, $1
.SetSaverIconOff
	ld [wBallSaverIconOn], a
	ld a, [wBallSaverTimerSeconds]
	ld c, $0
	cp $2
	jr c, .asm_dc34
	ld c, $4
	cp $6
	jr c, .asm_dc34
	ld c, $10
	cp $b
	jr c, .asm_dc34
	ld c, $ff
.asm_dc34
	ld a, c
	ld [wBallSaverFlashRate], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba DrawBallSaverIcon
	ret
