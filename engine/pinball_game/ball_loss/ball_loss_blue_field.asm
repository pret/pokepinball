HandleBallLossBlueField: ; 0xde4f
	ld a, [wBallSaverTimerFrames]
	ld hl, wBallSaverTimerSeconds
	or [hl]
	jr z, .youLose
	ld a, [wNumTimesBallSavedTextWillDisplay]
	bit 7, a
	jr nz, .skip_save_text
	dec a
	ld [wNumTimesBallSavedTextWillDisplay], a
	push af
	ld de, BallSavedText
	call ShowBallLossText
	pop af
	jr nz, .skip_save_text
	ld a, $1
	ld [wBallSaverTimerFrames], a
	ld [wBallSaverTimerSeconds], a
.skip_save_text
	lb de, $15, $02
	call PlaySoundEffect
	ret

.youLose
	ld de, MUSIC_NOTHING
	call PlaySong
	ld bc, $001e
	call AdvanceFrames
	lb de, $25, $24
	call PlaySoundEffect
	call Start20SecondSaverTimer
	ld a, $1
	ld [wLostBall], a
	xor a
	ld [wPinballLaunched], a
	ld [wd4df], a
	call ConcludeSpecialMode_BlueField
	ld a, [wCurBonusMultiplierFromFieldEvents]
	and a
	jr z, .noExtraBall
	dec a
	ld [wCurBonusMultiplierFromFieldEvents], a
	ld a, $1
	ld [wd49c], a ; Extra Ball
	ld de, EndOfBallBonusText
	call ShowBallLossText
	ret

.noExtraBall
	ld a, [wd49d]
	ld hl, wd49e
	cp [hl]
	jr z, .gameOver
	inc a
	ld [wd49d], a
	ld de, EndOfBallBonusText
	call ShowBallLossText
	ret

.gameOver
	ld de, EndOfBallBonusText
	call ShowBallLossText
	ld a, $1
	ld [wGameOver], a
	ret

ConcludeSpecialMode_BlueField: ; 0xded6
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	jr nz, .notCatchEmMode
	callba ConcludeCatchEmMode
	ret

.notCatchEmMode
	cp SPECIAL_MODE_EVOLUTION
	jr nz, .notEvolutionMode
	ld a, $0
	ld [wSlotIsOpen], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	callba ConcludeEvolutionMode
	ret

.notEvolutionMode
	ld a, $0
	ld [wSlotIsOpen], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	callba ConcludeMapMoveMode
	ret
