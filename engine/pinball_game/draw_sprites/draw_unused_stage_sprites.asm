DrawSprites_UnusedStageNoFlippers: ; 0x18079
	callba DrawPinball
	ret

DrawSprites_UnusedStageWithFlippers: ; 0x18084
	callba DrawFlippers
	callba DrawPinball
	ret
