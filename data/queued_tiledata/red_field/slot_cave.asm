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
