HandleBallLoss: ; 0xdc49
	ld a, [wCurrentStage]
	rst JumpTable  ; calls JumpToFuncInTable
CallTable_dc4d: ; 0xdc4d
	; STAGE_RED_FIELD_TOP
	dw HandleBallLossRedField
	; STAGE_RED_FIELD_BOTTOM
	dw HandleBallLossRedField
	dw Func_de4e
	dw Func_de4e
	; STAGE_BLUE_FIELD_TOP
	dw HandleBallLossBlueField
	; STAGE_BLUE_FIELD_TOP
	dw HandleBallLossBlueField
	; STAGE_GENGAR_BONUS
	dw HandleBallLossGengarBonus
	; STAGE_GENGAR_BONUS
	dw HandleBallLossGengarBonus
	; STAGE_MEWTWO_BONUS
	dw HandleBallLossMewtwoBonus
	; STAGE_MEWTWO_BONUS
	dw HandleBallLossMewtwoBonus
	; STAGE_MEOWTH_BONUS
	dw HandleBallLossMeowthBonus
	; STAGE_MEOWTH_BONUS
	dw HandleBallLossMeowthBonus
	; STAGE_DIGLETT_BONUS
	dw HandleBallLossDiglettBonus
	; STAGE_DIGLETT_BONUS
	dw HandleBallLossDiglettBonus
	; STAGE_SEEL_BONUS
	dw HandleBallLossSeelBonus
	; STAGE_SEEL_BONUS
	dw HandleBallLossSeelBonus

ShowBallLossText: ; 0xdc6d
; Input: de = pointer to scrolling text header
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wScrollingText3
	pop de
	call LoadScrollingText
	ret
