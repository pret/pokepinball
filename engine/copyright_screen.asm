HandleCopyrightScreen: ; 0x821e
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
CopyrightScreenFunctions: ; 0x8222
	dw FadeInCopyrightScreen
	dw DisplayCopyrightScreen
	dw FadeOutCopyrightScreenAndLoadData

FadeInCopyrightScreen: ; 0x8228
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
	ld hl, CopyrightTextGfxPointers
	call LoadVideoData
	call ClearOAMBuffer
	call SetAllPalettesWhite
	call EnableLCD
	call SGBNormal
	ld bc, $0050
	call AdvanceFrames
	call FadeIn
	ld hl, wScreenState
	inc [hl]
	ret

CopyrightTextGfxPointers: ; 0x825e
	dw CopyrightTextGfx_GameBoy
	dw CopyrightTextGfx_GameBoyColor

CopyrightTextGfx_GameBoy: ; 0x8262
	VIDEO_DATA_TILES   CopyrightTextGfx, vTilesSH, $400
	VIDEO_DATA_TILEMAP CopyrightScreenTilemap, vBGMap, $400
	db $FF, $FF  ; terminators

CopyrightTextGfx_GameBoyColor: ; 0x8272
	VIDEO_DATA_TILES    CopyrightTextGfx, vTilesSH, $400
	VIDEO_DATA_TILEMAP  CopyrightScreenTilemap, vBGMap, $400
	VIDEO_DATA_BGATTR   CopyrightScreenBGAttributes, vBGMap, $400
	VIDEO_DATA_PALETTES CopyrightScreenPalettes, $80
	db $FF, $FF ; terminators

DisplayCopyrightScreen: ; 0x8290
	ld b, $5a  ; number of frames to show the copyright screen
.delayLoop
	push bc
	rst AdvanceFrame  ; wait for next frame
	pop bc
	ld a, b
	cp $2d  ; player can press A button to skip copyright screen once counter is below $2d
	jr nc, .decrementCounter
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr nz, .done
.decrementCounter
	dec b
	jr nz, .delayLoop
.done
	ld hl, wScreenState
	inc [hl]
	ret

FadeOutCopyrightScreenAndLoadData: ; 0x82a8
	call FadeOut
	call DisableLCD
	ld hl, sHighScores
	ld de, wRedHighScore1Points
	ld bc, $0082
	call LoadSavedData
	jr c, .loadedHighScores
	callba CopyInitialHighScores
.loadedHighScores
	ld hl, sPokedexFlags
	ld de, wPokedexFlags
	ld bc, $0098
	call LoadSavedData
	jr c, .asm_82de
	callba ClearPokedexData
.asm_82de
	ld hl, sKeyConfigs
	ld de, wKeyConfigs
	ld bc, $000e
	call LoadSavedData
	jr c, .asm_82f6
	callba SaveDefaultKeyConfigs
.asm_82f6
	ld hl, sSaveGame
	ld de, wPartyMons
	ld bc, $04c3  ; This is saved game data from when the player saves in the middle of a game.
	call LoadSavedData
	jr c, .asm_8308
	xor a
	ld [wd7c2], a  ; if this is non-zero, the main menu will prompt for "continue or new game?".
.asm_8308
	ld hl, wCurrentScreen
	inc [hl]
	xor a
	ld [wScreenState], a
	ret
