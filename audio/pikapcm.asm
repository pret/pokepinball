PlayPikachuSoundClip: ; 0x50000
; Plays the pcm (pulse-code modulation) sound clip of one of the pikachu noises.
	sla a
	ld c, a
	ld b, $0
	ld hl, PikachuSoundClipPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	di
	ld b, $4
.asm_50010
	ld a, [rLY]
	and a
	jr nz, .asm_50010
	dec b
	jr nz, .asm_50010
	xor a
	ld [rNR50], a
	ld [rNR51], a
	ld a, $80
	ld [rNR52], a
	xor a
	ld [rNR30], a
	ld hl, wd84b
	ld c, $30
	ld b, $10
.asm_5002b
	ld a, [$ff00+c]
	ld [hli], a
	ld a, $ff
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_5002b
	ld a, $80
	ld [rNR30], a
	ld a, $ff
	ld [rNR31], a
	ld a, $20
	ld [rNR32], a
	ld a, $ff
	ld [rNR33], a
	ld a, $87
	ld [rNR34], a
	ld a, $77
	ld [rNR50], a
	ld a, $44
	ld [rNR51], a
	pop hl
	call PlayPikachuPCM
	xor a
	ld [rNR50], a
	ld [rNR51], a
	ld [rNR52], a
	ld hl, wd84b
	ld c, $30
	ld b, $10
.asm_50062
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_50062
	ld a, $77
	ld [rNR50], a
	ld a, $ff
	ld [rNR51], a
	ld a, $80
	ld [rNR52], a
	ei
	ret

PikachuSoundClipPointers: ; 0x50076
	dw PikachuBillboardBonusSoundClip
	dw PikachuThundershockSoundClip

PikachuBillboardBonusSoundClip:  ; 0x5007a
	dw $caf  ; length of the pcm data (todo: there is probably a way to do this dynamically with rgbds)
	INCBIN "audio/sound_clips/pi_ka_chu.pcm"

	db $1f  ; unused

PikachuThundershockSoundClip:  ; 0x50d2c
	dw $1227  ; length of the pcm data (todo: there is probably a way to do this dynamically with rgbds)
	INCBIN "audio/sound_clips/piiiiikaaaa.pcm"

	db $f0, $00, $00  ; unused

PlayPikachuPCM: ; 0x51f56
; Plays the audio PCM at [hl]
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	; bc = number of bytes in the sound clip's PCM (pulse-code modulation)
.loop
	ld a, [hli]
	ld d, a
	ld a, $3
.playSingleSample
	dec a
	jr nz, .playSingleSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	call PlaySoundClipSample
	call LoadNextSoundClipSample
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

LoadNextSoundClipSample: ; 0x51f94
	ld a, d
	and $80
	srl a
	srl a
	ld [rNR32], a
	sla d
	ret

PlaySoundClipSample: ; 0x51fa0
	ld a, $3
.loop
	dec a
	jr nz, .loop
	ret
