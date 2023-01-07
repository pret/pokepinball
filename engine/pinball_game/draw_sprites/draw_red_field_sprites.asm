DrawSpritesRedFieldTop: ; 0x1755c
	ld bc, $7f00
	call DrawTimer
	call DrawVoltorbSprites
	call DrawDitto
	call DrawBellsproutHead
	call DrawBellsproutBody
	call DrawStaryu
	call DrawSpinner_RedField
	call DrawPinball
	call DrawEvolutionIndicatorArrows_RedFieldTop
	call DrawEvolutionTrinket_RedFieldTop
	ret

DrawSpritesRedFieldBottom: ; 0x1757e
	ld bc, $7f00
	call DrawTimer
	call DrawMonCaptureAnimation
	call DrawAnimatedMon_RedStage
	call DrawPikachuSavers_RedStage
	callba DrawFlippers
	call DrawPinball
	call DrawEvolutionIndicatorArrows_RedFieldBottom
	call DrawEvolutionTrinket_RedFieldBottom
	call DrawSlotGlow_RedField
	ret

INCLUDE "engine/pinball_game/draw_sprites/draw_timer.asm"

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
	db $26, $27, $28 ; animated sprite type 0
	db $29, $2A, $2B ; animated sprite type 1
	db $2C, $2D, $2E ; animated sprite type 2
	db $2F, $30, $31 ; animated sprite type 3

DrawVoltorbSprites: ; 0x17cc4
	ld de, wVoltorb1Animation
	ld hl, Voltorb1OAMData
	call DrawVoltorbSprite
	ld de, wVoltorb2Animation
	ld hl, Voltorb2OAMData
	call DrawVoltorbSprite
	ld de, wVoltorb3Animation
	ld hl, Voltorb3OAMData
	; fall through

DrawVoltorbSprite: ; 0x17cdc
	push hl
	ld hl, VoltorbAnimation
	call UpdateAnimation
	ld h, d
	ld l, e
	ld a, [hl]
	and a
	jr nz, .drawVoltorb
	call GenRandom
	and $7
	add $1e
	ld [hli], a
	ld a, $1
	ld [hli], a
	xor a
	ld [hl], a
.drawVoltorb
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

Voltorb1OAMData:
	db $3A, $4E ; x, y offsets
	db $00 ; which voltorb
	db $BD, $BC, $CE ; oam ids

Voltorb2OAMData:
	db $53, $44 ; x, y offsets
	db $01 ; which voltorb
	db $BD, $BC, $CD ; oam ids

Voltorb3OAMData:
	db $4D, $60 ; x, y offsets
	db $02 ; which voltorb
	db $BD, $BC, $CF ; oam ids

VoltorbAnimation:
; Each entry is [duration][OAM id]
	db $1E, $01
	db $02, $02
	db $03, $01
	db $02, $02
	db $03, $01
	db $02, $02
	db $00 ; terminator

DrawDitto: ; 0x17d34
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
	ld hl, DittoOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

DittoOAMIds:
	db $C9
	db $C9
	db $C9
	db $C9
	db $C8
	db $C8
	db $CA
	db $CA

DrawBellsproutHead: ; 0x17d59
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
	ld hl, BellsproutHeadAnimationOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

BellsproutHeadAnimationOAMIds: ; 0x17d76
	db $BE
	db $BF
	db $C0
	db $C1

DrawBellsproutBody: ; 0x17d7a
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

DrawStaryu: ; 0x17d92
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, StaryuAnimation
	ld de, wStaryuAnimation
	call UpdateAnimation
	ld a, [wStaryuAnimationFrameCounter]
	and a
	jr nz, .drawStaryu
	ld a, $13
	ld [wStaryuAnimationFrameCounter], a
	xor a
	ld [wStaryuAnimationFrame], a
	ld [wStaryuAnimationIndex], a
.drawStaryu
	ld a, $2b
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $69
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wStaryuAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, StaryuAnimationOAMIds
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

StaryuAnimationOAMIds: ; 0x17dce
	db $CB
	db $D0

StaryuAnimation:
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

DrawSpinner_RedField: ; 0x17de1
	ld a, $88
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $5a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wSpinnerState + 1]
	srl a
	srl a
	ld e, a
	ld d, $0
	ld hl, SpinnerOAMIds_RedField
	add hl, de
	ld a, [hl]
	call LoadOAMData
	ret

SpinnerOAMIds_RedField: ; 0x17e02
	db $C2, $C3, $C4, $C5, $C6, $C7

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
	ld a, [hFrameCounter]
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

INCLUDE "engine/pinball_game/draw_sprites/draw_pinball.asm"

DrawEvolutionIndicatorArrows_RedFieldTop: ; 0x17efb
	ld a, [wEvolutionObjectsDisabled]
	and a
	ret nz
	ld a, [hFrameCounter]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 5
	ld hl, EvolutionIndicatorArrowsOAM_RedFieldTop
	ld b, $6
	jr DrawEvolutionIndicatorArrows_RedField

DrawEvolutionIndicatorArrows_RedFieldBottom: ; 0x17f0f
	ld a, [wEvolutionObjectsDisabled]
	and a
	ret nz
	ld a, [hFrameCounter]
	bit 4, a
	ret z
	ld de, wIndicatorStates + 11
	ld hl, EvolutionIndicatorArrowsOAM_RedFieldBottom
	ld b, $8
DrawEvolutionIndicatorArrows_RedField: ; 0x17f21
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
	jr nz, DrawEvolutionIndicatorArrows_RedField
	ret

EvolutionIndicatorArrowsOAM_RedFieldTop:
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

EvolutionIndicatorArrowsOAM_RedFieldBottom:
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

DrawEvolutionTrinket_RedFieldTop: ; 0x17f64
	ld a, [wEvolutionObjectsDisabled]
	and a
	ret z
	ld de, wActiveEvolutionTrinkets
	ld hl, EvolutionTrinketOAMOffsets_RedFieldTop
	ld b, $c
	ld c, $39
	jr DrawEvolutionTrinket_RedField

DrawEvolutionTrinket_RedFieldBottom: ; 0x17f75
	ld a, [wEvolutionObjectsDisabled]
	and a
	ret z
	ld de, wActiveEvolutionTrinkets + 12
	ld hl, EvolutionTrinketOAMOffsets_RedFieldBottom
	ld b, $6
	ld c, $40
DrawEvolutionTrinket_RedField: ; 0x17f84
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
	ld a, [hFrameCounter]
	and $e
	jr nz, .asm_17f9c
	dec c
.asm_17f9c
	pop af
	call nz, LoadOAMData
	pop bc
	inc de
	dec b
	jr nz, DrawEvolutionTrinket_RedField
	ret

EvolutionTrinketOAMOffsets_RedFieldTop:
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

EvolutionTrinketOAMOffsets_RedFieldBottom:
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
