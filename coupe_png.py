"""Coupe XZ exacte (plan y=0) de l'assemblage -> coupe.png ; verifie aussi contacts/interferences base <-> coiffe."""
import numpy as np, cadquery as cq
import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt
from build_oculaire import composants, base, coiffe
cs = composants()
step = 0.25
rs = np.arange(-32, 32.01, step); zs = np.arange(0, 90.01, step)
img = np.ones((len(zs), len(rs), 3))
for c in cs:
    col = [(c["color"] >> 16 & 255) / 255, (c["color"] >> 8 & 255) / 255, (c["color"] & 255) / 255]
    s = c["shape"].val()
    bb = s.BoundingBox()
    for i, z in enumerate(zs):
        if z < bb.zmin or z > bb.zmax: continue
        for j, r in enumerate(rs):
            if abs(r) > bb.xmax + 0.1: continue
            if s.isInside(cq.Vector(r, 0, z), 1e-4): img[i, j] = col
fig, ax = plt.subplots(figsize=(6, 9))
ax.imshow(img, origin="lower", extent=[rs[0], rs[-1], zs[0], zs[-1]], interpolation="nearest")
ax.set_aspect("equal"); ax.set_xlabel("mm"); ax.set_ylabel("z (mm)")
ax.axhline(73, color="k", lw=0.5, ls=":"); ax.text(-31, 73.5, "haut de la base z=73", fontsize=7)
fig.savefig("coupe.png", dpi=110, bbox_inches="tight")
b, c = base().val(), coiffe().val()
print("interference base/coiffe (mm3):", round(b.intersect(c).Volume(), 3))
