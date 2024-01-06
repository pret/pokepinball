SECTION "HRAM", HRAM

hPushSprite :: ds 10 ; 0xFF80
.end ::

hFarCallTempA :: db ; 0xFF8A
hFarCallTempE :: db ; 0xFF8B

hRotationAngleBuffer :: db ; 0xFF8C
hCosineResultBuffer  :: dw ; 0xFF8D
hSineResultBuffer    :: dw ; 0xFF8F

ds 7

hJoypadState             :: db ; 0xFF98  ; current state of buttons. See joy_constants.asm for which bits
                                         ; correspond to which buttons.
hNewlyPressedButtons     :: db ; 0xFF99  ; buttons that were pressed in the current frame.
hPressedButtons          :: db ; 0xFF9A  ; buttons that were pressed last frame and current frame(?)
hPrevPreviousJoypadState :: db ; 0xFF9B  ; joypad state from two frames ago. See joy_constants.asm for
                                         ; which bits correspond to which buttons. (need a better name for this...)
hPreviousJoypadState     :: db ; 0xFF9C  ; previous frame's joypad state. See joy_constants.asm for
                                         ; which bits correspond to which buttons.

hJoyRepeatDelay :: db ; 0xFF9D

hLCDC               :: db ; 0xFF9E
hSTAT               :: db ; 0xFF9F
hSCY                :: db ; 0xFFA0
hSCX                :: db ; 0xFFA1
hLYC                :: db ; 0xFFA2
hBGP                :: db ; 0xFFA3
hOBP0               :: db ; 0xFFA4
hOBP1               :: db ; 0xFFA5
hWY                 :: db ; 0xFFA6
hWX                 :: db ; 0xFFA7
hLastLYC            :: db ; 0xFFA8
hNextLYCSub         :: db ; 0xFFA9
hLYCSub             :: db ; 0xFFAA
hNextFrameHBlankSCX :: db ; 0xFFAB
hHBlankSCX          :: db ; 0xFFAC
hNextFrameHBlankSCY :: db ; 0xFFAD
hHBlankSCY          :: db ; 0xFFAE
hLCDCMask           :: db ; 0xFFAF
hStatIntrRoutine    :: db ; 0xFFB0

ds 1

hNumFramesSinceLastVBlank :: db ; 0xFFB2
hFrameCounter             :: db ; 0xFFB3
hVBlankCount              :: db ; 0xFFB4
hStatIntrFired            :: db ; 0xFFB5
hSignedMathSignBuffer     :: db ; 0xFFB6
hSignedMathSignBuffer2    :: db ; 0xFFB7

ds 2

hBallXPos :: dw ; 0xFFBA
hBallYPos :: dw ; 0xFFBC

ds 1

hFlipperCollisionRadius  :: db ; 0xFFBF

hFlipperStateChange   :: dw ; 0xFFC0
hPreviousFlipperState :: db ; 0xFFC2
hFlipperState         :: db ; 0xFFC3

hFFC4 :: db ; 0xFFC4

SECTION "HRAM.2", HRAM

hLoadedROMBank          :: db ; 0xFFF8  ; this is updated whenever the code switches ROM Banks
ds 1
hROMBankBuffer          :: db ; 0xFFFA
hSGBFlag                :: db ; 0xFFFB
hSGBInit                :: db ; 0xFFFC
hGameBoyColorFlagBackup :: db ; 0xFFFD
hGameBoyColorFlag       :: db ; 0xFFFE  ; this is set to $01 if a GameBoy Color is running the game. $00, otherwise.
