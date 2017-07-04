InitDiglettBonusStage: ; 0x199f2
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld [wStageCollisionState], a
	ld a, $1
	ld [wd7ac], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wCompletedBonusStage], a
	; initialize all digletts to hiding
	ld a, $1  ; hiding diglett state
	ld hl, wDiglettStates
	ld b, NUM_DIGLETTS
.initDiglettsLoop
	ld [hli], a
	dec b
	jr nz, .initDiglettsLoop
	ld a, $1
	ld [wDugtrioAnimationFrameCounter], a
	ld a, $c
	ld [wDugtrioAnimationFrame], a
	xor a
	ld [wDugtrioAnimationIndex], a
	ld [wDugrioState], a
	ld a, $11
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret
