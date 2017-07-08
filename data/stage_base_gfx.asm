StageGfxPointers_GameBoy: ; 0xe6f7
	dw StageRedFieldTopGfx_GameBoy
	dw StageRedFieldBottomGfx_GameBoy
	dw VideoData_e896
	dw VideoData_e8bd
	dw StageBlueFieldTopGfx_GameBoy
	dw StageBlueFieldBottomGfx_GameBoy
	dw StageGengarBonusGfx_GameBoy
	dw StageGengarBonusGfx_GameBoy
	dw StageMewtwoBonusGfx_GameBoy
	dw StageMewtwoBonusGfx_GameBoy
	dw StageMeowthBonusGfx_GameBoy
	dw StageMeowthBonusGfx_GameBoy
	dw StageDiglettBonusGfx_GameBoy
	dw StageDiglettBonusGfx_GameBoy
	dw StageSeelBonusGfx_GameBoy
	dw StageSeelBonusGfx_GameBoy

StageGfxPointers_GameBoyColor: ; 0xe717
	dw StageRedFieldTopGfx_GameBoyColor
	dw StageRedFieldBottomGfx_GameBoyColor
	dw VideoData_e8a6
	dw VideoData_e8d4
	dw StageBlueFieldTopGfx_GameBoyColor
	dw StageBlueFieldBottomGfx_GameBoyColor
	dw StageGengarBonusGfx_GameBoyColor
	dw StageGengarBonusGfx_GameBoyColor
	dw StageMewtwoBonusGfx_GameBoyColor
	dw StageMewtwoBonusGfx_GameBoyColor
	dw StageMeowthBonusGfx_GameBoyColor
	dw StageMeowthBonusGfx_GameBoyColor
	dw StageDiglettBonusGfx_GameBoyColor
	dw StageDiglettBonusGfx_GameBoyColor
	dw StageSeelBonusGfx_GameBoyColor
	dw StageSeelBonusGfx_GameBoyColor

StageRedFieldTopGfx_GameBoy: ; 0xe737
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   StageRedFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES   StageRedFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES   StageRedFieldTopStatusBarSymbolsGfx_GameBoy, vTilesSH, $100
	VIDEO_DATA_TILES   StageRedFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   StageRedFieldTopBaseGameBoyGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILEMAP StageRedFieldTopTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageRedFieldTopGfx_GameBoyColor: ; 0xe771
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageRedFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES         StageRedFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES         StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor, vTilesSH, $100
	VIDEO_DATA_TILES         StageRedFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         StageRedFieldTopBaseGameBoyColorGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx4, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx5, vTilesOB, $200
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx, vTilesOB + $200, $400
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx2, vTilesSH + $100, $200
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopStatusBarSymbolsGfx_GameBoyColor, vTilesSH, $100
	VIDEO_DATA_TILEMAP       StageRedFieldTopTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageRedFieldTopTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageRedFieldTopPalettes, $80
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx6, vTilesOB + $7c0, $40
	db $FF, $FF  ; terminators

StageRedFieldBottomGfx_GameBoy: ; 0xe7ea
	VIDEO_DATA_TILES    Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES    StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES    StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES    StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES    StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES    StageRedFieldBottomBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES    SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILEMAP  StageRedFieldBottomTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageRedFieldBottomGfx_GameBoyColor: ; 0xe824
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES         StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES         StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         StageRedFieldBottomBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   StageRedFieldBottomGfx5, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES         SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx, vTilesOB + $200, $400
	VIDEO_DATA_TILES_BANK2   StageRedJapaneseCharactersGfx2, vTilesSH + $100, $200
	VIDEO_DATA_TILES_BANK2   StageRedFieldBottomBaseGameBoyColorGfx, vTilesSH, $100
	VIDEO_DATA_TILEMAP       StageRedFieldBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageRedFieldBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageRedFieldBottomPalettes, $80
	VIDEO_DATA_TILES_BANK2   StageRedFieldTopGfx6, vTilesOB + $7c0, $40
	db $FF, $FF  ; terminators

VideoData_e896: ; 0xe896
	VIDEO_DATA_TILES Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES PinballPokeballGfx, vTilesOB + $400, $200
	db $FF, $FF  ; terminators

VideoData_e8a6: ; 0xe8a6
	VIDEO_DATA_TILES       Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES       PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES_BANK2 TimerDigitsGfx, vTilesOB + $600, $160
	db $FF, $FF  ; terminators

VideoData_e8bd: ; 0xe8bd
	VIDEO_DATA_TILES Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES PinballPokeballShakeGfx, vTilesOB + $380, $480
	VIDEO_DATA_TILES SaverTextOffGfx, vTilesSH + $2a0, $40
	db $FF, $FF  ; terminators

VideoData_e8d4: ; 0xe8d4
	VIDEO_DATA_TILES       Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES       PinballPokeballShakeGfx, vTilesOB + $380, $480
	VIDEO_DATA_TILES_BANK2 TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES       SaverTextOffGfx, vTilesSH + $2a0, $40
	db $FF, $FF  ; terminators

StageBlueFieldTopGfx_GameBoy: ; 0xe8f2
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   StageBlueFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES   StageBlueFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES   StageBlueFieldTopStatusBarSymbolsGfx_GameBoy, vTilesSH, $100
	VIDEO_DATA_TILES   StageBlueFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   StageBlueFieldTopBaseGameBoyGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILEMAP StageBlueFieldTopTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageBlueFieldTopGfx_GameBoyColor: ; 0xe92c
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageBlueFieldTopGfx1, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $200
	VIDEO_DATA_TILES         StageBlueFieldTopGfx2, vTilesOB + $600, $200
	VIDEO_DATA_TILES         StageBlueFieldTopStatusBarSymbolsGfx_GameBoyColor, vTilesSH, $100
	VIDEO_DATA_TILES         StageBlueFieldTopGfx3, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         StageBlueFieldTopBaseGameBoyColorGfx, vTilesSH + $2a0, $d60
	VIDEO_DATA_TILES_BANK2   StageBlueFieldTopGfx4, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       StageBlueFieldTopTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageBlueFieldTopTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageBlueFieldTopPalettes, $80
	db $FF, $FF  ; terminators

StageBlueFieldBottomGfx_GameBoy: ; 0xe982
	VIDEO_DATA_TILES    Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES    StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES    StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES    StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES    StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES    StageBlueFieldBottomBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES    SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILEMAP  StageBlueFieldBottomTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageBlueFieldBottomGfx_GameBoyColor: ; 0xe9bc
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedBonusSlotGlowGfx, vTilesOB + $1a0, $160
	VIDEO_DATA_TILES         StageSharedArrowsGfx, vTilesOB + $300, $80
	VIDEO_DATA_TILES         StageSharedBonusSlotGlow2Gfx, vTilesOB + $380, $20
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         StageBlueFieldBottomBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   StageBlueFieldBottomGfx1, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILES         SaverTextOffGfx, vTilesSH + $2a0, $40
	VIDEO_DATA_TILEMAP       StageBlueFieldBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 StageBlueFieldBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      StageBlueFieldBottomPalettes, $80
	db $FF, $FF  ; terminators

StageGengarBonusGfx_GameBoy: ; 0xea12
	VIDEO_DATA_TILES       Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES       PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES       GengarBonusBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES       GengarBonusGastlyGfx, vTilesSH + $100, $180
	VIDEO_DATA_TILES_BANK  GengarBonusHaunterGfx + $180, Bank(GengarBonusHaunterGfx), vTilesSH + $280, $20
	VIDEO_DATA_TILES_BANK  GengarBonusHaunterGfx + $1a0, Bank(GengarBonusHaunterGfx), vTilesOB + $1a0, $100
	VIDEO_DATA_TILES_BANK  GengarBonusGengarGfx  + $2a0, Bank(GengarBonusGengarGfx),  vTilesOB + $2a0, $160
	VIDEO_DATA_TILES_BANK  GengarBonusGengarGfx  + $400, Bank(GengarBonusGengarGfx),  vTilesOB + $7a0, $60
	VIDEO_DATA_TILES_BANK  GengarBonusGengarGfx  + $460, Bank(GengarBonusGengarGfx),  vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILEMAP     GengarBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageGengarBonusGfx_GameBoyColor: ; 0xea5a
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         StageSharedPikaBoltGfx, vTilesOB + $3c0, $440
	VIDEO_DATA_TILES         GengarBonusBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES         GengarBonusGastlyGfx, vTilesSH + $100, $180
	VIDEO_DATA_TILES_BANK    GengarBonusHaunterGfx + $180, Bank(GengarBonusHaunterGfx), vTilesSH + $280, $20
	VIDEO_DATA_TILES_BANK    GengarBonusHaunterGfx + $1a0, Bank(GengarBonusHaunterGfx), vTilesOB + $1a0, $100
	VIDEO_DATA_TILES_BANK    GengarBonusGengarGfx  + $2a0, Bank(GengarBonusGengarGfx),  vTilesOB + $2a0, $160
	VIDEO_DATA_TILES_BANK    GengarBonusGengarGfx  + $400, Bank(GengarBonusGengarGfx),  vTilesOB + $7a0, $60
	VIDEO_DATA_TILES_BANK    GengarBonusGengarGfx  + $460, Bank(GengarBonusGengarGfx),  vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILES_BANK2   GengarBonus1Gfx, vTilesSH, $1000
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       GengarBonusBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 GengarBonusBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      GengarBonusPalettes, $80
	db $FF, $FF  ; terminators

StageMewtwoBonusGfx_GameBoy: ; 0xeabe
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   MewtwoBonus1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   MewtwoBonus2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   MewtwoBonusBaseGameBoyGfx, vTilesSH, $1000
	VIDEO_DATA_TILES   MewtwoBonus3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   MewtwoBonus4Gfx, vTilesSH + $2a0, $2a0
	VIDEO_DATA_TILEMAP MewtwoBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageMewtwoBonusGfx_GameBoyColor: ; 0xeaf8
	VIDEO_DATA_TILES   Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   MewtwoBonus1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   MewtwoBonus2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   MewtwoBonusBaseGameBoyColorGfx, vTilesSH, $1000
	VIDEO_DATA_TILES   MewtwoBonus3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   MewtwoBonus4Gfx, vTilesSH + $2a0, $2a0
	; Can't use a macro here because it's copying the tiles from VRAM, not ROM.
	dw vTilesOB
	db $20  ; This is an arbitrary bank, since the data is in VRAM, not ROM.
	dw vTilesSH
	dw $4002
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       MewtoBonusBottomTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 MewtoBonusBottomTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      MewtwoBonusPalettes, $80
	db $FF, $FF  ; terminators

StageMeowthBonusGfx_GameBoy: ; 0xeb4e
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   MeowthBonusMeowth1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   MeowthBonusMeowth2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   MeowthBonusBaseGameBoyGfx, vTilesSH, $a00
	VIDEO_DATA_TILES   MeowthBonusMeowth3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   MeowthBonusMeowth4Gfx, vTilesSH + $2a0, $360
	VIDEO_DATA_TILEMAP MeowthBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageMeowthBonusGfx_GameBoyColor: ; 0xeb88
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         MeowthBonusMeowth1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES         MeowthBonusMeowth2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         MeowthBonusBaseGameBoyColorGfx, vTilesSH, $900
	VIDEO_DATA_TILES         MeowthBonusMeowth3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         MeowthBonusMeowth4Gfx, vTilesSH + $2a0, $360
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       MeowthBonusTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 MeowthBonusTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      MeowthBonusPalettes, $80
	db $FF, $FF  ; terminators

StageDiglettBonusGfx_GameBoy: ; 0xebd7
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   DiglettBonusDugtrio1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   DiglettBonusDugtrio2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   DiglettBonusBaseGameBoyGfx, vTilesSH, $e00  ; $e00 is actually $100 too many bytes. Should only be $d00. This accidentally loads palette data after the tile graphics.
	VIDEO_DATA_TILES   DiglettBonusDugtrio3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   DiglettBonusDugtrio4Gfx, vTilesSH + $2a0, $280
	VIDEO_DATA_TILEMAP DiglettBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageDiglettBonusGfx_GameBoyColor: ; 0xec11
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         DiglettBonusDugtrio1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES         DiglettBonusDugtrio2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         DiglettBonusBaseGameBoyColorGfx, vTilesSH, $e00
	VIDEO_DATA_TILES         DiglettBonusDugtrio3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         DiglettBonusDugtrio4Gfx, vTilesSH + $2a0, $280
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       DiglettBonusTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 DiglettBonusTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      DiglettBonusPalettes, $80
	db $FF, $FF  ; terminators

StageSeelBonusGfx_GameBoy: ; 0xec60
	VIDEO_DATA_TILES   Alphabet1Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES   SeelBonusSeel1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES   PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES   SeelBonusSeel2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES   SeelBonusBaseGameBoyGfx, vTilesSH, $d00  ; $d00 is actually $100 too many bytes. Should only be $c00. This accidentally loads palette data after the tile graphics.
	VIDEO_DATA_TILES   SeelBonusSeel3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES   SeelBonusSeel4Gfx, vTilesSH + $2a0, $4a0
	VIDEO_DATA_TILEMAP SeelBonusTilemap_GameBoy, vBGMap, $400
	db $FF, $FF  ; terminators

StageSeelBonusGfx_GameBoyColor: ; 0xec9a
	VIDEO_DATA_TILES         Alphabet2Gfx, vTilesOB, $1a0
	VIDEO_DATA_TILES         SeelBonusSeel1Gfx, vTilesOB + $1a0, $260
	VIDEO_DATA_TILES         PinballPokeballGfx, vTilesOB + $400, $320
	VIDEO_DATA_TILES         SeelBonusSeel2Gfx, vTilesOB + $7a0, $60
	VIDEO_DATA_TILES         SeelBonusBaseGameBoyColorGfx, vTilesSH, $b00  ; Should actually be $a00 bytes, not $b00
	VIDEO_DATA_TILES         SeelBonusSeel3Gfx, vTilesSH + $100, $1a0
	VIDEO_DATA_TILES         SeelBonusSeel4Gfx, vTilesSH + $2a0, $4a0
	VIDEO_DATA_TILES_BANK2   TimerDigitsGfx, vTilesOB + $600, $160
	VIDEO_DATA_TILEMAP       SeelBonusTilemap_GameBoyColor, vBGMap, $400
	VIDEO_DATA_TILEMAP_BANK2 SeelBonusTilemap2_GameBoyColor, vBGMap, $400
	VIDEO_DATA_PALETTES      SeelBonusPalettes, $80
	db $FF, $FF  ; terminators
