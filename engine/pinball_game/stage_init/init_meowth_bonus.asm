InitMeowthBonusStage: ; 0x24000
	ld a, [wLoadingSavedGame]
	and a
	ret nz
	xor a
	ld [wd4c8], a
	ld [wStageCollisionState], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wCompletedBonusStage], a
	ld a, $1
	ld [wDisableHorizontalScrollForBallStart], a
	ld a, $40
	ld [wMeowthXPosition], a
	ld a, $20
	ld [wMeowthYPosition], a
	ld a, $10
	ld [wMeowthAnimationFrameCounter], a
	xor a
	ld [wMeowthStageScore], a
	ld [wNumActiveJewelsBottom], a
	ld [wMeowthStageBonusCounter], a
	ld [wDisableMeowthJewelProduction], a
	ld [wd739], a
	ld bc, $0100  ; 1 minute 0 seconds
	callba StartTimer
	ld a, Bank(Music_MeowthStage)
	call SetSongBank
	ld de, MUSIC_MEOWTH_STAGE
	call PlaySong
	ret
