; TODO: move out the the graphics data and label it all.

LoadMapBillboardTileData: ; 0x30253
	ld a, [wCurrentMap]
	; fall through
LoadBillboardTileData: ; 0x30256
	sla a
	ld c, a
	ld b, $0
	push bc
	ld hl, BillboardTileDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BillboardTileDataPointers)
	call QueueGraphicsToLoad
	pop bc
	ld a, [hGameBoyColorFlag]
	and a
	ret z
	ld hl, BillboardPaletteDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, Bank(BillboardPaletteDataPointers)
	call QueueGraphicsToLoad
	ret

BillboardTileDataPointers: ; 0x3027a
	dw PalletTownBillboardTileDataList
	dw TileData_302c1
	dw TileData_302d2
	dw TileData_302e3
	dw TileData_302f4
	dw TileData_30305
	dw TileData_30316
	dw TileData_30327
	dw TileData_30338
	dw TileData_30349
	dw TileData_3035a
	dw TileData_3036b
	dw TileData_3037c
	dw TileData_3038d
	dw TileData_3039e
	dw TileData_303af
	dw TileData_303c0
	dw TileData_303d1
	dw TileData_303e2
	dw TileData_303f3
	dw TileData_30404
	dw TileData_30415
	dw TileData_30426
	dw TileData_30437
	dw TileData_30448
	dw TileData_30459
	dw TileData_3046a

PalletTownBillboardTileDataList: ; 0x302b0
	db $08
	dw PalletTownBillboardTileData1
	dw PalletTownBillboardTileData2
	dw PalletTownBillboardTileData3
	dw PalletTownBillboardTileData4
	dw PalletTownBillboardTileData5
	dw PalletTownBillboardTileData6
	dw PalletTownBillboardTileData7
	dw PalletTownBillboardTileData8

TileData_302c1: ; 0x302c1
	db $08
	dw TileData_304cb
	dw TileData_304d5
	dw TileData_304df
	dw TileData_304e9
	dw TileData_304f3
	dw TileData_304fd
	dw TileData_30507
	dw TileData_30511

TileData_302d2: ; 0x302d2
	db $08
	dw TileData_3051b
	dw TileData_30525
	dw TileData_3052f
	dw TileData_30539
	dw TileData_30543
	dw TileData_3054d
	dw TileData_30557
	dw TileData_30561

TileData_302e3: ; 0x302e3
	db $08
	dw TileData_3056b
	dw TileData_30575
	dw TileData_3057f
	dw TileData_30589
	dw TileData_30593
	dw TileData_3059d
	dw TileData_305a7
	dw TileData_305b1

TileData_302f4: ; 0x302f4
	db $08
	dw TileData_305bb
	dw TileData_305c5
	dw TileData_305cf
	dw TileData_305d9
	dw TileData_305e3
	dw TileData_305ed
	dw TileData_305f7
	dw TileData_30601

TileData_30305: ; 0x30305
	db $08
	dw TileData_3060b
	dw TileData_30615
	dw TileData_3061f
	dw TileData_30629
	dw TileData_30633
	dw TileData_3063d
	dw TileData_30647
	dw TileData_30651

TileData_30316: ; 0x30316
	db $08
	dw TileData_3065b
	dw TileData_30665
	dw TileData_3066f
	dw TileData_30679
	dw TileData_30683
	dw TileData_3068d
	dw TileData_30697
	dw TileData_306a1

TileData_30327: ; 0x30327
	db $08
	dw TileData_306ab
	dw TileData_306b5
	dw TileData_306bf
	dw TileData_306c9
	dw TileData_306d3
	dw TileData_306dd
	dw TileData_306e7
	dw TileData_306f1

TileData_30338: ; 0x30338
	db $08
	dw TileData_306fb
	dw TileData_30705
	dw TileData_3070f
	dw TileData_30719
	dw TileData_30723
	dw TileData_3072d
	dw TileData_30737
	dw TileData_30741

TileData_30349: ; 0x30349
	db $08
	dw TileData_3074b
	dw TileData_30755
	dw TileData_3075f
	dw TileData_30769
	dw TileData_30773
	dw TileData_3077d
	dw TileData_30787
	dw TileData_30791

TileData_3035a: ; 0x3035a
	db $08
	dw TileData_3079b
	dw TileData_307a5
	dw TileData_307af
	dw TileData_307b9
	dw TileData_307c3
	dw TileData_307cd
	dw TileData_307d7
	dw TileData_307e1

TileData_3036b: ; 0x3036b
	db $08
	dw TileData_307eb
	dw TileData_307f5
	dw TileData_307ff
	dw TileData_30809
	dw TileData_30813
	dw TileData_3081d
	dw TileData_30827
	dw TileData_30831

TileData_3037c: ; 0x3037c
	db $08
	dw TileData_3083b
	dw TileData_30845
	dw TileData_3084f
	dw TileData_30859
	dw TileData_30863
	dw TileData_3086d
	dw TileData_30877
	dw TileData_30881

TileData_3038d: ; 0x3038d
	db $08
	dw TileData_3088b
	dw TileData_30895
	dw TileData_3089f
	dw TileData_308a9
	dw TileData_308b3
	dw TileData_308bd
	dw TileData_308c7
	dw TileData_308d1

TileData_3039e: ; 0x3039e
	db $08
	dw TileData_308db
	dw TileData_308e5
	dw TileData_308ef
	dw TileData_308f9
	dw TileData_30903
	dw TileData_3090d
	dw TileData_30917
	dw TileData_30921

TileData_303af: ; 0x303af
	db $08
	dw TileData_3092b
	dw TileData_30935
	dw TileData_3093f
	dw TileData_30949
	dw TileData_30953
	dw TileData_3095d
	dw TileData_30967
	dw TileData_30971

TileData_303c0: ; 0x303c0
	db $08
	dw TileData_3097b
	dw TileData_30985
	dw TileData_3098f
	dw TileData_30999
	dw TileData_309a3
	dw TileData_309ad
	dw TileData_309b7
	dw TileData_309c1

TileData_303d1: ; 0x303d1
	db $08
	dw TileData_309cb
	dw TileData_309d5
	dw TileData_309df
	dw TileData_309e9
	dw TileData_309f3
	dw TileData_309fd
	dw TileData_30a07
	dw TileData_30a11

TileData_303e2: ; 0x303e2
	db $08
	dw TileData_30a1b
	dw TileData_30a25
	dw TileData_30a2f
	dw TileData_30a39
	dw TileData_30a43
	dw TileData_30a4d
	dw TileData_30a57
	dw TileData_30a61

TileData_303f3: ; 0x303f3
	db $08
	dw TileData_30a6b
	dw TileData_30a75
	dw TileData_30a7f
	dw TileData_30a89
	dw TileData_30a93
	dw TileData_30a9d
	dw TileData_30aa7
	dw TileData_30ab1

TileData_30404: ; 0x30404
	db $08
	dw TileData_30abb
	dw TileData_30ac5
	dw TileData_30acf
	dw TileData_30ad9
	dw TileData_30ae3
	dw TileData_30aed
	dw TileData_30af7
	dw TileData_30b01

TileData_30415: ; 0x30415
	db $08
	dw TileData_30b0b
	dw TileData_30b15
	dw TileData_30b1f
	dw TileData_30b29
	dw TileData_30b33
	dw TileData_30b3d
	dw TileData_30b47
	dw TileData_30b51

TileData_30426: ; 0x30426
	db $08
	dw TileData_30b5b
	dw TileData_30b65
	dw TileData_30b6f
	dw TileData_30b79
	dw TileData_30b83
	dw TileData_30b8d
	dw TileData_30b97
	dw TileData_30ba1

TileData_30437: ; 0x30437
	db $08
	dw TileData_30bab
	dw TileData_30bb5
	dw TileData_30bbf
	dw TileData_30bc9
	dw TileData_30bd3
	dw TileData_30bdd
	dw TileData_30be7
	dw TileData_30bf1

TileData_30448: ; 0x30448
	db $08
	dw TileData_30bfb
	dw TileData_30c05
	dw TileData_30c0f
	dw TileData_30c19
	dw TileData_30c23
	dw TileData_30c2d
	dw TileData_30c37
	dw TileData_30c41

TileData_30459: ; 0x30459
	db $08
	dw TileData_30c4b
	dw TileData_30c55
	dw TileData_30c5f
	dw TileData_30c69
	dw TileData_30c73
	dw TileData_30c7d
	dw TileData_30c87
	dw TileData_30c91

TileData_3046a: ; 0x3046a
	db $08
	dw TileData_30c9b
	dw TileData_30ca5
	dw TileData_30caf
	dw TileData_30cb9
	dw TileData_30cc3
	dw TileData_30ccd
	dw TileData_30cd7
	dw TileData_30ce1

PalletTownBillboardTileData1: ; 0x3047b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw PalletTownPic
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData2: ; 0x30485
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw PalletTownPic + $30
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData3: ; 0x3048f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw PalletTownPic + $60
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData4: ; 0x30499
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw PalletTownPic + $90
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData5: ; 0x304a3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw PalletTownPic + $C0
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData6: ; 0x304ad
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw PalletTownPic + $F0
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData7: ; 0x304b7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw PalletTownPic + $120
	db Bank(PalletTownPic)
	db $00

PalletTownBillboardTileData8: ; 0x304c1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw PalletTownPic + $150
	db Bank(PalletTownPic)
	db $00

TileData_304cb: ; 0x304cb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw ViridianCityPic
	db Bank(ViridianCityPic)
	db $00

TileData_304d5: ; 0x304d5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw ViridianCityPic + $30
	db Bank(ViridianCityPic)
	db $00

TileData_304df: ; 0x304df
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw ViridianCityPic + $60
	db Bank(ViridianCityPic)
	db $00

TileData_304e9: ; 0x304e9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw ViridianCityPic + $90
	db Bank(ViridianCityPic)
	db $00

TileData_304f3: ; 0x304f3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw ViridianCityPic + $C0
	db Bank(ViridianCityPic)
	db $00

TileData_304fd: ; 0x304fd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw ViridianCityPic + $F0
	db Bank(ViridianCityPic)
	db $00

TileData_30507: ; 0x30507
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw ViridianCityPic + $120
	db Bank(ViridianCityPic)
	db $00

TileData_30511: ; 0x30511
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw ViridianCityPic + $150
	db Bank(ViridianCityPic)
	db $00

TileData_3051b: ; 0x3051b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw ViridianForestPic
	db Bank(ViridianForestPic)
	db $00

TileData_30525: ; 0x30525
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw ViridianForestPic + $30
	db Bank(ViridianForestPic)
	db $00

TileData_3052f: ; 0x3052f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw ViridianForestPic + $60
	db Bank(ViridianForestPic)
	db $00

TileData_30539: ; 0x30539
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw ViridianForestPic + $90
	db Bank(ViridianForestPic)
	db $00

TileData_30543: ; 0x30543
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw ViridianForestPic + $C0
	db Bank(ViridianForestPic)
	db $00

TileData_3054d: ; 0x3054d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw ViridianForestPic + $F0
	db Bank(ViridianForestPic)
	db $00

TileData_30557: ; 0x30557
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw ViridianForestPic + $120
	db Bank(ViridianForestPic)
	db $00

TileData_30561: ; 0x30561
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw ViridianForestPic + $150
	db Bank(ViridianForestPic)
	db $00

TileData_3056b: ; 0x3056b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw PewterCityPic
	db Bank(PewterCityPic)
	db $00

TileData_30575: ; 0x30575
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw PewterCityPic + $30
	db Bank(PewterCityPic)
	db $00

TileData_3057f: ; 0x3057f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw PewterCityPic + $60
	db Bank(PewterCityPic)
	db $00

TileData_30589: ; 0x30589
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw PewterCityPic + $90
	db Bank(PewterCityPic)
	db $00

TileData_30593: ; 0x30593
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw PewterCityPic + $C0
	db Bank(PewterCityPic)
	db $00

TileData_3059d: ; 0x3059d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw PewterCityPic + $F0
	db Bank(PewterCityPic)
	db $00

TileData_305a7: ; 0x305a7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw PewterCityPic + $120
	db Bank(PewterCityPic)
	db $00

TileData_305b1: ; 0x305b1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw PewterCityPic + $150
	db Bank(PewterCityPic)
	db $00

TileData_305bb: ; 0x305bb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw MtMoonPic
	db Bank(MtMoonPic)
	db $00

TileData_305c5: ; 0x305c5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw MtMoonPic + $30
	db Bank(MtMoonPic)
	db $00

TileData_305cf: ; 0x305cf
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw MtMoonPic + $60
	db Bank(MtMoonPic)
	db $00

TileData_305d9: ; 0x305d9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw MtMoonPic + $90
	db Bank(MtMoonPic)
	db $00

TileData_305e3: ; 0x305e3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw MtMoonPic + $C0
	db Bank(MtMoonPic)
	db $00

TileData_305ed: ; 0x305ed
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw MtMoonPic + $F0
	db Bank(MtMoonPic)
	db $00

TileData_305f7: ; 0x305f7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw MtMoonPic + $120
	db Bank(MtMoonPic)
	db $00

TileData_30601: ; 0x30601
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw MtMoonPic + $150
	db Bank(MtMoonPic)
	db $00

TileData_3060b: ; 0x3060b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw CeruleanCityPic
	db Bank(CeruleanCityPic)
	db $00

TileData_30615: ; 0x30615
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw CeruleanCityPic + $30
	db Bank(CeruleanCityPic)
	db $00

TileData_3061f: ; 0x3061f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw CeruleanCityPic + $60
	db Bank(CeruleanCityPic)
	db $00

TileData_30629: ; 0x30629
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw CeruleanCityPic + $90
	db Bank(CeruleanCityPic)
	db $00

TileData_30633: ; 0x30633
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw CeruleanCityPic + $C0
	db Bank(CeruleanCityPic)
	db $00

TileData_3063d: ; 0x3063d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw CeruleanCityPic + $F0
	db Bank(CeruleanCityPic)
	db $00

TileData_30647: ; 0x30647
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw CeruleanCityPic + $120
	db Bank(CeruleanCityPic)
	db $00

TileData_30651: ; 0x30651
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw CeruleanCityPic + $150
	db Bank(CeruleanCityPic)
	db $00

TileData_3065b: ; 0x3065b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw VermilionCitySeasidePic
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_30665: ; 0x30665
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw VermilionCitySeasidePic + $30
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_3066f: ; 0x3066f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw VermilionCitySeasidePic + $60
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_30679: ; 0x30679
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw VermilionCitySeasidePic + $90
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_30683: ; 0x30683
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw VermilionCitySeasidePic + $C0
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_3068d: ; 0x3068d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw VermilionCitySeasidePic + $F0
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_30697: ; 0x30697
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw VermilionCitySeasidePic + $120
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_306a1: ; 0x306a1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw VermilionCitySeasidePic + $150
	db Bank(VermilionCitySeasidePic)
	db $00

TileData_306ab: ; 0x306ab
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw VermilionCityStreetsPic
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306b5: ; 0x306b5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw VermilionCityStreetsPic + $30
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306bf: ; 0x306bf
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw VermilionCityStreetsPic + $60
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306c9: ; 0x306c9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw VermilionCityStreetsPic + $90
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306d3: ; 0x306d3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw VermilionCityStreetsPic + $C0
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306dd: ; 0x306dd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw VermilionCityStreetsPic + $F0
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306e7: ; 0x306e7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw VermilionCityStreetsPic + $120
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306f1: ; 0x306f1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw VermilionCityStreetsPic + $150
	db Bank(VermilionCityStreetsPic)
	db $00

TileData_306fb: ; 0x306fb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw RockMountainPic
	db Bank(RockMountainPic)
	db $00

TileData_30705: ; 0x30705
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw RockMountainPic + $30
	db Bank(RockMountainPic)
	db $00

TileData_3070f: ; 0x3070f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw RockMountainPic + $60
	db Bank(RockMountainPic)
	db $00

TileData_30719: ; 0x30719
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw RockMountainPic + $90
	db Bank(RockMountainPic)
	db $00

TileData_30723: ; 0x30723
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw RockMountainPic + $C0
	db Bank(RockMountainPic)
	db $00

TileData_3072d: ; 0x3072d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw RockMountainPic + $F0
	db Bank(RockMountainPic)
	db $00

TileData_30737: ; 0x30737
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw RockMountainPic + $120
	db Bank(RockMountainPic)
	db $00

TileData_30741: ; 0x30741
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw RockMountainPic + $150
	db Bank(RockMountainPic)
	db $00

TileData_3074b: ; 0x3074b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw LavenderTownPic
	db Bank(LavenderTownPic)
	db $00

TileData_30755: ; 0x30755
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw LavenderTownPic + $30
	db Bank(LavenderTownPic)
	db $00

TileData_3075f: ; 0x3075f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw LavenderTownPic + $60
	db Bank(LavenderTownPic)
	db $00

TileData_30769: ; 0x30769
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw LavenderTownPic + $90
	db Bank(LavenderTownPic)
	db $00

TileData_30773: ; 0x30773
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw LavenderTownPic + $C0
	db Bank(LavenderTownPic)
	db $00

TileData_3077d: ; 0x3077d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw LavenderTownPic + $F0
	db Bank(LavenderTownPic)
	db $00

TileData_30787: ; 0x30787
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw LavenderTownPic + $120
	db Bank(LavenderTownPic)
	db $00

TileData_30791: ; 0x30791
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw LavenderTownPic + $150
	db Bank(LavenderTownPic)
	db $00

TileData_3079b: ; 0x3079b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw CeladonCityPic
	db Bank(CeladonCityPic)
	db $00

TileData_307a5: ; 0x307a5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw CeladonCityPic + $30
	db Bank(CeladonCityPic)
	db $00

TileData_307af: ; 0x307af
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw CeladonCityPic + $60
	db Bank(CeladonCityPic)
	db $00

TileData_307b9: ; 0x307b9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw CeladonCityPic + $90
	db Bank(CeladonCityPic)
	db $00

TileData_307c3: ; 0x307c3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw CeladonCityPic + $C0
	db Bank(CeladonCityPic)
	db $00

TileData_307cd: ; 0x307cd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw CeladonCityPic + $F0
	db Bank(CeladonCityPic)
	db $00

TileData_307d7: ; 0x307d7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw CeladonCityPic + $120
	db Bank(CeladonCityPic)
	db $00

TileData_307e1: ; 0x307e1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw CeladonCityPic + $150
	db Bank(CeladonCityPic)
	db $00

TileData_307eb: ; 0x307eb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw CyclingRoadPic
	db Bank(CyclingRoadPic)
	db $00

TileData_307f5: ; 0x307f5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw CyclingRoadPic + $30
	db Bank(CyclingRoadPic)
	db $00

TileData_307ff: ; 0x307ff
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw CyclingRoadPic + $60
	db Bank(CyclingRoadPic)
	db $00

TileData_30809: ; 0x30809
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw CyclingRoadPic + $90
	db Bank(CyclingRoadPic)
	db $00

TileData_30813: ; 0x30813
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw CyclingRoadPic + $C0
	db Bank(CyclingRoadPic)
	db $00

TileData_3081d: ; 0x3081d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw CyclingRoadPic + $F0
	db Bank(CyclingRoadPic)
	db $00

TileData_30827: ; 0x30827
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw CyclingRoadPic + $120
	db Bank(CyclingRoadPic)
	db $00

TileData_30831: ; 0x30831
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw CyclingRoadPic + $150
	db Bank(CyclingRoadPic)
	db $00

TileData_3083b: ; 0x3083b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw FuchsiaCityPic
	db Bank(FuchsiaCityPic)
	db $00

TileData_30845: ; 0x30845
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw FuchsiaCityPic + $30
	db Bank(FuchsiaCityPic)
	db $00

TileData_3084f: ; 0x3084f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw FuchsiaCityPic + $60
	db Bank(FuchsiaCityPic)
	db $00

TileData_30859: ; 0x30859
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw FuchsiaCityPic + $90
	db Bank(FuchsiaCityPic)
	db $00

TileData_30863: ; 0x30863
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw FuchsiaCityPic + $C0
	db Bank(FuchsiaCityPic)
	db $00

TileData_3086d: ; 0x3086d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw FuchsiaCityPic + $F0
	db Bank(FuchsiaCityPic)
	db $00

TileData_30877: ; 0x30877
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw FuchsiaCityPic + $120
	db Bank(FuchsiaCityPic)
	db $00

TileData_30881: ; 0x30881
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw FuchsiaCityPic + $150
	db Bank(FuchsiaCityPic)
	db $00

TileData_3088b: ; 0x3088b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw SafariZonePic
	db Bank(SafariZonePic)
	db $00

TileData_30895: ; 0x30895
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw SafariZonePic + $30
	db Bank(SafariZonePic)
	db $00

TileData_3089f: ; 0x3089f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw SafariZonePic + $60
	db Bank(SafariZonePic)
	db $00

TileData_308a9: ; 0x308a9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw SafariZonePic + $90
	db Bank(SafariZonePic)
	db $00

TileData_308b3: ; 0x308b3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw SafariZonePic + $C0
	db Bank(SafariZonePic)
	db $00

TileData_308bd: ; 0x308bd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw SafariZonePic + $F0
	db Bank(SafariZonePic)
	db $00

TileData_308c7: ; 0x308c7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw SafariZonePic + $120
	db Bank(SafariZonePic)
	db $00

TileData_308d1: ; 0x308d1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw SafariZonePic + $150
	db Bank(SafariZonePic)
	db $00

TileData_308db: ; 0x308db
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw SaffronCityPic
	db Bank(SaffronCityPic)
	db $00

TileData_308e5: ; 0x308e5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw SaffronCityPic + $30
	db Bank(SaffronCityPic)
	db $00

TileData_308ef: ; 0x308ef
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw SaffronCityPic + $60
	db Bank(SaffronCityPic)
	db $00

TileData_308f9: ; 0x308f9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw SaffronCityPic + $90
	db Bank(SaffronCityPic)
	db $00

TileData_30903: ; 0x30903
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw SaffronCityPic + $C0
	db Bank(SaffronCityPic)
	db $00

TileData_3090d: ; 0x3090d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw SaffronCityPic + $F0
	db Bank(SaffronCityPic)
	db $00

TileData_30917: ; 0x30917
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw SaffronCityPic + $120
	db Bank(SaffronCityPic)
	db $00

TileData_30921: ; 0x30921
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw SaffronCityPic + $150
	db Bank(SaffronCityPic)
	db $00

TileData_3092b: ; 0x3092b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw SeafoamIslandsPic
	db Bank(SeafoamIslandsPic)
	db $00

TileData_30935: ; 0x30935
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw SeafoamIslandsPic + $30
	db Bank(SeafoamIslandsPic)
	db $00

TileData_3093f: ; 0x3093f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw SeafoamIslandsPic + $60
	db Bank(SeafoamIslandsPic)
	db $00

TileData_30949: ; 0x30949
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw SeafoamIslandsPic + $90
	db Bank(SeafoamIslandsPic)
	db $00

TileData_30953: ; 0x30953
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw SeafoamIslandsPic + $C0
	db Bank(SeafoamIslandsPic)
	db $00

TileData_3095d: ; 0x3095d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw SeafoamIslandsPic + $F0
	db Bank(SeafoamIslandsPic)
	db $00

TileData_30967: ; 0x30967
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw SeafoamIslandsPic + $120
	db Bank(SeafoamIslandsPic)
	db $00

TileData_30971: ; 0x30971
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw SeafoamIslandsPic + $150
	db Bank(SeafoamIslandsPic)
	db $00

TileData_3097b: ; 0x3097b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw CinnabarIslandPic
	db Bank(CinnabarIslandPic)
	db $00

TileData_30985: ; 0x30985
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw CinnabarIslandPic + $30
	db Bank(CinnabarIslandPic)
	db $00

TileData_3098f: ; 0x3098f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw CinnabarIslandPic + $60
	db Bank(CinnabarIslandPic)
	db $00

TileData_30999: ; 0x30999
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw CinnabarIslandPic + $90
	db Bank(CinnabarIslandPic)
	db $00

TileData_309a3: ; 0x309a3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw CinnabarIslandPic + $C0
	db Bank(CinnabarIslandPic)
	db $00

TileData_309ad: ; 0x309ad
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw CinnabarIslandPic + $F0
	db Bank(CinnabarIslandPic)
	db $00

TileData_309b7: ; 0x309b7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw CinnabarIslandPic + $120
	db Bank(CinnabarIslandPic)
	db $00

TileData_309c1: ; 0x309c1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw CinnabarIslandPic + $150
	db Bank(CinnabarIslandPic)
	db $00

TileData_309cb: ; 0x309cb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw IndigoPlateauPic
	db Bank(IndigoPlateauPic)
	db $00

TileData_309d5: ; 0x309d5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw IndigoPlateauPic + $30
	db Bank(IndigoPlateauPic)
	db $00

TileData_309df: ; 0x309df
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw IndigoPlateauPic + $60
	db Bank(IndigoPlateauPic)
	db $00

TileData_309e9: ; 0x309e9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw IndigoPlateauPic + $90
	db Bank(IndigoPlateauPic)
	db $00

TileData_309f3: ; 0x309f3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw IndigoPlateauPic + $C0
	db Bank(IndigoPlateauPic)
	db $00

TileData_309fd: ; 0x309fd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw IndigoPlateauPic + $F0
	db Bank(IndigoPlateauPic)
	db $00

TileData_30a07: ; 0x30a07
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw IndigoPlateauPic + $120
	db Bank(IndigoPlateauPic)
	db $00

TileData_30a11: ; 0x30a11
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw IndigoPlateauPic + $150
	db Bank(IndigoPlateauPic)
	db $00

TileData_30a1b: ; 0x30a1b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw HurryUp2OnPic
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a25: ; 0x30a25
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw HurryUp2OnPic + $30
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a2f: ; 0x30a2f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw HurryUp2OnPic + $60
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a39: ; 0x30a39
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw HurryUp2OnPic + $90
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a43: ; 0x30a43
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw HurryUp2OnPic + $C0
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a4d: ; 0x30a4d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw HurryUp2OnPic + $F0
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a57: ; 0x30a57
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw HurryUp2OnPic + $120
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a61: ; 0x30a61
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw HurryUp2OnPic + $150
	db Bank(HurryUp2OnPic)
	db $00

TileData_30a6b: ; 0x30a6b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw HurryUpOnPic
	db Bank(HurryUpOnPic)
	db $00

TileData_30a75: ; 0x30a75
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw HurryUpOnPic + $30
	db Bank(HurryUpOnPic)
	db $00

TileData_30a7f: ; 0x30a7f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw HurryUpOnPic + $60
	db Bank(HurryUpOnPic)
	db $00

TileData_30a89: ; 0x30a89
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw HurryUpOnPic + $90
	db Bank(HurryUpOnPic)
	db $00

TileData_30a93: ; 0x30a93
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw HurryUpOnPic + $C0
	db Bank(HurryUpOnPic)
	db $00

TileData_30a9d: ; 0x30a9d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw HurryUpOnPic + $F0
	db Bank(HurryUpOnPic)
	db $00

TileData_30aa7: ; 0x30aa7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw HurryUpOnPic + $120
	db Bank(HurryUpOnPic)
	db $00

TileData_30ab1: ; 0x30ab1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw HurryUpOnPic + $150
	db Bank(HurryUpOnPic)
	db $00

TileData_30abb: ; 0x30abb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw GoToNextOnPic
	db Bank(GoToNextOnPic)
	db $00

TileData_30ac5: ; 0x30ac5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw GoToNextOnPic + $30
	db Bank(GoToNextOnPic)
	db $00

TileData_30acf: ; 0x30acf
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw GoToNextOnPic + $60
	db Bank(GoToNextOnPic)
	db $00

TileData_30ad9: ; 0x30ad9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw GoToNextOnPic + $90
	db Bank(GoToNextOnPic)
	db $00

TileData_30ae3: ; 0x30ae3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw GoToNextOnPic + $C0
	db Bank(GoToNextOnPic)
	db $00

TileData_30aed: ; 0x30aed
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw GoToNextOnPic + $F0
	db Bank(GoToNextOnPic)
	db $00

TileData_30af7: ; 0x30af7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw GoToNextOnPic + $120
	db Bank(GoToNextOnPic)
	db $00

TileData_30b01: ; 0x30b01
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw GoToNextOnPic + $150
	db Bank(GoToNextOnPic)
	db $00

TileData_30b0b: ; 0x30b0b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw GoToGengarBonusOnPic
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b15: ; 0x30b15
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw GoToGengarBonusOnPic + $30
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b1f: ; 0x30b1f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw GoToGengarBonusOnPic + $60
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b29: ; 0x30b29
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw GoToGengarBonusOnPic + $90
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b33: ; 0x30b33
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw GoToGengarBonusOnPic + $C0
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b3d: ; 0x30b3d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw GoToGengarBonusOnPic + $F0
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b47: ; 0x30b47
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw GoToGengarBonusOnPic + $120
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b51: ; 0x30b51
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw GoToGengarBonusOnPic + $150
	db Bank(GoToGengarBonusOnPic)
	db $00

TileData_30b5b: ; 0x30b5b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw GoToMewtwoBonusOnPic
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30b65: ; 0x30b65
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw GoToMewtwoBonusOnPic + $30
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30b6f: ; 0x30b6f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw GoToMewtwoBonusOnPic + $60
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30b79: ; 0x30b79
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw GoToMewtwoBonusOnPic + $90
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30b83: ; 0x30b83
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw GoToMewtwoBonusOnPic + $C0
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30b8d: ; 0x30b8d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw GoToMewtwoBonusOnPic + $F0
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30b97: ; 0x30b97
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw GoToMewtwoBonusOnPic + $120
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30ba1: ; 0x30ba1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw GoToMewtwoBonusOnPic + $150
	db Bank(GoToMewtwoBonusOnPic)
	db $00

TileData_30bab: ; 0x30bab
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw GoToMeowthBonusOnPic
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bb5: ; 0x30bb5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw GoToMeowthBonusOnPic + $30
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bbf: ; 0x30bbf
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw GoToMeowthBonusOnPic + $60
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bc9: ; 0x30bc9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw GoToMeowthBonusOnPic + $90
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bd3: ; 0x30bd3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw GoToMeowthBonusOnPic + $C0
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bdd: ; 0x30bdd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw GoToMeowthBonusOnPic + $F0
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30be7: ; 0x30be7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw GoToMeowthBonusOnPic + $120
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bf1: ; 0x30bf1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw GoToMeowthBonusOnPic + $150
	db Bank(GoToMeowthBonusOnPic)
	db $00

TileData_30bfb: ; 0x30bfb
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw GoToDiglettBonusOnPic
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c05: ; 0x30c05
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw GoToDiglettBonusOnPic + $30
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c0f: ; 0x30c0f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw GoToDiglettBonusOnPic + $60
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c19: ; 0x30c19
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw GoToDiglettBonusOnPic + $90
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c23: ; 0x30c23
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw GoToDiglettBonusOnPic + $C0
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c2d: ; 0x30c2d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw GoToDiglettBonusOnPic + $F0
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c37: ; 0x30c37
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw GoToDiglettBonusOnPic + $120
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c41: ; 0x30c41
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw GoToDiglettBonusOnPic + $150
	db Bank(GoToDiglettBonusOnPic)
	db $00

TileData_30c4b: ; 0x30c4b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw GoToSeelBonusOnPic
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c55: ; 0x30c55
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw GoToSeelBonusOnPic + $30
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c5f: ; 0x30c5f
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw GoToSeelBonusOnPic + $60
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c69: ; 0x30c69
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw GoToSeelBonusOnPic + $90
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c73: ; 0x30c73
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw GoToSeelBonusOnPic + $C0
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c7d: ; 0x30c7d
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw GoToSeelBonusOnPic + $F0
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c87: ; 0x30c87
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw GoToSeelBonusOnPic + $120
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c91: ; 0x30c91
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw GoToSeelBonusOnPic + $150
	db Bank(GoToSeelBonusOnPic)
	db $00

TileData_30c9b: ; 0x30c9b
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $10
	dw SlotOnPic
	db Bank(SlotOnPic)
	db $00

TileData_30ca5: ; 0x30ca5
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $13
	dw SlotOnPic + $30
	db Bank(SlotOnPic)
	db $00

TileData_30caf: ; 0x30caf
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $16
	dw SlotOnPic + $60
	db Bank(SlotOnPic)
	db $00

TileData_30cb9: ; 0x30cb9
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $19
	dw SlotOnPic + $90
	db Bank(SlotOnPic)
	db $00

TileData_30cc3: ; 0x30cc3
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1C
	dw SlotOnPic + $C0
	db Bank(SlotOnPic)
	db $00

TileData_30ccd: ; 0x30ccd
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $1F
	dw SlotOnPic + $F0
	db Bank(SlotOnPic)
	db $00

TileData_30cd7: ; 0x30cd7
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $22
	dw SlotOnPic + $120
	db Bank(SlotOnPic)
	db $00

TileData_30ce1: ; 0x30ce1
	dw Func_11d2
	db $30, $03
	dw vTilesSH tile $25
	dw SlotOnPic + $150
	db Bank(SlotOnPic)
	db $00

BillboardPaletteDataPointers: ; 0x30ceb
	dw PalletTownBillboardPaletteData
	dw PaletteData_30d26
	dw PaletteData_30d2b
	dw PaletteData_30d30
	dw PaletteData_30d35
	dw PaletteData_30d3a
	dw PaletteData_30d3f
	dw PaletteData_30d44
	dw PaletteData_30d49
	dw PaletteData_30d4e
	dw PaletteData_30d53
	dw PaletteData_30d58
	dw PaletteData_30d5d
	dw PaletteData_30d62
	dw PaletteData_30d67
	dw PaletteData_30d6c
	dw PaletteData_30d71
	dw PaletteData_30d76
	dw PaletteData_30d7b
	dw PaletteData_30d80
	dw PaletteData_30d85
	dw PaletteData_30d8a
	dw PaletteData_30d8f
	dw PaletteData_30d94
	dw PaletteData_30d99
	dw PaletteData_30d9e
	dw PaletteData_30da3

PalletTownBillboardPaletteData: ; 0x30d21
	db $02
	dw PalletTownBillboardBGPaletteData
	dw PalletTownBillboardBGPaletteMapData

PaletteData_30d26: ; 0x30d26
	db $02
	dw PaletteData_30dcd
	dw PaletteMapData_30dd6

PaletteData_30d2b: ; 0x30d2b
	db $02
	dw PaletteData_30df2
	dw PaletteMapData_30dfb

PaletteData_30d30: ; 0x30d30
	db $02
	dw PaletteData_30e17
	dw PaletteMapData_30e20

PaletteData_30d35: ; 0x30d35
	db $02
	dw PaletteData_30e3c
	dw PaletteMapData_30e45

PaletteData_30d3a: ; 0x30d3a
	db $02
	dw PaletteData_30e61
	dw PaletteMapData_30e6a

PaletteData_30d3f: ; 0x30d3f
	db $02
	dw PaletteData_30e86
	dw PaletteMapData_30e8f

PaletteData_30d44: ; 0x30d44
	db $02
	dw PaletteData_30eab
	dw PaletteMapData_30eb4

PaletteData_30d49: ; 0x30d49
	db $02
	dw PaletteData_30ed0
	dw PaletteMapData_30ed9

PaletteData_30d4e: ; 0x30d4e
	db $02
	dw PaletteData_30ef5
	dw PaletteMapData_30efe

PaletteData_30d53: ; 0x30d53
	db $02
	dw PaletteData_30f1a
	dw PaletteMapData_30f23

PaletteData_30d58: ; 0x30d58
	db $02
	dw PaletteData_30f3f
	dw PaletteMapData_30f48

PaletteData_30d5d: ; 0x30d5d
	db $02
	dw PaletteData_30f64
	dw PaletteMapData_30f6d

PaletteData_30d62: ; 0x30d62
	db $02
	dw PaletteData_30f89
	dw PaletteMapData_30f92

PaletteData_30d67: ; 0x30d67
	db $02
	dw PaletteData_30fae
	dw PaletteMapData_30fb7

PaletteData_30d6c: ; 0x30d6c
	db $02
	dw PaletteData_30fd3
	dw PaletteMapData_30fdc

PaletteData_30d71: ; 0x30d71
	db $02
	dw PaletteData_30ff8
	dw PaletteMapData_31001

PaletteData_30d76: ; 0x30d76
	db $02
	dw PaletteData_3101d
	dw PaletteMapData_31026

PaletteData_30d7b: ; 0x30d7b
	db $02
	dw PaletteData_31042
	dw PaletteMapData_3104b

PaletteData_30d80: ; 0x30d80
	db $02
	dw PaletteData_31067
	dw PaletteMapData_31070

PaletteData_30d85: ; 0x30d85
	db $02
	dw PaletteData_3108c
	dw PaletteMapData_31095

PaletteData_30d8a: ; 0x30d8a
	db $02
	dw PaletteData_310b1
	dw PaletteMapData_310ba

PaletteData_30d8f: ; 0x30d8f
	db $02
	dw PaletteData_310d6
	dw PaletteMapData_310df

PaletteData_30d94: ; 0x30d94
	db $02
	dw PaletteData_310fb
	dw PaletteMapData_31104

PaletteData_30d99: ; 0x30d99
	db $02
	dw PaletteData_31120
	dw PaletteMapData_31129

PaletteData_30d9e: ; 0x30d9e
	db $02
	dw PaletteData_31145
	dw PaletteMapData_3114e

PaletteData_30da3: ; 0x30da3
	db $02
	dw PaletteData_3116a
	dw PaletteMapData_31173

PalletTownBillboardBGPaletteData: ; 0x30da8
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PalletTownBillboardBGPalettes
	db Bank(PalletTownBillboardBGPalettes)
	db $00 ; terminator

PalletTownBillboardBGPaletteMapData: ; 0x30db1
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteTownBillboardBGPaletteMap
	db Bank(PaletteTownBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteTownBillboardBGPaletteMap + $6
	db Bank(PaletteTownBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteTownBillboardBGPaletteMap + $C
	db Bank(PaletteTownBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteTownBillboardBGPaletteMap + $12
	db Bank(PaletteTownBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30dcd: ; 0x30dcd
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw ViridianCityBillboardBGPalettes
	db Bank(ViridianCityBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30dd6: ; 0x30dd6
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw ViridianCityBillboardBGPaletteMap
	db Bank(ViridianCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw ViridianCityBillboardBGPaletteMap + $6
	db Bank(ViridianCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw ViridianCityBillboardBGPaletteMap + $C
	db Bank(ViridianCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw ViridianCityBillboardBGPaletteMap + $12
	db Bank(ViridianCityBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30df2: ; 0x30df2
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw ViridianForestBillboardBGPalettes
	db Bank(ViridianForestBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30dfb: ; 0x30dfb
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw ViridianForestBillboardBGPaletteMap
	db Bank(ViridianForestBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw ViridianForestBillboardBGPaletteMap + $6
	db Bank(ViridianForestBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw ViridianForestBillboardBGPaletteMap + $C
	db Bank(ViridianForestBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw ViridianForestBillboardBGPaletteMap + $12
	db Bank(ViridianForestBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30e17: ; 0x30e17
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PewterCityBillboardBGPalettes
	db Bank(PewterCityBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30e20: ; 0x30e20
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PewterCityBillboardBGPaletteMap
	db Bank(PewterCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PewterCityBillboardBGPaletteMap + $6
	db Bank(PewterCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PewterCityBillboardBGPaletteMap + $C
	db Bank(PewterCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PewterCityBillboardBGPaletteMap + $12
	db Bank(PewterCityBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30e3c: ; 0x30e3c
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw MtMoonBillboardBGPalettes
	db Bank(MtMoonBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30e45: ; 0x30e45
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw MtMoonBillboardBGPaletteMap
	db Bank(MtMoonBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw MtMoonBillboardBGPaletteMap + $6
	db Bank(MtMoonBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw MtMoonBillboardBGPaletteMap + $C
	db Bank(MtMoonBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw MtMoonBillboardBGPaletteMap + $12
	db Bank(MtMoonBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30e61: ; 0x30e61
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw CeruleanCityBillboardBGPalettes
	db Bank(CeruleanCityBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30e6a: ; 0x30e6a
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw CeruleanCityBillboardBGPaletteMap
	db Bank(CeruleanCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw CeruleanCityBillboardBGPaletteMap + $6
	db Bank(CeruleanCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw CeruleanCityBillboardBGPaletteMap + $C
	db Bank(CeruleanCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw CeruleanCityBillboardBGPaletteMap + $12
	db Bank(CeruleanCityBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30e86: ; 0x30e86
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw VermilionSeasideBillboardBGPalettes
	db Bank(VermilionSeasideBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30e8f: ; 0x30e8f
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw VermilionSeasideBillboardBGPaletteMap
	db Bank(VermilionSeasideBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw VermilionSeasideBillboardBGPaletteMap + $6
	db Bank(VermilionSeasideBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw VermilionSeasideBillboardBGPaletteMap + $C
	db Bank(VermilionSeasideBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw VermilionSeasideBillboardBGPaletteMap + $12
	db Bank(VermilionSeasideBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30eab: ; 0x30eab
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw VermilionStreetsBillboardBGPalettes
	db Bank(VermilionStreetsBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30eb4: ; 0x30eb4
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw VermilionStreetsBillboardBGPaletteMap
	db Bank(VermilionStreetsBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw VermilionStreetsBillboardBGPaletteMap + $6
	db Bank(VermilionStreetsBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw VermilionStreetsBillboardBGPaletteMap + $C
	db Bank(VermilionStreetsBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw VermilionStreetsBillboardBGPaletteMap + $12
	db Bank(VermilionStreetsBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30ed0: ; 0x30ed0
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw RockMountainBillboardBGPalettes
	db Bank(RockMountainBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30ed9: ; 0x30ed9
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw RockMountainBillboardBGPaletteMap
	db Bank(RockMountainBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw RockMountainBillboardBGPaletteMap + $6
	db Bank(RockMountainBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw RockMountainBillboardBGPaletteMap + $C
	db Bank(RockMountainBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw RockMountainBillboardBGPaletteMap + $12
	db Bank(RockMountainBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30ef5: ; 0x30ef5
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw LavenderTownBillboardBGPalettes
	db Bank(LavenderTownBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30efe: ; 0x30efe
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw LavenderTownBillboardBGPaletteMap
	db Bank(LavenderTownBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw LavenderTownBillboardBGPaletteMap + $6
	db Bank(LavenderTownBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw LavenderTownBillboardBGPaletteMap + $C
	db Bank(LavenderTownBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw LavenderTownBillboardBGPaletteMap + $12
	db Bank(LavenderTownBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30f1a: ; 0x30f1a
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw CeladonCityBillboardBGPalettes
	db Bank(CeladonCityBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30f23: ; 0x30f23
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw CeladonCityBillboardBGPaletteMap
	db Bank(CeladonCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw CeladonCityBillboardBGPaletteMap + $6
	db Bank(CeladonCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw CeladonCityBillboardBGPaletteMap + $C
	db Bank(CeladonCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw CeladonCityBillboardBGPaletteMap + $12
	db Bank(CeladonCityBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30f3f: ; 0x30f3f
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw CyclingRoadBillboardBGPalettes
	db Bank(CyclingRoadBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30f48: ; 0x30f48
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw CyclingRoadBillboardBGPaletteMap
	db Bank(CyclingRoadBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw CyclingRoadBillboardBGPaletteMap + $6
	db Bank(CyclingRoadBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw CyclingRoadBillboardBGPaletteMap + $C
	db Bank(CyclingRoadBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw CyclingRoadBillboardBGPaletteMap + $12
	db Bank(CyclingRoadBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30f64: ; 0x30f64
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw FuchsiaCityBillboardBGPalettes
	db Bank(FuchsiaCityBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30f6d: ; 0x30f6d
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw FuchsiaCityBillboardBGPaletteMap
	db Bank(FuchsiaCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw FuchsiaCityBillboardBGPaletteMap + $6
	db Bank(FuchsiaCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw FuchsiaCityBillboardBGPaletteMap + $C
	db Bank(FuchsiaCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw FuchsiaCityBillboardBGPaletteMap + $12
	db Bank(FuchsiaCityBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30f89: ; 0x30f89
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw SafariZoneBillboardBGPalettes
	db Bank(SafariZoneBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30f92: ; 0x30f92
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw SafariZoneBillboardBGPaletteMap
	db Bank(SafariZoneBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw SafariZoneBillboardBGPaletteMap + $6
	db Bank(SafariZoneBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw SafariZoneBillboardBGPaletteMap + $C
	db Bank(SafariZoneBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw SafariZoneBillboardBGPaletteMap + $12
	db Bank(SafariZoneBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30fae: ; 0x30fae
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw SaffronCityBillboardBGPalettes
	db Bank(SaffronCityBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30fb7: ; 0x30fb7
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw SaffronCityBillboardBGPaletteMap
	db Bank(SaffronCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw SaffronCityBillboardBGPaletteMap + $6
	db Bank(SaffronCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw SaffronCityBillboardBGPaletteMap + $C
	db Bank(SaffronCityBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw SaffronCityBillboardBGPaletteMap + $12
	db Bank(SaffronCityBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30fd3: ; 0x30fd3
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw SeafoamIslandsBillboardBGPalettes
	db Bank(SeafoamIslandsBillboardBGPalettes)
	db $00 ; terminator

PaletteMapData_30fdc: ; 0x30fdc
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw SeafoamIslandsBillboardBGPaletteMap
	db Bank(SeafoamIslandsBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw SeafoamIslandsBillboardBGPaletteMap + $6
	db Bank(SeafoamIslandsBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw SeafoamIslandsBillboardBGPaletteMap + $C
	db Bank(SeafoamIslandsBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw SeafoamIslandsBillboardBGPaletteMap + $12
	db Bank(SeafoamIslandsBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_30ff8: ; 0x30ff8
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw CinnabarIslandBillboardBGPalette1
	db Bank(CinnabarIslandBillboardBGPalette1)
	db $00 ; terminator

PaletteMapData_31001: ; 0x31001
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw CinnabarIslandBillboardBGPaletteMap
	db Bank(CinnabarIslandBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw CinnabarIslandBillboardBGPaletteMap + $6
	db Bank(CinnabarIslandBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw CinnabarIslandBillboardBGPaletteMap + $C
	db Bank(CinnabarIslandBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw CinnabarIslandBillboardBGPaletteMap + $12
	db Bank(CinnabarIslandBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_3101d: ; 0x3101d
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw IndigoPlateauBillboardBGPalette1
	db Bank(IndigoPlateauBillboardBGPalette1)
	db $00 ; terminator

PaletteMapData_31026: ; 0x31026
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw IndigoPlateauBillboardBGPaletteMap
	db Bank(IndigoPlateauBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw IndigoPlateauBillboardBGPaletteMap + $6
	db Bank(IndigoPlateauBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw IndigoPlateauBillboardBGPaletteMap + $C
	db Bank(IndigoPlateauBillboardBGPaletteMap)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw IndigoPlateauBillboardBGPaletteMap + $12
	db Bank(IndigoPlateauBillboardBGPaletteMap)

	db $00 ; terminator

PaletteData_31042: ; 0x31042
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc68
	db Bank(PaletteData_dcc68)
	db $00 ; terminator

PaletteMapData_3104b: ; 0x3104b
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_31067: ; 0x31067
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc68
	db Bank(PaletteData_dcc68)
	db $00 ; terminator

PaletteMapData_31070: ; 0x31070
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_3108c: ; 0x3108c
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc70
	db Bank(PaletteData_dcc70)
	db $00 ; terminator

PaletteMapData_31095: ; 0x31095
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_310b1: ; 0x310b1
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc40
	db Bank(PaletteData_dcc40)
	db $00 ; terminator

PaletteMapData_310ba: ; 0x310ba
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_310d6: ; 0x310d6
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc48
	db Bank(PaletteData_dcc48)
	db $00 ; terminator

PaletteMapData_310df: ; 0x310df
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_310fb: ; 0x310fb
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc50
	db Bank(PaletteData_dcc50)
	db $00 ; terminator

PaletteMapData_31104: ; 0x31104
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_31120: ; 0x31120
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc58
	db Bank(PaletteData_dcc58)
	db $00 ; terminator

PaletteMapData_31129: ; 0x31129
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_31145: ; 0x31145
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dcc60
	db Bank(PaletteData_dcc60)
	db $00 ; terminator

PaletteMapData_3114e: ; 0x3114e
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator

PaletteData_3116a: ; 0x3116a
	dw LoadPalettes
	db $10
	db $08 ; number of colors
	db $30 ; OAM palettes
	dw PaletteData_dd198
	db Bank(PaletteData_dd198)
	db $00 ; terminator

PaletteMapData_31173: ; 0x31173
	dw Func_122e
	db $18 ; total number of bytes

	db $06 ; number of bytes
	dw vBGMap + $87
	dw PaletteMap_d8000
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $a7
	dw PaletteMap_d8000 + $6
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $c7
	dw PaletteMap_d8000 + $C
	db Bank(PaletteMap_d8000)

	db $06 ; number of bytes
	dw vBGMap + $e7
	dw PaletteMap_d8000 + $12
	db Bank(PaletteMap_d8000)

	db $00 ; terminator
