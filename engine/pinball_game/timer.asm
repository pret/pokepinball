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
	ld [wTimeRanOut], a
	ld [wPauseTimer], a
	ld a, $1
	ld [wTimerActive], a
	ld a, $1
	ld [wd580], a
	callba LoadTimerGraphics
	ret

DecrementTimer: ; 0x86a4
	ld a, [wPauseTimer] ;quit unless ??? is 0
	and a
	ret nz
	ld a, [wTimerFrames]
	inc a
	cp 60
	jr c, .IfSecondHasNotPassed ;if frames +1 >= 60, reset it
	xor a
.IfSecondHasNotPassed
	ld [wTimerFrames], a ;inc frames
	ret c ;done if there was no reset
	ld hl, wTimerMinutes
	ld a, [hld]
	or [hl]
	jr nz, .IfTimeLeft ;if minutes or seconds is non-zero, jump, else ret marking that time ran out
	ld a, $1
	ld [wTimeRanOut], a
	ret

.IfTimeLeft
	ld a, [hl]
	sub $1
	daa ;take 1 from seconds
	jr nc, .IfMinuteHasNotPassed ; if < 0, set to 59
	ld a, $59
.IfMinuteHasNotPassed
	ld [hli], a
	ld a, [hl]
	sbc $0 ;sub minutes by 1 only if carry is set from the seconds sub
	daa
	ld [hl], a
	ret

StopTimer: ; 0x86d2
	xor a
	ld [wTimerActive], a
	ret
