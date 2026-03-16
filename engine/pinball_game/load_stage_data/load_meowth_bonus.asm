_LoadStageDataMeowthBonus: ; 0x24128
	callba LoadBallGraphics
	call LoadFlippersPalette
	callba UpdateMeowthMultiplierAnimation
	call QueueGateGraphicsToLoad_MeowthBonus
	callba LoadTimerGraphics
	ret
