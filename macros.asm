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

;\1 = X
;\2 = Y
;\3 = Reference Background Map (e.g. vBGMap0 or vBGMap1)
hlCoord: MACRO
	ld hl, \3 + $20 * \2 + \1
	ENDM
