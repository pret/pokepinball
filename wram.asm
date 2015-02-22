
SECTION "WRAM Bank 0", WRAM0

wc000::
	ds $500

wcBottomMessageText::
	ds $b00

SECTION "WRAM Bank 1", WRAMX, BANK[1]

wOAMBuffer:: ; d000
	; buffer for OAM data. Copied to OAM by DMA
	ds 4 * 40

	ds $87a

wSoundTestCurrentBackgroundMusic:: ; d91a
	ds 1
wSoundTextCurrentSoundEffect:: ; 0xd91b
	ds 1
