Func_24319: ; 0x2438f
	ld a, [wd6f4]
	cp $0
	jr z, .asm_24333
	ld a, [wd71a]
	sub $4
	ld b, a
	ld a, [wd727]
	add $4
	ld c, a
	call Func_24405
	ld a, $0
	jr c, .asm_24373
.asm_24333
	ld a, [wd6f4]
	cp $1
	jr z, .asm_2434d
	ld a, [wd71b]
	sub $4
	ld b, a
	ld a, [wd728]
	add $4
	ld c, a
	call Func_24405
	ld a, $1
	jr c, .asm_24373
.asm_2434d
	ld a, [wd6f4]
	cp $2
	ret z
	ld a, [wd71c]
	sub $4
	ld b, a
	ld a, [wd729]
	add $4
	ld c, a
	call Func_24405
	ld a, $2
	jr c, .asm_24373
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld [hl], $0
	ret

.asm_24373
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	inc [hl]
	ld d, $4
	ld a, [wd6f4]
	add d
	ld d, a
	ld a, [hl]
	cp d
	ret nc
	ld hl, wd6f5
	add hl, bc
	ld [hl], $0
	ret

Func_2438f: ; 0x2438f
	ld a, [wd6f4]
	cp $a
	jr z, .asm_243a9
	ld a, [wd724]
	sub $4
	ld b, a
	ld a, [wd731]
	add $4
	ld c, a
	call Func_24405
	ld a, $a
	jr c, .asm_243e9
.asm_243a9
	ld a, [wd6f4]
	cp $b
	jr z, .asm_243c3
	ld a, [wd725]
	sub $4
	ld b, a
	ld a, [wd732]
	add $4
	ld c, a
	call Func_24405
	ld a, $b
	jr c, .asm_243e9
.asm_243c3
	ld a, [wd6f4]
	cp $c
	ret z
	ld a, [wd726]
	sub $4
	ld b, a
	ld a, [wd733]
	add $4
	ld c, a
	call Func_24405
	ld a, $c
	jr c, .asm_243e9
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld [hl], $0
	ret

.asm_243e9
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	inc [hl]
	ld d, $4
	ld a, [wd6f4]
	add d
	ld d, a
	ld a, [hl]
	cp d
	ret nc
	ld hl, wd6f5
	add hl, bc
	ld [hl], $0
	ret

Func_24405: ; 0x24405
	ld hl, wd71a
	ld a, [wd6f4]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	add $8
	sub b
	cp $18
	jr nc, .asm_24428
	ld b, a
	ld hl, wd727
	add hl, de
	ld a, [hl]
	add $8
	sub c
	cp $18
	jr nc, .asm_24428
	ld c, a
	ld d, b
	scf
	ret

.asm_24428
	and a
	ret

ResolveMeowthBonusGameObjectCollisions: ; 0x2442a
	ld a, [wd710]
	jr nz, .asm_2443f
	ld a, [wMeowthStageBonusCounter]
	dec a
	dec a
	cp $fe
	jr z, .asm_24447
	cp $ff
	jr z, .asm_24447
	ld [wd79a], a
.asm_2443f
	ld de, wd79a
	call Func_24f00
	jr .asm_2444b

.asm_24447
	xor a
	ld [wd79a], a
.asm_2444b
	call Func_244f5
	call Func_245ab
	call Func_248ac
	call Func_24d07
	ld a, [wMeowthStageScore]
	cp $14
	jr c, .asm_24498
	ld a, [wd712]
	cp $2
	jr nc, .asm_24498
	ld a, [wNextBonusStage]
	cp BONUS_STAGE_ORDER_SEEL
	ret z
	ld a, BONUS_STAGE_ORDER_SEEL
	ld [wd712], a
	ld [wNextBonusStage], a
	ld a, $96
	ld [wd739], a
	ld de, $0000
	call PlaySong
	ld a, $1
	ld [wCompletedBonusStage], a
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText3
	ld de, MeowthStageClearedText
	call LoadScrollingText
	lb de, $4b, $2a
	call PlaySoundEffect
.asm_24498
	ld a, [wd712]
	cp $4
	jr nz, .asm_244b0
	ld a, [wSFXTimer]
	and a
	jr nz, .asm_244b0
	ld de, $0004
	call PlaySong
	ld a, $5
	ld [wd712], a
.asm_244b0
	ld a, [wd712]
	cp $4
	jr z, .asm_244c1
	callba PlayLowTimeSfx
.asm_244c1
	ld a, [wTimeRanOut]
	and a
	ret z
	xor a
	ld [wTimeRanOut], a
	ld a, $1
	ld [wd7be], a
	call Func_2862
	callba StopTimer
	ld a, $1
	ld [wd713], a
	ld a, $1
	ld [wd712], a
	ld hl, MeowthAnimationData5
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $4
	ld [wd6ec], a
	ret

Func_244f5: ; 0x244f5
	ld a, [wd6e6]
	and a
	ret nz
	ld a, [wBallXPos + 1]
	cp $8a
	ret nc
	ld a, $1
	ld [wStageCollisionState], a
	ld [wd6e6], a
	callba LoadStageCollisionAttributes
	call Func_24516
	ret

Func_24516: ; 0x24516
	ld a, [wStageCollisionState]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_24533
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_24529
	ld hl, TileDataPointers_2456f
.asm_24529
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_24533)
	call QueueGraphicsToLoad
	ret

TileDataPointers_24533: ; 0x24533
	dw TileData_24537
	dw TileData_2453a

TileData_24537: ; 0x24537
	db $01
	dw TileData_2453D

TileData_2453a: ; 0x2453a
	db $01
	dw TileData_24556

TileData_2453D: ; 0x2453D
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $01, $02

	db $02 ; number of tiles
	dw vBGMap + $133
	db $FF, $00

	db $03 ; number of tiles
	dw vBGMap + $152
	db $80, $FD, $FE

	db $02 ; number of tiles
	dw vBGMap + $172
	db $F6, $FA

	db $00 ; terminator

TileData_24556: ; 0x24556
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $E9, $E5

	db $02 ; number of tiles
	dw vBGMap + $133
	db $E7, $E3

	db $03 ; number of tiles
	dw vBGMap + $152
	db $12, $13, $E4

	db $02 ; number of tiles
	dw vBGMap + $172
	db $10, $11

	db $00 ; terminator

TileDataPointers_2456f: ; 0x2456f
	dw TileData_24573
	dw TileData_24576

TileData_24573: ; 0x
	db $01
	dw TileData_24579

TileData_24576: ; 0x
	db $01
	dw TileData_24592

TileData_24579: ; 0x24579
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $F6, $F5

	db $02 ; number of tiles
	dw vBGMap + $133
	db $F4, $F3

	db $03 ; number of tiles
	dw vBGMap + $152
	db $80, $F1, $F2

	db $02 ; number of tiles
	dw vBGMap + $172
	db $EA, $EE

	db $00 ; terminator

TileData_24592: ; 0x24592
	dw LoadTileLists
	db $09 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $113
	db $E5, $E3

	db $02 ; number of tiles
	dw vBGMap + $133
	db $E4, $E2

	db $03 ; number of tiles
	dw vBGMap + $152
	db $F0, $EF, $E3

	db $02 ; number of tiles
	dw vBGMap + $172
	db $ED, $EC

	db $00 ; terminator

Func_245ab: ; 0x245ab
	ld a, [wd6e7]
	and a
	jr z, .asm_24621
	cp $2
	jr z, .asm_24621
	ld a, $1
	ld [wd6f3], a
	ld a, [wMeowthYPosition]
	cp $20
	jr z, .asm_245c7
	cp $10
	jr z, .asm_245cc
	jr .asm_245cf

.asm_245c7
	call Func_247d9
	jr .asm_245cf

.asm_245cc
	call Func_24c28
.asm_245cf
	xor a
	ld [wd6e7], a
	ld [wd6f3], a
	ld a, $ff
	ld [wRumblePattern], a
	ld a, $3
	ld [wRumbleDuration], a
	lb de, $00, $33
	call PlaySoundEffect
	ld bc, OneThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wMeowthStageBonusCounter], a
	ld a, [wd6ec]
	cp $2
	jr nc, .asm_24621
	and a
	jr nz, .asm_24611
	ld hl, MeowthAnimationData3
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $2
	ld [wd6ec], a
	jr .asm_24651

.asm_24611
	ld hl, MeowthAnimationData4
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $3
	ld [wd6ec], a
	jr .asm_24651

.asm_24621
	ld a, [wd713]
	and a
	jr z, .asm_2462e
	ld a, $4
	ld [wd6ec], a
	jr .asm_24651

.asm_2462e
	ld a, [wd6ec]
	cp $2
	jr nc, .asm_24651
	ld a, [wd70b]
	cp $3
	jr nz, .asm_24651
	ld a, [wd70c]
	cp $3
	jr nz, .asm_24651
	ld hl, MeowthAnimationData5
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $4
	ld [wd6ec], a
.asm_24651
	ld a, [wd6ec]
	cp $2
	call c, Func_24709
	call Func_2465d
	ret

Func_2465d: ; 0x2465d
	ld a, [wd6ec]
	sla a
	ld c, a
	ld b, $0
	ld hl, MewothAnimationDataTable ; 0x246e2
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMeowthAnimation
	call UpdateAnimation
	ret nc
	ld a, [wd6ec]
	and a
	jr nz, .asm_24689
	ld a, [wMeowthAnimationIndex]
	cp $4
	ret nz
	ld hl, MeowthAnimationData1
	ld de, wMeowthAnimation
	call InitAnimation
	ret

.asm_24689
	cp $1
	jr nz, .asm_2469d
	ld a, [wMeowthAnimationIndex]
	cp $4
	ret nz
	ld hl, MeowthAnimationData2
	ld de, wMeowthAnimation
	call InitAnimation
	ret

.asm_2469d
	cp $2
	jr nz, .asm_246b5
	ld a, [wMeowthAnimationIndex]
	cp $1
	ret nz
	ld hl, MeowthAnimationData1
	ld de, wMeowthAnimation
	call InitAnimation
	xor a
	ld [wd6ec], a
	ret

.asm_246b5
	cp $3
	jr nz, .asm_246ce
	ld a, [wMeowthAnimationIndex]
	cp $1
	ret nz
	ld hl, MeowthAnimationData2
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $1
	ld [wd6ec], a
	ret

.asm_246ce
	cp $4
	jr nz, .asm_24689
	ld a, [wMeowthAnimationIndex]
	cp $2
	ret nz
	ld hl, MeowthAnimationData5
	ld de, wMeowthAnimation
	call InitAnimation
	ret

MewothAnimationDataTable: ; 0x246e2
	dw MeowthAnimationData1
	dw MeowthAnimationData2
	dw MeowthAnimationData3
	dw MeowthAnimationData4
	dw MeowthAnimationData5

MeowthAnimationData1: ; 0x246ec
; Each entry is [OAM id][duration]
	db $10, $00
	db $0B, $01
	db $10, $02
	db $0C, $01
	db $00 ; terminator

MeowthAnimationData2: ; 0x246f5
; Each entry is [OAM id][duration]
	db $10, $04
	db $0B, $05
	db $10, $06
	db $0C, $05
	db $00 ; terminator

MeowthAnimationData3: ; 0x246fe
; Each entry is [OAM id][duration]
	db $16, $03
	db $00 ; terminator

MeowthAnimationData4: ; 0x24701
; Each entry is [OAM id][duration]
	db $16, $07
	db $00 ; terminator

MeowthAnimationData5: ; 0x24704
	db $17, $08
	db $17, $09
	db $00 ; terminator

Func_24709: ; 0x24709
	ld a, [wMeowthXPosition]
	ld hl, wMeowthXMovement
	add [hl]
	ld [wMeowthXPosition], a
	ld hl, wMeowthYMovement
	ld a, [hl]
	and a
	jr z, .asm_24730
	bit 7, [hl]
	ld a, [wMeowthYPosition]
	jr nz, .asm_24724
	inc a
	jr .asm_24725

.asm_24724
	dec a
.asm_24725
	cp $21
	jr z, .asm_24730
	cp $f
	jr z, .asm_24730
	ld [wMeowthYPosition], a
.asm_24730
	call Func_24737
	call Func_2476d
	ret

Func_24737: ; 0x24737
	ld a, [wMeowthXPosition]
	cp $8
	jr nc, .asm_24742
	ld a, $1
	jr .asm_2475a

.asm_24742
	cp $78
	jr c, .asm_2474a
	ld a, $ff
	jr .asm_2475a

.asm_2474a
	ld a, [hNumFramesDropped]
	and $3f
	ret nz
	call GenRandom
	bit 7, a
	ld a, $1
	jr z, .asm_2475a
	ld a, $ff
.asm_2475a
	ld [wMeowthXMovement], a
	bit 7, a
	ld a, $1
	jr z, .asm_24764
	xor a
.asm_24764
	ld [wd6ec], a
	ld a, $2
	ld [wMeowthAnimationFrameCounter], a
	ret

Func_2476d: ; 0x2476d
	ld a, [wMeowthYMovement]
	and a
	jr z, .asm_247ab
	cp $1
	jr z, .asm_24791
	ld a, [wMeowthYPosition]
	cp $10
	jr nz, .asm_2478d
	ld a, [wd6e7]
	cp $2
	jr nz, .asm_2478a
	ld a, $1
	ld [wd6e7], a
.asm_2478a
	xor a
	jr .asm_247c9

.asm_2478d
	ld a, $ff
	jr .asm_247c9

.asm_24791
	ld a, [wMeowthYPosition]
	cp $20
	jr nz, .asm_247a7
	ld a, [wd6e7]
	cp $2
	jr nz, .asm_247a4
	ld a, $1
	ld [wd6e7], a
.asm_247a4
	xor a
	jr .asm_247c9

.asm_247a7
	ld a, $1
	jr .asm_247c9

.asm_247ab
	ld a, [wd70b]
	cp $3
	jr z, .asm_247cd
	ld a, [wd70c]
	cp $3
	jr z, .asm_247d3
	ld a, [hNumFramesDropped]
	and $3f
	ret nz
	call GenRandom
	bit 0, a
	ld a, $1
	jr z, .asm_247c9
	ld a, $ff
.asm_247c9
	ld [wMeowthYMovement], a
	ret

.asm_247cd
	ld a, $ff
	ld [wMeowthYMovement], a
	ret

.asm_247d3
	ld a, $1
	ld [wMeowthYMovement], a
	ret

Func_247d9: ; 0x247d9
	ld a, [wd6f3]
	and a
	ret z
	ld a, [wd71a]
	cp $c8
	jr nz, .asm_24823
	ld a, [wMeowthXPosition]
	add $8
	ld [wd71a], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd727], a
	ld a, $1
	ld [wd717], a
	xor a
	ld [wd6f3], a
	ld [wd714], a
	ld [wd6f5], a
	ld [wd6f8], a
	ld [wd6fb], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wBallXPos + 1]
	cp b
	jr nc, .asm_2481d
	ld a, $0
	ld [wd72a], a
	jr .asm_24822

.asm_2481d
	ld a, $1
	ld [wd72a], a
.asm_24822
	ret

.asm_24823
	ld a, [wd71b]
	cp $c8
	jr nz, .asm_24868
	ld a, [wMeowthXPosition]
	add $8
	ld [wd71b], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd728], a
	ld a, $1
	ld [wd718], a
	xor a
	ld [wd6f3], a
	ld [wd715], a
	ld [wd6f6], a
	ld [wd6f9], a
	ld [wd6fc], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wBallXPos + 1]
	cp b
	jr nc, .asm_24862
	ld a, $0
	ld [wd72b], a
	jr .asm_24867

.asm_24862
	ld a, $1
	ld [wd72b], a
.asm_24867
	ret

.asm_24868
	ld a, [wd71c]
	cp $c8
	ret nz
	ld a, [wMeowthXPosition]
	add $8
	ld [wd71c], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd729], a
	ld a, $1
	ld [wd719], a
	xor a
	ld [wd6f3], a
	ld [wd716], a
	ld [wd6f7], a
	ld [wd6fa], a
	ld [wd6fd], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wBallXPos + 1]
	cp b
	jr nc, .asm_248a6
	ld a, $0
	ld [wd72c], a
	jr .asm_248ab

.asm_248a6
	ld a, $1
	ld [wd72c], a
.asm_248ab
	ret

Func_248ac: ; 0x248ac
	ld a, [wd717]
	cp $1
	jr nz, .asm_248d3
	ld a, [wd714]
	cp $a
	jr z, .asm_248c4
	ld a, $0
	ld [wd6f4], a
	call Func_24a30
	jr .asm_248d3

.asm_248c4
	ld hl, wd70b
	inc [hl]
	ld a, $2
	ld [wd717], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_248d3
	ld a, [wd718]
	cp $1
	jr nz, .asm_248fa
	ld a, [wd715]
	cp $a
	jr z, .asm_248eb
	ld a, $1
	ld [wd6f4], a
	call Func_24a30
	jr .asm_248fa

.asm_248eb
	ld hl, wd70b
	inc [hl]
	ld a, $2
	ld [wd718], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_248fa
	ld a, [wd719]
	cp $1
	jr nz, .asm_24921
	ld a, [wd716]
	cp $a
	jr z, .asm_24912
	ld a, $2
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24921

.asm_24912
	ld hl, wd70b
	inc [hl]
	ld a, $2
	ld [wd719], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24921
	ld a, [wd717]
	cp $2
	jr nz, .asm_2492c
	ld hl, wd714
	inc [hl]
.asm_2492c
	ld a, [wd718]
	cp $2
	jr nz, .asm_24937
	ld hl, wd715
	inc [hl]
.asm_24937
	ld a, [wd719]
	cp $2
	jr nz, .asm_24942
	ld hl, wd716
	inc [hl]
.asm_24942
	ld a, [wd717]
	cp $3
	jr nz, .asm_24968
	ld a, [wd71a]
	ld b, a
	ld a, [wd727]
	ld c, a
	ld hl, wd714
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_2495f
	call Func_24e7f
	jr .asm_24968

.asm_2495f
	cp $a
	jr nz, .asm_24968
	ld a, $4
	ld [wd717], a
.asm_24968
	ld a, [wd718]
	cp $3
	jr nz, .asm_2498e
	ld a, [wd71b]
	ld b, a
	ld a, [wd728]
	ld c, a
	ld hl, wd715
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24985
	call Func_24e7f
	jr .asm_2498e

.asm_24985
	cp $a
	jr nz, .asm_2498e
	ld a, $4
	ld [wd718], a
.asm_2498e
	ld a, [wd719]
	cp $3
	jr nz, .asm_249b4
	ld a, [wd71c]
	ld b, a
	ld a, [wd729]
	ld c, a
	ld hl, wd716
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_249ab
	call Func_24e7f
	jr .asm_249b4

.asm_249ab
	cp $a
	jr nz, .asm_249b4
	ld a, $4
	ld [wd719], a
.asm_249b4
	ld a, [wd717]
	cp $4
	jr nz, .asm_249d0
	ld a, $c8
	ld [wd71a], a
	ld [wd727], a
	xor a
	ld [wd717], a
	ld hl, wd70b
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24a06
.asm_249d0
	ld a, [wd718]
	cp $4
	jr nz, .asm_249ec
	ld a, $c8
	ld [wd71b], a
	ld [wd728], a
	xor a
	ld [wd718], a
	ld hl, wd70b
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24a06
.asm_249ec
	ld a, [wd719]
	cp $4
	ret nz
	ld a, $c8
	ld [wd71c], a
	ld [wd729], a
	xor a
	ld [wd719], a
	ld hl, wd70b
	dec [hl]
	ld a, [hl]
	cp $2
	ret nz
.asm_24a06
	ld a, [wd713]
	and a
	ret nz
	ld a, [wMeowthXMovement]
	cp $ff
	jr z, .asm_24a21
	ld hl, MeowthAnimationData2
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $1
	ld [wd6ec], a
	ret

.asm_24a21
	ld hl, MeowthAnimationData1
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $0
	ld [wd6ec], a
	ret

Func_24a30: ; 0x24a30
	ld a, [wd6f4]
	ld c, a
	ld b, $0
	ld hl, wd6f8
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_24a42
	call Func_24b41
	ret

.asm_24a42
	ld a, [wd6f4]
	ld c, a
	ld b, $0
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	bit 2, a
	jr z, .asm_24a5e
	bit 1, a
	jr nz, .asm_24a5e
	bit 0, a
	jr nz, .asm_24a5e
	ld hl, wd714
	add hl, bc
	inc [hl]
.asm_24a5e
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld hl, Data_24af1
	ld e, a
	ld d, $0
	add hl, de
	ld hl, wd72a
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_24a97
.asm_24a72
	ld hl, wd72a
	add hl, bc
	ld [hl], $0
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24af1
	add hl, de
	pop af
	add [hl]
	cp $8e
	jr nc, .asm_24a97
	ld hl, wd71a
	add hl, bc
	ld [hl], a
	jr .asm_24abf

.asm_24a97
	ld hl, wd72a
	add hl, bc
	ld [hl], $1
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24af1
	add hl, de
	ld a, [hl]
	ld d, a
	ld a, $ff
	sub d
	inc a
	ld d, a
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	add d
	cp $5
	jr c, .asm_24a72
	ld hl, wd71a
	add hl, bc
	ld [hl], a
.asm_24abf
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24af1
	add hl, de
	inc hl
	ld a, [hl]
	ld d, a
	ld hl, wd727
	add hl, bc
	ld a, [hl]
	add d
	ld hl, wd727
	add hl, bc
	ld [hl], a
	ld hl, wd6f5
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp $46
	jr nz, .asm_24af0
	ld a, c
	cp $9
	jr c, .asm_24aed
	call Func_2438f
	ret

.asm_24aed
	call Func_24319
.asm_24af0
	ret

Data_24af1:
; These are offsets for something in the Meowth stage
	db 2, -4
	db 2, -4
	db 2, -4
	db 2,  0
	db 2, -2
	db 2,  0
	db 2, -2
	db 2,  0
	db 2, -2
	db 2,  0
	db 2, -2
	db 2,  0
	db 2,  0
	db 2,  0
	db 2,  0
	db 2,  2
	db 2,  2
	db 2,  2
	db 2,  2
	db 2,  2
	db 2,  3
	db 2,  4
	db 2,  4
	db 2,  4
	db 2,  4
	db 2,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 1,  4
	db 0,  0
	db 0,  0
	db 0,  0
	db 0,  0

Func_24b41: ; 0x24b41
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	cp $14
	jp nc, Func_24bf6
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld hl, Data_24c0a
	ld e, a
	ld d, $0
	add hl, de
	ld hl, wd72a
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_24b8a
.asm_24b65
	ld hl, wd72a
	add hl, bc
	ld [hl], $0
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24c0a
	add hl, de
	pop af
	add [hl]
	cp $90
	jr nc, .asm_24b8a
	ld hl, wd71a
	add hl, bc
	ld [hl], a
	jr .asm_24bb2

.asm_24b8a
	ld hl, wd72a
	add hl, bc
	ld [hl], $1
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24c0a
	add hl, de
	ld a, [hl]
	ld d, a
	ld a, $ff
	sub d
	inc a
	ld d, a
	ld hl, wd71a
	add hl, bc
	ld a, [hl]
	add d
	cp $6
	jr c, .asm_24b65
	ld hl, wd71a
	add hl, bc
	ld [hl], a
.asm_24bb2
	ld hl, wd6f5
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	ld hl, Data_24c0a
	add hl, de
	inc hl
	ld a, [hl]
	ld d, a
	ld hl, wd727
	add hl, bc
	ld a, [hl]
	add d
	ld hl, wd727
	add hl, bc
	ld [hl], a
	ld hl, wd6f5
	add hl, bc
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp $12
	jr nz, .asm_24bf4
	ld a, c
	cp $9
	jr c, .asm_24be1
	call Func_2438f
	jr .asm_24be4

.asm_24be1
	call Func_24319
.asm_24be4
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_24bf4
	ld [hl], $1
.asm_24bf4
	scf
	ret

Func_24bf6: ; 0x24bf6
	ld a, [wd6f4]
	ld b, $0
	ld c, a
	ld hl, wd6f8
	add hl, bc
	ld [hl], $0
	ld hl, wd714
	add hl, bc
	ld [hl], $a
	ccf
	ret

Data_24c0a:
; These are offsets for something in the Meowth stage
	db 2, -2
	db 2, -1
	db 2, -1
	db 2,  0
	db 2,  0
	db 2,  0
	db 2,  1
	db 2,  1
	db 2,  2
	db 2,  4
	db 1,  4
	db 0,  0
	db 0,  0
	db 0,  0
	db 0,  0

Func_24c28: ; 0x24c28
	ld a, [wd6f3]
	and a
	ret z
	ld a, [wd724]
	cp $c8
	jr nz, .asm_24c76
	ld a, [wMeowthXPosition]
	add $8
	ld [wd724], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd731], a
	ld a, $1
	ld [wd721], a
	ld hl, wd70c
	inc [hl]
	xor a
	ld [wd6f3], a
	ld [wd71e], a
	ld [wd6ff], a
	ld [wd702], a
	ld [wd705], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wBallXPos + 1]
	cp b
	jr nc, .asm_24c70
	ld a, $0
	ld [wd734], a
	jr .asm_24c75

.asm_24c70
	ld a, $1
	ld [wd734], a
.asm_24c75
	ret

.asm_24c76
	ld a, [wd725]
	cp $c8
	jr nz, .asm_24cbf
	ld a, [wMeowthXPosition]
	add $8
	ld [wd725], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd732], a
	ld a, $1
	ld [wd722], a
	ld hl, wd70c
	inc [hl]
	xor a
	ld [wd6f3], a
	ld [wd71f], a
	ld [wd700], a
	ld [wd703], a
	ld [wd706], a
	ld a, [wd6f7]
	add $14
	ld b, a
	ld a, [wBallXPos + 1]
	cp b
	jr nc, .asm_24cb9
	ld a, $0
	ld [wd735], a
	jr .asm_24cbe

.asm_24cb9
	ld a, $1
	ld [wd735], a
.asm_24cbe
	ret

.asm_24cbf
	ld a, [wd726]
	cp $c8
	ret nz
	ld a, [wMeowthXPosition]
	add $8
	ld [wd726], a
	ld a, [wMeowthYPosition]
	add $fb
	ld [wd733], a
	ld a, $1
	ld [wd723], a
	ld hl, wd70c
	inc [hl]
	xor a
	ld [wd6f3], a
	ld [wd720], a
	ld [wd701], a
	ld [wd704], a
	ld [wd707], a
	ld a, [wMeowthXPosition]
	add $14
	ld b, a
	ld a, [wBallXPos + 1]
	cp b
	jr nc, .asm_24d01
	ld a, $0
	ld [wd736], a
	jr .asm_24d06

.asm_24d01
	ld a, $1
	ld [wd736], a
.asm_24d06
	ret

Func_24d07: ; 0x24d07
	ld a, [wd721]
	cp $1
	jr nz, .asm_24d2a
	ld a, [wd71e]
	cp $a
	jr z, .asm_24d1f
	ld a, $a
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24d2a

.asm_24d1f
	ld a, $2
	ld [wd721], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24d2a
	ld a, [wd722]
	cp $1
	jr nz, .asm_24d4d
	ld a, [wd71f]
	cp $a
	jr z, .asm_24d42
	ld a, $b
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24d4d

.asm_24d42
	ld a, $2
	ld [wd722], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24d4d
	ld a, [wd723]
	cp $1
	jr nz, .asm_24d70
	ld a, [wd720]
	cp $a
	jr z, .asm_24d65
	ld a, $c
	ld [wd6f4], a
	call Func_24a30
	jr .asm_24d70

.asm_24d65
	ld a, $2
	ld [wd723], a
	lb de, $00, $34
	call PlaySoundEffect
.asm_24d70
	ld a, [wd721]
	cp $2
	jr nz, .asm_24d7b
	ld hl, wd71e
	inc [hl]
.asm_24d7b
	ld a, [wd722]
	cp $2
	jr nz, .asm_24d86
	ld hl, wd71f
	inc [hl]
.asm_24d86
	ld a, [wd723]
	cp $2
	jr nz, .asm_24d91
	ld hl, wd720
	inc [hl]
.asm_24d91
	ld a, [wd721]
	cp $3
	jr nz, .asm_24db7
	ld a, [wd724]
	ld b, a
	ld a, [wd731]
	ld c, a
	ld hl, wd71e
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24dae
	call Func_24e7f
	jr .asm_24db7

.asm_24dae
	cp $a
	jr nz, .asm_24db7
	ld a, $4
	ld [wd721], a
.asm_24db7
	ld a, [wd722]
	cp $3
	jr nz, .asm_24ddd
	ld a, [wd725]
	ld b, a
	ld a, [wd732]
	ld c, a
	ld hl, wd71f
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24dd4
	call Func_24e7f
	jr .asm_24ddd

.asm_24dd4
	cp $a
	jr nz, .asm_24ddd
	ld a, $4
	ld [wd722], a
.asm_24ddd
	ld a, [wd723]
	cp $3
	jr nz, .asm_24e03
	ld a, [wd726]
	ld b, a
	ld a, [wd733]
	ld c, a
	ld hl, wd720
	inc [hl]
	ld a, [hl]
	cp $2
	jr nz, .asm_24dfa
	call Func_24e7f
	jr .asm_24e03

.asm_24dfa
	cp $a
	jr nz, .asm_24e03
	ld a, $4
	ld [wd723], a
.asm_24e03
	ld a, [wd721]
	cp $4
	jr nz, .asm_24e1f
	ld a, $c8
	ld [wd724], a
	ld [wd731], a
	xor a
	ld [wd721], a
	ld hl, wd70c
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24e55
.asm_24e1f
	ld a, [wd722]
	cp $4
	jr nz, .asm_24e3b
	ld a, $c8
	ld [wd725], a
	ld [wd732], a
	xor a
	ld [wd722], a
	ld hl, wd70c
	dec [hl]
	ld a, [hl]
	cp $2
	jr z, .asm_24e55
.asm_24e3b
	ld a, [wd723]
	cp $4
	ret nz
	ld a, $c8
	ld [wd726], a
	ld [wd733], a
	xor a
	ld [wd723], a
	ld hl, wd70c
	dec [hl]
	ld a, [hl]
	cp $2
	ret nz
.asm_24e55
	ld a, [wd713]
	and a
	ret nz
	ld a, [wMeowthXMovement]
	cp $ff
	jr z, .asm_24e70
	ld hl, MeowthAnimationData2
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $1
	ld [wd6ec], a
	ret

.asm_24e70
	ld hl, MeowthAnimationData1
	ld de, wMeowthAnimation
	call InitAnimation
	ld a, $0
	ld [wd6ec], a
	ret

Func_24e7f: ; 0x24e7f
	ld a, b
	ld [wd79c], a
	ld a, c
	ld [wd79e], a
	ld hl, wMeowthStageBonusCounter
	inc [hl]
	ld a, [hl]
	cp $7  ; maximum bonus
	jr nz, .asm_24e92
	xor a
	ld [hl], a
.asm_24e92
	ld a, $ff
	ld [wRumblePattern], a
	ld a, $3
	ld [wRumbleDuration], a
	lb de, $00, $32
	call PlaySoundEffect
	ld a, [wMeowthStageBonusCounter]
	dec a
.asm_24ea6
	push af
	ld bc, OneHundredThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wMeowthStageScore
	inc [hl]
	pop af
	and a
	jr z, .asm_24ebf
	dec a
	jr .asm_24ea6

.asm_24ebf
	ld a, [wMeowthStageBonusCounter]
	dec a
	dec a
	cp $fe
	jr z, .asm_24ed7
	cp $ff
	jr z, .asm_24ed7
	ld [wd79a], a
	ld de, wd79a
	call Func_24ee7
	jr .asm_24ede

.asm_24ed7
	xor a
	ld [wd79a], a
	ld [wd795], a
.asm_24ede
	ld a, $1
	ld [wd64e], a
	call Func_24fa3
	ret

Func_24ee7: ; 0x24ee7
	ld a, $ff
	ld [wd795], a
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, MeowthStageAnimationDataTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec de
	dec de
	dec de
	call InitAnimation
	ret

Func_24f00: ; 0x24f00
	ld a, [de]
	sla a
	ld c, a
	ld b, $0
	ld hl, MeowthStageAnimationDataTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	dec de
	dec de
	dec de
	call UpdateAnimation
	pop de
	ld a, $1
	ld [wd710], a
	ret nc
	dec de
	ld a, [de]
	cp $a
	ret nz
	xor a
	ld [de], a
	ld [wd79c], a
	ld [wd79e], a
	ld [wd795], a
	xor a
	ld [wd710], a
	ret

MeowthStageAnimationDataTable: ; 0x24f30
	dw MeowthStageAnimationData1
	dw MeowthStageAnimationData2
	dw MeowthStageAnimationData3
	dw MeowthStageAnimationData4
	dw MeowthStageAnimationData5

MeowthStageAnimationData1: ; 0x24f3a
; Each entry is [OAM id][duration]
	db $02, $00
	db $02, $01
	db $02, $02
	db $10, $00
	db $04, $0F
	db $04, $00
	db $04, $0F
	db $04, $00
	db $04, $0F
	db $04, $00
	db $00 ; terminator

MeowthStageAnimationData2: ; 0x24f4f
; Each entry is [OAM id][duration]
	db $02, $03
	db $02, $04
	db $02, $05
	db $10, $03
	db $04, $0F
	db $04, $03
	db $04, $0F
	db $04, $03
	db $04, $0F
	db $04, $03
	db $00 ; terminator

MeowthStageAnimationData3: ; 0x24f64
; Each entry is [OAM id][duration]
	db $02, $06
	db $02, $07
	db $02, $08
	db $10, $06
	db $04, $0F
	db $04, $06
	db $04, $0F
	db $04, $06
	db $04, $0F
	db $04, $06
	db $00 ; terminator

MeowthStageAnimationData4: ; 0x24f79
; Each entry is [OAM id][duration]
	db $02, $09
	db $02, $0A
	db $02, $0B
	db $10, $09
	db $04, $0F
	db $04, $09
	db $04, $0F
	db $04, $09
	db $04, $0F
	db $04, $09
	db $00 ; terminator

MeowthStageAnimationData5: ; 0x24f8e
; Each entry is [OAM id][duration]
	db $02, $0C
	db $02, $0D
	db $02, $0E
	db $10, $0C
	db $04, $0F
	db $04, $0C
	db $04, $0F
	db $04, $0C
	db $04, $0F
	db $04, $0C
	db $00 ; terminator

Func_24fa3: ; 0x24fa3
	ld a, [wMeowthStageScore]
	ld c, a
	ld b, $0
.asm_24fa9
	ld a, c
	and a
	jr z, .asm_24fb5
	ld a, b
	add $8
	ld b, a
	dec c
	ld a, c
	jr .asm_24fa9

.asm_24fb5
	ld a, b
	and a
	jr z, .asm_24fbb
	sub $8
.asm_24fbb
	ld [wd652], a
	ld a, [wMeowthStageBonusCounter]
	and a
	jr z, .asm_24fca
	ld b, a
	ld a, [wMeowthStageScore]
	inc a
	sub b
.asm_24fca
	ld [wd651], a
	ld a, $0
	ld [wd64e], a
	ld a, [wMeowthStageScore]
	and a
	ret z
	cp $15
	jr c, .asm_24fe2
	ld a, $14
	ld [wMeowthStageScore], a
	jr .asm_24fed

.asm_24fe2
	push af
	xor a
	ld [wd650], a
	ld a, $1
	ld [wd64e], a
	pop af
.asm_24fed
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_25007
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_24ffd
	ld hl, TileDataPointers_25421
.asm_24ffd
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_25007)
	call QueueGraphicsToLoad
	ret

TileDataPointers_25007:
	dw TileData_25031
	dw TileData_25034
	dw TileData_25037
	dw TileData_2503a
	dw TileData_2503d
	dw TileData_25040
	dw TileData_25043
	dw TileData_25046
	dw TileData_25049
	dw TileData_2504c
	dw TileData_2504f
	dw TileData_25052
	dw TileData_25055
	dw TileData_25058
	dw TileData_2505b
	dw TileData_2505e
	dw TileData_25061
	dw TileData_25064
	dw TileData_25067
	dw TileData_2506a
	dw TileData_2506d

TileData_25031: ; 0x25031
	db $01
	dw TileData_25070

TileData_25034: ; 0x25034
	db $01
	dw TileData_2509d

TileData_25037: ; 0x25037
	db $01
	dw TileData_250ca

TileData_2503a: ; 0x2503a
	db $01
	dw TileData_250f7

TileData_2503d: ; 0x2503d
	db $01
	dw TileData_25124

TileData_25040: ; 0x25040
	db $01
	dw TileData_25151

TileData_25043: ; 0x25043
	db $01
	dw TileData_2517e

TileData_25046: ; 0x25046
	db $01
	dw TileData_251ab

TileData_25049: ; 0x25049
	db $01
	dw TileData_251d8

TileData_2504c: ; 0x2504c
	db $01
	dw TileData_25205

TileData_2504f: ; 0x2504f
	db $01
	dw TileData_25232

TileData_25052: ; 0x25052
	db $01
	dw TileData_2525f

TileData_25055: ; 0x25055
	db $01
	dw TileData_2528c

TileData_25058: ; 0x25058
	db $01
	dw TileData_252b9

TileData_2505b: ; 0x2505b
	db $01
	dw TileData_252e6

TileData_2505e: ; 0x2505e
	db $01
	dw TileData_25313

TileData_25061: ; 0x25061
	db $01
	dw TileData_25340

TileData_25064: ; 0x25064
	db $01
	dw TileData_2536d

TileData_25067: ; 0x25067
	db $01
	dw TileData_2539a

TileData_2506a: ; 0x2506a
	db $01
	dw TileData_253c7

TileData_2506d: ; 0x2506d
	db $01
	dw TileData_253f4

TileData_25070: ; 0x25070
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $E4, $0C, $0D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_2509d: ; 0x2509d
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $0C, $0D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_250ca: ; 0x250ca
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $0D

	db $03 ; number of tiles
	dw vBGMap + $3
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_250f7: ; 0x250f7
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_25124: ; 0x25124
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_25151: ; 0x25151
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $0E

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_2517e: ; 0x2517e
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_251ab: ; 0x251ab
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_251d8: ; 0x251d8
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $0D

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_25205: ; 0x25205
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $0E, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_25232: ; 0x25232
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $0D, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_2525f: ; 0x2525f
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $0E

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_2528c: ; 0x2528c
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $0D, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_252b9: ; 0x252b9
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $0E, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_252e6: ; 0x252e6
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $0D

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_25313: ; 0x25313
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $F
	db $0E, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_25340: ; 0x25340
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $F
	db $16, $0D, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_2536d: ; 0x2536d
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $F
	db $16, $16, $0E

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_2539a: ; 0x2539a
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $F
	db $16, $16, $16

	db $02
	dw vBGMap + $12
	db $0F, $E4

	db $00 ; terminator

TileData_253c7: ; 0x253c7
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $F
	db $16, $16, $16

	db $02
	dw vBGMap + $12
	db $17, $E4

	db $00 ; terminator

TileData_253f4: ; 0x253f4
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $14, $15, $16

	db $03 ; number of tiles
	dw vBGMap + $3
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $6
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $9
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $C
	db $16, $16, $16

	db $03 ; number of tiles
	dw vBGMap + $F
	db $16, $16, $16

	db $02
	dw vBGMap + $12
	db $17, $18

	db $00 ; terminator

TileDataPointers_25421: ; 0x25421
	dw TileData_2544b
	dw TileData_2544e
	dw TileData_25451
	dw TileData_25454
	dw TileData_25457
	dw TileData_2545a
	dw TileData_2545d
	dw TileData_25460
	dw TileData_25463
	dw TileData_25466
	dw TileData_25469
	dw TileData_2546c
	dw TileData_2546f
	dw TileData_25472
	dw TileData_25475
	dw TileData_25478
	dw TileData_2547b
	dw TileData_2547e
	dw TileData_25481
	dw TileData_25484
	dw TileData_25487

TileData_2544b: ; 0x2544b
	db $01
	dw TileData_2548a

TileData_2544e: ; 0x2544e
	db $01
	dw TileData_254b7

TileData_25451: ; 0x25451
	db $01
	dw TileData_254e4

TileData_25454: ; 0x25454
	db $01
	dw TileData_25511

TileData_25457: ; 0x25457
	db $01
	dw TileData_2553e

TileData_2545a: ; 0x2545a
	db $01
	dw TileData_2556b

TileData_2545d: ; 0x2545d
	db $01
	dw TileData_25598

TileData_25460: ; 0x25460
	db $01
	dw TileData_255c5

TileData_25463: ; 0x25463
	db $01
	dw TileData_255f2

TileData_25466: ; 0x25466
	db $01
	dw TileData_2561f

TileData_25469: ; 0x25469
	db $01
	dw TileData_2564c

TileData_2546c: ; 0x2546c
	db $01
	dw TileData_25679

TileData_2546f: ; 0x2546f
	db $01
	dw TileData_256a6

TileData_25472: ; 0x25472
	db $01
	dw TileData_256d3

TileData_25475: ; 0x25475
	db $01
	dw TileData_25700

TileData_25478: ; 0x25478
	db $01
	dw TileData_2572d

TileData_2547b: ; 0x2547b
	db $01
	dw TileData_2575a

TileData_2547e: ; 0x2547e
	db $01
	dw TileData_25787

TileData_25481: ; 0x25481
	db $01
	dw TileData_257b4

TileData_25484: ; 0x25484
	db $01
	dw TileData_257e1

TileData_25487: ; 0x25487
	db $01
	dw TileData_2580e

TileData_2548a: ; 0x2548a
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $E3, $FD, $FE

	db $03 ; number of tiles
	dw vBGMap + $3
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_254b7: ; 0x254b7
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $FD, $FE

	db $03 ; number of tiles
	dw vBGMap + $3
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_254e4: ; 0x254e4
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $FE

	db $03 ; number of tiles
	dw vBGMap + $3
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_25511: ; 0x25511
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_2553e: ; 0x2553e
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_2556b: ; 0x2556b
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $FE

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_25598: ; 0x25598
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_255c5: ; 0x255c5
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_255f2: ; 0x255f2
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $FE

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_2561f: ; 0x2561f
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_2564c: ; 0x2564c
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_25679: ; 0x25679
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $FE

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_256a6: ; 0x256a6
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $FE, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_256d3: ; 0x256d3
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $FE, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_25700: ; 0x25700
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $FE

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_2572d: ; 0x2572d
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $F
	db $FE, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_2575a: ; 0x2575a
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $F
	db $00, $FE, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_25787: ; 0x25787
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $F
	db $00, $00, $FE

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_257b4: ; 0x257b4
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $F
	db $00, $00, $00

	db $02 ; number of tiles
	dw vBGMap + $12
	db $FD, $E3

	db $00 ; terminator

TileData_257e1: ; 0x257e1
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $F
	db $00, $00, $00

	db $02 ; number of tiles
	dw vBGMap + $12
	db $02, $E3

	db $00 ; terminator

TileData_2580e: ; 0x2580e
	dw LoadTileLists
	db $14 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap
	db $FF, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $3
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $6
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $9
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $C
	db $00, $00, $00

	db $03 ; number of tiles
	dw vBGMap + $F
	db $00, $00, $00

	db $02 ; number of tiles
	dw vBGMap + $12
	db $02, $03

	db $00 ; terminator
