_LoadStageData: ; 0x8471
; Loads stage data such as additional graphics, collision attributes, etc.
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_8477: ; 0x8477
	padded_dab _LoadStageDataRedFieldTop     ; STAGE_RED_FIELD_TOP
	padded_dab _LoadStageDataRedFieldBottom  ; STAGE_RED_FIELD_BOTTOM
	padded_dab DoNothing_1805f
	padded_dab DoNothing_18060
	padded_dab _LoadStageDataBlueFieldTop    ; STAGE_BLUE_FIELD_TOP
	padded_dab _LoadStageDataBlueFieldBottom ; STAGE_BLUE_FIELD_BOTTOM
	padded_dab _LoadStageDataGengarBonus     ; STAGE_GENGAR_BONUS
	padded_dab _LoadStageDataGengarBonus     ; STAGE_GENGAR_BONUS
	padded_dab _LoadStageDataMewtwoBonus     ; STAGE_MEWTWO_BONUS
	padded_dab _LoadStageDataMewtwoBonus     ; STAGE_MEWTWO_BONUS
	padded_dab _LoadStageDataMeowthBonus     ; STAGE_MEOWTH_BONUS
	padded_dab _LoadStageDataMeowthBonus     ; STAGE_MEOWTH_BONUS
	padded_dab _LoadStageDataDiglettBonus    ; STAGE_DIGLETT_BONUS
	padded_dab _LoadStageDataDiglettBonus    ; STAGE_DIGLETT_BONUS
	padded_dab _LoadStageDataSeelBonus       ; STAGE_SEEL_BONUS
	padded_dab _LoadStageDataSeelBonus       ; STAGE_SEEL_BONUS
