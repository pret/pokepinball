INCLUDE "charmap.asm"
INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "home.asm"

SECTION "bank1", ROMX, BANK[$1]
INCLUDE "data/oam_frames.asm"

SECTION "bank2", ROMX, BANK[$2]

Func_8000: ; 0x8000
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_8004: ; 0x8004
	dw Func_800a
	dw Func_8104
	dw Func_814e

Func_800a: ; 0x800a
	xor a
	ld [hFFC4], a
	ld a, [hJoypadState]
	cp D_UP
	jr nz, .asm_8018
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_8021
.asm_8018
	ld hl, wCurrentScreen
	inc [hl]
	xor a
	ld [wScreenState], a
	ret

.asm_8021
	ld a, $45
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	call Func_8049
	call ClearOAMBuffer
	call Func_b66
	call Func_588
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ret

Func_8049: ; 0x8049
; This function is unused?
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
	call Fill33Bytes
	ld a, $80
	ld de, rOBPI
	ld hl, Data_80f4
	call Fill33Bytes
	ld hl, PointerTable_8089
	xor a
	call LoadVideoData
	ld a, Bank(UnusedTileListData_8094)
	ld bc, UnusedTileListData_8094
	ld de, LoadTileLists
	call Func_10c5
	ret

PointerTable_8089: ; 0x8089
	dw UnusedTextVideoData

UnusedTextVideoData: ; 0x808b
	VIDEO_DATA_TILES UnusedTextGfx, vTilesSH + $200, $400
	db $FF, $FF ; terminators

UnusedTileListData_8094: ; 0x8094
	db $13
	dbw $06, $98A3
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

Fill33Bytes: ; 0x80d1
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
	db $FF
	db $7F
	db $B5
	db $56
	db $6B
	db $2D
	db $00
	db $00
	db $FF
	db $7F
	db $B5
	db $56
	db $6B
	db $2D
	db $00
	db $00
Data_80f4: ; 0x80f4
	db $B5
	db $56
	db $FF
	db $7F
	db $6B
	db $2D
	db $00
	db $00
	db $FF
	db $7F
	db $B5
	db $56
	db $6B
	db $2D
	db $00
	db $00

Func_8104: ; 0x8104
	ld a, [hNewlyPressedButtons]
	ld b, a
	and (D_DOWN | D_UP)
	jr z, .asm_8115
	ld a, [hGameBoyColorFlag]
	ld [hFFC4], a
	xor $1
	ld [hGameBoyColorFlag], a
	jr .asm_811d

.asm_8115
	bit BIT_A_BUTTON, b
	ret z
	ld hl, wScreenState
	inc [hl]
	ret

.asm_811d
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_812e
	ld a, Bank(Data_813a)
	ld bc, Data_813a
	ld de, LoadTileLists
	call Func_10c5
	ret

.asm_812e
	ld a, Bank(Data_8144)
	ld bc, Data_8144
	ld de, LoadTileLists
	call Func_10c5
	ret

Data_813a: ; 0x813a
	db $02
	dbw $01, $98E3
	db $D1
	dbw $01, $9923
	db $D0
	db $00  ; terminator

Data_8144: ; 0x8144
	db $02
	dbw $01, $98E3
	db $D0
	dbw $01, $9923
	db $D1
	db $00  ; terminator

Func_814e: ; 0x414e
	call Func_cb5
	call Func_576
	ld hl, wCurrentScreen
	inc [hl]
	xor a
	ld [wScreenState], a
	ret

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
	call Func_b66
	call Func_588
	call SGBNormal
	call Func_bbe
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
	call Func_cb5
	call Func_576
	ld hl, wCurrentScreen
	inc [hl]
	xor a
	ld [wScreenState], a
	ret

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
	call Func_b66
	call Func_588
	call SGBNormal
	ld bc, $0050
	call AdvanceFrames
	call Func_bbe
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
	call Func_cb5
	call Func_576
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

InitializeStage: ; 0x8311
	ld hl, wc000
	ld bc, $0a00
	call ClearData
	ld a, $1
	ld [rVBK], a
	ld a, [wd805]
	and a
	jr nz, .asm_8331
	ld hl, vBGWin
	ld bc, $0400
	ld a, $0
	call Func_63e
	jr .asm_833c

.asm_8331
	ld hl, vBGWin
	ld bc, $0400
	ld a, $8
	call Func_63e
.asm_833c
	xor a
	ld [rVBK], a
	call Func_8388
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_8348: ; 0x8348
	; STAGE_RED_FIELD_TOP
	padded_dab InitRedField
	; STAGE_RED_FIELD_BOTTOM
	padded_dab InitRedField
	padded_dab Func_18000
	padded_dab Func_18000
	; STAGE_BLUE_FIELD_TOP
	padded_dab InitBlueField
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab InitBlueField
	; STAGE_GENGAR_BONUS
	padded_dab InitGengarBonusStage
	; STAGE_GENGAR_BONUS
	padded_dab InitGengarBonusStage
	; STAGE_MEWTWO_BONUS
	padded_dab InitMewtwoBonusStage
	; STAGE_MEWTWO_BONUS
	padded_dab InitMewtwoBonusStage
	; STAGE_MEOWTH_BONUS
	padded_dab InitMeowthBonusStage
	; STAGE_MEOWTH_BONUS
	padded_dab InitMeowthBonusStage
	; STAGE_DIGLETT_BONUS
	padded_dab InitDiglettBonusStage
	; STAGE_DIGLETT_BONUS
	padded_dab InitDiglettBonusStage
	; STAGE_SEEL_BONUS
	padded_dab InitSeelBonusStage
	; STAGE_SEEL_BONUS
	padded_dab InitSeelBonusStage

Func_8388: ; 0x8388
	ld a, [wd7c1]
	and a
	jr z, .asm_8398
	ld hl, wSubTileBallXPos
	ld bc, $0037
	call ClearData
	ret

.asm_8398
	ld a, [wCurrentStage]
	cp $6
	ret nc
	ld hl, wPartyMons
	ld bc, $0170
	call ClearData
	ld hl, wd473
	ld bc, $0039
	call ClearData
	ld hl, wd4ad
	ld bc, $034d
	call ClearData
	ret

StartBallForStage: ; 0x83ba
	ld a, [wd7c1]
	and a
	jr z, .asm_83c7
	call Func_8444
	call RestartStageMusic
	ret

.asm_83c7
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wd7ae], a
	ld [wd7af], a
	ld [wd7b2], a
	ld [wd7b3], a
	ld [wd7b0], a
	ld [wd7b1], a
	ld [wd7b4], a
	ld [wd7b5], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	inc a
	ld [wd548], a
	ld [wd549], a
	ld a, $20
	ld [wSCX], a
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_8404: ; 0x8404
	; STAGE_RED_FIELD_TOP
	padded_dab StartBallRedField
	; STAGE_RED_FIELD_BOTTOM
	padded_dab StartBallRedField
	padded_dab Func_1804a
	padded_dab Func_1804a
	; STAGE_BLUE_FIELD_TOP
	padded_dab StartBallBlueField
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab StartBallBlueField
	; STAGE_GENGAR_BONUS
	padded_dab StartBallGengarBonusStage
	; STAGE_GENGAR_BONUS
	padded_dab StartBallGengarBonusStage
	; STAGE_MEWTWO_BONUS
	padded_dab StartBallMewtwoBonusStage
	; STAGE_MEWTWO_BONUS
	padded_dab StartBallMewtwoBonusStage
	; STAGE_MEOWTH_BONUS
	padded_dab StartBallMeowthBonusStage
	; STAGE_MEOWTH_BONUS
	padded_dab StartBallMeowthBonusStage
	; STAGE_DIGLETT_BONUS
	padded_dab StartBallDiglettBonusStage
	; STAGE_DIGLETT_BONUS
	padded_dab StartBallDiglettBonusStage
	; STAGE_SEEL_BONUS
	padded_dab StartBallSeelBonusStage
	; STAGE_SEEL_BONUS
	padded_dab StartBallSeelBonusStage

Func_8444: ; 0x8444
	ld a, [wInSpecialMode]
	and a
	jr z, .asm_8460
	ld a, [wSpecialMode]
	and a
	jr nz, .asm_8460
	ld a, [wWildMonIsHittable]
	and a
	jr z, .asm_8460
	callba Func_10464
.asm_8460
	ret

RestartStageMusic: ; 0x8461
	ld a, [wStageSongBank]
	call SetSongBank
	ld a, [wStageSong]
	ld e, a
	ld d, $0
	call PlaySong
	ret

Func_8471: ; 0x8471
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_8477: ; 0x8477
	; STAGE_RED_FIELD_TOP
	padded_dab Func_14000
	; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_1401c
	padded_dab DoNothing_1805f
	padded_dab DoNothing_18060
	; STAGE_BLUE_FIELD_TOP
	padded_dab Func_1c165
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab Func_1c191
	; STAGE_GENGAR_BONUS
	padded_dab Func_1818b
	; STAGE_GENGAR_BONUS
	padded_dab Func_1818b
	; STAGE_MEWTWO_BONUS
	padded_dab Func_19310
	; STAGE_MEWTWO_BONUS
	padded_dab Func_19310
	; STAGE_MEOWTH_BONUS
	padded_dab Func_24128
	; STAGE_MEOWTH_BONUS
	padded_dab Func_24128
	; STAGE_DIGLETT_BONUS
	padded_dab Func_19a76
	; STAGE_DIGLETT_BONUS
	padded_dab Func_19a76
	; STAGE_SEEL_BONUS
	padded_dab Func_25b97
	; STAGE_SEEL_BONUS
	padded_dab Func_25b97

Func_84b7: ; 0x84b7
	ld a, [wCurrentStage]
	call CallInFollowingTable
PointerTable_84bd: ; 0x84bd
	; STAGE_RED_FIELD_TOP
	padded_dab Func_1755c
	; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_1757e
	padded_dab Func_18079
	padded_dab Func_18084
	; STAGE_BLUE_FIELD_TOP
	padded_dab Func_1f330
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab Func_1f35a
	; STAGE_GENGAR_BONUS
	padded_dab Func_18faf
	; STAGE_GENGAR_BONUS
	padded_dab Func_18faf
	; STAGE_MEWTWO_BONUS
	padded_dab Func_1994e
	; STAGE_MEWTWO_BONUS
	padded_dab Func_1994e
	; STAGE_MEOWTH_BONUS
	padded_dab Func_2583b
	; STAGE_MEOWTH_BONUS
	padded_dab Func_2583b
	; STAGE_DIGLETT_BONUS
	padded_dab Func_1ac98
	; STAGE_DIGLETT_BONUS
	padded_dab Func_1ac98
	; STAGE_SEEL_BONUS
	padded_dab Func_26b7e
	; STAGE_SEEL_BONUS
	padded_dab Func_26b7e

Func_84fd:
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .not_cgb
	ld a, $1
	ld [rVBK], a
	xor a
	call .FillAttrsOrBGMap
	xor a
	ld [rVBK], a
.not_cgb
	ld a, $81
	call .FillAttrsOrBGMap
	ld de, wBottomMessageBuffer + $47
	call Func_8524
	ret

.FillAttrsOrBGMap: ; 8519 (2:4519)
	hlCoord 0, 0, vBGWin
	ld b, $20
.loop
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Func_8524: ; 0x8524
	ld hl, wScore + $5
	lb bc, $0c, $01
.loop
	ld a, [hl]
	swap a
	and $f
	call .GetDigit
	inc de
	dec b
	ld a, [hld]
	and $f
	call .GetDigit
	inc de
	dec b
	jr nz, .loop
	ld a, $86
	ld [de], a
	inc de
	ret

.GetDigit: ; 0x8543
	jr nz, .okay
	ld a, b
	dec a
	jr z, .okay
	ld a, c
	and a
	ret nz
.okay
	add $86 ; 0
	ld [de], a
	ld c, $0
	ld a, b
	cp $c
	jr z, .load_tile_82
	cp $9
	jr z, .load_tile_82
	cp $6
	jr z, .load_tile_82
	cp $3
	ret nz
.load_tile_82
	set 7, e
	ld a, $82 ; ,
	ld [de], a
	res 7, e
	ret

Func_8569:
	xor a
	ld hl, wAddScoreQueue
	ld b, $31
.asm_856f
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_856f
	ld [hli], a
	ret

AddBigBCD6FromQueueWithBallMultiplier: ; 0x8576
	ld h, b
	ld l, c
	ld a, [wAddScoreQueueOffset]
	ld e, a
	ld d, wAddScoreQueue / $100
	ld a, [wBallType]
	and a
	jr nz, .asm_8585
	inc a
.asm_8585
	ld b, a
	jr asm_8592

AddBigBCD6FromQueue: ; 0x8588
; bc - Points to BCD buffer
	ld h, b
	ld l, c
	ld a, [wAddScoreQueueOffset]
	ld e, a
	ld d, wAddScoreQueue / $100
	ld b, $1
asm_8592:
	push hl
x = 0
rept 6
	ld a, [de]
if x == 0
	add [hl]
else
	adc [hl]
endc
	daa
	ld [de], a
	inc de
	inc hl
x = x + 1
endr
	ld a, e
	cp wAddScoreQueueEnd % $100
	jr nz, .okay
	ld e, wAddScoreQueue % $100
.okay
	pop hl
	dec b
	jr nz, asm_8592
	ld a, e
	ld [wAddScoreQueueOffset], a
	ret

Func_85c7: ; 0x85c7
	ld a, [hNumFramesDropped]
	and $3
	ret nz
	ld a, [wd478]
	ld l, a
	ld h, wAddScoreQueue / $100
	ld de, wScore
	ld a, [wAddScoreQueueOffset]
	cp l
	jr nz, .asm_85de
	ld [wd479], a
.asm_85de
	push hl
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	pop hl
	jr nz, .value_is_nonzero
	ld a, [wd479]
	ld [wd478], a
	ret

.value_is_nonzero
	ld a, [de]
	add [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	call c, SetMaxScore
	inc de
	inc hl
	ld a, l
	cp $60
	jr nz, .asm_862d
	ld l, $0
.asm_862d
	ld a, l
	ld [wd478], a
	ld a, $1
	ld [wd49f], a
	ret

SetMaxScore: ; 0x8637
	push hl
	ld hl, wScore
	ld a, $99
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	ret

Func_8645: ; 0x8645
	xor a
	ld [wd49f], a
	ld de, wBottomMessageBuffer + $47
	call Func_8524
	ret

Func_8650: ; 0x8650
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .bottomStage
	ld a, $86
	ld [hWY], a
	ret

.bottomStage
	ld a, [wBallYPos + 1]
	cp $84
	jr nc, .asm_8670
	ld a, [hWY]
	sub $3
	cp $86
	jr nc, .asm_866d
	ld a, $86
.asm_866d
	ld [hWY], a
	ret

.asm_8670
	ld a, [hWY]
	add $3
	cp $90
	jr c, .asm_867a
	ld a, $90
.asm_867a
	ld [hWY], a
	ret

StartTimer: ; 0x867d
; Starts the timer that counts down with the specified starting time when things
; like CatchEm Mode starts.
; input:  b = minutes
;         c = seconds
	ld a, c
	ld [wTimerSeconds], a
	ld a, b
	ld [wTimerMinutes], a
	xor a
	ld [wTimerFrames], a
	ld [wd57e], a
	ld [wd57f], a
	ld a, $1
	ld [wd57d], a
	ld a, $1
	ld [wd580], a
	callba Func_1404a
	ret

Func_86a4: ; 0x86a4
	ld a, [wd57f]
	and a
	ret nz
	ld a, [wTimerFrames]
	inc a
	cp $3c
	jr c, .asm_86b2
	xor a
.asm_86b2
	ld [wTimerFrames], a
	ret c
	ld hl, wTimerMinutes
	ld a, [hld]
	or [hl]
	jr nz, .asm_86c3
	ld a, $1
	ld [wd57e], a
	ret

.asm_86c3
	ld a, [hl]
	sub $1
	daa
	jr nc, .asm_86cb
	ld a, $59
.asm_86cb
	ld [hli], a
	ld a, [hl]
	sbc $0
	daa
	ld [hl], a
	ret

Func_86d2: ; 0x86d2
	xor a
	ld [wd57d], a
	ret

HandleInGameMenu: ; 0x86d7
; Routine responsible for the "SAVE"/"CANCEL" menu.
	ld a, [wd917]
	push af
	ld a, $1
	ld [wd917], a
	call FillBottomMessageBufferWithBlackTile
	xor a
	ld [wd4aa], a
	ld hl, wBottomMessageText
	ld a, $81
	ld b, $30
.clearLoop
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .clearLoop
	ld de, wBottomMessageText + $24
	ld hl, SaveText
	call Func_8797
	ld de, wBottomMessageText + $64
	ld hl, CancelText
	call Func_8797
	ld a, Bank(InGameMenuSymbolsGfx)
	ld hl, InGameMenuSymbolsGfx
	ld de, vTilesSH + $60
	ld bc, $0010
	call LoadVRAMData
	ld a, $0
	ld hl, wBottomMessageText
	ld de, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ld a, $60
	ld [hWY], a
	dec a
	ld [hLYC], a
	ld a, $fd
	ld [hLCDCMask], a
	call HandleInGameMenuSelection
	ld a, [wInGameMenuIndex]
	and a
	jr nz, .pickedCancel
	ld a, $1
	ld [wd7c2], a
	ld hl, wPartyMons
	ld de, sSaveGame
	ld bc, $04c3
	call SaveData
	xor a
	ld [wd803], a
	ld [wd804], a
.pickedCancel
	ld bc, $003c
	call AdvanceFrames
	ld a, $86
	ld [hWY], a
	ld a, $83
	ld [hLYC], a
	ld [hLastLYC], a
	ld a, $ff
	ld [hLCDCMask], a
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_8778
	ld a, Bank(StageRedFieldTopStatusBarSymbolsGfx_GameBoy)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoy + $60
	ld de, vTilesSH + $60
	ld bc, $0010
	call LoadVRAMData
	jr .asm_8786

.asm_8778
	ld a, Bank(StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor + $60
	ld de, vTilesSH + $60
	ld bc, $0010
	call LoadVRAMData
.asm_8786
	call FillBottomMessageBufferWithBlackTile
	pop af
	ld [wd917], a
	ld a, $1
	ld [wd4aa], a
	ld a, [wInGameMenuIndex]
	and a
	ret

Func_8797: ; 0x8797
	ld a, [hli]
	and a
	ret z
	add $bf
	ld [de], a
	inc de
	jr Func_8797

SaveText: ; 0x87a0
	db "SAVE@"

CancelText: ; 0x87a5
	db "CANCEL@"

HandleInGameMenuSelection: ; 0x87ac
	ld a, $1
	ld [wInGameMenuIndex], a
.waitForAButton
	call MoveInGameMenuCursor
	call DrawInGameMenu
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .waitForAButton
	lb de, $00, $01
	call PlaySoundEffect
	ret

MoveInGameMenuCursor: ; 0x87c5
; Moves the cursor up or down in the "SAVE"/"CANCEL" in-game menu
	ld a, [hNewlyPressedButtons]
	ld b, a
	ld a, [wInGameMenuIndex]
	bit BIT_D_UP, b
	jr z, .didntPressUp
	and a  ; is the cursor already on "SAVE"?
	ret z
	dec a
	ld [wInGameMenuIndex], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

.didntPressUp
	bit BIT_D_DOWN, b
	ret z
	cp $1  ; is the cursor already on "CANCEL"?
	ret z
	inc a
	ld [wInGameMenuIndex], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

DrawInGameMenu: ; 0x87ed
	ld a, $81
	ld [wBottomMessageText + $23], a
	ld [wBottomMessageText + $63], a
	ld a, [wInGameMenuIndex]
	ld c, a
	swap c
	sla c
	sla c
	ld b, $0
	ld hl, wBottomMessageText + $23
	add hl, bc
	ld a, $86
	ld [hl], a
	ld a, $0
	ld hl, wBottomMessageText
	ld de, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

CollisionForceAngles: ; 0x8817
; This data has something to do with collisions.
	db $C0
	db $C5
	db $D0
	db $DB
	db $E0
	db $E5
	db $F0
	db $FB
	db $00
	db $05
	db $10
	db $1B
	db $20
	db $25
	db $30
	db $3B
	db $45
	db $CA
	db $D5
	db $E0
	db $E5
	db $EA
	db $F5
	db $00
	db $05
	db $0A
	db $15
	db $20
	db $25
	db $2A
	db $35
	db $40
	db $50
	db $55
	db $E0
	db $EB
	db $F0
	db $F5
	db $00
	db $0B
	db $10
	db $15
	db $20
	db $2B
	db $30
	db $35
	db $40
	db $4B
	db $5B
	db $60
	db $6B
	db $F6
	db $FB
	db $00
	db $0B
	db $16
	db $1B
	db $20
	db $2B
	db $36
	db $3B
	db $40
	db $4B
	db $56
	db $60
	db $65
	db $70
	db $7B
	db $00
	db $05
	db $10
	db $1B
	db $20
	db $25
	db $30
	db $3B
	db $40
	db $45
	db $50
	db $5B
	db $65
	db $6A
	db $75
	db $80
	db $85
	db $0A
	db $15
	db $20
	db $25
	db $2A
	db $35
	db $40
	db $45
	db $4A
	db $55
	db $60
	db $70
	db $75
	db $80
	db $8B
	db $90
	db $95
	db $20
	db $2B
	db $30
	db $35
	db $40
	db $4B
	db $50
	db $55
	db $60
	db $6B
	db $7B
	db $80
	db $8B
	db $96
	db $9B
	db $A0
	db $AB
	db $36
	db $3B
	db $40
	db $4B
	db $56
	db $5B
	db $60
	db $6B
	db $76
	db $80
	db $85
	db $90
	db $9B
	db $A0
	db $A5
	db $B0
	db $BB
	db $40
	db $45
	db $50
	db $5B
	db $60
	db $65
	db $70
	db $7B
	db $85
	db $8A
	db $95
	db $A0
	db $A5
	db $AA
	db $B5
	db $C0
	db $C5
	db $4A
	db $55
	db $60
	db $65
	db $6A
	db $75
	db $80
	db $90
	db $95
	db $A0
	db $AB
	db $B0
	db $B5
	db $C0
	db $CB
	db $D0
	db $D5
	db $60
	db $6B
	db $70
	db $75
	db $80
	db $8B
	db $9B
	db $A0
	db $AB
	db $B6
	db $BB
	db $C0
	db $CB
	db $D6
	db $DB
	db $E0
	db $EB
	db $76
	db $7B
	db $80
	db $8B
	db $96
	db $A0
	db $A5
	db $B0
	db $BB
	db $C0
	db $C5
	db $D0
	db $DB
	db $E0
	db $E5
	db $F0
	db $FB
	db $80
	db $85
	db $90
	db $9B
	db $A5
	db $AA
	db $B5
	db $C0
	db $C5
	db $CA
	db $D5
	db $E0
	db $E5
	db $EA
	db $F5
	db $00
	db $05
	db $8A
	db $95
	db $A0
	db $B0
	db $B5
	db $C0
	db $CB
	db $D0
	db $D5
	db $E0
	db $EB
	db $F0
	db $F5
	db $00
	db $0B
	db $10
	db $15
	db $A0
	db $AB
	db $BB
	db $C0
	db $CB
	db $D6
	db $DB
	db $E0
	db $EB
	db $F6
	db $FB
	db $00
	db $0B
	db $16
	db $1B
	db $20
	db $2B
	db $B6

CollisionYDeltas: ; 0x8917
; This has to do with y-collision data
	dw $0000
	dw $FFE0
	dw $FF81
	dw $FEDE
	dw $FE77
	dw $FE00
	dw $FCCC
	dw $FB87
	dw $FB01
	dw $FA8E
	dw $F9F8
	dw $FA1F
	dw $FA77
	dw $FAFC
	dw $FCAD
	dw $FEE7
	dw $0119
	dw $FFC2
	dw $FF70
	dw $FEE4
	dw $FE8C
	dw $FE24
	dw $FD15
	dw $FBF9
	dw $FB87
	dw $FB27
	dw $FAB9
	dw $FB03
	dw $FB69
	dw $FBFA
	dw $FDBD
	dw $0000
	dw $0353
	dw $045D
	dw $FF4B
	dw $FF01
	dw $FECC
	dw $FE8A
	dw $FDD5
	dw $FD15
	dw $FCCC
	dw $FC94
	dw $FC77
	dw $FD03
	dw $FD81
	dw $FE24
	dw $0000
	dw $0243
	dw $0504
	dw $05F6
	dw $07B4
	dw $FF08
	dw $FEFB
	dw $FEE2
	dw $FE8A
	dw $FE24
	dw $FE00
	dw $FDEC
	dw $FE10
	dw $FEC9
	dw $FF54
	dw $0000
	dw $01DC
	dw $0406
	dw $0589
	dw $066D
	dw $0808
	dw $08E7
	dw $FF00
	dw $FEFB
	dw $FECC
	dw $FE8C
	dw $FE77
	dw $FE71
	dw $FEAD
	dw $FF73
	dw $0000
	dw $00AC
	dw $027F
	dw $0497
	dw $05E1
	dw $06B6
	dw $082C
	dw $08E1
	dw $08E7
	dw $FF08
	dw $FF01
	dw $FEE4
	dw $FEDE
	dw $FEE3
	dw $FF32
	dw $0000
	dw $008D
	dw $0137
	dw $02FD
	dw $04FD
	dw $0608
	dw $06B8
	dw $07D4
	dw $082C
	dw $0808
	dw $07B4
	dw $FF4B
	dw $FF70
	dw $FF81
	dw $FF99
	dw $0000
	dw $00CE
	dw $0153
	dw $01F0
	dw $0389
	dw $0547
	dw $0572
	dw $05F8
	dw $06B8
	dw $06B6
	dw $066D
	dw $05F6
	dw $045D
	dw $FFC2
	dw $FFE0
	dw $0000
	dw $0067
	dw $011D
	dw $018F
	dw $0214
	dw $036C
	dw $04D9
	dw $04FF
	dw $0572
	dw $0608
	dw $05E1
	dw $0589
	dw $0504
	dw $0353
	dw $0119
	dw $0000
	dw $0020
	dw $007F
	dw $0122
	dw $0189
	dw $0200
	dw $0334
	dw $0479
	dw $0479
	dw $04D9
	dw $0547
	dw $04FD
	dw $0497
	dw $0406
	dw $0243
	dw $0000
	dw $FEE7
	dw $003E
	dw $0090
	dw $011C
	dw $0174
	dw $01DC
	dw $02EB
	dw $0407
	dw $0334
	dw $036C
	dw $0389
	dw $02FD
	dw $027F
	dw $01DC
	dw $0000
	dw $FDBD
	dw $FCAD
	dw $FBA3
	dw $00B5
	dw $00FF
	dw $0134
	dw $0176
	dw $022B
	dw $02EB
	dw $0200
	dw $0214
	dw $01F0
	dw $0137
	dw $00AC
	dw $0000
	dw $FE24
	dw $FBFA
	dw $FAFC
	dw $FA0A
	dw $F84C
	dw $00F8
	dw $0105
	dw $011E
	dw $0176
	dw $01DC
	dw $0189
	dw $018F
	dw $0153
	dw $008D
	dw $0000
	dw $FF54
	dw $FD81
	dw $FB69
	dw $FA77
	dw $F993
	dw $F7F8
	dw $F719
	dw $0100
	dw $0105
	dw $0134
	dw $0174
	dw $0122
	dw $011D
	dw $00CE
	dw $0000
	dw $FF73
	dw $FEC9
	dw $FD03
	dw $FB03
	dw $FA1F
	dw $F94A
	dw $F7D4
	dw $F71F
	dw $F719
	dw $00F8
	dw $00FF
	dw $011C
	dw $007F
	dw $0067
	dw $0000
	dw $FF32
	dw $FEAD
	dw $FE10
	dw $FC77
	dw $FAB9
	dw $F9F8
	dw $F948
	dw $F82C
	dw $F7D4
	dw $F7F8
	dw $F84C
	dw $00B5
	dw $0090
	dw $0020
	dw $0000
	dw $FF99
	dw $FEE3
	dw $FE71
	dw $FDEC
	dw $FC94
	dw $FB27
	dw $FA8E
	dw $FA08
	dw $F948
	dw $F94A
	dw $F993
	dw $FA0A
	dw $FBA3
	dw $003E

CollisionXDeltas: ; 0x8b17
; This data has to do with x-collision data
	dw $FF00
	dw $FEFB
	dw $FECC
	dw $FE8C
	dw $FE77
	dw $FE71
	dw $FEAD
	dw $FF73
	dw $0000
	dw $00AC
	dw $027F
	dw $0497
	dw $0589
	dw $066D
	dw $0808
	dw $08E7
	dw $08E7
	dw $FF08
	dw $FF01
	dw $FEE4
	dw $FEDE
	dw $FEE3
	dw $FF32
	dw $0000
	dw $008D
	dw $0137
	dw $02FD
	dw $04FD
	dw $05E1
	dw $06B6
	dw $082C
	dw $08E1
	dw $0808
	dw $07B4
	dw $FF4B
	dw $FF70
	dw $FF81
	dw $FF99
	dw $0000
	dw $00CE
	dw $0153
	dw $01F0
	dw $0389
	dw $0547
	dw $0608
	dw $06B8
	dw $07D4
	dw $082C
	dw $066D
	dw $05F6
	dw $045D
	dw $FFC2
	dw $FFE0
	dw $0000
	dw $0067
	dw $011D
	dw $018F
	dw $0214
	dw $036C
	dw $04D9
	dw $0572
	dw $05F8
	dw $06B8
	dw $06B6
	dw $0589
	dw $0504
	dw $0353
	dw $0119
	dw $0000
	dw $0020
	dw $007F
	dw $0122
	dw $0189
	dw $0200
	dw $0334
	dw $0479
	dw $04FF
	dw $0572
	dw $0608
	dw $05E1
	dw $0497
	dw $0406
	dw $0243
	dw $0000
	dw $FEE7
	dw $003E
	dw $0090
	dw $011C
	dw $0174
	dw $01DC
	dw $02EB
	dw $0407
	dw $0479
	dw $04D9
	dw $0547
	dw $04FD
	dw $027F
	dw $01DC
	dw $0000
	dw $FDBD
	dw $FCAD
	dw $FBA3
	dw $00B5
	dw $00FF
	dw $0134
	dw $0176
	dw $022B
	dw $02EB
	dw $0334
	dw $036C
	dw $0389
	dw $02FD
	dw $00AC
	dw $0000
	dw $FE24
	dw $FBFA
	dw $FAFC
	dw $FA0A
	dw $F84C
	dw $00F8
	dw $0105
	dw $011E
	dw $0176
	dw $01DC
	dw $0200
	dw $0214
	dw $01F0
	dw $0137
	dw $0000
	dw $FF54
	dw $FD81
	dw $FB69
	dw $FA77
	dw $F993
	dw $F7F8
	dw $F719
	dw $0100
	dw $0105
	dw $0134
	dw $0174
	dw $0189
	dw $018F
	dw $0153
	dw $008D
	dw $FF73
	dw $FEC9
	dw $FD03
	dw $FB03
	dw $FA1F
	dw $F94A
	dw $F7D4
	dw $F71F
	dw $F719
	dw $00F8
	dw $00FF
	dw $011C
	dw $0122
	dw $011D
	dw $00CE
	dw $0000
	dw $FEAD
	dw $FE10
	dw $FC77
	dw $FAB9
	dw $F9F8
	dw $F948
	dw $F82C
	dw $F7D4
	dw $F7F8
	dw $F84C
	dw $00B5
	dw $0090
	dw $007F
	dw $0067
	dw $0000
	dw $FF32
	dw $FE71
	dw $FDEC
	dw $FC94
	dw $FB27
	dw $FA8E
	dw $FA08
	dw $F948
	dw $F94A
	dw $F993
	dw $FA0A
	dw $FBA3
	dw $003E
	dw $0020
	dw $0000
	dw $FF99
	dw $FEE3
	dw $FE77
	dw $FE00
	dw $FCCC
	dw $FB87
	dw $FB01
	dw $FA8E
	dw $F9F8
	dw $FA1F
	dw $FA77
	dw $FAFC
	dw $FCAD
	dw $FEE7
	dw $0000
	dw $FFE0
	dw $FF81
	dw $FEDE
	dw $FE8C
	dw $FE24
	dw $FD15
	dw $FBF9
	dw $FB87
	dw $FB27
	dw $FAB9
	dw $FB03
	dw $FB69
	dw $FBFA
	dw $FDBD
	dw $0000
	dw $0119
	dw $FFC2
	dw $FF70
	dw $FEE4
	dw $FECC
	dw $FE8A
	dw $FDD5
	dw $FD15
	dw $FCCC
	dw $FC94
	dw $FC77
	dw $FD03
	dw $FD81
	dw $FE24
	dw $0000
	dw $0243
	dw $0353
	dw $045D
	dw $FF4B
	dw $FF01
	dw $FEFB
	dw $FEE2
	dw $FE8A
	dw $FE24
	dw $FE00
	dw $FDEC
	dw $FE10
	dw $FEC9
	dw $FF54
	dw $0000
	dw $01DC
	dw $0406
	dw $0504
	dw $05F6
	dw $07B4
	dw $FF08

LoadDexVWFCharacter_: ; 0x8d17
; Loads a single variable-width-font character used in various parts of the Pokedex screen.
	ld a, [$ff92]
	cp $80
	jp c, Func_8e01
	ld a, [$ff90]
	ld c, a
	ld a, [$ff91]
	ld b, a
	ld a, [$ff93]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, [$ff8e]
	cp h
	jr nz, .asm_8d32
	ld a, [$ff8d]
	cp l
.asm_8d32
	jr nc, .asm_8d5c
	ld a, [$ff8d]
	ld [$ff90], a
	ld a, [$ff8e]
	ld [$ff91], a
	ld a, [$ff8d]
	ld c, a
	ld a, [$ff8e]
	ld b, a
	ld a, [$ff8c]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, l
	ld [$ff8d], a
	ld a, h
	ld [$ff8e], a
	srl h
	rr l
	srl h
	rr l
	ld a, [$ff8f]
	cp l
	jp c, Func_8df7
.asm_8d5c
	ld a, [$ff90]
	and $f8
	ld c, a
	ld a, [$ff91]
	ld b, a
	sla c
	rl b
	sla c
	rl b
	ld hl, wc010
	add hl, bc
	ld d, h
	ld e, l
	ld a, [$ff92]
	swap a
	ld c, a
	and $f
	ld b, a
	ld a, c
	and $f0
	ld c, a
	sla c
	rl b
	ld hl, PokedexCharactersGfx
	add hl, bc
	push hl
	ld a, [$ff90]
	and $7
	ld c, a
	ld b, $0
	ld hl, Data_8df9
	add hl, bc
	ld a, [hl]
	ld [wd85e], a
	cpl
	ld [wd85f], a
	ld a, c
	add $58
	ld b, a
	pop hl
	push hl
	ld c, $10
.asm_8da2
	push bc
	ld a, [hli]
	ld c, a
	ld a, [bc]
	ld c, a
	ld a, [wd85e]
	and c
	ld c, a
	ld a, [wd860]
	ld b, a
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	inc hl
	pop bc
	dec c
	jr nz, .asm_8da2
	pop hl
	ld c, $10
.asm_8dc4
	push bc
	ld a, [hli]
	ld c, a
	ld a, [bc]
	ld c, a
	ld a, [wd85f]
	and c
	ld c, a
	ld a, [wd860]
	ld b, a
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	inc hl
	pop bc
	dec c
	jr nz, .asm_8dc4
	ld a, [$ff90]
	ld c, a
	ld a, [$ff91]
	ld b, a
	ld a, [$ff93]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, l
	ld [$ff90], a
	ld a, h
	ld [$ff91], a
	and a
	ret

Func_8df7: ; 0x8df7
	scf
	ret

Data_8df9: ; 0x8df9
	db $FF, $7F, $3F, $1F, $0F, $07, $03, $01

Func_8e01: ; 0x8e01
	ld a, [$ff90]
	ld c, a
	ld a, [$ff91]
	ld b, a
	ld a, [$ff93]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, [$ff8e]
	cp h
	jr nz, .asm_8e15
	ld a, [$ff8d]
	cp l
.asm_8e15
	jr nc, .asm_8e3f
	ld a, [$ff8d]
	ld [$ff90], a
	ld a, [$ff8e]
	ld [$ff91], a
	ld a, [$ff8d]
	ld c, a
	ld a, [$ff8e]
	ld b, a
	ld a, [$ff8c]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, l
	ld [$ff8d], a
	ld a, h
	ld [$ff8e], a
	srl h
	rr l
	srl h
	rr l
	ld a, [$ff8f]
	cp l
	jp c, Func_8ed6
.asm_8e3f
	ld a, [$ff90]
	and $f8
	ld c, a
	ld a, [$ff91]
	ld b, a
	sla c
	rl b
	ld hl, wc010
	add hl, bc
	ld d, h
	ld e, l
	ld a, [$ff92]
	swap a
	ld c, a
	and $f
	ld b, a
	ld a, c
	and $f0
	ld c, a
	sla c
	rl b
	ld hl, PokedexCharactersGfx + $8
	add hl, bc
	push hl
	ld a, [$ff90]
	and $7
	ld c, a
	ld b, $0
	ld hl, Data_8ed8
	add hl, bc
	ld a, [hl]
	ld [wd85e], a
	cpl
	ld [wd85f], a
	ld a, c
	add $58
	ld b, a
	pop hl
	push hl
	ld c, $8
.asm_8e81
	push bc
	ld a, [hli]
	ld c, a
	ld a, [bc]
	ld c, a
	ld a, [wd85e]
	and c
	ld c, a
	ld a, [wd860]
	ld b, a
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	inc hl
	pop bc
	dec c
	jr nz, .asm_8e81
	pop hl
	ld c, $8
.asm_8ea3
	push bc
	ld a, [hli]
	ld c, a
	ld a, [bc]
	ld c, a
	ld a, [wd85f]
	and c
	ld c, a
	ld a, [wd860]
	ld b, a
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	ld a, [de]
	xor b
	or c
	xor b
	ld [de], a
	inc de
	inc hl
	pop bc
	dec c
	jr nz, .asm_8ea3
	ld a, [$ff90]
	ld c, a
	ld a, [$ff91]
	ld b, a
	ld a, [$ff93]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, l
	ld [$ff90], a
	ld a, h
	ld [$ff91], a
	and a
	ret

Func_8ed6: ; 0x8ed6
	scf
	ret

Data_8ed8: ; 0x8ed8
	db $FF, $7F, $3F, $1F, $0F, $07, $03, $01

Func_8ee0: ; 0x8ee0
	ld a, [$ff8d]
	ld [$ff90], a
	ld a, [$ff8e]
	ld [$ff91], a
	ld a, [$ff8d]
	ld c, a
	ld a, [$ff8e]
	ld b, a
	ld a, [$ff8c]
	ld l, a
	ld h, $0
	add hl, bc
	ld a, l
	ld [$ff8d], a
	ld a, h
	ld [$ff8e], a
	srl h
	rr l
	srl h
	rr l
	ld a, [$ff8f]
	cp l
	ret

Data_8f06:

SECTION "bank2.2", ROMX [$5800], BANK[$2]
Data_9800:

macro_9800: MACRO
x = 0
rept \1
y = 0
rept $100 / \1
	db (x + y) & $ff
y = y + \1
endr
x = x + 1
endr
endm

w = $100
rept 8
	macro_9800 w
w = w >> 1
endr

PokedexCharactersGfx: ; 0xa000
	INCBIN "gfx/pokedex/characters.interleave.2bpp"

SECTION "bank3", ROMX, BANK[$3]

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
	call Func_bbe  ; this does the fading
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
	call Func_cb5
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
	call Func_cb5
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
	db SCREEN_FIELD_SELECT, SCREEN_POKEDEX, SCREEN_OPTIONS

GoToHighScoresFromTitlescreen: ; 0xc1e7
	call Func_cb5
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

HandleOptionsScreen: ; 0xc34a
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
OptionsScreenFunctions: ; 0xc34e
	dw Func_c35a
	dw Func_c400
	dw Func_c483
	dw Func_c493
	dw Func_c506
	dw Func_c691

Func_c35a: ; 0xc35a
	ld a, $47
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld [wOBP0], a
	ld a, $d2
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld hl, OptionsScreenVideoDataPointers
	ld a, [hGameBoyColorFlag]
	call LoadVideoData
	call ClearOAMBuffer
	ld a, $2
	ld [wd921], a
	ld [wd91d], a
	ld a, $9
	ld [wd91f], a
	call Func_c43a
	call Func_c948
	call Func_b66
	ld a, $12
	call SetSongBank
	ld de, $0002
	call PlaySong
	call Func_588
	ld a, [wSoundTestCurrentBackgroundMusic]
	hlCoord 7, 11, vBGMap
	call RedrawSoundTestID
	ld a, [wSoundTextCurrentSoundEffect]
	hlCoord 7, 13, vBGMap
	call RedrawSoundTestID
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ret

OptionsScreenVideoDataPointers: ; 0xc3b9
	dw OptionsScreenVideoData_GameBoy
	dw OptionsScreenVideoData_GameBoyColor

OptionsScreenVideoData_GameBoy: ; 0xc3bd
	VIDEO_DATA_TILES   OptionMenuAndKeyConfigGfx, vTilesOB, $1400
	VIDEO_DATA_TILEMAP OptionMenuTilemap,  vBGMap, $240
	VIDEO_DATA_TILEMAP OptionMenuTilemap2, vBGWin, $240
	db $FF, $FF ; terminators

OptionsScreenVideoData_GameBoyColor: ; 0xc3d4
	VIDEO_DATA_TILES         OptionMenuAndKeyConfigGfx, vTilesOB, $1400
	VIDEO_DATA_TILEMAP       OptionMenuTilemap, vBGMap, $240
	VIDEO_DATA_TILEMAP_BANK2 OptionMenuTilemap3, vBGMap, $240
	VIDEO_DATA_TILEMAP       OptionMenuTilemap2, vBGWin, $240
	VIDEO_DATA_TILEMAP_BANK2 OptionMenuTilemap4, vBGWin, $240
	VIDEO_DATA_PALETTES      OptionMenuPalettes, $80
	db $FF, $FF ; terminators

Func_c400: ; 0xc400
	call Func_c41a
	call Func_c43a
	call Func_c447
	ld a, [hNewlyPressedButtons]
	bit 1, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	ld a, $2
	ld [wScreenState], a
	ret

Func_c41a: ; 0xc41a
	ld a, [hPressedButtons]
	ld b, a
	ld a, [wd916]
	bit 6, b
	jr z, .asm_c429
	and a
	ret z
	dec a
	jr .asm_c430

.asm_c429
	bit 7, b
	ret z
	cp $2
	ret z
	inc a
.asm_c430
	ld [wd916], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_c43a: ; 0xc43a
	call Func_c7ac
	call Func_c80b
	call Func_c88a
	call Func_c92e
	ret

Func_c447: ; 0xc447
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	ld a, [wd916]
	and a
	jr nz, .asm_c465
	ld a, [hSGBFlag]
	and a
	ret nz
	call Func_c4f4
	ld a, $3
	ld [wScreenState], a
	ret

.asm_c465
	cp $1
	jr nz, .asm_c477
	call ClearOAMBuffer
	ld hl, hLCDC
	set 3, [hl]
	ld a, $4
	ld [wScreenState], a
	ret

.asm_c477
	ld de, $0000
	call PlaySong
	ld a, $5
	ld [wScreenState], a
	ret

Func_c483: ; 0xc483
	call Func_cb5
	call Func_576
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

Func_c493: ; 0xc493
	call Func_c4b4
	call Func_c4e6
	call Func_c869
	ld a, [hNewlyPressedButtons]
	bit BIT_B_BUTTON, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	xor a
	ld [wd803], a
	ld [wd804], a
	ld a, $1
	ld [wScreenState], a
	ret

Func_c4b4: ; 0xc4b4
	ld a, [hNewlyPressedButtons]
	ld b, a
	ld a, [wd917]
	bit BIT_D_LEFT, b
	jr z, .asm_c4ce
	and a
	ret z
	dec a
	ld [wd917], a
	call Func_c4f4
	lb de, $00, $03
	call PlaySoundEffect
	ret

.asm_c4ce
	bit BIT_D_RIGHT, b
	ret z
	cp $1
	ret z
	inc a
	ld [wd917], a
	xor a
	ld [wd803], a
	ld [wd804], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_c4e6: ; 0xc4e6
	call Func_c7ac
	call Func_c80b
	call Func_c88a
	xor a
	call Func_c8f1
	ret

Func_c4f4: ; 0xc4f4
	xor a
	ld [wd91c], a
	ld [wd91e], a
	ld a, $2
	ld [wd91d], a
	ld a, $9
	ld [wd91f], a
	ret

Func_c506: ; 0xc506
	call Func_c534
	call Func_c554
	call Func_c55a
	ld a, [hNewlyPressedButtons]
	bit BIT_B_BUTTON, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	call ClearOAMBuffer
	ld hl, hLCDC
	res 3, [hl]
	ld hl, wKeyConfigBallStart
	ld de, sKeyConfigs
	ld bc, $000e
	call SaveData
	ld a, $1
	ld [wScreenState], a
	ret

Func_c534: ; 0xc534
	ld a, [hNewlyPressedButtons]
	ld b, a
	ld a, [wd918]
	bit BIT_D_UP, b
	jr z, .asm_c543
	and a
	ret z
	dec a
	jr .asm_c54a

.asm_c543
	bit BIT_D_DOWN, b
	ret z
	cp $7
	ret z
	inc a
.asm_c54a
	ld [wd918], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_c554: ; 0xc554
	ld a, $1
	call Func_c8f1
	ret

Func_c55a: ; 0xc55a
	ld a, [wd918]
	and a
	jr nz, .asm_c572
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	call SaveDefaultKeyConfigs
	call Func_c948
	ret

.asm_c572
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	ld bc, $001e
	call AdvanceFrames
	ld a, [wd918]
	dec a
	sla a
	ld c, a
	ld b, $0
	ld hl, PointerTable_c65f
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd918]
	dec a
	sla a
	call Func_c644
	ld bc, $00ff
.asm_c59f
	push bc
	push hl
	ld a, [wd918]
	dec a
	sla a
	call Func_c621
	call Func_c554
	call CleanOAMBuffer
	rst AdvanceFrame
	pop hl
	pop bc
	ld a, [hJoypadState]
	and a
	jr z, .asm_c5c2
	ld c, $0
	call Func_c9be
	call Func_c95f
	jr .asm_c59f

.asm_c5c2
	or c
	jr nz, .asm_c59f
	ld a, [wd918]
	dec a
	sla a
	call Func_c639
	push hl
	ld bc, $001e
	call AdvanceFrames
	pop hl
	ld bc, $0020
	add hl, bc
	ld a, [wd918]
	dec a
	sla a
	inc a
	call Func_c644
	ld bc, $00ff
	ld d, $5a
.asm_c5e9
	push bc
	push de
	push hl
	ld a, [wd918]
	dec a
	sla a
	inc a
	call Func_c621
	call Func_c554
	call CleanOAMBuffer
	rst AdvanceFrame
	pop hl
	pop de
	pop bc
	dec d
	ret z
	ld a, [hJoypadState]
	and a
	jr z, .asm_c613
	ld d, $ff
	ld c, $0
	call Func_c9be
	call Func_c95f
	jr .asm_c5e9

.asm_c613
	or c
	jr nz, .asm_c5e9
	ld a, [wd918]
	dec a
	sla a
	inc a
	call Func_c639
	ret

Func_c621: ; 0xc621
	sla a
	ld c, a
	ld b, $0
	ld hl, OAMPixelOffsetData_c66d
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [hNumFramesDropped]
	bit 2, a
	ret z
	ld a, $84
	call LoadOAMData
	ret

Func_c639: ; 0xc639
	push hl
	ld e, a
	ld d, $0
	ld hl, wKeyConfigBallStart
	add hl, de
	ld [hl], b
	pop hl
	ret

Func_c644: ; 0xc644
	push hl
	ld c, a
	ld b, $0
	ld hl, wKeyConfigBallStart
	add hl, bc
	ld [hl], $0
	pop hl
	push hl
	ld d, h
	ld e, l
	ld hl, Data_c689
	ld a, Bank(Data_c689)
	ld bc, $0008
	call LoadVRAMData
	pop hl
	ret

PointerTable_c65f: ; 0xc65f
	dw $9C6D
	dw $9CAD
	dw $9CED
	dw $9D2D
	dw $9D6D
	dw $9DAD
	dw $9DED

OAMPixelOffsetData_c66d: ; 0xc66d
	dw $6018
	dw $6020
	dw $6028
	dw $6030
	dw $6038
	dw $6040
	dw $6048
	dw $6050
	dw $6058
	dw $6060
	dw $6068
	dw $6070
	dw $6078
	dw $6080

Data_c689: ; 0xc689
	db $81, $81, $81, $81, $81, $81, $81, $81

Func_c691: ; 0xc91
	call Func_c6bf
	call Func_c6d9
	call Func_c6e8
	ld a, [hNewlyPressedButtons]
	bit BIT_B_BUTTON, a
	ret z
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	rst AdvanceFrame
	rst AdvanceFrame
	ld a, $12
	call SetSongBank
	ld de, $0002
	call PlaySong
	lb de, $00, $01
	call PlaySoundEffect
	ld a, $1
	ld [wScreenState], a
	ret

Func_c6bf: ; 0xc6bf
	ld a, [hNewlyPressedButtons]
	ld b, a
	ld a, [wd919]
	bit BIT_D_UP, b
	jr z, .asm_c6ce
	and a
	ret z
	dec a
	jr .asm_c6d5

.asm_c6ce
	bit BIT_D_DOWN, b
	ret z
	cp $1
	ret z
	inc a
.asm_c6d5
	ld [wd919], a
	ret

Func_c6d9: ; 0xc6d9
	call Func_c7ac
	call Func_c80b
	call Func_c88a
	ld a, $2
	call Func_c8f1
	ret

Func_c6e8: ; 0xc6e8
	ld a, [wd919]
	and a
	jr nz, UpdateSoundTestSoundEffectSelection
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, UpdateSoundTestBackgroundMusicSelection
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	rst AdvanceFrame
	rst AdvanceFrame
	ld a, [wSoundTestCurrentBackgroundMusic]
	sla a
	ld c, a
	ld b, $0
	ld hl, SongBanks
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, $0
	ld a, [hl]
	call SetSongBank
	call PlaySong
	ret

UpdateSoundTestBackgroundMusicSelection: ; 0xc715
	ld a, [hPressedButtons] ; joypad state
	ld b, a
	ld a, [wSoundTestCurrentBackgroundMusic]
	bit BIT_D_LEFT, b  ; was the left dpad button pressed?
	jr z, .checkIfRightPressed
	dec a     ; decrement background music id
	bit 7, a  ; did it wrap around to $ff?
	jr z, .saveBackgroundMusicID
	ld a, NUM_SONGS - 1
	jr .saveBackgroundMusicID

.checkIfRightPressed
	bit BIT_D_RIGHT, b  ; was the right dpad button pressed?
	ret z
	inc a         ; increment background music id
	cp NUM_SONGS  ; should it wrap around to 0?
	jr nz, .saveBackgroundMusicID
	xor a
.saveBackgroundMusicID
	ld [wSoundTestCurrentBackgroundMusic], a
	hlCoord 7, 11, vBGMap
	jp RedrawSoundTestID

UpdateSoundTestSoundEffectSelection: ; 0xc73a
	ld a, [hNewlyPressedButtons] ; joypad state
	bit BIT_A_BUTTON, a
	jr z, .didntPressAButton
	ld a, [wSoundTextCurrentSoundEffect]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

.didntPressAButton
	ld a, [hPressedButtons] ; joypad state
	ld b, a
	ld a, [wSoundTextCurrentSoundEffect]
	bit BIT_D_LEFT, b  ; was the left dpad button pressed?
	jr z, .checkIfRightPressed
	dec a     ; decrement sound effect id
	bit 7, a  ; did it wrap around to $ff?
	jr z, .saveSoundEffectID
	ld a, NUM_SOUND_EFFECTS - 1
	jr .saveSoundEffectID

.checkIfRightPressed
	bit BIT_D_RIGHT, b  ; was the right dpad button pressed?
	ret z
	inc a                  ; increment background music id
	cp NUM_SOUND_EFFECTS   ; should it wrap around to 0?
	jr nz, .saveSoundEffectID
	xor a
.saveSoundEffectID
	ld [wSoundTextCurrentSoundEffect], a
	hlCoord 7, 13, vBGMap
	; fall through

RedrawSoundTestID: ; 0xc76c
; Redraws the 2-digit id number for the sound test's current background music or sound effect id.
; input:  a = id number
;        hl = pointer to bg map location where the new 2-digit id should be drawn
	push af  ; save music or sound effect id number
	swap a
	and $f   ; a contains high nybble of music id
	call .drawDigit
	pop af
	and $f   ; a contains low nybble of music id
.drawDigit
	add $b7  ; hexadecimal digit tiles start at tile number $b7
	call PutTileInVRAM
	inc hl
	ret

SongBanks: ; 0xc77e
	db MUSIC_NOTHING_0F,BANK(Music_Nothing0F)
	db MUSIC_BLUE_FIELD,BANK(Music_BlueField)
	db MUSIC_CATCH_EM_RED,BANK(Music_CatchEmRed)
	db MUSIC_HURRY_UP_RED,BANK(Music_HurryUpRed)
	db MUSIC_POKEDEX,BANK(Music_Pokedex)
	db MUSIC_GASTLY_GRAVEYARD,BANK(Music_GastlyInTheGraveyard)
	db MUSIC_HAUNTER_GRAVEYARD,BANK(Music_HaunterInTheGraveyard)
	db MUSIC_GENGAR_GRAVEYARD,BANK(Music_GengarInTheGraveyard)
	db MUSIC_RED_FIELD,BANK(Music_RedField)
	db MUSIC_CATCH_EM_BLUE,BANK(Music_CatchEmBlue)
	db MUSIC_HURRY_UP_BLUE,BANK(Music_HurryUpBlue)
	db MUSIC_HI_SCORE,BANK(Music_HiScore)
	db MUSIC_GAME_OVER,BANK(Music_GameOver)
	db MUSIC_WHACK_DIGLETT,BANK(Music_WhackTheDiglett)
	db MUSIC_WHACK_DUGTRIO,BANK(Music_WhackTheDugtrio)
	db MUSIC_SEEL_STAGE,BANK(Music_SeelStage)
	db MUSIC_TITLE_SCREEN,BANK(Music_Title)
	db MUSIC_MEWTWO_STAGE,BANK(Music_MewtwoStage)
	db MUSIC_OPTIONS,BANK(Music_Options)
	db MUSIC_FIELD_SELECT,BANK(Music_FieldSelect)
	db MUSIC_MEOWTH_STAGE,BANK(Music_MeowthStage)
	db MUSIC_END_CREDITS,BANK(Music_EndCredits)
	db MUSIC_NAME_ENTRY,BANK(Music_NameEntry)

Func_c7ac: ; 0xc7ac
	ld c, $0
	ld a, [wScreenState]
	cp $1
	jr z, .asm_c7cc
	ld a, [wd916]
	and a
	jr nz, .asm_c7cc
	ld a, [wd917]
	and a
	jr nz, .asm_c7cc
	ld a, [wd91e]
	cp $4
	jr nz, .asm_c7cc
	ld a, [wd91c]
	ld c, a
.asm_c7cc
	sla c
	ld b, $0
	ld hl, Data_c806
	add hl, bc
	ld a, [hl]
	ld bc, $5050
	call LoadOAMData
	ld a, [wd91d]
	dec a
	jr nz, .asm_c802
	ld a, [wd91c]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c806 + 2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_c7f5
	ld a, [wd91c]
	inc a
.asm_c7f5
	ld [wd91c], a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c806 + 1
	add hl, bc
	ld a, [hl]
.asm_c802
	ld [wd91d], a
	ret

Data_c806: ; 0xc806
	db $7B, $02, $7C, $02, $00

Func_c80b: ; 0xc80b
	ld c, $0
	ld a, [wScreenState]
	cp $1
	jr z, .asm_c824
	ld a, [wd916]
	and a
	jr nz, .asm_c824
	ld a, [wd917]
	and a
	jr nz, .asm_c824
	ld a, [wd91e]
	ld c, a
.asm_c824
	sla c
	ld b, $0
	ld hl, Data_c85e
	add hl, bc
	ld bc, $7870
	ld a, [hl]
	call LoadOAMData
	ld a, [wd91f]
	dec a
	jr nz, .asm_c85a
	ld a, [wd91e]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c85e + 2
	add hl, bc
	ld a, [hl]
	and a
	ld a, [wd91e]
	jr z, .asm_c850
	inc a
	ld [wd91e], a
.asm_c850
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c85e + 1
	add hl, bc
	ld a, [hl]
.asm_c85a
	ld [wd91f], a
	ret

Data_c85e: ; 0xc85e
	db $77, $09, $78, $09, $79, $09, $7A, $0D, $7A, $01, $00

Func_c869: ; 0xc869
	ld a, [wd916]
	and a
	ret nz
	ld a, [wd917]
	and a
	ret nz
	ld a, [wd91e]
	cp $3
	ret nz
	ld a, [wd91f]
	cp $1
	ret nz
	ld a, $55
	ld [wd803], a
	ld a, $40
	ld [wd804], a
	ret

Func_c88a: ; 0xc88a
	ld a, [wd916]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c8eb
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld e, $0
	ld a, [wScreenState]
	cp $1
	jr nz, .asm_c8a9
	ld a, [wd920]
	sla a
	ld e, a
.asm_c8a9
	ld d, $0
	ld hl, Data_c8de
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ld a, [wd921]
	dec a
	jr nz, .asm_c8da
	ld a, [wd920]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c8de + 2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_c8cd
	ld a, [wd920]
	inc a
.asm_c8cd
	ld [wd920], a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_c8de + 1
	add hl, bc
	ld a, [hl]
.asm_c8da
	ld [wd921], a
	ret

Data_c8de: ; 0xc8de
	db $7D, $02, $7E, $06, $7F, $02, $80, $04, $81, $06, $7F, $04, $00

Data_c8eb: ; 0xc8eb
	db $18, $08, $30, $08, $48, $08

Func_c8f1: ; 0xc8f1
	ld c, a
	ld b, $0
	ld hl, wd917
	add hl, bc
	ld e, [hl]
	sla c
	ld hl, PointerTable_c910
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, e
	sla c
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, $82
	call LoadOAMData
	ret

PointerTable_c910: ; 0xc910
	dw OAMPixelOffsetData_c916
	dw OAMPixelOffsetData_c91a
	dw OAMPixelOffsetData_c92a

OAMPixelOffsetData_c916: ; 0xc916
	dw $5018
	dw $7018

OAMPixelOffsetData_c91a: ; 0xc91a
	dw $0808
	dw $0818
	dw $0828
	dw $0838
	dw $0848
	dw $0858
	dw $0868
	dw $0878

OAMPixelOffsetData_c92a: ; 0xc92a
	dw $1058
	dw $1068

Func_c92e: ; 0xc92e
	ld a, [wd917]
	sla a
	ld c, a
	ld b, $0
	ld hl, OAMPixelOffsetData_c944
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $85
	call LoadOAMData
	ret

OAMPixelOffsetData_c944: ; 0xc944
	dw $5018
	dw $7018

Func_c948: ; 0xc948
	hlCoord 13, 3, vBGWin
	ld de, wKeyConfigBallStart
	ld b, $e
.asm_c950
	push bc
	ld a, [de]
	call Func_c95f
	inc de
	ld bc, $0020
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_c950
	ret

Func_c95f: ; 0xc95f
	push bc
	push de
	push hl
	push hl
	push af
	ld hl, wd922
	ld a, $81
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop af
	ld hl, wd922
	ld de, Data_c9ae
	ld b, $8
.asm_c979
	srl a
	push af
	jr nc, .asm_c994
	ld a, [de]
	inc de
	call Func_c9aa
	ld a, [de]
	inc de
	call Func_c9aa
	pop af
	push af
	and a
	jr z, .asm_c996
	ld a, $1a
	call Func_c9aa
	jr .asm_c996

.asm_c994
	inc de
	inc de
.asm_c996
	pop af
	dec b
	jr nz, .asm_c979
	pop de
	ld hl, wd922
	ld a, $0
	ld bc, $0008
	call LoadOrCopyVRAMData
	pop hl
	pop de
	pop bc
	ret

Func_c9aa: ; 0xc9aa
	and a
	ret z
	ld [hli], a
	ret

Data_c9ae: ; 0xc9ae
	db $14, $00, $15, $00, $18, $19, $16, $17, $13, $00, $12, $00, $10, $00, $11, $00

Func_c9be: ; 0xc9be
	push af
	push bc
	push hl
	ld c, a
	xor b
	and c
	ld hl, wd936
	call Func_c9ff
	ld a, b
	ld hl, wd93f
	call Func_c9ff
	ld a, [wd947]
	cp $3
	jr nc, .asm_c9f3
	ld hl, wd93e
	add [hl]
	sub $4
	ld hl, wd936
	call nc, Func_ca15
	ld de, wd936
	ld hl, wd93f
	ld b, $8
.asm_c9ec
	ld a, [de]
	or [hl]
	ld [hli], a
	inc de
	dec b
	jr nz, .asm_c9ec
.asm_c9f3
	ld hl, wd93f
	call Func_ca29
	pop hl
	pop bc
	ld b, a
	pop af
	ld a, b
	ret

Func_c9ff: ; 0xc9ff
	push bc
	ld bc, $0800
.asm_ca03
	sla a
	jr nc, .asm_ca0c
	ld [hl], $ff
	inc c
	jr .asm_ca0e

.asm_ca0c
	ld [hl], $0
.asm_ca0e
	inc hl
	dec b
	jr nz, .asm_ca03
	ld [hl], c
	pop bc
	ret

Func_ca15: ; 0xca15
	push bc
	inc a
	ld c, a
	ld b, $8
.asm_ca1a
	ld a, [hl]
	and a
	jr z, .asm_ca23
	ld [hl], $0
	dec c
	jr z, .asm_ca27
.asm_ca23
	inc hl
	dec b
	jr nz, .asm_ca1a
.asm_ca27
	pop bc
	ret

Func_ca29: ; 0ca29
	push bc
	ld bc, $0800
.asm_ca2d
	ld a, [hli]
	and a
	jr z, .asm_ca32
	scf
.asm_ca32
	rl c
	dec b
	jr nz, .asm_ca2d
	ld a, c
	pop bc
	ret

SaveDefaultKeyConfigs: ; 0ca3a
	ld hl, DefaultKeyConfigs
	ld de, wKeyConfigs
	ld b, $e
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld hl, wKeyConfigs
	ld de, sKeyConfigs
	ld bc, $000e
	call SaveData
	ret

DefaultKeyConfigs: ; 0xca55
	db A_BUTTON, $00  ; wKeyConfigBallStart
	db D_LEFT,   $00  ; wKeyConfigLeftFlipper
	db A_BUTTON, $00  ; wKeyConfigRightFlipper
	db D_DOWN,   $00  ; wKeyConfigLeftTilt
	db B_BUTTON, $00  ; wKeyConfigRightTilt
	db SELECT,   $00  ; wKeyConfigUpperTilt
	db START,    $00  ; wKeyConfigMenu

Data_ca63:
	db A_BUTTON,       $00  ; wKeyConfigBallStart
	db D_LEFT,         $00  ; wKeyConfigLeftFlipper
	db A_BUTTON,       $00  ; wKeyConfigRightFlipper
	db D_DOWN,         $00  ; wKeyConfigLeftTilt
	db B_BUTTON,       $00  ; wKeyConfigRightTilt
	db START,          $04  ; wKeyConfigUpperTilt
	db D_UP | D_RIGHT, $00  ; wKeyConfigMenu

Data_ca71:
	db A_BUTTON,              $00  ; wKeyConfigBallStart
	db D_LEFT,                $00  ; wKeyConfigLeftFlipper
	db A_BUTTON,              $00  ; wKeyConfigRightFlipper
	db D_DOWN,                $00  ; wKeyConfigLeftTilt
	db B_BUTTON,              $00  ; wKeyConfigRightTilt
	db START,                 $00  ; wKeyConfigUpperTilt
	db D_UP | START | SELECT, $00  ; wKeyConfigMenu

HandleHighScoresScreen: ; 0xca7f
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
HighScoresScreenFunctions: ; 0xca83
	dw Func_ca8f
	dw Func_cb14
	dw Func_ccac
	dw Func_ccb6
	dw Func_cd6c
	dw ExitHighScoresScreen

Func_ca8f: ; 0xca8f
	ld hl, wd473
	call GenRandom
	ld [hli], a
	call GenRandom
	ld [hli], a
	call GenRandom
	ld [hli], a
	call GenRandom
	ld [hli], a
	ld hl, wRedHighScore5Points + $5
	ld a, [wHighScoresStage]
	and a
	jr z, .asm_caae
	ld hl, wBlueHighScore5Points + $5
.asm_caae
	ld b, $5
.asm_cab0
	ld de, wScore + $5
	ld c, $6
.asm_cab5
	ld a, [de]
	cp [hl]
	jr c, .asm_cad0
	jr nz, .asm_cac2
	dec de
	dec hl
	dec c
	jr nz, .asm_cab5
	jr .asm_cad0

.asm_cac2
	dec hl
	dec c
	jr nz, .asm_cac2
	ld a, l
	sub $7
	ld l, a
	jr nc, .asm_cacd
	dec h
.asm_cacd
	dec b
	jr nz, .asm_cab0
.asm_cad0
	ld a, b
	ld [wda81], a
	xor a
	ld [wda80], a
	inc b
	ld hl, wRedHighScore4Unknown0x09 + 3
	ld de, wRedHighScore5Unknown0x09 + 3
	ld a, [wHighScoresStage]
	and a
	jr z, .asm_caeb
	ld hl, wBlueHighScore4Unknown0x09 + 3
	ld de, wBlueHighScore5Unknown0x09 + 3
.asm_caeb
	ld a, $5
.asm_caed
	cp b
	jr c, .asm_cb02
	push af
	jr nz, .asm_caf6
	ld hl, wd473 + $3
.asm_caf6
	ld c, $d
.asm_caf8
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .asm_caf8
	pop af
	dec a
	jr nz, .asm_caed
.asm_cb02
	ld a, [wda81]
	cp $5
	ld a, $1
	jr nz, .asm_cb0c
	xor a
.asm_cb0c
	ld [wda7f], a
	ld hl, wScreenState
	inc [hl]
	ret

Func_cb14: ; 0xcb14
	ld a, $43
	ld [hLCDC], a
	ld a, $e0
	ld [wBGP], a
	ld a, $e1
	ld [wOBP0], a
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld [hNextFrameHBlankSCX], a
	ld [hSCY], a
	ld [hNextFrameHBlankSCY], a
	ld a, $e
	ld [hLYC], a
	ld [hLastLYC], a
	ld a, $82
	ld [hNextLYCSub], a
	ld [hLYCSub], a
	ld hl, hSTAT
	set 6, [hl]
	ld hl, rIE
	set 1, [hl]
	ld a, $3
	ld [hHBlankRoutine], a
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_cb51
	ld a, [wHighScoresStage]
	inc a
.asm_cb51
	ld hl, HighScoresVideoDataPointers
	call LoadVideoData
	call ClearOAMBuffer
	ld a, $20
	ld [wda82], a
	call Func_d211
	hlCoord 0, 14, vBGMap
	ld de, wRedHighScore5Unknown0x09 + $3
	call Func_d2cb
	hlCoord 0, 14, vBGWin
	ld de, wBlueHighScore5Unknown0x09 + $3
	call Func_d2cb
	ld a, [wHighScoresStage]
	and a
	jr z, .asm_cb7f
	ld hl, hLCDC
	set 3, [hl]
.asm_cb7f
	call Func_b66
	ld a, [wda7f]
	and a
	jr z, .asm_cbbd
	ld a, [wda81]
	and a
	jr nz, .asm_cb9b
	ld a, $13
	call SetSongBank
	ld de, $0001
	call PlaySong
	jr .asm_cba6

.asm_cb9b
	ld a, $13
	call SetSongBank
	ld de, $0002
	call PlaySong
.asm_cba6
	call Func_588
	ld bc, $0009
	call Func_d68a
	ld bc, $03c9
	call Func_d68a
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ret

.asm_cbbd
	ld a, $10
	call SetSongBank
	ld de, $0004
	call PlaySong
	call Func_588
	ld bc, $0009
	call Func_d68a
	ld bc, $03c9
	call Func_d68a
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ld hl, wScreenState
	inc [hl]
	ret

HighScoresVideoDataPointers: ; 0xcbe3
	dw HighScoresVideoData_GameBoy
	dw HighScoresRedStageVideoData_GameBoyColor
	dw HighScoresBlueStageVideoData_GameBoyColor

HighScoresVideoData_GameBoy: ; 0xcbe9
	VIDEO_DATA_TILES HighScoresBaseGameBoyGfx, vTilesOB, $1800
	VIDEO_DATA_TILEMAP HighScoresTilemap, vBGMap, $400
	VIDEO_DATA_TILEMAP HighScoresTilemap2, vBGWin, $400
	dw HighScoresTilemap + $3c0
	db Bank(HighScoresTilemap)
	dw vBGMap
	dw ($40 << 2)
	dw HighScoresTilemap + $280
	db Bank(HighScoresTilemap)
	dw vBGMap + $200
	dw ($40 << 2)
	dw HighScoresTilemap2 + $3c0
	db Bank(HighScoresTilemap2)
	dw vBGWin
	dw ($40 << 2)
	dw HighScoresTilemap2 + $280
	db Bank(HighScoresTilemap2)
	dw vBGWin + $200
	dw ($40 << 2)
	db $FF, $FF  ; terminators

HighScoresRedStageVideoData_GameBoyColor: ; 0xcc1c
	VIDEO_DATA_TILES HighScoresBaseGameBoyGfx, vTilesOB, $1800
	VIDEO_DATA_TILEMAP HighScoresTilemap, vBGMap, $400
	VIDEO_DATA_TILEMAP HighScoresTilemap2, vBGWin, $400
	VIDEO_DATA_TILEMAP_BANK2 HighScoresTilemap4, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 HighScoresTilemap5, vBGWin, $400
	dw HighScoresTilemap + $3c0
	db Bank(HighScoresTilemap)
	dw vBGMap
	dw ($40 << 2)
	dw HighScoresTilemap + $280
	db Bank(HighScoresTilemap)
	dw vBGMap + $200
	dw ($40 << 2)
	dw HighScoresTilemap2 + $3c0
	db Bank(HighScoresTilemap2)
	dw vBGWin
	dw ($40 << 2)
	dw HighScoresTilemap2 + $280
	db Bank(HighScoresTilemap2)
	dw vBGWin + $200
	dw ($40 << 2)
	VIDEO_DATA_PALETTES HighScoresRedStagePalettes, $80
	db $FF, $FF

HighScoresBlueStageVideoData_GameBoyColor: ; 0xcc64
	VIDEO_DATA_TILES HighScoresBaseGameBoyGfx, vTilesOB, $1800
	VIDEO_DATA_TILEMAP HighScoresTilemap, vBGMap, $400
	VIDEO_DATA_TILEMAP HighScoresTilemap2, vBGWin, $400
	VIDEO_DATA_TILEMAP_BANK2 HighScoresTilemap4, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 HighScoresTilemap5, vBGWin, $400
	dw HighScoresTilemap + $3c0
	db Bank(HighScoresTilemap)
	dw vBGMap
	dw ($40 << 2)
	dw HighScoresTilemap + $280
	db Bank(HighScoresTilemap)
	dw vBGMap + $200
	dw ($40 << 2)
	dw HighScoresTilemap2 + $3c0
	db Bank(HighScoresTilemap2)
	dw vBGWin
	dw ($40 << 2)
	dw HighScoresTilemap2 + $280
	db Bank(HighScoresTilemap2)
	dw vBGWin + $200
	dw ($40 << 2)
	VIDEO_DATA_PALETTES HighScoresBlueStagePalettes, $80
	db $FF, $FF  ; terminators

Func_ccac: ; 0xccac
	call Func_d18b
	call Func_d1d2
	call Func_d211
	ret

Func_ccb6: ; 0xccb6
	call Func_d4cf
	call AnimateHighScoresArrow
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_ccd1
	lb de, $00, $01
	call PlaySoundEffect
	ld hl, wScreenState
	inc [hl]
	ld hl, wScreenState
	inc [hl]
	ret

.asm_ccd1
	bit 1, a
	jr z, .asm_cce4
	lb de, $00, $01
	call PlaySoundEffect
	ld hl, wScreenState
	inc [hl]
	ld hl, wScreenState
	inc [hl]
	ret

.asm_cce4
	bit 3, a
	jr z, .asm_ccfb
	call Func_1a43
	ld a, [hGameBoyColorFlag]
	ld [wd8f0], a
	lb de, $00, $01
	call PlaySoundEffect
	ld hl, wScreenState
	inc [hl]
	ret

.asm_ccfb
	ld a, [hJoypadState]
	cp (SELECT | D_UP)
	ret nz
	ld a, [hNewlyPressedButtons]
	and (SELECT | D_UP)
	ret z
	lb de, $00, $01
	call PlaySoundEffect
	call ClearOAMBuffer
	ld bc, $473b
	ld a, $94
	call LoadOAMData
.asm_cd16
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_B_BUTTON, a
	jr z, .asm_cd24
	lb de, $00, $01
	call PlaySoundEffect
	ret

.asm_cd24
	bit 0, a
	jr z, .asm_cd16
	lb de, $00, $01
	call PlaySoundEffect
	call CopyInitialHighScores
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap + $40
	deCoord 0, 2, vBGMap
	ld bc, $01c0
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2 + $40
	deCoord 0, 2, vBGWin
	ld bc, $01c0
	call LoadVRAMData
	hlCoord 0, 14, vBGMap
	ld de, wRedHighScore5Unknown0x09 + $3
	call Func_d361
	hlCoord 0, 14, vBGWin
	ld de, wBlueHighScore5Unknown0x09 + $3
	call Func_d361
	ld hl, wRedHighScore1Points
	ld de, $a000
	ld bc, $0082
	call SaveData
	ret

Func_cd6c: ; 0xcd6c
	ld a, [hNumFramesDropped]
	and $1f
	call z, Func_1a43
	call Func_cf7d
	call Func_cfa6
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_cdbb
	lb de, $00, $01
	call PlaySoundEffect
	ld a, [wda85]
	and a
	jr nz, .asm_cda1
	ld a, [wd86e]
	and a
	jr z, .asm_cdbb
	call ClearOAMBuffer
	ld bc, $473b
	ld a, $8e
	call LoadOAMData
	call Func_d042
	jr .asm_cdc6

.asm_cda1
	ld a, [wd8f0]
	and a
	jr z, .asm_cdbb
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	call Func_cdce
	push af
	ld de, $0004
	call PlaySong
	pop af
	jr nc, .asm_cdc6
.asm_cdbb
	ld a, [hNewlyPressedButtons]
	bit BIT_B_BUTTON, a
	ret z
	lb de, $00, $01
	call PlaySoundEffect
.asm_cdc6
	xor a
	ld [rRP], a
	ld hl, wScreenState
	dec [hl]
	ret

Func_cdce: ; 0xcdce
	push af
	ld a, $0
	ld [$abf6], a
	pop af
	call ClearOAMBuffer
	call Func_1be3
	call SendHighScores
	push af
	ld a, $1
	ld [$abf6], a
	pop af
	di
	ld a, [wd8ea]
	cp $0
	jp nz, .asm_ceb6
	ld a, [wd8e9]
	cp $1
	jr z, .asm_ce23
	push af
	ld a, $2
	ld [$abf6], a
	pop af
	ld b, $82
	ld hl, wRedHighScore1Points
	call Func_1cf8
	ld a, [wd8ea]
	cp $0
	jp nz, .asm_ceb6
	push af
	ld a, $3
	ld [$abf6], a
	pop af
	ld hl, wc4c0
	call Func_1dda
	ld a, [wd8ea]
	cp $0
	jp nz, .asm_ceb6
	jr .asm_ce4d

.asm_ce23
	push af
	ld a, $4
	ld [$abf6], a
	pop af
	ld hl, wc4c0
	call Func_1dda
	ld a, [wd8ea]
	cp $0
	jr nz, .asm_ceb6
	push af
	ld a, $5
	ld [$abf6], a
	pop af
	ld b, $82
	ld hl, wRedHighScore1Points
	call Func_1cf8
	ld a, [wd8ea]
	cp $0
	jr nz, .asm_ceb6
.asm_ce4d
	push af
	ld a, $6
	ld [$abf6], a
	pop af
	call Func_ceca
	rst AdvanceFrame
	ld hl, wc4cc
	ld b, $5
.asm_ce5d
	push bc
	push hl
	ld d, h
	ld e, l
	ld hl, wRedHighScore5Unknown0x09 + $3
	call Func_cfcb
	pop hl
	pop bc
	ld de, $000d
	add hl, de
	dec b
	jr nz, .asm_ce5d
	push af
	ld a, $7
	ld [$abf6], a
	pop af
	ld hl, wBottomMessageText + $0d
	ld b, $5
.asm_ce7c
	push bc
	push hl
	ld d, h
	ld e, l
	ld hl, wBlueHighScore5Unknown0x09 + $3
	call Func_cfcb
	pop hl
	pop bc
	ld de, $000d
	add hl, de
	dec b
	jr nz, .asm_ce7c
	push af
	ld a, $8
	ld [$abf6], a
	pop af
	hlCoord 0, 14, vBGMap
	ld de, wRedHighScore5Unknown0x09 + $3
	call Func_d361
	hlCoord 0, 14, vBGWin
	ld de, wBlueHighScore5Unknown0x09 + $3
	call Func_d361
	ld hl, wRedHighScore1Points
	ld de, $a000
	ld bc, $0082
	call SaveData
	and a
	ret

.asm_ceb6
	push af
	ld a, $9
	ld [$abf6], a
	pop af
	call Func_ceca
	rst AdvanceFrame
	push af
	ld a, $a
	ld [$abf6], a
	pop af
	scf
	ret

Func_ceca: ; 0xceca
	ld a, [rLY]
	and a
	jr nz, Func_ceca
	ei
	ret

SendHighScores: ; 0xced1
; Sends high scores, and plays the animation for sending the high scores.
	ld hl, SendHighScoresAnimationData
	ld de, wSendHighScoresAnimationFrameCounter
	call CopyHLToDE
	ld bc, $4800
	ld a, [wSendHighScoresAnimationFrame]
	call LoadOAMData
	ld bc, $473b
	ld a, $8f
	call LoadOAMData
	call CleanOAMBuffer
	rst AdvanceFrame
	ld a, $1
	ld [wd8e9], a
	ld b, $b4  ; maximum attempts to send high scores
.attemptToSendHighScoresLoop
	push bc
	xor a
	ld [hNumFramesSinceLastVBlank], a
.asm_cefa
	ld b, $2
	ld c, $56
	ld a, [$ff00+c]
	and b
	jr z, .asm_cf09
	ld a, [hNumFramesSinceLastVBlank]
	and a
	jr z, .asm_cefa
	jr .asm_cf0e

.asm_cf09
	call Func_1c50
	jr .continueAttempts

.asm_cf0e
	ld hl, SendHighScoresAnimationData
	ld de, wSendHighScoresAnimationFrameCounter
	call UpdateAnimation
	jr nc, .continueAttempts
	ld bc, $4800
	ld a, [wSendHighScoresAnimationFrame]
	call LoadOAMData
	ld bc, $473b
	ld a, $8f
	call LoadOAMData
	call CleanOAMBuffer
	call Func_1ca1
	ld a, [wSendHighScoresAnimationFrameIndex]
	cp $6
	jr nz, .continueAttempts
	ld hl, SendHighScoresAnimationData
	ld de, wSendHighScoresAnimationFrameCounter
	call CopyHLToDE
.continueAttempts
	pop bc
	ld a, [wd8ea]
	cp $0
	ret z
	dec b
	jr nz, .attemptToSendHighScoresLoop
	ret

SendHighScoresAnimationData: ; 0xcf4b
; Each entry is [OAM id][duration]
	db $0C, $98
	db $06, $99
	db $0A, $9A
	db $0C, $9B
	db $0A, $9C
	db $06, $9D
	db $00  ; terminator

Func_cf58: ; 0xcf58
	cp $5
	ret z
	push af
	lb de, $00, $02
	call PlaySoundEffect
	call ClearOAMBuffer
	rst AdvanceFrame
	pop af
	ld bc, $473b
	add $8f
	call LoadOAMData
.asm_cf6f
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_cf6f
	lb de, $00, $01
	call PlaySoundEffect
	ret

Func_cf7d: ; 0xcf7d
	ld a, [wd809]
	ld b, a
	ld a, [wda85]
	bit 6, b
	jr z, .asm_cf95
	and a
	ret z
	dec a
	ld [wda85], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

.asm_cf95
	bit 7, b
	ret z
	cp $1
	ret z
	inc a
	ld [wda85], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_cfa6: ; 0xcfa6
	ld bc, $473b
	ld a, $87
	call LoadOAMData
	ld a, [wd8f0]
	and a
	jr z, .asm_cfb6
	ld a, $2
.asm_cfb6
	ld e, a
	ld a, [wd86e]
	add e
	xor $3
	add $8a
	call LoadOAMData
	ld a, [wda85]
	add $88
	call LoadOAMData
	ret

Func_cfcb: ; 0xcfcb
	ld a, e
	ld [$ff8c], a
	ld a, d
	ld [$ff8d], a
	push hl
	ld b, $5
.asm_cfd4
	ld a, [$ff8c]
	ld e, a
	ld a, [$ff8d]
	ld d, a
	call Func_d005
	call Func_d017
	jr c, .asm_cfe5
	dec b
	jr nz, .asm_cfd4
.asm_cfe5
	inc b
	pop de
	ld hl, $fff3
	add hl, de
	ld a, $5
.asm_cfed
	cp b
	ret c
	push af
	jr nz, .asm_cff8
	ld a, [$ff8c]
	ld l, a
	ld a, [$ff8d]
	ld h, a
.asm_cff8
	ld c, $d
.asm_cffa
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .asm_cffa
	pop af
	dec a
	jr nz, .asm_cfed
	ret

Func_d005: ; 0xd005
	ld c, $7
.asm_d007
	ld a, [de]
	cp [hl]
	jr nz, .asm_d010
	dec de
	dec hl
	dec c
	jr nz, .asm_d007
.asm_d010
	ld a, c
	ld [$ff8e], a
	call Func_d035
	ret

Func_d017: ; 0xd017
	ld c, $6
.asm_d019
	ld a, [de]
	cp [hl]
	jr c, .asm_d02b
	jr nz, .asm_d030
	dec de
	dec hl
	dec c
	jr nz, .asm_d019
	ld a, [$ff8e]
	and a
	jr nz, .asm_d02b
	ld b, $5
.asm_d02b
	call Func_d035
	scf
	ret

.asm_d030
	call Func_d035
	and a
	ret

Func_d035: ; 0xd035
	ld a, e
	sub c
	ld e, a
	jr nc, .asm_d03b
	dec d
.asm_d03b
	ld a, l
	sub c
	ld l, a
	jr nc, .asm_d041
	dec h
.asm_d041
	ret

Func_d042: ; 0xd042
	ld a, [hJoypadState]
	ld [wda86], a
	ld b, a
	ld a, $80
	bit BIT_D_LEFT, b
	jr z, .asm_d052
	ld a, $7f
	jr .asm_d058

.asm_d052
	bit BIT_D_RIGHT, b
	jr z, .asm_d058
	ld a, $10
.asm_d058
	ld [wd8a7], a
	ld a, $e0
	ld [wd8aa], a
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap + $3c0
	ld de, wc280
	ld bc, $0040
	call FarCopyData
	ld a, $0
	hlCoord 0, 2, vBGMap
	ld de, wc2c0
	ld bc, $01c0
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap + $280
	ld de, wc480
	ld bc, $0040
	call FarCopyData
	call Func_d6b6
	call Func_d0e3
	ret c
	ld a, [wda86]
	bit 2, a
	jr z, .asm_d0a2
	ld de, wRedHighScore1Unknown0x09
	call Func_d107
	call Func_d0f5
	ret c
.asm_d0a2
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2 + $3c0
	ld de, wc280
	ld bc, $0040
	call FarCopyData
	ld a, $0
	hlCoord 0, 2, vBGWin
	ld de, wc2c0
	ld bc, $01c0
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2 + $280
	ld de, wc480
	ld bc, $0040
	call FarCopyData
	call Func_d6b6
	call Func_d0e3
	ret c
	ld a, [wda86]
	bit 2, a
	ret z
	ld de, wBlueHighScore1Unknown0x09
	call Func_d107
	call Func_d0f5
	ret

Func_d0e3: ; 0xd0e3
	ld a, BANK(HighScoresBaseGameBoyGfx)
	ld hl, HighScoresBaseGameBoyGfx + $800
	call Func_1a21
	ld a, [wd86d]
	and a
	ret z
	call Func_cf58
	scf
	ret

Func_d0f5: ; 0xd0f5
	ld a, BANK(GFX_a7b00)
	ld hl, GFX_a7b00
	call Func_1a21
	ld a, [wd86d]
	and a
	ret z
	call Func_cf58
	scf
	ret

Func_d107: ; 0xd107
	ld hl, wc280
	ld a, $c0
	ld b, $20
.clear
rept 32
	ld [hli], a
endr
	dec b
	jr nz, .clear
	ld hl, wc280
	ld b, $5
.loop
	ld c, $4
.inner
	ld a, [de]
	swap a
	call Func_d159
	ld a, [de]
	call Func_d159
	inc de
	inc hl
	dec c
	jr nz, .inner
	ld a, l
	add $4c
	ld l, a
	jr nc, .no_carry_1
	inc h
.no_carry_1
	ld a, e
	add $9
	ld e, a
	jr nc, .no_carry_2
	inc d
.no_carry_2
	dec b
	jr nz, .loop
	ret

Func_d159: ; 0xd159
	and $f
	sla a
	sla a
	xor $80
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	push bc
	push hl
	ld bc, $001e
	add hl, bc
	ld [hli], a
	inc a
	ld [hli], a
	pop hl
	pop bc
	ret

ExitHighScoresScreen: ; 0xd171
	call Func_cb5
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

Func_d18b: ; 0xd18b
	ld a, [hPressedButtons]
	ld b, a
	ld a, [wda81]
	ld e, a
	sla e
	sla e
	add e
	sla e
	add e
	ld e, a
	ld a, [wda80]
	add e
	ld e, a
	ld d, $0
	ld hl, wRedHighScore1Name
	ld a, [wHighScoresStage]
	and a
	jr z, .asm_d1ae
	ld hl, wBlueHighScore1Name
.asm_d1ae
	add hl, de
	ld a, [hl]
	bit 4, b
	jr z, .asm_d1bd
	inc a
	cp $38
	jr nz, .asm_d1c7
	ld a, $a
	jr .asm_d1c7

.asm_d1bd
	bit 5, b
	ret z
	dec a
	cp $9
	jr nz, .asm_d1c7
	ld a, $37
.asm_d1c7
	ld [hl], a
	call Func_d46f
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_d1d2: ; 0xd1d2
	ld a, [hNewlyPressedButtons]
	ld b, a
	ld a, [wda80]
	bit BIT_A_BUTTON, b
	jr z, .asm_d1fc
	inc a
	cp $3
	jr nz, .asm_d202
	lb de, $07, $45
	call PlaySoundEffect
	xor a
	ld [wda7f], a
	ld hl, wScreenState
	inc [hl]
	ld hl, wRedHighScore1Points
	ld de, $a000
	ld bc, $0082
	call SaveData
	ret

.asm_d1fc
	bit 1, b
	ret z
	and a
	ret z
	dec a
.asm_d202
	ld [wda80], a
	ld a, $20
	ld [wda82], a
	lb de, $00, $01
	call PlaySoundEffect
	ret

Func_d211: ; 0xd211
; related to high scores name entry?
	ld a, [wda7f]
	and a
	ret z
	ld a, [hJoypadState]
	and (D_RIGHT | D_LEFT)
	jr z, .asm_d221
	xor a
	ld [wda82], a
	ret

.asm_d221
	ld a, [wda82]
	inc a
	ld [wda82], a
	bit 5, a
	ret z
	ld a, [wda81]
	ld e, a
	ld d, $0
	ld hl, OAMPixelYOffsets_d247
	add hl, de
	ld c, [hl]
	ld a, [wda80]
	ld e, a
	ld d, $0
	ld hl, OAMPixelXOffsets_d24c
	add hl, de
	ld b, [hl]
	ld a, $86
	call LoadOAMData
	ret

OAMPixelYOffsets_d247: ; 0xd247
	db $10, $28, $40, $58, $70

OAMPixelXOffsets_d24c: ; 0xd24c
	db $18, $20, $28

AnimateHighScoresArrow: ; 0xd24f
; Handles the animation of the arrow in the bottom
; corner of the high scores screens.
	ld a, [wHighScoresArrowAnimationCounter]
	inc a
	cp $28
	jr c, .noOverflow
	xor a
.noOverflow
	ld [wHighScoresArrowAnimationCounter], a
	ld a, [wHighScoresStage]
	and a
	ld c, $77
	ld a, $95
	ld hl, HighScoresRightArrowOAMPixelXOffsets
	jr z, .asm_d26d
	ld a, $96
	ld hl, HighScoresLeftArrowOAMPixelXOffsets
.asm_d26d
	push af
	ld a, [wHighScoresArrowAnimationCounter]
	ld e, a
	ld d, $0
	add hl, de
	ld b, [hl]
	pop af
	call LoadOAMData
	ret

HighScoresRightArrowOAMPixelXOffsets: ; 0xd27b
; Controls the animation of the right-arrow in the bottom corner of the
; high scores screen.
	db $87, $87, $8A, $8A, $8A, $8A, $8A, $8A
	db $89, $89, $88, $88, $88, $88, $88, $88
	db $88, $88, $88, $88, $88, $88, $88, $88
	db $88, $88, $88, $88, $88, $88, $88, $88
	db $88, $88, $88, $88, $88, $88, $88, $88

HighScoresLeftArrowOAMPixelXOffsets: ; 0xd2a3
	db $02, $02, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01

Func_d2cb: ; 0xd2cb
	ld b, $5
.asm_d2cd
	push bc
	push hl
	dec de
	dec de
	dec de
	dec de
	ld a, l
	add $5
	ld l, a
	ld b, $3
.asm_d2d9
	ld a, [de]
	call Func_d348
	dec de
	dec hl
	dec b
	jr nz, .asm_d2d9
	pop hl
	push hl
	ld a, l
	add $6
	ld l, a
	ld bc, $0c01
.asm_d2eb
	ld a, [de]
	swap a
	and $f
	call Func_d30e
	inc hl
	dec b
	ld a, [de]
	and $f
	call Func_d30e
	dec de
	inc hl
	dec b
	jr nz, .asm_d2eb
	xor a
	call Func_d317
	pop hl
	ld bc, hSCY
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_d2cd
	ret

Func_d30e: ; 0xd30e
	jr nz, Func_d317
	ld a, b
	dec a
	jr z, Func_d317
	ld a, c
	and a
	ret nz
	; fall through
Func_d317: ; 0xd317
	push de
	push af
	call Func_d336
	pop af
	ld c, $0
	sla a
	add e
	ld [hl], a
	cp $fe
	jr z, .asm_d328
	inc a
.asm_d328
	push hl
	push af
	ld a, l
	add $20
	ld l, a
	jr nc, .asm_d331
	inc h
.asm_d331
	pop af
	ld [hl], a
	pop hl
	pop de
	ret

Func_d336: ; 0xd336
	ld e, $6c
	ld a, b
	cp $3
	ret z
	cp $6
	ret z
	cp $9
	ret z
	cp $c
	ret z
	ld e, $58
	ret

Func_d348: ; 0xd348
	ld c, $0
	sla a
	add $90
	ld [hl], a
	cp $fe
	jr z, .asm_d354
	inc a
.asm_d354
	push hl
	push af
	ld a, l
	add $20
	ld l, a
	jr nc, .asm_d35d
	inc h
.asm_d35d
	pop af
	ld [hl], a
	pop hl
	ret

Func_d361: ; 0xd361
	ld b, $5
.asm_d363
	push bc
	push hl
	dec de
	dec de
	dec de
	dec de
	ld a, l
	add $5
	ld l, a
	ld b, $3
.asm_d36f
	ld a, [de]
	call Func_d3e2
	dec de
	dec hl
	dec b
	jr nz, .asm_d36f
	pop hl
	push hl
	ld a, l
	add $6
	ld l, a
	ld bc, $0c01
.asm_d381
	ld a, [de]
	swap a
	and $f
	call Func_d3a4
	inc hl
	dec b
	ld a, [de]
	and $f
	call Func_d3a4
	dec de
	inc hl
	dec b
	jr nz, .asm_d381
	xor a
	call Func_d3ad
	pop hl
	ld bc, hSCY
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_d363
	ret

Func_d3a4: ; 0xd3a4
	jr nz, Func_d3ad
	ld a, b
	dec a
	jr z, Func_d3ad
	ld a, c
	and a
	ret nz
	; fall through
Func_d3ad: ; 0xd3ad
	push de
	push af
	call Func_d3d0
	pop af
	ld c, $0
	sla a
	add e
	call PutTileInVRAM
	cp $fe
	jr z, .asm_d3c0
	inc a
.asm_d3c0
	push hl
	push af
	ld a, l
	add $20
	ld l, a
	jr nc, .asm_d3c9
	inc h
.asm_d3c9
	pop af
	call PutTileInVRAM
	pop hl
	pop de
	ret

Func_d3d0: ; 0xd3d0
	ld e, $6c
	ld a, b
	cp $3
	ret z
	cp $6
	ret z
	cp $9
	ret z
	cp $c
	ret z
	ld e, $58
	ret

Func_d3e2: ; 0xd3e2
	ld c, $0
	sla a
	add $90
	call PutTileInVRAM
	cp $fe
	jr z, .asm_d3f0
	inc a
.asm_d3f0
	push hl
	push af
	ld a, l
	add $20
	ld l, a
	jr nc, .asm_d3f9
	inc h
.asm_d3f9
	pop af
	call PutTileInVRAM
	pop hl
	ret

CopyInitialHighScores: ; 0xd3ff
	ld hl, InitialHighScores
	ld de, wRedHighScore1Points
	call CopyInitialHighScoresForStage
	ld hl, InitialHighScores
	ld de, wBlueHighScore1Points

CopyInitialHighScoresForStage: ; 0xd40e
; input:  hl = address of high score entries
;         de = destination address for high score entries to be copied
	ld b, $5  ; 5 high score entries to copy
.copyHighScoreEntry
	ld c, $6  ; high score points are 6 bytes long
.copyPoints
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copyPoints
	ld c, $3  ; name is 3 bytes
.copyName
	ld a, [hli]
	sub $37
	ld [de], a
	inc de
	dec c
	jr nz, .copyName
	ld c, $4
.asm_d424  ; TODO: what are these 4 bytes used for?
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_d424
	dec b
	jr nz, .copyHighScoreEntry
	ret

INCLUDE "data/initial_high_scores.asm" ; 0xd42e

Func_d46f: ; 0xd46f
	ld a, [wda81]
	ld d, a
	sla a
	add d
	ld d, a
	ld e, $0
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	ld a, [wda80]
	add e
	ld e, a
	hlCoord 3, 2, vBGMap
	ld a, [wHighScoresStage]
	and a
	jr z, .asm_d496
	hlCoord 3, 2, vBGWin
.asm_d496
	add hl, de
	push hl
	ld a, [wda81]
	ld e, a
	sla e
	sla e
	add e
	sla e
	add e
	ld e, a
	ld a, [wda80]
	add e
	ld e, a
	ld d, $0
	ld hl, wRedHighScore1Name
	ld a, [wHighScoresStage]
	and a
	jr z, .asm_d4b8
	ld hl, wBlueHighScore1Name
.asm_d4b8
	add hl, de
	ld a, [hl]
	sla a
	add $90
	pop hl
	call PutTileInVRAM
	ld de, $0020
	add hl, de
	cp $fe
	jr z, .asm_d4cb
	inc a
.asm_d4cb
	call PutTileInVRAM
	ret

Func_d4cf: ; 0xd4cf
	ld a, [hNewlyPressedButtons]
	ld b, a
	ld a, [wHighScoresStage]
	bit 4, b
	jr z, .asm_d4e3
	and a
	ret nz
	lb de, $00, $03
	call PlaySoundEffect
	jr .asm_d4f0

.asm_d4e3
	bit 5, b
	ret z
	and a
	ret z
	lb de, $00, $03
	call PlaySoundEffect
	jr .asm_d537

.asm_d4f0
	call ClearOAMBuffer
	call Func_d57b
	ld a, $a5
	ld [hWX], a
	xor a
	ld [hWY], a
	ld a, $2
	ld [hSCX], a
	ld hl, hLCDC
	set 5, [hl]
	ld b, $27
.asm_d508
	push bc
	ld a, $27
	sub b
	bit 0, b
	call nz, TransitionHighScoresPalettes
	ld hl, hWX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	ld hl, hSCX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	rst AdvanceFrame
	pop bc
	dec b
	jr nz, .asm_d508
	xor a
	ld [hSCX], a
	ld hl, hLCDC
	res 5, [hl]
	set 3, [hl]
	ld a, $1
	ld [wHighScoresStage], a
	call Func_d5d0
	ret

.asm_d537
	call ClearOAMBuffer
	call Func_d57b
	ld a, $7
	ld [hWX], a
	xor a
	ld [hWY], a
	ld a, $a0
	ld [hSCX], a
	ld hl, hLCDC
	set 5, [hl]
	res 3, [hl]
	ld b, $27
.asm_d551
	push bc
	ld a, b
	bit 0, b
	call nz, TransitionHighScoresPalettes
	ld hl, hWX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld hl, hSCX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	rst AdvanceFrame
	pop bc
	dec b
	jr nz, .asm_d551
	xor a
	ld [hSCX], a
	ld hl, hLCDC
	res 5, [hl]
	xor a
	ld [wHighScoresStage], a
	call Func_d5d0
	ret

Func_d57b: ; 0xd57b
	ld a, $f0
	ld [hSCY], a
	xor a
	ld [hNextFrameHBlankSCX], a
	ld a, $10
	ld [hNextFrameHBlankSCY], a
	rst AdvanceFrame
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap
	deCoord 0, 0, vBGMap
	ld bc, $0040
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap + $200
	deCoord 0, 16, vBGMap
	ld bc, $0040
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2
	deCoord 0, 0, vBGWin
	ld bc, $0040
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2 + $200
	deCoord 0, 16, vBGWin
	ld bc, $0040
	call LoadVRAMData
	ld b, $10
.asm_d5c1
	push bc
	ld hl, hSCY
	inc [hl]
	ld hl, hNextFrameHBlankSCY
	dec [hl]
	rst AdvanceFrame
	pop bc
	dec b
	jr nz, .asm_d5c1
	ret

Func_d5d0: ; 0xd5d0
	ld b, $10
.asm_d5d2
	push bc
	ld hl, hSCY
	dec [hl]
	ld hl, hNextFrameHBlankSCY
	inc [hl]
	rst AdvanceFrame
	pop bc
	dec b
	jr nz, .asm_d5d2
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap + $3c0
	deCoord 0, 0, vBGMap
	ld bc, $0040
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap)
	ld hl, HighScoresTilemap + $280
	deCoord 0, 16, vBGMap
	ld bc, $0040
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2 + $3c0
	deCoord 0, 0, vBGWin
	ld bc, $0040
	call LoadVRAMData
	ld a, BANK(HighScoresTilemap2)
	ld hl, HighScoresTilemap2 + $280
	deCoord 0, 16, vBGWin
	ld bc, $0040
	call LoadVRAMData
	ld bc, $0009
	call Func_d68a
	xor a
	ld [hSCY], a
	ld [hNextFrameHBlankSCX], a
	ld [hNextFrameHBlankSCY], a
	ret

TransitionHighScoresPalettes: ; 0xd626
; When switching between the Red and Blue field high scores, the palettes
; of the rows smoothly transition between red and blue.
	ld c, a
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, c
	srl a
	sub $2
	cp $10
	ret nc
	ld c, a
	ld b, $0
	sla c
	add c
	ld c, a
	ld hl, HighScoresPalettesTransition
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, b
	ld l, c
	ld de, $0008
	ld bc, $0038
	push af
	call Func_7dc
	pop af
	ld de, $0040
	ld bc, $0008
	call Func_7dc
	ret

HighScoresPalettesTransition: ; 0xd65a
; When switching between the Red and Blue field high scores, the palette
; of the rows fades between red and blue. This table defines the transition
; of those palettes.
	dwb HighScoresTransitionPalettes1,  Bank(HighScoresTransitionPalettes1)
	dwb HighScoresTransitionPalettes2,  Bank(HighScoresTransitionPalettes2)
	dwb HighScoresTransitionPalettes3,  Bank(HighScoresTransitionPalettes3)
	dwb HighScoresTransitionPalettes4,  Bank(HighScoresTransitionPalettes4)
	dwb HighScoresTransitionPalettes5,  Bank(HighScoresTransitionPalettes5)
	dwb HighScoresTransitionPalettes6,  Bank(HighScoresTransitionPalettes6)
	dwb HighScoresTransitionPalettes7,  Bank(HighScoresTransitionPalettes7)
	dwb HighScoresTransitionPalettes8,  Bank(HighScoresTransitionPalettes8)
	dwb HighScoresTransitionPalettes9,  Bank(HighScoresTransitionPalettes9)
	dwb HighScoresTransitionPalettes10, Bank(HighScoresTransitionPalettes10)
	dwb HighScoresTransitionPalettes11, Bank(HighScoresTransitionPalettes11)
	dwb HighScoresTransitionPalettes12, Bank(HighScoresTransitionPalettes12)
	dwb HighScoresTransitionPalettes13, Bank(HighScoresTransitionPalettes13)
	dwb HighScoresTransitionPalettes14, Bank(HighScoresTransitionPalettes14)
	dwb HighScoresTransitionPalettes15, Bank(HighScoresTransitionPalettes15)
	dwb HighScoresTransitionPalettes16, Bank(HighScoresTransitionPalettes16)

Func_d68a: ; 0xd68a
	push bc
	ld hl, wPokedexFlags
	ld bc, (NUM_POKEMON << 8)
.asm_d691
	bit 1, [hl]
	jr z, .asm_d696
	inc c
.asm_d696
	inc hl
	dec b
	jr nz, .asm_d691
	ld a, c
	pop bc
	cp NUM_POKEMON
	ret nz
	ld hl, vBGMap
	add hl, bc
	call Func_d6aa
	ld hl, vBGWin
	add hl, bc
	; fall through
Func_d6aa: ; 0xd6aa
	ld a, $56
	call PutTileInVRAM
	inc hl
	ld a, $57
	call PutTileInVRAM
	ret

Func_d6b6: ; 0xd6b6
	ld hl, wPokedexFlags
	ld bc, (NUM_POKEMON << 8)
.asm_d6bc
	bit 1, [hl]
	jr z, .asm_d6c1
	inc c
.asm_d6c1
	inc hl
	dec b
	jr nz, .asm_d6bc
	ld a, c
	cp NUM_POKEMON
	ret nz
	ld hl, wc289
	ld a, $56
	ld [hli], a
	ld a, $57
	ld [hli], a
	ret

HandleFieldSelectScreen: ; 0xd6d3
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
FieldSelectScreenFunctions: ; 0xd6d7
	dw LoadFieldSelectScreen
	dw ChooseFieldToPlay
	dw ExitFieldSelectScreen

LoadFieldSelectScreen: ; 0xd6dd
	ld a, $43
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld a, $d2
	ld [wOBP0], a
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld [hSCY], a
	ld hl, FieldSelectGfxPointers
	ld a, [hGameBoyColorFlag]
	call LoadVideoData
	call ClearOAMBuffer
	ld a, $8
	ld [wFieldSelectBlinkingBorderFrame], a
	call Func_b66
	ld a, $12
	call SetSongBank
	ld de, $0003
	call PlaySong
	call Func_588
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ret

FieldSelectGfxPointers: ; 0xd71c
	dw FieldSelectGfx_GameBoy
	dw FieldSelectGfx_GameBoyColor

FieldSelectGfx_GameBoy: ; 0xd720
	VIDEO_DATA_TILES   FieldSelectScreenGfx, vTilesSH - $100, $d00
	VIDEO_DATA_TILEMAP FieldSelectTilemap, vBGMap, $240
	db $FF, $FF ; terminators

FieldSelectGfx_GameBoyColor: ; 0xd730
	VIDEO_DATA_TILES    FieldSelectScreenGfx, vTilesSH - $100, $d00
	VIDEO_DATA_TILEMAP  FieldSelectTilemap, vBGMap, $240
	VIDEO_DATA_BGATTR   FieldSelectBGAttributes, vBGMap, $240
	VIDEO_DATA_PALETTES FieldSelectScreenPalettes, $48
	db $FF, $FF ; terminators

ChooseFieldToPlay: ; 0xd74e
	call MoveFieldSelectCursor
	ld hl, FieldSelectBorderAnimationData
	call AnimateBlinkingFieldSelectBorder
	ld a, [hNewlyPressedButtons]
	and (A_BUTTON | B_BUTTON)
	ret z
	ld [wd8f6], a
	ld a, $18  ; number of frames to blink the border after selecting the Field
	ld [wFieldSelectBlinkingBorderTimer], a
	ld a, $1
	ld [wFieldSelectBlinkingBorderFrame], a
	lb de, $00, $01
	call PlaySoundEffect
	ld hl, wScreenState
	inc [hl]
	ret

ExitFieldSelectScreen: ; 0xd774
	ld a, [wd8f6]  ; this holds the button that was pressed (A or B)
	bit BIT_A_BUTTON, a
	jr z, .didntPressA
	ld hl, FieldSelectConfirmationAnimationData
	call AnimateBlinkingFieldSelectBorder
	ld a, [wFieldSelectBlinkingBorderTimer]
	dec a
	ld [wFieldSelectBlinkingBorderTimer], a
	ret nz
.didntPressA
	ld a, [hJoypadState]
	push af
	call Func_cb5
	call Func_576
	ld a, [wd8f6]
	bit BIT_A_BUTTON, a
	jr z, .pressedB
	ld a, [wSelectedFieldIndex]
	ld c, a
	ld b, $0
	ld hl, StartingStages
	add hl, bc
	ld a, [hl]
	ld [wCurrentStage], a
	pop af
	xor a
	ld [wd7c2], a
	ld hl, wPartyMons
	ld de, sSaveGame
	ld bc, $04c3
	call SaveData
	xor a
	ld [wd7c1], a
	; Start a round of Pinball! Yayy
	ld a, SCREEN_PINBALL_GAME
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

.pressedB
	pop af
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

StartingStages: ; 0xd7d1
; wSelectedFieldIndex is used to index this array
	db STAGE_RED_FIELD_BOTTOM, STAGE_BLUE_FIELD_BOTTOM

MoveFieldSelectCursor: ; 0xd7d3
; When the player presses Right or Left, the stage is
; illuminated with a blinking border.  This function keeps tracks
; of which field is currently selected.
	ld a, [hPressedButtons]
	ld b, a
	ld a, [wSelectedFieldIndex]
	bit BIT_D_LEFT, b
	jr z, .didntPressLeft
	and a
	ret z  ; if cursor is already hovering over Red stage, don't do anything
	dec a  ; move cursor over Red stage
	ld [wSelectedFieldIndex], a
	lb de, $00, $3c
	call PlaySoundEffect
	ret

.didntPressLeft
	bit BIT_D_RIGHT, b
	ret z
	cp $1
	ret z  ; if cursor is already hovering over Blue stage, don't do anything
	inc a  ; move cursor over Red stage
	ld [wSelectedFieldIndex], a
	lb de, $00, $3d
	call PlaySoundEffect
	ret

AnimateBlinkingFieldSelectBorder: ; 0xd7fb
; This makes the border of the currently-selected Field blink in the Field Select screen.
	push hl
	ld a, [wSelectedFieldIndex]
	sla a
	ld c, a
	ld b, $0
	ld hl, FieldSelectBorderOAMPixelOffsetData
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [wd915]
	sla a
	ld e, a
	ld d, $0
	pop hl
	push hl
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ld a, [wFieldSelectBlinkingBorderFrame]
	dec a
	jr nz, .asm_d838
	inc hl
	inc hl
	ld a, [hl]
	and a
	jr z, .asm_d82b
	ld a, [wd915]
	inc a
.asm_d82b
	ld [wd915], a
	sla a
	ld c, a
	ld b, $0
	pop hl
	push hl
	inc hl
	add hl, bc
	ld a, [hl]
.asm_d838
	ld [wFieldSelectBlinkingBorderFrame], a
	pop hl
	ret

FieldSelectBorderAnimationData:
; [OAM id][duration]
	db $9e, $08
	db $9f, $08
	db $9e, $08
	db $a0, $08
	db $00  ; terminator

FieldSelectConfirmationAnimationData:
; [OAM id][duration]
	db $9F, $03
	db $A0, $03
	db $9F, $03
	db $A0, $03
	db $00  ; terminator

FieldSelectBorderOAMPixelOffsetData:
	dw $2A42
	dw $7242

HandlePinballGame: ; 0xd853
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
PinballGameScreenFunctions: ; 0xd857
	dw GameScreenFunction_LoadGFX
	dw GameScreenFunction_StartBall
	dw GameScreenFunction_HandleBallPhysics
	dw GameScreenFunction_HandleBallLoss
	dw GameScreenFunction_EndBall

GameScreenFunction_LoadGFX: ; 0xd861
	xor a
	ld [wd908], a
	callba InitializeStage
	call FillBottomMessageBufferWithBlackTile
	ld a, $1
	ld [wd85d], a
	ld [wd4aa], a
	ld hl, wScreenState
	inc [hl]
	ret

GameScreenFunction_StartBall: ; 0xd87f
	ld a, $67
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld a, $e1
	ld [wOBP0], a
	ld a, $e4
	ld [wOBP1], a
	ld a, [wSCX]
	ld [hSCX], a
	xor a
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $83
	ld [hLYC], a
	ld [hLastLYC], a
	ld a, $ff
	ld [hLCDCMask], a
	ld hl, hSTAT
	set 6, [hl]
	ld hl, rIE
	set 1, [hl]
	ld a, $1
	ld [hHBlankRoutine], a
	callba StartBallForStage
	callba LoadStageCollisionAttributes
	callba Func_e6c2
	callba Func_ed5e
	call ClearOAMBuffer
	callba Func_84b7
	ld a, [wd849]
	and a
	call nz, Func_e5d
	ld a, $1
	ld [wd4aa], a
	xor a
	ld [wd7c1], a
	call Func_b66
	call Func_588
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ret

GameScreenFunction_HandleBallPhysics: ; 0xd909
; main loop for stage logic
	xor a
	ld [wFlipperCollision], a
	ld [wd7eb], a
	call ApplyGravityToBall
	call LimitBallVelocity
	xor a
	ld [wd7e9], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, HandleFlippers  ; only perform flipper routines on the lower-half of stages
	ld a, [wFlipperCollision]
	and a
	ld a, [wCollisionForceAngle]
	push af
	call CheckObjectCollision  ; collision stuff
	pop af
	jr z, .noFlipperCollision
	ld [wCollisionForceAngle], a
.noFlipperCollision
	call CheckGameObjectCollisions
	call Func_281c ; not collision-related
	ld hl, wKeyConfigMenu
	call IsKeyPressed
	jr z, .didntPressMenuKey
	lb de, $03, $4c
	call PlaySoundEffect
	callba HandleInGameMenu
	jp z, SaveGame
.didntPressMenuKey
	ld a, [wd7e9]  ; check for collision flag
	and a
	jr z, .skip_collision
	call ApplyTiltForces
	call LoadBallVelocity ; bc = x velocity, de = y velocity
	ld a, [wCollisionForceAngle]
	call ApplyCollisionForce
	call ApplyTorque
	ld a, [wFlipperCollision]
	and a
	jr z, .not_flippers_2
	; de -= *wFlipperYForce
	ld hl, wFlipperYForce
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	; bc += *wFlipperXForce
	ld hl, wFlipperXForce
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	add l
	ld c, a
	ld a, b
	adc h
	ld b, a
	jr .next

.not_flippers_2
	ld a, [wd7f8]
	and a
	jr nz, .skip_collision
.next
	ld a, [wCollisionForceAngle]
	call NegateAngleAndApplyCollisionForce
	call SetBallVelocity
.skip_collision
	call MoveBallPosition
	callba CheckStageTransition
	callba Func_84b7
	call Func_33e3
	ld a, [wd5cb]
	and a
	jr nz, .asm_d9e9
	callba Func_85c7
	callba Func_8650
	callba Func_8645
	call Func_dba9
	call Func_dc7c
	call Func_dcb4
.asm_d9e9
	ld a, [wd57d]
	and a
	callba nz, Func_86a4
	ld a, [wd4ae]
	and a
	ret z
	xor a
	ld [wd4ae], a
	ld hl, wScreenState
	inc [hl]
	ret

SaveGame: ; 0xda05
	ld de, $0000
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call Func_cb5
	ld a, [wd849]
	and a
	call nz, Func_e5d
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	xor a
	ld [wd4aa], a
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

GameScreenFunction_HandleBallLoss: ; 0xda36
	xor a
	ld [hJoypadState], a
	ld [hNewlyPressedButtons], a
	ld [hPressedButtons], a
	ld [wFlipperCollision], a
	ld [wd7eb], a
	xor a
	ld [wd7e9], a
	ld [wd548], a
	ld [wd549], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, HandleFlippers
	callba Func_84b7
	call Func_33e3
	callba Func_85c7
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd4c9]
	and a
	jr z, .asm_daa9
	ld a, [wd49c]
	cp $2
	jr z, .asm_daa9
	call Func_f533
	ld a, [wd49c]
	and a
	jr z, .asm_daa9
	ld a, $2
	ld [wd49c], a
	ld [wd4aa], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, ShootAgainText
	call LoadTextHeader
	ret

.asm_daa9
	xor a
	ld [wd49c], a
	ld hl, wScreenState
	inc [hl]
	ret

GameScreenFunction_EndBall: ; 0xdab2
	xor a
	ld [wd803], a
	ld a, [wGameOver]
	and a
	jp nz, TransitionToHighScoresScreen
	ld a, [wd495]
	and a
	jr nz, .asm_dae6
	ld a, [wd496]
	and a
	jr nz, .asm_db28
	call Func_cb5
	ld a, [wd849]
	and a
	call z, Func_e5d
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, $1
	ld [wScreenState], a
	ret

.asm_dae6
	ld de, $0000
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call Func_cb5
	ld a, [wd849]
	and a
	call nz, Func_e5d
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, [wCurrentStage]
	ld [wd4ad], a
	ld a, [wStageCollisionState]
	ld [wd4b0], a
	ld a, [wd497]
	ld [wCurrentStage], a
	xor a
	ld [wd496], a
	ld [wd495], a
	ld a, $0
	ld [wScreenState], a
	ret

.asm_db28
	ld de, $0000
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call Func_cb5
	ld a, [wd849]
	and a
	call nz, Func_e5d
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, [wd4ad]
	ld [wCurrentStage], a
	ld a, [wd4b0]
	ld [wStageCollisionState], a
	ld a, $1
	ld [wScreenState], a
	ret

TransitionToHighScoresScreen: ; 0xdb5d
	xor a
	ld [wGameOver], a
	ld de, $0000
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call Func_cb5
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	xor a
	ld [wd4aa], a
	ld a, [wCurrentStage]
	ld c, a
	ld b, $0
	ld hl, HighScoresStageMapping
	add hl, bc
	ld a, [hl]
	ld [wHighScoresStage], a
	ld a, SCREEN_HIGH_SCORES
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

HighScoresStageMapping: ; 0xdb99
; Determines which stage the high scores screen will start in,
; based on the map the player ended in.
; See wHighScoresStage for more info.
	db $00  ; STAGE_RED_FIELD_TOP
	db $00  ; STAGE_RED_FIELD_BOTTOM
	db $00
	db $00
	db $01  ; STAGE_BLUE_FIELD_TOP
	db $01  ; STAGE_BLUE_FIELD_BOTTOM
	db $00  ; STAGE_GENGAR_BONUS
	db $00  ; STAGE_GENGAR_BONUS
	db $00  ; STAGE_MEWTWO_BONUS
	db $00  ; STAGE_MEWTWO_BONUS
	db $00  ; STAGE_MEOWTH_BONUS
	db $00  ; STAGE_MEOWTH_BONUS
	db $00  ; STAGE_DIGLETT_BONUS
	db $00  ; STAGE_DIGLETT_BONUS
	db $00  ; STAGE_SEEL_BONUS
	db $00  ; STAGE_SEEL_BONUS

Func_dba9: ; 0xdba9
	ld a, $85
	ld [wBottomMessageBuffer + $44], a
	ld a, [wd49d]
	xor $3
	inc a
	add $86
	ld [wBottomMessageBuffer + $45], a
	ret

Start20SecondSaverTimer: ; 0xdbba
	ld a, $1
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wd4a2], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 20
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret

InitBallSaverForCatchEmMode: ; 0xdbd4
	ld a, [wBallSaverTimerFrames]
	ld [wBallSaverTimerFramesBackup], a
	ld a, [wBallSaverTimerSeconds]
	ld [wBallSaverTimerSecondsBackup], a
	ld a, [wNumTimesBallSavedTextWillDisplay]
	ld [wd4a8], a
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wd4a2], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 60
	ld [wBallSaverTimerSeconds], a
	ld a, $ff
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret

RestoreBallSaverAfterCatchEmMode: ; 0xdc00
	ld a, [wBallSaverTimerFramesBackup]
	ld [wBallSaverTimerFrames], a
	ld a, [wBallSaverTimerSecondsBackup]
	ld [wBallSaverTimerSeconds], a
	ld a, [wd4a8]
	ld [wNumTimesBallSavedTextWillDisplay], a
	ld a, [wBallSaverTimerSeconds]
	and a
	jr z, .asm_dc1a
	ld a, $1
.asm_dc1a
	ld [wBallSaverIconOn], a
	ld a, [wBallSaverTimerSeconds]
	ld c, $0
	cp $2
	jr c, .asm_dc34
	ld c, $4
	cp $6
	jr c, .asm_dc34
	ld c, $10
	cp $b
	jr c, .asm_dc34
	ld c, $ff
.asm_dc34
	ld a, c
	ld [wd4a2], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_14707
	ret

HandleBallLoss: ; 0xdc49
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_dc4d: ; 0xdc4d
	; STAGE_RED_FIELD_TOP
	dw RedField_HandleBallLoss
	; STAGE_RED_FIELD_BOTTOM
	dw RedField_HandleBallLoss
	dw Func_de4e
	dw Func_de4e
	; STAGE_BLUE_FIELD_TOP
	dw BlueField_HandleBallLoss
	; STAGE_BLUE_FIELD_TOP
	dw BlueField_HandleBallLoss
	; STAGE_GENGAR_BONUS
	dw Func_df1a
	; STAGE_GENGAR_BONUS
	dw Func_df1a
	; STAGE_MEWTWO_BONUS
	dw Func_df7e
	; STAGE_MEWTWO_BONUS
	dw Func_df7e
	; STAGE_MEOWTH_BONUS
	dw Func_dfe2
	; STAGE_MEOWTH_BONUS
	dw Func_dfe2
	; STAGE_DIGLETT_BONUS
	dw Func_e056
	; STAGE_DIGLETT_BONUS
	dw Func_e056
	; STAGE_SEEL_BONUS
	dw Func_e08b
	; STAGE_SEEL_BONUS
	dw Func_e08b

Func_dc6d: ; 0xdc6d
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	pop de
	call LoadTextHeader
	ret

Func_dc7c: ; 0xdc7c
	ld hl, wBottomMessageBuffer + $40
	ld a, $83
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $81
	ld [hl], a
	ld a, [wNumPartyMons]
	call ConvertHexByteToDecWord
	ld hl, wBottomMessageBuffer + $41
	ld c, $1
	ld a, d
	call .asm_dca0
	ld a, e
	swap a
	call .asm_dca0
	ld a, e
	ld c, $0
.asm_dca0
	and $f
	jr nz, .asm_dca7
	ld a, c
	and a
	ret nz
.asm_dca7
	ld c, $0
	add $86
	ld [hli], a
	ret

Data_dcad:
; BCD powers of 2
	db $01, $02, $04, $08, $16, $32, $64

Func_dcb4: ; 0xdcb4
	ld a, [wd517]
	cp $f
	ld a, $81
	jr nz, .asm_dcbf
	ld a, $84
.asm_dcbf
	ld [wBottomMessageBuffer + $46], a
	ret

LoadBallGfx: ; 0xdcc3
	xor a
	ld [wd4c8], a
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeBall
	ld a, Bank(PinballPokeballGfx)
	ld hl, PinballPokeballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notPokeBall
	cp ULTRA_BALL
	jr nc, .notGreatBall
	ld a, Bank(PinballGreatballGfx)
	ld hl, PinballGreatballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notGreatBall
	cp MASTER_BALL
	jr nc, .notUltraBall
	ld a, Bank(PinballUltraballGfx)
	ld hl, PinballUltraballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notUltraBall
	ld a, Bank(PinballMasterballGfx)
	ld hl, PinballMasterballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

LoadMiniBallGfx: ; 0xdd12
	ld a, $1
	ld [wd4c8], a
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeBall
	ld a, Bank(PinballPokeballMiniGfx)
	ld hl, PinballPokeballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notPokeBall
	cp ULTRA_BALL
	jr nc, .notGreatBall
	ld a, Bank(PinballGreatballMiniGfx)
	ld hl, PinballGreatballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notGreatBall
	cp MASTER_BALL
	jr nc, .notUltraBall
	ld a, Bank(PinballUltraballMiniGfx)
	ld hl, PinballUltraballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notUltraBall
	ld a, Bank(PinballMasterballMiniGfx)
	ld hl, PinballMasterballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

Func_dd62: ; 0xdd62
	ld a, $2
	ld [wd4c8], a
	ld a, $2a
	ld hl, PinballBallMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

RedField_HandleBallLoss: ; 0xdd76
	ld a, [wBallSaverTimerFrames]
	ld hl, wBallSaverTimerSeconds
	or [hl]
	jr z, .rip
	ld a, [wNumTimesBallSavedTextWillDisplay]
	bit 7, a
	jr nz, .skip_save_text
	dec a
	ld [wNumTimesBallSavedTextWillDisplay], a
	push af
	ld de, BallSavedText
	call Func_dc6d
	pop af
	jr nz, .skip_save_text
	ld a, $1
	ld [wBallSaverTimerFrames], a
	ld [wBallSaverTimerSeconds], a
.skip_save_text
	lb de, $15, $02
	call PlaySoundEffect
	ret

.rip
	ld de, $0000
	call PlaySong
	ld bc, $001e
	call AdvanceFrames
	lb de, $25, $24
	call PlaySoundEffect
	call Start20SecondSaverTimer
	ld a, $1
	ld [wd4c9], a
	xor a
	ld [wd4de], a
	ld [wd4df], a
	call Func_ddfd
	ld a, [wd49b]
	and a
	jr z, .asm_dddd
	dec a
	ld [wd49b], a
	ld a, $1
	ld [wd49c], a
	ld de, EndOfBallBonusText
	call Func_dc6d
	ret

.asm_dddd
	ld a, [wd49d]
	ld hl, wd49e
	cp [hl]
	jr z, .asm_ddf1
	inc a
	ld [wd49d], a
	ld de, EndOfBallBonusText
	call Func_dc6d
	ret

.asm_ddf1
	ld de, EndOfBallBonusText
	call Func_dc6d
	ld a, $1
	ld [wGameOver], a
	ret

Func_ddfd: ; 0xddfd
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	jr nz, .asm_de14
	callba Func_10157
	jr .asm_de40

.asm_de14
	cp $1
	jr nz, .asm_de2d
	xor a
	ld [wd604], a
	ld a, $1e
	ld [wd607], a
	callba Func_10ac8
	jr .asm_de40

.asm_de2d
	xor a
	ld [wd604], a
	ld a, $1e
	ld [wd607], a
	callba Func_3022b
.asm_de40
	ld a, [wd7ad]
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	ret

Func_de4e: ; 0xde4e
	ret

BlueField_HandleBallLoss: ; 0xde4f
	ld a, [wBallSaverTimerFrames]
	ld hl, wBallSaverTimerSeconds
	or [hl]
	jr z, .rip
	ld a, [wNumTimesBallSavedTextWillDisplay]
	bit 7, a
	jr nz, .skip_save_text
	dec a
	ld [wNumTimesBallSavedTextWillDisplay], a
	push af
	ld de, BallSavedText
	call Func_dc6d
	pop af
	jr nz, .skip_save_text
	ld a, $1
	ld [wBallSaverTimerFrames], a
	ld [wBallSaverTimerSeconds], a
.skip_save_text
	lb de, $15, $02
	call PlaySoundEffect
	ret

.rip
	ld de, $0000
	call PlaySong
	ld bc, $001e
	call AdvanceFrames
	lb de, $25, $24
	call PlaySoundEffect
	call Start20SecondSaverTimer
	ld a, $1
	ld [wd4c9], a
	xor a
	ld [wd4de], a
	ld [wd4df], a
	call Func_ded6
	ld a, [wd49b]
	and a
	jr z, .asm_deb6
	dec a
	ld [wd49b], a
	ld a, $1
	ld [wd49c], a
	ld de, EndOfBallBonusText
	call Func_dc6d
	ret

.asm_deb6
	ld a, [wd49d]
	ld hl, wd49e
	cp [hl]
	jr z, .asm_deca
	inc a
	ld [wd49d], a
	ld de, EndOfBallBonusText
	call Func_dc6d
	ret

.asm_deca
	ld de, EndOfBallBonusText
	call Func_dc6d
	ld a, $1
	ld [wGameOver], a
	ret

Func_ded6: ; 0xded6
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	jr nz, .asm_deec
	callba Func_10157
	ret

.asm_deec
	cp $1
	jr nz, .asm_df05
	ld a, $0
	ld [wd604], a
	ld a, $1e
	ld [wd607], a
	callba Func_10ac8
	ret

.asm_df05
	ld a, $0
	ld [wd604], a
	ld a, $1e
	ld [wd607], a
	callba Func_3022b
	ret

Func_df1a: ; 0xdf1a
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd6a8]
	and a
	jr nz, .asm_df57
	ld a, [wd6a2]
	cp $5
	jr c, .asm_df50
	xor a
	ld [wd4ae], a
	ld a, [wd6a7]
	and a
	ret nz
	ld [wd548], a
	ld [wd549], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $1
	ld [wd6a7], a
.asm_df50
	lb de, $00, $02
	call PlaySoundEffect
	ret

.asm_df57
	xor a
	ld [wd495], a
	ld a, $1
	ld [wd496], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wd7ac], a
	ld a, [wd49a]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, EndGengarStageText
	call LoadTextHeader
	ret

Func_df7e: ; 0xdf7e
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd6b3]
	and a
	jr nz, .asm_dfbb
	ld a, [wd6b1]
	cp $8
	jr c, .asm_dfb4
	xor a
	ld [wd4ae], a
	ld a, [wd6b2]
	and a
	ret nz
	ld [wd548], a
	ld [wd549], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $1
	ld [wd6b2], a
.asm_dfb4
	lb de, $00, $0b
	call PlaySoundEffect
	ret

.asm_dfbb
	xor a
	ld [wd495], a
	ld a, $1
	ld [wd496], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wd7ac], a
	ld a, [wd49a]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, EndMewtwoStageText
	call LoadTextHeader
	ret

Func_dfe2: ; 0xdfe2
	xor a
	ld [wd64e], a
	ld a, [wd7be]
	and a
	jr z, .asm_dff2
	ld a, [wd49a]
	and a
	jr z, .asm_e00f
.asm_dff2
	ld a, [wMeowthStageScore]
	cp $14
	jr nc, .asm_e00f
	cp $5
	jr c, .asm_e001
	sub $4
	jr .asm_e002

.asm_e001
	xor a
.asm_e002
	ld [wMeowthStageScore], a
	callba Func_24fa3
.asm_e00f
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd712]
	cp $0
	jr nz, .asm_e025
	lb de, $00, $02
	call PlaySoundEffect
	ret

.asm_e025
	xor a
	ld [wd57e], a
	ld [wd57d], a
	xor a
	ld [wd495], a
	ld a, $1
	ld [wd496], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wd7ac], a
	ld [wd712], a
	ld a, [wd49a]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, EndMeowthStageText
	call LoadTextHeader
	ret

Func_e056: ; 0xe056
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	lb de, $00, $0b
	call PlaySoundEffect
	xor a
	ld [wd495], a
	ld a, $1
	ld [wd496], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wd7ac], a
	ld a, [wd49a]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, EndDiglettStageText
	call LoadTextHeader
	ret

Func_e08b: ; 0xe08b
	xor a
	ld [wd64e], a
	ld a, [wd7be]
	and a
	jr z, .asm_e09b
	ld a, [wd49a]
	and a
	jr z, .asm_e0b8
.asm_e09b
	ld a, [wd793]
	cp $14
	jr nc, .asm_e0b8
	cp $5
	jr c, .asm_e0aa
	sub $4
	jr .asm_e0ab

.asm_e0aa
	xor a
.asm_e0ab
	ld [wd793], a
	callba Func_262f4
.asm_e0b8
	ld a, [wd4ad]
	ld hl, wCurrentStage
	cp [hl]
	ret z
	ld a, [wd794]
	cp $0
	jr nz, .asm_e0c8
	ret

.asm_e0c8
	lb de, $00, $02
	call PlaySoundEffect
	xor a
	ld [wd57d], a
	ld [wd57d], a
	ld [wd495], a
	ld a, $1
	ld [wd496], a
	ld a, $2
	ld [wd4c8], a
	xor a
	ld [wd7ac], a
	ld [wd794], a
	ld a, [wd49a]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, EndSeelStageText
	call LoadTextHeader
	ret

HandleFlippers: ; 0xe0fe
	xor a
	ld [wFlipperCollision], a
	ld [hFlipperYCollisionAttribute], a
	ld [wFlipperXForce], a
	ld [wFlipperXForce + 1], a
	call Func_e118
	call CheckFlipperCollision
	ld a, [wFlipperCollision]
	and a
	call nz, HandleFlipperCollision
	ret

Func_e118: ; 0xe118
	call PlayFlipperSoundIfPressed
	ld a, [wd7af]
	ld [wLeftFlipperAnimationState], a
	ld a, [wd7b3]
	ld [wRightFlipperAnimationState], a
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	ld hl, -$0333
	jr z, .asm_e13b
	ld a, [wd7be]
	and a
	jr nz, .asm_e13b
	ld hl,  $0333
.asm_e13b
	ld a, [wd7af]
	and a
	jr nz, .asm_e145
	bit 7, h
	jr nz, .asm_e14d
.asm_e145
	cp $f
	jr nz, .asm_e150
	bit 7, h
	jr nz, .asm_e150
.asm_e14d
	ld hl, $0000
.asm_e150
	ld a, l
	ld [wd7b0], a
	ld a, h
	ld [wd7b1], a
	ld a, [wd7ae]
	ld c, a
	ld a, [wd7af]
	ld b, a
	add hl, bc
	bit 7, h
	jr nz, .asm_e16f
	ld a, h
	cp $10
	jr c, .asm_e172
	ld hl, $0f00
	jr .asm_e172

.asm_e16f
	ld hl, $0000
.asm_e172
	ld a, l
	ld [wd7ae], a
	ld a, h
	ld [wd7af], a
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ld hl, -$0333
	jr z, .asm_e18e
	ld a, [wd7be]
	and a
	jr nz, .asm_e18e
	ld hl,  $0333
.asm_e18e
	ld a, [wd7b3]
	and a
	jr nz, .asm_e198
	bit 7, h
	jr nz, .asm_e1a0
.asm_e198
	cp $f
	jr nz, .asm_e1a3
	bit 7, h
	jr nz, .asm_e1a3
.asm_e1a0
	ld hl, $0000
.asm_e1a3
	ld a, l
	ld [wd7b4], a
	ld a, h
	ld [wd7b5], a
	ld a, [wd7b2]
	ld c, a
	ld a, [wd7b3]
	ld b, a
	add hl, bc
	bit 7, h
	jr nz, .asm_e1c2
	ld a, h
	cp $10
	jr c, .asm_e1c5
	ld hl, $0f00
	jr .asm_e1c5

.asm_e1c2
	ld hl, $0000
.asm_e1c5
	ld a, l
	ld [wd7b2], a
	ld a, h
	ld [wd7b3], a
	ret

PlayFlipperSoundIfPressed: ; 0xe1ce
	ld a, [wd7be]
	and a
	ret nz
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_e1e2
	lb de, $00, $0c
	call PlaySoundEffect
	ret

.asm_e1e2
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	lb de, $00, $0c
	call PlaySoundEffect
	ret

CheckFlipperCollision: ; 0xe1f0
	ld a, [wBallXPos + 1]
	cp $50  ; which half of the screen is the ball in?
	jp nc, CheckRightFlipperCollision ; right half of screen
	; fall through
CheckLeftFlipperCollision:
	ld hl, wBallXPos
	ld c, $ba
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [wLeftFlipperAnimationState]
	ld [$ffc2], a
	ld a, [wd7af]
	ld [$ffc3], a
	call ReadFlipperCollisionAttributes
	ld a, [wFlipperCollision]
	and a
	ret z
	ld a, [wd7b0]
	ld [$ffc0], a
	ld a, [wd7b1]
	ld [$ffc1], a
	ret

CheckRightFlipperCollision: ; 0xe226
; ball is in right half of screen
	ld hl, wBallXPos
	ld c, $ba
	ld a, [hli]
	sub $1
	cpl
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	sbc $a0
	cpl
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [wRightFlipperAnimationState]
	ld [$ffc2], a
	ld a, [wd7b3]
	ld [$ffc3], a
	call ReadFlipperCollisionAttributes
	ld a, [wFlipperCollision]
	and a
	ret z
	; collision with flipper occurred
	ld a, [wd7b4]
	ld [$ffc0], a
	ld a, [wd7b5]
	ld [$ffc1], a
	ret

ReadFlipperCollisionAttributes: ; 0xe25a
	ld a, [$ffbb]  ; ball x-position high byte
	sub $2b        ; check if ball is in x-position range of flippers
	ret c
	cp $30
	ret nc
	; ball is in x-position range of flippers
	ld [$ffbb], a  ; x offset of flipper horizontal range
	ld a, [$ffbd]  ; ball y-position high byte
	sub $7b        ; check if ball is in y-position range of flippers
	ret c
	cp $20
	ret nc
	; ball is in potential collision with flippers
	ld [$ffbd], a  ; y offset of flipper vertical range
	ld a, [$ffc2]  ; flipper animation state
.asm_e270
	push af
	ld l, $0
	ld h, a  ; multiply a by 0x600
	sla a
	sla h
	sla h
	add h
	ld h, a        ; hl = a * 0x600  (this is the length of the flipper collision attributes)
	ld a, [$ffbb]  ; x offset of flipper horizontal range
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
	rl b   ; bc = (x offset of flipper horizontal range) * 32
	; Each row of the flipper collision attributes is 32 bytes long.
	add hl, bc  ; hl points to the start of the row in the flipper collisoin attributes
	ld a, [$ffbd]  ; y offset of flipper vertical range
	ld c, a
	ld b, $0
	add hl, bc  ; hl points to the attribute byte in the flipper collision attributes
	ld d, h
	ld e, l  ; de points to the attribute byte in the flipper collision attributes
	ld a, h
	cp $40
	jr nc, .secondBank
	add $40
	ld h, a
	ld a, Bank(FlipperHorizontalCollisionAttributes)
	jr .readAttributeByte

.secondBank
	ld a, Bank(FlipperHorizontalCollisionAttributes2)
.readAttributeByte
	call ReadByteFromBank
	ld b, a
	and a
	jr nz, .collision
	; no collision
	pop af  ; a = flipper animation state(?)
	ld hl, $ffc3
	cp [hl]
	ret z
	jr c, .asm_e2be
	dec a
	jr .asm_e270

.asm_e2be
	inc a
	jr .asm_e270

.collision
	pop af  ; a = flipper animation state(?)
	ld a, b  ; a = collision attribute
	ld [hFlipperYCollisionAttribute], a
	ld h, d
	ld l, e
	ld a, h
	cp $20
	jr nc, .asm_e2d3
	add $60
	ld h, a
	ld a, Bank(FlipperVerticalCollisionAttributes)
	jr .asm_e2d8

.asm_e2d3
	add $20
	ld h, a
	ld a, Bank(FlipperVerticalCollisionAttributes2)
.asm_e2d8
	call ReadByteFromBank
	ld [wFlipperXCollisionAttribute], a
	ld a, $1
	ld [wFlipperCollision], a
	ret

Func_e2e4:
	ld a, c
	or b
	or l
	or h
	or e
	or d
	jr nz, .asm_e2f3
	ld a, [$ffba]
	ld e, a
	ld a, [$ffbb]
	ld d, a
	ret

.asm_e2f3
	ld a, d
	xor h
	push af
	bit 7, d
	jr z, .asm_e301
	ld a, e
	cpl
	ld e, a
	ld a, d
	cpl
	ld d, a
	inc de
.asm_e301
	bit 7, h
	jr z, .asm_e317
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc bc
	ld a, b
	or c
	jr nz, .asm_e317
	inc hl
.asm_e317
	push bc
	ld c, $11
	ld a, d
	or e
	jr nz, .asm_e324
	pop bc
	ld de, $7fff
	jr .asm_e36a

.asm_e324
	bit 7, d
	jr nz, .asm_e32f
	sla e
	rl d
	inc c
	jr .asm_e324

.asm_e32f
	ld a, c
	ld [$ff8c], a
	pop bc
	xor a
	ld [$ff8d], a
	ld [$ff8e], a
.asm_e338
	jr c, .asm_e344
	ld a, d
	cp h
	jr nz, .asm_e342
	ld a, e
	cp l
	jr z, .asm_e344
.asm_e342
	jr nc, .asm_e34b
.asm_e344
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	scf
.asm_e34b
	ld a, [$ff8d]
	rla
	ld [$ff8d], a
	ld a, [$ff8e]
	rla
	ld [$ff8e], a
	sla c
	rl b
	rl l
	rl h
	ld a, [$ff8c]
	dec a
	ld [$ff8c], a
	jr nz, .asm_e338
	ld a, [$ff8d]
	ld e, a
	ld a, [$ff8e]
	ld d, a
.asm_e36a
	pop af
	bit 7, a
	ret z
	ld a, e
	sub $1
	cpl
	ld e, a
	ld a, d
	sbc $0
	cpl
	ld d, a
	ret

Func_e379: ; 0xe379
	ld a, b
	xor d
	ld [$ffbe], a
	bit 7, b
	jr z, .asm_e388
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_e388
	bit 7, d
	jr z, .asm_e393
	ld a, e
	cpl
	ld e, a
	ld a, d
	cpl
	ld d, a
	inc de
.asm_e393
	push bc
	push de
	ld c, d
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld c, e
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld b, d
	call Func_e410
	pop de
	pop bc
	push hl
	ld b, e
	call Func_e410
	ld c, l
	ld l, h
	xor a
	ld h, a
	pop de
	add hl, de
	rl a
	pop de
	add hl, de
	jr nc, .asm_e3bf
	inc a
.asm_e3bf
	ld b, l
Data_e3c0:
	ld l, h
	ld h, a
	pop de
	add hl, de
	ld a, [$ffbe]
	bit 7, a
	ret z
	ld a, c
	sub $1
	cpl
	ld c, a
	ld a, b
	sbc $0
	cpl
	ld b, a
	ld a, l
	sbc $0
	cpl
	ld l, a
	ld a, h
	sbc $0
	cpl
	ld h, a
	ret

Func_e3de:
	push bc
	push de
	ld c, d
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld c, e
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld b, d
	call Func_e410
	pop de
	pop bc
	push hl
	ld b, e
	call Func_e410
	ld c, l
	ld l, h
	xor a
	ld h, a
	pop de
	add hl, de
	rl a
	pop de
	add hl, de
	jr nc, .asm_e40a
	inc a
.asm_e40a
	ld b, l
	ld l, h
	ld h, a
	pop de
	add hl, de
	ret

Func_e410: ; 0xe410
	ld a, b
	cp c
	jr nc, .asm_e416
	ld b, c
	ld c, a
.asm_e416
	ld h, $3e
	ld l, c
	ld e, [hl]
	inc h
	ld d, [hl]
	ld l, b
	ld a, [hl]
	dec h
	ld l, [hl]
	ld h, a
	add hl, de
	push af
	ld d, $3e
	ld a, b
	sub c
	ld e, a
	ld a, [de]
	ld c, a
	inc d
	ld a, [de]
	ld b, a
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	jr nc, .asm_e43c
	pop af
	ccf
	rr h
	rr l
	ret

.asm_e43c
	pop af
	rr h
	rr l
	ret

HandleFlipperCollision: ; 0xe442
; This is called when the ball is colliding with either the
; right or left flipper.
	ld a, $1
	ld [wd7e9], a
	xor a
	ld [wBallPositionPointerOffsetFromStageTopLeft], a
	ld [wBallPositionPointerOffsetFromStageTopLeft + 1], a
	ld [wCurCollisionAttribute], a
	ld [wd7f6], a
	ld [wd7f7], a
	ld a, [hFlipperYCollisionAttribute]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_e538
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [$ffc0]
	ld e, a
	ld a, [$ffc1]
	ld d, a
	sla e
	rl d
	sla e
	rl d  ; multiplied de by 4
	call Func_e379
	ld a, b
	ld [wFlipperYForce], a
	ld a, l
	ld [wFlipperYForce + 1], a
	ld a, [wBallXPos + 1]
	cp $50  ; which flipper did the ball hit?
	ld a, [wFlipperXCollisionAttribute]
	jr c, .asm_e48b
	cpl  ; invert the x collision attribute
	inc a
.asm_e48b
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7eb], a
	ld a, [wFlipperYForce + 1]
	bit 7, a
	ret z
	xor a
	ld [wFlipperYForce], a
	ld [wFlipperYForce + 1], a
	ret

DrawFlippers: ; 0xe4a1
	ld a, [wCurrentStage]
	and a
	ret z
	ld hl, FlippersOAMPixelOffsetData
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	push hl
	ld hl, LeftFlipperOAMIds
	ld a, [wd7af]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	cp $b
	jr nz, .asm_e4d6
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_e4d4
	ld a, [wd7be]
	and a
	jr z, .asm_e4d4
	ld a, $18
	jr .asm_e4d6

.asm_e4d4
	ld a, $b
.asm_e4d6
	call LoadOAMData
	pop hl
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	ld hl, RightFlipperOAMIds
	ld a, [wd7b3]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	cp $8
	jr nz, .asm_e506
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_e504
	ld a, [wd7be]
	and a
	jr z, .asm_e504
	ld a, $17
	jr .asm_e506

.asm_e504
	ld a, $8
.asm_e506
	call LoadOAMData
	ret

FlippersOAMPixelOffsetData:
; flipper oam pixel offsets
	dw $7b38 ; left flipper
	dw $7b68 ; right flipper

LeftFlipperOAMIds:
; TODO: Don't know how exactly these are used, but it is used by the animation
; when the flipper is activated and rotates upward to hit the pinball.
	db $0b, $0b, $0b, $0b, $0b, $0b, $0b
	db $0c, $0c, $0c, $0c, $0c, $0c, $0c
	db $0d, $0d, $0d, $0d, $0d, $0d, $0d

RightFlipperOAMIds:
	db $08, $08, $08, $08, $08, $08, $08
	db $09, $09, $09, $09, $09, $09, $09
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A

Data_e538: ; 0xe538
	dw $0000
	dw $000C
	dw $001C
	dw $0030
	dw $0038
	dw $0048
	dw $005C
	dw $006C
	dw $0070
	dw $0080
	dw $0094
	dw $00A4
	dw $00B4
	dw $00C4
	dw $00D4
	dw $00E4
	dw $00F8
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC

LoadStageCollisionAttributes: ; 0xe578
	ld a, [wCurrentStage]
	sla a
	ld c, a
	ld b, $0
	ld hl, StageCollisionAttributesPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	and a
	jr z, .asm_e598
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	sla a
	add c
	ld c, a
	ld b, $0  ; bc = 6 * [wStageCollisionState]
	add hl, bc
.asm_e598
	ld de, wStageCollisionMapPointer
	ld b, $6
.asm_e59d
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_e59d
	call LoadCollisionAttributes
	ret

StageCollisionAttributesPointers: ; 0xe5a7
	dw StageRedFieldTopCollisionAttributesPointers
	dw StageRedFieldBottomCollisionAttributesPointers
	dw StageUnusedCollisionAttributesPointers
	dw StageUnused2CollisionAttributesPointers
	dw StageBlueFieldTopCollisionAttributesPointers
	dw StageBlueFieldBottomCollisionAttributesPointers
	dw StageGengarBonusCollisionAttributesPointers
	dw StageGengarBonusCollisionAttributesPointers
	dw StageMewtwoBonusCollisionAttributesPointers
	dw StageMewtwoBonusCollisionAttributesPointers
	dw StageMeowthBonusCollisionAttributesPointers
	dw StageMeowthBonusCollisionAttributesPointers
	dw StageDiglettBonusCollisionAttributesPointers
	dw StageDiglettBonusCollisionAttributesPointers
	dw StageSeelBonusCollisionAttributesPointers
	dw StageSeelBonusCollisionAttributesPointers

StageRedFieldTopCollisionAttributesPointers: ; 0xe5c7
	db $01  ; multiple pair entries
	dwb StageRedFieldTopCollisionAttributes0, Bank(StageRedFieldTopCollisionAttributes0)
	dwb StageRedFieldTopCollisionMasks0, Bank(StageRedFieldTopCollisionMasks0)
	dwb StageRedFieldTopCollisionAttributes1, Bank(StageRedFieldTopCollisionAttributes1)
	dwb StageRedFieldTopCollisionMasks0, Bank(StageRedFieldTopCollisionMasks0)
	dwb StageRedFieldTopCollisionAttributes2, Bank(StageRedFieldTopCollisionAttributes2)
	dwb StageRedFieldTopCollisionMasks1, Bank(StageRedFieldTopCollisionMasks1)
	dwb StageRedFieldTopCollisionAttributes3, Bank(StageRedFieldTopCollisionAttributes3)
	dwb StageRedFieldTopCollisionMasks1, Bank(StageRedFieldTopCollisionMasks1)
	dwb StageRedFieldTopCollisionAttributes4, Bank(StageRedFieldTopCollisionAttributes4)
	dwb StageRedFieldTopCollisionMasks2, Bank(StageRedFieldTopCollisionMasks2)
	dwb StageRedFieldTopCollisionAttributes5, Bank(StageRedFieldTopCollisionAttributes5)
	dwb StageRedFieldTopCollisionMasks2, Bank(StageRedFieldTopCollisionMasks2)
	dwb StageRedFieldTopCollisionAttributes6, Bank(StageRedFieldTopCollisionAttributes6)
	dwb StageRedFieldTopCollisionMasks3, Bank(StageRedFieldTopCollisionMasks3)
	dwb StageRedFieldTopCollisionAttributes7, Bank(StageRedFieldTopCollisionAttributes7)
	dwb StageRedFieldTopCollisionMasks3, Bank(StageRedFieldTopCollisionMasks3)

StageRedFieldBottomCollisionAttributesPointers: ; 0xe5f8
	db $00  ; single pair entry
	dwb StageRedFieldBottomCollisionAttributes, Bank(StageRedFieldBottomCollisionAttributes)
	dwb StageRedFieldBottomCollisionMasks, Bank(StageRedFieldBottomCollisionMasks)

StageUnusedCollisionAttributesPointers: ; 0xe5ff
; This entry is never used
	db $00

StageUnused2CollisionAttributesPointers: ; 0xe600
; This entry is never used
	db $00

StageBlueFieldTopCollisionAttributesPointers: ; 0xe601
	db $01  ; multiple pair entries
	dwb StageBlueFieldTopCollisionAttributesBallEntrance, Bank(StageBlueFieldTopCollisionAttributesBallEntrance)
	dwb StageBlueFieldTopCollisionMasks, Bank(StageBlueFieldTopCollisionMasks)
	dwb StageBlueFieldTopCollisionAttributes, Bank(StageBlueFieldTopCollisionAttributes)
	dwb StageBlueFieldTopCollisionMasks, Bank(StageBlueFieldTopCollisionMasks)

StageBlueFieldBottomCollisionAttributesPointers: ; 0xe60e
	db $00  ; single pair entry
	dwb StageBlueFieldBottomCollisionAttributes, Bank(StageBlueFieldBottomCollisionAttributes)
	dwb StageBlueFieldBottomCollisionMasks, Bank(StageBlueFieldBottomCollisionMasks)

StageGengarBonusCollisionAttributesPointers: ; 0xe615
	db $01  ; multiple pair entries
	dwb StageGengarBonusCollisionAttributesBallEntrance, Bank(StageGengarBonusCollisionAttributesBallEntrance)
	dwb StageGengarBonusCollisionMasks, Bank(StageGengarBonusCollisionMasks)
	dwb StageGengarBonusCollisionAttributes, Bank(StageGengarBonusCollisionAttributes)
	dwb StageGengarBonusCollisionMasks, Bank(StageGengarBonusCollisionMasks)

StageMewtwoBonusCollisionAttributesPointers: ; 0xe622
	db $01  ; multiple pair entries
	dwb StageMewtwoBonusCollisionAttributesBallEntrance, Bank(StageMewtwoBonusCollisionAttributesBallEntrance)
	dwb StageMewtwoBonusCollisionMasks, Bank(StageMewtwoBonusCollisionMasks)
	dwb StageMewtwoBonusCollisionAttributes, Bank(StageMewtwoBonusCollisionAttributes)
	dwb StageMewtwoBonusCollisionMasks, Bank(StageMewtwoBonusCollisionMasks)

StageMeowthBonusCollisionAttributesPointers: ; 0xe62f
	db $01  ; multiple pair entries
	dwb StageMeowthBonusCollisionAttributesBallEntrance, Bank(StageMeowthBonusCollisionAttributesBallEntrance)
	dwb StageMeowthBonusCollisionMasks, Bank(StageMeowthBonusCollisionMasks)
	dwb StageMeowthBonusCollisionAttributes, Bank(StageMeowthBonusCollisionAttributes)
	dwb StageMeowthBonusCollisionMasks, Bank(StageMeowthBonusCollisionMasks)

StageDiglettBonusCollisionAttributesPointers: ; 0xe63c
	db $01  ; multiple pair entries
	dwb StageDiglettBonusCollisionAttributesBallEntrance, Bank(StageDiglettBonusCollisionAttributesBallEntrance)
	dwb StageDiglettBonusCollisionMasks, Bank(StageDiglettBonusCollisionMasks)
	dwb StageDiglettBonusCollisionAttributes, Bank(StageDiglettBonusCollisionAttributes)
	dwb StageDiglettBonusCollisionMasks, Bank(StageDiglettBonusCollisionMasks)

StageSeelBonusCollisionAttributesPointers: ; 0xe649
	db $01  ; multiple pair entries
	dwb StageSeelBonusCollisionAttributesBallEntrance, Bank(StageSeelBonusCollisionAttributesBallEntrance)
	dwb StageSeelBonusCollisionMasks, Bank(StageSeelBonusCollisionMasks)
	dwb StageSeelBonusCollisionAttributes, Bank(StageSeelBonusCollisionAttributes)
	dwb StageSeelBonusCollisionMasks, Bank(StageSeelBonusCollisionMasks)

LoadCollisionAttributes: ; 0xe656
; Loads the stage's collision attributes into RAM
; Input:  [wStageCollisionMapPointer] = pointer to collision attributes map
;         [wStageCollisionMapBank] = ROM bank of collision attributes map
	ld hl, wStageCollisionMapPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wStageCollisionMapBank]
	ld de, wStageCollisionMap
	ld bc, $0300
	call FarCopyData
	ld hl, wStageCollisionMapPointer
	ld [hl], (wStageCollisionMap & $ff)
	inc hl
	ld [hl], (wStageCollisionMap >> 8)
	inc hl
	ld [hl], $0  ; Bank 0, because the data is in WRAM, so it doesn't matter which bank is saved
	ret

FieldVerticalTransition: ; 0xe674
	push af
	ld a, [wd548]
	push af
	xor a
	ld [wd548], a
	ld [wd803], a
	callba Func_84b7
	call CleanOAMBuffer
	pop af
	ld [wd548], a
	pop af
	ld [wCurrentStage], a
	xor a
	ld [hBGP], a
	ld [hOBP0], a
	ld [hOBP1], a
	rst AdvanceFrame
	call Func_e5d
	call Func_576
	call ClearOAMBuffer
	call Func_1129
	call LoadStageCollisionAttributes
	call Func_e6c2
	call Func_e5d
	call Func_588
	ld a, $e4
	ld [hBGP], a
	ld a, $e1
	ld [hOBP0], a
	ld a, $e4
	ld [hOBP1], a
	ret

Func_e6c2: ; 0xe6c2
	ld a, [wCurrentStage]
	bit 0, a
	ld a, $86
	jr z, .asm_e6d5
	ld a, [wd5ca]
	and a
	ld a, $86
	jr nz, .asm_e6d5
	ld a, $90
.asm_e6d5
	ld [hWY], a
	ld hl, StageGfxPointers_GameBoy
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .loadData
	ld hl, StageGfxPointers_GameBoyColor
.loadData
	ld a, [wCurrentStage]
	call LoadVideoData
	xor a
	ld [wd7f2], a
	callba Func_8471
	ret

StageGfxPointers_GameBoy: ; 0xe6f7
	dw StageRedFieldTopGfx_GameBoy
	dw StageRedFieldBottomGfx_GameBoy
	dw VideoData_e896
	dw VideoData_e8bd
	dw StageBlueFieldTopGfx_GameBoy
	dw StageBlueFieldBottomGfx_GameBoy
	dw StageGengarBonusGfx_GameBoy
	dw StageGengarBonusGfx_GameBoy
	dw StageMewtwoBonusGfx_GameBoy
	dw StageMewtwoBonusGfx_GameBoy
	dw StageMeowthBonusGfx_GameBoy
	dw StageMeowthBonusGfx_GameBoy
	dw StageDiglettBonusGfx_GameBoy
	dw StageDiglettBonusGfx_GameBoy
	dw StageSeelBonusGfx_GameBoy
	dw StageSeelBonusGfx_GameBoy

StageGfxPointers_GameBoyColor: ; 0xe717
	dw StageRedFieldTopGfx_GameBoyColor
	dw StageRedFieldBottomGfx_GameBoyColor
	dw VideoData_e8a6
	dw VideoData_e8d4
	dw StageBlueFieldTopGfx_GameBoyColor
	dw StageBlueFieldBottomGfx_GameBoyColor
	dw StageGengarBonusGfx_GameBoyColor
	dw StageGengarBonusGfx_GameBoyColor
	dw StageMewtwoBonusGfx_GameBoyColor
	dw StageMewtwoBonusGfx_GameBoyColor
	dw StageMeowthBonusGfx_GameBoyColor
	dw StageMeowthBonusGfx_GameBoyColor
	dw StageDiglettBonusGfx_GameBoyColor
	dw StageDiglettBonusGfx_GameBoyColor
	dw StageSeelBonusGfx_GameBoyColor
	dw StageSeelBonusGfx_GameBoyColor

StageRedFieldTopGfx_GameBoy: ; 0xe737
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   StageRedFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES   StageRedFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES   StageRedFieldTopStatusBarSymbolsGfx_GameBoy, vTilesSH, $100
	VIDEO_DATA_TILES   StageRedFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   StageRedFieldTopBaseGameBoyGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILEMAP StageRedFieldTopTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageRedFieldTopGfx_GameBoyColor: ; 0xe771
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageRedFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES         StageRedFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES         StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor, vTilesSH, $100
	VIDEO_DATA_TILES         StageRedFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         StageRedFieldTopBaseGameBoyColorGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx4, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx5, vTilesOB, $200
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx, vTilesOB + $200, $400
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx2, vTilesSH + $100, $200
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor, vTilesSH, $100
	VIDEO_DATA_TILEMAP       StageRedFieldTopTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageRedFieldTopTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageRedFieldTopPalettes, $80
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx6, vTilesOB + $7c0, $40
	db $FF, $FF  ; terminators

StageRedFieldBottomGfx_GameBoy: ; 0xe7ea
	VIDEO_DATA_TILES    Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES    StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES    StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES    StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES    StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES    StageRedFieldBottomBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES    SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILEMAP  StageRedFieldBottomTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageRedFieldBottomGfx_GameBoyColor: ; 0xe824
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES         StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES         StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         StageRedFieldBottomBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   StageRedFieldBottomGfx5, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES         SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx, vTilesOB + $200, $400
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx2, vTilesSH + $100, $200
	VIDEO_DATA_TILES_BANK2   StageRedFieldBottomBaseGameBoyColorGfx, vTilesSH, $100
	VIDEO_DATA_TILEMAP       StageRedFieldBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageRedFieldBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageRedFieldBottomPalettes, $80
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx6, vTilesOB + $7c0, $40
	db $FF, $FF  ; terminators

VideoData_e896: ; 0xe896
	VIDEO_DATA_TILES Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES PinballPokeballGfx, vTilesOB + $400, $200
	db $FF, $FF  ; terminators

VideoData_e8a6: ; 0xe8a6
	VIDEO_DATA_TILES       Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES       PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES_BANK2 TimerDigitsGfx, vTilesOB + $600, $160
	db $FF, $FF  ; terminators

VideoData_e8bd: ; 0xe8bd
	VIDEO_DATA_TILES Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES PinballPokeballShakeGfx, vTilesOB + $380, $480
	VIDEO_DATA_TILES SaverTextOffGfx, vTilesSH + $2a0, $40
	db $FF, $FF  ; terminators

VideoData_e8d4: ; 0xe8d4
	VIDEO_DATA_TILES       Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES       PinballPokeballShakeGfx, vTilesOB + $380, $480
	VIDEO_DATA_TILES_BANK2 TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES       SaverTextOffGfx, vTilesSH + $2a0, $40
	db $FF, $FF  ; terminators

StageBlueFieldTopGfx_GameBoy: ; 0xe8f2
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   StageBlueFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES   StageBlueFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES   StageBlueFieldTopStatusBarSymbolsGfx_GameBoy, vTilesSH, $100
	VIDEO_DATA_TILES   StageBlueFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   StageBlueFieldTopBaseGameBoyGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILEMAP StageBlueFieldTopTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageBlueFieldTopGfx_GameBoyColor: ; 0xe92c
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageBlueFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES         StageBlueFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES         StageBlueFieldTopStatusBarSymbolsGfx_GameBoyColor, vTilesSH, $100
	VIDEO_DATA_TILES         StageBlueFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         StageBlueFieldTopBaseGameBoyColorGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILES_BANK2   StageBlueFieldTopGfx4, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       StageBlueFieldTopTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageBlueFieldTopTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageBlueFieldTopPalettes, $80
	db $FF, $FF  ; terminators

StageBlueFieldBottomGfx_GameBoy: ; 0xe982
	VIDEO_DATA_TILES    Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES    StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES    StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES    StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES    StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES    StageBlueFieldBottomBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES    SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILEMAP  StageBlueFieldBottomTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageBlueFieldBottomGfx_GameBoyColor: ; 0xe9bc
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES         StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES         StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         StageBlueFieldBottomBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   StageBlueFieldBottomGfx1, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES         SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILEMAP       StageBlueFieldBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageBlueFieldBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageBlueFieldBottomPalettes, $80
	db $FF, $FF  ; terminators

StageGengarBonusGfx_GameBoy: ; 0xea12
	VIDEO_DATA_TILES       Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES       PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES       GengarBonusBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES       GengarBonusGastlyGfx, vTilesSH + $100, $180
	VIDEO_DATA_TILES_BANK  GengarBonusHaunterGfx + $180, Bank(GengarBonusHaunterGfx), vTilesSH + $280, $20
	VIDEO_DATA_TILES_BANK  GengarBonusHaunterGfx + $1a0, Bank(GengarBonusHaunterGfx), vTilesOB + $1a0, $100
	VIDEO_DATA_TILES       GengarBonusGengar1Gfx, vTilesOB + $2a0, $160
	VIDEO_DATA_TILES       GengarBonusGengar2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES       GengarBonusGengar3Gfx, vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILEMAP     GengarBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageGengarBonusGfx_GameBoyColor: ; 0xea5a
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         GengarBonusBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES         GengarBonusGastlyGfx, vTilesSH + $100, $180
	VIDEO_DATA_TILES_BANK    GengarBonusHaunterGfx + $180, Bank(GengarBonusHaunterGfx), vTilesSH + $280, $20
	VIDEO_DATA_TILES_BANK    GengarBonusHaunterGfx + $1a0, Bank(GengarBonusHaunterGfx), vTilesOB + $1a0, $100
	VIDEO_DATA_TILES         GengarBonusGengar1Gfx, vTilesOB + $2a0, $160
	VIDEO_DATA_TILES         GengarBonusGengar2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         GengarBonusGengar3Gfx, vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILES_BANK2   GengarBonus1Gfx, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       GengarBonusBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 GengarBonusBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      GengarBonusPalettes, $80
	db $FF, $FF  ; terminators

StageMewtwoBonusGfx_GameBoy: ; 0xeabe
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   MewtwoBonus1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   MewtwoBonus2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   MewtwoBonusBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES   MewtwoBonus3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   MewtwoBonus4Gfx, vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILEMAP MewtwoBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageMewtwoBonusGfx_GameBoyColor: ; 0xeaf8
	VIDEO_DATA_TILES   Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   MewtwoBonus1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   MewtwoBonus2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   MewtwoBonusBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES   MewtwoBonus3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   MewtwoBonus4Gfx, vTilesSH + $2a0, $2a0
	; Can't use a macro here because it's copying the tiles from VRAM, not ROM.
	dw vTilesOB
	db $20  ; This is an arbitrary bank, since the data is in VRAM, not ROM.
	dw vTilesSH
	dw $4002
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       MewtoBonusBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 MewtoBonusBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      MewtwoBonusPalettes, $80
	db $FF, $FF  ; terminators

StageMeowthBonusGfx_GameBoy: ; 0xeb4e
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   MeowthBonusMeowth1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   MeowthBonusMeowth2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   MeowthBonusBaseGameBoyGfx, vTilesSH, $a00
	VIDEO_DATA_TILES   MeowthBonusMeowth3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   MeowthBonusMeowth4Gfx, vTilesSH + $2a0, $360
	VIDEO_DATA_TILEMAP MeowthBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageMeowthBonusGfx_GameBoyColor: ; 0xeb88
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         MeowthBonusMeowth1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES         MeowthBonusMeowth2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         MeowthBonusBaseGameBoyColorGfx, vTilesSH, $900
	VIDEO_DATA_TILES         MeowthBonusMeowth3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         MeowthBonusMeowth4Gfx, vTilesSH + $2a0, $360
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       MeowthBonusTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 MeowthBonusTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      MeowthBonusPalettes, $80
	db $FF, $FF  ; terminators

StageDiglettBonusGfx_GameBoy: ; 0xebd7
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   DiglettBonusDugtrio1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   DiglettBonusDugtrio2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   DiglettBonusBaseGameBoyGfx, vTilesSH, $e00  ; $e00 is actually $100 too many bytes. Should only be $d00. This accidentally loads palette data after the tile graphics.
	VIDEO_DATA_TILES   DiglettBonusDugtrio3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   DiglettBonusDugtrio4Gfx, vTilesSH + $2a0, $280
	VIDEO_DATA_TILEMAP DiglettBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageDiglettBonusGfx_GameBoyColor: ; 0xec11
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         DiglettBonusDugtrio1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES         DiglettBonusDugtrio2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         DiglettBonusBaseGameBoyColorGfx, vTilesSH, $e00
	VIDEO_DATA_TILES         DiglettBonusDugtrio3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         DiglettBonusDugtrio4Gfx, vTilesSH + $2a0, $280
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       DiglettBonusTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 DiglettBonusTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      DiglettBonusPalettes, $80
	db $FF, $FF  ; terminators

StageSeelBonusGfx_GameBoy: ; 0xec60
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   SeelBonusSeel1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   SeelBonusSeel2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   SeelBonusBaseGameBoyGfx, vTilesSH, $d00  ; $d00 is actually $100 too many bytes. Should only be $c00. This accidentally loads palette data after the tile graphics.
	VIDEO_DATA_TILES   SeelBonusSeel3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   SeelBonusSeel4Gfx, vTilesSH + $2a0, $4a0
	VIDEO_DATA_TILEMAP SeelBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageSeelBonusGfx_GameBoyColor: ; 0xec9a
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         SeelBonusSeel1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES         SeelBonusSeel2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         SeelBonusBaseGameBoyColorGfx, vTilesSH, $b00  ; Should actually be $a00 bytes, not $b00
	VIDEO_DATA_TILES         SeelBonusSeel3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         SeelBonusSeel4Gfx, vTilesSH + $2a0, $4a0
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       SeelBonusTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 SeelBonusTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      SeelBonusPalettes, $80
	db $FF, $FF  ; terminators

CheckStageTransition: ; 0xece9
	call Func_ed5e
	ld a, [wBallYPos + 1]
	add $10
	cp $18
	jr c, .moving_up
	cp $b8
	ret c
	ld a, [wCurrentStage]
	ld c, a
	ld b, $0
	ld hl, BallMovingDownStageTransitions
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .rip
	call FieldVerticalTransition
	ld a, [wBallYPos + 1]
	sub $88
	ld [wBallYPos + 1], a
	ret

.moving_up
	ld a, [wCurrentStage]
	ld c, a
	ld b, $0
	ld hl, BallMovingUpStageTransitions
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .rip
	call FieldVerticalTransition
	ld a, [wBallYPos + 1]
	add $88
	ld [wBallYPos + 1], a
	ret

.rip
	ld a, $1
	ld [wd4ae], a
	callba HandleBallLoss
	ret

BallMovingUpStageTransitions: ; 0xed3e
; Maps the relationship between stages when
; the ball moves out of the screen upward.
	db $FF                   ; STAGE_RED_FIELD_TOP
	db STAGE_RED_FIELD_TOP   ; STAGE_RED_FIELD_BOTTOM
	db $FF
	db $02
	db $FF                   ; STAGE_BLUE_FIELD_TOP
	db STAGE_BLUE_FIELD_TOP  ; STAGE_BLUE_FIELD_BOTTOM
	db $FF                   ; STAGE_GENGAR_BONUS
	db $FF                   ; STAGE_GENGAR_BONUS
	db $FF                   ; STAGE_MEWTWO_BONUS
	db $FF                   ; STAGE_MEWTWO_BONUS
	db $FF                   ; STAGE_MEOWTH_BONUS
	db $FF                   ; STAGE_MEOWTH_BONUS
	db $FF                   ; STAGE_DIGLETT_BONUS
	db $FF                   ; STAGE_DIGLETT_BONUS
	db $FF                   ; STAGE_SEEL_BONUS
	db $FF                   ; STAGE_SEEL_BONUS

BallMovingDownStageTransitions: ; 0xed4e
; Maps the relationship between stages when
; the ball moves out of the screen downward.
	db STAGE_RED_FIELD_BOTTOM   ; STAGE_RED_FIELD_TOP
	db $FF                      ; STAGE_RED_FIELD_BOTTOM
	db $03
	db $FF
	db STAGE_BLUE_FIELD_BOTTOM  ; STAGE_BLUE_FIELD_TOP
	db $FF                      ; STAGE_BLUE_FIELD_BOTTOM
	db $FF                      ; STAGE_GENGAR_BONUS
	db $FF                      ; STAGE_GENGAR_BONUS
	db $FF                      ; STAGE_MEWTWO_BONUS
	db $FF                      ; STAGE_MEWTWO_BONUS
	db $FF                      ; STAGE_MEOWTH_BONUS
	db $FF                      ; STAGE_MEOWTH_BONUS
	db $FF                      ; STAGE_DIGLETT_BONUS
	db $FF                      ; STAGE_DIGLETT_BONUS
	db $FF                      ; STAGE_SEEL_BONUS
	db $FF                      ; STAGE_SEEL_BONUS

Func_ed5e: ; 0xed5e
	ld hl, wSCX
	ld a, [wd7ac]
	and a
	jr nz, .modify_scx_and_scy
	ld a, [wBallXPos + 1]
	cp $9a
	ld a,  2
	jr nc, .okay1
	ld a, -2
.okay1
	ld [wd7aa], a
	add [hl]
	cp $22
	jr z, .modify_scx_and_scy
	bit 7, a
	jr nz, .modify_scx_and_scy
	ld [hl], a
.modify_scx_and_scy
	ld a, [hl]
	ld hl, wd79f
	sub [hl]
	ld [hSCX], a
	xor a
	ld hl, wd7a0
	sub [hl]
	ld [hSCY], a
	ret

Func_ed8e: ; 0xed8e
	xor a
	ld [wd803], a
	ld [wd804], a
	ld [wd622], a
	ld a, [wNumPartyMons]
	ld [wd620], a
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeMultipliers
	add hl, bc
	ld a, [hl]
	ld [wd621], a
.asm_edac
	xor a
	ld [hJoypadState], a
	ld [hNewlyPressedButtons], a
	ld [hPressedButtons], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	ld [hFarCallTempA], a
	ld a, $3
	ld hl, HandleFlippers
	call nz, BankSwitch
	callba Func_84b7
	call Func_33e3
	call CleanOAMBuffer
	rst AdvanceFrame
	ld a, [wd7af]
	and a
	jr nz, .asm_edac
	ld a, [wd7b3]
	and a
	jr nz, .asm_edac
	ld a, [hGameBoyColorFlag]
	and a
	call nz, LoadGreyBillboardPaletteData
	call GenRandom
	and $f0
	ld [wd61a], a
	xor a
	ld [wd61b], a
	ld [wd61e], a
.asm_6df7
	ld a, [wd61a]
	ld c, a
	ld b, $0
	ld hl, Data_f339
	add hl, bc
	ld a, [wd619]
	add [hl]
	ld c, a
	ld hl, Data_f439
	add hl, bc
	ld a, [hli]
	bit 7, a
	jr nz, .asm_ee56
	call Func_eef9
	ld [wd61d], a
	push af
	lb de, $00, $09
	call PlaySoundEffect
	pop af
	call LoadBillboardOffPicture
	ld a, [wd61b]
	cp $a
	jr nc, .asm_ee29
	ld a, $a
.asm_ee29
	ld b, a
.asm_ee2a
	push bc
	call Func_eeee
	ld a, [wd61e]
	and a
	jr nz, .asm_ee47
	call Func_ef1e
	jr z, .asm_ee47
	ld [wd61e], a
	ld a, $32
	ld [wd61b], a
	lb de, $07, $28
	call PlaySoundEffect
.asm_ee47
	pop bc
	dec b
	jr nz, .asm_ee2a
	ld a, [wd61b]
	inc a
	ld [wd61b], a
	cp $3c
	jr z, .asm_ee69
.asm_ee56
	ld a, [wd61a]
	and $f0
	ld b, a
	ld a, [wd61a]
	inc a
	and $f
	or b
	ld [wd61a], a
	jp .asm_6df7

.asm_ee69
	ld a, [wd61d]
	cp $5
	jr nz, .asm_ee78
	lb de, $0c, $42
	call PlaySoundEffect
	jr .asm_ee7e

.asm_ee78
	lb de, $0c, $43
	call PlaySoundEffect
.asm_ee7e
	ld b, $28
.asm_ee80
	push bc
	rst AdvanceFrame
	pop bc
	call Func_ef1e
	jr nz, .asm_ee8b
	dec b
	jr nz, .asm_ee80
.asm_ee8b
	ld a, [hGameBoyColorFlag]
	and a
	ld a, [wd61d]
	call nz, Func_f2a0
	ld b, $80
.asm_ee96
	push bc
	ld a, b
	and $f
	jr nz, .asm_eeae
	bit 4, b
	jr z, .asm_eea8
	ld a, [wd61d]
	call LoadBillboardPicture
	jr .asm_eeae

.asm_eea8
	ld a, [wd61d]
	call LoadBillboardOffPicture
.asm_eeae
	rst AdvanceFrame
	pop bc
	call Func_ef1e
	jr nz, .asm_eeb8
	dec b
	jr nz, .asm_ee96
.asm_eeb8
	ld a, [wd619]
	add $a
	cp $fa
	jr nz, .asm_eec3
	ld a, $64
.asm_eec3
	ld [wd619], a
	ld a, [wd61d]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_eeca: ; 0xeeca
	dw Start30SecondSaverTimer
	dw Start60SecondSaverTimer
	dw Start90SecondSaverTimer
	dw Func_ef83
	dw Func_efa7
	dw Func_efb2
	dw Func_eff3
	dw Func_f034
	dw Func_f03a
	dw UpgradeBallBlueField
	dw UpgradeBallBlueField
	dw UpgradeBallBlueField
	dw SlotBonusMultiplier
	dw Func_f172
	dw Func_f172
	dw Func_f172
	dw Func_f172
	dw Func_f172

Func_eeee: ; 0xeeee
	push bc
	ld bc, $0200
.asm_eef2
	dec bc
	ld a, b
	or c
	jr nz, .asm_eef2
	pop bc
	ret

Func_eef9: ; 0xeef9
	cp $8
	jr nz, .asm_ef09
	ld a, [wd620]
	and a
	jr nz, .asm_ef06
	ld a, $7
	ret

.asm_ef06
	ld a, $8
	ret

.asm_ef09
	cp $9
	jr nz, .asm_ef14
	push hl
	ld hl, wd621
	add [hl]
	pop hl
	ret

.asm_ef14
	cp $d
	ret nz
	push hl
	ld hl, wd498
	add [hl]
	pop hl
	ret

Func_ef1e: ; 0xef1e
	push bc
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	jr nz, .asm_ef2d
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
.asm_ef2d
	pop bc
	ret

BallTypeMultipliers: ; 0xef2f
; Score multiplier for each ball type.
	db $00  ; POKE_BALL
	db $00
	db $01  ; GREAT_BALL
	db $02  ; ULTRA_BALL
	db $02
	db $02  ; MASTER_BALL

Start30SecondSaverTimer: ; 0xef35
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wd4a2], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 30
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret

Start60SecondSaverTimer: ; 0xef4f
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wd4a2], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 60
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret

Start90SecondSaverTimer: ; 0xef69
	ld a, $0
	ld [wBallSaverIconOn], a
	ld a, $ff
	ld [wd4a2], a
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, 90
	ld [wBallSaverTimerSeconds], a
	ld a, $2
	ld [wNumTimesBallSavedTextWillDisplay], a
	ret

Func_ef83: ; 0xef83
	ld a, $1
	ld [wd51d], a
	ld a, $f
	ld [wd517], a
	xor a
	ld [wd85d], a
	call Func_310a
	rst AdvanceFrame
	ld a, $0
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wd85d], a
	ret

Func_efa7: ; 0xefa7
	callba Func_30164
	ret

Func_efb2: ; 0xefb2
	ld a, $8
	call Func_a21
	ld [wCurSlotBonus], a
	ld b, $80
.asm_efbc
	push bc
	ld a, b
	and $f
	jr nz, .asm_efd8
	bit 4, b
	jr z, .asm_efd0
	ld a, [wCurSlotBonus]
	add (SmallReward100PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardPicture
	jr .asm_efd8

.asm_efd0
	ld a, [wCurSlotBonus]
	add (SmallReward100PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardOffPicture
.asm_efd8
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	and FLIPPERS
	jr nz, .asm_efe3
	dec b
	jr nz, .asm_efbc
.asm_efe3
	ld a, [wCurSlotBonus]
	inc a
	swap a
	ld e, a
	ld d, $0
	ld bc, $0000
	call AddBCDEToCurBufferValue
	ret

Func_eff3: ; 0xeff3
	ld a, $8
	call Func_a21
	ld [wCurSlotBonus], a
	ld b, $80
.asm_effd
	push bc
	ld a, b
	and $f
	jr nz, .asm_f019
	bit 4, b
	jr z, .asm_f011
	ld a, [wCurSlotBonus]
	add (BigReward1000000PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardPicture
	jr .asm_f019

.asm_f011
	ld a, [wCurSlotBonus]
	add (BigReward1000000PointsOnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardOffPicture
.asm_f019
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	and FLIPPERS
	jr nz, .asm_f024
	dec b
	jr nz, .asm_effd
.asm_f024
	ld a, [wCurSlotBonus]
	inc a
	swap a
	ld c, a
	ld b, $0
	ld de, $0000
	call AddBCDEToCurBufferValue
	ret

Func_f034: ; 0xf034
	ld a, $1
	ld [wd622], a
	ret

Func_f03a: ; 0xf03a
	ld a, $2
	ld [wd622], a
	ret

UpgradeBallBlueField: ; 0xf040
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
	ld a, [wBallType]
	cp MASTER_BALL
	jr z, .masterBall
	lb de, $06, $3a
	call PlaySoundEffect
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld de, FieldMultiplierText
	ld hl, wd5cc
	call LoadTextHeader
	; upgrade ball type
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgressionBlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .asm_f0b0

.masterBall
	lb de, $0f, $4d
	call PlaySoundEffect
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, DigitsText1to8
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, FieldMultiplierSpecialBonusText
	call LoadTextHeader
.asm_f0b0
	callba Func_155bb
	ret

BallTypeProgressionBlueField: ; 0xf0bb
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

SlotBonusMultiplier: ; 0xf0c1
	ld a, $4
	call Func_a21
	ld [wCurSlotBonus], a
	ld b, $80
.asm_f0cb
	push bc
	ld a, b
	and $f
	jr nz, .asm_f0e7
	bit 4, b
	jr z, .asm_f0df
	ld a, [wCurSlotBonus]
	add (BonusMultiplierX1OnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardPicture
	jr .asm_f0e7

.asm_f0df
	ld a, [wCurSlotBonus]
	add (BonusMultiplierX1OnPic_Pointer - BillboardPicturePointers) / 3
	call LoadBillboardOffPicture
.asm_f0e7
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	and FLIPPERS
	jr nz, .asm_f0f2
	dec b
	jr nz, .asm_f0cb
.asm_f0f2
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld [wd612], a
	ld a, [wd482]
	call .DivideBy25
	ld b, c
	ld a, [wCurSlotBonus]
	inc a
	ld hl, wd482
	add [hl]
	cp 100
	jr c, .asm_f113
	ld a, 99
.asm_f113
	ld [hl], a
	call .DivideBy25
	ld a, c
	cp b
	callba nz, Func_30164
	callba Func_16f95
	ld a, [wd60c]
	callba Func_f154 ; no need for BankSwitch here...
	ld a, [wd60d]
	add $14
	callba Func_f154 ; no need for BankSwitch here...
	ret

.DivideBy25: ; 0xf14a
	ld c, $0
.div_25
	cp 25
	ret c
	sub 25
	inc c
	jr .div_25

Func_f154: ; 0xf154
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_f15a: ; 0xf15a
	padded_dab Func_16f28
	padded_dab Func_16f28
	padded_dab Func_16f28
	padded_dab Func_16f28
	padded_dab Func_1d5f2
	padded_dab Func_1d5f2

Func_f172: ; 0xf172
	ld a, $1
	ld [wd623], a
	ret

LoadBillboardPicture: ; 0xf178
; Loads a billboard picture's tiles into VRAM
; input:  a = billboard picture id
	push hl
	ld c, a
	ld b, $0
	sla c
	add c  ; a has been multplied by 3 becuase entires in BillboardPicturePointers are 3 bytes long
	ld c, a
	ld hl, BillboardPicturePointers
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, b
	ld l, c
	ld de, vTilesSH tile $10   ; destination address to copy the tiles
	ld bc, $180    ; billboard pictures are $180 bytes
	call LoadVRAMData  ; loads the tiles into VRAM
	pop hl
	ret

LoadBillboardOffPicture: ; 0xf196
; Loads the dimly-lit "off" version of a billboard picture into VRAM
; Input:  a = billboard picture id
	push hl
	ld c, a
	ld b, $0
	sla c
	add c
	ld c, a
	ld hl, BillboardPicturePointers
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, b
	ld l, c
	ld bc, $0180  ; get the address of the "off" version of the picture
	add hl, bc
	ld de, vTilesSH tile $10
	ld bc, $0180
	call LoadVRAMData
	pop hl
	ret

INCLUDE "data/billboard/billboard_pic_pointers.asm"

LoadGreyBillboardPaletteData: ; 0xf269
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .loadPaletteMap
	ld a, BANK(StageRedFieldBottomBGPalette5) ; also used in blue stage
	ld hl, StageRedFieldBottomBGPalette5
	ld de, $0030
	ld bc, $0008
	call Func_7dc
.loadPaletteMap
	ld a, BANK(GreyBillboardPaletteMap)
	ld de, GreyBillboardPaletteMap
	hlCoord 7, 4, vBGMap
	call LoadBillboardPaletteMap
	ret

GreyBillboardPaletteMap:
	db $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06

Func_f2a0: ; 0xf2a0
	push hl
	ld c, a
	ld b, $0
	sla c
	add c
	ld c, a
	ld hl, PaletteDataPointerTable_f2be
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, b
	ld l, c
	ld de, $0030
	ld bc, $0010
	call Func_7dc
	pop hl
	ret

PaletteDataPointerTable_f2be: ; 0xf2be
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc10, Bank(PaletteData_dcc10)
	dwb PaletteData_dcc18, Bank(PaletteData_dcc18)
	dwb PaletteData_dcc20, Bank(PaletteData_dcc20)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc28, Bank(PaletteData_dcc28)
	dwb PaletteData_dcc08, Bank(PaletteData_dcc08)
	dwb PaletteData_dcc30, Bank(PaletteData_dcc30)
	dwb PaletteData_dcc38, Bank(PaletteData_dcc38)
	dwb PaletteData_dcc40, Bank(PaletteData_dcc40)
	dwb PaletteData_dcc48, Bank(PaletteData_dcc48)
	dwb PaletteData_dcc50, Bank(PaletteData_dcc50)
	dwb PaletteData_dcc58, Bank(PaletteData_dcc58)
	dwb PaletteData_dcc60, Bank(PaletteData_dcc60)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)
	dwb PaletteData_dcc00, Bank(PaletteData_dcc00)

Data_f339: ; 0xf339
	db $02, $06, $00, $08, $04, $02, $06, $08, $04, $00, $06, $02, $04, $08, $00, $02
	db $06, $02, $04, $08, $00, $06, $04, $08, $02, $00, $06, $08, $02, $00, $06, $08
	db $02, $04, $00, $08, $06, $04, $00, $02, $06, $04, $00, $08, $06, $04, $02, $08
	db $00, $08, $02, $04, $00, $08, $06, $02, $04, $00, $06, $08, $04, $00, $06, $02
	db $00, $08, $02, $04, $00, $08, $06, $04, $02, $08, $00, $06, $02, $08, $00, $06
	db $02, $00, $06, $04, $02, $00, $06, $08, $02, $04, $00, $06, $08, $04, $02, $06
	db $00, $02, $08, $04, $00, $02, $06, $04, $08, $02, $06, $00, $04, $08, $06, $02
	db $04, $08, $06, $02, $00, $08, $04, $06, $00, $02, $04, $06, $00, $02, $04, $08
	db $02, $00, $04, $06, $02, $00, $08, $04, $02, $00, $06, $04, $08, $00, $06, $04
	db $04, $00, $02, $08, $04, $06, $00, $08, $02, $04, $06, $08, $00, $04, $06, $02
	db $06, $08, $04, $02, $06, $00, $08, $02, $04, $00, $06, $02, $08, $04, $06, $02
	db $04, $06, $02, $00, $08, $04, $06, $00, $08, $02, $06, $00, $08, $02, $04, $00
	db $02, $00, $06, $04, $02, $08, $06, $00, $04, $08, $02, $00, $04, $06, $08, $00
	db $08, $06, $04, $00, $08, $06, $02, $00, $08, $06, $04, $00, $08, $06, $04, $02
	db $02, $00, $06, $04, $08, $02, $00, $04, $08, $02, $00, $04, $06, $02, $08, $00
	db $04, $06, $08, $02, $00, $06, $04, $08, $02, $06, $00, $08, $04, $06, $02, $08

Data_f439: ; 0xf439
	db $05, $19, $0C, $4C, $00, $4C, $03, $4C, $FF, $00, $05, $19, $0C, $4C, $00, $4C
	db $07, $4C, $FF, $00, $05, $19, $0C, $44, $00, $44, $03, $44, $06, $16, $05, $19
	db $0C, $4C, $00, $4C, $08, $4C, $FF, $00, $01, $4C, $06, $66, $0D, $4C, $FF, $00
	db $FF, $00, $05, $19, $0C, $4C, $00, $4C, $03, $4C, $FF, $00, $05, $19, $0C, $4C
	db $00, $4C, $07, $4C, $FF, $00, $05, $19, $0C, $44, $00, $44, $03, $44, $06, $16
	db $05, $19, $0C, $4C, $00, $4C, $08, $4C, $FF, $00, $01, $3F, $06, $3F, $0D, $3F
	db $09, $3F, $FF, $00, $05, $11, $0C, $4F, $00, $4F, $03, $4F, $FF, $00, $05, $11
	db $0C, $4F, $01, $4F, $07, $4F, $FF, $00, $05, $11, $0C, $44, $00, $44, $03, $44
	db $06, $1E, $05, $11, $0C, $4F, $01, $4F, $08, $4F, $FF, $00, $02, $66, $06, $4C
	db $0D, $4C, $FF, $00, $FF, $00, $05, $0A, $0C, $51, $00, $51, $03, $51, $FF, $00
	db $05, $0A, $0C, $51, $01, $51, $07, $51, $FF, $00, $05, $0A, $0C, $44, $00, $44
	db $03, $44, $06, $26, $05, $0A, $0C, $51, $01, $51, $08, $51, $FF, $00, $01, $3F
	db $06, $3F, $0D, $3F, $09, $3F, $FF, $00, $05, $0A, $0C, $51, $00, $51, $03, $51
	db $FF, $00, $05, $0A, $0C, $51, $01, $51, $07, $51, $FF, $00, $05, $0A, $0C, $44
	db $00, $44, $03, $44, $06, $26, $05, $0A, $0C, $51, $01, $51, $08, $51, $FF, $00
	db $01, $26, $06, $26, $0D, $26, $04, $8C, $FF, $00

Func_f533: ; 0xf533
	call FillBottomMessageBufferWithBlackTile
	call Func_f55c
	call Func_f57f
	ld a, $60
	ld [hWY], a
	dec a
	ld [hLYC], a
	ld a, $fd
	ld [hLCDCMask], a
	call Func_f5a0
	ld a, $90
	ld [hWY], a
	ld a, $83
	ld [hLYC], a
	ld [hLastLYC], a
	ld a, $ff
	ld [hLCDCMask], a
	call FillBottomMessageBufferWithBlackTile
	ret

Func_f55c: ; 0xf55c
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	ld a, BANK(GFX_d61c0)
	ld hl, GFX_d61c0
	ld de, vTilesSH tile $03
	ld bc, $0010
	call LoadVRAMData
	ret

.gameboyColor
	ld a, BANK(GFX_d63c0)
	ld hl, GFX_d63c0
	ld de, vTilesSH tile $03
	ld bc, $0010
	call LoadVRAMData
	ret

Func_f57f: ; 0xf57f
	xor a
	ld [wd4aa], a
	ld hl, wBottomMessageText
	ld a, $81
	ld b, $40
.clearLoop
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .clearLoop
	ld a, $0
	ld hl, wBottomMessageText
	ld de, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

Func_f5a0: ; 0xf5a0
	ld de, wBottomMessageText + $40
	ld hl, BonusPointsText
	call PrintTextNoHeader
	ld de, wBottomMessageText + $80
	ld hl, SubtotalPointsText
	call PrintTextNoHeader
	ld hl, wd489
	call Func_f8b5
	ld hl, wd48f
	call Func_f8b5
	ld a, $1
	ld [wd4ab], a
	call ValidateSignature6
	call Func_f64e
	call Func_f60a
	call Func_f676
	ld a, $1
	ld [wd4ab], a
	call Func_f70d
	ld a, [wGameOver]
	and a
	ret z
	ld a, $10
	call SetSongBank
	ld de, $0005
	call PlaySong
	ld hl, wBottomMessageText
	ld bc, $0040
	call Func_f81b
	ld de, wBottomMessageText + $20
	ld hl, GameOverText
	call PrintTextNoHeader
	ld bc, $0040
	ld de, $0000
	call Func_f80d
.asm_f602
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_f602
	ret

Func_f60a: ; 0xf60a
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_f60d: ; 0xf60d
	; STAGE_RED_FIELD_TOP
	dw Func_f945
	; STAGE_RED_FIELD_BOTTOM
	dw Func_f945
	dw Func_f9f2
	dw Func_f9f2
	; STAGE_BLUE_FIELD_TOP
	dw Func_f9f3
	; STAGE_BLUE_FIELD_BOTTOM
	dw Func_f9f3
	; STAGE_GENGAR_BONUS
	dw Func_faf6
	; STAGE_GENGAR_BONUS
	dw Func_faf6
	; STAGE_MEWTWO_BONUS
	dw Func_faf7
	; STAGE_MEWTWO_BONUS
	dw Func_faf7
	; STAGE_MEOWTH_BONUS
	dw Func_faf8
	; STAGE_MEOWTH_BONUS
	dw Func_faf8

ValidateSignature6: ; 0xf626
	ld de, wBottomMessageText + $01
	ld hl, NumPokemonCaughtText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $01
	ld a, [wd628]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd628
	ld de, PointsData_f921
	call Func_f853
	call Func_f824
	ret

Func_f64e: ; 0xf64e
	ld de, wBottomMessageText
	ld hl, NumPokemonEvolvedText
	call PrintTextNoHeader
	ld hl, wBottomMessageText
	ld a, [wd629]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd629
	ld de, PointsData_f927
	call Func_f853
	call Func_f824
	ret

Func_f676: ; 0xf676
	ld b, $4
.asm_f678
	push bc
	ld hl, wBottomMessageText + $20
	ld de, wBottomMessageText
	ld bc, $00e0
	call LocalCopyData
	ld bc, $00c0
	ld de, $0000
	call Func_f80d
	ld a, [wd4ab]
	and a
	jr z, .asm_f69f
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_f69f
	xor a
	ld [wd4ab], a
.asm_f69f
	pop bc
	dec b
	jr nz, .asm_f678
	ld de, wBottomMessageText + $40
	ld hl, MultiplierPointsText
	call PrintTextNoHeader
	ld de, wBottomMessageText + $80
	ld hl, TotalPointsText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $50
	ld a, [wd482]
	call Func_f78e
	ld bc, $0040
	ld de, $0040
	call Func_f80d
.asm_f6c7
	push de
	push hl
	ld hl, wd494
	ld de, wBottomMessageText + $86
	call Func_f8bd
	ld bc, $0040
	ld de, $0080
	call Func_f80d
	lb de, $00, $3e
	call PlaySoundEffect
	ld a, [wd4ab]
	and a
	jr z, .asm_f6f2
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_f6f2
	xor a
	ld [wd4ab], a
.asm_f6f2
	pop hl
	pop de
	ld a, [wd482]
	and a
	jr z, .asm_f709
	dec a
	ld [wd482], a
	ld hl, wd48f
	ld de, wd489
	call AddBigBCD6
	jr .asm_f6c7

.asm_f709
	call Func_f83a
	ret

Func_f70d: ; 0xf70d
	ld b, $4
.asm_f70f
	push bc
	ld hl, wBottomMessageText + $20
	ld de, wBottomMessageText
	ld bc, $00e0
	call LocalCopyData
	ld bc, $00c0
	ld de, $0000
	call Func_f80d
	ld a, [wd4ab]
	and a
	jr z, .asm_f736
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_f736
	xor a
	ld [wd4ab], a
.asm_f736
	pop bc
	dec b
	jr nz, .asm_f70f
	ld de, wBottomMessageText + $60
	ld hl, ScoreText
	call PrintTextNoHeader
	ld hl, wScore + $5
	ld de, wBottomMessageText + $66
	call Func_f8bd
	ld bc, $0040
	ld de, $0060
	call Func_f80d
	lb de, $00, $3e
	call PlaySoundEffect
	ld a, [wd4ab]
	and a
	jr z, .asm_f76c
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_f76c
	xor a
	ld [wd4ab], a
.asm_f76c
	ld hl, wScore
	ld de, wd48f
	call AddBigBCD6
	ld hl, wScore + $5
	ld de, wBottomMessageText + $66
	call Func_f8bd
	ld bc, $0040
	ld de, $0060
	call Func_f80d
	call Func_f83a
	call Func_f83a
	ret

Func_f78e: ; 0xf78e
	push hl
	call ConvertHexByteToDecWord
	pop hl
	ld c, $1
	ld a, d
	call .asm_f7a4
	inc hl
	ld a, e
	swap a
	call .asm_f7a4
	inc hl
	ld c, $0
	ld a, e
	; fall through
.asm_f7a4
	and $f
	jr nz, .asm_f7ab
	ld a, c
	and a
	ret nz
.asm_f7ab
	add $86
	ld [hl], a
	ld c, $0
	ret

PrintTextNoHeader: ; 0xf7b1
	ld a, [wd805]
	and a
	jr nz, .asm_f7e0
.loop
	ld a, [hli]
	and a
	ret z
	cp "0"
	jr c, .asm_f7c6
	cp "9" + 1
	jr nc, .asm_f7c6
	add $56
	jr .asm_f7dc

.asm_f7c6
	cp "A"
	jr c, .asm_f7d2
	cp "Z" + 1
	jr nc, .asm_f7d2
	add $bf
	jr .asm_f7dc

.asm_f7d2
	cp "e"
	jr nz, .asm_f7da
	ld a, $83
	jr .asm_f7dc

.asm_f7da
	ld a, $81
.asm_f7dc
	ld [de], a
	inc de
	jr .loop

.asm_f7e0
	ld a, [hli]
	and a
	ret z
	cp "0"
	jr c, .asm_f7ef
	cp "9" + 1
	jr nc, .asm_f7ef
	add $56
	jr .asm_f809

.asm_f7ef
	cp $a0
	jr c, .asm_f7fb
	cp $e0
	jr nc, .asm_f7fb
	sub $80
	jr .asm_f809

.asm_f7fb
	cp $e0
	jr c, .asm_f807
	cp $f4
	jr nc, .asm_f807
	sub $50
	jr .asm_f809

.asm_f807
	ld a, $81
.asm_f809
	ld [de], a
	inc de
	jr .asm_f7e0

Func_f80d: ; 0xf80d
	hlCoord 0, 0, vBGWin
	add hl, de
	push hl
	ld hl, wBottomMessageText
	add hl, de
	pop de
	call LoadVRAMData
	ret

Func_f81b: ; 0xf81b
	ld a, $81
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, Func_f81b
	ret

Func_f824: ; 0xf824
	call Func_f83a
	ld hl, wBottomMessageText
	ld bc, $0040
	call Func_f81b
	ld hl, wBottomMessageText + $48
	ld bc, $0038
	call Func_f81b
	ret

Func_f83a: ; 0xf83a
	ld a, [wd4ab]
	and a
	ret z
	ld b, $46
.asm_f841
	push bc
	rst AdvanceFrame
	pop bc
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr nz, .asm_f84e
	dec b
	jr nz, .asm_f841
	ret

.asm_f84e
	xor a
	ld [wd4ab], a
	ret

Func_f853: ; 0xf853
	push hl
	ld hl, wd483
	call Func_f8b5
	pop hl
.asm_f85b
	push de
	push hl
	ld hl, wd488
	ld de, wBottomMessageText + $46
	call Func_f8bd
	ld bc, $0040
	ld de, $0040
	call Func_f80d
	lb de, $00, $3e
	call PlaySoundEffect
	ld a, [wd4ab]
	and a
	jr z, .asm_f886
	rst AdvanceFrame
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_f886
	xor a
	ld [wd4ab], a
.asm_f886
	pop hl
	pop de
	ld a, [hl]
	and a
	jr z, .asm_f899
	dec [hl]
	push de
	push hl
	ld hl, wd483
	call AddBigBCD6
	pop hl
	pop de
	jr .asm_f85b

.asm_f899
	ld hl, wd489
	ld de, wd483
	call AddBigBCD6
	ld hl, wd48e
	ld de, wBottomMessageText + $86
	call Func_f8bd
	ld bc, $0040
	ld de, $0080
	call Func_f80d
	ret

Func_f8b5: ; 0xf8b5
	xor a
	ld b, $6
.asm_f8b8
	ld [hli], a
	dec b
	jr nz, .asm_f8b8
	ret

Func_f8bd: ; 0xf8bd
	ld bc, $0c01
.asm_f8c0
	ld a, [hl]
	swap a
	call Func_f8d5
	inc de
	dec b
	ld a, [hld]
	call Func_f8d5
	inc de
	dec b
	jr nz, .asm_f8c0
	ld a, $86
	ld [de], a
	inc de
	ret

Func_f8d5: ; 0xf8d5
	and $f
	jr nz, .asm_f8e0
	ld a, b
	dec a
	jr z, .asm_f8e0
	ld a, c
	and a
	ret nz
.asm_f8e0
	add $86
	ld [de], a
	ld c, $0
	ld a, b
	cp $c
	jr z, .asm_f8f5
	cp $9
	jr z, .asm_f8f5
	cp $6
	jr z, .asm_f8f5
	cp $3
	ret nz
.asm_f8f5
	push de
	ld a, e
	add $20
	ld e, a
	jr nc, .asm_f8fd
	inc d
.asm_f8fd
	ld a, $82
	ld [de], a
	pop de
	ret

AddBigBCD6: ; 0xf902
x = 0
rept 6
	ld a, [de]
if x == 0
	add [hl]
else
	adc [hl]
endc
x = x + 1
	daa
	ld [hli], a
	inc de
endr
	ret

PointsData_f921: ; 0xf921
	bigBCD6 50000
PointsData_f927: ; 0xf927
	bigBCD6 75000
PointsData_f92d: ; 0xf92d
	bigBCD6 7500
PointsData_f933: ; 0xf933
	bigBCD6 5000
PointsData_f939: ; 0xf939
	bigBCD6 2500
PointsData_f93f: ; 0xf93f
	bigBCD6 1000

Func_f945: ; 0xf945
	call Func_f952
	call Func_f97a
	call Func_f9a2
	call Func_f9ca
	ret

Func_f952: ; 0xf952
	ld de, wBottomMessageText + $03
	ld hl, BellsproutCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $03
	ld a, [wd62a]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd62a
	ld de, PointsData_f92d
	call Func_f853
	call Func_f824
	ret

Func_f97a: ; 0xf97a
	ld de, wBottomMessageText + $04
	ld hl, DugtrioCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $04
	ld a, [wd62b]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd62b
	ld de, PointsData_f933
	call Func_f853
	call Func_f824
	ret

Func_f9a2: ; 0xf9a2
	ld de, wBottomMessageText + $03
	ld hl, CaveShotCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $03
	ld a, [wd62c]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd62c
	ld de, PointsData_f939
	call Func_f853
	call Func_f824
	ret

Func_f9ca: ; 0xf9ca
	ld de, wBottomMessageText + $01
	ld hl, SpinnerTurnsCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $01
	ld a, [wd62d]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd62d
	ld de, PointsData_f93f
	call Func_f853
	call Func_f824
	ret

Func_f9f2: ; 0xf9f2
	ret

Func_f9f3: ; 0xf9f3
	call Func_fa06
	call Func_fa2e
	call Func_fa56
	call Func_fa7e
	call Func_faa6
	call Func_face
	ret

Func_fa06: ; 0xfa06
	ld de, wBottomMessageText + $04
	ld hl, CloysterCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $04
	ld a, [wd63b]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd63b
	ld de, PointsData_f92d
	call Func_f853
	call Func_f824
	ret

Func_fa2e: ; 0xfa2e
	ld de, wBottomMessageText + $04
	ld hl, SlowpokeCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $04
	ld a, [wd63a]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd63a
	ld de, PointsData_f92d
	call Func_f853
	call Func_f824
	ret

Func_fa56: ; 0xfa56
	ld de, wBottomMessageText + $04
	ld hl, PoliwagCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $04
	ld a, [wd63d]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd63d
	ld de, PointsData_f933
	call Func_f853
	call Func_f824
	ret

Func_fa7e: ; 0xfa7e
	ld de, wBottomMessageText + $04
	ld hl, PsyduckCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $04
	ld a, [wd63c]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd63c
	ld de, PointsData_f933
	call Func_f853
	call Func_f824
	ret

Func_faa6: ; 0xfaa6
	ld de, wBottomMessageText + $03
	ld hl, CaveShotCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $03
	ld a, [wd62c]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd62c
	ld de, PointsData_f939
	call Func_f853
	call Func_f824
	ret

Func_face: ; 0xface  :)
	ld de, wBottomMessageText + $01
	ld hl, SpinnerTurnsCounterText
	call PrintTextNoHeader
	ld hl, wBottomMessageText + $01
	ld a, [wd62d]
	call Func_f78e
	ld bc, $0040
	ld de, $0000
	call Func_f80d
	ld hl, wd62d
	ld de, PointsData_f93f
	call Func_f853
	call Func_f824
	ret

Func_faf6: ; 0xfaf6
	ret

Func_faf7: ; 0xfaf7
	ret

Func_faf8: ; 0xfaf8
	ret

; XXX
	ret

; XXX
	ret

SECTION "bank4", ROMX, BANK[$4]

Func_10000: ; 0x10000
	ld c, a
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, c
	ld [wd54c], a
	ld a, [wSpecialMode]
	cp $1
	jp z, Func_10a95
	cp $2
	jr nz, .asm_10021
	callba Func_301ce
	ret

.asm_10021
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_10027: ; 0x10027
	; STAGE_RED_FIELD_TOP
	padded_dab Func_20000
	; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_20000
	padded_dab Func_20000
	padded_dab Func_20000
	; STAGE_BLUE_FIELD_TOP
	padded_dab Func_202bc
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab Func_202bc

StartCatchEmMode: ; 0x1003f
	ld a, [wInSpecialMode]  ; current game mode?
	and a
	ret nz  ; don't start catch 'em mode if we're already doing something like Map Move mode
	ld a, $1
	ld [wInSpecialMode], a  ; set special mode flag
	xor a
	ld [wSpecialMode], a
	ld [wd54d], a
	ld a, [wCurrentStage]
	sla a
	ld c, a
	ld b, $0
	push bc
	ld hl, WildMonOffsetsPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurrentMap]
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	pop de
	ld hl, WildMonPointers
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	call GenRandom
	and $f
	call CheckForMew
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wRareMonsFlag]  ; this gets set to $08 when the rare mons should be used.
	sla a
	ld c, a
	add hl, bc
	ld a, [hl]  ; a contains mon id
	dec a
	ld [wCurrentCatchEmMon], a
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, EvolutionLineIds
	add hl, bc
	ld c, [hl]
	ld h, b
	ld l, c
	add hl, bc
	add hl, bc  ; multiply the evolution line id by 3
	ld bc, Data_13685
	add hl, bc
	ld a, [hli]
	ld [wd5c1], a
	ld [wd5be], a
	ld a, [hli]
	ld [wd5c2], a
	ld a, [hli]
	ld [wd5c3], a
	ld hl, wd586
	ld a, [wd5b6]
	ld c, a
	and a
	ld b, $18
	jr z, .asm_100c7
.asm_100ba
	ld a, $1
	ld [hli], a
	xor a
	ld [hli], a
	dec b
	dec c
	jr nz, .asm_100ba
	ld a, b
	and a
	jr z, .asm_100ce
.asm_100c7
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
	ld hl, CatchEmTimerData
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
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
	; STAGE_RED_FIELD_TOP
	dw Func_10871
	; STAGE_RED_FIELD_BOTTOM
	dw Func_10871
	dw Func_1098a
	dw Func_1098a
	; STAGE_BLUE_FIELD_TOP
	dw Func_1098c
	; STAGE_BLUE_FIELD_BOTTOM
	dw Func_1098c

CheckForMew:
; Sets the encountered mon to Mew if the following conditions are met:
;   1. Random number in register a equals $f
;   2. The current map is Indigo Plateau (it does a roundabout way of checking this)
;   3. The right alley has been hit three times
;   4. The Mewtwo Bonus Stage completion counter equals 2.
	push af
	cp $f  ; random number equals $f
	jr nz, .asm_10155
	ld a, c
	cp $60  ; check if low-byte of map mons offset is Indigo Plateau
	jr nz, .asm_10155
	ld a, b
	cp $1  ; check if high-byte of map mons offset is Indigo Plateau
	jr nz, .asm_10155
	ld a, [wRareMonsFlag]
	cp $8
	jr nz, .asm_10155
	ld a, [wNumMewtwoBonusCompletions]
	cp $2
	jr nz, .asm_10155
	pop af
	xor a
	ld [wNumMewtwoBonusCompletions], a
	ld a, $10
	ret

.asm_10155
	pop af
	ret

Func_10157: ; 0x10157
	xor a
	ld [wInSpecialMode], a
	ld [wWildMonIsHittable], a
	ld [wd5c6], a
	ld [wd5b6], a
	ld [wNumMonHits], a
	call Func_10488
	callba Func_86d2
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_10178: ; 0x10178
	; STAGE_RED_FIELD_TOP
	dw Func_108f5
	; STAGE_RED_FIELD_BOTTOM
	dw Func_108f5
	dw Func_1098b
	dw Func_1098b
	; STAGE_BLUE_FIELD_TOP
	dw Func_109fc
	; STAGE_BLUE_FIELD_BOTTOM
	dw Func_109fc

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
	ld de, Func_1266
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
	ld de, Func_1266
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

Func_10464: ; 0x10464
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

Func_10488: ; 0x10488
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
	ld a, BANK(GFX_a8800)
	ld hl, GFX_a8800
	ld de, vTilesSH tile $10
	ld bc, $0180
	call LoadVRAMData
	call LoadShakeBallGfx
	ld hl, BallCaptureAnimationData
	ld de, wBallCaptureAnimationFrameCounter
	call CopyHLToDE
	ld a, $1
	ld [wCapturingMon], a
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	xor a
	ld [wd548], a
	ld [wd549], a
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
	ld de, wBallCaptureAnimationFrameCounter
	call UpdateAnimation
	ld a, [wBallCaptureAnimationFrameIndex]
	cp $1
	jr nz, .asm_1055d
	ld a, [wBallCaptureAnimationFrameCounter]
	cp $1
	jr nz, .asm_1055d
	xor a
	ld [wWildMonIsHittable], a
	ret

.asm_1055d
	ld a, [wBallCaptureAnimationFrameIndex]
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
	ld [wd4b4], a
	ld a, $40
	ld [wd4b6], a
	ld a, $80
	ld [wBallXVelocity], a
	xor a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld [wCapturingMon], a
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	callba RestoreBallSaverAfterCatchEmMode
	call Func_10157
	ld de, $0001
	call PlaySong
	ld hl, wd628
	call Func_e4a
	jr nc, .asm_105d1
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_105d1
	call SetPokemonOwnedFlag
	ld a, [wd624]
	cp $3
	ret z
	inc a
	ld [wd625], a
	ld a, $80
	ld [wd626], a
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
	ld hl, wd5cc
	ld de, LetsGetPokemonText
	call LoadTextHeader
	ret

Func_106a6: ; 0x106a6
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, PokemonRanAwayText
	call LoadTextHeader
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
	ld hl, wd5cc
	pop de
	call LoadTextHeader
	ld hl, wd5d4
	pop de
	call LoadTextHeader
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
	ld a, [wd5db]
	add b
	ld [wd5db], a
	ld a, $14
	sub b
	srl a
	ld b, a
	ld a, [wd5d8]
	add b
	ld [wd5d8], a
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

Func_107a5: ; 0x107a5
	xor a
	ld hl, wIndicatorStates
	ld b, $13
.asm_107ab
	ld [hli], a
	dec b
	jr nz, .asm_107ab
	ret

Func_107b0: ; 0x107b0
	xor a
	ld [wd604], a
	ld [wIndicatorStates + 4], a
	callba Func_16425
	ret

Func_107c2: ; 0x107c2
	ld a, $1e
	ld [wd607], a
	ret

Func_107c8: ; 0x107c8
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
	ld hl, wd5e9
	ld de, Data_2a50
	call Func_3372
	pop de
	pop bc
	ld hl, wd5e4
	ld de, JackpotText
	call Func_3357
	ret

Func_10848: ; 0x10848
	ld bc, OneHundredMillionPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, OneBillionText
	call LoadTextHeader
	ld hl, wd5cc
	ld de, PokemonCaughtSpecialBonusText
	call LoadTextHeader
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
	callba Func_159f4
	ret

.asm_108d3
	callba Func_14135
	callba Func_10184
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_108f5: ; 0x108f5
	call Func_107a5
	call Func_107c2
	call Func_107c8
	call Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_14135
	call Func_10432
	callba Func_30253
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
	ld hl, Data_10958
	ld a, BANK(Data_10958)
	call Func_10aa
	ld a, [wd624]
	callba Func_174d4
	ld hl, Data_1097d
	ld a, BANK(Data_1097d)
	call Func_10aa
	ret

Data_10958:
	db 3
	dw Data_1095f
	dw Data_10969
	dw Data_10973

Data_1095f:
	dr $1095f, $10969
Data_10969:
	dr $10969, $10973
Data_10973:
	dr $10973, $1097d

Data_1097d:
	db 1
	dw Data_10980

Data_10980:
	dr $10980, $1098a

Func_1098a: ; 0x1098a
	ret

Func_1098b: ; 0x1098b
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
	callba Func_1f2ed
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
	call Func_107a5
	call Func_107c2
	callba Func_1f2ff
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	call Func_10432
	callba Func_30253
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
	ld hl, Data_10a63
	ld a, BANK(Data_10a63)
	call Func_10aa
	ld a, [wd624]
	callba Func_174d4
	ld hl, Data_10a88
	ld a, BANK(Data_10a88)
	call Func_10aa
	ret

Data_10a63:
	db 3
	dw Data_10a6a
	dw Data_10a74
	dw Data_10a7e

Data_10a6a:
	dr $10a6a, $10a74
Data_10a74:
	dr $10a74, $10a7e
Data_10a7e:
	dr $10a7e, $10a88

Data_10a88:
	db 1
	dw Data_10a8b

Data_10a8b:
	dr $10a8b, $10a95

Func_10a95: ; 0x19a95
	ld a, [wCurrentStage]
	call CallInFollowingTable
PointerTable_10a9b: ; 0x10a9b
	; STAGE_RED_FIELD_TOP
	padded_dab Func_20581
	; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_20581
	padded_dab Func_20581
	padded_dab Func_20581
	; STAGE_BLUE_FIELD_TOP
	padded_dab Func_20bae
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab Func_20bae

Func_10ab3: ; 0x10ab3
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_10abc: ; 0x10abc
	; STAGE_RED_FIELD_TOP
	dw Func_10ebb
	; STAGE_RED_FIELD_BOTTOM
	dw Func_10ebb
	dw Func_11054
	dw Func_11054
	; STAGE_BLUE_FIELD_TOP
	dw Func_11061
	; STAGE_BLUE_FIELD_BOTTOM
	dw Func_11061

Func_10ac8: ; 0x10ac8
	xor a
	ld [wd5ca], a
	call FillBottomMessageBufferWithBlackTile
	xor a
	ld [wInSpecialMode], a
	ld [wWildMonIsHittable], a
	ld [wd5b6], a
	ld [wNumMonHits], a
	ld [wd551], a
	ld [wd554], a
	call Func_10488
	callba Func_86d2
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_10af3: ; 0x10af3
	; STAGE_RED_FIELD_TOP
	dw Func_10fe3
	; STAGE_RED_FIELD_BOTTOM
	dw Func_10fe3
	dw Func_11060
	dw Func_11060
	; STAGE_BLUE_FIELD_TOP
	dw Func_11195
	; STAGE_BLUE_FIELD_TOP
	dw Func_11195

Func_10aff: ; 0x10aff
	ld a, [wCurrentStage]
	res 0, a
	ld c, a
	ld b, $0
	srl c
	sla a
	sla a
	sla a
	sub c
	ld c, a
	ld hl, VideoData_10b2a
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push af
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	pop af
	call LoadVRAMData
	ret

VideoData_10b2a: ; 0x10b2a
	dab StageRedFieldTopGfx3
	dw $8900
	dw $E0
	dab StageRedFieldTopGfx3
	dw $8900
	dw $E0
	dab StageRedFieldTopGfx3
	dw $8900
	dw $E0

Func_10b3f: ; 0x10b3f
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, StartTrainingText
	jr z, .asm_10b55
	ld de, FindItemsText
.asm_10b55
	call LoadTextHeader
	ret

Func_10b59: ; 0x10b59
	xor a
	ld [wd4aa], a
	ld hl, wBottomMessageText
	ld a, $81
	ld b, $30
.asm_10b64
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_10b64
	ld hl, wPartyMons
	call Func_10b8e
	ld a, BANK(InGameMenuSymbolsGfx)
	ld hl, InGameMenuSymbolsGfx
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
	ld a, $0
	ld hl, wBottomMessageText
	deCoord 0, 0, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

Func_10b8e: ; 0x10b8e
	ld a, [wNumPartyMons]
	ld c, $0
	ld b, a
.asm_10b94
	ld a, [hli]
	call Func_10ba2
	inc c
	ld a, c
	cp $6
	jr z, .asm_10ba1
	dec b
	jr nz, .asm_10b94
.asm_10ba1
	ret

Func_10ba2: ; 0x10ba2
	push bc
	push hl
	swap c
	sla c
	ld b, $0
	ld hl, wBottomMessageText
	add hl, bc
	ld d, h
	ld e, l
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
	ld hl, PokemonNames
	add hl, bc
	ld a, $81
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	ld a, $81
	ld [de], a
	inc de
	call Func_3125
.asm_10bda
	ld a, e
	and $1f
	cp $14
	jr nc, .asm_10be7
	ld a, $81
	ld [de], a
	inc de
	jr .asm_10bda

.asm_10be7
	pop hl
	pop bc
	ret

Func_10bea: ; 0x10bea
	xor a
	ld [wd461], a
	ld [wd462], a
	ld [wd463], a
.asm_10bf4
	call Func_10c0c
	call Func_b2e
	call Func_10c38
	rst AdvanceFrame
	ld a, [wd809]
	bit 0, a
	jr z, .asm_10bf4
	lb de, $00, $01
	call PlaySoundEffect
	ret

Func_10c0c: ; 0x10c0c
	ld a, [wd80a]
	ld b, a
	ld a, [wNumPartyMons]
	ld c, a
	ld a, [wd461]
	bit 6, b
	jr z, .asm_10c28
	and a
	ret z
	dec a
	ld [wd461], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

.asm_10c28
	bit 7, b
	ret z
	inc a
	cp c
	ret z
	ld [wd461], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

Func_10c38: ; 0x10c38
	ld a, [wd461]
	ld hl, wd462
	sub [hl]
	jr nc, .asm_10c45
	dec [hl]
	xor a
	jr .asm_10c4c

.asm_10c45
	cp $6
	jr c, .asm_10c4c
	inc [hl]
	ld a, $5
.asm_10c4c
	ld c, a
	push bc
	ld a, [hl]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	call Func_10b8e
	ld a, [hJoypadState]
	and a
	ld a, [wd463]
	jr z, .asm_10c62
	xor a
.asm_10c62
	inc a
	ld [wd463], a
	bit 3, a
	pop bc
	jr nz, .asm_10c78
	swap c
	sla c
	ld b, $0
	ld hl, wBottomMessageText + $03
	add hl, bc
	ld a, $88
	ld [hl], a
.asm_10c78
	ld a, [wd462]
	and a
	jr z, .asm_10c83
	ld a, $8a
	ld [wBottomMessageText + $11], a
.asm_10c83
	ld a, [wd462]
	add $7
	jr z, .asm_10c96
	ld c, a
	ld a, [wNumPartyMons]
	cp c
	jr c, .asm_10c96
	ld a, $89
	ld [wBottomMessageText + $b1], a
.asm_10c96
	ld a, $0
	ld hl, wBottomMessageText
	deCoord 0, 0, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

Func_10ca5: ; 0x10ca5
	ld a, [wd461]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [wCurrentEvolutionMon]
	cp $ff
	ret z
	ld [hl], a
	ret

Func_10cb7: ; 0x10cb7
	call FillBottomMessageBufferWithBlackTile
	call Func_10b59
	ld a, $60
	ld [hWY], a
	dec a
	ld [hLYC], a
	ld a, $fd
	ld [hLCDCMask], a
	call Func_10bea
	ld a, $86
	ld [hWY], a
	ld a, $83
	ld [hLYC], a
	ld [hLastLYC], a
	ld a, $ff
	ld [hLCDCMask], a
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_10cee
	ld a, BANK(StageRedFieldTopStatusBarSymbolsGfx_GameBoy)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoy + $80
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
	jr .asm_10cfc

.asm_10cee
	ld a, BANK(StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor + $80
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
.asm_10cfc
	call FillBottomMessageBufferWithBlackTile
	ld a, $1
	ld [wd4aa], a
	ld [wInSpecialMode], a
	ld [wSpecialMode], a
	xor a
	ld [wd54d], a
	ld a, [wd461]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [hl]
	ld [wCurrentCatchEmMon], a
	ret

Func_10d1d: ; 0x10d1d
	ld hl, wd586
	ld b, $18
.asm_10d22
	ld a, $1
	ld [hli], a
	xor a
	ld [hli], a
	dec b
	jr nz, .asm_10d22
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, Data_1298b
	add hl, bc
	ld a, [hl]
	add $2
	ld [wd555], a
	xor a
	ld hl, wd566
	ld b, $13
.asm_10d40
	ld [hli], a
	dec b
	jr nz, .asm_10d40
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, CatchEmTimerData
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	callba StartTimer
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	sla c  ; multiply mon id by 6
	rl b
	add c
	ld c, a
	jr nc, .noCarry
	inc b
.noCarry
	sla c
	rl b
	ld hl, MonEvolutions
	add hl, bc
	push hl
	ld bc, $03ff
.countMonEvolutionsLoop
	ld a, [hli]
	and a
	jr z, .noEvolution
	inc c
.noEvolution
	inc hl
	dec b
	jr nz, .countMonEvolutionsLoop
	ld a, c
	cp $ff
	jr nz, .asm_10d8a
	xor a
.asm_10d8a
	call Func_a21
	sla a
	ld c, a
	pop hl
	add hl, bc  ; hl points to one of three entries in mon's evolution data
	ld a, [hli]  ; a = mon id of evolution
	dec a
	ld [wCurrentEvolutionMon], a
	ld a, [hl]  ; a = evoluion type id
	ld [wCurrentEvolutionType], a
	xor a
	ld [wd554], a
	ld [wd556], a
	ld [wd557], a
	ld hl, wd55c
	ld a, $1
	ld b, $3
.asm_10dac
	ld [hli], a
	dec b
	jr nz, .asm_10dac
	xor a
	ld b, $7
.asm_10db3
	ld [hli], a
	dec b
	jr nz, .asm_10db3
	ld de, wd55c
	ld a, [wd555]
	ld c, a
	inc a
	ld b, a
.asm_10dc0
	push bc
	ld a, c
	call Func_a21
	ld c, a
	ld b, $0
	ld hl, wd55c
	add hl, bc
	ld c, [hl]
	ld a, [de]
	ld [hl], a
	ld a, c
	ld [de], a
	pop bc
	inc de
	dec b
	jr nz, .asm_10dc0
	callba InitBallSaverForCatchEmMode
	call Func_10b3f
	call Func_3579
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_10e09
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
.asm_10e09
	ret

Func_10e0a: ; 0x10e0a
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jp z, Func_10e8b
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
	ld hl, PokemonNames + 1
	add hl, bc
	ld de, ItEvolvedIntoAnText  ; "It evolved into an"
	ld bc, Data_2b34
	ld a, [hl]
	; check if mon's name starts with a vowel, so it can print "an", instead of "a"
	cp "A"
	jr z, .nameStartsWithVowel
	cp "I"
	jr z, .nameStartsWithVowel
	cp "U"
	jr z, .nameStartsWithVowel
	cp "E"
	jr z, .nameStartsWithVowel
	cp "O"
	jr z, .nameStartsWithVowel
	ld de, ItEvolvedIntoAText  ; "It evolved into a"
	ld bc, Data_2b1c
.nameStartsWithVowel
	push hl
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	pop de
	call LoadTextHeader
	ld hl, wd5d4
	pop de
	call LoadTextHeader
	pop hl
	ld de, wBottomMessageText + $20
	ld b, $0
.asm_10e67
	ld a, [hli]
	and a
	jr z, .asm_10e70
	ld [de], a
	inc de
	inc b
	jr .asm_10e67

.asm_10e70
	ld a, $20
	ld [de], a
	inc de
	xor a
	ld [de], a
	ld a, [wd5db]
	add b
	ld [wd5db], a
	ld a, $14
	sub b
	srl a
	ld b, a
	ld a, [wd5d8]
	add b
	ld [wd5d8], a
	ret

Func_10e8b: ; 0x10e8b
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $0100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, Data_2b6b
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, EvolutionSpecialBonusText
	call LoadTextHeader
	ret

Func_10ebb: ; 0x10ebb
	ld a, [wNumPartyMons]
	and a
	ret z
	call Func_10cb7
	call Func_10d1d
	ld a, [wd555]
	sub $2
	ld c, a
	sla c
	ld hl, IndicatorStatesPointerTable_10f3b
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wIndicatorStates
	ld b, $13
.asm_10eda
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_10eda
	xor a
	ld [wLeftAlleyCount], a
	call Func_107b0
	ld a, $2
	ld [wd7ad], a
	ld de, $0002
	call PlaySong
	call SetPokemonSeenFlag
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_10f0b
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesSH tile $10
	ld bc, $00e0
	call LoadOrCopyVRAMData
	ret

.asm_10f0b
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadOrCopyVRAMData
	callba Func_14135
	callba Func_10184
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

IndicatorStatesPointerTable_10f3b: ; 0x10f3b
	dw IndicatorStates_10f4b
	dw IndicatorStates_10f5e
	dw IndicatorStates_10f71
	dw IndicatorStates_10f84
	dw IndicatorStates_10f97
	dw IndicatorStates_10faa
	dw IndicatorStates_10fbd
	dw IndicatorStates_10fd0

IndicatorStates_10f4b:  ; 0x10f4b
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00

IndicatorStates_10f5e:  ; 0x10f5e
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00

IndicatorStates_10f71:  ; 0x10f71
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_10f84:  ; 0x10f84
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_10f97:  ; 0x10f97
	db $00, $00, $00, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_10faa:  ; 0x10faa
	db $00, $00, $80, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_10fbd:  ; 0x10fbd
	db $00, $00, $80, $80, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_10fd0:  ; 0x10fd0
	db $00, $00, $80, $80, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

Func_10fe3: ; 0x10fe3
	call Func_107a5
	call Func_107c2
	call Func_107c8
	call Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	jp z, Func_10aff
	callba Func_14135
	callba Func_16425
	callba Func_30253
	ld a, BANK(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_11036
	ld a, BANK(StageRedFieldBottomOBJPalette7)
	ld hl, StageRedFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_11036
	ld hl, Data_10958
	ld a, BANK(Data_10958)
	call Func_10aa
	ld a, [wd624]
	callba Func_174d4
	ld hl, Data_1097d
	ld a, BANK(Data_1097d)
	call Func_10aa
	ret

Func_11054: ; 0x11054
	ld a, [wNumPartyMons]
	and a
	ret z
	call Func_10cb7
	call Func_10d1d
	ret

Func_11060: ; 0x11060
	ret

Func_11061: ; 0x11061
	ld a, [wNumPartyMons]
	and a
	ret z
	call Func_10cb7
	call Func_10d1d
	ld a, $1
	ld [wd643], a
	ld a, [wd555]
	sub $2
	ld c, a
	sla c
	ld hl, IndicatorStatesPointerTable_110ed
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wIndicatorStates
	ld b, $13
.asm_11085
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_11085
	xor a
	ld [wLeftAlleyCount], a
	callba Func_1f2ed
	ld a, $2
	ld [wd7ad], a
	ld de, $0002
	call PlaySong
	call SetPokemonSeenFlag
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_110bd
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesOB tile $60
	ld bc, $00e0
	call LoadOrCopyVRAMData
	ret

.asm_110bd
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadOrCopyVRAMData
	callba Func_1c2cb
	callba Func_10184
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

IndicatorStatesPointerTable_110ed: ; 0x110ed
	dw IndicatorStates_110fd
	dw IndicatorStates_11110
	dw IndicatorStates_11123
	dw IndicatorStates_11136
	dw IndicatorStates_11149
	dw IndicatorStates_1115c
	dw IndicatorStates_1116f
	dw IndicatorStates_11182

IndicatorStates_110fd: ; 0x110fd
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $01, $00, $00, $00, $00

IndicatorStates_11110: ; 0x11110
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01, $01, $00, $00, $00, $00

IndicatorStates_11123: ; 0x11123
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_11136: ; 0x11136
	db $00, $00, $80, $00, $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_11149: ; 0x11149
	db $00, $00, $80, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_1115c: ; 0x1115c
	db $00, $00, $80, $80, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_1116f: ; 0x1116f
	db $80, $00, $80, $80, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

IndicatorStates_11182: ; 0x11182
	db $80, $00, $80, $80, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

Func_11195: ; 0x11195
	xor a
	ld [wd643], a
	call Func_107a5
	call Func_107c2
	callba Func_1f2ff
	ld a, [wCurrentStage]
	bit 0, a
	jp z, Func_1120e
	callba Func_1c2cb
	callba Func_1e8f6
	callba Func_30253
	ld a, Bank(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_111f0
	ld a, BANK(StageBlueFieldBottomOBJPalette7)
	ld hl, StageBlueFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_111f0
	ld hl, Data_10a63
	ld a, BANK(Data_10a63)
	call Func_10aa
	ld a, [wd624]
	callba Func_174d4
	ld hl, Data_10a88
	ld a, BANK(Data_10a88)
	call Func_10aa
	ret

Func_1120e: ; 0x1120e
	ld a, [wCurrentStage]
	sub $4
	res 0, a
	ld c, a
	ld b, $0
	srl c
	sla a
	sla a
	sla a
	sub c
	ld c, a
	ld hl, VRAMData_1123b
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push af
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	pop af
	call LoadVRAMData
	ret

VRAMData_1123b: ; 0x1123b
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0
	dab StageBlueFieldTopGfx3
	dw $8600, $E0

INCLUDE "data/wild_mons.asm"
INCLUDE "data/evolution_line_starts.asm"
INCLUDE "data/evolution_lines.asm"
INCLUDE "data/evolution_methods.asm"
INCLUDE "data/mon_names.asm"
INCLUDE "data/mon_initial_indicator_states.asm"

Data_1298b: ; 0x1298b
	db $01  ; BULBASAUR
	db $02  ; IVYSAUR
	db $03  ; VENUSAUR
	db $01  ; CHARMANDER
	db $02  ; CHARMELEON
	db $03  ; CHARIZARD
	db $01  ; SQUIRTLE
	db $02  ; WARTORTLE
	db $03  ; BLASTOISE
	db $01  ; CATERPIE
	db $02  ; METAPOD
	db $03  ; BUTTERFREE
	db $01  ; WEEDLE
	db $02  ; KAKUNA
	db $03  ; BEEDRILL
	db $01  ; PIDGEY
	db $02  ; PIDGEOTTO
	db $03  ; PIDGEOT
	db $01  ; RATTATA
	db $03  ; RATICATE
	db $01  ; SPEAROW
	db $03  ; FEAROW
	db $01  ; EKANS
	db $03  ; ARBOK
	db $01  ; PIKACHU
	db $03  ; RAICHU
	db $01  ; SANDSHREW
	db $03  ; SANDSLASH
	db $01  ; NIDORAN_F
	db $02  ; NIDORINA
	db $04  ; NIDOQUEEN
	db $01  ; NIDORAN_M
	db $02  ; NIDORINO
	db $04  ; NIDOKING
	db $02  ; CLEFAIRY
	db $03  ; CLEFABLE
	db $02  ; VULPIX
	db $03  ; NINETALES
	db $02  ; JIGGLYPUFF
	db $03  ; WIGGLYTUFF
	db $02  ; ZUBAT
	db $03  ; GOLBAT
	db $01  ; ODDISH
	db $02  ; GLOOM
	db $04  ; VILEPLUME
	db $02  ; PARAS
	db $03  ; PARASECT
	db $02  ; VENONAT
	db $03  ; VENOMOTH
	db $02  ; DIGLETT
	db $03  ; DUGTRIO
	db $02  ; MEOWTH
	db $03  ; PERSIAN
	db $02  ; PSYDUCK
	db $03  ; GOLDUCK
	db $02  ; MANKEY
	db $03  ; PRIMEAPE
	db $02  ; GROWLITHE
	db $03  ; ARCANINE
	db $01  ; POLIWAG
	db $02  ; POLIWHIRL
	db $04  ; POLIWRATH
	db $01  ; ABRA
	db $02  ; KADABRA
	db $04  ; ALAKAZAM
	db $01  ; MACHOP
	db $02  ; MACHOKE
	db $04  ; MACHAMP
	db $01  ; BELLSPROUT
	db $02  ; WEEPINBELL
	db $04  ; VICTREEBEL
	db $02  ; TENTACOOL
	db $03  ; TENTACRUEL
	db $01  ; GEODUDE
	db $02  ; GRAVELER
	db $04  ; GOLEM
	db $02  ; PONYTA
	db $03  ; RAPIDASH
	db $02  ; SLOWPOKE
	db $03  ; SLOWBRO
	db $02  ; MAGNEMITE
	db $03  ; MAGNETON
	db $04  ; FARFETCH_D
	db $02  ; DODUO
	db $03  ; DODRIO
	db $02  ; SEEL
	db $03  ; DEWGONG
	db $02  ; GRIMER
	db $03  ; MUK
	db $02  ; SHELLDER
	db $03  ; CLOYSTER
	db $01  ; GASTLY
	db $02  ; HAUNTER
	db $04  ; GENGAR
	db $04  ; ONIX
	db $02  ; DROWZEE
	db $03  ; HYPNO
	db $02  ; KRABBY
	db $03  ; KINGLER
	db $02  ; VOLTORB
	db $03  ; ELECTRODE
	db $02  ; EXEGGCUTE
	db $03  ; EXEGGUTOR
	db $02  ; CUBONE
	db $03  ; MAROWAK
	db $04  ; HITMONLEE
	db $04  ; HITMONCHAN
	db $04  ; LICKITUNG
	db $02  ; KOFFING
	db $03  ; WEEZING
	db $02  ; RHYHORN
	db $03  ; RHYDON
	db $04  ; CHANSEY
	db $04  ; TANGELA
	db $04  ; KANGASKHAN
	db $04  ; HORSEA
	db $04  ; SEADRA
	db $02  ; GOLDEEN
	db $03  ; SEAKING
	db $02  ; STARYU
	db $03  ; STARMIE
	db $04  ; MR_MIME
	db $04  ; SCYTHER
	db $04  ; JYNX
	db $04  ; ELECTABUZZ
	db $04  ; MAGMAR
	db $04  ; PINSIR
	db $04  ; TAUROS
	db $02  ; MAGIKARP
	db $03  ; GYARADOS
	db $04  ; LAPRAS
	db $04  ; DITTO
	db $02  ; EEVEE
	db $03  ; VAPOREON
	db $03  ; JOLTEON
	db $03  ; FLAREON
	db $04  ; PORYGON
	db $02  ; OMANYTE
	db $03  ; OMASTAR
	db $02  ; KABUTO
	db $03  ; KABUTOPS
	db $04  ; AERODACTYL
	db $04  ; SNORLAX
	db $04  ; ARTICUNO
	db $04  ; ZAPDOS
	db $04  ; MOLTRES
	db $01  ; DRATINI
	db $02  ; DRAGONAIR
	db $04  ; DRAGONITE
	db $04  ; MEWTWO
	db $06  ; MEW

INCLUDE "data/catchem_timer_values.asm"
INCLUDE "data/mon_gfx/mon_gfx_pointers.asm"
INCLUDE "data/mon_animated_sprite_types.asm"
INCLUDE "data/collision/mon_collision_mask_pointers.asm"

Data_13685: ; 0x13685
; Each 3-byte entry is related to an evolution line. Don't know what this is for, yet.
	db $12, $12, $10 ; EVOLINE_BULBASAUR
	db $10, $10, $10 ; EVOLINE_CHARMANDER
	db $12, $12, $0E ; EVOLINE_SQUIRTLE
	db $14, $14, $12 ; EVOLINE_CATERPIE
	db $14, $14, $10 ; EVOLINE_WEEDLE
	db $0A, $0A, $0E ; EVOLINE_PIDGEY
	db $11, $13, $10 ; EVOLINE_RATTATA
	db $0B, $0B, $10 ; EVOLINE_SPEAROW
	db $12, $12, $0E ; EVOLINE_EKANS
	db $12, $14, $0E ; EVOLINE_PIKACHU
	db $10, $12, $10 ; EVOLINE_SANDSHREW
	db $11, $12, $0E ; EVOLINE_NIDORAN_F
	db $11, $12, $0E ; EVOLINE_NIDORAN_M
	db $12, $13, $10 ; EVOLINE_CLEFAIRY
	db $11, $11, $10 ; EVOLINE_VULPIX
	db $12, $12, $10 ; EVOLINE_JIGGLYPUFF
	db $08, $08, $10 ; EVOLINE_ZUBAT
	db $10, $10, $10 ; EVOLINE_ODDISH
	db $10, $10, $10 ; EVOLINE_PARAS
	db $11, $11, $0E ; EVOLINE_VENONAT
	db $10, $10, $0E ; EVOLINE_DIGLETT
	db $14, $14, $0E ; EVOLINE_MEOWTH
	db $30, $30, $10 ; EVOLINE_PSYDUCK
	db $12, $12, $10 ; EVOLINE_MANKEY
	db $12, $12, $10 ; EVOLINE_GROWLITHE
	db $10, $10, $10 ; EVOLINE_POLIWAG
	db $10, $10, $10 ; EVOLINE_ABRA
	db $12, $14, $10 ; EVOLINE_MACHOP
	db $10, $12, $10 ; EVOLINE_BELLSPROUT
	db $0C, $0C, $12 ; EVOLINE_TENTACOOL
	db $12, $14, $0C ; EVOLINE_GEODUDE
	db $12, $14, $0E ; EVOLINE_PONYTA
	db $30, $30, $10 ; EVOLINE_SLOWPOKE
	db $14, $14, $10 ; EVOLINE_MAGNEMITE
	db $12, $12, $0E ; EVOLINE_FARFETCH_D
	db $12, $12, $0E ; EVOLINE_DODUO
	db $14, $14, $0E ; EVOLINE_SEEL
	db $12, $12, $10 ; EVOLINE_GRIMER
	db $14, $14, $0E ; EVOLINE_SHELLDER
	db $10, $10, $0E ; EVOLINE_GASTLY
	db $12, $12, $10 ; EVOLINE_ONIX
	db $14, $14, $10 ; EVOLINE_DROWZEE
	db $14, $12, $10 ; EVOLINE_KRABBY
	db $02, $02, $10 ; EVOLINE_VOLTORB
	db $12, $12, $10 ; EVOLINE_EXEGGCUTE
	db $12, $12, $10 ; EVOLINE_CUBONE
	db $14, $10, $10 ; EVOLINE_HITMONLEE
	db $14, $10, $10 ; EVOLINE_HITMONCHAN
	db $14, $12, $10 ; EVOLINE_LICKITUNG
	db $11, $11, $10 ; EVOLINE_KOFFING
	db $14, $14, $10 ; EVOLINE_RHYHORN
	db $12, $12, $10 ; EVOLINE_CHANSEY
	db $10, $10, $10 ; EVOLINE_TANGELA
	db $12, $12, $10 ; EVOLINE_KANGASKHAN
	db $0F, $0F, $0E ; EVOLINE_HORSEA
	db $12, $12, $0E ; EVOLINE_GOLDEEN
	db $23, $23, $10 ; EVOLINE_STARYU
	db $13, $13, $10 ; EVOLINE_MR_MIME
	db $13, $13, $10 ; EVOLINE_SCYTHER
	db $12, $12, $10 ; EVOLINE_JYNX
	db $12, $14, $10 ; EVOLINE_ELECTABUZZ
	db $14, $14, $0E ; EVOLINE_MAGMAR
	db $12, $12, $0E ; EVOLINE_PINSIR
	db $12, $14, $10 ; EVOLINE_TAUROS
	db $18, $18, $0C ; EVOLINE_MAGIKARP
	db $16, $16, $0C ; EVOLINE_LAPRAS
	db $14, $14, $10 ; EVOLINE_DITTO
	db $12, $12, $10 ; EVOLINE_EEVEE
	db $10, $10, $0E ; EVOLINE_PORYGON
	db $12, $12, $0E ; EVOLINE_OMANYTE
	db $12, $12, $0E ; EVOLINE_KABUTO
	db $0C, $0C, $12 ; EVOLINE_AERODACTYL
	db $26, $36, $12 ; EVOLINE_SNORLAX
	db $13, $13, $10 ; EVOLINE_ARTICUNO
	db $13, $13, $10 ; EVOLINE_ZAPDOS
	db $13, $13, $10 ; EVOLINE_MOLTRES
	db $12, $12, $0E ; EVOLINE_DRATINI
	db $14, $14, $0E ; EVOLINE_MEWTWO
	db $14, $14, $0E ; EVOLINE_MEW

SECTION "bank5", ROMX, BANK[$5]

Func_14000: ; 0x14000
	call Func_14091
	call Func_159f4
	call Func_15450
	call Func_16859
	call Func_14ece
	call Func_14234
	call Func_16425
	call Func_142fc
	call Func_1404a
	ret

Func_1401c: ; 0x1401c
	call Func_14091
	call Func_14377
	call Func_14135
	call Func_asm_1522d
	call Func_14282
	call Func_1414b
	call Func_14234
	call Func_14746
	call Func_14707
	call Func_140f9
	call Func_16878
	call Func_140e2
	call Func_16425
	call Func_142fc
	call Func_1404a
	ret

Func_1404a: ; 0x1404a
	ld a, [wd57d]
	and a
	ret z
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld a, [wd580]
	and a
	ret z
	ld a, $f
	ld [wd581], a
	call Func_1762f
	ld hl, wTimerDigits
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wTimerDigits
	ld a, [wTimerMinutes]
	and $f
	call LoadTimerDigitTiles
	ld a, [wTimerSeconds]
	swap a
	and $f
	call LoadTimerDigitTiles
	ld a, [wTimerSeconds]
	and $f
	call LoadTimerDigitTiles
	ld a, e
	srl a
	srl a
	ld d, $90 ; colon
	call LoadTimerDigitTiles
	ret

Func_14091: ; 0x14091
	ld a, $ff
	ld [wd4d7], a
	ld [wd4db], a
	ld a, [wd4b4]
	ld [wd4c5], a
	ld a, [wd4b6]
	ld [wd4c6], a
	ld a, [wBallRotation]
	ld [wd4c7], a
	ld a, [wd503]
	and a
	ret z
	xor a
	ld [wd503], a
	ld a, [wd502]
	res 1, a
	ld [wd502], a
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	lb de, $00, $07
	call PlaySoundEffect
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

Func_140e2: ; 0x140e2
	ld a, $ff
	ld [wd60e], a
	ld [wd60f], a
	ld a, [wd60c]
	call Func_16f28
	ld a, [wd60d]
	add $14
	call Func_16f28
	ret

Func_140f9: ; 0x140f9
	ld a, [wd4ef]
	and a
	jr z, .asm_1410c
	xor a
	ld a, $66
	ld [wc7e3], a
	ld a, $67
	ld [wc803], a
	ld a, $2
.asm_1410c
	call Func_149d9
	ld a, [wLeftMapMoveCounter]
	call Func_149f5
	ld a, [wd4f1]
	and a
	jr z, .asm_14127
	ld a, $6a
	ld [wc7f0], a
	ld a, $6b
	ld [wc810], a
	ld a, $2
.asm_14127
	add $3
	call Func_149d9
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_149f5
	ret

Func_14135: ; 0x14135
	ld bc, $0000
.asm_14138
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	res 7, a
	call Func_169cd
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_14138
	ret

Func_1414b: ; 0x1414b
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	cp $2
	ret z
	ld a, [wd5c6]
	and a
	jr nz, .asm_14165
	ld a, [wCapturingMon]
	and a
	jr nz, .asm_14165
	jp Func_14210

.asm_14165
	callba Func_141f2
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_10301
	ld a, [wCapturingMon]
	and a
	ret z
	ld a, BANK(PikachuSaverGfx)
	ld hl, PikachuSaverGfx + $c0
	ld de, vTilesOB tile $7e
	ld bc, $0020
	call FarCopyData
	ld a, BANK(GFX_a8800)
	ld hl, GFX_a8800
	ld de, vTilesSH tile $10
	ld bc, $0180
	call FarCopyData
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeball
	ld a, Bank(PinballPokeballShakeGfx)
	ld hl, PinballPokeballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

.notPokeball
	cp ULTRA_BALL
	jr nc, .notGreatball
	ld a, Bank(PinballGreatballShakeGfx)
	ld hl, PinballGreatballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

.notGreatball
	cp MASTER_BALL
	jr nc, .notUltraball
	ld a, Bank(PinballUltraballShakeGfx)
	ld hl, PinballUltraballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

.notUltraball
	ld a, Bank(PinballMasterballShakeGfx)
	ld hl, PinballMasterballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

Func_141f2: ; 0x141f2
	ld a, $80
	hlCoord 7, 4, vBGMap
	call Func_14209
	hlCoord 7, 5, vBGMap
	call Func_14209
	hlCoord 7, 6, vBGMap
	call Func_14209
	hlCoord 7, 7, vBGMap
	; fall through

Func_14209: ; 0x14209
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

Func_14210: ; 0x14210
	ld hl, wd586
	ld b, $18
.asm_14215
	ld a, [hli]
	xor $1
	ld [hli], a
	dec b
	jr nz, .asm_14215
	callba Func_10184
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_14234: ; 0x14234
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	cp $1
	ret nz
	ld a, [wd554]
	cp $3
	ret z
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_1425c
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesSH tile $10
	ld bc, $00e0
	call FarCopyData
	jr .asm_1426a

.asm_1425c
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call FarCopyData
.asm_1426a
	ld a, [wd551]
	and a
	ret z
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, BANK(Data_dd188)
	ld hl, Data_dd188
	ld de, $0070
	ld bc, $0010
	call Func_6fd
	ret

Func_14282: ; 0x14282
	ld a, [wInSpecialMode]
	and a
	jr z, .asm_1429e
	ld a, [wSpecialMode]
	and a
	jr nz, .asm_14296
	ld a, [wNumMonHits]
	and a
	call nz, Func_142b3
	ret

.asm_14296
	cp $1
	jr nz, .asm_1429e
	call Func_142c3
	ret

.asm_1429e
	ld a, [wd624]
	call Func_174d4
	ld a, BANK(Data_d8f60)
	ld hl, Data_d8f60
	ld de, vTilesSH tile $2e
	ld bc, $0020
	call FarCopyData
	ret

Func_142b3: ; 0x142b3
	push af
	callba Func_10611
	pop af
	dec a
	jr nz, Func_142b3
	ret

Func_142c3: ; 0x142c3
	ld de, $0000
	ld a, [wd554]
	and a
	ret z
	ld b, a
.asm_142cc
	ld a, [wCurrentEvolutionType]
	call Func_142d7
	inc de
	dec b
	jr nz, .asm_142cc
	ret

Func_142d7: ; 0x142d7
	push bc
	push de
	dec a
	ld c, a
	ld b, $0
	swap c
	sla c
	ld hl, Data_d8e80
	add hl, bc
	swap e
	sla e
	push hl
	ld hl, vTilesSH tile $2e
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, $0020
	ld a, BANK(Data_d8e80)
	call FarCopyData
	pop de
	pop bc
	ret

Func_142fc: ; 0x142fc
	ld a, [wd4c8]
	and a
	jr nz, .asm_1430e
	callba LoadBallGfx
	jr .asm_14328

.asm_1430e
	cp $1
	jr nz, .asm_1431e
	callba LoadMiniBallGfx
	jr .asm_14328

.asm_1431e
	callba Func_dd62
.asm_14328
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeball
	ld a, BANK(PokeBallObjPalette)
	ld hl, PokeBallObjPalette
	ld de, $0040
	ld bc, $0008
	call Func_6fd
	ret

.notPokeball
	cp ULTRA_BALL
	jr nc, .notGreatball
	ld a, BANK(GreatBallObjPalette)
	ld hl, GreatBallObjPalette
	ld de, $0040
	ld bc, $0008
	call Func_6fd
	ret

.notGreatball
	cp MASTER_BALL
	jr nc, .notUltraball
	ld a, BANK(UltraBallObjPalette)
	ld hl, UltraBallObjPalette
	ld de, $0040
	ld bc, $0008
	call Func_6fd
	ret

.notUltraball
	ld a, BANK(MasterBallObjPalette)
	ld hl, MasterBallObjPalette
	ld de, $0040
	ld bc, $0008
	call Func_6fd
	ret

Func_14377: ; 0x14377
	ld a, [wInSpecialMode]
	and a
	jr nz, .asm_143b1
	ld a, [wd609]
	and a
	jr z, .asm_14393
	ld a, [wd498]
	add $15
	callba Func_30256
	ret

.asm_14393
	ld a, [wd608]
	and a
	jr z, .asm_143a6
	ld a, $1a
	callba Func_30256
	ret

.asm_143a6
	callba Func_30253
	ret

.asm_143b1
	ld a, [wSpecialMode]
	cp $2
	ret nz
	ld a, [wd54d]
	cp $3
	jr nz, .asm_143c9
	callba Func_30253
	ret

.asm_143c9
	ld a, [wd604]
	and a
	ld a, $14
	jr nz, .asm_143d6
	ld a, [wd55a]
	add $12
.asm_143d6
	callba Func_30256
	ret

INCLUDE "engine/collision/red_stage_game_object_collision.asm"

Func_1460e: ; 0x1460e
	call ResolveVoltorbCollision
	call ResolveRedStageSpinnerCollision
	call ResolveRedStagePinballUpgradeTriggersCollision
	call HandleRedStageBallTypeUpgradeCounter
	call Func_15270
	call ResolveRedStageBoardTriggerCollision
	call ResolveRedStagePikachuCollision
	call ResolveStaryuCollision
	call ResolveBellsproutCollision
	call ResolveDittoSlotCollision
	call Func_161e0
	call Func_164e3
	call Func_146a9
	call Func_174ea
	call Func_148cf
	callba Func_30188
	ld a, $0
	callba Func_10000
	ret

Func_14652: ; 0x14652
	call Func_14795
	call Func_15f86
	call ResolveDiglettCollision
	call Func_14880
	call Func_14e10
	call Func_154a9
	call HandleRedStageBallTypeUpgradeCounter
	call Func_151cb
	call Func_1652d
	call ResolveRedStagePikachuCollision
	call Func_167ff
	call Func_169a6
	call ResolveRedStageBonusMultiplierCollision
	call Func_16279
	call Func_161af
	call Func_164e3
	call Func_14733
	call Func_146a2
	call Func_174d0
	callba Func_30188
	ld a, $0
	callba Func_10000
	ret

Func_146a2: ; 0x146a2
	call Func_146a9
	call nz, Func_14707
	ret

Func_146a9: ; 0x146a9
	ld a, [wBallSaverTimerFrames]
	ld hl, wBallSaverTimerSeconds
	or [hl]
	ret z
	ld a, [wBallXPos + 1]
	cp $9a
	jr nc, .asm_146e8
	ld a, [wBallSaverTimerFrames]
	dec a
	ld [wBallSaverTimerFrames], a
	bit 7, a
	jr z, .asm_146e8
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, [hl]
	dec a
	bit 7, a
	jr nz, .asm_146cf
	ld [hl], a
.asm_146cf
	inc a
	ld c, $0
	cp $2
	jr c, .asm_146e4
	ld c, $4
	cp $6
	jr c, .asm_146e4
	ld c, $10
	cp $b
	jr c, .asm_146e4
	ld c, $ff
.asm_146e4
	ld a, c
	ld [wd4a2], a
.asm_146e8
	ld a, [wd4a2]
	ld c, $0
	and a
	jr z, .asm_146fe
	ld c, $1
	cp $ff
	jr z, .asm_146fe
	ld hl, hNumFramesDropped
	and [hl]
	jr z, .asm_146fe
	ld c, $0
.asm_146fe
	ld a, [wBallSaverIconOn]
	cp c
	ld a, c
	ld [wBallSaverIconOn], a
	ret

Func_14707: ; 0x14707
	ld a, [wBallSaverIconOn]
	and a
	jr nz, .asm_1471c
	ld a, BANK(Data_1172b)
	ld hl, Data_1172b
	deCoord 8, 13, vBGMap
	ld bc, $0004
	call LoadOrCopyVRAMData
	ret

.asm_1471c
	ld a, BANK(Data_1472f)
	ld hl, Data_1472f
	deCoord 8, 13, vBGMap
	ld bc, $0004
	call LoadOrCopyVRAMData
	ret

Data_1172b:
	dr $1472b, $1472f

Data_1472f:
	dr $1472f, $14733

Func_14733: ; 0x14733
	ld c, $0
	ld a, [wd49b]
	and a
	jr z, .asm_1473d
	ld c, $1
.asm_1473d
	ld a, [wd4a9]
	cp c
	ld a, c
	ld [wd4a9], a
	ret z
	; fall through

Func_14746: ; 0x14746
	ld c, $0
	ld a, [wd49b]
	and a
	jr z, .asm_14750
	ld c, $2
.asm_14750
	ld b, $0
	ld hl, Data_1475f
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(Data_1475f)
	call Func_10aa
	ret

Data_1475f:
	dw Data_14763
	dw Data_14768

Data_14763:
	db 2
	dw Data_1476d
	dw Data_14777

Data_14768:
	db 2
	dw Data_14781
	dw Data_1478b

Data_1476d:
	dr $1476d, $14777

Data_14777:
	dr $14777, $14781

Data_14781:
	dr $14781, $1478b

Data_1478b:
	dr $1478b, $14795

Func_14795: ; 0x14795
	ld a, [wWildMonCollision]
	and a
	ret z
	xor a
	ld [wWildMonCollision], a
	ld a, $1
	ld [wBallHitWildMon], a
	lb de, $00, $06
	call PlaySoundEffect
	ret

ResolveDiglettCollision: ; 0x147aa
	ld a, [wWhichDiglett]
	and a
	jp z, .asm_14834
	xor a
	ld [wWhichDiglett], a
	ld a, [wWhichDiglettId]
	sub $1
	sla a
	ld c, a
	ld b, $0
	ld hl, wLeftMapMoveCounter
	add hl, bc
	ld a, [hl]
	cp $3
	jr z, .asm_14834
	inc a
	ld [hld], a
	ld [hl], $50
	ld hl, wd4f7
	add hl, bc
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, c
	and a
	jr z, .asm_14807
	ld a, $6a
	ld [wc7f0], a
	ld a, $6b
	ld [wc810], a
	ld a, $5
	call Func_149d9
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_149f5
	ld a, $8
	callba Func_10000
	ld a, [wRightMapMoveCounter]
	cp $3
	call z, Func_14920
	jr .asm_14830

.asm_14807
	ld a, $66
	ld [wc7e3], a
	ld a, $67
	ld [wc803], a
	ld a, $2
	call Func_149d9
	ld a, [wLeftMapMoveCounter]
	call Func_149f5
	ld a, $7
	callba Func_10000
	ld a, [wLeftMapMoveCounter]
	cp $3
	call z, Func_14947
.asm_14830
	call Func_1496d
	ret

.asm_14834
	ld a, [wd4ef]
	and a
	jr z, .asm_14857
	dec a
	ld [wd4ef], a
	jr nz, .asm_14857
	ld a, [wLeftMapMoveCounter]
	sub $3
	jr nz, .asm_1484d
	ld [wLeftMapMoveCounter], a
	call Func_149f5
.asm_1484d
	ld a, $64
	ld [wc7e3], a
	ld a, $65
	ld [wc803], a
.asm_14857
	ld a, [wd4f1]
	and a
	jr z, .asm_1487c
	dec a
	ld [wd4f1], a
	jr nz, .asm_1487c
	ld a, [wRightMapMoveCounter]
	sub $3
	jr nz, .asm_14872
	ld [wRightMapMoveCounter], a
	add $4
	call Func_149f5
.asm_14872
	ld a, $68
	ld [wc7f0], a
	ld a, $69
	ld [wc810], a
.asm_1487c
	call Func_14990
	ret

Func_14880: ; 0x14880
	ld hl, wd4f7
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_148a6
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_148a6
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_148a6
	cp $3
	jr z, .asm_148a6
	dec a
	ld [wLeftMapMoveCounter], a
	call Func_149f5
.asm_148a6
	ld hl, wd4f9
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_148ce
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_148ce
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_148ce
	cp $3
	jr z, .asm_148ce
	dec a
	ld [wRightMapMoveCounter], a
	add $4
	call Func_149f5
.asm_148ce
	ret

Func_148cf: ; 0x148cf
	ld b, $0
	ld hl, wd4f8
	ld a, [hld]
	or [hl]
	jr z, .asm_148f8
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_148f8
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_148f8
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_148f8
	cp $3
	jr z, .asm_148f8
	dec a
	ld [wLeftMapMoveCounter], a
.asm_148f8
	ld hl, wd4fa
	ld a, [hld]
	or [hl]
	jr z, .asm_1491f
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1491f
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1491f
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_1491f
	cp $3
	jr z, .asm_1491f
	dec a
	ld [wRightMapMoveCounter], a
.asm_1491f
	ret

Func_14920: ; 0x14920
	ld hl, wd62b
	call Func_e4a
	jr nc, .asm_14937
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_14937
	ld a, $1
	ld [wd55a], a
	callba StartMapMoveMode
	ret

Func_14947: ; 0x14947
	ld hl, wd62b
	call Func_e4a
	jr nc, .asm_1495e
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_1495e
	xor a
	ld [wd55a], a
	callba StartMapMoveMode
	ret

Func_1496d: ; 0x1496d
	ld a, $55
	ld [wd803], a
	ld a, $4
	ld [wd804], a
	ld a, $2
	ld [wd7eb], a
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $0f
	call PlaySoundEffect
	ret

Func_14990: ; 0x14990
	ld a, [wd4ef]
	and a
	jr nz, .asm_149b6
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_149a2
	dec a
	ld [wLeftMapMoveDiglettAnimationCounter], a
	jr .asm_149b6

.asm_149a2
	call Func_1130
	ret nz
	ld a, $14
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, [wLeftMapMoveDiglettFrame]
	xor $1
	ld [wLeftMapMoveDiglettFrame], a
	call Func_149d9
.asm_149b6
	ld a, [wd4f1]
	and a
	ret nz
	ld a, [wRightMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_149c6
	dec a
	ld [wRightMapMoveDiglettAnimationCounter], a
	ret

.asm_149c6
	call Func_1130
	ret nz
	ld a, $14
	ld [wRightMapMoveDiglettAnimationCounter], a
	ld a, [wRightMapMoveDiglettFrame]
	xor $1
	ld [wRightMapMoveDiglettFrame], a
	add $3
	; fall through
Func_149d9: ; 0x149d9
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_14a11
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_149e9
	ld hl, Data_14a83
.asm_149e9
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, BANK(Data_14a11)
	call Func_10aa
	ret

Func_149f5: ; 0x149f5
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_14af5
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_14a05
	ld hl, Data_14c8d
.asm_14a05
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, BANK(Data_14af5)
	call Func_10aa
	ret

Data_14a11:
	dr $14a11, $14a83

Data_14a83:
	dr $14a83, $14af5

Data_14af5:
	dr $14af5, $14c8d

Data_14c8d:
	dr $14c8d, $14d85

ResolveVoltorbCollision: ; 0x14d85
	ld a, [wWhichVoltorb]
	and a
	jr z, .noVoltorbCollision
	xor a
	ld [wWhichVoltorb], a
	call Func_14dc9
	ld a, $10
	ld [wd4d6], a
	ld a, [wWhichVoltorbId]
	sub $3
	ld [wd4d7], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.noVoltorbCollision
	ld a, [wd4d6]
	and a
	ret z
	dec a
	ld [wd4d6], a
	ret nz
	ld a, $ff
	ld [wd4d7], a
	ret

Func_14dc9: ; 0x14dc9
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $0e
	call PlaySoundEffect
	ret

ResolveRedStageSpinnerCollision: ; 0x14dea
	ld a, [wSpinnerCollision]
	and a
	jr z, Func_14e10
	xor a
	ld [wSpinnerCollision], a
	ld a, [wBallYVelocity]
	ld c, a
	ld a, [wBallYVelocity + 1]
	ld b, a
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld a, $c
	callba Func_10000
	; fall through
Func_14e10: ; 0x14e10
	ld hl, wd50b
	ld a, [hli]
	or [hl]
	ret z
	ld a, [wd50b]
	ld c, a
	ld a, [wd50c]
	ld b, a
	bit 7, b
	jr nz, .asm_14e2e
	ld a, c
	sub $7
	ld c, a
	ld a, b
	sbc $0
	ld b, a
	jr nc, .asm_14e3b
	jr .asm_14e38

.asm_14e2e
	ld a, c
	add $7
	ld c, a
	ld a, b
	adc $0
	ld b, a
	jr nc, .asm_14e3b
.asm_14e38
	ld bc, $0000
.asm_14e3b
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld hl, wd50b
	ld a, [wd509]
	add [hl]
	ld [wd509], a
	inc hl
	ld a, [wd50a]
	adc [hl]
	bit 7, a
	ld c, $0
	jr z, .asm_14e5e
	add $18
	ld c, $1
	jr .asm_14e66

.asm_14e5e
	cp $18
	jr c, .asm_14e66
	sub $18
	ld c, $1
.asm_14e66
	ld [wd50a], a
	ld a, c
	and a
	ret z
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd62d
	call Func_e4a
	ld a, [wd517]
	cp $f
	jr nz, .asm_14e8a
	call Func_14ea7
	ret

.asm_14e8a
	inc a
	ld [wd517], a
	call Func_14ea7
	ld a, [wd517]
	cp $f
	jr nz, .asm_14e9d
	ld a, $64
	ld [wd51e], a
.asm_14e9d
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	call Func_14ece
	ret

Func_14ea7: ; 0x14ea7
	ld a, [wd51e]
	and a
	ret nz
	ld a, [wd517]
	ld c, a
	ld b, $0
	ld hl, Data_14ebe
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

Data_14ebe:
	dr $14ebe, $14ece

Func_14ece: ; 0x14ece
	ld a, [wd517]
	ld c, a
	sla c
	ld b, $0
	ld hl, Data_14eeb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_14ee1
	ld hl, Data_1509b
.asm_14ee1
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(Data_14eeb)
	call Func_10aa
	ret

Data_14eeb:
	dr $14eeb, $1509b

Data_1509b:
	dr $1509b, $151cb

Func_151cb: ; 0x151cb
	ld a, [wWhichCAVELight]
	and a
	jr z, .asm_15229
	xor a
	ld [wWhichCAVELight], a
	ld a, [wd513]
	and a
	jr nz, .asm_15229
	ld a, [wWhichCAVELightId]
	sub $a
	ld c, a
	ld b, $0
	ld hl, wd50f
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd50f
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	inc hl
	and [hl]
	jr z, Func_asm_1522d
	ld a, $1
	ld [wd513], a
	ld a, $80
	ld [wd514], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $09
	call PlaySoundEffect
	ld hl, wd62c
	call Func_e4a
	jr Func_asm_1522d

.asm_15229
	call Func_15270
	ret z
	; fall through

Func_asm_1522d: ; 0x1522d
	ld hl, wd512
	ld b, $4
.asm_15232
	ld a, [hld]
	push hl
	call Func_1523c
	pop hl
	dec b
	jr nz, .asm_15232
	ret

Func_1523c: ; 0x1523c
	and a
	jr z, .asm_1524e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15249
	ld hl, Data_152dd
	jr .asm_1525b

.asm_15249
	ld hl, Data_1531d
	jr .asm_1525b

.asm_1524e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15258
	ld hl, Data_152e5
	jr .asm_1525b

.asm_15258
	ld hl, Data_15325
.asm_1525b
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_15270: ; 0x15270
	ld a, [wd513]
	and a
	jr z, .asm_152a6
	ld a, [wd514]
	dec a
	ld [wd514], a
	jr nz, .asm_1528d
	ld [wd513], a
	ld a, $1
	ld [wd608], a
	ld a, $3
	ld [wd607], a
	xor a
.asm_1528d
	and $7
	ret nz
	ld a, [wd514]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_152a6
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_152c2
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.asm_152c2
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hl], a
	ret

Data_152dd:
	dr $152dd, $152e5

Data_152e5:
	dr $152e5, $1531d

Data_1531d:
	dr $1531d, $15325

Data_15325:
	dr $15325, $1535d

ResolveRedStagePinballUpgradeTriggersCollision: ; 0x1535d
	ld a, [wWhichPinballUpgradeTrigger]
	and a
	jp z, .asm_1544c
	xor a
	ld [wWhichPinballUpgradeTrigger], a
	ld a, [wStageCollisionState]
	bit 0, a
	jp z, .asm_1544c
	ld a, [wd5fc]
	and a
	jp nz, .asm_1544c
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	call Func_159c9
	ld a, $b
	callba Func_10000
	ld a, [wWhichPinballUpgradeTriggerId]
	sub $e
	ld c, a
	ld b, $0
	ld hl, wd5f9
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd5f9
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	jr nz, .asm_153c0
	lb de, $00, $09
	call PlaySoundEffect
	jp Func_15450

.asm_153c0
	ld a, $1
	ld [wd5fc], a
	ld a, $80
	ld [wd5fd], a
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wBallType]
	cp MASTER_BALL
	jr z, .masterBall
	lb de, $06, $3a
	call PlaySoundEffect
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld de, FieldMultiplierText
	ld hl, wd5cc
	call LoadTextHeader
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgressionRedField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .asm_15447

.masterBall
	lb de, $0f, $4d
	call PlaySoundEffect
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $0100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, DigitsText1to8
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, FieldMultiplierSpecialBonusText
	call LoadTextHeader
.asm_15447
	call TransitionPinballUpgrade
	jr Func_15450

.asm_1544c
	call Func_154a9
	ret z

Func_15450
	ld a, [wStageCollisionState]
	bit 0, a
	ret z
	ld hl, wd5fb
	ld b, $3
.asm_1545b
	ld a, [hld]
	push hl
	call Func_15465
	pop hl
	dec b
	jr nz, .asm_1545b
	ret

Func_15465: ; 0x15465
	and a
	jr z, .asm_15477
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15472
	ld hl, Data_15511
	jr .asm_15484

.asm_15472
	ld hl, Data_15543
	jr .asm_15484

.asm_15477
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15481
	ld hl, Data_15517
	jr .asm_15484

.asm_15481
	ld hl, Data_15549
.asm_15484
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_15499: ; 0x15499
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld b, $3
.asm_1549f
	push hl
	xor a
	call Func_15465
	pop hl
	dec b
	jr nz, .asm_1549f
	ret

Func_154a9: ; 0x154a9
	ld a, [wd5fc]
	and a
	jr z, .asm_154d6
	ld a, [wd5fd]
	dec a
	ld [wd5fd], a
	jr nz, .asm_154bb
	ld [wd5fc], a
.asm_154bb
	and $7
	jr nz, .asm_154d4
	ld a, [wd5fd]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_154d4
	xor a
	ret

.asm_154d6
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_154ee
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.asm_154ee
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hl], a
	ret

BallTypeProgressionRedField: ; 0x15505
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

BallTypeDegradationRedField: ; 0x1550b
; Determines the previous upgrade for the Ball.
	db POKE_BALL   ; POKE_BALL -> POKE_BALL
	db POKE_BALL   ; unused
	db POKE_BALL   ; GREAT_BALL -> POKE_BALL
	db GREAT_BALL  ; ULTRA_BALL -> GREAT_BALL
	db ULTRA_BALL  ; unused
	db ULTRA_BALL  ; MASTER_BALL -> GREAT_BALL

Data_15511:
	dr $15511, $15517

Data_15517:
	dr $15517, $15543

Data_15543:
	dr $15543, $15549

Data_15549:
	dr $15549, $15575

HandleRedStageBallTypeUpgradeCounter: ; 0x15575
	ld a, [wCapturingMon]
	and a
	ret nz
	ld hl, wBallTypeCounter
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	ret z
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	ret nz
	; counter is now 0! Degrade the ball upgrade.
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeDegradationRedField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	and a
	jr z, .pokeball
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
.pokeball
	call TransitionPinballUpgrade
	ret

TransitionPinballUpgrade: ; 0x155a7
	ld a, [wBallType]
	ld c, a
	sla c
	ld b, $0
	ld hl, PinballUpgradeTransitionPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(PinballUpgradeTransitionPointers)
	call Func_10aa
	; fall through

Func_155bb: ; 0x155bb
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	; gameboy color
	ld a, [wBallType]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_157f7
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, BANK(Data_157f7)
	ld de, Func_1266
	call Func_10c5
	ret

PinballUpgradeTransitionPointers:
	dw TransitionToPokeBallPointers  ; POKE_BALL
	dw TransitionToPokeBallPointers  ; POKE_BALL
	dw TransitionToGreatBallPointers ; GREAT_BALL
	dw TransitionToUltraBallPointers ; ULTRA_BALL
	dw TransitionToUltraBallPointers ; ULTRA_BALL
	dw TransitionToMasterBallPointers ; MASTER_BALL

TransitionToPokeBallPointers:
	db 11
	dw TransitionToPokeBall_TileData_1
	dw TransitionToPokeBall_TileData_2
	dw TransitionToPokeBall_TileData_3
	dw TransitionToPokeBall_TileData_4
	dw TransitionToPokeBall_TileData_5
	dw TransitionToPokeBall_TileData_6
	dw TransitionToPokeBall_TileData_7
	dw TransitionToPokeBall_TileData_8
	dw TransitionToPokeBall_TileData_9
	dw TransitionToPokeBall_TileData_10
	dw TransitionToPokeBall_TileData_11

TransitionToGreatBallPointers:
	db 11
	dw TransitionToGreatBall_TileData_1
	dw TransitionToGreatBall_TileData_2
	dw TransitionToGreatBall_TileData_3
	dw TransitionToGreatBall_TileData_4
	dw TransitionToGreatBall_TileData_5
	dw TransitionToGreatBall_TileData_6
	dw TransitionToGreatBall_TileData_7
	dw TransitionToGreatBall_TileData_8
	dw TransitionToGreatBall_TileData_9
	dw TransitionToGreatBall_TileData_10
	dw TransitionToGreatBall_TileData_11

TransitionToUltraBallPointers:
	db 11
	dw TransitionToUltraBall_TileData_1
	dw TransitionToUltraBall_TileData_2
	dw TransitionToUltraBall_TileData_3
	dw TransitionToUltraBall_TileData_4
	dw TransitionToUltraBall_TileData_5
	dw TransitionToUltraBall_TileData_6
	dw TransitionToUltraBall_TileData_7
	dw TransitionToUltraBall_TileData_8
	dw TransitionToUltraBall_TileData_9
	dw TransitionToUltraBall_TileData_10
	dw TransitionToUltraBall_TileData_11

TransitionToMasterBallPointers:
	db 11
	dw TransitionToMasterBall_TileData_1
	dw TransitionToMasterBall_TileData_2
	dw TransitionToMasterBall_TileData_3
	dw TransitionToMasterBall_TileData_4
	dw TransitionToMasterBall_TileData_5
	dw TransitionToMasterBall_TileData_6
	dw TransitionToMasterBall_TileData_7
	dw TransitionToMasterBall_TileData_8
	dw TransitionToMasterBall_TileData_9
	dw TransitionToMasterBall_TileData_10
	dw TransitionToMasterBall_TileData_11

TransitionToPokeBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballPokeballGfx + $0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballPokeballGfx + $30
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballPokeballGfx + $60
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballPokeballGfx + $90
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballPokeballGfx + $c0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballPokeballGfx + $f0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballPokeballGfx + $120
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballPokeballGfx + $150
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballPokeballGfx + $180
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballPokeballGfx + $1b0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballPokeballGfx + $1e0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToGreatBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballGreatballGfx + $0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballGreatballGfx + $30
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballGreatballGfx + $60
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballGreatballGfx + $90
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballGreatballGfx + $c0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballGreatballGfx + $f0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballGreatballGfx + $120
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballGreatballGfx + $150
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballGreatballGfx + $180
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballGreatballGfx + $1b0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballGreatballGfx + $1e0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToUltraBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballUltraballGfx + $0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballUltraballGfx + $30
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballUltraballGfx + $60
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballUltraballGfx + $90
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballUltraballGfx + $c0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballUltraballGfx + $f0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballUltraballGfx + $120
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballUltraballGfx + $150
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballUltraballGfx + $180
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballUltraballGfx + $1b0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballUltraballGfx + $1e0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToMasterBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballMasterballGfx + $0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballMasterballGfx + $30
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballMasterballGfx + $60
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballMasterballGfx + $90
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballMasterballGfx + $c0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballMasterballGfx + $f0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballMasterballGfx + $120
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballMasterballGfx + $150
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballMasterballGfx + $180
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballMasterballGfx + $1b0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballMasterballGfx + $1e0
	db Bank(PinballMasterballGfx)
	db $00

Data_157f7:
	dw Data_15803
	dw Data_15803
	dw Data_1580a
	dw Data_15811
	dw Data_15811
	dw Data_15818

Data_15803:
	db $08, $04, $40, $68, $51, $37, $00
Data_1580a:
	db $08, $04, $40, $70, $51, $37, $00
Data_15811:
	db $08, $04, $40, $78, $51, $37, $00
Data_15818:
	db $08, $04, $40, $80, $51, $37, $00

ResolveRedStageBoardTriggerCollision: ; 0x1581f
	ld a, [wWhichBoardTrigger]
	and a
	ret z
	xor a
	ld [wWhichBoardTrigger], a
	ld bc, FivePoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wWhichBoardTriggerId]
	sub $11
	ld c, a
	ld b, $0
	ld hl, wd521
	add hl, bc
	ld [hl], $1
	ld a, [wd521]
	and a
	call nz, Func_1587c
	ld a, [wd522]
	and a
	call nz, Func_158c0
	ld a, [wd523]
	and a
	call nz, Func_15904
	ld a, [wd524]
	and a
	call nz, HandleLeftAlleyTriggerRedField
	ld a, [wd525]
	and a
	call nz, Func_15931
	ld a, [wd526]
	and a
	call nz, Func_15944
	ld a, [wd527]
	and a
	call nz, HandleRightAlleyTriggerRedField
	ld a, [wd528]
	and a
	call nz, Func_15990
	ret

Func_1587c: ; 0x1587c
	xor a
	ld [wd521], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba Func_10000
	ret c
	ld a, [wLeftAlleyCount]
	cp $3
	ret z
	inc a
	ld [wLeftAlleyCount], a
	set 7, a
	ld [wIndicatorStates], a
	cp $83
	ret nz
	ld a, [wStageCollisionState]
	and $1
	or $6
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

Func_158c0: ; 0x158c0
	xor a
	ld [wd522], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba Func_10000
	ret c
	ld a, [wLeftAlleyCount]
	cp $3
	ret z
	inc a
	ld [wLeftAlleyCount], a
	set 7, a
	ld [wIndicatorStates], a
	cp $83
	ret nz
	ld a, [wStageCollisionState]
	and $1
	or $6
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

Func_15904: ; 0x15904
	xor a
	ld [wd523], a
	ld a, [wSecondaryLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $3
	callba Func_10000
	ret

HandleLeftAlleyTriggerRedField: ; 0x1591e
; Ball passed over the left alley trigger point in the Red Field.
	xor a
	ld [wd524], a
	ld [wRightAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wLeftAlleyTrigger], a
	call Func_159c9
	ret

Func_15931: ; 0x15931
	xor a
	ld [wd525], a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	ld [wSecondaryLeftAlleyTrigger], a
	call Func_159c9
	ret

Func_15944: ; 0x15944
	xor a
	ld [wd526], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba Func_10000
	ret c
	ld a, [wRightAlleyCount]
	cp $3
	ret z
	inc a
	ld [wRightAlleyCount], a
	cp $3
	jr z, .asm_1596e
	set 7, a
.asm_1596e
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

HandleRightAlleyTriggerRedField: ; 0x1597d
; Ball passed over the right alley trigger point in the Red Field.
	xor a
	ld [wd527], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wRightAlleyTrigger], a
	call Func_159c9
	ret

Func_15990: ; 0x15990
	xor a
	ld [wd528], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba Func_10000
	ret c
	ld a, [wRightAlleyCount]
	cp $3
	ret z
	inc a
	ld [wRightAlleyCount], a
	cp $3
	jr z, .asm_159ba
	set 7, a
.asm_159ba
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

Func_159c9: ; 0x159c9
	ld a, [wd7ad]
	bit 7, a
	ret nz
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	ld a, $ff
	ld [wd7ad], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ld a, $1
	ld [wd580], a
	call Func_1404a
	ret

Func_159f4: ; 0x159f4
	ld a, [hLCDC]
	bit 7, a
	jr z, .asm_15a13
	ld a, [wd7f2]
	and $fe
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	cp c
	jr z, .asm_15a13
	add c
	cp $2
	jr z, .asm_15a13
	lb de, $00, $00
	call PlaySoundEffect
.asm_15a13
	ld a, [wd7f2]
	swap a
	ld c, a
	ld a, [wStageCollisionState]
	sla a
	or c
	ld c, a
	ld b, $0
	ld hl, Data_15a3f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_15a2d
	ld hl, Data_15d05
.asm_15a2d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_15a3f)
	call Func_10aa
	ld a, [wStageCollisionState]
	ld [wd7f2], a
	ret

Data_15a3f:
	dr $15a3f, $15d05

Data_15d05:
	dr $15d05, $15e93

ResolveBellsproutCollision: ; 0x15e93
	ld a, [wBellsproutCollision]
	and a
	jr z, .asm_15eda
	xor a
	ld [wBellsproutCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, BellsproutAnimationData
	ld de, wBellsproutAnimationFrameCounter
	call CopyHLToDE
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $7c
	ld [wBallXPos + 1], a
	ld a, $78
	ld [wBallYPos + 1], a
	xor a
	ld [wd549], a
.asm_15eda
	ld hl, BellsproutAnimationData
	ld de, wBellsproutAnimationFrameCounter
	call UpdateAnimation
	push af
	ld a, [wBellsproutAnimationFrameCounter]
	and a
	jr nz, .asm_15ef8
	ld a, $19
	ld [wBellsproutAnimationFrameCounter], a
	xor a
	ld [wBellsproutAnimationFrame], a
	ld a, $6
	ld [wBellsproutAnimationFrameIndex], a
.asm_15ef8
	pop af
	ret nc
	ld a, [wBellsproutAnimationFrameIndex]
	cp $1
	jr nz, .asm_15f35
	xor a
	ld [wd548], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .noCatchEmMode
	ld a, $8
	jr nz, .startCatchEmMode
	xor a
.startCatchEmMode
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
.noCatchEmMode
	ld hl, wd62a
	call Func_e4a
	ret nc
	ld c, $19
	call Func_e55
	callba z, Func_30164
	ret

.asm_15f35
	ld a, [wBellsproutAnimationFrameIndex]
	cp $4
	jr nz, .asm_15f42
	ld a, $1
	ld [wd548], a
	ret

.asm_15f42
	ld a, [wBellsproutAnimationFrameIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wd549], a
	xor a
	ld [wBallXVelocity + 1], a
	ld a, $2
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, $5
	callba Func_10000
	ret

BellsproutAnimationData: ; 0x15f69
; Each entry is [duration][OAM id]
	db $08, $01
	db $06, $02
	db $20, $03
	db $06, $02
	db $08, $01
	db $01, $00
	db $29, $00
	db $28, $01
	db $2A, $00
	db $27, $01
	db $29, $00
	db $28, $01
	db $2B, $00
	db $28, $01
	db $00  ; terminator

Func_15f86: ; 0x15f86
	ld a, [wWhichBumper]
	and a
	jr z, .asm_15f99
	call Func_5fb8
	call Func_15fa6
	xor a
	ld [wWhichBumper], a
	call Func_15fda
.asm_15f99
	ld a, [wd4da]
	and a
	ret z
	dec a
	ld [wd4da], a
	call z, Func_5fb8
	ret

Func_15fa6: ; 0x15fa6
	ld a, $10
	ld [wd4da], a
	ld a, [wWhichBumperId]
	sub $6
	ld [wd4db], a
	sla a
	inc a
	jr asm_15fc0

Func_5fb8: ; 0x5fb8
	ld a, [wd4db]
	cp $ff
	ret z
	sla a
asm_15fc0
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_16010
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_15fd0
	ld hl, Data_16080
.asm_15fd0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_16010)
	call Func_10aa
	ret

Func_15fda: ; 0x15fda
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wWhichBumperId]
	sub $6
	ld c, a
	ld b, $0
	ld hl, Data_1600e
	add hl, bc
	ld a, [wCollisionForceAngle]
	add [hl]
	ld [wCollisionForceAngle], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

Data_1600e:
	dr $1600e, $16010

Data_16010:
	dr $16010, $16080

Data_16080:
	dr $16080, $160f0

ResolveDittoSlotCollision: ; 0x160f0
	ld a, [wDittoSlotCollision]
	and a
	jr z, .asm_16137
	xor a
	ld [wDittoSlotCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $21
	call PlaySoundEffect
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd549], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $11
	ld [wBallXPos + 1], a
	ld a, $23
	ld [wBallYPos + 1], a
	ld a, $10
	ld [wd600], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
.asm_16137
	ld a, [wd600]
	and a
	ret z
	dec a
	ld [wd600], a
	cp $f
	jr nz, .asm_1614f
	callba LoadMiniBallGfx
	ret

.asm_1614f
	cp $c
	jr nz, .asm_1615e
	callba Func_dd62
	ret

.asm_1615e
	cp $9
	jr nz, .asm_1616d
	xor a
	ld [wd548], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_1616d
	cp $6
	jr nz, .asm_1618e
	callba Func_10ab3
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

.asm_1618e
	cp $3
	jr nz, .asm_1619d
	callba LoadMiniBallGfx
	ret

.asm_1619d
	and a
	ret nz
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ret

Func_161af: ; 0x161af
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $fe
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jr asm_1620f

Func_161e0: ; 0x161e0
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $86
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
asm_1620f: ; 0x1620f
	ld bc, Data_f0000
	add hl, bc
	ld de, wBallXVelocity
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1624e
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1624e
	pop hl
	bit 7, h
	jr z, .asm_1625a
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1625a
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	lb de, $00, $04
	call PlaySoundEffect
	ret

Func_16279: ; 0x16279
	ld a, [wSlotCollision]
	and a
	jr z, .asm_162ae
	xor a
	ld [wSlotCollision], a
	ld a, [wd604]
	and a
	ret z
	ld a, [wd603]
	and a
	jr nz, .asm_162ae
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd549], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $16
	ld [wBallYPos + 1], a
	ld a, $13
	ld [wd603], a
.asm_162ae
	ld a, [wd603]
	and a
	ret z
	dec a
	ld [wd603], a
	ld a, $18
	ld [wd606], a
	ld a, [wd603]
	cp $12
	jr nz, .asm_162d4
	lb de, $00, $21
	call PlaySoundEffect
	callba LoadMiniBallGfx
	ret

.asm_162d4
	cp $f
	jr nz, .asm_162e3
	callba Func_dd62
	ret

.asm_162e3
	cp $c
	jr nz, .asm_162f2
	xor a
	ld [wd548], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_162f2
	cp $9
	jr nz, .asm_162fa
	call Func_16352
	ret

.asm_162fa
	cp $6
	jr nz, .asm_16317
	xor a
	ld [wd604], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	callba LoadMiniBallGfx
	ret

.asm_16317
	cp $3
	jr nz, .asm_16330
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	ret

.asm_16330
	and a
	ret nz
	call Func_16425
	ld a, [wd622]
	cp $1
	ret nz
	call GenRandom
	and $8
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
	xor a
	ld [wd622], a
	ret

Func_16352: ; 0x16352
	xor a
	ld [wIndicatorStates + 4], a
	ld a, $d
	callba Func_10000
	jr nc, .asm_1636d
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ret

.asm_1636d
	ld a, [wd624]
	cp $3
	jr nz, .asm_163b3
	ld a, [wd607]
	and a
	jr nz, .asm_163b3
.asm_1637a
	ld a, [wd623]
	and a
	jr nz, .asm_16389
	xor a
	ld [wd625], a
	ld a, $40
	ld [wd626], a
.asm_16389
	xor a
	ld [wd623], a
	ld a, $1
	ld [wd495], a
	ld [wd4ae], a
	ld a, [wd498]
	ld c, a
	ld b, $0
	ld hl, Data_16420
	add hl, bc
	ld a, [hl]
	ld [wd497], a
	call Func_163f2
	xor a
	ld [wd609], a
	ld [wd622], a
	ld a, $1e
	ld [wd607], a
	ret

.asm_163b3
	callba Func_ed8e
	xor a
	ld [wd608], a
	ld a, [wd61d]
	cp $d
	jr nc, .asm_1637a
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ld a, [wd622]
	cp $2
	ret nz
	callba Func_10ab3
	ld a, [wd7ad]
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	xor a
	ld [wd622], a
	ret

Func_163f2: ; 0x163f2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld a, [wd497]
	ld de, GoToDiglettStageText
	cp $d
	jr z, .asm_1640f
	ld de, GoToGengarStageText
	cp $7
	jr z, .asm_1640f
	ld de, GoToMewtwoStageText
.asm_1640f
	call LoadTextHeader
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $3c, $23
	call PlaySoundEffect
	ret

Data_16420:
	dr $16420, $16425

Func_16425: ; 0x16425
	ld a, [wCurrentStage]
	and $1
	sla a
	ld c, a
	ld a, [wd604]
	add c
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1644d
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_16441
	ld hl, Data_164a1
.asm_16441
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_1644d)
	call Func_10aa
	ret

Data_1644d:
	dr $1644d, $164a1

Data_164a1:
	dr $164a1, $164e3

Func_164e3: ; 0x164e3
	ld a, [wd607]
	and a
	ret z
	dec a
	ld [wd607], a
	ret nz
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wd609]
	and a
	jr z, .asm_164ff
	ld a, [wd498]
	add $15
	jr .asm_16506

.asm_164ff
	ld a, [wd608]
	and a
	ret z
	ld a, $1a
.asm_16506
	ld hl, wCurrentStage
	bit 0, [hl]
	callba nz, Func_30256
	ld a, [wd604]
	and a
	ret nz
	ld a, $1
	ld [wd604], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	call nz, Func_16425
	ret

Func_1652d: ; 0x1652d
	ld a, [wPinballLaunchAlley]
	and a
	ret z
	xor a
	ld [wPinballLaunchAlley], a
	ld a, [wd4de]
	and a
	jr z, .asm_16566
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hl], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld a, $80
	ld [wBallYVelocity], a
	ld a, $fa
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	lb de, $00, $0a
	call PlaySoundEffect
.asm_16566
	ld a, $ff
	ld [wPreviousTriggeredGameObject], a
	ld a, [wd4de]
	and a
	ret nz
	ld a, [wd4e0]
	and a
	jr nz, .asm_16582
	call Func_1658f
	ld a, $1
	ld [wd4e0], a
	ld [wd4de], a
	ret

.asm_16582
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	ret z
	ld a, $1
	ld [wd4de], a
	ret

Func_1658f: ; 0x1658f
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, LoadGreyBillboardPaletteData
.showNextMap
	ld a, [wInitialMapSelectionIndex]
	inc a
	cp $7  ; number of maps to choose from at the start of play
	jr c, .gotMapId
	xor a  ; wrap around to 0
.gotMapId
	ld [wInitialMapSelectionIndex], a
	ld c, a
	ld b, $0
	ld hl, RedStageInitialMaps
	add hl, bc
	ld a, [hl]
	ld [wCurrentMap], a
	push af
	lb de, $00, $48
	call PlaySoundEffect
	pop af
	add (PalletTownPic_Pointer - BillboardPicturePointers) / 3 ; map billboard pictures start at the $29th entry in BillboardPicturePointers
	callba LoadBillboardPicture
	ld b, $20  ; number of frames to delay before the next map is shown
.waitOnCurrentMap
	push bc
	callba Func_eeee
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	jr nz, .ballStartKeyPressed
	pop bc
	dec b
	jr nz, .waitOnCurrentMap
	jr .showNextMap

.ballStartKeyPressed
	pop bc
	callba Func_30253
	ld bc, StartFromMapText
	callba Func_3118f
	ld a, [wCurrentMap]
	ld [wd4e3], a
	xor a
	ld [wd4e2], a
	ret

RedStageInitialMaps: ; 0x16605
	db PALLET_TOWN
	db VIRIDIAN_FOREST
	db PEWTER_CITY
	db CERULEAN_CITY
	db VERMILION_SEASIDE
	db ROCK_MOUNTAIN
	db LAVENDER_TOWN

ResolveRedStagePikachuCollision: ; 0x1660c
	ld a, [wWhichPikachu]
	and a
	jr z, .asm_1667b
	xor a
	ld [wWhichPikachu], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1667b
	ld a, [wd51d]
	and a
	jr nz, .asm_16634
	ld a, [wWhichPikachuId]
	sub $1c
	ld hl, wd518
	cp [hl]
	jr nz, .asm_1667b
	ld a, [wd517]
	cp $f
	jr nz, .asm_16667
.asm_16634
	ld hl, PikachuSaverAnimationDataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call CopyHLToDE
	ld a, [wd51d]
	and a
	jr nz, .asm_16647
	xor a
	ld [wd517], a
.asm_16647
	ld a, $1
	ld [wd51c], a
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld [wd549], a
	call FillBottomMessageBufferWithBlackTile
	jr .asm_1667b

.asm_16667
	ld hl, PikachuSaverAnimation2DataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call CopyHLToDE
	ld a, $2
	ld [wd51c], a
	lb de, $00, $3b
	call PlaySoundEffect
.asm_1667b
	ld a, [wd51c]
	and a
	call z, Func_16766
	call Func_1669e
	ld a, [wd517]
	cp $f
	ret nz
	ld a, [wd51e]
	and a
	ret z
	dec a
	ld [wd51e], a
	cp $5a
	ret nz
	lb de, $0f, $22
	call PlaySoundEffect
	ret

Func_1669e: ; 0x1669e
	ld a, [wd51c]
	cp $1
	jr nz, .asm_16719
	ld hl, PikachuSaverAnimationDataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $1
	jr nz, .asm_166f7
	xor a
	ld [wd85d], a
	call Func_310a
	rst AdvanceFrame
	ld a, $1
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wd85d], a
	ld a, $ff
	ld [wd803], a
	ld a, $60
	ld [wd804], a
	ld hl, wd62e
	call Func_e4a
	jr nc, .asm_166f0
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_166f0
	lb de, $16, $10
	call PlaySoundEffect
	ret

.asm_166f7
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $11
	ret nz
	ld a, $fc
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wd51c], a
	ret

.asm_16719
	cp $2
	jr nz, .asm_16732
	ld hl, PikachuSaverAnimation2DataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $1
	ret nz
	xor a
	ld [wd51c], a
	ret

.asm_16732
	ld a, [hNumFramesDropped]
	swap a
	and $1
	ld [wPikachuSaverAnimationFrame], a
	ret

PikachuSaverAnimationDataBlueStage: ; 0x1673c
; Each entry is [duration][OAM id]
	db $0C, $02
	db $05, $03
	db $05, $02
	db $05, $04
	db $05, $05
	db $05, $02
	db $06, $06
	db $06, $07
	db $06, $08
	db $06, $02
	db $06, $05
	db $06, $08
	db $06, $07
	db $06, $02
	db $06, $08
	db $06, $07
	db $06, $02
	db $01, $00
	db $00

PikachuSaverAnimation2DataBlueStage: ; 0x16761
; Each entry is [duration][OAM id]
	db $0C, $02
	db $01, $00
	db $00

Func_16766: ; 0x16766
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	jr z, .asm_16774
	ld hl, wd518
	ld [hl], $0
	ret

.asm_16774
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ret z
	ld hl, wd518
	ld [hl], $1
	ret

ResolveStaryuCollision: ; 0x16781
	ld a, [wStaryuCollision]
	and a
	jr z, .asm_167bd
	xor a
	ld [wStaryuCollision], a
	ld a, [wd503]
	and a
	jr nz, .asm_167c2
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd502]
	xor $1
	set 1, a
	ld [wd502], a
	ld a, $14
	ld [wd503], a
	call Func_16859
	ld a, $6
	callba Func_10000
	ret

.asm_167bd
	ld a, [wd503]
	and a
	ret z
.asm_167c2
	dec a
	ld [wd503], a
	ret nz
	ld a, [wd502]
	res 1, a
	ld [wd502], a
	call Func_16859
	ld a, [wd502]
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	lb de, $00, $07
	call PlaySoundEffect
	ld a, [wStageCollisionState]
	bit 0, a
	jp nz, Func_15450
	jp Func_15499

Func_167ff: ; 0x167ff
	ld a, [wStaryuCollision]
	and a
	jr z, .asm_16839
	xor a
	ld [wStaryuCollision], a
	ld a, [wd503]
	and a
	jr nz, .asm_1683e
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd502]
	xor $1
	ld [wd502], a
	ld a, $14
	ld [wd503], a
	call Func_16878
	ld a, $6
	callba Func_10000
	ret

.asm_16839
	ld a, [wd503]
	and a
	ret z
.asm_1683e
	dec a
	ld [wd503], a
	ret nz
	ld a, [wd502]
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	lb de, $00, $07
	call PlaySoundEffect
	ret

Func_16859: ; 0x16859
	ld a, [wd502]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_16899
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1686c
	ld hl, Data_16910
.asm_1686c
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_16899)
	call Func_10aa
	ret

Func_16878: ; 0x16878
	ld a, [wd502]
	and $1
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1695a
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1688d
	ld hl, Data_16980
.asm_1688d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_1695a)
	call Func_10aa
	ret

Data_16899:
	dr $16899, $16910

Data_16910:
	dr $16910, $1695a

Data_1695a:
	dr $1695a, $16980

Data_16980:
	dr $16980, $169a6

Func_169a6: ; 0x169a6
	ld a, [hNumFramesDropped]
	and $1f
	ret nz
	ld bc, $0000
.asm_169ae
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	bit 7, [hl]
	jr z, .asm_169c5
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 5, [hl]
	jr z, .asm_169c2
	inc a
.asm_169c2
	call Func_169cd
.asm_169c5
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_169ae
	ret

Func_169cd: ; 0x169cd
	push af
	sla c
	ld hl, Data_169ed
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_169db
	ld hl, Data_16bef
.asm_169db
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_169ed)
	call Func_10aa
	ret

Data_169ed:
	dr $169ed, $16bef

Data_16bef:
	dr $16bef, $16d9d

ResolveRedStageBonusMultiplierCollision: ; 016d9d
	ld a, [wWhichBonusMultiplierRailing]
	and a
	jp z, Func_16e51
	xor a
	ld [wWhichBonusMultiplierRailing], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wWhichBonusMultiplierRailingId]
	sub $21
	jr nz, .asm_16ddc
	ld a, $9
	callba Func_10000
	ld a, [wd610]
	cp $3
	jr nz, .asm_16e35
	ld a, $1
	ld [wd610], a
	ld a, $3
	ld [wd611], a
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	jr .asm_16e35

.asm_16ddc
	ld a, $a
	callba Func_10000
	ld a, [wd611]
	cp $3
	jr nz, .asm_16e35
	ld a, $1
	ld [wd610], a
	ld a, $1
	ld [wd611], a
	ld a, $80
	ld [wd612], a
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	ld a, [wd482]
	inc a
	cp 100
	jr c, .asm_16e10
	ld a, 99
.asm_16e10
	ld [wd482], a
	jr nc, .asm_16e24
	ld c, $19
	call Func_e55
	callba z, Func_30164
.asm_16e24
	ld a, [wd60c]
	ld [wd614], a
	ld a, [wd60d]
	ld [wd615], a
	ld a, $1
	ld [wd613], a
.asm_16e35
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd60c]
	call Func_16f28
	ld a, [wd60d]
	add $14
	call Func_16f28
	ret

Func_16e51: ; 0x16e51
	call Func_16ef5
	ld a, [wd612]
	and a
	jr z, .asm_16e8f
	dec a
	ld [wd612], a
	cp $70
	jr nz, .asm_16e6e
	ld a, $2
	ld [wd610], a
	ld a, $2
	ld [wd611], a
	jr .asm_16e8f

.asm_16e6e
	and a
	jr nz, .asm_16e8f
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld a, [wd482]
	call Func_16f95
	ld a, [wd60c]
	call Func_16f28
	ld a, [wd60d]
	add $14
	call Func_16f28
	ret

.asm_16e8f
	ld a, [wd610]
	cp $2
	jr c, .asm_16ec1
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_16ea0
	srl a
	srl a
.asm_16ea0
	ld b, a
	and $3
	jr nz, .asm_16ec1
	bit 3, b
	jr nz, .asm_16eb6
	ld a, [wd60c]
	res 7, a
	ld [wd60c], a
	call Func_16f28
	jr .asm_16ec1

.asm_16eb6
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	call Func_16f28
.asm_16ec1
	ld a, [wd611]
	cp $2
	ret c
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_16ed1
	srl a
	srl a
.asm_16ed1
	ld b, a
	and $3
	ret nz
	bit 3, b
	jr nz, .asm_16ee7
	ld a, [wd60d]
	res 7, a
	ld [wd60d], a
	add $14
	call Func_16f28
	ret

.asm_16ee7
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	add $14
	call Func_16f28
	ret

Func_16ef5: ; 0x16ef5
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd613]
	and a
	ret z
	xor a
	ld [wd613], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, BonusMultiplierText
	call LoadTextHeader
	ld hl, wBottomMessageText + $12
	ld a, [wd614]
	and $7f
	jr z, .asm_16f1f
	add $30
	ld [hli], a
.asm_16f1f
	ld a, [wd615]
	res 7, a
	add $30
	ld [hl], a
	ret

Func_16f28: ; 0x16f28
	push af
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_16f33
	pop af
	call Func_16f38
	ret

.asm_16f33
	pop af
	call Func_16f7b
	ret

Func_16f38: ; 0x16f38
	push af
	res 7, a
	ld hl, wd60e
	cp $14
	jr c, .asm_16f47
	ld hl, wd60f
	sub $a
.asm_16f47
	cp [hl]
	jr z, .asm_16f5c
	ld [hl], a
	ld c, a
	ld b, $0
	sla c
	ld hl, Data_16fc8
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_16fc8)
	call Func_10aa
.asm_16f5c
	pop af
	ld bc, $0000
	bit 7, a
	jr z, .asm_16f68
	res 7, a
	set 1, c
.asm_16f68
	cp $14
	jr c, .asm_16f6e
	set 2, c
.asm_16f6e
	ld hl, Data_171e4
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_171e4)
	call Func_10aa
	ret

Func_16f7b: ; 0x16f7b
	bit 7, a
	jr z, .asm_16f83
	res 7, a
	add $a
.asm_16f83
	ld c, a
	ld b, $0
	sla c
	ld hl, Data_17228
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_17228)
	call Func_10aa
	ret

Func_16f95: ; 0x16f95
	ld a, [wd482]
	inc a
	cp 100
	jr c, .asm_16f9f
	ld a, 99
.asm_16f9f
	ld b, a
	xor a
	ld hl, Data_16fc1
	ld c, $7
.asm_16fa6
	bit 0, b
	jr z, .asm_16fac
	add [hl]
	daa
.asm_16fac
	srl b
	inc hl
	dec c
	jr nz, .asm_16fa6
	push af
	swap a
	and $f
	ld [wd60c], a
	pop af
	and $f
	ld [wd60d], a
	ret

Data_16fc1:
	dr $16fc1, $16fc8

Data_16fc8:
	dr $16fc8, $171e4

Data_171e4:
	dr $171e4, $17228

Data_17228:
	dr $17228, $174d0

Func_174d0: ; 0x174d0
	call Func_174ea
	ret nc
	; fall through

Func_174d4: ; 0x174d4
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_17528
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	ret

Func_174ea: ; 0x174ea
	ld a, [wd624]
	ld hl, wd625
	cp [hl]
	ret z
	ld a, [wd626]
	dec a
	ld [wd626], a
	jr nz, .asm_17514
	ld a, [wd625]
	ld [wd624], a
	cp $3
	jr c, .asm_1750f
	ld a, $1
	ld [wd609], a
	ld a, $3
	ld [wd607], a
.asm_1750f
	ld a, [wd624]
	scf
	ret

.asm_17514
	and $7
	ret nz
	ld a, [wd626]
	bit 3, a
	jr nz, .asm_17523
	ld a, [wd624]
	scf
	ret

.asm_17523
	ld a, [wd625]
	scf
	ret

Data_17528:
	dr $17528, $1755c

Func_1755c: ; 0x1755c
	ld bc, $7f00
	call DrawTimer
	call Func_17cc4
	call Func_17d34
	call Func_17d59
	call Func_17d7a
	call Func_17d92
	call Func_17de1
	call DrawPinball
	call Func_17efb
	call Func_17f64
	ret

Func_1757e: ; 0x1757e
	ld bc, $7f00
	call DrawTimer
	call DrawMonCaptureAnimation
	call DrawAnimatedMon_RedStage
	call DrawPikachuSavers_RedStage
	callba DrawFlippers
	call DrawPinball
	call Func_17f0f
	call Func_17f75
	call Func_17fca
	ret

DrawTimer: ; 0x175a4
	ld a, [wd57d]
	and a
	ret z
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, DrawTimer_GameBoyColor
	ld a, [wd580]
	and a
	ret z
	ld a, [wd581]
	and a
	jr z, .DrawTimer_GameBoy
	dec a
	ld [wd581], a
	ret

.DrawTimer_GameBoy
	call Func_1762f
	ld hl, wTimerDigits
	ld a, [wTimerMinutes]
	and $f
	call LoadTimerDigitTiles
	ld a, [wTimerSeconds]
	swap a
	and $f
	call LoadTimerDigitTiles
	ld a, [wTimerSeconds]
	and $f
	call LoadTimerDigitTiles
	ld d, $0
	ld hl, TimerOAMIds
	add hl, de
	ld a, [hli]
	call DrawTimerDigit
	ld a, [hli]
	call DrawTimerDigit
	ld a, [hli]
	call DrawTimerDigit
	ld a, [hli]
	call DrawTimerDigit
	ret

DrawTimer_GameBoyColor: ; 0x175f5
; Loads the OAM data for the timer in the top-right corner of the screen.
	ld a, [wTimerMinutes]
	and $f
	call DrawTimerDigit_GameBoyColor
	ld a, $a  ; colon
	call DrawTimerDigit_GameBoyColor
	ld a, [wTimerSeconds]
	swap a
	and $f
	call DrawTimerDigit_GameBoyColor  ; tens digit of the minutes
	ld a, [wTimerSeconds]
	and $f
	call DrawTimerDigit_GameBoyColor  ; ones digit of the minutes
	ret

TimerOAMIds:
	db $d7, $da, $d8, $d9
	db $dc, $df, $dd, $de
	db $dc, $db, $dd, $de
	db $f5, $f8, $f6, $f7

DrawTimerDigit_GameBoyColor: ; 0x17625
	add $b1  ; the timer digits' OAM ids start at $b1
DrawTimerDigit: ; 0x17627
	call LoadOAMData
	ld a, b
	add $8
	ld b, a
	ret

Func_1762f: ; 0x1762f
	lb de, $60, $0c
	ld a, [wCurrentStage]
	cp $6
	ret nc
	lb de, $00, $00
	bit 0, a
	ret z
	lb de, $30, $04
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	ret nz
	lb de, $30, $08
	ret

LoadTimerDigitTiles: ; 0x1764f
	push bc
	push de
	cp [hl]
	jr z, .skip
	push af
	push hl
	add d
	call Func_17665
	pop hl
	pop af
	ld [hl], a
.skip
	inc hl
	pop de
	ld a, d
	add $10
	ld d, a
	pop bc
	ret

Func_17665: ; 0x17665
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, Data_17679
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_17679)
	call Func_10aa
	ret

Data_17679:
INCLUDE "data/unknown_17679.asm"

DrawMonCaptureAnimation: ; 0x17c67
	ld a, [wCapturingMon]
	and a
	ret z
	ld a, $50
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $38
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBallCaptureAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, BallCaptureAnimationOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

BallCaptureAnimationOAMIds:
	db $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $21, $22, $23, $24, $25

DrawAnimatedMon_RedStage: ; 0x17c96
	ld a, [wWildMonIsHittable]
	and a
	ret z
	ld a, $50
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $3e
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd5bd]
	ld e, a
	ld d, $0
	ld hl, AnimatedMonOAMIds_RedStage
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

AnimatedMonOAMIds_RedStage:
	db $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31

Func_17cc4: ; 0x17cc4
	ld de, wd4cd
	ld hl, Data_17d15
	call Func_17cdc
	ld de, wd4d0
	ld hl, Data_17d1b
	call Func_17cdc
	ld de, wd4d3
	ld hl, Data_17d21
	; fall through

Func_17cdc: ; 0x17cdc
	push hl
	ld hl, Data_17d27
	call UpdateAnimation
	ld h, d
	ld l, e
	ld a, [hl]
	and a
	jr nz, .asm_17cf6
	call GenRandom
	and $7
	add $1e
	ld [hli], a
	ld a, $1
	ld [hli], a
	xor a
	ld [hl], a
.asm_17cf6
	pop hl
	inc de
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [wd4d7]
	sub [hl]
	inc hl
	jr z, .asm_17d0c
	ld a, [de]
.asm_17d0c
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17d15:
	dr $17d15, $17d1b

Data_17d1b:
	dr $17d1b, $17d21

Data_17d21:
	dr $17d21, $17d27

Data_17d27:
	dr $17d27, $17d34

Func_17d34: ; 0x17d34
	ld a, $0
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wStageCollisionState]
	ld e, a
	ld d, $0
	ld hl, Data_17d51
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17d51:
	dr $17d51, $17d59

Func_17d59: ; 0x17d59
	ld a, $74
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $52
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBellsproutAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, Data_17d76
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17d76:
	dr $17d76, $17d7a

Func_17d7a: ; 0x17d7a
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, $67
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $54
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, $cc
	call LoadOAMData
	ret

Func_17d92: ; 0x17d92
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, Data_17dd0
	ld de, wd504
	call UpdateAnimation
	ld a, [wd504]
	and a
	jr nz, .asm_17db1
	ld a, $13
	ld [wd504], a
	xor a
	ld [wd505], a
	ld [wd506], a
.asm_17db1
	ld a, $2b
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $69
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd505]
	ld e, a
	ld d, $0
	ld hl, Data_17dce
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17dce:
	dr $17dce, $17dd0

Data_17dd0:
	dr $17dd0, $17de1

Func_17de1: ; 0x17de1
	ld a, $88
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $5a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd50a]
	srl a
	srl a
	ld e, a
	ld d, $0
	ld hl, Data_17e02
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17e02:
	dr $17e02, $17e08

DrawPikachuSavers_RedStage: ; 0x17e08
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [wd51d]
	and a
	ld a, [wd518]
	jr z, .asm_17e33
	ld a, [wd51c]
	and a
	jr nz, .asm_17e29
	ld a, [hNumFramesDropped]
	srl a
	srl a
	srl a
	and $1
	jr .asm_17e33

.asm_17e29
	ld a, [wd4b4]
	cp $50
	ld a, $1
	jr nc, .asm_17e33
	xor a
.asm_17e33
	sla a
	ld c, a
	ld b, $0
	ld hl, PikachuSaverOAMOffsets_RedStage
	add hl, bc
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	ld a, [wPikachuSaverAnimationFrame]
	add $e
	call LoadOAMData
	ret

PikachuSaverOAMOffsets_RedStage:
	dw $7E0F
	dw $7E92

Func_17e4f: ; 0x17e4f
; unused
	ld hl, UnusedData_7e55
	jp Func_17e5e

UnusedData_7e55: ; 0x17e55
	db $00, $2B, $69, $CB, $00, $67, $54, $CC
	db $FF

Func_17e5e: ; 0x17e5e
; unused
	ld a, [hGameBoyColorFlag]
	ld e, a
	ld a, [hSCX]
	ld d, a
.asm_17e64
	ld a, [hli]
	cp $ff
	ret z
	or e
	jr nz, .asm_17e70
	inc hl
	inc hl
	inc hl
	jr .asm_17e64
.asm_17e70
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hli]
	bit 0, e
	call nz, LoadOAMData
	jr .asm_17e64

DrawPinball: ; 0x17e81
	ld a, [wd548]
	and a
	ret z
	ld hl, wBallSpin
	ld a, [wBallRotation]
	add [hl]
	ld [wBallRotation], a
	ld a, [wBallXPos + 1]
	inc a
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wBallYPos + 1]
	inc a
	sub $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBallRotation]
	srl a
	srl a
	srl a  ; divide wBallRotation by 8 because
	srl a  ; there are 8 frames of the ball spinning
	and $7
	add $0
	call LoadOAMData
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld a, [hSGBFlag]
	and a
	ret nz
	ld a, [wd4c5]
	inc a
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd4c6]
	inc a
	sub $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd4c7]
	srl a
	srl a
	srl a
	srl a
	and $7
	add $0
	call LoadOAMData
	ld a, [wBallXPos + 1]
	ld [wd4c5], a
	ld a, [wBallYPos + 1]
	ld [wd4c6], a
	ld a, [wBallRotation]
	ld [wd4c7], a
	ret

Func_17efb: ; 0x17efb
	ld a, [wd551]
	and a
	ret nz
	ld a, [hNumFramesDropped]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 5
	ld hl, Data_17f3a
	ld b, $6
	jr asm_17f21

Func_17f0f: ; 0x17f0f
	ld a, [wd551]
	and a
	ret nz
	ld a, [hNumFramesDropped]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 11
	ld hl, Data_17f4c
	ld b, $8
asm_17f21: ; 0x17f21
	push bc
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [de]
	and a
	ld a, [hli]
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, asm_17f21
	ret

Data_17f3a:
	dr $17f3a, $17f4c

Data_17f4c:
	dr $17f4c, $17f64

Func_17f64: ; 0x17f64
	ld a, [wd551]
	and a
	ret z
	ld de, wd566
	ld hl, Data_17fa6
	ld b, $c
	ld c, $39
	jr asm_17f84

Func_17f75: ; 0x17f75
	ld a, [wd551]
	and a
	ret z
	ld de, wd572
	ld hl, Data_17fbe
	ld b, $6
	ld c, $40
asm_17f84: ; 0x17f84
	push bc
	ld a, [de]
	add c
	cp c
	push af
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hNumFramesDropped]
	and $e
	jr nz, .asm_17f9c
	dec c
.asm_17f9c
	pop af
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, asm_17f84
	ret

Data_17fa6:
	dr $17fa6, $17fbe

Data_17fbe:
	dr $17fbe, $17fca

Func_17fca: ; 0x17fca
	ld a, [wd604]
	and a
	ret z
	ld a, [wd606]
	inc a
	ld [wd606], a
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $1
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd606]
	srl a
	srl a
	srl a
	and $3
	add $4f
	cp $52
	call nz, LoadOAMData
	ret

SECTION "bank6", ROMX, BANK[$6]

Func_18000: ; 0x18000
	ld hl, wc000
	ld bc, $0a00
	call ClearData
	ld a, $1
	ld [rVBK], a
	hlCoord 0, 0, vBGWin
	ld bc, $0400
	call ClearData
	xor a
	ld [rVBK], a
	ld hl, wWhichVoltorb
	ld bc, $032e
	call ClearData
	xor a
	ld hl, wScore + $5
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ld [wNumPartyMons], a
	ld [wd49b], a
	ld [wd4c9], a
	ld a, $1
	ld [wd49d], a
	ld a, $3
	ld [wd49e], a
	callba Start20SecondSaverTimer
	ret

Func_1804a: ; 0x1804a
	ld a, $0
	ld [wBallXPos], a
	ld a, $b0
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $98
	ld [wBallYPos + 1], a
	ret

DoNothing_1805f: ; 0x1805f
	ret

DoNothing_18060: ; 0x18060
	ret

DoNothing_18061: ; 0x18061
	ret

CheckRedStageLaunchAlleyCollision_: ; 0x18062
	callba CheckRedStageLaunchAlleyCollision
	ret

DoNothing_1806d: ; 0x1806d
	ret

Func_1806e: ; 0x1806e
	callba Func_1652d
	ret

Func_18079: ; 0x18079
	callba DrawPinball
	ret

Func_18084: ; 0x18084
	callba DrawFlippers
	callba DrawPinball
	ret

InitGengarBonusStage: ; 0x18099
	ld a, [wd7c1]
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
	ld [wd7ac], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wd49a], a
	ld hl, Data_18121
	ld de, wd659
	call Func_18112
	call Func_18112
	call Func_18112
	ld hl, Data_1813c
	ld de, wd67e
	call Func_18112
	call Func_18112
	ld hl, Data_1814e
	ld de, wd698
	call Func_18112
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
	ld a, $f
	call SetSongBank
	ld de, $0005
	call PlaySong
	ret

Func_18112: ; 0x18112
	ld b, $3
.asm_18114
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
	jr nz, .asm_18114
	ret

Data_18121:
	dr $18121, $1813c

Data_1813c:
	dr $1813c, $1814e

Data_1814e:
	dr $1814e, $18157

StartBallGengarBonusStage: ; 0x18157
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd653], a
	xor a
	ld [wd674], a
	ld a, $8
	ld [wd690], a
	ld [wd6a1], a
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	ret

Func_1818b: ; 0x1818b
	callba Func_142fc
	call Func_2862
	call Func_18d72
	ld a, [wd7c1]
	callba Func_1404a
	and a
	ret z
	call Func_183db
	call Func_18d91
	ret

CheckGengarBonusStageGameObjectCollisions: ; 0x181b1
	call CheckGengarBonusStageGastlyCollision
	call CheckGengarBonusStageHaunterCollision
	call CheckGengarBonusStageGengarCollision
	call GengarBonusStageGravestonesCollision
	ret

CheckGengarBonusStageGastlyCollision: ; 0x181be
	ld a, [wd659]
	and a
	ret z
	ld a, [wGastly1XPos + 1]
	ld b, a
	ld a, [wGastly1YPos + 1]
	add $10
	ld c, a
	ld a, [wGastly1AnimationState]
	call CheckSingleGastlyCollision
	ld a, $1
	jr c, .hitGastly
	ld a, [wGastly2XPos + 1]
	ld b, a
	ld a, [wGastly2YPos + 1]
	add $10
	ld c, a
	ld a, [wGastly2AnimationState]
	call CheckSingleGastlyCollision
	ld a, $2
	jr c, .hitGastly
	ld a, [wGastly3XPos + 1]
	ld b, a
	ld a, [wGastly3YPos + 1]
	add $10
	ld c, a
	ld a, [wGastly3AnimationState]
	call CheckSingleGastlyCollision
	ld a, $3
	ret nc
.hitGastly
	ld [wTriggeredGameObjectIndex], a
	ld [wd657], a
	add $4
	ld [wTriggeredGameObject], a
	ld [wd658], a
	ret

CheckSingleGastlyCollision: ; 0x1820d
	cp $4
	jr z, .noCollision
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
	jr nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, CircularCollisionAngles
	add hl, de
	ld a, BANK(CircularCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.noCollision
	and a
	ret

CheckGengarBonusStageHaunterCollision: ; 0x18259
	ld a, [wd67e]
	and a
	ret z
	ld a, [wHaunter1XPos + 1]
	add $fe
	ld b, a
	ld a, [wHaunter1YPos + 1]
	add $c
	ld c, a
	ld a, [wHaunter1AnimationState]
	call CheckSingleHaunterCollision
	ld a, $1
	jr c, .hitHaunter
	ld a, [wHaunter2XPos + 1]
	add $fe
	ld b, a
	ld a, [wHaunter2YPos + 1]
	add $c
	ld c, a
	ld a, [wHaunter2AnimationState]
	call CheckSingleHaunterCollision
	ld a, $2
	ret nc
.hitHaunter
	ld [wTriggeredGameObjectIndex], a
	ld [wd67c], a
	add $7
	ld [wTriggeredGameObject], a
	ld [wd67d], a
	ret

CheckSingleHaunterCollision: ; 0x18298
	cp $5
	jr z, .noCollision
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $28
	jr nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, HaunterCollisionAngles
	add hl, de
	ld a, BANK(HaunterCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.noCollision
	and a
	ret

CheckGengarBonusStageGengarCollision: ; 0x182e4
	ld a, [wd698]
	and a
	ret z
	ld a, [wGengarXPos + 1]
	ld b, a
	ld a, [wGengarYPos + 1]
	add $c
	ld c, a
	call CheckGiantGengarCollision
	ld a, $1
	ret nc
	ld [wTriggeredGameObjectIndex], a
	ld [wd696], a
	add $9
	ld [wTriggeredGameObject], a
	ld [wd697], a
	ret

CheckGiantGengarCollision: ; 0x18308
	ld a, [wBallXPos + 1]
	sub b
	cp $30
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $40
	jr nc, .noCollision
	ld c, a
	ld a, c
	sla a
	add c
	ld e, a
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, GengarCollisionAngles
	add hl, de
	ld a, BANK(GengarCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.noCollision
	and a
	ret

GengarBonusStageGravestonesCollision: ; 0x18350
	ld de, GengarBonusStageGravestonesCollisionData
	ld hl, GengarBonusStageGravestonesCollisionAttributes
	ld bc, wWhichGravestone
	and a
	jp HandleGameObjectCollision

GengarBonusStageGravestonesCollisionAttributes:
	db $00  ; flat list
	db $19, $1A, $1B, $1C, $27, $1D, $1E, $1F, $20
	db $FF ; terminator

GengarBonusStageGravestonesCollisionData:
	db $11, $11
	db $01, $24, $52
	db $02, $44, $3A
	db $03, $74, $5A
	db $04, $7C, $32
	db $FF ; terminator

Func_18377: ; 0x18377
	call Func_18464
	call Func_1860b
	call Func_187b1
	call Func_18d34
	call Func_183b7
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba Func_86d2
	ld a, [wd6a2]
	cp $5
	ret nc
	ld a, $1
	ld [wd6a8], a
	ret

Func_183b7: ; 0x183b7
	ld a, [wd653]
	and a
	ret nz
	ld a, [wd4b4]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd653], a
	callba LoadStageCollisionAttributes
	call Func_183db
	call Func_18d91
	ret

Func_183db: ; 0x183db
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_183f8
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_183ee
	ld hl, Data_1842e
.asm_183ee
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(Data_183f8)
	call Func_10aa
	ret

Data_183f8:
	dr $183f8, $1842e

Data_1842e:
	dr $1842e, $18464

Func_18464: ; 0x18464
	ld a, [wd659]
	and a
	ret z
	ld a, [wd657]
	and a
	jr z, .asm_184d5
	xor a
	ld [wd657], a
	ld a, [wd7be]
	and a
	jr nz, .asm_184d5
	ld a, [wd658]
	sub $5
	ld c, a
	sla a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd65d
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jr nz, .asm_184d5
	push de
	dec de
	dec de
	dec de
	ld hl, Data_185e6
	call CopyHLToDE
	pop de
	ld a, $1
	ld [de], a
	ld a, [wd67b]
	inc a
	ld [wd67b], a
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld a, $33
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $2c
	call PlaySoundEffect
.asm_184d5
	ld bc, $0830
	ld de, wd65d
	ld hl, wd675
	call Func_1850c
	ld bc, $5078
	ld de, wd666
	ld hl, wd677
	call Func_1850c
	ld bc, $3050
	ld de, wd66f
	ld hl, wd679
	call Func_1850c
	ld de, wd65d
	call Func_18562
	ld de, wd666
	call Func_18562
	ld de, wd66f
	call Func_18562
	ret

Func_1850c: ; 0x1850c
	ld a, [de]
	and a
	ret nz
	inc de
	push hl
	ld a, [hli]
	push af
	push bc
	ld a, [hl]
	inc a
	and $1f
	ld [hl], a
	ld c, a
	ld b, $0
	ld hl, Data_18542
	add hl, bc
	pop bc
	pop af
	and a
	jr nz, .asm_18534
	ld a, [de]
	add [hl]
	ld [de], a
	inc de
	ld a, [de]
	adc $0
	ld [de], a
	pop hl
	cp c
	ret c
	ld a, $1
	ld [hl], a
	ret

.asm_18534
	ld a, [de]
	sub [hl]
	ld [de], a
	inc de
	ld a, [de]
	sbc $0
	ld [de], a
	pop hl
	cp b
	ret nc
	xor a
	ld [hl], a
	ret

Data_18542:
	dr $18542, $18562

Func_18562: ; 0x18562
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_185d9
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
	dec de
	and a
	jr nz, .asm_1858a
	ld a, [de]
	cp $4
	ret nz
	ld hl, Data_185dd
	dec de
	dec de
	call CopyHLToDE
	ret

.asm_1858a
	cp $1
	ret nz
	ld a, [de]
	cp $12
	ret nz
	ld a, [wd67b]
	cp $a
	jr nz, .asm_185b1
	ld a, $1
	ld [wd67e], a
	ld [wd687], a
	xor a
	ld [wd659], a
	ld [wd662], a
	ld [wd66b], a
	ld de, $0006
	call PlaySong
	ret

.asm_185b1
	ld c, a
	ld a, [wd65d]
	and a
	jr nz, .asm_185b9
	inc c
.asm_185b9
	ld a, [wd666]
	and a
	jr nz, .asm_185c0
	inc c
.asm_185c0
	ld a, [wd66f]
	and a
	jr nz, .asm_185c7
	inc c
.asm_185c7
	ld a, c
	cp $a
	ret nc
	ld hl, Data_185dd
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	xor a
	ld [de], a
	ret

Data_185d9:
	dr $185d9, $185dd

Data_185dd:
	dr $185dd, $185e6

Data_185e6:
	dr $185e6, $1860b

Func_1860b: ; 0x1860b
	ld a, [wd67e]
	and a
	ret z
	ld a, [wd67c]
	and a
	jr z, .asm_1867c
	xor a
	ld [wd67c], a
	ld a, [wd7be]
	and a
	jr nz, .asm_1867c
	ld a, [wd67d]
	sub $8
	ld c, a
	sla a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd682
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jr nz, .asm_1867c
	push de
	dec de
	dec de
	dec de
	ld hl, Data_1878a
	call CopyHLToDE
	pop de
	ld a, $1
	ld [de], a
	ld a, [wd695]
	inc a
	ld [wd695], a
	ld bc, FiveHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld a, $33
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $2d
	call PlaySoundEffect
.asm_1867c
	ld bc, $5078
	ld de, wd682
	ld hl, wd691
	call Func_186a1
	ld bc, $1038
	ld de, wd68b
	ld hl, wd693
	call Func_186a1
	ld de, wd682
	call Func_186f7
	ld de, wd68b
	call Func_186f7
	ret

Func_186a1: ; 0x186a1
	ld a, [de]
	and a
	ret nz
	inc de
	push hl
	ld a, [hli]
	push af
	push bc
	ld a, [hl]
	inc a
	and $1f
	ld [hl], a
	ld c, a
	ld b, $0
	ld hl, Data_186d7
	add hl, bc
	pop bc
	pop af
	and a
	jr nz, .asm_186c9
	ld a, [de]
	add [hl]
	ld [de], a
	inc de
	ld a, [de]
	adc $0
	ld [de], a
	pop hl
	cp c
	ret c
	ld a, $1
	ld [hl], a
	ret

.asm_186c9
	ld a, [de]
	sub [hl]
	ld [de], a
	inc de
	ld a, [de]
	sbc $0
	ld [de], a
	pop hl
	cp b
	ret nc
	xor a
	ld [hl], a
	ret

Data_186d7:
	dr $186d7, $186f7

Func_186f7: ; 0x186f7
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1877d
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
	dec de
	and a
	jr nz, .asm_1871f
	ld a, [de]
	cp $4
	ret nz
	ld hl, Data_18781
	dec de
	dec de
	call CopyHLToDE
	ret

.asm_1871f
	cp $1
	ret nz
	ld a, [de]
	cp $12
	jr nz, .asm_18761
	ld a, [wd695]
	cp $a
	jr nz, .asm_18740
	ld a, $1
	ld [wd656], a
	call Func_18d72
	call Func_18d91
	ld de, $0000
	call PlaySong
	ret

.asm_18740
	ld c, a
	ld a, [wd682]
	and a
	jr nz, .asm_18748
	inc c
.asm_18748
	ld a, [wd68b]
	and a
	jr nz, .asm_1874f
	inc c
.asm_1874f
	ld a, c
	cp $a
	ret nc
	ld hl, Data_18781
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	xor a
	ld [de], a
	ret

.asm_18761
	cp $13
	ret nz
	ld a, [wd695]
	cp $a
	ret nz
	ld a, $1
	ld [wd698], a
	xor a
	ld [wd67e], a
	ld [wd687], a
	ld de, GENGAR
	call PlayCry
	ret

Data_1877d:
	dr $1877d, $18781

Data_18781:
	dr $18781, $1878a

Data_1878a:
	dr $1878a, $187b1

Func_187b1: ; 0x187b1
	ld a, [wd698]
	and a
	ret z
	ld a, [wd696]
	and a
	jp z, .asm_1885d
	xor a
	ld [wd696], a
	ld a, [wd7be]
	and a
	jp nz, .asm_1885d
	ld a, [wd697]
	sub $a
	ld c, a
	sla a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd69c
	add hl, bc
	ld d, h
	ld e, l
	ld a, [de]
	and a
	jp nz, .asm_1885d
	push de
	dec de
	dec de
	dec de
	ld a, [wd6a2]
	inc a
	ld [wd6a2], a
	cp $5
	jr nc, .asm_18804
	ld hl, Data_18b2b
	call CopyHLToDE
	pop de
	ld a, $2
	ld [de], a
	lb de, $00, $37
	call PlaySoundEffect
	jr .asm_18826

.asm_18804
	ld hl, Data_18b32
	call CopyHLToDE
	pop de
	ld a, $3
	ld [de], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba Func_86d2
	ld de, $0000
	call PlaySong
.asm_18826
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueue
	ld a, $33
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $ff
	ld [wGengarYPos + 1], a
.asm_1885d
	ld a, [wd69c]
	cp $2
	jr nc, .asm_18869
	call Func_18876
	jr .asm_1886c

.asm_18869
	call Func_188e1
.asm_1886c
	ld de, wd69c
	call Func_189af
	call Func_1894c
	ret

Func_18876: ; 0x18876
	ld a, [wd6a3]
	cp $1
	jr z, .asm_1889b
	cp $2
	jr z, .asm_1889b
	ld a, [wd69a]
	cp $1
	jr z, .asm_1888c
	cp $2
	jr nz, .asm_1889b
.asm_1888c
	ld a, $1
	ld [wd6a4], a
	ld a, $11
	ld [wd803], a
	ld a, $8
	ld [wd804], a
.asm_1889b
	ld a, [wd69a]
	ld hl, wd6a3
	cp [hl]
	ret z
	ld a, [wd69c]
	and a
	jr nz, .asm_188da
	ld a, [wGengarYPos + 1]
	add $80
	cp $a0
	jr nc, .asm_188da
	ld a, [wd69a]
	and a
	jr z, .asm_188ca
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $3
	ld [wGengarYPos + 1], a
	jr .asm_188da

.asm_188ca
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $1
	ld [wGengarYPos + 1], a
.asm_188da
	ld a, [wd69a]
	ld [wd6a3], a
	ret

Func_188e1: ; 0x188e1
	ld a, [wd6a3]
	cp $1
	jr z, .asm_18901
	cp $2
	jr z, .asm_18901
	ld a, [wd69a]
	cp $1
	jr z, .asm_188f7
	cp $2
	jr nz, .asm_18901
.asm_188f7
	ld a, $1
	ld [wd803], a
	ld a, $8
	ld [wd804], a
.asm_18901
	ld a, [wd69a]
	cp $6
	ret z
	ld a, [wd69a]
	ld hl, wd6a3
	cp [hl]
	ret z
	ld a, [wd69c]
	cp $3
	jr nz, .asm_1891d
	ld a, [wd69b]
	cp $9
	jr c, .asm_18945
.asm_1891d
	ld a, [wd69a]
	and a
	jr z, .asm_18935
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $fd
	ld [wGengarYPos + 1], a
	jr .asm_18945

.asm_18935
	ld a, [wGengarYPos]
	add $0
	ld [wGengarYPos], a
	ld a, [wGengarYPos + 1]
	adc $ff
	ld [wGengarYPos + 1], a
.asm_18945
	ld a, [wd69a]
	ld [wd6a3], a
	ret

Func_1894c: ; 0x1894c
	ld a, [wd6a6]
	and a
	jr nz, .asm_1898f
	ld a, [wd6a4]
	and a
	jr z, .asm_1898f
	ld a, [wd6a5]
	cp $3
	jr z, .asm_18980
	inc a
	ld [wd6a5], a
	ld a, [wd548]
	ld hl, wd549
	and [hl]
	jr z, .asm_18973
	ld a, [wd4b6]
	inc a
	ld [wd4b6], a
.asm_18973
	ld a, [wd7a0]
	dec a
	ld [wd7a0], a
	ld a, $1
	ld [wUpperTiltPushing], a
	ret

.asm_18980
	lb de, $00, $2b
	call PlaySoundEffect
	ld a, $1
	ld [wd6a6], a
	xor a
	ld [wd6a4], a
.asm_1898f
	xor a
	ld [wUpperTiltPushing], a
	ld a, [wd6a5]
	and a
	jr z, .asm_189a5
	dec a
	ld [wd6a5], a
	ld a, [wd7a0]
	inc a
	ld [wd7a0], a
	ret

.asm_189a5
	ld a, [wd6a4]
	and a
	ret nz
	xor a
	ld [wd6a6], a
	ret

Func_189af: ; 0x189af
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_18a57
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
	dec de
	and a
	jr nz, .asm_189d7
	ld a, [de]
	cp $4
	ret nz
	ld hl, Data_18a61
	dec de
	dec de
	call CopyHLToDE
	ret

.asm_189d7
	cp $1
	jr nz, .asm_189ed
	ld a, [de]
	cp $60
	ret nz
	ld hl, Data_18a61
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	xor a
	ld [de], a
	ret

.asm_189ed
	cp $2
	jr nz, .asm_18a04
	ld a, [de]
	cp $3
	ret nz
	ld hl, Data_18a6a
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	ld a, $1
	ld [de], a
	ret

.asm_18a04
	cp $3
	jr nz, .asm_18a3c
	ld a, [de]
	cp $1
	jr nz, .asm_18a14
	lb de, $00, $2e
	call PlaySoundEffect
	ret

.asm_18a14
	cp $fe
	ret nz
	ld a, $1
	ld [wd6a8], a
	ld a, $1
	ld [wd498], a
	ld a, $1
	ld [wd49a], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, GengarStageClearedText
	call LoadTextHeader
	lb de, $4b, $2a
	call PlaySoundEffect
	ret

.asm_18a3c
	cp $4
	ret nz
	ld a, [de]
	cp $2
	ret nz
	ld hl, Data_18a61
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	xor a
	ld [de], a
	ld de, $0007
	call PlaySong
	ret

Data_18a57:
	dr $18a57, $18a61

Data_18a61:
	dr $18a61, $18a6a

Data_18a6a:
	dr $18a6a, $18b2b

Data_18b2b:
	dr $18b2b, $18b32

Data_18b32:
	dr $18b32, $18d34

Func_18d34: ; 0x18d34
	ld a, [wWhichGravestone]
	and a
	jr z, .asm_18d71
	xor a
	ld [wWhichGravestone], a
	ld a, [wd7be]
	and a
	jr nz, .asm_18d71
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueue
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld de, $002f
	call Func_4d8
.asm_18d71
	ret

Func_18d72: ; 0x18d72
	ld a, [wd656]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_18ddb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_18d85
	ld hl, Data_18ed1
.asm_18d85
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_18ddb)
	call Func_10aa
	ret

Func_18d91: ; 0x18d91
	ld a, [wd656]
	and a
	ld hl, Data_18dc9
	jr z, .asm_18d9d
	ld hl, Data_18dd2
.asm_18d9d
	ld de, wc7c7
	call Func_18db2
	ld de, wc7ae
	call Func_18db2
	ld de, wc823
	call Func_18db2
	ld de, wc84d
	; fall through

Func_18db2: ; 0x18db2
	push hl
	ld b, $3
.asm_18db5
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add $1e
	ld e, a
	jr nc, .asm_18dc4
	inc d
.asm_18dc4
	dec b
	jr nz, .asm_18db5
	pop hl
	ret

Data_18dc9:
	dr $18dc9, $18dd2

Data_18dd2:
	dr $18dd2, $18ddb

Data_18ddb:
	dr $18ddb, $18ed1

Data_18ed1:
	dr $18ed1, $18faf

Func_18faf: ; 0x18faf
	ld bc, $7f00
	callba DrawTimer
	call Func_19020
	call Func_190b9
	call Func_19185
	callba DrawFlippers
	callba DrawPinball
	ret

Func_18fda:
	ld a, [hNewlyPressedButtons]
	bit 6, a
	ret z
	ld a, [wd659]
	and a
	jr z, .asm_18ff8
	ld a, $1
	ld [wd67e], a
	ld [wd687], a
	xor a
	ld [wd659], a
	ld [wd662], a
	ld [wd66b], a
	ret

.asm_18ff8
	ld a, [wd67e]
	and a
	jr z, .asm_1900b
	ld a, $1
	ld [wd698], a
	xor a
	ld [wd67e], a
	ld [wd687], a
	ret

.asm_1900b
	ld a, [wd698]
	and a
	ret z
	ld a, $1
	ld [wd659], a
	ld [wd662], a
	ld [wd66b], a
	xor a
	ld [wd698], a
	ret

Func_19020: ; 0x19020
	ld de, wd659
	call Func_19033
	ld de, wd662
	call Func_19033
	ld de, wd66b
	call Func_19033
	ret

Func_19033: ; 0x19033
	ld a, [de]
	and a
	ret z
.asm_19036
	call Func_19070
	jr nc, .asm_19042
	ld a, [rLCDC]
	bit 7, a
	jr z, .asm_19036
	ret

.asm_19042
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_1906b
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_1906b:
	db $00, $01, $02, $03
	db $FF

Func_19070: ; 0x19070
	ld a, [wd674]
	and a
	ret z
	push de
	dec a
	ld [wd674], a
	sla a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_190a9
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $22
	ld bc, $0060
	call LoadOrCopyVRAMData
	ld a, $8
	ld [wd690], a
	ld [wd6a1], a
	xor a
	ld [wd67e], a
	ld [wd687], a
	ld [wd698], a
	pop de
	scf
	ret

Data_190a9:
	dr $190a9, $190b9

Func_190b9: ; 0x190b9
	ld de, wd67e
	call Func_190c6
	ld de, wd687
	call Func_190c6
	ret

Func_190c6: ; 0x190c6
	ld a, [de]
	and a
	ret z
.asm_190c9
	call Func_19104
	jr nc, .asm_190d5
	ld a, [rLCDC]
	bit 7, a
	jr z, .asm_190c9
	ret

.asm_190d5
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_190fe
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_190fe:
	db $04, $05, $06, $07, $08
	db $FF

Func_19104: ; 0x19104
	ld a, [wd690]
	and a
	ret z
	push de
	dec a
	ld [wd690], a
	sla a
	sla a
	sla a
	ld c, a
	ld b, $0
	ld hl, GengarBonusStageHaunterGfxTable
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(GengarBonusHaunterGfx)
	call LoadOrCopyVRAMData
	ld a, $4
	ld [wd674], a
	ld a, $8
	ld [wd6a1], a
	xor a
	ld [wd659], a
	ld [wd662], a
	ld [wd66b], a
	ld [wd698], a
	pop de
	scf
	ret

GengarBonusStageHaunterGfxTable: ; 0x19145
; Graphics data for Haunter.
; First word:  length in bytes
; Second word: destination VRAM address
; Third word:  graphics data
; Fourth word: unused
	dw $60, vTilesSH tile $10, GengarBonusHaunterGfx,        $0000
	dw $60, vTilesSH tile $16, GengarBonusHaunterGfx + $60,  $0000
	dw $60, vTilesSH tile $1c, GengarBonusHaunterGfx + $c0,  $0000
	dw $60, vTilesSH tile $22, GengarBonusHaunterGfx + $120, $0000
	dw $20, vTilesSH tile $28, GengarBonusHaunterGfx + $180, $0000
	dw $40, vTilesOB tile $1a, GengarBonusHaunterGfx + $1a0, $0000
	dw $60, vTilesOB tile $1e, GengarBonusHaunterGfx + $1e0, $0000
	dw $60, vTilesOB tile $24, GengarBonusHaunterGfx + $240, $0000

Func_19185: ; 0x19185
	ld de, wd698
	call Func_1918c
	ret

Func_1918c: ; 0x1918c
	ld a, [de]
	and a
	ret z
.asm_1918f
	call Func_191cb
	jr nc, .asm_1919b
	ld a, [rLCDC]
	bit 7, a
	jr z, .asm_1918f
	ret

.asm_1919b
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_191c4
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_191c4:
	db $09, $0A, $0B, $0C, $0D, $0E
	db $FF

Func_191cb: ; 0x191cb
	ld a, [wd6a1]
	and a
	ret z
	push de
	dec a
	ld [wd6a1], a
	sla a
	sla a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1920f
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $26
	call LoadOrCopyVRAMData
	ld a, $4
	ld [wd674], a
	ld a, $8
	ld [wd690], a
	xor a
	ld [wd659], a
	ld [wd662], a
	ld [wd66b], a
	ld [wd67e], a
	ld [wd687], a
	pop de
	scf
	ret

Data_1920f:
	dr $1920f, $1924f

InitMewtwoBonusStage: ; 0x1924f
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld [wStageCollisionState], a
	ld a, $1
	ld [wd7ac], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wd49a], a
	ld hl, Data_192ab
	ld de, wd6b6
	ld b, $c
.asm_19275
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
	jr nz, .asm_19275
	ld hl, Data_192db
	ld de, wd6ac
	ld b, $8
.asm_1928c
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_1928c
	ld bc, $0200  ; 2 minutes 0 seconds
	callba StartTimer
	ld a, $12
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

Data_192ab:
	dr $192ab, $192db

Data_192db:
	dr $192db, $192e3

StartBallMewtwoBonusStage: ; 0x192e3
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd6a9], a
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	ret

Func_19310: ; 0x19310
	callba Func_142fc
	call Func_2862
	callba Func_1404a
	ld a, [wd7c1]
	and a
	ret z
	call Func_194ac
	ret

CheckMewtwoBonusStageGameObjectCollisions: ; 0x19330
	call Func_19414
	call Func_19337
	ret

Func_19337: ; 0x19337
	ld hl, wd6bb
	ld bc, $0601
.asm_1933d
	push bc
	push hl
	ld a, [hli]
	add $f8
	ld b, a
	ld a, [hld]
	add $8
	ld c, a
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	dec hl
	dec hl
	bit 0, [hl]
	call nz, Func_1936f
	pop hl
	pop bc
	ld a, c
	jr c, .asm_19360
	ld de, $0008
	add hl, de
	inc c
	dec b
	jr nz, .asm_1933d
	ret

.asm_19360
	ld [wTriggeredGameObjectIndex], a
	ld [wd6b4], a
	add $0
	ld [wTriggeredGameObject], a
	ld [wd6b5], a
	ret

Func_1936f: ; 0x1936f
	cp $b
	jp z, Func_19412
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jp nc, Func_19412
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
	jp nc, Func_19412
	ld c, a
	ld e, a
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	sla l
	rl h
	sla l
	rl h
	ld de, Data_e4000
	add hl, de
	ld de, wBallXVelocity
	ld a, BANK(Data_e4000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_e4000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(Data_e4000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_e4000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_193ea
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_193ea
	pop hl
	bit 7, h
	jr z, .asm_193f6
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_193f6
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	jr c, .asm_19410
	ld a, [wd804]
	and a
	jr nz, .asm_19410
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
.asm_19410
	scf
	ret

Func_19412: ; 0x19312
	and a
	ret

Func_19414: ; 0x19414
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .asm_1944f
	ld a, [wd6aa]
	bit 7, a
	jr nz, .asm_1944f
	ld a, [wd7e9]
	and a
	ret z
	ld a, [wCurCollisionAttribute]
	sub $10
	ret c
	cp $c
	ret nc
	ld a, $1
	ld [wTriggeredGameObjectIndex], a
	add $6
	ld [wTriggeredGameObject], a
	ld b, a
	ld hl, wd6aa
	ld [hl], $0
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .asm_1944f
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.asm_1944f
	and a
	ret

Func_19451: ; 0x19451
	call Func_19531
	call Func_19701
	call Func_1948b
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba Func_86d2
	ld a, [wd6b1]
	cp $8
	ret nc
	ld a, $1
	ld [wd6b3], a
	ret

Func_1948b: ; 0x1948b
	ld a, [wd6a9]
	and a
	ret nz
	ld a, [wd4b4]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd6a9], a
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
	call Func_10aa
	ret

Data_194c9:
	dr $194c9, $194fd

Data_194fd:
	dr $194fd, $19531

Func_19531: ; 0x19531
	ld a, [wd6aa]
	and a
	jr z, .asm_195a2
	xor a
	ld [wd6aa], a
	ld a, [wd7be]
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
	call Func_1988e
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
	ld [wd7be], a
	call Func_2862
	callba Func_86d2
	ld de, $0000
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
	ld a, [wd499]
	ld [wd498], a
	ld a, [wNumMewtwoBonusCompletions]
	cp $2  ; only counts up to 2. Gets reset to 0 when Mew is encountered in Catch 'Em Mode.
	jr z, .asm_1965e
	inc a
	ld [wNumMewtwoBonusCompletions], a
.asm_1965e
	ld a, $1
	ld [wd49a], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
.asm_1966b
	ld de, MewtwoStageClearedText
	call LoadTextHeader
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
	call CopyHLToDE
	pop de
	inc de
	pop af
	ld [de], a
	ret

Data_19691:
	dr $19691, $19701

Func_19701: ; 0x19701
	ld a, [wd6b4]
	and a
	jr z, .asm_19742
	xor a
	ld [wd6b4], a
	ld a, [wd7be]
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
	call Func_1978b
	ld de, wd6c5
	call Func_1978b
	ld de, wd6cd
	call Func_1978b
	ld de, wd6d5
	call Func_1978b
	ld de, wd6dd
	call Func_1978b
	ld de, wd6e5
	call Func_1978b
	ld de, wd6b6
	call Func_19833
	ld de, wd6be
	call Func_19833
	ld de, wd6c6
	call Func_19833
	ld de, wd6ce
	call Func_19833
	ld de, wd6d6
	call Func_19833
	ld de, wd6de
	call Func_19833
	ret

Func_1978b: ; 0x1978b
	ld a, [de]
	ld c, a
	ld b, $0
	sla c
	inc a
	cp $48
	jr c, .asm_19797
	xor a
.asm_19797
	ld [de], a
	ld hl, Data_197a3 + 1
	add hl, bc
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	ret

Data_197a3:
	dr $197a3, $19833

Func_19833: ; 0x19833
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
	ld hl, Data_19916
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
	ld hl, Data_19916
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	pop af
	ld [de], a
	ret

Func_1988e: ; 0x1988e
	ld a, [wd6b1]
	sla a
	sla a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_198ce
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

Data_198ce:
	dr $198ce, $19916

Data_19916:
	dr $19916, $1994e

Func_1994e: ; 0x1994e
	ld bc, $7f65
	callba DrawTimer
	call Func_1999d
	callba DrawFlippers
	callba DrawPinball
	call Func_19976
	ret

Func_19976: ; 0x19976
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $0
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd6ad]
	ld e, a
	ld d, $0
	ld hl, OAMIds_19995
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_19995:
	db $0F, $10, $11, $12, $17, $18, $19
	db $FF

Func_1999d: ; 0x1999d
	ld de, wd6b6
	call Func_199be
	ld de, wd6be
	call Func_199be
	ld de, wd6c6
	call Func_199be
	ld de, wd6ce
	call Func_199be
	ld de, wd6d6
	call Func_199be
	ld de, wd6de
	; fall through

Func_199be: ; 0x199be
	ld a, [de]
	and a
	ret z
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_199e6
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_199e6:
	db $13, $14, $15, $16, $1A, $1B, $1C, $1D, $1E, $1F, $20
	db $FF

InitDiglettBonusStage: ; 0x199f2
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld [wStageCollisionState], a
	ld a, $1
	ld [wd7ac], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wd49a], a
	; initialize all digletts to hiding
	ld a, $1  ; hiding diglett state
	ld hl, wDiglettStates
	ld b, NUM_DIGLETTS
.initDiglettsLoop
	ld [hli], a
	dec b
	jr nz, .initDiglettsLoop
	ld a, $1
	ld [wDugtrioAnimationFrameCounter], a
	ld a, $c
	ld [wDugtrioAnimationFrame], a
	xor a
	ld [wDugtrioAnimationFrameIndex], a
	ld [wDugrioState], a
	ld a, $11
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

StartBallDiglettBonusStage: ; 0x19a38
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	ld a, $40
	ld [wBallXVelocity], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd73a], a
	ld hl, wDiglettStates
	ld b, NUM_DIGLETTS
.asm_19a60
	ld a, [hl]
	and a
	jr z, .asm_19a67
	ld a, $1  ; hiding diglett state
	ld [hl], a
.asm_19a67
	inc hl
	dec b
	jr nz, .asm_19a60
	xor a
	ld [wCurrentDiglett], a
	ld [wDiglettsInitializedFlag], a
	ld [wd765], a
	ret

Func_19a76: ; 0x19a76
	callba Func_142fc
	call Func_2862
	ld a, [wd7c1]
	and a
	ret z
	call Func_19bbd
	call Func_19a96
	ld a, [wDugrioState]
	and a
	call nz, Func_1ac2c
	ret

Func_19a96: ; 0x19a96
	ld hl, wDiglettStates
	ld bc, NUM_DIGLETTS << 8
.asm_19a9c
	ld a, [hli]
	and a
	jr z, .asm_19aae
	push bc
	push hl
	push af
	call Func_19da8
	pop af
	cp $6
	call c, Func_19dcd
	pop hl
	pop bc
.asm_19aae
	inc c
	dec b
	jr nz, .asm_19a9c
	ret

CheckDiglettBonusStageGameObjectCollisions: ; 0x19ab3
	call CheckDiglettBonusStageDiglettHeadsCollision
	call CheckDiglettBonusStageDugtrioCollision
	ret

CheckDiglettBonusStageDiglettHeadsCollision: ; 0x19aba
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .asm_19b16
	ld a, [wd73b]
	bit 7, a
	jr nz, .asm_19b16
	ld a, [wd7e9]
	and a
	ret z ; is a collision happening?
	ld a, [wCurCollisionAttribute]
	sub $19
	ret c ; is the pinball colliding with a Diglett head?
	cp $33
	ret nc
	ld c, a
	ld b, $0
	ld hl, Data_19b18
	add hl, bc
	ld a, [hl]
	cp $a
	jr nc, .asm_19aed
	ld a, [wBallXPos + 1]
	cp $48
	ld a, $11
	jr nc, .asm_19af7
	xor a
	jr .asm_19af7

.asm_19aed
	ld a, [wBallXPos + 1]
	cp $68
	ld a, $11
	jr nc, .asm_19af7
	xor a
.asm_19af7
	add [hl]
	ld [wTriggeredGameObjectIndex], a
	add $0
	ld [wTriggeredGameObject], a
	ld b, a
	ld hl, wd73b
	ld [hl], $0
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .asm_19b16
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.asm_19b16
	and a
	ret

Data_19b18:
	dr $19b18, $19b4b

CheckDiglettBonusStageDugtrioCollision: ; 0x19b4b
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .asm_19b86
	ld a, [wd75f]
	bit 7, a
	jr nz, .asm_19b86
	ld a, [wd7e9]
	and a
	ret z
	ld a, [wCurCollisionAttribute]
	sub $14
	ret c
	cp $5
	ret nc
	ld a, $1
	ld [wTriggeredGameObjectIndex], a
	add $1f
	ld [wTriggeredGameObject], a
	ld b, a
	ld hl, wd75f
	ld [hl], $0
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .asm_19b86
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.asm_19b86
	and a
	ret

Func_19b88: ; 0x19b88
	call Func_19c52
	call Func_1aad4
	call Func_19b92
	ret

Func_19b92: ; 0x19b92
	ld a, [wd73a]
	and a
	ret nz
	ld a, [wd4b4]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd73a], a
	xor a
	ld [wc853], a
	ld [wc873], a
	ld [wc893], a
	ld a, $5
	ld [wc872], a
	ld a, $7
	ld [wc892], a
	call Func_19bbd
	ret

Func_19bbd: ; 0x19bbd
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_19bda
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_19bd0
	ld hl, Data_19c16
.asm_19bd0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_19bda)
	call Func_10aa
	ret

Data_19bda:
	dr $19bda, $19c16

Data_19c16:
	dr $19c16, $19c52

Func_19c52: ; 0x19c52
	ld a, [wd73b]
	and a
	jr z, .asm_19cc8
	xor a
	ld [wd73b], a
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	lb de, $00, $35
	call PlaySoundEffect
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wd73c]
	sub $1
	ld c, a
	ld b, $0
	ld hl, wDiglettStates
	add hl, bc
	ld a, [hl]
	cp $6
	jr nc, .asm_19cc8
	ld a, $8
	ld [hl], a
	call Func_19da8
	call Func_19df0
	ld hl, wDiglettStates
	ld bc, NUM_DIGLETTS << 8
	xor a
.asm_19ca0
	ld a, [hli]
	and a
	jr z, .asm_19ca8
	cp $6
	jr c, .asm_19ca9
.asm_19ca8
	inc c
.asm_19ca9
	dec b
	jr nz, .asm_19ca0
	ld a, c
	cp NUM_DIGLETTS
	jr nz, .asm_19cc8
	ld hl, Data_1ac75
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $1
	ld [wDugrioState], a
	call Func_1ac2c
	ld de, $0002
	call PlaySong
.asm_19cc8
	call Func_19cdd
	ld a, [wd765]
	and a
	ret nz
	ld a, $1
	ld [wd765], a
	ld a, [wDugrioState]
	and a
	call nz, Func_1ac2c
	ret

Func_19cdd: ; 0x19cdd
	ld a, [wDiglettsInitializedFlag]
	and a
	jr nz, .alreadyInitializedDigletts
	ld a, [wDiglettInitDelayCounter]
	add DIGLETT_INITIALIZE_DELAY
	ld [wDiglettInitDelayCounter], a
	ret nc
	ld hl, DiglettInitializeOrder
	ld a, [wCurrentDiglett]
	ld c, a
	ld b, $0
	add hl, bc
	ld b, $1
.asm_19cf8
	push bc
	ld a, [hli]
	bit 7, a
	jr z, .asm_19d02
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
.asm_19d02
	push hl
	ld c, a
	ld b, $0
	ld hl, wDiglettStates
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_19d29
	dec a
	jr nz, .asm_19d21
	; pick a random starting state for the diglett that isn't the "hiding" state
	call GenRandom
	and $3
	add $2
	ld [hl], a
	call Func_19da8
	call Func_19dcd
	jr .asm_19d29

.asm_19d21
	and $3
	add $2
	ld [hl], a
	call Func_19da8
.asm_19d29
	pop hl
	pop bc
	dec b
	jr nz, .asm_19cf8
	ld hl, wDiglettsInitializedFlag
	ld a, [wCurrentDiglett]
	add $1
	cp NUM_DIGLETTS
	jr c, .notDoneInitializingDigletts
	set 0, [hl]
	sub NUM_DIGLETTS
.notDoneInitializingDigletts
	ld [wCurrentDiglett], a
	ret

.alreadyInitializedDigletts
	ld hl, DiglettUpdateOrder
	ld a, [wCurrentDiglett]
	ld c, a
	ld b, $0
	add hl, bc
	ld b, $4  ; update 4 digletts
.updateDiglettLoop
	push bc
	ld a, [hli]
	bit 7, a
	jr z, .asm_19d58
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
.asm_19d58
	push hl
	ld c, a
	ld b, $0
	ld hl, wDiglettStates
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_19d8f
	dec a
	jr nz, .asm_19d77
	call GenRandom
	and $3
	add $2
	ld [hl], a
	call Func_19da8
	call Func_19dcd
	jr .asm_19d8f

.asm_19d77
	cp $5
	jr c, .incrementDiglettState
	ld [hl], a
	jr nz, .asm_19d8f
	xor a
	ld [hl], a
	ld a, $1
	call Func_19da8
	jr .asm_19d8f

.incrementDiglettState
	and $3
	add $2
	ld [hl], a
	call Func_19da8
.asm_19d8f
	pop hl
	pop bc
	dec b
	jr nz, .updateDiglettLoop
	ld hl, wDiglettsInitializedFlag
	ld a, [wCurrentDiglett]
	add $4
	cp NUM_DIGLETTS
	jr c, .asm_19da4
	set 0, [hl]
	sub NUM_DIGLETTS
.asm_19da4
	ld [wCurrentDiglett], a
	ret

Func_19da8: ; 0x19da8
; input: a = diglett state
;        c = diglett index
	cp $6
	jr c, .asm_19dae
	ld a, $6  ; "getting hit" state
.asm_19dae
	push bc
	ld b, a
	sla c
	ld a, c
	sla c
	add c
	add b  ; a = (index * 6) + state
	dec a
	ld c, a
	ld b, $0  ; bc = (index * 6) + state - 1
	sla c
	rl b  ; bc = 2 * ((index * 6) + state - 1)
	ld hl, DiglettTileDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(DiglettTileDataPointers)
	call Func_10aa
	pop bc
	ret

Func_19dcd: ; 0x19dcd
	sla c
	ld a, c
	sla c
	add c
	ld c, a
	ld b, $0
	ld hl, Data_19e13
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add $1f
	ld e, a
	jr nc, .asm_19dea
	inc d
.asm_19dea
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret

Func_19df0: ; 0x19df0
	sla c
	ld a, c
	sla c
	add c
	ld c, a
	ld b, $0
	ld hl, Data_19e13
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, $2
	ld [de], a
	inc de
	ld [de], a
	ld a, e
	add $1f
	ld e, a
	jr nc, .asm_19e0d
	inc d
.asm_19e0d
	ld a, $2
	ld [de], a
	inc de
	ld [de], a
	ret

Data_19e13:
	dr $19e13, $19ed1

INCLUDE "data/diglett_stage/diglett_stage_animation_data.asm"

Func_1aad4: ; 0x1aad4
	ld a, [wd75f]
	and a
	jr z, .asm_1ab2c
	xor a
	ld [wd75f], a
	ld a, [wDugrioState]
	bit 0, a
	jr z, .asm_1ab2c
	cp $7
	jr z, .asm_1ab2c
	inc a
	ld [wDugrioState], a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1ac62
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueue
	lb de, $00, $36
	call PlaySoundEffect
	ld a, $33
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
.asm_1ab2c
	call Func_1ab30
	ret

Func_1ab30: ; 0x1ab30
	ld a, [wDugrioState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1ac62
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDugtrioAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wDugrioState]
	and a
	ret z
	cp $1
	jr nz, .asm_1ab64
	ld a, [wDugtrioAnimationFrameIndex]
	cp $3
	ret nz
	ld hl, Data_1ac75
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $1
	ld [wDugrioState], a
	ret

.asm_1ab64
	cp $2
	jr nz, .asm_1ab7d
	ld a, [wDugtrioAnimationFrameIndex]
	cp $1
	ret nz
	ld hl, Data_1ac7f
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $3
	ld [wDugrioState], a
	ret

.asm_1ab7d
	cp $3
	jr nz, .asm_1ab96
	ld a, [wDugtrioAnimationFrameIndex]
	cp $3
	ret nz
	ld hl, Data_1ac7f
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $3
	ld [wDugrioState], a
	ret

.asm_1ab96
	cp $4
	jr nz, .asm_1abaf
	ld a, [wDugtrioAnimationFrameIndex]
	cp $1
	ret nz
	ld hl, Data_1ac89
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $5
	ld [wDugrioState], a
	ret

.asm_1abaf
	cp $5
	jr nz, .asm_1abc8
	ld a, [wDugtrioAnimationFrameIndex]
	cp $3
	ret nz
	ld hl, Data_1ac89
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $5
	ld [wDugrioState], a
	ret

.asm_1abc8
	cp $6
	jr nz, .asm_1abe1
	ld a, [wDugtrioAnimationFrameIndex]
	cp $1
	ret nz
	ld hl, Data_1ac93
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	ld a, $7
	ld [wDugrioState], a
	ret

.asm_1abe1
	cp $7
	ret nz
	ld a, [wDugtrioAnimationFrameIndex]
	cp $1
	jr nz, .asm_1abf2
	ld de, $0000
	call PlaySong
	ret

.asm_1abf2
	cp $2
	ret nz
	ld hl, Data_1ac72
	ld de, wDugtrioAnimationFrameCounter
	call CopyHLToDE
	xor a
	ld [wDugrioState], a
	ld [wd498], a
	ld a, $1
	ld [wd49a], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, DiglettStageClearedText
	call LoadTextHeader
	lb de, $4b, $2a
	call PlaySoundEffect
	ld a, $1
	ld [wd7be], a
	call Func_2862
	ld hl, Data_1ac56
	jr asm_1ac2f

Func_1ac2c: ; 0x1ac2c
	ld hl, Data_1ac4a
asm_1ac2f:
	ld de, wc768
	ld b, $3
.asm_1ac34
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
	ld a, e
	add $1d
	ld e, a
	jr nc, .asm_1ac46
	inc d
.asm_1ac46
	dec b
	jr nz, .asm_1ac34
	ret

Data_1ac4a:
	dr $1ac4a, $1ac56

Data_1ac56:
	dr $1ac56, $1ac62

Data_1ac62:
	dr $1ac62, $1ac72

Data_1ac72:
	dr $1ac72, $1ac75

Data_1ac75:
	dr $1ac75, $1ac7f

Data_1ac7f:
	dr $1ac7f, $1ac89

Data_1ac89:
	dr $1ac89, $1ac93

Data_1ac93:
	dr $1ac93, $1ac98

Func_1ac98: ; 0x1ac98
	callba DrawFlippers
	callba DrawPinball
	call Func_1acb0
	ret

Func_1acb0: ; 0x1acb0
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $0
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wDugtrioAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, OAMIds_1accf
	add hl, de
	ld a, [hl]
	bit 7, a
	call z, LoadOAMData2
	ret

OAMIds_1accf:
	db $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52, $53
	db $FF

SECTION "bank7", ROMX, BANK[$7]

InitBlueField: ; 0x1c000
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld hl, wScore + $5
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ld [wNumPartyMons], a
	ld [wd49b], a
	ld [wd4c9], a
	ld [wBallType], a
	ld [wd4c8], a
	ld hl, wd624
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd7ac], a
	ld [wd7be], a
	ld [wCurrentMap], a  ; PALLET_TOWN
	ld a, $1
	ld [wd49d], a
	ld [wd482], a
	ld a, $2
	ld [wRightAlleyCount], a
	ld a, $3
	ld [wd49e], a
	ld [wd610], a
	ld a, $2
	ld [wd498], a
	ld [wd499], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 3], a
	ld a, $82
	ld [wIndicatorStates + 1], a
	xor a
	ld [wd648], a
	ld [wd649], a
	ld [wd64a], a
	ld [wd643], a
	ld [wd644], a
	ld [wd645], a
	ld [wd646], a
	callba Start20SecondSaverTimer
	callba Func_1d65f
	ld a, $10
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

StartBallBlueField: ; 0x1c08d
	ld a, [wd496]
	and a
	jp nz, StartBallAfterBonusStageBlueField
	ld a, $0
	ld [wBallXPos], a
	ld a, $a7
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $98
	ld [wBallYPos + 1], a
	xor a
	ld [wd549], a
	ld [wd580], a
	call Func_1c7c7
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	xor a
	ld [wd50b], a
	ld [wd50c], a
	ld [wd51d], a
	ld [wd51e], a
	ld [wd517], a
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wLeftMapMoveCounter], a
	ld [wRightMapMoveCounter], a
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wBallType], a
	ld [wd611], a
	ld [wd612], a
	ld [wd628], a
	ld [wd629], a
	ld [wd62a], a
	ld [wd62b], a
	ld [wd62c], a
	ld [wd63a], a
	ld [wd63b], a
	ld [wd63d], a
	ld [wd63c], a
	ld [wd62d], a
	ld [wd62e], a
	ld [wd613], a
	inc a
	ld [wd482], a
	ld [wd4ef], a
	ld [wd4f1], a
	ld a, $3
	ld [wd610], a
	call Func_1d65f
	ld a, $10
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

StartBallAfterBonusStageBlueField: ; 0x1c129
	ld a, $0
	ld [wBallXPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $16
	ld [wBallYPos + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wd496], a
	ld [wSCX], a
	ld [wd7be], a
	ld a, [wBallTypeBackup]
	ld [wBallType], a
	ld a, $10
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

Func_1c165: ; 0x1c165
	call asm_1e475
	call Func_1cb43
	call Func_1c3ee
	call Func_1e8f6
	callba Func_142fc
	ld a, $1
	ld [wd640], a
	call Func_1f18a
	callba Func_1404a
	call Func_1c203
	ret

Func_1c191: ; 0x1c191
	call Func_1c1db
	call Func_1c4b6
	call Func_1c2cb
	call Func_1e627
	call Func_1c43c
	call Func_1c305
	call Func_1c3ee
	callba Func_14746
	callba Func_14707
	call Func_1c235
	call Func_1c21e
	call Func_1e8f6
	callba Func_142fc
	callba Func_1404a
	call Func_1c203
	ret

Func_1c1db: ; 0x1c1db
	ld a, [wd641]
	cp $0
	ret z
	ld a, $1
	ld [wd640], a
	ld a, $0
	ld [wd641], a
	ld a, [wBlueStageForceFieldDirection]
	cp $2  ; down direction
	ret nz
	ld a, $0
	ld [wBlueStageForceFieldDirection], a
	ld a, $1  ; right direction
	ld [wd64a], a
	xor a
	ld [wd649], a
	ld [wd648], a
	ret

Func_1c203: ; 0x1c203
	ld a, $ff
	ld [wd4d7], a
	ld [wd4db], a
	ld a, [wd4b4]
	ld [wd4c5], a
	ld a, [wd4b6]
	ld [wd4c6], a
	ld a, [wBallRotation]
	ld [wd4c7], a
	ret

Func_1c21e: ; 0x1c21e
	ld a, $ff
	ld [wd60e], a
	ld [wd60f], a
	ld a, [wd60c]
	call Func_1d5f2
	ld a, [wd60d]
	add $14
	call Func_1d5f2
	ret

Func_1c235: ; 0x1c235
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_1c249
	ld a, $54
	ld [wc7e3], a
	ld a, $55
	ld [wc803], a
	ld a, $1
	jr .asm_1c24a

.asm_1c249
	xor a
.asm_1c24a
	call Func_1de4b
	ld a, [wLeftMapMoveCounter]
	call Func_1de6f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1c267
	ld a, [wLeftMapMoveCounter]
	cp $0
	jr z, .asm_1c264
	ld b, $7
	add b
	jr .asm_1c269

.asm_1c264
	xor a
	jr .asm_1c269

.asm_1c267
	ld a, $8
.asm_1c269
	call Func_1de6f
	ld a, [wRightMapMoveDiglettFrame]
	and a
	jr z, .asm_1c295
	ld a, $52
	ld [wc7f0], a
	ld a, $53
	ld [wc810], a
	ld a, [wd644]
	and a
	jr z, .asm_1c28a
	ld a, [wd55a]
	and a
	jr nz, .asm_1c2bd
	jr .asm_1c291

.asm_1c28a
	ld a, [wRightMapMoveCounter]
	add $3
	jr .asm_1c297

.asm_1c291
	ld a, $3
	jr .asm_1c297

.asm_1c295
	ld a, $2
.asm_1c297
	call Func_1de4b
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_1de6f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1c2b7
	ld a, [wRightMapMoveCounter]
	cp $0
	jr z, .asm_1c2b3
	ld b, $a
	add b
	jr .asm_1c2b9

.asm_1c2b3
	ld a, $4
	jr .asm_1c2b9

.asm_1c2b7
	ld a, $9
.asm_1c2b9
	call Func_1de6f
	ret

.asm_1c2bd
	ld a, $6
	call Func_1de4b
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_1de6f
	ret

Func_1c2cb: ; 0x1c2cb
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld bc, $0000
.asm_1c2d4
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	res 7, a
	call Func_1eb41
	pop bc
	inc c
	ld a, c
	cp $2
	jr nz, .asm_1c2d4
	ld bc, $0002
.asm_1c2e9
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wd648
	add hl, bc
	dec hl
	dec hl
	ld a, [hl]
	ld d, a
	pop af
	add d
	call Func_1eb41
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_1c2e9
	ret

Func_1c305: ; 0x1c305
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	cp $2
	ret z
	ld a, [wd5c6]
	and a
	jr nz, .asm_1c31f
	ld a, [wCapturingMon]
	and a
	jr nz, .asm_1c31f
	jp Func_1c3ca

.asm_1c31f
	callba Func_1c3ac
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_10301
	ld a, [wCapturingMon]
	and a
	ret z
	ld a, BANK(PikachuSaverGfx)
	ld hl, PikachuSaverGfx + $c0
	ld de, vTilesOB tile $7e
	ld bc, $0020
	call FarCopyData
	ld a, BANK(StageSharedPikaBoltGfx)
	ld hl, GFX_a8800
	ld de, vTilesSH tile $10
	ld bc, $0180
	call FarCopyData
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeball
	ld a, Bank(PinballPokeballShakeGfx)
	ld hl, PinballPokeballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

.notPokeball
	cp ULTRA_BALL
	jr nc, .notGreatball
	ld a, Bank(PinballGreatballShakeGfx)
	ld hl, PinballGreatballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

.notGreatball
	cp MASTER_BALL
	jr nc, .notUltraBall
	ld a, Bank(PinballUltraballShakeGfx)
	ld hl, PinballUltraballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

.notUltraBall
	ld a, Bank(PinballMasterballShakeGfx)
	ld hl, PinballMasterballShakeGfx
	ld de, vTilesOB tile $38
	ld bc, $0040
	call FarCopyData
	ret

Func_1c3ac: ; 0x1c3ac
	ld a, $80
	hlCoord 7, 4, vBGMap
	call Func_1c3c3
	hlCoord 7, 5, vBGMap
	call Func_1c3c3
	hlCoord 7, 6, vBGMap
	call Func_1c3c3
	hlCoord 7, 7, vBGMap
	; fall through

Func_1c3c3: ; 0x1c3c3
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

Func_1c3ca: ; 0x1c3ca
	ld hl, wd586
	ld b, $18
.asm_1c3cf
	ld a, [hli]
	xor $1
	ld [hli], a
	dec b
	jr nz, .asm_1c3cf
	callba Func_10184
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_102bc
	ret

Func_1c3ee: ; 0x1c3ee
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	cp $1
	ret nz
	ld a, [wd554]
	cp $3
	ret z
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_1c416
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesOB tile $60
	ld bc, $00e0
	call FarCopyData
	jr .asm_1c424

.asm_1c416
	ld a, BANK(Data_dbe80)
	ld hl, Data_dbe80
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call FarCopyData
.asm_1c424
	ld a, [wd551]
	and a
	ret z
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, BANK(Data_dd188)
	ld hl, Data_dd188
	ld de, $0070
	ld bc, $0010
	call Func_6fd
	ret

Func_1c43c: ; 0x1c43c
	ld a, [wInSpecialMode]
	and a
	jr z, .asm_1c458
	ld a, [wSpecialMode]
	and a
	jr nz, .asm_1c450
	ld a, [wNumMonHits]
	and a
	call nz, Func_1c46d
	ret

.asm_1c450
	cp $1
	jr nz, .asm_1c458
	call Func_1c47d
	ret

.asm_1c458
	ld a, [wd624]
	call Func_1f265
	ld a, BANK(Data_d8f60)
	ld hl, Data_d8f60
	ld de, vTilesSH tile $2e
	ld bc, $0020
	call FarCopyData
	ret

Func_1c46d: ; 0x1c46d
	push af
	callba Func_10611
	pop af
	dec a
	jr nz, Func_1c46d
	ret

Func_1c47d: ; 0x1c47d
	ld de, $0000
	ld a, [wd554]
	and a
	ret z
	ld b, a
.asm_1c486
	ld a, [wCurrentEvolutionType]
	call Func_1c491
	inc de
	dec b
	jr nz, .asm_1c486
	ret

Func_1c491: ; 0x1c491
	push bc
	push de
	dec a
	ld c, a
	ld b, $0
	swap c
	sla c
	ld hl, Data_d8e80
	add hl, bc
	swap e
	sla e
	push hl
	ld hl, vTilesSH tile $2e
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld bc, $0020
	ld a, BANK(Data_d8e80)
	call FarCopyData
	pop de
	pop bc
	ret

Func_1c4b6: ; 0x1c4b6
	ld a, [wInSpecialMode]
	and a
	jr nz, .asm_1c4f0
	ld a, [wd609]
	and a
	jr z, .asm_1c4d2
	ld a, [wd498]
	add $15
	callba Func_30256
	ret

.asm_1c4d2
	ld a, [wd608]
	and a
	jr z, .asm_1c4e5
	ld a, $1a
	callba Func_30256
	ret

.asm_1c4e5
	callba Func_30253
	ret

.asm_1c4f0
	ld a, [wSpecialMode]
	cp $2
	ret nz
	ld a, [wd54d]
	cp $3
	jr nz, .asm_1c508
	callba Func_30253
	ret

.asm_1c508
	ld a, [wd604]
	and a
	ld a, $14
	jr nz, .asm_1c515
	ld a, [wd55a]
	add $12
.asm_1c515
	callba Func_30256
	ret

INCLUDE "engine/collision/blue_stage_game_object_collision.asm"

Func_1c715: ; 0x1c715
	call ResolveShellderCollision
	call ResolveBlueStageSpinnerCollision
	call ResolveBlueStagePinballUpgradeTriggersCollision
	call HandleBlueStageBallTypeUpgradeCounter
	call Func_1e66a
	call ResolveBlueStageBoardTriggerCollision
	call ResolveBlueStagePikachuCollision
	call ResolveSlowpokeCollision
	call ResolveCloysterCollision
	call Func_1ea3b
	call ResolvePsyduckPoliwagCollision
	call ResolveBlueStageForceFieldCollision
	call Func_1e9c0
	call Func_1c8b6
	call Func_1f18a
	callba Func_146a9
	call Func_1f27b
	call Func_1df15
	callba Func_30188
	ld a, $0
	callba Func_10000
	ret

Func_1c769: ; 0x1c769
	call Func_1ca4a
	call Func_1ce40
	call ResolvePsyduckPoliwagCollision
	call Func_1ca85
	call Func_1e4b8
	call HandleBlueStageBallTypeUpgradeCounter
	call Func_1e5c5
	call Func_1c7d7
	call ResolveBlueStagePikachuCollision
	call Func_1ead4
	call ResolveBlueStageBonusMultiplierCollision
	call Func_1e757
	call Func_1e9c0
	call Func_1ea0a
	call Func_1c8b6
	callba Func_14733
	callba Func_146a2
	call Func_1f261
	call Func_1de93
	callba Func_30188
	ld a, $0
	callba Func_10000
	ret

Func_1c7c7: ; 0x1c7c7
	ld a, $0
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ret

Func_1c7d7: ; 0x1c7d7
	ld a, [wPinballLaunchAlley]
	and a
	ret z
	xor a
	ld [wPinballLaunchAlley], a
	ld a, [wd4de]
	and a
	jr z, .asm_1c810
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hl], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld a, $71
	ld [wBallYVelocity], a
	ld a, $fa
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	lb de, $00, $0a
	call PlaySoundEffect
.asm_1c810
	ld a, $ff
	ld [wPreviousTriggeredGameObject], a
	ld a, [wd4de]
	and a
	ret nz
	ld a, [wd4e0]
	and a
	jr nz, .asm_1c82c
	call Func_1c839
	ld a, $1
	ld [wd4e0], a
	ld [wd4de], a
	ret

.asm_1c82c
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	ret z
	ld a, $1
	ld [wd4de], a
	ret

Func_1c839: ; 0x1c839
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, LoadGreyBillboardPaletteData
.showNextMap
	ld a, [wInitialMapSelectionIndex]
	inc a
	cp $7  ; number of maps to choose from at the start of play
	jr c, .gotMapId
	xor a  ; wrap around to 0
.gotMapId
	ld [wInitialMapSelectionIndex], a
	ld c, a
	ld b, $0
	ld hl, BlueStageInitialMaps
	add hl, bc
	ld a, [hl]
	ld [wCurrentMap], a
	push af
	lb de, $00, $48
	call PlaySoundEffect
	pop af
	add (PalletTownPic_Pointer - BillboardPicturePointers) / 3  ; map billboard pictures start at the $29th entry in BillboardPicturePointers
	callba LoadBillboardPicture
	ld b, $20  ; number of frames to delay before the next map is shown
.waitOnCurrentMap
	push bc
	callba Func_eeee
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	jr nz, .ballStartKeyPressed
	pop bc
	dec b
	jr nz, .waitOnCurrentMap
	jr .showNextMap

.ballStartKeyPressed
	pop bc
	callba Func_30253
	ld bc, StartFromMapText
	callba Func_3118f
	ld a, [wCurrentMap]
	ld [wd4e3], a
	xor a
	ld [wd4e2], a
	ret

BlueStageInitialMaps: ; 0x1c8af
	db VIRIDIAN_CITY
	db VIRIDIAN_FOREST
	db MT_MOON
	db CERULEAN_CITY
	db VERMILION_STREETS
	db ROCK_MOUNTAIN
	db CELADON_CITY

Func_1c8b6: ; 0x1c8b6
	ld a, [wd64c]
	inc a
	cp $3c
	jr z, .asm_1c8c2
	ld [wd64c], a
	ret

.asm_1c8c2
	xor a
	ld [wd64c], a
	ld hl, wd64d
	inc [hl]
	ld a, [hl]
	cp $5
	ret nz
	ld a, [wd644]
	and a
	jr nz, .asm_1c8e1
	ld a, [wd643]
	and a
	jr nz, .asm_1c8e5
	ld a, [wRightAlleyCount]
	cp $2
	jr nc, .asm_1c8e5
.asm_1c8e1
	xor a
	ld [wd64b], a
.asm_1c8e5
	ld a, [wd644]
	and a
	jr nz, .asm_1c8f8
	ld a, [wd643]
	and a
	jr nz, .asm_1c8fc
	ld a, [wLeftAlleyCount]
	cp $3
	jr z, .asm_1c8fc
.asm_1c8f8
	xor a
	ld [wd64b], a
.asm_1c8fc
	xor a
	ld [wd64d], a
	xor a
	ld [wd64a], a
	ld [wd649], a
	ld [wd648], a
	ld a, [wBlueStageForceFieldDirection]
	cp $1  ; right direction
	jr z, .asm_1c97f
	cp $3  ; left direction
	jr z, .asm_1c97f
.asm_1c915
	ld a, [wd644]
	cp $0
	jr z, .asm_1c925
	ld a, [wd55a]
	cp $0
	jr nz, .asm_1c933
	jr .asm_1c947

.asm_1c925
	ld a, [wd643]
	cp $0
	jr nz, .asm_1c933
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .asm_1c947
.asm_1c933
	ld a, [wd64b]
	cp $1
	jr z, .asm_1c947
	ld a, $1  ; right direction
	ld [wBlueStageForceFieldDirection], a
	ld [wd64b], a
	ld [wd640], a
	jr .asm_1c99e

.asm_1c947
	ld a, [wd644]
	cp $0
	jr z, .asm_1c955
	ld a, [wd55a]
	cp $0
	jr z, .asm_1c969
.asm_1c955
	ld a, [wd643]
	cp $0
	jr nz, .asm_1c969
	ld a, [wLeftAlleyCount]
	cp $3
	jr nz, .asm_1c97f
	ld a, [wInSpecialMode]
	and a
	jr nz, .asm_1c97f
.asm_1c969
	ld a, [wd64b]
	cp $3
	jr z, .asm_1c915
	ld a, $3  ; left direction
	ld [wBlueStageForceFieldDirection], a
	ld [wd64b], a
	ld a, $1
	ld [wd640], a
	jr .asm_1c99e

.asm_1c97f
	ld a, [wd641]
	and a
	jr nz, .asm_1c993
	xor a
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wd640], a
	ld [wd64a], a
	jr .asm_1c99e

.asm_1c993
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wd640], a
	ret

.asm_1c99e
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jr nz, .asm_1c9ac
	ld a, $1
	ld [wd64a], a
	jr .asm_1c9c0

.asm_1c9ac
	cp $1
	jr nz, .asm_1c9b7
	ld a, $1
	ld [wd649], a
	jr .asm_1c9c0

.asm_1c9b7
	cp $3
	jr nz, .asm_1c9c0
	ld a, $1
	ld [wd648], a
.asm_1c9c0
	ret

ResolveShellderCollision: ; 0x1c9c1
	ld a, [wWhichShellder]
	and a
	jr z, .noCollision
	xor a
	ld [wWhichShellder], a
	call Func_1ca29
	ld a, [wd641]
	and a
	jr nz, .asm_1c9f2
	ld a, $1
	ld [wd641], a
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jr nz, .asm_1c9f2
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wd640], a
	ld a, $3
	ld [wd64c], a
	ld [wd64d], a
.asm_1c9f2
	ld a, $10
	ld [wd4d6], a
	ld a, [wWhichShellderId]
	sub $3
	ld [wd4d7], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.noCollision
	ld a, [wd4d6]
	and a
	ret z
	dec a
	ld [wd4d6], a
	ret nz
	ld a, $ff
	ld [wd4d7], a
	ret

Func_1ca29: ; 0x1ca29
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $0e
	call PlaySoundEffect
	ret

Func_1ca4a: ; 1ca4a
	ld a, [wWildMonCollision]
	and a
	ret z
	xor a
	ld [wWildMonCollision], a
	ld a, $1
	ld [wBallHitWildMon], a
	lb de, $00, $06
	call PlaySoundEffect
	ret

ResolveBlueStageSpinnerCollision: ; 0x1ca5f
	ld a, [wSpinnerCollision]
	and a
	jr z, Func_1ca85
	xor a
	ld [wSpinnerCollision], a
	ld a, [wBallYVelocity]
	ld c, a
	ld a, [wBallYVelocity + 1]
	ld b, a
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld a, $c
	callba Func_10000
	; fall through

Func_1ca85: ; 0x1ca85
	ld hl, wd50b
	ld a, [hli]
	or [hl]
	ret z
	ld a, [wd50b]
	ld c, a
	ld a, [wd50c]
	ld b, a
	bit 7, b
	jr nz, .asm_1caa3
	ld a, c
	sub $7
	ld c, a
	ld a, b
	sbc $0
	ld b, a
	jr nc, .asm_1cab0
	jr .asm_1caad

.asm_1caa3
	ld a, c
	add $7
	ld c, a
	ld a, b
	adc $0
	ld b, a
	jr nc, .asm_1cab0
.asm_1caad
	ld bc, $0000
.asm_1cab0
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld hl, wd50b
	ld a, [wd509]
	add [hl]
	ld [wd509], a
	inc hl
	ld a, [wd50a]
	adc [hl]
	bit 7, a
	ld c, $0
	jr z, .asm_1cad3
	add $18
	ld c, $1
	jr .asm_1cadb

.asm_1cad3
	cp $18
	jr c, .asm_1cadb
	sub $18
	ld c, $1
.asm_1cadb
	ld [wd50a], a
	ld a, c
	and a
	ret z
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd62d
	call Func_e4a
	ld a, [wd517]
	cp $f
	jr nz, .asm_1caff
	call Func_1cb1c
	ret

.asm_1caff
	inc a
	ld [wd517], a
	call Func_1cb1c
	ld a, [wd517]
	cp $f
	jr nz, .asm_1cb12
	ld a, $64
	ld [wd51e], a
.asm_1cb12
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	call Func_1cb43
	ret

Func_1cb1c: ; 0x1cb1c
	ld a, [wd51e]
	and a
	ret nz
	ld a, [wd517]
	ld c, a
	ld b, $0
	ld hl, Data_1cb33
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

Data_1cb33:
	dr $1cb33, $1cb43

Func_1cb43: ; 0x1cb43
	ld a, [wd517]
	ld c, a
	sla c
	ld b, $0
	ld hl, Data_1cb60
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1cb56
	ld hl, Data_1cd10
.asm_1cb56
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_1cb60)
	call Func_10aa
	ret

Data_1cb60:
	dr $1cb60, $1cd10

Data_1cd10:
	dr $1cd10, $1ce40

Func_1ce40: ; 1ce40
	ld a, [wWhichBumper]
	and a
	jr z, .asm_1ce53
	call Func_1ce72
	call Func_1ce60
	xor a
	ld [wWhichBumper], a
	call Func_1ce94
.asm_1ce53
	ld a, [wd4da]
	and a
	ret z
	dec a
	ld [wd4da], a
	call z, Func_1ce72
	ret

Func_1ce60: ; 0x1ce60
	ld a, $10
	ld [wd4da], a
	ld a, [wWhichBumperId]
	sub $1
	ld [wd4db], a
	sla a
	inc a
	jr asm_1ce7a

Func_1ce72: ; 1ce72
	ld a, [wd4db]
	cp $ff
	ret z
	sla a
asm_1ce7a: ; 0x1ce7a
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1ceca
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1ce8a
	ld hl, Data_1cf3a
.asm_1ce8a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_1ceca)
	call Func_10aa
	ret

Func_1ce94: ; 0x1ce94
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wWhichBumperId]
	sub $1
	ld c, a
	ld b, $0
	ld hl, Data_1cec8
	add hl, bc
	ld a, [wCollisionForceAngle]
	add [hl]
	ld [wCollisionForceAngle], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

Data_1cec8:
	dr $1cec8, $1ceca

Data_1ceca:
	dr $1ceca, $1cf3a

Data_1cf3a:
	dr $1cf3a, $1cfaa

ResolveBlueStageBoardTriggerCollision: ; 0x1cfaa
	ld a, [wWhichBoardTrigger]
	and a
	ret z
	xor a
	ld [wWhichBoardTrigger], a
	ld bc, FivePoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wStageCollisionState]
	cp $0
	jr nz, .asm_1cfe5
	ld a, $1
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ld a, $1
	ld [wd580], a
	callba Func_1404a
.asm_1cfe5
	ld a, [wWhichBoardTriggerId]
	sub $7
	ld c, a
	ld b, $0
	ld hl, wd521
	add hl, bc
	ld [hl], $1
	ld a, [wd521]
	and a
	call nz, Func_1d010
	ld a, [wd522]
	and a
	call nz, Func_1d047
	ld a, [wd523]
	and a
	call nz, HandleLeftAlleyTriggerBlueField
	ld a, [wd524]
	and a
	call nz, HandleRightAlleyTriggerBlueField
	ret

Func_1d010: ; 0x1d010
	xor a
	ld [wd521], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba Func_10000
	ret c
	ld a, [wLeftAlleyCount]
	cp $3
	ret z
	inc a
	ld [wLeftAlleyCount], a
	cp $3
	jr z, .asm_1d03e
	set 7, a
	ld [wIndicatorStates], a
	ret

.asm_1d03e
	ld [wIndicatorStates], a
	ld a, $80
	ld [wIndicatorStates + 2], a
	ret

Func_1d047: ; 0x1d047
	xor a
	ld [wd522], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba Func_10000
	ret c
	ld a, [wRightAlleyCount]
	cp $3
	ret z
	inc a
	ld [wRightAlleyCount], a
	cp $3
	jr z, .asm_1d071
	set 7, a
.asm_1d071
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

HandleLeftAlleyTriggerBlueField: ; 0x1d080
; Ball passed over the left alley trigger point in the Blue Field.
	xor a
	ld [wd523], a
	ld [wRightAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wLeftAlleyTrigger], a
	ret c
	ret

HandleRightAlleyTriggerBlueField: ; 0x1d091
; Ball passed over the right alley trigger point in the Blue Field.
	xor a
	ld [wd524], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wRightAlleyTrigger], a
	ret

ResolveBlueStagePikachuCollision: ; 0x1d0a1
	ld a, [wWhichPikachu]
	and a
	jr z, .asm_1d110
	xor a
	ld [wWhichPikachu], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1d110
	ld a, [wd51d]
	and a
	jr nz, .asm_1d0c9
	ld a, [wWhichPikachuId]
	sub $d
	ld hl, wd518
	cp [hl]
	jr nz, .asm_1d110
	ld a, [wd517]
	cp $f
	jr nz, .asm_1d0fc
.asm_1d0c9
	ld hl, PikachuSaverAnimationDataRedStage
	ld de, wPikachuSaverAnimationFrameCounter
	call CopyHLToDE
	ld a, [wd51d]
	and a
	jr nz, .asm_1d0dc
	xor a
	ld [wd517], a
.asm_1d0dc
	ld a, $1
	ld [wd51c], a
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld [wd549], a
	call FillBottomMessageBufferWithBlackTile
	jr .asm_1d110

.asm_1d0fc
	ld hl, PikachuSaverAnimation2DataRedStage
	ld de, wPikachuSaverAnimationFrameCounter
	call CopyHLToDE
	ld a, $2
	ld [wd51c], a
	lb de, $00, $3b
	call PlaySoundEffect
.asm_1d110
	ld a, [wd51c]
	and a
	call z, Func_1d1fb
	call Func_1d133
	ld a, [wd517]
	cp $f
	ret nz
	ld a, [wd51e]
	and a
	ret z
	dec a
	ld [wd51e], a
	cp $5a
	ret nz
	lb de, $0f, $22
	call PlaySoundEffect
	ret

Func_1d133: ; 0x1d133
	ld a, [wd51c]
	cp $1
	jr nz, .asm_1d1ae
	ld hl, PikachuSaverAnimationDataRedStage
	ld de, wPikachuSaverAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $1
	jr nz, .asm_1d18c
	xor a
	ld [wd85d], a
	call Func_310a
	rst AdvanceFrame
	ld a, $1
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wd85d], a
	ld a, $ff
	ld [wd803], a
	ld a, $60
	ld [wd804], a
	ld hl, wd62e
	call Func_e4a
	jr nc, .asm_1d185
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_1d185
	lb de, $16, $10
	call PlaySoundEffect
	ret

.asm_1d18c
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $11
	ret nz
	ld a, $fc
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wd51c], a
	ret

.asm_1d1ae
	cp $2
	jr nz, .asm_1d1c7
	ld hl, PikachuSaverAnimation2DataRedStage
	ld de, wPikachuSaverAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $1
	ret nz
	xor a
	ld [wd51c], a
	ret

.asm_1d1c7
	ld a, [hNumFramesDropped]
	swap a
	and $1
	ld [wPikachuSaverAnimationFrame], a
	ret

PikachuSaverAnimationDataRedStage: ; 0x1d1d1
; Each entry is [duration][OAM id]
	db $0C, $02
	db $05, $03
	db $05, $02
	db $05, $04
	db $05, $05
	db $05, $02
	db $06, $06
	db $06, $07
	db $06, $08
	db $06, $02
	db $06, $05
	db $06, $08
	db $06, $07
	db $06, $02
	db $06, $08
	db $06, $07
	db $06, $02
	db $01, $00
	db $00

PikachuSaverAnimation2DataRedStage: ; 0x1d1f6
; Each entry is [duration][OAM id]
	db $0C, $02
	db $01, $00
	db $00

Func_1d1fb: ; 0x1d1fb
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	jr z, .asm_1d209
	ld hl, wd518
	ld [hl], $0
	ret

.asm_1d209
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ret z
	ld hl, wd518
	ld [hl], $1
	ret

ResolveSlowpokeCollision: ; 0x1d216
	ld a, [wSlowpokeCollision]
	and a
	jr z, .asm_1d253
	xor a
	ld [wSlowpokeCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, Data_1d312
	ld de, wd632
	call CopyHLToDE
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	xor a
	ld [wd549], a
.asm_1d253
	ld hl, Data_1d312
	ld de, wd632
	call UpdateAnimation
	push af
	ld a, [wd632]
	and a
	jr nz, .asm_1d271
	ld a, $19
	ld [wd632], a
	xor a
	ld [wd633], a
	ld a, $6
	ld [wd634], a
.asm_1d271
	pop af
	ret nc
	ld a, [wd634]
	cp $1
	jr nz, .asm_1d2b6
	xor a
	ld [wd548], a
	ld a, [wLeftAlleyCount]
	cp $3
	jr nz, .asm_1d299
	callba Func_10ab3
	ld a, [wd643]
	and a
	ret z
	ld a, $1
	ld [wd642], a
.asm_1d299
	ld hl, wd63a
	call Func_e4a
	ld hl, wd62a
	call Func_e4a
	ret nc
	ld c, $19
	call Func_e55
	callba z, Func_30164
	ret

.asm_1d2b6
	ld a, [wd634]
	cp $4
	jr nz, .asm_1d2c3
	ld a, $1
	ld [wd548], a
	ret

.asm_1d2c3
	ld a, [wd634]
	cp $5
	ret nz
	ld a, $1
	ld [wd549], a
	ld a, $b0
	ld [wBallXVelocity], a
	ld a, $0
	ld [wBallXVelocity + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, [wd642]
	cp $0
	jr nz, .asm_1d2f8
	ld a, $f
	callba Func_10000
.asm_1d2f8
	xor a
	ld [wd642], a
	ld [wd64c], a
	ld [wd64d], a
	ld a, $1
	ld [wd641], a
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wd640], a
	ret

Data_1d312:
	dr $1d312, $1d32d

ResolveCloysterCollision: ; 0x1d32d
	ld a, [wCloysterCollision]
	and a
	jr z, .asm_1d36a
	xor a
	ld [wCloysterCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, Data_1d41d
	ld de, wd637
	call CopyHLToDE
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	xor a
	ld [wd549], a
.asm_1d36a
	ld hl, Data_1d41d
	ld de, wd637
	call UpdateAnimation
	push af
	ld a, [wd637]
	and a
	jr nz, .asm_1d388
	ld a, $19
	ld [wd637], a
	xor a
	ld [wd638], a
	ld a, $6
	ld [wd639], a
.asm_1d388
	pop af
	ret nc
	ld a, [wd639]
	cp $1
	jr nz, .asm_1d3cb
	xor a
	ld [wd548], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .noCatchEmMode
	ld a, $8
	jr nz, .asm_1d3a1
	xor a
.asm_1d3a1
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
.noCatchEmMode
	ld hl, wd63b
	call Func_e4a
	ld hl, wd62a
	call Func_e4a
	ret nc
	ld c, $19
	call Func_e55
	callba z, Func_30164
	ret

.asm_1d3cb
	ld a, [wd639]
	cp $4
	jr nz, .asm_1d3d8
	ld a, $1
	ld [wd548], a
	ret

.asm_1d3d8
	ld a, [wd639]
	cp $5
	ret nz
	ld a, $1
	ld [wd549], a
	ld a, $4f
	ld [wBallXVelocity], a
	ld a, $ff
	ld [wBallXVelocity + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, $e
	callba Func_10000
	xor a
	ld [wd64c], a
	ld [wd64d], a
	ld a, $1
	ld [wd641], a
	ld a, $2  ; down direction
	ld [wBlueStageForceFieldDirection], a
	ld a, $1
	ld [wd640], a
	ret

Data_1d41d:
	dr $1d41d, $1d438

ResolveBlueStageBonusMultiplierCollision: ; 0x1d438
	call Func_1d692
	ld a, [wWhichBonusMultiplierRailing]
	and a
	jp z, Func_1d51b
	xor a
	ld [wWhichBonusMultiplierRailing], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wWhichBonusMultiplierRailingId]
	sub $f
	jr nz, .asm_1d48e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d45c
	ld a, $1f
	jr .asm_1d45e

.asm_1d45c
	ld a, $29
.asm_1d45e
	call Func_1d5f2
	ld a, $3c
	ld [wd647], a
	ld a, $9
	callba Func_10000
	ld a, [wd610]
	cp $3
	jp nz, asm_1d4fa
	ld a, $1
	ld [wd610], a
	ld a, $3
	ld [wd611], a
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	jr asm_1d4fa

.asm_1d48e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d497
	ld a, $21
	jr .asm_1d499

.asm_1d497
	ld a, $2b
.asm_1d499
	call Func_1d5f2
	ld a, $1e
	ld [wd647], a
	ld a, $a
	callba Func_10000
	ld a, [wd611]
	cp $3
	jr nz, asm_1d4fa
	ld a, $1
	ld [wd610], a
	ld a, $1
	ld [wd611], a
	ld a, $80
	ld [wd612], a
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	ld a, [wd482]
	inc a
	cp 100
	jr c, .asm_1d4d5
	ld a, 99
.asm_1d4d5
	ld [wd482], a
	jr nc, .asm_1d4e9
	ld c, $19
	call Func_e55
	callba z, Func_30164
.asm_1d4e9
	ld a, [wd60c]
	ld [wd614], a
	ld a, [wd60d]
	ld [wd615], a
	ld a, $1
	ld [wd613], a
asm_1d4fa: ; 0x1d4fa
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd60c]
	call Func_1d5f2
	ld a, [wd60d]
	add $14
	call Func_1d5f2
	ld a, $3c
	ld [wd647], a
	ret

Func_1d51b: ; 0x1d51b
	call Func_1d5bf
	ld a, [wd612]
	and a
	jr z, .asm_1d559
	dec a
	ld [wd612], a
	cp $70
	jr nz, .asm_1d538
	ld a, $2
	ld [wd610], a
	ld a, $2
	ld [wd611], a
	jr .asm_1d559

.asm_1d538
	and a
	jr nz, .asm_1d559
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld a, [wd482]
	call Func_1d65f
	ld a, [wd60c]
	call Func_1d5f2
	ld a, [wd60d]
	add $14
	call Func_1d5f2
	ret

.asm_1d559
	ld a, [wd610]
	cp $2
	jr c, .asm_1d58b
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_1d56a
	srl a
	srl a
.asm_1d56a
	ld b, a
	and $3
	jr nz, .asm_1d58b
	bit 3, b
	jr nz, .asm_1d580
	ld a, [wd60c]
	res 7, a
	ld [wd60c], a
	call Func_1d5f2
	jr .asm_1d58b

.asm_1d580
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	call Func_1d5f2
.asm_1d58b
	ld a, [wd611]
	cp $2
	ret c
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_1d59b
	srl a
	srl a
.asm_1d59b
	ld b, a
	and $3
	ret nz
	bit 3, b
	jr nz, .asm_1d5b1
	ld a, [wd60d]
	res 7, a
	ld [wd60d], a
	add $14
	call Func_1d5f2
	ret

.asm_1d5b1
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	add $14
	call Func_1d5f2
	ret

Func_1d5bf: ; 0x1d5bf
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd613]
	and a
	ret z
	xor a
	ld [wd613], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, BonusMultiplierText
	call LoadTextHeader
	ld hl, wBottomMessageText + $12
	ld a, [wd614]
	and $7f
	jr z, .asm_1d5e9
	add $30
	ld [hli], a
.asm_1d5e9
	ld a, [wd615]
	res 7, a
	add $30
	ld [hl], a
	ret

Func_1d5f2: ; 0x1d5f2
	push af
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d5fd
	pop af
	call Func_1d602
	ret

.asm_1d5fd
	pop af
	call Func_1d645
	ret

Func_1d602: ; 0x1d602
	push af
	res 7, a
	ld hl, wd60e
	cp $14
	jr c, .asm_1d611
	ld hl, wd60f
	sub $a
.asm_1d611
	cp [hl]
	jr z, .asm_1d626
	ld [hl], a
	ld c, a
	ld b, $0
	sla c
	ld hl, Data_1d6be
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_1d6be)
	call Func_10aa
.asm_1d626
	pop af
	ld bc, $0000
	bit 7, a
	jr z, .asm_1d632
	res 7, a
	set 1, c
.asm_1d632
	cp $14
	jr c, .asm_1d638
	set 2, c
.asm_1d638
	ld hl, Data_1d946
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_1d946)
	call Func_10aa
	ret

Func_1d645: ; 0x1d645
	bit 7, a
	jr z, .asm_1d64d
	res 7, a
	add $a
.asm_1d64d
	ld c, a
	ld b, $0
	sla c
	ld hl, Data_1d97a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_1d97a)
	call Func_10aa
	ret

Func_1d65f: ; 0x1d65f
	ld a, [wd482]
	inc a
	cp $64
	jr c, .asm_1d669
	ld a, $63
.asm_1d669
	ld b, a
	xor a
	ld hl, Data_1d68b
	ld c, $7
.asm_1d670
	bit 0, b
	jr z, .asm_1d676
	add [hl]
	daa
.asm_1d676
	srl b
	inc hl
	dec c
	jr nz, .asm_1d670
	push af
	swap a
	and $f
	ld [wd60c], a
	pop af
	and $f
	ld [wd60d], a
	ret

Data_1d68b:
	dr $1d68b, $1d692

Func_1d692: ; 0x1d692
	ld a, [wd647]
	cp $1
	jr z, .asm_1d69e
	dec a
	ld [wd647], a
	ret

.asm_1d69e
	ld a, $0
	ld [wd647], a
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1d6b3
	ld a, $1e
	call Func_1d5f2
	ld a, $20
	call Func_1d5f2
	ret

.asm_1d6b3
	ld a, $2a
	call Func_1d5f2
	ld a, $28
	call Func_1d5f2
	ret

Data_1d6be:
	dr $1d6be, $1d946

Data_1d946:
	dr $1d946, $1d97a

Data_1d97a:
	dr $1d97a, $1dbd2

ResolvePsyduckPoliwagCollision: ; 0x1dbd2
	ld a, [wWhichPsyduckPoliwag]
	and a
	jp z, Func_1dc8e
	cp $2
	jr z, .asm_1dc33
	xor a
	ld [wWhichPsyduckPoliwag], a
	ld hl, wLeftMapMoveCounter
	ld a, [hl]
	cp $3
	jp z, Func_1dc8e
	inc a
	ld [hl], a
	ld hl, wd4f7
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dc06
	ld a, $54
	ld [wc7e3], a
	ld a, $55
	ld [wc803], a
.asm_1dc06
	ld a, $1
	call Func_1de4b
	ld a, [wLeftMapMoveCounter]
	call Func_1de6f
	ld a, [wLeftMapMoveCounter]
	cp $3
	ld a, $7
	callba Func_10000
	ld a, $2
	ld [wd646], a
	ld a, $78
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, $14
	ld [wLeftMapMoveDiglettFrame], a
	jr .asm_1dc8a

.asm_1dc33
	xor a
	ld [wWhichPsyduckPoliwag], a
	ld hl, wRightMapMoveCounter
	ld a, [hl]
	cp $3
	jp z, Func_1dc8e
	inc a
	ld [hl], a
	ld hl, wd4f9
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dc5c
	ld a, $52
	ld [wc7f0], a
	ld a, $53
	ld [wc810], a
.asm_1dc5c
	ld a, $3
	call Func_1de4b
	ld a, [wRightMapMoveCounter]
	cp $3
	ld a, $8
	callba Func_10000
	ld a, [wRightMapMoveCounter]
	cp $3
	ccf
	call z, Func_1ddf4
	ld a, $2
	ld [wd645], a
	ld a, $28
	ld [wRightMapMoveDiglettAnimationCounter], a
	ld a, $78
	ld [wRightMapMoveDiglettFrame], a
.asm_1dc8a
	call Func_1de22
	ret

Func_1dc8e: ; 0x1dc8e
	call Func_1dc95
	call Func_1dd2e
	ret

Func_1dc95: ; 0x1dc95
	ld a, [wd646]
	cp $0
	ret z
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_1dceb
	dec a
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, [wd644]
	and a
	ret nz
	ld a, [wLeftMapMoveDiglettFrame]
	cp $1
	jr z, .asm_1dcb9
	cp $0
	ret z
	dec a
	ld [wLeftMapMoveDiglettFrame], a
	ret

.asm_1dcb9
	ld a, [wd646]
	cp $2
	ret nz
	call Func_1130
	ret nz
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1dcd7
	ld a, [wLeftMapMoveCounter]
	cp $0
	jr z, .asm_1dcd4
	ld b, $7
	add b
	jr .asm_1dcd9

.asm_1dcd4
	xor a
	jr .asm_1dcd9

.asm_1dcd7
	ld a, $8
.asm_1dcd9
	call Func_1de6f
	ld a, [wLeftMapMoveCounter]
	cp $3
	ccf
	call z, Func_1ddc7
	ld a, $1
	ld [wd646], a
	ret

.asm_1dceb
	ld a, [wd646]
	cp $1
	ret nz
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	ret nz
	ld a, $0
	call Func_1de4b
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dd0c
	ld a, $5e
	ld [wc7e3], a
	ld a, $5f
	ld [wc803], a
.asm_1dd0c
	ld a, $0
	ld [wd646], a
	ld a, [wLeftMapMoveCounter]
	sub $3
	ret nz
	ld a, [wLeftMapMoveCounter]
	sub $3
	ld [wLeftMapMoveCounter], a
	call Func_1de6f
	ld a, $0
	call Func_1de4b
	ld a, $0
	ld [wd646], a
	ret

; XXX
	ret

Func_1dd2e: ; 0x1dd2e
	ld a, [wd645]
	cp $0
	ret z
	cp $1
	jr z, .asm_1dd53
	cp $3
	jr z, .asm_1dd69
	ld a, [wRightMapMoveDiglettAnimationCounter]
	cp $0
	jr z, .asm_1dd48
	dec a
	ld [wRightMapMoveDiglettAnimationCounter], a
	ret

.asm_1dd48
	ld a, $2
	call Func_1de4b
	ld a, $1
	ld [wd645], a
	ret

.asm_1dd53
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_1de6f
	ld a, [wRightMapMoveCounter]
	add $3
	call Func_1de4b
	ld a, $3
	ld [wd645], a
	ret

.asm_1dd69
	ld a, [wRightMapMoveDiglettFrame]
	and a
	jr z, .asm_1dd74
	dec a
	ld [wRightMapMoveDiglettFrame], a
	ret

.asm_1dd74
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1dd89
	ld a, [wRightMapMoveCounter]
	cp $0
	jr z, .asm_1dd85
	ld b, $a
	add b
	jr .asm_1dd8b

.asm_1dd85
	ld a, $4
	jr .asm_1dd8b

.asm_1dd89
	ld a, $9
.asm_1dd8b
	call Func_1de6f
	ld a, $2
	call Func_1de4b
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_1dda9
	ld a, $24
	ld [wc7f0], a
	ld a, $25
	ld [wc810], a
	ld a, $0
	ld [wd645], a
.asm_1dda9
	ld a, [wRightMapMoveCounter]
	sub $3
	ret nz
	ld a, [wRightMapMoveCounter]
	sub $3
	ld [wRightMapMoveCounter], a
	ld a, $4
	call Func_1de6f
	ld a, $2
	call Func_1de4b
	ld a, $0
	ld [wd645], a
	ret

Func_1ddc7: ; 0x1ddc7
	ld hl, wd63d
	call Func_e4a
	ld hl, wd62b
	call Func_e4a
	jr nc, .asm_1dde4
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_1dde4
	xor a
	ld [wd55a], a
	callba StartMapMoveMode
	scf
	ret

Func_1ddf4: ; 0x1ddf4
	ld hl, wd63c
	call Func_e4a
	ld hl, wd62b
	call Func_e4a
	jr nc, .asm_1de11
	ld c, $a
	call Func_e55
	callba z, Func_30164
.asm_1de11
	ld a, $1
	ld [wd55a], a
	callba StartMapMoveMode
	scf
	ret

Func_1de22: ; 0x1de22
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, $55
	ld [wd803], a
	ld a, $4
	ld [wd804], a
	ld a, $2
	ld [wd7eb], a
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $0f
	call PlaySoundEffect
	ret

Func_1de4b: ; 0x1de4b
	ld b, a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, b
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1df66
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1de63
	ld hl, Data_1e00f
.asm_1de63
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_1df66)
	call Func_10aa
	ret

Func_1de6f: ; 0x1de6f
	ld b, a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, b
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1e0a4
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1de87
	ld hl, Data_1e1d6
.asm_1de87
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_1e0a4)
	call Func_10aa
	ret

Func_1de93: ; 0x1de93
	ld hl, wd4f7
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1ded2
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1ded2
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_1ded2
	cp $3
	jr z, .asm_1ded2
	dec a
	ld [wLeftMapMoveCounter], a
	call Func_1de6f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1decd
	ld a, [wLeftMapMoveCounter]
	cp $0
	jr z, .asm_1deca
	ld b, $7
	add b
	jr .asm_1decf

.asm_1deca
	xor a
	jr .asm_1decf

.asm_1decd
	ld a, $8
.asm_1decf
	call Func_1de6f
.asm_1ded2
	ld hl, wd4f9
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1df14
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1df14
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_1df14
	cp $3
	jr z, .asm_1df14
	dec a
	ld [wRightMapMoveCounter], a
	add $4
	call Func_1de6f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1df0f
	ld a, [wRightMapMoveCounter]
	cp $0
	jr z, .asm_1df0b
	ld b, $a
	add b
	jr .asm_1df11

.asm_1df0b
	ld a, $4
	jr .asm_1df11

.asm_1df0f
	ld a, $9
.asm_1df11
	call Func_1de6f
.asm_1df14
	ret

Func_1df15: ; 0x1df15
	ld b, $0
	ld hl, wd4f8
	ld a, [hld]
	or [hl]
	jr z, .asm_1df3e
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1df3e
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1df3e
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_1df3e
	cp $3
	jr z, .asm_1df3e
	dec a
	ld [wLeftMapMoveCounter], a
.asm_1df3e
	ld hl, wd4fa
	ld a, [hld]
	or [hl]
	jr z, .asm_1df65
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1df65
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1df65
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_1df65
	cp $3
	jr z, .asm_1df65
	dec a
	ld [wRightMapMoveCounter], a
.asm_1df65
	ret

Data_1df66:
	dr $1df66, $1e00f

Data_1e00f:
	dr $1e00f, $1e0a4

Data_1e0a4:
	dr $1e0a4, $1e1d6

Data_1e1d6:
	dr $1e1d6, $1e356

ResolveBlueStagePinballUpgradeTriggersCollision: ; 0x1e356
	ld a, [wWhichPinballUpgradeTrigger]
	and a
	jp z, Func_1e471
	xor a
	ld [wWhichPinballUpgradeTrigger], a
	ld a, [wStageCollisionState]
	cp $0
	jr nz, .asm_1e386
	ld a, $1
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	ld a, $1
	ld [wd580], a
	callba Func_1404a
.asm_1e386
	ld a, [wStageCollisionState]
	bit 0, a
	jp z, Func_1e471
	ld a, [wd5fc]
	and a
	jp nz, Func_1e471
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $b
	callba Func_10000
	ld a, [wWhichPinballUpgradeTriggerId]
	sub $13
	ld c, a
	ld b, $0
	ld hl, wd5f9
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	jr z, .asm_1e3bf
	ld [hl], $0
.asm_1e3bf
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd5f9
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	jr nz, .asm_1e3de
	lb de, $00, $09
	call PlaySoundEffect
	jp asm_1e475

.asm_1e3de
	ld a, $1
	ld [wd5fc], a
	ld a, $80
	ld [wd5fd], a
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wBallType]
	cp MASTER_BALL
	jr z, .masterBall
	lb de, $06, $3a
	call PlaySoundEffect
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, FieldMultiplierText
	call LoadTextHeader
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgression2BlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .asm_1e465

.masterBall
	lb de, $0f, $4d
	call PlaySoundEffect
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $0100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, DigitsText1to8
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, FieldMultiplierSpecialBonusText
	call LoadTextHeader
.asm_1e465
	callba TransitionPinballUpgrade
	jr asm_1e475

Func_1e471: ; 0x1e471
	call Func_1e4b8
	ret z
asm_1e475: ; 0x1e475
	ld hl, wd5fb
	ld b, $3
.asm_1e47a
	ld a, [hld]
	push hl
	call Func_1e484
	pop hl
	dec b
	jr nz, .asm_1e47a
	ret

Func_1e484: ; 0x1e484
	and a
	jr z, .asm_1e496
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e491
	ld hl, Data_1e520
	jr .asm_1e4a3

.asm_1e491
	ld hl, Data_1e556
	jr .asm_1e4a3

.asm_1e496
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e4a0
	ld hl, Data_1e526
	jr .asm_1e4a3

.asm_1e4a0
	ld hl, Data_1e55c
.asm_1e4a3
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $7
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_1e4b8: ; 0x1e4b8
	ld a, [wd5fc]
	and a
	jr z, .asm_1e4e5
	ld a, [wd5fd]
	dec a
	ld [wd5fd], a
	jr nz, .asm_1e4ca
	ld [wd5fc], a
.asm_1e4ca
	and $7
	jr nz, .asm_1e4e3
	ld a, [wd5fd]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_1e4e3
	xor a
	ret

.asm_1e4e5
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .leftFlipperKeyIsPressed
	; left flipper key is pressed
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.leftFlipperKeyIsPressed
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	; right flipper key is pressed
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hl], a
	ret

BallTypeProgression2BlueField: ; 0x1e514
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

BallTypeDegradation2BlueField: ; 0x1e51a
; Determines the previous upgrade for the Ball.
	db POKE_BALL   ; POKE_BALL -> POKE_BALL
	db POKE_BALL   ; unused
	db POKE_BALL   ; GREAT_BALL -> POKE_BALL
	db GREAT_BALL  ; ULTRA_BALL -> GREAT_BALL
	db ULTRA_BALL  ; unused
	db ULTRA_BALL  ; MASTER_BALL -> GREAT_BALL

Data_1e520:
	dr $1e520, $1e526

Data_1e526:
	dr $1e526, $1e556

Data_1e556:
	dr $1e556, $1e55c

Data_1e55c:
	dr $1e55c, $1e58c

HandleBlueStageBallTypeUpgradeCounter: ; 0x1e58c
	ld a, [wCapturingMon]
	and a
	ret nz
	; check if counter is at 0
	ld hl, wBallTypeCounter
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	ret z
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	ret nz
	; counter is now 0! Degrade the ball upgrade.
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeDegradation2BlueField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	and a
	jr z, .pokeball
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
.pokeball
	callba TransitionPinballUpgrade
	ret

Func_1e5c5: ; 0x1e5c5
	ld a, [wWhichCAVELight]
	and a
	jr z, .asm_1e623
	xor a
	ld [wWhichCAVELight], a
	ld a, [wd513]
	and a
	jr nz, .asm_1e623
	ld a, [wWhichCAVELightId]
	sub $16
	ld c, a
	ld b, $0
	ld hl, wd50f
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd50f
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	inc hl
	and [hl]
	jr z, Func_1e627
	ld a, $1
	ld [wd513], a
	ld a, $80
	ld [wd514], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $09
	call PlaySoundEffect
	ld hl, wd62c
	call Func_e4a
	jr Func_1e627

.asm_1e623
	call Func_1e66a
	ret z
	; fall through

Func_1e627: ; 0x1e627
	ld hl, wd512
	ld b, $4
.asm_1e62c
	ld a, [hld]
	push hl
	call Func_1e636
	pop hl
	dec b
	jr nz, .asm_1e62c
	ret

Func_1e636: ; 0x1e636
	and a
	jr z, .asm_1e648
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e643
	ld hl, Data_1e6d7
	jr .asm_1e655

.asm_1e643
	ld hl, Data_1e717
	jr .asm_1e655

.asm_1e648
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_1e652
	ld hl, Data_1e6df
	jr .asm_1e655

.asm_1e652
	ld hl, Data_1e71f
.asm_1e655
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $7
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_1e66a: ; 0x1e66a
	ld a, [wd513]
	and a
	jr z, .asm_1e6a0
	ld a, [wd514]
	dec a
	ld [wd514], a
	jr nz, .asm_1e687
	ld [wd513], a
	ld a, $1
	ld [wd608], a
	ld a, $3
	ld [wd607], a
	xor a
.asm_1e687
	and $7
	ret nz
	ld a, [wd514]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_1e6a0
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_1e6bc
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.asm_1e6bc
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hl], a
	ret

Data_1e6d7:
	dr $1e6d7, $1e6df

Data_1e6df:
	dr $1e6df, $1e717

Data_1e717:
	dr $1e717, $1e71f

Data_1e71f:
	dr $1e71f, $1e757

Func_1e757: ; 0x1e757
	ld a, [wSlotCollision]
	and a
	jr z, .asm_1e78c
	xor a
	ld [wSlotCollision], a
	ld a, [wd604]
	and a
	ret z
	ld a, [wd603]
	and a
	jr nz, .asm_1e78c
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd549], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $16
	ld [wBallYPos + 1], a
	ld a, $13
	ld [wd603], a
.asm_1e78c
	ld a, [wd603]
	and a
	ret z
	dec a
	ld [wd603], a
	ld a, $18
	ld [wd606], a
	ld a, [wd603]
	cp $12
	jr nz, .asm_1e7b2
	lb de, $00, $21
	call PlaySoundEffect
	callba LoadMiniBallGfx
	ret

.asm_1e7b2
	cp $f
	jr nz, .asm_1e7c1
	callba Func_dd62
	ret

.asm_1e7c1
	cp $c
	jr nz, .asm_1e7d0
	xor a
	ld [wd548], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_1e7d0
	cp $9
	jr nz, .asm_1e7d8
	call Func_1e830
	ret

.asm_1e7d8
	cp $6
	jr nz, .asm_1e7f5
	xor a
	ld [wd604], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	callba LoadMiniBallGfx
	ret

.asm_1e7f5
	cp $3
	jr nz, .asm_1e80e
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	ret

.asm_1e80e
	and a
	ret nz
	call Func_1e8f6
	ld a, [wd622]
	cp $1
	ret nz
	call GenRandom
	and $8
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
	xor a
	ld [wd622], a
	ret

Func_1e830: ; 0x1e830
	xor a
	ld [wIndicatorStates + 4], a
	ld a, $d
	callba Func_10000
	jr nc, .asm_1e84b
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ret

.asm_1e84b
	ld a, [wd624]
	cp $3
	jr nz, .asm_1e891
	ld a, [wd607]
	and a
	jr nz, .asm_1e891
.asm_1e858
	ld a, [wd623]
	and a
	jr nz, .asm_1e867
	xor a
	ld [wd625], a
	ld a, $40
	ld [wd626], a
.asm_1e867
	xor a
	ld [wd623], a
	ld a, $1
	ld [wd495], a
	ld [wd4ae], a
	ld a, [wd498]
	ld c, a
	ld b, $0
	ld hl, Data_1e8f1
	add hl, bc
	ld a, [hl]
	ld [wd497], a
	call Func_1e8c3
	xor a
	ld [wd609], a
	ld [wd622], a
	ld a, $1e
	ld [wd607], a
	ret

.asm_1e891
	callba Func_ed8e
	xor a
	ld [wd608], a
	ld a, [wd61d]
	cp $d
	jr nc, .asm_1e858
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ld a, [wd622]
	cp $2
	ret nz
	callba Func_10ab3
	xor a
	ld [wd622], a
	ret

Func_1e8c3: ; 0x1e8c3
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld a, [wd497]
	ld de, GoToMeowthStageText
	cp $b
	jr z, .asm_1e8e0
	ld de, GoToSeelStageText
	cp $f
	jr z, .asm_1e8e0
	ld de, GoToMewtwoStageText
.asm_1e8e0
	call LoadTextHeader
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $3c, $23
	call PlaySoundEffect
	ret

Data_1e8f1:
	dr $1e8f1, $1e8f6

Func_1e8f6: ; 0x1e8f6
	ld a, [wCurrentStage]
	and $1
	sla a
	ld c, a
	ld a, [wd604]
	add c
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1e91e
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1e912
	ld hl, Data_1e970
.asm_1e912
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_1e91e)
	call Func_10aa
	ret

Data_1e91e:
	dr $1e91e, $1e970

Data_1e970:
	dr $1e970, $1e9c0

Func_1e9c0: ; 0x1e9c0
	ld a, [wd607]
	and a
	ret z
	dec a
	ld [wd607], a
	ret nz
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wd609]
	and a
	jr z, .asm_1e9dc
	ld a, [wd498]
	add $15
	jr .asm_1e9e3

.asm_1e9dc
	ld a, [wd608]
	and a
	ret z
	ld a, $1a
.asm_1e9e3
	ld hl, wCurrentStage
	bit 0, [hl]
	callba nz, Func_30256
	ld a, [wd604]
	and a
	ret nz
	ld a, $1
	ld [wd604], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	call nz, Func_1e8f6
	ret

Func_1ea0a: ; 0x1ea0a
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $fe
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jr asm_1ea6a

Func_1ea3b: ; 0x1ea3b
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $86
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	; fall through

asm_1ea6a: ; 0x1ea6a
	ld bc, Data_f0000
	add hl, bc
	ld de, wBallXVelocity
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1eaa9
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1eaa9
	pop hl
	bit 7, h
	jr z, .asm_1eab5
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1eab5
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	lb de, $00, $04
	call PlaySoundEffect
	ret

Func_1ead4: ; 0x1ead4
	ld a, [hNumFramesDropped]
	and $f
	ret nz
	ld bc, $0000
.asm_1eadc
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	cp $1
	jr z, .asm_1eaf8
	bit 7, [hl]
	jr z, .asm_1eaf8
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 4, [hl]
	jr z, .asm_1eaf5
	inc a
.asm_1eaf5
	call Func_1eb41
.asm_1eaf8
	pop bc
	inc c
	ld a, c
	cp $2
	jr nz, .asm_1eadc
	ld a, [hNumFramesDropped]
	and $f
	ret nz
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld bc, $0002
.asm_1eb0d
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	ld a, [hl]
	cp $1
	jr z, .asm_1eb29
	bit 7, [hl]
	jr z, .asm_1eb29
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 4, [hl]
	jr z, .asm_1eb2b
	inc a
	inc a
	jr .asm_1eb2b

.asm_1eb29
	ld a, $0
.asm_1eb2b
	push af
	ld hl, wd648
	add hl, bc
	dec hl
	dec hl
	ld a, [hl]
	ld d, a
	pop af
	add d
	call Func_1eb41
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_1eb0d
	ret

Func_1eb41: ; 0x1eb41
	push af
	sla c
	ld hl, Data_1eb61
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1eb4f
	ld hl, Data_1ed51
.asm_1eb4f
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_1eb61)
	call Func_10aa
	ret

Data_1eb61:
	dr $1eb61, $1ed51

Data_1ed51:
	dr $1ed51, $1ef09

ResolveBlueStageForceFieldCollision: ; 0x1ef09
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jp z, Func_1ef20
	cp $1  ; right direction
	jp z, Func_1ef4d
	cp $2  ; down direction
	jp z, Func_1ef7e
	cp $3  ; left direction
	jp z, Func_1efae
	; fall through
	; default to upward forcefield

Func_1ef20: ; 0x1ef20
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jp Func_1efdc

Func_1ef4d: ; 0x1ef4d
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld a, $30
	sub c
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jp Func_1efdc

Func_1ef7e: ; 0x1ef7e
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, a
	ld a, $30
	sub c
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jr Func_1efdc

Func_1efae: ; 0x1efae
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallYPos + 1]
	sub $60
	cp $30
	ret nc
	ld c, a
	ld a, $30
	sub c
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	; fall through
Func_1efdc: ; 0x1efdc
	ld a, [wBlueStageForceFieldDirection]
	cp $0  ; up direction
	jp z, Func_1eff3
	cp $1  ; right direction
	jp z, Func_1f0be
	cp $2  ; down direction
	jp z, Func_1f057
	cp $3  ; left direction
	jp z, Func_1f124
	; fall through
	; default to upward forcefield

Func_1eff3:  ; 0x1eff3
	ld bc, Data_ec000
	add hl, bc
	ld de, wBallXVelocity
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f032
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f032
	pop hl
	bit 7, h
	jr z, .asm_1f03e
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f03e
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f057: ; 0x1f057
	ld bc, Data_ec000
	add hl, bc
	ld de, wBallXVelocity
	bit 2, l
	ret nz
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	sub c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	sbc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f099
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f099
	pop hl
	bit 7, h
	jr z, .asm_1f0a5
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f0a5
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f0be: ; 0x1f0be
	ld bc, Data_ec000
	add hl, bc
	ld de, wBallYVelocity
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc hl
	push bc
	dec de
	dec de
	dec de
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	sub c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	sbc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f0ff
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f0ff
	pop hl
	bit 7, h
	jr z, .asm_1f10b
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f10b
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f124: ; 0x1f124
	ld bc, Data_ec000
	add hl, bc
	ld de, wBallYVelocity
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	sub c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	sbc b
	ld [de], a
	inc hl
	push bc
	dec de
	dec de
	dec de
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(Data_ec000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1f165
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1f165
	pop hl
	bit 7, h
	jr z, .asm_1f171
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1f171
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

Func_1f18a: ; 0x1f18a
	ld a, [wd640]
	cp $0
	jr z, .asm_1f1b4
	ld a, [wBlueStageForceFieldDirection]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1f1b5
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1f1a4
	ld hl, Data_1f201
.asm_1f1a4
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(Data_1f1b5)
	call Func_10aa
	ld a, $0
	ld [wd640], a
.asm_1f1b4
	ret

Data_1f1b5:
	dr $1f1b5, $1f201

Data_1f201:
	dr $1f201, $1f261

Func_1f261: ; 0x1f261
	call Func_1f27b
	ret nc
	; fall through

Func_1f265: ; 0x1f265
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_1f2b9
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $7
	ld de, LoadTileLists
	call Func_10c5
	ret

Func_1f27b: ; 0x1f27b
	ld a, [wd624]
	ld hl, wd625
	cp [hl]
	ret z
	ld a, [wd626]
	dec a
	ld [wd626], a
	jr nz, .asm_1f2a5
	ld a, [wd625]
	ld [wd624], a
	cp $3
	jr c, .asm_1f2a0
	ld a, $1
	ld [wd609], a
	ld a, $3
	ld [wd607], a
.asm_1f2a0
	ld a, [wd624]
	scf
	ret

.asm_1f2a5
	and $7
	ret nz
	ld a, [wd626]
	bit 3, a
	jr nz, .asm_1f2b4
	ld a, [wd624]
	scf
	ret

.asm_1f2b4
	ld a, [wd625]
	scf
	ret

Data_1f2b9:
	dr $1f2b9, $1f2ed

Func_1f2ed: ; 0x1f2ed
	xor a
	ld [wd604], a
	ld [wIndicatorStates + 4], a
	ld [hFarCallTempA], a
	ld a, Bank(Func_1e8f6)  ; this is in the same bank...
	ld hl, Func_1e8f6
	call BankSwitch
	ret

Func_1f2ff: ; 0x1f2ff
	ld a, [wLeftAlleyCount]
	cp $3
	jr c, .asm_1f30b
	ld a, $80
	ld [wIndicatorStates + 2], a
.asm_1f30b
	ld a, [wLeftAlleyCount]
	cp $3
	jr z, .asm_1f314
	set 7, a
.asm_1f314
	ld [wIndicatorStates], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .asm_1f323
	ld a, $80
	ld [wIndicatorStates + 3], a
.asm_1f323
	ld a, [wRightAlleyCount]
	cp $3
	jr z, .asm_1f32c
	set 7, a
.asm_1f32c
	ld [wIndicatorStates + 1], a
	ret

Func_1f330: ; 0x1f330
	ld bc, $7f00
	callba DrawTimer
	call Func_1f395
	call Func_1f3e1
	call Func_1f408
	call Func_1f428
	callba DrawPinball
	call Func_1f48f
	call Func_1f4f8
	ret

Func_1f35a: ; 0x1f35a
	ld bc, $7f00
	callba DrawTimer
	callba DrawMonCaptureAnimation
	call DrawAnimatedMon_BlueStage
	call DrawPikachuSavers_BlueStage
	callba DrawFlippers
	callba DrawPinball
	call Func_1f4a3
	call Func_1f509
	call Func_1f55e
	ret

Func_1f395: ; 0x1f395
	ld de, wd4cd
	ld hl, Data_1f3cf
	call Func_1f3ad
	ld de, wd4d0
	ld hl, Data_1f3d5
	call Func_1f3ad
	ld de, wd4d3
	ld hl, Data_1f3db
	; fall through

Func_1f3ad: ; 0x1f3ad
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [wd4d7]
	sub [hl]
	inc hl
	jr z, .asm_1f3c4
	ld a, $0
	jr .asm_1f3c6

.asm_1f3c4
	ld a, $1
.asm_1f3c6
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_1f3cf:
	dr $1f3cf, $1f3d5

Data_1f3d5:
	dr $1f3d5, $1f3db

Data_1f3db:
	dr $1f3db, $1f3e1

Func_1f3e1: ; 0x1f3e1
	ld a, $8a
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $53
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd50a]
	srl a
	srl a
	ld e, a
	ld d, $0
	ld hl, Data_1f402
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_1f402:
	dr $1f402, $1f408

Func_1f408: ; 0x1f408
	ld a, $18
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $5f
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd633]
	ld e, a
	ld d, $0
	ld hl, Data_1f425
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_1f425:
	dr $1f425, $1f428

Func_1f428: ; 0x1f428
	ld a, $70
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $59
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd638]
	ld e, a
	ld d, $0
	ld hl, Data_1f445
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_1f445:
	dr $1f445, $1f448

DrawPikachuSavers_BlueStage: ; 0x1f448
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [wd51d]
	and a
	ld a, [wd518]
	jr z, .asm_1f473
	ld a, [wd51c]
	and a
	jr nz, .asm_1f469
	ld a, [hNumFramesDropped]
	srl a
	srl a
	srl a
	and $1
	jr .asm_1f473

.asm_1f469
	ld a, [wd4b4]
	cp $50
	ld a, $1
	jr nc, .asm_1f473
	xor a
.asm_1f473
	sla a
	ld c, a
	ld b, $0
	ld hl, PikachuSaverOAMOffsets_BlueStage
	add hl, bc
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	ld a, [wPikachuSaverAnimationFrame]
	add $e
	call LoadOAMData
	ret

PikachuSaverOAMOffsets_BlueStage:
	dw $7E0F
	dw $7E92

Func_1f48f: ; 0x1f48f
	ld a, [wd551]
	and a
	ret nz
	ld a, [hNumFramesDropped]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 5
	ld hl, Data_1f4ce
	ld b, $6
	jr asm_1f4b5

Func_1f4a3: ; 0x1f4a3
	ld a, [wd551]
	and a
	ret nz
	ld a, [hNumFramesDropped]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 11
	ld hl, Data_1f4e0
	ld b, $8
asm_1f4b5:
	push bc
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [de]
	and a
	ld a, [hli]
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, asm_1f4b5
	ret

Data_1f4ce:
	dr $1f4ce, $1f4e0

Data_1f4e0:
	dr $1f4e0, $1f4f8

Func_1f4f8: ; 0x1f4f8
	ld a, [wd551]
	and a
	ret z
	ld de, wd566
	ld hl, Data_1f53a
	ld b, $c
	ld c, $47
	jr asm_1f518

Func_1f509: ; 0x1f509
	ld a, [wd551]
	and a
	ret z
	ld de, wd572
	ld hl, Data_1f552
	ld b, $6
	ld c, $40
asm_1f518: ; 0x1f518
	push bc
	ld a, [de]
	add c
	cp c
	push af
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hNumFramesDropped]
	and $e
	jr nz, .asm_1f530
	dec c
.asm_1f530
	pop af
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, asm_1f518
	ret

Data_1f53a:
	dr $1f53a, $1f552

Data_1f552:
	dr $1f552, $1f55e

Func_1f55e: ; 0x1f55e
	ld a, [wd604]
	and a
	ret z
	ld a, [wd606]
	inc a
	ld [wd606], a
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $1
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd606]
	srl a
	srl a
	srl a
	and $3
	add $4f
	cp $52
	call nz, LoadOAMData
	ret

DrawAnimatedMon_BlueStage: ; 0x1f58b
	ld a, [wWildMonIsHittable]
	and a
	ret z
	ld a, $50
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $3e
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd5bd]
	ld e, a
	ld d, $0
	ld hl, AnimatedMonOAMIds_BlueStage
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

AnimatedMonOAMIds_BlueStage:
	db $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31

SECTION "bank8", ROMX, BANK[$8]

Func_20000: ; 0x20000
	ld a, [wd54c]
	cp $4
	jp z, Func_20230
	cp $c
	jp z, Func_202a8
	cp $5
	jp z, Func_202b2
	cp $0
	jr z, .asm_20018
	scf
	ret

.asm_20018
	call Func_201f2
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_20021: ; 0x20021
	padded_dab Func_20041
	padded_dab Func_2005f
	padded_dab Func_2006b
	padded_dab Func_200a3
	padded_dab Func_200d3
	padded_dab Func_20193
	padded_dab CapturePokemonRedStage
	padded_dab Func_201ce

Func_20041: ; 0x20041
	ld a, [wd5b6]
	cp $18
	jr nz, .asm_2005d
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_2005d
	ld hl, wd54d
	inc [hl]
	ld a, $14
	ld [wd54e], a
	ld a, $5
	ld [wd54f], a
.asm_2005d
	scf
	ret

Func_2005f: ; 0x2005f
	callba Func_10648
	scf
	ret

Func_2006b: ; 0x2006b
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20098
	call Func_1130
	jr nz, .asm_200a1
	callba Func_10414
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_10301
.asm_20098
	ld a, $1
	ld [wd5c6], a
	ld hl, wd54d
	inc [hl]
.asm_200a1
	scf
	ret

Func_200a3: ; 0x200a3
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_200af
	call Func_1130
	jr nz, .asm_200d1
.asm_200af
	callba ShowAnimatedWildMon
	callba Func_10732
	callba Func_10464
	ld hl, wd54d
	inc [hl]
.asm_200d1
	scf
	ret

Func_200d3: ; 0x200d3
	ld a, [wd5be]
	dec a
	ld [wd5be], a
	jr z, .asm_200e6
	ld a, [wd5c4]
	inc a
	ld [wd5c4], a
	and $3
	ret nz
.asm_200e6
	ld a, [wBallHitWildMon]
	and a
	jp z, .asm_20167
	xor a
	ld [wBallHitWildMon], a
	ld a, [wd5c3]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .notMew
	ld a, [wNumMewHitsLow]
	inc a
	ld [wNumMewHitsLow], a
	jr nz, .asm_20116
.notMew
	ld a, [wNumMonHits]
	cp $3
	jr z, .hitMonThreeTimes
	inc a
	ld [wNumMonHits], a
.asm_20116
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld bc, $0030
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5e9
	ld de, Data_2a2a
	call Func_3372
	pop de
	pop bc
	ld hl, wd5e4
	ld de, HitText
	call Func_3357
	ld a, [wNumMonHits]
	callba Func_10611
	ld c, $2
	jr .asm_2018a

.hitMonThreeTimes
	xor a
	ld [wd57e], a
	ld a, $1
	ld [wd57f], a
	ld hl, wd54d
	inc [hl]
	ld c, $2
	jr .asm_2018a

.asm_20167
	ld a, [wd5be]
	and a
	ret nz
	ld a, [wd5bc]
	ld c, a
	ld a, [wd5bd]
	sub c
	cp $1
	ld c, $0
	jr nc, .asm_2017c
	ld c, $1
.asm_2017c
	ld b, $0
	ld hl, wd5c1
	add hl, bc
	ld a, [hl]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
.asm_2018a
	ld a, [wd5bc]
	add c
	ld [wd5bd], a
	scf
	ret

Func_20193: ; 0x20193
	ld a, [wd580]
	and a
	jr z, .asm_2019e
	xor a
	ld [wd580], a
	ret

.asm_2019e
	callba BallCaptureInit
	ld hl, wd54d
	inc [hl]
	callba Func_106b6
	callba AddCaughtPokemonToParty
	scf
	ret

CapturePokemonRedStage: ; 0x201c2
	callba CapturePokemon
	scf
	ret

Func_201ce: ; 0x201ce
	ld a, [wd5ca]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba Func_10157
	ld de, $0001
	call PlaySong
	scf
	ret

Func_201f2: ; 0x201f2
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $7
	ld [wd54d], a
	; Automatically set Mew as caught, since you can't possibly catch it
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .asm_2021b
	callba SetPokemonOwnedFlag
.asm_2021b
	callba Func_86d2
	callba Func_106a6
	ret

Func_20230: ; 0x20230
	ld a, [wd5b6]
	cp $18
	jr z, .asm_2029d
	sla a
	ld c, a
	ld b, $0
	ld hl, wd586
	add hl, bc
	ld d, $4
.asm_20242
	ld a, $1
	ld [hli], a
	inc hl
	ld a, l
	cp wd5b6 % $100
	jr z, .asm_2024e
	dec d
	jr nz, .asm_20242
.asm_2024e
	ld a, [wd5b6]
	add $4
	cp $18
	jr c, .master_loop9
	ld a, $18
.master_loop9
	ld [wd5b6], a
	cp $18
	jr nz, .asm_20264
	xor a
	ld [wIndicatorStates + 9], a
.asm_20264
	callba Func_10184
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld bc, $0010
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5e9
	ld de, Data_2a3d
	call Func_3372
	pop de
	pop bc
	ld hl, wd5e4
	ld de, FlippedText
	call Func_3357
.asm_2029d
	ld bc, $0001
	ld de, $0000
	call Func_3538
	scf
	ret

Func_202a8: ; 0x202a8
	ld bc, $0000
	ld de, $1000
	call Func_3538
	ret

Func_202b2: ; 0x202b2
	ld bc, $0005
	ld de, $0000
	call Func_3538
	ret

Func_202bc: ; 0x202bc
	ld a, [wd54c]
	cp $4
	jp z, Func_204f1
	cp $c
	jp z, Func_20569
	cp $f
	jp z, Func_20573
	cp $e
	jp z, Func_2057a
	cp $0
	jr z, .asm_202d9
	scf
	ret

.asm_202d9
	call Func_204b3
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_202e2: ; 0x202e2
	padded_dab Func_20302
	padded_dab Func_20320
	padded_dab Func_2032c
	padded_dab Func_20364
	padded_dab Func_20394
	padded_dab Func_20454
	padded_dab CapturePokemonBlueStage
	padded_dab Func_2048f

Func_20302: ; 0x20302
	ld a, [wd5b6]
	cp $18
	jr nz, .asm_2031e
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_2031e
	ld hl, wd54d
	inc [hl]
	ld a, $14
	ld [wd54e], a
	ld a, $5
	ld [wd54f], a
.asm_2031e
	scf
	ret

Func_20320: ; 0x20320
	callba Func_10648
	scf
	ret

Func_2032c: ; 0x2032c
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20333
	call Func_1130
	jr nz, .asm_20362
	callba Func_10414
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, Func_10301
.asm_20333
	ld a, $1
	ld [wd5c6], a
	ld hl, wd54d
	inc [hl]
.asm_20362
	scf
	ret

Func_20364: ; 0x20364
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20370
	call Func_1130
	jr nz, .asm_20392
.asm_20370
	callba ShowAnimatedWildMon
	callba Func_10732
	callba Func_10464
	ld hl, wd54d
	inc [hl]
.asm_20392
	scf
	ret

Func_20394: ; 0x20394
	ld a, [wd5be]
	dec a
	ld [wd5be], a
	jr z, .asm_203a7
	ld a, [wd5c4]
	inc a
	ld [wd5c4], a
	and $3
	ret nz
.asm_203a7
	ld a, [wBallHitWildMon]
	and a
	jp z, .asm_20428
	xor a
	ld [wBallHitWildMon], a
	ld a, [wd5c3]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .notMew
	ld a, [wNumMewHitsLow]
	inc a
	ld [wNumMewHitsLow], a
	jr nz, .asm_203d7
.notMew
	ld a, [wNumMonHits]
	cp $3
	jr z, .asm_20417
	inc a
	ld [wNumMonHits], a
.asm_203d7
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld bc, $0030
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5e9
	ld de, Data_2a2a
	call Func_3372
	pop de
	pop bc
	ld hl, wd5e4
	ld de, HitText
	call Func_3357
	ld a, [wNumMonHits]
	callba Func_10611
	ld c, $2
	jr .asm_2044b

.asm_20417
	xor a
	ld [wd57e], a
	ld a, $1
	ld [wd57f], a
	ld hl, wd54d
	inc [hl]
	ld c, $2
	jr .asm_2044b

.asm_20428
	ld a, [wd5be]
	and a
	ret nz
	ld a, [wd5bc]
	ld c, a
	ld a, [wd5bd]
	sub c
	cp $1
	ld c, $0
	jr nc, .asm_2043d
	ld c, $1
.asm_2043d
	ld b, $0
	ld hl, wd5c1
	add hl, bc
	ld a, [hl]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
.asm_2044b
	ld a, [wd5bc]
	add c
	ld [wd5bd], a
	scf
	ret

Func_20454: ; 0x20454
	ld a, [wd580]
	and a
	jr z, .asm_2045f
	xor a
	ld [wd580], a
	ret

.asm_2045f
	callba BallCaptureInit
	ld hl, wd54d
	inc [hl]
	callba Func_106b6
	callba AddCaughtPokemonToParty
	scf
	ret

CapturePokemonBlueStage: ; 0x20483
	callba CapturePokemon
	scf
	ret

Func_2048f: ; 0x2048f
	ld a, [wd5ca]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba Func_10157
	ld de, $0001
	call PlaySong
	scf
	ret

Func_204b3: ; 0x204b3
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $7
	ld [wd54d], a
	; Automatically set Mew as caught, since you can't possibly catch it
	ld a, [wCurrentCatchEmMon]
	cp MEW - 1
	jr nz, .notMew
	callba SetPokemonOwnedFlag
.notMew
	callba Func_86d2
	callba Func_106a6
	ret

Func_204f1: ; 0x204f1
	ld a, [wd5b6]
	cp $18
	jr z, .asm_2055e
	sla a
	ld c, a
	ld b, $0
	ld hl, wd586
	add hl, bc
	ld d, $4
.asm_20503
	ld a, $1
	ld [hli], a
	inc hl
	ld a, l
	cp wd5b6 % $100
	jr z, .asm_2050f
	dec d
	jr nz, .asm_20503
.asm_2050f
	ld a, [wd5b6]
	add $4
	cp $18
	jr c, .asm_2051a
	ld a, $18
.asm_2051a
	ld [wd5b6], a
	cp $18
	jr nz, .asm_20525
	xor a
	ld [wIndicatorStates + 9], a
.asm_20525
	callba Func_10184
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	ld bc, $0010
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5e9
	ld de, Data_2a3d
	call Func_3372
	pop de
	pop bc
	ld hl, wd5e4
	ld de, FlippedText
	call Func_3357
.asm_2055e
	ld bc, $0001
	ld de, $0000
	call Func_3538
	scf
	ret

Func_20569: ; 0x20569
	ld bc, $0000
	ld de, $1000
	call Func_3538
	ret

Func_20573: ; 0x20573
	ld bc, $0005
	ld de, $0000
	ret

Func_2057a: ; 0x2057a
	ld bc, $0005
	ld de, $0000
	ret

Func_20581: ; 0x20581
	ld a, [wd54c]
	cp $4
	jp z, Func_2080f
	cp $3
	jp z, Func_20839
	cp $5
	jp z, Func_2085a
	cp $6
	jp z, Func_20887
	cp $7
	jp z, Func_208a8
	cp $8
	jp z, Func_208c9
	cp $9
	jp z, Func_208ea
	cp $a
	jp z, Func_2090b
	cp $b
	jp z, Func_2092c
	cp $c
	jp z, Func_2094d
	cp $d
	jp z, Func_20b02
	cp $2
	jp z, Func_20a65
	cp $1
	jp z, Func_20a82
	cp $0
	jr z, .asm_205cb
	scf
	ret

.asm_205cb
	call Func_2077b
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_205d4: ; 0x205d4
	padded_dab Func_205e0
	padded_dab Func_2070b
	padded_dab Func_20757

Func_205e0: ; 0x205e0
	ld a, [wCurrentStage]
	ld b, a
	ld a, [wd578]
	and a
	ret z
	dec a
	bit 0, b
	jr z, .asm_205f0
	add $c
.asm_205f0
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ld a, [hl]
	and a
	ret z
	xor a
	ld [hl], a
	ld [wd551], a
	call Func_20651
	ld a, [wd558]
	ld [wIndicatorStates + 2], a
	ld a, [wd559]
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_14135
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld de, YeahYouGotItText
	ld hl, wd5cc
	call LoadTextHeader
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_2064f
	ld a, BANK(StageRedFieldBottomOBJPalette6)
	ld hl, StageRedFieldBottomOBJPalette6
	ld de, $0070
	ld bc, $0008
	call Func_7dc
.asm_2064f
	scf
	ret

Func_20651: ; 0x20651
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20681
	ld a, [wCurrentEvolutionType]
	dec a
	ld c, a
	ld b, $0
	swap c
	sla c
	ld hl, Data_d8e80
	add hl, bc
	ld a, [wd554]
	ld c, a
	ld b, $0
	swap c
	sla c
	push hl
	ld hl, vTilesSH tile $2e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, $0020
	ld a, BANK(Data_d8e80)
	call LoadVRAMData
.asm_20681
	ld a, [wd554]
	inc a
	ld [wd554], a
	cp $1
	jr nz, .asm_20693
	lb de, $07, $28
	call PlaySoundEffect
	ret

.asm_20693
	cp $2
	jr nz, .asm_2069e
	lb de, $07, $44
	call PlaySoundEffect
	ret

.asm_2069e
	cp $3
	ret nz
	lb de, $07, $45
	call PlaySoundEffect
	ld a, $1
	ld [wd604], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	xor a
	ld [wIndicatorStates + 9], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 13], a
	ld [wIndicatorStates + 14], a
	ld [wIndicatorStates + 11], a
	ld [wIndicatorStates + 12], a
	ld [wIndicatorStates + 6], a
	ld [wIndicatorStates + 7], a
	ld [wd558], a
	ld [wd559], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, BANK(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20700
	ld a, BANK(StageRedFieldBottomOBJPalette7)
	ld hl, StageRedFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_20700
	callba Func_16425
	ret

Func_2070b: ; 0x2070b
	callba RestoreBallSaverAfterCatchEmMode
	callba Func_10ca5
	callba Func_10ac8
	ld de, $0001
	call PlaySong
	ld hl, wd629
	call Func_e4a
	callba SetPokemonOwnedFlag
	ld a, [wd624]
	cp $3
	ret z
	add $2
	cp $3
	jr c, .asm_2074d
	ld a, $3
.asm_2074d
	ld [wd625], a
	ld a, $80
	ld [wd626], a
	scf
	ret

Func_20757: ; 0x20757
	ld a, [wd5ca]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba Func_10ac8
	ld de, $0001
	call PlaySong
	scf
	ret

Func_2077b: ; 0x2077b
	ld hl, wd556
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	jr z, .asm_2078e
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	jr nz, .asm_2078e
	call Func_20a55
.asm_2078e
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $2
	ld [wd54d], a
	xor a
	ld [wd604], a
	ld hl, wIndicatorStates
	ld [wIndicatorStates + 4], a
	ld [wIndicatorStates + 9], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 13], a
	ld [wIndicatorStates + 14], a
	ld [wIndicatorStates + 11], a
	ld [wIndicatorStates + 12], a
	ld [wIndicatorStates + 6], a
	ld [wIndicatorStates + 7], a
	ld [wd558], a
	ld [wd559], a
	ld [wd551], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_207f5
	callba Func_14135
	callba Func_16425
.asm_207f5
	callba Func_86d2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, EvolutionFailedText
	call LoadTextHeader
	ret

Func_2080f: ; 0x2080f
	ld bc, $0001
	ld de, $5000
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20837
	ld a, [wIndicatorStates + 9]
	and a
	jr z, .asm_20837
	xor a
	ld [wIndicatorStates + 9], a
	ld a, [wd55c]
	and a
	ld a, $0
	ld [wd55c], a
	jp nz, Func_20977
	jp Func_209eb

.asm_20837
	scf
	ret

Func_20839: ; 0x20839
	ld a, [wd551]
	and a
	jr nz, .asm_20858
	ld a, [wIndicatorStates + 2]
	and a
	jr z, .asm_20858
	xor a
	ld [wIndicatorStates + 2], a
	ld a, [wd563]
	and a
	ld a, $0
	ld [wd563], a
	jp nz, Func_20977
	jp Func_209eb

.asm_20858
	scf
	ret

Func_2085a: ; 0x2085a
	ld bc, $0007
	ld de, $5000
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20885
	ld a, [wIndicatorStates + 3]
	and a
	jr z, .asm_20885
	xor a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wd562]
	and a
	ld a, $0
	ld [wd562], a
	jp nz, Func_20977
	jp Func_209eb

.asm_20885
	scf
	ret

Func_20887: ; 0x20887
	ld a, [wd551]
	and a
	jr nz, .asm_208a6
	ld a, [wIndicatorStates + 8]
	and a
	jr z, .asm_208a6
	xor a
	ld [wIndicatorStates + 8], a
	ld a, [wd561]
	and a
	ld a, $0
	ld [wd561], a
	jp nz, Func_20977
	jp Func_209eb

.asm_208a6
	scf
	ret

Func_208a8: ; 0x208a8
	ld a, [wd551]
	and a
	jr nz, .asm_208c7
	ld a, [wIndicatorStates + 13]
	and a
	jr z, .asm_208c7
	xor a
	ld [wIndicatorStates + 13], a
	ld a, [wd55d]
	and a
	ld a, $0
	ld [wd55d], a
	jp nz, Func_20977
	jp Func_209eb

.asm_208c7
	scf
	ret

Func_208c9: ; 0x208c9
	ld a, [wd551]
	and a
	jr nz, .asm_208e8
	ld a, [wIndicatorStates + 14]
	and a
	jr z, .asm_208e8
	xor a
	ld [wIndicatorStates + 14], a
	ld a, [wd55e]
	and a
	ld a, $0
	ld [wd55e], a
	jp nz, Func_20977
	jp Func_209eb

.asm_208e8
	scf
	ret

Func_208ea: ; 0x208ea
	ld a, [wd551]
	and a
	jr nz, .asm_20909
	ld a, [wIndicatorStates + 11]
	and a
	jr z, .asm_20909
	xor a
	ld [wIndicatorStates + 11], a
	ld a, [wd55f]
	and a
	ld a, $0
	ld [wd55f], a
	jp nz, Func_20977
	jp Func_209eb

.asm_20909
	scf
	ret

Func_2090b: ; 0x2090b
	ld a, [wd551]
	and a
	jr nz, .asm_2092a
	ld a, [wIndicatorStates + 12]
	and a
	jr z, .asm_2092a
	xor a
	ld [wIndicatorStates + 12], a
	ld a, [wd560]
	and a
	ld a, $0
	ld [wd560], a
	jp nz, Func_20977
	jp Func_209eb

.asm_2092a
	scf
	ret

Func_2092c: ; 0x2092c
	ld a, [wd551]
	and a
	jr nz, .asm_2094b
	ld a, [wIndicatorStates + 6]
	and a
	jr z, .asm_2094b
	xor a
	ld [wIndicatorStates + 6], a
	ld a, [wd565]
	and a
	ld a, $0
	ld [wd565], a
	jp nz, Func_20977
	jp Func_209eb

.asm_2094b
	scf
	ret

Func_2094d: ; 0x2094d
	ld bc, $0000
	ld de, $1500
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20975
	ld a, [wIndicatorStates + 7]
	and a
	jr z, .asm_20975
	xor a
	ld [wIndicatorStates + 7], a
	ld a, [wd564]
	and a
	ld a, $0
	ld [wd564], a
	jp nz, Func_20977
	jp Func_209eb

.asm_20975
	scf
	ret

Func_20977: ; 0x20977
	lb de, $07, $46
	call PlaySoundEffect
	call Func_20af5
	ld a, [wCurrentEvolutionType]
	ld [hl], a
	ld [wd551], a
	ld a, [wIndicatorStates + 2]
	ld [wd558], a
	ld a, [wIndicatorStates + 3]
	ld [wd559], a
	xor a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_14135
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_209bf
	ld a, BANK(Data_dd188)
	ld hl, Data_dd188
	ld de, $0070
	ld bc, $0010
	call Func_7dc
.asm_209bf
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentEvolutionType]
	dec a
	ld c, a
	ld b, $0
	sla c
	ld hl, EvolutionTypeGetTextPointers
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, wd5cc
	call LoadTextHeader
	scf
	ret

Func_209eb: ; 0x209eb
	lb de, $07, $47
	call PlaySoundEffect
	ld a, $1
	ld [wd551], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld a, [wIndicatorStates + 2]
	ld [wd558], a
	ld a, [wIndicatorStates + 3]
	ld [wd559], a
	xor a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_14135
	ld a, $58
	ld [wd556], a
	ld a, $2
	ld [wd557], a
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, PokemonIsTiredText
	jr z, .asm_20a50
	ld de, ItemNotFoundText
.asm_20a50
	call LoadTextHeader
	scf
	ret

Func_20a55: ; 0x20a55
	ld a, [wd551]
	and a
	jr z, .asm_20a63
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_20a63
	jr asm_20a9f

.asm_20a63
	scf
	ret

Func_20a65: ; 0x20a65
	ld a, [wd551]
	and a
	jr z, .asm_20a80
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_20a80
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr asm_20a9f

.asm_20a80
	scf
	ret

Func_20a82: ; 0x20a82
	ld a, [wd551]
	and a
	jr z, .asm_20a9d
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_20a9d
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr asm_20a9f

.asm_20a9d
	scf
	ret

asm_20a9f:
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld [wd551], a
	ld a, [wd558]
	ld [wIndicatorStates + 2], a
	ld a, [wd559]
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_14135
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20ada
	ld a, BANK(StageRedFieldBottomOBJPalette6)
	ld hl, StageRedFieldBottomOBJPalette6
	ld de, $0070
	ld bc, $0008
	call Func_7dc
.asm_20ada
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, PokemonRecoveredText
	jr z, .asm_20aed
	ld de, TryNextPlaceText
.asm_20aed
	ld hl, wd5cc
	call LoadTextHeader
	scf
	ret

Func_20af5: ; 0x20af5
	ld a, $11
	call Func_a21
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ret

Func_20b02: ; 0x20b02
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jr nz, .asm_20b0c
	ld a, [wCurrentCatchEmMon]
.asm_20b0c
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_20b18
	inc b
.asm_20b18
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
	ld de, vTilesSH tile $10
	ld bc, $0180
	call LoadOrCopyVRAMData
	pop bc
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20b80
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
	hlCoord 7, 4, vBGMap
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
.asm_20b80
	callba Func_10e0a
	call Func_3475
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $2d, $26
	call PlaySoundEffect
	callba Func_10825
	call Func_3475
	ld a, $1
	ld [wd54d], a
	scf
	ret

Func_20bae: ; 0x20bae
	ld a, [wd54c]
	cp $4
	jp z, Func_20e34
	cp $1
	jp z, Func_21089
	cp $e
	jp z, Func_20e5e
	cp $f
	jp z, Func_20e82
	cp $7
	jp z, Func_20ea6
	cp $8
	jp z, Func_20ec7
	cp $9
	jp z, Func_20ee8
	cp $a
	jp z, Func_20f09
	cp $b
	jp z, Func_20f2a
	cp $c
	jp z, Func_20f4b
	cp $d
	jp z, Func_2112a
	cp $2
	jp z, Func_2105c
	cp $0
	jr z, .asm_20bf3
	scf
	ret

.asm_20bf3
	call Func_20da0
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_20bfc: ; 0x20bfc
	padded_dab Func_20c08
	padded_dab Func_20d30
	padded_dab Func_20d7c

Func_20c08: ; 0x20c08
	ld a, [wCurrentStage]
	ld b, a
	ld a, [wd578]
	and a
	ret z
	dec a
	bit 0, b
	jr z, .asm_20c18
	add $c
.asm_20c18
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ld a, [hl]
	and a
	ret z
	xor a
	ld [hl], a
	ld [wd551], a
	call Func_20c76
	ld a, [wd558]
	ld [wIndicatorStates], a
	ld a, [wd559]
	ld [wIndicatorStates + 3], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld de, YeahYouGotItText
	ld hl, wd5cc
	call LoadTextHeader
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20c74
	ld a, BANK(StageBlueFieldBottomOBJPalette6)
	ld hl, StageBlueFieldBottomOBJPalette6
	ld de, $0070
	ld bc, $0008
	call Func_7dc
.asm_20c74
	scf
	ret

Func_20c76: ; 0x20c76
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20ca6
	ld a, [wCurrentEvolutionType]
	dec a
	ld c, a
	ld b, $0
	swap c
	sla c
	ld hl, Data_d8e80
	add hl, bc
	ld a, [wd554]
	ld c, a
	ld b, $0
	swap c
	sla c
	push hl
	ld hl, vTilesSH tile $2e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, $0020
	ld a, BANK(Data_d8e80)
	call LoadVRAMData
.asm_20ca6
	ld a, [wd554]
	inc a
	ld [wd554], a
	cp $1
	jr nz, .asm_20cb8
	lb de, $07, $28
	call PlaySoundEffect
	ret

.asm_20cb8
	cp $2
	jr nz, .asm_20cc3
	lb de, $07, $44
	call PlaySoundEffect
	ret

.asm_20cc3
	cp $3
	ret nz
	lb de, $07, $45
	call PlaySoundEffect
	ld a, $1
	ld [wd604], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	xor a
	ld [wIndicatorStates + 9], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 13], a
	ld [wIndicatorStates + 14], a
	ld [wIndicatorStates + 11], a
	ld [wIndicatorStates + 12], a
	ld [wIndicatorStates + 10], a
	ld [wIndicatorStates + 6], a
	ld [wIndicatorStates + 7], a
	ld [wd558], a
	ld [wd559], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	ld a, BANK(StageSharedBonusSlotGlowGfx)
	ld hl, StageSharedBonusSlotGlowGfx + $60
	ld de, vTilesOB tile $20
	ld bc, $00e0
	call LoadVRAMData
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20d25
	ld a, BANK(StageBlueFieldBottomOBJPalette7)
	ld hl, StageBlueFieldBottomOBJPalette7
	ld de, $0078
	ld bc, $0008
	call Func_7dc
.asm_20d25
	callba Func_1e8f6
	ret

Func_20d30: ; 0x20d30
	callba RestoreBallSaverAfterCatchEmMode
	callba Func_10ca5
	callba Func_10ac8
	ld de, $0001
	call PlaySong
	ld hl, wd629
	call Func_e4a
	callba SetPokemonOwnedFlag
	ld a, [wd624]
	cp $3
	ret z
	add $2
	cp $3
	jr c, .asm_20d72
	ld a, $3
.asm_20d72
	ld [wd625], a
	ld a, $80
	ld [wd626], a
	scf
	ret

Func_20d7c: ; 0x20d7c
	ld a, [wd5ca]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba RestoreBallSaverAfterCatchEmMode
	callba Func_10ac8
	ld de, $0001
	call PlaySong
	scf
	ret

Func_20da0: ; 0x20da0
	ld hl, wd556
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	jr z, .asm_20db3
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	jr nz, .asm_20db3
	call Func_21079
.asm_20db3
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $2
	ld [wd54d], a
	xor a
	ld [wd604], a
	ld hl, wIndicatorStates
	ld [wIndicatorStates + 4], a
	ld [wIndicatorStates + 9], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 13], a
	ld [wIndicatorStates + 14], a
	ld [wIndicatorStates + 11], a
	ld [wIndicatorStates + 12], a
	ld [wIndicatorStates + 10], a
	ld [wIndicatorStates + 6], a
	ld [wIndicatorStates + 7], a
	ld [wd558], a
	ld [wd559], a
	ld [wd551], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_20e1a
	callba Func_1c2cb
	callba Func_1e8f6
.asm_20e1a
	callba Func_86d2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, EvolutionFailedText
	call LoadTextHeader
	ret

Func_20e34: ; 0x20e34
	ld bc, $0001
	ld de, $5000
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20e5c
	ld a, [wIndicatorStates + 9]
	and a
	jr z, .asm_20e5c
	xor a
	ld [wIndicatorStates + 9], a
	ld a, [wd55c]
	and a
	ld a, $0
	ld [wd55c], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20e5c
	scf
	ret

Func_20e5e: ; 0x20e5e
	ld a, [wd551]
	and a
	jr nz, .asm_20e80
	ld a, [wIndicatorStates + 3]
	and a
	jr z, .asm_20e80
	xor a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 10], a
	ld a, [wd562]
	and a
	ld a, $0
	ld [wd562], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20e80
	scf
	ret

Func_20e82: ; 0x20e82
	ld a, [wd551]
	and a
	jr nz, .asm_20ea4
	ld a, [wIndicatorStates + 8]
	and a
	jr z, .asm_20ea4
	xor a
	ld [wIndicatorStates + 8], a
	ld [wIndicatorStates + 2], a
	ld a, [wd561]
	and a
	ld a, $0
	ld [wd561], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20ea4
	scf
	ret

Func_20ea6: ; 0x20ea6
	ld a, [wd551]
	and a
	jr nz, .asm_20ec5
	ld a, [wIndicatorStates + 13]
	and a
	jr z, .asm_20ec5
	xor a
	ld [wIndicatorStates + 13], a
	ld a, [wd55d]
	and a
	ld a, $0
	ld [wd55d], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20ec5
	scf
	ret

Func_20ec7: ; 0x20ec7
	ld a, [wd551]
	and a
	jr nz, .asm_20ee6
	ld a, [wIndicatorStates + 14]
	and a
	jr z, .asm_20ee6
	xor a
	ld [wIndicatorStates + 14], a
	ld a, [wd55e]
	and a
	ld a, $0
	ld [wd55e], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20ee6
	scf
	ret

Func_20ee8: ; 0x20ee8
	ld a, [wd551]
	and a
	jr nz, .asm_20f07
	ld a, [wIndicatorStates + 11]
	and a
	jr z, .asm_20f07
	xor a
	ld [wIndicatorStates + 11], a
	ld a, [wd55f]
	and a
	ld a, $0
	ld [wd55f], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f07
	scf
	ret

Func_20f09: ; 0x20f09
	ld a, [wd551]
	and a
	jr nz, .asm_20f28
	ld a, [wIndicatorStates + 12]
	and a
	jr z, .asm_20f28
	xor a
	ld [wIndicatorStates + 12], a
	ld a, [wd560]
	and a
	ld a, $0
	ld [wd560], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f28
	scf
	ret

Func_20f2a: ; 0x20f2a
	ld a, [wd551]
	and a
	jr nz, .asm_20f49
	ld a, [wIndicatorStates + 6]
	and a
	jr z, .asm_20f49
	xor a
	ld [wIndicatorStates + 6], a
	ld a, [wd565]
	and a
	ld a, $0
	ld [wd565], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f49
	scf
	ret

Func_20f4b: ; 0x20f4b
	ld bc, $0000
	ld de, $1500
	call Func_3538
	ld a, [wd551]
	and a
	jr nz, .asm_20f73
	ld a, [wIndicatorStates + 7]
	and a
	jr z, .asm_20f73
	xor a
	ld [wIndicatorStates + 7], a
	ld a, [wd564]
	and a
	ld a, $0
	ld [wd564], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_20f73
	scf
	ret

Func_20f75: ; 0x20f75
	lb de, $07, $46
	call PlaySoundEffect
	call Func_2111d
	ld a, [wCurrentEvolutionType]
	ld [hl], a
	ld [wd551], a
	ld a, [wIndicatorStates]
	ld [wd558], a
	ld a, [wIndicatorStates + 3]
	ld [wd559], a
	ld a, [wIndicatorStates + 2]
	ld [wd63f], a
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_20fc3
	ld a, BANK(Data_dd188)
	ld hl, Data_dd188
	ld de, $0070
	ld bc, $0010
	call Func_7dc
.asm_20fc3
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentEvolutionType]
	dec a
	ld c, a
	ld b, $0
	sla c
	ld hl, EvolutionTypeGetTextPointers
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, wd5cc
	call LoadTextHeader
	scf
	ret

Func_20fef: ; 0x20fef
	lb de, $07, $47
	call PlaySoundEffect
	ld a, $1
	ld [wd551], a
	ld a, [wIndicatorStates]
	ld [wd558], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld a, [wIndicatorStates + 3]
	ld [wd559], a
	ld a, [wIndicatorStates + 2]
	ld [wd63f], a
	xor a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld a, $58
	ld [wd556], a
	ld a, $2
	ld [wd557], a
	ld bc, ThreeHundredThousandPoints
	callba AddBigBCD6FromQueue
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, PokemonIsTiredText
	jr z, .asm_21057
	ld de, ItemNotFoundText
.asm_21057
	call LoadTextHeader
	scf
	ret

Func_2105c: ; 0x2105c
	ld a, [wd551]
	and a
	jr z, .asm_21077
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_21077
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr asm_210c7

.asm_21077
	scf
	ret

Func_21079: ; 0x21079
	ld a, [wd551]
	and a
	jr z, .asm_21087
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_21087
	jr asm_210c7

.asm_21087
	scf
	ret

Func_21089: ; 0x21089
	ld a, [wd551]
	and a
	jr nz, .asm_210aa
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_210a8
	xor a
	ld [wIndicatorStates], a
	ld a, [wd563]
	and a
	ld a, $0
	ld [wd563], a
	jp nz, Func_20f75
	jp Func_20fef

.asm_210a8
	scf
	ret

.asm_210aa
	ld a, [wd551]
	and a
	jr z, .asm_210c5
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_210c5
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueue
	jr asm_210c7

.asm_210c5
	scf
	ret

asm_210c7:
	xor a
	ld [wIndicatorStates + 1], a
	ld [wd551], a
	ld a, [wd558]
	ld [wIndicatorStates], a
	ld a, [wd559]
	ld [wIndicatorStates + 3], a
	ld a, [wd63f]
	ld [wIndicatorStates + 2], a
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, Func_1c2cb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_21102
	ld a, BANK(StageBlueFieldBottomOBJPalette6)
	ld hl, StageBlueFieldBottomOBJPalette6
	ld de, $0070
	ld bc, $0008
	call Func_7dc
.asm_21102
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentEvolutionType]
	cp EVO_EXPERIENCE
	ld de, PokemonRecoveredText
	jr z, .asm_21115
	ld de, TryNextPlaceText
.asm_21115
	ld hl, wd5cc
	call LoadTextHeader
	scf
	ret

Func_2111d: ; 0x2111d
	ld a, $11
	call Func_a21
	ld c, a
	ld b, $0
	ld hl, wd566
	add hl, bc
	ret

Func_2112a: ; 0x2112a
	ld a, [wCurrentEvolutionMon]
	cp $ff
	jr nz, .asm_21134
	ld a, [wCurrentCatchEmMon]
.asm_21134
	ld c, a
	ld b, $0
	sla c
	rl b
	add c
	ld c, a
	jr nc, .asm_21140
	inc b
.asm_21140
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
	ld de, vTilesSH tile $10
	ld bc, $0180
	call LoadOrCopyVRAMData
	pop bc
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_211a8
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
	hlCoord 7, 4, vBGMap
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
.asm_211a8
	callba Func_10e0a
	call Func_3475
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $2d, $26
	call PlaySoundEffect
	callba Func_10825
	call Func_3475
	ld a, $1
	ld [wd54d], a
	scf
	ret

SECTION "bank9", ROMX, BANK[$9]

InitMeowthBonusStage: ; 0x24000
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld [wd4c8], a
	ld [wStageCollisionState], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wd49a], a
	ld a, $1
	ld [wd7ac], a
	ld a, $40
	ld [wMeowthXPosition], a
	ld a, $20
	ld [wMeowthYPosition], a
	ld a, $10
	ld [wMeowthAnimationFrameCounter], a
	xor a
	ld [wMeowthStageScore], a
	ld [wd70b], a
	ld [wMeowthStageBonusCounter], a
	ld [wd713], a
	ld [wd739], a
	ld bc, $0100  ; 1 minute 0 seconds
	callba StartTimer
	ld a, $12
	call SetSongBank
	ld de, $0004
	call PlaySong
	ret

StartBallMeowthBonusStage: ; 0x24059
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	ld a, $40
	ld [wBallXVelocity], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd6e6], a
	ld hl, wd6f3
	ld b, $16
.asm_24081
	ld a, [hl]
	and a
	jr z, .asm_24088
	ld a, $1
	ld [hl], a
.asm_24088
	inc hl
	dec b
	jr nz, .asm_24081
	ld a, $1
	ld [wd7ac], a
	ld a, $40
	ld [wMeowthXPosition], a
	ld a, $20
	ld [wMeowthYPosition], a
	ld a, $10
	ld [wMeowthAnimationFrameCounter], a
	ld a, $ff  ; walk left
	ld [wMeowthXMovement], a
	xor a
	ld [wMeowthAnimationFrame], a
	ld [wd6ec], a
	ld [wMeowthAnimationFrameIndex], a
	ld [wd70b], a
	ld [wd70c], a
	ld a, $c8
	ld [wd71a], a
	ld [wd727], a
	ld [wd71b], a
	ld [wd728], a
	ld [wd71c], a
	ld [wd729], a
	ld [wd724], a
	ld [wd731], a
	ld [wd725], a
	ld [wd732], a
	ld [wd726], a
	ld [wd733], a
	xor a
	ld [wd717], a
	ld [wd718], a
	ld [wd719], a
	ld [wd721], a
	ld [wd722], a
	ld [wd723], a
	ld [wd714], a
	ld [wd715], a
	ld [wd716], a
	ld [wd71e], a
	ld [wd71f], a
	ld [wd720], a
	ld [wd64e], a
	ld [wd64f], a
	ld [wd650], a
	ld [wd651], a
	ld [wd795], a
	ld [wd796], a
	ld [wd797], a
	ld [wd798], a
	ld [wd799], a
	ld [wd79a], a
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	ret

Func_24128: ; 0x24128
	callba Func_142fc
	call Func_2862
	callba Func_24fa3
	call Func_24516
	callba Func_1404a
	ret

CheckMeowthBonusStageGameObjectCollisions: ; 0x2414d
	call CheckMeowthBonusStageMeowthCollision
	call CheckMeowthBonusStageJewelsCollision
	call CheckMeowthBonusStageJewelsCollision2
	ret

CheckMeowthBonusStageMeowthCollision: ; 0x24157
	ld a, [wd6e7]
	cp $0
	ret nz
	ld a, [wMeowthXPosition]
	add -9
	ld b, a
	ld a, [wMeowthYPosition]
	add $6
	ld c, a
	call CheckMeowthCollision
	ld a, $3
	ret nc
	ret

CheckMeowthCollision: ; 0x24170
	ld a, [wBallXPos + 1]
	sub b
	cp $30
	jp nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $28
	jp nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld h, d
	ld l, e
	sla e
	rl d
	add hl, de
	ld d, h
	ld e, l
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, MeowthCollisionAngles
	add hl, de
	ld a, BANK(MeowthCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7e9], a
	ld a, [wd6ec]
	cp $2
	ret z
	cp $3
	ret z
	ld a, [wd713]
	and a
	ret nz
	ld a, [wMeowthYMovement]
	and a
	jr z, .asm_241ed
	ld a, [wMeowthYMovement]
	cp $1
	jr nz, .asm_241df
	ld a, [wd70b]
	cp $3
	jr z, .asm_241eb
	jr .asm_241e6

.asm_241df
	ld a, [wd70c]
	cp $3
	jr z, .asm_241eb
.asm_241e6
	ld a, $2
	ld [wd6e7], a
.asm_241eb
	scf
	ret

.asm_241ed
	ld a, [wMeowthYPosition]
	cp $20
	jr nz, .asm_241fd
	ld a, [wd70b]
	cp $3
	jr z, .asm_24210
	jr .asm_2420b

.asm_241fd
	ld a, [wMeowthYPosition]
	cp $10
	jr nz, .asm_24210
	ld a, [wd70c]
	cp $3
	jr z, .asm_24210
.asm_2420b
	ld a, $1
	ld [wd6e7], a
.asm_24210
	scf
	ret

.noCollision
	and a
	ret

CheckMeowthBonusStageJewelsCollision: ; 0x24214
	ld a, [wd717]
	cp $2
	jr nz, .asm_2422e
	ld a, [wd71a]
	sub $4
	ld b, a
	ld a, [wd727]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $0
	jr c, .asm_24260
.asm_2422e
	ld a, [wd718]
	cp $2
	jr nz, .asm_24248
	ld a, [wd71b]
	sub $4
	ld b, a
	ld a, [wd728]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $1
	jr c, .asm_24260
.asm_24248
	ld a, [wd719]
	cp $2
	ret nz
	ld a, [wd71c]
	sub $4
	ld b, a
	ld a, [wd729]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $2
	ret nc
.asm_24260
	ld b, $0
	ld c, a
	ld hl, wd717
	add hl, bc
	ld a, $3
	ld [hl], a
	ld hl, wd714
	add hl, bc
	ld a, $0
	ld [hl], a
	ret

CheckJewelCollision: ; 0x24272
	ld a, [wBallXPos + 1]
	sub b
	cp $18
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $18
	jr nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld h, d
	ld l, e
	sla e
	rl d
	add hl, de
	ld d, h
	ld e, l
	ld l, b
	ld h, $0
	add hl, de
	ld de, MeowthJewelCollisionAngles
	add hl, de
	ld a, BANK(MeowthJewelCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.noCollision
	and a
	ret

CheckMeowthBonusStageJewelsCollision2: ; 0x242bb
	ld a, [wd721]
	cp $2
	jr nz, .asm_242d5
	ld a, [wd724]
	sub $4
	ld b, a
	ld a, [wd731]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $0
	jr c, .asm_24307
.asm_242d5
	ld a, [wd722]
	cp $2
	jr nz, .asm_242ef
	ld a, [wd725]
	sub $4
	ld b, a
	ld a, [wd732]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $1
	jr c, .asm_24307
.asm_242ef
	ld a, [wd723]
	cp $2
	ret nz
	ld a, [wd726]
	sub $4
	ld b, a
	ld a, [wd733]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $2
	ret nc
.asm_24307
	ld b, $0
	ld c, a
	ld hl, wd721
	add hl, bc
	ld a, $3
	ld [hl], a
	ld hl, wd71e
	add hl, bc
	ld a, $0
	ld [hl], a
	ret

Func_24319: ; 0x2438f
	ld a, [wd6f4]
	cp $0
	jr z, .asm_24333
	ld a, [wd71a]
	sub $4
	ld b, a
	ld a, [wd727]
	add $4
	ld c, a
	call Func_24405
	ld a, $0
	jr c, .asm_24373
.asm_24333
	ld a, [wd6f4]
	cp $1
	jr z, .asm_2434d
	ld a, [wd71b]
	sub $4
	ld b, a
	ld a, [wd728]
	add $4
	ld c, a
	call Func_24405
	ld a, $1
	jr c, .asm_24373
.asm_2434d
	ld a, [wd6f4]
	cp $2
	ret z
	ld a, [wd71c]
	sub $4
	ld b, a
	ld a, [wd729]
	add $4
	ld c, a
	call Func_24405
	ld a, $2
	jr c, .asm_24373
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld [hl], $0
	ret

.asm_24373
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	inc [hl]
	ld d, $4
	ld a, [wd6f4]
	add d
	ld d, a
	ld a, [hl]
	cp d
	ret nc
	ld hl, wd6f5
	add hl, bc
	ld [hl], $0
	ret

Func_2438f: ; 0x2438f
	ld a, [wd6f4]
	cp $a
	jr z, .asm_243a9
	ld a, [wd724]
	sub $4
	ld b, a
	ld a, [wd731]
	add $4
	ld c, a
	call Func_24405
	ld a, $a
	jr c, .asm_243e9
.asm_243a9
	ld a, [wd6f4]
	cp $b
	jr z, .asm_243c3
	ld a, [wd725]
	sub $4
	ld b, a
	ld a, [wd732]
	add $4
	ld c, a
	call Func_24405
	ld a, $b
	jr c, .asm_243e9
.asm_243c3
	ld a, [wd6f4]
	cp $c
	ret z
	ld a, [wd726]
	sub $4
	ld b, a
	ld a, [wd733]
	add $4
	ld c, a
	call Func_24405
	ld a, $c
	jr c, .asm_243e9
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld [hl], $0
	ret

.asm_243e9
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	inc [hl]
	ld d, $4
	ld a, [wd6f4]
	add d
	ld d, a
	ld a, [hl]
	cp d
	ret nc
	ld hl, wd6f5
	add hl, bc
	ld [hl], $0
	ret

Func_24405: ; 0x24405
	ld hl, wd71a
	ld a, [wd6f4]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	add $8
	sub b
	cp $18
	jr nc, .asm_24428
	ld b, a
	ld hl, wd727
	add hl, de
	ld a, [hl]
	add $8
	sub c
	cp $18
	jr nc, .asm_24428
	ld c, a
	ld d, b
	scf
	ret

.asm_24428
	and a
	ret

Func_2442a: ; 0x2442a
	ld a, [wd710]
	jr nz, .asm_2443f
	ld a, [wMeowthStageBonusCounter]
	dec a
	dec a
	cp $fe
	jr z, .asm_24447
	cp $ff
	jr z, .asm_24447
	ld [wd79a], a
.asm_2443f
	ld de, wd79a
	call Func_24f00
	jr .asm_2444b

.asm_24447
	xor a
	ld [wd79a], a
.asm_2444b
	call Func_244f5
	call Func_245ab
	call Func_248ac
	call Func_24d07
	ld a, [wMeowthStageScore]
	cp $14
	jr c, .asm_24498
	ld a, [wd712]
	cp $2
	jr nc, .asm_24498
	ld a, [wd498]
	cp $4
	ret z
	ld a, $4
	ld [wd712], a
	ld [wd498], a
	ld a, $96
	ld [wd739], a
	ld de, $0000
	call PlaySong
	ld a, $1
	ld [wd49a], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, MeowthStageClearedText
	call LoadTextHeader
	lb de, $4b, $2a
	call PlaySoundEffect
.asm_24498
	ld a, [wd712]
	cp $4
	jr nz, .asm_244b0
	ld a, [wSFXTimer]
	and a
	jr nz, .asm_244b0
	ld de, $0004
	call PlaySong
	ld a, $5
	ld [wd712], a
.asm_244b0
	ld a, [wd712]
	cp $4
	jr z, .asm_244c1
	callba Func_107f8
.asm_244c1
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba Func_86d2
	ld a, $1
	ld [wd713], a
	ld a, $1
	ld [wd712], a
	ld hl, Data_24704
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $4
	ld [wd6ec], a
	ret

Func_244f5: ; 0x244f5
	ld a, [wd6e6]
	and a
	ret nz
	ld a, [wd4b4]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd6e6], a
	callba LoadStageCollisionAttributes
	call Func_24516
	ret

Func_24516: ; 0x24516
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_24533
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_24529
	ld hl, Data_2456f
.asm_24529
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_24533)
	call Func_10aa
	ret

Data_24533:
	dr $24533, $2456f

Data_2456f:
	dr $2456f, $245ab

Func_245ab: ; 0x245ab
	ld a, [wd6e7]
	and a
	jr z, .asm_24621
	cp $2
	jr z, .asm_24621
	ld a, $1
	ld [wd6f3], a
	ld a, [wMeowthYPosition]
	cp $20
	jr z, .asm_245c7
	cp $10
	jr z, .asm_245cc
	jr .asm_245cf

.asm_245c7
	call Func_247d9
	jr .asm_245cf

.asm_245cc
	call Func_24c28
.asm_245cf
	xor a
	ld [wd6e7], a
	ld [wd6f3], a
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	lb de, $00, $33
	call PlaySoundEffect
	ld bc, OneThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wMeowthStageBonusCounter], a
	ld a, [wd6ec]
	cp $2
	jr nc, .asm_24621
	and a
	jr nz, .asm_24611
	ld hl, Data_246fe
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $2
	ld [wd6ec], a
	jr .asm_24651

.asm_24611
	ld hl, Data_24701
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $3
	ld [wd6ec], a
	jr .asm_24651

.asm_24621
	ld a, [wd713]
	and a
	jr z, .asm_2462e
	ld a, $4
	ld [wd6ec], a
	jr .asm_24651

.asm_2462e
	ld a, [wd6ec]
	cp $2
	jr nc, .asm_24651
	ld a, [wd70b]
	cp $3
	jr nz, .asm_24651
	ld a, [wd70c]
	cp $3
	jr nz, .asm_24651
	ld hl, Data_24704
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $4
	ld [wd6ec], a
.asm_24651
	ld a, [wd6ec]
	cp $2
	call c, Func_24709
	call Func_2465d
	ret

Func_2465d: ; 0x2465d
	ld a, [wd6ec]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_246e2
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMeowthAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wd6ec]
	and a
	jr nz, .asm_24689
	ld a, [wMeowthAnimationFrameIndex]
	cp $4
	ret nz
	ld hl, Data_246ec
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ret

.asm_24689
	cp $1
	jr nz, .asm_2469d
	ld a, [wMeowthAnimationFrameIndex]
	cp $4
	ret nz
	ld hl, Data_246f5
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ret

.asm_2469d
	cp $2
	jr nz, .asm_246b5
	ld a, [wMeowthAnimationFrameIndex]
	cp $1
	ret nz
	ld hl, Data_246ec
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	xor a
	ld [wd6ec], a
	ret

.asm_246b5
	cp $3
	jr nz, .asm_246ce
	ld a, [wMeowthAnimationFrameIndex]
	cp $1
	ret nz
	ld hl, Data_246f5
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $1
	ld [wd6ec], a
	ret

.asm_246ce
	cp $4
	jr nz, .asm_24689
	ld a, [wMeowthAnimationFrameIndex]
	cp $2
	ret nz
	ld hl, Data_24704
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ret

Data_246e2:
	dr $246e2, $246ec

Data_246ec:
	dr $246ec, $246f5

Data_246f5:
	dr $246f5, $246fe

Data_246fe:
	dr $246fe, $24701

Data_24701:
	dr $24701, $24704

Data_24704:
	dr $24704, $24709

Func_24709: ; 0x24709
	ld a, [wMeowthXPosition]
	ld hl, wMeowthXMovement
	add [hl]
	ld [wMeowthXPosition], a
	ld hl, wMeowthYMovement
	ld a, [hl]
	and a
	jr z, .asm_24730
	bit 7, [hl]
	ld a, [wMeowthYPosition]
	jr nz, .asm_24724
	inc a
	jr .asm_24725

.asm_24724
	dec a
.asm_24725
	cp $21
	jr z, .asm_24730
	cp $f
	jr z, .asm_24730
	ld [wMeowthYPosition], a
.asm_24730
	call Func_24737
	call Func_2476d
	ret

Func_24737: ; 0x24737
	ld a, [wMeowthXPosition]
	cp $8
	jr nc, .asm_24742
	ld a, $1
	jr .asm_2475a

.asm_24742
	cp $78
	jr c, .asm_2474a
	ld a, $ff
	jr .asm_2475a

.asm_2474a
	ld a, [hNumFramesDropped]
	and $3f
	ret nz
	call GenRandom
	bit 7, a
	ld a, $1
	jr z, .asm_2475a
	ld a, $ff
.asm_2475a
	ld [wMeowthXMovement], a
	bit 7, a
	ld a, $1
	jr z, .asm_24764
	xor a
.asm_24764
	ld [wd6ec], a
	ld a, $2
	ld [wMeowthAnimationFrameCounter], a
	ret

Func_2476d: ; 0x2476d
	ld a, [wMeowthYMovement]
	and a
	jr z, .asm_247ab
	cp $1
	jr z, .asm_24791
	ld a, [wMeowthYPosition]
	cp $10
	jr nz, .asm_2478d
	ld a, [wd6e7]
	cp $2
	jr nz, .asm_2478a
	ld a, $1
	ld [wd6e7], a
.asm_2478a
	xor a
	jr .asm_247c9

.asm_2478d
	ld a, $ff
	jr .asm_247c9

.asm_24791
	ld a, [wMeowthYPosition]
	cp $20
	jr nz, .asm_247a7
	ld a, [wd6e7]
	cp $2
	jr nz, .asm_247a4
	ld a, $1
	ld [wd6e7], a
.asm_247a4
	xor a
	jr .asm_247c9

.asm_247a7
	ld a, $1
	jr .asm_247c9

.asm_247ab
	ld a, [wd70b]
	cp $3
	jr z, .asm_247cd
	ld a, [wd70c]
	cp $3
	jr z, .asm_247d3
	ld a, [hNumFramesDropped]
	and $3f
	ret nz
	call GenRandom
	bit 0, a
	ld a, $1
	jr z, .asm_247c9
	ld a, $ff
.asm_247c9
	ld [wMeowthYMovement], a
	ret

.asm_247cd
	ld a, $ff
	ld [wMeowthYMovement], a
	ret

.asm_247d3
	ld a, $1
	ld [wMeowthYMovement], a
	ret

Func_247d9: ; 0x247d9
	ld a, [wd6f3]
	and a
	ret z
	ld a, [wd71a]
	cp $c8
	jr nz, .asm_24823
	ld a, [wMeowthXPosition]
	add $8
	ld [wd71a], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd727], a
	ld a, $1
	ld [wd717], a
	xor a
	ld [wd6f3], a
	ld [wd714], a
	ld [wd6f5], a
	ld [wd6f8], a
	ld [wd6fb], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wd4b4]
	cp b
	jr nc, .asm_2481d
	ld a, $0
	ld [wd72a], a
	jr .asm_24822

.asm_2481d
	ld a, $1
	ld [wd72a], a
.asm_24822
	ret

.asm_24823
	ld a, [wd71b]
	cp $c8
	jr nz, .asm_24868
	ld a, [wMeowthXPosition]
	add $8
	ld [wd71b], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd728], a
	ld a, $1
	ld [wd718], a
	xor a
	ld [wd6f3], a
	ld [wd715], a
	ld [wd6f6], a
	ld [wd6f9], a
	ld [wd6fc], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wd4b4]
	cp b
	jr nc, .asm_24862
	ld a, $0
	ld [wd72b], a
	jr .asm_24867

.asm_24862
	ld a, $1
	ld [wd72b], a
.asm_24867
	ret

.asm_24868
	ld a, [wd71c]
	cp $c8
	ret nz
	ld a, [wMeowthXPosition]
	add $8
	ld [wd71c], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd729], a
	ld a, $1
	ld [wd719], a
	xor a
	ld [wd6f3], a
	ld [wd716], a
	ld [wd6f7], a
	ld [wd6fa], a
	ld [wd6fd], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wd4b4]
	cp b
	jr nc, .asm_248a6
	ld a, $0
	ld [wd72c], a
	jr .asm_248ab

.asm_248a6
	ld a, $1
	ld [wd72c], a
.asm_248ab
	ret

Func_248ac: ; 0x248ac
	ld a, [wd717]
	cp $1
	jr nz, .asm_248d3
	ld a, [wd714]
	cp $a
	jr z, .asm_248c4
	ld a, $0
	ld [wd6f4], a
	call Func_24a30
	jr .asm_248d3

.asm_248c4
	ld hl, wd70b
	inc [hl]
	ld a, $2
	ld [wd717], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_248d3
	ld a, [wd718]
	cp $1
	jr nz, .asm_248fa
	ld a, [wd715]
	cp $a
	jr z, .asm_248eb
	ld a, $1
	ld [wd6f4], a
	call Func_24a30
	jr .asm_248fa

.asm_248eb
	ld hl, wd70b
	inc [hl]
	ld a, $2
	ld [wd718], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_248fa
	ld a, [wd719]
	cp $1
	jr nz, .asm_24921
	ld a, [wd716]
	cp $a
	jr z, .asm_24912
	ld a, $2
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24921

.asm_24912
	ld hl, wd70b
	inc [hl]
	ld a, $2
	ld [wd719], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24921
	ld a, [wd717]
	cp $2
	jr nz, .asm_2492c
	ld hl, wd714
	inc [hl]
.asm_2492c
	ld a, [wd718]
	cp $2
	jr nz, .asm_24937
	ld hl, wd715
	inc [hl]
.asm_24937
	ld a, [wd719]
	cp $2
	jr nz, .asm_24942
	ld hl, wd716
	inc [hl]
.asm_24942
	ld a, [wd717]
	cp $3
	jr nz, .asm_24968
	ld a, [wd71a]
	ld b, a
	ld a, [wd727]
	ld c, a
	ld hl, wd714
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_2495f
	call Func_24e7f
	jr .asm_24968

.asm_2495f
	cp $a
	jr nz, .asm_24968
	ld a, $4
	ld [wd717], a
.asm_24968
	ld a, [wd718]
	cp $3
	jr nz, .asm_2498e
	ld a, [wd71b]
	ld b, a
	ld a, [wd728]
	ld c, a
	ld hl, wd715
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24985
	call Func_24e7f
	jr .asm_2498e

.asm_24985
	cp $a
	jr nz, .asm_2498e
	ld a, $4
	ld [wd718], a
.asm_2498e
	ld a, [wd719]
	cp $3
	jr nz, .asm_249b4
	ld a, [wd71c]
	ld b, a
	ld a, [wd729]
	ld c, a
	ld hl, wd716
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_249ab
	call Func_24e7f
	jr .asm_249b4

.asm_249ab
	cp $a
	jr nz, .asm_249b4
	ld a, $4
	ld [wd719], a
.asm_249b4
	ld a, [wd717]
	cp $4
	jr nz, .asm_249d0
	ld a, $c8
	ld [wd71a], a
	ld [wd727], a
	xor a
	ld [wd717], a
	ld hl, wd70b
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24a06
.asm_249d0
	ld a, [wd718]
	cp $4
	jr nz, .asm_249ec
	ld a, $c8
	ld [wd71b], a
	ld [wd728], a
	xor a
	ld [wd718], a
	ld hl, wd70b
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24a06
.asm_249ec
	ld a, [wd719]
	cp $4
	ret nz
	ld a, $c8
	ld [wd71c], a
	ld [wd729], a
	xor a
	ld [wd719], a
	ld hl, wd70b
	dec [hl]
	ld a, [hl]
	cp $2
	ret nz
.asm_24a06
	ld a, [wd713]
	and a
	ret nz
	ld a, [wMeowthXMovement]
	cp $ff
	jr z, .asm_24a21
	ld hl, Data_246f5
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $1
	ld [wd6ec], a
	ret

.asm_24a21
	ld hl, Data_246ec
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $0
	ld [wd6ec], a
	ret

Func_24a30: ; 0x24a30
	ld a, [wd6f4]
	ld c, a
	ld b, $0
	ld hl, wd6f8
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_24a42
	call Func_24b41
	ret

.asm_24a42
	ld a, [wd6f4]
	ld c, a
	ld b, $0
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	bit 2, a
	jr z, .asm_24a5e
	bit 1, a
	jr nz, .asm_24a5e
	bit 0, a
	jr nz, .asm_24a5e
	ld hl, wd714
	add hl, bc
	inc [hl]
.asm_24a5e
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld hl, Data_24af1
	ld e, a
	ld d, $0
	add hl, de
	ld hl, wd72a
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_24a97
.asm_24a72
	ld hl, wd72a
	add hl, bc
	ld [hl], $0
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24af1
	add hl, de
	pop af
	add [hl]
	cp $8e
	jr nc, .asm_24a97
	ld hl, wd71a
	add hl, bc
	ld [hl], a
	jr .asm_24abf

.asm_24a97
	ld hl, wd72a
	add hl, bc
	ld [hl], $1
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24af1
	add hl, de
	ld a, [hl]
	ld d, a
	ld a, $ff
	sub d
	inc a
	ld d, a
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	add d
	cp $5
	jr c, .asm_24a72
	ld hl, wd71a
	add hl, bc
	ld [hl], a
.asm_24abf
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24af1
	add hl, de
	inc hl
	ld a, [hl]
	ld d, a
	ld hl, wd727
	add hl, bc
	ld a, [hl]
	add d
	ld hl, wd727
	add hl, bc
	ld [hl], a
	ld hl, wd6f5
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp $46
	jr nz, .asm_24af0
	ld a, c
	cp $9
	jr c, .asm_24aed
	call Func_2438f
	ret

.asm_24aed
	call Func_24319
.asm_24af0
	ret

Data_24af1:
	dr $24af1, $24b41

Func_24b41: ; 0x24b41
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	cp $14
	jp nc, Func_24bf6
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld hl, Data_24c0a
	ld e, a
	ld d, $0
	add hl, de
	ld hl, wd72a
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_24b8a
.asm_24b65
	ld hl, wd72a
	add hl, bc
	ld [hl], $0
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24c0a
	add hl, de
	pop af
	add [hl]
	cp $90
	jr nc, .asm_24b8a
	ld hl, wd71a
	add hl, bc
	ld [hl], a
	jr .asm_24bb2

.asm_24b8a
	ld hl, wd72a
	add hl, bc
	ld [hl], $1
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24c0a
	add hl, de
	ld a, [hl]
	ld d, a
	ld a, $ff
	sub d
	inc a
	ld d, a
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	add d
	cp $6
	jr c, .asm_24b65
	ld hl, wd71a
	add hl, bc
	ld [hl], a
.asm_24bb2
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24c0a
	add hl, de
	inc hl
	ld a, [hl]
	ld d, a
	ld hl, wd727
	add hl, bc
	ld a, [hl]
	add d
	ld hl, wd727
	add hl, bc
	ld [hl], a
	ld hl, wd6f5
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp $12
	jr nz, .asm_24bf4
	ld a, c
	cp $9
	jr c, .asm_24be1
	call Func_2438f
	jr .asm_24be4

.asm_24be1
	call Func_24319
.asm_24be4
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_24bf4
	ld [hl], $1
.asm_24bf4
	scf
	ret

Func_24bf6: ; 0x24bf6
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld [hl], $0
	ld hl, wd714
	add hl, bc
	ld [hl], $a
	ccf
	ret

Data_24c0a:
	dr $24c0a, $24c28

Func_24c28: ; 0x24c28
	ld a, [wd6f3]
	and a
	ret z
	ld a, [wd724]
	cp $c8
	jr nz, .asm_24c76
	ld a, [wMeowthXPosition]
	add $8
	ld [wd724], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd731], a
	ld a, $1
	ld [wd721], a
	ld hl, wd70c
	inc [hl]
	xor a
	ld [wd6f3], a
	ld [wd71e], a
	ld [wd6ff], a
	ld [wd702], a
	ld [wd705], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wd4b4]
	cp b
	jr nc, .asm_24c70
	ld a, $0
	ld [wd734], a
	jr .asm_24c75

.asm_24c70
	ld a, $1
	ld [wd734], a
.asm_24c75
	ret

.asm_24c76
	ld a, [wd725]
	cp $c8
	jr nz, .asm_24cbf
	ld a, [wMeowthXPosition]
	add $8
	ld [wd725], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd732], a
	ld a, $1
	ld [wd722], a
	ld hl, wd70c
	inc [hl]
	xor a
	ld [wd6f3], a
	ld [wd71f], a
	ld [wd700], a
	ld [wd703], a
	ld [wd706], a
	ld a, [wd6f7]
	add $14
	ld b, a
	ld a, [wd4b4]
	cp b
	jr nc, .asm_24cb9
	ld a, $0
	ld [wd735], a
	jr .asm_24cbe

.asm_24cb9
	ld a, $1
	ld [wd735], a
.asm_24cbe
	ret

.asm_24cbf
	ld a, [wd726]
	cp $c8
	ret nz
	ld a, [wMeowthXPosition]
	add $8
	ld [wd726], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd733], a
	ld a, $1
	ld [wd723], a
	ld hl, wd70c
	inc [hl]
	xor a
	ld [wd6f3], a
	ld [wd720], a
	ld [wd701], a
	ld [wd704], a
	ld [wd707], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wd4b4]
	cp b
	jr nc, .asm_24d01
	ld a, $0
	ld [wd736], a
	jr .asm_24d06

.asm_24d01
	ld a, $1
	ld [wd736], a
.asm_24d06
	ret

Func_24d07: ; 0x24d07
	ld a, [wd721]
	cp $1
	jr nz, .asm_24d2a
	ld a, [wd71e]
	cp $a
	jr z, .asm_24d1f
	ld a, $a
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24d2a

.asm_24d1f
	ld a, $2
	ld [wd721], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24d2a
	ld a, [wd722]
	cp $1
	jr nz, .asm_24d4d
	ld a, [wd71f]
	cp $a
	jr z, .asm_24d42
	ld a, $b
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24d4d

.asm_24d42
	ld a, $2
	ld [wd722], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24d4d
	ld a, [wd723]
	cp $1
	jr nz, .asm_24d70
	ld a, [wd720]
	cp $a
	jr z, .asm_24d65
	ld a, $c
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24d70

.asm_24d65
	ld a, $2
	ld [wd723], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24d70
	ld a, [wd721]
	cp $2
	jr nz, .asm_24d7b
	ld hl, wd71e
	inc [hl]
.asm_24d7b
	ld a, [wd722]
	cp $2
	jr nz, .asm_24d86
	ld hl, wd71f
	inc [hl]
.asm_24d86
	ld a, [wd723]
	cp $2
	jr nz, .asm_24d91
	ld hl, wd720
	inc [hl]
.asm_24d91
	ld a, [wd721]
	cp $3
	jr nz, .asm_24db7
	ld a, [wd724]
	ld b, a
	ld a, [wd731]
	ld c, a
	ld hl, wd71e
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24dae
	call Func_24e7f
	jr .asm_24db7

.asm_24dae
	cp $a
	jr nz, .asm_24db7
	ld a, $4
	ld [wd721], a
.asm_24db7
	ld a, [wd722]
	cp $3
	jr nz, .asm_24ddd
	ld a, [wd725]
	ld b, a
	ld a, [wd732]
	ld c, a
	ld hl, wd71f
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24dd4
	call Func_24e7f
	jr .asm_24ddd

.asm_24dd4
	cp $a
	jr nz, .asm_24ddd
	ld a, $4
	ld [wd722], a
.asm_24ddd
	ld a, [wd723]
	cp $3
	jr nz, .asm_24e03
	ld a, [wd726]
	ld b, a
	ld a, [wd733]
	ld c, a
	ld hl, wd720
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24dfa
	call Func_24e7f
	jr .asm_24e03

.asm_24dfa
	cp $a
	jr nz, .asm_24e03
	ld a, $4
	ld [wd723], a
.asm_24e03
	ld a, [wd721]
	cp $4
	jr nz, .asm_24e1f
	ld a, $c8
	ld [wd724], a
	ld [wd731], a
	xor a
	ld [wd721], a
	ld hl, wd70c
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24e55
.asm_24e1f
	ld a, [wd722]
	cp $4
	jr nz, .asm_24e3b
	ld a, $c8
	ld [wd725], a
	ld [wd732], a
	xor a
	ld [wd722], a
	ld hl, wd70c
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24e55
.asm_24e3b
	ld a, [wd723]
	cp $4
	ret nz
	ld a, $c8
	ld [wd726], a
	ld [wd733], a
	xor a
	ld [wd723], a
	ld hl, wd70c
	dec [hl]
	ld a, [hl]
	cp $2
	ret nz
.asm_24e55
	ld a, [wd713]
	and a
	ret nz
	ld a, [wMeowthXMovement]
	cp $ff
	jr z, .asm_24e70
	ld hl, Data_246f5
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $1
	ld [wd6ec], a
	ret

.asm_24e70
	ld hl, Data_246ec
	ld de, wMeowthAnimationFrameCounter
	call CopyHLToDE
	ld a, $0
	ld [wd6ec], a
	ret

Func_24e7f: ; 0x24e7f
	ld a, b
	ld [wd79c], a
	ld a, c
	ld [wd79e], a
	ld hl, wMeowthStageBonusCounter
	inc [hl]
	ld a, [hl]
	cp $7  ; maximum bonus
	jr nz, .asm_24e92
	xor a
	ld [hl], a
.asm_24e92
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	lb de, $00, $32
	call PlaySoundEffect
	ld a, [wMeowthStageBonusCounter]
	dec a
.asm_24ea6
	push af
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wMeowthStageScore
	inc [hl]
	pop af
	and a
	jr z, .asm_24ebf
	dec a
	jr .asm_24ea6

.asm_24ebf
	ld a, [wMeowthStageBonusCounter]
	dec a
	dec a
	cp $fe
	jr z, .asm_24ed7
	cp $ff
	jr z, .asm_24ed7
	ld [wd79a], a
	ld de, wd79a
	call Func_24ee7
	jr .asm_24ede

.asm_24ed7
	xor a
	ld [wd79a], a
	ld [wd795], a
.asm_24ede
	ld a, $1
	ld [wd64e], a
	call Func_24fa3
	ret

Func_24ee7: ; 0x24ee7
	ld a, $ff
	ld [wd795], a
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_24f30
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec de
	dec de
	dec de
	call CopyHLToDE
	ret

Func_24f00: ; 0x24f00
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_24f30
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
	ld a, $1
	ld [wd710], a
	ret nc
	dec de
	ld a, [de]
	cp $a
	ret nz
	xor a
	ld [de], a
	ld [wd79c], a
	ld [wd79e], a
	ld [wd795], a
	xor a
	ld [wd710], a
	ret

Data_24f30:
	dr $24f30, $24fa3

Func_24fa3: ; 0x24fa3
	ld a, [wMeowthStageScore]
	ld c, a
	ld b, $0
.asm_24fa9
	ld a, c
	and a
	jr z, .asm_24fb5
	ld a, b
	add $8
	ld b, a
	dec c
	ld a, c
	jr .asm_24fa9

.asm_24fb5
	ld a, b
	and a
	jr z, .asm_24fbb
	sub $8
.asm_24fbb
	ld [wd652], a
	ld a, [wMeowthStageBonusCounter]
	and a
	jr z, .asm_24fca
	ld b, a
	ld a, [wMeowthStageScore]
	inc a
	sub b
.asm_24fca
	ld [wd651], a
	ld a, $0
	ld [wd64e], a
	ld a, [wMeowthStageScore]
	and a
	ret z
	cp $15
	jr c, .asm_24fe2
	ld a, $14
	ld [wMeowthStageScore], a
	jr .asm_24fed

.asm_24fe2
	push af
	xor a
	ld [wd650], a
	ld a, $1
	ld [wd64e], a
	pop af
.asm_24fed
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_25007
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_24ffd
	ld hl, Data_25421
.asm_24ffd
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_25007)
	call Func_10aa
	ret

Data_25007:
	dr $25007, $25421

Data_25421:
	dr $25421, $2583b

Func_2583b: ; 0x2583b
	ld bc, $7f65
	callba DrawTimer
	callba DrawFlippers
	call Func_259fe
	call Func_25895
	call Func_2595e
	call Func_2586c
	callba DrawPinball
	call Func_25a39
	ret

Func_2586c: ; 0x2586c
	ld a, [wMeowthXPosition]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthYPosition]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, OAMIds_2588b
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

OAMIds_2588b:
	db $21, $22, $23, $24, $25, $26, $27, $28, $33, $34

Func_25895: ; 0x25895
	ld a, [wd714]
	cp $b
	jr nz, .asm_258a0
	xor a
	ld [wd714], a
.asm_258a0
	ld a, [wd715]
	cp $b
	jr nz, .asm_258ab
	xor a
	ld [wd715], a
.asm_258ab
	ld a, [wd716]
	cp $b
	jr nz, .asm_258b6
	xor a
	ld [wd716], a
.asm_258b6
	ld a, [wd71a]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd727]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd717]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd714]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd71b]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd728]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd718]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd715]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd71c]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd729]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd719]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd716]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

OAMPointers_25935:
	dw OAMIds_2593d
	dw OAMIds_2593d
	dw OAMIds_25948
	dw OAMIds_25953

OAMIds_2593d:
	db $29, $29, $29, $29, $2A, $2A, $2A, $2A, $2A, $2A, $2A

OAMIds_25948:
	db $2B, $2B, $2B, $2B, $2B, $2B, $2B, $2C, $2C, $2C, $2C

OAMIds_25953:
	db $2D, $32, $31, $30, $2F, $2E, $2F, $30, $31, $32, $32

Func_2595e: ; 0x2595e
	ld a, [wd71e]
	cp $b
	jr nz, .asm_25969
	xor a
	ld [wd71e], a
.asm_25969
	ld a, [wd71f]
	cp $b
	jr nz, .asm_25974
	xor a
	ld [wd71f], a
.asm_25974
	ld a, [wd720]
	cp $b
	jr nz, .asm_2597f
	xor a
	ld [wd720], a
.asm_2597f
	ld a, [wd724]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd731]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd721]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd71e]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd725]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd732]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd722]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd71f]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld a, [wd726]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd733]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd723]
	sla a
	ld e, a
	ld d, $0
	ld hl, OAMPointers_25935
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd720]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

Func_259fe: ; 0x259fe
	ld a, [wd795]
	and a
	ret z
	ld de, wd79c
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_25a29
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_25a29:
	db $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $40, $41, $42, $43
	db $FF

Func_25a39: ; 0x25a39
	ld a, [wd64e]
	and a
	ret z
	ld a, [wd652]
	ld hl, hSCX
	sub [hl]
	ld b, a
	xor a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd64f]
	cp $a
	jr c, .asm_25a58
	ld de, $0000
	jr .asm_25a5b

.asm_25a58
	ld de, $0001
.asm_25a5b
	ld hl, OAMIds_25a7a
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld hl, wd64f
	inc [hl]
	ld a, [hl]
	cp $14
	ret c
	ld [hl], $0
	ld hl, wd650
	inc [hl]
	ld a, [hl]
	cp $a
	ret nz
	xor a
	ld [wd64e], a
	ret

OAMIds_25a7a: ; 0x25a7a
	db $44, $45

InitSeelBonusStage: ; 0x25a7c
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld [wd4c8], a
	ld [wStageCollisionState], a
	ld a, $1
	ld [wd7ac], a
	ld a, [wBallType]
	ld [wBallTypeBackup], a
	xor a
	ld [wd4c8], a
	ld [wBallType], a
	ld [wd49a], a
	ld hl, Data_25ae5
	ld de, wd76d
	call Func_25ad8
	ld de, wd777
	call Func_25ad8
	ld de, wd781
	call Func_25ad8
	xor a
	ld [wd793], a
	ld [wd791], a
	ld [wd792], a
	ld [wd739], a
	ld bc, $0130  ; 1 minute 30 seconds
	callba StartTimer
	ld a, $11
	call SetSongBank
	ld de, $0003
	call PlaySong
	ret

Func_25ad8: ; 0x25ad8
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
	ret

Data_25ae5:
	dr $25ae5, $25af1

StartBallSeelBonusStage: ; 0x25af1
	ld a, $0
	ld [wBallXPos], a
	ld a, $a6
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $56
	ld [wBallYPos + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	xor a
	ld [wSCX], a
	ld [wStageCollisionState], a
	ld [wd766], a
	ld a, $0
	ld [wd772], a
	ld a, $1
	ld [wd77c], a
	ld a, $0
	ld [wd786], a
	ld a, $4
	ld [wd775], a
	ld [wd77f], a
	ld [wd76b], a
	ld a, $1
	ld [wd76c], a
	ld a, $4
	ld [wd776], a
	ld a, $1
	ld [wd780], a
	ld a, $5
	ld [wd771], a
	ld [wd77b], a
	ld [wd785], a
	ld a, $ff
	ld [wd79a], a
	xor a
	ld [wd792], a
	ld [wd791], a
	ld [wd64e], a
	ld [wd64f], a
	ld [wd650], a
	ld [wd651], a
	ld [wd795], a
	ld [wd796], a
	ld [wd797], a
	ld [wd798], a
	ld [wd799], a
	ld [wd79a], a
	ld de, wd76b
	ld a, [wd76c]
	call Func_26137
	ld de, wd775
	ld a, [wd776]
	call Func_26137
	ld de, wd77f
	ld a, [wd780]
	call Func_26137
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	ret

Func_25b97: ; 0x25b97
	callba Func_142fc
	call Func_2862
	callba Func_262f4
	call Func_25d0e
	callba Func_1404a
	ret

CheckSeelBonusStageGameObjectCollisions: ; 0x25bbc
	call CheckSeelBonusStageSeelHeadCollisions
	ret

CheckSeelBonusStageSeelHeadCollisions: ; 0x25bc0
	ld a, [wd76c]
	cp $0
	jr nz, .seel2
	ld a, [wd76e]
	ld b, a
	ld a, [wd770]
	add $14
	ld c, a
	call CheckSeelHeadCollision
	ld a, $0
	jr c, .hitSeelHead
.seel2
	ld a, [wd776]
	cp $0
	jr nz, .seel3
	ld a, [wd778]
	ld b, a
	ld a, [wd77a]
	add $14
	ld c, a
	call CheckSeelHeadCollision
	ld a, $1
	jr c, .hitSeelHead
.seel3
	ld a, [wd780]
	cp $0
	jr nz, .done
	ld a, [wd782]
	ld b, a
	ld a, [wd784]
	add $14
	ld c, a
	call CheckSeelHeadCollision
	ld a, $2
	jr c, .hitSeelHead
.done
	ret

.hitSeelHead
	ld [wd768], a
	ld a, $1
	ld [wd767], a
	ret

CheckSeelHeadCollision: ; 0x25c12
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
	jr nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, CircularCollisionAngles
	add hl, de
	ld a, BANK(CircularCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.noCollision
	and a
	ret

Func_25c5a: ; 0x25c5a
	call Func_25da3
	call Func_25ced
	ld a, [wd793]
	cp $14
	jr c, .asm_25c98
	ld a, [wd794]
	cp $2
	jr nc, .asm_25c98
	ld a, $1
	ld [wd498], a
	ld de, $0000
	call PlaySong
	ld a, $1
	ld [wd49a], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld de, SeelStageClearedText
	call LoadTextHeader
	ld a, $2
	ld [wd794], a
	lb de, $4b, $2a
	call PlaySoundEffect
.asm_25c98
	ld a, [wd794]
	cp $2
	jr nz, .asm_25cb0
	ld a, [wSFXTimer]
	and a
	jr nz, .asm_25cb0
	ld de, $0003
	call PlaySong
	ld a, $5
	ld [wd794], a
.asm_25cb0
	ld a, [wd794]
	cp $2
	jr z, .asm_25cc1
	callba Func_107f8
.asm_25cc1
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba Func_86d2
	ld a, $3
	ld [wd791], a
	ld a, [wd794]
	cp $5
	ret z
	ld a, $1
	ld [wd794], a
	ret

Func_25ced: ; 0x25ced
	ld a, [wd766]
	and a
	ret nz
	ld a, [wd4b4]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd766], a
	callba LoadStageCollisionAttributes
	call Func_25d0e
	ret

Func_25d0e: ; 0x25d0e
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_25d2b
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_25d21
	ld hl, Data_25d67
.asm_25d21
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_25d2b)
	call Func_10aa
	ret

Data_25d2b:
	dr $25d2b, $25d67

Data_25d67:
	dr $25d67, $25da3

Func_25da3: ; 0x25da3
	ld a, [wd767]
	and a
	jp z, .asm_25e38
	xor a
	ld [wd767], a
	ld a, [wd768]
	sla a
	ld c, a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, wd76c
	add hl, bc
	ld d, h
	ld e, l
	ld a, $9
	ld [de], a
	dec de
	dec de
	dec de
	push bc
	ld hl, Data_261d8
	call CopyHLToDE
	pop bc
	ld hl, wd76e
	add hl, bc
	ld a, [hl]
	ld [wd79c], a
	ld hl, wd770
	add hl, bc
	ld a, [hl]
	add $8
	ld [wd79e], a
	ld a, [wd792]
	cp $9
	jr nz, .asm_25df1
	ld a, $0
	ld [wd792], a
	ld [wd79a], a
.asm_25df1
	ld a, [wd792]
	dec a
	cp $ff
	jr z, .asm_25e04
	ld [wd79a], a
	ld de, wd79a
	call Func_261f9
	jr .asm_25e07

.asm_25e04
	ld [wd79a], a
.asm_25e07
	ld a, $33
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	lb de, $00, $30
	call PlaySoundEffect
	call Func_25e85
	ld hl, wd792
	inc [hl]
	ld a, [wd793]
	cp $14
	ret nc
	ld hl, wd793
	inc [hl]
	ld a, [wd792]
	dec a
	ld b, a
	ld a, [hl]
	add b
	ld [hl], a
	ld a, $1
	ld [wd64e], a
	call Func_262f4
.asm_25e38
	ld de, wd76c    ; I think these three calls are one for each Seel swimming around
	call Func_25f47
	ld de, wd776
	call Func_25f47
	ld de, wd780
	call Func_25f47
	ld a, [wd792]
	dec a
	cp $ff
	jr z, .asm_25e5d
	ld [wd79a], a
	ld de, wd79a
	call Func_26212
	jr .asm_25e60

.asm_25e5d
	ld [wd79a], a
.asm_25e60
	ld bc, $087a  ; again, probably one call for each Seel swimming around
	ld de, wd76d
	ld hl, wd772
	call Func_25ec5
	ld bc, $087a
	ld de, wd777
	ld hl, wd77c
	call Func_25ec5
	ld bc, $087a
	ld de, wd781
	ld hl, wd786
	call Func_25ec5
	ret

Func_25e85: ; 0x25e85
	ld a, [wd792]
	inc a
	ld d, $1
	ld e, a
	ld a, $1
.asm_25e8e
	cp e
	jr z, .asm_25e96
	sla d
	inc a
	jr .asm_25e8e

.asm_25e96
	push de
	ld a, d
	cp $32
	jr nc, .asm_25ead
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	pop de
	dec d
	jr .asm_25ebf

.asm_25ead
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	pop de
	ld a, d
	sub $32
	ld d, a
.asm_25ebf
	ld a, d
	cp $0
	jr nz, .asm_25e96
	ret

Func_25ec5: ; 0x25ec5
	dec de
	ld a, [de]
	cp $1
	jr z, .asm_25ece
	cp $4
	ret nz
.asm_25ece
	inc de
	push hl
	ld a, [hld]
	push af
	push bc
	ld a, [hl]
	and $f
	ld c, a
	ld b, $0
	ld hl, Data_25f27
	add hl, bc
	pop bc
	pop af
	and a
	jr nz, .asm_25f05
	ld a, [de]
	add [hl]
	ld [de], a
	inc de
	ld a, [de]
	adc $0
	ld [de], a
	pop hl
	cp c
	ret c
	ld a, $1
	ld [hl], a
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld a, $7
	ld [hl], a
	dec hl
	dec hl
	dec hl
	ld d, h
	ld e, l
	ld hl, Data_261c2
	call CopyHLToDE
	ret

.asm_25f05
	ld a, [de]
	sub [hl]
	ld [de], a
	inc de
	ld a, [de]
	sbc $0
	ld [de], a
	pop hl
	cp b
	ret nc
	xor a
	ld [hl], a
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	dec hl
	ld a, $8
	ld [hl], a
	dec hl
	dec hl
	dec hl
	ld d, h
	ld e, l
	ld hl, Data_261cd
	call CopyHLToDE
	ret

Data_25f27:
	dr $25f27, $25f47

Func_25f47: ; 0x25f47
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_2614f
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
CallTable_25f5f: ; 0x25f5f
	dw Func_25f77
	dw Func_25fbe
	dw Func_25ff3
	dw Func_2602a
	dw Func_2604c
	dw Func_2607f
	dw Func_260b6
	dw Func_260d8
	dw Func_260e2
	dw Func_260ec
	dw Func_26109
	dw Func_26120

Func_25f77: ; 0x25f77
	dec de
	ld a, [de]
	cp $2
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ld a, $3
	jr z, .asm_25f8f
	pop de
	xor a
	jp Func_26137

.asm_25f8f
	ld hl, wd792
	ld [hl], $0
	call GenRandom
	bit 7, a
	jr z, .asm_25fa2
	inc de
	ld a, $1
	ld [de], a
	dec de
	jr .asm_25fa7

.asm_25fa2
	inc de
	ld a, $0
	ld [de], a
	dec de
.asm_25fa7
	inc de
	ld a, [de]
	and a
	jr z, .asm_25fb0
	ld a, $6
	jr .asm_25fb2

.asm_25fb0
	ld a, $3
.asm_25fb2
	push af
	lb de, $00, $31
	call PlaySoundEffect
	pop af
	pop de
	jp Func_26137

Func_25fbe: ; 0x25fbe
	dec de
	ld a, [de]
	cp $4
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	dec a
	ld [de], a
	jr z, .asm_25fd5
	pop de
	ld a, $1
	jp Func_26137

.asm_25fd5
	ld a, [wd791]
	cp $0
	jr z, .asm_25fe9
	ld a, $2
	ld [de], a
	pop de
	ld a, $4
	ld [de], a
	ld a, $1
	jp Func_26137
	ret ; unused instruction

.asm_25fe9
	ld hl, wd791
	inc [hl]
	pop de
	ld a, $2
	jp Func_26137

Func_25ff3: ; 0x25ff3
	dec de
	ld a, [de]
	cp $7
	ret nz
	xor a
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [wd792]
	cp $6
	jr nc, .asm_26020
	cp $2
	jr nc, .asm_26016
	ld a, $3
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_26016
	ld a, $2
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_26020
	ld a, $1
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

Func_2602a: ; 0x2602a
	dec de
	ld a, [de]
	cp $9
	ret nz
	ld a, $1
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	call GenRandom
	bit 7, a
	jr z, .asm_26044
	ld a, $3
	jr .asm_26046

.asm_26044
	ld a, $5
.asm_26046
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_2604c: ; 0x2604c
	dec de
	ld a, [de]
	cp $4
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	dec a
	ld [de], a
	jr z, .asm_26063
	pop de
	ld a, $4
	jp Func_26137

.asm_26063
	ld a, [wd791]
	cp $0
	jr z, .asm_26075
	ld a, $2
	ld [de], a
	pop de
	ld a, $4
	ld [de], a
	jp Func_26137
	ret ; unused instruction

.asm_26075
	ld hl, wd791
	inc [hl]
	pop de
	ld a, $5
	jp Func_26137

Func_2607f: ; 0x2607f
	dec de
	ld a, [de]
	cp $7
	ret nz
	xor a
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [wd792]
	cp $6
	jr nc, .asm_260ac
	cp $2
	jr nc, .asm_260a2
	ld a, $3
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_260a2
	ld a, $2
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

.asm_260ac
	ld a, $1
	ld [de], a
	lb de, $00, $31
	call PlaySoundEffect
	ret

Func_260b6: ; 0x260b6
	dec de
	ld a, [de]
	cp $9
	ret nz
	ld a, $4
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	call GenRandom
	bit 7, a
	jr z, .asm_260d0
	ld a, $3
	jr .asm_260d2

.asm_260d0
	ld a, $5
.asm_260d2
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_260d8: ; 0x260d8
	dec de
	ld a, [de]
	cp $5
	ret nz
	ld a, $4
	jp Func_26137

Func_260e2: ; 0x260e2
	dec de
	ld a, [de]
	cp $5
	ret nz
	ld a, $1
	jp Func_26137

Func_260ec: ; 0x260ec
	dec de
	ld a, [de]
	cp $1
	ret nz
	push de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	and a
	jr z, .asm_26103
	pop de
	ld a, $b
	jp Func_26137

.asm_26103
	pop de
	ld a, $a
	jp Func_26137

Func_26109: ; 0x26109
	dec de
	ld a, [de]
	cp $7
	ret nz
	ld a, $1
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, $5
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_26120: ; 0x26120
	dec de
	ld a, [de]
	cp $7
	ret nz
	ld a, $4
	call Func_26137
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, $5
	ld [de], a
	ld hl, wd791
	dec [hl]
	ret

Func_26137: ; 0x26137
	push af
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_2614f
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	call CopyHLToDE
	pop de
	inc de
	pop af
	ld [de], a
	ret

Data_2614f:
	dr $2614f, $261c2

Data_261c2:
	dr $261c2, $261cd

Data_261cd:
	dr $261cd, $261d8

Data_261d8:
	dr $261d8, $261f9

Func_261f9: ; 0x261f9
	ld a, $ff
	ld [wd795], a
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_2623a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec de
	dec de
	dec de
	call CopyHLToDE
	ret

Func_26212: ; 0x26212
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_2623a
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
	dec de
	ld a, [de]
	cp $a
	ret nz
	xor a
	ld [de], a
	ld [wd79c], a
	ld [wd79e], a
	ld a, a
	ld [wd795], a
	ret

Data_2623a:
	dr $2623a, $262f4

Func_262f4: ; 0x262f4
	ld a, [wd793]
	ld c, a
	ld b, $0
.asm_262fa
	ld a, c
	and a
	jr z, .asm_26306
	ld a, b
	add $8
	ld b, a
	dec c
	ld a, c
	jr .asm_262fa

.asm_26306
	ld a, b
	and a
	jr z, .asm_2630c
	sub $8
.asm_2630c
	ld [wd652], a
	ld a, [wd792]
	and a
	jr z, .asm_2631b
	ld b, a
	ld a, [wd793]
	inc a
	sub b
.asm_2631b
	ld [wd651], a
	ld a, [wd793]
	cp $15
	jr c, .asm_2632a
	ld a, $14
	ld [wd793], a
.asm_2632a
	push af
	xor a
	ld [wd650], a
	pop af
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_2634a
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_26340
	ld hl, Data_26764
.asm_26340
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_2634a)
	call Func_10aa
	ret

Data_2634a:
	dr $2634a, $26764

Data_26764:
	dr $26764, $26b7e

Func_26b7e: ; 0x26b7e
	ld bc, $7f65
	callba DrawTimer
	call Func_26bf7
	callba DrawFlippers
	callba DrawPinball
	call Func_26ba9
	call Func_26c3c
	ret

Func_26ba9: ; 0x26ba9
	ld de, wd76e
	call Func_26bbc
	ld de, wd778
	call Func_26bbc
	ld de, wd782
	call Func_26bbc
	ret

Func_26bbc: ; 0x26bbc
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_26bdf
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_26bdf:
	db $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $63
	db $64, $65, $66, $67, $68, $69, $6A
	db $FF

Func_26bf7: ; 0x26bf7: ; 0x26bf7
	ld a, [wd795]
	cp $0
	ret z
	ld de, wd79c
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OAMIds_26c23
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

OAMIds_26c23:
	db $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7A
	db $7B, $7C, $7D, $7E, $7F, $80, $81, $82
	db $FF

Func_26c3c: ; 0x26c3c
	ld a, [wd64e]
	and a
	ret z
	ld a, [wd652]
	ld hl, hSCX
	sub [hl]
	ld b, a
	xor a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd64f]
	cp $a
	jr c, .asm_26c5b
	ld de, $0000
	jr .asm_26c5e

.asm_26c5b
	ld de, $0001
.asm_26c5e
	ld hl, OAMIds_26c7d
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ld hl, wd64f
	inc [hl]
	ld a, [hl]
	cp $14
	ret c
	ld [hl], $0
	ld hl, wd650
	inc [hl]
	ld a, [hl]
	cp $a
	ret nz
	xor a
	ld [wd64e], a
	ret

OAMIds_26c7d:
	db $83, $84

SECTION "banka", ROMX, BANK[$a]

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
	ld [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld a, $93
	ld [wOBP0], a
	ld a, $e4
	ld [wOBP1], a
	xor a
	ld [hSCX], a
	ld a, $8
	ld [hSCY], a
	ld a, $7
	ld [hWX], a
	ld a, $8c
	ld [hWY], a
	ld a, $3b
	ld [hLYC], a
	ld [hLastLYC], a
	ld [hNextLYCSub], a
	ld [hLYCSub], a
	ld hl, hSTAT
	set 6, [hl]
	ld hl, rIE
	set 1, [hl]
	ld a, $2
	ld [hHBlankRoutine], a
	ld hl, PointerTable_280a2
	ld a, [hGameBoyColorFlag]
	call LoadVideoData
	xor a
	ld [wCurPokedexIndex], a
	ld [wPokedexOffset], a
	ld [wd95b], a
	ld [wd95c], a
	ld [wd960], a
	ld [wd961], a
	ld [wd95e], a
	ld a, $1
	ld [wd862], a
	call ClearOAMBuffer
	call Func_285db
	call Func_28931
	call Func_289c8
	call Func_28a15
	call Func_28972
	call Func_28a8a
	call Func_28ad1
	call Func_28add
	call CountNumSeenOwnedMons
	call Func_b66
	ld a, $f
	call SetSongBank
	ld de, $0004
	call PlaySong
	call Func_588
	call Func_bbe
	ld hl, wScreenState
	inc [hl]
	ret

PointerTable_280a2: ; 0x280a2
	dw Data_280a6
	dw Data_280c4

Data_280a6: ; 0x280a6
	dab Data_ad800
	dw vTilesOB
	dw $6000
	dab Data_c5000
	dw $9800
	dw $1000
	dab Data_c4800
	dw vBGWin
	dw $800
	dab Data_c4800
	dw $9e00
	dw $800
	dw $FFFF ; terminators

Data_280c4: ; 0x280c4
	dab Data_ad800
	dw vTilesOB
	dw $6000
	dab Data_c5000
	dw $9800
	dw $1000
	dab Data_c5400
	dw $9800
	dw $1002
	dab Data_c4800
	dw vBGWin
	dw $800
	dab Data_c4800
	dw $9e00
	dw $800
	dab Data_c4c00
	dw vBGWin
	dw $802
	dab Data_c4c00
	dw $9e00
	dw $802
	dab Data_dce80
	dw $0000
	dw $101
	dw $FFFF ; terminators

MainPokedexScreen: ; 0x280fe
	call Func_28513
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_28142
	ld a, [wd95f]
	and a
	jp nz, .asm_28174
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	jp z, .asm_28174
	push hl
	ld a, [wCurPokedexIndex]
	inc a
	ld e, a
	ld d, $0
	call PlayCry
	pop hl
	bit 1, [hl]
	jp z, .asm_28174
	call Func_288c6
	call Func_2885c
	call CleanOAMBuffer
	call Func_2887c
	call Func_2885c
	ld hl, wScreenState
	inc [hl]
	ret

.asm_28142
	bit BIT_B_BUTTON, a
	jr z, .asm_2814f
	call Func_285db
	ld a, $4
	ld [wScreenState], a
	ret

.asm_2814f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_28174
	ld a, [hJoypadState]
	bit BIT_START, a
	jr z, .asm_28168
	ld a, [wd960]
	and a
	ld a, $ff
	ld [wd960], a
	call z, Func_28add
	jr .asm_28174

.asm_28168
	ld a, [wd960]
	and a
	ld a, $0
	ld [wd960], a
	call nz, Func_28add
.asm_28174
	call Func_285db
	ret

MonInfoPokedexScreen: ; 0x28178
	ld a, [wd956]
	bit 0, a
	jr z, .asm_28190
	ld a, [hNewlyPressedButtons]
	bit BIT_A_BUTTON, a
	jr z, .asm_2818a
	call Func_28912
	jr .asm_281a2

.asm_2818a
	bit 1, a
	jr z, .asm_281a2
	jr .asm_28196

.asm_28190
	ld a, [hNewlyPressedButtons]
	and $3
	jr z, .asm_281a2
.asm_28196
	call Func_288a2
	call Func_285db
	ld a, $1
	ld [wScreenState], a
	ret

.asm_281a2
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_281c7
	ld a, [hJoypadState]
	bit BIT_START, a
	jr z, .asm_281bb
	ld a, [wd960]
	and a
	ld a, $ff
	ld [wd960], a
	call z, Func_28add
	jr .asm_281c7

.asm_281bb
	ld a, [wd960]
	and a
	ld a, $0
	ld [wd960], a
	call nz, Func_28add
.asm_281c7
	call Func_2885c
	ret

Func_281cb:
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
	ld a, [wd960]
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
	ld [$ff8c], a
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
	ld [$ff8c], a
.asm_28214
	ld h, d
	ld l, e
	ld de, wda8a
	ld b, $8
.asm_2821b
	push bc
	ld a, [$ff8c]
	call ReadByteFromBank
	inc hl
	ld c, a
	ld a, [$ff8c]
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
	ld hl, Data_28289
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

Data_28289:
	dr $28289, $282b9

Data_282b9:
	dr $282b9, $282e9

Func_282e9: ; 0x282e9
	ld a, [wd960]
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
	ld a, [hNumFramesDropped]
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
	add $a5
	ld bc, $2030
	call LoadOAMData
.asm_28318
	ld a, [wdaa2]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_282b9
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $63
	call LoadOAMData
	call Func_28368
	ld a, [hNewlyPressedButtons]
	and $6
	jr z, .asm_28367
	ld a, BANK(Data_c4800)
	ld hl, Data_c4800
	ld de, vBGWin
	ld bc, $0200
	call LoadVRAMData
	ld a, $1
	ld [rVBK], a
	ld a, BANK(Data_c4c00)
	ld hl, Data_c4c00
	ld de, vBGWin
	ld bc, $0200
	call LoadVRAMData
	xor a
	ld [rVBK], a
	call Func_28972
	call Func_28a8a
	call Func_28ad1
	ld a, $1
	ld [wScreenState], a
.asm_28367
	ret

Func_28368: ; 0x28368
	ld a, [hJoypadState]
	bit BIT_A_BUTTON, a
	jr nz, .asm_28371
	jp Func_284bc

.asm_28371
	ld a, [hPressedButtons]
	ld b, a
	ld a, [wdaa2]
	ld e, a
	ld d, $0
	ld hl, wda8a
	add hl, de
	ld a, [hl]
	bit 5, b
	jr z, .asm_28386
	dec a
	jr .asm_2838a

.asm_28386
	bit 4, b
	ret z
	inc a
.asm_2838a
	and $1f
	ld [hl], a
	push af
	sla e
	rl d
	ld hl, Data_28289
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
	ld a, [wd960]
	and a
	jr nz, .asm_283ff
	ld hl, Data_2845c
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
	ld hl, Data_2845c
	add hl, de
	ld a, [hl]
	ld hl, rBGPI
	call PutTileInVRAM
	ld hl, rBGPD
	ld a, c
	call PutTileInVRAM
	ld a, b
	call PutTileInVRAM
	ld hl, Data_2848c
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
	dr $2842c, $2845c

Data_2845c:
	dr $2845c, $2848c

Data_2848c:
	dr $2848c, $284bc

Func_284bc: ; 0x284bc
	ld a, [hPressedButtons]
	ld b, a
	ld a, [wdaa2]
	bit 5, b
	jr z, .asm_284cd
	dec a
	bit 7, a
	jr nz, .asm_284ef
	jr .asm_284f5

.asm_284cd
	bit 4, b
	jr z, .asm_284d8
	inc a
	cp $18
	jr nc, .asm_284f3
	jr .asm_284f5

.asm_284d8
	bit 6, b
	jr z, .asm_284e4
	sub $3
	bit 7, a
	jr nz, .asm_284ef
	jr .asm_284f5

.asm_284e4
	bit 7, b
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
	call Func_cb5
	call Func_576
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

Func_28513: ; 0x28513
	ld a, [hPressedButtons]
	ld hl, wd95e
	or [hl]
	ld [hl], a
	ld a, [wd95c]
	and a
	ret nz
	ld a, [wd95e]
	ld b, a
	ld a, [wd9f8]
	and a
	ld a, NUM_POKEMON - 1
	jr z, .asm_2852d
	ld a, NUM_POKEMON
.asm_2852d
	ld d, a
	ld a, [wCurPokedexIndex]
	bit 6, b
	jr z, .asm_28548
	and a
	jr z, .asm_285a9
	dec a
	ld [wCurPokedexIndex], a
	ld a, $4
	ld [wd95c], a
	ld a, $1
	ld [wd95f], a
	jr .asm_285a9

.asm_28548
	bit 7, b
	jr z, .asm_2855f
	inc a
	cp d
	jr z, .asm_285a9
	ld [wCurPokedexIndex], a
	ld a, $4
	ld [wd95c], a
	ld a, $1
	ld [wd95f], a
	jr .asm_285a9

.asm_2855f
	ld a, d
	sub $9
	ld d, a
	ld a, [wPokedexOffset]
	ld c, $5
	bit 5, b
	jr z, .asm_28586
	cp $5
	jr nc, .asm_28571
	ld c, a
.asm_28571
	sub c
	ld [wPokedexOffset], a
	ld a, [wCurPokedexIndex]
	sub c
	ld [wCurPokedexIndex], a
	ld a, $1
	ld [wd95f], a
	call Func_285ca
	jr .asm_285aa

.asm_28586
	bit 4, b
	jr z, .asm_285ae
	cp d
	jr c, .asm_28594
	push af
	cpl
	add d
	add $5
	ld c, a
	pop af
.asm_28594
	add c
	ld [wPokedexOffset], a
	ld a, [wCurPokedexIndex]
	add c
	ld [wCurPokedexIndex], a
	ld a, $1
	ld [wd95f], a
	call Func_285ca
	jr .asm_285aa

.asm_285a9
	xor a
.asm_285aa
	ld [wd95e], a
	ret

.asm_285ae
	ld a, [wd95f]
	and a
	ret z
	lb de, $00, $03
	call PlaySoundEffect
	call Func_28931
	call Func_289c8
	call Func_28a15
	call Func_28add
	xor a
	ld [wd95f], a
	ret

Func_285ca: ; 0x285ca
	xor a
	ld [wd80a], a
	call Func_28972
	call Func_28a8a
	call Func_28ad1
	ld a, [wd80a]
	ret

Func_285db: ; 0x285db
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit 1, [hl]  ; has pokemon been seen or captured?
	call nz, Func_287e7
	ld bc, $8c38
	ld a, $64
	call LoadOAMData
	ld bc, vTilesSH tile $04
	ld a, $65
	call LoadOAMData
	ld bc, $8888
	ld a, $66
	call LoadOAMData
	call DrawCornerInfoPokedexScreen
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, DexScrollBarOffsets
	add hl, bc
	ld a, [hl]
	add $49
	ld c, a
	ld b, $90
	ld a, [wd95b]
	srl a
	srl a
	and $3
	ld e, a
	ld d, $0
	ld hl, DexScrollBarOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ld a, [wCurPokedexIndex]
	ld hl, wPokedexOffset
	sub [hl]
	jr nc, .asm_2863b
	dec [hl]
	ld a, $1
	ld [wd95d], a
	xor a
	jr .asm_28647

.asm_2863b
	cp $5
	jr c, .asm_28647
	ld a, $1
	ld [wd95d], a
	inc [hl]
	ld a, $4
.asm_28647
	ld c, a
	push bc
	ld a, [hJoypadState]
	and a
	ld a, [wd95b]
	jr z, .asm_28652
	xor a
.asm_28652
	inc a
	ld [wd95b], a
	bit 3, a
	jr nz, .asm_28667
	swap c
	ld a, c
	add $40
	ld c, a
	ld b, $10
	ld a, $63
	call LoadOAMData
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
	jp [hl]

PointerTable_2867f: ; 0x2867f
	dw Func_286dd
	dw Func_28721
	dw Func_286dd
	dw Func_28765

DexScrollBarOAMIds:
	db $67, $68, $69, $68

DrawCornerInfoPokedexScreen: ; 0x2868b
; If player is holding SELECT button, it draws the seen/own count in the top-right corner.
; Otherwise, it draws the word "POKeDEX".
	ld a, [hJoypadState]
	bit BIT_SELECT, a
	jr z, .asm_286c8
	ld bc, $6d03
	ld a, [wNumPokemonSeen + 1]
	call LoadSeenOwnDigitOAM
	ld a, [wNumPokemonSeen]
	swap a
	call LoadSeenOwnDigitOAM
	ld a, [wNumPokemonSeen]
	call LoadSeenOwnDigitOAM
	ld bc, $8202
	ld a, $76
	call LoadOAMData  ; draws the "/" between the seen/owned numbers
	ld bc, $8703
	ld a, [wNumPokemonOwned + 1]
	call LoadSeenOwnDigitOAM
	ld a, [wNumPokemonOwned]
	swap a
	call LoadSeenOwnDigitOAM
	ld a, [wNumPokemonOwned]
	call LoadSeenOwnDigitOAM
	ret

.asm_286c8
	ld bc, $6800
	ld a, $6a
	call LoadOAMData
	ret

LoadSeenOwnDigitOAM: ; 0x286d1
	and $f
	add $6c
	call LoadOAMData
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
	ld hl, wc010
	xor a
	ld bc, $00a0
	call LoadOrCopyVRAMData
	ld a, $1
	ld [wd862], a
	pop hl
	pop bc
.asm_286ff
	ld a, [wd95d]
	and a
	ret z
	ld a, [wd95c]
	and a
	jr nz, .asm_2870d
	ld [wd95d], a
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
	ld a, [wd95d]
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
	ld hl, Data_287c7
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
	ld hl, Data_287c7
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
	ld a, [wd95d]
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
	ld hl, Data_287b7
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
	call Func_28993
	ret

.asm_28791
	push hl
	ld a, [hl]
	add $5
	sla a
	and $e
	ld c, a
	ld b, $0
	ld hl, Data_287b7
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
	call Func_28993
	ret

Data_287b7:
	dr $287b7, $287c7

Data_287c7:
	dr $287c7, $287e7

Func_287e7: ; 0x287e7
	ld a, [wd960]
	and a
	ret z
	ld a, [wd95f]
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
	ld [wd5bc], a
	call Func_28815
	ld a, [wd5bd]
	add $a5
	ld bc, $2030
	call LoadOAMData
	ret

Func_28815: ; 0x28815
	ld a, [wd5be]
	dec a
	ld [wd5be], a
	ret nz
	ld a, [wBallHitWildMon]
	inc a
	and $7
	ld [wBallHitWildMon], a
	jr nz, .asm_28836
	ld a, [wd5c3]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
	ld c, $2
	jr .asm_28854

.asm_28836
	ld a, [wd5bc]
	ld c, a
	ld a, [wd5bd]
	sub c
	cp $1
	ld c, $0
	jr nc, .asm_28846
	ld c, $1
.asm_28846
	ld b, $0
	ld hl, wd5c1
	add hl, bc
	ld a, [hl]
	ld [wd5be], a
	xor a
	ld [wd5c4], a
.asm_28854
	ld a, [wd5bc]
	add c
	ld [wd5bd], a
	ret

Func_2885c: ; 0x2885c
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit 1, [hl]
	call nz, Func_287e7
	ld bc, $8888
	ld a, $66
	call LoadOAMData
	ld bc, $6800
	ld a, $6a
	call LoadOAMData
	ret

Func_2887c: ; 0x2887c
	ld a, BANK(Data_c5120)
	ld hl, Data_c5120
	deCoord 0, 8, vBGMap
	ld bc, $0100
	call LoadVRAMData
	ld a, $3f
	ld [hLYC], a
	ld a, $47
	ld [hNextLYCSub], a
	ld b, $33
.asm_28894
	push bc
	ld a, $7a
	sub b
	ld [hNextLYCSub], a
	rst AdvanceFrame
	pop bc
	dec b
	dec b
	dec b
	jr nz, .asm_28894
	ret

Func_288a2: ; 0x288a2
	ld b, $33
.asm_288a4
	push bc
	ld a, $44
	add b
	ld [hNextLYCSub], a
	rst AdvanceFrame
	pop bc
	dec b
	dec b
	dec b
	jr nz, .asm_288a4
	ld a, $3b
	ld [hLYC], a
	ld [hNextLYCSub], a
	ld a, BANK(Data_c5100)
	ld hl, Data_c5100
	deCoord 0, 8, vBGMap
	ld bc, $0020
	call LoadVRAMData
	ret

Func_288c6: ; 0x288c6
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit 1, [hl]
	ld hl, Unknown_2c000
	jr z, .asm_288f4
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
.asm_288f4
	xor a
	ld [wd860], a
	ld [wd861], a
	ld bc, $906c
	ld de, vTilesSH tile $10
	call Func_28d97
	rl a
	ld [wd956], a
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
	call Func_28d97
	rl a
	ld [wd956], a
	ld a, l
	ld [wd957], a
	ld a, h
	ld [wd958], a
	ret

Func_28931: ; 0x28931
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	ld hl, Data_28970
	jr z, .asm_2895d
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
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
.asm_2895d
	ld a, $ff
	ld [wd860], a
	xor a
	ld [wd861], a
	ld bc, $500a
	ld de, vTilesBG tile $50
	call Func_28e09
	ret

Data_28970:
	dr $28970, $28972

Func_28972: ; 0x28972
	ld a, [wPokedexOffset]
	ld c, a
	ld b, $6
.asm_28978
	push bc
	ld a, c
	sla a
	and $e
	ld e, a
	ld d, $0
	ld hl, Data_287b7
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, c
	call Func_28993
	pop bc
	inc c
	dec b
	jr nz, .asm_28978
	ret

Func_28993: ; 0x28993
	push hl
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	ld a, [hl]
	and a
	ld hl, Data_289c6
	jr z, .asm_289b7
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
.asm_289b7
	xor a
	ld [wd860], a
	ld [wd861], a
	ld bc, $500a ; not a pointer
	call Func_28e09
	pop hl
	ret

Data_289c6:
	dr $289c6, $289c8

Func_289c8: ; 0x289c8
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, wPokedexFlags
	add hl, bc
	bit 1, [hl]
	ld hl, Data_28a12
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
	add hl, bc  ; value * 11
	sla l
	rl h
	add hl, bc  ; value * 23
	ld bc, MonSpeciesNames
	add hl, bc
.pokemonNotOwned
	ld a, $ff
	ld [wd860], a
	ld a, $4
	ld [wd861], a
	ld bc, $5816
	ld de, vTilesBG tile $5a
	call Func_28e09
	ret

Data_28a12:
	dr $28a12, $28a15

Func_28a15: ; 0x28a15
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
	ld bc, Data_2a85d
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
	bit 1, [hl]
	jr nz, .asm_28a54
	ld de, Data_28a7f
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
	ld a, [rLCDC]
	bit 7, a
	jr nz, .asm_28a7a
	ld a, [de]
	ld [hl], a
	ret

.asm_28a7a
	ld a, [de]
	call PutTileInVRAM
	ret

Data_28a7f:
	dr $28a7f, $28a8a

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
	ld hl, Data_287c7
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
	ld bc, Data_2a85d
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
	ld [hNextFrameHBlankSCX], a
	ret

Func_28add: ; 0x28add
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
	ld a, [wd960]
	and a
	jr z, .asm_28afc
	call Func_28cc2
	jp z, Func_28bf5
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
	ld a, [hGameBoyColorFlag]
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
	ld a, [hGameBoyColorFlag]
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
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, BANK(UncaughtPokemonPaletteMap)
	ld de, UncaughtPokemonPaletteMap
	hlCoord 1, 3, vBGMap
	call LoadBillboardPaletteMap
	ret

Func_28bf5: ; 0x28bf5
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
	ld [rVBK], a
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
	ld [rVBK], a
	pop bc
	push bc
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, EvolutionLineIds
	add hl, bc
	ld a, BANK(EvolutionLineIds)
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
	ld hl, Data_13685
	add hl, bc
	ld a, Bank(Data_13685)
	call ReadByteFromBank
	ld [wd5c1], a
	ld [wd5be], a
	inc hl
	ld a, Bank(Data_13685)
	call ReadByteFromBank
	ld [wd5c2], a
	inc hl
	ld a, Bank(Data_13685)
	call ReadByteFromBank
	ld [wd5c3], a
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, Bank(MonAnimatedSpriteTypes)
	call ReadByteFromBank
	ld [wd5bc], a
	ld [wd5bd], a
	call Func_28cf8
	pop bc
	ld a, [hGameBoyColorFlag]
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

Func_28cc2: ; 0x28cc2
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, Bank(MonAnimatedSpriteTypes)
	call ReadByteFromBank
	bit 7, a
	ret

Func_28cd4: ; 0x28cd4
	xor a
	ld hl, wd961
	cp [hl]
	ret z
	ld [hl], a
	ld de, .Data_28ce0
	jr asm_28d1d

.Data_28ce0: ; 0x28ce0
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
	jr asm_28d1d

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

asm_28d1d
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
	bit 0, [hl]  ; is mon seen?
	jr z, .checkOwned
	inc e
.checkOwned
	bit 1, [hl]  ; is mon owned?
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
	ld a, [rLCDC]
	bit 7, a
	jr nz, .asm_28d92
	pop af
	ld [hl], a
	ret

.asm_28d92
	pop af
	call PutTileInVRAM
	ret

Func_28d97: ; 0x28d97
	push de
	ld a, b
	ld [$ff8c], a
	ld [$ff8d], a
	ld a, c
	ld [$ff8f], a
	xor a
	ld [$ff8e], a
	ld [$ff90], a
	ld [$ff91], a
	call Func_28e73
.asm_28daa
	call Func_2957c
	jr nc, .asm_28dcb
	push hl
	ld [$ff92], a
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
	ld [$ff93], a
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
	bit 7, c
	jr z, .asm_28de9
	dec b
.asm_28de9
	ld hl, wc010
	add hl, bc
	ld a, [$ff8f]
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

Func_28e09: ; 0x28e09
	push de
	ld a, b
	ld [$ff8c], a
	ld [$ff8d], a
	ld a, c
	ld [$ff8f], a
	xor a
	ld [$ff8e], a
	ld [$ff90], a
	ld [$ff91], a
	call Func_28e73
.asm_28e1c
	call Func_295e1
	jr nc, .asm_28e35
	push hl
	ld [$ff92], a
	ld c, a
	ld b, $0
	ld hl, CharacterWidths
	add hl, bc
	ld a, [hl]
	ld [$ff93], a
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
	ld hl, wc010
	add hl, bc
	ld a, [$ff8f]
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

Func_28e73: ; 0x28e73
	push hl
	ld a, [$ff8f]
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

Func_2957c: ; 0x2957c
	ld a, BANK(PokedexDescriptionPointers)
	call ReadByteFromBank
	inc hl
	and a
	ret z
	cp $d ; carriage return
	jr nz, .asm_2958c
	ld a, $ff
	scf
	ret

.asm_2958c
	cp "0"
	jr c, .asm_29594
	cp "9" + 1
	jr c, .asm_295be
.asm_29594
	cp "A"
	jr c, .asm_2959c
	cp "Z" + 1
	jr c, .asm_295c2
.asm_2959c
	cp "a"
	jr c, .asm_295a4
	cp "z" + 1
	jr c, .asm_295c6
.asm_295a4
	cp " "
	jr z, .asm_295ca
	cp ","
	jr z, .asm_295cd
	cp "."
	jr z, .asm_295d1
	cp "`"
	jr z, .asm_295d5
	cp "-"
	jr z, .asm_295d9
	cp "é"
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
	call Func_29605
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	scf
	ret

Func_29605: ; 0x29605
	ld a, b
	cp $81
	jr nz, .asm_29611
	ld hl, Data_2962f
	ld a, c
	sub $40
	ret

.asm_29611
	cp $83
	jr nz, .asm_2961c
	ld hl, Data_2973b
	ld a, c
	sub $40
	ret

.asm_2961c
	ld a, c
	cp $9f
	jr nc, .asm_29628
	ld hl, Data_2969c
	ld a, c
	sub $4f
	ret

.asm_29628
	ld hl, Data_296e8
	ld a, c
	sub $9f
	ret

Data_2962f:
	dr $2962f, $2969c

Data_2969c:
	dr $2969c, $296e8

Data_296e8:
	dr $296e8, $2973b

Data_2973b:
	dr $2973b, $29792

CharacterWidths: ; 0x29792
; The Pokedex shows variable-width font. This list specifies the width of every letter (tile?)
	db $05
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $05
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $06
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $08  ; "A"
	db $07  ; "B"
	db $07  ; "C"
	db $07  ; "D"
	db $07  ; "E"
	db $07  ; "F"
	db $07  ; "G"
	db $07  ; "H"
	db $05  ; "I"
	db $08  ; "J"
	db $07  ; "K"
	db $07  ; "L"
	db $08  ; "M"
	db $07  ; "N"
	db $07  ; "O"
	db $07  ; "P"
	db $08  ; "Q"
	db $07  ; "R"
	db $07  ; "S"
	db $08  ; "T"
	db $07  ; "U"
	db $08  ; "V"
	db $08  ; "W"
	db $08  ; "X"
	db $08  ; "Y"
	db $08  ; "Z"
	db $07
	db $08
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $08
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $05
	db $08
	db $07
	db $07
	db $08
	db $07
	db $07
	db $07
	db $08
	db $07
	db $07
	db $08
	db $07
	db $08
	db $08
	db $08
	db $08
	db $08
	db $07  ; "a"
	db $07  ; "b"
	db $07  ; "c"
	db $07  ; "d"
	db $07  ; "e"
	db $07  ; "f"
	db $07  ; "g"
	db $07  ; "h"
	db $03  ; "i"
	db $07  ; "j"
	db $07  ; "k"
	db $03  ; "l"
	db $08  ; "m"
	db $07  ; "n"
	db $07  ; "o"
	db $07  ; "p"
	db $07  ; "q"
	db $07  ; "r"
	db $07  ; "s"
	db $07  ; "t"
	db $07  ; "u"
	db $07  ; "v"
	db $08  ; "w"
	db $07  ; "x"
	db $07  ; "y"
	db $07  ; "z"
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $07
	db $03
	db $07
	db $05
	db $05
	db $05
	db $05
	db $05
	db $07
	db $07
	db $07
	db $07
	db $05
	db $07
	db $07
	db $07
	db $07
	db $07

INCLUDE "text/pokedex_mon_names.asm"
INCLUDE "data/mon_species.asm"
INCLUDE "text/pokedex_species.asm"

Data_2a85d:
	dr $2a85d, $2b136

INCLUDE "data/dex_scroll_offsets.asm"

SECTION "bankb", ROMX, BANK[$b]

Unknown_2c000: ; 0x2c000
	dex_text " "
	dex_end

INCLUDE "text/pokedex_descriptions.asm"

SECTION "bankc", ROMX, BANK[$c]

InitRedField: ; 0x30000
	ld a, [wd7c1]
	and a
	ret nz
	xor a
	ld hl, wScore + $5
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hld], a
	ld [hl], a
	ld [wNumPartyMons], a
	ld [wd49b], a
	ld [wd4c9], a
	ld [wBallType], a
	ld [wd4c8], a
	ld hl, wd624
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd7ac], a
	ld [wd7be], a
	ld [wCurrentMap], a  ; PALLET_TOWN
	ld a, $1
	ld [wd49d], a
	ld [wd482], a
	ld a, $2
	ld [wRightAlleyCount], a
	ld a, $3
	ld [wd49e], a
	ld [wd610], a
	ld [wd498], a
	ld [wd499], a
	ld a, $4
	ld [wStageCollisionState], a
	ld [wd7ad], a
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 3], a
	ld a, $82
	ld [wIndicatorStates + 1], a
	callba Start20SecondSaverTimer
	callba Func_16f95
	ld a, $f
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

StartBallRedField: ; 0x3007d
	ld a, [wd496]
	and a
	jp nz, StartBallAfterBonusStageRedField
	ld a, $0
	ld [wBallXPos], a
	ld a, $a7
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $98
	ld [wBallYPos + 1], a
	xor a
	ld [wd549], a
	ld [wd580], a
	ld a, [wd7ad]
	bit 7, a
	jr z, .asm_300ae
	ld a, [wStageCollisionState]
	res 0, a
	ld [wd7ad], a
.asm_300ae
	ld a, [wStageCollisionState]
	and $1
	ld [wStageCollisionState], a
	ld a, [wd4c9]
	and a
	ret z
	xor a
	ld [wd4c9], a
	xor a
	ld [wd50b], a
	ld [wd50c], a
	ld [wd51d], a
	ld [wd517], a
	ld [wd51e], a
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wLeftMapMoveCounter], a
	ld [wRightMapMoveCounter], a
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wBallType], a
	ld [wd611], a
	ld [wd612], a
	ld [wd628], a
	ld [wd629], a
	ld [wd62a], a
	ld [wd62b], a
	ld [wd62c], a
	ld [wd62d], a
	ld [wd62e], a
	ld [wd613], a
	inc a
	ld [wd482], a
	ld [wd4ef], a
	ld [wd4f1], a
	ld a, $3
	ld [wd610], a
	callba Func_16f95
	ld a, $f
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

StartBallAfterBonusStageRedField: ; 0x30128
	ld a, $0
	ld [wBallXPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $16
	ld [wBallYPos + 1], a
	xor a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wd496], a
	ld [wSCX], a
	ld [wd7be], a
	ld a, [wBallTypeBackup]
	ld [wBallType], a
	ld a, $f
	call SetSongBank
	ld de, $0001
	call PlaySong
	ret

Func_30164: ; 0x30164
	ld a, [wd49b]
	inc a
	cp $b
	jr z, .asm_30175
	ld [wd49b], a
	ld a, $1
	ld [wd4ca], a
	ret

.asm_30175
	ld bc, TenMillionPoints
	callba AddBigBCD6FromQueue
	ld a, $2
	ld [wd4ca], a
	ret

Func_30188: ; 0x30188
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd4ca]
	and a
	ret z
	cp $1
	jr nz, .asm_301a7
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, ExtraBallText
	call LoadTextHeader
	jr .asm_301c9

.asm_301a7
	ld bc, $1000
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, DigitsText1to9
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, ExtraBallSpecialBonusText
	call LoadTextHeader
.asm_301c9
	xor a
	ld [wd4ca], a
	ret

Func_301ce: ; 0x301ce
	ld a, [wCurrentStage]
	call CallInFollowingTable
PointerTable_301d4: ; 0x301d4
	; STAGE_RED_FIELD_TOP
	padded_dab Func_314ae
	; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_314ae
	padded_dab Func_314ae
	padded_dab Func_314ae
	; STAGE_BLUE_FIELD_TOP
	padded_dab Func_3161b
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab Func_3161b

StartMapMoveMode: ; 0x301ec
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, $1
	ld [wInSpecialMode], a
	ld a, $2
	ld [wSpecialMode], a
	xor a
	ld [wd54d], a
	ld bc, $0030  ; 30 seconds
	callba StartTimer
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_3021b
	ld a, [wd55a]
	add $12
	call Func_30256
.asm_3021b
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_3021f: ; 0x3021f
	; STAGE_RED_FIELD_TOP
	dw Func_311b4
	; STAGE_RED_FIELD_BOTTOM
	dw Func_311b4
	dw Func_31324
	dw Func_31324
	; STAGE_BLUE_FIELD_TOP
	dw Func_31326
	; STAGE_BLUE_FIELD_BOTTOM
	dw Func_31326

Func_3022b: ; 0x3022b
	xor a
	ld [wd5ca], a
	call FillBottomMessageBufferWithBlackTile
	xor a
	ld [wInSpecialMode], a
	ld [wSpecialMode], a
	callba Func_86d2
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_30247: ; 0x30247
	; STAGE_RED_FIELD_TOP
	dw Func_31234
	; STAGE_RED_FIELD_BOTTOM
	dw Func_31234
	dw Func_31325
	dw Func_31325
	; STAGE_BLUE_FIELD_TOP
	dw Func_313c3
	; STAGE_BLUE_FIELD_TOP
	dw Func_313c3

Func_30253: ; 0x30253
	ld a, [wCurrentMap]
	; fall through
Func_30256: ; 0x30256
	sla a
	ld c, a
	ld b, $0
	push bc
	ld hl, PointerTable_3027a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(PointerTable_3027a)
	call Func_10aa
	pop bc
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, PointerTable_30ceb
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(PointerTable_30ceb)
	call Func_10aa
	ret

PointerTable_3027a: ; 0x3027a
	dw Data_302b0
	dw Data_302c1
	dw Data_302d2
	dw Data_302e3
	dw Data_302f4
	dw Data_30305
	dw Data_30316
	dw Data_30327
	dw Data_30338
	dw Data_30349
	dw Data_3035a
	dw Data_3036b
	dw Data_3037c
	dw Data_3038d
	dw Data_3039e
	dw Data_303af
	dw Data_303c0
	dw Data_303d1
	dw Data_303e2
	dw Data_303f3
	dw Data_30404
	dw Data_30415
	dw Data_30426
	dw Data_30437
	dw Data_30448
	dw Data_30459
	dw Data_3046a

Data_302b0: ; 0x302b0
	db $08, $7B, $44, $85, $44, $8F, $44, $99, $44, $A3, $44, $AD, $44, $B7, $44, $C1, $44
Data_302c1: ; 0x302c1
	db $08, $CB, $44, $D5, $44, $DF, $44, $E9, $44, $F3, $44, $FD, $44, $07, $45, $11, $45
Data_302d2: ; 0x302d2
	db $08, $1B, $45, $25, $45, $2F, $45, $39, $45, $43, $45, $4D, $45, $57, $45, $61, $45
Data_302e3: ; 0x302e3
	db $08, $6B, $45, $75, $45, $7F, $45, $89, $45, $93, $45, $9D, $45, $A7, $45, $B1, $45
Data_302f4: ; 0x302f4
	db $08, $BB, $45, $C5, $45, $CF, $45, $D9, $45, $E3, $45, $ED, $45, $F7, $45, $01, $46
Data_30305: ; 0x30305
	db $08, $0B, $46, $15, $46, $1F, $46, $29, $46, $33, $46, $3D, $46, $47, $46, $51, $46
Data_30316: ; 0x30316
	db $08, $5B, $46, $65, $46, $6F, $46, $79, $46, $83, $46, $8D, $46, $97, $46, $A1, $46
Data_30327: ; 0x30327
	db $08, $AB, $46, $B5, $46, $BF, $46, $C9, $46, $D3, $46, $DD, $46, $E7, $46, $F1, $46
Data_30338: ; 0x30338
	db $08, $FB, $46, $05, $47, $0F, $47, $19, $47, $23, $47, $2D, $47, $37, $47, $41, $47
Data_30349: ; 0x30349
	db $08, $4B, $47, $55, $47, $5F, $47, $69, $47, $73, $47, $7D, $47, $87, $47, $91, $47
Data_3035a: ; 0x3035a
	db $08, $9B, $47, $A5, $47, $AF, $47, $B9, $47, $C3, $47, $CD, $47, $D7, $47, $E1, $47
Data_3036b: ; 0x3036b
	db $08, $EB, $47, $F5, $47, $FF, $47, $09, $48, $13, $48, $1D, $48, $27, $48, $31, $48
Data_3037c: ; 0x3037c
	db $08, $3B, $48, $45, $48, $4F, $48, $59, $48, $63, $48, $6D, $48, $77, $48, $81, $48
Data_3038d: ; 0x3038d
	db $08, $8B, $48, $95, $48, $9F, $48, $A9, $48, $B3, $48, $BD, $48, $C7, $48, $D1, $48
Data_3039e: ; 0x3039e
	db $08, $DB, $48, $E5, $48, $EF, $48, $F9, $48, $03, $49, $0D, $49, $17, $49, $21, $49
Data_303af: ; 0x303af
	db $08, $2B, $49, $35, $49, $3F, $49, $49, $49, $53, $49, $5D, $49, $67, $49, $71, $49
Data_303c0: ; 0x303c0
	db $08, $7B, $49, $85, $49, $8F, $49, $99, $49, $A3, $49, $AD, $49, $B7, $49, $C1, $49
Data_303d1: ; 0x303d1
	db $08, $CB, $49, $D5, $49, $DF, $49, $E9, $49, $F3, $49, $FD, $49, $07, $4A, $11, $4A
Data_303e2: ; 0x303e2
	db $08, $1B, $4A, $25, $4A, $2F, $4A, $39, $4A, $43, $4A, $4D, $4A, $57, $4A, $61, $4A
Data_303f3: ; 0x303f3
	db $08, $6B, $4A, $75, $4A, $7F, $4A, $89, $4A, $93, $4A, $9D, $4A, $A7, $4A, $B1, $4A
Data_30404: ; 0x30404
	db $08, $BB, $4A, $C5, $4A, $CF, $4A, $D9, $4A, $E3, $4A, $ED, $4A, $F7, $4A, $01, $4B
Data_30415: ; 0x30415
	db $08, $0B, $4B, $15, $4B, $1F, $4B, $29, $4B, $33, $4B, $3D, $4B, $47, $4B, $51, $4B
Data_30426: ; 0x30426
	db $08, $5B, $4B, $65, $4B, $6F, $4B, $79, $4B, $83, $4B, $8D, $4B, $97, $4B, $A1, $4B
Data_30437: ; 0x30437
	db $08, $AB, $4B, $B5, $4B, $BF, $4B, $C9, $4B, $D3, $4B, $DD, $4B, $E7, $4B, $F1, $4B
Data_30448: ; 0x30448
	db $08, $FB, $4B, $05, $4C, $0F, $4C, $19, $4C, $23, $4C, $2D, $4C, $37, $4C, $41, $4C
Data_30459: ; 0x30459
	db $08, $4B, $4C, $55, $4C, $5F, $4C, $69, $4C, $73, $4C, $7D, $4C, $87, $4C, $91, $4C
Data_3046a: ; 0x3046a
	db $08, $9B, $4C, $A5, $4C, $AF, $4C, $B9, $4C, $C3, $4C, $CD, $4C, $D7, $4C, $E1, $4C
	dr $3047b, $30ceb

PointerTable_30ceb: ; 0x30ceb
	dw Data_30d21
	dw Data_30d26
	dw Data_30d2b
	dw Data_30d30
	dw Data_30d35
	dw Data_30d3a
	dw Data_30d3f
	dw Data_30d44
	dw Data_30d49
	dw Data_30d4e
	dw Data_30d53
	dw Data_30d58
	dw Data_30d5d
	dw Data_30d62
	dw Data_30d67
	dw Data_30d6c
	dw Data_30d71
	dw Data_30d76
	dw Data_30d7b
	dw Data_30d80
	dw Data_30d85
	dw Data_30d8a
	dw Data_30d8f
	dw Data_30d94
	dw Data_30d99
	dw Data_30d9e
	dw Data_30da3

Data_30d21: ; 0x30d21
	db $02, $A8, $4D, $B1, $4D
Data_30d26: ; 0x30d26
	db $02, $CD, $4D, $D6, $4D
Data_30d2b: ; 0x30d2b
	db $02, $F2, $4D, $FB, $4D
Data_30d30: ; 0x30d30
	db $02, $17, $4E, $20, $4E
Data_30d35: ; 0x30d35
	db $02, $3C, $4E, $45, $4E
Data_30d3a: ; 0x30d3a
	db $02, $61, $4E, $6A, $4E
Data_30d3f: ; 0x30d3f
	db $02, $86, $4E, $8F, $4E
Data_30d44: ; 0x30d44
	db $02, $AB, $4E, $B4, $4E
Data_30d49: ; 0x30d49
	db $02, $D0, $4E, $D9, $4E
Data_30d4e: ; 0x30d4e
	db $02, $F5, $4E, $FE, $4E
Data_30d53: ; 0x30d53
	db $02, $1A, $4F, $23, $4F
Data_30d58: ; 0x30d58
	db $02, $3F, $4F, $48, $4F
Data_30d5d: ; 0x30d5d
	db $02, $64, $4F, $6D, $4F
Data_30d62: ; 0x30d62
	db $02, $89, $4F, $92, $4F
Data_30d67: ; 0x30d67
	db $02, $AE, $4F, $B7, $4F
Data_30d6c: ; 0x30d6c
	db $02, $D3, $4F, $DC, $4F
Data_30d71: ; 0x30d71
	db $02, $F8, $4F, $01, $50
Data_30d76: ; 0x30d76
	db $02, $1D, $50, $26, $50
Data_30d7b: ; 0x30d7b
	db $02, $42, $50, $4B, $50
Data_30d80: ; 0x30d80
	db $02, $67, $50, $70, $50
Data_30d85: ; 0x30d85
	db $02, $8C, $50, $95, $50
Data_30d8a: ; 0x30d8a
	db $02, $B1, $50, $BA, $50
Data_30d8f: ; 0x30d8f
	db $02, $D6, $50, $DF, $50
Data_30d94: ; 0x30d94
	db $02, $FB, $50, $04, $51
Data_30d99: ; 0x30d99
	db $02, $20, $51, $29, $51
Data_30d9e: ; 0x30d9e
	db $02, $45, $51, $4E, $51
Data_30da3: ; 0x30da3
	db $02, $6A, $51, $73, $51
	dr $30da8, $3118f

Func_3118f: ; 0x3118f
	push bc
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld a, [wCurrentMap]
	sla a
	ld c, a
	ld b, $0
	ld hl, MapNames
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, wd5d4
	call LoadTextHeader
	pop de
	ld hl, wd5cc
	call LoadTextHeader
	ret

Func_311b4: ; 0x311b4
	ld a, [wd55a]
	and a
	jr nz, .asm_311ce
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	jr .asm_311e2

.asm_311ce
	ld a, $80
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 4], a
	jr .asm_311e2

.asm_311e2
	ld a, $2
	callba Func_149d9
	ld a, $5
	callba Func_149d9
	ld a, $6a
	ld [wc7f0], a
	ld a, $6b
	ld [wc810], a
	ld a, $66
	ld [wc7e3], a
	ld a, $67
	ld [wc803], a
	callba Func_107b0
	ld a, $4
	ld [wd7ad], a
	ld de, $0003
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_14135
	ret

Func_31234: ; 0x31234
	callba Func_107a5
	callba Func_107c2
	callba Func_107c8
	callba Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_14135
	callba Func_16425
	callba Func_30253
	ret

Func_31281: ; 0x31282
	ld a, [wd4e2]
	inc a
	cp $6
	jr c, .asm_3129e
	ld a, $ff
	ld [wd4e3], a
	ld [wd4e4], a
	ld [wd4e5], a
	ld [wd4e6], a
	ld [wd4e7], a
	ld [wd4e8], a
	xor a
.asm_3129e
	ld [wd4e2], a
	cp $3
	jr c, .asm_312b2
	cp $5
	jr c, .asm_312e7
	ld a, INDIGO_PLATEAU
	ld [wCurrentMap], a
	ld [wd4e8], a
	ret

.asm_312b2
	call GenRandom
	and $7
	cp $7
	jr nc, .asm_312b2
	ld c, a
	ld b, $0
	ld hl, Data_31319
	add hl, bc
	ld c, [hl]
	ld hl, wd4e3
	ld a, [wd4e2]
	and a
	jr z, .asm_312d4
	ld b, a
.asm_312cd
	ld a, [hli]
	cp c
	jr z, .asm_312b2
	dec b
	jr nz, .asm_312cd
.asm_312d4
	ld a, c
	ld [wCurrentMap], a
	ld a, [wd4e2]
	ld c, a
	ld b, $0
	ld hl, wd4e3
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

.asm_312e7
	call GenRandom
	and $3
	ld c, a
	ld b, $0
	ld hl, Data_31320
	add hl, bc
	ld c, [hl]
	ld hl, wd4e6
	ld a, [wd4e2]
	sub $3
	jr z, .asm_31306
	ld b, a
.asm_312ff
	ld a, [hli]
	cp c
	jr z, .asm_312e7
	dec b
	jr nz, .asm_312ff
.asm_31306
	ld a, c
	ld [wCurrentMap], a
	ld a, [wd4e2]
	ld c, a
	ld b, $0
	ld hl, wd4e3
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

Data_31319:
	dr $31319, $31320

Data_31320:
	dr $31320, $31324

Func_31324: ; 0x31324
	ret

Func_31325: ; 0x31325
	ret

Func_31326: ; 0x31326
	ld a, [wd55a]
	and a
	jr nz, .asm_3134c
	ld a, $80
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	ld a, $3
	callba Func_1de4b
	jr .asm_31382

.asm_3134c
	ld a, $80
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 4], a
	ld a, $1
	callba Func_1de4b
	ld a, $6
	callba Func_1de4b
	ld a, $7
	callba Func_1de6f
.asm_31382
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_3139d
	ld a, $54
	ld [wc7e3], a
	ld a, $55
	ld [wc803], a
	ld a, $52
	ld [wc7f0], a
	ld a, $53
	ld [wc810], a
.asm_3139d
	ld a, $1
	ld [wd644], a
	callba Func_1f2ed
	ld de, $0003
	call PlaySong
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	ret

Func_313c3: ; 0x313c3
	callba Func_107a5
	callba Func_107c2
	callba Func_1f2ff
	ld a, $0
	ld [wd644], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	callba Func_1e8f6
	callba Func_30253
	ret

Func_3140b: ; 0x3140b
	ld a, [wd4e2]
	inc a
	cp $6
	jr c, .asm_31428
	ld a, $ff
	ld [wd4e3], a
	ld [wd4e4], a
	ld [wd4e5], a
	ld [wd4e6], a
	ld [wd4e7], a
	ld [wd4e8], a
	xor a
.asm_31428
	ld [wd4e2], a
	cp $3
	jr c, .asm_3143c
	cp $5
	jr c, .asm_31471
	ld a, INDIGO_PLATEAU
	ld [wCurrentMap], a
	ld [wd4e8], a
	ret

.asm_3143c
	call GenRandom
	and $7
	cp $7
	jr nc, .asm_3143c
	ld c, a
	ld b, $0
	ld hl, Data_314a3
	add hl, bc
	ld c, [hl]
	ld hl, wd4e3
	ld a, [wd4e2]
	and a
	jr z, .asm_3145e
	ld b, a
.asm_31457
	ld a, [hli]
	cp c
	jr z, .asm_3143c
	dec b
	jr nz, .asm_31457
.asm_3145e
	ld a, c
	ld [wCurrentMap], a
	ld a, [wd4e2]
	ld c, a
	ld b, $0
	ld hl, wd4e3
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

.asm_31471
	call GenRandom
	and $3
	ld c, a
	ld b, $0
	ld hl, Data_314aa
	add hl, bc
	ld c, [hl]
	ld hl, wd4e6
	ld a, [wd4e2]
	sub $3
	jr z, .asm_31490
	ld b, a
.asm_31489
	ld a, [hli]
	cp c
	jr z, .asm_31471
	dec b
	jr nz, .asm_31489
.asm_31490
	ld a, c
	ld [wCurrentMap], a
	ld a, [wd4e2]
	ld c, a
	ld b, $0
	ld hl, wd4e3
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

Data_314a3:
	dr $314a3, $314aa

Data_314aa:
	dr $314aa, $314ae

Func_314ae: ; 0x314ae
	ld a, [wd57d]
	and a
	ld a, [wd54c]
	jr z, .asm_314d0
	cp $1
	jp z, Func_31591
	cp $3
	jp z, Func_31591
	cp $2
	jp z, Func_315b3
	cp $5
	jp z, Func_315b3
	cp $d
	jp z, Func_315d5
.asm_314d0
	cp $0
	jr z, .asm_314d6
	scf
	ret

.asm_314d6
	call Func_3151f
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_314df: ; 0xd13df
	padded_dab Func_314ef
	padded_dab Func_314f1
	padded_dab Func_314f3
	padded_dab Func_31505

Func_314ef: ; 0x314ef
	scf
	ret

Func_314f1: ; 0x314f1
	scf
	ret

Func_314f3: ; 0x314f3
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

Func_31505: ; 0x31505
	ld a, [wd5ca]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

Func_3151f: ; 0x3151f
	ld a, $50
	ld [wd4ef], a
	ld [wd4f1], a
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $3
	ld [wd54d], a
	xor a
	ld [wd604], a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_31577
	callba Func_14135
	callba Func_16425
	callba Func_30253
.asm_31577
	callba Func_86d2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, MapMoveFailedText
	call LoadTextHeader
	ret

Func_31591: ; 0x31591
	ld a, [wd55a]
	and a
	jr nz, .asm_315b1
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_315b1
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wd604], a
	ld [wd54d], a
.asm_315b1
	scf
	ret

Func_315b3: ; 0x315b3
	ld a, [wd55a]
	and a
	jr z, .asm_315d3
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_315d3
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wd604], a
	ld [wd54d], a
.asm_315d3
	scf
	ret

Func_315d5: ; 0x315d5
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	callba Func_31281
	callba Func_30253
	lb de, $25, $25
	call PlaySoundEffect
	ld bc, ArrivedAtMapText
	callba Func_3118f
.asm_31603
	callba Func_33e3
	rst AdvanceFrame
	ld a, [wd5ca]
	and a
	jr nz, .asm_31603
	ld a, $2
	ld [wd54d], a
	scf
	ret

Func_3161b: ; 0x3161b
	ld a, [wd57d]
	and a
	ld a, [wd54c]
	jr z, .asm_3163d
	cp $1
	jp z, Func_31708
	cp $f
	jp z, Func_31708
	cp $2
	jp z, Func_3172a
	cp $e
	jp z, Func_3172a
	cp $d
	jp z, Func_3174c
.asm_3163d
	cp $0
	jr z, .asm_31643
	scf
	ret

.asm_31643
	call Func_3168c
	ld a, [wd54d]
	call CallInFollowingTable
PointerTable_3164c: ; 0x3164c
	padded_dab Func_3165c
	padded_dab Func_3165e
	padded_dab Func_31660
	padded_dab Func_31672

Func_3165c: ; 0x3165c
	scf
	ret

Func_3165e: ; 0x3165e
	scf
	ret

Func_31660: ; 0x31660
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

Func_31672: ; 0x31672
	ld a, [wd5ca]
	and a
	ret nz
	call FillBottomMessageBufferWithBlackTile
	callba Func_3022b
	ld de, $0001
	call PlaySong
	scf
	ret

Func_3168c: ; 0x3168c
	ld a, $50
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld [wRightMapMoveDiglettFrame], a
	ld a, $3
	ld [wd645], a
	ld a, $1
	ld [wd646], a
	callba Func_107f8
	ld a, [wd57e]
	and a
	ret z
	xor a
	ld [wd57e], a
	ld a, $3
	ld [wd54d], a
	xor a
	ld [wd604], a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 2], a
	ld [wIndicatorStates + 3], a
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	jr z, .asm_316ee
	callba Func_1c2cb
	callba Func_1e8f6
	callba Func_30253
.asm_316ee
	callba Func_86d2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, MapMoveFailedText
	call LoadTextHeader
	ret

Func_31708: ; 0x31708
	ld a, [wd55a]
	and a
	jr nz, .asm_31728
	ld a, [wIndicatorStates]
	and a
	jr z, .asm_31728
	xor a
	ld [wIndicatorStates], a
	ld [wIndicatorStates + 2], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wd604], a
	ld [wd54d], a
.asm_31728
	scf
	ret

Func_3172a: ; 0x3172a
	ld a, [wd55a]
	and a
	jr z, .asm_3174a
	ld a, [wIndicatorStates + 1]
	and a
	jr z, .asm_3174a
	xor a
	ld [wIndicatorStates + 1], a
	ld [wIndicatorStates + 3], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, $1
	ld [wd604], a
	ld [wd54d], a
.asm_3174a
	scf
	ret

Func_3174c: ; 0x3174c
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	callba Func_3140b
	callba Func_30253
	lb de, $25, $25
	call PlaySoundEffect
	ld bc, ArrivedAtMapText
	callba Func_3118f
.asm_3177a
	callba Func_33e3
	rst AdvanceFrame
	ld a, [wd5ca]
	and a
	jr nz, .asm_3177a
	ld a, $2
	ld [wd54d], a
	scf
	ret

SECTION "bankd", ROMX, BANK[$d]

SlotOnPic: ; 0x34000
	INCBIN "gfx/billboard/slot/slot_on.2bpp"
SlotOffPic: ; 0x34180
	INCBIN "gfx/billboard/slot/slot_off.2bpp"

SECTION "bankd.2", ROMX [$7f00], BANK[$d]

StageSeelBonusCollisionMasks: ; 0x37f00
	INCBIN "data/collision/masks/seel_bonus.masks"

SECTION "banke", ROMX, BANK[$e]
Data_38000:
	db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Data_38010:
	db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Data_38020:
	db $51, $10, $00, $10, $00, $10, $00, $10, $00, $80, $00, $00, $00, $00, $00, $00

Data_38030:
	db $a9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dr $38040, $3809a ; 38040

Data_3809a:
	db $00, $00, $00
	db $40, $40, $40
	db $90, $90, $90
	db $e4, $e4, $e4

Data_380a6:
	db $59, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dr $380b6, $38156 ; 380b6

Data_38156:
	db $99, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dr $38166, $39166

Data_39166:
	db $99, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dr $39176, $3a176 ; 39176

Data_3a176:
	db $a1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	dr $3a186, $3a9e6 ; 3a186

Data_3a9e6:
	db $79, $5d, $08, $00, $0b, $8c, $d0, $f4, $60, $00, $00, $00, $00, $00, $00, $00
Data_3a9f6:
	db $79, $52, $08, $00, $0b, $a9, $e7, $9f, $01, $c0, $7e, $e8, $e8, $e8, $e8, $e0
Data_3aa06:
	db $79, $47, $08, $00, $0b, $c4, $d0, $16, $a5, $cb, $c9, $05, $d0, $10, $a2, $28
Data_3aa16:
	db $79, $3c, $08, $00, $0b, $f0, $12, $a5, $c9, $c9, $c8, $d0, $1c, $a5, $ca, $c9
Data_3aa26:
	db $79, $31, $08, $00, $0b, $0c, $a5, $ca, $c9, $7e, $d0, $06, $a5, $cb, $c9, $7e
Data_3aa36:
	db $79, $26, $08, $00, $0b, $39, $cd, $48, $0c, $d0, $34, $a5, $c9, $c9, $80, $d0
Data_3aa46:
	db $79, $1b, $08, $00, $0b, $ea, $ea, $ea, $ea, $ea, $a9, $01, $cd, $4f, $0c, $d0
Data_3aa56:
	db $79, $10, $08, $00, $0b, $4c, $20, $08, $ea, $ea, $ea, $ea, $ea, $60, $ea, $ea
Data_3aa66:
	db $b9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
Data_3aa76:
	db $b9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

SECTION "bankf", ROMX, BANK[$f]

INCLUDE "audio/engine_0f.asm"

SECTION "bank10", ROMX, BANK[$10]

INCLUDE "audio/engine_10.asm"

SECTION "bank11", ROMX, BANK[$11]

INCLUDE "audio/engine_11.asm"

SECTION "bank12", ROMX, BANK[$12]

INCLUDE "audio/engine_12.asm"

SECTION "bank13", ROMX, BANK[$13]

INCLUDE "audio/engine_13.asm"

SECTION "bank14", ROMX, BANK[$14]

INCLUDE "audio/pikapcm.asm"

; bank $15 is blank

SECTION "bank16", ROMX, BANK[$16]

INCLUDE "data/billboard/billboard_pics.asm"
INCLUDE "data/mon_gfx/mon_billboard_palettes_1.asm"

SECTION "bank17", ROMX, BANK[$17]

INCLUDE "data/billboard/reward_pics.asm"

MeowthBonusBaseGameBoyGfx: ; 0x5f600
	INCBIN "gfx/stage/meowth_bonus/meowth_bonus_base_gameboy.2bpp"

SECTION "bank18", ROMX, BANK[$18]

INCLUDE "data/mon_gfx/mon_billboard_pics_1.asm"

StageRedFieldTopStatusBarSymbolsGfx_GameBoy: ; 0x63000
	INCBIN "gfx/stage/red_top/status_bar_symbols_gameboy.2bpp"
	
	INCBIN "gfx/unused_pocket_monster.2bpp"
	ds $20 ; free space

StageRedFieldTopBaseGameBoyGfx: ; 0x632a0
	INCBIN "gfx/stage/red_top/red_top_base_gameboy.2bpp"

SECTION "bank19", ROMX, BANK[$19]

INCLUDE "data/mon_gfx/mon_billboard_pics_2.asm"

StageBlueFieldBottomBaseGameBoyGfx: ; 0x67000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_base_gameboy.2bpp"

SECTION "bank1a", ROMX, BANK[$1a]

INCLUDE "data/mon_gfx/mon_billboard_pics_3.asm"

StageBlueFieldTopStatusBarSymbolsGfx_GameBoy: ; 0x6b000
	INCBIN "gfx/stage/blue_top/status_bar_symbols_gameboy.2bpp"
	
	INCBIN "gfx/unused_pocket_monster.2bpp"
	ds $20 ; free space

StageBlueFieldTopBaseGameBoyGfx: ; 0x6b2a0
	INCBIN "gfx/stage/blue_top/blue_top_base_gameboy.2bpp"

SECTION "bank1b", ROMX, BANK[$1b]

INCLUDE "data/mon_gfx/mon_billboard_pics_4.asm"

UnusedStageGfx: ; 0x6f000
	INCBIN "gfx/stage/unused_stage.2bpp"

SECTION "bank1c", ROMX, BANK[$1c]

INCLUDE "data/mon_gfx/mon_billboard_pics_5.asm"

UncaughtPokemonBackgroundPic:
	INCBIN "gfx/pokedex/uncaught_pokemon.2bpp"
	INCBIN "gfx/pokedex/uncaught_pokemon.2bpp" ; This pic is unnecessarily duplicated.

	ds $1800 ; free space

GengarBonusBaseGameBoyGfx: ; 0x73000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_base_gameboy.2bpp"

SECTION "bank1d", ROMX, BANK[$1d]

INCLUDE "data/mon_gfx/mon_billboard_pics_6.asm"

StageRedFieldBottomBaseGameBoyGfx: ; 0x77000
	INCBIN  "gfx/stage/red_bottom/red_bottom_base_gameboy.2bpp"

SECTION "bank1e", ROMX, BANK[$1e]

INCLUDE "data/mon_gfx/mon_billboard_pics_7.asm"

INCLUDE "data/billboard/bonus_multiplier_pics.asm"

INCLUDE "data/mon_gfx/mon_billboard_palettes_2.asm"

SECTION "bank1f", ROMX, BANK[$1f]

INCLUDE "data/mon_gfx/mon_animated_pics_1.asm"

MewtwoBonusBaseGameBoyGfx: ; 0x7f000
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_bonus_base_gameboy.2bpp"

EraseAllDataGfx: ; 0x7fd00: ; 0x7fd00
	INCBIN "gfx/erase_all_data.2bpp"

SECTION "bank20", ROMX, BANK[$20]

INCLUDE "data/mon_gfx/mon_animated_pics_2.asm"

MewtwoBonusBaseGameBoyColorGfx: ; 0x83000
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_bonus_base_gameboycolor.2bpp"

StageDiglettBonusCollisionMasks: ; 0x83d00
	INCBIN "data/collision/masks/diglett_bonus.masks"

SECTION "bank21", ROMX, BANK[$21]

INCLUDE "data/mon_gfx/mon_animated_pics_3.asm"

	ds $300 ; free space

DiglettBonusBaseGameBoyColorGfx: ; 0x87000
	INCBIN "gfx/stage/diglett_bonus/diglett_bonus_base_gameboycolor.2bpp"

GengarBonusHaunterGfx: ; 0x87d00
	INCBIN "gfx/stage/gengar_bonus/haunter.interleave.2bpp"

SECTION "bank22", ROMX, BANK[$22]

INCLUDE "data/mon_gfx/mon_animated_pics_4.asm"

FieldSelectScreenGfx:
FieldSelectBlinkingBorderGfx: ; 0x8b000
	INCBIN "gfx/field_select/blinking_border.2bpp"
FieldSelectGfx: ; 0x8b100
	INCBIN "gfx/field_select/field_select_tiles.2bpp"

GengarBonusGastlyGfx: ; 0x8bd00
	INCBIN "gfx/stage/gengar_bonus/gastly.w32.interleave.2bpp"
	dr $8be80, $8bf00

INCLUDE "data/mon_gfx/mon_billboard_palettes_3.asm"

SECTION "bank23", ROMX, BANK[$23]

INCLUDE "data/mon_gfx/mon_animated_pics_5.asm"

DiglettBonusBaseGameBoyGfx: ; 0x8f000
	INCBIN "gfx/stage/diglett_bonus/diglett_bonus_base_gameboy.2bpp"

INCLUDE "gfx/high_scores/high_scores_transition_palettes.asm"
INCLUDE "data/billboard/map_palettes.asm"

SECTION "bank24", ROMX, BANK[$24]

INCLUDE "data/mon_gfx/mon_billboard_pics_8.asm"

SeelBonusBaseGameBoyGfx: ; 0x93000
	INCBIN "gfx/stage/seel_bonus/seel_bonus_base_gameboy.2bpp"

INCLUDE "data/billboard/map_palette_maps_2.asm"

	dr $93c39, $94000

SECTION "bank25", ROMX, BANK[$25]

INCLUDE "data/mon_gfx/mon_billboard_pics_9.asm"

SeelBonusBaseGameBoyColorGfx: ; 0x97000
	INCBIN "gfx/stage/seel_bonus/seel_bonus_base_gameboycolor.2bpp"

StageRedFieldTopGfx3: ; 0x97a00
	INCBIN "gfx/stage/red_top/red_top_3.2bpp"
StageRedFieldTopGfx1: ; 0x97ba0
	INCBIN "gfx/stage/red_top/red_top_1.2bpp"
StageRedFieldTopGfx2: ; 0x97e00
	INCBIN "gfx/stage/red_top/red_top_2.2bpp"

SECTION "bank26", ROMX, BANK[$26]

INCLUDE "data/mon_gfx/mon_billboard_pics_10.asm"

SeelBonusSeel3Gfx: ; 0x9b000
	INCBIN "gfx/stage/seel_bonus/seel_3.2bpp"
SeelBonusSeel1Gfx: ; 0x9b1a0
	INCBIN "gfx/stage/seel_bonus/seel_1.2bpp"
SeelBonusSeel2Gfx: ; 0x9b400
	INCBIN "gfx/stage/seel_bonus/seel_2.2bpp"
SeelBonusSeel4Gfx: ; 0x9b460
	INCBIN "gfx/stage/seel_bonus/seel_4.2bpp"
	dr $9b900, $9bba0

GengarBonusGengar1Gfx: ; 0x9bba0
	INCBIN "gfx/stage/gengar_bonus/gengar_1.2bpp"
GengarBonusGengar2Gfx: ; 0x9bd00
	INCBIN "gfx/stage/gengar_bonus/gengar_2.2bpp"
GengarBonusGengar3Gfx: ; 0x9bd60
	INCBIN "gfx/stage/gengar_bonus/gengar_3.2bpp"

SECTION "bank27", ROMX, BANK[$27]

StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor: ; 0x9c000
	INCBIN "gfx/stage/red_top/status_bar_symbols_gameboycolor.2bpp"
	dr $9c100, $9c2a0

StageRedFieldTopBaseGameBoyColorGfx: ; 0x9c2a0
	INCBIN "gfx/stage/red_top/red_top_base_gameboycolor.2bpp"

StageRedFieldTopGfx4: ; 0x9d000
	INCBIN "gfx/stage/red_top/red_top_4.2bpp"

GengarBonusBaseGameBoyColorGfx: ; 0x9e000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_base_gameboycolor.2bpp"
GengarBonus1Gfx: ; 0x9f000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_1.2bpp"

SECTION "bank28", ROMX, BANK[$28]

StageBlueFieldTopStatusBarSymbolsGfx_GameBoyColor: ; 0xa0000
	INCBIN "gfx/stage/blue_top/status_bar_symbols_gameboycolor.2bpp"
	dr $a0100, $a02a0

StageBlueFieldTopBaseGameBoyColorGfx: ; 0xa02a0
	INCBIN "gfx/stage/blue_top/blue_top_base_gameboycolor.2bpp"

StageBlueFieldTopGfx4: ; 0xa1000
	INCBIN "gfx/stage/blue_top/blue_top_4.2bpp"

StageRedFieldBottomBaseGameBoyColorGfx: ; 0xa2000
	INCBIN "gfx/stage/red_bottom/red_bottom_base_gameboycolor.2bpp"

StageRedFieldBottomGfx5: ; 0xa3000
	INCBIN "gfx/stage/red_bottom/red_bottom_5.2bpp"

SECTION "bank29", ROMX, BANK[$29]

StageBlueFieldBottomBaseGameBoyColorGfx: ; 0xa4000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_base_gameboycolor.2bpp"
StageBlueFieldBottomGfx1: ; 0xa5000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_1.2bpp"

INCLUDE "data/billboard/map_pics.asm"

GFX_a7b00:
	dr $a7b00, $a8000 ; 0xa7b00

SECTION "bank2a", ROMX, BANK[$2a]
	dr $a8000, $a82c0

PinballGreatballShakeGfx: ; 0xa82c0
	INCBIN "gfx/stage/ball_greatball_shake.w16.interleave.2bpp"
PinballUltraballShakeGfx: ; 0xa8300
	INCBIN "gfx/stage/ball_ultraball_shake.w16.interleave.2bpp"
PinballMasterballShakeGfx: ; 0xa8340
	INCBIN "gfx/stage/ball_masterball_shake.w16.interleave.2bpp"
PinballPokeballShakeGfx: ; 0xa8380
	INCBIN "gfx/stage/ball_pokeball_shake.w16.interleave.2bpp"

StageSharedPikaBoltGfx: ; 0xa83c0
	INCBIN "gfx/stage/shared/pika_bolt.2bpp"

PinballPokeballGfx: ; 0xa8400
	INCBIN "gfx/stage/ball_pokeball.w32.interleave.2bpp"

FlipperGfx: ; 0xa8600
	INCBIN "gfx/stage/flipper.2bpp"

PikachuSaverGfx: ; 0xa8720
	INCBIN "gfx/stage/pikachu_saver.2bpp"

GFX_a8800:
	INCBIN "gfx/unknown/a8800.interleave.w32.2bpp"
	dr $a8980, $a8a00

PinballGreatballGfx: ; 0xa8a00
	INCBIN "gfx/stage/ball_greatball.w32.interleave.2bpp"
PinballUltraballGfx: ; 0xa8c00
	INCBIN "gfx/stage/ball_ultraball.w32.interleave.2bpp"
PinballMasterballGfx: ; 0xa8e00
	INCBIN "gfx/stage/ball_masterball.w32.interleave.2bpp"

PinballPokeballMiniGfx: ; 0xa9000
	INCBIN "gfx/stage/ball_pokeball_mini.w32.interleave.2bpp"
PinballGreatballMiniGfx: ; 0xa9200
	INCBIN "gfx/stage/ball_greatball_mini.w32.interleave.2bpp"
PinballUltraballMiniGfx: ; 0xa9400
	INCBIN "gfx/stage/ball_ultraball_mini.w32.interleave.2bpp"
PinballMasterballMiniGfx: ; 0xa9600
	INCBIN "gfx/stage/ball_masterball_mini.w32.interleave.2bpp"
PinballBallMiniGfx: ; 0xa9800
	INCBIN "gfx/stage/ball_mini.w32.interleave.2bpp"

HighScoresBaseGameBoyGfx: ; 0xa9a00
	INCBIN "gfx/high_scores/high_scores_base_gameboy.2bpp"

MeowthBonusBaseGameBoyColorGfx: ; 0xab200
	INCBIN "gfx/stage/meowth_bonus/meowth_bonus_base_gameboycolor.2bpp"

INCLUDE "data/billboard/map_palette_maps.asm"

	dr $abc80, $abf00

INCLUDE "data/mon_gfx/mon_animated_palettes_1.asm"

SECTION "bank2b", ROMX, BANK[$2b]

TitlescreenFadeInGfx: ; 0xac000
	INCBIN "gfx/titlescreen/titlescreen_fade_in.2bpp"

Data_ad800:
	dr $ad800, $af000

StageBlueFieldBottomCollisionMasks: ; 0xaf000
	INCBIN "data/collision/masks/blue_stage_bottom.masks"
	dr $af800, $af900

DiglettBonusDugtrio3Gfx: ; 0xaf900
	INCBIN "gfx/stage/diglett_bonus/dugtrio_3.2bpp"
DiglettBonusDugtrio1Gfx: ; 0xafaa0
	INCBIN "gfx/stage/diglett_bonus/dugtrio_1.2bpp"
DiglettBonusDugtrio2Gfx: ; 0xafd00
	INCBIN "gfx/stage/diglett_bonus/dugtrio_2.2bpp"
DiglettBonusDugtrio4Gfx: ; 0xafd60
	INCBIN "gfx/stage/diglett_bonus/dugtrio_4.2bpp"

SECTION "bank2c", ROMX, BANK[$2c]
	dr $b0000, $b3000

StageRedFieldTopCollisionAttributes6: ; 0xb3000
	INCBIN "data/collision/maps/red_stage_top_6.collision"
	dr $b3400, $b3800

FieldSelectTilemap: ; 0xb3800
	INCBIN "gfx/tilemaps/field_select.map"
FieldSelectBGAttributes: ; 0xb3c00
	INCBIN "gfx/bgattr/field_select.bgattr"

SECTION "bank2d", ROMX, BANK[$2d]

TitlescreenGfx: ; 0xb4000
	INCBIN "gfx/titlescreen/titlescreen.2bpp"

OptionMenuAndKeyConfigGfx:
OptionMenuBlankGfx: ; 0xb5800
	INCBIN "gfx/option_menu/blank.2bpp"
OptionMenuArrowGfx: ; 0xb5a00
	INCBIN "gfx/option_menu/arrow.2bpp"
OptionMenuPikaBubbleGfx: ; 0xb5a20
	INCBIN "gfx/option_menu/pika_bubble.2bpp"
OptionMenuBouncingPokeballGfx: ; 0xb5a80
	INCBIN "gfx/option_menu/bouncing_pokeball.2bpp"
OptionMenuRumblePikachuAnimationGfx: ; 0xb5b40
	INCBIN "gfx/option_menu/rumble_pikachu_animation.2bpp"
OptionMenuPsyduckGfx: ; 0xb5c00
	INCBIN "gfx/option_menu/psyduck.2bpp"
OptionMenuBoldArrowGfx: ; 0xb5fc0
	INCBIN "gfx/option_menu/bold_arrow.2bpp"
OptionMenuUnknownGfx: ; 0xb5fd0
	INCBIN "gfx/option_menu/solid_colors.2bpp"
OptionMenuOptionTextGfx: ; 0xb6020
	INCBIN "gfx/option_menu/option_text.2bpp"
OptionMenuPikachuGfx: ; 0xb6080
	INCBIN "gfx/option_menu/pikachu.2bpp"
OptionMenuPsyduckFeetGfx: ; 0xb6170
	INCBIN "gfx/option_menu/psyduck_feet.2bpp"
OptionMenuUnknown2Gfx: ; 0xb6200
	INCBIN "gfx/option_menu/blank2.2bpp"
OptionMenuRumbleTextGfx: ; 0xb6250
	INCBIN "gfx/option_menu/rumble_text.2bpp"
OptionMenuUnknown3Gfx: ; 0xb62b0
	INCBIN "gfx/option_menu/blank3.2bpp"
OptionMenuKeyCoTextGfx: ; 0xb6320
	INCBIN "gfx/option_menu/key_co_text.2bpp"
OptionMenuSoundTestDigitsGfx: ; 0xb6370
	INCBIN "gfx/option_menu/sound_test_digits.2bpp"
OptionMenuNfigTextGfx: ; 0xb6470
	INCBIN "gfx/option_menu/nfig_text.2bpp"
OptionMenuUnknown4Gfx: ; 0xb64a0
	INCBIN "gfx/option_menu/blank4.2bpp"

KeyConfigResetTextGfx: ; 0xb6500
	INCBIN "gfx/key_config/reset_text.2bpp"
KeyConfigBallStartTextGfx: ; 0xb6560
	INCBIN "gfx/key_config/ball_start_text.2bpp"
KeyConfigLeftFlipperTextGfx: ; 0xb65f0
	INCBIN "gfx/key_config/left_flipper_text.2bpp"
KeyConfigRightFlipperTextGfx: ; 0xb6680
	INCBIN "gfx/key_config/right_flipper_text.2bpp"
KeyConfigTiltTextGfx: ; 0xb6710
	INCBIN "gfx/key_config/tilt_text.2bpp"
KeyConfigMenuTextGfx: ; 0xb6810
	INCBIN "gfx/key_config/menu_text.2bpp"
KeyConfigKeyConfigTextGfx: ; 0xb6880
	INCBIN "gfx/key_config/key_config_text.2bpp"
KeyConfigIconsGfx: ; 0xb6900
	INCBIN "gfx/key_config/icons.2bpp"

OptionMenuSoundTextTextGfx: ; 0xb6a40
	INCBIN "gfx/option_menu/sound_test_text.2bpp"
OptionMenuOnOffTextGfx: ; 0xb6ad0
	INCBIN "gfx/option_menu/on_off_text.2bpp"
OptionMenuBGMSETextGfx: ; 0xb6b10
	INCBIN "gfx/option_menu/bgm_se_text.2bpp"

StageRedFieldTopCollisionAttributes5: ; 0xb6c00
	INCBIN "data/collision/maps/red_stage_top_5.collision"
	dr $b7000, $b7400

StageRedFieldTopCollisionAttributes4: ; 0xb7400
	INCBIN "data/collision/maps/red_stage_top_4.collision"
	dr $b7800, $b7c00

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_5.asm"

SECTION "bank2e", ROMX, BANK[$2e]

StageRedFieldTopCollisionAttributes3: ; 0xb8000
	INCBIN "data/collision/maps/red_stage_top_3.collision"
	dr $b8400, $b8800

StageRedFieldTopCollisionAttributes2: ; 0xb8800
	INCBIN "data/collision/maps/red_stage_top_2.collision"
	dr $b8c00, $b9000

StageRedFieldTopCollisionAttributes1: ; 0xb9000
	INCBIN "data/collision/maps/red_stage_top_1.collision"
	dr $b9400, $b9800

StageRedFieldTopCollisionAttributes0: ; 0xb9800
	INCBIN "data/collision/maps/red_stage_top_0.collision"
	dr $b9c00, $ba000

StageRedFieldTopTilemap_GameBoy: ; 0xba000
	INCBIN "gfx/tilemaps/stage_red_field_top_gameboy.map"
	dr $ba400, $ba800

StageRedFieldBottomTilemap_GameBoy: ; 0xba800
	INCBIN "gfx/tilemaps/stage_red_field_bottom_gameboy.map"
	dr $bac00, $bb000

StageRedFieldTopCollisionMasks0: ; 0xbb000
	INCBIN "data/collision/masks/red_stage_top_0.masks"

StageRedFieldTopCollisionMasks1: ; 0xbb800
	INCBIN "data/collision/masks/red_stage_top_1.masks"

SECTION "bank2f", ROMX, BANK[$2f]

StageRedFieldTopCollisionMasks2: ; 0xbc000
	INCBIN "data/collision/masks/red_stage_top_2.masks"

StageRedFieldTopCollisionMasks3: ; 0xbc800
	INCBIN "data/collision/masks/red_stage_top_3.masks"

StageRedFieldTopCollisionAttributes7: ; 0xbd000
	INCBIN "data/collision/maps/red_stage_top_7.collision"
	dr $bd400, $bd800

StageRedFieldBottomCollisionAttributes: ; 0xbd800
	INCBIN "data/collision/maps/red_stage_bottom.collision"
	dr $bdc00, $be000

StageRedFieldTopTilemap_GameBoyColor: ; 0xbe000
	INCBIN "gfx/tilemaps/stage_red_field_top_gameboycolor.map"

StageRedFieldTopTilemap2_GameBoyColor: ; 0xbe400
	INCBIN "gfx/tilemaps/stage_red_field_top_gameboycolor_2.map"

StageRedFieldBottomTilemap_GameBoyColor: ; 0xbe800
	INCBIN "gfx/tilemaps/stage_red_field_bottom_gameboycolor.map"

StageRedFieldBottomTilemap2_GameBoyColor: ; 0xbec00
	INCBIN "gfx/tilemaps/stage_red_field_bottom_gameboycolor_2.map"

StageBlueFieldTopTilemap_GameBoy: ; 0xbf000
	INCBIN "gfx/tilemaps/stage_blue_field_top_gameboy.map"
	dr $bf400, $bf800

EraseAllDataTilemap: ; 0xbf800
	INCBIN "gfx/tilemaps/erase_all_data.map"
EraseAllDataBGAttributes: ; 0xbfc00
	INCBIN "gfx/bgattr/erase_all_data.bgattr"

SECTION "bank30", ROMX, BANK[$30]

StageBlueFieldBottomTilemap_GameBoy: ; 0xc0000
	INCBIN "gfx/tilemaps/stage_blue_field_bottom_gameboy.map"
	dr $c0400, $c0800

StageBlueFieldTopCollisionMasks: ; 0xc0800
	INCBIN "data/collision/masks/blue_stage_top.masks"

StageBlueFieldTopCollisionAttributesBallEntrance: ; 0xc1000
	INCBIN "data/collision/maps/blue_stage_top_ball_entrance.collision"
	dr $c1400, $c1800

HighScoresTilemap2: ; 0xc1800
	INCBIN "gfx/tilemaps/high_scores_screen_2.map"
HighScoresTilemap5: ; 0xc1c00
	INCBIN "gfx/tilemaps/high_scores_screen_5.map"
HighScoresTilemap: ; 0xc2000
	INCBIN "gfx/tilemaps/high_scores_screen.map"
HighScoresTilemap4: ; 0xc2400
	INCBIN "gfx/tilemaps/high_scores_screen_4.map"

StageBlueFieldTopCollisionAttributes: ; 0xc2800
	INCBIN "data/collision/maps/blue_stage_top.collision"
	dr $c2c00, $c3000

OptionMenuTilemap2: ; 0xc3000
	INCBIN "gfx/tilemaps/option_menu_2.map"
	dr $c3240, $c3400

OptionMenuTilemap4: ; 0xc3400
	INCBIN "gfx/tilemaps/option_menu_4.map"
	dr $c3640, $c3800

OptionMenuTilemap: ; 0xc3800
	INCBIN "gfx/tilemaps/option_menu.map"
	dr $c3a40, $c3c00

OptionMenuTilemap3: ; 0xc3c00
	INCBIN "gfx/tilemaps/option_menu_3.map"
	dr $c3e40, $c4000

SECTION "bank31", ROMX, BANK[$31]

StageBlueFieldBottomCollisionAttributes: ; 0xc4000
	INCBIN "data/collision/maps/blue_stage_bottom.collision"
	dr $c4400, $c4800

Data_c4800:
	dr $c4800, $c4c00

Data_c4c00:
	dr $c4c00, $c5000

Data_c5000:
	dr $c5000, $c5100

Data_c5100:
	dr $c5100, $c5120

Data_c5120:
	dr $c5120, $c5400

Data_c5400:
	dr $c5400, $c5800

TitlescreenTilemap: ; 0xc5800
	INCBIN "gfx/tilemaps/titlescreen.map"
TitlescreenBGAttributes: ; 0xc5c00
	INCBIN "gfx/bgattr/titlescreen.bgattr"

	ds $1c0 ; free space

CopyrightScreenTilemap: ; 0xc6000
	INCBIN "gfx/tilemaps/copyright_screen.map"
CopyrightScreenBGAttributes: ; 0xc6400
	INCBIN "gfx/bgattr/copyright_screen.bgattr"

StageBlueFieldTopTilemap_GameBoyColor: ; 0xc6800
	INCBIN "gfx/tilemaps/stage_blue_field_top_gameboycolor.map"
StageBlueFieldTopTilemap2_GameBoyColor: ; 0xc6c00
	INCBIN "gfx/tilemaps/stage_blue_field_top_gameboycolor_2.map"

StageBlueFieldBottomTilemap_GameBoyColor: ; 0xc7000
	INCBIN "gfx/tilemaps/stage_blue_field_bottom_gameboycolor.map"
StageBlueFieldBottomTilemap2_GameBoyColor: ; 0xc7400
	INCBIN "gfx/tilemaps/stage_blue_field_bottom_gameboycolor_2.map"

StageGengarBonusCollisionAttributesBallEntrance: ; 0xc7800
	INCBIN "data/collision/maps/gengar_bonus_ball_entrance.collision"

SECTION "bank32", ROMX, BANK[$32]

StageGengarBonusCollisionAttributes: ; 0xc8000
	INCBIN "data/collision/maps/gengar_bonus.collision"

	ds $400 ; free space

GengarBonusTilemap_GameBoy: ; 0xc8800
	INCBIN "gfx/tilemaps/stage_gengar_bonus_gameboy.map"

	ds $400 ; free space

GengarBonusBottomTilemap_GameBoyColor: ; 0xc9000
	INCBIN "gfx/tilemaps/stage_gengar_bonus_gameboycolor.map"
GengarBonusBottomTilemap2_GameBoyColor: ; 0xc9400
	INCBIN "gfx/tilemaps/stage_gengar_bonus_gameboycolor_2.map"

MewtwoBonus3Gfx: ; 0xc9800
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_3.2bpp"
MewtwoBonus1Gfx: ; 0xc99a0
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_1.2bpp"
MewtwoBonus2Gfx: ; 0xc9c00
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_2.2bpp"
MewtwoBonus4Gfx: ; 0xc9c60
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_4.2bpp"

	ds $100 ; free space

StageMewtwoBonusCollisionAttributesBallEntrance: ; 0xca000
	INCBIN "data/collision/maps/mewtwo_bonus_ball_entrance.collision"

	ds $400 ; free space

StageMewtwoBonusCollisionAttributes: ; 0xca800
	INCBIN "data/collision/maps/mewtwo_bonus.collision"

	ds $400 ; free space

MewtwoBonusTilemap_GameBoy: ; 0xcb000
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboy.map"

	ds $400 ; free space

MewtoBonusBottomTilemap_GameBoyColor: ; 0xcb800
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboycolor.map"
MewtoBonusBottomTilemap2_GameBoyColor: ; 0xcbc00
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboycolor_2.map"

SECTION "bank33", ROMX, BANK[$33]

MeowthBonusMeowth3Gfx: ; 0xcc000
	INCBIN "gfx/stage/meowth_bonus/meowth_3.2bpp"
MeowthBonusMeowth1Gfx: ; 0xcc1a0
	INCBIN "gfx/stage/meowth_bonus/meowth_1.2bpp"
MeowthBonusMeowth2Gfx: ; 0xcc400
	INCBIN "gfx/stage/meowth_bonus/meowth_2.2bpp"
MeowthBonusMeowth4Gfx: ; 0xcc460
	INCBIN "gfx/stage/meowth_bonus/meowth_4.2bpp"

	ds $40 ; free space

StageMeowthBonusCollisionAttributesBallEntrance: ; 0xcc800
	INCBIN "data/collision/maps/meowth_bonus_ball_entrance.collision"

	ds $400 ; free space

StageMeowthBonusCollisionAttributes: ; 0xcd000
	INCBIN "data/collision/maps/meowth_bonus.collision"

	ds $400 ; free space

MeowthBonusTilemap_GameBoy: ; 0xcd800
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboy.map"

	ds $400 ; free space

MeowthBonusTilemap_GameBoyColor: ; 0xce000
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboycolor.map"
MeowthBonusTilemap2_GameBoyColor: ; 0xce400
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboycolor_2.map"

StageDiglettBonusCollisionAttributesBallEntrance: ; 0xce800
	INCBIN "data/collision/maps/diglett_bonus_ball_entrance.collision"

	ds $400 ; free space

StageDiglettBonusCollisionAttributes: ; 0xcf000
	INCBIN "data/collision/maps/diglett_bonus.collision"

	ds $400 ; free space

DiglettBonusTilemap_GameBoy: ; 0xcf800
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboy.map"

SECTION "bank34", ROMX, BANK[$34]

INCLUDE "data/collision/mon_collision_masks.asm"

	dr $d2800, $d3000

DiglettBonusTilemap_GameBoyColor: ; 0xd3000
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboycolor.map"
DiglettBonusTilemap2_GameBoyColor: ; 0xd3400
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboycolor_2.map"
	dr $d3800, $d4000

SECTION "bank35", ROMX, BANK[$35]

StageSeelBonusCollisionAttributesBallEntrance: ; 0xd4000
	INCBIN "data/collision/maps/seel_bonus_ball_entrance.collision"

	ds $400 ; free space

StageSeelBonusCollisionAttributes: ; 0xd4800
	INCBIN "data/collision/maps/seel_bonus.collision"

	ds $400 ; free space

SeelBonusTilemap_GameBoy: ; 0xd5000
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboy.map"

	ds $400 ; free space

SeelBonusTilemap_GameBoyColor: ; 0xd5800
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboycolor.map"
SeelBonusTilemap2_GameBoyColor: ; 0xd5c00
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboycolor_2.map"

Alphabet1Gfx: ; 0xd6000
	INCBIN "gfx/stage/alphabet_1.2bpp"

GFX_d61a0: INCBIN "gfx/unknown/d61a0.2bpp"
GFX_d61b0: INCBIN "gfx/unknown/d61b0.2bpp"
GFX_d61c0: INCBIN "gfx/stage/e_acute_mono.2bpp"
GFX_d61d0: INCBIN "gfx/unknown/d61d0.2bpp"
GFX_d61e0: INCBIN "gfx/unknown/d61e0.2bpp"
	dr $d61f0, $d6200

Alphabet2Gfx: ; 0xd6200
	INCBIN "gfx/stage/alphabet_2.2bpp"

GFX_d63a0: INCBIN "gfx/unknown/d63a0.2bpp"
GFX_d63b0: INCBIN "gfx/unknown/d63b0.2bpp"
GFX_d63c0: INCBIN "gfx/stage/e_acute_color.2bpp"
GFX_d63d0: INCBIN "gfx/unknown/d63d0.2bpp"
GFX_d63e0: INCBIN "gfx/unknown/d63e0.2bpp"

	dr $d63f0, $d6410

GFX_d6410: INCBIN "gfx/unknown/d6410.2bpp"

	dr $d6420, $d6430

GFX_d6430: INCBIN "gfx/unknown/d6430.2bpp"
GFX_d6440: INCBIN "gfx/unknown/d6440.2bpp"

InGameMenuSymbolsGfx: ; 0xd6450
	INCBIN "gfx/stage/menu_symbols.2bpp"
GFX_d6480: INCBIN "gfx/unknown/d6480.2bpp"

	ds $170 ; free space

StageBlueFieldTopGfx3: ; 0xd6600
	INCBIN "gfx/stage/blue_top/blue_top_3.2bpp"
StageBlueFieldTopGfx1: ; 0xd67a0
	INCBIN "gfx/stage/blue_top/blue_top_1.2bpp"
StageBlueFieldTopGfx2: ; 0xd6a00
	INCBIN "gfx/stage/blue_top/blue_top_2.2bpp"

StageRedJapaneseCharactersGfx: ; 0xd6c00
	INCBIN "gfx/stage/red_bottom/japanese_characters.2bpp"
StageRedJapaneseCharactersGfx2: ; 0xd7000
	INCBIN "gfx/stage/red_bottom/japanese_characters_2.2bpp"

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_1.asm"
INCLUDE "gfx/high_scores/high_scores_transition_palettes_2.asm"


SECTION "bank36", ROMX, BANK[$36]
	dr $d8000, $d8400

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_2.asm"

SaverTextOffGfx: ; 0xd8c00
	INCBIN "gfx/stage/saver_off.2bpp"
	dr $d8c40, $d8c80

CatchTextGfx:
	INCBIN "gfx/stage/catch.w48.2bpp"
	dr $d8ce0, $d8e80

Data_d8e80:
	dr $d8e80, $d8f60

Data_d8f60:
	dr $d8f60, $d9000

StageRedFieldBottomCollisionMasks: ; 0xd9000
	INCBIN "data/collision/masks/red_stage_bottom.masks"

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_3.asm"

UnusedTextGfx: ; 0xd9c00
	INCBIN "gfx/unused_text.2bpp"

CopyrightTextGfx: ; 0xda000
	INCBIN "gfx/copyright_text.2bpp"

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_4.asm"

StageSharedBonusSlotGlowGfx: ; 0xdac00
	INCBIN "gfx/stage/shared/bonus_slot_glow.2bpp"
	dr $dad60, $dade0

StageSharedBonusSlotGlow2Gfx: ; 0xdade0
	INCBIN "gfx/stage/shared/bonus_slot_glow_2.2bpp"

StageRedFieldTopGfx5: ; 0xdae00
	INCBIN "gfx/stage/red_top/red_top_5.2bpp"
	dr $db000, $db200

TimerDigitsGfx: ; 0xdb200
	INCBIN "gfx/stage/timer_digits.2bpp"
	dr $db360, $db600

StageGengarBonusCollisionMasks: ; 0xdb600
	INCBIN "data/collision/masks/gengar_bonus.masks"

INCLUDE "data/mon_gfx/mon_animated_palettes_2.asm"
INCLUDE "data/mon_gfx/mon_billboard_palettes_4.asm"

StageRedFieldTopGfx6: ; 0xdbb80
	INCBIN "gfx/stage/red_top/red_top_6.2bpp"
	dr $dbbc0, $dbc80

StageMewtwoBonusCollisionMasks: ; 0xdbc80
	INCBIN "data/collision/masks/mewtwo_bonus.masks"

INCLUDE "data/mon_gfx/mon_animated_palettes_3.asm"

Data_dbe80:
	dr $dbe80, $dc000

SECTION "bank37", ROMX, BANK[$37]

StageSharedArrowsGfx: ; 0xdc000
	INCBIN "gfx/stage/shared/arrows.2bpp"
	dr $dc080, $dc100

INCLUDE "data/mon_gfx/mon_billboard_palettes_5.asm"

StageMeowthBonusCollisionMasks: ; 0xdc600
	INCBIN "data/collision/masks/meowth_bonus.masks"

INCLUDE "data/mon_gfx/mon_billboard_palettes_6.asm"
INCLUDE "data/stage_palettes.asm"
INCLUDE "data/billboard/map_palettes_2.asm"

PokeBallObjPalette: ; 0xdd168
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 31,  5,  4
	RGB  0,  0,  0
GreatBallObjPalette: ; 0xdd170
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB  2,  8, 31
	RGB  0,  0,  0
UltraBallObjPalette: ; 0xdd178
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 27, 21,  0
	RGB  0,  0,  0
MasterBallObjPalette: ; 0xdd180
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 21,  3, 21
	RGB  0,  0,  0

Data_dd188:
	dr $dd188, $e0000

SECTION "bank38", ROMX, BANK[$38]
	dr $e0000, $e4000 ; 0xe0000

SECTION "bank39", ROMX, BANK[$39]
Data_e4000:
	dr $e4000, $e8000 ; 0xe4000

SECTION "bank3a", ROMX, BANK[$3a]

GengarCollisionAngles:
	INCBIN "data/collision/gengar_collision_angles.bin"

HaunterCollisionAngles:
	INCBIN "data/collision/haunter_collision_angles.bin"

CircularCollisionAngles: ; 0xe9100
	INCBIN "data/collision/circle_collision_angles.bin"

MeowthCollisionAngles:
	INCBIN "data/collision/meowth_collision_angles.bin"

MeowthJewelCollisionAngles:
	INCBIN "data/collision/meowth_jewel_collision_angles.bin"

SECTION "bank3b", ROMX, BANK[$3b]
Data_ec000:
	dr $ec000, $f0000 ; 0xec000

SECTION "bank3c", ROMX, BANK[$3c]
Data_f0000:
	dr $f0000, $f2400 ; 0xf0000

TiltRightOnlyForce: ; 0xf2400
	INCBIN "data/tilt/right_only"
TiltUpRightForce:
	INCBIN "data/tilt/up_right"
TiltUpOnlyForce:
	INCBIN "data/tilt/up_only"
TiltUpLeftForce:
	INCBIN "data/tilt/up_left"
TiltLeftOnlyForce:
	INCBIN "data/tilt/left_only"

SECTION "bank3d", ROMX, BANK[$3d]

FlipperHorizontalCollisionAttributes: ; 0xf4000
	INCBIN "data/collision/flippers/horizontal_attributes_0"

SECTION "bank3e", ROMX, BANK[$3e]

FlipperHorizontalCollisionAttributes2: ; 0xf8000
	INCBIN "data/collision/flippers/horizontal_attributes_1"

FlipperVerticalCollisionAttributes: ; 0xfa000
	INCBIN "data/collision/flippers/vertical_attributes_0"

SECTION "bank3f", ROMX, BANK[$3f]

FlipperVerticalCollisionAttributes2: ; 0xfc000
	INCBIN "data/collision/flippers/vertical_attributes_1"
