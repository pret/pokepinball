; This file contains functions to handle adding and retrieving BCD (binary coded decimal) values.

Func_3500:
	ld hl, wScoreToAdd
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
	ld bc, wScoreToAdd
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

AddBCDEToCurBufferValue: ; 0x351c
	ld hl, wScoreToAdd
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
	ld bc, wScoreToAdd
	callba AddBigBCD6FromQueue
	ret

AddBCDEToJackpot: ; 0x3538
; Add BCD value bcde to [wCurrentJackpot].  Cap at $99999999.
	ld hl, wCurrentJackpot
	ld a, [hl]
	add e
	daa
	ld [hli], a
	ld a, [hl]
	adc d
	daa
	ld [hli], a
	ld a, [hl]
	adc c
	daa
	ld [hli], a
	ld a, [hl]
	adc b
	daa
	ld [hli], a
	ret nc
	ld hl, wCurrentJackpot
	ld a, $99
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

RetrieveJackpot: ; 0x3556
; Retrieves a 4-byte BCD value at wCurrentJackpot
	ld a, [wCurrentJackpot]
	ld e, a
	ld a, [wCurrentJackpot + 1]
	ld d, a
	ld a, [wCurrentJackpot + 2]
	ld c, a
	ld a, [wCurrentJackpot + 3]
	ld b, a
	ret

Func_3567:
; BCD add bc to hl
	ld a, l
	add c
	daa
	ld l, a
	ld a, h
	adc b
	daa
	ld h, a
	ret

Func_3570:
; BCD add de to hl
	ld a, l
	add e
	daa
	ld l, a
	ld a, h
	adc d
	daa
	ld h, a
	ret

Func_3579: ; 0x3579
; Delete 4-byte BCD value at wCurrentJackpot
	ld hl, wCurrentJackpot
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret
