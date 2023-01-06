HandleSelectGameboyTargetMenu: ; 0x8000
; This is an unreachable debug menu, which allowed developers to choose to run the game
; in either DMG or Game Boy Color mode.
; If you want to access this menu, you must set the initial screen to
; SCREEN_SELECT_GAMEBOY_TARGET, instead of SCREEN_ERASE_ALL_DATA.
; Additionally, you must hold UP when booting the game.
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
SelectGameboyTargetMenuFunctions: ; 0x8004
	dw InitSelectGameboyTargetMenu
	dw SelectCGBOrDMG
	dw EndSelectGameboyTargetMenu

InitSelectGameboyTargetMenu: ; 0x800a
	xor a
	ld [hFFC4], a
	ld a, [hJoypadState]
	cp D_UP
	jr nz, .skipDebugMenu
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .showMenu
.skipDebugMenu
	ld hl, wCurrentScreen
	inc [hl] ; set to SCREEN_ERASE_ALL_DATA
	xor a
	ld [wScreenState], a
	ret

.showMenu
	ld a, $45
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call LoadGameboyTargetMenuGfx
	call ClearOAMBuffer
	call SetAllPalettesWhite
	call EnableLCD
	call FadeIn
	ld hl, wScreenState
	inc [hl]
	ret

LoadGameboyTargetMenuGfx: ; 0x8049
	ld a, $1
	ld [rVBK], a
	ld c, $ff
	call FillTilesVRAM
	call FillBackgroundsVRAM
	xor a
	ld [rVBK], a
	ld c, $0
	call FillTilesVRAM
	call FillBackgroundsVRAM
	; This code makes no sense.
	; It first fills 33 bytes at $ff68, then refills at rOBPI
	ld a, $80
	ld de, rBGPI
	ld hl, Data_80e4
	call FillPalette
	ld a, $80
	ld de, rOBPI
	ld hl, Data_80f4
	call FillPalette
	ld hl, SelectGameboyTargetGfxPointers
	xor a
	call LoadVideoData
	ld a, Bank(SelectGameboyTarget_TileData)
	ld bc, SelectGameboyTarget_TileData
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	ret

SelectGameboyTargetGfxPointers: ; 0x8089
	dw SelectGameboyTarget_VideoData

SelectGameboyTarget_VideoData: ; 0x808b
	VIDEO_DATA_TILES SelectGameboyTargetTextGfx, vTilesSH + $200, $400
	db $FF, $FF ; terminators

SelectGameboyTarget_TileData: ; 0x8094
	db $13
	dbw $06, vBGMap + $a3
	db $BC, $AF, $B6, $AF, $AD, $BD
	dbw $06, $98AA
	db $BD, $AB, $BB, $B1, $AF, $BD
	dbw $04, $98E3
	db $D0, $AD, $B1, $AC
	dbw $03, $9924
	db $AE, $B7, $B1
	db $00  ; terminator

FillBackgroundsVRAM: ; 0x80b5
	ld hl, vBGMap
.fillLoop
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, h
	cp $a0  ; end of VRAM
	jr nz, .fillLoop
	ret

FillTilesVRAM: ; 0x80c3
	ld hl, vTilesOB
.fillLoop
	ld a, c
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, h
	cp (vBGMap >> 8)
	jr nz, .fillLoop
	ret

FillPalette: ; 0x80d1
; First places a in [de].
; Then, reads 32 bytes from hl and places them in order at de + 1
	ld [de], a
	inc de
	ld b, $4
.outerLoop
	ld c, $8
	push hl
.innerLoop
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	dec c
	jr nz, .innerLoop
	pop hl
	dec b
	jr nz, .outerLoop
	ret

Data_80e4: ; 0x80e4
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 11, 11, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 11, 11, 11
	RGB 00, 00, 00

Data_80f4: ; 0x80f4
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 11, 11, 11
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 11, 11, 11
	RGB 00, 00, 00

SelectCGBOrDMG: ; 0x8104
	ld a, [hNewlyPressedButtons]
	ld b, a
	and (D_DOWN | D_UP)
	jr z, .directionNotPressed
	ld a, [hGameBoyColorFlag]
	ld [hFFC4], a
	xor $1
	ld [hGameBoyColorFlag], a
	jr .moveCursor

.directionNotPressed
	bit BIT_A_BUTTON, b
	ret z
	ld hl, wScreenState
	inc [hl]
	ret

.moveCursor
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .cgb
	ld a, Bank(DMGSelected_TileData)
	ld bc, DMGSelected_TileData
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	ret

.cgb
	ld a, Bank(CGBSelected_TileData)
	ld bc, CGBSelected_TileData
	ld de, LoadTileLists
	call QueueGraphicsToLoadWithFunc
	ret

DMGSelected_TileData: ; 0x813a
	db $02
	dbw $01, $98E3
	db $D1
	dbw $01, $9923
	db $D0
	db $00  ; terminator

CGBSelected_TileData: ; 0x8144
	db $02
	dbw $01, $98E3
	db $D0
	dbw $01, $9923
	db $D1
	db $00  ; terminator

EndSelectGameboyTargetMenu: ; 0x414e
	call FadeOut
	call DisableLCD
	ld hl, wCurrentScreen
	inc [hl] ; set to SCREEN_ERASE_ALL_DATA
	xor a
	ld [wScreenState], a
	ret
