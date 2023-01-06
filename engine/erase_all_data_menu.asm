HandleEraseAllDataMenu: ; 0x815d
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
EraseAllDataMenuFunctions: ; 0x8161
	dw CheckForResetButtonCombo
	dw HandleEraseAllDataInput
	dw ExitEraseAllDataMenu

CheckForResetButtonCombo: ; 0x8167
	ld a, [hJoypadState]
	cp (D_UP | D_RIGHT | START | SELECT)
	jr z, .heldCorrectButtons
	ld hl, wCurrentScreen
	inc [hl]
	ret

.heldCorrectButtons
	ld a, $41
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	xor a
	ld [wOBP0], a
	ld [wOBP1], a
	ld [hSCX], a
	ld [hSCY], a
	ld a, [hGameBoyColorFlag]
	ld hl, EraseAllDataGfxPointers
	call LoadVideoData
	call ClearOAMBuffer
	call SetAllPalettesWhite
	call EnableLCD
	call SGBNormal
	call FadeIn
	ld hl, wScreenState
	inc [hl]
	ret

EraseAllDataGfxPointers: ; 0x81a2
	dw EraseAllDataGfx_GameBoy
	dw EraseAllDataGfx_GameBoyColor

EraseAllDataGfx_GameBoy: ; 0x81a6
	VIDEO_DATA_TILES   EraseAllDataGfx, vTilesBG, $300
	VIDEO_DATA_TILEMAP EraseAllDataTilemap, vBGMap, $400
	db $FF, $FF ; terminators

EraseAllDataGfx_GameBoyColor: ; 0x81b6
	VIDEO_DATA_TILES    EraseAllDataGfx, vTilesBG, $300
	VIDEO_DATA_TILEMAP  EraseAllDataTilemap, vBGMap, $400
	VIDEO_DATA_BGATTR   EraseAllDataBGAttributes, vBGMap, $400
	VIDEO_DATA_PALETTES HighScoresRedStagePalettes, $80
	db $FF, $FF ; terminators

HandleEraseAllDataInput: ; 0x81d4
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .checkForBButton
	ld hl, $a000
	xor a
	ld b, a
.eraseSavedDataLoop
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .eraseSavedDataLoop
	ld hl, wScreenState
	inc [hl]
	ret

.checkForBButton
	bit BIT_B_BUTTON, a
	ret z
	ld hl, wScreenState
	inc [hl]
	ret

ExitEraseAllDataMenu: ; 0x820f
	call FadeOut
	call DisableLCD
	ld hl, wCurrentScreen
	inc [hl]
	xor a
	ld [wScreenState], a
	ret
