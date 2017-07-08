INCLUDE "charmap.asm"
INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "home.asm"

SECTION "bank1", ROMX

INCLUDE "data/oam_frames.asm"

SECTION "bank2", ROMX

INCLUDE "engine/select_gameboy_target_menu.asm"
INCLUDE "engine/erase_all_data_menu.asm"
INCLUDE "engine/copyright_screen.asm"
INCLUDE "engine/pinball_game/stage_init/init_stages.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_stage_data.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_sprites.asm"

Func_84fd:
; unused?
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

INCLUDE "engine/pinball_game/score.asm"
INCLUDE "engine/pinball_game/timer.asm"
INCLUDE "engine/pinball_game/menu.asm"
INCLUDE "data/collision/collision_deltas.asm"
INCLUDE "engine/pokedex/variable_width_font_character.asm"

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

SECTION "bank2.2", ROMX
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

SECTION "bank3", ROMX

INCLUDE "engine/titlescreen.asm"
INCLUDE "engine/options_screen.asm"
INCLUDE "engine/high_scores_screen.asm"
INCLUDE "engine/field_select_screen.asm"
INCLUDE "engine/pinball_game.asm"
INCLUDE "engine/pinball_game/ball_saver/ball_saver_20.asm"
INCLUDE "engine/pinball_game/ball_saver/ball_saver_catchem_mode.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss.asm"

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
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	ld a, $81
	jr nz, .asm_dcbf
	ld a, $84
.asm_dcbf
	ld [wBottomMessageBuffer + $46], a
	ret

INCLUDE "engine/pinball_game/ball_gfx.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_red_field.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_blue_field.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_gengar_bonus.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_mewtwo_bonus.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_meowth_bonus.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_diglett_bonus.asm"
INCLUDE "engine/pinball_game/ball_loss/ball_loss_seel_bonus.asm"
INCLUDE "engine/pinball_game/flippers.asm"
INCLUDE "engine/pinball_game/stage_collision_attributes.asm"
INCLUDE "engine/pinball_game/vertical_screen_transition.asm"
INCLUDE "engine/pinball_game/slot.asm"
INCLUDE "engine/pinball_game/end_of_ball_bonus.asm"

SECTION "bank4", ROMX

Func_10000: ; 0x10000
	ld c, a
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, c
	ld [wd54c], a
	ld a, [wSpecialMode]
	cp SPECIAL_MODE_CATCHEM
	jp z, Func_10a95
	cp SPECIAL_MODE_EVOLUTION
	jr nz, .next
	callba Func_301ce
	ret

.next
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_10027: ; 0x10027
	padded_dab Func_20000 ; STAGE_RED_FIELD_TOP
	padded_dab Func_20000 ; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_20000
	padded_dab Func_20000
	padded_dab Func_202bc ; STAGE_BLUE_FIELD_TOP
	padded_dab Func_202bc ; STAGE_BLUE_FIELD_BOTTOM

INCLUDE "engine/pinball_game/catchem_mode.asm"

Func_10a95: ; 0x19a95
	ld a, [wCurrentStage]
	call CallInFollowingTable
PointerTable_10a9b: ; 0x10a9b
	padded_dab Func_20581 ; STAGE_RED_FIELD_TOP
	padded_dab Func_20581 ; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_20581
	padded_dab Func_20581
	padded_dab Func_20bae ; STAGE_BLUE_FIELD_TOP
	padded_dab Func_20bae ; STAGE_BLUE_FIELD_BOTTOM

StartEvolutionMode: ; 0x10ab3
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
StartEvolutionMode_CallTable: ; 0x10abc
	dw StartEvolutionMode_RedField ; STAGE_RED_FIELD_TOP
	dw StartEvolutionMode_RedField ; STAGE_RED_FIELD_BOTTOM
	dw StartEvolutionMode_UnusedField
	dw StartEvolutionMode_UnusedField
	dw StartEvolutionMode_BlueField ; STAGE_BLUE_FIELD_TOP
	dw StartEvolutionMode_BlueField ; STAGE_BLUE_FIELD_BOTTOM

ConcludeEvolutionMode: ; 0x10ac8
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
	call ClearWildMonCollisionMask
	callba StopTimer
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
ConcludeEvolutionMode_CallTable: ; 0x10af3
	dw ConcludeEvolutionMode_RedField ; STAGE_RED_FIELD_TOP
	dw ConcludeEvolutionMode_RedField ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_11060
	dw DoNothing_11060
	dw ConcludeEvolutionMode_BlueField ; STAGE_BLUE_FIELD_TOP
	dw ConcludeEvolutionMode_BlueField ; STAGE_BLUE_FIELD_TOP

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

InitEvolutionSelectionMenu: ; 0x10b59
; Initializes the list menu, which the player uses to select which pokemon to evolve.
	xor a
	ld [wDrawBottomMessageBox], a
	ld hl, wBottomMessageText
	ld a, $81
	ld b, $30
.clearLoop
	ld [hli], a ; load spaces into bottom text. repeat 192 times
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .clearLoop
	ld hl, wPartyMons
	call LoadMonNamesIntoEvolutionSelectionList
	ld a, BANK(InGameMenuSymbolsGfx)
	ld hl, InGameMenuSymbolsGfx + $50
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
	ld a, $0
	ld hl, wBottomMessageText
	deCoord 0, 0, vBGWin
	ld bc, $00c0
	call LoadVRAMData
	ret

LoadMonNamesIntoEvolutionSelectionList: ; 0x10b8e
; Loads 6 pokemon names into the list that allows the player to select which pokemon to evolve.
; Input: hl = pointer to a list of pokemon ids. (an offset of wPartyMons)
	ld a, [wNumPartyMons]
	ld c, $0
	ld b, a
.loop
	ld a, [hli]
	call LoadMonNameIntoEvolutionSelectionList
	inc c
	ld a, c
	cp $6
	jr z, .done
	dec b
	jr nz, .loop
.done
	ret

LoadMonNameIntoEvolutionSelectionList: ; 0x10ba2
; Loads a single pokemon name into the list of pokemon to evolve.
; Input: c = index of the list
;        a = pokemon id
	push bc
	push hl
	swap c ;c* 32, does wird things if c starts >15
	sla c
	ld b, $0
	ld hl, wBottomMessageText
	add hl, bc ;goes down text as many times as new c
	ld d, h
	ld e, l
	ld c, a ;c now equals paerty mon, HL stored in de
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ;multiplies party mon by 16, then jumps to correct name in the table
	ld hl, PokemonNames ;names are 16 chars long
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
	ld [de], a ; loaded 4 spaces into de
	inc de
	call LoadMonNameIntoBottomMessageBufferList
.loadBlankCharacterLoop
	ld a, e
	and $1f
	cp $14
	jr nc, .done
	ld a, $81
	ld [de], a
	inc de
	jr .loadBlankCharacterLoop

.done
	pop hl
	pop bc
	ret

SelectPokemonToEvolveMenu: ; 0x10bea
; Drivers the menu that allows the player to select a pokemon to evolve.
	xor a
	ld [wCurSelectedPartyMon], a
	ld [wCurSelectedPartyMonScrollOffset], a
	ld [wPartySelectionCursorCounter], a
.loop
	call MoveEvolutionSelectionCursor
	call ClearPersistentJoypadStates
	call UpdateEvolutionSelectionList
	rst AdvanceFrame
	ld a, [wNewlyPressedButtonsPersistent]
	bit BIT_A_BUTTON, a
	jr z, .loop
	lb de, $00, $01
	call PlaySoundEffect
	ret

MoveEvolutionSelectionCursor: ; 0x10c0c
	ld a, [wPressedButtonsPersistent]
	ld b, a
	ld a, [wNumPartyMons]
	ld c, a
	ld a, [wCurSelectedPartyMon]
	bit BIT_D_UP, b
	jr z, .didntPressUp
	and a
	ret z
	; move the cursor up
	dec a
	ld [wCurSelectedPartyMon], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

.didntPressUp
	bit BIT_D_DOWN, b
	ret z
	inc a
	cp c
	ret z
	; move the cursor down
	ld [wCurSelectedPartyMon], a
	lb de, $00, $03
	call PlaySoundEffect
	ret

UpdateEvolutionSelectionList: ; 0x10c38
	ld a, [wCurSelectedPartyMon]
	ld hl, wCurSelectedPartyMonScrollOffset
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
	call LoadMonNamesIntoEvolutionSelectionList
	ld a, [hJoypadState]
	and a
	ld a, [wPartySelectionCursorCounter]
	jr z, .asm_10c62
	xor a
.asm_10c62
	inc a
	ld [wPartySelectionCursorCounter], a
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
	ld a, [wCurSelectedPartyMonScrollOffset]
	and a
	jr z, .asm_10c83
	ld a, $8a
	ld [wBottomMessageText + $11], a
.asm_10c83
	ld a, [wCurSelectedPartyMonScrollOffset]
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

PlaceEvolutionInParty: ; 0x10ca5
	ld a, [wCurSelectedPartyMon]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [wCurrentEvolutionMon]
	cp $ff
	ret z
	ld [hl], a
	ret

SelectPokemonToEvolve: ; 0x10cb7
	call FillBottomMessageBufferWithBlackTile
	call InitEvolutionSelectionMenu
	ld a, $60
	ld [hWY], a
	dec a
	ld [hLYC], a
	ld a, $fd
	ld [hLCDCMask], a
	call SelectPokemonToEvolveMenu
	ld a, $86
	ld [hWY], a
	ld a, $83
	ld [hLYC], a
	ld [hLastLYC], a
	ld a, $ff
	ld [hLCDCMask], a
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	ld a, BANK(StageRedFieldTopStatusBarSymbolsGfx_GameBoy)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoy + $80
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
	jr .asm_10cfc

.gameboyColor
	ld a, BANK(StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor)
	ld hl, StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor + $80
	ld de, vTilesSH tile $08
	ld bc, $0030
	call LoadVRAMData
.asm_10cfc
	call FillBottomMessageBufferWithBlackTile
	ld a, SPECIAL_MODE_CATCHEM
	ld [wDrawBottomMessageBox], a
	ld [wInSpecialMode], a
	ld [wSpecialMode], a
	xor a
	ld [wd54d], a
	ld a, [wCurSelectedPartyMon]
	ld c, a
	ld b, $0
	ld hl, wPartyMons
	add hl, bc
	ld a, [hl]
	ld [wCurrentCatchEmMon], a
	ret

InitEvolutionModeForMon: ; 0x10d1d
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

StartEvolutionMode_RedField: ; 0x10ebb
	ld a, [wNumPartyMons]
	and a
	ret z
	call SelectPokemonToEvolve
	call InitEvolutionModeForMon
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
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
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
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
	ld de, vTilesSH tile $10
	ld bc, $00e0
	call LoadOrCopyVRAMData
	ret

.asm_10f0b
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
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

ConcludeEvolutionMode_RedField: ; 0x10fe3
	call ResetIndicatorStates
	call Func_107c2
	call Func_107c8
	call Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	jp z, Func_10aff
	callba Func_14135
	callba Func_16425
	callba LoadMapBillboardTileData
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
	ld hl, BlankSaverSpaceTileDataRedField
	ld a, BANK(BlankSaverSpaceTileDataRedField)
	call Func_10aa
	ld a, [wPreviousNumPokeballs]
	callba Func_174d4
	ld hl, CaughtPokeballTileDataPointers
	ld a, BANK(CaughtPokeballTileDataPointers)
	call Func_10aa
	ret

StartEvolutionMode_UnusedField: ; 0x11054
	ld a, [wNumPartyMons]
	and a
	ret z
	call SelectPokemonToEvolve
	call InitEvolutionModeForMon
	ret

DoNothing_11060: ; 0x11060
	ret

StartEvolutionMode_BlueField: ; 0x11061
	ld a, [wNumPartyMons]
	and a
	ret z
	call SelectPokemonToEvolve
	call InitEvolutionModeForMon
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
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
	ld de, vTilesOB tile $60
	ld bc, $00e0
	call LoadOrCopyVRAMData
	ret

.asm_110bd
	ld a, BANK(EvolutionTrinketsGfx)
	ld hl, EvolutionTrinketsGfx
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

ConcludeEvolutionMode_BlueField: ; 0x11195
	xor a
	ld [wd643], a
	call ResetIndicatorStates
	call Func_107c2
	callba Func_1f2ff
	ld a, [wCurrentStage]
	bit 0, a
	jp z, Func_1120e
	callba Func_1c2cb
	callba QueueGraphicsDataToLoad
	callba LoadMapBillboardTileData
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
	ld hl, BlankSaverSpaceTileDataBlueField
	ld a, BANK(BlankSaverSpaceTileDataBlueField)
	call Func_10aa
	ld a, [wPreviousNumPokeballs]
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
; This has to do with which indicators will need to be hit to evolve the pokemon.
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

SECTION "bank5", ROMX

INCLUDE "engine/pinball_game/load_stage_data/load_red_field.asm"
INCLUDE "engine/pinball_game/object_collision/red_stage_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/red_stage_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_red_field_sprites.asm"

SECTION "bank6", ROMX

INCLUDE "engine/pinball_game/stage_init/init_unused_stage.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_unused_stage.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_unused_stage.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_unused_stage_sprites.asm"
INCLUDE "engine/pinball_game/stage_init/init_gengar_bonus.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_gengar_bonus.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_gengar_bonus.asm"
INCLUDE "engine/pinball_game/object_collision/gengar_bonus_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/gengar_bonus_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_gengar_bonus_sprites.asm"
INCLUDE "engine/pinball_game/stage_init/init_mewtwo_bonus.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_mewtwo_bonus.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_mewtwo_bonus.asm"
INCLUDE "engine/pinball_game/object_collision/mewtwo_bonus_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/mewtwo_bonus_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_mewtwo_bonus_sprites.asm"
INCLUDE "engine/pinball_game/stage_init/init_diglett_bonus.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_diglett_bonus.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_diglett_bonus.asm"
INCLUDE "engine/pinball_game/object_collision/diglett_bonus_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/diglett_bonus_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_diglett_bonus_sprites.asm"

SECTION "bank7", ROMX

INCLUDE "engine/pinball_game/stage_init/init_blue_field.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_blue_field.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_blue_field.asm"
INCLUDE "engine/pinball_game/object_collision/blue_stage_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/blue_stage_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_blue_field_sprites.asm"

SECTION "bank8", ROMX

INCLUDE "engine/pinball_game/catchem_mode/catchem_mode_red_field.asm"
INCLUDE "engine/pinball_game/catchem_mode/catchem_mode_blue_field.asm"
INCLUDE "engine/pinball_game/evolution_mode/evolution_mode_red_field.asm"
INCLUDE "engine/pinball_game/evolution_mode/evolution_mode_blue_field.asm"

SECTION "bank9", ROMX

INCLUDE "engine/pinball_game/stage_init/init_meowth_bonus.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_meowth_bonus.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_meowth_bonus.asm"
INCLUDE "engine/pinball_game/object_collision/meowth_bonus_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/meowth_bonus_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_meowth_bonus_sprites.asm"
INCLUDE "engine/pinball_game/stage_init/init_seel_bonus.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_seel_bonus.asm"
INCLUDE "engine/pinball_game/load_stage_data/load_seel_bonus.asm"
INCLUDE "engine/pinball_game/object_collision/seel_bonus_object_collision.asm"
INCLUDE "engine/pinball_game/object_collision/seel_bonus_resolve_collision.asm"
INCLUDE "engine/pinball_game/draw_sprites/draw_seel_bonus_sprites.asm"

SECTION "banka", ROMX

INCLUDE "engine/pokedex.asm"

SECTION "bankb", ROMX

Unknown_2c000: ; 0x2c000
	dex_text " "
	dex_end

INCLUDE "text/pokedex_descriptions.asm"

SECTION "bankc", ROMX

INCLUDE "engine/pinball_game/stage_init/init_red_field.asm"
INCLUDE "engine/pinball_game/ball_init/ball_init_red_field.asm"
INCLUDE "engine/pinball_game/bonus_multiplier.asm"
INCLUDE "engine/pinball_game/extra_ball.asm"

Func_301ce: ; 0x301ce
	ld a, [wCurrentStage]
	call CallInFollowingTable
PointerTable_301d4: ; 0x301d4
	padded_dab Func_314ae ; STAGE_RED_FIELD_TOP
	padded_dab Func_314ae ; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_314ae
	padded_dab Func_314ae
	padded_dab Func_3161b ; STAGE_BLUE_FIELD_TOP
	padded_dab Func_3161b ; STAGE_BLUE_FIELD_BOTTOM

StartMapMoveMode: ; 0x301ec
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, $1
	ld [wInSpecialMode], a
	ld a, SPECIAL_MODE_MAP_MOVE
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
	call LoadBillboardTileData
.asm_3021b
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_3021f: ; 0x3021f
	dw Func_311b4 ; STAGE_RED_FIELD_TOP
	dw Func_311b4 ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_31324
	dw DoNothing_31324
	dw Func_31326 ; STAGE_BLUE_FIELD_TOP
	dw Func_31326 ; STAGE_BLUE_FIELD_BOTTOM

Func_3022b: ; 0x3022b
	xor a
	ld [wd5ca], a
	call FillBottomMessageBufferWithBlackTile
	xor a
	ld [wInSpecialMode], a
	ld [wSpecialMode], a
	callba StopTimer
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_30247: ; 0x30247
	dw Func_31234 ; STAGE_RED_FIELD_TOP
	dw Func_31234 ; STAGE_RED_FIELD_BOTTOM
	dw DoNothing_31325
	dw DoNothing_31325
	dw Func_313c3 ; STAGE_BLUE_FIELD_TOP
	dw Func_313c3 ; STAGE_BLUE_FIELD_TOP

INCLUDE "engine/pinball_game/billboard_tiledata.asm"

LoadScrollingMapNameText: ; 0x3118f
; Loads the scrolling message that displays the current map's name.
; Input: bc = pointer to prefix scrolling text
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
	ld [wStageCollisionMap + $f0], a
	ld a, $6b
	ld [wStageCollisionMap + $110], a
	ld a, $66
	ld [wStageCollisionMap + $e3], a
	ld a, $67
	ld [wStageCollisionMap + $103], a
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
	callba ResetIndicatorStates
	callba Func_107c2
	callba Func_107c8
	callba Func_107e9
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_14135
	callba Func_16425
	callba LoadMapBillboardTileData
	ret

ChooseNextMap_RedField: ; 0x31282
; Picks the next map to perform a map move.
; Also records which maps have been visited.
	ld a, [wNumMapMoves]
	inc a
	cp $6
	jr c, .dontReset
	ld a, $ff
	ld [wVisitedMaps], a
	ld [wVisitedMaps + 1], a
	ld [wVisitedMaps + 2], a
	ld [wVisitedMaps + 3], a
	ld [wVisitedMaps + 4], a
	ld [wVisitedMaps + 5], a
	xor a
.dontReset
	ld [wNumMapMoves], a
	cp $3
	jr c, .chooseMapFromArea1
	cp $5
	jr c, .chooseMapFromArea2
	ld a, INDIGO_PLATEAU
	ld [wCurrentMap], a
	ld [wVisitedMaps + 5], a
	ret

.chooseMapFromArea1
	call GenRandom
	and $7
	cp $7
	jr nc, .chooseMapFromArea1
	ld c, a
	ld b, $0
	ld hl, FirstMapMoveSet_RedField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps
	ld a, [wNumMapMoves]
	and a
	jr z, .asm_312d4
	ld b, a
.asm_312cd
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea1
	dec b
	jr nz, .asm_312cd
.asm_312d4
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

.chooseMapFromArea2
	call GenRandom
	and $3
	ld c, a
	ld b, $0
	ld hl, SecondMapMoveSet_RedField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps + 3
	ld a, [wNumMapMoves]
	sub $3
	jr z, .asm_31306
	ld b, a
.asm_312ff
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea2
	dec b
	jr nz, .asm_312ff
.asm_31306
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

FirstMapMoveSet_RedField:
	db PALLET_TOWN
	db VIRIDIAN_FOREST
	db PEWTER_CITY
	db CERULEAN_CITY
	db VERMILION_SEASIDE
	db ROCK_MOUNTAIN
	db LAVENDER_TOWN

SecondMapMoveSet_RedField:
	db CYCLING_ROAD
	db SAFARI_ZONE
	db SEAFOAM_ISLANDS
	db CINNABAR_ISLAND

DoNothing_31324: ; 0x31324
	ret

DoNothing_31325: ; 0x31325
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
	ld [wStageCollisionMap + $e3], a
	ld a, $55
	ld [wStageCollisionMap + $103], a
	ld a, $52
	ld [wStageCollisionMap + $f0], a
	ld a, $53
	ld [wStageCollisionMap + $110], a
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
	callba ResetIndicatorStates
	callba Func_107c2
	callba Func_1f2ff
	ld a, $0
	ld [wd644], a
	ld a, [wCurrentStage]
	bit 0, a
	ret z
	callba Func_1c2cb
	callba QueueGraphicsDataToLoad
	callba LoadMapBillboardTileData
	ret

ChooseNextMap_BlueField: ; 0x3140b
; Picks the next map to perform a map move.
; Also records which maps have been visited.
	ld a, [wNumMapMoves]
	inc a
	cp $6
	jr c, .dontReset
	ld a, $ff
	ld [wVisitedMaps], a
	ld [wVisitedMaps + 1], a
	ld [wVisitedMaps + 2], a
	ld [wVisitedMaps + 3], a
	ld [wVisitedMaps + 4], a
	ld [wVisitedMaps + 5], a
	xor a
.dontReset
	ld [wNumMapMoves], a
	cp $3
	jr c, .chooseMapFromArea1
	cp $5
	jr c, .chooseMapFromArea2
	ld a, INDIGO_PLATEAU
	ld [wCurrentMap], a
	ld [wVisitedMaps + 5], a
	ret

.chooseMapFromArea1
	call GenRandom
	and $7
	cp $7
	jr nc, .chooseMapFromArea1
	ld c, a
	ld b, $0
	ld hl, FirstMapMoveSet_BlueField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps
	ld a, [wNumMapMoves]
	and a
	jr z, .asm_3145e
	ld b, a
.asm_31457
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea1
	dec b
	jr nz, .asm_31457
.asm_3145e
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

.chooseMapFromArea2
	call GenRandom
	and $3
	ld c, a
	ld b, $0
	ld hl, SecondMapMoveSet_BlueField
	add hl, bc
	ld c, [hl]
	ld hl, wVisitedMaps + 3
	ld a, [wNumMapMoves]
	sub $3
	jr z, .asm_31490
	ld b, a
.asm_31489
	ld a, [hli]
	cp c
	jr z, .chooseMapFromArea2
	dec b
	jr nz, .asm_31489
.asm_31490
	ld a, c
	ld [wCurrentMap], a
	ld a, [wNumMapMoves]
	ld c, a
	ld b, $0
	ld hl, wVisitedMaps
	add hl, bc
	ld a, [wCurrentMap]
	ld [hl], a
	ret

FirstMapMoveSet_BlueField:
	db VIRIDIAN_CITY
	db VIRIDIAN_FOREST
	db MT_MOON
	db CERULEAN_CITY
	db VERMILION_STREETS
	db ROCK_MOUNTAIN
	db CELADON_CITY

SecondMapMoveSet_BlueField:
	db FUCHSIA_CITY
	db SAFARI_ZONE
	db SAFFRON_CITY
	db CINNABAR_ISLAND

Func_314ae: ; 0x314ae
	ld a, [wTimerActive]
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
	callba LoadMapBillboardTileData
.asm_31577
	callba StopTimer
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
	callba ChooseNextMap_RedField
	callba LoadMapBillboardTileData
	lb de, $25, $25
	call PlaySoundEffect
	ld bc, ArrivedAtMapText
	callba LoadScrollingMapNameText
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
	ld a, [wTimerActive]
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
	callba QueueGraphicsDataToLoad
	callba LoadMapBillboardTileData
.asm_316ee
	callba StopTimer
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
	callba ChooseNextMap_BlueField
	callba LoadMapBillboardTileData
	lb de, $25, $25
	call PlaySoundEffect
	ld bc, ArrivedAtMapText
	callba LoadScrollingMapNameText
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

SECTION "bankd", ROMX

SlotOnPic: ; 0x34000
	INCBIN "gfx/billboard/slot/slot_on.2bpp"
SlotOffPic: ; 0x34180
	INCBIN "gfx/billboard/slot/slot_off.2bpp"

SECTION "bankd.2", ROMX

StageSeelBonusCollisionMasks: ; 0x37f00
	INCBIN "data/collision/masks/seel_bonus.masks"

SECTION "banke", ROMX
Data_38000:
	db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Data_38010:
	db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Data_38020:
	db $51, $10, $00, $10, $00, $10, $00, $10, $00, $80, $00, $00, $00, $00, $00, $00

Data_38030:
	db $a9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Data_3809a:
	db $00, $00, $00
	db $40, $40, $40
	db $90, $90, $90
	db $e4, $e4, $e4

Data_380a6:
	db $59, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31

    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31

    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31

    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31
    RGB 31, 31, 31

    RGB 30, 31, 29
    RGB 28, 28, 25
    RGB 27, 26, 24
    RGB 24, 24, 24

    RGB 23, 23, 23
    RGB 23, 23, 23
    RGB 23, 23, 23
    RGB 23, 23, 23

    RGB 23, 23, 23
    RGB 23, 23, 23
    RGB 23, 23, 23
    RGB 23, 23, 23

    RGB 23, 23, 23
    RGB 23, 23, 23
    RGB 23, 23, 23
    RGB 23, 23, 23

    RGB 30, 31, 27
    RGB 25, 26, 20
    RGB 23, 21, 18
    RGB 17, 17, 17

    RGB 15, 15, 15
    RGB 15, 15, 15
    RGB 15, 15, 15
    RGB 15, 15, 15

    RGB 15, 15, 15
    RGB 15, 15, 15
    RGB 15, 15, 15
    RGB 15, 15, 15

    RGB 15, 15, 15
    RGB 15, 15, 15
    RGB 15, 15, 15
    RGB 15, 15, 15

    RGB 29, 31, 25
    RGB 22, 24, 15
    RGB 19, 16, 12
    RGB 10, 10, 10

    RGB 7, 7, 7
    RGB 7, 7, 7
    RGB 7, 7, 7
    RGB 7, 7, 7

    RGB 7, 7, 7
    RGB 7, 7, 7
    RGB 7, 7, 7
    RGB 7, 7, 7

    RGB 7, 7, 7
    RGB 7, 7, 7
    RGB 7, 7, 7
    RGB 7, 7, 7

    RGB 29, 31, 23
    RGB 20, 22, 10
    RGB 15, 12, 6
    RGB 3, 3, 4

    RGB 0, 0, 0
    RGB 0, 0, 0
    RGB 0, 0, 0
    RGB 0, 0, 0

    RGB 0, 0, 0
    RGB 0, 0, 0
    RGB 0, 0, 0
    RGB 0, 0, 0

    RGB 0, 0, 0
    RGB 0, 0, 0
    RGB 0, 0, 0
    RGB 0, 0, 0

Data_38156:
	db $99, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	INCBIN "gfx/sgb_border.interleave.2bpp"

Data_39166:
	db $99, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	INCBIN "gfx/sgb_border_blank.2bpp"

Data_3a176:
	db $a1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	INCBIN "gfx/tilemaps/sgb_border.map"

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

SECTION "bankf", ROMX

INCLUDE "audio/engine_0f.asm"

SECTION "bank10", ROMX

INCLUDE "audio/engine_10.asm"

SECTION "bank11", ROMX

INCLUDE "audio/engine_11.asm"

SECTION "bank12", ROMX

INCLUDE "audio/engine_12.asm"

; This is a blob of unused junk data
INCBIN "data/unknown/unused_4b6a8.bin"

SECTION "bank13", ROMX

INCLUDE "audio/engine_13.asm"

SECTION "bank14", ROMX

INCLUDE "audio/pikapcm.asm"

SECTION "bank16", ROMX

INCLUDE "data/billboard/billboard_pics.asm"
INCLUDE "data/mon_gfx/mon_billboard_palettes_1.asm"

SECTION "bank17", ROMX

INCLUDE "data/billboard/reward_pics.asm"

MeowthBonusBaseGameBoyGfx: ; 0x5f600
	INCBIN "gfx/stage/meowth_bonus/meowth_bonus_base_gameboy.2bpp"

SECTION "bank18", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_1.asm"

StageRedFieldTopStatusBarSymbolsGfx_GameBoy: ; 0x63000
	INCBIN "gfx/stage/red_top/status_bar_symbols_gameboy.2bpp"

	INCBIN "gfx/unused_pocket_monster.2bpp"

SECTION "bank18.2", ROMX

StageRedFieldTopBaseGameBoyGfx: ; 0x632a0
	INCBIN "gfx/stage/red_top/red_top_base_gameboy.2bpp"

SECTION "bank19", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_2.asm"

StageBlueFieldBottomBaseGameBoyGfx: ; 0x67000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_base_gameboy.2bpp"

SECTION "bank1a", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_3.asm"

StageBlueFieldTopStatusBarSymbolsGfx_GameBoy: ; 0x6b000
	INCBIN "gfx/stage/blue_top/status_bar_symbols_gameboy.2bpp"

	INCBIN "gfx/unused_pocket_monster.2bpp"
	ds $20 ; free space

StageBlueFieldTopBaseGameBoyGfx: ; 0x6b2a0
	INCBIN "gfx/stage/blue_top/blue_top_base_gameboy.2bpp"

SECTION "bank1b", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_4.asm"

UnusedStageGfx: ; 0x6f000
	INCBIN "gfx/stage/unused_stage.2bpp"

SECTION "bank1c", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_5.asm"

UncaughtPokemonBackgroundPic:
	INCBIN "gfx/pokedex/uncaught_pokemon.2bpp"
	INCBIN "gfx/pokedex/uncaught_pokemon.2bpp" ; This pic is unnecessarily duplicated.

SECTION "bank1c.2", ROMX

GengarBonusBaseGameBoyGfx: ; 0x73000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_base_gameboy.2bpp"

SECTION "bank1d", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_6.asm"

StageRedFieldBottomBaseGameBoyGfx: ; 0x77000
	INCBIN  "gfx/stage/red_bottom/red_bottom_base_gameboy.2bpp"

SECTION "bank1e", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_7.asm"

INCLUDE "data/billboard/bonus_multiplier_pics.asm"

INCLUDE "data/mon_gfx/mon_billboard_palettes_2.asm"

SECTION "bank1f", ROMX

INCLUDE "data/mon_gfx/mon_animated_pics_1.asm"

MewtwoBonusBaseGameBoyGfx: ; 0x7f000
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_bonus_base_gameboy.2bpp"

EraseAllDataGfx: ; 0x7fd00: ; 0x7fd00
	INCBIN "gfx/erase_all_data.2bpp"

SECTION "bank20", ROMX

INCLUDE "data/mon_gfx/mon_animated_pics_2.asm"

MewtwoBonusBaseGameBoyColorGfx: ; 0x83000
	INCBIN "gfx/stage/mewtwo_bonus/mewtwo_bonus_base_gameboycolor.2bpp"

StageDiglettBonusCollisionMasks: ; 0x83d00
	INCBIN "data/collision/masks/diglett_bonus.masks"

SECTION "bank21", ROMX

INCLUDE "data/mon_gfx/mon_animated_pics_3.asm"

SECTION "bank21.2", ROMX

DiglettBonusBaseGameBoyColorGfx: ; 0x87000
	INCBIN "gfx/stage/diglett_bonus/diglett_bonus_base_gameboycolor.2bpp"

GengarBonusHaunterGfx: ; 0x87d00
	INCBIN "gfx/stage/gengar_bonus/haunter.interleave.2bpp"

SECTION "bank22", ROMX

INCLUDE "data/mon_gfx/mon_animated_pics_4.asm"

FieldSelectScreenGfx:
FieldSelectBlinkingBorderGfx: ; 0x8b000
	INCBIN "gfx/field_select/blinking_border.2bpp"
FieldSelectGfx: ; 0x8b100
	INCBIN "gfx/field_select/field_select_tiles.2bpp"

GengarBonusGastlyGfx: ; 0x8bd00
	INCBIN "gfx/stage/gengar_bonus/gastly.interleave.2bpp"

SECTION "bank22.2", ROMX

INCLUDE "data/mon_gfx/mon_billboard_palettes_3.asm"

SECTION "bank23", ROMX

INCLUDE "data/mon_gfx/mon_animated_pics_5.asm"

DiglettBonusBaseGameBoyGfx: ; 0x8f000
	INCBIN "gfx/stage/diglett_bonus/diglett_bonus_base_gameboy.2bpp"

INCLUDE "gfx/high_scores/high_scores_transition_palettes.asm"
INCLUDE "data/billboard/map_palettes.asm"

SECTION "bank24", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_8.asm"

SeelBonusBaseGameBoyGfx: ; 0x93000
	INCBIN "gfx/stage/seel_bonus/seel_bonus_base_gameboy.2bpp"

INCLUDE "data/billboard/map_palette_maps_2.asm"

SECTION "bank25", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_9.asm"

SeelBonusBaseGameBoyColorGfx: ; 0x97000
	INCBIN "gfx/stage/seel_bonus/seel_bonus_base_gameboycolor.2bpp"

StageRedFieldTopGfx3: ; 0x97a00
	INCBIN "gfx/stage/red_top/red_top_3.2bpp"
StageRedFieldTopGfx1: ; 0x97ba0
	INCBIN "gfx/stage/red_top/red_top_1.2bpp"
StageRedFieldTopGfx2: ; 0x97e00
	INCBIN "gfx/stage/red_top/red_top_2.2bpp"

SECTION "bank26", ROMX

INCLUDE "data/mon_gfx/mon_billboard_pics_10.asm"

SeelBonusSeel3Gfx: ; 0x9b000
	INCBIN "gfx/stage/seel_bonus/seel_3.2bpp"
SeelBonusSeel1Gfx: ; 0x9b1a0
	INCBIN "gfx/stage/seel_bonus/seel_1.2bpp"
SeelBonusSeel2Gfx: ; 0x9b400
	INCBIN "gfx/stage/seel_bonus/seel_2.2bpp"
SeelBonusSeel4Gfx: ; 0x9b460
	INCBIN "gfx/stage/seel_bonus/seel_4.2bpp"

GengarBonusGengarGfx: ; 0x9b900
	INCBIN "gfx/stage/gengar_bonus/gengar.interleave.2bpp"

SECTION "bank27", ROMX

StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor: ; 0x9c000
	INCBIN "gfx/stage/red_top/status_bar_symbols_gameboycolor.2bpp"

	INCBIN "gfx/unused_pocket_monster_2.2bpp"

SECTION "bank27.2", ROMX

StageRedFieldTopBaseGameBoyColorGfx: ; 0x9c2a0
	INCBIN "gfx/stage/red_top/red_top_base_gameboycolor.2bpp"

StageRedFieldTopGfx4: ; 0x9d000
	INCBIN "gfx/stage/red_top/red_top_4.2bpp"

GengarBonusBaseGameBoyColorGfx: ; 0x9e000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_base_gameboycolor.2bpp"
GengarBonus1Gfx: ; 0x9f000
	INCBIN "gfx/stage/gengar_bonus/gengar_bonus_1.2bpp"

SECTION "bank28", ROMX

StageBlueFieldTopStatusBarSymbolsGfx_GameBoyColor: ; 0xa0000
	INCBIN "gfx/stage/blue_top/status_bar_symbols_gameboycolor.2bpp"

	INCBIN "gfx/unused_pocket_monster_2.2bpp"

SECTION "bank28.2", ROMX

StageBlueFieldTopBaseGameBoyColorGfx: ; 0xa02a0
	INCBIN "gfx/stage/blue_top/blue_top_base_gameboycolor.2bpp"

StageBlueFieldTopGfx4: ; 0xa1000
	INCBIN "gfx/stage/blue_top/blue_top_4.2bpp"

StageRedFieldBottomBaseGameBoyColorGfx: ; 0xa2000
	INCBIN "gfx/stage/red_bottom/red_bottom_base_gameboycolor.2bpp"

StageRedFieldBottomGfx5: ; 0xa3000
	INCBIN "gfx/stage/red_bottom/red_bottom_5.2bpp"

SECTION "bank29", ROMX

StageBlueFieldBottomBaseGameBoyColorGfx: ; 0xa4000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_base_gameboycolor.2bpp"
StageBlueFieldBottomGfx1: ; 0xa5000
	INCBIN "gfx/stage/blue_bottom/blue_bottom_1.2bpp"

INCLUDE "data/billboard/map_pics.asm"

HighScoresHexadecimalCharsGfx:
	INCBIN "gfx/high_scores/hexadecimal_characters.2bpp"

SECTION "bank2a", ROMX

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

BallCaptureSmokeGfx:
	INCBIN "gfx/stage/ball_capture_smoke.interleave.2bpp"

SECTION "bank2a.2", ROMX

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

SECTION "bank2a.3", ROMX

INCLUDE "data/mon_gfx/mon_animated_palettes_1.asm"

SECTION "bank2b", ROMX

TitlescreenFadeInGfx: ; 0xac000
	INCBIN "gfx/titlescreen/titlescreen_fade_in.2bpp"

PokedexInitialGfx:
	INCBIN "gfx/pokedex/pokedex_initial.2bpp"

StageBlueFieldBottomCollisionMasks: ; 0xaf000
	INCBIN "data/collision/masks/blue_stage_bottom.masks"

SECTION "bank2b.2", ROMX

DiglettBonusDugtrio3Gfx: ; 0xaf900
	INCBIN "gfx/stage/diglett_bonus/dugtrio_3.2bpp"
DiglettBonusDugtrio1Gfx: ; 0xafaa0
	INCBIN "gfx/stage/diglett_bonus/dugtrio_1.2bpp"
DiglettBonusDugtrio2Gfx: ; 0xafd00
	INCBIN "gfx/stage/diglett_bonus/dugtrio_2.2bpp"
DiglettBonusDugtrio4Gfx: ; 0xafd60
	INCBIN "gfx/stage/diglett_bonus/dugtrio_4.2bpp"

SECTION "bank2c", ROMX

StageRedFieldBottomIndicatorsGfx_Gameboy: ; 0xb0000
	INCBIN "gfx/stage/red_bottom/red_bottom_indicators_gameboy.2bpp"

StageRedFieldTopCollisionAttributes6: ; 0xb3000
	INCBIN "data/collision/maps/red_stage_top_6.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

FieldSelectTilemap: ; 0xb3800
	INCBIN "gfx/tilemaps/field_select.map"
FieldSelectBGAttributes: ; 0xb3c00
	INCBIN "gfx/bgattr/field_select.bgattr"

SECTION "bank2d", ROMX

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
	INCBIN "data/collision/unused_trailing_data.bin"

StageRedFieldTopCollisionAttributes4: ; 0xb7400
	INCBIN "data/collision/maps/red_stage_top_4.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_5.asm"

SECTION "bank2e", ROMX

StageRedFieldTopCollisionAttributes3: ; 0xb8000
	INCBIN "data/collision/maps/red_stage_top_3.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

StageRedFieldTopCollisionAttributes2: ; 0xb8800
	INCBIN "data/collision/maps/red_stage_top_2.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

StageRedFieldTopCollisionAttributes1: ; 0xb9000
	INCBIN "data/collision/maps/red_stage_top_1.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

StageRedFieldTopCollisionAttributes0: ; 0xb9800
	INCBIN "data/collision/maps/red_stage_top_0.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

StageRedFieldTopTilemap_GameBoy: ; 0xba000
	INCBIN "gfx/tilemaps/stage_red_field_top_gameboy.map"

SECTION "bank2e.2", ROMX

StageRedFieldBottomTilemap_GameBoy: ; 0xba800
	INCBIN "gfx/tilemaps/stage_red_field_bottom_gameboy.map"

SECTION "bank2e.3", ROMX

StageRedFieldTopCollisionMasks0: ; 0xbb000
	INCBIN "data/collision/masks/red_stage_top_0.masks"

StageRedFieldTopCollisionMasks1: ; 0xbb800
	INCBIN "data/collision/masks/red_stage_top_1.masks"

SECTION "bank2f", ROMX

StageRedFieldTopCollisionMasks2: ; 0xbc000
	INCBIN "data/collision/masks/red_stage_top_2.masks"

StageRedFieldTopCollisionMasks3: ; 0xbc800
	INCBIN "data/collision/masks/red_stage_top_3.masks"

StageRedFieldTopCollisionAttributes7: ; 0xbd000
	INCBIN "data/collision/maps/red_stage_top_7.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

StageRedFieldBottomCollisionAttributes: ; 0xbd800
	INCBIN "data/collision/maps/red_stage_bottom.collision"

SECTION "bank2f.2", ROMX

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

SECTION "bank2f.3", ROMX

EraseAllDataTilemap: ; 0xbf800
	INCBIN "gfx/tilemaps/erase_all_data.map"
EraseAllDataBGAttributes: ; 0xbfc00
	INCBIN "gfx/bgattr/erase_all_data.bgattr"

SECTION "bank30", ROMX

StageBlueFieldBottomTilemap_GameBoy: ; 0xc0000
	INCBIN "gfx/tilemaps/stage_blue_field_bottom_gameboy.map"

SECTION "bank30.2", ROMX

StageBlueFieldTopCollisionMasks: ; 0xc0800
	INCBIN "data/collision/masks/blue_stage_top.masks"

StageBlueFieldTopCollisionAttributesBallEntrance: ; 0xc1000
	INCBIN "data/collision/maps/blue_stage_top_ball_entrance.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

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
	INCBIN "data/collision/unused_trailing_data.bin"

OptionMenuTilemap2: ; 0xc3000
	INCBIN "gfx/tilemaps/option_menu_2.map"

SECTION "bank30.3", ROMX

OptionMenuTilemap4: ; 0xc3400
	INCBIN "gfx/tilemaps/option_menu_4.map"
	INCBIN "gfx/tilemaps/unused_tilemap_c3640.map"

OptionMenuTilemap: ; 0xc3800
	INCBIN "gfx/tilemaps/option_menu.map"

SECTION "bank30.4", ROMX

OptionMenuTilemap3: ; 0xc3c00
	INCBIN "gfx/tilemaps/option_menu_3.map"
	INCBIN "gfx/tilemaps/unused_tilemap_c3640.map"

SECTION "bank31", ROMX

StageBlueFieldBottomCollisionAttributes: ; 0xc4000
	INCBIN "data/collision/maps/blue_stage_bottom.collision"
	INCBIN "data/collision/unused_trailing_data.bin"

PokedexTilemap:
	INCBIN "gfx/tilemaps/pokedex.map"
PokedexBGAttributes:
	INCBIN "gfx/bgattr/pokedex.bgattr"

PokedexTilemap2:
	INCBIN "gfx/tilemaps/pokedex_2.map"
PokedexBGAttributes2:
	INCBIN "gfx/bgattr/pokedex_2.bgattr"

TitlescreenTilemap: ; 0xc5800
	INCBIN "gfx/tilemaps/titlescreen.map"
TitlescreenBGAttributes: ; 0xc5c00
	INCBIN "gfx/bgattr/titlescreen.bgattr"

SECTION "bank31.2", ROMX

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

SECTION "bank32", ROMX

StageGengarBonusCollisionAttributes: ; 0xc8000
	INCBIN "data/collision/maps/gengar_bonus.collision"

SECTION "bank32.2", ROMX

GengarBonusTilemap_GameBoy: ; 0xc8800
	INCBIN "gfx/tilemaps/stage_gengar_bonus_gameboy.map"

SECTION "bank32.3", ROMX

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

SECTION "bank32.4", ROMX

StageMewtwoBonusCollisionAttributesBallEntrance: ; 0xca000
	INCBIN "data/collision/maps/mewtwo_bonus_ball_entrance.collision"

SECTION "bank32.5", ROMX

StageMewtwoBonusCollisionAttributes: ; 0xca800
	INCBIN "data/collision/maps/mewtwo_bonus.collision"

SECTION "bank32.6", ROMX

MewtwoBonusTilemap_GameBoy: ; 0xcb000
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboy.map"

SECTION "bank32.7", ROMX

MewtoBonusBottomTilemap_GameBoyColor: ; 0xcb800
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboycolor.map"
MewtoBonusBottomTilemap2_GameBoyColor: ; 0xcbc00
	INCBIN "gfx/tilemaps/stage_mewtwo_bonus_gameboycolor_2.map"

SECTION "bank33", ROMX

MeowthBonusMeowth3Gfx: ; 0xcc000
	INCBIN "gfx/stage/meowth_bonus/meowth_3.2bpp"
MeowthBonusMeowth1Gfx: ; 0xcc1a0
	INCBIN "gfx/stage/meowth_bonus/meowth_1.2bpp"
MeowthBonusMeowth2Gfx: ; 0xcc400
	INCBIN "gfx/stage/meowth_bonus/meowth_2.2bpp"
MeowthBonusMeowth4Gfx: ; 0xcc460
	INCBIN "gfx/stage/meowth_bonus/meowth_4.2bpp"

SECTION "bank33.2", ROMX

StageMeowthBonusCollisionAttributesBallEntrance: ; 0xcc800
	INCBIN "data/collision/maps/meowth_bonus_ball_entrance.collision"

SECTION "bank33.3", ROMX

StageMeowthBonusCollisionAttributes: ; 0xcd000
	INCBIN "data/collision/maps/meowth_bonus.collision"

SECTION "bank33.4", ROMX

MeowthBonusTilemap_GameBoy: ; 0xcd800
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboy.map"

SECTION "bank33.5", ROMX

MeowthBonusTilemap_GameBoyColor: ; 0xce000
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboycolor.map"
MeowthBonusTilemap2_GameBoyColor: ; 0xce400
	INCBIN "gfx/tilemaps/stage_meowth_bonus_gameboycolor_2.map"

StageDiglettBonusCollisionAttributesBallEntrance: ; 0xce800
	INCBIN "data/collision/maps/diglett_bonus_ball_entrance.collision"

SECTION "bank33.6", ROMX

StageDiglettBonusCollisionAttributes: ; 0xcf000
	INCBIN "data/collision/maps/diglett_bonus.collision"

SECTION "bank33.7", ROMX

DiglettBonusTilemap_GameBoy: ; 0xcf800
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboy.map"

SECTION "bank34", ROMX

INCLUDE "data/collision/mon_collision_masks.asm"

INCBIN "gfx/tilemaps/unused_tilemap_d2800.map"

DiglettBonusTilemap_GameBoyColor: ; 0xd3000
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboycolor.map"
DiglettBonusTilemap2_GameBoyColor: ; 0xd3400
	INCBIN "gfx/tilemaps/stage_diglett_bonus_gameboycolor_2.map"

INCBIN "data/unused_data_d3800.bin"

SECTION "bank35", ROMX

StageSeelBonusCollisionAttributesBallEntrance: ; 0xd4000
	INCBIN "data/collision/maps/seel_bonus_ball_entrance.collision"

SECTION "bank35.2", ROMX

StageSeelBonusCollisionAttributes: ; 0xd4800
	INCBIN "data/collision/maps/seel_bonus.collision"

SECTION "bank35.3", ROMX

SeelBonusTilemap_GameBoy: ; 0xd5000
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboy.map"

SECTION "bank35.4", ROMX

SeelBonusTilemap_GameBoyColor: ; 0xd5800
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboycolor.map"
SeelBonusTilemap2_GameBoyColor: ; 0xd5c00
	INCBIN "gfx/tilemaps/stage_seel_bonus_gameboycolor_2.map"

Alphabet1Gfx: ; 0xd6000
	INCBIN "gfx/stage/alphabet_1.2bpp"

Exclamation_Point_CharacterGfx: INCBIN "gfx/stage/exclamation_point_mono.2bpp" ;DMG excalamation point
Period_CharacterGfx: INCBIN "gfx/stage/period_mono.2bpp" ;DMG period
E_Acute_CharacterGfx: INCBIN "gfx/stage/e_acute_mono.2bpp"
Apostrophe_CharacterGfx: INCBIN "gfx/stage/apostrophe_mono.2bpp" ;DMG apostrophe
Colon_CharacterGfx: INCBIN "gfx/stage/colon_mono.2bpp" ;DMG colon

SECTION "bank35.5", ROMX

Alphabet2Gfx: ; 0xd6200
	INCBIN "gfx/stage/alphabet_2.2bpp"

Exclamation_Point_CharacterGfx_GameboyColor: INCBIN "gfx/stage/exclamation_point_color.2bpp";gbc excalamation point
Period_CharacterGfx_GameboyColor: INCBIN "gfx/stage/period_color.2bpp" ;gbc period
E_Acute_CharacterGfx_GameboyColor: INCBIN "gfx/stage/e_acute_color.2bpp"
Apostrophe_CharacterGfx_GameboyColor: INCBIN "gfx/stage/apostrophe_color.2bpp" ;GBC apostrophe
Colon_CharacterGfx_GameboyColor: INCBIN "gfx/stage/colon_color.2bpp" ;gbc colon

SECTION "bank35.6", ROMX

InGameMenuSymbolsGfx: ; 0xd6400
	INCBIN "gfx/stage/menu_symbols.2bpp"

SECTION "bank35.7", ROMX

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

SECTION "bank36", ROMX

PaletteMap_d8000: ; 0xd8000
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6
	db $6, $6, $6, $6, $6, $6

SECTION "bank36.2", ROMX

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_2.asm"

SaverTextOffGfx: ; 0xd8c00
	INCBIN "gfx/stage/saver_off.2bpp"

AgainTextOffGfx: ; 0xd8c40
	INCBIN "gfx/stage/again_off.2bpp"

CatchTextGfx:
	INCBIN "gfx/stage/catch.w48.2bpp"

UnusedEvolutionTextGfx: ; 0xd8ce0
	INCBIN "gfx/stage/unused_evolution_text.2bpp"

EvolutionProgressIconsGfx:
	INCBIN "gfx/stage/evolution_progress_icons.2bpp"

CaughtPokeballGfx: ; 0xd8f60
	INCBIN "gfx/stage/caught_pokeball.2bpp"

SECTION "bank36.3", ROMX

StageRedFieldBottomCollisionMasks: ; 0xd9000
	INCBIN "data/collision/masks/red_stage_bottom.masks"

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_3.asm"

SelectGameboyTargetTextGfx: ; 0xd9c00
	INCBIN "gfx/select_gb_target_text.2bpp"

CopyrightTextGfx: ; 0xda000
	INCBIN "gfx/copyright_text.2bpp"

INCLUDE "data/mon_gfx/mon_billboard_palette_maps_4.asm"

StageSharedBonusSlotGlowGfx: ; 0xdac00
	INCBIN "gfx/stage/shared/bonus_slot_glow.2bpp"

SECTION "bank36.4", ROMX

StageSharedBonusSlotGlow2Gfx: ; 0xdade0
	INCBIN "gfx/stage/shared/bonus_slot_glow_2.2bpp"

StageRedFieldTopGfx5: ; 0xdae00
	INCBIN "gfx/stage/red_top/red_top_5.2bpp"

TimerDigitsGfx2: ; 0xdb000
	INCBIN "gfx/stage/timer_digits.2bpp"

SECTION "bank36.5", ROMX

TimerDigitsGfx: ; 0xdb200
	INCBIN "gfx/stage/timer_digits.2bpp"

SECTION "bank36.6", ROMX

GengarBonusGroundGfx: ; 0xdb400
	INCBIN "gfx/stage/gengar_bonus/gengar_ground.2bpp"

SECTION "bank36.7", ROMX

StageGengarBonusCollisionMasks: ; 0xdb600
	INCBIN "data/collision/masks/gengar_bonus.masks"

INCLUDE "data/mon_gfx/mon_animated_palettes_2.asm"
INCLUDE "data/mon_gfx/mon_billboard_palettes_4.asm"

StageRedFieldTopGfx6: ; 0xdbb80
	INCBIN "gfx/stage/red_top/red_top_6.2bpp"

SECTION "bank36.8", ROMX

StageMewtwoBonusCollisionMasks: ; 0xdbc80
	INCBIN "data/collision/masks/mewtwo_bonus.masks"

INCLUDE "data/mon_gfx/mon_animated_palettes_3.asm"

EvolutionTrinketsGfx:
	INCBIN "gfx/stage/shared/evolution_trinkets.2bpp"

Unknown_dbf60: ; 0xdbf60
; this seems to be unused garbage
	INCBIN "data/unknown/unused_dbf60.bin"

SECTION "bank37", ROMX

StageSharedArrowsGfx: ; 0xdc000
	INCBIN "gfx/stage/shared/arrows.2bpp"

SECTION "bank37.2", ROMX

INCLUDE "data/mon_gfx/mon_billboard_palettes_5.asm"

StageMeowthBonusCollisionMasks: ; 0xdc600
	INCBIN "data/collision/masks/meowth_bonus.masks"

INCLUDE "data/mon_gfx/mon_billboard_palettes_6.asm"
INCLUDE "data/stage_palettes.asm"
INCLUDE "data/billboard/map_palettes_2.asm"
INCLUDE "data/ball_palettes.asm"

PaletteData_dd188: ; 0xdd188
	RGB 31, 31, 31
    RGB 31, 29, 0
    RGB 29, 3, 2
    RGB 2, 2, 2
PaletteData_dd190: ; 0xdd190
    RGB 31, 31, 31
    RGB 9, 22, 6
    RGB 4, 13, 31
    RGB 2, 2, 2
PaletteData_dd198: ; 0xdd198
    RGB 31, 31, 31
    RGB 31, 26, 2
    RGB 31, 3, 0
    RGB 0, 0, 0
PaletteData_dd1a0: ; 0xdd1a0
    RGB 31, 31, 31
    RGB 31, 26, 2
    RGB 31, 3, 0
    RGB 0, 0, 0

SECTION "bank39", ROMX

BallPhysicsData_e4000:
	INCBIN "data/collision/ball_physics_e4000.bin"

SECTION "bank3a", ROMX

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

SECTION "bank3b", ROMX
BallPhysicsData_ec000:
	INCBIN "data/collision/ball_physics_ec000.bin"

SECTION "bank3c", ROMX
BallPhysicsData_f0000:
	INCBIN "data/collision/ball_physics_f0000.bin"

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

SECTION "bank3d", ROMX

FlipperHorizontalCollisionAttributes: ; 0xf4000
	INCBIN "data/collision/flippers/horizontal_attributes_0"

SECTION "bank3e", ROMX

FlipperHorizontalCollisionAttributes2: ; 0xf8000
	INCBIN "data/collision/flippers/horizontal_attributes_1"

FlipperVerticalCollisionAttributes: ; 0xfa000
	INCBIN "data/collision/flippers/vertical_attributes_0"

SECTION "bank3f", ROMX

FlipperVerticalCollisionAttributes2: ; 0xfc000
	INCBIN "data/collision/flippers/vertical_attributes_1"
