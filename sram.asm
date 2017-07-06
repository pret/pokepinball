SECTION "SRAM 0", SRAM

saved_data: MACRO
\1:: ds \2
\1Signature:: ds 2
\1Checksum:: dw
\1Backup:: ds \2
\1BackupSignature:: ds 2
\1BackupChecksum:: dw
ENDM

	saved_data sHighScores, $82
	saved_data sPokedexFlags, $98
	saved_data sKeyConfigs, $e
	saved_data sSaveGame, $4c3
