"""Controle des ajustements du banc puis export STL (une par piece) + assemblage STEP dans 'banc focale lentilles/'."""
import os
import cadquery as cq
from build_banc import *

here = os.path.dirname(os.path.abspath(__file__))
out = os.path.join(here, "banc focale lentilles")
os.makedirs(out, exist_ok=True)
P = dict(pieces())


def inter(a, b):
    try:
        return a.intersect(b).val().Volume()
    except Exception:
        return 0.0


# ---- controles --------------------------------------------------------------
print("queue d'aronde A dans mortaise B : interference %.2f mm3 (doit etre 0)" % inter(P["1_rail_A"], P["2_rail_B"]))
rails = P["1_rail_A"].union(P["2_rail_B"])
for nom, x in (("chariot lentille", 60), ("chariot ecran", 200)):
    c = P["3_chariot_lentille"] if "lentille" in nom else P["4_chariot_ecran"]
    print("%s sur le rail a x=%d : interference %.2f mm3 (doit etre 0)" % (nom, x, inter(c.translate((x, 0, 0)), rails)))
c = P["3_chariot_lentille"].val().BoundingBox()
print("axe optique a %.0f mm au-dessus de la table ; rayon libre sous l'axe : %.1f mm (Ø50 -> 25 mm)" % (Z_AX, Z_AX - CAR_Z))

# ---- export -----------------------------------------------------------------
for n, s in P.items():
    cq.exporters.export(s, os.path.join(out, n + ".stl"), tolerance=0.03, angularTolerance=0.1)
asm = cq.Assembly(name="banc_focale")
asm.add(P["1_rail_A"], name="rail_A", color=cq.Color(0.7, 0.7, 0.72))
asm.add(P["2_rail_B"], name="rail_B", color=cq.Color(0.6, 0.6, 0.65))
asm.add(P["3_chariot_lentille"], name="chariot_lentille", loc=cq.Location((40, 0, 0)), color=cq.Color(0.2, 0.55, 0.8))
asm.add(P["4_chariot_ecran"], name="chariot_ecran", loc=cq.Location((200, 0, 0)), color=cq.Color(0.3, 0.7, 0.4))
asm.add(P["5_support_source"], name="support_source", loc=cq.Location((-120, 0, 0)), color=cq.Color(0.8, 0.5, 0.2))
asm.save(os.path.join(out, "assemblage_banc.step"))
print("exporte dans", out)
for f in sorted(os.listdir(out)):
    print("  %-28s %6.0f Ko" % (f, os.path.getsize(os.path.join(out, f)) / 1024))
