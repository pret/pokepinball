DrawSpritesMewtwoBonus: ; 0x1994e
	ld bc, $7f65
	callba DrawTimer
	call DrawOrbitingBallSprites
	callba DrawFlippers
	callba DrawPinball
	call Func_19976
	ret

Func_19976: ; 0x19976
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $0
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMewtwoAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, MewtwoSpriteIds
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadSpriteData2
	ret

MewtwoSpriteIds:
	MACRO MewtwoSpriteId
		   const \2
		   db \1
	ENDM
	const_def

	MewtwoSpriteId SPRITE2_MEWTWO_BASE, MEWTWOSPRITE_BASE
	MewtwoSpriteId SPRITE2_MEWTWO_REGENERATING_1, MEWTWOSPRITE_REGENERATING_1
	MewtwoSpriteId SPRITE2_MEWTWO_REGENERATING_2, MEWTWOSPRITE_REGENERATING_2
	MewtwoSpriteId SPRITE2_MEWTWO_REGENERATING_3, MEWTWOSPRITE_REGENERATING_3
	MewtwoSpriteId SPRITE2_MEWTWO_IDLE_1, MEWTWOSPRITE_IDLE_1
	MewtwoSpriteId SPRITE2_MEWTWO_IDLE_2, MEWTWOSPRITE_IDLE_2
	MewtwoSpriteId SPRITE2_MEWTWO_HIT, MEWTWOSPRITE_HIT
	MewtwoSpriteId $FF, MEWTWOSPRITE_INVISIBLE

DrawOrbitingBallSprites: ; 0x1999d
	ld de, wOrbitingBall0
	call DrawOrbitingBallSprite
	ld de, wOrbitingBall1
	call DrawOrbitingBallSprite
	ld de, wOrbitingBall2
	call DrawOrbitingBallSprite
	ld de, wOrbitingBall3
	call DrawOrbitingBallSprite
	ld de, wOrbitingBall4
	call DrawOrbitingBallSprite
	ld de, wOrbitingBall5
	; fall through

DrawOrbitingBallSprite: ; 0x199be
	ld a, [de]
	and a
	ret z
	inc de
	inc de
	inc de
	inc de
	inc de
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, OrbitingBallSpriteIds
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadSpriteData2
	ret

OrbitingBallSpriteIds:
	MACRO OrbitingBallSpriteId
		   const \2
		   db \1
	ENDM
	const_def

	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_FULL_SIZE_0, ORBITINGBALLSPRITE_FULL_SIZE_0
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_FULL_SIZE_1, ORBITINGBALLSPRITE_FULL_SIZE_1
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_FULL_SIZE_2, ORBITINGBALLSPRITE_FULL_SIZE_2
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_FULL_SIZE_3, ORBITINGBALLSPRITE_FULL_SIZE_3
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_0, ORBITINGBALLSPRITE_GROWING_0
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_1, ORBITINGBALLSPRITE_GROWING_1
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_2, ORBITINGBALLSPRITE_GROWING_2
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_3, ORBITINGBALLSPRITE_GROWING_3
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_4, ORBITINGBALLSPRITE_GROWING_4
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_5, ORBITINGBALLSPRITE_GROWING_5
	OrbitingBallSpriteId SPRITE2_ORBITING_BALL_GROWING_6, ORBITINGBALLSPRITE_GROWING_6
	OrbitingBallSpriteId $FF, ORBITINGBALLSPRITE_INVISIBLE
