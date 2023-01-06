TileDataPointers_1eb61:
	dw TileDataPointers_1eb6b
	dw TileDataPointers_1eb75
	dw TileDataPointers_1eb7f
	dw TileDataPointers_1eb87
	dw TileDataPointers_1eb8f

TileDataPointers_1eb6b: ; 0x1eb6b
	dw TileData_1eb97
	dw TileData_1eb9a
	dw TileData_1eb9d
	dw TileData_1eba0
	dw TileData_1eba3

TileDataPointers_1eb75: ; 0x1eb75
	dw TileData_1eba6
	dw TileData_1eba9
	dw TileData_1ebac
	dw TileData_1ebaf
	dw TileData_1ebb2

TileDataPointers_1eb7f: ; 0x1eb7f
	dw TileData_1ebb5
	dw TileData_1ebb8
	dw TileData_1ebbb
	dw TileData_1ebbe

TileDataPointers_1eb87: ; 0x1eb87
	dw TileData_1ebc1
	dw TileData_1ebc6
	dw TileData_1ebcb
	dw TileData_1ebd0

TileDataPointers_1eb8f: ; 0x1eb8f
	dw TileData_1ebd5
	dw TileData_1ebda
	dw TileData_1ebdf
	dw TileData_1ebe4

TileData_1eb97: ; 0x1eb97
	db $01
	dw TileData_1ebe9

TileData_1eb9a: ; 0x1eb9a
	db $01
	dw TileData_1ebf9

TileData_1eb9d: ; 0x1eb9d
	db $01
	dw TileData_1ec09

TileData_1eba0: ; 0x1eba0
	db $01
	dw TileData_1ec19

TileData_1eba3: ; 0x1eba3
	db $01
	dw TileData_1ec29

TileData_1eba6: ; 0x1eba6
	db $01
	dw TileData_1ec39

TileData_1eba9: ; 0x1eba9
	db $01
	dw TileData_1ec49

TileData_1ebac: ; 0x1ebac
	db $01
	dw TileData_1ec59

TileData_1ebaf: ; 0x1ebaf
	db $01
	dw TileData_1ec69

TileData_1ebb2: ; 0x1ebb2
	db $01
	dw TileData_1ec79

TileData_1ebb5: ; 0x1ebb5
	db $01
	dw TileData_1ec89

TileData_1ebb8: ; 0x1ebb8
	db $01
	dw TileData_1ec93

TileData_1ebbb: ; 0x1ebbb
	db $01
	dw TileData_1ec9d

TileData_1ebbe: ; 0x1ebbe
	db $01
	dw TileData_1eca7

TileData_1ebc1: ; 0x1ebc1
	db $02
	dw TileData_1ecb1
	dw TileData_1ecbb

TileData_1ebc6: ; 0x1ebc6
	db $02
	dw TileData_1ecc5
	dw TileData_1eccf

TileData_1ebcb: ; 0x1ebcb
	db $02
	dw TileData_1ecd9
	dw TileData_1ece3

TileData_1ebd0: ; 0x1ebd0
	db $02
	dw TileData_1eced
	dw TileData_1ecf7

TileData_1ebd5: ; 0x1ebd5
	db $02
	dw TileData_1ed01
	dw TileData_1ed0b

TileData_1ebda: ; 0x1ebda
	db $02
	dw TileData_1ed15
	dw TileData_1ed1f

TileData_1ebdf: ; 0x1ebdf
	db $02
	dw TileData_1ed01
	dw TileData_1ed0b

TileData_1ebe4: ; 0x1ebe4
	db $02
	dw TileData_1ed15
	dw TileData_1ed1f

TileData_1ebe9: ; 0x1ebe9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3D

	db $01 ; number of tiles
	dw vBGMap + $84
	db $17

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ebf9: ; 0x1ebf9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3E

	db $01 ; number of tiles
	dw vBGMap + $84
	db $17

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ec09: ; 0x1ec09
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3E

	db $01 ; number of tiles
	dw vBGMap + $84
	db $18

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ec19: ; 0x1ec19
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3E

	db $01 ; number of tiles
	dw vBGMap + $84
	db $18

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3E

	db $00 ; terminator

TileData_1ec29: ; 0x1ec29
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $3D

	db $01 ; number of tiles
	dw vBGMap + $84
	db $18

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $3D

	db $00 ; terminator

TileData_1ec39: ; 0x1ec39
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $3F

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1D

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $3F

	db $00 ; terminator

TileData_1ec49: ; 0x1ec49
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1D

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $3F

	db $00 ; terminator

TileData_1ec59: ; 0x1ec59
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1E

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $3F

	db $00 ; terminator

TileData_1ec69: ; 0x1ec69
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1E

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $40

	db $00 ; terminator

TileData_1ec79: ; 0x1ec79
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $40

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $1D

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $40

	db $00 ; terminator

TileData_1ec89: ; 0x1ec89
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageBlueFieldBottomBaseGameBoyGfx + $950
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ec93: ; 0x1ec93
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1F40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ec9d: ; 0x1ec9d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1F60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1eca7: ; 0x1eca7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $15
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1F80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ecb1: ; 0x1ecb1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageBlueFieldBottomBaseGameBoyGfx + $990
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ecbb: ; 0x1ecbb
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageBlueFieldBottomBaseGameBoyGfx + $9B0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ecc5: ; 0x1ecc5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2270
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1eccf: ; 0x1eccf
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2290
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ecd9: ; 0x1ecd9
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $22B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ece3: ; 0x1ece3
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $22D0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1eced: ; 0x1eced
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $19
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $22F0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ecf7: ; 0x1ecf7
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $1B
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2310
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed01: ; 0x1ed01
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageBlueFieldBottomBaseGameBoyGfx + $A30
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ed0b: ; 0x1ed0b
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageBlueFieldBottomBaseGameBoyGfx + $A50
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1ed15: ; 0x1ed15
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed1f: ; 0x1ed1f
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed29: ; 0x1ed29
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed33: ; 0x1ed33
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e3d: ; 0x1e3d
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $23
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1C80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1ed47: ; 0x1ed47
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $25
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1CA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_1ed51: ; 0x1ed51
	dw TileDataPointers_1ed5b
	dw TileDataPointers_1ed65
	dw TileDataPointers_1ed6f
	dw TileDataPointers_1ed77
	dw TileDataPointers_1ed7f

TileDataPointers_1ed5b: ; 0x1ed5b
	dw TileData_1ed87
	dw TileData_1ed8a
	dw TileData_1ed8d
	dw TileData_1ed90
	dw TileData_1ed93

TileDataPointers_1ed65: ; 0x1ed65
	dw TileData_1ed96
	dw TileData_1ed99
	dw TileData_1ed9c
	dw TileData_1ed9f
	dw TileData_1eda2

TileDataPointers_1ed6f: ; 0x1ed6f
	dw TileData_1eda5
	dw TileData_1eda8
	dw TileData_1edab
	dw TileData_1edae

TileDataPointers_1ed77: ; 0x1ed77
	dw TileData_1edb1
	dw TileData_1edb4
	dw TileData_1edb7
	dw TileData_1edba

TileDataPointers_1ed7f: ; 0x1ed7f
	dw TileData_1edbd
	dw TileData_1edc0
	dw TileData_1edc3
	dw TileData_1edc6

TileData_1ed87: ; 0x1ed87
	db $01
	dw TileData_1edc9

TileData_1ed8a: ; 0x1ed8a
	db $01
	dw TileData_1edd9

TileData_1ed8d: ; 0x1ed8d
	db $01
	dw TileData_1ede9

TileData_1ed90: ; 0x1ed90
	db $01
	dw TileData_1edf9

TileData_1ed93: ; 0x1ed93
	db $01
	dw TileData_1ee09

TileData_1ed96: ; 0x1ed96
	db $01
	dw TileData_1ee19

TileData_1ed99: ; 0x1ed99
	db $01
	dw TileData_1ee29

TileData_1ed9c: ; 0x1ed9c
	db $01
	dw TileData_1ee39

TileData_1ed9f: ; 0x1ed9f
	db $01
	dw TileData_1ee49

TileData_1eda2: ; 0x1eda2
	db $01
	dw TileData_1ee59

TileData_1eda5: ; 0x1eda5
	db $01
	dw TileData_1ee69

TileData_1eda8: ; 0x1eda8
	db $01
	dw TileData_1ee75

TileData_1edab: ; 0x1edab
	db $01
	dw TileData_1ee81

TileData_1edae: ; 0x1edae
	db $01
	dw TileData_1ee8d

TileData_1edb1: ; 0x1edb1
	db $01
	dw TileData_1ee99

TileData_1edb4: ; 0x1edb4
	db $01
	dw TileData_1eea7

TileData_1edb7: ; 0x1edb7
	db $01
	dw TileData_1eeb5

TileData_1edba: ; 0x1edba
	db $01
	dw TileData_1eec3

TileData_1edbd: ; 0x1edbd
	db $01
	dw TileData_1eed1

TileData_1edc0: ; 0x1edc0
	db $01
	dw TileData_1eedf

TileData_1edc3: ; 0x1edc3
	db $01
	dw TileData_1eeed

TileData_1edc6: ; 0x1edc6
	db $01
	dw TileData_1eefb

TileData_1edc9: ; 0x1edc9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $31

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0D

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1edd9: ; 0x1edd9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $32

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0D

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1ede9: ; 0x1ede9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $32

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0E

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1edf9: ; 0x1edf9
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $32

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0E

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7D

	db $00 ; terminator

TileData_1ee09: ; 0x1ee09
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $64
	db $31

	db $01 ; number of tiles
	dw vBGMap + $84
	db $0E

	db $01 ; number of tiles
	dw vBGMap + $A5
	db $7C

	db $00 ; terminator

TileData_1ee19: ; 0x1ee19
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $33

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $0F

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee29: ; 0x1ee29
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $34

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $0F

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee39: ; 0x1ee39
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $34

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $10

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee49: ; 0x1ee49
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $34

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $10

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7F

	db $00 ; terminator

TileData_1ee59: ; 0x1ee59
	dw LoadTileLists
	db $03 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $6F
	db $33

	db $01 ; number of tiles
	dw vBGMap + $8F
	db $10

	db $01 ; number of tiles
	dw vBGMap + $AE
	db $7E

	db $00 ; terminator

TileData_1ee69: ; 0x1ee69
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $05

	db $01 ; number of tiles
	dw vBGMap + $68
	db $06

	db $00 ; terminator

TileData_1ee75: ; 0x1ee75
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $07

	db $01 ; number of tiles
	dw vBGMap + $68
	db $08

	db $00 ; terminator

TileData_1ee81: ; 0x1ee81
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $09

	db $01 ; number of tiles
	dw vBGMap + $68
	db $0A

	db $00 ; terminator

TileData_1ee8d: ; 0x1ee8d
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $48
	db $0B

	db $01 ; number of tiles
	dw vBGMap + $68
	db $0C

	db $00 ; terminator

TileData_1ee99: ; 0x1ee99
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $26, $27

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $28, $29

	db $00 ; terminator

TileData_1eea7: ; 0x1eea7
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $2A, $2B

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $2C, $2D

	db $00 ; terminator

TileData_1eeb5: ; 0x1eeb5
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $2E, $2F

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $30, $31

	db $00 ; terminator

TileData_1eec3: ; 0x1eec3
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $4B
	db $32, $33

	db $02 ; number of tiles
	dw vBGMap + $6B
	db $34, $35

	db $00 ; terminator

TileData_1eed1: ; 0x1eed1
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $16, $17

	db $02 ; number of tiles
	dw vBGMap + $69
	db $18, $19

	db $00 ; terminator

TileData_1eedf: ; 0x1eedf
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $1A, $1B

	db $02 ; number of tiles
	dw vBGMap + $69
	db $1C, $1D

	db $00 ; terminator

TileData_1eeed: ; 0x1eeed
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $1E, $1F

	db $02 ; number of tiles
	dw vBGMap + $69
	db $20, $21

	db $00 ; terminator

TileData_1eefb: ; 0x1eefb
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $49
	db $22, $23

	db $02 ; number of tiles
	dw vBGMap + $69
	db $24, $25

	db $00 ; terminator
