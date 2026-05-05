	dw .Drumkit0
	dw .Drumkit1
	dw .Drumkit2
	dw .Drumkit2
	dw .Drumkit2
	dw .Drumkit2

.Drumkit0:
	dw .Drum00
	dw .Drum01
	dw .Drum02
	dw .Drum03
	dw .Drum04
	dw .Drum05
	dw .Drum06
	dw .Drum07
	dw .Drum08
	dw .Drum09
	dw .Drum10
	dw .Drum11
	dw .Drum12
	dw .Drum00
	dw .Drum00
	dw .Drum00

.Drumkit1:
	dw .Drum00
	dw .Drum06
	dw .Drum02
	dw .Drum03
	dw .Drum04
	dw .Drum13
	dw .Drum14
	dw .Drum15
	dw .Drum16
	dw .Drum17
	dw .Drum18
	dw .Drum11
	dw .Drum19
	dw .Drum00
	dw .Drum00
	dw .Drum00

.Drumkit2:
	dw .Drum00
	dw .Drum10
	dw .Drum11
	dw .Drum03
	dw .Drum04
	dw .Drum20
	dw .Drum21
	dw .Drum22
	dw .Drum08
	dw .Drum09
	dw .Drum23
	dw .Drum24
	dw .Drum25
	dw .Drum00
	dw .Drum00
	dw .Drum00

.Drum06:
	noise_note 32, 1, 1, 17
	sound_ret

.Drum00:
	sound_ret

.Drum01:
	noise_note 32, 9, 1, 51
	sound_ret

.Drum02:
	noise_note 32, 5, 1, 50
	sound_ret

.Drum03:
	noise_note 32, 8, 1, 49
	sound_ret

.Drum04:
	noise_note 33, 7, 1, 112
	noise_note 32, 1, 1, 17
	sound_ret

.Drum05:
	noise_note 48, 8, 2, 76
	noise_note 34, 6, 1, 32
	sound_ret

.Drum14:
	noise_note 48, 9, 1, 24
	sound_ret

.Drum07:
	noise_note 39, 9, 2, 16
	sound_ret

.Drum08:
	noise_note 51, 9, 1, 0
	noise_note 51, 1, 1, 0
	sound_ret

.Drum09:
	noise_note 51, 9, 1, 17
	noise_note 51, 1, 1, 0
	sound_ret

.Drum10:
	noise_note 1, 1, 8, 1
	sound_ret

.Drum11:
	noise_note 1, 2, 8, 1
	sound_ret

.Drum19:
	noise_note 51, 8, 8, 21
	noise_note 32, 6, 5, 18
	sound_ret

.Drum16:
	noise_note 51, 5, 1, 33
	noise_note 51, 1, 1, 17
	sound_ret

.Drum17:
	noise_note 51, 5, 1, 80
	noise_note 51, 1, 1, 17
	sound_ret

.Drum13:
	noise_note 32, 10, 1, 49
	sound_ret

.Drum12:
	noise_note 32, 8, 4, 18
	sound_ret

.Drum15:
	noise_note 51, 8, 1, 0
	noise_note 51, 1, 1, 0
	sound_ret

.Drum20:
	noise_note 1, 3, 8, 1
	sound_ret

.Drum21:
	noise_note 1, 4, 8, 1
	sound_ret

.Drum22:
	noise_note 1, 5, 8, 1
	sound_ret

.Drum23:
	noise_note 1, 6, 8, 1
	sound_ret

.Drum24:
	noise_note 1, 7, 8, 1
	sound_ret

.Drum25:
	noise_note 1, 8, 8, 1
	sound_ret

.Drum18:
	noise_note 51, 8, 1, 33
	noise_note 51, 1, 1, 17
	sound_ret
