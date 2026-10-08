"""Oeilletons d'ESSAI a imprimer : un par dégagement d'oeil (24 = optique libre, 20, 17, 14 ; mesure depuis la derniere surface de verre). On regarde avec chacun et on garde
celui qui donne le meilleur compromis champ / confort. Un petit creux par rang sur le dessus n'est pas necessaire : le nom du fichier suffit."""
import os
import cadquery as cq
from build_oculaire import oeilleton

here = os.path.dirname(os.path.abspath(__file__))
out = os.path.join(here, "essais_oeilleton")
os.makedirs(out, exist_ok=True)
for er in (24, 20, 17, 14):
    sh = oeilleton(er)
    bb = sh.val().BoundingBox()
    cq.exporters.export(sh, os.path.join(out, "oeilleton_degagement_%dmm.stl" % er), tolerance=0.03, angularTolerance=0.1)
    print("oeilleton %2d mm : hauteur %.1f mm, Ø%.0f, volume %.0f mm3" % (er, bb.zmax - bb.zmin, bb.xmax - bb.xmin, sh.val().Volume()))
