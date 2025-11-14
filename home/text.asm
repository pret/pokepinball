INCLUDE "text/scrolling_text.asm"

EnableBottomText: ; 0x30db
	ld a, $86
	ldh [hWY], a ;force text bar up
	ld a, $1
	ld [wBottomTextEnabled], a
	ld [wDisableDrawScoreboardInfo], a
	ret

FillBottomMessageBufferWithBlackTile: ; 0x30e8 wipes the message buffer and disables all text
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
	ld [wScrollingText1Enabled], a
	ld [wScrollingText2Enabled], a
	ld [wScrollingText3Enabled], a
	ld [wStationaryText1], a
	ld [wStationaryText2], a
	ld [wStationaryText3], a
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

LoadMonNameIntoBottomMessageBufferList: ; 0x3125 increases address to load into by 64
	ld b, $1
	jr PlaceText

PlaceTextLow: ; 0x3129 disables special loads PlaceTextLow
	ld b, $0
PlaceText: ; 0x312b loads e chars of text text into de
	ld a, [wd805]
	and a
	jp nz, UnusedPlaceString ;unused alternate place string
.next_char
	ld a, [hli]
	and a
	ret z ;if a = 0, jump
	ld c, $81
	cp ' '
	jr z, .space
	cp ','
	jr z, .comma
	cp '♂'
	jr z, .male
	cp '♀'
	jr z, .female
	cp '`'
	jr z, .apostrophe
	cp '!'
	jr z, .exclamation
	cp 'x'
	jr z, .little_x
	cp 'e'
	jr z, .e_acute
	cp '*'
	jr z, .asterisk
	cp '.'
	jr z, .period
	cp ':'
	jr z, .colon
	cp '0'
	jr c, .check_AtoZ
	cp '9' + 1
	jr c, .digit
.check_AtoZ
	cp 'A'
	jr c, .invalid
	cp 'Z' + 1
	jr c, .alphabet
.invalid
	jr .next_char

.space
	ld a, c ;$81 = space
	jr .load_char

.comma
	inc c ;$82 = , , goes back a space?
	dec e
	jr .CheckLoadHieght

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
.CheckLoadHieght
	bit 0, b
	jr nz, .LowLoad ;only load special if b is 1
	set 7, e ;temporerally set 7 of e, adding  to pointer de or taking it away
	ld a, c
	ld [de], a
	res 7, e
.LowLoad
	inc e ;move to next slot
	jp .next_char

LoadSpecialTextChar: ; 0x31e1 copy special font data into VRAM based on the contents of a
	push bc
	push de
	push hl
	ld c, a
	ldh a, [hGameBoyColorFlag]
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

UnusedPlaceString: ; 0x3268 seems to place text based on different, confusing logic, but the enabling flag is never set above 0
	ld a, [hli]
	and a
	ret z
	ld c, $81 ;special space?
	cp ' '
	jr z, .Space ;space
	cp ','
	jr z, .Comma ;comma
	cp '0'
	jr c, .Punctuation ;less than 0 is punctuation
	cp '9' + 1
	jr c, .Digits ;less than colon is numbers, more than is a mix of punctuation and AtoZ
.Punctuation
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
	jr UnusedPlaceString

.asm_328f
	sub $80
	jr .asm_32a0

.asm_3293
	sub $50
	jr .asm_32a0

.Space
	ld a, c
	jr .asm_32a0

.Comma
	inc c
	dec e
	jr .asm_32a1

.Digits
	add $56
.asm_32a0
	ld [de], a
.asm_32a1
	set 7, e
	ld a, c
	ld [de], a
	res 7, e
	inc e
	jr UnusedPlaceString

LoadScrollingText: ; 0x32aa
; Loads scrolling text into the specified buffer.
; Scrolling text appears in a black bar at the bottom of the screen during pinball gameplay.
; Input: de = pointer to scrolling text data
;        hl = pointer to scrolling text header (See wScrollingText1)
; Scrolling text Header Format:
;	Byte 1: Step delay (in frames)
;	Byte 2: Starting wBottomMessageBuffer offset (wBottomMessageBuffer + $40 = left-most tile)
;	Byte 3: Stopping wBottomMessageBuffer offset (stops scrolling in the middle of the screen)
;	Byte 4: Number of steps to pause
;	Byte 5: Text offset in wBottomMessageText
;	Byte 6: Total number of steps in the entire scrolling animation
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
	ld a, '0'
	ld [de], a
	inc de
	ld a, ' '
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

HandleScrollingText: ; 0x3325 activates while text is scrolling
; Input: hl = pointer to scrolling_text struct
	ld a, [hli] ;if scrolling set to off, ret.
	and a
	ret z
	ld a, [hl]
	dec a ;decrement time until next scroll, if it is zero then process a scroll
	ld [hli], a
	ret nz
	ld a, [hld] ;reset the scroll timer
	ld [hl], a
	inc hl
	inc hl
	push hl
	ld a, [hli] ;retrieve current text start position from the struct, place in e for the PlaceText function
	ld e, a
	cp [hl] ; check if in the stop position
	inc hl
	jr nz, .NotInStopPosition
	ld a, [hl] ;lower stop position timer
	dec a
	ld [hl], a
	jr nz, .SkipScroll ;if stop timer not zero, prevent the scroll by setting e to the current position
.NotInStopPosition
	dec e ;decrement the text start position, causing the text to move 1 tile to the left
.SkipScroll
	push de
	ld d, wBottomMessageBuffer / $100 ;$c6
	inc hl
	push hl
	ld l, [hl] ;Retrieve text source pointer from Byte 7
	ld h, wBottomMessageText / $100
	call PlaceTextLow ;load text into destination e in text RAM
	pop hl
	inc hl
	ld a, [hl]
	dec a
	ld [hl], a ;dec Byte 8
	pop de
	pop hl ;+3
	ld [hl], e ;restore position into var 4
	ret nz ;if position = 0, switch scrolling off
	dec hl
	dec hl
	dec hl
	ld [hl], $0 ;+0
	ret

LoadStationaryTextAndHeader: ; 0x3357 LoadStationaryTextAndHeader
	ld a, $1
	ld [hli], a ;Enable and load StationaryText de. then load the text after it in until a $00 is loaded in
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
.Loop
	ld a, [de]
	ld [hli], a
	inc de
	and a
	jr nz, .Loop
	ret

LoadScoreTextFromStack: ; 0x3372 load stationary text header DE into HL, then load 4 byte BCD score from the stack into the buffer, ending in an 0 and space
	ld a, $1
	ld [hli], a ;load 1, then first 4 bytes of de into hl
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
	ld hl, sp + 5 ;access a 4 byte buffer stored previously on the stack
	lb bc, 8, 1
.Loop
	ld a, [hl]
	swap a
	and $f ;get 10's digit
	call LoadBCDDigitAsText
	dec b
	ld a, [hld]
	and $f ;get units digit
	call LoadBCDDigitAsText
	dec b
	jr nz, .Loop ;loop 4 times
	ld a, '0'
	ld [de], a
	inc de
	ld a, ' ' ;end with a 0 and a space
	ld [de], a
	inc de
	xor a
	ld [de], a
	ret

LoadBCDDigitAsText: ; 0x33a7 Enter BCD digit a into text DE. b is a loop counter and c is a "have you entered a digit yet" flag
	jr nz, .EnterDigit ;if no digit, not end of loop and not yet entered a digit, skip
	ld a, b
	dec a
	jr z, .EnterDigit
	ld a, c
	and a
	ret nz
.EnterDigit
	add '0' ;load digit into de
	ld [de], a
	inc de
	ld c, $0 ;mark that a digit has been entered
	ld a, b
	cp $6
	jr z, .EnterComma
	cp $3
	ret nz ;if b is 3 or 6, load a seperator comma into the text
.EnterComma
	ld a, ','
	ld [de], a
	inc de
	ret

HandleStationaryText: ; 0x33c3 Handles stationary text
	ld a, [hli] ;+1
	and a
	ret z ;ret if not enabled
	ld a, [hli] ;load buffer offset into e
	ld e, a
	ld d, wBottomMessageBuffer / $100
	push hl
	ld l, [hl] ;Place text from buffer into text
	ld h, wBottomMessageText / $100
	call PlaceTextLow
	pop hl
	inc hl ;decrement timer
	ld a, [hl]
	dec a
	ld [hli], a
	ret nz
	ld a, [hl]
	dec a
	ld [hld], a
	bit 7, a ;if Var5 <= 128, which is to say has not underflowed, ret, else disable text
	ret z
	dec hl
	dec hl
	dec hl
	ld [hl], $0
	ret

UpdateBottomText: ; 0x33e3
; Updates the scrolling and/or stationary text messages in the bottom black bar.
	ld a, [wBottomTextEnabled]
	and a
	jr nz, .textEnabled
	ld [wDisableDrawScoreboardInfo], a
	ret

.textEnabled
	ld c, $0
	ld a, [wScrollingText1Enabled]
	and a
	jr z, .Scrolling1Off ;if scrolling text is enabled, scroll text and inc c. repeat for each struct
	push bc
	ld hl, wScrollingText1
	call HandleScrollingText
	pop bc
	inc c
.Scrolling1Off
	ld a, [wScrollingText2Enabled]
	and a
	jr z, .Scrolling2Off
	push bc
	ld hl, wScrollingText2
	call HandleScrollingText
	pop bc
	inc c
.Scrolling2Off
	ld a, [wScrollingText3Enabled]
	and a
	jr z, .Scrolling3Off
	push bc
	ld hl, wScrollingText3
	call HandleScrollingText
	pop bc
	inc c
.Scrolling3Off
	ld a, [wStationaryText1]
	and a
	jr z, .Stationary1Off
	push bc
	ld hl, wStationaryText1
	call HandleStationaryText
	pop bc
	inc c
.Stationary1Off
	ld a, [wStationaryText2]
	and a
	jr z, .Stationary2Off
	push bc
	ld hl, wStationaryText2
	call HandleStationaryText
	pop bc
	inc c
.Stationary2Off
	ld a, [wStationaryText3]
	and a
	jr z, .Stationary3Off
	push bc
	ld hl, wStationaryText3
	call HandleStationaryText
	pop bc
	inc c
.Stationary3Off
	ld a, c
	and a
	ret nz ;if text has displayed, we are done, else
	ld [wBottomTextEnabled], a ; disable bottom text
	call FillBottomMessageBufferWithBlackTile ;fill with default data?
	ldh a, [hGameBoyColorFlag]
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

MainLoopUntilTextIsClear: ; 0x3475
	xor a
	ldh [hJoypadState], a
	ldh [hNewlyPressedButtons], a
	ldh [hPressedButtons], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a ;handle flippers if the stage has any
	callba nz, HandleFlippers
	callba DrawSpritesForStage
	call UpdateBottomText
	call CleanSpriteBuffer
	rst AdvanceFrame
	ld a, [wBottomTextEnabled]
	and a
	jr nz, MainLoopUntilTextIsClear ;loops until wBottomTextEnabled is zero
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
