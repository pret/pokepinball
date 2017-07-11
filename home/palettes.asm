SetAllPalettesWhite: ; 0xb66
; Sets all BG and OBJ palettes to white.
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	xor a
	ld [hBGP], a
	ld [hOBP0], a
	ld [hOBP1], a
	ret

.gameboyColor
	ld de, rBGPI
	ld hl, wPaletteData
	ld b, $0
	ld c, $20
.asm_b7d
	ld a, b
	ld [rBGPI], a
	inc b
	ld a, [rBGPD]
	ld [hli], a
	ld a, b
	ld [rBGPI], a
	inc b
	ld a, [rBGPD]
	ld [hli], a
	dec c
	jr nz, .asm_b7d
	ld b, $0
	ld c, $20
.asm_b92
	ld a, b
	ld [rOBPI], a
	inc b
	ld a, [rOBPD]
	ld [hli], a
	ld a, b
	ld [rOBPI], a
	inc b
	ld a, [rOBPD]
	ld [hli], a
	dec c
	jr nz, .asm_b92
	ld de, rBGPI
	ld b, $2
.asm_ba8
	ld a, $80
	ld [de], a
	inc de
	ld c, $20
.asm_bae
	ld a, $ff
	ld [de], a
	ld [hli], a
	ld a, $7f
	ld [de], a
	ld [hli], a
	dec c
	jr nz, .asm_bae
	inc de
	dec b
	jr nz, .asm_ba8
	ret

FadeIn: ; 0xbbe
; Fades palettes in from white screen.
	ld a, [hGameBoyColorFlag]
	and a
	jp nz, FadeIn_GameboyColor
	; Regular Gameboy
	ld hl, hBGP
	ld de, wBGP
	ld b, $3
.loop
	ld a, [de]
	and $55
	ld c, a
	ld a, [de]
	and $aa
	srl a
	and c
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ld bc, $0002
	call AdvanceFrames
	ld hl, hBGP
	ld de, wBGP
	ld b, $3
.loop2
	ld a, [de]
	and $aa
	srl a
	add [hl]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop2
	ld bc, $0002
	call AdvanceFrames
	ld hl, hBGP
	ld de, wBGP
	ld b, $3
.loop3
	ld a, [de]
	and $55
	ld c, a
	ld a, [de]
	and $aa
	srl a
	or c
	add [hl]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop3
	ld bc, $0002
	call AdvanceFrames
	ret

FadeIn_GameboyColor: ; 0xc19
; Fades in to the target palette data in wPaletteData from wFadeBGPaletteData and wFadeOBJPaletteData
; Fade is completed after 16 frames of incrementally updating the palettes.
	ld b, 16 ; fade takes 16 frames to complete
.loop
	push bc
	ld de, wPaletteData
	ld hl, wFadeBGPaletteData
	call FadeInStep
	call SetFadedPalettes
	pop bc
	dec b
	jr nz, .loop
	ret

FadeInStep: ; 0xc2d
; de = base palette data
; hl = faded palette data
	ld a, b
	cp $1
	jr z, .lastStep
	ld c, $40 ; total number of colors in BG and OBJ palettes
.loop
	push bc
	ld a, [hli]
	sub $42
	ld c, a
	ld a, [hld]
	sbc $8
	ld b, a  ; subtracted 2 from each RGB value of the color
	call GetNextFadedPalette
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	pop bc
	dec c
	jr nz, .loop
	ret

.lastStep
	ld c, $40 ; total number of colors in BG and OBJ palettes
.loop2
	push bc
	ld a, [hli]
	sub $21
	ld c, a
	ld a, [hld]
	sbc $4
	ld b, a
	call GetNextFadedPalette
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	pop bc
	dec c
	jr nz, .loop2
	ret

GetNextFadedPalette: ; 0xc60
; de = source palette data
; bc = target palette RGB - 2
; Places the resulting palette RGB into bc
	push hl
	ld a, [de]
	and %00011111  ; Target RGB Blue value
	ld l, a
	ld a, c
	and %00011111  ; Current faded RBG Blue value - 2
	cp l
	jr nc, .brighter
	; set the current faded Blue value to the target blue value.
	ld a, c
	and %11100000
	or l
	ld c, a
.brighter
	ld a, [de]
	and %11100000
	ld l, a
	inc de
	ld a, [de]
	srl a
	rr l
	srl a
	rr l
	ld a, c
	and %11100000
	ld h, a
	ld a, b
	srl a
	rr h
	srl a
	rr h
	ld a, h
	cp l
	jr nc, .asm_ca3
	ld h, $0
	sla l
	rl h
	sla l
	rl h
	ld a, c
	and $1f
	or l
	ld c, a
	ld a, b
	and $7c
	or h
	ld b, a
.asm_ca3
	ld a, [de]
	and $7c
	ld l, a
	ld a, b
	and $7c
	cp l
	jr nc, .asm_cb2
	ld a, b
	and $3
	or l
	ld b, a
.asm_cb2
	inc de
	pop hl
	ret

FadeOut: ; 0xcb5
; Fades palettes out to a white screen.
	ld a, [hGameBoyColorFlag]
	and a
	jp nz, FadeOut_GameboyColor
	; Regular Gameboy
	ld hl, hBGP
	ld b, $3
.loop
	push bc
	push hl
	ld b, $3
.loop2
	ld a, [hl]
	and $55
	ld c, a
	ld a, [hl]
	and $aa
	srl a
	or c
	cpl
	inc a
	add [hl]
	ld [hli], a
	dec b
	jr nz, .loop2
	ld bc, $0002
	call AdvanceFrames
	pop hl
	pop bc
	dec b
	jr nz, .loop
	xor a
	ld hl, hBGP
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld bc, $0002
	call AdvanceFrames
	ret

FadeOut_GameboyColor: ; 0xcee
; Fades out to white RGB colors from the currently-loaded palettes.
; Fade is completed after 16 frames of incrementally updating the palettes.
	ld hl, wFadeBGPaletteData
	ld de, rBGPI
	call LoadCurrentPalettesIntoFadePalettes
	ld hl, wFadeOBJPaletteData
	ld de, rOBPI
	call LoadCurrentPalettesIntoFadePalettes
	ld b, 16 ; fade takes 16 frames to complete
.loop
	push bc
	ld hl, wFadeBGPaletteData
	call FadeOutStep
	call SetFadedPalettes
	pop bc
	dec b
	jr nz, .loop
	ret

FadeOutStep: ; 0xd11
; hl = faded palette data
	ld b, $40
.asm_d13
	ld a, [hl]
	and $1f
	add $2
	ld e, a
	cp $1f
	jr c, .asm_d1f
	ld e, $1f
.asm_d1f
	ld a, [hl]
	and $e0
	or e
	ld [hl], a
	ld a, [hli]
	and $e0
	ld e, [hl]
	dec hl
	srl e
	rr a
	srl e
	rr a
	add $10
	ld e, a
	jr nc, .asm_d38
	ld e, $f8
.asm_d38
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	ld a, [hl]
	and $1f
	or e
	ld [hli], a
	ld a, [hl]
	and $7c
	or d
	ld [hl], a
	ld a, [hl]
	and $7c
	add $8
	ld e, a
	cp $7c
	jr c, .asm_d58
	ld e, $7c
.asm_d58
	ld a, [hl]
	and $3
	or e
	ld [hli], a
	dec b
	jr nz, .asm_d13
	ret

SetFadedPalettes: ; 0d61
; Sets the current palette data to the faded palettes.
	ld a, [rIE]
	res 0, a
	ld [rIE], a
	ld hl, wFadeBGPaletteData
	ld de, rBGPI
	ld a, $80
	ld [de], a
	inc de
.waitForVBlank
	ld a, [rLY]
	cp $90
	jr c, .waitForVBlank
	ld b, $10
.loadBGColorsLoop
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .loadBGColorsLoop
	inc de
	ld a, $80
	ld [de], a
	inc de
	ld b, $10
.loadOBJColorsLoop
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .loadOBJColorsLoop
	ld a, [rIE]
	set 0, a
	ld [rIE], a
	ret

LoadCurrentPalettesIntoFadePalettes: ; 0xd9d
; hl = destination for palette data
; de = source of palettes (rBGPI or rOBPI)
	ld b, $0
	ld c, e
	inc c
	call WaitForLCD
.asm_da4
	call Func_61b
.asm_da7
	ld a, [rSTAT]
	and $3
	jr nz, .asm_da7  ; wait for lcd controller to finish transferring data
	ld a, b
	ld [de], a
	ld a, [$ff00+c]
	ld [hli], a
	inc b
	ld a, b
	ld [de], a
	ld a, [$ff00+c]
	ld [hli], a
	inc b
	ld a, b
	ld [de], a
	ld a, [$ff00+c]
	ld [hli], a
	inc b
	ld a, b
	ld [de], a
	ld a, [$ff00+c]
	ld [hli], a
	inc b
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ld a, b
	cp $40
	jr nz, .asm_da4
	ret
