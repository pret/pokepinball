TileDataPointers_1cb60:
	dw TileData_1cb80
	dw TileData_1cb85
	dw TileData_1cb8a
	dw TileData_1cb8f
	dw TileData_1cb94
	dw TileData_1cb99
	dw TileData_1cb9e
	dw TileData_1cba3
	dw TileData_1cba8
	dw TileData_1cbad
	dw TileData_1cbb2
	dw TileData_1cbb7
	dw TileData_1cbbc
	dw TileData_1cbc1
	dw TileData_1cbc6
	dw TileData_1cbcb

TileData_1cb80: ; 0x1cb80
	db $02
	dw TileData_1cbd0
	dw TileData_1cbda

TileData_1cb85: ; 0x1cb85
	db $02
	dw TileData_1cbe4
	dw TileData_1cbee

TileData_1cb8a: ; 0x1cb8a
	db $02
	dw TileData_1cbf8
	dw TileData_1cc02

TileData_1cb8f: ; 0x1cb8f
	db $02
	dw TileData_1cc0c
	dw TileData_1cc16

TileData_1cb94: ; 0x1cb94
	db $02
	dw TileData_1cc20
	dw TileData_1cc2a

TileData_1cb99: ; 0x1cb99
	db $02
	dw TileData_1cc34
	dw TileData_1cc3e

TileData_1cb9e: ; 0x1cb9e
	db $02
	dw TileData_1cc48
	dw TileData_1cc52

TileData_1cba3: ; 0x1cba3
	db $02
	dw TileData_1cc5c
	dw TileData_1cc66

TileData_1cba8: ; 0x1cba8
	db $02
	dw TileData_1cc70
	dw TileData_1cc7a

TileData_1cbad: ; 0x1cbad
	db $02
	dw TileData_1cc84
	dw TileData_1cc8e

TileData_1cbb2: ; 0x1cbb2
	db $02
	dw TileData_1cc98
	dw TileData_1cca2

TileData_1cbb7: ; 0x1cbb7
	db $02
	dw TileData_1ccac
	dw TileData_1ccb6

TileData_1cbbc: ; 0x1cbbc
	db $02
	dw TileData_1ccc0
	dw TileData_1ccca

TileData_1cbc1: ; 0x1cbc1
	db $02
	dw TileData_1ccd4
	dw TileData_1ccde

TileData_1cbc6: ; 0x1cbc6
	db $02
	dw TileData_1cce8
	dw TileData_1ccf2

TileData_1cbcb: ; 0x1cbcb
	db $02
	dw TileData_1ccfc
	dw TileData_1cd06

TileData_1cbd0: ; 0xcbd0
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageBlueFieldTopBaseGameBoyGfx + $c20
	db Bank(StageBlueFieldTopBaseGameBoyGfx)
	db $00 ; terminator

TileData_1cbda: ; 0xcbda
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageBlueFieldTopBaseGameBoyGfx + $c40
	db Bank(StageBlueFieldTopBaseGameBoyGfx)
	db $00 ; terminator

TileData_1cbe4: ; 0xcbe4
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1800
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cbee: ; 0xcbee
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1820
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cbf8: ; 0xcbf8
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1840
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc02: ; 0xcc02
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1860
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc0c: ; 0xcc0c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1880
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc16: ; 0xcc16
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $18A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc20: ; 0xcc20
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $18C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc2a: ; 0xcc2a
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $18E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc34: ; 0xcc34
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1900
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc3e: ; 0xcc3e
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1920
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc48: ; 0xcc48
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1940
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc52: ; 0xcc52
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1960
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc5c: ; 0xcc5c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1980
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc66: ; 0xcc66
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $19A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc70: ; 0xcc70
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $19C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc7a: ; 0xcc7a
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $19E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc84: ; 0xcc84
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc8e: ; 0xcc8e
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cc98: ; 0xcc98
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cca2: ; 0xcca2
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccac: ; 0xccac
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1A80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccb6: ; 0xccb6
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1AA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccc0: ; 0xccc0
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1AC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccca: ; 0xccca
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1AE0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccd4: ; 0xccd4
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B00
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccde: ; 0xccde
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B20
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cce8: ; 0xcce8
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B40
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccf2: ; 0xccf2
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B60
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1ccfc: ; 0xccfc
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6C
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1B80
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileData_1cd06: ; 0xcd06
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $6E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1BA0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00 ; terminator

TileDataPointers_1cd10:
	dw TileData_1cd30
	dw TileData_1cd33
	dw TileData_1cd36
	dw TileData_1cd39
	dw TileData_1cd3c
	dw TileData_1cd3f
	dw TileData_1cd42
	dw TileData_1cd45
	dw TileData_1cd48
	dw TileData_1cd4b
	dw TileData_1cd4e
	dw TileData_1cd51
	dw TileData_1cd54
	dw TileData_1cd57
	dw TileData_1cd5a
	dw TileData_1cd5d

TileData_1cd30: ; 0x1cd30
	db $01
	dw TileData_1cd60

TileData_1cd33: ; 0x1cd33
	db $01
	dw TileData_1cd6e

TileData_1cd36: ; 0x1cd36
	db $01
	dw TileData_1cd7c

TileData_1cd39: ; 0x1cd39
	db $01
	dw TileData_1cd8a

TileData_1cd3c: ; 0x1cd3c
	db $01
	dw TileData_1cd98

TileData_1cd3f: ; 0x1cd3f
	db $01
	dw TileData_1cda6

TileData_1cd42: ; 0x1cd42
	db $01
	dw TileData_1cdb4

TileData_1cd45: ; 0x1cd45
	db $01
	dw TileData_1cdc2

TileData_1cd48: ; 0x1cd48
	db $01
	dw TileData_1cdd0

TileData_1cd4b: ; 0x1cd4b
	db $01
	dw TileData_1cdde

TileData_1cd4e: ; 0x1cd4e
	db $01
	dw TileData_1cdec

TileData_1cd51: ; 0x1cd51
	db $01
	dw TileData_1cdfa

TileData_1cd54: ; 0x1cd54
	db $01
	dw TileData_1ce08

TileData_1cd57: ; 0x1cd57
	db $01
	dw TileData_1ce16

TileData_1cd5a: ; 0x1cd5a
	db $01
	dw TileData_1ce24

TileData_1cd5d: ; 0x1cd5d
	db $01
	dw TileData_1ce32

TileData_1cd60: ; 0x1cd60
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $4A, $4B

	db $00 ; terminator

TileData_1cd6e: ; 0x1cd6e
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $4C, $4D

	db $00 ; terminator

TileData_1cd7c: ; 0x1cd7c
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $4E, $4F

	db $00 ; terminator

TileData_1cd8a: ; 0x1cd8a
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $50, $51

	db $00 ; terminator

TileData_1cd98: ; 0x1cd98
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $52, $53

	db $00 ; terminator

TileData_1cda6: ; 0x1cda6
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $54, $55

	db $00 ; terminator

TileData_1cdb4: ; 0x1cdb4
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $56, $57

	db $00 ; terminator

TileData_1cdc2: ; 0x1cdc2
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdd0: ; 0x1cdd0
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $48, $49

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdde: ; 0x1cdde
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $5C, $5D

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdec: ; 0x1cdec
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $5E, $5F

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1cdfa: ; 0x1cdfa
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $60, $61

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce08: ; 0x1ce08
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $62, $63

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce16: ; 0x1ce16
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $64, $65

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce24: ; 0x1ce24
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $66, $67

	db $02 ; number of tiles
	dw vBGMap + $163
	db $58, $59

	db $00 ; terminator

TileData_1ce32: ; 0x1ce32
	dw LoadTileLists
	db $04 ; total number of tiles

	db $02 ; number of tiles
	dw vBGMap + $143
	db $68, $69

	db $02 ; number of tiles
	dw vBGMap + $163
	db $6A, $6B

	db $00 ; terminator
