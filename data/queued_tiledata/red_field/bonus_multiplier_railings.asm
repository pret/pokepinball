BonusMultiplierRailingTileDataPointers_16fc8:
	dw BonusMultiplierRailingTileData_16ff0
	dw BonusMultiplierRailingTileData_16ff5
	dw BonusMultiplierRailingTileData_16ffa
	dw BonusMultiplierRailingTileData_16fff
	dw BonusMultiplierRailingTileData_17004
	dw BonusMultiplierRailingTileData_17009
	dw BonusMultiplierRailingTileData_1700e
	dw BonusMultiplierRailingTileData_17013
	dw BonusMultiplierRailingTileData_17018
	dw BonusMultiplierRailingTileData_1701d
	dw BonusMultiplierRailingTileData_17022
	dw BonusMultiplierRailingTileData_17027
	dw BonusMultiplierRailingTileData_1702c
	dw BonusMultiplierRailingTileData_17031
	dw BonusMultiplierRailingTileData_17036
	dw BonusMultiplierRailingTileData_1703b
	dw BonusMultiplierRailingTileData_17040
	dw BonusMultiplierRailingTileData_17045
	dw BonusMultiplierRailingTileData_1704a
	dw BonusMultiplierRailingTileData_1704f

BonusMultiplierRailingTileData_16ff0: ; 0x16ff0
	db $02
	dw BonusMultiplierRailingTileData_17054
	dw BonusMultiplierRailingTileData_1705e

BonusMultiplierRailingTileData_16ff5: ; 0x16ff5
	db $02
	dw BonusMultiplierRailingTileData_17068
	dw BonusMultiplierRailingTileData_17072

BonusMultiplierRailingTileData_16ffa: ; 0x16ffa
	db $02
	dw BonusMultiplierRailingTileData_1707c
	dw BonusMultiplierRailingTileData_17086

BonusMultiplierRailingTileData_16fff: ; 0x16fff
	db $02
	dw BonusMultiplierRailingTileData_17090
	dw BonusMultiplierRailingTileData_1709a

BonusMultiplierRailingTileData_17004: ; 0x17004
	db $02
	dw BonusMultiplierRailingTileData_170a4
	dw BonusMultiplierRailingTileData_170ae

BonusMultiplierRailingTileData_17009: ; 0x17009
	db $02
	dw BonusMultiplierRailingTileData_170b8
	dw BonusMultiplierRailingTileData_170c2

BonusMultiplierRailingTileData_1700e: ; 0x1700e
	db $02
	dw BonusMultiplierRailingTileData_170cc
	dw BonusMultiplierRailingTileData_170d6

BonusMultiplierRailingTileData_17013: ; 0x17013
	db $02
	dw BonusMultiplierRailingTileData_170e0
	dw BonusMultiplierRailingTileData_170ea

BonusMultiplierRailingTileData_17018: ; 0x17018
	db $02
	dw BonusMultiplierRailingTileData_170f4
	dw BonusMultiplierRailingTileData_170fe

BonusMultiplierRailingTileData_1701d: ; 0x1701d
	db $02
	dw BonusMultiplierRailingTileData_17108
	dw BonusMultiplierRailingTileData_17112

BonusMultiplierRailingTileData_17022: ; 0x17022
	db $02
	dw BonusMultiplierRailingTileData_1711c
	dw BonusMultiplierRailingTileData_17126

BonusMultiplierRailingTileData_17027: ; 0x17027
	db $02
	dw BonusMultiplierRailingTileData_17130
	dw BonusMultiplierRailingTileData_1713a

BonusMultiplierRailingTileData_1702c: ; 0x1702c
	db $02
	dw BonusMultiplierRailingTileData_17144
	dw BonusMultiplierRailingTileData_1714e

BonusMultiplierRailingTileData_17031: ; 0x17031
	db $02
	dw BonusMultiplierRailingTileData_17158
	dw BonusMultiplierRailingTileData_17162

BonusMultiplierRailingTileData_17036: ; 0x17036
	db $02
	dw BonusMultiplierRailingTileData_1716c
	dw BonusMultiplierRailingTileData_17176

BonusMultiplierRailingTileData_1703b: ; 0x1703b
	db $02
	dw BonusMultiplierRailingTileData_17180
	dw BonusMultiplierRailingTileData_1718a

BonusMultiplierRailingTileData_17040: ; 0x17040
	db $02
	dw BonusMultiplierRailingTileData_17194
	dw BonusMultiplierRailingTileData_1719e

BonusMultiplierRailingTileData_17045: ; 0x17045
	db $02
	dw BonusMultiplierRailingTileData_171a8
	dw BonusMultiplierRailingTileData_171b2

BonusMultiplierRailingTileData_1704a: ; 0x1704a
	db $02
	dw BonusMultiplierRailingTileData_171bc
	dw BonusMultiplierRailingTileData_171c6

BonusMultiplierRailingTileData_1704f: ; 0x1704f
	db $02
	dw BonusMultiplierRailingTileData_171d0
	dw BonusMultiplierRailingTileData_171da

BonusMultiplierRailingTileData_17054: ; 0x17054
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1280
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1705e: ; 0x1705e
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1140
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17068: ; 0x17068
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $12A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17072: ; 0x17072
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1160
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1707c: ; 0x1707c
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $12C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17086: ; 0x17086
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1180
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17090: ; 0x17090
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $12E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1709a: ; 0x1709a
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $11A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170a4: ; 0x170a4
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1300
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170ae: ; 0x170ae
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $11C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170b8: ; 0x170b8
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1320
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170c2: ; 0x170c2
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $11E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170cc: ; 0x170cc
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1340
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170d6: ; 0x170d6
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1200
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170e0: ; 0x170e0
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1360
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170ea: ; 0x170ea
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1220
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170f4: ; 0x170f4
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1380
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_170fe: ; 0x170fe
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1240
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17108: ; 0x17108
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $46
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $13A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17112: ; 0x17112
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $48
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1260
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1711c: ; 0x1711c
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1500
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17126: ; 0x17126
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $13C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17130: ; 0x17130
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1520
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1713a: ; 0x1713a
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $13E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17144: ; 0x17144
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1540
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1714e: ; 0x1714e
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1400
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17158: ; 0x17158
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1560
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17162: ; 0x17162
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1420
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1716c: ; 0x1716c
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1580
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17176: ; 0x17176
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1440
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17180: ; 0x17180
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $15A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1718a: ; 0x1718a
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1460
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_17194: ; 0x17194
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $15C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_1719e: ; 0x1719e
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1480
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171a8: ; 0x171a8
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $15E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171b2: ; 0x171b2
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $14A0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171bc: ; 0x171bc
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1600
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171c6: ; 0x171c6
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $14C0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171d0: ; 0x171d0
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4a
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $1620
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171da: ; 0x171da
	dw Func_11d2
	db $20, $02
	dw vTilesSH tile $4c
	dw StageRedFieldBottomIndicatorsGfx_Gameboy + $14E0
	db Bank(StageRedFieldBottomIndicatorsGfx_Gameboy)
	db $00

BonusMultiplierRailingTileData_171e4:
	dw BonusMultiplierRailingTileData_171ec
	dw BonusMultiplierRailingTileData_171ef
	dw BonusMultiplierRailingTileData_171f2
	dw BonusMultiplierRailingTileData_171f5

BonusMultiplierRailingTileData_171ec: ; 0x171ec
	db $01
	dw BonusMultiplierRailingTileData_171f8

BonusMultiplierRailingTileData_171ef: ; 0x171ef
	db $01
	dw BonusMultiplierRailingTileData_17204

BonusMultiplierRailingTileData_171f2: ; 0x171f2
	db $01
	dw BonusMultiplierRailingTileData_17210

BonusMultiplierRailingTileData_171f5: ; 0x171f5
	db $01
	dw BonusMultiplierRailingTileData_1721c

BonusMultiplierRailingTileData_171f8: ; 0x171f8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $C6

	db $01
	dw vBGMap + $24
	db $C7

	db $00

BonusMultiplierRailingTileData_17204: ; 0x17204
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $C8

	db $01
	dw vBGMap + $24
	db $C9

	db $00

BonusMultiplierRailingTileData_17210: ; 0x17210
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $CA

	db $01
	dw vBGMap + $2F
	db $CB

	db $00

BonusMultiplierRailingTileData_1721c: ; 0x1721c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $CC

	db $01
	dw vBGMap + $2F
	db $CD

	db $00

BonusMultiplierRailingTileDataPointers_17228:
	dw BonusMultiplierRailingTileData_17278
	dw BonusMultiplierRailingTileData_1727b
	dw BonusMultiplierRailingTileData_1727e
	dw BonusMultiplierRailingTileData_17281
	dw BonusMultiplierRailingTileData_17284
	dw BonusMultiplierRailingTileData_17287
	dw BonusMultiplierRailingTileData_1728a
	dw BonusMultiplierRailingTileData_1728d
	dw BonusMultiplierRailingTileData_17290
	dw BonusMultiplierRailingTileData_17293
	dw BonusMultiplierRailingTileData_17296
	dw BonusMultiplierRailingTileData_17299
	dw BonusMultiplierRailingTileData_1729c
	dw BonusMultiplierRailingTileData_1729f
	dw BonusMultiplierRailingTileData_172a2
	dw BonusMultiplierRailingTileData_172a5
	dw BonusMultiplierRailingTileData_172a8
	dw BonusMultiplierRailingTileData_172ab
	dw BonusMultiplierRailingTileData_172ae
	dw BonusMultiplierRailingTileData_172b1
	dw BonusMultiplierRailingTileData_172b4
	dw BonusMultiplierRailingTileData_172b7
	dw BonusMultiplierRailingTileData_172ba
	dw BonusMultiplierRailingTileData_172bd
	dw BonusMultiplierRailingTileData_172c0
	dw BonusMultiplierRailingTileData_172c3
	dw BonusMultiplierRailingTileData_172c6
	dw BonusMultiplierRailingTileData_172c9
	dw BonusMultiplierRailingTileData_172cc
	dw BonusMultiplierRailingTileData_172cf
	dw BonusMultiplierRailingTileData_172d2
	dw BonusMultiplierRailingTileData_172d5
	dw BonusMultiplierRailingTileData_172d8
	dw BonusMultiplierRailingTileData_172db
	dw BonusMultiplierRailingTileData_172de
	dw BonusMultiplierRailingTileData_172e1
	dw BonusMultiplierRailingTileData_172e4
	dw BonusMultiplierRailingTileData_172e7
	dw BonusMultiplierRailingTileData_172ea
	dw BonusMultiplierRailingTileData_172ed

BonusMultiplierRailingTileData_17278: ; 0x17278
	db $01
	dw BonusMultiplierRailingTileData_172f0

BonusMultiplierRailingTileData_1727b: ; 0x1727b
	db $01
	dw BonusMultiplierRailingTileData_172fc

BonusMultiplierRailingTileData_1727e: ; 0x1727e
	db $01
	dw BonusMultiplierRailingTileData_17308

BonusMultiplierRailingTileData_17281: ; 0x17281
	db $01
	dw BonusMultiplierRailingTileData_17314

BonusMultiplierRailingTileData_17284: ; 0x17284
	db $01
	dw BonusMultiplierRailingTileData_17320

BonusMultiplierRailingTileData_17287: ; 0x17287
	db $01
	dw BonusMultiplierRailingTileData_1732c

BonusMultiplierRailingTileData_1728a: ; 0x1728a
	db $01
	dw BonusMultiplierRailingTileData_17338

BonusMultiplierRailingTileData_1728d: ; 0x1728d
	db $01
	dw BonusMultiplierRailingTileData_17344

BonusMultiplierRailingTileData_17290: ; 0x17290
	db $01
	dw BonusMultiplierRailingTileData_17350

BonusMultiplierRailingTileData_17293: ; 0x17293
	db $01
	dw BonusMultiplierRailingTileData_1735c

BonusMultiplierRailingTileData_17296: ; 0x17296
	db $01
	dw BonusMultiplierRailingTileData_17368

BonusMultiplierRailingTileData_17299: ; 0x17299
	db $01
	dw BonusMultiplierRailingTileData_17374

BonusMultiplierRailingTileData_1729c: ; 0x1729c
	db $01
	dw BonusMultiplierRailingTileData_17380

BonusMultiplierRailingTileData_1729f: ; 0x1729f
	db $01
	dw BonusMultiplierRailingTileData_1738c

BonusMultiplierRailingTileData_172a2: ; 0x172a2
	db $01
	dw BonusMultiplierRailingTileData_17398

BonusMultiplierRailingTileData_172a5: ; 0x172a5
	db $01
	dw BonusMultiplierRailingTileData_173a4

BonusMultiplierRailingTileData_172a8: ; 0x172a8
	db $01
	dw BonusMultiplierRailingTileData_173b0

BonusMultiplierRailingTileData_172ab: ; 0x172ab
	db $01
	dw BonusMultiplierRailingTileData_173bc

BonusMultiplierRailingTileData_172ae: ; 0x172ae
	db $01
	dw BonusMultiplierRailingTileData_173c8

BonusMultiplierRailingTileData_172b1: ; 0x172b1
	db $01
	dw BonusMultiplierRailingTileData_173d4

BonusMultiplierRailingTileData_172b4: ; 0x172b4
	db $01
	dw BonusMultiplierRailingTileData_173e0

BonusMultiplierRailingTileData_172b7: ; 0x172b7
	db $01
	dw BonusMultiplierRailingTileData_173ec

BonusMultiplierRailingTileData_172ba: ; 0x172ba
	db $01
	dw BonusMultiplierRailingTileData_173f8

BonusMultiplierRailingTileData_172bd: ; 0x172bd
	db $01
	dw BonusMultiplierRailingTileData_17404

BonusMultiplierRailingTileData_172c0: ; 0x172c0
	db $01
	dw BonusMultiplierRailingTileData_17410

BonusMultiplierRailingTileData_172c3: ; 0x172c3
	db $01
	dw BonusMultiplierRailingTileData_1741c

BonusMultiplierRailingTileData_172c6: ; 0x172c6
	db $01
	dw BonusMultiplierRailingTileData_17428

BonusMultiplierRailingTileData_172c9: ; 0x172c9
	db $01
	dw BonusMultiplierRailingTileData_17434

BonusMultiplierRailingTileData_172cc: ; 0x172cc
	db $01
	dw BonusMultiplierRailingTileData_17440

BonusMultiplierRailingTileData_172cf: ; 0x172cf
	db $01
	dw BonusMultiplierRailingTileData_1744c

BonusMultiplierRailingTileData_172d2: ; 0x172d2
	db $01
	dw BonusMultiplierRailingTileData_17458

BonusMultiplierRailingTileData_172d5: ; 0x172d5
	db $01
	dw BonusMultiplierRailingTileData_17464

BonusMultiplierRailingTileData_172d8: ; 0x172d8
	db $01
	dw BonusMultiplierRailingTileData_17470

BonusMultiplierRailingTileData_172db: ; 0x172db
	db $01
	dw BonusMultiplierRailingTileData_1747c

BonusMultiplierRailingTileData_172de: ; 0x172de
	db $01
	dw BonusMultiplierRailingTileData_17488

BonusMultiplierRailingTileData_172e1: ; 0x172e1
	db $01
	dw BonusMultiplierRailingTileData_17494

BonusMultiplierRailingTileData_172e4: ; 0x172e4
	db $01
	dw BonusMultiplierRailingTileData_174a0

BonusMultiplierRailingTileData_172e7: ; 0x172e7
	db $01
	dw BonusMultiplierRailingTileData_174ac

BonusMultiplierRailingTileData_172ea: ; 0x172ea
	db $01
	dw BonusMultiplierRailingTileData_174b8

BonusMultiplierRailingTileData_172ed: ; 0x172ed
	db $01
	dw BonusMultiplierRailingTileData_174c4

BonusMultiplierRailingTileData_172f0: ; 0x172f0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $40

	db $01
	dw vBGMap + $24
	db $41

	db $00

BonusMultiplierRailingTileData_172fc: ; 0x172fc
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $42

	db $01
	dw vBGMap + $24
	db $43

	db $00

BonusMultiplierRailingTileData_17308: ; 0x17308
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $44

	db $01
	dw vBGMap + $24
	db $45

	db $00

BonusMultiplierRailingTileData_17314: ; 0x17314
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $46

	db $01
	dw vBGMap + $24
	db $47

	db $00

BonusMultiplierRailingTileData_17320: ; 0x17320
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $48

	db $01
	dw vBGMap + $24
	db $49

	db $00

BonusMultiplierRailingTileData_1732c: ; 0x1732c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $4A

	db $01
	dw vBGMap + $24
	db $4B

	db $00

BonusMultiplierRailingTileData_17338: ; 0x17338
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $4C

	db $01
	dw vBGMap + $24
	db $4D

	db $00

BonusMultiplierRailingTileData_17344: ; 0x17344
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $4E

	db $01
	dw vBGMap + $24
	db $4F

	db $00

BonusMultiplierRailingTileData_17350: ; 0x17350
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $50

	db $01
	dw vBGMap + $24
	db $51

	db $00

BonusMultiplierRailingTileData_1735c: ; 0x1735c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $52

	db $01
	dw vBGMap + $24
	db $53

	db $00

BonusMultiplierRailingTileData_17368: ; 0x17368
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $2C

	db $01
	dw vBGMap + $24
	db $2D

	db $00

BonusMultiplierRailingTileData_17374: ; 0x17374
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $2E

	db $01
	dw vBGMap + $24
	db $2F

	db $00

BonusMultiplierRailingTileData_17380: ; 0x17380
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $30

	db $01
	dw vBGMap + $24
	db $31

	db $00

BonusMultiplierRailingTileData_1738c: ; 0x1738c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $32

	db $01
	dw vBGMap + $24
	db $33

	db $00

BonusMultiplierRailingTileData_17398: ; 0x17398
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $34

	db $01
	dw vBGMap + $24
	db $35

	db $00

BonusMultiplierRailingTileData_173a4: ; 0x173a4
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $36

	db $01
	dw vBGMap + $24
	db $37

	db $00

BonusMultiplierRailingTileData_173b0: ; 0x173b0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $38

	db $01
	dw vBGMap + $24
	db $39

	db $00

BonusMultiplierRailingTileData_173bc: ; 0x173bc
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $3A

	db $01
	dw vBGMap + $24
	db $3B

	db $00

BonusMultiplierRailingTileData_173c8: ; 0x173c8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $3C

	db $01
	dw vBGMap + $24
	db $3D

	db $00

BonusMultiplierRailingTileData_173d4: ; 0x173d4
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $4
	db $3E

	db $01
	dw vBGMap + $24
	db $3F

	db $00

BonusMultiplierRailingTileData_173e0: ; 0x173e0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $68

	db $01
	dw vBGMap + $2F
	db $69

	db $00

BonusMultiplierRailingTileData_173ec: ; 0x173ec
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $6A

	db $01
	dw vBGMap + $2F
	db $6B

	db $00

BonusMultiplierRailingTileData_173f8: ; 0x173f8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $6C

	db $01
	dw vBGMap + $2F
	db $6D

	db $00

BonusMultiplierRailingTileData_17404: ; 0x17404
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $6E

	db $01
	dw vBGMap + $2F
	db $6F

	db $00

BonusMultiplierRailingTileData_17410: ; 0x17410
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $70

	db $01
	dw vBGMap + $2F
	db $71

	db $00

BonusMultiplierRailingTileData_1741c: ; 0x1741c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $72

	db $01
	dw vBGMap + $2F
	db $73

	db $00

BonusMultiplierRailingTileData_17428: ; 0x17428
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $74

	db $01
	dw vBGMap + $2F
	db $75

	db $00

BonusMultiplierRailingTileData_17434: ; 0x17434
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $76

	db $01
	dw vBGMap + $2F
	db $77

	db $00

BonusMultiplierRailingTileData_17440: ; 0x17440
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $78

	db $01
	dw vBGMap + $2F
	db $79

	db $00

BonusMultiplierRailingTileData_1744c: ; 0x1744c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $7A

	db $01
	dw vBGMap + $2F
	db $7B

	db $00

BonusMultiplierRailingTileData_17458: ; 0x17458
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $54

	db $01
	dw vBGMap + $2F
	db $55

	db $00

BonusMultiplierRailingTileData_17464: ; 0x17464
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $56

	db $01
	dw vBGMap + $2F
	db $57

	db $00

BonusMultiplierRailingTileData_17470: ; 0x17470
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $58

	db $01
	dw vBGMap + $2F
	db $59

	db $00

BonusMultiplierRailingTileData_1747c: ; 0x1747c
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $5A

	db $01
	dw vBGMap + $2F
	db $5B

	db $00

BonusMultiplierRailingTileData_17488: ; 0x17488
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $5C

	db $01
	dw vBGMap + $2F
	db $5D

	db $00

BonusMultiplierRailingTileData_17494: ; 0x17494
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $5E

	db $01
	dw vBGMap + $2F
	db $5F

	db $00

BonusMultiplierRailingTileData_174a0: ; 0x174a0
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $60

	db $01
	dw vBGMap + $2F
	db $61

	db $00

BonusMultiplierRailingTileData_174ac: ; 0x174ac
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $62

	db $01
	dw vBGMap + $2F
	db $63

	db $00

BonusMultiplierRailingTileData_174b8: ; 0x174b8
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $64

	db $01
	dw vBGMap + $2F
	db $65

	db $00

BonusMultiplierRailingTileData_174c4: ; 0x174c4
	dw LoadTileLists
	db $02

	db $01
	dw vBGMap + $F
	db $66

	db $01
	dw vBGMap + $2F
	db $67

	db $00
