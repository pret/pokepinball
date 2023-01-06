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

TileData_16080:
	dw TileData_16088
	dw TileData_1608b
	dw TileData_1608e
	dw TileData_16091

TileData_16088: ; 0x16088
	db $01
	dw TileData_16094

TileData_1608b: ; 0x1608b
	db $01
	dw TileData_160ab

TileData_1608e: ; 0x1608e
	db $01
	dw TileData_160c2

TileData_16091: ; 0x16091
	db $01
	dw TileData_160d9

TileData_16094: ; 0x16094
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

TileData_160ab: ; 0x160ab
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

TileData_160c2: ; 0x160c2
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

TileData_160d9: ; 0x160d9
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
