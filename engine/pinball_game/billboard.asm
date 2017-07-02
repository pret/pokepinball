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
