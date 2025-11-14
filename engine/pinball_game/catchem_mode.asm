CheckSpecialModeColision: ; 0x10000
	ld c, a
	ld a, [wInSpecialMode] ;special mode in c
	and a
	ret z ;if mot in special mode, ret
	ld a, c
	ld [wSpecialModeCollisionID], a
	ld a, [wSpecialMode]
	cp SPECIAL_MODE_EVOLUTION ;branch based on mode
	jp z, HandleEvoModeCollision ;call evo mode logic
	cp SPECIAL_MODE_MAP_MOVE
	jr nz, .CatchMode  ;call catch mode logic
	callba HandleMapModeCollision ;call map move logic
	ret

.CatchMode
	ld a, [wCurrentStage]
	call CallInFollowingTable
HandleCatchEmCollisionCallTable: ; 0x10027
	padded_dab HandleRedCatchEmCollision ; STAGE_RED_FIELD_TOP
	padded_dab HandleRedCatchEmCollision ; STAGE_RED_FIELD_BOTTOM
	padded_dab HandleRedCatchEmCollision
	padded_dab HandleRedCatchEmCollision
	padded_dab HandleBlueCatchEmCollision ; STAGE_BLUE_FIELD_TOP
	padded_dab HandleBlueCatchEmCollision ; STAGE_BLUE_FIELD_BOTTOM

StartCatchEmMode: ; 0x1003f
	ld a, [wInSpecialMode]  ; current game mode?
	and a
	ret nz  ; don't start catch 'em mode if we're already doing something like Map Move mode
	ld a, $1
	ld [wInSpecialMode], a  ; set special mode flag
	xor a
	ld [wSpecialMode], a
	ld [wSpecialModeState], a
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
	ld hl, CatchemMonIds ; fetch the mon's catchem id
	add hl, bc
	ld c, [hl]
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc  ; multiply the catchem mod id by 3, add it to pointer to ???
	ld bc, CatchSpriteFrameDurations ;mystery data, seems pokedex related too
	add hl, bc
	ld a, [hli]
	ld [wCurrentCatchMonIdleFrame1Duration], a
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	ld a, [hli]
	ld [wCurrentCatchMonIdleFrame2Duration], a
	ld a, [hli]
	ld [wCurrentCatchMonHitFrameDuration], a ;load the 3 bytes into ????
	ld hl, wBillboardTilesIlluminationStates
	ld a, [wNumberOfCatchModeTilesFlipped]
	ld c, a
	and a
	ld b, $18
	jr z, .asm_100c7 ;if tiles flipped = 0, jump with b = 24 (2 seperate loops?)
.asm_100ba
	ld a, $1
	ld [hli], a ;load 1 then 0 into data from wNumberOfCatchModeTilesFlipped C times, where C is the contents of wNumberOfCatchModeTilesFlipped
	xor a
	ld [hli], a
	dec b
	dec c
	jr nz, .asm_100ba
	ld a, b ;load 24 - times looped into a, if 0: skip
	and a
	jr z, .asm_100ce
.asm_100c7 ;loop 0 then 1 into the rest of the data from wNumberOfCatchModeTilesFlipped
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
	ld [wNumberOfCatchModeTilesFlipped], a
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

Func_10184: ; 0x10184 called by what looks like the "hit voltorb and shellder" handllers and after all tiles are flipped, as well as some evo mode stuff
	ld a, [wCurrentStage]
	bit 0, a
	ret z  ;skip if stage has no flippers
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .NoOverflow
	inc b
.NoOverflow ;double current catch em mon
	ld hl, MonBillboardPicPointers
	add hl, bc
	ld a, [hli]
	ldh [hBillboardPicPointer], a ;load 3 byte billboard pointer into Hram
	ld a, [hli]
	ldh [hBillboardPicPointer + 1], a
	ld a, [hl]
	ldh [hBillboardPicBank], a
	ld hl, MonBillboardPaletteMapPointers ;and the PAL pointers
	add hl, bc
	ld a, [hli]
	ldh [hBillboardPaletteMapPointer], a
	ld a, [hli]
	ldh [hBillboardPaletteMapPointer + 1], a
	ld a, [hli]
	ldh [hBillboardPaletteMapBank], a
	ld de, wc000
	ld hl, wBillboardTilesIlluminationStates
	ld c, $0
.Loop24Times
	ld a, [hli]
	cp [hl]
	ld [hli], a ;load first byte into next and test it gainst the second byte, if it's the same skip
	jr z, .NextLoop
	ld b, a ;else store in b
	call nz, Func_101d9
	ldh a, [hGameBoyColorFlag]
	and a
	jr z, .NextLoop ;skip if DMG
	ld a, [wCurrentStage]
	bit 0, a
	ld a, b
	call nz, Func_10230 ;if lower stage, run ???
.NextLoop
	inc c
	ld a, c
	cp $18 ;run 24 times
	jr nz, .Loop24Times
	ret

Func_101d9: ; 0x101d9
	push bc
	push hl
	push de
	push af
	ld a, $10
	ld [de], a ;load 16 into de
	inc de
	ld a, $1
	ld [de], a ;1 into de+1
	inc de
	ld b, $0
	ld hl, Data_102a4 ;retrieve ???? c
	add hl, bc
	ld c, [hl]
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ;multiply ??? by 16
	ld hl, vTilesSH tile $10 ;wut
	add hl, bc ;add ???*16 to wut (8 2 bit pixels?)
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de ;load result in to de
	ldh a, [hBillboardPicPointer] ;loaded billboard pointer
	ld l, a
	ldh a, [hBillboardPicPointer + 1]
	ld h, a
	add hl, bc ;add ???*16
	pop af
	and a
	jr nz, .asm_10215 ;if a is 0, add $180 (384)
	ld bc, $0180
	add hl, bc
.asm_10215
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ldh a, [hBillboardPicBank]
	ld [de], a
	inc de ;load adjusted pointer into de, then 0
	ld a, $0
	ld [de], a
	inc de
	pop bc
	push de
	xor a
	ld de, Func_11d2 ; queue graphics load from the adjusted pointer bank 0 using this func
	call QueueGraphicsToLoadWithFunc
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
	inc de ;load 1 into first 2 bytes from DE
	ld b, $0
	ld hl, Data_102a4
	add hl, bc ;retrieve entry c from ???
	ld c, [hl]
	sla c
	ld hl, PointerTable_10274 ;grab billboard BG position(?) pointer entry c, place in de
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	srl c
	ldh a, [hBillboardPaletteMapPointer];load PAL pointer
	ld l, a
	ldh a, [hBillboardPaletteMapPointer + 1]
	ld h, a
	add hl, bc ;add the value from Data_102a4
	pop af
	and a
	ldh a, [hBillboardPaletteMapBank]
	call ReadByteFromBank ;fetch pallete data
	jr nz, .asm_10261 ;
	ld a, $5
.asm_10261
	ld [de], a ;if a's initial place is 0, make it 5 into de, else load the PAL bank
	inc de
	ld a, $0
	ld [de], a ;then load 0
	inc de
	pop bc
	push de
	xor a
	ld de, LoadTileListsBank1 ;load pal pointer as graphics?
	call QueueGraphicsToLoadWithFunc
	pop de
	pop hl
	pop bc
	ret

PointerTable_10274: ; 0x10274 4x6 area? the billboard's position?
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
	ldh [hBillboardPicPointer], a
	ld a, [hli]
	ldh [hBillboardPicPointer + 1], a
	ld a, [hl]
	ldh [hBillboardPicBank], a
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
	ldh a, [hBillboardPicPointer]
	ld [de], a
	inc de
	ldh a, [hBillboardPicPointer + 1]
	ld [de], a
	inc de
	ldh a, [hBillboardPicBank]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	xor a
	ld bc, wc1b8
	ld de, LoadPalettes
	call QueueGraphicsToLoadWithFunc
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
	ldh [hBillboardPicPointer], a
	ld a, [hli]
	ldh [hBillboardPicPointer + 1], a
	ld a, [hl]
	ldh [hBillboardPicBank], a
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
	ldh a, [hBillboardPicPointer]
	ld [de], a
	inc de
	ldh a, [hBillboardPicPointer + 1]
	ld [de], a
	inc de
	ldh a, [hBillboardPicBank]
	ld [de], a
	inc de
	ld a, $4
	ld [de], a
	inc de
	ld a, $68
	ld [de], a
	inc de
	ldh a, [hBillboardPicPointer]
	ld l, a
	ldh a, [hBillboardPicPointer + 1]
	ld h, a
	ld bc, $0008
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ldh a, [hBillboardPicBank]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	xor a
	ld bc, wc1b8
	ld de, LoadPalettes
	call QueueGraphicsToLoadWithFunc
	ret

Func_10362: ; 0x10362
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .loadPointer
	inc b
.loadPointer
	ld hl, MonAnimatedPicPointers
	add hl, bc
	ld a, [hli]
	ldh [hBillboardPicPointer], a
	ld a, [hli]
	ldh [hBillboardPicPointer + 1], a
	ld a, [hl]
	ldh [hBillboardPicBank], a
	ld de, wc150
	ld bc, 0
.loop
	call Func_1038e
	inc c
	ld a, c
	cp $d
	jr nz, .loop
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
	ldh a, [hBillboardPicPointer]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ldh a, [hBillboardPicPointer + 1]
	adc [hl]
	ld [de], a
	inc de
	ldh a, [hBillboardPicBank]
	ld [de], a
	inc de
	ld a, $0
	ld [de], a
	inc de
	pop bc
	push de
	xor a
	ld de, Func_11d2
	call QueueGraphicsToLoadWithFunc
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

LoadBillboardClearedTilemap: ; 0x10414
	ld a, BANK(TileData_Billboard_Cleared)
	ld bc, TileData_Billboard_Cleared
	ld de, FillTileLists
	call QueueGraphicsToLoadWithFunc
	ret

TileData_Billboard_Cleared: ; 0x10420
	db $18 ; total number of tiles
	db $06 ; number of tiles
	dw vBGMap + $87 ; destination
	db $80 ; fill value
	db $06
	dw vBGMap + $a7
	db $80
	db $06
	dw vBGMap + $c7
	db $80
	db $06
	dw vBGMap + $e7
	db $80
	db $00 ; terminator

LoadBillboardTilemap: ; 0x10432
	ld a, BANK(TileData_Billboard_Normal)
	ld bc, TileData_Billboard_Normal
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	ret

TileData_Billboard_Normal: ; 0x1043e
	db $18 ; total number of tiles
	db $06 ; number of tiles
	dw vBGMap + $87 ; destination
	db $90, $91, $92, $93, $94, $95 ; data
	db $06
	dw vBGMap + $a7
	db $96, $97, $98, $99, $9a, $9b
	db $06
	dw vBGMap + $c7
	db $9c, $9d, $9e, $9f, $a0, $a1
	db $06
	dw vBGMap + $e7
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
	ld a, BANK(BallCaptureSmoke2Gfx)
	ld hl, BallCaptureSmoke2Gfx
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

CapturePokemonAnimation: ; 0x1052d
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
	call MainLoopUntilTextIsClear
	ld de, MUSIC_NOTHING
	call PlaySong
	rst AdvanceFrame
	lb de, $23, $29
	call PlaySoundEffect
	call ShowJackpotText
	call MainLoopUntilTextIsClear
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
	ld de, MUSIC_BLUE_FIELD ; This is either MUSIC_BLUE_FIELD or MUSIC_RED_FIELD, they just happen to be the same song id in their respective audio Banks.
	call PlaySong
	ld hl, wNumPokemonCaughtInBallBonus
	call Increment_Max100
	jr nc, .notMaxed
	ld c, 10
	call Modulo_C
	callba z, AddExtraBall ; increments bonus multiplier every 10 pokemon caught
.notMaxed
	call SetPokemonOwnedFlag
	ld a, [wPreviousNumPokeballs]
	cp 3
	ret z
	inc a
	ld [wNumPokeballs], a
	ld a, $80
	ld [wPokeballBlinkingCounter], a
	ret

BallCaptureAnimationData: ; 0x105e4
; Each entry is [sprite id][duration]
	db $05, BALLCAPTURESPRITE_0
	db $05, BALLCAPTURESPRITE_1
	db $05, BALLCAPTURESPRITE_2
	db $04, BALLCAPTURESPRITE_3
	db $06, BALLCAPTURESPRITE_4
	db $08, BALLCAPTURESPRITE_5
	db $07, BALLCAPTURESPRITE_6
	db $05, BALLCAPTURESPRITE_7
	db $04, BALLCAPTURESPRITE_8
	db $04, BALLCAPTURESPRITE_9
	db $04, BALLCAPTURESPRITE_10
	db $04, BALLCAPTURESPRITE_11
	db $24, BALLCAPTURESPRITE_10
	db $09, BALLCAPTURESPRITE_12
	db $09, BALLCAPTURESPRITE_10
	db $09, BALLCAPTURESPRITE_12
	db $27, BALLCAPTURESPRITE_10
	db $09, BALLCAPTURESPRITE_12
	db $09, BALLCAPTURESPRITE_10
	db $09, BALLCAPTURESPRITE_12
	db $24, BALLCAPTURESPRITE_10
	db $01, BALLCAPTURESPRITE_10
	db $00  ; terminator

Func_10611: ; 0x10611
	and a ;if a NZ
	ret z
	dec a ;dec a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1062a
	add hl, bc ;load that graphics data and qeue it up
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, BANK(Data_1062a)
	ld de, Func_11d2
	call QueueGraphicsToLoadWithFunc
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
	ld hl, wBillboardTilesIlluminationStates
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
	ld hl, wSpecialModeState
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
	ld [wCurrentAnimatedMonSpriteType], a
	ld [wCurrentAnimatedMonSpriteFrame], a
	ld a, $1
	ld [wWildMonIsHittable], a
	xor a
	ld [wBallHitWildMon], a
	ld [wNumMonHits], a
	ret

Func_10696: ; 0x10696
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText1
	ld de, LetsGetPokemonText
	call LoadScrollingText
	ret

Func_106a6: ; 0x106a6
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText1
	ld de, PokemonRanAwayText
	call LoadScrollingText
	ret

ShowCapturedPokemonText: ; 0x106b6
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
	cp 'A'
	jr z, .asm_106f1
	cp 'I'
	jr z, .asm_106f1
	cp 'U'
	jr z, .asm_106f1
	cp 'E'
	jr z, .asm_106f1
	cp 'O'
	jr z, .asm_106f1
	ld de, YouGotAText ; "You got a"
	ld bc, Data_2a79
.asm_106f1
	push hl
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
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

PlayCatchemPokemonCry: ; 0x10732
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
	set BIT_POKEDEX_MON_SEEN, [hl]
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
	set BIT_POKEDEX_MON_CAUGHT, [hl]
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

CloseSlotCave_: ; 0x107b0
	xor a
	ld [wSlotIsOpen], a
	ld [wIndicatorStates + 4], a
	callba LoadSlotCaveCoverGraphics_RedField
	ret

OpenSlotCave: ; 0x107c2
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
	ld [wRedStageStructureBackup], a
	ret

PlayLowTimeSfx: ; 0x107f8
	ld a, [wTimerFrames]
	and a
	ret nz
	ld a, [wTimerMinutes]
	and a
	ret nz
	ld a, [wTimerSeconds]
	cp 32
	jr nz, .Not32Seconds
	lb de, $07, $49
	call PlaySoundEffect
	ret

.Not32Seconds
	cp 16
	jr nz, .Not16Seconds
	lb de, $0a, $4a
	call PlaySoundEffect
	ret

.Not16Seconds
	cp 5
	ret nz
	lb de, $0d, $4b
	call PlaySoundEffect
	ret

ShowJackpotText: ; 0x10825
	call RetrieveJackpot ;retreive somethign score related, put it on the stack
	push bc ;store data on stack to bge read in by LoadScoreTextFromStack
	push de
	call AddBCDEToCurBufferValue
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wStationaryText2
	ld de, CatchModeJackpotScoreStationaryTextHeader
	call LoadScoreTextFromStack
	pop de
	pop bc
	ld hl, wStationaryText1
	ld de, JackpotText
	call LoadStationaryTextAndHeader
	ret

Func_10848: ; 0x10848
	ld bc, OneHundredMillionPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText2
	ld de, OneBillionText
	call LoadScrollingText
	ld hl, wScrollingText1
	ld de, PokemonCaughtSpecialBonusText
	call LoadScrollingText
	call MainLoopUntilTextIsClear
	ret

Func_10871: ; 0x10871
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, CatchemMonIds
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
	call CloseSlotCave_
	ld a, $4
	ld [wRedStageStructureBackup], a
	ld de, MUSIC_CATCH_EM_BLUE ; This is either MUSIC_CATCH_EM_BLUE or MUSIC_CATCH_EM_RED. They happen to have the same id in their respective audio Banks.
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_108d3
	callba LoadStageCollisionAttributes
	callba LoadFieldStructureGraphics_RedField
	ret

.asm_108d3
	callba ClearAllRedIndicators
	callba Func_10184
	ldh a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_108f5: ; 0x108f5
	call ResetIndicatorStates
	call OpenSlotCave
	call SetLeftAndRightAlleyArrowIndicatorStates_RedField
	call Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba ClearAllRedIndicators
	call LoadBillboardTilemap
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
	call QueueGraphicsToLoad
	ld a, [wPreviousNumPokeballs]
	callba LoadPokeballsGraphics_RedField
	ld hl, CaughtPokeballTileDataPointers
	ld a, BANK(CaughtPokeballTileDataPointers)
	call QueueGraphicsToLoad
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
	ld hl, CatchemMonIds
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
	ld de, MUSIC_CATCH_EM_BLUE ; This is either MUSIC_CATCH_EM_BLUE or MUSIC_CATCH_EM_RED. They happen to have the same id in their respective audio
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	callba Func_10184
	ldh a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_109fc: ; 0x109fc
	call ResetIndicatorStates
	call OpenSlotCave
	callba SetLeftAndRightAlleyArrowIndicatorStates_BlueField
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	call LoadBillboardTilemap
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
	call QueueGraphicsToLoad
	ld a, [wPreviousNumPokeballs]
	callba LoadPokeballsGraphics_RedField
	ld hl, Data_10a88
	ld a, BANK(Data_10a88)
	call QueueGraphicsToLoad
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
