_LoadStageDataMewtwoBonus: ; 0x19310
	callba Func_142fc
	call LoadFlippersPalette
	callba LoadTimerGraphics
	ld a, [wLoadingSavedGame]
	and a
	ret z
	call Func_194ac
	ret
