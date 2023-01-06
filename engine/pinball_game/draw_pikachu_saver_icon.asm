DrawPikachuSaverLightningBoltIcon: ; 0xdcb4
; Draws the lightning bolt icon when Pikachu saver has been fully charged.
; The ligntning bolt is drawn in the score bar at the bottom of the screen.
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	ld a, $81
	jr nz, .drawIcon
	ld a, $84
.drawIcon
	ld [wBottomMessageBuffer + $46], a
	ret
