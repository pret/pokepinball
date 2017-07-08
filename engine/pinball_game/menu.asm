HandleInGameMenu: ; 0x86d7
; Routine responsible for the "SAVE"/"CANCEL" menu.
	ld a, [wd917]
	push af
	ld a, $1
	ld [wd917], a
	call FillBottomMessageBufferWithBlackTile
	xor a
	ld [wDrawBottomMessageBox], a
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
	ld hl, InGameMenuSymbolsGfx + $50
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
	ld [wDrawBottomMessageBox], a
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
