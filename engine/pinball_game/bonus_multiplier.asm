IncrementBonusMultiplierFromFieldEvent: ; 0x30164
; Increments the bonus multiplier count received from game object actions.
; This is a separate counter than hitting the bonus multiplier railings.
; I guess they wanted hitting the bonus multiplier railings to be the primary
; way of racking up the End-of-Ball Bonus Multiplier.
	ld a, [wCurBonusMultiplierFromFieldEvents]
	inc a
	cp MAX_BONUS_MULTIPLIER_FIELD_EVENTS
	jr z, .maxed
	ld [wCurBonusMultiplierFromFieldEvents], a
	ld a, $1
	ld [wd4ca], a
	ret

.maxed
	ld bc, TenMillionPoints
	callba AddBigBCD6FromQueue
	ld a, $2
	ld [wd4ca], a
	ret
