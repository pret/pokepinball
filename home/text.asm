Func_30db: ; 0x30db
	ld a, $86
	ld [hWY], a
	ld a, $1
	ld [wd5ca], a
	ld [wd5cb], a
	ret

FillBottomMessageBufferWithBlackTile: ; 0x30e8
	ld a, $81
	ld hl, wBottomMessageBuffer
	ld b, $40
.loop
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .loop
	xor a
	ld [wd5cc], a
	ld [wd5d4], a
	ld [wd5dc], a
	ld [wd5e4], a
	ld [wd5e9], a
	ld [wd5ee], a
	ret

Func_310a: ; 0x310a
	ld a, $81
	ld hl, wBottomMessageBuffer + $40
	ld b, $5
.asm_3111
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_3111
	ld hl, wBottomMessageBuffer + $c0
	ld b, $5
.asm_311d
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_311d
	ret

LoadMonNameIntoBottomMessageBufferList: ; 0x3125 enables special loads
	ld b, $1
	jr asm_312b

Func_3129: ; 0x3129 disables special loads
	ld b, $0
asm_312b: ; 0x312b loads e chars of text text into de
	ld a, [wd805]
	and a
	jp nz, Func_3268 ;if ??? = 0, then continue, else jump
.next_char
	ld a, [hli]
	and a
	ret z ;if a = 0, jump
	ld c, $81
	cp " "
	jr z, .space
	cp ","
	jr z, .comma
	cp "♂"
	jr z, .male
	cp "♀"
	jr z, .female
	cp "`"
	jr z, .apostrophe
	cp "!"
	jr z, .exclamation
	cp "x"
	jr z, .little_x
	cp "e"
	jr z, .e_acute
	cp "*"
	jr z, .asterisk
	cp "."
	jr z, .period
	cp ":"
	jr z, .colon
	cp "0"
	jr c, .check_atoz
	cp "9" + 1
	jr c, .digit
.check_atoz
	cp "A"
	jr c, .invalid
	cp "Z" + 1
	jr c, .alphabet
.invalid
	jr .next_char

.space
	ld a, c ;$81 = space
	jr .load_char

.comma
	inc c ;$82 = , , goes back a space?
	dec e
	jr .check_special_load

.male
	xor a
	call LoadSpecialTextChar
	ld a, $83
	jr .load_char

.female
	ld a, $1
	call LoadSpecialTextChar
	ld a, $84
	jr .load_char

.apostrophe
	ld a, $2
	call LoadSpecialTextChar
	ld a, $85
	jr .load_char

.e_acute
	ld a, $3
	call LoadSpecialTextChar
	ld a, $83
	jr .load_char

.asterisk
	ld a, $4
	call LoadSpecialTextChar
	ld a, $87
	jr .load_char

.exclamation
	ld a, $5
	call LoadSpecialTextChar
	ld a, $85
	jr .load_char

.little_x
	ld a, $6
	call LoadSpecialTextChar
	ld a, $85
	jr .load_char

.period
	ld a, $7
	call LoadSpecialTextChar
	ld a, $86
	jr .load_char

.colon
	ld a, $8
	call LoadSpecialTextChar
	ld a, $83
	jr .load_char

.digit
	add $56
	jr .load_char

.alphabet
	add $bf
.load_char
	ld [de], a ;load char into de
.check_special_load
	bit 0, b
	jr nz, .no_special_load ;only load special if b is 1
	set 7, e ;tempererally set 7 of e, adding  to pointer de or taking it away
	ld a, c
	ld [de], a
	res 7, e
.no_special_load
	inc e ;move to next slot
	jp .next_char

LoadSpecialTextChar: ; 0x31e1 copy special font data into VRAM based on the contents of a
	push bc
	push de
	push hl
	ld c, a
	ld a, [hGameBoyColorFlag]
	and a
	ld a, c
	jr z, .asm_31ed
	add $9
.asm_31ed
	ld c, a
	sla a
	sla a
	add c
	ld c, a
	ld b, $0
	ld hl, SpecialTextCharPointers ;special text pointers
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b ;bytes taken are, in order, in e,d,a,l,h
	ld bc, $0010
	call LoadVRAMData ;copy 16 byte image into VRAM
	pop hl
	pop de
	pop bc
	ret

SpecialTextCharPointers:
	dw vTilesSH tile 3 ;start of special font data for LoadSpecialTextChar if DMG
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $40 ;bank of data, then pointer to source. each block is 5 bytes - male
	dw vTilesSH tile 4 ; female
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $30

	dw vTilesSH tile 5 ;apostrophe
	dbw Bank(Apostrophe_CharacterGfx), Apostrophe_CharacterGfx

	dw vTilesSH tile 3 ;acute e
	dbw Bank(E_Acute_CharacterGfx), E_Acute_CharacterGfx

	dw vTilesSH tile 7 ;asterisk
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $80

	dw vTilesSH tile 5 ;exclaiamation point
	dbw Bank(Exclamation_Point_CharacterGfx), Exclamation_Point_CharacterGfx

	dw vTilesSH tile 5 ;little x
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $10

	dw vTilesSH tile 6 ;period
	dbw Bank(Period_CharacterGfx), Period_CharacterGfx

	dw vTilesSH tile 3 ;colon
	dbw Bank(Colon_CharacterGfx), Colon_CharacterGfx

	dw vTilesSH tile 3 ;start of special font data for LoadSpecialTextChar if DMG
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $40 ;male

	dw vTilesSH tile 4 ;female
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $30

	dw vTilesSH tile 5 ;apostrophe
	dbw Bank(Apostrophe_CharacterGfx_GameboyColor), Apostrophe_CharacterGfx_GameboyColor

	dw vTilesSH tile 3 ;acute e
	dbw Bank(E_Acute_CharacterGfx_GameboyColor), E_Acute_CharacterGfx_GameboyColor

	dw vTilesSH tile 7 ;asterisk
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $80

	dw vTilesSH tile 5 ;exclaimation point
	dbw Bank(Exclamation_Point_CharacterGfx_GameboyColor), Exclamation_Point_CharacterGfx_GameboyColor

	dw vTilesSH tile 5 ;little x
	dbw Bank(InGameMenuSymbolsGfx), InGameMenuSymbolsGfx + $10

	dw vTilesSH tile 6 ;period
	dbw Bank(Period_CharacterGfx_GameboyColor), Period_CharacterGfx_GameboyColor

	dw vTilesSH tile 3 ;colon
	dbw Bank(Colon_CharacterGfx_GameboyColor), Colon_CharacterGfx_GameboyColor

Func_3268: ; 0x3268
	ld a, [hli]
	and a
	ret z
	ld c, $81
	cp $20
	jr z, .asm_3297
	cp $2c
	jr z, .asm_329a
	cp $30
	jr c, .asm_327d
	cp $3a
	jr c, .asm_329e
.asm_327d
	cp $a0
	jr c, .asm_3285
	cp $e0
	jr c, .asm_328f
.asm_3285
	cp $e0
	jr c, .asm_328d
	cp $f4
	jr c, .asm_3293
.asm_328d
	jr Func_3268

.asm_328f
	sub $80
	jr .asm_32a0

.asm_3293
	sub $50
	jr .asm_32a0

.asm_3297
	ld a, c
	jr .asm_32a0

.asm_329a
	inc c
	dec e
	jr .asm_32a1

.asm_329e
	add $56
.asm_32a0
	ld [de], a
.asm_32a1
	set 7, e
	ld a, c
	ld [de], a
	res 7, e
	inc e
	jr Func_3268

LoadTextHeader: ; 0x32aa
; Loads scrolling text into the specified buffer.
; Scrolling text appears in a black bar at the bottom of the screen during pinball gameplay.
; Input: de = pointer to scrolling text
;        hl = pointer to text header buffer
; Text Header Format:
;	Byte 1: Step delay (in frames)
;	Byte 2: Starting wBottomMessageBuffer offset (wBottomMessageBuffer + $40 = left-most tile)
;	Byte 3: Stopping wBottomMessageBuffer offset (stops scrolling in the middle of the screen)
;	Byte 4: Number of steps to pause
;	Byte 5: Text offset in wBottomMessageText
;	Byte 6: Total number of steps in the entire scolling animation
;	Remaining Bytes: Raw text to load
	ld a, $1
	ld [hli], a
	ld a, [de]
	ld [hli], a  ; frame delay counter
	ld [hli], a  ; frame delay
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	push af
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	pop af
	ld l, a
	ld h, wBottomMessageText / $100
.copyTextLoop
	ld a, [de]
	ld [hli], a
	inc de
	and a  ; cmp "@"
	jr nz, .copyTextLoop
	ret

Func_32cc: ; 0x32cc
	ld a, $1
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	push af
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	pop af
	ld e, a
	ld d, wBottomMessageText / $100
	ld hl, sp + 5
	lb bc, 8, 1
.asm_32ec
	ld a, [hl]
	swap a
	and $f
	call Func_3309
	dec b
	ld a, [hld]
	and $f
	call Func_3309
	dec b
	jr nz, .asm_32ec
	ld a, "0"
	ld [de], a
	inc de
	ld a, " "
	ld [de], a
	inc de
	xor a
	ld [de], a
	ret

Func_3309: ; 0x3309
	jr nz, .asm_3312
	ld a, b
	dec a
	jr z, .asm_3312
	ld a, c
	and a
	ret nz
.asm_3312
	add $30
	ld [de], a
	inc de
	ld c, $0
	ld a, b
	cp $6
	jr z, .asm_3320
	cp $3
	ret nz
.asm_3320
	ld a, $2c
	ld [de], a
	inc de
	ret

Func_3325: ; 0x3325
	ld a, [hli]
	and a
	ret z
	ld a, [hl]
	dec a
	ld [hli], a
	ret nz
	ld a, [hld]
	ld [hl], a
	inc hl
	inc hl
	push hl
	ld a, [hli]
	ld e, a
	cp [hl]
	inc hl
	jr nz, .asm_333c
	ld a, [hl]
	dec a
	ld [hl], a
	jr nz, .asm_333d
.asm_333c
	dec e
.asm_333d
	push de
	ld d, wBottomMessageBuffer / $100
	inc hl
	push hl
	ld l, [hl]
	ld h, wBottomMessageText / $100
	call Func_3129
	pop hl
	inc hl
	ld a, [hl]
	dec a
	ld [hl], a
	pop de
	pop hl
	ld [hl], e
	ret nz
	dec hl
	dec hl
	dec hl
	ld [hl], $0
	ret

Func_3357: ; 0x3357
	ld a, $1
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	push af
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	pop af
	ld l, a
	ld h, wBottomMessageText / $100
.asm_336b
	ld a, [de]
	ld [hli], a
	inc de
	and a
	jr nz, .asm_336b
	ret

Func_3372: ; 0x3372
	ld a, $1
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	push af
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	pop af
	ld e, a
	ld d, wBottomMessageText / $100
	ld hl, sp + 5
	lb bc, 8, 1
.asm_338a
	ld a, [hl]
	swap a
	and $f
	call Func_33a7
	dec b
	ld a, [hld]
	and $f
	call Func_33a7
	dec b
	jr nz, .asm_338a
	ld a, $30
	ld [de], a
	inc de
	ld a, $20
	ld [de], a
	inc de
	xor a
	ld [de], a
	ret

Func_33a7: ; 0x33a7
	jr nz, .asm_33b0
	ld a, b
	dec a
	jr z, .asm_33b0
	ld a, c
	and a
	ret nz
.asm_33b0
	add $30
	ld [de], a
	inc de
	ld c, $0
	ld a, b
	cp $6
	jr z, .asm_33be
	cp $3
	ret nz
.asm_33be
	ld a, $2c
	ld [de], a
	inc de
	ret

Func_33c3: ; 0x33c3
	ld a, [hli]
	and a
	ret z
	ld a, [hli]
	ld e, a
	ld d, wBottomMessageBuffer / $100
	push hl
	ld l, [hl]
	ld h, wBottomMessageText / $100
	call Func_3129
	pop hl
	inc hl
	ld a, [hl]
	dec a
	ld [hli], a
	ret nz
	ld a, [hl]
	dec a
	ld [hld], a
	bit 7, a
	ret z
	dec hl
	dec hl
	dec hl
	ld [hl], $0
	ret

Func_33e3: ; 0x33e3
	ld a, [wd5ca]
	and a
	jr nz, .asm_33ed
	ld [wd5cb], a
	ret

.asm_33ed
	ld c, $0
	ld a, [wd5cc]
	and a
	jr z, .asm_33fe
	push bc
	ld hl, wd5cc
	call Func_3325
	pop bc
	inc c
.asm_33fe
	ld a, [wd5d4]
	and a
	jr z, .asm_340d
	push bc
	ld hl, wd5d4
	call Func_3325
	pop bc
	inc c
.asm_340d
	ld a, [wd5dc]
	and a
	jr z, .asm_341c
	push bc
	ld hl, wd5dc
	call Func_3325
	pop bc
	inc c
.asm_341c
	ld a, [wd5e4]
	and a
	jr z, .asm_342b
	push bc
	ld hl, wd5e4
	call Func_33c3
	pop bc
	inc c
.asm_342b
	ld a, [wd5e9]
	and a
	jr z, .asm_343a
	push bc
	ld hl, wd5e9
	call Func_33c3
	pop bc
	inc c
.asm_343a
	ld a, [wd5ee]
	and a
	jr z, .asm_3449
	push bc
	ld hl, wd5ee
	call Func_33c3
	pop bc
	inc c
.asm_3449
	ld a, c
	and a
	ret nz
	ld [wd5ca], a
	call FillBottomMessageBufferWithBlackTile
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .gameboyColor
	ld a, Bank(StageRedFieldTopStatusBarSymbolsGfx_GameBoy)
	ld hl, $30 + StageRedFieldTopStatusBarSymbolsGfx_GameBoy
	ld de, $8830
	ld bc, $0040
	call LoadOrCopyVRAMData
	ret

.gameboyColor
	ld a, Bank(StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor)
	ld hl, $30 + StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor
	ld de, $8830
	ld bc, $0040
	call LoadOrCopyVRAMData
	ret

Func_3475: ; 0x3475
	xor a
	ld [hJoypadState], a
	ld [hNewlyPressedButtons], a
	ld [hPressedButtons], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, HandleFlippers
	callba DrawSpritesForStage
	call Func_33e3
	call CleanOAMBuffer
	rst AdvanceFrame
	ld a, [wd5ca]
	and a
	jr nz, Func_3475
	ret

FivePoints:       ; 34a6
	bigBCD6 000000000005
TenPoints:  ; 34ac
	bigBCD6 000000000010
OneHundredPoints:  ; 34b2
	bigBCD6 000000000100
FourHundredPoints: ; 34b8
	bigBCD6 000000000400
FiveHundredPoints: ; 34be
	bigBCD6 000000000500
OneThousandPoints:         ; 34c4
	bigBCD6 000000001000
FiveThousandPoints:        ; 34ca
	bigBCD6 000000005000
TenThousandPoints: ; 34d0
	bigBCD6 000000010000
OneHundredThousandPoints: ; 34d6
	bigBCD6 000000100000
ThreeHundredThousandPoints: ; 34dc
	bigBCD6 000000300000
FiveHundredThousandPoints: ; 34e2
	bigBCD6 000000500000
OneMillionPoints: ; 34e8
	bigBCD6 000001000000
FiveMillionPoints: ; 34ee
	bigBCD6 000005000000
TenMillionPoints: ; 34f4
	bigBCD6 000010000000
OneHundredMillionPoints: ; 34fa
	bigBCD6 000100000000

