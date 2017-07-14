ResolveDiglettBonusGameObjectCollisions: ; 0x19b88
	call Func_19c52
	call Func_1aad4
	call Func_19b92
	ret

Func_19b92: ; 0x19b92
	ld a, [wd73a]
	and a
	ret nz
	ld a, [wBallXPos + 1]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd73a], a
	xor a
	ld [wStageCollisionMap + $153], a
	ld [wStageCollisionMap + $173], a
	ld [wStageCollisionMap + $193], a
	ld a, $5
	ld [wStageCollisionMap + $172], a
	ld a, $7
	ld [wStageCollisionMap + $192], a
	call Func_19bbd
	ret

Func_19bbd: ; 0x19bbd
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_19bda
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_19bd0
	ld hl, Data_19c16
.asm_19bd0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_19bda)
	call QueueGraphicsToLoad
	ret

Data_19bda:
	dw Data_19bde
	dw Data_19be1

Data_19bde: ; 0x19bde
	dbw $1, TileListData_19be4

Data_19be1: ; 0x19be1
	dbw $1, TileListData_19bfd

TileListData_19be4: ; 0x19be4
	dw LoadTileLists
	db $09
	db $02
	dw vBGMap + $113
	db $4E, $4F
	db $02
	dw vBGMap + $133
	db $80, $4D
	db $03
	dw vBGMap + $152
	db $80, $4B, $4C
	db $02
	dw vBGMap + $172
	db $49, $4A
	db $00 ; terminator

TileListData_19bfd: ; 0x19bfd
	dw LoadTileLists
	db $09
	db $02
	dw vBGMap + $113
	db $1D, $FB
	db $02
	dw vBGMap + $133
	db $1B, $FA
	db $03
	dw vBGMap + $152
	db $18, $19, $FB
	db $02
	dw vBGMap + $172
	db $14, $15
	db $00  ; terminator

Data_19c16:
	dw Data_19c1a
	dw Data_19c1d

Data_19c1a: ; 0x19c1a
	dbw $1, Data_19c20

Data_19c1d: ; 0x19c1d
	dbw $1, Data_19c39

Data_19c20: ; 0x19c20
	dw LoadTileLists
	db $09
	db $02
	dw vBGMap + $113
	db $4E, $4F
	db $02
	dw vBGMap + $133
	db $80, $4D
	db $03
	dw vBGMap + $152
	db $80, $4B, $4C
	db $02
	dw vBGMap + $172
	db $49, $4A
	db $00  ; terminator

Data_19c39: ; 0x19c39
	dw LoadTileLists
	db $09
	db $02
	dw vBGMap + $113
	db $1D, $FB
	db $02
	dw vBGMap + $133
	db $1B, $FA
	db $03
	dw vBGMap + $152
	db $18, $19, $FB
	db $02
	dw vBGMap + $172
	db $14, $15
	db $00  ; terminator

Func_19c52: ; 0x19c52
	ld a, [wd73b]
	and a
	jr z, .asm_19cc8
	xor a
	ld [wd73b], a
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueue
	lb de, $00, $35
	call PlaySoundEffect
	ld hl, $0100
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wd73c]
	sub $1
	ld c, a
	ld b, $0
	ld hl, wDiglettStates
	add hl, bc
	ld a, [hl]
	cp $6
	jr nc, .asm_19cc8
	ld a, $8
	ld [hl], a
	call Func_19da8
	call Func_19df0
	ld hl, wDiglettStates
	ld bc, NUM_DIGLETTS << 8
	xor a
.asm_19ca0
	ld a, [hli]
	and a
	jr z, .asm_19ca8
	cp $6
	jr c, .asm_19ca9
.asm_19ca8
	inc c
.asm_19ca9
	dec b
	jr nz, .asm_19ca0
	ld a, c
	cp NUM_DIGLETTS
	jr nz, .asm_19cc8
	ld hl, AnimationData_1ac75
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $1
	ld [wDugrioState], a
	call Func_1ac2c
	ld de, $0002
	call PlaySong
.asm_19cc8
	call Func_19cdd
	ld a, [wd765]
	and a
	ret nz
	ld a, $1
	ld [wd765], a
	ld a, [wDugrioState]
	and a
	call nz, Func_1ac2c
	ret

Func_19cdd: ; 0x19cdd
	ld a, [wDiglettsInitializedFlag]
	and a
	jr nz, .alreadyInitializedDigletts
	ld a, [wDiglettInitDelayCounter]
	add DIGLETT_INITIALIZE_DELAY
	ld [wDiglettInitDelayCounter], a
	ret nc
	ld hl, DiglettInitializeOrder
	ld a, [wCurrentDiglett]
	ld c, a
	ld b, $0
	add hl, bc
	ld b, $1
.asm_19cf8
	push bc
	ld a, [hli]
	bit 7, a
	jr z, .asm_19d02
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
.asm_19d02
	push hl
	ld c, a
	ld b, $0
	ld hl, wDiglettStates
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_19d29
	dec a
	jr nz, .asm_19d21
	; pick a random starting state for the diglett that isn't the "hiding" state
	call GenRandom
	and $3
	add $2
	ld [hl], a
	call Func_19da8
	call Func_19dcd
	jr .asm_19d29

.asm_19d21
	and $3
	add $2
	ld [hl], a
	call Func_19da8
.asm_19d29
	pop hl
	pop bc
	dec b
	jr nz, .asm_19cf8
	ld hl, wDiglettsInitializedFlag
	ld a, [wCurrentDiglett]
	add $1
	cp NUM_DIGLETTS
	jr c, .notDoneInitializingDigletts
	set 0, [hl]
	sub NUM_DIGLETTS
.notDoneInitializingDigletts
	ld [wCurrentDiglett], a
	ret

.alreadyInitializedDigletts
	ld hl, DiglettUpdateOrder
	ld a, [wCurrentDiglett]
	ld c, a
	ld b, $0
	add hl, bc
	ld b, $4  ; update 4 digletts
.updateDiglettLoop
	push bc
	ld a, [hli]
	bit 7, a
	jr z, .asm_19d58
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
.asm_19d58
	push hl
	ld c, a
	ld b, $0
	ld hl, wDiglettStates
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_19d8f
	dec a
	jr nz, .asm_19d77
	call GenRandom
	and $3
	add $2
	ld [hl], a
	call Func_19da8
	call Func_19dcd
	jr .asm_19d8f

.asm_19d77
	cp $5
	jr c, .incrementDiglettState
	ld [hl], a
	jr nz, .asm_19d8f
	xor a
	ld [hl], a
	ld a, $1
	call Func_19da8
	jr .asm_19d8f

.incrementDiglettState
	and $3
	add $2
	ld [hl], a
	call Func_19da8
.asm_19d8f
	pop hl
	pop bc
	dec b
	jr nz, .updateDiglettLoop
	ld hl, wDiglettsInitializedFlag
	ld a, [wCurrentDiglett]
	add $4
	cp NUM_DIGLETTS
	jr c, .asm_19da4
	set 0, [hl]
	sub NUM_DIGLETTS
.asm_19da4
	ld [wCurrentDiglett], a
	ret

Func_19da8: ; 0x19da8
; input: a = diglett state
;        c = diglett index
	cp $6
	jr c, .asm_19dae
	ld a, $6  ; "getting hit" state
.asm_19dae
	push bc
	ld b, a
	sla c
	ld a, c
	sla c
	add c
	add b  ; a = (index * 6) + state
	dec a
	ld c, a
	ld b, $0  ; bc = (index * 6) + state - 1
	sla c
	rl b  ; bc = 2 * ((index * 6) + state - 1)
	ld hl, DiglettTileDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(DiglettTileDataPointers)
	call QueueGraphicsToLoad
	pop bc
	ret

Func_19dcd: ; 0x19dcd
	sla c
	ld a, c
	sla c
	add c
	ld c, a
	ld b, $0
	ld hl, Data_19e13
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add $1f
	ld e, a
	jr nc, .asm_19dea
	inc d
.asm_19dea
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret

Func_19df0: ; 0x19df0
	sla c
	ld a, c
	sla c
	add c
	ld c, a
	ld b, $0
	ld hl, Data_19e13
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, $2
	ld [de], a
	inc de
	ld [de], a
	ld a, e
	add $1f
	ld e, a
	jr nc, .asm_19e0d
	inc d
.asm_19e0d
	ld a, $2
	ld [de], a
	inc de
	ld [de], a
	ret

Data_19e13:
	dw wStageCollisionMap + $a1
	db $19, $19, $1A, $1B

	dw wStageCollisionMap + $e1
	db $1C, $1C, $1D, $1E

	dw wStageCollisionMap + $121
	db $1F, $1F, $20, $21

	dw wStageCollisionMap + $c3
	db $22, $22, $23, $24

	dw wStageCollisionMap + $103
	db $25, $25, $26, $27

	dw wStageCollisionMap + $143
	db $28, $28, $29, $2A

	dw wStageCollisionMap + $a5
	db $2B, $2B, $2C, $2D

	dw wStageCollisionMap + $e5
	db $2E, $2E, $2F, $30

	dw wStageCollisionMap + $125
	db $31, $31, $32, $33

	dw wStageCollisionMap + $165
	db $34, $34, $35, $36

	dw wStageCollisionMap + $c7
	db $37, $37, $38, $39

	dw wStageCollisionMap + $107
	db $3A, $3A, $3B, $3C

	dw wStageCollisionMap + $147
	db $3D, $3D, $3E, $3F

	dw wStageCollisionMap + $187
	db $40, $40, $41, $42

	dw wStageCollisionMap + $e9
	db $43, $43, $44, $45

	dw wStageCollisionMap + $129
	db $46, $46, $47, $48

	dw wStageCollisionMap + $169
	db $49, $49, $4A, $4B

	dw wStageCollisionMap + $cb
	db $19, $19, $1A, $1B

	dw wStageCollisionMap + $10b
	db $1C, $1C, $1D, $1E

	dw wStageCollisionMap + $14b
	db $1F, $1F, $20, $21

	dw wStageCollisionMap + $18b
	db $22, $22, $23, $24

	dw wStageCollisionMap + $ad
	db $25, $25, $26, $27

	dw wStageCollisionMap + $ed
	db $28, $28, $29, $2A

	dw wStageCollisionMap + $12d
	db $2B, $2B, $2C, $2D

	dw wStageCollisionMap + $16d
	db $2E, $2E, $2F, $30

	dw wStageCollisionMap + $cf
	db $31, $31, $32, $33

	dw wStageCollisionMap + $10f
	db $34, $34, $35, $36

	dw wStageCollisionMap + $14f
	db $37, $37, $38, $39

	dw wStageCollisionMap + $b1
	db $3A, $3A, $3B, $3C

	dw wStageCollisionMap + $f1
	db $3D, $3D, $3E, $3F

	dw wStageCollisionMap + $131
	db $40, $40, $41, $42

	; unused pointers?
	dw DiglettInitializeOrder
	dw DiglettUpdateOrder

INCLUDE "data/diglett_stage/diglett_stage_animation_data.asm"

Func_1aad4: ; 0x1aad4
	ld a, [wd75f]
	and a
	jr z, .asm_1ab2c
	xor a
	ld [wd75f], a
	ld a, [wDugrioState]
	bit 0, a
	jr z, .asm_1ab2c
	cp $7
	jr z, .asm_1ab2c
	inc a
	ld [wDugrioState], a
	sla a
	ld c, a
	ld b, $0
	ld hl, AnimationDataPointers_1ac62
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDugtrioAnimation
	call InitAnimation
	ld bc, FiveMillionPoints
	callba AddBigBCD6FromQueue
	lb de, $00, $36
	call PlaySoundEffect
	ld a, $33
	ld [wRumblePattern], a
	ld a, $8
	ld [wRumbleDuration], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
.asm_1ab2c
	call Func_1ab30
	ret

Func_1ab30: ; 0x1ab30
	ld a, [wDugrioState]
	sla a
	ld c, a
	ld b, $0
	ld hl, AnimationDataPointers_1ac62
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDugtrioAnimation
	call UpdateAnimation
	ret nc
	ld a, [wDugrioState]
	and a
	ret z
	cp $1
	jr nz, .asm_1ab64
	ld a, [wDugtrioAnimationIndex]
	cp $3
	ret nz
	ld hl, AnimationData_1ac75
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $1
	ld [wDugrioState], a
	ret

.asm_1ab64
	cp $2
	jr nz, .asm_1ab7d
	ld a, [wDugtrioAnimationIndex]
	cp $1
	ret nz
	ld hl, AnimationData_1ac7f
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $3
	ld [wDugrioState], a
	ret

.asm_1ab7d
	cp $3
	jr nz, .asm_1ab96
	ld a, [wDugtrioAnimationIndex]
	cp $3
	ret nz
	ld hl, AnimationData_1ac7f
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $3
	ld [wDugrioState], a
	ret

.asm_1ab96
	cp $4
	jr nz, .asm_1abaf
	ld a, [wDugtrioAnimationIndex]
	cp $1
	ret nz
	ld hl, AnimationData_1ac89
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $5
	ld [wDugrioState], a
	ret

.asm_1abaf
	cp $5
	jr nz, .asm_1abc8
	ld a, [wDugtrioAnimationIndex]
	cp $3
	ret nz
	ld hl, AnimationData_1ac89
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $5
	ld [wDugrioState], a
	ret

.asm_1abc8
	cp $6
	jr nz, .asm_1abe1
	ld a, [wDugtrioAnimationIndex]
	cp $1
	ret nz
	ld hl, AnimationData_1ac93
	ld de, wDugtrioAnimation
	call InitAnimation
	ld a, $7
	ld [wDugrioState], a
	ret

.asm_1abe1
	cp $7
	ret nz
	ld a, [wDugtrioAnimationIndex]
	cp $1
	jr nz, .asm_1abf2
	ld de, $0000
	call PlaySong
	ret

.asm_1abf2
	cp $2
	ret nz
	ld hl, AnimationData_1ac72
	ld de, wDugtrioAnimation
	call InitAnimation
	xor a
	ld [wDugrioState], a
	ld [wNextBonusStage], a ; BONUS_STAGE_ORDER_GENGAR
	ld a, $1
	ld [wCompletedBonusStage], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	ld de, DiglettStageClearedText
	call LoadScrollingText
	lb de, $4b, $2a
	call PlaySoundEffect
	ld a, $1
	ld [wd7be], a
	call Func_2862
	ld hl, Data_1ac56
	jr asm_1ac2f

Func_1ac2c: ; 0x1ac2c
	ld hl, Data_1ac4a
asm_1ac2f:
	ld de, wStageCollisionMap + $68
	ld b, $3
.asm_1ac34
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add $1d
	ld e, a
	jr nc, .asm_1ac46
	inc d
.asm_1ac46
	dec b
	jr nz, .asm_1ac34
	ret

Data_1ac4a:
	db $00, $00, $00, $00
	db $14, $14, $14, $14
	db $15, $16, $17, $18

Data_1ac56:
	db $50, $02, $02, $51
	db $02, $02, $02, $02
	db $02, $02, $02, $02

AnimationDataPointers_1ac62: ; 0x1ac62
	dw AnimationData_1ac72
	dw AnimationData_1ac75
	dw AnimationData_1ac7c
	dw AnimationData_1ac7f
	dw AnimationData_1ac86
	dw AnimationData_1ac89
	dw AnimationData_1ac90
	dw AnimationData_1ac93

AnimationData_1ac72: ; 0x1ac72
; Each entry is [duration][OAM id]
	db $01, $0C
	db $00 ; terminator

AnimationData_1ac75: ; 0x1ac75
; Each entry is [duration][OAM id]
	db $0E, $00
	db $0E, $01
	db $0E, $02
	db $00 ; terminator

AnimationData_1ac7c: ; 0x1ac7c
; Each entry is [duration][OAM id]
	db $0D, $03
	db $00 ; terminator

AnimationData_1ac7f: ; 0x1ac7f
; Each entry is [duration][OAM id]
	db $0E, $04
	db $0E, $05
	db $0E, $06
	db $00

AnimationData_1ac86: ; 0x1ac86
; Each entry is [duration][OAM id]
	db $0D, $07
	db $00 ; terminator

AnimationData_1ac89: ; 0x1ac89
; Each entry is [duration][OAM id]
	db $0E, $08
	db $0E, $09
	db $0E, $0A
	db $00

AnimationData_1ac90: ; 0x1ac90
; Each entry is [duration][OAM id]
	db $0D, $0B
	db $00 ; terminator

AnimationData_1ac93: ; 0x1ac93
; Each entry is [duration][OAM id]
	db $01, $0D
	db $40, $0D
	db $00 ; terminator
