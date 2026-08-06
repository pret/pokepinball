Func_61b: ; 0x61b
	ldh a, [rLY]  ; LY register (LCDC Y-Coordinate)
	cp $40
	jr c, .asm_625
	cp $80
	jr c, .asm_63d
.asm_625
	ldh a, [rLY]  ; LY register (LCDC Y-Coordinate)
	cp $40
	jr c, .asm_625
	cp $80
	jr nc, .asm_625
.asm_62f
	ldh a, [rSTAT]
	and $3
	jr nz, .asm_62f  ; wait for lcd controller to finish transferring data
	ld a, $15
.wait
	dec a
	jr nz, .wait
	nop
	nop
	nop
.asm_63d
	ret

__memset_8: ; 0xc3e
	dec bc
.fill_loop
	ld [hli], a
	dec bc
	bit 7, b
	jr z, .fill_loop
	ret

__memset_16:
	srl b
	rr c
.asm_064a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_064a
	ret

ClearData: ; 0x654
; Clears bc bytes starting at hl.
; bc can be a maximum of $7fff, since it checks bit 7 of b when looping.
	xor a
	dec bc
.clearLoop
	ld [hli], a
	dec bc
	bit 7, b
	jr z, .clearLoop
	ret

LocalCopyData: ; 0x65d
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, LocalCopyData
	ret

FarCopyData: ; 0x666 spooky
; Copies data from any bank to either working RAM or video RAM
; Input: hl = address of data to copy
;        a  = bank of data to copy
;        de = destination for data
;        bc = number of bytes to copy
	bit 7, h
	jr nz, .copyFromSRAM
	ldh [hROMBankBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	scf
	jr .copyData

.copyFromSRAM
	ld [MBC5SRamBank], a
	and a
.copyData
	push af
.copyLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .copyLoop
	pop af
	ret nc
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

ReadByteFromBank: ; 0x68f
; Input: a  = bank
;        hl = address of byte to read
; Output: a = byte at a:hl
	push de
	ld d, a
	ldh a, [hLoadedROMBank]
	ld e, a
	ld a, d
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ld d, [hl]
	ld a, e
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ld a, d
	pop de
	ret

LoadVideoData: ; 0x6a4
; Input:
;     hl = address of pointer table
;      a = index of item to load in pointer table
; This needs more documentation. It loads things like graphics and palettes.
	sla a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loadItem
	ld a, [hli]
	ld c, a
	and [hl]
	cp $ff      ; two consecutive $ff bytes terminate the array
	ret z
	ld a, [hli]
	ld b, a     ; bc contains pointer to data to be loaded
	push hl
	push bc
	ld a, [hli] ; a contains bank of data to be loaded
	ld e, [hl]
	inc hl
	ld d, [hl]  ; de contains destination address or palette offset for data
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]  ; bc contains size and flags
	inc hl      ; this is a wasted instruction
	pop hl
	call .autoCopyVideoData
	pop hl
	ld bc, $0005
	add hl, bc
	jr .loadItem

.autoCopyVideoData
; a: bank
; hl: source
; bc: flags and size rolled into one
; 	bit 0: CGB palette data if set, tile data else
; 	If tile data:
; 		bit 1: VBank
; 		de = dest
; 	Else:
; 		de = palette offset
; 	remaining bits: size
	srl b
	rr c
	jp c, FarCopyCGBPals  ; if lowest bit of bc is set
	jp .nopJump
.nopJump
	ldh [hROMBankBuffer], a  ; save bank of data to be loaded
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]  ; a contains bank of data to be loaded
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a  ; switch bank to the bank of data to be loaded
	srl b
	rr c
	rl a
	and $1  ; checks bit 1 of the last word in the data struct
	ldh [rVBK], a  ; set VRAM Bank
.copyByte
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b  ; does bc = 0?
	jr nz, .copyByte
	xor a
	ldh [rVBK], a  ; set VRAM Bank to Bank 0
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a  ; reload the previous ROM Bank
	ret

FarCopyCGBPals: ; 0x6fd
; a: bank
; hl: source
; e: dest offset
; bc: size
	ldh [hROMBankBuffer], a  ; save bank of data to be loaded
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]  ; a contains bank of data to be loaded
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a  ; switch bank to the bank of data to be loaded
	ld a, e
	bit 6, a
	jr nz, .do_obp
	ld de, rBGPI
	call .copyPaletteData
	jr z, .no_obp
	xor a
.do_obp
	ld de, rOBPI
	call .copyPaletteData
.no_obp
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

.copyPaletteData
	res 6, a ; only 64 bytes fit here
	ld b, a
	set 7, a ; auto-increment
	ld [de], a
	inc de
.copyByte
	ld a, [hli]
	ld [de], a
	inc b
	dec c
	ret z
	bit 6, b
	jr z, .copyByte
	ret

LoadOrCopyVRAMData: ; 0x735
	push hl
	ld hl, rLCDC
	bit 7, [hl]
	pop hl
	jp z, FarCopyData
	; fall through
LoadVRAMData: ; 0x73f
; This loads some data into VRAM. It waits for the LCD H-Blank to copy the data 4 bytes at a time.
; input:  hl = source of data
;          a = bank of data to load
;         de = destination of data
;         bc = number of bytes to copy
	bit 7, h
	jr nz, .asm_752
	ldh [hROMBankBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	scf
	jr .asm_756

.asm_752
	ld [MBC5SRamBank], a
	and a
.asm_756
	push af
	call WaitForLCD
.loop
	call Func_61b
.waitForHBlank
	ldh a, [rSTAT]
	and $3
	jr nz, .waitForHBlank
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
	dec bc
	dec bc
	dec bc
	dec bc
	nop
	nop
	nop
	nop
	ld a, b
	or c
	jr nz, .loop
	pop af
	ret nc
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

FarCopyPalettes: ; 0x790
	push hl
	ld hl, rLCDC
	bit 7, [hl]
	pop hl
	jp nz, Func_7dc
	bit 7, h
	jr nz, .asm_7ad
	ldh [hROMBankBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	scf
	jr .asm_7b1

.asm_7ad
	ld [MBC5SRamBank], a
	and a
.asm_7b1
	push af
	ld a, e
	bit 6, e
	ld de, rBGPI
	jr z, .asm_7bf
	res 6, a
	ld de, rOBPI
.asm_7bf
	set 7, a
	ld [de], a
	inc de
.asm_7c3
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	dec bc
	dec bc
	dec bc
	dec bc
	ld a, b
	or c
	jr nz, .asm_7c3
	pop af
	ret nc
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

Func_7dc: ; 0x7dc
	bit 7, h
	jr nz, .asm_7ef
	ldh [hROMBankBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	scf
	jr .asm_7f3

.asm_7ef
	ld [MBC5SRamBank], a
	and a
.asm_7f3
	push af
	ld a, e
	bit 6, e
	ld de, rBGPI
	jr z, .asm_801
	res 6, a
	ld de, rOBPI
.asm_801
	push hl
	ld h, d
	ld l, e
	set 7, a
	call PutTileInVRAM
	inc de
	pop hl
	call WaitForLCD
.asm_80e
	call Func_61b
.asm_811
	ldh a, [rSTAT]
	and $3
	jr nz, .asm_811
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [de], a
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
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec bc
	dec bc
	dec bc
	dec bc
	nop
	nop
	nop
	nop
	ld a, b
	or c
	jr nz, .asm_80e
	pop af
	ret nc
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

PutTileInVRAM: ; 0x848
; Puts a tile in VRAM.
; input:  a = tile number
;        hl = pointer to VRAM location where tile should be placed
	push af
	call WaitForLCD
	call Func_61b
.asm_84f
	ldh a, [rSTAT]
	and $3
	jr nz, .asm_84f  ; wait for lcd controller to finish transferring data
	pop af
	ld [hl], a  ; Store tile number in VRAM background map
	ret

Func_858: ; 0x858
	push af
	call WaitForLCD
	call Func_61b
.asm_85f
	ldh a, [rSTAT]
	and $3
	jr nz, .asm_85f
	ld a, $1
	ldh [rVBK], a
	pop af
	ld [hl], a
	xor a
	ldh [rVBK], a
	ret

LoadBillboardPaletteMap: ; 0x86f
; Loads the background palette map for a 6x4-tile billboard picture.
	ldh [hROMBankBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ldh a, [rLCDC]
	bit 7, a
	jr nz, .asm_8ac
	ld a, $1
	ldh [rVBK], a
	ld b, $4
.loop
	push bc
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld bc, $001a
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	xor a
	ldh [rVBK], a
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

.asm_8ac
	ld b, $4
.asm_8ae
	push bc
	ld a, [de]
	call Func_858
	inc hl
	inc de
	ld a, [de]
	call Func_858
	inc hl
	inc de
	ld a, [de]
	call Func_858
	inc hl
	inc de
	ld a, [de]
	call Func_858
	inc hl
	inc de
	ld a, [de]
	call Func_858
	inc hl
	inc de
	ld a, [de]
	call Func_858
	inc de
	ld bc, $001b
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_8ae
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

Func_8e1: ; 0x8e1
	ldh [hROMBankBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ldh a, [rLCDC]
	bit 7, a
	jr nz, .asm_902
	ld a, c
	ld [hli], a
.asm_8f5
	ld a, [de]
	ld [hl], a
	inc de
	dec b
	jr nz, .asm_8f5
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

.asm_902
	ld a, c
	call PutTileInVRAM
	inc hl
.asm_907
	ld a, [de]
	call PutTileInVRAM
	inc de
	dec b
	jr nz, .asm_907
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret
