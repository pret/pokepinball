
ReadJoypad: ; 0xab8
; Reads the current state of the joypad and saves the state into
; some registers the game uses during gameplay. It remembers the joypad state
; from the current frame, previous frame, and two frames ago.
	ld a, $20
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	and $f
	swap a
	ld b, a
	ld a, $30
	ld [rJOYP], a
	ld a, $10
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	and $f
	or b
	cpl  ; a contains currently-pressed buttons
	ldh [hJoypadState], a
	ld a, $30
	ld [rJOYP], a
	ldh a, [hJoypadState]
	ld hl, hPreviousJoypadState
	xor [hl]  ; a contains buttons that are different from previous frame
	push af
	ld hl, hJoypadState
	and [hl]  ; a contains newly-pressed buttons compared to last frame
	ldh [hNewlyPressedButtons], a
	ldh [hPressedButtons], a
	pop af
	ld hl, hPreviousJoypadState
	and [hl]  ; a contains newly-pressed buttons compared to two frames ago
	ldh [hPrevPreviousJoypadState], a
	ldh a, [hJoypadState]
	and a
	jr z, .asm_b15
	ld hl, hPreviousJoypadState
	cp [hl]
	jr nz, .asm_b15
	; button(s) is pressed, and they're identical to the buttons pressed last frame.
	; this code is related to holding down a button for an extended period of time.
	ld hl, hJoyRepeatDelay
	dec [hl]
	jr nz, .asm_b1a
	ldh a, [hJoypadState]
	ldh [hPressedButtons], a
	ld a, [wd807]
	ldh [hJoyRepeatDelay], a
	jr .asm_b1a

.asm_b15
	ld a, [wd806]
	ldh [hJoyRepeatDelay], a
.asm_b1a
	ldh a, [hJoypadState]
	ldh [hPreviousJoypadState], a
	ld hl, wJoypadStatesPersistent
	ldh a, [hJoypadState]
	or [hl]
	ld [hli], a
	ldh a, [hNewlyPressedButtons]
	or [hl]
	ld [hli], a
	ldh a, [hPressedButtons]
	or [hl]
	ld [hli], a
	ret

ClearPersistentJoypadStates: ; 0xb2e
	ld hl, wJoypadStatesPersistent
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

IsKeyPressed2: ; 0xb36
	ldh a, [hJoypadState]
	and [hl]
	jr z, .asm_b3e
	cp [hl]
	jr z, .asm_b48
.asm_b3e
	inc hl
	ldh a, [hJoypadState]
	and [hl]
	ret z
	cp [hl]
	jr z, .asm_b48
	xor a
	ret

.asm_b48
	ld a, $1
	and a
	ret

IsKeyPressed: ; 0xb4c
; Checks if a key for the specified key config is pressed.
; input:   hl = pointer to key config byte pair (e.g. wKeyConfigLeftFlipper)
; output:  zero flag is set if a corresponding key is pressed
;          zero flag is reset if no corresponding key is pressed
	ldh a, [hJoypadState]
	and [hl]
	jr z, .asm_b58
	cp [hl]
	jr nz, .asm_b58
	ldh a, [hNewlyPressedButtons]
	and [hl]
	ret nz
.asm_b58
	inc hl
	ldh a, [hJoypadState]
	and [hl]
	ret z
	cp [hl]
	jr nz, .asm_b64
	ldh a, [hNewlyPressedButtons]
	and [hl]
	ret

.asm_b64
	xor a
	ret
