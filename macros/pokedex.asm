dex_number: MACRO
	db ((\1 / 100) % 10) + $30
	db ((\1 / 10) % 10) + $30
	db ((\1 / 1) % 10) + $30
	db $00
	ENDM

; \1 = feet
; \2 = inches
dex_height: MACRO
feet_tens_digit = (\1 / 10) % 10
	IF feet_tens_digit == 0
	db $20
	ELSE
	db feet_tens_digit + $30
	ENDC
feet_ones_digit = \1 % 10
	db feet_ones_digit + $30
inches_tens_digit = (\2 / 10) % 10
	IF inches_tens_digit > 0
	db $70
	ELSE
	db $72
	ENDC
inches_ones_digit = \2 % 10
	db inches_ones_digit + $30
	db $00
	ENDM

dex_weight: MACRO
	IF \1 >= 1000
	db ((\1 / 1000) % 10) + $30
	ELSE
	db $20
	ENDC

	IF \1 >= 100
	db ((\1 / 100) % 10) + $30
	ELSE
	db $20
	ENDC

	IF \1 >= 10
	db ((\1 / 10) % 10) + $30
	ELSE
	db $20
	ENDC

	db (\1 % 10) + $30
	db $00, $83
	ENDM

dex_weight_decimal: MACRO
x = \1 * 10
	IF x >= 100
	db ((x / 100) % 10) + $30
	ELSE
	db $20
	ENDC

	IF x >= 10
	db ((x / 100) % 10) + $30
	ELSE
	db $20
	ENDC

	db (x % 10) + $30
	db (\2 % 10) + $30
	db $00, $FC
	ENDM

dex_species: MACRO
	REPT _NARG
	dex_species_char \1
	SHIFT
	ENDR
	REPT 11 - _NARG
	dex_species_char " "
	ENDR
	db $00
	ENDM

dex_species_char: MACRO
	IF \1 == " "
	db $81, $40
	ELSE
	db $82, \1 + $1F
	ENDC
	ENDM
