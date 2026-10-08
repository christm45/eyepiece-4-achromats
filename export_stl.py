"""Exporte en STL les pieces a imprimer de l'oculaire (dossier stl_oculaire/). Necessite CadQuery."""
import os
import cadquery as cq
from build_oculaire import composants

here = os.path.dirname(os.path.abspath(__file__))
out = os.path.join(here, "stl_oculaire")
os.makedirs(out, exist_ok=True)
for c in composants():
    if c["kind"] != "print":
        continue
    nom = c["name"].replace(" ", "_").replace("\u00d8", "D").replace("'", "").replace(",", "_").replace("(", "").replace(")", "")
    cq.exporters.export(c["shape"], os.path.join(out, nom + ".stl"), tolerance=0.02, angularTolerance=0.1)
    print("%-45s -> %s.stl" % (c["name"], nom))
