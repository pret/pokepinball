HandleBallLossRedField: ; 0xdd76
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
	call ConcludeSpecialMode_RedField
	ld a, [wCurBonusMultiplierFromFieldEvents]
	and a
	jr z, .asm_dddd
	dec a
	ld [wCurBonusMultiplierFromFieldEvents], a
	ld a, $1
	ld [wd49c], a
	ld de, EndOfBallBonusText
	call ShowBallLossText
	ret

.asm_dddd
	ld a, [wCurBallLife]
	ld hl, wNumBallLives
	cp [hl]
	jr z, .gameOver
	inc a
	ld [wCurBallLife], a
	ld de, EndOfBallBonusText
	call ShowBallLossText
	ret

.gameOver
	ld de, EndOfBallBonusText
	call ShowBallLossText
	ld a, $1
	ld [wGameOver], a
	ret

ConcludeSpecialMode_RedField: ; 0xddfd
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	jr nz, .notCatchEmMode
	callba ConcludeCatchEmMode
	jr .setCollisionState

.notCatchEmMode
	cp SPECIAL_MODE_EVOLUTION
	jr nz, .notEvolutionMode
	xor a
	ld [wSlotIsOpen], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	callba ConcludeEvolutionMode
	jr .setCollisionState

.notEvolutionMode
	xor a
	ld [wSlotIsOpen], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	callba ConcludeMapMoveMode
.setCollisionState
	ld a, [wd7ad]
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	ret

Func_de4e: ; 0xde4e
; unused
	ret
