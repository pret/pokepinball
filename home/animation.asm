InitAnimation: ; 0x28a0
; Initializes an OAM animation.
; hl = pointer to first frame of animation
; de = pointer to destination animation struct
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	xor a
	ld [de], a
	ret

UpdateAnimation: ; 0x28a9
; Updates an animation struct.  (See wDugtrioAnimationFrameCounter)
; Input:  de = pointer to 3-byte animation struct
;         hl = pointer to animation frames data
; Sets carry flag if the animation is over.
	ld a, [de]
	and a
	ret z  ; return, if counter is zero
	dec a
	ld [de], a
	ret nz  ; return if counter is not zero after the decrement
	push de
	inc de
	inc de
	ld a, [de]  ; a = current frame index
	inc a
	ld [de], a
	ld c, a
	ld b, $0
	sla c
	rl b
	add hl, bc  ; hl = pointer to two-byte entry in the frames data table
	ld a, [hli]
	pop de
	and a
	scf
	ret z  ; return if the next entry is $00
	push de
	ld [de], a  ; save the animation duration
	inc de
	ld a, [hli]
	ld [de], a  ; save the next animation frame id
	pop de
	ret
