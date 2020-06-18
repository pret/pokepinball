dex_number: MACRO
	db ((\1 / 100) % 10) + "0"
	db ((\1 / 10) % 10) + "0"
	db ((\1 / 1) % 10) + "0"
	db "@"
	ENDM

; \1 = feet
; \2 = inches
dex_height: MACRO
feet_tens_digit = (\1 / 10) % 10
	IF feet_tens_digit == 0
	db " "
	ELSE
	db feet_tens_digit + "0"
	ENDC
feet_ones_digit = \1 % 10
	db feet_ones_digit + "0"
inches_tens_digit = (\2 / 10) % 10
	IF inches_tens_digit > 0
	db $70
	ELSE
	db $72
	ENDC
inches_ones_digit = \2 % 10
	db inches_ones_digit + "0"
	db "@"
	ENDM

dex_weight: MACRO
	IF \1 >= 1000
	db ((\1 / 1000) % 10) + "0"
	ELSE
	db " "
	ENDC

	IF \1 >= 100
	db ((\1 / 100) % 10) + "0"
	ELSE
	db " "
	ENDC

	IF \1 >= 10
	db ((\1 / 10) % 10) + "0"
	ELSE
	db " "
	ENDC

	db (\1 % 10) + "0"
	db $00, $83
	ENDM

dex_weight_decimal: MACRO
x = \1 * 10
	IF x >= 100
	db ((x / 100) % 10) + "0"
	ELSE
	db " "
	ENDC

	IF x >= 10
	db ((x / 100) % 10) + "0"
	ELSE
	db " "
	ENDC

	db (x % 10) + "0"
	db (\2 % 10) + "0"
	db $00, $FC
	ENDM

; \1 = species string
dex_species: MACRO
; Add right padding to format to 11 characters, define 2 bytes
; for each character (using dex_species_char below)
I = 0
    REPT STRLEN(\1)
I = I + 1
        dex_species_char STRSUB(\1\, I\, 1)
    ENDR
    REPT 11 - STRLEN(\1)
        dex_species_char " "
    ENDR
    db "@"
ENDM

dex_species_char: MACRO
	IF \1 == " "
	db $81, $40
	ELSE
	db $82, \1 + $1F
	ENDC
	ENDM
