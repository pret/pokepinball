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
