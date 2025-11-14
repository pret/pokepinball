HandlePokedexScreen: ; 0x28000
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
PointerTable_28004: ; 0x28004
	dw LoadPokedexScreen
	dw MainPokedexScreen
	dw MonInfoPokedexScreen
	dw Func_282e9 ; not sure if this is used ever...
	dw ExitPokedexScreen

LoadPokedexScreen: ; 0x2800e
	ld a, $23
	ldh [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld a, $93
	ld [wOBP0], a
	ld a, $e4
	ld [wOBP1], a
	xor a
	ldh [hSCX], a
	ld a, $8
	ldh [hSCY], a
	ld a, $7
	ldh [hWX], a
	ld a, $8c
	ldh [hWY], a
	ld a, $3b
	ldh [hLYC], a
	ldh [hLastLYC], a
	ldh [hNextLYCSub], a
	ldh [hLYCSub], a
	ld hl, hSTAT
	set 6, [hl]
	ld hl, rIE
	set 1, [hl]
	ld a, $2
	ldh [hStatIntrRoutine], a
	ld hl, PointerTable_280a2
	ldh a, [hGameBoyColorFlag]
	call LoadVideoData
	xor a
	ld [wCurPokedexIndex], a
	ld [wPokedexOffset], a
	ld [wPokedexBlinkingCursorAndScrollBarCounter], a
	ld [wd95c], a
	ld [wPokedexStartButtonIsPressed], a
	ld [wd961], a
	ld [wd95e], a
	ld a, $1
	ld [wd862], a
	call ClearSpriteBuffer
	call DisplayPokedexScrollBarAndCursor
	call DrawSummaryWindowMonName
	call DrawSummaryWindowMonSpecies
	call DrawSummaryWindowMonAttributes
	call DrawPokedexMonNames
	call Func_28a8a
	call Func_28ad1
	call DrawSummaryWindowMonImage
	call CountNumSeenOwnedMons
	call SetAllPalettesWhite
	ld a, Bank(Music_Pokedex)
	call SetSongBank
	ld de, MUSIC_POKEDEX
	call PlaySong
	call EnableLCD
	call FadeIn
	ld hl, wScreenState
	inc [hl]
	ret

PointerTable_280a2: ; 0x280a2
	dw Data_280a6
	dw Data_280c4

Data_280a6: ; 0x280a6
	dab PokedexInitialGfx
	dw vTilesOB
	dw $6000
	dab PokedexTilemap2
	dw $9800
	dw $1000
	dab PokedexTilemap
	dw vBGWin
	dw $800
	dab PokedexTilemap
	dw $9e00
	dw $800
	dw $FFFF ; terminators

Data_280c4: ; 0x280c4
	dab PokedexInitialGfx
	dw vTilesOB
	dw $6000
	dab PokedexTilemap2
	dw $9800
	dw $1000
	dab PokedexBGAttributes2
	dw $9800
	dw $1002
	dab PokedexTilemap
	dw vBGWin
	dw $800
	dab PokedexTilemap
	dw $9e00
	dw $800
	dab PokedexBGAttributes
	dw vBGWin
	dw $802
	dab PokedexBGAttributes
	dw $9e00
	dw $802
	dab PokedexPalettes
	dw $0000
	dw $101
	dw $FFFF ; terminators

MainPokedexScreen: ; 0x280fe
	call HandlePokedexDirectionalInput
	ldh a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .checkIfBPressed
	ld a, [wPokedexCursorWasMoved]
	and a
	jp nz, .done
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	jp z, .done
	push hl
	ld a, [wCurPokedexIndex]
	inc a
	ld e, a
	ld d, $0
	call PlayCry
	pop hl
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	jp z, .done
	call LoadPokemonDescriptionIntoVRAM
	call Func_2885c
	call CleanSpriteBuffer
	call ScrollPokemonDescriptionDown
	call Func_2885c
	ld hl, wScreenState
	inc [hl]
	ret

.checkIfBPressed
	bit BIT_B_BUTTON, a
	jr z, .checkIfGameboyColorAndIfStartIsPressed
	call DisplayPokedexScrollBarAndCursor
	ld a, $4
	ld [wScreenState], a
	ret

.checkIfGameboyColorAndIfStartIsPressed
	ldh a, [hGameBoyColorFlag]
	and a
	jr z, .done
	ldh a, [hJoypadState]
	bit BIT_START, a
	jr z, .asm_28168
	ld a, [wPokedexStartButtonIsPressed]
	and a
	ld a, $ff
	ld [wPokedexStartButtonIsPressed], a
	call z, DrawSummaryWindowMonImage
	jr .done

.asm_28168
	ld a, [wPokedexStartButtonIsPressed]
	and a
	ld a, $0
	ld [wPokedexStartButtonIsPressed], a
	call nz, DrawSummaryWindowMonImage
.done
	call DisplayPokedexScrollBarAndCursor
	ret

MonInfoPokedexScreen: ; 0x28178
	ld a, [wPokedexDescriptionPageFlag]
	bit 0, a
	jr z, .lastPokedexDescriptionPage
	ldh a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .checkIfBPressed
	call Func_28912
	jr .displayMonImage

.checkIfBPressed
	bit BIT_B_BUTTON, a
	jr z, .displayMonImage
	jr .exitMonInfoView

.lastPokedexDescriptionPage
	ldh a, [hNewlyPressedButtons]
	and A_BUTTON | B_BUTTON
	jr z, .displayMonImage
.exitMonInfoView
	call Func_288a2
	call DisplayPokedexScrollBarAndCursor
	ld a, $1
	ld [wScreenState], a
	ret

.displayMonImage
	ldh a, [hGameBoyColorFlag]
	and a
	jr z, .asm_281c7
	ldh a, [hJoypadState]
	bit BIT_START, a
	jr z, .asm_281bb
	ld a, [wPokedexStartButtonIsPressed]
	and a
	ld a, $ff
	ld [wPokedexStartButtonIsPressed], a
	call z, DrawSummaryWindowMonImage
	jr .asm_281c7

.asm_281bb
	ld a, [wPokedexStartButtonIsPressed]
	and a
	ld a, $0
	ld [wPokedexStartButtonIsPressed], a
	call nz, DrawSummaryWindowMonImage
.asm_281c7
	call Func_2885c
	ret

UnusedFunc_281cb:
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_281da
	inc b
.asm_281da
	ld a, [wPokedexStartButtonIsPressed]
	and a
	jr nz, .asm_281fb
	ld hl, MonBillboardPalettePointers
	add hl, bc
	ld a, BANK(MonBillboardPalettePointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, BANK(MonBillboardPalettePointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, BANK(MonBillboardPalettePointers)
	call ReadByteFromBank
	ldh [hPokedexBillboardPaletteBank], a
	jr .asm_28214

.asm_281fb
	ld hl, MonAnimatedPalettePointers
	add hl, bc
	ld a, BANK(MonAnimatedPalettePointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, BANK(MonAnimatedPalettePointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, BANK(MonAnimatedPalettePointers)
	call ReadByteFromBank
	ldh [hPokedexBillboardPaletteBank], a
.asm_28214
	ld h, d
	ld l, e
	ld de, wda8a
	ld b, $8
.asm_2821b
	push bc
	ldh a, [hPokedexBillboardPaletteBank]
	call ReadByteFromBank
	inc hl
	ld c, a
	ldh a, [hPokedexBillboardPaletteBank]
	call ReadByteFromBank
	inc hl
	ld b, a
	ld a, c
	and $1f
	ld [de], a
	inc de
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	ld a, c
	and $1f
	ld [de], a
	inc de
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	ld a, c
	and $1f
	ld [de], a
	inc de
	pop bc
	dec b
	jr nz, .asm_2821b
	ld hl, VRAMAddresses_28289
	ld de, wda8a
	ld b, $18
.asm_2826d
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	inc de
	push af
	swap a
	and $f
	call PutTileInVRAM
	inc hl
	pop af
	and $f
	call PutTileInVRAM
	pop hl
	inc hl
	inc hl
	dec b
	jr nz, .asm_2826d
	ret

VRAMAddresses_28289:
	dw vBGWin + $26
	dw vBGWin + $2B
	dw vBGWin + $30
	dw vBGWin + $46
	dw vBGWin + $4B
	dw vBGWin + $50
	dw vBGWin + $66
	dw vBGWin + $6B
	dw vBGWin + $70
	dw vBGWin + $86
	dw vBGWin + $8B
	dw vBGWin + $90
	dw vBGWin + $C6
	dw vBGWin + $CB
	dw vBGWin + $D0
	dw vBGWin + $E6
	dw vBGWin + $EB
	dw vBGWin + $F0
	dw vBGWin + $106
	dw vBGWin + $10B
	dw vBGWin + $110
	dw vBGWin + $126
	dw vBGWin + $12B
	dw vBGWin + $130

SpriteOffsetsTable_282b9:
; y, x coordinates
	db $40, $18
	db $40, $40
	db $40, $68
	db $48, $18
	db $48, $40
	db $48, $68
	db $50, $18
	db $50, $40
	db $50, $68
	db $58, $18
	db $58, $40
	db $58, $68
	db $68, $18
	db $68, $40
	db $68, $68
	db $70, $18
	db $70, $40
	db $70, $68
	db $78, $18
	db $78, $40
	db $78, $68
	db $80, $18
	db $80, $40
	db $80, $68

Func_282e9: ; 0x282e9
	ld a, [wPokedexStartButtonIsPressed]
	and a
	jr z, .asm_28318
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, Bank(MonAnimatedSpriteTypes)
	call ReadByteFromBank
	ld c, a
	ldh a, [hFrameCounter]
	swap a
	and $7
	cp $7
	jr z, .asm_2830d
	and $1
	jr .asm_2830f

.asm_2830d
	ld a, $2
.asm_2830f
	add c
	add SPRITE_POKEDEX_ANIMATED_MON
	ld bc, $2030
	call LoadSpriteData
.asm_28318
	ld a, [wdaa2]
	sla a
	ld c, a
	ld b, $0
	ld hl, SpriteOffsetsTable_282b9
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, SPRITE_DEX_ARROW
	call LoadSpriteData
	call Func_28368
	ldh a, [hNewlyPressedButtons]
	and $6
	jr z, .asm_28367
	ld a, BANK(PokedexTilemap)
	ld hl, PokedexTilemap
	ld de, vBGWin
	ld bc, $0200
	call LoadVRAMData
	ld a, $1
	ldh [rVBK], a
	ld a, BANK(PokedexBGAttributes)
	ld hl, PokedexBGAttributes
	ld de, vBGWin
	ld bc, $0200
	call LoadVRAMData
	xor a
	ldh [rVBK], a
	call DrawPokedexMonNames
	call Func_28a8a
	call Func_28ad1
	ld a, $1
	ld [wScreenState], a
.asm_28367
	ret

Func_28368: ; 0x28368
	ldh a, [hJoypadState]
	bit BIT_A_BUTTON, a
	jr nz, .asm_28371
	jp Func_284bc

.asm_28371
	ldh a, [hPressedButtons]
	ld b, a
	ld a, [wdaa2]
	ld e, a
	ld d, $0
	ld hl, wda8a
	add hl, de
	ld a, [hl]
	bit BIT_D_LEFT, b
	jr z, .checkIfRightPressed
	dec a
	jr .asm_2838a

.checkIfRightPressed
	bit BIT_D_RIGHT, b
	ret z
	inc a
.asm_2838a
	and $1f
	ld [hl], a
	push af
	sla e
	rl d
	ld hl, VRAMAddresses_28289
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	push af
	swap a
	and $f
	call PutTileInVRAM
	inc hl
	pop af
	and $f
	call PutTileInVRAM
	ld hl, Data_2842c
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hld]
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld a, [hld]
	or c
	ld c, a
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld a, [hl]
	or c
	ld c, a
	ld a, [wPokedexStartButtonIsPressed]
	and a
	jr nz, .asm_283ff
	ld hl, BGPaletteIndices_2845c
	add hl, de
	ld a, [hl]
	ld hl, rBGPI
	call PutTileInVRAM
	ld hl, rBGPD
	ld a, c
	call PutTileInVRAM
	ld a, b
	call PutTileInVRAM
	ret

.asm_283ff
	ld hl, BGPaletteIndices_2845c
	add hl, de
	ld a, [hl]
	ld hl, rBGPI
	call PutTileInVRAM
	ld hl, rBGPD
	ld a, c
	call PutTileInVRAM
	ld a, b
	call PutTileInVRAM
	ld hl, SpritePaletteIndices_2848c
	add hl, de
	ld a, [hl]
	ld hl, rOBPI
	call PutTileInVRAM
	ld hl, rOBPD
	ld a, c
	call PutTileInVRAM
	ld a, b
	call PutTileInVRAM
	ret

Data_2842c:
	dw wda8c
	dw wda8c
	dw wda8c
	dw wda8f
	dw wda8f
	dw wda8f
	dw wda92
	dw wda92
	dw wda92
	dw wda95
	dw wda95
	dw wda95
	dw wda98
	dw wda98
	dw wda98
	dw wda9b
	dw wda9b
	dw wda9b
	dw wda9e
	dw wda9e
	dw wda9e
	dw wdaa1
	dw wdaa1
	dw wdaa1

BGPaletteIndices_2845c:
; second byte is unused
	db $30 | $80, $00
	db $30 | $80, $00
	db $30 | $80, $00
	db $32 | $80, $00
	db $32 | $80, $00
	db $32 | $80, $00
	db $34 | $80, $00
	db $34 | $80, $00
	db $34 | $80, $00
	db $36 | $80, $00
	db $36 | $80, $00
	db $36 | $80, $00
	db $38 | $80, $00
	db $38 | $80, $00
	db $38 | $80, $00
	db $3A | $80, $00
	db $3A | $80, $00
	db $3A | $80, $00
	db $3C | $80, $00
	db $3C | $80, $00
	db $3C | $80, $00
	db $3E | $80, $00
	db $3E | $80, $00
	db $3E | $80, $00

SpritePaletteIndices_2848c:
	db $D8, $00
	db $D8, $00
	db $D8, $00
	db $DA, $00
	db $DA, $00
	db $DA, $00
	db $DC, $00
	db $DC, $00
	db $DC, $00
	db $DE, $00
	db $DE, $00
	db $DE, $00
	db $E8, $00
	db $E8, $00
	db $E8, $00
	db $EA, $00
	db $EA, $00
	db $EA, $00
	db $EC, $00
	db $EC, $00
	db $EC, $00
	db $EE, $00
	db $EE, $00
	db $EE, $00

Func_284bc: ; 0x284bc
	ldh a, [hPressedButtons]
	ld b, a
	ld a, [wdaa2]
	bit BIT_D_LEFT, b
	jr z, .checkIfRightPressed
	dec a
	bit 7, a
	jr nz, .asm_284ef
	jr .asm_284f5

.checkIfRightPressed
	bit BIT_D_RIGHT, b
	jr z, .checkIfUpPressed
	inc a
	cp $18
	jr nc, .asm_284f3
	jr .asm_284f5

.checkIfUpPressed
	bit BIT_D_UP, b
	jr z, .checkIfDownPressed
	sub $3
	bit 7, a
	jr nz, .asm_284ef
	jr .asm_284f5

.checkIfDownPressed
	bit BIT_D_DOWN, b
	ret z
	add $3
	cp $18
	jr nc, .asm_284f3
	jr .asm_284f5

.asm_284ef
	add $18
	jr .asm_284f5

.asm_284f3
	sub $18
.asm_284f5
	ld [wdaa2], a
	ret

ExitPokedexScreen: ; 0x284f9
	call FadeOut
	call DisableLCD
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

HandlePokedexDirectionalInput: ; 0x28513
	ldh a, [hPressedButtons]
	ld hl, wd95e ; some temp storage for joypad input
	or [hl]
	ld [hl], a ; load any combination of button presses
	ld a, [wd95c]
	and a
	ret nz
	ld a, [wd95e]
	ld b, a
	; if MEW has not been seen or caught, act as if the max pokedex number were 150 instead of 151
	ld a, [wPokedexFlags + MEW - 1]
	and a
	ld a, NUM_POKEMON - 1
	jr z, .gotMaximumPokedexIndex
	ld a, NUM_POKEMON
.gotMaximumPokedexIndex
	ld d, a
	ld a, [wCurPokedexIndex]
	bit BIT_D_UP, b
	jr z, .checkIfDownPressed
	and a
	jr z, .done
	dec a
	ld [wCurPokedexIndex], a
	ld a, $4
	ld [wd95c], a
	ld a, $1
	ld [wPokedexCursorWasMoved], a
	jr .done

.checkIfDownPressed
	bit BIT_D_DOWN, b
	jr z, .checkIfLeftPressed
	inc a
	cp d
	jr z, .done ; jump if reached bottom of Pokedex
	ld [wCurPokedexIndex], a
	ld a, $4
	ld [wd95c], a
	ld a, $1
	ld [wPokedexCursorWasMoved], a
	jr .done

.checkIfLeftPressed
	ld a, d
	sub $9
	ld d, a
	ld a, [wPokedexOffset]
	ld c, $5
	bit BIT_D_LEFT, b
	jr z, .checkIfRightPressed
	cp $5 ; 5 is max number of pokedex entries displayed
	jr nc, .getNewLowerPokedexOffset
	ld c, a ; load the offset when [wPokedexOffset] is 0, 1, 2, 3, or 4
.getNewLowerPokedexOffset
	sub c
	ld [wPokedexOffset], a
	ld a, [wCurPokedexIndex]
	sub c
	ld [wCurPokedexIndex], a
	ld a, $1
	ld [wPokedexCursorWasMoved], a
	call Func_285ca ; TODO
	jr .asm_285aa

.checkIfRightPressed
	bit BIT_D_RIGHT, b
	jr z, .asm_285ae
	cp d
	jr c, .getNewHigherPokedexOffset
; change how far the menu can scroll down when near the end of the Pokedex
	push af
	cpl
	add d
	add $5
	ld c, a
	pop af
.getNewHigherPokedexOffset
	add c
	ld [wPokedexOffset], a
	ld a, [wCurPokedexIndex]
	add c
	ld [wCurPokedexIndex], a
	ld a, $1
	ld [wPokedexCursorWasMoved], a
	call Func_285ca
	jr .asm_285aa

.done
	xor a
.asm_285aa
	ld [wd95e], a
	ret

.asm_285ae 
	ld a, [wPokedexCursorWasMoved]
	and a
	ret z
	lb de, $00, $03
	call PlaySoundEffect
	call DrawSummaryWindowMonName
	call DrawSummaryWindowMonSpecies
	call DrawSummaryWindowMonAttributes
	call DrawSummaryWindowMonImage
	xor a
	ld [wPokedexCursorWasMoved], a
	ret

Func_285ca: ; 0x285ca
	xor a
	ld [wPressedButtonsPersistent], a
	call DrawPokedexMonNames
	call Func_28a8a
	call Func_28ad1
	ld a, [wPressedButtonsPersistent]
	ret

DisplayPokedexScrollBarAndCursor: ; 0x285db
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	call nz, AnimateMonSpriteIfStartIsPressed
	ld bc, $8c38
	ld a, SPRITE_DEX_SCROLLBAR_TOPPER_0
	call LoadSpriteData
	ld bc, $8840
	ld a, SPRITE_DEX_SCROLLBAR_TOPPER_1
	call LoadSpriteData
	ld bc, $8888
	ld a, SPRITE_DEX_SCROLLBAR_TOPPER_2
	call LoadSpriteData
	call DrawCornerInfoPokedexScreen
; determine where to draw the right hand side scroll bar
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, DexScrollBarOffsets
	add hl, bc
	ld a, [hl]
	add $49 ; y-coordinate shift of scroll bar
	ld c, a
	ld b, $90 ; x-coordinate shift of scroll bar
	ld a, [wPokedexBlinkingCursorAndScrollBarCounter]
	srl a
	srl a
	and $3 ; get a number between 0 - 3
	ld e, a
	ld d, $0
	ld hl, DexScrollBarSpriteIds
	add hl, de
	ld a, [hl]
	call LoadSpriteData
; check if moving the cursor up has caused the window to shift
	ld a, [wCurPokedexIndex]
	ld hl, wPokedexOffset
	sub [hl]
	jr nc, .windowDoesNotMoveUp
	dec [hl]
	ld a, 1
	ld [wPokedexWindowWasShifted], a
	xor a
	jr .decideCursorSprite

.windowDoesNotMoveUp
	cp 5
	jr c, .decideCursorSprite
; if scrolling down moves the window
	ld a, 1
	ld [wPokedexWindowWasShifted], a
	inc [hl]
	ld a, $4
.decideCursorSprite
	ld c, a
	push bc
	ldh a, [hJoypadState]
	and a
	ld a, [wPokedexBlinkingCursorAndScrollBarCounter]
	jr z, .wasJoyHeld
	xor a
.wasJoyHeld
	inc a
	ld [wPokedexBlinkingCursorAndScrollBarCounter], a
; Every 16th time reaching this loop, the sprite will change (blinking),
; unless a button is pressed. Hence why bit 3 is tested.
	bit 3, a 
	jr nz, .asm_28667
	swap c
	ld a, c
	add $40
	ld c, a
	ld b, $10
	ld a, SPRITE_DEX_ARROW
	call LoadSpriteData
.asm_28667
	pop bc
	ld a, [wd95c]
	and a
	ret z
	dec a
	ld [wd95c], a
	sla a
	ld e, a
	ld d, $0
	push hl
	ld hl, PointerTable_2867f
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PointerTable_2867f: ; 0x2867f
	dw Func_286dd
	dw Func_28721
	dw Func_286dd
	dw Func_28765

DexScrollBarSpriteIds:
	db SPRITE_DEX_SCROLLBAR_0
	db SPRITE_DEX_SCROLLBAR_1
	db SPRITE_DEX_SCROLLBAR_2
	db SPRITE_DEX_SCROLLBAR_1

DrawCornerInfoPokedexScreen: ; 0x2868b
; If player is holding SELECT button, it draws the seen/own count in the top-right corner.
; Otherwise, it draws the word "POKeDEX".
	ldh a, [hJoypadState]
	bit BIT_SELECT, a
	jr z, .asm_286c8
	ld bc, $6d03
	ld a, [wNumPokemonSeen + 1]
	call LoadSeenOwnDigitSprite
	ld a, [wNumPokemonSeen]
	swap a
	call LoadSeenOwnDigitSprite
	ld a, [wNumPokemonSeen]
	call LoadSeenOwnDigitSprite
	ld bc, $8202
	ld a, SPRITE_SLASH_CHARACTER
	call LoadSpriteData  ; draws the "/" between the seen/owned numbers
	ld bc, $8703
	ld a, [wNumPokemonOwned + 1]
	call LoadSeenOwnDigitSprite
	ld a, [wNumPokemonOwned]
	swap a
	call LoadSeenOwnDigitSprite
	ld a, [wNumPokemonOwned]
	call LoadSeenOwnDigitSprite
	ret

.asm_286c8
	ld bc, $6800
	ld a, SPRITE_POKEDEX_TEXT
	call LoadSpriteData
	ret

LoadSeenOwnDigitSprite: ; 0x286d1
	and $f
	add SPRITE_DIGIT
	call LoadSpriteData
	ld a, b
	add $7 ; adds 7 pixels to the next digit's x position on screen
	ld b, a
	ret

Func_286dd: ; 0x286dd
	pop hl
	ld a, [wd862]
	and a
	jr nz, .asm_286ff
	push bc
	push hl
	ld a, [wd863]
	ld e, a
	ld a, [wd864]
	ld d, a
	ld hl, wPokedexFontBuffer
	xor a
	ld bc, $00a0
	call LoadOrCopyVRAMData
	ld a, $1
	ld [wd862], a
	pop hl
	pop bc
.asm_286ff
	ld a, [wPokedexWindowWasShifted]
	and a
	ret z
	ld a, [wd95c]
	and a
	jr nz, .asm_2870d
	ld [wPokedexWindowWasShifted], a
.asm_2870d
	ld a, c
	and a
	jr nz, .asm_28719
	ld hl, hNextFrameHBlankSCX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	ret

.asm_28719
	ld hl, hNextFrameHBlankSCX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ret

Func_28721: ; 0x28721
	pop hl
	ld a, [wPokedexWindowWasShifted]
	and a
	ret z
	ld a, c
	and a
	jr nz, .asm_28747
	ld a, [hl]
	push af
	sla a
	and $1e
	ld c, a
	ld b, $0
	ld hl, BGMapLocations_287c7
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call Func_28aaa
	ld hl, hNextFrameHBlankSCX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	ret

.asm_28747
	ld a, [hl]
	add $5
	push af
	sla a
	and $1e
	ld c, a
	ld b, $0
	ld hl, BGMapLocations_287c7
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call Func_28aaa
	ld hl, hNextFrameHBlankSCX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ret

Func_28765: ; 0x28765
	pop hl
	ld a, [wPokedexWindowWasShifted]
	and a
	ret z
	ld a, c
	and a
	jr nz, .asm_28791
	push hl
	ld a, [hl]
	sla a
	and $e
	ld c, a
	ld b, $0
	ld hl, PokedexMonNamesTileLocations
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, hNextFrameHBlankSCX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	pop hl
	xor a
	ld [wd862], a
	ld a, [hl]
	call DrawPokedexListMonName
	ret

.asm_28791
	push hl
	ld a, [hl]
	add $5
	sla a
	and $e
	ld c, a
	ld b, $0
	ld hl, PokedexMonNamesTileLocations
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, hNextFrameHBlankSCX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	pop hl
	xor a
	ld [wd862], a
	ld a, [hl]
	add $5
	call DrawPokedexListMonName
	ret

PokedexMonNamesTileLocations:
	dw vTilesOB tile $0
	dw vTilesOB tile $A
	dw vTilesOB tile $14
	dw vTilesOB tile $1E
	dw vTilesOB tile $28
	dw vTilesOB tile $32
	dw vTilesOB tile $3C
	dw vTilesOB tile $46

BGMapLocations_287c7:
	dw vBGWin + $7
	dw vBGWin + $47
	dw vBGWin + $87
	dw vBGWin + $C7
	dw vBGWin + $107
	dw vBGWin + $147
	dw vBGWin + $187
	dw vBGWin + $1C7
	dw vBGWin + $207
	dw vBGWin + $247
	dw vBGWin + $287
	dw vBGWin + $2C7
	dw vBGWin + $307
	dw vBGWin + $347
	dw vBGWin + $387
	dw vBGWin + $3C7

AnimateMonSpriteIfStartIsPressed: ; 0x287e7
	ld a, [wPokedexStartButtonIsPressed]
	and a
	ret z
	ld a, [wPokedexCursorWasMoved]
	and a
	ret nz
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, Bank(MonAnimatedSpriteTypes)
	call ReadByteFromBank
	bit 7, a
	ret nz
	ld [wCurrentAnimatedMonSpriteType], a
	call Func_28815
	ld a, [wCurrentAnimatedMonSpriteFrame]
	add SPRITE_POKEDEX_ANIMATED_MON
	ld bc, $2030
	call LoadSpriteData
	ret

Func_28815: ; 0x28815
	ld a, [wLoopsUntilNextCatchSpriteAnimationChange]
	dec a
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	ret nz
	ld a, [wBallHitWildMon]
	inc a
	and $7
	ld [wBallHitWildMon], a
	jr nz, .asm_28836
	ld a, [wCurrentCatchMonHitFrameDuration]
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	xor a
	ld [wCatchModeMonUpdateTimer], a
	ld c, $2
	jr .asm_28854

.asm_28836
	ld a, [wCurrentAnimatedMonSpriteType]
	ld c, a
	ld a, [wCurrentAnimatedMonSpriteFrame]
	sub c
	cp $1
	ld c, $0
	jr nc, .asm_28846
	ld c, $1
.asm_28846
	ld b, $0
	ld hl, wCurrentCatchMonIdleFrame1Duration
	add hl, bc
	ld a, [hl]
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	xor a
	ld [wCatchModeMonUpdateTimer], a
.asm_28854
	ld a, [wCurrentAnimatedMonSpriteType]
	add c
	ld [wCurrentAnimatedMonSpriteFrame], a
	ret

Func_2885c: ; 0x2885c
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	call nz, AnimateMonSpriteIfStartIsPressed
	ld bc, $8888
	ld a, SPRITE_DEX_SCROLLBAR_TOPPER_2
	call LoadSpriteData
	ld bc, $6800
	ld a, SPRITE_POKEDEX_TEXT
	call LoadSpriteData
	ret

ScrollPokemonDescriptionDown: ; 0x2887c
	ld a, BANK(PokedexTilemap2)
	ld hl, PokedexTilemap2 + $120
	deCoord 0, 8, vBGMap
	ld bc, $0100
	call LoadVRAMData
	ld a, $3f
	ldh [hLYC], a
	ld a, $47
	ldh [hNextLYCSub], a
	ld b, $33
.frame_loop
	push bc
	ld a, $7a
	sub b
	ldh [hNextLYCSub], a
	rst AdvanceFrame
	pop bc
	dec b
	dec b
	dec b
	jr nz, .frame_loop
	ret

Func_288a2: ; 0x288a2
	ld b, $33
.asm_288a4
	push bc
	ld a, $44
	add b
	ldh [hNextLYCSub], a
	rst AdvanceFrame
	pop bc
	dec b
	dec b
	dec b
	jr nz, .asm_288a4
	ld a, $3b
	ldh [hLYC], a
	ldh [hNextLYCSub], a
	ld a, BANK(PokedexTilemap2)
	ld hl, PokedexTilemap2 + $100
	deCoord 0, 8, vBGMap
	ld bc, $0020
	call LoadVRAMData
	ret

LoadPokemonDescriptionIntoVRAM: ; 0x288c6
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	ld hl, BlankPokedexDescription
	jr z, .loadDescription
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, PokedexDescriptionPointers
	add hl, bc
	ld a, BANK(PokedexDescriptionPointers)
	call ReadByteFromBank
	inc hl
	ld c, a
	ld a, BANK(PokedexDescriptionPointers)
	call ReadByteFromBank
	ld b, a
	ld h, b
	ld l, c
.loadDescription
	xor a
	ld [wd860], a
	ld [wd861], a
	ld bc, $906c ; $90 is the tile number for the first VWF character
	ld de, vTilesSH tile $10
	call LoadPokemonDescriptionVWFCharacterTiles
	rl a
	ld [wPokedexDescriptionPageFlag], a
	ld a, l
	ld [wd957], a
	ld a, h
	ld [wd958], a
	ret

Func_28912: ; 0x28912
	ld bc, $906c
	ld de, vTilesSH tile $10
	ld a, [wd957]
	ld l, a
	ld a, [wd958]
	ld h, a
	call LoadPokemonDescriptionVWFCharacterTiles
	rl a
	ld [wPokedexDescriptionPageFlag], a
	ld a, l
	ld [wd957], a
	ld a, h
	ld [wd958], a
	ret

DrawSummaryWindowMonName: ; 0x28931
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	ld hl, BlankDexName
	jr z, .gotMonNameAddress
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	; compute 11 * bc (11 is length of name)
	ld h, b
	ld l, c
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	add hl, bc
	add hl, bc
	ld bc, MonDexNames
	add hl, bc
.gotMonNameAddress
	ld a, $ff
	ld [wd860], a
	xor a
	ld [wd861], a
	ld bc, $500a ; not memory address
	ld de, vTilesBG tile $50
	call LoadPokemonNameVWFCharacterTiles
	ret

BlankDexName:
	db " @"

DrawPokedexMonNames: ; 0x28972
; c is used to determine where to draw the name in the Pokedex
	ld a, [wPokedexOffset]
	ld c, a
	ld b, 6
.loop
	push bc
	ld a, c
	sla a ; PokedexMonNamesTileLocations has 8 entries. These two lines are simply adjusting register a to index PokedexMonNamesTileLocations.
	and $e
	ld e, a
	ld d, $0
	ld hl, PokedexMonNamesTileLocations
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, c
	call DrawPokedexListMonName
	pop bc
	inc c
	dec b
	jr nz, .loop
	ret

DrawPokedexListMonName: ; 0x28993
	push hl
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	ld hl, BlankDexName2
	jr z, .gotMonNameAddress
	; compute 11 * bc (11 is length of name)
	ld h, b
	ld l, c
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	add hl, bc
	add hl, bc
	ld bc, MonDexNames
	add hl, bc
.gotMonNameAddress
	xor a
	ld [wd860], a
	ld [wd861], a
	ld bc, $500a ; not a pointer
	call LoadPokemonNameVWFCharacterTiles
	pop hl
	ret

BlankDexName2:
	db " @"

DrawSummaryWindowMonSpecies: ; 0x289c8
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	ld hl, BlankSpeciesName
	jr z, .pokemonNotOwned
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonSpecies
	add hl, bc
	ld c, [hl]
	ld h, b
	ld l, c
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	add hl, bc
	add hl, bc  ; species * 11
	sla l
	rl h
	add hl, bc  ; species * 23
	ld bc, MonSpeciesNames
	add hl, bc
.pokemonNotOwned
	ld a, $ff
	ld [wd860], a
	ld a, $4
	ld [wd861], a
	ld bc, $5816
	ld de, vTilesBG tile $5a
	call LoadPokemonNameVWFCharacterTiles
	ret

BlankSpeciesName:
	dw $4081 ; variable-width font character
	db $00

DrawSummaryWindowMonAttributes: ; 0x28a15
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld h, b
	ld l, c
	sla l
	rl h
	add hl, bc
	sla l
	rl h
	add hl, bc
	sla l
	rl h
	add hl, bc
	ld bc, PokedexMonAttributesTexts
	add hl, bc
	ld d, h
	ld e, l
	ld a, $0
	ld [wd865], a
	push de
	hlCoord 4, 2, vBGMap
	call Func_28d71
	pop de
	inc de
	inc de
	inc de
	inc de
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	jr nz, .asm_28a54
	ld de, BlankPokemonTileData_28a7f
.asm_28a54
	push de
	hlCoord 8, 6, vBGMap
	call Func_28d71
	pop de
	inc de
	inc de
	inc de
	inc de
	inc de
	push de
	hlCoord 14, 6, vBGMap
	call Func_28d71
	pop de
	inc de
	inc de
	inc de
	inc de
	inc de
	hlCoord 16, 7, vBGMap
	ldh a, [rLCDC]
	bit 7, a
	jr nz, .asm_28a7a
	ld a, [de]
	ld [hl], a
	ret

.asm_28a7a
	ld a, [de]
	call PutTileInVRAM
	ret

BlankPokemonTileData_28a7f:
	db $FF, $FF, $72, $FF
	db $00 ; terminator

	db $FF, $FF, $FF, $FF
	db $00 ; terminator

	db $83 ; tile id

Func_28a8a: ; 0x28a8a
	ld a, [wPokedexOffset]
	ld c, a
	ld b, $6
.asm_28a90
	push bc
	ld a, c
	sla a
	and $1e
	ld e, a
	ld d, $0
	ld hl, BGMapLocations_287c7
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	call Func_28aaa
	pop bc
	inc c
	dec b
	jr nz, .asm_28a90
	ret

Func_28aaa: ; 0x28aaa
	push hl
	ld c, a
	ld b, $0
	ld h, b
	ld l, c
	sla l
	rl h
	add hl, bc
	sla l
	rl h
	add hl, bc
	sla l
	rl h
	add hl, bc
	ld bc, PokedexMonAttributesTexts
	add hl, bc
	ld d, h
	ld e, l
	ld a, $23
	ld [wd865], a
	pop hl
	push hl
	call Func_28d71
	pop hl
	ret

Func_28ad1: ; 0x28ad1
	ld a, [wPokedexOffset]
	swap a
	and $f0
	sub $3c
	ldh [hNextFrameHBlankSCX], a
	ret

DrawSummaryWindowMonImage: ; 0x28add
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	jp z, LoadUncaughtPokemonBackgroundGfx
	dec a
	jp z, LoadSeenPokemonGfx
	ld a, [wPokedexStartButtonIsPressed]
	and a
	jr z, .asm_28afc
	call CheckIfMonHasAnimation
	jp z, PlayMonPokedexCatchAnimation
.asm_28afc
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_28b0b
	inc b
.asm_28b0b
	push bc
	ld hl, MonBillboardPicPointers
	add hl, bc
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	inc hl
	ld c, a
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	inc hl
	ld b, a
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	ld h, b
	ld l, c
	ld de, vTilesBG tile $00
	ld bc, $0180
	call LoadOrCopyVRAMData
	call Func_28cd4
	pop bc
	ldh a, [hGameBoyColorFlag]
	and a
	ret z
	push bc
	ld hl, MonBillboardPaletteMapPointers
	add hl, bc
	ld a, Bank(MonBillboardPaletteMapPointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, Bank(MonBillboardPaletteMapPointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, Bank(MonBillboardPaletteMapPointers)
	call ReadByteFromBank
	hlCoord 1, 3, vBGMap
	call LoadBillboardPaletteMap
	pop bc
	ld hl, MonBillboardPalettePointers
	add hl, bc
	ld a, Bank(MonBillboardPalettePointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, Bank(MonBillboardPalettePointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, Bank(MonBillboardPalettePointers)
	call ReadByteFromBank
	ld bc, $10b0
	ld hl, rBGPI
	call Func_8e1
	ret

LoadUncaughtPokemonBackgroundGfx: ; 0x28b76
	ld a, BANK(UncaughtPokemonBackgroundPic)
	ld hl, UncaughtPokemonBackgroundPic
	ld de, vTilesBG tile $00
	ld bc, $0180
	call LoadOrCopyVRAMData
	call Func_28cd4
	ldh a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, BANK(UncaughtPokemonPaletteMap)
	ld de, UncaughtPokemonPaletteMap
	hlCoord 1, 3, vBGMap
	call LoadBillboardPaletteMap
	ret

UncaughtPokemonPaletteMap:
	db $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05

LoadSeenPokemonGfx: ; 0x28baf
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_28bbe
	inc b
.asm_28bbe
	ld hl, MonBillboardPicPointers
	add hl, bc
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	inc hl
	ld c, a
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	inc hl
	ld b, a
	ld a, Bank(MonBillboardPicPointers)
	call ReadByteFromBank
	ld hl, $0180
	add hl, bc
	ld de, vTilesBG tile $00
	ld bc, $0180
	call LoadOrCopyVRAMData
	call Func_28cd4
	ldh a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, BANK(UncaughtPokemonPaletteMap)
	ld de, UncaughtPokemonPaletteMap
	hlCoord 1, 3, vBGMap
	call LoadBillboardPaletteMap
	ret

PlayMonPokedexCatchAnimation: ; 0x28bf5
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_28c04
	inc b
.asm_28c04
	push bc
	ld a, $1
	ldh [rVBK], a
	ld hl, MonAnimatedPicPointers
	add hl, bc
	ld a, Bank(MonAnimatedPicPointers)
	call ReadByteFromBank
	inc hl
	ld c, a
	ld a, Bank(MonAnimatedPicPointers)
	call ReadByteFromBank
	inc hl
	ld b, a
	ld a, Bank(MonAnimatedPicPointers)
	call ReadByteFromBank
	ld h, b
	ld l, c
	ld de, vTilesOB
	ld bc, $0300
	call LoadOrCopyVRAMData
	xor a
	ldh [rVBK], a
	pop bc
	push bc
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, CatchemMonIds
	add hl, bc
	ld a, BANK(CatchemMonIds)
	call ReadByteFromBank
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_28c4b
	inc b
.asm_28c4b
	ld hl, CatchSpriteFrameDurations
	add hl, bc
	ld a, Bank(CatchSpriteFrameDurations)
	call ReadByteFromBank
	ld [wCurrentCatchMonIdleFrame1Duration], a
	ld [wLoopsUntilNextCatchSpriteAnimationChange], a
	inc hl
	ld a, Bank(CatchSpriteFrameDurations)
	call ReadByteFromBank
	ld [wCurrentCatchMonIdleFrame2Duration], a
	inc hl
	ld a, Bank(CatchSpriteFrameDurations)
	call ReadByteFromBank
	ld [wCurrentCatchMonHitFrameDuration], a
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, Bank(MonAnimatedSpriteTypes)
	call ReadByteFromBank
	ld [wCurrentAnimatedMonSpriteType], a
	ld [wCurrentAnimatedMonSpriteFrame], a
	call Func_28cf8
	pop bc
	ldh a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, MonAnimatedPalettePointers
	add hl, bc
	ld a, Bank(MonAnimatedPalettePointers)
	call ReadByteFromBank
	inc hl
	ld e, a
	ld a, Bank(MonAnimatedPalettePointers)
	call ReadByteFromBank
	inc hl
	ld d, a
	ld a, Bank(MonAnimatedPalettePointers)
	call ReadByteFromBank
	push af
	push de
	ld bc, $10b0
	ld hl, rBGPI
	call Func_8e1
	pop de
	pop af
	push af
	ld bc, $08d8
	ld hl, rOBPI
	call Func_8e1
	pop af
	ld bc, $08e8
	ld hl, rOBPI
	call Func_8e1
	ret

CheckIfMonHasAnimation: ; 0x28cc2
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, Bank(MonAnimatedSpriteTypes)
	call ReadByteFromBank
	bit 7, a ; if true, this Pokemon does not have an animation
	ret

Func_28cd4: ; 0x28cd4
	xor a
	ld hl, wd961
	cp [hl]
	ret z
	ld [hl], a
	ld de, .data_28ce0
	jr Func_28d1d

.data_28ce0: ; 0x28ce0
	db $0
	db $1
	db $2
	db $3
	db $4
	db $5
	db $6
	db $7
	db $8
	db $9
	db $a
	db $b
	db $c
	db $d
	db $e
	db $f
	db $10
	db $11
	db $12
	db $13
	db $14
	db $15
	db $16
	db $17

Func_28cf8: ; 0x28cf8
	ld a, $1
	ld hl, wd961
	cp [hl]
	ret z
	ld [hl], a
	ld de, .data_28d05
	jr Func_28d1d

.data_28d05
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe
	db $fe

Func_28d1d:
	hlCoord 1, 3, vBGMap
	ld b, $4
.asm_28d22
	ld c, $6
.asm_28d24
	ld a, [de]
	call PutTileInVRAM
	inc de
	inc hl
	dec c
	jr nz, .asm_28d24
	ld a, l
	add $1a
	ld l, a
	dec b
	jr nz, .asm_28d22
	ret

CountNumSeenOwnedMons: ; 0x28d35
	ld hl, wPokedexFlags
	ld de, $0000  ; keep a running count: d = owned, e = seen
	ld b, NUM_POKEMON
.checkSeen
	bit BIT_POKEDEX_MON_SEEN, [hl]
	jr z, .checkOwned
	inc e
.checkOwned
	bit BIT_POKEDEX_MON_CAUGHT, [hl]
	jr z, .nextMon
	inc d
.nextMon
	inc hl
	dec b
	jr nz, .checkSeen
	push de
	ld a, d
	call ConvertHexByteToDecWord
	ld a, e
	ld [wNumPokemonSeen], a
	ld a, d
	ld [wNumPokemonSeen + 1], a
	pop de
	ld a, e
	call ConvertHexByteToDecWord
	ld a, e
	ld [wNumPokemonOwned], a
	ld a, d
	ld [wNumPokemonOwned + 1], a
	ret

ClearPokedexData: ; 0x28d66
	ld hl, wPokedexFlags
	xor a
	ld b, NUM_POKEMON
.asm_28d6c
	ld [hli], a
	dec b
	jr nz, .asm_28d6c
	ret

Func_28d71: ; 0x28d71
	ld a, [wd865]
	ld c, a
	ld a, [de]
	inc de
	and a
	ret z
	cp $20
	jr nz, .asm_28d81
	ld a, $ff
	jr .asm_28d82

.asm_28d81
	add c
.asm_28d82
	call Func_28d88
	inc hl
	jr Func_28d71

Func_28d88: ; 0x28d88
	push af
	ldh a, [rLCDC]
	bit 7, a
	jr nz, .asm_28d92
	pop af
	ld [hl], a
	ret

.asm_28d92
	pop af
	call PutTileInVRAM
	ret

LoadPokemonDescriptionVWFCharacterTiles: ; 0x28d97
	push de
	ld a, b
	ldh [hVariableWidthFontFF8C], a
	ldh [hVariableWidthFontFF8D], a
	ld a, c
	ldh [hVariableWidthFontFF8F], a
	xor a
	ldh [hVariableWidthFontFF8E], a
	ldh [hVariableWidthFontFF90], a
	ldh [hVariableWidthFontFF91], a
	call Func_28e73 ; function zeros out a large chunk of memory
.asm_28daa
	call PokedexDescriptionVWFCharacterMapping
	jr nc, .asm_28dcb
	push hl
	ldh [hVariableWidthFontFF92], a
	cp $ff
	jr nz, .asm_28dbb
	call Func_208c
	jr .asm_28dc8

.asm_28dbb
	ld c, a
	ld b, $0
	ld hl, CharacterWidths
	add hl, bc
	ld a, [hl]
	ldh [hVariableWidthFontFF93], a
	call LoadDexVWFCharacter
.asm_28dc8
	pop hl
	jr nc, .asm_28daa
.asm_28dcb
	pop de
	push af
	ld a, e
	ld [wd863], a
	ld a, d
	ld [wd864], a
	ld a, [wd862]
	and a
	jr nz, .asm_28ddd
	pop af
	ret

.asm_28ddd
	push hl
	ld a, [wd861]
	ld c, a
	ld b, $0
	bit 7, c ; `c` is always either 0 or 4, hence this always sets the zero flag
	jr z, .asm_28de9
	dec b
.asm_28de9
	ld hl, wPokedexFontBuffer
	add hl, bc
	ldh a, [hVariableWidthFontFF8F]
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	xor a
	call LoadOrCopyVRAMData
	pop hl
	pop af
	ret

LoadPokemonNameVWFCharacterTiles: ; 0x28e09
	push de
	ld a, b
	ldh [hVariableWidthFontFF8C], a
	ldh [hVariableWidthFontFF8D], a
	ld a, c
	ldh [hVariableWidthFontFF8F], a
	xor a
	ldh [hVariableWidthFontFF8E], a
	ldh [hVariableWidthFontFF90], a
	ldh [hVariableWidthFontFF91], a
	call Func_28e73
.asm_28e1c
	call Func_295e1
	jr nc, .asm_28e35
	push hl
	ldh [hVariableWidthFontFF92], a
	ld c, a
	ld b, $0
	ld hl, CharacterWidths
	add hl, bc
	ld a, [hl]
	ldh [hVariableWidthFontFF93], a
	call LoadDexVWFCharacter
	pop hl
	jr nc, .asm_28e1c
	nop
.asm_28e35
	pop de
	push af
	ld a, e
	ld [wd863], a
	ld a, d
	ld [wd864], a
	ld a, [wd862]
	and a
	jr nz, .asm_28e47
	pop af
	ret

.asm_28e47
	push hl
	ld a, [wd861]
	ld c, a
	ld b, $0
	bit 7, c
	jr z, .asm_28e53
	dec b
.asm_28e53
	ld hl, wPokedexFontBuffer
	add hl, bc
	ldh a, [hVariableWidthFontFF8F]
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	xor a
	call LoadOrCopyVRAMData
	pop hl
	pop af
	ret

; Appears to select a certain amount of memory that will get zeroed out.
Func_28e73: ; 0x28e73
	push hl
	ldh a, [hVariableWidthFontFF8F]
	; `a` in this function always contains either $0A, $16, or $6c
	; compute 16*a and stores it as `bc`.
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, Func_29566
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	; When we `push hl`, this will be the address that we will return to when `ret` is called.
	; Specifically, the address should occur somewhere in `Func_28e9a` or `Func_29566`, basically,
	; indicating how many memory locations we should zero out.
	push hl
	ld hl, wc000
	ld a, [wd860]
	ret

Func_28e9a:
REPT 20 * 87
	ld [hli], a
ENDR
Func_29566:
REPT 20
	ld [hli], a
ENDR
	pop hl
	ret

; This function takes in the character ID and performs some kind of mapping on it.
; Not exactly sure why. Need to research more.
PokedexDescriptionVWFCharacterMapping: ; 0x2957c
	ld a, BANK(PokedexDescriptionPointers)
	call ReadByteFromBank
	inc hl
	and a
	ret z
	cp $d ; carriage return
	jr nz, .checkNumericCharacter
	ld a, $ff
	scf
	ret

.checkNumericCharacter
	cp '0'
	jr c, .checkUpperCaseCharacter
	cp '9' + 1
	jr c, .asm_295be
.checkUpperCaseCharacter
	cp 'A'
	jr c, .checkLowerCaseCharacter
	cp 'Z' + 1
	jr c, .asm_295c2
.checkLowerCaseCharacter
	cp 'a'
	jr c, .checkSpecialCharacter
	cp 'z' + 1
	jr c, .asm_295c6
.checkSpecialCharacter
	cp ' '
	jr z, .asm_295ca
	cp ','
	jr z, .asm_295cd
	cp '.'
	jr z, .asm_295d1
	cp '`'
	jr z, .asm_295d5
	cp '-'
	jr z, .asm_295d9
	cp 'é'
	jr z, .asm_295dd
	and a
	ret

.asm_295be
	sub $88
	scf
	ret

.asm_295c2
	sub $8e
	scf
	ret

.asm_295c6
	sub $94
	scf
	ret

.asm_295ca
	xor a
	scf
	ret

.asm_295cd
	ld a, $f3
	scf
	ret

.asm_295d1
	ld a, $f4
	scf
	ret

.asm_295d5
	ld a, $fa
	scf
	ret

.asm_295d9
	ld a, $b2
	scf
	ret

.asm_295dd
	ld a, $f9
	scf
	ret

Func_295e1: ; 0x295e1
	ld a, [hli]
	and a
	ret z
	cp $80
	jr nc, .asm_295ed
	ld c, a
	ld b, $0
	jr .asm_295f0

.asm_295ed
	ld b, a
	ld a, [hli]
	ld c, a
.asm_295f0
	ld a, b
	and a
	jr nz, .asm_295f9
	ld a, c
	sub $20
	scf
	ret

.asm_295f9
	push hl
	call GetCharacterWidthIndex
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	scf
	ret

GetCharacterWidthIndex: ; 0x29605
	ld a, b
	cp $81
	jr nz, .asm_29611
	ld hl, CharacterWidthIndices1
	ld a, c
	sub $40
	ret

.asm_29611
	cp $83
	jr nz, .asm_2961c
	ld hl, CharacterWidthIndices3
	ld a, c
	sub $40
	ret

.asm_2961c
	ld a, c
	cp $9f
	jr nc, .asm_29628
	ld hl, CharacterWidthIndices2
	ld a, c
	sub $4f
	ret

.asm_29628
	ld hl, CharacterWidthIndices4
	ld a, c
	sub $9f
	ret

INCLUDE "data/vwf_character_widths.asm"
INCLUDE "text/pokedex_mon_names.asm"
INCLUDE "data/mon_species.asm"
INCLUDE "text/pokedex_species.asm"
INCLUDE "text/pokedex_mon_attributes.asm"
INCLUDE "data/dex_scroll_offsets.asm"
