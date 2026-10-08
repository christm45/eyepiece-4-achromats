"""Tessele les pieces du banc -> banc_meshes.json (repere three.js : x rail, Y haut = Z CAD, Z = -Y CAD)."""
import json, base64, struct, os
from build_banc import pieces, Z_AX, CAR_Z, RAIL_H, X_IDX_LENS, X_IDX_SCREEN, T_POST, STEPS, MASK_X, LED_SEAT_X
here = os.path.dirname(os.path.abspath(__file__))
COL = {"1_rail_A": (0x4f6d8c, "Rail A (segment avec queue d'aronde)"), "2_rail_B": (0x6f8fb0, "Rail B (segment avec mortaise)"),
       "3_chariot_lentille": (0x1f6fb5, "Chariot porte-lentille"), "4_chariot_ecran": (0x16a085, "Chariot écran (calque)"),
       "5_support_source": (0xf08a24, "Support source LED + masque")}
enc = lambda pos: base64.b64encode(struct.pack("<%df" % len(pos), *pos)).decode()
out = []
for name, sh in pieces():
    verts, tris = sh.val().tessellate(0.05, 0.2)
    pos = []
    for t in tris:
        for i in t:
            v = verts[i]; pos += [v.x, v.z, -v.y]
    out.append({"id": name, "name": COL[name][1], "color": COL[name][0], "n": len(pos) // 3, "pos": enc(pos)})
meta = {"zax": Z_AX, "idxL": X_IDX_LENS, "idxS": X_IDX_SCREEN, "post": T_POST, "steps": STEPS, "maskX": MASK_X, "ledSeat": LED_SEAT_X}
json.dump({"parts": out, "meta": meta}, open(os.path.join(here, "banc_meshes.json"), "w"))
print("pieces:", len(out), "triangles:", sum(p["n"] for p in out) // 3, " %.2f Mo" % (os.path.getsize(os.path.join(here, "banc_meshes.json")) / 1e6))
