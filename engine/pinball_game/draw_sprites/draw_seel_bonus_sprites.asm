DrawSpritesSeelBonus: ; 0x26b7e
	ld bc, $7f65
	callba DrawTimer
	call Func_26bf7
	callba DrawFlippers
	callba DrawPinball
	call Func_26ba9
	call Func_26c3c
	ret

Func_26ba9: ; 0x26ba9
	ld de, wd76e
	call Func_26bbc
	ld de, wd778
	call Func_26bbc
	ld de, wd782
	call Func_26bbc
	ret

Func_26bbc: ; 0x26bbc
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, SpriteIds_26bdf
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadSpriteData2
	ret

SpriteIds_26bdf: ; 0x26bdf
	MACRO SeelSpriteId
		const \2
		db \1
	ENDM
	const_def

	SeelSpriteId SPRITE2_SEEL_PEEKING_0, SEELSPRITE_PEEKING_0
	SeelSpriteId SPRITE2_SEEL_PEEKING_1, SEELSPRITE_PEEKING_1
	SeelSpriteId SPRITE2_SEEL_HIT, SEELSPRITE_HIT
	SeelSpriteId SPRITE2_SEEL_SWIM_RIGHT_0, SEELSPRITE_SWIM_RIGHT_0
	SeelSpriteId SPRITE2_SEEL_SWIM_RIGHT_1, SEELSPRITE_SWIM_RIGHT_1
	SeelSpriteId SPRITE2_SEEL_SWIM_RIGHT_2, SEELSPRITE_SWIM_RIGHT_2
	SeelSpriteId SPRITE2_SEEL_TURN_RIGHT_TO_LEFT_0, SEELSPRITE_TURN_RIGHT_TO_LEFT_0
	SeelSpriteId SPRITE2_SEEL_TURN_RIGHT_TO_LEFT_1, SEELSPRITE_TURN_RIGHT_TO_LEFT_1
	SeelSpriteId SPRITE2_SEEL_SHADOW_CIRCLE_0, SEELSPRITE_SHADOW_CIRCLE_0
	SeelSpriteId SPRITE2_SEEL_SHADOW_CIRCLE_1, SEELSPRITE_SHADOW_CIRCLE_1
	SeelSpriteId SPRITE2_SEEL_SHADOW_CIRCLE_2, SEELSPRITE_SHADOW_CIRCLE_2
	SeelSpriteId SPRITE2_SEEL_EMERGE_0, SEELSPRITE_EMERGE_0
	SeelSpriteId SPRITE2_SEEL_EMERGE_1, SEELSPRITE_EMERGE_1
	SeelSpriteId SPRITE2_SEEL_SPLASH, SEELSPRITE_SPLASH
	SeelSpriteId SPRITE2_SEEL_TURN_LEFT_TO_RIGHT_2, SEELSPRITE_TURN_LEFT_TO_RIGHT_2
	SeelSpriteId SPRITE2_SEEL_TURN_LEFT_TO_RIGHT_3, SEELSPRITE_TURN_LEFT_TO_RIGHT_3
	SeelSpriteId SPRITE2_SEEL_SWIM_LEFT_0, SEELSPRITE_SWIM_LEFT_0
	SeelSpriteId SPRITE2_SEEL_SWIM_LEFT_1, SEELSPRITE_SWIM_LEFT_1
	SeelSpriteId SPRITE2_SEEL_SWIM_LEFT_2, SEELSPRITE_SWIM_LEFT_2
	SeelSpriteId SPRITE2_SEEL_TURN_LEFT_TO_RIGHT_0, SEELSPRITE_TURN_LEFT_TO_RIGHT_0
	SeelSpriteId SPRITE2_SEEL_TURN_LEFT_TO_RIGHT_1, SEELSPRITE_TURN_LEFT_TO_RIGHT_1
	SeelSpriteId SPRITE2_SEEL_TURN_RIGHT_TO_LEFT_2, SEELSPRITE_TURN_RIGHT_TO_LEFT_2
	SeelSpriteId SPRITE2_SEEL_TURN_RIGHT_TO_LEFT_3, SEELSPRITE_TURN_RIGHT_TO_LEFT_3
	SeelSpriteId $FF, SEELSPRITE_INVISIBLE

Func_26bf7: ; 0x26bf7
	ld a, [wd795]
	cp $0
	ret z
	ld de, wd79c
	ld a, [de]
	ld hl, hSCX
	sub [hl]
	ld b, a
	inc de
	inc de
	ld a, [de]
	ld hl, hSCY
	sub [hl]
	ld c, a
	dec de
	dec de
	dec de
	dec de
	dec de
	dec de
	ld a, [de]
	ld e, a
	ld d, $0
	ld hl, SeelMultiplierSpriteIds
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadSpriteData2
	ret

SeelMultiplierSpriteIds: ; 0x26c23
	MACRO SeelMultiplierSpriteId
		const \2
		db \1
	ENDM
	const_def

	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_2_FRAME_0, SEELMULTIPLIERSPRITE_2_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_2_FRAME_1, SEELMULTIPLIERSPRITE_2_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_2_FRAME_2, SEELMULTIPLIERSPRITE_2_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_4_FRAME_0, SEELMULTIPLIERSPRITE_4_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_4_FRAME_1, SEELMULTIPLIERSPRITE_4_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_4_FRAME_2, SEELMULTIPLIERSPRITE_4_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_8_FRAME_0, SEELMULTIPLIERSPRITE_8_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_8_FRAME_1, SEELMULTIPLIERSPRITE_8_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_8_FRAME_2, SEELMULTIPLIERSPRITE_8_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_16_FRAME_0, SEELMULTIPLIERSPRITE_16_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_16_FRAME_1, SEELMULTIPLIERSPRITE_16_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_16_FRAME_2, SEELMULTIPLIERSPRITE_16_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_32_FRAME_0, SEELMULTIPLIERSPRITE_32_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_32_FRAME_1, SEELMULTIPLIERSPRITE_32_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_32_FRAME_2, SEELMULTIPLIERSPRITE_32_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_64_FRAME_0, SEELMULTIPLIERSPRITE_64_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_64_FRAME_1, SEELMULTIPLIERSPRITE_64_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_64_FRAME_2, SEELMULTIPLIERSPRITE_64_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_128_FRAME_0, SEELMULTIPLIERSPRITE_128_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_128_FRAME_1, SEELMULTIPLIERSPRITE_128_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_128_FRAME_2, SEELMULTIPLIERSPRITE_128_FRAME_2
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_256_FRAME_0, SEELMULTIPLIERSPRITE_256_FRAME_0
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_256_FRAME_1, SEELMULTIPLIERSPRITE_256_FRAME_1
	SeelMultiplierSpriteId SPRITE2_SEEL_MULTIPLIER_256_FRAME_2, SEELMULTIPLIERSPRITE_256_FRAME_2
	SeelMultiplierSpriteId $FF, SEELMULTIPLIERSPRITE_INVISIBLE

Func_26c3c: ; 0x26c3c
	ld a, [wd64e]
	and a
	ret z
	ld a, [wd652]
	ld hl, hSCX
	sub [hl]
	ld b, a
	xor a
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wd64f]
	cp $a
	jr c, .asm_26c5b
	ld de, $0000
	jr .asm_26c5e

.asm_26c5b
	ld de, $0001
.asm_26c5e
	ld hl, SeelProgressSparkleSpriteIds
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ld hl, wd64f
	inc [hl]
	ld a, [hl]
	cp $14
	ret c
	ld [hl], $0
	ld hl, wd650
	inc [hl]
	ld a, [hl]
	cp $a
	ret nz
	xor a
	ld [wd64e], a
	ret

SeelProgressSparkleSpriteIds: ; 0x26c7d
	db SPRITE2_SEEL_PROGRESS_SPARKLE_0
	db SPRITE2_SEEL_PROGRESS_SPARKLE_1
