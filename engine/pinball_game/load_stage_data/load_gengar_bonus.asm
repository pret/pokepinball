_LoadStageDataGengarBonus: ; 0x1818b
	callba LoadBallGraphics
	call LoadFlippersPalette
	call QueueSecondaryGateGraphics_GengarBonus
	ld a, [wLoadingSavedGame]
	callba LoadTimerGraphics
	and a
	ret z
	call QueueGateGraphicsToLoad_GengarBonus
	call UpdateGateCollisionMapTiles_GengarBonus
	ret
