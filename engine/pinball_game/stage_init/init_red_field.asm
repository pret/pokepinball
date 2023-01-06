InitRedField: ; 0x30000
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
	ld [wNextBonusStage], a ; BONUS_STAGE_ORDER_DIGLETT
	ld [wInitialNextBonusStage], a ; BONUS_STAGE_ORDER_DIGLETT
	ld a, $4
	ld [wStageCollisionState], a
	ld [wd7ad], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 3], a
	ld a, $82
	ld [wIndicatorStates + 1], a
	callba Start20SecondSaverTimer
	callba GetBCDForNextBonusMultiplier_RedField
	ld a, Bank(Music_RedField)
	call SetSongBank
	ld de, MUSIC_RED_FIELD
	call PlaySong
	ret
