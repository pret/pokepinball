	dr $4c000, $4cca2

SongHeaderPointers13: ; 0x4cca2
	dw Music_Nothing13
	dw Music_EndCredits
	dw Music_NameEntry
; 0x4cca8

INCLUDE "audio/music/nothing13.asm"
INCLUDE "audio/music/endcredits.asm"
INCLUDE "audio/music/nameentry.asm"

	dr $4def4, $50000
