
SECTION "WRAM Bank 0", WRAM0

wc000:: ; 0xc000
	ds $10

wc010:: ; 0xc010
	ds $140

wc150:: ; 0xc150
	ds $68

wc1b8:: ; 0xc1b8
	ds $c8

wc280:: ; 0xc280
	ds $9

wc289:: ; 0xc289
	ds $37

wc2c0:: ; 0xc2c0
	ds $140

wMonAnimatedCollisionMask:: ; 0xc400
	ds $80

wc480:: ; 0xc480
	ds $40

wc4c0:: ; 0xc4c0
	ds $c

wc4cc:: ; 0xc4cc
	ds $34

wBottomMessageText:: ; 0xc500
	ds $100

wBottomMessageBuffer:: ; 0xc600
; This acts as a buffer to hold the scrolling text message.
; Rather than storing the raw text, it stores tile ids for the text.
; The lower-left most tile is at 0xc640, so everything before isn't visible on screen.
	ds $100

wStageCollisionMap:: ; 0xc700
	ds $300

wca00::
	ds $100

wcb00:: ; 0xcb00
	ds $500

SECTION "WRAM Bank 1", WRAMX, BANK[1]

wOAMBuffer:: ; 0xd000
	ds $a0
wOAMBufferEnd:: ; 0xd0a0

SECTION "WRAM Bank 1.1", WRAMX [$d200], BANK [1]
wPaletteData:: ; 0xd200
	ds $80

; This buffer holds the intermediate palette data when fading to a new palette.
; The target palette is held in wPaletteData.
wFadeBGPaletteData:: ; 0xd280
	ds $40
wFadeOBJPaletteData:: ; 0xd2c0
	ds $40

wPartyMons:: ; 0xd300
	ds $100

wAddScoreQueue:: ; 0xd400
	ds $60
wAddScoreQueueEnd:: ; 0xd460

wNumPartyMons:: ; 0xd460
	ds $1

wd461:: ; 0xd461
	ds $1

wd462:: ; 0xd462
	ds $1

wd463:: ; 0xd463
	ds $1

wd464:: ; 0xd464
	ds $6

wScore:: ; 0xd46a
	ds $6

wd470:: ; 0xd470
	ds $1

wd471:: ; 0xd471
	ds $1

wd472:: ; 0xd472
	ds $1

wd473:: ; 0xd473
	ds $4

wAddScoreQueueOffset:: ; 0xd477
	ds $1

wd478:: ; 0xd478
	ds $1

wd479:: ; 0xd479
	ds $1

wd47a:: ; 0xd47a
	ds $4

wBallType:: ; 0xd47e
	ds $1

wBallTypeCounter:: ; 0xd47f
	ds $2

wBallTypeBackup:: ; 0xd481
	ds $1

wd482:: ; 0xd482
	ds $1

wd483:: ; 0xd483
	ds $5

wd488:: ; 0xd488
	ds $1

wd489:: ; 0xd489
	ds $5

wd48e:: ; 0xd48e
	ds $1

wd48f:: ; 0xd48f
	ds $5

wd494:: ; 0xd494
	ds $1

wd495:: ; 0xd495
	ds $1

wd496:: ; 0xd496
	ds $1

wd497:: ; 0xd497
	ds $1

wd498:: ; 0xd498
	ds $1

wd499:: ; 0xd499
	ds $1

wd49a:: ; 0xd49a
	ds $1

wCurBonusMultiplier:: ; 0xd49b
; Current value of the bonus multiplier. See MAX_BONUS_MULTIPLIER.
	ds $1

wd49c:: ; 0xd49c
	ds $1

wd49d:: ; 0xd49d
	ds $1

wd49e:: ; 0xd49e
	ds $1

wd49f:: ; 0xd49f
	ds $2

wBallSaverIconOn:: ; 0xd4a1
	ds $1

wd4a2:: ; 0xd4a2
	ds $1

wBallSaverTimerFrames:: ; 0xd4a3
	ds $1

wBallSaverTimerSeconds:: ; 0xd4a4
	ds $1

wNumTimesBallSavedTextWillDisplay:: ; 0xd4a5
	ds $1

wBallSaverTimerFramesBackup:: ; 0xd4a6
	ds $1

wBallSaverTimerSecondsBackup:: ; 0xd4a7
	ds $1

wd4a8:: ; 0xd4a8
	ds $1

wd4a9:: ; 0xd4a9
	ds $1

wd4aa:: ; 0xd4aa
	ds $1

wd4ab:: ; 0xd4ab
	ds $1

wCurrentStage:: ; 0xd4ac
	ds $1

wd4ad:: ; 0xd4ad
	ds $1

wd4ae:: ; 0xd4ae
	ds $1

wStageCollisionState:: ; 0xd4af
	ds $1

wd4b0:: ; 0xd4b0
	ds $3

wBallXPos:: ; 0xd4b3
	ds $1

wd4b4:: ; 0xd4b4
	ds $1

wBallYPos:: ; 0xd4b5
	ds $1

wd4b6:: ; 0xd4b6
	ds $1

wPreviousBallXPos:: ; 0xd4b7
	ds $2

wPreviousBallYPos:: ; 0xd4b9
	ds $2

wBallXVelocity:: ; 0xd4bb
	ds $2

wBallYVelocity:: ; 0xd4bd
	ds $6

wBallSpin:: ; 0xd4c3
	ds $1

wBallRotation:: ; 0xd4c4
	ds $1

wd4c5:: ; 0xd4c5
	ds $1

wd4c6:: ; 0xd4c6
	ds $1

wd4c7:: ; 0xd4c7
	ds $1

wd4c8:: ; 0xd4c8
	ds $1

wd4c9:: ; 0xd4c9
	ds $1

wd4ca:: ; 0xd4ca
	ds $1

wWhichVoltorb:: ; 0xd4cb
wWhichShellder::
	ds $1
wWhichVoltorbId:: ; 0xd4cc
wWhichShellderId::
	ds $1

wd4cd:: ; 0xd4cd
	ds $3

wd4d0:: ; 0xd4d0
	ds $3

wd4d3:: ; 0xd4d3
	ds $3

wd4d6:: ; 0xd4d6
	ds $1

wd4d7:: ; 0xd4d7
	ds $1

wWhichBumper:: ; 0xd4d8
; 0 = neither
; 1 = left bumper
; 2 = right bumper
	ds $1
wWhichBumperId:: ; 0xd4d9
	ds $1

wd4da:: ; 0xd4da
	ds $1

wd4db:: ; 0xd4db
	ds $1

wPinballLaunchAlley:: ; 0xd4dc
; 0 = pinball isn't resting at the start, waiting to be launched by the player
; 1 = pinball can be launched to start the round
; second byte is unused, but it's written by HandleGameObjectCollision
	ds $2

wd4de:: ; 0xd4de
	ds $1

wd4df:: ; 0xd4df
	ds $1

wd4e0:: ; 0xd4e0
	ds $1

wInitialMapSelectionIndex:: ; 0xd4e1
	ds $1

wd4e2:: ; 0xd4e2
	ds $1

wd4e3:: ; 0xd4e3
	ds $1

wd4e4:: ; 0xd4e4
	ds $1

wd4e5:: ; 0xd4e5
	ds $1

wd4e6:: ; 0xd4e6
	ds $1

wd4e7:: ; 0xd4e7
	ds $1

wd4e8:: ; 0xd4e8
	ds $2

wTriggeredGameObject:: ; 0xd4ea
; Game objects, such as the two bumpers, Pikachu savers, CAVE, etc. have unique ids.
; This byte saves the object which the pinball is currently colliding with.
	ds $1

wTriggeredGameObjectIndex:: ; 0xd4eb
; Many game objects come in pairs, wuch as the two bumpers, Pikachu savers, etc.
; This byte stores which of them the pinball is currently colliding with.
	ds $1

wPreviousTriggeredGameObject:: ; 0xd4ec
; Store the previous triggered game object's id, so that the pinball cant trigger
; and object two frames in a row. It has to "un-collide" before it can collide again.
	ds $1

wWhichDiglett:: ; 0xd4ed
wWhichPsyduckPoliwag::
	ds $1
wWhichDiglettId:: ; 0xd4ee
wWhichPsyduckPoliwagId::
	ds $1

wd4ef:: ; 0xd4ef
	ds $1

wLeftMapMoveCounter:: ; 0xd4f0
	ds $1

wd4f1:: ; 0xd4f1
	ds $1

wRightMapMoveCounter:: ; 0xd4f2
	ds $1

wLeftMapMoveDiglettAnimationCounter:: ; 0xd4f3
	ds $1

wLeftMapMoveDiglettFrame:: ; 0xd4f4
	ds $1

wRightMapMoveDiglettAnimationCounter:: ; 0xd4f5
	ds $1

wRightMapMoveDiglettFrame:: ; 0xd4f6
	ds $1

wd4f7:: ; 0xd4f7
	ds $1

wd4f8:: ; 0xd4f8
	ds $1

wd4f9:: ; 0xd4f9
	ds $1

wd4fa:: ; 0xd4fa
	ds $1

wBellsproutCollision:: ; 0xd4fb
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wBellsproutAnimationFrameCounter:: ; 0xd4fd
	ds $1

wBellsproutAnimationFrame:: ; 0xd4fe
	ds $1

wBellsproutAnimationFrameIndex:: ; 0xd4ff
	ds $1

wStaryuCollision:: ; 0xd500
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wd502:: ; 0xd502
	ds $1

wd503:: ; 0xd503
	ds $1

wd504:: ; 0xd504
	ds $1

wd505:: ; 0xd505
	ds $1

wd506:: ; 0xd506
	ds $1

wSpinnerCollision:: ; 0xd507
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wd509:: ; 0xd509
	ds $1

wd50a:: ; 0xd50a
	ds $1

wd50b:: ; 0xd50b
	ds $1

wd50c:: ; 0xd50c
	ds $1

wWhichCAVELight:: ; 0xd50d
	ds $1
wWhichCAVELightId:: ; 0xd50e
	ds $1

wd50f:: ; 0xd50f
	ds $3

wd512:: ; 0xd512
	ds $1

wd513:: ; 0xd513
	ds $1

wd514:: ; 0xd514
	ds $1

wWhichPikachu:: ; 0xd515
	ds $1
wWhichPikachuId:: ; 0xd516
	ds $1

wPikachuSaverCharge:: ; 0xd517
; Holds the amount of Pikachu "charge" that has been generated by spinning the spinner
; in the right alley. The charge's value ranges from 0 - 15.
	ds $1

wd518:: ; 0xd518
	ds $1

wPikachuSaverAnimationFrameCounter:: ; 0xd519
	ds $1

wPikachuSaverAnimationFrame:: ; 0xd51a
	ds $1

wPikachuSaverAnimationFrameIndex:: ; 0xd51b
	ds $1

wd51c:: ; 0xd51c
	ds $1

wPikachuSaverSlotRewardActive:: ; 0xd51d
; Set to 1 if the Pikachu Saver slot reward is active. 0 otherwise.
	ds $1

wd51e:: ; 0xd51e
	ds $1

wWhichBoardTrigger:: ; 0xd51f
	ds $1
wWhichBoardTriggerId:: ; 0xd520
	ds $1

wd521:: ; 0xd521
	ds $1

wd522:: ; 0xd522
	ds $1

wd523:: ; 0xd523
	ds $1

wd524:: ; 0xd524
	ds $1

wd525:: ; 0xd525
	ds $1

wd526:: ; 0xd526
	ds $1

wd527:: ; 0xd527
	ds $1

wd528:: ; 0xd528
	ds $7

wIndicatorStates:: ; 0xd52f
	ds $13

wLeftAlleyTrigger:: ; 0xd542
	ds $1

wLeftAlleyCount:: ; 0xd543
	ds $1

wRightAlleyTrigger:: ; 0xd544
	ds $1

wRightAlleyCount:: ; 0xd545
	ds $1

wSecondaryLeftAlleyTrigger:: ; 0xd546
	ds $2

wd548:: ; 0xd548
	ds $1

wd549:: ; 0xd549
	ds $1

wCurrentMap:: ; 0xd54a
	ds $1

wInSpecialMode:: ; 0xd54b
; Set to 1 if currently in special game mode. See wSpecialMode.
	ds $1

wd54c:: ; 0xd54c
	ds $1

wd54d:: ; 0xd54d
	ds $1

wd54e:: ; 0xd54e
	ds $1

wd54f:: ; 0xd54f
	ds $1

wSpecialMode:: ; 0xd550
; Represents the current pinball mode. Example special modes would be, Catch'Em, Evolution, Map Move
; See SPECIAL_MODE constants.
	ds $1

wd551:: ; 0xd551
	ds $1

wCurrentEvolutionMon:: ; 0xd552
	ds $1

wCurrentEvolutionType:: ; 0xd553
	ds $1

wd554:: ; 0xd554
	ds $1

wd555:: ; 0xd555
	ds $1

wd556:: ; 0xd556
	ds $1

wd557:: ; 0xd557
	ds $1

wd558:: ; 0xd558
	ds $1

wd559:: ; 0xd559
	ds $1

wd55a:: ; 0xd55a
	ds $1

wRareMonsFlag:: ; 0xd55b
	ds $1

wd55c:: ; 0xd55c
	ds $1

wd55d:: ; 0xd55d
	ds $1

wd55e:: ; 0xd55e
	ds $1

wd55f:: ; 0xd55f
	ds $1

wd560:: ; 0xd560
	ds $1

wd561:: ; 0xd561
	ds $1

wd562:: ; 0xd562
	ds $1

wd563:: ; 0xd563
	ds $1

wd564:: ; 0xd564
	ds $1

wd565:: ; 0xd565
	ds $1

wd566:: ; 0xd566
	ds $c

wd572:: ; 0xd572
	ds $6

wd578:: ; 0xd578
	ds $1

wCurrentCatchEmMon:: ; 0xd579
	ds $1

wTimerSeconds:: ; 0xd57a
	ds $1

wTimerMinutes:: ; 0xd57b
	ds $1

wTimerFrames:: ; 0xd57c
	ds $1

wTimerActive:: ; 0xd57d
; Set to 1 when the Timer is displayed and counting down.
	ds $1

wd57e:: ; 0xd57e
	ds $1

wd57f:: ; 0xd57f
	ds $1

wd580:: ; 0xd580
	ds $1

wd581:: ; 0xd581
	ds $1

wTimerDigits:: ; 0xd582
; first byte = minutes
; second byte = tens place
; third byte = ones place
; fourth byte = unused, but still written to
	ds $4

wd586:: ; 0xd586
	ds $30

wd5b6:: ; 0xd5b6
	ds $5

wWildMonIsHittable:: ; 0xd5bb
; Set to 1 when the wild pokemon is animated and hittable with the pinball.
	ds $1

wd5bc:: ; 0xd5bc
	ds $1

wd5bd:: ; 0xd5bd
	ds $1

wd5be:: ; 0xd5be
	ds $1

wBallHitWildMon:: ; 0xd5bf
	ds $1

wNumMonHits:: ; 0xd5c0
	ds $1

wd5c1:: ; 0xd5c1
	ds $1

wd5c2:: ; 0xd5c2
	ds $1

wd5c3:: ; 0xd5c3
	ds $1

wd5c4:: ; 0xd5c4
	ds $1

wNumMewHitsLow:: ; 0xd5c5
	ds $1

wd5c6:: ; 0xd5c6
	ds $1

wWildMonCollision:: ; 0xd5c7
; Set by HandleGameObjectCollision
; Second byte gets set, but is unused
	ds $2

	ds $1

wd5ca:: ; 0xd5ca
	ds $1

wd5cb:: ; 0xd5cb
	ds $1

wd5cc:: ; 0xd5cc
	ds $8

wd5d4:: ; 0xd5d4
	ds $4

wd5d8:: ; 0xd5d8
	ds $3

wd5db:: ; 0xd5db
	ds $1

wd5dc:: ; 0xd5dc
	ds $8

wd5e4:: ; 0xd5e4
	ds $5

wd5e9:: ; 0xd5e9
	ds $5

wd5ee:: ; 0xd5ee
	ds $5

wCapturingMon:: ; 0xd5f3
; Set to 1 when the capturing animation starts.
	ds $1

wBallCaptureAnimationFrameCounter:: ; 0xd5f4
	ds $1

wBallCaptureAnimationFrame:: ; 0xd5f5
	ds $1

wBallCaptureAnimationFrameIndex:: ; 0xd5f6
	ds $1

wWhichPinballUpgradeTrigger:: ; 0xd5f7
	ds $1
wWhichPinballUpgradeTriggerId:: ; 0xd5f8
	ds $1

wd5f9:: ; 0xd5f9
	ds $2

wd5fb:: ; 0xd5fb
	ds $1

wd5fc:: ; 0xd5fc
	ds $1

wd5fd:: ; 0xd5fd
	ds $1

wDittoSlotCollision:: ; 0xd5fe
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wd600:: ; 0xd600
	ds $1

wSlotCollision:: ; 0xd601
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wd603:: ; 0xd603
	ds $1

wd604:: ; 0xd604
	ds $2

wd606:: ; 0xd606
	ds $1

wd607:: ; 0xd607
	ds $1

wd608:: ; 0xd608
	ds $1

wd609:: ; 0xd609
	ds $1

wWhichBonusMultiplierRailing:: ; 0xd60a
	ds $1
wWhichBonusMultiplierRailingId:: ; 0xd60b
	ds $1

wd60c:: ; 0xd60c
	ds $1

wd60d:: ; 0xd60d
	ds $1

wd60e:: ; 0xd60e
	ds $1

wd60f:: ; 0xd60f
	ds $1

wd610:: ; 0xd610
	ds $1

wd611:: ; 0xd611
	ds $1

wd612:: ; 0xd612
	ds $1

wd613:: ; 0xd613
	ds $1

wd614:: ; 0xd614
	ds $1

wd615:: ; 0xd615
	ds $1

wGameOver:: ; 0xd616
	ds $3

wd619:: ; 0xd619
	ds $1

wd61a:: ; 0xd61a
	ds $1

wd61b:: ; 0xd61b
	ds $2

wd61d:: ; 0xd61d
	ds $1

wd61e:: ; 0xd61e
	ds $1

wCurSlotBonus:: ; 0xd61f
	ds $1

wd620:: ; 0xd620
	ds $1

wd621:: ; 0xd621
	ds $1

wCatchEmOrEvolutionSlotRewardActive:: ; 0xd622
; Set to 1 if the "Start Catch 'Em Mode" Slot Reward is received.
; Set to 2 if the "Start Evolution Mode" Slot Reward is received.
	ds $1

wBonusStageSlotRewardActive:: ; 0xd623
; Set to 1 when the "Go To Bonus" Slot Reward is received.
	ds $1

wd624:: ; 0xd624
	ds $1

wd625:: ; 0xd625
	ds $1

wd626:: ; 0xd626
	ds $2

wd628:: ; 0xd628
	ds $1

wd629:: ; 0xd629
	ds $1

wd62a:: ; 0xd62a
	ds $1

wd62b:: ; 0xd62b
	ds $1

wd62c:: ; 0xd62c
	ds $1

wd62d:: ; 0xd62d
	ds $1

wd62e:: ; 0xd62e
	ds $1

wNumMewtwoBonusCompletions:: ; 0xd62f
	ds $1

wSlowpokeCollision:: ; 0xd630
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wd632:: ; 0xd632
	ds $1

wd633:: ; 0xd633
	ds $1

wd634:: ; 0xd634
	ds $1

wCloysterCollision:: ; 0xd635
; Second byte is set by HandleGameObjectCollision, but is unused
	ds $2

wd637:: ; 0xd637
	ds $1

wd638:: ; 0xd638
	ds $1

wd639:: ; 0xd639
	ds $1

wd63a:: ; 0xd63a
	ds $1

wd63b:: ; 0xd63b
	ds $1

wd63c:: ; 0xd63c
	ds $1

wd63d:: ; 0xd63d
	ds $1

wBlueStageForceFieldDirection:: ; 0xd63e
	ds $1

wd63f:: ; 0xd63f
	ds $1

wd640:: ; 0xd640
	ds $1

wd641:: ; 0xd641
	ds $1

wd642:: ; 0xd642
	ds $1

wd643:: ; 0xd643
	ds $1

wd644:: ; 0xd644
	ds $1

wd645:: ; 0xd645
	ds $1

wd646:: ; 0xd646
	ds $1

wd647:: ; 0xd647
	ds $1

wd648:: ; 0xd648
	ds $1

wd649:: ; 0xd649
	ds $1

wd64a:: ; 0xd64a
	ds $1

wd64b:: ; 0xd64b
	ds $1

wd64c:: ; 0xd64c
	ds $1

wd64d:: ; 0xd64d
	ds $1

wd64e:: ; 0xd64e
	ds $1

wd64f:: ; 0xd64f
	ds $1

wd650:: ; 0xd650
	ds $1

wd651:: ; 0xd651
	ds $1

wd652:: ; 0xd652
	ds $1

wd653:: ; 0xd653
	ds $1

wWhichGravestone:: ; 0xd654
; second byte is unused
	ds $2

wd656:: ; 0xd656
	ds $1

wd657:: ; 0xd657
	ds $1

wd658:: ; 0xd658
	ds $1

wd659:: ; 0xd659
	ds $2

wGastly1AnimationState:: ; 0xd65b
	ds $2

wd65d:: ; 0xd65d
	ds $1

wGastly1XPos:: ; 0xd65e
	ds $2
wGastly1YPos:: ; 0xd660
	ds $2

wd662:: ; 0xd662
	ds $2

wGastly2AnimationState:: ; 0xd664
	ds $2

wd666:: ; 0xd666
	ds $1

wGastly2XPos:: ; 0xd668
	ds $2
wGastly2YPos:: ; 0xd66a
	ds $2

wd66b:: ; 0xd66b
	ds $2

wGastly3AnimationState:: ; 0xd66d
	ds $2

wd66f:: ; 0xd66f
	ds $1

wGastly3XPos:: ; 0xd671
	ds $2
wGastly3YPos:: ; 0xd673
	ds $2

wd674:: ; 0xd674
	ds $1

wd675:: ; 0xd675
	ds $2

wd677:: ; 0xd677
	ds $2

wd679:: ; 0xd679
	ds $2

wd67b:: ; 0xd67b
	ds $1

wd67c:: ; 0xd67c
	ds $1

wd67d:: ; 0xd67d
	ds $1

wd67e:: ; 0xd67e
	ds $2

wHaunter1AnimationState:: ; 0xd680
	ds $2

wd682:: ; 0xd682
	ds $1

wHaunter1XPos:: ; 0xd683
	ds $2
wHaunter1YPos:: ; 0xd685
	ds $2

wd687:: ; 0xd687
	ds $2

wHaunter2AnimationState:: ; 0xd689
	ds $1

	ds $1

wd68b:: ; 0xd68b
	ds $1

wHaunter2XPos:: ; 0xd68c
	ds $2
wHaunter2YPos:: ; 0xd68e
	ds $2

wd690:: ; 0xd690
	ds $1

wd691:: ; 0xd691
	ds $2

wd693:: ; 0xd693
	ds $2

wd695:: ; 0xd695
	ds $1

wd696:: ; 0xd696
	ds $1

wd697:: ; 0xd697
	ds $1

wd698:: ; 0xd698
	ds $2

wGengarAnimationState:: ; 0xd69a
	ds $1

wd69b:: ; 0xd69b
	ds $1

wd69c:: ; 0xd69c
	ds $1

wGengarXPos:: ; 0xd69d
	ds $2
wGengarYPos:: ; 0xd69f
	ds 2

wd6a1:: ; 0xd6a1
	ds $1

wd6a2:: ; 0xd6a2
	ds $1

wd6a3:: ; 0xd6a3
	ds $1

wd6a4:: ; 0xd6a4
	ds $1

wd6a5:: ; 0xd6a5
	ds $1

wd6a6:: ; 0xd6a6
	ds $1

wd6a7:: ; 0xd6a7
	ds $1

wd6a8:: ; 0xd6a8
	ds $1

wd6a9:: ; 0xd6a9
	ds $1

wd6aa:: ; 0xd6aa
	ds $2

wd6ac:: ; 0xd6ac
	ds $1

wd6ad:: ; 0xd6ad
	ds $1

wd6ae:: ; 0xd6ae
	ds $1

wd6af:: ; 0xd6af
	ds $1

wd6b0:: ; 0xd6b0
	ds $1

wd6b1:: ; 0xd6b1
	ds $1

wd6b2:: ; 0xd6b2
	ds $1

wd6b3:: ; 0xd6b3
	ds $1

wd6b4:: ; 0xd6b4
	ds $1

wd6b5:: ; 0xd6b5
	ds $1

wd6b6:: ; 0xd6b6
	ds $4

wd6ba:: ; 0xd6ba
	ds $1

wd6bb:: ; 0xd6bb
	ds $2

wd6bd:: ; 0xd6bd
	ds $1

wd6be:: ; 0xd6be
	ds $7

wd6c5:: ; 0xd6c5
	ds $1

wd6c6:: ; 0xd6c6
	ds $7

wd6cd:: ; 0xd6cd
	ds $1

wd6ce:: ; 0xd6ce
	ds $7

wd6d5:: ; 0xd6d5
	ds $1

wd6d6:: ; 0xd6d6
	ds $7

wd6dd:: ; 0xd6dd
	ds $1

wd6de:: ; 0xd6de
	ds $7

wd6e5:: ; 0xd6e5
	ds $1

wd6e6:: ; 0xd6e6
	ds $1

wd6e7:: ; 0xd6e7
	ds $2

wMeowthAnimationFrameCounter:: ; 0xd6e9
	ds $1

wMeowthAnimationFrame:: ; 0xd6ea
	ds $1

wMeowthAnimationFrameIndex:: ; 0xd6eb
	ds $1

wd6ec:: ; 0xd6ec
	ds $1

wMeowthXPosition:: ; 0xd6ed
	ds $1

wMeowthYPosition:: ; 0xd6ee
	ds $2

wMeowthXMovement:: ; 0xd6f0
	ds $1

wMeowthYMovement:: ; 0xd6f1
	ds $2

wd6f3:: ; 0xd6f3
	ds $1

wd6f4:: ; 0xd6f4
	ds $1

wd6f5:: ; 0xd6f5
	ds $1

wd6f6:: ; 0xd6f6
	ds $1

wd6f7:: ; 0xd6f7
	ds $1

wd6f8:: ; 0xd6f8
	ds $1

wd6f9:: ; 0xd6f9
	ds $1

wd6fa:: ; 0xd6fa
	ds $1

wd6fb:: ; 0xd6fb
	ds $1

wd6fc:: ; 0xd6fc
	ds $1

wd6fd:: ; 0xd6fd
	ds $2

wd6ff:: ; 0xd6ff
	ds $1

wd700:: ; 0xd700
	ds $1

wd701:: ; 0xd701
	ds $1

wd702:: ; 0xd702
	ds $1

wd703:: ; 0xd703
	ds $1

wd704:: ; 0xd704
	ds $1

wd705:: ; 0xd705
	ds $1

wd706:: ; 0xd706
	ds $1

wd707:: ; 0xd707
	ds $4

wd70b:: ; 0xd70b
	ds $1

wd70c:: ; 0xd70c
	ds $3

wMeowthStageBonusCounter:: ; 0xd70f
	ds $1

wd710:: ; 0xd710
	ds $1

wMeowthStageScore:: ; 0xd711
	ds $1

wd712:: ; 0xd712
	ds $1

wd713:: ; 0xd713
	ds $1

wd714:: ; 0xd714
	ds $1

wd715:: ; 0xd715
	ds $1

wd716:: ; 0xd716
	ds $1

wd717:: ; 0xd717
	ds $1

wd718:: ; 0xd718
	ds $1

wd719:: ; 0xd719
	ds $1

wd71a:: ; 0xd71a
	ds $1

wd71b:: ; 0xd71b
	ds $1

wd71c:: ; 0xd71c
	ds $2

wd71e:: ; 0xd71e
	ds $1

wd71f:: ; 0xd71f
	ds $1

wd720:: ; 0xd720
	ds $1

wd721:: ; 0xd721
	ds $1

wd722:: ; 0xd722
	ds $1

wd723:: ; 0xd723
	ds $1

wd724:: ; 0xd724
	ds $1

wd725:: ; 0xd725
	ds $1

wd726:: ; 0xd726
	ds $1

wd727:: ; 0xd727
	ds $1

wd728:: ; 0xd728
	ds $1

wd729:: ; 0xd729
	ds $1

wd72a:: ; 0xd72a
	ds $1

wd72b:: ; 0xd72b
	ds $1

wd72c:: ; 0xd72c
	ds $5

wd731:: ; 0xd731
	ds $1

wd732:: ; 0xd732
	ds $1

wd733:: ; 0xd733
	ds $1

wd734:: ; 0xd734
	ds $1

wd735:: ; 0xd735
	ds $1

wd736:: ; 0xd736
	ds $3

wd739:: ; 0xd739
	ds $1

wd73a:: ; 0xd73a
	ds $1

wd73b:: ; 0xd73b
	ds $1

wd73c:: ; 0xd73c
	ds $1

wDiglettStates:: ; 0xd73d
	ds $1f

wCurrentDiglett:: ; 0xd75c
	ds $1

wDiglettsInitializedFlag:: ; 0xd75d
	ds $1

wDiglettInitDelayCounter:: ; 0xd75e
	ds $1

wd75f:: ; 0xd75f
	ds $2

wDugtrioAnimationFrameCounter:: ; 0xd761
	ds $1

wDugtrioAnimationFrame:: ; 0xd762
	ds $1

wDugtrioAnimationFrameIndex:: ; 0xd763
	ds $1

wDugrioState:: ; 0xd764
	ds $1

wd765:: ; 0xd765
	ds $1

wd766:: ; 0xd766
	ds $1

wd767:: ; 0xd767
	ds $1

wd768:: ; 0xd768
	ds $3

wd76b:: ; 0xd76b
	ds $1

wd76c:: ; 0xd76c
	ds $1

wd76d:: ; 0xd76d
	ds $1

wd76e:: ; 0xd76e
	ds $2

wd770:: ; 0xd770
	ds $1

wd771:: ; 0xd771
	ds $1

wd772:: ; 0xd772
	ds $3

wd775:: ; 0xd775
	ds $1

wd776:: ; 0xd776
	ds $1

wd777:: ; 0xd777
	ds $1

wd778:: ; 0xd778
	ds $2

wd77a:: ; 0xd77a
	ds $1

wd77b:: ; 0xd77b
	ds $1

wd77c:: ; 0xd77c
	ds $3

wd77f:: ; 0xd77f
	ds $1

wd780:: ; 0xd780
	ds $1

wd781:: ; 0xd781
	ds $1

wd782:: ; 0xd782
	ds $2

wd784:: ; 0xd784
	ds $1

wd785:: ; 0xd785
	ds $1

wd786:: ; 0xd786
	ds $b

wd791:: ; 0xd791
	ds $1

wd792:: ; 0xd792
	ds $1

wd793:: ; 0xd793
	ds $1

wd794:: ; 0xd794
	ds $1

wd795:: ; 0xd795
	ds $1

wd796:: ; 0xd796
	ds $1

wd797:: ; 0xd797
	ds $1

wd798:: ; 0xd798
	ds $1

wd799:: ; 0xd799
	ds $1

wd79a:: ; 0xd79a
	ds $2

wd79c:: ; 0xd79c
	ds $2

wd79e:: ; 0xd79e
	ds $1

wd79f:: ; 0xd79f
	ds $1

wd7a0:: ; 0xd7a0
	ds $1

wLeftTiltCounter:: ; 0xd7a1
	ds $1

wLeftTiltReset:: ; 0xd7a2
	ds $1

wRightTiltCounter:: ; 0xd7a3
	ds $1

wRightTiltReset:: ; 0xd7a4
	ds $1

wUpperTiltCounter:: ; 0xd7a5
	ds $1

wUpperTiltReset:: ; 0xd7a6
	ds $1

wLeftTiltPushing:: ; 0xd7a7
	ds $1

wRightTiltPushing:: ; 0xd7a8
	ds $1

wUpperTiltPushing:: ; 0xd7a9
	ds $1

wd7aa:: ; 0xd7aa
	ds $1

wSCX:: ; 0xd7ab
	ds $1

wd7ac:: ; 0xd7ac
	ds $1

wd7ad:: ; 0xd7ad
	ds $1

wd7ae:: ; 0xd7ae
	ds $1

wd7af:: ; 0xd7af
	ds $1

wd7b0:: ; 0xd7b0
	ds $1

wd7b1:: ; 0xd7b1
	ds $1

wd7b2:: ; 0xd7b2
	ds $1

wd7b3:: ; 0xd7b3
	ds $1

wd7b4:: ; 0xd7b4
	ds $1

wd7b5:: ; 0xd7b5
	ds $1

wLeftFlipperAnimationState:: ; 0xd7b6
	ds $1

wRightFlipperAnimationState:: ; 0xd7b7
	ds $1

wFlipperXCollisionAttribute:: ; 0xd7b8
	ds $1

wFlipperCollision:: ; 0xd7b9
	ds $1

wFlipperXForce:: ; 0xd7ba
	dw

wFlipperYForce:: ; 0xd7bc
	dw

wd7be:: ; 0xd7be
	ds $1

wStageSong:: ; 0xd7bf
	ds $1

wStageSongBank:: ; 0xd7c0
	ds $1

wd7c1:: ; 0xd7c1
	ds $1

wd7c2:: ; 0xd7c2
	ds $1

wSubTileBallXPos:: ; 0xd7c3
	ds $1

wSubTileBallYPos:: ; 0xd7c4
	ds $1

wUpperLeftCollisionAttribute:: ; 0xd7c5
	ds $1

wLowerLeftCollisionAttribute:: ; 0xd7c6
	ds $1

wUpperRightCollisionAttribute:: ; 0xd7c7
	ds $1

wLowerRightCollisionAttribute:: ; 0xd7c8
	ds $1

wd7c9:: ; 0xd7c9
	ds $10

wd7d9:: ; 0xd7d9
	ds $10

wd7e9:: ; 0xd7e9
	ds $1

wCollisionForceAngle:: ; 0xd7ea
	ds $1

wd7eb:: ; 0xd7eb
	ds $1

wStageCollisionMapPointer:: ; 0xd7ec
	ds $2

wStageCollisionMapBank:: ; 0xd7ee
	ds $1

wStageCollisionMasksPointer:: ; 0xd7ef
	ds $2

wStageCollisionMasksBank:: ; 0xd7f1
	ds $1

wd7f2:: ; 0xd7f2
	ds $1

wBallPositionPointerOffsetFromStageTopLeft:: ; 0xd7f3
	dw

wCurCollisionAttribute:: ; 0xd7f5
	ds $1

wd7f6:: ; 0xd7f6
	ds $1

wd7f7:: ; 0xd7f7
	ds $1

wd7f8:: ; 0xd7f8
	ds $1

wInGameMenuIndex:: ; 0xd7f9
	ds $1

wd7fa:: ; 0xd7fa
	ds $1

wd7fb:: ; 0xd7fb
	ds $1

wd7fc:: ; 0xd7fc
	ds $1

wd7fd:: ; 0xd7fd
	ds $1

wd7fe:: ; 0xd7fe
	ds $2

wSFXTimer:: ; 0xd800
	ds $1

wd801:: ; 0xd801
	ds $1

wOAMBufferSize:: ; 0xd802
	ds $1

wd803:: ; 0xd803
	ds $1

wd804:: ; 0xd804
	ds $1

wd805:: ; 0xd805
	ds $1

wd806:: ; 0xd806
	ds $1

wd807:: ; 0xd807
	ds $1

wd808:: ; 0xd808
	ds $1

wd809:: ; 0xd809
	ds $1

wd80a:: ; 0xd80a
	ds $2

wBGP:: ; 0xd80c
	ds $1

wOBP0:: ; 0xd80d
	ds $1

wOBP1:: ; 0xd80e
	ds $1

wd80f:: ; 0xd80f
	ds $1

wd810:: ; 0xd810
	ds $1

wd811:: ; 0xd811
	ds $1

wd812:: ; 0xd812
	ds $18

wd82a:: ; 0xd82a
	ds $7

wd831:: ; 0xd831
	ds $c

wd83d:: ; 0xd83d
	ds $9

wd846:: ; 0xd846
	ds $2

wd848:: ; 0xd848
	ds $1

wd849:: ; 0xd849
	ds $1

wd84a:: ; 0xd84a
	ds $1

wd84b:: ; 0xd84b
	ds $4

wd84f:: ; 0xd84f
	ds $c

wCurrentSongBank:: ; 0xd85b
	ds $2

wd85d:: ; 0xd85d
	ds $1

wd85e:: ; 0xd85e
	ds $1

wd85f:: ; 0xd85f
	ds $1

wd860:: ; 0xd860
	ds $1

wd861:: ; 0xd861
	ds $1

wd862:: ; 0xd862
	ds $1

wd863:: ; 0xd863
	ds $1

wd864:: ; 0xd864
	ds $1

wd865:: ; 0xd865
	ds $1

wd866:: ; 0xd866
	ds $1

wd867:: ; 0xd867
	ds $1

wd868:: ; 0xd868
	ds $1

wd869:: ; 0xd869
	ds $1

wd86a:: ; 0xd86a
	ds $1

wd86b:: ; 0xd86b
	ds $1

wd86c:: ; 0xd86c
	ds $1

wd86d:: ; 0xd86d
	ds $1

wd86e:: ; 0xd86e
	ds $1d

wd88b:: ; 0xd88b
	ds $12

wd89d:: ; 0xd89d
	ds $a

wd8a7:: ; 0xd8a7
	ds $1

wd8a8:: ; 0xd8a8
	ds $1

wd8a9:: ; 0xd8a9
	ds $1

wd8aa:: ; 0xd8aa
	ds $1

wd8ab:: ; 0xd8ab
	ds $1

wd8ac:: ; 0xd8ac
	ds $1

wd8ad:: ; 0xd8ad
	ds $1

wd8ae:: ; 0xd8ae
	ds $1

wd8af:: ; 0xd8af
	ds $1

wd8b0:: ; 0xd8b0
	ds $1

wd8b1:: ; 0xd8b1
	ds $1

wd8b2:: ; 0xd8b2
	ds $1

wd8b3:: ; 0xd8b3
	ds $1

wd8b4:: ; 0xd8b4
	ds $1

wd8b5:: ; 0xd8b5
	ds $1

wd8b6:: ; 0xd8b6
	ds $1

wd8b7:: ; 0xd8b7
	ds $1

wd8b8:: ; 0xd8b8
	ds $1

wd8b9:: ; 0xd8b9
	ds $1

wd8ba:: ; 0xd8ba
	ds $1

wd8bb:: ; 0xd8bb
	ds $1

wd8bc:: ; 0xd8bc
	ds $1

wd8bd:: ; 0xd8bd
	ds $1

wd8be:: ; 0xd8be
	ds $1

wd8bf:: ; 0xd8bf
	ds $1

wd8c0:: ; 0xd8c0
	ds $1

wd8c1:: ; 0xd8c1
	ds $1

wd8c2:: ; 0xd8c2
	ds $1

wd8c3:: ; 0xd8c3
	ds $1

wd8c4:: ; 0xd8c4
	ds $1

wd8c5:: ; 0xd8c5
	ds $1

wd8c6:: ; 0xd8c6
	ds $1

wd8c7:: ; 0xd8c7
	ds $1

wd8c8:: ; 0xd8c8
	ds $2

wd8ca:: ; 0xd8ca
	ds $1

wd8cb:: ; 0xd8cb
	ds $1

wd8cc:: ; 0xd8cc
	ds $1

wd8cd:: ; 0xd8cd
	ds $1

wd8ce:: ; 0xd8ce
	ds $1

wd8cf:: ; 0xd8cf
	ds $1

wd8d0:: ; 0xd8d0
	ds $1

wd8d1:: ; 0xd8d1
	ds $1

wd8d2:: ; 0xd8d2
	ds $1

wd8d3:: ; 0xd8d3
	ds $1

wd8d4:: ; 0xd8d4
	ds $1

wd8d5:: ; 0xd8d5
	ds $1

wd8d6:: ; 0xd8d6
	ds $1

wd8d7:: ; 0xd8d7
	ds $1

wd8d8:: ; 0xd8d8
	ds $3

wd8db:: ; 0xd8db
	ds $1

wd8dc:: ; 0xd8dc
	ds $1

wd8dd:: ; 0xd8dd
	ds $1

wd8de:: ; 0xd8de
	ds $2

wd8e0:: ; 0xd8e0
	ds $1

wd8e1:: ; 0xd8e1
	ds $1

wd8e2:: ; 0xd8e2
	ds $1

wd8e3:: ; 0xd8e3
	ds $1

wd8e4:: ; 0xd8e4
	ds $1

wd8e5:: ; 0xd8e5
	ds $1

wd8e6:: ; 0xd8e6
	ds $1

wd8e7:: ; 0xd8e7
	ds $1

wd8e8:: ; 0xd8e8
	ds $1

wd8e9:: ; 0xd8e9
	ds $1

wd8ea:: ; 0xd8ea
	ds $1

wd8eb:: ; 0xd8eb
	ds $1

wd8ec:: ; 0xd8ec
	ds $1

wd8ed:: ; 0xd8ed
	ds $1

wd8ee:: ; 0xd8ee
	ds $1

wd8ef:: ; 0xd8ef
	ds $1

wd8f0:: ; 0xd8f0
	ds $1

wCurrentScreen:: ; 0xd8f1
	ds $1

wScreenState:: ; 0xd8f2
	ds $4

wd8f6:: ; 0xd8f6
	ds $12

wd908:: ; 0xd908
	ds $1

wTitleScreenCursorSelection:: ; 0xd909
	ds $1

wTitleScreenGameStartCursorSelection:: ; 0xd90a
	ds $2

wTitleScreenBlinkAnimationFrame:: ; 0xd90c
	ds $1

wTitleScreenBlinkAnimationCounter:: ; 0xd90d
	ds $1

wTitleScreenBouncingBallAnimationFrame:: ; 0xd90e
	ds $1

wTitleScreenPokeballAnimationCounter:: ; 0xd90f
	ds $1

wd910:: ; 0xd910
	ds $1

wd911:: ; 0xd911
	ds $1

wFieldSelectBlinkingBorderTimer:: ; 0xd912
	ds $1

wSelectedFieldIndex:: ; 0xd913
	ds $1

wFieldSelectBlinkingBorderFrame:: ; 0xd914
	ds $1

wd915:: ; 0xd915
	ds $1

wd916:: ; 0xd916
	ds $1

wd917:: ; 0xd917
	ds $1

wd918:: ; 0xd918
	ds $1

wd919:: ; 0xd919
	ds $1

wSoundTestCurrentBackgroundMusic:: ; 0xd91a
	ds $1

wSoundTextCurrentSoundEffect:: ; 0xd91b
	ds $1

wd91c:: ; 0xd91c
	ds $1

wd91d:: ; 0xd91d
	ds $1

wd91e:: ; 0xd91e
	ds $1

wd91f:: ; 0xd91f
	ds $1

wd920:: ; 0xd920
	ds $1

wd921:: ; 0xd921
	ds $1

wd922:: ; 0xd922
	ds $14

wd936:: ; 0xd936
	ds $8

wd93e:: ; 0xd93e
	ds $1

wd93f:: ; 0xd93f
	ds $8

wd947:: ; 0xd947
	ds $1

wKeyConfigs::
wKeyConfigBallStart:: ; 0xd948
	ds $2

wKeyConfigLeftFlipper:: ; 0xd94a
	ds $2

wKeyConfigRightFlipper:: ; 0xd94c
	ds $2

wKeyConfigLeftTilt:: ; 0xd94e
	ds $2

wKeyConfigRightTilt:: ; 0xd950
	ds $2

wKeyConfigUpperTilt:: ; 0xd952
	ds $2

wKeyConfigMenu:: ; 0xd954
	ds $2

wd956:: ; 0xd956
	ds $1

wd957:: ; 0xd957
	ds $1

wd958:: ; 0xd958
	ds $1

wCurPokedexIndex:: ; 0xd959
	ds $1

wPokedexOffset:: ; 0xd95a
	ds $1

wd95b:: ; 0xd95b
	ds $1

wd95c:: ; 0xd95c
	ds $1

wd95d:: ; 0xd95d
	ds $1

wd95e:: ; 0xd95e
	ds $1

wd95f:: ; 0xd95f
	ds $1

wd960:: ; 0xd960
	ds $1

wd961:: ; 0xd961
	ds $1

wPokedexFlags:: ; 0xd962
	ds $96

wd9f8:: ; 0xd9f8
	ds $1

wNumPokemonSeen:: ; 0xd9f9
	ds $2

wNumPokemonOwned:: ; 0xd9fb
	ds $2

high_scores: MACRO
\1Points:: ds 6
\1Name:: ds 3
\1Unknown0x09:: ds 4
ENDM

wRedHighScores:: ; 0xd9fd
	high_scores wRedHighScore1
	high_scores wRedHighScore2
	high_scores wRedHighScore3
	high_scores wRedHighScore4
	high_scores wRedHighScore5

wBlueHighScores:: ; 0xd9fd
	high_scores wBlueHighScore1
	high_scores wBlueHighScore2
	high_scores wBlueHighScore3
	high_scores wBlueHighScore4
	high_scores wBlueHighScore5

wda7f:: ; 0xda7f
	ds $1

wda80:: ; 0xda80
	ds $1

wda81:: ; 0xda81
	ds $1

wda82:: ; 0xda82
	ds $1

wHighScoresStage:: ; 0xda83
	ds $1

wHighScoresArrowAnimationCounter:: ; 0xda84
	ds $1

wda85:: ; 0xda85
	ds $1

wda86:: ; 0xda86
	ds $1

wSendHighScoresAnimationFrameCounter:: ; 0xda87
	ds $1

wSendHighScoresAnimationFrame:: ; 0xda88
	ds $1

wSendHighScoresAnimationFrameIndex:: ; 0xda89
	ds $1

wda8a:: ; 0xda8a
	ds $2

wda8c:: ; 0xda8c
	ds $3

wda8f:: ; 0xda8f
	ds $3

wda92:: ; 0xda92
	ds $3

wda95:: ; 0xda95
	ds $3

wda98:: ; 0xda98
	ds $3

wda9b:: ; 0xda9b
	ds $3

wda9e:: ; 0xda9e
	ds $3

wdaa1:: ; 0xdaa1
	ds $1

wdaa2:: ; 0xdaa2
	ds $1

wdaa3:: ; 0xdaa3
	ds $20a

wdcad:: ; 0xdcad
	ds $53

SECTION "Audio RAM", WRAMX [$dd00], BANK [1]
wdd00:: ; 0xdd00
	ds $1

wChannel0:: ; 0xdd01
	ds $32

wChannel1:: ; 0xdd33
	ds $32

wChannel2:: ; 0xdd65
	ds $32

wChannel3:: ; 0xdd97
	ds $32

wChannel4:: ; 0xddc9
	ds $32

wChannel5:: ; 0xddfb
	ds $32

wChannel6:: ; 0xde2d
	ds $32

wChannel7:: ; 0xde5f
	ds $32

wde91:: ; 0xde91
	ds $1

wde92:: ; 0xde92
	ds $1

wde93:: ; 0xde93
	ds $1

wde94:: ; 0xde94
	ds $1

wde95:: ; 0xde95
	ds $1

wde96:: ; 0xde96
	ds $1

wde97:: ; 0xde97
	ds $1

wde98:: ; 0xde98
	ds $1

wde99:: ; 0xde99
	ds $1

wde9a:: ; 0xde9a
	ds $1

wde9b:: ; 0xde9b
	ds $1

wde9c:: ; 0xde9c
	ds $1

wde9d:: ; 0xde9d
	ds $1

wde9e:: ; 0xde9e
	ds $1

wde9f:: ; 0xde9f
	ds $2

wdea1:: ; 0xdea1
	ds $1

wdea2:: ; 0xdea2
	ds $1

wdea3:: ; 0xdea3
	ds $1

wdea4:: ; 0xdea4
	ds $1

wdea5:: ; 0xdea5
	ds $3

wdea8:: ; 0xdea8
	ds $1

wdea9:: ; 0xdea9
	ds $1

wdeaa:: ; 0xdeaa
	ds $1

wdeab:: ; 0xdeab
	ds $1

wdeac:: ; 0xdeac
	ds $1

wdead:: ; 0xdead
	ds $1

wdeae:: ; 0xdeae
	ds $2

wMusicRAMEnd:: ; deb0
wdeb0:: ; 0xdeb0
	ds $50

SECTION "Stack", WRAMX [$dfff], BANK [1]
wStack:: ; 0xdfff
	ds -$ff
