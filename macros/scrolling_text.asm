; 6-byte header for scrolling text in the bottom message box. See LoadScrollingText, and wScrollingText1 for documentation.

; \1: Pause offset (number of tiles from the left of the screen)
; \2: Number of steps to pause
; \3: Text index the bottom text buffer (wBottomMessageText)
; \4: Number of steps after the Pause (text disappears after these number of steps)
scrolling_text_normal: MACRO
	scrolling_text 5, 20, \1, \2, \3, \4
	ENDM

; \1: Step delay (in frames)
; \2: Starting offset (number of tiles from the left of the screen)
; \3: Pause offset (stops scrolling in the middle of the screen)
; \4: Number of steps to pause
; \5: Text index the bottom text buffer (wBottomMessageText)
; \6: Number of steps after the Pause (text disappears after these number of steps)
scrolling_text: MACRO
	db \1
	db \2 + $40
	db \3 + $40
	db \4
	db \5 * $10
	db \6 + \4 + (\2 - \3)
	ENDM

; \1: Step delay (in frames)
; \2: Total number of steps before disappearing.
scrolling_text_nopause: MACRO
	db \1
	db 20 + $40
	db 0, 0, 0
	db \2
	ENDM

; \1: Offset (number of tiles from the left of the screen)
; \2: Raw text index the bottom text buffer (wBottomMessageText)
; \3: Number of frames to display the text.
stationary_text: MACRO
	db \1 + $40
	db \2 * $10
	dw \3
	ENDM
