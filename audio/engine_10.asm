	dr $40000, $40ca2

SongHeaderPointers10: ; 0x40ca2
	dw Music_Nothing10
	dw Music_RedField
	dw Music_CatchEmBlue
	dw Music_HurryUpBlue
	dw Music_HiScore
	dw Music_GameOver
; 0x40cae

INCLUDE "audio/music/nothing10.asm"
INCLUDE "audio/music/redfield.asm"
INCLUDE "audio/music/catchemblue.asm"
INCLUDE "audio/music/hiscore.asm"
INCLUDE "audio/music/gameover.asm"
INCLUDE "audio/music/hurryupblue.asm"

	dr $4255b, $44000
