INCLUDE "macros/pokedex.asm"
INCLUDE "macros/scrolling_text.asm"
INCLUDE "macros/sound.asm"

AdvanceFrame EQUS "$10"
JumpTable EQUS "$18"
ReadHalfword EQUS "$20"

dex_text   EQUS "db "     ; Start beginning of pokedex description
dex_line   EQUS "db $0d," ; Start new line in pokedex description
dex_end    EQUS "db $00"  ; Terminate the pokedex description

dbw: MACRO
	db \1
	dw \2
	ENDM

dwb: MACRO
	dw \1
	db \2
	ENDM

dba: MACRO
	dbw BANK(\1), \1
	ENDM

dab: MACRO
	dwb \1, BANK(\1)
	ENDM

lb: MACRO
	ld \1, (\2 << 8) | \3
	ENDM

padded_dab: MACRO
	dab \1
	db $00
	ENDM

dn: MACRO
	rept _NARG / 2
	db (\1) << 4 + (\2)
	shift
	shift
	endr
	ENDM

dx: MACRO
x = 8 * ((\1) - 1)
	rept \1
	db ((\2) >> x) & $ff
x = x + -8
	endr
	ENDM

bigdw: MACRO ; big-endian word
	dx 2, \1
	ENDM

callba: MACRO
	ld [hFarCallTempA], a
	IF _NARG > 1
	ld a, BANK(\2)
	ld hl, \2
	call \1, BankSwitch
	ELSE
	ld a, BANK(\1)
	ld hl, \1
	call BankSwitch
	ENDC
	ENDM

bigBCD6: MACRO
; There is probably a better name for this macro.
; It write a BCD in big-endian form.
	dn ((\1) / 10) % 10, (\1) % 10
	dn ((\1) / 1000) % 10, ((\1) / 100) % 10
	dn ((\1) / 100000) % 10, ((\1) / 10000) % 10
	dn ((\1) / 10000000) % 10, ((\1) / 1000000) % 10
	dn ((\1) / 1000000000) % 10, ((\1) / 100000000) % 10
	dn ((\1) / 100000000000) % 10, ((\1) / 10000000000) % 10
	ENDM

; Constant enumeration is useful for mons, maps, etc.
const_def: MACRO
const_value = 0
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + 1
ENDM

;\1 = X
;\2 = Y
;\3 = Reference Background Map (e.g. vBGMap or vBGWin)
coord: MACRO
	ld \1, \4 + $20 * \3 + \2
	ENDM

hlCoord EQUS "coord hl,"
deCoord EQUS "coord de,"
bcCoord EQUS "coord bc,"

tile EQUS "+ $10 *"

;\1 = 5-bit Blue value
;\2 = 5-bit Green value
;\3 = 5-bit Red value
RGB: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
	ENDM

;\1 = pointer to 2bpp tile data
;\2 = destination for tile data in VRAM
;\3 = size of 2bpp tile data to copy
VIDEO_DATA_TILES: MACRO
	dw \1
	db Bank(\1)
	dw \2
	dw (\3 << 2)
	ENDM

;\1 = pointer to 2bpp tile data
;\2 = bank of data
;\3 = destination for tile data in VRAM
;\4 = size of 2bpp tile data to copy
VIDEO_DATA_TILES_BANK: MACRO
	dw \1
	db \2
	dw \3
	dw (\4 << 2)
	ENDM

;\1 = pointer to 2bpp tile data
;\2 = destination for tile data in VRAM
;\3 = size of 2bpp tile data to copy
VIDEO_DATA_TILES_BANK2: MACRO
	dw \1
	db Bank(\1)
	dw \2
	dw (\3 << 2) | $2
	ENDM
	
;\1 = pointer to tilemap data
;\2 = destination for tilemap data in VRAM
;\3 = size of tilemap to copy
VIDEO_DATA_TILEMAP: MACRO
	VIDEO_DATA_TILES \1, \2, \3
	ENDM

;\1 = pointer to tilemap data
;\2 = destination for tilemap data in VRAM
;\3 = size of tilemap to copy
VIDEO_DATA_TILEMAP_BANK2: MACRO
	VIDEO_DATA_TILES_BANK2 \1, \2, \3
	ENDM

;\1 = pointer to background attribute data
;\2 = destination for background attribute data in VRAM
;\3 = size of background attribute data to copy
VIDEO_DATA_BGATTR: MACRO
	VIDEO_DATA_TILES_BANK2 \1, \2, \3
	ENDM

;\1 = pointer to palette data
;\2 = size of palette data
VIDEO_DATA_PALETTES: MACRO
	dw \1
	db Bank(\1)
	dw $0000
	dw (\2 << 1) | $1
	ENDM
