LoadSavedData: ; 0xf0c
	call ValidateSaveData
	ret nc
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	scf
	ret

SaveData: ; 0xf1a
; Input: hl = data to save
;        bc = number of bytes to save
;        de = destination for saved data
	push bc
	push de
	push hl
.save
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .save
	pop hl
	pop de
	pop bc
	ld h, d
	ld l, e
	call SignData
	call ComputeChecksum
	call CreateBackupCopy
	ret

ValidateSaveData: ; 0xf34
	call ValidateSignature
	jr nc, .backup
	call ValidateChecksum
	jr nc, .backup
	ret

.backup
	add hl, bc
	inc hl
	inc hl
	inc hl
	inc hl
	call ValidateSignature
	ret nc
	call ValidateChecksum
	ret

CreateBackupCopy: ; 0xf4c
	push bc
	push hl
	push de
	inc bc
	inc bc
	inc bc
	inc bc
	ld d, h
	ld e, l
	add hl, bc
.loop
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop de
	pop hl
	pop bc
	ret

ValidateSignature: ; 0xf62
	push hl
	add hl, bc
	ld a, [hli]
	cp $4e
	jr nz, .asm_f71
	ld a, [hl]
	cp $54
	jr nz, .asm_f71
	scf
	jr .asm_f72

.asm_f71
	and a
.asm_f72
	pop hl
	ret

SignData: ; 0xf74
	push hl
	add hl, bc
	ld a, $4e
	ld [hli], a
	ld a, $54
	ld [hl], a
	pop hl
	ret

ValidateChecksum: ; 0xf7e
	push bc
	push de
	push hl
	inc bc
	inc bc
	ld de, $0000
.loop
	ld a, [hli]
	add e
	ld e, a
	jr nc, .asm_f8c
	inc d
.asm_f8c
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, [hli]
	cp e
	jr nz, .fail
	ld a, [hl]
	cp d
	jr nz, .fail
	scf
	jr .pass

.fail
	and a
.pass
	pop hl
	pop de
	pop bc
	ret

ComputeChecksum: ; 0xfa1
	push bc
	push de
	push hl
	inc bc
	inc bc
	ld de, $0000
.loop
	ld a, [hli]
	add e
	ld e, a
	jr nc, .nocarry
	inc d
.nocarry
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hl], a
	pop hl
	pop de
	pop bc
	ret
