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
	ld de, $0000
	call PlaySong
	ld bc, $001e
	call AdvanceFrames
	lb de, $25, $24
	call PlaySoundEffect
	call Start20SecondSaverTimer
	ld a, $1
	ld [wd4c9], a
	xor a
	ld [wPinballLaunched], a
	ld [wd4df], a
	call Func_ded6
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

Func_ded6: ; 0xded6
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	jr nz, .asm_deec
	callba ConcludeCatchEmMode
	ret

.asm_deec
	cp SPECIAL_MODE_EVOLUTION
	jr nz, .asm_df05
	ld a, $0
	ld [wSlotIsOpen], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	callba ConcludeEvolutionMode
	ret

.asm_df05
	ld a, $0
	ld [wSlotIsOpen], a
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	callba Func_3022b
	ret
