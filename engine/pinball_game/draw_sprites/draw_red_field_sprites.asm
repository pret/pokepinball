DrawSpritesRedFieldTop: ; 0x1755c
	ld bc, $7f00
	call DrawTimer
	call DrawVoltorbSprites
	call Func_17d34
	call Func_17d59
	call Func_17d7a
	call Func_17d92
	call Func_17de1
	call DrawPinball
	call Func_17efb
	call Func_17f64
	ret

DrawSpritesRedFieldBottom: ; 0x1757e
	ld bc, $7f00
	call DrawTimer
	call DrawMonCaptureAnimation
	call DrawAnimatedMon_RedStage
	call DrawPikachuSavers_RedStage
	callba DrawFlippers
	call DrawPinball
	call Func_17f0f
	call Func_17f75
	call DrawSlotGlow_RedField
	ret

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

DrawMonCaptureAnimation: ; 0x17c67
	ld a, [wCapturingMon]
	and a
	ret z
	ld a, $50
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $38
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBallCaptureAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, BallCaptureAnimationOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

BallCaptureAnimationOAMIds:
	db $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $21, $22, $23, $24, $25

DrawAnimatedMon_RedStage: ; 0x17c96
	ld a, [wWildMonIsHittable]
	and a
	ret z
	ld a, $50
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $3e
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wCurrentAnimatedMonSpriteFrame]
	ld e, a
	ld d, $0
	ld hl, AnimatedMonOAMIds_RedStage
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

AnimatedMonOAMIds_RedStage:
	db $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31

DrawVoltorbSprites: ; 0x17cc4
	ld de, wVoltorb1Animation
	ld hl, OAMData_17d15
	call DrawVoltorbSprite
	ld de, wVoltorb2Animation
	ld hl, OAMData_17d1b
	call DrawVoltorbSprite
	ld de, wVoltorb3Animation
	ld hl, OAMData_17d21
	; fall through

DrawVoltorbSprite: ; 0x17cdc
	push hl
	ld hl, AnimationData_17d27
	call UpdateAnimation
	ld h, d
	ld l, e
	ld a, [hl]
	and a
	jr nz, .asm_17cf6
	call GenRandom
	and $7
	add $1e
	ld [hli], a
	ld a, $1
	ld [hli], a
	xor a
	ld [hl], a
.asm_17cf6
	pop hl
	inc de
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [wWhichAnimatedVoltorb]
	sub [hl]
	inc hl
	jr z, .asm_17d0c
	ld a, [de]
.asm_17d0c
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

OAMData_17d15:
	db $3A, $4E ; x, y offsets
	db $00 ; ???
	db $BD, $BC, $CE ; oam ids

OAMData_17d1b:
	db $53, $44 ; x, y offsets
	db $01 ; ???
	db $BD, $BC, $CD ; oam ids

OAMData_17d21:
	db $4D, $60 ; x, y offsets
	db $02 ; ???
	db $BD, $BC, $CF ; oam ids

AnimationData_17d27:
; Each entry is [duration][OAM id]
	db $1E, $01
	db $02, $02
	db $03, $01
	db $02, $02
	db $03, $01
	db $02, $02
	db $00 ; terminator

Func_17d34: ; 0x17d34
	ld a, $0
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wStageCollisionState]
	ld e, a
	ld d, $0
	ld hl, OAMIds_17d51
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

OAMIds_17d51:
	db $C9
	db $C9
	db $C9
	db $C9
	db $C8
	db $C8
	db $CA
	db $CA

Func_17d59: ; 0x17d59
	ld a, $74
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $52
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBellsproutAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, BellsproutAnimationOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

BellsproutAnimationOAMIds: ; 0x17d76
	db $BE
	db $BF
	db $C0
	db $C1

Func_17d7a: ; 0x17d7a
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld a, $67
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $54
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, $cc
	call LoadOAMData
	ret

Func_17d92: ; 0x17d92
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, AnimationData_17dd0
	ld de, wd504
	call UpdateAnimation
	ld a, [wd504]
	and a
	jr nz, .asm_17db1
	ld a, $13
	ld [wd504], a
	xor a
	ld [wd505], a
	ld [wd506], a
.asm_17db1
	ld a, $2b
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $69
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd505]
	ld e, a
	ld d, $0
	ld hl, OAMIds_17dce
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

OAMIds_17dce: ; 0x17dce
	db $CB
	db $D0

AnimationData_17dd0:
; Each entry is [duration][OAM id]
	db $14, $00
	db $13, $01
	db $15, $00
	db $12, $01
	db $14, $00
	db $13, $01
	db $16, $00
	db $13, $01
	db $0 ; terminator

Func_17de1: ; 0x17de1
	ld a, $88
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $5a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd50a]
	srl a
	srl a
	ld e, a
	ld d, $0
	ld hl, OAMIds_17e02
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

OAMIds_17e02: ; 0x17e02
	db $C2
	db $C3
	db $C4
	db $C5
	db $C6
	db $C7

DrawPikachuSavers_RedStage: ; 0x17e08
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	ld a, [wWhichPikachuSaverSide]
	jr z, .asm_17e33
	ld a, [wd51c]
	and a
	jr nz, .asm_17e29
	ld a, [hNumFramesDropped]
	srl a
	srl a
	srl a
	and $1
	jr .asm_17e33

.asm_17e29
	ld a, [wBallXPos + 1]
	cp $50
	ld a, $1
	jr nc, .asm_17e33
	xor a
.asm_17e33
	sla a
	ld c, a
	ld b, $0
	ld hl, PikachuSaverOAMOffsets_RedStage
	add hl, bc
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	ld a, [wPikachuSaverAnimationFrame]
	add $e
	call LoadOAMData
	ret

PikachuSaverOAMOffsets_RedStage:
	dw $7E0F
	dw $7E92

Func_17e4f: ; 0x17e4f
; unused
	ld hl, UnusedData_7e55
	jp Func_17e5e

UnusedData_7e55: ; 0x17e55
	db $00, $2B, $69, $CB, $00, $67, $54, $CC
	db $FF

Func_17e5e: ; 0x17e5e
; unused
	ld a, [hGameBoyColorFlag]
	ld e, a
	ld a, [hSCX]
	ld d, a
.asm_17e64
	ld a, [hli]
	cp $ff
	ret z
	or e
	jr nz, .asm_17e70
	inc hl
	inc hl
	inc hl
	jr .asm_17e64
.asm_17e70
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hli]
	bit 0, e
	call nz, LoadOAMData
	jr .asm_17e64

DrawPinball: ; 0x17e81
	ld a, [wPinballIsVisible]
	and a
	ret z
	ld hl, wBallSpin
	ld a, [wBallRotation]
	add [hl]
	ld [wBallRotation], a
	ld a, [wBallXPos + 1]
	inc a
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wBallYPos + 1]
	inc a
	sub $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBallRotation]
	srl a
	srl a
	srl a  ; divide wBallRotation by 8 because
	srl a  ; there are 8 frames of the ball spinning
	and $7
	add $0
	call LoadOAMData
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld a, [hSGBFlag]
	and a
	ret nz
	ld a, [wd4c5]
	inc a
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wd4c6]
	inc a
	sub $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd4c7]
	srl a
	srl a
	srl a
	srl a
	and $7
	add $0
	call LoadOAMData
	ld a, [wBallXPos + 1]
	ld [wd4c5], a
	ld a, [wBallYPos + 1]
	ld [wd4c6], a
	ld a, [wBallRotation]
	ld [wd4c7], a
	ret

Func_17efb: ; 0x17efb
	ld a, [wd551]
	and a
	ret nz
	ld a, [hNumFramesDropped]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 5
	ld hl, OAMData_17f3a
	ld b, $6
	jr asm_17f21

Func_17f0f: ; 0x17f0f
	ld a, [wd551]
	and a
	ret nz
	ld a, [hNumFramesDropped]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 11
	ld hl, OAMData_17f4c
	ld b, $8
asm_17f21: ; 0x17f21
	push bc
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [de]
	and a
	ld a, [hli]
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, asm_17f21
	ret

OAMData_17f3a:
	db $0D, $37 ; x, y offsets
	db $D1 ; oam id

	db $46, $22 ; x, y offsets
	db $D6 ; oam id

	db $8A, $4A ; x, y offsets
	db $D2 ; oam id

	db $41, $81 ; x, y offsets
	db $D3 ; oam id

	db $3D, $65 ; x, y offsets
	db $D5 ; oam id

	db $73, $74 ; x, y offsets
	db $D4 ; oam id

OAMData_17f4c:
	db $2D, $13 ; x, y offsets
	db $32 ; oam id

	db $6A, $13 ; x, y offsets
	db $33 ; oam id

	db $25, $2D ; x, y offsets
	db $34 ; oam id

	db $73, $2D ; x, y offsets
	db $35 ; oam id

	db $0F, $40 ; x, y offsets
	db $36 ; oam id

	db $1F, $40 ; x, y offsets
	db $36 ; oam id

	db $79, $40 ; x, y offsets
	db $37 ; oam id

	db $89, $40 ; x, y offsets
	db $37 ; oam id

Func_17f64: ; 0x17f64
	ld a, [wd551]
	and a
	ret z
	ld de, wd566
	ld hl, OAMOffsets_17fa6
	ld b, $c
	ld c, $39
	jr asm_17f84

Func_17f75: ; 0x17f75
	ld a, [wd551]
	and a
	ret z
	ld de, wd572
	ld hl, OAMOffsets_17fbe
	ld b, $6
	ld c, $40
asm_17f84: ; 0x17f84
	push bc
	ld a, [de]
	add c
	cp c
	push af
	ld a, [hSCX]
	ld b, a
	ld a, [hli]
	sub b
	ld b, a
	ld a, [hSCY]
	ld c, a
	ld a, [hli]
	sub c
	ld c, a
	ld a, [hNumFramesDropped]
	and $e
	jr nz, .asm_17f9c
	dec c
.asm_17f9c
	pop af
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, asm_17f84
	ret

OAMOffsets_17fa6:
; x, y offsets
	db $4C, $0C
	db $32, $12
	db $66, $12
	db $19, $25
	db $7F, $25
	db $1E, $36
	db $7F, $36
	db $0E, $65
	db $8B, $65
	db $49, $7A
	db $59, $7A
	db $71, $7A

OAMOffsets_17fbe:
; x, y offsets
	db $3D, $13
	db $5B, $13
	db $31, $17
	db $67, $17
	db $2E, $2C
	db $6A, $2C

DrawSlotGlow_RedField: ; 0x17fca
; Draws the glowing animation surround the slot cave entrance.
	ld a, [wSlotIsOpen]
	and a
	ret z
	ld a, [wSlotGlowingAnimationCounter]
	inc a
	ld [wSlotGlowingAnimationCounter], a
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $1
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wSlotGlowingAnimationCounter]
	srl a
	srl a
	srl a
	and $3
	add $4f
	cp $52
	call nz, LoadOAMData
	ret
