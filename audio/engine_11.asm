	dr $44000, $44ca2

SongHeaderPointers11: ; 0x44ca2
	dw Music_Nothing11
	dw Music_WhackTheDiglett
	dw Music_WhackTheDugtrio
	dw Music_SeelStage
	dw Music_Title
; 0x44cac

INCLUDE "audio/music/nothing11.asm"
INCLUDE "audio/music/whackthediglett.asm"
INCLUDE "audio/music/whackthedugtrio.asm"
INCLUDE "audio/music/seelstage.asm"
INCLUDE "audio/music/title.asm"

	dr $462d3, $48000
