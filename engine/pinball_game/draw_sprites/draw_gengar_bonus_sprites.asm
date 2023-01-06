DrawSpritesGengarBonus: ; 0x18faf
	ld bc, $7f00
	callba DrawTimer
	call Func_19020
	call Func_190b9
	call Func_19185
	callba DrawFlippers
	callba DrawPinball
	ret

Debug_CycleGengarBonusPhase:
; Leftover debugging function for quickly cycling through
; the three phases of the Gengar Bonus stage. Pressing UP
; will instantly skip to the next phase.
	ld a, [hNewlyPressedButtons]
	bit BIT_D_UP, a
	ret z
	ld a, [wGastly1Enabled]
	and a
	jr z, .disabled
	ld a, $1
	ld [wd67e], a
	ld [wd687], a
	xor a
	ld [wGastly1Enabled], a
	ld [wGastly2Enabled], a
	ld [wGastly3Enabled], a
	ret

.disabled
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
	ld a, 1
	ld [wGastly1Enabled], a
	ld [wGastly2Enabled], a
	ld [wGastly3Enabled], a
	xor a
	ld [wd698], a
	ret

Func_19020: ; 0x19020
	ld de, wGastly1Enabled
	call Func_19033
	ld de, wGastly2Enabled
	call Func_19033
	ld de, wGastly3Enabled
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
	ld hl, GastlyVideoData_190a9
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(GengarBonusGastlyGfx)
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

GastlyVideoData_190a9:
	dw vTilesSH tile $10, GengarBonusGastlyGfx
	dw vTilesSH tile $16, GengarBonusGastlyGfx + $60
	dw vTilesSH tile $1c, GengarBonusGastlyGfx + $c0
	dw vTilesSH tile $22, GengarBonusGastlyGfx + $120

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
	ld [wGastly1Enabled], a
	ld [wGastly2Enabled], a
	ld [wGastly3Enabled], a
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
	ld hl, GengarBonusStageGengarGfxTable
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
	ld [wGastly1Enabled], a
	ld [wGastly2Enabled], a
	ld [wGastly3Enabled], a
	ld [wd67e], a
	ld [wd687], a
	pop de
	scf
	ret

GengarBonusStageGengarGfxTable:
	dw $60, vTilesSH tile $10, GengarBonusGengarGfx,        $0000
	dw $60, vTilesSH tile $16, GengarBonusGengarGfx + $60,  $0000
	dw $60, vTilesSH tile $1c, GengarBonusGengarGfx + $c0,  $0000
	dw $60, vTilesSH tile $22, GengarBonusGengarGfx + $120, $0000
	dw $20, vTilesSH tile $28, GengarBonusGengarGfx + $180, $0000
	dw $40, vTilesOB tile $1a, GengarBonusGengarGfx + $1a0, $0000
	dw $60, vTilesOB tile $1e, GengarBonusGengarGfx + $1e0, $0000
	dw $60, vTilesOB tile $24, GengarBonusGengarGfx + $240, $0000
