CheckBlueStageTopGameObjectCollisions: ; 0x1c520
	call CheckBlueStageShellderCollision
	call CheckBlueStageSpinnerCollision
	call CheckBlueStageBoardTriggersCollision
	call CheckBlueStageSlowpokeCollision
	call CheckBlueStageCloysterCollision
	call CheckBlueStagePinballUpgradeTriggersCollision
	call CheckBlueStageEvolutionTrinketCollision
	ret

CheckBlueStageBottomGameObjectCollisions: ; 0x1c536
	ld a, [wBallYPos + 1]
	cp $56
	jr nc, .lowerHalfOfScreen
	call CheckBlueStageWildPokemonCollision
	call CheckBlueStagePsyduckPoliwagCollision
	call CheckBlueStageBonusMultiplierCollision
	call CheckBlueStageSlotCollision
	call CheckBlueStageEvolutionTrinketCollision
	ret

.lowerHalfOfScreen
	call CheckBlueStageBumpersCollision
	call CheckBlueStagePikachuCollision
	call CheckBlueStageCAVELightsCollision
	call CheckBlueStageLaunchAlleyCollision
	ret

CheckBlueStageShellderCollision: ; 0x1c55a
	ld de, BlueStageShellderCollisionData
	ld hl, BlueStageShellderCollisionAttributes
	ld bc, wWhichShellder
	and a
	jp HandleGameObjectCollision

CheckBlueStageSpinnerCollision: ; 0x1c567
	ld de, BlueStageSpinnerCollisionData
	ld bc, wSpinnerCollision
	scf
	jp HandleGameObjectCollision

CheckBlueStageBumpersCollision: ; 0x1c571
	ld de, BlueStageBumpersCollisionData
	ld hl, BlueStageBumpersCollisionAttributes
	ld bc, wWhichBumper
	and a
	jp HandleGameObjectCollision

CheckBlueStageBoardTriggersCollision: ; 0x1c57e
	ld de, BlueStageBoardTriggersCollisionData
	ld bc, wWhichBoardTrigger
	scf
	jp HandleGameObjectCollision

CheckBlueStageCloysterCollision: ; 0x1c588
	ld de, BlueStageCloysterCollisionData
	ld bc, wCloysterCollision
	scf
	jp HandleGameObjectCollision

CheckBlueStageSlowpokeCollision: ; 0x1c592
	ld de, BlueStageSlowpokeCollisionData
	ld bc, wSlowpokeCollision
	scf
	jp HandleGameObjectCollision

CheckBlueStagePikachuCollision: ; 0x1c59c
	ld de, BlueStagePikachuCollisionData
	ld bc, wWhichPikachu
	scf
	jp HandleGameObjectCollision

CheckBlueStageBonusMultiplierCollision: ; 0x1c5a6
	ld de, BlueStageBonusMultiplierCollisionData
	ld hl, BlueStageBonusMultiplierCollisionAttributes
	ld bc, wWhichBonusMultiplierRailing
	and a
	jp HandleGameObjectCollision

CheckBlueStagePsyduckPoliwagCollision: ; 0x1c5b3
	ld de, BlueStagePsyduckPoliwagCollisionData
	ld hl, BlueStagePsyduckPoliwagCollisionAttributes
	ld bc, wWhichPsyduckPoliwag
	and a
	jp HandleGameObjectCollision

CheckBlueStagePinballUpgradeTriggersCollision: ; 0x1c5c0
	ld de, BlueStagePinballUpgradeTriggersCollisionData
	ld bc, wWhichPinballUpgradeTrigger
	scf
	jp HandleGameObjectCollision

CheckBlueStageCAVELightsCollision: ; 0x1c5ca
	ld de, BlueStageCAVELightsCollisionData
	ld bc, wWhichCAVELight
	scf
	jp HandleGameObjectCollision

CheckBlueStageSlotCollision: ; 0x1c5d4
	ld de, BlueStageSlotCollisionData
	ld bc, wSlotCollision
	scf
	jp HandleGameObjectCollision

CheckBlueStageWildPokemonCollision: ; 0x1c5de
	ld de, BlueStageWildPokemonCollisionData
	ld hl, BlueStageWildPokemonCollisionAttributes
	ld bc, wWildMonCollision
	and a
	jp HandleGameObjectCollision

CheckBlueStageEvolutionTrinketCollision: ; 0x1c5eb
	xor a
	ld [wCollidedPointIndex], a
	ld a, [wEvolutionObjectsDisabled]
	and a
	ret z
	ld a, [wCurrentStage]
	bit 0, a
	jr nz, .asm_1c601
	ld hl, BlueTopEvolutionTrinketCoords
	jp PinballCollidesWithPoints

.asm_1c601
	ld hl, BlueBottomEvolutionTrinketCoords
	jp PinballCollidesWithPoints

CheckBlueStageLaunchAlleyCollision: ; 0x1c607
	ld de, BlueStageLaunchAlleyCollisionData
	ld bc, wPinballLaunchCollision
	scf
	jp HandleGameObjectCollision

INCLUDE "data/collision/game_objects/blue_stage_game_object_collision.asm"
