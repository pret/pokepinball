InitBallForStage: ; 0x83ba
	ld a, [wd7c1]
	and a
	jr z, .asm_83c7
	call TryLoadWildMonCollisionMask
	call RestartStageMusic
	ret

.asm_83c7
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wd7ae], a
	ld [wd7af], a
	ld [wd7b2], a
	ld [wd7b3], a
	ld [wd7b0], a
	ld [wd7b1], a
	ld [wd7b4], a
	ld [wd7b5], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	inc a
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	ld a, $20
	ld [wSCX], a
	ld a, [wCurrentStage]
	call CallInFollowingTable
CallTable_8404: ; 0x8404
	; STAGE_RED_FIELD_TOP
	padded_dab InitBallRedField
	; STAGE_RED_FIELD_BOTTOM
	padded_dab InitBallRedField
	padded_dab Func_1804a
	padded_dab Func_1804a
	; STAGE_BLUE_FIELD_TOP
	padded_dab InitBallBlueField
	; STAGE_BLUE_FIELD_BOTTOM
	padded_dab InitBallBlueField
	; STAGE_GENGAR_BONUS
	padded_dab InitBallGengarBonusStage
	; STAGE_GENGAR_BONUS
	padded_dab InitBallGengarBonusStage
	; STAGE_MEWTWO_BONUS
	padded_dab InitBallMewtwoBonusStage
	; STAGE_MEWTWO_BONUS
	padded_dab InitBallMewtwoBonusStage
	; STAGE_MEOWTH_BONUS
	padded_dab InitBallMeowthBonusStage
	; STAGE_MEOWTH_BONUS
	padded_dab InitBallMeowthBonusStage
	; STAGE_DIGLETT_BONUS
	padded_dab InitBallDiglettBonusStage
	; STAGE_DIGLETT_BONUS
	padded_dab InitBallDiglettBonusStage
	; STAGE_SEEL_BONUS
	padded_dab InitBallSeelBonusStage
	; STAGE_SEEL_BONUS
	padded_dab InitBallSeelBonusStage

TryLoadWildMonCollisionMask: ; 0x8444
	ld a, [wInSpecialMode]
	and a
	jr z, .done
	ld a, [wSpecialMode]
	and a ; Is the current special mode "Catch 'Em" mode?
	jr nz, .done
	ld a, [wWildMonIsHittable]
	and a
	jr z, .done
	callba LoadWildMonCollisionMask
.done
	ret

RestartStageMusic: ; 0x8461
	ld a, [wStageSongBank]
	call SetSongBank
	ld a, [wStageSong]
	ld e, a
	ld d, $0
	call PlaySong
	ret
