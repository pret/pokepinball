InitBallDiglettBonusStage: ; 0x19a38
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
	ld [wDiglettBonusClosedGate], a
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
