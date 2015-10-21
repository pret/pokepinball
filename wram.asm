
SECTION "WRAM Bank 0", WRAM0

wc000::
    ds $400

wMonAnimatedCollisionMask:: ; 0xc400
    ds $80

    ds $80

wcBottomMessageText:: ; 0xc500
    ds $200

wStageCollisionMap:: ; 0xc700
; Collision data for each tile for the current stage.
    ds $300

    ds $600

SECTION "WRAM Bank 1", WRAMX, BANK[1]

wOAMBuffer:: ; d000
    ; buffer for OAM data. Copied to OAM by DMA
    ds 4 * 40

    ds $160

wPaletteData:: ; 0xd200
    ; 16 palette definitions
    ds $100

wPartyMons:: ; 0xd300
; List of pokemon in the player's party.
; When a pokemon is caught, it's appended to this list.
; When a pokemon is evolved, the pokemon's evolution replaces its entry in the list.
    ds $160

wNumPartyMons:: ; ; 0xd460
; Number of pokemon in the wPartyMons list.
    ds 1

    ds 9

wScore:: ; 0xd46a
; player's current score
    ds 6

    ds $e

wBallType:: ; 0xd47e
; PokeBall, Great Ball, Ultra Ball, or Master Ball
    ds 1
wBallTypeCounter:: ; 0xd47f
; two-byte counter that represents how many frames remain until the Ball uprade goes down to the next level.
    ds 2
wBallTypeBackup:: ; 0xd481
; Holds the ball type during bonus stages, since they always use a regular pokeball.
    ds 1

    ds $1f

wBallSaverIconOn:: ; 0xd4a1
; The blue Ball Saver icon is illuminated when this byte is non-zero.
    ds 1

    ds 1

wBallSaverTimerFrames:: ; 0xd4a3
; Count the number of frames until wBallSaverTimerSeconds should be decremented
    ds 1
wBallSaverTimerSeconds:: ; 0xd4a4
; Remaining seconds for Ball Saver
    ds 1

    ds 1

wBallSaverTimerFramesBackup:: ; 0xd4a6
; Used to store a backup of wBallSaverTimerFrames
    ds 1
wBallSaverTimerSecondsBackup:: ; 0xd4a7
; Used to store a backup of wBallSaverTimerSeconds
    ds 1


    ds 4

wCurrentStage:: ; 0xd4ac
    ds 1

    ds 2

wStageCollisionState:: ; 0xd4af
; Stores the current collision state id for the stage
; For example, the Red stage can have different collision states when
; the Ditto lane is open, or when there is a wall above the Voltorbs.
    ds 1

    ds 3

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

    ds $d

    ds 1

wLeftMapMoveCounter:: ; 0xd4f0
; Diglett or Poliwag counter that counts to three to trigger a Map Move
    ds 1

    ds 1

wRightMapMoveCounter:: ; 0xd4f2
; Diglett or Psyduck counter that counts to three to trigger a Map Move\
    ds 1

wLeftMapMoveDiglettAnimationCounter:: ; 0xd4f3
; Counter that loops to control the left-side map move diglett head bobbing animation
    ds 1
wLeftMapMoveDiglettFrame:: ; 0xd4f4
; Contains frame for map move diglett head bobbing animation
    ds 1
wRightMapMoveDiglettAnimationCounter :: ; 0xd4f5
; Counter that loops to control the left-side map move diglett head bobbing animation
    ds 1
wRightMapMoveDiglettFrame:: ; 0xd4f6
; Contains frame for map move diglett head bobbing animation
    ds 1

    ds $38

wIndicatorStates:: ; 0xd52f
; Each byte represents the status of each possible indicator on the stage.
; An indicator is a blinking icon telling the player to hit the pinball in
; a certain area.  For example, when the Cloyster can be entered in the Blue
; Stage, the blue right arrow will starting blinking in the bottom half of that
; stage.
    ds $13

wLeftAlleyTrigger:: ; 0xd542
; Set to $1 when ball passes over the bottom-left corner of the Blue/Red field top screen
; It's used to determine if the Ball was hit up the left side alley.
    ds 1
wLeftAlleyCount:: ; 0xd543
; Increments when the Ball travels up the left alley.
; When the count is 3, evolution mode can be triggered.
    ds 1
wRightAlleyTrigger:: ; 0xd544
; Set to $1 when Ball passes over the bottom-right corner of the Blue/Red field top screen
; It's used to determine if the Ball was hit up the right side alley.
    ds 1
wRightAlleyCount:: ; 0xd545
; Increments when the Ball travels up the right alley.
; When the count is 2, Catch 'Em Mode can be triggered.
; If the count is 3, the current map's rare pokemon will be used for Catch 'Em Mode.
    ds 1
wSecondaryLeftAlleyTrigger:: ; 0xd546
; Set to $1 when Ball passes over the bottom of the skinny alley between the left alley and Staryu button on the Red Field top screen.
; It's used to determine if the Ball was hit up the Red Stage's secondary left-side alley.
    ds 1

    ds 3

wCurrentMap:: ; 0xd54a
; Current map during play. See map_constants.asm
    ds 1

wInSpecialMode:: ; 0xd54b
; Set to non-zero when things like Catch 'em Mode or Map Move mode start.
    ds 1

    ds 4

wSpecialMode:: ; 0xd550
; wInSpecialMode must be non-zero to activate this.
; 0 = Catch Em Mode
; 1 = Evolution Mode
; 2 = Map Move Mode
    ds 1

    ds 1

wCurrentEvolutionMon:: ; 0xd552
; Current mon id for Evolution Mode.
; It stores (mon id - 1).
    ds 1
wCurrentEvolutionType:: ; 0xd553
; Evolution type for the current mon in Evolution Mode.
; See evolution_type_constants.asm
    ds 1

    ds 7

wRareMonsFlag:: ; 0xd55b
; Gets set to $8 when the rare mons should be used for catch 'em mode.  $8 is then doubled to add $10 to the base address of the map's wild mons table.
    ds 1

    ds $1d

wCurrentCatchEmMon:: ; 0xd579
; Current mon id for CatchEm Mode.
; It stores (mon id - 1).
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

    ds $6e

; Number of times the Mewtwo Bonus stage has been defeated.
; Counts up at most to 2, and is reset if Mew is encountered.
wNumMewtwoBonusCompletions:: ; 0xd62f
    ds 1

    ds $e

wBlueStageForceFieldDirection:: ; 0xd63e
; Controls the direction of the arrow force field in between Cloyster and Slowpoke in the Blue Stage.
; $0 = up
; $1 = right
; $2 = down
; $3 = left
    ds 1

    ds $aa

wMeowthAnimationFrameCounter:: ; 0xd6e9
; Counts down. When it hits 0, the next animation frame happens.
    ds 1

    ds 3

wMeowthXPosition:: ; 0xd6ed
    ds 1
wMeowthYPosition:: ; 0xd6ee
    ds 1

    ds 1

wMeowthXMovement:: ; 0xd6f0
; Used to move meowth horizontally.
; Value is $01 when moving right.
; Value is $ff when moving left.
    ds 1
wMeowthYMovement:: ; 0xd6f1
; Used to move meowth vertically.
; Value is $01 when moving down.
; Value is $ff when moving up.
    ds 1

    ds $1d

wMeowthStageBonusCounter:: ; 0xd70f
; Keeps track of how many bonus points you get from collecting a coin.
; The bonus increases by 1 each time you collect a coin.
; If Meowth is hit, the bonus resets to 0.
    ds 1

    ds 1

wMeowthStageScore:: ; 0xd711
; Number of Meowth coins collected.
    ds 1

    ds $2b

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

    ds 2

wDugtrioAnimationFrameCounter:: ; 0xd761
; wDugtrioAnimationFrame is incremented when this counter hits zero. The counter loops repeatedly.
    ds 1
wDugtrioAnimationFrame:: ; 0xd762
    ds 1
wDugtrioAnimationFrame2:: ; 0xd763
; Loops from 0-2 repeatedly at the same page as wDugtrioAnimationFrame.
    ds 1

wDugrioState:: ; 0xd764
; Similar function as wDiglettStates.
; $0 = Dugtrio hasn't appeared yet
; $1 = 3 healthy dugtrio
; $2 = Getting hit first time
; $3 = 2 healthy dugtrio
; $4 = Getting hit second time
; $5 = 1 healthy dugtrio
; $6 = Getting hit third time
; $7 = Disappearing
    ds 1

    ds $3c

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

    ds $23

wStageCollisionMapPointer:: ; 0xd7ec
; pointer to the current collision map (always points to wStageCollisionMapPointer, except when loading new attributes)
    ds 2
wStageCollisionMapBank:: ; 0xd7ee
; holds bank of current collision map (always $00, except when loading new attributes)
    ds 1

wStageCollisionMasksPointer:: ; 0xd7ef
; Pointer to the current collision masks array
    ds 2
wStageCollisionMasksBank:: ; 0xd7f1
; Holds bank of current collision masks array
    ds 1

    ds 7

wInGameMenuIndex:: ; 0xd7f9
    ds 1

    ds $61

wCurrentSongBank:: ; 0xd85b
    ds 1

    ds $95

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

    ds 3

wCurPokedexIndex:: ; 0xd959
; Stores the mon index of which pokemon the cursor is on in the Pokedex screen.
    ds 1
wPokedexOffset:: ; 0xd95a
; Stores the number of pokedex entries that are above the current displayed pokemon entries.
    ds 1

    ds 7

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

    ds 4

wHighScoresStage:: ; 0xda83
; Current stage's high scores.
; 0 = Red Stage
; 1 = Blue stage
    ds 1

wHighScoresArrowAnimationCounter:: ; 0xda84
; Counts up to $28 and wraps around to $0 to control the animation of the
; arrows in the bottom corner of the high scores screen.
    ds 1
