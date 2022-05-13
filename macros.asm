; Constant enumeration is useful for mons, maps, etc.
MACRO const_def
	if _NARG >= 1
		DEF const_value = \1
	else
		DEF const_value = 0
	endc
	if _NARG >= 2
		DEF const_inc = \2
	else
		DEF const_inc = 1
	endc
ENDM

MACRO const
	DEF \1 EQU const_value
	DEF const_value = const_value + const_inc
ENDM

INCLUDE "macros/pokedex.asm"
INCLUDE "macros/scrolling_text.asm"
INCLUDE "macros/sound.asm"

DEF AdvanceFrame EQUS "$10"
DEF JumpTable EQUS "$18"
DEF ReadHalfword EQUS "$20"

DEF dex_text   EQUS "db "     ; Start beginning of pokedex description
DEF dex_line   EQUS "db $0d," ; Start new line in pokedex description
DEF dex_end    EQUS "db $00"  ; Terminate the pokedex description

MACRO dbw
	db \1
	dw \2
ENDM

MACRO dwb
	dw \1
	db \2
ENDM

MACRO dba
	dbw BANK(\1), \1
ENDM

MACRO dab
	dwb \1, BANK(\1)
ENDM

MACRO lb
	ld \1, (\2 << 8) | \3
ENDM

MACRO padded_dab
	dab \1
	db $00
ENDM

MACRO dn
	rept _NARG / 2
		db (\1) << 4 + (\2)
		shift
		shift
	endr
ENDM

MACRO dx
	DEF x = 8 * ((\1) - 1)
	rept \1
		db ((\2) >> x) & $ff
		DEF x = x + -8
	endr
ENDM

MACRO bigdw ; big-endian word
	dx 2, \1
ENDM

MACRO callba
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

MACRO bigBCD6
; There is probably a better name for this macro.
; It write a BCD in big-endian form.
	dn ((\1) / 10) % 10, (\1) % 10
	dn ((\1) / 1000) % 10, ((\1) / 100) % 10
	dn ((\1) / 100000) % 10, ((\1) / 10000) % 10
	dn ((\1) / 10000000) % 10, ((\1) / 1000000) % 10
	dn ((\1) / 1000000000) % 10, ((\1) / 100000000) % 10
	dn ((\1) / 100000000000) % 10, ((\1) / 10000000000) % 10
ENDM

;\1 = X
;\2 = Y
;\3 = Reference Background Map (e.g. vBGMap or vBGWin)
MACRO coord
	ld \1, \4 + $20 * \3 + \2
ENDM

DEF hlCoord EQUS "coord hl,"
DEF deCoord EQUS "coord de,"
DEF bcCoord EQUS "coord bc,"

DEF tile EQUS "+ $10 *"

;\1 = 5-bit Blue value
;\2 = 5-bit Green value
;\3 = 5-bit Red value
MACRO RGB
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

;\1 = pointer to 2bpp tile data
;\2 = destination for tile data in VRAM
;\3 = size of 2bpp tile data to copy
MACRO VIDEO_DATA_TILES
	dw \1
	db Bank(\1)
	dw \2
	dw (\3 << 2)
ENDM

;\1 = pointer to 2bpp tile data
;\2 = bank of data
;\3 = destination for tile data in VRAM
;\4 = size of 2bpp tile data to copy
MACRO VIDEO_DATA_TILES_BANK
	dw \1
	db \2
	dw \3
	dw (\4 << 2)
ENDM

;\1 = pointer to 2bpp tile data
;\2 = destination for tile data in VRAM
;\3 = size of 2bpp tile data to copy
MACRO VIDEO_DATA_TILES_BANK2
	dw \1
	db Bank(\1)
	dw \2
	dw (\3 << 2) | $2
ENDM

;\1 = pointer to tilemap data
;\2 = destination for tilemap data in VRAM
;\3 = size of tilemap to copy
MACRO VIDEO_DATA_TILEMAP
	VIDEO_DATA_TILES \1, \2, \3
ENDM

;\1 = pointer to tilemap data
;\2 = destination for tilemap data in VRAM
;\3 = size of tilemap to copy
MACRO VIDEO_DATA_TILEMAP_BANK2
	VIDEO_DATA_TILES_BANK2 \1, \2, \3
ENDM

;\1 = pointer to background attribute data
;\2 = destination for background attribute data in VRAM
;\3 = size of background attribute data to copy
MACRO VIDEO_DATA_BGATTR
	VIDEO_DATA_TILES_BANK2 \1, \2, \3
ENDM

;\1 = pointer to palette data
;\2 = size of palette data
MACRO VIDEO_DATA_PALETTES
	dw \1
	db Bank(\1)
	dw $0000
	dw (\2 << 1) | $1
ENDM
