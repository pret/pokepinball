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
