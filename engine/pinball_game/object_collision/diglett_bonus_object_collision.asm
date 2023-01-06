CheckDiglettBonusStageGameObjectCollisions: ; 0x19ab3
	call CheckDiglettBonusStageDiglettHeadsCollision
	call CheckDiglettBonusStageDugtrioCollision
	ret

CheckDiglettBonusStageDiglettHeadsCollision: ; 0x19aba
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .asm_19b16
	ld a, [wd73b]
	bit 7, a
	jr nz, .asm_19b16
	ld a, [wIsBallColliding]
	and a
	ret z ; is a collision happening?
	ld a, [wCurCollisionAttribute]
	sub $19
	ret c ; is the pinball colliding with a Diglett head?
	cp $33
	ret nc
	ld c, a
	ld b, $0
	ld hl, Data_19b18
	add hl, bc
	ld a, [hl]
	cp $a
	jr nc, .asm_19aed
	ld a, [wBallXPos + 1]
	cp $48
	ld a, $11
	jr nc, .asm_19af7
	xor a
	jr .asm_19af7

.asm_19aed
	ld a, [wBallXPos + 1]
	cp $68
	ld a, $11
	jr nc, .asm_19af7
	xor a
.asm_19af7
	add [hl]
	ld [wTriggeredGameObjectIndex], a
	add $0
	ld [wTriggeredGameObject], a
	ld b, a
	ld hl, wd73b
	ld [hl], $0
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .asm_19b16
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.asm_19b16
	and a
	ret

Data_19b18:
	db $01, $01, $01
	db $02, $02, $02
	db $03, $03, $03
	db $04, $04, $04
	db $05, $05, $05
	db $06, $06, $06
	db $07, $07, $07
	db $08, $08, $08
	db $09, $09, $09
	db $0A, $0A, $0A
	db $0B, $0B, $0B
	db $0C, $0C, $0C
	db $0D, $0D, $0D
	db $0E, $0E, $0E
	db $0F, $0F, $0F
	db $10, $10, $10
	db $11, $11, $11

CheckDiglettBonusStageDugtrioCollision: ; 0x19b4b
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .asm_19b86
	ld a, [wd75f]
	bit 7, a
	jr nz, .asm_19b86
	ld a, [wIsBallColliding]
	and a
	ret z
	ld a, [wCurCollisionAttribute]
	sub $14
	ret c
	cp $5
	ret nc
	ld a, $1
	ld [wTriggeredGameObjectIndex], a
	add $1f
	ld [wTriggeredGameObject], a
	ld b, a
	ld hl, wd75f
	ld [hl], $0
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .asm_19b86
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.asm_19b86
	and a
	ret
