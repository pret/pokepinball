DrawSpritesDiglettBonus: ; 0x1ac98
	callba DrawFlippers
	callba DrawPinball
	call DrawDugtrio
	ret

DrawDugtrio: ; 0x1acb0
	ld a, $40
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, $0
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wDugtrioAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, DugtrioSpriteIds
	add hl, de
	ld a, [hl]
	bit 7, a
	call z, LoadSpriteData2
	ret

DugtrioSpriteIds:
	MACRO DugtrioSpriteId
		const \2
		db \1
	ENDM
	const_def

	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH3_FRAME0, DUGTRIOSPRITE_HEALTH3_FRAME0
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH3_FRAME1, DUGTRIOSPRITE_HEALTH3_FRAME1
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH3_FRAME2, DUGTRIOSPRITE_HEALTH3_FRAME2
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH3_HIT,    DUGTRIOSPRITE_HEALTH3_HIT
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH2_FRAME0, DUGTRIOSPRITE_HEALTH2_FRAME0
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH2_FRAME1, DUGTRIOSPRITE_HEALTH2_FRAME1
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH2_FRAME2, DUGTRIOSPRITE_HEALTH2_FRAME2
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH2_HIT,    DUGTRIOSPRITE_HEALTH2_HIT
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH1_FRAME0, DUGTRIOSPRITE_HEALTH1_FRAME0
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH1_FRAME1, DUGTRIOSPRITE_HEALTH1_FRAME1
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH1_FRAME2, DUGTRIOSPRITE_HEALTH1_FRAME2
	DugtrioSpriteId SPRITE2_DUGTRIO_HEALTH1_HIT,    DUGTRIOSPRITE_HEALTH1_HIT
	DugtrioSpriteId SPRITE2_DUGTRIO_DROPPED,        DUGTRIOSPRITE_DROPPED
	DugtrioSpriteId SPRITE2_DUGTRIO_DEFEATED,       DUGTRIOSPRITE_DEFEATED
	db $FF
