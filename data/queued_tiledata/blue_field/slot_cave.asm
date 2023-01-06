TileDataPointers_1e91e:
	dw TileData_1e926
	dw TileData_1e929
	dw TileData_1e92c
	dw TileData_1e931

TileData_1e926: ; 0x1e926
	db $01
	dw TileData_1e936

TileData_1e929: ; 0x1e929
	db $01
	dw TileData_1e93f

TileData_1e92c: ; 0x1e92c
	db $02
	dw TileData_1e948
	dw TileData_1e952

TileData_1e931: ; 0x1e931
	db $02
	dw TileData_1e95c
	dw TileData_1e966

TileData_1e936: ; 0x1e936
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $EE, $EF

	db $00 ; terminator

TileData_1e93f: ; 0x1e93f
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $F0, $F1

	db $00 ; terminator

TileData_1e948: ; 0x1e948
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1F
	dw StageBlueFieldBottomBaseGameBoyGfx + $9F0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e952: ; 0x1e952
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $21
	dw StageBlueFieldBottomBaseGameBoyGfx + $A10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e95c: ; 0x1e95c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1F
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1BC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e966: ; 0x1e966
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $21
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1BE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_1e970:
	dw TileData_1e978
	dw TileData_1e97d
	dw TileData_1e980
	dw TileData_1e983

TileData_1e978: ; 0x1e978
	db $02
	dw TileData_1e986
	dw TileData_1e98F

TileData_1e97d: ; 0x1e97d
	db $01
	dw TileData_1e99b

TileData_1e980: ; 0x1e980
	db $01
	dw TileData_1e9a4

TileData_1e983: ; 0x1e983
	db $01
	dw TileData_1e9b2

TileData_1e986: ; 0x1e986
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $F0, $F1

	db $00 ; terminator

TileData_1e98F: ; 0x1e98F
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $224
	db $D8

	db $01 ; number of tiles
	dw vBGMap + $22f
	db $EC

	db $00 ; terminator

TileData_1e99b: ; 0x1e99b
	dw LoadTileLists
	db $02 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $229
	db $F2, $F3

	db $00 ; terminator

TileData_1e9a4: ; 0x1e9a4
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw $9809
	db $15, $16

	db $02 ; terminator
	dw vBGMap + $29
	db $17, $18

	db $00 ; terminator

TileData_1e9b2: ; 0x1e9b2
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $9
	db $19, $1A

	db $02 ; terminator
	dw vBGMap + $29
	db $1B, $1C

	db $00 ; terminator
