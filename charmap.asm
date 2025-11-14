	charmap "@", $00
	charmap " ", $20
	charmap "!", $21
	charmap "♂", $24
	charmap "*", $2A
	charmap ",", $2C
	charmap "-", $2D
	charmap ".", $2E
	charmap ":", $3A
	charmap "é", $40
	charmap "♀", $5C
	charmap "`", $60

DEF chars EQUS "0123456789"
FOR x, STRLEN(#chars)
	charmap STRSLICE(#chars, x, x + 1), $30 + x
ENDR

REDEF chars EQUS "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
FOR x, STRLEN(#chars)
	charmap STRSLICE(#chars, x, x + 1), $41 + x
ENDR

REDEF chars EQUS "abcdefghijklmnopqrstuvwxyz"
FOR x, STRLEN(#chars)
	charmap STRSLICE(#chars, x, x + 1), $61 + x
ENDR
