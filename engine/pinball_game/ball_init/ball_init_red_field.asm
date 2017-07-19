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
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	xor a
	ld [wd50b], a
	ld [wd50c], a
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
	ld [wd613], a
	inc a
	ld [wCurBonusMultiplier], a
	ld [wLeftDiglettAnimationController], a
	ld [wRightDiglettAnimationController], a
	ld a, $3
	ld [wd610], a
	callba GetBCDForNextBonusMultiplier_RedField
	ld a, $f
	call SetSongBank
	ld de, $0001
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
	ld [wd7be], a
	ld a, [wBallTypeBackup]
	ld [wBallType], a
	ld a, $f
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret
