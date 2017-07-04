CheckGameObjectCollisions: ; 0x2720
	ld a, $ff
	ld [wTriggeredGameObject], a
	call CheckGameObjectCollisions_
	ld a, [wTriggeredGameObject]
	ld [wPreviousTriggeredGameObject], a
	ret

CheckGameObjectCollisions_: ; 0x272f
	ld a, [wCurrentStage]
	call CallInFollowingTable
GameObjectCollisions_CallTable: ; 0x2735
	padded_dab CheckRedStageTopGameObjectCollisions       ; STAGE_RED_FIELD_TOP
	padded_dab CheckRedStageBottomGameObjectCollisions    ; STAGE_RED_FIELD_BOTTOM
	padded_dab DoNothing_18061
	padded_dab Func_18062
	padded_dab CheckBlueStageTopGameObjectCollisions      ; STAGE_BLUE_FIELD_TOP
	padded_dab CheckBlueStageBottomGameObjectCollisions   ; STAGE_BLUE_FIELD_BOTTOM
	padded_dab CheckGengarBonusStageGameObjectCollisions  ; STAGE_GENGAR_BONUS
	padded_dab CheckGengarBonusStageGameObjectCollisions  ; STAGE_GENGAR_BONUS
	padded_dab CheckMewtwoBonusStageGameObjectCollisions  ; STAGE_MEWTWO_BONUS
	padded_dab CheckMewtwoBonusStageGameObjectCollisions  ; STAGE_MEWTWO_BONUS
	padded_dab CheckMeowthBonusStageGameObjectCollisions  ; STAGE_MEOWTH_BONUS
	padded_dab CheckMeowthBonusStageGameObjectCollisions  ; STAGE_MEOWTH_BONUS
	padded_dab CheckDiglettBonusStageGameObjectCollisions ; STAGE_DIGLETT_BONUS
	padded_dab CheckDiglettBonusStageGameObjectCollisions ; STAGE_DIGLETT_BONUS
	padded_dab CheckSeelBonusStageGameObjectCollisions    ; STAGE_SEEL_BONUS
	padded_dab CheckSeelBonusStageGameObjectCollisions    ; STAGE_SEEL_BONUS

HandleGameObjectCollision: ; 0x2775
; Handle collision checking for one set of game objects, such as the bumpers, Pikachu savers, etc.
; Input: hl = pointer to collision attribute list for game objects
;        de = pointer to object collision struct
;        carry flag = unset to skip the collision attribute list check
	ld a, [wTriggeredGameObject]
	inc a
	jr nz, .noTrigger
	ld a, [bc]
	bit 7, a
	jr nz, .noTrigger
	push bc
	push de
	call nc, IsCollisionInList
	pop hl
	call c, CheckGameObjectCollision
	ld a, [wTriggeredGameObject]
	ld b, a
	pop hl
	ld [hl], $0
	jr nc, .noTrigger
	ld a, [wPreviousTriggeredGameObject]
	cp b
	jr z, .noTrigger
	ld a, [wTriggeredGameObjectIndex]
	ld [hli], a
	ld a, [wTriggeredGameObject]
	ld [hl], a
	scf
	ret

.noTrigger
	and a
	ret

CheckGameObjectCollision: ; 0x27a4
; Checks if any of the given game objects are colliding with the pinball.
; Saves information about which game object was collided.
; Sets carry flag if a game object was collided.
; Input: hl = pointer to game object struct with the following format:
;             [x distance][y distance] (defines bounding box for the following list of objects)
;             [game object id][object x][object y] (terminate this list with $FF)
	xor a
	ld [wTriggeredGameObjectIndex], a
	ld a, [hli] ; x distance threshold
	ld d, a
	ld a, [hli] ; y distance threshold
	ld e, a
	ld a, [wBallXPos + 1]
	ld b, a
	ld a, [wBallYPos + 1]
	ld c, a
.loop
	ld a, [wTriggeredGameObjectIndex]
	inc a
	ld [wTriggeredGameObjectIndex], a
	ld a, [hli]
	ld [wTriggeredGameObject], a
	cp $ff
	ret z
	ld a, [hli]
	sub b
	bit 7, a
	jr z, .compareXDifference
	cpl   ; calculate absolute value of the difference
	inc a
.compareXDifference
	cp d
	ld a, [hli]
	jr nc, .loop
	sub c
	bit 7, a
	jr z, .compareYDifference
	cpl   ; calculate absolute value of the difference
	inc a
.compareYDifference
	cp e
	jr nc, .loop
	scf
	ret

IsCollisionInList: ; 0x27da
; Checks if the pinball's current collision attribute is in the given list.
; Input: hl = pointer to list of collision attributes, terminated by $FF.
; Output: Sets carry flag if the attribute is in the list.
; First byte in list is 0 if the list is independent of the stage's current collision state (Red stage's
; top section changes during gameply.)
	ld a, [hli]
	and a
	jr z, .checkList
	dec hl
	ld a, [wStageCollisionState]
	ld c, a
	ld b, $0
	add hl, bc
	ld c, [hl]
	add hl, bc
.checkList
	ld a, [wd7e9]
	and a
	ret z
	ld a, [wCurCollisionAttribute]
	ld b, a
	ld c, -1 ; This saves the list offset in C, but the result isn't used by any callers of this routine.
.loop
	inc c
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, .loop
	scf
	ret

PinballCollidesWithPoints: ; 0x27fd
; Checks if pinball collides with any of the (x, y) points in the given list.
; Saves the index of the collided point.
; Input:  hl = pointer to array of (x, y) points
; Output: Saves index of collided point in wd578
	ld a, [wBallXPos + 1]
	ld b, a
	ld a, [wBallYPos + 1]
	ld c, a
	ld d, $0
.nextPoint
	ld a, [hli]
	and a
	ret z
	inc d
	ld a, [hli]
	sub b
	cp $e8
	ld a, [hli]
	jr c, .nextPoint
	sub c
	cp $e8
	jr c, .nextPoint
	ld a, d
	ld [wd578], a
	ret

ResolveGameObjectCollisions: ; 0x281c
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_2822: ; 0x2822
; not collisions
	padded_dab ResolveRedFieldTopGameObjectCollisions     ; STAGE_RED_FIELD_TOP
	padded_dab ResolveRedFieldBottomGameObjectCollisions  ; STAGE_RED_FIELD_BOTTOM
	padded_dab DoNothing_1806d
	padded_dab Func_1806e
	padded_dab ResolveBlueFieldTopGameObjectCollisions    ; STAGE_BLUE_FIELD_TOP
	padded_dab ResolveBlueFieldBottomGameObjectCollisions ; STAGE_BLUE_FIELD_BOTTOM
	padded_dab ResolveGengarBonusGameObjectCollisions     ; STAGE_GENGAR_BONUS
	padded_dab ResolveGengarBonusGameObjectCollisions     ; STAGE_GENGAR_BONUS
	padded_dab ResolveMewtwoBonusGameObjectCollisions     ; STAGE_MEWTWO_BONUS
	padded_dab ResolveMewtwoBonusGameObjectCollisions     ; STAGE_MEWTWO_BONUS
	padded_dab ResolveMeowthBonusGameObjectCollisions     ; STAGE_MEOWTH_BONUS
	padded_dab ResolveMeowthBonusGameObjectCollisions     ; STAGE_MEOWTH_BONUS
	padded_dab ResolveDiglettBonusGameObjectCollisions    ; STAGE_DIGLETT_BONUS
	padded_dab ResolveDiglettBonusGameObjectCollisions    ; STAGE_DIGLETT_BONUS
	padded_dab ResolveSeelBonusGameObjectCollisions       ; STAGE_SEEL_BONUS
	padded_dab ResolveSeelBonusGameObjectCollisions       ; STAGE_SEEL_BONUS
