; Unused -- load stage data for unused stage.
DoNothing_1805f: ; 0x1805f
	ret

DoNothing_18060: ; 0x18060
	ret

DoNothing_18061: ; 0x18061
	ret

Func_18062: ; 0x18062
; used by unused stage
	callba CheckRedStageLaunchAlleyCollision
	ret

DoNothing_1806d: ; 0x1806d
	ret

Func_1806e: ; 0x1806e
	callba ResolveRedStagePinballLaunchCollision
	ret
