macro_9800: MACRO
x = 0
rept \1
y = 0
rept $100 / \1
	db (x + y) & $ff
y = y + \1
endr
x = x + 1
endr
endm

Data_9800:

w = $100
rept 8
	macro_9800 w
w = w >> 1
endr
