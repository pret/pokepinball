SECTION "SRAM 0", SRAM

saved_data: MACRO
\1:: ds \2
\1Signature:: ds 2
\1Checksum:: dw
\1Backup:: ds \2
\1BackupSignature:: ds 2
\1BackupChecksum:: dw
ENDM

	saved_data sHighScores, $82   ; a000
	saved_data sPokedexFlags, $98 ; a10c
	saved_data sKeyConfigs, $e    ; a244
	saved_data sSaveGame, $4c3    ; a268
; abf6

	ds $409
sRNGMod:: ; afff
