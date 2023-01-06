TileDataPointers_1df66:
	dw TileData_1df74
	dw TileData_1df77
	dw TileData_1df7a
	dw TileData_1df7f
	dw TileData_1df84
	dw TileData_1df89
	dw TileData_1df8e

TileData_1df74: ; 0x1df74
	db $01
	dw TileData_1df93

TileData_1df77: ; 0x1df77
	db $01
	dw TileData_1df9f

TileData_1df7a: ; 0x1df7a
	db $02
	dw TileData_1dfab
	dw TileData_1dfb5

TileData_1df7f: ; 0x1df7f
	db $02
	dw TileData_1dfbf
	dw TileData_1dfc9

TileData_1df84: ; 0x1df84
	db $02
	dw TileData_1dfd3
	dw TileData_1dfdd

TileData_1df89: ; 0x1df89
	db $02
	dw TileData_1dfe7
	dw TileData_1dff1

TileData_1df8e: ; 0x1df8e
	db $02
	dw TileData_1dffb
	dw TileData_1e005

TileData_1df93: ; 0x1df93
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $4A

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $4B

	db $00 ; terminator

TileData_1df9f: ; 0x1df9f
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $4C

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $4D

	db $00 ; terminator

TileData_1dfab: ; 0x1dfab
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageBlueFieldBottomBaseGameBoyGfx + $CE0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfb5: ; 0x1dfb5
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageBlueFieldBottomBaseGameBoyGfx + $D10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfbf: ; 0x1dfbf
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageBlueFieldBottomBaseGameBoyGfx + $D30
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfc9: ; 0x1dfc9
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageBlueFieldBottomBaseGameBoyGfx + $D60
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1dfd3: ; 0x1dfd3
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $20B0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dfdd: ; 0x1dfdd
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $20E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dfe7: ; 0x1dfe7
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2100
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dff1: ; 0x1dff1
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2130
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1dffb: ; 0x1dffb
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $4E
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2150
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e005: ; 0x1e005
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $51
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2180
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileDataPointers_1e00f:
	dw TileData_1e01d
	dw TileData_1e020
	dw TileData_1e023
	dw TileData_1e026
	dw TileData_1e029
	dw TileData_1e02c
	dw TileData_1e02f

TileData_1e01d: ; 0x1e01d
	db $01
	dw TileData_1e032

TileData_1e020: ; 0x1e020
	db $01
	dw TileData_1e03e

TileData_1e023: ; 0x1e023
	db $01
	dw TileData_1e04a

TileData_1e026: ; 0x1e026
	db $01
	dw TileData_1e05c

TileData_1e029: ; 0x1e029
	db $01
	dw TileData_1e06e

TileData_1e02c: ; 0x1e02c
	db $01
	dw TileData_1e080

TileData_1e02f: ; 0x1e02f
	db $01
	dw TileData_1e092

TileData_1e032: ; 0x1e032
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $35

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $36

	db $00 ; terminator

TileData_1e03e: ; 0x1e03e
	dw LoadTileLists
	db $02 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $A3
	db $37

	db $01 ; number of tiles
	dw vBGMap + $C3
	db $38

	db $00 ; terminator

TileData_1e04a: ; 0x1e04a
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $4F

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $50, $51

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $52, $53

	db $00 ; terminator

TileData_1e05c: ; 0x1e05c
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $54

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $55, $56

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $57, $58

	db $00 ; terminator

TileData_1e06e: ; 0x1e06e
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $59

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $5A, $5B

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $5C, $5D

	db $00 ; terminator

TileData_1e080: ; 0x1e080
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $59

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $5A, $5E

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $5C, $5F

	db $00 ; terminator

TileData_1e092: ; 0x1e092
	dw LoadTileLists
	db $05 ; total number of tiles

	db $01 ; number of tiles
	dw vBGMap + $90
	db $60

	db $02 ; number of tiles
	dw vBGMap + $AF
	db $61, $62

	db $02 ; number of tiles
	dw vBGMap + $CF
	db $63, $64

	db $00 ; terminator

TileDataPointers_1e0a4:
	dw TileData_1e0b8
	dw TileData_1e0bf
	dw TileData_1e0c6
	dw TileData_1e0cd
	dw TileData_1e0d4
	dw TileData_1e0d9
	dw TileData_1e0de
	dw TileData_1e0e3
	dw TileData_1e0e8
	dw TileData_1e0ed

TileData_1e0b8: ; 0x1e0b8
	db $03
	dw TileData_1e0f0
	dw TileData_1e0fa
	dw TileData_1e104

TileData_1e0bf: ; 0x1e0bf
	db $03
	dw TileData_1e10e
	dw TileData_1e118
	dw TileData_1e122

TileData_1e0c6: ; 0x1e0c6
	db $03
	dw TileData_1e12c
	dw TileData_1e136
	dw TileData_1e140

TileData_1e0cd: ; 0x1e0cd
	db $03
	dw TileData_1e14a
	dw TileData_1e154
	dw TileData_1e15e

TileData_1e0d4: ; 0x1e0d4
	db $02
	dw TileData_1e168
	dw TileData_1e172

TileData_1e0d9: ; 0x1e0d9
	db $02
	dw TileData_1e17c
	dw TileData_1e186

TileData_1e0de: ; 0x1e0de
	db $02
	dw TileData_1e190
	dw TileData_1e19a

TileData_1e0e3: ; 0x1e0e3
	db $02
	dw TileData_1e1a4
	dw TileData_1e1ae

TileData_1e0e8: ; 0x1e0e8
	db $02
	dw TileData_1e1b8
	dw TileData_1e1c2

TileData_1e0ed: ; 0x1e0ed
	db $01
	dw TileData_1e1cc

TileData_1e0f0: ; 0x1e0f0
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageBlueFieldBottomBaseGameBoyGfx + $C10
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e0fa: ; 0x1e0fa
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageBlueFieldBottomBaseGameBoyGfx + $C40
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e104: ; 0x1e104
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageBlueFieldBottomBaseGameBoyGfx + $C70
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e10e: ; 0x1e10e
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1FC0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e118: ; 0x1e118
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2050
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e122: ; 0x1e122
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e12c: ; 0x1e12c
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1FF0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e136: ; 0x1e136
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2050
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e140: ; 0x1e140
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e14a: ; 0x1e14a
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $41
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2020
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e154: ; 0x1e154
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2050
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e15e: ; 0x1e15e
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2080
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e168: ; 0x1e168
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageBlueFieldBottomBaseGameBoyGfx + $D80
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e172: ; 0x1e172
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageBlueFieldBottomBaseGameBoyGfx + $DA0
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e17c: ; 0x1e17c
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e186: ; 0x1e186
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e190: ; 0x1e190
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e19a: ; 0x1e19a
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2210
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e1a4: ; 0x1e1a4
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $21C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e1ae: ; 0x1e1ae
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $5A
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $2240
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

TileData_1e1b8: ; 0x1e1b8
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $44
	dw StageBlueFieldBottomBaseGameBoyGfx + $C40
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e1c2: ; 0x1e1c2
	dw Func_11d2
	db $30, $03
	dw vTilesBG tile $47
	dw StageBlueFieldBottomBaseGameBoyGfx + $C70
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileData_1e1cc: ; 0x1e1cc
	dw Func_11d2
	db $20, $02
	dw vTilesBG tile $58
	dw StageBlueFieldBottomBaseGameBoyGfx + $D80
	db Bank(StageBlueFieldBottomBaseGameBoyGfx)
	db $00

TileDataPointers_1e1d6:
	dw TileData_1e1f2
	dw TileData_1e1f5
	dw TileData_1e1f8
	dw TileData_1e1fb
	dw TileData_1e1fe
	dw TileData_1e201
	dw TileData_1e204
	dw TileData_1e207
	dw TileData_1e20a
	dw TileData_1e20d
	dw TileData_1e210
	dw TileData_1e213
	dw TileData_1e216
	dw TileData_1e219
	
TileData_1e1f2: ; 0x1e1f2
	db $01
	dw TileData_1e21c

TileData_1e1f5: ; 0x1e1f5
	db $01
	dw TileData_1e238

TileData_1e1f8: ; 0x1e1f8
	db $01
	dw TileData_1e254

TileData_1e1fb: ; 0x1e1fb
	db $01
	dw TileData_1e270

TileData_1e1fe: ; 0x1e1fe
	db $01
	dw TileData_1e28c

TileData_1e201: ; 0x1e201
	db $01
	dw TileData_1e2a2

TileData_1e204: ; 0x1e204
	db $01
	dw TileData_1e2b8

TileData_1e207: ; 0x1e207
	db $01
	dw TileData_1e2ce

TileData_1e20a: ; 0x1e20a
	db $01
	dw TileData_1e2e4

TileData_1e20d: ; 0x1e20d
	db $01
	dw TileData_1e2fa

TileData_1e210: ; 0x1e210
	db $01
	dw TileData_1e310

TileData_1e213: ; 0x1e213
	db $01
	dw TileData_1e326

TileData_1e216: ; 0x1e216
	db $01
	dw TileData_1e336

TileData_1e219: ; 0x1e219
	db $01
	dw TileData_1e346

TileData_1e21c: ; 0x1e21c
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $36, $37, $38

	db $03 ; number of tiles
	dw vBGMap + $80
	db $39, $3A, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e238: ; 0x1e238
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $3C, $37, $38

	db $03 ; number of tiles
	dw vBGMap + $80
	db $3D, $3E, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $52, $53, $54

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $55, $56, $57

	db $00 ; terminator

TileData_1e254: ; 0x1e254
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $40, $41, $38

	db $03 ; number of tiles
	dw vBGMap + $80
	db $42, $43, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $52, $53, $54

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $55, $56, $57

	db $00 ; terminator

TileData_1e270: ; 0x1e270
	dw LoadTileLists
	db $0C ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $60
	db $36, $46, $47

	db $03 ; number of tiles
	dw vBGMap + $80
	db $48, $49, $4A

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $52, $53, $54

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $55, $56, $57

	db $00 ; terminator

TileData_1e28c: ; 0x1e28c
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $67, $68

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $69, $6A, $6B

	db $00 ; terminator

TileData_1e2a2: ; 0x1e2a2
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $6C, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $6D, $6E, $68

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $6F, $70, $6B

	db $00 ; terminator

TileData_1e2b8: ; 0x1e2b8
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $6C, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $72, $68

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $69, $73, $6B

	db $00 ; terminator

TileData_1e2ce: ; 0x1e2ce
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $75, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $76, $77

	db $03 ; number of tiles
	dw vBGMap + $D1
	db $69, $78, $79

	db $00 ; terminator

TileData_1e2e4: ; 0x1e2e4
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $80
	db $3F, $3A, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e2fa: ; 0x1e2fa
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $80
	db $44, $45, $3B

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e310: ; 0x1e310
	dw LoadTileLists
	db $09 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $80
	db $39, $4B, $4A

	db $03 ; number of tiles
	dw vBGMap + $A0
	db $4C, $4D, $4E

	db $03 ; number of tiles
	dw vBGMap + $C0
	db $4F, $50, $51

	db $00 ; terminator

TileData_1e326: ; 0x1e326
	dw LoadTileLists
	db $06 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $6D, $71, $68

	db $00 ; terminator

TileData_1e336: ; 0x1e336
	dw LoadTileLists
	db $06 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $74, $68

	db $00 ; terminator

TileData_1e346: ; 0x1e346
	dw LoadTileLists
	db $06 ; total number of tiles

	db $03 ; number of tiles
	dw vBGMap + $91
	db $4D, $65, $4E

	db $03 ; number of tiles
	dw vBGMap + $B1
	db $66, $67, $77

	db $00 ; terminator
