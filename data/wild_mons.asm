WildMonOffsetsPointers: ; 0x1126c
	dw RedStageWildMonDataOffsets
	dw RedStageWildMonDataOffsets
	dw RedStageWildMonDataOffsets
	dw RedStageWildMonDataOffsets
	dw BlueStageWildMonDataOffsets
	dw BlueStageWildMonDataOffsets

RedStageWildMonDataOffsets: ; 0x11278
	dw (RedStagePalletTownWildMons - RedStageWildMons)        ; PALLET_TOWN
	dw $0000                                                  ; VIRIDIAN_CITY (unused in Red Stage)
	dw (RedStageViridianForestWildMons - RedStageWildMons)    ; VIRIDIAN_FOREST
	dw (RedStagePewterCityWildMons - RedStageWildMons)        ; PEWTER_CITY
	dw $0000                                                  ; MT_MOON (unused in Red Stage)
	dw (RedStageCeruleanCityWildMons - RedStageWildMons)      ; CERULEAN_CITY
	dw (RedStageVermilionSeasideWildMons - RedStageWildMons)  ; VERMILION_SEASIDE
	dw $0000                                                  ; VERMILION_STREETS (unused in Red Stage)
	dw (RedStageRockMountainWildMons - RedStageWildMons)      ; ROCK_MOUNTAIN
	dw (RedStageLavenderTownWildMons - RedStageWildMons)      ; LAVENDER_TOWN
	dw $0000                                                  ; CELADON_CITY (unused in Red Stage)
	dw (RedStageCyclingRoadWildMons - RedStageWildMons)       ; CYCLING_ROAD
	dw $0000                                                  ; FUCHSIA_CITY (unused in Red Stage)
	dw (RedStageSafariZoneWildMons - RedStageWildMons)        ; SAFARI_ZONE
	dw $0000                                                  ; SAFFRON_CITY (unused in Red Stage)
	dw (RedStageSeafoamIslandsWildMons - RedStageWildMons)    ; SEAFOAM_ISLANDS
	dw (RedStageCinnabarIslandWildMons - RedStageWildMons)    ; CINNABAR_ISLAND
	dw (RedStageIndigoPlateauWildMons - RedStageWildMons)     ; INDIGO_PLATEAU

BlueStageWildMonDataOffsets: ; 0x1129c
	dw $0000                                                    ; PALLET_TOWN (unused in Blue Stage)
	dw (BlueStageViridianCityWildMons - BlueStageWildMons)      ; VIRIDIAN_CITY
	dw (BlueStageViridianForestWildMons - BlueStageWildMons)    ; VIRIDIAN_FOREST
	dw $0000                                                    ; PEWTER_CITY (unused in Blue Stage)
	dw (BlueStageMtMoonWildMons - BlueStageWildMons)            ; MT_MOON
	dw (BlueStageCeruleanCityWildMons - BlueStageWildMons)      ; CERULEAN_CITY
	dw $0000                                                    ; VERMILION_SEASIDE (unused in Blue Stage)
	dw (BlueStageVermilionStreetsWildMons - BlueStageWildMons)  ; VERMILION_STREETS
	dw (BlueStageRockMountainWildMons - BlueStageWildMons)      ; ROCK_MOUNTAIN
	dw $0000                                                    ; LAVENDER_TOWN (unused in Blue Stage)
	dw (BlueStageCeladonCityWildMons - BlueStageWildMons)       ; CELADON_CITY
	dw $0000                                                    ; CYCLING_ROAD (unused in Blue Stage)
	dw (BlueStageFuchsiaCityWildMons - BlueStageWildMons)       ; FUCHSIA_CITY
	dw (BlueStageSafariZoneWildMons - BlueStageWildMons)        ; SAFARI_ZONE
	dw (BlueStageSaffronCityWildMons - BlueStageWildMons)       ; SAFFRON_CITY
	dw $0000                                                    ; SEAFOAM_ISLANDS (unused in Blue Stage)
	dw (BlueStageCinnabarIslandWildMons - BlueStageWildMons)    ; CINNABAR_ISLAND
	dw (BlueStageIndigoPlateauWildMons - BlueStageWildMons)     ; INDIGO_PLATEAU

WildMonPointers: ; 0x112c0
	dw RedStageWildMons
	dw RedStageWildMons
	dw RedStageWildMons
	dw RedStageWildMons
	dw BlueStageWildMons
	dw BlueStageWildMons

INCLUDE "data/red_wild_mons.asm"
INCLUDE "data/blue_wild_mons.asm"
