InitBlueField: ; 0x1c000
	ld a, [wd7c1]
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
	ld [wd49b], a
	ld [wd4c9], a
	ld [wBallType], a
	ld [wd4c8], a
	ld hl, wd624
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd7ac], a
	ld [wd7be], a
	ld [wCurrentMap], a  ; PALLET_TOWN
	ld a, $1
	ld [wd49d], a
	ld [wd482], a
	ld a, $2
	ld [wRightAlleyCount], a
	ld a, $3
	ld [wd49e], a
	ld [wd610], a
	ld a, $2
	ld [wd498], a
	ld [wd499], a
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
	ld [wd645], a
	ld [wd646], a
	callba Start20SecondSaverTimer
	callba Func_1d65f
	ld a, $10
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret
