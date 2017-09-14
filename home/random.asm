GenRandom: ; 0x959
	push bc
	push de
	push hl
	ld a, [wRNGPointer]
	ld c, a
	ld b, $0 ;load ??? into c
	inc a
	cp 54 + 1 ;inc ???, if ??? is 55 do alot of subtraction and make ??? 0
	jr nz, .asm_96e
	call UpdateRNG
	xor a
	ld bc, $0000
.asm_96e
	ld [wRNGPointer], a ;place wRNGPointer + 1 back in
	ld hl, wRNGValues ;choose number generated based on wRNGPointer and all the subtraction
	add hl, bc
	ld a, [hl]
	pop hl
	pop de
	pop bc
	ret

ResetRNG: ; 0x97a
	ld a, [wRNGModulus]
	ld d, a
	ld a, $0 ; wasted instruction (debug that was never commented out?)
	; [wRNGSub] = [sRNGMod] % [wRNGModulus]
	ld a, [sRNGMod]
.modulo
	cp d
	jr c, .okay
	sub d
	jr .modulo

.okay
	ld [wRNGSub], a
	ld [wRNGSub2], a
	ld e, $1
	ld hl, .Data
	ld a, 54
.copy_prng
	push af
	ld c, [hl]
	inc hl
	ld b, $0
	push hl
	ld hl, wRNGValues
	add hl, bc
	ld [hl], e
	ld a, [wRNGSub]
	sub e
	jr nc, .next
	add d
.next
	ld e, a
	ld a, [hl]
	ld [wRNGSub], a
	pop hl
	pop af
	dec a
	jr nz, .copy_prng
	call UpdateRNG
	call UpdateRNG
	call UpdateRNG
	ld a, $0 ; wasted instruction (debug that was never commented out?)
	call GenRandom
	ld [sRNGMod], a
	ret

.Data
; offsets from wRNGValues
	db $14, $29, $07, $1c, $31, $0f, $24, $02, $17
	db $2c, $0a, $1f, $34, $12, $27, $05, $1a, $2f
	db $0d, $22, $00, $15, $2a, $08, $1d, $32, $10
	db $25, $03, $18, $2d, $0b, $20, $35, $13, $28
	db $06, $1b, $30, $0e, $23, $01, $16, $2b, $09
	db $1e, $33, $11, $26, $04, $19, $2e, $0c, $21

UpdateRNG: ; 0x9fa
; Adjusts two RNG values using wRNGModulus
	ld a, [wRNGModulus]
	ld d, a
 ; [d812] = ([d812] - 24 * [d831]) % [d810]
	ld bc, wRNGValues
	ld hl, wRNGValues + $1f
	ld e, $18
.loop
	ld a, [bc]
	sub [hl]
	jr nc, .no_carry
	add d
.no_carry
	ld [bc], a
	dec e
	jr nz, .loop
 ; [d82a] = ([d82a] - 31 * [d812]) % [d810]
	ld bc, wRNGValues + $18 ; d82a
	ld hl, wRNGValues
	ld e, $1f
.loop2
	ld a, [bc]
	sub [hl]
	jr nc, .no_carry2
	add d
.no_carry2
	ld [bc], a
	dec e
	jr nz, .loop2
	ret

RandomRange: ; 0xa21
; Random value 0 <= x < a
	push bc
	push hl
	ld c, a
	ld b, $0
	ld hl, EvensAndOdds
	add hl, bc
	ld l, [hl]
	call GenRandom
	call MultiplyAbyL_AncientEgyptian
	inc h
	srl h
	ld a, h
	pop hl
	pop bc
	ret

EvensAndOdds:
; The first 128 bytes are the first 128 even numbers starting at 0.
; The next 128 bytes are the first 128 odd numbers starting at 1.
; The (a)th element is essentially what you'd get from rlca.
x = 0
REPT 128
	db x | ((x >> 7) & 1)
x = x + 2
ENDR
