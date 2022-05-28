DEF hPushOAM EQU $FF80

DEF hFarCallTempA EQU $FF8A
DEF hFarCallTempE EQU $FF8B
DEF hJoypadState  EQU $FF98  ; current state of buttons. See joy_constants.asm for which bits
                             ; correspond to which buttons.
DEF hNewlyPressedButtons      EQU $FF99  ; buttons that were pressed in the current frame.
DEF hPressedButtons           EQU $FF9A  ; buttons that were pressed last frame and current frame(?)
DEF hPrevPreviousJoypadState  EQU $FF9B  ; joypad state from two frames ago. See joy_constants.asm for
                                         ; which bits correspond to which buttons. (need a better name for this...)
DEF hPreviousJoypadState  EQU $FF9C      ; prevoius frame's joypad state. See joy_constants.asm for
                                         ; which bits correspond to which buttons.

DEF hJoyRepeatDelay EQU $FF9D

DEF hLCDC               EQU $FF9E
DEF hSTAT               EQU $FF9F
DEF hSCY                EQU $FFA0
DEF hSCX                EQU $FFA1
DEF hLYC                EQU $FFA2
DEF hBGP                EQU $FFA3
DEF hOBP0               EQU $FFA4
DEF hOBP1               EQU $FFA5
DEF hWY                 EQU $FFA6
DEF hWX                 EQU $FFA7
DEF hLastLYC            EQU $FFA8
DEF hNextLYCSub         EQU $FFA9
DEF hLYCSub             EQU $FFAA
DEF hNextFrameHBlankSCX EQU $FFAB
DEF hHBlankSCX          EQU $FFAC
DEF hNextFrameHBlankSCY EQU $FFAD
DEF hHBlankSCY          EQU $FFAE
DEF hLCDCMask           EQU $FFAF
DEF hStatIntrRoutine    EQU $FFB0

DEF hNumFramesSinceLastVBlank EQU $FFB2
DEF hFrameCounter             EQU $FFB3
DEF hVBlankCount              EQU $FFB4
DEF hStatIntrFired            EQU $FFB5
DEF hSignedMathSignBuffer     EQU $FFB6
DEF hSignedMathSignBuffer2    EQU $FFB7

DEF hBallXPos EQU $FFBA
DEF hBallYPos EQU $FFBC

DEF hFlipperStateChange   EQU $FFC0
DEF hPreviousFlipperState EQU $FFC2
DEF hFlipperState         EQU $FFC3

DEF hRotationAngleBuffer EQU $FF8C
DEF hCosineResultBuffer  EQU $FF8D
DEF hSineResultBuffer    EQU $FF8F

DEF hFlipperCollisionRadius  EQU $FFBF

DEF hFFC4 = $FFC4

DEF hLoadedROMBank          EQU $FFF8  ; this is updated whenever the code switches ROM Banks
DEF hROMBankBuffer          EQU $FFFA
DEF hSGBFlag                EQU $FFFB
DEF hSGBInit                EQU $FFFC
DEF hGameBoyColorFlagBackup EQU $FFFD
DEF hGameBoyColorFlag       EQU $FFFE  ; this is set to $01 if a GameBoy Color is running the game. $00, otherwise.
