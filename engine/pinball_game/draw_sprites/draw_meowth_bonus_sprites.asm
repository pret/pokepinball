DrawSpritesMeowthBonus: ; 0x2583b
	ld bc, $7f65
	callba DrawTimer
	callba DrawFlippers
	call Func_259fe
	call Func_25895
	call Func_2595e
	call Func_2586c
	callba DrawPinball
	call Func_25a39
	ret

Func_2586c: ; 0x2586c
	ld a, [wMeowthXPosition]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthYPosition]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthAnimationFrame]
	ld e, a
	ld d, $0
	ld hl, MeowthSpriteIds
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ret

MeowthSpriteIds:
	MACRO MeowthSpriteId
		const \2
		db \1
	ENDM
	const_def

	MeowthSpriteId SPRITE2_MEOWTH_LEFT_WALK_0, MEOWTHSPRITE_LEFT_WALK_0
	MeowthSpriteId SPRITE2_MEOWTH_LEFT_WALK_1, MEOWTHSPRITE_LEFT_WALK_1
	MeowthSpriteId SPRITE2_MEOWTH_LEFT_WALK_2, MEOWTHSPRITE_LEFT_WALK_2
	MeowthSpriteId SPRITE2_MEOWTH_LEFT_HIT, MEOWTHSPRITE_LEFT_HIT
	MeowthSpriteId SPRITE2_MEOWTH_RIGHT_WALK_0, MEOWTHSPRITE_RIGHT_WALK_0
	MeowthSpriteId SPRITE2_MEOWTH_RIGHT_WALK_1, MEOWTHSPRITE_RIGHT_WALK_1
	MeowthSpriteId SPRITE2_MEOWTH_RIGHT_WALK_2, MEOWTHSPRITE_RIGHT_WALK_2
	MeowthSpriteId SPRITE2_MEOWTH_RIGHT_HIT, MEOWTHSPRITE_RIGHT_HIT
	MeowthSpriteId SPRITE2_MEOWTH_TIMEOUT_0, MEOWTHSPRITE_TIMEOUT_0
	MeowthSpriteId SPRITE2_MEOWTH_TIMEOUT_1, MEOWTHSPRITE_TIMEOUT_1

Func_25895: ; 0x25895
	ld a, [wMeowthJewel0AnimationIndex]
	cp $b ; each entry of MeowthJewelSpriteIdsTable has 11 entries
	jr nz, .asm_258a0
	xor a
	ld [wMeowthJewel0AnimationIndex], a
.asm_258a0
	ld a, [wMeowthJewel1AnimationIndex]
	cp $b
	jr nz, .asm_258ab
	xor a
	ld [wMeowthJewel1AnimationIndex], a
.asm_258ab
	ld a, [wMeowthJewel2AnimationIndex]
	cp $b
	jr nz, .asm_258b6
	xor a
	ld [wMeowthJewel2AnimationIndex], a
.asm_258b6
	ld a, [wMeowthJewel0XCoord]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthJewel0YCoord]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthJewel0State]
	sla a
	ld e, a
	ld d, $0
	ld hl, MeowthJewelSpriteIdsTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMeowthJewel0AnimationIndex]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ld a, [wMeowthJewel1XCoord]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthJewel1YCoord]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthJewel1State]
	sla a
	ld e, a
	ld d, $0
	ld hl, MeowthJewelSpriteIdsTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMeowthJewel1AnimationIndex]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ld a, [wMeowthJewel2XCoord]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthJewel2YCoord]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthJewel2State]
	sla a
	ld e, a
	ld d, $0
	ld hl, MeowthJewelSpriteIdsTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMeowthJewel2AnimationIndex]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ret

MeowthJewelSpriteIdsTable:
	dw MeowthJewelSpawnSpriteIds
	dw MeowthJewelSpawnSpriteIds
	dw MeowthJewelIdleSpriteIds
	dw MeowthJewelCollectSpriteIds

MeowthJewelSpawnSpriteIds:
	db SPRITE2_MEOWTHJEWEL_SPAWN_0
	db SPRITE2_MEOWTHJEWEL_SPAWN_0
	db SPRITE2_MEOWTHJEWEL_SPAWN_0
	db SPRITE2_MEOWTHJEWEL_SPAWN_0
	db SPRITE2_MEOWTHJEWEL_SPAWN_1
	db SPRITE2_MEOWTHJEWEL_SPAWN_1
	db SPRITE2_MEOWTHJEWEL_SPAWN_1
	db SPRITE2_MEOWTHJEWEL_SPAWN_1
	db SPRITE2_MEOWTHJEWEL_SPAWN_1
	db SPRITE2_MEOWTHJEWEL_SPAWN_1
	db SPRITE2_MEOWTHJEWEL_SPAWN_1

MeowthJewelIdleSpriteIds:
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_0
	db SPRITE2_MEOWTHJEWEL_IDLE_1
	db SPRITE2_MEOWTHJEWEL_IDLE_1
	db SPRITE2_MEOWTHJEWEL_IDLE_1
	db SPRITE2_MEOWTHJEWEL_IDLE_1

MeowthJewelCollectSpriteIds:
	db SPRITE2_MEOWTHJEWEL_COLLECT_0
	db SPRITE2_MEOWTHJEWEL_COLLECT_5
	db SPRITE2_MEOWTHJEWEL_COLLECT_4
	db SPRITE2_MEOWTHJEWEL_COLLECT_3
	db SPRITE2_MEOWTHJEWEL_COLLECT_2
	db SPRITE2_MEOWTHJEWEL_COLLECT_1
	db SPRITE2_MEOWTHJEWEL_COLLECT_2
	db SPRITE2_MEOWTHJEWEL_COLLECT_3
	db SPRITE2_MEOWTHJEWEL_COLLECT_4
	db SPRITE2_MEOWTHJEWEL_COLLECT_5
	db SPRITE2_MEOWTHJEWEL_COLLECT_5

Func_2595e: ; 0x2595e
	ld a, [wMeowthJewel3AnimationIndex]
	cp $b
	jr nz, .asm_25969
	xor a
	ld [wMeowthJewel3AnimationIndex], a
.asm_25969
	ld a, [wMeowthJewel4AnimationIndex]
	cp $b
	jr nz, .asm_25974
	xor a
	ld [wMeowthJewel4AnimationIndex], a
.asm_25974
	ld a, [wMeowthJewel5AnimationIndex]
	cp $b
	jr nz, .asm_2597f
	xor a
	ld [wMeowthJewel5AnimationIndex], a
.asm_2597f
	ld a, [wMeowthJewel3XCoord]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthJewel3YCoord]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthJewel3State]
	sla a
	ld e, a
	ld d, $0
	ld hl, MeowthJewelSpriteIdsTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMeowthJewel3AnimationIndex]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ld a, [wMeowthJewel4XCoord]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthJewel4YCoord]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthJewel4State]
	sla a
	ld e, a
	ld d, $0
	ld hl, MeowthJewelSpriteIdsTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMeowthJewel4AnimationIndex]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ld a, [wMeowthJewel5XCoord]
	ld hl, hSCX
	sub [hl]
	ld b, a
	ld a, [wMeowthJewel5YCoord]
	ld hl, hSCY
	sub [hl]
	ld c, a
	ld a, [wMeowthJewel5State]
	sla a
	ld e, a
	ld d, $0
	ld hl, MeowthJewelSpriteIdsTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMeowthJewel5AnimationIndex]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	call LoadSpriteData2
	ret

Func_259fe: ; 0x259fe
	ld a, [wd795]
	and a
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
	ld hl, MeowthMultiplierSpriteIds
	add hl, de
	ld a, [hl]
	cp $ff
	call nz, LoadSpriteData2
	ret

MeowthMultiplierSpriteIds:
	MACRO MeowthMultiplierSpriteId
		const \2
		db \1
	ENDM
	const_def

	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_2_FRAME_0, MEOWTHMULTIPLIERSPRITE_2_FRAME_0
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_2_FRAME_1, MEOWTHMULTIPLIERSPRITE_2_FRAME_1
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_2_FRAME_2, MEOWTHMULTIPLIERSPRITE_2_FRAME_2
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_3_FRAME_0, MEOWTHMULTIPLIERSPRITE_3_FRAME_0
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_3_FRAME_1, MEOWTHMULTIPLIERSPRITE_3_FRAME_1
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_3_FRAME_2, MEOWTHMULTIPLIERSPRITE_3_FRAME_2
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_4_FRAME_0, MEOWTHMULTIPLIERSPRITE_4_FRAME_0
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_4_FRAME_1, MEOWTHMULTIPLIERSPRITE_4_FRAME_1
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_4_FRAME_2, MEOWTHMULTIPLIERSPRITE_4_FRAME_2
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_5_FRAME_0, MEOWTHMULTIPLIERSPRITE_5_FRAME_0
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_5_FRAME_1, MEOWTHMULTIPLIERSPRITE_5_FRAME_1
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_5_FRAME_2, MEOWTHMULTIPLIERSPRITE_5_FRAME_2
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_6_FRAME_0, MEOWTHMULTIPLIERSPRITE_6_FRAME_0
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_6_FRAME_1, MEOWTHMULTIPLIERSPRITE_6_FRAME_1
	MeowthMultiplierSpriteId SPRITE2_MEOWTH_MULTIPLIER_6_FRAME_2, MEOWTHMULTIPLIERSPRITE_6_FRAME_2
	MeowthMultiplierSpriteId $FF, MEOWTHMULTIPLIERSPRITE_INVISIBLE

Func_25a39: ; 0x25a39
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
	jr c, .asm_25a58
	ld de, $0000
	jr .asm_25a5b

.asm_25a58
	ld de, $0001
.asm_25a5b
	ld hl, MeowthProgressSparkleSpriteIds
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

MeowthProgressSparkleSpriteIds: ; 0x25a7a
	db SPRITE2_MEOWTH_PROGRESS_SPARKLE_0
	db SPRITE2_MEOWTH_PROGRESS_SPARKLE_1
