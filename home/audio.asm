
PlaySong: ; 0x490
	ld a, [hLoadedROMBank]
	push af
	ld a, [wCurrentSongBank]
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ld a, e
	ld [wStageSong], a
	ld a, [wCurrentSongBank]
	ld [wStageSongBank], a
	call PlaySong_BankF  ; this function is replicated in multiple banks.
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

PlaySoundEffect: ; 0x4af
; u8 d = duration
; u8 e = SFX ID
	ld a, [wdead]
	and a
	ret nz
	ld a, [wSFXTimer]
	and a
	jr z, .asm_4bd
	ld a, d
	and a
	ret z
.asm_4bd
	ld a, d
	ld [wSFXTimer], a
	ld d, $0
	ld a, [hLoadedROMBank]
	push af
	ld a, [wCurrentSongBank]
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	call PlaySoundEffect_BankF  ; this function is replicated in multiple banks
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

PlaySFXIfNoneActive: ; 0x4d8
	push bc
	push de
	push hl
	ld a, [wChannel4 + 2]
	ld hl, wChannel5 + 2
	or [hl]
	ld hl, wChannel6 + 2
	or [hl]
	and $1
	call z, PlaySoundEffect
	pop hl
	pop de
	pop bc
	ret

PlayCry: ; 0x4ef
; Plays a Pokemon cry.
; Input:  e = mon id
	ld a, [hLoadedROMBank]
	push af
	ld a, [wCurrentSongBank]
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	call PlayCry_BankF  ; this function is replicated in multiple banks
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

UpdateSFX: ; 0x504
	ld a, [hLoadedROMBank]
	push af
	ld a, [wCurrentSongBank]
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	call Func_3c180
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ld a, [wd801]
	inc a
	ld [wd801], a
	and $3
	ret nz
	ld a, [wSFXTimer]
	and a
	ret z
	dec a
	ld [wSFXTimer], a
	ret

SetSongBank: ; 0x52c
	di
	ld [wCurrentSongBank], a
	ei
	ret
