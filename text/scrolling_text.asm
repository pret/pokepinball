; 6-byte header for scrolling text in the bottom message box. See LoadScrollingText, and wScrollingText1 for documentation.

BallSavedText:
	db $05, $54, $45, $14, $00, $33
	db "BALL SAVED @"

ShootAgainText:
	db $05, $54, $44, $14, $00, $34
	db "SHOOT AGAIN @"

EndOfBallBonusText:
	db $05, $54, $41, $14, $00, $3a
	db "END OF BALL BONUS @"

FieldMultiplierText:
	db $05, $54, $40, $14, $00, $3c
	db "FIELD MULTIPLIER x0 @"

FieldMultiplierSpecialBonusText:
	db $07, $54, $00, $00, $00, $33
	db "FIELD MULTIPLIER SPECIAL BONUS @"

DigitsText1to8:
	db $07, $73, $46, $14, $20, $50
	db "12345678 @"

BonusMultiplierText:
	db $05, $54, $40, $14, $00, $3d
	db "BONUS MULTIPLIER x0  @"

ExtraBallText:
	db $05, $54, $45, $14, $00, $33
	db "EXTRA BALL @"

ExtraBallSpecialBonusText:
	db $07, $54, $00, $00, $00, $2d
	db "EXTRA BALL SPECIAL BONUS @"

DigitsText1to9:
	db $07, $6d, $45, $14, $20, $4b
	db "123456789 @"

LetsGetPokemonText:
	db $05, $54, $41, $14, $00, $3a
	db "LET`S GET POKeMON @"

PokemonRanAwayText:
	db $05, $54, $42, $14, $00, $39
	db "POKeMON RAN AWAY @"

PokemonCaughtSpecialBonusText:
	db $07, $54, $00, $00, $00, $31
	db "POKeMON CAUGHT SPECIAL BONUS @"

OneBillionText:
	db $07, $6e, $45, $14, $20, $50
	db "1,000,000,000 @"

HitText:
	db $44, $00, $40, $00
	db "HIT @"

Data_2a2a:
	db $48, $10, $40, $00, $00, $00

FlippedText:
	db $42, $00, $40, $00
	db "FLIPPED @"

Data_2a3d:
	db $4a, $10, $40, $00, $00, $00

JackpotText:
	db $42, $00, $b4, $00
	db "JACKPOT @"

Data_2a50:
	db $4a, $10, $b4, $00, $00, $00

YouGotAText:
	db $05, $54, $00, $00, $00, $1e
	db "YOU GOT A @"

YouGotAnText:
	db $05, $54, $00, $00, $00, $1f
	db "YOU GOT AN @"

Data_2a79:
	db $05, $5e, $40, $14, $20, $43
	db "                 @"

Data_2a91:
	db $05, $5f, $40, $14, $20, $44
	db "                 @"

StartTrainingText:
	db $05, $54, $43, $14, $00, $37
	db "START TRAINING @"

FindItemsText:
	db $05, $54, $45, $14, $00, $33
	db "FIND ITEMS @"

EvolutionFailedText:
	db $05, $54, $42, $14, $00, $39
	db "EVOLUTION FAILED @"

ItEvolvedIntoAText:
	db $05, $54, $00, $00, $00, $26
	db "IT EVOLVED INTO A @"

ItEvolvedIntoAnText:
	db $05, $54, $00, $00, $00, $27
	db "IT EVOLVED INTO AN @"

Data_2b1c:
	db $05, $66, $40, $14, $20, $4b
	db "                 @"

Data_2b34:
	db $05, $67, $40, $14, $20, $4c
	db "                 @"

EvolutionSpecialBonusText:
	db $07, $54, $00, $00, $00, $2c
	db "EVOLUTION SPECIAL BONUS @"

Data_2b6b:
	db $07, $6c, $46, $14, $20, $49
	db "12345678 @"

PokemonIsTiredText:
	db $05, $54, $42, $14, $00, $39
	db "POKeMON IS TIRED @"

ItemNotFoundText:
	db $05, $54, $43, $14, $00, $37
	db "ITEM NOT FOUND @"

PokemonRecoveredText:
	db $05, $54, $41, $14, $00, $3a
	db "POKeMON RECOVERED @"

TryNextPlaceText:
	db $05, $54, $43, $14, $00, $37
	db "TRY NEXT PLACE @"

YeahYouGotItText:
	db $05, $54, $42, $14, $00, $39
	db "YEAH! YOU GOT IT @"

EvolutionTypeGetTextPointers:
	dw GetThunderStoneText
	dw GetMoonStoneText
	dw GetFireStoneText
	dw GetLeafStoneText
	dw GetWaterStoneText
	dw GetLinkCableText
	dw GetExperienceText

GetExperienceText:
	db $05, $54, $43, $14, $00, $37
	db "GET EXPERIENCE @"

GetFireStoneText:
	db $05, $54, $42, $14, $00, $39
	db "GET A FIRE STONE @"

GetWaterStoneText:
	db $05, $54, $41, $14, $00, $3a
	db "GET A WATER STONE @"

GetThunderStoneText:
	db $05, $54, $40, $14, $00, $3c
	db "GET A THUNDER STONE @"

GetLeafStoneText:
	db $05, $54, $42, $14, $00, $39
	db "GET A LEAF STONE @"

GetMoonStoneText:
	db $05, $54, $42, $14, $00, $39
	db "GET A MOON STONE @"

GetLinkCableText:
	db $05, $54, $42, $14, $00, $39
	db "GET A LINK CABLE @"

MapMoveFailedText:
	db $05, $54, $42, $14, $00, $38
	db "MAP MOVE FAILED @"

ArrivedAtMapText:
	db $05, $54, $00, $00, $00, $1f
	db "ARRIVED AT @"

StartFromMapText:
	db $05, $54, $00, $00, $00, $1f
	db "START FROM @"

MapNames:
	dw PalletTownText
	dw ViridianCityText
	dw ViridianForestText
	dw PewterCityText
	dw MtMoonText
	dw CeruleanCityText
	dw VermilionSeasideText
	dw VermilionStreetsText
	dw RockMountainText
	dw LavenderTownText
	dw CeladonCityText
	dw CyclingRoadText
	dw FuchiaCityText ; mispelling -- should be fuchsia
	dw SafariZoneText
	dw SaffronCityText
	dw SeafoamIslandsText
	dw CinnabarIslandText
	dw IndigoPlateauText

PalletTownText:
	db $05, $5f, $44, $14, $20, $3f
	db "PALLET TOWN @"

ViridianCityText:
	db $05, $5f, $43, $14, $20, $41
	db "VIRIDIAN CITY @"

ViridianForestText:
	db $05, $5f, $42, $14, $20, $43
	db "VIRIDIAN FOREST @"

PewterCityText:
	db $05, $5f, $44, $14, $20, $3f
	db "PEWTER CITY @"

MtMoonText:
	db $05, $5f, $46, $14, $20, $3b
	db "MT.MOON @"

CeruleanCityText:
	db $05, $5f, $43, $14, $20, $41
	db "CERULEAN CITY @"

VermilionSeasideText:
	db $05, $5f, $40, $14, $20, $47
	db "VERMILION : SEASIDE @"

VermilionStreetsText:
	db $05, $5f, $40, $14, $20, $47
	db "VERMILION : STREETS @"

RockMountainText:
	db $05, $5f, $43, $14, $20, $41
	db "ROCK MOUNTAIN @"

LavenderTownText:
	db $05, $5f, $43, $14, $20, $41
	db "LAVENDER TOWN @"

CeladonCityText:
	db $05, $5f, $44, $14, $20, $40
	db "CELADON CITY @"

CyclingRoadText:
	db $05, $5f, $44, $14, $20, $40
	db "CYCLING ROAD @"

FuchiaCityText:
	db $05, $5f, $44, $14, $20, $3f
	db "FUCHIA CITY @" ; mispelling -- should be fuchsia

SafariZoneText:
	db $05, $5f, $44, $14, $20, $3f
	db "SAFARI ZONE @"

SaffronCityText:
	db $05, $5f, $44, $14, $20, $40
	db "SAFFRON CITY @"

SeafoamIslandsText:
	db $05, $5f, $42, $14, $20, $43
	db "SEAFOAM ISLANDS @"

CinnabarIslandText:
	db $05, $5f, $42, $14, $20, $43
	db "CINNABAR ISLAND @"

IndigoPlateauText:
	db $05, $5f, $43, $14, $20, $42
	db "INDIGO PLATEAU @"

GoToDiglettStageText:
	db $05, $54, $40, $14, $00, $3c
	db "GO TO DIGLETT STAGE @"

GoToGengarStageText:
	db $05, $54, $41, $14, $00, $3b
	db "GO TO GENGAR STAGE @"

GoToMewtwoStageText:
	db $05, $54, $41, $14, $00, $3b
	db "GO TO MEWTWO STAGE @"

GoToMeowthStageText:
	db $05, $54, $41, $14, $00, $3b
	db "GO TO MEOWTH STAGE @"

GoToSeelStageText:
	db $05, $54, $42, $14, $00, $39
	db "GO TO SEEL STAGE @"

EndGengarStageText:
	db $05, $54, $42, $14, $00, $39
	db "END GENGAR STAGE @"

EndMewtwoStageText:
	db $05, $54, $42, $14, $00, $39
	db "END MEWTWO STAGE @"

EndDiglettStageText:
	db $05, $54, $41, $14, $00, $3a
	db "END DIGLETT STAGE @"

EndMeowthStageText:
	db $05, $54, $42, $14, $00, $39
	db "END MEOWTH STAGE @"

EndSeelStageText:
	db $05, $54, $43, $14, $00, $37
	db "END SEEL STAGE @"

GengarStageClearedText:
	db $05, $54, $40, $14, $00, $3d
	db "GENGAR STAGE CLEARED @"

MewtwoStageClearedText:
	db $05, $54, $40, $14, $00, $3d
	db "MEWTWO STAGE CLEARED @"

DiglettStageClearedText:
	db $05, $54, $3f, $14, $00, $3e
	db "DIGLETT STAGE CLEARED @"

MeowthStageClearedText:
	db $05, $54, $40, $14, $00, $3d
	db "MEOWTH STAGE CLEARED @"

SeelStageClearedText:
	db $05, $54, $41, $14, $00, $3b
	db "SEEL STAGE CLEARED @"

NumPokemonCaughtText:
	db "  0 POKeMON CAUGHT@"

NumPokemonEvolvedText:
	db "  0 POKeMON EVOLVED@"

BellsproutCounterText:
	db "  0 BELLSPROUT@"

DugtrioCounterText:
	db "  0 DUGTRIO@"

CaveShotCounterText:
	db "  0 CAVE SHOTS@"

SpinnerTurnsCounterText:
	db "  0 SPINNER TURNS@"

BonusPointsText:
	db " BONUS@"

SubtotalPointsText:
	db " SUBTOTAL@"

MultiplierPointsText:
	db " MULTIPLIER@"

TotalPointsText:
	db " TOTAL@"

ScoreText:
	db " SCORE@"

GameOverText:
	db "     GAME  OVER     @"

PsyduckCounterText:
	db "  0 PSYDUCK@"

PoliwagCounterText:
	db "  0 POLIWAG@"

CloysterCounterText:
	db "  0 CLOYSTER@"

SlowpokeCounterText:
	db "  0 SLOWPOKE@"
