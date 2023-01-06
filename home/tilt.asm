HandleTilts: ; 0x3582
	call HandleLeftTilt
	call HandleRightTilt
	call HandleUpperTilt
	ret

HandleLeftTilt: ; 0x358c
	ld a, [wLeftTiltReset]
	and a
	jr nz, .tiltCoolDown
	ld hl, wKeyConfigLeftTilt
	call IsKeyPressed2
	jr z, .tiltCoolDown
	ld a, [wLeftTiltCounter]
	cp 3
	jr z, .startCoolDown
	inc a
	ld [wLeftTiltCounter], a
	cp 1
	jr nz, .skipSoundEffect
	lb de, $00, $3f
	call PlaySoundEffect
.skipSoundEffect
	ld a, [wPinballIsVisible]
	ld hl, wEnableBallGravityAndTilt
	and [hl]
	jr z, .skipBallMovement
	ld a, [wBallXPos + 1]
	dec a  ; move ball's position to the left by 1 pixel
	ld [wBallXPos + 1], a
.skipBallMovement
	ld a, [wLeftAndRightTiltPixelsOffset]
	inc a
	ld [wLeftAndRightTiltPixelsOffset], a
	ld a, 1
	ld [wLeftTiltPushing], a
	ret

.startCoolDown
	ld a, 1
	ld [wLeftTiltReset], a
.tiltCoolDown
	xor a
	ld [wLeftTiltPushing], a
	ld a, [wLeftTiltCounter]
	and a
	jr z, .done
	dec a
	ld [wLeftTiltCounter], a
	ld a, [wLeftAndRightTiltPixelsOffset]
	dec a
	ld [wLeftAndRightTiltPixelsOffset], a
	ret

.done
	ld hl, wKeyConfigLeftTilt
	call IsKeyPressed2
	ret nz
	xor a
	ld [wLeftTiltReset], a
	ret

HandleRightTilt: ; 0x35f3
	ld a, [wRightTiltReset]
	and a
	jr nz, .tiltCoolDown
	ld hl, wKeyConfigRightTilt
	call IsKeyPressed2
	jr z, .tiltCoolDown
	ld a, [wRightTiltCounter]
	cp 3
	jr z, .startCoolDown
	inc a
	ld [wRightTiltCounter], a
	cp 1
	jr nz, .skipSoundEffect
	lb de, $00, $3f
	call PlaySoundEffect
.skipSoundEffect
	ld a, [wPinballIsVisible]
	ld hl, wEnableBallGravityAndTilt
	and [hl]
	jr z, .skipBallMovement
	ld a, [wBallXPos + 1]
	inc a  ; move ball's position to the right by 1 pixel
	ld [wBallXPos + 1], a
.skipBallMovement
	ld a, [wLeftAndRightTiltPixelsOffset]
	dec a
	ld [wLeftAndRightTiltPixelsOffset], a
	ld a, 1
	ld [wRightTiltPushing], a
	ret

.startCoolDown
	ld a, 1
	ld [wRightTiltReset], a
.tiltCoolDown
	xor a
	ld [wRightTiltPushing], a
	ld a, [wRightTiltCounter]
	and a
	jr z, .done
	dec a
	ld [wRightTiltCounter], a
	ld a, [wLeftAndRightTiltPixelsOffset]
	inc a
	ld [wLeftAndRightTiltPixelsOffset], a
	ret

.done
	ld hl, wKeyConfigRightTilt
	call IsKeyPressed2
	ret nz
	xor a
	ld [wRightTiltReset], a
	ret

HandleUpperTilt: ; 0x365a
	ld a, [wUpperTiltReset]
	and a
	jr nz, .tiltCoolDown
	ld hl, wKeyConfigUpperTilt
	call IsKeyPressed2
	jr z, .tiltCoolDown
	ld a, [wUpperTiltCounter]
	cp 4
	jr z, .startCoolDown
	inc a
	ld [wUpperTiltCounter], a
	cp 1
	jr nz, .skipSoundEffect
	lb de, $00, $3f
	call PlaySoundEffect
.skipSoundEffect
	ld a, [wPinballIsVisible]
	ld hl, wEnableBallGravityAndTilt
	and [hl]
	jr z, .skipBallMovement
	ld a, [wBallYPos + 1]
	inc a  ; move ball's position down by 1 pixel
	ld [wBallYPos + 1], a
.skipBallMovement
	ld a, [wUpperTiltPixelsOffset]
	dec a
	ld [wUpperTiltPixelsOffset], a
	ld a, 1
	ld [wUpperTiltPushing], a
	ret

.startCoolDown
	ld a, 1
	ld [wUpperTiltReset], a
.tiltCoolDown
	xor a
	ld [wUpperTiltPushing], a
	ld a, [wUpperTiltCounter]
	and a
	jr z, .done
	dec a
	ld [wUpperTiltCounter], a
	ld a, [wUpperTiltPixelsOffset]
	inc a
	ld [wUpperTiltPixelsOffset], a
	ret

.done
	ld hl, wKeyConfigUpperTilt
	call IsKeyPressed2
	ret nz
	xor a
	ld [wUpperTiltReset], a
	ret

ApplyTiltForces: ; 0x36c1
	ld a, [wPinballIsVisible]
	ld hl, wEnableBallGravityAndTilt
	and [hl]
	ret z
	ld c, $0
	ld a, [wUpperTiltPushing]
	srl a
	rl c
	ld a, [wRightTiltPushing]
	srl a
	rl c
	ld a, [wLeftTiltPushing]
	srl a
	rl c
	ld b, $0
	sla c
	ld hl, TiltForces
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, h
	ret nz
	ld a, [wCollisionNormalAngle]
	ld c, a
	ld b, $0
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ld a, [hLoadedROMBank]
	push af
	ld a, BANK(TiltLeftOnlyForce)
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ld a, [wBallXVelocity]
	add [hl]
	ld [wBallXVelocity], a
	inc hl
	ld a, [wBallXVelocity + 1]
	adc [hl]
	ld [wBallXVelocity + 1], a
	inc hl
	ld a, [wBallYVelocity]
	add [hl]
	ld [wBallYVelocity], a
	inc hl
	ld a, [wBallYVelocity + 1]
	adc [hl]
	ld [wBallYVelocity + 1], a
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

TiltForces: ; 0x372d
	dw $FFFF ; no tilt
	dw TiltLeftOnlyForce
	dw TiltRightOnlyForce
	dw $FFFF ; left + right (cancel each other, so no tilt)
	dw TiltUpOnlyForce
	dw TiltUpLeftForce
	dw TiltUpRightForce
	dw TiltUpOnlyForce
