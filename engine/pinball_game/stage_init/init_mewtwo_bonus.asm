InitMewtwoBonusStage: ; 0x1924f
	ld a, [wLoadingSavedGame]
	and a
	ret nz
	xor a
	ld [wStageCollisionState], a
	ld a, $1
	ld [wDisableHorizontalScrollForBallStart], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wBallSize], a
	ld [wBallType], a
	ld [wCompletedBonusStage], a
	ld hl, InitMewtwoOrbitingBallData
	ld de, wOrbitingBall0
	ld b, $c
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld hl, Data_192db
	ld de, wMewtwoAnimation
	ld b, $8
.loop2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop2
	ld bc, $0200  ; 2 minutes 0 seconds
	callba StartTimer
	ld a, Bank(Music_MewtwoStage)
	call SetSongBank
	ld de, MUSIC_MEWTWO_STAGE
	call PlaySong
	ret

InitMewtwoOrbitingBallData:
	db $01, $01, $00, $00
	db $00, $62, $08, $00
	db $01, $01, $00, $00
	db $00, $55, $1F, $0C
	db $01, $01, $00, $00
	db $00, $3B, $1F, $18
	db $01, $01, $00, $00
	db $00, $2E, $08, $24
	db $01, $01, $00, $00
	db $00, $3B, $F1, $30
	db $01, $01, $00, $00
	db $00, $55, $F1, $3C

Data_192db:
	db $01, $00, $00, $00, $00, $00, $00, $00
