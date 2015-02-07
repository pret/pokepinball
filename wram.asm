
SECTION "WRAM Bank 0", WRAM0

wc000::
	ds 4096

SECTION "WRAM Bank 1", WRAMX, BANK[1]

wOAMBuffer:: ; d000
	; buffer for OAM data. Copied to OAM by DMA
	ds 4 * 40
