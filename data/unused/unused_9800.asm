MACRO macro_9800
	FOR X, \1
		FOR Y, 0, $100, \1
			db (X + Y) & $ff
		endr
	endr
endm

Data_9800:

DEF w = $100
rept 8
	macro_9800 w
	DEF w = w >> 1
endr
