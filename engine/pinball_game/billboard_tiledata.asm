LoadMapBillboardTileData: ; 0x30253
	ld a, [wCurrentMap]
	; fall through
LoadBillboardTileData: ; 0x30256
	sla a
	ld c, a
	ld b, $0
	push bc
	ld hl, BillboardTileDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BillboardTileDataPointers)
	call QueueGraphicsToLoad
	pop bc
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, BillboardPaletteDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BillboardPaletteDataPointers)
	call QueueGraphicsToLoad
	ret

INCLUDE "data/queued_tiledata/billboard.asm"
