Func_18000: ; 0x18000
; unused -- Stage init function for unused stage.
	ld hl, wc000
	ld bc, $0a00
	call ClearData
	ld a, $1
	ld [rVBK], a
	hlCoord 0, 0, vBGWin
	ld bc, $0400
	call ClearData
	xor a
	ld [rVBK], a
	ld hl, wWhichVoltorb
	ld bc, $032e
	call ClearData
	xor a
	ld hl, wScore + $5
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ld [wNumPartyMons], a
	ld [wCurBonusMultiplierFromFieldEvents], a
	ld [wd4c9], a
	ld a, $1
	ld [wd49d], a
	ld a, $3
	ld [wd49e], a
	callba Start20SecondSaverTimer
	ret
