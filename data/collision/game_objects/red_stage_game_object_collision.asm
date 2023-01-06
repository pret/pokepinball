RedStageDiglettCollisionAttributes:
	db $00  ; flat list
	db $64, $65, $68, $69
	db $FF ; terminator

RedStageDiglettCollisionData:
	db $08, $0C  ; x, y bounding box
	db $01, $20, $40  ; id, x, y
	db $02, $80, $40  ; id, x, y
	db $FF ; terminator

RedStageVoltorbCollisionAttributes:
	db $00  ; flat list
	db $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF, $F0, $F1, $F2, $F3, $F4, $F5
	db $FF ; terminator

RedStageVoltorbCollisionData:
	db $0E, $0E  ; x, y bounding box
	db $03, $42, $66  ; id, x, y
	db $04, $5A, $5C  ; id, x, y
	db $05, $55, $78  ; id, x, y
	db $FF ; terminator

RedStageBumpersCollisionAttributes:
	db $00  ; flat list
	db $32, $3F, $37, $3C, $34, $31, $3E, $36, $3B, $3D
	db $FF ; terminator

RedStageBumpersCollisionData:
	db $06, $0B  ; x, y bounding box
	db $06, $30, $66  ; id, x, y
	db $07, $6F, $66  ; id, x, y
	db $FF ; terminator

RedStageLaunchAlleyCollisionData:
	db $08, $08  ; x, y bounding box
	db $08, $A8, $98  ; id, x, y
	db $FF ; terminator

RedStageSpinnerCollisionData:
	db $08, $04  ; x, y, bounding box
	db $09, $90, $6C  ; id, x, y
	db $FF ; terminator

RedStageCAVELightsCollisionData:
	db $05, $03  ; x, y bounding box
	db $0A, $0E, $65  ; id, x, y
	db $0B, $1E, $65  ; id, x, y
	db $0C, $82, $65  ; id, x, y
	db $0D, $92, $65  ; id, x, y
	db $FF ; terminator

RedStagePinballUpgradeTriggerCollisionData:
	db $06, $05  ; x, y bounding box
	db $0E, $3A, $53  ; id, x, y
	db $0F, $50, $48  ; id, x, y
	db $10, $66, $49  ; id, x, y
	db $FF ; terminator

RedStageBoardTriggersCollisionData:
	db $09, $09  ; x, y bounding box
	db $11, $1C, $3C  ; id, x, y
	db $12, $2A, $44  ; id, x, y
	db $13, $25, $63  ; id, x, y
	db $14, $12, $7A  ; id, x, y
	db $15, $26, $84  ; id, x, y
	db $16, $7C, $44  ; id, x, y
	db $17, $8E, $7A  ; id, x, y
	db $18, $7F, $39  ; id, x, y
	db $FF ; terminator

RedStageTopStaryuCollisionAttributes:
	db $00  ; flat list
	db $10, $11, $12
	db $FF ; terminator

RedStageTopStaryuCollisionData:
	db $08, $06  ; x, y bounding box
	db $19, $40, $90  ; id, x, y
	db $FF ; terminator

RedStageBottomStaryuCollisionAttributes:
	db $00  ; flat list
	db $56, $5B, $5C
	db $FF ; terminator

RedStageBottomStaryuCollisionData:
	db $08, $06  ; x, y bounding box
	db $1A, $40, $08  ; id, x, y
	db $FF ; terminator

RedStageBellsproutCollisionData:
	db $06, $05  ; x, y bounding box
	db $1B, $7B, $76  ; id, x, y
	db $FF ; terminator

RedStagePikachuCollisionData:
	db $03, $05  ; x, y bounding box
	db $1C, $0E, $7C  ; id, x, y
	db $1D, $92, $7C  ; id, x, y
	db $FF ; terminator

RedStageWildPokemonCollisionAttributes:
	db $00  ; flat list
	db $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF
	db $FF ; terminator

RedStageWildPokemonCollisionData:
	db $1A, $1A  ; x, y bounding box
	db $1E, $50, $40  ; id, x, y
	db $FF ; terminator

RedStageDittoSlotCollisionData:
	db $03, $03  ; x, y bounding box
	db $1F, $12, $24  ; id, x, y
	db $FF ; terminator

RedStageSlotCollisionData:
	db $04, $04  ; x, y bounding box
	db $20, $50, $16  ; id, x, y
	db $FF ; terminator

RedStageBonusMultipliersCollisionAttributes:
	db $00  ; flat list
	db $4C, $4B, $48, $47, $4D, $4A
	db $FF ; terminator

RedStageBonusMultipliersCollisionData:
	db $07, $07  ; x, y bounding box
	db $21, $2C, $20  ; id, x, y
	db $22, $74, $20  ; id, x, y
	db $FF ; terminator

RedStageEvolutionTrinketCoordinatePointers: ; 0x145d2
	dw RedStageTopEvolutionTrinketCoords
	dw RedStageBottomEvolutionTrinketCoords

RedStageTopEvolutionTrinketCoords: ; 0x156d6
; First byte is just non-zero to signify that the array hasn't ended.
; Second byte is x coordinate.
; Third byte is y coordinate.
	db $01, $44, $14
	db $01, $2A, $1A
	db $01, $5E, $1A
	db $01, $11, $2D
	db $01, $77, $2D
	db $01, $16, $3E
	db $01, $77, $3E
	db $01, $06, $6D
	db $01, $83, $6D
	db $01, $41, $82
	db $01, $51, $82
	db $01, $69, $82
	db $00  ; terminator

RedStageBottomEvolutionTrinketCoords: ; 0x145fb
; First byte is just non-zero to signify that the array hasn't ended.
; Second byte is x coordinate.
; Third byte is y coordinate.
	db $01, $35, $1B
	db $01, $53, $1B
	db $01, $29, $1F
	db $01, $5F, $1F
	db $01, $26, $34
	db $01, $62, $34
	db $00  ; terminator
