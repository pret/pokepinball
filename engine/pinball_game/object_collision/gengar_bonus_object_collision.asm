CheckGengarBonusStageGameObjectCollisions: ; 0x181b1
	call CheckGengarBonusStageGastlyCollision
	call CheckGengarBonusStageHaunterCollision
	call CheckGengarBonusStageGengarCollision
	call GengarBonusStageGravestonesCollision
	ret

CheckGengarBonusStageGastlyCollision: ; 0x181be
	ld a, [wGastly1Enabled]
	and a
	ret z
	ld a, [wGastly1XPos + 1]
	ld b, a
	ld a, [wGastly1YPos + 1]
	add $10
	ld c, a
	ld a, [wGastly1AnimationFrame]
	call CheckSingleGastlyCollision
	ld a, $1
	jr c, .hitGastly
	ld a, [wGastly2XPos + 1]
	ld b, a
	ld a, [wGastly2YPos + 1]
	add $10
	ld c, a
	ld a, [wGastly2AnimationFrame]
	call CheckSingleGastlyCollision
	ld a, $2
	jr c, .hitGastly
	ld a, [wGastly3XPos + 1]
	ld b, a
	ld a, [wGastly3YPos + 1]
	add $10
	ld c, a
	ld a, [wGastly3AnimationFrame]
	call CheckSingleGastlyCollision
	ld a, $3
	ret nc
.hitGastly
	ld [wTriggeredGameObjectIndex], a
	ld [wd657], a
	add $4
	ld [wTriggeredGameObject], a
	ld [wd658], a
	ret

CheckSingleGastlyCollision: ; 0x1820d
	cp $4
	jr z, .noCollision
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
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
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, CircularCollisionAngles
	add hl, de
	ld a, BANK(CircularCollisionAngles)
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

CheckGengarBonusStageHaunterCollision: ; 0x18259
	ld a, [wd67e]
	and a
	ret z
	ld a, [wHaunter1XPos + 1]
	add $fe
	ld b, a
	ld a, [wHaunter1YPos + 1]
	add $c
	ld c, a
	ld a, [wHaunter1AnimationState]
	call CheckSingleHaunterCollision
	ld a, $1
	jr c, .hitHaunter
	ld a, [wHaunter2XPos + 1]
	add $fe
	ld b, a
	ld a, [wHaunter2YPos + 1]
	add $c
	ld c, a
	ld a, [wHaunter2AnimationState]
	call CheckSingleHaunterCollision
	ld a, $2
	ret nc
.hitHaunter
	ld [wTriggeredGameObjectIndex], a
	ld [wd67c], a
	add $7
	ld [wTriggeredGameObject], a
	ld [wd67d], a
	ret

CheckSingleHaunterCollision: ; 0x18298
	cp $5
	jr z, .noCollision
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $28
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
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, HaunterCollisionAngles
	add hl, de
	ld a, BANK(HaunterCollisionAngles)
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

CheckGengarBonusStageGengarCollision: ; 0x182e4
	ld a, [wd698]
	and a
	ret z
	ld a, [wGengarXPos + 1]
	ld b, a
	ld a, [wGengarYPos + 1]
	add $c
	ld c, a
	call CheckGiantGengarCollision
	ld a, $1
	ret nc
	ld [wTriggeredGameObjectIndex], a
	ld [wd696], a
	add $9
	ld [wTriggeredGameObject], a
	ld [wd697], a
	ret

CheckGiantGengarCollision: ; 0x18308
	ld a, [wBallXPos + 1]
	sub b
	cp $30
	jr nc, .noCollision
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $40
	jr nc, .noCollision
	ld c, a
	ld a, c
	sla a
	add c
	ld e, a
	ld d, $0
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	ld de, GengarCollisionAngles
	add hl, de
	ld a, BANK(GengarCollisionAngles)
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

GengarBonusStageGravestonesCollision: ; 0x18350
	ld de, GengarBonusStageGravestonesCollisionData
	ld hl, GengarBonusStageGravestonesCollisionAttributes
	ld bc, wWhichGravestone
	and a
	jp HandleGameObjectCollision

GengarBonusStageGravestonesCollisionAttributes:
	db $00  ; flat list
	db $19, $1A, $1B, $1C, $27, $1D, $1E, $1F, $20
	db $FF ; terminator

GengarBonusStageGravestonesCollisionData:
	db $11, $11
	db $01, $24, $52
	db $02, $44, $3A
	db $03, $74, $5A
	db $04, $7C, $32
	db $FF ; terminator
