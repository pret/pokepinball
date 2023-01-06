CheckSeelBonusStageGameObjectCollisions: ; 0x25bbc
	call CheckSeelBonusStageSeelHeadCollisions
	ret

CheckSeelBonusStageSeelHeadCollisions: ; 0x25bc0
	ld a, [wd76c]
	cp $0
	jr nz, .seel2
	ld a, [wd76e]
	ld b, a
	ld a, [wd770]
	add $14
	ld c, a
	call CheckSeelHeadCollision
	ld a, $0
	jr c, .hitSeelHead
.seel2
	ld a, [wd776]
	cp $0
	jr nz, .seel3
	ld a, [wd778]
	ld b, a
	ld a, [wd77a]
	add $14
	ld c, a
	call CheckSeelHeadCollision
	ld a, $1
	jr c, .hitSeelHead
.seel3
	ld a, [wd780]
	cp $0
	jr nz, .done
	ld a, [wd782]
	ld b, a
	ld a, [wd784]
	add $14
	ld c, a
	call CheckSeelHeadCollision
	ld a, $2
	jr c, .hitSeelHead
.done
	ret

.hitSeelHead
	ld [wd768], a
	ld a, $1
	ld [wd767], a
	ret

CheckSeelHeadCollision: ; 0x25c12
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
