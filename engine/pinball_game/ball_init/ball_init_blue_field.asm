InitBallBlueField: ; 0x1c08d
	ld a, [wReturningFromBonusStage]
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
	ld [wEnableBallGravityAndTilt], a
	ld [wd580], a
	call InitBlueFieldCollisionAttributes
	ld a, [wLostBall]
	and a
	ret z
	xor a
	ld [wLostBall], a
	xor a
	ld [wSpinnerVelocity], a
	ld [wSpinnerVelocity + 1], a
	ld [wPikachuSaverSlotRewardActive], a
	ld [wd51e], a
	ld [wPikachuSaverCharge], a
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
	ld [wNumSlowpokeEntries], a
	ld [wNumCloysterEntries], a
	ld [wNumPoliwagTriples], a
	ld [wNumPsyduckTriples], a
	ld [wNumSpinnerTurns], a
	ld [wNumPikachuSaves], a
	ld [wShowBonusMultiplierBottomMessage], a
	inc a
	ld [wCurBonusMultiplier], a
	ld [wLeftDiglettAnimationController], a
	ld [wRightDiglettAnimationController], a
	ld a, $3
	ld [wd610], a
	call GetBCDForNextBonusMultiplier_BlueField
	ld a, Bank(Music_BlueField)
	call SetSongBank
	ld de, MUSIC_BLUE_FIELD
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
	ld [wReturningFromBonusStage], a
	ld [wSCX], a
	ld [wFlippersDisabled], a
	ld a, [wBallTypeBackup]
	ld [wBallType], a
	ld a, Bank(Music_BlueField)
	call SetSongBank
	ld de, MUSIC_BLUE_FIELD
	call PlaySong
	ret
