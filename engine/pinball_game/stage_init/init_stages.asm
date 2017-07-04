InitializeCurrentStage: ; 0x8311
	ld hl, wc000
	ld bc, $0a00
	call ClearData
	ld a, $1
	ld [rVBK], a
	ld a, [wd805]
	and a
	jr nz, .asm_8331
	ld hl, vBGWin
	ld bc, $0400
	ld a, $0
	call Func_63e
	jr .asm_833c

.asm_8331
	ld hl, vBGWin
	ld bc, $0400
	ld a, $8
	call Func_63e
.asm_833c
	xor a
	ld [rVBK], a
	call ResetDataForStageInitialization
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_8348: ; 0x8348
	padded_dab InitRedField          ; STAGE_RED_FIELD_TOP
	padded_dab InitRedField          ; STAGE_RED_FIELD_BOTTOM
	padded_dab Func_18000
	padded_dab Func_18000
	padded_dab InitBlueField         ; STAGE_BLUE_FIELD_TOP
	padded_dab InitBlueField         ; STAGE_BLUE_FIELD_BOTTOM
	padded_dab InitGengarBonusStage  ; STAGE_GENGAR_BONUS
	padded_dab InitGengarBonusStage  ; STAGE_GENGAR_BONUS
	padded_dab InitMewtwoBonusStage  ; STAGE_MEWTWO_BONUS
	padded_dab InitMewtwoBonusStage  ; STAGE_MEWTWO_BONUS
	padded_dab InitMeowthBonusStage  ; STAGE_MEOWTH_BONUS
	padded_dab InitMeowthBonusStage  ; STAGE_MEOWTH_BONUS
	padded_dab InitDiglettBonusStage ; STAGE_DIGLETT_BONUS
	padded_dab InitDiglettBonusStage ; STAGE_DIGLETT_BONUS
	padded_dab InitSeelBonusStage    ; STAGE_SEEL_BONUS
	padded_dab InitSeelBonusStage    ; STAGE_SEEL_BONUS

ResetDataForStageInitialization: ; 0x8388
; Resets some game data, depending on which stage is being initialized.
	ld a, [wd7c1]
	and a
	jr z, .asm_8398
	ld hl, wSubTileBallXPos
	ld bc, $0037
	call ClearData
	ret
.asm_8398
	ld a, [wCurrentStage]
	cp STAGE_BLUE_FIELD_BOTTOM + 1
	ret nc  ; Check if bonus stage
	ld hl, wPartyMons
	ld bc, $0170
	call ClearData
	ld hl, wHighScoreId
	ld bc, $0039
	call ClearData
	ld hl, wd4ad
	ld bc, $034d
	call ClearData
	ret
