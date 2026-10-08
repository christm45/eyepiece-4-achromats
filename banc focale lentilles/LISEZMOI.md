# Banc de mesure de la focale des achromats

Pièces (STL, une impression chacune) : `1_rail_A`, `2_rail_B`, `3_chariot_lentille`, `4_chariot_ecran`, `5_support_source`.
`assemblage_banc.step` montre l'ensemble. Le rail fait 2 × 160 mm ; les deux moitiés s'emboîtent par une queue d'aronde (jeu 0,35 mm) :
graduation de 0 à 305 mm, un trait par mm (plus long tous les 5 et 10 mm), chiffres tous les 50 mm.

## Principe
Une source **lointaine** (au moins 2 m : fenêtre éloignée, LED au bout de la pièce, lampe) est imagée par la lentille sur un écran
(papier sulfurisé / calque) qui coulisse sur le rail. On lit où l'image est nette, puis :

    f = u·v / (u + v)

`u` = distance source → lentille au mètre ruban ; `v` = distance lentille → écran. Avec u = 3 m, sans correction l'erreur serait de 5 %
sur une focale de 160 mm : c'est pourquoi la formule est obligatoire.

## Montage
1. Imprimez les 5 pièces (chariots : posez-les sur leur face de glissement ouverte vers le bas avec supports, ou retournés ; vérifiez que le rail coulisse avant de l'utiliser, au besoin poncez ou changez `JEU`).
2. Emboîtez le rail B dans le rail A par la queue d'aronde. Posez le tout sur une table.
3. Chariot lentille : la lentille se pose dans le logement étagé **depuis l'avant (côté source)** ; elle s'appuie sur un épaulement :
   Ø50 → épaulement 1, Ø40 → épaulement 2, Ø30 → épaulement 3. Serrez-la par la tranche avec une vis **M3 en nylon** (2 trous M3 sur le dessus, à tarauder).
   Orientez l'achromat comme il l'était dans les jumelles (côté objet vers la source) ; la focale ne dépend pas du sens, mais l'image est plus nette ainsi.
4. Chariot écran : glissez une bande de papier sulfurisé dans la fente du haut (c'est le plan de mesure).
5. Support source : LED 5 mm dans le logement arrière, masque (trou d'épingle dans du papier alu, ou petite croix) dans la fente.
   Ou utilisez simplement un objet lointain très contrasté. La source doit être à l'axe de la lentille.

## Lecture
Chaque chariot a une **fenêtre de lecture** de 10 × 23 mm au-dessus de la voie graduée, avec un **fil repère** de 0,8 mm : on lit le trait qui est sous le fil ; les chiffres sont gravés tous les 10 mm et visibles dans la fenêtre (traits tous les mm, plus longs à 5 et 10 mm). Regardez de dessus, à la verticale, pour éviter la parallaxe.
- Chariot lentille : le fil repère est 11,5 / 8,5 / 5,5 mm derrière la face arrière de la lentille (Ø50 / Ø40 / Ø30).
- Chariot écran : le fil repère est 8,0 mm derrière le plan du papier.
Notez la lecture du chariot lentille, déplacez l'écran jusqu'à l'image la plus nette (petit point lumineux), notez sa lecture, puis :

    python mesure_focale.py 40 60 225 3000 8

(Ø40, lectures 60 et 225, source à 3000 mm, épaisseur de la lentille 8 mm). Le script donne BFD, v et f.

## Précision et pièges
- Lecture à ±0,5 mm sur chaque trait : f à ±1 mm. Le plan principal d'un achromat épais est supposé au milieu de son épaisseur : jusqu'à ~2 mm d'écart possible.
- Pour une meilleure précision : mesurez **deux fois**, la lentille retournée, et prenez la moyenne.
- Un achromat de jumelle est corrigé pour une source lointaine et un faisceau étroit : travaillez à pleine ouverture mais cherchez l'image la plus petite, pas la plus lumineuse.
- Des focales jusqu'à ~280 mm tiennent sur le rail (305 mm). Au-delà, rallongez en ajoutant un segment.
- Pour une **paire** (les deux achromats face à face), mesurez-la montée comme dans l'oculaire (écart entre les lentilles = celui de l'oculaire) : sa focale est ≈ f/2.
- Les trois jeux et dimensions sont dans `build_banc.py` (`JEU`, `RAIL_SEG`, `STEPS`) si votre imprimante demande un autre réglage.
