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
	ld hl, TimerSpriteIds
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
; Loads the sprite data for the timer in the top-right corner of the screen.
	ld a, [wTimerMinutes]
	and $f
	call DrawTimerDigit_GameBoyColor
	ld a, $a  ; colon
	call DrawTimerDigit_GameBoyColor
	ld a, [wTimerSeconds]
	swap a
	and $f
	call DrawTimerDigit_GameBoyColor  ; tens digit of the seconds
	ld a, [wTimerSeconds]
	and $f
	call DrawTimerDigit_GameBoyColor  ; ones digit of the seconds
	ret

TimerSpriteIds:
	db SPRITE_TIMER_MINUTES_TOP, SPRITE_TIMER_COLON_TOP, SPRITE_TIMER_TENSECONDS_TOP, SPRITE_TIMER_ONESECONDS_TOP
	db SPRITE_TIMER_MINUTES_BOTTOM, SPRITE_TIMER_COLON_BOTTOM, SPRITE_TIMER_TENSECONDS_BOTTOM, SPRITE_TIMER_ONESECONDS_BOTTOM
	db SPRITE_TIMER_MINUTES_BOTTOM, SPRITE_TIMER_COLON_BOTTOMCATCHEM, SPRITE_TIMER_TENSECONDS_BOTTOM, SPRITE_TIMER_ONESECONDS_BOTTOM
	db SPRITE_TIMER_MINUTES_BONUS, SPRITE_TIMER_COLON_BONUS, SPRITE_TIMER_TENSECONDS_BONUS, SPRITE_TIMER_ONESECONDS_BONUS

DrawTimerDigit_GameBoyColor: ; 0x17625
	add SPRITE_TIMER_DIGIT
DrawTimerDigit: ; 0x17627
	call LoadSpriteData
	ld a, b
	add $8
	ld b, a
	ret

Func_1762f: ; 0x1762f
; determines which set of timer sprites to use based on the current board and board state
; returns: d : an index into TimerDigitsTileData
;          e : an index into TimerSpriteIds
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
