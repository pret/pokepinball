HandleFlippers: ; 0xe0fe
	xor a
	ld [wFlipperCollision], a
	ld [hFlipperYCollisionAttribute], a
	ld [wFlipperXForce], a
	ld [wFlipperXForce + 1], a
	call Func_e118
	call CheckFlipperCollision
	ld a, [wFlipperCollision]
	and a
	call nz, HandleFlipperCollision
	ret

Func_e118: ; 0xe118
	call PlayFlipperSoundIfPressed
	ld a, [wd7af]
	ld [wLeftFlipperAnimationState], a
	ld a, [wd7b3]
	ld [wRightFlipperAnimationState], a
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	ld hl, -$0333
	jr z, .asm_e13b
	ld a, [wFlippersDisabled]
	and a
	jr nz, .asm_e13b
	ld hl,  $0333
.asm_e13b
	ld a, [wd7af]
	and a
	jr nz, .asm_e145
	bit 7, h
	jr nz, .asm_e14d
.asm_e145
	cp $f
	jr nz, .asm_e150
	bit 7, h
	jr nz, .asm_e150
.asm_e14d
	ld hl, $0000
.asm_e150
	ld a, l
	ld [wd7b0], a
	ld a, h
	ld [wd7b1], a
	ld a, [wd7ae]
	ld c, a
	ld a, [wd7af]
	ld b, a
	add hl, bc
	bit 7, h
	jr nz, .asm_e16f
	ld a, h
	cp $10
	jr c, .asm_e172
	ld hl, $0f00
	jr .asm_e172

.asm_e16f
	ld hl, $0000
.asm_e172
	ld a, l
	ld [wd7ae], a
	ld a, h
	ld [wd7af], a
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ld hl, -$0333
	jr z, .asm_e18e
	ld a, [wFlippersDisabled]
	and a
	jr nz, .asm_e18e
	ld hl,  $0333
.asm_e18e
	ld a, [wd7b3]
	and a
	jr nz, .asm_e198
	bit 7, h
	jr nz, .asm_e1a0
.asm_e198
	cp $f
	jr nz, .asm_e1a3
	bit 7, h
	jr nz, .asm_e1a3
.asm_e1a0
	ld hl, $0000
.asm_e1a3
	ld a, l
	ld [wd7b4], a
	ld a, h
	ld [wd7b4 + 1], a
	ld a, [wd7b2]
	ld c, a
	ld a, [wd7b3]
	ld b, a
	add hl, bc
	bit 7, h
	jr nz, .asm_e1c2
	ld a, h
	cp $10
	jr c, .asm_e1c5
	ld hl, $0f00
	jr .asm_e1c5

.asm_e1c2
	ld hl, $0000
.asm_e1c5
	ld a, l
	ld [wd7b2], a
	ld a, h
	ld [wd7b3], a
	ret

PlayFlipperSoundIfPressed: ; 0xe1ce
	ld a, [wFlippersDisabled]
	and a
	ret nz
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_e1e2
	lb de, $00, $0c
	call PlaySoundEffect
	ret

.asm_e1e2
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	lb de, $00, $0c
	call PlaySoundEffect
	ret

CheckFlipperCollision: ; 0xe1f0
	ld a, [wBallXPos + 1]
	cp $50  ; which half of the screen is the ball in?
	jp nc, CheckRightFlipperCollision ; right half of screen
	; fall through
CheckLeftFlipperCollision:
	ld hl, wBallXPos
	ld c, $ba
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [wLeftFlipperAnimationState]
	ld [$ffc2], a
	ld a, [wd7af]
	ld [$ffc3], a
	call ReadFlipperCollisionAttributes
	ld a, [wFlipperCollision]
	and a
	ret z
	ld a, [wd7b0]
	ld [$ffc0], a
	ld a, [wd7b1]
	ld [$ffc1], a
	ret

CheckRightFlipperCollision: ; 0xe226
; ball is in right half of screen
	ld hl, wBallXPos
	ld c, $ba
	ld a, [hli]
	sub $1
	cpl
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	sbc $a0
	cpl
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [wRightFlipperAnimationState]
	ld [$ffc2], a
	ld a, [wd7b3]
	ld [$ffc3], a
	call ReadFlipperCollisionAttributes
	ld a, [wFlipperCollision]
	and a
	ret z
	; collision with flipper occurred
	ld a, [wd7b4]
	ld [$ffc0], a
	ld a, [wd7b4 + 1]
	ld [$ffc1], a
	ret

ReadFlipperCollisionAttributes: ; 0xe25a
	ld a, [$ffbb]  ; ball x-position high byte
	sub $2b        ; check if ball is in x-position range of flippers
	ret c
	cp $30
	ret nc
	; ball is in x-position range of flippers
	ld [$ffbb], a  ; x offset of flipper horizontal range
	ld a, [$ffbd]  ; ball y-position high byte
	sub $7b        ; check if ball is in y-position range of flippers
	ret c
	cp $20
	ret nc
	; ball is in potential collision with flippers
	ld [$ffbd], a  ; y offset of flipper vertical range
	ld a, [$ffc2]  ; flipper animation state
.asm_e270
	push af
	ld l, $0
	ld h, a  ; multiply a by 0x600
	sla a
	sla h
	sla h
	add h
	ld h, a        ; hl = a * 0x600  (this is the length of the flipper collision attributes)
	ld a, [$ffbb]  ; x offset of flipper horizontal range
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b   ; bc = (x offset of flipper horizontal range) * 32
	; Each row of the flipper collision attributes is 32 bytes long.
	add hl, bc  ; hl points to the start of the row in the flipper collisoin attributes
	ld a, [$ffbd]  ; y offset of flipper vertical range
	ld c, a
	ld b, $0
	add hl, bc  ; hl points to the attribute byte in the flipper collision attributes
	ld d, h
	ld e, l  ; de points to the attribute byte in the flipper collision attributes
	ld a, h
	cp $40
	jr nc, .secondBank
	add $40
	ld h, a
	ld a, Bank(FlipperHorizontalCollisionAttributes)
	jr .readAttributeByte

.secondBank
	ld a, Bank(FlipperHorizontalCollisionAttributes2)
.readAttributeByte
	call ReadByteFromBank
	ld b, a
	and a
	jr nz, .collision
	; no collision
	pop af  ; a = flipper animation state(?)
	ld hl, $ffc3
	cp [hl]
	ret z
	jr c, .asm_e2be
	dec a
	jr .asm_e270

.asm_e2be
	inc a
	jr .asm_e270

.collision
	pop af  ; a = flipper animation state(?)
	ld a, b  ; a = collision attribute
	ld [hFlipperYCollisionAttribute], a
	ld h, d
	ld l, e
	ld a, h
	cp $20
	jr nc, .asm_e2d3
	add $60
	ld h, a
	ld a, Bank(FlipperVerticalCollisionAttributes)
	jr .asm_e2d8

.asm_e2d3
	add $20
	ld h, a
	ld a, Bank(FlipperVerticalCollisionAttributes2)
.asm_e2d8
	call ReadByteFromBank
	ld [wFlipperXCollisionAttribute], a
	ld a, $1
	ld [wFlipperCollision], a
	ret

Func_e2e4:
	ld a, c
	or b
	or l
	or h
	or e
	or d
	jr nz, .asm_e2f3
	ld a, [$ffba]
	ld e, a
	ld a, [$ffbb]
	ld d, a
	ret

.asm_e2f3
	ld a, d
	xor h
	push af
	bit 7, d
	jr z, .asm_e301
	ld a, e
	cpl
	ld e, a
	ld a, d
	cpl
	ld d, a
	inc de
.asm_e301
	bit 7, h
	jr z, .asm_e317
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc bc
	ld a, b
	or c
	jr nz, .asm_e317
	inc hl
.asm_e317
	push bc
	ld c, $11
	ld a, d
	or e
	jr nz, .asm_e324
	pop bc
	ld de, $7fff
	jr .asm_e36a

.asm_e324
	bit 7, d
	jr nz, .asm_e32f
	sla e
	rl d
	inc c
	jr .asm_e324

.asm_e32f
	ld a, c
	ld [$ff8c], a
	pop bc
	xor a
	ld [$ff8d], a
	ld [$ff8e], a
.asm_e338
	jr c, .asm_e344
	ld a, d
	cp h
	jr nz, .asm_e342
	ld a, e
	cp l
	jr z, .asm_e344
.asm_e342
	jr nc, .asm_e34b
.asm_e344
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	scf
.asm_e34b
	ld a, [$ff8d]
	rla
	ld [$ff8d], a
	ld a, [$ff8e]
	rla
	ld [$ff8e], a
	sla c
	rl b
	rl l
	rl h
	ld a, [$ff8c]
	dec a
	ld [$ff8c], a
	jr nz, .asm_e338
	ld a, [$ff8d]
	ld e, a
	ld a, [$ff8e]
	ld d, a
.asm_e36a
	pop af
	bit 7, a
	ret z
	ld a, e
	sub $1
	cpl
	ld e, a
	ld a, d
	sbc $0
	cpl
	ld d, a
	ret

Func_e379: ; 0xe379
	ld a, b
	xor d
	ld [$ffbe], a
	bit 7, b
	jr z, .asm_e388
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_e388
	bit 7, d
	jr z, .asm_e393
	ld a, e
	cpl
	ld e, a
	ld a, d
	cpl
	ld d, a
	inc de
.asm_e393
	push bc
	push de
	ld c, d
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld c, e
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld b, d
	call Func_e410
	pop de
	pop bc
	push hl
	ld b, e
	call Func_e410
	ld c, l
	ld l, h
	xor a
	ld h, a
	pop de
	add hl, de
	rl a
	pop de
	add hl, de
	jr nc, .asm_e3bf
	inc a
.asm_e3bf
	ld b, l
Data_e3c0:
	ld l, h
	ld h, a
	pop de
	add hl, de
	ld a, [$ffbe]
	bit 7, a
	ret z
	ld a, c
	sub $1
	cpl
	ld c, a
	ld a, b
	sbc $0
	cpl
	ld b, a
	ld a, l
	sbc $0
	cpl
	ld l, a
	ld a, h
	sbc $0
	cpl
	ld h, a
	ret

Func_e3de:
	push bc
	push de
	ld c, d
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld c, e
	call Func_e410
	pop de
	pop bc
	push hl
	push bc
	push de
	ld b, d
	call Func_e410
	pop de
	pop bc
	push hl
	ld b, e
	call Func_e410
	ld c, l
	ld l, h
	xor a
	ld h, a
	pop de
	add hl, de
	rl a
	pop de
	add hl, de
	jr nc, .asm_e40a
	inc a
.asm_e40a
	ld b, l
	ld l, h
	ld h, a
	pop de
	add hl, de
	ret

Func_e410: ; 0xe410
	ld a, b
	cp c
	jr nc, .asm_e416
	ld b, c
	ld c, a
.asm_e416
	ld h, $3e
	ld l, c
	ld e, [hl]
	inc h
	ld d, [hl]
	ld l, b
	ld a, [hl]
	dec h
	ld l, [hl]
	ld h, a
	add hl, de
	push af
	ld d, $3e
	ld a, b
	sub c
	ld e, a
	ld a, [de]
	ld c, a
	inc d
	ld a, [de]
	ld b, a
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	jr nc, .asm_e43c
	pop af
	ccf
	rr h
	rr l
	ret

.asm_e43c
	pop af
	rr h
	rr l
	ret

HandleFlipperCollision: ; 0xe442
; This is called when the ball is colliding with either the
; right or left flipper.
	ld a, $1
	ld [wd7e9], a
	xor a
	ld [wBallPositionPointerOffsetFromStageTopLeft], a
	ld [wBallPositionPointerOffsetFromStageTopLeft + 1], a
	ld [wCurCollisionAttribute], a
	ld [wd7f6], a
	ld [wd7f7], a
	ld a, [hFlipperYCollisionAttribute]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_e538
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [$ffc0]
	ld e, a
	ld a, [$ffc1]
	ld d, a
	sla e
	rl d
	sla e
	rl d  ; multiplied de by 4
	call Func_e379
	ld a, b
	ld [wFlipperYForce], a
	ld a, l
	ld [wFlipperYForce + 1], a
	ld a, [wBallXPos + 1]
	cp $50  ; which flipper did the ball hit?
	ld a, [wFlipperXCollisionAttribute]
	jr c, .asm_e48b
	cpl  ; invert the x collision attribute
	inc a
.asm_e48b
	ld [wCollisionForceAngle], a
	ld a, $1
	ld [wd7eb], a
	ld a, [wFlipperYForce + 1]
	bit 7, a
	ret z
	xor a
	ld [wFlipperYForce], a
	ld [wFlipperYForce + 1], a
	ret

DrawFlippers: ; 0xe4a1
	ld a, [wCurrentStage]
	and a
	ret z
	ld hl, FlippersOAMPixelOffsetData
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	push hl
	ld hl, LeftFlipperOAMIds
	ld a, [wd7af]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	cp $b
	jr nz, .asm_e4d6
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_e4d4
	ld a, [wFlippersDisabled]
	and a
	jr z, .asm_e4d4
	ld a, $18
	jr .asm_e4d6

.asm_e4d4
	ld a, $b
.asm_e4d6
	call LoadOAMData
	pop hl
	ld a, [hSCX]
	ld d, a
	ld a, [hSCY]
	ld e, a
	ld a, [hli]
	sub d
	ld b, a
	ld a, [hli]
	sub e
	ld c, a
	ld hl, RightFlipperOAMIds
	ld a, [wd7b3]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	cp $8
	jr nz, .asm_e506
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_e504
	ld a, [wFlippersDisabled]
	and a
	jr z, .asm_e504
	ld a, $17
	jr .asm_e506

.asm_e504
	ld a, $8
.asm_e506
	call LoadOAMData
	ret

FlippersOAMPixelOffsetData:
; flipper oam pixel offsets
	dw $7b38 ; left flipper
	dw $7b68 ; right flipper

LeftFlipperOAMIds:
; TODO: Don't know how exactly these are used, but it is used by the animation
; when the flipper is activated and rotates upward to hit the pinball.
	db $0b, $0b, $0b, $0b, $0b, $0b, $0b
	db $0c, $0c, $0c, $0c, $0c, $0c, $0c
	db $0d, $0d, $0d, $0d, $0d, $0d, $0d

RightFlipperOAMIds:
	db $08, $08, $08, $08, $08, $08, $08
	db $09, $09, $09, $09, $09, $09, $09
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A

Data_e538: ; 0xe538
	dw $0000
	dw $000C
	dw $001C
	dw $0030
	dw $0038
	dw $0048
	dw $005C
	dw $006C
	dw $0070
	dw $0080
	dw $0094
	dw $00A4
	dw $00B4
	dw $00C4
	dw $00D4
	dw $00E4
	dw $00F8
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
	dw $00FC
