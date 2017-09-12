CheckRedStageTopGameObjectCollisions: ; 0x143e1
	call CheckRedStageVoltorbCollision
	call CheckRedStageSpinnerCollision
	call CheckRedStageBoardTriggersCollision
	call CheckRedStageTopStaryuCollision
	call CheckRedStageBellsproutCollision
	call CheckRedStageDittoSlotCollision
	call CheckRedStagePinballUpgradeTriggersCollision
	jp CheckRedStageEvolutionTrinketCollision

CheckRedStageBottomGameObjectCollisions: ; 0x143f9
	ld a, [wBallYPos + 1]
	cp $56
	jr nc, .lowerHalfOfScreen
	call CheckRedStageWildPokemonCollision
	call CheckRedStageBottomStaryuCollision
	call CheckRedStageDiglettCollision
	call CheckRedStageBonusMultiplierCollision
	call CheckRedStageSlotCollision
	jp CheckRedStageEvolutionTrinketCollision

.lowerHalfOfScreen
	call CheckRedStageBumpersCollision
	call CheckRedStagePikachuCollision
	call CheckRedStageCAVELightsCollision
	jp CheckRedStageLaunchAlleyCollision

CheckRedStageEvolutionTrinketCollision: ; 0x1441e
	xor a
	ld [wCollidedPointIndex], a
	ld a, [wEvolutionObjectsDisabled]
	and a
	ret z
	ld a, [wCurrentStage]
	ld hl, RedStageEvolutionTrinketCoordinatePointers
	ld c, a
	ld b, $0
	sla c
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp PinballCollidesWithPoints

CheckRedStageDittoSlotCollision: ; 0x14439
	ld de, RedStageDittoSlotCollisionData
	ld bc, wDittoSlotCollision
	scf
	jp HandleGameObjectCollision

CheckRedStageSlotCollision: ; 0x14443
	ld de, RedStageSlotCollisionData
	ld bc, wSlotCollision
	scf
	jp HandleGameObjectCollision

CheckRedStageWildPokemonCollision: ; 0x1444d
	ld de, RedStageWildPokemonCollisionData
	ld hl, RedStageWildPokemonCollisionAttributes
	ld bc, wWildMonCollision
	and a
	jp HandleGameObjectCollision

CheckRedStageBonusMultiplierCollision: ; 0x1445a
; There are two small railings above the Digletts. If you hit them, you get a bonus
; multiplier. I can't think of a good name for these two obsjects.
	ld de, RedStageBonusMultipliersCollisionData
	ld hl, RedStageBonusMultipliersCollisionAttributes
	ld bc, wWhichBonusMultiplierRailing
	and a
	jp HandleGameObjectCollision

CheckRedStageDiglettCollision: ; 0x14467
	ld de, RedStageDiglettCollisionData
	ld hl, RedStageDiglettCollisionAttributes
	ld bc, wWhichDiglett
	and a
	jp HandleGameObjectCollision

CheckRedStageVoltorbCollision: ; 0x14474
	ld de, RedStageVoltorbCollisionData
	ld hl, RedStageVoltorbCollisionAttributes
	ld bc, wWhichVoltorb
	and a
	jp HandleGameObjectCollision

CheckRedStageBumpersCollision: ; 0x14481
	ld de, RedStageBumpersCollisionData
	ld hl, RedStageBumpersCollisionAttributes
	ld bc, wWhichBumper
	and a
	jp HandleGameObjectCollision

CheckRedStageLaunchAlleyCollision: ; 0x1448e
	ld de, RedStageLaunchAlleyCollisionData
	ld bc, wPinballLaunchCollision
	scf
	jp HandleGameObjectCollision

CheckRedStageSpinnerCollision: ; 0x14498
	ld de, RedStageSpinnerCollisionData
	ld bc, wSpinnerCollision
	scf
	jp HandleGameObjectCollision

CheckRedStageCAVELightsCollision: ; 0x144a2
	ld de, RedStageCAVELightsCollisionData
	ld bc, wWhichCAVELight
	scf
	jp HandleGameObjectCollision

CheckRedStagePinballUpgradeTriggersCollision: ; 0x144ac
	ld de, RedStagePinballUpgradeTriggerCollisionData
	ld bc, wWhichPinballUpgradeTrigger
	scf
	jp HandleGameObjectCollision

CheckRedStageBoardTriggersCollision: ; 0x144b6
	ld de, RedStageBoardTriggersCollisionData
	ld bc, wWhichBoardTrigger
	scf
	jp HandleGameObjectCollision

CheckRedStageTopStaryuCollision: ; 0x144c0
	ld de, RedStageTopStaryuCollisionData
	ld hl, RedStageTopStaryuCollisionAttributes
	ld bc, wStaryuCollision
	and a
	jp HandleGameObjectCollision

CheckRedStageBottomStaryuCollision: ; 0x144cd
; Staryu collision can actually be hit via the bottom screen, despite the fact
; that the Staryu is located on the (bottom of the) top screen.
	ld de, RedStageBottomStaryuCollisionData
	ld hl, RedStageBottomStaryuCollisionAttributes
	ld bc, wStaryuCollision
	and a
	jp HandleGameObjectCollision

CheckRedStageBellsproutCollision: ; 0x144da
	ld de, RedStageBellsproutCollisionData
	ld bc, wBellsproutCollision
	scf
	jp HandleGameObjectCollision

CheckRedStagePikachuCollision:
	ld de, RedStagePikachuCollisionData
	ld bc, wWhichPikachu
	scf
	jp HandleGameObjectCollision

INCLUDE "data/collision/game_objects/red_stage_game_object_collision.asm"
