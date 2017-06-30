Func_1804a: ; 0x1804a
; Unused -- Init ball routine for unused stage.
	ld a, $0
	ld [wBallXPos], a
	ld a, $b0
	ld [wBallXPos + 1], a
	ld a, $0
	ld [wBallYPos], a
	ld a, $98
	ld [wBallYPos + 1], a
	ret
