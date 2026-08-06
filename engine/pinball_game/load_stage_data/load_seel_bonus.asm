_LoadStageDataSeelBonus: ; 0x25b97
	callba LoadBallGraphics
	call LoadFlippersPalette
	callba UpdateSeelStageScoreDisplay
	call QueueGateGraphicsToLoad_SeelBonus
	callba LoadTimerGraphics
	ret
