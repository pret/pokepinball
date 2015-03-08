
SECTION "WRAM Bank 0", WRAM0

wc000::
    ds $500

wcBottomMessageText::
    ds $b00

SECTION "WRAM Bank 1", WRAMX, BANK[1]

wOAMBuffer:: ; d000
    ; buffer for OAM data. Copied to OAM by DMA
    ds 4 * 40

    ds $414

wBallXPos:: ; 0xd4b4
; x coordinate of the center of the pokeball
    ds 1
    ds 1
wBallYPos:: ; 0xd4b6
; y coordinate of the center of the pokeball
    ds 1
    ds 1

    ds $b

wBallSpin:: ; 0xd4c3
    ds 1
wBallRotation:: ; 0xd4c4
; wBallSpin is added to this every frame
    ds 1

    ds $85

wCurrentMap:: ; 0xd54a
; Current map during play. See map_constants.asm
    ds 1

    ds $2e
    ; d54b might be the current mode (catchEm, evolution, map change, etc.)

wCurrentMon:: ; 0xd579
; Current mon id for CatchEm Mode. Might also be used for Evolution Mode.
; It stores (mon id - 1), which is annoying.
    ds 1

wTimerSeconds:: ; 0xd57a
    ds 1
wTimerMinutes:: ; 0xd57b
    ds 1
wTimerFrames::  ; 0xd57c
    ds 1

    ds $38c

wTitleScreenCursorSelection:: ; 0xd909
; 0 = Game Start
; 1 = PokeDex
; 2 = Option
    ds 1

wTitleScreenGameStartCursorSelection:: ; 0xd90a
; 0 = New Game
; 1 = Continue
    ds 1

    ds 1

wTitleScreenBlinkAnimationFrame:: ; 0xd90c
; Pikachu's blinking animation is looped through frames. This keeps track of the current frame.
    ds 1

wTitleScreenBlinkAnimationCounter:: ; 0xd90d
; Counts down. When it hits 0, wTitleScreenBlinkAnimationFrame is incremented.
    ds 1

wTitleScreenBouncingBallAnimationFrame:: ; 0xd90e
; The bouncing Pokeball on the title screen has a 6-frame animation. This keeps track of the current frame.
    ds 1

wTitleScreenPokeballAnimationCounter:: ; 0xd90f
    ds 1

    ds 10

wSoundTestCurrentBackgroundMusic:: ; d91a
    ds 1
wSoundTextCurrentSoundEffect:: ; 0xd91b
    ds 1

    ds 44

wKeyConfigs:: ; 0xd948
; each function map to two joypad buttons (see joy_constants.asm)
wKeyConfigBallStart:: ; 0xd948
    ds 2
wKeyConfigLeftFlipper:: ; 0xd94a
    ds 2
wKeyConfigRightFlipper:: ; 0xd94c
    ds 2
wKeyConfigLeftTilt:: ; 0xd94e
    ds 2
wKeyConfigRightTilt:: ; 0xd950
    ds 2
wKeyConfigUpperTilt:: ; 0xd952
    ds 2
wKeyConfigMenu:: ; 0xd954
    ds 2

    ds 12

wPokedexFlags:: ; 0xd962
; Each pokemon is represented by one byte in the normal Pokedex order
;     byte == 0: mon hasn't been seen
;     byte == 1: mon has been seen
;     byte >= 2: mon has been captured
    ds 151

    ds 4 ; TODO: these change when byte in wPokedexFlags change

wRedHighScores:: ; 0xd9fd
wRedHighScore1Points:: ; 0xd9fd
    ds 6
wRedHighScore1Name:: ; 0xda03
    ds 3
    ds 4

wRedHighScore2Points:: ; 0xda0a
    ds 6
wRedHighScore2Name:: ; 0xda10
    ds 3
    ds 4

wRedHighScore3Points:: ; 0xda17
    ds 6
wRedHighScore3Name:: ; 0xda1d
    ds 3
    ds 4

wRedHighScore4Points:: ; 0xda24
    ds 6
wRedHighScore4Name:: ; 0xda2a
    ds 3
    ds 4

wRedHighScore5Points:: ; 0xda31
    ds 6
wRedHighScore5Name:: ; 0xda37
    ds 3
    ds 4

wBlueHighScores:: ; 0xda3e
wBlueHighScore1Points:: ; 0xda3e
    ds 6
wBlueHighScore1Name:: ; 0xda44
    ds 3
    ds 4

wBlueHighScore2Points:: ; 0xda4b
    ds 6
wBlueHighScore2Name:: ; 0xda52
    ds 3
    ds 4

wBlueHighScore3Points:: ; 0xda58
    ds 6
wBlueHighScore3Name:: ; 0xda5e
    ds 3
    ds 4

wBlueHighScore4Points:: ; 0xda65
    ds 6
wBlueHighScore4Name:: ; 0xda6b
    ds 3
    ds 4

wBlueHighScore5Points:: ; 0xda72
    ds 6
wBlueHighScore5Name:: ; 0xda78
    ds 3
    ds 4
