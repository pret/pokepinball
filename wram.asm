
SECTION "WRAM Bank 0", WRAM0

wc000::
    ds $500

wcBottomMessageText:: ; 0xc500
    ds $b00

SECTION "WRAM Bank 1", WRAMX, BANK[1]

wOAMBuffer:: ; d000
    ; buffer for OAM data. Copied to OAM by DMA
    ds 4 * 40

    ds $160

wPaletteData:: ; 0xd200
    ; 16 palette definitions
    ds $100

    ds $16a

wScore:: ; 0xd46a
; player's current score
    ds 6

    ds $3c

wCurrentStage:: ; 0xd4ac
    ds 1

    ds 6

wBallXPos:: ; 0xd4b3
; x coordinate of the center of the pokeball
; little-endian word
; Most-significant byte is the pixel, and least-significant byte is fraction of a pixel
    ds 2

wBallYPos:: ; 0xd4b5
; y coordinate of the center of the pokeball
; little-endian word
; Most-significant byte is the pixel, and least-significant byte is fraction of a pixel
    ds 2

wPreviousBallXPos:: ; 0xd4b7
; x coordinate of the center of the pokeball in the previous frame
; little-endian word
; Most-significant byte is the pixel, and least-significant byte is fraction of a pixel
    ds 2

wPreviousBallYPos:: ; 0xd4b9
; y coordinate of the center of the pokeball in the previous frame
; little-endian word
; Most-significant byte is the pixel, and least-significant byte is fraction of a pixel
    ds 2

wBallXVelocity:: ; 0xd4bb
; little-endian word
; This is added to wBallXPos every frame.
    ds 2

wBallYVelocity:: ; 0xd4bd
; little-endian word
; This is added to wBallYPos every frame.
    ds 2

    ds 4

wBallSpin:: ; 0xd4c3
    ds 1
wBallRotation:: ; 0xd4c4
; wBallSpin is added to this every frame
    ds 1

    ds $1c

wInitialMapSelectionIndex:: ; 0xd4e1
; index to keep track of the spinning map selection at the start of a new game
    ds 1

    ds $e

wLeftMapMoveCounter:: ; 0xd4f0
; Diglett or Poliwag counter that counts to three to trigger a Map Move
    ds 1

    ds 1

wRightMapMoveCounter:: ; 0xd4f2
; Diglett or Psyduck counter that counts to three to trigger a Map Move\
    ds 1

    ds $57

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

    ds $43

wNumMonHits:: ; 0xd5c0
; Number of times the wild pokemon has been hit in Catch'em mode
    ds 1

    ds $17c

wDiglettStates:: ; 0xd73d
; Each diglett has a sprite state 1 - 5.
; The animation wiggles back and forth.
; $0 = diglett has been hit
; $1 = hiding in hole
; $2 = straight up
; $3 = leaning left
; $4 = straight up
; $5 = leaning right
; $6 = getting hit
    ds 31

wCurrentDiglett:: ; 0xd75c
; Keeps track of which diglett is being updated.
    ds 1

wDiglettsInitializedFlag:: ; 0xd75d
; bit 0 is set after all digletts have been initialized
    ds 1

wDiglettInitDelayCounter:: ; 0xd75e
; used to faciliate how fast the digletts are initialized
    ds 1

    ds $42

wLeftTiltCounter:: ; 0xd7a1
; Counts up to 3 and back down to time the left tilt animation
    ds 1
wLeftTiltReset:: ; 0xd7a2
; Set to $1 when the left tilt button has been held down long enough
    ds 1
wRightTiltCounter:: ; 0xd7a3
; Counts up to 3 and back down to time the right tilt animation
    ds 1
wRightTiltReset:: ; 0xd7a4
; Set to $1 when the right tilt button has been held down long enough
    ds 1
wUpperTiltCounter:: ; 0xd7a5
; Counts up to 3 and back down to time the upper tilt animation
    ds 1
wUpperTiltReset:: ; 0xd7a6
; Set to $1 when the upper tilt button has been held down long enough
    ds 1

wLeftTiltPushing:: ; 0xd7a7
; Set to $1 when the left tilt is in the first half of its animation
    ds 1
wRightTiltPushing:: ; 0xd7a8
; Set to $1 when the right tilt is in the first half of its animation
    ds 1
wUpperTiltPushing:: ; 0xd7a9
; Set to $1 when the upper tilt is in the first half of its animation
    ds 1

    ds 15

wFlipperCollision:: ; 0xd7b9
; Set to $1 when the ball is colliding with a flipper
    ds 1

    ds 9

wSubTileBallXPos:: ; 0xd7c3
    ds 1
wSubTileBallYPos:: ; 0xd7c4
    ds 1

wUpperLeftCollisionAttribute:: ; 0xd7c5
    ds 1
wLowerLeftCollisionAttribute:: ; 0xd7c6
    ds 1
wUpperRightCollisionAttribute:: ; 0xd7c7
    ds 1
wLowerRightCollisionAttribute:: ; 0xd7c8
    ds 1


    ds $30

wInGameMenuIndex:: ; 0xd7f9
    ds 1

    ds $f7

wCurrentScreen:: ; 0xd8f1
; The game is driven by state machines. This is the current screen.
    ds 1
wScreenState:: ; 0xd8f2
; The game is driven by state machines. This is the current state for the current screen.
    ds 1

    ds 22

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

    ds 2

wFieldSelectBlinkingBorderTimer:: ; 0xd912
; Number of frames to blink the field select screen border after the player chooses a field.
    ds 1

wSelectedFieldIndex:: ; d913
; $0 if player is hovering cursor over Red Stage
; $1 if player is hovering cursor over Blue Stage
    ds 1

wFieldSelectBlinkingBorderFrame:: ; 0xd914
; The blinking border's current animation frame.
    ds 1

    ds 5

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
wNumPokemonSeen:: ; 0xd9f9
    ds 2
wNumPokemonOwned:: ; 0xd9fb
    ds 2

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
