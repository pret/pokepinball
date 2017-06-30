_LoadStageDataMewtwoBonus: ; 0x19310
	callba Func_142fc
	call Func_2862
	callba Func_1404a
	ld a, [wd7c1]
	and a
	ret z
	call Func_194ac
	ret
