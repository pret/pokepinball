HandleTitlescreen: ; 0xc000
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
TitlescreenFunctions: ; 0xc004
	dw FadeInTitlescreen
	dw TitlescreenLoop ; titlescreen loop
	dw Func_c10e ; previously saved game menu
	dw Func_c1cb ; game start, pokedex, option
	dw GoToHighScoresFromTitlescreen ; go to high scores

FadeInTitlescreen: ; 0xc00e
	ld a, $43
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld a, $d2
	ld [wOBP0], a
	ld a, $e1
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld hl, TitlescreenFadeInGfxPointers
	ld a, [hGameBoyColorFlag]
	call LoadVideoData
	ld a, $1
	ld [wTitleScreenGameStartCursorSelection], a
	call ClearOAMBuffer
	ld a, $2
	ld [wTitleScreenPokeballAnimationCounter], a
	call HandleTitlescreenAnimations
	call Func_b66
	ld a, $11
	call SetSongBank
	ld de, $0004
	call PlaySong
	call Func_588
	call FadeIn
	ld hl, wScreenState
	inc [hl]
	ret

TitlescreenFadeInGfxPointers: ; 0xc057
	dw TitlescreenFadeInGfx_GameBoy
	dw TitlescreenFadeInGfx_GameBoyColor

TitlescreenFadeInGfx_GameBoy: ; 0xc05b
	VIDEO_DATA_TILES   TitlescreenGfx, vTilesOB, $1800
	VIDEO_DATA_TILEMAP TitlescreenTilemap, vBGMap, $240
	db $FF, $FF ; terminators

TitlescreenFadeInGfx_GameBoyColor: ; 0xc06b
	VIDEO_DATA_TILES    TitlescreenFadeInGfx, vTilesOB, $1800
	VIDEO_DATA_TILEMAP  TitlescreenTilemap, vBGMap, $240
	VIDEO_DATA_BGATTR   TitlescreenBGAttributes, vBGMap, $240
	VIDEO_DATA_PALETTES TitlescreenPalettes, $80
	db $FF, $FF ; terminators

TitlescreenLoop: ; 0xc089
	call Func_c0ee
	call HandleTitlescreenAnimations
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a  ; was A button pressed?
	jr z, .AButtonNotPressed
	ld a, [wTitleScreenCursorSelection]
	and a
	jr nz, .asm_c0d3
	; player chose "Game Start"
	ld a, [wd7c2]  ; if this is non-zero, the main menu will prompt for "continue or new game?".
	and a
	jr z, .noPreviouslySavedGame
	lb de, $00, $01
	call PlaySoundEffect
	xor a
	ld [wd910], a
	ld a, $2
	ld [wd911], a
	ld a, $1
	ld [wTitleScreenGameStartCursorSelection], a
	ld hl, wScreenState
	inc [hl]
	ret

.noPreviouslySavedGame
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $00, $27
	call PlaySoundEffect
	ld bc, $0037
	call AdvanceFrames
	ld a, $3
	ld [wScreenState], a
	ret

.asm_c0d3
	lb de, $00, $01
	call PlaySoundEffect
	ld a, $3
	ld [wScreenState], a
	ret

.AButtonNotPressed
	bit BIT_B_BUTTON, a  ; was B button pressed?
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	ld a, $4
	ld [wScreenState], a
	ret

Func_c0ee: ; 0xc0ee
	ld hl, wTitleScreenCursorSelection
	ld c, $2
	call Func_c1fc
	ret

HandleTitlescreenAnimations: ; 0xc0f7
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_c104
	ld bc, $2040
	ld a, $62  ; seemingly-unused OAM data for titlescreen. It's just blank tiles.
	call LoadOAMData
.asm_c104
	call Func_c21d  ; does nothing...
	call HandleTitlescreenPikachuBlinkingAnimation
	call HandleTitlescreenPokeballAnimation
	ret

Func_c10e: ; 0xc10e
	call Func_c1a2
	call Func_c1b1
	ld a, [wd910]
	cp $6
	ret nz
	ld a, [hNewlyPressedButtons]
	bit 0, a
	jr z, .asm_c17c
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $00, $27
	call PlaySoundEffect
	ld bc, $0041
	call AdvanceFrames
	ld a, [wTitleScreenGameStartCursorSelection]
	and a
	jr z, .asm_c177
	call FadeOut
	call Func_576
	ld a, [wd7c2]
	and a
	jr z, .asm_c173
	ld hl, sSaveGame
	ld de, wPartyMons
	ld bc, $04c3
	call LoadSavedData
	jr nc, .asm_c173
	xor a
	ld [wd7c2], a
	ld hl, wPartyMons
	ld de, sSaveGame
	ld bc, $04c3
	call SaveData
	ld a, $1
	ld [wd7c1], a
	ld a, SCREEN_PINBALL_GAME
	ld [wCurrentScreen], a
	ld a, $0
	ld [wScreenState], a
	ret

.asm_c173
	xor a
	ld [wd7c1], a
.asm_c177
	ld hl, wScreenState
	inc [hl]
	ret

.asm_c17c
	bit 1, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	ld a, $8
	ld [wd910], a
	ld a, $2
	ld [wd911], a
.asm_c18f
	call CleanOAMBuffer
	rst AdvanceFrame
	call Func_c1b1
	ld a, [wd910]
	cp $e
	jr nz, .asm_c18f
	ld hl, wScreenState
	dec [hl]
	ret

Func_c1a2: ; 0xc1a2
	ld a, [wd910]
	cp $6
	ret nz
	ld hl, wTitleScreenGameStartCursorSelection
	ld c, $1
	call Func_c1fc
	ret

Func_c1b1: ; 0xc1b1
	call Func_c2df
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_c1c1
	ld bc, $2040
	ld a, $62
	call LoadOAMData
.asm_c1c1
	call Func_c21d
	call HandleTitlescreenPikachuBlinkingAnimation
	call HandleTitlescreenPokeballAnimation
	ret

Func_c1cb: ; 0c1cb
	call FadeOut
	call Func_576
	ld a, [wTitleScreenCursorSelection]
	ld c, a
	ld b, $0
	ld hl, Data_c1e4
	add hl, bc
	ld a, [hl]
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

Data_c1e4: ; 0xc1e4
	db SCREEN_FIELD_SELECT
	db SCREEN_POKEDEX
	db SCREEN_OPTIONS

GoToHighScoresFromTitlescreen: ; 0xc1e7
	call FadeOut
	call Func_576
	ld a, SCREEN_HIGH_SCORES
	ld [wCurrentScreen], a
	ld a, $1
	ld [wScreenState], a
	xor a
	ld [wda7f], a
	ret

Func_c1fc: ; 0xc1fc
	ld a, [hPressedButtons]
	ld b, a
	ld a, [hl]
	bit 6, b
	jr z, .asm_c20f
	and a
	ret z
	dec a
	ld [hl], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

.asm_c20f
	bit 7, b
	ret z
	cp c
	ret z
	inc a
	ld [hl], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_c21d: ; 0xc21d
; World's greatest function.
	ret

HandleTitlescreenPikachuBlinkingAnimation: ; 0xc21e
	ld a, [wTitleScreenBlinkAnimationFrame]
	sla a
	ld c, a
	ld b, $0
	ld hl, TitleScreenBlinkAnimation
	add hl, bc
	lb bc, $38, $10
	ld a, [hl]
	cp $5a  ; blink animation frame 1 OAM id
	call nz, LoadOAMData
	ld a, [wTitleScreenBlinkAnimationCounter]
	dec a
	jr nz, .done
	inc hl
	inc hl  ; hl points to next frame in TitleScreenBlinkAnimation array
	ld a, [hl]
	and a  ; reached the end of the animation frames?
	jr z, .saveAnimationFrame
	ld a, [wTitleScreenBlinkAnimationFrame]
	inc a
.saveAnimationFrame
	ld [wTitleScreenBlinkAnimationFrame], a
	sla a
	ld c, a
	ld b, $0
	ld hl, (TitleScreenBlinkAnimation + 1)
	add hl, bc
	ld a, [hl]  ;  a contains second byte in the current animation frame data
	cp $3c  ;  is this a long-duration animation frame?
	jr c, .done
	ld c, a
	call GenRandom
	and $1f
	add c
.done
	ld [wTitleScreenBlinkAnimationCounter], a
	ret

TitleScreenBlinkAnimation: ; 0xc25f
; Array of animation frames. The animation is looped when it finishes.
; first byte = OAM data id to load
; second byte = number of frames to show this animation.
	db $5a, $c8
	db $5b, $04
	db $5c, $04
	db $5b, $04
	db $5a, $3c
	db $5b, $03
	db $5c, $03
	db $5b, $03
	db $5a, $03
	db $5b, $03
	db $5c, $03
	db $5b, $03
	db $00  ; terminator

HandleTitlescreenPokeballAnimation: ; 0xc278
	ld a, [wTitleScreenCursorSelection]
	sla a
	ld c, a
	ld b, $0
	ld hl, TitleScreenPokeballCoordOffsets
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld e, $0
	ld a, [wScreenState]  ; TODO: I think this is the "titlescreen state" byte.
	cp $1
	jr nz, .loadOAM  ; skip getting the correct animation frame
	ld a, [wTitleScreenBouncingBallAnimationFrame]
	sla a
	ld e, a
.loadOAM
	ld d, $0
	ld hl, TitleScreenPokeballAnimation
	add hl, de
	ld a, [hl]  ; a contains OAM id
	call LoadOAMData
	ld a, [wTitleScreenPokeballAnimationCounter]
	dec a
	jr nz, .done
	ld a, [wTitleScreenBouncingBallAnimationFrame]
	sla a
	ld c, a
	ld b, $0
	ld hl, (TitleScreenPokeballAnimation + 2)  ; first frame of actual animation
	add hl, bc
	ld a, [hl]
	and a
	jr z, .saveAnimationFrame  ; end of list?
	ld a, [wTitleScreenBouncingBallAnimationFrame]
	inc a
.saveAnimationFrame
	ld [wTitleScreenBouncingBallAnimationFrame], a
	sla a
	ld c, a
	ld b, $0
	ld hl, (TitleScreenPokeballAnimation + 1)  ; first duration
	add hl, bc
	ld a, [hl]
.done
	ld [wTitleScreenPokeballAnimationCounter], a
	ret

TitleScreenPokeballAnimation: ; 0xc2cc
; first byte  = OAM id
; second byte = animation frame duration
	db $5D, $02
	db $5E, $06
	db $5F, $02
	db $60, $04
	db $61, $06
	db $5F, $04
	db $00  ; terminator

TitleScreenPokeballCoordOffsets: ; 0xc2d9
	db $67, $15
	db $73, $15
	db $7F, $15

Func_c2df: ; 0xc2df
	ld bc, $4446  ; pixel offsets, not data
	ld a, [wd910]
	cp $6
	jr nz, .asm_c2f0
	ld a, [wTitleScreenGameStartCursorSelection]
	add $58
	jr .asm_c2fd

.asm_c2f0
	ld a, [wd910]
	sla a
	ld e, a
	ld d, $0
	ld hl, Data_c32b
	add hl, de
	ld a, [hl]
.asm_c2fd
	call LoadOAMData
	ld a, [wd911]
	dec a
	jr nz, .asm_c327
	ld a, [wd910]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c32b + 2
	add hl, bc
	ld a, [hl]
	and a
	ld a, [wd910]
	jr z, .asm_c31d
	inc a
	ld [wd910], a
.asm_c31d
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c32b + 1
	add hl, bc
	ld a, [hl]
.asm_c327
	ld [wd911], a
	ret

Data_c32b: ; 0xc32b
	db $52, $02
	db $53, $02
	db $54, $02
	db $55, $02
	db $56, $02
	db $57, $02
	db $57, $02
	db $00, $00
	db $57, $02
	db $56, $02
	db $55, $02
	db $54, $02
	db $53, $02
	db $52, $02
	db $52, $02
	db $00
