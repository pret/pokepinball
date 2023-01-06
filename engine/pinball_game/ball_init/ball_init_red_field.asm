InitBallRedField: ; 0x3007d
	ld a, [wReturningFromBonusStage]
	and a
	jp nz, StartBallAfterBonusStageRedField
	ld a, $0
	ld [wBallXPos], a
	ld a, $a7
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $98
	ld [wBallYPos + 1], a
	xor a
	ld [wEnableBallGravityAndTilt], a
	ld [wd580], a
	ld a, [wd7ad]
	bit 7, a
	jr z, .asm_300ae
	ld a, [wStageCollisionState]
	res 0, a
	ld [wd7ad], a
.asm_300ae
	ld a, [wStageCollisionState]
	and $1
	ld [wStageCollisionState], a
	ld a, [wLostBall]
	and a
	ret z
	xor a
	ld [wLostBall], a
	xor a
	ld [wSpinnerVelocity], a
	ld [wSpinnerVelocity + 1], a
	ld [wPikachuSaverSlotRewardActive], a
	ld [wPikachuSaverCharge], a
	ld [wd51e], a
	ld hl, wCAVELightStates
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wLeftMapMoveCounter], a
	ld [wRightMapMoveCounter], a
	ld hl, wBallUpgradeTriggerStates
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wBallType], a
	ld [wd611], a
	ld [wd612], a
	ld [wNumPokemonCaughtInBallBonus], a
	ld [wNumPokemonEvolvedInBallBonus], a
	ld [wNumBellsproutEntries], a
	ld [wNumDugtrioTriples], a
	ld [wNumCAVECompletions], a
	ld [wNumSpinnerTurns], a
	ld [wNumPikachuSaves], a
	ld [wShowBonusMultiplierBottomMessage], a
	inc a
	ld [wCurBonusMultiplier], a
	ld [wLeftDiglettAnimationController], a
	ld [wRightDiglettAnimationController], a
	ld a, $3
	ld [wd610], a
	callba GetBCDForNextBonusMultiplier_RedField
	ld a, Bank(Music_RedField)
	call SetSongBank
	ld de, MUSIC_RED_FIELD
	call PlaySong
	ret

StartBallAfterBonusStageRedField: ; 0x30128
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
	ld [wReturningFromBonusStage], a
	ld [wSCX], a
	ld [wFlippersDisabled], a
	ld a, [wBallTypeBackup]
	ld [wBallType], a
	ld a, Bank(Music_RedField)
	call SetSongBank
	ld de, MUSIC_RED_FIELD
	call PlaySong
	ret
