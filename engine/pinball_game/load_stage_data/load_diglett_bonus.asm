_LoadStageDataDiglettBonus: ; 0x19a76
	callba LoadBallGraphics
	call LoadFlippersPalette
	ld a, [wLoadingSavedGame]
	and a
	ret z
	call QueueGateGraphicsToLoad_DiglettBonus
	call RestoreDiglettStatesOnLoad
	ld a, [wDugrioState]
	and a
	call nz, LoadDugtrioCollisionData
	ret

RestoreDiglettStatesOnLoad: ; 0x19a96
	ld hl, wDiglettStates
	ld bc, NUM_DIGLETTS << 8
.asm_19a9c
	ld a, [hli]
	and a
	jr z, .asm_19aae
	push bc
	push hl
	push af
	call UpdateDiglettAnimationState
	pop af
	cp $6
	call c, WriteDiglettCollisionMapTiles
	pop hl
	pop bc
.asm_19aae
	inc c
	dec b
	jr nz, .asm_19a9c
	ret
