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
	ld [wd80c], a
	ld [wd80d], a
	ld [wd80e], a
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
	ld [wd80c], a
	xor a
	ld [wd80d], a
	ld [wd80e], a
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
	ld [wd80c], a
	xor a
	ld [wd80d], a
	ld [wd80e], a
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
	call Func_8461
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
	ld [wd7ab], a
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
	ld a, [wd5bb]
	and a
	jr z, .asm_8460
	callba Func_10464
.asm_8460
	ret

Func_8461: ; 0x8461
	ld a, [wd7c0]
	call SetSongBank
	ld a, [wd7bf]
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
	padded_dab Func_1805f
	padded_dab Func_18060
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

Data_8817: ; 0x8817
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

Data_8917: ; 0x8917
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

Data_8b17: ; 0x8b17
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

Func_8d17: ; 0x8d17
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
	ld [wd80c], a
	ld a, $d2
	ld [wd80d], a
	ld a, $e1
	ld [wd80e], a
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
	call Func_926
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
	ld [wd80c], a
	ld [wd80d], a
	ld a, $d2
	ld [wd80e], a
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
	call Func_926
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
	call Func_926
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
	ld [wd80c], a
	ld a, $e1
	ld [wd80d], a
	ld [wd80e], a
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
	call Func_926
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
	call Func_926
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
	call nz, Func_d626
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
	call nz, Func_d626
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

Func_d626: ; 0xd626
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
	ld hl, PointerTable_d65a
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

PointerTable_d65a: ; 0xd65a
	dwb $7D00, $23
	dwb $7D40, $23
	dwb $7D80, $23
	dwb $7DC0, $23
	dwb $7E00, $23
	dwb $7E40, $23
	dwb $7E80, $23
	dwb $7EC0, $23
	dwb $7E00, $35
	dwb $7E40, $35
	dwb $7E80, $35
	dwb $7EC0, $35
	dwb $7F00, $35
	dwb $7F40, $35
	dwb $7F80, $35
	dwb $7FC0, $35

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
	ld [wd80c], a
	ld a, $d2
	ld [wd80d], a
	ld [wd80e], a
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
	dw Func_d861
	dw Func_d87f
	dw Func_d909
	dw Func_da36
	dw Func_dab2

Func_d861: ; 0xd861
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

Func_d87f: ; 0xd87f
	ld a, $67
	ld [hLCDC], a
	ld a, $e4
	ld [wd80c], a
	ld a, $e1
	ld [wd80d], a
	ld a, $e4
	ld [wd80e], a
	ld a, [wd7ab]
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

Func_d909: ; 0xd909
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
	ld [hFarCallTempA], a
	ld a, Bank(HandleFlippers)
	ld hl, HandleFlippers
	call nz, BankSwitch  ; only perform flipper routines on the lower-half of stages
	ld a, [wFlipperCollision]
	and a
	ld a, [wd7ea]
	push af
	call Func_22b5  ; collision stuff
	pop af
	jr z, .noFlipperCollision
	ld [wd7ea], a
.noFlipperCollision
	call Func_2720 ; not collision-related
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
	jr z, .asm_d9a2
	call ApplyTiltForces
	call LoadBallVelocity
	ld a, [wd7ea]
	call Func_21e7
	call Func_222b
	ld a, [wFlipperCollision]
	and a
	jr z, .asm_d993
	ld hl, wd7bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	ld hl, wd7ba
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	add l
	ld c, a
	ld a, b
	adc h
	ld b, a
	jr .asm_d999

.asm_d993
	ld a, [wd7f8]
	and a
	jr nz, .asm_d9a2
.asm_d999
	ld a, [wd7ea]
	call Func_21e5
	call SetBallVelocity
.asm_d9a2
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_86a4)
	ld hl, Func_86a4
	call nz, BankSwitch
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

Func_da36: ; 0xda36
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
	ld [hFarCallTempA], a
	ld a, Bank(HandleFlippers)
	ld hl, HandleFlippers
	call nz, BankSwitch
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

Func_dab2: ; 0xdab2
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
	ld [wd7ba], a
	ld [wd7bb], a
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
	ld [wd7f3], a
	ld [wd7f4], a
	ld [wd7f5], a
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
	ld [wd7bc], a
	ld a, l
	ld [wd7bd], a
	ld a, [wBallXPos + 1]
	cp $50  ; which flipper did the ball hit?
	ld a, [wFlipperXCollisionAttribute]
	jr c, .asm_e48b
	cpl  ; invert the x collision attribute
	inc a
.asm_e48b
	ld [wd7ea], a
	ld a, $1
	ld [wd7eb], a
	ld a, [wd7bd]
	bit 7, a
	ret z
	xor a
	ld [wd7bc], a
	ld [wd7bd], a
	ret

Func_e4a1: ; 0xe4a1
	ld a, [wCurrentStage]
	and a
	ret z
	ld hl, Data_e50a
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
	ld hl, Data_e50e
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
	ld hl, Data_e523
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

Data_e50a:
	dr $e50a, $e50e

Data_e50e:
	dr $e50e, $e523

Data_e523:
	dr $e523, $e538

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
	call Func_926
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
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   GengarBonusBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES   GengarBonusGastlyGfx, vTilesSH + $100, $180
	VIDEO_DATA_TILES   GengarBonusHaunter1Gfx, vTilesSH + $280, $20
	VIDEO_DATA_TILES   GengarBonusHaunter2Gfx, vTilesOB + $1a0, $100
	VIDEO_DATA_TILES   GengarBonusGengar1Gfx, vTilesOB + $2a0, $160
	VIDEO_DATA_TILES   GengarBonusGengar2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   GengarBonusGengar3Gfx, vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILEMAP GengarBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageGengarBonusGfx_GameBoyColor: ; 0xea5a
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         GengarBonusBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES         GengarBonusGastlyGfx, vTilesSH + $100, $180
	VIDEO_DATA_TILES         GengarBonusHaunter1Gfx, vTilesSH + $280, $20
	VIDEO_DATA_TILES         GengarBonusHaunter2Gfx, vTilesOB + $1a0, $100
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
	ld hl, wd7ab
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
	call Func_926
	rst AdvanceFrame
	ld a, [wd7af]
	and a
	jr nz, .asm_edac
	ld a, [wd7b3]
	and a
	jr nz, .asm_edac
	ld a, [hGameBoyColorFlag]
	and a
	call nz, Func_f269
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call nz, BankSwitch
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

BillboardPicturePointers: ; 0xf1b8
BillboardPicturePointer: MACRO
\1_Pointer: dab \1
ENDM
	BillboardPicturePointer BallSaver30SecondsOnPic
	BillboardPicturePointer BallSaver60SecondsOnPic
	BillboardPicturePointer BallSaver90SecondsOnPic
	BillboardPicturePointer PikachuSaverOnPic
	BillboardPicturePointer ExtraBallOnPic
	BillboardPicturePointer SmallRewardOnPic
	BillboardPicturePointer BigRewardOnPic
	BillboardPicturePointer CatchEmModeOnPic
	BillboardPicturePointer EvolutionModeOnPic
	BillboardPicturePointer GreatBallOnPic
	BillboardPicturePointer UltraBallOnPic
	BillboardPicturePointer MasterBallOnPic
	BillboardPicturePointer BonusMultiplierOnPic
	BillboardPicturePointer GoToGengarBonusOnPic
	BillboardPicturePointer GoToMewtwoBonusOnPic
	BillboardPicturePointer GoToMeowthBonusOnPic
	BillboardPicturePointer GoToDiglettBonusOnPic
	BillboardPicturePointer GoToSeelBonusOnPic
	BillboardPicturePointer SmallReward100PointsOnPic
	BillboardPicturePointer SmallReward200PointsOnPic
	BillboardPicturePointer SmallReward300PointsOnPic
	BillboardPicturePointer SmallReward400PointsOnPic
	BillboardPicturePointer SmallReward500PointsOnPic
	BillboardPicturePointer SmallReward600PointsOnPic
	BillboardPicturePointer SmallReward700PointsOnPic
	BillboardPicturePointer SmallReward800PointsOnPic
	BillboardPicturePointer SmallReward900PointsOnPic
	BillboardPicturePointer BigReward1000000PointsOnPic
	BillboardPicturePointer BigReward2000000PointsOnPic
	BillboardPicturePointer BigReward3000000PointsOnPic
	BillboardPicturePointer BigReward4000000PointsOnPic
	BillboardPicturePointer BigReward5000000PointsOnPic
	BillboardPicturePointer BigReward6000000PointsOnPic
	BillboardPicturePointer BigReward7000000PointsOnPic
	BillboardPicturePointer BigReward8000000PointsOnPic
	BillboardPicturePointer BigReward9000000PointsOnPic
	BillboardPicturePointer BonusMultiplierX1OnPic
	BillboardPicturePointer BonusMultiplierX2OnPic
	BillboardPicturePointer BonusMultiplierX3OnPic
	BillboardPicturePointer BonusMultiplierX4OnPic
	BillboardPicturePointer BonusMultiplierX5OnPic
	BillboardPicturePointer PalletTownPic
	BillboardPicturePointer ViridianCityPic
	BillboardPicturePointer ViridianForestPic
	BillboardPicturePointer PewterCityPic
	BillboardPicturePointer MtMoonPic
	BillboardPicturePointer CeruleanCityPic
	BillboardPicturePointer VermilionCitySeasidePic
	BillboardPicturePointer VermilionCityStreetsPic
	BillboardPicturePointer RockMountainPic
	BillboardPicturePointer LavenderTownPic
	BillboardPicturePointer CeladonCityPic
	BillboardPicturePointer CyclingRoadPic
	BillboardPicturePointer FuchsiaCityPic
	BillboardPicturePointer SafariZonePic
	BillboardPicturePointer SaffronCityPic
	BillboardPicturePointer SeafoamIslandsPic
	BillboardPicturePointer CinnabarIslandPic
	BillboardPicturePointer IndigoPlateauPic

Func_f269: ; 0xf269
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_f27c
	ld a, BANK(StageRedFieldBottomBGPalette5)
	ld hl, StageRedFieldBottomBGPalette5
	ld de, $0030
	ld bc, $0008
	call Func_7dc
.asm_f27c
	ld a, BANK(Data_f288)
	ld de, Data_f288
	hlCoord 7, 4, vBGMap
	call Func_86f
	ret

Data_f288:
	dr $f288, $f2a0

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
	ld hl, Data_2898
	deCoord 6, 8, vBGMap
	ld bc, $0008
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
	ld [wd5bb], a
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

Func_10496: ; 0x10496
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
	ld [wd5f3], a
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
	ld [wd5bb], a
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
	ld [wd5f3], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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

Func_10678: ; 0x10678
	ld a, [wCurrentCatchEmMon]
	ld c, a
	ld b, $0
	ld hl, MonAnimatedSpriteTypes
	add hl, bc
	ld a, [hl]
	ld [wd5bc], a
	ld [wd5bd], a
	ld a, $1
	ld [wd5bb], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_102bc)
	ld hl, Func_102bc
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_102bc)
	ld hl, Func_102bc
	call nz, BankSwitch
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
	ld [wd5bb], a
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
	ld hl, Data_2898
	deCoord 6, 8, vBGMap
	ld bc, $0008
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_102bc)
	ld hl, Func_102bc
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_102bc)
	ld hl, Func_102bc
	call nz, BankSwitch
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

WildMonOffsetsPointers: ; 0x1126c
	dw RedStageWildMonDataOffsets
	dw RedStageWildMonDataOffsets
	dw RedStageWildMonDataOffsets
	dw RedStageWildMonDataOffsets
	dw BlueStageWildMonDataOffsets
	dw BlueStageWildMonDataOffsets

RedStageWildMonDataOffsets: ; 0x11278
	dw (RedStagePalletTownWildMons - RedStageWildMons)        ; PALLET_TOWN
	dw $0000                                                  ; VIRIDIAN_CITY (unused in Red Stage)
	dw (RedStageViridianForestWildMons - RedStageWildMons)    ; VIRIDIAN_FOREST
	dw (RedStagePewterCityWildMons - RedStageWildMons)        ; PEWTER_CITY
	dw $0000                                                  ; MT_MOON (unused in Red Stage)
	dw (RedStageCeruleanCityWildMons - RedStageWildMons)      ; CERULEAN_CITY
	dw (RedStageVermilionSeasideWildMons - RedStageWildMons)  ; VERMILION_SEASIDE
	dw $0000                                                  ; VERMILION_STREETS (unused in Red Stage)
	dw (RedStageRockMountainWildMons - RedStageWildMons)      ; ROCK_MOUNTAIN
	dw (RedStageLavenderTownWildMons - RedStageWildMons)      ; LAVENDER_TOWN
	dw $0000                                                  ; CELADON_CITY (unused in Red Stage)
	dw (RedStageCyclingRoadWildMons - RedStageWildMons)       ; CYCLING_ROAD
	dw $0000                                                  ; FUCHSIA_CITY (unused in Red Stage)
	dw (RedStageSafariZoneWildMons - RedStageWildMons)        ; SAFARI_ZONE
	dw $0000                                                  ; SAFFRON_CITY (unused in Red Stage)
	dw (RedStageSeafoamIslandsWildMons - RedStageWildMons)    ; SEAFOAM_ISLANDS
	dw (RedStageCinnabarIslandWildMons - RedStageWildMons)    ; CINNABAR_ISLAND
	dw (RedStageIndigoPlateauWildMons - RedStageWildMons)     ; INDIGO_PLATEAU

BlueStageWildMonDataOffsets: ; 0x1129c
	dw $0000                                                    ; PALLET_TOWN (unused in Blue Stage)
	dw (BlueStageViridianCityWildMons - BlueStageWildMons)      ; VIRIDIAN_CITY
	dw (BlueStageViridianForestWildMons - BlueStageWildMons)    ; VIRIDIAN_FOREST
	dw $0000                                                    ; PEWTER_CITY (unused in Blue Stage)
	dw (BlueStageMtMoonWildMons - BlueStageWildMons)            ; MT_MOON
	dw (BlueStageCeruleanCityWildMons - BlueStageWildMons)      ; CERULEAN_CITY
	dw $0000                                                    ; VERMILION_SEASIDE (unused in Blue Stage)
	dw (BlueStageVermilionStreetsWildMons - BlueStageWildMons)  ; VERMILION_STREETS
	dw (BlueStageRockMountainWildMons - BlueStageWildMons)      ; ROCK_MOUNTAIN
	dw $0000                                                    ; LAVENDER_TOWN (unused in Blue Stage)
	dw (BlueStageCeladonCityWildMons - BlueStageWildMons)       ; CELADON_CITY
	dw $0000                                                    ; CYCLING_ROAD (unused in Blue Stage)
	dw (BlueStageFuchsiaCityWildMons - BlueStageWildMons)       ; FUCHSIA_CITY
	dw (BlueStageSafariZoneWildMons - BlueStageWildMons)        ; SAFARI_ZONE
	dw (BlueStageSaffronCityWildMons - BlueStageWildMons)       ; SAFFRON_CITY
	dw $0000                                                    ; SEAFOAM_ISLANDS (unused in Blue Stage)
	dw (BlueStageCinnabarIslandWildMons - BlueStageWildMons)    ; CINNABAR_ISLAND
	dw (BlueStageIndigoPlateauWildMons - BlueStageWildMons)     ; INDIGO_PLATEAU

WildMonPointers: ; 0x112c0
	dw RedStageWildMons
	dw RedStageWildMons
	dw RedStageWildMons
	dw RedStageWildMons
	dw BlueStageWildMons
	dw BlueStageWildMons

INCLUDE "data/red_wild_mons.asm"
INCLUDE "data/blue_wild_mons.asm"
INCLUDE "data/evolution_line_starts.asm"
INCLUDE "data/evolution_lines.asm"
INCLUDE "data/evolution_methods.asm"
INCLUDE "data/mon_names.asm"

CatchEmModeInitialIndicatorStates: ; 0x123ae
; Initial states for the indicators when starting Catch Em mode.
; For some reason, each pokemon evolution line has its own entry, but
; they're all exactly the same.
; See wIndicatorStates, for a description of indicators.
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_BULBASAUR
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_CHARMANDER
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SQUIRTLE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_CATERPIE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_WEEDLE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PIDGEY
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_RATTATA
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SPEAROW
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_EKANS
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PIKACHU
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SANDSHREW
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_NIDORAN_F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_NIDORAN_M
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_CLEFAIRY
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_VULPIX
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_JIGGLYPUFF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ZUBAT
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ODDISH
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PARAS
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_VENONAT
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_DIGLETT
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MEOWTH
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PSYDUCK
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MANKEY
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_GROWLITHE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_POLIWAG
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ABRA
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MACHOP
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_BELLSPROUT
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_TENTACOOL
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_GEODUDE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PONYTA
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SLOWPOKE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MAGNEMITE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_FARFETCH_D
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_DODUO
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SEEL
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_GRIMER
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SHELLDER
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_GASTLY
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ONIX
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_DROWZEE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_KRABBY
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_VOLTORB
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_EXEGGCUTE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_CUBONE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_HITMONLEE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_HITMONCHAN
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_LICKITUNG
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_KOFFING
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_RHYHORN
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_CHANSEY
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_TANGELA
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_KANGASKHAN
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_HORSEA
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_GOLDEEN
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_STARYU
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MR_MIME
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SCYTHER
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_JYNX
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ELECTABUZZ
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MAGMAR
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PINSIR
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_TAUROS
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MAGIKARP
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_LAPRAS
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_DITTO
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_EEVEE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_PORYGON
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_OMANYTE
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_KABUTO
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_AERODACTYL
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_SNORLAX
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ARTICUNO
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_ZAPDOS
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MOLTRES
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_DRATINI
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MEWTWO
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; EVOLINE_MEW

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

MonBillboardPicPointers: ; 0x12b50
	dwb BulbasaurPic, Bank(BulbasaurPic)
	dwb IvysaurPic, Bank(IvysaurPic)
	dwb VenusaurPic, Bank(VenusaurPic)
	dwb CharmanderPic, Bank(CharmanderPic)
	dwb CharmeleonPic, Bank(CharmeleonPic)
	dwb CharizardPic, Bank(CharizardPic)
	dwb SquirtlePic, Bank(SquirtlePic)
	dwb WartortlePic, Bank(WartortlePic)
	dwb BlastoisePic, Bank(BlastoisePic)
	dwb CaterpiePic, Bank(CaterpiePic)
	dwb MetapodPic, Bank(MetapodPic)
	dwb ButterfreePic, Bank(ButterfreePic)
	dwb WeedlePic, Bank(WeedlePic)
	dwb KakunaPic, Bank(KakunaPic)
	dwb BeedrillPic, Bank(BeedrillPic)
	dwb PidgeyPic, Bank(PidgeyPic)
	dwb PidgeottoPic, Bank(PidgeottoPic)
	dwb PidgeotPic, Bank(PidgeotPic)
	dwb RattataPic, Bank(RattataPic)
	dwb RaticatePic, Bank(RaticatePic)
	dwb SpearowPic, Bank(SpearowPic)
	dwb FearowPic, Bank(FearowPic)
	dwb EkansPic, Bank(EkansPic)
	dwb ArbokPic, Bank(ArbokPic)
	dwb PikachuPic, Bank(PikachuPic)
	dwb RaichuPic, Bank(RaichuPic)
	dwb SandshrewPic, Bank(SandshrewPic)
	dwb SandslashPic, Bank(SandslashPic)
	dwb Nidoran_FPic, Bank(Nidoran_FPic)
	dwb NidorinaPic, Bank(NidorinaPic)
	dwb NidoqueenPic, Bank(NidoqueenPic)
	dwb Nidoran_MPic, Bank(Nidoran_MPic)
	dwb NidorinoPic, Bank(NidorinoPic)
	dwb NidokingPic, Bank(NidokingPic)
	dwb ClefairyPic, Bank(ClefairyPic)
	dwb ClefablePic, Bank(ClefablePic)
	dwb VulpixPic, Bank(VulpixPic)
	dwb NinetalesPic, Bank(NinetalesPic)
	dwb JigglypuffPic, Bank(JigglypuffPic)
	dwb WigglytuffPic, Bank(WigglytuffPic)
	dwb ZubatPic, Bank(ZubatPic)
	dwb GolbatPic, Bank(GolbatPic)
	dwb OddishPic, Bank(OddishPic)
	dwb GloomPic, Bank(GloomPic)
	dwb VileplumePic, Bank(VileplumePic)
	dwb ParasPic, Bank(ParasPic)
	dwb ParasectPic, Bank(ParasectPic)
	dwb VenonatPic, Bank(VenonatPic)
	dwb VenomothPic, Bank(VenomothPic)
	dwb DiglettPic, Bank(DiglettPic)
	dwb DugtrioPic, Bank(DugtrioPic)
	dwb MeowthPic, Bank(MeowthPic)
	dwb PersianPic, Bank(PersianPic)
	dwb PsyduckPic, Bank(PsyduckPic)
	dwb GolduckPic, Bank(GolduckPic)
	dwb MankeyPic, Bank(MankeyPic)
	dwb PrimeapePic, Bank(PrimeapePic)
	dwb GrowlithePic, Bank(GrowlithePic)
	dwb ArcaninePic, Bank(ArcaninePic)
	dwb PoliwagPic, Bank(PoliwagPic)
	dwb PoliwhirlPic, Bank(PoliwhirlPic)
	dwb PoliwrathPic, Bank(PoliwrathPic)
	dwb AbraPic, Bank(AbraPic)
	dwb KadabraPic, Bank(KadabraPic)
	dwb AlakazamPic, Bank(AlakazamPic)
	dwb MachopPic, Bank(MachopPic)
	dwb MachokePic, Bank(MachokePic)
	dwb MachampPic, Bank(MachampPic)
	dwb BellsproutPic, Bank(BellsproutPic)
	dwb WeepinbellPic, Bank(WeepinbellPic)
	dwb VictreebellPic, Bank(VictreebellPic)
	dwb TentacoolPic, Bank(TentacoolPic)
	dwb TentacruelPic, Bank(TentacruelPic)
	dwb GeodudePic, Bank(GeodudePic)
	dwb GravelerPic, Bank(GravelerPic)
	dwb GolemPic, Bank(GolemPic)
	dwb PonytaPic, Bank(PonytaPic)
	dwb RapidashPic, Bank(RapidashPic)
	dwb SlowpokePic, Bank(SlowpokePic)
	dwb SlowbroPic, Bank(SlowbroPic)
	dwb MagnemitePic, Bank(MagnemitePic)
	dwb MagnetonPic, Bank(MagnetonPic)
	dwb Farfetch_dPic, Bank(Farfetch_dPic)
	dwb DoduoPic, Bank(DoduoPic)
	dwb DodrioPic, Bank(DodrioPic)
	dwb SeelPic, Bank(SeelPic)
	dwb DewgongPic, Bank(DewgongPic)
	dwb GrimerPic, Bank(GrimerPic)
	dwb MukPic, Bank(MukPic)
	dwb ShellderPic, Bank(ShellderPic)
	dwb CloysterPic, Bank(CloysterPic)
	dwb GastlyPic, Bank(GastlyPic)
	dwb HaunterPic, Bank(HaunterPic)
	dwb GengarPic, Bank(GengarPic)
	dwb OnixPic, Bank(OnixPic)
	dwb DrowzeePic, Bank(DrowzeePic)
	dwb HypnoPic, Bank(HypnoPic)
	dwb KrabbyPic, Bank(KrabbyPic)
	dwb KinglerPic, Bank(KinglerPic)
	dwb VoltorbPic, Bank(VoltorbPic)
	dwb ElectrodePic, Bank(ElectrodePic)
	dwb ExeggcutePic, Bank(ExeggcutePic)
	dwb ExeggutorPic, Bank(ExeggutorPic)
	dwb CubonePic, Bank(CubonePic)
	dwb MarowakPic, Bank(MarowakPic)
	dwb HitmonleePic, Bank(HitmonleePic)
	dwb HitmonchanPic, Bank(HitmonchanPic)
	dwb LickitungPic, Bank(LickitungPic)
	dwb KoffingPic, Bank(KoffingPic)
	dwb WeezingPic, Bank(WeezingPic)
	dwb RhyhornPic, Bank(RhyhornPic)
	dwb RhydonPic, Bank(RhydonPic)
	dwb ChanseyPic, Bank(ChanseyPic)
	dwb TangelaPic, Bank(TangelaPic)
	dwb KangaskhanPic, Bank(KangaskhanPic)
	dwb HorseaPic, Bank(HorseaPic)
	dwb SeadraPic, Bank(SeadraPic)
	dwb GoldeenPic, Bank(GoldeenPic)
	dwb SeakingPic, Bank(SeakingPic)
	dwb StaryuPic, Bank(StaryuPic)
	dwb StarmiePic, Bank(StarmiePic)
	dwb Mr_MimePic, Bank(Mr_MimePic)
	dwb ScytherPic, Bank(ScytherPic)
	dwb JynxPic, Bank(JynxPic)
	dwb ElectabuzzPic, Bank(ElectabuzzPic)
	dwb MagmarPic, Bank(MagmarPic)
	dwb PinsirPic, Bank(PinsirPic)
	dwb TaurosPic, Bank(TaurosPic)
	dwb MagikarpPic, Bank(MagikarpPic)
	dwb GyaradosPic, Bank(GyaradosPic)
	dwb LaprasPic, Bank(LaprasPic)
	dwb DittoPic, Bank(DittoPic)
	dwb EeveePic, Bank(EeveePic)
	dwb VaporeonPic, Bank(VaporeonPic)
	dwb JolteonPic, Bank(JolteonPic)
	dwb FlareonPic, Bank(FlareonPic)
	dwb PorygonPic, Bank(PorygonPic)
	dwb OmanytePic, Bank(OmanytePic)
	dwb OmastarPic, Bank(OmastarPic)
	dwb KabutoPic, Bank(KabutoPic)
	dwb KabutopsPic, Bank(KabutopsPic)
	dwb AerodactylPic, Bank(AerodactylPic)
	dwb SnorlaxPic, Bank(SnorlaxPic)
	dwb ArticunoPic, Bank(ArticunoPic)
	dwb ZapdosPic, Bank(ZapdosPic)
	dwb MoltresPic, Bank(MoltresPic)
	dwb DratiniPic, Bank(DratiniPic)
	dwb DragonairPic, Bank(DragonairPic)
	dwb DragonitePic, Bank(DragonitePic)
	dwb MewtwoPic, Bank(MewtwoPic)
	dwb MewPic, Bank(MewPic)

MonBillboardPaletteMapPointers: ; 0x12d15
	dwb BulbasaurBillboardBGPaletteMap, Bank(BulbasaurBillboardBGPaletteMap)
	dwb IvysaurBillboardBGPaletteMap, Bank(IvysaurBillboardBGPaletteMap)
	dwb VenusaurBillboardBGPaletteMap, Bank(VenusaurBillboardBGPaletteMap)
	dwb CharmanderBillboardBGPaletteMap, Bank(CharmanderBillboardBGPaletteMap)
	dwb CharmeleonBillboardBGPaletteMap, Bank(CharmeleonBillboardBGPaletteMap)
	dwb CharizardBillboardBGPaletteMap, Bank(CharizardBillboardBGPaletteMap)
	dwb SquirtleBillboardBGPaletteMap, Bank(SquirtleBillboardBGPaletteMap)
	dwb WartortleBillboardBGPaletteMap, Bank(WartortleBillboardBGPaletteMap)
	dwb BlastoiseBillboardBGPaletteMap, Bank(BlastoiseBillboardBGPaletteMap)
	dwb CaterpieBillboardBGPaletteMap, Bank(CaterpieBillboardBGPaletteMap)
	dwb MetapodBillboardBGPaletteMap, Bank(MetapodBillboardBGPaletteMap)
	dwb ButterfreeBillboardBGPaletteMap, Bank(ButterfreeBillboardBGPaletteMap)
	dwb WeedleBillboardBGPaletteMap, Bank(WeedleBillboardBGPaletteMap)
	dwb KakunaBillboardBGPaletteMap, Bank(KakunaBillboardBGPaletteMap)
	dwb BeedrillBillboardBGPaletteMap, Bank(BeedrillBillboardBGPaletteMap)
	dwb PidgeyBillboardBGPaletteMap, Bank(PidgeyBillboardBGPaletteMap)
	dwb PidgeottoBillboardBGPaletteMap, Bank(PidgeottoBillboardBGPaletteMap)
	dwb PidgeotBillboardBGPaletteMap, Bank(PidgeotBillboardBGPaletteMap)
	dwb RattataBillboardBGPaletteMap, Bank(RattataBillboardBGPaletteMap)
	dwb RaticateBillboardBGPaletteMap, Bank(RaticateBillboardBGPaletteMap)
	dwb SpearowBillboardBGPaletteMap, Bank(SpearowBillboardBGPaletteMap)
	dwb FearowBillboardBGPaletteMap, Bank(FearowBillboardBGPaletteMap)
	dwb EkansBillboardBGPaletteMap, Bank(EkansBillboardBGPaletteMap)
	dwb ArbokBillboardBGPaletteMap, Bank(ArbokBillboardBGPaletteMap)
	dwb PikachuBillboardBGPaletteMap, Bank(PikachuBillboardBGPaletteMap)
	dwb RaichuBillboardBGPaletteMap, Bank(RaichuBillboardBGPaletteMap)
	dwb SandshrewBillboardBGPaletteMap, Bank(SandshrewBillboardBGPaletteMap)
	dwb SandslashBillboardBGPaletteMap, Bank(SandslashBillboardBGPaletteMap)
	dwb NidoranFBillboardBGPaletteMap, Bank(NidoranFBillboardBGPaletteMap)
	dwb NidorinaBillboardBGPaletteMap, Bank(NidorinaBillboardBGPaletteMap)
	dwb NidoqueenBillboardBGPaletteMap, Bank(NidoqueenBillboardBGPaletteMap)
	dwb NidoranMBillboardBGPaletteMap, Bank(NidoranMBillboardBGPaletteMap)
	dwb NidorinoBillboardBGPaletteMap, Bank(NidorinoBillboardBGPaletteMap)
	dwb NidokingBillboardBGPaletteMap, Bank(NidokingBillboardBGPaletteMap)
	dwb ClefairyBillboardBGPaletteMap, Bank(ClefairyBillboardBGPaletteMap)
	dwb ClefableBillboardBGPaletteMap, Bank(ClefableBillboardBGPaletteMap)
	dwb VulpixBillboardBGPaletteMap, Bank(VulpixBillboardBGPaletteMap)
	dwb NinetalesBillboardBGPaletteMap, Bank(NinetalesBillboardBGPaletteMap)
	dwb JigglypuffBillboardBGPaletteMap, Bank(JigglypuffBillboardBGPaletteMap)
	dwb WigglytuffBillboardBGPaletteMap, Bank(WigglytuffBillboardBGPaletteMap)
	dwb ZubatBillboardBGPaletteMap, Bank(ZubatBillboardBGPaletteMap)
	dwb GolbatBillboardBGPaletteMap, Bank(GolbatBillboardBGPaletteMap)
	dwb OddishBillboardBGPaletteMap, Bank(OddishBillboardBGPaletteMap)
	dwb GloomBillboardBGPaletteMap, Bank(GloomBillboardBGPaletteMap)
	dwb VileplumeBillboardBGPaletteMap, Bank(VileplumeBillboardBGPaletteMap)
	dwb ParasBillboardBGPaletteMap, Bank(ParasBillboardBGPaletteMap)
	dwb ParasectBillboardBGPaletteMap, Bank(ParasectBillboardBGPaletteMap)
	dwb VenonatBillboardBGPaletteMap, Bank(VenonatBillboardBGPaletteMap)
	dwb VenomothBillboardBGPaletteMap, Bank(VenomothBillboardBGPaletteMap)
	dwb DiglettBillboardBGPaletteMap, Bank(DiglettBillboardBGPaletteMap)
	dwb DugtrioBillboardBGPaletteMap, Bank(DugtrioBillboardBGPaletteMap)
	dwb MeowthBillboardBGPaletteMap, Bank(MeowthBillboardBGPaletteMap)
	dwb PersianBillboardBGPaletteMap, Bank(PersianBillboardBGPaletteMap)
	dwb PsyduckBillboardBGPaletteMap, Bank(PsyduckBillboardBGPaletteMap)
	dwb GolduckBillboardBGPaletteMap, Bank(GolduckBillboardBGPaletteMap)
	dwb MankeyBillboardBGPaletteMap, Bank(MankeyBillboardBGPaletteMap)
	dwb PrimeapeBillboardBGPaletteMap, Bank(PrimeapeBillboardBGPaletteMap)
	dwb GrowlitheBillboardBGPaletteMap, Bank(GrowlitheBillboardBGPaletteMap)
	dwb ArcanineBillboardBGPaletteMap, Bank(ArcanineBillboardBGPaletteMap)
	dwb PoliwagBillboardBGPaletteMap, Bank(PoliwagBillboardBGPaletteMap)
	dwb PoliwhirlBillboardBGPaletteMap, Bank(PoliwhirlBillboardBGPaletteMap)
	dwb PoliwrathBillboardBGPaletteMap, Bank(PoliwrathBillboardBGPaletteMap)
	dwb AbraBillboardBGPaletteMap, Bank(AbraBillboardBGPaletteMap)
	dwb KadabraBillboardBGPaletteMap, Bank(KadabraBillboardBGPaletteMap)
	dwb AlakazamBillboardBGPaletteMap, Bank(AlakazamBillboardBGPaletteMap)
	dwb MachopBillboardBGPaletteMap, Bank(MachopBillboardBGPaletteMap)
	dwb MachokeBillboardBGPaletteMap, Bank(MachokeBillboardBGPaletteMap)
	dwb MachampBillboardBGPaletteMap, Bank(MachampBillboardBGPaletteMap)
	dwb BellsproutBillboardBGPaletteMap, Bank(BellsproutBillboardBGPaletteMap)
	dwb WeepinbellBillboardBGPaletteMap, Bank(WeepinbellBillboardBGPaletteMap)
	dwb VictreebellBillboardBGPaletteMap, Bank(VictreebellBillboardBGPaletteMap)
	dwb TentacoolBillboardBGPaletteMap, Bank(TentacoolBillboardBGPaletteMap)
	dwb TentacruelBillboardBGPaletteMap, Bank(TentacruelBillboardBGPaletteMap)
	dwb GeodudeBillboardBGPaletteMap, Bank(GeodudeBillboardBGPaletteMap)
	dwb GravelerBillboardBGPaletteMap, Bank(GravelerBillboardBGPaletteMap)
	dwb GolemBillboardBGPaletteMap, Bank(GolemBillboardBGPaletteMap)
	dwb PonytaBillboardBGPaletteMap, Bank(PonytaBillboardBGPaletteMap)
	dwb RapidashBillboardBGPaletteMap, Bank(RapidashBillboardBGPaletteMap)
	dwb SlowpokeBillboardBGPaletteMap, Bank(SlowpokeBillboardBGPaletteMap)
	dwb SlowbroBillboardBGPaletteMap, Bank(SlowbroBillboardBGPaletteMap)
	dwb MagnemiteBillboardBGPaletteMap, Bank(MagnemiteBillboardBGPaletteMap)
	dwb MagnetonBillboardBGPaletteMap, Bank(MagnetonBillboardBGPaletteMap)
	dwb FarfetchdBillboardBGPaletteMap, Bank(FarfetchdBillboardBGPaletteMap)
	dwb DoduoBillboardBGPaletteMap, Bank(DoduoBillboardBGPaletteMap)
	dwb DodrioBillboardBGPaletteMap, Bank(DodrioBillboardBGPaletteMap)
	dwb SeelBillboardBGPaletteMap, Bank(SeelBillboardBGPaletteMap)
	dwb DewgongBillboardBGPaletteMap, Bank(DewgongBillboardBGPaletteMap)
	dwb GrimerBillboardBGPaletteMap, Bank(GrimerBillboardBGPaletteMap)
	dwb MukBillboardBGPaletteMap, Bank(MukBillboardBGPaletteMap)
	dwb ShellderBillboardBGPaletteMap, Bank(ShellderBillboardBGPaletteMap)
	dwb CloysterBillboardBGPaletteMap, Bank(CloysterBillboardBGPaletteMap)
	dwb GastlyBillboardBGPaletteMap, Bank(GastlyBillboardBGPaletteMap)
	dwb HaunterBillboardBGPaletteMap, Bank(HaunterBillboardBGPaletteMap)
	dwb GengarBillboardBGPaletteMap, Bank(GengarBillboardBGPaletteMap)
	dwb OnixBillboardBGPaletteMap, Bank(OnixBillboardBGPaletteMap)
	dwb DrowzeeBillboardBGPaletteMap, Bank(DrowzeeBillboardBGPaletteMap)
	dwb HypnoBillboardBGPaletteMap, Bank(HypnoBillboardBGPaletteMap)
	dwb KrabbyBillboardBGPaletteMap, Bank(KrabbyBillboardBGPaletteMap)
	dwb KinglerBillboardBGPaletteMap, Bank(KinglerBillboardBGPaletteMap)
	dwb VoltorbBillboardBGPaletteMap, Bank(VoltorbBillboardBGPaletteMap)
	dwb ElectrodeBillboardBGPaletteMap, Bank(ElectrodeBillboardBGPaletteMap)
	dwb ExeggcuteBillboardBGPaletteMap, Bank(ExeggcuteBillboardBGPaletteMap)
	dwb ExeggutorBillboardBGPaletteMap, Bank(ExeggutorBillboardBGPaletteMap)
	dwb CuboneBillboardBGPaletteMap, Bank(CuboneBillboardBGPaletteMap)
	dwb MarowakBillboardBGPaletteMap, Bank(MarowakBillboardBGPaletteMap)
	dwb HitmonleeBillboardBGPaletteMap, Bank(HitmonleeBillboardBGPaletteMap)
	dwb HitmonchanBillboardBGPaletteMap, Bank(HitmonchanBillboardBGPaletteMap)
	dwb LickitungBillboardBGPaletteMap, Bank(LickitungBillboardBGPaletteMap)
	dwb KoffingBillboardBGPaletteMap, Bank(KoffingBillboardBGPaletteMap)
	dwb WeezingBillboardBGPaletteMap, Bank(WeezingBillboardBGPaletteMap)
	dwb RhyhornBillboardBGPaletteMap, Bank(RhyhornBillboardBGPaletteMap)
	dwb RhydonBillboardBGPaletteMap, Bank(RhydonBillboardBGPaletteMap)
	dwb ChanseyBillboardBGPaletteMap, Bank(ChanseyBillboardBGPaletteMap)
	dwb TangelaBillboardBGPaletteMap, Bank(TangelaBillboardBGPaletteMap)
	dwb KangaskhanBillboardBGPaletteMap, Bank(KangaskhanBillboardBGPaletteMap)
	dwb HorseaBillboardBGPaletteMap, Bank(HorseaBillboardBGPaletteMap)
	dwb SeadraBillboardBGPaletteMap, Bank(SeadraBillboardBGPaletteMap)
	dwb GoldeenBillboardBGPaletteMap, Bank(GoldeenBillboardBGPaletteMap)
	dwb SeakingBillboardBGPaletteMap, Bank(SeakingBillboardBGPaletteMap)
	dwb StaryuBillboardBGPaletteMap, Bank(StaryuBillboardBGPaletteMap)
	dwb StarmieBillboardBGPaletteMap, Bank(StarmieBillboardBGPaletteMap)
	dwb MrMimeBillboardBGPaletteMap, Bank(MrMimeBillboardBGPaletteMap)
	dwb ScytherBillboardBGPaletteMap, Bank(ScytherBillboardBGPaletteMap)
	dwb JynxBillboardBGPaletteMap, Bank(JynxBillboardBGPaletteMap)
	dwb ElectabuzzBillboardBGPaletteMap, Bank(ElectabuzzBillboardBGPaletteMap)
	dwb MagmarBillboardBGPaletteMap, Bank(MagmarBillboardBGPaletteMap)
	dwb PinsirBillboardBGPaletteMap, Bank(PinsirBillboardBGPaletteMap)
	dwb TaurosBillboardBGPaletteMap, Bank(TaurosBillboardBGPaletteMap)
	dwb MagikarpBillboardBGPaletteMap, Bank(MagikarpBillboardBGPaletteMap)
	dwb GyaradosBillboardBGPaletteMap, Bank(GyaradosBillboardBGPaletteMap)
	dwb LaprasBillboardBGPaletteMap, Bank(LaprasBillboardBGPaletteMap)
	dwb DittoBillboardBGPaletteMap, Bank(DittoBillboardBGPaletteMap)
	dwb EeveeBillboardBGPaletteMap, Bank(EeveeBillboardBGPaletteMap)
	dwb VaporeonBillboardBGPaletteMap, Bank(VaporeonBillboardBGPaletteMap)
	dwb JolteonBillboardBGPaletteMap, Bank(JolteonBillboardBGPaletteMap)
	dwb FlareonBillboardBGPaletteMap, Bank(FlareonBillboardBGPaletteMap)
	dwb PorygonBillboardBGPaletteMap, Bank(PorygonBillboardBGPaletteMap)
	dwb OmanyteBillboardBGPaletteMap, Bank(OmanyteBillboardBGPaletteMap)
	dwb OmastarBillboardBGPaletteMap, Bank(OmastarBillboardBGPaletteMap)
	dwb KabutoBillboardBGPaletteMap, Bank(KabutoBillboardBGPaletteMap)
	dwb KabutopsBillboardBGPaletteMap, Bank(KabutopsBillboardBGPaletteMap)
	dwb AerodactylBillboardBGPaletteMap, Bank(AerodactylBillboardBGPaletteMap)
	dwb SnorlaxBillboardBGPaletteMap, Bank(SnorlaxBillboardBGPaletteMap)
	dwb ArticunoBillboardBGPaletteMap, Bank(ArticunoBillboardBGPaletteMap)
	dwb ZapdosBillboardBGPaletteMap, Bank(ZapdosBillboardBGPaletteMap)
	dwb MoltresBillboardBGPaletteMap, Bank(MoltresBillboardBGPaletteMap)
	dwb DratiniBillboardBGPaletteMap, Bank(DratiniBillboardBGPaletteMap)
	dwb DragonairBillboardBGPaletteMap, Bank(DragonairBillboardBGPaletteMap)
	dwb DragoniteBillboardBGPaletteMap, Bank(DragoniteBillboardBGPaletteMap)
	dwb MewtwoBillboardBGPaletteMap, Bank(MewtwoBillboardBGPaletteMap)
	dwb MewBillboardBGPaletteMap, Bank(MewBillboardBGPaletteMap)

MonBillboardPalettePointers: ; 0x12eda
	dwb BulbasaurBillboardBGPalette1, Bank(BulbasaurBillboardBGPalette1)
	dwb IvysaurBillboardBGPalette1, Bank(IvysaurBillboardBGPalette1)
	dwb VenusaurBillboardBGPalette1, Bank(VenusaurBillboardBGPalette1)
	dwb CharmanderBillboardBGPalette1, Bank(CharmanderBillboardBGPalette1)
	dwb CharmeleonBillboardBGPalette1, Bank(CharmeleonBillboardBGPalette1)
	dwb CharizardBillboardBGPalette1, Bank(CharizardBillboardBGPalette1)
	dwb SquirtleBillboardBGPalette1, Bank(SquirtleBillboardBGPalette1)
	dwb WartortleBillboardBGPalette1, Bank(WartortleBillboardBGPalette1)
	dwb BlastoiseBillboardBGPalette1, Bank(BlastoiseBillboardBGPalette1)
	dwb CaterpieBillboardBGPalette1, Bank(CaterpieBillboardBGPalette1)
	dwb MetapodBillboardBGPalette1, Bank(MetapodBillboardBGPalette1)
	dwb ButterfreeBillboardBGPalette1, Bank(ButterfreeBillboardBGPalette1)
	dwb WeedleBillboardBGPalette1, Bank(WeedleBillboardBGPalette1)
	dwb KakunaBillboardBGPalette1, Bank(KakunaBillboardBGPalette1)
	dwb BeedrillBillboardBGPalette1, Bank(BeedrillBillboardBGPalette1)
	dwb PidgeyBillboardBGPalette1, Bank(PidgeyBillboardBGPalette1)
	dwb PidgeottoBillboardBGPalette1, Bank(PidgeottoBillboardBGPalette1)
	dwb PidgeotBillboardBGPalette1, Bank(PidgeotBillboardBGPalette1)
	dwb RattataBillboardBGPalette1, Bank(RattataBillboardBGPalette1)
	dwb RaticateBillboardBGPalette1, Bank(RaticateBillboardBGPalette1)
	dwb SpearowBillboardBGPalette1, Bank(SpearowBillboardBGPalette1)
	dwb FearowBillboardBGPalette1, Bank(FearowBillboardBGPalette1)
	dwb EkansBillboardBGPalette1, Bank(EkansBillboardBGPalette1)
	dwb ArbokBillboardBGPalette1, Bank(ArbokBillboardBGPalette1)
	dwb PikachuBillboardBGPalette1, Bank(PikachuBillboardBGPalette1)
	dwb RaichuBillboardBGPalette1, Bank(RaichuBillboardBGPalette1)
	dwb SandshrewBillboardBGPalette1, Bank(SandshrewBillboardBGPalette1)
	dwb SandslashBillboardBGPalette1, Bank(SandslashBillboardBGPalette1)
	dwb NidoranFBillboardBGPalette1, Bank(NidoranFBillboardBGPalette1)
	dwb NidorinaBillboardBGPalette1, Bank(NidorinaBillboardBGPalette1)
	dwb NidoqueenBillboardBGPalette1, Bank(NidoqueenBillboardBGPalette1)
	dwb NidoranMBillboardBGPalette1, Bank(NidoranMBillboardBGPalette1)
	dwb NidorinoBillboardBGPalette1, Bank(NidorinoBillboardBGPalette1)
	dwb NidokingBillboardBGPalette1, Bank(NidokingBillboardBGPalette1)
	dwb ClefairyBillboardBGPalette1, Bank(ClefairyBillboardBGPalette1)
	dwb ClefableBillboardBGPalette1, Bank(ClefableBillboardBGPalette1)
	dwb VulpixBillboardBGPalette1, Bank(VulpixBillboardBGPalette1)
	dwb NinetalesBillboardBGPalette1, Bank(NinetalesBillboardBGPalette1)
	dwb JigglypuffBillboardBGPalette1, Bank(JigglypuffBillboardBGPalette1)
	dwb WigglytuffBillboardBGPalette1, Bank(WigglytuffBillboardBGPalette1)
	dwb ZubatBillboardBGPalette1, Bank(ZubatBillboardBGPalette1)
	dwb GolbatBillboardBGPalette1, Bank(GolbatBillboardBGPalette1)
	dwb OddishBillboardBGPalette1, Bank(OddishBillboardBGPalette1)
	dwb GloomBillboardBGPalette1, Bank(GloomBillboardBGPalette1)
	dwb VileplumeBillboardBGPalette1, Bank(VileplumeBillboardBGPalette1)
	dwb ParasBillboardBGPalette1, Bank(ParasBillboardBGPalette1)
	dwb ParasectBillboardBGPalette1, Bank(ParasectBillboardBGPalette1)
	dwb VenonatBillboardBGPalette1, Bank(VenonatBillboardBGPalette1)
	dwb VenomothBillboardBGPalette1, Bank(VenomothBillboardBGPalette1)
	dwb DiglettBillboardBGPalette1, Bank(DiglettBillboardBGPalette1)
	dwb DugtrioBillboardBGPalette1, Bank(DugtrioBillboardBGPalette1)
	dwb MeowthBillboardBGPalette1, Bank(MeowthBillboardBGPalette1)
	dwb PersianBillboardBGPalette1, Bank(PersianBillboardBGPalette1)
	dwb PsyduckBillboardBGPalette1, Bank(PsyduckBillboardBGPalette1)
	dwb GolduckBillboardBGPalette1, Bank(GolduckBillboardBGPalette1)
	dwb MankeyBillboardBGPalette1, Bank(MankeyBillboardBGPalette1)
	dwb PrimeapeBillboardBGPalette1, Bank(PrimeapeBillboardBGPalette1)
	dwb GrowlitheBillboardBGPalette1, Bank(GrowlitheBillboardBGPalette1)
	dwb ArcanineBillboardBGPalette1, Bank(ArcanineBillboardBGPalette1)
	dwb PoliwagBillboardBGPalette1, Bank(PoliwagBillboardBGPalette1)
	dwb PoliwhirlBillboardBGPalette1, Bank(PoliwhirlBillboardBGPalette1)
	dwb PoliwrathBillboardBGPalette1, Bank(PoliwrathBillboardBGPalette1)
	dwb AbraBillboardBGPalette1, Bank(AbraBillboardBGPalette1)
	dwb KadabraBillboardBGPalette1, Bank(KadabraBillboardBGPalette1)
	dwb AlakazamBillboardBGPalette1, Bank(AlakazamBillboardBGPalette1)
	dwb MachopBillboardBGPalette1, Bank(MachopBillboardBGPalette1)
	dwb MachokeBillboardBGPalette1, Bank(MachokeBillboardBGPalette1)
	dwb MachampBillboardBGPalette1, Bank(MachampBillboardBGPalette1)
	dwb BellsproutBillboardBGPalette1, Bank(BellsproutBillboardBGPalette1)
	dwb WeepinbellBillboardBGPalette1, Bank(WeepinbellBillboardBGPalette1)
	dwb VictreebellBillboardBGPalette1, Bank(VictreebellBillboardBGPalette1)
	dwb TentacoolBillboardBGPalette1, Bank(TentacoolBillboardBGPalette1)
	dwb TentacruelBillboardBGPalette1, Bank(TentacruelBillboardBGPalette1)
	dwb GeodudeBillboardBGPalette1, Bank(GeodudeBillboardBGPalette1)
	dwb GravelerBillboardBGPalette1, Bank(GravelerBillboardBGPalette1)
	dwb GolemBillboardBGPalette1, Bank(GolemBillboardBGPalette1)
	dwb PonytaBillboardBGPalette1, Bank(PonytaBillboardBGPalette1)
	dwb RapidashBillboardBGPalette1, Bank(RapidashBillboardBGPalette1)
	dwb SlowpokeBillboardBGPalette1, Bank(SlowpokeBillboardBGPalette1)
	dwb SlowbroBillboardBGPalette1, Bank(SlowbroBillboardBGPalette1)
	dwb MagnemiteBillboardBGPalette1, Bank(MagnemiteBillboardBGPalette1)
	dwb MagnetonBillboardBGPalette1, Bank(MagnetonBillboardBGPalette1)
	dwb FarfetchdBillboardBGPalette1, Bank(FarfetchdBillboardBGPalette1)
	dwb DoduoBillboardBGPalette1, Bank(DoduoBillboardBGPalette1)
	dwb DodrioBillboardBGPalette1, Bank(DodrioBillboardBGPalette1)
	dwb SeelBillboardBGPalette1, Bank(SeelBillboardBGPalette1)
	dwb DewgongBillboardBGPalette1, Bank(DewgongBillboardBGPalette1)
	dwb GrimerBillboardBGPalette1, Bank(GrimerBillboardBGPalette1)
	dwb MukBillboardBGPalette1, Bank(MukBillboardBGPalette1)
	dwb ShellderBillboardBGPalette1, Bank(ShellderBillboardBGPalette1)
	dwb CloysterBillboardBGPalette1, Bank(CloysterBillboardBGPalette1)
	dwb GastlyBillboardBGPalette1, Bank(GastlyBillboardBGPalette1)
	dwb HaunterBillboardBGPalette1, Bank(HaunterBillboardBGPalette1)
	dwb GengarBillboardBGPalette1, Bank(GengarBillboardBGPalette1)
	dwb OnixBillboardBGPalette1, Bank(OnixBillboardBGPalette1)
	dwb DrowzeeBillboardBGPalette1, Bank(DrowzeeBillboardBGPalette1)
	dwb HypnoBillboardBGPalette1, Bank(HypnoBillboardBGPalette1)
	dwb KrabbyBillboardBGPalette1, Bank(KrabbyBillboardBGPalette1)
	dwb KinglerBillboardBGPalette1, Bank(KinglerBillboardBGPalette1)
	dwb VoltorbBillboardBGPalette1, Bank(VoltorbBillboardBGPalette1)
	dwb ElectrodeBillboardBGPalette1, Bank(ElectrodeBillboardBGPalette1)
	dwb ExeggcuteBillboardBGPalette1, Bank(ExeggcuteBillboardBGPalette1)
	dwb ExeggutorBillboardBGPalette1, Bank(ExeggutorBillboardBGPalette1)
	dwb CuboneBillboardBGPalette1, Bank(CuboneBillboardBGPalette1)
	dwb MarowakBillboardBGPalette1, Bank(MarowakBillboardBGPalette1)
	dwb HitmonleeBillboardBGPalette1, Bank(HitmonleeBillboardBGPalette1)
	dwb HitmonchanBillboardBGPalette1, Bank(HitmonchanBillboardBGPalette1)
	dwb LickitungBillboardBGPalette1, Bank(LickitungBillboardBGPalette1)
	dwb KoffingBillboardBGPalette1, Bank(KoffingBillboardBGPalette1)
	dwb WeezingBillboardBGPalette1, Bank(WeezingBillboardBGPalette1)
	dwb RhyhornBillboardBGPalette1, Bank(RhyhornBillboardBGPalette1)
	dwb RhydonBillboardBGPalette1, Bank(RhydonBillboardBGPalette1)
	dwb ChanseyBillboardBGPalette1, Bank(ChanseyBillboardBGPalette1)
	dwb TangelaBillboardBGPalette1, Bank(TangelaBillboardBGPalette1)
	dwb KangaskhanBillboardBGPalette1, Bank(KangaskhanBillboardBGPalette1)
	dwb HorseaBillboardBGPalette1, Bank(HorseaBillboardBGPalette1)
	dwb SeadraBillboardBGPalette1, Bank(SeadraBillboardBGPalette1)
	dwb GoldeenBillboardBGPalette1, Bank(GoldeenBillboardBGPalette1)
	dwb SeakingBillboardBGPalette1, Bank(SeakingBillboardBGPalette1)
	dwb StaryuBillboardBGPalette1, Bank(StaryuBillboardBGPalette1)
	dwb StarmieBillboardBGPalette1, Bank(StarmieBillboardBGPalette1)
	dwb MrMimeBillboardBGPalette1, Bank(MrMimeBillboardBGPalette1)
	dwb ScytherBillboardBGPalette1, Bank(ScytherBillboardBGPalette1)
	dwb JynxBillboardBGPalette1, Bank(JynxBillboardBGPalette1)
	dwb ElectabuzzBillboardBGPalette1, Bank(ElectabuzzBillboardBGPalette1)
	dwb MagmarBillboardBGPalette1, Bank(MagmarBillboardBGPalette1)
	dwb PinsirBillboardBGPalette1, Bank(PinsirBillboardBGPalette1)
	dwb TaurosBillboardBGPalette1, Bank(TaurosBillboardBGPalette1)
	dwb MagikarpBillboardBGPalette1, Bank(MagikarpBillboardBGPalette1)
	dwb GyaradosBillboardBGPalette1, Bank(GyaradosBillboardBGPalette1)
	dwb LaprasBillboardBGPalette1, Bank(LaprasBillboardBGPalette1)
	dwb DittoBillboardBGPalette1, Bank(DittoBillboardBGPalette1)
	dwb EeveeBillboardBGPalette1, Bank(EeveeBillboardBGPalette1)
	dwb VaporeonBillboardBGPalette1, Bank(VaporeonBillboardBGPalette1)
	dwb JolteonBillboardBGPalette1, Bank(JolteonBillboardBGPalette1)
	dwb FlareonBillboardBGPalette1, Bank(FlareonBillboardBGPalette1)
	dwb PorygonBillboardBGPalette1, Bank(PorygonBillboardBGPalette1)
	dwb OmanyteBillboardBGPalette1, Bank(OmanyteBillboardBGPalette1)
	dwb OmastarBillboardBGPalette1, Bank(OmastarBillboardBGPalette1)
	dwb KabutoBillboardBGPalette1, Bank(KabutoBillboardBGPalette1)
	dwb KabutopsBillboardBGPalette1, Bank(KabutopsBillboardBGPalette1)
	dwb AerodactylBillboardBGPalette1, Bank(AerodactylBillboardBGPalette1)
	dwb SnorlaxBillboardBGPalette1, Bank(SnorlaxBillboardBGPalette1)
	dwb ArticunoBillboardBGPalette1, Bank(ArticunoBillboardBGPalette1)
	dwb ZapdosBillboardBGPalette1, Bank(ZapdosBillboardBGPalette1)
	dwb MoltresBillboardBGPalette1, Bank(MoltresBillboardBGPalette1)
	dwb DratiniBillboardBGPalette1, Bank(DratiniBillboardBGPalette1)
	dwb DragonairBillboardBGPalette1, Bank(DragonairBillboardBGPalette1)
	dwb DragoniteBillboardBGPalette1, Bank(DragoniteBillboardBGPalette1)
	dwb MewtwoBillboardBGPalette1, Bank(MewtwoBillboardBGPalette1)
	dwb MewBillboardBGPalette1, Bank(MewBillboardBGPalette1)

MonAnimatedPalettePointers: ; 0x1309f
	dwb BulbasaurAnimatedObjPalette1, Bank(BulbasaurAnimatedObjPalette1)
	dwb BulbasaurAnimatedObjPalette1, Bank(BulbasaurAnimatedObjPalette1)
	dwb BulbasaurAnimatedObjPalette1, Bank(BulbasaurAnimatedObjPalette1)
	dwb CharmanderAnimatedObjPalette1, Bank(CharmanderAnimatedObjPalette1)
	dwb CharmanderAnimatedObjPalette1, Bank(CharmanderAnimatedObjPalette1)
	dwb CharmanderAnimatedObjPalette1, Bank(CharmanderAnimatedObjPalette1)
	dwb SquirtleAnimatedObjPalette1, Bank(SquirtleAnimatedObjPalette1)
	dwb SquirtleAnimatedObjPalette1, Bank(SquirtleAnimatedObjPalette1)
	dwb SquirtleAnimatedObjPalette1, Bank(SquirtleAnimatedObjPalette1)
	dwb CaterpieAnimatedObjPalette1, Bank(CaterpieAnimatedObjPalette1)
	dwb CaterpieAnimatedObjPalette1, Bank(CaterpieAnimatedObjPalette1)
	dwb CaterpieAnimatedObjPalette1, Bank(CaterpieAnimatedObjPalette1)
	dwb WeedleAnimatedObjPalette1, Bank(WeedleAnimatedObjPalette1)
	dwb WeedleAnimatedObjPalette1, Bank(WeedleAnimatedObjPalette1)
	dwb WeedleAnimatedObjPalette1, Bank(WeedleAnimatedObjPalette1)
	dwb PidgeyAnimatedObjPalette1, Bank(PidgeyAnimatedObjPalette1)
	dwb PidgeyAnimatedObjPalette1, Bank(PidgeyAnimatedObjPalette1)
	dwb PidgeyAnimatedObjPalette1, Bank(PidgeyAnimatedObjPalette1)
	dwb RattataAnimatedObjPalette1, Bank(RattataAnimatedObjPalette1)
	dwb RattataAnimatedObjPalette1, Bank(RattataAnimatedObjPalette1)
	dwb SpearowAnimatedObjPalette1, Bank(SpearowAnimatedObjPalette1)
	dwb SpearowAnimatedObjPalette1, Bank(SpearowAnimatedObjPalette1)
	dwb EkansAnimatedObjPalette1, Bank(EkansAnimatedObjPalette1)
	dwb EkansAnimatedObjPalette1, Bank(EkansAnimatedObjPalette1)
	dwb PikachuAnimatedObjPalette1, Bank(PikachuAnimatedObjPalette1)
	dwb PikachuAnimatedObjPalette1, Bank(PikachuAnimatedObjPalette1)
	dwb SandshrewAnimatedObjPalette1, Bank(SandshrewAnimatedObjPalette1)
	dwb SandshrewAnimatedObjPalette1, Bank(SandshrewAnimatedObjPalette1)
	dwb NidoranFAnimatedObjPalette1, Bank(NidoranFAnimatedObjPalette1)
	dwb NidoranFAnimatedObjPalette1, Bank(NidoranFAnimatedObjPalette1)
	dwb NidoranFAnimatedObjPalette1, Bank(NidoranFAnimatedObjPalette1)
	dwb NidoranMAnimatedObjPalette1, Bank(NidoranMAnimatedObjPalette1)
	dwb NidoranMAnimatedObjPalette1, Bank(NidoranMAnimatedObjPalette1)
	dwb NidoranMAnimatedObjPalette1, Bank(NidoranMAnimatedObjPalette1)
	dwb ClefairyAnimatedObjPalette1, Bank(ClefairyAnimatedObjPalette1)
	dwb ClefairyAnimatedObjPalette1, Bank(ClefairyAnimatedObjPalette1)
	dwb VulpixAnimatedObjPalette1, Bank(VulpixAnimatedObjPalette1)
	dwb VulpixAnimatedObjPalette1, Bank(VulpixAnimatedObjPalette1)
	dwb JigglypuffAnimatedObjPalette1, Bank(JigglypuffAnimatedObjPalette1)
	dwb JigglypuffAnimatedObjPalette1, Bank(JigglypuffAnimatedObjPalette1)
	dwb ZubatAnimatedObjPalette1, Bank(ZubatAnimatedObjPalette1)
	dwb ZubatAnimatedObjPalette1, Bank(ZubatAnimatedObjPalette1)
	dwb OddishAnimatedObjPalette1, Bank(OddishAnimatedObjPalette1)
	dwb OddishAnimatedObjPalette1, Bank(OddishAnimatedObjPalette1)
	dwb OddishAnimatedObjPalette1, Bank(OddishAnimatedObjPalette1)
	dwb ParasAnimatedObjPalette1, Bank(ParasAnimatedObjPalette1)
	dwb ParasAnimatedObjPalette1, Bank(ParasAnimatedObjPalette1)
	dwb VenonatAnimatedObjPalette1, Bank(VenonatAnimatedObjPalette1)
	dwb VenonatAnimatedObjPalette1, Bank(VenonatAnimatedObjPalette1)
	dwb DiglettAnimatedObjPalette1, Bank(DiglettAnimatedObjPalette1)
	dwb DiglettAnimatedObjPalette1, Bank(DiglettAnimatedObjPalette1)
	dwb MeowthAnimatedObjPalette1, Bank(MeowthAnimatedObjPalette1)
	dwb MeowthAnimatedObjPalette1, Bank(MeowthAnimatedObjPalette1)
	dwb PsyduckAnimatedObjPalette1, Bank(PsyduckAnimatedObjPalette1)
	dwb PsyduckAnimatedObjPalette1, Bank(PsyduckAnimatedObjPalette1)
	dwb MankeyAnimatedObjPalette1, Bank(MankeyAnimatedObjPalette1)
	dwb MankeyAnimatedObjPalette1, Bank(MankeyAnimatedObjPalette1)
	dwb GrowlitheAnimatedObjPalette1, Bank(GrowlitheAnimatedObjPalette1)
	dwb GrowlitheAnimatedObjPalette1, Bank(GrowlitheAnimatedObjPalette1)
	dwb PoliwagAnimatedObjPalette1, Bank(PoliwagAnimatedObjPalette1)
	dwb PoliwagAnimatedObjPalette1, Bank(PoliwagAnimatedObjPalette1)
	dwb PoliwagAnimatedObjPalette1, Bank(PoliwagAnimatedObjPalette1)
	dwb AbraAnimatedObjPalette1, Bank(AbraAnimatedObjPalette1)
	dwb AbraAnimatedObjPalette1, Bank(AbraAnimatedObjPalette1)
	dwb AbraAnimatedObjPalette1, Bank(AbraAnimatedObjPalette1)
	dwb MachopAnimatedObjPalette1, Bank(MachopAnimatedObjPalette1)
	dwb MachopAnimatedObjPalette1, Bank(MachopAnimatedObjPalette1)
	dwb MachopAnimatedObjPalette1, Bank(MachopAnimatedObjPalette1)
	dwb BellsproutAnimatedObjPalette1, Bank(BellsproutAnimatedObjPalette1)
	dwb BellsproutAnimatedObjPalette1, Bank(BellsproutAnimatedObjPalette1)
	dwb BellsproutAnimatedObjPalette1, Bank(BellsproutAnimatedObjPalette1)
	dwb TentacoolAnimatedObjPalette1, Bank(TentacoolAnimatedObjPalette1)
	dwb TentacoolAnimatedObjPalette1, Bank(TentacoolAnimatedObjPalette1)
	dwb GeodudeAnimatedObjPalette1, Bank(GeodudeAnimatedObjPalette1)
	dwb GeodudeAnimatedObjPalette1, Bank(GeodudeAnimatedObjPalette1)
	dwb GeodudeAnimatedObjPalette1, Bank(GeodudeAnimatedObjPalette1)
	dwb PonytaAnimatedObjPalette1, Bank(PonytaAnimatedObjPalette1)
	dwb PonytaAnimatedObjPalette1, Bank(PonytaAnimatedObjPalette1)
	dwb SlowpokeAnimatedObjPalette1, Bank(SlowpokeAnimatedObjPalette1)
	dwb SlowpokeAnimatedObjPalette1, Bank(SlowpokeAnimatedObjPalette1)
	dwb MagnemiteAnimatedObjPalette1, Bank(MagnemiteAnimatedObjPalette1)
	dwb MagnemiteAnimatedObjPalette1, Bank(MagnemiteAnimatedObjPalette1)
	dwb FarfetchdAnimatedObjPalette1, Bank(FarfetchdAnimatedObjPalette1)
	dwb DoduoAnimatedObjPalette1, Bank(DoduoAnimatedObjPalette1)
	dwb DoduoAnimatedObjPalette1, Bank(DoduoAnimatedObjPalette1)
	dwb SeelAnimatedObjPalette1, Bank(SeelAnimatedObjPalette1)
	dwb SeelAnimatedObjPalette1, Bank(SeelAnimatedObjPalette1)
	dwb GrimerAnimatedObjPalette1, Bank(GrimerAnimatedObjPalette1)
	dwb GrimerAnimatedObjPalette1, Bank(GrimerAnimatedObjPalette1)
	dwb ShellderAnimatedObjPalette1, Bank(ShellderAnimatedObjPalette1)
	dwb ShellderAnimatedObjPalette1, Bank(ShellderAnimatedObjPalette1)
	dwb GastlyAnimatedObjPalette1, Bank(GastlyAnimatedObjPalette1)
	dwb GastlyAnimatedObjPalette1, Bank(GastlyAnimatedObjPalette1)
	dwb GastlyAnimatedObjPalette1, Bank(GastlyAnimatedObjPalette1)
	dwb OnixAnimatedObjPalette1, Bank(OnixAnimatedObjPalette1)
	dwb DrowzeeAnimatedObjPalette1, Bank(DrowzeeAnimatedObjPalette1)
	dwb DrowzeeAnimatedObjPalette1, Bank(DrowzeeAnimatedObjPalette1)
	dwb KrabbyAnimatedObjPalette1, Bank(KrabbyAnimatedObjPalette1)
	dwb KrabbyAnimatedObjPalette1, Bank(KrabbyAnimatedObjPalette1)
	dwb VoltorbAnimatedObjPalette1, Bank(VoltorbAnimatedObjPalette1)
	dwb VoltorbAnimatedObjPalette1, Bank(VoltorbAnimatedObjPalette1)
	dwb ExeggcuteAnimatedObjPalette1, Bank(ExeggcuteAnimatedObjPalette1)
	dwb ExeggcuteAnimatedObjPalette1, Bank(ExeggcuteAnimatedObjPalette1)
	dwb CuboneAnimatedObjPalette1, Bank(CuboneAnimatedObjPalette1)
	dwb CuboneAnimatedObjPalette1, Bank(CuboneAnimatedObjPalette1)
	dwb HitmonleeAnimatedObjPalette1, Bank(HitmonleeAnimatedObjPalette1)
	dwb HitmonchanAnimatedObjPalette1, Bank(HitmonchanAnimatedObjPalette1)
	dwb LickitungAnimatedObjPalette1, Bank(LickitungAnimatedObjPalette1)
	dwb KoffingAnimatedObjPalette1, Bank(KoffingAnimatedObjPalette1)
	dwb KoffingAnimatedObjPalette1, Bank(KoffingAnimatedObjPalette1)
	dwb RhyhornAnimatedObjPalette1, Bank(RhyhornAnimatedObjPalette1)
	dwb RhyhornAnimatedObjPalette1, Bank(RhyhornAnimatedObjPalette1)
	dwb ChanseyAnimatedObjPalette1, Bank(ChanseyAnimatedObjPalette1)
	dwb TangelaAnimatedObjPalette1, Bank(TangelaAnimatedObjPalette1)
	dwb KangaskhanAnimatedObjPalette1, Bank(KangaskhanAnimatedObjPalette1)
	dwb HorseaAnimatedObjPalette1, Bank(HorseaAnimatedObjPalette1)
	dwb HorseaAnimatedObjPalette1, Bank(HorseaAnimatedObjPalette1)
	dwb GoldeenAnimatedObjPalette1, Bank(GoldeenAnimatedObjPalette1)
	dwb GoldeenAnimatedObjPalette1, Bank(GoldeenAnimatedObjPalette1)
	dwb StaryuAnimatedObjPalette1, Bank(StaryuAnimatedObjPalette1)
	dwb StaryuAnimatedObjPalette1, Bank(StaryuAnimatedObjPalette1)
	dwb MrMimeAnimatedObjPalette1, Bank(MrMimeAnimatedObjPalette1)
	dwb ScytherAnimatedObjPalette1, Bank(ScytherAnimatedObjPalette1)
	dwb JynxAnimatedObjPalette1, Bank(JynxAnimatedObjPalette1)
	dwb ElectabuzzAnimatedObjPalette1, Bank(ElectabuzzAnimatedObjPalette1)
	dwb MagmarAnimatedObjPalette1, Bank(MagmarAnimatedObjPalette1)
	dwb PinsirAnimatedObjPalette1, Bank(PinsirAnimatedObjPalette1)
	dwb TaurosAnimatedObjPalette1, Bank(TaurosAnimatedObjPalette1)
	dwb MagikarpAnimatedObjPalette1, Bank(MagikarpAnimatedObjPalette1)
	dwb MagikarpAnimatedObjPalette1, Bank(MagikarpAnimatedObjPalette1)
	dwb LaprasAnimatedObjPalette1, Bank(LaprasAnimatedObjPalette1)
	dwb DittoAnimatedObjPalette1, Bank(DittoAnimatedObjPalette1)
	dwb EeveeAnimatedObjPalette1, Bank(EeveeAnimatedObjPalette1)
	dwb EeveeAnimatedObjPalette1, Bank(EeveeAnimatedObjPalette1)
	dwb EeveeAnimatedObjPalette1, Bank(EeveeAnimatedObjPalette1)
	dwb EeveeAnimatedObjPalette1, Bank(EeveeAnimatedObjPalette1)
	dwb PorygonAnimatedObjPalette1, Bank(PorygonAnimatedObjPalette1)
	dwb OmanyteAnimatedObjPalette1, Bank(OmanyteAnimatedObjPalette1)
	dwb OmanyteAnimatedObjPalette1, Bank(OmanyteAnimatedObjPalette1)
	dwb KabutoAnimatedObjPalette1, Bank(KabutoAnimatedObjPalette1)
	dwb KabutoAnimatedObjPalette1, Bank(KabutoAnimatedObjPalette1)
	dwb AerodactylAnimatedObjPalette1, Bank(AerodactylAnimatedObjPalette1)
	dwb SnorlaxAnimatedObjPalette1, Bank(SnorlaxAnimatedObjPalette1)
	dwb ArticunoAnimatedObjPalette1, Bank(ArticunoAnimatedObjPalette1)
	dwb ZapdosAnimatedObjPalette1, Bank(ZapdosAnimatedObjPalette1)
	dwb MoltresAnimatedObjPalette1, Bank(MoltresAnimatedObjPalette1)
	dwb DratiniAnimatedObjPalette1, Bank(DratiniAnimatedObjPalette1)
	dwb DratiniAnimatedObjPalette1, Bank(DratiniAnimatedObjPalette1)
	dwb DratiniAnimatedObjPalette1, Bank(DratiniAnimatedObjPalette1)
	dwb MewtwoAnimatedObjPalette1, Bank(MewtwoAnimatedObjPalette1)
	dwb MewAnimatedObjPalette1, Bank(MewAnimatedObjPalette1)

MonAnimatedPicPointers: ; 0x13264
	dwb BulbasaurAnimatedPic, Bank(BulbasaurAnimatedPic)
	dwb BulbasaurAnimatedPic, Bank(BulbasaurAnimatedPic)
	dwb BulbasaurAnimatedPic, Bank(BulbasaurAnimatedPic)
	dwb CharmanderAnimatedPic, Bank(CharmanderAnimatedPic)
	dwb CharmanderAnimatedPic, Bank(CharmanderAnimatedPic)
	dwb CharmanderAnimatedPic, Bank(CharmanderAnimatedPic)
	dwb SquirtleAnimatedPic, Bank(SquirtleAnimatedPic)
	dwb SquirtleAnimatedPic, Bank(SquirtleAnimatedPic)
	dwb SquirtleAnimatedPic, Bank(SquirtleAnimatedPic)
	dwb CaterpieAnimatedPic, Bank(CaterpieAnimatedPic)
	dwb CaterpieAnimatedPic, Bank(CaterpieAnimatedPic)
	dwb CaterpieAnimatedPic, Bank(CaterpieAnimatedPic)
	dwb WeedleAnimatedPic, Bank(WeedleAnimatedPic)
	dwb WeedleAnimatedPic, Bank(WeedleAnimatedPic)
	dwb WeedleAnimatedPic, Bank(WeedleAnimatedPic)
	dwb PidgeyAnimatedPic, Bank(PidgeyAnimatedPic)
	dwb PidgeyAnimatedPic, Bank(PidgeyAnimatedPic)
	dwb PidgeyAnimatedPic, Bank(PidgeyAnimatedPic)
	dwb RattataAnimatedPic, Bank(RattataAnimatedPic)
	dwb RattataAnimatedPic, Bank(RattataAnimatedPic)
	dwb SpearowAnimatedPic, Bank(SpearowAnimatedPic)
	dwb SpearowAnimatedPic, Bank(SpearowAnimatedPic)
	dwb EkansAnimatedPic, Bank(EkansAnimatedPic)
	dwb EkansAnimatedPic, Bank(EkansAnimatedPic)
	dwb PikachuAnimatedPic, Bank(PikachuAnimatedPic)
	dwb PikachuAnimatedPic, Bank(PikachuAnimatedPic)
	dwb SandshrewAnimatedPic, Bank(SandshrewAnimatedPic)
	dwb SandshrewAnimatedPic, Bank(SandshrewAnimatedPic)
	dwb NidoranFAnimatedPic, Bank(NidoranFAnimatedPic)
	dwb NidoranFAnimatedPic, Bank(NidoranFAnimatedPic)
	dwb NidoranFAnimatedPic, Bank(NidoranFAnimatedPic)
	dwb NidoranMAnimatedPic, Bank(NidoranMAnimatedPic)
	dwb NidoranMAnimatedPic, Bank(NidoranMAnimatedPic)
	dwb NidoranMAnimatedPic, Bank(NidoranMAnimatedPic)
	dwb ClefairyAnimatedPic, Bank(ClefairyAnimatedPic)
	dwb ClefairyAnimatedPic, Bank(ClefairyAnimatedPic)
	dwb VulpixAnimatedPic, Bank(VulpixAnimatedPic)
	dwb VulpixAnimatedPic, Bank(VulpixAnimatedPic)
	dwb JigglypuffAnimatedPic, Bank(JigglypuffAnimatedPic)
	dwb JigglypuffAnimatedPic, Bank(JigglypuffAnimatedPic)
	dwb ZubatAnimatedPic, Bank(ZubatAnimatedPic)
	dwb ZubatAnimatedPic, Bank(ZubatAnimatedPic)
	dwb OddishAnimatedPic, Bank(OddishAnimatedPic)
	dwb OddishAnimatedPic, Bank(OddishAnimatedPic)
	dwb OddishAnimatedPic, Bank(OddishAnimatedPic)
	dwb ParasAnimatedPic, Bank(ParasAnimatedPic)
	dwb ParasAnimatedPic, Bank(ParasAnimatedPic)
	dwb VenonatAnimatedPic, Bank(VenonatAnimatedPic)
	dwb VenonatAnimatedPic, Bank(VenonatAnimatedPic)
	dwb DiglettAnimatedPic, Bank(DiglettAnimatedPic)
	dwb DiglettAnimatedPic, Bank(DiglettAnimatedPic)
	dwb MeowthAnimatedPic, Bank(MeowthAnimatedPic)
	dwb MeowthAnimatedPic, Bank(MeowthAnimatedPic)
	dwb PsyduckAnimatedPic, Bank(PsyduckAnimatedPic)
	dwb PsyduckAnimatedPic, Bank(PsyduckAnimatedPic)
	dwb MankeyAnimatedPic, Bank(MankeyAnimatedPic)
	dwb MankeyAnimatedPic, Bank(MankeyAnimatedPic)
	dwb GrowlitheAnimatedPic, Bank(GrowlitheAnimatedPic)
	dwb GrowlitheAnimatedPic, Bank(GrowlitheAnimatedPic)
	dwb PoliwagAnimatedPic, Bank(PoliwagAnimatedPic)
	dwb PoliwagAnimatedPic, Bank(PoliwagAnimatedPic)
	dwb PoliwagAnimatedPic, Bank(PoliwagAnimatedPic)
	dwb AbraAnimatedPic, Bank(AbraAnimatedPic)
	dwb AbraAnimatedPic, Bank(AbraAnimatedPic)
	dwb AbraAnimatedPic, Bank(AbraAnimatedPic)
	dwb MachopAnimatedPic, Bank(MachopAnimatedPic)
	dwb MachopAnimatedPic, Bank(MachopAnimatedPic)
	dwb MachopAnimatedPic, Bank(MachopAnimatedPic)
	dwb BellsproutAnimatedPic, Bank(BellsproutAnimatedPic)
	dwb BellsproutAnimatedPic, Bank(BellsproutAnimatedPic)
	dwb BellsproutAnimatedPic, Bank(BellsproutAnimatedPic)
	dwb TentacoolAnimatedPic, Bank(TentacoolAnimatedPic)
	dwb TentacoolAnimatedPic, Bank(TentacoolAnimatedPic)
	dwb GeodudeAnimatedPic, Bank(GeodudeAnimatedPic)
	dwb GeodudeAnimatedPic, Bank(GeodudeAnimatedPic)
	dwb GeodudeAnimatedPic, Bank(GeodudeAnimatedPic)
	dwb PonytaAnimatedPic, Bank(PonytaAnimatedPic)
	dwb PonytaAnimatedPic, Bank(PonytaAnimatedPic)
	dwb SlowpokeAnimatedPic, Bank(SlowpokeAnimatedPic)
	dwb SlowpokeAnimatedPic, Bank(SlowpokeAnimatedPic)
	dwb MagnemiteAnimatedPic, Bank(MagnemiteAnimatedPic)
	dwb MagnemiteAnimatedPic, Bank(MagnemiteAnimatedPic)
	dwb FarfetchdAnimatedPic, Bank(FarfetchdAnimatedPic)
	dwb DoduoAnimatedPic, Bank(DoduoAnimatedPic)
	dwb DoduoAnimatedPic, Bank(DoduoAnimatedPic)
	dwb SeelAnimatedPic, Bank(SeelAnimatedPic)
	dwb SeelAnimatedPic, Bank(SeelAnimatedPic)
	dwb GrimerAnimatedPic, Bank(GrimerAnimatedPic)
	dwb GrimerAnimatedPic, Bank(GrimerAnimatedPic)
	dwb ShellderAnimatedPic, Bank(ShellderAnimatedPic)
	dwb ShellderAnimatedPic, Bank(ShellderAnimatedPic)
	dwb GastlyAnimatedPic, Bank(GastlyAnimatedPic)
	dwb GastlyAnimatedPic, Bank(GastlyAnimatedPic)
	dwb GastlyAnimatedPic, Bank(GastlyAnimatedPic)
	dwb OnixAnimatedPic, Bank(OnixAnimatedPic)
	dwb DrowzeeAnimatedPic, Bank(DrowzeeAnimatedPic)
	dwb DrowzeeAnimatedPic, Bank(DrowzeeAnimatedPic)
	dwb KrabbyAnimatedPic, Bank(KrabbyAnimatedPic)
	dwb KrabbyAnimatedPic, Bank(KrabbyAnimatedPic)
	dwb VoltorbAnimatedPic, Bank(VoltorbAnimatedPic)
	dwb VoltorbAnimatedPic, Bank(VoltorbAnimatedPic)
	dwb ExeggcuteAnimatedPic, Bank(ExeggcuteAnimatedPic)
	dwb ExeggcuteAnimatedPic, Bank(ExeggcuteAnimatedPic)
	dwb CuboneAnimatedPic, Bank(CuboneAnimatedPic)
	dwb CuboneAnimatedPic, Bank(CuboneAnimatedPic)
	dwb HitmonleeAnimatedPic, Bank(HitmonleeAnimatedPic)
	dwb HitmonchanAnimatedPic, Bank(HitmonchanAnimatedPic)
	dwb LickitungAnimatedPic, Bank(LickitungAnimatedPic)
	dwb KoffingAnimatedPic, Bank(KoffingAnimatedPic)
	dwb KoffingAnimatedPic, Bank(KoffingAnimatedPic)
	dwb RhyhornAnimatedPic, Bank(RhyhornAnimatedPic)
	dwb RhyhornAnimatedPic, Bank(RhyhornAnimatedPic)
	dwb ChanseyAnimatedPic, Bank(ChanseyAnimatedPic)
	dwb TangelaAnimatedPic, Bank(TangelaAnimatedPic)
	dwb KangaskhanAnimatedPic, Bank(KangaskhanAnimatedPic)
	dwb HorseaAnimatedPic, Bank(HorseaAnimatedPic)
	dwb HorseaAnimatedPic, Bank(HorseaAnimatedPic)
	dwb GoldeenAnimatedPic, Bank(GoldeenAnimatedPic)
	dwb GoldeenAnimatedPic, Bank(GoldeenAnimatedPic)
	dwb StaryuAnimatedPic, Bank(StaryuAnimatedPic)
	dwb StaryuAnimatedPic, Bank(StaryuAnimatedPic)
	dwb MrMimeAnimatedPic, Bank(MrMimeAnimatedPic)
	dwb ScytherAnimatedPic, Bank(ScytherAnimatedPic)
	dwb JynxAnimatedPic, Bank(JynxAnimatedPic)
	dwb ElectabuzzAnimatedPic, Bank(ElectabuzzAnimatedPic)
	dwb MagmarAnimatedPic, Bank(MagmarAnimatedPic)
	dwb PinsirAnimatedPic, Bank(PinsirAnimatedPic)
	dwb TaurosAnimatedPic, Bank(TaurosAnimatedPic)
	dwb MagikarpAnimatedPic, Bank(MagikarpAnimatedPic)
	dwb MagikarpAnimatedPic, Bank(MagikarpAnimatedPic)
	dwb LaprasAnimatedPic, Bank(LaprasAnimatedPic)
	dwb DittoAnimatedPic, Bank(DittoAnimatedPic)
	dwb EeveeAnimatedPic, Bank(EeveeAnimatedPic)
	dwb EeveeAnimatedPic, Bank(EeveeAnimatedPic)
	dwb EeveeAnimatedPic, Bank(EeveeAnimatedPic)
	dwb EeveeAnimatedPic, Bank(EeveeAnimatedPic)
	dwb PorygonAnimatedPic, Bank(PorygonAnimatedPic)
	dwb OmanyteAnimatedPic, Bank(OmanyteAnimatedPic)
	dwb OmanyteAnimatedPic, Bank(OmanyteAnimatedPic)
	dwb KabutoAnimatedPic, Bank(KabutoAnimatedPic)
	dwb KabutoAnimatedPic, Bank(KabutoAnimatedPic)
	dwb AerodactylAnimatedPic, Bank(AerodactylAnimatedPic)
	dwb SnorlaxAnimatedPic, Bank(SnorlaxAnimatedPic)
	dwb ArticunoAnimatedPic, Bank(ArticunoAnimatedPic)
	dwb ZapdosAnimatedPic, Bank(ZapdosAnimatedPic)
	dwb MoltresAnimatedPic, Bank(MoltresAnimatedPic)
	dwb DratiniAnimatedPic, Bank(DratiniAnimatedPic)
	dwb DratiniAnimatedPic, Bank(DratiniAnimatedPic)
	dwb DratiniAnimatedPic, Bank(DratiniAnimatedPic)
	dwb MewtwoAnimatedPic, Bank(MewtwoAnimatedPic)
	dwb MewAnimatedPic, Bank(MewAnimatedPic)

MonAnimatedSpriteTypes: ; 0x13429
; Each mon has an animated sprite tilemap type.
; $03 is bulbasaur's
; $00 is squirtle's
; All other mon's use $06
	db $03  ; BULBASAUR
	db $FF  ; IVYSAUR
	db $FF  ; VENUSAUR
	db $06  ; CHARMANDER
	db $FF  ; CHARMELEON
	db $FF  ; CHARIZARD
	db $00  ; SQUIRTLE
	db $FF  ; WARTORTLE
	db $FF  ; BLASTOISE
	db $06  ; CATERPIE
	db $FF  ; METAPOD
	db $FF  ; BUTTERFREE
	db $06  ; WEEDLE
	db $FF  ; KAKUNA
	db $FF  ; BEEDRILL
	db $06  ; PIDGEY
	db $FF  ; PIDGEOTTO
	db $FF  ; PIDGEOT
	db $06  ; RATTATA
	db $FF  ; RATICATE
	db $06  ; SPEAROW
	db $FF  ; FEAROW
	db $06  ; EKANS
	db $FF  ; ARBOK
	db $06  ; PIKACHU
	db $FF  ; RAICHU
	db $06  ; SANDSHREW
	db $FF  ; SANDSLASH
	db $06  ; NIDORAN_F
	db $FF  ; NIDORINA
	db $FF  ; NIDOQUEEN
	db $06  ; NIDORAN_M
	db $FF  ; NIDORINO
	db $FF  ; NIDOKING
	db $06  ; CLEFAIRY
	db $FF  ; CLEFABLE
	db $06  ; VULPIX
	db $FF  ; NINETALES
	db $06  ; JIGGLYPUFF
	db $FF  ; WIGGLYTUFF
	db $06  ; ZUBAT
	db $FF  ; GOLBAT
	db $06  ; ODDISH
	db $FF  ; GLOOM
	db $FF  ; VILEPLUME
	db $06  ; PARAS
	db $FF  ; PARASECT
	db $06  ; VENONAT
	db $FF  ; VENOMOTH
	db $06  ; DIGLETT
	db $FF  ; DUGTRIO
	db $06  ; MEOWTH
	db $FF  ; PERSIAN
	db $06  ; PSYDUCK
	db $FF  ; GOLDUCK
	db $06  ; MANKEY
	db $FF  ; PRIMEAPE
	db $06  ; GROWLITHE
	db $FF  ; ARCANINE
	db $06  ; POLIWAG
	db $FF  ; POLIWHIRL
	db $FF  ; POLIWRATH
	db $06  ; ABRA
	db $FF  ; KADABRA
	db $FF  ; ALAKAZAM
	db $06  ; MACHOP
	db $FF  ; MACHOKE
	db $FF  ; MACHAMP
	db $06  ; BELLSPROUT
	db $FF  ; WEEPINBELL
	db $FF  ; VICTREEBEL
	db $06  ; TENTACOOL
	db $FF  ; TENTACRUEL
	db $06  ; GEODUDE
	db $FF  ; GRAVELER
	db $FF  ; GOLEM
	db $06  ; PONYTA
	db $FF  ; RAPIDASH
	db $06  ; SLOWPOKE
	db $FF  ; SLOWBRO
	db $06  ; MAGNEMITE
	db $FF  ; MAGNETON
	db $06  ; FARFETCH_D
	db $06  ; DODUO
	db $FF  ; DODRIO
	db $06  ; SEEL
	db $FF  ; DEWGONG
	db $06  ; GRIMER
	db $FF  ; MUK
	db $06  ; SHELLDER
	db $FF  ; CLOYSTER
	db $06  ; GASTLY
	db $FF  ; HAUNTER
	db $FF  ; GENGAR
	db $06  ; ONIX
	db $06  ; DROWZEE
	db $FF  ; HYPNO
	db $06  ; KRABBY
	db $FF  ; KINGLER
	db $06  ; VOLTORB
	db $FF  ; ELECTRODE
	db $06  ; EXEGGCUTE
	db $FF  ; EXEGGUTOR
	db $06  ; CUBONE
	db $FF  ; MAROWAK
	db $06  ; HITMONLEE
	db $06  ; HITMONCHAN
	db $06  ; LICKITUNG
	db $06  ; KOFFING
	db $FF  ; WEEZING
	db $06  ; RHYHORN
	db $FF  ; RHYDON
	db $06  ; CHANSEY
	db $06  ; TANGELA
	db $06  ; KANGASKHAN
	db $06  ; HORSEA
	db $FF  ; SEADRA
	db $06  ; GOLDEEN
	db $FF  ; SEAKING
	db $06  ; STARYU
	db $FF  ; STARMIE
	db $06  ; MR_MIME
	db $06  ; SCYTHER
	db $06  ; JYNX
	db $06  ; ELECTABUZZ
	db $06  ; MAGMAR
	db $06  ; PINSIR
	db $06  ; TAUROS
	db $06  ; MAGIKARP
	db $FF  ; GYARADOS
	db $06  ; LAPRAS
	db $06  ; DITTO
	db $06  ; EEVEE
	db $FF  ; VAPOREON
	db $FF  ; JOLTEON
	db $FF  ; FLAREON
	db $06  ; PORYGON
	db $09  ; OMANYTE
	db $FF  ; OMASTAR
	db $06  ; KABUTO
	db $FF  ; KABUTOPS
	db $06  ; AERODACTYL
	db $06  ; SNORLAX
	db $06  ; ARTICUNO
	db $06  ; ZAPDOS
	db $06  ; MOLTRES
	db $06  ; DRATINI
	db $FF  ; DRAGONAIR
	db $FF  ; DRAGONITE
	db $06  ; MEWTWO
	db $06  ; MEW

MonAnimatedCollisionMaskPointers: ; 0x134c0
; Pointers to the collision masks of the animated sprites of mons.
; Note only, evolution mons use an arbitrary non-evolved mon entry, since it will never be used.
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb CharmanderAnimatedCollisionMask, Bank(CharmanderAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb SquirtleAnimatedCollisionMask, Bank(SquirtleAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb CaterpieAnimatedCollisionMask, Bank(CaterpieAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb WeedleAnimatedCollisionMask, Bank(WeedleAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb PidgeyAnimatedCollisionMask, Bank(PidgeyAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb RattataAnimatedCollisionMask, Bank(RattataAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb SpearowAnimatedCollisionMask, Bank(SpearowAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb EkansAnimatedCollisionMask, Bank(EkansAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb PikachuAnimatedCollisionMask, Bank(PikachuAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb SandshrewAnimatedCollisionMask, Bank(SandshrewAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb NidoranfAnimatedCollisionMask, Bank(NidoranfAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb NidoranmAnimatedCollisionMask, Bank(NidoranmAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb ClefairyAnimatedCollisionMask, Bank(ClefairyAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb VulpixAnimatedCollisionMask, Bank(VulpixAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb JigglypuffAnimatedCollisionMask, Bank(JigglypuffAnimatedCollisionMask)
	dwb BulbasaurAnimatedCollisionMask, Bank(BulbasaurAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb OddishAnimatedCollisionMask, Bank(OddishAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ParasAnimatedCollisionMask, Bank(ParasAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb VenonatAnimatedCollisionMask, Bank(VenonatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb DiglettAnimatedCollisionMask, Bank(DiglettAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb MeowthAnimatedCollisionMask, Bank(MeowthAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb PsyduckAnimatedCollisionMask, Bank(PsyduckAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb MankeyAnimatedCollisionMask, Bank(MankeyAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb GrowlitheAnimatedCollisionMask, Bank(GrowlitheAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb PoliwagAnimatedCollisionMask, Bank(PoliwagAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb AbraAnimatedCollisionMask, Bank(AbraAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb MachopAnimatedCollisionMask, Bank(MachopAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb BellsproutAnimatedCollisionMask, Bank(BellsproutAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb TentacoolAnimatedCollisionMask, Bank(TentacoolAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb GeodudeAnimatedCollisionMask, Bank(GeodudeAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb PonytaAnimatedCollisionMask, Bank(PonytaAnimatedCollisionMask)
	dwb ZubatAnimatedCollisionMask, Bank(ZubatAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb MagnemiteAnimatedCollisionMask, Bank(MagnemiteAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb FarfetchdAnimatedCollisionMask, Bank(FarfetchdAnimatedCollisionMask)
	dwb DoduoAnimatedCollisionMask, Bank(DoduoAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb SeelAnimatedCollisionMask, Bank(SeelAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb GrimerAnimatedCollisionMask, Bank(GrimerAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb ShellderAnimatedCollisionMask, Bank(ShellderAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb GastlyAnimatedCollisionMask, Bank(GastlyAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb OnixAnimatedCollisionMask, Bank(OnixAnimatedCollisionMask)
	dwb DrowzeeAnimatedCollisionMask, Bank(DrowzeeAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb KrabbyAnimatedCollisionMask, Bank(KrabbyAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb VoltorbAnimatedCollisionMask, Bank(VoltorbAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb ExeggcuteAnimatedCollisionMask, Bank(ExeggcuteAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb CuboneAnimatedCollisionMask, Bank(CuboneAnimatedCollisionMask)
	dwb SlowpokeAnimatedCollisionMask, Bank(SlowpokeAnimatedCollisionMask)
	dwb HitmonleeAnimatedCollisionMask, Bank(HitmonleeAnimatedCollisionMask)
	dwb HitmonchanAnimatedCollisionMask, Bank(HitmonchanAnimatedCollisionMask)
	dwb LickitungAnimatedCollisionMask, Bank(LickitungAnimatedCollisionMask)
	dwb KoffingAnimatedCollisionMask, Bank(KoffingAnimatedCollisionMask)
	dwb LickitungAnimatedCollisionMask, Bank(LickitungAnimatedCollisionMask)
	dwb RhyhornAnimatedCollisionMask, Bank(RhyhornAnimatedCollisionMask)
	dwb LickitungAnimatedCollisionMask, Bank(LickitungAnimatedCollisionMask)
	dwb ChanseyAnimatedCollisionMask, Bank(ChanseyAnimatedCollisionMask)
	dwb TangelaAnimatedCollisionMask, Bank(TangelaAnimatedCollisionMask)
	dwb KangaskhanAnimatedCollisionMask, Bank(KangaskhanAnimatedCollisionMask)
	dwb HorseaAnimatedCollisionMask, Bank(HorseaAnimatedCollisionMask)
	dwb LickitungAnimatedCollisionMask, Bank(LickitungAnimatedCollisionMask)
	dwb GoldeenAnimatedCollisionMask, Bank(GoldeenAnimatedCollisionMask)
	dwb LickitungAnimatedCollisionMask, Bank(LickitungAnimatedCollisionMask)
	dwb StaryuAnimatedCollisionMask, Bank(StaryuAnimatedCollisionMask)
	dwb LickitungAnimatedCollisionMask, Bank(LickitungAnimatedCollisionMask)
	dwb MrMimeAnimatedCollisionMask, Bank(MrMimeAnimatedCollisionMask)
	dwb ScytherAnimatedCollisionMask, Bank(ScytherAnimatedCollisionMask)
	dwb JynxAnimatedCollisionMask, Bank(JynxAnimatedCollisionMask)
	dwb ElectabuzzAnimatedCollisionMask, Bank(ElectabuzzAnimatedCollisionMask)
	dwb MagmarAnimatedCollisionMask, Bank(MagmarAnimatedCollisionMask)
	dwb PinsirAnimatedCollisionMask, Bank(PinsirAnimatedCollisionMask)
	dwb TaurosAnimatedCollisionMask, Bank(TaurosAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb LaprasAnimatedCollisionMask, Bank(LaprasAnimatedCollisionMask)
	dwb DittoAnimatedCollisionMask, Bank(DittoAnimatedCollisionMask)
	dwb EeveeAnimatedCollisionMask, Bank(EeveeAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb PorygonAnimatedCollisionMask, Bank(PorygonAnimatedCollisionMask)
	dwb OmanyteAnimatedCollisionMask, Bank(OmanyteAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb KabutoAnimatedCollisionMask, Bank(KabutoAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb AerodactylAnimatedCollisionMask, Bank(AerodactylAnimatedCollisionMask)
	dwb SnorlaxAnimatedCollisionMask, Bank(SnorlaxAnimatedCollisionMask)
	dwb ArticunoAnimatedCollisionMask, Bank(ArticunoAnimatedCollisionMask)
	dwb ZapdosAnimatedCollisionMask, Bank(ZapdosAnimatedCollisionMask)
	dwb MoltresAnimatedCollisionMask, Bank(MoltresAnimatedCollisionMask)
	dwb DratiniAnimatedCollisionMask, Bank(DratiniAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb MagikarpAnimatedCollisionMask, Bank(MagikarpAnimatedCollisionMask)
	dwb MewtwoAnimatedCollisionMask, Bank(MewtwoAnimatedCollisionMask)
	dwb MewAnimatedCollisionMask, Bank(MewAnimatedCollisionMask)

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
	ld hl, wd582
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wd582
	ld a, [wTimerMinutes]
	and $f
	call Func_1764f
	ld a, [wTimerSeconds]
	swap a
	and $f
	call Func_1764f
	ld a, [wTimerSeconds]
	and $f
	call Func_1764f
	ld a, e
	srl a
	srl a
	ld d, $90
	call Func_1764f
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
	ld a, [wd5f3]
	and a
	jr nz, .asm_14165
	jp Func_14210

.asm_14165
	callba Func_141f2
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	ld [hFarCallTempA], a
	ld a, Bank(Func_10301)
	ld hl, Func_10301
	call nz, BankSwitch
	ld a, [wd5f3]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_102bc)
	ld hl, Func_102bc
	call nz, BankSwitch
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

Func_143e1: ; 0x143e1
; not collisions.
	call Func_14474 ; voltorbs
	call Func_14498
	call Func_144b6
	call Func_144c0
	call Func_144da
	call Func_14439
	call Func_144ac
	jp Func_1441e

Func_143f9: ; 0x143f9
	ld a, [wBallYPos + 1]
	cp $56
	jr nc, .asm_14412
	call Func_1444d
	call Func_144cd
	call Func_14467
	call Func_1445a
	call Func_14443
	jp Func_1441e

.asm_14412
	call Func_14481
	call Func_144e4
	call Func_144a2
	jp Func_1448e

Func_1441e: ; 0x1441e
	xor a
	ld [wd578], a
	ld a, [wd551]
	and a
	ret z
	ld a, [wCurrentStage]
	ld hl, RedStageEvolutionTrinketCoordinatePointers
	ld c, a
	ld b, $0
	sla c
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PinballCollideWithPoints

Func_14439: ; 0x14439
	ld de, Data_145b5
	ld bc, wd5fe
	scf
	jp Func_2775

Func_14443: ; 0x14443
	ld de, Data_145bb
	ld bc, wd601
	scf
	jp Func_2775

Func_1444d: ; 0x1444d
	ld de, Data_145af
	ld hl, Data_1459d
	ld bc, wd5c7
	and a
	jp Func_2775

Func_1445a: ; 0x1445a
	ld de, Data_145c9
	ld hl, Data_145c1
	ld bc, wd60a
	and a
	jp Func_2775

Func_14467: ; 0x14467
	ld de, Data_144f4
	ld hl, Data_144ee
	ld bc, wd4ed
	and a
	jp Func_2775

Func_14474: ; 0x14474
	ld de, Data_14515
	ld hl, Data_144fd
	ld bc, wd4cb
	and a
	jp Func_2775

Func_14481: ; 0x14481
	ld de, Data_1452d
	ld hl, Data_14521
	ld bc, wd4d8
	and a
	jp Func_2775

Func_1448e: ; 0x1448e
	ld de, Data_14536
	ld bc, wd4dc
	scf
	jp Func_2775

Func_14498: ; 0x14498
	ld de, Data_1453c
	ld bc, wd507
	scf
	jp Func_2775

Func_144a2: ; 0x144a2
	ld de, Data_14542
	ld bc, wd50d
	scf
	jp Func_2775

Func_144ac: ; 0x144ac
	ld de, Data_14551
	ld bc, wd5f7
	scf
	jp Func_2775

Func_144b6: ; 0x144b6
	ld de, Data_1455d
	ld bc, wd51f
	scf
	jp Func_2775

Func_144c0: ; 0x144c0
	ld de, Data_1457d
	ld hl, Data_14578
	ld bc, wd500
	and a
	jp Func_2775

Func_144cd: ; 0x144cd
	ld de, Data_14588
	ld hl, Data_14583
	ld bc, wd500
	and a
	jp Func_2775

Func_144da: ; 0x144da
	ld de, Data_1458e
	ld bc, wd4fb
	scf
	jp Func_2775

Func_144e4: ; 0x144e4
	ld de, Data_14594
	ld bc, wd515
	scf
	jp Func_2775

Data_144ee:
	dr $144ee, $144f4

Data_144f4:
	dr $144f4, $144fd

Data_144fd:
	dr $144fd, $14515

Data_14515:
	dr $14515, $14521

Data_14521:
	dr $14521, $1452d

Data_1452d:
	dr $1452d, $14536

Data_14536:
	dr $14536, $1453c

Data_1453c:
	dr $1453c, $14542

Data_14542:
	dr $14542, $14551

Data_14551:
	dr $14551, $1455d

Data_1455d:
	dr $1455d, $14578

Data_14578:
	dr $14578, $1457d

Data_1457d:
	dr $1457d, $14583

Data_14583:
	dr $14583, $14588

Data_14588:
	dr $14588, $1458e

Data_1458e:
	dr $1458e, $14594

Data_14594:
	dr $14594, $1459d

Data_1459d:
	dr $1459d, $145af

Data_145af:
	dr $145af, $145b5

Data_145b5:
	dr $145b5, $145bb

Data_145bb:
	dr $145bb, $145c1

Data_145c1:
	dr $145c1, $145c9

Data_145c9:
	dr $145c9, $145d2

RedStageEvolutionTrinketCoordinatePointers: ; 0x145d2
	dw RedStageTopEvolutionTrinketCoords
	dw RedStageBottomEvolutionTrinketCoords

RedStageTopEvolutionTrinketCoords: ; 0x156d6
; First byte is just non-zero to signify that the array hasn't ended.
; Second byte is x coordinate.
; Third byte is y coordinate.
	db $01, $44, $14
	db $01, $2A, $1A
	db $01, $5E, $1A
	db $01, $11, $2D
	db $01, $77, $2D
	db $01, $16, $3E
	db $01, $77, $3E
	db $01, $06, $6D
	db $01, $83, $6D
	db $01, $41, $82
	db $01, $51, $82
	db $01, $69, $82
	db $00  ; terminator

RedStageBottomEvolutionTrinketCoords: ; 0x145fb
; First byte is just non-zero to signify that the array hasn't ended.
; Second byte is x coordinate.
; Third byte is y coordinate.
	db $01, $35, $1B
	db $01, $53, $1B
	db $01, $29, $1F
	db $01, $5F, $1F
	db $01, $26, $34
	db $01, $62, $34
	db $00  ; terminator

Func_1460e: ; 0x1460e
; not collisions
	call Func_14d85
	call Func_14dea
	call Func_1535d
	call HandleBallTypeUpgradeCounterRedField
	call Func_15270
	call Func_1581f
	call Func_1660c
	call Func_16781
	call Func_15e93
	call Func_160f0
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
	call Func_147aa
	call Func_14880
	call Func_14e10
	call Func_154a9
	call HandleBallTypeUpgradeCounterRedField
	call Func_151cb
	call Func_1652d
	call Func_1660c
	call Func_167ff
	call Func_169a6
	call Func_16d9d
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
	ld a, [wd5c7]
	and a
	ret z
	xor a
	ld [wd5c7], a
	ld a, $1
	ld [wBallHitWildMon], a
	lb de, $00, $06
	call PlaySoundEffect
	ret

Func_147aa: ; 0x147aa
	ld a, [wd4ed]
	and a
	jp z, .asm_14834
	xor a
	ld [wd4ed], a
	ld a, [wd4ee]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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

Func_14d85: ; 0x14d85
	ld a, [wd4cb]
	and a
	jr z, .asm_14db9
	xor a
	ld [wd4cb], a
	call Func_14dc9
	ld a, $10
	ld [wd4d6], a
	ld a, [wd4cc]
	sub $3
	ld [wd4d7], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.asm_14db9
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $0e
	call PlaySoundEffect
	ret

Func_14dea: ; 0x14dea
	ld a, [wd507]
	and a
	jr z, Func_14e10
	xor a
	ld [wd507], a
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
	ld a, [wd50d]
	and a
	jr z, .asm_15229
	xor a
	ld [wd50d], a
	ld a, [wd513]
	and a
	jr nz, .asm_15229
	ld a, [wd50e]
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

Func_1535d: ; 0x1535d
	ld a, [wd5f7]
	and a
	jp z, .asm_1544c
	xor a
	ld [wd5f7], a
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
	ld a, [wd5f8]
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
	call Func_155a7
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

HandleBallTypeUpgradeCounterRedField: ; 0x15575
	ld a, [wd5f3]
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
	call Func_155a7
	ret

Func_155a7: ; 0x155a7
	ld a, [wBallType]
	ld c, a
	sla c
	ld b, $0
	ld hl, Data_155d7
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $5
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

Data_155d7:
	dw Data_155e3
	dw Data_155e3
	dw Data_155fa
	dw Data_15611
	dw Data_15611
	dw Data_15628

Data_155e3:
	db 11
	dw Data_1563f
	dw Data_15649
	dw Data_15653
	dw Data_1565d
	dw Data_15667
	dw Data_15671
	dw Data_1567b
	dw Data_15685
	dw Data_1568f
	dw Data_15699
	dw Data_156a3

Data_155fa:
	db 11
	dw Data_156ad
	dw Data_156b7
	dw Data_156c1
	dw Data_156cb
	dw Data_156d5
	dw Data_156df
	dw Data_156e9
	dw Data_156f3
	dw Data_156fd
	dw Data_15707
	dw Data_15711

Data_15611:
	db 11
	dw Data_1571b
	dw Data_15725
	dw Data_1572f
	dw Data_15739
	dw Data_15743
	dw Data_1574d
	dw Data_15757
	dw Data_15761
	dw Data_1576b
	dw Data_15775
	dw Data_1577f

Data_15628:
	db 11
	dw Data_15789
	dw Data_15793
	dw Data_1579d
	dw Data_157a7
	dw Data_157b1
	dw Data_157bb
	dw Data_157c5
	dw Data_157cf
	dw Data_157d9
	dw Data_157e3
	dw Data_157ed

Data_1563f:
	dr $1563f, $15649

Data_15649:
	dr $15649, $15653

Data_15653:
	dr $15653, $1565d

Data_1565d:
	dr $1565d, $15667

Data_15667:
	dr $15667, $15671

Data_15671:
	dr $15671, $1567b

Data_1567b:
	dr $1567b, $15685

Data_15685:
	dr $15685, $1568f

Data_1568f:
	dr $1568f, $15699

Data_15699:
	dr $15699, $156a3

Data_156a3:
	dr $156a3, $156ad

Data_156ad:
	dr $156ad, $156b7

Data_156b7:
	dr $156b7, $156c1

Data_156c1:
	dr $156c1, $156cb

Data_156cb:
	dr $156cb, $156d5

Data_156d5:
	dr $156d5, $156df

Data_156df:
	dr $156df, $156e9

Data_156e9:
	dr $156e9, $156f3

Data_156f3:
	dr $156f3, $156fd

Data_156fd:
	dr $156fd, $15707

Data_15707:
	dr $15707, $15711

Data_15711:
	dr $15711, $1571b

Data_1571b:
	dr $1571b, $15725

Data_15725:
	dr $15725, $1572f

Data_1572f:
	dr $1572f, $15739

Data_15739:
	dr $15739, $15743

Data_15743:
	dr $15743, $1574d

Data_1574d:
	dr $1574d, $15757

Data_15757:
	dr $15757, $15761

Data_15761:
	dr $15761, $1576b

Data_1576b:
	dr $1576b, $15775

Data_15775:
	dr $15775, $1577f

Data_1577f:
	dr $1577f, $15789

Data_15789:
	dr $15789, $15793

Data_15793:
	dr $15793, $1579d

Data_1579d:
	dr $1579d, $157a7

Data_157a7:
	dr $157a7, $157b1

Data_157b1:
	dr $157b1, $157bb

Data_157bb:
	dr $157bb, $157c5

Data_157c5:
	dr $157c5, $157cf

Data_157cf:
	dr $157cf, $157d9

Data_157d9:
	dr $157d9, $157e3

Data_157e3:
	dr $157e3, $157ed

Data_157ed:
	dr $157ed, $157f7

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

Func_1581f: ; 0x1581f
	ld a, [wd51f]
	and a
	ret z
	xor a
	ld [wd51f], a
	ld bc, FivePoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd520]
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
	ld a, $5
	call Func_10aa
	ld a, [wStageCollisionState]
	ld [wd7f2], a
	ret

Data_15a3f:
	dr $15a3f, $15d05

Data_15d05:
	dr $15d05, $15e93

Func_15e93: ; 0x15e93
	ld a, [wd4fb]
	and a
	jr z, .asm_15eda
	xor a
	ld [wd4fb], a
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
	jr nz, .asm_15f11
	xor a
.asm_15f11
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
.noCatchEmMode
	ld hl, wd62a
	call Func_e4a
	ret nc
	ld c, $19
	call Func_e55
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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
	ld a, [wd4d8]
	and a
	jr z, .asm_15f99
	call Func_5fb8
	call Func_15fa6
	xor a
	ld [wd4d8], a
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
	ld a, [wd4d9]
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
	ld a, $5
	call Func_10aa
	ret

Func_15fda: ; 0x15fda
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wd4d9]
	sub $6
	ld c, a
	ld b, $0
	ld hl, Data_1600e
	add hl, bc
	ld a, [wd7ea]
	add [hl]
	ld [wd7ea], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

Data_1600e:
	dr $1600e, $16010

Data_16010:
	dr $16010, $16080

Data_16080:
	dr $16080, $160f0

Func_160f0: ; 0x160f0
	ld a, [wd5fe]
	and a
	jr z, .asm_16137
	xor a
	ld [wd5fe], a
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
	ld a, [wd601]
	and a
	jr z, .asm_162ae
	xor a
	ld [wd601], a
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
	ld a, $5
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30256)
	ld hl, Func_30256
	call nz, BankSwitch
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
	ld a, [wd4dc]
	and a
	ret z
	xor a
	ld [wd4dc], a
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
	ld [wd4ec], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_f269)
	ld hl, Func_f269
	call nz, BankSwitch
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

Func_1660c: ; 0x1660c
	ld a, [wd515]
	and a
	jr z, .asm_1667b
	xor a
	ld [wd515], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1667b
	ld a, [wd51d]
	and a
	jr nz, .asm_16634
	ld a, [wd516]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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

Func_16781: ; 0x16781
	ld a, [wd500]
	and a
	jr z, .asm_167bd
	xor a
	ld [wd500], a
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
	ld a, [wd500]
	and a
	jr z, .asm_16839
	xor a
	ld [wd500], a
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
	ld a, $5
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
	ld a, $5
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
	ld a, $5
	call Func_10aa
	ret

Data_169ed:
	dr $169ed, $16bef

Data_16bef:
	dr $16bef, $16d9d

Func_16d9d: ; 016d9d
	ld a, [wd60a]
	and a
	jp z, Func_16e51
	xor a
	ld [wd60a], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wd60b]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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
	ld a, $5
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
	ld a, $5
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
	ld a, $5
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
	call Func_175a4
	call Func_17cc4
	call Func_17d34
	call Func_17d59
	call Func_17d7a
	call Func_17d92
	call Func_17de1
	call Func_17e81
	call Func_17efb
	call Func_17f64
	ret

Func_1757e: ; 0x1757e
	ld bc, $7f00
	call Func_175a4
	call Func_17c67
	call Func_17c96
	call Func_17e08
	callba Func_e4a1
	call Func_17e81
	call Func_17f0f
	call Func_17f75
	call Func_17fca
	ret

Func_175a4: ; 0x175a4
	ld a, [wd57d]
	and a
	ret z
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, DrawTimer
	ld a, [wd580]
	and a
	ret z
	ld a, [wd581]
	and a
	jr z, .asm_175be
	dec a
	ld [wd581], a
	ret

.asm_175be
	call Func_1762f
	ld hl, wd582
	ld a, [wTimerMinutes]
	and $f
	call Func_1764f
	ld a, [wTimerSeconds]
	swap a
	and $f
	call Func_1764f
	ld a, [wTimerSeconds]
	and $f
	call Func_1764f
	ld d, $0
	ld hl, Data_17615
	add hl, de
	ld a, [hli]
	call Func_17627
	ld a, [hli]
	call Func_17627
	ld a, [hli]
	call Func_17627
	ld a, [hli]
	call Func_17627
	ret

DrawTimer: ; 0x175f5
; Loads the OAM data for the timer in the top-right corner of the screen.
	ld a, [wTimerMinutes]
	and $f
	call DrawTimerDigit
	ld a, $a  ; colon
	call DrawTimerDigit
	ld a, [wTimerSeconds]
	swap a
	and $f
	call DrawTimerDigit  ; tens digit of the minutes
	ld a, [wTimerSeconds]
	and $f
	call DrawTimerDigit  ; ones digit of the minutes
	ret

Data_17615:
	db $d7, $da, $d8, $d9
	db $dc, $df, $dd, $de
	db $dc, $db, $dd, $de
	db $f5, $f8, $f6, $f7

DrawTimerDigit: ; 0x17625
	add $b1  ; the timer digits' OAM ids start at $b1
Func_17627: ; 0x17627
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

Func_1764f: ; 0x1764f
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
	ld a, $5
	call Func_10aa
	ret

Data_17679:
INCLUDE "data/unknown_17679.asm"

Func_17c67: ; 0x17c67
	ld a, [wd5f3]
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
	ld hl, Data_17c89
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17c89:
	dr $17c89, $17c96

Func_17c96: ; 0x17c96
	ld a, [wd5bb]
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
	ld hl, Data_17cb8
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_17cb8:
	dr $17cb8, $17cc4

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

Func_17e08: ; 0x17e08
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
	ld hl, Data_17e4b
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

Data_17e4b:
	dr $17e4b, $17e81

Func_17e81: ; 0x17e81
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
	ld hl, wd4cb
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

Func_1805f: ; 0x1805f
	ret

Func_18060: ; 0x18060
	ret

Func_18061: ; 0x18061
	ret

Func_18062: ; 0x18062
	callba Func_1448e
	ret

Func_1806d: ; 0x1806d
	ret

Func_1806e: ; 0x1806e
	callba Func_1652d
	ret

Func_18079: ; 0x18079
	callba Func_17e81
	ret

Func_18084: ; 0x18084
	callba Func_e4a1
	callba Func_17e81
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
	ld [wd7ab], a
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

Func_181b1: ; 0x181b1
	call Func_181be
	call Func_18259
	call Func_182e4
	call Func_18350
	ret

Func_181be: ; 0x181be
	ld a, [wd659]
	and a
	ret z
	ld a, [wd65f]
	ld b, a
	ld a, [wd661]
	add $10
	ld c, a
	ld a, [wd65b]
	call Func_1820d
	ld a, $1
	jr c, .asm_181fe
	ld a, [wd668]
	ld b, a
	ld a, [wd66a]
	add $10
	ld c, a
	ld a, [wd664]
	call Func_1820d
	ld a, $2
	jr c, .asm_181fe
	ld a, [wd671]
	ld b, a
	ld a, [wd673]
	add $10
	ld c, a
	ld a, [wd66d]
	call Func_1820d
	ld a, $3
	ret nc
.asm_181fe
	ld [wd4eb], a
	ld [wd657], a
	add $4
	ld [wd4ea], a
	ld [wd658], a
	ret

Func_1820d: ; 0x1820d
	cp $4
	jr z, .asm_18257
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .asm_18257
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
	jr nc, .asm_18257
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
	ld de, Data_e9100
	add hl, de
	ld a, BANK(Data_e9100)
	call ReadByteFromBank
	bit 7, a
	jr nz, .asm_18257
	sla a
	ld [wd7ea], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.asm_18257
	and a
	ret

Func_18259: ; 0x18259
	ld a, [wd67e]
	and a
	ret z
	ld a, [wd684]
	add $fe
	ld b, a
	ld a, [wd686]
	add $c
	ld c, a
	ld a, [wd680]
	call Func_18298
	ld a, $1
	jr c, .asm_18289
	ld a, [wd68d]
	add $fe
	ld b, a
	ld a, [wd68f]
	add $c
	ld c, a
	ld a, [wd689]
	call Func_18298
	ld a, $2
	ret nc
.asm_18289
	ld [wd4eb], a
	ld [wd67c], a
	add $7
	ld [wd4ea], a
	ld [wd67d], a
	ret

Func_18298: ; 0x18298
	cp $5
	jr z, .asm_182e2
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .asm_182e2
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $28
	jr nc, .asm_182e2
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
	ld de, Data_e8c00
	add hl, de
	ld a, BANK(Data_e8c00)
	call ReadByteFromBank
	bit 7, a
	jr nz, .asm_182e2
	sla a
	ld [wd7ea], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.asm_182e2
	and a
	ret

Func_182e4: ; 0x182e4
	ld a, [wd698]
	and a
	ret z
	ld a, [wd69e]
	ld b, a
	ld a, [wd6a0]
	add $c
	ld c, a
	call Func_18308
	ld a, $1
	ret nc
	ld [wd4eb], a
	ld [wd696], a
	add $9
	ld [wd4ea], a
	ld [wd697], a
	ret

Func_18308: ; 0x18308
	ld a, [wBallXPos + 1]
	sub b
	cp $30
	jr nc, .asm_1834e
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $40
	jr nc, .asm_1834e
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
	ld de, Data_e8000
	add hl, de
	ld a, BANK(Data_e8000)
	call ReadByteFromBank
	bit 7, a
	jr nz, .asm_1834e
	sla a
	ld [wd7ea], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.asm_1834e
	and a
	ret

Func_18350: ; 0x18350
	ld de, Data_18368
	ld hl, Data_1835d
	ld bc, wd654
	and a
	jp Func_2775

Data_1835d:
	dr $1835d, $18368

Data_18368:
	dr $18368, $18377

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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wd69f]
	add $0
	ld [wd69f], a
	ld a, [wd6a0]
	adc $ff
	ld [wd6a0], a
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
	ld a, [wd6a0]
	add $80
	cp $a0
	jr nc, .asm_188da
	ld a, [wd69a]
	and a
	jr z, .asm_188ca
	ld a, [wd69f]
	add $0
	ld [wd69f], a
	ld a, [wd6a0]
	adc $3
	ld [wd6a0], a
	jr .asm_188da

.asm_188ca
	ld a, [wd69f]
	add $0
	ld [wd69f], a
	ld a, [wd6a0]
	adc $1
	ld [wd6a0], a
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
	ld a, [wd69f]
	add $0
	ld [wd69f], a
	ld a, [wd6a0]
	adc $fd
	ld [wd6a0], a
	jr .asm_18945

.asm_18935
	ld a, [wd69f]
	add $0
	ld [wd69f], a
	ld a, [wd6a0]
	adc $ff
	ld [wd6a0], a
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
	ld a, [wd654]
	and a
	jr z, .asm_18d71
	xor a
	ld [wd654], a
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
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
	ld a, $6
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
	callba Func_175a4
	call Func_19020
	call Func_190b9
	call Func_19185
	callba Func_e4a1
	callba Func_17e81
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
	ld hl, Data_1906b
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_1906b:
	dr $1906b, $19070

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
	ld hl, Data_190fe
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_190fe:
	dr $190fe, $19104

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
	ld hl, Data_19145
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
	ld a, $21
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

Data_19145:
	dr $19145, $19185

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
	ld hl, Data_191c4
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_191c4:
	dr $191c4, $191cb

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
	ld [wd7ab], a
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

Func_19330: ; 0x19330
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
	ld [wd4eb], a
	ld [wd6b4], a
	add $0
	ld [wd4ea], a
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
	ld a, [wd4ea]
	inc a
	jr nz, .asm_1944f
	ld a, [wd6aa]
	bit 7, a
	jr nz, .asm_1944f
	ld a, [wd7e9]
	and a
	ret z
	ld a, [wd7f5]
	sub $10
	ret c
	cp $c
	ret nc
	ld a, $1
	ld [wd4eb], a
	add $6
	ld [wd4ea], a
	ld b, a
	ld hl, wd6aa
	ld [hl], $0
	ld a, [wd4ec]
	cp b
	jr z, .asm_1944f
	ld a, [wd4eb]
	ld [hli], a
	ld a, [wd4ea]
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
	ld a, $6
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
	callba Func_175a4
	call Func_1999d
	callba Func_e4a1
	callba Func_17e81
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
	ld hl, Data_19995
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_19995:
	dr $19995, $1999d

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
	ld hl, Data_199e6
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_199e6:
	dr $199e6, $199f2

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
	ld [wd7ab], a
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

Func_19ab3: ; 0x19ab3
	call Func_19aba
	call Func_19b4b
	ret

Func_19aba: ; 0x19aba
	ld a, [wd4ea]
	inc a
	jr nz, .asm_19b16
	ld a, [wd73b]
	bit 7, a
	jr nz, .asm_19b16
	ld a, [wd7e9]
	and a
	ret z
	ld a, [wd7f5]
	sub $19
	ret c
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
	ld [wd4eb], a
	add $0
	ld [wd4ea], a
	ld b, a
	ld hl, wd73b
	ld [hl], $0
	ld a, [wd4ec]
	cp b
	jr z, .asm_19b16
	ld a, [wd4eb]
	ld [hli], a
	ld a, [wd4ea]
	ld [hl], a
	scf
	ret

.asm_19b16
	and a
	ret

Data_19b18:
	dr $19b18, $19b4b

Func_19b4b: ; 0x19b4b
	ld a, [wd4ea]
	inc a
	jr nz, .asm_19b86
	ld a, [wd75f]
	bit 7, a
	jr nz, .asm_19b86
	ld a, [wd7e9]
	and a
	ret z
	ld a, [wd7f5]
	sub $14
	ret c
	cp $5
	ret nc
	ld a, $1
	ld [wd4eb], a
	add $1f
	ld [wd4ea], a
	ld b, a
	ld hl, wd75f
	ld [hl], $0
	ld a, [wd4ec]
	cp b
	jr z, .asm_19b86
	ld a, [wd4eb]
	ld [hli], a
	ld a, [wd4ea]
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
	ld a, $6
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
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
	callba Func_e4a1
	callba Func_17e81
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
	ld hl, Data_1accf
	add hl, de
	ld a, [hl]
	bit 7, a
	call z, LoadOAMData2
	ret

Data_1accf:
	dr $1accf, $1acde

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
	ld [wd7ab], a
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
	ld a, [wd5f3]
	and a
	jr nz, .asm_1c31f
	jp Func_1c3ca

.asm_1c31f
	callba Func_1c3ac
	callba Func_10362
	ld a, [hGameBoyColorFlag]
	and a
	ld [hFarCallTempA], a
	ld a, Bank(Func_10301)
	ld hl, Func_10301
	call nz, BankSwitch
	ld a, [wd5f3]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_102bc)
	ld hl, Func_102bc
	call nz, BankSwitch
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

Func_1c520: ; 0x1c520
	call Func_1c55a ; shellders
	call Func_1c567 ; spinner
	call Func_1c57e
	call Func_1c592
	call Func_1c588
	call Func_1c5c0
	call Func_1c5eb
	ret

Func_1c536: ; 0x1c536
	ld a, [wBallYPos + 1]
	cp $56
	jr nc, .asm_1c54d
	call Func_1c5de
	call Func_1c5b3
	call Func_1c5a6
	call Func_1c5d4
	call Func_1c5eb
	ret

.asm_1c54d
	call Func_1c571
	call Func_1c59c
	call Func_1c5ca
	call Func_1c607
	ret

Func_1c55a: ; 0x1c55a
	ld de, Data_1c644
	ld hl, Data_1c62e
	ld bc, wd4cb
	and a
	jp Func_2775

Func_1c567: ; 0x1c567
	ld de, Data_1c650
	ld bc, wd507
	scf
	jp Func_2775

Func_1c571: ; 0x1c571
	ld de, Data_1c625
	ld hl, Data_1c611
	ld bc, wd4d8
	and a
	jp Func_2775

Func_1c57e: ; 0x1c57e
	ld de, Data_1c656
	ld bc, wd51f
	scf
	jp Func_2775

Func_1c588: ; 0x1c588
	ld de, Data_1c665
	ld bc, wd635
	scf
	jp Func_2775

Func_1c592: ; 0x1c592
	ld de, Data_1c66b
	ld bc, wd630
	scf
	jp Func_2775

Func_1c59c: ; 0x1c59c
	ld de, Data_1c671
	ld bc, wd515
	scf
	jp Func_2775

Func_1c5a6: ; 0x1c5a6
	ld de, Data_1c686
	ld hl, Data_1c67a
	ld bc, wd60a
	and a
	jp Func_2775

Func_1c5b3: ; 0x1c5b3
	ld de, Data_1c695
	ld hl, Data_1c68f
	ld bc, wd4ed
	and a
	jp Func_2775

Func_1c5c0: ; 0x1c5c0
	ld de, Data_1c69e
	ld bc, wd5f7
	scf
	jp Func_2775

Func_1c5ca: ; 0x1c5ca
	ld de, Data_1c6aa
	ld bc, wd50d
	scf
	jp Func_2775

Func_1c5d4: ; 0x1c5d4
	ld de, Data_1c6b9
	ld bc, wd601
	scf
	jp Func_2775

Func_1c5de: ; 0x1c5de
	ld de, Data_1c6d1
	ld hl, Data_1c6bf
	ld bc, wd5c7
	and a
	jp Func_2775

Func_1c5eb: ; 0x1c5eb
	xor a
	ld [wd578], a
	ld a, [wd551]
	and a
	ret z
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_1c601
	ld hl, BlueTopEvolutionTrinketCoords
	jp PinballCollideWithPoints

.asm_1c601
	ld hl, BlueBottomEvolutionTrinketCoords
	jp PinballCollideWithPoints

Func_1c607: ; 0x1c607
	ld de, Data_1c70f
	ld bc, wd4dc
	scf
	jp Func_2775

Data_1c611:
	dr $1c611, $1c625

Data_1c625:
	dr $1c625, $1c62e

Data_1c62e:
	dr $1c62e, $1c644

Data_1c644:
	dr $1c644, $1c650

Data_1c650:
	dr $1c650, $1c656

Data_1c656:
	dr $1c656, $1c665

Data_1c665:
	dr $1c665, $1c66b

Data_1c66b:
	dr $1c66b, $1c671

Data_1c671:
	dr $1c671, $1c67a

Data_1c67a:
	dr $1c67a, $1c686

Data_1c686:
	dr $1c686, $1c68f

Data_1c68f:
	dr $1c68f, $1c695

Data_1c695:
	dr $1c695, $1c69e

Data_1c69e:
	dr $1c69e, $1c6aa

Data_1c6aa:
	dr $1c6aa, $1c6b9

Data_1c6b9:
	dr $1c6b9, $1c6bf

Data_1c6bf:
	dr $1c6bf, $1c6d1

Data_1c6d1:
	dr $1c6d1, $1c6d7

BlueTopEvolutionTrinketCoords: ; 0x1c6d7
; First byte is just non-zero to signify that the array hasn't ended.
; Second byte is x coordinate.
; Third byte is y coordinate.
	db $01, $44, $11
	db $01, $23, $1B
	db $01, $65, $1B
	db $01, $0D, $2E
	db $01, $7A, $2E
	db $01, $05, $48
	db $01, $44, $88
	db $01, $83, $48
	db $01, $02, $6E
	db $01, $2E, $88
	db $01, $59, $88
	db $01, $85, $6E
	db $00

BlueBottomEvolutionTrinketCoords: ; 0x1c6fc
; First byte is just non-zero to signify that the array hasn't ended.
; Second byte is x coordinate.
; Third byte is y coordinate.
	db $01, $33, $1B
	db $01, $55, $1B
	db $01, $29, $1F
	db $01, $5F, $1F
	db $01, $1D, $35
	db $01, $6B, $35
	db $00

Data_1c70f:
	dr $1c70f, $1c715

Func_1c715: ; 0x1c715
	call Func_1c9c1
	call Func_1ca5f
	call Func_1e356
	call HandleBallTypeUpgradeCounterBlueField
	call Func_1e66a
	call Func_1cfaa
	call Func_1d0a1
	call Func_1d216
	call HandleEnteringCloyster
	call Func_1ea3b
	call Func_1dbd2
	call Func_1ef09
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
	call Func_1dbd2
	call Func_1ca85
	call Func_1e4b8
	call HandleBallTypeUpgradeCounterBlueField
	call Func_1e5c5
	call Func_1c7d7
	call Func_1d0a1
	call Func_1ead4
	call Func_1d438
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
	ld a, [wd4dc]
	and a
	ret z
	xor a
	ld [wd4dc], a
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
	ld [wd4ec], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_f269)
	ld hl, Func_f269
	call nz, BankSwitch
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

Func_1c9c1: ; 0x1c9c1
	ld a, [wd4cb]
	and a
	jr z, .asm_1ca19
	xor a
	ld [wd4cb], a
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
	ld a, [wd4cc]
	sub $3
	ld [wd4d7], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.asm_1ca19
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
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $0e
	call PlaySoundEffect
	ret

Func_1ca4a: ; 1ca4a
	ld a, [wd5c7]
	and a
	ret z
	xor a
	ld [wd5c7], a
	ld a, $1
	ld [wBallHitWildMon], a
	lb de, $00, $06
	call PlaySoundEffect
	ret

Func_1ca5f: ; 0x1ca5f
	ld a, [wd507]
	and a
	jr z, Func_1ca85
	xor a
	ld [wd507], a
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
	ld a, $7
	call Func_10aa
	ret

Data_1cb60:
	dr $1cb60, $1cd10

Data_1cd10:
	dr $1cd10, $1ce40

Func_1ce40: ; 1ce40
	ld a, [wd4d8]
	and a
	jr z, .asm_1ce53
	call Func_1ce72
	call Func_1ce60
	xor a
	ld [wd4d8], a
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
	ld a, [wd4d9]
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
	ld a, $7
	call Func_10aa
	ret

Func_1ce94: ; 0x1ce94
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wd7bc], a
	ld a, h
	ld [wd7bd], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wd4d9]
	sub $1
	ld c, a
	ld b, $0
	ld hl, Data_1cec8
	add hl, bc
	ld a, [wd7ea]
	add [hl]
	ld [wd7ea], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

Data_1cec8:
	dr $1cec8, $1ceca

Data_1ceca:
	dr $1ceca, $1cf3a

Data_1cf3a:
	dr $1cf3a, $1cfaa

Func_1cfaa: ; 0x1cfaa
	ld a, [wd51f]
	and a
	ret z
	xor a
	ld [wd51f], a
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
	ld a, [wd520]
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

Func_1d0a1: ; 0x1d0a1
	ld a, [wd515]
	and a
	jr z, .asm_1d110
	xor a
	ld [wd515], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1d110
	ld a, [wd51d]
	and a
	jr nz, .asm_1d0c9
	ld a, [wd516]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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

Func_1d216: ; 0x1d216
	ld a, [wd630]
	and a
	jr z, .asm_1d253
	xor a
	ld [wd630], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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

HandleEnteringCloyster: ; 0x1d32d
	ld a, [wd635]
	and a
	jr z, .asm_1d36a
	xor a
	ld [wd635], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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

Func_1d438: ; 0x1d438
	call Func_1d692
	ld a, [wd60a]
	and a
	jp z, Func_1d51b
	xor a
	ld [wd60a], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wd60b]
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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
	ld a, $7
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
	ld a, $7
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
	ld a, $7
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

Func_1dbd2: ; 0x1dbd2
	ld a, [wd4ed]
	and a
	jp z, Func_1dc8e
	cp $2
	jr z, .asm_1dc33
	xor a
	ld [wd4ed], a
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
	ld [wd4ed], a
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30164)
	ld hl, Func_30164
	call z, BankSwitch
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
	ld a, $7
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
	ld a, $7
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

Func_1e356: ; 0x1e356
	ld a, [wd5f7]
	and a
	jp z, Func_1e471
	xor a
	ld [wd5f7], a
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
	ld a, [wd5f8]
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
	callba Func_155a7
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

HandleBallTypeUpgradeCounterBlueField: ; 0x1e58c
	ld a, [wd5f3]
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
	callba Func_155a7
	ret

Func_1e5c5: ; 0x1e5c5
	ld a, [wd50d]
	and a
	jr z, .asm_1e623
	xor a
	ld [wd50d], a
	ld a, [wd513]
	and a
	jr nz, .asm_1e623
	ld a, [wd50e]
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
	ld a, [wd601]
	and a
	jr z, .asm_1e78c
	xor a
	ld [wd601], a
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
	ld a, $7
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_30256)
	ld hl, Func_30256
	call nz, BankSwitch
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
	ld a, $7
	call Func_10aa
	ret

Data_1eb61:
	dr $1eb61, $1ed51

Data_1ed51:
	dr $1ed51, $1ef09

Func_1ef09: ; 0x1ef09
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
	jp z, LoadOAMData2e
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

LoadOAMData2e: ; 0x1f0be
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
	ld a, $7
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
	callba Func_175a4
	call Func_1f395
	call Func_1f3e1
	call Func_1f408
	call Func_1f428
	callba Func_17e81
	call Func_1f48f
	call Func_1f4f8
	ret

Func_1f35a: ; 0x1f35a
	ld bc, $7f00
	callba Func_175a4
	callba Func_17c67
	call Func_1f58b
	call Func_1f448
	callba Func_e4a1
	callba Func_17e81
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

Func_1f448: ; 0x1f448
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
	ld hl, Data_1f48b
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

Data_1f48b:
	dr $1f48b, $1f48f

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

Func_1f58b: ; 0x1f58b
	ld a, [wd5bb]
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
	ld hl, Data_1f5ad
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

Data_1f5ad:
	dr $1f5ad, $1f5b9

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
	ld [hFarCallTempA], a
	ld a, Bank(Func_10301)
	ld hl, Func_10301
	call nz, BankSwitch
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
	callba Func_10678
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
	callba Func_10496
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_10301)
	ld hl, Func_10301
	call nz, BankSwitch
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
	callba Func_10678
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
	callba Func_10496
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_14135)
	ld hl, Func_14135
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_14135)
	ld hl, Func_14135
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_14135)
	ld hl, Func_14135
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_14135)
	ld hl, Func_14135
	call nz, BankSwitch
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
	call Func_86f
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_1c2cb)
	ld hl, Func_1c2cb
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_1c2cb)
	ld hl, Func_1c2cb
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_1c2cb)
	ld hl, Func_1c2cb
	call nz, BankSwitch
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
	ld [hFarCallTempA], a
	ld a, Bank(Func_1c2cb)
	ld hl, Func_1c2cb
	call nz, BankSwitch
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
	call Func_86f
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
	ld [wd7ab], a
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

Func_2414d: ; 0x2414d
	call Func_24157
	call Func_24214
	call Func_242bb
	ret

Func_24157: ; 0x24157
	ld a, [wd6e7]
	cp $0
	ret nz
	ld a, [wMeowthXPosition]
	add $f7
	ld b, a
	ld a, [wMeowthYPosition]
	add $6
	ld c, a
	call Func_24170
	ld a, $3
	ret nc
	ret

Func_24170: ; 0x24170
	ld a, [wBallXPos + 1]
	sub b
	cp $30
	jp nc, .asm_24212
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $28
	jp nc, .asm_24212
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
	ld de, Data_e9500
	add hl, de
	ld a, BANK(Data_e9500)
	call ReadByteFromBank
	bit 7, a
	jr nz, .asm_24212
	sla a
	ld [wd7ea], a
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

.asm_24212
	and a
	ret

Func_24214: ; 0x24214
	ld a, [wd717]
	cp $2
	jr nz, .asm_2422e
	ld a, [wd71a]
	sub $4
	ld b, a
	ld a, [wd727]
	add $c
	ld c, a
	call Func_24272
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
	call Func_24272
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
	call Func_24272
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

Func_24272: ; 0x24272
	ld a, [wBallXPos + 1]
	sub b
	cp $18
	jr nc, .asm_242b9
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $18
	jr nc, .asm_242b9
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
	ld de, Data_e9c80
	add hl, de
	ld a, BANK(Data_e9c80)
	call ReadByteFromBank
	bit 7, a
	jr nz, .asm_242b9
	sla a
	ld [wd7ea], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.asm_242b9
	and a
	ret

Func_242bb: ; 0x242bb
	ld a, [wd721]
	cp $2
	jr nz, .asm_242d5
	ld a, [wd724]
	sub $4
	ld b, a
	ld a, [wd731]
	add $c
	ld c, a
	call Func_24272
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
	call Func_24272
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
	call Func_24272
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
	ld a, $9
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
	ld a, $9
	call Func_10aa
	ret

Data_25007:
	dr $25007, $25421

Data_25421:
	dr $25421, $2583b

Func_2583b: ; 0x2583b
	ld bc, $7f65
	callba Func_175a4
	callba Func_e4a1
	call Func_259fe
	call Func_25895
	call Func_2595e
	call Func_2586c
	callba Func_17e81
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
	ld hl, Data_2588b
	add hl, de
	ld a, [hl]
	call LoadOAMData2
	ret

Data_2588b:
	dr $2588b, $25895

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
	ld hl, Data_25935
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
	ld hl, Data_25935
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
	ld hl, Data_25935
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

Data_25935:
	dr $25935, $2595e

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
	ld hl, Data_25935
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
	ld hl, Data_25935
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
	ld hl, Data_25935
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
	ld hl, Data_25a29
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_25a29:
	dr $25a29, $25a39

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
	ld hl, Data_25a7a
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

Data_25a7a:
	dr $25a7a, $25a7c

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
	ld [wd7ab], a
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

Func_25bbc: ; 0x25bbc
	call Func_25bc0
	ret

Func_25bc0: ; 0x25bc0
	ld a, [wd76c]
	cp $0
	jr nz, .asm_25bd8
	ld a, [wd76e]
	ld b, a
	ld a, [wd770]
	add $14
	ld c, a
	call Func_25c12
	ld a, $0
	jr c, .asm_25c09
.asm_25bd8
	ld a, [wd776]
	cp $0
	jr nz, .asm_25bf0
	ld a, [wd778]
	ld b, a
	ld a, [wd77a]
	add $14
	ld c, a
	call Func_25c12
	ld a, $1
	jr c, .asm_25c09
.asm_25bf0
	ld a, [wd780]
	cp $0
	jr nz, .asm_25c08
	ld a, [wd782]
	ld b, a
	ld a, [wd784]
	add $14
	ld c, a
	call Func_25c12
	ld a, $2
	jr c, .asm_25c09
.asm_25c08
	ret

.asm_25c09
	ld [wd768], a
	ld a, $1
	ld [wd767], a
	ret

Func_25c12: ; 0x25c12
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .asm_25c58
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
	jr nc, .asm_25c58
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
	ld de, Data_e9100
	add hl, de
	ld a, BANK(Data_e9100)
	call ReadByteFromBank
	bit 7, a
	jr nz, .asm_25c58
	sla a
	ld [wd7ea], a
	ld a, $1
	ld [wd7e9], a
	scf
	ret

.asm_25c58
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
	ld a, $9
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
	ld a, $9
	call Func_10aa
	ret

Data_2634a:
	dr $2634a, $26764

Data_26764:
	dr $26764, $26b7e

Func_26b7e: ; 0x26b7e
	ld bc, $7f65
	callba Func_175a4
	call Func_26bf7
	callba Func_e4a1
	callba Func_17e81
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
	ld hl, Data_26bdf
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_26bdf:
	dr $26bdf, $26bf7

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
	ld hl, Data_26c23
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadOAMData2
	ret

Data_26c23:
	dr $26c23, $26c3c

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
	ld hl, Data_26c7d
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

Data_26c7d:
	dr $26c7d, $26c7f

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
	ld [wd80c], a
	ld a, $93
	ld [wd80d], a
	ld a, $e4
	ld [wd80e], a
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
	call Func_926
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
	ld hl, Data_2b136
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
	ld hl, Data_28687
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

Data_28687:
	dr $28687, $2868b

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
	ld bc, Data_29892
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
	ld bc, Data_29892
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
	jr z, .asm_289fe
	ld a, [wCurPokedexIndex]
	ld c, a
	ld b, $0
	ld hl, MonDexTypeIDs
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
	ld bc, Data_29fa6
	add hl, bc
.asm_289fe
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
	jp z, Func_28b76
	dec a
	jp z, Func_28baf
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
	call Func_86f
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

Func_28b76: ; 0x28b76
	ld a, BANK(Data_71500)
	ld hl, Data_71500
	ld de, vTilesBG tile $00
	ld bc, $0180
	call LoadOrCopyVRAMData
	call Func_28cd4
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, BANK(Data_28b97)
	ld de, Data_28b97
	hlCoord 1, 3, vBGMap
	call Func_86f
	ret

Data_28b97:
	dr $28b97, $28baf

Func_28baf: ; 0x28baf
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
	ld a, BANK(Data_28b97)
	ld de, Data_28b97
	hlCoord 1, 3, vBGMap
	call Func_86f
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
	call Func_206d
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
	call Func_206d
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

Data_29892:
	dr $29892, $29f0f

MonDexTypeIDs: ; 0x29f0f
	db $00
	db $00
	db $00
	db $01
	db $02
	db $02
	db $03
	db $04
	db $05
	db $06
	db $07
	db $08
	db $09
	db $07
	db $0A
	db $0B
	db $0C
	db $0C
	db $60
	db $60
	db $0B
	db $0E
	db $0F
	db $10
	db $0D
	db $0D
	db $0D
	db $0D
	db $11
	db $11
	db $12
	db $11
	db $11
	db $12
	db $13
	db $13
	db $14
	db $14
	db $15
	db $15
	db $16
	db $16
	db $17
	db $17
	db $18
	db $19
	db $19
	db $1A
	db $1B
	db $1C
	db $1C
	db $1D
	db $1E
	db $1F
	db $1F
	db $20
	db $20
	db $21
	db $22
	db $23
	db $23
	db $23
	db $24
	db $24
	db $24
	db $25
	db $25
	db $25
	db $18
	db $26
	db $26
	db $27
	db $27
	db $28
	db $28
	db $29
	db $2A
	db $2A
	db $2B
	db $2C
	db $2D
	db $2D
	db $2E
	db $2F
	db $30
	db $31
	db $31
	db $32
	db $32
	db $33
	db $33
	db $34
	db $34
	db $35
	db $36
	db $37
	db $37
	db $38
	db $39
	db $3A
	db $3A
	db $3B
	db $3C
	db $3D
	db $3E
	db $3F
	db $40
	db $41
	db $42
	db $42
	db $43
	db $12
	db $3B
	db $44
	db $45
	db $46
	db $46
	db $47
	db $47
	db $48
	db $49
	db $4A
	db $4B
	db $4C
	db $4D
	db $4E
	db $4F
	db $50
	db $51
	db $52
	db $53
	db $54
	db $55
	db $56
	db $57
	db $58
	db $59
	db $5A
	db $5A
	db $05
	db $05
	db $5B
	db $5C
	db $5D
	db $4D
	db $02
	db $46
	db $46
	db $46
	db $5E
	db $5F

Data_29fa6:
	dr $29fa6, $2a85d

Data_2a85d:
	dr $2a85d, $2b136

Data_2b136:
	dr $2b136, $2b1cd

SECTION "bankb", ROMX, BANK[$b]

Unknown_2c000: ; 0x2c000
	dex_text " "
	dex_end

PokedexDescriptionPointers: ; 0x2c002
	dw BulbasaurPokedexDescription
	dw IvysaurPokedexDescription
	dw VenusaurPokedexDescription
	dw CharmanderPokedexDescription
	dw CharmeleonPokedexDescription
	dw CharizardPokedexDescription
	dw SquirtlePokedexDescription
	dw WartortlePokedexDescription
	dw BlastoisePokedexDescription
	dw CaterpiePokedexDescription
	dw MetapodPokedexDescription
	dw ButterfreePokedexDescription
	dw WeedlePokedexDescription
	dw KakunaPokedexDescription
	dw BeedrillPokedexDescription
	dw PidgeyPokedexDescription
	dw PidgeottoPokedexDescription
	dw PidgeotPokedexDescription
	dw RattataPokedexDescription
	dw RaticatePokedexDescription
	dw SpearowPokedexDescription
	dw FearowPokedexDescription
	dw EkansPokedexDescription
	dw ArbokPokedexDescription
	dw PikachuPokedexDescription
	dw RaichuPokedexDescription
	dw SandshrewPokedexDescription
	dw SandslashPokedexDescription
	dw NidoranFPokedexDescription
	dw NidorinaPokedexDescription
	dw NidoqueenPokedexDescription
	dw NidoranMPokedexDescription
	dw NidorinoPokedexDescription
	dw NidokingPokedexDescription
	dw ClefairyPokedexDescription
	dw ClefablePokedexDescription
	dw VulpixPokedexDescription
	dw NinetalesPokedexDescription
	dw JigglypuffPokedexDescription
	dw WigglytuffPokedexDescription
	dw ZubatPokedexDescription
	dw GolbatPokedexDescription
	dw OddishPokedexDescription
	dw GloomPokedexDescription
	dw VileplumePokedexDescription
	dw ParasPokedexDescription
	dw ParasectPokedexDescription
	dw VenonatPokedexDescription
	dw VenomothPokedexDescription
	dw DiglettPokedexDescription
	dw DugtrioPokedexDescription
	dw MeowthPokedexDescription
	dw PersianPokedexDescription
	dw PsyduckPokedexDescription
	dw GolduckPokedexDescription
	dw MankeyPokedexDescription
	dw PrimeapePokedexDescription
	dw GrowlithePokedexDescription
	dw ArcaninePokedexDescription
	dw PoliwagPokedexDescription
	dw PoliwhirlPokedexDescription
	dw PoliwrathPokedexDescription
	dw AbraPokedexDescription
	dw KadabraPokedexDescription
	dw AlakazamPokedexDescription
	dw MachopPokedexDescription
	dw MachokePokedexDescription
	dw MachampPokedexDescription
	dw BellsproutPokedexDescription
	dw WeepinbellPokedexDescription
	dw VictreebellPokedexDescription
	dw TentacoolPokedexDescription
	dw TentacruelPokedexDescription
	dw GeodudePokedexDescription
	dw GravelerPokedexDescription
	dw GolemPokedexDescription
	dw PonytaPokedexDescription
	dw RapidashPokedexDescription
	dw SlowpokePokedexDescription
	dw SlowbroPokedexDescription
	dw MagnemitePokedexDescription
	dw MagnetonPokedexDescription
	dw FarfetchdPokedexDescription
	dw DoduoPokedexDescription
	dw DodrioPokedexDescription
	dw SeelPokedexDescription
	dw DewgongPokedexDescription
	dw GrimerPokedexDescription
	dw MukPokedexDescription
	dw ShellderPokedexDescription
	dw CloysterPokedexDescription
	dw GastlyPokedexDescription
	dw HaunterPokedexDescription
	dw GengarPokedexDescription
	dw OnixPokedexDescription
	dw DrowzeePokedexDescription
	dw HypnoPokedexDescription
	dw KrabbyPokedexDescription
	dw KinglerPokedexDescription
	dw VoltorbPokedexDescription
	dw ElectrodePokedexDescription
	dw ExeggcutePokedexDescription
	dw ExeggutorPokedexDescription
	dw CubonePokedexDescription
	dw MarowakPokedexDescription
	dw HitmonleePokedexDescription
	dw HitmonchanPokedexDescription
	dw LickitungPokedexDescription
	dw KoffingPokedexDescription
	dw WeezingPokedexDescription
	dw RhyhornPokedexDescription
	dw RhydonPokedexDescription
	dw ChanseyPokedexDescription
	dw TangelaPokedexDescription
	dw KangaskhanPokedexDescription
	dw HorseaPokedexDescription
	dw SeadraPokedexDescription
	dw GoldeenPokedexDescription
	dw SeakingPokedexDescription
	dw StaryuPokedexDescription
	dw StarmiePokedexDescription
	dw MrMimePokedexDescription
	dw ScytherPokedexDescription
	dw JynxPokedexDescription
	dw ElectabuzzPokedexDescription
	dw MagmarPokedexDescription
	dw PinsirPokedexDescription
	dw TaurosPokedexDescription
	dw MagikarpPokedexDescription
	dw GyaradosPokedexDescription
	dw LaprasPokedexDescription
	dw DittoPokedexDescription
	dw EeveePokedexDescription
	dw VaporeonPokedexDescription
	dw JolteonPokedexDescription
	dw FlareonPokedexDescription
	dw PorygonPokedexDescription
	dw OmanytePokedexDescription
	dw OmastarPokedexDescription
	dw KabutoPokedexDescription
	dw KabutopsPokedexDescription
	dw AerodactylPokedexDescription
	dw SnorlaxPokedexDescription
	dw ArticunoPokedexDescription
	dw ZapdosPokedexDescription
	dw MoltresPokedexDescription
	dw DratiniPokedexDescription
	dw DragonairPokedexDescription
	dw DragonitePokedexDescription
	dw MewtwoPokedexDescription
	dw MewPokedexDescription

RhydonPokedexDescription: ; 0x2c130
	dex_text "Protected by an"
	dex_line "armor-like hide,"
	dex_line "it is capable of"
	dex_line "living in molten"
	dex_line "lava of 3,600"
	dex_line "degrees."
	dex_end

KangaskhanPokedexDescription: ; 0x2c18a
	dex_text "The infant rarely"
	dex_line "ventures out of"
	dex_line "its mother`s"
	dex_line "protective pouch"
	dex_line "until it is 3"
	dex_line "years old."
	dex_end

NidoranMPokedexDescription: ; 0x2c1e3
	dex_text "Stiffens its ears"
	dex_line "to sense danger."
	dex_line "The larger its"
	dex_line "horns, the more"
	dex_line "powerful its"
	dex_line "secreted venom."
	dex_end

ClefairyPokedexDescription: ; 0x2c242
	dex_text "Its magical and"
	dex_line "cute appeal has"
	dex_line "many admirers."
	dex_line "It is rare and"
	dex_line "found only in"
	dex_line "certain areas."
	dex_end

SpearowPokedexDescription: ; 0x2c29d
	dex_text "Eats bugs in"
	dex_line "grassy areas. It"
	dex_line "has to flap its"
	dex_line "short wings at"
	dex_line "high speed to"
	dex_line "stay airborne."
	dex_end

VoltorbPokedexDescription: ; 0x2c2f7
	dex_text "Usually found in"
	dex_line "power plants."
	dex_line "Easily mistaken"
	dex_line "for a POKé BALL,"
	dex_line "they have zapped"
	dex_line "many people."
	dex_end

NidokingPokedexDescription: ; 0x2c355
	dex_text "It uses its"
	dex_line "powerful tail in"
	dex_line "battle to smash,"
	dex_line "constrict, then"
	dex_line "break the prey`s"
	dex_line "bones."
	dex_end

SlowbroPokedexDescription: ; 0x2c3ab
	dex_text "The SHELLDER that"
	dex_line "is latched onto"
	dex_line "SLOWPOKE`s tail"
	dex_line "is said to feed"
	dex_line "on the host`s left"
	dex_line "over scraps."
	dex_end

IvysaurPokedexDescription: ; 0x2c40d
	dex_text "When the bulb on"
	dex_line "its back grows"
	dex_line "large, it appears"
	dex_line "to lose the"
	dex_line "ability to stand"
	dex_line "on its hind legs."
	dex_end

ExeggutorPokedexDescription: ; 0x2c46e
	dex_text "Legend has it that"
	dex_line "on rare occasions,"
	dex_line "one of its heads"
	dex_line "will drop off and"
	dex_line "continue on as an"
	dex_line "EXEGGCUTE."
	dex_end

LickitungPokedexDescription: ; 0x2c4d4
	dex_text "Its tongue can be"
	dex_line "extended like a"
	dex_line "chameleon`s. It"
	dex_line "leaves a tingling"
	dex_line "sensation when it"
	dex_line "licks enemies."
	dex_end

ExeggcutePokedexDescription: ; 0x2c539
	dex_text "Often mistaken"
	dex_line "for eggs."
	dex_line "When disturbed,"
	dex_line "they quickly"
	dex_line "gather and attack"
	dex_line "in swarms."
	dex_end

GrimerPokedexDescription: ; 0x2c58c
	dex_text "Appears in filthy"
	dex_line "areas. Thrives by"
	dex_line "sucking up"
	dex_line "polluted sludge"
	dex_line "that is pumped"
	dex_line "out of factories."
	dex_end

GengarPokedexDescription: ; 0x2c5ec
	dex_text "Under a full moon,"
	dex_line "this POKéMON"
	dex_line "likes to mimic"
	dex_line "the shadows of"
	dex_line "people and laugh"
	dex_line "at their fright."
	dex_end

NidoranFPokedexDescription: ; 0x2c64c
	dex_text "Although small,"
	dex_line "its venomous"
	dex_line "barbs render this"
	dex_line "POKéMON dangerous."
	dex_line "The female has"
	dex_line "smaller horns."
	dex_end

NidoqueenPokedexDescription: ; 0x2c6ac
	dex_text "Its hard scales"
	dex_line "provide strong"
	dex_line "protection. It"
	dex_line "uses its hefty"
	dex_line "bulk to execute"
	dex_line "powerful moves."
	dex_end

CubonePokedexDescription: ; 0x2c709
	dex_text "Because it never"
	dex_line "removes its skull"
	dex_line "helmet, no one"
	dex_line "has ever seen"
	dex_line "this POKéMON`s"
	dex_line "real face."
	dex_end

RhyhornPokedexDescription: ; 0x2c763
	dex_text "Its massive bones"
	dex_line "are 1000 times"
	dex_line "harder than human"
	dex_line "bones. It can"
	dex_line "easily knock a"
	dex_line "trailer flying."
	dex_end

LaprasPokedexDescription: ; 0x2c7c3
	dex_text "A POKéMON that"
	dex_line "has been over-"
	dex_line "hunted almost to"
	dex_line "extinction. It"
	dex_line "can ferry people"
	dex_line "across the water."
	dex_end

ArcaninePokedexDescription: ; 0x2c824
	dex_text "A POKéMON that"
	dex_line "has been admired"
	dex_line "since the past"
	dex_line "for its beauty."
	dex_line "It runs agilely"
	dex_line "as if on wings."
	dex_end

MewPokedexDescription: ; 0x2c883
	dex_text "So rare that it"
	dex_line "is still said to"
	dex_line "be a mirage by"
	dex_line "many experts. Only"
	dex_line "a few people have"
	dex_line "seen it worldwide. "
	dex_end

GyaradosPokedexDescription: ; 0x2c8ec
	dex_text "Rarely seen in"
	dex_line "the wild. Huge"
	dex_line "and vicious, it"
	dex_line "is capable of"
	dex_line "destroying entire"
	dex_line "cities in a rage."
	dex_end

ShellderPokedexDescription: ; 0x2c94c
	dex_text "Its hard shell"
	dex_line "repels any kind"
	dex_line "of attack."
	dex_line "It is vulnerable"
	dex_line "only when its"
	dex_line "shell is open."
	dex_end

TentacoolPokedexDescription: ; 0x2c9a4
	dex_text "Drifts in shallow"
	dex_line "seas. Anglers who"
	dex_line "hook them by"
	dex_line "accident are"
	dex_line "often punished by"
	dex_line "its stinging acid."
	dex_end

GastlyPokedexDescription: ; 0x2ca07
	dex_text "Almost invisible,"
	dex_line "this gaseous"
	dex_line "POKéMON cloaks"
	dex_line "the target and"
	dex_line "puts it to sleep"
	dex_line "without notice."
	dex_end

ScytherPokedexDescription: ; 0x2ca65
	dex_text "With ninja-like"
	dex_line "agility and speed,"
	dex_line "it can create the"
	dex_line "illusion that"
	dex_line "there is more"
	dex_line "than one."
	dex_end

StaryuPokedexDescription: ; 0x2cac0
	dex_text "An enigmatic"
	dex_line "POKéMON that can"
	dex_line "effortlessly"
	dex_line "regenerate any"
	dex_line "appendage it"
	dex_line "loses in battle."
	dex_end

BlastoisePokedexDescription: ; 0x2cb18
	dex_text "A brutal POKéMON"
	dex_line "with pressurized"
	dex_line "water jets on its"
	dex_line "shell. They are"
	dex_line "used for high"
	dex_line "speed tackles."
	dex_end

PinsirPokedexDescription: ; 0x2cb79
	dex_text "If it fails to"
	dex_line "crush the victim"
	dex_line "in its pincers,"
	dex_line "it will swing it"
	dex_line "around and toss"
	dex_line "it hard."
	dex_end

TangelaPokedexDescription: ; 0x2cbd3
	dex_text "The whole body is"
	dex_line "swathed with wide"
	dex_line "vines that are"
	dex_line "similar to sea-"
	dex_line "weed. Its vines"
	dex_line "shake as it walks."
	dex_end

GrowlithePokedexDescription: ; 0x2cc39
	dex_text "Very protective"
	dex_line "of its territory."
	dex_line "It will bark and"
	dex_line "bite to repel"
	dex_line "intruders from"
	dex_line "its space."
	dex_end

OnixPokedexDescription: ; 0x2cc94
	dex_text "As it grows, the"
	dex_line "stone portions of"
	dex_line "its body harden"
	dex_line "to become similar"
	dex_line "to a diamond, but"
	dex_line "colored black."
	dex_end

FearowPokedexDescription: ; 0x2ccfa
	dex_text "With its huge and"
	dex_line "magnificent wings,"
	dex_line "it can keep aloft"
	dex_line "without ever"
	dex_line "having to land"
	dex_line "for rest."
	dex_end

PidgeyPokedexDescription: ; 0x2cd57
	dex_text "A common sight in"
	dex_line "forests and woods."
	dex_line "It flaps its"
	dex_line "wings at ground"
	dex_line "level to kick up"
	dex_line "blinding sand."
	dex_end

SlowpokePokedexDescription: ; 0x2cdb9
	dex_text "Incredibly slow"
	dex_line "and dopey. It"
	dex_line "takes 5 seconds"
	dex_line "for it to feel"
	dex_line "pain when under"
	dex_line "attack."
	dex_end

KadabraPokedexDescription: ; 0x2ce0e
	dex_text "It emits special"
	dex_line "alpha waves from"
	dex_line "its body that"
	dex_line "induce headaches"
	dex_line "just by being"
	dex_line "close by."
	dex_end

GravelerPokedexDescription: ; 0x2ce67
	dex_text "Rolls down slopes"
	dex_line "to move. It rolls"
	dex_line "over any obstacle"
	dex_line "without slowing"
	dex_line "or changing its"
	dex_line "direction."
	dex_end

ChanseyPokedexDescription: ; 0x2cec8
	dex_text "A rare and elusive"
	dex_line "POKéMON that is"
	dex_line "said to bring"
	dex_line "happiness to those"
	dex_line "who manage to get"
	dex_line "it."
	dex_end

MachokePokedexDescription: ; 0x2cf22
	dex_text "Its muscular body"
	dex_line "is so powerful, it"
	dex_line "must wear a power"
	dex_line "save belt to be"
	dex_line "able to regulate"
	dex_line "its motions."
	dex_end

MrMimePokedexDescription: ; 0x2cf87
	dex_text "If interrupted"
	dex_line "while it is"
	dex_line "miming, it will"
	dex_line "slap around the"
	dex_line "offender with its"
	dex_line "broad hands."
	dex_end

HitmonleePokedexDescription: ; 0x2cfe1
	dex_text "When in a hurry,"
	dex_line "its legs lengthen"
	dex_line "progressively."
	dex_line "It runs smoothly"
	dex_line "with extra long,"
	dex_line "loping strides."
	dex_end

HitmonchanPokedexDescription: ; 0x2d045
	dex_text "While apparently"
	dex_line "doing nothing, it"
	dex_line "fires punches in"
	dex_line "lightning fast"
	dex_line "volleys that are"
	dex_line "impossible to see. "
	dex_end

ArbokPokedexDescription: ; 0x2d0ad
	dex_text "It is rumored that"
	dex_line "the ferocious"
	dex_line "warning markings"
	dex_line "on its belly"
	dex_line "differ from area"
	dex_line "to area."
	dex_end

ParasectPokedexDescription: ; 0x2d106
	dex_text "A host-parasite"
	dex_line "pair in which the"
	dex_line "parasite mushroom"
	dex_line "has taken over the"
	dex_line "host bug. Prefers"
	dex_line "damp places. "
	dex_end

PsyduckPokedexDescription: ; 0x2d16d
	dex_text "While lulling its"
	dex_line "enemies with its"
	dex_line "vacant look, this"
	dex_line "wily POKéMON will"
	dex_line "use psychokinetic"
	dex_line "powers."
	dex_end

DrowzeePokedexDescription: ; 0x2d1ce
	dex_text "Puts enemies to"
	dex_line "sleep then eats"
	dex_line "their dreams."
	dex_line "Occasionally gets"
	dex_line "sick from eating"
	dex_line "bad dreams."
	dex_end

GolemPokedexDescription: ; 0x2d22b
	dex_text "Its boulder-like"
	dex_line "body is extremely"
	dex_line "hard. It can"
	dex_line "easily withstand"
	dex_line "dynamite blasts"
	dex_line "without damage."
	dex_end

MagmarPokedexDescription: ; 0x2d28c
	dex_text "Its body always"
	dex_line "burns with an"
	dex_line "orange glow that"
	dex_line "enables it to"
	dex_line "hide perfectly"
	dex_line "among flames."
	dex_end

ElectabuzzPokedexDescription: ; 0x2d2e6
	dex_text "Normally found"
	dex_line "near power plants,"
	dex_line "they can wander"
	dex_line "away and cause"
	dex_line "major blackouts"
	dex_line "in cities."
	dex_end

MagnetonPokedexDescription: ; 0x2d342
	dex_text "Formed by several"
	dex_line "MAGNEMITEs linked"
	dex_line "together. They"
	dex_line "frequently appear"
	dex_line "when sunspots"
	dex_line "flare up."
	dex_end

KoffingPokedexDescription: ; 0x2d39f
	dex_text "Because it stores"
	dex_line "several kinds of"
	dex_line "toxic gases in"
	dex_line "its body, it is"
	dex_line "prone to exploding"
	dex_line "without warning."
	dex_end

MankeyPokedexDescription: ; 0x2d405
	dex_text "Extremely quick to"
	dex_line "anger. It could"
	dex_line "be docile one"
	dex_line "moment then"
	dex_line "thrashing away"
	dex_line "the next instant."
	dex_end

SeelPokedexDescription: ; 0x2d463
	dex_text "The protruding"
	dex_line "horn on its head"
	dex_line "is very hard."
	dex_line "It is used for"
	dex_line "bashing through"
	dex_line "thick ice."
	dex_end

DiglettPokedexDescription: ; 0x2d4bb
	dex_text "Lives about one"
	dex_line "yard underground"
	dex_line "where it feeds on"
	dex_line "plant roots. It"
	dex_line "sometimes appears"
	dex_line "above ground."
	dex_end

TaurosPokedexDescription: ; 0x2d51e
	dex_text "When it targets"
	dex_line "an enemy, it"
	dex_line "charges furiously"
	dex_line "while whipping its"
	dex_line "body with its"
	dex_line "long tails."
	dex_end

FarfetchdPokedexDescription: ; 0x2d57a
	dex_text "The sprig of"
	dex_line "green onions it"
	dex_line "holds is its"
	dex_line "weapon. It is"
	dex_line "used much like a"
	dex_line "metal sword."
	dex_end

VenonatPokedexDescription: ; 0x2d5d0
	dex_text "Lives in the"
	dex_line "shadows of tall"
	dex_line "trees where it"
	dex_line "eats insects. It"
	dex_line "is attracted by"
	dex_line "light at night."
	dex_end

DragonitePokedexDescription: ; 0x2d62d
	dex_text "An extremely"
	dex_line "rarely seen"
	dex_line "marine POKéMON."
	dex_line "Its intelligence"
	dex_line "is said to match"
	dex_line "that of humans."
	dex_end

DoduoPokedexDescription: ; 0x2d688
	dex_text "A bird that makes"
	dex_line "up for its poor"
	dex_line "flying with its"
	dex_line "fast foot speed."
	dex_line "Leaves giant"
	dex_line "footprints."
	dex_end

PoliwagPokedexDescription: ; 0x2d6e4
	dex_text "Its newly grown"
	dex_line "legs prevent it"
	dex_line "from running. It"
	dex_line "appears to prefer"
	dex_line "swimming than"
	dex_line "trying to stand."
	dex_end

JynxPokedexDescription: ; 0x2d746
	dex_text "It seductively"
	dex_line "wiggles its hips"
	dex_line "as it walks. It"
	dex_line "can cause people"
	dex_line "to dance in"
	dex_line "unison with it."
	dex_end

MoltresPokedexDescription: ; 0x2d7a3
	dex_text "Known as the"
	dex_line "legendary bird of"
	dex_line "fire. Every flap"
	dex_line "of its wings"
	dex_line "creates a dazzling"
	dex_line "flash of flames."
	dex_end

ArticunoPokedexDescription: ; 0x2d804
	dex_text "A legendary bird"
	dex_line "POKéMON that is"
	dex_line "said to appear to"
	dex_line "doomed people who"
	dex_line "are lost in icy"
	dex_line "mountains."
	dex_end

ZapdosPokedexDescription: ; 0x2d864
	dex_text "A legendary bird"
	dex_line "POKéMON that is"
	dex_line "said to appear"
	dex_line "from clouds while"
	dex_line "dropping enormous"
	dex_line "lightning bolts."
	dex_end

DittoPokedexDescription: ; 0x2d8c9
	dex_text "Capable of copying"
	dex_line "an enemy`s genetic"
	dex_line "code to instantly"
	dex_line "transform itself"
	dex_line "into a duplicate"
	dex_line "of the enemy."
	dex_end

MeowthPokedexDescription: ; 0x2d931
	dex_text "Adores circular"
	dex_line "objects. Wanders"
	dex_line "the streets on a"
	dex_line "nightly basis to"
	dex_line "look for dropped"
	dex_line "loose change."
	dex_end

KrabbyPokedexDescription: ; 0x2d993
	dex_text "Its pincers are"
	dex_line "not only powerful"
	dex_line "weapons, they are"
	dex_line "used for balance"
	dex_line "when walking"
	dex_line "sideways."
	dex_end

VulpixPokedexDescription: ; 0x2d9ef
	dex_text "At the time of"
	dex_line "birth, it has"
	dex_line "just one tail."
	dex_line "The tail splits"
	dex_line "from its tip as"
	dex_line "it grows older."
	dex_end

NinetalesPokedexDescription: ; 0x2da4b
	dex_text "Very smart and"
	dex_line "very vengeful."
	dex_line "Grabbing one of"
	dex_line "its many tails"
	dex_line "could result in a"
	dex_line "1000-year curse."
	dex_end

PikachuPokedexDescription: ; 0x2daab
	dex_text "When several of"
	dex_line "these POKéMON"
	dex_line "gather, their"
	dex_line "electricity could"
	dex_line "build and cause"
	dex_line "lightning storms."
	dex_end

RaichuPokedexDescription: ; 0x2db0b
	dex_text "Its long tail"
	dex_line "serves as a"
	dex_line "ground to protect"
	dex_line "itself from its"
	dex_line "own high voltage"
	dex_line "power."
	dex_end

DratiniPokedexDescription: ; 0x2db5f
	dex_text "Long considered a"
	dex_line "mythical POKéMON"
	dex_line "until recently"
	dex_line "when a small"
	dex_line "colony was found"
	dex_line "living underwater."
	dex_end

DragonairPokedexDescription: ; 0x2dbc2
	dex_text "A mystical POKéMON"
	dex_line "that exudes a"
	dex_line "gentle aura."
	dex_line "Has the ability"
	dex_line "to change climate"
	dex_line "conditions."
	dex_end

KabutoPokedexDescription: ; 0x2dc1e
	dex_text "A POKéMON that"
	dex_line "was resurrected"
	dex_line "from a fossil"
	dex_line "found in what was"
	dex_line "once the ocean"
	dex_line "floor eons ago."
	dex_end

KabutopsPokedexDescription: ; 0x2dc7c
	dex_text "Its sleek shape is"
	dex_line "perfect for swim-"
	dex_line "ming. It slashes"
	dex_line "prey with its"
	dex_line "claws and drains"
	dex_line "the body fluids."
	dex_end

HorseaPokedexDescription: ; 0x2dce2
	dex_text "Known to shoot"
	dex_line "down flying bugs"
	dex_line "with precision"
	dex_line "blasts of ink"
	dex_line "from the surface"
	dex_line "of the water."
	dex_end

SeadraPokedexDescription: ; 0x2dd3e
	dex_text "Capable of swim-"
	dex_line "ming backwards by"
	dex_line "rapidly flapping"
	dex_line "its wing-like"
	dex_line "pectoral fins and"
	dex_line "stout tail."
	dex_end

SandshrewPokedexDescription: ; 0x2dd9e
	dex_text "Burrows deep"
	dex_line "underground in"
	dex_line "arid locations"
	dex_line "far from water."
	dex_line "It only emerges"
	dex_line "to hunt for food."
	dex_end

SandslashPokedexDescription: ; 0x2ddfb
	dex_text "Curls up into a"
	dex_line "spiny ball when"
	dex_line "threatened. It"
	dex_line "can roll while"
	dex_line "curled up to"
	dex_line "attack or escape."
	dex_end

OmanytePokedexDescription: ; 0x2de58
	dex_text "Although long"
	dex_line "extinct, in rare"
	dex_line "cases, it can be"
	dex_line "genetically"
	dex_line "resurrected from"
	dex_line "fossils."
	dex_end

OmastarPokedexDescription: ; 0x2deae
	dex_text "A prehistoric"
	dex_line "POKéMON that died"
	dex_line "out when its"
	dex_line "heavy shell made"
	dex_line "it impossible to"
	dex_line "catch prey."
	dex_end

JigglypuffPokedexDescription: ; 0x2df09
	dex_text "When its huge eyes"
	dex_line "light up, it sings"
	dex_line "a mysteriously"
	dex_line "soothing melody"
	dex_line "that lulls its"
	dex_line "enemies to sleep."
	dex_end

WigglytuffPokedexDescription: ; 0x2df6f
	dex_text "The body is soft"
	dex_line "and rubbery. When"
	dex_line "angered, it will"
	dex_line "suck in air and"
	dex_line "inflate itself to"
	dex_line "an enormous size."
	dex_end

EeveePokedexDescription: ; 0x2dfd7
	dex_text "Its genetic code"
	dex_line "is irregular."
	dex_line "It may mutate if"
	dex_line "it is exposed to"
	dex_line "radiation from"
	dex_line "element STONEs."
	dex_end

FlareonPokedexDescription: ; 0x2e037
	dex_text "When storing"
	dex_line "thermal energy in"
	dex_line "its body, its"
	dex_line "temperature could"
	dex_line "soar to over 1600"
	dex_line "degrees."
	dex_end

JolteonPokedexDescription: ; 0x2e091
	dex_text "It accumulates"
	dex_line "negative ions in"
	dex_line "the atmosphere to"
	dex_line "blast out 10000-"
	dex_line "volt lightning"
	dex_line "bolts."
	dex_end

VaporeonPokedexDescription: ; 0x2e0ea
	dex_text "Lives close to"
	dex_line "water. Its long"
	dex_line "tail is ridged"
	dex_line "with a fin which"
	dex_line "is often mistaken"
	dex_line "for a mermaid`s."
	dex_end

MachopPokedexDescription: ; 0x2e14c
	dex_text "Loves to build"
	dex_line "its muscles."
	dex_line "It trains in all"
	dex_line "styles of martial"
	dex_line "arts to become"
	dex_line "even stronger."
	dex_end

ZubatPokedexDescription: ; 0x2e1a9
	dex_text "Forms colonies in"
	dex_line "perpetually dark"
	dex_line "places. Uses"
	dex_line "ultrasonic waves"
	dex_line "to identify and"
	dex_line "approach targets."
	dex_end

EkansPokedexDescription: ; 0x2e20c
	dex_text "Moves silently"
	dex_line "and stealthily."
	dex_line "Eats the eggs of"
	dex_line "birds, such as"
	dex_line "PIDGEY and"
	dex_line "SPEAROW, whole."
	dex_end

ParasPokedexDescription: ; 0x2e266
	dex_text "Burrows to suck"
	dex_line "tree roots. The"
	dex_line "mushrooms on its"
	dex_line "back grow by draw-"
	dex_line "ing nutrients from"
	dex_line "the bug host."
	dex_end

PoliwhirlPokedexDescription: ; 0x2e2cb
	dex_text "Capable of living"
	dex_line "in or out of"
	dex_line "water. When out"
	dex_line "of water, it"
	dex_line "sweats to keep"
	dex_line "its body slimy."
	dex_end

PoliwrathPokedexDescription: ; 0x2e326
	dex_text "An adept swimmer"
	dex_line "at both the front"
	dex_line "crawl and breast"
	dex_line "stroke. Easily"
	dex_line "overtakes the best"
	dex_line "human swimmers."
	dex_end

WeedlePokedexDescription: ; 0x2e38c
	dex_text "Often found in"
	dex_line "forests, eating"
	dex_line "leaves."
	dex_line "It has a sharp"
	dex_line "venomous stinger"
	dex_line "on its head."
	dex_end

KakunaPokedexDescription: ; 0x2e3e0
	dex_text "Almost incapable"
	dex_line "of moving, this"
	dex_line "POKéMON can only"
	dex_line "harden its shell"
	dex_line "to protect itself"
	dex_line "from predators."
	dex_end

BeedrillPokedexDescription: ; 0x2e445
	dex_text "Flies at high"
	dex_line "speed and attacks"
	dex_line "using its large"
	dex_line "venomous stingers"
	dex_line "on its forelegs"
	dex_line "and tail."
	dex_end

DodrioPokedexDescription: ; 0x2e4a1
	dex_text "Uses its three"
	dex_line "brains to execute"
	dex_line "complex plans."
	dex_line "While two heads"
	dex_line "sleep, one head"
	dex_line "stays awake."
	dex_end

PrimeapePokedexDescription: ; 0x2e4fe
	dex_text "Always furious"
	dex_line "and tenacious to"
	dex_line "boot. It will not"
	dex_line "abandon chasing"
	dex_line "its quarry until"
	dex_line "it is caught."
	dex_end

DugtrioPokedexDescription: ; 0x2e55f
	dex_text "A team of DIGLETT"
	dex_line "triplets."
	dex_line "It triggers huge"
	dex_line "earthquakes by"
	dex_line "burrowing 60 miles"
	dex_line "underground."
	dex_end

VenomothPokedexDescription: ; 0x2e5bb
	dex_text "The dust-like"
	dex_line "scales covering"
	dex_line "its wings are"
	dex_line "color coded to"
	dex_line "indicate the kinds"
	dex_line "of poison it has."
	dex_end

DewgongPokedexDescription: ; 0x2e61b
	dex_text "Stores thermal"
	dex_line "energy in its"
	dex_line "body. Swims at a"
	dex_line "steady 8 knots"
	dex_line "even in intensely"
	dex_line "cold waters. "
	dex_end

CaterpiePokedexDescription: ; 0x2e678
	dex_text "Its short feet"
	dex_line "are tipped with"
	dex_line "suction pads that"
	dex_line "enable it to"
	dex_line "tirelessly climb"
	dex_line "slopes and walls."
	dex_end

MetapodPokedexDescription: ; 0x2e6d9
	dex_text "This POKéMON is"
	dex_line "vulnerable to"
	dex_line "attack while its"
	dex_line "shell is soft,"
	dex_line "exposing its weak"
	dex_line "and tender body."
	dex_end

ButterfreePokedexDescription: ; 0x2e73a
	dex_text "In battle, it"
	dex_line "flaps its wings"
	dex_line "at high speed to"
	dex_line "release highly"
	dex_line "toxic dust into"
	dex_line "the air."
	dex_end

MachampPokedexDescription: ; 0x2e791
	dex_text "Using its heavy"
	dex_line "muscles, it throws"
	dex_line "powerful punches"
	dex_line "that can send the"
	dex_line "victim clear over"
	dex_line "the horizon. "
	dex_end

GolduckPokedexDescription: ; 0x2e7f7
	dex_text "Often seen swim-"
	dex_line "ming elegantly by"
	dex_line "lake shores. It"
	dex_line "is often mistaken"
	dex_line "for the Japanese"
	dex_line "monster, Kappa."
	dex_end

HypnoPokedexDescription: ; 0x2e85d
	dex_text "When it locks eyes"
	dex_line "with an enemy, it"
	dex_line "will use a mix of"
	dex_line "PSI moves such as"
	dex_line "HYPNOSIS and"
	dex_line "CONFUSION."
	dex_end

GolbatPokedexDescription: ; 0x2e8be
	dex_text "Once it strikes,"
	dex_line "it will not stop"
	dex_line "draining energy"
	dex_line "from the victim"
	dex_line "even if it gets"
	dex_line "too heavy to fly."
	dex_end

MewtwoPokedexDescription: ; 0x2e922
	dex_text "It was created by"
	dex_line "a scientist after"
	dex_line "years of horrific"
	dex_line "gene splicing and"
	dex_line "DNA engineering"
	dex_line "experiments."
	dex_end

SnorlaxPokedexDescription: ; 0x2e987
	dex_text "Very lazy. Just"
	dex_line "eats and sleeps."
	dex_line "As its rotund"
	dex_line "bulk builds, it"
	dex_line "becomes steadily"
	dex_line "more slothful."
	dex_end

MagikarpPokedexDescription: ; 0x2e9e6
	dex_text "In the distant"
	dex_line "past, it was"
	dex_line "somewhat stronger"
	dex_line "than the horribly"
	dex_line "weak descendants"
	dex_line "that exist today."
	dex_end

MukPokedexDescription: ; 0x2ea49
	dex_text "Thickly covered"
	dex_line "with a filthy,"
	dex_line "vile sludge. It"
	dex_line "is so toxic, even"
	dex_line "its footprints"
	dex_line "contain poison."
	dex_end

KinglerPokedexDescription: ; 0x2eaa9
	dex_text "The large pincer"
	dex_line "has 10000 hp of"
	dex_line "crushing power."
	dex_line "However, its huge"
	dex_line "size makes it"
	dex_line "unwieldy to use."
	dex_end

CloysterPokedexDescription: ; 0x2eb0b
	dex_text "When attacked, it"
	dex_line "launches its"
	dex_line "horns in quick"
	dex_line "volleys. Its"
	dex_line "innards have"
	dex_line "never been seen."
	dex_end

ElectrodePokedexDescription: ; 0x2eb64
	dex_text "It stores electric"
	dex_line "energy under very"
	dex_line "high pressure."
	dex_line "It often explodes"
	dex_line "with little or no"
	dex_line "provocation."
	dex_end

ClefablePokedexDescription: ; 0x2ebc9
	dex_text "A timid fairy"
	dex_line "POKéMON that is"
	dex_line "rarely seen. It"
	dex_line "will run and hide"
	dex_line "the moment it"
	dex_line "senses people."
	dex_end

WeezingPokedexDescription: ; 0x2ec26
	dex_text "Where two kinds"
	dex_line "of poison gases"
	dex_line "meet, 2 KOFFINGs"
	dex_line "can fuse into a"
	dex_line "WEEZING over many"
	dex_line "years."
	dex_end

PersianPokedexDescription: ; 0x2ec80
	dex_text "Although its fur"
	dex_line "has many admirers,"
	dex_line "it is tough to"
	dex_line "raise as a pet"
	dex_line "because of its"
	dex_line "fickle meanness."
	dex_end

MarowakPokedexDescription: ; 0x2ece2
	dex_text "The bone it holds"
	dex_line "is its key weapon."
	dex_line "It throws the"
	dex_line "bone skillfully"
	dex_line "like a boomerang"
	dex_line "to KO targets."
	dex_end

HaunterPokedexDescription: ; 0x2ed45
	dex_text "Because of its"
	dex_line "ability to slip"
	dex_line "through block"
	dex_line "walls, it is said"
	dex_line "to be from an-"
	dex_line "other dimension."
	dex_end

AbraPokedexDescription: ; 0x2eda4
	dex_text "Using its ability"
	dex_line "to read minds, it"
	dex_line "will identify"
	dex_line "impending danger"
	dex_line "and TELEPORT to"
	dex_line "safety."
	dex_end

AlakazamPokedexDescription: ; 0x2edff
	dex_text "Its brain can out-"
	dex_line "perform a super-"
	dex_line "computer."
	dex_line "Its intelligence"
	dex_line "quotient is said"
	dex_line "to be 5,000."
	dex_end

PidgeottoPokedexDescription: ; 0x2ee5c
	dex_text "Very protective"
	dex_line "of its sprawling"
	dex_line "territorial area,"
	dex_line "this POKéMON will"
	dex_line "fiercely peck at"
	dex_line "any intruder."
	dex_end

PidgeotPokedexDescription: ; 0x2eec0
	dex_text "When hunting, it"
	dex_line "skims the surface"
	dex_line "of water at high"
	dex_line "speed to pick off"
	dex_line "unwary prey such"
	dex_line "as MAGIKARP."
	dex_end

StarmiePokedexDescription: ; 0x2ef24
	dex_text "Its central core"
	dex_line "glows with the"
	dex_line "seven colors of"
	dex_line "the rainbow. Some"
	dex_line "people value the"
	dex_line "core as a gem."
	dex_end

BulbasaurPokedexDescription: ; 0x2ef86
	dex_text "A strange seed was"
	dex_line "planted on its"
	dex_line "back at birth."
	dex_line "The plant sprouts"
	dex_line "and grows with"
	dex_line "this POKéMON."
	dex_end

VenusaurPokedexDescription: ; 0x2efe6
	dex_text "The plant blooms"
	dex_line "when it is"
	dex_line "absorbing solar"
	dex_line "energy. It stays"
	dex_line "on the move to"
	dex_line "seek sunlight."
	dex_end

TentacruelPokedexDescription: ; 0x2f041
	dex_text "The tentacles are"
	dex_line "normally kept"
	dex_line "short. On hunts,"
	dex_line "they are extended"
	dex_line "to ensnare and"
	dex_line "immobilize prey."
	dex_end

GoldeenPokedexDescription: ; 0x2f0a4
	dex_text "Its tail fin"
	dex_line "billows like an"
	dex_line "elegant ballroom"
	dex_line "dress, giving it"
	dex_line "the nickname of"
	dex_line "the Water Queen."
	dex_end

SeakingPokedexDescription: ; 0x2f104
	dex_text "In the autumn"
	dex_line "spawning season,"
	dex_line "they can be seen"
	dex_line "swimming power-"
	dex_line "fully up rivers"
	dex_line "and creeks."
	dex_end

PonytaPokedexDescription: ; 0x2f160
	dex_text "Its hooves are 10"
	dex_line "times harder than"
	dex_line "diamonds. It can"
	dex_line "trample anything"
	dex_line "completely flat"
	dex_line "in little time."
	dex_end

RapidashPokedexDescription: ; 0x2f1c6
	dex_text "Very competitive,"
	dex_line "this POKéMON will"
	dex_line "chase anything"
	dex_line "that moves fast"
	dex_line "in the hopes of"
	dex_line "racing it."
	dex_end

RattataPokedexDescription: ; 0x2f224
	dex_text "Bites anything"
	dex_line "when it attacks."
	dex_line "Small and very"
	dex_line "quick, it is a"
	dex_line "common sight in"
	dex_line "many places."
	dex_end

RaticatePokedexDescription: ; 0x2f27f
	dex_text "It uses its whis-"
	dex_line "kers to maintain"
	dex_line "its balance."
	dex_line "It apparently"
	dex_line "slows down if"
	dex_line "they are cut off."
	dex_end

NidorinoPokedexDescription: ; 0x2f2dd
	dex_text "An aggressive"
	dex_line "POKéMON that is"
	dex_line "quick to attack."
	dex_line "The horn on its"
	dex_line "head secretes a"
	dex_line "powerful venom."
	dex_end

NidorinaPokedexDescription: ; 0x2f33c
	dex_text "The female`s horn"
	dex_line "develops slowly."
	dex_line "Prefers physical"
	dex_line "attacks such as"
	dex_line "clawing and"
	dex_line "biting."
	dex_end

GeodudePokedexDescription: ; 0x2f394
	dex_text "Found in fields"
	dex_line "and mountains."
	dex_line "Mistaking them"
	dex_line "for boulders,"
	dex_line "people often step"
	dex_line "or trip on them."
	dex_end

PorygonPokedexDescription: ; 0x2f3f3
	dex_text "A POKéMON that"
	dex_line "consists entirely"
	dex_line "of programming"
	dex_line "code. Capable of"
	dex_line "moving freely in"
	dex_line "cyberspace."
	dex_end

AerodactylPokedexDescription: ; 0x2f451
	dex_text "A ferocious, pre-"
	dex_line "historic POKéMON"
	dex_line "that goes for the"
	dex_line "enemy`s throat"
	dex_line "with its serrated"
	dex_line "saw-like fangs."
	dex_end

MagnemitePokedexDescription: ; 0x2f4b7
	dex_text "Uses anti-gravity"
	dex_line "to stay suspended."
	dex_line "Appears without"
	dex_line "warning and uses"
	dex_line "THUNDER WAVE and"
	dex_line "similar moves."
	dex_end

CharmanderPokedexDescription: ; 0x2f51d
	dex_text "Obviously prefers"
	dex_line "hot places. When"
	dex_line "it rains, steam"
	dex_line "is said to spout"
	dex_line "from the tip of"
	dex_line "its tail."
	dex_end

SquirtlePokedexDescription: ; 0x2f57b
	dex_text "After birth, its"
	dex_line "back swells and"
	dex_line "hardens into a"
	dex_line "shell. Powerfully"
	dex_line "sprays foam from"
	dex_line "its mouth."
	dex_end

CharmeleonPokedexDescription: ; 0x2f5d9
	dex_text "When it swings"
	dex_line "its burning tail,"
	dex_line "it elevates the"
	dex_line "temperature to"
	dex_line "unbearably high"
	dex_line "levels."
	dex_end

WartortlePokedexDescription: ; 0x2f631
	dex_text "Often hides in"
	dex_line "water to stalk"
	dex_line "unwary prey. For"
	dex_line "swimming fast, it"
	dex_line "moves its ears to"
	dex_line "maintain balance."
	dex_end

CharizardPokedexDescription: ; 0x2f696
	dex_text "Spits fire that"
	dex_line "is hot enough to"
	dex_line "melt boulders."
	dex_line "Known to cause"
	dex_line "forest fires"
	dex_line "unintentionally."
	dex_end

OddishPokedexDescription: ; 0x2f6f3
	dex_text "During the day,"
	dex_line "it keeps its face"
	dex_line "buried in the"
	dex_line "ground. At night,"
	dex_line "it wanders around"
	dex_line "sowing its seeds."
	dex_end

GloomPokedexDescription: ; 0x2f759
	dex_text "The fluid that"
	dex_line "oozes from its"
	dex_line "mouth isn`t drool."
	dex_line "It is a nectar"
	dex_line "that is used to"
	dex_line "attract prey."
	dex_end

VileplumePokedexDescription: ; 0x2f7b7
	dex_text "The larger its"
	dex_line "petals, the more"
	dex_line "toxic pollen it"
	dex_line "contains. Its big"
	dex_line "head is heavy and"
	dex_line "hard to hold up."
	dex_end

BellsproutPokedexDescription: ; 0x2f81c
	dex_text "A carnivorous"
	dex_line "POKéMON that traps"
	dex_line "and eats bugs."
	dex_line "It uses its root"
	dex_line "feet to soak up"
	dex_line "needed moisture."
	dex_end

WeepinbellPokedexDescription: ; 0x2f87e
	dex_text "It spits out"
	dex_line "POISONPOWDER to"
	dex_line "immobilize the"
	dex_line "enemy and then"
	dex_line "finishes it with"
	dex_line "a spray of ACID."
	dex_end

VictreebellPokedexDescription: ; 0x2f8d8
	dex_text "Said to live in"
	dex_line "huge colonies"
	dex_line "deep in jungles,"
	dex_line "although no one"
	dex_line "has ever returned"
	dex_line "from there."
	dex_end

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
	ld [wd7ab], a
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
	ld a, $c
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
	ld a, $c
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

BallSaver30SecondsOnPic: ; 0x58000
	INCBIN "gfx/billboard/slot/30secondballsaver_on.2bpp"
BallSaver30SecondsOffPic: ; 0x58180
	INCBIN "gfx/billboard/slot/30secondballsaver_off.2bpp"
BallSaver60SecondsOnPic: ; 0x58300
	INCBIN "gfx/billboard/slot/60secondballsaver_on.2bpp"
BallSaver60SecondsOffPic: ; 0x580480
	INCBIN "gfx/billboard/slot/60secondballsaver_off.2bpp"
BallSaver90SecondsOnPic: ; 0x58600
	INCBIN "gfx/billboard/slot/90secondballsaver_on.2bpp"
BallSaver90SecondsOffPic: ; 0x58780
	INCBIN "gfx/billboard/slot/90secondballsaver_off.2bpp"
PikachuSaverOnPic: ; 0x58900
	INCBIN "gfx/billboard/slot/pikachusaver_on.2bpp"
PikachuSaverOffPic: ; 0x58a80
	INCBIN "gfx/billboard/slot/pikachusaver_off.2bpp"
ExtraBallOnPic: ; 0x58c00
	INCBIN "gfx/billboard/slot/extraball_on.2bpp"
ExtraBallOffPic: ; 0x58d80
	INCBIN "gfx/billboard/slot/extraball_off.2bpp"
SmallRewardOnPic: ; 0x58f00
	INCBIN "gfx/billboard/slot/small_on.2bpp"
SmallRewardOffPic: ; 0x59080
	INCBIN "gfx/billboard/slot/small_off.2bpp"
BigRewardOnPic: ; 0x59200
	INCBIN "gfx/billboard/slot/big_on.2bpp"
BigRewardOffPic: ; 0x59380
	INCBIN "gfx/billboard/slot/big_off.2bpp"
CatchEmModeOnPic: ; 0x59500
	INCBIN "gfx/billboard/slot/catchem_on.2bpp"
CatchEmModeOffPic: ; 0x59680
	INCBIN "gfx/billboard/slot/catchem_off.2bpp"
EvolutionModeOnPic: ; 0x59800
	INCBIN "gfx/billboard/slot/evolution_on.2bpp"
EvolutionModeOffPic: ; 0x59980
	INCBIN "gfx/billboard/slot/evolution_off.2bpp"
GreatBallOnPic: ; 0x59b00
	INCBIN "gfx/billboard/slot/greatball_on.2bpp"
GreatBallOffPic: ; 0x59c80
	INCBIN "gfx/billboard/slot/greatball_off.2bpp"
UltraBallOnPic: ; 0x59e00
	INCBIN "gfx/billboard/slot/ultraball_on.2bpp"
UltraBallOffPic: ; 0x59f80
	INCBIN "gfx/billboard/slot/ultraball_off.2bpp"
MasterBallOnPic: ; 0x5a100
	INCBIN "gfx/billboard/slot/masterball_on.2bpp"
MasterBallOffPic: ; 0x5a280
	INCBIN "gfx/billboard/slot/masterball_off.2bpp"
BonusMultiplierOnPic: ; 0x5a400
	INCBIN "gfx/billboard/slot/bonusmultiplier_on.2bpp"
BonusMultiplierOffPic: ; 0x5a580
	INCBIN "gfx/billboard/slot/bonusmultiplier_off.2bpp"
HurryUpOnPic: ; 0x5a700
	INCBIN "gfx/billboard/hurryup_on.2bpp"
HurryUpOffPic: ; 0x5a880
	INCBIN "gfx/billboard/hurryup_off.2bpp"
HurryUp2OnPic: ; 0x5aa00
	INCBIN "gfx/billboard/hurryup2_on.2bpp"
HurryUp2OffPic: ; 0x5ab80
	INCBIN "gfx/billboard/hurryup2_off.2bpp"
GoToNextOnPic: ; 0x5ad00
	INCBIN "gfx/billboard/gotonext_on.2bpp"
GoToNextOffPic: ; 0x5ae80
	INCBIN "gfx/billboard/gotonext_off.2bpp"
GoToGengarBonusOnPic: ; 0x5b000
	INCBIN "gfx/billboard/bonus_stages/gotogengarbonus_on.2bpp"
GoToGengarBonusOffPic: ; 0x5b180
	INCBIN "gfx/billboard/bonus_stages/gotogengarbonus_off.2bpp"
GoToMewtwoBonusOnPic: ; 0x5b300
	INCBIN "gfx/billboard/bonus_stages/gotomewtwobonus_on.2bpp"
GoToMewtwoBonusOffPic: ; 0x5b480
	INCBIN "gfx/billboard/bonus_stages/gotomewtwobonus_off.2bpp"
GoToMeowthBonusOnPic: ; 0x5b600
	INCBIN "gfx/billboard/bonus_stages/gotomeowthbonus_on.2bpp"
GoToMeowthBonusOffPic: ; 0x5b780
	INCBIN "gfx/billboard/bonus_stages/gotomeowthbonus_off.2bpp"
GoToDiglettBonusOnPic: ; 0x5b900
	INCBIN "gfx/billboard/bonus_stages/gotodiglettbonus_on.2bpp"
GoToDiglettBonusOffPic: ; 0x5ba80
	INCBIN "gfx/billboard/bonus_stages/gotodiglettbonus_off.2bpp"
GoToSeelBonusOnPic: ; 0x5bc00
	INCBIN "gfx/billboard/bonus_stages/gotoseelbonus_on.2bpp"
GoToSeelBonusOffPic: ; 0x5bd80
	INCBIN "gfx/billboard/bonus_stages/gotoseelbonus_off.2bpp"

ChanseyBillboardBGPalette1: ; 0x5bf00
	RGB 31, 31, 31
	RGB 31, 15, 20
	RGB 27, 5, 7
	RGB 0, 0, 0
ChanseyBillboardBGPalette2: ; 0x5bf08
	RGB 31, 31, 31
	RGB 31, 15, 20
	RGB 27, 5, 7
	RGB 0, 0, 0

TangelaBillboardBGPalette1: ; 0x5bf10
	RGB 31, 31, 31
	RGB 15, 21, 29
	RGB 4, 8, 18
	RGB 0, 0, 0
TangelaBillboardBGPalette2: ; 0x5bf18
	RGB 31, 31, 31
	RGB 15, 21, 29
	RGB 4, 8, 18
	RGB 0, 0, 0

KangaskhanBillboardBGPalette1: ; 0x5bf20
	RGB 31, 31, 31
	RGB 31, 18, 9
	RGB 17, 10, 4
	RGB 0, 0, 0
KangaskhanBillboardBGPalette2: ; 0x5bf28
	RGB 31, 31, 31
	RGB 31, 18, 9
	RGB 17, 10, 4
	RGB 0, 0, 0

HorseaBillboardBGPalette1: ; 0x5bf30
	RGB 31, 31, 31
	RGB 12, 19, 31
	RGB 4, 7, 22
	RGB 0, 0, 0
HorseaBillboardBGPalette2: ; 0x5bf38
	RGB 31, 31, 31
	RGB 25, 26, 3
	RGB 4, 7, 22
	RGB 0, 0, 0

SeadraBillboardBGPalette1: ; 0x5bf40
	RGB 31, 31, 31
	RGB 12, 19, 31
	RGB 4, 7, 22
	RGB 0, 0, 0
SeadraBillboardBGPalette2: ; 0x5bf48
	RGB 31, 31, 31
	RGB 12, 19, 31
	RGB 4, 7, 22
	RGB 0, 0, 0

GoldeenBillboardBGPalette1: ; 0x5bf50
	RGB 31, 31, 31
	RGB 30, 16, 4
	RGB 29, 3, 0
	RGB 0, 0, 0
GoldeenBillboardBGPalette2: ; 0x5bf58
	RGB 31, 31, 31
	RGB 30, 16, 4
	RGB 29, 3, 0
	RGB 0, 0, 0

SeakingBillboardBGPalette1: ; 0x5bf60
	RGB 31, 31, 31
	RGB 29, 17, 5
	RGB 31, 5, 0
	RGB 0, 0, 0
SeakingBillboardBGPalette2: ; 0x5bf68
	RGB 31, 31, 31
	RGB 29, 17, 5
	RGB 31, 5, 0
	RGB 0, 0, 0

StaryuBillboardBGPalette1: ; 0x5bf70
	RGB 31, 31, 31
	RGB 31, 20, 0
	RGB 19, 3, 6
	RGB 0, 0, 0
StaryuBillboardBGPalette2: ; 0x5bf78
	RGB 31, 31, 31
	RGB 31, 16, 8
	RGB 25, 3, 2
	RGB 0, 0, 0

StarmieBillboardBGPalette1: ; 0x5bf80
	RGB 31, 31, 31
	RGB 31, 17, 0
	RGB 15, 8, 16
	RGB 0, 0, 0
StarmieBillboardBGPalette2: ; 0x5bf88
	RGB 31, 31, 31
	RGB 31, 16, 8
	RGB 25, 3, 2
	RGB 0, 0, 0

MrMimeBillboardBGPalette1: ; 0x5bf90
	RGB 31, 31, 31
	RGB 31, 17, 19
	RGB 28, 6, 4
	RGB 0, 0, 0
MrMimeBillboardBGPalette2: ; 0x5bf98
	RGB 31, 31, 31
	RGB 31, 17, 19
	RGB 28, 6, 4
	RGB 0, 0, 0

ScytherBillboardBGPalette1: ; 0x5bfa0
	RGB 31, 31, 31
	RGB 17, 31, 4
	RGB 4, 16, 4
	RGB 0, 0, 0
ScytherBillboardBGPalette2: ; 0x5bfa8
	RGB 31, 31, 31
	RGB 17, 31, 4
	RGB 4, 16, 4
	RGB 0, 0, 0

JynxBillboardBGPalette1: ; 0x5bfb0
	RGB 31, 31, 31
	RGB 29, 13, 15
	RGB 30, 6, 1
	RGB 0, 0, 0
JynxBillboardBGPalette2: ; 0x5bfb8
	RGB 31, 31, 31
	RGB 31, 21, 0
	RGB 30, 6, 1
	RGB 0, 0, 0

ElectabuzzBillboardBGPalette1: ; 0x5bfc0
	RGB 31, 31, 31
	RGB 31, 27, 0
	RGB 19, 11, 0
	RGB 0, 0, 0
ElectabuzzBillboardBGPalette2: ; 0x5bfc8
	RGB 31, 31, 31
	RGB 31, 27, 0
	RGB 19, 11, 0
	RGB 0, 0, 0

MagmarBillboardBGPalette1: ; 0x5bfd0
	RGB 31, 31, 31
	RGB 31, 27, 0
	RGB 28, 6, 0
	RGB 0, 0, 0
MagmarBillboardBGPalette2: ; 0x5bfd8
	RGB 31, 31, 31
	RGB 31, 27, 0
	RGB 28, 6, 0
	RGB 0, 0, 0

PinsirBillboardBGPalette1: ; 0x5bfe0
	RGB 31, 31, 31
	RGB 17, 23, 10
	RGB 21, 10, 3
	RGB 0, 0, 0
PinsirBillboardBGPalette2: ; 0x5bfe8
	RGB 31, 31, 31
	RGB 31, 19, 8
	RGB 21, 10, 3
	RGB 0, 0, 0

TaurosBillboardBGPalette1: ; 0x5bff0
	RGB 31, 31, 31
	RGB 31, 18, 7
	RGB 17, 9, 0
	RGB 0, 0, 0
TaurosBillboardBGPalette2: ; 0x5bff8
	RGB 31, 31, 31
	RGB 14, 16, 20
	RGB 17, 9, 0
	RGB 0, 0, 0

SECTION "bank17", ROMX, BANK[$17]

SmallReward100PointsOnPic: ; 0x5c000
	INCBIN "gfx/billboard/slot/100points_on.2bpp"
SmallReward100PointsOffPic: ; 0x5c180
	INCBIN "gfx/billboard/slot/100points_off.2bpp"
SmallReward200PointsOnPic: ; 0x5c300
	INCBIN "gfx/billboard/slot/200points_on.2bpp"
SmallReward200PointsOffPic: ; 0x54800
	INCBIN "gfx/billboard/slot/200points_off.2bpp"
SmallReward300PointsOnPic: ; 0x5c600
	INCBIN "gfx/billboard/slot/300points_on.2bpp"
SmallReward300PointsOffPic: ; 0x5c780
	INCBIN "gfx/billboard/slot/300points_off.2bpp"
SmallReward400PointsOnPic: ; 0x5c900
	INCBIN "gfx/billboard/slot/400points_on.2bpp"
SmallReward400PointsOffPic: ; 0x5ca80
	INCBIN "gfx/billboard/slot/400points_off.2bpp"
SmallReward500PointsOnPic: ; 0x5cc00
	INCBIN "gfx/billboard/slot/500points_on.2bpp"
SmallReward500PointsOffPic: ; 0x5cd80
	INCBIN "gfx/billboard/slot/500points_off.2bpp"
SmallReward600PointsOnPic: ; 0x5cf00
	INCBIN "gfx/billboard/slot/600points_on.2bpp"
SmallReward600PointsOffPic: ; 0x5d080
	INCBIN "gfx/billboard/slot/600points_off.2bpp"
SmallReward700PointsOnPic: ; 0x5d200
	INCBIN "gfx/billboard/slot/700points_on.2bpp"
SmallReward700PointsOffPic: ; 0x5d380
	INCBIN "gfx/billboard/slot/700points_off.2bpp"
SmallReward800PointsOnPic: ; 0x5d500
	INCBIN "gfx/billboard/slot/800points_on.2bpp"
SmallReward800PointsOffPic: ; 0x5d680
	INCBIN "gfx/billboard/slot/800points_off.2bpp"
SmallReward900PointsOnPic: ; 0x5d800
	INCBIN "gfx/billboard/slot/900points_on.2bpp"
SmallReward900PointsOffPic: ; 0x5d980
	INCBIN "gfx/billboard/slot/900points_off.2bpp"
BigReward1000000PointsOnPic: ; 0x5db00
	INCBIN "gfx/billboard/slot/1000000points_on.2bpp"
BigReward1000000PointsOffPic: ; 0x5dc80
	INCBIN "gfx/billboard/slot/1000000points_off.2bpp"
BigReward2000000PointsOnPic: ; 0x5de00
	INCBIN "gfx/billboard/slot/2000000points_on.2bpp"
BigReward2000000PointsOffPic: ; 0x5df80
	INCBIN "gfx/billboard/slot/2000000points_off.2bpp"
BigReward3000000PointsOnPic: ; 0x5e100
	INCBIN "gfx/billboard/slot/3000000points_on.2bpp"
BigReward3000000PointsOffPic: ; 0x5e280
	INCBIN "gfx/billboard/slot/3000000points_off.2bpp"
BigReward4000000PointsOnPic: ; 0x5e400
	INCBIN "gfx/billboard/slot/4000000points_on.2bpp"
BigReward4000000PointsOffPic: ; 0x5e580
	INCBIN "gfx/billboard/slot/4000000points_off.2bpp"
BigReward5000000PointsOnPic: ; 0x5e700
	INCBIN "gfx/billboard/slot/5000000points_on.2bpp"
BigReward5000000PointsOffPic: ; 0x5e880
	INCBIN "gfx/billboard/slot/5000000points_off.2bpp"
BigReward6000000PointsOnPic: ; 0x5ea00
	INCBIN "gfx/billboard/slot/6000000points_on.2bpp"
BigReward6000000PointsOffPic: ; 0x5eb80
	INCBIN "gfx/billboard/slot/6000000points_off.2bpp"
BigReward7000000PointsOnPic: ; 0x5ed00
	INCBIN "gfx/billboard/slot/7000000points_on.2bpp"
BigReward7000000PointsOffPic: ; 0x5ee80
	INCBIN "gfx/billboard/slot/7000000points_off.2bpp"
BigReward8000000PointsOnPic: ; 0x5f000
	INCBIN "gfx/billboard/slot/8000000points_on.2bpp"
BigReward8000000PointsOffPic: ; 0x5f180
	INCBIN "gfx/billboard/slot/8000000points_off.2bpp"
BigReward9000000PointsOnPic: ; 0x5f300
	INCBIN "gfx/billboard/slot/9000000points_on.2bpp"
BigReward9000000PointsOffPic: ; 0x5f480
	INCBIN "gfx/billboard/slot/9000000points_off.2bpp"

MeowthBonusBaseGameBoyGfx: ; 0x5f600
	INCBIN "gfx/stage/meowth_bonus/meowth_bonus_base_gameboy.2bpp"

SECTION "bank18", ROMX, BANK[$18]

VenomothPic: ; 0x60000
	INCBIN "gfx/billboard/mon_pics/venomoth.2bpp"
VenomothSilhouettePic: ; 0x60180
	INCBIN "gfx/billboard/mon_silhouettes/venomoth.2bpp"
DiglettPic: ; 0x60300
	INCBIN "gfx/billboard/mon_pics/diglett.2bpp"
DiglettSilhouettePic: ; 0x60480
	INCBIN "gfx/billboard/mon_silhouettes/diglett.2bpp"
DugtrioPic: ; 0x60600
	INCBIN "gfx/billboard/mon_pics/dugtrio.2bpp"
DugtrioSilhouettePic: ; 0x60780
	INCBIN "gfx/billboard/mon_silhouettes/dugtrio.2bpp"
MeowthPic: ; 0x60900
	INCBIN "gfx/billboard/mon_pics/meowth.2bpp"
MeowthSilhouettePic: ; 0x60a80
	INCBIN "gfx/billboard/mon_silhouettes/meowth.2bpp"
PersianPic: ; 0x60c00
	INCBIN "gfx/billboard/mon_pics/persian.2bpp"
PersianSilhouettePic: ; 0x60d80
	INCBIN "gfx/billboard/mon_silhouettes/persian.2bpp"
PsyduckPic: ; 0x60f00
	INCBIN "gfx/billboard/mon_pics/psyduck.2bpp"
PsyduckSilhouettePic: ; 0x61080
	INCBIN "gfx/billboard/mon_silhouettes/psyduck.2bpp"
GolduckPic: ; 0x61200
	INCBIN "gfx/billboard/mon_pics/golduck.2bpp"
GolduckSilhouettePic:  ; 0x61380
	INCBIN "gfx/billboard/mon_silhouettes/golduck.2bpp"
MankeyPic: ; 0x61500
	INCBIN "gfx/billboard/mon_pics/mankey.2bpp"
MankeySilhouettePic: ; 0x61680
	INCBIN "gfx/billboard/mon_silhouettes/mankey.2bpp"
PrimeapePic: ; 0x61800
	INCBIN "gfx/billboard/mon_pics/primeape.2bpp"
PrimeapeSilhouettePic: ; 0x61980
	INCBIN "gfx/billboard/mon_silhouettes/primeape.2bpp"
GrowlithePic: ; 0x61b00
	INCBIN "gfx/billboard/mon_pics/growlithe.2bpp"
GrowlitheSilhouettePic: ; 0x61c80
	INCBIN "gfx/billboard/mon_silhouettes/growlithe.2bpp"
ArcaninePic: ; 0x61e00
	INCBIN "gfx/billboard/mon_pics/arcanine.2bpp"
ArcanineSilhouettePic: ; 0x61f80
	INCBIN "gfx/billboard/mon_silhouettes/arcanine.2bpp"
PoliwagPic: ; 0x62100
	INCBIN "gfx/billboard/mon_pics/poliwag.2bpp"
PoliwagSilhouettePic: ; 0x62280
	INCBIN "gfx/billboard/mon_silhouettes/poliwag.2bpp"
PoliwhirlPic: ; 0x62400
	INCBIN "gfx/billboard/mon_pics/poliwhirl.2bpp"
PoliwhirlSilhouettePic: ; 0x62580
	INCBIN "gfx/billboard/mon_silhouettes/poliwhirl.2bpp"
PoliwrathPic: ; 0x62700
	INCBIN "gfx/billboard/mon_pics/poliwrath.2bpp"
PoliwrathSilhouettePic: ; 0x62880
	INCBIN "gfx/billboard/mon_silhouettes/poliwrath.2bpp"
AbraPic: ; 0x62a00
	INCBIN "gfx/billboard/mon_pics/abra.2bpp"
AbraSilhouettePic: ; 0x62b80
	INCBIN "gfx/billboard/mon_silhouettes/abra.2bpp"
KadabraPic: ; 0x62d00
	INCBIN "gfx/billboard/mon_pics/kadabra.2bpp"
KadabraSilhouettePic: ; 0x62e80
	INCBIN "gfx/billboard/mon_silhouettes/kadabra.2bpp"

StageRedFieldTopStatusBarSymbolsGfx_GameBoy: ; 0x63000
	INCBIN "gfx/stage/red_top/status_bar_symbols_gameboy.2bpp"
	dr $63100, $632a0

StageRedFieldTopBaseGameBoyGfx: ; 0x632a0
	INCBIN "gfx/stage/red_top/red_top_base_gameboy.2bpp"

SECTION "bank19", ROMX, BANK[$19]

NidorinoPic: ; 0x64000
	INCBIN "gfx/billboard/mon_pics/nidorino.2bpp"
NidorinoSilhouettePic: ; 0x64180
	INCBIN "gfx/billboard/mon_silhouettes/nidorino.2bpp"
NidokingPic: ; 0x64300
	INCBIN "gfx/billboard/mon_pics/nidoking.2bpp"
NidokingSilhouettePic: ; 0x64480
	INCBIN "gfx/billboard/mon_silhouettes/nidoking.2bpp"
ClefairyPic: ; 0x64600
	INCBIN "gfx/billboard/mon_pics/clefairy.2bpp"
ClefairySilhouettePic: ; 0x64780
	INCBIN "gfx/billboard/mon_silhouettes/clefairy.2bpp"
ClefablePic: ; 0x64900
	INCBIN "gfx/billboard/mon_pics/clefable.2bpp"
ClefableSilhouettePic: ; 0x64a80
	INCBIN "gfx/billboard/mon_silhouettes/clefable.2bpp"
VulpixPic: ; 0x64c00
	INCBIN "gfx/billboard/mon_pics/vulpix.2bpp"
VulpixSilhouettePic: ; 0x64d80
	INCBIN "gfx/billboard/mon_silhouettes/vulpix.2bpp"
NinetalesPic: ; 0x64f00
	INCBIN "gfx/billboard/mon_pics/ninetales.2bpp"
NinetalesSilhouettePic: ; 0x65080
	INCBIN "gfx/billboard/mon_silhouettes/ninetales.2bpp"
JigglypuffPic: ; 0x65200
	INCBIN "gfx/billboard/mon_pics/jigglypuff.2bpp"
JigglypuffSilhouettePic:  ; 0x65380
	INCBIN "gfx/billboard/mon_silhouettes/jigglypuff.2bpp"
WigglytuffPic: ; 0x65500
	INCBIN "gfx/billboard/mon_pics/wigglytuff.2bpp"
WigglytuffSilhouettePic: ; 0x65680
	INCBIN "gfx/billboard/mon_silhouettes/wigglytuff.2bpp"
ZubatPic: ; 0x65800
	INCBIN "gfx/billboard/mon_pics/zubat.2bpp"
ZubatSilhouettePic: ; 0x65980
	INCBIN "gfx/billboard/mon_silhouettes/zubat.2bpp"
GolbatPic: ; 0x65b00
	INCBIN "gfx/billboard/mon_pics/golbat.2bpp"
GolbatSilhouettePic: ; 0x65c80
	INCBIN "gfx/billboard/mon_silhouettes/golbat.2bpp"
OddishPic: ; 0x65e00
	INCBIN "gfx/billboard/mon_pics/oddish.2bpp"
OddishSilhouettePic: ; 0x65f80
	INCBIN "gfx/billboard/mon_silhouettes/oddish.2bpp"
GloomPic: ; 0x66100
	INCBIN "gfx/billboard/mon_pics/gloom.2bpp"
GloomSilhouettePic: ; 0x66280
	INCBIN "gfx/billboard/mon_silhouettes/gloom.2bpp"
VileplumePic: ; 0x66400
	INCBIN "gfx/billboard/mon_pics/vileplume.2bpp"
VileplumeSilhouettePic: ; 0x66580
	INCBIN "gfx/billboard/mon_silhouettes/vileplume.2bpp"
ParasPic: ; 0x66700
	INCBIN "gfx/billboard/mon_pics/paras.2bpp"
ParasSilhouettePic: ; 0x66880
	INCBIN "gfx/billboard/mon_silhouettes/paras.2bpp"
ParasectPic: ; 0x66a00
	INCBIN "gfx/billboard/mon_pics/parasect.2bpp"
ParasectSilhouettePic: ; 0x66b80
	INCBIN "gfx/billboard/mon_silhouettes/parasect.2bpp"
VenonatPic: ; 0x66d00
	INCBIN "gfx/billboard/mon_pics/venonat.2bpp"
VenonatSilhouettePic: ; 0x66e80
	INCBIN "gfx/billboard/mon_silhouettes/venonat.2bpp"

StageBlueFieldBottomBaseGameBoyGfx: ; 0x67000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_base_gameboy.2bpp"

SECTION "bank1a", ROMX, BANK[$1a]

ChanseyPic: ; 0x68000
	INCBIN "gfx/billboard/mon_pics/chansey.2bpp"
ChanseySilhouettePic: ; 0x68180
	INCBIN "gfx/billboard/mon_silhouettes/chansey.2bpp"
TangelaPic: ; 0x68300
	INCBIN "gfx/billboard/mon_pics/tangela.2bpp"
TangelaSilhouettePic: ; 0x68480
	INCBIN "gfx/billboard/mon_silhouettes/tangela.2bpp"
KangaskhanPic: ; 0x68600
	INCBIN "gfx/billboard/mon_pics/kangaskhan.2bpp"
KangaskhanSilhouettePic: ; 0x68780
	INCBIN "gfx/billboard/mon_silhouettes/kangaskhan.2bpp"
HorseaPic: ; 0x68900
	INCBIN "gfx/billboard/mon_pics/horsea.2bpp"
HorseaSilhouettePic: ; 0x68a80
	INCBIN "gfx/billboard/mon_silhouettes/horsea.2bpp"
SeadraPic: ; 0x68c00
	INCBIN "gfx/billboard/mon_pics/seadra.2bpp"
SeadraSilhouettePic: ; 0x68d80
	INCBIN "gfx/billboard/mon_silhouettes/seadra.2bpp"
GoldeenPic: ; 0x68f00
	INCBIN "gfx/billboard/mon_pics/goldeen.2bpp"
GoldeenSilhouettePic: ; 0x69080
	INCBIN "gfx/billboard/mon_silhouettes/goldeen.2bpp"
SeakingPic: ; 0x69200
	INCBIN "gfx/billboard/mon_pics/seaking.2bpp"
SeakingSilhouettePic:  ; 0x69380
	INCBIN "gfx/billboard/mon_silhouettes/seaking.2bpp"
StaryuPic: ; 0x69500
	INCBIN "gfx/billboard/mon_pics/staryu.2bpp"
StaryuSilhouettePic: ; 0x69680
	INCBIN "gfx/billboard/mon_silhouettes/staryu.2bpp"
StarmiePic: ; 0x69800
	INCBIN "gfx/billboard/mon_pics/starmie.2bpp"
StarmieSilhouettePic: ; 0x69980
	INCBIN "gfx/billboard/mon_silhouettes/starmie.2bpp"
Mr_MimePic: ; 0x69b00
	INCBIN "gfx/billboard/mon_pics/mr_mime.2bpp"
Mr_MimeSilhouettePic: ; 0x69c80
	INCBIN "gfx/billboard/mon_silhouettes/mr_mime.2bpp"
ScytherPic: ; 0x69e00
	INCBIN "gfx/billboard/mon_pics/scyther.2bpp"
ScytherSilhouettePic: ; 0x69f80
	INCBIN "gfx/billboard/mon_silhouettes/scyther.2bpp"
JynxPic: ; 0x6a100
	INCBIN "gfx/billboard/mon_pics/jynx.2bpp"
JynxSilhouettePic: ; 0x6a280
	INCBIN "gfx/billboard/mon_silhouettes/jynx.2bpp"
ElectabuzzPic: ; 0x6a400
	INCBIN "gfx/billboard/mon_pics/electabuzz.2bpp"
ElectabuzzSilhouettePic: ; 0x6a580
	INCBIN "gfx/billboard/mon_silhouettes/electabuzz.2bpp"
MagmarPic: ; 0x6a700
	INCBIN "gfx/billboard/mon_pics/magmar.2bpp"
MagmarSilhouettePic: ; 0x6a880
	INCBIN "gfx/billboard/mon_silhouettes/magmar.2bpp"
PinsirPic: ; 0x6aa00
	INCBIN "gfx/billboard/mon_pics/pinsir.2bpp"
PinsirSilhouettePic: ; 0x6ab80
	INCBIN "gfx/billboard/mon_silhouettes/pinsir.2bpp"
TaurosPic: ; 0x6ad00
	INCBIN "gfx/billboard/mon_pics/tauros.2bpp"
TaurosSilhouettePic: ; 0x6ae80
	INCBIN "gfx/billboard/mon_silhouettes/tauros.2bpp"

StageBlueFieldTopStatusBarSymbolsGfx_GameBoy: ; 0x6b000
	INCBIN "gfx/stage/blue_top/status_bar_symbols_gameboy.2bpp"
	dr $6b100, $6b2a0

StageBlueFieldTopBaseGameBoyGfx: ; 0x6b2a0
	INCBIN "gfx/stage/blue_top/blue_top_base_gameboy.2bpp"

SECTION "bank1b", ROMX, BANK[$1b]

MagikarpPic: ; 0x6c000
	INCBIN "gfx/billboard/mon_pics/magikarp.2bpp"
MagikarpSilhouettePic: ; 0x6c180
	INCBIN "gfx/billboard/mon_silhouettes/magikarp.2bpp"
GyaradosPic: ; 0x6c300
	INCBIN "gfx/billboard/mon_pics/gyarados.2bpp"
GyaradosSilhouettePic: ; 0x6c480
	INCBIN "gfx/billboard/mon_silhouettes/gyarados.2bpp"
LaprasPic: ; 0x6c600
	INCBIN "gfx/billboard/mon_pics/lapras.2bpp"
LaprasSilhouettePic: ; 0x6c780
	INCBIN "gfx/billboard/mon_silhouettes/lapras.2bpp"
DittoPic: ; 0x6c900
	INCBIN "gfx/billboard/mon_pics/ditto.2bpp"
DittoSilhouettePic: ; 0x6ca80
	INCBIN "gfx/billboard/mon_silhouettes/ditto.2bpp"
EeveePic: ; 0x6cc00
	INCBIN "gfx/billboard/mon_pics/eevee.2bpp"
EeveeSilhouettePic: ; 0x6cd80
	INCBIN "gfx/billboard/mon_silhouettes/eevee.2bpp"
VaporeonPic: ; 0x6cf00
	INCBIN "gfx/billboard/mon_pics/vaporeon.2bpp"
VaporeonSilhouettePic: ; 0x6d080
	INCBIN "gfx/billboard/mon_silhouettes/vaporeon.2bpp"
JolteonPic: ; 0x6d200
	INCBIN "gfx/billboard/mon_pics/jolteon.2bpp"
JolteonSilhouettePic:  ; 0x6d380
	INCBIN "gfx/billboard/mon_silhouettes/jolteon.2bpp"
FlareonPic: ; 0x6d500
	INCBIN "gfx/billboard/mon_pics/flareon.2bpp"
FlareonSilhouettePic: ; 0x6d680
	INCBIN "gfx/billboard/mon_silhouettes/flareon.2bpp"
PorygonPic: ; 0x6d800
	INCBIN "gfx/billboard/mon_pics/porygon.2bpp"
PorygonSilhouettePic: ; 0x6d980
	INCBIN "gfx/billboard/mon_silhouettes/porygon.2bpp"
OmanytePic: ; 0x6db00
	INCBIN "gfx/billboard/mon_pics/omanyte.2bpp"
OmanyteSilhouettePic: ; 0x6dc80
	INCBIN "gfx/billboard/mon_silhouettes/omanyte.2bpp"
OmastarPic: ; 0x6de00
	INCBIN "gfx/billboard/mon_pics/omastar.2bpp"
OmastarSilhouettePic: ; 0x6df80
	INCBIN "gfx/billboard/mon_silhouettes/omastar.2bpp"
KabutoPic: ; 0x6e100
	INCBIN "gfx/billboard/mon_pics/kabuto.2bpp"
KabutoSilhouettePic: ; 0x6e280
	INCBIN "gfx/billboard/mon_silhouettes/kabuto.2bpp"
KabutopsPic: ; 0x6e400
	INCBIN "gfx/billboard/mon_pics/kabutops.2bpp"
KabutopsSilhouettePic: ; 0x6e580
	INCBIN "gfx/billboard/mon_silhouettes/kabutops.2bpp"
AerodactylPic: ; 0x6e700
	INCBIN "gfx/billboard/mon_pics/aerodactyl.2bpp"
AerodactylSilhouettePic: ; 0x6e880
	INCBIN "gfx/billboard/mon_silhouettes/aerodactyl.2bpp"
SnorlaxPic: ; 0x6ea00
	INCBIN "gfx/billboard/mon_pics/snorlax.2bpp"
SnorlaxSilhouettePic: ; 0x6eb80
	INCBIN "gfx/billboard/mon_silhouettes/snorlax.2bpp"
ArticunoPic: ; 0x6ed00
	INCBIN "gfx/billboard/mon_pics/articuno.2bpp"
ArticunoSilhouettePic: ; 0x6ee80
	INCBIN "gfx/billboard/mon_silhouettes/articuno.2bpp"

UnusedStageGfx: ; 0x6f000
	INCBIN "gfx/stage/unused_stage.2bpp"

SECTION "bank1c", ROMX, BANK[$1c]

ZapdosPic: ; 0x70000
	INCBIN "gfx/billboard/mon_pics/zapdos.2bpp"
ZapdosSilhouettePic: ; 0x70180
	INCBIN "gfx/billboard/mon_silhouettes/zapdos.2bpp"
MoltresPic: ; 0x70300
	INCBIN "gfx/billboard/mon_pics/moltres.2bpp"
MoltresSilhouettePic: ; 0x70480
	INCBIN "gfx/billboard/mon_silhouettes/moltres.2bpp"
DratiniPic: ; 0x70600
	INCBIN "gfx/billboard/mon_pics/dratini.2bpp"
DratiniSilhouettePic: ; 0x70780
	INCBIN "gfx/billboard/mon_silhouettes/dratini.2bpp"
DragonairPic: ; 0x70900
	INCBIN "gfx/billboard/mon_pics/dragonair.2bpp"
DragonairSilhouettePic: ; 0x70a80
	INCBIN "gfx/billboard/mon_silhouettes/dragonair.2bpp"
DragonitePic: ; 0x70c00
	INCBIN "gfx/billboard/mon_pics/dragonite.2bpp"
DragoniteSilhouettePic: ; 0x70d80
	INCBIN "gfx/billboard/mon_silhouettes/dragonite.2bpp"
MewtwoPic: ; 0x70f00
	INCBIN "gfx/billboard/mon_pics/mewtwo.2bpp"
MewtwoSilhouettePic: ; 0x71080
	INCBIN "gfx/billboard/mon_silhouettes/mewtwo.2bpp"
MewPic: ; 0x71200
	INCBIN "gfx/billboard/mon_pics/mew.2bpp"
MewSilhouettePic:  ; 0x71380
	INCBIN "gfx/billboard/mon_silhouettes/mew.2bpp"

Data_71500:
	dr $71500, $73000

GengarBonusBaseGameBoyGfx: ; 0x73000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_base_gameboy.2bpp"

SECTION "bank1d", ROMX, BANK[$1d]

PidgeottoPic: ; 0x74000
	INCBIN "gfx/billboard/mon_pics/pidgeotto.2bpp"
PidgeottoSilhouettePic: ; 0x74180
	INCBIN "gfx/billboard/mon_silhouettes/pidgeotto.2bpp"
PidgeotPic: ; 0x74300
	INCBIN "gfx/billboard/mon_pics/pidgeot.2bpp"
PidgeotSilhouettePic: ; 0x74480
	INCBIN "gfx/billboard/mon_silhouettes/pidgeot.2bpp"
RattataPic: ; 0x74600
	INCBIN "gfx/billboard/mon_pics/rattata.2bpp"
RattataSilhouettePic: ; 0x74780
	INCBIN "gfx/billboard/mon_silhouettes/rattata.2bpp"
RaticatePic: ; 0x74900
	INCBIN "gfx/billboard/mon_pics/raticate.2bpp"
RaticateSilhouettePic: ; 0x74a80
	INCBIN "gfx/billboard/mon_silhouettes/raticate.2bpp"
SpearowPic: ; 0x74c00
	INCBIN "gfx/billboard/mon_pics/spearow.2bpp"
SpearowSilhouettePic: ; 0x74d80
	INCBIN "gfx/billboard/mon_silhouettes/spearow.2bpp"
FearowPic: ; 0x74f00
	INCBIN "gfx/billboard/mon_pics/fearow.2bpp"
FearowSilhouettePic: ; 0x75080
	INCBIN "gfx/billboard/mon_silhouettes/fearow.2bpp"
EkansPic: ; 0x75200
	INCBIN "gfx/billboard/mon_pics/ekans.2bpp"
EkansSilhouettePic:  ; 0x75380
	INCBIN "gfx/billboard/mon_silhouettes/ekans.2bpp"
ArbokPic: ; 0x75500
	INCBIN "gfx/billboard/mon_pics/arbok.2bpp"
ArbokSilhouettePic: ; 0x75680
	INCBIN "gfx/billboard/mon_silhouettes/arbok.2bpp"
PikachuPic: ; 0x75800
	INCBIN "gfx/billboard/mon_pics/pikachu.2bpp"
PikachuSilhouettePic: ; 0x75980
	INCBIN "gfx/billboard/mon_silhouettes/pikachu.2bpp"
RaichuPic: ; 0x75b00
	INCBIN "gfx/billboard/mon_pics/raichu.2bpp"
RaichuSilhouettePic: ; 0x75c80
	INCBIN "gfx/billboard/mon_silhouettes/raichu.2bpp"
SandshrewPic: ; 0x75e00
	INCBIN "gfx/billboard/mon_pics/sandshrew.2bpp"
SandshrewSilhouettePic: ; 0x75f80
	INCBIN "gfx/billboard/mon_silhouettes/sandshrew.2bpp"
SandslashPic: ; 0x76100
	INCBIN "gfx/billboard/mon_pics/sandslash.2bpp"
SandslashSilhouettePic: ; 0x76280
	INCBIN "gfx/billboard/mon_silhouettes/sandslash.2bpp"
Nidoran_FPic: ; 0x76400
	INCBIN "gfx/billboard/mon_pics/nidoran_f.2bpp"
Nidoran_FSilhouettePic: ; 0x76580
	INCBIN "gfx/billboard/mon_silhouettes/nidoran_f.2bpp"
NidorinaPic: ; 0x76700
	INCBIN "gfx/billboard/mon_pics/nidorina.2bpp"
NidorinaSilhouettePic: ; 0x76880
	INCBIN "gfx/billboard/mon_silhouettes/nidorina.2bpp"
NidoqueenPic: ; 0x76a00
	INCBIN "gfx/billboard/mon_pics/nidoqueen.2bpp"
NidoqueenSilhouettePic: ; 0x76b80
	INCBIN "gfx/billboard/mon_silhouettes/nidoqueen.2bpp"
Nidoran_MPic: ; 0x76d00
	INCBIN "gfx/billboard/mon_pics/nidoran_m.2bpp"
Nidoran_MSilhouettePic: ; 0x76e80
	INCBIN "gfx/billboard/mon_silhouettes/nidoran_m.2bpp"

StageRedFieldBottomBaseGameBoyGfx: ; 0x77000
	INCBIN  "gfx/stage/red_bottom/red_bottom_base_gameboy.2bpp"

SECTION "bank1e", ROMX, BANK[$1e]

BulbasaurPic: ; 0x78000
	INCBIN "gfx/billboard/mon_pics/bulbasaur.2bpp"
BulbasaurSilhouettePic: ; 0x78180
	INCBIN "gfx/billboard/mon_silhouettes/bulbasaur.2bpp"
IvysaurPic: ; 0x78300
	INCBIN "gfx/billboard/mon_pics/ivysaur.2bpp"
IvysaurSilhouettePic: ; 0x78480
	INCBIN "gfx/billboard/mon_silhouettes/ivysaur.2bpp"
VenusaurPic: ; 0x78600
	INCBIN "gfx/billboard/mon_pics/venusaur.2bpp"
VenusaurSilhouettePic: ; 0x78780
	INCBIN "gfx/billboard/mon_silhouettes/venusaur.2bpp"
CharmanderPic: ; 0x78900
	INCBIN "gfx/billboard/mon_pics/charmander.2bpp"
CharmanderSilhouettePic: ; 0x78a80
	INCBIN "gfx/billboard/mon_silhouettes/charmander.2bpp"
CharmeleonPic: ; 0x78c00
	INCBIN "gfx/billboard/mon_pics/charmeleon.2bpp"
CharmeleonSilhouettePic: ; 0x78d80
	INCBIN "gfx/billboard/mon_silhouettes/charmeleon.2bpp"
CharizardPic: ; 0x78f00
	INCBIN "gfx/billboard/mon_pics/charizard.2bpp"
CharizardSilhouettePic: ; 0x79080
	INCBIN "gfx/billboard/mon_silhouettes/charizard.2bpp"
SquirtlePic: ; 0x79200
	INCBIN "gfx/billboard/mon_pics/squirtle.2bpp"
SquirtleSilhouettePic:  ; 0x79380
	INCBIN "gfx/billboard/mon_silhouettes/squirtle.2bpp"
WartortlePic: ; 0x79500
	INCBIN "gfx/billboard/mon_pics/wartortle.2bpp"
WartortleSilhouettePic: ; 0x79680
	INCBIN "gfx/billboard/mon_silhouettes/wartortle.2bpp"
BlastoisePic: ; 0x79800
	INCBIN "gfx/billboard/mon_pics/blastoise.2bpp"
BlastoiseSilhouettePic: ; 0x79980
	INCBIN "gfx/billboard/mon_silhouettes/blastoise.2bpp"
CaterpiePic: ; 0x79b00
	INCBIN "gfx/billboard/mon_pics/caterpie.2bpp"
CaterpieSilhouettePic: ; 0x79c80
	INCBIN "gfx/billboard/mon_silhouettes/caterpie.2bpp"
MetapodPic: ; 0x79e00
	INCBIN "gfx/billboard/mon_pics/metapod.2bpp"
MetapodSilhouettePic: ; 0x79f80
	INCBIN "gfx/billboard/mon_silhouettes/metapod.2bpp"
ButterfreePic: ; 0x7a100
	INCBIN "gfx/billboard/mon_pics/butterfree.2bpp"
ButterfreeSilhouettePic: ; 0x7a280
	INCBIN "gfx/billboard/mon_silhouettes/butterfree.2bpp"
WeedlePic: ; 0x7a400
	INCBIN "gfx/billboard/mon_pics/weedle.2bpp"
WeedleSilhouettePic: ; 0x7a580
	INCBIN "gfx/billboard/mon_silhouettes/weedle.2bpp"
KakunaPic: ; 0x7a700
	INCBIN "gfx/billboard/mon_pics/kakuna.2bpp"
KakunaSilhouettePic: ; 0x7a880
	INCBIN "gfx/billboard/mon_silhouettes/kakuna.2bpp"
BeedrillPic: ; 0x7aa00
	INCBIN "gfx/billboard/mon_pics/beedrill.2bpp"
BeedrillSilhouettePic: ; 0x7ab80
	INCBIN "gfx/billboard/mon_silhouettes/beedrill.2bpp"
PidgeyPic: ; 0x7ad00
	INCBIN "gfx/billboard/mon_pics/pidgey.2bpp"
PidgeySilhouettePic: ; 0x7ae80
	INCBIN "gfx/billboard/mon_silhouettes/pidgey.2bpp"

BonusMultiplierX1OnPic: ; 0x7b000
	INCBIN "gfx/billboard/slot/bonusmultiplierX1_on.2bpp"
BonusMultiplierX1OffPic: ; 0x7b180
	INCBIN "gfx/billboard/slot/bonusmultiplierX1_off.2bpp"
BonusMultiplierX2OnPic: ; 0x7b300
	INCBIN "gfx/billboard/slot/bonusmultiplierX2_on.2bpp"
BonusMultiplierX2OffPic: ; 0x7b480
	INCBIN "gfx/billboard/slot/bonusmultiplierX2_off.2bpp"
BonusMultiplierX3OnPic: ; 0x7b600
	INCBIN "gfx/billboard/slot/bonusmultiplierX3_on.2bpp"
BonusMultiplierX3OffPic: ; 0x7b780
	INCBIN "gfx/billboard/slot/bonusmultiplierX3_off.2bpp"
BonusMultiplierX4OnPic: ; 0x7b900
	INCBIN "gfx/billboard/slot/bonusmultiplierX4_on.2bpp"
BonusMultiplierX4OffPic: ; 0x7ba80
	INCBIN "gfx/billboard/slot/bonusmultiplierX4_off.2bpp"
BonusMultiplierX5OnPic: ; 0x7bc00
	INCBIN "gfx/billboard/slot/bonusmultiplierX5_on.2bpp"
BonusMultiplierX5OffPic: ; 0x7bd80
	INCBIN "gfx/billboard/slot/bonusmultiplierX5_off.2bpp"

MagikarpBillboardBGPalette1: ; 0x7bf00
	RGB 31, 31, 31
	RGB 29, 28, 4
	RGB 31, 7, 0
	RGB 0, 0, 0
MagikarpBillboardBGPalette2: ; 0x7bf08
	RGB 31, 31, 31
	RGB 31, 14, 12
	RGB 31, 7, 0
	RGB 0, 0, 0

GyaradosBillboardBGPalette1: ; 0x7bf10
	RGB 31, 31, 31
	RGB 12, 18, 31
	RGB 3, 9, 14
	RGB 0, 0, 0
GyaradosBillboardBGPalette2: ; 0x7bf18
	RGB 31, 31, 31
	RGB 31, 14, 16
	RGB 15, 3, 0
	RGB 0, 0, 0

LaprasBillboardBGPalette1: ; 0x7bf20
	RGB 31, 31, 31
	RGB 12, 19, 31
	RGB 5, 8, 19
	RGB 0, 0, 0
LaprasBillboardBGPalette2: ; 0x7bf28
	RGB 31, 31, 31
	RGB 12, 19, 31
	RGB 5, 8, 19
	RGB 0, 0, 0

DittoBillboardBGPalette1: ; 0x7bf30
	RGB 31, 31, 31
	RGB 26, 9, 21
	RGB 15, 2, 10
	RGB 0, 0, 0
DittoBillboardBGPalette2: ; 0x7bf38
	RGB 31, 31, 31
	RGB 26, 9, 21
	RGB 15, 2, 10
	RGB 0, 0, 0

EeveeBillboardBGPalette1: ; 0x7bf40
	RGB 31, 31, 31
	RGB 25, 16, 4
	RGB 12, 7, 0
	RGB 0, 0, 0
EeveeBillboardBGPalette2: ; 0x7bf48
	RGB 31, 31, 31
	RGB 25, 16, 4
	RGB 12, 7, 0
	RGB 0, 0, 0

VaporeonBillboardBGPalette1: ; 0x7bf50
	RGB 31, 31, 31
	RGB 10, 18, 29
	RGB 4, 6, 14
	RGB 0, 0, 0
VaporeonBillboardBGPalette2: ; 0x7bf58
	RGB 31, 31, 31
	RGB 31, 28, 7
	RGB 4, 6, 14
	RGB 0, 0, 0

JolteonBillboardBGPalette1: ; 0x7bf60
	RGB 31, 31, 31
	RGB 31, 26, 0
	RGB 15, 10, 0
	RGB 0, 0, 0
JolteonBillboardBGPalette2: ; 0x7bf68
	RGB 31, 31, 31
	RGB 31, 26, 0
	RGB 15, 10, 0
	RGB 0, 0, 0

FlareonBillboardBGPalette1: ; 0x7bf70
	RGB 31, 31, 31
	RGB 31, 27, 0
	RGB 31, 6, 0
	RGB 0, 0, 0
FlareonBillboardBGPalette2: ; 0x7bf78
	RGB 31, 31, 31
	RGB 31, 27, 0
	RGB 31, 6, 0
	RGB 0, 0, 0

PorygonBillboardBGPalette1: ; 0x7bf80
	RGB 31, 31, 31
	RGB 29, 12, 13
	RGB 2, 10, 17
	RGB 0, 0, 0
PorygonBillboardBGPalette2: ; 0x7bf88
	RGB 31, 31, 31
	RGB 5, 23, 31
	RGB 2, 10, 17
	RGB 0, 0, 0

OmanyteBillboardBGPalette1: ; 0x7bf90
	RGB 31, 31, 31
	RGB 22, 21, 14
	RGB 0, 15, 25
	RGB 0, 0, 0
OmanyteBillboardBGPalette2: ; 0x7bf98
	RGB 31, 31, 31
	RGB 11, 26, 29
	RGB 0, 15, 25
	RGB 0, 0, 0

OmastarBillboardBGPalette1: ; 0x7bfa0
	RGB 31, 31, 31
	RGB 22, 21, 14
	RGB 0, 15, 25
	RGB 0, 0, 0
OmastarBillboardBGPalette2: ; 0x7bfa8
	RGB 31, 31, 31
	RGB 11, 26, 29
	RGB 0, 15, 25
	RGB 0, 0, 0

KabutoBillboardBGPalette1: ; 0x7bfb0
	RGB 31, 31, 31
	RGB 29, 18, 0
	RGB 14, 6, 0
	RGB 0, 0, 0
KabutoBillboardBGPalette2: ; 0x7bfb8
	RGB 31, 6, 0
	RGB 29, 18, 0
	RGB 14, 6, 0
	RGB 0, 0, 0

KabutopsBillboardBGPalette1: ; 0x7bfc0
	RGB 31, 31, 31
	RGB 31, 22, 13
	RGB 19, 12, 0
	RGB 0, 0, 0
KabutopsBillboardBGPalette2: ; 0x7bfc8
	RGB 31, 31, 31
	RGB 16, 25, 12
	RGB 19, 12, 0
	RGB 0, 0, 0

AerodactylBillboardBGPalette1: ; 0x7bfd0
	RGB 31, 31, 31
	RGB 20, 18, 31
	RGB 8, 6, 15
	RGB 0, 0, 0
AerodactylBillboardBGPalette2: ; 0x7bfd8
	RGB 31, 31, 31
	RGB 20, 18, 31
	RGB 17, 3, 25
	RGB 0, 0, 0

SnorlaxBillboardBGPalette1: ; 0x7bfe0
	RGB 31, 31, 31
	RGB 31, 27, 9
	RGB 5, 6, 14
	RGB 0, 0, 0
SnorlaxBillboardBGPalette2: ; 0x7bfe8
	RGB 31, 31, 31
	RGB 31, 27, 9
	RGB 28, 6, 2
	RGB 0, 0, 0

ArticunoBillboardBGPalette1: ; 0x7bff0
	RGB 31, 31, 31
	RGB 13, 27, 29
	RGB 5, 13, 24
	RGB 0, 0, 0
ArticunoBillboardBGPalette2: ; 0x7bff8
	RGB 31, 31, 31
	RGB 13, 27, 29
	RGB 5, 13, 24
	RGB 0, 0, 0

SECTION "bank1f", ROMX, BANK[$1f]

SlowpokeAnimatedPic: ; 0x7c000
	INCBIN "gfx/billboard/mon_animated/slowpoke.w32.interleave.2bpp"
MagnemiteAnimatedPic: ; 0x7c300
	INCBIN "gfx/billboard/mon_animated/magnemite.w32.interleave.2bpp"
FarfetchdAnimatedPic: ; 0x7c600
	INCBIN "gfx/billboard/mon_animated/farfetch_d.w32.interleave.2bpp"
DoduoAnimatedPic: ; 0x7c900
	INCBIN "gfx/billboard/mon_animated/doduo.w32.interleave.2bpp"
SeelAnimatedPic: ; 0x7cc00
	INCBIN "gfx/billboard/mon_animated/seel.w32.interleave.2bpp"
GrimerAnimatedPic: ; 0x7cf00
	INCBIN "gfx/billboard/mon_animated/grimer.w32.interleave.2bpp"
ShellderAnimatedPic: ; 0x7d200
	INCBIN "gfx/billboard/mon_animated/shellder.w32.interleave.2bpp"
GastlyAnimatedPic: ; 0x7d500
	INCBIN "gfx/billboard/mon_animated/gastly.w32.interleave.2bpp"
OnixAnimatedPic: ; 0x7d800
	INCBIN "gfx/billboard/mon_animated/onix.w32.interleave.2bpp"
DrowzeeAnimatedPic: ; 0x7db00
	INCBIN "gfx/billboard/mon_animated/drowzee.w32.interleave.2bpp"
KrabbyAnimatedPic: ; 0x7de00
	INCBIN "gfx/billboard/mon_animated/krabby.w32.interleave.2bpp"
VoltorbAnimatedPic: ; 0x7e100
	INCBIN "gfx/billboard/mon_animated/voltorb.w32.interleave.2bpp"
ExeggcuteAnimatedPic: ; 0x7e400
	INCBIN "gfx/billboard/mon_animated/exeggcute.w32.interleave.2bpp"
CuboneAnimatedPic: ; 0x7e700
	INCBIN "gfx/billboard/mon_animated/cubone.w32.interleave.2bpp"
HitmonleeAnimatedPic: ; 0x7ea00
	INCBIN "gfx/billboard/mon_animated/hitmonlee.w32.interleave.2bpp"
HitmonchanAnimatedPic: ; 0x7ed00
	INCBIN "gfx/billboard/mon_animated/hitmonchan.w32.interleave.2bpp"

MewtwoBonusBaseGameBoyGfx: ; 0x7f000
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_bonus_base_gameboy.2bpp"

EraseAllDataGfx: ; 0x7fd00: ; 0x7fd00
	INCBIN "gfx/erase_all_data.2bpp"

SECTION "bank20", ROMX, BANK[$20]

LickitungAnimatedPic: ; 0x80000
	INCBIN "gfx/billboard/mon_animated/lickitung.w32.interleave.2bpp"
KoffingAnimatedPic: ; 0x80300
	INCBIN "gfx/billboard/mon_animated/koffing.w32.interleave.2bpp"
RhyhornAnimatedPic: ; 0x80600
	INCBIN "gfx/billboard/mon_animated/rhyhorn.w32.interleave.2bpp"
ChanseyAnimatedPic: ; 0x80900
	INCBIN "gfx/billboard/mon_animated/chansey.w32.interleave.2bpp"
TangelaAnimatedPic: ; 0x80c00
	INCBIN "gfx/billboard/mon_animated/tangela.w32.interleave.2bpp"
KangaskhanAnimatedPic: ; 0x80f00
	INCBIN "gfx/billboard/mon_animated/kangaskhan.w32.interleave.2bpp"
HorseaAnimatedPic: ; 0x81200
	INCBIN "gfx/billboard/mon_animated/horsea.w32.interleave.2bpp"
GoldeenAnimatedPic: ; 0x81500
	INCBIN "gfx/billboard/mon_animated/goldeen.w32.interleave.2bpp"
StaryuAnimatedPic: ; 0x81800
	INCBIN "gfx/billboard/mon_animated/staryu.w32.interleave.2bpp"
MrMimeAnimatedPic: ; 0x81b00
	INCBIN "gfx/billboard/mon_animated/mr_mime.w32.interleave.2bpp"
ScytherAnimatedPic: ; 0x81e00
	INCBIN "gfx/billboard/mon_animated/scyther.w32.interleave.2bpp"
JynxAnimatedPic: ; 0x82100
	INCBIN "gfx/billboard/mon_animated/jynx.w32.interleave.2bpp"
ElectabuzzAnimatedPic: ; 0x82400
	INCBIN "gfx/billboard/mon_animated/electabuzz.w32.interleave.2bpp"
MagmarAnimatedPic: ; 0x82700
	INCBIN "gfx/billboard/mon_animated/magmar.w32.interleave.2bpp"
PinsirAnimatedPic: ; 0x82a00
	INCBIN "gfx/billboard/mon_animated/pinsir.w32.interleave.2bpp"
TaurosAnimatedPic: ; 0x82d00
	INCBIN "gfx/billboard/mon_animated/tauros.w32.interleave.2bpp"

MewtwoBonusBaseGameBoyColorGfx: ; 0x83000
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_bonus_base_gameboycolor.2bpp"

StageDiglettBonusCollisionMasks: ; 0x83d00
	INCBIN "data/collision/masks/diglett_bonus.masks"

SECTION "bank21", ROMX, BANK[$21]

MagikarpAnimatedPic: ; 0x84000
	INCBIN "gfx/billboard/mon_animated/magikarp.w32.interleave.2bpp"
LaprasAnimatedPic: ; 0x84300
	INCBIN "gfx/billboard/mon_animated/lapras.w32.interleave.2bpp"
DittoAnimatedPic: ; 0x84600
	INCBIN "gfx/billboard/mon_animated/ditto.w32.interleave.2bpp"
EeveeAnimatedPic: ; 0x84900
	INCBIN "gfx/billboard/mon_animated/eevee.w32.interleave.2bpp"
PorygonAnimatedPic: ; 0x84c00
	INCBIN "gfx/billboard/mon_animated/porygon.w32.interleave.2bpp"
OmanyteAnimatedPic: ; 0x84f00
	INCBIN "gfx/billboard/mon_animated/omanyte.w32.interleave.2bpp"
KabutoAnimatedPic: ; 0x85200
	INCBIN "gfx/billboard/mon_animated/kabuto.w32.interleave.2bpp"
AerodactylAnimatedPic: ; 0x85500
	INCBIN "gfx/billboard/mon_animated/aerodactyl.w32.interleave.2bpp"
SnorlaxAnimatedPic: ; 0x85800
	INCBIN "gfx/billboard/mon_animated/snorlax.w32.interleave.2bpp"
ArticunoAnimatedPic: ; 0x85b00
	INCBIN "gfx/billboard/mon_animated/articuno.w32.interleave.2bpp"
ZapdosAnimatedPic: ; 0x85e00
	INCBIN "gfx/billboard/mon_animated/zapdos.w32.interleave.2bpp"
MoltresAnimatedPic: ; 0x86100
	INCBIN "gfx/billboard/mon_animated/moltres.w32.interleave.2bpp"
DratiniAnimatedPic: ; 0x86400
	INCBIN "gfx/billboard/mon_animated/dratini.w32.interleave.2bpp"
MewtwoAnimatedPic: ; 0x86700
	INCBIN "gfx/billboard/mon_animated/mewtwo.w32.interleave.2bpp"
MewAnimatedPic: ; 0x86a00
	INCBIN "gfx/billboard/mon_animated/mew.w32.interleave.2bpp"
	dr $86d00, $87000

DiglettBonusBaseGameBoyColorGfx: ; 0x87000
	INCBIN "gfx/stage/diglett_bonus/diglett_bonus_base_gameboycolor.2bpp"
	dr $87e00, $87e80

GengarBonusHaunter1Gfx: ; 0x87e80
	INCBIN "gfx/stage/gengar_bonus/haunter_1.2bpp"
GengarBonusHaunter2Gfx: ; 0x87ea0
	INCBIN "gfx/stage/gengar_bonus/haunter_2.w32.interleave.2bpp"

SECTION "bank22", ROMX, BANK[$22]

ZubatAnimatedPic: ; 0x88000
	INCBIN "gfx/billboard/mon_animated/zubat.w32.interleave.2bpp"
OddishAnimatedPic: ; 0x88300
	INCBIN "gfx/billboard/mon_animated/oddish.w32.interleave.2bpp"
ParasAnimatedPic: ; 0x88600
	INCBIN "gfx/billboard/mon_animated/paras.w32.interleave.2bpp"
VenonatAnimatedPic: ; 0x88900
	INCBIN "gfx/billboard/mon_animated/venonat.w32.interleave.2bpp"
DiglettAnimatedPic: ; 0x88c00
	INCBIN "gfx/billboard/mon_animated/diglett.w32.interleave.2bpp"
MeowthAnimatedPic: ; 0x88f00
	INCBIN "gfx/billboard/mon_animated/meowth.w32.interleave.2bpp"
PsyduckAnimatedPic: ; 0x89200
	INCBIN "gfx/billboard/mon_animated/psyduck.w32.interleave.2bpp"
MankeyAnimatedPic: ; 0x89500
	INCBIN "gfx/billboard/mon_animated/mankey.w32.interleave.2bpp"
GrowlitheAnimatedPic: ; 0x89800
	INCBIN "gfx/billboard/mon_animated/growlithe.w32.interleave.2bpp"
PoliwagAnimatedPic: ; 0x89b00
	INCBIN "gfx/billboard/mon_animated/poliwag.w32.interleave.2bpp"
AbraAnimatedPic: ; 0x89e00
	INCBIN "gfx/billboard/mon_animated/abra.w32.interleave.2bpp"
MachopAnimatedPic: ; 0x8a100
	INCBIN "gfx/billboard/mon_animated/machop.w32.interleave.2bpp"
BellsproutAnimatedPic: ; 0x8a400
	INCBIN "gfx/billboard/mon_animated/bellsprout.w32.interleave.2bpp"
TentacoolAnimatedPic: ; 0x8a700
	INCBIN "gfx/billboard/mon_animated/tentacool.w32.interleave.2bpp"
GeodudeAnimatedPic: ; 0x8aa00
	INCBIN "gfx/billboard/mon_animated/geodude.w32.interleave.2bpp"
PonytaAnimatedPic: ; 0x8ad00
	INCBIN "gfx/billboard/mon_animated/ponyta.w32.interleave.2bpp"

FieldSelectScreenGfx:
FieldSelectBlinkingBorderGfx: ; 0x8b000
	INCBIN "gfx/field_select/blinking_border.2bpp"
FieldSelectGfx: ; 0x8b100
	INCBIN "gfx/field_select/field_select_tiles.2bpp"

GengarBonusGastlyGfx: ; 0x8bd00
	INCBIN "gfx/stage/gengar_bonus/gastly.w32.interleave.2bpp"
	dr $8be80, $8bf00

BulbasaurBillboardBGPalette1: ; 0x8bf00
	RGB 31, 31, 31
	RGB 0, 19, 13
	RGB 26, 1, 0
	RGB 0, 0, 0
BulbasaurBillboardBGPalette2: ; 0x8bf08
	RGB 31, 31, 31
	RGB 0, 19, 13
	RGB 0, 9, 0
	RGB 0, 0, 0

IvysaurBillboardBGPalette1: ; 0x8bf10
	RGB 31, 31, 31
	RGB 0, 19, 13
	RGB 0, 12, 6
	RGB 0, 0, 0
IvysaurBillboardBGPalette2: ; 0x8bf18
	RGB 31, 31, 31
	RGB 25, 17, 3
	RGB 0, 12, 6
	RGB 0, 0, 0

VenusaurBillboardBGPalette1: ; 0x8bf20
	RGB 31, 31, 31
	RGB 0, 19, 13
	RGB 26, 1, 0
	RGB 0, 0, 0
VenusaurBillboardBGPalette2: ; 0x8bf28
	RGB 31, 31, 31
	RGB 0, 19, 13
	RGB 5, 15, 0
	RGB 0, 0, 0

CharmanderBillboardBGPalette1: ; 0x8bf30
	RGB 31, 31, 31
	RGB 31, 17, 1
	RGB 26, 0, 0
	RGB 3, 2, 0
CharmanderBillboardBGPalette2: ; 0x8bf38
	RGB 31, 31, 31
	RGB 31, 17, 1
	RGB 26, 0, 0
	RGB 3, 2, 0

CharmeleonBillboardBGPalette1: ; 0x8bf40
	RGB 31, 31, 31
	RGB 31, 17, 1
	RGB 26, 4, 0
	RGB 3, 2, 0
CharmeleonBillboardBGPalette2: ; 0x8bf48
	RGB 31, 31, 31
	RGB 31, 17, 1
	RGB 26, 4, 0
	RGB 3, 2, 0

CharizardBillboardBGPalette1: ; 0x8bf50
	RGB 31, 31, 31
	RGB 31, 17, 1
	RGB 26, 4, 0
	RGB 3, 2, 0
CharizardBillboardBGPalette2: ; 0x8bf58
	RGB 31, 31, 31
	RGB 31, 17, 1
	RGB 26, 4, 0
	RGB 3, 2, 0

SquirtleBillboardBGPalette1: ; 0x8bf60
	RGB 31, 31, 31
	RGB 26, 23, 0
	RGB 0, 16, 31
	RGB 0, 0, 0
SquirtleBillboardBGPalette2: ; 0x8bf68
	RGB 31, 31, 31
	RGB 14, 27, 31
	RGB 0, 16, 31
	RGB 0, 1, 3

WartortleBillboardBGPalette1: ; 0x8bf70
	RGB 31, 31, 31
	RGB 29, 23, 0
	RGB 0, 16, 31
	RGB 0, 0, 0
WartortleBillboardBGPalette2: ; 0x8bf78
	RGB 31, 31, 31
	RGB 14, 27, 31
	RGB 0, 16, 31
	RGB 0, 1, 3

BlastoiseBillboardBGPalette1: ; 0x8bf80
	RGB 31, 31, 31
	RGB 27, 20, 10
	RGB 12, 6, 3
	RGB 0, 0, 0
BlastoiseBillboardBGPalette2: ; 0x8bf88
	RGB 31, 31, 31
	RGB 11, 18, 31
	RGB 2, 6, 19
	RGB 0, 0, 0

CaterpieBillboardBGPalette1: ; 0x8bf90
	RGB 31, 31, 31
	RGB 23, 27, 5
	RGB 3, 17, 0
	RGB 0, 0, 0
CaterpieBillboardBGPalette2: ; 0x8bf98
	RGB 31, 31, 31
	RGB 23, 27, 5
	RGB 3, 17, 0
	RGB 0, 0, 0

MetapodBillboardBGPalette1: ; 0x8bfa0
	RGB 31, 31, 31
	RGB 23, 27, 5
	RGB 7, 18, 0
	RGB 0, 0, 0
MetapodBillboardBGPalette2: ; 0x8bfa8
	RGB 31, 31, 31
	RGB 23, 27, 5
	RGB 7, 18, 0
	RGB 0, 0, 0

ButterfreeBillboardBGPalette1: ; 0x8bfb0
	RGB 31, 31, 31
	RGB 31, 15, 0
	RGB 31, 0, 1
	RGB 3, 2, 0
ButterfreeBillboardBGPalette2: ; 0x8bfb8
	RGB 31, 31, 31
	RGB 11, 13, 31
	RGB 9, 8, 18
	RGB 0, 0, 0

WeedleBillboardBGPalette1: ; 0x8bfc0
	RGB 31, 31, 31
	RGB 29, 25, 0
	RGB 25, 6, 7
	RGB 3, 2, 0
WeedleBillboardBGPalette2: ; 0x8bfc8
	RGB 31, 31, 31
	RGB 29, 25, 0
	RGB 25, 6, 7
	RGB 3, 2, 0

KakunaBillboardBGPalette1: ; 0x8bfd0
	RGB 31, 31, 31
	RGB 28, 24, 0
	RGB 18, 12, 0
	RGB 3, 2, 0
KakunaBillboardBGPalette2: ; 0x8bfd8
	RGB 31, 31, 31
	RGB 28, 24, 0
	RGB 18, 12, 0
	RGB 3, 2, 0

BeedrillBillboardBGPalette1: ; 0x8bfe0
	RGB 31, 31, 31
	RGB 30, 27, 0
	RGB 21, 7, 0
	RGB 3, 2, 0
BeedrillBillboardBGPalette2: ; 0x8bfe8
	RGB 31, 31, 31
	RGB 30, 27, 0
	RGB 21, 7, 0
	RGB 3, 2, 0

PidgeyBillboardBGPalette1: ; 0x8bff0
	RGB 31, 31, 31
	RGB 30, 25, 1
	RGB 26, 9, 3
	RGB 3, 2, 0
PidgeyBillboardBGPalette2: ; 0x8bff8
	RGB 31, 31, 31
	RGB 30, 25, 1
	RGB 26, 9, 3
	RGB 3, 2, 0

SECTION "bank23", ROMX, BANK[$23]

BulbasaurAnimatedPic: ; 0x8c000
	INCBIN "gfx/billboard/mon_animated/bulbasaur.w32.interleave.2bpp"
CharmanderAnimatedPic: ; 0x8c300
	INCBIN "gfx/billboard/mon_animated/charmander.w32.interleave.2bpp"
SquirtleAnimatedPic: ; 0x8c600
	INCBIN "gfx/billboard/mon_animated/squirtle.w32.interleave.2bpp"
CaterpieAnimatedPic: ; 0x8c900
	INCBIN "gfx/billboard/mon_animated/caterpie.w32.interleave.2bpp"
WeedleAnimatedPic: ; 0x8cc00
	INCBIN "gfx/billboard/mon_animated/weedle.w32.interleave.2bpp"
PidgeyAnimatedPic: ; 0x8cf00
	INCBIN "gfx/billboard/mon_animated/pidgey.w32.interleave.2bpp"
RattataAnimatedPic: ; 0x8d200
	INCBIN "gfx/billboard/mon_animated/rattata.w32.interleave.2bpp"
SpearowAnimatedPic: ; 0x8d500
	INCBIN "gfx/billboard/mon_animated/spearow.w32.interleave.2bpp"
EkansAnimatedPic: ; 0x8d800
	INCBIN "gfx/billboard/mon_animated/ekans.w32.interleave.2bpp"
PikachuAnimatedPic: ; 0x8db00
	INCBIN "gfx/billboard/mon_animated/pikachu.w32.interleave.2bpp"
SandshrewAnimatedPic: ; 0x8de00
	INCBIN "gfx/billboard/mon_animated/sandshrew.w32.interleave.2bpp"
NidoranFAnimatedPic: ; 0x8e100
	INCBIN "gfx/billboard/mon_animated/nidoran_f.w32.interleave.2bpp"
NidoranMAnimatedPic: ; 0x8e400
	INCBIN "gfx/billboard/mon_animated/nidoran_m.w32.interleave.2bpp"
ClefairyAnimatedPic: ; 0x8e700
	INCBIN "gfx/billboard/mon_animated/clefairy.w32.interleave.2bpp"
VulpixAnimatedPic: ; 0x8ea00
	INCBIN "gfx/billboard/mon_animated/vulpix.w32.interleave.2bpp"
JigglypuffAnimatedPic: ; 0x8ed00
	INCBIN "gfx/billboard/mon_animated/jigglypuff.w32.interleave.2bpp"

DiglettBonusBaseGameBoyGfx: ; 0x8f000
	INCBIN "gfx/stage/diglett_bonus/diglett_bonus_base_gameboy.2bpp"
	dr $8fd00, $8ff00

PalletTownBillboardBGPalette1: ; 0x8ff00
	RGB 31, 31, 31
	RGB 22, 18, 17
	RGB 0, 19, 0
	RGB 0, 0, 0
PalletTownBillboardBGPalette2: ; 0x8ff08
	RGB 31, 31, 31
	RGB 24, 9, 3
	RGB 0, 4, 25
	RGB 0, 0, 0

ViridianCityBillboardBGPalette1: ; 0x8ff10
	RGB 31, 31, 31
	RGB 0, 14, 31
	RGB 0, 22, 0
	RGB 0, 0, 0
ViridianCityBillboardBGPalette2: ; 0x8ff18
	RGB 31, 31, 31
	RGB 26, 15, 3
	RGB 0, 22, 0
	RGB 0, 0, 0

ViridianForestBillboardBGPalette1: ; 0x8ff20
	RGB 31, 31, 31
	RGB 31, 20, 3
	RGB 2, 16, 1
	RGB 0, 0, 0
ViridianForestBillboardBGPalette2: ; 0x8ff28
	RGB 31, 31, 31
	RGB 31, 20, 3
	RGB 24, 6, 0
	RGB 0, 0, 0

PewterCityBillboardBGPalette1: ; 0x8ff30
	RGB 31, 31, 31
	RGB 27, 20, 10
	RGB 2, 16, 1
	RGB 0, 0, 0
PewterCityBillboardBGPalette2: ; 0x8ff38
	RGB 31, 31, 31
	RGB 5, 17, 31
	RGB 26, 3, 1
	RGB 0, 0, 0

MtMoonBillboardBGPalette1: ; 0x8ff40
	RGB 31, 28, 2
	RGB 19, 20, 27
	RGB 2, 7, 20
	RGB 0, 0, 0
MtMoonBillboardBGPalette2: ; 0x8ff48
	RGB 31, 28, 2
	RGB 19, 20, 27
	RGB 2, 7, 20
	RGB 0, 0, 0

CeruleanCityBillboardBGPalette1: ; 0x8ff50
	RGB 31, 22, 5
	RGB 16, 22, 4
	RGB 1, 15, 0
	RGB 0, 0, 0
CeruleanCityBillboardBGPalette2: ; 0x8ff58
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 3, 11, 31
	RGB 0, 0, 0

VermilionSeasideBillboardBGPalette1: ; 0x8ff60
	RGB 31, 31, 31
	RGB 8, 20, 31
	RGB 2, 8, 23
	RGB 0, 0, 0
VermilionSeasideBillboardBGPalette2: ; 0x8ff68
	RGB 31, 31, 31
	RGB 22, 22, 22
	RGB 21, 8, 0
	RGB 0, 0, 0

VermilionStreetsBillboardBGPalette1: ; 0x8ff70
	RGB 31, 31, 31
	RGB 20, 22, 25
	RGB 31, 8, 0
	RGB 0, 0, 0
VermilionStreetsBillboardBGPalette2: ; 0x8ff78
	RGB 31, 31, 31
	RGB 20, 22, 25
	RGB 7, 8, 13
	RGB 0, 0, 0

RockMountainBillboardBGPalette1: ; 0x8ff80
	RGB 31, 31, 31
	RGB 27, 13, 4
	RGB 21, 5, 0
	RGB 0, 0, 0
RockMountainBillboardBGPalette2: ; 0x8ff88
	RGB 3, 18, 31
	RGB 27, 13, 4
	RGB 2, 16, 1
	RGB 0, 0, 0

LavenderTownBillboardBGPalette1: ; 0x8ff90
	RGB 31, 31, 10
	RGB 11, 18, 31
	RGB 2, 6, 19
	RGB 0, 0, 0
LavenderTownBillboardBGPalette2: ; 0x8ff98
	RGB 31, 31, 31
	RGB 11, 18, 31
	RGB 2, 6, 19
	RGB 0, 0, 0

CeladonCityBillboardBGPalette1: ; 0x8ffa0
	RGB 31, 31, 31
	RGB 11, 19, 31
	RGB 29, 8, 4
	RGB 0, 0, 0
CeladonCityBillboardBGPalette2: ; 0x8ffa8
	RGB 31, 31, 31
	RGB 31, 9, 9
	RGB 16, 2, 2
	RGB 0, 0, 0

CyclingRoadBillboardBGPalette1: ; 0x8ffb0
	RGB 31, 24, 15
	RGB 11, 21, 5
	RGB 31, 9, 5
	RGB 0, 0, 0
CyclingRoadBillboardBGPalette2: ; 0x8ffb8
	RGB 31, 22, 13
	RGB 11, 21, 5
	RGB 0, 15, 0
	RGB 0, 0, 0

FuchsiaCityBillboardBGPalette1: ; 0x8ffc0
	RGB 31, 31, 31
	RGB 10, 25, 31
	RGB 26, 3, 1
	RGB 0, 0, 0
FuchsiaCityBillboardBGPalette2: ; 0x8ffc8
	RGB 31, 31, 31
	RGB 27, 23, 6
	RGB 28, 6, 3
	RGB 0, 0, 0

SafariZoneBillboardBGPalette1: ; 0x8ffd0
	RGB 31, 31, 31
	RGB 13, 27, 31
	RGB 4, 19, 27
	RGB 0, 0, 0
SafariZoneBillboardBGPalette2: ; 0x8ffd8
	RGB 29, 21, 17
	RGB 13, 19, 5
	RGB 0, 14, 0
	RGB 0, 0, 0

SaffronCityBillboardBGPalette1: ; 0x8ffe0
	RGB 31, 31, 31
	RGB 8, 19, 31
	RGB 2, 7, 26
	RGB 0, 0, 0
SaffronCityBillboardBGPalette2: ; 0x8ffe8
	RGB 31, 31, 31
	RGB 27, 28, 1
	RGB 24, 7, 5
	RGB 0, 0, 0

SeafoamIslandsBillboardBGPalette1: ; 0x8fff0
	RGB 24, 27, 30
	RGB 31, 24, 1
	RGB 2, 15, 1
	RGB 0, 0, 0
SeafoamIslandsBillboardBGPalette2: ; 0x8fff8
	RGB 24, 27, 30
	RGB 0, 14, 31
	RGB 0, 9, 23
	RGB 0, 0, 0

SECTION "bank24", ROMX, BANK[$24]

HypnoPic: ; 0x90000
	INCBIN "gfx/billboard/mon_pics/hypno.2bpp"
HypnoSilhouettePic: ; 0x90180
	INCBIN "gfx/billboard/mon_silhouettes/hypno.2bpp"
KrabbyPic: ; 0x90300
	INCBIN "gfx/billboard/mon_pics/krabby.2bpp"
KrabbySilhouettePic: ; 0x90480
	INCBIN "gfx/billboard/mon_silhouettes/krabby.2bpp"
KinglerPic: ; 0x90600
	INCBIN "gfx/billboard/mon_pics/kingler.2bpp"
KinglerSilhouettePic: ; 0x90780
	INCBIN "gfx/billboard/mon_silhouettes/kingler.2bpp"
VoltorbPic: ; 0x90900
	INCBIN "gfx/billboard/mon_pics/voltorb.2bpp"
VoltorbSilhouettePic: ; 0x90a80
	INCBIN "gfx/billboard/mon_silhouettes/voltorb.2bpp"
ElectrodePic: ; 0x90c00
	INCBIN "gfx/billboard/mon_pics/electrode.2bpp"
ElectrodeSilhouettePic: ; 0x90d80
	INCBIN "gfx/billboard/mon_silhouettes/electrode.2bpp"
ExeggcutePic: ; 0x90f00
	INCBIN "gfx/billboard/mon_pics/exeggcute.2bpp"
ExeggcuteSilhouettePic: ; 0x91080
	INCBIN "gfx/billboard/mon_silhouettes/exeggcute.2bpp"
ExeggutorPic: ; 0x91200
	INCBIN "gfx/billboard/mon_pics/exeggutor.2bpp"
ExeggutorSilhouettePic:  ; 0x91380
	INCBIN "gfx/billboard/mon_silhouettes/exeggutor.2bpp"
CubonePic: ; 0x91500
	INCBIN "gfx/billboard/mon_pics/cubone.2bpp"
CuboneSilhouettePic: ; 0x91680
	INCBIN "gfx/billboard/mon_silhouettes/cubone.2bpp"
MarowakPic: ; 0x91800
	INCBIN "gfx/billboard/mon_pics/marowak.2bpp"
MarowakSilhouettePic: ; 0x91980
	INCBIN "gfx/billboard/mon_silhouettes/marowak.2bpp"
HitmonleePic: ; 0x91b00
	INCBIN "gfx/billboard/mon_pics/hitmonlee.2bpp"
HitmonleeSilhouettePic: ; 0x91c80
	INCBIN "gfx/billboard/mon_silhouettes/hitmonlee.2bpp"
HitmonchanPic: ; 0x91e00
	INCBIN "gfx/billboard/mon_pics/hitmonchan.2bpp"
HitmonchanSilhouettePic: ; 0x91f80
	INCBIN "gfx/billboard/mon_silhouettes/hitmonchan.2bpp"
LickitungPic: ; 0x92100
	INCBIN "gfx/billboard/mon_pics/lickitung.2bpp"
LickitungSilhouettePic: ; 0x92280
	INCBIN "gfx/billboard/mon_silhouettes/lickitung.2bpp"
KoffingPic: ; 0x92400
	INCBIN "gfx/billboard/mon_pics/koffing.2bpp"
KoffingSilhouettePic: ; 0x92580
	INCBIN "gfx/billboard/mon_silhouettes/koffing.2bpp"
WeezingPic: ; 0x92700
	INCBIN "gfx/billboard/mon_pics/weezing.2bpp"
WeezingSilhouettePic: ; 0x92880
	INCBIN "gfx/billboard/mon_silhouettes/weezing.2bpp"
RhyhornPic: ; 0x92a00
	INCBIN "gfx/billboard/mon_pics/rhyhorn.2bpp"
RhyhornSilhouettePic: ; 0x92b80
	INCBIN "gfx/billboard/mon_silhouettes/rhyhorn.2bpp"
RhydonPic: ; 0x92d00
	INCBIN "gfx/billboard/mon_pics/rhydon.2bpp"
RhydonSilhouettePic: ; 0x92e80
	INCBIN "gfx/billboard/mon_silhouettes/rhydon.2bpp"

SeelBonusBaseGameBoyGfx: ; 0x93000
	INCBIN "gfx/stage/seel_bonus/seel_bonus_base_gameboy.2bpp"

CinnabarIslandBillboardBGPaletteMap: ; 0x93c00
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $7, $7, $7, $6
	db $6, $6, $6, $6, $6, $6

IndigoPlateauBillboardBGPaletteMap: ; 0x93c18
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $7, $7, $7
	dr $93c39, $94000

SECTION "bank25", ROMX, BANK[$25]

MagnemitePic: ; 0x94000
	INCBIN "gfx/billboard/mon_pics/magnemite.2bpp"
MagnemiteSilhouettePic: ; 0x94180
	INCBIN "gfx/billboard/mon_silhouettes/magnemite.2bpp"
MagnetonPic: ; 0x94300
	INCBIN "gfx/billboard/mon_pics/magneton.2bpp"
MagnetonSilhouettePic: ; 0x94480
	INCBIN "gfx/billboard/mon_silhouettes/magneton.2bpp"
Farfetch_dPic: ; 0x94600
	INCBIN "gfx/billboard/mon_pics/farfetch_d.2bpp"
Farfetch_dSilhouettePic: ; 0x94780
	INCBIN "gfx/billboard/mon_silhouettes/farfetch_d.2bpp"
DoduoPic: ; 0x94900
	INCBIN "gfx/billboard/mon_pics/doduo.2bpp"
DoduoSilhouettePic: ; 0x94a80
	INCBIN "gfx/billboard/mon_silhouettes/doduo.2bpp"
DodrioPic: ; 0x94c00
	INCBIN "gfx/billboard/mon_pics/dodrio.2bpp"
DodrioSilhouettePic: ; 0x94d80
	INCBIN "gfx/billboard/mon_silhouettes/dodrio.2bpp"
SeelPic: ; 0x94f00
	INCBIN "gfx/billboard/mon_pics/seel.2bpp"
SeelSilhouettePic: ; 0x95080
	INCBIN "gfx/billboard/mon_silhouettes/seel.2bpp"
DewgongPic: ; 0x95200
	INCBIN "gfx/billboard/mon_pics/dewgong.2bpp"
DewgongSilhouettePic:  ; 0x95380
	INCBIN "gfx/billboard/mon_silhouettes/dewgong.2bpp"
GrimerPic: ; 0x95500
	INCBIN "gfx/billboard/mon_pics/grimer.2bpp"
GrimerSilhouettePic: ; 0x95680
	INCBIN "gfx/billboard/mon_silhouettes/grimer.2bpp"
MukPic: ; 0x95800
	INCBIN "gfx/billboard/mon_pics/muk.2bpp"
MukSilhouettePic: ; 0x95980
	INCBIN "gfx/billboard/mon_silhouettes/muk.2bpp"
ShellderPic: ; 0x95b00
	INCBIN "gfx/billboard/mon_pics/shellder.2bpp"
ShellderSilhouettePic: ; 0x95c80
	INCBIN "gfx/billboard/mon_silhouettes/shellder.2bpp"
CloysterPic: ; 0x95e00
	INCBIN "gfx/billboard/mon_pics/cloyster.2bpp"
CloysterSilhouettePic: ; 0x95f80
	INCBIN "gfx/billboard/mon_silhouettes/cloyster.2bpp"
GastlyPic: ; 0x96100
	INCBIN "gfx/billboard/mon_pics/gastly.2bpp"
GastlySilhouettePic: ; 0x96280
	INCBIN "gfx/billboard/mon_silhouettes/gastly.2bpp"
HaunterPic: ; 0x96400
	INCBIN "gfx/billboard/mon_pics/haunter.2bpp"
HaunterSilhouettePic: ; 0x96580
	INCBIN "gfx/billboard/mon_silhouettes/haunter.2bpp"
GengarPic: ; 0x96700
	INCBIN "gfx/billboard/mon_pics/gengar.2bpp"
GengarSilhouettePic: ; 0x96880
	INCBIN "gfx/billboard/mon_silhouettes/gengar.2bpp"
OnixPic: ; 0x96a00
	INCBIN "gfx/billboard/mon_pics/onix.2bpp"
OnixSilhouettePic: ; 0x96b80
	INCBIN "gfx/billboard/mon_silhouettes/onix.2bpp"
DrowzeePic: ; 0x96d00
	INCBIN "gfx/billboard/mon_pics/drowzee.2bpp"
DrowzeeSilhouettePic: ; 0x96e80
	INCBIN "gfx/billboard/mon_silhouettes/drowzee.2bpp"

SeelBonusBaseGameBoyColorGfx: ; 0x97000
	INCBIN "gfx/stage/seel_bonus/seel_bonus_base_gameboycolor.2bpp"

StageRedFieldTopGfx3: ; 0x97a00
	INCBIN "gfx/stage/red_top/red_top_3.2bpp"
StageRedFieldTopGfx1: ; 0x97ba0
	INCBIN "gfx/stage/red_top/red_top_1.2bpp"
StageRedFieldTopGfx2: ; 0x97e00
	INCBIN "gfx/stage/red_top/red_top_2.2bpp"

SECTION "bank26", ROMX, BANK[$26]

AlakazamPic: ; 0x98000
	INCBIN "gfx/billboard/mon_pics/alakazam.2bpp"
AlakazamSilhouettePic: ; 0x98180
	INCBIN "gfx/billboard/mon_silhouettes/alakazam.2bpp"
MachopPic: ; 0x98300
	INCBIN "gfx/billboard/mon_pics/machop.2bpp"
MachopSilhouettePic: ; 0x98480
	INCBIN "gfx/billboard/mon_silhouettes/machop.2bpp"
MachokePic: ; 0x98600
	INCBIN "gfx/billboard/mon_pics/machoke.2bpp"
MachokeSilhouettePic: ; 0x98780
	INCBIN "gfx/billboard/mon_silhouettes/machoke.2bpp"
MachampPic: ; 0x98900
	INCBIN "gfx/billboard/mon_pics/machamp.2bpp"
MachampSilhouettePic: ; 0x98a80
	INCBIN "gfx/billboard/mon_silhouettes/machamp.2bpp"
BellsproutPic: ; 0x98c00
	INCBIN "gfx/billboard/mon_pics/bellsprout.2bpp"
BellsproutSilhouettePic: ; 0x98d80
	INCBIN "gfx/billboard/mon_silhouettes/bellsprout.2bpp"
WeepinbellPic: ; 0x98f00
	INCBIN "gfx/billboard/mon_pics/weepinbell.2bpp"
WeepinbellSilhouettePic: ; 0x97080
	INCBIN "gfx/billboard/mon_silhouettes/weepinbell.2bpp"
VictreebellPic: ; 0x97200
	INCBIN "gfx/billboard/mon_pics/victreebell.2bpp"
VictreebellSilhouettePic:  ; 0x97380
	INCBIN "gfx/billboard/mon_silhouettes/victreebell.2bpp"
TentacoolPic: ; 0x97500
	INCBIN "gfx/billboard/mon_pics/tentacool.2bpp"
TentacoolSilhouettePic: ; 0x97680
	INCBIN "gfx/billboard/mon_silhouettes/tentacool.2bpp"
TentacruelPic: ; 0x97800
	INCBIN "gfx/billboard/mon_pics/tentacruel.2bpp"
TentacruelSilhouettePic: ; 0x97980
	INCBIN "gfx/billboard/mon_silhouettes/tentacruel.2bpp"
GeodudePic: ; 0x97b00
	INCBIN "gfx/billboard/mon_pics/geodude.2bpp"
GeodudeSilhouettePic: ; 0x97c80
	INCBIN "gfx/billboard/mon_silhouettes/geodude.2bpp"
GravelerPic: ; 0x97e00
	INCBIN "gfx/billboard/mon_pics/graveler.2bpp"
GravelerSilhouettePic: ; 0x97f80
	INCBIN "gfx/billboard/mon_silhouettes/graveler.2bpp"
GolemPic: ; 0x9a100
	INCBIN "gfx/billboard/mon_pics/golem.2bpp"
GolemSilhouettePic: ; 0x9a280
	INCBIN "gfx/billboard/mon_silhouettes/golem.2bpp"
PonytaPic: ; 0x9a400
	INCBIN "gfx/billboard/mon_pics/ponyta.2bpp"
PonytaSilhouettePic: ; 0x9a580
	INCBIN "gfx/billboard/mon_silhouettes/ponyta.2bpp"
RapidashPic: ; 0x9a700
	INCBIN "gfx/billboard/mon_pics/rapidash.2bpp"
RapidashSilhouettePic: ; 0x9a880
	INCBIN "gfx/billboard/mon_silhouettes/rapidash.2bpp"
SlowpokePic: ; 0x9aa00
	INCBIN "gfx/billboard/mon_pics/slowpoke.2bpp"
SlowpokeSilhouettePic: ; 0x9ab80
	INCBIN "gfx/billboard/mon_silhouettes/slowpoke.2bpp"
SlowbroPic: ; 0x9ad00
	INCBIN "gfx/billboard/mon_pics/slowbro.2bpp"
SlowbroSilhouettePic: ; 0x9ae80
	INCBIN "gfx/billboard/mon_silhouettes/slowbro.2bpp"

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

PalletTownPic: ; 0xa6000
	INCBIN "gfx/billboard/maps/pallettown.2bpp"
ViridianCityPic: ; 0xa6180
	INCBIN "gfx/billboard/maps/viridiancity.2bpp"
ViridianForestPic: ; 0xa6300
	INCBIN "gfx/billboard/maps/viridianforest.2bpp"
PewterCityPic: ; 0xa6480
	INCBIN "gfx/billboard/maps/pewtercity.2bpp"
MtMoonPic: ; 0xa6600
	INCBIN "gfx/billboard/maps/mtmoon.2bpp"
CeruleanCityPic: ; 0xa6780
	INCBIN "gfx/billboard/maps/ceruleancity.2bpp"
VermilionCitySeasidePic: ; 0xa6900
	INCBIN "gfx/billboard/maps/vermilioncityseaside.2bpp"
VermilionCityStreetsPic: ; 0xa6a80
	INCBIN "gfx/billboard/maps/vermilioncitystreets.2bpp"
RockMountainPic: ; 0xa6c00
	INCBIN "gfx/billboard/maps/rockmountain.2bpp"
LavenderTownPic: ; 0xa6d80
	INCBIN "gfx/billboard/maps/lavendertown.2bpp"
CeladonCityPic: ; 0xa6f00
	INCBIN "gfx/billboard/maps/celadoncity.2bpp"
CyclingRoadPic: ; 0xa7080
	INCBIN "gfx/billboard/maps/cyclingroad.2bpp"
FuchsiaCityPic: ; 0xa7200
	INCBIN "gfx/billboard/maps/fuchsiacity.2bpp"
SafariZonePic: ; 0xa7380
	INCBIN "gfx/billboard/maps/safarizone.2bpp"
SaffronCityPic: ; 0xa7500
	INCBIN "gfx/billboard/maps/saffroncity.2bpp"
SeafoamIslandsPic: ; 0xa7680
	INCBIN "gfx/billboard/maps/seafoamislands.2bpp"
CinnabarIslandPic: ; 0xa7800
	INCBIN "gfx/billboard/maps/cinnabarisland.2bpp"
IndigoPlateauPic: ; 0xa7980
	INCBIN "gfx/billboard/maps/indigoplateau.2bpp"
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

PaletteTownBillboardBGPaletteMap: ; 0xabb00
	db $6, $7, $7, $7, $7, $7
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $7, $7

ViridianCityBillboardBGPaletteMap: ; 0xabb18
	db $6, $6, $6, $6, $7, $6
	db $6, $6, $6, $6, $7, $6
	db $7, $7, $7, $7, $7, $6
	db $7, $7, $7, $7, $7, $6

ViridianForestBillboardBGPaletteMap: ; 0xabb30
	db $6, $7, $6, $6, $7, $6
	db $7, $7, $7, $7, $7, $6
	db $6, $7, $6, $6, $7, $6
	db $6, $7, $7, $7, $7, $6

PewterCityBillboardBGPaletteMap: ; 0xabb48
	db $7, $7, $7, $7, $7, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MtMoonBillboardBGPaletteMap: ; 0xabb60
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

CeruleanCityBillboardBGPaletteMap: ; 0xabb78
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

VermilionSeasideBillboardBGPaletteMap: ; 0xabb90
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $6, $6, $6

VermilionStreetsBillboardBGPaletteMap: ; 0xabba8
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $7, $7, $7, $7
	db $6, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

RockMountainBillboardBGPaletteMap: ; 0xabbc0
	db $7, $7, $7, $7, $7, $7
	db $6, $6, $7, $7, $7, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

LavenderTownBillboardBGPaletteMap: ; 0xabbd8
	db $6, $7, $7, $6, $6, $6
	db $6, $7, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

CeladonCityBillboardBGPaletteMap: ; 0xabbf0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $7, $7
	db $6, $6, $7, $7, $7, $7

CyclingRoadBillboardBGPaletteMap: ; 0xabc08
	db $7, $7, $7, $7, $6, $6
	db $7, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $7, $7

FuchsiaCityBillboardBGPaletteMap: ; 0xabc20
	db $7, $6, $6, $6, $6, $6
	db $7, $6, $6, $6, $6, $6
	db $7, $7, $7, $6, $6, $7
	db $7, $7, $7, $7, $7, $7

SafariZoneBillboardBGPaletteMap: ; 0xabc38
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

SaffronCityBillboardBGPaletteMap: ; 0xabc50
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $6, $7, $7
	db $7, $7, $7, $7, $7, $7

SeafoamIslandsBillboardBGPaletteMap: ; 0xabc68
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $6, $7, $7, $7
	db $7, $7, $7, $6, $7, $7
	db $7, $7, $7, $7, $7, $7
	dr $abc80, $abf00

BulbasaurAnimatedObjPalette1: ; 0xabf00
	RGB 31, 31, 31
	RGB 5, 21, 30
	RGB 1, 3, 22
	RGB 0, 0, 0
BulbasaurAnimatedObjPalette2: ; 0xabf08
	RGB 31, 31, 31
	RGB 0, 21, 15
	RGB 0, 12, 6
	RGB 0, 0, 0

CharmanderAnimatedObjPalette1: ; 0xabf10
	RGB 31, 31, 31
	RGB 31, 17, 0
	RGB 26, 1, 0
	RGB 0, 0, 0
CharmanderAnimatedObjPalette2: ; 0xabf18
	RGB 31, 31, 31
	RGB 31, 17, 0
	RGB 26, 1, 0
	RGB 0, 0, 0

SquirtleAnimatedObjPalette1: ; 0xabf20
	RGB 31, 31, 31
	RGB 4, 19, 31
	RGB 1, 5, 17
	RGB 0, 0, 0
SquirtleAnimatedObjPalette2: ; 0xabf28
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 14, 9, 3
	RGB 0, 0, 0

CaterpieAnimatedObjPalette1: ; 0xabf30
	RGB 31, 31, 31
	RGB 0, 25, 9
	RGB 27, 13, 0
	RGB 0, 0, 0
CaterpieAnimatedObjPalette2: ; 0xabf38
	RGB 31, 31, 31
	RGB 0, 25, 9
	RGB 27, 13, 0
	RGB 0, 0, 0

WeedleAnimatedObjPalette1: ; 0xabf40
	RGB 31, 31, 31
	RGB 31, 25, 3
	RGB 25, 9, 7
	RGB 0, 0, 0
WeedleAnimatedObjPalette2: ; 0xabf48
	RGB 31, 31, 31
	RGB 31, 25, 3
	RGB 25, 9, 7
	RGB 0, 0, 0

PidgeyAnimatedObjPalette1: ; 0xabf50
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 21, 10, 4
	RGB 0, 0, 0
PidgeyAnimatedObjPalette2: ; 0xabf58
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 21, 10, 4
	RGB 0, 0, 0

RattataAnimatedObjPalette1: ; 0xabf60
	RGB 31, 31, 31
	RGB 30, 12, 23
	RGB 20, 4, 8
	RGB 0, 0, 0
RattataAnimatedObjPalette2: ; 0xabf68
	RGB 31, 31, 31
	RGB 30, 12, 23
	RGB 20, 4, 8
	RGB 0, 0, 0

SpearowAnimatedObjPalette1: ; 0xabf70
	RGB 31, 31, 31
	RGB 31, 22, 14
	RGB 24, 4, 2
	RGB 0, 0, 0
SpearowAnimatedObjPalette2: ; 0xabf78
	RGB 31, 31, 31
	RGB 31, 22, 14
	RGB 24, 4, 2
	RGB 0, 0, 0

EkansAnimatedObjPalette1: ; 0xabf80
	RGB 31, 31, 31
	RGB 30, 26, 12
	RGB 20, 7, 12
	RGB 0, 0, 0
EkansAnimatedObjPalette2: ; 0xabf88
	RGB 31, 31, 31
	RGB 30, 26, 12
	RGB 20, 7, 12
	RGB 0, 0, 0

PikachuAnimatedObjPalette1: ; 0xabf90
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 23, 10, 0
	RGB 3, 3, 0
PikachuAnimatedObjPalette2: ; 0xabf98
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 23, 10, 0
	RGB 3, 3, 0

SandshrewAnimatedObjPalette1: ; 0xabfa0
	RGB 31, 31, 31
	RGB 30, 25, 3
	RGB 19, 11, 0
	RGB 0, 0, 0
SandshrewAnimatedObjPalette2: ; 0xabfa8
	RGB 31, 31, 31
	RGB 30, 25, 3
	RGB 19, 11, 0
	RGB 0, 0, 0

NidoranFAnimatedObjPalette1: ; 0xabfb0
	RGB 31, 31, 31
	RGB 19, 23, 30
	RGB 8, 8, 24
	RGB 0, 0, 0
NidoranFAnimatedObjPalette2: ; 0xabfb8
	RGB 31, 31, 31
	RGB 19, 23, 30
	RGB 8, 8, 24
	RGB 0, 0, 0

NidoranMAnimatedObjPalette1: ; 0xabfc0
	RGB 31, 31, 31
	RGB 28, 16, 25
	RGB 20, 5, 12
	RGB 0, 0, 0
NidoranMAnimatedObjPalette2: ; 0xabfc8
	RGB 31, 31, 31
	RGB 28, 16, 25
	RGB 20, 5, 12
	RGB 0, 0, 0

ClefairyAnimatedObjPalette1: ; 0xabfd0
	RGB 31, 31, 31
	RGB 31, 20, 20
	RGB 23, 5, 6
	RGB 0, 0, 0
ClefairyAnimatedObjPalette2: ; 0xabfd8
	RGB 31, 31, 31
	RGB 31, 20, 20
	RGB 23, 5, 6
	RGB 0, 0, 0

VulpixAnimatedObjPalette1: ; 0xabfe0
	RGB 31, 31, 31
	RGB 30, 20, 13
	RGB 27, 8, 0
	RGB 0, 0, 0
VulpixAnimatedObjPalette2: ; 0xabfe8
	RGB 31, 31, 31
	RGB 30, 20, 13
	RGB 27, 8, 0
	RGB 0, 0, 0

JigglypuffAnimatedObjPalette1: ; 0xabff0
	RGB 31, 31, 31
	RGB 31, 18, 18
	RGB 7, 6, 27
	RGB 0, 0, 0
JigglypuffAnimatedObjPalette2: ; 0xabff8
	RGB 31, 31, 31
	RGB 31, 18, 18
	RGB 7, 6, 27
	RGB 0, 0, 0

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
		dr $b5fd0, $b6020
OptionMenuOptionTextGfx: ; 0xb6020
	INCBIN "gfx/option_menu/option_text.2bpp"
OptionMenuPikachuGfx: ; 0xb6080
	INCBIN "gfx/option_menu/pikachu.2bpp"
OptionMenuPsyduckFeetGfx: ; 0xb6170
	INCBIN "gfx/option_menu/psyduck_feet.2bpp"
OptionMenuUnknown2Gfx: ; 0xb6200
		dr $b6200, $b6250
OptionMenuRumbleTextGfx: ; 0xb6250
	INCBIN "gfx/option_menu/rumble_text.2bpp"
OptionMenuUnknown3Gfx: ; 0xb62b0
		dr $b62b0, $b6320
OptionMenuKeyCoTextGfx: ; 0xb6320
	INCBIN "gfx/option_menu/key_co_text.2bpp"
OptionMenuSoundTestDigitsGfx: ; 0xb6370
	INCBIN "gfx/option_menu/sound_test_digits.2bpp"
OptionMenuNfigTextGfx: ; 0xb6470
	INCBIN "gfx/option_menu/nfig_text.2bpp"
OptionMenuUnknown4Gfx: ; 0xb64a0
		dr $b64a0, $b6500

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

PidgeottoBillboardBGPaletteMap: ; 0xb7c00
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

PidgeotBillboardBGPaletteMap: ; 0xb7c18
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

RattataBillboardBGPaletteMap: ; 0xb7c30
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

RaticateBillboardBGPaletteMap: ; 0xb7c48
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

SpearowBillboardBGPaletteMap: ; 0xb7c60
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

FearowBillboardBGPaletteMap: ; 0xb7c78
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

EkansBillboardBGPaletteMap: ; 0xb7c90
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

ArbokBillboardBGPaletteMap: ; 0xb7ca8
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

PikachuBillboardBGPaletteMap: ; 0xb7cc0
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

RaichuBillboardBGPaletteMap: ; 0xb7cd8
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

SandshrewBillboardBGPaletteMap: ; 0xb7cf0
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

SandslashBillboardBGPaletteMap: ; 0xb7d08
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

NidoranFBillboardBGPaletteMap: ; 0xb7d20
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

NidorinaBillboardBGPaletteMap: ; 0xb7d38
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

NidoqueenBillboardBGPaletteMap: ; 0xb7d50
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

NidoranMBillboardBGPaletteMap: ; 0xb7d68
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	dr $b7d80, $b8000 ; 0xb7d80

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
	dr $c5e40, $c6000

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
	dr $c8400, $c8800

GengarBonusTilemap_GameBoy: ; 0xc8800
	INCBIN "gfx/tilemaps/stage_gengar_bonus_gameboy.map"
	dr $c8c00, $c9000

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
	dr $c9f00, $ca000

StageMewtwoBonusCollisionAttributesBallEntrance: ; 0xca000
	INCBIN "data/collision/maps/mewtwo_bonus_ball_entrance.collision"
	dr $ca400, $ca800

StageMewtwoBonusCollisionAttributes: ; 0xca800
	INCBIN "data/collision/maps/mewtwo_bonus.collision"
	dr $cac00, $cb000

MewtwoBonusTilemap_GameBoy: ; 0xcb000
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboy.map"
	dr $cb400, $cb800

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
	dr $cc7c0, $cc800

StageMeowthBonusCollisionAttributesBallEntrance: ; 0xcc800
	INCBIN "data/collision/maps/meowth_bonus_ball_entrance.collision"
	dr $ccc00, $cd000

StageMeowthBonusCollisionAttributes: ; 0xcd000
	INCBIN "data/collision/maps/meowth_bonus.collision"
	dr $cd400, $cd800

MeowthBonusTilemap_GameBoy: ; 0xcd800
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboy.map"
	dr $cdc00, $ce000

MeowthBonusTilemap_GameBoyColor: ; 0xce000
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboycolor.map"
MeowthBonusTilemap2_GameBoyColor: ; 0xce400
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboycolor_2.map"

StageDiglettBonusCollisionAttributesBallEntrance: ; 0xce800
	INCBIN "data/collision/maps/diglett_bonus_ball_entrance.collision"
	dr $cec00, $cf000

StageDiglettBonusCollisionAttributes: ; 0xcf000
	INCBIN "data/collision/maps/diglett_bonus.collision"
	dr $cf400, $cf800

DiglettBonusTilemap_GameBoy: ; 0xcf800
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboy.map"
	dr $cfc00, $d0000

SECTION "bank34", ROMX, BANK[$34]

MagikarpAnimatedCollisionMask: ; 0xd04000
	INCBIN "data/collision/mon_masks/magikarp_collision.1bpp"
LaprasAnimatedCollisionMask: ; 0xd04080
	INCBIN "data/collision/mon_masks/lapras_collision.1bpp"
DittoAnimatedCollisionMask: ; 0xd04100
	INCBIN "data/collision/mon_masks/ditto_collision.1bpp"
EeveeAnimatedCollisionMask: ; 0xd04180
	INCBIN "data/collision/mon_masks/eevee_collision.1bpp"
PorygonAnimatedCollisionMask: ; 0xd04200
	INCBIN "data/collision/mon_masks/porygon_collision.1bpp"
OmanyteAnimatedCollisionMask: ; 0xd04280
	INCBIN "data/collision/mon_masks/omanyte_collision.1bpp"
KabutoAnimatedCollisionMask: ; 0xd04300
	INCBIN "data/collision/mon_masks/kabuto_collision.1bpp"
AerodactylAnimatedCollisionMask: ; 0xd04380
	INCBIN "data/collision/mon_masks/aerodactyl_collision.1bpp"
SnorlaxAnimatedCollisionMask: ; 0xd04400
	INCBIN "data/collision/mon_masks/snorlax_collision.1bpp"
ArticunoAnimatedCollisionMask: ; 0xd04480
	INCBIN "data/collision/mon_masks/articuno_collision.1bpp"
ZapdosAnimatedCollisionMask: ; 0xd04500
	INCBIN "data/collision/mon_masks/zapdos_collision.1bpp"
MoltresAnimatedCollisionMask: ; 0xd04580
	INCBIN "data/collision/mon_masks/moltres_collision.1bpp"
DratiniAnimatedCollisionMask: ; 0xd04600
	INCBIN "data/collision/mon_masks/dratini_collision.1bpp"
MewtwoAnimatedCollisionMask: ; 0xd04680
	INCBIN "data/collision/mon_masks/mewtwo_collision.1bpp"
MewAnimatedCollisionMask: ; 0xd04700
	INCBIN "data/collision/mon_masks/mew_collision.1bpp"

	dr $d0780, $d0800

LickitungAnimatedCollisionMask: ; 0xd04800
	INCBIN "data/collision/mon_masks/lickitung_collision.1bpp"
KoffingAnimatedCollisionMask: ; 0xd04880
	INCBIN "data/collision/mon_masks/koffing_collision.1bpp"
RhyhornAnimatedCollisionMask: ; 0xd04900
	INCBIN "data/collision/mon_masks/rhyhorn_collision.1bpp"
ChanseyAnimatedCollisionMask: ; 0xd04980
	INCBIN "data/collision/mon_masks/chansey_collision.1bpp"
TangelaAnimatedCollisionMask: ; 0xd04A00
	INCBIN "data/collision/mon_masks/tangela_collision.1bpp"
KangaskhanAnimatedCollisionMask: ; 0xd04A80
	INCBIN "data/collision/mon_masks/kangaskhan_collision.1bpp"
HorseaAnimatedCollisionMask: ; 0xd04B00
	INCBIN "data/collision/mon_masks/horsea_collision.1bpp"
GoldeenAnimatedCollisionMask: ; 0xd04B80
	INCBIN "data/collision/mon_masks/goldeen_collision.1bpp"
StaryuAnimatedCollisionMask: ; 0xd04C00
	INCBIN "data/collision/mon_masks/staryu_collision.1bpp"
MrMimeAnimatedCollisionMask: ; 0xd04C80
	INCBIN "data/collision/mon_masks/mrmime_collision.1bpp"
ScytherAnimatedCollisionMask: ; 0xd04D00
	INCBIN "data/collision/mon_masks/scyther_collision.1bpp"
JynxAnimatedCollisionMask: ; 0xd04D80
	INCBIN "data/collision/mon_masks/jynx_collision.1bpp"
ElectabuzzAnimatedCollisionMask: ; 0xd04E00
	INCBIN "data/collision/mon_masks/electabuzz_collision.1bpp"
MagmarAnimatedCollisionMask: ; 0xd04E80
	INCBIN "data/collision/mon_masks/magmar_collision.1bpp"
PinsirAnimatedCollisionMask: ; 0xd04F00
	INCBIN "data/collision/mon_masks/pinsir_collision.1bpp"
TaurosAnimatedCollisionMask: ; 0xd04F80
	INCBIN "data/collision/mon_masks/tauros_collision.1bpp"
SlowpokeAnimatedCollisionMask: ; 0xd05000
	INCBIN "data/collision/mon_masks/slowpoke_collision.1bpp"
MagnemiteAnimatedCollisionMask: ; 0xd05080
	INCBIN "data/collision/mon_masks/magnemite_collision.1bpp"
FarfetchdAnimatedCollisionMask: ; 0xd05100
	INCBIN "data/collision/mon_masks/farfetchd_collision.1bpp"
DoduoAnimatedCollisionMask: ; 0xd05180
	INCBIN "data/collision/mon_masks/doduo_collision.1bpp"
SeelAnimatedCollisionMask: ; 0xd05200
	INCBIN "data/collision/mon_masks/seel_collision.1bpp"
GrimerAnimatedCollisionMask: ; 0xd05280
	INCBIN "data/collision/mon_masks/grimer_collision.1bpp"
ShellderAnimatedCollisionMask: ; 0xd05300
	INCBIN "data/collision/mon_masks/shellder_collision.1bpp"
GastlyAnimatedCollisionMask: ; 0xd05380
	INCBIN "data/collision/mon_masks/gastly_collision.1bpp"
OnixAnimatedCollisionMask: ; 0xd05400
	INCBIN "data/collision/mon_masks/onix_collision.1bpp"
DrowzeeAnimatedCollisionMask: ; 0xd05480
	INCBIN "data/collision/mon_masks/drowzee_collision.1bpp"
KrabbyAnimatedCollisionMask: ; 0xd05500
	INCBIN "data/collision/mon_masks/krabby_collision.1bpp"
VoltorbAnimatedCollisionMask: ; 0xd05580
	INCBIN "data/collision/mon_masks/voltorb_collision.1bpp"
ExeggcuteAnimatedCollisionMask: ; 0xd05600
	INCBIN "data/collision/mon_masks/exeggcute_collision.1bpp"
CuboneAnimatedCollisionMask: ; 0xd05680
	INCBIN "data/collision/mon_masks/cubone_collision.1bpp"
HitmonleeAnimatedCollisionMask: ; 0xd05700
	INCBIN "data/collision/mon_masks/hitmonlee_collision.1bpp"
HitmonchanAnimatedCollisionMask: ; 0xd05780
	INCBIN "data/collision/mon_masks/hitmonchan_collision.1bpp"
ZubatAnimatedCollisionMask: ; 0xd05800
	INCBIN "data/collision/mon_masks/zubat_collision.1bpp"
OddishAnimatedCollisionMask: ; 0xd05880
	INCBIN "data/collision/mon_masks/oddish_collision.1bpp"
ParasAnimatedCollisionMask: ; 0xd05900
	INCBIN "data/collision/mon_masks/paras_collision.1bpp"
VenonatAnimatedCollisionMask: ; 0xd05980
	INCBIN "data/collision/mon_masks/venonat_collision.1bpp"
DiglettAnimatedCollisionMask: ; 0xd05A00
	INCBIN "data/collision/mon_masks/diglett_collision.1bpp"
MeowthAnimatedCollisionMask: ; 0xd05A80
	INCBIN "data/collision/mon_masks/meowth_collision.1bpp"
PsyduckAnimatedCollisionMask: ; 0xd05B00
	INCBIN "data/collision/mon_masks/psyduck_collision.1bpp"
MankeyAnimatedCollisionMask: ; 0xd05B80
	INCBIN "data/collision/mon_masks/mankey_collision.1bpp"
GrowlitheAnimatedCollisionMask: ; 0xd05C00
	INCBIN "data/collision/mon_masks/growlithe_collision.1bpp"
PoliwagAnimatedCollisionMask: ; 0xd05C80
	INCBIN "data/collision/mon_masks/poliwag_collision.1bpp"
AbraAnimatedCollisionMask: ; 0xd05D00
	INCBIN "data/collision/mon_masks/abra_collision.1bpp"
MachopAnimatedCollisionMask: ; 0xd05D80
	INCBIN "data/collision/mon_masks/machop_collision.1bpp"
BellsproutAnimatedCollisionMask: ; 0xd05E00
	INCBIN "data/collision/mon_masks/bellsprout_collision.1bpp"
TentacoolAnimatedCollisionMask: ; 0xd05E80
	INCBIN "data/collision/mon_masks/tentacool_collision.1bpp"
GeodudeAnimatedCollisionMask: ; 0xd05F00
	INCBIN "data/collision/mon_masks/geodude_collision.1bpp"
PonytaAnimatedCollisionMask: ; 0xd05F80
	INCBIN "data/collision/mon_masks/ponyta_collision.1bpp"
BulbasaurAnimatedCollisionMask: ; 0xd06000
	INCBIN "data/collision/mon_masks/bulbasaur_collision.1bpp"
CharmanderAnimatedCollisionMask: ; 0xd06080
	INCBIN "data/collision/mon_masks/charmander_collision.1bpp"
SquirtleAnimatedCollisionMask: ; 0xd06100
	INCBIN "data/collision/mon_masks/squirtle_collision.1bpp"
CaterpieAnimatedCollisionMask: ; 0xd06180
	INCBIN "data/collision/mon_masks/caterpie_collision.1bpp"
WeedleAnimatedCollisionMask: ; 0xd06200
	INCBIN "data/collision/mon_masks/weedle_collision.1bpp"
PidgeyAnimatedCollisionMask: ; 0xd06280
	INCBIN "data/collision/mon_masks/pidgey_collision.1bpp"
RattataAnimatedCollisionMask: ; 0xd06300
	INCBIN "data/collision/mon_masks/rattata_collision.1bpp"
SpearowAnimatedCollisionMask: ; 0xd06380
	INCBIN "data/collision/mon_masks/spearow_collision.1bpp"
EkansAnimatedCollisionMask: ; 0xd06400
	INCBIN "data/collision/mon_masks/ekans_collision.1bpp"
PikachuAnimatedCollisionMask: ; 0xd06480
	INCBIN "data/collision/mon_masks/pikachu_collision.1bpp"
SandshrewAnimatedCollisionMask: ; 0xd06500
	INCBIN "data/collision/mon_masks/sandshrew_collision.1bpp"
NidoranfAnimatedCollisionMask: ; 0xd06580
	INCBIN "data/collision/mon_masks/nidoranf_collision.1bpp"
NidoranmAnimatedCollisionMask: ; 0xd06600
	INCBIN "data/collision/mon_masks/nidoranm_collision.1bpp"
ClefairyAnimatedCollisionMask: ; 0xd06680
	INCBIN "data/collision/mon_masks/clefairy_collision.1bpp"
VulpixAnimatedCollisionMask: ; 0xd06700
	INCBIN "data/collision/mon_masks/vulpix_collision.1bpp"
JigglypuffAnimatedCollisionMask: ; 0xd06780
	INCBIN "data/collision/mon_masks/jigglypuff_collision.1bpp"
	dr $d2800, $d3000

DiglettBonusTilemap_GameBoyColor: ; 0xd3000
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboycolor.map"
DiglettBonusTilemap2_GameBoyColor: ; 0xd3400
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboycolor_2.map"
	dr $d3800, $d4000

SECTION "bank35", ROMX, BANK[$35]

StageSeelBonusCollisionAttributesBallEntrance: ; 0xd4000
	INCBIN "data/collision/maps/seel_bonus_ball_entrance.collision"
	dr $d4400, $d4800

StageSeelBonusCollisionAttributes: ; 0xd4800
	INCBIN "data/collision/maps/seel_bonus.collision"
	dr $d4c00, $d5000

SeelBonusTilemap_GameBoy: ; 0xd5000
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboy.map"
	dr $d5400, $d5800

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
	dr $d6490, $d6600

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

NidorinoBillboardBGPaletteMap: ; 0xd7200
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

NidokingBillboardBGPaletteMap: ; 0xd7218
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ClefairyBillboardBGPaletteMap: ; 0xd7230
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ClefableBillboardBGPaletteMap: ; 0xd7248
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

VulpixBillboardBGPaletteMap: ; 0xd7260
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

NinetalesBillboardBGPaletteMap: ; 0xd7278
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

JigglypuffBillboardBGPaletteMap: ; 0xd7290
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $7, $7, $6
	db $6, $7, $7, $7, $7, $6
	db $6, $6, $6, $6, $6, $6

WigglytuffBillboardBGPaletteMap: ; 0xd72a8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $7, $6, $6
	db $6, $7, $6, $7, $6, $6
	db $6, $6, $6, $6, $6, $6

ZubatBillboardBGPaletteMap: ; 0xd72c0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GolbatBillboardBGPaletteMap: ; 0xd72d8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

OddishBillboardBGPaletteMap: ; 0xd72f0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $7, $7, $7, $7, $6
	db $6, $7, $7, $7, $7, $6

GloomBillboardBGPaletteMap: ; 0xd7308
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $7, $7, $6
	db $7, $7, $7, $7, $7, $7

VileplumeBillboardBGPaletteMap: ; 0xd7320
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $7, $7, $6
	db $6, $6, $7, $7, $7, $6

ParasBillboardBGPaletteMap: ; 0xd7338
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ParasectBillboardBGPaletteMap: ; 0xd7350
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

VenonatBillboardBGPaletteMap: ; 0xd7368
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d7380, $d7600

VenomothBillboardBGPaletteMap: ; 0xd7600
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DiglettBillboardBGPaletteMap: ; 0xd7618
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $7, $7, $6, $6

DugtrioBillboardBGPaletteMap: ; 0xd7630
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MeowthBillboardBGPaletteMap: ; 0xd7648
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6

PersianBillboardBGPaletteMap: ; 0xd7660
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PsyduckBillboardBGPaletteMap: ; 0xd7678
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GolduckBillboardBGPaletteMap: ; 0xd7690
	db $6, $7, $7, $7, $6, $6
	db $6, $7, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MankeyBillboardBGPaletteMap: ; 0xd76a8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PrimeapeBillboardBGPaletteMap: ; 0xd76c0
	db $6, $6, $6, $6, $6, $6
	db $7, $6, $6, $6, $6, $7
	db $7, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $6

GrowlitheBillboardBGPaletteMap: ; 0xd76d8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $6, $6, $6

ArcanineBillboardBGPaletteMap: ; 0xd76f0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PoliwagBillboardBGPaletteMap: ; 0xd7708
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PoliwhirlBillboardBGPaletteMap: ; 0xd7720
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PoliwrathBillboardBGPaletteMap: ; 0xd7738
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

AbraBillboardBGPaletteMap: ; 0xd7750
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

KadabraBillboardBGPaletteMap: ; 0xd7768
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $6, $6, $6, $6
	db $6, $7, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d7780, $d7a00

AlakazamBillboardBGPaletteMap: ; 0xd7a00
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $6, $6, $7, $6
	db $6, $6, $6, $6, $6, $6

MachopBillboardBGPaletteMap: ; 0xd7a18
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MachokeBillboardBGPaletteMap: ; 0xd7a30
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MachampBillboardBGPaletteMap: ; 0xd7a48
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

BellsproutBillboardBGPaletteMap: ; 0xd7a60
	db $6, $6, $6, $6, $7, $7
	db $6, $7, $7, $6, $7, $7
	db $6, $7, $7, $6, $6, $7
	db $6, $6, $6, $6, $7, $7

WeepinbellBillboardBGPaletteMap: ; 0xd7a78
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $6, $6, $6
	db $7, $7, $7, $6, $6, $6

VictreebellBillboardBGPaletteMap: ; 0xd7a90
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $7, $7, $7, $7
	db $6, $6, $6, $6, $6, $6

TentacoolBillboardBGPaletteMap: ; 0xd7aa8
	db $6, $7, $6, $6, $7, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

TentacruelBillboardBGPaletteMap: ; 0xd7ac0
	db $6, $6, $7, $6, $7, $6
	db $6, $6, $6, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GeodudeBillboardBGPaletteMap: ; 0xd7ad8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GravelerBillboardBGPaletteMap: ; 0xd7af0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GolemBillboardBGPaletteMap: ; 0xd7b08
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $6, $6, $6
	db $6, $7, $7, $6, $6, $6

PonytaBillboardBGPaletteMap: ; 0xd7b20
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $6, $6, $7
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $6

RapidashBillboardBGPaletteMap: ; 0xd7b38
	db $7, $7, $7, $7, $7, $6
	db $7, $7, $7, $6, $7, $6
	db $7, $7, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $6

SlowpokeBillboardBGPaletteMap: ; 0xd7b50
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $7, $6, $6
	db $7, $7, $7, $7, $6, $6
	db $7, $7, $7, $7, $6, $6

SlowbroBillboardBGPaletteMap: ; 0xd7b68
	db $7, $7, $7, $7, $7, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d7b80, $d8000

SECTION "bank36", ROMX, BANK[$36]
	dr $d8000, $d8400

MagnemiteBillboardBGPaletteMap: ; 0xd8400
	db $7, $7, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $6, $6

MagnetonBillboardBGPaletteMap: ; 0xd8418
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

FarfetchdBillboardBGPaletteMap: ; 0xd8430
	db $6, $6, $6, $6, $7, $7
	db $6, $6, $6, $6, $7, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DoduoBillboardBGPaletteMap: ; 0xd8448
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DodrioBillboardBGPaletteMap: ; 0xd8460
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

SeelBillboardBGPaletteMap: ; 0xd8478
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $7, $7, $6
	db $6, $6, $7, $7, $7, $6

DewgongBillboardBGPaletteMap: ; 0xd8490
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GrimerBillboardBGPaletteMap: ; 0xd84a8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MukBillboardBGPaletteMap: ; 0xd84c0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ShellderBillboardBGPaletteMap: ; 0xd84d8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $7, $6, $6

CloysterBillboardBGPaletteMap: ; 0xd84f0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GastlyBillboardBGPaletteMap: ; 0xd8508
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

HaunterBillboardBGPaletteMap: ; 0xd8520
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6

GengarBillboardBGPaletteMap: ; 0xd8538
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $6, $7, $6
	db $6, $6, $6, $6, $6, $6

OnixBillboardBGPaletteMap: ; 0xd8550
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DrowzeeBillboardBGPaletteMap: ; 0xd8568
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d8580, $d8800

HypnoBillboardBGPaletteMap: ; 0xd8800
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $7, $7
	db $7, $6, $6, $6, $7, $7
	db $7, $6, $6, $6, $7, $7

KrabbyBillboardBGPaletteMap: ; 0xd8818
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

KinglerBillboardBGPaletteMap: ; 0xd8830
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

VoltorbBillboardBGPaletteMap: ; 0xd8848
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $7
	db $6, $6, $6, $6, $7, $7
	db $7, $6, $6, $7, $7, $7

ElectrodeBillboardBGPaletteMap: ; 0xd8860
	db $6, $6, $6, $7, $7, $6
	db $6, $6, $6, $7, $7, $7
	db $6, $6, $6, $6, $7, $7
	db $6, $6, $6, $6, $6, $6

ExeggcuteBillboardBGPaletteMap: ; 0xd8878
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ExeggutorBillboardBGPaletteMap: ; 0xd8890
	db $6, $6, $6, $6, $6, $6
	db $6, $7, $7, $7, $7, $6
	db $6, $7, $7, $7, $7, $6
	db $6, $7, $7, $7, $7, $6

CuboneBillboardBGPaletteMap: ; 0xd88a8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $7, $7, $7, $6

MarowakBillboardBGPaletteMap: ; 0xd88c0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $7, $7

HitmonleeBillboardBGPaletteMap: ; 0xd88d8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

HitmonchanBillboardBGPaletteMap: ; 0xd88f0
	db $6, $6, $7, $7, $7, $7
	db $6, $6, $6, $7, $7, $7
	db $6, $6, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

LickitungBillboardBGPaletteMap: ; 0xd8908
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $7, $6, $6

KoffingBillboardBGPaletteMap: ; 0xd8920
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

WeezingBillboardBGPaletteMap: ; 0xd8938
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

RhyhornBillboardBGPaletteMap: ; 0xd8950
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

RhydonBillboardBGPaletteMap: ; 0xd8968
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d8980, $d8c00

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

MagikarpBillboardBGPaletteMap: ; 0xd9400
	db $6, $6, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $6

GyaradosBillboardBGPaletteMap: ; 0xd9418
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $7, $7, $6, $6

LaprasBillboardBGPaletteMap: ; 0xd9430
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DittoBillboardBGPaletteMap: ; 0xd9448
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

EeveeBillboardBGPaletteMap: ; 0xd9460
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

VaporeonBillboardBGPaletteMap: ; 0xd9478
	db $7, $7, $7, $6, $6, $6
	db $7, $7, $6, $6, $7, $7
	db $7, $7, $6, $6, $7, $7
	db $6, $6, $6, $6, $6, $6

JolteonBillboardBGPaletteMap: ; 0xd9490
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

FlareonBillboardBGPaletteMap: ; 0xd94a8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PorygonBillboardBGPaletteMap: ; 0xd94c0
	db $6, $6, $6, $6, $7, $6
	db $6, $6, $7, $6, $6, $7
	db $6, $7, $7, $6, $6, $7
	db $6, $7, $7, $7, $6, $6

OmanyteBillboardBGPaletteMap: ; 0xd94d8
	db $6, $7, $6, $6, $6, $6
	db $6, $7, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $6
	db $7, $7, $6, $6, $6, $6

OmastarBillboardBGPaletteMap: ; 0xd94f0
	db $6, $6, $6, $6, $7, $6
	db $6, $6, $6, $6, $7, $7
	db $6, $7, $7, $6, $6, $7
	db $6, $6, $7, $6, $6, $7

KabutoBillboardBGPaletteMap: ; 0xd9508
	db $6, $6, $6, $7, $7, $6
	db $6, $6, $7, $7, $7, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

KabutopsBillboardBGPaletteMap: ; 0xd9520
	db $7, $6, $6, $6, $6, $7
	db $7, $6, $6, $6, $7, $7
	db $7, $6, $6, $7, $6, $7
	db $6, $6, $7, $7, $6, $6

AerodactylBillboardBGPaletteMap: ; 0xd9538
	db $7, $7, $6, $6, $7, $7
	db $7, $7, $6, $7, $7, $7
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

SnorlaxBillboardBGPaletteMap: ; 0xd9550
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ArticunoBillboardBGPaletteMap: ; 0xd9568
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d9580, $d9800

ZapdosBillboardBGPaletteMap: ; 0xd9800
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MoltresBillboardBGPaletteMap: ; 0xd9818
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DratiniBillboardBGPaletteMap: ; 0xd9830
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DragonairBillboardBGPaletteMap: ; 0xd9848
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

DragoniteBillboardBGPaletteMap: ; 0xd9860
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $7, $6, $6, $6, $6, $7
	db $7, $7, $6, $6, $7, $7

MewtwoBillboardBGPaletteMap: ; 0xd9878
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6

MewBillboardBGPaletteMap: ; 0xd9890
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $d98a8, $d9c00

UnusedTextGfx: ; 0xd9c00
	INCBIN "gfx/unused_text.2bpp"

CopyrightTextGfx: ; 0xda000
	INCBIN "gfx/copyright_text.2bpp"

ChanseyBillboardBGPaletteMap: ; 0xda400
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

TangelaBillboardBGPaletteMap: ; 0xda418
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

KangaskhanBillboardBGPaletteMap: ; 0xda430
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

HorseaBillboardBGPaletteMap: ; 0xda448
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $7, $7

SeadraBillboardBGPaletteMap: ; 0xda460
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

GoldeenBillboardBGPaletteMap: ; 0xda478
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

SeakingBillboardBGPaletteMap: ; 0xda490
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

StaryuBillboardBGPaletteMap: ; 0xda4a8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $7, $6, $6
	db $6, $6, $6, $6, $6, $6

StarmieBillboardBGPaletteMap: ; 0xda4c0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $7, $6, $6
	db $6, $6, $6, $6, $6, $6

MrMimeBillboardBGPaletteMap: ; 0xda4d8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

ScytherBillboardBGPaletteMap: ; 0xda4f0
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

JynxBillboardBGPaletteMap: ; 0xda508
	db $6, $7, $7, $7, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $6, $6, $6

ElectabuzzBillboardBGPaletteMap: ; 0xda520
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MagmarBillboardBGPaletteMap: ; 0xda538
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

PinsirBillboardBGPaletteMap: ; 0xda550
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $7, $6, $6, $6
	db $6, $6, $6, $6, $7, $7

TaurosBillboardBGPaletteMap: ; 0xda568
	db $7, $7, $6, $6, $7, $7
	db $7, $7, $6, $7, $7, $7
	db $6, $7, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	dr $da580, $da800

BulbasaurBillboardBGPaletteMap: ; 0xda800
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $6, $7, $7
	db $7, $7, $7, $6, $6, $7

IvysaurBillboardBGPaletteMap: ; 0xda818
	db $6, $7, $7, $7, $7, $7
	db $7, $6, $6, $6, $6, $7
	db $6, $6, $6, $7, $6, $7
	db $6, $6, $6, $7, $7, $7

VenusaurBillboardBGPaletteMap: ; 0xda830
	db $7, $7, $6, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $6, $6, $6, $6, $7
	db $7, $7, $6, $6, $6, $7

CharmanderBillboardBGPaletteMap: ; 0xda848
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

CharmeleonBillboardBGPaletteMap: ; 0xda860
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

CharizardBillboardBGPaletteMap: ; 0xda878
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

SquirtleBillboardBGPaletteMap: ; 0xda890
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $6, $6, $7, $7

WartortleBillboardBGPaletteMap: ; 0xda8a8
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $6, $6, $7, $7
	db $7, $6, $6, $6, $7, $7

BlastoiseBillboardBGPaletteMap: ; 0xda8c0
	db $6, $6, $6, $6, $7, $7
	db $6, $7, $7, $7, $7, $7
	db $6, $6, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

CaterpieBillboardBGPaletteMap: ; 0xda8d8
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

MetapodBillboardBGPaletteMap: ; 0xda8f0
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

ButterfreeBillboardBGPaletteMap: ; 0xda908
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $6, $6, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

WeedleBillboardBGPaletteMap: ; 0xda920
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

KakunaBillboardBGPaletteMap: ; 0xda938
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

BeedrillBillboardBGPaletteMap: ; 0xda950
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7

PidgeyBillboardBGPaletteMap: ; 0xda968
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	db $7, $7, $7, $7, $7, $7
	dr $da980, $dac00

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

ZubatAnimatedObjPalette1: ; 0xdb780
	RGB 31, 31, 31
	RGB 15, 19, 31
	RGB 14, 9, 21
	RGB 0, 0, 0
ZubatAnimatedObjPalette2: ; 0xdb3788
	RGB 31, 31, 31
	RGB 15, 19, 31
	RGB 14, 9, 21
	RGB 0, 0, 0

OddishAnimatedObjPalette1: ; 0xdb790
	RGB 31, 31, 31
	RGB 27, 29, 5
	RGB 5, 16, 0
	RGB 0, 0, 0
OddishAnimatedObjPalette2: ; 0xdb798
	RGB 31, 31, 31
	RGB 27, 29, 5
	RGB 5, 16, 0
	RGB 0, 0, 0

ParasAnimatedObjPalette1: ; 0xdb7a0
	RGB 31, 31, 31
	RGB 31, 15, 1
	RGB 22, 5, 2
	RGB 0, 0, 0
ParasAnimatedObjPalette2: ; 0xdb7a8
	RGB 31, 31, 31
	RGB 31, 15, 1
	RGB 22, 5, 2
	RGB 0, 0, 0

VenonatAnimatedObjPalette1: ; 0xdb7b0
	RGB 31, 31, 31
	RGB 24, 15, 28
	RGB 12, 5, 18
	RGB 0, 0, 0
VenonatAnimatedObjPalette2: ; 0xdb7b8
	RGB 31, 31, 31
	RGB 24, 15, 28
	RGB 12, 5, 18
	RGB 0, 0, 0

DiglettAnimatedObjPalette1: ; 0xdb7c0
	RGB 31, 31, 31
	RGB 31, 18, 1
	RGB 24, 9, 3
	RGB 0, 0, 0
DiglettAnimatedObjPalette2: ; 0xdb7c8
	RGB 31, 31, 31
	RGB 31, 18, 1
	RGB 24, 9, 3
	RGB 0, 0, 0

MeowthAnimatedObjPalette1: ; 0xdb7d0
	RGB 31, 31, 31
	RGB 30, 25, 16
	RGB 23, 12, 6
	RGB 0, 0, 0
MeowthAnimatedObjPalette2: ; 0xdb7d8
	RGB 31, 31, 31
	RGB 30, 25, 16
	RGB 23, 12, 6
	RGB 0, 0, 0

PsyduckAnimatedObjPalette1: ; 0xdb7e0
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 19, 17, 0
	RGB 0, 0, 0
PsyduckAnimatedObjPalette2: ; 0xdb7e8
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 19, 17, 0
	RGB 0, 0, 0

MankeyAnimatedObjPalette1: ; 0xdb7f0
	RGB 31, 31, 31
	RGB 31, 21, 19
	RGB 23, 8, 4
	RGB 0, 0, 0
MankeyAnimatedObjPalette2: ; 0xdb7f8
	RGB 31, 31, 31
	RGB 31, 21, 19
	RGB 23, 8, 4
	RGB 0, 0, 0

GrowlitheAnimatedObjPalette1: ; 0xdb800
	RGB 31, 31, 31
	RGB 31, 18, 1
	RGB 24, 9, 3
	RGB 0, 0, 0
GrowlitheAnimatedObjPalette2: ; 0xdb808
	RGB 31, 31, 31
	RGB 31, 18, 1
	RGB 24, 9, 3
	RGB 0, 0, 0

PoliwagAnimatedObjPalette1: ; 0xdb810
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0
PoliwagAnimatedObjPalette2: ; 0xdb818
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0

AbraAnimatedObjPalette1: ; 0xdb820
	RGB 31, 31, 31
	RGB 30, 24, 0
	RGB 17, 10, 4
	RGB 0, 0, 0
AbraAnimatedObjPalette2: ; 0xdb828
	RGB 31, 31, 31
	RGB 30, 24, 0
	RGB 17, 10, 4
	RGB 0, 0, 0

MachopAnimatedObjPalette1: ; 0xdb830
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0
MachopAnimatedObjPalette2: ; 0xdb838
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0

BellsproutAnimatedObjPalette1: ; 0xdb840
	RGB 31, 31, 31
	RGB 29, 26, 5
	RGB 5, 16, 0
	RGB 0, 0, 0
BellsproutAnimatedObjPalette2: ; 0xdb848
	RGB 31, 31, 31
	RGB 29, 26, 5
	RGB 5, 16, 0
	RGB 0, 0, 0

TentacoolAnimatedObjPalette1: ; 0xdb850
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 0, 11, 22
	RGB 0, 0, 0
TentacoolAnimatedObjPalette2: ; 0xdb858
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 0, 11, 22
	RGB 0, 0, 0

GeodudeAnimatedObjPalette1: ; 0xdb860
	RGB 31, 31, 31
	RGB 19, 23, 20
	RGB 8, 11, 7
	RGB 0, 0, 0
GeodudeAnimatedObjPalette2: ; 0xdb868
	RGB 31, 31, 31
	RGB 19, 23, 20
	RGB 8, 11, 7
	RGB 0, 0, 0

PonytaAnimatedObjPalette1: ; 0xdb870
	RGB 31, 31, 31
	RGB 31, 28, 11
	RGB 31, 6, 0
	RGB 0, 0, 0
PonytaAnimatedObjPalette2: ; 0xdb878
	RGB 31, 31, 31
	RGB 31, 28, 11
	RGB 31, 6, 0
	RGB 0, 0, 0

SlowpokeAnimatedObjPalette1: ; 0xdb880
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 31, 11, 9
	RGB 0, 0, 0
SlowpokeAnimatedObjPalette2: ; 0xdb888
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 31, 11, 9
	RGB 0, 0, 0

MagnemiteAnimatedObjPalette1: ; 0xdb890
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0
MagnemiteAnimatedObjPalette2: ; 0xdb898
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0

FarfetchdAnimatedObjPalette1: ; 0xdb8a0
	RGB 31, 31, 31
	RGB 31, 22, 5
	RGB 19, 11, 4
	RGB 0, 0, 0
FarfetchdAnimatedObjPalette2: ; 0xdb8a8
	RGB 31, 31, 31
	RGB 31, 22, 5
	RGB 19, 11, 4
	RGB 0, 0, 0

DoduoAnimatedObjPalette1: ; 0xdb8b0
	RGB 31, 31, 31
	RGB 30, 20, 5
	RGB 22, 5, 2
	RGB 0, 0, 0
DoduoAnimatedObjPalette2: ; 0xdb8b8
	RGB 31, 31, 31
	RGB 30, 20, 5
	RGB 22, 5, 2
	RGB 0, 0, 0

SeelAnimatedObjPalette1: ; 0xdb8c0
	RGB 31, 31, 31
	RGB 20, 24, 29
	RGB 8, 11, 20
	RGB 0, 0, 0
SeelAnimatedObjPalette2: ; 0xdb8c8
	RGB 31, 31, 31
	RGB 20, 24, 29
	RGB 8, 11, 20
	RGB 0, 0, 0

GrimerAnimatedObjPalette1: ; 0xdb8d0
	RGB 31, 31, 31
	RGB 27, 15, 31
	RGB 16, 7, 19
	RGB 0, 0, 0
GrimerAnimatedObjPalette2: ; 0xdb8d8
	RGB 31, 31, 31
	RGB 27, 15, 31
	RGB 16, 7, 19
	RGB 0, 0, 0

ShellderAnimatedObjPalette1: ; 0xdb8e0
	RGB 31, 31, 31
	RGB 26, 19, 29
	RGB 15, 11, 17
	RGB 0, 0, 0
ShellderAnimatedObjPalette2: ; 0xdb8e8
	RGB 31, 31, 31
	RGB 26, 19, 29
	RGB 15, 11, 17
	RGB 0, 0, 0

GastlyAnimatedObjPalette1: ; 0xdb8f0
	RGB 31, 31, 31
	RGB 25, 17, 28
	RGB 12, 7, 15
	RGB 0, 0, 0
GastlyAnimatedObjPalette2: ; 0xdb8f8
	RGB 31, 31, 31
	RGB 31, 23, 17
	RGB 23, 8, 4
	RGB 0, 0, 0

OnixAnimatedObjPalette1: ; 0xdb900
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0
OnixAnimatedObjPalette2: ; 0xdb908
	RGB 31, 31, 31
	RGB 17, 19, 23
	RGB 9, 10, 12
	RGB 0, 0, 0

DrowzeeAnimatedObjPalette1: ; 0xdb910
	RGB 31, 31, 31
	RGB 30, 24, 0
	RGB 17, 10, 4
	RGB 0, 0, 0
DrowzeeAnimatedObjPalette2: ; 0xdb918
	RGB 31, 31, 31
	RGB 30, 24, 0
	RGB 17, 10, 4
	RGB 0, 0, 0

KrabbyAnimatedObjPalette1: ; 0xdb920
	RGB 31, 31, 31
	RGB 31, 20, 8
	RGB 28, 6, 0
	RGB 0, 0, 0
KrabbyAnimatedObjPalette2: ; 0xdb928
	RGB 31, 31, 31
	RGB 31, 20, 8
	RGB 28, 6, 0
	RGB 0, 0, 0

VoltorbAnimatedObjPalette1: ; 0xdb930
	RGB 31, 31, 31
	RGB 31, 17, 14
	RGB 31, 0, 0
	RGB 0, 0, 0
VoltorbAnimatedObjPalette2: ; 0xdb938
	RGB 31, 31, 31
	RGB 31, 17, 14
	RGB 31, 0, 0
	RGB 0, 0, 0

ExeggcuteAnimatedObjPalette1: ; 0xdb940
	RGB 31, 31, 31
	RGB 31, 17, 16
	RGB 20, 8, 5
	RGB 0, 0, 0
ExeggcuteAnimatedObjPalette2: ; 0xdb948
	RGB 31, 31, 31
	RGB 31, 17, 16
	RGB 20, 8, 5
	RGB 0, 0, 0

CuboneAnimatedObjPalette1: ; 0xdb950
	RGB 31, 31, 31
	RGB 30, 15, 5
	RGB 18, 9, 4
	RGB 0, 0, 0
CuboneAnimatedObjPalette2: ; 0xdb958
	RGB 31, 31, 31
	RGB 20, 22, 29
	RGB 13, 8, 6
	RGB 0, 0, 0

HitmonleeAnimatedObjPalette1: ; 0xdb960
	RGB 31, 31, 31
	RGB 26, 13, 7
	RGB 16, 10, 7
	RGB 0, 0, 0
HitmonleeAnimatedObjPalette2: ; 0xdb968
	RGB 31, 31, 31
	RGB 26, 13, 7
	RGB 16, 10, 7
	RGB 0, 0, 0

HitmonchanAnimatedObjPalette1: ; 0xdb970
	RGB 31, 31, 31
	RGB 27, 17, 10
	RGB 24, 4, 2
	RGB 0, 0, 0
HitmonchanAnimatedObjPalette2: ; 0xdb978
	RGB 31, 31, 31
	RGB 27, 17, 10
	RGB 24, 4, 2
	RGB 0, 0, 0

LickitungAnimatedObjPalette1: ; 0xdb980
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 31, 11, 9
	RGB 0, 0, 0
LickitungAnimatedObjPalette2: ; 0xdb988
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 31, 11, 9
	RGB 0, 0, 0

KoffingAnimatedObjPalette1: ; 0xdb990
	RGB 31, 31, 31
	RGB 26, 19, 29
	RGB 15, 11, 17
	RGB 0, 0, 0
KoffingAnimatedObjPalette2: ; 0xdb998
	RGB 31, 31, 31
	RGB 26, 19, 29
	RGB 15, 11, 17
	RGB 0, 0, 0

RhyhornAnimatedObjPalette1: ; 0xdb9a0
	RGB 31, 31, 31
	RGB 26, 13, 24
	RGB 15, 4, 14
	RGB 0, 0, 0
RhyhornAnimatedObjPalette2: ; 0xdb9a8
	RGB 31, 31, 31
	RGB 26, 13, 24
	RGB 15, 4, 14
	RGB 0, 0, 0

ChanseyAnimatedObjPalette1: ; 0xdb9b0
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 31, 11, 9
	RGB 0, 0, 0
ChanseyAnimatedObjPalette2: ; 0xdb9b8
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 31, 11, 9
	RGB 0, 0, 0

TangelaAnimatedObjPalette1: ; 0xdb9c0
	RGB 31, 31, 31
	RGB 13, 19, 31
	RGB 1, 6, 20
	RGB 0, 0, 0
TangelaAnimatedObjPalette2: ; 0xdb9c8
	RGB 31, 31, 31
	RGB 13, 19, 31
	RGB 1, 6, 20
	RGB 0, 0, 0

KangaskhanAnimatedObjPalette1: ; 0xdb9d0
	RGB 31, 31, 31
	RGB 28, 21, 11
	RGB 16, 10, 5
	RGB 0, 0, 0
KangaskhanAnimatedObjPalette2: ; 0xdb9d8
	RGB 31, 31, 31
	RGB 28, 21, 11
	RGB 16, 10, 5
	RGB 0, 0, 0

HorseaAnimatedObjPalette1: ; 0xdb9e0
	RGB 31, 31, 31
	RGB 13, 19, 31
	RGB 1, 6, 20
	RGB 0, 0, 0
HorseaAnimatedObjPalette2: ; 0xdb9e8
	RGB 31, 31, 31
	RGB 13, 19, 31
	RGB 1, 6, 20
	RGB 0, 0, 0

GoldeenAnimatedObjPalette1: ; 0xdb9f0
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 29, 0, 0
	RGB 0, 0, 0
GoldeenAnimatedObjPalette2: ; 0xdb9f8
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 29, 0, 0
	RGB 0, 0, 0

StaryuAnimatedObjPalette1: ; 0xdba00
	RGB 31, 31, 31
	RGB 31, 22, 5
	RGB 19, 7, 1
	RGB 0, 0, 0
StaryuAnimatedObjPalette2: ; 0xdba08
	RGB 31, 31, 31
	RGB 31, 22, 5
	RGB 19, 7, 1
	RGB 0, 0, 0

MrMimeAnimatedObjPalette1: ; 0xdba10
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 29, 0, 0
	RGB 0, 0, 0
MrMimeAnimatedObjPalette2: ; 0xdba18
	RGB 31, 31, 31
	RGB 31, 18, 16
	RGB 29, 0, 0
	RGB 0, 0, 0

ScytherAnimatedObjPalette1: ; 0xdba20
	RGB 31, 31, 31
	RGB 22, 29, 5
	RGB 6, 17, 1
	RGB 0, 0, 0
ScytherAnimatedObjPalette2: ; 0xdba28
	RGB 31, 31, 31
	RGB 22, 29, 5
	RGB 6, 17, 1
	RGB 0, 0, 0

JynxAnimatedObjPalette1: ; 0xdba30
	RGB 31, 31, 31
	RGB 31, 16, 16
	RGB 25, 1, 3
	RGB 0, 0, 0
JynxAnimatedObjPalette2: ; 0xdba38
	RGB 31, 31, 31
	RGB 31, 16, 16
	RGB 25, 1, 3
	RGB 0, 0, 0

ElectabuzzAnimatedObjPalette1: ; 0xdba40
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 21, 14, 1
	RGB 0, 0, 0
ElectabuzzAnimatedObjPalette2: ; 0xdba48
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 21, 14, 1
	RGB 0, 0, 0

MagmarAnimatedObjPalette1: ; 0xdba50
	RGB 31, 31, 31
	RGB 31, 23, 2
	RGB 31, 3, 0
	RGB 0, 0, 0
MagmarAnimatedObjPalette2: ; 0xdba58
	RGB 31, 31, 31
	RGB 31, 23, 2
	RGB 31, 3, 0
	RGB 0, 0, 0

PinsirAnimatedObjPalette1: ; 0xdba60
	RGB 31, 31, 31
	RGB 28, 20, 13
	RGB 17, 12, 6
	RGB 0, 0, 0
PinsirAnimatedObjPalette2: ; 0xdba68
	RGB 31, 31, 31
	RGB 28, 20, 13
	RGB 17, 12, 6
	RGB 0, 0, 0

TaurosAnimatedObjPalette1: ; 0xdba70
	RGB 31, 31, 31
	RGB 31, 21, 5
	RGB 20, 9, 3
	RGB 0, 0, 0
TaurosAnimatedObjPalette2: ; 0xdba78
	RGB 31, 31, 31
	RGB 31, 21, 5
	RGB 20, 9, 3
	RGB 0, 0, 0

PidgeottoBillboardBGPalette1: ; 0xdba80
	RGB 31, 31, 31
	RGB 30, 21, 0
	RGB 28, 6, 1
	RGB 3, 2, 0
PidgeottoBillboardBGPalette2: ; 0xdba88
	RGB 31, 31, 31
	RGB 30, 21, 0
	RGB 28, 6, 1
	RGB 3, 2, 0

PidgeotBillboardBGPalette1: ; 0xdba90
	RGB 31, 31, 31
	RGB 26, 23, 0
	RGB 28, 6, 1
	RGB 3, 2, 0
PidgeotBillboardBGPalette2: ; 0xdba98
	RGB 31, 31, 31
	RGB 26, 23, 0
	RGB 28, 6, 1
	RGB 3, 2, 0

RattataBillboardBGPalette1: ; 0xdbaa0
	RGB 31, 31, 31
	RGB 30, 16, 24
	RGB 21, 4, 7
	RGB 0, 0, 0
RattataBillboardBGPalette2: ; 0xdbaa8
	RGB 31, 31, 31
	RGB 30, 16, 24
	RGB 21, 4, 7
	RGB 0, 0, 0

RaticateBillboardBGPalette1: ; 0xdbab0
	RGB 31, 31, 31
	RGB 30, 24, 7
	RGB 27, 7, 0
	RGB 3, 2, 0
RaticateBillboardBGPalette2: ; 0xdbab8
	RGB 31, 31, 31
	RGB 30, 24, 7
	RGB 27, 7, 0
	RGB 3, 2, 0

SpearowBillboardBGPalette1: ; 0xdbac0
	RGB 31, 31, 31
	RGB 31, 24, 2
	RGB 30, 3, 0
	RGB 0, 0, 0
SpearowBillboardBGPalette2: ; 0xdbac8
	RGB 31, 31, 31
	RGB 31, 24, 2
	RGB 30, 3, 0
	RGB 0, 0, 0

FearowBillboardBGPalette1: ; 0xdbad0
	RGB 31, 31, 31
	RGB 31, 24, 2
	RGB 30, 3, 0
	RGB 0, 0, 0
FearowBillboardBGPalette2: ; 0xdbad8
	RGB 31, 31, 31
	RGB 31, 24, 2
	RGB 30, 3, 0
	RGB 0, 0, 0

EkansBillboardBGPalette1: ; 0xdbae0
	RGB 31, 31, 31
	RGB 30, 16, 24
	RGB 21, 4, 7
	RGB 0, 0, 0
EkansBillboardBGPalette2: ; 0xdbae8
	RGB 31, 31, 31
	RGB 30, 16, 24
	RGB 21, 4, 7
	RGB 0, 0, 0

ArbokBillboardBGPalette1: ; 0xdbaf0
	RGB 31, 31, 31
	RGB 30, 16, 24
	RGB 26, 1, 5
	RGB 0, 0, 0
ArbokBillboardBGPalette2: ; 0xdbaf8
	RGB 31, 31, 31
	RGB 30, 16, 24
	RGB 26, 1, 5
	RGB 0, 0, 0

PikachuBillboardBGPalette1: ; 0xdbb00
	RGB 31, 31, 31
	RGB 30, 24, 4
	RGB 27, 7, 0
	RGB 3, 2, 0
PikachuBillboardBGPalette2: ; 0xdbb08
	RGB 31, 31, 31
	RGB 30, 24, 4
	RGB 27, 7, 0
	RGB 3, 2, 0

RaichuBillboardBGPalette1: ; 0xdbb10
	RGB 31, 31, 31
	RGB 30, 26, 3
	RGB 29, 16, 0
	RGB 3, 2, 0
RaichuBillboardBGPalette2: ; 0xdbb18
	RGB 31, 31, 31
	RGB 30, 26, 3
	RGB 29, 16, 0
	RGB 3, 2, 0

SandshrewBillboardBGPalette1: ; 0xdbb20
	RGB 31, 31, 31
	RGB 31, 25, 7
	RGB 23, 14, 0
	RGB 0, 0, 0
SandshrewBillboardBGPalette2: ; 0xdbb28
	RGB 31, 31, 31
	RGB 31, 25, 7
	RGB 23, 14, 0
	RGB 0, 0, 0

SandslashBillboardBGPalette1: ; 0xdbb30
	RGB 31, 31, 31
	RGB 31, 25, 7
	RGB 25, 10, 0
	RGB 3, 2, 0
SandslashBillboardBGPalette2: ; 0xdbb38
	RGB 31, 31, 31
	RGB 31, 25, 7
	RGB 25, 10, 0
	RGB 3, 2, 0

NidoranFBillboardBGPalette1: ; 0xdbb40
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 8, 8, 24
	RGB 0, 0, 0
NidoranFBillboardBGPalette2: ; 0xdbb48
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 8, 8, 24
	RGB 0, 0, 0

NidorinaBillboardBGPalette1: ; 0xdbb50
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 8, 8, 24
	RGB 0, 0, 0
NidorinaBillboardBGPalette2: ; 0xdbb58
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 8, 8, 24
	RGB 0, 0, 0

NidoqueenBillboardBGPalette1: ; 0xdbb60
	RGB 31, 31, 31
	RGB 10, 18, 31
	RGB 6, 5, 23
	RGB 0, 0, 0
NidoqueenBillboardBGPalette2: ; 0xdbb68
	RGB 31, 31, 31
	RGB 10, 18, 31
	RGB 6, 5, 23
	RGB 0, 0, 0

NidoranMBillboardBGPalette1: ; 0xdbb70
	RGB 31, 31, 31
	RGB 28, 16, 25
	RGB 17, 1, 12
	RGB 0, 0, 0
NidoranMBillboardBGPalette2: ; 0xdbb78
	RGB 31, 31, 31
	RGB 28, 16, 25
	RGB 17, 1, 12
	RGB 0, 0, 0

StageRedFieldTopGfx6: ; 0xdbb80
	INCBIN "gfx/stage/red_top/red_top_6.2bpp"
	dr $dbbc0, $dbc80

StageMewtwoBonusCollisionMasks: ; 0xdbc80
	INCBIN "data/collision/masks/mewtwo_bonus.masks"

MagikarpAnimatedObjPalette1: ; 0xdbd80
	RGB 31, 31, 31
	RGB 31, 16, 10
	RGB 28, 6, 0
	RGB 0, 0, 0
MagikarpAnimatedObjPalette2: ; 0xdbd88
	RGB 31, 31, 31
	RGB 31, 16, 10
	RGB 28, 6, 0
	RGB 0, 0, 0

LaprasAnimatedObjPalette1: ; 0xdbd90
	RGB 31, 31, 31
	RGB 11, 22, 31
	RGB 0, 10, 30
	RGB 0, 0, 0
LaprasAnimatedObjPalette2: ; 0xdbd98
	RGB 31, 31, 31
	RGB 11, 22, 31
	RGB 0, 10, 30
	RGB 0, 0, 0

DittoAnimatedObjPalette1: ; 0xdbda0
	RGB 31, 31, 31
	RGB 25, 18, 28
	RGB 15, 7, 16
	RGB 0, 0, 0
DittoAnimatedObjPalette2: ; 0xdbda8
	RGB 31, 31, 31
	RGB 25, 18, 28
	RGB 15, 7, 16
	RGB 0, 0, 0

EeveeAnimatedObjPalette1: ; 0xdbdb0
	RGB 31, 31, 31
	RGB 29, 20, 10
	RGB 17, 9, 4
	RGB 0, 0, 0
EeveeAnimatedObjPalette2: ; 0xdbdb8
	RGB 31, 31, 31
	RGB 29, 20, 10
	RGB 17, 9, 4
	RGB 0, 0, 0

PorygonAnimatedObjPalette1: ; 0xdbdc0
	RGB 31, 31, 31
	RGB 29, 8, 20
	RGB 0, 0, 31
	RGB 0, 0, 0
PorygonAnimatedObjPalette2: ; 0xdbdc8
	RGB 31, 31, 31
	RGB 29, 8, 20
	RGB 0, 0, 31
	RGB 0, 0, 0

OmanyteAnimatedObjPalette1: ; 0xdbdd0
	RGB 31, 31, 31
	RGB 13, 18, 31
	RGB 1, 6, 20
	RGB 0, 0, 0
OmanyteAnimatedObjPalette2: ; 0xdbdd8
	RGB 31, 31, 31
	RGB 13, 18, 31
	RGB 1, 6, 20
	RGB 0, 0, 0

KabutoAnimatedObjPalette1: ; 0xdbde0
	RGB 31, 31, 31
	RGB 29, 21, 6
	RGB 20, 7, 1
	RGB 0, 0, 0
KabutoAnimatedObjPalette2: ; 0xdbde8
	RGB 31, 31, 31
	RGB 29, 21, 6
	RGB 20, 7, 1
	RGB 0, 0, 0

AerodactylAnimatedObjPalette1: ; 0xdbdf0
	RGB 31, 31, 31
	RGB 25, 20, 29
	RGB 10, 8, 17
	RGB 0, 0, 0
AerodactylAnimatedObjPalette2: ; 0xdbdf8
	RGB 31, 31, 31
	RGB 25, 20, 29
	RGB 10, 8, 17
	RGB 0, 0, 0

SnorlaxAnimatedObjPalette1: ; 0xdbe00
	RGB 31, 31, 31
	RGB 31, 25, 9
	RGB 17, 7, 2
	RGB 0, 0, 0
SnorlaxAnimatedObjPalette2: ; 0xdbe08
	RGB 31, 31, 31
	RGB 31, 25, 9
	RGB 17, 7, 2
	RGB 0, 0, 0

ArticunoAnimatedObjPalette1: ; 0xdbe10
	RGB 31, 31, 31
	RGB 11, 22, 31
	RGB 0, 4, 31
	RGB 0, 0, 0
ArticunoAnimatedObjPalette2: ; 0xdbe18
	RGB 31, 31, 31
	RGB 11, 22, 31
	RGB 0, 4, 31
	RGB 0, 0, 0

ZapdosAnimatedObjPalette1: ; 0xdbe20
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 22, 7, 3
	RGB 0, 0, 0
ZapdosAnimatedObjPalette2: ; 0xdbe28
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 22, 7, 3
	RGB 0, 0, 0

MoltresAnimatedObjPalette1: ; 0xdbe30
	RGB 31, 31, 31
	RGB 31, 26, 0
	RGB 31, 3, 0
	RGB 0, 0, 0
MoltresAnimatedObjPalette2: ; 0xdbe38
	RGB 31, 31, 31
	RGB 31, 26, 0
	RGB 31, 3, 0
	RGB 0, 0, 0

DratiniAnimatedObjPalette1: ; 0xdbe40
	RGB 31, 31, 31
	RGB 20, 22, 31
	RGB 6, 8, 18
	RGB 0, 0, 0
DratiniAnimatedObjPalette2: ; 0xdbe48
	RGB 31, 31, 31
	RGB 20, 22, 31
	RGB 6, 8, 18
	RGB 0, 0, 0

MewtwoAnimatedObjPalette1: ; 0xdbe50
	RGB 31, 31, 31
	RGB 31, 19, 27
	RGB 23, 8, 17
	RGB 0, 0, 0
MewtwoAnimatedObjPalette2: ; 0xdbe58
	RGB 31, 31, 31
	RGB 31, 19, 27
	RGB 23, 8, 17
	RGB 0, 0, 0

MewAnimatedObjPalette1: ; 0xdbe60
	RGB 31, 31, 31
	RGB 31, 19, 27
	RGB 23, 8, 17
	RGB 0, 0, 0
MewAnimatedObjPalette2: ; 0xdbe68
	RGB 31, 31, 31
	RGB 31, 19, 27
	RGB 23, 8, 17
	RGB 0, 0, 0
	dr $dbe70, $dbe80

Data_dbe80:
	dr $dbe80, $dc000

SECTION "bank37", ROMX, BANK[$37]

StageSharedArrowsGfx: ; 0xdc000
	INCBIN "gfx/stage/shared/arrows.2bpp"
	dr $dc080, $dc100

NidorinoBillboardBGPalette1: ; 0xdc100
	RGB 31, 31, 31
	RGB 31, 15, 24
	RGB 21, 3, 15
	RGB 0, 0, 0
NidorinoBillboardBGPalette2: ; 0xdc108
	RGB 31, 31, 31
	RGB 31, 15, 24
	RGB 21, 3, 15
	RGB 0, 0, 0

NidokingBillboardBGPalette1: ; 0xdc110
	RGB 31, 31, 31
	RGB 25, 14, 31
	RGB 17, 0, 26
	RGB 0, 0, 0
NidokingBillboardBGPalette2: ; 0xdc118
	RGB 31, 31, 31
	RGB 25, 14, 31
	RGB 17, 0, 26
	RGB 0, 0, 0

ClefairyBillboardBGPalette1: ; 0xdc120
	RGB 31, 31, 31
	RGB 31, 14, 18
	RGB 20, 8, 4
	RGB 0, 0, 0
ClefairyBillboardBGPalette2: ; 0xdc128
	RGB 31, 31, 31
	RGB 31, 14, 18
	RGB 20, 8, 4
	RGB 0, 0, 0

ClefableBillboardBGPalette1: ; 0xdc130
	RGB 31, 31, 31
	RGB 31, 14, 18
	RGB 20, 8, 4
	RGB 0, 0, 0
ClefableBillboardBGPalette2: ; 0xdc138
	RGB 31, 31, 31
	RGB 31, 14, 18
	RGB 20, 8, 4
	RGB 0, 0, 0

VulpixBillboardBGPalette1: ; 0xdc140
	RGB 31, 31, 31
	RGB 31, 17, 13
	RGB 25, 6, 0
	RGB 0, 0, 0
VulpixBillboardBGPalette2: ; 0xdc148
	RGB 31, 31, 31
	RGB 31, 17, 13
	RGB 25, 6, 0
	RGB 0, 0, 0

NinetalesBillboardBGPalette1: ; 0xdc150
	RGB 31, 31, 31
	RGB 28, 26, 0
	RGB 23, 12, 3
	RGB 0, 0, 0
NinetalesBillboardBGPalette2: ; 0xdc158
	RGB 31, 31, 31
	RGB 28, 26, 0
	RGB 23, 12, 3
	RGB 0, 0, 0

JigglypuffBillboardBGPalette1: ; 0xdc160
	RGB 31, 31, 31
	RGB 31, 16, 19
	RGB 22, 6, 11
	RGB 3, 2, 0
JigglypuffBillboardBGPalette2: ; 0xdc168
	RGB 31, 31, 31
	RGB 31, 16, 19
	RGB 13, 2, 21
	RGB 0, 0, 0

WigglytuffBillboardBGPalette1: ; 0xdc170
	RGB 31, 31, 31
	RGB 31, 16, 19
	RGB 22, 6, 11
	RGB 3, 2, 0
WigglytuffBillboardBGPalette2: ; 0xdc178
	RGB 31, 31, 31
	RGB 31, 16, 19
	RGB 13, 5, 19
	RGB 0, 0, 0

ZubatBillboardBGPalette1: ; 0xdc180
	RGB 31, 31, 31
	RGB 14, 15, 30
	RGB 10, 5, 26
	RGB 3, 2, 0
ZubatBillboardBGPalette2: ; 0xdc188
	RGB 31, 31, 31
	RGB 14, 15, 30
	RGB 10, 5, 26
	RGB 0, 0, 0

GolbatBillboardBGPalette1: ; 0xdc190
	RGB 31, 31, 31
	RGB 15, 15, 30
	RGB 10, 5, 26
	RGB 3, 2, 0
GolbatBillboardBGPalette2: ; 0xdc198
	RGB 31, 31, 31
	RGB 15, 15, 30
	RGB 10, 5, 26
	RGB 0, 0, 0

OddishBillboardBGPalette1: ; 0xdc1a0
	RGB 31, 31, 31
	RGB 22, 28, 2
	RGB 7, 18, 0
	RGB 0, 0, 0
OddishBillboardBGPalette2: ; 0xdc1a8
	RGB 31, 31, 31
	RGB 31, 6, 0
	RGB 4, 8, 14
	RGB 0, 0, 0

GloomBillboardBGPalette1: ; 0xdc1b0
	RGB 31, 31, 31
	RGB 30, 19, 15
	RGB 28, 4, 0
	RGB 0, 0, 0
GloomBillboardBGPalette2: ; 0xdc1b8
	RGB 31, 31, 31
	RGB 19, 20, 31
	RGB 4, 8, 14
	RGB 0, 0, 0

VileplumeBillboardBGPalette1: ; 0xdc1c0
	RGB 31, 31, 31
	RGB 30, 19, 15
	RGB 28, 4, 0
	RGB 0, 0, 0
VileplumeBillboardBGPalette2: ; 0xdc1c8
	RGB 31, 31, 31
	RGB 19, 20, 31
	RGB 4, 8, 14
	RGB 0, 0, 0

ParasBillboardBGPalette1: ; 0xdc1d0
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 23, 6, 3
	RGB 0, 0, 0
ParasBillboardBGPalette2: ; 0xdc1d8
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 23, 6, 3
	RGB 0, 0, 0

ParasectBillboardBGPalette1: ; 0xdc1e0
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 23, 6, 3
	RGB 0, 0, 0
ParasectBillboardBGPalette2: ; 0xdc1e8
	RGB 31, 31, 31
	RGB 31, 20, 11
	RGB 23, 6, 3
	RGB 0, 0, 0

VenonatBillboardBGPalette1: ; 0xdc1f0
	RGB 31, 31, 31
	RGB 24, 15, 28
	RGB 12, 5, 18
	RGB 0, 0, 0
VenonatBillboardBGPalette2: ; 0xdc1f8
	RGB 31, 31, 31
	RGB 24, 15, 28
	RGB 12, 5, 18
	RGB 0, 0, 0

VenomothBillboardBGPalette1: ; 0xdc200
	RGB 31, 31, 31
	RGB 27, 17, 29
	RGB 17, 7, 16
	RGB 0, 0, 0
VenomothBillboardBGPalette2: ; 0xdc208
	RGB 31, 31, 31
	RGB 27, 17, 29
	RGB 17, 7, 16
	RGB 0, 0, 0

DiglettBillboardBGPalette1: ; 0xdc210
	RGB 31, 31, 31
	RGB 24, 17, 5
	RGB 15, 7, 0
	RGB 0, 0, 0
DiglettBillboardBGPalette2: ; 0xdc218
	RGB 31, 31, 31
	RGB 24, 17, 5
	RGB 23, 3, 0
	RGB 0, 0, 0

DugtrioBillboardBGPalette1: ; 0xdc220
	RGB 31, 31, 31
	RGB 24, 17, 5
	RGB 15, 7, 0
	RGB 0, 0, 0
DugtrioBillboardBGPalette2: ; 0xdc228
	RGB 31, 31, 31
	RGB 24, 17, 5
	RGB 23, 3, 0
	RGB 0, 0, 0

MeowthBillboardBGPalette1: ; 0xdc230
	RGB 31, 31, 31
	RGB 29, 28, 7
	RGB 19, 10, 0
	RGB 0, 0, 0
MeowthBillboardBGPalette2: ; 0xdc238
	RGB 31, 31, 31
	RGB 29, 28, 7
	RGB 31, 0, 0
	RGB 0, 0, 0

PersianBillboardBGPalette1: ; 0xdc240
	RGB 31, 31, 31
	RGB 29, 28, 7
	RGB 19, 10, 0
	RGB 0, 0, 0
PersianBillboardBGPalette2: ; 0xdc248
	RGB 31, 31, 31
	RGB 29, 28, 7
	RGB 31, 0, 0
	RGB 0, 0, 0

PsyduckBillboardBGPalette1: ; 0xdc250
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 19, 17, 0
	RGB 0, 0, 0
PsyduckBillboardBGPalette2: ; 0xdc258
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 19, 17, 0
	RGB 0, 0, 0

GolduckBillboardBGPalette1: ; 0xdc260
	RGB 31, 31, 31
	RGB 26, 25, 7
	RGB 13, 15, 27
	RGB 0, 0, 0
GolduckBillboardBGPalette2: ; 0xdc268
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 13, 15, 27
	RGB 0, 0, 0

MankeyBillboardBGPalette1: ; 0xdc270
	RGB 31, 31, 31
	RGB 28, 20, 17
	RGB 22, 9, 5
	RGB 0, 0, 0
MankeyBillboardBGPalette2: ; 0xdc278
	RGB 31, 31, 31
	RGB 28, 20, 17
	RGB 22, 9, 5
	RGB 0, 0, 0

PrimeapeBillboardBGPalette1: ; 0xdc280
	RGB 31, 31, 31
	RGB 28, 20, 17
	RGB 22, 9, 5
	RGB 0, 0, 0
PrimeapeBillboardBGPalette2: ; 0xdc288
	RGB 31, 31, 31
	RGB 15, 15, 15
	RGB 22, 9, 5
	RGB 0, 0, 0

GrowlitheBillboardBGPalette1: ; 0xdc290
	RGB 31, 31, 31
	RGB 28, 27, 10
	RGB 26, 12, 0
	RGB 0, 0, 0
GrowlitheBillboardBGPalette2: ; 0xdc298
	RGB 31, 31, 31
	RGB 28, 27, 10
	RGB 31, 0, 0
	RGB 0, 0, 0

ArcanineBillboardBGPalette1: ; 0xdc2a0
	RGB 31, 31, 31
	RGB 28, 27, 10
	RGB 26, 12, 0
	RGB 0, 0, 0
ArcanineBillboardBGPalette2: ; 0xdc2a8
	RGB 31, 31, 31
	RGB 28, 27, 10
	RGB 31, 0, 0
	RGB 0, 0, 0

PoliwagBillboardBGPalette1: ; 0xdc2b0
	RGB 31, 31, 31
	RGB 20, 20, 27
	RGB 11, 11, 18
	RGB 0, 0, 0
PoliwagBillboardBGPalette2: ; 0xdc2b8
	RGB 31, 31, 31
	RGB 31, 17, 14
	RGB 11, 11, 18
	RGB 0, 0, 0

PoliwhirlBillboardBGPalette1: ; 0xdc2c0
	RGB 31, 31, 31
	RGB 20, 20, 27
	RGB 11, 11, 18
	RGB 0, 0, 0
PoliwhirlBillboardBGPalette2: ; 0xdc2c8
	RGB 31, 31, 31
	RGB 20, 20, 27
	RGB 11, 11, 18
	RGB 0, 0, 0

PoliwrathBillboardBGPalette1: ; 0xdc2d0
	RGB 31, 31, 31
	RGB 20, 20, 27
	RGB 11, 11, 18
	RGB 0, 0, 0
PoliwrathBillboardBGPalette2: ; 0xdc2d8
	RGB 31, 31, 31
	RGB 20, 20, 27
	RGB 11, 11, 18
	RGB 0, 0, 0

AbraBillboardBGPalette1: ; 0xdc2e0
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 19, 11, 6
	RGB 0, 0, 0
AbraBillboardBGPalette2: ; 0xdc2e8
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 19, 11, 6
	RGB 0, 0, 0

KadabraBillboardBGPalette1: ; 0xdc2f0
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 19, 11, 6
	RGB 0, 0, 0
KadabraBillboardBGPalette2: ; 0xdc2f8
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 19, 11, 6
	RGB 0, 0, 0

HypnoBillboardBGPalette1: ; 0xdc300
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 21, 15, 5
HypnoBillboardBGPalette2: ; 0xdc308
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 21, 15, 5
	RGB 0, 0, 0

KrabbyBillboardBGPalette1: ; 0xdc310
	RGB 31, 31, 31
	RGB 31, 16, 17
	RGB 25, 6, 0
KrabbyBillboardBGPalette2: ; 0xdc318
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 16, 17
	RGB 25, 6, 0
	RGB 0, 0, 0

KinglerBillboardBGPalette1: ; 0xdc320
	RGB 31, 31, 31
	RGB 31, 16, 17
	RGB 25, 6, 0
KinglerBillboardBGPalette2: ; 0xdc328
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 16, 17
	RGB 25, 6, 0
	RGB 0, 0, 0

VoltorbBillboardBGPalette1: ; 0xdc330
	RGB 31, 31, 31
	RGB 31, 16, 17
	RGB 25, 6, 0
VoltorbBillboardBGPalette2: ; 0xdc338
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 25, 6, 0
	RGB 0, 0, 0

ElectrodeBillboardBGPalette1: ; 0xdc340
	RGB 31, 31, 31
	RGB 31, 15, 12
	RGB 25, 6, 0
ElectrodeBillboardBGPalette2: ; 0xdc348
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 19, 23, 31
	RGB 25, 6, 0
	RGB 0, 0, 0

ExeggcuteBillboardBGPalette1: ; 0xdc350
	RGB 31, 31, 31
	RGB 31, 15, 12
	RGB 18, 8, 6
ExeggcuteBillboardBGPalette2: ; 0xdc358
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 15, 12
	RGB 18, 8, 6
	RGB 0, 0, 0

ExeggutorBillboardBGPalette1: ; 0xdc360
	RGB 31, 31, 31
	RGB 31, 27, 5
	RGB 7, 18, 0
ExeggutorBillboardBGPalette2: ; 0xdc368
	RGB 3, 2, 0
	RGB 31, 31, 31
	RGB 31, 23, 5
	RGB 20, 10, 3
	RGB 0, 0, 0

CuboneBillboardBGPalette1: ; 0xdc370
	RGB 31, 31, 31
	RGB 18, 20, 27
	RGB 20, 10, 3
CuboneBillboardBGPalette2: ; 0xdc378
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 29, 23, 10
	RGB 20, 10, 3
	RGB 0, 0, 0

MarowakBillboardBGPalette1: ; 0xdc380
	RGB 31, 31, 31
	RGB 18, 20, 27
	RGB 20, 10, 3
MarowakBillboardBGPalette2: ; 0xdc388
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 29, 23, 10
	RGB 20, 10, 3
	RGB 0, 0, 0

HitmonleeBillboardBGPalette1: ; 0xdc390
	RGB 31, 31, 31
	RGB 29, 23, 10
	RGB 21, 13, 3
HitmonleeBillboardBGPalette2: ; 0xdc398
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 29, 23, 10
	RGB 21, 13, 3
	RGB 0, 0, 0

HitmonchanBillboardBGPalette1: ; 0xdc3a0
	RGB 31, 31, 31
	RGB 31, 21, 13
	RGB 23, 3, 3
HitmonchanBillboardBGPalette2: ; 0xdc3a8
	RGB 3, 2, 0
	RGB 31, 31, 31
	RGB 31, 21, 13
	RGB 22, 3, 25
	RGB 0, 0, 0

LickitungBillboardBGPalette1: ; 0xdc3b0
	RGB 31, 31, 31
	RGB 31, 21, 21
	RGB 31, 9, 8
LickitungBillboardBGPalette2: ; 0xdc3b8
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 31, 20, 12
	RGB 31, 9, 8
	RGB 0, 0, 0

KoffingBillboardBGPalette1: ; 0xdc3c0
	RGB 31, 31, 31
	RGB 21, 13, 28
	RGB 10, 7, 14
KoffingBillboardBGPalette2: ; 0xdc3c8
	RGB 3, 2, 0
	RGB 31, 31, 31
	RGB 21, 13, 28
	RGB 21, 4, 7
	RGB 0, 0, 0

WeezingBillboardBGPalette1: ; 0xdc3d0
	RGB 31, 31, 31
	RGB 21, 13, 28
	RGB 10, 7, 14
WeezingBillboardBGPalette2: ; 0xdc3d8
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 21, 13, 28
	RGB 21, 4, 7
	RGB 3, 2, 0

RhyhornBillboardBGPalette1: ; 0xdc3e0
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 11, 16
RhyhornBillboardBGPalette2: ; 0xdc3e8
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 11, 16
	RGB 0, 0, 0

RhydonBillboardBGPalette1: ; 0xdc3f0
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 11, 16
RhydonBillboardBGPalette2: ; 0xdc3f8
	RGB 0, 0, 0
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 13, 11, 16
	RGB 0, 0, 0

MagnemiteBillboardBGPalette1: ; 0xdc400
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0
MagnemiteBillboardBGPalette2: ; 0xdc408
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 31, 0, 0
	RGB 0, 0, 0

MagnetonBillboardBGPalette1: ; 0xdc410
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0
MagnetonBillboardBGPalette2: ; 0xdc418
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0

FarfetchdBillboardBGPalette1: ; 0xdc420
	RGB 31, 31, 31
	RGB 31, 29, 13
	RGB 20, 12, 9
	RGB 0, 0, 0
FarfetchdBillboardBGPalette2: ; 0xdc428
	RGB 31, 31, 31
	RGB 21, 31, 17
	RGB 7, 20, 6
	RGB 0, 0, 0

DoduoBillboardBGPalette1: ; 0xdc430
	RGB 31, 31, 31
	RGB 29, 26, 14
	RGB 26, 16, 4
	RGB 0, 0, 0
DoduoBillboardBGPalette2: ; 0xdc438
	RGB 31, 31, 31
	RGB 29, 26, 14
	RGB 26, 16, 4
	RGB 0, 0, 0

DodrioBillboardBGPalette1: ; 0xdc440
	RGB 31, 31, 31
	RGB 29, 26, 14
	RGB 26, 16, 4
	RGB 0, 0, 0
DodrioBillboardBGPalette2: ; 0xdc448
	RGB 31, 31, 31
	RGB 29, 26, 14
	RGB 26, 16, 4
	RGB 0, 0, 0

SeelBillboardBGPalette1: ; 0xdc450
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0
SeelBillboardBGPalette2: ; 0xdc458
	RGB 31, 31, 31
	RGB 29, 26, 14
	RGB 31, 11, 10
	RGB 0, 0, 0

DewgongBillboardBGPalette1: ; 0xdc460
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0
DewgongBillboardBGPalette2: ; 0xdc468
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0

GrimerBillboardBGPalette1: ; 0xdc470
	RGB 31, 31, 31
	RGB 27, 18, 30
	RGB 15, 7, 19
	RGB 0, 0, 0
GrimerBillboardBGPalette2: ; 0xdc478
	RGB 31, 31, 31
	RGB 27, 18, 30
	RGB 15, 7, 19
	RGB 0, 0, 0

MukBillboardBGPalette1: ; 0xdc480
	RGB 31, 31, 31
	RGB 27, 18, 30
	RGB 15, 7, 19
	RGB 0, 0, 0
MukBillboardBGPalette2: ; 0xdc488
	RGB 31, 31, 31
	RGB 27, 18, 30
	RGB 15, 7, 19
	RGB 0, 0, 0

ShellderBillboardBGPalette1: ; 0xdc490
	RGB 31, 31, 31
	RGB 24, 21, 25
	RGB 13, 11, 15
	RGB 0, 0, 0
ShellderBillboardBGPalette2: ; 0xdc498
	RGB 31, 31, 31
	RGB 24, 21, 25
	RGB 31, 13, 13
	RGB 0, 0, 0

CloysterBillboardBGPalette1: ; 0xdc4a0
	RGB 31, 31, 31
	RGB 25, 21, 26
	RGB 14, 11, 16
	RGB 0, 0, 0
CloysterBillboardBGPalette2: ; 0xdc4a8
	RGB 31, 31, 31
	RGB 25, 21, 26
	RGB 14, 11, 16
	RGB 0, 0, 0

GastlyBillboardBGPalette1: ; 0xdc4b0
	RGB 31, 31, 31
	RGB 26, 18, 27
	RGB 15, 8, 16
	RGB 0, 0, 0
GastlyBillboardBGPalette2: ; 0xdc4b8
	RGB 31, 31, 31
	RGB 26, 18, 27
	RGB 26, 10, 8
	RGB 0, 0, 0

HaunterBillboardBGPalette1: ; 0xdc4c0
	RGB 31, 31, 31
	RGB 26, 18, 27
	RGB 15, 8, 16
	RGB 0, 0, 0
HaunterBillboardBGPalette2: ; 0xdc4c8
	RGB 31, 31, 31
	RGB 31, 13, 13
	RGB 14, 9, 15
	RGB 0, 0, 0

GengarBillboardBGPalette1: ; 0xdc4d0
	RGB 31, 31, 31
	RGB 18, 21, 23
	RGB 10, 12, 13
	RGB 0, 0, 0
GengarBillboardBGPalette2: ; 0xdc4d8
	RGB 31, 31, 31
	RGB 31, 11, 6
	RGB 10, 12, 13
	RGB 0, 0, 0

OnixBillboardBGPalette1: ; 0xdc4e0
	RGB 31, 31, 31
	RGB 20, 20, 24
	RGB 10, 10, 14
	RGB 0, 0, 0
OnixBillboardBGPalette2: ; 0xdc4e8
	RGB 31, 31, 31
	RGB 20, 20, 24
	RGB 10, 10, 14
	RGB 0, 0, 0

DrowzeeBillboardBGPalette1: ; 0xdc4f0
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 21, 19, 0
	RGB 0, 0, 0
DrowzeeBillboardBGPalette2: ; 0xdc4f8
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 21, 19, 0
	RGB 0, 0, 0

AlakazamBillboardBGPalette1: ; 0xdc500
	RGB 31, 31, 31
	RGB 31, 30, 0
	RGB 19, 11, 6
	RGB 0, 0, 0
AlakazamBillboardBGPalette2: ; 0xdc508
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 19, 11, 6
	RGB 0, 0, 0

MachopBillboardBGPalette1: ; 0xdc510
	RGB 31, 31, 31
	RGB 19, 19, 21
	RGB 12, 12, 13
	RGB 0, 0, 0
MachopBillboardBGPalette2: ; 0xdc518
	RGB 31, 31, 31
	RGB 19, 19, 21
	RGB 31, 0, 0
	RGB 0, 0, 0

MachokeBillboardBGPalette1: ; 0xdc520
	RGB 31, 31, 31
	RGB 18, 18, 22
	RGB 11, 11, 14
	RGB 0, 0, 0
MachokeBillboardBGPalette2: ; 0xdc528
	RGB 31, 31, 31
	RGB 18, 18, 22
	RGB 31, 0, 0
	RGB 0, 0, 0

MachampBillboardBGPalette1: ; 0xdc530
	RGB 31, 31, 31
	RGB 18, 21, 22
	RGB 9, 12, 13
	RGB 0, 0, 0
MachampBillboardBGPalette2: ; 0xdc538
	RGB 31, 31, 31
	RGB 18, 21, 22
	RGB 31, 0, 0
	RGB 0, 0, 0

BellsproutBillboardBGPalette1: ; 0xdc540
	RGB 31, 31, 31
	RGB 26, 29, 7
	RGB 11, 20, 0
	RGB 0, 0, 0
BellsproutBillboardBGPalette2: ; 0xdc548
	RGB 31, 31, 31
	RGB 26, 29, 7
	RGB 31, 11, 8
	RGB 0, 0, 0

WeepinbellBillboardBGPalette1: ; 0xdc550
	RGB 31, 31, 31
	RGB 26, 29, 7
	RGB 11, 20, 0
	RGB 0, 0, 0
WeepinbellBillboardBGPalette2: ; 0xdc558
	RGB 31, 31, 31
	RGB 26, 29, 7
	RGB 31, 11, 8
	RGB 0, 0, 0

VictreebellBillboardBGPalette1: ; 0xdc560
	RGB 31, 31, 31
	RGB 29, 31, 9
	RGB 11, 20, 0
	RGB 0, 0, 0
VictreebellBillboardBGPalette2: ; 0xdc568
	RGB 31, 31, 31
	RGB 29, 31, 9
	RGB 31, 11, 8
	RGB 0, 0, 0

TentacoolBillboardBGPalette1: ; 0xdc570
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 0, 11, 22
	RGB 0, 0, 0
TentacoolBillboardBGPalette2: ; 0xdc578
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 31, 5, 6
	RGB 0, 0, 0

TentacruelBillboardBGPalette1: ; 0xdc580
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 0, 11, 22
	RGB 0, 0, 0
TentacruelBillboardBGPalette2: ; 0xdc588
	RGB 31, 31, 31
	RGB 16, 22, 31
	RGB 31, 5, 6
	RGB 0, 0, 0

GeodudeBillboardBGPalette1: ; 0xdc590
	RGB 31, 31, 31
	RGB 20, 23, 22
	RGB 10, 13, 12
	RGB 0, 0, 0
GeodudeBillboardBGPalette2: ; 0xdc598
	RGB 31, 31, 31
	RGB 20, 23, 22
	RGB 10, 13, 12
	RGB 0, 0, 0

GravelerBillboardBGPalette1: ; 0xdc5a0
	RGB 31, 31, 31
	RGB 20, 23, 22
	RGB 10, 13, 12
	RGB 0, 0, 0
GravelerBillboardBGPalette2: ; 0xdc5a8
	RGB 31, 31, 31
	RGB 20, 23, 22
	RGB 10, 13, 12
	RGB 0, 0, 0

GolemBillboardBGPalette1: ; 0xdc5b0
	RGB 31, 31, 31
	RGB 26, 25, 15
	RGB 10, 13, 12
	RGB 0, 0, 0
GolemBillboardBGPalette2: ; 0xdc5b8
	RGB 31, 31, 31
	RGB 26, 25, 15
	RGB 31, 0, 0
	RGB 0, 0, 0

PonytaBillboardBGPalette1: ; 0xdc5c0
	RGB 31, 31, 31
	RGB 27, 26, 11
	RGB 31, 0, 0
	RGB 0, 0, 0
PonytaBillboardBGPalette2: ; 0xdc5c8
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 31, 0, 0
	RGB 0, 0, 0

RapidashBillboardBGPalette1: ; 0xdc5d0
	RGB 31, 31, 31
	RGB 27, 26, 11
	RGB 31, 0, 0
	RGB 0, 0, 0
RapidashBillboardBGPalette2: ; 0xdc5d8
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 31, 0, 0
	RGB 0, 0, 0

SlowpokeBillboardBGPalette1: ; 0xdc5e0
	RGB 31, 31, 31
	RGB 31, 21, 21
	RGB 31, 11, 11
	RGB 0, 0, 0
SlowpokeBillboardBGPalette2: ; 0xdc5e8
	RGB 31, 31, 31
	RGB 31, 27, 15
	RGB 31, 11, 11
	RGB 0, 0, 0

SlowbroBillboardBGPalette1: ; 0xdc5f0
	RGB 31, 31, 31
	RGB 31, 27, 15
	RGB 31, 11, 11
	RGB 0, 0, 0
SlowbroBillboardBGPalette2: ; 0xdc5f8
	RGB 31, 31, 31
	RGB 23, 23, 23
	RGB 12, 12, 12
	RGB 0, 0, 0

StageMeowthBonusCollisionMasks: ; 0xdc600
	INCBIN "data/collision/masks/meowth_bonus.masks"

ZapdosBillboardBGPalette1: ; 0xdc700
	RGB 31, 31, 31
	RGB 29, 27, 0
	RGB 20, 6, 0
	RGB 0, 0, 0
ZapdosBillboardBGPalette2: ; 0xdc708
	RGB 31, 31, 31
	RGB 29, 27, 0
	RGB 20, 6, 0
	RGB 0, 0, 0

MoltresBillboardBGPalette1: ; 0xdc710
	RGB 31, 31, 31
	RGB 30, 25, 0
	RGB 30, 6, 0
	RGB 0, 0, 0
MoltresBillboardBGPalette2: ; 0xdc718
	RGB 31, 31, 31
	RGB 30, 25, 0
	RGB 30, 6, 0
	RGB 0, 0, 0

DratiniBillboardBGPalette1: ; 0xdc720
	RGB 31, 31, 31
	RGB 17, 19, 24
	RGB 6, 11, 15
	RGB 0, 0, 0
DratiniBillboardBGPalette2: ; 0xdc728
	RGB 31, 31, 31
	RGB 17, 19, 24
	RGB 6, 11, 15
	RGB 0, 0, 0

DragonairBillboardBGPalette1: ; 0xdc730
	RGB 31, 31, 31
	RGB 9, 19, 30
	RGB 2, 4, 26
	RGB 0, 0, 0
DragonairBillboardBGPalette2: ; 0xdc738
	RGB 31, 31, 31
	RGB 9, 19, 30
	RGB 2, 4, 26
	RGB 0, 0, 0

DragoniteBillboardBGPalette1: ; 0xdc740
	RGB 31, 31, 31
	RGB 31, 23, 7
	RGB 27, 11, 0
	RGB 0, 0, 0
DragoniteBillboardBGPalette2: ; 0xdc748
	RGB 31, 31, 31
	RGB 13, 22, 16
	RGB 27, 11, 0
	RGB 0, 0, 0

MewtwoBillboardBGPalette1: ; 0xdc750
	RGB 31, 31, 31
	RGB 28, 23, 28
	RGB 13, 7, 20
	RGB 0, 0, 0
MewtwoBillboardBGPalette2: ; 0xdc758
	RGB 31, 31, 31
	RGB 28, 23, 28
	RGB 20, 5, 18
	RGB 0, 0, 0

MewBillboardBGPalette1: ; 0xdc760
	RGB 31, 31, 31
	RGB 31, 18, 24
	RGB 31, 7, 12
	RGB 0, 0, 0
MewBillboardBGPalette2: ; 0xdc768
	RGB 31, 31, 31
	RGB 31, 18, 24
	RGB 0, 10, 31
	RGB 0, 0, 0
	dr $dc770, $dc880

SeelBonusPalettes: ; 0xdc880
SeelBonusBGPalette0: ; 0xdc880
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
SeelBonusBGPalette1: ; 0xdc888
	RGB 31, 31, 31
	RGB 30, 24, 4
	RGB 27, 7, 0
	RGB 0, 0, 0
SeelBonusBGPalette2: ; 0xdc890
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
SeelBonusBGPalette3: ; 0xdc898
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusBGPalette4: ; 0xdc8a0
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusBGPalette5: ; 0xdc8a8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusBGPalette6: ; 0xdc8b0
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusBGPalette7: ; 0xdc8b8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

SeelBonusOBJPalette0: ; 0xdc8c0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
SeelBonusOBJPalette1: ; 0xdc8c8
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 31, 11, 10
	RGB 0, 0, 0
SeelBonusOBJPalette2: ; 0xdc8d0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
SeelBonusOBJPalette3: ; 0xdc8d8
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 11, 11, 20
	RGB 0, 0, 0
SeelBonusOBJPalette4: ; 0xdc8e0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusOBJPalette5: ; 0xdc8e8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusOBJPalette6: ; 0xdc8f0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
SeelBonusOBJPalette7: ; 0xdc8f8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
	dr $dc900, $dc980

StageRedFieldTopPalettes: ; 0xdc980
StageRedFieldTopBGPalette0: ; 0xdc980
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
StageRedFieldTopBGPalette1: ; 0xdc988
	RGB 31, 31, 31
	RGB 24, 31, 0
	RGB 31, 0, 0
	RGB 3, 0, 0
StageRedFieldTopBGPalette2: ; 0xdc990
	RGB 31, 31, 31
	RGB 11, 25, 31
	RGB 0, 11, 31
	RGB 0, 0, 0
StageRedFieldTopBGPalette3: ; 0xdc998
	RGB 31, 31, 31
	RGB 31, 13, 13
	RGB 31, 0, 0
	RGB 0, 0, 0
StageRedFieldTopBGPalette4: ; 0xdc9a0
	RGB 31, 31, 31
	RGB 31, 0, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
StageRedFieldTopBGPalette5: ; 0xdc9a8
	RGB 24, 31, 0
	RGB 31, 0, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
StageRedFieldTopBGPalette6: ; 0xdc9b0
	RGB 31, 31, 31
	RGB 13, 13, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
StageRedFieldTopBGPalette7: ; 0xdc9b8
	RGB 31, 31, 31
	RGB 31, 13, 13
	RGB 31, 0, 0
	RGB 0, 0, 0

StageRedFieldTopOBJPalette0: ; 0xdc9c0
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
StageRedFieldTopOBJPalette1: ; 0xdc9c8
	RGB 31, 31, 31
	RGB 31, 19, 22
	RGB 21, 0, 0
	RGB 4, 0, 0
StageRedFieldTopOBJPalette2: ; 0xdc9d0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 0, 31
	RGB 0, 0, 0
StageRedFieldTopOBJPalette3: ; 0xdc9d8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 22, 0
	RGB 10, 4, 0
StageRedFieldTopOBJPalette4: ; 0xdc9e0
	RGB 20, 20, 20
	RGB 18, 31, 18
	RGB 5, 19, 0
	RGB 0, 7, 0
StageRedFieldTopOBJPalette5: ; 0xdc9e8
	RGB 31, 31, 31
	RGB 31, 20, 0
	RGB 31, 15, 16
	RGB 5, 2, 0
StageRedFieldTopOBJPalette6: ; 0xdc9f0
	RGB 20, 20, 20
	RGB 0, 31, 25
	RGB 0, 18, 14
	RGB 0, 0, 0
StageRedFieldTopOBJPalette7: ; 0xdc9f8
	RGB 31, 31, 31
	RGB 31, 15, 13
	RGB 21, 0, 0
	RGB 4, 0, 0

DiglettBonusPalettes: ; 0xdca00
DiglettBonusBGPalette0: ; 0xdca00
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
DiglettBonusBGPalette1: ; 0xdca08
	RGB 31, 31, 31
	RGB 10, 24, 20
	RGB 5, 13, 10
	RGB 0, 0, 0
DiglettBonusBGPalette2: ; 0xdca10
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
DiglettBonusBGPalette3: ; 0xdca18
	RGB 31, 31, 31
	RGB 31, 18, 8
	RGB 27, 0, 0
	RGB 0, 0, 0
DiglettBonusBGPalette4: ; 0xdca20
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusBGPalette5: ; 0xdca28
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusBGPalette6: ; 0xdca30
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusBGPalette7: ; 0xdca38
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

DiglettBonusOBJPalette0: ; 0xdca40
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
DiglettBonusOBJPalette1: ; 0xdca48
	RGB 31, 31, 31
	RGB 31, 18, 8
	RGB 27, 0, 0
	RGB 0, 0, 0
DiglettBonusOBJPalette2: ; 0xdca50
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
DiglettBonusOBJPalette3: ; 0xdca58
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusOBJPalette4: ; 0xdca60
	RGB 20, 20, 20
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusOBJPalette5: ; 0xdca68
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusOBJPalette6: ; 0xdca70
	RGB 20, 20, 20
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
DiglettBonusOBJPalette7: ; 0xdca78
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

StageRedFieldBottomPalettes: ; 0xdca80
StageRedFieldBottomBGPalette0: ; 0xdca80
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
StageRedFieldBottomBGPalette1: ; 0xdca88
	RGB 31, 31, 31
	RGB 24, 31, 0
	RGB 31, 0, 0
	RGB 3, 0, 0
StageRedFieldBottomBGPalette2: ; 0xdca90
	RGB 31, 31, 31
	RGB 11, 25, 31
	RGB 0, 11, 31
	RGB 0, 0, 0
StageRedFieldBottomBGPalette3: ; 0xdca98
	RGB 31, 31, 31
	RGB 31, 13, 13
	RGB 31, 0, 0
	RGB 0, 0, 0
StageRedFieldBottomBGPalette4: ; 0xdcaa0
	RGB 31, 31, 31
	RGB 31, 0, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
StageRedFieldBottomBGPalette5: ; 0xdcaa8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
StageRedFieldBottomBGPalette6: ; 0xdcab0
	RGB 29, 30, 31
	RGB 27, 20, 10
	RGB 2, 16, 1
	RGB 0, 0, 0
StageRedFieldBottomBGPalette7: ; 0xdcab8
	RGB 29, 30, 31
	RGB 5, 17, 31
	RGB 26, 3, 1
	RGB 0, 0, 0

StageRedFieldBottomOBJPalette0: ; 0xdcac0
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette1: ; 0xdcac8
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 27, 21, 0
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette2: ; 0xdcad0
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette3: ; 0xdcad8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette4: ; 0xdcae0
	RGB 21, 21, 21
	RGB 31, 28, 0
	RGB 29, 0, 0
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette5: ; 0xdcae8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette6: ; 0xdcaf0
	RGB 20, 20, 20
	RGB 0, 31, 25
	RGB 0, 18, 14
	RGB 0, 0, 0
StageRedFieldBottomOBJPalette7: ; 0xdcaf8
	RGB 31, 31, 31
	RGB 31, 30, 16
	RGB 27, 24, 8
	RGB 23, 19, 3

StageBlueFieldTopPalettes:  ; 0xdcb00
StageBlueFieldTopBGPalette0: ; 0xdcb00
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
StageBlueFieldTopBGPalette1: ; 0xdcb08
	RGB 31, 31, 31
	RGB 11, 25, 31
	RGB 0, 11, 31
	RGB 0, 0, 0
StageBlueFieldTopBGPalette2: ; 0xdcb10
	RGB 31, 31, 31
	RGB 4, 23, 13
	RGB 0, 13, 4
	RGB 0, 0, 0
StageBlueFieldTopBGPalette3: ; 0xdcb18
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 15, 8, 0
	RGB 0, 0, 0
StageBlueFieldTopBGPalette4: ; 0xdcb20
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
StageBlueFieldTopBGPalette5: ; 0xdcb28
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
StageBlueFieldTopBGPalette6: ; 0xdcb30
	RGB 31, 31, 31
	RGB 13, 13, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
StageBlueFieldTopBGPalette7: ; 0xdcb38
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

StageBlueFieldTopOBJPalette0: ; 0xdcb40
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
StageBlueFieldTopOBJPalette1: ; 0xdcb48
	RGB 31, 31, 31
	RGB 31, 13, 15
	RGB 23, 4, 6
	RGB 0, 0, 0
StageBlueFieldTopOBJPalette2: ; 0xdcb50
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 31, 26, 0
	RGB 10, 6, 0
StageBlueFieldTopOBJPalette3: ; 0xdcb58
	RGB 31, 31, 31
	RGB 24, 22, 26
	RGB 12, 10, 14
	RGB 0, 0, 0
StageBlueFieldTopOBJPalette4: ; 0xdcb60
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
StageBlueFieldTopOBJPalette5: ; 0xdcb68
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
StageBlueFieldTopOBJPalette6: ; 0xdcb70
	RGB 21, 21, 21
	RGB 0, 31, 25
	RGB 0, 18, 14
	RGB 0, 0, 0
StageBlueFieldTopOBJPalette7: ; 0xdcb78
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0

StageBlueFieldBottomPalettes: ; 0xdcb80
StageBlueFieldBottomBGPalette0: ; 0xdcb80
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette1: ; 0xdcb88
	RGB 31, 31, 31
	RGB 11, 25, 31
	RGB 0, 11, 31
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette2: ; 0xdcb90
	RGB 31, 31, 31
	RGB 4, 23, 13
	RGB 0, 13, 4
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette3: ; 0xdcb98
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 15, 8, 0
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette4: ; 0xdcba0
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette5: ; 0xdcba8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette6: ; 0xdcbb0
	RGB 31, 31, 31
	RGB 15, 20, 31
	RGB 7, 11, 21
	RGB 0, 0, 0
StageBlueFieldBottomBGPalette7: ; 0xdcbb8
	RGB 31, 31, 31
	RGB 27, 20, 10
	RGB 24, 7, 5
	RGB 0, 0, 0

StageBlueFieldBottomOBJPalette0: ; 0xdcbc0
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette1: ; 0xdcbc8
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 27, 21, 0
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette2: ; 0xdcbd0
	RGB 21, 21, 21
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette3: ; 0xdcbd8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette4: ; 0xdcbe0
	RGB 21, 21, 21
	RGB 31, 28, 0
	RGB 29, 0, 0
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette5: ; 0xdcbe8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette6: ; 0xdcbf0
	RGB 21, 21, 21
	RGB 0, 31, 25
	RGB 0, 18, 14
	RGB 0, 0, 0
StageBlueFieldBottomOBJPalette7: ; 0xdcbf8
	RGB 31, 31, 31
	RGB 31, 30, 16
	RGB 27, 24, 8
	RGB 23, 19, 3

PaletteData_dcc00:  ; 0xdcc00
	RGB 31, 31, 31
	RGB 31, 28, 0
	RGB 0, 11, 31
	RGB 0, 0, 0
PaletteData_dcc08:  ; 0xdcc08
	RGB 31, 31, 31
	RGB 31, 28, 0
	RGB 29, 0, 0
	RGB 0, 0, 0
PaletteData_dcc10:  ; 0xdcc10
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
PaletteData_dcc18:  ; 0xdcc18
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 15, 8, 0
	RGB 0, 0, 0
PaletteData_dcc20:  ; 0xdcc20
	RGB 31, 31, 31
	RGB 4, 23, 13
	RGB 29, 0, 0
	RGB 0, 0, 0
PaletteData_dcc28:  ; 0xdcc28
	RGB 31, 31, 31
	RGB 29, 0, 0
	RGB 0, 0, 22
	RGB 0, 0, 0
PaletteData_dcc30:  ; 0xdcc30
	RGB 31, 31, 31
	RGB 31, 0, 15
	RGB 11, 0, 13
	RGB 0, 0, 0
PaletteData_dcc38:  ; 0xdcc38
	RGB 31, 31, 31
	RGB 11, 25, 31
	RGB 0, 11, 31
	RGB 0, 0, 0
PaletteData_dcc40:  ; 0xdcc40
	RGB 31, 31, 31
	RGB 15, 15, 19
	RGB 31, 0, 31
	RGB 0, 0, 0
PaletteData_dcc48:  ; 0xdcc48
	RGB 31, 31, 31
	RGB 31, 25, 31
	RGB 31, 0, 31
	RGB 0, 0, 0
PaletteData_dcc50:  ; 0xdcc50
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 27, 11, 2
	RGB 0, 0, 0
PaletteData_dcc58:  ; 0xdcc58
	RGB 31, 31, 31
	RGB 31, 18, 8
	RGB 27, 0, 0
	RGB 0, 0, 0
PaletteData_dcc60:  ; 0xdcc60
	RGB 31, 31, 31
	RGB 20, 20, 26
	RGB 31, 11, 10
	RGB 0, 0, 0
	dr $dcc68, $dcc80

MeowthBonusPalettes: ; 0xdcc80
MeowthBonusBGPalette0: ; 0xdcc80
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
MeowthBonusBGPalette1: ; 0xdcc88
	RGB 31, 31, 31
	RGB 31, 16, 0
	RGB 15, 7, 0
	RGB 0, 0, 0
MeowthBonusBGPalette2: ; 0xdcc90
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
MeowthBonusBGPalette3: ; 0xdcc98
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusBGPalette4: ; 0xdcca0
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusBGPalette5: ; 0xdcca8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusBGPalette6: ; 0xdccb0
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusBGPalette7: ; 0xdccb8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

MeowthBonusOBJPalette0: ; 0xdccc0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
MeowthBonusOBJPalette1: ; 0xdccc8
	RGB 31, 31, 31
	RGB 31, 26, 16
	RGB 25, 9, 0
	RGB 0, 0, 0
MeowthBonusOBJPalette2: ; 0xdccd0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
MeowthBonusOBJPalette3: ; 0xdccd8
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 23, 7, 0
	RGB 0, 0, 0
MeowthBonusOBJPalette4: ; 0xdcce0
	RGB 20, 20, 20
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusOBJPalette5: ; 0xdcce8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusOBJPalette6: ; 0xdccf0
	RGB 20, 20, 20
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MeowthBonusOBJPalette7: ; 0xdccf8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

HighScoresBlueStagePalettes: ; 0xdcd00
HighScoresBlueStageBGPalette0: ; 0xdcd00
	RGB 31, 31, 31
	RGB 23, 23, 23
	RGB 14, 14, 14
	RGB 5, 5, 5
HighScoresBlueStageBGPalette1: ; 0xdcd08
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 9, 9, 27
	RGB 0, 0, 0
HighScoresBlueStageBGPalette2: ; 0xdcd10
	RGB 31, 31, 31
	RGB 31, 8, 0
	RGB 9, 9, 27
	RGB 0, 0, 0
HighScoresBlueStageBGPalette3: ; 0xdcd18
	RGB 31, 31, 31
	RGB 31, 16, 0
	RGB 9, 9, 27
	RGB 0, 0, 0
HighScoresBlueStageBGPalette4: ; 0xdcd20
	RGB 31, 31, 31
	RGB 31, 24, 0
	RGB 9, 9, 27
	RGB 0, 0, 0
HighScoresBlueStageBGPalette5: ; 0xdcd28
	RGB 31, 31, 31
	RGB 31, 31, 0
	RGB 9, 9, 27
	RGB 0, 0, 0
HighScoresBlueStageBGPalette6: ; 0xdcd30
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresBlueStageBGPalette7: ; 0xdcd38
	RGB 31, 29, 4
	RGB 29, 18, 0
	RGB 31, 0, 0
	RGB 5, 5, 5

HighScoresBlueStageOBJPalette0: ; 0xdcd40
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 9, 9, 27
	RGB 0, 0, 0
HighScoresBlueStageOBJPalette1: ; 0xdcd48
	RGB 31, 31, 31
	RGB 31, 29, 4
	RGB 29, 18, 0
	RGB 0, 0, 0
HighScoresBlueStageOBJPalette2: ; 0xdcd50
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 14, 14, 14
	RGB 5, 5, 5
HighScoresBlueStageOBJPalette3: ; 0xdcd58
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresBlueStageOBJPalette4: ; 0xdcd60
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 31, 31, 31
	RGB 0, 0, 0
HighScoresBlueStageOBJPalette5: ; 0xdcd68
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresBlueStageOBJPalette6: ; 0xdcd70
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresBlueStageOBJPalette7: ; 0xdcd88
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

HighScoresRedStagePalettes: ; 0xdcd80
HighScoresRedStageBGPalette0: ; 0xdcd80
	RGB 31, 31, 31
	RGB 23, 23, 23
	RGB 14, 14, 14
	RGB 5, 5, 5
HighScoresRedStageBGPalette1: ; 0xdcd88
	RGB 31, 31, 31
	RGB 0, 0, 31
	RGB 31, 6, 6
	RGB 0, 0, 0
HighScoresRedStageBGPalette2: ; 0xdcd90
	RGB 31, 31, 31
	RGB 0, 8, 31
	RGB 31, 6, 6
	RGB 0, 0, 0
HighScoresRedStageBGPalette3: ; 0xdcd98
	RGB 31, 31, 31
	RGB 0, 16, 31
	RGB 31, 6, 6
	RGB 0, 0, 0
HighScoresRedStageBGPalette4: ; 0xdcda0
	RGB 31, 31, 31
	RGB 0, 24, 31
	RGB 31, 6, 6
	RGB 0, 0, 0
HighScoresRedStageBGPalette5: ; 0xdcda8
	RGB 31, 31, 31
	RGB 0, 31, 31
	RGB 31, 6, 6
	RGB 0, 0, 0
HighScoresRedStageBGPalette6: ; 0xdcdb0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresRedStageBGPalette7: ; 0xdcdb8
	RGB 31, 29, 4
	RGB 29, 18, 0
	RGB 31, 0, 0
	RGB 5, 5, 5

HighScoresRedStageOBJPalette0: ; 0xdcdc0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 6, 6
	RGB 0, 0, 0
HighScoresRedStageOBJPalette1: ; 0xdcdc8
	RGB 31, 31, 31
	RGB 31, 29, 4
	RGB 29, 18, 0
	RGB 0, 0, 0
HighScoresRedStageOBJPalette2: ; 0xdcdd0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 14, 14, 14
	RGB 5, 5, 5
HighScoresRedStageOBJPalette3: ; 0xdcdd8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresRedStageOBJPalette4: ; 0xdcde0
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 31, 31, 31
	RGB 0, 0, 0
HighScoresRedStageOBJPalette5: ; 0xdcde8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresRedStageOBJPalette6: ; 0xdcdf0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
HighScoresRedStageOBJPalette7: ; 0xdcdf8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

OptionMenuPalettes: ; 0xdce00
OptionMenuBGPalette0: ; 0xdce00
	RGB 31, 31, 31
	RGB 31, 30, 9
	RGB 22, 21, 0
	RGB 0, 0, 0
OptionMenuBGPalette1: ; 0xdce08
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 31, 8, 0
	RGB 0, 0, 0
OptionMenuBGPalette2: ; 0xdce10
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 26, 18, 0
	RGB 0, 0, 0
OptionMenuBGPalette3: ; 0xdce18
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 22, 10, 0
	RGB 0, 0, 0
OptionMenuBGPalette4: ; 0xdce20
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
OptionMenuBGPalette5: ; 0xdce28
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
OptionMenuBGPalette6: ; 0xdce30
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
OptionMenuBGPalette7: ; 0xdce38
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

OptionMenuOBJPalette0: ; 0xdce40
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 31, 8, 0
	RGB 0, 0, 0
OptionMenuOBJPalette1: ; 0xdce48
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 0, 0, 0
OptionMenuOBJPalette2: ; 0xdce50
	RGB 31, 31, 31
	RGB 31, 31, 11
	RGB 26, 23, 0
	RGB 0, 0, 0
OptionMenuOBJPalette3: ; 0xdce58
	RGB 31, 31, 31
	RGB 22, 22, 22
	RGB 11, 11, 11
	RGB 0, 0, 0
OptionMenuOBJPalette4: ; 0xdce60
	RGB 31, 31, 31
	RGB 23, 23, 27
	RGB 31, 0, 0
	RGB 0, 0, 0
OptionMenuOBJPalette5: ; 0xdce68
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
OptionMenuOBJPalette6: ; 0xdce70
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
OptionMenuOBJPalette7: ; 0xdce78
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

Data_dce80:
	dr $dce80, $dcf00

MewtwoBonusPalettes: ; 0xdcf00
MewtwoBonusBGPalette0: ; 0xdcf00
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
MewtwoBonusBGPalette1: ; 0xdcf08
	RGB 31, 31, 31
	RGB 15, 15, 21
	RGB 6, 6, 11
	RGB 0, 0, 0
MewtwoBonusBGPalette2: ; 0xdcf10
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 16, 0, 0
	RGB 0, 0, 0
MewtwoBonusBGPalette3: ; 0xdcf18
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusBGPalette4: ; 0xdcf20
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusBGPalette5: ; 0xdcf28
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusBGPalette6: ; 0xdcf30
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusBGPalette7: ; 0xdcf38
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

MewtwoBonusOBJPalette0: ; 0xdcf40
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
MewtwoBonusOBJPalette1: ; 0xdcf48
	RGB 31, 31, 31
	RGB 24, 19, 0
	RGB 13, 8, 0
	RGB 0, 0, 0
MewtwoBonusOBJPalette2: ; 0xdcf50
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
MewtwoBonusOBJPalette3: ; 0xdcf58
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusOBJPalette4: ; 0xdcf60
	RGB 20, 20, 20
	RGB 31, 25, 31
	RGB 31, 0, 31
	RGB 0, 0, 0
MewtwoBonusOBJPalette5: ; 0xdcf68
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusOBJPalette6: ; 0xdcf70
	RGB 20, 20, 20
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
MewtwoBonusOBJPalette7: ; 0xdcf78
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

TitlescreenPalettes: ; 0xdcf80
TitlescreenBGPalette0: ; 0xdcf80
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 31, 0, 0
	RGB 0, 0, 0
TitlescreenBGPalette1: ; 0xdcf88
	RGB 31, 31, 31
	RGB 0, 12, 26
	RGB 31, 0, 0
	RGB 0, 0, 0
TitlescreenBGPalette2: ; 0xdcf90
	RGB 31, 31, 31
	RGB 23, 31, 24
	RGB 31, 0, 0
	RGB 0, 0, 0
TitlescreenBGPalette3: ; 0xdcf98
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 0, 12, 26
	RGB 0, 0, 0
TitlescreenBGPalette4: ; 0xdcfa0
	RGB 31, 31, 31
	RGB 20, 20, 31
	RGB 0, 12, 26
	RGB 0, 0, 0
TitlescreenBGPalette5: ; 0xdcfa8
	RGB 31, 31, 31
	RGB 23, 31, 24
	RGB 0, 12, 26
	RGB 0, 0, 0
TitlescreenBGPalette6: ; 0xdcfb0
	RGB 31, 31, 31
	RGB 20, 20, 31
	RGB 23, 31, 24
	RGB 0, 0, 0
TitlescreenBGPalette7: ; 0xdcfb8
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0

TitlescreenOBJPalette0: ; 0xdcfc0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 29, 0
	RGB 0, 0, 0
TitlescreenOBJPalette1: ; 0xdcfc8
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
TitlescreenOBJPalette2: ; 0xdcfd0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 23, 23, 27
	RGB 0, 0, 0
TitlescreenOBJPalette3: ; 0xdcfd8
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
TitlescreenOBJPalette4: ; 0xdcfe0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
TitlescreenOBJPalette5: ; 0xdcfe8
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
TitlescreenOBJPalette6: ; 0xdcff0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
TitlescreenOBJPalette7: ; 0xdcff8
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0
	RGB 0, 6, 0

CopyrightScreenPalettes: ; 0xdd000
CopyrightScreenBGPalette0: ; 0xdd000
	RGB 31, 31, 31
	RGB 22, 22, 22
	RGB 11, 11, 11
	RGB 0, 0, 0
CopyrightScreenBGPalette1: ; 0xdd008
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenBGPalette2: ; 0xdd010
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenBGPalette3: ; 0xdd018
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenBGPalette4: ; 0xdd020
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenBGPalette5: ; 0xdd028
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenBGPalette6: ; 0xdd030
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenBGPalette7: ; 0xdd038
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

CopyrightScreenOBJPalette0: ; 0xdd040
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 22, 22, 22
	RGB 0, 0, 0
CopyrightScreenOBJPalette1: ; 0xdd048
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 11, 11, 11
	RGB 0, 0, 0
CopyrightScreenOBJPalette2: ; 0xdd050
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenOBJPalette3: ; 0xdd058
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenOBJPalette4: ; 0xdd060
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenOBJPalette5: ; 0xdd068
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenOBJPalette6: ; 0xdd070
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
CopyrightScreenOBJPalette7: ; 0xdd078
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB 31, 31, 31

GengarBonusPalettes: ; 0xdd080
GengarBonusBGPalette0: ; 0xdd080
	RGB 31, 31, 31
	RGB 13, 20, 31
	RGB 31, 4, 4
	RGB 0, 0, 0
GengarBonusBGPalette1: ; 0xdd088
	RGB 28, 31, 4
	RGB 8, 14, 31
	RGB 4, 5, 15
	RGB 0, 0, 0
GengarBonusBGPalette2: ; 0xdd090
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusBGPalette3: ; 0xdd098
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusBGPalette4: ; 0xdd0a0
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusBGPalette5: ; 0xdd0a8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusBGPalette6: ; 0xdd0b0
	RGB 31, 31, 31
	RGB 13, 13, 31
	RGB 31, 0, 0
	RGB 0, 0, 0
GengarBonusBGPalette7: ; 0xdd0b8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

GengarBonusOBJPalette0: ; 0xdd0c0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 31, 5, 4
	RGB 0, 0, 0
GengarBonusOBJPalette1: ; 0xdd0c8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusOBJPalette2: ; 0xdd0d0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 21, 21, 27
	RGB 0, 0, 0
GengarBonusOBJPalette3: ; 0xdd0d8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusOBJPalette4: ; 0xdd0e0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 29, 0, 31
	RGB 0, 0, 0
GengarBonusOBJPalette5: ; 0xdd0e8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusOBJPalette6: ; 0xdd0f0
	RGB 20, 20, 20
	RGB 31, 31, 31
	RGB 8, 8, 8
	RGB 0, 0, 0
GengarBonusOBJPalette7: ; 0xdd0f8
	RGB 31, 31, 31
	RGB 20, 20, 20
	RGB 8, 8, 8
	RGB 0, 0, 0

FieldSelectScreenPalettes: ; 0xdd100
FieldSelectScreenBGPalette0: ; 0xdd100
	RGB 31, 31, 31
	RGB 31, 20, 0
	RGB 31, 0, 0
	RGB 0, 0, 0
FieldSelectScreenBGPalette1: ; 0xdd108
	RGB 31, 31, 31
	RGB 0, 22, 31
	RGB 0, 0, 31
	RGB 0, 0, 0
FieldSelectScreenBGPalette2: ; 0xdd110
	RGB 31, 31, 31
	RGB 31, 0, 0
	RGB 0, 25, 0
	RGB 0, 0, 0
FieldSelectScreenBGPalette3: ; 0xdd118
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
FieldSelectScreenBGPalette4: ; 0xdd120
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
FieldSelectScreenBGPalette5: ; 0xdd128
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
FieldSelectScreenBGPalette6: ; 0xdd130
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
FieldSelectScreenBGPalette7: ; 0xdd138
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31
	RGB 31, 0, 31

FieldSelectScreenOBJPalette0: ; 0xdd140
	RGB 10, 10, 10
	RGB 31, 31, 31
	RGB 21, 21, 21
	RGB 0, 0, 0

CinnabarIslandBillboardBGPalette1: ; 0xdd148
	RGB 31, 31, 31
	RGB 14, 21, 0
	RGB 0, 10, 31
	RGB 0, 0, 0
CinnabarIslandBillboardBGPalette2: ; 0xdd150
	RGB 31, 31, 31
	RGB 14, 21, 0
	RGB 2, 11, 1
	RGB 0, 0, 0

IndigoPlateauBillboardBGPalette1: ; 0xdd158
	RGB 31, 31, 31
	RGB 11, 18, 31
	RGB 7, 9, 19
	RGB 0, 0, 0
IndigoPlateauBillboardBGPalette2: ; 0xdd160
	RGB 31, 31, 31
	RGB 11, 18, 31
	RGB 9, 20, 0
	RGB 0, 0, 0

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
Data_e8000:
	dr $e8000, $e8c00 ; 0xe8000

Data_e8c00:
	dr $e8c00, $e9100 ; 0xe8000

Data_e9100:
	dr $e9100, $e9500 ; 0xe8000

Data_e9500:
	dr $e9500, $e9c80 ; 0xe8000

Data_e9c80:
	dr $e9c80, $ec000 ; 0xe8000

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
	dr $f3800, $f4000 ; 0xf0000

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
