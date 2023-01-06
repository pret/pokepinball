_LoadStageDataGengarBonus: ; 0x1818b
	callba LoadBallGraphics
	call LoadFlippersPalette
	call Func_18d72
	ld a, [wLoadingSavedGame]
	callba LoadTimerGraphics
	and a
	ret z
	call Func_183db
	call Func_18d91
	ret
