; TODO: this file has a bunch of stuff that doesn't belong here.

ResolveRedFieldTopGameObjectCollisions: ; 0x1460e
	call ResolveVoltorbCollision
	call ResolveRedStageSpinnerCollision
	call ResolveRedStagePinballUpgradeTriggersCollision
	call HandleRedStageBallTypeUpgradeCounter
	call Func_15270
	call ResolveRedStageBoardTriggerCollision
	call ResolveRedStagePikachuCollision
	call ResolveStaryuCollision
	call ResolveBellsproutCollision
	call ResolveDittoSlotCollision
	call Func_161e0
	call Func_164e3
	call Func_146a9
	call Func_174ea
	call Func_148cf
	callba HandleExtraBall
	ld a, $0
	callba Func_10000
	ret

ResolveRedFieldBottomGameObjectCollisions: ; 0x14652
	call Func_14795
	call Func_15f86
	call ResolveDiglettCollision
	call Func_14880
	call Func_14e10
	call Func_154a9
	call HandleRedStageBallTypeUpgradeCounter
	call Func_151cb
	call Func_1652d
	call ResolveRedStagePikachuCollision
	call Func_167ff
	call Func_169a6
	call ResolveRedStageBonusMultiplierCollision
	call Func_16279
	call Func_161af
	call Func_164e3
	call Func_14733
	call Func_146a2
	call Func_174d0
	callba HandleExtraBall
	ld a, $0
	callba Func_10000
	ret

Func_146a2: ; 0x146a2
	call Func_146a9
	call nz, Func_14707
	ret

Func_146a9: ; 0x146a9
	ld a, [wBallSaverTimerFrames]
	ld hl, wBallSaverTimerSeconds
	or [hl]
	ret z
	ld a, [wBallXPos + 1]
	cp $9a
	jr nc, .asm_146e8
	ld a, [wBallSaverTimerFrames]
	dec a
	ld [wBallSaverTimerFrames], a
	bit 7, a
	jr z, .asm_146e8
	ld a, 59
	ld [wBallSaverTimerFrames], a
	ld a, [hl]
	dec a
	bit 7, a
	jr nz, .asm_146cf
	ld [hl], a
.asm_146cf
	inc a
	ld c, $0
	cp $2
	jr c, .asm_146e4
	ld c, $4
	cp $6
	jr c, .asm_146e4
	ld c, $10
	cp $b
	jr c, .asm_146e4
	ld c, $ff
.asm_146e4
	ld a, c
	ld [wd4a2], a
.asm_146e8
	ld a, [wd4a2]
	ld c, $0
	and a
	jr z, .asm_146fe
	ld c, $1
	cp $ff
	jr z, .asm_146fe
	ld hl, hNumFramesDropped
	and [hl]
	jr z, .asm_146fe
	ld c, $0
.asm_146fe
	ld a, [wBallSaverIconOn]
	cp c
	ld a, c
	ld [wBallSaverIconOn], a
	ret

Func_14707: ; 0x14707
	ld a, [wBallSaverIconOn]
	and a
	jr nz, .asm_1471c
	ld a, BANK(BgTileData_1172b)
	ld hl, BgTileData_1172b
	deCoord 8, 13, vBGMap
	ld bc, $0004
	call LoadOrCopyVRAMData
	ret

.asm_1471c
	ld a, BANK(BgTileData_1472f)
	ld hl, BgTileData_1472f
	deCoord 8, 13, vBGMap
	ld bc, $0004
	call LoadOrCopyVRAMData
	ret

BgTileData_1172b:
	db $AA, $AB, $AC, $AD

BgTileData_1472f:
	db $B4, $B5, $B6, $B7

Func_14733: ; 0x14733
	ld c, $0
	ld a, [wCurBonusMultiplier]
	and a
	jr z, .asm_1473d
	ld c, $1
.asm_1473d
	ld a, [wd4a9]
	cp c
	ld a, c
	ld [wd4a9], a
	ret z
	; fall through

Func_14746: ; 0x14746
	ld c, $0
	ld a, [wCurBonusMultiplier]
	and a
	jr z, .asm_14750
	ld c, $2
.asm_14750
	ld b, $0
	ld hl, AgainTextTileDataRedField
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(AgainTextTileDataRedField)
	call Func_10aa
	ret

AgainTextTileDataRedField:
	dw AgainTextOffTileDataRedField
	dw AgainTextOnTileDataRedField

AgainTextOffTileDataRedField:
	db 2
	dw AgainTextOffTileDataRedField1
	dw AgainTextOffTileDataRedField2

AgainTextOnTileDataRedField:
	db 2
	dw AgainTextOnTileDataRedField1
	dw AgainTextOnTileDataRedField2

AgainTextOffTileDataRedField1:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $38
	dw AgainTextOffGfx
	db Bank(AgainTextOffGfx)
	db $00

AgainTextOffTileDataRedField2:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $3a
	dw AgainTextOffGfx + $20
	db Bank(AgainTextOffGfx)
	db $00

AgainTextOnTileDataRedField1:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $38
	dw StageRedFieldBottomBaseGameBoyGfx + $380
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

AgainTextOnTileDataRedField2:
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $3a
	dw StageRedFieldBottomBaseGameBoyGfx + $3a0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

Func_14795: ; 0x14795
	ld a, [wWildMonCollision]
	and a
	ret z
	xor a
	ld [wWildMonCollision], a
	ld a, $1
	ld [wBallHitWildMon], a
	lb de, $00, $06
	call PlaySoundEffect
	ret

ResolveDiglettCollision: ; 0x147aa
	ld a, [wWhichDiglett]
	and a
	jp z, .asm_14834
	xor a
	ld [wWhichDiglett], a
	ld a, [wWhichDiglettId]
	sub $1
	sla a
	ld c, a
	ld b, $0
	ld hl, wLeftMapMoveCounter
	add hl, bc
	ld a, [hl]
	cp $3
	jr z, .asm_14834
	inc a
	ld [hld], a
	ld [hl], $50
	ld hl, wd4f7
	add hl, bc
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, c
	and a
	jr z, .asm_14807
	ld a, $6a
	ld [wStageCollisionMap + $f0], a
	ld a, $6b
	ld [wStageCollisionMap + $110], a
	ld a, $5
	call Func_149d9
	ld a, [wRightMapMoveCounter]
	add $4
	call Func_149f5
	ld a, $8
	callba Func_10000
	ld a, [wRightMapMoveCounter]
	cp $3
	call z, Func_14920
	jr .asm_14830

.asm_14807
	ld a, $66
	ld [wStageCollisionMap + $e3], a
	ld a, $67
	ld [wStageCollisionMap + $103], a
	ld a, $2
	call Func_149d9
	ld a, [wLeftMapMoveCounter]
	call Func_149f5
	ld a, $7
	callba Func_10000
	ld a, [wLeftMapMoveCounter]
	cp $3
	call z, Func_14947
.asm_14830
	call Func_1496d
	ret

.asm_14834
	ld a, [wd4ef]
	and a
	jr z, .asm_14857
	dec a
	ld [wd4ef], a
	jr nz, .asm_14857
	ld a, [wLeftMapMoveCounter]
	sub $3
	jr nz, .asm_1484d
	ld [wLeftMapMoveCounter], a
	call Func_149f5
.asm_1484d
	ld a, $64
	ld [wStageCollisionMap + $e3], a
	ld a, $65
	ld [wStageCollisionMap + $103], a
.asm_14857
	ld a, [wd4f1]
	and a
	jr z, .asm_1487c
	dec a
	ld [wd4f1], a
	jr nz, .asm_1487c
	ld a, [wRightMapMoveCounter]
	sub $3
	jr nz, .asm_14872
	ld [wRightMapMoveCounter], a
	add $4
	call Func_149f5
.asm_14872
	ld a, $68
	ld [wStageCollisionMap + $f0], a
	ld a, $69
	ld [wStageCollisionMap + $110], a
.asm_1487c
	call Func_14990
	ret

Func_14880: ; 0x14880
	ld hl, wd4f7
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_148a6
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_148a6
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_148a6
	cp $3
	jr z, .asm_148a6
	dec a
	ld [wLeftMapMoveCounter], a
	call Func_149f5
.asm_148a6
	ld hl, wd4f9
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_148ce
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_148ce
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_148ce
	cp $3
	jr z, .asm_148ce
	dec a
	ld [wRightMapMoveCounter], a
	add $4
	call Func_149f5
.asm_148ce
	ret

Func_148cf: ; 0x148cf
	ld b, $0
	ld hl, wd4f8
	ld a, [hld]
	or [hl]
	jr z, .asm_148f8
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_148f8
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_148f8
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wLeftMapMoveCounter]
	and a
	jr z, .asm_148f8
	cp $3
	jr z, .asm_148f8
	dec a
	ld [wLeftMapMoveCounter], a
.asm_148f8
	ld hl, wd4fa
	ld a, [hld]
	or [hl]
	jr z, .asm_1491f
	dec [hl]
	ld a, [hli]
	cp $ff
	jr nz, .asm_1491f
	dec [hl]
	ld a, [hld]
	cp $ff
	jr nz, .asm_1491f
	ld a, $e0
	ld [hli], a
	ld a, $1
	ld [hl], a
	ld a, [wRightMapMoveCounter]
	and a
	jr z, .asm_1491f
	cp $3
	jr z, .asm_1491f
	dec a
	ld [wRightMapMoveCounter], a
.asm_1491f
	ret

Func_14920: ; 0x14920
	ld hl, wNumDugtrioTriples
	call Increment_Max100
	jr nc, .asm_14937
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_14937
	ld a, $1
	ld [wd55a], a
	callba StartMapMoveMode
	ret

Func_14947: ; 0x14947
	ld hl, wNumDugtrioTriples
	call Increment_Max100
	jr nc, .asm_1495e
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_1495e
	xor a
	ld [wd55a], a
	callba StartMapMoveMode
	ret

Func_1496d: ; 0x1496d
	ld a, $55
	ld [wd803], a
	ld a, $4
	ld [wd804], a
	ld a, $2
	ld [wd7eb], a
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $0f
	call PlaySoundEffect
	ret

Func_14990: ; 0x14990
	ld a, [wd4ef]
	and a
	jr nz, .asm_149b6
	ld a, [wLeftMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_149a2
	dec a
	ld [wLeftMapMoveDiglettAnimationCounter], a
	jr .asm_149b6

.asm_149a2
	call Func_1130
	ret nz
	ld a, $14
	ld [wLeftMapMoveDiglettAnimationCounter], a
	ld a, [wLeftMapMoveDiglettFrame]
	xor $1
	ld [wLeftMapMoveDiglettFrame], a
	call Func_149d9
.asm_149b6
	ld a, [wd4f1]
	and a
	ret nz
	ld a, [wRightMapMoveDiglettAnimationCounter]
	and a
	jr z, .asm_149c6
	dec a
	ld [wRightMapMoveDiglettAnimationCounter], a
	ret

.asm_149c6
	call Func_1130
	ret nz
	ld a, $14
	ld [wRightMapMoveDiglettAnimationCounter], a
	ld a, [wRightMapMoveDiglettFrame]
	xor $1
	ld [wRightMapMoveDiglettFrame], a
	add $3
	; fall through
Func_149d9: ; 0x149d9
	sla a
	ld c, a
	ld b, $0
	ld hl, TileListDataPointers_14a11
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_149e9
	ld hl, TileListDataPointers_14a83
.asm_149e9
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, BANK(TileListDataPointers_14a11)
	call Func_10aa
	ret

Func_149f5: ; 0x149f5
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_14af5
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_14a05
	ld hl, TileListDataPointers_14c8d
.asm_14a05
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, BANK(Data_14af5)
	call Func_10aa
	ret

TileListDataPointers_14a11: ; 0x14a11
	dw TileListData_14a1d
	dw TileListData_14a20
	dw TileListData_14a23
	dw TileListData_14a26
	dw TileListData_14a29
	dw TileListData_14a2c

TileListData_14a1d: ; 0x14a1d
	db $01
	dw TileListData_14a2f

TileListData_14a20: ; 0x14a20
	db $01
	dw TileListData_14a3d

TileListData_14a23: ; 0x14a23
	db $01
	dw TileListData_14a4b

TileListData_14a26: ; 0x14a26
	db $01
	dw TileListData_14a59

TileListData_14a29: ; 0x14a29
	db $01
	dw TileListData_14a67

TileListData_14a2c: ; 0x14a2c
	db $01
	dw TileListData_14a75

TileListData_14a2f: ; 0x14a2f
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $a3
	db $4C, $4D

	db $02 ; number of tiles
	dw vBGMap + $c3
	db $4E, $4F

	db $00  ; terminator

TileListData_14a3d: ; 0x14a3d
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $a3
	db $50, $51

	db $02 ; number of tiles
	dw vBGMap + $c3
	db $52, $53

	db $00  ; terminator

TileListData_14a4b: ; 0x14a4b
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $a3
	db $54, $80

	db $02 ; number of tiles
	dw vBGMap + $c3
	db $55, $80

	db $00  ; terminator

TileListData_14a59: ; 0x14a59
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $af
	db $56, $57

	db $02 ; number of tiles
	dw vBGMap + $cf
	db $58, $59

	db $00  ; terminator

TileListData_14a67: ; 0x14a67
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $af
	db $5a, $5b

	db $02 ; number of tiles
	dw vBGMap + $cf
	db $5c, $5d

	db $00  ; terminator

TileListData_14a75: ; 0x14a75
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $af
	db $80, $5e

	db $02 ; number of tiles
	dw vBGMap + $cf
	db $80, $5f

	db $00  ; terminator

TileListDataPointers_14a83:
	dw TileListData_14a8f
	dw TileListData_14a92
	dw TileListData_14a95
	dw TileListData_14a98
	dw TileListData_14a9b
	dw TileListData_14a9e

TileListData_14a8f: ; 0x14a8f
	db $01
	dw TileListData_14aa1

TileListData_14a92: ; 0x14a92
	db $01
	dw TileListData_14aaf

TileListData_14a95: ; 0x14a95
	db $01
	dw TileListData_14abd

TileListData_14a98: ; 0x14a98
	db $01
	dw TileListData_14acb

TileListData_14a9b: ; 0x14a9b
	db $01
	dw TileListData_14ad9

TileListData_14a9e: ; 0x14a9e
	db $01
	dw TileListData_14ae7

TileListData_14aa1: ; 0x14aa1
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $a3
	db $54, $55

	db $02 ; number of tiles
	dw vBGMap + $c3
	db $56, $57

	db $00

TileListData_14aaf: ; 0x14aaf
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $a3
	db $58, $59

	db $02 ; number of tiles
	dw vBGMap + $c3
	db $5A, $5B

	db $00 ; terminator

TileListData_14abd: ; 0x14abd
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $a3
	db $5C, $80

	db $02 ; number of tiles
	dw vBGMap + $c3
	db $5D, $80

	db $00 ; terminator

TileListData_14acb: ; 0x14acb
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $af
	db $55, $54

	db $02 ; number of tiles
	dw vBGMap + $cf
	db $57, $56

	db $00 ; terminator

TileListData_14ad9: ; 0x14ad9
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $af
	db $59, $58

	db $02 ; number of tiles
	dw vBGMap + $cf
	db $5B, $5A

	db $00 ; terminator

TileListData_14ae7: ; 0x14ae7
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $af
	db $80, $5C

	db $02 ; number of tiles
	dw vBGMap + $cf
	db $80, $5D

	db $00 ; terminator

Data_14af5: ; 0x14af5
	dw Data_14b05
	dw Data_14b0e
	dw Data_14b17
	dw Data_14b20
	dw Data_14b29
	dw Data_14b32
	dw Data_14b3b
	dw Data_14b44

Data_14b05: ; 0x14b05
	db $04
	dw Data_14b4d
	dw Data_14b57
	dw Data_14b61
	dw Data_14b6b

Data_14b0e: ; 0x14b0e
	db $04
	dw Data_14b75
	dw Data_14b7f
	dw Data_14b89
	dw Data_14b93

Data_14b17: ; 0x14b17
	db $04
	dw Data_14b9d
	dw Data_14ba7
	dw Data_14bb1
	dw Data_14bbb

Data_14b20: ; 0x14b20
	db $04
	dw Data_14bc5
	dw Data_14bcf
	dw Data_14bd9
	dw Data_14be3

Data_14b29: ; 0x14b29
	db $04
	dw Data_14bed
	dw Data_14bf7
	dw Data_14c01
	dw Data_14c0b

Data_14b32: ; 0x14b32
	db $04
	dw Data_14c15
	dw Data_14c1f
	dw Data_14c29
	dw Data_14c33

Data_14b3b: ; 0x14b3b
	db $04
	dw Data_14c3d
	dw Data_14c47
	dw Data_14c51
	dw Data_14c5b

Data_14b44: ; 0x14b44
	db $04
	dw Data_14c65
	dw Data_14c6f
	dw Data_14c79
	dw Data_14c83

Data_14b4d: ; 0x14b4d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $26
	dw StageRedFieldBottomBaseGameBoyGfx + $a60
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14b57: ; 0x14b57
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $29
	dw StageRedFieldBottomBaseGameBoyGfx + $a90
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14b61: ; 0x14b61
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $2C
	dw StageRedFieldBottomBaseGameBoyGfx + $ac0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14b6b: ; 0x14b6b
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $2F
	dw StageRedFieldBottomBaseGameBoyGfx + $af0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14b75: ; 0x14b75
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $26
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $720
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14b7f: ; 0x14b7f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $29
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $750
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14b89: ; 0x14b89
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $2C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $780
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14b93: ; 0x14b93
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $2F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $7B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14b9d: ; 0x14b9d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $26
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $7C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14ba7: ; 0x14ba7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $29
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $7F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14bb1: ; 0x14bb1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $2C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $820
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14bbb: ; 0x14bbb
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $2F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $850
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14bc5: ; 0x14bc5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $26
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $860
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14bcf: ; 0x14bcf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $29
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $890
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14bd9: ; 0x14bd9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $2C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $8C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14be3: ; 0x14be3
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $2F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $8F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14bed: ; 0x14bed
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $30
	dw StageRedFieldBottomBaseGameBoyGfx + $B00
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14bf7: ; 0x14bf7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $33
	dw StageRedFieldBottomBaseGameBoyGfx + $B30
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14c01: ; 0x14c01
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $36
	dw StageRedFieldBottomBaseGameBoyGfx + $B60
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14c0b: ; 0x14c0b
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $39
	dw StageRedFieldBottomBaseGameBoyGfx + $B90
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00 ; terminator

Data_14c15: ; 0x14c15
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $30
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $900
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c1f: ; 0x14c1f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $33
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $930
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c29: ; 0x14c29
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $36
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $960
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c33: ; 0x14c33
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $39
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $990
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c3d: ; 0x14c3d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $30
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $9A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c47: ; 0x14c47
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $33
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $9D0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c51: ; 0x14c51
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $36
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $A00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c5b: ; 0x14c5b
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $39
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $A30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c65: ; 0x14c65
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $30
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $A40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c6f: ; 0x14c6f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $33
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $A70
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c79: ; 0x14c79
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $36
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $AA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

Data_14c83: ; 0x14c83
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $39
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $AD0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileListDataPointers_14c8d:
	dw Data_14c9d
	dw Data_14ca0
	dw Data_14ca3
	dw Data_14ca6
	dw Data_14ca9
	dw Data_14cac
	dw Data_14caf
	dw Data_14cb2

Data_14c9d: ; 0x14c9d
	db $01
	dw TileListData_14cb5

Data_14ca0: ; 0x14ca0
	db $01
	dw TileListData_14ccf

Data_14ca3: ; 0x14ca3
	db $01
	dw TileListData_14ce9

Data_14ca6: ; 0x14ca6
	db $01
	dw TileListData_14d03

Data_14ca9: ; 0x14ca9
	db $01
	dw TileListData_14d1d

Data_14cac: ; 0x14cac
	db $01
	dw TileListData_14d37

Data_14caf: ; 0x14caf
	db $01
	dw TileListData_14d51

Data_14cb2: ; 0x14cb2
	db $01
	dw TileListData_14d6b

TileListData_14cb5: ; 0x14cb5
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $80
	db $06, $07

	db $03 ; number of tiles
	dw vBGMap + $a0
	db $08, $09, $0A

	db $03 ; number of tiles
	dw vBGMap + $c0
	db $0B, $0C, $0D

	db $02 ; number of tiles
	dw vBGMap + $e0
	db $0E, $0F

	db $00 ; terminator

TileListData_14ccf: ; 0x14ccf
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $80
	db $06, $07

	db $03 ; number of tiles
	dw vBGMap + $a0
	db $10, $11, $0A

	db $03 ; number of tiles
	dw vBGMap + $c0
	db $12, $13, $0D

	db $02 ; number of tiles
	dw vBGMap + $e0
	db $14, $15

	db $00 ; terminator

TileListData_14ce9: ; 0x14ce9
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $80
	db $06, $07

	db $03 ; number of tiles
	dw vBGMap + $a0
	db $10, $16, $17

	db $03 ; number of tiles
	dw vBGMap + $c0
	db $12, $18, $19

	db $02 ; number of tiles
	dw vBGMap + $e0
	db $14, $15

	db $00 ; terminator

TileListData_14d03: ; 0x14d03
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $80
	db $1A, $1B

	db $03 ; number of tiles
	dw vBGMap + $a0
	db $1C, $1D, $17

	db $03 ; number of tiles
	dw vBGMap + $c0
	db $12, $18, $19

	db $02 ; number of tiles
	dw vBGMap + $e0
	db $14, $15

	db $00 ; terminator

TileListData_14d1d: ; 014d1d
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $92
	db $07, $06

	db $03 ; number of tiles
	dw vBGMap + $b1
	db $0A, $1E, $08

	db $03 ; number of tiles
	dw vBGMap + $d1
	db $22, $0C, $24

	db $02 ; number of tiles
	dw vBGMap + $f2
	db $0F, $0E

	db $00 ; terminator

TileListData_14d37: ; 0x14d37
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $92
	db $07, $06

	db $03 ; number of tiles
	dw vBGMap + $b1
	db $0A, $1F, $10

	db $03 ; number of tiles
	dw vBGMap + $d1
	db $22, $13, $25

	db $02 ; number of tiles
	dw vBGMap + $f2
	db $15, $14

	db $00 ; terminator

TileListData_14d51: ; 0x14d51
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $92
	db $07, $06

	db $03 ; number of tiles
	dw vBGMap + $b1
	db $17, $20, $10

	db $03 ; number of tiles
	dw vBGMap + $d1
	db $23, $18, $25

	db $02 ; number of tiles
	dw vBGMap + $f2
	db $15, $14

	db $00 ; terminator

TileListData_14d6b: ; 0x14d6b
	dw LoadTileLists
	db $0A ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $92
	db $1B, $1A

	db $03 ; number of tiles
	dw vBGMap + $b1
	db $17, $21, $1C

	db $03 ; number of tiles
	dw vBGMap + $d1
	db $23, $18, $25

	db $02 ; number of tiles
	dw vBGMap + $f2
	db $15, $14

	db $00 ; terminator

ResolveVoltorbCollision: ; 0x14d85
	ld a, [wWhichVoltorb]
	and a
	jr z, .noVoltorbCollision
	xor a
	ld [wWhichVoltorb], a
	call Func_14dc9
	ld a, $10
	ld [wd4d6], a
	ld a, [wWhichVoltorbId]
	sub $3
	ld [wd4d7], a
	ld a, $4
	callba Func_10000
	ld bc, FiveHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ret

.noVoltorbCollision
	ld a, [wd4d6]
	and a
	ret z
	dec a
	ld [wd4d6], a
	ret nz
	ld a, $ff
	ld [wd4d7], a
	ret

Func_14dc9: ; 0x14dc9
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	lb de, $00, $0e
	call PlaySoundEffect
	ret

ResolveRedStageSpinnerCollision: ; 0x14dea
	ld a, [wSpinnerCollision]
	and a
	jr z, Func_14e10
	xor a
	ld [wSpinnerCollision], a
	ld a, [wBallYVelocity]
	ld c, a
	ld a, [wBallYVelocity + 1]
	ld b, a
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld a, $c
	callba Func_10000
	; fall through
Func_14e10: ; 0x14e10
	ld hl, wd50b
	ld a, [hli]
	or [hl]
	ret z
	ld a, [wd50b]
	ld c, a
	ld a, [wd50c]
	ld b, a
	bit 7, b
	jr nz, .asm_14e2e
	ld a, c
	sub $7
	ld c, a
	ld a, b
	sbc $0
	ld b, a
	jr nc, .asm_14e3b
	jr .asm_14e38

.asm_14e2e
	ld a, c
	add $7
	ld c, a
	ld a, b
	adc $0
	ld b, a
	jr nc, .asm_14e3b
.asm_14e38
	ld bc, $0000
.asm_14e3b
	ld a, c
	ld [wd50b], a
	ld a, b
	ld [wd50c], a
	ld hl, wd50b
	ld a, [wd509]
	add [hl]
	ld [wd509], a
	inc hl
	ld a, [wd50a]
	adc [hl]
	bit 7, a
	ld c, $0
	jr z, .asm_14e5e
	add $18
	ld c, $1
	jr .asm_14e66

.asm_14e5e
	cp $18
	jr c, .asm_14e66
	sub $18
	ld c, $1
.asm_14e66
	ld [wd50a], a
	ld a, c
	and a
	ret z
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wNumSpinnerTurns
	call Increment_Max100
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_14e8a
	call Func_14ea7
	ret

.asm_14e8a
	inc a
	ld [wPikachuSaverCharge], a
	call Func_14ea7
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_14e9d
	ld a, $64
	ld [wd51e], a
.asm_14e9d
	ld a, [wCurrentStage]
	bit 0, a
	ret nz
	call Func_14ece
	ret

Func_14ea7: ; 0x14ea7
	ld a, [wd51e]
	and a
	ret nz
	ld a, [wPikachuSaverCharge]
	ld c, a
	ld b, $0
	ld hl, SoundEffects_14ebe
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, $0
	call PlaySoundEffect
	ret

SoundEffects_14ebe:
	db $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $11

Func_14ece: ; 0x14ece
	ld a, [wPikachuSaverCharge]
	ld c, a
	sla c
	ld b, $0
	ld hl, TileDataPointers_14eeb
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_14ee1
	ld hl, TileDataPointers_1509b
.asm_14ee1
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(TileDataPointers_14eeb)
	call Func_10aa
	ret

TileDataPointers_14eeb:
	dw TileData_14f0b
	dw TileData_14f10
	dw TileData_14f15
	dw TileData_14f1a
	dw TileData_14f1f
	dw TileData_14f24
	dw TileData_14f29
	dw TileData_14f2e
	dw TileData_14f33
	dw TileData_14f38
	dw TileData_14f3d
	dw TileData_14f42
	dw TileData_14f47
	dw TileData_14f4c
	dw TileData_14f51
	dw TileData_14f56

TileData_14f0b: ; 0x14f0b
	db $02
	dw TileData_14f5b
	dw TileData_14f65

TileData_14f10: ; 0x14f10
	db $02
	dw TileData_14f6f
	dw TileData_14f79

TileData_14f15: ; 0x14f15
	db $02
	dw TileData_14f83
	dw TileData_14f8d

TileData_14f1a: ; 0x14f1a
	db $02
	dw TileData_14f97
	dw TileData_14fa1

TileData_14f1f: ; 0x14f1f
	db $02
	dw TileData_14fab
	dw TileData_14fb5

TileData_14f24: ; 0x14f24
	db $02
	dw TileData_14fbf
	dw TileData_14fc9

TileData_14f29: ; 0x14f29
	db $02
	dw TileData_14fd3
	dw TileData_14fdd

TileData_14f2e: ; 0x14f2e
	db $02
	dw TileData_14fe7
	dw TileData_14ff1

TileData_14f33: ; 0x14f33
	db $02
	dw TileData_14ffb
	dw TileData_15005

TileData_14f38: ; 0x14f38
	db $02
	dw TileData_1500f
	dw TileData_15019

TileData_14f3d: ; 0x14f3d
	db $02
	dw TileData_15023
	dw TileData_1502d

TileData_14f42: ; 0x14f42
	db $02
	dw TileData_15037
	dw TileData_15041

TileData_14f47: ; 0x14f47
	db $02
	dw TileData_1504b
	dw TileData_15055

TileData_14f4c: ; 0x14f4c
	db $02
	dw TileData_1505f
	dw TileData_15069

TileData_14f51: ; 0x14f51
	db $02
	dw TileData_15073
	dw TileData_1507d

TileData_14f56: ; 0x14f56
	db $02
	dw TileData_15087
	dw TileData_15091

TileData_14f5b: ; 0x14f5b
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldTopBaseGameBoyGfx + $cb0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00 ; terminator

TileData_14f65: ; 0x14f65
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldTopBaseGameBoyGfx + $cd0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00 ; terminator

TileData_14f6f: ; 0x14f6f
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $AE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14f79: ; 0x14f79
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $B00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14f83: ; 0x14f83
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $B20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14f8d: ; 0x14f8d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $B40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14f97: ; 0x14f97
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $B60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fa1: ; 0x14fa1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $B80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fab: ; 0x14fab
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $BA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fb5: ; 0x14fb5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $BC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fbf: ; 0x14fbf
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $BE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fc9: ; 0x14fc9
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fd3: ; 0x14fd3
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fdd: ; 0x14fdd
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14fe7: ; 0x14fe7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14ff1: ; 0x14ff1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_14ffb: ; 0x14ffb
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $CA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15005: ; 0x15005
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $CC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1500f: ; 0x1500f
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $CE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15019: ; 0x15019
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $D00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15023: ; 0x15023
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $D20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1502d: ; 0x1502d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $D40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15037: ; 0x15037
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $D60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15041: ; 0x15041
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $D80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1504b: ; 0x1504b
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $DA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15055: ; 0x15055
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $DC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1505f: ; 0x1505f
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $DE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15069: ; 0x15069
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $E00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15073: ; 0x15073
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $E20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1507d: ; 0x1507d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $E40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15087: ; 0x15087
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $75
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $E60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_15091: ; 0x15091
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $77
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $E80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileDataPointers_1509b:
	dw TileData_150bb
	dw TileData_150be
	dw TileData_150c1
	dw TileData_150c4
	dw TileData_150c7
	dw TileData_150ca
	dw TileData_150cd
	dw TileData_150d0
	dw TileData_150d3
	dw TileData_150d6
	dw TileData_150d9
	dw TileData_150dc
	dw TileData_150df
	dw TileData_150e2
	dw TileData_150e5
	dw TileData_150e8

TileData_150bb: ; 0x150bb
	db $01
	dw TileData_150eb

TileData_150be: ; 0x150be
	db $01
	dw TileData_150f9

TileData_150c1: ; 0x150c1
	db $01
	dw TileData_15107

TileData_150c4: ; 0x150c4
	db $01
	dw TileData_15115

TileData_150c7: ; 0x150c7
	db $01
	dw TileData_15123

TileData_150ca: ; 0x150ca
	db $01
	dw TileData_15131

TileData_150cd: ; 0x150cd
	db $01
	dw TileData_1513f

TileData_150d0: ; 0x150d0
	db $01
	dw TileData_1514d

TileData_150d3: ; 0x150d3
	db $01
	dw TileData_1515b

TileData_150d6: ; 0x150d6
	db $01
	dw TileData_15169

TileData_150d9: ; 0x150d9
	db $01
	dw TileData_15177

TileData_150dc: ; 0x150dc
	db $01
	dw TileData_15185

TileData_150df: ; 0x150df
	db $01
	dw TileData_15193

TileData_150e2: ; 0x150e2
	db $01
	dw TileData_151a1

TileData_150e5: ; 0x150e5
	db $01
	dw TileData_151af

TileData_150e8: ; 0x150e8
	db $01
	dw TileData_151bd

TileData_150eb: ; 0x150eb
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $5E, $5F

	db $00 ; terminator

TileData_150f9: ; 0x150f9
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $60, $61

	db $00 ; terminator

TileData_15107: ; 0x15107
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $62, $63

	db $00 ; terminator

TileData_15115: ; 0x15115
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $64, $65

	db $00 ; terminator

TileData_15123: ; 0x15123
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $66, $67

	db $00 ; terminator

TileData_15131: ; 0x15131
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $68, $69

	db $00 ; terminator

TileData_1513f: ; 0x1513f
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $6A, $6B

	db $00 ; terminator

TileData_1514d: ; 0x1514d
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $6C, $6D

	db $00 ; terminator

TileData_1515b: ; 0x1515b
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $5C, $5D

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_15169: ; 0x15169
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $70, $71

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_15177: ; 0x15177
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $72, $73

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_15185: ; 0x15185
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $74, $75

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_15193: ; 0x15193
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $76, $77

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_151a1: ; 0x151a1
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $78, $79

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_151af: ; 0x151af
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $7A, $7B

	db $02 ; number of tiles
	dw $992E
	db $6E, $6F

	db $00 ; terminator

TileData_151bd: ; 0x151bd
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $990E
	db $7C, $7D

	db $02 ; number of tiles
	dw $992E
	db $7E, $7F

	db $00 ; terminator

Func_151cb: ; 0x151cb
	ld a, [wWhichCAVELight]
	and a
	jr z, .asm_15229
	xor a
	ld [wWhichCAVELight], a
	ld a, [wd513]
	and a
	jr nz, .asm_15229
	ld a, [wWhichCAVELightId]
	sub $a
	ld c, a
	ld b, $0
	ld hl, wd50f
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd50f
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	inc hl
	and [hl]
	jr z, Func_asm_1522d
	ld a, $1
	ld [wd513], a
	ld a, $80
	ld [wd514], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $09
	call PlaySoundEffect
	ld hl, wNumCAVECompletions
	call Increment_Max100
	jr Func_asm_1522d

.asm_15229
	call Func_15270
	ret z
	; fall through

Func_asm_1522d: ; 0x1522d
	ld hl, wd512
	ld b, $4
.asm_15232
	ld a, [hld]
	push hl
	call Func_1523c
	pop hl
	dec b
	jr nz, .asm_15232
	ret

Func_1523c: ; 0x1523c
	and a
	jr z, .asm_1524e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15249
	ld hl, TileDataPointers_152dd
	jr .asm_1525b

.asm_15249
	ld hl, TileDataPointers_1531d
	jr .asm_1525b

.asm_1524e
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15258
	ld hl, TileDataPointers_152e5
	jr .asm_1525b

.asm_15258
	ld hl, TileDataPointers_15325
.asm_1525b
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_15270: ; 0x15270
	ld a, [wd513]
	and a
	jr z, .asm_152a6
	ld a, [wd514]
	dec a
	ld [wd514], a
	jr nz, .asm_1528d
	ld [wd513], a
	ld a, $1
	ld [wd608], a
	ld a, $3
	ld [wd607], a
	xor a
.asm_1528d
	and $7
	ret nz
	ld a, [wd514]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd50f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_152a6
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_152c2
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.asm_152c2
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wd50f
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, d
	ld [hl], a
	ret

TileDataPointers_152dd:
	dw TileData_152ed
	dw TileData_152f3
	dw TileData_152f9
	dw TileData_152ff

TileDataPointers_152e5:
	dw TileData_15305
	dw TileData_1530b
	dw TileData_15311
	dw TileData_15317

TileData_152ed: ; 0x152ed
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $121
	db $7d

	db $00 ; terminator

TileData_152f3: ; 0x152f3
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $123
	db $7d

	db $00 ; terminator

TileData_152f9: ; 0x152f9
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $130
	db $7f

	db $00 ; terminator

TileData_152ff: ; 0x152ff
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $132
	db $7f

	db $00 ; terminator

TileData_15305: ; 0x15305
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $121
	db $7c

	db $00 ; terminator

TileData_1530b: ; 0x1530b
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $123
	db $7c

	db $00 ; terminator

TileData_15311: ; 0x15311
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $130
	db $7e

	db $00 ; terminator

TileData_15317: ; 0x15317
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $132
	db $7e

	db $00 ; terminator

TileDataPointers_1531d:
	dw TileData_1532d
	dw TileData_15333
	dw TileData_15339
	dw TileData_1533f

TileDataPointers_15325:
	dw TileData_15345
	dw TileData_1534b
	dw TileData_15351
	dw TileData_15357

TileData_1532d: ; 0x1532d
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $121
	db $27

	db $00 ; terminator

TileData_15333: ; 0x15333
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $123
	db $29

	db $00 ; terminator

TileData_15339: ; 0x15339
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $130
	db $7E

	db $00 ; terminator

TileData_1533f: ; 0x1533f
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $132
	db $7F

	db $00 ; terminator

TileData_15345: ; 0x15345
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $121
	db $26

	db $00 ; terminator

TileData_1534b: ; 0x1534b
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $123
	db $28

	db $00 ; terminator

TileData_15351: ; 0x15351
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $130
	db $7C

	db $00 ; terminator

TileData_15357: ; 0x15357
	db $01 ; total number of tiles
	
	db $01 ; number of tiles
	dw vBGMap + $132
	db $7D

	db $00 ; terminator

ResolveRedStagePinballUpgradeTriggersCollision: ; 0x1535d
	ld a, [wWhichPinballUpgradeTrigger]
	and a
	jp z, .asm_1544c
	xor a
	ld [wWhichPinballUpgradeTrigger], a
	ld a, [wStageCollisionState]
	bit 0, a
	jp z, .asm_1544c
	ld a, [wd5fc]
	and a
	jp nz, .asm_1544c
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	call Func_159c9
	ld a, $b
	callba Func_10000
	ld a, [wWhichPinballUpgradeTriggerId]
	sub $e
	ld c, a
	ld b, $0
	ld hl, wd5f9
	add hl, bc
	ld a, [hl]
	ld [hl], $1
	and a
	ret nz
	ld bc, OneHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld hl, wd5f9
	ld a, [hli]
	and [hl]
	inc hl
	and [hl]
	jr nz, .asm_153c0
	lb de, $00, $09
	call PlaySoundEffect
	jp Func_15450

.asm_153c0
	ld a, $1
	ld [wd5fc], a
	ld a, $80
	ld [wd5fd], a
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
	ld bc, FourHundredPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wBallType]
	cp MASTER_BALL
	jr z, .masterBall
	lb de, $06, $3a
	call PlaySoundEffect
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld de, FieldMultiplierText
	ld hl, wd5cc
	call LoadTextHeader
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeProgressionRedField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	add $30
	ld [wBottomMessageText + $12], a
	jr .asm_15447

.masterBall
	lb de, $0f, $4d
	call PlaySoundEffect
	ld bc, OneMillionPoints
	callba AddBigBCD6FromQueue
	ld bc, $0100
	ld de, $0000
	push bc
	push de
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5d4
	ld de, DigitsText1to8
	call Func_32cc
	pop de
	pop bc
	ld hl, wd5cc
	ld de, FieldMultiplierSpecialBonusText
	call LoadTextHeader
.asm_15447
	call TransitionPinballUpgrade
	jr Func_15450

.asm_1544c
	call Func_154a9
	ret z

Func_15450
	ld a, [wStageCollisionState]
	bit 0, a
	ret z
	ld hl, wd5fb
	ld b, $3
.asm_1545b
	ld a, [hld]
	push hl
	call Func_15465
	pop hl
	dec b
	jr nz, .asm_1545b
	ret

Func_15465: ; 0x15465
	and a
	jr z, .asm_15477
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15472
	ld hl, TileDataPointers_15511
	jr .asm_15484

.asm_15472
	ld hl, TileDataPointers_15543
	jr .asm_15484

.asm_15477
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_15481
	ld hl, TileDataPointers_15517
	jr .asm_15484

.asm_15481
	ld hl, TileDataPointers_15549
.asm_15484
	push bc
	dec b
	sla b
	ld e, b
	ld d, $0
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	pop bc
	ret

Func_15499: ; 0x15499
	ld a, [hGameBoyColorFlag]
	and a
	ret nz
	ld b, $3
.asm_1549f
	push hl
	xor a
	call Func_15465
	pop hl
	dec b
	jr nz, .asm_1549f
	ret

Func_154a9: ; 0x154a9
	ld a, [wd5fc]
	and a
	jr z, .asm_154d6
	ld a, [wd5fd]
	dec a
	ld [wd5fd], a
	jr nz, .asm_154bb
	ld [wd5fc], a
.asm_154bb
	and $7
	jr nz, .asm_154d4
	ld a, [wd5fd]
	srl a
	srl a
	srl a
	and $1
	ld hl, wd5f9
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $1
	and a
	ret

.asm_154d4
	xor a
	ret

.asm_154d6
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed
	jr z, .asm_154ee
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hld], a
	ld a, b
	ld [hl], a
	ret

.asm_154ee
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed
	ret z
	ld hl, wd5f9
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld e, a
	ld a, b
	ld [hld], a
	ld a, c
	ld [hld], a
	ld a, e
	ld [hl], a
	ret

BallTypeProgressionRedField: ; 0x15505
; Determines the next upgrade for the Ball.
	db GREAT_BALL   ; POKE_BALL -> GREAT_BALL
	db GREAT_BALL   ; unused
	db ULTRA_BALL   ; GREAT_BALL -> ULTRA_BALL
	db MASTER_BALL  ; ULTRA_BALL -> MASTER_BALL
	db MASTER_BALL  ; unused
	db MASTER_BALL  ; MASTER_BALL -> MASTER_BALL

BallTypeDegradationRedField: ; 0x1550b
; Determines the previous upgrade for the Ball.
	db POKE_BALL   ; POKE_BALL -> POKE_BALL
	db POKE_BALL   ; unused
	db POKE_BALL   ; GREAT_BALL -> POKE_BALL
	db GREAT_BALL  ; ULTRA_BALL -> GREAT_BALL
	db ULTRA_BALL  ; unused
	db ULTRA_BALL  ; MASTER_BALL -> GREAT_BALL

TileDataPointers_15511:
	dw TileData_1551d
	dw TileData_15523
	dw TileData_1552a

TileDataPointers_15517:
	dw TileData_15530
	dw TileData_15536
	dw TileData_1553d

TileData_1551d: ; 0x1551d
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $E7
	db $ac

	db $00 ; terminator

TileData_15523: ; 0x15523
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $C9
	db $ad, $ae

	db $00 ; terminator

TileData_1552a: ; 0x1552a
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $CC
	db $af

	db $00 ; terminator

TileData_15530: ; 0x15530
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $E7
	db $66

	db $00 ; terminator

TileData_15536: ; 0x15536
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $C9
	db $68, $69

	db $00 ; terminator

TileData_1553d: ; 0x1553d
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $CC
	db $6a

	db $00 ; terminator

TileDataPointers_15543:
	dw TileData_1554f
	dw TileData_15555
	dw TileData_1555c

TileDataPointers_15549:
	dw TileData_15562
	dw TileData_15568
	dw TileData_1556F

TileData_1554f: ; 0x1554f
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $e7
	db $3D

	db $00 ; terminator

TileData_15555: ; 0x15555
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $c9
	db $3F, $40

	db $00 ; terminator

TileData_1555c: ; 0x1555c
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $cc
	db $41

	db $00 ; terminator

TileData_15562: ; 0x15562
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $e7
	db $37

	db $00 ; terminator

TileData_15568: ; 0x15568
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $c9
	db $39, $3a

	db $00 ; terminator

TileData_1556F: ; 0x1556F
	db $01 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $cc
	db $3B

	db $00 ; terminator

HandleRedStageBallTypeUpgradeCounter: ; 0x15575
	ld a, [wCapturingMon]
	and a
	ret nz
	ld hl, wBallTypeCounter
	ld a, [hli]
	ld c, a
	ld b, [hl]
	or b
	ret z
	dec bc
	ld a, b
	ld [hld], a
	ld [hl], c
	or c
	ret nz
	; counter is now 0! Degrade the ball upgrade.
	ld a, [wBallType]
	ld c, a
	ld b, $0
	ld hl, BallTypeDegradationRedField
	add hl, bc
	ld a, [hl]
	ld [wBallType], a
	and a
	jr z, .pokeball
	; load approximately 1 minute of frames into wBallTypeCounter
	ld a, $10
	ld [wBallTypeCounter], a
	ld a, $e
	ld [wBallTypeCounter + 1], a
.pokeball
	call TransitionPinballUpgrade
	ret

TransitionPinballUpgrade: ; 0x155a7
	ld a, [wBallType]
	ld c, a
	sla c
	ld b, $0
	ld hl, PinballUpgradeTransitionPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(PinballUpgradeTransitionPointers)
	call Func_10aa
	; fall through

Func_155bb: ; 0x155bb
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	; gameboy color
	ld a, [wBallType]
	sla a
	ld c, a
	ld b, $0
	ld hl, Data_157f7
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, BANK(Data_157f7)
	ld de, LoadPalettes
	call Func_10c5
	ret

PinballUpgradeTransitionPointers:
	dw TransitionToPokeBallPointers  ; POKE_BALL
	dw TransitionToPokeBallPointers  ; POKE_BALL
	dw TransitionToGreatBallPointers ; GREAT_BALL
	dw TransitionToUltraBallPointers ; ULTRA_BALL
	dw TransitionToUltraBallPointers ; ULTRA_BALL
	dw TransitionToMasterBallPointers ; MASTER_BALL

TransitionToPokeBallPointers:
	db 11
	dw TransitionToPokeBall_TileData_1
	dw TransitionToPokeBall_TileData_2
	dw TransitionToPokeBall_TileData_3
	dw TransitionToPokeBall_TileData_4
	dw TransitionToPokeBall_TileData_5
	dw TransitionToPokeBall_TileData_6
	dw TransitionToPokeBall_TileData_7
	dw TransitionToPokeBall_TileData_8
	dw TransitionToPokeBall_TileData_9
	dw TransitionToPokeBall_TileData_10
	dw TransitionToPokeBall_TileData_11

TransitionToGreatBallPointers:
	db 11
	dw TransitionToGreatBall_TileData_1
	dw TransitionToGreatBall_TileData_2
	dw TransitionToGreatBall_TileData_3
	dw TransitionToGreatBall_TileData_4
	dw TransitionToGreatBall_TileData_5
	dw TransitionToGreatBall_TileData_6
	dw TransitionToGreatBall_TileData_7
	dw TransitionToGreatBall_TileData_8
	dw TransitionToGreatBall_TileData_9
	dw TransitionToGreatBall_TileData_10
	dw TransitionToGreatBall_TileData_11

TransitionToUltraBallPointers:
	db 11
	dw TransitionToUltraBall_TileData_1
	dw TransitionToUltraBall_TileData_2
	dw TransitionToUltraBall_TileData_3
	dw TransitionToUltraBall_TileData_4
	dw TransitionToUltraBall_TileData_5
	dw TransitionToUltraBall_TileData_6
	dw TransitionToUltraBall_TileData_7
	dw TransitionToUltraBall_TileData_8
	dw TransitionToUltraBall_TileData_9
	dw TransitionToUltraBall_TileData_10
	dw TransitionToUltraBall_TileData_11

TransitionToMasterBallPointers:
	db 11
	dw TransitionToMasterBall_TileData_1
	dw TransitionToMasterBall_TileData_2
	dw TransitionToMasterBall_TileData_3
	dw TransitionToMasterBall_TileData_4
	dw TransitionToMasterBall_TileData_5
	dw TransitionToMasterBall_TileData_6
	dw TransitionToMasterBall_TileData_7
	dw TransitionToMasterBall_TileData_8
	dw TransitionToMasterBall_TileData_9
	dw TransitionToMasterBall_TileData_10
	dw TransitionToMasterBall_TileData_11

TransitionToPokeBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballPokeballGfx + $0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballPokeballGfx + $30
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballPokeballGfx + $60
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballPokeballGfx + $90
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballPokeballGfx + $c0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballPokeballGfx + $f0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballPokeballGfx + $120
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballPokeballGfx + $150
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballPokeballGfx + $180
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballPokeballGfx + $1b0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballPokeballGfx + $1e0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToGreatBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballGreatballGfx + $0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballGreatballGfx + $30
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballGreatballGfx + $60
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballGreatballGfx + $90
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballGreatballGfx + $c0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballGreatballGfx + $f0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballGreatballGfx + $120
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballGreatballGfx + $150
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballGreatballGfx + $180
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballGreatballGfx + $1b0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballGreatballGfx + $1e0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToUltraBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballUltraballGfx + $0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballUltraballGfx + $30
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballUltraballGfx + $60
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballUltraballGfx + $90
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballUltraballGfx + $c0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballUltraballGfx + $f0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballUltraballGfx + $120
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballUltraballGfx + $150
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballUltraballGfx + $180
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballUltraballGfx + $1b0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballUltraballGfx + $1e0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToMasterBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballMasterballGfx + $0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballMasterballGfx + $30
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballMasterballGfx + $60
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballMasterballGfx + $90
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballMasterballGfx + $c0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballMasterballGfx + $f0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballMasterballGfx + $120
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballMasterballGfx + $150
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballMasterballGfx + $180
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballMasterballGfx + $1b0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballMasterballGfx + $1e0
	db Bank(PinballMasterballGfx)
	db $00

Data_157f7:
	dw Data_15803
	dw Data_15803
	dw Data_1580a
	dw Data_15811
	dw Data_15811
	dw Data_15818

Data_15803:
	db $08, $04, $40, $68, $51, $37, $00
Data_1580a:
	db $08, $04, $40, $70, $51, $37, $00
Data_15811:
	db $08, $04, $40, $78, $51, $37, $00
Data_15818:
	db $08, $04, $40, $80, $51, $37, $00

ResolveRedStageBoardTriggerCollision: ; 0x1581f
	ld a, [wWhichBoardTrigger]
	and a
	ret z
	xor a
	ld [wWhichBoardTrigger], a
	ld bc, FivePoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wWhichBoardTriggerId]
	sub $11
	ld c, a
	ld b, $0
	ld hl, wd521
	add hl, bc
	ld [hl], $1
	ld a, [wd521]
	and a
	call nz, Func_1587c
	ld a, [wd522]
	and a
	call nz, Func_158c0
	ld a, [wd523]
	and a
	call nz, Func_15904
	ld a, [wd524]
	and a
	call nz, HandleLeftAlleyTriggerRedField
	ld a, [wd525]
	and a
	call nz, Func_15931
	ld a, [wd526]
	and a
	call nz, Func_15944
	ld a, [wd527]
	and a
	call nz, HandleRightAlleyTriggerRedField
	ld a, [wd528]
	and a
	call nz, Func_15990
	ret

Func_1587c: ; 0x1587c
	xor a
	ld [wd521], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba Func_10000
	ret c
	ld a, [wLeftAlleyCount]
	cp $3
	ret z
	inc a
	ld [wLeftAlleyCount], a
	set 7, a
	ld [wIndicatorStates], a
	cp $83
	ret nz
	ld a, [wStageCollisionState]
	and $1
	or $6
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

Func_158c0: ; 0x158c0
	xor a
	ld [wd522], a
	ld a, [wLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	callba Func_10000
	ret c
	ld a, [wLeftAlleyCount]
	cp $3
	ret z
	inc a
	ld [wLeftAlleyCount], a
	set 7, a
	ld [wIndicatorStates], a
	cp $83
	ret nz
	ld a, [wStageCollisionState]
	and $1
	or $6
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ret

Func_15904: ; 0x15904
	xor a
	ld [wd523], a
	ld a, [wSecondaryLeftAlleyTrigger]
	and a
	ret z
	xor a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $3
	callba Func_10000
	ret

HandleLeftAlleyTriggerRedField: ; 0x1591e
; Ball passed over the left alley trigger point in the Red Field.
	xor a
	ld [wd524], a
	ld [wRightAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wLeftAlleyTrigger], a
	call Func_159c9
	ret

Func_15931: ; 0x15931
	xor a
	ld [wd525], a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld a, $1
	ld [wSecondaryLeftAlleyTrigger], a
	call Func_159c9
	ret

Func_15944: ; 0x15944
	xor a
	ld [wd526], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba Func_10000
	ret c
	ld a, [wRightAlleyCount]
	cp $3
	ret z
	inc a
	ld [wRightAlleyCount], a
	cp $3
	jr z, .asm_1596e
	set 7, a
.asm_1596e
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

HandleRightAlleyTriggerRedField: ; 0x1597d
; Ball passed over the right alley trigger point in the Red Field.
	xor a
	ld [wd527], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld a, $1
	ld [wRightAlleyTrigger], a
	call Func_159c9
	ret

Func_15990: ; 0x15990
	xor a
	ld [wd528], a
	ld a, [wRightAlleyTrigger]
	and a
	ret z
	xor a
	ld [wRightAlleyTrigger], a
	ld a, $2
	callba Func_10000
	ret c
	ld a, [wRightAlleyCount]
	cp $3
	ret z
	inc a
	ld [wRightAlleyCount], a
	cp $3
	jr z, .asm_159ba
	set 7, a
.asm_159ba
	ld [wIndicatorStates + 1], a
	ld a, [wRightAlleyCount]
	cp $2
	ret c
	ld a, $80
	ld [wIndicatorStates + 3], a
	ret

Func_159c9: ; 0x159c9
	ld a, [wd7ad]
	bit 7, a
	ret nz
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	ld a, $ff
	ld [wd7ad], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	ld a, $1
	ld [wd580], a
	call Func_1404a
	ret

Func_159f4: ; 0x159f4
	ld a, [hLCDC]
	bit 7, a
	jr z, .asm_15a13
	ld a, [wd7f2]
	and $fe
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	cp c
	jr z, .asm_15a13
	add c
	cp $2
	jr z, .asm_15a13
	lb de, $00, $00
	call PlaySoundEffect
.asm_15a13
	ld a, [wd7f2]
	swap a
	ld c, a
	ld a, [wStageCollisionState]
	sla a
	or c
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_15a3f
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_15a2d
	ld hl, TileDataPointers_15d05
.asm_15a2d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_15a3f)
	call Func_10aa
	ld a, [wStageCollisionState]
	ld [wd7f2], a
	ret

TileDataPointers_15a3f:
	dw $0000
	dw TileData_15b71
	dw TileData_15b16
	dw TileData_15abf
	dw TileData_15b23
	dw TileData_15adc
	dw TileData_15b2a
	dw TileData_15af3
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b16
	dw $0000
	dw TileData_15b23
	dw $0000
	dw TileData_15b2a
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b71
	dw TileData_15b3d
	dw $0000
	dw TileData_15b50
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b82
	dw $0000
	dw $0000
	dw TileData_15b3d
	dw $0000
	dw TileData_15b50
	dw $0000
	dw $0000
	dw TileData_15b57
	dw $0000
	dw $0000
	dw TileData_15b71
	dw TileData_15b2a
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b57
	dw TileData_15b82
	dw $0000
	dw $0000
	dw TileData_15b2a
	dw $0000
	dw $0000
	dw TileData_15b6a
	dw $0000
	dw TileData_15b3d
	dw $0000
	dw $0000
	dw TileData_15b71
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15b6a
	dw $0000
	dw TileData_15b3d
	dw TileData_15b82
	dw $0000

TileData_15abf: ; 0x15abf
	db $e
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51

TileData_15adc: ; 0x15adc
	db $0b
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51
	dw TileData_15ce7
	dw TileData_15cf1
	dw TileData_15cfb

TileData_15af3: ; 0x15af3
	db $11
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51
	dw TileData_15cab
	dw TileData_15cb5
	dw TileData_15cbf

TileData_15b16: ; 0x15b16
	db $06
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5

TileData_15b23: ; 0x15b23
	db $03
	dw TileData_15ce7
	dw TileData_15cf1
	dw TileData_15cfb

TileData_15b2a: ; 0x15b2a
	db $09
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15cab
	dw TileData_15cb5
	dw TileData_15cbf

TileData_15b3d: ; 0x15b3d
	db $09
	dw TileData_15bcf
	dw TileData_15bd9
	dw TileData_15be3
	dw TileData_15bed
	dw TileData_15bf7
	dw TileData_15c01
	dw TileData_15ce7
	dw TileData_15cf1
	dw TileData_15cfb

TileData_15b50: ; 0x15b50
	db $03
	dw TileData_15cab
	dw TileData_15cb5
	dw TileData_15cbf

TileData_15b57: ; 0x15b57
	db $09
	dw TileData_15b93
	dw TileData_15b9d
	dw TileData_15ba7
	dw TileData_15bb1
	dw TileData_15bbb
	dw TileData_15bc5
	dw TileData_15cc9
	dw TileData_15cd3
	dw TileData_15cdd

TileData_15b6a: ; 0x15b6a
	db $03
	dw TileData_15cc9
	dw TileData_15cd3
	dw TileData_15cdd

TileData_15b71: ; 0x15b71
	db $08
	dw TileData_15c0b
	dw TileData_15c15
	dw TileData_15c1f
	dw TileData_15c29
	dw TileData_15c33
	dw TileData_15c3d
	dw TileData_15c47
	dw TileData_15c51

TileData_15b82: ; 0x15b82
	db $08
	dw TileData_15c5b
	dw TileData_15c65
	dw TileData_15c6f
	dw TileData_15c79
	dw TileData_15c83
	dw TileData_15c8d
	dw TileData_15c97
	dw TileData_15ca1

TileData_15b93: ; 0x15b93
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15b9d: ; 0x15b9d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15ba7: ; 0x15ba7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bb1: ; 0x15bb1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $90
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bbb: ; 0x15bbb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $50
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bc5: ; 0x15bc5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $53
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15bcf: ; 0x15bcf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldTopBaseGameBoyGfx + $9a0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15bd9: ; 0x15bd9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldTopBaseGameBoyGfx + $9d0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15be3: ; 0x15be3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4A
	dw StageRedFieldTopBaseGameBoyGfx + $a00
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15bed: ; 0x15bed
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4D
	dw StageRedFieldTopBaseGameBoyGfx + $a30
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15bf7: ; 0x15bf7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $50
	dw StageRedFieldTopBaseGameBoyGfx + $a60
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c01: ; 0x15c01
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $53
	dw StageRedFieldTopBaseGameBoyGfx + $a90
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c0b: ; 0x15c0b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $56
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $120
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c15: ; 0x15c15
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $59
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $150
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c1f: ; 0x15c1f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $180
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c29: ; 0x15c29
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c33: ; 0x15c33
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $62
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c3d: ; 0x15c3d
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $65
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $210
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c47: ; 0x15c47
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $66
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $620
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c51: ; 0x15c51
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $69
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $650
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15c5b: ; 0x15c5b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $56
	dw StageRedFieldTopBaseGameBoyGfx + $ac0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c65: ; 0x15c65
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $59
	dw StageRedFieldTopBaseGameBoyGfx + $af0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c6f: ; 0x15c6f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5C
	dw StageRedFieldTopBaseGameBoyGfx + $b20
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c79: ; 0x15c79
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5F
	dw StageRedFieldTopBaseGameBoyGfx + $b50
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c83: ; 0x15c83
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $62
	dw StageRedFieldTopBaseGameBoyGfx + $b80
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c8d: ; 0x15c8d
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $65
	dw StageRedFieldTopBaseGameBoyGfx + $bb0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15c97: ; 0x15c97
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $66
	dw StageRedFieldTopBaseGameBoyGfx + $bc0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15ca1: ; 0x15ca1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $69
	dw StageRedFieldTopBaseGameBoyGfx + $bf0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15cab: ; 0x15cab
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cb5: ; 0x15cb5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cbf: ; 0x15cbf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $72
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $310
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cc9: ; 0x15cc9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6C
	dw StageRedFieldTopBaseGameBoyGfx + $c20
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15cd3: ; 0x15cd3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6F
	dw StageRedFieldTopBaseGameBoyGfx + $c50
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15cdd: ; 0x15cdd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $72
	dw StageRedFieldTopBaseGameBoyGfx + $c80
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_15ce7: ; 0x15ce7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $220
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cf1: ; 0x15cf1
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $6F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $250
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_15cfb: ; 0x15cfb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $72
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $280
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_15d05:
	dw $0000
	dw TileData_15db1
	dw TileData_15d96
	dw TileData_15d85
	dw TileData_15d99
	dw TileData_15d8a
	dw TileData_15d9c
	dw TileData_15d8f
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15d96
	dw $0000
	dw TileData_15d99
	dw $0000
	dw TileData_15d9c
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15db1
	dw TileData_15da1
	dw $0000
	dw TileData_15da6
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15db4
	dw $0000
	dw $0000
	dw TileData_15da1
	dw $0000
	dw TileData_15da6
	dw $0000
	dw $0000
	dw TileData_15da9
	dw $0000
	dw $0000
	dw TileData_15db1
	dw TileData_15d9c
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15da9
	dw TileData_15db4
	dw $0000
	dw $0000
	dw TileData_15d9c
	dw $0000
	dw $0000
	dw TileData_15dae
	dw $0000
	dw TileData_15da1
	dw $0000
	dw $0000
	dw TileData_15db1
	dw $0000
	dw $0000
	dw $0000
	dw TileData_15dae
	dw $0000
	dw TileData_15da1
	dw TileData_15db4
	dw $0000

TileData_15d85: ; 0x15d85
	db $02
	dw TileData_15db7
	dw TileData_15df2

TileData_15d8a: ; 0x15d8a
	db $02
	dw TileData_15df2
	dw TileData_15e82

TileData_15d8f: ; 0x15d8f
	db $03
	dw TileData_15db7
	dw TileData_15df2
	dw TileData_15e50

TileData_15d96: ; 0x15d96
	db $01
	dw TileData_15db7

TileData_15d99: ; 0x15d99
	db $01
	dw TileData_15e82

TileData_15d9c: ; 0x15d9c
	db $02
	dw TileData_15db7
	dw TileData_15e50

TileData_15da1: ; 0x15da1
	db $02
	dw TileData_15dd5
	dw TileData_15e82

TileData_15da6: ; 0x15da6
	db $01
	dw TileData_15e50

TileData_15da9: ; 0x15da9
	db $02
	dw TileData_15db7
	dw TileData_15e69

TileData_15dae: ; 0x15dae
	db $01
	dw TileData_15e69

TileData_15db1: ; 0x15dab1
	db $01
	dw TileData_15df2

TileData_15db4: ; 0x15db4
	db $01
	dw TileData_15e21

TileData_15db7: ; 0x15db7
	dw Func_1198

	db ($a << 1)
	db $03
	dw vBGMap + $4c

	db ($40 << 1)
	db $09
	dw vBGMap + $6c

	db (($32 << 1) | 1)
	db $08
	dw vBGMap + $8d

	db (4 << 1)
	dw vBGMap + $ae

	db (2 << 1)
	dw vBGMap + $d0

	db (2 << 1)
	dw vBGMap + $f1

	db (2 << 1)
	dw vBGMap + $111

	db (1 << 1)
	dw vBGMap + $132

	db $00 ; terminator

TileData_15dd5: ; 0x15dd5
	dw Func_1198

	db ($a << 1)
	db $03
	dw vBGMap + $4c

	db (($28 << 1) | 1)
	db $08
	dw vBGMap + $6c

	db ($4 << 1)
	dw vBGMap + $8d

	db ($04 << 1)
	dw vBGMap + $ae

	db ($02 << 1)
	dw vBGMap + $d0

	db ($02 << 1)
	dw vBGMap + $f1

	db ($02 << 1)
	dw vBGMap + $111

	db (1 << 1)
	dw vBGMap + $132

	db $00 ; terminator

TileData_15df2: ; 0x15df2
	dw LoadTileLists
	db $19 ; total number of tiles

	db $05 ; number of tiles
	dw vBGMap + $a9
	db $1e, $1f, $20, $21, $22

	db $07
	dw vBGMap + $c7
	db $23, $24, $39, $3a, $25, $3b, $26

	db $08 ; number of tiles
	dw vBGMap + $e6
	db $27, $37, $28, $29, $2a, $2b, $3c, $2c

	db $03 ; number of tiles
	dw vBGMap + $106
	db $2d, $38, $2e

	db $01 ; number of tiles
	dw vBGMap + $10d
	db $2f

	db $01 ; number of tiles
	dw vBGMap + $126
	db $30

	db 00 ; terminator

TileData_15e21: ; 0x15e21
	dw LoadTileLists
	db $19 ; total number of tiles

	db $05 ; number of tiles
	dw vBGMap + $a9
	db $0b, $0c, $0d, $0e, $0f

	db $07
	dw vBGMap + $c7
	db $10, $11, $33, $34, $12, $35, $13

	db $08 ; number of tiles
	dw vBGMap + $e6
	db $14, $31, $15, $16, $17, $18, $36, $19

	db $03 ; number of tiles
	dw vBGMap + $106
	db $1a, $32, $1b

	db $01 ; number of tiles
	dw vBGMap + $10d
	db $1c

	db $01 ; number of tiles
	dw vBGMap + $126
	db $1d

	db 00 ; terminator

TileData_15e50: ; 0x15e50
	dw LoadTileLists
	db $09 ; total number of tiles
	
	db $03 ; number of tiles
	dw vBGMap + $100
	db $45, $46, $22

	db $02 ; number of tiles
	dw vBGMap + $120
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $140
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $160
	db $45, $46

	db $00 ; terminator

TileData_15e69: ; 0x15e69
	dw LoadTileLists
	db $09 ; total number of tiles
	
	db $03 ; number of tiles
	dw vBGMap + $100
	db $43, $44, $22

	db $02 ; number of tiles
	dw vBGMap + $120
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $140
	db $45, $46

	db $02 ; number of tiles
	dw vBGMap + $160
	db $45, $46

	db $00 ; terminator

TileData_15e82: ; 0x15e82
	dw Func_1198

	db ((4 << 1) | 1)
	db $07
	dw vBGMap + $100

	db (($23 << 1) | 1)
	db $04
	dw vBGMap + $120

	db (2 << 1)
	dw vBGMap + $140

	db (2 << 1)
	dw vBGMap + $160

	db $00 ; terminator

ResolveBellsproutCollision: ; 0x15e93
	ld a, [wBellsproutCollision]
	and a
	jr z, .asm_15eda
	xor a
	ld [wBellsproutCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $05
	call PlaySoundEffect
	ld hl, BellsproutAnimationData
	ld de, wBellsproutAnimationFrameCounter
	call CopyHLToDE
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $7c
	ld [wBallXPos + 1], a
	ld a, $78
	ld [wBallYPos + 1], a
	xor a
	ld [wd549], a
.asm_15eda
	ld hl, BellsproutAnimationData
	ld de, wBellsproutAnimationFrameCounter
	call UpdateAnimation
	push af
	ld a, [wBellsproutAnimationFrameCounter]
	and a
	jr nz, .asm_15ef8
	ld a, $19
	ld [wBellsproutAnimationFrameCounter], a
	xor a
	ld [wBellsproutAnimationFrame], a
	ld a, $6
	ld [wBellsproutAnimationFrameIndex], a
.asm_15ef8
	pop af
	ret nc
	ld a, [wBellsproutAnimationFrameIndex]
	cp $1
	jr nz, .asm_15f35
	xor a
	ld [wd548], a
	ld a, [wRightAlleyCount]
	cp $2
	jr c, .noCatchEmMode
	ld a, $8
	jr nz, .startCatchEmMode
	xor a
.startCatchEmMode
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
.noCatchEmMode
	ld hl, wNumBellsproutEntries
	call Increment_Max100
	ret nc
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplier
	ret

.asm_15f35
	ld a, [wBellsproutAnimationFrameIndex]
	cp $4
	jr nz, .asm_15f42
	ld a, $1
	ld [wd548], a
	ret

.asm_15f42
	ld a, [wBellsproutAnimationFrameIndex]
	cp $5
	ret nz
	ld a, $1
	ld [wd549], a
	xor a
	ld [wBallXVelocity + 1], a
	ld a, $2
	ld [wBallYVelocity + 1], a
	lb de, $00, $06
	call PlaySoundEffect
	ld a, $5
	callba Func_10000
	ret

BellsproutAnimationData: ; 0x15f69
; Each entry is [duration][OAM id]
	db $08, $01
	db $06, $02
	db $20, $03
	db $06, $02
	db $08, $01
	db $01, $00
	db $29, $00
	db $28, $01
	db $2A, $00
	db $27, $01
	db $29, $00
	db $28, $01
	db $2B, $00
	db $28, $01
	db $00  ; terminator

Func_15f86: ; 0x15f86
	ld a, [wWhichBumper]
	and a
	jr z, .asm_15f99
	call Func_5fb8
	call Func_15fa6
	xor a
	ld [wWhichBumper], a
	call Func_15fda
.asm_15f99
	ld a, [wd4da]
	and a
	ret z
	dec a
	ld [wd4da], a
	call z, Func_5fb8
	ret

Func_15fa6: ; 0x15fa6
	ld a, $10
	ld [wd4da], a
	ld a, [wWhichBumperId]
	sub $6
	ld [wd4db], a
	sla a
	inc a
	jr asm_15fc0

Func_5fb8: ; 0x5fb8
	ld a, [wd4db]
	cp $ff
	ret z
	sla a
asm_15fc0
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_16010
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_15fd0
	ld hl, Data_16080
.asm_15fd0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_16010)
	call Func_10aa
	ret

Func_15fda: ; 0x15fda
	ld a, $ff
	ld [wd803], a
	ld a, $3
	ld [wd804], a
	ld hl, $0200
	ld a, l
	ld [wFlipperYForce], a
	ld a, h
	ld [wFlipperYForce + 1], a
	ld a, $80
	ld [wFlipperCollision], a
	ld a, [wWhichBumperId]
	sub $6
	ld c, a
	ld b, $0
	ld hl, CollisionAngleDeltas_1600e
	add hl, bc
	ld a, [wCollisionForceAngle]
	add [hl]
	ld [wCollisionForceAngle], a
	lb de, $00, $0b
	call PlaySoundEffect
	ret

CollisionAngleDeltas_1600e:
	db -8, 8

TileDataPointers_16010:
	dw TileData_16018
	dw TileData_1601b
	dw TileData_1601e
	dw TileData_16021

TileData_16018: ; 0x16018
	db $01
	dw TileData_16024

TileData_1601b: ; 0x1601b
	db $01
	dw TileData_1603B

TileData_1601e: ; 0x1601e
	db $01
	dw TileData_16052

TileData_16021: ; 0x16021
	db $01
	dw TileData_16069

TileData_16024: ; 0x16024
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $60

	db $02 ; number of tiles
	dw vBGMap + $144
	db $61, $62

	db $02 ; number of tiles
	dw vBGMap + $164
	db $63, $64

	db $02 ; number of tiles
	dw vBGMap + $185
	db $65, $66

	db $00 ; terminator

TileData_1603B: ; 0x1603B
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $67

	db $02 ; number of tiles
	dw vBGMap + $144
	db $68, $69

	db $02 ; number of tiles
	dw vBGMap + $164
	db $6A, $6B

	db $02 ; number of tiles
	dw vBGMap + $185
	db $6C, $6D

	db $00 ; terminator

TileData_16052: ; 0x16052
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $6E

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $6F, $70

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $71, $72

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $73, $74

	db $00 ; terminator

TileData_16069: ; 0x16069
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $75

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $76, $77

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $78, $79

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $7A, $7B

	db $00 ; terminator

Data_16080:
	dw Data_16088
	dw Data_1608b
	dw Data_1608e
	dw Data_16091

Data_16088: ; 0x16088
	db $01
	dw Data_16094

Data_1608b: ; 0x1608b
	db $01
	dw Data_160ab

Data_1608e: ; 0x1608e
	db $01
	dw Data_160c2

Data_16091: ; 0x16091
	db $01
	dw Data_160d9

Data_16094: ; 0x16094
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $2A

	db $02 ; number of tiles
	dw vBGMap + $144
	db $2B, $2C

	db $02 ; number of tiles
	dw vBGMap + $164
	db $2D, $2E

	db $02 ; number of tiles
	dw vBGMap + $185
	db $2F, $30

	db $00 ; terminator

Data_160ab: ; 0x160ab
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $124
	db $31

	db $02 ; number of tiles
	dw vBGMap + $144
	db $32, $33

	db $02 ; number of tiles
	dw vBGMap + $164
	db $34, $35

	db $02 ; number of tiles
	dw vBGMap + $185
	db $36, $37

	db $00 ; terminator

Data_160c2: ; 0x160c2
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $2A

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $2C, $2B

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $2E, $2D

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $30, $2F

	db $00 ; terminator

Data_160d9: ; 0x160d9
	dw LoadTileLists
	db $07 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $12F
	db $31

	db $02 ; number of tiles
	dw vBGMap + $14E
	db $33, $32

	db $02 ; number of tiles
	dw vBGMap + $16E
	db $35, $34

	db $02 ; number of tiles
	dw vBGMap + $18D
	db $37, $36

	db $00 ; terminator

ResolveDittoSlotCollision: ; 0x160f0
	ld a, [wDittoSlotCollision]
	and a
	jr z, .asm_16137
	xor a
	ld [wDittoSlotCollision], a
	ld bc, TenThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	lb de, $00, $21
	call PlaySoundEffect
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd549], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $11
	ld [wBallXPos + 1], a
	ld a, $23
	ld [wBallYPos + 1], a
	ld a, $10
	ld [wd600], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
.asm_16137
	ld a, [wd600]
	and a
	ret z
	dec a
	ld [wd600], a
	cp $f
	jr nz, .asm_1614f
	callba LoadMiniBallGfx
	ret

.asm_1614f
	cp $c
	jr nz, .asm_1615e
	callba Func_dd62
	ret

.asm_1615e
	cp $9
	jr nz, .asm_1616d
	xor a
	ld [wd548], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_1616d
	cp $6
	jr nz, .asm_1618e
	callba Func_10ab3
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	ret

.asm_1618e
	cp $3
	jr nz, .asm_1619d
	callba LoadMiniBallGfx
	ret

.asm_1619d
	and a
	ret nz
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ret

Func_161af: ; 0x161af
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $fe
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
	jr asm_1620f

Func_161e0: ; 0x161e0
	ld a, [wd604]
	and a
	ret z
	ld a, [wBallYPos + 1]
	sub $86
	cp $30
	ret nc
	ld c, $0
	ld b, a
	ld h, b
	ld l, c
	srl b
	rr c
	srl b
	rr c
	srl h
	rr l
	add hl, bc
	ld a, [wBallXPos + 1]
	sub $38
	cp $30
	ret nc
	ld c, a
	ld b, $0
	sla c
	sla c
	add hl, bc
asm_1620f: ; 0x1620f
	ld bc, BallPhysicsData_f0000
	add hl, bc
	ld de, wBallXVelocity
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	push bc
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld c, a
	ld a, [de]
	add c
	ld [de], a
	inc de
	inc hl
	ld a, BANK(BallPhysicsData_f0000)
	call ReadByteFromBank
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	inc de
	inc hl
	bit 7, b
	jr z, .asm_1624e
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	inc bc
.asm_1624e
	pop hl
	bit 7, h
	jr z, .asm_1625a
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	inc hl
.asm_1625a
	add hl, bc
	sla l
	rl h
	ld a, h
	cp $2
	ret c
	ld a, [wd804]
	and a
	ret nz
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	lb de, $00, $04
	call PlaySoundEffect
	ret

Func_16279: ; 0x16279
	ld a, [wSlotCollision]
	and a
	jr z, .asm_162ae
	xor a
	ld [wSlotCollision], a
	ld a, [wd604]
	and a
	ret z
	ld a, [wd603]
	and a
	jr nz, .asm_162ae
	xor a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wd549], a
	ld [wBallXPos], a
	ld [wBallYPos], a
	ld a, $50
	ld [wBallXPos + 1], a
	ld a, $16
	ld [wBallYPos + 1], a
	ld a, $13
	ld [wd603], a
.asm_162ae
	ld a, [wd603]
	and a
	ret z
	dec a
	ld [wd603], a
	ld a, $18
	ld [wd606], a
	ld a, [wd603]
	cp $12
	jr nz, .asm_162d4
	lb de, $00, $21
	call PlaySoundEffect
	callba LoadMiniBallGfx
	ret

.asm_162d4
	cp $f
	jr nz, .asm_162e3
	callba Func_dd62
	ret

.asm_162e3
	cp $c
	jr nz, .asm_162f2
	xor a
	ld [wd548], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ret

.asm_162f2
	cp $9
	jr nz, .asm_162fa
	call Func_16352
	ret

.asm_162fa
	cp $6
	jr nz, .asm_16317
	xor a
	ld [wd604], a
	ld a, $5
	ld [wd803], a
	ld a, $8
	ld [wd804], a
	callba LoadMiniBallGfx
	ret

.asm_16317
	cp $3
	jr nz, .asm_16330
	callba LoadBallGfx
	ld a, $2
	ld [wBallYVelocity + 1], a
	ld a, $80
	ld [wBallXVelocity], a
	ret

.asm_16330
	and a
	ret nz
	call Func_16425
	ld a, [wCatchEmOrEvolutionSlotRewardActive]
	cp CATCHEM_MODE_SLOT_REWARD
	ret nz
	call GenRandom
	and $8
	ld [wRareMonsFlag], a
	callba StartCatchEmMode
	xor a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

Func_16352: ; 0x16352
	xor a
	ld [wIndicatorStates + 4], a
	ld a, $d
	callba Func_10000
	jr nc, .asm_1636d
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ret

.asm_1636d
	ld a, [wd624]
	cp $3
	jr nz, .asm_163b3
	ld a, [wd607]
	and a
	jr nz, .asm_163b3
.asm_1637a
	ld a, [wBonusStageSlotRewardActive]
	and a
	jr nz, .asm_16389
	xor a
	ld [wd625], a
	ld a, $40
	ld [wd626], a
.asm_16389
	xor a
	ld [wBonusStageSlotRewardActive], a
	ld a, $1
	ld [wd495], a
	ld [wd4ae], a
	ld a, [wd498]
	ld c, a
	ld b, $0
	ld hl, GoToBonusStageTextIds_RedField
	add hl, bc
	ld a, [hl]
	ld [wd497], a
	call Func_163f2
	xor a
	ld [wd609], a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ld a, $1e
	ld [wd607], a
	ret

.asm_163b3
	callba Func_ed8e
	xor a
	ld [wd608], a
	ld a, [wd61d]
	cp $d
	jr nc, .asm_1637a
	ld a, $1
	ld [wd548], a
	ld [wd549], a
	ld a, [wCatchEmOrEvolutionSlotRewardActive]
	cp EVOLUTION_MODE_SLOT_REWARD
	ret nz
	callba Func_10ab3
	ld a, [wd7ad]
	ld c, a
	ld a, [wStageCollisionState]
	and $1
	or c
	ld [wStageCollisionState], a
	xor a
	ld [wCatchEmOrEvolutionSlotRewardActive], a
	ret

Func_163f2: ; 0x163f2
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5dc
	ld a, [wd497]
	ld de, GoToDiglettStageText
	cp STAGE_DIGLETT_BONUS
	jr z, .asm_1640f
	ld de, GoToGengarStageText
	cp STAGE_GENGAR_BONUS
	jr z, .asm_1640f
	ld de, GoToMewtwoStageText
.asm_1640f
	call LoadTextHeader
	ld de, $0000
	call PlaySong
	rst AdvanceFrame
	lb de, $3c, $23
	call PlaySoundEffect
	ret

GoToBonusStageTextIds_RedField:
	db STAGE_GENGAR_BONUS
	db STAGE_MEWTWO_BONUS
	db STAGE_MEOWTH_BONUS
	db STAGE_DIGLETT_BONUS
	db STAGE_SEEL_BONUS

Func_16425: ; 0x16425
	ld a, [wCurrentStage]
	and $1
	sla a
	ld c, a
	ld a, [wd604]
	add c
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1644d
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_16441
	ld hl, TileDataPointers_164a1
.asm_16441
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1644d)
	call Func_10aa
	ret

TileDataPointers_1644d:
	dw TileData_16455
	dw TileData_16458
	dw TileData_1645b
	dw TileData_16460

TileData_16455: ; 0x16455
	db $01
	dw TileData_16465

TileData_16458: ; 0x16458
	db $01
	dw TileData_1646f

TileData_1645b: ; 0x1645b
	db $02
	dw TileData_16479
	dw TileData_16483

TileData_16460: ; 0x16460
	db $02
	dw TileData_1648D
	dw TileData_16497

TileData_16465: ; 0x16465
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldTopBaseGameBoyGfx + $1c0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_1646f: ; 0x1646f
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $340
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16479: ; 0x16479
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $48
	dw StageRedFieldBottomBaseGameBoyGfx + $c80
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16483: ; 0x16483
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $4A
	dw StageRedFieldBottomBaseGameBoyGfx + $CA0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_1648D: ; 0x1648D
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $340
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16497: ; 0x16497
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $4A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $360
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_164a1:
	dw TileData_164a9
	dw TileData_164ac
	dw TileData_164af
	dw TileData_164b2

TileData_164a9: ; 0x164a9
	db $01
	dw TileData_164b5

TileData_164ac: ; 0x164ac
	db $01
	dw TileData_164be

TileData_164af: ; 0x164af
	db $01
	dw TileData_164c7

TileData_164b2: ; 0x164b2
	db $01
	dw TileData_164d5

TileData_164b5: ; 0x164b5
	dw LoadTileLists
	db $02

	db $02
	dw vBGMap + $229
	db $d4, $d5

	db $00

TileData_164be: ; 0x164be
	dw LoadTileLists
	db $02

	db $02

	dw vBGMap + $229
	db $d6, $d7

	db $00

TileData_164c7: ; 0x164c7
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $9
	db $38, $39

	db $02
	dw vBGMap + $29
	db $3a, $3b

	db $00

TileData_164d5: ; 0x164d5
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $9
	db $3c, $3d

	db $02
	dw vBGMap + $29
	db $3e, $3f

	db $00

Func_164e3: ; 0x164e3
	ld a, [wd607]
	and a
	ret z
	dec a
	ld [wd607], a
	ret nz
	ld a, [wInSpecialMode]
	and a
	ret nz
	ld a, [wd609]
	and a
	jr z, .asm_164ff
	ld a, [wd498]
	add $15
	jr .asm_16506

.asm_164ff
	ld a, [wd608]
	and a
	ret z
	ld a, $1a
.asm_16506
	ld hl, wCurrentStage
	bit 0, [hl]
	callba nz, LoadBillboardTileData
	ld a, [wd604]
	and a
	ret nz
	ld a, $1
	ld [wd604], a
	ld a, $80
	ld [wIndicatorStates + 4], a
	ld a, [wCurrentStage]
	bit 0, a
	call nz, Func_16425
	ret

Func_1652d: ; 0x1652d
	ld a, [wPinballLaunchAlley]
	and a
	ret z
	xor a
	ld [wPinballLaunchAlley], a
	ld a, [wd4de]
	and a
	jr z, .asm_16566
	xor a
	ld [wRightAlleyTrigger], a
	ld [wLeftAlleyTrigger], a
	ld [wSecondaryLeftAlleyTrigger], a
	ld hl, wBallXVelocity
	ld [hli], a
	ld [hl], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld a, $80
	ld [wBallYVelocity], a
	ld a, $fa
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	lb de, $00, $0a
	call PlaySoundEffect
.asm_16566
	ld a, $ff
	ld [wPreviousTriggeredGameObject], a
	ld a, [wd4de]
	and a
	ret nz
	ld a, [wd4e0]
	and a
	jr nz, .asm_16582
	call Func_1658f
	ld a, $1
	ld [wd4e0], a
	ld [wd4de], a
	ret

.asm_16582
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	ret z
	ld a, $1
	ld [wd4de], a
	ret

Func_1658f: ; 0x1658f
	ld a, [hGameBoyColorFlag]
	and a
	callba nz, LoadGreyBillboardPaletteData
.showNextMap
	ld a, [wInitialMapSelectionIndex]
	inc a
	cp $7  ; number of maps to choose from at the start of play
	jr c, .gotMapId
	xor a  ; wrap around to 0
.gotMapId
	ld [wInitialMapSelectionIndex], a
	ld c, a
	ld b, $0
	ld hl, RedStageInitialMaps
	add hl, bc
	ld a, [hl]
	ld [wCurrentMap], a
	push af
	lb de, $00, $48
	call PlaySoundEffect
	pop af
	add (PalletTownPic_Pointer - BillboardPicturePointers) / 3 ; map billboard pictures start at the $29th entry in BillboardPicturePointers
	callba LoadBillboardPicture
	ld b, $20  ; number of frames to delay before the next map is shown
.waitOnCurrentMap
	push bc
	callba Func_eeee
	ld hl, wKeyConfigBallStart
	call IsKeyPressed
	jr nz, .ballStartKeyPressed
	pop bc
	dec b
	jr nz, .waitOnCurrentMap
	jr .showNextMap

.ballStartKeyPressed
	pop bc
	callba LoadMapBillboardTileData
	ld bc, StartFromMapText
	callba Func_3118f
	ld a, [wCurrentMap]
	ld [wd4e3], a
	xor a
	ld [wd4e2], a
	ret

RedStageInitialMaps: ; 0x16605
	db PALLET_TOWN
	db VIRIDIAN_FOREST
	db PEWTER_CITY
	db CERULEAN_CITY
	db VERMILION_SEASIDE
	db ROCK_MOUNTAIN
	db LAVENDER_TOWN

ResolveRedStagePikachuCollision: ; 0x1660c
	ld a, [wWhichPikachu]
	and a
	jr z, .asm_1667b
	xor a
	ld [wWhichPikachu], a
	ld a, [wd51c]
	and a
	jr nz, .asm_1667b
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	jr nz, .asm_16634
	ld a, [wWhichPikachuId]
	sub $1c
	ld hl, wd518
	cp [hl]
	jr nz, .asm_1667b
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	jr nz, .asm_16667
.asm_16634
	ld hl, PikachuSaverAnimationDataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call CopyHLToDE
	ld a, [wPikachuSaverSlotRewardActive]
	and a
	jr nz, .asm_16647
	xor a
	ld [wPikachuSaverCharge], a
.asm_16647
	ld a, $1
	ld [wd51c], a
	xor a
	ld [wBallXVelocity], a
	ld [wBallXVelocity + 1], a
	ld [wBallYVelocity], a
	ld [wBallYVelocity + 1], a
	ld [wBallSpin], a
	ld [wBallRotation], a
	ld [wd549], a
	call FillBottomMessageBufferWithBlackTile
	jr .asm_1667b

.asm_16667
	ld hl, PikachuSaverAnimation2DataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call CopyHLToDE
	ld a, $2
	ld [wd51c], a
	lb de, $00, $3b
	call PlaySoundEffect
.asm_1667b
	ld a, [wd51c]
	and a
	call z, Func_16766
	call Func_1669e
	ld a, [wPikachuSaverCharge]
	cp MAX_PIKACHU_SAVER_CHARGE
	ret nz
	ld a, [wd51e]
	and a
	ret z
	dec a
	ld [wd51e], a
	cp $5a
	ret nz
	lb de, $0f, $22
	call PlaySoundEffect
	ret

Func_1669e: ; 0x1669e
	ld a, [wd51c]
	cp $1
	jr nz, .asm_16719
	ld hl, PikachuSaverAnimationDataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $1
	jr nz, .asm_166f7
	xor a
	ld [wd85d], a
	call Func_310a
	rst AdvanceFrame
	ld a, $1
	callba PlayPikachuSoundClip
	ld a, $1
	ld [wd85d], a
	ld a, $ff
	ld [wd803], a
	ld a, $60
	ld [wd804], a
	ld hl, wd62e
	call Increment_Max100
	jr nc, .asm_166f0
	ld c, $a
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_166f0
	lb de, $16, $10
	call PlaySoundEffect
	ret

.asm_166f7
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $11
	ret nz
	ld a, $fc
	ld [wBallYVelocity + 1], a
	ld a, $1
	ld [wd549], a
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	xor a
	ld [wd51c], a
	ret

.asm_16719
	cp $2
	jr nz, .asm_16732
	ld hl, PikachuSaverAnimation2DataBlueStage
	ld de, wPikachuSaverAnimationFrameCounter
	call UpdateAnimation
	ret nc
	ld a, [wPikachuSaverAnimationFrameIndex]
	cp $1
	ret nz
	xor a
	ld [wd51c], a
	ret

.asm_16732
	ld a, [hNumFramesDropped]
	swap a
	and $1
	ld [wPikachuSaverAnimationFrame], a
	ret

PikachuSaverAnimationDataBlueStage: ; 0x1673c
; Each entry is [duration][OAM id]
	db $0C, $02
	db $05, $03
	db $05, $02
	db $05, $04
	db $05, $05
	db $05, $02
	db $06, $06
	db $06, $07
	db $06, $08
	db $06, $02
	db $06, $05
	db $06, $08
	db $06, $07
	db $06, $02
	db $06, $08
	db $06, $07
	db $06, $02
	db $01, $00
	db $00

PikachuSaverAnimation2DataBlueStage: ; 0x16761
; Each entry is [duration][OAM id]
	db $0C, $02
	db $01, $00
	db $00

Func_16766: ; 0x16766
	ld hl, wKeyConfigLeftFlipper
	call IsKeyPressed2
	jr z, .asm_16774
	ld hl, wd518
	ld [hl], $0
	ret

.asm_16774
	ld hl, wKeyConfigRightFlipper
	call IsKeyPressed2
	ret z
	ld hl, wd518
	ld [hl], $1
	ret

ResolveStaryuCollision: ; 0x16781
	ld a, [wStaryuCollision]
	and a
	jr z, .asm_167bd
	xor a
	ld [wStaryuCollision], a
	ld a, [wd503]
	and a
	jr nz, .asm_167c2
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd502]
	xor $1
	set 1, a
	ld [wd502], a
	ld a, $14
	ld [wd503], a
	call Func_16859
	ld a, $6
	callba Func_10000
	ret

.asm_167bd
	ld a, [wd503]
	and a
	ret z
.asm_167c2
	dec a
	ld [wd503], a
	ret nz
	ld a, [wd502]
	res 1, a
	ld [wd502], a
	call Func_16859
	ld a, [wd502]
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	callba LoadStageCollisionAttributes
	call Func_159f4
	lb de, $00, $07
	call PlaySoundEffect
	ld a, [wStageCollisionState]
	bit 0, a
	jp nz, Func_15450
	jp Func_15499

Func_167ff: ; 0x167ff
	ld a, [wStaryuCollision]
	and a
	jr z, .asm_16839
	xor a
	ld [wStaryuCollision], a
	ld a, [wd503]
	and a
	jr nz, .asm_1683e
	ld bc, FiveThousandPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd502]
	xor $1
	ld [wd502], a
	ld a, $14
	ld [wd503], a
	call Func_16878
	ld a, $6
	callba Func_10000
	ret

.asm_16839
	ld a, [wd503]
	and a
	ret z
.asm_1683e
	dec a
	ld [wd503], a
	ret nz
	ld a, [wd502]
	and $1
	ld c, a
	ld a, [wStageCollisionState]
	and $fe
	or c
	ld [wStageCollisionState], a
	lb de, $00, $07
	call PlaySoundEffect
	ret

Func_16859: ; 0x16859
	ld a, [wd502]
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_16899
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1686c
	ld hl, TileDataPointers_16910
.asm_1686c
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_16899)
	call Func_10aa
	ret

Func_16878: ; 0x16878
	ld a, [wd502]
	and $1
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_1695a
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_1688d
	ld hl, TileDataPointers_16980
.asm_1688d
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, Bank(TileDataPointers_1695a)
	call Func_10aa
	ret

TileDataPointers_16899:
	dw TileData_168a1
	dw TileData_168a8
	dw TileData_168af
	dw TileData_168af

TileData_168a1: ; 0x168a1
	db $03
	dw TileData_168b6
	dw TileData_168c0
	dw TileData_168ca

TileData_168a8: ; 0x168a8
	db $03
	dw TileData_168d4
	dw TileData_168de
	dw TileData_168e8

TileData_168af: ; 0x168af
	db $03
	dw TileData_168f2
	dw TileData_168fc
	dw TileData_16906

TileData_168b6: ; 0x168b6
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $50
	dw StageRedFieldTopBaseGameBoyGfx + $260
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168c0: ; 0x168c0
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $53
	dw StageRedFieldTopBaseGameBoyGfx + $290
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168ca: ; 0x168ca
	dw Func_11d2
	db $10, $01
	dw vTilesSH tile $56
	dw StageRedFieldTopBaseGameBoyGfx + $2c0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168d4: ; 0x168d4
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $52
	dw StageRedFieldTopBaseGameBoyGfx + $280
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168de: ; 0x168de
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $55
	dw StageRedFieldTopBaseGameBoyGfx + $2b0
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileData_168e8: ; 0x168e8
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $50
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $EA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_168f2: ; 0x168f2
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $10E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_168fc: ; 0x168fc
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $54
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1110
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16906: ; 0x16906
	dw Func_11d2
	db $10, $01
	dw vTilesSH tile $50
	dw StageRedFieldTopBaseGameBoyGfx + $260
	db Bank(StageRedFieldTopBaseGameBoyGfx)
	db $00

TileDataPointers_16910:
	dw TileData_16918
	dw TileData_1691b
	dw TileData_1691e
	dw TileData_1691e

TileData_16918: ;0x16918
	db $01
	dw TileData_16921

TileData_1691b: ;0x1691b
	db $01
	dw TileData_16934

TileData_1691e: ;0x1691e
	db $01
	dw TileData_16947

TileData_16921: ; 0x16921
	dw LoadTileLists
	db $06

	db $03
	dw vBGMap + $1C6
	db $C3, $C4, $C5

	db $02
	dw vBGMap + $1E7
	db $C6, $C7

	db $01
	dw vBGMap + $207
	db $C8

	db $00

TileData_16934: ; 0x16934
	dw LoadTileLists
	db $06

	db $03
	dw vBGMap + $1C6
	db $CD, $CE, $C5

	db $02
	dw vBGMap + $1E7
	db $C6, $C7

	db $01
	dw vBGMap + $207
	db $C8

	db $00

TileData_16947: ; 0x16947
	dw LoadTileLists
	db $06

	db $03
	dw vBGMap + $1C6
	db $C3, $C4, $C9

	db $02
	dw vBGMap + $1E7
	db $CA, $CB

	db $01
	dw vBGMap + $207
	db $CC

	db $00

TileDataPointers_1695a:
	dw TileData_1695e
	dw TileData_16961

TileData_1695e: ; 0x1695e
	db $01
	dw TileData_16964

TileData_16961: ; 0x16961
	db $01
	dw TileData_16972

TileData_16964: ; 0x16964
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $BE, $BF

	db $02
	dw vBGMap + $60
	db $C0, $C1

	db $00

TileData_16972: ; 0x16972
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $C2, $C3

	db $02
	dw vBGMap + $60
	db $C4, $C5

	db $00

TileDataPointers_16980:
	dw TileData_16984
	dw TileData_16987

TileData_16984: ; 0x16984
	db $01
	dw TileData_1698a

TileData_16987: ; 0x16987
	db $01
	dw TileData_16998

TileData_1698a: ; 0x1698a
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $BC, $BD

	db $02
	dw vBGMap + $60
	db $BE, $BF

	db $00

TileData_16998: ; 0x16998
	dw LoadTileLists
	db $04

	db $02
	dw vBGMap + $40
	db $C0, $C1

	db $02
	dw vBGMap + $60
	db $C2, $C3

	db $00

Func_169a6: ; 0x169a6
	ld a, [hNumFramesDropped]
	and $1f
	ret nz
	ld bc, $0000
.asm_169ae
	push bc
	ld hl, wIndicatorStates
	add hl, bc
	bit 7, [hl]
	jr z, .asm_169c5
	ld a, [hl]
	res 7, a
	ld hl, hNumFramesDropped
	bit 5, [hl]
	jr z, .asm_169c2
	inc a
.asm_169c2
	call Func_169cd
.asm_169c5
	pop bc
	inc c
	ld a, c
	cp $5
	jr nz, .asm_169ae
	ret

Func_169cd: ; 0x169cd
	push af
	sla c
	ld hl, TileDataPointers_169ed
	ld a, [hGameBoyColorFlag]
	and a
	jr z, .asm_169db
	ld hl, TileDataPointers_16bef
.asm_169db
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_169ed)
	call Func_10aa
	ret

TileDataPointers_169ed:
	dw TileDataPointers_169f7
	dw TileDataPointers_16a01
	dw TileDataPointers_16a0b
	dw TileDataPointers_16a0f
	dw TileDataPointers_16a13

TileDataPointers_169f7: ; 0x169f7
	dw TileData_16a17
	dw TileData_16a1e
	dw TileData_16a25
	dw TileData_16a2c
	dw TileData_16a33

TileDataPointers_16a01: ; 0x16a01
	dw TileData_16a3a
	dw TileData_16a41
	dw TileData_16a48
	dw TileData_16a4f
	dw TileData_16a56

TileDataPointers_16a0b: ; 0x16a0b
	dw TileData_16a5d
	dw TileData_16a60

TileDataPointers_16a0f: ; 0x16a0f
	dw TileData_16a63
	dw TileData_16a66

TileDataPointers_16a13: ; 0x16a13
	dw TileData_16a69
	dw TileData_16a6e

TileData_16a17: ; 0x16a17
	db $03
	dw TileData_16a73
	dw TileData_16a7d
	dw TileData_16a87

TileData_16a1e: ; 0x16a1e
	db $03
	dw TileData_16a91
	dw TileData_16a9b
	dw TileData_16aa5

TileData_16a25: ; 0x16a25
	db $03
	dw TileData_16aaf
	dw TileData_16ab9
	dw TileData_16ac3

TileData_16a2c: ; 0x16a2c
	db $03
	dw TileData_16acd
	dw TileData_16ad7
	dw TileData_16ae1

TileData_16a33: ; 0x16a33
	db $03
	dw TileData_16aeb
	dw TileData_16af5
	dw TileData_16aff

TileData_16a3a: ; 0x16a3a
	db $03
	dw TileData_16b09
	dw TileData_16b13
	dw TileData_16b1d

TileData_16a41: ; 0x16a41
	db $03
	dw TileData_16b27
	dw TileData_16b31
	dw TileData_16b3b

TileData_16a48: ; 0x16a48
	db $03
	dw TileData_16b45
	dw TileData_16b4f
	dw TileData_16b59

TileData_16a4f: ; 0x16a4f
	db $03
	dw TileData_16b63
	dw TileData_16b6d
	dw TileData_16b77

TileData_16a56: ; 0x16a56
	db $03
	dw TileData_16b81
	dw TileData_16b8b
	dw TileData_16b95

TileData_16a5d: ; 0x16a5d
	db $01
	dw TileData_16b9f

TileData_16a60: ; 0x16a60
	db $01
	dw TileData_16ba9

TileData_16a63: ; 0x16a63
	db $01
	dw TileData_16bb3

TileData_16a66: ; 0x16a66
	db $01
	dw TileData_16bbd

TileData_16a69: ; 0x16a69
	db $02
	dw TileData_16bc7
	dw TileData_16bd1

TileData_16a6e: ; 0x16a6e
	db $02
	dw TileData_16bdb
	dw TileData_16be5

TileData_16a73: ; 0x16a73
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomBaseGameBoyGfx + $ba0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16a7d: ; 0x16a7d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomBaseGameBoyGfx + $bd0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16a87: ; 0x16a87
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomBaseGameBoyGfx + $c00
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16a91: ; 0x16a91
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $380
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16a9b: ; 0x16a9b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $3B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aa5: ; 0x16aa5
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $3E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aaf: ; 0x16aaf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $3F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ab9: ; 0x16ab9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $420
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ac3: ; 0x16ac3
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $450
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16acd: ; 0x16acd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $460
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ad7: ; 0x16ad7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $490
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16ae1: ; 0x16ae1
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $4C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aeb: ; 0x16aeb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F30
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16af5: ; 0x16af5
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $3D
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16aff: ; 0x16aff
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $40
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $F90
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b09: ; 0x16b09
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomBaseGameBoyGfx + $c10
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16b13: ; 0x16b13
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomBaseGameBoyGfx + $c40
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16b1d: ; 0x16b1d
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomBaseGameBoyGfx + $c70
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16b27: ; 0x16b27
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $4D0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b31: ; 0x16b31
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $500
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b3b: ; 0x16b3b
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $530
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b45: ; 0x16b45
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $540
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b4f: ; 0x16b4f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $570
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b59: ; 0x16b59
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $5A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b63: ; 0x16b63
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $5B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b6d: ; 0x16b6d
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $5E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b77: ; 0x16b77
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $610
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b81: ; 0x16b81
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1010
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b8b: ; 0x16b8b
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1040
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b95: ; 0x16b95
	dw Func_11d2
	db $10, $01
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1070
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16b9f: ; 0x16b9f
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $20
	dw StageRedFieldBottomBaseGameBoyGfx + $a00
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16ba9: ; 0x16ba9
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $20
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16bb3: ; 0x16bb3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $23
	dw StageRedFieldBottomBaseGameBoyGfx + $a30
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16bbd: ; 0x16bbd
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $10B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16bc7: ; 0x16bc7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1C
	dw StageRedFieldBottomBaseGameBoyGfx + $9c0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16bd1: ; 0x16bd1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1E
	dw StageRedFieldBottomBaseGameBoyGfx + $9e0
	db Bank(StageRedFieldBottomBaseGameBoyGfx)
	db $00

TileData_16bdb: ; 0x16bdb
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $6E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_16be5: ; 0x16be5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $700
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_16bef:
	dw TileDataPointers_16bf9
	dw TileDataPointers_16c03
	dw TileDataPointers_16c0d
	dw TileDataPointers_16c11
	dw TileDataPointers_16c15

TileDataPointers_16bf9: ; 0x16bf9
	dw TileData_16c19
	dw TileData_16c1c
	dw TileData_16c1f
	dw TileData_16c22
	dw TileData_16c25

TileDataPointers_16c03: ; 0x16c03
	dw TileData_16c28
	dw TileData_16c2b
	dw TileData_16c2e
	dw TileData_16c31
	dw TileData_16c34

TileDataPointers_16c0d: ; 0x16c0d
	dw TileData_16c37
	dw TileData_16c3a

TileDataPointers_16c11: ; 0x16c11
	dw TileData_16c3d
	dw TileData_16c40

TileDataPointers_16c15: ; 0x16c15
	dw TileData_16c43
	dw TileData_16c46

TileData_16c19: ; 0x16c19
	db $01
	dw TileData_16c49

TileData_16c1c: ; 0x16c1c
	db $01
	dw TileData_16c63

TileData_16c1f: ; 0x16c1f
	db $01
	dw TileData_16c7d

TileData_16c22: ; 0x16c22
	db $01
	dw TileData_16c97

TileData_16c25: ; 0x16c25
	db $01
	dw TileData_16cb1

TileData_16c28: ; 0x16c28
	db $01
	dw TileData_16ccb

TileData_16c2b: ; 0x16c2b
	db $01
	dw TileData_16ce5

TileData_16c2e: ; 0x16c2e
	db $01
	dw TileData_16cff

TileData_16c31: ; 0x16c31
	db $01
	dw TileData_16d19

TileData_16c34: ; 0x16c34
	db $01
	dw TileData_16d33

TileData_16c37: ; 0x16c37
	db $01
	dw TileData_16d4d

TileData_16c3a: ; 0x16c3a
	db $01
	dw TileData_16d5a

TileData_16c3d: ; 0x16c3d
	db $01
	dw TileData_16d67

TileData_16c40: ; 0x16c40
	db $01
	dw TileData_16d74

TileData_16c43: ; 0x16c43
	db $01
	dw TileData_16d81

TileData_16c46: ; 0x16c46
	db $01
	dw TileData_16d8f

TileData_16c49: ; 0x16c49
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $23
	db $5E

	db $02
	dw vBGMap + $43
	db $5F, $60

	db $02
	dw vBGMap + $64
	db $61, $62

	db $01
	dw vBGMap + $85
	db $63

	db $01
	dw vBGMap + $A5
	db $64

	db $00

TileData_16c63: ; 0x16c63
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $23
	db $65

	db $02
	dw vBGMap + $43
	db $66, $67

	db $02
	dw vBGMap + $64
	db $61, $62

	db $01
	dw vBGMap + $85
	db $63

	db $01
	dw vBGMap + $A5
	db $64

	db $00

TileData_16c7d: ; 0x16c7d
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $23
	db $65

	db $02
	dw vBGMap + $43
	db $66, $67

	db $02
	dw vBGMap + $64
	db $68, $69

	db $01
	dw vBGMap + $85
	db $63

	db $01
	dw vBGMap + $A5
	db $64

	db $00

TileData_16c97: ; 0x16c97
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $23
	db $65

	db $02
	dw vBGMap + $43
	db $66, $67

	db $02
	dw vBGMap + $64
	db $68, $69

	db $01
	dw vBGMap + $85
	db $6A

	db $01
	dw vBGMap + $A5
	db $6B

	db $00

TileData_16cb1: ; 0x16cb1
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $23
	db $5E

	db $02
	dw vBGMap + $43
	db $5F, $60

	db $02
	dw vBGMap + $64
	db $68, $69

	db $01
	dw vBGMap + $85
	db $6A

	db $01
	dw vBGMap + $A5
	db $6B

	db $00

TileData_16ccb: ; 0x16ccb
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $30
	db $6C

	db $02
	dw vBGMap + $4F
	db $6D, $6E

	db $02
	dw vBGMap + $6E
	db $6F, $70

	db $01
	dw vBGMap + $8E
	db $71

	db $01
	dw vBGMap + $AE
	db $72

	db $00

TileData_16ce5: ; 0x16ce5
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $30
	db $73

	db $02
	dw vBGMap + $4F
	db $74, $75

	db $02
	dw vBGMap + $6E
	db $6F, $70

	db $01
	dw vBGMap + $8E
	db $71

	db $01
	dw vBGMap + $AE
	db $72

	db $00

TileData_16cff: ; 0x16cff
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $30
	db $73

	db $02
	dw vBGMap + $4F
	db $74, $75

	db $02
	dw vBGMap + $6E
	db $76, $77

	db $01
	dw vBGMap + $8E
	db $71

	db $01
	dw vBGMap + $AE
	db $72

	db $00

TileData_16d19: ; 0x16d19
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $30
	db $73

	db $02
	dw vBGMap + $4F
	db $74, $75

	db $02
	dw vBGMap + $6E
	db $76, $77

	db $01
	dw vBGMap + $8E
	db $78

	db $01
	dw vBGMap + $AE
	db $79

	db $00

TileData_16d33: ; 0x16d33
	dw LoadTileLists
	db $07
	
	db $01
	dw vBGMap + $30
	db $6C

	db $02
	dw vBGMap + $4F
	db $6D, $6E

	db $02
	dw vBGMap + $6E
	db $76, $77

	db $01
	dw vBGMap + $8E
	db $78

	db $01
	dw vBGMap + $AE
	db $79

	db $00

TileData_16d4d: ; 0x16d4d
	dw LoadTileLists
	db $03
	
	db $01
	dw vBGMap + $6
	db $48

	db $02
	dw vBGMap + $26
	db $49, $4A

	db $00

TileData_16d5a: ; 0x16d5a
	dw LoadTileLists
	db $03
	
	db $01
	dw vBGMap + $6
	db $4B

	db $02
	dw vBGMap + $26
	db $4C, $4D

	db $00

TileData_16d67: ; 0x16d67
	dw LoadTileLists
	db $03
	
	db $01
	dw vBGMap + $D
	db $4E

	db $02
	dw vBGMap + $2C
	db $4F, $50

	db $00

TileData_16d74: ; 0x16d74
	dw LoadTileLists
	db $03
	
	db $01
	dw vBGMap + $D
	db $51

	db $02
	dw vBGMap + $2C
	db $52, $53

	db $00

TileData_16d81: ; 0x16d81
	dw LoadTileLists
	db $04
	
	db $02
	dw vBGMap + $49
	db $40, $41

	db $02
	dw vBGMap + $69
	db $42, $43

	db $00

TileData_16d8f: ; 0x16d8f
	dw LoadTileLists
	db $04
	
	db $02
	dw vBGMap + $49
	db $44, $45

	db $02
	dw vBGMap + $69
	db $46, $47

	db $00

ResolveRedStageBonusMultiplierCollision: ; 016d9d
	ld a, [wWhichBonusMultiplierRailing]
	and a
	jp z, Func_16e51
	xor a
	ld [wWhichBonusMultiplierRailing], a
	lb de, $00, $0d
	call PlaySoundEffect
	ld a, [wWhichBonusMultiplierRailingId]
	sub $21
	jr nz, .asm_16ddc
	ld a, $9
	callba Func_10000
	ld a, [wd610]
	cp $3
	jr nz, .asm_16e35
	ld a, $1
	ld [wd610], a
	ld a, $3
	ld [wd611], a
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	jr .asm_16e35

.asm_16ddc
	ld a, $a
	callba Func_10000
	ld a, [wd611]
	cp $3
	jr nz, .asm_16e35
	ld a, $1
	ld [wd610], a
	ld a, $1
	ld [wd611], a
	ld a, $80
	ld [wd612], a
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	ld a, [wd482]
	inc a
	cp 100
	jr c, .asm_16e10
	ld a, 99
.asm_16e10
	ld [wd482], a
	jr nc, .asm_16e24
	ld c, $19
	call Modulo_C
	callba z, IncrementBonusMultiplier
.asm_16e24
	ld a, [wd60c]
	ld [wd614], a
	ld a, [wd60d]
	ld [wd615], a
	ld a, $1
	ld [wd613], a
.asm_16e35
	ld bc, TenPoints
	callba AddBigBCD6FromQueueWithBallMultiplier
	ld a, [wd60c]
	call Func_16f28
	ld a, [wd60d]
	add $14
	call Func_16f28
	ret

Func_16e51: ; 0x16e51
	call Func_16ef5
	ld a, [wd612]
	and a
	jr z, .asm_16e8f
	dec a
	ld [wd612], a
	cp $70
	jr nz, .asm_16e6e
	ld a, $2
	ld [wd610], a
	ld a, $2
	ld [wd611], a
	jr .asm_16e8f

.asm_16e6e
	and a
	jr nz, .asm_16e8f
	ld a, $3
	ld [wd610], a
	xor a
	ld [wd611], a
	ld a, [wd482]
	call Func_16f95
	ld a, [wd60c]
	call Func_16f28
	ld a, [wd60d]
	add $14
	call Func_16f28
	ret

.asm_16e8f
	ld a, [wd610]
	cp $2
	jr c, .asm_16ec1
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_16ea0
	srl a
	srl a
.asm_16ea0
	ld b, a
	and $3
	jr nz, .asm_16ec1
	bit 3, b
	jr nz, .asm_16eb6
	ld a, [wd60c]
	res 7, a
	ld [wd60c], a
	call Func_16f28
	jr .asm_16ec1

.asm_16eb6
	ld a, [wd60c]
	set 7, a
	ld [wd60c], a
	call Func_16f28
.asm_16ec1
	ld a, [wd611]
	cp $2
	ret c
	cp $3
	ld a, [hNumFramesDropped]
	jr c, .asm_16ed1
	srl a
	srl a
.asm_16ed1
	ld b, a
	and $3
	ret nz
	bit 3, b
	jr nz, .asm_16ee7
	ld a, [wd60d]
	res 7, a
	ld [wd60d], a
	add $14
	call Func_16f28
	ret

.asm_16ee7
	ld a, [wd60d]
	set 7, a
	ld [wd60d], a
	add $14
	call Func_16f28
	ret

Func_16ef5: ; 0x16ef5
	ld a, [wd5ca]
	and a
	ret nz
	ld a, [wd613]
	and a
	ret z
	xor a
	ld [wd613], a
	call FillBottomMessageBufferWithBlackTile
	call Func_30db
	ld hl, wd5cc
	ld de, BonusMultiplierText
	call LoadTextHeader
	ld hl, wBottomMessageText + $12
	ld a, [wd614]
	and $7f
	jr z, .asm_16f1f
	add $30
	ld [hli], a
.asm_16f1f
	ld a, [wd615]
	res 7, a
	add $30
	ld [hl], a
	ret

Func_16f28: ; 0x16f28
	push af
	ld a, [hGameBoyColorFlag]
	and a
	jr nz, .asm_16f33
	pop af
	call Func_16f38
	ret

.asm_16f33
	pop af
	call Func_16f7b
	ret

Func_16f38: ; 0x16f38
	push af
	res 7, a
	ld hl, wd60e
	cp $14
	jr c, .asm_16f47
	ld hl, wd60f
	sub $a
.asm_16f47
	cp [hl]
	jr z, .asm_16f5c
	ld [hl], a
	ld c, a
	ld b, $0
	sla c
	ld hl, TileDataPointers_16fc8
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_16fc8)
	call Func_10aa
.asm_16f5c
	pop af
	ld bc, $0000
	bit 7, a
	jr z, .asm_16f68
	res 7, a
	set 1, c
.asm_16f68
	cp $14
	jr c, .asm_16f6e
	set 2, c
.asm_16f6e
	ld hl, Data_171e4
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(Data_171e4)
	call Func_10aa
	ret

Func_16f7b: ; 0x16f7b
	bit 7, a
	jr z, .asm_16f83
	res 7, a
	add $a
.asm_16f83
	ld c, a
	ld b, $0
	sla c
	ld hl, TileDataPointers_17228
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(TileDataPointers_17228)
	call Func_10aa
	ret

Func_16f95: ; 0x16f95
	ld a, [wd482]
	inc a
	cp 100
	jr c, .asm_16f9f
	ld a, 99
.asm_16f9f
	ld b, a
	xor a
	ld hl, Data_16fc1
	ld c, $7
.asm_16fa6
	bit 0, b
	jr z, .asm_16fac
	add [hl]
	daa
.asm_16fac
	srl b
	inc hl
	dec c
	jr nz, .asm_16fa6
	push af
	swap a
	and $f
	ld [wd60c], a
	pop af
	and $f
	ld [wd60d], a
	ret

Data_16fc1:
; BCD powers of 2
	db $01
	db $02
	db $04
	db $08
	db $16
	db $32
	db $64

TileDataPointers_16fc8:
	dw TileData_16ff0
	dw TileData_16ff5
	dw TileData_16ffa
	dw TileData_16fff
	dw TileData_17004
	dw TileData_17009
	dw TileData_1700e
	dw TileData_17013
	dw TileData_17018
	dw TileData_1701d
	dw TileData_17022
	dw TileData_17027
	dw TileData_1702c
	dw TileData_17031
	dw TileData_17036
	dw TileData_1703b
	dw TileData_17040
	dw TileData_17045
	dw TileData_1704a
	dw TileData_1704f

TileData_16ff0: ; 0x16ff0
	db $02
	dw TileData_17054
	dw TileData_1705e

TileData_16ff5: ; 0x16ff5
	db $02
	dw TileData_17068
	dw TileData_17072

TileData_16ffa: ; 0x16ffa
	db $02
	dw TileData_1707c
	dw TileData_17086

TileData_16fff: ; 0x16fff
	db $02
	dw TileData_17090
	dw TileData_1709a

TileData_17004: ; 0x17004
	db $02
	dw TileData_170a4
	dw TileData_170ae

TileData_17009: ; 0x17009
	db $02
	dw TileData_170b8
	dw TileData_170c2

TileData_1700e: ; 0x1700e
	db $02
	dw TileData_170cc
	dw TileData_170d6

TileData_17013: ; 0x17013
	db $02
	dw TileData_170e0
	dw TileData_170ea

TileData_17018: ; 0x17018
	db $02
	dw TileData_170f4
	dw TileData_170fe

TileData_1701d: ; 0x1701d
	db $02
	dw TileData_17108
	dw TileData_17112

TileData_17022: ; 0x17022
	db $02
	dw TileData_1711c
	dw TileData_17126

TileData_17027: ; 0x17027
	db $02
	dw TileData_17130
	dw TileData_1713a

TileData_1702c: ; 0x1702c
	db $02
	dw TileData_17144
	dw TileData_1714e

TileData_17031: ; 0x17031
	db $02
	dw TileData_17158
	dw TileData_17162

TileData_17036: ; 0x17036
	db $02
	dw TileData_1716c
	dw TileData_17176

TileData_1703b: ; 0x1703b
	db $02
	dw TileData_17180
	dw TileData_1718a

TileData_17040: ; 0x17040
	db $02
	dw TileData_17194
	dw TileData_1719e

TileData_17045: ; 0x17045
	db $02
	dw TileData_171a8
	dw TileData_171b2

TileData_1704a: ; 0x1704a
	db $02
	dw TileData_171bc
	dw TileData_171c6

TileData_1704f: ; 0x1704f
	db $02
	dw TileData_171d0
	dw TileData_171da

TileData_17054: ; 0x17054
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1280
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1705e: ; 0x1705e
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1140
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17068: ; 0x17068
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $12A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17072: ; 0x17072
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1160
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1707c: ; 0x1707c
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $12C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17086: ; 0x17086
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1180
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17090: ; 0x17090
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $12E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1709a: ; 0x1709a
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $11A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170a4: ; 0x170a4
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1300
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170ae: ; 0x170ae
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $11C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170b8: ; 0x170b8
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1320
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170c2: ; 0x170c2
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $11E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170cc: ; 0x170cc
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1340
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170d6: ; 0x170d6
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1200
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170e0: ; 0x170e0
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1360
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170ea: ; 0x170ea
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1220
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170f4: ; 0x170f4
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1380
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_170fe: ; 0x170fe
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1240
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17108: ; 0x17108
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $13A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17112: ; 0x17112
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1260
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1711c: ; 0x1711c
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1500
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17126: ; 0x17126
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $13C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17130: ; 0x17130
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1520
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1713a: ; 0x1713a
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $13E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17144: ; 0x17144
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1540
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1714e: ; 0x1714e
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1400
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17158: ; 0x17158
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1560
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17162: ; 0x17162
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1420
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1716c: ; 0x1716c
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1580
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17176: ; 0x17176
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1440
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17180: ; 0x17180
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $15A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1718a: ; 0x1718a
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1460
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_17194: ; 0x17194
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $15C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1719e: ; 0x1719e
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1480
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_171a8: ; 0x171a8
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $15E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_171b2: ; 0x171b2
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $14A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_171bc: ; 0x171bc
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1600
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_171c6: ; 0x171c6
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $14C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_171d0: ; 0x171d0
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1620
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_171da: ; 0x171da
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $14E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

Data_171e4:
	dw Data_171ec
	dw Data_171ef
	dw Data_171f2
	dw Data_171f5

Data_171ec: ; 0x171ec
	db $01
	dw Data_171f8

Data_171ef: ; 0x171ef
	db $01
	dw Data_17204

Data_171f2: ; 0x171f2
	db $01
	dw Data_17210

Data_171f5: ; 0x171f5
	db $01
	dw Data_1721c

Data_171f8: ; 0x171f8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $C6

	db $01
	dw vBGMap + $24
	db $C7

	db $00

Data_17204: ; 0x17204
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $C8

	db $01
	dw vBGMap + $24
	db $C9

	db $00

Data_17210: ; 0x17210
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $CA

	db $01
	dw vBGMap + $2F
	db $CB

	db $00

Data_1721c: ; 0x1721c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $CC

	db $01
	dw vBGMap + $2F
	db $CD

	db $00

TileDataPointers_17228:
	dw TileData_17278
	dw TileData_1727b
	dw TileData_1727e
	dw TileData_17281
	dw TileData_17284
	dw TileData_17287
	dw TileData_1728a
	dw TileData_1728d
	dw TileData_17290
	dw TileData_17293
	dw TileData_17296
	dw TileData_17299
	dw TileData_1729c
	dw TileData_1729f
	dw TileData_172a2
	dw TileData_172a5
	dw TileData_172a8
	dw TileData_172ab
	dw TileData_172ae
	dw TileData_172b1
	dw TileData_172b4
	dw TileData_172b7
	dw TileData_172ba
	dw TileData_172bd
	dw TileData_172c0
	dw TileData_172c3
	dw TileData_172c6
	dw TileData_172c9
	dw TileData_172cc
	dw TileData_172cf
	dw TileData_172d2
	dw TileData_172d5
	dw TileData_172d8
	dw TileData_172db
	dw TileData_172de
	dw TileData_172e1
	dw TileData_172e4
	dw TileData_172e7
	dw TileData_172ea
	dw TileData_172ed

TileData_17278: ; 0x17278
	db $01
	dw TileData_172f0

TileData_1727b: ; 0x1727b
	db $01
	dw TileData_172fc

TileData_1727e: ; 0x1727e
	db $01
	dw TileData_17308

TileData_17281: ; 0x17281
	db $01
	dw TileData_17314

TileData_17284: ; 0x17284
	db $01
	dw TileData_17320

TileData_17287: ; 0x17287
	db $01
	dw TileData_1732c

TileData_1728a: ; 0x1728a
	db $01
	dw TileData_17338

TileData_1728d: ; 0x1728d
	db $01
	dw TileData_17344

TileData_17290: ; 0x17290
	db $01
	dw TileData_17350

TileData_17293: ; 0x17293
	db $01
	dw TileData_1735c

TileData_17296: ; 0x17296
	db $01
	dw TileData_17368

TileData_17299: ; 0x17299
	db $01
	dw TileData_17374

TileData_1729c: ; 0x1729c
	db $01
	dw TileData_17380

TileData_1729f: ; 0x1729f
	db $01
	dw TileData_1738c

TileData_172a2: ; 0x172a2
	db $01
	dw TileData_17398

TileData_172a5: ; 0x172a5
	db $01
	dw TileData_173a4

TileData_172a8: ; 0x172a8
	db $01
	dw TileData_173b0

TileData_172ab: ; 0x172ab
	db $01
	dw TileData_173bc

TileData_172ae: ; 0x172ae
	db $01
	dw TileData_173c8

TileData_172b1: ; 0x172b1
	db $01
	dw TileData_173d4

TileData_172b4: ; 0x172b4
	db $01
	dw TileData_173e0

TileData_172b7: ; 0x172b7
	db $01
	dw TileData_173ec

TileData_172ba: ; 0x172ba
	db $01
	dw TileData_173f8

TileData_172bd: ; 0x172bd
	db $01
	dw TileData_17404

TileData_172c0: ; 0x172c0
	db $01
	dw TileData_17410

TileData_172c3: ; 0x172c3
	db $01
	dw TileData_1741c

TileData_172c6: ; 0x172c6
	db $01
	dw TileData_17428

TileData_172c9: ; 0x172c9
	db $01
	dw TileData_17434

TileData_172cc: ; 0x172cc
	db $01
	dw TileData_17440

TileData_172cf: ; 0x172cf
	db $01
	dw TileData_1744c

TileData_172d2: ; 0x172d2
	db $01
	dw TileData_17458

TileData_172d5: ; 0x172d5
	db $01
	dw TileData_17464

TileData_172d8: ; 0x172d8
	db $01
	dw TileData_17470

TileData_172db: ; 0x172db
	db $01
	dw TileData_1747c

TileData_172de: ; 0x172de
	db $01
	dw TileData_17488

TileData_172e1: ; 0x172e1
	db $01
	dw TileData_17494

TileData_172e4: ; 0x172e4
	db $01
	dw TileData_174a0

TileData_172e7: ; 0x172e7
	db $01
	dw TileData_174ac

TileData_172ea: ; 0x172ea
	db $01
	dw TileData_174b8

TileData_172ed: ; 0x172ed
	db $01
	dw TileData_174c4

TileData_172f0: ; 0x172f0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $40

	db $01
	dw vBGMap + $24
	db $41

	db $00

TileData_172fc: ; 0x172fc
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $42

	db $01
	dw vBGMap + $24
	db $43

	db $00

TileData_17308: ; 0x17308
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $44

	db $01
	dw vBGMap + $24
	db $45

	db $00

TileData_17314: ; 0x17314
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $46

	db $01
	dw vBGMap + $24
	db $47

	db $00

TileData_17320: ; 0x17320
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $48

	db $01
	dw vBGMap + $24
	db $49

	db $00

TileData_1732c: ; 0x1732c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $4A

	db $01
	dw vBGMap + $24
	db $4B

	db $00

TileData_17338: ; 0x17338
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $4C

	db $01
	dw vBGMap + $24
	db $4D

	db $00

TileData_17344: ; 0x17344
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $4E

	db $01
	dw vBGMap + $24
	db $4F

	db $00

TileData_17350: ; 0x17350
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $50

	db $01
	dw vBGMap + $24
	db $51

	db $00

TileData_1735c: ; 0x1735c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $52

	db $01
	dw vBGMap + $24
	db $53

	db $00

TileData_17368: ; 0x17368
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $2C

	db $01
	dw vBGMap + $24
	db $2D

	db $00

TileData_17374: ; 0x17374
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $2E

	db $01
	dw vBGMap + $24
	db $2F

	db $00

TileData_17380: ; 0x17380
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $30

	db $01
	dw vBGMap + $24
	db $31

	db $00

TileData_1738c: ; 0x1738c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $32

	db $01
	dw vBGMap + $24
	db $33

	db $00

TileData_17398: ; 0x17398
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $34

	db $01
	dw vBGMap + $24
	db $35

	db $00

TileData_173a4: ; 0x173a4
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $36

	db $01
	dw vBGMap + $24
	db $37

	db $00

TileData_173b0: ; 0x173b0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $38

	db $01
	dw vBGMap + $24
	db $39

	db $00

TileData_173bc: ; 0x173bc
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $3A

	db $01
	dw vBGMap + $24
	db $3B

	db $00

TileData_173c8: ; 0x173c8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $3C

	db $01
	dw vBGMap + $24
	db $3D

	db $00

TileData_173d4: ; 0x173d4
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $3E

	db $01
	dw vBGMap + $24
	db $3F

	db $00

TileData_173e0: ; 0x173e0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $68

	db $01
	dw vBGMap + $2F
	db $69

	db $00

TileData_173ec: ; 0x173ec
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $6A

	db $01
	dw vBGMap + $2F
	db $6B

	db $00

TileData_173f8: ; 0x173f8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $6C

	db $01
	dw vBGMap + $2F
	db $6D

	db $00

TileData_17404: ; 0x17404
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $6E

	db $01
	dw vBGMap + $2F
	db $6F

	db $00

TileData_17410: ; 0x17410
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $70

	db $01
	dw vBGMap + $2F
	db $71

	db $00

TileData_1741c: ; 0x1741c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $72

	db $01
	dw vBGMap + $2F
	db $73

	db $00

TileData_17428: ; 0x17428
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $74

	db $01
	dw vBGMap + $2F
	db $75

	db $00

TileData_17434: ; 0x17434
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $76

	db $01
	dw vBGMap + $2F
	db $77

	db $00

TileData_17440: ; 0x17440
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $78

	db $01
	dw vBGMap + $2F
	db $79

	db $00

TileData_1744c: ; 0x1744c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $7A

	db $01
	dw vBGMap + $2F
	db $7B

	db $00

TileData_17458: ; 0x17458
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $54

	db $01
	dw vBGMap + $2F
	db $55

	db $00

TileData_17464: ; 0x17464
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $56

	db $01
	dw vBGMap + $2F
	db $57

	db $00

TileData_17470: ; 0x17470
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $58

	db $01
	dw vBGMap + $2F
	db $59

	db $00

TileData_1747c: ; 0x1747c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $5A

	db $01
	dw vBGMap + $2F
	db $5B

	db $00

TileData_17488: ; 0x17488
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $5C

	db $01
	dw vBGMap + $2F
	db $5D

	db $00

TileData_17494: ; 0x17494
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $5E

	db $01
	dw vBGMap + $2F
	db $5F

	db $00

TileData_174a0: ; 0x174a0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $60

	db $01
	dw vBGMap + $2F
	db $61

	db $00

TileData_174ac: ; 0x174ac
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $62

	db $01
	dw vBGMap + $2F
	db $63

	db $00

TileData_174b8: ; 0x174b8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $64

	db $01
	dw vBGMap + $2F
	db $65

	db $00

TileData_174c4: ; 0x174c4
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $66

	db $01
	dw vBGMap + $2F
	db $67

	db $00

Func_174d0: ; 0x174d0
	call Func_174ea
	ret nc
	; fall through

Func_174d4: ; 0x174d4
	sla a
	ld c, a
	ld b, $0
	ld hl, TileDataPointers_17528
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $5
	ld de, LoadTileLists
	call Func_10c5
	ret

Func_174ea: ; 0x174ea
	ld a, [wd624]
	ld hl, wd625
	cp [hl]
	ret z
	ld a, [wd626]
	dec a
	ld [wd626], a
	jr nz, .asm_17514
	ld a, [wd625]
	ld [wd624], a
	cp $3
	jr c, .asm_1750f
	ld a, $1
	ld [wd609], a
	ld a, $3
	ld [wd607], a
.asm_1750f
	ld a, [wd624]
	scf
	ret

.asm_17514
	and $7
	ret nz
	ld a, [wd626]
	bit 3, a
	jr nz, .asm_17523
	ld a, [wd624]
	scf
	ret

.asm_17523
	ld a, [wd625]
	scf
	ret

TileDataPointers_17528:
	dw TileData_17530
	dw TileData_1753B
	dw TileData_17546
	dw TileData_17551

TileData_17530: ; 0x17530
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $B0, $B1, $B0, $B1, $B0, $B1
	db $00

TileData_1753B: ; 0x1753B
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $AE, $AF, $B0, $B1, $B0, $B1
	db $00

TileData_17546: ; 0x17546
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $AE, $AF, $AE, $AF, $B0, $B1
	db $00

TileData_17551: ; 0x17551
	db $06 ; total number of tiles

	db $06 ; number of tiles
	dw $9907
	db $AE, $AF, $AE, $AF, $AE, $AF
	db $00
