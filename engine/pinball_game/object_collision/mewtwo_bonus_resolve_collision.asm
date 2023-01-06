ResolveMewtwoBonusGameObjectCollisions: ; 0x19451
	call Func_19531
	call Func_19701
	call TryCloseGate_MewtwoBonus
	callba PlayLowTimeSfx
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $1
	ld [wFlippersDisabled], a
	call LoadFlippersPalette
	callba StopTimer
	ld a, [wd6b1]
	cp $8
	ret nc
	ld a, $1
	ld [wd6b3], a
	ret

TryCloseGate_MewtwoBonus: ; 0x1948b
	ld a, [wMewtwoBonusClosedGate]
	and a
	ret nz
	ld a, [wBallXPos + 1]
	cp 138
	ret nc
	ld a, 1
	ld [wStageCollisionState], a
	ld [wMewtwoBonusClosedGate], a
	callba LoadStageCollisionAttributes
	call Func_194ac
	ret

Func_194ac: ; 0x194ac
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_194c9
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_194bf
	ld hl, Data_194fd
.asm_194bf
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_194c9)
	call QueueGraphicsToLoad
	ret

Data_194c9:
	dw Data_194cd
	dw Data_194d0

Data_194cd: ; 0x194cd
	db 1
	dw Data_194d3

Data_194d0: ; 0x194d0
	db 1
	dw Data_194e8

Data_194d3: ; 0x194d3
	dw LoadTileLists
	db $05 ; total number of tiles to load

	db $01 ; number of tiles
	dw vBGMap + $113
	db $45

	db $01 ; number of tiles
	dw vBGMap + $133
	db $80

	db $02 ; number of tiles
	dw vBGMap + $152
	db $80, $09

	db $01 ; number of tiles
	dw vBGMap + $172
	db $12

	db $00 ; terminator

Data_194e8: ; 0x194e8
	dw LoadTileLists
	db $05 ; total number of tiles to load

	db $01 ; number of tiles
	dw vBGMap + $113
	db $46

	db $01 ; number of tiles
	dw vBGMap + $133
	db $47

	db $02 ; number of tiles
	dw vBGMap + $152
	db $48, $49

	db $01 ; number of tiles
	dw vBGMap + $172
	db $4A

	db $00 ; terminator

Data_194fd:
	dw Data_19501
	dw Data_19504

Data_19501: ; 0x19501
	db 1
	dw Data_19507

Data_19504: ; 0x19504
	db 1
	dw Data_1951c

Data_19507: ; 0x19507
	dw LoadTileLists
	db $05 ; total number of tiles to load

	db $01 ; number of tiles
	dw vBGMap + $113
	db $45

	db $01 ; number of tiles
	dw vBGMap + $133
	db $80

	db $02 ; number of tiles
	dw vBGMap + $152
	db $80, $09

	db $01 ; number of tiles
	dw vBGMap + $172
	db $12

	db $00 ; terminator

Data_1951c: ; 0x1951c
	dw LoadTileLists
	db $05 ; total number of tiles to load

	db $01 ; number of tiles
	dw vBGMap + $113
	db $46

	db $01 ; number of tiles
	dw vBGMap + $133
	db $47

	db $02 ; number of tiles
	dw vBGMap + $152
	db $48, $49

	db $01 ; number of tiles
	dw vBGMap + $172
	db $4A

	db $00 ; terminator

Func_19531: ; 0x19531
	ld a, [wd6aa]
	and a
	jr z, .asm_195a2
	xor a
	ld [wd6aa], a
	ld a, [wFlippersDisabled]
	and a
	jr nz, .asm_195a2
	ld a, [wd6af]
	cp $2
	jr nc, .asm_195a2
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueue
	ld a, [wd6b0]
	inc a
	cp $3
	jr nz, .asm_19565
	ld a, [wd6b1]
	inc a
	ld [wd6b1], a
	xor a
.asm_19565
	ld [wd6b0], a
	call ResetOrbitingBalls
	ld a, [wd6b1]
	cp $8
	jr z, .asm_19582
	ld a, $2
	ld de, wd6ae
	call Func_19679
	lb de, $00, $39
	call PlaySoundEffect
	jr .asm_195a2

.asm_19582
	ld a, $3
	ld de, wd6ae
	call Func_19679
	ld a, $1
	ld [wFlippersDisabled], a
	call LoadFlippersPalette
	callba StopTimer
	ld de, MUSIC_NOTHING
	call PlaySong
.asm_195a2
	call Func_195ac
	ld de, wd6af
	call Func_195f5
	ret

Func_195ac: ; 0x195ac
	ld a, [wd6af]
	and a
	ret nz
	ld hl, wd6bd
	ld de, $0008
	ld b, $6
.asm_195b9
	ld a, [hl]
	cp $2b
	jr nz, .asm_195ce
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	cp $2
	ret nz
	ld a, $1
	ld de, wd6ae
	call Func_19679
	ret

.asm_195ce
	add hl, de
	dec b
	jr nz, .asm_195b9
	ret

Func_195d3: ; 0x195d3
	ld hl, wd6bd
	ld de, $0008
	ld b, $6
.asm_195db
	ld a, [hl]
	cp $18
	jr nz, .asm_195f0
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	cp $2
	ret nz
	ld d, h
	ld e, l
	dec de
	ld a, $1
	call Func_19876
	ret

.asm_195f0
	add hl, de
	dec b
	jr nz, .asm_195db
	ret

Func_195f5: ; 0x195f5
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_19691
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	dec de
	call UpdateAnimation
	pop de
	ret nc
	ld a, [de]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_1960d: ; 0x1960d
	dw Func_19615
	dw Func_1961e
	dw Func_1962f
	dw Func_19638

Func_19615: ; 0x19615
	dec de
	ld a, [de]
	cp $4
	ret nz
	xor a
	jp Func_19679

Func_1961e: ; 0x1961e
	dec de
	ld a, [de]
	cp $c
	jr nz, .asm_19628
	call Func_195d3
	ret

.asm_19628
	cp $d
	ret nz
	xor a
	jp Func_19679

Func_1962f: ; 0x1962f
	dec de
	ld a, [de]
	cp $1
	ret nz
	xor a
	jp Func_19679

Func_19638: ; 0x19638
	dec de
	ld a, [de]
	cp $1
	jr nz, .asm_19645
	lb de, $00, $40
	call PlaySoundEffect
	ret

.asm_19645
	cp $20
	ret nz
	ld a, $1
	ld [wd6b3], a
	ld a, [wInitialNextBonusStage]
	ld [wNextBonusStage], a
	ld a, [wNumMewtwoBonusCompletions]
	cp $2  ; only counts up to 2. Gets reset to 0 when Mew is encountered in Catch 'Em Mode.
	jr z, .asm_1965e
	inc a
	ld [wNumMewtwoBonusCompletions], a
.asm_1965e
	ld a, $1
	ld [wCompletedBonusStage], a
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText3
.asm_1966b
	ld de, MewtwoStageClearedText
	call LoadScrollingText
	lb de, $4b, $2a
	call PlaySoundEffect
	ret

Func_19679: ; 0x19679
	push af
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_19691
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	pop af
	ld [de], a
	ret

Data_19691:
	dw Data_19699
	dw Data_196a2
	dw Data_196bd
	dw Data_196c0

Data_19699: ; 0x19699
	db $30, $00, $04, $05, $34, $04, $03, $05
	db $00 ; terminator

Data_196a2: ; 0x196a2
	db $0A, $00, $06, $01, $05, $02, $05, $01, $04, $02, $04, $01, $04, $02, $03, $01
	db $03, $02, $03, $01, $03, $02, $04, $00, $40, $03
	db $00 ; terminator

Data_196bd: ; 0x196bd
	db $10, $06
	db $00 ; terminator

Data_196c0: ; 0x196c0
	db $04, $06, $04, $07, $04, $06, $04, $07, $04, $06, $04, $07, $04, $06, $04, $07
	db $03, $06, $03, $07, $03, $06, $03, $07, $03, $06, $03, $07, $03, $06, $03, $07
	db $02, $06, $02, $07, $02, $06, $02, $07, $02, $06, $02, $07, $02, $06, $02, $07
	db $01, $06, $01, $07, $01, $06, $01, $07, $01, $06, $01, $07, $01, $06, $01, $07
	db $00 ; terminator

Func_19701: ; 0x19701
	ld a, [wd6b4]
	and a
	jr z, .asm_19742
	xor a
	ld [wd6b4], a
	ld a, [wFlippersDisabled]
	and a
	jr nz, .asm_19742
	ld a, [wd6b5]
	sub $1
	sla a
	sla a
	sla a
	ld c, a
	ld b, $0
	ld hl, wd6ba
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jr nz, .asm_19742
	dec de
	ld a, $2
	call Func_19876
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	lb de, $00, $38
	call PlaySoundEffect
.asm_19742
	ld de, wd6bd
	call SetOrbitingBallCoordinates
	ld de, wd6c5
	call SetOrbitingBallCoordinates
	ld de, wd6cd
	call SetOrbitingBallCoordinates
	ld de, wd6d5
	call SetOrbitingBallCoordinates
	ld de, wd6dd
	call SetOrbitingBallCoordinates
	ld de, wd6e5
	call SetOrbitingBallCoordinates
	ld de, wd6b6
	call UpdateOrbitingBallAnimation
	ld de, wd6be
	call UpdateOrbitingBallAnimation
	ld de, wd6c6
	call UpdateOrbitingBallAnimation
	ld de, wd6ce
	call UpdateOrbitingBallAnimation
	ld de, wd6d6
	call UpdateOrbitingBallAnimation
	ld de, wd6de
	call UpdateOrbitingBallAnimation
	ret

SetOrbitingBallCoordinates: ; 0x1978b
; Sets the x, y coordinates for one of the balls orbiting around Mewtwo
	ld a, [de]
	ld c, a
	ld b, $0
	sla c
	inc a
	cp $48 ; num entries in MewtwoOrbitingBallsCoords
	jr c, .looadCoords
	xor a
.looadCoords
	ld [de], a
	ld hl, MewtwoOrbitingBallsCoords + 1
	add hl, bc
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	ret

MewtwoOrbitingBallsCoords:
; x, y coordinates for balls that orbit around Mewtwo.
	db $62, $08
	db $62, $0A
	db $62, $0D
	db $61, $0F
	db $60, $11
	db $60, $13
	db $5F, $15
	db $5D, $17
	db $5C, $19
	db $5A, $1A
	db $59, $1C
	db $57, $1D
	db $55, $1F
	db $53, $20
	db $51, $20
	db $4F, $21
	db $4D, $22
	db $4A, $22
	db $48, $22
	db $46, $22
	db $43, $22
	db $41, $21
	db $3F, $20
	db $3D, $20
	db $3B, $1F
	db $39, $1D
	db $37, $1C
	db $36, $1A
	db $34, $19
	db $33, $17
	db $31, $15
	db $30, $13
	db $30, $11
	db $2F, $0F
	db $2E, $0D
	db $2E, $0A
	db $2E, $08
	db $2E, $06
	db $2E, $03
	db $2F, $01
	db $30, $FF
	db $30, $FD
	db $31, $FB
	db $33, $F9
	db $34, $F7
	db $36, $F6
	db $37, $F4
	db $39, $F3
	db $3B, $F1
	db $3D, $F0
	db $3F, $F0
	db $41, $EF
	db $43, $EE
	db $46, $EE
	db $48, $EE
	db $4A, $EE
	db $4D, $EE
	db $4F, $EF
	db $51, $F0
	db $53, $F0
	db $55, $F1
	db $57, $F3
	db $59, $F4
	db $5A, $F6
	db $5C, $F7
	db $5D, $F9
	db $5F, $FB
	db $60, $FD
	db $60, $FF
	db $61, $01
	db $62, $03
	db $62, $06

UpdateOrbitingBallAnimation: ; 0x19833
; Updates the animation for one of the balls orbiting around Mewtwo.
	ld a, [de]
	and a
	ret z
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, OrbitingBallAnimations
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	dec de
	call UpdateAnimation
	pop de
	ret nc
	ld a, [de]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_19852: ; 0x19852
	dw Func_1985a
	dw Func_19863
	dw Func_1986c
	dw Func_1986d

Func_1985a: ; 0x1985a
	dec de
	ld a, [de]
	cp $6
	ret nz
	xor a
	jp Func_19876

Func_19863: ; 0x19863
	dec de
	ld a, [de]
	cp $7
	ret nz
	xor a
	jp Func_19876

Func_1986c: ; 0x1986c
	ret

Func_1986d: ; 0x1986d
	dec de
	ld a, [de]
	cp $1
	ret nz
	xor a
	jp Func_19876

Func_19876: ; 0x19876
	push af
	sla a
	ld c, a
	ld b, $0
	ld hl, OrbitingBallAnimations
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	call InitAnimation
	pop de
	inc de
	pop af
	ld [de], a
	ret

ResetOrbitingBalls: ; 0x1988e
	ld a, [wd6b1]
	sla a
	sla a
	sla a
	ld c, a
	ld b, $0
	ld hl, OrbitingBallsStartCoordsIndices
	add hl, bc
	ld de, wd6bd
	ld b, $6
.asm_198a3
	ld a, [hli]
	push bc
	push de
	push hl
	bit 7, a
	jr nz, .asm_198b7
	ld [de], a
	dec de
	dec de
	dec de
	dec de
	ld a, $3
	call Func_19876
	jr .asm_198c0

.asm_198b7
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	xor a
	ld [de], a
.asm_198c0
	pop hl
	pop de
	pop bc
	ld a, e
	add $8
	ld e, a
	jr nc, .asm_198ca
	inc d
.asm_198ca
	dec b
	jr nz, .asm_198a3
	ret

OrbitingBallsStartCoordsIndices:
; When Mewtwo is hit, the orbs briefly disappear. When they reappear,
; this table determines which entry in the MewtwoOrbitingBallsCoords table
; each orb will start at.
; Last two bytes in each row are unused
	db $00, $0C, $18, $24, $30, $3C, $FF, $FF ; All 6 orbs are up
	db $00, $0E, $1D, $2B, $3A, $FF, $FF, $FF ; 5 orbs are up
	db $00, $12, $24, $36, $FF, $FF, $FF, $FF ; 4 orbs
	db $00, $12, $24, $36, $FF, $FF, $FF, $FF ; 3 orbs
	db $00, $18, $30, $FF, $FF, $FF, $FF, $FF ; 2 orbs
	db $00, $24, $FF, $FF, $FF, $FF, $FF, $FF ; 1 orb
	db $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; 0 orbs
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; unused
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF ; unused

OrbitingBallAnimations:
	dw OrbitingBallAnimation1
	dw OrbitingBallAnimation2
	dw OrbitingBallAnimation3
	dw OrbitingBallAnimation4

OrbitingBallAnimation1: ; 0x1991e
; Each entry is [duration][OAM id]
	db $0A, $00
	db $08, $01
	db $08, $02
	db $0A, $03
	db $08, $02
	db $08, $01
	db $00 ; terminator

OrbitingBallAnimation2: ; 0x1992b
; Each entry is [duration][OAM id]
	db $05, $04
	db $06, $05
	db $06, $06
	db $07, $07
	db $07, $08
	db $08, $09
	db $08, $0A
	db $00 ; terminator

OrbitingBallAnimation3: ; 0x1993a
; Each entry is [duration][OAM id]
	db $05, $0A
	db $05, $09
	db $04, $08
	db $04, $07
	db $03, $06
	db $03, $05
	db $02, $04
	db $80, $0B
	db $00 ; terminator

OrbitingBallAnimation4: ; 0x1994b
; Each entry is [duration][OAM id]
	db $0C, $0B
	db $00 ; terminator
