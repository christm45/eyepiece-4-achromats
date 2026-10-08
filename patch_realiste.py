"""Patch du gabarit : ajoute le mode rendu realiste (reflets, verre physique, ombres, vues). Idempotent."""
import os
here = os.path.dirname(os.path.abspath(__file__))
tpl = os.path.join(here, "page_template.tpl")
s = open(tpl, encoding="utf8").read()
if "id=\"real\"" in s:
    print("deja applique"); raise SystemExit


def rep(a, b):
    global s
    assert a in s, "introuvable : " + a[:70]
    s = s.replace(a, b, 1)


rep("<script>__ORBIT__</script>", "<script>__ORBIT__</script>\n<script>__ROOMENV__</script>")

rep("<h2>Vue 3D</h2>", """<h2>Vue 3D</h2>
  <label class="chk"><input id="real" type="checkbox" checked> Rendu réaliste (reflets, verre, ombres)</label>
  <div class="row"><span>Filament</span><select id="fil" style="grid-column:2/4;background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px"><option value="noir">PLA noir mat</option><option value="gris">PETG gris anthracite</option><option value="blanc">PLA blanc</option><option value="code">Couleurs de repérage</option></select></div>
  <div class="row"><span>Vues</span><div style="grid-column:2/4;display:flex;gap:6px;flex-wrap:wrap"><button class="vb" data-v="face">Face</button><button class="vb" data-v="oeil">Côté œil</button><button class="vb" data-v="tele">Côté télescope</button><button class="vb" data-v="profil">Profil</button></div></div>""")
rep("</style>", ".vb{background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px 9px;cursor:pointer;font-size:12px}.vb:hover{border-color:var(--ac)}</style>")
rep('id="op" type="range" min="0.1" max="1" step="0.05" value="0.55"><output id="opo">0.55</output>',
    'id="op" type="range" min="0.1" max="1" step="0.05" value="0.35"><output id="opo">0.35</output>')

rep("renderer.setPixelRatio(Math.min(devicePixelRatio, 2));",
    "renderer.setPixelRatio(Math.min(devicePixelRatio, 2)); renderer.shadowMap.enabled = true; renderer.shadowMap.type = THREE.PCFSoftShadowMap; renderer.outputEncoding = THREE.sRGBEncoding;")

rep("const clip = new THREE.Plane(new THREE.Vector3(-1, 0, 0), 0);", """const clip = new THREE.Plane(new THREE.Vector3(-1, 0, 0), 0);
dl.castShadow = true; dl.shadow.mapSize.set(2048, 2048); dl.shadow.camera.left = -140; dl.shadow.camera.right = 140; dl.shadow.camera.top = 160; dl.shadow.camera.bottom = -60; dl.shadow.camera.far = 600; dl.shadow.bias = -0.0004; dl.shadow.radius = 4;
const pmrem = new THREE.PMREMGenerator(renderer), envTex = pmrem.fromScene(new THREE.RoomEnvironment(), 0.04).texture;
const floor = new THREE.Mesh(new THREE.CircleGeometry(260, 64), new THREE.MeshStandardMaterial({ color: 0x242a33, roughness: 0.85, metalness: 0 }));
floor.rotation.x = -Math.PI / 2; floor.position.y = -0.05; floor.receiveShadow = true; scene.add(floor);""")

rep("const parts = [];", """function smoothNormals(pos) {      // normales lissees par angle de pli (40 deg) sur le maillage non indexe
  const nt = pos.length / 9, fn = new Float32Array(nt * 3), map = new Map();
  const key = (i) => Math.round(pos[i] * 50) + "," + Math.round(pos[i + 1] * 50) + "," + Math.round(pos[i + 2] * 50);
  for (let t = 0; t < nt; t++) {
    const o = t * 9, ax = pos[o + 3] - pos[o], ay = pos[o + 4] - pos[o + 1], az = pos[o + 5] - pos[o + 2];
    const bx = pos[o + 6] - pos[o], by = pos[o + 7] - pos[o + 1], bz = pos[o + 8] - pos[o + 2];
    fn[t * 3] = ay * bz - az * by; fn[t * 3 + 1] = az * bx - ax * bz; fn[t * 3 + 2] = ax * by - ay * bx;
    for (let v = 0; v < 3; v++) { const k = key(o + v * 3); let a = map.get(k); if (!a) { a = []; map.set(k, a); } a.push(t); }
  }
  const out = new Float32Array(nt * 9), ct = Math.cos(40 * Math.PI / 180);
  for (let t = 0; t < nt; t++) {
    const sx = fn[t * 3], sy = fn[t * 3 + 1], sz = fn[t * 3 + 2], sl = Math.hypot(sx, sy, sz) || 1;
    for (let v = 0; v < 3; v++) {
      let nx = 0, ny = 0, nz = 0;
      for (const u of map.get(key(t * 9 + v * 3))) {
        const ux = fn[u * 3], uy = fn[u * 3 + 1], uz = fn[u * 3 + 2], ul = Math.hypot(ux, uy, uz) || 1;
        if ((sx * ux + sy * uy + sz * uz) / (sl * ul) > ct) { nx += ux; ny += uy; nz += uz; }
      }
      const nl = Math.hypot(nx, ny, nz) || 1; out[t * 9 + v * 3] = nx / nl; out[t * 9 + v * 3 + 1] = ny / nl; out[t * 9 + v * 3 + 2] = nz / nl;
    }
  }
  return out;
}
const FIL = { noir: [0x1e2024, 0.62, 0.0], gris: [0x4a5058, 0.45, 0.1], blanc: [0xe6e6e1, 0.55, 0.0] };
function look(p) {
  const real = $("real").checked, glass = p.glass, c = p.c;
  let m;
  if (!real) m = new THREE.MeshStandardMaterial({ color: c.color, metalness: glass ? 0 : 0.05, roughness: glass ? 0.08 : 0.55, transparent: glass, opacity: glass ? 0.55 : 1, depthWrite: !glass, side: THREE.DoubleSide });
  else if (glass) m = new THREE.MeshPhysicalMaterial({ color: 0xf2ecff, metalness: 0, roughness: 0.03, transmission: 0.65, thickness: 7, ior: 1.52, clearcoat: 1, clearcoatRoughness: 0.02, envMapIntensity: 1.6, side: THREE.DoubleSide });
  else { const f = $("fil").value, a = f === "code" ? [c.color, 0.5, 0.05] : FIL[f]; m = new THREE.MeshStandardMaterial({ color: a[0], roughness: a[1], metalness: a[2], envMapIntensity: 0.9, side: THREE.DoubleSide }); }
  p.mesh.material = m; p.mesh.castShadow = real && !glass; p.mesh.receiveShadow = real && !glass;
}
function applyLook() {
  const real = $("real").checked;
  scene.environment = real ? envTex : null; renderer.toneMapping = real ? THREE.ACESFilmicToneMapping : THREE.NoToneMapping; renderer.toneMappingExposure = 1.05;
  grid.visible = !real; axis.visible = !real; floor.visible = real; renderer.setClearColor(real ? 0x151a21 : 0x10151c);
  scene.children.forEach(o => { if (o.isHemisphereLight) o.intensity = real ? 0.25 : 0.95; });
  parts.forEach(look); applyScene();
}
const parts = [];""")

rep('g.setAttribute("position", new THREE.BufferAttribute(dec(c.pos), 3)); g.computeVertexNormals();',
    'const pa = dec(c.pos); g.setAttribute("position", new THREE.BufferAttribute(pa, 3)); g.setAttribute("normal", new THREE.BufferAttribute(smoothNormals(pa), 3));')
rep("""  const m = new THREE.MeshStandardMaterial({ color: c.color, metalness: glass ? 0 : 0.05, roughness: glass ? 0.08 : 0.55,
    transparent: glass, opacity: glass ? 0.55 : 1, depthWrite: !glass, side: THREE.DoubleSide, clippingPlanes: [] });
  const mesh = new THREE.Mesh(g, m); scene.add(mesh); parts.push({ c, mesh, glass, off: offOf(c.name), on: true });""",
    """  const mesh = new THREE.Mesh(g, new THREE.MeshBasicMaterial()); scene.add(mesh); parts.push({ c, mesh, glass, off: offOf(c.name), on: true });""")
rep("parts.forEach(p => { p.mesh.position.y = p.off * e; p.mesh.material.clippingPlanes = cut ? [clip] : []; if (p.glass) p.mesh.material.opacity = op; });",
    """const real = $("real").checked;
  parts.forEach(p => { p.mesh.position.y = p.off * e; p.mesh.material.clippingPlanes = cut ? [clip] : []; if (p.glass) { if (real) p.mesh.material.transmission = 1 - op; else p.mesh.material.opacity = op; } });""")
rep("function resize()", """$("real").addEventListener("input", applyLook); $("fil").addEventListener("input", applyLook);
const VUES = { face: [190, 110, 210, 0, 50, 0], oeil: [70, 210, 95, 0, 80, 0], tele: [90, -70, 150, 0, 55, 0], profil: [260, 50, 0, 0, 50, 0] };
document.querySelectorAll(".vb").forEach(b => b.addEventListener("click", () => { const v = VUES[b.dataset.v]; cam.position.set(v[0], v[1], v[2]); ctl.target.set(v[3], v[4], v[5]); ctl.update(); }));
function resize()""")
rep("resize(); update(); applyScene();", "resize(); update(); applyLook();")
rep("ctl.update();\n  if ($(\"cut\")", "ctl.update(); floor.visible = $(\"real\").checked && cam.position.y > 0;\n  if ($(\"cut\")")
open(tpl, "w", encoding="utf8").write(s)

mk = os.path.join(here, "make_html.py")
m = open(mk, encoding="utf8").read()
m = m.replace('.replace("__OPTICS__"', '.replace("__ROOMENV__", safe(rd(os.path.join(vendor, "RoomEnvironment.js"))))\n            .replace("__OPTICS__"')
open(mk, "w", encoding="utf8").write(m)
print("patch applique")
