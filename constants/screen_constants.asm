; See wCurrentScreen in wram.asm

; unreachable debug menu, which allows selecting DMG or Game Boy Color during boot
SCREEN_SELECT_GAMEBOY_TARGET   EQU $0

SCREEN_ERASE_ALL_DATA  EQU $1
SCREEN_COPYRIGHT       EQU $2
SCREEN_TITLESCREEN     EQU $3
SCREEN_PINBALL_GAME    EQU $4
SCREEN_POKEDEX         EQU $5
SCREEN_OPTIONS         EQU $6
SCREEN_HIGH_SCORES     EQU $7
SCREEN_FIELD_SELECT    EQU $8
