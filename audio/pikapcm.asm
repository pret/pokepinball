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
	ldh a, [rLY]
	and a
	jr nz, .asm_50010
	dec b
	jr nz, .asm_50010
	xor a
	ldh [rNR50], a
	ldh [rNR51], a
	ld a, $80
	ldh [rNR52], a
	xor a
	ldh [rNR30], a
	ld hl, wd84b
	ld c, $30
	ld b, $10
.asm_5002b
	ldh a, [$ff00+c]
	ld [hli], a
	ld a, $ff
	ldh [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_5002b
	ld a, $80
	ldh [rNR30], a
	ld a, $ff
	ldh [rNR31], a
	ld a, $20
	ldh [rNR32], a
	ld a, $ff
	ldh [rNR33], a
	ld a, $87
	ldh [rNR34], a
	ld a, $77
	ldh [rNR50], a
	ld a, $44
	ldh [rNR51], a
	pop hl
	call PlayPikachuPCM
	xor a
	ldh [rNR50], a
	ldh [rNR51], a
	ldh [rNR52], a
	ld hl, wd84b
	ld c, $30
	ld b, $10
.asm_50062
	ld a, [hli]
	ldh [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_50062
	ld a, $77
	ldh [rNR50], a
	ld a, $ff
	ldh [rNR51], a
	ld a, $80
	ldh [rNR52], a
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
	ldh [rNR32], a
	sla d
	ret

PlaySoundClipSample: ; 0x51fa0
	ld a, $3
.loop
	dec a
	jr nz, .loop
	ret
