Music_HaunterInTheGraveyard: ; 3dffc
	dbw $80, Music_HaunterInTheGraveyard_Ch1
	dbw $01, Music_HaunterInTheGraveyard_Ch2
	dbw $02, Music_HaunterInTheGraveyard_Ch3
; 3e005


Music_HaunterInTheGraveyard_Ch1: ; 3e005
	forceoctave $2
	callchannel Music_HaunterInTheGraveyard_branch_3ddf3

Music_HaunterInTheGraveyard_Ch2: ; 3e00a
	forceoctave $2
	callchannel Music_HaunterInTheGraveyard_branch_3de4c

Music_HaunterInTheGraveyard_Ch3: ; 3e00f
	forceoctave $2
	callchannel Music_HaunterInTheGraveyard_branch_3df1f


Music_GengarInTheGraveyard: ; 3e014
	dbw $c0, Music_GengarInTheGraveyard_Ch1
	dbw $01, Music_GengarInTheGraveyard_Ch2
	dbw $02, Music_GengarInTheGraveyard_Ch3
	dbw $03, Music_GengarInTheGraveyard_Ch4
; 3e020

Music_GengarInTheGraveyard_Ch1: ; 3e020
	tempo 124
	volume $77
	notetype $c, $b3
	dutycycle $3
	notetype $6, $21
	note __, 16
	octave 4
	note E_, 1
	note A_, 1
	intensity $48
	note E_, 1
	note A_, 1
	intensity $68
	note E_, 1
	note A_, 1
	intensity $88
	note E_, 1
	note A_, 1
	intensity $a8
	note E_, 1
	note A_, 1
	intensity $88
	note E_, 1
	note A_, 1
	intensity $68
	note E_, 1
	note A_, 1
	intensity $48
	note E_, 1
	note A_, 1
	intensity $28
	note F_, 1
	note G#, 1
	note F_, 1
	note G#, 1
	note F_, 1
	note G#, 1
	note F_, 1
	note G#, 1
	note F_, 1
	intensity $38
	note G#, 1
	note F_, 1
	note G#, 1
	note F_, 1
	intensity $48
	note G#, 1
	note F_, 1
	note G#, 1
	note F_, 1
	note G#, 1
	intensity $58
	note F_, 1
	note G#, 1
	intensity $68
	note F_, 1
	note G#, 1
	intensity $78
	note F_, 1
	note G#, 1
	intensity $88
	note F_, 1
	note G#, 1
	intensity $98
	note F_, 1
	note G#, 1
	intensity $a8
	note F_, 1
	note G#, 1
	intensity $b8
	note F_, 1
	note G#, 1

Music_GengarInTheGraveyard_branch_3e081: ; 3e081

Music_HaunterInTheGraveyard_branch_3e081: ; 3e081
	vibrato $8, $33
	intensity $81
	octave 2
	note F_, 2
	note F_, 1
	note __, 1
	note F_, 2
	note F_, 1
	note __, 1
	note F_, 2
	note F_, 1
	note __, 1
	note F_, 2
	note F_, 1
	note __, 1
	intensity $88
	octave 3
	note D_, 6
	octave 2
	note B_, 6
	note G#, 2
	note __, 2
	intensity $81
	note C_, 2
	note C_, 1
	note __, 1
	note C_, 2
	note C_, 1
	note __, 1
	note C_, 2
	note C_, 1
	note __, 1
	note C_, 2
	note C_, 1
	note __, 1
	intensity $88
	note A_, 6
	note F#, 6
	note D#, 2
	note __, 2
	loopchannel 2, Music_HaunterInTheGraveyard_branch_3e081
	callchannel Music_HaunterInTheGraveyard_branch_3e12f
	forceoctave $3
	callchannel Music_HaunterInTheGraveyard_branch_3e12f
	forceoctave $8
	callchannel Music_HaunterInTheGraveyard_branch_3e12f
	forceoctave $0
	intensity $88
	octave 4
	note C#, 4
	intensity $81
	octave 3
	note D#, 1
	note __, 1
	intensity $88
	octave 4
	note C_, 4
	intensity $81
	octave 3
	note D_, 1
	note __, 1
	intensity $88
	note B_, 4
	intensity $81
	note C#, 1
	note __, 1
	intensity $88
	note A#, 4
	intensity $81
	note C_, 1
	note __, 1
	intensity $88
	note A_, 2
	note G#, 2
	note G_, 2
	note F#, 2
	callchannel Music_HaunterInTheGraveyard_branch_3e14e
	intensity $81
	octave 2
	note C_, 2
	note C_, 1
	note __, 1
	octave 3
	note C_, 2
	octave 2
	note C_, 1
	note __, 1
	octave 3
	note C_, 2
	octave 2
	note C_, 1
	note __, 1
	note C_, 1
	note __, 1
	octave 3
	note C_, 2
	octave 2
	note C_, 1
	note __, 1
	note C#, 2
	note D_, 1
	note __, 1
	note D#, 2
	note E_, 1
	note __, 1
	note F_, 2
	note F#, 1
	note __, 1
	note G_, 2
	callchannel Music_HaunterInTheGraveyard_branch_3e14e
	intensity $88
	octave 2
	note B_, 2
	octave 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	octave 2
	note B_, 2
	octave 1
	note B_, 1
	note __, 1
	note B_, 1
	note __, 1
	vibrato $6, $53
	intensity $88
	octave 2
	note A#, 1
	note B_, 11
	note A#, 2
	note A_, 2
	note G#, 2
	note G_, 2
	loopchannel 0, Music_HaunterInTheGraveyard_branch_3e081
; 3e12f

Music_GengarInTheGraveyard_branch_3e12f: ; 3e12f

Music_HaunterInTheGraveyard_branch_3e12f: ; 3e12f
	intensity $88
	octave 3
	note C_, 4
	intensity $81
	octave 2
	note C_, 2
	note C_, 1
	note __, 1
	note C_, 2
	note C_, 1
	note __, 1
	note C_, 2
	note C_, 1
	note __, 1
	intensity $88
	octave 3
	note C_, 4
	intensity $81
	octave 2
	note C_, 2
	octave 3
	note C_, 2
	note __, 2
	intensity $88
	note F#, 6
	endchannel
; 3e14e

Music_GengarInTheGraveyard_branch_3e14e: ; 3e14e

Music_HaunterInTheGraveyard_branch_3e14e: ; 3e14e
	intensity $81
	octave 2
	note F_, 2
	note __, 2
	note F_, 2
	note F_, 2
	note G#, 2
	intensity $88
	note B_, 6
	intensity $81
	note F_, 2
	note __, 2
	note F_, 2
	note F_, 2
	note B_, 2
	intensity $88
	octave 3
	note D_, 6
	endchannel
; 3e165
