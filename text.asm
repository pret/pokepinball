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

Data_2a21:
	dr $2a21, $2a56

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

Data_2bf0:
	dw Data_2c45
	dw Data_2c78
	dw Data_2c14
	dw Data_2c60
	dw Data_2c2c
	dw Data_2c90
	dw Data_2bfe

Data_2bfe:
	db $05, $54, $43, $14, $00, $37
	db "GET EXPERIENCE @"

Data_2c14:
	db $05, $54, $42, $14, $00, $39
	db "GET A FIRE STONE @"

Data_2c2c:
	db $05, $54, $41, $14, $00, $3a
	db "GET A WATER STONE @"

Data_2c45:
	db $05, $54, $40, $14, $00, $3c
	db "GET A THUNDER STONE @"

Data_2c60:
	db $05, $54, $42, $14, $00, $39
	db "GET A LEAF STONE @"

Data_2c78:
	db $05, $54, $42, $14, $00, $39
	db "GET A MOON STONE @"

Data_2c90:
	db $05, $54, $42, $14, $00, $39
	db "GET A LINK CABLE @"

Data_2ca8:
	db $05, $54, $42, $14, $00, $38
	db "MAP MOVE FAILED @"

Data_2cbf:
	db $05, $54, $00, $00, $00, $1f
	db "ARRIVED AT @"

Data_2cd1:
	db $05, $54, $00, $00, $00, $1f
	db "START FROM @"

Data_2ce3:
	dw Data_2d07
	dw Data_2d1a
	dw Data_2d2f
	dw Data_2d46
	dw Data_2d59
	dw Data_2d68
	dw Data_2d7d
	dw Data_2d98
	dw Data_2db3
	dw Data_2dc8
	dw Data_2ddd
	dw Data_2df1
	dw Data_2e05
	dw Data_2e18
	dw Data_2e2b
	dw Data_2e3f
	dw Data_2e56
	dw Data_2e6d

Data_2d07:
	db $05, $5f, $44, $14, $20, $3f
	db "PALLET TOWN @"

Data_2d1a:
	db $05, $5f, $43, $14, $20, $41
	db "VIRIDIAN CITY @"

Data_2d2f:
	db $05, $5f, $42, $14, $20, $43
	db "VIRIDIAN FOREST @"

Data_2d46:
	db $05, $5f, $44, $14, $20, $3f
	db "PEWTER CITY @"

Data_2d59:
	db $05, $5f, $46, $14, $20, $3b
	db "MT.MOON @"

Data_2d68:
	db $05, $5f, $43, $14, $20, $41
	db "CERULEAN CITY @"

Data_2d7d:
	db $05, $5f, $40, $14, $20, $47
	db "VERMILION : SEASIDE @"

Data_2d98:
	db $05, $5f, $40, $14, $20, $47
	db "VERMILION : STREETS @"

Data_2db3:
	db $05, $5f, $43, $14, $20, $41
	db "ROCK MOUNTAIN @"

Data_2dc8:
	db $05, $5f, $43, $14, $20, $41
	db "LAVENDER TOWN @"

Data_2ddd:
	db $05, $5f, $44, $14, $20, $40
	db "CELADON CITY @"

Data_2df1:
	db $05, $5f, $44, $14, $20, $40
	db "CYCLING ROAD @"

Data_2e05:
	db $05, $5f, $44, $14, $20, $3f
	db "FUCHIA CITY @"

Data_2e18:
	db $05, $5f, $44, $14, $20, $3f
	db "SAFARI ZONE @"

Data_2e2b:
	db $05, $5f, $44, $14, $20, $40
	db "SAFFRON CITY @"

Data_2e3f:
	db $05, $5f, $42, $14, $20, $43
	db "SEAFOAM ISLANDS @"

Data_2e56:
	db $05, $5f, $42, $14, $20, $43
	db "CINNABAR ISLAND @"

Data_2e6d:
	db $05, $5f, $43, $14, $20, $42
	db "INDIGO PLATEAU @"

Data_2e83:
	db $05, $54, $40, $14, $00, $3c
	db "GO TO DIGLETT STAGE @"

Data_2e9e:
	db $05, $54, $41, $14, $00, $3b
	db "GO TO GENGAR STAGE @"

Data_2eb8:
	db $05, $54, $41, $14, $00, $3b
	db "GO TO MEWTWO STAGE @"

Data_2ed2:
	db $05, $54, $41, $14, $00, $3b
	db "GO TO MEOWTH STAGE @"

Data_2eec:
	db $05, $54, $42, $14, $00, $39
	db "GO TO SEEL STAGE @"

Data_2f04:
	db $05, $54, $42, $14, $00, $39
	db "END GENGAR STAGE @"

Data_2f1c:
	db $05, $54, $42, $14, $00, $39
	db "END MEWTWO STAGE @"

Data_2f34:
	db $05, $54, $41, $14, $00, $3a
	db "END DIGLETT STAGE @"

Data_2f4d:
	db $05, $54, $42, $14, $00, $39
	db "END MEOWTH STAGE @"

Data_2f65:
	db $05, $54, $43, $14, $00, $37
	db "END SEEL STAGE @"

Data_2f7b:
	db $05, $54, $40, $14, $00, $3d
	db "GENGAR STAGE CLEARED @"

Data_2f97:
	db $05, $54, $40, $14, $00, $3d
	db "MEWTWO STAGE CLEARED @"

Data_2fb3:
	db $05, $54, $3f, $14, $00, $3e
	db "DIGLETT STAGE CLEARED @"

Data_2fd0:
	db $05, $54, $40, $14, $00, $3d
	db "MEOWTH STAGE CLEARED @"

Data_2fec:
	db $05, $54, $41, $14, $00, $3b
	db "SEEL STAGE CLEARED @"

Data_3006:
	db "  0 POKeMON CAUGHT@"

Data_3019:
	db "  0 POKeMON EVOLVED@"

BellsproutCounterText:
	db "  0 BELLSPROUT@"

DugtrioCounterText:
	db "  0 DUGTRIO@"

CaveShotCounterText:
	db "  0 CAVE SHOTS@"

SpinnerTurnsCounterText:
	db "  0 SPINNER TURNS@"

Data_3069:
	db " BONUS@"

Data_3070:
	db " SUBTOTAL@"

Data_307a:
	db " MULTIPLIER@"

Data_3086:
	db " TOTAL@"

Data_308d:
	db " SCORE@"

Data_3094:
	db "     GAME  OVER     @"

PsyduckCounterText:
	db "  0 PSYDUCK@"

PoliwagCounterText:
	db "  0 POLIWAG@"

CloysterCounterText:
	db "  0 CLOYSTER@"

SlowpokeCounterText:
	db "  0 SLOWPOKE@"
