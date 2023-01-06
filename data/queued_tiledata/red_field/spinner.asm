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
