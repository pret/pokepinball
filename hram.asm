hJoypadState  EQU $FF98  ; current state of buttons. See joy_constants.asm for which bits
                         ; correspond to which buttons.
hNewlyPressedButtons      EQU $FF99  ; buttons that were pressed in the current frame.
hPressedButtons           EQU $FF9A  ; buttons that were pressed last frame and current frame(?)
hPrevPreviousJoypadState  EQU $FF9B  ; joypad state from two frames ago. See joy_constants.asm for
                                     ; which bits correspond to which buttons. (need a better name for this...)
hPreviousJoypadState  EQU $FF9C  ; prevoius frame's joypad state. See joy_constants.asm for
                                 ; which bits correspond to which buttons.

hBoardYShift  EQU $FFA0  ; Vertical pixel offset of the board. For example, the board is shifted
                        ;  by small amounts when "tilt up" is used.
hBoardXShift  EQU $FFA1  ; Horizontal pixel offset of the board. For example, the board is shifted
                        ;  $20 pixels to the right when launching the ball at the start of a round.

hLoadedROMBank   EQU $FFF8  ; this is updated whenever the code switches ROM Banks

hGameBoyColorFlag  EQU $FFFE  ; this is set to $01 if a GameBoy Color is running the game. $00, otherwise.
