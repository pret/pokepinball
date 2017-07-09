PinballUpgradeTransition_TileDataPointers:
	dw TransitionToPokeBallPointers  ; POKE_BALL
	dw TransitionToPokeBallPointers  ; POKE_BALL
	dw TransitionToGreatBallPointers ; GREAT_BALL
	dw TransitionToUltraBallPointers ; ULTRA_BALL
	dw TransitionToUltraBallPointers ; ULTRA_BALL
	dw TransitionToMasterBallPointers ; MASTER_BALL

TransitionToPokeBallPointers:
	db 11
	dw TransitionToPokeBall_TileData_1
	dw TransitionToPokeBall_TileData_2
	dw TransitionToPokeBall_TileData_3
	dw TransitionToPokeBall_TileData_4
	dw TransitionToPokeBall_TileData_5
	dw TransitionToPokeBall_TileData_6
	dw TransitionToPokeBall_TileData_7
	dw TransitionToPokeBall_TileData_8
	dw TransitionToPokeBall_TileData_9
	dw TransitionToPokeBall_TileData_10
	dw TransitionToPokeBall_TileData_11

TransitionToGreatBallPointers:
	db 11
	dw TransitionToGreatBall_TileData_1
	dw TransitionToGreatBall_TileData_2
	dw TransitionToGreatBall_TileData_3
	dw TransitionToGreatBall_TileData_4
	dw TransitionToGreatBall_TileData_5
	dw TransitionToGreatBall_TileData_6
	dw TransitionToGreatBall_TileData_7
	dw TransitionToGreatBall_TileData_8
	dw TransitionToGreatBall_TileData_9
	dw TransitionToGreatBall_TileData_10
	dw TransitionToGreatBall_TileData_11

TransitionToUltraBallPointers:
	db 11
	dw TransitionToUltraBall_TileData_1
	dw TransitionToUltraBall_TileData_2
	dw TransitionToUltraBall_TileData_3
	dw TransitionToUltraBall_TileData_4
	dw TransitionToUltraBall_TileData_5
	dw TransitionToUltraBall_TileData_6
	dw TransitionToUltraBall_TileData_7
	dw TransitionToUltraBall_TileData_8
	dw TransitionToUltraBall_TileData_9
	dw TransitionToUltraBall_TileData_10
	dw TransitionToUltraBall_TileData_11

TransitionToMasterBallPointers:
	db 11
	dw TransitionToMasterBall_TileData_1
	dw TransitionToMasterBall_TileData_2
	dw TransitionToMasterBall_TileData_3
	dw TransitionToMasterBall_TileData_4
	dw TransitionToMasterBall_TileData_5
	dw TransitionToMasterBall_TileData_6
	dw TransitionToMasterBall_TileData_7
	dw TransitionToMasterBall_TileData_8
	dw TransitionToMasterBall_TileData_9
	dw TransitionToMasterBall_TileData_10
	dw TransitionToMasterBall_TileData_11

TransitionToPokeBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballPokeballGfx + $0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballPokeballGfx + $30
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballPokeballGfx + $60
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballPokeballGfx + $90
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballPokeballGfx + $c0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballPokeballGfx + $f0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballPokeballGfx + $120
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballPokeballGfx + $150
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballPokeballGfx + $180
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballPokeballGfx + $1b0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToPokeBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballPokeballGfx + $1e0
	db Bank(PinballPokeballGfx)
	db $00

TransitionToGreatBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballGreatballGfx + $0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballGreatballGfx + $30
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballGreatballGfx + $60
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballGreatballGfx + $90
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballGreatballGfx + $c0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballGreatballGfx + $f0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballGreatballGfx + $120
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballGreatballGfx + $150
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballGreatballGfx + $180
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballGreatballGfx + $1b0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToGreatBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballGreatballGfx + $1e0
	db Bank(PinballGreatballGfx)
	db $00

TransitionToUltraBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballUltraballGfx + $0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballUltraballGfx + $30
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballUltraballGfx + $60
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballUltraballGfx + $90
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballUltraballGfx + $c0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballUltraballGfx + $f0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballUltraballGfx + $120
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballUltraballGfx + $150
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballUltraballGfx + $180
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballUltraballGfx + $1b0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToUltraBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballUltraballGfx + $1e0
	db Bank(PinballUltraballGfx)
	db $00

TransitionToMasterBall_TileData_1:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $40)
	dw PinballMasterballGfx + $0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_2:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $43)
	dw PinballMasterballGfx + $30
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_3:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $46)
	dw PinballMasterballGfx + $60
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_4:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $49)
	dw PinballMasterballGfx + $90
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_5:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4c)
	dw PinballMasterballGfx + $c0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_6:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $4f)
	dw PinballMasterballGfx + $f0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_7:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $52)
	dw PinballMasterballGfx + $120
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_8:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $55)
	dw PinballMasterballGfx + $150
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_9:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $58)
	dw PinballMasterballGfx + $180
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_10:
	dw Func_11d2
	db $30, $03
	dw (vTilesOB tile $5b)
	dw PinballMasterballGfx + $1b0
	db Bank(PinballMasterballGfx)
	db $00

TransitionToMasterBall_TileData_11:
	dw Func_11d2
	db $20, $02
	dw (vTilesOB tile $5e)
	dw PinballMasterballGfx + $1e0
	db Bank(PinballMasterballGfx)
	db $00

PinballUpgradeTransitionPalettes:
	dw TransitionToPokeBall_PaletteData
	dw TransitionToPokeBall_PaletteData
	dw TransitionToGreatBall_PaletteData
	dw TransitionToUltraBall_PaletteData
	dw TransitionToUltraBall_PaletteData
	dw TransitionToMasterBall_PaletteData

TransitionToPokeBall_PaletteData:
	db $08
	db $04 ; number of colors
	db $40
	dw PokeBallObjPalette
	db Bank(PokeBallObjPalette)
	db $00 ; terminator

TransitionToGreatBall_PaletteData:
	db $08
	db $04 ; number of colors
	db $40
	dw GreatBallObjPalette
	db Bank(GreatBallObjPalette)
	db $00 ; terminator

TransitionToUltraBall_PaletteData:
	db $08
	db $04 ; number of colors
	db $40
	dw UltraBallObjPalette
	db Bank(UltraBallObjPalette)
	db $00 ; terminator

TransitionToMasterBall_PaletteData:
	db $08
	db $04 ; number of colors
	db $40
	dw MasterBallObjPalette
	db Bank(MasterBallObjPalette)
	db $00 ; terminator
