CheckMewtwoBonusStageGameObjectCollisions: ; 0x19330
	call Func_19414
	call Func_19337
	ret

Func_19337: ; 0x19337
	ld hl, wd6bb
	ld bc, $0601
.asm_1933d
	push bc
	push hl
	ld a, [hli]
	add $f8
	ld b, a
	ld a, [hld]
	add $8
	ld c, a
	dec hl
	dec hl
	dec hl
	ld a, [hl]
	dec hl
	dec hl
	bit 0, [hl]
	call nz, Func_1936f
	pop hl
	pop bc
	ld a, c
	jr c, .asm_19360
	ld de, $0008
	add hl, de
	inc c
	dec b
	jr nz, .asm_1933d
	ret

.asm_19360
	ld [wTriggeredGameObjectIndex], a
	ld [wd6b4], a
	add $0
	ld [wTriggeredGameObject], a
	ld [wd6b5], a
	ret

Func_1936f: ; 0x1936f
	cp $b
	jp z, Func_19412
	ld a, [wBallXPos + 1]
	sub b
	cp $20
	jp nc, Func_19412
	ld b, a
	ld a, [wBallYPos + 1]
	sub c
	cp $20
	jp nc, Func_19412
	ld c, a
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
	sla e
	rl d
	ld l, b
	ld h, $0
	add hl, de
	sla l
	rl h
	sla l
	rl h
	ld de, BallPhysicsData_e4000
	add hl, de
	ld de, wBallXVelocity
	ld a, BANK(BallPhysicsData_e4000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_e4000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(BallPhysicsData_e4000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_e4000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_193ea
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_193ea
	pop hl
	bit 7, h
	jr z, .asm_193f6
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_193f6
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	jr c, .asm_19410
	ld a, [wRumbleDuration]
	and a
	jr nz, .asm_19410
	ld a, $5
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
.asm_19410
	scf
	ret

Func_19412: ; 0x19312
	and a
	ret

Func_19414: ; 0x19414
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .asm_1944f
	ld a, [wd6aa]
	bit 7, a
	jr nz, .asm_1944f
	ld a, [wIsBallColliding]
	and a
	ret z
	ld a, [wCurCollisionAttribute]
	sub $10
	ret c
	cp $c
	ret nc
	ld a, $1
	ld [wTriggeredGameObjectIndex], a
	add $6
	ld [wTriggeredGameObject], a
	ld b, a
	ld hl, wd6aa
	ld [hl], $0
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .asm_1944f
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.asm_1944f
	and a
	ret
