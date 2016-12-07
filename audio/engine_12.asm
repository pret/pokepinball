	dr $48000, $48ca2

SongHeaderPointers12: ; 0x48ca2
	dw Music_Nothing12
	dw Music_MewtwoStage
	dw Music_Options
	dw Music_FieldSelect
	dw Music_MeowthStage
; 0x48cac

INCLUDE "audio/music/nothing12.asm"
INCLUDE "audio/music/mewtwostage.asm"
INCLUDE "audio/music/options.asm"
INCLUDE "audio/music/fieldselect.asm"
INCLUDE "audio/music/meowthstage.asm"

	dr $49c04, $4c000
