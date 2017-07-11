SaveGame: ; 0xda05
	ld de, $0000
	call PlaySong
	ld bc, $0004
	call AdvanceFrames
	call FadeOut
	ld a, [wUpdateAudioEngineUsingTimerInterrupt]
	and a
	call nz, ToggleAudioEngineUpdateMethod
	call DisableLCD
	ld hl, hSTAT
	res 6, [hl]
	ld hl, rIE
	res 1, [hl]
	xor a
	ld [wDrawBottomMessageBox], a
	ld a, SCREEN_TITLESCREEN
	ld [wCurrentScreen], a
	xor a
	ld [wScreenState], a
	ret
