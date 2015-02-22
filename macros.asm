INCLUDE "macros/sound.asm"

dbw: MACRO
	db \1
	dw \2
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

;\1 = X
;\2 = Y
;\3 = Reference Background Map (e.g. vBGMap0 or vBGMap1)
hlCoord: MACRO
	ld hl, \3 + $20 * \2 + \1
	ENDM
