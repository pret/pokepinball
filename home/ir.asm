InitializeIRTimingData: ; 0x1be3
	ld a, $c0
	ldh [rRP], a
	ld a, $ff
	ld [wd8ea], a
	xor a
	ld b, a
.loop
	inc a
	jr nz, .loop
	inc b
	jr nz, .loop
	ld hl, wd8eb
	ldh a, [rKEY1]
	bit 7, a
	jr z, .normalSpeed
	ld [hl], $e
	inc hl
	ld [hl], $12
	inc hl
	ld [hl], $8
	inc hl
	ld [hl], $c
	inc hl
	ld [hl], $c
	ret

.normalSpeed
	ld [hl], $6
	inc hl
	ld [hl], $8
	inc hl
	ld [hl], $2
	inc hl
	ld [hl], $4
	inc hl
	ld [hl], $5
	ret

WaitForIRSignalHigh: ; 0x1c1b
	inc d
	ret z
	ldh a, [$ff00+c]
	bit 1, a
	jr z, WaitForIRSignalHigh
	ret

WaitForIRSignalLow: ; 0x1c23
	inc d
	ret z
	ldh a, [$ff00+c]
	bit 1, a
	jr nz, WaitForIRSignalLow
	ret

SendIRPulse: ; 0x1c2b
	ld a, $c1
	ldh [$ff00+c], a
.asm_1c2e
	dec d
	jr nz, .asm_1c2e
	ret

SendIRGap: ; 0x1c32
	ld a, $c0
	ldh [$ff00+c], a
.asm_1c35
	dec d
	jr nz, .asm_1c35
	ret

EstablishIRConnection:
	xor a
	ldh [hNumFramesSinceLastVBlank], a
	ld a, $1
	ld [wd8e9], a
.asm_1c41
	ld b, $2
	ld c, rRP % $100
	ldh a, [$ff00+c]
	and b
	jr z, HandleIRReceiveHandshake
	ldh a, [hNumFramesSinceLastVBlank]
	and a
	jr nz, HandleIRSendHandshake
	jr .asm_1c41

HandleIRReceiveHandshake: ; 0x1c50
	ld a, $1
	ld [wd8e9], a
	ld b, $1a
	ld c, rRP % $100
	ld d, $0
	ld e, d
	call WaitForIRSignalLow
	ld a, d
	and a
	jp z, SetIRErrorState
	ld d, e
	call WaitForIRSignalHigh
	ld a, d
	and a
	jp z, SetIRErrorState
	call WaitForIRSignalLow
	ld a, d
	and a
	jp z, SetIRErrorState
	call WaitForIRSignalHigh
	ld a, d
	and a
	jp z, SetIRErrorState
	cp $8
	jp c, SetIRErrorState
	cp $2a
	jp nc, SetIRErrorState
	ld a, $0
	ld [wd8ea], a
	ld d, b
	call SendIRGap
	ld d, b
	call SendIRPulse
	ld d, b
	call SendIRGap
	ld d, b
	call SendIRPulse
	ld d, b
	call SendIRGap
	ret

HandleIRSendHandshake: ; 0x1ca1
	ld a, $2
	ld [wd8e9], a
	ld b, $1a
	ld c, rRP % $100
	ld d, b
	ld e, $0
	call SendIRGap
	ld d, b
	call SendIRPulse
	ld d, b
	call SendIRGap
	ld d, b
	call SendIRPulse
	ld d, b
	call SendIRGap
	ld d, e
	call WaitForIRSignalLow
	ld a, d
	and a
	jp z, SetIRErrorState
	ld d, e
	call WaitForIRSignalHigh
	ld a, d
	and a
	jp z, SetIRErrorState
	ld d, e
	call WaitForIRSignalLow
	ld a, d
	and a
	jp z, SetIRErrorState
	ld d, e
	call WaitForIRSignalHigh
	ld a, d
	and a
	jp z, SetIRErrorState
	ld d, $1a
	call SendIRGap
	ld a, $0
	ld [wd8ea], a
	ret

DisableIRCommunication:
	xor a
	ldh [rRP], a
	ld a, $ff
	ld [wd8ea], a
	ret

TransmitIRData: ; 0x1cf8
	xor a
	ld [wd8e4], a
	ld [wd8e5], a
	push hl
	push bc
	ld hl, wd8e6
	ld a, $5a
	ld [hli], a
	ld [hl], b
	dec hl
	ld b, $2
	ld d, $1e
	call SendIRGap
	call TransmitIRDataBytes
	pop bc
	pop hl
	call IRTimingNop
	call TransmitIRDataBytes
	ld a, [wd8e4]
	ld [wd8e6], a
	ld a, [wd8e5]
	ld [wd8e7], a
	ld hl, wd8e6
	ld b, $2
	call TransmitIRDataBytes
	ld hl, wd8ea
	ld b, $1
	call ReceiveIRDataBytes
	ld a, [wd8e6]
	ld [wd8e4], a
	ld a, [wd8e7]
	ld [wd8e5], a
	ret

TransmitIRDataBytes: ; 0x1d44
	ld a, [wd8ea]
	cp $0
	ret nz
	ld c, rRP % $100
	ld d, $16
	call SendIRPulse
	ld d, $16
	call SendIRGap
	ld a, b
	cpl
	ld b, a
.asm_1d59
	inc b
	jr z, .asm_1dae
	ld a, $8
	ld [wd8e3], a
	ld a, [hli]
	ld e, a
	ld a, [wd8e4]
	add e
	ld [wd8e4], a
	jr nc, .asm_1d75
	ld a, [wd8e5]
	inc a
	ld [wd8e5], a
	jr .asm_1d78

.asm_1d75
	call IRTimingNop
.asm_1d78
	ld a, e
	rlca
	ld e, a
	jr nc, .asm_1d8d
	ld a, [wd8eb]
	ld d, a
	call SendIRPulse
	ld a, [wd8ec]
	ld d, a
	call SendIRGap
	jr .asm_1d9b

.asm_1d8d
	ld a, [wd8ed]
	ld d, a
	call SendIRPulse
	ld a, [wd8ee]
	ld d, a
	call SendIRGap
.asm_1d9b
	ld a, [wd8e3]
	dec a
	ld [wd8e3], a
	jr z, .asm_1dac
	call IRTimingDelay
	call IRTimingDelay
	jr .asm_1d78

.asm_1dac
	jr .asm_1d59

.asm_1dae
	call IRTimingNop
	call IRTimingNop
	call IRTimingDelay
	ld d, $16
	call SendIRPulse
	ld d, $16
	call SendIRGap
	ret

SetIRErrorState: ; 0x1dc2
	ld a, $2
	ld [wd8ea], a
	ret

SetIRChecksumError:
	ld a, [wd8ea]
	or $1
	ld [wd8ea], a
	ret

SetIRProtocolError: ; 0x1dd1
	ld a, [wd8ea]
	or $4
	ld [wd8ea], a
	ret

ReceiveIRData: ; 0x1dda
	xor a
	ld [wd8e4], a
	ld [wd8e5], a
	push hl
	ld hl, wd8e6
	ld b, $2
	call ReceiveIRDataBytes
	ld a, [wd8e7]
	ld [wd8e8], a
	ld b, a
	pop hl
	ld a, [wd8e6]
	cp $5a
	jp nz, SetIRProtocolError
	call ReceiveIRDataBytes
	ld a, [wd8e4]
	ld d, a
	ld a, [wd8e5]
	ld e, a
	push de
	ld hl, wd8e6
	ld b, $2
	call ReceiveIRDataBytes
	pop de
	ld hl, wd8e6
	ld a, [hli]
	xor d
	ld b, a
	ld a, [hl]
	xor e
	or b
	jr z, .asm_1e22
	ld a, [wd8ea]
	or $1
	ld [wd8ea], a
.asm_1e22
	push de
	ld hl, wd8ea
	ld b, $1
	call TransmitIRDataBytes
	pop de
	ld a, d
	ld [wd8e4], a
	ld a, e
	ld [wd8e5], a
	ld a, [wd8e8]
	cp $82
	ret z
	ret

ReceiveIRDataBytes: ; 0x1e3b
	ld a, [wd8ea]
	cp $0
	ret nz
	ld c, rRP % $100
	ld d, $0
	call WaitForIRSignalLow
	ld a, d
	or a
	jp z, SetIRErrorState
	ld d, $0
	call WaitForIRSignalHigh
	ld a, d
	or a
	jp z, SetIRErrorState
	ld d, $0
	call WaitForIRSignalLow
	ld a, d
	or a
	jp z, SetIRErrorState
	call IRTimingDelay
	call IRTimingDelay
	push af
	pop af
	ld a, b
	cpl
	ld b, a
.asm_1e6c
	inc b
	jr z, .asm_1eb9
	ld a, $8
	ld [wd8e3], a
.asm_1e74
	ld d, $0
	call WaitForIRSignalHigh
	call WaitForIRSignalLow
	ld a, [wd8ef]
	cp d
	jr nc, .asm_1e88
	ld a, e
	set 0, a
	ld e, a
	jr .asm_1e8c

.asm_1e88
	ld a, e
	res 0, a
	ld e, a
.asm_1e8c
	ld a, [wd8e3]
	dec a
	ld [wd8e3], a
	jr z, .asm_1ea0
	ld a, e
	rlca
	ld e, a
	call IRTimingDelay
	call IRTimingDelay
	jr .asm_1e74

.asm_1ea0
	ld a, e
	ld [hli], a
	ld a, [wd8e4]
	add e
	ld [wd8e4], a
	jr nc, .asm_1eb4
	ld a, [wd8e5]
	inc a
	ld [wd8e5], a
	jr .asm_1eb7

.asm_1eb4
	call IRTimingNop
.asm_1eb7
	jr .asm_1e6c

.asm_1eb9
	ld d, $0
	call WaitForIRSignalHigh
	ld a, d
	and a
	jp z, SetIRErrorState
	ld d, $11
	call SendIRGap
	ret

TransmitIRPacket:
	ld b, $00
	jp TransmitIRData

ReceiveIRPacket:
	ld b, $00
	jp ReceiveIRData

IRTimingNop: ; 0x1ed3
	ret

IRTimingDelay: ; 0x1ed4
	jr z, .asm_1ed6
.asm_1ed6
	jr nz, .asm_1ed8
.asm_1ed8
	ret
