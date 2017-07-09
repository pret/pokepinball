StartCatchEmMode: ; 0x1003f
	ld a, [wInSpecialMode]  ; current game mode?
	and a
	ret nz  ; don't start catch 'em mode if we're already doing something like Map Move mode
	ld a, $1
	ld [wInSpecialMode], a  ; set special mode flag
	xor a
	ld [wSpecialMode], a
	ld [wd54d], a ;set ??? to 0
	ld a, [wCurrentStage]
	sla a
	ld c, a ;store twice current stage to use a pointer offset
	ld b, $0
	push bc
	ld hl, WildMonOffsetsPointers
	add hl, bc
	ld a, [hli] ;hl = pointer to wild mon pointer table
	ld h, [hl]
	ld l, a
	ld a, [wCurrentMap]
	sla a
	ld c, a
	add hl, bc ;go to correct location in table
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a ;bc = offset needed to reach correct wild table
	pop de ;pop current stage offset
	ld hl, WildMonPointers
	add hl, de
	ld a, [hli] ;fetch start od correct wilds table, place in hl
	ld h, [hl]
	ld l, a
	add hl, bc
	call GenRandom
	and $f
	call CheckForMew ;a = $10 if mew, else is less
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wRareMonsFlag]  ; this gets set to $08 when the rare mons should be used.
	sla a
	ld c, a
	add hl, bc
	ld a, [hl]  ; a contains mon id. overshoots by 1 if mew, causing mew to be loaded
	dec a
	ld [wCurrentCatchEmMon], a ;stores 1 less than ID
	ld a, [wCurrentCatchEmMon] ;wow gamefreak
	ld c, a
	ld b, $0
	ld hl, EvolutionLineIds ;fetch the mon's evolution line
	add hl, bc
	ld c, [hl]
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc  ; multiply the evolution line id by 3, add it to pointer to ???
	ld bc, Data_13685 ;mystery data
	add hl, bc
	ld a, [hli]
	ld [wd5c1], a
	ld [wd5be], a
	ld a, [hli]
	ld [wd5c2], a
	ld a, [hli]
	ld [wd5c3], a ;load the 3 bytes into ????
	ld hl, wd586
	ld a, [wd5b6]
	ld c, a
	and a
	ld b, $18
	jr z, .asm_100c7 ;if ?? = 0, jump with b = 24 (2 seperate loops?
.asm_100ba
	ld a, $1
	ld [hli], a ;load 1 then 0 into data from wd5b6 C times, where C is the contents of wd5b6
	xor a
	ld [hli], a
	dec b
	dec c
	jr nz, .asm_100ba
	ld a, b ;load 24 - times looped into a, if 0: skip
	and a
	jr z, .asm_100ce
.asm_100c7 ;loop 0 then 1 into the rest of the data from wd5b6
	xor a
	ld [hli], a
	inc a
	ld [hli], a
	dec b
	jr nz, .asm_100c7
.asm_100ce
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, CatchEmTimerData ;contains how long each mon stays on screen, all are 2 minutes by default
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a ;bc = timer legnth. b = secons c = minutes
	callba StartTimer
	callba InitBallSaverForCatchEmMode
	call Func_10696
	call Func_3579
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1011d
	ld a, BANK(StageRedFieldBottomBaseGameBoyColorGfx)
	ld hl, StageRedFieldBottomBaseGameBoyColorGfx + $300
	ld de, vTilesSH tile $2e
	ld bc, $0020
	call LoadOrCopyVRAMData
	ld a, $0
	ld hl, CatchBarTiles
	deCoord 6, 8, vBGMap
	ld bc, (CatchBarTilesEnd - CatchBarTiles)
	call LoadOrCopyVRAMData
.asm_1011d
	call SetPokemonSeenFlag
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_10124: ; 0x10124
	dw Func_10871      ; STAGE_RED_FIELD_TOP
	dw Func_10871      ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_1098a
	dw DoNothing_1098a
	dw Func_1098c      ; STAGE_BLUE_FIELD_TOP
	dw Func_1098c      ; STAGE_BLUE_FIELD_BOTTOM

CheckForMew:
; Sets the encountered mon to Mew if the following conditions are met:
;   1. Random number in register a equals $f
;   2. The current map is Indigo Plateau (it does a roundabout way of checking this)
;   3. The right alley has been hit three times
;   4. The Mewtwo Bonus Stage completion counter equals 2.
	push af
	cp $f  ; random number equals $f (1 in 16)
	jr nz, .NotMew
	ld a, c
	cp (BlueStageIndigoPlateauWildMons - BlueStageWildMons) & $ff  ; check if low-byte of map mons offset is Indigo Plateau
	jr nz, .NotMew
	ld a, b
	cp (BlueStageIndigoPlateauWildMons - BlueStageWildMons) >> 8  ; check if high-byte of map mons offset is Indigo Plateau
	jr nz, .NotMew
	ld a, [wRareMonsFlag]
	cp $8
	jr nz, .NotMew
	ld a, [wNumMewtwoBonusCompletions]
	cp NUM_MEWTWO_COMPLETIONS_FOR_MEW
	jr nz, .NotMew
	pop af
	xor a
	ld [wNumMewtwoBonusCompletions], a
	ld a, $10
	ret

.NotMew
	pop af
	ret

ConcludeCatchEmMode: ; 0x10157
	xor a
	ld [wInSpecialMode], a
	ld [wWildMonIsHittable], a
	ld [wd5c6], a
	ld [wd5b6], a
	ld [wNumMonHits], a
	call ClearWildMonCollisionMask
	callba StopTimer
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_10178: ; 0x10178
	dw Func_108f5      ; STAGE_RED_FIELD_TOP
	dw Func_108f5      ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_1098b
	dw DoNothing_1098b
	dw Func_109fc      ; STAGE_BLUE_FIELD_TOP
	dw Func_109fc      ; STAGE_BLUE_FIELD_BOTTOM

Func_10184: ; 0x10184
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_10199
	inc b
.asm_10199
	ld hl, MonBillboardPicPointers
	add hl, bc
	ld a, [hli]
	ld [$ff8c], a
	ld a, [hli]
	ld [$ff8d], a
	ld a, [hl]
	ld [$ff8e], a
	ld hl, MonBillboardPaletteMapPointers
	add hl, bc
	ld a, [hli]
	ld [$ff8f], a
	ld a, [hli]
	ld [$ff90], a
	ld a, [hli]
	ld [$ff91], a
	ld de, wc000
	ld hl, wd586
	ld c, $0
.asm_101bb
	ld a, [hli]
	cp [hl]
	ld [hli], a
	jr z, .asm_101d2
	ld b, a
	call nz, Func_101d9
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_101d2
	ld a, [wCurrentStage]
	bit 0, a
	ld a, b
	call nz, Func_10230
.asm_101d2
	inc c
	ld a, c
	cp $18
	jr nz, .asm_101bb
	ret

Func_101d9: ; 0x101d9
	push bc
	push hl
	push de
	push af
	ld a, $10
	ld [de], a
	inc de
	ld a, $1
	ld [de], a
	inc de
	ld b, $0
	ld hl, Data_102a4
	add hl, bc
	ld c, [hl]
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, vTilesSH tile $10
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld a, [$ff8c]
	ld l, a
	ld a, [$ff8d]
	ld h, a
	add hl, bc
	pop af
	and a
	jr nz, .asm_10215
	ld bc, $0180
	add hl, bc
.asm_10215
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld a, [$ff8e]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	inc de
	pop bc
	push de
	xor a
	ld de, Func_11d2
	call Func_10c5
	pop de
	pop hl
	pop bc
	ret

Func_10230: ; 0x10230
	push bc
	push hl
	push de
	push af
	ld a, $1
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld b, $0
	ld hl, Data_102a4
	add hl, bc
	ld c, [hl]
	sla c
	ld hl, PointerTable_10274
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	srl c
	ld a, [$ff8f]
	ld l, a
	ld a, [$ff90]
	ld h, a
	add hl, bc
	pop af
	and a
	ld a, [$ff91]
	call ReadByteFromBank
	jr nz, .asm_10261
	ld a, $5
.asm_10261
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	inc de
	pop bc
	push de
	xor a
	ld de, LoadTileListsBank1
	call Func_10c5
	pop de
	pop hl
	pop bc
	ret

PointerTable_10274: ; 0x10274
	dw $9887
	dw $9888
	dw $9889
	dw $988A
	dw $988B
	dw $988C
	dw $98A7
	dw $98A8
	dw $98A9
	dw $98AA
	dw $98AB
	dw $98AC
	dw $98C7
	dw $98C8
	dw $98C9
	dw $98CA
	dw $98CB
	dw $98CC
	dw $98E7
	dw $98E8
	dw $98E9
	dw $98EA
	dw $98EB
	dw $98EC

Data_102a4: ; 0x102a4
	db $00, $07, $06, $01, $0E, $15, $14, $0F, $04, $0B, $0A, $05, $0C, $13, $12, $0D, $02, $09, $08, $03, $10, $17, $16, $11

Func_102bc: ; 0x102bc
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_102cb
	inc b
.asm_102cb
	ld hl, MonBillboardPalettePointers
	add hl, bc
	ld a, [hli]
	ld [$ff8c], a
	ld a, [hli]
	ld [$ff8d], a
	ld a, [hl]
	ld [$ff8e], a
	ld de, wc1b8
	ld a, $10
	ld [de], a
	inc de
	ld a, $8
	ld [de], a
	inc de
	ld a, $30
	ld [de], a
	inc de
	ld a, [$ff8c]
	ld [de], a
	inc de
	ld a, [$ff8d]
	ld [de], a
	inc de
	ld a, [$ff8e]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	xor a
	ld bc, wc1b8
	ld de, LoadPalettes
	call Func_10c5
	ret

Func_10301: ; 0x10301
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_10310
	inc b
.asm_10310
	ld hl, MonAnimatedPalettePointers
	add hl, bc
	ld a, [hli]
	ld [$ff8c], a
	ld a, [hli]
	ld [$ff8d], a
	ld a, [hl]
	ld [$ff8e], a
	ld de, wc1b8
	ld a, $10
	ld [de], a
	inc de
	ld a, $4
	ld [de], a
	inc de
	ld a, $58
	ld [de], a
	inc de
	ld a, [$ff8c]
	ld [de], a
	inc de
	ld a, [$ff8d]
	ld [de], a
	inc de
	ld a, [$ff8e]
	ld [de], a
	inc de
	ld a, $4
	ld [de], a
	inc de
	ld a, $68
	ld [de], a
	inc de
	ld a, [$ff8c]
	ld l, a
	ld a, [$ff8d]
	ld h, a
	ld bc, $0008
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld a, [$ff8e]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	xor a
	ld bc, wc1b8
	ld de, LoadPalettes
	call Func_10c5
	ret

Func_10362: ; 0x10362
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_10371
	inc b
.asm_10371
	ld hl, MonAnimatedPicPointers
	add hl, bc
	ld a, [hli]
	ld [$ff8c], a
	ld a, [hli]
	ld [$ff8d], a
	ld a, [hl]
	ld [$ff8e], a
	ld de, wc150
	ld bc, $0000
.asm_10384
	call Func_1038e
	inc c
	ld a, c
	cp $d
	jr nz, .asm_10384
	ret

Func_1038e: ; 0x1038e
	push bc
	push de
	ld a, c
	sla a
	add c
	ld c, a
	sla c
	ld hl, Data_103c6
	add hl, bc
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
	ld a, [$ff8c]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [$ff8d]
	adc [hl]
	ld [de], a
	inc de
	ld a, [$ff8e]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	inc de
	pop bc
	push de
	xor a
	ld de, Func_11d2
	call Func_10c5
	pop de
	pop bc
	ret

Data_103c6: ; 0x103c6
; TODO: this might have pointers in it
	db $40, $04, $00, $89, $00, $00
	db $40, $04, $40, $89, $40, $00
	db $40, $04, $80, $89, $80, $00
	db $40, $04, $C0, $89, $C0, $00
	db $40, $04, $00, $8A, $00, $01
	db $40, $04, $40, $8A, $40, $01
	db $20, $02, $80, $8A, $80, $01
	db $20, $02, $A0, $81, $A0, $01
	db $40, $04, $C0, $81, $C0, $01
	db $40, $04, $00, $82, $00, $02
	db $40, $04, $40, $82, $40, $02
	db $40, $04, $80, $82, $80, $02
	db $40, $04, $C0, $82, $C0, $02

Func_10414: ; 0x10414
	ld a, BANK(Data_10420)
	ld bc, Data_10420
	ld de, Func_11b5
	call Func_10c5
	ret

Data_10420:
	db $18
	db $06
	dw $9887
	db $80
	db $06
	dw $98a7
	db $80
	db $06
	dw $98c7
	db $80
	db $06
	dw $98e7
	db $80
	db $00

Func_10432: ; 0x10432
	ld a, BANK(Data_1043e)
	ld bc, Data_1043e
	ld de, LoadTileLists
	call Func_10c5
	ret

Data_1043e:
	db $18
	db $06
	dw $9887
	db $90, $91, $92, $93, $94, $95
	db $06
	dw $98a7
	db $96, $97, $98, $99, $9a, $9b
	db $06
	dw $98c7
	db $9c, $9d, $9e, $9f, $a0, $a1
	db $06
	dw $98e7
	db $a2, $a3, $a4, $a5, $a6, $a7
	db $00

LoadWildMonCollisionMask: ; 0x10464
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .noCarry
	inc b
.noCarry
	ld hl, MonAnimatedCollisionMaskPointers
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, b
	ld l, c
	ld de, wMonAnimatedCollisionMask
	ld bc, $0080
	call FarCopyData
	ret

ClearWildMonCollisionMask: ; 0x10488
	xor a
	ld hl, wMonAnimatedCollisionMask
	ld b, $20
.asm_1048e
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_1048e
	ret

BallCaptureInit: ; 0x10496
	xor a
	ld [wd5c6], a
	ld a, BANK(PikachuSaverGfx)
	ld hl, PikachuSaverGfx + $c0
	ld de, vTilesOB tile $7e
	ld bc, $0020
	call LoadVRAMData
	ld a, BANK(BallCaptureSmokeGfx)
	ld hl, BallCaptureSmokeGfx
	ld de, vTilesSH tile $10
	ld bc, $0180
	call LoadVRAMData
	call LoadShakeBallGfx
	ld hl, BallCaptureAnimationData
	ld de, wBallCaptureAnimation
	call InitAnimation
	ld a, $1
	ld [wCapturingMon], a
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	xor a
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

LoadShakeBallGfx: ; 0x104e2
; Loads the graphics for the ball shaking after a pokemon is caught.
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeball
	ld a, Bank(PinballPokeballShakeGfx)
	ld hl, PinballPokeballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call LoadVRAMData
	ret

.notPokeball
	cp ULTRA_BALL
	jr nc, .notGreatball
	ld a, Bank(PinballGreatballShakeGfx)
	ld hl, PinballGreatballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call LoadVRAMData
	ret

.notGreatball
	cp MASTER_BALL
	jr nc, .notUltraBall
	ld a, Bank(PinballUltraballShakeGfx)
	ld hl, PinballUltraballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call LoadVRAMData
	ret

.notUltraBall
	ld a, Bank(PinballMasterballShakeGfx)
	ld hl, PinballMasterballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call LoadVRAMData
	ret

CapturePokemon: ; 0x1052d
	ld a, [wBallCaptureAnimationFrame]
	cp $c
	jr nz, .asm_10541
	ld a, [wBallCaptureAnimationFrameCounter]
	cp $1
	jr nz, .asm_10541
	lb de, $00, $41
	call PlaySoundEffect
.asm_10541
	ld hl, BallCaptureAnimationData
	ld de, wBallCaptureAnimation
	call UpdateAnimation
	ld a, [wBallCaptureAnimationIndex]
	cp $1
	jr nz, .asm_1055d
	ld a, [wBallCaptureAnimationFrameCounter]
	cp $1
	jr nz, .asm_1055d
	xor a
	ld [wWildMonIsHittable], a
	ret

.asm_1055d
	ld a, [wBallCaptureAnimationIndex]
	cp $15
	ret nz
	ld a, [wBallCaptureAnimationFrameCounter]
	cp $1
	ret nz
	call Func_3475
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $23, $29
	call PlaySoundEffect
	call Func_10825
	call Func_3475
	ld a, [wNumPartyMons]
	and a
	call z, Func_10848
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $40
	ld [wBallYPos + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	xor a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld [wCapturingMon], a
	ld a, $1
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	callba RestoreBallSaverAfterCatchEmMode
	call ConcludeCatchEmMode
	ld de, $0001
	call PlaySong
	ld hl, wNumPokemonCaughtInBallBonus
	call Increment_Max100
	jr nc, .notMaxed
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplierFromFieldEvent ; increments bonus multiplier every 10 pokemon caught
.notMaxed
	call SetPokemonOwnedFlag
	ld a, [wPreviousNumPokeballs]
	cp $3
	ret z
	inc a
	ld [wNumPokeballs], a
	ld a, $80
	ld [wPokeballBlinkingCounter], a
	ret

BallCaptureAnimationData: ; 0x105e4
; Each entry is [OAM id][duration]
	db $05, $00
	db $05, $01
	db $05, $02
	db $04, $03
	db $06, $04
	db $08, $05
	db $07, $06
	db $05, $07
	db $04, $08
	db $04, $09
	db $04, $0A
	db $04, $0B
	db $24, $0A
	db $09, $0C
	db $09, $0A
	db $09, $0C
	db $27, $0A
	db $09, $0C
	db $09, $0A
	db $09, $0C
	db $24, $0A
	db $01, $0A
	db $00  ; terminator

Func_10611: ; 0x10611
	and a
	ret z
	dec a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1062a
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, BANK(Data_1062a)
	ld de, Func_11d2
	call Func_10c5
	ret

Data_1062a:
	dw Data_10630
	dw Data_10638
	dw Data_10640

Data_10630:
	db $20
	db $02
	dw $8ae0
	dw CatchTextGfx + $00
	db BANK(CatchTextGfx)
	db $00

Data_10638:
	db $20
	db $02
	dw $8b00
	dw CatchTextGfx + $20
	db BANK(CatchTextGfx)
	db $00

Data_10640:
	db $20
	db $02
	dw $8b20
	dw CatchTextGfx + $40
	db BANK(CatchTextGfx)
	db $00

Func_10648: ; 0x10648
	call Func_10184
	ld a, [wd54e]
	dec a
	ld [wd54e], a
	jr nz, .asm_10677
	ld a, $14
	ld [wd54e], a
	ld hl, wd586
	ld b, $18
.asm_1065e
	ld a, [wd54f]
	and $1
	ld [hli], a
	xor $1
	ld [hli], a
	dec b
	jr nz, .asm_1065e
	ld a, [wd54f]
	dec a
	ld [wd54f], a
	jr nz, .asm_10677
	ld hl, wd54d
	inc [hl]
.asm_10677
	ret

ShowAnimatedWildMon: ; 0x10678
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, [hl]
	ld [wd5bc], a
	ld [wd5bd], a
	ld a, $1
	ld [wWildMonIsHittable], a
	xor a
	ld [wBallHitWildMon], a
	ld [wNumMonHits], a
	ret

Func_10696: ; 0x10696
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld de, LetsGetPokemonText
	call LoadScrollingText
	ret

Func_106a6: ; 0x106a6
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	ld de, PokemonRanAwayText
	call LoadScrollingText
	ret

Func_106b6: ; 0x106b6
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b  ; bc was just multiplied by 16
	ld hl, PokemonNames + 1
	add hl, bc
	ld de, YouGotAnText ; "You got an"
	ld bc, Data_2a91
	ld a, [hl]
	; check if mon's name starts with a vowel, so it can print "an", instead of "a"
	cp "A"
	jr z, .asm_106f1
	cp "I"
	jr z, .asm_106f1
	cp "U"
	jr z, .asm_106f1
	cp "E"
	jr z, .asm_106f1
	cp "O"
	jr z, .asm_106f1
	ld de, YouGotAText ; "You got a"
	ld bc, Data_2a79
.asm_106f1
	push hl
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText1
	pop de
	call LoadScrollingText
	ld hl, wScrollingText2
	pop de
	call LoadScrollingText
	pop hl
	ld de, wBottomMessageText + $20
	ld b, $0  ; count the number of letters in mon's name in register b
.readLetter
	ld a, [hli]
	and a
	jr z, .endOfName
	ld [de], a
	inc de
	inc b
	jr .readLetter

.endOfName
	ld a, $20
	ld [de], a
	inc de
	xor a
	ld [de], a
	ld a, [wScrollingText2ScrollStepsRemaining]
	add b
	ld [wScrollingText2ScrollStepsRemaining], a
	ld a, $14
	sub b
	srl a
	ld b, a
	ld a, [wScrollingText2StopOffset]
	add b
	ld [wScrollingText2StopOffset], a
	ret

Func_10732: ; 0x10732
	ld a, [wCurrentCatchEmMon]
	inc a
	ld e, a
	ld d, $0
	call PlayCry
	ret

AddCaughtPokemonToParty: ; 0x1073d
	ld a, [wNumPartyMons]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [wCurrentCatchEmMon]
	ld [hl], a
	ld a, [wNumPartyMons]
	inc a
	ld [wNumPartyMons], a
	ret

SetPokemonSeenFlag: ; 0x10753
	ld a, [wSpecialMode]
	and a
	ld a, [wCurrentCatchEmMon]
	jr z, .asm_10766
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jr nz, .asm_10766
	ld a, [wCurrentCatchEmMon]
.asm_10766
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	set 0, [hl]
	ld hl, wPokedexFlags
	ld de, sPokedexFlags
	ld bc, $0098
	call SaveData
	ret

SetPokemonOwnedFlag: ; 0x1077c
	ld a, [wSpecialMode]
	and a
	ld a, [wCurrentCatchEmMon]
	jr z, .asm_1078f
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jr nz, .asm_1078f
	ld a, [wCurrentCatchEmMon]
.asm_1078f
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	set 1, [hl]
	ld hl, wPokedexFlags
	ld de, sPokedexFlags
	ld bc, $0098
	call SaveData
	ret

ResetIndicatorStates: ; 0x107a5
	xor a
	ld hl, wIndicatorStates
	ld b, $13
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Func_107b0: ; 0x107b0
	xor a
	ld [wSlotIsOpen], a
	ld [wIndicatorStates + 4], a
	callba LoadSlotCaveCoverGraphics_RedField
	ret

Func_107c2: ; 0x107c2
	ld a, $1e
	ld [wFramesUntilSlotCaveOpens], a
	ret

SetLeftAndRightAlleyArrowIndicatorStates_RedField: ; 0x107c8
	ld a, [wRightAlleyCount]
	cp $3
	jr z, .asm_107d1
	set 7, a
.asm_107d1
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .asm_107e0
	ld a, $80
	ld [wIndicatorStates + 3], a
.asm_107e0
	ld a, [wLeftAlleyCount]
	set 7, a
	ld [wIndicatorStates], a
	ret

Func_107e9: ; 0x107e9
	ld a, [wLeftAlleyCount]
	cp $3
	ld a, $4
	jr nz, .asm_107f4
	ld a, $6
.asm_107f4
	ld [wd7ad], a
	ret

Func_107f8: ; 0x107f8
	ld a, [wTimerFrames]
	and a
	ret nz
	ld a, [wTimerMinutes]
	and a
	ret nz
	ld a, [wTimerSeconds]
	cp $20
	jr nz, .asm_10810
	lb de, $07, $49
	call PlaySoundEffect
	ret

.asm_10810
	cp $10
	jr nz, .asm_1081b
	lb de, $0a, $4a
	call PlaySoundEffect
	ret

.asm_1081b
	cp $5
	ret nz
	lb de, $0d, $4b
	call PlaySoundEffect
	ret

Func_10825: ; 0x10825
	call Retrieve8DigitBCDValueAtwd47a
	push bc
	push de
	call AddBCDEToCurBufferValue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wStationaryText2
	ld de, Data_2a50
	call Func_3372
	pop de
	pop bc
	ld hl, wStationaryText1
	ld de, JackpotText
	call Func_3357
	ret

Func_10848: ; 0x10848
	ld bc, OneHundredMillionPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText2
	ld de, OneBillionText
	call LoadScrollingText
	ld hl, wScrollingText1
	ld de, PokemonCaughtSpecialBonusText
	call LoadScrollingText
	call Func_3475
	ret

Func_10871: ; 0x10871
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, EvolutionLineIds
	add hl, bc
	ld a, [hl] ; a contains evolution line id
	ld c, a
	ld b, $0
	ld l, c
	ld h, b
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, l
	ld b, h
	ld hl, CatchEmModeInitialIndicatorStates
	add hl, bc
	ld de, wIndicatorStates
	ld b, $13  ; number of indicators
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	xor a
	ld [wRightAlleyCount], a
	call Func_107b0
	ld a, $4
	ld [wd7ad], a
	ld de, $0002
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_108d3
	callba LoadStageCollisionAttributes
	callba LoadFieldStructureGraphics_RedField
	ret

.asm_108d3
	callba Func_14135
	callba Func_10184
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_108f5: ; 0x108f5
	call ResetIndicatorStates
	call Func_107c2
	call SetLeftAndRightAlleyArrowIndicatorStates_RedField
	call Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_14135
	call Func_10432
	callba LoadMapBillboardTileData
	ld a, Bank(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx
	ld de, vTilesOB tile $1a
	ld bc, $0160
	call LoadVRAMData
	ld a, BANK(StageSharedBonusSlotGlow2Gfx)
	ld hl, StageSharedBonusSlotGlow2Gfx
	ld de, vTilesOB tile $38
	ld bc, $0020
	call LoadVRAMData
	ld hl, BlankSaverSpaceTileDataRedField
	ld a, BANK(BlankSaverSpaceTileDataRedField)
	call Func_10aa
	ld a, [wPreviousNumPokeballs]
	callba LoadPokeballsGraphics_RedField
	ld hl, CaughtPokeballTileDataPointers
	ld a, BANK(CaughtPokeballTileDataPointers)
	call Func_10aa
	ret

BlankSaverSpaceTileDataRedField:
	db 3
	dw BlankSaverSpaceTileDataRedField1
	dw BlankSaverSpaceTileDataRedField2
	dw BlankSaverSpaceTileDataRedField3

BlankSaverSpaceTileDataRedField1:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $2e
	dw StageRedFieldBottomBaseGameBoyColorGfx + $2e0
	db Bank(StageRedFieldBottomBaseGameBoyColorGfx)
	db $00

BlankSaverSpaceTileDataRedField2:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $30
	dw StageRedFieldBottomBaseGameBoyColorGfx + $300
	db Bank(StageRedFieldBottomBaseGameBoyColorGfx)
	db $00

BlankSaverSpaceTileDataRedField3:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $32
	dw StageRedFieldBottomBaseGameBoyColorGfx + $320
	db Bank(StageRedFieldBottomBaseGameBoyColorGfx)
	db $00

CaughtPokeballTileDataPointers:
	db 1
	dw CaughtPokeballTileData

CaughtPokeballTileData:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $2e
	dw CaughtPokeballGfx
	db Bank(CaughtPokeballGfx)
	db $00

DoNothing_1098a: ; 0x1098a
	ret

DoNothing_1098b: ; 0x1098b
	ret

Func_1098c: ; 0x1098c
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, EvolutionLineIds
	add hl, bc
	ld a, [hl]
	ld c, a
	ld b, $0
	ld l, c
	ld h, b
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	add hl, bc
	add hl, bc
	ld c, l
	ld b, h
	ld hl, CatchEmModeInitialIndicatorStates
	add hl, bc
	ld de, wIndicatorStates
	ld b, $13  ; number of indicators
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	xor a
	ld [wRightAlleyCount], a
	callba CloseSlotCave
	ld de, $0002
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	ld [hFarCallTempA], a
	ld a, $4
	ld hl, Func_10184
	call BankSwitch
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_109fc: ; 0x109fc
	call ResetIndicatorStates
	call Func_107c2
	callba SetLeftAndRightAlleyArrowIndicatorStates_BlueField
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	call Func_10432
	callba LoadMapBillboardTileData
	ld a, BANK(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx
	ld de, vTilesOB tile $1a
	ld bc, $0160
	call LoadVRAMData
	ld a, BANK(StageSharedBonusSlotGlow2Gfx)
	ld hl, StageSharedBonusSlotGlow2Gfx
	ld de, vTilesOB tile $38
	ld bc, $0020
	call LoadVRAMData
	ld hl, BlankSaverSpaceTileDataBlueField
	ld a, BANK(BlankSaverSpaceTileDataBlueField)
	call Func_10aa
	ld a, [wPreviousNumPokeballs]
	callba LoadPokeballsGraphics_RedField
	ld hl, Data_10a88
	ld a, BANK(Data_10a88)
	call Func_10aa
	ret

BlankSaverSpaceTileDataBlueField:
	db 3
	dw BlankSaverSpaceTileDataBlueField1
	dw BlankSaverSpaceTileDataBlueField2
	dw BlankSaverSpaceTileDataBlueField3

BlankSaverSpaceTileDataBlueField1:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $2e
	dw StageBlueFieldBottomBaseGameBoyColorGfx + $2e0
	db Bank(StageBlueFieldBottomBaseGameBoyColorGfx)
	db $00

BlankSaverSpaceTileDataBlueField2:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $30
	dw StageBlueFieldBottomBaseGameBoyColorGfx + $300
	db Bank(StageBlueFieldBottomBaseGameBoyColorGfx)
	db $00

BlankSaverSpaceTileDataBlueField3:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $32
	dw StageBlueFieldBottomBaseGameBoyColorGfx + $320
	db Bank(StageBlueFieldBottomBaseGameBoyColorGfx)
	db $00

Data_10a88:
	db 1
	dw Data_10a8b

Data_10a8b:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $2e
	dw CaughtPokeballGfx
	db Bank(CaughtPokeballGfx)
	db $00
