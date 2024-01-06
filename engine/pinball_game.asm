HandlePinballGame: ; 0xd853
	ld a, [wScreenState]
	rst JumpTable  ; calls JumpToFuncInTable
PinballGameScreenFunctions: ; 0xd857
	dw GameScreenFunction_LoadGFX
	dw GameScreenFunction_StartBall
	dw GameScreenFunction_HandleBallPhysics
	dw GameScreenFunction_HandleBallLoss
	dw GameScreenFunction_EndBall

GameScreenFunction_LoadGFX: ; 0xd861
	xor a
	ld [wd908], a
	callba InitializeCurrentStage
	call FillBottomMessageBufferWithBlackTile
	ld a, $1
	ld [wAudioEngineEnabled], a
	ld [wDrawBottomMessageBox], a
	ld hl, wScreenState
	inc [hl]
	ret

GameScreenFunction_StartBall: ; 0xd87f
	ld a, $67
	ldh [hLCDC], a
	ld a, $e4
	ld [wBGP], a
	ld a, $e1
	ld [wOBP0], a
	ld a, $e4
	ld [wOBP1], a
	ld a, [wSCX]
	ldh [hSCX], a
	xor a
	ldh [hSCY], a
	ld a, $7
	ldh [hWX], a
	ld a, $83
	ldh [hLYC], a
	ldh [hLastLYC], a
	ld a, $ff
	ldh [hLCDCMask], a
	ld hl, hSTAT
	set 6, [hl]
	ld hl, rIE
	set 1, [hl]
	ld a, $1
	ldh [hStatIntrRoutine], a
	callba InitBallForStage
	callba LoadStageCollisionAttributes
	callba LoadStageData
	callba ScrollScreenToShowPinball
	call ClearSpriteBuffer
	callba DrawSpritesForStage
	ld a, [wUpdateAudioEngineUsingTimerInterrupt]
	and a
	call nz, ToggleAudioEngineUpdateMethod
	ld a, $1
	ld [wDrawBottomMessageBox], a
	xor a
	ld [wLoadingSavedGame], a
	call SetAllPalettesWhite
	call EnableLCD
	call FadeIn
	ld hl, wScreenState
	inc [hl]
	ret

GameScreenFunction_HandleBallPhysics: ; 0xd909
; main loop for stage logic
	xor a
	ld [wFlipperCollision], a
	ld [wCollisionForceAmplification], a
	call ApplyGravityToBall
	call LimitBallVelocity
	xor a
	ld [wIsBallColliding], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, HandleFlippers  ; only perform flipper logic on the lower half of stages
	ld a, [wFlipperCollision]
	and a
	ld a, [wCollisionNormalAngle]
	push af
	call CheckStageCollision
	pop af
	jr z, .noFlipperCollision
	ld [wCollisionNormalAngle], a
.noFlipperCollision
	call CheckGameObjectCollisions
	call ResolveGameObjectCollisions
	ld hl, wKeyConfigMenu
	call IsKeyPressed
	jr z, .didntPressMenuKey
	lb de, $03, $4c
	call PlaySoundEffect
	callba HandleInGameMenu
	jp z, SaveGame
.didntPressMenuKey
	ld a, [wIsBallColliding]  ; check for collision flag
	and a
	jr z, .moveBallPosition
	call ApplyTiltForces
	call LoadBallVelocity ; bc = x velocity, de = y velocity
	; First, rotate the velocity vector into a standardized coordinate
	; system where the normal angle points upwards.
	ld a, [wCollisionNormalAngle]
	call RotateVector
	; Apply the collision forces to the ball in the rotated coordinate system.
	call ApplyCollisionForces
	ld a, [wFlipperCollision]
	and a
	jr z, .noFlipperCollision2
	; de -= *wFlipperYForce
	ld hl, wFlipperYForce
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	; bc += *wFlipperXForce
	ld hl, wFlipperXForce
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	add l
	ld c, a
	ld a, b
	adc h
	ld b, a
	jr .updateBallVelocity

.noFlipperCollision2
	ld a, [wNoCollisionApplied]
	and a
	jr nz, .moveBallPosition
.updateBallVelocity
	; Rotate the velocity vector back to the regular coordinate system, and
	; set the ball's velocity to the resulting vector.
	ld a, [wCollisionNormalAngle]
	call NegateAngleAndRotateVector
	call SetBallVelocity
.moveBallPosition
	call MoveBallPosition
	callba CheckStageTransition
	callba DrawSpritesForStage
	call UpdateBottomText
	ld a, [wDisableDrawScoreboardInfo]
	and a
	jr nz, .skipDrawingScoreboard
	callba Func_85c7
	callba HideScoreIfBallLow
	callba Func_8645
	call Func_dba9
	call DrawNumPartyMonsIcon
	call DrawPikachuSaverLightningBoltIcon
.skipDrawingScoreboard
	ld a, [wTimerActive]
	and a
	callba nz, DecrementTimer
	ld a, [wMoveToNextScreenState]
	and a
	ret z
	xor a
	ld [wMoveToNextScreenState], a
	ld hl, wScreenState
	inc [hl]
	ret

INCLUDE "engine/pinball_game/save_game.asm"

GameScreenFunction_HandleBallLoss: ; 0xda36
	xor a
	ldh [hJoypadState], a
	ldh [hNewlyPressedButtons], a
	ldh [hPressedButtons], a
	ld [wFlipperCollision], a
	ld [wCollisionForceAmplification], a
	xor a
	ld [wIsBallColliding], a
	ld [wPinballIsVisible], a
	ld [wEnableBallGravityAndTilt], a
	call HandleTilts
	ld a, [wCurrentStage]
	bit 0, a
	callba nz, HandleFlippers
	callba DrawSpritesForStage
	call UpdateBottomText
	callba Func_85c7
	ld a, [wBottomTextEnabled]
	and a
	ret nz
	ld a, [wLostBall]
	and a
	jr z, .asm_daa9
	ld a, [wExtraBallState]
	cp $2
	jr z, .asm_daa9
	call EndOfBallBonus
	ld a, [wExtraBallState]
	and a
	jr z, .asm_daa9
	ld a, $2
	ld [wExtraBallState], a
	ld [wDrawBottomMessageBox], a
	call FillBottomMessageBufferWithBlackTile
	call EnableBottomText
	ld hl, wScrollingText3
	ld de, ShootAgainText
	call LoadScrollingText
	ret

.asm_daa9
	xor a
	ld [wExtraBallState], a
	ld hl, wScreenState
	inc [hl]
	ret

GameScreenFunction_EndBall: ; 0xdab2
	xor a
	ld [wRumblePattern], a
	ld a, [wGameOver]
	and a
	jp nz, TransitionToHighScoresScreen
	ld a, [wGoingToBonusStage]
	and a
	jr nz, .goingToBonusStage
	ld a, [wReturningFromBonusStage]
	and a
	jr nz, .returningFromBonusStage
	call FadeOut
	ld a, [wUpdateAudioEngineUsingTimerInterrupt]
	and a
	call z, ToggleAudioEngineUpdateMethod
	call DisableLCD
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, $1
	ld [wScreenState], a
	ret

.goingToBonusStage
	ld de, MUSIC_NOTHING
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call FadeOut
	ld a, [wUpdateAudioEngineUsingTimerInterrupt]
	and a
	call nz, ToggleAudioEngineUpdateMethod
	call DisableLCD
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, [wCurrentStage]
	ld [wCurrentStageBackup], a
	ld a, [wStageCollisionState]
	ld [wStageCollisionStateBackup], a
	ld a, [wNextStage]
	ld [wCurrentStage], a
	xor a
	ld [wReturningFromBonusStage], a
	ld [wGoingToBonusStage], a
	ld a, $0
	ld [wScreenState], a
	ret

.returningFromBonusStage
	ld de, MUSIC_NOTHING
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call FadeOut
	ld a, [wUpdateAudioEngineUsingTimerInterrupt]
	and a
	call nz, ToggleAudioEngineUpdateMethod
	call DisableLCD
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	ld a, [wCurrentStageBackup]
	ld [wCurrentStage], a
	ld a, [wStageCollisionStateBackup]
	ld [wStageCollisionState], a
	ld a, $1
	ld [wScreenState], a
	ret

TransitionToHighScoresScreen: ; 0xdb5d
	xor a
	ld [wGameOver], a
	ld de, MUSIC_NOTHING
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call FadeOut
	call DisableLCD
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	xor a
	ld [wDrawBottomMessageBox], a
	ld a, [wCurrentStage]
	ld c, a
	ld b, $0
	ld hl, HighScoresStageMapping
	add hl, bc
	ld a, [hl]
	ld [wHighScoresStage], a
	ld a, SCREEN_HIGH_SCORES
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret

HighScoresStageMapping: ; 0xdb99
; Determines which stage the high scores screen will start in,
; based on the map the player ended in.
; See wHighScoresStage for more info.
	db $00  ; STAGE_RED_FIELD_TOP
	db $00  ; STAGE_RED_FIELD_BOTTOM
	db $00
	db $00
	db $01  ; STAGE_BLUE_FIELD_TOP
	db $01  ; STAGE_BLUE_FIELD_BOTTOM
	db $00  ; STAGE_GENGAR_BONUS
	db $00  ; STAGE_GENGAR_BONUS
	db $00  ; STAGE_MEWTWO_BONUS
	db $00  ; STAGE_MEWTWO_BONUS
	db $00  ; STAGE_MEOWTH_BONUS
	db $00  ; STAGE_MEOWTH_BONUS
	db $00  ; STAGE_DIGLETT_BONUS
	db $00  ; STAGE_DIGLETT_BONUS
	db $00  ; STAGE_SEEL_BONUS
	db $00  ; STAGE_SEEL_BONUS

Func_dba9: ; 0xdba9
	ld a, $85
	ld [wBottomMessageBuffer + $44], a
	ld a, [wCurBallLife]
	xor $3
	inc a
	add $86
	ld [wBottomMessageBuffer + $45], a
	ret
