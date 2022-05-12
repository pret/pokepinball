MACRO macro_9800
	DEF x = 0
	rept \1
		DEF y = 0
		rept $100 / \1
			db (x + y) & $ff
			DEF y = y + \1
		endr
		DEF x = x + 1
	endr
endm

Data_9800:

w = $100
rept 8
	macro_9800 w
	DEF w = w >> 1
endr
