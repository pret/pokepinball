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
	assert SPRITE_BALL_SPIN_COUNT == 8 ; or any power of two
	and SPRITE_BALL_SPIN_COUNT - 1
	add SPRITE_BALL_SPIN
	call LoadSpriteData
	ldh a, [hGameBoyColorFlag]
	and a
	ret nz
	ldh a, [hGameBoyColorFlag]
	and a
	ret nz
	ldh a, [hSGBFlag]
	and a
	ret nz
	ld a, [wBallPreviousXPosDMG]
	inc a
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wBallPreviousYPosDMG]
	inc a
	sub $10
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wBallPreviousRotationDMG]
	srl a
	srl a
	srl a
	srl a
	and SPRITE_BALL_SPIN_COUNT - 1
	add SPRITE_BALL_SPIN
	call LoadSpriteData
	ld a, [wBallXPos + 1]
	ld [wBallPreviousXPosDMG], a
	ld a, [wBallYPos + 1]
	ld [wBallPreviousYPosDMG], a
	ld a, [wBallRotation]
	ld [wBallPreviousRotationDMG], a
	ret
