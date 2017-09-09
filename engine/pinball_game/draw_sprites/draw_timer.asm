DrawTimer: ; 0x175a4
	ld a, [wTimerActive]
	and a
	ret z
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, DrawTimer_GameBoyColor
	ld a, [wd580]
	and a
	ret z
	ld a, [wd581]
	and a
	jr z, .DrawTimer_GameBoy
	dec a
	ld [wd581], a
	ret

.DrawTimer_GameBoy
	call Func_1762f
	ld hl, wTimerDigits
	ld a, [wTimerMinutes]
	and $f
	call LoadTimerDigitTiles
	ld a, [wTimerSeconds]
	swap a
	and $f
	call LoadTimerDigitTiles
	ld a, [wTimerSeconds]
	and $f
	call LoadTimerDigitTiles
	ld d, $0
	ld hl, TimerOAMIds
	add hl, de
	ld a, [hli]
	call DrawTimerDigit
	ld a, [hli]
	call DrawTimerDigit
	ld a, [hli]
	call DrawTimerDigit
	ld a, [hli]
	call DrawTimerDigit
	ret

DrawTimer_GameBoyColor: ; 0x175f5
; Loads the OAM data for the timer in the top-right corner of the screen.
	ld a, [wTimerMinutes]
	and $f
	call DrawTimerDigit_GameBoyColor
	ld a, $a  ; colon
	call DrawTimerDigit_GameBoyColor
	ld a, [wTimerSeconds]
	swap a
	and $f
	call DrawTimerDigit_GameBoyColor  ; tens digit of the minutes
	ld a, [wTimerSeconds]
	and $f
	call DrawTimerDigit_GameBoyColor  ; ones digit of the minutes
	ret

TimerOAMIds:
	db $d7, $da, $d8, $d9
	db $dc, $df, $dd, $de
	db $dc, $db, $dd, $de
	db $f5, $f8, $f6, $f7

DrawTimerDigit_GameBoyColor: ; 0x17625
	add $b1  ; the timer digits' OAM ids start at $b1
DrawTimerDigit: ; 0x17627
	call LoadOAMData
	ld a, b
	add $8
	ld b, a
	ret

Func_1762f: ; 0x1762f
	lb de, $60, $0c
	ld a, [wCurrentStage]
	cp FIRST_BONUS_STAGE
	ret nc
	lb de, $00, $00
	bit 0, a
	ret z
	lb de, $30, $04
	ld a, [wInSpecialMode]
	and a
	ret z
	ld a, [wSpecialMode]
	and a
	ret nz
	lb de, $30, $08
	ret

LoadTimerDigitTiles: ; 0x1764f
	push bc
	push de
	cp [hl]
	jr z, .skip
	push af
	push hl
	add d
	call Func_17665
	pop hl
	pop af
	ld [hl], a
.skip
	inc hl
	pop de
	ld a, d
	add $10
	ld d, a
	pop bc
	ret

Func_17665: ; 0x17665
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, TimerDigitsTileData
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TimerDigitsTileData)
	call QueueGraphicsToLoad
	ret

INCLUDE "data/timer_digits_tiledata.asm"
