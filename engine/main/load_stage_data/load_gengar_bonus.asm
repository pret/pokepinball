_LoadStageDataGengarBonus: ; 0x1818b
	callba Func_142fc
	call Func_2862
	call Func_18d72
	ld a, [wd7c1]
	callba Func_1404a
	and a
	ret z
	call Func_183db
	call Func_18d91
	ret
