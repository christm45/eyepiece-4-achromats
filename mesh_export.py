"""Tessele les pieces -> meshes.json (positions float32 en base64, repere three.js : Y vers le haut = Z CAD)."""
import json, base64, struct, os
from build_oculaire import composants, stack

here = os.path.dirname(os.path.abspath(__file__))


def enc(pos):
    return base64.b64encode(struct.pack("<%df" % len(pos), *pos)).decode()


out = []
for c in composants():
    verts, tris = c["shape"].val().tessellate(0.04, 0.12)
    pos = []
    for (a, b, d) in tris:
        for idx in (a, b, d):
            v = verts[idx]
            pos += [v.x, v.z, -v.y]
    out.append({"name": c["name"], "group": c["group"], "color": c["color"], "kind": c["kind"],
                "n": len(pos) // 3, "pos": enc(pos)})
json.dump({"stack": stack(), "comps": out}, open(os.path.join(here, "meshes.json"), "w"))
print("composants:", len(out), " triangles:", sum(c["n"] for c in out) // 3,
      " json: %.2f Mo" % (os.path.getsize(os.path.join(here, "meshes.json")) / 1e6))
