hBoardYShift  EQU $FFA0  ; Vertical pixel offset of the board. For example, the board is shifted
                        ;  by small amounts when "tilt up" is used.
hBoardXShift  EQU $FFA1  ; Horizontal pixel offset of the board. For example, the board is shifted
                        ;  $20 pixels to the right when launching the ball at the start of a round.

hLoadedROMBank   EQU $FFF8  ; this is updated whenever the code switches ROM Banks
