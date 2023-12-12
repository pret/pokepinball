LoadBallGfx: ; 0xdcc3
	xor a
	ld [wBallSize], a
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeBall
	ld a, Bank(PinballPokeballGfx)
	ld hl, PinballPokeballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notPokeBall
	cp ULTRA_BALL
	jr nc, .notGreatBall
	ld a, Bank(PinballGreatballGfx)
	ld hl, PinballGreatballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notGreatBall
	cp MASTER_BALL
	jr nc, .notUltraBall
	ld a, Bank(PinballUltraballGfx)
	ld hl, PinballUltraballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notUltraBall
	ld a, Bank(PinballMasterballGfx)
	ld hl, PinballMasterballGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

LoadMiniBallGfx: ; 0xdd12
	ld a, $1
	ld [wBallSize], a
	ld a, [wBallType]
	cp GREAT_BALL
	jr nc, .notPokeBall
	ld a, Bank(PinballPokeballMiniGfx)
	ld hl, PinballPokeballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notPokeBall
	cp ULTRA_BALL
	jr nc, .notGreatBall
	ld a, Bank(PinballGreatballMiniGfx)
	ld hl, PinballGreatballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notGreatBall
	cp MASTER_BALL
	jr nc, .notUltraBall
	ld a, Bank(PinballUltraballMiniGfx)
	ld hl, PinballUltraballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

.notUltraBall
	ld a, Bank(PinballMasterballMiniGfx)
	ld hl, PinballMasterballMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret

LoadSuperMiniPinballGfx: ; 0xdd62
; Loads the mini pinball graphics, which are used when entering the Slot or Ditto caves.
	ld a, $2
	ld [wBallSize], a
	ld a, $2a
	ld hl, PinballBallSuperMiniGfx
	ld de, vTilesOB tile $40
	ld bc, $0200
	call LoadOrCopyVRAMData
	ret
