CheckMeowthBonusStageGameObjectCollisions: ; 0x2414d
	call CheckMeowthBonusStageMeowthCollision
	call CheckMeowthBonusStageJewelsCollision
	call CheckMeowthBonusStageJewelsCollision2
	ret

CheckMeowthBonusStageMeowthCollision: ; 0x24157
	ld a, [wd6e7]
	cp $0
	ret nz
	ld a, [wMeowthXPosition]
	add -9
	ld b, a
	ld a, [wMeowthYPosition]
	add $6
	ld c, a
	call CheckMeowthCollision
	ld a, $3
	ret nc
	ret

CheckMeowthCollision: ; 0x24170
	ld a, [wBallXPos + 1]
	sub b
	cp $30
	jp nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $28
	jp nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld h, d
	ld l, e
	sla e
	rl d
	add hl, de
	ld d, h
	ld e, l
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, MeowthCollisionAngles
	add hl, de
	ld a, BANK(MeowthCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionNormalAngle], a
	ld a, $1
	ld [wIsBallColliding], a
	ld a, [wMeowthState]
	cp 2
	ret z
	cp 3
	ret z
	ld a, [wDisableMeowthJewelProduction]
	and a
	ret nz
	ld a, [wMeowthYMovement]
	and a
	jr z, .walkingHorizontally
	ld a, [wMeowthYMovement]
	cp 1
	jr nz, .walkingUp
	ld a, [wNumActiveJewelsBottom]
	cp 3
	jr z, .exit
	jr .createNewJewel

.walkingUp
	ld a, [wNumActiveJewelsTop]
	cp 3
	jr z, .exit
.createNewJewel
	ld a, $2
	ld [wd6e7], a
.exit
	scf
	ret

.walkingHorizontally
	ld a, [wMeowthYPosition]
	cp 32
	jr nz, .locatedAtTop
	ld a, [wNumActiveJewelsBottom]
	cp 3
	jr z, .exit2
	jr .createNewJewel2

.locatedAtTop
	ld a, [wMeowthYPosition]
	cp 16
	jr nz, .exit2
	ld a, [wNumActiveJewelsTop]
	cp 3
	jr z, .exit2
.createNewJewel2
	ld a, $1
	ld [wd6e7], a
.exit2
	scf
	ret

.noCollision
	and a
	ret

CheckMeowthBonusStageJewelsCollision: ; 0x24214
	ld a, [wMeowthJewel0State]
	cp $2
	jr nz, .asm_2422e
	ld a, [wMeowthJewel0XCoord]
	sub $4
	ld b, a
	ld a, [wMeowthJewel0YCoord]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $0
	jr c, .asm_24260
.asm_2422e
	ld a, [wMeowthJewel1State]
	cp $2
	jr nz, .asm_24248
	ld a, [wMeowthJewel1XCoord]
	sub $4
	ld b, a
	ld a, [wMeowthJewel1YCoord]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $1
	jr c, .asm_24260
.asm_24248
	ld a, [wMeowthJewel2State]
	cp $2
	ret nz
	ld a, [wMeowthJewel2XCoord]
	sub $4
	ld b, a
	ld a, [wMeowthJewel2YCoord]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $2
	ret nc
.asm_24260
	ld b, $0
	ld c, a
	ld hl, wMeowthJewel0State
	add hl, bc
	ld a, $3
	ld [hl], a
	ld hl, wMeowthJewel0AnimationIndex
	add hl, bc
	ld a, $0
	ld [hl], a
	ret

CheckJewelCollision: ; 0x24272
	ld a, [wBallXPos + 1]
	sub b
	cp $18
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $18
	jr nc, .noCollision
	ld c, a
	ld e, c
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld h, d
	ld l, e
	sla e
	rl d
	add hl, de
	ld d, h
	ld e, l
	ld l, b
	ld h, $0
	add hl, de
	ld de, MeowthJewelCollisionAngles
	add hl, de
	ld a, BANK(MeowthJewelCollisionAngles)
	call ReadByteFromBank
	bit 7, a
	jr nz, .noCollision
	sla a
	ld [wCollisionNormalAngle], a
	ld a, $1
	ld [wIsBallColliding], a
	scf
	ret

.noCollision
	and a
	ret

CheckMeowthBonusStageJewelsCollision2: ; 0x242bb
	ld a, [wMeowthJewel3State]
	cp $2
	jr nz, .asm_242d5
	ld a, [wMeowthJewel3XCoord]
	sub $4
	ld b, a
	ld a, [wMeowthJewel3YCoord]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $0
	jr c, .asm_24307
.asm_242d5
	ld a, [wMeowthJewel4State]
	cp $2
	jr nz, .asm_242ef
	ld a, [wMeowthJewel4XCoord]
	sub $4
	ld b, a
	ld a, [wMeowthJewel4YCoord]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $1
	jr c, .asm_24307
.asm_242ef
	ld a, [wMeowthJewel5State]
	cp $2
	ret nz
	ld a, [wMeowthJewel5XCoord]
	sub $4
	ld b, a
	ld a, [wMeowthJewel5YCoord]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $2
	ret nc
.asm_24307
	ld b, $0
	ld c, a
	ld hl, wMeowthJewel3State
	add hl, bc
	ld a, $3
	ld [hl], a
	ld hl, wMeowthJewel3AnimationIndex
	add hl, bc
	ld a, $0
	ld [hl], a
	ret
