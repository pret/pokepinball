FarSendSGBPackets: ; 0x12a1
; send 16*b bytes at a:hl via the joypad register
	ld [hROMBankBuffer], a
	ld a, [hLoadedROMBank]
	push af
	ld a, [hROMBankBuffer]
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ld a, [hl]
	and $7
	jr z, .quit
	ld b, a
	ld c, $0
.loop
	push bc
	ld a, $0
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	ld b, $10
.inner_loop
	ld e, $8
	ld a, [hli]
	ld d, a
.innermost_loop
	bit 0, d
	ld a, $10
	jr nz, .got_data
	ld a, $20
.got_data
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	rr d
	dec e
	jr nz, .innermost_loop
	dec b
	jr nz, .inner_loop
	ld a, $20
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	pop bc
	dec b
	jr z, .quit
	call SGBWait7000
	jr .loop

.quit
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

SGBWait7000: ; 0x12ec
	ld de, 7000
.asm_12ef
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .asm_12ef
	ret

InitSGB: ; 0x12f8
	ld a, BANK(Data_38010)
	ld hl, Data_38010
	call FarSendSGBPackets
	call SGBWait7000
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .asm_1346
	ld a, $20
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, $30
	ld [rJOYP], a
	ld a, $10
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, $30
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .asm_1346
	ld a, BANK(Data_38000)
	ld hl, Data_38000
	call FarSendSGBPackets
	call SGBWait7000
	and a
	ret

.asm_1346
	ld a, BANK(Data_38000)
	ld hl, Data_38000
	call FarSendSGBPackets
	call SGBWait7000
	scf
	ret

FarSendSGBPacket_BGMapRows: ; 0x1353
	ld [hROMBankBuffer], a
	ld a, [hLoadedROMBank]
	push af
	ld a, [hROMBankBuffer]
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	push af
	push hl
	ld a, $e4
	ld [rBGP], a
	ld de, $0010
	add hl, de
	ld de, vTilesSH ; tiles
	call LocalCopyData
	ld hl, vBGMap ; bgmap
	ld de, $000c
	ld a, $80
	ld c, $d
.row
	ld b, $14
.col
	ld [hli], a
	inc a
	dec b
	jr nz, .col
	add hl, de
	dec c
	jr nz, .row
	ld a, $81
	ld [rLCDC], a
	ld bc, $0005
	call SGBWait1750
	pop hl
	pop af
	call FarSendSGBPackets
	ld bc, $0006
	call SGBWait1750
	ld a, [hBGP]
	ld [rBGP], a
	ld a, [hLCDC]
	ld [rLCDC], a
	pop af
	ld [hLoadedROMBank], a
	ld [MBC5RomBank], a
	ret

SendSGBBorder: ; 0x13a8
	ld a, [hSGBFlag]
	and a
	ret z
	ld bc, $0078
	call SGBWait1750
	call SignalStartSGBBorderTransmission
	ld a, BANK(Data_3a9e6)
	ld hl, Data_3a9e6
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3a9f6)
	ld hl, Data_3a9f6
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3aa06)
	ld hl, Data_3aa06
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3aa16)
	ld hl, Data_3aa16
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3aa26)
	ld hl, Data_3aa26
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3aa36)
	ld hl, Data_3aa36
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3aa46)
	ld hl, Data_3aa46
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_3aa56)
	ld hl, Data_3aa56
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld bc, Data_39166 - Data_38156 - $10
	ld a, BANK(Data_38156)
	ld hl, Data_38156
	call FarSendSGBPacket_BGMapRows
	ld bc, $0004
	call SGBWait1750
	ld bc, Data_3a176 - Data_39166 - $10
	ld a, BANK(Data_39166)
	ld hl, Data_39166
	call FarSendSGBPacket_BGMapRows
	ld bc, $0004
	call SGBWait1750
	ld bc, Data_3a9e6 - Data_3a176 - $10
	ld a, BANK(Data_3a176)
	ld hl, Data_3a176
	call FarSendSGBPacket_BGMapRows
	ld bc, $0004
	call SGBWait1750
	ld bc, Data_38156 - Data_380a6 - $10
	ld a, BANK(Data_380a6)
	ld hl, Data_380a6
	call FarSendSGBPacket_BGMapRows
	ld bc, $0004
	call SGBWait1750
	ld bc, Data_3809a - Data_38030 - $10
	ld a, BANK(Data_38030)
	ld hl, Data_38030
	call FarSendSGBPacket_BGMapRows
	ld bc, $0004
	call SGBWait1750
	ld a, BANK(Data_38020)
	ld hl, Data_38020
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ret

SignalStartSGBBorderTransmission: ; 0x1489
	ld a, [hSGBFlag]
	and a
	ret z
	ld a, [hSGBInit]
	and a
	ret nz
	ld a, BANK(Data_3aa66)
	ld hl, Data_3aa66
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	ld a, $ff
	ld [hSGBInit], a
	ret

SGBNormal: ; 0x14a4
	ld a, [hSGBFlag]
	and a
	ret z
	ld bc, $0002
	call SGBWait1750
	ld a, [hSGBInit]
	and a
	ret z
	ld a, BANK(Data_3aa76)
	ld hl, Data_3aa76
	call FarSendSGBPackets
	ld bc, $0004
	call SGBWait1750
	xor a
	ld [hSGBInit], a
	ret
