IncrementBonusMultiplier: ; 0x30164
	ld a, [wCurBonusMultiplier]
	inc a
	cp MAX_BONUS_MULTIPLIER
	jr z, .maxed
	ld [wCurBonusMultiplier], a
	ld a, $1
	ld [wd4ca], a
	ret

.maxed
	ld bc, TenMillionPoints
	callba AddBigBCD6FromQueue
	ld a, $2
	ld [wd4ca], a
	ret
