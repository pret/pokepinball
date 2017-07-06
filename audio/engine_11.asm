Func_44000:
	push hl
	push de
	push bc
	push af
	call Func_44b1b
	ld hl, wChannel0
	ld de, wdeb0 - wChannel0
.clearLoop
	xor a
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, .clearLoop
	ld hl, rNR50
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $80
	ld [hli], a
	ld hl, rNR10
	ld e, $4
.loop
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $8
	ld [hli], a
	xor a
	ld [hli], a
	ld a, $80
	ld [hli], a
	dec e
	jr nz, .loop
	ld a, $8
	ld [wde9a], a
	ld a, $77
	ld [wde98], a
	call Func_44b15
	pop af
	pop bc
	pop de
	pop hl
	ret

Func_44042:
	ld a, [de]
	inc de
	and $7
	ld [wdeae], a
	ld c, a
	ld b, $0
	ld hl, ChannelPointers_Bank11
	add hl, bc
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, $0002
	add hl, bc
	res 0, [hl]
	push de
	xor a
	ld hl, $0000
	add hl, bc
	ld e, $32
.loop
	ld [hli], a
	dec e
	jr nz, .loop
	ld hl, $0017
	add hl, bc
	xor a
	ld [hli], a
	inc a
	ld [hl], a
	ld hl, $0028
	add hl, bc
	ld [hl], a
	pop de
	ld hl, $0005
	add hl, bc
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	ld hl, $0000
	add hl, bc
	ld a, [wde9b]
	ld [hli], a
	ld a, [wde9c]
	ld [hl], a
	ret

Unused_4408b: ; 4008b
	db $F5, $1B, $1A, $77, $11

PlaySong_Bank11:
	push de
	call Func_44000
	pop de
	call Func_44b1b
	ld hl, wde9b
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, SongHeaderPointers_Bank11
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	rlca
	rlca
	and $3
	inc a
.asm_440ac
	push af
	call Func_44042
	call Func_44adf
	pop af
	dec a
	jr nz, .asm_440ac
	call Func_44b15
	ret

Unused_440bb: ; 400bb
	db $41, $0E, $C9, $54, $50

PlaySoundEffect_Bank11:
	call Func_44b1b
	ld hl, wde9b
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, SoundEffects_Bank11
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	rlca
	rlca
	and $3
	inc a
.asm_440d7
	push af
	call Func_44042
	ld hl, $0002
	add hl, bc
	set 3, [hl]
	call Func_44adf
	pop af
	dec a
	jr nz, .asm_440d7
	call Func_44b15
	ret

Unused_440ec:
; ???
	db $58, $46, $91, $46

PlayCry_Bank11:
; Plays a Pokemon cry.
; Input: e = mon id
	call Func_44b1b
	ld a, e
	and a
	ret z
	dec e
	ld d, $0
	ld hl, CryData_Bank11
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]  ; de = base cry id
	inc hl
	ld a, [hli]
	ld [wdea8], a
	ld a, [hli]
	ld [wdea9], a  ; dea8 = cry pitch
	ld a, [hli]
	ld [wdeaa], a
	ld a, [hl]
	ld [wdeab], a  ; deaa = cry length
	ld hl, wde9b
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, CryBasePointers_Bank11
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	rlca
	rlca
	and $3
	inc a
.asm_4412a
	push af
	call Func_44042
	ld hl, $0002
	add hl, bc
	set 5, [hl]
	ld hl, $0003
	add hl, bc
	set 4, [hl]
	ld hl, $0026
	add hl, bc
	ld a, [wdea8]
	ld [hli], a
	ld a, [wdea9]
	ld [hl], a
	ld a, [wde97]
	and $3
	cp $3
	jr nc, .asm_4415b
	ld hl, $0017
	add hl, bc
	ld a, [wdeaa]
	ld [hli], a
	ld a, [wdeab]
	ld [hl], a
.asm_4415b
	call Func_44adf
	pop af
	dec a
	jr nz, .asm_4412a
	ld a, [wdeac]
	and a
	jr nz, .asm_44173
	ld a, [wde98]
	ld [wdeac], a
	ld a, $77
	ld [wde98], a
.asm_44173
	ld a, $1
	ld [wdead], a
	call Func_44b15
	ret

Unused_4417c; ; 0x4017c
; ???
	db $87, $56, $BF, $56

Func_44180:
	ld a, [wdd00]
	and a
	ret z
	xor a
	ld [wde97], a
	ld [wde99], a
	ld bc, wChannel0
.asm_4418f
	ld hl, $0002
	add hl, bc
	bit 0, [hl]
	jp z, .asm_4422d
	ld hl, $0014
	add hl, bc
	ld a, [hl]
	cp $2
	jr c, .asm_441a4
	dec [hl]
	jr .asm_441c1

.asm_441a4
	ld hl, $001c
	add hl, bc
	ld a, [hl]
	ld hl, $001b
	add hl, bc
	ld [hl], a
	ld hl, $0025
	add hl, bc
	ld a, [hl]
	ld hl, $0024
	add hl, bc
	ld [hl], a
	ld hl, $0003
	add hl, bc
	res 1, [hl]
	call Func_44670
.asm_441c1
	ld hl, $000d
	add hl, bc
	ld a, [hli]
	ld [wde91], a
	ld a, [hli]
	ld [wde92], a
	ld a, [hli]
	ld [wde93], a
	ld a, [hl]
	ld [wde94], a
	call Func_444f0
	call Func_44632
	ld a, [wdead]
	and a
	jr z, .asm_4420a
	ld a, [wde97]
	cp $4
	jr nc, .asm_44219
	ld hl, wChannel4 + 2
	bit 0, [hl]
	jr nz, .asm_44204
	ld hl, wChannel5 + 2
	bit 0, [hl]
	jr nz, .asm_44204
	ld hl, wChannel6 + 2
	bit 0, [hl]
	jr nz, .asm_44204
	ld hl, wChannel7 + 2
	bit 0, [hl]
	jr z, .asm_4420a
.asm_44204
	ld hl, $000b
	add hl, bc
	set 5, [hl]
.asm_4420a
	ld a, [wde97]
	cp $4
	jr nc, .asm_44219
	ld hl, $00ca
	add hl, bc
	bit 0, [hl]
	jr nz, .asm_44227
.asm_44219
	call Func_4424d
	ld hl, $0019
	add hl, bc
	ld a, [wde99]
	or [hl]
	ld [wde99], a
.asm_44227
	ld hl, $000b
	add hl, bc
	xor a
	ld [hl], a
.asm_4422d
	ld hl, $0032
	add hl, bc
	ld c, l
	ld b, h
	ld a, [wde97]
	inc a
	ld [wde97], a
	cp $8
	jp nz, .asm_4418f
	call Func_4440d
	ld a, [wde98]
	ld [rNR50], a
	ld a, [wde99]
	ld [rNR51], a
	ret

Func_4424d:
	ld hl, PointerTable_4425e
	ld a, [wde97]
	and $7
	add a
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PointerTable_4425e:
	dw Func_4426e
	dw Func_442e0
	dw Func_44349
	dw Func_443cf
	dw Func_4426e
	dw Func_442e0
	dw Func_44349
	dw Func_443cf

Func_4426e:
	ld hl, $000b
	add hl, bc
	bit 3, [hl]
	jr z, .asm_4427b
	ld a, [wde9a]
	ld [rNR10], a
.asm_4427b
	bit 5, [hl]
	jr nz, .asm_442ba
	bit 4, [hl]
	jr nz, .asm_442c6
	bit 6, [hl]
	jr nz, .asm_442b4
	bit 1, [hl]
	jr z, .asm_44295
	ld a, [wde93]
	ld [rNR13], a
	ld a, [wde94]
	ld [rNR14], a
.asm_44295
	bit 2, [hl]
	jr z, .asm_442a5
	ld a, [wde92]
	ld [rNR12], a
	ld a, [wde94]
	or $80
	ld [rNR14], a
.asm_442a5
	bit 0, [hl]
	ret z
	ld a, [wde91]
	ld d, a
	ld a, [rNR11]
	and $3f
	or d
	ld [rNR11], a
	ret

.asm_442b4
	ld a, [wde93]
	ld [rNR13], a
	ret

.asm_442ba
	ld a, $8
	ld [rNR12], a
	ld a, [wde94]
	or $80
	ld [rNR14], a
	ret

.asm_442c6
	ld hl, wde91
	ld a, $3f
	or [hl]
	ld [rNR11], a
	ld a, [wde92]
	ld [rNR12], a
	ld a, [wde93]
	ld [rNR13], a
	ld a, [wde94]
	or $80
	ld [rNR14], a
	ret

Func_442e0:
	ld hl, $000b
	add hl, bc
	bit 5, [hl]
	jr nz, .asm_44323
	bit 4, [hl]
	jr nz, .asm_4432f
	bit 6, [hl]
	jr nz, .asm_4431d
	bit 1, [hl]
	jr z, .asm_442fe
	ld a, [wde93]
	ld [rNR23], a
	ld a, [wde94]
	ld [rNR24], a
.asm_442fe
	bit 2, [hl]
	jr z, .asm_4430e
	ld a, [wde92]
	ld [rNR22], a
	ld a, [wde94]
	or $80
	ld [rNR24], a
.asm_4430e
	bit 0, [hl]
	ret z
	ld a, [wde91]
	ld d, a
	ld a, [rNR21]
	and $3f
	or d
	ld [rNR21], a
	ret

.asm_4431d
	ld a, [wde93]
	ld [rNR23], a
	ret

.asm_44323
	ld a, $8
	ld [rNR22], a
	ld a, [wde94]
	or $80
	ld [rNR24], a
	ret

.asm_4432f
	ld hl, wde91
	ld a, $3f
	or [hl]
	ld [rNR21], a
	ld a, [wde92]
	ld [rNR22], a
	ld a, [wde93]
	ld [rNR23], a
	ld a, [wde94]
	or $80
	ld [rNR24], a
	ret

Func_44349:
	ld hl, $000b
	add hl, bc
	bit 5, [hl]
	jr nz, .asm_44387
	bit 4, [hl]
	jr nz, .asm_4438b
	bit 6, [hl]
	jr nz, .asm_44381
	bit 1, [hl]
	jr z, .asm_44367
	ld a, [wde93]
	ld [rNR33], a
	ld a, [wde94]
	ld [rNR34], a
.asm_44367
	bit 2, [hl]
	ret z
	xor a
	ld [rNR30], a
	call LoadWavePattern_Bank11
	ld a, $80
	ld [rNR30], a
	ld a, [wde93]
	ld [rNR33], a
	ld a, [wde94]
	or $80
	ld [rNR34], a
	ret

.asm_44381
	ld a, [wde93]
	ld [rNR33], a
	ret

.asm_44387
	xor a
	ld [rNR30], a
	ret

.asm_4438b
	ld a, $3f
	ld [rNR31], a
	xor a
	ld [rNR30], a
	call LoadWavePattern_Bank11
	ld a, $80
	ld [rNR30], a
	ld a, [wde93]
	ld [rNR33], a
	ld a, [wde94]
	or $80
	ld [rNR34], a
	ret

LoadWavePattern_Bank11:
	push hl
	ld a, [wde92]
	and $f
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, WavePatterns_Bank11
	add hl, de
	ld de, rWave_0
	push bc
	ld b, $10
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop bc
	pop hl
	ld a, [wde92]
	and $f0
	sla a
	ld [rNR32], a  ; set volume of wave channel
	ret

Func_443cf:
	ld hl, $000b
	add hl, bc
	bit 5, [hl]
	jr nz, .asm_443f1
	bit 4, [hl]
	jr nz, .asm_443fa
	bit 1, [hl]
	jr z, .asm_443e4
	ld a, [wde93]
	ld [rNR43], a
.asm_443e4
	bit 2, [hl]
	ret z
	ld a, [wde92]
	ld [rNR42], a
	ld a, $80
	ld [rNR44], a
	ret

.asm_443f1
	ld a, $8
	ld [rNR42], a
	ld a, $80
	ld [rNR44], a
	ret

.asm_443fa
	ld a, $3f
	ld [rNR41], a
	ld a, [wde92]
	ld [rNR42], a
	ld a, [wde93]
	ld [rNR43], a
	ld a, $80
	ld [rNR44], a
	ret

Func_4440d:
	ld a, [wdea2]
	and a
	ret z
	ld a, [wdea3]
	and a
	jr z, .asm_4441d
	dec a
	ld [wdea3], a
	ret

.asm_4441d
	ld a, [wdea2]
	ld d, a
	and $7f
	ld [wdea3], a
	ld a, [wde98]
	and $7
	bit 7, d
	jr nz, .asm_44448
	and a
	jr z, .asm_44435
	dec a
	jr .asm_44454

.asm_44435
	ld a, [wdea4]
	ld e, a
	ld a, [wdea5]
	ld d, a
	push bc
	call PlaySong_Bank11
	pop bc
	ld hl, wdea2
	set 7, [hl]
	ret

.asm_44448
	cp $7
	jr nc, .asm_4444f
	inc a
	jr .asm_44454

.asm_4444f
	xor a
	ld [wdea2], a
	ret

.asm_44454
	ld d, a
	swap a
	or d
	ld [wde98], a
	ret

Func_4445c:
	ld hl, $0003
	add hl, bc
	bit 1, [hl]
	ret z
	ld hl, $0014
	add hl, bc
	ld a, [hl]
	ld hl, wde95
	sub [hl]
	jr nc, .asm_44470
	ld a, $1
.asm_44470
	ld [hl], a
	ld hl, $000f
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $001f
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	ld hl, $0020
	add hl, bc
	sub [hl]
	jr nc, .asm_444ab
	ld hl, $0004
	add hl, bc
	set 1, [hl]
	ld hl, $000f
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	jr .asm_444c9

.asm_444ab
	ld hl, $0004
	add hl, bc
	res 1, [hl]
	ld hl, $000f
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $001f
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	ld hl, $0020
	add hl, bc
	sub [hl]
	ld d, a
.asm_444c9
	push bc
	ld hl, wde95
	ld b, $0
.asm_444cf
	inc b
	ld a, e
	sub [hl]
	ld e, a
	jr nc, .asm_444cf
	ld a, d
	and a
	jr z, .asm_444dc
	dec d
	jr .asm_444cf

.asm_444dc
	ld a, e
	add [hl]
	ld d, b
	pop bc
	ld hl, $0021
	add hl, bc
	ld [hl], d
	ld hl, $0022
	add hl, bc
	ld [hl], a
	ld hl, $0023
	add hl, bc
	xor a
	ld [hl], a

	; fall through

Func_444f0:
	ld hl, $0003
	add hl, bc
	bit 2, [hl]
	jr z, .asm_4450b
	ld hl, $001a
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	ld [hl], a
	and $c0
	ld [wde91], a
	ld hl, $000b
	add hl, bc
	set 0, [hl]
.asm_4450b
	ld hl, $0003
	add hl, bc
	bit 4, [hl]
	jr z, .asm_44529
	ld hl, $0026
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wde93
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	ld hl, wde93
	ld [hl], e
	inc hl
	ld [hl], d
.asm_44529
	ld hl, $0003
	add hl, bc
	bit 1, [hl]
	jp z, .asm_445c1
	ld hl, $000f
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0004
	add hl, bc
	bit 1, [hl]
	jr z, .asm_44574
	ld hl, $0021
	add hl, bc
	ld l, [hl]
	ld h, $0
	add hl, de
	ld d, h
	ld e, l
	ld hl, $0022
	add hl, bc
	ld a, [hl]
	ld hl, $0023
	add hl, bc
	add [hl]
	ld [hl], a
	ld a, $0
	adc e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld hl, $0020
	add hl, bc
	ld a, [hl]
	cp d
	jp c, .asm_445a1
	jr nz, .asm_445b4
	ld hl, $001f
	add hl, bc
	ld a, [hl]
	cp e
	jp c, .asm_445a1
	jr .asm_445b4

.asm_44574
	ld a, e
	ld hl, $0021
	add hl, bc
	ld e, [hl]
	sub e
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	ld hl, $0022
	add hl, bc
	ld a, [hl]
	add a
	ld [hl], a
	ld a, e
	sbc $0
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	ld hl, $0020
	add hl, bc
	ld a, d
	cp [hl]
	jr c, .asm_445a1
	jr nz, .asm_445b4
	ld hl, $001f
	add hl, bc
	ld a, e
	cp [hl]
	jr nc, .asm_445b4
.asm_445a1
	ld hl, $0003
	add hl, bc
	res 1, [hl]
	ld hl, $0004
	add hl, bc
	res 1, [hl]
	ld hl, $0020
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
.asm_445b4
	ld hl, $000f
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, $000b
	add hl, bc
	set 1, [hl]
.asm_445c1
	ld hl, $0003
	add hl, bc
	bit 0, [hl]
	jr z, .asm_4461a
	ld hl, $001b
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .asm_445e3
	ld hl, $001d
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_4461a
	ld d, a
	ld hl, $001e
	add hl, bc
	ld a, [hl]
	and $f
	jr z, .asm_445e6
.asm_445e3
	dec [hl]
	jr .asm_4461a

.asm_445e6
	ld a, [hl]
	swap [hl]
	or [hl]
	ld [hl], a
	ld a, [wde93]
	ld e, a
	ld hl, $0004
	add hl, bc
	bit 0, [hl]
	jr z, .asm_44605
	res 0, [hl]
	ld a, d
	and $f
	ld d, a
	ld a, e
	sub d
	jr nc, .asm_44611
	ld a, $0
	jr .asm_44611

.asm_44605
	set 0, [hl]
	ld a, d
	and $f0
	swap a
	add e
	jr nc, .asm_44611
	ld a, $ff
.asm_44611
	ld [wde93], a
	ld hl, $000b
	add hl, bc
	set 6, [hl]
.asm_4461a
	ld hl, $0003
	add hl, bc
	bit 3, [hl]
	ret z
	ld hl, $0024
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_4462b
	dec [hl]
	ret

.asm_4462b
	ld hl, $000b
	add hl, bc
	set 5, [hl]
	ret

Func_44632:
	ld hl, $0002
	add hl, bc
	bit 4, [hl]
	ret z
	ld a, [wde9f]
	and a
	jr z, .asm_44644
	dec a
	ld [wde9f], a
	ret

.asm_44644
	ld hl, wde9d
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
	cp $ff
	ret z
	and $f
	inc a
	ld [wde9f], a
	ld a, [de]
	inc de
	ld [wde92], a
	ld a, [de]
	inc de
	ld [wde93], a
	xor a
	ld [wde94], a
	ld hl, wde9d
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, $000b
	add hl, bc
	set 4, [hl]
	ret

Func_44670:
	call Func_44a10
	cp $ff
	jr z, .asm_446c9
	cp $d0
	jr c, .asm_44680
.asm_4467b
	call Func_44786
	jr Func_44670

.asm_44680
	ld hl, $0002
	add hl, bc
	bit 3, [hl]
	jp nz, Func_44723
	bit 5, [hl]
	jp nz, Func_44723
	bit 4, [hl]
	jp nz, Func_44750
	ld a, [wde96]
	and $f
	call Func_44a5b
	ld a, [wde96]
	swap a
	and $f
	jr z, .asm_446c2
	ld hl, $0011
	add hl, bc
	ld [hl], a
	ld e, a
	ld hl, $0012
	add hl, bc
	ld d, [hl]
	call Func_44a2b
	ld hl, $000f
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, $000b
	add hl, bc
	set 4, [hl]
	jp Func_4445c

.asm_446c2
	ld hl, $000b
	add hl, bc
	set 5, [hl]
	ret

.asm_446c9
	ld hl, $0002
	add hl, bc
	bit 1, [hl]
	jr nz, .asm_4467b
	ld a, [wde97]
	cp $4
	jr nc, .asm_446e0
	ld hl, $00ca
	add hl, bc
	bit 0, [hl]
	jr nz, .asm_446f6
.asm_446e0
	ld hl, $0002
	add hl, bc
	bit 5, [hl]
	call nz, Func_44704
	ld a, [wde97]
	cp $4
	jr nz, .asm_446f6
	xor a
	ld [rNR10], a
	ld [wde9a], a
.asm_446f6
	ld hl, $0002
	add hl, bc
	res 0, [hl]
	ld hl, $0000
	add hl, bc
	xor a
	ld [hli], a
	ld [hli], a
	ret

Func_44704:
	ld a, [wde97]
	cp $4
	ret nz
	xor a
	ld hl, wChannel5 + $26
	ld [hli], a
	ld [hl], a
	ld hl, wChannel7 + $26
	ld [hli], a
	ld [hl], a
	ld a, [wdeac]
	ld [wde98], a
	xor a
	ld [wdeac], a
	ld [wdead], a
	ret

Func_44723:
	ld hl, $000b
	add hl, bc
	set 4, [hl]
	ld a, [wde96]
	call Func_44a5b
	call Func_44a10
	ld hl, $000e
	add hl, bc
	ld [hl], a
	call Func_44a10
	ld hl, $000f
	add hl, bc
	ld [hl], a
	ld a, [wde97]
	and $3
	cp $3
	ret z
	call Func_44a10
	ld hl, $0010
	add hl, bc
	ld [hl], a
	ret

Func_44750:
	ld a, [wde97]
	cp $3
	ret nz
	ld a, [wde96]
	and $f
	call Func_44a5b
	ld a, [wdea1]
	ld e, a
	ld d, $0
	ld hl, Data_44ba2
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wde96]
	swap a
	and $f
	ret z
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld [wde9d], a
	ld a, [hl]
	ld [wde9e], a
	xor a
	ld [wde9f], a
	ret

Func_44786:
	ld a, [wde96]
	sub $d0
	ld e, a
	ld d, $0
	ld hl, PointerTable_44797
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PointerTable_44797:
	dw Func_449b6
	dw Func_449b6
	dw Func_449b6
	dw Func_449b6
	dw Func_449b6
	dw Func_449b6
	dw Func_449b6
	dw Func_449b6
	dw Func_44973
	dw Func_449c1
	dw Func_449aa
	dw Func_44994
	dw Func_449a1
	dw Func_44987
	dw Func_44939
	dw Func_44951
	dw Func_448ff
	dw Func_448c4
	dw Func_448b5
	dw Func_4495f
	dw Func_449ca
	dw Func_449da
	dw Func_44926
	dw Func_447f7
	dw Func_447f7
	dw Func_449e9
	dw Func_447f7
	dw Func_447f7
	dw Func_44a05
	dw Func_44a0b
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_447f7
	dw Func_44885
	dw Func_4488e
	dw Func_44833
	dw Func_44843
	dw Func_4480d
	dw Func_447f8

Func_447f7:
	ret

Func_447f8:
	ld hl, $0002
	add hl, bc
	res 1, [hl]
	ld hl, $0007
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0005
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Func_4480d:
	call Func_44a10
	ld e, a
	call Func_44a10
	ld d, a
	push de
	ld hl, $0005
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0007
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	ld hl, $0005
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, $0002
	add hl, bc
	set 1, [hl]
	ret

Func_44833:
	call Func_44a10
	ld e, a
	call Func_44a10
	ld d, a
	ld hl, $0005
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Func_44843:
	call Func_44a10
	ld hl, $0002
	add hl, bc
	bit 2, [hl]
	jr nz, .asm_44859
	and a
	jr z, .asm_44862
	dec a
	set 2, [hl]
	ld hl, $0016
	add hl, bc
	ld [hl], a
.asm_44859
	ld hl, $0016
	add hl, bc
	ld a, [hl]
	and a
	jr z, .asm_44872
	dec [hl]
.asm_44862
	call Func_44a10
	ld e, a
	call Func_44a10
	ld d, a
	ld hl, $0005
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

.asm_44872
	ld hl, $0002
	add hl, bc
	res 2, [hl]
	ld hl, $0005
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

Func_44885:
	call Func_44a10
	ld hl, $000c
	add hl, bc
	ld [hl], a
	ret

Func_4488e:
	call Func_44a10
	ld hl, $000c
	add hl, bc
	cp [hl]
	jr z, .asm_448a5
	ld hl, $0005
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

.asm_448a5
	call Func_44a10
	ld e, a
	call Func_44a10
	ld d, a
	ld hl, $0005
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Func_448b5:
	call Func_44a10
	ld hl, $0025
	add hl, bc
	ld [hl], a
	ld hl, $0003
	add hl, bc
	set 3, [hl]
	ret

Func_448c4:
	ld hl, $0003
	add hl, bc
	set 0, [hl]
	ld hl, $0004
	add hl, bc
	res 0, [hl]
	call Func_44a10
	ld hl, $001c
	add hl, bc
	ld [hl], a
	ld hl, $001b
	add hl, bc
	ld [hl], a
	call Func_44a10
	ld hl, $001d
	add hl, bc
	ld d, a
	and $f0
	swap a
	srl a
	ld e, a
	adc $0
	swap a
	or e
	ld [hl], a
	ld hl, $001e
	add hl, bc
	ld a, d
	and $f
	ld d, a
	swap a
	or d
	ld [hl], a
	ret

Func_448ff:
	call Func_44a10
	ld [wde95], a
	call Func_44a10
	ld d, a
	and $f
	ld e, a
	ld a, d
	swap a
	and $f
	ld d, a
	call Func_44a2b
	ld hl, $001f
	add hl, bc
	ld [hl], e
	ld hl, $0020
	add hl, bc
	ld [hl], d
	ld hl, $0003
	add hl, bc
	set 1, [hl]
	ret

Func_44926:
	ld hl, $0003
	add hl, bc
	set 4, [hl]
	ld hl, $0027
	add hl, bc
	call Func_44a10
	ld [hld], a
	call Func_44a10
	ld [hl], a
	ret

Func_44939:
	ld hl, $0003
	add hl, bc
	set 2, [hl]
	call Func_44a10
	rrca
	rrca
	ld hl, $001a
	add hl, bc
	ld [hl], a
	and $c0
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret

Func_44951:
	ld hl, $0002
	add hl, bc
	bit 3, [hl]
	jr z, .asm_4495c
	res 3, [hl]
	ret

.asm_4495c
	set 3, [hl]
	ret

Func_4495f:
	ld hl, $0002
	add hl, bc
	bit 4, [hl]
	jr z, .asm_4496a
	res 4, [hl]
	ret

.asm_4496a
	set 4, [hl]
	call Func_44a10
	ld [wdea1], a
	ret

Func_44973:
	call Func_44a10
	ld hl, $0028
	add hl, bc
	ld [hl], a
	ld a, [wde97]
	and $3
	cp $3
	ret z
	call Func_449a1
	ret

Func_44987:
	call Func_44a10
	ld [wde9a], a
	ld hl, $000b
	add hl, bc
	set 3, [hl]
	ret

Func_44994:
	call Func_44a10
	rrca
	rrca
	and $c0
	ld hl, $000d
	add hl, bc
	ld [hl], a
	ret

Func_449a1:
	call Func_44a10
	ld hl, $000e
	add hl, bc
	ld [hl], a
	ret

Func_449aa:
	call Func_44a10
	ld d, a
	call Func_44a10
	ld e, a
	call Func_44a95
	ret

Func_449b6:
	ld hl, $0012
	add hl, bc
	ld a, [wde96]
	and $7
	ld [hl], a
	ret

Func_449c1:
	call Func_44a10
	ld hl, $0013
	add hl, bc
	ld [hl], a
	ret

Func_449ca:
	ld a, [wde97]
	call Func_44af4
	call Func_44a10
	ld hl, $0019
	add hl, bc
	and [hl]
	ld [hl], a
	ret

Func_449da:
	call Func_44a10
	ld a, [wdea2]
	and a
	ret nz
	ld a, [wde96]
	ld [wde98], a
	ret

Func_449e9:
	call Func_44a10
	; cast to s16
	ld e, a
	cp $80
	jr nc, .asm_449f5
	ld d, $0
	jr .asm_449f7

.asm_449f5
	ld d, $ff
.asm_449f7
	ld hl, $0017
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld e, l
	ld d, h
	call Func_44a95
	ret

Func_44a05:
	ld a, $1
	ld [wdead], a
	ret

Func_44a0b:
	xor a
	ld [wdead], a
	ret

Func_44a10:
	push hl
	push de
	ld hl, $0005
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	ld [wde96], a
	inc de
	ld hl, $0005
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	pop hl
	ld a, [wde96]
	ret

Func_44a2b:
	ld hl, $0013
	add hl, bc
	ld a, [hl]
	swap a
	and $f
	add d
	push af
	ld hl, $0013
	add hl, bc
	ld a, [hl]
	and $f
	ld l, a
	ld d, $0
	ld h, d
	add hl, de
	add hl, hl
	ld de, Data_44b20 
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop af
.asm_44a4b
	cp $7
	jr nc, .asm_44a56
	sra d
	rr e
	inc a
	jr .asm_44a4b

.asm_44a56
	ld a, d
	and $7
	ld d, a
	ret

Func_44a5b:
	inc a
	ld e, a
	ld d, $0
	ld hl, $0028
	add hl, bc
	ld a, [hl]
	ld l, $0
	call Func_44a86
	ld a, l
	ld hl, $0017
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $0015
	add hl, bc
	ld l, [hl]
	call Func_44a86
	ld e, l
	ld d, h
	ld hl, $0015
	add hl, bc
	ld [hl], e
	ld hl, $0014
	add hl, bc
	ld [hl], d
	ret

Func_44a86:
	ld h, $0
.asm_44a88
	srl a
	jr nc, .asm_44a8d
	add hl, de
.asm_44a8d
	sla e
	rl d
	and a
	jr nz, .asm_44a88
	ret

Func_44a95:
	push bc
	ld a, [wde97]
	cp $4
	jr nc, .asm_44ab7
	ld bc, wChannel0
	call Func_44ad1
	ld bc, wChannel1
	call Func_44ad1
	ld bc, wChannel2
	call Func_44ad1
	ld bc, wChannel3
	call Func_44ad1
	jr .asm_44acf

.asm_44ab7
	ld bc, wChannel4
	call Func_44ad1
	ld bc, wChannel5
	call Func_44ad1
	ld bc, wChannel6
	call Func_44ad1
	ld bc, wChannel7
	call Func_44ad1
.asm_44acf
	pop bc
	ret

Func_44ad1:
	ld hl, $0017
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld hl, $0015
	add hl, bc
	ld [hl], a
	ret

Func_44adf:
	call Func_44b06
	ld a, [wdeae]
	jr .asm_44aea

	ld a, [wde97]
.asm_44aea
	call Func_44af4
	ld hl, $0002
	add hl, bc
	set 0, [hl]
	ret

Func_44af4:
	push de
	and $3
	ld e, a
	ld d, $0
	ld hl, Data_44c8e
	add hl, de
	ld a, [hl]
	ld hl, $0019
	add hl, bc
	ld [hl], a
	pop de
	ret

Func_44b06:
	ld a, [wdeae]
	and $3
	cp $0
	ret nz
	xor a
	ld [rNR10], a
	ld [wde9a], a
	ret

Func_44b15:
	ld a, $1
	ld [wdd00], a
	ret

Func_44b1b:
	xor a
	ld [wdd00], a
	ret

Data_44b20:
	dw $0000
	dw $f82c
	dw $f89d
	dw $f907
	dw $f96b
	dw $f9ca
	dw $fa23
	dw $fa77
	dw $fac7
	dw $fb12
	dw $fb58
	dw $fb9b
	dw $fbda
	dw $fc16
	dw $fc4e
	dw $fc83
	dw $fcb5
	dw $fce5
	dw $fd11
	dw $fd3b
	dw $fd63
	dw $fd89
	dw $fdac
	dw $fdcd
	dw $fded

WavePatterns_Bank11:
WavePattern0_Bank11:
	db $02, $46, $8A, $CE, $FF, $FE, $ED, $DC, $CB, $A9, $87, $65, $44, $33, $22, $11
WavePattern1_Bank11:
	db $02, $46, $8A, $CE, $EF, $FF, $FE, $EE, $DD, $CB, $A9, $87, $65, $43, $22, $11
WavePattern2_Bank11:
	db $01, $23, $43, $21, $FE, $CA, $8A, $CE, $01, $23, $43, $21, $FE, $CA, $8A, $CE
WavePattern3_Bank11:
	db $00, $11, $22, $33, $44, $33, $22, $11, $FF, $EE, $CC, $AA, $88, $AA, $CC, $EE
WavePattern4_Bank11:
	db $00, $11, $22, $33, $44, $33, $22, $11, $FF, $EE, $CC, $AA, $88, $AA, $CC, $EE

Data_44ba2:
; related to percussion instruments
	dw Data_44bae
	dw Data_44bce
	dw Data_44bee
	dw Data_44bee
	dw Data_44bee
	dw Data_44bee

Data_44bae:
	dw Data_44c12
	dw Data_44c13
	dw Data_44c17
	dw Data_44c1b
	dw Data_44c1f
	dw Data_44c26
	dw Data_44c0e
	dw Data_44c31
	dw Data_44c35
	dw Data_44c3c
	dw Data_44c43
	dw Data_44c47
	dw Data_44c64
	dw Data_44c12
	dw Data_44c12
	dw Data_44c12

Data_44bce:
	dw Data_44c12
	dw Data_44c0e
	dw Data_44c17
	dw Data_44c1b
	dw Data_44c1f
	dw Data_44c60
	dw Data_44c2d
	dw Data_44c68
	dw Data_44c52
	dw Data_44c59
	dw Data_44c87
	dw Data_44c47
	dw Data_44c4b
	dw Data_44c12
	dw Data_44c12
	dw Data_44c12

Data_44bee:
	dw Data_44c12
	dw Data_44c43
	dw Data_44c47
	dw Data_44c1b
	dw Data_44c1f
	dw Data_44c6f
	dw Data_44c73
	dw Data_44c77
	dw Data_44c35
	dw Data_44c3c
	dw Data_44c7b
	dw Data_44c7f
	dw Data_44c83
	dw Data_44c12
	dw Data_44c12
	dw Data_44c12

Data_44c0e:
	db $20, $11, $11
	db $FF ; terminator

Data_44c12:
	db $FF ; terminator

Data_44c13:
	db $20, $91, $33
	db $FF ; terminator

Data_44c17:
	db $20, $51, $32
	db $FF ; terminator

Data_44c1b:
	db $20, $81, $31
	db $FF ; terminator

Data_44c1f:
	db $21, $71, $70, $20, $11, $11
	db $FF ; terminator

Data_44c26:
	db $30, $82, $4C, $22, $61, $20
	db $FF ; terminator

Data_44c2d:
	db $30, $91, $18
	db $FF ; terminator

Data_44c31:
	db $27, $92, $10
	db $FF ; terminator

Data_44c35:
	db $33, $91, $00, $33, $11, $00
	db $FF ; terminator

Data_44c3c:
	db $33, $91, $11, $33, $11, $00
	db $FF ; terminator

Data_44c43:
	db $01, $18, $01
	db $FF ; terminator

Data_44c47:
	db $01, $28, $01
	db $FF ; terminator

Data_44c4b:
	db $33, $88, $15, $20, $65, $12
	db $FF ; terminator

Data_44c52:
	db $33, $51, $21, $33, $11, $11
	db $FF ; terminator

Data_44c59:
	db $33, $51, $50, $33, $11, $11
	db $FF ; terminator

Data_44c60:
	db $20, $A1, $31
	db $FF ; terminator

Data_44c64:
	db $20, $84, $12
	db $FF ; terminator

Data_44c68:
	db $33, $81, $00, $33, $11, $00
	db $FF ; terminator

Data_44c6f:
	db $01, $38, $01
	db $FF ; terminator

Data_44c73:
	db $01, $48, $01
	db $FF ; terminator

Data_44c77:
	db $01, $58, $01
	db $FF ; terminator

Data_44c7b:
	db $01, $68, $01
	db $FF ; terminator

Data_44c7f:
	db $01, $78, $01
	db $FF ; terminator

Data_44c83:
	db $01, $88, $01
	db $FF ; terminator

Data_44c87:
	db $33, $81, $21, $33, $11, $11
	db $FF ; terminator

Data_44c8e:
	db $11, $22, $44, $88

ChannelPointers_Bank11:
	dw wChannel0
	dw wChannel1
	dw wChannel2
	dw wChannel3
	dw wChannel4
	dw wChannel5
	dw wChannel6
	dw wChannel7

SongHeaderPointers_Bank11: ; 0x44ca2
	dw Music_Nothing11
	dw Music_WhackTheDiglett
	dw Music_WhackTheDugtrio
	dw Music_SeelStage
	dw Music_Title

INCLUDE "audio/music/nothing11.asm"
INCLUDE "audio/music/whackthediglett.asm"
INCLUDE "audio/music/whackthedugtrio.asm"
INCLUDE "audio/music/seelstage.asm"
INCLUDE "audio/music/title.asm"

SoundEffects_Bank11:
	dw SoundEffect0_Bank11
	dw SoundEffect1_Bank11
	dw SoundEffect2_Bank11
	dw SoundEffect3_Bank11
	dw SoundEffect4_Bank11
	dw SoundEffect5_Bank11
	dw SoundEffect6_Bank11
	dw SoundEffect7_Bank11
	dw SoundEffect8_Bank11
	dw SoundEffect9_Bank11
	dw SoundEffect10_Bank11
	dw SoundEffect11_Bank11
	dw SoundEffect12_Bank11
	dw SoundEffect13_Bank11
	dw SoundEffect14_Bank11
	dw SoundEffect15_Bank11
	dw SoundEffect16_Bank11
	dw SoundEffect17_Bank11
	dw SoundEffect18_Bank11
	dw SoundEffect19_Bank11
	dw SoundEffect20_Bank11
	dw SoundEffect21_Bank11
	dw SoundEffect22_Bank11
	dw SoundEffect23_Bank11
	dw SoundEffect24_Bank11
	dw SoundEffect25_Bank11
	dw SoundEffect26_Bank11
	dw SoundEffect27_Bank11
	dw SoundEffect28_Bank11
	dw SoundEffect29_Bank11
	dw SoundEffect30_Bank11
	dw SoundEffect31_Bank11
	dw SoundEffect32_Bank11
	dw SoundEffect33_Bank11
	dw SoundEffect34_Bank11
	dw SoundEffect35_Bank11
	dw SoundEffect36_Bank11
	dw SoundEffect37_Bank11
	dw SoundEffect38_Bank11
	dw SoundEffect39_Bank11
	dw SoundEffect40_Bank11
	dw SoundEffect41_Bank11
	dw SoundEffect42_Bank11
	dw SoundEffect43_Bank11
	dw SoundEffect44_Bank11
	dw SoundEffect45_Bank11
	dw SoundEffect46_Bank11
	dw SoundEffect47_Bank11
	dw SoundEffect48_Bank11
	dw SoundEffect49_Bank11
	dw SoundEffect50_Bank11
	dw SoundEffect51_Bank11
	dw SoundEffect52_Bank11
	dw SoundEffect53_Bank11
	dw SoundEffect54_Bank11
	dw SoundEffect55_Bank11
	dw SoundEffect56_Bank11
	dw SoundEffect57_Bank11
	dw SoundEffect58_Bank11
	dw SoundEffect59_Bank11
	dw SoundEffect60_Bank11
	dw SoundEffect61_Bank11
	dw SoundEffect62_Bank11
	dw SoundEffect63_Bank11
	dw SoundEffect64_Bank11
	dw SoundEffect65_Bank11
	dw SoundEffect66_Bank11
	dw SoundEffect67_Bank11
	dw SoundEffect68_Bank11
	dw SoundEffect69_Bank11
	dw SoundEffect70_Bank11
	dw SoundEffect71_Bank11
	dw SoundEffect72_Bank11
	dw SoundEffect73_Bank11
	dw SoundEffect74_Bank11
	dw SoundEffect75_Bank11
	dw SoundEffect76_Bank11
	dw SoundEffect77_Bank11

SoundEffect0_Bank11:
	db $04 ; wChannel4
	dw SoundEffect0_Channel4_Bank11

SoundEffect0_Channel4_Bank11:
	dutycycle $02
	soundinput $94
	soundeffect_note $05, $F6, $0B, $1E
	soundinput $95
	soundeffect_note $08, $8B, $0B, $3E
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect1_Bank11:
	db $04 ; wChannel4
	dw SoundEffect1_Channel4_Bank11

SoundEffect1_Channel4_Bank11:
	dutycycle $02
	soundinput $14
	soundeffect_note $04, $F2, $00, $06
	soundeffect_note $04, $F2, $00, $06
	soundinput $17
	soundeffect_note $0F, $F2, $00, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect2_Bank11:
	db $04 ; wChannel4
	dw SoundEffect2_Channel4_Bank11

SoundEffect2_Channel4_Bank11:
	dutycycle $01
	soundinput $17
	soundeffect_note $0F, $D7, $00, $06
	soundeffect_note $0F, $B7, $80, $05
	soundeffect_note $0F, $87, $00, $05
	soundeffect_note $0F, $47, $80, $04
	soundeffect_note $0F, $17, $00, $04
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect3_Bank11:
	db $04 ; wChannel4
	dw SoundEffect3_Channel4_Bank11

SoundEffect3_Channel4_Bank11:
	dutycycle $02
	soundeffect_note $02, $F1, $80, $06
	soundeffect_note $02, $F1, $80, $07
	soundeffect_note $02, $31, $80, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect4_Bank11:
	db $04 ; wChannel4
	dw SoundEffect4_Channel4_Bank11

SoundEffect4_Channel4_Bank11:
	dutycycle $00
	soundinput $35
	soundeffect_note $0c, $C3, $6B, $3B
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect5_Bank11:
	db $04 ; wChannel4
	dw SoundEffect5_Channel4_Bank11

SoundEffect5_Channel4_Bank11:
	dutycycle $02
	soundinput $95
	soundeffect_note $0F, $F2, $00, $04
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect6_Bank11:
	db $04 ; wChannel4
	dw SoundEffect6_Channel4_Bank11

SoundEffect6_Channel4_Bank11:
	dutycycle $00
	soundinput $17
	soundeffect_note $0F, $D2, $00, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect7_Bank11:
	db $04 ; wChannel4
	dw SoundEffect7_Channel4_Bank11

SoundEffect7_Channel4_Bank11:
	dutycycle $02
	soundinput $9A
	soundeffect_note $04, $F3, $0B, $3E
	soundinput $9D
	soundeffect_note $03, $C2, $2C, $3F
	soundeffect_note $06, $E1, $A2, $1D
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect8_Bank11:
	db $04 ; wChannel4
	dw SoundEffect8_Channel4_Bank11

SoundEffect8_Channel4_Bank11:
	dutycycle $02
	soundinput $88
	soundeffect_note $01, $D2, $62, $07
	soundeffect_note $08, $52, $62, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect9_Bank11:
	db $04 ; wChannel4
	dw SoundEffect9_Channel4_Bank11

SoundEffect9_Channel4_Bank11:
	dutycycle $02
	soundeffect_note $02, $F1, $80, $07
	soundeffect_note $04, $F1, $61, $07
	soundeffect_note $02, $41, $61, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect10_Bank11:
	db $04 ; wChannel4
	dw SoundEffect10_Channel4_Bank11

SoundEffect10_Channel4_Bank11:
	dutycycle $02
	soundinput $2F
	soundeffect_note $0F, $E2, $80, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect11_Bank11:
	db $4 | (($2 - 1) << 6) ; wChannel4
	dw SoundEffect11_Channel4_Bank11
	db $07 ; wChannel7
	dw SoundEffect11_Channel7_Bank11

SoundEffect11_Channel4_Bank11:
	dutycycle $02
	soundinput $16
	soundeffect_note $01, $F1, $27, $06
	soundeffect_note $00, $71, $27, $06
	soundeffect_note $0F, $F2, $00, $04
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect11_Channel7_Bank11:
	soundeffect_percussion $01, $7B, $37
	soundeffect_percussion $00, $00, $00
	soundeffect_percussion $0F, $82, $10
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect12_Bank11:
	db $07 ; wChannel7
	dw SoundEffect12_Channel7_Bank11

SoundEffect12_Channel7_Bank11:
	soundeffect_percussion $01, $F8, $12
	soundeffect_percussion $05, $A1, $20
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect13_Bank11:
	db $04 ; wChannel4
	dw SoundEffect13_Channel4_Bank11

SoundEffect13_Channel4_Bank11:
	dutycycle $02
	soundeffect_note $01, $F2, $A0, $06
	soundeffect_note $01, $F2, $E0, $06
	soundeffect_note $08, $F1, $00, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect14_Bank11:
	db $04 ; wChannel4
	dw SoundEffect14_Channel4_Bank11

SoundEffect14_Channel4_Bank11:
	dutycycle $02
	soundeffect_note $04, $E1, $C1, $06
	soundeffect_note $02, $E1, $41, $07
	soundeffect_note $0F, $F1, $81, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect15_Bank11:
	db $04 ; wChannel4
	dw SoundEffect15_Channel4_Bank11

SoundEffect15_Channel4_Bank11:
	dutycycle $01
	soundinput $AF
	soundeffect_note $0F, $F2, $80, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect16_Bank11:
	db $04 ; wChannel4
	dw SoundEffect16_Channel4_Bank11

SoundEffect16_Channel4_Bank11:
	togglesfx
	forceoctave $04
SoundEffect16_Channel4_Loop_Bank11:
	notetype $01, $F8
	soundinput $24
	dutycycle $00
	octave 2
	note C_, 2
	octave 4
	note E_, 1
	intensity $E8
	octave 4
	note G_, 1
	loopchannel $15, SoundEffect16_Channel4_Loop_Bank11
	octave 5
	note G_, 2
	note C_, 1
	db $FF

SoundEffect17_Bank11:
	db $04 ; wChannel4
	dw SoundEffect17_Channel4_Bank11

SoundEffect17_Channel4_Bank11:
	dutycycle $00
	soundeffect_note $00, $B1, $80, $07
	soundeffect_note $08, $81, $B0, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect18_Bank11:
	db $04 ; wChannel4
	dw SoundEffect18_Channel4_Bank11

SoundEffect18_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $27, $06
	soundeffect_note $02, $41, $27, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect19_Bank11:
	db $04 ; wChannel4
	dw SoundEffect19_Channel19_Bank11

SoundEffect19_Channel19_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $72, $06
	soundeffect_note $02, $41, $72, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect20_Bank11:
	db $04 ; wChannel4
	dw SoundEffect20_Channel4_Bank11

SoundEffect20_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $9D, $06
	soundeffect_note $02, $41, $9D, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect21_Bank11:
	db $04 ; wChannel4
	dw SoundEffect21_Channel4_Bank11
	
SoundEffect21_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $C4, $06
	soundeffect_note $02, $41, $C4, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect22_Bank11:
	db $04 ; wChannel4
	dw SoundEffect22_Channel4_Bank11

SoundEffect22_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $D6, $06
	soundeffect_note $02, $41, $D6, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect23_Bank11:
	db $04 ; wChannel4
	dw SoundEffect23_Channel4_Bank11

SoundEffect23_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $F6, $06
	soundeffect_note $02, $41, $F6, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect24_Bank11:
	db $04 ; wChannel4
	dw SoundEffect24_Channel4_Bank11

SoundEffect24_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $13, $07
	soundeffect_note $02, $41, $13, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect25_Bank11:
	db $04 ; wChannel4
	dw SoundEffect25_Channel4_Bank11

SoundEffect25_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $2D, $07
	soundeffect_note $02, $41, $2D, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect26_Bank11:
	db $04 ; wChannel4
	dw SoundEffect26_Channel4_Bank11

SoundEffect26_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $39, $07
	soundeffect_note $02, $41, $39, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect27_Bank11:
	db $04 ; wChannel4
	dw SoundEffect27_Channel4_Bank11

SoundEffect27_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $4E, $07
	soundeffect_note $02, $41, $4E, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect28_Bank11:
	db $04 ; wChannel4
	dw SoundEffect28_Channel4_Bank11

SoundEffect28_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $62, $07
	soundeffect_note $02, $41, $62, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect29_Bank11:
	db $04 ; wChannel4
	dw SoundEffect29_Channel4_Bank11

SoundEffect29_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $6B, $07
	soundeffect_note $02, $41, $6B, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect30_Bank11:
	db $04 ; wChannel4
	dw SoundEffect30_Channel4_Bank11

SoundEffect30_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $7B, $07
	soundeffect_note $02, $41, $7B, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect31_Bank11:
	db $04 ; wChannel4
	dw SoundEffect31_Channel4_Bank11

SoundEffect31_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $89, $07
	soundeffect_note $02, $41, $89, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect32_Bank11:
	db $04 ; wChannel4
	dw SoundEffect32_Channel4_Bank11

SoundEffect32_Channel4_Bank11:
	dutycycle $01
	soundeffect_note $03, $F1, $96, $07
	soundeffect_note $02, $41, $96, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect33_Bank11:
	db $04 ; wChannel4
	dw SoundEffect33_Channel4_Bank11

SoundEffect33_Channel4_Bank11:
	dutycycle $01
	soundinput $94
	soundeffect_note $02, $F8, $27, $06
	dutycycle $02
	soundinput $95
	soundeffect_note $04, $F4, $6A, $05
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect34_Bank11:
	db $04 | (($2 - 1) << 6) ; wChannel4
	dw SoundEffect34_Channel4_Bank11
	db $05
	dw SoundEffect34_Channel5_Bank11

SoundEffect34_Channel4_Bank11:
	togglesfx
	tempo $88
	volume $77
	notetype $0C, $E1
	dutycycle $02
	octave 3
	note B_, 1
	note E_, 1
	octave 4
	note E_, 1
	note G#, 1
	intensity $52
	note G#, 1
	intensity $E1
	note A_, 1
	intensity $52
	note A_, 1
	intensity $E1
	note G#, 1
	intensity $52
	note G#, 1
	db $FF

SoundEffect34_Channel5_Bank11:
	togglesfx
	notetype $06, $B1
	dutycycle $02
	octave 4
	note E_, 2
	note G#, 2
	note B_, 2
	octave 5
	note E_, 2
	intensity $52
	note E_, 2
	intensity $B1
	note F#, 2
	intensity $52
	note F#, 2
	intensity $B1
	note E_, 2
	intensity $52
	note E_, 2
	db $FF

SoundEffect35_Bank11:
	db $04 | (($3 - 1) << 6) ; wChannel4
	dw SoundEffect35_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect35_Channel5_Bank11
	db $06 ; wChannel6
	dw SoundEffect35_Channel6_Bank11

SoundEffect35_Channel4_Bank11:
	togglesfx
	tempo $73
	volume $77
	tone $01
	dutycycle $02
	notetype $06, $56
	octave 5
	note C_, 8
	octave 4
	note B_, 8
	intensity $66
	note A#, 8
	note A_, 8
	intensity $76
	note G_, 10
	note __, 1
	intensity $68
	note G#, 1
	intensity $88
	note A_, 2
	note G_, 2
	vibrato $12, $34
	notetype $0C, $97
	note F#, 12
	db $FF

SoundEffect35_Channel5_Bank11:
	togglesfx
	vibrato $12, $34
	dutycycle $03
	notetype $0C, $B4
	octave 3
	note E_, 1
	intensity $28
	note E_, 1
	callchannel SoundEffect35_Channel5_ch1_Bank11
	intensity $B4
	note A#, 1
	intensity $28
	note A#, 1
	callchannel SoundEffect35_Channel5_ch1_Bank11
	intensity $B8
	note B_, 5
	intensity $28
	note B_, 1
	intensity $B8
	note C_, 1
	octave 3
	note B_, 1
	intensity $B7
	note A_, 12
	db $FF

SoundEffect35_Channel5_ch1_Bank11:
	intensity $B4
	note G_, 1
	intensity $28
	note G_, 1
	intensity $B4
	note A_, 1
	intensity $28
	note A_, 1
	intensity $B4
	note G_, 1
	intensity $28
	note G_, 1
	db $FF

SoundEffect35_Channel6_Bank11:
	togglesfx
	notetype $06, $22
	octave 2
	note C_, 2
	intensity $32
	octave 3
	note C_, 1
	note __, 1
	octave 2
	note G_, 1
	note __, 1
	octave 3
	note C_, 1
	note __, 1
	note C_, 2
	note __, 2
	intensity $22
	octave 1
	note E_, 2
	note G_, 2
	octave 2
	note C#, 2
	intensity $32
	octave 3
	note C#, 1
	note __, 1
	octave 2
	note G_, 1
	note __, 1
	octave 3
	note C#, 1
	note __, 1
	note C#, 2
	note __, 2
	intensity $22
	octave 1
	note A_, 2
	note G_, 2
	octave 2
	note D_, 2
	intensity $32
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note A_, 1
	note __, 1
	octave 3
	note D_, 1
	note __, 1
	note D_, 2
	note __, 2
	intensity $22
	octave 2
	note D_, 2
	note E_, 2
	notetype $0C, $22
	note F#, 12
	db $FF

SoundEffect36_Bank11:
	db $04 | (($3 - 1) << 6) ; wChannel4
	dw SoundEffect36_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect36_Channel5_Bank11
	db $06 ; wChannel6
	dw SoundEffect36_Channel6_Bank11

SoundEffect36_Channel4_Bank11:
	togglesfx
	tempo $70
	volume $77
	dutycycle $02
	notetype $08, $81
	note __, 3
SoundEffect36_Channel4_loop_Bank11:
	octave 4
	note F_, 2
	note D_, 2
	intensity $88
	octave 2
	note A#, 1
	note __, 1
	loopchannel $02, SoundEffect36_Channel4_loop_Bank11
	intensity $81
	octave 4
	note E_, 2
	note C_, 2
	intensity $88
	octave 3
	note C_, 1
	note __, 1
	intensity $81
	octave 4
	note C_, 2
	octave 3
	note G_, 2
	intensity $88
	note C_, 1
	note __, 1
	dutycycle $00
	intensity $A8
	octave 2
	note A_, 2
	note __, 4
	octave 3
	note C_, 2
	note __, 2
	octave 2
	note A_, 2
	note __, 2
	db $FF

SoundEffect36_Channel5_Bank11:
	togglesfx
	dutycycle $03
	notetype $08, $A8
	octave 4
	note C_, 1
	note E_, 1
	note F#, 1
	note G_, 4
	note A_, 1
	intensity $28
	note A_, 1
	intensity $A8
	note G_, 4
	note F_, 1
	intensity $28
	note F_, 1
	intensity $A8
	note G_, 4
	note F_, 1
	intensity $28
	note F_, 1
	intensity $A8
	note E_, 2
	intensity $88
	note D#, 1
	intensity $78
	note D_, 1
	intensity $A8
	note C_, 2
	octave 3
	note F_, 2
	intensity $28
	note F_, 2
	note __, 1
	intensity $88
	note G#, 1
	intensity $A8
	note A_, 2
	intensity $28
	note A_, 2
	intensity $A8
	note F_, 2
	intensity $28
	note F_, 2
	db $FF

SoundEffect36_Channel6_Bank11:
	togglesfx
	notetype $08, $22
	note __, 3
	octave 1
	note A#, 4
	octave 2
	note F_, 1
	note __, 1
	octave 1
	note A#, 4
	octave 2
	note F_, 1
	note __, 1
	note C_, 4
	note G_, 1
	note __, 1
	note C_, 4
	note G_, 1
	note __, 1
	note C_, 2
	note __, 4
	note F_, 2
	note __, 2
	note C_, 2
	note __, 2
	db $FF

SoundEffect37_Bank11:
	db $04 | (($3 - 1) << 6) ; wChannel4
	dw SoundEffect37_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect37_Channel5_Bank11
	db $06 ; wChannel6
	dw SoundEffect37_Channel6_Bank11

SoundEffect37_Channel4_Bank11:
	togglesfx
	tempo $6E
	volume $77
	dutycycle $02
	notetype $06, $91
	note __, 4
	octave 3
	note G_, 2
	intensity $71
	note A#, 2
	octave 4
	note D_, 2
	note F_, 2
	intensity $91
	octave 3
	note G_, 2
	intensity $71
	note A#, 2
	octave 4
	note D_, 2
	octave 3
	note A#, 2
	intensity $91
	note E_, 2
	intensity $71
	note G_, 2
	note A_, 2
	octave 4
	note C_, 2
	intensity $91
	octave 3
	note E_, 2
	intensity $71
	note G_, 2
	note A_, 2
	note G_, 2
	intensity $91
	note F_, 2
	intensity $71
	note A#, 2
	octave 4
	note D_, 2
	octave 3
	note F_, 2
	intensity $91
	note A#, 2
	intensity $71
	octave 4
	note D_, 2
	intensity $91
	octave 3
	note A#, 2
	intensity $71
	octave 4
	note D_, 2
	intensity $A3
	note E_, 4
	note __, 4
	dutycycle $03
	octave 3
	note E_, 2
	note __, 2
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	note C_, 4
	db $FF

SoundEffect37_Channel5_Bank11:
	togglesfx
	dutycycle $03
	notetype $06, $B3
	octave 4
	note F_, 3
	note A_, 1
	note A#, 4
	note A_, 4
	note G_, 4
	note F_, 4
	note E_, 4
	note F_, 4
	note G_, 4
	note F_, 3
	note F#, 1
	note G_, 4
	note F_, 4
	note E_, 4
	note F_, 4
	note G_, 4
	intensity $28
	note G_, 2
	note __, 2
	intensity $b3
	octave 3
	note G_, 2
	intensity $28
	note G_, 2
	intensity $b3
	note E_, 1
	intensity $28
	note E_, 1
	intensity $b3
	note E_, 1
	intensity $28
	note E_, 1
	intensity $b3
	note F_, 4
	db $FF

SoundEffect37_Channel6_Bank11:
	togglesfx
	notetype $06, $22
	note __, 4
	octave 1
	note A#, 2
	note __, 2
	note A#, 2
	note __, 2
	octave 2
	note D_, 5
	note __, 1
	octave 1
	note A#, 2
	note A_, 2
	note __, 2
	note A_, 2
	note __, 2
	octave 2
	note C_, 5
	note __, 1
	octave 1
	note A_, 2
	note A#, 2
	note __, 2
	note F_, 2
	note __, 2
	note F_, 5
	note __, 1
	note A#, 2
	octave 2
	note C_, 4
	note __, 4
	note C_, 2
	note __, 2
	octave 1
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A_, 4
	db $FF

SoundEffect38_Bank11:
	db $04 | (($3 - 1) << 6) ; wChannel4
	dw SoundEffect38_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect38_Channel5_Bank11
	db $06 ; wChannel6
	dw SoundEffect38_Channel6_Bank11

SoundEffect38_Channel4_Bank11:
	togglesfx
	tempo $70
	volume $77
	dutycycle $03
	vibrato $09, $34
	forceoctave $07
	notetype $08, $A3
	octave 3
	note C_, 4
	intensity $78
	octave 2
	note C_, 2
	intensity $A3
	note A#, 4
	intensity $78
	note C_, 2
	intensity $A3
	note A_, 4
	intensity $78
	note C_, 2
	intensity $38
	octave 3
	note C_, 1
	intensity $48
	note D_, 1
	intensity $58
	note E_, 1
	intensity $68
	note F_, 1
	intensity $78
	note G_, 1
	intensity $88
	note A_, 1
	intensity $91
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note C#, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 2
	note A#, 1
	note __, 1
	intensity $85
	octave 3
	note C_, 12
	note __, 1
	db $FF

SoundEffect38_Channel5_Bank11:
	togglesfx
	dutycycle $03
	vibrato $09, $34
	forceoctave $07
	notetype $08, $B8
	octave 3
	note A_, 4
	intensity $28
	note A_, 2
	intensity $B8
	note F_, 4
	intensity $28
	note F_, 2
	intensity $B8
	note C_, 4
	intensity $28
	note C_, 2
	note __, 6
	intensity $98
	note A#, 1
	intensity $28
	note A#, 1
	intensity $B8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $B8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $B8
	note G_, 1
	intensity $28
	note G_, 1
	intensity $B8
	note G_, 1
	intensity $28
	note G_, 1
	intensity $B8
	note A#, 1
	intensity $28
	note A#, 1
	intensity $B5
	note A_, 12
	note __, 1
	db $FF

SoundEffect38_Channel6_Bank11:
	togglesfx
	forceoctave $07
	notetype $08, $22
	octave 1
	note F_, 2
	note __, 2
	note A_, 2
	note F_, 2
	note __, 2
	note A#, 2
	note F_, 2
	note __, 2
	note A_, 2
	note F_, 2
	note __, 2
	note A_, 2
	note A#, 2
	note __, 2
	octave 2
	note D_, 1
	note __, 1
	note C#, 2
	note __, 2
	note F_, 1
	note __, 1
	note F_, 12
	note __, 1
	db $FF

SoundEffect39_Bank11:
	db $04 | (($2 - 1) << 6) ; wChannel4
	dw SoundEffect39_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect39_Channel5_Bank11

SoundEffect39_Channel4_Bank11:
	togglesfx
	tempo $80
	volume $77
	dutycycle $02
	notetype $0C, $C1
	forceoctave $05
	octave 4
	note G_, 1
	note D_, 1
	note A_, 1
	intensity $72
	octave 5
	note D_, 1
	intensity $52
	octave 4
	note A_, 1
	intensity $32
	octave 5
	note D_, 1
	intensity $22
	octave 4
	note A_, 1
	intensity $12
	octave 5
	note D_, 1
	db $FF

SoundEffect39_Channel5_Bank11:
	togglesfx
	notetype $06, $A1
	dutycycle $02
	forceoctave $05
	octave 4
	note D_, 2
	octave 3
	note A_, 2
	octave 4
	note D_, 2
	note __, 2
	intensity $52
	note D_, 2
	note __, 2
	intensity $22
	note D_, 2
	db $FF

SoundEffect40_Bank11:
	db $04 ; wChannel4
	dw SoundEffect40_Channel4_Bank11

SoundEffect40_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 4
	note C_, 2
	note E_, 2
	note G_, 2
	octave 5
	note C_, 9
	intensity $A1
	note C_, 9
	intensity $71
	note C_, 9
	intensity $41
	note C_, 9
	note __, 2
	db $FF

SoundEffect41_Bank11:
	db $04 | (($3 - 1) << 6) ; wChannel4
	dw SoundEffect41_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect41_Channel5_Bank11
	db $06 ; wChannel6
	dw SoundEffect41_Channel6_Bank11

SoundEffect41_Channel4_Bank11:
	togglesfx
	tempo $78
	volume $77
	tone $01
	vibrato $09, $34
	dutycycle $02
	notetype $06, $93
	octave 3
	note A#, 2
	note __, 2
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note G_, 2
	note __, 2
	note G_, 1
	note __, 1
	note G_, 1
	note __, 1
	note A#, 2
	note __, 2
	note A#, 1
	note __, 1
	note A#, 1
	note __, 1
	note F#, 2
	note __, 2
	note F#, 1
	note __, 1
	note F#, 1
	note __, 1
	intensity $85
	note F_, 16
	note __, 1
	db $FF

SoundEffect41_Channel5_Bank11:
	togglesfx
	vibrato $09, $34
	dutycycle $02
	callchannel SoundEffect41_Channel5_ch0_Bank11
	forceoctave $18
	callchannel SoundEffect41_Channel5_ch0_Bank11
	forceoctave $03
	callchannel SoundEffect41_Channel5_ch0_Bank11
	forceoctave $01
	callchannel SoundEffect41_Channel5_ch0_Bank11
	forceoctave $00
	intensity $B5
	note D_, 16
	note __, 1
	db $FF
SoundEffect41_Channel5_ch0_Bank11:
	notetype $06, $B3
	octave 4
	note D_, 2
	intensity $28
	note D_, 2
	intensity $B3
	note D_, 1
	intensity $28
	note D_, 1
	intensity $B3
	note D_, 1
	intensity $28
	note D_, 1
	db $FF

SoundEffect41_Channel6_Bank11:
	togglesfx
	notetype $06, $22
	octave 2
	note F_, 2
	note __, 2
	octave 3
	note F_, 1
	note __, 1
	octave 2
	note F_, 1
	note __, 1
	note D#, 2
	note __, 2
	octave 3
	note D#, 1
	note __, 1
	octave 2
	note D#, 1
	note __, 1
	note D_, 2
	note __, 2
	octave 3
	note D_, 1
	note __, 1
	octave 2
	note D_, 1
	note __, 1
	octave 1
	note A#, 2
	note __, 2
	octave 2
	note A#, 1
	note __, 1
	octave 1
	note A#, 1
	note __, 1
	note A#, 16
	note __, 1
	db $FF

SoundEffect42_Bank11:
	db $04 | (($4 - 1) << 6) ; wChannel4
	dw SoundEffect42_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect42_Channel5_Bank11
	db $06 ; wChannel6
	dw SoundEffect42_Channel6_Bank11
	db $07 ; wChannel7
	dw SoundEffect42_Channel7_Bank11

SoundEffect42_Channel4_Bank11:
	togglesfx
	forceoctave $18
	tempo $70
	volume $77
	vibrato $14, $24
	notetype $06, $84
	note __, 12
	dutycycle $03
	octave 4
	note E_, 4
	octave 3
	note A_, 4
	octave 4
	note C#, 4
	note E_, 4
	dutycycle $02
	intensity $88
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 4
	note __, 4
	dutycycle $03
	intensity $84
	octave 4
	note F#, 4
	note C#, 1
	note D_, 3
	octave 3
	note A_, 4
	octave 4
	note F#, 4
	dutycycle $02
	intensity $88
	octave 2
	note A_, 2
	note __, 2
	octave 3
	note A_, 1
	note __, 1
	note A_, 1
	note __, 1
	note A_, 4
	dutycycle $03
	note __, 1
	intensity $67
	octave 4
	note D_, 1
	intensity $77
	note F_, 1
	intensity $87
	note G#, 1
	notetype $0C, $97
	note A_, 12
	note __, 1
	db $FF

SoundEffect42_Channel5_Bank11:
	togglesfx
	forceoctave $18
	vibrato $14, $24
	notetype $06, $B4
	dutycycle $03
	octave 4
	note G#, 4
	note A_, 4
	note B_, 4
	octave 5
	note C#, 4
	note C_, 4
	octave 4
	note B_, 4
	octave 5
	note C#, 4
	intensity $28
	note C#, 2
	note __, 2
	intensity $B4
	note C_, 4
	intensity $28
	note C_, 2
	note __, 2
	intensity $B4
	octave 4
	note B_, 4
	note A_, 4
	octave 5
	note D#, 1
	note E_, 3
	note D_, 4
	note E_, 4
	intensity $28
	note E_, 2
	note __, 2
	intensity $B4
	octave 4
	note B_, 4
	intensity $28
	note B_, 2
	note __, 2
	intensity $B4
	octave 5
	note D_, 4
	notetype $0C, $B7
	note C#, 12
	note __, 1
	db $FF

SoundEffect42_Channel6_Bank11:
	togglesfx
	forceoctave $18
	notetype $06, $22
	octave 2
	note E_, 2
	note __, 2
	note E_, 6
	note __, 2
	note E_, 2
	note __, 2
	note E_, 2
	note __, 2
	note A_, 4
	note E_, 1
	note __, 1
	note E_, 1
	note __, 1
	note C#, 2
	note __, 2
	octave 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 4
	octave 2
	note C#, 4
	note F#, 2
	note __, 2
	note F#, 2
	note __, 2
	note A_, 4
	note D_, 1
	note __, 1
	note D_, 1
	note __, 1
	note D_, 2
	note __, 2
	octave 3
	note F_, 1
	note __, 1
	note F_, 1
	note __, 1
	note F_, 4
	octave 1
	note A_, 4
	notetype $0C, $22
	octave 2
	note E_, 12
	note __, 1
	db $FF

SoundEffect42_Channel7_Bank11:
	note F#, 1
	note C_, 2
	note __, 1
	loopchannel 5, SoundEffect42_Channel7_Bank11
	note D_, 1
	note C_, 2
	note __, 1
	db $FF

SoundEffect43_Bank11:
	db $04 ; wChannel 4
	dw SoundEffect43_Channel4_Bank11

SoundEffect43_Channel4_Bank11:
	dutycycle $01
	soundinput $94
	soundeffect_note $02, $F1, $17, $05
	soundinput $AA
	soundeffect_note $03, $F8, $6C, $1F
	soundeffect_note $03, $F8, $6C, $1F
	soundeffect_note $08, $F1, $6C, $1F
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect44_Bank11:
	db $04 ; wChannel4
	dw SoundEffect44_Channel4_Bank11

SoundEffect44_Channel4_Bank11:
	dutycycle $00
	soundinput $6D
	soundeffect_note $09, $FB, $96, $07
	soundinput $65
	soundeffect_note $04, $FE, $C4, $06
	soundeffect_note $04, $94, $C4, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect45_Bank11:
	db $04 ; wChannel4
	dw SoundEffect45_Channel4_Bank11

SoundEffect45_Channel4_Bank11:
	dutycycle $03
	soundinput $6D
	soundeffect_note $09, $FB, $13, $07
	soundinput $65
	soundeffect_note $04, $FE, $27, $06
	soundeffect_note $04, $94, $27, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect46_Bank11:
	db $04 ; wChannel4
	dw SoundEffect46_Channel4_Bank11

SoundEffect46_Channel4_Bank11:
	dutycycle $03
	soundinput $43
	soundeffect_note $08, $F8, $64, $3B
	soundinput $9F
	soundeffect_note $06, $F8, $64, $3B
	soundinput $95
	soundeffect_note $08, $F8, $64, $3B
	soundinput $5D
	soundeffect_note $06, $F3, $27, $06
	soundeffect_note $04, $E3, $72, $06
	soundeffect_note $04, $D3, $27, $06
	soundeffect_note $08, $C3, $72, $06
	soundeffect_note $10, $A3, $27, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect47_Bank11:
	db $04 ; wChannel4
	dw SoundEffect47_Channel4_Bank11

SoundEffect47_Channel4_Bank11:
	dutycycle $02
	soundeffect_note $01, $E2, $13, $07
	soundeffect_note $08, $62, $13, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect48_Bank11:
	db $04 ; wChannel4
	dw SoundEffect48_Channel4_Bank11

SoundEffect48_Channel4_Bank11:
	dutycycle $00
	soundinput $5E
	soundeffect_note $02, $F8, $D6, $06
	soundeffect_note $02, $A1, $D6, $06
	soundeffect_note $08, $F1, $13, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect49_Bank11:
	db $07 ; wChannel7
	dw SoundEffect49_Channel7_Bank11

SoundEffect49_Channel7_Bank11:
	soundeffect_percussion $03, $8D, $21
	soundeffect_percussion $02, $CC, $22
	soundeffect_percussion $08, $82, $21
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect50_Bank11:
	db $04 ; wChannel4
	dw SoundEffect50_Channel4_Bank11

SoundEffect50_Channel4_Bank11:
	dutycycle $00
	soundeffect_note $01, $91, $96, $07
SoundEffect50_Channel4_loop_Bank11:
_Bank11	soundeffect_note $03, $F1, $C6, $07
	loopchannel $02, SoundEffect50_Channel4_loop_Bank11
	soundeffect_note $0A, $C1, $C6, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect51_Bank11:
	db $04 ; wChannel4
	dw SoundEffect51_Channel4_Bank11

SoundEffect51_Channel4_Bank11:
	dutycycle $00
	soundinput $77
	soundeffect_note $01, $C8, $D6, $06
	soundeffect_note $03, $F8, $62, $07
	soundeffect_note $02, $B3, $6B, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect52_Bank11:
	db $04 ; wChannel4
	dw SoundEffect52_Channel4_Bank11

SoundEffect52_Channel4_Bank11:
	dutycycle $00
	soundeffect_note $01, $91, $B6, $07
	soundeffect_note $02, $F1, $CD, $07
	soundeffect_note $02, $41, $CD, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect53_Bank11:
	db $04 ; wChannel4
	dw SoundEffect53_Channel4_Bank11

SoundEffect53_Channel4_Bank11:
	dutycycle $00
	soundinput $9F
	soundeffect_note $02, $F8, $27, $06
	soundinput $8F
	soundeffect_note $02, $E1, $D6, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect54_Bank11:
	db $04 ; wChannel4
	dw SoundEffect54_Channel4_Bank11

SoundEffect54_Channel4_Bank11:
	dutycycle $00
	soundinput $9E
	soundeffect_note $02, $F8, $27, $05
	soundinput $8F
	soundeffect_note $02, $F1, $D6, $05
	soundinput $BC
	soundeffect_note $07, $F4, $D6, $04
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect55_Bank11:
	db $04 ; wChannel4
	dw SoundEffect55_Channel4_Bank11

SoundEffect55_Channel4_Bank11:
	dutycycle $03
	soundinput $43
	soundeffect_note $08, $F8, $64, $3B
	soundinput $9F
	soundeffect_note $06, $F8, $64, $3B
	soundinput $95
	soundeffect_note $08, $F8, $64, $3B
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect56_Bank11:
	db $04 ; wChannel4
	dw SoundEffect56_Channel4_Bank11

SoundEffect56_Channel4_Bank11:
	dutycycle $02
	soundinput $97
	soundeffect_note $04, $F3, $B6, $06
	soundeffect_note $04, $A3, $7D, $06
	soundeffect_note $04, $63, $07, $06
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect57_Bank11:
	db $07 ; wChannel7
	dw SoundEffect57_Channel7_Bank11

SoundEffect57_Channel7_Bank11:
	soundeffect_percussion $06, $F1, $47
	soundeffect_percussion $04, $B8, $35
	soundeffect_percussion $06, $B1, $59
	soundeffect_percussion $04, $51, $59
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect58_Bank11:
	db $04 ; wChannel4
	dw SoundEffect58_Channel4_Bank11

SoundEffect58_Channel4_Bank11:
	dutycycle $02
	soundinput $A7
	soundeffect_note $05, $D4, $2D, $07
	soundeffect_note $05, $A4, $4E, $07
	soundeffect_note $02, $94, $7B, $07
	soundeffect_note $05, $74, $4E, $07
	soundeffect_note $02, $54, $7B, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect59_Bank11:
	db $04 ; wChannel4
	dw SoundEffect59_Channel4_Bank11

SoundEffect59_Channel4_Bank11:
	dutycycle $02
	soundinput $A7
	soundeffect_note $04, $91, $27, $07
	dutycycle $01
	soundinput $AF
	soundeffect_note $03, $C1, $96, $07
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect60_Bank11:
	db $04 ; wChannel4
	dw SoundEffect60_Channel4_Bank11

SoundEffect60_Channel4_Bank11: ; ; 0x3edb3
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 5
	note C#, 3
	intensity $31
	note C#, 3
	note __, 2
	db $FF

SoundEffect61_Bank11:
	db $04 ; wChannel4
	dw SoundEffect61_Channel4_Bank11

SoundEffect61_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 5
	note F#, 3
	intensity $31
	note F#, 3
	note __, 2
	db $FF

SoundEffect62_Bank11:
	db $04 ; wChannel4
	dw SoundEffect62_Channel4_Bank11

SoundEffect62_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $A1
	octave 4
	note D_, 3
	note A_, 3
	octave 5
	note C#, 9
	intensity $28
	note C#, 3
	note __, 2
	db $FF

SoundEffect63_Bank11:
	db $07 ; wChannel7
	dw SoundEffect63_Channel7_Bank11

SoundEffect63_Channel7_Bank11:
	soundeffect_percussion $01, $B1, $44
	soundeffect_percussion $00, $00, $00
	soundeffect_percussion $01, $51, $44
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect64_Bank11:
	db $07 ; wChannel7
	dw SoundEffect64_Channel7_Bank11

SoundEffect64_Channel7_Bank11:
	soundeffect_percussion $06, $F1, $47
	soundeffect_percussion $04, $C8, $35
	soundeffect_percussion $04, $B1, $59
SoundEffect64_Channel7_loop_Bank11:
	soundeffect_percussion $04, $98, $33
	soundeffect_percussion $06, $64, $69
	loopchannel $03, SoundEffect64_Channel7_loop_Bank11
	soundeffect_percussion $06, $6C, $11
	soundeffect_percussion $06, $6C, $22
	soundeffect_percussion $06, $6C, $33
	soundeffect_percussion $06, $6C, $44
	soundeffect_percussion $16, $83, $55
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect65_Bank11:
	db $04 ; wChannel4
	dw SoundEffect65_Channel4_Bank11

SoundEffect65_Channel4_Bank11:
	dutycycle $02
	soundinput $3A
	soundeffect_note $04, $F2, $00, $02
	soundinput $22
	soundeffect_note $08, $E2, $00, $02
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect66_Bank11:
	db $04 ; wChannel4
	dw SoundEffect66_Channel4_Bank11

SoundEffect66_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $02, $D1
	octave 4
	note A_, 3
	note G#, 3
	note G_, 3
	octave 3
	note B_, 3
	note A_, 3
	note G#, 3
	intensity $D2
	note G_, 16
	note __, 2
	db $FF

SoundEffect67_Bank11:
	db $04 ; wChannel4
	dw SoundEffect67_Channel4_Bank11

SoundEffect67_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $02, $D1
	octave 4
	note G_, 3
	note B_, 3
	octave 5
	note C_, 3
	note D_, 3
	note F_, 3
	note E_, 3
	intensity $D2
	note F_, 16
	note __, 2
	db $FF

SoundEffect68_Bank11:
	db $04 ; wChannel4
	dw SoundEffect68_Channel4_Bank11

SoundEffect68_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 4
	note G_, 2
	octave 5
	note C_, 2
	note E_, 2
	note G_, 9
	intensity $A1
	note G_, 9
	intensity $71
	note G_, 9
	intensity $41
	note G_, 9
	note __, 2
	db $FF

SoundEffect69_Bank11:
	db $04 ; wChannel4
	dw SoundEffect69_Channel4_Bank11

SoundEffect69_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 4
	note C_, 2
	note E_, 2
	note G_, 2
	octave 6
	note C_, 9
	intensity $A1
	note C_, 9
	intensity $71
	note C_, 9
	intensity $41
	note C_, 9
	note __, 2
	db $FF

SoundEffect70_Bank11:
	db $04 ; wChannel4
	dw SoundEffect70_Channel4_Bank11

SoundEffect70_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 4
	note G_, 3
	octave 5
	note D_, 3
	octave 4
	note B_, 3
	octave 5
	note F_, 3
	octave 6
	note C_, 9
	intensity $28
	note C_, 3
	note __, 2
	db $FF

SoundEffect71_Bank11:
	db $04 ; wChannel4
	dw SoundEffect71_Channel4_Bank11

SoundEffect71_Channel4_Bank11:
	dutycycle $00
	soundeffect_note $02, $F8, $64, $3B
	soundeffect_note $02, $28, $64, $3B
	soundeffect_note $14, $F8, $64, $3B
	soundeffect_note $02, $28, $64, $3B
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect72_Bank11:
	db $07 ; wChannel7
	dw SoundEffect72_Channel7_Bank11

SoundEffect72_Channel7_Bank11:
	soundeffect_percussion $00, $E8, $34
	soundeffect_percussion $00, $00, $00
	soundeffect_percussion $01, $E1, $01
	soundeffect_percussion $01, $00, $00
	db $FF

SoundEffect73_Bank11:
	db $04
	dw SoundEffect73_Channel4_Bank11

SoundEffect73_Channel4_Bank11:
	dutycycle $02
SoundEffect73_Channel4_loop_Bank11:
	soundeffect_note $02, $F1, $B6, $07
	soundeffect_note $02, $31, $B6, $07
	loopchannel $04, SoundEffect73_Channel4_loop_Bank11
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect74_Bank11:
	db $04 ; wChannel4
	dw SoundEffect74_Channel4_Bank11

SoundEffect74_Channel4_Bank11:
	dutycycle $02
SoundEffect74_Channel4_loop_Bank11:
	soundeffect_note $02, $F1, $B6, $07
	soundeffect_note $02, $31, $B6, $07
	loopchannel $06, SoundEffect74_Channel4_loop_Bank11
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect75_Bank11:
	db $04 ; wChannel4
	dw SoundEffect75_Channel4_Bank11

SoundEffect75_Channel4_Bank11:
	dutycycle $02
SoundEffect75_Channel4_loop_Bank11:
	soundeffect_note $02, $F1, $B6, $07
	soundeffect_note $02, $31, $B6, $07
	loopchannel $08, SoundEffect75_Channel4_loop_Bank11
	soundeffect_note $01, $00, $00, $00
	db $FF

SoundEffect76_Bank11:
	db $04 ; wChannel4
	dw SoundEffect76_Channel4_Bank11

SoundEffect76_Channel4_Bank11:
	togglesfx
	dutycycle $02
	notetype $01, $F1
	octave 4
	note G_, 3
	note B_, 3
	octave 5
	note D_, 3
	note F#, 14
	note __, 2
	db $FF

SoundEffect77_Bank11:
	db $4 | (($2 - 1) << 6) ; wChannel4
	dw SoundEffect77_Channel4_Bank11
	db $05 ; wChannel5
	dw SoundEffect77_Channel5_Bank11

SoundEffect77_Channel4_Bank11:
	togglesfx
	dutycycle $02
	tempo $90
	volume $77
	notetype $08, $D1
	octave 4
	note G#, 1
	note F_, 1
	note G#, 1
	octave 5
	note C#, 1
	intensity $50
	note C#, 1
	intensity $D1
	octave 4
	note G#, 1
	octave 5
	note C#, 3
	intensity $52
	note C#, 3
	db $FF 

SoundEffect77_Channel5_Bank11:
	togglesfx
	dutycycle $02
	notetype $08, $E1
	octave 5
	note C#, 1
	octave 4
	note G#, 1
	octave 5
	note C#, 1
	note F_, 1
	intensity $50
	note F_, 1
	intensity $E1
	note C#, 1
	note G#, 3
	intensity $52
	note G#, 3
	db $FF

CryBasePointers_Bank11:
	dw Cry_00_Header_Bank11
	dw Cry_01_Header_Bank11
	dw Cry_02_Header_Bank11
	dw Cry_03_Header_Bank11
	dw Cry_04_Header_Bank11
	dw Cry_05_Header_Bank11
	dw Cry_06_Header_Bank11
	dw Cry_07_Header_Bank11
	dw Cry_08_Header_Bank11
	dw Cry_09_Header_Bank11
	dw Cry_0A_Header_Bank11
	dw Cry_0B_Header_Bank11
	dw Cry_0C_Header_Bank11
	dw Cry_0D_Header_Bank11
	dw Cry_0E_Header_Bank11
	dw Cry_0F_Header_Bank11
	dw Cry_10_Header_Bank11
	dw Cry_11_Header_Bank11
	dw Cry_12_Header_Bank11
	dw Cry_13_Header_Bank11
	dw Cry_14_Header_Bank11
	dw Cry_15_Header_Bank11
	dw Cry_16_Header_Bank11
	dw Cry_17_Header_Bank11
	dw Cry_18_Header_Bank11
	dw Cry_19_Header_Bank11
	dw Cry_1A_Header_Bank11
	dw Cry_1B_Header_Bank11
	dw Cry_1C_Header_Bank11
	dw Cry_1D_Header_Bank11
	dw Cry_1E_Header_Bank11
	dw Cry_1F_Header_Bank11
	dw Cry_20_Header_Bank11
	dw Cry_21_Header_Bank11
	dw Cry_22_Header_Bank11
	dw Cry_23_Header_Bank11
	dw Cry_24_Header_Bank11
	dw Cry_25_Header_Bank11

CryData_Bank11:
; Each entry is in the following format:
; [base cry id], [pitch], [length
	dw $000F, $0080, $0081  ; BULBASAUR
	dw $000F, $0020, $0100  ; IVYSAUR
	dw $000F, $0000, $0140  ; VENUSAUR
	dw $0004, $0060, $00C0  ; CHARMANDER
	dw $0004, $0020, $00C0  ; CHARMELEON
	dw $0004, $0000, $0100  ; CHARIZARD
	dw $001D, $0060, $00C0  ; SQUIRTLE
	dw $001D, $0020, $00C0  ; WARTORTLE
	dw $0013, $0000, $0100  ; BLASTOISE
	dw $0016, $0080, $00A0  ; CATERPIE
	dw $001C, $00CC, $0081  ; METAPOD
	dw $0016, $0077, $00C0  ; BUTTERFREE
	dw $0015, $00EE, $0081  ; WEEDLE
	dw $0013, $00FF, $0081  ; KAKUNA
	dw $0013, $0060, $0100  ; BEEDRILL
	dw $000E, $00DF, $0084  ; PIDGEY
	dw $0014, $0028, $0140  ; PIDGEOTTO
	dw $0014, $0011, $017F  ; PIDGEOT
	dw $0022, $0000, $0100  ; RATTATA
	dw $0022, $0020, $017F  ; RATICATE
	dw $0010, $0000, $0100  ; SPEAROW
	dw $0018, $0040, $0120  ; FEAROW
	dw $0017, $0012, $00C0  ; EKANS
	dw $0017, $00E0, $0090  ; ARBOK
	dw $000F, $00EE, $0081  ; PIKACHU
	dw $0009, $00EE, $0088  ; RAICHU
	dw $0000, $0020, $00C0  ; SANDSHREW
	dw $0000, $00FF, $017F  ; SANDSLASH
	dw $0001, $0000, $0100  ; NIDORAN_F
	dw $0001, $002C, $0160  ; NIDORINA
	dw $000A, $0000, $0100  ; NIDOQUEEN
	dw $0000, $0000, $0100  ; NIDORAN_M
	dw $0000, $002C, $0140  ; NIDORINO
	dw $0009, $0000, $0100  ; NIDOKING
	dw $0019, $00CC, $0081  ; CLEFAIRY
	dw $0019, $00AA, $00A0  ; CLEFABLE
	dw $0024, $004F, $0090  ; VULPIX
	dw $0024, $0088, $00E0  ; NINETALES
	dw $000E, $00FF, $00B5  ; JIGGLYPUFF
	dw $000E, $0068, $00E0  ; WIGGLYTUFF
	dw $001D, $00E0, $0100  ; ZUBAT
	dw $001D, $00FA, $0100  ; GOLBAT
	dw $0008, $00DD, $0081  ; ODDISH
	dw $0008, $00AA, $00C0  ; GLOOM
	dw $0023, $0022, $017F  ; VILEPLUME
	dw $001E, $0020, $0160  ; PARAS
	dw $001E, $0042, $017F  ; PARASECT
	dw $001A, $0044, $00C0  ; VENONAT
	dw $001A, $0029, $0100  ; VENOMOTH
	dw $000B, $00AA, $0081  ; DIGLETT
	dw $000B, $002A, $0090  ; DUGTRIO
	dw $0019, $0077, $0090  ; MEOWTH
	dw $0019, $0099, $017F  ; PERSIAN
	dw $0021, $0020, $00E0  ; PSYDUCK
	dw $0021, $00FF, $00C0  ; GOLDUCK
	dw $000A, $00DD, $00E0  ; MANKEY
	dw $000A, $00AF, $00C0  ; PRIMEAPE
	dw $001F, $0020, $00C0  ; GROWLITHE
	dw $0015, $0000, $0100  ; ARCANINE
	dw $000E, $00FF, $017F  ; POLIWAG
	dw $000E, $0077, $00E0  ; POLIWHIRL
	dw $000E, $0000, $017F  ; POLIWRATH
	dw $001C, $00C0, $0081  ; ABRA
	dw $001C, $00A8, $0140  ; KADABRA
	dw $001C, $0098, $017F  ; ALAKAZAM
	dw $001F, $00EE, $0081  ; MACHOP
	dw $001F, $0048, $00E0  ; MACHOKE
	dw $001F, $0008, $0140  ; MACHAMP
	dw $0021, $0055, $0081  ; BELLSPROUT
	dw $0025, $0044, $00A0  ; WEEPINBELL
	dw $0025, $0066, $014C  ; VICTREEBEL
	dw $001A, $0000, $0100  ; TENTACOOL
	dw $001A, $00EE, $017F  ; TENTACRUEL
	dw $0024, $00F0, $0090  ; GEODUDE
	dw $0024, $0000, $0100  ; GRAVELER
	dw $0012, $00E0, $00C0  ; GOLEM
	dw $0025, $0000, $0100  ; PONYTA
	dw $0025, $0020, $0140  ; RAPIDASH
	dw $0002, $0000, $0100  ; SLOWPOKE
	dw $001F, $0000, $0100  ; SLOWBRO
	dw $001C, $0080, $00E0  ; MAGNEMITE
	dw $001C, $0020, $0140  ; MAGNETON
	dw $0010, $00DD, $0081  ; FARFETCH_D
	dw $000B, $00BB, $0081  ; DODUO
	dw $000B, $0099, $00A0  ; DODRIO
	dw $000C, $0088, $0140  ; SEEL
	dw $000C, $0023, $017F  ; DEWGONG
	dw $0005, $0000, $0100  ; GRIMER
	dw $0007, $00EF, $017F  ; MUK
	dw $0018, $0000, $0100  ; SHELLDER
	dw $0018, $006F, $0160  ; CLOYSTER
	dw $001C, $0000, $0100  ; GASTLY
	dw $001C, $0030, $00C0  ; HAUNTER
	dw $0007, $0000, $017F  ; GENGAR
	dw $0017, $00FF, $0140  ; ONIX
	dw $000D, $0088, $00A0  ; DROWZEE
	dw $000D, $00EE, $00C0  ; HYPNO
	dw $0020, $0020, $0160  ; KRABBY
	dw $0020, $00EE, $0160  ; KINGLER
	dw $0006, $00ED, $0100  ; VOLTORB
	dw $0006, $00A8, $0110  ; ELECTRODE
	dw $000B, $0000, $0100  ; EXEGGCUTE
	dw $000D, $0000, $0100  ; EXEGGUTOR
	dw $0019, $0000, $0100  ; CUBONE
	dw $0008, $004F, $00E0  ; MAROWAK
	dw $0012, $0080, $0140  ; HITMONLEE
	dw $000C, $00EE, $0140  ; HITMONCHAN
	dw $000C, $0000, $0100  ; LICKITUNG
	dw $0012, $00E6, $015D  ; KOFFING
	dw $0012, $00FF, $017F  ; WEEZING
	dw $0004, $0000, $0100  ; RHYHORN
	dw $0011, $0000, $0100  ; RHYDON
	dw $0014, $000A, $0140  ; CHANSEY
	dw $0012, $0000, $0100  ; TANGELA
	dw $0003, $0000, $0100  ; KANGASKHAN
	dw $0019, $0099, $0090  ; HORSEA
	dw $0019, $003C, $0081  ; SEADRA
	dw $0016, $0080, $00C0  ; GOLDEEN
	dw $0016, $0010, $017F  ; SEAKING
	dw $001E, $0002, $00A0  ; STARYU
	dw $001E, $0000, $0100  ; STARMIE
	dw $0020, $0008, $00C0  ; MR_MIME
	dw $0016, $0000, $0100  ; SCYTHER
	dw $000D, $00FF, $017F  ; JYNX
	dw $0006, $008F, $017F  ; ELECTABUZZ
	dw $0004, $00FF, $00B0  ; MAGMAR
	dw $0014, $0000, $0100  ; PINSIR
	dw $001D, $0011, $00C0  ; TAUROS
	dw $0017, $0080, $0080  ; MAGIKARP
	dw $0017, $0000, $0100  ; GYARADOS
	dw $001B, $0000, $0100  ; LAPRAS
	dw $000E, $00FF, $017F  ; DITTO
	dw $001A, $0088, $00E0  ; EEVEE
	dw $001A, $00AA, $017F  ; VAPOREON
	dw $001A, $003D, $0100  ; JOLTEON
	dw $001A, $0010, $00A0  ; FLAREON
	dw $0025, $00AA, $017F  ; PORYGON
	dw $001F, $00F0, $0081  ; OMANYTE
	dw $001F, $00FF, $00C0  ; OMASTAR
	dw $0016, $00BB, $00C0  ; KABUTO
	dw $0018, $00EE, $0081  ; KABUTOPS
	dw $0023, $0020, $0170  ; AERODACTYL
	dw $0005, $0055, $0081  ; SNORLAX
	dw $0009, $0080, $00C0  ; ARTICUNO
	dw $0018, $00FF, $0100  ; ZAPDOS
	dw $0009, $00F8, $00C0  ; MOLTRES
	dw $000F, $0060, $00C0  ; DRATINI
	dw $000F, $0040, $0100  ; DRAGONAIR
	dw $000F, $003C, $0140  ; DRAGONITE
	dw $001E, $0099, $017F  ; MEWTWO
	dw $001E, $00EE, $017F  ; MEW

Cry_00_Header_Bank11:
	channelcount 3
	channel 4, Cry_00_Ch4_Bank11
	channel 5, Cry_00_Ch5_Bank11
	channel 7, Cry_00_Ch7_Bank11

Cry_01_Header_Bank11:
	channelcount 3
	channel 4,  Cry_01_Ch4_Bank11
	channel 5,  Cry_01_Ch5_Bank11
	channel 7,  Cry_01_Ch7_Bank11

Cry_02_Header_Bank11:
	channelcount 3
	channel 4, Cry_02_Ch4_Bank11
	channel 5, Cry_02_Ch5_Bank11
	channel 7, Cry_02_Ch7_Bank11

Cry_03_Header_Bank11:
	channelcount 3
	channel 4, Cry_03_Ch4_Bank11
	channel 5, Cry_03_Ch5_Bank11
	channel 7, Cry_03_Ch7_Bank11

Cry_04_Header_Bank11:
	channelcount 3
	channel 4, Cry_04_Ch4_Bank11
	channel 5, Cry_04_Ch5_Bank11
	channel 7, Cry_04_Ch7_Bank11

Cry_05_Header_Bank11:
	channelcount 3
	channel 4, Cry_05_Ch4_Bank11
	channel 5, Cry_05_Ch5_Bank11
	channel 7, Cry_05_Ch7_Bank11

Cry_06_Header_Bank11:
	channelcount 3
	channel 4, Cry_06_Ch4_Bank11
	channel 5, Cry_06_Ch5_Bank11
	channel 7, Cry_06_Ch7_Bank11

Cry_07_Header_Bank11:
	channelcount 3
	channel 4, Cry_07_Ch4_Bank11
	channel 5, Cry_07_Ch5_Bank11
	channel 7, Cry_07_Ch7_Bank11

Cry_08_Header_Bank11:
	channelcount 3
	channel 4, Cry_08_Ch4_Bank11
	channel 5, Cry_08_Ch5_Bank11
	channel 7, Cry_08_Ch7_Bank11

Cry_09_Header_Bank11:
	channelcount 3
	channel 4, Cry_09_Ch4_Bank11
	channel 5, Cry_09_Ch5_Bank11
	channel 7, Cry_09_Ch7_Bank11

Cry_0A_Header_Bank11:
	channelcount 3
	channel 4, Cry_0A_Ch4_Bank11
	channel 5, Cry_0A_Ch5_Bank11
	channel 7, Cry_0A_Ch7_Bank11

Cry_0B_Header_Bank11:
	channelcount 3
	channel 4, Cry_0B_Ch4_Bank11
	channel 5, Cry_0B_Ch5_Bank11
	channel 7, Cry_0B_Ch7_Bank11

Cry_0C_Header_Bank11:
	channelcount 3
	channel 4, Cry_0C_Ch4_Bank11
	channel 5, Cry_0C_Ch5_Bank11
	channel 7, Cry_0C_Ch7_Bank11

Cry_0D_Header_Bank11:
	channelcount 3
	channel 4, Cry_0D_Ch4_Bank11
	channel 5, Cry_0D_Ch5_Bank11
	channel 7, Cry_0D_Ch7_Bank11

Cry_0E_Header_Bank11:
	channelcount 3
	channel 4, Cry_0E_Ch4_Bank11
	channel 5, Cry_0E_Ch5_Bank11
	channel 7, Cry_0E_Ch7_Bank11

Cry_0F_Header_Bank11:
	channelcount 3
	channel 4, Cry_0F_Ch4_Bank11
	channel 5, Cry_0F_Ch5_Bank11
	channel 7, Cry_0F_Ch7_Bank11

Cry_10_Header_Bank11:
	channelcount 3
	channel 4, Cry_10_Ch4_Bank11
	channel 5, Cry_10_Ch5_Bank11
	channel 7, Cry_10_Ch7_Bank11

Cry_11_Header_Bank11:
	channelcount 3
	channel 4, Cry_11_Ch4_Bank11
	channel 5, Cry_11_Ch5_Bank11
	channel 7, Cry_11_Ch7_Bank11

Cry_12_Header_Bank11:
	channelcount 3
	channel 4, Cry_12_Ch4_Bank11
	channel 5, Cry_12_Ch5_Bank11
	channel 7, Cry_12_Ch7_Bank11

Cry_13_Header_Bank11:
	channelcount 3
	channel 4, Cry_13_Ch4_Bank11
	channel 5, Cry_13_Ch5_Bank11
	channel 7, Cry_13_Ch7_Bank11

Cry_14_Header_Bank11:
	channelcount 3
	channel 4, Cry_14_Ch4_Bank11
	channel 5, Cry_14_Ch5_Bank11
	channel 7, Cry_14_Ch7_Bank11

Cry_15_Header_Bank11:
	channelcount 3
	channel 4, Cry_15_Ch4_Bank11
	channel 5, Cry_15_Ch5_Bank11
	channel 7, Cry_15_Ch7_Bank11

Cry_16_Header_Bank11:
	channelcount 3
	channel 4, Cry_16_Ch4_Bank11
	channel 5, Cry_16_Ch5_Bank11
	channel 7, Cry_16_Ch7_Bank11

Cry_17_Header_Bank11:
	channelcount 3
	channel 4, Cry_17_Ch4_Bank11
	channel 5, Cry_17_Ch5_Bank11
	channel 7, Cry_17_Ch7_Bank11

Cry_18_Header_Bank11:
	channelcount 3
	channel 4, Cry_18_Ch4_Bank11
	channel 5, Cry_18_Ch5_Bank11
	channel 7, Cry_18_Ch7_Bank11

Cry_19_Header_Bank11:
	channelcount 3
	channel 4, Cry_19_Ch4_Bank11
	channel 5, Cry_19_Ch5_Bank11
	channel 7, Cry_19_Ch7_Bank11

Cry_1A_Header_Bank11:
	channelcount 3
	channel 4, Cry_1A_Ch4_Bank11
	channel 5, Cry_1A_Ch5_Bank11
	channel 7, Cry_1A_Ch7_Bank11

Cry_1B_Header_Bank11:
	channelcount 3
	channel 4, Cry_1B_Ch4_Bank11
	channel 5, Cry_1B_Ch5_Bank11
	channel 7, Cry_1B_Ch7_Bank11

Cry_1C_Header_Bank11:
	channelcount 3
	channel 4, Cry_1C_Ch4_Bank11
	channel 5, Cry_1C_Ch5_Bank11
	channel 7, Cry_1C_Ch7_Bank11

Cry_1D_Header_Bank11:
	channelcount 3
	channel 4, Cry_1D_Ch4_Bank11
	channel 5, Cry_1D_Ch5_Bank11
	channel 7, Cry_1D_Ch7_Bank11

Cry_1E_Header_Bank11:
	channelcount 3
	channel 4, Cry_1E_Ch4_Bank11
	channel 5, Cry_1E_Ch5_Bank11
	channel 7, Cry_1E_Ch7_Bank11

Cry_1F_Header_Bank11:
	channelcount 3
	channel 4, Cry_1F_Ch4_Bank11
	channel 5, Cry_1F_Ch5_Bank11
	channel 7, Cry_1F_Ch7_Bank11

Cry_20_Header_Bank11:
	channelcount 3
	channel 4, Cry_20_Ch4_Bank11
	channel 5, Cry_20_Ch5_Bank11
	channel 7, Cry_20_Ch7_Bank11

Cry_21_Header_Bank11:
	channelcount 3
	channel 4, Cry_21_Ch4_Bank11
	channel 5, Cry_21_Ch5_Bank11
	channel 7, Cry_21_Ch7_Bank11

Cry_22_Header_Bank11:
	channelcount 3
	channel 4, Cry_22_Ch4_Bank11
	channel 5, Cry_22_Ch5_Bank11
	channel 7, Cry_22_Ch7_Bank11

Cry_23_Header_Bank11:
	channelcount 3
	channel 4, Cry_23_Ch4_Bank11
	channel 5, Cry_23_Ch5_Bank11
	channel 7, Cry_23_Ch7_Bank11

Cry_24_Header_Bank11:
	channelcount 3
	channel 4, Cry_24_Ch4_Bank11
	channel 5, Cry_24_Ch5_Bank11
	channel 7, Cry_24_Ch7_Bank11

Cry_25_Header_Bank11:
	channelcount 3
	channel 4, Cry_25_Ch4_Bank11
	channel 5, Cry_25_Ch5_Bank11
	channel 7, Cry_25_Ch7_Bank11

UnusedCry_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0F, $E0, $80, $07
	soundeffect_note $0F, $F0, $84, $07
	soundeffect_note $0F, $C3, $E0, $05
	soundeffect_note $0F, $C4, $00, $06
	soundeffect_note $0A, $6C, $80, $07
	soundeffect_note $08, $71, $84, $07
	endchannel

UnusedCry_Ch5_Bank11:
	unknownmusic0xde $05
	soundeffect_note $0F, $A0, $41, $07
	soundeffect_note $0F, $B0, $43, $07
	soundeffect_note $0F, $93, $B1, $05
	soundeffect_note $0F, $94, $C1, $05
	soundeffect_note $0A, $4C, $41, $07
	soundeffect_note $08, $31, $46, $07
	endchannel

UnusedCry_Ch7_Bank11:
	soundeffect_percussion $02, $F2, $4C
	soundeffect_percussion $06, $E0, $3A
	soundeffect_percussion $0F, $D0, $3A
	soundeffect_percussion $08, $D0, $2C
	soundeffect_percussion $06, $E6, $4C
	soundeffect_percussion $0C, $7D, $4C
	soundeffect_percussion $0F, $D3, $4C
	endchannel

Cry_09_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0F, $F7, $A0, $07
	soundeffect_note $06, $E6, $A3, $07
	soundeffect_note $0A, $F4, $A0, $07
	unknownmusic0xde $A5
	soundeffect_note $0A, $F6, $D8, $07
	soundeffect_note $04, $E3, $D7, $07
	soundeffect_note $0F, $F2, $D8, $07
	endchannel

Cry_09_Ch5_Bank11:
	unknownmusic0xde $05
	soundeffect_note $02, $08, $00, $00
	soundeffect_note $0F, $A7, $A1, $06
	soundeffect_note $06, $86, $A2, $06
	soundeffect_note $0A, $74, $A1, $06
	unknownmusic0xde $5F
	soundeffect_note $0A, $76, $D6, $06
	soundeffect_note $04, $83, $D9, $06
	soundeffect_note $0F, $A2, $D7, $06
	endchannel

Cry_09_Ch7_Bank11:
	soundeffect_percussion $02, $F2, $3C
	soundeffect_percussion $08, $E4, $3E
	soundeffect_percussion $0F, $D7, $3C
	soundeffect_percussion $06, $C5, $3B
	soundeffect_percussion $06, $E4, $3D
	soundeffect_percussion $08, $B6, $3C
	soundeffect_percussion $06, $D4, $3D
	soundeffect_percussion $08, $C1, $3B
	endchannel

Cry_23_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0F, $F7, $C0, $07
	soundeffect_note $06, $E4, $C1, $07
	soundeffect_note $0A, $F6, $C0, $07
	soundeffect_note $04, $D3, $C2, $07
	soundeffect_note $08, $C1, $C0, $07
	endchannel

Cry_23_Ch5_Bank11:
	unknownmusic0xde $5F
	soundeffect_note $0F, $97, $81, $07
	soundeffect_note $06, $84, $80, $07
	soundeffect_note $0A, $96, $81, $07
	soundeffect_note $0F, $83, $81, $07
	endchannel

Cry_23_Ch7_Bank11:
	soundeffect_percussion $03, $F2, $3C
	soundeffect_percussion $0D, $E6, $2C
	soundeffect_percussion $0F, $D7, $3C
	soundeffect_percussion $08, $C1, $2C
	endchannel

Cry_24_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0F, $F7, $80, $06
	soundeffect_note $0A, $E6, $84, $06
	soundeffect_note $0F, $D7, $90, $06
	soundeffect_note $08, $D5, $90, $06
	soundeffect_note $06, $C4, $88, $06
	soundeffect_note $05, $D3, $70, $06
	soundeffect_note $04, $D3, $60, $06
	soundeffect_note $08, $C1, $40, $06
	endchannel

Cry_24_Ch5_Bank11:
	unknownmusic0xde $05
	soundeffect_note $0F, $B7, $41, $06
	soundeffect_note $0A, $96, $42, $06
	soundeffect_note $0F, $A7, $51, $06
	soundeffect_note $08, $A5, $51, $06
	soundeffect_note $06, $94, $47, $06
	soundeffect_note $05, $A3, $31, $06
	soundeffect_note $04, $93, $22, $06
	soundeffect_note $08, $71, $01, $06
	endchannel

Cry_24_Ch7_Bank11:
	soundeffect_percussion $0F, $E4, $3C
	soundeffect_percussion $0A, $C7, $4C
	soundeffect_percussion $0A, $C7, $3C
	soundeffect_percussion $0C, $B7, $4C
	soundeffect_percussion $0F, $A2, $5C
	endchannel

Cry_11_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $06, $F7, $A0, $07
	soundeffect_note $08, $E6, $A4, $07
	soundeffect_note $04, $D6, $A0, $07
	soundeffect_note $0F, $D3, $20, $07
	soundeffect_note $08, $C3, $23, $07
	soundeffect_note $02, $C2, $28, $07
	soundeffect_note $08, $B1, $30, $07
	endchannel

Cry_11_Ch5_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $04, $08, $00, $00
	soundeffect_note $06, $A7, $41, $07
	soundeffect_note $08, $86, $43, $07
	soundeffect_note $04, $76, $41, $07
	soundeffect_note $0D, $83, $C2, $06
	soundeffect_note $07, $73, $C1, $06
	soundeffect_note $03, $82, $CC, $06
	soundeffect_note $08, $71, $D8, $06
	endchannel

Cry_11_Ch7_Bank11:
	soundeffect_percussion $02, $F2, $4C
	soundeffect_percussion $06, $E6, $3A
	soundeffect_percussion $04, $D7, $3A
	soundeffect_percussion $06, $D6, $2C
	soundeffect_percussion $08, $E5, $3C
	soundeffect_percussion $0C, $D2, $3D
	soundeffect_percussion $08, $D1, $2C
	endchannel

Cry_25_Ch4_Bank11:
	unknownmusic0xde $A5
	soundeffect_note $06, $F4, $40, $07
	soundeffect_note $0F, $E3, $30, $07
	soundeffect_note $04, $F4, $40, $07
	soundeffect_note $05, $B3, $48, $07
	soundeffect_note $08, $D1, $50, $07
	endchannel

Cry_25_Ch5_Bank11:
	unknownmusic0xde $77
	soundeffect_note $06, $C3, $12, $07
	soundeffect_note $0F, $B3, $04, $07
	soundeffect_note $03, $C3, $12, $07
	soundeffect_note $04, $C3, $21, $07
	soundeffect_note $08, $B1, $32, $07
	endchannel

Cry_25_Ch7_Bank11:
	soundeffect_percussion $08, $D6, $2C
	soundeffect_percussion $0C, $C6, $3C
	soundeffect_percussion $0A, $B6, $2C
	soundeffect_percussion $08, $91, $1C
	endchannel

Cry_03_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $04, $F7, $08, $06
	soundeffect_note $06, $E6, $00, $06
	soundeffect_note $06, $D7, $F0, $05
	soundeffect_note $06, $C4, $E0, $05
	soundeffect_note $05, $D3, $C0, $05
	soundeffect_note $04, $D3, $A0, $05
	soundeffect_note $08, $E1, $80, $05
	endchannel

Cry_03_Ch5_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $04, $C7, $04, $05
	soundeffect_note $06, $A6, $02, $05
	soundeffect_note $06, $97, $F1, $04
	soundeffect_note $04, $B4, $E1, $04
	soundeffect_note $05, $A3, $C2, $04
	soundeffect_note $04, $B3, $A3, $04
	soundeffect_note $08, $C1, $82, $04
	endchannel

Cry_03_Ch7_Bank11:
	soundeffect_percussion $0C, $E4, $4C
	soundeffect_percussion $0A, $C7, $5C
	soundeffect_percussion $0C, $B6, $4C
	soundeffect_percussion $0F, $A2, $5C
	endchannel

Cry_0F_Ch4_Bank11:
	unknownmusic0xde $F1
	soundeffect_note $04, $F7, $C0, $07
	soundeffect_note $0C, $E6, $C2, $07
	soundeffect_note $06, $B5, $80, $06
	soundeffect_note $04, $C4, $70, $06
	soundeffect_note $04, $B5, $60, $06
	soundeffect_note $08, $C1, $40, $06
	endchannel

Cry_0F_Ch5_Bank11:
	unknownmusic0xde $CC
	soundeffect_note $03, $C7, $81, $07
	soundeffect_note $0C, $B6, $80, $07
	soundeffect_note $06, $A5, $41, $06
	soundeffect_note $04, $C4, $32, $06
	soundeffect_note $06, $B5, $21, $06
	soundeffect_note $08, $A1, $02, $06
	endchannel

Cry_0F_Ch7_Bank11:
	soundeffect_percussion $03, $E4, $3C
	soundeffect_percussion $0C, $D6, $2C
	soundeffect_percussion $04, $E4, $3C
	soundeffect_percussion $08, $B7, $5C
	soundeffect_percussion $0F, $C2, $5D
	endchannel

Cry_10_Ch4_Bank11:
	unknownmusic0xde $C9
	soundeffect_note $08, $F7, $80, $06
	soundeffect_note $02, $F7, $60, $06
	soundeffect_note $01, $E7, $40, $06
	soundeffect_note $01, $E7, $20, $06
	soundeffect_note $0F, $D1, $00, $06
	soundeffect_note $04, $C7, $40, $07
	soundeffect_note $04, $A7, $30, $07
	soundeffect_note $0F, $91, $20, $07
	endchannel

Cry_10_Ch5_Bank11:
	unknownmusic0xde $79
	soundeffect_note $0A, $E7, $82, $06
	soundeffect_note $02, $E7, $62, $06
	soundeffect_note $01, $D7, $42, $06
	soundeffect_note $01, $D7, $22, $06
	soundeffect_note $0F, $C1, $02, $06
	soundeffect_note $04, $B7, $42, $07
	soundeffect_note $02, $97, $32, $07
	soundeffect_note $0F, $81, $22, $07
	endchannel

Cry_10_Ch7_Bank11:
	soundeffect_percussion $04, $74, $21
	soundeffect_percussion $04, $74, $10
	soundeffect_percussion $04, $71, $20
	endchannel

Cry_00_Ch4_Bank11:
	unknownmusic0xde 245
	soundeffect_note 4, 243, 24, 7
	soundeffect_note 15, 229, 152, 7
	soundeffect_note 8, 145, 88, 7
	endchannel

Cry_00_Ch5_Bank11:
	unknownmusic0xde 160
	soundeffect_note 5, 179, 8, 7
	soundeffect_note 15, 197, 136, 7
	soundeffect_note 8, 113, 72, 7
	endchannel

Cry_00_Ch7_Bank11:
	soundeffect_percussion 3, 161, 28
	soundeffect_percussion 14, 148, 44
	soundeffect_percussion 8, 129, 28
	endchannel

Cry_0E_Ch4_Bank11:
	unknownmusic0xde $A5
	soundeffect_note $04, $E1, $00, $07
	soundeffect_note $04, $F2, $80, $07
	soundeffect_note $02, $92, $40, $07
	soundeffect_note $08, $E1, $00, $06
	endchannel

Cry_0E_Ch5_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $04, $B1, $E1, $06
	soundeffect_note $03, $C2, $E1, $06
	soundeffect_note $03, $62, $81, $06
	soundeffect_note $08, $B1, $E1, $05
	endchannel

Cry_0E_Ch7_Bank11:
	soundeffect_percussion $02, $61, $32
	soundeffect_percussion $02, $61, $21
	soundeffect_percussion $08, $61, $11
	endchannel


Cry_06_Ch4_Bank11:
	unknownmusic0xde $FA
	soundeffect_note $06, $83, $47, $02
	soundeffect_note $0F, $62, $26, $02
	soundeffect_note $04, $52, $45, $02
	soundeffect_note $09, $63, $06, $02
	soundeffect_note $0F, $82, $25, $02
	soundeffect_note $0F, $42, $07, $02
Cry_06_Ch5_Bank11:
	endchannel

Cry_06_Ch7_Bank11:
	soundeffect_percussion $08, $D4, $8C
	soundeffect_percussion $04, $E2, $9C
	soundeffect_percussion $0F, $C6, $8C
	soundeffect_percussion $08, $E4, $AC
	soundeffect_percussion $0F, $D7, $9C
	soundeffect_percussion $0F, $F2, $AC
	endchannel

Cry_07_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $04, $F3, $E0, $06
	soundeffect_note $0F, $E4, $40, $06
	soundeffect_note $08, $C1, $20, $06
	endchannel

Cry_07_Ch5_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $03, $C3, $83, $06
	soundeffect_note $0E, $B4, $02, $06
	soundeffect_note $08, $A1, $01, $06
	endchannel

Cry_07_Ch7_Bank11:
	soundeffect_percussion $04, $D3, $5C
	soundeffect_percussion $0F, $E6, $4C
	soundeffect_percussion $08, $B1, $5C
	endchannel

Cry_05_Ch4_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $06, $E2, $00, $05
	soundeffect_note $06, $E3, $80, $05
	soundeffect_note $06, $D3, $70, $05
	soundeffect_note $08, $A1, $60, $05
	endchannel

Cry_05_Ch5_Bank11:
	unknownmusic0xde $F5
	soundeffect_note $06, $E2, $82, $04
	soundeffect_note $06, $D3, $01, $05
	soundeffect_note $06, $B2, $E2, $04
	soundeffect_note $08, $81, $C1, $04
Cry_05_Ch7_Bank11:
	endchannel

Cry_0B_Ch4_Bank11:
	unknownmusic0xde $CC
	soundeffect_note $04, $F1, $00, $07
	soundeffect_note $04, $E1, $80, $07
	soundeffect_note $04, $D1, $40, $07
	soundeffect_note $04, $E1, $40, $07
	soundeffect_note $04, $F1, $80, $07
	soundeffect_note $04, $D1, $00, $07
	soundeffect_note $04, $F1, $01, $07
	soundeffect_note $04, $D1, $82, $07
	soundeffect_note $04, $C1, $42, $07
	soundeffect_note $08, $B1, $41, $07
	endchannel

Cry_0B_Ch5_Bank11:
	unknownmusic0xde $44
	soundeffect_note $0C, $08, $00, $00
	soundeffect_note $04, $F1, $01, $07
	soundeffect_note $04, $E1, $82, $07
	soundeffect_note $04, $D1, $41, $07
	soundeffect_note $04, $E1, $41, $07
	soundeffect_note $04, $F1, $82, $07
	soundeffect_note $08, $D1, $01, $07
	endchannel

Cry_0B_Ch7_Bank11:
	soundeffect_percussion $0F, $08, $00
	soundeffect_percussion $04, $08, $00
	soundeffect_percussion $04, $D1, $4C
	soundeffect_percussion $04, $B1, $2C
	soundeffect_percussion $04, $D1, $3C
	soundeffect_percussion $04, $B1, $3C
	soundeffect_percussion $04, $C1, $2C
	soundeffect_percussion $08, $A1, $4C
	endchannel

Cry_0C_Ch4_Bank11:
	unknownmusic0xde $CC
	soundeffect_note $08, $F5, $00, $06
	soundeffect_note $02, $D2, $38, $06
	soundeffect_note $02, $C2, $30, $06
	soundeffect_note $02, $C2, $28, $06
	soundeffect_note $02, $B2, $20, $06
	soundeffect_note $02, $B2, $10, $06
	soundeffect_note $02, $A2, $18, $06
	soundeffect_note $02, $B2, $10, $06
	soundeffect_note $08, $C1, $20, $06
	endchannel

Cry_0C_Ch5_Bank11:
	unknownmusic0xde $44
	soundeffect_note $0C, $C3, $C0, $05
	soundeffect_note $03, $B1, $F9, $05
	soundeffect_note $02, $A1, $F1, $05
	soundeffect_note $02, $A1, $E9, $05
	soundeffect_note $02, $91, $E1, $05
	soundeffect_note $02, $91, $D9, $05
	soundeffect_note $02, $81, $D1, $05
	soundeffect_note $02, $91, $D9, $05
	soundeffect_note $08, $91, $E1, $05
Cry_0C_Ch7_Bank11:
	endchannel

Cry_02_Ch4_Bank11:
	unknownmusic0xde $00
	soundeffect_note $08, $F5, $80, $04
	soundeffect_note $02, $E1, $E0, $05
	soundeffect_note $08, $D1, $DC, $05
	endchannel

Cry_02_Ch5_Bank11:
	unknownmusic0xde $A5
	soundeffect_note $07, $95, $41, $04
	soundeffect_note $02, $81, $21, $05
	soundeffect_note $08, $61, $1A, $05
Cry_02_Ch7_Bank11:
	endchannel

Cry_0D_Ch4_Bank11:
	unknownmusic0xde $88
	soundeffect_note $05, $F2, $50, $06
	soundeffect_note $09, $D1, $60, $06
	soundeffect_note $05, $E2, $12, $06
	soundeffect_note $09, $C1, $22, $06
	soundeffect_note $05, $F2, $10, $06
	soundeffect_note $06, $D1, $20, $06
	soundeffect_note $FD, $02, $DB, $77
	endchannel

Cry_0D_Ch5_Bank11:
	unknownmusic0xde $40
	soundeffect_note $04, $08, $00, $00
	soundeffect_note $05, $F2, $51, $06
	soundeffect_note $09, $D1, $61, $06
	soundeffect_note $05, $E2, $14, $06
	soundeffect_note $08, $C1, $24, $06
	soundeffect_note $05, $F2, $11, $06
	soundeffect_note $0C, $D1, $21, $06
	soundeffect_note $05, $E2, $14, $06
	soundeffect_note $08, $C1, $24, $06
	soundeffect_note $05, $F2, $11, $06
	soundeffect_note $04, $D1, $21, $06
	endchannel

Cry_0D_Ch7_Bank11:
	soundeffect_percussion $06, $D2, $1C
	soundeffect_percussion $09, $B1, $2C
	soundeffect_percussion $08, $C2, $2C
	soundeffect_percussion $09, $B1, $3C
	soundeffect_percussion $06, $C2, $2C
	soundeffect_percussion $09, $A2, $3C
	soundeffect_percussion $07, $C2, $2C
	soundeffect_percussion $05, $A1, $3C
	soundeffect_percussion $09, $C2, $2C
	soundeffect_percussion $04, $A1, $3C
	endchannel

Cry_01_Ch4_Bank11:
	unknownmusic0xde $A0
	soundeffect_note $04, $F3, $00, $06
	soundeffect_note $08, $D5, $60, $07
	soundeffect_note $03, $E2, $20, $07
	soundeffect_note $08, $D1, $10, $07
	endchannel

Cry_01_Ch5_Bank11:
	unknownmusic0xde $5A
	soundeffect_note $05, $B3, $F1, $06
	soundeffect_note $07, $C5, $52, $07
	soundeffect_note $03, $A2, $11, $07
	soundeffect_note $08, $B1, $01, $06
	endchannel

Cry_01_Ch7_Bank11:
	soundeffect_percussion $03, $A2, $3C
	soundeffect_percussion $0C, $94, $2C
	soundeffect_percussion $03, $82, $1C
	soundeffect_percussion $08, $71, $2C
	endchannel

Cry_0A_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $08, $F7, $E0, $06
	soundeffect_note $06, $E6, $E5, $06
	soundeffect_note $03, $F4, $E0, $06
	soundeffect_note $03, $F6, $D0, $06
	soundeffect_note $03, $E3, $C0, $06
	soundeffect_note $04, $F2, $B0, $06
	soundeffect_note $0F, $A2, $C8, $06
	endchannel

Cry_0A_Ch5_Bank11:
	unknownmusic0xde $05
	soundeffect_note $03, $08, $00, $00
	soundeffect_note $08, $A7, $A1, $06
	soundeffect_note $06, $86, $A3, $06
	soundeffect_note $03, $74, $A1, $06
	soundeffect_note $03, $76, $91, $06
	soundeffect_note $03, $83, $82, $06
	soundeffect_note $04, $A2, $71, $06
	soundeffect_note $0F, $72, $89, $06
	endchannel

Cry_0A_Ch7_Bank11:
	soundeffect_percussion $02, $F2, $3C
	soundeffect_percussion $08, $E4, $3E
	soundeffect_percussion $08, $D7, $3C
	soundeffect_percussion $05, $C5, $3B
	soundeffect_percussion $03, $D4, $2C
	soundeffect_percussion $02, $B6, $3C
	soundeffect_percussion $03, $A4, $2C
	soundeffect_percussion $08, $91, $3C
	endchannel

Cry_08_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0F, $F6, $65, $05
	soundeffect_note $0A, $E4, $7C, $05
	soundeffect_note $03, $C2, $5C, $05
	soundeffect_note $0F, $B2, $3C, $05
	endchannel

Cry_08_Ch5_Bank11:
	unknownmusic0xde $5A
	soundeffect_note $0E, $D6, $03, $05
	soundeffect_note $09, $B4, $1B, $05
	soundeffect_note $04, $92, $FA, $04
	soundeffect_note $0F, $A2, $DB, $04
	endchannel

Cry_08_Ch7_Bank11:
	soundeffect_percussion $0C, $E6, $4C
	soundeffect_percussion $0B, $D7, $5C
	soundeffect_percussion $0F, $C2, $4C
	endchannel

Cry_04_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $04, $F7, $A0, $06
	soundeffect_note $08, $E6, $A4, $06
	soundeffect_note $04, $D6, $A0, $06
	soundeffect_note $0C, $D3, $20, $06
	soundeffect_note $08, $C3, $24, $06
	soundeffect_note $04, $C2, $20, $06
	soundeffect_note $08, $B1, $10, $06
	endchannel

Cry_04_Ch5_Bank11:
	unknownmusic0xde $5A
	soundeffect_note $04, $E7, $01, $06
	soundeffect_note $08, $D6, $03, $06
	soundeffect_note $04, $C6, $01, $06
	soundeffect_note $0C, $C3, $81, $05
	soundeffect_note $08, $B3, $83, $05
	soundeffect_note $04, $B2, $82, $05
	soundeffect_note $08, $A1, $71, $05
	endchannel

Cry_04_Ch7_Bank11:
	soundeffect_percussion $07, $D6, $5C
	soundeffect_percussion $08, $E6, $4C
	soundeffect_percussion $04, $D4, $5C
	soundeffect_percussion $04, $D4, $4C
	soundeffect_percussion $07, $C3, $4C
	soundeffect_percussion $08, $A1, $5C
	endchannel

Cry_19_Ch4_Bank11:
	unknownmusic0xde $1B
	soundeffect_note $07, $D2, $40, $07
	soundeffect_note $0F, $E5, $60, $07
	soundeffect_note $18, $C1, $30, $07
	endchannel

Cry_19_Ch5_Bank11:
	unknownmusic0xde $81
	soundeffect_note $02, $C2, $01, $07
	soundeffect_note $04, $C2, $08, $07
	soundeffect_note $0F, $D7, $41, $07
	soundeffect_note $18, $A2, $01, $07
Cry_19_Ch7_Bank11:
	endchannel

Cry_16_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0F, $D7, $80, $07
	soundeffect_note $04, $E6, $A0, $07
	soundeffect_note $0F, $D2, $40, $07
	endchannel

Cry_16_Ch5_Bank11:
	unknownmusic0xde $5A
	soundeffect_note $0F, $C7, $53, $07
	soundeffect_note $05, $B6, $72, $07
	soundeffect_note $0F, $C2, $11, $07
	endchannel

Cry_16_Ch7_Bank11:
	soundeffect_percussion $0D, $F6, $4C
	soundeffect_percussion $04, $E6, $3C
	soundeffect_percussion $0F, $F2, $4C
	endchannel

Cry_1B_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $06, $F7, $C0, $06
	soundeffect_note $0F, $E7, $00, $07
	soundeffect_note $04, $F4, $F0, $06
	soundeffect_note $04, $E4, $E0, $06
	soundeffect_note $08, $D1, $D0, $06
	endchannel

Cry_1B_Ch5_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $07, $E6, $81, $06
	soundeffect_note $0E, $D5, $C1, $06
	soundeffect_note $04, $C4, $B1, $06
	soundeffect_note $04, $D4, $A1, $06
	soundeffect_note $08, $C1, $91, $06
	endchannel

Cry_1B_Ch7_Bank11:
	soundeffect_percussion $0A, $A6, $3C
	soundeffect_percussion $0E, $94, $2C
	soundeffect_percussion $05, $A3, $3C
	soundeffect_percussion $08, $91, $2C
	endchannel

Cry_12_Ch4_Bank11:
	unknownmusic0xde $A5
	soundeffect_note $0C, $F2, $40, $04
	soundeffect_note $0F, $E3, $A0, $04
	soundeffect_note $04, $D2, $90, $04
	soundeffect_note $08, $D1, $80, $04
	endchannel

Cry_12_Ch5_Bank11:
	unknownmusic0xde $EE
	soundeffect_note $0B, $D2, $38, $04
	soundeffect_note $0E, $C6, $98, $04
	soundeffect_note $03, $B2, $88, $04
	soundeffect_note $08, $B1, $78, $04
	endchannel

Cry_12_Ch7_Bank11:
	soundeffect_percussion $0A, $E6, $6C
	soundeffect_percussion $0F, $D2, $5C
	soundeffect_percussion $03, $C2, $6C
	soundeffect_percussion $08, $D1, $5C
	endchannel

Cry_13_Ch4_Bank11:
	unknownmusic0xde $33
	soundeffect_note $0F, $F6, $C0, $05
	soundeffect_note $08, $E3, $BC, $05
	soundeffect_note $06, $D2, $D0, $05
	soundeffect_note $06, $B2, $E0, $05
	soundeffect_note $06, $C2, $F0, $05
	soundeffect_note $08, $B1, $00, $06
	endchannel

Cry_13_Ch5_Bank11:
	unknownmusic0xde $99
	soundeffect_note $0E, $C6, $B1, $04
	soundeffect_note $07, $C3, $AD, $04
	soundeffect_note $05, $B2, $C1, $04
	soundeffect_note $08, $92, $D1, $04
	soundeffect_note $06, $A2, $E1, $04
	soundeffect_note $08, $91, $F1, $04
	endchannel

Cry_13_Ch7_Bank11:
	soundeffect_percussion $0A, $E6, $5C
	soundeffect_percussion $0A, $D6, $6C
	soundeffect_percussion $04, $C2, $4C
	soundeffect_percussion $06, $D3, $5C
	soundeffect_percussion $08, $B3, $4C
	soundeffect_percussion $08, $A1, $5C
	endchannel

Cry_14_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $08, $E4, $90, $07
	soundeffect_note $0F, $F5, $C0, $07
	soundeffect_note $08, $D1, $D8, $07
	endchannel

Cry_14_Ch5_Bank11:
	unknownmusic0xde $A5
	soundeffect_note $0A, $C4, $71, $07
	soundeffect_note $0F, $B6, $A2, $07
	soundeffect_note $08, $A1, $B7, $07
	endchannel

Cry_14_Ch7_Bank11:
	soundeffect_percussion $08, $E4, $4C
	soundeffect_percussion $0E, $C4, $3C
	soundeffect_percussion $08, $D1, $2C
	endchannel

Cry_1E_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $06, $F2, $00, $06
	soundeffect_note $06, $E2, $40, $06
	soundeffect_note $06, $D2, $80, $06
	soundeffect_note $06, $E2, $C0, $06
	soundeffect_note $06, $D2, $00, $07
	soundeffect_note $06, $C2, $40, $07
	soundeffect_note $06, $B2, $80, $07
	soundeffect_note $08, $A1, $C0, $07
	endchannel

Cry_1E_Ch5_Bank11:
	unknownmusic0xde $11
	soundeffect_note $03, $08, $01, $00
	soundeffect_note $06, $C2, $C1, $05
	soundeffect_note $06, $B2, $02, $06
	soundeffect_note $06, $A2, $41, $06
	soundeffect_note $06, $B2, $82, $06
	soundeffect_note $06, $A2, $C2, $06
	soundeffect_note $06, $92, $01, $07
	soundeffect_note $06, $A2, $42, $07
	soundeffect_note $08, $81, $81, $07
	endchannel

Cry_1E_Ch7_Bank11:
	soundeffect_percussion $06, $08, $01
	soundeffect_percussion $05, $E2, $5C
	soundeffect_percussion $05, $C2, $4C
	soundeffect_percussion $05, $D2, $3C
	soundeffect_percussion $05, $B2, $2C
	soundeffect_percussion $05, $C2, $1C
	soundeffect_percussion $05, $A2, $1B
	soundeffect_percussion $05, $92, $1A
	soundeffect_percussion $08, $81, $18
	endchannel

Cry_15_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $04, $F3, $80, $07
	soundeffect_note $0F, $E7, $00, $07
	soundeffect_note $08, $D3, $10, $07
	soundeffect_note $04, $C2, $00, $07
	soundeffect_note $04, $D2, $F0, $06
	soundeffect_note $08, $C1, $E0, $06
	endchannel

Cry_15_Ch5_Bank11:
	unknownmusic0xde $5A
	soundeffect_note $06, $C3, $01, $07
	soundeffect_note $0E, $B7, $81, $06
	soundeffect_note $07, $B3, $92, $06
	soundeffect_note $03, $A2, $81, $06
	soundeffect_note $04, $B2, $72, $06
	soundeffect_note $08, $A1, $61, $06
	endchannel

Cry_15_Ch7_Bank11:
	soundeffect_percussion $06, $E3, $5C
	soundeffect_percussion $0E, $D6, $4C
	soundeffect_percussion $06, $C6, $3C
	soundeffect_percussion $03, $B3, $4C
	soundeffect_percussion $03, $A2, $5C
	soundeffect_percussion $08, $B1, $6C
	endchannel

Cry_17_Ch4_Bank11:
	unknownmusic0xde $0F
	soundeffect_note $0F, $F7, $00, $05
	soundeffect_note $0F, $E7, $08, $05
	soundeffect_note $08, $B4, $80, $04
	soundeffect_note $0F, $A2, $60, $04
	endchannel

Cry_17_Ch5_Bank11:
	unknownmusic0xde $44
	soundeffect_note $0E, $D7, $81, $04
	soundeffect_note $0E, $C7, $89, $04
	soundeffect_note $0A, $B4, $01, $04
	soundeffect_note $0F, $C2, $E1, $03
	endchannel

Cry_17_Ch7_Bank11:
	soundeffect_percussion $0E, $F7, $7C
	soundeffect_percussion $0C, $F6, $6C
	soundeffect_percussion $09, $E4, $7C
	soundeffect_percussion $0F, $E2, $6C
	endchannel

Cry_1C_Ch4_Bank11:
	unknownmusic0xde $F5
	soundeffect_note $07, $D6, $E1, $07
	soundeffect_note $06, $C6, $E2, $07
	soundeffect_note $09, $D6, $E1, $07
	soundeffect_note $07, $C6, $E0, $07
	soundeffect_note $05, $B6, $E2, $07
	soundeffect_note $07, $C6, $E1, $07
	soundeffect_note $06, $B6, $E0, $07
	soundeffect_note $08, $A1, $DF, $07
	endchannel

Cry_1C_Ch5_Bank11:
	unknownmusic0xde $44
	soundeffect_note $06, $C3, $C9, $07
	soundeffect_note $06, $B3, $C7, $07
	soundeffect_note $0A, $C4, $C3, $07
	soundeffect_note $08, $B4, $C7, $07
	soundeffect_note $06, $C3, $C9, $07
	soundeffect_note $0F, $A2, $C5, $07
	endchannel

Cry_1C_Ch7_Bank11:
	soundeffect_percussion $0D, $19, $7C
	soundeffect_percussion $0D, $F7, $8C
	soundeffect_percussion $0C, $D6, $7C
	soundeffect_percussion $08, $C4, $6C
	soundeffect_percussion $0F, $B3, $5C
	endchannel

Cry_1A_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $06, $F7, $40, $07
	soundeffect_note $0C, $E6, $44, $07
	soundeffect_note $06, $D5, $50, $07
	soundeffect_note $04, $C3, $60, $07
	soundeffect_note $03, $C3, $80, $07
	soundeffect_note $08, $D1, $A0, $07
	endchannel

Cry_1A_Ch5_Bank11:
	unknownmusic0xde $0A
	soundeffect_note $06, $C7, $01, $07
	soundeffect_note $0B, $B6, $02, $07
	soundeffect_note $06, $A5, $11, $07
	soundeffect_note $04, $93, $21, $07
	soundeffect_note $03, $A3, $41, $07
	soundeffect_note $08, $91, $62, $07
	endchannel

Cry_1A_Ch7_Bank11:
	soundeffect_percussion $03, $E2, $3C
	soundeffect_percussion $08, $D6, $4C
	soundeffect_percussion $05, $D4, $3C
	soundeffect_percussion $0C, $C7, $4C
	soundeffect_percussion $02, $E2, $3C
	soundeffect_percussion $08, $D1, $2C
	endchannel

Cry_1D_Ch4_Bank11:
	unknownmusic0xde $F4
	soundeffect_note $0F, $F0, $05, $07
	soundeffect_note $0A, $E0, $00, $07
	soundeffect_note $06, $B4, $10, $07
	soundeffect_note $04, $D3, $00, $07
	soundeffect_note $06, $B2, $20, $06
	soundeffect_note $08, $A1, $24, $06
	endchannel

Cry_1D_Ch5_Bank11:
	unknownmusic0xde $22
	soundeffect_note $0F, $B0, $C3, $06
	soundeffect_note $0A, $A0, $C1, $06
	soundeffect_note $06, $84, $D2, $06
	soundeffect_note $04, $93, $C1, $06
	soundeffect_note $06, $82, $E1, $05
	soundeffect_note $08, $61, $E8, $05
	endchannel

Cry_1D_Ch7_Bank11:
	soundeffect_percussion $06, $E6, $4C
	soundeffect_percussion $0F, $D6, $3C
	soundeffect_percussion $0A, $C5, $4A
	soundeffect_percussion $01, $B2, $5B
	soundeffect_percussion $0F, $C2, $4C
	endchannel

Cry_18_Ch4_Bank11:
	unknownmusic0xde $50
	soundeffect_note $0A, $F5, $80, $06
	soundeffect_note $03, $E2, $A0, $06
	soundeffect_note $03, $F2, $C0, $06
	soundeffect_note $03, $E2, $E0, $06
	soundeffect_note $03, $D2, $00, $07
	soundeffect_note $03, $C2, $E0, $06
	soundeffect_note $03, $D2, $C0, $06
	soundeffect_note $08, $C1, $A0, $06
	endchannel

Cry_18_Ch5_Bank11:
	unknownmusic0xde $0F
	soundeffect_note $09, $D5, $31, $06
	soundeffect_note $03, $D2, $52, $06
	soundeffect_note $03, $E2, $71, $06
	soundeffect_note $03, $B2, $91, $06
	soundeffect_note $03, $C2, $B2, $06
	soundeffect_note $03, $B2, $91, $06
	soundeffect_note $03, $C2, $71, $06
	soundeffect_note $08, $B1, $51, $06
	endchannel

Cry_18_Ch7_Bank11:
	soundeffect_percussion $06, $E3, $4C
	soundeffect_percussion $04, $C3, $3C
	soundeffect_percussion $05, $D4, $3C
	soundeffect_percussion $04, $C4, $2C
	soundeffect_percussion $06, $B4, $3C
	soundeffect_percussion $08, $C1, $2C
	endchannel

Cry_1F_Ch4_Bank11:
	unknownmusic0xde $A5
	soundeffect_note $03, $F4, $41, $06
	soundeffect_note $0D, $D6, $21, $07
	soundeffect_note $08, $F4, $19, $07
	soundeffect_note $08, $C1, $1A, $07
	endchannel

Cry_1F_Ch5_Bank11:
	unknownmusic0xde $CC
	soundeffect_note $04, $F4, $80, $05
	soundeffect_note $0E, $E6, $E0, $06
	soundeffect_note $08, $D5, $D8, $06
	soundeffect_note $08, $D1, $DC, $06
	endchannel

Cry_1F_Ch7_Bank11:
	soundeffect_percussion $05, $C4, $46
	soundeffect_percussion $0D, $A5, $44
	soundeffect_percussion $08, $C4, $45
	soundeffect_percussion $08, $B1, $44
	endchannel

Cry_20_Ch4_Bank11:
	unknownmusic0xde $F0
	soundeffect_note $0D, $F1, $11, $05
	soundeffect_note $0D, $E1, $15, $05
	soundeffect_note $0D, $E1, $11, $05
	soundeffect_note $08, $D1, $11, $05
	endchannel

Cry_20_Ch5_Bank11:
	unknownmusic0xde $15
	soundeffect_note $0C, $E1, $0C, $05
	soundeffect_note $0C, $D1, $10, $05
	soundeffect_note $0E, $C1, $0C, $05
	soundeffect_note $08, $C1, $0A, $05
	endchannel

Cry_20_Ch7_Bank11:
	soundeffect_percussion $0E, $F2, $65
	soundeffect_percussion $0D, $E2, $55
	soundeffect_percussion $0E, $D2, $56
	soundeffect_percussion $08, $D1, $66
	endchannel

Cry_21_Ch4_Bank11:
	unknownmusic0xde $1B
	soundeffect_note $03, $F3, $64, $05
	soundeffect_note $02, $E2, $44, $05
	soundeffect_note $05, $D1, $22, $05
	soundeffect_note $02, $B2, $84, $04
	soundeffect_note $08, $D1, $A2, $04
	soundeffect_note $03, $F3, $24, $05
	soundeffect_note $04, $E4, $E4, $04
	soundeffect_note $08, $D1, $02, $05
	endchannel

Cry_21_Ch5_Bank11:
	unknownmusic0xde $CC
	soundeffect_note $03, $D3, $60, $05
	soundeffect_note $02, $C2, $40, $05
	soundeffect_note $05, $C1, $20, $05
	soundeffect_note $02, $92, $80, $04
	soundeffect_note $08, $C1, $A0, $04
	soundeffect_note $03, $D3, $20, $05
	soundeffect_note $03, $C4, $E0, $04
	soundeffect_note $08, $C1, $00, $05
Cry_21_Ch7_Bank11:
	endchannel

Cry_22_Ch4_Bank11:
	unknownmusic0xde $11
	soundeffect_note $02, $3D, $81, $03
	soundeffect_note $07, $F5, $01, $06
	soundeffect_note $01, $C2, $81, $04
	soundeffect_note $08, $91, $81, $03
	endchannel

Cry_22_Ch5_Bank11:
	unknownmusic0xde $EE
	soundeffect_note $02, $3E, $B0, $05
	soundeffect_note $07, $D5, $5D, $07
	soundeffect_note $01, $B2, $B0, $06
	soundeffect_note $08, $61, $B0, $05
	endchannel

Cry_22_Ch7_Bank11:
	soundeffect_percussion $02, $92, $49
	soundeffect_percussion $07, $B5, $29
	soundeffect_percussion $01, $A2, $39
	soundeffect_percussion $08, $91, $49
	endchannel
