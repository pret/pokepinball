InitGengarBonusStage: ; 0x18099
	ld a, [wLoadingSavedGame]
	and a
	jr z, .asm_180ac
	xor a
	ld [wd674], a
	ld a, $8
	ld [wd690], a
	ld [wd6a1], a
	ret
.asm_180ac
	ld a, $1
	ld [wDisableHorizontalScrollForBallStart], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wCompletedBonusStage], a
	ld hl, GastlyInitialData
	ld de, wd659
	call Copy9BytesToDE
	call Copy9BytesToDE
	call Copy9BytesToDE
	ld hl, HaunterInitialData
	ld de, wd67e
	call Copy9BytesToDE
	call Copy9BytesToDE
	ld hl, GengarInitialData
	ld de, wd698
	call Copy9BytesToDE
	xor a
	ld [wd67b], a
	ld [wd695], a
	ld hl, wd6a2
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd656], a
	ld bc, $0130  ; 1 minute 30 seconds
	callba StartTimer
	ld a, Bank(Music_GastlyInTheGraveyard)
	call SetSongBank
	ld de, MUSIC_GASTLY_GRAVEYARD
	call PlaySong
	ret

Copy9BytesToDE: ; 0x18112
	ld b, $3
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
	dec b
	jr nz, .loop
	ret

GastlyInitialData: ; 0x18121
; Gastly 1
	db $01, $01
	db $00, $00 ; wGastly1AnimationState
	db $00
	db $00, $08 ; wGastly1XPos
	db $00, $08 ; wGastly1YPos
; Gastly 2
	db $01, $01
	db $00, $00 ; wGastly2AnimationState
	db $00
	db $00, $50 ; wGastly2XPos
	db $00, $20 ; wGastly2YPos
; Gastly 3
	db $01, $01
	db $00, $00 ; wGastly2AnimationState
	db $00
	db $00, $30 ; wGastly3XPos
	db $00, $38 ; wGastly3YPos

HaunterInitialData: ; 0x1813c
; Haunter 1
	db $00, $01
	db $00, $00 ; wHaunter1AnimationState
	db $00
	db $00, $50 ; wHaunter1XPos
	db $00, $10 ; wHaunter1YPos
; Haunter 2
	db $00, $01
	db $00, $00 ; wHaunter2AnimationState
	db $00
	db $00, $10 ; wHaunter2XPos
	db $00, $34 ; wHaunter2YPos

GengarInitialData: ; 0x1814e
	db $00, $01 
	db $00, $00 ; wGengarAnimationState
	db $04 
	db $00, $38 ; wGengarXPos
	db $00, $F8 ; wGengarYPos
