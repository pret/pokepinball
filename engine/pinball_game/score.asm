Func_8524: ; 0x8524
	ld hl, wScore + $5
	lb bc, $0c, $01
.loop
	ld a, [hl]
	swap a
	and $f
	call .GetDigit
	inc de
	dec b
	ld a, [hld]
	and $f
	call .GetDigit
	inc de
	dec b
	jr nz, .loop
	ld a, $86
	ld [de], a
	inc de
	ret

.GetDigit: ; 0x8543
	jr nz, .okay
	ld a, b
	dec a
	jr z, .okay
	ld a, c
	and a
	ret nz
.okay
	add $86 ; 0
	ld [de], a
	ld c, $0
	ld a, b
	cp $c
	jr z, .load_tile_82
	cp $9
	jr z, .load_tile_82
	cp $6
	jr z, .load_tile_82
	cp $3
	ret nz
.load_tile_82
	set 7, e
	ld a, $82 ; ,
	ld [de], a
	res 7, e
	ret

Func_8569:
	xor a
	ld hl, wAddScoreQueue
	ld b, $31
.asm_856f
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_856f
	ld [hli], a
	ret

AddBigBCD6FromQueueWithBallMultiplier: ; 0x8576
	ld h, b
	ld l, c
	ld a, [wAddScoreQueueOffset]
	ld e, a
	ld d, wAddScoreQueue / $100
	ld a, [wBallType]
	and a
	jr nz, .asm_8585
	inc a
.asm_8585
	ld b, a
	jr asm_8592

AddBigBCD6FromQueue: ; 0x8588
; bc - Points to BCD buffer
	ld h, b
	ld l, c
	ld a, [wAddScoreQueueOffset]
	ld e, a
	ld d, wAddScoreQueue / $100
	ld b, $1
asm_8592:
	push hl
x = 0
rept 6
	ld a, [de]
if x == 0
	add [hl]
else
	adc [hl]
endc
	daa
	ld [de], a
	inc de
	inc hl
x = x + 1
endr
	ld a, e
	cp wAddScoreQueueEnd % $100
	jr nz, .okay
	ld e, wAddScoreQueue % $100
.okay
	pop hl
	dec b
	jr nz, asm_8592
	ld a, e
	ld [wAddScoreQueueOffset], a
	ret

Func_85c7: ; 0x85c7
	ld a, [hNumFramesDropped]
	and $3
	ret nz
	ld a, [wd478]
	ld l, a
	ld h, wAddScoreQueue / $100
	ld de, wScore
	ld a, [wAddScoreQueueOffset]
	cp l
	jr nz, .asm_85de
	ld [wd479], a
.asm_85de
	push hl
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	pop hl
	jr nz, .value_is_nonzero
	ld a, [wd479]
	ld [wd478], a
	ret

.value_is_nonzero
	ld a, [de]
	add [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	inc de
	inc hl
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	ld [hl], $0
	call c, SetMaxScore
	inc de
	inc hl
	ld a, l
	cp $60
	jr nz, .asm_862d
	ld l, $0
.asm_862d
	ld a, l
	ld [wd478], a
	ld a, $1
	ld [wd49f], a
	ret

SetMaxScore: ; 0x8637
	push hl
	ld hl, wScore
	ld a, $99
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	ret

Func_8645: ; 0x8645
	xor a
	ld [wd49f], a
	ld de, wBottomMessageBuffer + $47
	call Func_8524
	ret

Func_8650: ; 0x8650
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .bottomStage
	ld a, $86
	ld [hWY], a
	ret

.bottomStage
	ld a, [wBallYPos + 1]
	cp $84
	jr nc, .asm_8670
	ld a, [hWY]
	sub $3
	cp $86
	jr nc, .asm_866d
	ld a, $86
.asm_866d
	ld [hWY], a
	ret

.asm_8670
	ld a, [hWY]
	add $3
	cp $90
	jr c, .asm_867a
	ld a, $90
.asm_867a
	ld [hWY], a
	ret
