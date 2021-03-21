#!/usr/bin/env python

song_names = {
	0x0f: [
		"Nothing0F",
		"RedField",
		"CatchEmRed",
		"HurryUpRed",
		"Pokedex",
		"GastlyInTheGraveyard",
		"HaunterInTheGraveyard",
		"GengarInTheGraveyard",
	],
	0x10: [
		"Nothing10",
		"BlueField",
		"CatchEmBlue",
		"HurryUpBlue",
		"HiScore",
		"GameOver",
	],
	0x11: [
		"Nothing11",
		"WhackTheDiglett",
		"WhackTheDugtrio",
		"SeelStage",
		"Title",
	],
	0x12: [
		"Nothing12",
		"MewtwoStage",
		"Options",
		"FieldSelect",
		"MeowthStage",
	],
	0x13: [
		"Nothing13",
		"EndCredits",
		"NameEntry",
	],
}

cry_names = {
	0x0f: [
		"00_BankF",
		"01_BankF",
		"02_BankF",
		"03_BankF",
		"04_BankF",
		"05_BankF",
		"06_BankF",
		"07_BankF",
		"08_BankF",
		"09_BankF",
		"0A_BankF",
		"0B_BankF",
		"0C_BankF",
		"0D_BankF",
		"0E_BankF",
		"0F_BankF",
		"10_BankF",
		"11_BankF",
		"12_BankF",
		"13_BankF",
		"14_BankF",
		"15_BankF",
		"16_BankF",
		"17_BankF",
		"18_BankF",
		"19_BankF",
		"1A_BankF",
		"1B_BankF",
		"1C_BankF",
		"1D_BankF",
		"1E_BankF",
		"1F_BankF",
		"20_BankF",
		"21_BankF",
		"22_BankF",
		"23_BankF",
		"24_BankF",
		"25_BankF",
	],
	0x10: [
		"00_Bank10",
		"01_Bank10",
		"02_Bank10",
		"03_Bank10",
		"04_Bank10",
		"05_Bank10",
		"06_Bank10",
		"07_Bank10",
		"08_Bank10",
		"09_Bank10",
		"0A_Bank10",
		"0B_Bank10",
		"0C_Bank10",
		"0D_Bank10",
		"0E_Bank10",
		"0F_Bank10",
		"10_Bank10",
		"11_Bank10",
		"12_Bank10",
		"13_Bank10",
		"14_Bank10",
		"15_Bank10",
		"16_Bank10",
		"17_Bank10",
		"18_Bank10",
		"19_Bank10",
		"1A_Bank10",
		"1B_Bank10",
		"1C_Bank10",
		"1D_Bank10",
		"1E_Bank10",
		"1F_Bank10",
		"20_Bank10",
		"21_Bank10",
		"22_Bank10",
		"23_Bank10",
		"24_Bank10",
		"25_Bank10",
	],
	0x11: [
		"00_Bank11",
		"01_Bank11",
		"02_Bank11",
		"03_Bank11",
		"04_Bank11",
		"05_Bank11",
		"06_Bank11",
		"07_Bank11",
		"08_Bank11",
		"09_Bank11",
		"0A_Bank11",
		"0B_Bank11",
		"0C_Bank11",
		"0D_Bank11",
		"0E_Bank11",
		"0F_Bank11",
		"10_Bank11",
		"11_Bank11",
		"12_Bank11",
		"13_Bank11",
		"14_Bank11",
		"15_Bank11",
		"16_Bank11",
		"17_Bank11",
		"18_Bank11",
		"19_Bank11",
		"1A_Bank11",
		"1B_Bank11",
		"1C_Bank11",
		"1D_Bank11",
		"1E_Bank11",
		"1F_Bank11",
		"20_Bank11",
		"21_Bank11",
		"22_Bank11",
		"23_Bank11",
		"24_Bank11",
		"25_Bank11",
	],
	0x12: [
		"00_Bank12",
		"01_Bank12",
		"02_Bank12",
		"03_Bank12",
		"04_Bank12",
		"05_Bank12",
		"06_Bank12",
		"07_Bank12",
		"08_Bank12",
		"09_Bank12",
		"0A_Bank12",
		"0B_Bank12",
		"0C_Bank12",
		"0D_Bank12",
		"0E_Bank12",
		"0F_Bank12",
		"10_Bank12",
		"11_Bank12",
		"12_Bank12",
		"13_Bank12",
		"14_Bank12",
		"15_Bank12",
		"16_Bank12",
		"17_Bank12",
		"18_Bank12",
		"19_Bank12",
		"1A_Bank12",
		"1B_Bank12",
		"1C_Bank12",
		"1D_Bank12",
		"1E_Bank12",
		"1F_Bank12",
		"20_Bank12",
		"21_Bank12",
		"22_Bank12",
		"23_Bank12",
		"24_Bank12",
		"25_Bank12",
	],
	0x13: [
		"00_Bank13",
		"01_Bank13",
		"02_Bank13",
		"03_Bank13",
		"04_Bank13",
		"05_Bank13",
		"06_Bank13",
		"07_Bank13",
		"08_Bank13",
		"09_Bank13",
		"0A_Bank13",
		"0B_Bank13",
		"0C_Bank13",
		"0D_Bank13",
		"0E_Bank13",
		"0F_Bank13",
		"10_Bank13",
		"11_Bank13",
		"12_Bank13",
		"13_Bank13",
		"14_Bank13",
		"15_Bank13",
		"16_Bank13",
		"17_Bank13",
		"18_Bank13",
		"19_Bank13",
		"1A_Bank13",
		"1B_Bank13",
		"1C_Bank13",
		"1D_Bank13",
		"1E_Bank13",
		"1F_Bank13",
		"20_Bank13",
		"21_Bank13",
		"22_Bank13",
		"23_Bank13",
		"24_Bank13",
		"25_Bank13",
	],
}

sfx_names = {
	0x0f: [
		"SoundEffect0_BankF",
		"SoundEffect1_BankF",
		"SoundEffect2_BankF",
		"SoundEffect3_BankF",
		"SoundEffect4_BankF",
		"SoundEffect5_BankF",
		"SoundEffect6_BankF",
		"SoundEffect7_BankF",
		"SoundEffect8_BankF",
		"SoundEffect9_BankF",
		"SoundEffect10_BankF",
		"SoundEffect11_BankF",
		"SoundEffect12_BankF",
		"SoundEffect13_BankF",
		"SoundEffect14_BankF",
		"SoundEffect15_BankF",
		"SoundEffect16_BankF",
		"SoundEffect17_BankF",
		"SoundEffect18_BankF",
		"SoundEffect19_BankF",
		"SoundEffect20_BankF",
		"SoundEffect21_BankF",
		"SoundEffect22_BankF",
		"SoundEffect23_BankF",
		"SoundEffect24_BankF",
		"SoundEffect25_BankF",
		"SoundEffect26_BankF",
		"SoundEffect27_BankF",
		"SoundEffect28_BankF",
		"SoundEffect29_BankF",
		"SoundEffect30_BankF",
		"SoundEffect31_BankF",
		"SoundEffect32_BankF",
		"SoundEffect33_BankF",
		"SoundEffect34_BankF",
		"SoundEffect35_BankF",
		"SoundEffect36_BankF",
		"SoundEffect37_BankF",
		"SoundEffect38_BankF",
		"SoundEffect39_BankF",
		"SoundEffect40_BankF",
		"SoundEffect41_BankF",
		"SoundEffect42_BankF",
		"SoundEffect43_BankF",
		"SoundEffect44_BankF",
		"SoundEffect45_BankF",
		"SoundEffect46_BankF",
		"SoundEffect47_BankF",
		"SoundEffect48_BankF",
		"SoundEffect49_BankF",
		"SoundEffect50_BankF",
		"SoundEffect51_BankF",
		"SoundEffect52_BankF",
		"SoundEffect53_BankF",
		"SoundEffect54_BankF",
		"SoundEffect55_BankF",
		"SoundEffect56_BankF",
		"SoundEffect57_BankF",
		"SoundEffect58_BankF",
		"SoundEffect59_BankF",
		"SoundEffect60_BankF",
		"SoundEffect61_BankF",
		"SoundEffect62_BankF",
		"SoundEffect63_BankF",
		"SoundEffect64_BankF",
		"SoundEffect65_BankF",
		"SoundEffect66_BankF",
		"SoundEffect67_BankF",
		"SoundEffect68_BankF",
		"SoundEffect69_BankF",
		"SoundEffect70_BankF",
		"SoundEffect71_BankF",
		"SoundEffect72_BankF",
		"SoundEffect73_BankF",
		"SoundEffect74_BankF",
		"SoundEffect75_BankF",
		"SoundEffect76_BankF",
		"SoundEffect77_BankF",
	],
	0x10: [
		"SoundEffect0_Bank10",
		"SoundEffect1_Bank10",
		"SoundEffect2_Bank10",
		"SoundEffect3_Bank10",
		"SoundEffect4_Bank10",
		"SoundEffect5_Bank10",
		"SoundEffect6_Bank10",
		"SoundEffect7_Bank10",
		"SoundEffect8_Bank10",
		"SoundEffect9_Bank10",
		"SoundEffect10_Bank10",
		"SoundEffect11_Bank10",
		"SoundEffect12_Bank10",
		"SoundEffect13_Bank10",
		"SoundEffect14_Bank10",
		"SoundEffect15_Bank10",
		"SoundEffect16_Bank10",
		"SoundEffect17_Bank10",
		"SoundEffect18_Bank10",
		"SoundEffect19_Bank10",
		"SoundEffect20_Bank10",
		"SoundEffect21_Bank10",
		"SoundEffect22_Bank10",
		"SoundEffect23_Bank10",
		"SoundEffect24_Bank10",
		"SoundEffect25_Bank10",
		"SoundEffect26_Bank10",
		"SoundEffect27_Bank10",
		"SoundEffect28_Bank10",
		"SoundEffect29_Bank10",
		"SoundEffect30_Bank10",
		"SoundEffect31_Bank10",
		"SoundEffect32_Bank10",
		"SoundEffect33_Bank10",
		"SoundEffect34_Bank10",
		"SoundEffect35_Bank10",
		"SoundEffect36_Bank10",
		"SoundEffect37_Bank10",
		"SoundEffect38_Bank10",
		"SoundEffect39_Bank10",
		"SoundEffect40_Bank10",
		"SoundEffect41_Bank10",
		"SoundEffect42_Bank10",
		"SoundEffect43_Bank10",
		"SoundEffect44_Bank10",
		"SoundEffect45_Bank10",
		"SoundEffect46_Bank10",
		"SoundEffect47_Bank10",
		"SoundEffect48_Bank10",
		"SoundEffect49_Bank10",
		"SoundEffect50_Bank10",
		"SoundEffect51_Bank10",
		"SoundEffect52_Bank10",
		"SoundEffect53_Bank10",
		"SoundEffect54_Bank10",
		"SoundEffect55_Bank10",
		"SoundEffect56_Bank10",
		"SoundEffect57_Bank10",
		"SoundEffect58_Bank10",
		"SoundEffect59_Bank10",
		"SoundEffect60_Bank10",
		"SoundEffect61_Bank10",
		"SoundEffect62_Bank10",
		"SoundEffect63_Bank10",
		"SoundEffect64_Bank10",
		"SoundEffect65_Bank10",
		"SoundEffect66_Bank10",
		"SoundEffect67_Bank10",
		"SoundEffect68_Bank10",
		"SoundEffect69_Bank10",
		"SoundEffect70_Bank10",
		"SoundEffect71_Bank10",
		"SoundEffect72_Bank10",
		"SoundEffect73_Bank10",
		"SoundEffect74_Bank10",
		"SoundEffect75_Bank10",
		"SoundEffect76_Bank10",
		"SoundEffect77_Bank10",
	],
	0x11: [
		"SoundEffect0_Bank11",
		"SoundEffect1_Bank11",
		"SoundEffect2_Bank11",
		"SoundEffect3_Bank11",
		"SoundEffect4_Bank11",
		"SoundEffect5_Bank11",
		"SoundEffect6_Bank11",
		"SoundEffect7_Bank11",
		"SoundEffect8_Bank11",
		"SoundEffect9_Bank11",
		"SoundEffect10_Bank11",
		"SoundEffect11_Bank11",
		"SoundEffect12_Bank11",
		"SoundEffect13_Bank11",
		"SoundEffect14_Bank11",
		"SoundEffect15_Bank11",
		"SoundEffect16_Bank11",
		"SoundEffect17_Bank11",
		"SoundEffect18_Bank11",
		"SoundEffect19_Bank11",
		"SoundEffect20_Bank11",
		"SoundEffect21_Bank11",
		"SoundEffect22_Bank11",
		"SoundEffect23_Bank11",
		"SoundEffect24_Bank11",
		"SoundEffect25_Bank11",
		"SoundEffect26_Bank11",
		"SoundEffect27_Bank11",
		"SoundEffect28_Bank11",
		"SoundEffect29_Bank11",
		"SoundEffect30_Bank11",
		"SoundEffect31_Bank11",
		"SoundEffect32_Bank11",
		"SoundEffect33_Bank11",
		"SoundEffect34_Bank11",
		"SoundEffect35_Bank11",
		"SoundEffect36_Bank11",
		"SoundEffect37_Bank11",
		"SoundEffect38_Bank11",
		"SoundEffect39_Bank11",
		"SoundEffect40_Bank11",
		"SoundEffect41_Bank11",
		"SoundEffect42_Bank11",
		"SoundEffect43_Bank11",
		"SoundEffect44_Bank11",
		"SoundEffect45_Bank11",
		"SoundEffect46_Bank11",
		"SoundEffect47_Bank11",
		"SoundEffect48_Bank11",
		"SoundEffect49_Bank11",
		"SoundEffect50_Bank11",
		"SoundEffect51_Bank11",
		"SoundEffect52_Bank11",
		"SoundEffect53_Bank11",
		"SoundEffect54_Bank11",
		"SoundEffect55_Bank11",
		"SoundEffect56_Bank11",
		"SoundEffect57_Bank11",
		"SoundEffect58_Bank11",
		"SoundEffect59_Bank11",
		"SoundEffect60_Bank11",
		"SoundEffect61_Bank11",
		"SoundEffect62_Bank11",
		"SoundEffect63_Bank11",
		"SoundEffect64_Bank11",
		"SoundEffect65_Bank11",
		"SoundEffect66_Bank11",
		"SoundEffect67_Bank11",
		"SoundEffect68_Bank11",
		"SoundEffect69_Bank11",
		"SoundEffect70_Bank11",
		"SoundEffect71_Bank11",
		"SoundEffect72_Bank11",
		"SoundEffect73_Bank11",
		"SoundEffect74_Bank11",
		"SoundEffect75_Bank11",
		"SoundEffect76_Bank11",
		"SoundEffect77_Bank11",
	],
	0x12: [
		"SoundEffect0_Bank12",
		"SoundEffect1_Bank12",
		"SoundEffect2_Bank12",
		"SoundEffect3_Bank12",
		"SoundEffect4_Bank12",
		"SoundEffect5_Bank12",
		"SoundEffect6_Bank12",
		"SoundEffect7_Bank12",
		"SoundEffect8_Bank12",
		"SoundEffect9_Bank12",
		"SoundEffect10_Bank12",
		"SoundEffect11_Bank12",
		"SoundEffect12_Bank12",
		"SoundEffect13_Bank12",
		"SoundEffect14_Bank12",
		"SoundEffect15_Bank12",
		"SoundEffect16_Bank12",
		"SoundEffect17_Bank12",
		"SoundEffect18_Bank12",
		"SoundEffect19_Bank12",
		"SoundEffect20_Bank12",
		"SoundEffect21_Bank12",
		"SoundEffect22_Bank12",
		"SoundEffect23_Bank12",
		"SoundEffect24_Bank12",
		"SoundEffect25_Bank12",
		"SoundEffect26_Bank12",
		"SoundEffect27_Bank12",
		"SoundEffect28_Bank12",
		"SoundEffect29_Bank12",
		"SoundEffect30_Bank12",
		"SoundEffect31_Bank12",
		"SoundEffect32_Bank12",
		"SoundEffect33_Bank12",
		"SoundEffect34_Bank12",
		"SoundEffect35_Bank12",
		"SoundEffect36_Bank12",
		"SoundEffect37_Bank12",
		"SoundEffect38_Bank12",
		"SoundEffect39_Bank12",
		"SoundEffect40_Bank12",
		"SoundEffect41_Bank12",
		"SoundEffect42_Bank12",
		"SoundEffect43_Bank12",
		"SoundEffect44_Bank12",
		"SoundEffect45_Bank12",
		"SoundEffect46_Bank12",
		"SoundEffect47_Bank12",
		"SoundEffect48_Bank12",
		"SoundEffect49_Bank12",
		"SoundEffect50_Bank12",
		"SoundEffect51_Bank12",
		"SoundEffect52_Bank12",
		"SoundEffect53_Bank12",
		"SoundEffect54_Bank12",
		"SoundEffect55_Bank12",
		"SoundEffect56_Bank12",
		"SoundEffect57_Bank12",
		"SoundEffect58_Bank12",
		"SoundEffect59_Bank12",
		"SoundEffect60_Bank12",
		"SoundEffect61_Bank12",
		"SoundEffect62_Bank12",
		"SoundEffect63_Bank12",
		"SoundEffect64_Bank12",
		"SoundEffect65_Bank12",
		"SoundEffect66_Bank12",
		"SoundEffect67_Bank12",
		"SoundEffect68_Bank12",
		"SoundEffect69_Bank12",
		"SoundEffect70_Bank12",
		"SoundEffect71_Bank12",
		"SoundEffect72_Bank12",
		"SoundEffect73_Bank12",
		"SoundEffect74_Bank12",
		"SoundEffect75_Bank12",
		"SoundEffect76_Bank12",
		"SoundEffect77_Bank12",
	],
	0x13: [
		"SoundEffect0_Bank13",
		"SoundEffect1_Bank13",
		"SoundEffect2_Bank13",
		"SoundEffect3_Bank13",
		"SoundEffect4_Bank13",
		"SoundEffect5_Bank13",
		"SoundEffect6_Bank13",
		"SoundEffect7_Bank13",
		"SoundEffect8_Bank13",
		"SoundEffect9_Bank13",
		"SoundEffect10_Bank13",
		"SoundEffect11_Bank13",
		"SoundEffect12_Bank13",
		"SoundEffect13_Bank13",
		"SoundEffect14_Bank13",
		"SoundEffect15_Bank13",
		"SoundEffect16_Bank13",
		"SoundEffect17_Bank13",
		"SoundEffect18_Bank13",
		"SoundEffect19_Bank13",
		"SoundEffect20_Bank13",
		"SoundEffect21_Bank13",
		"SoundEffect22_Bank13",
		"SoundEffect23_Bank13",
		"SoundEffect24_Bank13",
		"SoundEffect25_Bank13",
		"SoundEffect26_Bank13",
		"SoundEffect27_Bank13",
		"SoundEffect28_Bank13",
		"SoundEffect29_Bank13",
		"SoundEffect30_Bank13",
		"SoundEffect31_Bank13",
		"SoundEffect32_Bank13",
		"SoundEffect33_Bank13",
		"SoundEffect34_Bank13",
		"SoundEffect35_Bank13",
		"SoundEffect36_Bank13",
		"SoundEffect37_Bank13",
		"SoundEffect38_Bank13",
		"SoundEffect39_Bank13",
		"SoundEffect40_Bank13",
		"SoundEffect41_Bank13",
		"SoundEffect42_Bank13",
		"SoundEffect43_Bank13",
		"SoundEffect44_Bank13",
		"SoundEffect45_Bank13",
		"SoundEffect46_Bank13",
		"SoundEffect47_Bank13",
		"SoundEffect48_Bank13",
		"SoundEffect49_Bank13",
		"SoundEffect50_Bank13",
		"SoundEffect51_Bank13",
		"SoundEffect52_Bank13",
		"SoundEffect53_Bank13",
		"SoundEffect54_Bank13",
		"SoundEffect55_Bank13",
		"SoundEffect56_Bank13",
		"SoundEffect57_Bank13",
		"SoundEffect58_Bank13",
		"SoundEffect59_Bank13",
		"SoundEffect60_Bank13",
		"SoundEffect61_Bank13",
		"SoundEffect62_Bank13",
		"SoundEffect63_Bank13",
		"SoundEffect64_Bank13",
		"SoundEffect65_Bank13",
		"SoundEffect66_Bank13",
		"SoundEffect67_Bank13",
		"SoundEffect68_Bank13",
		"SoundEffect69_Bank13",
		"SoundEffect70_Bank13",
		"SoundEffect71_Bank13",
		"SoundEffect72_Bank13",
		"SoundEffect73_Bank13",
		"SoundEffect74_Bank13",
		"SoundEffect75_Bank13",
		"SoundEffect76_Bank13",
		"SoundEffect77_Bank13",
	],
}

drum_names = {
	0x0f: [
		"Drum00_BankF",
		"Drum01_BankF",
		"Drum02_BankF",
		"Drum03_BankF",
		"Drum04_BankF",
		"Drum05_BankF",
		"Drum06_BankF",
		"Drum07_BankF",
		"Drum08_BankF",
		"Drum09_BankF",
		"Drum10_BankF",
		"Drum11_BankF",
		"Drum12_BankF",
		"Drum00_BankF",
		"Drum00_BankF",
		"Drum00_BankF",

		"Drum00_BankF",
		"Drum06_BankF",
		"Drum02_BankF",
		"Drum03_BankF",
		"Drum04_BankF",
		"Drum13_BankF",
		"Drum14_BankF",
		"Drum15_BankF",
		"Drum16_BankF",
		"Drum17_BankF",
		"Drum18_BankF",
		"Drum11_BankF",
		"Drum19_BankF",
		"Drum00_BankF",
		"Drum00_BankF",
		"Drum00_BankF",

		"Drum00_BankF",
		"Drum10_BankF",
		"Drum11_BankF",
		"Drum03_BankF",
		"Drum04_BankF",
		"Drum20_BankF",
		"Drum21_BankF",
		"Drum22_BankF",
		"Drum08_BankF",
		"Drum09_BankF",
		"Drum23_BankF",
		"Drum24_BankF",
		"Drum25_BankF",
		"Drum00_BankF",
		"Drum00_BankF",
		"Drum00_BankF",
	],
	0x10: [
		"Drum00_Bank10",
		"Drum01_Bank10",
		"Drum02_Bank10",
		"Drum03_Bank10",
		"Drum04_Bank10",
		"Drum05_Bank10",
		"Drum06_Bank10",
		"Drum07_Bank10",
		"Drum08_Bank10",
		"Drum09_Bank10",
		"Drum10_Bank10",
		"Drum11_Bank10",
		"Drum12_Bank10",
		"Drum00_Bank10",
		"Drum00_Bank10",
		"Drum00_Bank10",

		"Drum00_Bank10",
		"Drum06_Bank10",
		"Drum02_Bank10",
		"Drum03_Bank10",
		"Drum04_Bank10",
		"Drum13_Bank10",
		"Drum14_Bank10",
		"Drum15_Bank10",
		"Drum16_Bank10",
		"Drum17_Bank10",
		"Drum18_Bank10",
		"Drum11_Bank10",
		"Drum19_Bank10",
		"Drum00_Bank10",
		"Drum00_Bank10",
		"Drum00_Bank10",

		"Drum00_Bank10",
		"Drum10_Bank10",
		"Drum11_Bank10",
		"Drum03_Bank10",
		"Drum04_Bank10",
		"Drum20_Bank10",
		"Drum21_Bank10",
		"Drum22_Bank10",
		"Drum08_Bank10",
		"Drum09_Bank10",
		"Drum23_Bank10",
		"Drum24_Bank10",
		"Drum25_Bank10",
		"Drum00_Bank10",
		"Drum00_Bank10",
		"Drum00_Bank10",
	],
	0x11: [
		"Drum00_Bank11",
		"Drum01_Bank11",
		"Drum02_Bank11",
		"Drum03_Bank11",
		"Drum04_Bank11",
		"Drum05_Bank11",
		"Drum06_Bank11",
		"Drum07_Bank11",
		"Drum08_Bank11",
		"Drum09_Bank11",
		"Drum10_Bank11",
		"Drum11_Bank11",
		"Drum12_Bank11",
		"Drum00_Bank11",
		"Drum00_Bank11",
		"Drum00_Bank11",

		"Drum00_Bank11",
		"Drum06_Bank11",
		"Drum02_Bank11",
		"Drum03_Bank11",
		"Drum04_Bank11",
		"Drum13_Bank11",
		"Drum14_Bank11",
		"Drum15_Bank11",
		"Drum16_Bank11",
		"Drum17_Bank11",
		"Drum18_Bank11",
		"Drum11_Bank11",
		"Drum19_Bank11",
		"Drum00_Bank11",
		"Drum00_Bank11",
		"Drum00_Bank11",

		"Drum00_Bank11",
		"Drum10_Bank11",
		"Drum11_Bank11",
		"Drum03_Bank11",
		"Drum04_Bank11",
		"Drum20_Bank11",
		"Drum21_Bank11",
		"Drum22_Bank11",
		"Drum08_Bank11",
		"Drum09_Bank11",
		"Drum23_Bank11",
		"Drum24_Bank11",
		"Drum25_Bank11",
		"Drum00_Bank11",
		"Drum00_Bank11",
		"Drum00_Bank11",
	],
	0x12: [
		"Drum00_Bank12",
		"Drum01_Bank12",
		"Drum02_Bank12",
		"Drum03_Bank12",
		"Drum04_Bank12",
		"Drum05_Bank12",
		"Drum06_Bank12",
		"Drum07_Bank12",
		"Drum08_Bank12",
		"Drum09_Bank12",
		"Drum10_Bank12",
		"Drum11_Bank12",
		"Drum12_Bank12",
		"Drum00_Bank12",
		"Drum00_Bank12",
		"Drum00_Bank12",

		"Drum00_Bank12",
		"Drum06_Bank12",
		"Drum02_Bank12",
		"Drum03_Bank12",
		"Drum04_Bank12",
		"Drum13_Bank12",
		"Drum14_Bank12",
		"Drum15_Bank12",
		"Drum16_Bank12",
		"Drum17_Bank12",
		"Drum18_Bank12",
		"Drum11_Bank12",
		"Drum19_Bank12",
		"Drum00_Bank12",
		"Drum00_Bank12",
		"Drum00_Bank12",

		"Drum00_Bank12",
		"Drum10_Bank12",
		"Drum11_Bank12",
		"Drum03_Bank12",
		"Drum04_Bank12",
		"Drum20_Bank12",
		"Drum21_Bank12",
		"Drum22_Bank12",
		"Drum08_Bank12",
		"Drum09_Bank12",
		"Drum23_Bank12",
		"Drum24_Bank12",
		"Drum25_Bank12",
		"Drum00_Bank12",
		"Drum00_Bank12",
		"Drum00_Bank12",
	],
	0x13: [
		"Drum00_Bank13",
		"Drum01_Bank13",
		"Drum02_Bank13",
		"Drum03_Bank13",
		"Drum04_Bank13",
		"Drum05_Bank13",
		"Drum06_Bank13",
		"Drum07_Bank13",
		"Drum08_Bank13",
		"Drum09_Bank13",
		"Drum10_Bank13",
		"Drum11_Bank13",
		"Drum12_Bank13",
		"Drum00_Bank13",
		"Drum00_Bank13",
		"Drum00_Bank13",

		"Drum00_Bank13",
		"Drum06_Bank13",
		"Drum02_Bank13",
		"Drum03_Bank13",
		"Drum04_Bank13",
		"Drum13_Bank13",
		"Drum14_Bank13",
		"Drum15_Bank13",
		"Drum16_Bank13",
		"Drum17_Bank13",
		"Drum18_Bank13",
		"Drum11_Bank13",
		"Drum19_Bank13",
		"Drum00_Bank13",
		"Drum00_Bank13",
		"Drum00_Bank13",

		"Drum00_Bank13",
		"Drum10_Bank13",
		"Drum11_Bank13",
		"Drum03_Bank13",
		"Drum04_Bank13",
		"Drum20_Bank13",
		"Drum21_Bank13",
		"Drum22_Bank13",
		"Drum08_Bank13",
		"Drum09_Bank13",
		"Drum23_Bank13",
		"Drum24_Bank13",
		"Drum25_Bank13",
		"Drum00_Bank13",
		"Drum00_Bank13",
		"Drum00_Bank13",
	],
}

rom = bytearray(open("baserom.gbc", "rb").read())

# music command names and parameter lists
music_commands = {
	0x00: { "name": "rest",                 "params": [ "lower_nibble_off_by_one" ] },
	0x10: { "name": "note",                 "params": [ "note", "lower_nibble_off_by_one" ] },
	0xb0: { "name": "drum_note",            "params": [ "upper_nibble", "lower_nibble_off_by_one" ] },
	0xd0: { "name": "octave",               "params": [ "octave" ] },
	0xd7: { "name": "drum_speed",           "params": [ "byte" ] },
	0xd8: { "name": "note_type",            "params": [ "byte", "nibbles_unsigned_signed" ] },
	0xda: { "name": "tempo",                "params": [ "word_big_endian" ] },
	0xdb: { "name": "duty_cycle",           "params": [ "byte" ] },
	0xde: { "name": "duty_cycle_pattern",   "params": [ "crumbs" ] },
	0xe0: { "name": "pitch_slide",          "params": [ "byte_off_by_one", "nibbles_octave_note" ] },
	0xe1: { "name": "vibrato",              "params": [ "byte", "nibbles" ] },
	0xe5: { "name": "volume",               "params": [ "nibbles" ] },
	0xef: { "name": "stereo_panning",       "params": [ "nibbles_boolean" ] },
	0xfd: { "name": "sound_loop",           "params": [ "byte", "label" ] },
	0xfe: { "name": "sound_call",           "params": [ "label" ] },
	0xff: { "name": "sound_ret",            "params": [] },

	0xd9: { "name": "transpose",            "params": [ "nibbles" ] },
	0xdc: { "name": "volume_envelope",      "params": [ "nibbles_unsigned_signed" ] },
	0xe3: { "name": "toggle_noise",         "params": [ "byte" ] },
	0xe4: { "name": "force_stereo_panning", "params": [ "nibbles_boolean" ] },
	0xe6: { "name": "pitch_offset",         "params": [ "word_big_endian" ] },
	0xfc: { "name": "sound_jump",           "params": [ "label" ] },

	0x01: { "name": "square_note",          "params": [ "command_byte", "nibbles_unsigned_signed", "word" ] },
	0x02: { "name": "noise_note",           "params": [ "command_byte", "nibbles_unsigned_signed", "byte" ] },
	0xdd: { "name": "pitch_sweep",          "params": [ "nibbles_unsigned_signed" ] },
	0xdf: { "name": "toggle_sfx",           "params": [] },
	0xec: { "name": "sfx_priority_on",      "params": [] },
	0xed: { "name": "sfx_priority_off",     "params": [] },
	0xf0: { "name": "sfx_toggle_noise",     "params": [ "byte" ] },
}

# length in bytes of each type of parameter
param_lengths = {
	"command_byte":            0,
	"note":                    0,
	"upper_nibble":            0,
	"lower_nibble":            0,
	"lower_nibble_off_by_one": 0,
	"octave":                  0,
	"crumbs":                  1,
	"nibbles":                 1,
	"nibbles_boolean":         1,
	"nibbles_binary":          1,
	"nibbles_unsigned_signed": 1,
	"nibbles_octave_note":     1,
	"byte":                    1,
	"byte_off_by_one":         1,
	"word":                    2,
	"word_big_endian":         2,
	"label":                   2,
}

# constants used for note commands
music_notes = {
	0x0: "B_",
	0x1: "C_",
	0x2: "C#",
	0x3: "D_",
	0x4: "D#",
	0x5: "E_",
	0x6: "F_",
	0x7: "F#",
	0x8: "G_",
	0x9: "G#",
	0xa: "A_",
	0xb: "A#",
	0xc: "B_",
}

def get_base_command_id(command_id, channel=1, is_sfx=False):
	# noise
	if command_id < 0xd0 and is_sfx and (channel == 4 or channel == 8):
		return 0x02
	# sound
	elif command_id < 0xd0 and is_sfx:
		return 0x01
	# rest
	elif command_id < 0x10:
		return 0x00
	# drum_note
	elif command_id < 0xd0 and channel == 4:
		return 0xb0
	# note
	elif command_id < 0xd0:
		return 0x10
	# octave
	elif command_id < 0xd8:
		return 0xd0
	# drum_speed
	elif command_id == 0xd8 and (channel == 4 or channel == 8):
		return 0xd7
	else:
		return command_id

def get_bank(address):
	return int(address / 0x4000)

# get absolute pointer stored at an address in the rom
# if bank is None, assumes the pointer refers to the same bank as the bank it is located in
def get_pointer(address, bank=None):
	if bank is None:
		bank = get_bank(address)
	return (rom[address + 1] * 0x100 + rom[address]) % 0x4000 + bank * 0x4000

# return True if the command at address is a loop command
#   and the loop count is 0 (infinite)
#   or if the command is a jump command (effectively the same as infinite loop)
def is_infinite_loop(address):
	return ((rom[address] == 0xfd and rom[address + 1] == 0) or
			(rom[address] == 0xfc))

def make_blob(start, output, end=None, label=None):
	return { "start": start, "output": output, "end": end if end else start, "label": label }

# parse a single channel of a sound
# returns a list of all labels and commands
def dump_channel(start_address, sound_name, channel, prefix="", is_sfx=True, address=None):
	blobs = []
	labels = []
	branches = set()
	if address is None:
		if sound_name == "MewtwoStage" and channel == 2:
			blobs.append(make_blob(0x49052, "; unreferenced\n"))
			branches.add(0x49052)
		blobs.append(make_blob(start_address, "{}{}_Ch{}:\n".format(prefix, sound_name, channel)))
		address = start_address
	while 1:
		if rom[address] == 0xdf:
			is_sfx = not is_sfx
		command_address = address
		command_id = rom[command_address]
		command = music_commands[get_base_command_id(command_id, channel, is_sfx)]
		output = "\t{}".format(command["name"])
		label = None
		address += 1
		# print all params for current command
		for i in range(len(command["params"])):
			param = rom[address]
			param_type = command["params"][i]
			param_length = param_lengths[param_type]
			if param_type == "command_byte":
				output += " {}".format(command_id)
			elif param_type == "note":
				output += " {}".format(music_notes[command_id >> 4])
			elif param_type == "upper_nibble":
				output += " {}".format(command_id >> 4)
			elif param_type == "lower_nibble":
				output += " {}".format(command_id & 0b1111)
			elif param_type == "lower_nibble_off_by_one":
				output += " {}".format((command_id & 0b1111) + 1)
			elif param_type == "octave":
				output += " {}".format(8 - (command_id & 0b1111))
			elif param_type == "crumbs":
				output += " {}, {}, {}, {}".format((param >> 6) & 0b11, (param >> 4) & 0b11, (param >> 2) & 0b11, (param >> 0) & 0b11)
			elif param_type == "nibbles":
				output += " {}, {}".format(param >> 4, param & 0b1111)
			elif param_type == "nibbles_boolean":
				output += " {}, {}".format("TRUE" if param >> 4 else "FALSE", "TRUE" if param & 0b1111 else "FALSE")
			elif param_type == "nibbles_binary":
				output += " %{:04b}, %{:04b}".format(param >> 4, param & 0b1111)
			elif param_type == "nibbles_unsigned_signed":
				output += " {}, {}".format(param >> 4, param & 0b1111 if param & 0b1111 <= 8 else (param & 0b0111) * -1)
			elif param_type == "nibbles_octave_note":
				output += " {}, {}".format(8 - (param >> 4), music_notes[param & 0b1111])
			elif param_type == "byte":
				output += " {}".format(param)
			elif param_type == "byte_off_by_one":
				output += " {}".format(param + 1)
			elif param_type == "word":
				output += " {}".format(param + rom[address + 1] * 0x100)
			elif param_type == "word_big_endian":
				output += " {}".format(param * 0x100 + rom[address + 1])
			elif param_type == "label":
				param = get_pointer(address)
				output += " {:x}".format(param)
				if param == start_address:
					label = "{}{}_Ch{}".format(prefix, sound_name, channel)
				else:
					label = "{}{}_branch_{:x}".format(prefix, sound_name, param)
					if command_id == 0xfe and param >= start_address:
						branches.add(param)
					elif param < start_address:
						labels.append({ "address": param, "label": label })
			address += param_length
			if i < len(command["params"]) - 1:
				output += ","
		output += "\n"
		blobs.append(make_blob(command_address, output, address, label))
		if (command_id == 0xff or (is_infinite_loop(command_address) and
			not (is_infinite_loop(address) or rom[address] == 0xff))):
			blobs.append(make_blob(address, "\n"))
			break
	for branch in branches:
		blobs += dump_channel(start_address, sound_name, channel, prefix, is_sfx, branch)[0]
	return blobs, labels

def dump_sound(header, sound_name, prefix="", is_sfx=True):
	blobs = []
	blobs.append(make_blob(header, "{}{}:\n".format(prefix, sound_name)))
	labels = []
	final_channel = (rom[header] >> 6) + 1
	for i in range(final_channel):
		channel_num = (rom[header] & 0b1111) + 1
		start_address = get_pointer(header + 1)
		if i == 0:
			h = "\tchannel_count {}\n\tchannel {}, {:x}\n".format(final_channel, channel_num, start_address)
		else:
			h = "\tchannel {}, {:x}\n".format(channel_num, start_address)
		label = "{}{}_Ch{}".format(prefix, sound_name, channel_num)
		blobs.append(make_blob(header, h, header + 3, label))
		channel_blobs, channel_labels = dump_channel(start_address, sound_name, channel_num, prefix, is_sfx)
		blobs += channel_blobs
		labels += channel_labels
		header += 3
	blobs.append(make_blob(header, "\n"))
	return blobs, labels

def dump_all_sounds(header_pointer, sound_names, prefix="", is_sfx=True):
	blobs = []
	for sound_name in sound_names:
		header = get_pointer(header_pointer)
		blobs += dump_sound(header, sound_name, prefix, is_sfx)[0]
		header_pointer += 2
	return blobs
 
def fill_gap(start, end):
	output = ""
	for address in range(start, end):
		byte = rom[address]
		if byte == get_base_command_id(byte) and len(music_commands[byte]["params"]) == 0:
			output += "\t{}\n".format(music_commands[byte]["name"])
		else:
			output += "\tdb ${:x}\n".format(rom[address])
	output += "\n"
	return output

def sort_and_filter(blobs, extra_labels=[]):
	blobs.sort(key=lambda b: (b["start"], b["end"], len(b["output"])))
	filtered = []
	added_labels = []
	for label in extra_labels:
		if label["label"] not in added_labels and blobs[0]["start"] <= label["address"] < blobs[-1]["end"]:
			filtered.append(make_blob(label["address"], label["label"] + ":\n"))
			added_labels.append(label["label"])
	for blob, next in zip(blobs, blobs[1:]+[None]):
		if next and blob["start"] == next["start"] and blob["output"] == next["output"]:
			continue
		if blob["label"] is not None:
			label_pos = blob["output"].rfind(" ") + 1
			label_address = int(blob["output"][label_pos:], 16)
			blob["output"] = blob["output"][:label_pos] + blob["label"] + "\n"
			if "_branch_" in blob["label"] and blob["label"] not in added_labels and label_address >= blobs[0]["start"]:
				filtered.append(make_blob(label_address, blob["label"] + ":\n"))
				added_labels.append(blob["label"])
		if next and blob["end"] < next["start"] and get_bank(blob["end"]) == get_bank(next["start"]):
			blob["output"] += fill_gap(blob["end"], next["start"])
		filtered.append(blob)
	filtered.sort(key=lambda b: (b["start"], b["end"], len(b["output"])))
	return filtered

def write_all_sounds_to_file(path, file, blobs):
	import os
	try:
		print("Writing {}...".format(path + file))
		os.makedirs(path, exist_ok=True)
		sound_file = open(path + file, "w")
		for blob in blobs[:-1]:
			sound_file.write(blob["output"])
		sound_file.close()
	except IOError as ex:
		print("Error writing {}".format(path + file))
		print(ex)

def export_all_sounds(path, header_pointer, sound_names, prefix="", is_sfx=True):
	sounds = []
	labels = []
	for sound_name in sound_names:
		header = get_pointer(header_pointer)
		blobs, sound_labels = dump_sound(header, sound_name, prefix, is_sfx)
		sounds.append(blobs)
		labels += sound_labels
		header_pointer += 2
	for blobs, sound_name in zip(sounds, sound_names):
		blobs = sort_and_filter(blobs, labels)
		write_all_sounds_to_file(path, "{}.asm".format(sound_name.lower()), blobs)

def dump_all_songs(bank):
	export_all_sounds("audio/music/", bank * 0x4000 + 0x4ca2 % 0x4000, song_names[bank], "Music_", is_sfx=False)

def dump_all_cries(bank, address):
	blobs = dump_all_sounds(bank * 0x4000 + address % 0x4000, cry_names[bank], "Cry_")
	if bank == 0x0f:
		blobs += dump_channel(0x3f48f, "Unused_BankF", 5, "Cry_")[0]
		blobs += dump_channel(0x3f4aa, "Unused_BankF", 6, "Cry_")[0]
		blobs += dump_channel(0x3f4c5, "Unused_BankF", 8, "Cry_")[0]
	elif bank == 0x10:
		blobs += dump_channel(0x4361c, "Unused_Bank10", 5, "Cry_")[0]
		blobs += dump_channel(0x43637, "Unused_Bank10", 6, "Cry_")[0]
		blobs += dump_channel(0x43652, "Unused_Bank10", 8, "Cry_")[0]
	elif bank == 0x11:
		blobs += dump_channel(0x47394, "Unused_Bank11", 5, "Cry_")[0]
		blobs += dump_channel(0x473af, "Unused_Bank11", 6, "Cry_")[0]
		blobs += dump_channel(0x473ca, "Unused_Bank11", 8, "Cry_")[0]
	elif bank == 0x12:
		blobs += dump_channel(0x4acc5, "Unused_Bank12", 5, "Cry_")[0]
		blobs += dump_channel(0x4ace0, "Unused_Bank12", 6, "Cry_")[0]
		blobs += dump_channel(0x4acfb, "Unused_Bank12", 8, "Cry_")[0]
	elif bank == 0x13:
		blobs += dump_channel(0x4efb5, "Unused_Bank13", 5, "Cry_")[0]
		blobs += dump_channel(0x4efd0, "Unused_Bank13", 6, "Cry_")[0]
		blobs += dump_channel(0x4efeb, "Unused_Bank13", 8, "Cry_")[0]
	blobs = sort_and_filter(blobs)
	write_all_sounds_to_file("audio/", "cries_{:02x}.asm".format(bank), blobs)

def dump_all_sfx(bank, address):
	blobs = dump_all_sounds(bank * 0x4000 + address % 0x4000, sfx_names[bank], "Sfx_")
	blobs = sort_and_filter(blobs)
	write_all_sounds_to_file("audio/", "sfx_{:02x}.asm".format(bank), blobs)

def dump_all_drumkits(bank):
	blobs = []
	pointer_table = "Drumkits_Bank{:X}:\n".format(bank)
	pointer_tables = []
	drumkit_pointer = bank * 0x4000 + 0x4ba2 % 0x4000
	for drumkit in range(3):
		pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
		drumkit_table = "Drumkit{}_Bank{:X}:\n".format(drumkit, bank)
		if drumkit == 2:
			pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
			pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
			pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
		drum_pointer = get_pointer(drumkit_pointer + drumkit * 2)
		for drum in range(16):
			address = get_pointer(drum_pointer + drum * 2)
			drumkit_table += "\tdw {}\n".format(drum_names[bank][drumkit * 16 + drum])
			blobs += dump_channel(address, "{}".format(drum_names[bank][drumkit * 16 + drum]), 4)[0]
		drumkit_table += "\n"
		pointer_tables.append(drumkit_table)
	output = pointer_table + "\n" + "".join(pointer_tables)
	blobs.append(make_blob(drumkit_pointer, output, blobs[0]["start"]))
	for blob in blobs:
		if blob["output"].endswith("_Ch4:\n"):
			blob["output"] = blob["output"][:-6] + ":\n"
	blobs = sort_and_filter(blobs)
	write_all_sounds_to_file("audio/", "drumkits_{:02x}.asm".format(bank), blobs)

if __name__ == "__main__":
	dump_all_songs(0x0f)
	dump_all_songs(0x10)
	dump_all_songs(0x11)
	dump_all_songs(0x12)
	dump_all_songs(0x13)

	dump_all_cries(0x0f, 0x6f63)
	dump_all_cries(0x10, 0x70f0)
	dump_all_cries(0x11, 0x6e68)
	dump_all_cries(0x12, 0x6799)
	dump_all_cries(0x13, 0x6a89)

	dump_all_sfx(0x0f, 0x63ce)
	dump_all_sfx(0x10, 0x655b)
	dump_all_sfx(0x11, 0x62d3)
	dump_all_sfx(0x12, 0x5c04)
	dump_all_sfx(0x13, 0x5ef4)

	dump_all_drumkits(0x0f)
	dump_all_drumkits(0x10)
	dump_all_drumkits(0x11)
	dump_all_drumkits(0x12)
	dump_all_drumkits(0x13)
