HandleFlippers: ; 0xe0fe
	xor a
	ld [wFlipperCollision], a
	ld [hFlipperCollisionRadius], a
	ld [wFlipperXForce], a
	ld [wFlipperXForce + 1], a
	call UpdateFlipperStates
	call CheckFlipperCollision
	ld a, [wFlipperCollision]
	and a
	call nz, HandleFlipperCollision
	ret

UpdateFlipperStates: ; 0xe118
	call PlayFlipperSoundIfPressed
	ld a, [wLeftFlipperState + 1]
	ld [wPreviousLeftFlipperState], a
	ld a, [wRightFlipperState + 1]
	ld [wPreviousRightFlipperState], a
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	ld hl, -$0333
	jr z, .checkLeftStateBounds
	ld a, [wFlippersDisabled]
	and a
	jr nz, .checkLeftStateBounds
	ld hl,  $0333
.checkLeftStateBounds
	ld a, [wLeftFlipperState + 1]
	and a
	jr nz, .checkLeftMaxState
	bit 7, h
	jr nz, .noLeftStateChange
.checkLeftMaxState
	cp $f
	jr nz, .updateLeftState
	bit 7, h
	jr nz, .updateLeftState
.noLeftStateChange
	ld hl, $0000
.updateLeftState
	ld a, l
	ld [wLeftFlipperStateChange], a
	ld a, h
	ld [wLeftFlipperStateChange + 1], a
	ld a, [wLeftFlipperState]
	ld c, a
	ld a, [wLeftFlipperState + 1]
	ld b, a
	add hl, bc
	bit 7, h
	jr nz, .asm_e16f
	ld a, h
	cp $10
	jr c, .writeLeftFlipperState
	ld hl, $0f00
	jr .writeLeftFlipperState

.asm_e16f
	ld hl, $0000
.writeLeftFlipperState
	ld a, l
	ld [wLeftFlipperState], a
	ld a, h
	ld [wLeftFlipperState + 1], a
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ld hl, -$0333
	jr z, .checkRightStateBounds
	ld a, [wFlippersDisabled]
	and a
	jr nz, .checkRightStateBounds
	ld hl,  $0333
.checkRightStateBounds
	ld a, [wRightFlipperState + 1]
	and a
	jr nz, .checkRightMaxState
	bit 7, h
	jr nz, .noRightStateChange
.checkRightMaxState
	cp $f
	jr nz, .updateRightState
	bit 7, h
	jr nz, .updateRightState
.noRightStateChange
	ld hl, $0000
.updateRightState
	ld a, l
	ld [wRightFlipperStateChange], a
	ld a, h
	ld [wRightFlipperStateChange + 1], a
	ld a, [wRightFlipperState]
	ld c, a
	ld a, [wRightFlipperState + 1]
	ld b, a
	add hl, bc
	bit 7, h
	jr nz, .asm_e1c2
	ld a, h
	cp $10
	jr c, .writeRightFlipperState
	ld hl, $0f00
	jr .writeRightFlipperState

.asm_e1c2
	ld hl, $0000
.writeRightFlipperState
	ld a, l
	ld [wRightFlipperState], a
	ld a, h
	ld [wRightFlipperState + 1], a
	ret

PlayFlipperSoundIfPressed: ; 0xe1ce
	ld a, [wFlippersDisabled]
	and a
	ret nz
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .checkRightFlipper
	lb de, $00, $0c
	call PlaySoundEffect
	ret

.checkRightFlipper
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	lb de, $00, $0c
	call PlaySoundEffect
	ret

CheckFlipperCollision: ; 0xe1f0
	ld a, [wBallXPos + 1]
	cp 80  ; which half of the screen is the ball in?
	jp nc, CheckRightFlipperCollision ; right half of screen
	; fall through
CheckLeftFlipperCollision:
	ld hl, wBallXPos
	ld c, (hBallXPos & $ff)
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
	ld a, [wPreviousLeftFlipperState]
	ld [hPreviousFlipperState], a
	ld a, [wLeftFlipperState + 1]
	ld [hFlipperState], a
	call ReadFlipperCollisionAttributes
	ld a, [wFlipperCollision]
	and a
	ret z
	ld a, [wLeftFlipperStateChange]
	ld [hFlipperStateChange], a
	ld a, [wLeftFlipperStateChange + 1]
	ld [hFlipperStateChange + 1], a
	ret

CheckRightFlipperCollision: ; 0xe226
; ball is in right half of screen
	ld hl, wBallXPos
	ld c, (hBallXPos & $ff)
	ld a, [hli]  ; Invert the ball's x position, so that the flipper collision bytes are mirrored.
	sub $1
	cpl
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	sbc 160
	cpl
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [wPreviousRightFlipperState]
	ld [hPreviousFlipperState], a
	ld a, [wRightFlipperState + 1]
	ld [hFlipperState], a
	call ReadFlipperCollisionAttributes
	ld a, [wFlipperCollision]
	and a
	ret z
	; collision with flipper occurred
	ld a, [wRightFlipperStateChange]
	ld [hFlipperStateChange], a
	ld a, [wRightFlipperStateChange + 1]
	ld [hFlipperStateChange + 1], a
	ret

ReadFlipperCollisionAttributes: ; 0xe25a
	ld a, [hBallXPos + 1]
	sub 43  ; check if ball is in horizontal range of flippers
	ret c
	cp 48
	ret nc
	; ball is in horizontal range of flippers
	ld [hBallXPos + 1], a  ; x offset of flipper horizontal range
	ld a, [hBallYPos + 1]  ; ball y-position high byte
	sub 123  ; check if ball is in vertical range of flippers
	ret c
	cp 32
	ret nc
	; ball is in potential collision with flippers
	ld [hBallYPos + 1], a
	ld a, [hPreviousFlipperState]
.collisionCheckLoop
	push af
	ld l, 0
	ld h, a  ; multiply a by 0x600
	sla a
	sla h
	sla h
	add h
	ld h, a  ; hl = a * 0x600  (this is the length of the flipper collision attributes)
	ld a, [hBallXPos + 1]  ; x offset of flipper horizontal range
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b   ; bc = (ball x offset) * 32
	; Each column of the flipper collision attributes is 32 bytes long.
	add hl, bc  ; hl points to the start of the row in the flipper collision attributes
	ld a, [hBallYPos + 1]  ; y offset of flipper vertical range
	ld c, a
	ld b, 0
	add hl, bc  ; hl points to the attribute byte in the flipper collision attributes
	ld d, h
	ld e, l  ; de points to the attribute byte in the flipper collision attributes
	ld a, h
	cp $40
	jr nc, .secondBank
	add $40
	ld h, a
	ld a, Bank(FlipperCollisionRadii)
	jr .readCollisionByte

.secondBank
	ld a, Bank(FlipperCollisionRadii2)
.readCollisionByte
	call ReadByteFromBank
	ld b, a
	and a
	jr nz, .collision
	pop af  ; a = previous flipper state
	ld hl, hFlipperState
	cp [hl]
	ret z
	jr c, .checkNextHigherState
	dec a
	jr .collisionCheckLoop

.checkNextHigherState
	inc a
	jr .collisionCheckLoop

.collision
	pop af  ; a = flipper state that resulted in a collision
	ld a, b  ; a = collision point radius
	ld [hFlipperCollisionRadius], a
	ld h, d
	ld l, e
	ld a, h
	cp $20
	jr nc, .nextBank
	add $60
	ld h, a
	ld a, Bank(FlipperCollisionNormalAngles)
	jr .readCollisionByte2

.nextBank
	add $20
	ld h, a
	ld a, Bank(FlipperCollisionNormalAngles2)
.readCollisionByte2
	call ReadByteFromBank
	ld [wFlipperCollisionNormalAngle], a
	ld a, 1
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
	ld a, [hBallXPos]
	ld e, a
	ld a, [hBallXPos + 1]
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

CalculateFlipperYForce: ; 0xe379
; Calculates the y force that's added to the ball's velocity when colliding with a flipper.
; Flippers rotate around a point, and the further away from that rotation point that ball is, the
; higher the magnitude value is (bc). This magnitude is multiplied by the flipper state change to
; calculate the final y force. Both of the inputs to this function can be thought of as 8.8 fixed-point
; floats, and the result of their multiplication is interprted as a 16.16 fixed-point float.
; bc = radius magnitude
; de = flipper state change * 4
; Returns: lb = resulting y force (yes, it's a logical 2-byte register composed of l and b)
	ld a, b
	xor d
	ld [$ffbe], a
	bit 7, b
	jr z, .bcIsPositive
	; negate bc so it's positive
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.bcIsPositive
	bit 7, d
	jr z, .deIsPositive
	; negate de so it's positive
	ld a, e
	cpl
	ld e, a
	ld a, d
	cpl
	ld d, a
	inc de
.deIsPositive
	; Multiply bc by de.
	; This is achieved by multiplying logicall treating the operation
	; as 32-bit registers.
	; The result of bc * de is stored in a 32-bit register of hlbc.
	push bc
	push de
	ld c, d
	call MultiplyBC
	pop de
	pop bc
	push hl
	push bc
	push de
	ld c, e
	call MultiplyBC
	pop de
	pop bc
	push hl
	push bc
	push de
	ld b, d
	call MultiplyBC
	pop de
	pop bc
	push hl
	ld b, e
	call MultiplyBC
	ld c, l
	ld l, h
	xor a
	ld h, a
	pop de
	add hl, de
	rl a
	pop de
	add hl, de
	jr nc, .noCarry
	inc a
.noCarry
	ld b, l
	ld l, h
	ld h, a
	pop de
	add hl, de
	; hlbc = 32-bit result of the multiplication
	ld a, [$ffbe]
	bit 7, a
	ret z
	; negate hlbc
	ld a, c
	sub 1
	cpl
	ld c, a
	ld a, b
	sbc 0
	cpl
	ld b, a
	ld a, l
	sbc 0
	cpl
	ld l, a
	ld a, h
	sbc 0
	cpl
	ld h, a
	ret

; unused
; This function might be have been used as CalculateFlipperXForce, since
; there is use of FlipperXForce anywhere, and this appears very similar to
; CalculateFlipperYForce.
Func_e3de:
	push bc
	push de
	ld c, d
	call MultiplyBC
	pop de
	pop bc
	push hl
	push bc
	push de
	ld c, e
	call MultiplyBC
	pop de
	pop bc
	push hl
	push bc
	push de
	ld b, d
	call MultiplyBC
	pop de
	pop bc
	push hl
	ld b, e
	call MultiplyBC
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

MultiplyBC: ; 0xe410
; Multiplies b and c
; Result in hl
; The reason it's using squares and such is because this is a constant-time algorithm.
; If you do the algebra, you'll see that (b*b + c*c - (b-c)*(b-c)) / 2 == b*c
	ld a, b
	cp c
	jr nc, .asm_e416
	ld b, c
	ld c, a
.asm_e416
	ld h, (SquaresLow >> 8)
	ld l, c
	ld e, [hl]
	inc h
	ld d, [hl]  ; de = c**2
	ld l, b
	ld a, [hl]
	dec h
	ld l, [hl]
	ld h, a     ; hl = b**2
	add hl, de  ; hl = b**2 + c**2
	push af
	ld d, (SquaresLow >> 8)
	ld a, b
	sub c
	ld e, a
	ld a, [de]
	ld c, a
	inc d
	ld a, [de]
	ld b, a     ; bc = (b - c)**2
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a     ; hl = b**2 + c**2 - (b - c)**2
	jr nc, .positive
	pop af
	ccf
	rr h
	rr l
	ret

.positive
	pop af
	rr h
	rr l
	ret

HandleFlipperCollision: ; 0xe442
; This is called when the ball is colliding with either the
; right or left flipper.
	ld a, 1
	ld [wIsBallColliding], a
	xor a
	ld [wBallPositionTileOffset], a
	ld [wBallPositionTileOffset + 1], a
	ld [wCurCollisionAttribute], a
	ld [wCurCollisionTileOffset], a
	ld [wCurCollisionTileOffset + 1], a
	ld a, [hFlipperCollisionRadius]
	sla a
	ld c, a
	ld b, 0
	ld hl, FlipperRadiusMagnitudes
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [hFlipperStateChange]
	ld e, a
	ld a, [hFlipperStateChange + 1]
	ld d, a
	sla e
	rl d
	sla e
	rl d  ; multiplied flipper state change by 4
	call CalculateFlipperYForce
	ld a, b
	ld [wFlipperYForce], a
	ld a, l
	ld [wFlipperYForce + 1], a
	ld a, [wBallXPos + 1]
	cp 80  ; which flipper did the ball hit?
	ld a, [wFlipperCollisionNormalAngle]
	jr c, .writeNormalAngle
	cpl  ; mirror the normal angle across the y axis
	inc a
.writeNormalAngle
	ld [wCollisionNormalAngle], a
	ld a, 1
	ld [wCollisionForceAmplification], a
	ld a, [wFlipperYForce + 1]
	bit 7, a
	ret z
	; don't apply any y force if the ball is being forced downwards into the flipper
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
	ld a, [wLeftFlipperState + 1]
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
	ld a, [wRightFlipperState + 1]
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

; See CalculateFlipperYForce to see how these magnitudes are used.
; Each entry corresponds to a distance from the flipper's rotation point.
FlipperRadiusMagnitudes: ; 0xe538
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
