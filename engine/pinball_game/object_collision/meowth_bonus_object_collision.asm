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
	ld a, [wd6ec]
	cp $2
	ret z
	cp $3
	ret z
	ld a, [wd713]
	and a
	ret nz
	ld a, [wMeowthYMovement]
	and a
	jr z, .asm_241ed
	ld a, [wMeowthYMovement]
	cp $1
	jr nz, .asm_241df
	ld a, [wd70b]
	cp $3
	jr z, .asm_241eb
	jr .asm_241e6

.asm_241df
	ld a, [wd70c]
	cp $3
	jr z, .asm_241eb
.asm_241e6
	ld a, $2
	ld [wd6e7], a
.asm_241eb
	scf
	ret

.asm_241ed
	ld a, [wMeowthYPosition]
	cp $20
	jr nz, .asm_241fd
	ld a, [wd70b]
	cp $3
	jr z, .asm_24210
	jr .asm_2420b

.asm_241fd
	ld a, [wMeowthYPosition]
	cp $10
	jr nz, .asm_24210
	ld a, [wd70c]
	cp $3
	jr z, .asm_24210
.asm_2420b
	ld a, $1
	ld [wd6e7], a
.asm_24210
	scf
	ret

.noCollision
	and a
	ret

CheckMeowthBonusStageJewelsCollision: ; 0x24214
	ld a, [wd717]
	cp $2
	jr nz, .asm_2422e
	ld a, [wd71a]
	sub $4
	ld b, a
	ld a, [wd727]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $0
	jr c, .asm_24260
.asm_2422e
	ld a, [wd718]
	cp $2
	jr nz, .asm_24248
	ld a, [wd71b]
	sub $4
	ld b, a
	ld a, [wd728]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $1
	jr c, .asm_24260
.asm_24248
	ld a, [wd719]
	cp $2
	ret nz
	ld a, [wd71c]
	sub $4
	ld b, a
	ld a, [wd729]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $2
	ret nc
.asm_24260
	ld b, $0
	ld c, a
	ld hl, wd717
	add hl, bc
	ld a, $3
	ld [hl], a
	ld hl, wd714
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
	ld a, [wd721]
	cp $2
	jr nz, .asm_242d5
	ld a, [wd724]
	sub $4
	ld b, a
	ld a, [wd731]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $0
	jr c, .asm_24307
.asm_242d5
	ld a, [wd722]
	cp $2
	jr nz, .asm_242ef
	ld a, [wd725]
	sub $4
	ld b, a
	ld a, [wd732]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $1
	jr c, .asm_24307
.asm_242ef
	ld a, [wd723]
	cp $2
	ret nz
	ld a, [wd726]
	sub $4
	ld b, a
	ld a, [wd733]
	add $c
	ld c, a
	call CheckJewelCollision
	ld a, $2
	ret nc
.asm_24307
	ld b, $0
	ld c, a
	ld hl, wd721
	add hl, bc
	ld a, $3
	ld [hl], a
	ld hl, wd71e
	add hl, bc
	ld a, $0
	ld [hl], a
	ret
