StartTimer: ; 0x867d
; Starts the timer that counts down with the specified starting time when things
; like CatchEm Mode start.
; input:  b = minutes
;         c = seconds
	ld a, c
	ld [wTimerSeconds], a
	ld a, b
	ld [wTimerMinutes], a
	xor a
	ld [wTimerFrames], a
	ld [wd57e], a
	ld [wd57f], a
	ld a, $1
	ld [wTimerActive], a
	ld a, $1
	ld [wd580], a
	callba LoadTimerGraphics
	ret

Func_86a4: ; 0x86a4
	ld a, [wd57f]
	and a
	ret nz
	ld a, [wTimerFrames]
	inc a
	cp $3c
	jr c, .asm_86b2
	xor a
.asm_86b2
	ld [wTimerFrames], a
	ret c
	ld hl, wTimerMinutes
	ld a, [hld]
	or [hl]
	jr nz, .asm_86c3
	ld a, $1
	ld [wd57e], a
	ret

.asm_86c3
	ld a, [hl]
	sub $1
	daa
	jr nc, .asm_86cb
	ld a, $59
.asm_86cb
	ld [hli], a
	ld a, [hl]
	sbc $0
	daa
	ld [hl], a
	ret

StopTimer: ; 0x86d2
	xor a
	ld [wTimerActive], a
	ret
