InitBlueField: ; 0x1c000
	ld a, [wLoadingSavedGame]
	and a
	ret nz
	xor a
	ld hl, wScore + $5
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ld [wNumPartyMons], a
	ld [wExtraBalls], a
	ld [wLostBall], a
	ld [wBallType], a
	ld [wd4c8], a
	ld hl, wPreviousNumPokeballs
	ld [hli], a
	ld [hli], a ; wNumPokeballs
	ld [hli], a ; wPokeballBlinkingCounter
	ld [wDisableHorizontalScrollForBallStart], a
	ld [wFlippersDisabled], a
	ld [wCurrentMap], a  ; PALLET_TOWN
	ld a, 1
	ld [wCurBallLife], a
	ld [wCurBonusMultiplier], a
	ld a, 2
	ld [wRightAlleyCount], a
	ld a, 3
	ld [wNumBallLives], a
	ld [wd610], a
	ld a, BONUS_STAGE_ORDER_MEOWTH
	ld [wNextBonusStage], a
	ld [wInitialNextBonusStage], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 3], a
	ld a, $82
	ld [wIndicatorStates + 1], a
	xor a
	ld [wd648], a
	ld [wd649], a
	ld [wd64a], a
	ld [wd643], a
	ld [wd644], a
	ld [wPsyduckState], a
	ld [wPoliwagState], a
	callba Start20SecondSaverTimer
	callba GetBCDForNextBonusMultiplier_BlueField
	ld a, Bank(Music_BlueField)
	call SetSongBank
	ld de, MUSIC_BLUE_FIELD
	call PlaySong
	ret
