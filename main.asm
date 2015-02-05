INCLUDE "constants.asm"

SECTION "Home", ROM0

INCBIN "bin/0_3fff.bin" ; 0x0


SECTION "bank1", ROMX, BANK[$1]

INCBIN "bin/4000_7fff.bin" ; 0x4000


SECTION "bank2", ROMX, BANK[$2]

INCBIN "bin/8000_bfff.bin" ; 0x8000


SECTION "bank3", ROMX, BANK[$3]

INCBIN "bin/c000_ffff.bin" ; 0xc000


SECTION "bank4", ROMX, BANK[$4]

INCBIN "bin/10000_13fff.bin" ; 0x10000


SECTION "bank5", ROMX, BANK[$5]

INCBIN "bin/14000_17fff.bin" ; 0x14000


SECTION "bank6", ROMX, BANK[$6]

INCBIN "bin/18000_1bfff.bin" ; 0x18000


SECTION "bank7", ROMX, BANK[$7]

INCBIN "bin/1c000_1ffff.bin" ; 0x1c000


SECTION "bank8", ROMX, BANK[$8]

INCBIN "bin/20000_23fff.bin" ; 0x20000


SECTION "bank9", ROMX, BANK[$9]

INCBIN "bin/24000_27fff.bin" ; 0x24000


SECTION "banka", ROMX, BANK[$a]

INCBIN "bin/28000_2bfff.bin" ; 0x28000


SECTION "bankb", ROMX, BANK[$b]

INCBIN "bin/2c000_2ffff.bin" ; 0x2c000


SECTION "bankc", ROMX, BANK[$c]

INCBIN "bin/30000_33fff.bin" ; 0x30000


SECTION "bankd", ROMX, BANK[$d]

INCBIN "bin/34000_37fff.bin" ; 0x34000


SECTION "banke", ROMX, BANK[$e]

INCBIN "bin/38000_3bfff.bin" ; 0x38000


SECTION "bankf", ROMX, BANK[$f]

INCBIN "bin/3c000_3ffff.bin" ; 0x3c000


SECTION "bank10", ROMX, BANK[$10]

INCBIN "bin/40000_43fff.bin" ; 0x40000


SECTION "bank11", ROMX, BANK[$11]

INCBIN "bin/44000_47fff.bin" ; 0x44000


SECTION "bank12", ROMX, BANK[$12]

INCBIN "bin/48000_4bfff.bin" ; 0x48000


SECTION "bank13", ROMX, BANK[$13]

INCBIN "bin/4c000_4ffff.bin" ; 0x4c000


SECTION "bank14", ROMX, BANK[$14]

INCBIN "bin/50000_53fff.bin" ; 0x50000


SECTION "bank15", ROMX, BANK[$15]

INCBIN "bin/54000_57fff.bin" ; 0x54000


SECTION "bank16", ROMX, BANK[$16]

INCBIN "bin/58000_5bfff.bin" ; 0x58000


SECTION "bank17", ROMX, BANK[$17]

INCBIN "bin/5c000_5ffff.bin" ; 0x5c000


SECTION "bank18", ROMX, BANK[$18]

VenomothPic: ; 0x60000
	INCBIN "gfx/billboard/mon_pics/venomoth.2bpp"
VenomothSilhouettePic: ; 0x60180
	INCBIN "gfx/billboard/mon_silhouettes/venomoth.2bpp"
DiglettPic: ; 0x60300
	INCBIN "gfx/billboard/mon_pics/diglett.2bpp"
DiglettSilhouettePic: ; 0x60480
	INCBIN "gfx/billboard/mon_silhouettes/diglett.2bpp"
DugtrioPic: ; 0x60600
	INCBIN "gfx/billboard/mon_pics/dugtrio.2bpp"
DugtrioSilhouettePic: ; 0x60780
	INCBIN "gfx/billboard/mon_silhouettes/dugtrio.2bpp"
MeowthPic: ; 0x60900
	INCBIN "gfx/billboard/mon_pics/meowth.2bpp"
MeowthSilhouettePic: ; 0x60a80
	INCBIN "gfx/billboard/mon_silhouettes/meowth.2bpp"
PersianPic: ; 0x60c00
	INCBIN "gfx/billboard/mon_pics/persian.2bpp"
PersianSilhouettePic: ; 0x60d80
	INCBIN "gfx/billboard/mon_silhouettes/persian.2bpp"
PsyduckPic: ; 0x60f00
	INCBIN "gfx/billboard/mon_pics/psyduck.2bpp"
PsyduckSilhouettePic: ; 0x61080
	INCBIN "gfx/billboard/mon_silhouettes/psyduck.2bpp"
GolduckPic: ; 0x61200
	INCBIN "gfx/billboard/mon_pics/golduck.2bpp"
GolduckSilhouettePic:  ; 0x61380
	INCBIN "gfx/billboard/mon_silhouettes/golduck.2bpp"
MankeyPic: ; 0x61500
	INCBIN "gfx/billboard/mon_pics/mankey.2bpp"
MankeySilhouettePic: ; 0x61680
	INCBIN "gfx/billboard/mon_silhouettes/mankey.2bpp"
PrimeapePic: ; 0x61800
	INCBIN "gfx/billboard/mon_pics/primeape.2bpp"
PrimeapeSilhouettePic: ; 0x61980
	INCBIN "gfx/billboard/mon_silhouettes/primeape.2bpp"
GrowlithePic: ; 0x61b00
	INCBIN "gfx/billboard/mon_pics/growlithe.2bpp"
GrowlitheSilhouettePic: ; 0x61c80
	INCBIN "gfx/billboard/mon_silhouettes/growlithe.2bpp"
ArcaninePic: ; 0x61e00
	INCBIN "gfx/billboard/mon_pics/arcanine.2bpp"
ArcanineSilhouettePic: ; 0x61f80
	INCBIN "gfx/billboard/mon_silhouettes/arcanine.2bpp"
PoliwagPic: ; 0x62100
	INCBIN "gfx/billboard/mon_pics/poliwag.2bpp"
PoliwagSilhouettePic: ; 0x62280
	INCBIN "gfx/billboard/mon_silhouettes/poliwag.2bpp"
PoliwhirlPic: ; 0x62400
	INCBIN "gfx/billboard/mon_pics/poliwhirl.2bpp"
PoliwhirlSilhouettePic: ; 0x62580
	INCBIN "gfx/billboard/mon_silhouettes/poliwhirl.2bpp"
PoliwrathPic: ; 0x62700
	INCBIN "gfx/billboard/mon_pics/poliwrath.2bpp"
PoliwrathSilhouettePic: ; 0x62880
	INCBIN "gfx/billboard/mon_silhouettes/poliwrath.2bpp"
AbraPic: ; 0x62a00
	INCBIN "gfx/billboard/mon_pics/abra.2bpp"
AbraSilhouettePic: ; 0x62b80
	INCBIN "gfx/billboard/mon_silhouettes/abra.2bpp"
KadabraPic: ; 0x62d00
	INCBIN "gfx/billboard/mon_pics/kadabra.2bpp"
KadabraSilhouettePic: ; 0x62e80
	INCBIN "gfx/billboard/mon_silhouettes/kadabra.2bpp"

INCBIN "bin/63000_63fff.bin" ; 0x63000


SECTION "bank19", ROMX, BANK[$19]

NidorinoPic: ; 0x64000
	INCBIN "gfx/billboard/mon_pics/nidorino.2bpp"
NidorinoSilhouettePic: ; 0x64180
	INCBIN "gfx/billboard/mon_silhouettes/nidorino.2bpp"
NidokingPic: ; 0x64300
	INCBIN "gfx/billboard/mon_pics/nidoking.2bpp"
NidokingSilhouettePic: ; 0x64480
	INCBIN "gfx/billboard/mon_silhouettes/nidoking.2bpp"
ClefairyPic: ; 0x64600
	INCBIN "gfx/billboard/mon_pics/clefairy.2bpp"
ClefairySilhouettePic: ; 0x64780
	INCBIN "gfx/billboard/mon_silhouettes/clefairy.2bpp"
ClefablePic: ; 0x64900
	INCBIN "gfx/billboard/mon_pics/clefable.2bpp"
ClefableSilhouettePic: ; 0x64a80
	INCBIN "gfx/billboard/mon_silhouettes/clefable.2bpp"
VulpixPic: ; 0x64c00
	INCBIN "gfx/billboard/mon_pics/vulpix.2bpp"
VulpixSilhouettePic: ; 0x64d80
	INCBIN "gfx/billboard/mon_silhouettes/vulpix.2bpp"
NinetalesPic: ; 0x64f00
	INCBIN "gfx/billboard/mon_pics/ninetales.2bpp"
NinetalesSilhouettePic: ; 0x65080
	INCBIN "gfx/billboard/mon_silhouettes/ninetales.2bpp"
JigglypuffPic: ; 0x65200
	INCBIN "gfx/billboard/mon_pics/jigglypuff.2bpp"
JigglypuffSilhouettePic:  ; 0x65380
	INCBIN "gfx/billboard/mon_silhouettes/jigglypuff.2bpp"
WigglytuffPic: ; 0x65500
	INCBIN "gfx/billboard/mon_pics/wigglytuff.2bpp"
WigglytuffSilhouettePic: ; 0x65680
	INCBIN "gfx/billboard/mon_silhouettes/wigglytuff.2bpp"
ZubatPic: ; 0x65800
	INCBIN "gfx/billboard/mon_pics/zubat.2bpp"
ZubatSilhouettePic: ; 0x65980
	INCBIN "gfx/billboard/mon_silhouettes/zubat.2bpp"
GolbatPic: ; 0x65b00
	INCBIN "gfx/billboard/mon_pics/golbat.2bpp"
GolbatSilhouettePic: ; 0x65c80
	INCBIN "gfx/billboard/mon_silhouettes/golbat.2bpp"
OddishPic: ; 0x65e00
	INCBIN "gfx/billboard/mon_pics/oddish.2bpp"
OddishSilhouettePic: ; 0x65f80
	INCBIN "gfx/billboard/mon_silhouettes/oddish.2bpp"
GloomPic: ; 0x66100
	INCBIN "gfx/billboard/mon_pics/gloom.2bpp"
GloomSilhouettePic: ; 0x66280
	INCBIN "gfx/billboard/mon_silhouettes/gloom.2bpp"
VileplumePic: ; 0x66400
	INCBIN "gfx/billboard/mon_pics/vileplume.2bpp"
VileplumeSilhouettePic: ; 0x66580
	INCBIN "gfx/billboard/mon_silhouettes/vileplume.2bpp"
ParasPic: ; 0x66700
	INCBIN "gfx/billboard/mon_pics/paras.2bpp"
ParasSilhouettePic: ; 0x66880
	INCBIN "gfx/billboard/mon_silhouettes/paras.2bpp"
ParasectPic: ; 0x66a00
	INCBIN "gfx/billboard/mon_pics/parasect.2bpp"
ParasectSilhouettePic: ; 0x66b80
	INCBIN "gfx/billboard/mon_silhouettes/parasect.2bpp"
VenonatPic: ; 0x66d00
	INCBIN "gfx/billboard/mon_pics/venonat.2bpp"
VenonatSilhouettePic: ; 0x66e80
	INCBIN "gfx/billboard/mon_silhouettes/venonat.2bpp"

INCBIN "bin/67000_67fff.bin" ; 0x67000


SECTION "bank1a", ROMX, BANK[$1a]

ChanseyPic: ; 0x68000
	INCBIN "gfx/billboard/mon_pics/chansey.2bpp"
ChanseySilhouettePic: ; 0x68180
	INCBIN "gfx/billboard/mon_silhouettes/chansey.2bpp"
TangelaPic: ; 0x68300
	INCBIN "gfx/billboard/mon_pics/tangela.2bpp"
TangelaSilhouettePic: ; 0x68480
	INCBIN "gfx/billboard/mon_silhouettes/tangela.2bpp"
KangaskhanPic: ; 0x68600
	INCBIN "gfx/billboard/mon_pics/kangaskhan.2bpp"
KangaskhanSilhouettePic: ; 0x68780
	INCBIN "gfx/billboard/mon_silhouettes/kangaskhan.2bpp"
HorseaPic: ; 0x68900
	INCBIN "gfx/billboard/mon_pics/horsea.2bpp"
HorseaSilhouettePic: ; 0x68a80
	INCBIN "gfx/billboard/mon_silhouettes/horsea.2bpp"
SeadraPic: ; 0x68c00
	INCBIN "gfx/billboard/mon_pics/seadra.2bpp"
SeadraSilhouettePic: ; 0x68d80
	INCBIN "gfx/billboard/mon_silhouettes/seadra.2bpp"
GoldeenPic: ; 0x68f00
	INCBIN "gfx/billboard/mon_pics/goldeen.2bpp"
GoldeenSilhouettePic: ; 0x69080
	INCBIN "gfx/billboard/mon_silhouettes/goldeen.2bpp"
SeakingPic: ; 0x69200
	INCBIN "gfx/billboard/mon_pics/seaking.2bpp"
SeakingSilhouettePic:  ; 0x69380
	INCBIN "gfx/billboard/mon_silhouettes/seaking.2bpp"
StaryuPic: ; 0x69500
	INCBIN "gfx/billboard/mon_pics/staryu.2bpp"
StaryuSilhouettePic: ; 0x69680
	INCBIN "gfx/billboard/mon_silhouettes/staryu.2bpp"
StarmiePic: ; 0x69800
	INCBIN "gfx/billboard/mon_pics/starmie.2bpp"
StarmieSilhouettePic: ; 0x69980
	INCBIN "gfx/billboard/mon_silhouettes/starmie.2bpp"
Mr_MimePic: ; 0x69b00
	INCBIN "gfx/billboard/mon_pics/mr_mime.2bpp"
Mr_MimeSilhouettePic: ; 0x69c80
	INCBIN "gfx/billboard/mon_silhouettes/mr_mime.2bpp"
ScytherPic: ; 0x69e00
	INCBIN "gfx/billboard/mon_pics/scyther.2bpp"
ScytherSilhouettePic: ; 0x69f80
	INCBIN "gfx/billboard/mon_silhouettes/scyther.2bpp"
JynxPic: ; 0x6a100
	INCBIN "gfx/billboard/mon_pics/jynx.2bpp"
JynxSilhouettePic: ; 0x6a280
	INCBIN "gfx/billboard/mon_silhouettes/jynx.2bpp"
ElectabuzzPic: ; 0x6a400
	INCBIN "gfx/billboard/mon_pics/electabuzz.2bpp"
ElectabuzzSilhouettePic: ; 0x6a580
	INCBIN "gfx/billboard/mon_silhouettes/electabuzz.2bpp"
MagmarPic: ; 0x6a700
	INCBIN "gfx/billboard/mon_pics/magmar.2bpp"
MagmarSilhouettePic: ; 0x6a880
	INCBIN "gfx/billboard/mon_silhouettes/magmar.2bpp"
PinsirPic: ; 0x6aa00
	INCBIN "gfx/billboard/mon_pics/pinsir.2bpp"
PinsirSilhouettePic: ; 0x6ab80
	INCBIN "gfx/billboard/mon_silhouettes/pinsir.2bpp"
TaurosPic: ; 0x6ad00
	INCBIN "gfx/billboard/mon_pics/tauros.2bpp"
TaurosSilhouettePic: ; 0x6ae80
	INCBIN "gfx/billboard/mon_silhouettes/tauros.2bpp"

INCBIN "bin/6b000_6bfff.bin" ; 0x6b000


SECTION "bank1b", ROMX, BANK[$1b]

MagikarpPic: ; 0x6c000
	INCBIN "gfx/billboard/mon_pics/magikarp.2bpp"
MagikarpSilhouettePic: ; 0x6c180
	INCBIN "gfx/billboard/mon_silhouettes/magikarp.2bpp"
GyaradosPic: ; 0x6c300
	INCBIN "gfx/billboard/mon_pics/gyarados.2bpp"
GyaradosSilhouettePic: ; 0x6c480
	INCBIN "gfx/billboard/mon_silhouettes/gyarados.2bpp"
LaprasPic: ; 0x6c600
	INCBIN "gfx/billboard/mon_pics/lapras.2bpp"
LaprasSilhouettePic: ; 0x6c780
	INCBIN "gfx/billboard/mon_silhouettes/lapras.2bpp"
DittoPic: ; 0x6c900
	INCBIN "gfx/billboard/mon_pics/ditto.2bpp"
DittoSilhouettePic: ; 0x6ca80
	INCBIN "gfx/billboard/mon_silhouettes/ditto.2bpp"
EeveePic: ; 0x6cc00
	INCBIN "gfx/billboard/mon_pics/eevee.2bpp"
EeveeSilhouettePic: ; 0x6cd80
	INCBIN "gfx/billboard/mon_silhouettes/eevee.2bpp"
VaporeonPic: ; 0x6cf00
	INCBIN "gfx/billboard/mon_pics/vaporeon.2bpp"
VaporeonSilhouettePic: ; 0x6d080
	INCBIN "gfx/billboard/mon_silhouettes/vaporeon.2bpp"
JolteonPic: ; 0x6d200
	INCBIN "gfx/billboard/mon_pics/jolteon.2bpp"
JolteonSilhouettePic:  ; 0x6d380
	INCBIN "gfx/billboard/mon_silhouettes/jolteon.2bpp"
FlareonPic: ; 0x6d500
	INCBIN "gfx/billboard/mon_pics/flareon.2bpp"
FlareonSilhouettePic: ; 0x6d680
	INCBIN "gfx/billboard/mon_silhouettes/flareon.2bpp"
PorygonPic: ; 0x6d800
	INCBIN "gfx/billboard/mon_pics/porygon.2bpp"
PorygonSilhouettePic: ; 0x6d980
	INCBIN "gfx/billboard/mon_silhouettes/porygon.2bpp"
OmanytePic: ; 0x6db00
	INCBIN "gfx/billboard/mon_pics/omanyte.2bpp"
OmanyteSilhouettePic: ; 0x6dc80
	INCBIN "gfx/billboard/mon_silhouettes/omanyte.2bpp"
OmastarPic: ; 0x6de00
	INCBIN "gfx/billboard/mon_pics/omastar.2bpp"
OmastarSilhouettePic: ; 0x6df80
	INCBIN "gfx/billboard/mon_silhouettes/omastar.2bpp"
KabutoPic: ; 0x6e100
	INCBIN "gfx/billboard/mon_pics/kabuto.2bpp"
KabutoSilhouettePic: ; 0x6e280
	INCBIN "gfx/billboard/mon_silhouettes/kabuto.2bpp"
KabutopsPic: ; 0x6e400
	INCBIN "gfx/billboard/mon_pics/kabutops.2bpp"
KabutopsSilhouettePic: ; 0x6e580
	INCBIN "gfx/billboard/mon_silhouettes/kabutops.2bpp"
AerodactylPic: ; 0x6e700
	INCBIN "gfx/billboard/mon_pics/aerodactyl.2bpp"
AerodactylSilhouettePic: ; 0x6e880
	INCBIN "gfx/billboard/mon_silhouettes/aerodactyl.2bpp"
SnorlaxPic: ; 0x6ea00
	INCBIN "gfx/billboard/mon_pics/snorlax.2bpp"
SnorlaxSilhouettePic: ; 0x6eb80
	INCBIN "gfx/billboard/mon_silhouettes/snorlax.2bpp"
ArticunoPic: ; 0x6ed00
	INCBIN "gfx/billboard/mon_pics/articuno.2bpp"
ArticunoSilhouettePic: ; 0x6ee80
	INCBIN "gfx/billboard/mon_silhouettes/articuno.2bpp"

INCBIN "bin/6f000_6ffff.bin" ; 0x6f000


SECTION "bank1c", ROMX, BANK[$1c]

ZapdosPic: ; 0x70000
	INCBIN "gfx/billboard/mon_pics/zapdos.2bpp"
ZapdosSilhouettePic: ; 0x70180
	INCBIN "gfx/billboard/mon_silhouettes/zapdos.2bpp"
MoltresPic: ; 0x70300
	INCBIN "gfx/billboard/mon_pics/moltres.2bpp"
MoltresSilhouettePic: ; 0x70480
	INCBIN "gfx/billboard/mon_silhouettes/moltres.2bpp"
DratiniPic: ; 0x70600
	INCBIN "gfx/billboard/mon_pics/dratini.2bpp"
DratiniSilhouettePic: ; 0x70780
	INCBIN "gfx/billboard/mon_silhouettes/dratini.2bpp"
DragonairPic: ; 0x70900
	INCBIN "gfx/billboard/mon_pics/dragonair.2bpp"
DragonairSilhouettePic: ; 0x70a80
	INCBIN "gfx/billboard/mon_silhouettes/dragonair.2bpp"
DragonitePic: ; 0x70c00
	INCBIN "gfx/billboard/mon_pics/dragonite.2bpp"
DragoniteSilhouettePic: ; 0x70d80
	INCBIN "gfx/billboard/mon_silhouettes/dragonite.2bpp"
MewtwoPic: ; 0x70f00
	INCBIN "gfx/billboard/mon_pics/mewtwo.2bpp"
MewtwoSilhouettePic: ; 0x71080
	INCBIN "gfx/billboard/mon_silhouettes/mewtwo.2bpp"
MewPic: ; 0x71200
	INCBIN "gfx/billboard/mon_pics/mew.2bpp"
MewSilhouettePic:  ; 0x71380
	INCBIN "gfx/billboard/mon_silhouettes/mew.2bpp"

INCBIN "bin/71500_73fff.bin" ; 0x71500


SECTION "bank1d", ROMX, BANK[$1d]

PidgeottoPic: ; 0x74000
	INCBIN "gfx/billboard/mon_pics/pidgeotto.2bpp"
PidgeottoSilhouettePic: ; 0x74180
	INCBIN "gfx/billboard/mon_silhouettes/pidgeotto.2bpp"
PidgeotPic: ; 0x74300
	INCBIN "gfx/billboard/mon_pics/pidgeot.2bpp"
PidgeotSilhouettePic: ; 0x74480
	INCBIN "gfx/billboard/mon_silhouettes/pidgeot.2bpp"
RattataPic: ; 0x74600
	INCBIN "gfx/billboard/mon_pics/rattata.2bpp"
RattataSilhouettePic: ; 0x74780
	INCBIN "gfx/billboard/mon_silhouettes/rattata.2bpp"
RaticatePic: ; 0x74900
	INCBIN "gfx/billboard/mon_pics/raticate.2bpp"
RaticateSilhouettePic: ; 0x74a80
	INCBIN "gfx/billboard/mon_silhouettes/raticate.2bpp"
SpearowPic: ; 0x74c00
	INCBIN "gfx/billboard/mon_pics/spearow.2bpp"
SpearowSilhouettePic: ; 0x74d80
	INCBIN "gfx/billboard/mon_silhouettes/spearow.2bpp"
FearowPic: ; 0x74f00
	INCBIN "gfx/billboard/mon_pics/fearow.2bpp"
FearowSilhouettePic: ; 0x75080
	INCBIN "gfx/billboard/mon_silhouettes/fearow.2bpp"
EkansPic: ; 0x75200
	INCBIN "gfx/billboard/mon_pics/ekans.2bpp"
EkansSilhouettePic:  ; 0x75380
	INCBIN "gfx/billboard/mon_silhouettes/ekans.2bpp"
ArbokPic: ; 0x75500
	INCBIN "gfx/billboard/mon_pics/arbok.2bpp"
ArbokSilhouettePic: ; 0x75680
	INCBIN "gfx/billboard/mon_silhouettes/arbok.2bpp"
PikachuPic: ; 0x75800
	INCBIN "gfx/billboard/mon_pics/pikachu.2bpp"
PikachuSilhouettePic: ; 0x75980
	INCBIN "gfx/billboard/mon_silhouettes/pikachu.2bpp"
RaichuPic: ; 0x75b00
	INCBIN "gfx/billboard/mon_pics/raichu.2bpp"
RaichuSilhouettePic: ; 0x75c80
	INCBIN "gfx/billboard/mon_silhouettes/raichu.2bpp"
SandshrewPic: ; 0x75e00
	INCBIN "gfx/billboard/mon_pics/sandshrew.2bpp"
SandshrewSilhouettePic: ; 0x75f80
	INCBIN "gfx/billboard/mon_silhouettes/sandshrew.2bpp"
SandslashPic: ; 0x76100
	INCBIN "gfx/billboard/mon_pics/sandslash.2bpp"
SandslashSilhouettePic: ; 0x76280
	INCBIN "gfx/billboard/mon_silhouettes/sandslash.2bpp"
Nidoran_FPic: ; 0x76400
	INCBIN "gfx/billboard/mon_pics/nidoran_f.2bpp"
Nidoran_FSilhouettePic: ; 0x76580
	INCBIN "gfx/billboard/mon_silhouettes/nidoran_f.2bpp"
NidorinaPic: ; 0x76700
	INCBIN "gfx/billboard/mon_pics/nidorina.2bpp"
NidorinaSilhouettePic: ; 0x76880
	INCBIN "gfx/billboard/mon_silhouettes/nidorina.2bpp"
NidoqueenPic: ; 0x76a00
	INCBIN "gfx/billboard/mon_pics/nidoqueen.2bpp"
NidoqueenSilhouettePic: ; 0x76b80
	INCBIN "gfx/billboard/mon_silhouettes/nidoqueen.2bpp"
Nidoran_MPic: ; 0x76d00
	INCBIN "gfx/billboard/mon_pics/nidoran_m.2bpp"
Nidoran_MSilhouettePic: ; 0x76e80
	INCBIN "gfx/billboard/mon_silhouettes/nidoran_m.2bpp"

INCBIN "bin/77000_77fff.bin" ; 0x77000


SECTION "bank1e", ROMX, BANK[$1e]

BulbasaurPic: ; 0x78000
	INCBIN "gfx/billboard/mon_pics/bulbasaur.2bpp"
BulbasaurSilhouettePic: ; 0x78180
	INCBIN "gfx/billboard/mon_silhouettes/bulbasaur.2bpp"
IvysaurPic: ; 0x78300
	INCBIN "gfx/billboard/mon_pics/ivysaur.2bpp"
IvysaurSilhouettePic: ; 0x78480
	INCBIN "gfx/billboard/mon_silhouettes/ivysaur.2bpp"
VenusaurPic: ; 0x78600
	INCBIN "gfx/billboard/mon_pics/venusaur.2bpp"
VenusaurSilhouettePic: ; 0x78780
	INCBIN "gfx/billboard/mon_silhouettes/venusaur.2bpp"
CharmanderPic: ; 0x78900
	INCBIN "gfx/billboard/mon_pics/charmander.2bpp"
CharmanderSilhouettePic: ; 0x78a80
	INCBIN "gfx/billboard/mon_silhouettes/charmander.2bpp"
CharmeleonPic: ; 0x78c00
	INCBIN "gfx/billboard/mon_pics/charmeleon.2bpp"
CharmeleonSilhouettePic: ; 0x78d80
	INCBIN "gfx/billboard/mon_silhouettes/charmeleon.2bpp"
CharizardPic: ; 0x78f00
	INCBIN "gfx/billboard/mon_pics/charizard.2bpp"
CharizardSilhouettePic: ; 0x79080
	INCBIN "gfx/billboard/mon_silhouettes/charizard.2bpp"
SquirtlePic: ; 0x79200
	INCBIN "gfx/billboard/mon_pics/squirtle.2bpp"
SquirtleSilhouettePic:  ; 0x79380
	INCBIN "gfx/billboard/mon_silhouettes/squirtle.2bpp"
WartortlePic: ; 0x79500
	INCBIN "gfx/billboard/mon_pics/wartortle.2bpp"
WartortleSilhouettePic: ; 0x79680
	INCBIN "gfx/billboard/mon_silhouettes/wartortle.2bpp"
BlastoisePic: ; 0x79800
	INCBIN "gfx/billboard/mon_pics/blastoise.2bpp"
BlastoiseSilhouettePic: ; 0x79980
	INCBIN "gfx/billboard/mon_silhouettes/blastoise.2bpp"
CaterpiePic: ; 0x79b00
	INCBIN "gfx/billboard/mon_pics/caterpie.2bpp"
CaterpieSilhouettePic: ; 0x79c80
	INCBIN "gfx/billboard/mon_silhouettes/caterpie.2bpp"
MetapodPic: ; 0x79e00
	INCBIN "gfx/billboard/mon_pics/metapod.2bpp"
MetapodSilhouettePic: ; 0x79f80
	INCBIN "gfx/billboard/mon_silhouettes/metapod.2bpp"
ButterfreePic: ; 0x7a100
	INCBIN "gfx/billboard/mon_pics/butterfree.2bpp"
ButterfreeSilhouettePic: ; 0x7a280
	INCBIN "gfx/billboard/mon_silhouettes/butterfree.2bpp"
WeedlePic: ; 0x7a400
	INCBIN "gfx/billboard/mon_pics/weedle.2bpp"
WeedleSilhouettePic: ; 0x7a580
	INCBIN "gfx/billboard/mon_silhouettes/weedle.2bpp"
KakunaPic: ; 0x7a700
	INCBIN "gfx/billboard/mon_pics/kakuna.2bpp"
KakunaSilhouettePic: ; 0x7a880
	INCBIN "gfx/billboard/mon_silhouettes/kakuna.2bpp"
BeedrillPic: ; 0x7aa00
	INCBIN "gfx/billboard/mon_pics/beedrill.2bpp"
BeedrillSilhouettePic: ; 0x7ab80
	INCBIN "gfx/billboard/mon_silhouettes/beedrill.2bpp"
PidgeyPic: ; 0x7ad00
	INCBIN "gfx/billboard/mon_pics/pidgey.2bpp"
PidgeySilhouettePic: ; 0x7ae80
	INCBIN "gfx/billboard/mon_silhouettes/pidgey.2bpp"

INCBIN "bin/7b000_7bfff.bin" ; 0x7b000


SECTION "bank1f", ROMX, BANK[$1f]

INCBIN "bin/7c000_7ffff.bin" ; 0x7c000


SECTION "bank20", ROMX, BANK[$20]

INCBIN "bin/80000_83fff.bin" ; 0x80000


SECTION "bank21", ROMX, BANK[$21]

INCBIN "bin/84000_87fff.bin" ; 0x84000


SECTION "bank22", ROMX, BANK[$22]

INCBIN "bin/88000_8bfff.bin" ; 0x88000


SECTION "bank23", ROMX, BANK[$23]

INCBIN "bin/8c000_8ffff.bin" ; 0x8c000


SECTION "bank24", ROMX, BANK[$24]

HypnoPic: ; 0x90000
	INCBIN "gfx/billboard/mon_pics/hypno.2bpp"
HypnoSilhouettePic: ; 0x90180
	INCBIN "gfx/billboard/mon_silhouettes/hypno.2bpp"
KrabbyPic: ; 0x90300
	INCBIN "gfx/billboard/mon_pics/krabby.2bpp"
KrabbySilhouettePic: ; 0x90480
	INCBIN "gfx/billboard/mon_silhouettes/krabby.2bpp"
KinglerPic: ; 0x90600
	INCBIN "gfx/billboard/mon_pics/kingler.2bpp"
KinglerSilhouettePic: ; 0x90780
	INCBIN "gfx/billboard/mon_silhouettes/kingler.2bpp"
VoltorbPic: ; 0x90900
	INCBIN "gfx/billboard/mon_pics/voltorb.2bpp"
VoltorbSilhouettePic: ; 0x90a80
	INCBIN "gfx/billboard/mon_silhouettes/voltorb.2bpp"
ElectrodePic: ; 0x90c00
	INCBIN "gfx/billboard/mon_pics/electrode.2bpp"
ElectrodeSilhouettePic: ; 0x90d80
	INCBIN "gfx/billboard/mon_silhouettes/electrode.2bpp"
ExeggcutePic: ; 0x90f00
	INCBIN "gfx/billboard/mon_pics/exeggcute.2bpp"
ExeggcuteSilhouettePic: ; 0x91080
	INCBIN "gfx/billboard/mon_silhouettes/exeggcute.2bpp"
ExeggutorPic: ; 0x91200
	INCBIN "gfx/billboard/mon_pics/exeggutor.2bpp"
ExeggutorSilhouettePic:  ; 0x91380
	INCBIN "gfx/billboard/mon_silhouettes/exeggutor.2bpp"
CubonePic: ; 0x91500
	INCBIN "gfx/billboard/mon_pics/cubone.2bpp"
CuboneSilhouettePic: ; 0x91680
	INCBIN "gfx/billboard/mon_silhouettes/cubone.2bpp"
MarowakPic: ; 0x91800
	INCBIN "gfx/billboard/mon_pics/marowak.2bpp"
MarowakSilhouettePic: ; 0x91980
	INCBIN "gfx/billboard/mon_silhouettes/marowak.2bpp"
HitmonleePic: ; 0x91b00
	INCBIN "gfx/billboard/mon_pics/hitmonlee.2bpp"
HitmonleeSilhouettePic: ; 0x91c80
	INCBIN "gfx/billboard/mon_silhouettes/hitmonlee.2bpp"
HitmonchanPic: ; 0x91e00
	INCBIN "gfx/billboard/mon_pics/hitmonchan.2bpp"
HitmonchanSilhouettePic: ; 0x91f80
	INCBIN "gfx/billboard/mon_silhouettes/hitmonchan.2bpp"
LickitungPic: ; 0x92100
	INCBIN "gfx/billboard/mon_pics/lickitung.2bpp"
LickitungSilhouettePic: ; 0x92280
	INCBIN "gfx/billboard/mon_silhouettes/lickitung.2bpp"
KoffingPic: ; 0x92400
	INCBIN "gfx/billboard/mon_pics/koffing.2bpp"
KoffingSilhouettePic: ; 0x92580
	INCBIN "gfx/billboard/mon_silhouettes/koffing.2bpp"
WeezingPic: ; 0x92700
	INCBIN "gfx/billboard/mon_pics/weezing.2bpp"
WeezingSilhouettePic: ; 0x92880
	INCBIN "gfx/billboard/mon_silhouettes/weezing.2bpp"
RhyhornPic: ; 0x92a00
	INCBIN "gfx/billboard/mon_pics/rhyhorn.2bpp"
RhyhornSilhouettePic: ; 0x92b80
	INCBIN "gfx/billboard/mon_silhouettes/rhyhorn.2bpp"
RhydonPic: ; 0x92d00
	INCBIN "gfx/billboard/mon_pics/rhydon.2bpp"
RhydonSilhouettePic: ; 0x92e80
	INCBIN "gfx/billboard/mon_silhouettes/rhydon.2bpp"

INCBIN "bin/93000_93fff.bin" ; 0x93000


SECTION "bank25", ROMX, BANK[$25]

MagnemitePic: ; 0x94000
	INCBIN "gfx/billboard/mon_pics/magnemite.2bpp"
MagnemiteSilhouettePic: ; 0x94180
	INCBIN "gfx/billboard/mon_silhouettes/magnemite.2bpp"
MagnetonPic: ; 0x94300
	INCBIN "gfx/billboard/mon_pics/magneton.2bpp"
MagnetonSilhouettePic: ; 0x94480
	INCBIN "gfx/billboard/mon_silhouettes/magneton.2bpp"
Farfetch_dPic: ; 0x94600
	INCBIN "gfx/billboard/mon_pics/farfetch_d.2bpp"
Farfetch_dSilhouettePic: ; 0x94780
	INCBIN "gfx/billboard/mon_silhouettes/farfetch_d.2bpp"
DoduoPic: ; 0x94900
	INCBIN "gfx/billboard/mon_pics/doduo.2bpp"
DoduoSilhouettePic: ; 0x94a80
	INCBIN "gfx/billboard/mon_silhouettes/doduo.2bpp"
DodrioPic: ; 0x94c00
	INCBIN "gfx/billboard/mon_pics/dodrio.2bpp"
DodrioSilhouettePic: ; 0x94d80
	INCBIN "gfx/billboard/mon_silhouettes/dodrio.2bpp"
SeelPic: ; 0x94f00
	INCBIN "gfx/billboard/mon_pics/seel.2bpp"
SeelSilhouettePic: ; 0x95080
	INCBIN "gfx/billboard/mon_silhouettes/seel.2bpp"
DewgongPic: ; 0x95200
	INCBIN "gfx/billboard/mon_pics/dewgong.2bpp"
DewgongSilhouettePic:  ; 0x95380
	INCBIN "gfx/billboard/mon_silhouettes/dewgong.2bpp"
GrimerPic: ; 0x95500
	INCBIN "gfx/billboard/mon_pics/grimer.2bpp"
GrimerSilhouettePic: ; 0x95680
	INCBIN "gfx/billboard/mon_silhouettes/grimer.2bpp"
MukPic: ; 0x95800
	INCBIN "gfx/billboard/mon_pics/muk.2bpp"
MukSilhouettePic: ; 0x95980
	INCBIN "gfx/billboard/mon_silhouettes/muk.2bpp"
ShellderPic: ; 0x95b00
	INCBIN "gfx/billboard/mon_pics/shellder.2bpp"
ShellderSilhouettePic: ; 0x95c80
	INCBIN "gfx/billboard/mon_silhouettes/shellder.2bpp"
CloysterPic: ; 0x95e00
	INCBIN "gfx/billboard/mon_pics/cloyster.2bpp"
CloysterSilhouettePic: ; 0x95f80
	INCBIN "gfx/billboard/mon_silhouettes/cloyster.2bpp"
GastlyPic: ; 0x96100
	INCBIN "gfx/billboard/mon_pics/gastly.2bpp"
GastlySilhouettePic: ; 0x96280
	INCBIN "gfx/billboard/mon_silhouettes/gastly.2bpp"
HaunterPic: ; 0x96400
	INCBIN "gfx/billboard/mon_pics/haunter.2bpp"
HaunterSilhouettePic: ; 0x96580
	INCBIN "gfx/billboard/mon_silhouettes/haunter.2bpp"
GengarPic: ; 0x96700
	INCBIN "gfx/billboard/mon_pics/gengar.2bpp"
GengarSilhouettePic: ; 0x96880
	INCBIN "gfx/billboard/mon_silhouettes/gengar.2bpp"
OnixPic: ; 0x96a00
	INCBIN "gfx/billboard/mon_pics/onix.2bpp"
OnixSilhouettePic: ; 0x96b80
	INCBIN "gfx/billboard/mon_silhouettes/onix.2bpp"
DrowzeePic: ; 0x96d00
	INCBIN "gfx/billboard/mon_pics/drowzee.2bpp"
DrowzeeSilhouettePic: ; 0x96e80
	INCBIN "gfx/billboard/mon_silhouettes/drowzee.2bpp"

INCBIN "bin/97000_97fff.bin" ; 0x97000


SECTION "bank26", ROMX, BANK[$26]

AlakazamPic: ; 0x98000
	INCBIN "gfx/billboard/mon_pics/alakazam.2bpp"
AlakazamSilhouettePic: ; 0x98180
	INCBIN "gfx/billboard/mon_silhouettes/alakazam.2bpp"
MachopPic: ; 0x98300
	INCBIN "gfx/billboard/mon_pics/machop.2bpp"
MachopSilhouettePic: ; 0x98480
	INCBIN "gfx/billboard/mon_silhouettes/machop.2bpp"
MachokePic: ; 0x98600
	INCBIN "gfx/billboard/mon_pics/machoke.2bpp"
MachokeSilhouettePic: ; 0x98780
	INCBIN "gfx/billboard/mon_silhouettes/machoke.2bpp"
MachampPic: ; 0x98900
	INCBIN "gfx/billboard/mon_pics/machamp.2bpp"
MachampSilhouettePic: ; 0x98a80
	INCBIN "gfx/billboard/mon_silhouettes/machamp.2bpp"
BellsproutPic: ; 0x98c00
	INCBIN "gfx/billboard/mon_pics/bellsprout.2bpp"
BellsproutSilhouettePic: ; 0x98d80
	INCBIN "gfx/billboard/mon_silhouettes/bellsprout.2bpp"
WeepinbellPic: ; 0x98f00
	INCBIN "gfx/billboard/mon_pics/weepinbell.2bpp"
WeepinbellSilhouettePic: ; 0x97080
	INCBIN "gfx/billboard/mon_silhouettes/weepinbell.2bpp"
VictreebellPic: ; 0x97200
	INCBIN "gfx/billboard/mon_pics/victreebell.2bpp"
VictreebellSilhouettePic:  ; 0x97380
	INCBIN "gfx/billboard/mon_silhouettes/victreebell.2bpp"
TentacoolPic: ; 0x97500
	INCBIN "gfx/billboard/mon_pics/tentacool.2bpp"
TentacoolSilhouettePic: ; 0x97680
	INCBIN "gfx/billboard/mon_silhouettes/tentacool.2bpp"
TentacruelPic: ; 0x97800
	INCBIN "gfx/billboard/mon_pics/tentacruel.2bpp"
TentacruelSilhouettePic: ; 0x97980
	INCBIN "gfx/billboard/mon_silhouettes/tentacruel.2bpp"
GeodudePic: ; 0x97b00
	INCBIN "gfx/billboard/mon_pics/geodude.2bpp"
GeodudeSilhouettePic: ; 0x97c80
	INCBIN "gfx/billboard/mon_silhouettes/geodude.2bpp"
GravelerPic: ; 0x97e00
	INCBIN "gfx/billboard/mon_pics/graveler.2bpp"
GravelerSilhouettePic: ; 0x97f80
	INCBIN "gfx/billboard/mon_silhouettes/graveler.2bpp"
GolemPic: ; 0x9a100
	INCBIN "gfx/billboard/mon_pics/golem.2bpp"
GolemSilhouettePic: ; 0x9a280
	INCBIN "gfx/billboard/mon_silhouettes/golem.2bpp"
PonytaPic: ; 0x9a400
	INCBIN "gfx/billboard/mon_pics/ponyta.2bpp"
PonytaSilhouettePic: ; 0x9a580
	INCBIN "gfx/billboard/mon_silhouettes/ponyta.2bpp"
RapidashPic: ; 0x9a700
	INCBIN "gfx/billboard/mon_pics/rapidash.2bpp"
RapidashSilhouettePic: ; 0x9a880
	INCBIN "gfx/billboard/mon_silhouettes/rapidash.2bpp"
SlowpokePic: ; 0x9aa00
	INCBIN "gfx/billboard/mon_pics/slowpoke.2bpp"
SlowpokeSilhouettePic: ; 0x9ab80
	INCBIN "gfx/billboard/mon_silhouettes/slowpoke.2bpp"
SlowbroPic: ; 0x9ad00
	INCBIN "gfx/billboard/mon_pics/slowbro.2bpp"
SlowbroSilhouettePic: ; 0x9ae80
	INCBIN "gfx/billboard/mon_silhouettes/slowbro.2bpp"

INCBIN "bin/9b000_9bfff.bin" ; 0x9b000


SECTION "bank27", ROMX, BANK[$27]

INCBIN "bin/9c000_9ffff.bin" ; 0x9c000


SECTION "bank28", ROMX, BANK[$28]

INCBIN "bin/a0000_a3fff.bin" ; 0xa0000


SECTION "bank29", ROMX, BANK[$29]

INCBIN "bin/a4000_a5fff.bin" ; 0xa4000

PalletTownPic: ; 0xa6000
	INCBIN "gfx/billboard/maps/pallettown.2bpp"
ViridianCityPic: ; 0xa6180
	INCBIN "gfx/billboard/maps/viridiancity.2bpp"
ViridianForestPic: ; 0xa6300
	INCBIN "gfx/billboard/maps/viridianforest.2bpp"
PewterCityPic: ; 0xa6480
	INCBIN "gfx/billboard/maps/pewtercity.2bpp"
MtMoonPic: ; 0xa6600
	INCBIN "gfx/billboard/maps/mtmoon.2bpp"
CeruleanCityPic: ; 0xa6780
	INCBIN "gfx/billboard/maps/ceruleancity.2bpp"
VermilionCitySeasidePic: ; 0xa6900
	INCBIN "gfx/billboard/maps/vermilioncityseaside.2bpp"
VermilionCityStreetsPic: ; 0xa6a80
	INCBIN "gfx/billboard/maps/vermilioncitystreets.2bpp"
RockMountainPic: ; 0xa6c00
	INCBIN "gfx/billboard/maps/rockmountain.2bpp"
LavenderTownPic: ; 0xa6d80
	INCBIN "gfx/billboard/maps/lavendertown.2bpp"
CeladonCityPic: ; 0xa6f00
	INCBIN "gfx/billboard/maps/celadoncity.2bpp"
CyclingRoadPic: ; 0xa7080
	INCBIN "gfx/billboard/maps/cyclingroad.2bpp"
FuchsiaCityPic: ; 0xa7200
	INCBIN "gfx/billboard/maps/fuchsiacity.2bpp"
SafariZonePic: ; 0xa7380
	INCBIN "gfx/billboard/maps/safarizone.2bpp"
SaffronCityPic: ; 0xa7500
	INCBIN "gfx/billboard/maps/saffroncity.2bpp"
SeafoamIslandsPic: ; 0xa7680
	INCBIN "gfx/billboard/maps/seafoamislands.2bpp"
CinnabarIslandPic: ; 0xa7800
	INCBIN "gfx/billboard/maps/cinnabarisland.2bpp"
IndigoPlateauPic: ; 0xa7980
	INCBIN "gfx/billboard/maps/indigoplateau.2bpp"

INCBIN "bin/a7b00_a7fff.bin" ; 0xa7b00

SECTION "bank2a", ROMX, BANK[$2a]

INCBIN "bin/a8000_abfff.bin" ; 0xa8000


SECTION "bank2b", ROMX, BANK[$2b]

INCBIN "bin/ac000_affff.bin" ; 0xac000


SECTION "bank2c", ROMX, BANK[$2c]

INCBIN "bin/b0000_b3fff.bin" ; 0xb0000


SECTION "bank2d", ROMX, BANK[$2d]

INCBIN "bin/b4000_b7fff.bin" ; 0xb4000


SECTION "bank2e", ROMX, BANK[$2e]

INCBIN "bin/b8000_bbfff.bin" ; 0xb8000


SECTION "bank2f", ROMX, BANK[$2f]

INCBIN "bin/bc000_bffff.bin" ; 0xbc000


SECTION "bank30", ROMX, BANK[$30]

INCBIN "bin/c0000_c3fff.bin" ; 0xc0000


SECTION "bank31", ROMX, BANK[$31]

INCBIN "bin/c4000_c7fff.bin" ; 0xc4000


SECTION "bank32", ROMX, BANK[$32]

INCBIN "bin/c8000_cbfff.bin" ; 0xc8000


SECTION "bank33", ROMX, BANK[$33]

INCBIN "bin/cc000_cffff.bin" ; 0xcc000


SECTION "bank34", ROMX, BANK[$34]

INCBIN "bin/d0000_d3fff.bin" ; 0xd0000


SECTION "bank35", ROMX, BANK[$35]

INCBIN "bin/d4000_d7fff.bin" ; 0xd4000


SECTION "bank36", ROMX, BANK[$36]

INCBIN "bin/d8000_dbfff.bin" ; 0xd8000


SECTION "bank37", ROMX, BANK[$37]

INCBIN "bin/dc000_dffff.bin" ; 0xdc000


SECTION "bank38", ROMX, BANK[$38]

INCBIN "bin/e0000_e3fff.bin" ; 0xe0000


SECTION "bank39", ROMX, BANK[$39]

INCBIN "bin/e4000_e7fff.bin" ; 0xe4000


SECTION "bank3a", ROMX, BANK[$3a]

INCBIN "bin/e8000_ebfff.bin" ; 0xe8000


SECTION "bank3b", ROMX, BANK[$3b]

INCBIN "bin/ec000_effff.bin" ; 0xec000


SECTION "bank3c", ROMX, BANK[$3c]

INCBIN "bin/f0000_f3fff.bin" ; 0xf0000


SECTION "bank3d", ROMX, BANK[$3d]

INCBIN "bin/f4000_f7fff.bin" ; 0xf4000


SECTION "bank3e", ROMX, BANK[$3e]

INCBIN "bin/f8000_fbfff.bin" ; 0xf8000


SECTION "bank3f", ROMX, BANK[$3f]

INCBIN "bin/fc000_fffff.bin" ; 0xfc000

