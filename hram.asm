hPushOAM EQU $FF80

hFarCallTempA EQU $FF8A
hFarCallTempE EQU $FF8B
hJoypadState  EQU $FF98  ; current state of buttons. See joy_constants.asm for which bits
	                     ; correspond to which buttons.
hNewlyPressedButtons      EQU $FF99  ; buttons that were pressed in the current frame.
hPressedButtons           EQU $FF9A  ; buttons that were pressed last frame and current frame(?)
hPrevPreviousJoypadState  EQU $FF9B  ; joypad state from two frames ago. See joy_constants.asm for
	                                 ; which bits correspond to which buttons. (need a better name for this...)
hPreviousJoypadState  EQU $FF9C  ; prevoius frame's joypad state. See joy_constants.asm for
	                             ; which bits correspond to which buttons.
hJoyRepeatDelay EQU $FF9D

hLCDC               EQU $FF9E
hSTAT               EQU $FF9F
hSCY                EQU $FFA0
hSCX                EQU $FFA1
hLYC                EQU $FFA2
hBGP                EQU $FFA3
hOBP0               EQU $FFA4
hOBP1               EQU $FFA5
hWY                 EQU $FFA6
hWX                 EQU $FFA7
hLastLYC            EQU $FFA8
hNextLYCSub         EQU $FFA9
hLYCSub             EQU $FFAA
hNextFrameHBlankSCX EQU $FFAB
hHBlankSCX          EQU $FFAC
hNextFrameHBlankSCY EQU $FFAD
hHBlankSCY          EQU $FFAE
hLCDCMask           EQU $FFAF
hStatIntrRoutine    EQU $FFB0

hNumFramesSinceLastVBlank EQU $FFB2
hNumFramesDropped         EQU $FFB3
hVBlankCount              EQU $FFB4
hStatIntrFired            EQU $FFB5
hSignedMathSignBuffer     EQU $FFB6
hSignedMathSignBuffer2    EQU $FFB7

hSineOrCosineArgumentBuffer EQU $FF8C
hCosineResultBuffer         EQU $FF8D
hSineResultBuffer           EQU $FF8F

hFlipperYCollisionAttribute  EQU $FFBF  ; Vertical collision attribute for when ball collides with a flipper.

hFFC4 = $FFC4

hLoadedROMBank          EQU $FFF8  ; this is updated whenever the code switches ROM Banks
hROMBankBuffer          EQU $FFFA
hSGBFlag                EQU $FFFB
hSGBInit                EQU $FFFC
hGameBoyColorFlagBackup EQU $FFFD
hGameBoyColorFlag       EQU $FFFE  ; this is set to $01 if a GameBoy Color is running the game. $00, otherwise.
